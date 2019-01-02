> * 原文地址：[How I fixed a very old GIL race condition in Python 3.7](https://vstinner.github.io/python37-gil-change.html)
> * 原文作者：[Victor Stinner](https://vstinner.github.io/author/victor-stinner.html)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-i-fixed-a-very-old-gil-race-condition-in-python-3-7.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-i-fixed-a-very-old-gil-race-condition-in-python-3-7.md)
> * 译者：[kezhenxu94](https://github.com/kezhenxu94)
> * 校对者：[Starrier](https://github.com/Starriers)

# 我是如何修复 Python 3.7 中一个非常古老的 GIL 竞态条件 bug 的

**著名的 Python GIL (Global Interpreter Lock, 全局解析器锁) 库中一个严重的 bug 花了我 4 年的时间去修复**，Python GIL 是 Python 中最容易出错的部分之一。我不得不钻入 Git 的提交历史里面，找到 26 年前 **Guido van Rossum** 提交的记录：彼时，**线程还是很晦涩难懂的东西**。且听我慢慢道来。

## 由 C 线程和 GIL 引起的 Python 致命错误

在 2014 年 3 月份的时候, **Steve Dower** 报告了一个当 “C 语言线程“ 使用 Python C API 时产生的 bug [bpo-20891](https://bugs.python.org/issue20891)：

> 在 Python 3.4rc3 中，在一个不是用 Python 创建的线程中调用 `PyGILState_Ensure()` 方法，但不调用 `PyEval_InitThreads()` 方法时，会导致程序出现严重错误，并退出：
>
> `Fatal Python error: take_gil: NULL tstate`

我的第一句评论：

> 在我看来这是 `PyEval_InitThreads()` 的一个 bug 呀。

[![Release the GIL!](https://vstinner.github.io/images/release_the_gil.png)](https://twitter.com/kwinkunks/status/619496450834087938)

## PyGILState_Ensure() 修复方案

两年内我我就忘了这个 bug 。到了 2016 年 3 月份，我修改了 Steve 的测试代码，以兼容 Linux (当时的测试代码是在 Windows 上写的)。我成功地在我的电脑上重现了这个 bug ，然后写了个 `PyGILState_Ensure()` 的修复补丁。

一年后，也就是 2017 年 11 月，**Marcin Kasperski** 问道：

> 这个修复补丁发布了吗？我在更改日志里面没有看到…

糟糕，我又一次完全忘了这个问题！这次，我不仅**提交了我对 PyGILState_Ensure() 的修复补丁**，还写了**单元测试** `test_embed.test_bpo20891()`：

> 好了，这个 bug 已经在 Python 2.7, 3.6 和主分支（后来的 3.7）上修复啦。在 3.6 和 master 上，这个补丁还带了单元测试呢。

我在主分支上的修复提交, 提交 [b4d1e1f7](https://github.com/python/cpython/commit/b4d1e1f7c1af6ae33f0e371576c8bcafedb099db)：

```
bpo-20891: Fix PyGILState_Ensure() (#4650)

When PyGILState_Ensure() is called in a non-Python thread before
PyEval_InitThreads(), only call PyEval_InitThreads() after calling
PyThreadState_New() to fix a crash.

Add an unit test in test_embed.
```

然后我就关了这个 issue [bpo-20891](https://bugs.python.org/issue20891) 了…

## 单元测试在 macOS 上随机奔溃

一切都安好…… 直到一周之后，我意识到我新加的单元测试在 macOS 系统上**时不时**会奔溃。最终我成功找到重现路径，以下例子是第三次运行时奔溃：

```
macbook:master haypo$ while true; do ./Programs/_testembed bpo20891 ||break; date; done
Lun  4 déc 2017 12:46:34 CET
Lun  4 déc 2017 12:46:34 CET
Lun  4 déc 2017 12:46:34 CET
Fatal Python error: PyEval_SaveThread: NULL tstate

Current thread 0x00007fffa5dff3c0 (most recent call first):
Abort trap: 6
```

`test_embed.test_bpo20891()` 在 macOS 的 `PyGILState_Ensure()` 出现了一个竞态条件：GIL 锁自身的构建……没有锁保护！添加一个锁来检测 Python 当前有没有 GIL 锁显然毫无意义……

我提出了修复 `PyThread_start_new_thread()` 的一个不是很完整的建议：

> 我找到一个可行的修复方案：在 `PyThread_start_new_thread()` 中调用 `PyEval_InitThreads()`。这样 GIL 就能够在第二个线程一产生时就创建好了。当有两个线程在运行的时候就不能再创建 GIL 了。但至少在“是不是用 `python`”这种非黑即白的情况下，如果一个线程不是用 Python 创建的，这种修复方案会失效，但此时这个线程又会调用 `PyGILState_Ensure()`。

## 为什么不一开始就创建 GIL？

**Antoine Pitrou** 问了一个简单的问题：

> 为什么不在**解析器初始化时**就调用 `PyEval_InitThreads()`？有什么不好之处吗？

多亏了 `git blame` 和 `git log` 命令，我找到了“按需创建 GIL”代码的发源地，**26 年前的一个变更**！

```
commit 1984f1e1c6306d4e8073c28d2395638f80ea509b
Author: Guido van Rossum <guido@python.org>
Date:   Tue Aug 4 12:41:02 1992 +0000

    * Makefile adapted to changes below.
    * split pythonmain.c in two: most stuff goes to pythonrun.c, in the library.
    * new optional built-in threadmodule.c, build upon Sjoerd's thread.{c,h}.
    * new module from Sjoerd: mmmodule.c (dynamically loaded).
    * new module from Sjoerd: sv (svgen.py, svmodule.c.proto).
    * new files thread.{c,h} (from Sjoerd).
    * new xxmodule.c (example only).
    * myselect.h: bzero -> memset
    * select.c: bzero -> memset; removed global variable

(...)

+void
+init_save_thread()
+{
+#ifdef USE_THREAD
+       if (interpreter_lock)
+               fatal("2nd call to init_save_thread");
+       interpreter_lock = allocate_lock();
+       acquire_lock(interpreter_lock, 1);
+#endif
+}
+#endif
```

我猜测这种动态创建 GIL 的意图是为了避免那些只使用了一个线程（即永远不会新建线程）的应用“过早”创建 GIL 的情况。

幸运的是，**Guido van Rossum** 当时也在，能够和我一起找出根本原因：

> 是的，最初的原因就是**线程是很晦涩难懂的，也没有多少代码里面会用线程**，那时，由于 GIL 代码中的 bug ，我们肯定会觉得**频繁使用 GIL 会导致（微小的）性能下降**和**奔溃风险的上升**。现在了解到我们不再需要担心这两方面的问题了，可以**尽情地使用初始化它了**。

## Py_Initialize() 的第二个修复方案的提出

我提议了 `Py_Initialize()` 的**另一个修复方案**：总是在 Python 一启动的时候就创建 GIL ，不再“按需”创建，以避免竞态条件发生的风险：

```
+    /* Create the GIL */
+    PyEval_InitThreads();
```

**Nick Coghlan** 问我是否能够在我的补丁上运行一下性能基准测试。我在我的 [PR 4700](https://github.com/python/cpython/pull/4700/) 上运行了 [pyperformance](http://pyperformance.readthedocs.io/)，差距高达 5%：

```
haypo@speed-python$ python3 -m perf compare_to \
    2017-12-18_12-29-master-bd6ec4d79e85.json.gz \
    2017-12-18_12-29-master-bd6ec4d79e85-patch-4700.json.gz \
    --table --min-speed=5

+----------------------+--------------------------------------+-------------------------------------------------+
| Benchmark            | 2017-12-18_12-29-master-bd6ec4d79e85 | 2017-12-18_12-29-master-bd6ec4d79e85-patch-4700 |
+======================+======================================+=================================================+
| pathlib              | 41.8 ms                              | 44.3 ms: 1.06x slower (+6%)                     |
+----------------------+--------------------------------------+-------------------------------------------------+
| scimark_monte_carlo  | 197 ms                               | 210 ms: 1.07x slower (+7%)                      |
+----------------------+--------------------------------------+-------------------------------------------------+
| spectral_norm        | 243 ms                               | 269 ms: 1.11x slower (+11%)                     |
+----------------------+--------------------------------------+-------------------------------------------------+
| sqlite_synth         | 7.30 us                              | 8.13 us: 1.11x slower (+11%)                    |
+----------------------+--------------------------------------+-------------------------------------------------+
| unpickle_pure_python | 707 us                               | 796 us: 1.13x slower (+13%)                     |
+----------------------+--------------------------------------+-------------------------------------------------+

Not significant (55): 2to3; chameleon; chaos; (...)
```

哇，5 个基准降低了。性能回归测试在 Python 中很受欢迎：我们一直都致力于[让 Python 跑得更快](https://lwn.net/Articles/725114/)！

## 圣诞前夕跳过失败的测试

我没有料到有 5 个基准测试性能都降低了。这需要更深层的探究，但我没有时间去做这些探究，如果要做性能回归测试，我又得对此负责，感觉太害羞/羞愧了。

在圣诞节假期之前，我还下不定决心，然而 `test_embed.test_bpo20891()` 还是一如既往地在 macOS 系统上随机奔溃。让我在假期前的两周时间内去接触 Python 中最最容易出错的部分 —— GIL 着实让我感到很难受。所以我决定跳过 `test_bpo20891()` 的单元测试直到过完假期再说。

Python 3.7 ，没有彩蛋。

[![Sad Christmas tree](https://vstinner.github.io/images/sad_christmas_tree.png)](https://drawception.com/panel/drawing/0teL3336/charlie-brown-sad-about-small-christmas-tree/)

## 运行新的基准测试，第二个修复补丁合并到主分支

在 2018 年的 1 月末，我再一次运行了我 PR 中性能降下来的那 5 个基准测试。我在我的笔记本上手动运行这些基准测试，让不同的测试使用独立的 CPU ：

```
vstinner@apu$ python3 -m perf compare_to ref.json patch.json --table
Not significant (5): unpickle_pure_python; sqlite_synth; spectral_norm; pathlib; scimark_monte_carlo
```

好了，根据 [Python “性能”基准测试套件](http://pyperformance.readthedocs.io/)，现在证明了我的第二个修复方案其实并**没有对性能产生多大的影响**。

我决定把我的修复方案推送到主分支，提交 [2914bb32](https://github.com/python/cpython/commit/2914bb32e2adf8dff77c0ca58b33201bc94e398c)：

```
bpo-20891: Py_Initialize() now creates the GIL (#4700)

The GIL is no longer created "on demand" to fix a race condition when
PyGILState_Ensure() is called in a non-Python thread.
```

然后我在主分支上重新启动了 `test_embed.test_bpo20891()` 单元测试。

## 对不起，Python 2.7 和 3.6 没有第二个修复补丁！

**Antoine Pitrou** 想过要把补丁移植到 Python 3.6 [不能合并](https://github.com/python/cpython/pull/5421#issuecomment-361214537)：

> 我觉得没必要。大家已经可以调用 `PyEval_InitThreads()` 了。

**Guido van Rossum** 也不想移植这个补丁。所以我就从 3.6 的主分支中移除了 `test_embed.test_bpo20891()`。

由于同样的原因，我也没有在 Python 2.7 中应用我的第二个补丁，此外，Python 2.7 没有单元测试，因为移植太难了。

但至少，Python 2.7 和 3.6 应用了我的第一个补丁，`PyGILState_Ensure()`。

## 总结

Python 在一些边界情况下仍然有一些竞态条件。这种 bug 是在 C 线程使用 Python API 创建 GIL 时发现的。我推送了第一个补丁，但另一个新的竞态条件在 macOS 上出现了。

我不得不钻进 Python GIL 非常古老的提交历史（1992 年）中。幸运的是 **Guido van Rossum** 能够帮忙一起找到 bug 的根本原因。

在一次基准测试小故障后，我们意见达成一致，在 Python 3.7 中总是一启动解析器就创建 GIL，而不是“按需”创建。这种变更没有对性能产生明显的影响。

同时我们也决定保持 Python 2.7 和 3.6 不变，以防止任何回归测试的风险：继续“按需”创建 GIL。

**著名的 Python GIL (Global Interpreter Lock, 全局解析器锁) 库中一个严重的 bug 花了我 4 年的时间去修复**，Python GIL 是 Python 中最容易出错的部分之一。很开心现在这个 bug 已经被我们甩开了：在即将发布的 Python 3.7 中已经被完全修复了！

在 [bpo-20891](https://bugs.python.org/issue20891) 查看完整的故事。感谢帮助我修复这个 bug 的所有开发者！


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
