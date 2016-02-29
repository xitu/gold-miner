* 原文链接 : [Using concurrency to improve speed and performance in Android](https://medium.com/@ali.muzaffar/using-concurrency-and-speed-and-performance-on-android-d00ab4c5c8e3#.rt9z1k25u)
* 原文作者 : [Ali Muzaffar](https://medium.com/@ali.muzaffar)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:
* 状态 : 待认领

![](http://ww1.sinaimg.cn/large/9b5c8bd8jw1f1cvbu9fzaj20m80fj48q.jpg)

#### The Android framework provides great utility classes for asynchronous processing. However, most of them queue up on a single background thread. What do you do when you need more threads?

It is well known that all UI updates in Android happen on the UI thread (also known as the main thread). Any operations on this thread will block UI updates and so AsyncTask, IntentService and Threads are used when heavy computation is needed. As a matter of fact, I wrote on at least [8 ways to do asynchronous processing in Android](https://medium.com/android-news/8-ways-to-do-asynchronous-processing-in-android-and-counting-f634dc6fae4e#.bkk6mudb4) not too long ago. However, [AsyncTasks](http://developer.android.com/reference/android/os/AsyncTask.html) in Android are executed on a single background thread and the same is true for [IntentService](http://developer.android.com/reference/android/os/AsyncTask.html). So, what is a developer to do?

**Update:** As [Marco Kotz](https://medium.com/u/b49242be2be7) [points out](https://medium.com/@mrcktz/hi-ali-nice-article-thanks-for-sharing-ba72b07f1fb3), you can use a ThreadPool Executor with AsyncTask so that more than one background thread can be used by your AsyncTasks.

### What most developers do

In most scenarios, you do not have to spawn multiple threads, simply spinning off AsyncTasks or queuing operations for IntentService is more than enough. However, when you truly needs multiple threads, more often than not, I've seen developers simply spin-off plain old Threads.

    String[] urls = …
    for (final String url : urls) {
        new Thread(new Runnable() {
            public void run() {
                //Make API call or, download data or download image
            }
        }).start();
    }

There are a few problems with this approach. For one thing, the operating system limits the number of connections to the same domain to (I believe) four. Which means, this code is not really doing what you think it is doing. It created threads that have to wait on other threads to complete before they can begin their operation. Also, each thread is being created, used to perform a task, and then destroyed. There is no reuse.

### Why is this a problem?

Lets say for example that you want to develop a burst shooting app that takes 10 shots a second from the Camera preview (or more). The features of the app could be something as follows:

*   Capture 10 shots in the form of byte[], in a second without blocking the UI.
*   Convert each byte[] from the YUV format to RGB format.
*   Create a Bitmap from the converted array.
*   Fix orientation of the bitmap.
*   Generate a thumbnail size bitmap.
*   Write full size bitmap to disk as a compressed Jpeg.
*   Queue full size image for upload to the server.

Understandably, if you did all of this on the main UI thread. You would not get a lot of performance out of your app. The only way you would stand a chance would be to cache the camera preview data and process it while the UI is idle.

An alternative might be to create a long running HandlerThread that can be used to receive your camera preview on a background thread and do all of this processing. While this would work better, there would be too much of a delay between subsequent burst shots because of all the processing required.

    public class CameraHandlerThread extends HandlerThread
            implements Camera.PictureCallback, Camera.PreviewCallback {
        private static String TAG = "CameraHandlerThread";
       private static final int WHAT_PROCESS_IMAGE = 0;

        Handler mHandler = null;
        WeakReference<camerapreviewfragment> ref = null;

        private PictureUploadHandlerThread mPictureUploadThread;
        private boolean mBurst = false;
        private int mCounter = 1;

        CameraHandlerThread(CameraPreviewFragment cameraPreview) {
            super(TAG);
            start();
            mHandler = new Handler(getLooper(), new Handler.Callback() {

                @Override
                public boolean handleMessage(Message msg) {
                    if (msg.what == WHAT_PROCESS_IMAGE) {
                        //Do everything
                    }
                    return true;
                }
            });
            ref = new WeakReference<>(cameraPreview);
        }

       ...

        @Override
        public void onPreviewFrame(byte[] data, Camera camera) {
            if (mBurst) {
                CameraPreviewFragment f = ref.get();
                if (f != null) {
                    mHandler.obtainMessage(WHAT_PROCESS_IMAGE, data)
                   .sendToTarget();
                    try {
                        sleep(100);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                    if (f.isAdded()) {
                        f.readyForPicture();
                    }
                }
                if (mCounter++ == 10) {
                    mBurst = false;
                    mCounter = 1;
                }
            }
        }
    }

**Note:** If you need to learn more above HandlerThreads and how to use them, be sure to [read my post on HandlerThreads](https://medium.com/@ali.muzaffar/handlerthreads-and-why-you-should-be-using-them-in-your-android-apps-dc8bf1540341#.co4ilm67m).

Since everything is being done on one background Thread, our main performance benefit here is that our Thread is long running and isn’t being destroyed and recreated. However, the thread is being shared by a lot of expensive operations which is can only do in a linear manner.

We could create a second HandlerThread to process our images and a third to write them to the disk and a fourth to perform our upload to the server. We would be able to take pictures faster, however, these threads would still be dependant on each other in a linear manner. There is no true concurrency. We would be able to take pictures faster, however, because of the time required to process each image, the users would still perceive a big a lag between when they click a button and the thumbnails are displayed.

### Using a ThreadPool to improve the situation

While we could just spin off a lot of threads as needed, there is a time cost associated with creating a thread and destroying it. We also, do not want to create more threads than we need and want to make full use of our available hardware. Too many threads can affect the performance by eating up CPU cycles. The solution is to use a ThreadPool.

Creating a ThreadPool for use in your app is straight forward, start by creating a Singleton which will represent your ThreadPool.

    public class BitmapThreadPool {
        private static BitmapThreadPool mInstance;
        private ThreadPoolExecutor mThreadPoolExec;
        private static int MAX_POOL_SIZE;
        private static final int KEEP_ALIVE = 10;
        BlockingQueue<runnable> workQueue = new LinkedBlockingQueue<>();

        public static synchronized void post(Runnable runnable) {
            if (mInstance == null) {
                mInstance = new BitmapThreadPool();
            }
            mInstance.mThreadPoolExec.execute(runnable);
        }

        private BitmapThreadPool() {
            int coreNum = Runtime.getRuntime().availableProcessors();
            MAX_POOL_SIZE = coreNum * 2;
            mThreadPoolExec = new ThreadPoolExecutor(
                    coreNum,
                    MAX_POOL_SIZE,
                    KEEP_ALIVE,
                    TimeUnit.SECONDS,
                    workQueue);
        }

        public static void finish() {
            mInstance.mThreadPoolExec.shutdown();
        }
    }

Then in the code above, simply change the Handler callback to:

    mHandler = new Handler(getLooper(), new Handler.Callback() {

        @Override
        public boolean handleMessage(Message msg) {
            if (msg.what == WHAT_PROCESS_IMAGE) {
                BitmapThreadPool.post(new Runnable() {
                    @Override
                    public void run() {
                        //do everything
                    }
                });
            }
            return true;
        }
    });

That’s it! The performance improvement will be noticeable, just look at the videos below!

The advantage here is that we can define our pool size and even specify how long to keep threads around before reclaiming them. We can also create different ThreadPools for different operations or use one ThreadPool for many. Just be careful to clean up properly when you’re done with the threads.

We can even create ThreadPools that specialize in various jobs, one ThreadPool to convert the data to Bitmaps, one to write the data out to disk and a third to upload the Bitmaps to the server. In doing so, if our ThreadPool has a max of 4 threads, we can convert, write and upload 4 images at a time instead of just one. The user will see 4 images show up at a time rather than one.

The above is a simplified example, however, the [full code for my project is on GitHub](https://github.com/alphamu/ThreadPoolWithCameraPreview) and you can take a look and give me some feedback.

You can also [check out the demo app on Google Play](https://play.google.com/store/apps/details?id=au.com.alphamu.camerapreviewcaptureimage).

**Before implementing ThreadPool:** If you can, follow the timer on top of the screen as the thumbnails begin the show up at the bottom. Since I’ve taken all operations except the notifyDataSetChanged() on the adapter off the main thread, the counter should continue to run smoothly.

<figure><iframe frameborder="0" allowfullscreen="1" title="YouTube video player" width="640" height="360" src="https://www.youtube.com/embed/YmU8ogom_5g?wmode=opaque&amp;widget_referrer=https%3A%2F%2Fmedium.com%2Fmedia%2F6a9266d6d49e3e234f9d60f5763602df%3FmaxWidth%3D640&amp;enablejsapi=1&amp;origin=https%3A%2F%2Fcdn.embedly.com"></iframe></figure>

**After implementing ThreadPool:** The counter on top of the screen should still run smoothly, however, image thumbnails are showing up a lot faster.

<figure><iframe frameborder="0" allowfullscreen="1" title="YouTube video player" width="640" height="360" src="https://www.youtube.com/embed/77Lh9XpXArw?wmode=opaque&amp;widget_referrer=https%3A%2F%2Fmedium.com%2Fmedia%2F53c35a233037c20ad1c4f2cba7528580%3FmaxWidth%3D640&amp;enablejsapi=1&amp;origin=https%3A%2F%2Fcdn.embedly.com"></iframe></figure>

### Finally

In order to build great Android apps, [read more of my articles](https://medium.com/@ali.muzaffar).

Yay! you made it to the end! We should hang out! feel free to follow me on Medium, [LinkedIn](https://www.linkedin.com/in/alimuzaffar), [Google+](https://plus.google.com/+AliMuzaffar) or [Twitter](https://twitter.com/ali_muzaffar).
