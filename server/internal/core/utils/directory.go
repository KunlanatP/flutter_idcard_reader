package utils

import (
	"fmt"
	"io"
	"log"
	"os"
	"regexp"
	"strings"
)

func IsEmpty(path string) (bool, error) {
	f, err := os.Open(path)
	if err != nil {
		return false, err
	}
	defer f.Close()

	_, err = f.Readdirnames(1) // OR f.Readdir(1)
	if err == io.EOF {
		return true, nil
	}
	return false, err
}

// Get the first 8 characters of AppID for create directory
// ex. AppID = bb518165-9718-4d9b-843a-ffb246b6c9b1
// >> .../THAID_HOME/FTD/builder/bb518165/{AppName}
func SplitID(appId string) string {
	splitted := strings.Split(appId, "-")
	return splitted[0]
}

func CheckUpperCaseCharacter(name string) string {
	var re = regexp.MustCompile(`[[:upper:]]+`)
	str := name

	for i, match := range re.FindAllString(name, -1) {
		str = strings.Replace(str, match, fmt.Sprintf("_%s", match), i)
	}

	return strings.ToLower(strings.ReplaceAll(str, "__", "_"))
}

func AppNameUpperCaseCharacter(name string) string {
	var re = regexp.MustCompile(`[[:upper:]]+`)
	str := name

	for i, match := range re.FindAllString(name, -1) {
		str = strings.Replace(str, match, fmt.Sprintf(" %s", strings.ToUpper(match)), i)
	}

	return str
}

func ValidateDirectory(path string) error {
	err := os.MkdirAll(path, os.ModePerm)
	if err != nil {
		log.Println(err)
		return err
	}
	return nil
}
