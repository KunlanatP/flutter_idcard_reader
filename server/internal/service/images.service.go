package service

import (
	"context"
	"fmt"
	"log"
	"mime/multipart"
	"os"
	"path/filepath"

	"github.com/KunlanatP/idcard-reader-server/internal/core/config"
	"github.com/KunlanatP/idcard-reader-server/internal/core/domain"
	"github.com/KunlanatP/idcard-reader-server/internal/core/dto"
	"github.com/KunlanatP/idcard-reader-server/internal/core/errs"
	"github.com/KunlanatP/idcard-reader-server/internal/core/utils"
	"github.com/KunlanatP/idcard-reader-server/internal/repository"
	"github.com/gofiber/fiber/v2"
	"github.com/google/uuid"
)

type ImageService interface {
	CreateImage(ctx *fiber.Ctx, query dto.QueryUserAndPerson, file *multipart.FileHeader) (*domain.Image, error)
	GetByteOfImageFileById(ctx context.Context, id string) ([]byte, error)
	GetImageById(ctx context.Context, id string) (*domain.Image, error)
}

func ImageServiceImpl(
	userRepo repository.UserRepository,
	peopleRepo repository.PeopleRepository,
	imageRepo repository.ImageRepository,
) ImageService {
	return &imageServiceImpl{
		userRepo:   userRepo,
		peopleRepo: peopleRepo,
		imageRepo:  imageRepo,
	}
}

type imageServiceImpl struct {
	userRepo   repository.UserRepository
	peopleRepo repository.PeopleRepository
	imageRepo  repository.ImageRepository
}

func (s *imageServiceImpl) CreateImage(ctx *fiber.Ctx, query dto.QueryUserAndPerson, file *multipart.FileHeader) (*domain.Image, error) {
	if _, err := s.userRepo.FindUserByID(ctx.Context(), query.UserID); err != nil {
		return nil, err
	}
	if _, err := s.peopleRepo.FindPeopleByID(ctx.Context(), query.PeopleID); err != nil {
		return nil, err
	}

	dirPath := filepath.Join(
		config.Default.THAID_HOME,
		utils.SplitID(query.UserID),
		utils.SplitID(query.PeopleID),
	)

	fullPath := filepath.Join(config.Default.LOCAL_PATH, dirPath)
	if err := utils.ValidateDirectory(fullPath); err != nil {
		log.Fatal(err)
	}

	name, extension := utils.GetFileNameExtension(file.Filename)
	name = uuid.NewString()
	if err := ctx.SaveFile(file, fmt.Sprintf("%s/%s%s", fullPath, name, extension)); err != nil {
		return nil, err
	}

	return s.imageRepo.CreateImage(ctx.Context(), domain.Image{
		OriginName: name + extension,
		Extension:  extension,
		Reference:  dirPath,
		Size:       file.Size,
		UserID:     query.UserID,
		PeopleID:   query.PeopleID,
	})
}

func (s *imageServiceImpl) GetByteOfImageFileById(ctx context.Context, id string) ([]byte, error) {
	if len(id) == 0 {
		return nil, errs.ErrImageIDIsRequired
	}
	data, err := s.imageRepo.FindImageByID(ctx, id)
	if err != nil {
		return nil, err
	}
	pathImage := filepath.Join(
		config.Default.LOCAL_PATH,
		data.Reference,
		data.OriginName,
	)
	reader, err := os.ReadFile(pathImage)
	if err != nil {
		return nil, err
	}
	return reader, nil
}

func (s *imageServiceImpl) GetImageById(ctx context.Context, id string) (*domain.Image, error) {
	if len(id) == 0 {
		return nil, errs.ErrImageIDIsRequired
	}
	return s.imageRepo.FindImageByID(ctx, id)
}
