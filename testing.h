#ifndef LITE_TEST_H
#define LITE_TEST_H

#include <stdio.h>

typedef void (*TestFunc)(void);

typedef struct Test {
  const char *name;
  TestFunc func;
  struct Test *next;
} Test;

typedef struct {
  Test *head;
  Test *tail;
} Suite;

#define TEST(name)                                                             \
  void name(void);                                                             \
  __attribute__((constructor)) static void register_##name(void) {             \
    lite_test_register(#name, name);                                           \
  }                                                                            \
  void name(void)

#define ASSERT_TRUE(cond)                                                      \
  do {                                                                         \
    if (!(cond)) {                                                             \
      printf("[FAIL] %s:%d: ASSERT_TRUE(%s)\n", __FILE__, __LINE__, #cond);    \
      lite_test_fail();                                                        \
      return;                                                                  \
    }                                                                          \
  } while (0)

#define ASSERT_FALSE(cond) ASSERT_TRUE(!(cond))
#define ASSERT_EQ(a, b) ASSERT_TRUE((a) == (b))
#define ASSERT_NE(a, b) ASSERT_TRUE((a) != (b))
#define ASSERT_FAIL(msg)                                                       \
  do {                                                                         \
    printf("[FAIL] %s:%d: %s\n", __FILE__, __LINE__, msg);                     \
    lite_test_fail();                                                          \
    return;                                                                    \
  } while (0)

Suite *lite_test_get_suite(void);
void lite_test_register(const char *name, TestFunc func);
void lite_test_run_all(void);
void lite_test_fail(void);

#endif
