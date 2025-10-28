package database

import (
	"context"
	"fmt"
	"intellifinder/services/permissions/pkg/dto"
	"intellifinder/services/permissions/pkg/models"
	"strings"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
)

type PermissionRepository struct {
	db *pgxpool.Pool
}

// NewPermissionRepository creates a new permission repository
func NewPermissionRepository(db *pgxpool.Pool) *PermissionRepository {
	return &PermissionRepository{
		db: db,
	}
}

func (r *PermissionRepository) CreatePermission(ctx context.Context, permission *models.Permission) error {
	_, err := r.db.Exec(ctx, insertPermission, permission.Service, permission.Action, permission.CreatedAt, permission.UpdatedAt)
	if err != nil {
		return fmt.Errorf("failed to create permission: %w", err)
	}
	return nil
}

func (r *PermissionRepository) PermissionExistsByServiceAndAction(ctx context.Context, service string, action string) (bool, error) {
	var exists bool
	err := r.db.QueryRow(ctx, checkPermissionExistsByServiceAndAction, service, action).Scan(&exists)
	if err != nil {
		return false, fmt.Errorf("failed to check permission exists by service and action: %w", err)
	}
	return exists, nil
}

func (r *PermissionRepository) GetServicePermissions(ctx context.Context, service string, page int32, limit int32) (*dto.PaginatedPermissions, error) {
	offset := (page - 1) * limit

	rows, err := r.db.Query(ctx, getPermissionsByService, service, limit, offset)
	if err != nil {
		return nil, fmt.Errorf("failed to get permissions by service: %w", err)
	}
	defer rows.Close()

	permissions, err := pgx.CollectRows(rows, pgx.RowToStructByName[models.Permission])
	if err != nil {
		return nil, fmt.Errorf("failed to collect permission rows: %w", err)
	}

	var totalCount int32
	err = r.db.QueryRow(ctx, countPermissionsByService, service).Scan(&totalCount)
	if err != nil {
		return nil, fmt.Errorf("failed to count permissions by service: %w", err)
	}
	return dto.NewPaginatedPermissions(permissions, page, limit, totalCount), nil
}

func (r *PermissionRepository) GetAllPermissions(ctx context.Context, page int32, limit int32) (*dto.PaginatedPermissions, error) {
	offset := (page - 1) * limit

	rows, err := r.db.Query(ctx, getAllPermissions, limit, offset)
	if err != nil {
		return nil, fmt.Errorf("failed to get all permissions: %w", err)
	}
	defer rows.Close()

	permissions, err := pgx.CollectRows(rows, pgx.RowToStructByName[models.Permission])
	if err != nil {
		return nil, fmt.Errorf("failed to collect permission rows: %w", err)
	}

	var totalCount int32
	err = r.db.QueryRow(ctx, countAllPermissions).Scan(&totalCount)
	if err != nil {
		return nil, fmt.Errorf("failed to count all permissions: %w", err)
	}

	return dto.NewPaginatedPermissions(permissions, page, limit, totalCount), nil
}

// RegisterServicePermissions registers all permissions for a service using bulk insert
func (r *PermissionRepository) RegisterServicePermissions(ctx context.Context, serviceName string, permissions []string) error {
	if len(permissions) == 0 {
		return nil
	}

	// Parse all permission strings and prepare for bulk insert
	now := time.Now()
	valueStrings := make([]string, 0, len(permissions))
	args := make([]any, 0, len(permissions)*4)
	argIndex := 1

	for _, permissionStr := range permissions {
		// Parse permission string (format: "service:action")
		service, action, err := parsePermissionString(permissionStr)
		if err != nil {
			return fmt.Errorf("failed to parse permission string %s: %w", permissionStr, err)
		}

		// Add values for this permission
		valueStrings = append(valueStrings, fmt.Sprintf("($%d, $%d, $%d, $%d)", argIndex, argIndex+1, argIndex+2, argIndex+3))
		args = append(args, service, action, now, now)
		argIndex += 4
	}

	// Build the bulk insert query
	query := fmt.Sprintf(bulkInsertPermissions, strings.Join(valueStrings, ","))

	// Execute bulk insert
	_, err := r.db.Exec(ctx, query, args...)
	if err != nil {
		return fmt.Errorf("failed to bulk insert permissions: %w", err)
	}

	return nil
}

func parsePermissionString(permissionStr string) (service, action string, err error) {
	parts := strings.Split(permissionStr, ":")
	if len(parts) != 2 {
		return "", "", fmt.Errorf("invalid permission format, expected 'service:action', got: %s", permissionStr)
	}
	return parts[0], parts[1], nil
}
