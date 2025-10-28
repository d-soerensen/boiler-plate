package permissions

import (
	"context"
	"intellifinder/services/permissions/pkg/dto"
)

type Repository interface {
	RegisterServicePermissions(ctx context.Context, serviceName string, permissions []string) error
	GetServicePermissions(ctx context.Context, serviceName string, page int32, limit int32) (*dto.PaginatedPermissions, error)
	GetAllPermissions(ctx context.Context, page int32, limit int32) (*dto.PaginatedPermissions, error)
	PermissionExistsByServiceAndAction(ctx context.Context, service string, action string) (bool, error)
}
