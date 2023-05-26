package repository

import (
	"context"
	"errors"

	"github.com/KunlanatP/idcard-reader-server/internal/core/domain"
	"github.com/KunlanatP/idcard-reader-server/internal/core/errs"
	"github.com/KunlanatP/idcard-reader-server/internal/repository/entities"
	"gorm.io/gorm"
)

type ImageRepository interface {
	CreateImage(ctx context.Context, data domain.Image) (*domain.Image, error)
	FindImageByID(ctx context.Context, id string) (*domain.Image, error)
}

func WithGormImageRepository(db *gorm.DB) ImageRepository {
	return &imageRepository{db}
}

type imageRepository struct {
	db *gorm.DB
}

func (r *imageRepository) CreateImage(ctx context.Context, data domain.Image) (*domain.Image, error) {
	create := &entities.Image{
		OriginName: data.OriginName,
		Size:       data.Size,
		Reference:  data.Reference,
		Extension:  data.Extension,
		UserID:     data.UserID,
		PeopleID:   data.PeopleID,
	}
	if err := r.db.Create(create).Error; err != nil {
		return nil, err
	}
	return create.ToDomain(), nil
}

func (r *imageRepository) FindImageByID(ctx context.Context, id string) (*domain.Image, error) {
	image := &entities.Image{}
	if err := r.db.First(image, "id=?", id).Error; err != nil {
		if errors.Is(gorm.ErrRecordNotFound, err) {
			return nil, errs.ErrImageNotFound
		}
	}
	return image.ToDomain(), nil
}
