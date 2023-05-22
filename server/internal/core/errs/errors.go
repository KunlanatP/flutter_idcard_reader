package errs

import (
	"net/http"

	"github.com/KunlanatP/idcard-reader-server/internal/core/dto"
)

// UnkownErrorMessage default use with 500 error was not expected
const UnkownErrorMessage string = "unkown error"

type Error struct {
	Code    int    `json:"code" example:"500"`
	Message string `json:"message" example:"Unknown error"`
}

func (app *Error) Error() string {
	return app.Message
}

func (app *Error) ToReply() *dto.ErrorReply {
	return &dto.ErrorReply{
		Error: dto.ErrorMessage{
			Message: app.Message,
		},
	}
}

func newError(code int, message []string) *Error {
	var msg string
	if len(message) > 0 {
		msg = message[0]
	} else {
		msg = http.StatusText(code)
	}
	return &Error{
		Code:    code,
		Message: msg,
	}
}

// var ErrClearHome = Invalid("can't clear isHome.")
// var ErrBuildFileTypeNotFound = Invalid("no build file type found")
// var ErrNoPageFound = Invalid("no page found")
// var ErrPageNotFound = NotFound("page not found")
// var ErrStateParameterNotFound = NotFound("State parameter not found")
// var ErrPageIsEmpty = NotFound("page is empty")
// var ErrPageAlreadyExist = Invalid("page already exist")
// var ErrHomePageNotFound = NotFound("home page not found")
// var ErrNoLatestContentVersion = NoContent("no latest content version")

// var ErrAppNotFound = NotFound("application not found")
// var ErrNoAppFound = Invalid("no app found")
// var ErrNoStateFound = Invalid("no state found")

// var ErrInvalidAppID = Invalid("Invalid app id")
// var ErrInvalidPageID = Invalid("Invalid page id")
// var ErrInvalidContentID = Invalid("Invalid content id")

var ErrIDCardIsRequired = Invalid("ID-Card is required")
var ErrMobileIsRequired = Invalid("Phone number is required")

// var ErrPageIDIsRequired = Invalid("Page id is required")
// var ErrNameIsRequired = Invalid("Name is required")
// var ErrFieldIsRequired = Invalid("This field is required")

var ErrInvalidRequestToSave = Invalid("invalid request to save")

// var ErrIsDirEmpty = Invalid("Dir is empty.")

// var ErrFuncHandlerIDIsRequired = Invalid("Function handler id is required")
// var ErrFuncHandlerNotFound = NotFound("Function handler not found")

// var ErrActionIDIsRequired = Invalid("Action id is required")
var ErrUserNotFound = NotFound("User not found")

// var ErrDuplicateKeyValue = NotFound("duplicate key value violates unique constraint")
