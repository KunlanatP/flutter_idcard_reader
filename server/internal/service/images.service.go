package service

import (
	"fmt"
	"mime/multipart"

	"github.com/KunlanatP/idcard-reader-server/internal/core/domain"
	"github.com/KunlanatP/idcard-reader-server/internal/repository"
	"github.com/gofiber/fiber/v2"
)

type ImageService interface {
	CreateImage(ctx *fiber.Ctx, file *multipart.FileHeader) (*domain.Image, error)
}

func ImageServiceImpl(imageRepo repository.ImageRepository) ImageService {
	return &imageServiceImpl{
		imageRepo: imageRepo,
	}
}

type imageServiceImpl struct {
	imageRepo repository.ImageRepository
}

func (s *imageServiceImpl) CreateImage(ctx *fiber.Ctx, file *multipart.FileHeader) (*domain.Image, error) {
	fmt.Println(file)
	return nil, nil
}
