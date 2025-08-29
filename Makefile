# Makefile for Lite Test Framework
# Compiles each .c file in current directory and subdirectories as separate executables
# Place this Makefile in the test/ directory

CC = gcc
CFLAGS = -Wall -Wextra -std=c99 -g
INCLUDES = -I..

# Directories
BIN_DIR = bin
OBJ_DIR = obj

# Source files
FRAMEWORK_SRC = ../testing.c
FRAMEWORK_HDR = ../testing.h
TEST_SOURCES = $(shell find . -name "*.c" -type f)
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
$(OBJ_DIR)/testing.o: $(FRAMEWORK_SRC) $(FRAMEWORK_HDR) | $(OBJ_DIR)
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

# Build individual test executables from any subdirectory
define build_test_rule
$(BIN_DIR)/$(notdir $(basename $(1))): $(1) $(OBJ_DIR)/testing.o $(FRAMEWORK_HDR) | $(BIN_DIR)
	$(CC) $(CFLAGS) $(INCLUDES) $(1) $(OBJ_DIR)/testing.o -o $$@
endef

$(foreach test,$(TEST_SOURCES),$(eval $(call build_test_rule,$(test))))

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
	@echo "  run-test-NAME  - Build and run specific test (e.g., run-test-mutex)"
	@echo "  list-tests     - Show all available tests"
	@echo "  clean          - Remove all build artifacts"
	@echo "  help           - Show this help message"
	@echo ""
	@echo "Usage examples:"
	@echo "  make build-tests    # Just compile"
	@echo "  make run-tests      # Compile and run all"
	@echo "  make run-test-mutex # Run only mutex.c test"

# Debug info (useful for troubleshooting)
.PHONY: debug
debug:
	@echo "Debug Information:"
	@echo "=================="
	@echo "CC: $(CC)"
	@echo "CFLAGS: $(CFLAGS)"
	@echo "INCLUDES: $(INCLUDES)"
	@echo "BIN_DIR: $(BIN_DIR)"
	@echo "OBJ_DIR: $(OBJ_DIR)"
	@echo "FRAMEWORK_SRC: $(FRAMEWORK_SRC)"
	@echo "FRAMEWORK_HDR: $(FRAMEWORK_HDR)"
	@echo "TEST_SOURCES: $(TEST_SOURCES)"
	@echo "TEST_NAMES: $(TEST_NAMES)"
	@echo "TEST_EXECUTABLES: $(TEST_EXECUTABLES)"
	@echo ""
	@echo "Found test files:"
	@for test in $(TEST_SOURCES); do echo "  - $$test"; done
