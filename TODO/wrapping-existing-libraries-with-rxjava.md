>* 原文链接 : [Wrapping Existing Libraries With RxJava](http://ryanharter.com/blog/2015/07/07/wrapping-existing-libraries-with-rxjava/)
* 原文作者 : [Ryan Harter](http://ryanharter.com/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


[RxJava](https://github.com/ReactiveX/RxJava) is all the rage in the Android world lately, and with good reason. While Functional Reactive Programming has a bit of a steep learning curve, the benefits are enormous.

One issue I’ve run accross is the fact that I need to use libraries that don’t support RxJava, but use the Listener pattern instead, and therefore miss out on many of the composability benefits of Rx.

I ran into this exact issue while [integrating OpenIAB](http://ryanharter.com/blog/2015/07/04/using-all-the-app-stores/) into the latest release of [Fragment](https://play.google.com/store/apps/details?id=com.pixite.fragment). To make matters more difficult, [OpenIAB](http://onepf.org/openiab/) uses `startActivityForResult` to actually launch a new Activity and return a result. That made me wonder, how can I use OpenIAB with RxJava?

## Wrap It Up

The solution here is to wrap the existing library with some Rx. This is actually quite simple, and the basic rules can apply to any listener based library.

If the library you want to use has synchronous methods available, then the prefered way to wrap it with RxJava would be to use `Observable.defer()`, which simply delays the call until the observable has been subscribed to, and performs the action on the subscription’s assigned thread.

    public Observable
         wrappedMethod() {
          return Observable.defer(() -&gt; {
            return Observable.just(library.synchronousMethod());
          });
        }

This is by far the easiest way to wrap existing libraries and should be pefered over using a library’s listeners, as the mixed thread handling can get quite confusing.

In some cases, like with OpenIAB, not all methods are available as synchronous calls. For these cases, we must take a different approach to wrapping the library.

## The API

I like to build libraries from the outside in<sup>[1](http://ryanharter.com/blog/2015/07/07/wrapping-existing-libraries-with-rxjava/#sub-1)</sup>, so first we need to define our API.

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

Each of these three method’s underlying implementation in OpenIAB works a little bit differently. `setup()` uses a standard Listener callback interface, `queryInventory()` can be done synchronously but throws an Exception which must be caught, and `purchase()` uses a listener, but also relies on `startActivityForResult`.

Let’s take each of these one at a time to see how we can wrap each type of method call with an RxJava Observable.

#### <span>Note</span>

Though I don’t use it in production, I’m using Java 8 lambdas in the code examples for brevity. Others do use them in productions using [Retrolambda](https://github.com/evant/gradle-retrolambda), and you’re welcome to do that if you wish.</div>

## Wrapping Listener Methods in RxJava

When wrapping method calls that use listeners, things like `Observable.just()` don’t work, since there is usually no return value. Therefore, we have to use `Observable.create()` so that we can pass the result of the Listener callback to the subscriber.

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

To take this step by step, you can see in the `setup()` method that we are using `Observable.create()` to create an Observable, and in the `OnSubscribe` block we call our listener based method, **providing our own Listener implementation** that passes results to the subscriber accordingly.

In this case, that translates to calling the `helper.startSetup()` method inside our OnSubscribe class, passing our own `OnIabSetupFinishedListener` implementation that passes the result to the subscriber accordingly.

Since the listener will always be called, even if the subscriber no longer cares, we must first check `subscriber.isUnsubscribed()` to avoid sending messages no one cares about.

Notice that we can easily bypass the expensive `startSetup()` call if the helper is already set up by checking `helper.setupSuccessful()`. In that case we can call `subscriber.onNext()` directly.

## Wrapping Synchronous Methods That Throw Exceptions

The second method we have to implement, `queryInventory()`, can be done as a synchronous call, but we can’t use `Observable.just()` because the `IabException` it throws isn’t a `RuntimeException`, so it must be caught.

To accomplish this, we can easily use `Observable.defer()`, surround the synchronous call in a try-catch, and return either `Observable.just()` or `Observable.error()`, depending on the result.

    public Observable queryInventory(final List skus) {
      return Observable.defer(() -&gt; {
        try {
          return Observable.just(helper.queryInventory(skus));
        } catch (IabException e) {
          return Observable.error(e);
        }
      });
    }

This is a pretty simple case. One thing to note is that returning `Observable.error()` might not be the best approach. If the exception is recoverable, then you should return a useable Observable with some other value. Remember, `onError()` should only be called when the subscription is no longer usable.

## Wrapping Methods That User Listeners and Activity Results

The last method we need to implement, `purchase()`, is the same as the Listener example above, but it has the added complexity of using `startActivityForResult`. Since this is also using a Listener, this doesn’t really change our Observable implementation, we just need to add a method on our Helper interface so that we can pass the activity result through.

Since this is just about the same as our original Listener example, we’ll go straight to the OpenIAB implementation.

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

As you can see, our `handleActivityResult()` method simply passed the result through to the IabHelper to handle. If the activity result matches our request, the Listener we created will be called, which in turn calls our subscriber methods.

Again, we need to be sure to check `subscriber.isUnsubscribed()` to ensure we still have someone who cares about the result.

## Rx Everywhere

These are just a few examples showing how to wrap existing libraries in RxJava. That should help you consistently use Functional Reactive Programming throughout your Android apps, and take advantage of some of the many benefits.

