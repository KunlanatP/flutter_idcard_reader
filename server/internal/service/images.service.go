package service

import (
	"fmt"
	"mime/multipart"

	"github.com/KunlanatP/idcard-reader-server/internal/core/domain"
	"github.com/KunlanatP/idcard-reader-server/internal/core/dto"
	"github.com/KunlanatP/idcard-reader-server/internal/repository"
	"github.com/gofiber/fiber/v2"
)

type ImageService interface {
	CreateImage(ctx *fiber.Ctx, query dto.QueryUserAndPerson, file *multipart.FileHeader) (*domain.Image, error)
}

func ImageServiceImpl(
	// userRepo repository.UserRepository,
	// personRepo repository.PersonRepository,
	imageRepo repository.ImageRepository,
) ImageService {
	return &imageServiceImpl{
		// userRepo:   userRepo,
		// personRepo: personRepo,
		imageRepo: imageRepo,
	}
}

type imageServiceImpl struct {
	// userRepo   repository.UserRepository
	// personRepo repository.PersonRepository
	imageRepo repository.ImageRepository
}

func (s *imageServiceImpl) CreateImage(ctx *fiber.Ctx, query dto.QueryUserAndPerson, file *multipart.FileHeader) (*domain.Image, error) {
	// if _, err := s.userRepo.FindUserByID(ctx.Context(), query.UserID); err != nil {
	// 	return nil, err
	// }
	// if _, err := s.personRepo.FindPersonByID(ctx.Context(), query.UserID); err != nil {
	// 	return nil, err
	// }
	fmt.Println(file)
	return nil, nil
}
