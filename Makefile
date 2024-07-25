CC=clang
CFLAGS=-Og -ggdb3 -fno-omit-frame-pointer $(XCFLAGS)
ubsan_flags=-fsanitize=undefined,address -O2 -fomit-frame-pointer
OBJS=main.o

all: lisp

test:
	sample/test.sh

%.o: %.c
	$(CC) $(CFLAGS) -c $<

%.ubsan.o: %.c
	$(CC) $(ubsan_flags) $(CFLAGS) -c $< -o $@

lisp: $(OBJS)
	$(CC) $(CFLAGS) $^ -o $@

ubsan: lisp-ubsan
lisp-ubsan: $(OBJS:.o=.ubsan.o)
	$(CC) $(ubsan_flags) $(CFLAGS) $^ -o $@

clean:
	rm -f *.o lisp lisp-*

%.analyze: %.c
	$(CC) $(CFLAGS) --analyze -c $< -o /dev/null

analyze: $(OBJS:.o=.analyze)

.PHONY: clean analyze ubsan test
