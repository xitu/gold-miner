> * 原文地址：[Finally understanding how references work in Android and Java](https://medium.com/google-developer-experts/finally-understanding-how-references-work-in-android-and-java-26a0d9c92f83#.x1m4ykp6m)
* 原文作者：[Enrique López Mañas](https://medium.com/@enriquelopezmanas)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Finally understanding how references work in Android and Java
A few weeks ago I attended [Mobiconf](http://2016.mobiconf.org/), one of the best conferences for Mobile Developers I had the pleasure to attend in Poland. During his eclectic presentation “The best (good) practices”, my friend and colleague [Jorge Barroso](https://github.com/flipper83) came up with a statement that made me reflect after hearing it:

> If you are an Android developer and you do not use WeakReferences, you have a problem.

On an example of good timing, a couple of months ago I did publish my last book, “[Android High Performance](https://goo.gl/DLyeXN)”, co-authored with [Diego Grancini](https://www.linkedin.com/in/diegograncini). One of the most passionate chapters is the one talking about Memory Management in Android. In this chapter, we talk about how the memory works in a mobile device, how memory leaks happen, why this is important and which techniques we can apply to avoid them. Since I did start developing for Android, I have always observed a tendency to involuntarily avoid or give a low priority to everything related with memory leaks and memory management. If the functional criteria are fulfilled, why bothering? We are always in a rush to develop new features, and we would rather present something visual in our next Sprint demo rather than caring about something that nobody will see at a first glance.

Is a nice argument, which irrevocably leads to acquiring [technical debt](https://en.wikipedia.org/wiki/Technical_debt). I would even add that the technical debt has also some effects in the real world that we cannot measure with unit tests: disappointment, friction among fellow developers, low quality software shipped and loss of motivation. The reason why this effects are difficult to measure is because often they happen in the long term. It occurs a little bit like with politicians: if I am only going to be in charge for 8 years, why would I bother about what happens in 12? Except that in Software Development everything moves way faster.

Writing about the decent and proper mindset to adopt in Software Development could require a few volumes, and there are already many books and articles that you can explore. However, explaining briefly the different types of memory references, what do they mean and how can they be applied in Android will be a briefer task, and this is what I want to do in this article.

First of all: what is a reference in Java?

> A reference is the direction of an object that is annotated, so you can access it.

Java has by default 4 types of references: **strong**, **soft**, **weak** and **phantom**. Some people argue that there are just two types of references, strong and weak, and the weak references can present 2 degrees of weakness. We tend to classify everything in life with the taxonomic perseverance of a botanist. Whatever it works better for you, but first you do need to understand them. Then you can figure out your own classification.

What does each type of reference mean?

**Strong reference:** strong references are the ordinary references in Java. Anytime we create a new object, a strong reference is by default created. For example, when we do:

    MyObject object = new MyObject();

A new object _MyObject_ is created, and a strong reference to it is stored in _object_. Easy so far, are you still with me? Well, now more interesting things are coming. This _object_ is **strongly reachable** — that means, it can be reached through a chain of strong references. That will prevent the Garbage Collector of picking it up and destroy it, which is what we mostly want. But now, let´s see an example where this can play against us.

    public class MainActivity extends Activity {
        @Override
        protected void onCreate(Bundle savedInstanceState) {   
            super.onCreate(savedInstanceState);
            setContentView(R.layout.main);
            new MyAsyncTask().execute();
        }

        private class MyAsyncTask extends AsyncTask {
            @Override
            protected Object doInBackground(Object[] params) {
                return doSomeStuff();
            }
            private Object doSomeStuff() {
                //do something to get result
                return new MyObject();
            } 
        }
        }

Take a few minutes and try to spot any approach susceptible of problems.

No worries, take more time if you can´t.

Now?

The _AsyncTask_ will be created and executed together with the _Activity_ _onCreate()_ method. But here we have a problem: the inner class needs to be accessing the outside class during its entire lifetime.

What happens when the _Activity_ is destroyed? The _AsyncTask_ is holding a reference to the _Activity_, and the _Activity_ cannot be collected by the GC. This is what we called a memory leak.

> **Side note**: when in my previous lifes I used to conduct interviews with prospective candidates, I used to ask them how could you create a memory leak rather than asking about the theoretical aspect of what a memory leak is. It was always much more fun!

The memory leak actually happens not only when the _Activity_ is destroyed _per-se_, but as well when it is forcibly destroyed by the system due to a change in the configuration or more memory is needed, etc. If the _AsyncTask_ is complex (i.e., keeps references to _Views_ in the _Activity_, etc) it could even lead to crashes, since the view references are null.

So how can prevent this problem from ever happening again? Let´s explain the other type of references:

**WeakReference**: a weak reference is a reference not strong enough to keep the object in memory. If we try to determine if the object is strongly referenced and it happened to be through _WeakReferences_, the object will be garbage-collected. For terms of understanding, is better to kill the theory and show as a practical example how could we adapt the previous code to use a _WeakReference_ and avoid a memory leak:

    public class MainActivity extends Activity {
        @Override
        protected void onCreate(Bundle savedInstanceState) {
            super.onCreate(savedInstanceState);
            new MyAsyncTask(this).execute();
         }
        private static class MyAsyncTask extends AsyncTask {
            private WeakReference mainActivity;    

            public MyAsyncTask(MainActivity mainActivity) {   
                this.mainActivity = new WeakReference<>(mainActivity);            
            }
            @Override
            protected Object doInBackground(Object[] params) {
                return doSomeStuff();
            }
            private Object doSomeStuff() {
                //do something to get result
                return new Object();
            }
            @Override
            protected void onPostExecute(Object object) {
                super.onPostExecute(object);
                if (mainActivity.get() != null){
                    //adapt contents
                }
            }
        }
        }

Note a main difference now: the Activity within the inner class is now referenced as follows:

    private WeakReference mainActivity;

What will happen here? When the Activity stops existing, since it is hold through the means of a WeakReference, it can be collected. Therefore no memory leaks will happen.

> **Side note:** now that you hopefully understand what WeakReferences are a little bit better, you will find useful the class WeakHashMap. It works exactly as a HashMap, except that the keys (key, not values) are referred to using WeakReferences. This makes them very useful to implement entities such as caches.

We have mentioned however a couple of references more. Let´s see where they are useful, and how we can benefit of them:

**SoftReference**: think of a _SoftReference_ as a stronger _WeakReference_. Whereas a _WeakReference_ will be collected immediately, a _SoftReference_ will beg to the GC to stay in memory unless there is no other option. The [Garbage Collector algorithms](https://plumbr.eu/handbook/garbage-collection-algorithms-implementations) are really thrilling and something you can dive in for hours and hours without getting tired. But basically, they say _“I will always reclaim the WeakReference. If the object is a SoftReference, I will decide what to do based on the ecosystem conditions”_. This makes a _SoftReference_ very useful for the implementation of a cache: as long as the memory is plenty, we do not have to worry of manually removing objects. If you want to see an example in action, you can check [this example](http://peters-andoird-blog.blogspot.de/2012/05/softreference-cache.html) of a cache implemented with _SoftReference_.

**PhantomReference**: Ah, PhantomReferences! I think I can count on the fingers of one hand how often I saw them used in a production environment. An Object that has only being referenced through a PhantomReference them can be collected whenever the Garbage Collector wants. No further explanations, no “call me back”. This makes it hard to characterise. Why would we like to use such a thing? Are the other ones not problematic enough? Why did I choose to be a programmer? PhantomReference can be used exactly to detect when an object has been removed from memory. Being fully transparent, I recall two occasions when I had to use a PhantomReference in my entire professional career. So do not get stressed if they are hard to understand now.

Hope this has clear a little bit the idea you previously had about references. As in any matter of learning, you might want to start to [be practical](https://medium.com/@enriquelopezmanas/the-theoretical-animal-4f6901aaf571#.5nocvfu4m) and play around with your code and see how can you improve it. A first step would be to see if you are having any memory leak, and see if you can use any of the lessons learned here to get rid of those nasty memory leaks. If you have liked this article or it did help you, feel free to share and/or leave a comment. That is the currency that fuels amateur writers.

Thanks to my colleague [Sebastian](https://twitter.com/semuvex) for his input on the article!