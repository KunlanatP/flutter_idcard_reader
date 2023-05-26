package main

import (
	"fmt"
	"log"
	"os"
	"os/signal"

	"github.com/KunlanatP/idcard-reader-server/internal/api/v1/image"
	"github.com/KunlanatP/idcard-reader-server/internal/api/v1/people"
	"github.com/KunlanatP/idcard-reader-server/internal/api/v1/user"
	"github.com/KunlanatP/idcard-reader-server/internal/core/errs"
	"github.com/KunlanatP/idcard-reader-server/internal/repository"
	"github.com/KunlanatP/idcard-reader-server/internal/repository/migration"
	"github.com/KunlanatP/idcard-reader-server/internal/service"
	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	"github.com/joho/godotenv"
	"github.com/spf13/cobra"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

func init() {
	rootCmd.AddCommand(startCmd)
	startCmd.Flags().Uint16VarP(&port, "port", "p", 8080, "Spacific port to start")
	configEnv()
}

func configEnv() {
	err := godotenv.Load(".env")
	if err != nil {
		log.Fatal("Error loading .env file")
	}
}

var port uint16

var startCmd = &cobra.Command{
	Use:   "start",
	Short: "Start server",
	Long:  `Start server at localhost:8080`,
	Run:   startCommandLine,
}

func startCommandLine(cmd *cobra.Command, args []string) {
	//* prepare connect db
	dsn := os.Getenv("DB_URL")
	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})

	if err != nil {
		log.Fatalf("Can not open DB: %v", err)
	}

	//* auto migrate schema to db
	migration.AutoMigrate(db)

	//* prepare fiber server
	fiberApp := fiber.New(fiber.Config{
		ErrorHandler: errs.FiberErrorHandler(),
	})

	fiberApp.Use(cors.New())

	//* Match any route
	// fiberApp.Use(middleware.AuthenMiddlewear)

	v1Route := fiberApp.Group("/api/v1")

	userRepo := repository.WithGormUserRepository(db)
	peopleRepo := repository.WithGormPeopleRepository(db)
	imageRepo := repository.WithGormImageRepository(db)

	userServ := service.UserServiceImpl(userRepo)
	peopleServ := service.PeopleServiceImpl(userRepo, peopleRepo, imageRepo)
	imageServ := service.ImageServiceImpl(userRepo, peopleRepo, imageRepo)

	v1Route.Mount("/", user.UserController(userServ))
	v1Route.Mount("/", people.PeopleController(peopleServ))
	v1Route.Mount("/", image.ImageController(imageServ))

	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt)

	go func() {
		<-c
		fmt.Println("Gracefully shutting down...")
		_ = fiberApp.Shutdown()
	}()

	log.Println("Starting server")

	if err := fiberApp.Listen(fmt.Sprintf(":%d", port)); err != nil {
		log.Panic(err)
	}

}
