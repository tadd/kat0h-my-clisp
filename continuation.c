#include "main.h"
#include "continuation.h"
static void *main_rbp;

expr *mk_continuation_expr(continuation *cont) {
  expr *e = xmalloc(sizeof(expr));
  TYPEOF(e) = CONTINUATION;
  E_CONTINUATION(e) = cont;
  return e;
}
int get_continuation(continuation *c) {
  void *rsp;
  GETRSP(rsp);
  c->rsp = rsp;
  c->stacklen = main_rbp - rsp + 1;
  c->stack = malloc(sizeof(char) * c->stacklen);
  char *dst = c->stack;
  char *src = c->rsp;
  for (int i = c->stacklen; 0 <= --i;)
    *dst++ = *src++;
  return setjmp(c->cont_reg);
}
void _cc(continuation *c, int val) {
  char *dst = c->rsp;
  char *src = c->stack;
  for (int i = c->stacklen; 0 <= --i;)
    *dst++ = *src++;
  longjmp(c->cont_reg, val);
}
void call_continuation(continuation *c, int val) {
  volatile void *q = 0;
  do {
    q = alloca(16);
  } while (q > c->rsp);
  _cc(c, val);
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
