# 使用 RxJava 包裹现存的库

>* 原文链接 : [Wrapping Existing Libraries With RxJava](http://ryanharter.com/blog/2015/07/07/wrapping-existing-libraries-with-rxjava/)
* 原文作者 : [Ryan Harter](http://ryanharter.com/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [尹述迪](http://yinshudi.com)
* 校对者:

[RxJava](https://github.com/ReactiveX/RxJava) 是最近 Android 世界里最流行的一个库，而且当之无愧。同时，考虑到函数式响应编程的学习曲线十分陡峭，RxJava 的好处相当之大。

我曾经遇到过一个问题：我需要使用一个库，但它并不支持 RxJava，而是用 Listener 模式取而代之。因此我无法享受很多 Rx 的好处。

我偶然发现这个现实的问题是在[集成OpenIAB](http://ryanharter.com/blog/2015/07/04/using-all-the-app-stores/)至最新版本的[Fragment](https://play.google.com/store/apps/details?id=com.pixite.fragment)时。更糟糕的是,[OpenIAB](http://onepf.org/openiab/)使用`startActivityForResult`来启动一个新的 Activity 并返回一个结果。这使我开始思考，如何将 OpenIAB 和 RxJava 结合在一起使用呢？

## 将它包裹起来

解决方案是将现有的库用 Rx 包裹起来。这实际上非常简单，并且这些基本的原则能应用于任何基于 listener 的库。

如果你的库拥有可用的同步方法，那么将其用RxJava 包裹起来的最好的方式是使用`Observable.defer()`。这种方式下，observable 会被延迟到它被订阅时调用，并在指定的线程中执行操作。
```
    public Observable
         wrappedMethod() {
          return Observable.defer(() -&gt; {
            return Observable.just(library.synchronousMethod());
          });
        }
```
这是迄今为止最简单的包裹现存的库的方法。这也优于使用库的 listeners ，因为那种混杂在不同线程中的处理方式实在令人难以理解。

在某些情况下，比如 OpenIAB中，不是所有的方法都支持写成同步的调用。这时候，我们就必须使用一些不同的方法来包裹这个库了。

## API

我喜欢在外部构建库，因此我们首先需要定义我们的 API。
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
这三个方法在 OpenIAB 中的基本实现有些小小的不同。`setup()`使用了一个标准的回调接口，`queryInventory()`能同步使用，但你必须捕获它抛出的异常，`purchase()`使用一个 listener，但也依赖于`startActivityForResult`。

让我们分别看看如何用 RxJava 中的 Observable 包裹这几种类型的方法。

####温馨小贴士
我在代码示例中使用了 Java 8的 lambdas 语法来使代码看起来更简洁，但我并未将它用在产品中。如果谁非想在产品中使用它，可以使用开源项目[Retrolambda](https://github.com/evant/gradle-retrolambda)，恩，不用谢。

## 用 RxJava 包裹带有监听的方法

包裹那些使用 listeners 的方法时，`Observable.just()`并不管用，因为它一般没有返回值。我们必须用`Observable.create()`,这样我们就可以将 Listener  的结果回调给 subscriber。
```
    public Observable setup() {
      return Observable.create(subscriber -&gt; {
        if (!helper.setupSuccessful()) {
          helper.startSetup(result -&gt; {
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

一步一步地看上面的代码，你会发现我们可以在`setup()`方法中使用`Observable.create()`创建一个 Observable，并在`OnSubscribe`代码块中调用我们基于 listener 的方法。在这些代码中，**我们实现自己的 Listener**，并将结果结果传给相应的 subscriber。

具体到这个示例中，我们在 OnSubscribe 中调用`helper.startSetup()`方法，通过我们自己实现的`OnIabSetupFinishedListener`将结果传递给相应的 subscriber。

由于 listener 总是会被调用，而不管 subsriber 还是否需要，我们必须先调用`subscriber.isUnsubscribed()`检查一下，以此来避免发送不必要的消息。

注意，如果通过检查`helper.setupSuccessful()`发现 helper 已经设置好了，我们可以轻松地避免调用消耗巨大的`startSetup()`.比如在这个示例中，我们就可以直接调用`subscriber.onNext()`。

## 包裹抛出异常的同步方法

第二个我们必须实现的方法是`queryInventory()`,它能被同步调用，但我们不能使用`Observable.just()`方法，因为它抛出的`IabException`并不是`RuntimeException`的子类，因此必须被捕获。

我们可以很轻松地用`Observable.defer()`来解决这个问题。我们将同步调用的代码用 try-catch 包起来，并根据结果返回`Observable.just()`或是`Observable.error()`.
```
    public Observable queryInventory(final List skus) {
      return Observable.defer(() -&gt; {
        try {
          return Observable.just(helper.queryInventory(skus));
        } catch (IabException e) {
          return Observable.error(e);
        }
      });
    }
```

这是一个非常简单的例子。有点需要注意的是返回`Observable.error()`并不是最好的方法。如果这个异常是可以接受的，那你需要返回一个有用的带有值的Observable。记住，`onError()`只能在 subscription 不再有用时被调用。

## 包裹使用了 Listeners 和 Activity Results 的方法

最后一个我们需要实现的方法，`purchase()`，和上面 listener 示例类似，但它因为使用了`startActivityForResult`而更为复杂。由于这里同样使用了 Listener，因此并不改变我们的 Observable 实现，我们只需要在我们的 Helper 接口里增加一个方法，以便通过它返回 activity 的结果。

由于这和第一个 listener 的例子类似，我们直接来看 OpenIAB 的实现。
```
    public Observable purchase(final String sku) {
      return Observable.create(subscriber -&gt; {
        helper.launchPurchaseFlow(activity, sku, REQUEST_CODE_PURCHASE, (result, info) -&gt; {
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
如你所见，`handleActivityResult()`方法只是简单地将结果传递给 IabHelper 来处理。如果那个 activity 的结果和我们的请求相匹配，我们创建的 Listener 会被调用，然后 Listener 再反过来调用我们的 subscriber 方法。

再次强调，我们需要检查`subscriber.isUnsubscribed()`来确保还有观察者需要我们的结果。

## Rx全世界
这些只是几个简单的例子来演示如何用 RxJava 将现存的库包裹起来。这能帮你灵活地在你的 Android 应用中使用函数式响应编程，并享受它的诸多好处。
