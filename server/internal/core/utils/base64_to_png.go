package utils

import (
	"encoding/base64"
	"fmt"
	"image"
	"image/jpeg"
	"image/png"
	"log"
	"os"
	"path/filepath"
	"strings"

	"github.com/KunlanatP/idcard-reader-server/internal/api/v1/people/model"
	"github.com/KunlanatP/idcard-reader-server/internal/core/config"
	"github.com/google/uuid"
)

func CreateImage(userID, peopleID, base64 string) (resImage *model.ImageDTO) {
	dirPath := filepath.Join(
		config.Default.THAID_HOME,
		SplitID(userID),
		SplitID(peopleID),
	)
	return Base64toPng(base64, dirPath, uuid.NewString(), "jpeg")
}

func Base64toPng(data, dirPath, filename, extension string) (out *model.ImageDTO) {
	fullPath := filepath.Join(
		config.Default.LOCAL_PATH,
		dirPath,
	)
	reader := base64.NewDecoder(base64.StdEncoding, strings.NewReader(data))

	var img image.Image
	var err error

	switch extension {

	case "jpeg":
		img, err = jpeg.Decode(reader)
	default:
		img, err = png.Decode(reader)
	}

	if err != nil {
		log.Fatal(err)
	}

	if err := ValidateDirectory(fullPath); err != nil {
		log.Fatal(err)
	}

	//Encode from image format to writer
	originName := fmt.Sprintf("%s.%s", filename, extension)
	pngFilename := filepath.Join(fullPath, originName)
	f, err := os.OpenFile(pngFilename, os.O_WRONLY|os.O_CREATE, 0777)
	if err != nil {
		log.Fatal(err)
		return
	}

	err = png.Encode(f, img)
	if err != nil {
		log.Fatal(err)
		return
	}

	created := &model.ImageDTO{
		OriginName: originName,
		Reference:  dirPath,
		Extension:  extension,
	}
	return created
}
