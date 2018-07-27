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

# 让我们一起解决‘this’难题 — 第一部分

![](https://i.loli.net/2018/07/23/5b553df9455fa.png)

难道我们都不能理解吗?在某种程度上，几乎所有的 JavaScript 开发人员都曾经思考过“this”这个事情。对我来说，每当“this”出来捣乱的时候，我就想方设法地去解决掉它，然后就把它忘了，我想您应该也曾遇到过这样的场景。但是今天，让我们彻底解决这个问题吧，让我们一次性一劳永逸地解决“this”的问题。
Can’t we all relate to this? At some point ‘this’ has been a thing to think about for almost all JavaScript developers. For me, whenever ‘this’ started to rear its ugly head I somehow managed to make things work and then forgot about it, and I’d like think you did the same, at some point. But let’s be done with it, today, once and for all _`*dramatic drumroll*`_ let’s settle ‘this’.

几天前，我在图书馆遇到了一个意想不到的事情。

![](https://i.loli.net/2018/07/23/5b553e2648b71.png)

这本书的整个第二章都是关于“this”的，我很有自信地通读了一遍，但是发现其中有些地方讲到的“this”，我居然搞不懂它们是什么，需要去猜测。是时候反省一下我多度自信的愚蠢行为了。我又把这一章重读了好几遍，发觉这些内容是每个 Javascript 开发人员都应该了解的。

因此，我试图用一种更彻底的方式和更多的示例代码来展示 [凯尔·辛普森](http://getify.me/) 在他的这本书 [你不知道的 Javascript](https://github.com/getify/You-Dont-Know-JS) 中描述的那些规范。

现在我不会通篇只讲理论，我会直接以曾经困扰过我的困难问题为例开始讲起，我希望它们也是你会感到困难的问题。不管这些问题是否会困挠你，我都会给出解释说明，我会一个接一个地向你介绍所有规则，当然还会有一些额外的小惊喜。

在开始之前，我假设您已经了解了一些 JavaScript 的背景知识，当我讲到 global、window、this、prototype 等等的时候，你知道它们是什么意思。这篇文章中，我会同时使用 global 和 window，在这里它们就是一回事，是可以互换的。

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

你被难住了吗？为了测试，您当然可以把这段代码复制下来，然后在浏览器或者 Node 的运行环境中去运行看看结果。再来一次,你被难住了吗？好吧，我就不再问了。但说真的，如果你没被难住，那就给你自己加一分。

如果您运行上面的代码，就会在控制台中看到 global 对象被打印出三次。为了解释这一点，让我来介绍 **第一个规则，默认绑定**。规则规定，当一个函数执行独立调用时，例如只是 _funcName();_ ，这时函数的 “this” 被指向 global 对象。

需要理解的是，在调用函数之前，“this”并没有绑定到一个函数，因此，要找到“this”，您应该密切注意该函数是如何调用或调用的，而不是在哪里。所有三个函数调用 _foo();bar();和 baz();_ 都是是独立的调用，因此这三个函数的 “this” 都是 global 对象。

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

注意下最开始的“use strict”。在这种情况下，你觉得控制台会打印什么？当然，如果您了解 _strict mode_ ，您就会知道在严格模式下 global 对象不会被默认绑定。所以，你得到的打印是三次 _undefined_ 的输出，而不再是 _global_。

回顾一下，在一个简单调用函数中,比如独立调用中，“this”在非严格模式下指向 global 对象，但在严格模式下不允许 global 对象默认绑定，因这些函数中的 “this” 是 undefined。

为了使我们对默认绑定概念立即得更加具体，这里有一些示例。

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

_foo_ 先被调用，然后又调用 _bar_，_bar_ 将“this”打印到控制台中。这里的技巧是看看函数是如何被调用的。_foo_ 和 _bar_ 都被单独调用，因此，他们内部的“this”都是指向 global 对象。但是由于 _bar_ 是唯一执行打印的函数，所以我们看到 global 对象在控制台中输出了一次。

我希望你没有回答 _foo_ 或 _bar_ 。有没有？

我们已经了解了默认绑定。让我们再做一个简单的测试。在下面的示例中，控制台输出什么？

#### Example #4

```Javascript
var a = 1;

function foo() {  
 console.log(this.a);  
}

foo();
```

输出结果是 undefined？是 1？还是什么？

如果您已经很好地理解了之前讲解的内容，那么您应该知道控制台输出的是“1”。为什么?首先，默认绑定作用于函数 _foo_ 。因此 _foo_ 中的“this”指向 global 对象，并且 _a_ 被声明为 global 变量，这就意味着 _a_ 是 global 对象的属性(也称之为全局对象污染)，因此 _this.a_ 和 _var a_ 就是同一个东西。

随着本文的深入，我们将会继续研究默认绑定，但是现在是时候向您介绍下一个规则了。

#### Example #5

```Javascript
var obj = {  
 a: 1,   
 foo: function() {  
  console.log(this);   
 }  
};

obj.foo();
```

这里应该没有什么疑问，对象“obj”会被输出在控制台中。你在这里看到的是 **隐式绑定** 。规则规定，当一个函数被作为一个对象方法被调用时，那么它内部的“this”应该指向这个对象。如果函数调用前面有多个对象（ _obj1.obj2. func()_ ），那么函数之前的最后一个对象（ _obj3_ ）会被绑定。

> 需要注意的一点是函数调用必须有效，那也就是说但你调用 _obj.func()_ 时,必须确保 _func_ 是对象 _obj._ 的属性。

因此，在上面的例子中调用 _obj.foo()_ 时，“this”就是 obj，因此 _obj_ 被打印输出在控制台中。

#### Example #6

```Javascript
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

你被难住了？我希望没有。

跟在 _myObject_ 后面的这个全局调用 _logThis()_ 通过 _console.log(this)_ 打印的是 global 对象；而 _myObject.logThis()_ 打印的是 _myObject_ 对象。

这里需要注意一件有趣的事情:

```Javascript
console.log(logThis === myObject.logThis); // true
```

为什么不呢?它们当然是相同的函数，但是您可以看到 **如何调用_logThis_** 会让其中的“this”发生改变。当 _logThis_ 被单独调用时，使用默认绑定规则，但是当 _logThis_ 作为前面的对象属性被引用时，使用隐式绑定规则。

不管是谁，让我们看看是怎么处理的（双关语）。

#### Example #8

```Javascript
function foo() {  
 var a = 2;  
 this.bar();  
}

function bar() {  
 console.log(this.a);  
}

foo();
```

控制台输出什么？首先，您可能会问我们可以调用“_this.bar()”吗？当然可以，它不会导致错误。

就像示例#4 中的 _var a_ 一样， _bar_ 也是全局对象的属性。因为 foo 被单独调用了，它内部的“this”就是全局对象(默认绑定规则)。因此 _foo_ 内部的 _this.bar_ 就是 _bar_ 。但实际的问题是，控制台中输出什么？

如果你猜的没错，“undefined”会被打印出来。

注意 _bar_ 是如何被调用的？看起来，隐式绑定在这里发挥作用。隐式绑定意味着 _bar_ 中的“this”是其前面的对象引用。_bar_ 前面的对象引用是全局对象，在 foo 里面是全局对象，对不对？因此在 _bar_ 中尝试访问 _this.a_ 等同于访问 _[global object].a_ 。没有什么意外，因此控制台会输出 undefined。

太棒了!继续向下讲解。

#### Example #7

```Javascript
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

函数 _foo_ 接受一个回调函数作为参数。这就是我们所做的我们在调用_foo_的时候在parans之间放置一个函数。

```Javascript
obj.foo( function() { console.log(this); } );
```

但是请注意 _foo_ 是 **如何** 被调用的。它是一个单独调用吗？当然不是，因此第一个输出到控制台的是对象 _obj_ 。我们传入的回调函数是什么？在 _foo_ 内部，回调函数变为 _fn_ ，注意 _fn_ 是 **如何** 被调用的。对，因此 _fn_ 中的“this”是全局对象，因此第二个被输出到控制台的是全局对象。

希望你不会觉得无聊。顺便问一下，你的分数怎么样？还可以吗？好吧，这次我准备难倒你了。

#### Example #8

```Javascript
var arr = [1, 2, 3, 4];

Array.prototype.myCustomFunc = function() {
 console.log(this);
};

arr.myCustomFunc();
```

如果你不知道 Javascript 里面的 _.prototype_ 是什么的话，那你就权且把它和其他对象等同看待，但是如果你是一个 JavaScript 开发人员，你应该知道它是什么。你知道吗？帮自己一个忙，去读一些关于原型链相关的书。我在这里等你。

那么打印输出什么？是 _Array.prototype_ 对象？错了！

这是和之前相同的技巧，请检查 _custommyfunc_ 是 **如何** 被调用的。没错，隐式绑定把 _arr_ 绑定到 _myCustomFunc_ ，因此输出到控制台的是 _arr[1,2,3,4]_ 。

我说的，您理解了吗?

#### Example #9

```Javascript
var arr = [1, 2, 3, 4];

arr.forEach(function() {  
 console.log(this);  
});
```

执行上述代码的结果是，在控制台中输出了 4 次全局对象。如果你错了，也没关系。请再看示例#7。还没理解？下一个示例会有所帮助。

#### Example #10

```Javascript
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

```Javascript
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

```Javascript
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

```Javascript
// This is WGL
arr [1, 2, 3, 4]
Normal this : global
Arrow function this : arr [1, 2, 3, 4]
```

如果我用箭头函数重写示例#9会怎么样?那么什么会被记录到控制台呢?

```Javascript
var arr = [1, 2, 3, 4];

arr.forEach(() => {
 console.log(this);
});
```

上面的例子是一个额外的例子，所以即使你猜对了也不要增加分数。你还在记分吗?这样的书呆子。


现在请密切注意以下示例。我不希望你以任何代价把这个弄错;-)

#### Example #13

```Javascript
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

```Javascript
1000 spent in January, undefined  
2000 spent in February, undefined  
3000 spent in March, undefined
```

这都是关于_printExpenses_函数的。首先注意它是如何调用的。隐式绑定?是的。所以_printExpenses_中的' this '是对象_yearlycost。_这意味着_this。expenses_是_yearlyExpense_对象中的_expenses_数组，所以这里没有问题。现在，当它在传递给forEach的回调函数中出现“this”时，它当然是全局对象，请参考例#9。


注意，下面的“固定”版本是如何使用arrow函数进行补救的。

```Javascript
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

```Javascript
1000 spent in January, 2016  
2000 spent in February, 2016  
3000 spent in March, 2016
```

到目前为止，我们已经熟悉了隐式绑定和默认绑定。我们现在知道函数调用的方式决定了它里面的“this”。我们还简要地讨论了箭头函数以及它们是如何被定义为“this”的。


在我们讨论其他规则之前，您应该知道，有些情况下，我们可以隐式地将“this”定义为“this”。让我们快速看一下这些例子。

#### Example #14

```Javascript
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

```Javascript
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

```Javascript
var obj = {  
 a: 2,  
 b: this.a * 2  
};

console.log( obj.b ); // NaN
```

它读起来很好，在_obj_ ' this应该是_obj_，因此是_this。现代应该是2。嗯,没有。因为在这个对象文字里面的' this '是全局对象，所以如果你做这样的事情…

```Javascript
var myObj = {  
 a: 2,  
 b: this  
};

console.log(myObj.b); // global
```

全局对象被记录到控制台。您可能会说“那么，myObj是全局对象的属性(例如#4和#8)，不是吗?”“绝对。

```Javascript
console.log( this === myObj.b ); // true   
console.log( this.hasOwnProperty(‘myObj’) ); //true
```

“也就是说，如果我做了这样的事情，它就会成功!”

```Javascript
var myObj = {  
 a: 2,  
 b: this.myObj.a * 2  
};
```

遗憾的是，这是所有逻辑失败的地方。上面的代码是一个错误的，编译器抱怨它找不到未定义的属性_a_。(http://stackoverflow.com/questions/4616202/self-reference -in object- literations/10766107 #10766107 #10766107)我就是不知道。


幸运的是，getters(隐式绑定)正在为我们提供帮助。

```Javascript
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

