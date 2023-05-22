package repository

import "gorm.io/gorm"

type ImageRepository interface{}

func WithGormImageRepository(db *gorm.DB) ImageRepository {
	return &imageRepository{db}
}

type imageRepository struct {
	db *gorm.DB
}
