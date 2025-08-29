# Makefile for Lite Test Framework
# Compiles each .c file in test/ directory as a separate executable

CC = gcc
CFLAGS = -Wall -Wextra -std=c99 -g
INCLUDES = -I.

# Directories
TEST_DIR = test
BIN_DIR = $(TEST_DIR)/bin
OBJ_DIR = $(TEST_DIR)/obj

# Source files
FRAMEWORK_SRC = testing.c
TEST_SOURCES = $(wildcard $(TEST_DIR)/*.c)
TEST_NAMES = $(basename $(notdir $(TEST_SOURCES)))
TEST_EXECUTABLES = $(addprefix $(BIN_DIR)/, $(TEST_NAMES))

# Default target
.PHONY: all
all: build-tests

# Create necessary directories
$(BIN_DIR):
	mkdir -p $(BIN_DIR)

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

# Compile framework object file
$(OBJ_DIR)/testing.o: $(FRAMEWORK_SRC) testing.h | $(OBJ_DIR)
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

# Build individual test executables
$(BIN_DIR)/%: $(TEST_DIR)/%.c $(OBJ_DIR)/testing.o testing.h | $(BIN_DIR)
	$(CC) $(CFLAGS) $(INCLUDES) $< $(OBJ_DIR)/testing.o -o $@

# Build all tests
.PHONY: build-tests
build-tests: $(TEST_EXECUTABLES)
	@echo "Built $(words $(TEST_EXECUTABLES)) test executables:"
	@for test in $(TEST_NAMES); do echo "  - $(BIN_DIR)/$$test"; done

# Run all tests
.PHONY: run-tests
run-tests: build-tests
	@echo "Running all tests..."
	@echo "==================="
	@total=0; passed=0; \
	for test in $(TEST_EXECUTABLES); do \
		echo; \
		echo "Running $$test:"; \
		echo "-------------------"; \
		if ./$$test; then \
			passed=$$((passed + 1)); \
		fi; \
		total=$$((total + 1)); \
	done; \
	echo; \
	echo "==================="; \
	echo "Test Summary: $$passed/$$total tests passed"

# Run specific test
.PHONY: run-test-%
run-test-%: $(BIN_DIR)/%
	@echo "Running test: $*"
	@./$(BIN_DIR)/$*

# Clean build artifacts
.PHONY: clean
clean:
	rm -rf $(BIN_DIR) $(OBJ_DIR)
	@echo "Cleaned build directories"

# Show available tests
.PHONY: list-tests
list-tests:
	@echo "Available tests:"
	@for test in $(TEST_NAMES); do echo "  - $$test"; done

# Help target
.PHONY: help
help:
	@echo "Lite Test Framework Makefile"
	@echo "============================"
	@echo "Available targets:"
	@echo "  build-tests    - Compile all test files into executables"
	@echo "  run-tests      - Build and run all tests with summary"
	@echo "  run-test-NAME  - Build and run specific test (e.g., run-test-math)"
	@echo "  list-tests     - Show all available tests"
	@echo "  clean          - Remove all build artifacts"
	@echo "  help           - Show this help message"
	@echo ""
	@echo "Usage examples:"
	@echo "  make build-tests    # Just compile"
	@echo "  make run-tests      # Compile and run all"
	@echo "  make run-test-calc  # Run only calc.c test"

# Debug info (useful for troubleshooting)
.PHONY: debug
debug:
	@echo "Debug Information:"
	@echo "=================="
	@echo "CC: $(CC)"
	@echo "CFLAGS: $(CFLAGS)"
	@echo "TEST_DIR: $(TEST_DIR)"
	@echo "BIN_DIR: $(BIN_DIR)"
	@echo "OBJ_DIR: $(OBJ_DIR)"
	@echo "FRAMEWORK_SRC: $(FRAMEWORK_SRC)"
	@echo "TEST_SOURCES: $(TEST_SOURCES)"
	@echo "TEST_NAMES: $(TEST_NAMES)"
	@echo "TEST_EXECUTABLES: $(TEST_EXECUTABLES)"
