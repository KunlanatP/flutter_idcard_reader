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

func Base64toPng(data, dirPath, filename string) (out *model.ImageDTO) {

	reader := base64.NewDecoder(base64.StdEncoding, strings.NewReader(data))
	m, formatString, err := image.Decode(reader)
	if err != nil {
		log.Fatal(err)
	}
	bounds := m.Bounds()
	fmt.Println(bounds, formatString)

	if err := ValidateDirectory(dirPath); err != nil {
		log.Fatal(err)
	}

	//Encode from image format to writer
	originName := fmt.Sprintf("%s.%s", filename, formatString)
	pngFilename := filepath.Join(dirPath, originName)
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
		OriginName: originName,
		Reference:  config.Default.THAID_HOME,
		Extension:  "png",
	}
	return created
}
