> * 原文地址：[RxAndroid Tutorial](https://www.raywenderlich.com/141980/rxandroid-tutorial)
* 原文作者：[Artem Kholodnyi](https://www.raywenderlich.com/u/mlatu)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Jamweak](https://github.com/jamweak)
* 校对者：[Zhiwei Yu](https://github.com/Zhiw), [Tanglie](https://github.com/tanglie1993)

# RxAndroid 中文教程

如果你是新人，你可能会想订阅我的 [RSS 流](http://www.raywenderlich.com/feed/)，或者关注我的 [Twitter](http://twitter.com/rwenderlich)。感谢阅读！

![AndroidReactive-feature](https://koenig-media.raywenderlich.com/uploads/2016/11/AndroidReactive-feature-250x250.png)

有人曾说，我们一生都应去追求积极主动的处事方式，而不是响应式。然而，这种思想并不适用开发 Android 程序。:]

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

- 将多个 observable 合并成一个

但愿你喜欢奶酪——因为我们将使用一个寻找奶酪的应用程序来讲述上面的这些概念！:]

## 准备开始 ##

下载 [学习本教程的起步工程](https://koenig-media.raywenderlich.com/uploads/2016/11/CheeseFinder-starter-2.zip)，并使用 Android Studio 打开。

你只会用到 *CheeseActivity.java* 文件。`CheeseActivity` 这个类继承自 `BaseSearchActivity`；花些时间看一下 `BaseSearchActivity` 类，熟悉一下你将使用到的一些东西：

- `showProgressBar()`: 展示进度条的方法…

- `hideProgressBar()`: …隐藏进度条的方法

- `showResult(List<String> result)`: 展示奶酪列表的方法

- `mCheeseSearchEngine`: 一个 `CheeseSearchEngine` 的实例。它具有 `search` 方法，你可以调用它来查询奶酪。这个方法接收一个文本查询，返回一个匹配奶酪的列表：

编译并在你的 Android 设备或模拟器上运行这个工程。 你将会看到一个空荡荡的查询页面。

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

你可能已经完成了一些响应式的编程，即便当时你并不了解它。

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

这是个非常错误的 observable，因为它违背了 Observable 规范，在发出结束信号之后，又发出了其它事件。

## 如何创建一个 Observable ##

有许多库能够帮助你创建一个几乎覆盖所有类型事件的 Observable。然而，有时你必须自己做，学习如何做是个好办法！

你可以使用 `Observable.create()` 方法创建一个 Observable。下面是方法签名：

```
Observable<T> create(ObservableOnSubscribe<T> source)
```

看起来很简洁方便，但是它是什么意思？“source” 又是什么意思？要了解这个方法签名，你必须得知道什么是 `ObservableOnSubscribe`。它是一个接口，声明如下：

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

为了让整个过程形象化，来设想调节水流大小的水龙头。水管就相当于一个 `Observable`，如果你有办法从中汲取的话，它就会释放出水流。你构建一个可以开关的水龙头，就像创建一个 `ObservableEmitter`，随后用 `Observable.create()` 来连接水管。结果就是一个理想的水龙头。:]

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

既然已经定义好了 Observable，你需要为它设置一个订阅者。在这之前，你需要了解更多的接口，`Consumer`。它是一种从 emitter 中接收值的简便方式。

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

3. 重写 `accept()` 方法, 当 oberservable 发出事件后会回调此方法。

4. 最后, 执行查询并展示查询结果。

编译并运行应用，输入一些字符然后点击 *Search* 按钮。你应该看到一个匹配你查询规则的奶酪列表：

![enter-and-press-300x500](https://koenig-media.raywenderlich.com/uploads/2016/09/enter-and-press-300x500.png)

看起来很好吃的样子! :]

## RxJava 线程模型 ##

你刚才已经初尝了响应式编程。现在还有一个问题：当点击查询按钮时，UI 界面会卡住几秒钟的时间。

你也可能注意到在 Studio 的 Android Monitor 一栏会有如下几行：

```
> 08-24 14:36:34.554 3500-3500/com.raywenderlich.cheesefinder I/Choreographer: Skipped 119 frames!  The application may be doing too much work on its main thread.
```

发生这种情况是因为在主线程中执行了 `search` 操作。如果 `search` 操作中存在网络访问请求， Android 应用会崩溃，并会发出一个 NetworkOnMainThreadException 异常。是时候来修复这个问题了。

RxJava 中一个流传甚广的错误观点在于它默认是支持多线程的，类似于 `AsyncTask`，然而，如非特别指定，RxJava 会在它被调用的线程中执行所有的操作。

你可以通过使用 `subscribeOn` 和 `observeOn` 操作符来改变这一行为。

`subscribeOn` 应该只会在调用链中被调用一次。如果并非如此的话，那会以第一次调用时的线程为准。
`subscribeOn` 指定了 observable 在哪个线程中被订阅（例如，被创建）。如果你在 Android 的 View 中使用 observable 发出事件，你需要确认订阅会在 Android UI 线程中执行。

另一方面，在调用链中调用多少次 `observeOn` 都是可以的。`observeOn` 指定了链中的下一个操作符执行的线程，例如：

```
myObservable // observable 将会在 i/o 线程被订阅
  .subscribeOn(Schedulers.io())
  .observeOn(AndroidSchedulers.mainThread())
  .map(/* 将会在主线程被调用 */)
  .doOnNext(/* ...下面的代码会等到下次 observeOn 时执行 */)
  .observeOn(Schedulers.io())
  .subscribe(/* 将会在 i/o 线程执行 */);
```

最有用的调度器有如下几个：

- `Schedulers.io()`: 适合在 I/O 线程的工作，例如网络请求或磁盘操作。

- `Schedulers.computation()`: 计算性的任务，比如事件轮循或者处理回调等。

- `AndroidSchedulers.mainThread()` 在主线程中执行下个操作符的操作。

## Map 操作符 ##

`map` 操作符对 observable 发出的每一个事件应用一次函数变换，返回另外的一个发出函数执行结果类型事件的 observable。你也会用到它来处理线程调度问题。

如果你有一个叫做 `numbers` 的 observable 发出如下事件：

![map-0](https://koenig-media.raywenderlich.com/uploads/2016/08/map-0-1.png)

并且你按着如下方式使用 `map` 操作符:

```
numbers.map(new Function<Integer, Integer>() {
  @Override
  public Integer apply(Integer number) throws Exception {
    return number * number;
  }
}
```

结果如下:

![map-1](https://koenig-media.raywenderlich.com/uploads/2016/08/map-1-1.png)

这是一种用较少的代码来遍历多个事件条目的巧妙方式。让我开始使用它吧！

修改 `CheeseActivity` 类中的 `onStart()` 成如下形式：

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

当看到提示时, 解决有歧义的 `Function` 依赖:

```
importio.reactivex.functions.Function;
```

重新回顾一下上面的代码:

1. 首先, 指定下一个操作符应该在 I/O 线程执行；

2. 对于每一次查询，都会返回一个结果列表；

3. 最后, 指定该位置处的代码应当在主线程，而不是 I/O 线程中运行。 在 Android 中, 所有对 `View` 的操作都应保证在主线程中执行。

编译并运行工程. 现在 UI 界面哪怕在执行查询时应该也不会再卡顿了。

## 利用 doOnNext 来显示进度条 ##

是时候来展示进度条了!

这需要用到 `doOnNext` 操作符。`doOnNext` 需要一个 `Consumer` 参数，它能让你在每次 observable 发出事件的时候做一些处理。

同样地，需要在 `CheeseActivity` 类中修改 `onStart()` 成如下:

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

依次解释 3 条注释:

1. 保证下一个操作符将会在主线程中执行；

2. 添加 `doOnNext` 操作符以便 `showProgressBar()` 方法会在 observable 每次发出事件时被回调；

3. 当你想要展示查询结果时，不要忘记调用 `hideProgressBar()` 方法。

编译并运行工程。 当你开始查询时，你应该会看到进度条:

![progressbar](https://koenig-media.raywenderlich.com/uploads/2016/09/progressbar-300x500.png)

## 观察文本改变 ##

如果你想在用户键入一些文字时自动执行搜索，就想Google一样，该怎样做呢？

首先, 你需要订阅 `TextView` 的文本改变. 在 `CheeseActivity` 类中添加如下代码:

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

下面是每一步的详细解释:

1. 声明一个方法，返回一个发出文本改变事件的 observable；

2. 使用 `create()`方法创建 `textChangeObservable`, 它需要一个 `ObservableOnSubscribe` 参数；

3. 当 observer 进行订阅时, 第一件事就是要创建一个 `TextWatcher`.

4. 我们并不对 `beforeTextChanged()` 和 `afterTextChanged()` 方法感兴趣。当用户键入内容触发 `onTextChanged()` 方法时, 将文本值传递给 observer；

5. 通过 `addTextChangedListener()` 方法将观察器添加到 `EditText` 上；

6. 不要忘记移除观察器。调用 `emitter.setCancellable()` 并重写 `cancel()` 来调用 `removeTextChangedListener()` 方法；

7. 最后, 返回创建的 observable。

为了看到这个 observable 起作用, 将 `CheeseActivity` 类的 `onStart()` 方法中的 `searchTextObservable` 替换如下:

```
Observable<String> searchTextObservable = createTextChangeObservable();
```

编译并运行工程。你将会看到在 `TextView` 中键入内容后，即会开始查询：

![text-view-changes-simple](https://koenig-media.raywenderlich.com/uploads/2016/09/text-view-changes-simple-300x500.png)

## 按长度过滤查询 ##

查询只有一个输入字母的结果是没有意义的。为了解决这个问题，让我们来引入强大的 `filter` 操作符。`filter` 只会让符合特定条件的事件通过。它采用一个 `Predicate` 作为参数，`Predicate` 是一个接口，在其中定义了一个输入指定的类型才会通过的测试，它返回一个 `boolean` 类型的结果。在这个例子中，Predicate 有一个 `String` 类型的入参，并在字符串的长度大于等于两个字符时返回 `true`。


用下面的代码替换 `createTextChangeObservable()` 中的 `return textChangeObservable`:

```
return textChangeObservable
    .filter(new Predicate<String>() {
      @Override
      public boolean test(String query) throws Exception {
        return query.length() >= 2;
      }
    });
```

解决有歧义的 `Predicate` 依赖:

```
import io.reactivex.functions.Predicate;
```

其它流程都保持不变，除了字符长度小于 `2` 的查询不会向下传递执行。

运行这个工程；你将会看到只有当键入第二个字符时才会执行查询操作:

![filter-0](https://koenig-media.raywenderlich.com/uploads/2016/09/filter-0-300x500.png)

![filter-1](https://koenig-media.raywenderlich.com/uploads/2016/09/filter-1-300x500.png)

## 防抖动操作符 ##

你并不会想每次改变一个字符时都向服务器去请求一次查询。

`防抖动` 是能展示响应式编程规范强大之处的操作符之一。非常类似 `filter` 操作符, `防抖动`, 对 observable 发出的事件进行过滤。但是决定事件该不该被过滤掉的原则不是靠判断发出的是什么事件，而是取决于何时发出的事件。

`防抖动` 会在每个事件发出后等待指定的时间。如果在这等待期间没有其它事件发生，那么最后保留的事件将会被发送出去：

![719f0e58_1472502674](https://koenig-media.raywenderlich.com/uploads/2016/08/719f0e58_1472502674-650x219.png) 

在 `createTextChangeObservable()` 方法中, 在 `filter` 操作符后添加 `debounce` 操作符，代码如下所示：

```
return textChangeObservable
    .filter(new Predicate<String>() {
      @Override
      public boolean test(String query) throws Exception {
        return query.length() >= 2;
      }
    }).debounce(1000, TimeUnit.MILLISECONDS);  // add this line

```

运行应用，你将会注意到只有当你停止快速键入时，才会执行查询操作：

![debounce-500px](https://koenig-media.raywenderlich.com/uploads/2016/09/debounce-500px-1.gif)

`防抖动`会等待 1000 毫秒后发出最近一次的查询事件。

## 合并操作符 ##

刚开始时，你创建了一个响应查询按钮点击事件的 observable，接着又实现了一个响应文字变化的 observable。但是怎样做到响应两者呢？

RxJava 中有许多合并 observable 的操作符。最简便易用的就是 `merge`。

`merge` 接收两个或更多 observable 发出的事件，然后将它们放入一个 observable 中：

![ae08759b_1472502259](https://koenig-media.raywenderlich.com/uploads/2016/08/ae08759b_1472502259-650x296.png) 

将 `onStart()` 的开头改成如下形式:

```
Observable<String> buttonClickStream = createButtonClickObservable();
Observable<String> textChangeStream = createTextChangeObservable();
 
Observable<String> searchTextObservable = Observable.merge(textChangeStream, buttonClickStream);
```

运行应用。试一试键入文字或者点击查询按钮；查询操作会在完成输入两个以上的字符后或是点击查询按钮时被执行。

## RxJava 与 Activity/Fragment 的生命周期 ##

还记得你设置的那些　`setCancellable`　方法吗？除非这些 observable 被取消订阅，否则它们不会被触发。

`Observable.subscribe()` 方法调用之后会返回一个 `Disposable`。 `Disposable` 是一个包括两个方法的接口:

```
public interface Disposable {
  void dispose();  // 结束订阅
  boolean isDisposed(); // 当订阅结束后返回 true
}
```

将如下字段添加到 `CheeseActivity` 类中:

```
private Disposable mDisposable;
```

在 `onStart()` 中, 添加如下代码将 `subscribe()` 方法的返回值赋值给 `mDisposable` (只需改变第一行):

```
mDisposable = searchTextObservable // 修改此行
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

既然已经在 `onStart()` 中进行了订阅，那么 `onStop()` 是取消订阅的极佳地点。

将这段代码添加到 *CheeseActivity.java* 类中:

```
@Override
protected void onStop() {
  super.onStop();
  if (!mDisposable.isDisposed()) {
    mDisposable.dispose();
  }
}
```

就是这样！完成！:]

## 后续 ##

你可以从[这里](https://koenig-media.raywenderlich.com/uploads/2016/12/CheeseFinder-final.zip)下载本教程中的最终版本项目。

在本教程中，你已经学到了许多知识。但这仅是 RxJava 世界的一小部分。比如说，还有 [RxBinding](https://github.com/JakeWharton/RxBinding) , 一个包含大多数 Android View API 的库。使用这个库后，你只需调用 `RxView.clicks(viewVariable)` 来创建一个发出点击事件的 observable。

想要了解更多关于 RxJava 的知识，请参考 [ReactiveX 文档](http://reactivex.io/documentation/operators.html).

如果你有任何意见或者疑问，不要犹豫，立刻加入到下面的讨论中来！
