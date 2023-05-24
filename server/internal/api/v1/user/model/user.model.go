package model

type CreateUserDTO struct {
	IdCard    string `json:"idCard" validate:"required"`
	Firstname string `json:"firstname" validate:"required"`
	Lastname  string `json:"lastname" validate:"required"`
	Mobile    string `json:"mobile" validate:"required,min=10,max=10"`
	Email     string `json:"email" validate:"required"`
	// Image       string `json:"image" validate:"required"`
	Rank        string `json:"rank" validate:"required"`
	Affiliation string `json:"affiliation" validate:"required"`
	Status      string `json:"status" validate:"required"`
}
