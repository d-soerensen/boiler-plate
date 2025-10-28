package permissions

import (
	"context"
	"fmt"
	"intellifinder/services/permissions/pkg/dto"
)

type Service struct {
	repo Repository
}

func NewService(repo Repository) *Service {
	return &Service{
		repo: repo,
	}
}

func (s *Service) RegisterServicePermissions(ctx context.Context, serviceName string, permissions []string) error {
	if serviceName == "" {
		return fmt.Errorf("service name is required")
	}

	if len(permissions) == 0 {
		return fmt.Errorf("permissions are required")
	}

	for _, permission := range permissions {
		if err := s.validatePermission(permission); err != nil {
			return fmt.Errorf("failed to validate permission: %w", err)
		}
	}

	if err := s.repo.RegisterServicePermissions(ctx, serviceName, permissions); err != nil {
		return fmt.Errorf("failed to register service permissions: %w", err)
	}

	return nil
}

func (s *Service) GetServicePermissions(ctx context.Context, serviceName string, page int32, limit int32) (*dto.PaginatedPermissions, error) {
	if serviceName == "" {
		return nil, fmt.Errorf("service name is required")
	}

	if page <= 0 {
		return nil, fmt.Errorf("page must be greater than 0")
	}

	if limit <= 0 {
		return nil, fmt.Errorf("limit must be greater than 0")
	}

	permissions, err := s.repo.GetServicePermissions(ctx, serviceName, page, limit)
	if err != nil {
		return nil, fmt.Errorf("failed to get service permissions: %w", err)
	}

	return permissions, nil
}

func (s *Service) GetAllPermissions(ctx context.Context, page int32, limit int32) (*dto.PaginatedPermissions, error) {
	if page <= 0 {
		return nil, fmt.Errorf("page must be greater than 0")
	}

	if limit <= 0 {
		return nil, fmt.Errorf("limit must be greater than 0")
	}

	permissions, err := s.repo.GetAllPermissions(ctx, page, limit)
	if err != nil {
		return nil, fmt.Errorf("failed to get all permissions: %w", err)
	}

	return permissions, nil
}

func (s *Service) PermissionExistsByServiceAndAction(ctx context.Context, service string, action string) (bool, error) {
	if service == "" {
		return false, fmt.Errorf("service is required")
	}

	if action == "" {
		return false, fmt.Errorf("action is required")
	}

	exists, err := s.repo.PermissionExistsByServiceAndAction(ctx, service, action)
	if err != nil {
		return false, fmt.Errorf("failed to check if permission exists: %w", err)
	}

	return exists, nil
}
