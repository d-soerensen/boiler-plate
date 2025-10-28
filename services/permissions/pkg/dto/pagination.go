package dto

import "intellifinder/services/permissions/pkg/models"

type PaginatedPermissions struct {
	Permissions []models.Permission `json:"permissions"`
	Page        int32               `json:"page"`
	Limit       int32               `json:"limit"`
	TotalCount  int32               `json:"total_count"`
	LastPage    int32               `json:"last_page"`
}

func NewPaginatedPermissions(permissions []models.Permission, page, limit, totalCount int32) *PaginatedPermissions {
	lastPage := int32(1)
	if limit > 0 {
		lastPage = (totalCount + limit - 1) / limit // Ceiling division
		if lastPage == 0 {
			lastPage = 1
		}
	}

	return &PaginatedPermissions{
		Permissions: permissions,
		Page:        page,
		Limit:       limit,
		TotalCount:  totalCount,
		LastPage:    lastPage,
	}
}
