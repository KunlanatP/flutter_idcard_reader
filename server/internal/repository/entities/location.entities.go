package entities

import (
	"github.com/KunlanatP/idcard-reader-server/internal/core/domain"
	"github.com/KunlanatP/idcard-reader-server/internal/repository/entities/base"
)

type Location struct {
	base.Model
	Latitude  float64 `json:"latitude"`
	Longitude float64 `json:"longitude"`
	UserID    string  `json:"userId"`
	User      User    `json:"-"`
	PeopleID  string  `json:"peopleId"`
	People    People  `json:"-"`
}

func (l *Location) ToDomain() *domain.Location {
	return &domain.Location{
		ID:        l.ID,
		Latitude:  l.Latitude,
		Longitude: l.Longitude,
		PeopleID:  l.PeopleID,
		UserID:    l.UserID,
	}
}
