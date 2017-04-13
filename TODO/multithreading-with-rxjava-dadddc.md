
> * 原文地址：[Multithreading with RxJava](https://android.jlelse.eu/multithreading-with-rxjava-dadddc4f7a63#.yghtx4u43)
> * 原文作者：[Pierce Zaifman](https://android.jlelse.eu/@PierceZaifman?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[PhxNirvana](https://github.com/phxnirvana)
> * 校对者：

# RxJava 中的多线程 #

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/2000/1*PD7aznI_MSxRwXI37a7mtg.jpeg">

大多数情况下，我写的 Android 代码都是可以流畅运行的，因此，速度从不是我考虑的问题。但几周前我处理一个读取和分析大文件的 app 时，浮现出了这一问题。

尽管我期望用户明白文件越大，耗时越长的道理，有时候他们仍会放弃我的应用。他们可能认为应用卡住了，也可能是因为他们就不想等那么久。所以如果我能把时间砍一半或更多的话，一定会大有裨意的。

#### 初体验 ####

因为我所有后台任务都用 RxJava 重写了，所以继续用 RxJava 来解决这个问题也是自然而然的。尤其是我还有一些如下所示的代码：

```
List<String> dataList;
//这里是数据列表

List<DataModel> result = new ArrayList<>();
for (String data : dataList) {
    result.add(DataParser.createData(data));
}
```

所以我只是想把循环的每个操作放到一个后台线程中。如下所示：

```
List<String> dataList;
//这里是数据列表

List<Observable<DataModel>> tasks = new ArrayList<>();

for (String data : dataList) {
    tasks.add(Observable.just(data).subscribeOn(Schedulers.io()).map(s -> {
        // 返回一个 DataModel 对象
        return DataParser.createData(s);
    }));
}

List<DataModel> result = new ArrayList<>();

// 等待运行结束并收集结果
for (DataModel dataModel : Observable.merge(tasks).toBlocking().toIterable()) {
    result.add(dataModel);
}
```

的确起作用了，时间减少了近一半。但也导致大量垃圾回收（GC），这使得加载时的 UI 又卡又慢。为了搞清楚问题的原因，我加了一句 log 打印如下信息 `Thread.currentThread().getName()`。 这样我就搞清楚了，我在处理每一段数据时都新建了线程。正如结果所示，创建上千个线程并不是什么好主意。

#### 二进宫 ####

我已经完成了加速数据处理的目标，但运行起来并不那么流畅。我想知道如果不触发这么多 GC 的话还能不能跑得再快点。所以作为直接创建新线程的代替，我建立了我自己的限定线程数量的线程池提供给 RxJava 使用：

```
List<String> dataList;
//这里是数据列表

List<Observable<DataModel>> tasks = new ArrayList<>();

// 取得能够使用的最大线程数
int threadCount = Runtime.getRuntime().availableProcessors();
ExecutorService threadPoolExecutor = Executors.newFixedThreadPool(threadCount);
Scheduler scheduler = Schedulers.from(threadPoolExecutor);

for (String data : dataList) {
    tasks.add(Observable.just(data).subscribeOn(scheduler).map(s -> {
        // 返回一个 DataModel 对象
        return DataParser.createData(s);
    }));
}

List<DataModel> result = new ArrayList<>();

// 等待运行结束并收集结果
for (DataModel dataModel : Observable.merge(tasks).toBlocking().toIterable()) {
    result.add(dataModel);
}
```

对于单个数据都很大的数据集来说，这样减少了约 10% 的数据处理时间。然而，对于单个数据都很小的数据集就减少了约 30% 的时间。这同时也减少了 GC 的数量，但 GC 还是太频繁。

#### Third attempt ####

我有一个新想法——如果性能的瓶颈是线程的管理和切换会怎么样？为了克服这个问题，我可以将数据按照线程来拆分。这样虽然仍是并发运行，但对每个线程的管理将大大减小。我尝试使用 [这里](https://github.com/ReactiveX/RxJava/issues/3532#issuecomment-157509946) 的解决方法来实现我的想法：

```
List<String> dataList;
//这里是数据列表


// 取得能够使用的最大线程数
int threadCount = Runtime.getRuntime().availableProcessors();
ExecutorService threadPoolExecutor = Executors.newFixedThreadPool(threadCount);
Scheduler scheduler = Schedulers.from(threadPoolExecutor);

AtomicInteger groupIndex = new AtomicInteger();

// 以线程数量为依据分组数据，将每组数据放到它们自己的线程中
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

// 等待运行结束并收集结果
for (List<DataModel> dataModels : resultGroups) {
    result.addAll(dataModels);
}
```

上文中我提到用两组数据测试，一组单个数据大但总数少，另一组单个数据小但数量多。当我再次测试时，第一组数据几乎没差别，而第二组改变相当大。之前几乎要 20秒，现在只需 5秒。

第二组数据运行时间改进如此大的原因是数量的改变。每个数据都需要指定工作线程，而现在减少了指定线程时的工作量，性能也从而提升了。

#### Clean up ####

上面的代码要执行并发还有一些地方需要修改，所以我重新用 util 整理了代码，增加了这段代码的通用性：

```
/**
 * Will process the data with the callable by splitting the data into the specified number of threads.
 * <b>T</b> 是要被处理的数据类型，<b>U</b> 是返回的数据类型
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

这里 `T` 是被处理的数据类型，样例中是`DataModel`。传入待处理的 `List<T>` 并期望结果是 `U`。在我的样例中 `U` 是 `List<DataModel>`，但它可以是任何东西，并不一定是一个 list。被传入的工作方法处理每个子列表并返回结果。

#### 可以再快点么？ ####

事实上影响运行速度的因素有许多。比如线程管理方式，线程数，设备等。大多数因素我无法控制，但总有一些是我没有考虑到的。

如果数据不是平均分配的会怎么样？举个例子，如果有 4 个线程，第四个线程数据量是其他的 10 倍会怎么样？这时第四个线程的耗时就是其他线程的大约 10 倍。这种情况下使用多线程就不会减少多少时间。我的第二次尝试基本解决了这个问题，因为线程只在需要时才初始化。但这个方法太慢了。

我也试过改变数据分组方式。作为随意分配的取代，我可以跟踪每一组数据的总量，然后将数据分配给最少的那组。这样每个线程的工作量就接近平均了。倒霉的是，测试之后发现这样做增加的时间远大于它节省的时间。

这么做可能会更快，（结果）取决于原始数据有多不平均。但大多数情况下，随机分配看起来更快些。理想情况下是每个线程一有空就分配任务，同时执行分配所消耗的资源也少，这是最高效的。但我找不到一个足够高效的可以减少分配瓶颈的方法。

#### Final thoughts ####

所以如果你想要并发运行一些代码，这里提供一种方法。让我知道你的想法，这里还有许多考验控制的变量。得到一个最优解（如果有的话）总是很难的。以及，**能**并发执行并不意味着**必须**用并发。

### 如果有收获的话，轻轻扎一下小红心吧老铁。想阅读更多，在 [Medium](https://medium.com/@piercezaifman) 关注我。谢谢！（顺便关注一下 [译者](https://juejin.im/user/57a16f4e6be3ff00650682d8) 233） ###
