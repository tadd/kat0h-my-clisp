CC = gcc
CFLAGS=-O0 -ggdb3
OBJS=main.o continuation.o

all: scm

scm: $(OBJS)
	$(CC) $(CFLAGS) $^ -o $@

%.o: %.c
	$(CC) $(CFLAGS) -c $<

main.o: main.h
continuation.o: continuation.h

clean:
	rm -f *.o scm

tags:
	ctags -R .

%.analyze: %.c
	$(CC) $(CFLAGS) --analyze -c $< -o /dev/null

analyze: $(OBJS:.o=.analyze)

.PHONY: all clean tags analyze
