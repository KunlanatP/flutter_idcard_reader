package entities

import (
	"github.com/KunlanatP/idcard-reader-server/internal/core/domain"
	"github.com/KunlanatP/idcard-reader-server/internal/repository/entities/base"
)

type People struct {
	base.Model
	NationID    string `json:"nationID" gorm:"index:idx_nationID,unique"`
	TitleTH     string `json:"titleTH"`
	FirstnameTH string `json:"firstnameTH"`
	LastnameTH  string `json:"lastnameTH"`
	TitleEN     string `json:"titleEN"`
	FirstnameEN string `json:"firstnameEN"`
	LastnameEN  string `json:"lastnameEN"`
	Address     string `json:"address"`
	Birthdate   string `json:"birthdate"`
	IssueDate   string `json:"issueDate"`
	ExpireDate  string `json:"expireDate"`
	Gender      int    `json:"gender"`
	ImageUrl    string `json:"imageUrl"`
	Mobile      string `json:"mobile"`
	UserID      string `json:"userId"`
}

func (p *People) ToDomain() *domain.PeopleOutput {
	return &domain.PeopleOutput{
		ID:          p.ID,
		NationID:    p.NationID,
		TitleTH:     p.TitleTH,
		FirstnameTH: p.FirstnameTH,
		LastnameTH:  p.LastnameTH,
		TitleEN:     p.TitleEN,
		FirstnameEN: p.FirstnameEN,
		LastnameEN:  p.LastnameEN,
		Address:     p.Address,
		Birthdate:   p.Birthdate,
		IssueDate:   p.IssueDate,
		ExpireDate:  p.ExpireDate,
		Gender:      p.Gender,
		Mobile:      p.Mobile,
		ImageUrl:       p.ImageUrl,
		UserID:      p.UserID,
	}
}
