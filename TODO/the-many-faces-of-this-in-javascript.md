
> * 原文地址：[The many faces of `this` in javascript](https://blog.pragmatists.com/the-many-faces-of-this-in-javascript-5f8be40df52e)
> * 原文作者：[Michał Witkowski](https://blog.pragmatists.com/@michal.witkowski?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/the-many-faces-of-this-in-javascript.md](https://github.com/xitu/gold-miner/blob/master/TODO/the-many-faces-of-this-in-javascript.md)
> * 译者：[lsvih](https://github.com/lsvih)
> * 校对者：[lampui](https://github.com/lampui), [zerosrat](https://github.com/zerosrat)

# Javascript 中多样的 this

![](https://cdn-images-1.medium.com/max/800/1*7SJ32rCU2QasXn9Uyv8NyQ.jpeg)

本文将尽量解释清楚 JavaScript 中最基础的部分之一：执行上下文（execution context）。如果你经常使用 JS 框架，那理解 `this` 更是锦上添花。但如果你想更加认真地对待编程的话，理解上下文无疑是非常重要的。

我们可以像平常说话一样来使用 `this`。例如：我会说“我妈很不爽，这（this）太糟糕了”，而不会说“我妈很不爽，我妈很不爽这件事太糟糕了”。理解了 `this` 的上下文，才会理解我们为什么觉得很糟糕。

现在试着把这个例子与编程语言联系起来。在 Javascript 中，我们将 `this` 作为一个快捷方式，一个引用。它指向其所在上下文的某个对象或变量。

现在这么说可能会让人不解，不过很快你就能理解它们了。


## **全局上下文**

如果你和某人聊天，在刚开始对话、没有做介绍、没有任何上下文时，他对你说：“这（this）太糟糕了”，你会怎么想？大多数情况人们会试图将“这（this）”与周围的事物、最近发生的事情联系起来。

对于浏览器来说也是如此。成千上万的开发者在没有上下文的情况下使用了 `this`。我们可怜的浏览器只能将 `this` 指向一个全局对象（大多数情况下是 window）。

```
var a = 15;
console.log(this.a);
// => 15
console.log(window.a);
// => 15
```
[以上代码需在浏览器中执行]

函数外部的任何地方都为全局上下文，`this` 始终指向全局上下文（window 对象）。

## 函数上下文

以真实世界来类比，函数上下文可以看成句子的上下文。“我妈很不爽，这（this）很不妙。”我们都知道这句话中的 `this` 是什么意思。其它句子中同样可以使用 `this`，但是由于其处于所处上下文不同因而意思全然不同。例如，“风暴来袭，这（this）太糟糕了。”

JavaScript 的上下文与对象有关，它取决于函数被执行时所在的对象。因此 `this` 会指向被执行函数所在的对象。

```
var a = 20;

function gx () {
    return this;
}

function fx () {
    return this.a;
}

function fy () {
    return window.a;
}

console.log(gx() === window);
// => True
console.log(fx());
// => 20
console.log(fy());
// => 20
```

`this` 由函数被调用的方式决定。如你所见，上面的所有函数都是在全局上下文中被调用。

```
var o = {
  prop: 37,
  f: function() {
    return this.prop;
  }
};

console.log(o.f());
// => 37
```

当一个函数是作为某个对象的方法被调用时，它的 `this` 指向的就是这个方法所在的对象。

```
function fx () {
    return this;
}

var obj = {
    method: function () {
        return this;
    }
};

var x_obj = {
    y_obj: {
        method: function () {
            return this;
        }
    }
};

console.log(fx() === window);
// => True — 我们仍处于全局上下文中。
console.log(obj.method() === window);
// => False — 函数作为一个对象的方法被调用。
console.log(obj.method() === obj);
// => True — 函数作为一个对象的方法被调用。
console.log(x_obj.y_obj.method() === x_obj)
// => False — 函数作为 y_obj 对象的方法被调用，因此 `this` 指向的是 y_obj 的上下文。
```

**例 4**

```
function f2 () {
  'use strict'; 
  return this;
}

console.log(f2() === undefined);
// => True
```

在严格模式下，全局作用域的函数在全局作用域被调用时，`this` 为 `undefined`。

**例 5**

```
function fx () {
    return this;
}

var obj = {
    method: fx
};

console.log(obj.method() === window);
// => False
console.log(obj.method() === obj);
// => True
```

与前面的例子一样，无论函数是如何被定义的，在这儿它都是作为一个对象方法被调用。

**例 6**

```
var obj = {
    method: function () {
        return this;
    }
};

var sec_obj = {
    method: obj.method
};

console.log(sec_obj.method() === obj);
// => False
console.log(sec_obj.method() === sec_obj);
// => True
```

`this` 是动态的，它可以由一个对象指向另一个对象。

**例 7**

```
var shop = {
  fruit: "Apple",
  sellMe: function() {
    console.log("this ", this.fruit);
// => this Apple
    console.log("shop ", shop.fruit);
// => shop Apple
  }
}

shop.sellMe()
```

我们既能通过 `shop` 对象也能通过 `this` 来访问 `fruit` 属性。

**例 8**

```
var Foo = function () {
    this.bar = "baz"; 
};

var foo = new Foo();

console.log(foo.bar); 
// => baz
console.log(window.bar);
// => undefined
```

现在情况不同了。`new` 操作符创建了一个对象的实例。因此函数的上下文设置为这个被创建的对象实例。

## Call、apply、bind

依旧以真实世界举例：“这（this）太糟糕了，因为我妈开始不爽了。”

这三个方法可以让我们在任何期许的上下文中执行函数。让我们举几个例子看看它们的用法：

**例 1**

```
var bar = "xo xo";

var foo = {
    bar: "lorem ipsum"
};

function test () {
    return this.bar;
}

console.log(test());
// => xo xo — 我们在全局上下文中调用了 test 函数。
console.log(test.call(foo)); 
// => lorem ipsum — 通过使用 `call`，我们在 foo 对象的上下文中调用了 test 函数。
console.log(test.apply(foo));
// => lorem ipsum — 通过使用 `apply`，我们在 foo 对象的上下文中调用了 test 函数。
```

这两种方法都能让你在任何需要的上下文中执行函数。

`apply` 可以让你在调用函数时将参数以不定长数组的形式传入，而 `call` 则需要你明确参数。

**例 2**

```
var a = 5;

function test () {
    return this.a;
}

var bound = test.bind(document);

console.log(bound()); 
// => undefined — 在 document 对象中没有 a 这个变量。
console.log(bound.call(window)); 
// => undefined — 在 document 对象中没有 a 这个变量。在这个情况中，call 不能改变上下文。

var sec_bound = test.bind({a: 15})

console.log(sec_bound())
// => 15 — 我们创建了一个新对象 {a:15}，并在此上下文中调用了 test 函数。
```

`bind` 方法返回的函数的下上文会被永久改变。
在使用 bind 之后，其上下文就固定了，无论你再使用 call、apply 或者 bind 都无法再改变其上下文。

## **箭头函数（ES6）**

箭头函数是 ES6 中的一个新语法。它是一个非常方便的工具，不过你需要知道，在箭头函数中的上下文与普通函数中的上下文的定义是不同的。让我们举例看看。

**例 1**

```
var foo = (() => this);
console.log(foo() === window); 
// => True
```

当我们使用箭头函数时，`this` 会保留其封闭范围的上下文。

**例 2**

```
var obj = {method: () => this};

var sec_obj = {
  method: function() {
    return this;
  }
};

console.log(obj.method() === obj);
// => False
console.log(obj.method() === window);
// => True
console.log(sec_obj.method() === sec_obj);
// => True
```

请注意箭头函数与普通函数的不同点。在这个例子中使用箭头函数时，我们仍然处于 window 上下文中。
我们可以这么看：

> *x => this.y equals function (x) { return this.y }.bind(this)*

可以将箭头函数看做其始终 `bind` 了函数外层上下文的 `this`，因此不能将它作为构造函数使用。下面的例子也说明了其不同之处。

**例 3**

```
var a = "global";

var obj = {
 method: function () {
   return {
     a: "inside method",
     normal: function() {
       return this.a;
     },
     arrowFunction: () => this.a
   };
 },
 a: "inside obj"
};

console.log(obj.method().normal());
// => inside method
console.log(obj.method().arrowFunction());
// => inside obj
```

当你了解了函数中动态（dynamic） `this` 与词法（lexical）`this` ，在定义新函数的时候请三思。如果函数将作为一个方法被调用，那么使用动态 `this`；如果它作为一个子程序（subroutine）被调用，则使用词法 `this`。

> 译注：了解动态作用域与词法作用域可[阅读此文章](http://www.cnblogs.com/xiaohuochai/p/5700095.html)

## **相关阅读**

- [http://www.joshuakehn.com/2011/10/20/Understanding-JavaScript-Context.html](http://www.joshuakehn.com/2011/10/20/Understanding-JavaScript-Context.html)
- [http://ryanmorr.com/understanding-scope-and-context-in-javascript/](http://ryanmorr.com/understanding-scope-and-context-in-javascript/)
- [https://hackernoon.com/execution-context-in-javascript-319dd72e8e2c](https://hackernoon.com/execution-context-in-javascript-319dd72e8e2c)
- [http://2ality.com/2012/04/arrow-functions.html](http://2ality.com/2012/04/arrow-functions.html)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
