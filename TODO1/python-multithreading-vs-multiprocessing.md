> * 原文地址：[Intro to Threads and Processes in Python](https://medium.com/@bfortuner/python-multithreading-vs-multiprocessing-73072ce5600b)
> * 原文作者：[Brendan Fortuner](https://medium.com/@bfortuner?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/python-multithreading-vs-multiprocessing.md](https://github.com/xitu/gold-miner/blob/master/TODO1/python-multithreading-vs-multiprocessing.md)
> * 译者：[lsvih](https://github.com/lsvih)
> * 校对者：[yqian1991](https://github.com/yqian1991)

# Python 的多线程与多进程

## 初学者的并行编程指南

![](https://cdn-images-1.medium.com/max/1600/1*bHJr8cxHLidDg9T4442P8g.png)

在参加 Kaggle 的 [Understanding the Amazon from Space](https://www.kaggle.com/c/planet-understanding-the-amazon-from-space) 比赛时，我试图对自己代码的各个部分进行加速。速度在 Kaggle 比赛中至关重要。高排名常常需要尝试数百种模型结构与超参组合，能在一个持续一分钟的 epoch 中省出 10 秒都是一个巨大的胜利。

让我吃惊的是，数据处理是最大的瓶颈。我用了 Numpy 的矩阵旋转、矩阵翻转、缩放及裁切等操作，在 CPU 上进行运算。Numpy 和 Pytorch 的 DataLoader 在某些情况中使用了并行处理。我同时会运行 3 到 5 个实验，每个实验都各自进行数据处理。但这种处理方式看起来效率不高，我希望知道我是否能用并行处理来加快所有实验的运行速度。

### 什么是并行处理？

简单来说就是在同一时刻做两件事情，也可以是在不同的 CPU 上分别运行代码，或者说当程序等待外部资源（文件加载、API 调用等）时把“浪费”的 CPU 周期充分利用起来提高效率。

下面的例子是一个“正常”的程序。它会使用单线程，依次进行下载一个 URL 列表的内容。

![](https://cdn-images-1.medium.com/max/1600/0*FxpoyXf9dxLQO7JW.png)

下面是一个同样的程序，不过使用了 2 个线程。它把 URL 列表分给不同的线程，处理速度几乎翻倍。

![](https://cdn-images-1.medium.com/max/2000/0*yVD6mleQs8wfhXjb.png)

如果你对如何绘制以上图表感到好奇，可以参考[源码](https://github.com/bfortuner/ml-study/blob/master/multitasking_python.ipynb)，下面也简单介绍一下：

1.  在你函数内部加上一个计时器，并返回函数执行的起始与结束时间

```
URLS = [url1, url2, url3, ...]
def download(url, base):
    start = time.time() - base
    resp = urlopen(url)
    stop = time.time() - base
    return start,stop
```

2. 单线程程序的可视化如下：多次执行你的函数，并将多个开始结束的时间存储下来

```
results = [download(url, 1) for url in URLS]
```

3. 将 [start, stop] 的结果数组进行转置，绘制柱状图

```
def visualize_runtimes(results):
    start,stop = np.array(results).T
    plt.barh(range(len(start)), stop-start, left=start)
    plt.grid(axis=’x’)
    plt.ylabel("Tasks")
    plt.xlabel("Seconds")
```

多线程的图表生成方式与此类似。Python 的并发库一样可以返回结果数组。

### **进程 vs 线程**

一个**进程**就是一个程序的实例（比如 Jupyter notebook 或 Python 解释器）。进程启动**线程**（子进程）来处理一些子任务（比如按键、加载 HTML 页面、保存文件等）。线程存活于进程内部，线程间共享相同的内存空间。

**举例：Microsoft Word**  
当你打开 Word 时，你其实就是创建了一个进程。当你开始打字时，进程启动了一些线程：一个线程专门用于获取键盘输入，一个线程用于显示文本，一个线程用于自动保存文件，还有一个线程用于拼写检查。在启动这些线程之后，Word 就能更好的利用空闲的 CPU 时间（等待键盘输入或文件加载的时间）让你有更高的工作效率。

#### **进程**

*   由操作系统创建，以运行程序
*   一个进程可以包括多个线程
*   两个进程可以在 Python 程序中同时执行代码
*   启动与终止进程需要花费更多的时间，因此用进程比用线程的开销更大
*   由于进程不共享内存空间，因此进程间交换信息比线程间交换信息要慢很多。在 Python 中，用序列化数据结构（如数组）的方法进行信息交换会花费 IO 处理级别的时间。

#### **线程**

*   线程是在进程内部的类似迷你进程的东西
*   不同的线程共享同样的内存空间，可以高效地读写相同的变量
*   两个线程不能在同一个 Python 程序中执行代码（有解决这个问题的方法`*`）

#### CPU vs 核

**CPU**，或者说处理器，管理着计算机最基本的运算工作。CPU 有一个或着多个**核**，可以让 CPU 同时执行代码。

如果只有一个核，那么对 CPU 密集型任务（比如循环、运算等）不会有速度的提升。操作系统需要在很小的时间片在不同的任务间来回切换调度。因此，做一些很琐碎的操作（比如下载一些图片）时，多任务处理反而会降低处理性能。这个现象的原因是在启动与维护多个任务时也有性能的开销。

#### **Python 的 GIL 锁问题**

CPython（python 的标准实现）有一个叫做 [GIL](https://wiki.python.org/moin/GlobalInterpreterLock)（全局解释锁）的东西，会阻止在程序中同时执行两个线程。一些人非常不喜欢它，但也有一些人喜欢它。目前有一些解决它的方法，不过 Numpy 之类的库大都是通过执行外部 C 语言代码来绕过这种限制。

#### **何时使用线程，何时使用进程？**

*   得益于多核与不存在 GIL，**多进程**可以加速 CPU 密集型的 Python 程序。
*   **多线程**可以很好的处理 IO 任务或涉及外部系统的任务，因为线程可以将不同的工作高效地结合起来。而进程需要对结果进行序列化才能汇聚多个结果，这需要消耗额外的时间。
*   由于 GIL 的存在，**多线程**对 CPU 密集的 Python 程序没有什么帮助。

`*`对于点积等某些运算，Numpy 绕过了 Python 的 GIL 锁，能够并行执行代码。

### 并行处理示例

Python 的 [concurrent.futures 库](https://docs.python.org/3/library/concurrent.futures.html)用起来轻松愉快。你只需要简单的将函数、待处理的对象列表和并发的数量传给它即可。在下面几节中，我会以几种实验来演示何时使用线程何时使用进程。

```
def multithreading(func, args, 
                   workers):
    with ThreadPoolExecutor(workers) as ex:
        res = ex.map(func, args)
    return list(res)

def multiprocessing(func, args, 
                    workers):
    with ProcessPoolExecutor(work) as ex:
        res = ex.map(func, args)
    return list(res)
```

#### **API 调用**

对于 API 调用，多线程明显比串行处理与多进程速度要快很多。

```
def download(url):
    try:
        resp = urlopen(url)
    except Exception as e:
        print ('ERROR: %s' % e)
```

![](https://cdn-images-1.medium.com/max/1600/0*8SmynNwwW8nePlQf.png)

**2 个线程**

![](https://cdn-images-1.medium.com/max/1600/0*vCyQXr1HQdAaJJDP.png)

**4 个线程**

![](https://cdn-images-1.medium.com/max/1600/0*Mj0T3T_fYBzzjXQt.png)

**2 个进程**

![](https://cdn-images-1.medium.com/max/1600/0*UzBbZNxBUaVmjM-N.png)

**4 个进程**

![](https://cdn-images-1.medium.com/max/1600/0*ZBofiDY2P4gciHCB.png)

#### **IO 密集型任务**

我传入了一个巨大的文本，以观测线程与进程的写入性能。线程效果较好，但多进程也让速度有所提升。

```
def io_heavy(text):
    f = open('output.txt', 'wt', encoding='utf-8')
    f.write(text)
    f.close()
```

**串行**

```
%timeit -n 1 [io_heavy(TEXT,1) for i in range(N)]
>> 1 loop, best of 3: 1.37 s per loop
```

**4 个线程**

![](https://cdn-images-1.medium.com/max/1600/0*rARC61dTge2NwbFt.png)

**4 个进程**

![](https://cdn-images-1.medium.com/max/1600/0*iEYUn87JGyJrNd4W.png)

#### CPU 密集型任务

由于没有 GIL，可以在多核上同时执行代码，多进程理所当然的胜出。

```
def cpu_heavy(n):
    count = 0
    for i in range(n):
        count += i
```

![](https://cdn-images-1.medium.com/max/1600/0*VODW-i_4b75hFoNY.png)

**串行：** 4.2 秒  
**4 个线程：** 6.5 秒  
**4 个进程：** 1.9 秒

#### Numpy 中的点积

不出所料，无论是用多线程还是多进程都不会对此代码有什么帮助。Numpy 在幕后执行外部的 C 语言代码，绕开了 GIL。

```
def dot_product(i, base):
    start = time.time() - base
    res = np.dot(a,b)
    stop = time.time() - base
    return start,stop

```

**串行：** 2.8 秒  
**2 个线程：** 3.4 秒  
**2 个进程：** 3.3 秒

以上实验的 Notebook 请[参考此处](https://github.com/bfortuner/ml-study/blob/master/multitasking_python.ipynb)，你可以自己来复现这些实验。

### **相关资源**

以下是我在探索这个主题时的一些参考文章。特别推荐 Nathan Grigg 的[这篇博客](https://nathangrigg.com/2015/04/python-threading-vs-processes)，给了我可视化方法的灵感。

* [**Multiprocessing vs Threading Python**: I am trying to understand the advantages of multiprocessing over threading. I know that multiprocessing gets around the…](http://stackoverflow.com/questions/3044580/multiprocessing-vs-threading-python)

* [**multithreaded blas in python/numpy**: I re-run the the benchmark on our new HPC. Both the hardware as well as the software stack changed from the setup in…](http://stackoverflow.com/questions/5260068/multithreaded-blas-in-python-numpy)

* [**Amdahl's law - Wikipedia**: In computer architecture, Amdahl's law (or Amdahl's argument) is a formula which gives the theoretical speedup in…](https://en.wikipedia.org/wiki/Amdahl%27s_law)

* [**How Linux handles threads and process scheduling**: The Linux kernel scheduler is actually scheduling tasks, and these are either threads or (single-threaded) processes…](http://stackoverflow.com/questions/8463741/how-linux-handles-threads-and-process-scheduling)

* [**Optimal number of threads per core**: Let's say I have a 4-core CPU, and I want to run some process in the minimum amount of time. The process is ideally…](http://stackoverflow.com/questions/1718465/optimal-number-of-threads-per-core/10670440#10670440)

* [**How many threads is too many?**: I am writing a server, and I branch each action of into a thread when the request is incoming. I do this because almost…](http://stackoverflow.com/questions/481970/how-many-threads-is-too-many)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
