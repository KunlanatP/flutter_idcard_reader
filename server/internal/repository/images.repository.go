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
	CreateImageProfile(ctx context.Context, data *domain.Image) (*domain.Image, error)
	CreateImages(ctx context.Context, datas []domain.Image) (out []domain.Image, err error)
	FindImageByID(ctx context.Context, id string) (*domain.Image, error)
	FindImageProfileByID(ctx context.Context, id string) (*domain.Image, error)
	DeleteImagesByID(ctx context.Context, id string) error
}

func WithGormImageRepository(db *gorm.DB) ImageRepository {
	return &imageRepository{db}
}

type imageRepository struct {
	db *gorm.DB
}

func (r *imageRepository) CreateImageProfile(ctx context.Context, data *domain.Image) (*domain.Image, error) {
	creater := entities.ImageProfile{
		OriginName: data.OriginName,
		Size:       data.Size,
		Reference:  data.Reference,
		Extension:  data.Extension,
		UserID:     data.UserID,
		PeopleID:   data.PeopleID,
	}
	if err := r.db.Create(&creater).Error; err != nil {
		return nil, err
	}
	return creater.ToDomain(), nil
}

func (r *imageRepository) CreateImages(ctx context.Context, datas []domain.Image) (out []domain.Image, err error) {
	for _, data := range datas {
		create := &entities.Images{
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
		out = append(out, *create.ToDomain())
	}
	return
}

func (r *imageRepository) FindImageByID(ctx context.Context, id string) (*domain.Image, error) {
	image := &entities.Images{}
	if err := r.db.First(image, "id=?", id).Error; err != nil {
		if errors.Is(gorm.ErrRecordNotFound, err) {
			return nil, errs.ErrImageNotFound
		}
	}
	return image.ToDomain(), nil
}

func (r *imageRepository) FindImageProfileByID(ctx context.Context, id string) (*domain.Image, error) {
	image := &entities.ImageProfile{}
	if err := r.db.First(image, "id=?", id).Error; err != nil {
		if errors.Is(gorm.ErrRecordNotFound, err) {
			return nil, errs.ErrImageNotFound
		}
	}
	return image.ToDomain(), nil
}

func (r *imageRepository) DeleteImagesByID(ctx context.Context, id string) error {
	return r.db.Transaction(func(tx *gorm.DB) error {
		if err := tx.Delete(&entities.Images{}, "id=?", id).Error; err != nil {
			return err
		}
		return nil
	})
}
