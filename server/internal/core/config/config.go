package config

import (
	"log"

	"github.com/caarlos0/env/v6"
	"github.com/joho/godotenv"
)

type Config struct {
	DB_URL      string `env:"DB_URL,required"`
	DB_MAX_POOL int    `env:"DB_MAX_POOL,required" envDefault:"50"`
	LOCAL_PATH  string `env:"LOCAL_PATH"`
	THAID_HOME  string `env:"THAID_HOME"`
	BACKEND_URL string `env:"BACKEND_URL"`
}

// Default use to share config same instance without parse
var Default = Config{}

func init() {
	log.Println("Load init configuration")

	if err := godotenv.Load(".env"); err != nil {
		log.Fatal("Error loading .env file", err)
	}
	if err := env.Parse(&Default); err != nil {
		log.Fatal("Error parsing config env", err)
	}
}
