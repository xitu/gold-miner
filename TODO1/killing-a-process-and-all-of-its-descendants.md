> * 原文地址：[Killing a process and all of its descendants](http://morningcoffee.io/killing-a-process-and-all-of-its-descendants.html)
> * 原文作者：[igor_sarcevic](https://twitter.com/igor_sarcevic)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/killing-a-process-and-all-of-its-descendants.md](https://github.com/xitu/gold-miner/blob/master/TODO1/killing-a-process-and-all-of-its-descendants.md)
> * 译者：[江五渣](http://jalan.space)
> * 校对者：[TokenJan](https://github.com/TokenJan)，[portandbridge](https://github.com/portandbridge)

# 如何杀死一个进程和它的所有子进程

在类 Unix 系统中杀死进程比预期中更棘手。上周我在调试一个在 Semaphore 中终止作业的问题。更具体地说，这是一个有关于在作业中终止正在运行的进程的问题。以下是我从中学到的要点：

* 类 Unix 操作系统有着复杂的进程间关系：父子进程、进程组、会话、会话的领导进程。但是，在 Linux 与 MacOS 等操作系统中，这其中的细节并不统一。符合 POSIX 的操作系统支持使用负 PID 向进程组发送信号。
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

## 什么是进程组和会话领导进程？

让我们再次观察上述事例中 `ps j` 命令的输出。

```shell
$ ps j -A
 PPID   PID  PGID   SID TTY      TPGID STAT   UID   TIME COMMAND
    0     1     1     1 ?           -1 Ss       0   0:03 /sbin/init
29051  1470  1470 29051 pts/2     2386 SN    1000   0:00 sleep 100
29051  1538  1538 29051 pts/2     2386 SN    1000   0:00 sleep 101
29051  2386  2386 29051 pts/2     2386 R+    1000   0:00 ps j -A
    1 29051 29051 29051 pts/2     2386 Ss    1000   0:00 -bash
```

除了使用 PPID 和 PID 表示的父子进程关系外，进程间还有其他两种关系：

* 用 PGID 表示的进程组
* 用 SID 表示的会话

我们可以在支持作业控制的 Shell 环境中观察到进程组，例如 `bash` 和 `zsh`，它们为每个管道命令都创建了一个进程组。进程组是一个或多个进程（通常与一个作业关联）的集合，可以从同一个终端接收信号。每个进程组都有一个唯一的进程组 ID。

```shell
# 启动一个由 tail 和 grep 命令组成的进程组
$ tail -f /var/log/syslog | grep "CRON" &

$ ps j
 PPID   PID  PGID   SID TTY      TPGID STAT   UID   TIME COMMAND
29051 19701 19701 29051 pts/2    19784 SN    1000   0:00 tail -f /var/log/syslog
29051 19702 19701 29051 pts/2    19784 SN    1000   0:00 grep CRON
29051 19784 19784 29051 pts/2    19784 R+    1000   0:00 ps j
29050 29051 29051 29051 pts/2    19784 Ss    1000   0:00 -bash
```

请注意，在前半段中，`tail` 和 `grep` 的 PGID 是相同的。

会话是进程组的集合，通常由一个控制终端和一个会话领导进程组成。如果会话中有一个控制终端，它就具有单个前台进程组，除了该控制终端，会话中的所有其他进程组都是后台进程组。

![会话](http://morningcoffee.io/images/killing-a-process-and-all-of-its-descendants/sessions.png)

并非所有的 bash 进程都是会话，但是当你使用 SSH 登录一台远程服务器时，你通常会得到一个会话。当 bash 作为会话领导进程运行时，它将 SIGHUP 信号传播给它的子进程。SIGHUP 信号的传播方式就是我一直以来坚信子进程会与父进程一起消亡的核心原因。

## 在 Unix 中会话的实现并非一致

在上述事例中，你可以注意到 SID （进程的会话 ID）出现的位置。它是会话中所有进程共享的 ID。

但是，你需要记住，并非所有的 Unix 系统都遵循这一实现。单一 UNIX 规范只讨论“会话领导进程”，没有类似于进程 ID 或进程组 ID 的“会话 ID”。会话领导进程是一个具有唯一进程 ID 的单进程，因此我们可以讨论的会话 ID 是会话领导者的进程 ID。

System V Release 4 引入了会话 ID。

实际上，这意味着你能在 Linux 上通过 `ps` 命令获取会话 ID，但是在 BSD 及其变体（如 MacOS）上，会话 ID 并不存在，或始终为零。

## 杀死进程组或会话中的所有进程

我们可以使用该 PGID，通过 kill 命令向整个进程组发送信号：

```shell
$ kill -SIGTERM -- -19701
```

我们用一个负数 `-19701` 向进程组发送信号。如果我们传递的是一个正数，这个数将被视为进程 ID 用于终止进程。如果我们传递的是一个负数，它被视为 PGID，用于终止整个进程组。

负数来自系统调用的直接定义。

杀死会话中的所有进程与之完全不同。如我们在前一节说到的，有些系统没有会话 ID 的概念。即使是具有会话 ID 的系统，例如 Linux，也没有提供系统调用来终止会话中的所有进程。你需要遍历 `/proc` 输出的进程树，收集所有的 SID，然后一一终止进程。

Pgrep 实现了遍历、收集并通过会话 ID 杀死进程的算法。使用以下命令：

```shell
pkill -s <SID>
```

## 被 nohup 忽略的信号传播到子进程

被忽略的信号，就像是被 `nohup` 忽略的信号那样，都被传播到进程的所有子进程中。这种信号传播方式就是我上周在 bug 排查中遇到的最终瓶颈。

我的程序是用于运行 bash 命令的代理程序，而我在该程序中验证到的是，我已经建立了一个具有控制终端的 bash 会话。该控制终端是 bash 会话中其他启动进程的会话领导进程。我的进程树如下所示：

```shell
agent -+
       +- bash (session leader) -+
                                 | - process1
                                 | - process2
```

我假设，当我使用 SIGHUP 杀死 bash 会话时，它的子进程也会同时终止。对代理的集成测试也证明了这一点。

但是，我忽略了这个代理是以 `nohup` 启动的。当你使用 `exec` 启动子进程时，就像我们在代理中启动 bash 进程一样，它会从它的父进程继承信号状态。

最后一个结论使我惊讶万分。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
