> * 原文地址：[The Publisher/Subscriber Pattern in JavaScript](https://medium.com/better-programming/the-publisher-subscriber-pattern-in-javascript-2b31b7ea075a)
> * 原文作者：[jsmanifest](https://medium.com/@jsmanifest)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-publisher-subscriber-pattern-in-javascript.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-publisher-subscriber-pattern-in-javascript.md)
> * 译者：
> * 校对者：

# The Publisher/Subscriber Pattern in JavaScript

> Pub/sub, simplified

![**Photo by [NordWood Themes](https://unsplash.com/@nordwood) on [Unsplash](https://unsplash.com/)**](https://cdn-images-1.medium.com/max/3000/1*yH2hPgLBkX2CtuFwGlpdIA.jpeg)

In this article, we will be going over the publish/subscribe pattern in JavaScript and see how simple (but powerful) it is to implement in our JavaScript applications.

The publisher/subscriber pattern is a design pattern that allows us to create powerful dynamic applications with modules that can communicate with each other without being directly dependent on each other.

The pattern is quite common in JavaScript and has a close resemblance to the observer pattern in the way it works — except that in the observer pattern, an observer is notified directly by its subject, whereas in the publisher/subscriber method, the subscriber is notified through a channel that sits in-between the publisher and subscriber that relays the messages back and forth.

When we implement this, we will need a publisher, subscriber, and some place to store callbacks that are registered from subscribers.

Let’s go ahead and see how this looks like in code. We’re going to use a [factory](https://www.sitepoint.com/factory-functions-javascript/) function (you don’t have to use this pattern) to create the publisher/subscriber implementation.

The first thing we’re going to do is to declare a local variable inside the function to store subscribed callbacks:

```
function pubSub() {
  const subscribers = {}
}
```

Next, we’ll define the `subscribe` method which will be responsible for inserting callbacks to `subscribers`:

```JavaScript
function pubSub() {
  const subscribers = {}
  
  function subscribe(eventName, callback) {
    if (!Array.isArray(subscribers[eventName])) {
      subscribers[eventName] = []
    }
    subscribers[eventName].push(callback)
  }
  
  return {
    subscribe,
  }
}
```

What’s happening here is that before attempting to register a callback listener for an event name, it checks to see if the `eventName` property in the `subscribers` storage is already an `array`. If it isn't, it assumes that this will be the first registered callback for `subscribers[eventName]` and initializes it into an array. Then, it proceeds to push the callback into the array.

When the `publish` event fires, it will take two arguments:

1. The `eventName`
2. Any `data` that will be passed to *every single callback registered in `subscribers[eventName]`

Lets go ahead and see how this looks like in code:

```JavaScript
function pubSub() {
  
  const subscribers = {}
  
  function publish(eventName, data) {
    if (!Array.isArray(subscribers[eventName])) {
      return
    }
    subscribers[eventName].forEach((callback) => {
      callback(data)
    })
  }
  
  function subscribe(eventName, callback) {
    if (!Array.isArray(subscribers[eventName])) {
      subscribers[eventName] = []
    }
    subscribers[eventName].push(callback)
  }
  
  return {
    publish,
    subscribe,
  }
}
```

Before iterating on the list of callbacks in `subscribers`, it’ll check if it actually exists as an array in the object. If it doesn't, it will assume that the `eventName` was never even registered before, so it will simply just return. This is a safeguard against potential crashes.

After that, if the program reaches the `.forEach` line, then we know that the `eventName` was registered with one or more callbacks in the past. The program will proceed to loop through `subscribers[eventName]` safely.

For each callback that it encounters, it calls the callback with the `data` that was passed in as the second argument.

So this is what will happen if we subscribed a function like this:

```
function showMeTheMoney(money) {
  console.log(money)
}

const ps = pubSub()

ps.subscribe('show-money', showMeTheMoney)
```

And if we call the `publish` method sometime in the future:

```
ps.publish('show-money', 1000000)
```

Then the `showMeTheMoney` callback we registered will be invoked in addition to receiving `1000000` as the `money` argument:

```
function showMeTheMoney(money) {
  console.log(money) // result: 10000000
}
```

And that’s how the publisher/subscriber pattern works. We defined a `pubSub` function and provided a location locally to the function that stores the callbacks, a `subscribe`method to register the callbacks, and a `publish` method that iterates and calls all of the registered callbacks with any data.

There’s one more problem, though. In a real application, we might suffer a never-ending memory leak if we subscribe many callbacks, and it’s especially wasteful if we don’t do anything about that.

So what we need last is a way for subscribed callbacks to be removed when they are no longer necessary. What often happens in this case is that some `unsubscribe` method is placed somewhere. The most convenient place to implement this is the return value from `subscribe `because, in my opinion, it’s the most intuitive when we see this in code:

```JavaScript
function subscribe(eventName, callback) {
  if (!Array.isArray(subscribers[eventName])) {
    subscribers[eventName] = []
  }
  
  subscribers[eventName].push(callback)
  
  const index = subscribers[eventName].length - 1
  
  return {
    unsubscribe() {
      subscribers[eventName].splice(index, 1)
    },
  }
}

const unsubscribe = subscribe('food', function(data) {
  console.log(`Received some food: ${data}`)
})

// Removes the subscribed callback
unsubscribe()
```

In the example, we needed an index. So we make sure we remove the right one since we used `.splice`, which needs an accurate index to remove the item we are looking for.

You can also do something like this; however, it’s less performant:

```JavaScript
function subscribe(eventName, callback) {
  if (!Array.isArray(subscribers[eventName])) {
    subscribers[eventName] = []
  }
  
  subscribers[eventName].push(callback)
  
  const index = subscribers[eventName].length - 1
  
  return {
    unsubscribe() {
      subscribers[eventName] = subscribers[eventName].filter((cb) => {
        // Does not include the callback in the new array
        if (cb === callback) {
          return false
        }
        return true
      })
    },
  }
}
```

---

## Disadvantages

Although there are huge benefits to this pattern, there are also devastating disadvantages that might cost us a lot of debugging time.

How do we know if we subscribed the same callback before or not? There’s really no way to tell unless we implement a utility that maps through a list, but then we’d be making JavaScript do more tasks.

It also becomes harder to maintain our code the more we abuse this pattern in a real-world scenario. The fact that callbacks are decoupled in this pattern makes it hard to track down each step when you have callbacks doing this and doing that everywhere.

---

## Conclusion

And that concludes this post. I hope you found this to be valuable and look out for more in the future!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
