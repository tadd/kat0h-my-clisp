#ifndef CONTINUATION_H
#define CONTINUATION_H

#include <alloca.h>
#include <setjmp.h>
#include <stddef.h>
typedef struct {
  volatile void *stack;
  unsigned long stacklen;
  volatile void *rsp;
  jmp_buf cont_reg;
} continuation;

void init_continuation(volatile void *rbp);
#define GETRSP(rsp) asm volatile("mov %%rsp, %0" : "=r"(rsp));
#define GETRBP(rbp) asm volatile("mov %%rbp, %0" : "=r"(rbp));
#define INIT_CONTINUATION()                                                    \
  {                                                                            \
    volatile char base = 0;                                                    \
    main_rbp = &base;                                                          \
  }
void *get_continuation(continuation *c);
void call_continuation(continuation *c, void *expr);
void free_continuation(continuation *c);

#endif
