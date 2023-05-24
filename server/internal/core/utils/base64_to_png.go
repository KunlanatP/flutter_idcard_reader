package utils

import (
	"encoding/base64"
	"fmt"
	"image"
	"image/png"
	"log"
	"os"
	"path/filepath"
	"strings"

	"github.com/KunlanatP/idcard-reader-server/internal/api/v1/people/model"
	"github.com/KunlanatP/idcard-reader-server/internal/core/config"
)

func Base64toPng(data string, appId string) (out *model.ImageDTO) {
	reader := base64.NewDecoder(base64.StdEncoding, strings.NewReader(data))
	m, formatString, err := image.Decode(reader)
	if err != nil {
		log.Fatal(err)
	}
	bounds := m.Bounds()
	fmt.Println(bounds, formatString)

	fullPath := filepath.Join(config.Default.LOCAL_PATH, config.Default.IMAGE_PATH)

	if err := ValidateDirectory(fullPath); err != nil {
		log.Fatal(err)
	}

	//Encode from image format to writer
	pngFilename := filepath.Join(fullPath, "default.png")
	f, err := os.OpenFile(pngFilename, os.O_WRONLY|os.O_CREATE, 0777)
	if err != nil {
		log.Fatal(err)
		return
	}

	err = png.Encode(f, m)
	if err != nil {
		log.Fatal(err)
		return
	}

	created := &model.ImageDTO{
		OriginName: "default.png",
		Reference:  config.Default.IMAGE_PATH,
		Extension:  "png",
	}
	return created
}
