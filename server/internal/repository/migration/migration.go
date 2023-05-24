package migration

import (
	"github.com/KunlanatP/idcard-reader-server/internal/core/log"
	"github.com/KunlanatP/idcard-reader-server/internal/repository/entities"
	"gorm.io/gorm"
)

// AutoMigrate for migrate database schema
func AutoMigrate(db *gorm.DB) {
	if db == nil {
		log.Critical("DB connection can't nill")
	}
	migrateList := []interface{}{
		&entities.User{},
		&entities.People{},
	}
	if err := db.AutoMigrate(migrateList...); err != nil {
		log.Errorf("Can't automigrate schema %v", err)
	}
}
