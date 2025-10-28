package database

import (
	"context"
	"fmt"

	"github.com/jackc/pgx/v5/pgxpool"
)

func CreatePermissionTable(ctx context.Context, db *pgxpool.Pool) error {
	_, err := db.Exec(ctx, createPermissionTable)
	if err != nil {
		return fmt.Errorf("failed to create permission table: %w", err)
	}

	// Also create indexes
	_, err = db.Exec(ctx, createPermissionIndex)
	if err != nil {
		return fmt.Errorf("failed to create permission indexes: %w", err)
	}

	return nil
}
