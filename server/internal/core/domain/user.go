package domain

type User struct {
	ID        string `json:"id"`
	IdCard    string `json:"idCard"`
	Firstname string `json:"firstname"`
	Lastname  string `json:"lastname"`
	Mobile    string `json:"mobile"`
	Email     string `json:"email"`
	// Image       string `json:"image"`
	Rank        string `json:"rank"`
	Affiliation string `json:"affiliation"`
	Status      string `json:"status"`
}
