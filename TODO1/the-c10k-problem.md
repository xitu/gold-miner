> * 原文地址：[The C10K problem](http://www.kegel.com/c10k.html)
> * 原文作者：[www.kegel.com](http://www.kegel.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-c10k-problem.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-c10k-problem.md)
> * 译者：[kobehaha](https://github.com/kobehaha)
> * 校对者：

# C10K 问题

现在 web 服务器能够同时处理上万请求，难道不是吗？毕竟如今的网络将会有很大的发展空间。

计算机也同样强大，你可以花 $1200 买一台 1000MHz，2G 内存和 1000Mbits/sec 的网卡的机器。让我们来看看 — 20000 客户端，每个客户端 50KHz，1000Kb 和每秒 50Kb，那没有什么比这每两万个客户端的每个每秒从磁盘中取出4千字节并将它们每秒发送到网络上去更消耗资源了。(顺便说一下，每个客户端 $0.0.8，一些操作系统收费的每个客户端 $100 的许可费看起来有点沉重)所以硬件不再是一种瓶颈。

在1999年，最繁忙的 ftp 网站之一，cdrom.com，实际上通过一个千兆以太网网卡同时处理 10000个客户端。截至2001年，现在相同的速度也被[ISP 提供](http://www.senteco.com/telecom/ethernet.htm)，他们希望它变得越来越受大型企业客户的欢迎。

轻量级的客户端计算模型似乎又开始变得流行起来了 - 服务器在互联网上运行，为数千个客户提供服务。

基于以上的一些考虑，这有一些关于如何配置操作系统和编写支持数千客户端的代码问题提出了一些注意点。讨论的中心的主要是围绕着类Unix操作系统，因为这是我个人感兴趣的领域，但是Windows也会涉及一点。

## 内容

- [C10K 问题](#the-c10k-problem)
  - [内容](#contents)
  - [相关网站](#related-sites)
  - [预读书籍](#book-to-read-first)
    - [I/O 框架](#io-frameworks)
    - [I/O 策略](#io-strategies)
    - [1. 一个线程服务多个客户端，使用非阻塞 IO 和**水平触发**的就绪通知](#1-serve-many-clients-with-each-thread-and-use-nonblocking-io-and-level-triggered-readiness-notification)
    - [2. 一个线程服务多个客户端，使用非阻塞 IO 和就绪**改变**通知](#2-serve-many-clients-with-each-thread-and-use-nonblocking-io-and-readiness-change-notification)
    - [3. 一个线程服务多个客户端，使用异步 I/O](#3-serve-many-clients-with-each-server-thread-and-use-asynchronous-io)
    - [4. 一个线程服务一个客户端](#4-serve-one-client-with-each-server-thread)
      - [Linux 线程](#linuxthreads)
      - [NGPT: Linux 的下一代 Posix 线程](#ngpt-next-generation-posix-threads-for-linux)
      - [NPTL: Linux 原生的 Posix 线程库](#nptl-native-posix-thread-library-for-linux)
      - [FreeBSD 线程支持](#freebsd-threading-support)
      - [NetBSD 线程支持](#netbsd-threading-support)
      - [Solaris 线程支持](#solaris-threading-support)
      - [JDK 1.3.x 及更早版本中的Java线程支持](#java-threading-support-in-jdk-13x-and-earlier)
      - [注意：1:1 线程与 M:N线程](#note-11-threading-vs-mn-threading)
    - [5. 将服务端代码构建到内核中](#5-build-the-server-code-into-the-kernel)
  - [将 TCP 协议栈带入用户空间](#bring-the-tcp-stack-into-userspace)
  - [评论](#comments)
  - [打开文件句柄的限制](#limits-on-open-filehandles)
  - [线程限制](#limits-on-threads)
  - [Java 问题](#java-issues)
  - [其他建议](#other-tips)
    - [其他限制](#other-limits)
    - [内核问题](#kernel-issues)
    - [测试服务性能](#measuring-server-performance)
  - [例子](#examples)
    - [有趣的基于 select() 的服务器](#interesting-select-based-servers)
    - [有趣的基于 /dev/poll 的服务器](#interesting-devpoll-based-servers)
    - [有趣的基于 epoll 的服务器](#interesting-epoll-based-servers)
    - [有趣的基于 kqueue() 的服务器](#interesting-kqueue-based-servers)
    - [有趣的基于实时信号的服务器](#interesting-realtime-signal-based-servers)
    - [有趣的基于线程的服务器](#interesting-thread-based-servers)
    - [有趣的内核服务器](#interesting-in-kernel-servers)
    - [其他有趣的链接](#other-interesting-links)

## 相关网站

参阅下 Nick Black 的杰出的 [快速的 Unix 服务器](http://dank.qemfd.net/dankwiki/index.php/Network_servers)页面，了解大约2009的情况。

在 2003 年 10 月，Felix von Leitner 整理了一个优秀的关于网络可扩展性的[网站](http://bulk.fefe.de/scalability/)和[演示](http://bulk.fefe.de/scalable-networking.pdf)，完成了多种不同的网络系统调用和操作系统的性能比较。其中一个发现是 linux 2.6 内核击败了 2.4 内核，当然这里有很多很好的图片会给操作系统开发人员在平时提供点想法。(另见 [Slashdot](http://developers.slashdot.org/developers/03/10/19/0130256.shtml?tid=106&tid=130&tid=185&tid=190) 的评论；看看是否有人对基于菲利克斯的基准进行改进将会很有趣结果)。

## 预读书籍

如果你没有阅读过 the late W. Richard Stevens 的 [Unix 网络编程：网络 Apis：套接字和 Xti（第 1 卷)](http://www.amazon.com/exec/obidos/ASIN/013490012X/)的拷贝，请尽快获取一份，它描述了很多的于 I/O 策略和编写高性能服务器的陷阱。它甚至谈到了 ['thundering herd'](http://www.citi.umich.edu/projects/linux-scalability/reports/accept.html)问题。当你在阅读它时，请阅读 [Jeff Darcy 写的关于高性能服务器设计](http://pl.atyp.us/content/tech/servers.html)。

（另外一本书[构建可扩展的网站](http://www.amazon.com/gp/product/0596102356)可能会对**使用**而不是**编写**一个web服务器的人会有帮助）


### I/O 框架

以下提供了几个预打包的库，它们抽象了下面介绍的一些技术，使代码与操作系统隔离，并使其更具可移植性。

*   [ACE](http://www.cs.wustl.edu/~schmidt/ACE.html)，一个重量级的 C++ I/O 框架，包含一些用面对对象的思想实现的 I/O 策略和许多其他有用的事情。特别的，他的 Reactor 以面对对象的方式执行非阻塞 I/O，Proactor 是一种面对对象处理异步 I/O 的的方式。

*   [ASIO](http://asio.sf.net) 是一个 C++ I/O 框架，它正在成为Boost的一部分。这就像是为 STL 时代更新的ACE。

*   [libevent](http://monkey.org/~provos/libevent) 是 Niels Provos 写的一个轻量级的 C I/O 框架。它支持 kqueue 和 select，即将支持 poll 和 epoll。我想它应该只采用了**水平触发**，这具有两面性。Niels给了一个图来说明时间和连接数目在处理一个事件上的功能，图中可以看出kqueue 和 sys_epoll 是明显的赢家。

*   我自己在轻量级框架的尝试(可惜的是没有保持更新):

   *   [Poller](http://www.kegel.com/dkftpbench/Poller_bench.html) 是一个轻量级的 C++ I/O 框架，它能使用任何一种准备就绪API(poll， select， /dev/poll， kqueue， sigio)实现水平触发准备就绪API。[以其他多种 API 为基础测试](http://www.kegel.com/dkftpbench/Poller_bench.html)，Poll的性能好的多.文档链到下面的Poller 子类，该链接文档的下面一部分说明了如何使用这些准备就绪API。
   *   [rn](http://www.kegel.com/rn/) 是一个轻量级的C I/O 框架，这是我在Poller之后的第二次尝试。他使用lgpl(因此它更容易在商业应用程序中使用) 和 C(因此更容易在非 C++ 的产品中使用)。如今它被应用在一些商业产品中。

*   Matt Welsh 在2000年4月写了一篇关于如何在构建可扩展性服务时去平衡工作线程和事件驱动使用的[论文](http://www.cs.berkeley.edu/~mdw/papers/events.pdf)，该论文描述了他的 Sandstorm I/O 框架。

*   [Cory Nelson 的Scale!库](http://svn.sourceforge.net/viewcvs.cgi/*checkout*/int64/scale/readme.txt) - 一个Windows下的异步套接字，文件，和管道 I/O 库。

### I/O 策略

网络软件的设计者有多种选择，这有一些

* 是否以及如何在单个线程发出多个 I/O 调用
	 *    不处理；使用阻塞和同步调用，尽可能的使用多个线程和进程实现并发。
	 *   使用非阻塞调用(如，在一个socket write()上设置 O_NONBLOCK) 去启动 I/O，就绪通知(如，poll() 或则 /dev/poll)知道什么时候通道是 OK 的然后开启下一个 I/O。通常这只能用于网络 I/O，而不能用于磁盘 I/O。
    *   使用异步调用(如，aio_write())去启动 I/O，完成通知(如，信号或完成端口)去通知 I/O 完成。这同时适用于网络和磁盘 I/O。

*   如何控制每个客户的服务
	*   一个进程服务一个客户(经典的 Unix 方法，从1980年左右就开始使用)
    *   一个系统级别线程服务多个客户;每个客户通过以下控制:
        *   一个用户级别线程(如. GNU 状态线程，带绿色线程的经典 java)    
        *   状态机(有点深奥，但在某些圈子里很受欢迎；我的最爱)
        *   continuation (有点深奥，但在某些圈子里很受欢迎)
    *   一个系统级线程服务单个客户(如，经典的带有原生线程的Java)
    *   一个系统级线程服务每个活跃的客户(如. Tomcat与apache的前端；NT完成端口；线程池)

*  是否使用标准系统服务，或者构建服务到内核中(如，在一些自定义驱动，内核模块，或者 VxD)

下边的5中组合似乎非常流行:

1.  一个线程服务多个客户端，使用非阻塞 I/O 和**水平触发**就绪通知
2.  一个线程服务多个客户端，使用非阻塞 I/O 和就绪**更改**通知
3.  一个线程服务多个客户端，使用异步 I/O
4.  一个线程服务多个客户端，使用阻塞 I/O
5.  将服务端代码构建到内核

### 1. 一个线程服务多个客户端，使用非阻塞 IO 和**水平触发**就绪通知

... 在所有的网络句柄上都设置为非阻塞模式，使用 select() 或者 poll() 去告知哪个网络句柄处理有数据等待。此模型是最传统的，这种模式下，内核告诉你是否一个文件描述符就绪，自从上次内核告诉你它以来，你是否对该文件描述符做了任何事情。('水平触发'这个名词来自计算机硬件设计;它与['边缘触发'](#nb.edge)相反)。Jonathon Lemon在他的[关于BSDCON 2000 paper kqueue()的论文](http://people.freebsd.org/~jlemon/papers/kqueue.pdf)中介绍了这些术语。

注意: 牢记来自内核的就绪通知只是一个提示，这一点尤为重要；当你尝试去读取文件描述符的时候，它可能没有就绪，这就是为什么需要在使用就绪通知时使用非阻塞模式的原因。

一个重要的瓶颈是 read() 或 sendfile() 从磁盘块读取时，如果该页当前并不在内存中。在设置非阻塞模式的磁盘文件处理是没有影响的。内存映射磁盘文件也是如此，首先一个服务需要磁盘 I/O 时，他的处理块，所有客户端必须等待，因此原生非线程性能将会被浪费了。 
这也就是异步 I/O 的目的，当然仅限于没有 AIO 的系统上，用多线程和多进程进行磁盘 I/O 也可能解决这个瓶颈。一种方法是使用内存映射文件，如果 mincore() 表示需要 I/O，让一个工作线程去进行 I/O 操作，并继续处理网络流量。Jef Poskanzer 提到 Pai， Druschel， and Zwaenepoel的 1999 [Flash](http://www.cs.rice.edu/~vivek/flash99/) web服务器使用这个技巧；他们在[Usenix '99](http://www.usenix.org/events/usenix99/technical.html)发表了关于它的演讲。看起来 mincore() 在 BSD-derived Unixes 上是可用的，如像[FreeBSD](http://www.freebsd.org/cgi/man.cgi?query=mincore)和Solaris，但它不是[单Unix规范](http://www.unix-systems.org/)的一部分。从kernel 2.3.51 开始，它也开始是 linux 的一部分，[感谢Chuck Lever](http://www.citi.umich.edu/projects/citi-netscape/status/mar-apr2000.html)。


但是在2003年十一月的 freebsd-hackers list， Vivek Pei 等人报道了使用他们的 Flash web 服务器有一个很好的结果，然后在攻击其瓶颈，其中发现一个瓶颈是 mincore(猜测以后这不是一个好办法)，另外一个就是 sendfile 阻塞磁盘访问；他们一种修改的 sendfile()，当他的访问磁盘页尚未处于核心状态时返回类似 EWOULDBLOCK 的内容，提升了性能。(不知道怎么告诉用户页现在是常驻的...在我看来真正需要的是aio_sendfile())他们优化的最终结果是在 1GHZ/1GB 的FreeBSD盒子上 SpecWeb99 得分约为800，这比 spec.org 上的任何文件都要好。


在非阻塞套接字的集合中，关于单一线程如何告知哪个套接字是准备就绪的，列出了几种方法:

*   **传统的 select()**
	 不幸的，select() 限制了 FD_SETSIZE 的处理。这个限制被编译到标准库和用户程序中。(一些 C 库版本让你在编译应用程序的时候提示这个限制)
    
    参阅[Poller_select](dkftpbench/doc/Poller_select.html) ([cc](dkftpbench/dkftpbench-0.44/Poller_select.cc)，[h](dkftpbench/dkftpbench-0.44/Poller_select.h))是一个如何使用 select() 与其他就绪通知模式交互的示例。

    
* 	 **传统的 poll()**
     对于 poll() 能处理的文件描述符数量的没有硬编码限制，但是当有上千连接时会变得慢，因为大多数文件描述符在某个时刻都是是空闲的，完全扫描成千上万个文件描述符会花费时间。
    
    一些操作系统(像，Solaris 8)使用像 poll hinting 的技术加速了 poll() 等，Niels Provos 在 1999 年为 Linux [实现和并利用基准测试程序测试](http://www.humanfactor.com/cgi-bin/cgi-delegate/apache-ML/nh/1999/May/0415.html)。
    
    参阅[Poller_poll](dkftpbench/doc/Poller_poll.html) ([cc](dkftpbench/dkftpbench-0.44/Poller_poll.cc)，[h](dkftpbench/dkftpbench-0.44/Poller_poll.h)，[benchmarks](dkftpbench/Poller_bench.html))是一个如何使用 poll() 与其他就绪通知模式交互的示例。
    
*   **/dev/poll**

    这是推荐在 Solaris 代替 poll 的方法
    
    /dev/poll 的背后思想就是利用 poll() 在大部分的调用时使用相同的参数。使用 /dev/poll，获取一个 /dev/poll 的文件描述符，然后把你关心的文件描述符写入到/dev/poll的描述符；然后，你就可以从该句柄中读取当前就绪文件描述符集。
    
    它悄悄的出现在 Solaris 7 中([看 patchid 106541](http://sunsolve.sun.com/pub-cgi/retrieve.pl?patchid=106541&collection=fpatches))，但是它第一次公开现身是在[Solaris 8](http://docs.sun.com:80/ab2/coll.40.6/REFMAN7/@Ab2PageView/55123?Ab2Lang=C&Ab2Enc=iso-8859-1)中；[据 Sun 透露](http://www.sun.com/sysadmin/ea/poll.html)，在750客户端的情况下，这只有 poll() 的10％的开销。
    
    在 Linux 上尝试了 /dev/poll 的各种实现，但它们都没有像 epoll 一样高效，并且从未真正完成。不推荐在Linux上使用 /dev/poll。
    
    参阅[Poller_devpoll](dkftpbench/doc/Poller_devpoll.html) ([cc](dkftpbench/dkftpbench-0.44/Poller_devpoll.cc)， [h](dkftpbench/dkftpbench-0.44/Poller_devpoll.h)[基础测试](dkftpbench/Poller_bench.html))是一个如何使用 /dev/poll 与其他就绪通知模式交互的示例。(注意 - 该示例适用于Linux /dev/poll，可能无法在 Solaris 上正常运行)
    
*   **kqueue()**

    是在 FreeBSD 系统上推荐使用的代替 poll 的方法(很快，NetBSD)。
    
    [看下边](#nb.kqueue) kqueue() 可以指定边缘触发或水平触发。

### 2. 一个线程服务多个客户端，使用非阻塞 IO 和就绪**改变**通知

就绪改变通知(或边缘就绪通知)意味着你向内核提供文件描述符，然后，当该描述符从 _not ready_ 转换为 _ready_ 时，内核会以某种方式通知你。然后它假定你已知文件描述符已准备好，同时不会再对该描述符发送类似的就绪通知，直到你在描述符上进行一些操作使得该描述符不再就绪(例如，直到你收到 EWOULDBLOCK 错误为止)发送，接收或接受呼叫，或小于请求的字节数的发送或接收传输)。

当你使用就绪改变通知时，你必须准备处理好虚假事件，因为最常见的实现是只要接收到任何数据包都发出就绪信号，而不管文件描述符是否准备就绪。

这与"[水平触发](#nb)"就绪通知相反。它对编程错误的宽容度要低一些，因为如果你只错过一个事件，那么事件的连接就会永远停滞不前。尽管如此，我发现边缘触发的就绪通知能让使用 OpenSSL 编程非阻塞客户端变得更容易，因此还是值得尝试。

[[Banga， Mogul， Drusha '99]](http://www.cs.rice.edu/~druschel/usenix99event.ps.gz)在 1999 年描述了这种类型的模式。

有几种API使应用程序检索"文件描述符准备就绪"通知：

* 	**kqueue()** 这是在 FreeBSD(很快，NetBSD)系统上推荐使用边缘触发的方法
    
    FreeBSD 4.3 和以后的版本，以及截至[2002年10月的NetBSD-current](http://kerneltrap.org/node.php?id=472)支持 poll() 的通用替代方法[kqueue()/ kevent()](http://www.FreeBSD.org/cgi/man.cgi?query=kqueue&apropos=0&sektion=0&manpath=FreeBSD+5.0-current&format=html)；它同时支持边缘触发和水平触发。(另见[Jonathan Lemon的网页](http://people.freebsd.org/~jlemon/)和他的[BSDCon 2000 关于kqueue() 的论文](http://people.freebsd.org/~jlemon/papers/kqueue.pdf))
    
    与 /dev/poll 一样，你可以分配一个监听对象，不过不是打开文件/dev/poll，而是调用kqueue() 来获得。需要改变你正在监听的事件或者要获取当前事件的列表，可以在 kqueue() 返回的描述符上调用kevent()。它不仅可以监听套接字就绪，还可以监听纯文件就绪，信号，甚至是 I/O 完成。
    
     **注意:** 截至2000年10月，FreeBSD 上的线程库与 kqueue() 无法很好地交互；因此，当kqueue() 阻塞时，整个进程都会阻塞，而不仅仅是调用kqueue()的线程。
    
    参阅 [Poller_kqueue](dkftpbench/doc/Poller_kqueue.html) ([cc](dkftpbench/dkftpbench-0.44/Poller_kqueue.cc)， [h](dkftpbench/dkftpbench-0.44/Poller_kqueue.h)，[基础测试](dkftpbench/Poller_bench.html))是一个如何使用 kqueue() 与其他就绪通知模式交互的示例。
    
    使用 kqueue() 的示例和库:
    
    *   [PyKQueue](http://people.freebsd.org/~dwhite/PyKQueue/) - kqueue() 的 Python 绑定
    *   [Ronald F. Guilmette的示例echo服务器](http://www.monkeys.com/kqueue/echo.c)；另外可以看看[他2000年9月28日写的关于freebsd.questions的帖子](http://groups.yahoo.com/group/freebsd-questions/message/223580)。
    
*   **epoll**
    这是 Linux 2.6 的内核中推荐使用的边沿触发 poll。
    
    2001年7月11日，Davide Libenzi 提出了实时信号的替代方案;他将他的补丁称之为 [/dev/epoll www.xmailserver.org/linux-patches/nio-improve.html](http://www.xmailserver.org/linux-patches/nio-improve.html)。这就像实时的信号就绪通知一样，同时它可以合并冗余事件，并且具有更高效的批量事件检索的方法。
    
    当接口从 /dev 中的特殊文件更改为系统调用 sys_epoll 后，Epoll就合并到2.5.46 版本的内核开发树中。2.4 内核可以也使用旧版 epoll 的补丁。
    
    在2002年万圣节前后，linux 内核邮件列表就统一[epoll，aio和其他事件源的问题](http://marc.theaimsgroup.com/?l=linux-kernel&m=103607925020720&w=2)进行了长时间的争论。它也会发生，但Davide首先还是集中精力打造 epoll。
    
*   Polyakov的 kevent(Linux 2.6+) 新闻报道：2006年2月9日和2006年7月9日，Evgeniy Polyakov 发布了补丁，似乎统一了epoll和aio；他的目标是支持网络AIO。看到：
    
    *   [关于 kevent 的 LWN 文章](http://lwn.net/Articles/172844/)
    *   [他7月的公告](http://lkml.org/lkml/2006/7/9/82)
    *   [他的 kevent 页面](http://tservice.net.ru/~s0mbre/old/?section=projects&item=kevent))
    *   [他的 naio 页面](http://tservice.net.ru/~s0mbre/old/?section=projects&item=naio)
    *   [一些最近的讨论](http://thread.gmane.org/gmane.linux.network/37595/focus=37673)
    
*   Drepper 的新网络接口(Linux 2.6+ 提案)
     在 OLS 2006 上，Ulrich Drepper 提出了一种新的高速异步网络API。看到：
    
    *   他的论文， "[需要异步，零拷贝网络I/O](http://people.redhat.com/drepper/newni.pdf)"
    *   [他的幻灯片](http://people.redhat.com/drepper/newni-slides.pdf)
    *   [LWN 7月22日 的文章](http://lwn.net/Articles/192410/)
    
*   **实时信号**
    Linux 2.4 内核中推荐使用的边沿触发poll。
    
    linux 2.4 内核可以通过特定的实时信号分配套接字就绪事件。示例如下:
    
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
    
    当 read() 或 write() 等普通 I/O 函数完成时，发送该信号。要使用该段的话，在循环里面，当poll() 处理完所有的描述符后，进入 sigwaitinfo()[sigwaitinfo()](http://www.opengroup.org/onlinepubs/007908799/xsh/sigwaitinfo.html) 循环。

    如果 sigwaitinfo 或 sigtimedwait 返回你的实时信号，siginfo.si_fd 和 siginfo.si_band 提供的信息几乎与 pollfd.fd 和 pollfd.revents 在调用 poll() 之后的信息相同，如果你处理该 I/O，那么就继续调用 sigwaitinfo()。

    如果 sigwaitinfo 返回传统的 SIGIO，那么信号队列溢出，你必须[通过临时将信号处理程序更改为 SIG_DFL ](http://www.cs.helsinki.fi/linux/linux-kernel/Year-1999/1999-41/0644.html)来刷新信号队列，然后回到外层 poll() 循环。
    
    参阅 [Poller_sigio](dkftpbench/doc/Poller_sigio.html) ([cc](dkftpbench/dkftpbench-0.44/Poller_sigio.cc)，[h](dkftpbench/dkftpbench-0.44/Poller_sigio.h))是一个如何使用 rtsignals 与其他就绪通知模式交互的示例。
    
    参阅[Zach Brown的phhttpd](#phhttpd)，例如直接使用此功能的代码.(还是不要; phhttpd有点难以弄清楚......)
    
    [[Provos，Lever和Tweedie 2000](http://www.citi.umich.edu/techreports/reports/citi-tr-00-7.ps.gz)]描述了 phhttpd 的最新基准，使用的不同的sigtimedwait()，sigtimedwait4()，它允许你通过一次调用检索多个信号。有趣的是 sigtimedwait4() 对他们的主要好处似乎是允许应用程序来衡量系统过载(因此它可以[行为恰当](#overload))。(请注意，poll()也提供了同样的系统负载测量）
    
*   **每个 fd 一个信号**  
    Signal-per-fd 是由 Chandra 和 Mosberger 提出的对实时信号的一种改进，它通过合并冗余事件来减少或消除实时信号队列溢出。但它并没有超越 epoll。他们的论文 ([www.hpl.hp.com/techreports/2000/HPL-2000-174.html](http://www.hpl.hp.com/techreports/2000/HPL-2000-174.html))将此方案的性能与 select() 和 /dev/poll 进行了比较。
    
    [Vitaly Luban于2001年5月18日宣布了一项实施该计划的补丁](http://boudicca.tux.org/hypermail/linux-kernel/2001week20/1353.html)；他的补丁产生于[www.luban.org/GPL/gpl.html](http://www.luban.org/GPL/gpl.html)。(注意:截至2001年9月，这个补丁在高负载下可能存在稳定性问题。[dkftpbench](dkftpbench)在大约4500个用户可能会触发oops)。
    
    参阅[Poller_sigfd](dkftpbench/doc/Poller_sigfd.html) ([cc](dkftpbench/dkftpbench-0.44/Poller_sigfd.cc)，[h](dkftpbench/dkftpbench-0.44/Poller_sigfd.h))是一个如何使用 signal-per-fd 与其他就绪通知模式交互的示例。

### 3.  一个线程服务多个客户端，使用异步 I/O

这在 Unix 至今都没有流行起来，可能是因为较少的操作系统支持了异步 I/O，也可能是因为(像非阻塞 I/O)它要求重新思考应用程序。在标准 Unix 下，异步 I/O 被[aio_ 接口](http://www.opengroup.org/onlinepubs/007908799/xsh/realtime.html)提供(从该链接向下滚动到"异步输入和输出")，它将信号和值与每个 I/O操作相关联。信号及其值排队并有效地传递给用户进程。这是来自 POSIX 1003.1b 实时扩展，也是单Unix规范第二版本。

AIO通常与边缘触发完成通知一起使用，即当操作完成时，信号排队.(它也可以通过调用[aio_suspend()](http://www.opengroup.org/onlinepubs/007908799/xsh/aio_suspend.html)与水平触发的完成通知一起使用，虽然我怀疑很少有人这样做)

glibc 2.1和后续版本提供了一个普通的实现，仅仅是为了兼容标准，而不是为了获得性能上的提高。

截止linux内核 2.5.32，Ben LaHaise的 Linux AIO 实现已合并到主 Linux 内核中.它不使用内核线程，同时还具有非常高效的底层api，但是(从2.6.0-test2开始)还不支持套接字。(2.4内核还有一个 AIO 补丁，但 2.5/2.6 实现有些不同)更多信息:

* 	 网页"[Linux的内核异步 I/O(AIO)支持](http://lse.sourceforge.net/io/aio.html)，试图将有关 2.6 内核的 AIO 实现的所有信息联系在一起(2003年9月16日发布)。
*   第3轮: Benjamin C.R. LaHaise 的[aio vs /dev/epoll](http://www.linuxsymposium.org/2002/view_txt.php?text=abstract&talk=11)(2002年OLS发表)
*   [Linux2.5中的异步I/O支持](http://archive.linuxsymposium.org/ols2003/Proceedings/All-Reprints/Reprint-Pulavarty-OLS2003.pdf)由 Bhattacharya，Pratt，Pulaverty 和 Morgan，IBM提供发表在OLS'2003。
*   Suparna Bhattacharya针对[Linux的异步 I/O(aio) 设计说明](http://sourceforge.net/docman/display_doc.php?docid=12548&group_id=8875) - 将 Ben 的 AIO 与 SGI 的 KAIO 和其他一些 AIO 项目进行比较
*   [Linux AIO主页](http://www.kvack.org/~blah/aio/) - Ben 的初步补丁，邮件列表等。
*   [linux-aio邮件列表档案](http://marc.theaimsgroup.com/?l=linux-aio)
*   [libaio-oracle](http://www.ocfs.org/aio/) - 在 libaio 之上实现标准Posix AIO的库。[Joel Becker于2003年4月18日首次提到](http://marc.theaimsgroup.com/?l=linux-aio&m=105069158425822&w=2)。

Suparna还建议看看[DAFS API 对 AIO 的方法](http://www.dafscollaborative.org/tools/dafs_api.pdf)。

[Red Hat AS](http://www.ussg.iu.edu/hypermail/linux/kernel/0209.0/0832.html)和 Suse SLES 都在 2.4 内核上提供了高性能的实现.它与2.6内核实现有关，但并不完全相同。

2006年2月，网络AIO有一个新的尝试;看[上面关于Evgeniy Polyakov基于kevent的AIO的说明](#kevent)

在1999年，**[SGI为 Linux 实现了高速 AIO](http://oss.sgi.com/projects/kaio/)**，从版本1.1开始，据说可以很好地兼容磁盘 I/O 和套接字.它似乎使用内核线程.对于那些不能等待 Ben 的 AIO 支持套接字的人来说，会仍然很有用。

O'Reilly的书[POSIX.4: 真实世界的编程](http://www.oreilly.com/catalog/posix4/)据说涵盖了对aio的一个很好的介绍。

Solaris 早期非标准的 aio 实现的教程在线[Sunsite](http://sunsite.nstu.nsk.su/sunworldonline/swol-03-1996/swol-03-aio.html)。这可能值得一看，但请记住，你需要在心理上将"aioread"转换为"aio_read"等。

请注意，AIO不提供在不阻塞磁盘 I/O 的情况下打开文件的方法; 如果你关心打开磁盘文件导致休眠，Linus建议你只需在另一个线程中执行 open（）而不是是进行 aio_open() 系统调用。

在Windows下，异步 I/O 与术语"重叠 I/O "和 IOCP 或"I/O完成端口"相关联.微软的 IOCP 结合了现有技术的技术，如异步 I/O(如aio_write)和排队完成通知(如将 aio_sigevent 字段与 aio_write 一起使用时)，以及阻止某些请求尝试保持运行线程数量相关的新想法具有单个 IOCP 常量。欲获得更多信息，请参阅 sysinternals.com 上的 Mark Russinovich 撰写的[I/O 完成端口的内部](http://www.sysinternals.com/ntw2k/info/comport.shtml)，Jeffrey Richter的书 "为Microsoft Windows 2000编写服务端程序"([Amazon](http://www.amazon.com/exec/obidos/ASIN/0735607532)， [MSPress](http://www.microsoft.com/mspress/books/toc/3402.asp))， [U.S. patent #06223207](http://patft.uspto.gov/netacgi/nph-Parser?Sect1=PTO1&Sect2=HITOFF&d=PALL&p=1&u=/netahtml/srchnum.htm&r=1&f=G&l=50&s1='6223207'.WKU.&OS=PN/6223207&RS=PN/6223207)， 或者[MSDN](http://msdn.microsoft.com/library/default.asp?url=/library/en-us/fileio/filesio_4z1v.asp)。

### 4. 一个线程服务多个客户端

...让 read() 和 write() 阻塞.每个客户端使用整个栈侦会有很大的缺点，就是消耗内存。很多操作系统也难以操作处理上百个线程.如果每个线程获得2MB堆栈（不是非常见的默认值)，则在 32 位机器上的 (2^30/2 ^21）= 512 个线程上会耗尽*虚拟内存*，具有 1GB 用户可访问的VM(比如，Linux 通常在 x86 上允许)你可以通过提供更小的栈解决这个问题，但是线程一旦创建，大多数线程库都不允许增加线程栈，所以这样做就意，味着你必须使你的程序最小程度地使用内存。你也可以通过转移到64位处理器来解决这个问题。

在Linux， FreeBSD， Solaris上的线程支持是正在完善，即使对于主流用户来说，64位处理器也即将到来。也许在不就的将来，那些喜好每个客户端使用一个线程的人也有能力服务10000个客户端了。然而，在目前这个时候，如果你真的想要支持那么多客户，你可能最好还是使用其他一些方法。

对于毫不掩饰的亲线程观点的人，请参阅[为什么事件是一个坏主意(对于高并发服务器)](http://www.usenix.org/events/hotos03/tech/vonbehren.html)由von Behren，Condit和Brewer，UCB，在HotOS IX上发布。有反线营地的任何人能指出一篇反驳这篇论文的论文吗？:-)

#### Linux 线程

[Linux线程](http://pauillac.inria.fr/~xleroy/linuxthreads/)是标准Linux线程库的名称.从 glibc2.0 开始，它就集成到 glibc 中，主要是符合 Posix 标准，但性能和信号支持度上都不尽如人意。

#### NGPT: Linux 的下一代的 Posix 线程

[NGPT](http://www-124.ibm.com/pthreads/)是 IBM 启动的为 Linux 带来更好的 Posix 线程兼容性的项目。他目前的稳定版本是2.2，工作的非常好...但是 NGPT 团队[宣布](http://www-124.ibm.com/pthreads/docs/announcement)他们将 NGPT 代码库置于support-only模式，因为他们觉得这是"长期支持社区的最佳方式"。NGPT团队将会继续改进 Linux 的线程支持，但是现在主要集中在NPTL。(感谢NGPT团队的出色工作以及他们以优雅的方式转向NPTL)

#### NPTL: Linux 原生的 Posix 线程库

[NPTL](http://people.redhat.com/drepper/nptl/)是由 Ulrich Drepper([glibc](http://www.gnu.org/software/libc/) 的维护人员)和[Ulrich Drepper](http://people.redhat.com/drepper/)发起的，目的是为Linux带来的 world-class Posix 线程库支持。

截至2003年10月5日，NPTL 现在作为附加目录合并到 glibc cvs 树中(就像linux线程)，所以它几乎肯定会与 glibc 的下一个版本一起发布。

Red Hat 9 是最早的包含NPTL的发行版本(这对某些用户来说有点不方便，但有人不得不打破僵局...）

NPTL 链接:

*   [NPTL讨论的邮件列表](https://listman.redhat.com/mailman/listinfo/phil-list)
*   [NPTL源码](http://people.redhat.com/drepper/nptl/)
*   [NPTEL的初步公告](http://lwn.net/Articles/10465/)
*   [描述NPTEL目标的原始白皮书](http://people.redhat.com/drepper/glibcthreads.html)
*   [修订后的白皮书描述了NPTEL的最终设计](http://people.redhat.com/drepper/nptl-design.pdf)
*    [Ingo Molnar的](http://marc.theaimsgroup.com/?l=linux-kernel&m=103230439008204&w=2)第一个基准显示它可以处理 10^6 个线程
*   [Ulrich的基准测试](http://marc.theaimsgroup.com/?l=linux-kernel&m=103269598000900&w=2)对比了 linux 线程，NPTL，和 IBM 的 [NGPT](#threads.ngpt) 的性能。它似乎显示 NPTL 比 NGPT 更快。

这是我尝试写的描述NPTL历史的文章(也可以看看[Jerry Cooperstein的文章](http://www.onlamp.com/pub/a/onlamp/2002/11/07/linux_threads.html)):

在2002年3月， [NGPT团队的Bill Abt， glibc的维护者与Ulrich Drepper和其他人会面](http://people.redhat.com/drepper/glibcthreads.html)探讨LinuxThreads的发展.会议产生的一个想法是提高互斥性能;Rusty Russell [等人](http://marc.theaimsgroup.com/?l=linux-kernel&m=103284847815916&w=2)后来实现了[快速用户空间锁(futexes)](http://marc.theaimsgroup.com/?l=linux-kernel&m=102196625921110&w=2))，它现在被用在 NGPT 和 NPTL 中.大多数与会者认为NGPT应该被合并到glibc。

但 Ulrich Drepper 并不喜欢 NGPT，认为他可以做得更好。(对于那些试图为 glibc 做出补丁的人来说，这可能不会让人大吃一惊:-)在接下来的几个月里，Ulrich Drepper，Ingo Molnar致力于 glibc 和内核的变化，这些变化构成了 Native Posix线程库(NPTL)。NPTL使用了NGPT设计的所有内核改进，并利用一些新功能。Ingo Molnar [描述](https://listman.redhat.com/pipermail/phil-list/2002-September/000013.html)了内核增强功能如下：

> NPTL 使用 NGPT 引入的三个内核特性：getpid() 返回 PID，CLONE_THREAD 和 futexes; NPTL 还使用(并依赖)更广泛的新内核功能，作为该项目的一部分开发。
>
> 引入 2.5.8 内核的 NGPT 中的一些项目得到了修改，清理和扩展，例如线程组处理(CLONE_THREAD)。[影响 NGPT 兼容性的 CLONE_THREAD 更改与 NGPT 人员同步，以确保NGPT不会以任何不可接受的方式破坏]
>
> NPTL开发和使用的内核功能在设计白皮书中有描述，http://people.redhat.com/drepper/nptl-design.pdf ...
>
> 简短列表: TLS支持，各种克隆扩展(CLONE_SETTLS，CLONE_SETTID，CLONE_CLEARTID)，POSIX线程信号处理，sys_exit()扩展(在VM发布时发布TID futex)sys_exit_group()系统调用，sys_execve()增强功能 并支持分离的线程。
>
> 还有扩展 PID 空间的工作 - 例如，procfs由于 64K PID 的设计，为max_pid 和 pid 分配可伸缩性的工作而崩溃。此外，还进行了许多仅针对性能的改进。
>
> 本质上，新功能完全是使用1:1线程方法 - 内核现在可以帮助改进线程的所有内容，并且我们为每个基本线程原语精确地执行最低限度必需的上下文切换和内核调用。

两者之间的一个重要区别是 NPTL 是 1:1 线程模型，而 NGPT 是 M:N 线程模型(见下文)。尽管如此，[Ulrich的初步基准](https://listman.redhat.com/pipermail/phil-list/2002-September/000009.html)似乎表明NPTL确实比NGPT快得多(NGPT团队期待看到Ulrich的基准代码来验证结果)。

#### FreeBSD 线程支持

FreeBSD同时支持 linux 线程和用户空间线程库。此外，在 FreeBSD 5.0 中引入了一个名为 KSE 的 M:N 实现。概述，参阅[www.unobvious.com/bsd/freebsd-threads.html](http://www.unobvious.com/bsd/freebsd-threads.html)。

2003年3月25日，[Jeff Roberson在 freebsd-arch 上发布了帖子](http://docs.freebsd.org/cgi/getmsg.cgi?fetch=121207+0+archive/2003/freebsd-arch/20030330.freebsd-arch):

> ...感谢Julian，David Xu，Mini，Dan Eischen，和其它的每一位参加了 KSE 和 libpthread 开发的成员所提供的基础，Mini和我已经开发出了一个 1:1 模型的线程实现.此代码与 KSE 并行工作，不会以任何方式更改它。它实际上有助于通过测试共享位来使M:N线程更接近...

并于2006年7月，[Robert Watson提出的 1:1 线程应该成为FreeBsd 7.x中的默认实现](http://marc.theaimsgroup.com/?l=freebsd-threads&m=115191979412894&w=2):

> 我知道过去曾经讨论过这个问题，但我认为随着7.x向前推进，是时候重新考虑一下这个问题.在许多常见应用程序和特定场景的基准测试中，libthr 表现出比 libpthread 更好的性能... libthr 也在我们的大量平台上实现的，并且已经在几个平台上实现了 libpthread。我们对 MySQL 和其他大量线程的使用者建议是"切换到 libthr "，这也是暗示性的! ...所以草书建议是：使libthr成为 7.x 上的默认线程库。

####  NetBSD 线程支持

根据 Noriyuki Soda 的说明:

> 内核支持 M:N 基于 Scheduler Activations 模型线程库将于2003年1月18日合并到NetBSD-current中.

更多细节，看由NethanD系统公司的 Nathan J. Williams在2002年的FREENIX上的演示[An Implementation of Scheduler Activations on the NetBSD Operating System](http://web.mit.edu/nathanw/www/usenix/freenix-sa/).

#### Solaris 线程支持

Solaris中的线程正在开始支持...从 Solaris 2 到 Solaris 8，默认线程库使用 M:N 模型，但 Solaris 9 默认为 1:1 模型线程支持.看[Sun的多线程编程指导](http://docs.sun.com/db/doc/805-5080)和[Sun关于 Java 和 Solaris 线程的笔记](http://java.sun.com/docs/hotspot/threads/threads.html)

#### Java 线程从 JDK 1.3.x 及以后开始支持

众所周知，直到 JDK1.3.x 的 Java 不支持处理除每个客户端一个线程之外的任何网络连接方法.[Volanomark](http://www.volano.com/report/)是一个很好的微基准测试，它可以在不同数量连接中测量每秒消息的吞吐量。截至2003年5月，来自不同供应商的 JDK 1.3 实际上能够处理一万个同时连接 - 尽管性能显着下降.请参阅[表4](http://www.volano.com/report/#nettable)，了解哪些 JVM 可以处理 10000 个连接，以及随着连接数量的增加性能会受到影响。

#### 注意：1:1 线程与 M:N 线程

在实现线程库时有一个选择: 你可以将所有线程支持放在内核中(这称为 1:1 线程模型)，或者您可以将其中的相当一部分移动到用户空间(这称为 M:N 线程模型).有一点，M:N被认为是更高的性能，但它太复杂了，很难做到正确，大多数人都在远离它。

*   [为什么Molnar更偏好 1:1 比 M:N](http://marc.theaimsgroup.com/?l=linux-kernel&m=103284879216107&w=2)
*   [Sun正在向 1:1 线程发展](http://java.sun.com/docs/hotspot/threads/threads.html)
*   [NGPT](http://www-124.ibm.com/pthreads/)是一个 Linux M:N 线程库
*   尽管 [Ulrich Drepper 计划在新的 glibc 线程库中去使用 M:N 线程](http://people.redhat.com/drepper/glibcthreads.html)，他从那以后[切换到 1:1 线程模型](http://people.redhat.com/drepper/nptl-design.pdf)
*   [MacOSX出现使用 1:1 线程.](http://developer.apple.com/technotes/tn/tn2028.html#MacOSXThreading)
*   [FreeBSD](http://people.freebsd.org/~julian/) 和 [NetBSD](http://web.mit.edu/nathanw/www/usenix/freenix-sa/)
似乎仍然相信 M:N 线程...孤独的坚持?看起来像 freebsd 7.0 可能会切换到 1:1 线程(见上文)，所以也许 M:N 线程的信徒最终被证明是错误的。 

### 5. 将服务器代码构建到内核中

据说 Novell 和微软已经在不同的时间做过这个，至少有一个 NFS 实现是这样做的，[khttpd](http://www.fenrus.demon.nl)为Linux和静态网页做了这个，["TUX"(线程linux web服务器)](http://slashdot.org/comments.pl?sid=00/07/05/0211257&cid=218)是Ingo Molnar为Linux的一个快速且灵活的内核空间HTTP服务器. Ingo的[2000年9月1日公告](http://marc.theaimsgroup.com/?l=linux-kernel&m=98098648011183&w=2)表示可以从[ftp://ftp.redhat.com/pub/redhat/tux](ftp://ftp.redhat.com/pub/redhat/tux) 下载 TUX 的alpha版本，并解释如何加入邮件列表以获取更多信息。

linux-kernel列表一直在讨论这种方法的优点和缺点，而且似乎达成了共识，不是将 Web 服务器移动到内核中，内核应该添加最小的钩子来提高Web服务器的性能.这样，其他类型的服务器可以受益。参见例如[Zach Brown的评论](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9906_03/msg01041.html)关于 userland 与内核 http 服务器的关系。似乎2.4 linux 内核为用户程序提供了足够的功能，因为[X15](#x15)服务器的运行速度与Tux一样快，但不使用任何内核修改。


## 将TCP栈带入用户空间

例如，参见[netmap](http://info.iet.unipi.it/~luigi/netmap/)数据包 I/O 框架和[Sandstorm](http://conferences.sigcomm.org/hotnets/2013/papers/hotnets-final43.pdf)基于这个概念验证Web服务器。

## 评论

Richard Gooch已经写了一篇关于[讨论 I/O 选项的论文](http://www.atnf.csiro.au/~rgooch/linux/docs/io-events.html)。

在2001年，Tim Brecht 和 MMichal Ostrowski 测试了[多种策略](http://www.hpl.hp.com/techreports/2001/HPL-2001-314.html)为简化基于 select 的服务器，他们的数据值得一看。

在2003年，Tim Brecht发布了[userver的源代码](http://www.hpl.hp.com/research/linux/userver/)，由Abhishek Chandra， David Mosberger， David Pariag 和 Michal Ostrowski 编写的几台服务器组成的小型Web服务器。他能使用select()， poll()，或者sigio。

早在1999年3月，[Dean Gaudet的文章](http://marc.theaimsgroup.com/?l=apache-httpd-dev&m=92100977123493&w=2):

> 我不断被问到"为什么你们不使用像 Zeus 这样的基于 select/event 的模型？它显然是最快的"...

他的理由归结为"这真的很难，收益还不清楚"，然而，在几个月内，很明显人们愿意继续努力。

Mark Russinovich 写了一篇[社论](http://linuxtoday.com/stories/5499.html)和一篇[文章](http://www.winntmag.com/Articles/Index.cfm?ArticleID=5048)讨论在 linux内核2.2 中的 I/O 策略问题。值得一看，甚至他似乎在某些方面也被误导了。特别是，他似乎认为Linux 2.2 的异步 I/O (参见上面的F_SETSIG)在数据就绪时不会通知用户进程，只有当新连接到达时。这似乎是一个奇怪的误解，也可以看看[更早的草案](http://www.dejanews.com/getdoc.xp?AN=431444525)，[Ingo Molnar于1999年4月30日的反驳](http://www.dejanews.com/getdoc.xp?AN=472893693)，[Russinovich对1999年5月2日的评论](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9905_01/msg00089.html)， [一个来自Alan Cox的反驳](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9905_01/msg00263.html)，和各种[linux-kernel的帖子](http://www.dejanews.com/dnquery.xp?ST=PS&QRY=threads&DBS=1&format=threaded&showsort=score&maxhits=100&LNG=ALL&groups=fa.linux.kernel+&fromdate=jun+1+1998)，我怀疑他试图说 Linux 不支持异步磁盘I/O，这曾经是真的，但是现在 SGI 已经实现了[KAIO](#aio)，它不再那么真实了。

有关"完成端口"的信息，请参阅[sysinternals.com](http://www.sysinternals.com/ntw2k/info/comport.shtml)和[MSDN](http://msdn.microsoft.com/library/techart/msdn_scalabil.htm)上的这些页面，他说这是NT独有的;简而言之，win32的"重叠 I/O "结果太低而不方便，"完成端口"是一个提供完成事件队列的包装器，加上调试魔术试图保持运行的数量，如果从该端口获取完成事件的其他线程正在休眠(可能阻塞I/O)则允许更多线程获取完成事件，从而使线程保持不变。

另请参阅[OS/400对I/O完成端口的支持](http://www.as400.ibm.com/developer/v4r5/api.html)

1999年9月对linux-kernel进行了一次有趣的讨论"[\> 15，000个同时连接](http://www.cs.Helsinki.FI/linux/linux-kernel/Year-1999/1999-36/0160.html)"(和[线程的第二周](http://www.cs.helsinki.fi/linux/linux-kernel/Year-1999/1999-37/0612.html))。强调:

*   Ed Hall[发布](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9909_01/msg00807.html)关于他的经历的一些笔记; 他在运行Solaris的UP P2/333 上实现了 >1000次 连接/秒。他的代码使用了一小块线程(每个CPU1或2个)，每个线程使用"基于事件的模型”管理大量客户端。

*   Mike Jagdis [发布了对 poll/select 性能开销的分析](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9909_01/msg00831.html)，并说"当前的 select/poll 实现可以得到显着改善，特别是在阻塞情况下，但由于 select/poll 没有，因此开销仍会随着描述符的数量而增加，并且不能，记住哪些描述符很有趣的.这很容易用新的API修复。欢迎提出建议......"

*  Mike[发布](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9909_01/msg00964.html)关于他的[改进select()和poll()的工作](http://www.purplet.demon.co.uk/linux/select/)。

*   Mike[发布了一些可能的API来替换poll()/select()](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9909_01/msg00971.html): "你可以编写'pollfd like'结构的'device like'API怎么样，'device'监听事件并在你读它时提供代表它们的'pollfd like'结构？..."

*   Rogier Wolff [建议](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9909_01/msg00979.html)使用"数字家伙建议的API"，[http://www.cs.rice.edu/~gaurav/papers/usenix99.ps](http://www.cs.rice.edu/~gaurav/papers/usenix99.ps)

*   Joerg Pommnitz [指出](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9909_02/msg00001.html)沿着这些线路的任何新API应该不仅能够等待文件描述符事件，还能够等待信号和SYSV-IPC。我们的同步原语至少应该能够做到 Win32 的 WaitForMultipleObjects。

*   Stephen Tweedie[断言]((http://www.linuxhq.com/lnxlists/linux-kernel/lk_9909_02/msg01198.html))，_SETSIG，排队的实时信号和 sigwaitinfo() 的组合是 http://www.cs.rice.edu/~gaurav/papers/usenix99.ps 中提出的API的超集.他还提到，如果你对性能感兴趣，你可以随时阻止信号;而不是异步传递信号，进程使用sigwaitinfo()从队列中获取下一个信号。

*   Jayson Nordwick [比较](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9909_03/msg00002.html)完成端口与 F_SETSIG 同步事件模型，并得出结论，它们非常相似。

*   Alan Cox [指出](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9909_03/msg00043.html) SCT的 SIGIO 补丁的旧版本包含在2.3.18ac中。

*   Jordan Mendelson [发布](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9909_03/msg00093.html)一些示例代码，展示了如何使用F_SETSIG。

*   Stephen C. Tweedie [继续](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9909_03/msg00095.html)比较完成端口和F_SETSIG，并注意到:"使用信号出队机制，如果库使用相同的机制，您的应用程序将获取发往各种库组件的信号"，但库可以设置自己的信号处理程序，所以这不应该影响程序(很多)。

* 	[Doug Royer](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9909_04/msg00900.html)指出，当他在 Sun 日历服务器上工作时，他在 Solaris 2.6 上获得了 100，000 个连接.其他人则估计Linux需要多少RAM，以及会遇到什么瓶颈。

有趣的阅读！

## 打开文件句柄的限制

*   任何Unix: 都由 ulimit 或 setrlimit 设置限制
*   Solaris: 看 [Solaris FAQ，问题3.46](http://www.wins.uva.nl/pub/solaris/solaris2/Q3.46.html) (或左右; 他们定期重新编号)
*   FreeBSD:  
      
    编辑 /boot/loader.conf， 增加行
    
    `set kern.maxfiles=XXXX`
    
    其中 XXXX 是文件描述符所需的系统限制，并重新启动.感谢一位匿名读者，他写道，他说他在 FreeBSD 4.3上获得了超过 10000 个连接，并说
    
    > "FWIW: 你实际上无法通过sysctl轻松调整FreeBSD中的最大连接数....你必须在/boot/loader.conf文件中这样做。
    > 这样做的原因是 zalloci() 调用初始化套接字和 tcpcb 结构区域在系统启动时很早就发生了，这样区域既可以是类型稳定的又可以交换。
    > 您还需要将 mbuf 的数量设置得更高，因为您在(在未修改的内核上)为 tcptempl 结构每个连接消耗一个 mbuf，用于实现 keepalive"
    
    其他的读者说到:
    
    > "从FreeBSD 4.4开始，不再分配tcptempl结构; 你不再需要担心每个连接都会被消耗一个mbuf
    
    也可以看看:
    *   [the FreeBSD 手册](http://www.freebsd.org/doc/en_US.ISO8859-1/books/handbook/configtuning-kernel-limits.html)
    *   调整手册中的 [SYSCTL TUNING](http://www.freebsd.org/cgi/man.cgi?query=tuning#SYSCTL+TUNING), [LOADER TUNABLES](http://www.freebsd.org/cgi/man.cgi?query=tuning#LOADER+TUNABLES), 和 [KERNEL CONFIG TUNING](http://www.freebsd.org/cgi/man.cgi?query=tuning#KERNEL+CONFIG+TUNING)
    *   [调整 FreeBSD 4.3 Box对高性能的影响](http://www.daemonnews.org/200108/benchmark.html)， 守护进程新闻，2001年8月
    *   [postfix.org 调整笔记](http://www.postfix.org/faq.html#moby-freebsd)， 涵盖FreeBSD 4.2 和 4.4
    *   [the Measurement Factory 的笔记](http://www.measurement-factory.com/docs/FreeBSD/)，大约是FreeBSD 4.3
*   OpenBSD: 读者说
    
    > "在OpenBSD，需要额外的调整来增加每个进程可用的打开文件句柄的数量: [/etc/login.conf](http://www.freebsd.org/cgi/man.cgi?query=login.conf&manpath=OpenBSD+3.1) 的openfiles-cur参数需要被增加. 您可以使用sysctl -w 或 sysctl.conf 更改 kern.max 文件，但它不起作用.这很重要，因为对于非特权进程，login.conf限制为非常低的64，对于特权进程为128
    
*   Linux: 参阅[Bodo Bauer的 /proc 文档](http://asc.di.fct.unl.pt/~jml/mirror/Proc/)。在2.4内核:
    
    `echo 32768 > /proc/sys/fs/file-max`
      
    增大系统打开文件的限制，和
    
    
    `ulimit -n 32768`
    
    增大当前进程的限制
    
    在 2.2.x 内核，
    
    ```
    echo 32768 > /proc/sys/fs/file-max
    echo 65536 > /proc/sys/fs/inode-max
    ```
    
    增大系统打开文件的限制，和
    
    ```
    ulimit -n 32768
    ```
    
    增大当前进程的限制
    
    我验证了 Red Hat 6.0 上的进程(2.2.5 左右加补丁)可以通过这种方式打开至少31000 个文件描述符。另一位研究员已经证实，2.2.12 上的进程可以通过这种方式打开至少90000 个文件描述符(具有适当的限制)。上限似乎是可用的内存。

    Stephen C. Tweedie [发表](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9909_02/msg01092.html) 关于如何使用 initscript 和 pam_limit 在引导时全局或按用户设置 ulimit 限制。

    在 2.2 更老的内核， 但是，即使进行了上述更改，每个进程的打开文件数仍限制为1024
    
    另见[Oskar1998年的帖子](http://www.dejanews.com/getdoc.xp?AN=313316592)，其中讨论了 2.0.36 内核中文件描述符的每进程和系统范围限制。

## 线程限制

在任何体系结构上，您可能需要减少为每个线程分配的堆栈空间量，以避免耗尽虚拟内存。如果使用pthreads，可以使用pthread_attr_init() 在运行时设置它。

*   Solaris: 我听说，它支持尽可能多的线程以适应内存
* 	带有 NPTL 的内核: /proc/sys/vm/max_map_count 也许需要被增加到大于 32000 的线程.（但是，除非你使用64位处理器，否则你需要使用非常小的堆栈线程来获得接近该数量的线程.）参见NPTL邮件列表，例如主题为"[无法创建超过32K线程?]((https://listman.redhat.com/archives/phil-list/2003-August/msg00005.html))，了解更多信息。
*   Linux 2.4: /proc/sys/kernel/threads-max 是最大数量的线程；我的Red Hat 8系统默认为2047.你可以像往常一样通过echo新值到该文件来设置增加值，如，"echo 4000 > /proc/sys/kernel/threads-max"
*   Linux 2.2: 甚至 2.2.13 内核限制了线程数量， 至少在 Intel. 我不知道在其他架构上是什么限制。[Mingo在英特尔上发布了针对 2.1.131 的补丁](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9812_02/msg00048.html)移除了这个限制.它已纳入 2.3.20。

    另请[参阅Volano关于在2.2内核中提升文件，线程和FD_SET限制的详细说明](http://www.volano.com/linux.html)。哇，这个文档将引导您完成许多难以理解的内容，但有点过时了。
    
*   Java: [请参阅Volano的详细基准信息](http://www.volano.com/benchmarks.html). 加上他们[关于如何调整各种系统的信息](http://www.volano.com/server.html) 去处理大量线程。

## Java 问题

通过JDK 1.3， Java的标准网络库大多提供了[一个客户端一个线程模型](#threaded.java)。这是一种非阻塞读的方式，但是没有办法去做非阻塞写。

在2001年5月. [JDK 1.4](http://java.sun.com/j2se/1.4/) 引进了包 [java.nio](http://java.sun.com/j2se/1.4/docs/guide/nio/) 去提供完全支持非阻塞 I/O (和其他好的东西)。看[发行说明](http://java.sun.com/j2se/1.4/relnotes.html#nio) 警告，尝试一下，给Sun反馈!

HP 的 java 也包含了一个[线程轮训API](http://www.devresource.hp.com/JavaATC/JavaPerfTune/pollapi.html)。

在2000， Matt Welsh为java实现了非阻塞套接字.他的性能基准测试显示他们优于在处理大量(大于10000)连接的服务器中的阻塞套接字.他的类库被称作[java-nbio](http://www.cs.berkeley.edu/~mdw/proj/java-nbio/);他是[Sandstorm](http://www.cs.berkeley.edu/~mdw/proj/sandstorm/)项目的一部分.基准测试显示[10000连接的性能](http://www.cs.berkeley.edu/~mdw/proj/sandstorm/iocore-bench/)是可用的。

参阅 Dean Gaude关于 Java，网络 I/O， 和线程主题的[文章](http://arctic.org/~dean/hybrid-jvm.txt)，和 Matt Welsh 写的关于事件对比工作线程的[论文](http://www.cs.berkeley.edu/~mdw/papers/events.pdf)

在 NIO 之前，有几个改进Java的网络API的建议:

*   Matt Welsh 的[Jaguar 系统](http://www.cs.berkeley.edu/~mdw/proj/jaguar/)提出预序列化对象，新的 Java 字节码和内存管理更改允许使用 Java 进行异步I/O。
*   C-C. Chang and T. von Eicken 写的[将Java连接到虚拟接口体系结构](http://www.cs.cornell.edu/Info/People/chichao/papers.htm)提出内存管理更改允许 Java 使用异步 I/O。
*   [JSR-51](http://java.sun.com/aboutJava/communityprocess/jsr/jsr_051_ioapis.html)是提出 java.nio 包的Sun工程项目. Matt Welsh参加了(谁说Sun不听?)。

## 其他建议

*   零拷贝  
    通常情况下，数据会从一处到其他处多次复制.任何将这些副本消除到裸体物理最小值的方案称为"零拷贝"。
    *   Thomas Ogrisegg 在 Linux 2.4.17-2.4.20 下为 mmaped 文件[发送零拷贝发送补丁](http://marc.theaimsgroup.com/?l=linux-kernel&m=104121076420067&w=2)，声称它比 sendfile() 更快。
    *   [IO-Lite](http://www.usenix.org/publications/library/proceedings/osdi99/full_papers/pai/pai_html/pai.html) 是一组 I/O 原语的提议，它摆脱了对许多副本的需求。
    *  在1999年， Alan Cox指出零拷贝有时是不值的会遇到麻烦。(但他确实喜欢sendfile())
    *   Ingo于2000年7月在 2.4 内核中为 TUX 1.0[实现了一种零拷贝TCP](http://boudicca.tux.org/hypermail/linux-kernel/2000week36/0979.html)，他说他很快就会将其提供给用户空间。
    *   [Drew Gallatin and Robert 已经为FreeBSD增加了一些零拷贝特性](http://people.freebsd.org/~ken/zero_copy/);想法似乎是如果你在一个套接字上调用 write() 或者 read()，指针是页对齐的，并且传输的数据量至少是一个页面， **同时**你不会马上重用缓冲区，内存管理技巧将会用于避免拷贝. 但是请参阅[linux-kernel上关于此消息的后续内容](http://boudicca.tux.org/hypermail/linux-kernel/2000week39/0249.html)，以了解人们对这些内存管理技巧速度的疑虑。
        
       根据Noriyuki Soda的说明:
        
        > 自 NetBSD-1.6 发布以来，通过指定 "SOSEND_LOAN" 内核选项，支持发送端零拷贝.此选项现在是 NetBSD-current 的默认选项(你可以通过在 NetBSD_current 上的内核选项中指定 "SOSEND_NO_LOAN" 来禁用此功能)。使用此功能时，如果将超过4096字节的数据指定为要发送的数据，则会自动启用零复制。

        
    *   sendfile() 系统调用可以实现零拷贝网络. 
        Linux和FreeBSD中的sendfile()函数允许您告诉内核发送部分或全部文件. 使操作系统尽可能高效地完成。 它可以在使用非阻塞 I/O 的线程或服务器的服务器中同样使用.(在 Linux中，目前他的记录还很少;[使用_syscall4 去调用它](http://www.dejanews.com/getdoc.xp?AN=422899634).Andi Kleen 正在写覆盖该内容的 man 页面.另请参阅Jeff Tranter在Linux Gazette issue 91中[探索 sendfile 系统调用](http://www.linuxgazette.com/issue91/tranter.html)) 有[传言](http://www.dejanews.com/getdoc.xp?AN=423005088)称 ftp.cdrom.com 受益于 sendfile()。

        sendfile() 的零拷贝实现正在为2.4内核提供.看[LWN Jan 25 2001](http://lwn.net/2001/0125/kernel.php3).
        
        一个开发者在 Freebsd 下使用 sendfile() 的报告显示使用 POLLWRBAND 而不是 POLLOUT 会产生很大的不同。
        
        Solaris 8 (截至2001年7月更新) 有一个新的系统调用'sendfilev'。[手册页的副本在这里](sendfilev.txt)。Solaris 8 7/01 [发版说明](http://www.sun.com/software/solaris/fcc/ucc-details701.html) 也提到了它。我怀疑这在以阻塞模式发送到套接字时最有用；使用非阻塞套接字会有点痛苦。
        
*   使用 writev 避免使用小帧(或者 TCP_CORK)
    一个新的在 Linux 下的套接字选项， TCP_CORK，告诉内核去避免发送部分帧，这有点帮助，例如当有很多小的 write() 调用时，由于某种原因你不能捆绑在一起.取消设置选项会刷新缓冲区.最好使用writev()，但......

    看[LWN Jan 25 2001](http://lwn.net/2001/0125/kernel.php3)，关于TCP-CORK和可能的替代MSG_MORE的关于linux-kernel的一些非常有趣的讨论的摘要。
    
*   在过载时表现得智能
    [[Provos， Lever， and Tweedie 2000](http://www.citi.umich.edu/techreports/reports/citi-tr-00-7.ps.gz)]提到在服务器过载时丢弃传入连接可以改善性能曲线的形状，并降低整体错误率。他们使用平滑版本的" I/O 就绪客户端数"作为过载的衡量标准。此技术应该很容易应用于使用 select， poll 或任何系统调用编写的服务器，这些调用返回每次调用的就绪事件技术（例如 /dev/poll 或 sigtimedwait4())。

*   某些程序可以从使用非Posix线程中受益。
    并非所有线程都是相同的，例如，Linux 中的 clone() 函数（及其在其他操作系统中的朋友）允许您创建具有其自己的当前工作目录的线程，这在实现ftp服务器时非常有用。有关使用本机线程而不是 pthreads 的示例，请参阅 Hoser FTPd。

*   缓存自己的数据有时可能是一个胜利
    Vivek Sadananda Pai(vivek@cs.rice.edu)在 [new-httpd](http://www.humanfactor.com/cgi-bin/cgi-delegate/apache-ML/nh/1999/)"回复: 修复混合服务器问题"，5月9日，声明:
    
    > "我在 FreeBSD 和 Solaris/x86 上比较了基于 select 的服务器和多进程服务器的原始性能.在微基准测试中，软件架构的性能差异很小.基于 select 的服务器的巨大性能优势源于进行应用程序级缓存。虽然多进程服务器可以以更高的成本实现，但实际工作负载(与微基准测试相比)更难获得相同的好处.我将把这些测量结果作为论文的一部分展示，这些论文将出现在下一届 Usenix 会议上。如果你有后记，那么论文可以在[http://www.cs.rice.edu/~vivek/flash99/](http://www.cs.rice.edu/~vivek/flash99/)"

### 其他限制

*   旧系统库可能使用 16位 变量来保存文件句柄，这会导致32767句柄之上的麻烦，glibc2.1 应该没问题。
*   许多系统使用 16位 变量来保存进程或线程ID.将[Volano可伸缩性基准测试](http://www.volano.com/benchmarks.html) 移植到 C 会很有意思，看看各种操作系统的线程数上限是多少。
*   某些操作系统预先分配了过多的线程本地内存;如果每个线程获得 1MB，并且总VM空间为 2GB，则会创建 2000 个线程的上限。
*   查看[http://www.acme.com/software/thttpd/benchmarks.html](http://www.acme.com/software/thttpd/benchmarks.html) 底部的性能对比图.请注意各种服务器如何在 128个 以上的连接上出现问题，甚至在 Solaris 2.6 上 知道原因的人，让我知道。

注意: 如果TCP堆栈有一个 bug，导致 SYN 或 FIN 时间更短(200ms)延迟，如 Linux 2.2.0-2.2.6 所示，并且操作系统或 http 守护程序对连接数有硬限制，你会期待这种行为，可能还有其他原因。

### 内核问题

对于Linux，看起来内核瓶颈正在不断修复.看[Linux Weekly News](http://lwn.net)，[Kernel Traffic](http://www.kt.opensrc.org/)， [the Linux-Kernel mailing list](http://marc.theaimsgroup.com/?l=linux-kernel)，和[my Mindcraft Redux page](mindcraft_redux.html)。

1999年3月，微软赞助了一项比较 NT 和 Linux 的基准测试，用于服务大量的 http 和 smb客户端，但是他们没有看到Linux的良好结果。另见[关于Mindcraft 1999年4月基准测试的文章](mindcraft_redux.html)了解更多信息

另请参见[Linux可扩展性项目](http://www.citi.umich.edu/projects/citi-netscape/).他们正在做有趣的工作.包括[Niels Provos的暗示民意调查补丁](http://linuxwww.db.erau.edu/mail_archives/linux-kernel/May_99/4105.html)，关于[雷鸣般的群体问题](http://www.citi.umich.edu/projects/linux-scalability/reports/accept.html)的一些工作。

另请参与[Mike Jagdis致力于改进 select() 和 poll()](http://www.purplet.demon.co.uk/linux/select/)；这是 Mike 关于它的[帖子](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9909_01/msg00964.html).

[Mohit Aron（aron@cs.rice.edu）写道，TCP中基于速率的时钟可以将"缓慢"连接上的HTTP响应时间提高80％](http://www.linuxhq.com/lnxlists/linux-kernel/lk_9910_02/msg00889.html)


### 测量服务器性能

特别是两个测试简单，有趣，而且很难：

1.  每秒原始连接数(每秒可以提供多少512字节文件?)

2.  具有许多慢速客户端的大型文件的总传输速率(在性能进入底池之前，有多少 28.8k 调制解调器客户端可以同时从服务器下载?)

Jef Poskanzer发布了比较许多Web服务器的基准测试。看他的结果[http://www.acme.com/software/thttpd/benchmarks.html](http://www.acme.com/software/thttpd/benchmarks.html)

我也有[关于将thttpd与Apache比较的一些旧笔记](http://www.alumni.caltech.edu/~dank/fixing-overloaded-web-server.html)可能对初学者感兴趣。

[Chuck Lever不断提醒](http://linuxhq.com/lnxlists/linux-kernel/lk_9906_02/msg00248.html)我们关于[Banga和Druschel关于Web服务器基准测试的论文](http://www.cs.rice.edu/CS/Systems/Web-measurement/paper/paper.html)，值得一读。

IBM有一篇名为[Java服务器基准测试](http://www.research.ibm.com/journal/sj/391/baylor.html)的优秀论文.[Baylor 等，2000年].值得一读。


## 例子

[Nginx](http://nginx.org) 是一个web服务器，它使用目标操作系统上可用的任何高效网络事件机制.它变得非常流行;这甚至有关于它的[两本](http://www.amazon.com/Nginx-HTTP-Server-Cl%C3%A9ment-Nedelcu/dp/1849510865/ref=sr_1_2?s=books&ie=UTF8&qid=1311267645&sr=1-2)[书](http://www.amazon.com/Nginx-HTTP-Server-Cl%C3%A9ment-Nedelcu/dp/1849510865/ref=sr_1_2?s=books&ie=UTF8&qid=1311267645&sr=1-2)

### 有趣的基于 select() 的服务器

*   [thttpd](http://www.acme.com/software/thttpd/) 非常简单. 使用单进程.他有非常好的性能，但是它不会随着 CPU 的数量而扩展。也可以使用kqueue。
*   [mathopd](http://mathop.diva.nl/)和thttpd相似。
*   [fhttpd](http://www.fhttpd.org/)
*   [boa](http://www.boa.org/)
*   [Roxen](http://www.roxen.com/)
*   [Zeus](http://www.zeustech.net/)，试图成为绝对最快的商业服务器.看他们的 [调整指导](http://support.zeustech.net/faq/entries/tuning.html)。
*   其他非 Java 服务列在[http://www.acme.com/software/thttpd/benchmarks.html](http://www.acme.com/software/thttpd/benchmarks.html)
*   [BetaFTPd](http://ca.us.mirrors.freshmeat.net/appindex/1999/02/17/919251275.html)
*   [Flash-Lite](http://www.cs.rice.edu/~vivek/iol98/) - 使用 IO-Lite 的 Web 服务器。
*   [Flash: 高效便携的Web服务器](http://www.cs.rice.edu/~vivek/flash99/) - 使用 select()， mmap()， mincore()。
*  	 [截至2003年的Flash Web服务器](http://www.cs.princeton.edu/~yruan/debox/) - 使用 select()， 修改的 sendfile()， 异步 open()
*   [xitami](http://www.imatix.com/html/xitami/) - 使用 select() 去实现它自己的线程抽象，以便无需线程的系统的可移植性。
*   [Medusa](http://www.nightmare.com/medusa/medusa.html) - Python 中的服务器编写工具包，旨在提供非常高的性能。
*   [userver](http://www.hpl.hp.com/research/linux/userver/) - 一个小的 http 服务器，可以使用 select，poll，epoll或sigio


### 有趣的基于 /dev/poll 服务器

* _N.Provos，C.Lever_，["Scalable Network I/O in Linux"](http://www.citi.umich.edu/techreports/reports/citi-tr-00-4.pdf)2000年5月.[ FREENIX track，Proc.USENIX 2000，San Diego，California（2000年6月).]描述了被修改为支持 /dev/poll 的 thttpd 版。将性能与phhttpd进行比较。

### 有趣的基于 epoll 服务器


*   [ribs2](https://github.com/Adaptv/ribs2)
*   [cmogstored](http://bogomips.org/cmogstored/README) - 对大多数网络使用 epoll/kqueue，对磁盘和 accept4 使用线程

### Interesting kqueue()-based servers

### 有趣的基于 kqueue() 服务器

*   [thttpd](http://www.acme.com/software/thttpd/) (从版本2.21开始?)
*  Adrian Chadd 说 "我正在做很多工作来使squid实际上像一个kqueue IO系统"；他的官方Squid子项目；看[http://squid.sourceforge.net/projects.html#commloops](http://squid.sourceforge.net/projects.html#commloops)。这显然比[Benno](http://www.advogato.org/person/benno/)的[补丁](http://netizen.com.au/~benno/squid-select.tar.gz)更新


### 有趣的基于实时信号服务器.

*   Chromium 的 X15. 这使用 2.4 内核 SIGIO 功能以及 sendfile() 和 TCP_CORK，据报道甚至比TUX实现更高的速度。在社区源许可下的[源码是可用的](http://www.chromium.com/cgi-bin/crosforum/YaBB.pl)。看 Fabio Riccardi [原始公告](http://boudicca.tux.org/hypermail/linux-kernel/2001week21/1624.html)

*   Zach Brown 的 [phhttpd](http://www.zabbo.net/phhttpd/) - "一个更快的服务服务器， 它用于展示 sigio/siginfo 事件模型。如果您尝试在生产环境中使用它，请将此代码视为高度实验性的，同时您自己也格外注意" 使用 2.3.21 或之后的 [siginfo](#nb.sigio) 特性， 包含了需要的更内核补丁。据传甚至比khttpd更快。见他1999年5月31日的一些[说明](http://www.cs.helsinki.fi/linux/linux-kernel/Year-1999/1999-22/0453.html)


### 有趣的基于线程的服务器

* 	[Hoser FTPD](http://www.zabbo.net/hftpd/)。看他的[基准页面](http://www.zabbo.net/hftpd/bench.html)
* 	[Peter Eriksson的phttpd](http://ca.us.mirrors.freshmeat.net/appindex/1999/02/06/918317238.html) 和
*   [pftpd](http://ca.us.mirrors.freshmeat.net/appindex/1999/02/06/918313631.html)
* 	基于 Java 的服务列在[http://www.acme.com/software/thttpd/benchmarks.html](http://www.acme.com/software/thttpd/benchmarks.html)
* Sun的[Java Web 服务器](http://jserv.javasoft.com/) (它已经[被报道过可以同时处理500客户端](http://archives.java.sun.com/cgi-bin/wa?A2=ind9901&L=jserv-interest&F=&S=&P=47739))


### 有趣的基于内核的服务器

*   [khttpd](http://www.fenrus.demon.nl)

*   Ingo Molnar等人的["TUX" Threaded linUX webserver](http://slashdot.org/comments.pl?sid=00/07/05/0211257&cid=218)，2.4内核。

### 其他有趣的链接

* 	[Jeff Darcy在设计高性能服务器的设计笔记](http://pl.atyp.us/content/tech/servers.html)
* 	[Ericsson的 ARIES 工程](http://www2.linuxjournal.com/lj-issues/issue91/4752.html) - 在 1 到 12 个处理器上，Apache 1与Apache 2 对比 Tomcat 的基准测试结果
*   [Prof. Peter Ladkin 的Web服务器性能](http://nakula.rvs.uni-bielefeld.de/made/artikel/Web-Bench/web-bench.html)页面
*   [Novell 的快速缓存](http://www.novell.com/bordermanager/ispcon4.html) - 声称每秒点击 10000 次.相当漂亮的性能图。
*   Rik van Riel 的[Linux性能调优网站](http://linuxperf.nl.linux.org/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
