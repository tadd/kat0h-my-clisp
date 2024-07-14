CC=clang
CFLAGS=-O0 -ggdb3
OBJS=main.o continuation.o

all: scm

%.o: %.c continuation.h
	$(CC) $(CFLAGS) -c $<

scm: $(OBJS)
	$(CC) $(CFLAGS) $^ -o $@

clean:
	rm -f *.o scm

%.analyze: %.c
	$(CC) $(CFLAGS) --analyze -c $< -o /dev/null

analyze: $(OBJS:.o=.analyze)

.PHONY: clean analyze
