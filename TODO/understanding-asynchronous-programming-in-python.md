> * 原文地址：[Understanding Asynchronous Programming in Python](https://dbader.org/blog/understanding-asynchronous-programming-in-python)
> * 原文作者：[Doug Farrell](https://dbader.org/blog/understanding-asynchronous-programming-in-python#author)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# Understanding Asynchronous Programming in Python

How to use Python to write asynchronous programs, and why you’d want to do such a thing.

![](https://dbader.org/blog/figures/python-async-programming.png)

A **synchronous program** is what most of us started out writing, and can be thought of as performing one execution step at a time, one after another.

Even with conditional branching, loops and function calls, we can still think about the code in terms of taking one execution step at a time, and when complete, moving on to the next.

Here are couple of example programs that would work this way:

- **Batch processing programs** are often created as synchronous programs: get some input, process it, create some output. One step logically follows another till we create the desired output. There’s really nothing else the program has to pay attention to besides those steps, and in that order.

- **Command-line programs** are often small, quick processes to “transform” something into something else. This can be expressed as a series of program steps executed serially and done.

An **asynchronous program** behaves differently. It still takes one execution step at a time. However the difference is the system may not wait for an execution step to be complete before moving on.

This means we are continuing onward through execution steps of the program, even though a previous execution step (or multiple steps) is running “elsewhere”. This also implies when one of those execution steps is running “elsewhere” completes, our program code somehow has to handle it.

Why would we want to write a program in this manner? The simple answer is it helps us handle particular kinds of programming problems.

Here’s a conceptual program that might be a candidate for asynchronous programming:

## Let’s Take a Look at a Simplistic Web Server

Its basic unit of work is the same as we described above for batch processing; get some input, process it, create the output. Written as a synchronous program this would create a working web server.

It would also be an *absolutely terrible* web server.

**Why?** In the case of a web server one unit of work (input, process, output) is not its only purpose. Its real purpose is to handle hundreds, perhaps thousands, of units of work at the same time, and for long periods of time.

**Can we make our synchronous web server better?** Sure, we can optimize our execution steps to make them as fast as possible. Unfortunately there are very real limits to this approach that leads to a web server that can’t respond fast enough, and can’t handle enough current users.

**What are the real limits of optimizing the above approach?** The speed of the network, file IO speed, database query speed, the speed of other connected services, etc. The common feature of this list is they are all IO functions. All of these items are many orders of magnitude slower than our CPU’s processing speed.

In a *synchronous program* if an execution step starts a database query (for example), the CPU is essentially idle for a long time before the query returns with some data and it can continue with the next execution step.

For *batch oriented programs* this isn’t a priority, processing the results of that IO is the goal, and often takes far longer than the IO. Any optimization efforts would be focused on the processing work, not the IO.

File, network and database IO are all pretty fast, but still way slower than the CPU. Asynchronous programming techniques allow our programs to take advantage of the relatively slow IO processes, and free the CPU to do other work.

When I started trying to understand asynchronous programming, people I asked and documentation I read talked a lot about the importance of writing non-blocking code. Yeah, this never helped me either.

What’s non-blocking code? What’s blocking code? That information was like having a reference manual without any practical context about how to use that technical detail in a meaningful way.

## The Real World is Asynchronous

Writing asynchronous programs is different, and kind of hard to get your head around. And that’s interesting because the world we live in, and how we interact with it, is almost entirely asynchronous.

**Here’s an example a lot of you can relate to:** being a parent trying to do several things at once; balance the checkbook, do some laundry and keep an eye on the kids.

We do this without even thinking about it, but let’s break it down somewhat:

- Balancing the checkbook is a task we’re trying to get done, and we could think of it as a synchronous task; one step follows another till it’s done.

- However, we can break away from it to do laundry, unloading the dryer, moving clothes from the washer to the dryer and starting another load in the washer. However, these tasks can be done asynchronously.

- While we’re actually working with the washer and dryer that’s a synchronous task and we’re working, but the bulk of the task happens after we start the washer and dryer and walk away to get back to work on the checkbook task. Now the task is asynchronous, the washer and dryer will run independently till the buzzer goes off, notifying us that one or the other needs attention.

- Watching the kids is another asynchronous task. Once they are set up and playing, they do so independently (sort of) until they need attention; someone’s hungry, someone gets hurt, someone yells in alarm, and as parents we react to it. The kids are a long running task with high priority, superceding any other task we might be doing, like the checkbook or laundry.

This example illustrates both blocking and non-blocking code. While we’re moving laudry around, for example, the CPU (the parent) is busy and blocked from doing other work.

But it’s okay because the CPU is busy and the task is relatively quick. When we start the washer and dryer and go back to do something else, now the laundry task has become asynchronous because the CPU is doing something else, has changed context if you will, and will be notified when the laundry task is complete by the machine buzzers.

As people this is how we work, we’re naturally always juggling multiple things at once, often without thinking about it. As programmers the trick is how to translate this kind of behavior into code that does kind of the same thing.

Let’s try to “program” this using code ideas you might be familiar with:

## Thought Experiment #1: The “Batching” Parent

Think about trying to do these tasks in a completely synchronous manner. If we’re a good parent in this scenario we just watch the kids, waiting for something to happen needing our attention. Nothing else, like the checkbook or laundry, would get done in this scenario.

We could re-prioritize the tasks any way we want, but only one of them would happen at a time in a synchronous, one after another, manner. This would be like the synchronous web server described above, it would work, but it would be a terrible way to live.

Nothing except watching the kids would get done till they were asleep, all other tasks would happen after that, well into the night. A couple of weeks of this and most parents would jump out the window.

## Thought Experiment #2: The “Polling” Parent

Let’s change things up so mulitple things could get done by using polling. In this approach the parent periodically breaks away from any current task and checks to see if any of the other tasks need attention.

Since we’re programming a parent, let’s make our polling interval something like fifteen minutes. So here every fifteen minutes the parent goes to check if the washer, dryer or kids need any attention, and then goes back to work on the checkbook. If any of those things do need attention, the work it gets done and the parent goes back to the checkbook task and continues on with the polling loop.

This works, tasks are getting done, but has a couple of problems. The CPU (parent) is spending a lot of time checking on things that don’t need attention because they aren’t done, like the washer and dryer. Given the polling interval, it’s entirely possible for tasks to be finished, but they wouldn’t get attention for some time, upto fifteen minutes. And the high priority watching the kids task probably couldn’t tolerate a possible window of fifteen minutes with no attention when something might be going drastically wrong.

We could address this by shortening our polling interval, but now the CPU is spending even more time context switching between tasks, and we start to hit a point of diminishing returns. And again, a couple of weeks of living like this and, well, see my previous comment about window and jumping.

## Thought Experiment #3: The “Threading” Parent

As parents it’s often heard, “if I could only clone myself”. Since we’re pretending we can program parents, we can essentially do this by using threading.

If we think of all the tasks as one “program”, we can break up the tasks and run them as threads, cloning the parent so to speak. Now there is a parent instance for each task; watching the kids, monitoring the dryer, monitoring the washer and doing the checkbook, all running independently. This sounds like a pretty nice solution to the program problem.

But is it? Since we have to tell the parent instances (CPUs) explicitely what to do in a program, we can run into some problems because all instances share everything in the program space.

For example, the parent monitoring the dryer sees the clothes are dry, takes control of the dryer and starts unloading. Let’s say that while the dryer parent is unloading clothes, the washer parent sees the washer is done, takes control of the washer, and then wants to take control of the dryer to move clothes from the washer to the dryer. When the dryer parent is finished unloading clothes that parent wants to take control of the washer and move clothes from the washer to the dryer.

Now those two parents are [deadlocked](https://en.wikipedia.org/wiki/Deadlock).

Both have control of their own resource, and want control of the other resource. They will wait forever for the other to release control. As programmers we’d have to write code to work this situation out.

Here’s another issue that might arise from parent threading. Suppose that unfortunately a child gets hurt and that parent has to take the child to emergent care. That happens right away because that parent clone is dedicated to watching the kids. But at emergent care the parent has to write a fairly large check to cover the deductible.

Meanwhile, the parent working on the checkbook is unaware of this large check being written, and suddenly the family account is overdrawn. Because the parent clones work within the same program, and the family money (checkbook) is a shared resource in that world, we’d have to work out a way to for the kid watching parent to inform the checkbook parent of what’s going on. Or provide some kind of locking mechanism so the resource can be used by only one parent at a time, with updates.

All of these things are manageable in program threading code, but it’s difficult to get right, and hard to debug when it’s wrong.

## Let’s Write Some Python Code

Now we’re going to take some of the approaches outlined in these “thought experiments” and we’ll turn them into functioning Python programs.

You can download all of the example code from [this GitHub repository](https://github.com/writeson/async_python_programming_presentation).

All the examples in this article have been tested with Python 3.6.1, and the [`requirements.txt` file included with the code examples](https://github.com/writeson/async_python_programming_presentation/blob/master/requirements.txt) indicates what modules you’ll need to run all the examples.

I would strongly suggest setting up a [Python virtual environment](https://www.youtube.com/watch?v=UqkT2Ml9beg) to run the code so as not to interfere with your system Python.

## Example 1: Synchronous Programming

This first example shows a somewhat contrived way of having a task pull “work” off a queue and do that work. In this case the work is just getting a number, and the task counts up to that number. It also prints it’s running at every count step, and prints the total at the end. The contrived part is this program provides a naive basis for multiple tasks to process the work on the queue.

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

The “task” in this program is just a function that accepts a string and a queue. When executed it looks to see if there is anything in the queue to process, and if so it pulls values off the queue, starts a for loop to count up to that value, and prints the total at the end. It continues this till there is nothing left in the queue, and exits.

When we run this task we get a listing showing that task one does all the work. The loop within it consumes all the work on the queue, and performs it. When that loop exits, task two gets a chance to run, but finds the queue empty, so it prints a statement to that affect and exits. There is nothing in the code that allows task one and task two to play nice together and switch between them.

## Example 2: Simple Cooperative Concurrency

The next version of the program (`example_2.py`) adds the ability of the two tasks to play nice together through the use of generators. The addition of the yield statement in the task function means the loop exits at that point, but maintains its context so it can be restarted later. The “run the tasks” loop later in the program takes advantage of this when it calls `t.next()`. This statement restarts the task at the point where it previously yielded.

This is a form of cooperative concurrency. The program is yielding control of its current context so something else can run. In this case it allows our primative “run the tasks” scheduler to run two instances of the task function, each one consuming work from the same queue. This is sort of clever, but a lot of work to get the same results as the first program.

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

When this program is run the output shows that both task one and two are running, consuming work from the queue and processing it. This is what’s intended, both tasks are processing work, and each ends up processing two items from the queue. But again, quite a bit of work to achieve the results.

The trick here is using the `yield` statement, which turns the task function into a generator, to perform a “context switch”. The program uses this context switch in order to run two instances of the task.

## Example 3: Cooperative Concurreny With Blocking Calls

The next version of the program (`example_3.py`) is exactly the same as the last, except for the addition of a `time.sleep(1)` call in the body of our task loop. This adds a one second delay to every iteration of the task loop. The delay was added to simulate the affect of a slow IO process occurring in our task.

I’ve also included a simple Elapsed Time class to handle the start time/elapsed time features used in the reporting.

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

When this program is run the output shows that both task one and two are running, consuming work from the queue and processing it as before. With the addition of the mock IO delay, we’re seeing that our cooperative concurrency hasn’t gotten us anything, the delay stops the processing of the entire program, and the CPU just waits for the IO delay to be over.

This is exactly what’s meant by “blocking code” in asynchronous documentation. Notice the time it takes to the run the entire program, this is the cummulative time of the all the delays. This again shows running things this way is not a win.

## Example 4: Cooperative Concurrency With Non-Blocking Calls (gevent)

The next version of the program (`example_4.py`) has been modified quite a bit. It makes use of the [gevent asynchronous programming module](http://www.gevent.org/) right at the top of the program. The module is imported, along with a module called `monkey`.

Then a method of the `monkey` module is called, `patch_all()`. What in the world is that doing? The simple explanation is it sets the program up so any other module imported having blocking (synchronous) code in it is “patched” to make it asynchronous.

Like most simple explanations, this isn’t very helpful. What it means in relation to our example program is the `time.sleep(1)` (our mock IO delay) no longer “blocks” the program. Instead it yields control cooperatively back to the system. Notice the “yield” statement from `example_3.py` is no longer present, it’s now part of the `time.sleep(1)` call.

So, if the `time.sleep(1)` function has been patched by gevent to yield control, where is the control going? One of the effects of using gevent is that it starts an event loop thread in the program. For our purposes this is like the “run the tasks” loop from `example_3.py`. When the `time.sleep(1)` delay ends, it returns control to the next executable statement after the `time.sleep(1)` statement. The advantage of this behavior is the CPU is no longer blocked by the delay, but is free to execute other code.

Our “run the tasks” loop no longer exists, instead our task array contains two calls to `gevent.spawn(...)`. These two calls start two gevent threads (called greenlets), which are lightweight microthreads that context switch cooperatively, rather than as a result of the system switching contexts like regular threads.

Notice the `gevent.joinall(tasks)` right after our tasks are spawned. This statement causes our program to wait till task one and task two are both finished. Without this our program would have continued on through the print statements, but with essentially nothing to do.

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

When this program runs, notice both task one and two start at the same time, then wait at the mock IO call. This is an indication the `time.sleep(1)` call is no longer blocking, and other work is being done.

At the end of the program notice the total elapsed time, it’s essentially half the time it took for `example_3.py` to run. Now we’re starting to see the advantages of an asynchronous program.

Being able to run two, or more, things concurrently by running IO processes in a non-blocking manner. By using gevent greenlets and controlling the context switches, we’re able to multiplex between tasks without to much trouble.

## Example 5: Synchronous (Blocking) HTTP Downloads

The next version of the program (`example_5.py`) is kind of a step forward and step back. The program now is doing some actual work with real IO, making HTTP requests to a list of URLs and getting the page contents, but it’s doing so in a blocking (synchronous) manner.

We’ve modified the program to import the wonderful [`requests` module](https://requests.org/) to make the actual HTTP requests, and added a list of URLs to the queue rather than numbers. Inside the task, rather than increment a counter, we’re using the requests module to get the contents of a URL gotten from the queue, and printing how long it took to do so.

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

As in an earlier version of the program, we’re using a `yield` to turn our task function into a generator, and perform a context switch in order to let the other task instance run.

Each task gets a URL from the work queue, gets the contents of the page pointed to by the URL and reports how long it took to get that content.

As before, the `yield` allows both our tasks to run, but because this program is running synchronously, each `requests.get()` call blocks the CPU till the page is retrieved. Notice the total time to run the entire program at the end, this will be meaningful for the next example.

## Example 6: Asynchronous (Non-Blocking) HTTP Downloads With gevent

This version of the program (`example_6.py`) modifies the previous version to use the gevent module again. Remember the gevent `monkey.patch_all()` call modifies any following modules so synchronous code becomes asynchronous, this includes `requests`.

Now the tasks have been modified to remove the `yield` call because the `requests.get(url)` call is no longer blocking, but performs a context switch back to the gevent event loop. In the “run the task” section we use gevent to spawn two instance of the task generator, then use `joinall()` to wait for them to complete.

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

At the end of this program run, take a look at the total time and the individual times to get the contents of the URL’s. You’ll see the total time is *less* than the cummulative time of all the `requests.get()` calls.

This is because those calls are running asynchronously, so we’re effectively taking better advantage of the CPU by allowing it to make multiple requests at once.

## Example 7: Asynchronous (Non-Blocking) HTTP Downloads With Twisted

This version of the program (`example_7.py`) uses the [Twisted module](https://twistedmatrix.com/) to do essentially the same thing as the gevent module, download the URL contents in a non-blocking manner.

Twisted is a very powerful system, and takes a fundementally different approach to create asynchronous programs. Where gevent modifies modules to make their synchronous code asynchronous, Twisted provides it’s own functions and methods to reach the same ends.

Where `example_6.py` used the patched `requests.get(url)` call to get the contents of the URLs, here we use the Twisted function `getPage(url)`.

In this version the `@defer.inlineCallbacks` function decorator works together with the `yield getPage(url)` to perform a context switch into the Twisted event loop.

In gevent the event loop was implied, but in Twisted it’s explicitely provided by the `reactor.run()` statement line near the bottom of the program.

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

Notice the end result is the same as the gevent version, the total program run time is less than the cummulative time for each URL to be retrieved.

## Example 8: Asynchronous (Non-Blocking) HTTP Downloads With Twisted Callbacks

This version of the program (`example_8.py`) also uses the Twisted library, but shows a more traditional approach to using Twisted.

By this I mean rather than using the `@defer.inlineCallbacks` / `yield` style of coding, this version uses explicit callbacks. A “callback” is a function that is passed to the system and can be called later in reaction to an event. In the example below the `success_callback()` function is provided to Twisted to be called when the `getPage(url)` call completes.

Notice in the program the `@defer.inlineCallbacks` decorator is no longer present on the `my_task()` function. In addition, the function is yielding a variable called `d`, shortand for something called a deferred, which is what is returned by the `getPage(url)` function call.

A *deferred* is Twisted’s way of handling asynchronous programming, and is what the callback is attached to. When this deferred “fires” (when the `getPage(url)` completes), the callback function will be called with the variables defined at the time the callback was attached.

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

The end result of running this program is the same as the previous two examples, the total time of the program is less than the cummulative time of getting the URLs.

Whether you use gevent or Twisted is a matter of personal preference and coding style. Both are powerful libaries that provide mechanisms allowing the programmer to create asynchronous code.

## Conclusion

I hope this has helped you see and understand where and how asynchronous programming can be useful. If you’re writing a program that’s calculating PI to the millionth decimal place, asynchronous code isn’t going to help at all.

However, if you’re trying to implement a server, or a program that does a significant amount of IO, it could make a huge difference. It’s a powerful technique that can take your programs to the next level.

## About the Author

Doug is a Python developer with more than 20 years of experience. He writes about Python on his [personal website](http://writeson.pythonanywhere.com/) and currently works as a Senior Web Engineer at Shutterfly. Doug is also an esteemed member of [PythonistaCafe](https://www.pythonistacafe.com).

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
