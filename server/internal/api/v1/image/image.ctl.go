package image

import (
	"github.com/KunlanatP/idcard-reader-server/internal/core/dto"
	"github.com/KunlanatP/idcard-reader-server/internal/core/errs"
	"github.com/KunlanatP/idcard-reader-server/internal/service"
	"github.com/gofiber/fiber/v2"
)

func ImageController(serv service.ImageService) *fiber.App {
	imagesRoute := fiber.New(fiber.Config{ErrorHandler: errs.FiberErrorHandler()})
	ctl := imageCtl{svc: serv}

	// imagesRoute.Get("/images", ctl.GetAllUsers)
	imagesRoute.Post("/images", ctl.CreateImage)

	return imagesRoute
}

type imageCtl struct {
	svc service.ImageService
}

// func (r *imageCtl) GetAllUsers(ctx *fiber.Ctx) (err error) {
// 	return ctx.Status(fiber.StatusOK).JSON("Hello")
// }

func (r *imageCtl) CreateImage(ctx *fiber.Ctx) (err error) {
	query := dto.QueryUserAndPerson{}
	ctx.QueryParser(&query)

	file, err := ctx.FormFile("image")
	if err != nil {
		return err
	}
	data, err := r.svc.CreateImage(ctx, query, file)
	if err != nil {
		return err
	}

	return ctx.Status(fiber.StatusCreated).JSON(data)
}
