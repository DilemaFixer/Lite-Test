# Lite Test

A lightweight, header-only unit testing framework for C projects. Simple to use, minimal dependencies, and easy to integrate into any C codebase.

## Features

- **Lightweight**: Minimal overhead and dependencies
- **Easy Integration**: Just include the header and source files
- **Automatic Test Registration**: Tests are automatically registered using constructor attributes
- **Simple Assertions**: Common assertion macros for testing
- **Clear Output**: Color-coded test results with pass/fail summary
- **No External Dependencies**: Pure C with standard library only

## Quick Start

``` shell
curl -O https://raw.githubusercontent.com/DilemaFixer/Lite-Test/main/testing.h
curl -O https://raw.githubusercontent.com/DilemaFixer/Lite-Test/main/testing.c
```

### 1. Include the Framework

Add `testing.h` and `testing.c` to your project and include the header:

```c
#include "testing.h"
```

### 2. Write Your Tests

Use the `TEST()` macro to define test functions:

```c
#include "testing.h"

TEST(test_basic_math) {
    ASSERT_EQ(2 + 2, 4);
    ASSERT_NE(5, 3);
    ASSERT_TRUE(10 > 5);
    ASSERT_FALSE(1 > 2);
}

TEST(test_string_operations) {
    const char* str = "hello";
    ASSERT_EQ(strlen(str), 5);
    ASSERT_TRUE(strcmp(str, "hello") == 0);
}

TEST(test_array_operations) {
    int arr[] = {1, 2, 3, 4, 5};
    int sum = 0;
    
    for (int i = 0; i < 5; i++) {
        sum += arr[i];
    }
    
    ASSERT_EQ(sum, 15);
}
```

### 3. Run Your Tests

Create a main function to execute all tests:

```c
int main() {
    lite_test_run_all();
    return 0;
}
```

## Available Assertions

The framework provides several assertion macros for testing:

| Assertion | Description | Example |
|-----------|-------------|---------|
| `ASSERT_TRUE(cond)` | Assert that condition is true | `ASSERT_TRUE(x > 0)` |
| `ASSERT_FALSE(cond)` | Assert that condition is false | `ASSERT_FALSE(ptr == NULL)` |
| `ASSERT_EQ(a, b)` | Assert that two values are equal | `ASSERT_EQ(result, 42)` |
| `ASSERT_NE(a, b)` | Assert that two values are not equal | `ASSERT_NE(error_code, 0)` |
| `ASSERT_FAIL(msg)` | Force test failure with message | `ASSERT_FAIL("Not implemented")` |

## Complete Example

Here's a complete example testing a simple calculator:

```c
// calculator.h
int add(int a, int b);
int multiply(int a, int b);
int divide(int a, int b);

// calculator.c
#include "calculator.h"

int add(int a, int b) {
    return a + b;
}

int multiply(int a, int b) {
    return a * b;
}

int divide(int a, int b) {
    if (b == 0) return -1; // Error case
    return a / b;
}

// test_calculator.c
#include "testing.h"
#include "calculator.h"

TEST(test_addition) {
    ASSERT_EQ(add(2, 3), 5);
    ASSERT_EQ(add(-1, 1), 0);
    ASSERT_EQ(add(0, 0), 0);
}

TEST(test_multiplication) {
    ASSERT_EQ(multiply(3, 4), 12);
    ASSERT_EQ(multiply(-2, 5), -10);
    ASSERT_EQ(multiply(0, 100), 0);
}

TEST(test_division) {
    ASSERT_EQ(divide(10, 2), 5);
    ASSERT_EQ(divide(7, 3), 2); // Integer division
    ASSERT_EQ(divide(5, 0), -1); // Error case
}

TEST(test_edge_cases) {
    ASSERT_TRUE(add(INT_MAX - 1, 1) == INT_MAX);
    ASSERT_NE(multiply(1000000, 1000000), 0); // Large numbers
}

int main() {
    printf("Running Calculator Tests...\n");
    lite_test_run_all();
    return 0;
}
```

## Expected Output

When you run your tests, you'll see output like:

```
Running Calculator Tests...
[PASS] test_addition
[PASS] test_multiplication
[PASS] test_division
[PASS] test_edge_cases
Summary: 4 passed, 0 failed
```

If a test fails, you'll see detailed information:

```
[FAIL] test_calculator.c:25: ASSERT_EQ(divide(10, 3), 4)
[FAIL] test_division
Summary: 3 passed, 1 failed
```

## Building Your Tests

### With GCC

```bash
gcc -o test_program testing.c test_calculator.c calculator.c
./test_program
```

### With Makefile

```makefile
CC = gcc
CFLAGS = -Wall -Wextra -std=c99

SOURCES = testing.c calculator.c test_calculator.c
TARGET = test_program

$(TARGET): $(SOURCES)
	$(CC) $(CFLAGS) -o $@ $^

test: $(TARGET)
	./$(TARGET)

clean:
	rm -f $(TARGET)

.PHONY: test clean
```

### Manual Test Registration

While the `TEST()` macro automatically registers tests, you can also manually register test functions:

```c
void my_custom_test(void) {
    ASSERT_TRUE(1 == 1);
}

int main() {
    lite_test_register("my_custom_test", my_custom_test);
    lite_test_run_all();
    return 0;
}
```

### Getting Test Suite Information

```c
Suite *suite = lite_test_get_suite();
// Access suite->head to iterate through tests manually
```

## API Reference

### Macros

- `TEST(name)` - Define a test function that will be automatically registered
- `ASSERT_TRUE(condition)` - Assert that condition evaluates to true
- `ASSERT_FALSE(condition)` - Assert that condition evaluates to false  
- `ASSERT_EQ(a, b)` - Assert that a equals b
- `ASSERT_NE(a, b)` - Assert that a does not equal b
- `ASSERT_FAIL(message)` - Force test failure with custom message

### Functions

- `void lite_test_register(const char *name, TestFunc func)` - Manually register a test
- `void lite_test_run_all(void)` - Run all registered tests
- `Suite *lite_test_get_suite(void)` - Get the test suite
- `void lite_test_fail(void)` - Mark current test as failed
