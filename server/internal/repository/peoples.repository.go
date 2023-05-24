package repository

import (
	"context"

	"github.com/KunlanatP/idcard-reader-server/internal/core/domain"
	"github.com/KunlanatP/idcard-reader-server/internal/repository/entities"
	"gorm.io/gorm"
)

type PeopleRepository interface {
	CreatePeople(ctx context.Context, data *domain.People) (*domain.PeopleOutput, error)
}

func WithGormPeopleRepository(db *gorm.DB) PeopleRepository {
	return &peopleRepository{db}
}

type peopleRepository struct {
	db *gorm.DB
}

func (r *peopleRepository) CreatePeople(ctx context.Context, data *domain.People) (*domain.PeopleOutput, error) {
	creater := entities.People{
		NationID:     data.PeopleData.NationID,
		TitleTH:      data.PeopleData.TitleTH,
		FirstnameTH:  data.PeopleData.FirstnameTH,
		LastnameTH:   data.PeopleData.LastnameTH,
		TitleEN:      data.PeopleData.TitleEN,
		FirstnameEN:  data.PeopleData.FirstnameEN,
		LastnameEN:   data.PeopleData.LastnameEN,
		Address:      data.PeopleData.Address,
		Birthdate:    data.PeopleData.Birthdate,
		IssueDate:    data.PeopleData.IssueDate,
		ExpireDate:   data.PeopleData.ExpireDate,
		Gender:       data.PeopleData.Gender,
		PhotoID:      "PhotoID",
		Mobile:       data.PeopleData.Mobile,
		UserNationID: data.UserNationID,
	}

	if err := r.db.Create(&creater).Error; err != nil {
		return nil, err
	}
	return creater.ToDomain(), nil
}
