> * 原文链接: [JavaScript ES6+: var, let, or const?](https://medium.com/javascript-scene/javascript-es6-var-let-or-const-ba58b8dcde75#.twa6gzmfp)
* 原文作者: [Eric Elliott](https://medium.com/@_ericelliott)
* 译文出自: [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者: [Gran](https://github.com/Graning)
* 校对者:


### ES6 中 的 var、let 和 const 应该如何选择？

你可以通过学习成为更好的开发者，最重要的是**让事情变得简单**。在上下文的标识符中，让事情变得简单意味着**单个标识符应该只被用来表示一个单一的概念。**

有时候很容易创建一个标识符表示一些数据，然后使用该标识符作为一个临时的空间去存储一些值作为一个过渡。

举个例子，你可能在查询完某个字符串参数值之后，通过其储存了一个完整的URL，只查询此字符串的话，就是该值。这种做法应该尽量避免。

这很容易理解，如果你对URL使用标识符，一个不同的查询字符串，最终用标识符来储存你之后的参数值。

这就是为什么在 ES6 上我喜欢_`const`_胜过_`let`_。在JavaScript中，**_`const`_ 意味着该标识符不能被重新赋值**。（不要被_immutable values_弄糊涂了。这不像真正的不可变的数据类型，就像那些由 Immutable.js 与 Mori 产生的东西。_`const`_可以有属性变化。）

如果我不需要重新赋值，**_`const`_ 就是我的默认选择** 相比 _`let`_ 要常用的多，因为我想让它在代码中的使用尽可能的清晰。

当我后面需要给一个变量重新赋值时一般使用 _`let`_。因为我**使用一个变量对应一个东西，**现在 _`let`_ 越来越多的被使用在循环和算法上面。

我在 ES6 中 不使用_`var`_。例如在一个 for 循环块范围值中，我想不出哪里使用 _`var`_ 比使用 _`let`_ 要好。

**_`const`_** 适用于 **赋值后不会再做修改** 的情况。

**_`let`,_**  适用于 **赋值后还会修改** 的情况。例如循环计数，或者是一个算法的值交换。它同时标志着这个变量只能被用在 **所定义的块作用域** 之中，这并不总是包含在整个函数中。 

**_`var`_** 现在是 **最坏的选择** 当你在 JavaScript 定义一个变量时。 它在定义后可能还会修改，可能会在全局函数中使用，或者说只为块或循环。

#### 警告：

现在 ES6 中的 _`let`_ 和 _`const`_ 已经不再对 _`typeof`:_ 的标识符进行安全检查了。 

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

如果你需要通过清除它释放一个值，你可以考虑使用 _`let`_ 而不是 _`const`_。如果你需要对垃圾回收进行微管理，你应该去看“Slay’n the Waste Monster”, instead: [https://medium.com/media/6f512d3acc928ffcb80ac4f5586c2e87?maxWidth=700](https://medium.com/media/6f512d3acc928ffcb80ac4f5586c2e87?maxWidth=700)