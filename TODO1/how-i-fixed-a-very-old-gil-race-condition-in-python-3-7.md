> * 原文地址：[How I fixed a very old GIL race condition in Python 3.7](https://vstinner.github.io/python37-gil-change.html)
> * 原文作者：[Victor Stinner](https://vstinner.github.io/author/victor-stinner.html)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-i-fixed-a-very-old-gil-race-condition-in-python-3-7.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-i-fixed-a-very-old-gil-race-condition-in-python-3-7.md)
> * 译者：
> * 校对者：

# How I fixed a very old GIL race condition in Python 3.7

**It took me 4 years to fix a nasty bug in the famous Python GIL** (Global Interpreter Lock), one of the most critical part of Python. I had to dig the Git history to find a **change made 26 years ago** by **Guido van Rossum**: at this time, _threads were something esoteric_. Let me tell you my story.

## Fatal Python error caused by a C thread and the GIL

In March 2014, **Steve Dower** reported the bug [bpo-20891](https://bugs.python.org/issue20891) when a "C thread" uses the Python C API:

> In Python 3.4rc3, calling `PyGILState_Ensure()` from a thread that was not created by Python and without any calls to `PyEval_InitThreads()` will cause a fatal exit:
> 
> `Fatal Python error: take_gil: NULL tstate`

My first comment:

> IMO it's a bug in `PyEval_InitThreads()`.

[![Release the GIL!](https://vstinner.github.io/images/release_the_gil.png)](https://twitter.com/kwinkunks/status/619496450834087938)

## PyGILState_Ensure() fix

I forgot the bug during 2 years. In March 2016, I modified Steve's test program to make it compatible with Linux (the test was written for Windows). I succeeded to reproduce the bug on my computer and I wrote a fix for `PyGILState_Ensure()`.

One year later, november 2017, **Marcin Kasperski** asked:

> Is this fix released? I can't find it in the changelog…

Oops, again, I completely forgot this issue! This time, not only I **applied my PyGILState_Ensure() fix**, but I also wrote the **unit test** `test_embed.test_bpo20891()`:

> Ok, the bug is now fixed in Python 2.7, 3.6 and master (future 3.7). On 3.6 and master, the fix comes with an unit test.

My fix for the master branch, commit [b4d1e1f7](https://github.com/python/cpython/commit/b4d1e1f7c1af6ae33f0e371576c8bcafedb099db):

```
bpo-20891: Fix PyGILState_Ensure() (#4650)

When PyGILState_Ensure() is called in a non-Python thread before
PyEval_InitThreads(), only call PyEval_InitThreads() after calling
PyThreadState_New() to fix a crash.

Add an unit test in test_embed.
```

And I closed the issue [bpo-20891](https://bugs.python.org/issue20891)...

## Random crash of the test on macOS

Everything was fine... but one week later, I noticed **random** crashes on macOS buildbots on my newly added unit test. I succeeded to reproduce the bug manually, example of crash at the 3rd run:

```
macbook:master haypo$ while true; do ./Programs/_testembed bpo20891 ||break; date; done
Lun  4 déc 2017 12:46:34 CET
Lun  4 déc 2017 12:46:34 CET
Lun  4 déc 2017 12:46:34 CET
Fatal Python error: PyEval_SaveThread: NULL tstate

Current thread 0x00007fffa5dff3c0 (most recent call first):
Abort trap: 6
```

`test_embed.test_bpo20891()` on macOS showed a race condition in `PyGILState_Ensure()`: the creation of the GIL lock itself... was not protected by a lock! Adding a new lock to check if Python currently has the GIL lock doesn't make sense...

I proposed an incomplete fix for `PyThread_start_new_thread()`:

> I found a working fix: call `PyEval_InitThreads()` in `PyThread_start_new_thread()`. So the GIL is created as soon as a second thread is spawned. The GIL cannot be created anymore while two threads are running. At least, with the `python` binary. It doesn't fix the issue if a thread is not spawned by Python, but this thread calls `PyGILState_Ensure()`.

## Why not always create the GIL?

**Antoine Pitrou** asked a simple question:

> Why not _always_ call `PyEval_InitThreads()` at interpreter initialization? Are there any downsides?

Thanks to `git blame` and `git log`, I found the origin of the code creating the GIL "on demand", **a change made 26 years ago**!

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

My guess was that the intent of dynamically created GIL is to reduce the "overhead" of the GIL for applications only using a single Python thread (never spawn a new Python thread).

Luckily, **Guido van Rossum** was around and was able to elaborate the rationale:

> Yeah, the original reasoning was that **threads were something esoteric and not used by most code**, and at the time we definitely felt that **always using the GIL would cause a (tiny) slowdown** and **increase the risk of crashes** due to bugs in the GIL code. I'd be happy to learn that we no longer need to worry about this and **can just always initialize it**.

## Second fix for Py_Initialize() proposed

I proposed a **second fix** for `Py_Initialize()` to always create the GIL as soon as Python starts, and no longer "on demand", to prevent any risk of a race condition:

```
+    /* Create the GIL */
+    PyEval_InitThreads();
```

**Nick Coghlan** asked if I could you run my patch through the performance benchmarks. I ran [pyperformance](http://pyperformance.readthedocs.io/) on my [PR 4700](https://github.com/python/cpython/pull/4700/). Differences of at least 5%:

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

Oh, 5 benchmarks were slower. Performance regressions are not welcome in Python: we are working hard on [making Python faster](https://lwn.net/Articles/725114/)!

## Skip the failing test before Christmas

I didn't expect that 5 benchmarks would be slower. It required further investigation, but I didn't have time for that and I was too shy or ashame to take the responsibility of pushing a performance regression.

Before the christmas holiday, no decision was taken whereas `test_embed.test_bpo20891()` was still failing randomly on macOS buildbots. I **was not confortable to touch a critical part of Python**, its GIL, just before leaving for two weeks. So I decided to skip `test_bpo20891()` until I'm back.

No gift for you, Python 3.7.

[![Sad Christmas tree](https://vstinner.github.io/images/sad_christmas_tree.png)](https://drawception.com/panel/drawing/0teL3336/charlie-brown-sad-about-small-christmas-tree/)

## New benchmark run and second fix applied to master

At the end of january 2018, I ran again the 5 benchmarks made slower by my PR. I ran these benchmarks manually on my laptop using CPU isolation:

```
vstinner@apu$ python3 -m perf compare_to ref.json patch.json --table
Not significant (5): unpickle_pure_python; sqlite_synth; spectral_norm; pathlib; scimark_monte_carlo
```

Ok, it confirms that my second fix has **no significant impact on performances** according to the [Python "performance" benchmark suite](http://pyperformance.readthedocs.io/).

I decided to **push my fix** to the master branch, commit [2914bb32](https://github.com/python/cpython/commit/2914bb32e2adf8dff77c0ca58b33201bc94e398c):

```
bpo-20891: Py_Initialize() now creates the GIL (#4700)

The GIL is no longer created "on demand" to fix a race condition when
PyGILState_Ensure() is called in a non-Python thread.
```

Then I reenabled `test_embed.test_bpo20891()` on the master branch.

## No second fix for Python 2.7 and 3.6, sorry!

**Antoine Pitrou** considered that backport for Python 3.6 [should not be merged](https://github.com/python/cpython/pull/5421#issuecomment-361214537):

> I don't think so. People can already call `PyEval_InitThreads()`.

**Guido van Rossum** didn't want to backport this change neither. So I only removed `test_embed.test_bpo20891()` from the 3.6 branch.

I didn't apply my second fix to Python 2.7 neither for the same reason. Moreover, Python 2.7 has no unit test, since it was too difficult to backport it.

At least, Python 2.7 and 3.6 got my first `PyGILState_Ensure()` fix.

## Conclusion

Python still has some race conditions in corner cases. Such bug was found in the creation of the GIL when a C thread starts using the Python API. I pushed a first fix, but a new and different race condition was found on macOS.

I had to dig into the very old history (1992) of the Python GIL. Luckily, **Guido van Rossum** was also able to elaborate the rationale.

After a glitch in benchmarks, we agreed to modify Python 3.7 to always create the GIL, instead of creating the GIL "on demand". The change has no significant impact on performances.

It was also decided to leave Python 2.7 and 3.6 unchanged, to prevent any risk of regression: continue to create the GIL "on demand".

**It took me 4 years to fix a nasty bug in the famous Python GIL.** I am never confortable when touching such **critical part** of Python. I am now happy that the bug is behind us: it's now fully fixed in the future Python 3.7!

See [bpo-20891](https://bugs.python.org/issue20891) for the full story. Thanks to all developers who helped me to fix this bug!


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
