module intellifinder/services/permissions

go 1.25.3

require (
	github.com/google/uuid v1.6.0
	github.com/jackc/pgx/v5 v5.5.1
	google.golang.org/grpc v1.76.0
	google.golang.org/protobuf v1.36.6
	intellifinder/libs/utils v0.0.0
)

replace intellifinder/libs/utils => ../../libs/utils

require (
	github.com/jackc/pgpassfile v1.0.0 // indirect
	github.com/jackc/pgservicefile v0.0.0-20221227161230-091c0ba34f0a // indirect
	github.com/jackc/puddle/v2 v2.2.1 // indirect
	golang.org/x/crypto v0.40.0 // indirect
	golang.org/x/net v0.42.0 // indirect
	golang.org/x/sync v0.16.0 // indirect
	golang.org/x/sys v0.34.0 // indirect
	golang.org/x/text v0.27.0 // indirect
	google.golang.org/genproto/googleapis/rpc v0.0.0-20250804133106-a7a43d27e69b // indirect
)
