CC = gcc
CFLAGS = -Og -ggdb3
OBJS = main.o continuation.o

all: scm

scm: $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c $<

main.o: main.h
continuation.o: continuation.h

clean:
	rm -f *.o scm

%.analyze: %.c
	$(CC) $(CFLAGS) --analyzer -c $< -o /dev/null

analyze: $(OBJS:.o=.analyze)

tags:
	ctags -R .

.PHONY: clean analyze
