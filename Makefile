CC=clang
CFLAGS=-O3 -ggdb3
OBJS=continuation.o main.o

all: lisp

%.o: %.c continuation.h
	$(CC) $(CFLAGS) -c $<

lisp: $(OBJS)
	$(CC) $(CFLAGS) $^ -o $@

clean:
	rm -f *.o lisp

%.analyze: %.c
	$(CC) $(CFLAGS) --analyze -c $< -o /dev/null

analyze: $(OBJS:.o=.analyze)

.PHONY: clean analyze
