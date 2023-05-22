package dto

type Pageable struct {
	Offset uint `query:"offset" json:"offset"`
	Limit  uint `query:"limit" json:"limit"`
}

type PageableWithSearch struct {
	Pageable
	Search string `query:"search" json:"search"`
}

type Pagination struct {
	Total int64 `json:"total"`
	Size  int   `json:"size"`
	Pageable
}

type Paging[T any] struct {
	Pagination
	Data []T `json:"data"`
}

// Migrate to v1.8 use type parameter instead of interface
func ReplyPage[T any](data []T, pageable Pageable, total int64) *Paging[T] {
	return &Paging[T]{
		Pagination: Pagination{
			Pageable: pageable,
			Size:     len(data),
			Total:    total,
		},
		Data: data,
	}
}
