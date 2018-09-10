> * 原文地址：[Let’s settle ‘this’ — Part One](https://medium.com/@nashvail/lets-settle-this-part-one-ef36471c7d97)
> * 原文作者：[Nash Vail](https://medium.com/@nashvail?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/lets-settle-this-part-one.md](https://github.com/xitu/gold-miner/blob/master/TODO1/lets-settle-this-part-one.md)
> * 译者：[geniusq1981](https://github.com/geniusq1981)
> * 校对者：[Moonliujk](https://github.com/Moonliujk)、[lance10030](https://github.com/lance10030)

# 让我们一起解决“this”难题 — 第一部分

![](https://i.loli.net/2018/07/23/5b553df9455fa.png)

难道我们就不能彻底搞清楚“this”吗？在某种程度上，几乎所有的 JavaScript 开发人员都曾经思考过“this”这个事情。对我来说，每当“this”出来捣乱的时候，我就会想方设法地去解决掉它，但过后就把它忘了，我想你应该也曾遇到过类似的场景。但是今天，让我们弄明白它，让我们一次性地彻底解决“this”的问题，一劳永逸。

前几天，我在图书馆遇到了一个意想不到的事情。

![](https://i.loli.net/2018/07/23/5b553e2648b71.png)

这本书的整个第二章都是关于“this”的，我很有自信地通读了一遍，但是发现其中有些地方讲到的“this”，我居然搞不懂它们是什么，需要去猜测。真的是时候反省一下我过度自信的愚蠢行为了。我再次把这一章重读了好几遍，发觉这里面的内容是每个 Javascript 开发人员都应该了解的。

因此，我尝试着用一种更彻底的方式和更多的示例代码来展示 [凯尔·辛普森](http://getify.me/) 在他的这本书 [你不知道的 Javascript](https://github.com/getify/You-Dont-Know-JS) 中描述的那些规范。

在这里我不会通篇只讲理论，我会直接以曾经困扰过我的困难问题为例开始讲起，我希望它们也是你感到困难的问题。但不管这些问题是否会困挠你，我都会给出解释说明，我会一个接一个地向你介绍所有的规则，当然还会有一些追加内容。

在开始之前，我假设你已经了解了一些 JavaScript 的背景知识，当我讲到 global、window、this、prototype 等等的时候，你知道它们是什么意思。这篇文章中，我会同时使用 global 和 window，在这里它们就是一回事，是可以互换的。

在下面给出的所有代码示例中，你的任务就是猜一下控制台输出的结果是什么。如果你猜对了，就给你自己加一分。准备好了吗？让我们开始吧。

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

你被难住了吗？为了测试，你当然可以把这段代码复制下来，然后在浏览器或者 Node 的运行环境中去运行看看结果。再来一次,你被难住了吗？好吧，我就不再问了。但说真的，如果你没被难住，那就给你自己加一分。

如果你运行上面的代码，就会在控制台中看到 global 对象被打印出三次。为了解释这一点，让我来介绍 **第一个规则，默认绑定**。规则规定，当一个函数执行独立调用时，例如只是 _funcName();_，这时函数的“this”被指向 global 对象。

需要理解的是，在调用函数之前，“this”并没有绑定到这个函数，因此，要找到“this”，你应该密切注意该函数是如何调用，而不是在哪里调用。所有三个函数 _foo();bar();_ 和 baz();_ 都是独立的调用，因此这三个函数的“this”都指向全局对象。

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

注意下最开始的“use strict”。在这种情况下，你觉得控制台会打印什么？当然，如果你了解 _strict mode_，你就会知道在严格模式下 global 对象不会被默认绑定。所以，你得到的打印是三次 _undefined_ 的输出，而不再是 _global_。

回顾一下，在一个简单调用函数中，比如独立调用中，“this”在非严格模式下指向 global 对象，但在严格模式下不允许 global 对象默认绑定，因此这些函数中的“this”是 undefined。

为了使我们对默认绑定概念理解得更加具体，这里有一些示例。

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

我希望你没有回答 _foo_ 或 _bar_。有没有？

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

如果你已经很好地理解了之前讲解的内容，那么你应该知道控制台输出的是“1”。为什么？首先，默认绑定作用于函数 _foo_。因此 _foo_ 中的“this”指向 global 对象，并且 _a_ 被声明为 global 变量，这就意味着 _a_ 是 global 对象的属性（也称之为全局对象污染），因此 _this.a_ 和 _var a_ 就是同一个东西。

随着本文的深入，我们将会继续研究默认绑定，但是现在是时候向你介绍下一个规则了。

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

这里应该没有什么疑问，对象“obj”会被输出在控制台中。你在这里看到的是 **隐式绑定**。规则规定，当一个函数被作为一个对象方法被调用时，那么它内部的“this”应该指向这个对象。如果函数调用前面有多个对象（ _obj1.obj2.func()_ ），那么函数之前的最后一个对象（_obj3_）会被绑定。

> 需要注意的一点是函数调用必须有效，那也就是说当你调用 _obj.func()_ 时，必须确保 _func_ 是对象 _obj_ 的属性。

因此，在上面的例子中调用 _obj.foo()_ 时，“this”就指向 obj，因此 _obj_ 被打印输出在控制台中。

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

这里需要注意一件有趣的事情：

```Javascript
console.log(logThis === myObject.logThis); // true
```

为什么不呢？它们当然是相同的函数，但是你可以看到 **如何调用_logThis_** 会让其中的“this”发生改变。当 _logThis_ 被单独调用时，使用默认绑定规则，但是当 _logThis_ 作为前面的对象属性被调用时，使用隐式绑定规则。

不管采用哪条规则，让我们看看是怎么处理的（双关语）。

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

控制台输出什么？首先，你可能会问我们可以调用“_this.bar()”吗？当然可以，它不会导致错误。

就像示例 #4 中的 _var a_ 一样，_bar_ 也是全局对象的属性。因为 foo 被单独调用了，它内部的“this”就是全局对象(默认绑定规则)。因此 _foo_ 内部的 _this.bar_ 就是 _bar_。但实际的问题是，控制台中输出什么？

如果你猜的没错，“undefined”会被打印出来。

注意 _bar_ 是如何被调用的？看起来，隐式绑定在这里发挥作用。隐式绑定意味着 _bar_ 中的“this”是其前面的对象引用。_bar_ 前面的对象引用是全局对象，在 foo 里面是全局对象，对不对？因此在 _bar_ 中尝试访问 _this.a_ 等同于访问 _[global object].a_。没有什么意外，因此控制台会输出 undefined。

太棒了！继续向下讲解。

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

函数 _foo_ 接受一个回调函数作为参数。我们所做的就是在调用 _foo_ 的时候在参数里面放了一个函数。

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

如果你还不知道 Javascript 里面的 _.prototype_ 是什么，那你就权且把它和其他对象等同看待，但如果你是 JavaScript 开发者，你应该知道。你知道吗？努努力，再去多读一些关于原型链相关的书籍吧。我在这里等着你。

那么打印输出的是什么？是 _Array.prototype_ 对象？错了！

这是和之前相同的技巧，请检查 _custommyfunc_ 是 **如何** 被调用的。没错，隐式绑定把 _arr_ 绑定到 _myCustomFunc_，因此输出到控制台的是 _arr[1,2,3,4]_。

我说的，你理解了吗？

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

就像示例 #7 一样，我们将回调函数 _fn_ 作为参数传递给函数 _myCustomFunc_。结果是传入的函数会被独立调用。这就是为什么在前面的示例（#9）中输出全局对象，因为在 forEach 中传入的回调函数被独立调用。

类似地，在本例中，首先输出到控制台的是 _arr_，然后是输出的是全局对象。我知道这看上去有点复杂，但我相信如果你能再多用点心，你会弄明白的。

让我们继续使用这个数组的示例来介绍更多的概念。我想我会在这里使用一个简称，WGL 怎么样？作为 WHAT.GETS.LOGGED 的简称？好吧，在我开始老生常谈之前，下面是另外一个例子。

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

那么，输出是？

答案和示例 #10 完全一样。轮到你了，说一说为什么首先输出的是 _arr_？你看到第一个 _console.log(this)_ 的下面有一段复杂的代码，它被称为 IIFE（立即调用的函数表达式）。这个名字不用再过多解释了，对吧？被 **(…)();** 这样形式封装的函数会立即被调用，也就是说等同于被独立调用，因此它内部的“this”是全局变量，所以输出的是全局变量。

要来新概念了！让我们看看你对 ES2015 的熟悉程度。

#### Example #12

```Javascript
var arr = [1, 2, 3, 4];

Array.prototype.myCustomFunc = function() {  
 console.log(this);

 (function() {  
  console.log(‘Normal this : ‘, this);  
 })();

 (() => {  
  console.log(‘Arrow function this : ‘, this);  
 })();

};

arr.myCustomFunc();
```

除了 IIFE 后面的增加了 3 行代码之外，其他代码与示例 #11 完全相同。它实际上也是一种 IIFE，只是语法稍有不同。嗨，这是箭头函数。

箭头函数的意思是，这些函数中的“this”是一个词法变量。也就是说，当将“this”与这种箭头函数绑定时，函数会从包裹它的函数或作用域中获取“this”的值。包裹我们这个箭头函数的函数里面的“this”是 _arr_。因此？

```Javascript
// This is WGL
arr [1, 2, 3, 4]
Normal this : global
Arrow function this : arr [1, 2, 3, 4]
```

如果我用箭头函数重写示例 #9 会怎么样？控制台输出什么呢？

```Javascript
var arr = [1, 2, 3, 4];

arr.forEach(() => {
 console.log(this);
});
```

上面的这个例子是额外追加的，所以即使你猜对了也不用增加分数。你还在算分吗？书呆子。

现在请仔细关注以下示例。我会不惜一切代价让你弄懂他们 :-)。

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

那么,输出是？多点时间想一想。

这是答案，但我希望你在阅读解释之前先自己想想。

```Javascript
1000 spent in January, undefined  
2000 spent in February, undefined  
3000 spent in March, undefined
```

这都是关于 _printExpenses_ 函数的。首先注意下它是如何被调用的。隐式绑定？是的。所以 _printExpenses_ 中的“this”指向的是对象 _yearlycost_。这意味着 _this.expenses_ 是 _yearlyExpense_ 对象中的 _expenses_ 数组，所以这里没有问题。现在，当它在传递给 forEach 的回调函数中出现“this”时，它当然是全局对象，请参考例 #9。

注意，下面的“修正”版本是如何使用箭头函数进行改进的。

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

这样我们就得到了想要的输出结果：

```Javascript
1000 spent in January, 2016  
2000 spent in February, 2016  
3000 spent in March, 2016
```

到目前为止，我们已经熟悉了隐式绑定和默认绑定。我们现在知道函数被调用的方式决定了它里面的“this”。我们还简要地讲了箭头函数以及它们内部的“this”是怎样定义的。

在我们讨论其他规则之前，你应该知道，有些情况下，我们的“this”可能会丢失隐式绑定。让我们快速地看一下这些例子。

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

不要被这里面的花哨代码所分心，只需注意函数是如何被调用的，就可以弄明白“this”的含义。你现在一定已经掌握这个技巧了吧。首先 _obj.foo()_ 被调用，因为 _foo_ 前面有一个对象引用，所以首先输出的是对象 _obj_。_bar_ 当然是被独立调用的，因此下一个输出是全局变量。提醒你一下，记住在严格模式下，全局对象是不会默认绑定的，因此如果你在开启了严格模式，那么控制台输出的就是 undefined，而不再是全局变量。

bar 和 foo 是对同一个函数的引用，唯一区别是它们被调用的方式不同。

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

这里也没什么特别的。我们是通过把 _obj.foo_ 作为 _doFoo_ 函数的参数（doFoo 这个名字听起来很有趣）。同样， _fn_ 和 _foo_ 是对同一个函数的引用。现在我要重复同样的分析过程， _fn_ 被独立调用，因此 _fn_ 中的“this”是全局对象。而全局对象没有属性 _a_，因此我们在控制台中得到了 undifined 的输出结果。

到这里，我们这部分就讲完了。在这一部分中，我们讨论了将“this”绑定到函数的两个规则。默认绑定和隐式绑定。我们研究了如何使用“use strict”来影响全局对象的绑定，以及如何会让隐式绑定的“this”失效。我希望在接下来的第二部分中，你会发现本文对你有所帮助，在那里我们将介绍一些新规则，包括 _new_ 和显式绑定。那里再见吧！


* * *


在我们结束之前，我想用一个“简单”的例子来作为这一部分的收尾，当我开始使用 Javascript 时，这个例子曾经让我感到非常震惊。Javascript 里面也并不是所有的东西都是美的，也有看起来很糟糕的东西。让我们看看其中的一个。

```Javascript
var obj = {  
 a: 2,  
 b: this.a * 2  
};

console.log( obj.b ); // NaN
```

它读起来感觉很好，在 _obj_ 里面，“this”应该是 _obj_，因此是 _this.a_ 应该是 2。嗯,错了。因为在这个对象里面的“this”是全局对象，所以如果你像这么写…

```Javascript
var myObj = {  
 a: 2,  
 b: this  
};

console.log(myObj.b); // global
```

控制台输出的就是全局对象。你可能会说“但是，myObj 是全局对象的属性（示例 #4 和示例 #8），不对吗？”是的，绝对正确。

```Javascript
console.log( this === myObj.b ); // true   
console.log( this.hasOwnProperty(‘myObj’) ); //true
```

“也就是说，如果我像这样写的话，它就可以！”

```Javascript
var myObj = {  
 a: 2,  
 b: this.myObj.a * 2  
};
```

遗憾的是，不是这样的，这会导致逻辑错误。上面的代码是不正确的，编译器会抱怨它找不到未定义的属性 _a_。[为什么会这样？](http://stackoverflow.com/questions/4616202/self-reference-in-object-literations/10766107#10766107)我也不太清楚。

幸运的是，getters（隐式绑定）可以给我们提供帮助。

```Javascript
var myObj = {  
 a: 2,  
 get b() {  
  return this.a * 2  
 }  
};

console.log( myObj.b ); // 4
```

你坚持到最后了！做得好。[第二部分](https://github.com/xitu/gold-miner/blob/master/todo1/lets-setts-this-part-two.md)，我们再见。

如果你发现这篇文章很有用，你可以推荐并分享给其他开发者。我经常发表文章，在 [Twitter](http://twitter.com/NashVail) 和 [Medium](http://medium.com/@nashvail) 上关注我，以便在这种情况发生时得到通知。

谢谢你的阅读，祝你愉快！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。

