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

apply-crons:
	ls *-cj.yaml | xargs -IXXX kubectl apply -f XXX -n testing

prometheus:
	kubectl port-forward -n prometheus service/prometheus-operated  9080:9090


venv:
	python3 -m venv venv
	. venv/bin/activate && pip install -r requirements.txt
	@echo "Virtual environment created and dependencies installed."
	@echo "To activate the virtual environment, run: source venv/bin/activate"
	@echo "To deactivate the virtual environment, run: deactivate"
	@echo "To install additional dependencies, run: pip install <package-name>"
	@echo "To remove the virtual environment, run: rm -rf venv"
	@echo "To run the tests, run: pytest -v --disable-warnings"