package service

import (
	"context"

	"github.com/KunlanatP/idcard-reader-server/internal/api/v1/user/model"
	"github.com/KunlanatP/idcard-reader-server/internal/core/domain"
	"github.com/KunlanatP/idcard-reader-server/internal/core/dto"
	"github.com/KunlanatP/idcard-reader-server/internal/core/errs"
	"github.com/KunlanatP/idcard-reader-server/internal/core/validate"
	"github.com/KunlanatP/idcard-reader-server/internal/repository"
)

type UserService interface {
	Search(ctx context.Context, paging dto.PageableWithSearch) (*dto.Paging[domain.User], error)
	CreateUser(ctx context.Context, data *model.CreateUserDTO) (*domain.User, error)
	UserLogin(ctx context.Context, data model.QueryUser) (*domain.User, error)
}

func UserServiceImpl(userRepo repository.UserRepository) UserService {
	return &userServiceImpl{
		userRepo: userRepo,
	}
}

type userServiceImpl struct {
	userRepo repository.UserRepository
}

func (s *userServiceImpl) Search(ctx context.Context, paging dto.PageableWithSearch) (*dto.Paging[domain.User], error) {
	data, err := s.userRepo.FindUserByName(ctx, paging.Pageable, paging.Search)
	if err != nil {
		return nil, err
	}
	total, err := s.userRepo.CountUserByName(ctx, paging.Search)
	if err != nil {
		return nil, err
	}
	return dto.ReplyPage(data, paging.Pageable, total), nil
}

func (s *userServiceImpl) CreateUser(ctx context.Context, data *model.CreateUserDTO) (*domain.User, error) {
	if err := validate.ValidS(data); err != nil {
		return nil, err
	}
	create := &domain.User{
		IdCard:      data.IdCard,
		Firstname:   data.Firstname,
		Lastname:    data.Lastname,
		Mobile:      data.Mobile,
		Email:       data.Email,
		Rank:        data.Rank,
		Affiliation: data.Affiliation,
		Status:      data.Status,
	}
	return s.userRepo.CreateUser(ctx, create)
}

func (s *userServiceImpl) UserLogin(ctx context.Context, data model.QueryUser) (*domain.User, error) {
	if err := validate.ValidS(data); err != nil {
		return nil, err
	}

	if len(data.IdCard) == 0 {
		return nil, errs.ErrIDCardIsRequired
	}

	if len(data.Mobile) == 0 {
		return nil, errs.ErrMobileIsRequired
	}

	return s.userRepo.FindUserByIdCardAndMobile(ctx, data)
}
