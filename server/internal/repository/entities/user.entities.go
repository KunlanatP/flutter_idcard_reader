package entities

import (
	"github.com/KunlanatP/idcard-reader-server/internal/core/domain"
	"github.com/KunlanatP/idcard-reader-server/internal/repository/entities/base"
)

type User struct {
	base.Model
	IdCard    string `json:"idCard" gorm:"index:idx_name,unique"`
	Firstname string `json:"firstname" gorm:"type:varchar"`
	Lastname  string `json:"lastname" gorm:"type:varchar"`
	Mobile    string `json:"mobile" gorm:"type:varchar"`
	Email     string `json:"email" gorm:"type:varchar"`
	// Image       string `json:"image" gorm:"type:varchar"`
	Rank        string `json:"rank" gorm:"type:varchar"`
	Affiliation string `json:"affiliation" gorm:"type:varchar"`
	Status      string `json:"status" gorm:"type:varchar"`
}

func (u *User) ToDomain() *domain.User {
	return &domain.User{
		ID:        u.ID,
		IdCard:    u.IdCard,
		Firstname: u.Firstname,
		Lastname:  u.Lastname,
		Mobile:    u.Mobile,
		Email:     u.Email,
		// Image:       u.Image,
		Rank:        u.Rank,
		Affiliation: u.Affiliation,
		Status:      u.Status,
	}
}
