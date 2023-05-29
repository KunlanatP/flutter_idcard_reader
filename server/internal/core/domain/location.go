package domain

type Location struct {
	ID        string  `json:"id"`
	Latitude  float64 `json:"latitude"`
	Longitude float64 `json:"longitude"`
	PeopleID  string  `json:"peopleId"`
	UserID    string  `json:"userId"`
}
