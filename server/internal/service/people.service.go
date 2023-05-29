package service

import (
	"context"
	"fmt"

	"github.com/KunlanatP/idcard-reader-server/internal/api/v1/people/model"
	"github.com/KunlanatP/idcard-reader-server/internal/core/config"
	"github.com/KunlanatP/idcard-reader-server/internal/core/domain"
	"github.com/KunlanatP/idcard-reader-server/internal/core/errs"
	"github.com/KunlanatP/idcard-reader-server/internal/core/utils"
	"github.com/KunlanatP/idcard-reader-server/internal/core/validate"
	"github.com/KunlanatP/idcard-reader-server/internal/repository"
)

type PeopleService interface {
	CreatePeople(ctx context.Context, data *model.CreatePeopleDTO) (*domain.PeopleOutput, error)
	UpdatePeopleByIDCard(ctx context.Context, idcard string, data *model.UpdatePeopleDTO) (*domain.PeopleOutput, error)
	DeletePeopleByID(ctx context.Context, id string) error
}

func PeopleServiceImpl(
	userRepo repository.UserRepository,
	peopleRepo repository.PeopleRepository,
	imageRepo repository.ImageRepository,
	locationRepo repository.LocationRepository,
) PeopleService {
	return &peopleServiceImpl{
		userRepo:     userRepo,
		peopleRepo:   peopleRepo,
		imageRepo:    imageRepo,
		locationRepo: locationRepo,
	}
}

type peopleServiceImpl struct {
	userRepo     repository.UserRepository
	peopleRepo   repository.PeopleRepository
	imageRepo    repository.ImageRepository
	locationRepo repository.LocationRepository
}

func (s *peopleServiceImpl) CreatePeople(ctx context.Context, data *model.CreatePeopleDTO) (*domain.PeopleOutput, error) {
	if err := validate.ValidS(data); err != nil {
		return nil, err
	}

	resUser, err := s.userRepo.FindUserByIdCard(ctx, data.UserNationID)
	if err != nil {
		return nil, err
	}
	resPeople, err := s.peopleRepo.GetPeopleByIDCard(ctx, data.PeopleData.NationID)
	if err != nil {
		_peopleData := &domain.PeopleData{
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
		}

		_location := &domain.LocationData{
			Latitude:  data.Location.Latitude,
			Longitude: data.Location.Longitude,
		}

		create := &domain.People{
			UserID:       resUser.ID,
			PeopleData:   _peopleData,
			LocationData: _location,
		}

		people, err := s.peopleRepo.CreatePeople(ctx, create)
		if err != nil {
			return nil, err
		}

		if len(data.PeopleData.Photo) > 0 {
			resImage := utils.CreateImage(resUser.ID, people.ID, data.PeopleData.Photo)
			img, err := s.imageRepo.CreateImageProfile(ctx, &domain.Image{
				OriginName: resImage.OriginName,
				Extension:  resImage.Extension,
				Reference:  resImage.Reference,
				UserID:     resUser.ID,
				PeopleID:   people.ID,
			})
			if err != nil {
				return nil, err
			}

			backendUrl := config.Default.BACKEND_URL
			_imageUrl := fmt.Sprintf("%s/images/profiles/%s", backendUrl, img.ID)
			return s.peopleRepo.UpdatePeopleByID(ctx, people.ID, &domain.PeopleData{
				ImageUrl: _imageUrl,
			})
		}

		s.locationRepo.CreateLocation(ctx, &domain.Location{
			Latitude:  _location.Latitude,
			Longitude: _location.Longitude,
			PeopleID:  people.ID,
			UserID:    resUser.ID,
		})

		return people, nil
	}

	_imageUrl := resPeople.ImageUrl

	if resPeople.IssueDate != data.PeopleData.IssueDate {
		resImage := utils.CreateImage(resPeople.UserID, resPeople.ID, data.PeopleData.Photo)
		img, err := s.imageRepo.CreateImageProfile(ctx, &domain.Image{
			OriginName: resImage.OriginName,
			Extension:  resImage.Extension,
			Reference:  resImage.Reference,
			UserID:     resPeople.UserID,
			PeopleID:   resPeople.ID,
		})
		if err != nil {
			return nil, err
		}

		s.locationRepo.CreateLocation(ctx, &domain.Location{
			Latitude:  data.Location.Latitude,
			Longitude: data.Location.Longitude,
			PeopleID:  resPeople.ID,
			UserID:    resUser.ID,
		})
		backendUrl := config.Default.BACKEND_URL
		_imageUrl = fmt.Sprintf("%s/images/profiles/%s", backendUrl, img.ID)
	}

	return s.peopleRepo.UpdatePeopleByID(ctx, resPeople.ID, &domain.PeopleData{
		TitleTH:     data.PeopleData.TitleTH,
		FirstnameTH: data.PeopleData.FirstnameTH,
		LastnameTH:  data.PeopleData.LastnameTH,
		TitleEN:     data.PeopleData.TitleEN,
		FirstnameEN: data.PeopleData.FirstnameEN,
		LastnameEN:  data.PeopleData.LastnameEN,
		Address:     data.PeopleData.Address,
		IssueDate:   data.PeopleData.IssueDate,
		ExpireDate:  data.PeopleData.ExpireDate,
		ImageUrl:    _imageUrl,
		Mobile:      data.PeopleData.Mobile,
	})
}

func (s *peopleServiceImpl) UpdatePeopleByIDCard(ctx context.Context, idcard string, data *model.UpdatePeopleDTO) (*domain.PeopleOutput, error) {
	if len(idcard) == 0 {
		return nil, errs.Invalid()
	}
	resPeople, err := s.peopleRepo.GetPeopleByIDCard(ctx, idcard)
	if err != nil {
		return nil, err
	}

	if _, err := s.userRepo.FindUserByID(ctx, resPeople.UserID); err != nil {
		return nil, err
	}
	if err := validate.ValidS(data); err != nil {
		return nil, err
	}

	resImage := utils.CreateImage(resPeople.UserID, resPeople.ID, data.Photo)
	img, err := s.imageRepo.CreateImageProfile(ctx, &domain.Image{
		OriginName: resImage.OriginName,
		Extension:  resImage.Extension,
		Reference:  resImage.Reference,
		UserID:     resPeople.UserID,
		PeopleID:   resPeople.ID,
	})
	if err != nil {
		return nil, err
	}

	backendUrl := config.Default.BACKEND_URL
	_imageUrl := fmt.Sprintf("%s/images/profiles/%s", backendUrl, img.ID)
	return s.peopleRepo.UpdatePeopleByID(ctx, resPeople.ID, &domain.PeopleData{
		TitleTH:     data.TitleTH,
		FirstnameTH: data.FirstnameTH,
		LastnameTH:  data.LastnameTH,
		TitleEN:     data.TitleEN,
		FirstnameEN: data.FirstnameEN,
		LastnameEN:  data.LastnameEN,
		Address:     data.Address,
		IssueDate:   data.IssueDate,
		ExpireDate:  data.ExpireDate,
		ImageUrl:    _imageUrl,
		Mobile:      data.Mobile,
	})
}

func (s *peopleServiceImpl) DeletePeopleByID(ctx context.Context, id string) error {
	if len(id) == 0 {
		return errs.Invalid()
	}
	return s.peopleRepo.DeletePeopleByID(ctx, id)
}
