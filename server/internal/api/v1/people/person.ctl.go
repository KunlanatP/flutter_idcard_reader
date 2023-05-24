package people

import (
	"github.com/KunlanatP/idcard-reader-server/internal/api/v1/people/model"
	"github.com/KunlanatP/idcard-reader-server/internal/core/errs"
	"github.com/KunlanatP/idcard-reader-server/internal/service"
	"github.com/gofiber/fiber/v2"
)

func PeopleController(serv service.PeopleService) *fiber.App {
	peopleRoute := fiber.New(fiber.Config{ErrorHandler: errs.FiberErrorHandler()})
	ctl := imageCtl{svc: serv}

	// peopleRoute.Get("/peoples", ctl.GetAllUsers)
	peopleRoute.Post("/peoples", ctl.CreatePeople)

	return peopleRoute
}

type imageCtl struct {
	svc service.PeopleService
}

// func (r *imageCtl) GetAllUsers(ctx *fiber.Ctx) (err error) {
// 	return ctx.Status(fiber.StatusOK).JSON("Hello")
// }

func (r *imageCtl) CreatePeople(ctx *fiber.Ctx) (err error) {
	body := model.CreatePeopleDTO{}
	if err = ctx.BodyParser(&body); err != nil {
		return errs.Invalid()
	}
	data, err := r.svc.CreatePeople(ctx.Context(), &body)
	if err != nil {
		return err
	}
	return ctx.Status(fiber.StatusOK).JSON(data)
}
