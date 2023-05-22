package validate

import (
	"fmt"

	"github.com/KunlanatP/idcard-reader-server/internal/core/errs"
	"github.com/go-playground/validator/v10"
)

var validate = validator.New()

func ValidS(s interface{}) error {
	if err := validate.Struct(s); err != nil {
		if validErr, ok := err.(validator.ValidationErrors); ok {
			return errs.Invalid(fmt.Sprintf(`%s is invalid`, validErr[0].Field()))
		}
	}
	return nil
}
