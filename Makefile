CC = gcc
CFLAGS=-O3 -flto=auto -fno-omit-frame-pointer -ggdb3
OBJS=main.o continuation.o

all: scm

scm: $(OBJS)
	$(CC) $(CFLAGS) $^ -o $@

%.o: %.c
	$(CC) $(CFLAGS) -c $<

main.o: main.h
continuation.o: continuation.h

test: scm
	./$< "`cat sample/callcc.scm`"

clean:
	rm -f *.o scm

tags:
	ctags -R .

%.analyze: %.c
	$(CC) $(CFLAGS) --analyze -c $< -o /dev/null

analyze: $(OBJS:.o=.analyze)

.PHONY: all clean tags analyze test
