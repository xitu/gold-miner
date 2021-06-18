> * 原文地址：[Observer Design Pattern in JavaScript](https://betterprogramming.pub/observer-design-pattern-in-javascript-c839ee49add4)
> * 原文作者：[Shubham Khatri](https://medium.com/@shubham-khatri)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/observer-design-pattern-in-javascript.md](https://github.com/xitu/gold-miner/blob/master/article/2021/observer-design-pattern-in-javascript.md)
> * 译者：
> * 校对者：

# Observer Design Pattern in JavaScript

![Photo by [Daniel Lerman](https://unsplash.com/@dlerman6?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/7680/0*ArBjTJj9lM6Jv7Ww)

While working with any language, we tend to use a number of reusable design solutions to commonly occurring problems. In JavaScript, too, we have a mix of well-defined patterns.

The Observer pattern is one of them.

In this article, we shall understand more about the Observer design pattern in JavaScript and implement a small example in vanilla JavaScript.

## What Is the Observer Design Pattern?

The Observer pattern follows a subscription model, where a subscriber (commonly referred to as **the** o**bserver**) subscribes to an event or an action handled by a publisher (commonly referred to as **the** **subject**) and is notified when the event or action occurs.

The subject broadcasts the occurrence of the event or action to all the observers.

When the observer no longer wishes to be notified of the changes by the subject, it unsubscribes itself from the subject, and the subject then removes it from the list of subscribers.

An Observer design pattern is very similar to a Publisher/Subscriber pattern, with a small difference that a Publisher/Subscriber pattern also specifies a topic it wants to subscribe to. For example, when detecting keyboard shortcuts, the subscriber can choose to specify a key combination that it wants to listen to in a Publisher/Subscriber model.

## Implementation of the Observer Pattern

As an example of the Observer pattern, we will go about implementing a simple interaction where multiple elements listen to the mouse position on the screen and perform different actions.

Below is an example of what our interaction looks like:

![](https://cdn-images-1.medium.com/max/2900/1*YQgn_fI7CgJ9UHoqpsh2OA.gif)

Before we implement this interaction, let us analyze what is happening in this example as the mouse position changes.

* The mouse position is immediately updated in the textbox at the top right corner.
* The circle follows the trajectory of the mouse after a delay of 1s.

From the above description, we see that multiple components need information about the same thing but behave differently.

From the above example, we identify that the **subject** listens to the mouse event on the window and relays it to whoever wants it. The **circle and textbox** are **observers** in the above example.

So let us now go ahead and implement it.

### Step 1. Implement a MousePositionObservable class

As a first step let us go ahead and implement the `MousePositionObservable` class. This class needs to do the following things:

* Keep a list of observer callbacks.
* Expose a `subscribe` method which the observers will call to subscribe to the change. The return value of this must be a function which when called will move the `callback` from the set of `subscriptions`.
* Listen to `mouseMove` event and trigger all subscription callbacks.

The code looks like the below:

```JavaScript
class MousePositionObservable {
  constructor() {
    this.subscriptions = [];
    window.addEventListener('mousemove',this.handleMouseMove);
  }
  handleMouseMove =  (e) => {
     this.subscriptions.forEach(sub => sub(e.clientX, e.clientY));
  }
  subscribe(callback) {
    this.subscriptions.push(callback);    
    
    return () => {
      this.subscription.filter(cb => cb === callback);
    }
  }
}
```

### Step 2. Create HTML elements

We now create our HTML elements for `circle` and `textMessageBox` and add styles to them.

```HTML
<div class="container">
  <div class="circle" ></div>
  <div class="mouse-position">
  <h4>Mouse Position</h4>
  <div class="position"></div>
</div>
</div>
```

### Step 3. Add observers

The last step to make it come together is to create an instance of our `MousePositionObservable` class and add observers to it.

To do that we shall invoke the `subscribe` method on the class instance and pass on a callback.

Our code looks like the below:

```JavaScript
const circle = document.querySelector('.circle');
  
const mousePositionObservable = new MousePositionObservable();

mousePositionObservable.subscribe((x, y) => {
  const circle = document.querySelector('.circle');
   window.setTimeout(() => {
     circle.style.transform = `translate(${x}px, ${y}px)`;
   }, 1000);
});

// Update the mouse positon container to show the mouse position values
mousePositionObservable.subscribe((x, y) => {
  const board = document.querySelector('.mouse-position .position');
  board.innerHTML = `
    <div>
       <div>ClientX: ${x}</div>
       <div>ClientY: ${y}</div>
    </div>
  `
})
```

We add two subscriptions to the `MousePositionObservable` instance, one for each of the elements which need to listen to mouse values.

The subscription callback for the `circle`element gets the reference of the DOM element and updates its `tranform`property. The transform property will use hardware acceleration where possible, so using `translate()` over position top and left will see performance benefits if any animations or transitions are also being used on the element.

The subscription callback for the `textbox` element updates its HTML content by using the `innerHTML` property.

That is all we need for our demo.

You can check out the working example in the Codepen below:

## Advantages and Disadvantages of the Observer Design Pattern

An Observer design pattern provides us the following benefits:

* It is extremely useful when we want to perform multiple actions on a single event.
* It provides a way to decouple functionalities while maintaining consistency between related objects.

The downside of this pattern stems from its benefits:

* Since the Observer design pattern leads to loosely coupled code, it is sometimes hard to guarantee that other parts of the application are working as they should. For example, the subscriptions added to the subject may have code that is behaving incorrectly, but there is no way for the publisher to know that.

## Conclusion

In this article, we went through what the Observer design pattern is and how to use it within our application. We also implement a demo based on this pattern and learned about some of the advantages and disadvantages of following this approach to designing interactions.

**Thank you for reading.**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
