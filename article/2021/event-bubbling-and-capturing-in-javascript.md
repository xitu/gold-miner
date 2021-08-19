> * 原文地址：[Event Bubbling and Capturing in JavaScript](https://blog.bitsrc.io/event-bubbling-and-capturing-in-javascript-6bc908321b22)
> * 原文作者：[Dulanka Karunasena](https://medium.com/@dulanka)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/event-bubbling-and-capturing-in-javascript.md](https://github.com/xitu/gold-miner/blob/master/article/2021/event-bubbling-and-capturing-in-javascript.md)
> * 译者：
> * 校对者：

# Event Bubbling and Capturing in JavaScript

![](https://cdn-images-1.medium.com/max/5760/1*7Iz_wjlurP2vVhkBpVVzgA.jpeg)

JavaScript event bubbling is there to capture and handle events propagated inside the DOM. But do you know, there are differences between event bubbling and capturing?

So, in this article, I will discuss all you need to know about the topic with relevant examples.

## Understanding the Event Flow

Before jumping to bubbling and capturing, let’s find out how an event is propagated inside the DOM.

If we have several nested elements handling the same event, we get confused about which event handler will trigger first. This is where understanding the event order becomes necessary.

> Usually, an event is propagated towards the target element starting from its parents, and then it will propagate back towards its parent element.

There are three phases in a JavaScript event,

* **Capture Phase:** Event propagates starting from ancestors towards the parent of the target. Propagation starts from `Window` object.
* **Target Phase:** The event reaches the target element or the element which started the event.
* **Bubble Phase:** This is the reverse of capture. ****Event is propagated towards ancestors until `Window` object.

The following diagram will give you a further understanding of the event propagation life cycle.

![DOM event flow](https://cdn-images-1.medium.com/max/2000/1*B0k6-J5ZwfmsxZDXAOCT2Q.jpeg)

Since now you understand event flow inside DOM, let’s see how event capturing and bubbling come into the picture.

## What is Event Capturing?

> Event capturing is the scenario in which the events will propagate, starting from the wrapper elements down to the target element that initiated the event cycle.

If you had an event bound to browser’s `Window`, it would be the first to execute. So, in the following example, the order of event handling will be `Window`, `Document`, `DIV 2`, `DIV 1`, and finally, the `button`.

![Event capturing sample](https://cdn-images-1.medium.com/max/2000/1*bwNxfZVJ28WSAQ5s1MCc3A.gif)

Here we can see that event capturing occurs only until the clicked element or the target. The event will not propagate to child elements.

We can use the `useCapture` argument of the `addEventListener()`method to register events for capturing phase.

```js
target.addEventListener(type, listener, useCapture)
```

You can use the following snippet to test out the above example and get hands-on experience in event capturing.

```JavaScript
window.addEventListener("click", () => {
    console.log('Window');
  },true);

document.addEventListener("click", () => {
    console.log('Document');
  },true);

document.querySelector(".div2").addEventListener("click", () => { 
    console.log('DIV 2');
  },true);

document.querySelector(".div1").addEventListener("click", () => {
    console.log('DIV 1');
  },true);

document.querySelector("button").addEventListener("click", () => {
    console.log('CLICK ME!');
  },true);
```

## What is Event Bubbling?

Event bubbling is pretty simple to understand if you know event capturing. It is the exact opposite of event capturing.

> Event bubbling will start from a child element and propagate up the DOM tree until the topmost ancestor’s event is handled.

Omitting or setting the `useCapture` argument to ‘false’ inside `addEventListener()` will register events for bubbling. So, the default behavior of Event Listeners is to bubble events.

![Event bubbling sample](https://cdn-images-1.medium.com/max/2000/1*sfTTnB76jtG7dhfMQa0Zsg.gif)

In our examples, we used either event capturing or event bubbling for all events. But what if we want to handle events inside both phases?

Let’s take an example of handling the `click` events of `Document` and `DIV 2` during the bubbling phase while others are handled during capturing.

![Registering events for both phases](https://cdn-images-1.medium.com/max/2000/1*L53X6yq5t-Nw_vl1EH9EWA.gif)

The `click` events attached to `Window`, `DIV 1`, and `button` will fire respectively during the capturing, while `DIV 2` and `Document` listeners are fired in order during the bubbling phase.

```JavaScript
window.addEventListener("click", () => {
    console.log('Window');
  },true);

document.addEventListener("click", () => {
    console.log('Document');
  }); //registered for bubbling

document.querySelector(".div2").addEventListener("click", () => { 
    console.log('DIV 2');
  }); //registered for bubbling

document.querySelector(".div1").addEventListener("click", () => {
    console.log('DIV 1');
  },true);

document.querySelector("button").addEventListener("click", () => {
    console.log('CLICK ME!');
  },true);
```

I think now you have a good understanding of event flow, event bubbling, and event capturing. So, let’s see when we can use event bubbling and event capturing.

## Usage of Event Capturing & Bubbling?

Usually, event propagation can be used whenever we need to execute a function globally. So, for example, we can register document-wide listeners, which will run if an event occurs inside the DOM.

> Similarly, we can use bubbling and capturing to perform UI changes.

Suppose we have a table that allows users to select cells, and we need to indicate the selected cells to the user.

![](https://cdn-images-1.medium.com/max/2000/1*ZAgwPqbTDtk8TROAUe-tdw.gif)

> In this case, assigning event handlers to each cell will not be a good practice. It will ultimately result in code repetition.

As a solution, we can use a single event listener and make use of event bubbling and capturing to handle these events.

So, I have created a single event listener for `table` and it will be used to change the styles of the cells.

```js
document.querySelector("table").addEventListener("click", (event) =>
  {       
     if (event.target.nodeName == 'TD')
         event.target.style.background = "rgb(230, 226, 40)";
  }
);
```

Inside the event listener, I have used `nodeName` to match the clicked cell and if it matches, the cell color will be changed.

## Preventing Event Propagation

> Sometimes event bubbling and capturing can be annoying if it starts to fire events without our control.

This can also cause performance issues if you have a heavily nested element structure because every event will create a new Event Cycle.

![When bubbling becomes annoying!](https://cdn-images-1.medium.com/max/3840/1*BObT883lMyK8AH2RPaBGdQ.gif)

In the above scenario, when I click the ‘Delete’ button, the `click` event of the wrapper element is also triggered. This happens due to the event bubbling.

> We can use the `stopPropagation()` method to avoid this behavior. It will stop events from propagating further up or down along the DOM tree.

```js
document.querySelector(".card").addEventListener("click", () => {
    $("#detailsModal").modal();
});

document.querySelector("button").addEventListener("click",(event)=>{
    event.stopPropagation(); //stop bubbling
    $("#deleteModal").modal();
});
```

![After using stopPropagation()](https://cdn-images-1.medium.com/max/3840/1*sDLWoQ_4VjjPiXhUGoY3uA.gif)

## Conclusion

JavaScript event bubbling and capturing can be used to handle events effectively inside web applications. Understanding the event flow and how capturing and bubbling works will help you optimize your application with correct event handling.

For example, if there are any unexpected event firings in your application, understanding event capturing and bubbling can save you time to investigate the issue.

So, I invite you to try out the above examples and share your experience in the comments section.

Thank you for Reading !!!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
