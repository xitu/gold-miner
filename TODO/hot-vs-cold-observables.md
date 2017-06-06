> * 原文地址：[Hot vs Cold Observables](https://medium.com/@benlesh/hot-vs-cold-observables-f8094ed53339)
> * 原文作者：[Ben Lesh](https://medium.com/@benlesh)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

---

# Hot vs Cold Observables

## TL;DR: You want a HOT observable when you don’t want to create your producer over and over again.

#### COLD is when your observable creates the producer

    // COLD
    var cold = new Observable((observer) => {
      var producer = new Producer();
      // have observer listen to producer here
    });

#### HOT is when your observable closes over the producer

    // HOT
    var producer = new Producer();
    var hot = new Observable((observer) => {
      // have observer listen to producer here
    });

### Getting deeper into what’s going on…

My last article about [Learning Observable By Building Observable](https://medium.com/@benlesh/learning-observable-by-building-observable-d5da57405d87) was mostly to illustrate that observables are just functions. The goal there was to demystify observables themselves, but it doesn’t really dive into one of the issues that seem to confuse people the most about observables: The notion of “hot” vs “cold”.

#### Observables are just functions!

Observables are functions that tie an observer to a producer. That’s it. They don’t necessarily set up the producer, they just set up an observer to listen to the producer, and generally return a teardown mechanism to remove that listener. The act of subscription is the act of “calling” the observable like a function, and passing it an observer.

#### What’s a “Producer”?

A producer is the source of values for your observable. It could be a web socket, it could be DOM events, it could be an iterator, or something looping over an array. Basically, it’s anything you’re using to get values and pass them to `observer.next(value)`.

### Cold Observables: Producers created *inside*

An observable is “cold” if its underlying producer is **created and activated **during subscription. This means, that if observables are functions, then the producer is created and activated by *calling that function.*

1. creates the producer
2. activates the producer
3. starts listening to the producer
4. unicast

The example below is “cold” because it creates and listens to the WebSocket *inside* of the subscriber function that is called when you subscribe to the Observable:

    const source = new Observable((observer) => {
      const socket = new WebSocket('ws://someurl');
      socket.addEventListener('message', (e) => observer.next(e));
      return () => socket.close();
    });

So anything that subscribes to `source` above, will get its own WebSocket instance, and when it unsubscribes, it will `close()` that socket. This means that our source is really only ever unicast, because the producer can only send to one observer. [Here is a basic JSBin illustrating the idea.](http://jsbin.com/wabuguy/1/edit?js,output)

### Hot Observables: Producers created *outside*

An observable is “hot” if its underlying producer is either created or activated outside of subscription.¹

1. shares a reference to a producer
2. starts listening to the producer
3. multicast (usually²)

If we were to take our example above and move the creation of the WebSocket *outside* of our observable it would become “hot”:

    const socket = new WebSocket('ws://someurl');

    const source = new Observable((observer) => {
      socket.addEventListener('message', (e) => observer.next(e));
    });

Now anything that subscribes to `source` will share the same WebSocket instance. It will effectively multicast to all subscribers now. But we have a little problem: We’re no longer carrying the logic to teardown the socket with our observable. That means that things like errors and completions, as well as unsubscribe, will no longer close the socket for us. So what we really want is to make our “cold” observable “hot”. [Here is a JSBin showing this basic concept.](http://jsbin.com/godawic/edit?js,output)

#### Why Make A “Hot” Observable?

From the first example above showing a cold observable, you can see that there might be some problems with having all cold observables all the time. For one thing, if you’re subscribing to an observable more than once that is creating some scarce resource, like a web socket connection, you don’t want to create that web socket connection over and over. It’s actually really easy to create more than one subscription to an observable without realizing it too. Let’s say you want to filter all of the “odd” and “even” values out of your web socket subscription. You’ll end up creating two subscriptions in the following scenario:

    source.filter(x => x % 2 === 0)
      .subscribe(x => console.log('even', x));

    source.filter(x => x % 2 === 1)
      .subscribe(x => console.log('odd', x));

### Rx Subjects

Before we can make our “cold” observable “hot”, we need to introduce a new type: The Rx Subject. It has a few properties:

1. It’s an observable. It’s shaped like an observable, and has all the same operators.
2. It’s an observer. It duck-types as an observer. When subscribed to as an observable, will emit any value you “next” into it as an observer.
3. It multicasts. All observers passed to it via `subscribe()` are added to an internal observers list.
4. When it’s done, it’s done. Subjects cannot be reused after they’re unsubscribed, completed or errored.
5. It passes values through itself. To restate #2, really. If you `next` a value into it, it will come out of the observable side of itself.

An Rx Subject is called a “subject” for item #3 above. “Subjects” in the Gang of Four Observer-Pattern are classes with an `addObserver` method, generally. In this case, our `addObserver` method is `subscribe`. [Here is a JSBin showing the basic behavior of an Rx Subject.](http://jsbin.com/muziva/1/edit?js,output)

### Making A Cold Observable Hot

Armed with our Rx Subject above, we can use a bit of functional programming to make any “cold” observable “hot”:

    function makeHot(cold) {
      const subject = new Subject();
      cold.subscribe(subject);
      return new Observable((observer) => subject.subscribe(observer));
    }

Our new `makeHot` method will take any cold observable and make it hot by creating a subject that is shared by the resulting observable. [Here’s a JSBin of this in action.](http://jsbin.com/ketodu/1/edit?js,output)

We still have a little problem, though, we’re not tracking our subscription to source, so how can we tear it down when we want to? We can add some reference counting to it to solve that:

    function makeHotRefCounted(cold) {
      const subject = new Subject();
      const mainSub = cold.subscribe(subject);
      let refs = 0;
      return new Observable((observer) => {
        refs++;
        let sub = subject.subscribe(observer);
        return () => {
          refs--;
          if (refs === 0) mainSub.unsubscribe();
          sub.unsubscribe();
        };
      });
    }

Now we have an observable that is hot, and when all subscriptions to it are ended, the `refs` we’re using to do reference counting will hit zero, and we’ll unsubscribe from our cold source observable. [Here is a JSBin demonstrating this in action](http://jsbin.com/lubata/1/edit?js,output).

### In RxJS, Use `publish()` or `share()`

You probably shouldn’t use any of the `makeHot` functions above, and instead should use operators like `publish()` and `share()`. There are a lot of ways and means to make a cold observable hot, and in Rx there are efficient and concise ways to perform each of those things. One could write an entire article just on the various operators used for this in Rx, but that wasn’t the goal here. The goal was to solidify the idea of what “hot” and “cold” really mean.

In RxJS 5, the operator `share()` makes a hot, refCounted observable that can be retried on failure, or repeated on success. Because subjects cannot be reused once they’ve errored, completed or otherwise unsubscribed, the `share()` operator will recycle dead subjects to enable resubscription to the resulting observable.

[Here is a JSBin demonstrating using `share()` to make a source hot in RxJS 5, and showing that it can be retried.](http://jsbin.com/mexuma/1/edit?js,output)

### The “Warm” Observable

Given everything stated above, one might be able to see how an Observable, being that it’s *just a function*, could actually be both “hot” and “cold”. Perhaps it observes two producers? One it creates and one it closes over? That’s probably bad juju, but there are rare cases where it might be necessary. A multiplexed web socket for example, must share a socket, but send its own subscription and filter out a data stream.

### “Hot” And “Cold” Are All About The Producer

If you’re closing over a shared reference to a producer in your observable, it’s “hot”, if you’re creating a new producer in your observable, it’s “cold”. If you’re doing both…. what are you doing? It’s “warm” I guess.

#### NOTES

¹ (NOTE: It’s sort of weird to say the producer is “activated” inside the subscription, but not “created” until some later point, but with proxies, that could be possible.) Usually “hot” observables have their producers both created and activated outside of the subscription.

² Hot observables are usually multicast, but they could be listening to a producer that only supports one listener at a time. The grounds for calling it “multicast” at that point are a little fuzzy.

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
