> * 原文地址：[4 Useful JavaScript Design Patterns You Should Know](https://medium.com/javascript-in-plain-english/4-useful-javascript-design-patterns-you-should-know-b4e1404e3929)
> * 原文作者：[bitfish](https://medium.com/@bf2)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/4-useful-javascript-design-patterns-you-should-know.md](https://github.com/xitu/gold-miner/blob/master/article/2020/4-useful-javascript-design-patterns-you-should-know.md)
> * 译者：[Zavier Tang](https://github.com/zaviertang)
> * 校对者：[niayyy-S](https://github.com/niayyy-S)、[CuteSunLee](https://github.com/CuteSunLee)

# 最常用的 4 种 JavaScript 设计模式

![Photo by [Neven Krcmarek](https://unsplash.com/@nevenkrcmarek?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/9820/0*0VPoIQRlovWvRq4d)

你是否像我以前一样对设计模式感到非常困惑呢？就我自身而言，我以前的个人项目，几乎没有考虑过设计模式。因此，存在很多设计缺陷和代码缺陷，给以后的维护和迭代带来了不少的麻烦。

但是要成为一名优秀的程序员，其基本要求之一就是精通设计模式。为此，我阅读了大量关于设计模式的书籍和博客，但一开始只学习到了一些理论知识。从来没有在实际项目中使用到。

直到后来我开始去阅读一些知名开源项目的源码，并在实际工作中请教了许多前辈，我才逐渐掌握了设计模式的使用。于是，我总结了一些自己的经验并写下了这篇文章，希望能对大家有所帮助。

本文将讨论以下设计模式的使用：

* **策略模式**
* **发布-订阅模式**
* **装饰者模式**
* **责任链模式**

#### 什么是设计模式？

引用维基百科：

> # 在软件工程中，设计模式（design pattern）是对软件设计中普遍存在（反复出现）的各种问题，所提出的解決方案。

这可能有点抽象，但你可以这样去理解：现在假设你正在玩一个电子游戏，你花了五个小时才完成通关。但是在你下一次玩的时候，因为你之前已经玩过了，积累了一些技巧，所以这次只需要两个小时就可以完成通关。这时你的朋友问你玩这个游戏的技巧，于是你告诉了他一些自己的经验，这就是所谓的设计模式。

#### 为什么需要设计模式？

我们开发的软件的功能总是随着时间而变化。设计模式的价值在于更好地组织我们当前的代码，并使其在未来更易于迭代。

现在让我们通过真实的例子来学习设计模式吧。

## 策略模式

假设我们有这样的需求，当用户试图打开一个页面时，只有满足以下的条件才能看到对应的内容:

* 用户是网站的注册用户
* 用户级别不小于 1
* 用户必须是前端工程师
* 用户的属性是活跃用户

现在我们需要编写判断逻辑，以确保只有符合条件的用户才能看到内容。你会怎么做？许多初学编程的人可能会简单地选择 `if-else` 并像下面这样编写代码：

```JavaScript
function checkAuth(data) {
  if (data.role !== 'registered') {
    console.log('该用户不是注册用户');
    return false;
  }
  if (data.grade < 1) {
    console.log("用户级别小于1");
    return false;
  }
  if (data.job !== 'FE') {
    console.log('该用户不是前端开发工程师');
    return false;
  }
  if (data.type !== 'active user') {
    console.log('该用户不是活跃用户');
    return false;
  }
}
```

我相信大家以前都写过类似的代码，但它有以下问题：

* 函数 `checkAuth` 是臃肿的
* 每个判断函数不能被复用
* 违反了开闭原则

那么我们如何解决这个问题呢？这就是策略模式发挥作用的时候了。

它是一种允许封装用于特定任务的备选算法的设计模式。它可以定义一系列算法，并以这样一种方式封装它们。它们在运行时可以互换调用顺序，而不需要编写额外的代码。

现在让我们使用策略模式来改写上面的代码。

```JavaScript
const jobList = ['FE', 'BE'];
var strategies = {
  checkRole: function(value) {
    if (value === 'registered') {
      return true;
    }
    return false;
  },
  checkGrade: function(value) {
    if (value >= 1) {
      return true;
    }
    return false;
  },
  checkJob: function(value) {
    if (jobList.indexOf(value) > 1) {
      return true;
    }
    return false;
  },
  checkType: function(value) {
    if (value === 'active user') {
      return true;
    }
    return false;
  }
};
```

上面的代码是我们将使用的策略列表，我们将继续完成验证逻辑。

```JavaScript
var Validator = function() {
  // Store strategies
  this.cache = [];
  // add strategy to cache
  this.add = function(value, method) {
    this.cache.push(function() {
      return strategies[method](value);
    });
  };
  // check all strategies
  this.check = function() {
    for (let i = 0; i < this.cache.length; i++) {
      let valiFn = this.cache[i];
      var data = valiFn();
      if (!data) {
        return false;
      }
    }
    return true;
  };
};
```

好了，现在让我们来实现前面的需求。

```JavaScript
var compose1 = function() {
  var validator = new Validator();
  const data1 = {
    role: 'register',
    grade: 3,
    job: 'FE',
    type: 'active user'
  };
  validator.add(data1.role, 'checkRole');
  validator.add(data1.grade, 'checkGrade');
  validator.add(data1.type, 'checkType');
  validator.add(data1.job, 'checkJob');
  const result = validator.check();
  return result;
};
```

看了上面的代码之后，你可能会想：代码量似乎增加了。

但正如我们之前所说的，设计模式的价值在于它能使你更容易地应对变化的需求。如果你的需求从头到尾都没有改变，那么使用设计模式真的没有多大价值。但是，如果当项目的需求发生了变化，那么设计模式的价值就可以得到体现。

例如，在另一个页面，我们对用户的验证逻辑是不同的，比如我们只需要确保：

* 用户是网站的注册用户
* 用户级别不小于 1

在这里，我们发现我们可以很容易地重用以前的代码：

```JavaScript
var compose2 = function() {
  var validator = new Validator();
  const data2 = {
    role: 'register',
    job: 'FE'
  };
  validator.add(data2.role, 'checkRole');
  validator.add(data2.job, 'checkJob');
  const result = validator.check();
  return result;
};
```

我们可以看到，通过使用策略模式，我们的代码变得更易于维护。现在可以考虑将策略模式应用到你自己的项目中了，例如在处理表单验证时。

当你的需求基本上满足以下条件时，你可以考虑使用策略模式来优化代码。

* 每个判断条件下的策略是独立的、可重用的
* 策略的内在逻辑比较复杂
* 策略需要灵活结合

## 发布-订阅模式

现在我们来看另一个需求：当用户成功提交申请时，后台需要触发相应的订单、消息和审计模块。

![](https://cdn-images-1.medium.com/max/3032/1*tTKBtTxsUjuSUkZIw9l3Dw.png)

如何编写代码呢？许多程序员可能会这样写：

```JavaScript
function applySuccess() {
  // 通知消息中心获取最新内容
  MessageCenter.fetch();
  // 更新订单信息
  Order.update();
  // 通知负责人审核
  Checker.alert();
}
```

这看起来还不错。

当然，代码本身并没有什么直接的错误，但是在实践中，它很可能会发生：

* `MessageCenter` 最初是由 Jon 开发的，他后来因为某些原因将 `MessageCenter.fetch` 重新命名为`MessageCenter.request`。这将导致你需要更改 `applySuccess` 函数，否则代码会报错。
* 订单模块最初是由 Bob 开发的，但是他因为工作量太大还没有写 `Order.update` 方法。这使得你的代码不可用，并且只能临时删除该函数。

更糟糕的是，你的项目常常不只依赖于这三个模块。例如，当申请成功时，我们需要提交一个日志。你如何处理这种情况？可能需要再次修改原始函数。

```JavaScript
function applySuccess() {
  // 通知消息中心获取最新内容
  MessageCenter.fetch();
  // 更新订单信息
  Order.update();
  // 通知负责人审核
  Checker.alert();
  Log.write();
  // 更多...
  // ...
}
```

随着涉及的模块越来越多，我们的代码变得越来越臃肿，维护起来也越来越困难。这时，发布-订阅模式就可以优雅地解决问题。

![](https://cdn-images-1.medium.com/max/3764/1*WkZyWe_HUw7YUuE-ASrL9Q.png)

你是否觉得 EventEmitter 很熟悉？没错，在面试中经常会出现？

发布-订阅是一种消息传递范例，消息的发布者不直接将消息发送给特定的订阅者，而是通过消息通道广播消息，订阅者通过订阅获得他们想要的消息。

首先，让我们写一个 EventEmit 函数：

```JavaScript
const EventEmit = function() {
  this.events = {};
  this.on = function(name, cb) {
    if (this.events[name]) {
      this.events[name].push(cb);
    } else {
      this.events[name] = [cb];
    }
  };
  this.trigger = function(name, ...arg) {
    if (this.events[name]) {
      this.events[name].forEach(eventListener => {
        eventListener(...arg);
      });
    }
  };
};
```

上面我们写了一个 EventEmit 函数，然后我们的代码可以改为：

```JavaScript
let event = new EventEmit();
MessageCenter.fetch() {
  event.on('success', () => {
    console.log('update MessageCenter');
  });
}
Order.update() {
  event.on('success', () => {
    console.log('update Order');
  });
}
Checker.alert() {
  event.on('success', () => {
    console.log('Notify Checker');
  });
}
event.trigger('success');
```

这样是不是更好呢？所有的事件都是相互独立的。我们可以在不影响其他模块的情况下随时添加、修改和删除事件。

当你负责一个基本上满足以上条件的模块时，可以考虑使用发布-订阅模式。

## 装饰者模式

让我们直接来看一个例子吧。

了解 React 的人都知道，高阶组件实际上只是一个函数。它接受一个组件作为参数并返回一个新组件。

所以，让我们来编写一个高阶组件（HOC），并使用它来装饰 TargetComponent。

```JavaScript
import React from 'react';
const yellowHOC = WrapperComponent => {
  return class extends React.Component {
    render() {
      <div style={{ backgroundColor: 'yellow' }}>
        <WrapperComponent {...this.props} />
      </div>;
    }
  };
};
export default yellowHOC;
```

在上面的代码中，我们定义了一个装饰黄色背景的高阶组件，我们使用它来装饰目标组件。

让我们看看，这里是如何使用这个高阶组件：

```JavaScript
import React from 'react';
import yellowHOC from './yellowHOC';
class TargetComponent extends Reac.Compoment {
  render() {
    return <div>hello world</div>;
  }
}
export default yellowHOC(TargetComponent);
```

在上面的例子中，我们设计了组件 yellowHOC 来包装其他组件。这就是装饰者模式。

你是否会感到困惑呢？让我们看一下装饰者模式的另一个例子。

```JavaScript
// Jon was originally a Chinese speaker
const jonWrite = function() {
  this.writeChinese = function() {
    console.log('I can only write Chinese');
  };
};
// Add the ability to write English to Jon through the decorator
const Decorator = function(old) {
  this.oldWrite = old.writeChinese;
  this.writeEnglish = function() {
    console.log('Give Jon the ability to write English');
  };
  this.newWrite = function() {
    this.oldWrite();
    this.writeEnglish();
  };
};
const oldJonWrite = new jonWrite();
const decorator = new Decorator(oldJonWrite);
decorator.newWrite();
```

## 责任链模式

假设我们在向公司申请购买一件设备时，必须遵循以下流程：

1. 申请该装置
2. 选择送货地址
3. 选择一位负责人审批

许多初学者将此视为非常简单的需求，并开始编写这样的代码。

```JavaScript
function applyDevice(data) {
  // some code to apply device
  // ...
  // Then go to the next step
  selectAddress(nextData);
}
function selectAddress(data) {
  // some code to select address
  // ...
  
  // Then go to the next step
  selectChecker(nextData);
}
function selectChecker(data) {
  // Some code to select a person to review
  // ...
}
```

看起来已经满足了要求，但实际上，上面有一个非常大的缺点：我们的采购流程可能会改变，比如增加一个库存检查流程。然后，你必须彻底地更改原始代码，这对于维护代码设计是非常困难的。

在这一点上，我们可以考虑使用责任链模式。

我们可以这样改写代码：

```JavaScript
const Chain = function(fn) {
  this.fn = fn;
  
  this.setNext = function() {}
  this.run = function() {}
}
const applyDevice = function() {}
const chainApplyDevice = new Chain(applyDevice);
const selectAddress = function() {}
const chainSelectAddress = new Chain(selectAddress);
const selectChecker = function() {}
const chainSelectChecker = new Chain(selectChecker);
chainApplyDevice.setNext(chainSelectAddress).setNext(chainSelectChecker);
chainApplyDevice.run();
```

这样有什么好处呢？我们做的第一件事是解耦，我们之前的方法是在函数 A 中调用函数 B，然后在函数 B 中调用函数 C。但是现在它不同了，每个函数都是相互独立的。

现在，假设我们需要在申请设备后选择地址之前检查库存。在代码中使用责任链模式，我们可以通过简单地修改代码来完成需求。

当你负责的模块满足以下条件时，请考虑使用责任链模式。

* 每个流程的代码都可以复用
* 每个流程都有固定的执行顺序
* 每个流程都可以重新组合

---

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
