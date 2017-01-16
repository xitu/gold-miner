> * 原文地址：[RxAndroid Tutorial](https://www.raywenderlich.com/141980/rxandroid-tutorial)
* 原文作者：[Artem Kholodnyi](https://www.raywenderlich.com/u/mlatu)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# [RxAndroid Tutorial](https://www.raywenderlich.com/141980/rxandroid-tutorial)#

If you're new here, you may want to subscribe to my [RSS feed](http://www.raywenderlich.com/feed/) or follow me on [Twitter](http://twitter.com/rwenderlich). Thanks for visiting!

![AndroidReactive-feature](https://koenig-media.raywenderlich.com/uploads/2016/11/AndroidReactive-feature-250x250.png)

They say you should develop a proactive mindset in life, not a reactive one. That does not apply to Android programming, however! :]

Reactive programming is not just another API. It’s a whole new paradigm and a very useful one. *RxJava* is a reactive implementation used on Android. Android is a perfect place to start your exploration of the reactive world. It’s made even easier with *RxAndroid*, a library that wraps asynchronous UI events to be more RxJava like.

Don’t be scared — I’ll bet the basic concept of reactive programming is known to you even if you are not aware of it yet. :]

*Note:* This tutorial requires good knowledge of Android and Java. To get up to speed, check out our [Android Development Tutorials](https://www.raywenderlich.com/category/android) first and return to this tutorial when you’re ready.

In this RxAndroid Tutorial you will learn how to do the following:

- What Reactive Programming is

- What an *observable* is

- Turn asynchronous events like button clicks and text field context changes into observables

- Transform observable items

- Filter observable items

- Specify the thread on which code should be executed

- Combine several observables into one

I hope you like cheese — because you’re going to build a cheese-finding app as you learn the concepts above! :] 

## Getting Started ##

Download [the starter project for this tutorial](https://koenig-media.raywenderlich.com/uploads/2016/11/CheeseFinder-starter-2.zip) and open it in Android Studio.

You’ll be working exclusively in *CheeseActivity.java*. The `CheeseActivity` class extends `BaseSearchActivity`; take some time to explore `BaseSearchActivity` and check out the following features ready for your use:

- `showProgressBar()`: A method to show a progress bar…

- `hideProgressBar()`: … and a method to hide it.

- `showResult(List<String> result)`: A method to display a list of cheeses.

- `mCheeseSearchEngine`: A field which is an instance of `CheeseSearchEngine`. It has a `search` method which you call when you want to search for cheeses. It accepts a text search query and returns a list of matching cheeses: 

Build and run the project on your Android device or emulator. You should see a gloriously empty search screen:

![starter-300x500](https://koenig-media.raywenderlich.com/uploads/2016/09/starter-300x500.png)

## What is Reactive Programming? ##

Before creating your first observable, indulge yourself with a bit of a theory first. :]

In *imperative* programming, an expression is evaluated once and a value is assigned to a variable:

```
int a = 2;
int b = 3;
int c = a * b; // c is 6
 
a = 10;
// c is still 6
```

On the other hand, *reactive* programming is all about responding to value changes.

You have probably done some reactive programming — even if you didn’t realize it at the time.

- 
Defining cell *values* in spreadsheets is similar to defining variables in imperative programming.

- 
Defining cell *expressions* in spreadsheets is similar to defining and operating on observables in reactive programming.

Take the following spreadsheet that implements the example from above:

![](https://i.imgur.com/W8YCp8u.png)

The spreadsheet assigns cell B1 with a value of 2, cell B2 with a value of 3 and a third cell, B3, with an expression that multiplies the value of B1 by the value of B2. When the value of either of the the components referenced in the expression changes, the change is observed and the expression is re-evaluated automagically in B3:

![](https://i.imgur.com/Mqqoi8D.png)

## RxJava Observable Contract ##

RxJava makes use of the *Observer pattern*.

*Note*: To refresh your memory about the Observer pattern you can visit [Common Design Patterns for Android](https://www.raywenderlich.com/109843/common-design-patterns-for-android).

In the Observer pattern, you have objects that implement two key RxJava interfaces: `Observable` and `Observer`. When an `Observable` changes state, all `Observer` objects subscribed to it are notified.

Among the methods in the `Observable` interface is `subscribe()`, which an `Observer` will call to begin the subscription.

From that point, the `Observer` interface has three methods which the `Observable` calls as needed:

- `onNext(T value)` provides a new item of type T to the `Observer`

- `onComplete()` notifies the `Observer` that the `Observable` has finished sending items

- `onError(Throwable e)` notifies the `Observer` that the `Observable` has experienced an error

As a rule, a well-behaved `Observable` emits zero or more items that could be followed by either completion or error. 

That sounds complicated, but some examples will easily explain.


A network request observable usually emits a single item and immediately completes:

![network-request](https://koenig-media.raywenderlich.com/uploads/2016/08/network-request-650x186.png)

The circle represents an item that has been emitted from the observable and the black block represents a completion or error .

A mouse movement observable would emit mouse coordinates but will never complete:

![mouse-coords](https://koenig-media.raywenderlich.com/uploads/2016/08/mouse-coords-650x186.png)

Here you can see multiple items that have been emitted but no block showing the mouse has completed or raised an error.

No more items can be emitted after an observable has completed. Here’s an example of a misbehaving observable that violates the Observable contract:

![misbehaving-stream](https://koenig-media.raywenderlich.com/uploads/2016/08/misbehaving-stream-650x186.png) 

That’s a bad, bad observable because it violates the Observable contract by emitting an item after it signaled completion.

## How to Create an Observable ##

There are many libraries to help you create observables from almost any type of event. However, sometimes you just need to roll your own. Besides, it’s a great way to learn!

You’ll create an Observable using `Observable.create()`. Here is its signature:

```
Observable<T> create(ObservableOnSubscribe<T> source)
```

That’s nice and concise, but what does it mean? What is the “source?” To understand that signature, you need to know what an `ObservableOnSubscribe` is. It’s an interface, with this contract:

```
public interface ObservableOnSubscribe<T> {
  void subscribe(ObservableEmitter<T> e) throws Exception;
}
```

Like an episode of a J.J. Abrams show like “Lost” or “Westworld,” that answers some questions while inevitably asking more. So the “source” you need to create your `Observable` will need to expose `subscribe()`, which in turn requires whatever’s calling it to provide an “emitter” as a parameter. What, then, is an emitter?

RxJava’s `Emitter` interface is similar to the `Observer` one:

```
public interface Emitter<T> {
  void onNext(T value);
  void onError(Throwable error);
  void onComplete();
}
```

An `ObservableEmitter`, specifically, also provides a means to cancel the subscription.

To visualize this whole situation, think of a water faucet regulating the flow of water. The water pipes are like an `Observable`, willing to deliver a flow of water if you have a means of tapping into it. You construct a faucet that can turn on and off, which is like an `ObservableEmitter`, and connect it to the water pipes in `Observable.create()`. The outcome is a nice fancy faucet. :]

An example will make the situation less abstract and more clear. It’s time to create your first observable! :]

## Observe Button Clicks ##

Add the following code inside the `CheeseActivity` class:

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

Here’s what’s going on in the code above:

1. You declare a method that returns an observable that will emit strings.

2. You create an observable with `Observable.create()`, and supply it with a new `ObservableOnSubscribe`.

3. You define your `ObservableOnSubscribe` by overriding `subscribe()`.

4. Set up an `OnClickListener` on `mSearchButton`.

5. When the click event happens, call `onNext` on the emitter and pass it the current text value of `mQueryEditText`.

6. Keeping references can cause memory leaks in Java. It’s a useful habit to remove listeners as soon as they are no longer needed. But what do you call when you are creating your own `Observable`? For that very reason, `ObservableEmitter` has `setCancellable()`. Override `cancel()`, and your implementation will be called when the Observable is disposed, such as when the Observable is completed or all Observers have unsubscribed from it.

7. For `OnClickListener`, the code that removes the listener is `setOnClickListener(null)`.

Now that you’ve defined your Observable, you need to set up the subscription to it. Before you do, you need to learn about one more interface, `Consumer`. It’s a simple way to accept values coming in from an emitter.

```
public interface Consumer<T> {
  void accept(T t) throws Exception;
}
```

This interface is handy when you want to set up a simple subscription to an Observable.

The `Observable` interface requires several versions of `subscribe()`, all with different parameters. For example, you could pass a full `Observer` if you like, but then you’d need to implement all the necessary methods.

But if all you want out of your subscription is for the observer to respond to values sent to `onNext()`, you can use the version of `subscribe()` that takes in a single `Consumer` (the parameter is even named `onNext`, to make the connection clear).

You’ll do exactly that when you subscribe in your activity’s `onStart()`. Add the following code to *CheeseActivity.java*:

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

The import for `Consumer` is ambiguous; when prompted, import:

```
importio.reactivex.functions.Consumer;
```

Here’s an explanation of each step:

1. First, create an observable by calling the method you just wrote.

2. Subscribe to the observable with `subscribe()`, and supply a simple `Consumer`.

3. Override `accept()`, which will be called when the observable emits an item.

4. Finally, perform the search and show the results.

Build and run the app. Enter some letters and press the *Search* button. You should see a list of cheeses that match your request:

![enter-and-press-300x500](https://koenig-media.raywenderlich.com/uploads/2016/09/enter-and-press-300x500.png)

Sounds yummy! :]

## RxJava Threading Model ##

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
