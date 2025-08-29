#include "testing.h"
#include <stdlib.h>

static Suite global_suite = {NULL, NULL};
static int current_test_failed = 0;

void lite_test_register(const char *name, TestFunc func) {
  Test *t = malloc(sizeof(Test));
  t->name = name;
  t->func = func;
  t->next = NULL;
  if (!global_suite.head) {
    global_suite.head = global_suite.tail = t;
  } else {
    global_suite.tail->next = t;
    global_suite.tail = t;
  }
}

void lite_test_fail(void) { current_test_failed = 1; }

Suite *lite_test_get_suite(void) { return &global_suite; }

void lite_test_run_all(void) {
  Test *t = global_suite.head;
  int passed = 0, failed = 0;
  while (t) {
    current_test_failed = 0;
    t->func();
    if (current_test_failed) {
      failed++;
      printf("[FAIL] %s\n", t->name);
    } else {
      passed++;
      printf("[PASS] %s\n", t->name);
    }
    t = t->next;
  }
  printf("Summary: %d passed, %d failed\n", passed, failed);
}
