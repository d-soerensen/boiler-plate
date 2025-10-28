package permissions

import "intellifinder/libs/permissions"

var authPermissions = []string{
	"auth:read",
	"auth:write",
	"auth:delete",
	"auth:update",
	"auth:inactivate",
	"auth:activate",
	"auth:reset-password",
	"auth:forgot-password",
	"auth:create-api-key",
	"auth:delete-api-key",
}

func init() {
	permissions.RegisterService("auth", authPermissions)
}
