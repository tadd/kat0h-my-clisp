#include "main.h"
#include "continuation.h"

#define MEMMOVE(dst, src, n) do { \
        uint8_t *d = dst, *s = src; \
        for (unsigned long i = n; i > 0; i--) \
            *d++ = *s++; \
    } while (0)

expr *mk_continuation_expr(continuation *cont) {
  expr *e = xmalloc(sizeof(expr));
  TYPEOF(e) = CONTINUATION;
  E_CONTINUATION(e) = cont;
  return e;
}
void init_continuation(void *rbp) { main_rbp = rbp; }
void *get_continuation(continuation *c) {
  void *rsp;
  GETRSP(rsp);
  c->rsp = rsp;
  c->stacklen = main_rbp - rsp + 1;
  c->stack = malloc(sizeof(char) * c->stacklen);
  MEMMOVE(c->stack, c->rsp, c->stacklen);
  if (setjmp(c->cont_reg) == 0)
    return NULL;
  else
    return e_expr;
}
void _cc(continuation *c, void *expr) {
  MEMMOVE(c->rsp, c->stack, c->stacklen);
  e_expr = expr;
  longjmp(c->cont_reg, 1);
}
void call_continuation(continuation *c, void *expr) {
  volatile void *q = 0;
  do {
    q = alloca(16);
  } while (q > c->rsp);
  _cc(c, expr);
}
void free_continuation(continuation *c) { free(c->stack); }
expr *ifunc_callcc(expr *args, frame *env) {
  if (cell_len(E_CELL(args)) != 1)
    throw("call/cc error: invalid number of arguments");
  expr *lmd = eval(CAR(args), env);
  if (TYPEOF(lmd) != LAMBDA)
    throw("call/cc error: not lambda");
  continuation *cont = xmalloc(sizeof(continuation));
  expr *r = get_continuation(cont);
  if (r == NULL) {
    // lambdaにcontinuationを渡して実行
    return eval_lambda(
        E_LAMBDA(lmd),
        E_CELL(mk_cell_expr(mk_continuation_expr(cont), mk_empty_cell_expr())),
        env);
  } else {
    // continuationが呼ばれた場合
    return r;
  }
}
