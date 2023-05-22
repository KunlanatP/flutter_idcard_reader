// This file response of function help to create client error response
package errs

import "net/http"

// Validate request from client error
func Invalid(message ...string) error {
	return newError(http.StatusBadRequest, message)
}

// User not authen
func UnAuthen(message ...string) error {
	return newError(http.StatusUnauthorized, message)
}

// User authen already but not have permission to do the stuff
func NoPermission(message ...string) error {
	return newError(http.StatusForbidden, message)
}

// Try to find some resource is not existing on server.
// status: 404
func NotFound(message ...string) error {
	return newError(http.StatusNotFound, message)
}

// Try to find some resource but have no resource and have referrenced.
// status: 204
func NoContent(message ...string) error {
	return newError(http.StatusNoContent, message)
}
