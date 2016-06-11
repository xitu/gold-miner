>* 原文链接 : [Eight Ways Your Android App Can Leak Memory](http://blog.nimbledroid.com/2016/05/23/memory-leaks.html)
* 原文作者 : [Tom Huzij](http://blog.nimbledroid.com/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [zhangzhaoqi](https://github.com/joddiy)
* 校对者: 


诸如 JAVA 这样的 GC （垃圾回收）语言的一个好处就是免去了开发者明晰内存分配的必要。这样降低了段错误导致应用奔溃或者未释放的内存挤爆了堆的可能性，也因此产生了更安全的代码。不幸的是，JAVA 里仍然有其他一些方式会导致内存的逻辑泄露。最终，这意味着你的 Android 应用有浪费非必要内存以及导致出现 out-of-memory (OOM) 错误的可能性。

传统的内存泄露发生的时机是：在所有的相关引用不再出现前，你忘记释放内存了。另一方面，逻辑的内存泄漏，是忘记去释放在应用中不再使用的对象引用的结果。如果对象仍然存在强引用（译者注：这里可以去关注下 Android 的弱引用），GC 就无法从内存中回收对象。这尤其在 Android 开发中是个大问题：如果你碰巧泄露了 [Context](http://developer.android.com/reference/android/content/Context.html)。这是因为像 [Activity](http://developer.android.com/reference/android/app/Activity.html) 一样的 Context 持有大量的内存引用，例如：view 层级和其他资源。如果你泄漏了 Context，就意味着你泄漏了它引用的所有东西。Android 应用通常在手机设备中运行在受限内存容器下，如果你的应用泄漏太多内存的话就会导致 out-of-memory (OOM) 错误了。

如果对象的有用存在期没有被明确定义的话，探查逻辑内存泄漏将会变成一件主观的事情。幸好，Activity 明确定义了 [生命周期](http://developer.android.com/reference/android/app/Activity.html#ActivityLifecycle)，使得我们可以简单地知道一个 Activity 对象是否被泄漏了。在 Activity 的生命末期，[onDestroy()](http://developer.android.com/reference/android/app/Activity.html#onDestroy()) 方法被调用来销毁 Activity ，这样做的原因可能是因为程序本身的意愿或者是因为 Android 需要回收一些内存。如果这个方法完成了，但是因为 Activity 的实例被堆根的一个强引用链持有着，那么 GC 就无法标记它为可回收——尽管原本是想删掉它。总之，我们定义了一个超越生命周期存在的泄露的 Activity。

Activity 是非常重的对象，所以你从来就不应该去对抗它里面的 Android 框架的操作。然而，Activity 实例也有一些泄漏是非意愿造成的。在 Android 中，所有的可能导致内存泄漏的陷阱都围绕着两个基本场景。第一个内存泄漏种类是由独立于应用状态存在的全局静态对象对 Activity 的链式引用造成的。另一个种类是由独立于 Activity 生命周期的一个线程持有 Activity 的引用链造成。下面我们来解释一些你可能遇到这些场景的方式。

### 1\. 静态 Activity

泄漏一个 Activity 最简单的方法是：定义 Activity 时在内部当年工艺一个静态变量，然后在运行这个 [Activity](https://github.com/NimbleDroid/Memory-Leaks/blob/master/app/src/main/java/com/nimbledroid/memoryleaks/MainActivity.java#L110) 实例的时候设置它。如果在 Activity 生命周期结束时没有清除引用的话，这个 Activity 就会泄漏。这是因为这个对象表示这个 Activity 类（比如：MainActivity ）是静态的并且在内存中一直保持加载状态。如果这个类对象持有了对 Activity 实例的引用，就不会被选中进行 GC 了。


    void setStaticActivity() {
      activity = this;
    }

    View saButton = findViewById(R.id.sa_button);
    saButton.setOnClickListener(new View.OnClickListener() {
      @Override public void onClick(View v) {
        setStaticActivity();
        nextActivity();
      }
    });



![](http://blog.nimbledroid.com/assets/memory-leaks-imgs/image07.png)

<figcaption>内存泄漏 1 - 静态 Activity</figcaption>


### 2\. 静态 View

A similar situation would be implementing a singleton pattern where an activity might be visited often and it would be beneficial to keep the instance loaded in memory so that it can be restored quickly. However, for reasons stated before, defying the defined lifecycle of an Activity and persisting it in memory is an extremely dangerous and unnecessary practice - and should be avoided at all costs.

But what if we have a particular View that takes a great deal of effort to instantiate but will remain unchanged across different lifetimes of the same Activity? Well then let’s make just that View static after instantiating it and attaching it to the View hierarchy, like we do [here](https://github.com/NimbleDroid/Memory-Leaks/blob/master/app/src/main/java/com/nimbledroid/memoryleaks/MainActivity.java#L132). Now if our Activity is destroyed, we should be able to release most of its memory.



    void setStaticView() {
      view = findViewById(R.id.sv_button);
    }

    View svButton = findViewById(R.id.sv_button);
    svButton.setOnClickListener(new View.OnClickListener() {
      @Override public void onClick(View v) {
        setStaticView();
        nextActivity();
      }
    });



![](http://blog.nimbledroid.com/assets/memory-leaks-imgs/image02.png)

<figcaption>内存泄漏 2 - 静态 View</figcaption>


Wait, what? Surely you knew that an attached View will maintain a reference to its Context, which, in this case, is our Activity. By making a static reference to the View, we’ve created a persistent reference chain to our Activity and leaked it. Don’t make attached Views static and if you must, at least [detach](http://developer.android.com/reference/android/view/ViewGroup.html#removeView(android.view.View)) them from the View hierarchy at some point before the Activity completes.

### 3\. Inner Classes

Moving on, let’s say we define a class inside the definition of our Activity’s class, known as an [Inner Class](https://github.com/NimbleDroid/Memory-Leaks/blob/master/app/src/main/java/com/nimbledroid/memoryleaks/MainActivity.java#L126). The programmer may choose to do this for a number of reasons including increasing readability and encapsulation. What if we create an instance of this Inner Class and maintain a static reference to it? At this point you might as well just guess that a memory leak is imminent.



    void createInnerClass() {
        class InnerClass {
        }
        inner = new InnerClass();
    }

    View icButton = findViewById(R.id.ic_button);
    icButton.setOnClickListener(new View.OnClickListener() {
        @Override public void onClick(View v) {
            createInnerClass();
            nextActivity();
        }
    });



![](http://blog.nimbledroid.com/assets/memory-leaks-imgs/image03.png)

<figcaption>Memory Leak 3 - Inner Class</figcaption>

Unfortunately because one of the benefits of Inner Class instances is that they have access to their Outer Class’s variables, they must maintain a reference to the Outer Class’s instance which causes our Activity to be leaked.

### 4\. Anonymous Classes

Similarly, Anonymous Classes will also maintain a reference to the class that they were declared inside. Therefore a leak can occur if you [declare and instantiate an AsyncTask anonymously inside your Activity](https://github.com/NimbleDroid/Memory-Leaks/blob/master/app/src/main/java/com/nimbledroid/memoryleaks/MainActivity.java#L102). If it continues to perform background work after the Activity has been destroyed, the reference to the Activity will persist and it won’t be garbage collected until after the background task completes.



    void startAsyncTask() {
        new AsyncTask<void, void,="" void="">() {
            @Override protected Void doInBackground(Void... params) {
                while(true);
            }
        }.execute();
    }

    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);
    View aicButton = findViewById(R.id.at_button);
    aicButton.setOnClickListener(new View.OnClickListener() {
        @Override public void onClick(View v) {
            startAsyncTask();
            nextActivity();
        }
    });</void,>



![](http://blog.nimbledroid.com/assets/memory-leaks-imgs/image04.png)

<figcaption>Memory Leak 4 - AsyncTask</figcaption>

### 5\. Handlers

The very same principle applies to background tasks [declared anonymously by a Runnable object and queued up for execution by a Handler object](https://github.com/NimbleDroid/Memory-Leaks/blob/master/app/src/main/java/com/nimbledroid/memoryleaks/MainActivity.java#L114). The Runnable object will implicitly reference the Activity it was declared in and will then be posted as a Message on the Handler’s MessageQueue. As long as the message hasn’t been handled before the Activity is destroyed, the chain of references will keep the Activity live in memory and will cause a leak.



    void createHandler() {
        new Handler() {
            @Override public void handleMessage(Message message) {
                super.handleMessage(message);
            }
        }.postDelayed(new Runnable() {
            @Override public void run() {
                while(true);
            }
        }, Long.MAX_VALUE >> 1);
    }

    View hButton = findViewById(R.id.h_button);
    hButton.setOnClickListener(new View.OnClickListener() {
        @Override public void onClick(View v) {
            createHandler();
            nextActivity();
        }
    });



![](http://blog.nimbledroid.com/assets/memory-leaks-imgs/image01.png)

<figcaption>Memory Leak 5 - Handler</figcaption>

### 6\. Threads

We can repeat this same mistake again with both the [Thread](https://github.com/NimbleDroid/Memory-Leaks/blob/master/app/src/main/java/com/nimbledroid/memoryleaks/MainActivity.java#L142) and [TimerTask](https://github.com/NimbleDroid/Memory-Leaks/blob/master/app/src/main/java/com/nimbledroid/memoryleaks/MainActivity.java#L150) classes.



    void spawnThread() {
        new Thread() {
            @Override public void run() {
                while(true);
            }
        }.start();
    }

    View tButton = findViewById(R.id.t_button);
    tButton.setOnClickListener(new View.OnClickListener() {
      @Override public void onClick(View v) {
          spawnThread();
          nextActivity();
      }
    });



![](http://blog.nimbledroid.com/assets/memory-leaks-imgs/image06.png)

<figcaption>Memory Leak 6 - Thread</figcaption>

### 7\. Timer Tasks

As long as they are declared and instantiated anonymously, despite the work occurring in a separate thread, they will persist a reference chain to the Activity after it has been destroyed and will yet again cause a leak.



    void scheduleTimer() {
        new Timer().schedule(new TimerTask() {
            @Override
            public void run() {
                while(true);
            }
        }, Long.MAX_VALUE >> 1);
    }

    View ttButton = findViewById(R.id.tt_button);
    ttButton.setOnClickListener(new View.OnClickListener() {
        @Override public void onClick(View v) {
            scheduleTimer();
            nextActivity();
        }
    });



![](http://blog.nimbledroid.com/assets/memory-leaks-imgs/image06.png)

<figcaption>Memory Leak 7 - TimerTask</figcaption>

### 8\. Sensor Manager

Finally, there are system services that can be retrieved by a Context with a call to [getSystemService](http://developer.android.com/reference/android/content/Context.html#getSystemService(java.lang.String)). These Services run in their own processes and assist applications by performing some sort of background work or interfacing to the device’s hardware capabilities. If the Context want to be notified every time an event occurs inside a Service, it needs to register itself as a [listener](https://github.com/NimbleDroid/Memory-Leaks/blob/master/app/src/main/java/com/nimbledroid/memoryleaks/MainActivity.java#L136). However, this will cause the Service to maintain a reference to the Activity, and if the programmer neglects to unregister the Activity as a listener before the Activity is destroyed it will be ineligible for garbage collection and leak will occur.



    void registerListener() {
           SensorManager sensorManager = (SensorManager) getSystemService(SENSOR_SERVICE);
           Sensor sensor = sensorManager.getDefaultSensor(Sensor.TYPE_ALL);
           sensorManager.registerListener(this, sensor, SensorManager.SENSOR_DELAY_FASTEST);
    }

    View smButton = findViewById(R.id.sm_button);
    smButton.setOnClickListener(new View.OnClickListener() {
        @Override public void onClick(View v) {
            registerListener();
            nextActivity();
        }
    });



![](http://blog.nimbledroid.com/assets/memory-leaks-imgs/image00.png)

<figcaption>Memory Leak 8 - Sensor Manager</figcaption>

Now that you’ve seen an array of various memory leaks you can see just how easy it is to accidentally leak a massive amount of memory. Remember, although in the worst case this will cause your app to run out of memory and crash, it might not necessarily always do this. Instead, it can eat up a large but non-lethal amount of your app’s memory space. In this case, the app has less memory to allocate for other objects and thus your garbage collector will need to run more often to free up space for new objects. Garbage collection is a very expensive operation and will cause noticeable slowdown for the user. Stay aware of potential reference chains when instantiating objects in your Activities and test for memory leaks often!

Correction: Due to an editing error, this article originally mistakenly referred to the Activity’s end-of-lifecycle method as onDelete(). The correct method is onDestroy(). Thanks to [@whoisgraham](https://twitter.com/whoisgraham/status/734993947014115328) for pointing that out.</div>

