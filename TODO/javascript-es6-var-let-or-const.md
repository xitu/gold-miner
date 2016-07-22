> * 原文链接: [JavaScript ES6+: var, let, or const?](https://medium.com/javascript-scene/javascript-es6-var-let-or-const-ba58b8dcde75#.twa6gzmfp)
* 原文作者: [Eric Elliott](https://medium.com/@_ericelliott)
* 译文出自: [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者: [Gran](https://github.com/Graning)
* 校对者:


### JavaScript ES6+: var, let, or const?

Perhaps the most important thing you can learn to be a better coder is to **keep things simple**. In the context of identifiers, that means that **a single identifier should only be used to represent a single concept.**

Sometimes it’s tempting to create an identifier to represent some data and then use that identifier as a temporary place to store values in transition from one representation to another.

For instance, you may be after a query string parameter value, and start by storing an entire URL, then just the query string, then the value. This practice should be avoided.

It’s easier to understand if you use one identifier for the URL, a different one for the query string, and finally, an identifier to store the parameter value you were after.

This is why I favor _`const`_ over _`let`_ in ES6\. In JavaScript, **_`const`_ means that the identifier can’t be reassigned.** (Not to be confused with _immutable values._ Unlike true immutable datatypes such as those produced by Immutable.js and Mori, a _`const`_ object can have properties mutated.)

If I don’t need to reassign, **_`const`_ is my default choice** over _`let`_ because I want the usage to be as clear as possible in the code.

I use _`let`_ when I need to reassign a variable. Because I **use one variable to represent one thing,** the use case for _`let`_ tends to be for loops or mathematical algorithms.

I don’t use _`var`_ in ES6\. There is value in block scope for loops, but I can’t think of a situation where I’d prefer _`var`_ over _`let`_.

**_`const`_** is a signal that **the identifier won’t be reassigned.**

**_`let`,_** is a signal that **the variable may be reassigned**, such as a counter in a loop, or a value swap in an algorithm. It also signals that the variable will be used **only in the block it’s defined in**, which is not always the entire containing function.

**_`var`_** is now **the weakest signal available** when you define a variable in JavaScript.</span> The variable may or may not be reassigned, and the variable may or may not be used for an entire function, or just for the purpose of a block or loop.

#### Warning:

With _`let`_ and _`const`_ in ES6, it’s no longer safe to check for an identifier’s existence using _`typeof`:_

```
function foo () {
  typeof bar;
  let bar = ‘baz’;
}

foo(); // ReferenceError: can't access lexical declaration
       // `bar' before initialization
```

But you’ll be fine because you took my advice from [“Programming JavaScript Applications”](http://pjabook.com) and you always initialize your identifiers before you try to use them…

#### P.S.

If you need to deallocate a value by unsetting it, you may consider _`let`_ over _`const`,_ but if you really need to micro-manage the garbage collector, you should probably watch “Slay’n the Waste Monster”, instead: [https://medium.com/media/6f512d3acc928ffcb80ac4f5586c2e87?maxWidth=700](https://medium.com/media/6f512d3acc928ffcb80ac4f5586c2e87?maxWidth=700)
