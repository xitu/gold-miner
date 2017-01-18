> * 原文地址：[RxAndroid Tutorial](https://www.raywenderlich.com/141980/rxandroid-tutorial)
* 原文作者：[Artem Kholodnyi](https://www.raywenderlich.com/u/mlatu)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Jamweak](https://github.com/jamweak)
* 校对者：

# RxAndroid 中文教程

如果你是新人，你可能会想订阅我的 [RSS 流](http://www.raywenderlich.com/feed/)，或者关注我的 [Twitter](http://twitter.com/rwenderlich)。感谢阅读！

![AndroidReactive-feature](https://koenig-media.raywenderlich.com/uploads/2016/11/AndroidReactive-feature-250x250.png)

有人曾说，我们一生都应去追求主动式地编程，而不是响应式。然而，这种思想并不适用开发 Android 程序。:]

响应式编程并不仅是另外一套 API 规范。它是一种全新的并且非常有用的代码规范。“RxJava” 是一个能在 Android 上使用的响应式编程的实现。Android 是一个开始探索响应式编程世界的极佳平台。尤其是使用 “RxAndroid” 后，事情变得更加简单。“RxAndroid” 是一个将异步 UI 事件封装成更像 RxJava 风格的公共库。

不要害怕——我敢打赌，即使你还不熟悉响应式编程，你也会知道关于它的一些基本概念的。:]

*注意:* 本教程需要熟悉 Android 和 Java 的相关知识。想要快速跟上节奏的话，不妨先看看我们的 [Android 开发教程](https://www.raywenderlich.com/category/android)，当你准备好了之后再来看本篇。

在本篇 RxAndroid 教程中，你将会学习如下知识：

- 什么是响应式编程

- 什么是 *observable*

- 将例如按钮点击或是文本更新这些异步事件转换成 observable

- 转换 observable 条目

- 过滤 observable 条目

- 指定代码在特定的线程中执行

- 拼装若干 observable，合并成一个

但愿你喜欢奶酪——因为我们将使用一个寻找奶酪的应用程序来讲述上面的这些概念！:]

## 准备开始 ##

下载 [学习本教程的起步工程](https://koenig-media.raywenderlich.com/uploads/2016/11/CheeseFinder-starter-2.zip)，并使用 Android Studio 打开。

你只会用到 *CheeseActivity.java* 文件。`CheeseActivity` 这个类继承自 `BaseSearchActivity`；花些时间看一下 `BaseSearchActivity` 类，熟悉一下你将使用到的一些东西：

- `showProgressBar()`: 展示进度条的方法…

- `hideProgressBar()`: …隐藏进度条的方法

- `showResult(List<String> result)`: 展示奶酪列表的方法

- `mCheeseSearchEngine`: 一个 `CheeseSearchEngine` 的实例。它具有 `search` 方法，你可以调用它来查询奶酪。这个方法接收一个文本查询，返回一个匹配奶酪的列表：

构建并在你的 Android 设备或模拟器上运行这个工程。 你将会看到一个空荡荡的查询页面。

![starter-300x500](https://koenig-media.raywenderlich.com/uploads/2016/09/starter-300x500.png)

## 什么是响应式编程？ ##

在你创建第一个 observable 之前，先让自己学习一下理论知识。:]

在 *命令式* 编程中, 一个表达式执行一次，值就赋给了对应的变量：

```
int a = 2;
int b = 3;
int c = a * b; // c is 6
 
a = 10;
// c 仍然是 6
```

在另一方面，*响应式* 编程就是关注值的变化。

你可能已经完成了一些响应式的编程，即便当时你并了解它。

- 
定义电子表格中单元格的“值”类似于在命令式编程中定义变量。

- 
定义电子表格中单元格的“表达式”类似于在响应式编程中定义并操控 observable。

下图的电子表格就实现了上述的两种示例：

![](https://i.imgur.com/W8YCp8u.png)

在表格中，赋给单元格 B1 的值是 2，B2 的值是 3。单元格 B3 中的值是由 B1 中的值乘以 B2 中的值这个表达式确定的。当表达式中引用的任一值发生变化时，这个变化即被表达式观察到，B3 中的值就会被重新计算：

![](https://i.imgur.com/Mqqoi8D.png)

## RxJava Observable 协议 ##

RxJava 使用了 *观察者模式*。

*注意*: 如果你想重温一下观察者模式的话，可以看看 [Android 中通用的设计模式](https://www.raywenderlich.com/109843/common-design-patterns-for-android).

在观察者模式中，你的对象需要实现 RxJava 中的两个关键接口：`Observable` 和 `Observer`。当 `Observable` 的状态改变时，所有的订阅它的 `Observer` 对象都会被通知。

在 `Observable` 接口的众多方法中，调用 `subscribe()` 让 `Observer` 开始订阅该 `Observable`。

从这时起，`Observer` 接口有三个方法是 `Observable` 调用时需要的：

- `onNext(T value)` 提供了一个新的 T 类型的条目给 `Observer`

- `onComplete()` 通知 `Observer`，`Observable` 已发送完条目

- `onError(Throwable e)` 通知 `Observer`，`Observable` 遇到了一个错误

按照规范，一个表现正常的 `Observable` 会发出零个或者多个事件，直到最后发出结束或者错误。这听起来挺复杂，下面会有一些示例能简单地解释：

一个网络请求 observable 通常发出一个单一的事件，并且立即结束：

![network-request](https://koenig-media.raywenderlich.com/uploads/2016/08/network-request-650x186.png)

绿色圆圈代表 observable 发出的一个事件，黑色的阻隔线代表结束或者错误。

一个鼠标移动的 observable 将会发出鼠标的坐标，但永远不会结束：

![mouse-coords](https://koenig-media.raywenderlich.com/uploads/2016/08/mouse-coords-650x186.png)

在上图你可以看到多个事件被发出，但是没有隔断显示鼠标已经结束观察或者遇到错误。

在结束之后，observable 不会再发出事件。下面示范一个错误的 observable 用法，其违背了 Observable 规范：

![misbehaving-stream](https://koenig-media.raywenderlich.com/uploads/2016/08/misbehaving-stream-650x186.png) 

这是个错误的，错误的 observable，因为它违背了 Observable 规范，在发出结束信号之后，又发出了其它事件。

## 如何创建一个 Observable ##

有许多库能够帮助你创建一个几乎覆盖所有类型事件的 Observable。然而，有时你必须自己做，学习如何做是个好办法！

你可以使用 `Observable.create()` 方法创建一个 Observable。下面是方法签名：

```
Observable<T> create(ObservableOnSubscribe<T> source)
```

看起来很简洁方便，但是它是什么意思？“source?” 又是什么意思？要了解这个方法签名，你必须得知道什么是 `ObservableOnSubscribe`。它是一个接口，声明如下：

```
public interface ObservableOnSubscribe<T> {
  void subscribe(ObservableEmitter<T> e) throws Exception;
}
```
就像艾布拉姆斯的剧集，如“迷失”或“西部世界”一样，回答问题往往不可避免地会引入其它问题。因此，你要用 “source” 来创建 `Observable`时，就需要知道 `subscribe()` 方法，这就又需要了解这个方法的调用者，它提供了一个 “emitter” 参数。然后呢，什么是 emitter?

RxJava 的 `Emitter` 接口和`Observer` 类似:

```
public interface Emitter<T> {
  void onNext(T value);
  void onError(Throwable error);
  void onComplete();
}
```

 `ObservableEmitter`, 特别地, 还提供了一种取消订阅的方式。

为了比拟使用过程，来设想调节水流大小的水龙头。水管就相当于一个 `Observable`，如果你有办法从中汲取的话，它就会释放出水流。你构建一个可以开关的水龙头，就像创建一个 `ObservableEmitter`，随后用 `Observable.create()` 来连接水管。结果就是一个理想的水龙头。:]

举例说明能将场景去抽象化，更加容易理解。接下来是时候来创建你的第一个 observable 了！:]

## 观察按钮点击 ##

将下面的代码添加到 `CheeseActivity` 类中:

```
// 1
private Observable<String> createButtonClickObservable() {
 
  // 2
  return Observable.create(new ObservableOnSubscribe<String>() {
 
    // 3
    @Override
    public void subscribe(final ObservableEmitter<String> emitter) throws Exception {
      // 4
      mSearchButton.setOnClickListener(new View.OnClickListener() {
        @Override
        public void onClick(View view) {
          // 5
          emitter.onNext(mQueryEditText.getText().toString());
        }
      });
 
      // 6
      emitter.setCancellable(new Cancellable() {
        @Override
        public void cancel() throws Exception {
          // 7
          mSearchButton.setOnClickListener(null);
        }
      });
    }
  });
}
```

这里是上述代码的注释：

1. 声明了一个方法，它返回一个 发出 String 类型事件的 observable;

2. 使用 `Observable.create()` 创建 observable, 并将 `ObservableOnSubscribe` 提供给它;

3. 重写 `subscribe()` 方法来定义自己的 `ObservableOnSubscribe`;

4. 在 `mSearchButton` 上设置一个监听器;

5. 当点击事件发生时，回调 emitter 中的 `onNext` 方法，并将 `mQueryEditText` 中的当前文本传递给它;

6. Java 中持有引用会造成内存泄漏。保持移除不需要的监听器是一个良好的习惯。但当你创建自定义的 `Observable` 时，该调用谁呢？基于这个原因，`ObservableEmitter` 有一个 `setCancellable()` 方法。 重写 `cancel()`, 当 Observable 被释放时，比如当 Observable 结束或是不再有订阅者时，你的实现会被调用；

7. 对于 `OnClickListener`, 移除监听器的方式是 `setOnClickListener(null)`；

既然已经定义好了 Observable，你需要设置一个关于它的订阅。在这之前，你需要了解更多的接口，`Consumer`。它是一种从 emitter 中接收值的简便方式。

```
public interface Consumer<T> {
  void accept(T t) throws Exception;
}
```

使用这个接口，你能很方便地去设置对 Obserable 的订阅。

`Observable` 接口支持几种版本的 `subscribe()`，每种都有不同的参数类型。例如，如果你愿意的话，你可以传一个完整的 `Observer`，但你需要实现其所有必要的方法。

但如果你所需要的仅仅是 observer 对于 `onNext()` 传进来的值做出响应的话，你可以使用只有一个 `Consumer` 参数（这个参数甚至被命名成 `onNext`，将联系变得清晰）版本的 `subscribe()` 方法。

当你在 activity 的 `onStart()` 方法中进行订阅时，你会完成上述的步骤。将下面的代码添加到 `CheeseActivity.java` 类中:

```
@Override
protected void onStart() {
  super.onStart();
  // 1
  Observable<String> searchTextObservable = createButtonClickObservable();
 
  searchTextObservable
      // 2
      .subscribe(new Consumer<String>() {
        //3
        @Override
        public void accept(String query) throws Exception {
          // 4
          showResult(mCheeseSearchEngine.search(query));
        }
      });
}
```

引入 `Consumer` 是有歧义的; 遇到提示时, 导入:

```
import io.reactivex.functions.Consumer;
```

以下是各步的释义：

1. 首先， 通过你刚刚写的方法创建一个 observable。

2. 使用 `subscribe()` 来订阅 observable, 提供一个 `Consumer` 参数。

3. 重写 `accept()` 方法, 当 oberservable 发出事件后会回调次方法。

4. 最后, 执行查询并展示查询结果。

构建并运行应用，输入一些字符然后点击 *Search* 按钮。你应该看到一个匹配你查询规则的奶酪列表：

![enter-and-press-300x500](https://koenig-media.raywenderlich.com/uploads/2016/09/enter-and-press-300x500.png)

看起来很好吃的样子! :]

## RxJava 线程模型 ##

You’ve had your first taste of reactive programming. There is one problem though: the UI freezes up for a few seconds when the search button is pressed.

You might also notice the following line in Android Monitor:

```
> 08-24 14:36:34.554 3500-3500/com.raywenderlich.cheesefinder I/Choreographer: Skipped 119 frames!  The application may be doing too much work on its main thread.
```

This happens because `search` is executed on the main thread. If `search` were to perform a network request, Android will crash the app with a NetworkOnMainThreadException exception. It’s time to fix that.

One popular myth about RxJava is that it is multi-threaded by default, similar to `AsyncTask`. However, if not otherwise specified, RxJava does all the work in the same thread it was called from.

You can change this behavior with the `subscribeOn` and `observeOn` operators.

`subscribeOn` is supposed to be called only once in the chain of operators. If it’s not, the first call wins. `subscribeOn` specifies the thread on which the observable will be subscribed (i.e. created). If you use observables that emit events from Android View, you need to make sure subscription is done on the Android UI thread.

On the other hand, it’s okay to call `observeOn` as many times as you want in the chain. `observeOn` specifies the thread on which the next operators in the chain will be executed. For example:

```
myObservable // observable will be subscribed on i/o thread
  .subscribeOn(Schedulers.io())
  .observeOn(AndroidSchedulers.mainThread())
  .map(/* this will be called on main thread... */)
  .doOnNext(/* ...and everything below until next observeOn */)
  .observeOn(Schedulers.io())
  .subscribe(/* this will be called on i/o thread */);
```

The most useful schedulers are:

- `Schedulers.io()`: Suitable for I/O-bound work such as network requests or disk operations.

- `Schedulers.computation()`: Works best with computational tasks like event-loops and processing callbacks.

- `AndroidSchedulers.mainThread()` executes the next operators on the UI thread.

## The Map Operator ##

The `map` operator applies a function to each item emitted by an observable and returns another observable that emits results of those function calls. You’ll need this to fix the threading issue as well.

If you have an observable called `numbers` that emits the following:

![map-0](https://koenig-media.raywenderlich.com/uploads/2016/08/map-0-1.png)

And if you apply `map` as follows:

```
numbers.map(new Function<Integer, Integer>() {
  @Override
  public Integer apply(Integer number) throws Exception {
    return number * number;
  }
}
```

The result would be the following:

![map-1](https://koenig-media.raywenderlich.com/uploads/2016/08/map-1-1.png)

That’s a handy way to iterate over multiple items with little code. Let’s put it to use!

Modify `onStart()` in `CheeseActivity` class to look like the following:

```
@Override
protected void onStart() {
  super.onStart();
  Observable<String> searchTextObservable = createButtonClickObservable();
 
  searchTextObservable
      // 1
      .observeOn(Schedulers.io())
      // 2
      .map(new Function<String, List<String>>() {
        @Override
        public List<String> apply(String query) {
          return mCheeseSearchEngine.search(query);
        }
      })
      // 3
      .observeOn(AndroidSchedulers.mainThread())
      .subscribe(new Consumer<List<String>>() {
        @Override
        public void accept(List<String> result) {
          showResult(result);
        }
      });
}
```

When prompted, resolve the ambiguous `Function` import:

```
importio.reactivex.functions.Function;
```

Going over the code above:

1. First, specify that the next operator should be called on the I/O thread.

2. For each search query, you return a list of results.

3. Finally, specify that code down the chain should be executed on the main thread instead of on the I/O thread. In Android, all code that works with `View`s should execute on the main thread.

Build and run your project. Now the UI should be responsive even when a search is in progress.

## Show Progress Bar with doOnNext ##

It’s time to display the progress bar!

For that you’ll need a `doOnNext` operator. `doOnNext` takes a `Consumer` and allows you do something each time an item is emitted by observable.

In the same `CheeseActivity` class modify `onStart()` to the following:

```
@Override
protected void onStart() {
  super.onStart();
  Observable<String> searchTextObservable = createButtonClickObservable();
 
  searchTextObservable
      // 1
      .observeOn(AndroidSchedulers.mainThread())
      // 2
      .doOnNext(new Consumer<String>() {
        @Override
        public void accept(String s) {
          showProgressBar();
        }
      })
      .observeOn(Schedulers.io())
      .map(new Function<String, List<String>>() {
        @Override
        public List<String> apply(String query) {
          return mCheeseSearchEngine.search(query);
        }
      })
      .observeOn(AndroidSchedulers.mainThread())
      .subscribe(new Consumer<List<String>>() {
        @Override
        public void accept(List<String> result) {
          // 3
          hideProgressBar();
          showResult(result);
        }
      });
}
```

Taking each numbered comment in turn:

1. Ensure that the next operator in chain will be run on the main thread.

2. Add the `doOnNext` operator so that `showProgressBar()` will be called every time a new item is emitted.

3. Don’t forget to call `hideProgressBar()` when you are just about to display a result.

Build and run your project. You should see the progress bar appearing when you initiate the search:

![progressbar](https://koenig-media.raywenderlich.com/uploads/2016/09/progressbar-300x500.png)

## Observe Text Changes ##

What if you want to perform search automatically when the user types some text, just like Google?

First, you need to subscribe to `TextView` text changes. Add the following method to the `CheeseActivity` class:

```
//1
private Observable<String> createTextChangeObservable() {
  //2
  Observable<String> textChangeObservable = Observable.create(new ObservableOnSubscribe<String>() {
    @Override
    public void subscribe(final ObservableEmitter<String> emitter) throws Exception {
      //3
      final TextWatcher watcher = new TextWatcher() {
        @Override
        public void beforeTextChanged(CharSequence s, int start, int count, int after) {}
 
        @Override
        public void afterTextChanged(Editable s) {}
 
        //4
        @Override
        public void onTextChanged(CharSequence s, int start, int before, int count) {
          emitter.onNext(s.toString());
        }
      };
 
      //5
      mQueryEditText.addTextChangedListener(watcher);
 
      //6
      emitter.setCancellable(new Cancellable() {
        @Override
        public void cancel() throws Exception {
          mQueryEditText.removeTextChangedListener(watcher);
        }
      });
    }
  });
 
  // 7
  return textChangeObservable;
}
```

Here’s the play-by-play of each step above:

1. Declare a method that will return an observable for text changes.

2. Create `textChangeObservable` with `create()`, which takes an `ObservableOnSubscribe`.

3. When an observer makes a subscription, the first thing to do is to create a `TextWatcher`.

4. You aren’t interested in `beforeTextChanged()` and `afterTextChanged()`. When the user types and `onTextChanged()` triggers, you pass the new text value to an observer.

5. Add the watcher to your `TextView` by calling `addTextChangedListener()`.

6. Don’t forget to remove your watcher. To do this, call `emitter.setCancellable()` and overwrite `cancel()` to call `removeTextChangedListener()`

7. Finally, return the created observable.

To see this observable in action, replace the declaration of `searchTextObservable` in `onStart()` of `CheeseActivity` as follows:

```
Observable<String> searchTextObservable = createTextChangeObservable();
```

Build and run your app. You should see the search kick off when you start typing text in the `TextView`:

![text-view-changes-simple](https://koenig-media.raywenderlich.com/uploads/2016/09/text-view-changes-simple-300x500.png)

## Filter Queries by Length ##

It doesn’t make sense to search for queries as short as a single letter. To fix this, let’s introduce the powerful `filter` operator.

`filter` passes only those items which satisfy a particular condition. `filter` takes in a `Predicate`, which is an interface that defines the test that input of a given type needs to pass, with a `boolean` result. In this case, the Predicate takes a `String` and returns `true` if the string’s length is two or more characters.

Replace `return textChangeObservable` in `createTextChangeObservable()` with the following code:

```
return textChangeObservable
    .filter(new Predicate<String>() {
      @Override
      public boolean test(String query) throws Exception {
        return query.length() >= 2;
      }
    });
```

Resolve the ambiguous `Predicate` import with:

```
importio.reactivex.functions.Predicate;
```

Everything will work exactly the same, except that text queries with `length` less than `2` won’t get sent down the chain.

Run the app; you should see the search kick off only when you type the second character:

![filter-0](https://koenig-media.raywenderlich.com/uploads/2016/09/filter-0-300x500.png)

![filter-1](https://koenig-media.raywenderlich.com/uploads/2016/09/filter-1-300x500.png)

## Debounce operator ##

You don’t want to send a new request to the server every time the query is changed by one symbol.

`debounce` is one of those operators that shows the real power of reactive paradigm. Much like the `filter` operator, `debounce`, filters items emitted by the observable. But the decision on whether the item should be filtered out is made not based on what the item is, but based on when the item was emitted.

`debounce` waits for a specified amount of time after each item emission for another item. If no item happens to be emitted during this wait, the last item is finally emitted:

![719f0e58_1472502674](https://koenig-media.raywenderlich.com/uploads/2016/08/719f0e58_1472502674-650x219.png) 

In `createTextChangeObservable()`, add the `debounce` operator just below the `filter` so that the `return` statement will look like the following code:

```
return textChangeObservable
    .filter(new Predicate<String>() {
      @Override
      public boolean test(String query) throws Exception {
        return query.length() >= 2;
      }
    }).debounce(1000, TimeUnit.MILLISECONDS);  // add this line

```

Run the app. You’ll notice that the search begins only when you stop making quick changes:

![debounce-500px](https://koenig-media.raywenderlich.com/uploads/2016/09/debounce-500px-1.gif)

`debounce` waits for 1000 milliseconds before emitting the latest query text.

## Merge Operator ##

You started by creating an observable that reacted to button clicks and then implemented an observable that reacts to text field changes. But how do you react to both?

There are a lot of operators to combine observables. The most simple and useful one is `merge`.

`merge` takes items from two or more observables and puts them into a single observable:

![ae08759b_1472502259](https://koenig-media.raywenderlich.com/uploads/2016/08/ae08759b_1472502259-650x296.png) 

Change the beginning of `onStart()` to the following:

```
Observable<String> buttonClickStream = createButtonClickObservable();
Observable<String> textChangeStream = createTextChangeObservable();
 
Observable<String> searchTextObservable = Observable.merge(textChangeStream, buttonClickStream);
```

Run your app. Play with the text field and the search button; the search will kick off either when you type finish typing two or more symbols or when you simply press the Search button.

## RxJava and Activity/Fragment lifecycle ##

Remember those `setCancellable` methods you set up? They won’t fire until the observable is unsubscribed.

The `Observable.subscribe()` call returns a `Disposable`. `Disposable` is an interface that has two methods:

```
public interface Disposable {
  void dispose();  // ends a subscription
  boolean isDisposed(); // returns true if resource is disposed (unsubscribed)
}
```

Add the following field to `CheeseActivity`:

```
private Disposable mDisposable;
```

In `onStart()`, set the returned value of `subscribe()` to `mDisposable` with the following code (only the first line changes):

```
mDisposable = searchTextObservable // change this line
  .observeOn(AndroidSchedulers.mainThread())
  .doOnNext(new Consumer<String>() {
    @Override
    public void accept(String s) {
      showProgressBar();
    }
  })
  .observeOn(Schedulers.io())
  .map(new Function<String, List<String>>() {
    @Override
    public List<String> apply(String query) {
      return mCheeseSearchEngine.search(query);
    }
  })
  .observeOn(AndroidSchedulers.mainThread())
  .subscribe(new Consumer<List<String>>() {
    @Override
    public void accept(List<String> result) {
      hideProgressBar();
      showResult(result);
    }
  });
```

Since you subscribed to the observable in `onStart()`, `onStop()` would be a perfect place to unsubscribe. 

Add the following code to *CheeseActivity.java*:

```
@Override
protected void onStop() {
  super.onStop();
  if (!mDisposable.isDisposed()) {
    mDisposable.dispose();
  }
}
```

And that’s it! :]

## Where to Go From Here? ##

You can download the final project from this tutorial [here](https://koenig-media.raywenderlich.com/uploads/2016/12/CheeseFinder-final.zip).

You’ve learned a lot in this tutorial. But that’s only a glimpse of the RxJava world. For example, there is [RxBinding](https://github.com/JakeWharton/RxBinding) , a library that includes most of the Android View APIs. Using this library, you can create a click observable by just calling `RxView.clicks(viewVariable)`.

To learn more about RxJava refer to the [ReactiveX documentation](http://reactivex.io/documentation/operators.html).

If you have any comments or questions, don’t hesitate to join the discussion below!
