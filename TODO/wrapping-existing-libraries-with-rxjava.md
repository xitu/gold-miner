>* 原文链接 : [Wrapping Existing Libraries With RxJava](http://ryanharter.com/blog/2015/07/07/wrapping-existing-libraries-with-rxjava/)
* 原文作者 : [Ryan Harter](http://ryanharter.com/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [尹述迪](http://yinshudi.com)
* 校对者: [markzhai](https://github.com/markzhai) , [Sausure](https://github.com/Sausure)

# 使用 RxJava 封装现有的库

[RxJava](https://github.com/ReactiveX/RxJava) 是最近 Android 世界里十分流行的一个库，并且有着充分的流行的理由。虽然函数式响应编程的学习曲线十分陡峭，但学会之后的好处是相当巨大的。

我曾遇到的一个问题是我需要使用一个不支持 RxJava，而是使用了监听模式的库，因此无法享受Rx的很多在可组合性方面的便利。

我碰到这个实际问题是在[集成 OpenIAB](http://ryanharter.com/blog/2015/07/04/using-all-the-app-stores/) 至最新版本的 [Fragment](https://play.google.com/store/apps/details?id=com.pixite.fragment) 时。更困难的是,[OpenIAB](http://onepf.org/openiab/) 使用`startActivityForResult`来启动一个新的 Activity 并返回一个结果。这使我开始思考，如何将 OpenIAB 和 RxJava 结合在一起使用呢？

## 将它封装起来

解决方案是将现有的库用 Rx 封装起来。这实际上非常简单，并且这些基本的原则能应用于任何基于监听器的库。

如果你的库拥有可用的同步方法，那么将其用 RxJava 封装起来的最好的方式是使用`Observable.defer()`。这会简单地延迟这个调用直到 observable 被订阅，然后在 subscription 的分配线程中执行。
```
    public Observable
         wrappedMethod() {
          return Observable.defer(() -> {
            return Observable.just(library.synchronousMethod());
          });
        }
```
这是迄今为止最简单的封装现有的库的方法。并且好于使用库的监听器，因为那种混杂在不同线程中的处理方式会令人感到困惑。

在某些情况下，比如 OpenIAB 中，不是所有的方法都支持写成同步的调用。这时候，我们就必须使用一些不同的方法来封装这个库了。

## API

我喜欢由外而内地构建一个库<sup>[1](http://ryanharter.com/blog/2015/07/07/wrapping-existing-libraries-with-rxjava/#sub-1)</sup>，因此我们首先需要定义我们的 API。
```
public interface InAppHelper {

  /**
   * Sets up the InAppHelper if it hasn't been already.
   */
  Observable setup();

  /**
   * Returns the Inventory based on the supplied skus.
   */
  Observable queryInventory(List skus);

  /**
   * Begins the purchase flow for the specified sku.
   */
  Observable purchase(String sku);
}
```
这三个方法在 OpenIAB 中的基本实现有些小小的不同。`setup()`使用了一个标准的回调接口，`queryInventory()`能同步使用，但会抛出一个必须被 catch 的异常，`purchase()`使用了一个监听器，但也依赖于`startActivityForResult`。

让我们分别看看如何用 RxJava 中的 Observable 封装这几种类型的方法。

>####温馨小贴士
我在代码示例中使用了 Java 8的 lambdas 语法来使代码看起来更简洁，但我并未将它用在工作中。如果谁非想在工作中使用它，可以使用开源项目[Retrolambda](https://github.com/evant/gradle-retrolambda)，恩，不用谢。

## 用 RxJava 封装带有监听器的方法

封装那些使用了监听器的方法时，`Observable.just()`并不管用，因为它一般没有返回值。我们必须使用`Observable.create()`,这样我们就可以将监听器的结果回调给 subscriber。
```
public Observable setup() {
  return Observable.create(subscriber -> {
    if (!helper.setupSuccessful()) {
      helper.startSetup(result -> {
        if (subscriber.isUnsubscribed()) return;

        if (result.isSuccess()) {
          subscriber.onNext(null);
          subscriber.onCompleted();
        } else {
          subscriber.onError(new IabException(result.getMessage()));
        }
      });
    } else {
      subscriber.onNext(null);
      subscriber.onComplete();
    }
  });
}
```

一步一步地看上面的代码，你会发现我们可以在`setup()`方法中使用`Observable.create()`创建一个 Observable，并在`OnSubscribe`代码块(译者注：即 lambda 表达式`subscriber -> {}`中的代码)中调用我们基于监听器的方法。在这些代码中，**我们实现自己的监听器**，并将结果传给相应的 subscriber。

具体到这个示例中，我们在 OnSubscribe 类中调用`helper.startSetup()`方法，通过我们自己实现的`OnIabSetupFinishedListener`将结果传递给相应的 subscriber。

由于监听器总是会被调用，而不管 subsriber 还是否需要，我们必须先调用`subscriber.isUnsubscribed()`检查一下，以此来避免发送不必要的消息。

注意，如果通过检查`helper.setupSuccessful()`发现 helper 已经设置好了，我们可以轻松地避免调用消耗巨大的`startSetup()`.比如在这个示例中，我们就可以直接调用`subscriber.onNext()`。

## 封装抛出异常的同步方法

第二个我们必须实现的方法是`queryInventory()`,它能被同步调用，但我们不能使用`Observable.just()`方法，因为它抛出的`IabException`并不是`RuntimeException`的子类，因此必须被捕获。

我们可以很轻松地用`Observable.defer()`来解决这个问题。我们将同步调用的代码用 try-catch 包起来，并根据结果返回`Observable.just()`或是`Observable.error()`.
```
public Observable queryInventory(final List skus) {
  return Observable.defer(() -> {
    try {
      return Observable.just(helper.queryInventory(skus));
    } catch (IabException e) {
      return Observable.error(e);
    }
  });
}
```

这是一个非常简单的例子。有点需要注意的是返回`Observable.error()`并不是最好的方法。如果这个异常是可以接受的，那你需要返回一个有用的带有值的 Observable。记住，`onError()`只能在 subscription 不再有用时被调用。

## 封装使用了监听器和 Activity Results 的方法

最后一个我们需要实现的方法，`purchase()`，和上面监听器的示例类似，但它因为使用了`startActivityForResult`而更为复杂。由于这里同样使用了监听器，因此并不改变我们的 Observable 实现，我们只需要在我们的 Helper 接口里增加一个方法，以便通过它返回 activity 的结果。

由于这和第一个监听器的例子类似，我们直接来看 OpenIAB 的实现。
```
public Observable purchase(final String sku) {
  return Observable.create(subscriber -> {
    helper.launchPurchaseFlow(activity, sku, REQUEST_CODE_PURCHASE, (result, info) -> {
      if (subscriber.isUnsubscribed()) return;

      if (result.isSuccess() || result.getResponse() == IabHelper.BILLING_RESPONSE_RESULT_ITEM_ALREADY_OWNED) {
        subscriber.onNext(info);
        subscriber.onCompleted();
      } else {
        subscriber.onError(new InAppHelperException(result.getMessage()));
      }
    });
  });
}

public boolean handleActivityResult(int requestCode, int resultCode, Intent data) {
  return helper.handleActivityResult(requestCode, resultCode, data);
}
```
如你所见，`handleActivityResult()`方法只是简单地将结果传递给 IabHelper 来处理。如果那个 activity 的结果和我们的请求相匹配，我们创建的监听器会被调用，然后监听器再反过来调用我们的 subscriber 方法。

再次强调，我们需要检查`subscriber.isUnsubscribed()`来确保还有观察者需要我们的结果。

## Rx无处不在
这些只是几个简单的例子来演示如何用 RxJava 将现有的库封装起来。这能帮你灵活地在你的 Android 应用中使用函数式响应编程，并享受它的诸多好处。
