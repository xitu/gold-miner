> * 原文地址：[4 Useful JavaScript Design Patterns You Should Know](https://medium.com/javascript-in-plain-english/4-useful-javascript-design-patterns-you-should-know-b4e1404e3929)
> * 原文作者：[bitfish](https://medium.com/@bf2)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/4-useful-javascript-design-patterns-you-should-know.md](https://github.com/xitu/gold-miner/blob/master/article/2020/4-useful-javascript-design-patterns-you-should-know.md)
> * 译者：
> * 校对者：

# 4 Useful JavaScript Design Patterns You Should Know

![Photo by [Neven Krcmarek](https://unsplash.com/@nevenkrcmarek?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/9820/0*0VPoIQRlovWvRq4d)

I wonder if you are as confused about the design patterns as I was before. In my case, I developed my own personal projects before, with almost no thought of design. Therefore, there are many design defects and code implementation defects, which bring a lot of trouble for later maintenance and development iterations.

But to be a high-level developer, one of the basic requirements is to be proficient in design patterns. To this end, I read a lot of books and blogs about design patterns, but I only learned some theoretical knowledge at the beginning. I never put it into practice.

It was not until later that I began to study the source code of some well-known open-source projects and consulted many predecessors in real work that I gradually mastered the use of design patterns. Now I have summed up some of my experience and written this article, I hope it can help you.

This article discusses the use of the following design patterns:

* **Strategy Pattern**
* **Publish–subscribe pattern**
* **Decorator Pattern**
* **Chain of Responsibility Pattern**

#### What are design patterns?

Wiki said:

> # A software design pattern is a general, reusable solution to a commonly occurring problem within a given context in software design.

This may be a little abstract, but you can understand it this way: Now imagine you’re playing a video game and it takes you five hours to get through. And then you play it again, because you’ve played it before, and you’ve accumulated some skills, so it only takes you two hours. Your friend asks you for tips on how to play the game, so you tell him some tips, which are design patterns.

#### Why do we need design patterns?

The functionality of the software we develop always changes over time. The value of design patterns is to better organize our current code and make it easier to iterate in the future.

Let’s learn about design patterns through real examples now.

## Strategy Pattern

Suppose we have the requirement that when a user tries to open a page, the correct content can only be seen if the following conditions are met:

* The user is a registered user of this site
* The user’s level is not less than 1
* The user must be a front-end development engineer
* The type of user is an active user

Now we need to write the judgment logic to make sure that only the right users can see the content. What do you do? Many novice programmers might simply pick up the ‘if-else’ and write code like this:

```JavaScript
function checkAuth(data) {
  if (data.role !== 'registered') {
    console.log('The user is not a registered user');
    return false;
  }
  if (data.grade < 1) {
    console.log("The user's level is less than 1");
    return false;
  }
  if (data.job !== 'FE') {
    console.log('The user is not a front-end development engineer');
    return false;
  }
  if (data.type !== 'active user') {
    console.log('The user is not an active user');
    return false;
  }
}
```

I’m sure you’ve all written similar code before, but it has the following problems:

* The `checkAuth` function is bloated.
* Each judgment function cannot be reused
* Violates the open-closed principle

So how do we solve this problem? This is where the strategy pattern comes into play.

It is a design pattern that allows the encapsulation of alternative algorithms for a particular task. It defines a family of algorithms and encapsulates them in such a way that they are interchangeable at runtime without client interference or knowledge.

Now let’s use the strategy pattern to improve the previous code.

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

The above code is a list of the strategies we will use, and we continue to complete the validation logic.

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

All right, now let’s implement the previous requirement.

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

After looking at the code above, you may think: the amount of code seems to have increased!

As we said before, the value of design patterns is that they make it easier for you to cope with change. If your requirements don’t change from the beginning to the end, there’s really not much value in using design patterns. However, if the requirements of the project change, then the value of the design pattern can be reflected.

For example, on another page, our verification logic for the user is different, we just need to ensure that:

* The user is a registered user of this site
* The user’s level is not less than 1

At this point, we find that we can easily reuse the previous code:

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

We can see that by applying the strategy pattern, our code becomes more maintainable. You can now consider applying the strategy pattern to your own projects, such as when handling form validation.

When the module you are responsible for basically meets the following conditions, you might consider using the strategy pattern to optimize your code.

* The strategies under each judgment condition are independent and reusable
* The internal logic of the strategy is relatively complex
* Strategies need to be flexibly combined

## Publish–subscribe pattern

Now let’s look at another requirement: when the user successfully completes an application, the background needs to trigger the corresponding order, message, and audit modules.

![](https://cdn-images-1.medium.com/max/3032/1*tTKBtTxsUjuSUkZIw9l3Dw.png)

How would you code? Many programmers might write something like this:

```JavaScript
function applySuccess() {
  // Notify the message center for the latest content
  MessageCenter.fetch();
  // Update order information
  Order.update();
  // Inform the person in charge to review
  Checker.alert();
}
```

This makes the code look fine.

Sure, there’s nothing directly wrong with the code itself, but in practice, it’s likely to happen:

* MessageCenter was originally developed by Jon, who later renamed `MessageCenter.fetch` to `MessageCenter.request` for some reason. This causes you to change the applySuccess function, or your code will crash.
* The Order module was originally developed by Bob, but he hasn’t written `Order.update` yet because of the number of tasks. This makes your code unusable and you can only temporarily remove the function.

Even worse, your project often relies on more than just these three modules. For example, when the application is successful, we need to submit a log. How do you handle this situation? You may have to modify the original function again.

```JavaScript
function applySuccess() {
  // Notify the message center for the latest content
  MessageCenter.fetch();
  // Update order information
  Order.update();
  // Inform the person in charge to review
  Checker.alert();
  Log.write();
  // Maybe more
  // ...
}
```

As more and more modules are involved, our code becomes more bloated and harder to maintain. That’s when the publish-and-subscribe model can save the disaster.

![](https://cdn-images-1.medium.com/max/3764/1*WkZyWe_HUw7YUuE-ASrL9Q.png)

Do you find EventEmitter familiar? That’s right, it comes up a lot in interview questions?

Publish-subscribe is a messaging paradigm in which the publisher of a message does not send the message directly to a particular subscriber, but instead broadcasts it over a message channel, and subscribers get the message they want through the subscription.

First, let’s write an EventEmit function:

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

Above we wrote an EventEmit, then our code can be changed to this:

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

Isn’t that better? All events are independent of each other. We can add, modify, and delete an event at any time without affecting other modules.

When you’re responsible for a module that basically satisfies the following conditions, you might consider using the publish-subscribe pattern.

## Decorator Pattern

Now let’s go straight to an example.

As anyone who knows React knows, a higher-order component is really just a function. It takes a component as an argument and returns a new component.

So let’s write a higher-order component, HOC, and use it to decorate the TargetComponent.

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

In the code above, we define a higher-order component that decorates a yellow background, which we use to decorate the target component.

Here’s how this higher-order component is used:

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

In the above example, we designed the component yellowHOC to wrap around the other components. This is decorator pattern.

If you have any questions, let’s look at another example of the decorator pattern.

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

## Chain of Responsibility Pattern

Suppose that when we apply to purchase a piece of a device from the company, we must follow the following procedure in order:

1. To apply for the device
2. Select shipping address
3. Select a person in charge to review

Many novices see this as a very simple requirement and start writing code like this.

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

It looks like the requirements have been met, but in fact, the above has a very big drawback: our purchase process may change, such as adding an inventory checking process. Then you have to change the original code drastically, which is very difficult to maintain code design.

At this point, we can consider using the chain of responsibility pattern.

We can rewrite the code like this:

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

What are the benefits? The first thing we did was we decoupled the nodes, and the way we did it was we called function B in function A, and then we called function C in function B. But now it’s different, each function is independent of each other.

Now, suppose we need to check the inventory before we select the address after we apply for the device. In the responsibility chain pattern of the code, we can complete the requirements by simply modify the code.

Consider using the chain of responsibility pattern when the module you are responsible for meets the following criteria.

* The code of each process can be reused
* Each process has a fixed order of execution
* Each process can be recombined

---

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
