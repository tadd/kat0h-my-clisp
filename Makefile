CC=clang
CFLAGS=-Og -ggdb3 $(XCFLAGS) #-fno-omit-frame-pointer
ubsan_flags=-fsanitize=undefined,address -O2 #-fomit-frame-pointer
OBJS=main.o

all: lisp

test:
	sample/test.sh

%.o: %.c
	$(CC) $(CFLAGS) -c $<

%.ubsan.o: %.c
	$(CC) $(CFLAGS) $(ubsan_flags) -c $< -o $@

lisp: $(OBJS)
	$(CC) $(CFLAGS) $^ -o $@

ubsan: lisp-ubsan
lisp-ubsan: $(OBJS:.o=.ubsan.o)
	$(CC) $(CFLAGS) $(ubsan_flags) $^ -o $@

clean:
	rm -f *.o lisp lisp-*

%.analyze: %.c
	$(CC) $(CFLAGS) --analyze -c $< -o /dev/null

analyze: $(OBJS:.o=.analyze)

.PHONY: clean analyze ubsan test
