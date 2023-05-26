package service

import (
	"context"
	"fmt"
	"path/filepath"
	"time"

	"github.com/KunlanatP/idcard-reader-server/internal/api/v1/people/model"
	"github.com/KunlanatP/idcard-reader-server/internal/core/config"
	"github.com/KunlanatP/idcard-reader-server/internal/core/domain"
	"github.com/KunlanatP/idcard-reader-server/internal/core/utils"
	"github.com/KunlanatP/idcard-reader-server/internal/core/validate"
	"github.com/KunlanatP/idcard-reader-server/internal/repository"
)

type PeopleService interface {
	CreatePeople(ctx context.Context, data *model.CreatePeopleDTO) (*domain.PeopleOutput, error)
}

func PeopleServiceImpl(
	userRepo repository.UserRepository,
	peopleRepo repository.PeopleRepository,
	imageRepo repository.ImageRepository,
) PeopleService {
	return &peopleServiceImpl{
		userRepo:   userRepo,
		peopleRepo: peopleRepo,
		imageRepo:  imageRepo,
	}
}

type peopleServiceImpl struct {
	userRepo   repository.UserRepository
	peopleRepo repository.PeopleRepository
	imageRepo  repository.ImageRepository
}

func (s *peopleServiceImpl) CreatePeople(ctx context.Context, data *model.CreatePeopleDTO) (*domain.PeopleOutput, error) {
	if err := validate.ValidS(data); err != nil {
		return nil, err
	}

	user, err := s.userRepo.FindUserByIdCard(ctx, data.UserNationID)
	if err != nil {
		return nil, err
	}

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

	_location := &domain.Location{
		Latitude:  data.Location.Latitude,
		Longitude: data.Location.Longitude,
	}

	create := &domain.People{
		UserID:     user.ID,
		PeopleData: _peopleData,
		Location:   _location,
	}

	people, err := s.peopleRepo.CreatePeople(ctx, create)
	if err != nil {
		return nil, err
	}

	if len(data.PeopleData.Photo) > 0 {
		dirPath := filepath.Join(
			config.Default.THAID_HOME,
			utils.SplitID(user.ID),
			utils.SplitID(people.ID),
		)
		base64 := data.PeopleData.Photo
		now := time.Now()
		resImage := utils.Base64toPng(base64, dirPath, "profile-"+now.Format("20060201-15:04:05"), "jpeg")

		img, err := s.imageRepo.CreateImage(ctx, []domain.Image{{
			OriginName: resImage.OriginName,
			Extension:  resImage.Extension,
			Reference:  resImage.Reference,
			UserID:     user.ID,
			PeopleID:   people.ID,
		}})
		if err != nil {
			return nil, err
		}

		backendUrl := config.Default.BACKEND_URL
		_imageUrl := fmt.Sprintf("%s/images/%s", backendUrl, img[0].ID)

		return s.peopleRepo.UpdatePeopleByID(ctx, people.ID, &domain.PeopleData{
			ImageUrl: _imageUrl,
		})
	}

	return people, nil
}
