> * 原文地址：[Understanding Asynchronous Programming in Python](https://dbader.org/blog/understanding-asynchronous-programming-in-python)
> * 原文作者：[Doug Farrell](https://dbader.org/blog/understanding-asynchronous-programming-in-python#author)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[steinliber](https://github.com/steinliber)
> * 校对者：[CACppuccino](https://github.com/CACppuccino)、[MrShayne](https://github.com/MrShayne)

# 理解 Python 中的异步编程

如何使用 Python 来编写异步程序以及为什么你需要做这件事。

![](https://dbader.org/blog/figures/python-async-programming.png)

我们中的大部分人一开始写的都是**同步程序**，这种类型的程序可以被认为是在同一时间只运行一个执行步骤，一步接着一步这样相继执行的。

即使是有条件分支、循环和函数调用，我们仍然可以认为代码在同一时间只执行一步，当这一步完成时，才执行下一步。

下面是使用这种模式运行的示例程序：

- **批量处理程序**通常是写成同步程序的：获取一些输入，处理它，然后创建一些输出。按照逻辑一步接一步地运行直到得到我们想要的输出。除了这些执行的步骤和顺序外，这类程序并不需要关注其它任何事情。

- **命令行程序**通常是一个小而快的程序，用来把一些东西“转换“成其他一些东西。这个程序表现出来就是一系列程序步骤连续执行直到完成任务。

一个**异步程序**表现的就不一样。它仍然是每次只执行一步。然而其不同之处在于系统可能不会等到一个执行步骤完成后再执行下一步。

这意味着即使先前的执行步骤（或者多个步骤）还在“其他地方“执行，我们仍然可以继续执行程序的下一步。这也意味着当在"其他地方"的步骤执行完成时，我们程序代码中必须去处理它。

为什么我们想要以这种方式写程序呢？简单来说就是它可以帮助我们处理特定类型的编程问题。

这里有个概念性的程序或许可以作为认识异步编程的例子：

## 让我们来看看一个简单的 Web 服务器

它的基本工作单元和我们之前描述的批量处理程序相同；获取一些输入，处理这些输入，然后创建输出。通过写一个同步程序就可以创建一个工作的 web 服务器。

它将是一个**绝对糟糕**的 web 服务器。

**为什么？** 在一个 web 服务器的情况下，一个工作单元（输入、处理、输出）不是这个服务器唯一的目的。它真正的目的是能长时间同时处理数百上千个工作单元。

**我们能让这个同步服务器变得更好吗？** 当然，我们可以通过优化我们的执行步骤来让它们运行的尽可能快。但是不幸的是，这种方法有非常现实的限制，从而导致 web 服务器无法足够快的响应请求，并且也不能处理足够数量的当前用户。

**上述方法优化的真实限制是什么？** 网络的速度，文件的读写速度，数据库的查询速度，其它连接服务的速度等。这个列表的的共有特征是它们都是 IO 函数。所有这些项的处理速度都比我们的 CPU 处理速度要慢很多个数量级。

在一个**同步程序**里如果一个执行步骤开始一次数据库查询（比如说），在这次查询返回一些数据之前，CPU 本质上会空闲很长一段时间，之后它才可以继续运行下一个执行步骤。

对于**面向批量处理的程序**这并不是关键，它的目的是处理通过 IO 操作得到的结果，而且这个过程所花时间通常比 IO 操作长得多。任何优化的工作都将侧重于处理的工作而不是 IO。

文件，网络和数据库 IO 操作都很快，但是它们的执行速度仍然比 CPU 执行速度慢。异步编程技术让我们的程序可以利用相对较慢的 IO 处理来释放 CPU 从而执行其他工作。

当我开始尝试了解异步编程时，我咨询的人们和查阅的文档谈了很多编写非阻塞代码的重要性。是的，这些从来没有帮助到我。

什么是非阻塞代码？什么是阻塞代码？这个信息就像我们有一个参考手册，但是手册里面没有具有实际意义的内容，来描述如何有意义地使用这些技术细节。

## 现实世界是异步的

相较于同步程序，编写异步程序是不一样的，让你理解起来会有一点困难。这就很有趣了，因为无论是在我们生活的世界里，还是我们与之交互的方式，这些几乎都是完全异步的。

**这里有一个大多数人都相关联的例子：** 作为一个父母尝试同时做好几件事；包括平衡支票本、洗衣服和照看孩子。

我们做这些事的时候甚至从来都没有细想，但是现在让我们试着把它们拆分出来：

- 平衡支票本是一个我们正在尝试将其完成的任务，而且我们可以把它看作一个同步任务；一步接着另一步执行直至任务完成。

- 但是，我们可以离开这个任务去洗衣服，把烘干机里已经烘干的衣物取出，再把已经洗完的衣服从洗衣机拿出来之后放到烘干机里并开始把另一些未洗的衣服放入洗衣机。不管怎样，这些任务是可以被异步完成的。

- 虽然我们在使用洗衣机和烘干机来洗衣服,这个过程是一个同步任务而且我们正在处理该任务，但是洗衣服的大部分任务是发生在我们启动洗衣机和烘干机之后发生的，这时候我们已经离开并返回平衡支票本的任务。现在任务就是异步的了，洗衣机和烘干机将会独立运行，一直到其中任意一个需要我们去处理时蜂鸣器就会响。

- 看孩子是另一个异步的任务。一旦他们起床了并且在玩耍，他们是一个人在那玩（一定程度上）直到他们需要我们的注意；一些孩子饿了，一些受伤了，一些在大声的叫喊，作为父母我们需要对此作出响应。照看孩子是一个长期运行的高优先级任务，重要性超过了任何我们可能正在做的其他任务，比如平衡支票本和洗衣服。

这个例子展示了阻塞和非阻塞代码。比如说当我们去洗衣服的时候，CPU（父母）就是忙碌的并且阻塞执行其它的工作。

但是没有关系，因为 CPU 正在忙碌而且这个任务运行时间相对来说是比较快的，当我们启动洗衣机和烘干机之后返回做其他事时，这个洗衣的任务现在就变成异步的了，因为 CPU 正在做其它的事情，如果你愿意，这时候已经改变了运行的上下文，而且当洗衣任务完成时你将通过机器的蜂鸣器得到通知。

作为人类这是我们工作的方式，我们很自然的在同一时间做多件事情，这过程经常是不加思索的。作为程序员，其中的诀窍就是把这种行为转化为做同样事的代码。

让我们尝试使用你可能熟悉的代码观念来"编程"：

## 头脑风暴 #1："批量处理型"父母

想想尝试使用完全同步的方式来完成这些任务。在这种情形下，如果我们是好的父母，我们就会一直照看着孩子，等待孩子这边有一些需要我们关注的事情发生。在这种情况下我们不会做其他任何事，比如平衡支票本或者洗衣服。

我们可以按任何我们想要的方式在确定任务的优先级，但是在同一时间只有一个任务以同步的方式发生，以一个接着另一个的方式。这种方式就像先前描述的同步服务器一样，它的确可以工作，但这将是一种可怕的运行方式。

直到孩子睡着之前，我们都不能干其它任何事，其他所有事只能在这个之后才能做了，但是这时候已经夜幕降临了。这样的一个星期之后，大多数父母会选择跳出窗外。

## 头脑风暴 #2："轮询"的父母

让我们改变上面的方式，使用轮询来完成多件事。在这个方式中，父母会周期性的离开任何当前正在做的任务，去检查是否有其它任务需要注意。

由于我们正在对一个父母编程，所以让我们来设置这个轮询的间隔时间，比如说15分钟。所以之后每隔15分钟，这个父母就会去检查洗衣机，烘干机或者孩子是否需要注意，然后再返回去处理平衡支票本。如果其中的任何一件事需要注意，父母就需要先完成这个工作再返回处理平衡支票本，之后继续进行轮询的循环。

如果这样做，任务就都可以完成，但是这样仍会有一些问题。CPU（父母）花了大量时间来检查不需要注意的事，仅仅是因为这些事还没有被完成，比如说像洗衣机和烘干机。给定轮询的时间间隔，在这段时间内任务执行完成是完全有可能的，但是在轮询时间 15 分钟到达之前，该任务有一段时间是不会得到注意的。对于照看孩子这个高优先级的任务，当一些非常严重的事情发生时，这个 15 分钟可能的窗口期是让人不能忍受的。

我们可以通过缩短我们的轮询时间来解决这个问题，但是现在 CPU 甚至会花费更多的时间在任务之间进行上下文切换，并且我们得到的收益开始逐渐降低。当我们像这样生活了几个星期之后，下场可以参考我之前关于窗口和跳跃的评论。

## 头脑风暴 #3："线程型"父母

我们经常可以从作为父母的人口中听到"只有把自己克隆了才能完成这么多的事"。由于现在我们假装可以对父母这个角色编程，我们可以通过使用线程来实现克隆。

如果我们把所有的任务看成一个"程序"，我们就可以把这些任务分解出来并且使用线程来运行这些任务，只要克隆这个父母就可以了。现在对于每个任务都有一个父母实例；包括照看孩子，看管洗衣机，看管烘干机和平衡收支本，所有这些任务都是独立运行的。这对于这个程序的问题来说听起来是一个很棒的解决方案。

但是确实是这样吗？因为我们必须明确的告诉这些父母实例（CPUs）在程序里面要做什么，当所有的实例都共享程序空间内的全部资源时，我们就会遇到一些问题。

比如说，当监控烘干机的父母看到衣服已经烘干了，就会去控制烘干机并开始把里面的衣服取出来。当负责烘干机的父母正在取出衣服时，负责洗衣机的父母看到洗衣机也洗完衣服了，就会去控制洗衣机，取出衣服后就会想要去控制烘干机来将洗完的衣服从洗衣机放到烘干机。这时候控制烘干机的父母已经从烘干机取出衣服而想要去控制洗衣机，并且之后会把衣服从洗衣机移动到烘干机。

现在这两个父母实例就已经[死锁](https://en.wikipedia.org/wiki/Deadlock)了。

他们两个都控制着自己的资源并且希望控制对方的资源。他们就会一直等待对方释放对资源的控制权。作为程序员，我们必须编写代码来处理这种情况。

这里是另一个因为父母线程可能引发的问题。比如不幸的是，一个孩子受伤了，父母就必须要带孩子去紧急治疗。因为现在这个父母的克隆是专门用于照看孩子的，所以可以马上响应。但是在这个紧急情况下，照看孩子的父母必须写一张相当大的支票来支付紧急护理的自付额。

同时，在支票本上工作的父母并不知道已经写了这个大额的支票，这时候家庭的账户就已经透支了。因为所有父母的克隆都在同一个程序内工作，家庭的钱（支票本）是这个程序世界里的一个共享资源，我们需要想出一个办法让照看孩子的父母可以通知平衡支票本的父母发生了什么。或者就要提供某种锁机制，这样在同一时间只有一个父母实例能更新这个资源。

所有这些事情都是可以在程序的线程代码中管理的，但是很难把代码写正确并且当出现问题时也很难 debug。

## 让我们来写一些 Python 代码

现在我们将采用在"头脑风暴"中概述的一些方法，我们将把它们转变为可以运行的 Python 代码。

你可以在这个 [GitHub 仓库](https://github.com/writeson/async_python_programming_presentation) 下载所有的示例代码。

这篇文章中的所有例子都已经在 Python 3.6.1 环境下测试过，而且在代码示例中的这个 [`requirements.txt` 文件](https://github.com/writeson/async_python_programming_presentation/blob/master/requirements.txt)包含了运行所有这些测试所需要的模块。

我强烈建议创建一个 [Python 虚拟环境](https://www.youtube.com/watch?v=UqkT2Ml9beg)来运行这些代码，这样就不会和系统级别的 Python 产生耦合。

## 示例 1：同步编程


第一个例子展示的是一种有些刻意设计的方式，即有一个任务先从队列中拉取"工作"之后再执行这个工作。在这种情况下，这个工作的内容只是获取一个数字，然后任务会把这个数字叠加起来。在每个计数步骤中，它还打印了字符串表明该任务正在运行，并且在循环的最后还打印出了总的计数。我们设计的部分即这个程序为多任务处理在队列中的工作提供了很自然的基础。

```
"""
example_1.py

Just a short example showing synchronous running of 'tasks'
"""

import queue

def task(name, work_queue):
    if work_queue.empty():
        print(f'Task {name} nothing to do')
    else:
        while not work_queue.empty():
            count = work_queue.get()
            total = 0
            for x in range(count):
                print(f'Task {name} running')
                total += 1
            print(f'Task {name} total: {total}')


def main():
    """
    This is the main entry point for the program
    """
    # create the queue of 'work'
    work_queue = queue.Queue()

    # put some 'work' in the queue
    for work in [15, 10, 5, 2]:
        work_queue.put(work)

    # create some tasks
    tasks = [
        (task, 'One', work_queue),
        (task, 'Two', work_queue)
    ]

    # run the tasks
    for t, n, q in tasks:
        t(n, q)

if __name__ == '__main__':
    main()
```

该程序中的"任务"就是一个函数，该函数可以接收一个字符串和一个队列作为参数。在执行时，它会去看队列里是否有任何需要处理的工作，如果有，它就会把值从队列中取出来，开启一个 for 循环来叠加这个计数值并且在最后打印出总数。它会一直这样运行直到队列里什么都没剩了才会结束离开。

当我们在执行这个任务时，我们会得到一个列表表明任务一（即代码中的 task One）做了所有的工作。它内部的循环消费了队列里的全部工作，并且执行这些工作。当退出任务一的循环后，任务二（即代码中的 task Two）有机会运行，但是它会发现队列是空的，因为这个影响，该任务会打印一段语句之后退出。代码中并没有任何地方可以让任务一和任务二协作的很好并且可以在它们之间切换。

## 示例 2： 简单的协作并发

程序（`example_2.py`）的下个版本通过使用生成器增加了两个任务可以跟好相互协作的能力。在任务函数中添加 yield 语句意味着循环会在执行到这个语句时退出，但是仍然保留当时的上下文，这样之后就可以恢复先前的循环。在程序后面 "run the tasks" 的循坏中当 `t.next()` 被调用时就可以利用这个。这条语句会在之前生成（即调用 yield 的语句处）的地方重新开始之前的任务。

这是一种协作并发的方式。这个程序会让出对它当前上下文的控制，这样其它的任务就可以运行。在这种情况下，它允许我们主要的 "run the tasks" 调度器可以运行任务函数的两个实例，每一个实例都从相同的队列中消费工作。这种做法虽然聪明一些，但是为了和第一个示例达成同样结果的同时做了更多的工作。

```
"""
example_2.py

Just a short example demonstrating a simple state machine in Python
"""

import queue

def task(name, queue):
    while not queue.empty():
        count = queue.get()
        total = 0
        for x in range(count):
            print(f'Task {name} running')
            total += 1
            yield
        print(f'Task {name} total: {total}')

def main():
    """
    This is the main entry point for the program
    """
    # create the queue of 'work'
    work_queue = queue.Queue()

    # put some 'work' in the queue
    for work in [15, 10, 5, 2]:
        work_queue.put(work)

    # create some tasks
    tasks = [
        task('One', work_queue),
        task('Two', work_queue)
    ]

    # run the tasks
    done = False
    while not done:
        for t in tasks:
            try:
                next(t)
            except StopIteration:
                tasks.remove(t)
            if len(tasks) == 0:
                done = True


if __name__ == '__main__':
    main()
```

当程序运行时，输出表明任务一和任务二都在运行，它们都从队列里消耗工作并且处理它。这就是我们想要的，两个任务都在处理工作，而且都是以处理从队列中的两个项目结束。但是再一次，需要做一点工作来实现这个结果。

这里的技巧在于使用 `yield` 语句，它将任务函数转变为生成器，来实现一个 "上下文切换"。这个程序使用这个上下文切换来运行任务的两个实例。

## 示例 3：通过阻塞调用来协作并发

程序（`example_3.py`）的下个版本和上一个版本几乎完全一样，除了在我们任务循环体内添加了一个 `time.sleep(1)` 调用。这使任务循环中的每次迭代都添加了一秒的延迟。这个添加的延迟是为了模拟在我们任务中出现缓慢 IO 操作的影响。

我还导入了一个简单的 Elapsed Time 类来处理报告中使用的开始时间／已用时间功能。


```
"""
example_3.py

Just a short example demonstraing a simple state machine in Python
However, this one has delays that affect it
"""

import time
import queue
from lib.elapsed_time import ET


def task(name, queue):
    while not queue.empty():
        count = queue.get()
        total = 0
        et = ET()
        for x in range(count):
            print(f'Task {name} running')
            time.sleep(1)
            total += 1
            yield
        print(f'Task {name} total: {total}')
        print(f'Task {name} total elapsed time: {et():.1f}')


def main():
    """
    This is the main entry point for the program
    """
    # create the queue of 'work'
    work_queue = queue.Queue()

    # put some 'work' in the queue
    for work in [15, 10, 5, 2]:
        work_queue.put(work)


    tasks = [
        task('One', work_queue),
        task('Two', work_queue)
    ]
    # run the scheduler to run the tasks
    et = ET()
    done = False
    while not done:
        for t in tasks:
            try:
                next(t)
            except StopIteration:
                tasks.remove(t)
            if len(tasks) == 0:
                done = True

    print()
    print('Total elapsed time: {}'.format(et()))


if __name__ == '__main__':
    main()
```

当该程序运行时，输出表明任务一和任务二都在运行，消费从队列里来的工作并像之前那样处理它们。随着增加的模拟 IO 操作延迟，我们发现我们协作式的并发并没有为我们做任何事，延迟会停止整个程序的运行，而 CPU 就只会等待这个 IO 延迟的结束。

这就是异步文档中 ”阻塞代码“的确切含义。注意运行整个程序所需要的时间，你会发现这就是所有 IO 延迟的累积时间。这再次意味着通过这种方式运行程序并不是胜利了。

## 示例 4：使用非阻塞调用来协作并发

程序（`example_4.py`）的下一个版本已经修改了不少代码。它在程序一开始就使用了 [gevent 异步编程模块](http://www.gevent.org/)。该 模块以及另一个叫做 `monkey` 的模块被导入了。

之后 `monkey` 模块一个叫做 `patch_all()` 的方法被调用。这个方法是用来干嘛的呢？简单来说它配置了这个应用程序，使其它所有包含阻塞（同步）代码的模块都会被打上"补丁"，这样这些同步代码就会变成异步的。

就像大多数简单的解释一样，这个解释对你并没有很大的帮助。在我们示例代码中与之相关的就是 `time.sleep(1)`（我们模拟的 IO 延迟）不会再"阻塞"整个程序。取而代之的是它让出程序的控制返回给系统。请注意，"example_3.py" 中的 "yield" 语句不再存在，它现在已经是 `time.sleep(1)` 函数调用内的一部分。

所以，如果 `time.sleep(1)` 已经被 gevent 打补丁来让出控制，那么这个控制又到哪里去了？使用 gevent 的一个作用是它会在程序中运行一个事件循环的线程。对于我们的目的来说，这个事件循环就像在 `example_3.py` 中 "run the tasks" 的循环。当 `time.sleep(1)` 的延迟结束时，它就会把控制返回给 `time.sleep(1)` 语句的下一条可执行语句。这样做的优点是 CPU 不会因为延迟被阻塞，而是可以有空闲去执行其它代码。

我们 "run the tasks" 的循环已经不再存在了，取而代之的是我们的任务队列包含了两个对 `gevent.spawn(...)` 的调用。这两个调用会启动两个 gevent 线程（叫做 greenlet），它们是相互协作进行上下文切换的轻量级微线程，而不是像普通线程一样由系统切换上下文。

注意在我们任务生成之后的 `gevent.joinall(tasks)` 调用。这条语句会让我们的程序会一直等待任务一和任务二都完成。如果没有这个的话，我们的程序将会继续执行后面打印的语句，但是实际上没有做任何事。

```
"""
example_4.py

Just a short example demonstrating a simple state machine in Python
However, this one has delays that affect it
"""

import gevent
from gevent import monkey
monkey.patch_all()

import time
import queue
from lib.elapsed_time import ET


def task(name, work_queue):
    while not work_queue.empty():
        count = work_queue.get()
        total = 0
        et = ET()
        for x in range(count):
            print(f'Task {name} running')
            time.sleep(1)
            total += 1
        print(f'Task {name} total: {total}')
        print(f'Task {name} total elapsed time: {et():.1f}')


def main():
    """
    This is the main entry point for the programWhen
    """
    # create the queue of 'work'
    work_queue = queue.Queue()

    # put some 'work' in the queue
    for work in [15, 10, 5, 2]:
        work_queue.put(work)

    # run the tasks
    et = ET()
    tasks = [
        gevent.spawn(task, 'One', work_queue),
        gevent.spawn(task, 'Two', work_queue)
    ]
    gevent.joinall(tasks)
    print()
    print(f'Total elapsed time: {et():.1f}')


if __name__ == '__main__':
    main()
```

当这个程序运行的时候，请注意任务一和任务二都在同样的时间开始，然后等待模拟的 IO 调用结束。这表明 `time.sleep(1)` 调用已经不再阻塞，其它的工作也正在被做。

在程序结束时，看下总的运行时间你就会发现它实际上是 `example_3.py` 运行时间的一半。现在我们开始看到异步程序的优势了。

在并发运行两个或者多个事件可以通过非阻塞的方式来执行 IO 操作。通过使用 gevent greenlets 和控制上下文切换，我们就可以在多个任务之间实现多路复用，这个实现并不会遇到太多麻烦。

## 示例 5：异步（阻塞）HTTP 下载

程序（`example_5.py`）的下一个版本有一点进步也有一点退步。这个程序现在处理的是有真正 IO 操作的工作，即向一个 URL 列表发起 HTTP 请求来获取页面内容，但是它仍然是以阻塞（同步）的方式运行的。

我们修改了这个程序导入了非常棒的 [`requests`  模块](https://requests.org/)  来创建真实的 HTTP 请求，而且我们把一份 URL 列表加入到队列中，而不是像之前一样只是数字。在这个任务中，我们也没有再用计数器，而是使用 requests 模块来获取从队列里得到 URL 页面的内容，并且我们打印了执行这个操作的时间。

```
"""
example_5.py

Just a short example demonstrating a simple state machine in Python
This version is doing actual work, downloading the contents of
URL's it gets from a queue
"""

import queue
import requests
from lib.elapsed_time import ET


def task(name, work_queue):
    while not work_queue.empty():
        url = work_queue.get()
        print(f'Task {name} getting URL: {url}')
        et = ET()
        requests.get(url)
        print(f'Task {name} got URL: {url}')
        print(f'Task {name} total elapsed time: {et():.1f}')
        yield


def main():
    """
    This is the main entry point for the program
    """
    # create the queue of 'work'
    work_queue = queue.Queue()

    # put some 'work' in the queue
    for url in [
        "http://google.com",
        "http://yahoo.com",
        "http://linkedin.com",
        "http://shutterfly.com",
        "http://mypublisher.com",
        "http://facebook.com"
    ]:
        work_queue.put(url)

    tasks = [
        task('One', work_queue),
        task('Two', work_queue)
    ]
    # run the scheduler to run the tasks
    et = ET()
    done = False
    while not done:
        for t in tasks:
            try:
                next(t)
            except StopIteration:
                tasks.remove(t)
            if len(tasks) == 0:
                done = True

    print()
    print(f'Total elapsed time: {et():.1f}')


if __name__ == '__main__':
    main()
```

和这个程序之前版本一样，我们使用一个 `yield` 关键字来把我们的任务函数转换成生成器，并且为了让其他任务实例可以执行，我们执行了一次上下文切换。

每个任务都会从工作队列中获取到一个 URL，获取这个 URL 指向页面的内容并且报告获取这些内容花了多长时间。

和之前一样，这个 `yield` 关键字让我们两个任务都能运行，但是因为这个程序是以同步的方式运行的，每个 `requests.get()` 调用在获取到页面之前都会阻塞 CPU。注意在最后运行整个程序的总时间，这对于下一个示例会很有意义。

## 示例 6：使用 gevent 实现异步（非阻塞）HTTP 下载

这个程序（`example_6.py`）的版本修改了先前的版本再次使用了 gevent 模块。记得 gevent 模块的 `monkey.patch_all()` 调用会修改之后的所有模块，这样这些模块的同步代码就会变成异步的，其中也包括 `requests` 模块。

现在的任务已经改成移除了对 `yield` 的调用，因为 `requests.get(url)` 调用已经不会再阻塞了，反而是执行一次上下文切换让出控制给 gevent 的事件循环。在 “run the task” 部分我们使用 gevent 来产生两个任务生成器，之后使用 `joinall()` 来等待它们完成。

```
"""
example_6.py

Just a short example demonstrating a simple state machine in Python
This version is doing actual work, downloading the contents of
URL's it gets from a queue. It's also using gevent to get the
URL's in an asynchronous manner.
"""

import gevent
from gevent import monkey
monkey.patch_all()

import queue
import requests
from lib.elapsed_time import ET


def task(name, work_queue):
    while not work_queue.empty():
        url = work_queue.get()
        print(f'Task {name} getting URL: {url}')
        et = ET()
        requests.get(url)
        print(f'Task {name} got URL: {url}')
        print(f'Task {name} total elapsed time: {et():.1f}')

def main():
    """
    This is the main entry point for the program
    """
    # create the queue of 'work'
    work_queue = queue.Queue()

    # put some 'work' in the queue
    for url in [
        "http://google.com",
        "http://yahoo.com",
        "http://linkedin.com",
        "http://shutterfly.com",
        "http://mypublisher.com",
        "http://facebook.com"
    ]:
        work_queue.put(url)

    # run the tasks
    et = ET()
    tasks = [
        gevent.spawn(task, 'One', work_queue),
        gevent.spawn(task, 'Two', work_queue)
    ]
    gevent.joinall(tasks)
    print()
    print(f'Total elapsed time: {et():.1f}')

if __name__ == '__main__':
    main()
```

在程序运行的最后，你可以看下总共的时间和获取每个 URL 分别的时间。你将会看到总时间会**少于** `requests.get()` 函数调用的累计时间。

这是因为这些函数调用是异步运行的，所以我们可以同一时间发送多个请求，从而更好地发挥出 CPU的优势。

## 示例 7：使用 Twisted 实现异步（非阻塞）HTTP 下载

程序（`example_7.py`）的版本使用了 [Twisted 模块](https://twistedmatrix.com/) ，该模块本所做的质上和 gevent 模块一样，即以非阻塞的方式下载 URL 对应的内容。

Twisted是一个非常强大的系统，采用了和 gevent 根本上不一样的方式来创建异步程序。gevent 模块是修改其模块使它们的同步代码变成异步，Twisted 提供了它自己的函数和方法来达到同样的结果。

之前在 `example_6.py` 中使用被打补丁的 `requests.get(url)` 调用来获取 URL 内容的位置，现在我们使用 Twisted 函数 `getPage(url)`。

在这个版本中，`@defer.inlineCallbacks` 函数装饰器和语句 `yield getPage(url)` 一起实现把上下文切换到 Twisted  的事件循环。

在 gevent 中这个事件循环是隐含的，但是在 Twisted 中，事件循环由位于程序底部的 `reactor.run()` 明确提供。

```
"""
example_7.py

Just a short example demonstrating a simple state machine in Python
This version is doing actual work, downloading the contents of
URL's it gets from a work_queue. This version uses the Twisted
framework to provide the concurrency
"""

from twisted.internet import defer
from twisted.web.client import getPage
from twisted.internet import reactor, task

import queue
from lib.elapsed_time import ET


@defer.inlineCallbacks
def my_task(name, work_queue):
    try:
        while not work_queue.empty():
            url = work_queue.get()
            print(f'Task {name} getting URL: {url}')
            et = ET()
            yield getPage(url)
            print(f'Task {name} got URL: {url}')
            print(f'Task {name} total elapsed time: {et():.1f}')
    except Exception as e:
        print(str(e))


def main():
    """
    This is the main entry point for the program
    """
    # create the work_queue of 'work'
    work_queue = queue.Queue()

    # put some 'work' in the work_queue
    for url in [
        b"http://google.com",
        b"http://yahoo.com",
        b"http://linkedin.com",
        b"http://shutterfly.com",
        b"http://mypublisher.com",
        b"http://facebook.com"
    ]:
        work_queue.put(url)

    # run the tasks
    et = ET()
    defer.DeferredList([
        task.deferLater(reactor, 0, my_task, 'One', work_queue),
        task.deferLater(reactor, 0, my_task, 'Two', work_queue)
    ]).addCallback(lambda _: reactor.stop())

    # run the event loop
    reactor.run()

    print()
    print(f'Total elapsed time: {et():.1f}')


if __name__ == '__main__':
    main()
```

注意最后的结果和 gevent 版本一样，整个程序运行的时间会小于获取每个 URL 内容的累计时间。

## 示例8：使用 Twisted 回调函数实现异步（非阻塞）HTTP 下载

程序 （`example_8.py`）的这个版本也是使用 Twisted 库，但是是以更传统的方式使用 Twisted。

这里我的意思是不再使用  `@defer.inlineCallbacks` / `yield` 这种代码风格，这个版本会使用明确的回调函数。一个"回调函数"是一个被传递给系统的函数，该函数可以在之后的事件响应中被调用。在下面的例子中，`success_callback()` 被提供给 Twisted，用来在 `getPage(url)` 调用完成后被调用。

注意在这个程序中 `@defer.inlineCallbacks` 装饰器并没有在 `my_task()` 函数中使用。除此之外，这个函数产出一个叫做  `d` 的变量，该变量是延后调用的缩写，是调用函数 `getPage(url)` 得到的返回值。

**延后**是 Twisted 处理异步编程的方式，回调函数就附加在其之上。当这个延后"触发"（即当 `getPage(url)` 完成时），会以回调函数被附加时定义的变量作为参数，来调用这个回调函数。

```
"""
example_8.py

Just a short example demonstrating a simple state machine in Python
This version is doing actual work, downloading the contents of
URL's it gets from a queue. This version uses the Twisted
framework to provide the concurrency
"""

from twisted.internet import defer
from twisted.web.client import getPage
from twisted.internet import reactor, task

import queue
from lib.elapsed_time import ET


def success_callback(results, name, url, et):
    print(f'Task {name} got URL: {url}')
    print(f'Task {name} total elapsed time: {et():.1f}')


def my_task(name, queue):
    if not queue.empty():
        while not queue.empty():
            url = queue.get()
            print(f'Task {name} getting URL: {url}')
            et = ET()
            d = getPage(url)
            d.addCallback(success_callback, name, url, et)
            yield d


def main():
    """
    This is the main entry point for the program
    """
    # create the queue of 'work'
    work_queue = queue.Queue()

    # put some 'work' in the queue
    for url in [
        b"http://google.com",
        b"http://yahoo.com",
        b"http://linkedin.com",
        b"http://shutterfly.com",
        b"http://mypublisher.com",
        b"http://facebook.com"
    ]:
        work_queue.put(url)

    # run the tasks
    et = ET()

    # create cooperator
    coop = task.Cooperator()

    defer.DeferredList([
        coop.coiterate(my_task('One', work_queue)),
        coop.coiterate(my_task('Two', work_queue)),
    ]).addCallback(lambda _: reactor.stop())

    # run the event loop
    reactor.run()

    print()
    print(f'Total elapsed time: {et():.1f}')


if __name__ == '__main__':
    main()
```

运行这个程序的最终结果和先前的两个示例一样，运行程序的总时间小于获取 URLs 内容的总时间。

无论你使用 gevent 还是 Twisted，这只是个人的喜好和代码风格问题。这两个都是强大的库，提供了让程序员可以编写异步代码的机制。


## 结论

我希望这可以帮你知道和理解异步编程可以在哪里以及如何可以变得有用。如果你正在编写一个将 PI 计算到小数点后百万级别精度的函数，异步代码对于该程序根本一点用都没有。

然而，如果你正在尝试实现一个服务器，或者是会执行大量 IO 操作的程序，使用异步编程就会产生巨大的变化。这是一个强大的技术可以帮助你的程序更上一层楼。

## 关于作者

Doug 是一位具有二十多年开发经验的 Python 开发者。他在他的[个人网站](http://writeson.pythonanywhere.com/)上写关于 Python 的文章，目前在 Shutterfly 担任高级 Web 工程师。 Doug 也是 [PythonistaCafe](https://www.pythonistacafe.com) 中的一位值得尊敬的成员。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
