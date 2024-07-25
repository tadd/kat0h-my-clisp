CC=clang
CFLAGS=-Og -ggdb3 -fno-omit-frame-pointer $(XCFLAGS)
OBJS=main.o

all: lisp

%.o: %.c
	$(CC) $(CFLAGS) -c $<

lisp: $(OBJS)
	$(CC) $(CFLAGS) $^ -o $@

clean:
	rm -f *.o lisp

%.analyze: %.c
	$(CC) $(CFLAGS) --analyze -c $< -o /dev/null

analyze: $(OBJS:.o=.analyze)

.PHONY: clean analyze
