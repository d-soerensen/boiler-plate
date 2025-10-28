package models

import "time"

type Token struct {
	TokenType        string    `json:"token_type"`
	Token            string    `json:"token"`
	ExpiresAt        time.Time `json:"expires_at"`
	RefreshToken     string    `json:"refresh_token"`
	ExpiresAtRefresh time.Time `json:"expires_at_refresh"`
}
