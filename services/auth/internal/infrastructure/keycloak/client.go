package keycloak

import (
	"context"
	"net/http"
)

type Client struct {
	baseURL    string
	httpClient *http.Client
}

func (c *Client) GetUser(ctx context.Context, id string) (*KeycloakUser, error) {
	// TODO implement
	panic("not implemented")
}

func (c *Client) RefreshToken(ctx context.Context, refreshToken string) (*KeycloakToken, error) {
	// TODO implement
	panic("not implemented")
}

func (c *Client) ValidateToken(ctx context.Context, token string) (*KeycloakToken, error) {
	// TODO implement
	panic("not implemented")
}

func (c *Client) CreateUser(ctx context.Context, user *KeycloakUser) (*KeycloakUser, error) {
	// TODO implement
	panic("not implemented")
}

func (c *Client) UpdateUser(ctx context.Context, user *KeycloakUser) (*KeycloakUser, error) {
	// TODO implement
	panic("not implemented")
}

func (c *Client) DeleteUser(ctx context.Context, id string) error {
	// TODO implement
	panic("not implemented")
}

func (c *Client) GetUserByEmail(ctx context.Context, email string) (*KeycloakUser, error) {
	// TODO implement
	panic("not implemented")
}

func (c *Client) GetUserByUsername(ctx context.Context, username string) (*KeycloakUser, error) {
	// TODO implement
	panic("not implemented")
}
