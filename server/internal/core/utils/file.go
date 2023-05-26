package utils

import (
	"encoding/json"
	"fmt"
	"io"
	"io/ioutil"
	"os"
	"path/filepath"
	"regexp"
	"strconv"
	"strings"
	"time"

	"github.com/KunlanatP/idcard-reader-server/internal/core/log"
)

func ReadFile(filename string) (string, error) {
	data, err := ioutil.ReadFile(filename)
	if err != nil {
		return "", err
	}
	return string(data), nil
}

func ReadJsonFile(filename string) (map[string]string, error) {
	// Open our jsonFile
	jsonFile, err := os.Open(filename)
	// if we os.Open returns an error then handle it
	if err != nil {
		return nil, err
	}

	log.Debug("Successfully Opened")
	// defer the closing of our jsonFile so that we can parse it later on
	defer jsonFile.Close()

	byteValue, _ := ioutil.ReadAll(jsonFile)
	jsonMap := make(map[string]string)
	if err := json.Unmarshal(byteValue, &jsonMap); err != nil {
		return nil, err
	}

	return jsonMap, nil
}

func WriteFile(filename, str string) {
	var file, err = os.Create(filename)
	if isError(err) {
		return
	}
	defer file.Close()

	_, err = file.WriteString(fmt.Sprintf("%s \n", str))
	if isError(err) {
		return
	}
	// Save file changes.
	err = file.Sync()
	if isError(err) {
		return
	}
}

func isError(err error) bool {
	return err != nil
}

func ValidateFileIsDuplicate(path string, fileName string, ext string) (string, error) {
	files, err := filepath.Glob(fmt.Sprintf("%s/%s%s", path, fileName, ext))
	if err != nil {
		return "", err
	}
	if len(files) > 0 {
		dup, err := filepath.Glob(fmt.Sprintf("%s/%s (*)%s", path, fileName, ext))
		if err != nil {
			return "", err
		}

		numFileDup := len(dup)
		numberNewFile := int64(1)
		if numFileDup != 0 {
			spliteName := strings.Split(dup[numFileDup-1], "(")
			numberNew := string(spliteName[len(spliteName)-1][0])
			numberNewFile, _ = strconv.ParseInt(numberNew, 0, 0)
		}
		newFileName := fmt.Sprintf("%s (%d)", fileName, numberNewFile+1)

		return newFileName, nil
	} else {
		return fileName, nil
	}

}

func GetFileNameExtension(fileName string) (string, string) {
	ext := filepath.Ext(fileName)
	name := strings.TrimSuffix(fileName, ext)
	return name, ext
}

func MoveFileTempDir(pathFile string, nameFile string) error {
	tempPath := filepath.Join(pathFile, "temp")
	if err := ValidateDirectory(tempPath); err != nil {
		return err
	}

	currentPath := filepath.Join(pathFile, nameFile)
	moveToTempPath := filepath.Join(tempPath, nameFile)

	inputFile, err := os.Open(currentPath)
	if err != nil {
		return err
	}
	outputFile, err := os.Create(moveToTempPath)
	if err != nil {
		inputFile.Close()
		return err
	}
	defer outputFile.Close()
	_, err = io.Copy(outputFile, inputFile)
	inputFile.Close()
	if err != nil {
		return err
	}

	err = os.Remove(currentPath)

	if err != nil {
		return err
	}

	return nil

}

func GetFileInDirectory(dirPath, pattern string) (string, error) {
	files, err := ioutil.ReadDir(dirPath)
	if err != nil {
		return "", err
	}

	var re = regexp.MustCompile(pattern)
	for _, file := range files {
		if re.MatchString(file.Name()) {
			return re.FindAllString(file.Name(), -1)[0], nil
		}
	}
	return "", nil
}

func GetLastFileInDirectory(dirPath string) (string, error) {
	files, err := ioutil.ReadDir(dirPath)
	if err != nil {
		return "", err
	}
	var modTime time.Time
	var names []string
	for _, fi := range files {
		if fi.Mode().IsRegular() {
			if !fi.ModTime().Before(modTime) {
				if fi.ModTime().After(modTime) {
					modTime = fi.ModTime()
					names = names[:0]
				}
				names = append(names, fi.Name())
			}
		}
	}
	if len(names) > 0 {
		return names[0], nil
	}
	return "", nil
}

func GetNameLastFile(dirPath string) ([]string, error) {
	files, err := ioutil.ReadDir(dirPath)
	if err != nil {
		return nil, err
	}
	var modTime time.Time
	var names []string
	for _, fi := range files {
		if fi.Mode().IsRegular() {
			if !fi.ModTime().Before(modTime) {
				if fi.ModTime().After(modTime) {
					modTime = fi.ModTime()
					names = names[:0]
				}
				names = append(names, fi.Name())
			}
		}
	}
	if len(names) > 0 {
		return names, nil

	}
	return names, nil
}

func CopyFile(src, dst string) (err error) {
	sfi, err := os.Stat(src)
	if err != nil {
		return
	}

	if !sfi.Mode().IsRegular() {
		return fmt.Errorf("CopyFile: non-regular source file %s (%q)", sfi.Name(), sfi.Mode().String())
	}
	dfi, err := os.Stat(dst)
	if err != nil {
		if !os.IsNotExist(err) {
			return
		}
	} else {
		if !(dfi.Mode().IsRegular()) {
			return fmt.Errorf("CopyFile: non-regular destination file %s (%q)", dfi.Name(), dfi.Mode().String())
		}
		if os.SameFile(sfi, dfi) {
			return
		}
	}
	if err = os.Link(src, dst); err == nil {
		return
	}
	err = copyFileContents(src, dst)
	return
}

func copyFileContents(src, dst string) (err error) {
	in, err := os.Open(src)
	if err != nil {
		return
	}
	defer in.Close()
	out, err := os.Create(dst)
	if err != nil {
		return
	}
	defer func() {
		cerr := out.Close()
		if err == nil {
			err = cerr
		}
	}()
	if _, err = io.Copy(out, in); err != nil {
		return
	}
	err = out.Sync()
	return
}

func WalkMatch(root, pattern, replace string) error {
	err := filepath.Walk(root, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if info.IsDir() {
			return nil
		}
		data, err := ioutil.ReadFile(path)
		if err != nil {
			return nil
		}
		file := string(data)
		re := regexp.MustCompile(pattern)
		result := re.ReplaceAllString(file, replace)

		WriteFile(path, result)
		return nil
	})
	if err != nil {
		return err
	}
	return nil
}
