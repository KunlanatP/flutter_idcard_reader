package domain

type User struct {
	ID        string `json:"id" gorm:"type:varchar"`
	IdCard    string `json:"idCard" gorm:"type:varchar"`
	Firstname string `json:"firstname" gorm:"type:varchar"`
	Lastname  string `json:"lastname" gorm:"type:varchar"`
	Mobile    string `json:"mobile" gorm:"type:varchar"`
	Email     string `json:"email" gorm:"type:varchar"`
	// Image       string `json:"image" gorm:"type:varchar"`
	Rank        string `json:"rank" gorm:"type:varchar"`
	Affiliation string `json:"affiliation" gorm:"type:varchar"`
	Status      string `json:"status" gorm:"type:varchar"`
}
