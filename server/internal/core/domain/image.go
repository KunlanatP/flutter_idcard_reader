package domain

type Image struct {
	ID         string `json:"id"`
	OriginName string `json:"originName"`
	Size       int64  `json:"size"`
	Extension  string `json:"extension"`
	Reference  string `json:"reference"`
}
