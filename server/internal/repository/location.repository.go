package repository

import (
	"context"
	"errors"

	"github.com/KunlanatP/idcard-reader-server/internal/core/domain"
	"github.com/KunlanatP/idcard-reader-server/internal/core/errs"
	"github.com/KunlanatP/idcard-reader-server/internal/repository/entities"
	"gorm.io/gorm"
)

type LocationRepository interface {
	CreateLocation(ctx context.Context, data *domain.Location) (*domain.Location, error)
	FindLocationByID(ctx context.Context, id string) (*domain.Location, error)
	DeleteLocationByID(ctx context.Context, id string) error
}

func WithGormLocationRepository(db *gorm.DB) LocationRepository {
	return &locationRepository{db}
}

type locationRepository struct {
	db *gorm.DB
}

func (r *locationRepository) CreateLocation(ctx context.Context, data *domain.Location) (*domain.Location, error) {
	creater := entities.Location{
		Latitude:  data.Latitude,
		Longitude: data.Longitude,
		UserID:    data.UserID,
		PeopleID:  data.PeopleID,
	}
	if err := r.db.Create(&creater).Error; err != nil {
		return nil, err
	}
	return creater.ToDomain(), nil
}

func (r *locationRepository) FindLocationByID(ctx context.Context, id string) (*domain.Location, error) {
	location := &entities.Location{}
	if err := r.db.First(location, "id=?", id).Error; err != nil {
		if errors.Is(gorm.ErrRecordNotFound, err) {
			return nil, errs.ErrLocationNotFound
		}
	}
	return location.ToDomain(), nil
}

func (r *locationRepository) DeleteLocationByID(ctx context.Context, id string) error {
	return r.db.Transaction(func(tx *gorm.DB) error {
		if err := tx.Delete(&entities.Location{}, "id=?", id).Error; err != nil {
			return err
		}
		return nil
	})
}
