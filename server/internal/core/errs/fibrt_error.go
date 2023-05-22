package errs

import (
	"github.com/KunlanatP/idcard-reader-server/internal/core/log"
	"github.com/gofiber/fiber/v2"
	"github.com/KunlanatP/idcard-reader-server/internal/core/dto"
)

func FiberErrorHandler() fiber.ErrorHandler {
	return func(c *fiber.Ctx, err error) error {
		if fiberError, ok := err.(*fiber.Error); ok {
			return c.Status(fiberError.Code).JSON(dto.ReplyError(err.Error()))
		}
		if appError, ok := err.(*Error); ok {
			return c.Status(appError.Code).JSON(appError.ToReply())
		}
		log.Errorf("[AppError]: %v", err)
		return c.Status(fiber.StatusInternalServerError).JSON(dto.ReplyError(UnkownErrorMessage))
	}
}
