package base

import (
	"time"

	"github.com/KunlanatP/idcard-reader-server/internal/core/errs"
	"github.com/google/uuid"
	"gorm.io/gorm"
)

type Model struct {
	ID        string         `json:"id" gorm:"primary_key"`
	CreatedAt time.Time      `json:"createdAt"`
	UpdatedAt time.Time      `json:"updatedAt"`
	DeletedAt gorm.DeletedAt `json:"-" gorm:"index"`
}

func (m *Model) BeforeCreate(tx *gorm.DB) (err error) {
	if m.ID != "" {
		err = errs.ErrInvalidRequestToSave
		return
	}
	m.ID = uuid.NewString()
	return
}
