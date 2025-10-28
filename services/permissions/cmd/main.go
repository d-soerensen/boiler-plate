package main

import (
	"context"
	"intellifinder/libs/utils"
	permissionsv1 "intellifinder/services/permissions/api/v1"
	"intellifinder/services/permissions/internal/domain/permissions"
	"intellifinder/services/permissions/internal/infrastructure/database"
	grpcServer "intellifinder/services/permissions/internal/infrastructure/grpc"
	"log"
	"net"
	"os"
	"os/signal"
	"syscall"

	"github.com/jackc/pgx/v5/pgxpool"
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
)

func main() {
	// Load configuration
	config := loadConfig()
	log.Println("Loaded configurations.")

	// Create context with cancellation
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	// Create pgx connection pool
	db, err := pgxpool.New(ctx, config.DatabaseURL)
	if err != nil {
		log.Fatalf("failed to create database pool: %v", err)
	}
	defer db.Close()

	// Run migration
	err = database.CreatePermissionTable(ctx, db)
	if err != nil {
		log.Fatalf("failed to create permission table: %v", err)
	}

	log.Println("Migration completed successfully!")

	repo := database.NewPermissionRepository(db)
	service := permissions.NewService(repo)
	permissionServer := grpcServer.NewPermissionServer(service)

	grpcServer := grpc.NewServer()
	permissionsv1.RegisterPermissionServiceServer(grpcServer, permissionServer)

	// Enable gRPC reflection for easy endpoint inspection
	reflection.Register(grpcServer)

	// Setup graceful shutdown
	sigChan := make(chan os.Signal, 1)
	signal.Notify(sigChan, os.Interrupt, syscall.SIGTERM)

	go func() {
		<-sigChan
		log.Println("Shutting down gracefully...")
		grpcServer.GracefulStop()
		cancel()
	}()

	listen, err := net.Listen("tcp", ":"+config.Port)
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	log.Printf("Server is running on port %s", config.Port)
	if err := grpcServer.Serve(listen); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}

func loadConfig() *Config {
	return &Config{
		Port:        utils.GetEnv("PORT", "8080"),
		DatabaseURL: utils.GetEnv("DATABASE_URL", ""),
	}
}

type Config struct {
	Port        string
	DatabaseURL string
}
