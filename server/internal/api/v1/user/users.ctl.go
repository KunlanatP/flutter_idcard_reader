package user

import (
	"net/http"

	"github.com/KunlanatP/idcard-reader-server/internal/api/v1/user/model"
	"github.com/KunlanatP/idcard-reader-server/internal/core/dto"
	"github.com/KunlanatP/idcard-reader-server/internal/core/errs"
	"github.com/KunlanatP/idcard-reader-server/internal/service"
	"github.com/gofiber/fiber/v2"
)

func UserController(serv service.UserService) *fiber.App {
	usersRoute := fiber.New(fiber.Config{ErrorHandler: errs.FiberErrorHandler()})
	ctl := userCtl{svc: serv}

	usersRoute.Get("/users", ctl.GetAllUsers)
	usersRoute.Post("/users", ctl.CreateUser)
	usersRoute.Get("/users/login", ctl.UserLogin)
	usersRoute.Get("/users/:idcard", ctl.GetUserByIdCard)

	return usersRoute
}

type userCtl struct {
	svc service.UserService
}

func (r *userCtl) GetAllUsers(ctx *fiber.Ctx) (err error) {
	paging := dto.PageableWithSearch{}
	ctx.QueryParser(&paging)
	data, err := r.svc.Search(ctx.Context(), paging)
	if err != nil {
		return err
	}
	return ctx.Status(http.StatusOK).JSON(data)
}

func (r *userCtl) CreateUser(ctx *fiber.Ctx) (err error) {
	body := model.CreateUserDTO{}
	if err = ctx.BodyParser(&body); err != nil {
		return errs.Invalid()
	}
	data, err := r.svc.CreateUser(ctx.Context(), &body)
	if err != nil {
		return err
	}
	return ctx.Status(fiber.StatusOK).JSON(data)
}

func (r *userCtl) UserLogin(ctx *fiber.Ctx) (err error) {
	query := dto.QueryUser{}
	ctx.QueryParser(&query)
	data, err := r.svc.UserLogin(ctx.Context(), query)
	if err != nil {
		return err
	}
	return ctx.Status(fiber.StatusOK).JSON(data)
}

func (r *userCtl) GetUserByIdCard(ctx *fiber.Ctx) (err error) {
	idcard := ctx.Params("idcard")
	data, err := r.svc.GetUserByIdCard(ctx.Context(), idcard)
	if err != nil {
		return err
	}
	return ctx.Status(http.StatusOK).JSON(data)
}
