> * 原文地址：[Android Handler Internals](https://medium.com/@jagsaund/android-handler-internals-b5d49eba6977)
* 原文作者：[Jag Saund](https://medium.com/@jagsaund)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

For an Android application to be responsive, you need to prevent the UI thread from blocking. Responsiveness also increases when blocking or computationally intensive tasks are offloaded to worker threads. The results of these operations often need to update UI components, which must be performed on the UI thread. Mechanisms like blocking queues, shared memory, and pipes impose blocking problems for the UI thread. To prevent this issue, Android provides its own message passing mechanism — the [Handler[1]](https://developer.android.com/reference/android/os/Handler.html). The Handler is a fundamental component in the Android framework. It offers a non-blocking message passing mechanism. Neither the producer nor the consumer block during message hand-offs.

Though Handlers are used frequently, it’s easy to overlook how they work. This articles takes a deeper look into the various components of the Handler. It explains why the Handler is a powerful component that goes beyond worker threads and UI thread communication.

### Image Viewer Example

Let’s start with an example of how we might use a Handler in an application. Consider an activity that needs to display an image fetched from the network. There’s several approaches to do this. In this example, we’ll start a new worker thread to perform the network call and retrieve the image payload.

An alternative is to use Handler Messages instead of Runnables.

In this second example, a worker thread fetches an image from the network. Once the image downloads, we need to update the ImageView with the bitmap. We know we can’t touch UI components from a non-UI thread, so we use a Handler. The Handler acts as a mediator between the worker thread and the UI thread. The message is enqueued by the Handler on the worker thread and processed by the Handler on the UI thread.

### A Deeper Look Inside the Handler

The components of a Handler are:

*   Handler
*   Message
*   Message Queue
*   Looper

We’ll look at each component and see how they interact with one another.

#### Handler

The [Handler[2]](https://developer.android.com/reference/android/os/Handler.html) is the immediate interface for message passing between threads. Both the consumer and producer threads interact with the Handler by invoking the following operations:

*   creating, inserting, or removing Messages from the Message Queue
*   processing Messages on the consumer thread





![](https://cdn-images-1.medium.com/freeze/max/60/1*Xiqug6cw7eXJQpimg5Hnnw.png?q=20)

![](https://cdn-images-1.medium.com/max/1600/1*Xiqug6cw7eXJQpimg5Hnnw.png)

![](https://cdn-images-1.medium.com/max/2000/1*Xiqug6cw7eXJQpimg5Hnnw.png)





The android.os.Handler component



Each Handler is associated with a Looper and a Message Queue. There’s two ways to create a Handler:

*   through the default constructor, which uses the Looper associated with the current thread
*   by explicitly specifying which Looper to use

A Handler can’t function without a Looper because it can’t put messages in the Message Queue. Thus, it won’t receive any messages to process.

    public Handler(Callback callback, boolean async) {
        // code removed for simplicity
        mLooper = Looper.myLooper();
        if (mLooper == null) {
            throw new RuntimeException( “Can’t create handler inside thread that has not called Looper.prepare()”);
        }
        mQueue = mLooper.mQueue;
        mCallback = callback;
        mAsynchronous = async;
        }

The snippet from [Android Source](https://github.com/android/platform_frameworks_base/blob/master/core/java/android/os/Handler.java#L188) (above) demonstrates the logic of constructing a new Handler. The handler checks if the current thread has a valid Looper. If not, it throws a Runtime exception. The Handler then receives a reference to the Looper’s Message Queue.

**Note:** _Multiple Handlers associated with the same thread share the same Message Queue because they share the same Looper._

The Callback is an optional argument. If provided, it processes messages dispatched by the Looper.

#### Message

The [Message[3]](https://developer.android.com/reference/android/os/Message.html) acts as a container for arbitrary data. The producer thread sends Messages to the Handler, which enqueues to the Message Queue. The Message provides three pieces of extra information, required by the Handler and Message Queue to process the message:

*   _what_ — an identifier the Handler can use to distinguish messages and process them differently
*   _time_ — informs the Message Queue when to process a Message
*   _target_ — indicates which Handler should process the Message





![](https://cdn-images-1.medium.com/freeze/max/60/1*odjf27TxzW3gC7-tbF-bPQ.png?q=20)

![](https://cdn-images-1.medium.com/max/1600/1*odjf27TxzW3gC7-tbF-bPQ.png)





The android.os.Message component



Message creation typically uses of one of the following Handler methods:

    public final Message obtainMessage()
    public final Message obtainMessage(int what)
    public final Message obtainMessage(int what, Object obj)
    public final Message obtainMessage(int what, int arg1, int arg2)
    public final Message obtainMessage(int what, int arg1, int arg2, Object obj)

The Message is obtained from the message pool. The supplied arguments populate the fields of the Message. The Handler also sets the Message’s target to itself. This allows us to chain the call as such:

    mHandler.obtainMessage(MSG_SHOW_IMAGE, mBitmap).sendToTarget();

The Message pool is a LinkedList of Message objects with a maximum pool size of 50\. After the Handler processes the Message, the Message Queue returns the object to the pool and resets all fields.

When posting a Runnable to the Handler via post(Runnable r), the Handler implicitly constructs a new Message. It also sets the callback field to hold the Runnable.

    Message m = Message.obtain();
    m.callback = r;





![](https://cdn-images-1.medium.com/freeze/max/60/1*g3PR2PWaPmD0q5DfAQxpsA.png?q=20)

![](https://cdn-images-1.medium.com/max/1600/1*g3PR2PWaPmD0q5DfAQxpsA.png)

![](https://cdn-images-1.medium.com/max/2000/1*g3PR2PWaPmD0q5DfAQxpsA.png)





Interaction of Producer Thread sending message to a Handler



At this point we can see the interaction between a producer thread and a Handler. The producer creates a Message and sends it to the Handler. The Handler then enqueues the Message into the Message Queue. The Handler processes the Message on the consumer thread sometime in the future.

#### Message Queue

The [Message Queue[4]](https://developer.android.com/reference/android/os/MessageQueue.html) is an unbounded LinkedList of Message objects. It inserts Messages in time order, where the lowest timestamp dispatches first.





![](https://cdn-images-1.medium.com/freeze/max/60/1*ogdWmXRs5md-KmiBnb61eg.png?q=20)

![](https://cdn-images-1.medium.com/max/1600/1*ogdWmXRs5md-KmiBnb61eg.png)





The android.os.MessageQueue component



The MessageQueue also maintains a dispatch barrier that represents the current time according to SystemClock.uptimeMillis. When a Message timestamp is less than this value, the message is dispatched and processed by the Handler.

The Handler offers three variations for sending a Message:

    public final boolean sendMessageDelayed(Message msg, long delayMillis)
    public final boolean sendMessageAtFrontOfQueue(Message msg)
    public boolean sendMessageAtTime(Message msg, long uptimeMillis)

Sending a message with a delay sets the Message’s _time_ field as _SystemClock.uptimeMillis()_ + _delayMillis_.

Messages sent with a delay have the time field set to SystemClock.uptimeMillis() + delayMillis. Whereas, Messages sent to the front of the queue have the time field set to 0, and process on the next Message loop iteration. Use this method with care as it can starve the message queue, cause ordering problems, or have other unexpected side-effects.

Handlers are often associated with UI components, which reference an Activity. The reference from the Handler back to these components can potentially leak the Activity. Consider the following scenario:

In this example, the Activity starts a new worker thread to download and display an image in an ImageView. The worker thread communicates UI updates via the UIHandler, which retains references to Views and updates their state (toggle visibility, set the bitmap).

Let’s assume the worker thread is taking long to download the image due to slow network. Destroying the Activity before the worker thread completes results in an Activity leak. There are two strong references in this example. One between the worker thread and UIHandler, and another between the UIHandler and the views. This prevents the Garbage Collector from reclaiming the Activity reference.

Now, let’s look at another example:

In this example, the following sequence of events occur:

*   A PingHandler is created
*   The Activity sends a delayed Message to the Handler, which enqueues into the MessageQueue
*   The Activity is destroyed before the Message dispatches
*   The Message is dispatched and processed by the UIHandler, and a log statement is output

Though it may not be apparent at first, the Activity leaks in this example as well.

After destroying the Activity, the Handler reference should be available for Garbage Collection. However, when we create a Message object, it retains a reference to the Handler:

    private boolean enqueueMessage(MessageQueue queue, Message msg, long uptimeMillis) {
        msg.target = this;
        if (mAsynchronous) {
            msg.setAsynchronous(true);
        }
        return queue.enqueueMessage(msg, uptimeMillis);
        }

The Android Source snippet (above) shows that all Messages sent to a Handler eventually invoke enqueueMessage. Notice that the Handler reference is explicitly assigned to msg.target. This tells the Looper which Handler should process the message when it’s retrieved from the MessageQueue.

The Message is added to the MessageQueue, which now holds a reference to the Message. The MessageQueue also has a Looper associated with it. An explicit Looper lives until it’s terminated, whereas the Main Looper lives as long as the application does. The Handler reference lives as long as the Message isn’t recycled by the MessageQueue. Once it’s recycled, it’s fields, including the target reference, are cleared.

Though there is a long living reference to the Handler, it isn’t clear if the Activity leaks. To check for a leak, we must determine if the Handler also references the Activity within the class. In this example, it does. There’s an implicit reference retained by a non-static class member to its enclosing class. Specifically, the PingHandler wasn’t declared as a static class, so it has an implicit reference to the Activity.

Using a combination of a WeakReference and a static class modifier prevents the Handler from leaking the Activity. When the Activity is destroyed, the WeakReference allows the Garbage Collector to reclaim the object you want to retain (typically an Activity). The static modifier on the inner Handler class prevents an implicit reference to the parent class.

Let’s modify our UIHandler from this example to address this concern:

Now, the UIHandler constructor takes in the Activity, which is wrapped in a WeakReference. This allows the Garbage Collector to reclaim the activity reference when the activity is destroyed. To interact with UI components of the Activity, we need a strong reference to the Activity from mActivityRef. Since we’re using a WeakReference, we must exercise caution when accessing the Activity. If the only path to an Activity reference is through a WeakReference, the Garbage Collector may have already reclaimed it. We need to check if that’s happened. If it has, the Handler is effectively irrelevant and the messages should be ignored.

Though this logic addresses leaking memory, there’s still a problem with it. The activity is already destroyed, yet the Garbage Collector hasn’t reclaimed the reference. Depending on the operation being performed, this can potentially crash your application. To work around this, we need to detect what state the activity is in.

Let’s update the UIHandler logic to account for these scenarios:

Now, we can generalize the interaction between a MessageQueue, the Handler, and Producer Threads:





![](https://cdn-images-1.medium.com/freeze/max/60/1*_2pw5528rfoTpPBE7l9NmA.png?q=20)

![](https://cdn-images-1.medium.com/max/1600/1*_2pw5528rfoTpPBE7l9NmA.png)

![](https://cdn-images-1.medium.com/max/2000/1*_2pw5528rfoTpPBE7l9NmA.png)





Interaction between MessageQueue, Handlers, and Producer Threads



In the figure (above), multiple producer threads submit Messages to different Handlers. However, each Handler is associated with the same Looper, so all Messages publish to the same MessageQueue. This is important because Android creates several Handlers associated with the Main Looper:

*   _The Choreographer:_ handles vsync and frame updates
*   _The ViewRoot:_ handles input and window events, configuration changes, etc.
*   _The InputMethodManager:_ handles keyboard touch events
*   And several others

**Tip:** _Ensure that producer threads aren’t spawning several Messages, as they may starve processing system generated Messages._





![](https://cdn-images-1.medium.com/freeze/max/60/1*rvIs3RCqJw1WFwuHwMtgaQ.png?q=20)

![](https://cdn-images-1.medium.com/max/1600/1*rvIs3RCqJw1WFwuHwMtgaQ.png)

![](https://cdn-images-1.medium.com/max/2000/1*rvIs3RCqJw1WFwuHwMtgaQ.png)





A small sample of events dispatched by the Main Looper



**Debugging Tips:** You can debug/dump all Messages dispatched by a Looper by attaching a LogPrinter:

    final Looper looper = getMainLooper();
        looper.setMessageLogging(new LogPrinter(Log.DEBUG, "Looper"));

Similarly, you can debug/dump all pending Messages in a MessageQueue associated with your Handler by attaching a LogPrinter to your Handler:

    handler.dump(new LogPrinter(Log.DEBUG, "Handler"), "");

#### Looper

The [Looper[5]](https://developer.android.com/reference/android/os/Looper.html) reads messages from the Message Queue and dispatches execution to the target Handler. Once a Message passes the dispatch barrier, it’s eligible for the Looper to read it in the next message loop. The Looper blocks when no messages are eligible for dispatch. It resumes when a Message is available.

Only one Looper can be associated with a Thread. Attaching another Looper to a Thread results in a RuntimeException. The use of a static ThreadLocal object in the Looper class ensures that only one Looper is attached to the Thread.

Calling Looper.quit terminates the Looper immediately. It also discards any Messages in the Message Queue that passed the dispatch barrier. Calling Looper.quitSafely ensures all Messages ready for dispatch are processed before pending messages are discarded.





![](https://cdn-images-1.medium.com/freeze/max/60/1*sNJrg-3mVc54jZfVevWoDg.png?q=20)

![](https://cdn-images-1.medium.com/max/1600/1*sNJrg-3mVc54jZfVevWoDg.png)





Overall flow of Handler interacting with MessageQueue and Looper



The Looper is setup in the run() method of a Thread. A call to the static method Looper.prepare() checks if a preexisting Looper is associated with this Thread. It does this by using the Looper’s ThreadLocal to check if a Looper object already exists. If it doesn’t, a new Looper object and a new MessageQueue are created. The [Android Source](https://github.com/android/platform_frameworks_base/blob/e71ecb2c4df15f727f51a0e1b65459f071853e35/core/java/android/os/Looper.java#L83) snippet (below) demonstrates this.

**Note:** _The public prepare Looper method invokes prepare(true) internally._

    private static void prepare(boolean quitAllowed) {
        if (sThreadLocal.get() != null) {
            throw new RuntimeException(“Only one Looper may be created per thread”);
        }
        sThreadLocal.set(new Looper(quitAllowed));
        }

The Handler can now receive Messages and add them to the Message Queue. Executing the static Looper.loop () method will start reading the Messages off the queue. Each loop iteration retrieves the next message, dispatches it to the target Handler, and recycles it back to the Message pool. Looper.loop will continue this process until the Looper is terminated. The [Android Source](https://github.com/android/platform_frameworks_base/blob/e71ecb2c4df15f727f51a0e1b65459f071853e35/core/java/android/os/Looper.java#L123) snippet (below) demonstrates this:

    public static void loop() {
        if (me == null) {
            throw new RuntimeException("No Looper; Looper.prepare() wasn't called on this thread.");
        }
        final MessageQueue queue = me.mQueue;
        for (;;) {
            Message msg = queue.next(); // might block
            if (msg == null) {
                // No message indicates that the message queue is quitting.
                return;
            }
            msg.target.dispatchMessage(msg);
            msg.recycleUnchecked();
        }
        }

It’s not necessary to create your own thread that has a Looper attached to it. Android provides a convenience class for this — HandlerThread. It extends the Thread class and manages the creation of a Looper. The snippet below describes a typical usage pattern:

    private final Handler handler;
        private final HandlerThread handlerThread;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate();
        handlerThread = new HandlerThread("HandlerDemo");
        handlerThread.start();
        handler = new CustomHandler(handlerThread.getLooper());
        }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        handlerThread.quit();
        }

The onCreate() method constructs a new HandlerThread. When the HandlerThread starts, it prepared the Looper and attaches it to the thread. The Looper now begins processing messages off the MessageQueue on the HandlerThread.

**Note:** _When the activity is destroyed, it’s important to terminate the HandlerThread. This also terminates the Looper._

#### Summary

The Android Handler plays an integral role in an Application’s lifecycle. It sets the foundation of the Half-Sync/Half-Async architectural pattern. Various internal and external sources rely on the Handler for asynchronous event dispatching, as it minimizes overhead and maintains thread safety.

A deeper understanding of how a component works helps resolve hard problems. It also allows us to use the component’s APIs optimally. We often use the Handler as a mechanism for worker to UI thread communication, but it’s more than that. The Handler appears in the [IntentService[6]](https://developer.android.com/reference/android/app/IntentService.html), the [Camera2[7]](https://developer.android.com/reference/android/hardware/camera2/CameraCaptureSession.html) APIs, and many others. In these APIs, it’s used more generally to focus on communicating between arbitrary threads.

We can apply this deeper understanding of the Handler to building more efficient, simple, and robust applications.