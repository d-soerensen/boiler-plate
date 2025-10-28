module github.com/intellifinder/v4/services/auth

go 1.25.3

require (
	github.com/intellifinder/v4/libs/auth v0.0.0
	github.com/intellifinder/v4/libs/database v0.0.0
	github.com/intellifinder/v4/libs/observability v0.0.0
	github.com/gin-gonic/gin v1.9.1
	github.com/golang-jwt/jwt/v5 v5.2.0
	github.com/google/uuid v1.5.0
	github.com/jackc/pgx/v5 v5.5.1
	github.com/redis/go-redis/v9 v9.3.0
	github.com/stretchr/testify v1.8.4
	go.uber.org/zap v1.26.0
	google.golang.org/grpc v1.60.1
	google.golang.org/protobuf v1.32.0
)

replace github.com/intellifinder/v4/libs/auth => ../../libs/auth
replace github.com/intellifinder/v4/libs/database => ../../libs/database
replace github.com/intellifinder/v4/libs/observability => ../../libs/observability
