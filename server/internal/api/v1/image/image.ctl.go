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
	imagesRoute.Get("/images/read/:id", ctl.GetImageById)
	imagesRoute.Get("/images/:id", ctl.GetByteOfImageFileById)
	imagesRoute.Get("/images/profiles/:id", ctl.GetByteOfImageProfileFileById)

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

	file, err := ctx.MultipartForm()
	if err != nil {
		return err
	}
	data, err := r.svc.CreateImage(ctx, query, file)
	if err != nil {
		return err
	}

	return ctx.Status(fiber.StatusCreated).JSON(data)
}

func (r *imageCtl) GetByteOfImageFileById(ctx *fiber.Ctx) (err error) {
	id := ctx.Params("id")
	images, err := r.svc.GetByteOfImageFileById(ctx.Context(), id)
	if err != nil {
		return err
	}
	ctx.Set("Content-Type", "image/png")
	return ctx.Status(fiber.StatusOK).Send(images)
}

func (r *imageCtl) GetByteOfImageProfileFileById(ctx *fiber.Ctx) (err error) {
	id := ctx.Params("id")
	images, err := r.svc.GetByteOfImageProfileFileById(ctx.Context(), id)
	if err != nil {
		return err
	}
	ctx.Set("Content-Type", "image/png")
	return ctx.Status(fiber.StatusOK).Send(images)
}

func (r *imageCtl) GetImageById(ctx *fiber.Ctx) (err error) {
	id := ctx.Params("id")
	data, err := r.svc.GetImageById(ctx.Context(), id)
	if err != nil {
		return err
	}
	return ctx.Status(fiber.StatusCreated).JSON(data)
}
