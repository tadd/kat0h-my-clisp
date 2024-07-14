#include <stdlib.h>
#include <string.h>
#include <setjmp.h>
#include <string.h>
#include "continuation.h"
extern volatile void *main_rbp;
static void *e_expr;

void *xmalloc(size_t size);

void init_continuation(volatile void *rbp) {
  main_rbp = rbp;
}
void *get_continuation(continuation *c) {
  GETRSP(c->rsp);
  c->stacklen = main_rbp - c->rsp + 1;
  c->stack = xmalloc(c->stacklen);
  memmove((void *) c->stack, (void *) c->rsp, c->stacklen);
  if (setjmp(c->cont_reg) == 0)
    return NULL;
  else
   return e_expr;
}
void _cc(continuation *c, void *expr) {
  memmove((void *) c->rsp, (void *) c->stack, c->stacklen);
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
  free((void *) c->stack);
}
