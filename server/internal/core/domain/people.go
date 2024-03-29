package domain

type People struct {
	UserID       string        `json:"userId"`
	PeopleData   *PeopleData   `json:"personData"`
	LocationData *LocationData `json:"location"`
}

type PeopleData struct {
	NationID    string `json:"nationID"`
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
}

type LocationData struct {
	Latitude  float64 `json:"latitude"`
	Longitude float64 `json:"longitude"`
}

type PeopleOutput struct {
	ID          string `json:"id"`
	NationID    string `json:"nationID"`
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
	Mobile      string `json:"mobile"`
	ImageUrl    string `json:"imageUrl"`
	UserID      string `json:"userId"`
}
