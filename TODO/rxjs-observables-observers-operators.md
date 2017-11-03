> * 原文地址：[RxJS: Observables, observers and operators introduction](https://toddmotto.com/rxjs-observables-observers-operators)
> * 原文作者：本文已获原作者 [Todd](https://toddmotto.com/) 授权
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[lsvih](https://github.com/lsvih)
> * 校对者：[sunui](https://github.com/sunui),[GangsterHyj](https://github.com/GangsterHyj)

# RxJS 简介：可观察对象、观察者与操作符 #


对于响应式编程来说，RxJS 是一个不可思议的工具。今天我们将深入探讨什么是 Observable（可观察对象）和 observer（观察者），然后了解如何创建自己的 operator（操作符）。

如果你之前用过 RxJS，想了解它的内部工作原理，以及 Observable、operator 是如何运作的，这篇文章将很适合你阅读。

### 什么是 Observable（可观察对象）？ ###

可观察对象其实就是一个比较特别的函数，它接受一个“观察者”（observer）对象作为参数（在这个观察者对象中有 “next”、“error”、“complete”等方法），以及它会返回一种解除与观察者关系的逻辑。例如我们自己实现的时候会使用一个简单的 “unsubscribe” 函数来实现退订功能（即解除与观察者绑定关系的逻辑）。而在 RxJS 中， 它是一个包含 `unsubsribe` 方法的订阅对象（Subscription）。

可观察对象会创建观察者对象（稍后我们将详细介绍它），并将它和我们希望获取数据值的“东西”连接起来。这个“东西”就是生产者（producer），它可能来自于 `click` 或者 `input` 之类的 DOM 事件，是数据值的来源。当然，它也可以是一些更复杂的情况，比如通过 HTTP 与服务器交流的事件。

我们稍后将要自己写一个可观察对象，以便更好地理解它！在此之前，让我们先看看一个订阅对象的例子：

```
const node = document.querySelector('input[type=text]');

const input$ = Rx.Observable.fromEvent(node, 'input');

input$.subscribe({
  next: (event) => console.log(`你刚刚输入了 ${event.target.value}!`),
  error: (err) => console.log(`Oops... ${err}`),
  complete: () => console.log(`完成!`)
});
```

这个例子使用了一个 `<input type="text">` 节点，并将其传入 `Rx.Observable.fromEvent()` 中。当我们触发指定的事件名时，它将会返回一个输入的 `Event` 的可观察对象。（因此我们在 console.log 中用  `${event.target.value}` 可以获取输入值）

当输入事件被触发的时候，可观察对象会将它的值传给观察者。

### 什么是 Observer（观察者）？ ###

观察者相当容易理解。在前面的例子中，我们传入 `.subscribe()` 中的对象字面量就是观察者（订阅对象将会调用我们的可观察对象）。

> `.subscribe(next, error, complete)` 也是一种合法的语法，但是我们现在研究的是对象字面量的情况。

当一个可观察对象产生数据值的时候，它会通知观察者，当新的值被成功捕获的时候调用 `.next()`，发生错误的时候调用 `.error()`。

当我们订阅一个可观察对象的时候，它会持续不断地将值传递给观察者，直到发生以下两件事：一种是生产者告知没有更多的值需要传递了，这种情况它会调用观察者的 `.complete()` ；一种是我们（“消费者”）对之后的值不再感兴趣，决定取消订阅（unsubsribe）。

如果我们想要对可观察对象传来的值进行组成构建（compose），那么在值传达最终的 `.subscribe()` 代码块之前，需要经过一连串的可观察对象（也就是操作符）处理。这个一连串的“链”也就是我们所说的可观察对象序列。链中的每个操作符都会返回一个新的可观察对象，让我们的序列能够持续进行下去——这也就是我们所熟知的“流”。

### 什么是 Operator（操作符）？  ###

我们前面提到，可观察对象能够进行链式调用，也就是说我们可以像这样写代码：

```
const input$ = Rx.Observable.fromEvent(node, 'input')
  .map(event => event.target.value)
  .filter(value => value.length >= 2)
  .subscribe(value => {
    // use the `value`
  });
```

这段代码做了下面一系列事情：

- 我们先假定用户输入了一个“a”
- 可观察对象将会对这个输入事件作出反应，将值传给下一个观察者
- “a”被传给了订阅了我们**初始**可观察对象的 `.map()`
- `.map()` 会返回一个 `event.target.value` 的新可观察对象，然后调用它观察者对象中的 `.next()`
- `.next()` 将会调用订阅了 `.map()` 的 `.filter()`，并将 `.map()` 处理后的值传递给它
- `.filter()` 将会返回另一个可观察对象，`.filter()` 过滤后留下 `.length` 大于等于 2 的值，并将其传给 `.next()`
- 我们通过 `.subscribe()` 获得了最终的数据值

这短短的几行代码做了这么多的事！如果你还觉得弄不清，只需要记住：

每当返回一个新的可观察对象，都会有一个新的**观察者**挂载到前一个**可观察对象**上，这样就能通过观察者的“流”进行传值，对观察者生产的值进行处理，然后调用 `.next()` 方法将处理后的值传递给下一个观察者。

简单来说，操作符将会不断地依次返回新的可观察对象，让我们的流能够持续进行。作为用户而言，我们不需要关心什么时候、什么情况下需要创建与使用可观察对象与观察者，我们只需要用我们的订阅对象进行链式调用就行了。

### 创建我们自己的 Observable（可观察对象） ###

现在，让我们开始写自己的可观察对象的实现吧。尽管它不会像 Rx 的实现那么高级，但我们还是对完善它充满信心。

#### Observable 构造器 ####

首先，我们需要创建一个 Observable 构造函数，此构造函数接受且仅接受 `subscribe` 函数作为其唯一的参数。每个 Observable 实例都存储 subscribe 属性，稍后可以由观察者对象调用它：

```
function Observable(subscribe) {
  this.subscribe = subscribe;
}
```

每个分配给 `this.subscribe` 的 `subscribe` 回调都将会被我们或者其它的可观察对象调用。这样我们下面做的事情就有意义了。

#### Observer 示例 ####

在深入探讨实际情况之前，我们先看一看基础的例子。

现在我们已经配好了可观察对象函数，可以调用我们的观察者，将 `1` 这个值传给它并订阅它：

```
const one$ = new Observable((observer) => {
  observer.next(1);
  observer.complete();
});

one$.subscribe({
  next: (value) => console.log(value) // 1
});
```

我们订阅了 Observable 实例，将我们的 observer（对象字面量）传入构造器中（之后它会被分配给 `this.subscribe`）。

#### Observable.fromEvent ####

现在我们已经完成了创建自己的 Observable 的基础步骤。下一步是为 Observable 添加 `static` 方法：

```
Observable.fromEvent = (element, name) => {

};
```

我们将像使用 RxJS 一样使用我们的 Observable：

```
const node = document.querySelector('input');

const input$ = Observable.fromEvent(node, 'input');
```

这意味着我们需要返回一个新的 Observable，然后将函数作为参数传递给它：

```
Observable.fromEvent = (element, name) => {
  return new Observable((observer) => {

  });
};
```

这段代码将我们的函数传入了构造器中的 `this.subscribe`。接下来，我们需要将事件监听设置好：

```
Observable.fromEvent = (element, name) => {
  return new Observable((observer) => {
    element.addEventListener(name, (event) => {}, false);
  });
};
```

那么这个 `observer` 参数是什么呢？它又是从哪里来的呢？

这个 `observer` 其实就是携带 `next`、`error`、`complete` 的对象字面量。

> 这块其实很有意思。`observer` 在 `.subscribe()` 被调用之前都不会被传递，因此 `addEventListener` 在 Observable 被“订阅”之前都不会被执行。

一旦调用 subscribe，也就会调用 Observable 构造器内的 `this.subscribe` 。它将会调用我们传入 `new Observable(callback)` 的 callback，同时也会依次将值传给我们的观察者。这样，当 Observable 做完一件事的时候，它就会用更新过的值调用我们观察者中的 `.next()` 方法。

那么之后呢？我们已经得到了初始化好的事件监听器，但是还没有调用 `.next()`。下面完成它：

```
Observable.fromEvent = (element, name) => {
  return new Observable((observer) => {
    element.addEventListener(name, (event) => {
      observer.next(event);
    }, false);
  });
};
```

我们都知道，可观察对象在被销毁前需要一个“处理后事”的函数，在我们这个例子中，我们需要移除事件监听：

```
Observable.fromEvent = (element, name) => {
  return new Observable((observer) => {
    const callback = (event) => observer.next(event);
    element.addEventListener(name, callback, false);
    return () => element.removeEventListener(name, callback, false);
  });
};
```

因为这个 Observable 还在处理 DOM API 和事件，因此我们还不会去调用 `.complete()`。这样在技术上就有无限的可用性。

试一试吧！下面是我们已经写好的完整代码：

```
const node = document.querySelector('input');
const p = document.querySelector('p');

function Observable(subscribe) {
  this.subscribe = subscribe;
}

Observable.fromEvent = (element, name) => {
  return new Observable((observer) => {
    const callback = (event) => observer.next(event);
    element.addEventListener(name, callback, false);
    return () => element.removeEventListener(name, callback, false);
  });
};

const input$ = Observable.fromEvent(node, 'input');

const unsubscribe = input$.subscribe({
  next: (event) => {
    p.innerHTML = event.target.value;
  }
});

// 5 秒之后自动取消订阅
setTimeout(unsubscribe, 5000);
```

在线示例：

```
HTML

<input type="text">
<p></p>

JavaScript

const node = document.querySelector('input');
const p = document.querySelector('p');

function Observable(subscribe) {
  this.subscribe = subscribe;
}

Observable.fromEvent = (element, name) => {
  return new Observable((observer) => {
    const callback = (event) => observer.next(event);
    element.addEventListener(name, callback, false);
    return () => element.removeEventListener(name, callback, false);
  });
};

const input$ = Observable.fromEvent(node, 'input');

input$.subscribe({
  next: (event) => {
    p.innerHTML = event.target.value;
  }
});


```
### 创造我们自己的 Operator（操作符） ###

在我们理解了可观察对象与观察者对象的概念之后，我们可以更轻松地去创造我们自己的操作符了。我们在 `Observable` 对象原型中加上一个新的方法：

```
Observable.prototype.map=function(mapFn){

};
```

这个方法将会像 JavaScript 中的 `Array.prototype.map` 一样使用，不过它可以对任何值用：

```
const input$ = Observable.fromEvent(node, 'input')
	.map(event => event.target.value);
```

所以我们要取得回调函数，并调用它，返回我们期望得到的数据。在这之前，我们需要拿到流中最新的数据值。

下面该做什么就比较明了了，我们要得到调用了这个 `.map()` 操作符的 Observable 实例的引用入口。我们是在原型链上编程，因此可以直接这么做：

```
Observable.prototype.map = function (mapFn) {
  const input = this;
};
```

找找乐子吧！现在我们可以在返回的 Obeservable 中调用 subscribe：

```
Observable.prototype.map = function (mapFn) {
  const input = this;
  return new Observable((observer) => {
  	return input.subscribe();
  });
};
```

> 我们要返回 `input.subscribe()` ，因为在我们退订的时候，非订阅对象将会顺着链一直转下去，解除每个 Observable 的订阅。

这个订阅对象将允许我们把之前 `Observable.fromEvent` 传来的值传递下去，因为它返回了构造器中含有 `subscribe` 原型的新的 Observable 对象。我们可以轻松地订阅它对数据值做出的任何更新！最后，完成通过 map 调用我们的 `mapFn()` 的功能：

```
Observable.prototype.map = function (mapFn) {
  const input = this;
  return new Observable((observer) => {
    return input.subscribe({
      next: (value) => observer.next(mapFn(value)),
      error: (err) => observer.error(err),
      complete: () => observer.complete()
    });
  });
};
```

现在我们可以进行链式调用了！

```
const input$ = Observable.fromEvent(node, 'input')
  .map(event => event.target.value);

input$.subscribe({
  next: (value) => {
    p.innerHTML = value;
  }
});
```

注意到最后一个 `.subscribe()` 不再和之前一样传入 `Event` 对象，而是传入了一个 `value` 了吗？这说明你成功地创建了一个可观察对象流。

再试试：
```

HTML

<input type="text">
<p></p>
<button type="button">
  Unsubscribe
</button>

JavaScript

const node = document.querySelector('input');
const p = document.querySelector('p');

function Observable(subscribe) {
  this.subscribe = subscribe;
}

Observable.prototype.map = function (mapFn) {
  const input = this;
  return new Observable((observer) => {
    return input.subscribe({
      next: (value) => observer.next(mapFn(value)),
      error: (err) => observer.error(err),
      complete: () => observer.complete()
    });
  });
};

Observable.fromEvent = (element, name) => {
  return new Observable((observer) => {
    const callback = (event) => observer.next(event);
    element.addEventListener(name, callback, false);
    return () => element.removeEventListener(name, callback, false);
  });
};

const input$ = Observable.fromEvent(node, 'input')
	.map(event => event.target.value);

const unsubscribe = input$.subscribe({
  next: (value) => {
    p.innerHTML = value;
  }
});

// avert your eyes
document
	.querySelector('button')
	.addEventListener('click', unsubscribe);



```
希望这篇文章对你来说还算有趣~:)

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
