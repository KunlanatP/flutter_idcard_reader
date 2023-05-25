package service

import (
	"context"
	"encoding/json"
	"fmt"
	"path/filepath"

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
) PeopleService {
	return &peopleServiceImpl{
		userRepo:   userRepo,
		peopleRepo: peopleRepo,
	}
}

type peopleServiceImpl struct {
	userRepo   repository.UserRepository
	peopleRepo repository.PeopleRepository
}

func (s *peopleServiceImpl) CreatePeople(ctx context.Context, data *model.CreatePeopleDTO) (*domain.PeopleOutput, error) {

	if err := validate.ValidS(data); err != nil {
		return nil, err
	}

	if _, err := s.userRepo.FindUserByIdCard(ctx, data.UserNationID); err != nil {
		return nil, err
	}

	if len(data.PeopleData.Photo) > 0 {
		dirPath := filepath.Join(
			config.Default.LOCAL_PATH,
			config.Default.THAID_HOME,
			data.UserNationID,
			data.PeopleData.NationID,
		)
		base64 := data.PeopleData.Photo
		resImage := utils.Base64toPng(base64, dirPath, "profile-"+data.PeopleData.IssueDate)

		js, _ := json.Marshal(resImage)
		fmt.Println(string(js))

		// _, err = s.imageRepo.CreateImage(ctx, domain.Image{
		// 	OriginName: resImage.OriginName,
		// 	Extension:  resImage.Extension,
		// 	Reference:  resImage.Reference,
		// 	AppID:      res.ID,
		// })
	}

	// _peopleData := &domain.PeopleData{
	// 	NationID:    data.PeopleData.NationID,
	// 	TitleTH:     data.PeopleData.TitleTH,
	// 	FirstnameTH: data.PeopleData.FirstnameTH,
	// 	LastnameTH:  data.PeopleData.LastnameTH,
	// 	TitleEN:     data.PeopleData.TitleEN,
	// 	FirstnameEN: data.PeopleData.FirstnameEN,
	// 	LastnameEN:  data.PeopleData.LastnameEN,
	// 	Address:     data.PeopleData.Address,
	// 	Birthdate:   data.PeopleData.Birthdate,
	// 	IssueDate:   data.PeopleData.IssueDate,
	// 	ExpireDate:  data.PeopleData.ExpireDate,
	// 	Gender:      data.PeopleData.Gender,
	// 	Photo:       "data.PeopleData.Photo",
	// 	Mobile:      data.PeopleData.Mobile,
	// }

	// _location := &domain.Location{
	// 	Latitude:  data.Location.Latitude,
	// 	Longitude: data.Location.Longitude,
	// }

	// create := &domain.People{
	// 	UserNationID: data.UserNationID,
	// 	PeopleData:   _peopleData,
	// 	Location:     _location,
	// }

	// return s.peopleRepo.CreatePeople(ctx, create)
	return nil, nil
}
