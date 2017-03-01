> * 原文地址：[5 Not So Obvious Things About RxJava](https://medium.com/@jagsaund/5-not-so-obvious-things-about-rxjava-c388bd19efbc#.kf2q0gksm)
* 原文作者：[Jag Saund](https://medium.com/@jagsaund)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： 
* 校对者：

![](https://cdn-images-1.medium.com/max/2000/1*0VDGLZYyQhUFBa9ZkFiHEQ.jpeg)

# 5 Not So Obvious Things About RxJava

Whether you’re new to RxJava, or have used it for a while, there’s always something new to learn. While using the framework, I learned 5 not so obvious things about RxJava that helped me maximize its potential.

***NOTE*** This article references APIs that are available in **RxJava 1.2.6**

### 1. When to use map or flatMap

[map](http://reactivex.io/documentation/operators/map.html) and [flatMap](http://reactivex.io/documentation/operators/flatmap.html) are two commonly used ReactiveX operators. They’re often the first two operators you learn, and it can be confusing to figure out which one’s the right one to use.

Both *map* and *flatMap* apply a transformational function on each item emitted by an Observable. However, *map* only emits one item, whereas *flatMap* emits zero or more items.

![](https://cdn-images-1.medium.com/max/800/1*hKc_cjAvfr4RqeMcyDbRkw.png)

In this example, the `map` operator applies the `split` function to each string and emits one item containing an array of strings. Use this when you want to transform one emitted item into another.

Sometimes, the function we apply returns multiple items, and we want to add them to a single stream. In this instance, `flatMap` is a good candidate. In the example above the `flatMap` operator “flattens” the array of words emitted into a single sequence.

### 2. Avoid creating observables with Observable.create(…)

At some point you’ll need to convert a traditional synchronous or asynchronous API into a reactive one. Though using [Observable.create](http://reactivex.io/documentation/operators/create.html) seems like an attractive solution, it requires you to:

- Unregister callbacks when an Observable is unsubscribed (failing to do so can cause memory leaks)
- Emit events using onNext or onCompleted only while a subscriber is still subscribed
- Propagate errors upstream using onError
- Handle backpressure

It’s difficult to correctly implement these requirements, but luckily, you don’t have to. There’s a few static helper methods that handle this for you:

**syncOnSubscribe**

A utility for creating a safe `OnSubscribe<T>` that responds correctly to backpressure requests from subscribers. Use it when you need to transform a synchronous pull-like API that’s blocking into a reactive one.

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

A static helper that’s great for wrapping a simple synchronous API and transforming it into a reactive one. As an added bonus, `fromCallable` also handles checked exceptions.

```
public Observable<Boolean> enablePushNotifications(boolean enable) {
  return Observable.fromCallable(() -> sharedPrefs
    .edit()
    .putBoolean(KEY_PUSH_NOTIFICATIONS_PREFS, enable)
    .commit());
}
```

**fromEmitter**

A static helper that’s great for wrapping an asynchronous API and managing the resource when the Observable is unsubscribed from. Unlike `fromCallable`, you have the ability to emit multiple items.

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

### 3. How to handle Backpressure

Sometimes, an Observable produces events so quickly that an Observer downstream can’t keep up with them. When this happens, you’ll often experience a `MissingBackpressureException`.

![](https://cdn-images-1.medium.com/max/800/1*G-yJQ_ururyvMGkGRA3eAw.png)

RxJava offers a few ways to manage backpressure but picking the right one depends on your situation.

**Cold vs. Hot Observables**

Cold Observables begin emitting items upon subscription. The Observer subscribed to a cold Observable can control the pace of emitting events without sacrificing the integrity of the stream. Examples of cold Observables include, reading a File, database queries, web requests, and a static iterable converted to an Observable.

Hot Observables are continuous streams of events, emitted regardless of the number of subscribers. When an Observer subscribes to a hot Observable, it can either:

- receive a replay of a subset of all events emitted
- receive a replay of all events emitted
- receive new events as they’re emitted

Examples of hot Observables include, touch events, notifications, and progress updates.

Due to the inherent nature of events emitted by a hot Observable, you can’t control their pace. For example, you can’t slow down the rate at which touch events are emitted. Thus, it’s best to use one of the flow control strategies outlined by `BackpressureMode`.

Using a reactive-pull approach, cold Observables can respond to feedback from the Observer to slow down. To learn more, see ReactiveX documentation on [backpressure and reactive-pull](https://github.com/ReactiveX/RxJava/wiki/Backpressure).

**BackpressureMode.NONE and BackpressureMode.ERROR**

In both of these modes, emitted events aren’t backpressured. A `MissingBackpressureException` is thrown when observeOn’s internal 16-element sized buffer overflows.

![](https://cdn-images-1.medium.com/max/800/1*Wexx6Cgpqhgwr_rQnGUjIw.png)

**BackpressureMode.BUFFER**

In this mode, an unbounded buffer with an initial size of 128 is created. Items emitted too quickly are buffered unboundedly. If the buffer isn’t drained, items continue to accumulate until memory is exhausted. This results in an `OutOfMemoryException`.

![](https://cdn-images-1.medium.com/max/800/1*7YWjJNYa1Qgzrxjdottmzg.png)

**BackpressureMode.DROP**

This mode uses a fixed buffer of size 1. If the downstream observable can’t keep up, the first item is buffered and subsequent emissions are dropped. When the consumer is ready to take the next value, it receives the first value emitted by the source Observable.

![](https://cdn-images-1.medium.com/max/800/1*Lc_olwX6t_KDWp1wXShXMg.png)

**BackpressureMode.LATEST**

This mode is similar to `BackpressureMode.DROP` because it also uses a fixed buffer of size 1. However, rather than buffering the first item and dropping subsequent items, `BackpressureMode.LATEST` replaces the item in the buffer with the latest emission. When the consumer is ready to take the next value, it receives the latest value emitted by the source Observable.

![](https://cdn-images-1.medium.com/max/800/1*3DRYVExZDiutRZpzaFx2xQ.png)

### 4. How to prevent errors from unintentionally terminating your stream

RxJava communicates unrecoverable errors by notifying the Observable sequence with an `onError` notification. This also terminates the sequence.

Sometimes, you don’t want your sequence to terminate. In those instances, RxJava offers a number of ways to handle errors without terminating your sequence.

RxJava offers a number of ways to handle errors but sometimes you don’t want your sequence to be terminated. This is especially handy when working with Subjects.

**onErrorResumeNext**

Using [onErrorResumeNext](http://reactivex.io/RxJava/javadoc/rx/Observable.html#onErrorResumeNext%28rx.Observable%29) allows you to intercept the `onError` notification and return another Observable. This can either wrap the error with additional information and return a new error, or it can return a new event to be received in `onNext`.

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

**The catch with onErrorResumeNext**

Using this operator repairs the downstream sequence, but terminates the upstream sequence because an `onError` notification has been emitted. Therefore, if you were connected to a Subject that was publishing notifications, an `onError` notification would terminate the Subject.

If you wish to keep the upstream running, nest the Observable with the `onErrorResumeNext` operator inside a `flatMap` or `switchMap` operator.

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

### 5. How to share your Observable

Sometimes you’ll need to share the output of an Observable with multiple Observers. Two ways to multicast the events emitted from on Observable with RxJava are `share` and `publish`.

**Share**

The `share` operator allows multiple Observers to connect to the source Observable. In the example below, a source Observable emits `MotionEvent` items that are shared. Then, we create two additional Observables to filter out the source for `DOWN` and `UP` touch events. For `DOWN` events, we draw a red circle, and for`UP` events we draw a blue circle.

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

However, when the Observer subscribes to the source Observable, the source begins emitting events. This is problematic because subsequent subscribers can miss one or more touch events.

![](https://cdn-images-1.medium.com/max/800/1*RLhTXNHt8GZxaYl1I0OVfw.gif)

In this example, the “blue” Observer misses the first value emitted after it subscribes to the source. In some situations, this is fine, but if you can’t afford to miss any events, you’ll need to use the `publish` operator.

**Publish**

Calling `publish` on a source Observable transforms the Observable into a ConnectedObservable. This means that it will behave similar to a valve being flipped on. The example below is the same as above, but notice we now use the `publish` operator.

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

Once the necessary Observables subscribe to the source, you’ll need to call `connect` on the source ConnectedObservable to begin emitting events.

![](https://cdn-images-1.medium.com/max/800/1*ORD0JlGH_FIk3oRb64gvEQ.gif)

Notice, once `connect` is called on the source, the same sequence of events emit to both the “green” and “blue” Observers.