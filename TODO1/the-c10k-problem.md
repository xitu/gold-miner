> * 原文地址：[The C10K problem](http://www.kegel.com/c10k.html)
> * 原文作者：[www.kegel.com](http://www.kegel.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-c10k-problem.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-c10k-problem.md)
> * 译者：
> * 校对者：

# The C10K problem

It's time for web servers to handle ten thousand clients simultaneously, don't you think? After all, the web is a big place now.

现在 web 服务器能够同时处理上万请求,难道不是吗?毕竟如今的网络将会有很大的发展空间.

And computers are big, too. You can buy a 1000MHz machine with 2 gigabytes of RAM and an 1000Mbit/sec Ethernet card for $1200 or so. Let's see - at 20000 clients, that's 50KHz, 100Kbytes, and 50Kbits/sec per client. It shouldn't take any more horsepower than that to take four kilobytes from the disk and send them to the network once a second for each of twenty thousand clients. (That works out to $0.08 per client, by the way. Those $100/client licensing fees some operating systems charge are starting to look a little heavy!) So hardware is no longer the bottleneck.

计算机也同样强大.你可以花 $1200 买一台 1000MHz,2G 内存和1000Mbits/sec的网卡的机器.让我们来看看-- 20000 客户端,每个客户端 50KHz, 1000Kb 和每秒 50Kb,那没有什么比这每两万个客户端的每个每秒从磁盘中取出4千字节并将它们每秒发送到网络上去更消耗资源了.(顺便说一下,每个客户端 $0.0.8,一些操作系统收费的每个客户端 $100 的许可费看起来有点沉重)所以硬件不再是一种瓶颈.

In 1999 one of the busiest ftp sites, cdrom.com, actually handled 10000 clients simultaneously through a Gigabit Ethernet pipe. As of 2001, that same speed is now [being offered by several ISPs](http://www.senteco.com/telecom/ethernet.htm), who expect it to become increasingly popular with large business customers.

在1999年,最繁忙的 ftp 网站之一, cdrom.com, 实际上通过一个千兆以太网网卡同时处理 10000个客户端.截至2001年,现在相同的速度也被[ISP 提供](http://www.senteco.com/telecom/ethernet.htm),他们希望它变得越来越受大型企业客户的欢迎.

And the thin client model of computing appears to be coming back in style - this time with the server out on the Internet, serving thousands of clients.

轻量级的客户端计算模型似乎又开始变得流行起来了 - 服务器在互联网上运行,为数千个客户提供服务.

With that in mind, here are a few notes on how to configure operating systems and write code to support thousands of clients. The discussion centers around Unix-like operating systems, as that's my personal area of interest, but Windows is also covered a bit.

基于以上的一些考虑,这有一些关于如何配置操作系统或者编写支持数千客户端的代码问题提出了一些注意点. 讨论的中心的主要是围绕着类Unix操作系统,因为这是我个人感兴趣的领域,但是Windows也会涉及一点.


## Contents

- [The C10K problem](#the-c10k-problem)
- [C10K问题](#the-c10k-problem)
  - [Contents](#contents)
  - [内容](#contents)
  - [Related Sites](#related-sites)
  - [相关网站](#related-sites)
  - [Book to Read First](#book-to-read-first)
  - [预读书籍](#book-to-read-first)
    - [I/O frameworks](#io-frameworks)
    - [I/O 框架](#io-frameworks)
    - [I/O Strategies](#io-strategies)
    - [I/O 策略](#io-strategies)
    - [1. Serve many clients with each thread, and use nonblocking I/O and **level-triggered** readiness notification](#1-serve-many-clients-with-each-thread-and-use-nonblocking-io-and-level-triggered-readiness-notification)
    - [1. 一个线程服务多个客户端,使用非阻塞 IO 和**水平触发**的就绪通知](#1-serve-many-clients-with-each-thread-and-use-nonblocking-io-and-level-triggered-readiness-notification)
    - [2. Serve many clients with each thread, and use nonblocking I/O and readiness **change** notification](#2-serve-many-clients-with-each-thread-and-use-nonblocking-io-and-readiness-change-notification)
    - [2. 一个线程服务多个客户端,使用非阻塞 IO 和就绪**改变**通知](#2-serve-many-clients-with-each-thread-and-use-nonblocking-io-and-readiness-change-notification)
    - [3. Serve many clients with each server thread, and use asynchronous I/O](#3-serve-many-clients-with-each-server-thread-and-use-asynchronous-io)
    - [3. 一个线程服务多个客户端,使用异步 I/O](#3-serve-many-clients-with-each-server-thread-and-use-asynchronous-io)
    - [4. Serve one client with each server thread](#4-serve-one-client-with-each-server-thread)
    - [4. 一个线程服务一个客户端](#4-serve-one-client-with-each-server-thread)
      - [LinuxThreads](#linuxthreads)
      - [Linux线程](#linuxthreads)
      - [NGPT: Next Generation Posix Threads for Linux](#ngpt-next-generation-posix-threads-for-linux)
      - [NGPT: Linux的下一代 Posix 线程](#ngpt-next-generation-posix-threads-for-linux)
      - [NPTL: Native Posix Thread Library for Linux](#nptl-native-posix-thread-library-for-linux)
      - [NPTL: Linux原生的 Posix 线程库](#nptl-native-posix-thread-library-for-linux)
      - [FreeBSD threading support](#freebsd-threading-support)
      - [FreeBSD 线程支持](#freebsd-threading-support)
      - [NetBSD threading support](#netbsd-threading-support)
      - [NetBSD 线程支持](#netbsd-threading-support)
      - [Solaris threading support](#solaris-threading-support)
      - [Solaris 线程支持](#solaris-threading-support)
      - [Java threading support in JDK 1.3.x and earlier](#java-threading-support-in-jdk-13x-and-earlier)
      - [JDK 1.3.x及更早版本中的Java线程支持](#java-threading-support-in-jdk-13x-and-earlier)
      - [Note: 1:1 threading vs. M:N threading](#note-11-threading-vs-mn-threading)
      - [注意：1:1 线程与 M:N线程](#note-11-threading-vs-mn-threading)
    - [5. Build the server code into the kernel](#5-build-the-server-code-into-the-kernel)
    - [5. 将服务端代码构建到内核中](#5-build-the-server-code-into-the-kernel)
  - [Bring the TCP stack into userspace](#bring-the-tcp-stack-into-userspace)
  - [将 TCP 协议栈带入用户空间](#bring-the-tcp-stack-into-userspace)
  - [Comments](#comments)
  - [评论](#comments)
  - [Limits on open filehandles](#limits-on-open-filehandles)
  - [打开文件句柄的限制](#limits-on-open-filehandles)
  - [Limits on threads](#limits-on-threads)
  - [线程限制](#limits-on-threads)
  - [Java issues](#java-issues)
  - [Java问题](#java-issues)
  - [Other tips](#other-tips)
  - [其他建议](#other-tips)
    - [Other limits](#other-limits)
    - [其他限制](#other-limits)
    - [Kernel Issues](#kernel-issues)
    - [内核问题](#kernel-issues)
    - [Measuring Server Performance](#measuring-server-performance)
    - [测试服务性能](#measuring-server-performance)
  - [Examples](#examples)
  - [例子](#examples)
    - [Interesting select()-based servers](#interesting-select-based-servers)
    - [有趣的基于 select() 的服务器](#interesting-select-based-servers)
    - [Interesting /dev/poll-based servers](#interesting-devpoll-based-servers)
    - [有趣的基于 /dev/poll 的服务器](#interesting-devpoll-based-servers)
    - [Interesting epoll-based servers](#interesting-epoll-based-servers)
    - [有趣的基于 epoll 的服务器](#interesting-epoll-based-servers)
    - [Interesting kqueue()-based servers](#interesting-kqueue-based-servers)
    - [有趣的基于 kqueue() 的服务器](#interesting-kqueue-based-servers)
    - [Interesting realtime signal-based servers](#interesting-realtime-signal-based-servers)
    - [有趣的基于实时信号的服务器](#interesting-realtime-signal-based-servers)
    - [Interesting thread-based servers](#interesting-thread-based-servers)
    - [有趣的基于线程的服务器](#interesting-thread-based-servers)
    - [Interesting in-kernel servers](#interesting-in-kernel-servers)
    - [有趣的内核服务器](#interesting-in-kernel-servers)
    - [Other interesting links](#other-interesting-links)
    - [其他有趣的链接](#other-interesting-links)


## Related Sites

## 相关网站

See Nick Black's execellent [Fast UNIX Servers](http://dank.qemfd.net/dankwiki/index.php/Network_servers) page for a circa-2009 look at the situation.

参阅下 Nick Black 的杰出的 [快速的Unix服务器](http://dank.qemfd.net/dankwiki/index.php/Network_servers)页面,了解大约2009的情况

In October 2003, Felix von Leitner put together an excellent [web page](http://bulk.fefe.de/scalability/) and [presentation](http://bulk.fefe.de/scalable-networking.pdf) about network scalability, complete with benchmarks comparing various networking system calls and operating systems. One of his observations is that the 2.6 Linux kernel really does beat the 2.4 kernel, but there are many, many good graphs that will give the OS developers food for thought for some time. (See also the [Slashdot](http://developers.slashdot.org/developers/03/10/19/0130256.shtml?tid=106&tid=130&tid=185&tid=190) comments; it'll be interesting to see whether anyone does followup benchmarks improving on Felix's results.)

在2003年10月,Felix von Leitner 整理了一个优秀的关于网络可扩展性的[网站](http://bulk.fefe.de/scalability/)和[演示](http://bulk.fefe.de/scalable-networking.pdf),完成了多种不同的网络系统调用和操作系统的性能比较.其中一个发现是 linux 2.6 内核击败了 2.4 内核,当然这里有很多很好的图片会让操作系统开发人员在平时提供点想法.(另见[Slashdot](http://developers.slashdot.org/developers/03/10/19/0130256.shtml?tid=106&tid=130&tid=185&tid=190)]的评论;看看是否有人对基于菲利克斯的基准进行改进将会很有趣结果).



## Book to Read First

## 预读书籍

If you haven't read it already, go out and get a copy of [Unix Network Programming : Networking Apis: Sockets and Xti (Volume 1)](http://www.amazon.com/exec/obidos/ASIN/013490012X/) by the late W. Richard Stevens. It describes many of the I/O strategies and pitfalls related to writing high-performance servers. It even talks about the ['thundering herd'](http://www.citi.umich.edu/projects/linux-scalability/reports/accept.html) problem. And while you're at it, go read [Jeff Darcy's notes on high-performance server design](http://pl.atyp.us/content/tech/servers.html).

如果你没有阅读过the late W. Richard Stevens的[Unix网络编程: 网络Apis:套接字和Xti（第1卷)](http://www.amazon.com/exec/obidos/ASIN/013490012X/)的拷贝,请尽快获取一份,它描述了很多的于 I/O 策略和编写高性能服务器的陷阱.它甚至谈到了 ['thundering herd'](http://www.citi.umich.edu/projects/linux-scalability/reports/accept.html)问题.当你在阅读它时,请阅读 [Jeff Darcy写的关于高性能服务器设计](http://pl.atyp.us/content/tech/servers.html).

(Another book which might be more helpful for those who are *using* rather than *writing* a web server is [Building Scalable Web Sites](http://www.amazon.com/gp/product/0596102356) by Cal Henderson.)

(另外一本书[构建可扩展的网站](http://www.amazon.com/gp/product/0596102356)可能会对**使用**而不是**编写**一个web服务器的人会有帮助)

### I/O frameworks

### I/O 框架

Prepackaged libraries are available that abstract some of the techniques presented below, insulating your code from the operating system and making it more portable.

以下提供了几个预打包的库,它们抽象了下面介绍的一些技术,使代码与操作系统隔离,并使其更具可移植性.


*   [ACE](http://www.cs.wustl.edu/~schmidt/ACE.html), a heavyweight C++ I/O framework, contains object-oriented implementations of some of these I/O strategies and many other useful things. In particular, his Reactor is an OO way of doing nonblocking I/O, and Proactor is an OO way of doing asynchronous I/O.

*   [ACE](http://www.cs.wustl.edu/~schmidt/ACE.html),一个重量级的 C++ I/O 框架,包含一些用面对对象的思想实现的 I/O 策略和许多其他有用的事情.特别的,他的 Reactor 以面对对象的方式执行非阻塞 I/O,Proactor 是一种面对对象处理异步 I/O 的的方式.

*   [ASIO](http://asio.sf.net) is an C++ I/O framework which is becoming part of the Boost library. It's like ACE updated for the STL era.

*   [ASIO](http://asio.sf.net) 是一个 C++ I/O 框架,它正在成为Boost的一部分.这就像是为 STL 时代更新的ACE.

*   [libevent](http://monkey.org/~provos/libevent) is a lightweight C I/O framework by Niels Provos. It supports kqueue and select, and soon will support poll and epoll. It's level-triggered only, I think, which has both good and bad sides. Niels has [a nice graph of time to handle one event](http://monkey.org/~provos/libevent/libevent-benchmark.jpg) as a function of the number of connections. It shows kqueue and sys_epoll as clear winners.

*   [libevent](http://monkey.org/~provos/libevent) 是 Niels Provos 写的一个轻量级的 C I/O 框架.它支持 kqueue 和 select,即将支持 poll 和 epoll.我想它应该只采用了**水平触发**,这具有两面性.Niels给了一个图来说明时间和连接数目在处理一个事件上的功能,图中可以看出kqueue 和 sys_epoll 是明显的赢家.

*   My own attempts at lightweight frameworks (sadly, not kept up to date):

* 我自己在轻量级框架的尝试(可惜的是没有保持更新)

    *   [Poller](http://www.kegel.com/dkftpbench/Poller_bench.html) is a lightweight C++ I/O framework that implements a level-triggered readiness API using whatever underlying readiness API you want (poll, select, /dev/poll, kqueue, or sigio). It's useful for [benchmarks that compare the performance of the various APIs.](http://www.kegel.com/dkftpbench/Poller_bench.html) This document links to Poller subclasses below to illustrate how each of the readiness APIs can be used.

	 *   [Poller](http://www.kegel.com/dkftpbench/Poller_bench.html) 是一个轻量级的 C++ I/O 框架,它使用任何一种准备就绪API(poll, select, /dev/poll, kqueue, sigio)实现水平触发准备就绪API. [以其他多种 API 为基础测试](http://www.kegel.com/dkftpbench/Poller_bench.html),Poll的性能好的多.文档链到下面的Poller 子类,该链接文档的下面一部分说明了如何使用这些准备就绪API.
    
    *   [rn](http://www.kegel.com/rn/) is a lightweight C I/O framework that was my second try after Poller. It's lgpl (so it's easier to use in commercial apps) and C (so it's easier to use in non-C++ apps). It was used in some commercial products.

    *   [rn](http://www.kegel.com/rn/) 是一个轻量级的C I/O 框架,这是我在Poller之后的第二次尝试. 他使用lgpl(因此它更容易在商业应用程序中使用) 和 C(因此更容易在非 C++ 的产品中使用).如今它被应用在一些商业产品中.
    
*   Matt Welsh wrote [a paper](http://www.cs.berkeley.edu/~mdw/papers/events.pdf) in April 2000 about how to balance the use of worker thread and event-driven techniques when building scalable servers. The paper describes part of his Sandstorm I/O framework.

*   Matt Welsh 在2000年4月写了一篇关于如何在构建可扩展性服务时去平衡工作线程和事件驱动使用的[论文](http://www.cs.berkeley.edu/~mdw/papers/events.pdf),该论文描述了他的 Sandstorm I/O 框架.

*   [Cory Nelson's Scale! library](http://svn.sourceforge.net/viewcvs.cgi/*checkout*/int64/scale/readme.txt) - an async socket, file, and pipe I/O library for Windows

*   [Cory Nelson 的Scale!库](http://svn.sourceforge.net/viewcvs.cgi/*checkout*/int64/scale/readme.txt) - 一个Windows下的异步套接字, 文件, 和管道 I/O 库.

### I/O Strategies

### I/O 策略

Designers of networking software have many options. Here are a few:

网络软件的设计者有多种选择.这有一些:

*   Whether and how to issue multiple I/O calls from a single thread

* 是否以及如何在单个线程发出多个 I/O 调用

    *   Don't; use blocking/synchronous calls throughout, and possibly use multiple threads or processes to achieve concurrency

	 *    不处理;使用阻塞和同步调用,尽可能的使用多个线程和进程实现并发.
    
    *   Use nonblocking calls (e.g. write() on a socket set to O_NONBLOCK) to start I/O, and readiness notification (e.g. poll() or /dev/poll) to know when it's OK to start the next I/O on that channel. Generally only usable with network I/O, not disk I/O.

	 *   使用非阻塞调用(如,在一个socket write()上设置 O_NONBLOCK) 去启动 I/O,就绪通知(如,poll() 或则 /dev/poll)知道什么时候通道是 OK 的然后开启下一个 I/O.通常这只能用于网络 I/O,而不能用于磁盘 I/O.
    
    *   Use asynchronous calls (e.g. aio_write()) to start I/O, and completion notification (e.g. signals or completion ports) to know when the I/O finishes. Good for both network and disk I/O.

    *   使用异步调用(如,aio_write())去启动 I/O,完成通知(如,信号或完成端口)去通知 I/O 完成.这同时适用于网络和磁盘 I/O.

*   How to control the code servicing each client

*   如何控制每个客户的服务

    *   one process for each client (classic Unix approach, used since 1980 or so)

	*   一个进程服务一个客户(经典的 Unix 方法,从1980年左右就开始使用)
    
    *   one OS-level thread handles many clients; each client is controlled by:
	
	  * 一个系统级别线程服务多个客户;每个客户通过以下控制:
    
        *   a user-level thread (e.g. GNU state threads, classic Java with green threads)
       
        *   一个用户级别线程(如. GNU 状态线程, 带绿色线程的经典 java)
        
        *   a state machine (a bit esoteric, but popular in some circles; my favorite)

		 *   状态机(有点深奥，但在某些圈子里很受欢迎; 我的最爱)
        
        *   a continuation (a bit esoteric, but popular in some circles)
       
        *   continuation (有点深奥,但在某些圈子里很受欢迎)
        
        
    *   one OS-level thread for each client (e.g. classic Java with native threads)

	*   一个系统级线程服务单个客户(如,经典的带有原生线程的Java)
    
    *   one OS-level thread for each active client (e.g. Tomcat with apache front end; NT completion ports; thread pools)

    *   一个系统级线程服务每个活跃的客户(如. Tomcat与apache的前端;NT完成端口; 线程池)

*   Whether to use standard O/S services, or put some code into the kernel (e.g. in a custom driver, kernel module, or VxD)

*   是否使用标准系统服务,或者构建服务到内核中(如,在一些自定义驱动,内核模块,或者 VxD)

The following five combinations seem to be popular:

下边的5中组合似乎非常流行:

1.  Serve many clients with each thread, and use nonblocking I/O and **level-triggered** readiness notification

1.  一个线程服务多个客户端.使用非阻塞 I/O 和**水平触发**就绪通知.

2.  Serve many clients with each thread, and use nonblocking I/O and readiness **change** notification

2.  一个线程服务多个客户端.使用非阻塞 I/O 和就绪**更改**通知.

3.  Serve many clients with each server thread, and use asynchronous I/O

3.  一个线程服务多个客户端. 使用异步 I/O.

4.  serve one client with each server thread, and use blocking I/O

4.  一个线程服务多个客户端.使用阻塞 I/O

5.  Build the server code into the kernel

5.  将服务端代码构建到内核

### 1. Serve many clients with each thread, and use nonblocking I/O and **level-triggered** readiness notification

### 1. 一个线程服务多个客户端,使用非阻塞 IO 和**水平触发**就绪通知

... set nonblocking mode on all network handles, and use select() or poll() to tell which network handle has data waiting. This is the traditional favorite. With this scheme, the kernel tells you whether a file descriptor is ready, whether or not you've done anything with that file descriptor since the last time the kernel told you about it. (The name 'level triggered' comes from computer hardware design; it's the opposite of ['edge triggered'](#nb.edge). Jonathon Lemon introduced the terms in his [BSDCON 2000 paper on kqueue()](http://people.freebsd.org/~jlemon/papers/kqueue.pdf).)

... 在所有的网络句柄上都设置为非阻塞模式,使用 select() 或则 poll() 去告知哪个网络句柄处理有数据等待.此模型是最传统的.这种模式下,内核告诉你是否一个文件描述符就绪,自从上次内核告诉你它以来,你是否对该文件描述符做了任何事情.('水平触发'这个名词来自计算机硬件设计;它与['边缘触发'](#nb.edge)相反).Jonathon Lemon在他的[关于BSDCON 2000 paper kqueue()的论文](http://people.freebsd.org/~jlemon/papers/kqueue.pdf)中介绍了这些术语


Note: it's particularly important to remember that readiness notification from the kernel is only a hint; the file descriptor might not be ready anymore when you try to read from it. That's why it's important to use nonblocking mode when using readiness notification.

注意: 牢记来自内核的就绪通知只是一个提示,这一点尤为重要;当你尝试去读取文件描述符的时候,它可能没有就绪.这就是为什么需要在使用就绪通知时使用非阻塞模式的原因.

An important bottleneck in this method is that read() or sendfile() from disk blocks if the page is not in core at the moment; setting nonblocking mode on a disk file handle has no effect. Same thing goes for memory-mapped disk files. The first time a server needs disk I/O, its process blocks, all clients must wait, and that raw nonthreaded performance goes to waste.  

一个重要的瓶颈是 read()或 sendfile() 从磁盘块读取时,如果该页当前并不在内存中.在设置非阻塞模式的磁盘文件处理是没有影响的.内存映射磁盘文件也是如此.首先一个服务需要磁盘 I/O时,他的处理块,所有客户端必须等待,因此原生非线程性能将会被浪费了.

This is what asynchronous I/O is for, but on systems that lack AIO, worker threads or processes that do the disk I/O can also get around this bottleneck. One approach is to use memory-mapped files, and if mincore() indicates I/O is needed, ask a worker to do the I/O, and continue handling network traffic. Jef Poskanzer mentions that Pai, Druschel, and Zwaenepoel's 1999 [Flash](http://www.cs.rice.edu/~vivek/flash99/) web server uses this trick; they gave a talk at [Usenix '99](http://www.usenix.org/events/usenix99/technical.html) on it. It looks like mincore() is available in BSD-derived Unixes like [FreeBSD](http://www.freebsd.org/cgi/man.cgi?query=mincore) and Solaris, but is not part of the [Single Unix Specification](http://www.unix-systems.org/). It's available as part of Linux as of kernel 2.3.51, [thanks to Chuck Lever](http://www.citi.umich.edu/projects/citi-netscape/status/mar-apr2000.html).

这也就是异步 I/O 的目的,当然仅限于没有 AIO 的系统上,用多线程和多进程进行磁盘 I/O 也可能解决这个瓶颈.一种方法是使用内存映射文件,如果 mincore() 表示需要 I/O,让一个工作线程去进行 I/O 操作,并继续处理网络流量.Jef Poskanzer 提到 Pai, Druschel, and Zwaenepoel的1999 [Flash](http://www.cs.rice.edu/~vivek/flash99/) web服务器使用这个技巧;他们在[Usenix '99](http://www.usenix.org/events/usenix99/technical.html)发表了关于它的演讲.看起来 mincore() 在BSD-derived Unixes 上是可用的,如像[FreeBSD](http://www.freebsd.org/cgi/man.cgi?query=mincore)和Solaris,但它不是[单Unix规范](http://www.unix-systems.org/)的一部分.从kernel2.3.51 开始,它也开始是linux的一部分,[感谢Chuck Lever](http://www.citi.umich.edu/projects/citi-netscape/status/mar-apr2000.html).


But [in November 2003 on the freebsd-hackers list, Vivek Pei et al reported](http://marc.theaimsgroup.com/?l=freebsd-hackers&m=106718343317930&w=2) very good results using system-wide profiling of their Flash web server to attack bottlenecks. One bottleneck they found was mincore (guess that wasn't such a good idea after all) Another was the fact that sendfile blocks on disk access; they improved performance by introducing a modified sendfile() that return something like EWOULDBLOCK when the disk page it's fetching is not yet in core. (Not sure how you tell the user the page is now resident... seems to me what's really needed here is aio_sendfile().) The end result of their optimizations is a SpecWeb99 score of about 800 on a 1GHZ/1GB FreeBSD box, which is better than anything on file at spec.org.

但是在2003年十一月的 freebsd-hackers list, Vivek Pei 等人报道了使用他们的 Flash web服务器有一个很好的结果.然后在攻击其瓶颈,其中发现一个瓶颈是 mincore(猜测以后这不是一个好办法),另外一个就是 sendfile 阻塞磁盘访问;他们一种修改的 sendfile(),当他的访问磁盘页尚未处于核心状态时返回类似 EWOULDBLOCK 的内容,提升了性能.(不知道怎么告诉用户页现在是常驻的...在我看来真正需要的是aio_sendfile().)他们优化的最终结果是在 1GHZ/1GB 的FreeBSD盒子上 SpecWeb99 得分约为800,这比spec.org上的任何文件都要好.


There are several ways for a single thread to tell which of a set of nonblocking sockets are ready for I/O:


在非阻塞套接字的集合中,关于单一线程如何告知哪个套接字是准备就绪的,列出了几种方法

*   **The traditional select()**

*   **传统的 select()**

    Unfortunately, select() is limited to FD_SETSIZE handles. This limit is compiled in to the standard library and user programs. (Some versions of the C library let you raise this limit at user app compile time.)
    
	 不幸的, select() 限制了 FD_SETSIZE 的处理.这个限制被编译到标准库和用户程序中.(一些 C 库版本让你在编译应用程序的时候提示这个限制.)
    
    See [Poller_select](dkftpbench/doc/Poller_select.html) ([cc](dkftpbench/dkftpbench-0.44/Poller_select.cc), [h](dkftpbench/dkftpbench-0.44/Poller_select.h)) for an example of how to use select() interchangeably with other readiness notification schemes.
    
    参阅[Poller_select](dkftpbench/doc/Poller_select.html) ([cc](dkftpbench/dkftpbench-0.44/Poller_select.cc),[h](dkftpbench/dkftpbench-0.44/Poller_select.h))是一个如何使用 select() 与其他就绪通知模式交互的示例.
    
*   **The traditional poll()**

* 	 **传统的 poll()**

    There is no hardcoded limit to the number of file descriptors poll() can handle, but it does get slow about a few thousand, since most of the file descriptors are idle at any one time, and scanning through thousands of file descriptors takes time.
    
    对于 poll() 能处理的文件描述符数量的没有硬编码限制,但是当有上千连接时会变得慢,因为大多数文件描述符在某个时刻都是是空闲的,完全扫描成千上万个文件描述符会花费时间.
    
    Some OS's (e.g. Solaris 8) speed up poll() et al by use of techniques like poll hinting, which was [implemented and benchmarked by Niels Provos](http://www.humanfactor.com/cgi-bin/cgi-delegate/apache-ML/nh/1999/May/0415.html) for Linux in 1999.
    
    一些操作系统(像,Solaris 8)使用像 poll hinting 的技术加速了 poll() 等,Niels Provos 在1999年为Linux[实现和并利用基准测试程序测试](http://www.humanfactor.com/cgi-bin/cgi-delegate/apache-ML/nh/1999/May/0415.html).
    
    
    See [Poller_poll](dkftpbench/doc/Poller_poll.html) ([cc](dkftpbench/dkftpbench-0.44/Poller_poll.cc), [h](dkftpbench/dkftpbench-0.44/Poller_poll.h), [benchmarks](dkftpbench/Poller_bench.html)) for an example of how to use poll() interchangeably with other readiness notification schemes.
    
    参阅[Poller_poll](dkftpbench/doc/Poller_poll.html) ([cc](dkftpbench/dkftpbench-0.44/Poller_poll.cc),[h](dkftpbench/dkftpbench-0.44/Poller_poll.h), [benchmarks](dkftpbench/Poller_bench.html))是一个如何使用 poll() 与其他就绪通知模式交互的示例.
    
*   **/dev/poll**

*   **/dev/poll**

    This is the recommended poll replacement for Solaris.
    
    这是推荐在Solaris 代替poll的方法
    
    The idea behind /dev/poll is to take advantage of the fact that often poll() is called many times with the same arguments. With /dev/poll, you get an open handle to /dev/poll, and tell the OS just once what files you're interested in by writing to that handle; from then on, you just read the set of currently ready file descriptors from that handle.
    
    /dev/poll 的背后思想就是利用 poll() 在大部分的调用时使用相同的参数.使用/dev/poll,获取一个 /dev/poll 的文件描述符,然后把你关心的文件描述符写入到/dev/poll的描述符;然后,你就可以从该句柄中读取当前就绪文件描述符集.
    
    It appeared quietly in Solaris 7 ([see patchid 106541](http://sunsolve.sun.com/pub-cgi/retrieve.pl?patchid=106541&collection=fpatches)) but its first public appearance was in [Solaris 8](http://docs.sun.com:80/ab2/coll.40.6/REFMAN7/@Ab2PageView/55123?Ab2Lang=C&Ab2Enc=iso-8859-1); [according to Sun](http://www.sun.com/sysadmin/ea/poll.html), at 750 clients, this has 10% of the overhead of poll().
    
    它悄悄的出现在 Solaris 7 中([看 patchid 106541](http://sunsolve.sun.com/pub-cgi/retrieve.pl?patchid=106541&collection=fpatches)),但是它第一次公开现身是在[Solaris 8](http://docs.sun.com:80/ab2/coll.40.6/REFMAN7/@Ab2PageView/55123?Ab2Lang=C&Ab2Enc=iso-8859-1)中;[据 Sun 透露](http://www.sun.com/sysadmin/ea/poll.html),在750客户端的情况下,这只有 poll() 的10％的开销.
    
    
    Various implementations of /dev/poll were tried on Linux, but none of them perform as well as epoll, and were never really completed. /dev/poll use on Linux is not recommended.
    
    在Linux上尝试了 /dev/poll 的各种实现,但它们都没有像 epoll 一样高效,并且从未真正完成.不推荐在Linux上使用 /dev/poll.

    See [Poller_devpoll](dkftpbench/doc/Poller_devpoll.html) ([cc](dkftpbench/dkftpbench-0.44/Poller_devpoll.cc), [h](dkftpbench/dkftpbench-0.44/Poller_devpoll.h) [benchmarks](dkftpbench/Poller_bench.html) ) for an example of how to use /dev/poll interchangeably with many other readiness notification schemes. (Caution - the example is for Linux /dev/poll, might not work right on Solaris.)
    
    参阅[Poller_devpoll](dkftpbench/doc/Poller_devpoll.html) ([cc](dkftpbench/dkftpbench-0.44/Poller_devpoll.cc), [h](dkftpbench/dkftpbench-0.44/Poller_devpoll.h)[基础测试](dkftpbench/Poller_bench.html))是一个如何使用 /dev/poll 与其他就绪通知模式交互的示例.(注意 - 该示例适用于Linux /dev/poll,可能无法在 Solaris 上正常运行.)
    
*   **kqueue()**

*   **kqueue()**

    This is the recommended poll replacement for FreeBSD (and, soon, NetBSD).
    
    是在FreeBSD系统上推荐使用的代替poll的方法(很快,NetBSD).

    [See below.](#nb.kqueue) kqueue() can specify either edge triggering or level triggering.
    
    [看下边](#nb.kqueue) kqueue() 可以指定边缘触发或水平触发.

### 2. Serve many clients with each thread, and use nonblocking I/O and readiness **change** notification


### 2. 一个线程服务多个客户端, 使用非阻塞 IO 和就绪**改变**通知

Readiness change notification (or edge-triggered readiness notification) means you give the kernel a file descriptor, and later, when that descriptor transitions from _not ready_ to _ready_, the kernel notifies you somehow. It then assumes you know the file descriptor is ready, and will not send any more readiness notifications of that type for that file descriptor until you do something that causes the file descriptor to no longer be ready (e.g. until you receive the EWOULDBLOCK error on a send, recv, or accept call, or a send or recv transfers less than the requested number of bytes).


就绪改变通知(或边缘就绪通知)意味着你向内核提供文件描述符,然后,当该描述符从 _not ready_ 转换为 _ready_ 时,内核会以某种方式通知你.然后它假定你已知文件描述符已准备好,同时不会再对该描述符发送类似的就绪通知,直到你在描述符上进行一些操作使得该描述符不再就绪(例如,直到你收到 EWOULDBLOCK 错误为止)发送,接收或接受呼叫,或小于请求的字节数的发送或接收传输).



When you use readiness change notification, you must be prepared for spurious events, since one common implementation is to signal readiness whenever any packets are received, regardless of whether the file descriptor was already ready.


当你使用就绪改变通知时,你必须准备处理好虚假事件,因为最常见的实现是只要接收到任何数据包都发出就绪信号,而不管文件描述符是否准备就绪.

This is the opposite of "[level-triggered](#nb)" readiness notification. It's a bit less forgiving of programming mistakes, since if you miss just one event, the connection that event was for gets stuck forever. Nevertheless, I have found that edge-triggered readiness notification made programming nonblocking clients with OpenSSL easier, so it's worth trying.


这与"[水平触发](#nb)"就绪通知相反.它对编程错误的宽容度要低一些,因为如果你只错过一个事件,那么事件的连接就会永远停滞不前.尽管如此,我发现边缘触发的就绪通知能让使用OpenSSL编程非阻塞客户端变得更容易,因此还是值得尝试.



[[Banga, Mogul, Drusha '99]](http://www.cs.rice.edu/~druschel/usenix99event.ps.gz) described this kind of scheme in 1999.

[[Banga, Mogul, Drusha '99]](http://www.cs.rice.edu/~druschel/usenix99event.ps.gz)在1999年描述了这种类型的模式.


There are several APIs which let the application retrieve 'file descriptor became ready' notifications:

有几种API使应用程序检索"文件描述符准备就绪"通知：

*   **kqueue()** This is the recommended edge-triggered poll replacement for FreeBSD (and, soon, NetBSD).


* 	**kqueue()** 这是在FreeBSD(很快,NetBSD)系统上推荐使用边缘触发的方法.
    
    FreeBSD 4.3 and later, and [NetBSD-current as of Oct 2002](http://kerneltrap.org/node.php?id=472), support a generalized alternative to poll() called [kqueue()/kevent()](http://www.FreeBSD.org/cgi/man.cgi?query=kqueue&apropos=0&sektion=0&manpath=FreeBSD+5.0-current&format=html); it supports both edge-triggering and level-triggering. (See also [Jonathan Lemon's page](http://people.freebsd.org/~jlemon/) and his [BSDCon 2000 paper on kqueue()](http://people.freebsd.org/~jlemon/papers/kqueue.pdf).)
    
    FreeBSD 4.3和以后的版本,以及截至[2002年10月的NetBSD-current](http://kerneltrap.org/node.php?id=472)支持 poll() 的通用替代方法[kqueue()/ kevent()](http://www.FreeBSD.org/cgi/man.cgi?query=kqueue&apropos=0&sektion=0&manpath=FreeBSD+5.0-current&format=html);它同时支持边缘触发和水平触发.(另见[Jonathan Lemon的网页](http://people.freebsd.org/~jlemon/)和他的[BSDCon 2000 关于kqueue() 的论文](http://people.freebsd.org/~jlemon/papers/kqueue.pdf).)
    

    Like /dev/poll, you allocate a listening object, but rather than opening the file /dev/poll, you call kqueue() to allocate one. To change the events you are listening for, or to get the list of current events, you call kevent() on the descriptor returned by kqueue(). It can listen not just for socket readiness, but also for plain file readiness, signals, and even for I/O completion.
    
    与 /dev/poll 一样,你可以分配一个监听对象,不过不是打开文件/dev/poll,而是调用kqueue() 来获得.需要改变你正在监听的事件或者要获取当前事件的列表,可以在kqueue()返回的描述符上调用kevent().它不仅可以监听套接字就绪,还可以监听纯文件就绪,信号,甚至是 I/O 完成.
    
    **Note:** as of October 2000, the threading library on FreeBSD does not interact well with kqueue(); evidently, when kqueue() blocks, the entire process blocks, not just the calling thread.
    
    **注意:** 截至2000年10月,FreeBSD 上的线程库与 kqueue() 无法很好地交互; 因此,当kqueue() 阻塞时,整个进程都会阻塞,而不仅仅是调用kqueue()的线程.
    
    See [Poller_kqueue](dkftpbench/doc/Poller_kqueue.html) ([cc](dkftpbench/dkftpbench-0.44/Poller_kqueue.cc), [h](dkftpbench/dkftpbench-0.44/Poller_kqueue.h), [benchmarks](dkftpbench/Poller_bench.html)) for an example of how to use kqueue() interchangeably with many other readiness notification schemes.
    
    
    参阅[Poller_kqueue](dkftpbench/doc/Poller_kqueue.html) ([cc](dkftpbench/dkftpbench-0.44/Poller_kqueue.cc), [h](dkftpbench/dkftpbench-0.44/Poller_kqueue.h),[基础测试](dkftpbench/Poller_bench.html))是一个如何使用 kqueue() 与其他就绪通知模式交互的示例
    
    
    Examples and libraries using kqueue():
    
    使用 kqueue() 的示例和库:
    
    *   [PyKQueue](http://people.freebsd.org/~dwhite/PyKQueue/) - a Python binding for kqueue()

	  *   [PyKQueue](http://people.freebsd.org/~dwhite/PyKQueue/) - kqueue() 的 Python 绑定
    
    *   [Ronald F. Guilmette's example echo server](http://www.monkeys.com/kqueue/echo.c); see also [his 28 Sept 2000 post on freebsd.questions](http://groups.yahoo.com/group/freebsd-questions/message/223580).

    *   [Ronald F. Guilmette的示例echo服务器](http://www.monkeys.com/kqueue/echo.c);另外可以看看[他2000年9月28日写的关于freebsd.questions的帖子](http://groups.yahoo.com/group/freebsd-questions/message/223580).
    
*   **epoll**
*   **epoll**

    This is the recommended edge-triggered poll replacement for the 2.6 Linux kernel.
    
    这是Linux 2.6 的内核中推荐使用的边沿触发poll.

    On 11 July 2001, Davide Libenzi proposed an alternative to realtime signals; his patch provides what he now calls [/dev/epoll www.xmailserver.org/linux-patches/nio-improve.html](http://www.xmailserver.org/linux-patches/nio-improve.html). This is just like the realtime signal readiness notification, but it coalesces redundant events, and has a more efficient scheme for bulk event retrieval.
    
    
    2001年7月11日,Davide Libenzi 提出了实时信号的替代方案;他将他的补丁称之为[/dev/epoll www.xmailserver.org/linux-patches/nio-improve.html](http://www.xmailserver.org/linux-patches/nio-improve.html). 这就像实时的信号就绪通知一样,同时它可以合并冗余事件,并且具有更高效的批量事件检索的方法.

    
    Epoll was merged into the 2.5 kernel tree as of 2.5.46 after its interface was changed from a special file in /dev to a system call, sys_epoll. A patch for the older version of epoll is available for the 2.4 kernel.
    
    当接口从 /dev 中的特殊文件更改为系统调用 sys_epoll 后,Epoll就合并到2.5.46 版本的内核开发树中. 2.4 内核可以也使用旧版 epoll 的补丁.

    
    There was a lengthy debate about [unifying epoll, aio, and other event sources](http://marc.theaimsgroup.com/?l=linux-kernel&m=103607925020720&w=2) on the linux-kernel mailing list around Halloween 2002. It may yet happen, but Davide is concentrating on firming up epoll in general first.
    
    在2002年万圣节前后,linux 内核邮件列表就统一[epoll,aio和其他事件源的问题](http://marc.theaimsgroup.com/?l=linux-kernel&m=103607925020720&w=2)进行了长时间的争论.它也会发生,但Davide首先还是集中精力打造 epoll.
    
    
*   Polyakov's kevent (Linux 2.6+) News flash: On 9 Feb 2006, and again on 9 July 2006, Evgeniy Polyakov posted patches which seem to unify epoll and aio; his goal is to support network AIO. See:
    
*  Polyakov的 kevent(Linux 2.6+) 新闻报道: 2006年2月9日和2006年7月9日，Evgeniy Polyakov发布了补丁,似乎统一了epoll和aio;他的目标是支持网络AIO.看到：

    *   [the LWN article about kevent](http://lwn.net/Articles/172844/)
    
    *   [关于kevent的LWN文章](http://lwn.net/Articles/172844/)
    
    *   [his July announcement](http://lkml.org/lkml/2006/7/9/82)

	 *   [他7月的公告](http://lkml.org/lkml/2006/7/9/82)
    
    *   [his kevent page](http://tservice.net.ru/~s0mbre/old/?section=projects&item=kevent)

	 * 	[他的kevent页面](http://tservice.net.ru/~s0mbre/old/?section=projects&item=kevent))
    
    *   [his naio page](http://tservice.net.ru/~s0mbre/old/?section=projects&item=naio)

	 *   [他的naio页面](http://tservice.net.ru/~s0mbre/old/?section=projects&item=naio)

    *   [some recent discussion](http://thread.gmane.org/gmane.linux.network/37595/focus=37673)

    *   [一些最近的讨论](http://thread.gmane.org/gmane.linux.network/37595/focus=37673)
    
*   Drepper's New Network Interface (proposal for Linux 2.6+) 

*   Drepper的新网络接口(Linux 2.6+提案)
    
    At OLS 2006, Ulrich Drepper proposed a new high-speed asynchronous networking API. See:
    
    在OLS 2006上,Ulrich Drepper提出了一种新的高速异步网络API.看到：
    
    *   his paper, "[The Need for Asynchronous, Zero-Copy Network I/O](http://people.redhat.com/drepper/newni.pdf)"
	
	 *   他的论文, "[需要异步,零拷贝网络I/O](http://people.redhat.com/drepper/newni.pdf)"
    
    *   [his slides](http://people.redhat.com/drepper/newni-slides.pdf)

	 * 	 [他的幻灯片](http://people.redhat.com/drepper/newni-slides.pdf)
    
    *   [LWN article from July 22](http://lwn.net/Articles/192410/)

    *   [LWN 7月22日的文章](http://lwn.net/Articles/192410/)
    
*   **Realtime Signals**  

*   **实时信号**

    This is the recommended edge-triggered poll replacement for the 2.4 Linux kernel.
    
    Linux2.4 内核中推荐使用的边沿触发poll.
    
    The 2.4 linux kernel can deliver socket readiness events via a particular realtime signal. Here's how to turn this behavior on:
    
    linux 2.4 内核可以通过特定的实时信号分配套接字就绪事件.示例如下:
    
    ```
    /* Mask off SIGIO and the signal you want to use. */
    sigemptyset(&sigset);
    sigaddset(&sigset, signum);
    sigaddset(&sigset, SIGIO);
    sigprocmask(SIG_BLOCK, &m_sigset, NULL);
    /* For each file descriptor, invoke F_SETOWN, F_SETSIG, and set O_ASYNC. */
    fcntl(fd, F_SETOWN, (int) getpid());
    fcntl(fd, F_SETSIG, signum);
    flags = fcntl(fd, F_GETFL);
    flags |= O_NONBLOCK|O_ASYNC;
    fcntl(fd, F_SETFL, flags);
    ```
    
        
    ```
    /* Mask off SIGIO and the signal you want to use. */
    sigemptyset(&sigset);
    sigaddset(&sigset, signum);
    sigaddset(&sigset, SIGIO);
    sigprocmask(SIG_BLOCK, &m_sigset, NULL);
    /* For each file descriptor, invoke F_SETOWN, F_SETSIG, and set O_ASYNC. */
    fcntl(fd, F_SETOWN, (int) getpid());
    fcntl(fd, F_SETSIG, signum);
    flags = fcntl(fd, F_GETFL);
    flags |= O_NONBLOCK|O_ASYNC;
    fcntl(fd, F_SETFL, flags);
    ```
    
    
    This sends that signal when a normal I/O function like read() or write() completes. To use this, write a normal poll() outer loop, and inside it, after you've handled all the fd's noticed by poll(), you loop calling [sigwaitinfo()](http://www.opengroup.org/onlinepubs/007908799/xsh/sigwaitinfo.html).
    
    当 read() 或 write() 等普通 I/O 函数完成时,发送该信号.要使用该段的话,在循环里面,当poll()处理完所有的描述符后,进入 sigwaitinfo()[sigwaitinfo()](http://www.opengroup.org/onlinepubs/007908799/xsh/sigwaitinfo.html) 循环.

    If sigwaitinfo or sigtimedwait returns your realtime signal, siginfo.si_fd and siginfo.si_band give almost the same information as pollfd.fd and pollfd.revents would after a call to poll(), so you handle the i/o, and continue calling sigwaitinfo().
    

	  如果 sigwaitinfo 或 sigtimedwait 返回你的实时信号,siginfo.si_fd 和 siginfo.si_band 提供的信息几乎与 pollfd.fd 和 pollfd.revents 在调用 poll() 之后的信息相同,如果你处理该 I/O,那么就继续调用sigwaitinfo()

    If sigwaitinfo returns a traditional SIGIO, the signal queue overflowed, so you [flush the signal queue by temporarily changing the signal handler to SIG_DFL](http://www.cs.helsinki.fi/linux/linux-kernel/Year-1999/1999-41/0644.html), and break back to the outer poll() loop.
    
    如果 sigwaitinfo 返回传统的 SIGIO,那么信号队列溢出,你必须[通过临时将信号处理程序更改为SIG_DFL](http://www.cs.helsinki.fi/linux/linux-kernel/Year-1999/1999-41/0644.html)来刷新信号队列,然后回到外层poll()循环.
    
    See [Poller_sigio](dkftpbench/doc/Poller_sigio.html) ([cc](dkftpbench/dkftpbench-0.44/Poller_sigio.cc), [h](dkftpbench/dkftpbench-0.44/Poller_sigio.h)) for an example of how to use rtsignals interchangeably with many other readiness notification schemes.
    
    参阅[Poller_sigio](dkftpbench/doc/Poller_sigio.html) ([cc](dkftpbench/dkftpbench-0.44/Poller_sigio.cc), [h](dkftpbench/dkftpbench-0.44/Poller_sigio.h))是一个如何使用 rtsignals 与其他就绪通知模式交互的示例.
    
    
    See [Zach Brown's phhttpd](#phhttpd) for example code that uses this feature directly. (Or don't; phhttpd is a bit hard to figure out...)
    
    参阅[Zach Brown的phhttpd](#phhttpd),例如直接使用此功能的代码.(还是不要; phhttpd有点难以弄清楚......)
    
    [[Provos, Lever, and Tweedie 2000](http://www.citi.umich.edu/techreports/reports/citi-tr-00-7.ps.gz)] describes a recent benchmark of phhttpd using a variant of sigtimedwait(), sigtimedwait4(), that lets you retrieve multiple signals with one call. Interestingly, the chief benefit of sigtimedwait4() for them seemed to be it allowed the app to gauge system overload (so it could [behave appropriately](#overload)). (Note that poll() provides the same measure of system overload.)
    
    [[Provos，Lever和Tweedie 2000](http://www.citi.umich.edu/techreports/reports/citi-tr-00-7.ps.gz)]描述了 phhttpd 的最新基准,使用的不同的sigtimedwait(),sigtimedwait4(),它允许你通过一次调用检索多个信号.有趣的是 sigtimedwait4() 对他们的主要好处似乎是允许应用程序来衡量系统过载(因此它可以[行为恰当](#overload)).(请注意,poll()也提供了同样的系统负载测量.）
    
    
    
*   **Signal-per-fd** 

*   **每个fd一个信号**
 
    Chandra and Mosberger proposed a modification to the realtime signal approach called "signal-per-fd" which reduces or eliminates realtime signal queue overflow by coalescing redundant events. It doesn't outperform epoll, though. Their paper ( [www.hpl.hp.com/techreports/2000/HPL-2000-174.html](http://www.hpl.hp.com/techreports/2000/HPL-2000-174.html)) compares performance of this scheme with select() and /dev/poll.
    
    Signal-per-fd是由Chandra和Mosberger提出的对实时信号的一种改进,它通过合并冗余事件来减少或消除实时信号队列溢出.但它并没有超越 epoll.他们的论文 ([www.hpl.hp.com/techreports/2000/HPL-2000-174.html](http://www.hpl.hp.com/techreports/2000/HPL-2000-174.html))将此方案的性能与select() 和 /dev/poll 进行了比较.
    
    
    [Vitaly Luban announced a patch implementing this scheme on 18 May 2001](http://boudicca.tux.org/hypermail/linux-kernel/2001week20/1353.html); his patch lives at [www.luban.org/GPL/gpl.html](http://www.luban.org/GPL/gpl.html). (Note: as of Sept 2001, there may still be stability problems with this patch under heavy load. [dkftpbench](dkftpbench) at about 4500 users may be able to trigger an oops.)
    
    [Vitaly Luban于2001年5月18日宣布了一项实施该计划的补丁](http://boudicca.tux.org/hypermail/linux-kernel/2001week20/1353.html);他的补丁产生于[www.luban.org/GPL/gpl.html](http://www.luban.org/GPL/gpl.html).(注意:截至2001年9月,这个补丁在高负载下可能存在稳定性问题.[dkftpbench](dkftpbench)在大约4500个用户可能会触发oops.)
    
    See [Poller_sigfd](dkftpbench/doc/Poller_sigfd.html) ([cc](dkftpbench/dkftpbench-0.44/Poller_sigfd.cc), [h](dkftpbench/dkftpbench-0.44/Poller_sigfd.h)) for an example of how to use signal-per-fd interchangeably with many other readiness notification schemes.
    
    参阅[Poller_sigfd](dkftpbench/doc/Poller_sigfd.html) ([cc](dkftpbench/dkftpbench-0.44/Poller_sigfd.cc),[h](dkftpbench/dkftpbench-0.44/Poller_sigfd.h))是一个如何使用 signal-per-fd 与其他就绪通知模式交互的示例.
    

### 3. Serve many clients with each server thread, and use asynchronous I/O


### 3. 一个线程服务多个客户端,使用异步 I/O.


This has not yet become popular in Unix, probably because few operating systems support asynchronous I/O, also possibly because it (like nonblocking I/O) requires rethinking your application. Under standard Unix, asynchronous I/O is provided by [the aio_ interface](http://www.opengroup.org/onlinepubs/007908799/xsh/realtime.html) (scroll down from that link to "Asynchronous input and output"), which associates a signal and value with each I/O operation. Signals and their values are queued and delivered efficiently to the user process. This is from the POSIX 1003.1b realtime extensions, and is also in the Single Unix Specification, version 2.

这在Unix至今都没有流行起来,可能是因为较少的操作系统支持了异步 I/O,也可能是因为(像非阻塞 I/O)它要求重新思考应用程序.在标准 Unix 下,异步 I/O 被[aio_ 接口](http://www.opengroup.org/onlinepubs/007908799/xsh/realtime.html)提供(从该链接向下滚动到"异步输入和输出"),它将信号和值与每个 I/O操作相关联.信号及其值排队并有效地传递给用户进程.这是来自 POSIX 1003.1b 实时扩展,也是单Unix规范第二版本.

AIO is normally used with edge-triggered completion notification, i.e. a signal is queued when the operation is complete. (It can also be used with level triggered completion notification by calling [aio_suspend()](http://www.opengroup.org/onlinepubs/007908799/xsh/aio_suspend.html), though I suspect few people do this.)

AIO通常与边缘触发完成通知一起使用,即当操作完成时,信号排队.(它也可以通过调用[aio_suspend()](http://www.opengroup.org/onlinepubs/007908799/xsh/aio_suspend.html)与水平触发的完成通知一起使用,虽然我怀疑很少有人这样做.)

glibc 2.1 and later provide a generic implementation written for standards compliance rather than performance.


glibc 2.1和后续版本提供了一个普通的实现,仅仅是为了兼容标准,而不是为了获得性能上的提高.

Ben LaHaise's implementation for Linux AIO was merged into the main Linux kernel as of 2.5.32. It doesn't use kernel threads, and has a very efficient underlying api, but (as of 2.6.0-test2) doesn't yet support sockets. (There is also an AIO patch for the 2.4 kernels, but the 2.5/2.6 implementation is somewhat different.) More info:

截止linux内核 2.5.32,Ben LaHaise的 Linux AIO 实现已合并到主 Linux 内核中.它不使用内核线程,同时还具有非常高效的底层api,但是(从2.6.0-test2开始)还不支持套接字.(2.4内核还有一个 AIO 补丁,但 2.5/2.6 实现有些不同.)更多信息:

*   The page "[Kernel Asynchronous I/O (AIO) Support for Linux](http://lse.sourceforge.net/io/aio.html)" which tries to tie together all info about the 2.6 kernel's implementation of AIO (posted 16 Sept 2003)

* 	网页"[Linux的内核异步 I/O(AIO)支持](http://lse.sourceforge.net/io/aio.html),试图将有关 2.6 内核的 AIO 实现的所有信息联系在一起(2003年9月16日发布).

*   [Round 3: aio vs /dev/epoll](http://www.linuxsymposium.org/2002/view_txt.php?text=abstract&talk=11) by Benjamin C.R. LaHaise (presented at 2002 OLS)

* 	第3轮: Benjamin C.R. LaHaise 的[aio vs /dev/epoll](http://www.linuxsymposium.org/2002/view_txt.php?text=abstract&talk=11)(2002年OLS发表)

*   [Asynchronous I/O Suport in Linux 2.5](http://archive.linuxsymposium.org/ols2003/Proceedings/All-Reprints/Reprint-Pulavarty-OLS2003.pdf), by Bhattacharya, Pratt, Pulaverty, and Morgan, IBM; presented at OLS '2003

* 	[Linux2.5中的异步I/O支持](http://archive.linuxsymposium.org/ols2003/Proceedings/All-Reprints/Reprint-Pulavarty-OLS2003.pdf)由Bhattacharya,Pratt,Pulaverty和Morgan,IBM提供发表在OLS'2003.

*   [Design Notes on Asynchronous I/O (aio) for Linux](http://sourceforge.net/docman/display_doc.php?docid=12548&group_id=8875) by Suparna Bhattacharya -- compares Ben's AIO with SGI's KAIO and a few other AIO projects

* 	 Suparna Bhattacharya针对[Linux的异步 I/O(aio) 设计说明](http://sourceforge.net/docman/display_doc.php?docid=12548&group_id=8875) - 将 Ben 的 AIO 与 SGI 的 KAIO 和其他一些 AIO 项目进行比较

*   [Linux AIO home page](http://www.kvack.org/~blah/aio/) - Ben's preliminary patches, mailing list, etc.

* 	[Linux AIO主页](http://www.kvack.org/~blah/aio/) - Ben的初步补丁,邮件列表等.

*   [linux-aio mailing list archives](http://marc.theaimsgroup.com/?l=linux-aio)

* 	[linux-aio邮件列表档案](http://marc.theaimsgroup.com/?l=linux-aio)

*   [libaio-oracle](http://www.ocfs.org/aio/) - library implementing standard Posix AIO on top of libaio. [First mentioned by Joel Becker on 18 Apr 2003](http://marc.theaimsgroup.com/?l=linux-aio&m=105069158425822&w=2).

*   [libaio-oracle](http://www.ocfs.org/aio/) - 在libaio之上实现标准Posix AIO的库.[Joel Becker于2003年4月18日首次提到](http://marc.theaimsgroup.com/?l=linux-aio&m=105069158425822&w=2).


Suparna also suggests having a look at the [the DAFS API's approach to AIO](http://www.dafscollaborative.org/tools/dafs_api.pdf).

Suparna还建议看看[DAFS API 对 AIO 的方法](http://www.dafscollaborative.org/tools/dafs_api.pdf).


[Red Hat AS](http://www.ussg.iu.edu/hypermail/linux/kernel/0209.0/0832.html) and Suse SLES both provide a high-performance implementation on the 2.4 kernel; it is related to, but not completely identical to, the 2.6 kernel implementation.

[Red Hat AS](http://www.ussg.iu.edu/hypermail/linux/kernel/0209.0/0832.html)和 Suse SLES 都在2.4内核上提供了高性能的实现.它与2.6内核实现有关,但并不完全相同.


In February 2006, a new attempt is being made to provide network AIO; see [the note above about Evgeniy Polyakov's kevent-based AIO](#kevent).

2006年2月,网络AIO有一个新的尝试;看[上面关于Evgeniy Polyakov基于kevent的AIO的说明](#kevent)

In 1999, **[SGI implemented high-speed AIO](http://oss.sgi.com/projects/kaio/) for Linux**. As of version 1.1, it's said to work well with both disk I/O and sockets. It seems to use kernel threads. It is still useful for people who can't wait for Ben's AIO to support sockets.

在1999年,**[SGI为 Linux 实现了高速 AIO](http://oss.sgi.com/projects/kaio/)**,从版本1.1开始,据说可以很好地兼容磁盘 I/O 和套接字.它似乎使用内核线程.对于那些不能等待 Ben 的 AIO 支持套接字的人来说,会仍然很有用.

The O'Reilly book [POSIX.4: Programming for the Real World](http://www.oreilly.com/catalog/posix4/) is said to include a good introduction to aio.

O'Reilly的书[POSIX.4: 真实世界的编程](http://www.oreilly.com/catalog/posix4/)据说涵盖了对aio的一个很好的介绍.


A tutorial for the earlier, nonstandard, aio implementation on Solaris is online at [Sunsite](http://sunsite.nstu.nsk.su/sunworldonline/swol-03-1996/swol-03-aio.html). It's probably worth a look, but keep in mind you'll need to mentally convert "aioread" to "aio_read", etc.

Solaris早期非标准的aio实现的教程在线[Sunsite](http://sunsite.nstu.nsk.su/sunworldonline/swol-03-1996/swol-03-aio.html).这可能值得一看,但请记住,你需要在心理上将"aioread"转换为"aio_read"等.

Note that AIO doesn't provide a way to open files without blocking for disk I/O; if you care about the sleep caused by opening a disk file, [Linus suggests](http://www.ussg.iu.edu/hypermail/linux/kernel/0102.1/0124.html) you should simply do the open() in a different thread rather than wishing for an aio_open() system call.

请注意,AIO不提供在不阻塞磁盘 I/O 的情况下打开文件的方法; 如果你关心打开磁盘文件导致休眠,Linus建议你只需在另一个线程中执行 open（）而不是是进行 aio_open() 系统调用.

Under Windows, asynchronous I/O is associated with the terms "Overlapped I/O" and IOCP or "I/O Completion Port". Microsoft's IOCP combines techniques from the prior art like asynchronous I/O (like aio_write) and queued completion notification (like when using the aio_sigevent field with aio_write) with a new idea of holding back some requests to try to keep the number of running threads associated with a single IOCP constant. For more information, see [Inside I/O Completion Ports](http://www.sysinternals.com/ntw2k/info/comport.shtml) by Mark Russinovich at sysinternals.com, Jeffrey Richter's book "Programming Server-Side Applications for Microsoft Windows 2000" ([Amazon](http://www.amazon.com/exec/obidos/ASIN/0735607532), [MSPress](http://www.microsoft.com/mspress/books/toc/3402.asp)), [U.S. patent #06223207](http://patft.uspto.gov/netacgi/nph-Parser?Sect1=PTO1&Sect2=HITOFF&d=PALL&p=1&u=/netahtml/srchnum.htm&r=1&f=G&l=50&s1='6223207'.WKU.&OS=PN/6223207&RS=PN/6223207), or [MSDN](http://msdn.microsoft.com/library/default.asp?url=/library/en-us/fileio/filesio_4z1v.asp).


在Windows下,异步 I/O 与术语"重叠 I/O "和 IOCP 或"I/O完成端口"相关联.微软的 IOCP 结合了现有技术的技术,如异步 I/O(如aio_write)和排队完成通知(如将 aio_sigevent 字段与 aio_write 一起使用时),以及阻止某些请求尝试保持运行线程数量相关的新想法具有单个 IOCP 常量.欲获得更多信息,请参阅 sysinternals.com 上的 Mark Russinovich 撰写的[I/O 完成端口的内部](http://www.sysinternals.com/ntw2k/info/comport.shtml),Jeffrey Richter的书 "为Microsoft Windows 2000编写服务端程序"([Amazon](http://www.amazon.com/exec/obidos/ASIN/0735607532), [MSPress](http://www.microsoft.com/mspress/books/toc/3402.asp)), [U.S. patent #06223207](http://patft.uspto.gov/netacgi/nph-Parser?Sect1=PTO1&Sect2=HITOFF&d=PALL&p=1&u=/netahtml/srchnum.htm&r=1&f=G&l=50&s1='6223207'.WKU.&OS=PN/6223207&RS=PN/6223207), 或者[MSDN](http://msdn.microsoft.com/library/default.asp?url=/library/en-us/fileio/filesio_4z1v.asp).

### 4. Serve one client with each server thread

### 4. 一个线程服务多个客户端

... and let read() and write() block. Has the disadvantage of using a whole stack frame for each client, which costs memory. Many OS's also have trouble handling more than a few hundred threads. If each thread gets a 2MB stack (not an uncommon default value), you run out of *virtual memory* at (2^30 / 2^21) = 512 threads on a 32 bit machine with 1GB user-accessible VM (like, say, Linux as normally shipped on x86). You can work around this by giving each thread a smaller stack, but since most thread libraries don't allow growing thread stacks once created, doing this means designing your program to minimize stack use. You can also work around this by moving to a 64 bit processor.

...让 read() 和 write() 阻塞.每个客户端使用整个栈侦会有很大的缺点,就是消耗内存.很多操作系统也难以操作处理上百个线程.如果每个线程获得2MB堆栈（不是非常见的默认值),则在 32 位机器上的 (2^30/2 ^21）= 512 个线程上会耗尽*虚拟内存*,具有 1GB 用户可访问的VM(比如,Linux 通常在 x86 上允许)你可以通过提供更小的栈解决这个问题,但是线程一旦创建,大多数线程库都不允许增加线程栈,所以这样做就意味着你必须使你的程序最小程度地使用内存.你也可以通过转移到64位处理器来解决这个问题.

The thread support in Linux, FreeBSD, and Solaris is improving, and 64 bit processors are just around the corner even for mainstream users. Perhaps in the not-too-distant future, those who prefer using one thread per client will be able to use that paradigm even for 10000 clients. Nevertheless, at the current time, if you actually want to support that many clients, you're probably better off using some other paradigm.

在Linux, FreeBSD, Solaris上的线程支持是正在完善,即使对于主流用户来说,64位处理器也即将到来.也许在不就的将来,那些喜好每个客户端使用一个线程的人也有能力服务10000个客户端了.然而,在目前这个时候,如果你真的想要支持那么多客户,你可能最好还是使用其他一些方法.



For an unabashedly pro-thread viewpoint, see [Why Events Are A Bad Idea (for High-concurrency Servers)](http://www.usenix.org/events/hotos03/tech/vonbehren.html) by von Behren, Condit, and Brewer, UCB, presented at HotOS IX. Anyone from the anti-thread camp care to point out a paper that rebuts this one? :-)


对于毫不掩饰的亲线程观点的人,请参阅[为什么事件是一个坏主意(对于高并发服务器)](http://www.usenix.org/events/hotos03/tech/vonbehren.html)由von Behren,Condit和Brewer,UCB,在HotOS IX上发布.有反线营地的任何人能指出一篇反驳这篇论文的论文吗？:-)


#### LinuxThreads

#### Linux 线程

[LinuxTheads](http://pauillac.inria.fr/~xleroy/linuxthreads/) is the name for the standard Linux thread library. It is integrated into glibc since glibc2.0, and is mostly Posix-compliant, but with less than stellar performance and signal support.

[Linux线程](http://pauillac.inria.fr/~xleroy/linuxthreads/)是标准Linux线程库的名称.从 glibc2.0 开始,它就集成到 glibc 中,主要是符合 Posix 标准,但性能和信号支持度上都不尽如人意.


#### NGPT: Next Generation Posix Threads for Linux


#### NGPT: Linux 的下一代的 Posix 线程

[NGPT](http://www-124.ibm.com/pthreads/) is a project started by IBM to bring good Posix-compliant thread support to Linux. It's at stable version 2.2 now, and works well... but the NGPT team has [announced](http://www-124.ibm.com/pthreads/docs/announcement) that they are putting the NGPT codebase into support-only mode because they feel it's "the best way to support the community for the long term". The NGPT team will continue working to improve Linux thread support, but now focused on improving NPTL. (Kudos to the NGPT team for their good work and the graceful way they conceded to NPTL.)

[NGPT](http://www-124.ibm.com/pthreads/)是 IBM 启动的为 Linux 带来更好的 Posix 线程兼容性的项目.他目前的稳定版本是2.2,工作的非常好...但是 NGPT 团队[宣布](http://www-124.ibm.com/pthreads/docs/announcement)他们将 NGPT 代码库置于support-only模式,因为他们觉得这是"长期支持社区的最佳方式". NGPT团队将会继续改进 Linux 的线程支持,但是现在主要集中在NPTL.(感谢NGPT团队的出色工作以及他们以优雅的方式转向NPTL.)



#### NPTL: Native Posix Thread Library for Linux

#### NPTL: Linux 原生的 Posix 线程库

[NPTL](http://people.redhat.com/drepper/nptl/) is a project by [Ulrich Drepper](http://people.redhat.com/drepper/) (the benevolent dict^H^H^H^Hmaintainer of [glibc](http://www.gnu.org/software/libc/)) and [Ingo Molnar](http://people.redhat.com/mingo/) to bring world-class Posix threading support to Linux.

[NPTL](http://people.redhat.com/drepper/nptl/)是由Ulrich Drepper([glibc](http://www.gnu.org/software/libc/)的维护人员)和[Ulrich Drepper](http://people.redhat.com/drepper/)发起的,目的是为Linux带来的world-class Posix线程库支持.

As of 5 October 2003, NPTL is now merged into the glibc cvs tree as an add-on directory (just like linuxthreads), so it will almost certainly be released along with the next release of glibc.

截至2003年10月5日,NPTL 现在作为附加目录合并到 glibc cvs 树中(就像linux线程),所以它几乎肯定会与 glibc 的下一个版本一起发布.


The first major distribution to include an early snapshot of NPTL was Red Hat 9. (This was a bit inconvenient for some users, but somebody had to break the ice...)

Red Hat 9是最早的包含NPTL的发行版本(这对某些用户来说有点不方便，但有人不得不打破僵局...）


NPTL links:

NPTL 链接:

*   [Mailing list for NPTL discussion](https://listman.redhat.com/mailman/listinfo/phil-list)

*   [NPTL讨论的邮件列表](https://listman.redhat.com/mailman/listinfo/phil-list)

*   [NPTL source code](http://people.redhat.com/drepper/nptl/)

* 	 [NPTL源码](http://people.redhat.com/drepper/nptl/)

*   [Initial announcement for NPTL](http://lwn.net/Articles/10465/)

* 	 [NPTEL的初步公告](http://lwn.net/Articles/10465/)

*   [Original whitepaper describing the goals for NPTL](http://people.redhat.com/drepper/glibcthreads.html)

* 	 [描述NPTEL目标的原始白皮书](http://people.redhat.com/drepper/glibcthreads.html)

*   [Revised whitepaper describing the final design of NPTL](http://people.redhat.com/drepper/nptl-design.pdf)

* 	 [修订后的白皮书描述了NPTEL的最终设计](http://people.redhat.com/drepper/nptl-design.pdf)

*   [Ingo Molnar's](http://marc.theaimsgroup.com/?l=linux-kernel&m=103230439008204&w=2) first benchmark showing it could handle 10^6 threads

* 	 [Ingo Molnar的](http://marc.theaimsgroup.com/?l=linux-kernel&m=103230439008204&w=2)第一个基准显示它可以处理10^6个线程

*   [Ulrich's benchmark](http://marc.theaimsgroup.com/?l=linux-kernel&m=103269598000900&w=2) comparing performance of LinuxThreads, NPTL, and IBM's [NGPT](#threads.ngpt). It seems to show NPTL is much faster than NGPT.

* 	 [Ulrich的基准测试](http://marc.theaimsgroup.com/?l=linux-kernel&m=103269598000900&w=2)对比了linux线程,NPTL,和IBM的[NGPT](#threads.ngpt)的性能.它似乎显示 NPTL 比 NGPT 更快.

Here's my try at describing the history of NPTL (see also [Jerry Cooperstein's article](http://www.onlamp.com/pub/a/onlamp/2002/11/07/linux_threads.html)):

这是我尝试写的描述NPTL历史的文章(也可以看看[Jerry Cooperstein的文章](http://www.onlamp.com/pub/a/onlamp/2002/11/07/linux_threads.html)):


[In March 2002, Bill Abt of the NGPT team, the glibc maintainer Ulrich Drepper, and others met](http://people.redhat.com/drepper/glibcthreads.html) to figure out what to do about LinuxThreads. One idea that came out of the meeting was to improve mutex performance; Rusty Russell [et al](http://marc.theaimsgroup.com/?l=linux-kernel&m=103284847815916&w=2) subsequently implemented [fast userspace mutexes (futexes)](http://marc.theaimsgroup.com/?l=linux-kernel&m=102196625921110&w=2)), which are now used by both NGPT and NPTL. Most of the attendees figured NGPT should be merged into glibc.

在2002年3月, [NGPT团队的Bill Abt, glibc的维护者与Ulrich Drepper和其他人会面](http://people.redhat.com/drepper/glibcthreads.html)探讨LinuxThreads的发展.会议产生的一个想法是提高互斥性能;Rusty Russell [等人](http://marc.theaimsgroup.com/?l=linux-kernel&m=103284847815916&w=2)后来实现了[快速用户空间锁(futexes)](http://marc.theaimsgroup.com/?l=linux-kernel&m=102196625921110&w=2)),它现在被用在 NGPT 和 NPTL 中.大多数与会者认为NGPT应该被合并到glibc.


Ulrich Drepper, though, didn't like NGPT, and figured he could do better. (For those who have ever tried to contribute a patch to glibc, this may not come as a big surprise :-) Over the next few months, Ulrich Drepper, Ingo Molnar, and others contributed glibc and kernel changes that make up something called the Native Posix Threads Library (NPTL). NPTL uses all the kernel enhancements designed for NGPT, and takes advantage of a few new ones. Ingo Molnar [described](https://listman.redhat.com/pipermail/phil-list/2002-September/000013.html) the kernel enhancements as follows:

但Ulrich Drepper并不喜欢 NGPT,认为他可以做得更好.(对于那些试图为 glibc 做出补丁的人来说,这可能不会让人大吃一惊:-)在接下来的几个月里,Ulrich Drepper,Ingo Molnar致力于 glibc 和内核的变化,这些变化构成了 Native Posix线程库(NPTL).NPTL使用了NGPT设计的所有内核改进,并利用一些新功能.Ingo Molnar[描述](https://listman.redhat.com/pipermail/phil-list/2002-September/000013.html)了内核增强功能如下：


> While NPTL uses the three kernel features introduced by NGPT: getpid() returns PID, CLONE_THREAD and futexes; NPTL also uses (and relies on) a much wider set of new kernel features, developed as part of this project.
> 
> NPTL使用NGPT引入的三个内核特性：getpid()返回 PID,CLONE_THREAD 和 futexes;NPTL还使用(并依赖)更广泛的新内核功能,作为该项目的一部分开发.
>
> Some of the items NGPT introduced into the kernel around 2.5.8 got modified, cleaned up and extended, such as thread group handling (CLONE_THREAD). [the CLONE_THREAD changes which impacted NGPT's compatibility got synced with the NGPT folks, to make sure NGPT does not break in any unacceptable way.]
>
> 引入 2.5.8 内核的 NGPT 中的一些项目得到了修改,清理和扩展,例如线程组处理(CLONE_THREAD).[影响 NGPT 兼容性的 CLONE_THREAD 更改与 NGPT 人员同步,以确保NGPT不会以任何不可接受的方式破坏.]
>
> The kernel features developed for and used by NPTL are described in the design whitepaper, http://people.redhat.com/drepper/nptl-design.pdf ...
> 
> NPTL开发和使用的内核功能在设计白皮书中有描述,http://people.redhat.com/drepper/nptl-design.pdf ...

>
> A short list: TLS support, various clone extensions (CLONE_SETTLS, CLONE_SETTID, CLONE_CLEARTID), POSIX thread-signal handling, sys_exit() extension (release TID futex upon VM-release), the sys_exit_group() system-call, sys_execve() enhancements and support for detached threads.
>
> 简短列表:TLS支持,各种克隆扩展(CLONE_SETTLS,CLONE_SETTID,CLONE_CLEARTID),POSIX线程信号处理,sys_exit()扩展(在VM发布时发布TID futex)sys_exit_group()系统调用,sys_execve()增强功能 并支持分离的线程.
>
> There was also work put into extending the PID space - eg. procfs crashed due to 64K PID assumptions, max_pid, and pid allocation scalability work. Plus a number of performance-only improvements were done as well.
> 还有扩展 PID 空间的工作 - 例如,procfs由于 64K PID 的设计,为max_pid 和 pid 分配可伸缩性的工作而崩溃.此外，还进行了许多仅针对性能的改进.

>
> In essence the new features are a no-compromises approach to 1:1 threading - the kernel now helps in everything where it can improve threading, and we precisely do the minimally necessary set of context switches and kernel calls for every basic threading primitive.

> 本质上,新功能完全是使用1:1线程方法 - 内核现在可以帮助改进线程的所有内容,并且我们为每个基本线程原语精确地执行最低限度必需的上下文切换和内核调用。

> 

One big difference between the two is that NPTL is a 1:1 threading model, whereas NGPT is an M:N threading model (see below). In spite of this, [Ulrich's initial benchmarks](https://listman.redhat.com/pipermail/phil-list/2002-September/000009.html) seem to show that NPTL is indeed much faster than NGPT. (The NGPT team is looking forward to seeing Ulrich's benchmark code to verify the result.)

两者之间的一个重要区别是NPTL是1:1线程模型,而NGPT是 M:N 线程模型(见下文).尽管如此,[Ulrich的初步基准](https://listman.redhat.com/pipermail/phil-list/2002-September/000009.html)似乎表明NPTL确实比NGPT快得多(NGPT团队期待看到Ulrich的基准代码来验证结果.)

#### FreeBSD threading support

#### FreeBSD线程支持

FreeBSD supports both LinuxThreads and a userspace threading library. Also, a M:N implementation called KSE was introduced in FreeBSD 5.0. For one overview, see [www.unobvious.com/bsd/freebsd-threads.html](http://www.unobvious.com/bsd/freebsd-threads.html).

FreeBSD同时支持 linux 线程和用户空间线程库.此外,在 FreeBSD 5.0 中引入了一个名为 KSE 的 M:N 实现.概述,参阅[www.unobvious.com/bsd/freebsd-threads.html](http://www.unobvious.com/bsd/freebsd-threads.html).

On 25 Mar 2003, [Jeff Roberson posted on freebsd-arch](http://docs.freebsd.org/cgi/getmsg.cgi?fetch=121207+0+archive/2003/freebsd-arch/20030330.freebsd-arch):

2003年3月25日,[Jeff Roberson在 freebsd-arch 上发布了帖子](http://docs.freebsd.org/cgi/getmsg.cgi?fetch=121207+0+archive/2003/freebsd-arch/20030330.freebsd-arch):


> ... Thanks to the foundation provided by Julian, David Xu, Mini, Dan Eischen, and everyone else who has participated with KSE and libpthread development Mini and I have developed a 1:1 threading implementation. This code works in parallel with KSE and does not break it in any way. It actually helps bring M:N threading closer by testing out shared bits. ...

> ...感谢Julian,David Xu,Mini,Dan Eischen,和其它的每一位参加了KSE和libpthread开发的成员所提供的基础,Mini和我已经开发出了一个 1:1 模型的线程实现.此代码与 KSE 并行工作，不会以任何方式更改它.它实际上有助于通过测试共享位来使M:N线程更接近...

And in July 2006, [Robert Watson proposed that the 1:1 threading implementation become the default in FreeBsd 7.x](http://marc.theaimsgroup.com/?l=freebsd-threads&m=115191979412894&w=2):

并于2006年7月,[Robert Watson提出的 1:1 线程应该成为FreeBsd 7.x中的默认实现](http://marc.theaimsgroup.com/?l=freebsd-threads&m=115191979412894&w=2):

> I know this has been discussed in the past, but I figured with 7.x trundling forward, it was time to think about it again. In benchmarks for many common applications and scenarios, libthr demonstrates significantly better performance over libpthread... libthr is also implemented across a larger number of our platforms, and is already libpthread on several. The first recommendation we make to MySQL and other heavy thread users is "Switch to libthr", which is suggestive, also! ... So the strawman proposal is: make libthr the default threading library on 7.x.

> 我知道过去曾经讨论过这个问题,但我认为随着7.x向前推进,是时候重新考虑一下这个问题.在许多常见应用程序和特定场景的基准测试中,libthr 表现出比 libpthread 更好的性能... libthr也在我们的大量平台上实现的,并且已经在几个平台上实现了 libpthread.我们对 MySQL 和其他大量线程的使用者建议是"切换到libthr",这也是暗示性的! ...所以草书建议是:使libthr成为7.x上的默认线程库.

#### NetBSD threading support

#### NetBSD线程支持

According to a note from Noriyuki Soda:

根据Noriyuki Soda的说明:

> Kernel supported M:N thread library based on the Scheduler Activations model is merged into NetBSD-current on Jan 18 2003.

> 内核支持 M:N 基于 Scheduler Activations 模型线程库将于2003年1月18日合并到NetBSD-current中.

For details, see [An Implementation of Scheduler Activations on the NetBSD Operating System](http://web.mit.edu/nathanw/www/usenix/freenix-sa/) by Nathan J. Williams, Wasabi Systems, Inc., presented at FREENIX '02.

更多细节,看由NethanD系统公司的 Nathan J. Williams在2002年的FREENIX上的演示[An Implementation of Scheduler Activations on the NetBSD Operating System](http://web.mit.edu/nathanw/www/usenix/freenix-sa/).



#### Solaris threading support

#### Solaris 线程支持

The thread support in Solaris is evolving... from Solaris 2 to Solaris 8, the default threading library used an M:N model, but Solaris 9 defaults to 1:1 model thread support. See [Sun's multithreaded programming guide](http://docs.sun.com/db/doc/805-5080) and [Sun's note about Java and Solaris threading](http://java.sun.com/docs/hotspot/threads/threads.html).

Solaris中的线程正在开始支持...从 Solaris 2 到 Solaris 8,默认线程库使用 M:N 模型，但 Solaris 9 默认为 1:1 模型线程支持.看[Sun的多线程编程指导](http://docs.sun.com/db/doc/805-5080)和[Sun关于 Java 和 Solaris 线程的笔记](http://java.sun.com/docs/hotspot/threads/threads.html)


#### Java threading support in JDK 1.3.x and earlier


#### Java线程从JDK 1.3.x及以后开始支持


As is well known, Java up to JDK1.3.x did not support any method of handling network connections other than one thread per client. [Volanomark](http://www.volano.com/report/) is a good microbenchmark which measures throughput in messsages per second at various numbers of simultaneous connections. As of May 2003, JDK 1.3 implementations from various vendors are in fact able to handle ten thousand simultaneous connections -- albeit with significant performance degradation. See [Table 4](http://www.volano.com/report/#nettable) for an idea of which JVMs can handle 10000 connections, and how performance suffers as the number of connections increases.


众所周知,直到 JDK1.3.x 的 Java 不支持处理除每个客户端一个线程之外的任何网络连接方法.[Volanomark](http://www.volano.com/report/)是一个很好的微基准测试,它可以在不同数量连接中测量每秒消息的吞吐量.截至2003年5月,来自不同供应商的 JDK 1.3实际上能够处理一万个同时连接 - 尽管性能显着下降.请参阅[表4](http://www.volano.com/report/#nettable),了解哪些 JVM 可以处理10000个连接,以及随着连接数量的增加性能会受到影响.



#### Note: 1:1 threading vs. M:N threading


#### 注意：1:1 线程与 M:N 线程


There is a choice when implementing a threading library: you can either put all the threading support in the kernel (this is called the 1:1 threading model), or you can move a fair bit of it into userspace (this is called the M:N threading model). At one point, M:N was thought to be higher performance, but it's so complex that it's hard to get right, and most people are moving away from it.

在实现线程库时有一个选择: 你可以将所有线程支持放在内核中(这称为 1:1 线程模型),或者您可以将其中的相当一部分移动到用户空间(这称为 M:N 线程模型).有一点,M:N被认为是更高的性能,但它太复杂了,很难做到正确,大多数人都在远离它.

*   [Why Ingo Molnar prefers 1:1 over M:N](http://marc.theaimsgroup.com/?l=linux-kernel&m=103284879216107&w=2)

* 	[为什么Molnar更偏好 1:1 比 M:N](http://marc.theaimsgroup.com/?l=linux-kernel&m=103284879216107&w=2)

*   [Sun is moving to 1:1 threads](http://java.sun.com/docs/hotspot/threads/threads.html)

* 	[Sun正在向 1:1 线程发展](http://java.sun.com/docs/hotspot/threads/threads.html)

*   [NGPT](http://www-124.ibm.com/pthreads/) is an M:N threading library for Linux.

* 	[NGPT](http://www-124.ibm.com/pthreads/)是一个Linux M:N 线程库.

*   Although [Ulrich Drepper planned to use M:N threads in the new glibc threading library](http://people.redhat.com/drepper/glibcthreads.html), he has since [switched to the 1:1 threading model.](http://people.redhat.com/drepper/nptl-design.pdf)

* 	尽管[Ulrich Drepper计划在新的 glibc 线程库中去使用 M:N 线程](http://people.redhat.com/drepper/glibcthreads.html),他从那以后[切换到 1:1 线程模型](http://people.redhat.com/drepper/nptl-design.pdf)

*   [MacOSX appears to use 1:1 threading.](http://developer.apple.com/technotes/tn/tn2028.html#MacOSXThreading)

* 	[MacOSX出现使用 1:1 线程.](http://developer.apple.com/technotes/tn/tn2028.html#MacOSXThreading)

*   [FreeBSD](http://people.freebsd.org/~julian/) and [NetBSD](http://web.mit.edu/nathanw/www/usenix/freenix-sa/) appear to still believe in M:N threading... The lone holdouts? Looks like freebsd 7.0 might switch to 1:1 threading (see above), so perhaps M:N threading's believers have finally been proven wrong everywhere.

* 	[FreeBSD](http://people.freebsd.org/~julian/) 和 [NetBSD](http://web.mit.edu/nathanw/www/usenix/freenix-sa/)似乎仍然相信 M:N线程...孤独的坚持?看起来像 freebsd 7.0 可能会切换到 1:1 线程(见上文),所以也许 M:N 线程的信徒最终被证明是错误的.


### 5. Build the server code into the kernel

### 5. 将服务器代码构建到内核中

Novell and Microsoft are both said to have done this at various times, at least one NFS implementation does this, [khttpd](http://www.fenrus.demon.nl) does this for Linux and static web pages, and ["TUX" (Threaded linUX webserver)](http://slashdot.org/comments.pl?sid=00/07/05/0211257&cid=218) is a blindingly fast and flexible kernel-space HTTP server by Ingo Molnar for Linux. Ingo's [September 1, 2000 announcement](http://marc.theaimsgroup.com/?l=linux-kernel&m=98098648011183&w=2) says an alpha version of TUX can be downloaded from [ftp://ftp.redhat.com/pub/redhat/tux](ftp://ftp.redhat.com/pub/redhat/tux), and explains how to join a mailing list for more info.  

据说 Novell 和微软已经在不同的时间做过这个,至少有一个 NFS 实现是这样做的,[khttpd](http://www.fenrus.demon.nl)为Linux和静态网页做了这个,["TUX"(线程linux web服务器)](http://slashdot.org/comments.pl?sid=00/07/05/0211257&cid=218)是Ingo Molnar为Linux的一个快速且灵活的内核空间HTTP服务器. Ingo的[2000年9月1日公告](http://marc.theaimsgroup.com/?l=linux-kernel&m=98098648011183&w=2)表示可以从[ftp://ftp.redhat.com/pub/redhat/tux](ftp://ftp.redhat.com/pub/redhat/tux) 下载 TUX 的alpha版本,并解释如何加入邮件列表以获取更多信息.


The linux-kernel list has been discussing the pros and cons of this approach, and the consensus seems to be instead of moving web servers into the kernel, the kernel should have the smallest possible hooks added to improve web server performance. That way, other kinds of servers can benefit. See e.g. [Zach Brown's remarks](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9906_03/msg01041.html) about userland vs. kernel http servers. It appears that the 2.4 linux kernel provides sufficient power to user programs, as the [X15](#x15) server runs about as fast as Tux, but doesn't use any kernel modifications.

linux-kernel列表一直在讨论这种方法的优点和缺点,而且似乎达成了共识,不是将 Web 服务器移动到内核中,内核应该添加最小的钩子来提高Web服务器的性能.这样,其他类型的服务器可以受益.参见例如[Zach Brown的评论](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9906_03/msg01041.html)关于 userland 与内核 http 服务器的关系.似乎2.4 linux 内核为用户程序提供了足够的功能，因为[X15](#x15)服务器的运行速度与Tux一样快,但不使用任何内核修改.


## Bring the TCP stack into userspace

## 将TCP栈带入用户空间

See for instance the [netmap](http://info.iet.unipi.it/~luigi/netmap/) packet I/O framework, and the [Sandstorm](http://conferences.sigcomm.org/hotnets/2013/papers/hotnets-final43.pdf) proof-of-concept web server based on it.


例如,参见[netmap](http://info.iet.unipi.it/~luigi/netmap/)数据包 I/O 框架和[Sandstorm](http://conferences.sigcomm.org/hotnets/2013/papers/hotnets-final43.pdf)基于这个概念验证Web服务器.

## Comments

## 评论

Richard Gooch has written [a paper discussing I/O options](http://www.atnf.csiro.au/~rgooch/linux/docs/io-events.html).

Richard Gooch已经写了一篇关于[讨论 I/O 选项的论文](http://www.atnf.csiro.au/~rgooch/linux/docs/io-events.html).

In 2001, Tim Brecht and MMichal Ostrowski [measured various strategies](http://www.hpl.hp.com/techreports/2001/HPL-2001-314.html) for simple select-based servers. Their data is worth a look.

在2001年,Tim Brecht和MMichal Ostrowski测试了[多种策略](http://www.hpl.hp.com/techreports/2001/HPL-2001-314.html)为简化基于 select 的服务器.他们的数据值得一看.

In 2003, Tim Brecht posted [source code for userver](http://www.hpl.hp.com/research/linux/userver/), a small web server put together from several servers written by Abhishek Chandra, David Mosberger, David Pariag, and Michal Ostrowski. It can use select(), poll(), epoll(), or sigio.

在2003年,Tim Brecht发布了[userver的源代码](http://www.hpl.hp.com/research/linux/userver/),由Abhishek Chandra, David Mosberger, David Pariag 和 Michal Ostrowski 编写的几台服务器组成的小型Web服务器.他能使用select(), poll(),或者sigio.


Back in March 1999, [Dean Gaudet posted](http://marc.theaimsgroup.com/?l=apache-httpd-dev&m=92100977123493&w=2):

早在1999年3月,[Dean Gaudet的文章](http://marc.theaimsgroup.com/?l=apache-httpd-dev&m=92100977123493&w=2):

> I keep getting asked "why don't you guys use a select/event based model like Zeus? It's clearly the fastest." ...
 
> 我不断被问到"为什么你们不使用像Zeus这样的基于select/event的模型？它显然是最快的."...

His reasons boiled down to "it's really hard, and the payoff isn't clear". Within a few months, though, it became clear that people were willing to work on it.

他的理由归结为"这真的很难，收益还不清楚",然而,在几个月内,很明显人们愿意继续努力.

Mark Russinovich wrote [an editorial](http://linuxtoday.com/stories/5499.html) and [an article](http://www.winntmag.com/Articles/Index.cfm?ArticleID=5048) discussing I/O strategy issues in the 2.2 Linux kernel. Worth reading, even he seems misinformed on some points. In particular, he seems to think that Linux 2.2's asynchronous I/O (see F_SETSIG above) doesn't notify the user process when data is ready, only when new connections arrive. This seems like a bizarre misunderstanding. See also [comments on an earlier draft](http://www.dejanews.com/getdoc.xp?AN=431444525), [Ingo Molnar's rebuttal of 30 April 1999](http://www.dejanews.com/getdoc.xp?AN=472893693), [Russinovich's comments of 2 May 1999](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9905_01/msg00089.html), [a rebuttal](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9905_01/msg00263.html) from Alan Cox, and various [posts to linux-kernel](http://www.dejanews.com/dnquery.xp?ST=PS&QRY=threads&DBS=1&format=threaded&showsort=score&maxhits=100&LNG=ALL&groups=fa.linux.kernel+&fromdate=jun+1+1998). I suspect he was trying to say that Linux doesn't support asynchronous disk I/O, which used to be true, but now that SGI has implemented [KAIO](#aio), it's not so true anymore.


Mark Russinovich 写了一篇[社论](http://linuxtoday.com/stories/5499.html)和一篇[文章](http://www.winntmag.com/Articles/Index.cfm?ArticleID=5048)讨论在 linux内核2.2 中的 I/O 策略问题.值得一看,甚至他似乎在某些方面也被误导了.特别是,他似乎认为Linux 2.2 的异步 I/O (参见上面的F_SETSIG)在数据就绪时不会通知用户进程,只有当新连接到达时.这似乎是一个奇怪的误解.也可以看看[更早的草案](http://www.dejanews.com/getdoc.xp?AN=431444525),[Ingo Molnar于1999年4月30日的反驳](http://www.dejanews.com/getdoc.xp?AN=472893693),[Russinovich对1999年5月2日的评论](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9905_01/msg00089.html), [一个来自Alan Cox的反驳](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9905_01/msg00263.html),和各种[linux-kernel的帖子](http://www.dejanews.com/dnquery.xp?ST=PS&QRY=threads&DBS=1&format=threaded&showsort=score&maxhits=100&LNG=ALL&groups=fa.linux.kernel+&fromdate=jun+1+1998),我怀疑他试图说 Linux 不支持异步磁盘I/O,这曾经是真的,但是现在 SGI 已经实现了[KAIO](#aio),它不再那么真实了.


See these pages at [sysinternals.com](http://www.sysinternals.com/ntw2k/info/comport.shtml) and [MSDN](http://msdn.microsoft.com/library/techart/msdn_scalabil.htm) for information on "completion ports", which he said were unique to NT; in a nutshell, win32's "overlapped I/O" turned out to be too low level to be convenient, and a "completion port" is a wrapper that provides a queue of completion events, plus scheduling magic that tries to keep the number of running threads constant by allowing more threads to pick up completion events if other threads that had picked up completion events from this port are sleeping (perhaps doing blocking I/O).

有关"完成端口"的信息,请参阅[sysinternals.com](http://www.sysinternals.com/ntw2k/info/comport.shtml)和[MSDN](http://msdn.microsoft.com/library/techart/msdn_scalabil.htm)上的这些页面,他说这是NT独有的;简而言之,win32的"重叠 I/O "结果太低而不方便，"完成端口"是一个提供完成事件队列的包装器，加上调试魔术试图保持运行的数量,如果从该端口获取完成事件的其他线程正在休眠(可能阻塞I/O)则允许更多线程获取完成事件,从而使线程保持不变。



See also [OS/400's support for I/O completion ports](http://www.as400.ibm.com/developer/v4r5/api.html).

另请参阅[OS/400对I/O完成端口的支持](http://www.as400.ibm.com/developer/v4r5/api.html)

There was an interesting discussion on linux-kernel in September 1999 titled "[\> 15,000 Simultaneous Connections](http://www.cs.Helsinki.FI/linux/linux-kernel/Year-1999/1999-36/0160.html)" (and the [second week](http://www.cs.helsinki.fi/linux/linux-kernel/Year-1999/1999-37/0612.html) of the thread). Highlights:

1999年9月对linux-kernel进行了一次有趣的讨论"[\> 15,000个同时连接](http://www.cs.Helsinki.FI/linux/linux-kernel/Year-1999/1999-36/0160.html)"(和[线程的第二周](http://www.cs.helsinki.fi/linux/linux-kernel/Year-1999/1999-37/0612.html)).强调:

*   Ed Hall [posted](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9909_01/msg00807.html) a few notes on his experiences; he's achieved >1000 connects/second on a UP P2/333 running Solaris. His code used a small pool of threads (1 or 2 per CPU) each managing a large number of clients using "an event-based model".

*   Ed Hall[发布](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9909_01/msg00807.html)关于他的经历的一些笔记; 他在运行Solaris的UP P2/333上实现了>1000次连接/秒.他的代码使用了一小块线程(每个CPU1或2个),每个线程使用"基于事件的模型”管理大量客户端.


*   Mike Jagdis [posted an analysis of poll/select overhead](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9909_01/msg00831.html), and said "The current select/poll implementation can be improved significantly, especially in the blocking case, but the overhead will still increase with the number of descriptors because select/poll does not, and cannot, remember what descriptors are interesting. This would be easy to fix with a new API. Suggestions are welcome..."

*   Mike Jagdis [发布了对 poll/select 性能开销的分析](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9909_01/msg00831.html),并说"当前的select/poll 实现可以得到显着改善,特别是在阻塞情况下,但由于 select/poll 没有,因此开销仍会随着描述符的数量而增加,并且不能,记住哪些描述符很有趣的.这很容易用新的API修复.欢迎提出建议......"


*   Mike [posted](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9909_01/msg00964.html) about his [work on improving select() and poll()](http://www.purplet.demon.co.uk/linux/select/).

*   Mike[发布](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9909_01/msg00964.html)关于他的[改进select()和poll()的工作](http://www.purplet.demon.co.uk/linux/select/).


*   Mike [posted a bit about a possible API to replace poll()/select()](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9909_01/msg00971.html): "How about a 'device like' API where you write 'pollfd like' structs, the 'device' listens for events and delivers 'pollfd like' structs representing them when you read it? ... "

*  Mike [发布了一些可能的API来替换poll()/select()](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9909_01/msg00971.html): "你可以编写'pollfd like'结构的'device like'API怎么样，'device'监听事件并在你读它时提供代表它们的'pollfd like'结构？..."



*   Rogier Wolff [suggested](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9909_01/msg00979.html) using "the API that the digital guys suggested", [http://www.cs.rice.edu/~gaurav/papers/usenix99.ps](http://www.cs.rice.edu/~gaurav/papers/usenix99.ps)

*   Rogier Wolff [建议](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9909_01/msg00979.html)使用"数字家伙建议的API",[http://www.cs.rice.edu/~gaurav/papers/usenix99.ps](http://www.cs.rice.edu/~gaurav/papers/usenix99.ps)

*   Joerg Pommnitz [pointed out](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9909_02/msg00001.html) that any new API along these lines should be able to wait for not just file descriptor events, but also signals and maybe SYSV-IPC. Our synchronization primitives should certainly be able to do what Win32's WaitForMultipleObjects can, at least.


*   Joerg Pommnitz [指出](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9909_02/msg00001.html)沿着这些线路的任何新API应该不仅能够等待文件描述符事件,还能够等待信号和SYSV-IPC.我们的同步原语至少应该能够做到Win32的WaitForMultipleObjects.


*   Stephen Tweedie [asserted](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9909_02/msg01198.html) that the combination of F_SETSIG, queued realtime signals, and sigwaitinfo() was a superset of the API proposed in http://www.cs.rice.edu/~gaurav/papers/usenix99.ps. He also mentions that you keep the signal blocked at all times if you're interested in performance; instead of the signal being delivered asynchronously, the process grabs the next one from the queue with sigwaitinfo().

*   Stephen Tweedie[断言]((http://www.linuxhq.com/lnxlists/linux-kernel/lk_9909_02/msg01198.html)),_SETSIG,排队的实时信号和 sigwaitinfo() 的组合是 http://www.cs.rice.edu/~gaurav/papers/usenix99.ps 中提出的API的超集.他还提到,如果你对性能感兴趣,你可以随时阻止信号;而不是异步传递信号,进程使用sigwaitinfo()从队列中获取下一个信号.

*   Jayson Nordwick [compared](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9909_03/msg00002.html) completion ports with the F_SETSIG synchronous event model, and concluded they're pretty similar.

*   Jayson Nordwick [比较](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9909_03/msg00002.html)完成端口与 F_SETSIG 同步事件模型,并得出结论,它们非常相似.

*   Alan Cox [noted](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9909_03/msg00043.html) that an older rev of SCT's SIGIO patch is included in 2.3.18ac.

*   Alan Cox [指出](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9909_03/msg00043.html)SCT的 SIGIO 补丁的旧版本包含在2.3.18ac中.

*   Jordan Mendelson [posted](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9909_03/msg00093.html) some example code showing how to use F_SETSIG.

*   Jordan Mendelson [发布](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9909_03/msg00093.html)一些示例代码,展示了如何使用F_SETSIG.

*   Stephen C. Tweedie [continued](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9909_03/msg00095.html) the comparison of completion ports and F_SETSIG, and noted: "With a signal dequeuing mechanism, your application is going to get signals destined for various library components if libraries are using the same mechanism," but the library can set up its own signal handler, so this shouldn't affect the program (much).

*   Stephen C. Tweedie [继续](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9909_03/msg00095.html)比较完成端口和F_SETSIG,并注意到:"使用信号出队机制,如果库使用相同的机制,您的应用程序将获取发往各种库组件的信号",但库可以设置自己的信号处理程序,所以这不应该影响程序(很多).

*   [Doug Royer](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9909_04/msg00900.html) noted that he'd gotten 100,000 connections on Solaris 2.6 while he was working on the Sun calendar server. Others chimed in with estimates of how much RAM that would require on Linux, and what bottlenecks would be hit.

* 	[Doug Royer](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9909_04/msg00900.html)指出,当他在 Sun 日历服务器上工作时,他在 Solaris 2.6 上获得了 100,000 个连接.其他人则估计Linux需要多少RAM，以及会遇到什么瓶颈。

Interesting reading!

有趣的阅读！

## Limits on open filehandles

## 打开文件句柄的限制

*   Any Unix: the limits set by ulimit or setrlimit.

*   任何Unix: 都由ulimit或setrlimit设置限制

*   Solaris: see [the Solaris FAQ, question 3.46](http://www.wins.uva.nl/pub/solaris/solaris2/Q3.46.html) (or thereabouts; they renumber the questions periodically).

* 	Solaris: 看 [Solaris FAQ，问题3.46](http://www.wins.uva.nl/pub/solaris/solaris2/Q3.46.html) (或左右; 他们定期重新编号)

*   FreeBSD:  
      
*   FreeBSD:


    Edit /boot/loader.conf, add the line
    
    编辑 /boot/loader.conf, 增加行
    
    `set kern.maxfiles=XXXX`
    
    `set kern.maxfiles=XXXX`
    
    where XXXX is the desired system limit on file descriptors, and reboot. Thanks to an anonymous reader, who wrote in to say he'd achieved far more than 10000 connections on FreeBSD 4.3, and says
    
    其中XXXX是文件描述符所需的系统限制,并重新启动.感谢一位匿名读者，他写道,他说他在FreeBSD 4.3上获得了超过10000个连接，并说
    
    > "FWIW: You can't actually tune the maximum number of connections in FreeBSD trivially, via sysctl.... You have to do it in the /boot/loader.conf file.  
    
    > "FWIW: 你实际上无法通过sysctl轻松调整FreeBSD中的最大连接数....你必须在/boot/loader.conf文件中这样做.
    
    > The reason for this is that the zalloci() calls for initializing the sockets and tcpcb structures zones occurs very early in system startup, in order that the zone be both type stable and that it be swappable.  
    
    > 这样做的原因是 zalloci() 调用初始化套接字和 tcpcb 结构区域在系统启动时很早就发生了，这样区域既可以是类型稳定的又可以交换。

    
    > You will also need to set the number of mbufs much higher, since you will (on an unmodified kernel) chew up one mbuf per connection for tcptempl structures, which are used to implement keepalive."
    
    > 您还需要将 mbuf 的数量设置得更高，因为您在(在未修改的内核上)为 tcptempl 结构每个连接消耗一个 mbuf,用于实现 keepalive."
    
    Another reader says
    
    其他的读者说到:
    
    > "As of FreeBSD 4.4, the tcptempl structure is no longer allocated; you no longer have to worry about one mbuf being chewed up per connection."
    
    > "从FreeBSD 4.4开始，不再分配tcptempl结构; 你不再需要担心每个连接都会被消耗一个mbuf
   
    
    See also:
    
    也可以看看:
        
    *   [the FreeBSD handbook](http://www.freebsd.org/doc/en_US.ISO8859-1/books/handbook/configtuning-kernel-limits.html)

	  *   [the FreeBSD 手册](http://www.freebsd.org/doc/en_US.ISO8859-1/books/handbook/configtuning-kernel-limits.html)
    
    *   [SYSCTL TUNING](http://www.freebsd.org/cgi/man.cgi?query=tuning#SYSCTL+TUNING), [LOADER TUNABLES](http://www.freebsd.org/cgi/man.cgi?query=tuning#LOADER+TUNABLES), and [KERNEL CONFIG TUNING](http://www.freebsd.org/cgi/man.cgi?query=tuning#KERNEL+CONFIG+TUNING) in 'man tuning'

	  *   [SYSCTL TUNING](http://www.freebsd.org/cgi/man.cgi?query=tuning#SYSCTL+TUNING), [LOADER TUNABLES](http://www.freebsd.org/cgi/man.cgi?query=tuning#LOADER+TUNABLES), and [KERNEL CONFIG TUNING](http://www.freebsd.org/cgi/man.cgi?query=tuning#KERNEL+CONFIG+TUNING) in 'man tuning'
    
    *   [The Effects of Tuning a FreeBSD 4.3 Box for High Performance](http://www.daemonnews.org/200108/benchmark.html), Daemon News, Aug 2001

	  *   [调整FreeBSD 4.3 Box对高性能的影响](http://www.daemonnews.org/200108/benchmark.html), 守护进程新闻,2001年8月
    
    *   [postfix.org tuning notes](http://www.postfix.org/faq.html#moby-freebsd), covering FreeBSD 4.2 and 4.4
    
    *   [postfix.org 调整笔记](http://www.postfix.org/faq.html#moby-freebsd), 涵盖FreeBSD 4.2 和 4.4
    
    *   [the Measurement Factory's notes](http://www.measurement-factory.com/docs/FreeBSD/), circa FreeBSD 4.3
    
    *   [the Measurement Factory 的笔记](http://www.measurement-factory.com/docs/FreeBSD/), 大约是FreeBSD 4.3

    
*   OpenBSD: A reader says

*   OpenBSD: 读者说
    
	
    > "In OpenBSD, an additional tweak is required to increase the number of open filehandles available per process: the openfiles-cur parameter in [/etc/login.conf](http://www.freebsd.org/cgi/man.cgi?query=login.conf&manpath=OpenBSD+3.1) needs to be increased. You can change kern.maxfiles either with sysctl -w or in sysctl.conf but it has no effect. This matters because as shipped, the login.conf limits are a quite low 64 for nonprivileged processes, 128 for privileged."
    
    > "在OpenBSD,需要额外的调整来增加每个进程可用的打开文件句柄的数量: [/etc/login.conf](http://www.freebsd.org/cgi/man.cgi?query=login.conf&manpath=OpenBSD+3.1) 的openfiles-cur参数需要被增加. 您可以使用sysctl -w 或 sysctl.conf 更改 kern.max 文件,但它不起作用.这很重要，因为对于非特权进程，login.conf限制为非常低的64，对于特权进程为128
    
*   Linux: See [Bodo Bauer's /proc documentation](http://asc.di.fct.unl.pt/~jml/mirror/Proc/). On 2.4 kernels:

*   Linux: 参阅[Bodo Bauer的 /proc 文档](http://asc.di.fct.unl.pt/~jml/mirror/Proc/). 在2.4内核:
    
    `echo 32768 > /proc/sys/fs/file-max`
    
    `echo 32768 > /proc/sys/fs/file-max`
    
    increases the system limit on open files, and
    
    增大系统打开文件的限制.和
    
    `ulimit -n 32768`
    
    `ulimit -n 32768`
    
    increases the current process' limit.
    
    增大当前进程的限制
    
    On 2.2.x kernels,
    
    在 2.2.x 内核,
    
    ```
    echo 32768 > /proc/sys/fs/file-max
    echo 65536 > /proc/sys/fs/inode-max
    ```
    
    ```
    echo 32768 > /proc/sys/fs/file-max
    echo 65536 > /proc/sys/fs/inode-max
    ```

    increases the system limit on open files, and
    
    增大系统打开文件的限制.和
    
    ```
    ulimit -n 32768
    ```
 
    ```
    ulimit -n 32768
    ```
    
    增大当前进程的限制
    
    I verified that a process on Red Hat 6.0 (2.2.5 or so plus patches) can open at least 31000 file descriptors this way. Another fellow has verified that a process on 2.2.12 can open at least 90000 file descriptors this way (with appropriate limits). The upper bound seems to be available memory.
    
    我验证了 Red Hat 6.0 上的进程(2.2.5 左右加补丁)可以通过这种方式打开至少31000 个文件描述符.另一位研究员已经证实,2.2.12 上的进程可以通过这种方式打开至少90000 个文件描述符(具有适当的限制).上限似乎是可用的内存。

	
    Stephen C. Tweedie [posted](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9909_02/msg01092.html) about how to set ulimit limits globally or per-user at boot time using initscript and pam_limit.
    
    Stephen C. Tweedie [发表](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9909_02/msg01092.html) 关于如何使用 initscript 和 pam_limit 在引导时全局或按用户设置 ulimit 限制.

    In older 2.2 kernels, though, the number of open files per process is still limited to 1024, even with the above changes.
    
    在 2.2 更老的内核, 但是,即使进行了上述更改,每个进程的打开文件数仍限制为1024

    See also [Oskar's 1998 post](http://www.dejanews.com/getdoc.xp?AN=313316592), which talks about the per-process and system-wide limits on file descriptors in the 2.0.36 kernel.
    
    另见[Oskar1998年的帖子](http://www.dejanews.com/getdoc.xp?AN=313316592),其中讨论了 2.0.36 内核中文件描述符的每进程和系统范围限制。
    
    

## Limits on threads

## 线程限制

On any architecture, you may need to reduce the amount of stack space allocated for each thread to avoid running out of virtual memory. You can set this at runtime with pthread_attr_init() if you're using pthreads.

在任何体系结构上,您可能需要减少为每个线程分配的堆栈空间量,以避免耗尽虚拟内存.如果使用pthreads,可以使用pthread_attr_init() 在运行时设置它。

*   Solaris: it supports as many threads as will fit in memory, I hear.

*   Solaris: 我听说,它支持尽可能多的线程以适应内存

*   Linux 2.6 kernels with NPTL: /proc/sys/vm/max_map_count may need to be increased to go above 32000 or so threads. (You'll need to use very small stack threads to get anywhere near that number of threads, though, unless you're on a 64 bit processor.) See the NPTL mailing list, e.g. the thread with subject "[Cannot create more than 32K threads?](https://listman.redhat.com/archives/phil-list/2003-August/msg00005.html)", for more info.

* 	带有 NPTL 的内核: /proc/sys/vm/max_map_count 也许需要被增加到大于 32000 的线程.（但是,除非你使用64位处理器,否则你需要使用非常小的堆栈线程来获得接近该数量的线程.）参见NPTL邮件列表,例如主题为"[无法创建超过32K线程?]((https://listman.redhat.com/archives/phil-list/2003-August/msg00005.html)),了解更多信息。


*   Linux 2.4: /proc/sys/kernel/threads-max is the max number of threads; it defaults to 2047 on my Red Hat 8 system. You can set increase this as usual by echoing new values into that file, e.g. "echo 4000 > /proc/sys/kernel/threads-max"

*   Linux 2.4: /proc/sys/kernel/threads-max 是最大数量的线程;我的Red Hat 8系统默认为2047.你可以像往常一样通过echo新值到该文件来设置增加值,如."echo 4000 > /proc/sys/kernel/threads-max"

*   Linux 2.2: Even the 2.2.13 kernel limits the number of threads, at least on Intel. I don't know what the limits are on other architectures. [Mingo posted a patch for 2.1.131 on Intel](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9812_02/msg00048.html) that removed this limit. It appears to be integrated into 2.3.20.

*   Linux 2.2: 甚至 2.2.13 内核限制了线程数量, 至少在Intel. 我不知道在其他架构上是什么限制.[Mingo在英特尔上发布了针对 2.1.131 的补丁](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9812_02/msg00048.html)移除了这个限制.它已纳入2.3.20.
    
    See also [Volano's detailed instructions for raising file, thread, and FD_SET limits in the 2.2 kernel](http://www.volano.com/linux.html). Wow. This document steps you through a lot of stuff that would be hard to figure out yourself, but is somewhat dated.
    
    另请[参阅Volano关于在2.2内核中提升文件，线程和FD_SET限制的详细说明](http://www.volano.com/linux.html). 哇.这个文档将引导您完成许多难以理解的内容，但有点过时了。
    
*   Java: See [Volano's detailed benchmark info](http://www.volano.com/benchmarks.html), plus their [info on how to tune various systems](http://www.volano.com/server.html) to handle lots of threads.

*   Java: [请参阅Volano的详细基准信息](http://www.volano.com/benchmarks.html). 加上他们[关于如何调整各种系统的信息](http://www.volano.com/server.html) 去处理大量线程.

## Java issues

## Java 问题

Up through JDK 1.3, Java's standard networking libraries mostly offered the [one-thread-per-client model](#threaded.java). There was a way to do nonblocking reads, but no way to do nonblocking writes.

通过JDK 1.3, Java的标准网络库大多提供了[一个客户端一个线程模型](#threaded.java).这是一种非阻塞读的方式,但是没有办法去做非阻塞写.


In May 2001, [JDK 1.4](http://java.sun.com/j2se/1.4/) introduced the package [java.nio](http://java.sun.com/j2se/1.4/docs/guide/nio/) to provide full support for nonblocking I/O (and some other goodies). See [the release notes](http://java.sun.com/j2se/1.4/relnotes.html#nio) for some caveats. Try it out and give Sun feedback!

在2001年5月. [JDK 1.4](http://java.sun.com/j2se/1.4/) 引进了包 [java.nio](http://java.sun.com/j2se/1.4/docs/guide/nio/) 去提供完全支持非阻塞 I/O (和其他好的东西).看[发行说明](http://java.sun.com/j2se/1.4/relnotes.html#nio) 警告.尝试一下,给Sun反馈!

HP's java also includes a [Thread Polling API](http://www.devresource.hp.com/JavaATC/JavaPerfTune/pollapi.html).

HP 的 java 也包含了一个[线程轮训API](http://www.devresource.hp.com/JavaATC/JavaPerfTune/pollapi.html).


In 2000, Matt Welsh implemented nonblocking sockets for Java; his performance benchmarks show that they have advantages over blocking sockets in servers handling many (up to 10000) connections. His class library is called [java-nbio](http://www.cs.berkeley.edu/~mdw/proj/java-nbio/); it's part of the [Sandstorm](http://www.cs.berkeley.edu/~mdw/proj/sandstorm/) project. Benchmarks showing [performance with 10000 connections](http://www.cs.berkeley.edu/~mdw/proj/sandstorm/iocore-bench/) are available.

在2000, Matt Welsh为java实现了非阻塞套接字.他的性能基准测试显示他们优于在处理大量(大于10000)连接的服务器中的阻塞套接字.他的类库被称作[java-nbio](http://www.cs.berkeley.edu/~mdw/proj/java-nbio/);他是[Sandstorm](http://www.cs.berkeley.edu/~mdw/proj/sandstorm/)项目的一部分.基准测试显示[10000连接的性能](http://www.cs.berkeley.edu/~mdw/proj/sandstorm/iocore-bench/)是可用的.

See also [Dean Gaudet's essay](http://arctic.org/~dean/hybrid-jvm.txt) on the subject of Java, network I/O, and threads, and the [paper](http://www.cs.berkeley.edu/~mdw/papers/events.pdf) by Matt Welsh on events vs. worker threads.

参阅 Dean Gaude关于 Java , 网络 I/O, 和线程主题的[文章](http://arctic.org/~dean/hybrid-jvm.txt),和 Matt Welsh 写的关于事件对比工作线程的[论文](http://www.cs.berkeley.edu/~mdw/papers/events.pdf)

Before NIO, there were several proposals for improving Java's networking APIs:

在 NIO 之前,有几个改进Java的网络API的建议:

*   Matt Welsh's [Jaguar system](http://www.cs.berkeley.edu/~mdw/proj/jaguar/) proposes preserialized objects, new Java bytecodes, and memory management changes to allow the use of asynchronous I/O with Java.

*   Matt Welsh 的[Jaguar 系统](http://www.cs.berkeley.edu/~mdw/proj/jaguar/)提出预序列化对象,新的 Java 字节码和内存管理更改允许使用 Java 进行异步I/O.

*   [Interfacing Java to the Virtual Interface Architecture](http://www.cs.cornell.edu/Info/People/chichao/papers.htm), by C-C. Chang and T. von Eicken, proposes memory management changes to allow the use of asynchronous I/O with Java.

*   C-C. Chang and T. von Eicken写的[将Java连接到虚拟接口体系结构](http://www.cs.cornell.edu/Info/People/chichao/papers.htm)提出内存管理更改允许 Java 使用异步 I/O.

*   [JSR-51](http://java.sun.com/aboutJava/communityprocess/jsr/jsr_051_ioapis.html) was the Sun project that came up with the java.nio package. Matt Welsh participated (who says Sun doesn't listen?).

*   [JSR-51](http://java.sun.com/aboutJava/communityprocess/jsr/jsr_051_ioapis.html)是提出 java.nio 包的Sun工程项目. Matt Welsh参加了(谁说Sun不听?).

## Other tips

## 其他建议

*   Zero-Copy  

*   零拷贝

    Normally, data gets copied many times on its way from here to there. Any scheme that eliminates these copies to the bare physical minimum is called "zero-copy".
    
    通常情况下,数据会从一处到其他处多次复制.任何将这些副本消除到裸体物理最小值的方案称为"零拷贝".
    
    
    *   [Thomas Ogrisegg's zero-copy send patch](http://marc.theaimsgroup.com/?l=linux-kernel&m=104121076420067&w=2) for mmaped files under Linux 2.4.17-2.4.20. Claims it's faster than sendfile().

	  *    Thomas Ogrisegg 在 Linux 2.4.17-2.4.20 下为 mmaped 文件[发送零拷贝发送补丁](http://marc.theaimsgroup.com/?l=linux-kernel&m=104121076420067&w=2).声称它比 sendfile() 更快.
    
    *   [IO-Lite](http://www.usenix.org/publications/library/proceedings/osdi99/full_papers/pai/pai_html/pai.html) is a proposal for a set of I/O primitives that gets rid of the need for many copies.

	  *    [IO-Lite](http://www.usenix.org/publications/library/proceedings/osdi99/full_papers/pai/pai_html/pai.html) 是一组 I/O 原语的提议,它摆脱了对许多副本的需求.
    
    *   [Alan Cox noted that zero-copy is sometimes not worth the trouble](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9905_01/msg00263.html) back in 1999. (He did like sendfile(), though.)

 	  *    在1999年, Alan Cox指出零拷贝有时是不值的会遇到麻烦.(但他确实喜欢sendfile())
    
    *   Ingo [implemented a form of zero-copy TCP](http://boudicca.tux.org/hypermail/linux-kernel/2000week36/0979.html) in the 2.4 kernel for TUX 1.0 in July 2000, and says he'll make it available to userspace soon.

	  *    Ingo于2000年7月在 2.4 内核中为 TUX 1.0[实现了一种零拷贝TCP](http://boudicca.tux.org/hypermail/linux-kernel/2000week36/0979.html),他说他很快就会将其提供给用户空间.
    
    *   [Drew Gallatin and Robert Picco have added some zero-copy features to FreeBSD](http://people.freebsd.org/~ken/zero_copy/); the idea seems to be that if you call write() or read() on a socket, the pointer is page-aligned, and the amount of data transferred is at least a page, *and* you don't immediately reuse the buffer, memory management tricks will be used to avoid copies. But see [followups to this message on linux-kernel](http://boudicca.tux.org/hypermail/linux-kernel/2000week39/0249.html) for people's misgivings about the speed of those memory management tricks.

    *   [Drew Gallatin and Robert 已经为FreeBSD增加了一些零拷贝特性](http://people.freebsd.org/~ken/zero_copy/);想法似乎是如果你在一个套接字上调用 write() 或者 read(),指针是页对齐的,并且传输的数据量至少是一个页面, **同时**你不会马上重用缓冲区,内存管理技巧将会用于避免拷贝. 但是请参阅[linux-kernel上关于此消息的后续内容](http://boudicca.tux.org/hypermail/linux-kernel/2000week39/0249.html)，以了解人们对这些内存管理技巧速度的疑虑.
        
        According to a note from Noriyuki Soda:
        
        根据Noriyuki Soda的说明:
        
        > Sending side zero-copy is supported since NetBSD-1.6 release by specifying "SOSEND_LOAN" kernel option. This option is now default on NetBSD-current (you can disable this feature by specifying "SOSEND_NO_LOAN" in the kernel option on NetBSD_current). With this feature, zero-copy is automatically enabled, if data more than 4096 bytes are specified as data to be sent.
        
        
        > 自NetBSD-1.6发布以来，通过指定 "SOSEND_LOAN" 内核选项，支持发送端零拷贝.此选项现在是 NetBSD-current 的默认选项(你可以通过在 NetBSD_current 上的内核选项中指定"SOSEND_NO_LOAN"来禁用此功能).使用此功能时，如果将超过4096字节的数据指定为要发送的数据，则会自动启用零复制.
        
    *   The sendfile() system call can implement zero-copy networking.  

    *   sendfile() 系统调用可以实现零拷贝网络.
    
        The sendfile() function in Linux and FreeBSD lets you tell the kernel to send part or all of a file. This lets the OS do it as efficiently as possible. It can be used equally well in servers using threads or servers using nonblocking I/O. (In Linux, it's poorly documented at the moment; [use _syscall4 to call it](http://www.dejanews.com/getdoc.xp?AN=422899634). Andi Kleen is writing new man pages that cover this. See also [Exploring The sendfile System Call](http://www.linuxgazette.com/issue91/tranter.html) by Jeff Tranter in Linux Gazette issue 91.) [Rumor has it](http://www.dejanews.com/getdoc.xp?AN=423005088), ftp.cdrom.com benefitted noticeably from sendfile(). 
        
        Linux和FreeBSD中的sendfile()函数允许您告诉内核发送部分或全部文件. 使操作系统尽可能高效地完成。 它可以在使用非阻塞 I/O 的线程或服务器的服务器中同样使用.(在 Linux中,目前他的记录还很少;[使用_syscall4 去调用它](http://www.dejanews.com/getdoc.xp?AN=422899634).Andi Kleen 正在写覆盖该内容的 man 页面.另请参阅Jeff Tranter在Linux Gazette issue 91中[探索 sendfile 系统调用](http://www.linuxgazette.com/issue91/tranter.html).) 有[传言](http://www.dejanews.com/getdoc.xp?AN=423005088)称 ftp.cdrom.com 受益于 sendfile().
        
        A zero-copy implementation of sendfile() is on its way for the 2.4 kernel. See [LWN Jan 25 2001](http://lwn.net/2001/0125/kernel.php3).
        
        sendfile() 的零拷贝实现正在为2.4内核提供.看[LWN Jan 25 2001](http://lwn.net/2001/0125/kernel.php3).
        
        One developer using sendfile() with Freebsd reports that using POLLWRBAND instead of POLLOUT makes a big difference.
        
        一个开发者在 Freebsd 下使用 sendfile() 的报告显示使用 POLLWRBAND 而不是 POLLOUT 会产生很大的不同.
        
        Solaris 8 (as of the July 2001 update) has a new system call 'sendfilev'. [A copy of the man page is here.](sendfilev.txt). The Solaris 8 7/01 [release notes](http://www.sun.com/software/solaris/fcc/ucc-details701.html) also mention it. I suspect that this will be most useful when sending to a socket in blocking mode; it'd be a bit of a pain to use with a nonblocking socket.
        
        Solaris 8 (截至2001年7月更新) 有一个新的系统调用'sendfilev'.[手册页的副本在这里](sendfilev.txt). Solaris 8 7/01 [发版说明](http://www.sun.com/software/solaris/fcc/ucc-details701.html) 也提到了它.我怀疑这在以阻塞模式发送到套接字时最有用;使用非阻塞套接字会有点痛苦。
        
*   Avoid small frames by using writev (or TCP_CORK)  

* 	使用writev避免使用小帧(或者 TCP_CORK)

    A new socket option under Linux, TCP_CORK, tells the kernel to avoid sending partial frames, which helps a bit e.g. when there are lots of little write() calls you can't bundle together for some reason. Unsetting the option flushes the buffer. Better to use writev(), though...
    
    一个新的在 Linux 下的套接字选项, TCP_CORK,告诉内核去避免发送部分帧,这有点帮助,例如当有很多小的 write() 调用时,由于某种原因你不能捆绑在一起.取消设置选项会刷新缓冲区.最好使用writev(),但......

    
    See [LWN Jan 25 2001](http://lwn.net/2001/0125/kernel.php3) for a summary of some very interesting discussions on linux-kernel about TCP_CORK and a possible alternative MSG_MORE.
    
    看[LWN Jan 25 2001](http://lwn.net/2001/0125/kernel.php3),关于TCP-CORK和可能的替代MSG_MORE的关于linux-kernel的一些非常有趣的讨论的摘要.
    
*   Behave sensibly on overload.  

* 	在过载时表现得智能.

    [[Provos, Lever, and Tweedie 2000](http://www.citi.umich.edu/techreports/reports/citi-tr-00-7.ps.gz)] notes that dropping incoming connections when the server is overloaded improved the shape of the performance curve, and reduced the overall error rate. They used a smoothed version of "number of clients with I/O ready" as a measure of overload. This technique should be easily applicable to servers written with select, poll, or any system call that returns a count of readiness events per call (e.g. /dev/poll or sigtimedwait4()).

	  [[Provos, Lever, and Tweedie 2000](http://www.citi.umich.edu/techreports/reports/citi-tr-00-7.ps.gz)]提到在服务器过载时丢弃传入连接可以改善性能曲线的形状,并降低整体错误率.他们使用平滑版本的" I/O 就绪客户端数"作为过载的衡量标准.此技术应该很容易应用于使用 select, poll 或任何系统调用编写的服务器,这些调用返回每次调用的就绪事件技术（例如 /dev/poll 或 sigtimedwait4()).

*   Some programs can benefit from using non-Posix threads. 

*   某些程序可以从使用非Posix线程中受益.
 
    Not all threads are created equal. The clone() function in Linux (and its friends in other operating systems) lets you create a thread that has its own current working directory, for instance, which can be very helpful when implementing an ftp server. See Hoser FTPd for an example of the use of native threads rather than pthreads.
    
    并非所有线程都是相同的.例如,Linux 中的 clone() 函数（及其在其他操作系统中的朋友）允许您创建具有其自己的当前工作目录的线程,这在实现ftp服务器时非常有用.有关使用本机线程而不是 pthreads 的示例，请参阅 Hoser FTPd。
    

*   Caching your own data can sometimes be a win.  

*   缓存自己的数据有时可能是一个胜利.

    "Re: fix for hybrid server problems" by Vivek Sadananda Pai (vivek@cs.rice.edu) on [new-httpd](http://www.humanfactor.com/cgi-bin/cgi-delegate/apache-ML/nh/1999/), May 9th, states:
    
    Vivek Sadananda Pai(vivek@cs.rice.edu)在 [new-httpd](http://www.humanfactor.com/cgi-bin/cgi-delegate/apache-ML/nh/1999/)"回复: 修复混合服务器问题",5月9日,声明:
    
    > "I've compared the raw performance of a select-based server with a multiple-process server on both FreeBSD and Solaris/x86. On microbenchmarks, there's only a marginal difference in performance stemming from the software architecture. The big performance win for select-based servers stems from doing application-level caching. While multiple-process servers can do it at a higher cost, it's harder to get the same benefits on real workloads (vs microbenchmarks). I'll be presenting those measurements as part of a paper that'll appear at the next Usenix conference. If you've got postscript, the paper is available at [http://www.cs.rice.edu/~vivek/flash99/](http://www.cs.rice.edu/~vivek/flash99/)"
    
    > "我在 FreeBSD 和 Solaris/x86 上比较了基于 select 的服务器和多进程服务器的原始性能.在微基准测试中,软件架构的性能差异很小.基于 select 的服务器的巨大性能优势源于进行应用程序级缓存.虽然多进程服务器可以以更高的成本实现,但实际工作负载(与微基准测试相比)更难获得相同的好处.我将把这些测量结果作为论文的一部分展示，这些论文将出现在下一届Usenix会议上.如果你有后记，那么论文可以在[http://www.cs.rice.edu/~vivek/flash99/](http://www.cs.rice.edu/~vivek/flash99/)"

### Other limits

### 其他限制

*   Old system libraries might use 16 bit variables to hold file handles, which causes trouble above 32767 handles. glibc2.1 should be ok.

*   旧系统库可能使用16位变量来保存文件句柄,这会导致32767句柄之上的麻烦.glibc2.1应该没问题。

*   Many systems use 16 bit variables to hold process or thread id's. It would be interesting to port the [Volano scalability benchmark](http://www.volano.com/benchmarks.html) to C, and see what the upper limit on number of threads is for the various operating systems.

*   许多系统使用16位变量来保存进程或线程ID.将[Volano可伸缩性基准测试](http://www.volano.com/benchmarks.html) 移植到C会很有意思，看看各种操作系统的线程数上限是多少.

*   Too much thread-local memory is preallocated by some operating systems; if each thread gets 1MB, and total VM space is 2GB, that creates an upper limit of 2000 threads.

*   某些操作系统预先分配了过多的线程本地内存;如果每个线程获得1MB,并且总VM空间为2GB,则会创建2000个线程的上限.


*   Look at the performance comparison graph at the bottom of [http://www.acme.com/software/thttpd/benchmarks.html](http://www.acme.com/software/thttpd/benchmarks.html). Notice how various servers have trouble above 128 connections, even on Solaris 2.6? Anyone who figures out why, let me know.  

*   查看[http://www.acme.com/software/thttpd/benchmarks.html](http://www.acme.com/software/thttpd/benchmarks.html) 底部的性能对比图.请注意各种服务器如何在 128个 以上的连接上出现问题,甚至在 Solaris 2.6上 知道原因的人,让我知道.

Note: if the TCP stack has a bug that causes a short (200ms) delay at SYN or FIN time, as Linux 2.2.0-2.2.6 had, and the OS or http daemon has a hard limit on the number of connections open, you would expect exactly this behavior. There may be other causes.

注意: 如果TCP堆栈有一个bug,导致 SYN 或 FIN 时间更短(200ms)延迟,如 Linux 2.2.0-2.2.6 所示,并且操作系统或 http 守护程序对连接数有硬限制,你会期待这种行为.可能还有其他原因.

### Kernel Issues

### 内核问题



For Linux, it looks like kernel bottlenecks are being fixed constantly. See [Linux Weekly News](http://lwn.net), [Kernel Traffic](http://www.kt.opensrc.org/), [the Linux-Kernel mailing list](http://marc.theaimsgroup.com/?l=linux-kernel), and [my Mindcraft Redux page](mindcraft_redux.html).

对于Linux,看起来内核瓶颈正在不断修复.看[Linux Weekly News](http://lwn.net),[Kernel Traffic](http://www.kt.opensrc.org/), [the Linux-Kernel mailing list](http://marc.theaimsgroup.com/?l=linux-kernel),和[my Mindcraft Redux page](mindcraft_redux.html).


In March 1999, Microsoft sponsored a benchmark comparing NT to Linux at serving large numbers of http and smb clients, in which they failed to see good results from Linux. See also [my article on Mindcraft's April 1999 Benchmarks](mindcraft_redux.html) for more info.

1999年3月,微软赞助了一项比较 NT 和 Linux 的基准测试,用于服务大量的 http 和 smb客户端,但是他们没有看到Linux的良好结果.另见[关于Mindcraft 1999年4月基准测试的文章](mindcraft_redux.html)了解更多信息

See also [The Linux Scalability Project](http://www.citi.umich.edu/projects/citi-netscape/). They're doing interesting work, including [Niels Provos' hinting poll patch](http://linuxwww.db.erau.edu/mail_archives/linux-kernel/May_99/4105.html), and some work on the [thundering herd problem](http://www.citi.umich.edu/projects/linux-scalability/reports/accept.html).


另请参见[Linux可扩展性项目](http://www.citi.umich.edu/projects/citi-netscape/).他们正在做有趣的工作.包括[Niels Provos的暗示民意调查补丁](http://linuxwww.db.erau.edu/mail_archives/linux-kernel/May_99/4105.html),关于[雷鸣般的群体问题](http://www.citi.umich.edu/projects/linux-scalability/reports/accept.html)的一些工作.


See also [Mike Jagdis' work on improving select() and poll()](http://www.purplet.demon.co.uk/linux/select/); here's [Mike's post](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9909_01/msg00964.html) about it.

另请参与[Mike Jagdis致力于改进 select() 和 poll()](http://www.purplet.demon.co.uk/linux/select/);这是Mike关于它的[帖子](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9909_01/msg00964.html).

[Mohit Aron (aron@cs.rice.edu) writes that rate-based clocking in TCP can improve HTTP response time over 'slow' connections by 80%.](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9910_02/msg00889.html)

[Mohit Aron（aron@cs.rice.edu）写道，TCP中基于速率的时钟可以将"缓慢"连接上的HTTP响应时间提高80％](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9910_02/msg00889.html)



### Measuring Server Performance

### 测量服务器性能

Two tests in particular are simple, interesting, and hard:

特别是两个测试简单,有趣,而且很难：

1.  raw connections per second (how many 512 byte files per second can you serve?)

1.  每秒原始连接数(每秒可以提供多少512字节文件?)

2.  total transfer rate on large files with many slow clients (how many 28.8k modem clients can simultaneously download from your server before performance goes to pot?)

2.  具有许多慢速客户端的大型文件的总传输速率(在性能进入底池之前,有多少 28.8k 调制解调器客户端可以同时从服务器下载?)


Jef Poskanzer has published benchmarks comparing many web servers. See [http://www.acme.com/software/thttpd/benchmarks.html](http://www.acme.com/software/thttpd/benchmarks.html) for his results.

Jef Poskanzer发布了比较许多Web服务器的基准测试.看他的结果[http://www.acme.com/software/thttpd/benchmarks.html](http://www.acme.com/software/thttpd/benchmarks.html)

I also have [a few old notes about comparing thttpd to Apache](http://www.alumni.caltech.edu/~dank/fixing-overloaded-web-server.html) that may be of interest to beginners.

我也有[关于将thttpd与Apache比较的一些旧笔记](http://www.alumni.caltech.edu/~dank/fixing-overloaded-web-server.html)可能对初学者感兴趣.

[Chuck Lever keeps reminding us](http://linuxhq.com/lnxlists/linux-kernel/lk_9906_02/msg00248.html) about [Banga and Druschel's paper on web server benchmarking](http://www.cs.rice.edu/CS/Systems/Web-measurement/paper/paper.html). It's worth a read.

[Chuck Lever不断提醒](http://linuxhq.com/lnxlists/linux-kernel/lk_9906_02/msg00248.html)我们关于[Banga和Druschel关于Web服务器基准测试的论文](http://www.cs.rice.edu/CS/Systems/Web-measurement/paper/paper.html).值得一读。


IBM has an excellent paper titled [Java server benchmarks](http://www.research.ibm.com/journal/sj/391/baylor.html) [Baylor et al, 2000]. It's worth a read.

IBM有一篇名为[Java服务器基准测试](http://www.research.ibm.com/journal/sj/391/baylor.html)的优秀论文.[Baylor 等,2000年].值得一读。


## Examples

## 例子

[Nginx](http://nginx.org) is a web server that uses whatever high-efficiency network event mechanism is available on the target OS. It's getting popular; there are even [two](http://www.amazon.com/Nginx-HTTP-Server-Cl%C3%A9ment-Nedelcu/dp/1849510865/ref=sr_1_2?s=books&ie=UTF8&qid=1311267645&sr=1-2) [books](http://www.amazon.com/Nginx-HTTP-Server-Cl%C3%A9ment-Nedelcu/dp/1849510865/ref=sr_1_2?s=books&ie=UTF8&qid=1311267645&sr=1-2) about it.

[Nginx](http://nginx.org) 是一个web服务器，它使用目标操作系统上可用的任何高效网络事件机制.它变得非常流行;这甚至有关于它的[两本](http://www.amazon.com/Nginx-HTTP-Server-Cl%C3%A9ment-Nedelcu/dp/1849510865/ref=sr_1_2?s=books&ie=UTF8&qid=1311267645&sr=1-2)[书](http://www.amazon.com/Nginx-HTTP-Server-Cl%C3%A9ment-Nedelcu/dp/1849510865/ref=sr_1_2?s=books&ie=UTF8&qid=1311267645&sr=1-2)

### Interesting select()-based servers

### 有趣的基于 select() 的服务器

*   [thttpd](http://www.acme.com/software/thttpd/) Very simple. Uses a single process. It has good performance, but doesn't scale with the number of CPU's. Can also use kqueue.

*   [thttpd](http://www.acme.com/software/thttpd/) 非常简单. 使用单进程.他有非常好的性能,但是它不会随着 CPU 的数量而扩展. 也可以使用kqueue.

*   [mathopd](http://mathop.diva.nl/). Similar to thttpd.

*   [mathopd](http://mathop.diva.nl/). 和thttpd相似.
   
*   [fhttpd](http://www.fhttpd.org/)

*   [fhttpd](http://www.fhttpd.org/)

*   [boa](http://www.boa.org/)

*   [boa](http://www.boa.org/)

*   [Roxen](http://www.roxen.com/)

*   [Roxen](http://www.roxen.com/)

*   [Zeus](http://www.zeustech.net/), a commercial server that tries to be the absolute fastest. See their [tuning guide](http://support.zeustech.net/faq/entries/tuning.html).

*   [Zeus](http://www.zeustech.net/),试图成为绝对最快的商业服务器.看他们的 [调整指导](http://support.zeustech.net/faq/entries/tuning.html).

*   The other non-Java servers listed at [http://www.acme.com/software/thttpd/benchmarks.html](http://www.acme.com/software/thttpd/benchmarks.html)

*   其他非 Java 服务列在[http://www.acme.com/software/thttpd/benchmarks.html](http://www.acme.com/software/thttpd/benchmarks.html)

*   [BetaFTPd](http://ca.us.mirrors.freshmeat.net/appindex/1999/02/17/919251275.html)

*   [BetaFTPd](http://ca.us.mirrors.freshmeat.net/appindex/1999/02/17/919251275.html)

*   [Flash-Lite](http://www.cs.rice.edu/~vivek/iol98/) - web server using IO-Lite.

*   [Flash-Lite](http://www.cs.rice.edu/~vivek/iol98/) - 使用 IO-Lite 的Web服务器。

*   [Flash: An efficient and portable Web server](http://www.cs.rice.edu/~vivek/flash99/) - uses select(), mmap(), mincore()

*   [Flash: 高效便携的Web服务器](http://www.cs.rice.edu/~vivek/flash99/) - 使用select(), mmap(), mincore().

*   [The Flash web server as of 2003](http://www.cs.princeton.edu/~yruan/debox/) - uses select(), modified sendfile(), async open()

*  	[截至2003年的Flash Web服务器](http://www.cs.princeton.edu/~yruan/debox/) - 使用 select(), 修改的 sendfile(), 异步 open()

*   [xitami](http://www.imatix.com/html/xitami/) - uses select() to implement its own thread abstraction for portability to systems without threads.

*   [xitami](http://www.imatix.com/html/xitami/) - 使用 select() 去实现它自己的线程抽象,以便无需线程的系统的可移植性.

*   [Medusa](http://www.nightmare.com/medusa/medusa.html) - a server-writing toolkit in Python that tries to deliver very high performance.

*   [Medusa](http://www.nightmare.com/medusa/medusa.html) - Python中的服务器编写工具包，旨在提供非常高的性能。

*   [userver](http://www.hpl.hp.com/research/linux/userver/) - a small http server that can use select, poll, epoll, or sigio

*   [userver](http://www.hpl.hp.com/research/linux/userver/) - 一个小的http服务器，可以使用select，poll，epoll或sigio


### Interesting /dev/poll-based servers

### 有趣的基于 /dev/poll 服务器

*   _N. Provos, C. Lever_, ["Scalable Network I/O in Linux,"](http://www.citi.umich.edu/techreports/reports/citi-tr-00-4.pdf) May, 2000. [FREENIX track, Proc. USENIX 2000, San Diego, California (June, 2000).] Describes a version of thttpd modified to support /dev/poll. Performance is compared with phhttpd.

* _N.Provos，C.Lever_,["Scalable Network I/O in Linux"](http://www.citi.umich.edu/techreports/reports/citi-tr-00-4.pdf)2000年5月.[ FREENIX track,Proc.USENIX 2000,San Diego,California（2000年6月).]描述了被修改为支持 /dev/poll的 thttpd 版.将性能与phhttpd进行比较。

### Interesting epoll-based servers

### 有趣的基于 epoll 服务器

*   [ribs2](https://github.com/Adaptv/ribs2)
*   [ribs2](https://github.com/Adaptv/ribs2)
*   [cmogstored](http://bogomips.org/cmogstored/README) - uses epoll/kqueue for most networking, threads for disk and accept4
*   [cmogstored](http://bogomips.org/cmogstored/README) - 对大多数网络使用epoll/kqueue,对磁盘和accept4使用线程

### Interesting kqueue()-based servers

### 有趣的基于 kqueue() 服务器

*   [thttpd](http://www.acme.com/software/thttpd/) (as of version 2.21?)

*   [thttpd](http://www.acme.com/software/thttpd/) (从版本2.21开始?)

*   Adrian Chadd says "I'm doing a lot of work to make squid actually LIKE a kqueue IO system"; it's an official Squid subproject; see [http://squid.sourceforge.net/projects.html#commloops](http://squid.sourceforge.net/projects.html#commloops). (This is apparently newer than [Benno](http://www.advogato.org/person/benno/)'s [patch](http://netizen.com.au/~benno/squid-select.tar.gz).)

*  Adrian Chadd 说 "我正在做很多工作来使squid实际上像一个kqueue IO系统";他的官方Squid子项目;看[http://squid.sourceforge.net/projects.html#commloops](http://squid.sourceforge.net/projects.html#commloops).这显然比[Benno](http://www.advogato.org/person/benno/)的[补丁](http://netizen.com.au/~benno/squid-select.tar.gz)更新

### Interesting realtime signal-based servers

### 有趣的基于实时信号服务器.

*   Chromium's X15. This uses the 2.4 kernel's SIGIO feature together with sendfile() and TCP_CORK, and reportedly achieves higher speed than even TUX. The [source is available](http://www.chromium.com/cgi-bin/crosforum/YaBB.pl) under a community source (not open source) license. See [the original announcement](http://boudicca.tux.org/hypermail/linux-kernel/2001week21/1624.html) by Fabio Riccardi.

*   Chromium 的 X15.这使用2.4内核 SIGIO 功能以及 sendfile() 和 TCP_CORK，据报道甚至比TUX实现更高的速度. 在社区源许可下的[源码是可用的](http://www.chromium.com/cgi-bin/crosforum/YaBB.pl).看 Fabio Riccardi [原始公告](http://boudicca.tux.org/hypermail/linux-kernel/2001week21/1624.html)

*   Zach Brown's [phhttpd](http://www.zabbo.net/phhttpd/) - "a quick web server that was written to showcase the sigio/siginfo event model. consider this code highly experimental and yourself highly mental if you try and use it in a production environment." Uses the [siginfo](#nb.sigio) features of 2.3.21 or later, and includes the needed patches for earlier kernels. Rumored to be even faster than khttpd. See [his post of 31 May 1999](http://www.cs.helsinki.fi/linux/linux-kernel/Year-1999/1999-22/0453.html) for some notes.

*   Zach Brown 的 [phhttpd](http://www.zabbo.net/phhttpd/) - "一个更快的服务服务器, 它用于展示 sigio/siginfo 事件模型.如果您尝试在生产环境中使用它,请将此代码视为高度实验性的,同时您自己也格外注意" 使用 2.3.21或之后的 [siginfo](#nb.sigio) 特性, 包含了需要的更内核补丁.据传甚至比khttpd更快.见他1999年5月31日的一些[说明](http://www.cs.helsinki.fi/linux/linux-kernel/Year-1999/1999-22/0453.html)

### Interesting thread-based servers

### 有趣的基于线程的服务器

*   [Hoser FTPD](http://www.zabbo.net/hftpd/). See their [benchmark page](http://www.zabbo.net/hftpd/bench.html).

* 	[Hoser FTPD](http://www.zabbo.net/hftpd/). 看他的[基准页面](http://www.zabbo.net/hftpd/bench.html)

*   [Peter Eriksson's phttpd](http://ca.us.mirrors.freshmeat.net/appindex/1999/02/06/918317238.html) and

* 	[Peter Eriksson的phttpd](http://ca.us.mirrors.freshmeat.net/appindex/1999/02/06/918317238.html) 和

*   [pftpd](http://ca.us.mirrors.freshmeat.net/appindex/1999/02/06/918313631.html)

*   [pftpd](http://ca.us.mirrors.freshmeat.net/appindex/1999/02/06/918313631.html)

*   The Java-based servers listed at [http://www.acme.com/software/thttpd/benchmarks.html](http://www.acme.com/software/thttpd/benchmarks.html)

* 	基于Java的服务列在[http://www.acme.com/software/thttpd/benchmarks.html](http://www.acme.com/software/thttpd/benchmarks.html)

*   Sun's [Java Web Server](http://jserv.javasoft.com/) (which has been [reported to handle 500 simultaneous clients](http://archives.java.sun.com/cgi-bin/wa?A2=ind9901&L=jserv-interest&F=&S=&P=47739))

* Sun的[Java Web 服务器](http://jserv.javasoft.com/) (它已经[被报道过可以同时处理500客户端](http://archives.java.sun.com/cgi-bin/wa?A2=ind9901&L=jserv-interest&F=&S=&P=47739))

### Interesting in-kernel servers

### 有趣的基于内核的服务器

*   [khttpd](http://www.fenrus.demon.nl)

*   [khttpd](http://www.fenrus.demon.nl)

*   ["TUX" (Threaded linUX webserver)](http://slashdot.org/comments.pl?sid=00/07/05/0211257&cid=218) by Ingo Molnar et al. For 2.4 kernel.

*   Ingo Molnar等人的["TUX" Threaded linUX webserver](http://slashdot.org/comments.pl?sid=00/07/05/0211257&cid=218).2.4内核.



### Other interesting links

### 其他有趣的链接

*   [Jeff Darcy's notes on high-performance server design](http://pl.atyp.us/content/tech/servers.html)

* 	[Jeff Darcy在设计高性能服务器的设计笔记](http://pl.atyp.us/content/tech/servers.html)

*   [Ericsson's ARIES project](http://www2.linuxjournal.com/lj-issues/issue91/4752.html) - benchmark results for Apache 1 vs. Apache 2 vs. Tomcat on 1 to 12 processors

* 	[Ericsson的 ARIES 工程](http://www2.linuxjournal.com/lj-issues/issue91/4752.html) - 在1到12个处理器上,Apache 1与Apache 2对比Tomcat的基准测试结果

*   [Prof. Peter Ladkin's Web Server Performance](http://nakula.rvs.uni-bielefeld.de/made/artikel/Web-Bench/web-bench.html) page.

*   [Prof. Peter Ladkin 的Web服务器性能](http://nakula.rvs.uni-bielefeld.de/made/artikel/Web-Bench/web-bench.html)页面

*   [Novell's FastCache](http://www.novell.com/bordermanager/ispcon4.html) - claims 10000 hits per second. Quite the pretty performance graph.

*   [Novell 的快速缓存](http://www.novell.com/bordermanager/ispcon4.html) - 声称每秒点击10000次.相当漂亮的性能图.

*   Rik van Riel's [Linux Performance Tuning site](http://linuxperf.nl.linux.org/)

*   Rik van Riel 的[Linux性能调优网站](http://linuxperf.nl.linux.org/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
