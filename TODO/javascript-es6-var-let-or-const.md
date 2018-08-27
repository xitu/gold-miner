> * 原文链接: [JavaScript ES6+: var, let, or const?](https://medium.com/javascript-scene/javascript-es6-var-let-or-const-ba58b8dcde75#.twa6gzmfp)
* 原文作者: [Eric Elliott](https://medium.com/@_ericelliott)
* 译文出自: [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者: [Gran](https://github.com/Graning)
* 校对者:[Yaowenjie](https://github.com/Yaowenjie),[zhangchen](https://github.com/zhangchen91)

# ES6 中 的 var、let 和 const 应该如何选择？

通过学习**让事情变得简单**这个原则也许是成为更好的开发者途径中最重要的事。这意味着在标识符的上下文中**单个标识符应该只被用来表示单一的概念**。

有时候为了表示一些数据就很容易创建一个标识符，然后使用该标识符作为一个临时的空间去存储一些值作为一个过渡。

举个例子，你可能只为了得到 URL 中的 query string 的某个值，而先创建了一个标识符存储完整 URL ，然后是 query string ，最后才是该值。这种做法应该尽量避免。

如果你对 URL、 query string、 GET 参数的值分别使用不同的标识符，是很容易理解的。

这就是为什么在 ES6 上我喜欢 _`const`_ 胜过 _`let`_ 。在JavaScript中，**_`const`_ 意味着该标识符不能被重新赋值**。不要被 _immutable values_ 弄糊涂了。不像那些诸如 Immutable.js 与 Mori 产生的真正不可变的数据类型，_`const`_声明的对象可以有属性变化。

如果我不需要重新赋值，**_`const`_ 就是我的默认选择** 相比 _`let`_ 要常用的多，因为我想让它在代码中的使用尽可能的清晰。

当我后面需要给一个变量重新赋值时一般使用 _`let`_。因为我**使用一个变量对应一个东西，**现在 _`let`_ 越来越多的被使用在循环和算法上面。

我在 ES6 中从不使用 _`var`_ 。例如在一个 for 循环块范围值中，我想不出哪里使用 _`var`_ 比使用 _`let`_ 要好。

**_`const`_**  适用于**赋值后不会再做修改**的情况。

**_`let`_**  适用于**赋值后还会修改**的情况。例如循环计数，或者是一个算法的值交换过程。它同时标志着这个变量只能被用在**所定义的块作用域**之中，也就是说它并不总是包含在整个函数中。

**_`var`_**  现在是**最坏的选择**当你在 JavaScript 中定义一个变量时。 它在定义后可能还会修改，可能会在全局函数中使用，或者说只为块或循环。

#### 警告：

现在在 ES6 中，因为 _`let`_ 和 _`const`_ 的暂时性死区效应，使用 _`typeof`:_ 来检测标识符已经不再安全了。 

译者注：在声明之前对标识符使用 _`typeof`:_ ，会抛出 ReferenceError。

```
function foo () {
  typeof bar;
  let bar = ‘baz’;
}

foo(); // ReferenceError: can't access lexical declaration
       // `bar' before initialization
```

但是不要紧只要你采用我的方法 [“Programming JavaScript Applications”](http://pjabook.com)，在你使用它们之前进行标识符初始化。

#### P.S.

如果你需要通过清除它释放一个值，你可以考虑使用 _`let`_ 而不是 _`const`_。如果你需要对垃圾回收进行微管理，你应该去看“Slay’n the Waste Monster”, 视频链接:
[![](https://i.ytimg.com/vi/RWmzxyMf2cE/sddefault.jpg)](https://medium.com/media/6f512d3acc928ffcb80ac4f5586c2e87?maxWidth=700)
