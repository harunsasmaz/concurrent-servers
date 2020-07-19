CC = gcc
CCFLAGS = -std=gnu99 -Wall -O3 -g -DNDEBUG -pthread
LDFLAGS = -lpthread -pthread

LDLIBUV = -luv -Wl,-rpath=/usr/local/lib

EXECUTABLES = \
	sequential-server \
	select-server \
	epoll-server \
	uv-server \
	uv-sleep-timer \
	uv-work-timer \
	uv-isprime-server \
	thread-spammer \
	blocking-listener \
	nonblocking-listener \
	simple-threaded-server

all: $(EXECUTABLES)

sequential-server: utils/utils.c sequential-server.c
	$(CC) $(CCFLAGS) $^ -o $@ $(LDFLAGS)

select-server: utils/utils.c multithread-servers/select-server.c
	$(CC) $(CCFLAGS) $^ -o $@ $(LDFLAGS)

simple-threaded-server: utils/utils.c multithread-servers/simple-threaded-server.c
	$(CC) $(CCFLAGS) $^ -o $@ $(LDFLAGS)

epoll-server: utils/utils.c multithread-servers/epoll-server.c
	$(CC) $(CCFLAGS) $^ -o $@ $(LDFLAGS)

uv-server: utils/utils.c libuv-servers/uv-server.c
	$(CC) $(CCFLAGS) $^ -o $@ $(LDFLAGS) $(LDLIBUV)

uv-sleep-timer: utils/utils.c libuv-servers/uv-sleep-timer.c
	$(CC) $(CCFLAGS) $^ -o $@ $(LDFLAGS) $(LDLIBUV)

uv-work-timer: utils/utils.c libuv-servers/uv-work-timer.c
	$(CC) $(CCFLAGS) $^ -o $@ $(LDFLAGS) $(LDLIBUV)

uv-isprime-server: utils/utils.c libuv-servers/uv-isprime-server.c
	$(CC) $(CCFLAGS) $^ -o $@ $(LDFLAGS) $(LDLIBUV)

thread-spammer: utils/thread-spammer.c
	$(CC) $(CCFLAGS) $^ -o $@ $(LDFLAGS)

blocking-listener: utils/utils.c listeners/blocking-listener.c
	$(CC) $(CCFLAGS) $^ -o $@ $(LDFLAGS)

nonblocking-listener: utils/utils.c listeners/nonblocking-listener.c
	$(CC) $(CCFLAGS) $^ -o $@ $(LDFLAGS)

.PHONY: clean format

clean:
	rm -f $(EXECUTABLES) *.o

format:
	clang-format -style=file -i *.c *.h