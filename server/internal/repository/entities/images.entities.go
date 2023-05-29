package entities

import (
	"github.com/KunlanatP/idcard-reader-server/internal/core/domain"
	"github.com/KunlanatP/idcard-reader-server/internal/repository/entities/base"
)

type Images struct {
	base.Model
	OriginName string `json:"originName"`
	Size       int64  `json:"size"`
	Extension  string `json:"extension"`
	Reference  string `json:"reference"`
	UserID     string `json:"userId"`
	User       User   `json:"-"`
	PeopleID   string `json:"peopleId"`
	People     People `json:"-"`
}

func (i *Images) ToDomain() *domain.Image {
	return &domain.Image{
		ID:         i.ID,
		OriginName: i.OriginName,
		Extension:  i.Extension,
		Reference:  i.Reference,
		Size:       i.Size,
		UserID:     i.UserID,
		PeopleID:   i.PeopleID,
	}
}
