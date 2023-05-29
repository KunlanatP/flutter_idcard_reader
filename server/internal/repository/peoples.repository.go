package repository

import (
	"context"
	"errors"

	"github.com/KunlanatP/idcard-reader-server/internal/core/domain"
	"github.com/KunlanatP/idcard-reader-server/internal/core/errs"
	"github.com/KunlanatP/idcard-reader-server/internal/core/log"
	"github.com/KunlanatP/idcard-reader-server/internal/repository/entities"
	"gorm.io/gorm"
)

type PeopleRepository interface {
	CreatePeople(ctx context.Context, data *domain.People) (*domain.PeopleOutput, error)
	FindPeopleByID(ctx context.Context, id string) (*domain.PeopleOutput, error)
	GetPeopleByIDCard(ctx context.Context, idcard string) (*domain.PeopleOutput, error)
	UpdatePeopleByID(ctx context.Context, id string, data *domain.PeopleData) (*domain.PeopleOutput, error)
	DeletePeopleByID(ctx context.Context, id string) error
}

func WithGormPeopleRepository(db *gorm.DB) PeopleRepository {
	return &peopleRepository{db}
}

type peopleRepository struct {
	db *gorm.DB
}

func (r *peopleRepository) CreatePeople(ctx context.Context, data *domain.People) (*domain.PeopleOutput, error) {
	creater := entities.People{
		NationID:    data.PeopleData.NationID,
		TitleTH:     data.PeopleData.TitleTH,
		FirstnameTH: data.PeopleData.FirstnameTH,
		LastnameTH:  data.PeopleData.LastnameTH,
		TitleEN:     data.PeopleData.TitleEN,
		FirstnameEN: data.PeopleData.FirstnameEN,
		LastnameEN:  data.PeopleData.LastnameEN,
		Address:     data.PeopleData.Address,
		Birthdate:   data.PeopleData.Birthdate,
		IssueDate:   data.PeopleData.IssueDate,
		ExpireDate:  data.PeopleData.ExpireDate,
		Gender:      data.PeopleData.Gender,
		Mobile:      data.PeopleData.Mobile,
		UserID:      data.UserID,
	}

	if err := r.db.Create(&creater).Error; err != nil {
		return nil, err
	}
	return creater.ToDomain(), nil
}

func (r *peopleRepository) FindPeopleByID(ctx context.Context, id string) (*domain.PeopleOutput, error) {
	people := &entities.People{}
	if err := r.db.First(people, "id=?", id).Error; err != nil {
		if errors.Is(gorm.ErrRecordNotFound, err) {
			return nil, errs.ErrPeopleNotFound
		}
	}
	return people.ToDomain(), nil
}

func (r *peopleRepository) GetPeopleByIDCard(ctx context.Context, idcard string) (*domain.PeopleOutput, error) {
	people := &entities.People{}
	if err := r.db.First(people, "nation_id=?", idcard).Error; err != nil {
		if errors.Is(gorm.ErrRecordNotFound, err) {
			return nil, errs.ErrPeopleNotFound
		}
	}
	return people.ToDomain(), nil
}

func (r *peopleRepository) UpdatePeopleByID(ctx context.Context, id string, data *domain.PeopleData) (*domain.PeopleOutput, error) {
	tx := r.db.Begin()
	updater := entities.People{
		TitleTH:     data.TitleTH,
		FirstnameTH: data.FirstnameTH,
		LastnameTH:  data.LastnameTH,
		TitleEN:     data.TitleEN,
		FirstnameEN: data.FirstnameEN,
		LastnameEN:  data.LastnameEN,
		Address:     data.Address,
		IssueDate:   data.IssueDate,
		ExpireDate:  data.ExpireDate,
		Mobile:      data.Mobile,
		ImageUrl:    data.ImageUrl,
	}
	updated := tx.Model(&updater).Where("id=?", id).Updates(updater)
	if err := updated.Error; err != nil {
		tx.Rollback()
		return nil, err
	}
	if err := tx.First(&updater, "id=?", id).Error; err != nil {
		tx.Rollback()
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, errs.ErrPeopleNotFound
		}
		return nil, err
	}
	tx.Commit()
	log.Debug("updater:id:", updater.ID, updater.ToDomain().ID)
	return updater.ToDomain(), nil
}

func (r *peopleRepository) DeletePeopleByID(ctx context.Context, id string) error {
	return r.db.Transaction(func(tx *gorm.DB) error {
		if err := tx.Delete(&entities.People{}, "id=?", id).Error; err != nil {
			return err
		}
		if err := tx.Delete(&entities.Location{}, "people_id=?", id).Error; err != nil {
			return err
		}
		return nil
	})
}
