.PHONY: all clean build build-noble

all: build

# Build all Dockerfiles
build: build-noble
	@echo "Built all Dockerfiles."

# Build the noble/Dockerfile
build-noble:
	@echo "Building noble/Dockerfile..."
	docker build -f noble/Dockerfile -t deltalake:noble .
	docker run -it --rm deltalake:noble test/test.sh
# Clean docker images
clean:
	@echo "Cleaning docker images..."
	docker rmi noble:latest || true

perf-test:
	docker run -it --rm -e "MULTIPLIER_COUNT=6" deltalake:noble test/perf-test.sh