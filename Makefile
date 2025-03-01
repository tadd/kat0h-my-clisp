CC = gcc
CFLAGS=-O3 -flto=auto -fno-omit-frame-pointer

all: main.o continuation.o
	$(CC) $(CFLAGS) -o scm main.o continuation.o
main.o: main.c main.h continuation.o
	$(CC) $(CFLAGS) -c main.c
continuation.o: continuation.c continuation.h
	$(CC) $(CFLAGS) -c continuation.c
clean:
	rm -rf main.o scm
tags:
	ctags -R .
