package people

import (
	"github.com/KunlanatP/idcard-reader-server/internal/api/v1/people/model"
	"github.com/KunlanatP/idcard-reader-server/internal/core/dto"
	"github.com/KunlanatP/idcard-reader-server/internal/core/errs"
	"github.com/KunlanatP/idcard-reader-server/internal/service"
	"github.com/gofiber/fiber/v2"
)

func PeopleController(serv service.PeopleService) *fiber.App {
	peopleRoute := fiber.New(fiber.Config{ErrorHandler: errs.FiberErrorHandler()})
	ctl := peopleCtl{svc: serv}

	peopleRoute.Post("/peoples", ctl.CreatePeople)
	peopleRoute.Patch("/peoples/:idcard", ctl.UpdatePeopleByIDCard)
	peopleRoute.Delete("/peoples/:id", ctl.DeletePeopleByID)

	// peopleRoute.Get("/peoples", ctl.Seatch)
	// peopleRoute.Patch("/peoples/:id", ctl.GetPeopleByID)

	return peopleRoute
}

type peopleCtl struct {
	svc service.PeopleService
}

func (r *peopleCtl) CreatePeople(ctx *fiber.Ctx) (err error) {
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

func (r *peopleCtl) UpdatePeopleByIDCard(ctx *fiber.Ctx) (err error) {
	idcard := ctx.Params("idcard")
	body := model.UpdatePeopleDTO{}
	if err = ctx.BodyParser(&body); err != nil {
		return errs.Invalid()
	}
	data, err := r.svc.UpdatePeopleByIDCard(ctx.Context(), idcard, &body)
	if err != nil {
		return err
	}
	return ctx.Status(fiber.StatusOK).JSON(data)
}

func (r *peopleCtl) DeletePeopleByID(ctx *fiber.Ctx) (err error) {
	id := ctx.Params("id")
	if err := r.svc.DeletePeopleByID(ctx.Context(), id); err != nil {
		return err
	}
	return ctx.Status(fiber.StatusOK).JSON(dto.ReplyStatus(fiber.StatusOK))
}
