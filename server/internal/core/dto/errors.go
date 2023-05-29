package dto

import "net/http"

type ErrorMessage struct {
	Message string `json:"message"`
}
type ErrorReply struct {
	Error ErrorMessage `json:"error"`
}

func ReplyError(message string) ErrorReply {
	return ErrorReply{
		Error: ErrorMessage{
			Message: message,
		},
	}
}

type StatusReply struct {
	Status interface{} `json:"status"`
}

func ReplyStatus(status int) *StatusReply {
	return &StatusReply{Status: http.StatusText(status)}
}
