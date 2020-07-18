# Concurrent Servers

Different approaches of socket servers to practice with.

## Dependencies

* <b> Environment: </b> Linux Ubuntu 18.04.4 LTS

* <b> Libraries: </b>
  * [pthread](https://www.cs.cmu.edu/afs/cs/academic/class/15492-f07/www/pthreads.html)
  * [netinet/in](http://manpages.ubuntu.com/manpages/trusty/man7/in.h.7posix.html)
  * [libuv](http://docs.libuv.org/en/v1.x/design.html)
    * To download: <code> sudo apt-get install -y libuv-dev </code>
  * [sys/socket](http://manpages.ubuntu.com/manpages/trusty/man7/sys_socket.h.7posix.html)
  * [sys/epoll](https://man7.org/linux/man-pages/man7/epoll.7.html)
  * [sys/select](https://man7.org/linux/man-pages/man2/select.2.html)

<b> Note: </b> There is no detailed explanation of the libraries described above. You may need to check what they are used for before starting out. I provided introductory links and if they are not enough, please search on Google for more details.

## Sequential Server

Our first server is a simple sequential server that does not use any special library besides POSIX for sockets. This server can serve connection for only one client at a moment. When a client is connected to the server, sequential server goes into a busy state and does not listen new connections until the current client is done. Hence, the other clients in the waiting state has to wait until serving is done.

This server obviously is not concurrent, and does not scale well for busy servers.

## Simple Threaded Server

Previous server implies the emergence of concurrency because we waste lots of our resource in busy-waiting even though we can handle with many connections simultaneously. Our second server uses pthread library of C and creates one thread per client. Modern OSes are good at handling with conccurency at CPU level, so this design outlines the previous server, however it also has some drawbacks.

Using one thread per client may lead to overuse of CPU resources for a long period of time. This scenario can also be extended to DoS attacks. Imagine 100.000s of threads running at the same time and using resources for a long time period. Context switching and thread scheduling can be very costly at this moment. There are various solutions to this. One of them is using <b>thread pools</b>.

## Select Server

Select is a POSIX module for standard UNIX API. It helps to prevent the problem mentioned in the previous server. It allows a single thread to "watch" a non-trivial number of file descriptors for changes, without needlessly spinning in a polling loop. Select server introduces new items under concurrent servers such as event-driven and callback-based programming, this can also be considered as asynchronous programming. Of course, select server has its own limitations. The most significant limitation of select server is the limited file descriptor set size. Also, the bad performance issue is a bit more subtle, but still very serious. Note that when select returns, the information it provides to the caller is the number of "ready" descriptors, and the updated descriptor sets. The descriptor sets map from descriptor to "ready/not ready" but they don't provide a way to iterate over all the ready descriptors efficiently.

## Epoll Server

Epoll is the Linux's solution to the high volume I/O event notification problem described above. The key to epoll's efficiency is greater cooperation from the kernel. Instead of using a file descriptor set, epoll_wait fills a buffer with events that are currently ready. Only the ready events are added to the buffer, so there is no need to iterate over all the currently watched file descriptors in the client. This changes the process of discovering which descriptors are ready from O(N) in select's case to O(1).

## libuv Server

There are various libraries for abstraction of event-driven loops, one of them is libuv. libuv is written in C, which makes it highly portable and very suitable for tying into high-level languages like JavaScript and Python. For the previous servers, the event loop was explicit in the main function; when using libuv, the loop is usually hidden inside the library itself, and user code just registers event handlers and runs the loop. Furthermore, libuv will use the fastest event loop implementation for a given platform: for Linux this is epoll.

prime server is an example of libuv where clients sends a number to check if it is a prime number or not.

## Utils

Some common functions used in all of the servers are packed into an utils header. Also, a simple spammer code is added to measure the resources spent by threads. Run that spammer with large amount of threads to understand resource usage.

## Test

To mimic the client operations, there are two python scripts that behaves as clients and run some assertions related to functionality of servers. Simply, To test, start the servers on a specific port and run python scripts on the same port number.
