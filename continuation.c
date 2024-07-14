#include <stdlib.h>
#include <string.h>
#include <setjmp.h>
#include "continuation.h"
static void *main_rbp;
static void *e_expr;

void init_continuation(void *rbp) {
  main_rbp = rbp;
}
void *get_continuation(continuation *c) {
  GETRSP(c->rsp);
  c->stacklen = main_rbp - c->rsp + 1;
  c->stack = malloc(c->stacklen);
  memmove(c->stack, c->rsp, c->stacklen);
  if (setjmp(c->cont_reg) == 0)
    return NULL;
  else
   return e_expr;
}
void _cc(continuation *c, void *expr) {
  memmove(c->rsp, c->stack, c->stacklen);
  e_expr = expr;
  longjmp(c->cont_reg, 1);
}
void call_continuation(continuation *c, void *expr) {
  char base = 0;
  volatile void *q = &base;
  int i = 1;
  if (q > c->rsp) {
      i = (q - c->rsp) % 64U + 1;
  }
  volatile void *p = alloca(64*i);
  _cc(c, expr);
}
void free_continuation(continuation *c) {
  free(c->stack);
}
