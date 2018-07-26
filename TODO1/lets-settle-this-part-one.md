> * 原文地址：[Let’s settle ‘this’ — Part One](https://medium.com/@nashvail/lets-settle-this-part-one-ef36471c7d97)
> * 原文作者：[Nash Vail](https://medium.com/@nashvail?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/lets-settle-this-part-one.md](https://github.com/xitu/gold-miner/blob/master/TODO1/lets-settle-this-part-one.md)
> * 译者：
> * 校对者：

# Let’s settle ‘this’ — Part One> * 原文地址：[Let’s settle ‘this’ — Part One](https://medium.com/@nashvail/lets-settle-this-part-one-ef36471c7d97)
> * 原文作者：[Nash Vail](https://medium.com/@nashvail?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/lets-settle-this-part-one.md](https://github.com/xitu/gold-miner/blob/master/TODO1/lets-settle-this-part-one.md)
> * 译者：[geniusq1981](https://github.com/geniusq1981)
> * 校对者：

# 让我们一起解决‘this’ — 第一部分

![](https://i.loli.net/2018/07/23/5b553df9455fa.png)

难道我们都不能理解吗?在某种程度上，几乎所有的JavaScript开发人员都曾经思考过“this”这个事情。对我来说，每当“this”出来捣乱的时候，我就想方设法地去解决掉它，然后就把它忘了，我想您应该也曾遇到过这样的场景。但是今天，让我们彻底解决这个问题吧，让我们一次性一劳永逸地解决“this”的问题。
Can’t we all relate to this? At some point ‘this’ has been a thing to think about for almost all JavaScript developers. For me, whenever ‘this’ started to rear its ugly head I somehow managed to make things work and then forgot about it, and I’d like think you did the same, at some point. But let’s be done with it, today, once and for all _`*dramatic drumroll*`_ let’s settle ‘this’.

几天前，我在图书馆遇到了一个意想不到的事情。

![](https://i.loli.net/2018/07/23/5b553e2648b71.png)

这本书的整个第二章都是关于“this”的，我很有自信地通读了一遍，但是发现其中有些页的内容里面讲到的“this”，我居然搞不懂它们是什么，需要猜测。是时候反省一下我多度自信的愚蠢行为了。我又重读了这一章好几遍，发觉这些内容是每个 Javascript 开发人员都应该了解的。

因此，我试图以一种更彻底的方式和更多的示例代码展示 [凯尔·辛普森](http://getify.me/) 在他的 [这本书](https://github.com/getify/You-Dont-Know-JS) 中描述的规范。

现在我不是全部只讲理论，我会直接从我遇到过的困难问题的示例开始讲起，我希望它们也是你感到困难的问题。不管这些问题是否会困挠你，我都会给你一个解释说明，我会一个接一个地向你介绍所有的规则，当然还有一些额外的小惊喜。

在开始之前，我假设您已经了解了一些 JavaScript 的背景知识，当我讲到 global、window、this、prototype 等等的时候，你知道他们是什么意思。这篇文章中，我会同时使用 global 和 window，在这里它们就是一回事，是可以互换的。

在下面给出的所有代码示例中，您的任务就是猜测控制台输出的结果是什么。如果你猜对了，就给你自己加一分。准备好了吗？让我们开始吧。

#### Example #1

```Javascript
function foo() {  
 console.log(this);   
 bar();  
}

function bar() {  
 console.log(this);   
 baz();  
}

function baz() {  
 console.log(this);   
}

foo();
```

你被难住了吗？对于测试，您当然可以把这段代码复制下来，然后在浏览器或者 Node 的运行环境中去运行看看结果。再来一次,你被难住了吗？好吧，我就不再问了。但说真的，如果你没被难住，那就给你自己加一分。

如果您运行上面的代码，就会在控制台中看到 global 对象被打印出三次。为了解释这一点，让我来介绍 **第一个规则，默认绑定**。规则规定，当一个函数执行独立调用时，例如只是 _funcName();_ ，这时函数的 “this” 被指向 global 对象。

要理解的一件事是，在调用函数之前，“this”并没有绑定到一个函数，因此，要找到“this”，您应该密切注意该函数是如何调用或调用的，而不是在哪里。所有三个函数调用 _foo();bar();和 baz();_ 都是是独立的调用，因此这三个函数的 “this” 都是全局对象。

#### Example #2

```Javascript
‘use strict’;
function foo() {
 console.log(this); 
 bar();
}
function bar() {
 console.log(this); 
 baz();
}
function baz() {
 console.log(this); 
}
foo();
```

注意最开始的“use strict”。在这种情况下，你觉得控制台打印的是什么？当然，如果您了解 _strict mode_ ，您就会知道在严格模式下全局对象不会被默认绑定。所以，你得到的打印信息是三次 _undefined_ 的输出，而不再是 _global_。

回顾一下，在一个简单调用函数中,比如独立调用，“this”在非严格模式下指向全局对象，但在严格模式下不允许全局对象默认绑定，因这些函数中的 “this” 是 undefined。

为了使我们的默认绑定概念更加具体，这里有一些示例。

#### Example #3

```Javascript
function foo() {
 function bar() {
  console.log(this); 
 } 
 bar();
}

foo();
```

_foo_先被调用，然后再调用 _bar_，_bar_ 将“this”打印到控制台中。这里的技巧是看看函数是如何被调用的。_foo_ 和 _bar_ 都被单独调用，因此，他们内部的“this”都是指向全局对象。但是由于 _bar_ 是唯一执行打印的函数，所以我们看到全局对象在控制台中输出了一次。

我希望你没有回答 _foo_ 或 _bar_ 。有没有？

我们已经了解了默认绑定。让我们再做一个简单的。在下面的示例中，控制台输出什么？

#### Example #4

```Javascript
var a = 1;

function foo() {  
 console.log(this.a);  
}

foo();
```

输出结果是 undefined？是 1？还是什么？

如果您已经很好地遵循了这个的步骤，那么您应该知道控制台输出的是“1”。为什么?首先，默认绑定作用于函数 _foo_ 。因此 _foo_ 中的“this”指向全局对象，并且 _a_ 被声明为全局变量，这就意味着 _a_ 是全局对象的属性(讨论全局对象污染)，因此 _this.a_ 和 _var a_ 就是同一个东西。

随着本文的深入，我们将继续与默认绑定保持联系，但是现在是时候向您介绍下一个规则了。

#### Example #5

```
var obj = {  
 a: 1,   
 foo: function() {  
  console.log(this);   
 }  
};

obj.foo();
```

这里没有trippy，对象“obj”是登录到控制台的内容。你在这里看到的是**隐绑定。**规则说，当一个函数被调用时，它是一个对象，它应该被用于函数调用的“this”绑定。如果函数调用前面有多个对象(_obj1.obj2. func()_))，那么函数调用(_obj3_)后面的对象就会被绑定。

> One thing to note here is that the function call must be valid which means when you write _obj.func(), func_ should be a property of object _obj._

因此，在上面的调用_object .foo() _obj的示例中是“this”，因此_obj_是打印到控制台的内容。

#### Example #6

```
function logThis() {  
 console.log(this);  
}

var myObject = {  
 a: 1,   
 logThis: logThis  
};

logThis();  
myObject.logThis();
```

你的旅行了吗?:)。我希望不是这样。


全局跟踪_myObject_是记录到控制台的内容。l_ogThis(); _logs global和_myObject.logThis()


有趣的是:

```
console.log(logThis === myObject.logThis); // true
```

为什么不呢?它们当然是相同的函数，但是您可以看到** _logThis_是如何被调用的** *更改其中的“this”的值。当_logThis_进行独立调用时，应用默认绑定规则，但是当_logThis_与前面的对象引用隐式绑定一起调用时，应用默认绑定规则。


不管谁，让我们看看你是怎么处理的(双关语)。

#### Example #8

```
function foo() {  
 var a = 2;  
 this.bar();  
}

function bar() {  
 console.log(this.a);  
}

foo();
```

什么被记录到控制台?首先，您可能会问“_this.bar()?”“你能做到吗?”当然可以，它不会导致错误。


就像示例#4中的_var a_成为全局对象的属性一样，_bar也是。因为foo被调用了单用(如果那是一个词)' this '在foo里面是全局对象(默认绑定)因此是_this。在_foo_和_bar_中的bar_是完全相同的。但实际的问题是，什么会被记录到控制台?


如果你猜对了，“undefined”就会被记录下来。


注意_bar_是如何被调用的?根据它看起来的样子，隐式绑定在这里发挥作用。隐式绑定表示_bar_中的“this”是其前面的对象引用。在_bar_前面的对象引用是全局对象，在foo里面是全局对象，不是吗?因此尝试访问_this。_bar_中的a_等同于试图访问_[global object]。令人惊讶的是，意外并不存在，因此未定义的是登录到控制台的内容。


太棒了!在移动。

#### Example #7

```
var obj = {  
 a: 1,   
 foo: function(fn) {  
  console.log(this);  
  fn();  
 }  
};

obj.foo(function() {  
 console.log(this);  
});
```

请不要让我失望。


函数_foo_接受回调函数作为参数。这就是我们所做的我们在调用_foo_的时候在parans之间放置一个函数。

```
obj.foo( function() { console.log(this); } );
```

但是请注意** * _foo_的调用方式。它是一个独立的调用吗?当然不是，因此第一个登录到控制台的是对象_obj。我们传入的回调函数是什么?在_foo_内部，回调函数变为_fn_，并注意** * _fn_是如何调用的。对，因此_fn_中的' this '是全局对象，因此它是打印到控制台的对象。


希望你不会觉得无聊。顺便问一下，你的分数怎么样?好吗?好吧，这次我准备好绊倒你了。

#### Example #8

```
var arr = [1, 2, 3, 4];

Array.prototype.myCustomFunc = function() {
 console.log(this);
};

arr.myCustomFunc();
```

如果你不知道什么是_。在JavaScript中，prototype_是现在的其他对象，但是如果你是一个JavaScript开发人员，你应该知道它是什么。你知道吗?帮自己一个忙，继续读一些关于原型的内容。我将等待。


那么什么记录?是_Array。prototype_对象?错了!


这是相同的老技巧，请检查**_how_* _custommyfunc_是否被调用。没错，隐式绑定绑定_ar_ to _myCustomFunc_因此登录到控制台的是_arr [1,2,3,4]._


我得到你了吗?

#### Example #9

```
var arr = [1, 2, 3, 4];

arr.forEach(function() {  
 console.log(this);  
});
```

执行上述代码的结果是，全局对象被记录到控制台的次数为4次。如果你绊倒了也没关系。请看示例#7。仍然没有得到它吗?下一个示例将有所帮助。

#### Example #10

```
var arr = [1, 2, 3, 4];

Array.prototype.myCustomFunc = function(fn) {  
 console.log(this);  
 fn();  
};

arr.myCustomFunc(function() {  
 console.log(this);   
});
```

就像示例#7一样，我们将回调函数_fn_作为参数传递给函数_myCustomFunc_。结果是传入的函数会进行独立调用。这就是为什么在前面的示例(#9)中全局对象被记录，因为在forEach中传入的回调函数进行独立调用。


类似地，在本例中，首先登录到控制台的是_arr_，然后是全局对象。我知道这看起来有点复杂，但我相信如果你多注意一点，你会明白的。


让我们继续使用这个数组示例来介绍更多的概念。我想我会在这里用一个缩写词，那么WGL呢?什么。得到。记录?这是下一个例子在我开始变得更老土之前。

#### Example #11

```
var arr = [1, 2, 3, 4];

Array.prototype.myCustomFunc = function() {  
 console.log(this);

(function() {  
 console.log(this);  
 })();

};

arr.myCustomFunc();
```

那么,WGL呢?


答案和第十条完全一样。由您决定为什么_arr_首先被记录。您在_console.log(这个)下面看到的复杂代码块;_是IIFE(立即调用的函数表达式)。这个名字是不言自明的，对吧?在**(** *…*)()中包装的函数;但是它被调用的方式相当于独立调用，因此它内部是全局的，因此全局是被记录的。


即将到来的新概念!让我们看看你对2015年的熟悉程度。

#### Example #12

```
var arr = [1, 2, 3, 4];

Array.prototype.myCustomFunc = function() {  
 console.log(this);

 (function() {  
  console.log(‘Normal this : ‘, this);  
 })();

 (() =\> {  
  console.log(‘Arrow function this : ‘, this);  
 })();

};

arr.myCustomFunc();
```

除了IIFE后的3行额外代码之外，所有内容都与示例#11相同。这实际上也是一种生活，只是语法稍有不同。先生，就是箭头函数。


箭头函数的意思是，这些函数中的“this”是词汇性的。也就是说，当需要将这个函数与这个函数绑定时，函数内部的某些东西会从它周围的函数或范围中获取这个函数。箭头函数周围的函数中的“this”是_arr。因此_ ?

```
// This is WGL
arr [1, 2, 3, 4]
Normal this : global
Arrow function this : arr [1, 2, 3, 4]
```

如果我用箭头函数重写示例#9会怎么样?那么什么会被记录到控制台呢?

```
var arr = [1, 2, 3, 4];

arr.forEach(() => {
 console.log(this);
});
```

上面的例子是一个额外的例子，所以即使你猜对了也不要增加分数。你还在记分吗?这样的书呆子。


现在请密切注意以下示例。我不希望你以任何代价把这个弄错;-)

#### Example #13

```
var yearlyExpense = {

 year: 2016,

 expenses: [
   {‘month’: ‘January’, amount: 1000}, 
   {‘month’: ‘February’, amount: 2000}, 
   {‘month’: ‘March’, amount: 3000}
  ],

 printExpenses: function() {
  this.expenses.forEach(function(expense) {
   console.log(expense.amount + ‘ spent in ‘ + expense.month + ‘, ‘ +    this.year);
   });
  }

};

yearlyExpense.printExpenses();
```

那么,WGL呢?花你的时间。


这是答案，但我希望你在阅读解释之前先自己想想。

```
1000 spent in January, undefined  
2000 spent in February, undefined  
3000 spent in March, undefined
```

这都是关于_printExpenses_函数的。首先注意它是如何调用的。隐式绑定?是的。所以_printExpenses_中的' this '是对象_yearlycost。_这意味着_this。expenses_是_yearlyExpense_对象中的_expenses_数组，所以这里没有问题。现在，当它在传递给forEach的回调函数中出现“this”时，它当然是全局对象，请参考例#9。


注意，下面的“固定”版本是如何使用arrow函数进行补救的。

```
var expense = {

 year: 2016,

 expenses: [
   {‘month’: ‘January’, amount: 1000}, 
   {‘month’: ‘February’, amount: 2000}, 
   {‘month’: ‘March’, amount: 3000}
  ],

 printExpenses: function() {
   this.expenses.forEach((expense) => {
    console.log(expense.amount + ‘ spent in ‘ + expense.month + ‘, ‘ +  this.year);
   });
  }

};

expense.printExpenses();
```

因此我们得到了我们想要的输出:

```
1000 spent in January, 2016  
2000 spent in February, 2016  
3000 spent in March, 2016
```

到目前为止，我们已经熟悉了隐式绑定和默认绑定。我们现在知道函数调用的方式决定了它里面的“this”。我们还简要地讨论了箭头函数以及它们是如何被定义为“this”的。


在我们讨论其他规则之前，您应该知道，有些情况下，我们可以隐式地将“this”定义为“this”。让我们快速看一下这些例子。

#### Example #14

```
var obj = {  
 a: 2,  
 foo: function() {  
  console.log(this);  
 }  
};

obj.foo();

var bar = obj.foo;  
bar();
```

无需为这里的所有花哨代码分心，只需注意函数是如何调用的，就可以在函数中找到“this”。你现在一定已经掌握了这个窍门了。首先调用_object .foo()_，因为_foo_前面有一个对象引用，所以首先记录的是对象_obj_。_bar_当然是独立调用，因此全局是下一个登录到控制台的内容。为了提醒您，记住在严格的模式全局对象中不符合默认绑定的条件，因此如果您在未定义的情况下有严格的模式，将会登录到控制台而不是全局的。


bar和foo都是对相同函数的引用，唯一的区别是它们被调用的方式不同。

#### Example #15

```
var obj = {  
 a: 2,  
 foo: function() {  
  console.log(this.a);  
 }  
};

function doFoo(fn) {  
 fn();  
}

doFoo(obj.foo);
```

这里也没什么特别的。我们是通过_obj。作为_doFoo_函数的参数(doFoo听起来很有趣，LOL)。同样，_fn_和_foo_是对同一个函数的引用。现在我要重复同样的旧东西，_fn_undergo独立调用，因此“this”在_fn_中是全局对象。全局对象没有属性_a，因此我们将未定义日志记录到控制台。


这部分就讲完了。在这一部分中，我们讨论了将“this”绑定到函数的两个规则。默认和隐式。我们研究了如何使用“use strict”影响全局对象的绑定，以及如何丢失隐式有界的“this”。我希望在接下来的部分中，您会发现本文对您有所帮助，我们将介绍一些新规则，包括_new_和显式绑定。看到你在那里。


* * *


在我们开始之前，我想用一个“简单”的例子来结束这部分，当我开始使用JS时，这个例子让我感到非常震惊。并不是所有的东西都是彩虹。让我们看看其中的一个。

```
var obj = {  
 a: 2,  
 b: this.a * 2  
};

console.log( obj.b ); // NaN
```

它读起来很好，在_obj_ ' this应该是_obj_，因此是_this。现代应该是2。嗯,没有。因为在这个对象文字里面的' this '是全局对象，所以如果你做这样的事情…

```
var myObj = {  
 a: 2,  
 b: this  
};

console.log(myObj.b); // global
```

全局对象被记录到控制台。您可能会说“那么，myObj是全局对象的属性(例如#4和#8)，不是吗?”“绝对。

```
console.log( this === myObj.b ); // true   
console.log( this.hasOwnProperty(‘myObj’) ); //true
```

“也就是说，如果我做了这样的事情，它就会成功!”

```
var myObj = {  
 a: 2,  
 b: this.myObj.a * 2  
};
```

遗憾的是，这是所有逻辑失败的地方。上面的代码是一个错误的，编译器抱怨它找不到未定义的属性_a_。(http://stackoverflow.com/questions/4616202/self-reference -in object- literations/10766107 #10766107 #10766107)我就是不知道。


幸运的是，getters(隐式绑定)正在为我们提供帮助。

```
var myObj = {  
 a: 2,  
 get b() {  
  return this.a * 2  
 }  
};

console.log( myObj.b ); // 4
```

你坚持到底了!做得很好。[第二部分](https://github.com/xitu/gold- miner/blob/master/todo1/lets-setts-this-part -two.md)等着你，再见。


如果你发现这篇文章很有用，你可以推荐并分享给其他开发者。我经常发表文章，在[Twitter](http://twitter.com/NashVail)和[Medium](http://medium.com/@nashvail)上关注我，以便在这种情况发生时得到通知。


谢谢你的阅读，祝你愉快!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。


![](https://i.loli.net/2018/07/23/5b553df9455fa.png)

Can’t we all relate to this? At some point ‘this’ has been a thing to think about for almost all JavaScript developers. For me, whenever ‘this’ started to rear its ugly head I somehow managed to make things work and then forgot about it, and I’d like think you did the same, at some point. But let’s be done with it, today, once and for all _`*dramatic drumroll*`_ let’s settle ‘this’.

A couple of days ago while in a library I had an unexpected encounter.

![](https://i.loli.net/2018/07/23/5b553e2648b71.png)

The second chapter of the book is all about ‘this’, I read it through, felt confident, couple of pages down a scenario pops up where I need to guess what ‘this’ is, and I mess up. That was one hell of a moment for introspection for my dumb self. I reread the chapter and then some and figured this is something every JS developer should know about.

This therefore is my attempt to present the rules [Kyle](http://getify.me/) describes in [the book](https://github.com/getify/You-Dont-Know-JS) but in a more thorough manner and with a lot more code examples.

Now I am not all about theory, I will right away start with examples that tripped me and I hope they trip you too. Whether you get tripped or not I will provide an explanation and that way, one by one I will introduce you to all the rules and some bonus ones as well.

Before we start, I assume you already have some knowledge of JavaScript and know what I mean when I say global, window, ‘this’, prototype e.t.c. In this article I will be using global and window interchangeably, they necessarily are the same thing for our intents and purposes.

In all of the code examples presented below your task is to guess what will be printed to the console. If you guess right add 1 to your score. Ready? Let’s begin.

#### Example #1

```
function foo() {  
 console.log(this);   
 bar();  
}

function bar() {  
 console.log(this);   
 baz();  
}

function baz() {  
 console.log(this);   
}

foo();
```

Did you trip? For testing, you can of course copy the code and fire it in a browser or in your terminal using node. Again, did you trip? Okay I will stop asking that. But seriously, if you didn’t trip add one to your score.

If you run the code above you get the global object logged to the console, thrice. To explain this let me introduce **the very first rule,** **Default Binding.** The rule says that when a function undergoes standalone invocation i.e just _funcName();_ ‘this’ for such functions resolves to the global object.

One thing to understand is that ‘this’ is not bound to a function until the function is invoked, therefore, to find ‘this’ you should pay a close attention to **_how the function is called or invoked and not where_**. All the three function invocations _foo(); bar();_ and _baz();_ are standalone invocations hence ‘this’ for all the three functions is the global object.

#### Example #2

```
‘use strict’;
function foo() {
 console.log(this); 
 bar();
}
function bar() {
 console.log(this); 
 baz();
}
function baz() {
 console.log(this); 
}
foo();
```

Notice the ‘use strict’ at the very top. What do you think gets printed to the console in this case? Well of course if you are aware of _strict mode_ you’d know that in strict mode the global object is not eligible for default binding. So instead of _global_ getting printed thrice, you get _undefined_ printed thrice.

To recap, inside a function that is invoked plainly i.e standalone invocation ‘this’ refers to the global object except in strict mode where global object default binding is not allowed hence ‘this’ in strict mode inside such functions is undefined.

To make our concept of Default binding more concrete, here are a few more examples.

#### Example #3

```
function foo() {
 function bar() {
  console.log(this); 
 } 
 bar();
}

foo();
```

_foo_ is called which in turn calls _bar_, and _bar_ prints ‘this’ to the console_._ Again, the trick is to see how the function is invoked. Both _foo_ and _bar_ undergo standalone invocation therefore ‘this’ inside both resolves to the global object. But since _bar_ is the only function that does the printing we see the global object logged to the console, once.

I hope you didn’t answer _foo_ or _bar._ Did you?

We’re getting comfortable with Default Binding here. Let’s do a simple one. What gets logged to the console in the example below?

#### Example #4

```
var a = 1;

function foo() {  
 console.log(this.a);  
}

foo();
```

Is it undefined? Is it 1? What is it?

If you have followed this far properly you should know that it is ‘1’ that gets logged to the console. Why? Well, first of all Default Binding applies to our function _foo_ here. Therefore ‘this’ inside _foo_ is the global object and _a_ is declared as a global variable which necessarily means _a_ is a property of the global object (talk about global object pollution) and therefore _this.a_ and _var a_ are the same exact thing.

We’ll keep in touch with Default Binding as we progress further in the article but now it’s time to introduce you to the next rule.

#### Example #5

```
var obj = {  
 a: 1,   
 foo: function() {  
  console.log(this);   
 }  
};

obj.foo();
```

Nothing trippy here really, the object ‘obj’ is what gets logged to the console. What you’re witnessing here is **Implicit Binding.** The rule says that when a function is invoked with an object reference preceding it it’s that object that should be used for the function call’s ‘this’ binding. To mention the obvious in case of the function call being preceded by more than one objects (_obj1.obj2.obj3.func()_), the object right behind the function call (_obj3_) is bound.

> One thing to note here is that the function call must be valid which means when you write _obj.func(), func_ should be a property of object _obj._

Therefore in the example above for the call _obj.foo()_ obj is the ‘this’ and hence _obj_ is what gets printed to the console.

#### Example #6

```
function logThis() {  
 console.log(this);  
}

var myObject = {  
 a: 1,   
 logThis: logThis  
};

logThis();  
myObject.logThis();
```

Did you trip? :). I hope not.

global followed by _myObject_ is what gets logged to the console. l_ogThis();_ logs global  and _myObject.logThis();_ logs _myObject._

An interesting thing to note here is that:

```
console.log(logThis === myObject.logThis); // true
```

Why not? They are of course the same function, but you see **how _logThis_ is invoked** changes the value of ‘this’ inside it. When _logThis_ undergoes standalone invocation, Default binding rule applies but when _logThis_ is invoked with a preceding object reference Implicit binding is applied.

Anywho, let’s see how you handle this (pun intended).

#### Example #8

```
function foo() {  
 var a = 2;  
 this.bar();  
}

function bar() {  
 console.log(this.a);  
}

foo();
```

What gets logged to the console? First of all you might ask “_this.bar()?”_ Can you even do that? Of course we can, it will not result in an error.

Just like _var a_ in Example #4 became a property of the global object so does _bar._ And since foo is invoked stand-a-lonely(if that’s a word) ‘this’ inside foo is the global object (Default Binding) hence _this.bar_ inside _foo_ and _bar_ are the same exact thing. But the actual question is what gets logged to the console?

If you guessed it right ‘undefined’ is what gets logged.

Notice how _bar_ has been invoked? Going by what it looks like, Implicit binding is in play here. Implicit binding says ‘this’ inside _bar_ is the object reference preceding it. The object reference preceding _bar_ is the global object as ‘this’ inside foo is the global object isn’t it? Therefore trying to access _this.a_ inside _bar_ is equivalent to trying to access _[global object].a_ which surprise, surprise doesn’t exist hence undefined is what gets logged to the console.

Awesome! Moving on.

#### Example #7

```
var obj = {  
 a: 1,   
 foo: function(fn) {  
  console.log(this);  
  fn();  
 }  
};

obj.foo(function() {  
 console.log(this);  
});
```

Please don’t let me down.

The function _foo_ accepts a callback function as parameter. And that’s what we did we put a function between the parans of _foo_ while invoking it.

```
obj.foo( function() { console.log(this); } );
```

But notice **how** _foo_ is invoked. Is it a standalone invocation? Of course not, therefore the first thing that gets logged to the console is the object _obj._ What about the callback function we passed in? Inside _foo_ the callback function becomes _fn_ and notice **how** _fn_ is invoked. That’s right, therefore ‘this’ inside _fn_ is the global object hence that is what is printed to the console.

Hope you’re not getting bored. How’s your score doing by the way? Good? Okay, I am all ready to trip you this time.

#### Example #8

```
var arr = [1, 2, 3, 4];

Array.prototype.myCustomFunc = function() {
 console.log(this);
};

arr.myCustomFunc();
```

If you have no idea what a _.prototype_ is in JavaScript just see it as any other object for now but if you are a JavaScript developer you _should_ know what it is. You know what? Do yourself a favor and go ahead and read a little about what prototypes are. I’ll wait.

So what gets logged? Is it the _Array.prototype_ object? Wrong!

It’s the same old trick, check out **_how_** _myCustomFunc_ is invoked. That’s right, Implicit binding binds _arr_ to _myCustomFunc_ hence what gets logged to the console is _arr [1, 2, 3, 4]._

Did I get you?

#### Example #9

```
var arr = [1, 2, 3, 4];

arr.forEach(function() {  
 console.log(this);  
});
```

The result of executing above code is the global object being logged four times to the console. It’s ok if you tripped. Take a look at Example #7. Still not getting it? The next example will help.

#### Example #10

```
var arr = [1, 2, 3, 4];

Array.prototype.myCustomFunc = function(fn) {  
 console.log(this);  
 fn();  
};

arr.myCustomFunc(function() {  
 console.log(this);   
});
```

Just like in example #7 we are passing a callback function _fn_ as a parameter to the function _myCustomFunc_. And as it turns out the passed in function undergoes standalone invocation. That is why in the previous example (#9) the global object gets logged, because inside forEach the passed in callback function undergoes standalone invocation.

Similarly, in this example the first thing that gets logged to the console is _arr_ and next, the global object. I understand if this looks a little complicated but I am sure you will get it if you pay a little more attention.

Let’s keep using this array example to introduce a few more concepts. I think I will start using an acronym here, how about WGL? WHAT. GETS. LOGGED? Here’s the next example before I start getting any more corny.

#### Example #11

```
var arr = [1, 2, 3, 4];

Array.prototype.myCustomFunc = function() {  
 console.log(this);

(function() {  
 console.log(this);  
 })();

};

arr.myCustomFunc();
```

So, WGL?

The answer is exactly the same as that of #10. It’s up to you to figure why _arr_ gets logged first. The complex looking block of code you see below _console.log(this);_ is what is known as an IIFE (Immediately Invoked Function Expression). The name is self explanatory right? The function wrapped inside **(** … **)();** gets invoked on the spot. But the way it’s invoked is equivalent to standalone invocation therefore ‘this’ inside it is global and hence global is what gets logged.

New concept coming up! Let’s see how familiar you are with ES2015.

#### Example #12

```
var arr = [1, 2, 3, 4];

Array.prototype.myCustomFunc = function() {  
 console.log(this);

 (function() {  
  console.log(‘Normal this : ‘, this);  
 })();

 (() =\> {  
  console.log(‘Arrow function this : ‘, this);  
 })();

};

arr.myCustomFunc();
```

Everything is the same as example #11 except 3 extras line of code after the IIFE. Which actually is also an IIFE but with a slightly different syntax. That sir, is what is called an Arrow function.

The thing with Arrow functions is that ‘this’ inside such functions is lexical. Which means when time comes to bind ‘this’ to such functions something from inside the function reaches out and grabs ‘this’ from the function or scope surrounding it. The ‘this’ inside the function surrounding our arrow function is _arr._ Therefore?

```
// This is WGL
arr [1, 2, 3, 4]
Normal this : global
Arrow function this : arr [1, 2, 3, 4]
```

What if I rewrote example #9 with arrow function. What would be logged to the console then?

```
var arr = [1, 2, 3, 4];

arr.forEach(() => {
 console.log(this);
});
```

The example above is a bonus one so don’t increment your score even if you guessed it right. Are you even keeping a score? Such a nerd.

Now pay close attention to the following example. I don’t want you to get this one wrong at any expense ;-).

#### Example #13

```
var yearlyExpense = {

 year: 2016,

 expenses: [
   {‘month’: ‘January’, amount: 1000}, 
   {‘month’: ‘February’, amount: 2000}, 
   {‘month’: ‘March’, amount: 3000}
  ],

 printExpenses: function() {
  this.expenses.forEach(function(expense) {
   console.log(expense.amount + ‘ spent in ‘ + expense.month + ‘, ‘ +    this.year);
   });
  }

};

yearlyExpense.printExpenses();
```

So, WGL? Take your time.

Here is the answer but I’d like you to try thinking it through yourself before reading the explanation.

```
1000 spent in January, undefined  
2000 spent in February, undefined  
3000 spent in March, undefined
```

It’s all about the _printExpenses_ function here. First of all notice how it’s invoked. Implicit binding right? yes. So ‘this’ inside _printExpenses_ is the object _yearlyExpense._ Which means _this.expenses_ is the _expenses_ array inside the _yearlyExpense_ object, so no problem here. Now when it comes to ‘this’ inside the callback function passed to forEach it’s of course the global object, refer example #9.

Notice how arrow function comes to rescue with the “fixed” version below.

```
var expense = {

 year: 2016,

 expenses: [
   {‘month’: ‘January’, amount: 1000}, 
   {‘month’: ‘February’, amount: 2000}, 
   {‘month’: ‘March’, amount: 3000}
  ],

 printExpenses: function() {
   this.expenses.forEach((expense) => {
    console.log(expense.amount + ‘ spent in ‘ + expense.month + ‘, ‘ +  this.year);
   });
  }

};

expense.printExpenses();
```

And hence we get our desired output :

```
1000 spent in January, 2016  
2000 spent in February, 2016  
3000 spent in March, 2016
```

So far we have made ourselves familiar with Implicit and Default binding. We now know that the way a function is invoked decides ‘this’ inside it. We also briefly went over arrow functions and how they’re bounded lexically to ‘this’.

Before we move to the other rules, you should know that there are instances where we can lose Implicitly bounded ‘this’. Let’s quickly take a look at those examples.

#### Example #14

```
var obj = {  
 a: 2,  
 foo: function() {  
  console.log(this);  
 }  
};

obj.foo();

var bar = obj.foo;  
bar();
```

No need to get distracted by all the fancy code here, to find ‘this’ inside a function simply notice how the function has been invoked. You must have had gotten the hang of this trick by now. First _obj.foo()_ is invoked, since _foo_ is preceded by an object reference, the first thing that gets logged is the object _obj_. _bar_ of course undergoes standalone invocation and therefore global is what gets logged to the console next. Just to remind you, remember in strict mode global object is not eligible for default binding, therefore if you have strict mode on undefined will be logged to the console instead of global.

Both bar and foo are references to the same exact function the only difference is in the way they are invoked.

#### Example #15

```
var obj = {  
 a: 2,  
 foo: function() {  
  console.log(this.a);  
 }  
};

function doFoo(fn) {  
 fn();  
}

doFoo(obj.foo);
```

Nothing very special here as well. We are passing _obj.foo_ as a parameter to the _doFoo_ function (doFoo sounds funny LOL). Again, _fn_ and _foo_ are references to the same function. Now I am going to repeat the same old thing, _fn_ undergoes standalone invocation therefore ‘this’ inside _fn_ is the global object. And the global object doesn’t have a property _a,_ hence we get undefined logged to the console.

And with that we’re done with this part. In this part we went over two rules of binding ‘this’ to functions. Default and Implicit. We took a look at how using ‘use strict’ affects the binding of global object also how implicitly bounded ‘this’ can be lost. I hope you found this article helpful in the next part we will take a look at a few new rules including _new_ and Explicit binding. See you there.

* * *

Before we part I’d like to end this part with a “simple” example that had me trippin a lot when I was taking my first steps in JS. Not everything is rainbows in JS there are some ugly parts as well. Let’s take a look at one of them.

```
var obj = {  
 a: 2,  
 b: this.a * 2  
};

console.log( obj.b ); // NaN
```

It reads so well right, inside _obj_ ‘this’ should be _obj_ and hence _this.a_ should be 2. Well, no. As it turns out ‘this’ inside this object literal is the global object, so if you do something like this…

```
var myObj = {  
 a: 2,  
 b: this  
};

console.log(myObj.b); // global
```

… the global object gets logged to the console. You might say “well then, myObj is the property of global object (Example #4 & #8) isn’t it?” Absolutely it is.

```
console.log( this === myObj.b ); // true   
console.log( this.hasOwnProperty(‘myObj’) ); //true
```

“Which means if I do something like this it should work!”

```
var myObj = {  
 a: 2,  
 b: this.myObj.a * 2  
};
```

Sadly no, this is where all the logic fails. The above code is a faulty one with the compiler complaining it couldn’t find property _a_ of undefined. [Why is that?](http://stackoverflow.com/questions/4616202/self-references-in-object-literal-declarations/10766107#10766107) I simply don’t know.

Fortunately, getters (Implicit binding) are here to the rescue.

```
var myObj = {  
 a: 2,  
 get b() {  
  return this.a * 2  
 }  
};

console.log( myObj.b ); // 4
```

You made it to the end! Well done. [Part two](https://github.com/xitu/gold-miner/blob/master/TODO1/lets-settle-this-part-two.md) awaits, see you there.

#### If you found this article helpful do recommend and share it for other developers to discover. I publish articles often, follow me on [Twitter](http://twitter.com/NashVail) and on [Medium](http://medium.com/@nashvail) to be notified when that happens.

#### Thanks for reading, have a good one!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
