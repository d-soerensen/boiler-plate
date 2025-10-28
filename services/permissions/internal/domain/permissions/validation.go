package permissions

import (
	"fmt"
	"strings"
)

func (s *Service) validatePermission(permission string) error {
	if permission == "" {
		return fmt.Errorf("permission is required")
	}

	if !strings.Contains(permission, ":") {
		return fmt.Errorf("permission must be in the format 'service:action'")
	}

	parts := strings.Split(permission, ":")
	if len(parts) != 2 {
		return fmt.Errorf("permission must be in the format 'service:action'")
	}

	service, action := parts[0], parts[1]

	if service == "" || action == "" {
		return fmt.Errorf("service and action are required")
	}

	return nil
}
