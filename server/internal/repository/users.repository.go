package repository

import (
	"context"
	"errors"

	"github.com/KunlanatP/idcard-reader-server/internal/core/domain"
	"github.com/KunlanatP/idcard-reader-server/internal/core/dto"
	"github.com/KunlanatP/idcard-reader-server/internal/core/errs"
	"github.com/KunlanatP/idcard-reader-server/internal/repository/entities"
	"gorm.io/gorm"
)

type UserRepository interface {
	FindUserByID(ctx context.Context, id string) (*domain.User, error)
	FindUserByName(ctx context.Context, paging dto.Pageable, name string) ([]domain.User, error)
	CountUserByName(ctx context.Context, name string) (count int64, err error)
	CreateUser(ctx context.Context, data *domain.User) (*domain.User, error)
	FindUserByIdCardAndMobile(ctx context.Context, query dto.QueryUser) (*domain.User, error)
	FindUserByIdCard(ctx context.Context, idCard string) (*domain.User, error)
	DeleteUserByID(ctx context.Context, id string) error
}

func WithGormUserRepository(db *gorm.DB) UserRepository {
	return &userRepository{db}
}

type userRepository struct {
	db *gorm.DB
}

func (r *userRepository) FindUserByID(ctx context.Context, id string) (*domain.User, error) {
	user := &entities.User{}
	if err := r.db.First(user, "id=?", id).Error; err != nil {
		if errors.Is(gorm.ErrRecordNotFound, err) {
			return nil, errs.ErrUserNotFound
		}
	}
	return user.ToDomain(), nil
}

func (r *userRepository) FindUserByName(ctx context.Context, paging dto.Pageable, name string) (users []domain.User, err error) {
	qry := r.db.Model(&entities.User{})
	if len(name) > 0 {
		qry.Where("firstname like ?", "%"+name+"%")
	}
	qry.Offset(int(paging.Offset)).Limit(int(paging.Limit)).Find(&users)
	return users, nil
}

func (r *userRepository) CountUserByName(ctx context.Context, name string) (count int64, err error) {
	qry := r.db.Model(&entities.User{})
	if len(name) > 0 {
		qry.Where("firstname like ?", "%"+name+"%")
	}
	if err = qry.Count(&count).Error; err != nil {
		return 0, err
	}
	return count, nil
}

func (r *userRepository) CreateUser(ctx context.Context, data *domain.User) (*domain.User, error) {
	creater := entities.User{
		IdCard:      data.IdCard,
		Firstname:   data.Firstname,
		Lastname:    data.Lastname,
		Mobile:      data.Mobile,
		Email:       data.Email,
		Rank:        data.Rank,
		Affiliation: data.Affiliation,
		Status:      data.Status,
	}

	if err := r.db.Create(&creater).Error; err != nil {
		return nil, err
	}
	return creater.ToDomain(), nil
}

func (r *userRepository) FindUserByIdCardAndMobile(ctx context.Context, query dto.QueryUser) (*domain.User, error) {
	user := &entities.User{}
	if err := r.db.First(user, "id_card=? AND mobile=?", query.IdCard, query.Mobile).Error; err != nil {
		if errors.Is(gorm.ErrRecordNotFound, err) {
			return nil, errs.ErrIDCardIsRequired
		}
	}
	return user.ToDomain(), nil
}

func (r *userRepository) FindUserByIdCard(ctx context.Context, idCard string) (*domain.User, error) {
	user := &entities.User{}
	if err := r.db.First(user, "id_card=?", idCard).Error; err != nil {
		if errors.Is(gorm.ErrRecordNotFound, err) {
			return nil, errs.ErrIDCardIsRequired
		}
	}
	return user.ToDomain(), nil
}

func (r *userRepository) DeleteUserByID(ctx context.Context, id string) error {
	return r.db.Transaction(func(tx *gorm.DB) error {
		if err := tx.Delete(&entities.User{}, "id=?", id).Error; err != nil {
			return err
		}
		return nil
	})
}
