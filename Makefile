CC = gcc
CFLAGS = -Og -ggdb3 -fno-omit-frame-pointer $(XCFLAGS)
ubsan_flags = -fsanitize=undefined,address -fomit-frame-pointer -O2
OBJS = main.o continuation.o

all: scm

scm: $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c $<

%.ubsan.o: %.c
	$(CC) $(CFLAGS) $(ubsan_flags) -c $< -o $@

main.*o: main.h
continuation.*o: continuation.h

ubsan: scm-ubsan
scm-ubsan: $(OBJS:.o=.ubsan.o)
	$(CC) $(CFLAGS) $(ubsan_flags) $^ -o $@

clean:
	rm -f *.o scm scm-*

%.analyze: %.c
	$(CC) $(CFLAGS) --analyzer -c $< -o /dev/null

analyze: $(OBJS:.o=.analyze)

tags:
	ctags -R .

.PHONY: clean analyze ubsan
