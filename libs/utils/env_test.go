package utils

import (
	"os"
	"testing"
)

func TestGetEnv(t *testing.T) {
	// Test with existing environment variable
	os.Setenv("TEST_VAR", "test_value")
	defer os.Unsetenv("TEST_VAR")

	if got := GetEnv("TEST_VAR", "default"); got != "test_value" {
		t.Errorf("GetEnv() = %v, want %v", got, "test_value")
	}

	// Test with non-existing environment variable
	if got := GetEnv("NON_EXISTING_VAR", "default_value"); got != "default_value" {
		t.Errorf("GetEnv() = %v, want %v", got, "default_value")
	}

	// Test with empty environment variable
	os.Setenv("EMPTY_VAR", "")
	defer os.Unsetenv("EMPTY_VAR")

	if got := GetEnv("EMPTY_VAR", "default"); got != "default" {
		t.Errorf("GetEnv() = %v, want %v", got, "default")
	}
}
