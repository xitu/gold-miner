> * 原文地址：[Multithreading with RxJava](https://android.jlelse.eu/multithreading-with-rxjava-dadddc4f7a63#.yghtx4u43)
> * 原文作者：[Pierce Zaifman](https://android.jlelse.eu/@PierceZaifman?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# Multithreading with RxJava #

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/2000/1*PD7aznI_MSxRwXI37a7mtg.jpeg">

Most of the code I’ve ever written for Android is fast enough that speed has never been a concern. Until a few weeks ago when I was working on an app that reads and analyzes large files.

While I expect users to understand that a larger file will take longer to process, at some point they will give up on my app. Either because they think the app isn’t working, or they simply aren’t willing to wait that long. So if I can cut that time in half or less, it’s certainly worth doing.

#### First attempt ####

Since I’ve been using RxJava for all of my background jobs, it made sense to try to do the same for this. Essentially I have some code that looks like this:

```
List<String> dataList;
//dataList gets populated here

List<DataModel> result = new ArrayList<>();
for (String data : dataList) {
    result.add(DataParser.createData(data));
}
```

So, I just tried to stick each iteration of the loop into a background thread. You can see what I did below:

```
List<String> dataList;
//dataList gets populated here

List<Observable<DataModel>> tasks = new ArrayList<>();

for (String data : dataList) {
    tasks.add(Observable.just(data).subscribeOn(Schedulers.io()).map(s -> {
        // returns a DataModel object
        return DataParser.createData(s);
    }));
}

List<DataModel> result = new ArrayList<>();

// Wait for everything to finish and collect the results
for (DataModel dataModel : Observable.merge(tasks).toBlocking().toIterable()) {
    result.add(dataModel);
}
```

It did speed it up, it was running in about half the time. But, it was causing a lot of garbage collection (GC), which made the UI very stuttery and janky while it was loading. To try to understand what was happening, I added a log to print out `Thread.currentThread().getName()`. This made me realize that I was actually spawning a new thread for each piece of data. As it turns out, spawning thousands of threads is not a good idea.

#### Second attempt ####

I’ve already accomplished my goal of speeding up the data processing, but it’s not running very smoothly. I was also wondering if it could run even faster if it didn’t cause so much GC. So instead of spawning a new thread, I created my own limited thread pool for RxJava to use:

```
List<String> dataList;
//dataList gets populated here

List<Observable<DataModel>> tasks = new ArrayList<>();

// Get the max number of threads we could have
int threadCount = Runtime.getRuntime().availableProcessors();
ExecutorService threadPoolExecutor = Executors.newFixedThreadPool(threadCount);
Scheduler scheduler = Schedulers.from(threadPoolExecutor);

for (String data : dataList) {
    tasks.add(Observable.just(data).subscribeOn(scheduler).map(s -> {
        // returns a DataModel object
        return DataParser.createData(s);
    }));
}

List<DataModel> result = new ArrayList<>();

// Wait for everything to finish and collect the results
for (DataModel dataModel : Observable.merge(tasks).toBlocking().toIterable()) {
    result.add(dataModel);
}
```

For a dataset where each piece of data was quite large, this resulted in a further time savings of roughly 10%. However, for a dataset where each piece of data was small, it reduced the processing time by roughly 30%. It also reduced the number of GC calls, but there were still too many.

#### Third attempt ####

I had one more idea — what if the overhead of managing and switching threads was slowing it down? To get around this, I could group my data into one sublist per thread. That way it would still run in parallel, but the management of each thread would be minimal. I adapted the solution [here](https://github.com/ReactiveX/RxJava/issues/3532#issuecomment-157509946)  to implement this idea:

```
List<String> dataList;
//dataList gets populated here


// Get the max number of threads we could have
int threadCount = Runtime.getRuntime().availableProcessors();
ExecutorService threadPoolExecutor = Executors.newFixedThreadPool(threadCount);
Scheduler scheduler = Schedulers.from(threadPoolExecutor);

AtomicInteger groupIndex = new AtomicInteger();

// Split the data into groups by thread number, then process each group on their own thread
Iterable<List<DataModel>> resultGroups = 
    Observable.from(dataList).groupBy(k -> groupIndex.getAndIncrement() % threadCount)
        .flatMap(group -> group.observeOn(scheduler).toList().map(sublist -> {
            List<DataModel> dataModels = new ArrayList<>();
            for (String data : sublist) {
                dataModels.add(DataParser.createData(data));
            }
            return dataModels;
        })).toBlocking().toIterable();

List<DataModel> result = new ArrayList<>();

// Wait for everything to finish and collect the results
for (List<DataModel> dataModels : resultGroups) {
    result.addAll(dataModels);
}
```

Previously I mentioned testing with two datasets. The first had large individual items but fewer total items. The second had many more total items, but each item was smaller. When I ran this solution against the first dataset, the difference was negligible. But, when I ran it on the second, longer dataset, the change was dramatic. With my previous approach it took about 20 seconds to process this dataset. Now, it takes about 5 seconds.

The reason the second dataset was sped up so much, is because of the number of data items. For each item, it has to schedule a thread to do the work. Now that I’ve reduced this scheduling work, there’s very little overhead.

#### Clean up ####

There’s a few places in my code where I need to do this parallel work. So I refactored this solution into a util method that can be called anywhere:

```
/**
 * Will process the data with the callable by splitting the data into the specified number of threads.
 * <b>T</b> is ths type of data being parsed, and <b>U</b> is the type of data being returned.
 */
public static <T, U> Iterable<U> parseDataInParallel(List<T> data, Func1<List<T>, U> worker) {
    int threadCount = Runtime.getRuntime().availableProcessors();
    ExecutorService threadPoolExecutor = Executors.newFixedThreadPool(threadCount);
    Scheduler scheduler = Schedulers.from(threadPoolExecutor);

    AtomicInteger groupIndex = new AtomicInteger();

    return Observable.from(data).groupBy(k -> groupIndex.getAndIncrement() % threadCount)
            .flatMap(group -> group.observeOn(scheduler).toList().map(worker)).toBlocking().toIterable();

}



//***EXAMPLE USAGE***
Iterable<List<DataModel>> resultGroups = Util.parseDataInParallel(dataList,
    (sublist) -> {
        List<DataModel> dataModels = new ArrayList<>();
        for (String data : sublist) {
            dataModels.add(DataParser.createData(data));
        }
        return dataModels;
    });

List<DataModel> results = new ArrayList<>();
for (List<DataModel> dataModels : resultGroups) {
    results.addAll(dataModels);
}
```

Here `T` is the type being processed, in the example that would be `DataModel`. You pass in a `List<T>` to be processed, and expect a result `U`. In my example `U` is `List<DataModel>`, but it could be anything, it doesn’t have to be a list either. The worker function being passed in is what does the processing of each sublist, and returns a result.

#### Can we make it faster? ####

There are many factors at play here that affect how fast this can run. Like how the threads are managed, how many threads are available, what kind of device the app is running on, etc. Most of these I can’t control, but there was something else I didn’t consider with my solution.

What if the data isn’t split evenly? For example, if I have 4 threads, what if every data item assigned to the 4th thread is 10 times larger than any other item? Then the 4th thread will end up running roughly 10 times longer than any other thread. In that case I won’t save much time with multithreading. The second approach I had actually solves this problem, since a thread is only assigned as it becomes available. But that solution was too slow.

I also tried to change how the data is grouped into sublists. Instead of doing it arbitrarily, I could keep track of the total size of the data in each group. Then, assign each data item to whichever list is the smallest. This way, the amount of work done by each thread is close to being equal. Unfortunately, in testing this solution I found the time it takes to do this extra setup usually costs more time than it saves.

Depending on how unevenly you expect your data to be split up, running it this way may actually be faster. But for the most part, it seems like just randomly splitting up the data is faster. Ideally if each thread could be assigned when available, with minimal overhead, it would be the most efficient solution. But, I couldn’t find a way to reduce the overhead enough to make it worth it.

#### Final thoughts ####

So if you need to run some code in parallel, here’s one approach. Let me know what you think, there are many variables at play here. It’s difficult to determine the optimal solution, if there even is one. Also remember, just because you *can* run something in parallel doesn’t mean you *should*.

### If You Enjoyed Reading, Please Click That Little Heart. If You Want To Read More Like This, Follow Me On [Medium](https://medium.com/@piercezaifman) . Thanks! ###
