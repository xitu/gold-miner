>* 原文链接 : [Eight Ways Your Android App Can Leak Memory](http://blog.nimbledroid.com/2016/05/23/memory-leaks.html)
* 原文作者 : [Tom Huzij](http://blog.nimbledroid.com/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [zhangzhaoqi](https://github.com/joddiy)
* 校对者: [Jasper Zhong](https://github.com/DeadLion)，[江湖迈杰](https://github.com/MiJack)

# 八个造成 Android 应用内存泄露的原因

诸如 Java 这样的 GC （垃圾回收）语言的一个好处就是免去了开发者管理内存分配的必要。这样降低了段错误导致应用崩溃或者未释放的内存挤爆了堆的可能性，因此也能编写更安全的代码。不幸的是，Java 里仍有一些其他的方式会导致内存“合理”地泄露。最终，这意味着你的 Android 应用可能会浪费一些非必要内存，甚至出现 out-of-memory (OOM) 错误。

传统的内存泄露发生的时机是：所有的相关引用已不在域范围内，你忘记释放内存了。另一方面，逻辑内存的泄漏，是忘记去释放在应用中不再使用的对象引用的结果。如果对象仍然存在强引用（译者注：这里可以去关注下 Java 的弱引用），GC 就无法从内存中回收对象。这在 Android 开发中尤其是个大问题：如果你碰巧泄露了 [Context](http://developer.android.com/reference/android/content/Context.html)。这是因为像 [Activity](http://developer.android.com/reference/android/app/Activity.html) 一样的 Context 持有大量的内存引用，例如：view 层级和其他资源。如果你泄漏了 Context，就意味着你泄漏了它引用的所有东西。Android 应用通常运行在内存受限的手机设备中，如果你的应用泄漏太多内存的话就会导致 out-of-memory (OOM) 错误。

如果对象的有用存在期没有被明确定义的话，探查逻辑内存泄漏将会变成一件很主观的事情。幸好，Activity 明确定义了 [生命周期](http://developer.android.com/reference/android/app/Activity.html#ActivityLifecycle)，使得我们可以简单地知道一个 Activity 对象是否被泄漏了。在 Activity 的生命末期，[onDestroy()](http://developer.android.com/reference/android/app/Activity.html#onDestroy()) 方法被调用来销毁 Activity ，这样做的原因可能是程序本身的意愿或者是 Android 需要回收一些内存。如果这个方法完成了，但是 Activity 的实例被堆根的一个强引用链持有着，那么 GC 就无法标记它为可回收 —— 尽管原本是想删掉它。因此，我们可以将一个泄露的 Activity 对象定义为一个超过其自然生命周期的对象。

Activity 是非常重的对象，所以你从来就不应该选择无视 Android 框架对它们的处理。然而，Activity 实例也有一些泄漏是非意愿造成的。在 Android 中，所有的可能导致内存泄漏的陷阱都围绕着两个基本场景：第一个是由独立于应用状态存在的全局静态对象对 Activity 的链式引用造成的；另一个是由独立于 Activity 生命周期的一个线程持有 Activity 的引用链造成。下面我们来解释一些你可能遇到这些场景的方式。

### 1\. 静态 Activity

泄漏一个 Activity 最简单的方法是：定义 Activity 时在内部定义一个静态变量，并将其值设置为处于运行状态的 [Activity](https://github.com/NimbleDroid/Memory-Leaks/blob/master/app/src/main/java/com/nimbledroid/memoryleaks/MainActivity.java#L110) 。如果在 Activity 生命周期结束时没有清除引用的话，这个 Activity 就会泄漏。这是因为这个对象表示这个 Activity 类（比如：MainActivity ）是静态的并且在内存中一直保持加载状态。如果这个类对象持有了对 Activity 实例的引用，就不会被选中进行 GC 了。



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

一个相似的情况是：对于经常访问到的 Activity 实现了单例模式，并且保持它的实例在内存中的加载状态使之有利于快速读写。然而，正如刚才提到的原因，违背了 Activity 既定的生命周期并且在内存中长久存在是一件极其危险和不必要的实践 —— 并且应该被完全禁止。

但是假如我们有一个特定的 View ：花费极大的代价来初始化，但是在同一个 Activity 的不同生命时间内没怎么变化过，我们该怎么办呢？我们可以简单地在初始化后就把这个 View 设为静态的，然后附加到 View 的层次关系中，就像我们在[这里](https://github.com/NimbleDroid/Memory-Leaks/blob/master/app/src/main/java/com/nimbledroid/memoryleaks/MainActivity.java#L132)做的。现在假如 Activity 被销毁了，我们应该可以释放它占用的大部分内存。



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


稍等，有一点奇怪的地方。正如你知道的，在这种情况下，我们的 Activity 中，一个被附加的 View 会持有对它的 Context 的引用。通过使用一个 View 的静态引用，我们给 Activity 设定了一个持久化的引用链并且泄露了它。不要使附加的 View 静态化，如果你必须这么做的话，至少让它们在 Activity 完成之前从 View 层级关系的同一点上[分离](http://developer.android.com/reference/android/view/ViewGroup.html#removeView(android.view.View))出来。

### 3\. 内部类

继续，让我们讨论下在 Activity 类中定义一个[内部类](https://github.com/NimbleDroid/Memory-Leaks/blob/master/app/src/main/java/com/nimbledroid/memoryleaks/MainActivity.java#L126)的情况。程序员一般选择这样做是有一些原因的，诸如提升可靠性和封装性等。假如我们创建了一个内部类的实例然后对其持有了一个静态引用呢？你肯定猜到了必然会发生内存泄漏。



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

<figcaption>内存泄漏 3 - 内部类</figcaption>

不幸的是，因为内部类的一个特性是它们可以访问外部类的变量，所以它们必然持有了对外部类实例的引用以至于 Activity 会发生泄漏。

### 4\. 匿名类

同样的，匿名类同样持有了内部定义的类的引用。因此如果你[在 Activity 中匿名地声明并且实例化了一个 AsyncTask](https://github.com/NimbleDroid/Memory-Leaks/blob/master/app/src/main/java/com/nimbledroid/memoryleaks/MainActivity.java#L102)的话就会发生泄漏。如果在 Activity 销毁后它仍在后台工作的话，对于 Activity 的引用会持续并且直到后台工作完成才会进行 GC。



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

<figcaption>内存泄漏 4 - AsyncTask</figcaption>

### 5\. Handler

相同的情况同样适用于这样的[后台任务](https://github.com/NimbleDroid/Memory-Leaks/blob/master/app/src/main/java/com/nimbledroid/memoryleaks/MainActivity.java#L114)：被一个 Runnable 对象定义并被一个 Handler 对象加入执行队列。这个 Runnable 对象将会隐式地引用定义它的 Activity 然后会作为 Message 提交到 Handler 的 MessageQueue（消息队列）。只要 Activity 销毁前消息还没有被处理，那么引用链就会使 Activity 保留在内存里并导致泄漏。



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

<figcaption>内存泄漏 5 - Handler</figcaption>

### 6\. Thread

我们在使用 [Thread](https://github.com/NimbleDroid/Memory-Leaks/blob/master/app/src/main/java/com/nimbledroid/memoryleaks/MainActivity.java#L142) 和 [TimerTask](https://github.com/NimbleDroid/Memory-Leaks/blob/master/app/src/main/java/com/nimbledroid/memoryleaks/MainActivity.java#L150) 时，可能会犯同样的错误。



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

<figcaption>内存泄漏 6 - Thread</figcaption>

### 7\. TimerTask

只要 TimerTask 被定义并且匿名实例化，即使任务执行在独立的线程里，它们也会在 Activity 销毁后保持对其的引用链，从而导致泄漏。



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

<figcaption>内存泄漏 7 - TimerTask</figcaption>

### 8\. SensorManager

最后，有一些 Context 可以通过调用 [getSystemService](http://developer.android.com/reference/android/content/Context.html#getSystemService(java.lang.String)) 来检索的系统服务。这些服务运行在它们独立的线程，辅助应用去与硬件设备进行接口通讯。如果 Context 想要时刻监听到 Service 中发生的事件，它就需要注册自己为 [Listener](https://github.com/NimbleDroid/Memory-Leaks/blob/master/app/src/main/java/com/nimbledroid/memoryleaks/MainActivity.java#L136)。然而，这将会造成 Service 持有 Activity 的引用，如果在 Activity 销毁前忘记注销作为 Listener 的 Activity 的话，GC 就无法回收从而导致泄漏。



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

<figcaption>内存泄漏 8 - SensorManager</figcaption>

现在你已经见识了这么多内存泄漏的情况，一不留神就泄漏大量内存实在是太容易发生了。记住，尽管最严重的内存泄漏情况才会造成应用内存溢出并崩溃，但并不总会发生这样的情况，取而代之的是，这将浪费应用大量内存空间。在这种情况下，应用给其他对象的可分配内存就少了，然后你的 GC 就不得不时常为新对象释放空间。GC 是代价很大的操作并会让用户感到速度下降。当你在 Activity 中初始化对象的时候，留心潜在的引用链，并且经常测试内存泄漏！

修改：由于一些编辑错误，这篇文章中涉及 Activity 结束生命周期的方法原本是 onDelete()，正确的应该是 onDestroy()，感谢 [@whoisgraham](https://twitter.com/whoisgraham/status/734993947014115328) 指出了这个错误。

