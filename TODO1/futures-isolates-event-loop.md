> * 原文地址：[Futures - Isolates - Event Loop](https://www.didierboelens.com/2019/01/futures---isolates---event-loop/)
> * 原文作者：[www.didierboelens.com](https://www.didierboelens.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/futures-isolates-event-loop.md](https://github.com/xitu/gold-miner/blob/master/TODO1/futures-isolates-event-loop.md)
> * 译者：
> * 校对者：

# Futures - Isolates - Event Loop

Single Thread, multi threading, synchronous and asynchronous. This article explains the different code execution modes in Flutter.

Difficulty: _Intermediate_

## Introduction

I recently received a couple of questions related to the notions of _Future_, _async_, _await_, _Isolate_ and parallel processing.

Along with these questions, some people experienced troubles with the sequence order of the processing of their code.

I thought that it would be quite useful to take the opportunity of an article to cover these topics and remove any ambiguity, mainly around the notions of _asynchronous_ and _parallel_ processings.

* * *

## Dart is a Single Threaded language

First things first, everyone needs to bear in mind that _Dart_ is **Single Thread** and _Flutter_ relies on _Dart_.

> **IMPORTANT**
> 
> _Dart_ executes **one operation at a time, one after the other** meaning that as long as one operation is executing, it **cannot** be interrupted by any other Dart code.

In other words, if you consider a **purely synchronous** method, the latter will be the **only one** to be executed until it is done.

```
void myBigLoop(){
    for (int i = 0; i < 1000000; i++){
        _doSomethingSynchronously();
    }
}
```

In the example above, the execution of the _myBigLoop()_ method will never be interrupted until it completes. As a consequence, if this method takes some time, the application will be “_blocked_” during the whole method execution.

* * *

## The _Dart_ execution model

Behind the scene, how does _Dart_ actually manage the sequence of operations to be executed?

In order to answer this question, we need to have a look at the _Dart_ code sequencer, called the **Event Loop**.

When you start a _Flutter_ (or any _Dart_) application, a new **Thread** process (in _Dart_ language = “_Isolate_”) is created and launched. This _thread_ will be the only one that you will have to care for the entire application.

So, when this thread is created, Dart automatically

1.  initializes 2 _Queues_, namely “**MicroTask**” and “**Event**” FIFO queues;
2.  executes the **main()** method and, once this code execution is completed,
3.  launches the **Event Loop**

During the whole life of the thread, a **single** internal and invisible process, called the “**Event Loop**”, will drive the way your code will be executed and in which sequence order, depending on the content of both _MicroTask_ and _Event_ Queues.

The _Event Loop_ corresponds to some kind of _infinite_ loop, cadenced by an internal clock which, at each _tick_, **if no other Dart code is being executed**, does something like the following:

```
void eventLoop(){
    while (microTaskQueue.isNotEmpty){
        fetchFirstMicroTaskFromQueue();
        executeThisMicroTask();
        return;
    }

    if (eventQueue.isNotEmpty){
        fetchFirstEventFromQueue();
        executeThisEventRelatedCode();
    }
}
```

As we can see the _MicroTask_ Queue has precedence over the _Event_ Queue but what are those 2 queues used for?

### MicroTask Queue

The _MicroTask_ Queue is used for **very short** internal actions that need to be run _asynchronously_, right after something else completes **and before** giving the hand back to the _Event_ Queue.

As an example of a _MicroTask_ you could imagine having to dispose a resource, right after it has been closed. As the closure process could take some time to complete, you could write something like this:

```
MyResource myResource;

...

void closeAndRelease() {
    scheduleMicroTask(_dispose);
    _close();
}

void _close(){
    // The code to be run synchronously
    // to close the resource
    ...
}

void _dispose(){
    // The code which has to be run
    // right after the _close()
    // has completed
}
```

This is something that most of the time, you will not have to work with. As an example, the whole _Flutter_ source code references the scheduleMicroTask() method only 7 times.

It is always preferable to consider using the _Event_ Queue.

### Event Queue

The _Event_ Queue is used to reference operations that result from

*   external events such as
    *   I/O;
    *   gesture;
    *   drawing;
    *   timers;
    *   streams;
    *   …
*   futures

In fact, each time an **external** event is triggered, the corresponding code to be executed is referenced into the _Event_ Queue.

As soon as there is no longer any _micro task_ to run, the _Event Loop_ considers the first item in the _Event_ Queue and will execute it.

It is very interesting to note that **Futures** are also handled via the _Event_ Queue.

* * *

### Futures

A _Future_ corresponds to a _task_ that runs _asynchronously_ and completes (or fails) some point in time in the future.

When you instantiate a new _Future_:

*   an instance of that _Future_ is created and recorded in an internal array, managed by _Dart_;
*   the code that needs to be executed by this _Future_ is directly pushed into the _Event_ Queue;
*   the _future instance_ is returned with a status (=incomplete);
*   if any, the next synchronous code is executed (**NOT the code of the Future**)

The code referenced by the _Future_ will be executed like any other _Event_, as soon as the _Event Loop_ will pick it up from the _Event_ loop.

When that code will be executed and will complete (or fail) its **then()** or **catchError()** will directly be executed.

In order to illustrate this, let’s take the following example:

```
void main(){
    print('Before the Future');
    Future((){
        print('Running the Future');
    }).then((_){
        print('Future is complete');
    });
    print('After the Future');
}
```

If we run this code, the output will be the following:

```
Before the Future
After the Future
Running the Future
Future is complete
```

This is totally normal as the flow of execution is the following:

1.  print(‘Before the Future’)
2.  add “_(){print(‘Running the Future’);}_” to the Event Queue;
3.  print(‘After the Future’)
4.  the _Event Loop_ fetches the code (referenced in bullet 2) and runs it
5.  when the code is executed, it looks for the _then()_ statement and runs it

Something very important to keep in mind:

> A **Future** is **NOT** executed in parallel but following the regular sequence of events, handled by the **Event Loop**

* * *

### Async methods

When you are suffixing the declaration of a method with the **async** keyword, _Dart_ knows that:

*   the outcome of the method is a _Future_;
*   it runs _synchronously_ the code of that method **up to the very first await** keyword, then it pauses the execution of the remainder of that method;
*   the next line of code will be run as soon as the _Future_, referenced by the _await_ keyword, will have completed.

This is **very important** to understand this since many developers think that **await** pauses the execution if the whole flow _until_ it completes but this is **not the case**. They forget how the **Event Loop** works…

To better illustrate this statement, let’s take the following sample and let’s try to figure out the outcome of its execution.

```
void main() async {
  methodA();
  await methodB();
  await methodC('main');
  methodD();
}

methodA(){
  print('A');
}

methodB() async {
  print('B start');
  await methodC('B');
  print('B end');
}

methodC(String from) async {
  print('C start from $from');
  
  Future((){                // <== This code will be executed some time in the future
    print('C running Future from $from');
  }).then((_){
    print('C end of Future from $from');
  });

  print('C end from $from');  
}

methodD(){
  print('D');
}
```

The correct sequence is the following:

1.  A
2.  B start
3.  C start from B
4.  C end from B
5.  B end
6.  C start from main
7.  C end from main
8.  D
9.  C running Future from B
10.  C end of Future from B
11.  C running Future from main
12.  C end of Future from main

Now, let’s consider that “_methodC()_” from the code above would correspond to a call to a server which might take uneven time to respond. I believe it is obvious to say that it might become very difficult to predict the exact flow of execution.

If your initial expectation from the sample code would have been to only execute _methodD()_ at the end of everything, you should have written the code, as follows:

```
void main() async {
  methodA();
  await methodB();
  await methodC('main');
  methodD();  
}

methodA(){
  print('A');
}

methodB() async {
  print('B start');
  await methodC('B');
  print('B end');
}

methodC(String from) async {
  print('C start from $from');

  await Future((){                  // <== modification is here
    print('C running Future from $from');
  }).then((_){
    print('C end of Future from $from');
  });
  print('C end from $from');  
}

methodD(){
  print('D');
}
```

This gives the following sequence:

1.  A
2.  B start
3.  C start from B
4.  C running Future from B
5.  C end of Future from B
6.  C end from B
7.  B end
8.  C start from main
9.  C running Future from main
10.  C end of Future from main
11.  C end from main
12.  D

The fact of adding a simple **await** at the level of the _Future_ in _methodC()_ changes the whole behavior.

Also very important to keep in mind:

> An **async** method is **NOT** executed in parallel but following the regular sequence of events, handled by the **Event Loop**, too.

A last example I wanted to show you is the following.  
What will be the output of running _method1_ and the one of _method2_? Will they be the same?

```
void method1(){
  List<String> myArray = <String>['a','b','c'];
  print('before loop');
  myArray.forEach((String value) async {
    await delayedPrint(value);
  });  
  print('end of loop');
}

void method2() async {
  List<String> myArray = <String>['a','b','c'];
  print('before loop');
  for(int i=0; i<myArray.length; i++) {
    await delayedPrint(myArray[i]);
  }
  print('end of loop');
}

Future<void> delayedPrint(String value) async {
  await Future.delayed(Duration(seconds: 1));
  print('delayedPrint: $value');
}
```

Answer:

| method1() | method2() |
| --------- | --------- |
| 1.  before loop | 1.  before loop |
| 2.  end of loop | 2.  delayedPrint: a (after 1 second) |
| 3.  delayedPrint: a (after 1 second) | 3.  delayedPrint: b (1 second later) |
| 4.  delayedPrint: b (directly after) | 4.  delayedPrint: c (1 second later) |
| 5.  delayedPrint: c (directly after) | 5.  end of loop (right after) |

Did you see the difference and the reason why their behavior is not the same?

The solution resides in the fact that _method1_ uses a function _forEach()_ to iterate the array. Each time it iterates, it invokes a new callback which is flagged as an **async** (thus a _Future_). It executes it until it gets to the _await_ then it pushes the remainder of the code into the _Event_ queue. As soon as the iteration is complete, it executes the next statement “print(‘end of loop’)”. Once done, the _Event Loop_ will process the 3 callbacks.

As regard _method2_, everything runs inside the same code “block” and therefore runs (in this example), line after line.

As you can see, even in a code that looks like very simple, we still need to keep in mind how the _Event Loop_ works…

* * *

## Multi-Threading

Therefore, how could we run parallel codes in Flutter? Is this possible?

**Yes**, thanks to the notion of [Isolates](https://api.dartlang.org/stable/2.1.0/dart-isolate/Isolate-class.html).

* * *

### What is an Isolate?

An _Isolate_ corresponds to the _Dart_ version of the notion of _Thread_, as already explained earlier.

However, there is a major difference with the usual implementation of “_Threads_” and this is why they are named “**Isolates**”.

> “Isolates” in Flutter **do not share memory**. Interaction between different “Isolates” is made via “**messages**” in terms of communication.

* * *

### Each Isolate has its own “_Event Loop_”

Each “_Isolate_” has its own “_Event Loop_” and Queues (MicroTask and Event). This means that the code runs inside in an _Isolate_, independently of another _Isolate_.

Thanks to this, we can obtain **parallel processing**.

* * *

### How to launch an Isolate?

Depending on the needs you have to run an _Isolate_, you might need to consider different approaches.

#### 1. Low-Level solution

This first solution does not use any package and fully relies on the low-level API, offered by _Dart_.

##### 1.1. Step 1: creation and hand-shaking

As I said earlier, _Isolates_ do not share any memory and communicate via messages, therefore, we need to find a way to establish this communication between the “caller” and the new _isolate_.

Each _Isolate_ exposes a **port** which is used to convey a message to that _Isolate_. This port is called “**SendPort**” (I personally find the name is bit misleading since it is a port aimed at _receiving/listening_, but this is the official name).

This means that both “_caller_” and “_new isolate_” need to know the port of each other to be able to communicate. This hand-shaking process is shown here below:

```
//
// The port of the new isolate
// this port will be used to further
// send messages to that isolate
//
SendPort newIsolateSendPort;

//
// Instance of the new Isolate
//
Isolate newIsolate;

//
// Method that launches a new isolate
// and proceeds with the initial
// hand-shaking
//
void callerCreateIsolate() async {
    //
    // Local and temporary ReceivePort to retrieve
    // the new isolate's SendPort
    //
    ReceivePort receivePort = ReceivePort();

    //
    // Instantiate the new isolate
    //
    newIsolate = await Isolate.spawn(
        callbackFunction,
        receivePort.sendPort,
    );

    //
    // Retrieve the port to be used for further
    // communication
    //
    newIsolateSendPort = await receivePort.first;
}

//
// The entry point of the new isolate
//
static void callbackFunction(SendPort callerSendPort){
    //
    // Instantiate a SendPort to receive message
    // from the caller
    //
    ReceivePort newIsolateReceivePort = ReceivePort();

    //
    // Provide the caller with the reference of THIS isolate's SendPort
    //
    callerSendPort.send(newIsolateReceivePort.sendPort);

    //
    // Further processing
    //
}
```

> **CONSTRAINTS**
> 
> The “_entry point_” of an isolate **MUST** be a top-level function or a **STATIC** method.

##### 1.2. Step 2: submission of a Message to the Isolate

Now that we have the port to be used to send a message to the Isolate, let’s see how to do it:

```
//
// Method that sends a message to the new isolate
// and receives an answer
// 
// In this example, I consider that the communication
// operates with Strings (sent and received data)
//
Future<String> sendReceive(String messageToBeSent) async {
    //
    // We create a temporary port to receive the answer
    //
    ReceivePort port = ReceivePort();

    //
    // We send the message to the Isolate, and also
    // tell the isolate which port to use to provide
    // any answer
    //
    newIsolateSendPort.send(
        CrossIsolatesMessage<String>(
            sender: port.sendPort,
            message: messageToBeSent,
        )
    );

    //
    // Wait for the answer and return it
    //
    return port.first;
}

//
// Extension of the callback function to process incoming messages
//
static void callbackFunction(SendPort callerSendPort){
    //
    // Instantiate a SendPort to receive message
    // from the caller
    //
    ReceivePort newIsolateReceivePort = ReceivePort();

    //
    // Provide the caller with the reference of THIS isolate's SendPort
    //
    callerSendPort.send(newIsolateReceivePort.sendPort);

    //
    // Isolate main routine that listens to incoming messages,
    // processes it and provides an answer
    //
    newIsolateReceivePort.listen((dynamic message){
        CrossIsolatesMessage incomingMessage = message as CrossIsolatesMessage;

        //
        // Process the message
        //
        String newMessage = "complemented string " + incomingMessage.message;

        //
        // Sends the outcome of the processing
        //
        incomingMessage.sender.send(newMessage);
    });
}

//
// Helper class
//
class CrossIsolatesMessage<T> {
    final SendPort sender;
    final T message;

    CrossIsolatesMessage({
        @required this.sender,
        this.message,
    });
}
```

##### 1.3. Step 3: destruction of the new Isolate

When you do no longer need the new Isolate instance, it is a good practice to release it, the following way:

```
//
// Routine to dispose an isolate
//
void dispose(){
    newIsolate?.kill(priority: Isolate.immediate);
    newIsolate = null;
}
```

##### 1.4. Special note - Single-Listener Streams

You might have certainly noticed that we are using _Streams_ to communicate between the “_caller_” and the new _isolate_. These _Streams_ are of type: “**Single-Listener**” Streams.

* * *

#### 2. One-shot computation

If you only need to run some piece of code to do some specific job and do not need to interact with that _Isolate_ once the job is done, there exists a very convenient _Helper_, called [compute](https://docs.flutter.io/flutter/foundation/compute.html).

This function:

*   spawns an _Isolate_,
*   runs a _callback_ function on that isolate, passing it some data,
*   returns the value, outcome the callback,
*   and kills the _Isolate_ at the end of the execution of the callback.

> **CONSTRAINTS**
> 
> The “callback” function **MUST** be a top-level function and **CANNOT** be a closure or a method of a class (static or not).

* * *

#### 3. **IMPORTANT LIMITATION**

At time of writing this article, it is important to note that

> Platform-Channel communication **ARE ONLY SUPPORTED** by the **main isolate**. This _main isolate_ corresponds to the one which is created when your application is launched.

In other words, _Platform-Channel_ communication is not possible via instances of isolates you programmatically create…

There is however a work-around… Please refer to this [link](https://github.com/flutter/flutter/issues/13937) for a discussion on this topic.

* * *

### When should I use Futures and Isolates?

Users will evaluate the quality of an application based on different factors, such as:

*   features
*   look
*   user friendliness
*   …

Your application could meet all of these factors but if the user experiences **lags** in the course of some processing, it is most likely that this will go against you.

Therefore, here are some hints you should systematically take into consideration in your developments:

1.  If pieces of codes **MAY NOT** be interrupted, use a _normal_ synchronous process (one method or multiple methods that call each other);
2.  If pieces of codes could run independently **WITHOUT** impacting the fluidity of the application, consider using the **Event Loop** via the use of **Futures**;
3.  If heavy processing might take some time to complete and could potentially impact the fluidity of the application, consider using **Isolates**.

In other words, it is advisable to try to use as much as possible the notion of **Futures** (directly or indirectly via **async** methods) as the code of these _Futures_ will be run as soon as the _Event Loop_ has some time. This will give the user the _feeling_ that things are being processed in parallel (while we now know it is not the case).

Another factor that could help you decide whether to use a _Future_ or an _Isolate_ is the average time it takes to run some code.

*   If a method takes a couple of _milliseconds_ => **Future**
*   If a processing might take several hundreds of _milliseconds_ => **Isolate**

Here are some good candidates for _Isolates_:

*   _JSON_ decoding: decoding a JSON, result of an HttpRequest, might take some time => use **compute**
*   encryption: encryption might be very consuming => **Isolate**
*   image processing: processing an image (cropping, e.g.) does take some time to complete => **Isolate**
*   load an image from the Web: in this case, why not delegating this to an **Isolate** which will return the complete image, once fully loaded?

* * *

## Conclusions

I think that understanding how the _Event Loop_ works is essential.

It is also important to keep in mind that _Flutter_ (_Dart_) is _Single-Thread_ therefore, in order to please the users, developers must make sure that the application will run as smoothly as possible. _Futures_ and _Isolates_ are very powerful tools that can help you achieve this goal.

Stay tuned for new articles and meanwhile… I wish you a happy coding !

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
