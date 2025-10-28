package database

const (
	createPermissionTable = `
		CREATE TABLE IF NOT EXISTS permissions (
			id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
			service VARCHAR(255) NOT NULL,
			action VARCHAR(255) NOT NULL,
			created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
			updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
			CONSTRAINT unique_service_action UNIQUE (service, action)
		)
	`

	createPermissionIndex = `
		CREATE INDEX IF NOT EXISTS idx_permissions_service ON permissions (service);
		CREATE INDEX IF NOT EXISTS idx_permissions_action ON permissions (action);
	`

	getPermissionsByService = `
		SELECT * FROM permissions
		WHERE service = $1
		ORDER BY created_at DESC
		LIMIT $2 OFFSET $3
	`
	countPermissionsByService = `
		SELECT COUNT(*) FROM permissions
		WHERE service = $1
	`

	getAllPermissions = `
		SELECT * FROM permissions
		ORDER BY created_at DESC
		LIMIT $1 OFFSET $2
	`

	countAllPermissions = `
		SELECT COUNT(*) FROM permissions
	`

	insertPermission = `
		INSERT INTO permissions (service, action, created_at, updated_at)
		VALUES ($1, $2, $3, $4)
		ON CONFLICT (service, action) DO NOTHING
	`

	bulkInsertPermissions = `
		INSERT INTO permissions (service, action, created_at, updated_at)
		VALUES %s
		ON CONFLICT (service, action) DO NOTHING
	`

	checkPermissionExistsByServiceAndAction = `
		SELECT EXISTS(SELECT 1 FROM permissions WHERE service = $1 AND action = $2)
	`
)
