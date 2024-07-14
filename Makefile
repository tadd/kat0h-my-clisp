CC=clang
CFLAGS=-O3 -flto=auto -fno-omit-frame-pointer -ggdb3
OBJS=main.o continuation.o

all: scm

%.o: %.c continuation.h
	$(CC) $(CFLAGS) -c $<

scm: $(OBJS)
	$(CC) $(CFLAGS) $^ -o $@

test: scm
	./$< "`cat sample/callcc.scm`"

clean:
	rm -f *.o scm

%.analyze: %.c
	$(CC) $(CFLAGS) --analyze -c $< -o /dev/null

analyze: $(OBJS:.o=.analyze)

.PHONY: clean analyze test
