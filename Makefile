.PHONY: all clean build build-noble

all: build

# Build all Dockerfiles
build: build-noble-uv
	@echo "Built all Dockerfiles."

# Build the noble/Dockerfile
build-noble:
	@echo "Building noble/Dockerfile..."
	docker build -f noble/Dockerfile -t deltalake:noble .
	docker run -it --rm deltalake:noble test/test.sh

# Build the noble/Dockerfile
build-deltashare:
	@echo "Building noble/Dockerfile..."
	docker build -f noble/Dockerfile.deltashare -t deltashare:noble .
	docker run -it --rm deltashare:noble test/test.sh

build-noble-uv:
	@echo "Building noble/Dockerfile..."
	docker build -f noble/Dockerfile.uv -t deltalake:uv .
	docker run -it --rm deltalake:uv bash test/test.sh
	docker tag deltalake:uv deltalake:build

build-alpine-uv:
	@echo "Building noble/Dockerfile..."
	docker build -f alpine/Dockerfile.uv -t deltalake:alpine-uv .
	docker run -it --rm deltalake:uv bash test/test.sh
runit:
	@echo "Running noble/Dockerfile..."
	docker run -it --rm deltalake:build bash

live:
	@echo "Running noble/Dockerfile..."
	docker run -it --rm -v $(shell pwd)/test:/test deltalake:build bash

# Clean docker images
clean:
	@echo "Cleaning docker images..."
	docker rmi noble:latest || true

perf-test:
	docker run -it --rm -e "MULTIPLIER_COUNT=6" deltalake:build test/perf-test.sh