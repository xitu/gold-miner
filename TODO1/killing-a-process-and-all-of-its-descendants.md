> * 原文地址：[Killing a process and all of its descendants](http://morningcoffee.io/killing-a-process-and-all-of-its-descendants.html)
> * 原文作者：[igor_sarcevic](https://twitter.com/igor_sarcevic)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/killing-a-process-and-all-of-its-descendants.md](https://github.com/xitu/gold-miner/blob/master/TODO1/killing-a-process-and-all-of-its-descendants.md)
> * 译者：[江五渣](http://jalan.space)
> * 校对者：

# 如何杀死一个进程和它的所有子进程？

在类 Unix 系统中杀死进程比预期中更棘手。上周我在调试一个有关 job stopping on Semaphore 的问题。更具体地说，这是一个有关于在作业中终止正在运行的进程的问题。以下是我从中学到的要点：

* 类 Unix 操作系统有着复杂的进程间关系：父子进程、进程组、会话、会话的领导进程。但是，在 Linix 与 MacOS 等操作系统中，这其中的细节并不统一。符合 POSIX 的操作系统支持使用负 PID 向进程组发送信号。
* 使用系统调用向会话中的所有进程发送信号并非易事。
* 用 exec 启动的子进程将继承其父进程的信号配置。例如，如果父进程忽略 SIGHUP 信号，它的子进程也会忽略 SIGHUP 信号。
* “孤儿进程组内发生了什么”这一问题的答案并不简单。

## 杀死父进程并不会同时杀死子进程

每个进程都有一个父进程。我们可以使用 `pstree` 或 `ps` 工具来观察这一点。

```shell
# 启动两个虚拟进程
$ sleep 100 &
$ sleep 101 &

$ pstree -p
init(1)-+
        |-bash(29051)-+-pstree(29251)
                      |-sleep(28919)
                      `-sleep(28964)

$ ps j -A
 PPID   PID  PGID   SID TTY      TPGID STAT   UID   TIME COMMAND
    0     1     1     1 ?           -1 Ss       0   0:03 /sbin/init
29051  1470  1470 29051 pts/2     2386 SN    1000   0:00 sleep 100
29051  1538  1538 29051 pts/2     2386 SN    1000   0:00 sleep 101
29051  2386  2386 29051 pts/2     2386 R+    1000   0:00 ps j -A
    1 29051 29051 29051 pts/2     2386 Ss    1000   0:00 -bash
```

调用 `ps` 命令可以显示 PID（进程 ID） 和 PPID（父进程 ID）。

我对父子进程间的关系有着错误的假设。我认为如果我杀死了父进程，那么也会杀死它的所有子进程。然而这是错误的。相反，子进程将会成为孤儿进程，而 init 进程将重新成为它们的父进程。

让我们看看通过终止 bash 进程（sleep 命令的当前父进程）来重建进程间的父子关系后发生了哪些变化。

```shell
$ kill 29051 # 杀死 bash 进程

$ pstree -A
init(1)-+
        |-sleep(28919)
        `-sleep(28965)
```

于我而言，重新分配父进程的行为很奇怪。例如，当我使用 SSH 登录一台服务器，启动一个进程，然后退出时，我启动的进程将会被终止。我错误地认为这是 Linux 上的默认行为。当我离开一个 SSH 会话时，进程的终止与进程组、会话的领导进程和控制终端都有关。

## What are process groups and session leaders?

Let’s observe the output of `ps j` from the previous example again.

```shell
$ ps j -A
 PPID   PID  PGID   SID TTY      TPGID STAT   UID   TIME COMMAND
    0     1     1     1 ?           -1 Ss       0   0:03 /sbin/init
29051  1470  1470 29051 pts/2     2386 SN    1000   0:00 sleep 100
29051  1538  1538 29051 pts/2     2386 SN    1000   0:00 sleep 101
29051  2386  2386 29051 pts/2     2386 R+    1000   0:00 ps j -A
    1 29051 29051 29051 pts/2     2386 Ss    1000   0:00 -bash
```

Apart from the parent-child relationship expressed by PPID and PID, we have two other relationships:

* Process groups represented by PGID
* Sessions represented by SID

Process groups are observable in shells that support job control, like `bash` and `zsh`, that are creating a process group for every pipeline of commands. A process group is a collection of one or more processes (usually associated with the same job) that can receive signals from the same terminal. Each process group has a unique process group ID.

```shell
# start a process group that consists of tail and grep
$ tail -f /var/log/syslog | grep "CRON" &

$ ps j
 PPID   PID  PGID   SID TTY      TPGID STAT   UID   TIME COMMAND
29051 19701 19701 29051 pts/2    19784 SN    1000   0:00 tail -f /var/log/syslog
29051 19702 19701 29051 pts/2    19784 SN    1000   0:00 grep CRON
29051 19784 19784 29051 pts/2    19784 R+    1000   0:00 ps j
29050 29051 29051 29051 pts/2    19784 Ss    1000   0:00 -bash
```

Notice that the PGID of `tail` and `grep` is the same in the previous snippet.

A session is a collection of process groups, usually associated with one controlling terminals and a session leader process. If a session has a controlling terminal, it has a single foreground process group, and all other process groups in the session are background process groups.

![sessions](http://morningcoffee.io/images/killing-a-process-and-all-of-its-descendants/sessions.png)

Not all bash processes are sessions, but when you SSH into a remote server, you usually get a session. When bash runs as a session leader, it propagates the SIGHUP signal to its children. SIGHUP propagation to children was the core reason for my long-held belief that children are dying along with the parents.

## Sessions are not consistent across Unix implementations

In the previous examples, you can notice the occurrence of SID, the session ID of the process. It is the ID shared by all processes in a session.

However, you need to keep in mind that this is not true across all Unix implementations. The Single UNIX Specification talks only about a “session leader”; there is no “session ID” similar to a process ID or a process group ID. A session leader is a single process that has a unique process ID, so we could talk about a session ID that is the process ID of the session leader.

System V Release 4 introduced Session IDs.

In practice, this means that you get session ID in the `ps` output on Linux, but on BSD and its variants like MacOS, the session ID isn’t present or always zero.

## Killing all processes in a process group or session

We can use that PGID to send a signal to the whole group with the kill utility:

```shell
$ kill -SIGTERM -- -19701
```

We used a negative number `-19701` to send a signal to the group. If kill receives a positive number, it kills the process with that ID. If we pass a negative number, it kills the process group with that PGID.

The negative number comes from the system call definition directly.

Killing all processes in a session is quite different. As explained in the previous section, some systems don’t have a notion of a session ID. Even the ones that have session IDs, like Linux, don’t have a system call to kill all processes in a session. You need to walk the `/proc` tree, collect the SIDs, and terminate the processes.

Pgrep implements the algorithm for walking, collecting, and process killing by session ID. Use the following snipped:

```shell
pkill -s <SID>
```

Nohup propagation to process descendants

Ignored signals, like the ones ignored with `nohup`, are propagated to all descendants of a process. This propagation was the final bottleneck in my bug hunting exercise last week.

In my program — an agent for running bash commands — I verified that I have an established a bash session that has a controlling terminal. It is the session leader of the processes started in that bash session. My process tree looks like this:

```shell
agent -+
       +- bash (session leader) -+
                                 | - process1
                                 | - process2
```

I assumed that when I kill the bash session with SIGHUP, it kills the children as well. Integration tests on the agent also verified this.

However, what I missed was that the agent is started with `nohup`. When you start a subprocess with `exec`, like we start the bash process in the agent, it inherits the signals states from its parents.

This last one took me by surprise.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
