package domain

type People struct {
	UserNationID string      `json:"user_nationID"`
	PeopleData   *PeopleData `json:"personData"`
	Location     *Location   `json:"location"`
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
	Photo       string `json:"photo"`
	Mobile      string `json:"mobile"`
}

type Location struct {
	Latitude  float64 `json:"latitude"`
	Longitude float64 `json:"longitude"`
}

type PeopleOutput struct {
	ID           string `json:"id"`
	NationID     string `json:"nationID"`
	TitleTH      string `json:"titleTH"`
	FirstnameTH  string `json:"firstnameTH"`
	LastnameTH   string `json:"lastnameTH"`
	TitleEN      string `json:"titleEN"`
	FirstnameEN  string `json:"firstnameEN"`
	LastnameEN   string `json:"lastnameEN"`
	Address      string `json:"address"`
	Birthdate    string `json:"birthdate"`
	IssueDate    string `json:"issueDate"`
	ExpireDate   string `json:"expireDate"`
	Gender       int    `json:"gender"`
	Mobile       string `json:"mobile"`
	UserNationID string `json:"user_nationID"`
}
