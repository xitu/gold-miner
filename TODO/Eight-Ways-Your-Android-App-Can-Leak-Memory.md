>* 原文链接 : [Eight Ways Your Android App Can Leak Memory](http://blog.nimbledroid.com/2016/05/23/memory-leaks.html)
* 原文作者 : [Tom Huzij](http://blog.nimbledroid.com/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


One advantage of a garbage-collecting-language like Java is that it removes the need for developers to explicitly manage allocated memory. This reduces the likelihood of a segmentation fault crashing the app or an unfreed memory allocation bloating the heap, thus creating safer code. Unfortunately, there are other ways that memory can be leaked logically within Java. Ultimately, this means that your Android apps are still susceptible to wasting unnecessary memory and crashing as a result of out-of-memory (OOM) errors.

Traditional memory leaks occur when you neglect to free allocated memory before all related references go out of scope. Logical memory leaks, on the other hand, are the result of forgetting to release references to objects that are no longer needed in your app. If a strong reference to an object still exists, the garbage collector cannot remove the object from memory. This is particularly problematic in Android development if you happen to leak a [Context](http://developer.android.com/reference/android/content/Context.html). This is because Contexts such as [Activities](http://developer.android.com/reference/android/app/Activity.html) contain many references to large amounts of memory, i.e. view hierarchies and other resources. If you leak a Context, you are also leaking everything that it points to. Android mostly runs on mobile devices with limited memory capacity so it’s very likely for your app to run out of available memory if too many leaks take place.

Detecting logical memory leaks would be a subjective matter if the useful lifespan of an object were not clearly defined. Thankfully, activities have very explicitly defined [lifecycles](http://developer.android.com/reference/android/app/Activity.html#ActivityLifecycle) that reveal the point at which we can easily consider an instance of an Activity object to have been leaked.The [onDestroy()](http://developer.android.com/reference/android/app/Activity.html#onDestroy()) method of an Activity is called at end-of-life and indicates that it is being destroyed either through programmer intention or because Android needs to recuperate some memory. If this method completes but the Activity instance can be reached by a chain of strong references from a heap root, then the garbage collector cannot mark it for removal from memory - despite the original intention to delete it. As a result, we can define a leaked Activity object as one that persists beyond its natural lifecycle.

Activities are very hefty objects, so you should never choose to defy the Android framework’s handling of them. However, there are ways that an Activity instance can become unintentionally leaked. In Android, all of the pitfalls that lead to potential memory leaks revolve around two fundamental situations. The first memory-leak-category is caused by a process-global static object that exists regardless of the app’s state and maintains a chain of references to the Activity. The other category is caused when a thread that outlasts the Activity’s lifetime neglects to clear a strong reference chain to that Activity. Let’s examine a few different ways that you might come across these situations.

### 1\. Static Activities

The easiest way to leak an Activity is by defining a static variable inside the class definition of the Activity and then setting it to the running instance of that [Activity](https://github.com/NimbleDroid/Memory-Leaks/blob/master/app/src/main/java/com/nimbledroid/memoryleaks/MainActivity.java#L110). If this reference is not cleared before the Activity’s lifecycle completes, the Activity will be leaked. This is because the object representing the class of the Activity (i.e., MainActivity) is static and remains loaded in memory for the entire runtime of the app. If this class object holds a reference to your Activity instance, it therefore won’t be eligible for garbage collection.



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

<figcaption>Memory Leak 1 - Static Activity</figcaption>


### 2\. Static Views

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

<figcaption>Memory Leak 2 - Static View</figcaption>


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

