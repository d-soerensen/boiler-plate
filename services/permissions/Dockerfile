FROM golang:1.25.3-alpine
WORKDIR /app
RUN apk add --no-cache git ca-certificates
COPY services/permissions/go.mod services/permissions/go.sum ./
COPY libs/utils ./libs/utils
RUN sed -i 's|../../libs/utils|./libs/utils|g' go.mod && \
    go mod download
COPY services/permissions .
RUN sed -i 's|../../libs/utils|./libs/utils|g' go.mod
RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup
RUN chown -R appuser:appgroup /app
USER appuser
EXPOSE 8080
CMD ["go", "run", "./cmd/main.go"]