module github.com/intellifinder/v4/gateway

go 1.25.3

require (
	github.com/intellifinder/v4/libs/middleware v0.0.0
	github.com/intellifinder/v4/libs/observability v0.0.0
	github.com/gin-gonic/gin v1.9.1
	github.com/stretchr/testify v1.8.4
	go.uber.org/zap v1.26.0
	google.golang.org/grpc v1.60.1
	google.golang.org/protobuf v1.32.0
)

replace github.com/intellifinder/v4/libs/middleware => ../libs/middleware
replace github.com/intellifinder/v4/libs/observability => ../libs/observability
