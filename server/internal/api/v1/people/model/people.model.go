package model

// {
//     "user_nationID": "123xxxxxxxxxx",
//     "personData": {
//         "nationID": "141xxxxxxxxxx",
//         "titleTH": "น.ส.",
//         "firstnameTH": "กุล...",
//         "lastnameTH": "ปะ....",
//         "titleEN": "Miss",
//         "firstnameEN": "Kuxxxxxx",
//         "lastnameEN": "Paxxxxx",
//         "address": "xxx xxxxx xxxxxx xxxxx",
//         "birthdate": "xxxx-xx-xx",
//         "issueDate": "xxxx-xx-xx",
//         "expireDate": "xxxx-xx-xx",
//         "gender": 2,
//         "photo": "base64",
//         "mobile": "093389xxxx"
//     },
//     "location": {
//         "latitude": 17.0761887,
//         "longitude": 102.9304177
//     }
// }

type CreatePeopleDTO struct {
	UserNationID string     `json:"userNationID" validate:"required"`
	PeopleData   PeopleData `json:"personData" validate:"required"`
	Location     Location   `json:"location" validate:"required"`
}

type PeopleData struct {
	NationID    string `json:"nationID" validate:"required"`
	TitleTH     string `json:"titleTH" validate:"required"`
	FirstnameTH string `json:"firstnameTH" validate:"required"`
	LastnameTH  string `json:"lastnameTH" validate:"required"`
	TitleEN     string `json:"titleEN" validate:"required"`
	FirstnameEN string `json:"firstnameEN" validate:"required"`
	LastnameEN  string `json:"lastnameEN" validate:"required"`
	Address     string `json:"address" validate:"required"`
	Birthdate   string `json:"birthdate" validate:"required"`
	IssueDate   string `json:"issueDate" validate:"required"`
	ExpireDate  string `json:"expireDate" validate:"required"`
	Gender      int    `json:"gender" validate:"required"`
	Photo       string `json:"photo" validate:"omitempty"`
	Mobile      string `json:"mobile" validate:"required"`
}

type Location struct {
	Latitude  float64 `json:"latitude" validate:"required"`
	Longitude float64 `json:"longitude" validate:"required"`
}

type ImageDTO struct {
	OriginName string `json:"name" validate:"required,min=5,max=100"`
	Extension  string `json:"extension" validate:"required"`
	Reference  string `json:"reference" validate:"required"`
}
