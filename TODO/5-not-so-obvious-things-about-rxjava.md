> * 原文地址：[5 Not So Obvious Things About RxJava](https://medium.com/@jagsaund/5-not-so-obvious-things-about-rxjava-c388bd19efbc#.kf2q0gksm)
> * 原文作者：[Jag Saund](https://medium.com/@jagsaund)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者： [skyar2009](https://github.com/skyar2009)
> * 校对者：[Danny1451](https://github.com/Danny1451), [yunshuipiao](https://github.com/yunshuipiao)

![](https://cdn-images-1.medium.com/max/2000/1*0VDGLZYyQhUFBa9ZkFiHEQ.jpeg)

# 震惊！RxJava 5 个不为人知的小秘密

无论你是刚刚接触 RxJava，还是已经使用过一段时间，关于 RxJava 你总会有些新的知识要学。在使用 RxJava 框架过程中，我发现了 5 点不那么明显的知识，使我可以充分挖掘它的潜能。

**注释** 本文引用的 APIs 是基于 **RxJava 1.2.6**

### 1. 什么时候使用 map，什么时候使用 flatMap

[map](http://reactivex.io/documentation/operators/map.html) 和 [flatMap](http://reactivex.io/documentation/operators/flatmap.html) 是常用的两个 ReactiveX 操作。它们往往是你最先接触的两个操作，并且很难确定使用哪个是正确的。

**map** 和 **flatMap** 都是对 Observable 发出的每一个元素执行转换方法。但是，**map** 只输出一个元素，**flatMap** 输出 0 或多个元素。

![](https://cdn-images-1.medium.com/max/800/1*hKc_cjAvfr4RqeMcyDbRkw.png)

在上面的例子中，`map` 操作对每一个字符串执行了 `split` 方法并输出了一个包含字符串数组的元素。当你想将一个元素转换成另一个时使用 `map`。

有些时候，我们执行的方法返回多个元素，并且我们希望将他们添加到同一个流中。这种情况下，`flatMap` 是一个好的选择。在上面的例子中 `flatMap` 操作将字符串数组处理后输出到了同一个序列。

### 2. 避免使用 Observable.create(…) 创建 Observable

有些时候你需要将同步或异步的 API 转成响应式的 API。使用 [Observable.create](http://reactivex.io/documentation/operators/create.html) 看起来是个极具诱惑性的选择，但它有如下要求：

- 当取消 Observable 订阅时需要注销回调 (否则会造成内存泄露)
- 只有当有订阅者订阅时才能使用 onNext 或 onCompleted 发送事件
- 使用 onError 向上游传递错误
- 处理背压

很难正确的实现以上要求，幸运的是，你可以不这么做。有一些静态工具方法可以帮你解决：

**syncOnSubscribe**

一个可以创建安全 `OnSubscribe<T>` 的工具，它创建的 `OnSubscribe<T>` 能够正确地处理来自订阅者的背压请求。当你需要将一个同步获取式的阻塞 API 转成响应式 API 时可以使用。

```
public Observable<byte[]> readFile(@NonNull FileInputStream stream) {
  final SyncOnSubscribe<FileInputStream, byte[]> fileReader = SyncOnSubscribe.createStateful(
    () -> stream,
    (stream, output) -> {
      try {
        final byte[] buffer = new byte[BUFFER_SIZE];
        int count = stream.read(buffer);
        if (count < 0) {
          output.onCompleted();
        } else {
          output.onNext(buffer);
        }
      } catch (IOException error) {
        output.onError(error);
      }
      return stream;
    },
    s -> IOUtil.closeSilently(s));
  return Observable.create(fileReader);
}
```

**fromCallable**

一个静态工具，可以对简单的同步 API 进行封装并将之转化成响应式 API。更赞的是，`fromCallable` 也可以处理检查到的异常。

```
public Observable<Boolean> enablePushNotifications(boolean enable) {
  return Observable.fromCallable(() -> sharedPrefs
    .edit()
    .putBoolean(KEY_PUSH_NOTIFICATIONS_PREFS, enable)
    .commit());
}
```

**fromEmitter**

一个静态工具，对异步 API 进行封装并可以管理 Observable 被取消订阅时释放的资源。不像 `fromCallable`，你可以输出多个元素。

```
import android.bluetooth.le.BluetoothLeScanner;
import android.bluetooth.le.ScanCallback;
import android.bluetooth.le.ScanResult;
import android.support.annotation.NonNull;
import rx.Emitter;
import rx.Observable;

import java.util.List;

public class RxBluetoothScanner {
    public static class ScanResultException extends RuntimeException {
        public ScanResultException(int errorCode) {
            super("Bluetooth scan failed. Error code: " + errorCode);
        }
    }
    
    private RxBluetoothScanner() {
    }

    @NonNull
    public static Observable<ScanResult> scan(@NonNull final BluetoothLeScanner scanner) {
        return Observable.fromEmitter(scanResultEmitter -> {
            final ScanCallback scanCallback = new ScanCallback() {
                @Override
                public void onScanResult(int callbackType, @NonNull ScanResult result) {
                    scanResultEmitter.onNext(result);
                }

                @Override
                public void onBatchScanResults(@NonNull List<ScanResult> results) {
                    for (ScanResult r : results) {
                        scanResultEmitter.onNext(r);
                    }
                }

                @Override
                public void onScanFailed(int errorCode) {
                    scanResultEmitter.onError(new ScanResultException(errorCode));
                }
            };
            
            scanResultEmitter.setCancellation(() -> scanner.stopScan(scanCallback));
            scanner.startScan(scanCallback);
        }, Emitter.BackpressureMode.BUFFER);
    }
}
```

### 3. 如何处理背压

有时，Observable 产生事件过快以至于下游观察者跟不上它的速度。当这种情况发生时，你往往会遇到 `MissingBackpressureException` 异常。

![](https://cdn-images-1.medium.com/max/800/1*G-yJQ_ururyvMGkGRA3eAw.png)

RxJava 提供了一些方法管理背压，但是具体使用哪一种需要视情况而定。

**冷、热 Observable**

只有当有订阅时，冷 Observable 才会发送元素。观察者订阅冷 Observable 可以控制发送事件的速度而不需要牺牲流的完整性。冷 Observable 例子有：读文件、数据库查询、网络请求以及静态迭代器转成的 Observable。

热 Observable 是连续的事件流，它的发出不依赖订阅者的数量。当一个观察者订阅了 Observable，那么它将面临下面的一种情况：

- 收到所有事件子集的重放
- 收到所有事件的重放
- 收到新的事件

热 Observables 例子有：触摸事件、通知以及进度更新。

由于热 Observable 发出事件的本性，我们不能控制它的速度。例如，你不能降低触摸事件发出的速度。因此，最好是使用 `BackpressureMode` 提供的流控制策略。

使用一个响应式获取方法，冷 Observable 可以根据观察者的反馈降低发送速度。更多知识，请看 ReactiveX 文档的[背压与响应式获取方法](https://github.com/ReactiveX/RxJava/wiki/Backpressure).

**BackpressureMode.NONE 和 BackpressureMode.ERROR**

在这两种模式中，发送的事件不是背压。当被观察者的 16 元素缓冲区溢出时会抛出 `MissingBackpressureException`。

![](https://cdn-images-1.medium.com/max/800/1*Wexx6Cgpqhgwr_rQnGUjIw.png)

**BackpressureMode.BUFFER**

在这种模式下，有一个无限的缓冲区（初始化时是 128）。过快发出的元素都会放到缓冲区中。如果缓冲区中的元素无法消耗，会持续的积累直到内存耗尽。结果是 `OutOfMemoryException` 异常。

![](https://cdn-images-1.medium.com/max/800/1*7YWjJNYa1Qgzrxjdottmzg.png)

**BackpressureMode.DROP**

这种模式是使用固定大小为 1 的缓冲区。如果下游观察者无法处理，第一个元素会缓存下来后续的会被丢弃。当消费者可以处理下一个元素时，它收到的将是 Observable 发出的第一个元素。

![](https://cdn-images-1.medium.com/max/800/1*Lc_olwX6t_KDWp1wXShXMg.png)

**BackpressureMode.LATEST**

这种模式与 `BackpressureMode.DROP` 类似，因为它也使用固定大小为 1 的缓冲区。然而，不是缓存第一个元素丢弃后续元素，`BackpressureMode.LATEST` 而是使用最新的元素替换缓冲区缓存的元素。当消费者可以处理下一个元素时，它收到的是 Observable 最近一次发送的元素。

![](https://cdn-images-1.medium.com/max/800/1*3DRYVExZDiutRZpzaFx2xQ.png)

### 4. 如何防止无意的结束流错误

RxJava 通过给 Observable 序列发送 `onError` 通知不可恢复的错误，并且会结束序列。

有时，你不希望结束序列。对于这种情况，RxJava 提供了几种不会结束序列的错误处理方法。

RxJava 提供了许多错误处理方法，但是有时你不希望结束序列。尤其是涉及到主题时。

**onErrorResumeNext**

使用 [onErrorResumeNext](http://reactivex.io/RxJava/javadoc/rx/Observable.html#onErrorResumeNext%28rx.Observable%29) 可以拦截 `onError` 并返回一个 Observable。或者对错误信息添加附加信息并返回一个新的错误，或者发送给 `onNext` 一个新的事件。

```
public Observable<SearchResult> search(@NotNull EditText searchView) {
  return RxTextView.textChanges(searchView) // In production, share this text view observable, don't create a new one each time
    .map(CharSequence::toString)
    .debounce(500, TimeUnit.MILLISECONDS)   // Avoid getting spammed with key stroke changes
    .filter(s -> s.length() > 1)            // Only interested in queries of length greater than 1
    .observeOn(workerScheduler)             // Next set of operations will be network so switch to an IO Scheduler (or worker)
    .switchMap(query -> searchService.query(query))   // Take the latest observable from upstream and unsubscribe from any previous subscriptions
    .onErrorResumeNext(Observable.empty()); // <-- This will terminate upstream (ie. we will stop receiving text view changes after an error!)
}
```

**使用 onErrorResumeNext 捕获**

使用该操作会修复下游序列，但是会结束上游序列因为已经发送了 `onError` 通知。所以，如果你连接的是一个发布通知的主题，`onError` 通知会结束主题。

如果你希望上游继续运行，可以在 `onErrorResumeNext` 操作中嵌套 `flatMap` 或 `switchMap` 操作。

```
public Observable<SearchResult> search(@NotNull EditText searchView) {
  return RxTextView.textChanges(searchView) // In production, share this text view observable, don't create a new one each time
    .map(CharSequence::toString)
    .debounce(500, TimeUnit.MILLISECONDS)   // Avoid getting spammed with key stroke changes
    .filter(s -> s.length() > 1)            // Only interested in queries of length greater than 1
    .observeOn(workerScheduler)             // Next set of operations will be network so switch to an IO Scheduler (or worker)
    .switchMap(query -> searchService.query(query) // Take the latest observable from upstream and unsubscribe from any previous subscriptions
               .onErrorResumeNext(Observable.empty()); // <-- This fixes the problem since the error is not seen by the upstream observable
}
```

### 5. 如何共享你的 Observable

有时你需要将 Observable 的输出共享给多个观察者。RxJava 提供了 `share` 和 `publish` 两种方式实现 Observable 发送事件的多播。

**Share**

`share` 允许多个观察者连接到源 Observable。下面的例子中，共享的是 Observable 发送的 `MotionEvent` 事件。然后，我们创建了另外两个 Observable 分别过滤 `DOWN` 和 `UP` 触摸事件。`DOWN` 事件我们画红圈，`UP` 事件我们画篮圈。

```
public void touchEventHandler(@NotNull View view) {
  final Observable<MotionEvent> motionEventObservable = RxView.touches(view).share();
  // Capture down events
  final Observable<MotionEvent> downEventsObservable = motionEventObservable
    .filter(event -> event.getAction() == MotionEvent.ACTION_DOWN);
  // Capture up events
  final Observable<MotionEvent> upEventsObservable = motionEventObservable
    .filter(event -> event.getAction() == MotionEvent.ACTION_UP);

  // Show a red circle at the position where the down event ocurred
  subscriptions.add(downEventsObservable.subscribe(event ->
      view.showCircle(event.getX(), event.getY(), Color.RED)));
  // Show a blue circle at the position where the up event ocurred
  subscriptions.add(upEventsObservable.subscribe(event ->
      view.showCircle(event.getX(), event.getY(), Color.BLUE)));
}
```

然而，一旦有观察者订阅 Observable，Observable 就会开始发送事件。这样就会造成后续的订阅者会错过一个或多个触摸事件。

![](https://cdn-images-1.medium.com/max/800/1*RLhTXNHt8GZxaYl1I0OVfw.gif)

在这个例子中，“蓝” 观察者错过了第一个事件。有些时候这没问题，但是如果你不能接受错过任何事件，那么你需要使用 `publish` 操作。

**Publish**

对 Observable 执行 `publish` 操作会将值转化为 ConnectedObservable。就像打开阀门一样。下面的例子和上面一样，需要注意的是我们现在使用的是 `publish` 操作。

```
public void touchEventHandler(@NotNull View view) {
  final ConnectedObservable<MotionEvent> motionEventObservable = RxView.touches(view).publish();
  // Capture down events
  final Observable<MotionEvent> downEventsObservable = motionEventObservable
    .filter(event -> event.getAction() == MotionEvent.ACTION_DOWN);
  // Capture up events
  final Observable<MotionEvent> upEventsObservable = motionEventObservable
    .filter(event -> event.getAction() == MotionEvent.ACTION_UP);

  // Show a red circle at the position where the down event ocurred
  subscriptions.add(downEventsObservable.subscribe(event ->
      view.showCircle(event.getX(), event.getY(), Color.RED)));
  // Show a blue circle at the position where the up event ocurred
  subscriptions.add(upEventsObservable.subscribe(event ->
      view.showCircle(event.getX(), event.getY(), Color.BLUE)));
  // Connect the source observable to begin emitting events
  subscriptions.add(motionEventObservable.connect());
}
```

一旦必要的 Observables 订阅了源，你需要执行对源 ConnectedObservable 执行 `connect` 来开始发送事件。

![](https://cdn-images-1.medium.com/max/800/1*ORD0JlGH_FIk3oRb64gvEQ.gif)

注意，一旦对源调用了 `connect` 方法，相同事件序列会分别发送给 “绿” 和 “蓝” 观察者。
