> * 原文地址：[Let’s settle ‘this’ — Part Two](https://medium.com/@nashvail/lets-settle-this-part-two-2d68e6cb7dba)
> * 原文作者：[Nash Vail](https://medium.com/@nashvail?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/lets-settle-this-part-two.md](https://github.com/xitu/gold-miner/blob/master/TODO1/lets-settle-this-part-two.md)
> * 译者：
> * 校对者：

# Let’s settle ‘this’ — Part Two

Hey! Welcome to part two of Let’s settle ‘this’ where we are trying to demystify one of JavaScript’s least understood aspect — the ‘this’ keyword. If you haven’t checked out [part one](https://github.com/xitu/gold-miner/blob/master/TODO1/lets-settle-this-part-one.md) yet you might want to do so. In Part One we went over Default and Implicit binding rules through 15 different examples. We saw how the value of ‘this’ for a function changes depending on how the function is invoked. Towards the end we also familiarized ourselves with arrow functions and how they undergo lexical binding. I hope you remember everything.

In this part we will be discussing two new rules, beginning with _new_ binding, we will get into innards and see how everything works. Next we will go over explicit binding and how we can bind any object as ‘this’ to any function through the _call(…), apply(…)_ and _bind(…)_ methods.

Let us continue where we left off. Your task is the same, to guess what gets logged to the console. Remember WGL?

But before we dive in, let’s warm up a little.

#### Example #16

```
function foo() {}

foo.a = 2;
foo.bar = {
 b: 3,
 c: function() {
  console.log(this);
 } 
}

foo.bar.c();
```

I know right now you’re like “What’s going on? Why are properties being assigned to a function here? Won’t this result in an error?”. Well, no first of all this will not result in an error. Every function in JavaScript is also an object. So like any other regular objects you can assign properties to a function too!

With that out of the way let’s now figure out what gets logged to the console. If you notice, Implicit binding is at work here. The object reference directly preceding _c’_s invocation is _bar_ isn’t it? Therefore ‘this’ inside _c_ is _bar_ and hence _bar_ is  what gets logged to the console.

The one thing you should carry away from this example is that functions in JavaScript are also objects and like any other objects they can be assigned properties.

#### Example #17

```
function foo() {
 console.log(this);
}

new foo();
```

So, what gets logged? Or does anything gets logged at all?

The answer is an empty object. Yes, not _a_ not _foo_ just an empty object. Let us see how that works.

First of all notice **_how_** the function is invoked. It’s not a standalone invocation nor it has an object reference preceding it. What it has though is _new_ in front of the call. Any function in JavaScript can be invoked with a _new_ keyword in front of it. And when that happens, when a function is invoked with _new_ roughly four events occur, two of which are,

1.  An empty object is created.
2.  The newly created object is bound as ‘this’ to the function call.

And that (2.) is the reason why when you execute the piece of code shown above you get an empty object logged to the console. You might ask “How is this even useful?”. We’ll get to that it’s all a little controversial.

#### Example #18

```
function foo(id, name) {
 this.id = id;
 this.name = name;
}

foo.prototype.print = function() {
 console.log( this.id, this.name );
};

var a = new foo(1, ‘A’);
var b = new foo(2, ‘B’);

a.print();
b.print();
```

Intuitively it’s very easy to guess what gets logged to the console in this example, but are you right technically? Let’s see.

To recap, when a function is invoked with the _new_ keyword four events occur.

1.  An empty object is created.
2.  The newly created object is bound as ‘this’ to the function call.
3.  **The newly created object is prototypically linked to function’s prototype object.**
4.  **The function is executed normally and at the end the newly created object is returned*.**

We have verified in the previous example that the first 2 events in fact happen, that is why we got an empty object logged to the console. Forget about 3 for now let’s focus on the 4th event. There is nothing stopping the function’s execution, the function is executed with its parameters as any other normal JavaScript function except for the fact that ‘this’ inside the function is a newly created empty object. So when inside the function, _foo_ in our case, we do something like _this.id = id_ **we are actually assigning properties to the newly created empty object that was bound as ‘this’ to the function on call**. Read that again. And once the function has finished executing **the same newly created object is returned**. Since in the example above we assigned an _id_ and a _name_ property to the object the returned object has those as well. The returned object then can be assigned to whatever we want like we did to _a_ and _b_ in the example above.

Every function call with _new_ results in creation of a brand new empty object, its optional augmentation (_this.propName = …)_ inside the function and its return at the end of function execution. Therefore in the end our variables _a_ and _b_ look something like this.

```
var a = {
 id: 1,
 name: ‘A’
};

var b = {
 id: 2,
 name: ‘B’
};
```

Great! we have just learnt a new way for creating objects. But _a_ and _b_ have something in common, they are both **prototypically linked to _foo_’s prototype** (event 4) and therefore have access to its properties ( variables, functions e.t.c ). And just because of that we can call _a.print()_ and _b.print()_ since _print_ is a function we created in _foo_’s prototype. Quick question, what binding occurs when I call _a.print()_? You’re absolutely right if you said Implicit. Therefore, on calling _a.print()_ ‘this’ inside _print_ is _a_ and the first thing to get logged to the console is _1, A_ and similarly when we call _b.print() 2, B_ gets logged.

#### Example #19

```
function foo(id, name) {
 this.id = id;
 this.name = name;

 return {
  message: ‘Got you!’
 };
}

foo.prototype.print = function() {
 console.log( this.id, this.name );
};

var a = new foo(1, ‘A’);
var b = new foo(2, ‘B’);

console.log( a );
console.log( b );
```

Almost everything is same as the code in the previous example except notice that _foo_ now returns an object. Alright, do one thing go back to the previous example and re read the 4th event would you? Notice the *****? When a function is called with the _new_ keyword the newly created object is returned at the end of execution **unless** you return your own custom object like we are doing in this example.

So? What gets logged? It’s very obvious to see that it’s the returned object the one with the _message_ property that gets logged to the console, twice. It’s so easy to break the whole construct isn’t it? Just return a meaningless object and everything fails. Moreover you now cannot call _a.print()_ or _b.print()_ since _a_ and _b_ are assigned what is returned and our returned object is not prototypically linked to _foo_’s prototype.

But wait what if instead of returning an object we returned a string like _‘abc’_ or a number or a boolean value or a function or null or undefined or an array? As it turns out whether the construct breaks or not depends on what you return. See a pattern here?

```
return {}; // Breaks
return function() {}; // Breaks
return new Number(3); // Breaks
return [1, 2, 3]; // Breaks
return null; // Doesn’t break
return undefined; // Doesn’t break
return ‘Hello’; // Doesn’t break
return 3; // Doesn’t break
...
```

Why this happens is a topic for another article. I mean we are already a little off course here, this example has not much to with ‘this’ binding right?

The whole creating objects through _new_ binding has been and being used (misused?) to fake traditional classes in JavaScript since long. In reality there are no classes in JavaScript the new _class_ syntax in ES2015 is just that, syntax. Behind the scenes _new_ binding is what happens there is no change there. I for one don’t care if you use _new_ binding to fake classes until your program works and the code is extensible, readable and maintainable. But then again how can you have extensible, readable and maintainable code with all the package and fragility _new_ binding brings?

That might have been a lot to take in. You should re read it if you’re still a little lost. It’s important that you understand how _new_ binding works probably to never use it again :).

Enough serious talk, let’s move on.

Consider the code below. Refrain yourself from guessing what gets logged in this example, we’ll continue “the guessing game” from the next example onwards :).

```
var expenses = {
 data: [1, 2, 3, 4, 5],
 total: function(earnings) {
  return this.data.reduce( (prev, cur) => prev + cur ) — (earnings || 0);
 }
};

var rents = {
 data: [1, 2, 3, 4]
};
```

The _expenses_ object has _data_ and _total_ properties_. data_ holds some numbers whereas _total_ is a function that takes in _earnings_ as a parameter and returns the sum of all numbers in _data_ minus the _earnings._ Very straightforward.

Now look at _rents,_ just like expenses it has a _data_ property too. Now say, for some reason, just being hypothetical here, you’d like to run the _total_ function over _rent_’s _data_ array and since we’re good programmers we don’t like repeating ourselves. We definitely can’t do _rents.total()_ and have _rents_ implicitly bound as ‘this’ to the _total_ function since _rents.total()_ is an invalid call owing to the fact that _rents_ has no property called _total._ Now only if there was a way to bind _rents_ as ‘this’ to the _total_ function. Well guess what? There is, allow me to introduce you to _call()_ and _apply()._

You see _call_ and _apply_ do the exact same thing, they allow you to bind the object you want to the function you want. Which means I can do this…

```
console.log( expenses.total.call(rents) ); // 10
```

...and this.

```
console.log( expenses.total.apply(rents) ); // 10
```

Which is great! Both of the above lines of code result in _total_ being called with ‘this’ as the _rents_ object. _call_ and _apply_ as far as ‘this’ binding is concerned only differ in the way you pass in arguments.

Notice that the function _total_ takes in an argument _earnings,_ let’s pass it.

```
console.log( expenses.total.call(rents, 10) ); // 0 Works!
console.log( expenses.total.apply(rents, 10) ); // Error
```

Passing arguments to the target function (_total_ in our case) via _call_ is simple you just pass in a comma separated list of arguments like to any other JavaScript function _.call(customThis, arg1, arg2, arg3…)._ In the code above we passed in 10 for the _earnings_ parameter and everything worked as expected.

_apply_ though requires you to pass in arguments to the target function (_total_ in our case) wrapped in an array _.apply(customThis, [arg1,arg2, arg3…]) W_hich notice we didn’t do in the snippet above resulting in an error. The error can definitely be fixed by wrapping arguments for the target function in an array, like so.

```
console.log( expenses.total.apply(rents, [10]) ); // 0 Works!
```

The mnemonic I use to remember the difference between _call_ and _apply_ goes something like this. A is for **_a_**_pply_  and A is for **a**rray as well! So arguments to the target function via **_a_**_pply_ are passed in wrapped in an **a**rray. Just a stupid little mnemonic, but it works 😬.

Now what if we pass in a number or a string or a boolean value or null/undefined instead of an object literal for ‘this’ to **_call_**_,_ **_apply_**  and  **_bind_**  (discussed next)_._ What happens then? Nothing much, say if you pass in a number 2 for ‘this’ it gets wrapped in its object form _new Number(2)_ similarly if you pass in a string it becomes _new String(…)_ boolean values become _new Boolean(…)_ so on and so forth and this new object whether String or Number or Boolean gets bound as ‘this’ to the called function. Passing in _null_ and _undefined_ though results in something different. If you pass in _null_ or _undefined_ for ‘this’ the function is called as if it underwent Default binding which means the global object is bound as ‘this’ to the called function.

There’s yet another way to bind ‘this’ to a function, this time through a method called, wait for it, _bind_!

Let’s see if you can figure this out. What gets logged in the example below?

#### Example #20

```
var expenses = {
 data: [1, 2, 3, 4, 5],
 total: function(earnings) {
  return this.data.reduce( (prev, cur) => prev + cur ) — (earnings   || 0);
 }
};

var rents = {
 data: [1, 2, 3, 4]
};

var rentsTotal = expenses.total.bind(rents);

console.log(rentsTotal());
console.log(rentsTotal(10));
```

The answer to this example is 10 followed by 0. Notice what’s happening right below the declaration of _rents_ object. We are creating a new function _rentsTotal_ from the function _expenses.total._ That’s what _bind_ does it creates a new function which when called has its ‘this’ keyword set to the provided value (_rents_ in our case). Therefore when we call _rentsTotal()_ which though is a standalone invocation has its ‘this’ already set to _rents_ and Default Binding cannot override that. This call results in 10 getting printed to the console.

In the next line calling _rentsTotal_ with a parameter (10) is exactly like calling _expenses.total_ with the same paramter (10) it is only in the value of ‘this’ where they differ. The result of this call is 0.

Moreover you can also bind parameters for the target function (_expenses.total_ in our case) using _bind._ Consider this.

```
var rentsTotal = expenses.total.bind(rents, 10);
console.log(rentsTotal());
```

What do you think gets logged to the console? 0 of course as 10 has been bound to the target function (_expenses.total)_ as _earnings_ by _bind._

Let us take a look at an example that illustrates a real life usage of _bind._

#### Example #21

```
// HTML

<button id=”button”>Hello</button>

// JavaScript

var myButton = {
 elem: document.getElementById(‘button’),
 buttonName: ‘My Precious Button’,
 init: function() {
  this.elem.addEventListener(‘click’, this.onClick);
 },
 onClick: function() {
  console.log(this.buttonName);
 }
};

myButton.init();
```

We have created a button in HTML and then we’re targeting that same button in our JavaScript code as _myButton._ Notice inside _init_ we are also attaching a click event listener to the button.Your question now is what gets logged to the console when the button is clicked?

If you guessed it right _undefined_ is what gets logged. The reason for this “sorcery” is that functions passed as callback (_this.onClick_ in our case) to event listeners has the target element bound as ‘this’ to them. Which means when _onClick_ is called ‘this’ inside it is the DOM object button (_elem_)  and not our _myButton_ object and because the DOM object button has no property with the name _buttonName_ it results in _undefined_ being logged to the console.

But there is a way to fix this (pun intended). All we need to do is add one, just one extra line of code.

#### Fix #1

```
var myButton = {
 elem: document.getElementById(‘button’),
 buttonName: ‘My Precious Button’,
 init: function() {
  this.onClick = this.onClick.bind(this);
  this.elem.addEventListener(‘click’, this.onClick);
 },
 onClick: function() {
  console.log(this.buttonName);
 }
};
```

Notice in the previous snippet (#21) the way function _init_ is invoked. Exactly, Implicit binding binds _myButton_ as ‘this’ to the _init_ function. Now notice how in the new line we are binding _myButton_ to the the _onClick_ function. Doing so creates a new function which is exactly _onClick_ except for the fact that it has its ‘this’ as _myButton_ object_._ The newly created function then is reassigned to _myButton.onClick._ That’s all, when you click the button now you’ll have “My Precious Button” logged to the console.

You could have fixed the code with arrow functions too. Here’s how. I will leave it up to you to figure why these work.

#### Fix #2

```
var myButton = {
 elem: document.getElementById(‘button’),
 buttonName: ‘My Precious Button’,
 init: function() {
  this.elem.addEventListener(‘click’, () => {
   this.onClick.call(this);
  });
 },
 onClick: function() {
 console.log(this.buttonName);
 }
};
```

#### Fix #3

```
var myButton = {
 elem: document.getElementById(‘button’),
 buttonName: ‘My Precious Button’,
 init: function() {
  this.elem.addEventListener(‘click’, () => {
   console.log(this.buttonName);
  });
 }
};
```

That’s it. We’re done… almost. There are still questions like is there an order of precedence? What if there is a clash between two rules trying to bind a ‘this’ to the same function? This is a topic for another article. Part 3? Probably and to be honest it’s rare you’ll run into such clashes. So for now we’re done and let’s summarize what we have learnt in the two parts.

#### Summary

In the first part we saw how ‘this’ for a function is not fixed and can change depending on how the function is invoked. We went over Default binding which applies when a function undergoes standalone invocation, Implicit binding which applies when a function is invoked with an object reference preceding it and arrow functions and how ‘this’ to them are bound lexically. Towards the end of the first part we also went over a self referencing quirk in JavaScript objects.

In this part we started out with _new_ binding and how it works and how the whole construct can easily be broken. Latter half of this part was dedicated to explicitly binding ‘this’ to functions using _call, apply_ and _bind._ I also embarrassingly shared my mnemonic with you about how to remember the difference between _call_ and _apply._ Hope you remember it.

#### This ended up being quite long. If you’re still reading, thank you! I hope you learned something. If you did please do recommend the article for others to discover. Have a good one!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
