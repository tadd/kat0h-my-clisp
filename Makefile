CC=clang
CFLAGS=-O3 -flto=auto -fno-omit-frame-pointer -ggdb3
OBJS=continuation.o main.o

all: lisp

%.o: %.c continuation.h
	$(CC) $(CFLAGS) -c $<

lisp: $(OBJS)
	$(CC) $(CFLAGS) $^ -o $@

test: lisp
	./lisp "`cat sample/callcc.scm`"

clean:
	rm -f *.o lisp

%.analyze: %.c
	$(CC) $(CFLAGS) --analyze -c $< -o /dev/null

analyze: $(OBJS:.o=.analyze)

.PHONY: clean analyze test
