package middleware

import (
	"github.com/gofiber/fiber/v2"
)

func AuthenMiddlewear(c *fiber.Ctx) error {
	authen := c.Get("Authorization")
	if authen == "" || authen != "Bearer xox" {
		return fiber.ErrUnauthorized
	}

	return c.Next()
}
