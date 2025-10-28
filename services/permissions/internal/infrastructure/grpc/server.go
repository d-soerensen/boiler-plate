package grpc

import (
	"context"
	permissionsv1 "intellifinder/services/permissions/api/v1"
	"intellifinder/services/permissions/internal/domain/permissions"
	"strings"
)

type PermissionServer struct {
	permissionsv1.UnimplementedPermissionServiceServer
	service *permissions.Service
}

func NewPermissionServer(service *permissions.Service) *PermissionServer {
	return &PermissionServer{
		service: service,
	}
}

func (s *PermissionServer) RegisterService(ctx context.Context, req *permissionsv1.RegisterServiceRequest) (*permissionsv1.RegisterServiceResponse, error) {
	err := s.service.RegisterServicePermissions(ctx, req.ServiceName, req.Permissions)
	if err != nil {
		return &permissionsv1.RegisterServiceResponse{
			Success: false,
			Message: err.Error(),
		}, nil
	}

	return &permissionsv1.RegisterServiceResponse{
		Success: true,
		Message: "Service permissions registered successfully",
	}, nil
}

func (s *PermissionServer) CheckPermission(ctx context.Context, req *permissionsv1.CheckPermissionRequest) (*permissionsv1.CheckPermissionResponse, error) {
	// Parse the permission string to get service and action
	parts := strings.Split(req.Permission, ":")
	if len(parts) != 2 {
		return &permissionsv1.CheckPermissionResponse{
			Exists: false,
		}, nil
	}

	service, action := parts[0], parts[1]
	exists, err := s.service.PermissionExistsByServiceAndAction(ctx, service, action)
	if err != nil {
		return nil, err
	}

	return &permissionsv1.CheckPermissionResponse{
		Exists: exists,
	}, nil
}

func (s *PermissionServer) GetServicePermissions(ctx context.Context, req *permissionsv1.GetServicePermissionsRequest) (*permissionsv1.GetServicePermissionsResponse, error) {
	result, err := s.service.GetServicePermissions(ctx, req.ServiceName, req.Page, req.Limit)
	if err != nil {
		return nil, err
	}

	// Convert models.Permission to strings
	permissionStrings := make([]string, len(result.Permissions))
	for i, perm := range result.Permissions {
		permissionStrings[i] = perm.Service + ":" + perm.Action
	}

	return &permissionsv1.GetServicePermissionsResponse{
		Permissions: permissionStrings,
		Page:        result.Page,
		Limit:       result.Limit,
		TotalCount:  result.TotalCount,
		LastPage:    result.LastPage,
	}, nil
}

func (s *PermissionServer) GetAllPermissions(ctx context.Context, req *permissionsv1.GetAllPermissionsRequest) (*permissionsv1.GetAllPermissionsResponse, error) {
	result, err := s.service.GetAllPermissions(ctx, req.Page, req.Limit)
	if err != nil {
		return nil, err
	}

	// Convert models.Permission to strings
	permissionStrings := make([]string, len(result.Permissions))
	for i, perm := range result.Permissions {
		permissionStrings[i] = perm.Service + ":" + perm.Action
	}

	return &permissionsv1.GetAllPermissionsResponse{
		Permissions: permissionStrings,
		Page:        result.Page,
		Limit:       result.Limit,
		TotalCount:  result.TotalCount,
		LastPage:    result.LastPage,
	}, nil
}
