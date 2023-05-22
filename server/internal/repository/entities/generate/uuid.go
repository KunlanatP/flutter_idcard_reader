package generate

import (
	"crypto/rand"

	"github.com/google/uuid"
)

// this is a static namespace for this machine, say
var exampleNS = uuid.New()

// generate a random UUID with the global namespace
func NewExampleUUID() (string, error) {
	// read 16 crypto-random bytes
	rnd := make([]byte, 16)
	if _, err := rand.Read(rnd); err != nil {
		return "", err
	}
	return uuid.NewSHA1(exampleNS, rnd).String(), nil
}
