> * 原文地址：[Android Handler Internals](https://medium.com/@jagsaund/android-handler-internals-b5d49eba6977)
* 原文作者：[Jag Saund](https://medium.com/@jagsaund)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Jamweak] (https://github.com/jamweak)
* 校对者：

如果你想要让一个Android应用程序反应灵敏，那么你必须防止它的UI线程被阻塞。同样地，将这些阻塞的或是计算密集型的任务转到工作线程去执行也会提高程序的响应灵敏性。然而，这些任务的执行结果通常需要更新UI组件的显示，但这只能在UI线程中去完成。有一些方法解决了UI线程的消息传递问题，例如blocking queue，共享内存以及管道技术。在Android中，为解决这个问题，提供了一种自有的消息传递机制——[Handler](https://developer.android.com/reference/android/os/Handler.html)。Handler是Android Framework架构中的一个基础组件，它实现了一种非阻塞的消息传递机制，在消息转换的过程中，消息的生产者和消费者都不会阻塞。

虽然Handler被使用的频率非常高，它的工作原理却很容易被忽视。本篇文章深入地剖析Handler众多内部组件的实现，它将会向您揭示Handler的强大之处，而不仅仅作为一个工作线程和UI线程通信的工具。

### 图片浏览示例

让我们从一个例子开始了解如何在应用中使用Handler。设想一个Activity需要从网络上获取图片并显示。有几种方式来做这件事，在下面的例子中，我们创建了一个新的工作线程去执行网络请求以获取图片。

```
public class ImageFetcherActivity extends AppCompactActivity {
    class WorkerThread extends Thread {
        void fetchImage(String url) {
            // network logic to create and execute request
            handler.post(new Runnable() {
                @Override
                public void run() {
                    imageView.setImageBitmap(image);
                }
            });
        }
    }
    
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        // prepare the view, maybe setContentView, etc
        new WorkerThread().fetchImage(imageUrl);
    }
}
```

另一种方法则是使用Handler Messages来代替Runnables。

```
public class ImageFetcherAltActivity extends AppCompactActivity {
    class WorkerThread extends Thread {
        void fetchImage(String url) {
            handler.sendEmptyMessage(MSG_SHOW_LOADER);
            // network call to load image
            handler.obtainMessage(MSG_SHOW_IMAGE, imageBitmap).sendToTarget();
        }
    }
    
    class UIHandler extends Handler {
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case MSG_SHOW_LOADER: {
                    progressIndicator.setVisibility(View.VISIBLE);
                    break;
                }
                case MSG_HIDE_LOADER: {
                    progressIndicator.setVisibility(View.GONE);
                    break;
                }
                case MSG_SHOW_IMAGE: {
                    progressIndicator.setVisibility(View.GONE);
                    imageView.setImageBitmap((Bitmap) msg.obj);
                    break;
                }
            }
        }
    }
    
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        // prepare the view, maybe setContentView, etc
        new WorkerThread().fetchImage(imageUrl);
    }
}
```
在第二个例子中，工作线程从网络获取到一张图片，一旦下载完成，我们需用使用下载好的bitmap去更新ImageView显示内容。我们知道我们不能从非UI线程中更新UI组件，因此我们使用Handler。Handler扮演了工作线程和UI线程的中间人的角色。消息在工作线程中被Handler加入队列，随后在UI线程中被Handler处理。

### 深入了解Handler

Handler由以下部分组成:

*   Handler
*   Message
*   Message Queue
*   Looper

我们接下来将学习各个组件以及他们之间的交互。

#### Handler

[Handler[2]](https://developer.android.com/reference/android/os/Handler.html)是线程间传递即时消息的接口，生产线程和消费线程调用以下操作来使用Handler:

*   在消息队列中创建、插入或移除消息
*   在消费线程中处理消息

![](https://cdn-images-1.medium.com/max/2000/1*Xiqug6cw7eXJQpimg5Hnnw.png)

android.os.Handler组件

每个Handler都有一个与之关联的Looper和消息队列。有两种创建Handler的方式：

*   通过默认的构造方法，使用当前线程中关联的Looper
*   显式地指定使用的Looper

没有指定Looper的Handler是无法工作的，因为它无法将消息放到消息队列中。因此，它无法获取要处理的消息。

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

上面的[代码段](https://github.com/android/platform_frameworks_base/blob/master/core/java/android/os/Handler.java#L188)展示了创建一个新的Handler的逻辑。Handler在创建时检查了当前的线程有没有可用的Looper对象，如果没有，它会抛出一个运行时的异常。如果正常的话，Handler则会持有Looper中消息队列对象的引用。

**注意:** _同一线程中的多个Handler分享一个同样的消息队列，因为他们分享的是同一个Looper对象。_

Callback参数是一个可选参数，如果提供的话，它将会处理由Looper分发过来的消息。

#### Message

[Message[3]](https://developer.android.com/reference/android/os/Message.html)是容纳任意数据的容器。生产线程发送消息给Handler，将其加入消息队列中。消息提供了三种额外的信息，以供Handler和消息队列处理时使用：

*   _what_ — 一种标识符，Handler能使用它来区分不同消息，从而采取不同的处理方法
*   _time_ — 告知消息队列何时处理消息
*   _target_ — 表示哪一个Handler应当处理消息


![](https://cdn-images-1.medium.com/max/1600/1*odjf27TxzW3gC7-tbF-bPQ.png)

The android.os.Message组件

消息的创建一般是通过使用Handler的以下方法实现：

    public final Message obtainMessage()
    public final Message obtainMessage(int what)
    public final Message obtainMessage(int what, Object obj)
    public final Message obtainMessage(int what, int arg1, int arg2)
    public final Message obtainMessage(int what, int arg1, int arg2, Object obj)

消息从消息池中获取得到，方法中提供的参数会放到消息体的对应字段中。Handler同样可以设置消息的目标为其自身，这允许我们可以进行循环调用，比如：

    mHandler.obtainMessage(MSG_SHOW_IMAGE, mBitmap).sendToTarget();

消息池是一个消息体对象的LinkedList，它的最大长度是50。在Handler处理完这条消息之后，消息队列返回这个对象到消息池中，并且重置其所有字段。

当使用Handler调用post方法来执行一个Runnable时，Handler隐式地创建了一个新的消息，并且设置callback参数来存储这个Runnable。

    Message m = Message.obtain();
    m.callback = r;


![](https://cdn-images-1.medium.com/max/2000/1*g3PR2PWaPmD0q5DfAQxpsA.png)

生产线程发送消息给Handler的交互

在上图中，我们能看到生产线程和Handler的交互。生产者创建了一个消息，并且发送给了Handler，随后Handler将这个消息加入消息队列中，在未来的某个时间，Handler会在消费线程中处理这个消息。

#### Message Queue

[Message Queue[4]](https://developer.android.com/reference/android/os/MessageQueue.html) 是一个消息体对象的无限LinkedList集合。 它按时序将消息插入队列，最小的时间戳将会被首先处理。

![](https://cdn-images-1.medium.com/max/1600/1*ogdWmXRs5md-KmiBnb61eg.png)

The android.os.MessageQueue组件

消息队列同样也维护着一个阻塞阈值(dispatch barrier)，根据SystemClock.uptimeMillis来表示当前的时间。当一个消息体的时间戳低于这个值的时候，消息就会被分发给Handler进行处理。

Handler提供了三种方式来发送消息：

    public final boolean sendMessageDelayed(Message msg, long delayMillis)
    public final boolean sendMessageAtFrontOfQueue(Message msg)
    public boolean sendMessageAtTime(Message msg, long uptimeMillis)

以延迟的方式发送消息，是设置了消息体的 _time_ 字段为 _SystemClock.uptimeMillis()_ + _delayMillis_ 。

延迟发送的消息设置了其时间字段为SystemClock.uptimeMillis() + delayMillis。然而，通过sendMessageAtFrontOfQueue()方法发送消息到队列头部，会将其时间字段设置为0，消息会在下一次轮询时被处理。需要谨慎使用这个方法，因为它可能会影响消息队列，造成顺序问题，或是其它不可预料的副作用。

Handler常与一些UI组件相关联，而这些UI组件通常持有对Activity的引用。Handler持有的对这些组件的引用可能会导致潜在的Activity泄露。考虑如下场景：

```
public class MainActivity extends AppCompatActivity {
    private static final String IMAGE_URL = "https://www.android.com/static/img/android.png";

    private static final int MSG_SHOW_PROGRESS = 1;
    private static final int MSG_SHOW_IMAGE = 2;

    private ProgressBar progressIndicator;
    private ImageView imageView;
    private Handler handler;

    class ImageFetcher implements Runnable {
        final String imageUrl;

        ImageFetcher(String imageUrl) {
            this.imageUrl = imageUrl;
        }

        @Override
        public void run() {
            handler.obtainMessage(MSG_SHOW_PROGRESS).sendToTarget();
            InputStream is = null;
            try {
                // Download image over the network
                URL url = new URL(imageUrl);
                HttpURLConnection conn = (HttpURLConnection) url.openConnection();

                conn.setRequestMethod("GET");
                conn.setDoInput(true);
                conn.connect();
                is = conn.getInputStream();

                // Decode the byte payload into a bitmap
                final Bitmap bitmap = BitmapFactory.decodeStream(is);
                handler.obtainMessage(MSG_SHOW_IMAGE, bitmap).sendToTarget();
            } catch (IOException ignore) {
            } finally {
                if (is != null) {
                    try {
                        is.close();
                    } catch (IOException ignore) {
                    }
                }
            }
        }
    }

    class UIHandler extends Handler {
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case MSG_SHOW_PROGRESS: {
                    imageView.setVisibility(View.GONE);
                    progressIndicator.setVisibility(View.VISIBLE);
                    break;
                }
                case MSG_SHOW_IMAGE: {
                    progressIndicator.setVisibility(View.GONE);
                    imageView.setVisibility(View.VISIBLE);
                    imageView.setImageBitmap((Bitmap) msg.obj);
                    break;
                }
            }
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        progressIndicator = (ProgressBar) findViewById(R.id.progress);
        imageView = (ImageView) findViewById(R.id.image);

        handler = new UIHandler();

        final Thread workerThread = new Thread(new ImageFetcher(IMAGE_URL));
        workerThread.start();
    }
}
```

在这个例子中，Activity开启了一个新的工作线程去下载并且在ImageView中展示图片。工作线程通过UIHandler去通知UI更新，这样就会持有了对View的引用，以便更新这些View的状态（切换可见性、设置图片等）。

让我们假设工作线程由于网络差，需要很长的时间去下载图片。在工作线程下载完成之前销毁这个Activity会导致Activity泄露。在本例中，有两个强引用关系，一个在工作线程和UIHandler之间，另一个在UIHandler和View之间。这就阻止了垃圾回收机制回收Activity的引用。

现在，让我们来看看另一个例子：

```
public class MainActivity extends AppCompatActivity {
    private static final String TAG = "Ping";

    private Handler handler;

    class PingHandler extends Handler {
        @Override
        public void handleMessage(Message msg) {
            Log.d(TAG, "Ping message received");
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        handler = new PingHandler();
        
        final Message msg = handler.obtainMessage();
        handler.sendEmptyMessageDelayed(0, TimeUnit.MINUTES.toMillis(1));
    }
}
```

在这个例子中ing，将按顺序发生如下事件：

*   PingHandler被创建
*   Activity发送了一个带延迟的消息给Handler，随后消息加入到消息队列中
*   Activity在消息到达之前被销毁
*   消息被分发，并被UIHandler处理，输出一条日志

虽然起初看起来不那么明显，但本例中的Activity也存在着泄露。

在销毁Activity之后，Handler应当可以被垃圾回收，然而当创建了一个消息对象之后，它也会持有对Handler的引用：

    private boolean enqueueMessage(MessageQueue queue, Message msg, long uptimeMillis) {
        msg.target = this;
        if (mAsynchronous) {
            msg.setAsynchronous(true);
        }
        return queue.enqueueMessage(msg, uptimeMillis);
    }

上面的Android代码段表明，所有被发送到Handler的消息最终都会触发enqueueMessage方法。注意到Handler的引用被显示地赋给了msg.target，以此来告诉Looper对象当消息从消息队列出队时，选择哪一个Handler来对其进行处理。

消息加入消息队列后，消息队列就获得了对消息的引用。它同样有一个与之关联的Looper。一个自定义的Looper对象的生命周期一直持续到它被结束，然而主线程中的Looper对象在程序的生命周期内一直存在。因此，消息中持有的对Handler的引用会一直维持到该消息被消息队列回收之前，一旦消息被回收，它内部的各字段，包括目标target的引用都会被清空。

虽然Handler能存活很长时间，但是当Activity发生泄露时，Handler不会被清空。为了检查是否发生泄露，我们必须检查Handler是否在本类范围内持有Activity的引用。在本例中，它确实持有：非静态内部类持有一个对其外部类的隐式引用。明确一点来说，PingHandler没有定义成一个静态类，所以它持有一个隐式的Activity引用。

通过结合使用弱引用和静态类修饰符可以阻止Handler导致的Activity泄露。当Activity被销毁时，弱引用允许垃圾回收器去回收你想要留存的对象（通常来说是Activity）。在Handler内部类前加入静态修饰符可以阻止对外部类持有隐式引用。

让我们来修改上例中的UIHandler来解决这个烦恼：

```
static class UIHandler extends Handler {
    private final WeakReference<ImageFetcherActivity> mActivityRef;
    
    UIHandler(ImageFetcherActivity activity) {
        mActivityRef = new WeakReference(activity);
    }
    
    @Override
    public void handleMessage(Message msg) {
        final ImageFetcherActivity activity = mActivityRef.get();
        if (activity == null) {
            return
        }
        
        switch (msg.what) {
            case MSG_SHOW_LOADER: {
                activity.progressIndicator.setVisibility(View.VISIBLE);
                break;
            }
            case MSG_HIDE_LOADER: {
                activity.progressIndicator.setVisibility(View.GONE);
                break;
            }
            case MSG_SHOW_IMAGE: {
                activity.progressIndicator.setVisibility(View.GONE);
                activity.imageView.setImageBitmap((Bitmap) msg.obj);
                break;
            }
        }
    }
}
```

现在，UIHandler的构造方法中需要传入Activity，而这个引用会被弱引用包装。这样就允许垃圾回收器在Activity销毁时回收这个引用。当与Activity中的UI组件交互时，我们需要从mActivityRef中获得一个Activity的强引用。由于我们正在使用一个弱引用，我们必须小心翼翼地去访问Activity。如果仅仅能通过弱引用的方式去访问Activity，垃圾回收器也许已经将其回收了，因此我们需要检查回收是否发生。如果确实被回收，Handler实际上已经与Activity无关了，那么这条消息就应该被丢弃。

虽然这个逻辑解决了内存泄露问题，但仍旧存在一个问题。Activity已经被销毁，但垃圾回收器还没来得及回收引用，依赖于操作系统运行时的状况，这可能会使你的程序导致潜在的崩溃。为解决这个问题，我们需要获取Activity当前的状态。

让我们更新UIHandler的逻辑来解决如上场景的问题：

```
static class UIHandler extends Handler {
    private final WeakReference<ImageFetcherActivity> mActivityRef;
    
    UIHandler(ImageFetcherActivity activity) {
        mActivityRef = new WeakReference(activity);
    }
    
    @Override
    public void handleMessage(Message msg) {
        final ImageFetcherActivity activity = mActivityRef.get();
        if (activity == null || activity.isFinishing() || activity.isDestroyed()) {
            removeCallbacksAndMessages(null);
            return
        }
        
        switch (msg.what) {
            case MSG_SHOW_LOADER: {
                activity.progressIndicator.setVisibility(View.VISIBLE);
                break;
            }
            case MSG_HIDE_LOADER: {
                activity.progressIndicator.setVisibility(View.GONE);
                break;
            }
            case MSG_SHOW_IMAGE: {
                activity.progressIndicator.setVisibility(View.GONE);
                activity.imageView.setImageBitmap((Bitmap) msg.obj);
                break;
            }
        }
    }
}
```

现在，我们可以概括消息队列、Handler、生产线程的交互：


![](https://cdn-images-1.medium.com/max/2000/1*_2pw5528rfoTpPBE7l9NmA.png)

消息队列、Handler、生产线程的交互

在上图中，多个生产线程提交消息到不同的Handler中。然而，不同的Handler都与相同的Looper对象关联，因此所有的消息都加入到同一个消息队列中。这一点非常重要，Android中创建的许多不同Handler都关联到主线程的Looper：

*   _The Choreographer:_ 处理垂直同步与帧更新
*   _The ViewRoot:_ 处理输入和窗口事件，配置修改等等
*   _The InputMethodManager:_ 处理键盘触摸事件及其它

**小贴士:** _确保生产线程不会大量生成消息，因为这可能会抑制处理系统生成消息。_

![](https://cdn-images-1.medium.com/max/2000/1*rvIs3RCqJw1WFwuHwMtgaQ.png)



主线程Looper分发消息的小示例



**调试帮助:** 你可以通过附加一个LogPrinter到Looper上来debug/dump被Looper分发的消息:

    final Looper looper = getMainLooper();
    looper.setMessageLogging(new LogPrinter(Log.DEBUG, "Looper"));

同样地，你可以debug/dump所有在消息队列中等待的消息，通过在与消息队列相关联的Handler上附加一个LogPrinter:

    handler.dump(new LogPrinter(Log.DEBUG, "Handler"), "");

#### Looper

[Looper[5]](https://developer.android.com/reference/android/os/Looper.html) 从消息队列中读取消息，然后分发给对应的Handler处理。一旦消息超过阻塞阈，那么Looper就会在下一轮读取过程中读取到它。Looper在没有消息分发的时候会变为阻塞状态，当有消息可用时会继续开始轮询。

每个线程只能关联一个Looper，给线程附加另外的Looper会导致运行时的异常。通过使用Looper类中的ThreadLocal对象可以保证每个线程只关联一个Looper对象。

调用Looper.quit()方法会立即终止Looper，并且会丢弃消息队列中已经通过阻塞阈的所有消息。调用Looper.quitSafely()方法能够保证所有待分发的消息在列队中等待的消息被丢弃前得到处理。


![](https://cdn-images-1.medium.com/max/1600/1*sNJrg-3mVc54jZfVevWoDg.png)


Handler与消息队列和Looper直接交互的整体流程


Looper应在线程的run方法中初始化。调用静态方法Looper.prepare()会检查线程是否与一个已存在的Looper关联。这个过程的实现是通过Looper类中的ThreadLocal对象来检查Looper对象是否存在。如果Looper不存在，将会创建一个新的Looper对象和一个新的消息队列。[Android代码](https://github.com/android/platform_frameworks_base/blob/e71ecb2c4df15f727f51a0e1b65459f071853e35/core/java/android/os/Looper.java#L83) 中的如下片段展示了这个过程。

**注意:** _公有的prepare方法会默认会调用prepare(true)。_

    private static void prepare(boolean quitAllowed) {
        if (sThreadLocal.get() != null) {
            throw new RuntimeException(“Only one Looper may be created per thread”);
        }
        sThreadLocal.set(new Looper(quitAllowed));
    }

Handler现在能接收到消息并加入消息队列中，执行静态方法Looper.loop()方法会开始将消息从队列中出队。每个轮询迭代器指向下一条消息，接着分发消息到对应目标的Handler，然后回收消息到消息池中。Looper.loop方法会死循环执行这个过程，直到Looper终止。 [Android代码](https://github.com/android/platform_frameworks_base/blob/e71ecb2c4df15f727f51a0e1b65459f071853e35/core/java/android/os/Looper.java#L123) 中的如下片段展示了这个过程：

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

并没有必要自己去创建关联Looper的线程。Android提供了一个简便的类做这件事——HandlerThread。它继承Thread类，并且提供对Looper创建的管理。下面的代码描述了它的一般使用过程：

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

onCreate()方法构造了一个HandlerThread，当HandlerThread启动后，它准备创建Loopper与它的线程关联，随后Looper开始处理HandlerThread的消息队列中的消息。

**注意:** _当Activity被销毁时，结束HandlerThread是很重要的，这个动作也会终止关联的Looper。_

#### 总结

Android中的Handler在应用的生命周期中扮演着不可缺少的角色。它是构成半同步/半异步模式架构的基础。许多内部和外部的代码都依赖Handler去异步地分发事件，它能以最小的代价去维持线程安全。

更深入的理解组件的工作方式能够帮助解决困难问题。这也能让我们以最佳的方法使用组件的API。我们通常将Handler作为工作线程和UI线程间的通信机制，但Handler并不仅限于次。它出现在[IntentService[6]](https://developer.android.com/reference/android/app/IntentService.html), 和 [Camera2[7]](https://developer.android.com/reference/android/hardware/camera2/CameraCaptureSession.html)和许多其它的API中。在这些API调用中，Handler更多情形下是被用作任意线程间的通信工具。

在深入理解了Handler的原理后，我们能运用其构建更有效率、更简洁、更健壮的应用程序。
