> * 原文地址：[Let’s settle ‘this’ — Part One](https://medium.com/@nashvail/lets-settle-this-part-one-ef36471c7d97)
> * 原文作者：[Nash Vail](https://medium.com/@nashvail?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/lets-settle-this-part-one.md](https://github.com/xitu/gold-miner/blob/master/TODO1/lets-settle-this-part-one.md)
> * 译者：
> * 校对者：

# Let’s settle ‘this’ — Part One

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
