> * 原文地址：[Hot vs Cold Observables](https://medium.com/@benlesh/hot-vs-cold-observables-f8094ed53339)
> * 原文作者：[Ben Lesh](https://medium.com/@benlesh)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[hikerpig](https://github.com/hikerpig)
> * 校对者：[Tina92](https://github.com/Tina92)

---

# Observable 之冷和热

## 简单来说：如果不想重复创建生产者（producer），你需要使用热 Observable

#### 冷：Observable 自行创建生产者

    // COLD
    var cold = new Observable((observer) => {
      var producer = new Producer();
      // have observer listen to producer here
    });

#### 热：Observable 使用已存在的生产者

    // HOT
    var producer = new Producer();
    var hot = new Observable((observer) => {
      // have observer listen to producer here
    });

### 深入解析

我上篇文章[通过自行实现学习 Observable](https://medium.com/@benlesh/learning-observable-by-building-observable-d5da57405d87) 阐述了 Observable 是种函数。虽旨在揭开 Observable 的神秘外衣，但并没有触及其最令人困惑的部分：“冷”和“热”的概念。

#### Observable 只是函数！

Observable 只是一个将观察者 (Observer) 连接到生产者的函数。意味着，它们并不需要自行创建生产者。只需要让一个观察者订阅生产者的消息，并提供一种取消监听的方式。这种订阅可通过像函数一样“调用” Observable，给它传递一个观察者。

#### 什么是“生产者”？

生产者是 Observable 的数据源。可以是一个 websocket 连接、DOM 事件、迭代器或一个遍历某数组的操作。可以是你用来获取并向 `observer.next(value)` 传递值的任何东西。。


### 冷 Observable：在内部创建生产者

一个“冷”的 Observable 的生产者**创建和激活**发生在订阅期。就是说若将 observable 比作函数，那么生产者是在“调用函数”时创建和激活的。

1. 创建生产者
2. 激活生产者
3. 开始监听生产者
4. 单播

下面例子是“冷”的，因为 WebSocket 连接是在订阅回调“内部”被创建和监听的，而订阅回调函数只有在订阅 Observable 时才会被执行。

    const source = new Observable((observer) => {
      const socket = new WebSocket('ws://someurl');
      socket.addEventListener('message', (e) => observer.next(e));
      return () => socket.close();
    });

上述`source`的所有订阅者都会有一个自己的 WebSocket，取消订阅时用`close()`将其关闭。因此该数据源是真正的单播，因为其生产者只向一个观察者发送值。[此 JSBin 例子说明了此概念](http://jsbin.com/wabuguy/1/edit?js,output)。

### 热 Observable：在外部创建生产者

热 Observable 的生产者在订阅回调函数外被创建或激活(备注1)。

1. 共享一个生产者的引用
2. 监听生产者
3. 组播(multicast)(备注2)

若我们改变一下之前的例子，把 WebSocket 的创建移到 Observable 外，就是个“热” Observable：

    const socket = new WebSocket('ws://someurl');

    const source = new Observable((observer) => {
      socket.addEventListener('message', (e) => observer.next(e));
    });

`source`的所有订阅者共享一个 WebSocket 实例，该 socket 的消息会组播给所有订阅者。但这引入一个小问题：我们没法用 observable 承载销毁该 socket 的逻辑。无论出错、完成，还是取消订阅，都不会关闭该连接。我们做的只是把“冷” Observable 变“热”[此 JSBin 例子说明了此概念](http://jsbin.com/godawic/edit?js,output)。

#### 为什么需要热 Observable？

在第一个冷 Observable 的例子里你可以看见，一直保有所有的冷 Observable 实例可能会有问题。首先，如果你需要订阅这个 observable 多次，而这个 observable 会创建类似于 WebSocket 这样的，占用如网络连接般稀缺资源的实例，你肯定不希望创建多个连接。而实际上，我们很容易忽略订阅多次的事实。例如当你需要过滤出 socket 消息值的奇/偶数序列，在此场景下你会创建两个订阅：

    source.filter(x => x % 2 === 0)
      .subscribe(x => console.log('even', x));

    source.filter(x => x % 2 === 1)
      .subscribe(x => console.log('odd', x));

### Rx Subjects

在我们把 Observable 从冷转热之前，需要介绍一种新类型：Rx Subject，它有以下特性：

1. 它是一个 Observable, 包含了 Observable 的所有操作方法。
2. 它是一个 Observer, 通过 duck-typing 实现了一些长得和 Observer 相似的接口。当被像 Observable 订阅时，会发出你使用类似 Observer 的 `next` 方法传入的值。
3. 支持组播。通过 `subscribe()` 传入的所有观察者会被加入一个内部的观察者列表里保存。
4. 结束状态明确。在取消订阅、完成或出错之后就无法再被使用。
5. 可以对自己传值。补充下第 2 条，使用 `next` 对其传值，会触发它的 Observable 相关回调。

Rx Subject 的名字得于第 3 条特性，“Subject” 在 Gang of Four（译者注：经典《设计模式》的几位作者）的观察者模式中，是实现了 `addObserver` 方法的类。在我们的例子中，`addObserver` 就是 `subscribe`。[一个展示 Rx Subject 行为的 JSBin 例子](http://jsbin.com/muziva/1/edit?js,output)。


### 把 Observable 从冷变热

有了 Rx Subject 的加持，我们可以用上一点函数式编程让 Observable 从冷转热：


    function makeHot(cold) {
      const subject = new Subject();
      cold.subscribe(subject);
      return new Observable((observer) => subject.subscribe(observer));
    }


`makeHot` 函数接受一个冷的 Observable `cold`，创建一个 `subject` 订阅 `cold` 的消息，最后该函数返回一个热 Observable, 它的生产者为 `subject`。[一个 JSBin 示例](http://jsbin.com/ketodu/1/edit?js,output)

不过还有一个小问题，我们没有直接订阅数据源，如果想取消订阅，该怎么做呢？可以用引用计数解决：

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

现在我们有一个热 Observable，且当其所有订阅取消了，用来计数的 `refs` 变为 0 时，便可以取消对原先冷 Observable 的订阅。[一个 JSBin 例子](http://jsbin.com/lubata/1/edit?js,output)。

### 在 RxJS 里使用 `publish()` 或 `share()`

你也许不该使用类似于上面 `makeHot` 这样的函数，而应该使用 `publish()` 或 `share()` 这样的函数 Observable 转热的途径，在 Rx 里有高效简洁的方式。为说明使用多种 Rx 操作符（译者注：operator，之后都作此翻译）来做这件事情，能专门写一篇文章，不过这不是本文的目的。真正的目的在于加强对“冷”“热”之分的理解。

在 RxJS 5 里，`share()` 操作符创建一个有引用计数的热 Observable，且可以在失败时重试，或在成功时重复执行。因为 Subject 在出错、完成或取消订阅后便不能再被重用，`share()` 操作符会更新重建已结束的 Subject，从而使得返回的 Observable 能够被再次订阅。

[一个在 RxJS 5 里使用 `share()` 创建热数据源的 JSBin 例子，也展示了重试的方法](http://jsbin.com/mexuma/1/edit?js,output)

### “温” Observable

看完如上所述，能知道 Observable 虽然 “只是函数”，却能有冷热之分。它还能监听两个生产者？一个由它创建，一个由它关闭？有点像不良的小伎俩，非其不用的场景并不多。例如多路 socket 数据源，共享一个 socket 连接，但分别有自己的数据订阅和过滤机制。

### 冷和热都只和生产者有关

如果在 Observable 内操作一个共享的生产者，是“热”的。而在 Observable 内部创建生产者，是“冷”的。那假如你二者皆有，是什么？我猜它是“温”的。

#### 备注

1. 说生产者在订阅回调内部被“激活”，而不是在之后某合适时机被“创建”，可能有点奇怪，不过通过代理（proxy），的确是可以的。通常“热” Observable 的生产者在订阅回调外部被创建和激活。

2. 热 Observable 通常是组播的，虽说它也许对应的是一个只支持单个监听回调的生产者。在此处说它是“组播”的，可能不是完全准确。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
