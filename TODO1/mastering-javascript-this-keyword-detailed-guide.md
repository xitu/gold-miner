> * 原文地址：[Mastering JavaScript this Keyword – Detailed Guide](https://www.thecodingdelight.com/javascript-this/#ftoc-heading-2)
> * 原文作者：[Jay](https://www.thecodingdelight.com/author/ljay189/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/mastering-javascript-this-keyword-detailed-guide.md](https://github.com/xitu/gold-miner/blob/master/TODO1/mastering-javascript-this-keyword-detailed-guide.md)
> * 译者：
> * 校对者：

# Mastering JavaScript this Keyword – Detailed Guide

The JavaScript `this` keyword is often considered one of the most confusing aspects of the language. JavaScript has come a long way, now with node.js being used to run JavaScript in the server, along with the continual evolution of the language. Needless to say that this language is not disappearing anytime soon.

Therefore, I believe that if you are a JavaScript developer or somebody who works with web technologies, learning how JavaScript works and also its idiosyncrasies will pay dividends down the road.

## Prerequisites

Before reading ahead, it is strongly recommended that you have a solid understanding of the following.

*   [Variable scope and hoisting](https://www.thecodingdelight.com/variable-scope-hoisting-javascript/)
*   [Functions in JavaScript](https://www.codecademy.com/courses/functions-in-javascript-2-0/0/1)
*   [Closures](https://medium.com/dailyjs/i-never-understood-javascript-closures-9663703368e8)

Without a solid understanding of the fundamentals, discussions regarding the JavaScript `this` keyword will only add a layer of confusion and frustration.

## Why should I Learn `this`?

If the basic introduction did not convince you to explore the `this` keyword in detail, I will cover the why in this section.

A very valid question, considering that people like Douglas Crockford have stopped using `new` and `this`, and instead, opted for an entirely functional approach for code reuse.

Traditionally, `new` and `this` has been and continues to be used extensively to achieve code reuse via the built-in [prototypal inheritance](https://developer.mozilla.org/en-US/docs/Learn/JavaScript/Objects/Inheritance) that JavaScript provides out of the box.

The first reason is that you aren’t going to be working just with code that you have written. Existing code and code that is being written even as you are reading this sentence likely contain the ‘`this`‘ keyword. Would definitely help if you understand how this works right (pun intended)?

Therefore, even if you don’t want to use this in your code base, in order to interpret the behavior of legacy code, having a strong understanding of how `this` works will help.

The second reason is **expanding your coding vision and skill**. Working with a variety of patterns will deepen your understanding of how you see, read, write and interpret code. We write code not for the machine to interpret, but for ourselves. This does not simply apply to your JavaScript skills.

> Deepening your understanding will impact and influence how you write code, regardless of the language/framework you are working with.

Just as Picasso dabbled in areas that he did not particularly enjoy or agree with for inspiration, having this knowledge will expand your knowledge and understanding of code.

## What is `this`?

[![JavaScript this call context](//personalzone-hulgokm2zfcmm9u.netdna-ssl.com/wp-content/uploads/2018/03/JavaScript-this-call-context.jpg)](//personalzone-hulgokm2zfcmm9u.netdna-ssl.com/wp-content/uploads/2018/03/JavaScript-this-call-context.jpg)

Before I start explaining, if you have a programming background in the traditional class-based OOP languages (E.g. C#, Java, C++), please throw away all your preconceived notions of what the ‘`this`‘ keyword is supposed to be. The JavaScript `this` keyword behaves quite differently, because JavaScript is not a [class-based Object-oriented programming language](https://en.wikipedia.org/wiki/Class-based_programming).

Although in ES6, JavaScript provides users with an option to code using classes, it is simply [syntactic sugar](https://www.quora.com/What-is-syntactic-sugar-in-programming-languages) for the underlying prototypal inheritance structure.

**The ‘`this`‘ keyword is a pointer that points to the object that called the function.**

I cannot stress just how important the previous sentence is. Remember, there were no classes in JavaScript until it was added in ES6. [Classes](http://2ality.com/2015/02/es6-classes-final.html) are merely syntactic sugar for linking objects together to formulate a behavior that is similar to the class based inheritance that most of us all are so used to. All the behind the scenes magics is woven together via linking of the prototype chain.

If the previous sentence is difficult to understand, the context of this is very similar to an English sentence. For example, the following line

`Bob.callPerson(John);`

Can be written in English as “Bob called a person named John”. Since `callPerson()` was called from Bob, `this` points at Bob. We will get into the nitty-gritty in the upcoming sections. By the end of this post, you will leave with a much better understanding (and confidence) of the `this` keyword in JavaScript.

## Execution Context

> _Execution context_ is a concept in the language spec that—in layman’s terms—roughly equates to the ‘environment’ a function executes in; that is, variable scope (and the _scope chain_, variables in closures from outer scopes), function arguments, and the value of the `this` object.
> 
> Source: [Stackoverflow.com](https://stackoverflow.com/questions/9384758/what-is-the-execution-context-in-javascript-exactly)

Remember, right now, we are focused on ascertaining what `this` is pointing at. Therefore, the only thing we need to ask ourselves is:

*   what is calling the function? What object is calling the function?

To understand this key concept, let us examine some examples.

```
var person = {
name: "Jay",
greet: function() {
console.log("hello, " + this.name);
}
};
person.greet();
```

Who/what is calling the g_reet function_? It is the object `person` right? On the left hand side of the `greet()` call, there is a person object. Therefore, the this keyword will point at `person`. Therefore, `this.name` will be equal to `"Jay"`. Now, using the example above, what if I were to add the following:

```
var greet = person.greet; // store reference to function;
greet(); // call function
```

What do you think the console will output in this case? “Jay”? `undefined`? Or something else?

The answer is `undefined`. If you are surprised by the output, no need to feel ashamed. You are about to learn something that will help you unlock a crucial gate in your JavaScript journey.

> The value of `this` is not defined by the object it is placed in, but by **how it is called**.

Let this newfound revelation sink in before proceeding.

With this, we are going to examine the **three ways** that the `this` keyword is defined.

## Identifying where `this` points at

We examined this in the previous section. But because this (pun unintended) is so important, we will review it again. First of all, I have a challenge for you: Examine the following code.

```
var name = "Jay Global";
var person = {
name: 'Jay Person',
details: {
name: 'Jay Details',
print: function() {
return this.name;
}
},
print: function() {
return this.name;
}
};
console.log(person.details.print());  // ?
console.log(person.print());          // ?
var name1 = person.print;
var name2 = person.details;
console.log(name1()); // ?
console.log(name2.print()) // ?
```

Write down your expected answers for the `console.log()` outputs. If you are not sure, review the previous section.

Once you are ready, feel free to check out the answers below.

### Answers and Explanations

##### person.details.print()

Before we proceed, who/what is calling print? In JavaScript, we read from left to right. Therefore, this points at `details` not `person`. This is an important distinction to make, so bear it in mind if this is something new to you.

The `print` key in `details` holds a function that returns `this.name`. Since we have identified that this refers to details, the function should return the value `'Jay Details'`.

##### person.print()

Once again, identify what `this` is pointing at. `print()` is being called on the `person` object right?

In this case, the `print` function on `person` returns `this.name`. `this` is currently pointing at `person`, so “`Jay Person`” will be returned.

##### console.log(name1)

This one can be a little tricky. In the previous line, we have the following pieces of code.

```
var name1 = person.print;
```

I won’t blame you if that is what you thought. Unfortunately, it is wrong. Remember, the `this` keyword is bound when the function is called. What is in front of `name1()`? Nothing. Therefore, the `this` keyword is going to point at the global `window` object.

Therefore, the answer is “`Jay Global`”.

##### person.print()

Take a look at the object that `name2` is pointing at. It is the `details` object right?

So what will the following print? If you understood all the material up until now, this should come quite naturally if you put your mind to it.

```
console.log(name2.print()) // ??
```

The answer is “`Jay Details`” because print is called on `name2` which points at `details`.

### Lexical Scope

You might be asking: **What is lexical scope**?

Heck, why are we even covering it when we are focusing on understanding the JavaScript `this` keyword? Well, it comes into play when we start working with ES6’s arrow functions. If you have written JavaScript for a year or more, chances are, you have come across arrow functions. And they will be used more and more as ES6 becomes more standardized.

[Lexical scope in JavaScript](https://toddmotto.com/everything-you-wanted-to-know-about-javascript-scope/#lexical-scope) can be confusing to grasp. If you [understand closures](https://www.thecodingdelight.com/javascript-closure/), it will be much easier to conceptualize. Let’s take a look at a brief code snippet.

```
// lexical scope of outerFn
var outerFn = function() {
var n = 5;
console.log(innerItem);
// lexical scope of innerFn
var innerFn = function() {  
var innerItem = "inner";    // Error. Can only go upwards with the elevator. Not downwards.
console.log(n);
};
return innerFn;
};
outerFn()();
```

Think of a building with a crappy elevator that can only travel upwards.

[![JavaScript lexical scope is a lot like a building with an elevator that only goes up](//personalzone-hulgokm2zfcmm9u.netdna-ssl.com/wp-content/uploads/2018/03/JavaScript-lexical-scope-building.jpg)](//personalzone-hulgokm2zfcmm9u.netdna-ssl.com/wp-content/uploads/2018/03/JavaScript-lexical-scope-building.jpg)

The top floor of a building is the global windows object. If you are on the first floor, you are able to see and access the items in the upper floors such as those stored the second and third floor (`outerFn` and the global `window` object).

That is why when we run the following code: `outerFn()()`; it logs 5 onto the console and not `undefined`.

However, when we try to log `innerItem` from the `outerFn` lexical scope, we get the following error. Remember, the lexical scope in JavaScript is like a crappy elevator in a building that can only move upwards. Since outerFn is one lexical scope above the innerFn, it cannot go down into the innerFn lexical scope and retrieve the value inside of it. Which is why we get the following error:

```
test.html:304 Uncaught ReferenceError: innerItem is not defined
at outerFn (test.html:304)
at test.html:313
```

### `this` and Arrow Functions

In [ES6](http://es6-features.org/#ExpressionBodies), whether you like it or not, [arrow functions](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Arrow_functions) were introduced. For those that are not yet accustomed to arrow functions or are new to JavaScript, how it behaves in conjunction with the `this` keyword may cause you some confusion and potentially grief, this section is dedicated to you!

> What is the main difference between _arrow functions_ and _regular functions_ when it comes to the `this` keyword?

**Answer**:

> Arrow Functions **lexically** bind their context so `this` actually refers to the originating context.
> 
> source: [hackernoon.com](https://hackernoon.com/javascript-es6-arrow-functions-and-lexical-this-f2a3e2a5e8c4)

I couldn’t have said it any better.

Arrow functions preserve the [lexical scope](https://stackoverflow.com/questions/1047454/what-is-lexical-scope) of its current execution context, while regular functions don’t. In other words, arrow functions derive the value of `this` from the lexical scope that contains the arrow function.

Let’s examine a few code snippets to ensure that you properly understand this. Understanding how this works (no pun intended) will save you a lot of headaches in the future, as the `this` keyword and arrow functions are used in conjunction quite regularly.

### Example

Take a look at the following code snippet carefully.

```
var object = {
data: [1,2,3],
dataDouble: [1,2,3],
double: function() {
console.log("this inside of outerFn double()");
console.log(this);
return this.data.map(function(item) {
console.log(this);      // What is this ???
return item * 2;
});
},
doubleArrow: function() {
console.log("this inside of outerFn doubleArrow()");
console.log(this);
return this.dataDouble.map(item => {
console.log(this);      // What is this ???
return item * 2;
});
}
};
object.double();
object.doubleArrow();
```

If we look at the execution context, both of these are called on `object`. So, it is safe to assume that this inside of the two function refers to `object` right? Yes, but I recommend you to copy and paste this code and test it yourself.

Here is the big question

> What does `this` point at inside of the inner `map` function inside `arrow()` and `doubleArrow()`?

[![this and arrow function](//personalzone-hulgokm2zfcmm9u.netdna-ssl.com/wp-content/uploads/2018/03/this-and-arrow-function.jpg)](//personalzone-hulgokm2zfcmm9u.netdna-ssl.com/wp-content/uploads/2018/03/this-and-arrow-function.jpg)

The following image should provide a huge hint. If you are not sure, please take around 5 minutes to think about what we have discussed in previous section. Afterwards, write down your answer to what you think this points to before proceeding. In the following section, we will answer the question.

### Revision of Execution Context

The title should already have given it away. In case you don’t know, the map function iterates through the array that it is called upon and applies the return value of the passed in callback to each of its items. [Read more about JavaScript’s map function](https://www.thecodingdelight.com/functional-programming-javascript-map/) if you are unsure or are just curious.

Anyhow, since `map()` is called on `this.data`, this will point at the array stored inside of the `data` key, which is `[1,2,3]`. Using the same logic, `this.dataDouble` should point at another array with the data `[1,2,3]`.

Now, if the function call is made on `object`, we have established that this refers to `object` right? Okay, let’s move onto the following code snippet.

```
double: function() {
return this.data.map(function(item) {
console.log(this);      // What is this ???
return item * 2;
});
}
```

Here is a trick question: who is calling the [anonymous function](https://en.wikibooks.org/wiki/JavaScript/Anonymous_functions) passed to `map()`? The answer is: no object is. To make things clear, here is a basic implementation of the `map` function.

```
// Array.map polyfill
if (Array.prototype.map === undefined) {
Array.prototype.map = function(fn) {
var rv = [];
for(var i=0, l=this.length; i<l; i++)
rv.push(fn(this[i]));
return rv;
};
}
```

Is there any object in front of `fn(this[i]));`? Therefore, the `this` keyword refers to the global windows object. Then, why does `this.dataDouble.map` using an arrow function has this pointing at `object`?

I will say it again, because it it that important:

> Arrow Functions Lexically Bind their Context to the <span style="text-decoration: underline;">**Originating Context**</span>

Now, you might be asking: what is the originating context? Good question!

Who is the original caller of `doubleArrow()`? `object` right? That is the originating context 🙂

## this and `use strict`

In ES5, the [strict mode](https://docs.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/dev-guides/hh673540(v=vs.85)) feature was added in order to make the language more robust and minimize human errors. One prime example is with the relationship between how this behaves in strict mode. In order to write your code in strict mode, all you have to do is write the string `"use strict";` at the top of the scope that you are working with.

Remember that JavaScript is traditionally function scoped, not block scoped. For example,

```
function strict() {
// Function-level strict mode syntax
'use strict';
function nested() { return 'And so am I!'; }
return "Hi!  I'm a strict mode function!  " + nested();
}
function notStrict() { return "I'm not strict."; }
```

Code snippet provided by [Mozilla Developer Network.](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Strict_mode)

Although block scoping can be achieved with the features that ES6 provides such as the [let keyword](https://www.thecodingdelight.com/javascript-es6-best-parts/#ftoc-heading-7).

Now, let’s look at a simple code snippet to see how this behaves in strict mode and out of strict mode. Please run the code snippet below before proceeding.

```
(function() {
"use strict";
console.log(this);
})();
(function() {
// Without strict mode
console.log(this);
})();
```

As you saw, `this` points at `undefined` in strict mode. In contrast, `this` points at the global `window` object without strict mode. In most cases, when users use this, they don’t want it to point at the global window object. Strict mode greatly reduces the possibility of developers shooting themselves in the foot when using the `this` keyword.

For example, what if the global window object has a property with the same key value as the one that you are using in your object? For example

```
(function() {
// "use strict";
var item = {
document: "My document",
getDoc: function() {
return this.document;
}
}
var getDoc = item.getDoc;
console.log(getDoc());
})();
```

There are two problems in this code.

1.  `this` will not point at `item` on line 10.
2.  If the program is run without strict mode, no error will be thrown, since the `document` object is a property of the global `window` object.

In this simple example, it won’t be much of a problem, since the code snippet is very small.

If you run code like this in production, when working with the item stored in `getDoc`, you will see a firework of errors that will be fairly difficult to trace, especially if the codebase is large has a lot of interactions between objects.

Fortunately, if we run the code snippet in strict mode, since this is `undefined`, it will immediately throw an error back at us.

> `test.html:312 Uncaught TypeError: Cannot read property 'document' of undefined`
> `at getDoc (test.html:312)`
> `at test.html:316`
> `at test.html:317`

## Explicitly Setting the Execution Context

We have talked a lot about execution context and the this keyword assuming that nobody was explicitly manipulating the execution context.

What can be both a blessing and a curse in JavaScript is that this “**call/execution context**” can be manipulated directly by a developer using JavaScript’s built-in features. They are

*   [bind()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/bind): Explicitly set the `this` value to an object of your choice without calling the function. Pass in n number of arguments delimited by the comma character (,). E.g. `func.bind(this, param1, param2, ...)`.
*   [apply()](https://www.w3schools.com/js/js_function_apply.asp): Explicitly set the `this` value to an object of your choice. The second parameter is an array containing all the arguments that you would like to pass to the function. Lastly, **call the function**.
*   [call()](https://docs.microsoft.com/en-us/scripting/javascript/reference/call-method-function-javascript): Explicitly set the `this` value to an object of your choice and like `bind`, pass in a number of arguments using the comma delimiter. E.g. `print.call(this, param1, param2, ...)`;. Lastly, **call the function**.

All the built-in functions mentioned above have a commonality in that they are used to make the `this` keyword point to something else. These features enable us to do some really cool things. Unfortunately, the topic is so broad that it will require many posts to cover all of them, so for the sake of brevity, I will not blab on about its application points in this post.

**Note**: Out of the three functions mentioned above, only `bind()` does not directly call the function after setting the `this` keyword.

## When to Use Bind, Call and Apply

You are probably thinking: This is confusing as it is already. What is the purpose of learning all of this?

First of all, you will see bind, call and apply used everywhere, especially in large libraries and frameworks. If you don’t understand what it does, you are woefully utilizing only a small part of the power JavaScript offers.

If you don’t want to read about possible usages and want to get into learning right away, feel free to skip this section.

A lot of the possible usages listed below are very broad and deep topics (most likely unable to be covered in a single post), so if you want to learn more about them, I will attach links. In the future, I might add sections to this ultimate guide, so that people can get the most out of it.

1.  [Borrowing methods](https://medium.com/@thejasonfile/borrowing-methods-from-a-function-in-javascript-713a0beed40d)
2.  [Currying](https://www.sitepoint.com/currying-in-functional-javascript/)
3.  [Partial application](http://benalman.com/news/2012/09/partial-application-in-javascript/#partial-application)
4.  [Dependency injection](http://krasimirtsonev.com/blog/article/Dependency-injection-in-JavaScript)

If I am missing any other practical use cases, please leave a message and let me know. I am always out to improve the guides so that you as a reader can get the most out of reading.

> Read high quality open source code to take your knowledge and skills to the next level.

Seriously, you will see some real practical application of the this keyword, call, apply, bind in some open source code. I talk about this along with other methods of [becoming a better programmer](https://www.thecodingdelight.com/become-better-programmer/).

In my opinion, the best open source to start reading is [underscore](http://underscorejs.org/). It isn’t monolithic compared to other open source projects like [d3](https://github.com/d3/d3), so it is perfect for educational purposes. Furthermore, it is compact, well-documented and the coding style is relatively easy to follow.

## JavaScript `this` and bind

As mentioned, `bind` allows you to explicitly set what this points at without actually calling the function. Here is a simple example

```
var bobObj = {
name: "Bob"
};
function print() {
return this.name;
}
// explicitly set this to point at "bobObj"
var printNameBob = print.bind(bobObj);
console.log(printNameBob());    // this points at bob, so logs "Bob"
```

In the example above, if we were to remove the bind method, then this would point at the global `window` object.

This might sound very stupid, but you should use `bind` when you want to bind the `this` object to a specific object. In some cases, we may want to borrow methods from another objects. For example,

```
var obj1 = {
data: [1,2,3],
printFirstData: function() {
if (this.data.length)
return this.data[0];
}
};
var obj2 = {
data: [4,5,6],
printSecondData: function() {
if (this.data.length > 1)
return this.data[1];
}
};
// get access to obj'2 method to use for obj1;
var getSecondData = obj2.printSecondData.bind(obj1);
console.log(getSecondData());   // prints 2
```

In the sample code snippet, the `obj2` has a method called `printSecondData` which we want to lend to `obj1`. In the following line

```
var getSecondData = obj2.printSecondData.bind(obj1);
```

we are using the power of bind to give `obj1` access to the `printSecondData` method on `obj2`.

### Exercise

In the code below

```
var object = {
data: [1,2,3],
double: function() {
this.data.forEach(function() {
// Get this to point to object.
console.log(this);
});
}
};
object.double();
```

Have the this keyword point at `object`. Hint: You do not have to rewrite `this.data.forEach`.

##### Answer

In one of the previous section, we need to be aware of execution context. If you look closely at how the anonymous function is called, it is not called as a method of a object. Therefore, the `this` keyword will point at the global `window` object.

Therefore, we need to bind object as the context to the anonymous function so that this points to `object`. now, when `double` runs, `object` is calling it, so the `this` inside of `double` when `object.double` is called is `object`.

```
var object = {
data: [1,2,3],
double: function() {
return this.data.forEach(function() {
// Get this to point to object.
console.log(this);
}.bind(this));
}
};
object.double();
```

However, what happens if we do the following?

```
var double = object.double;
double();   // ??
```

What is the call context of `double()`? It is the global context. Therefore, we will get the following error.

> `Uncaught TypeError: Cannot read property 'forEach' of undefined`
> `at double (test.html:282)`
> `at test.html:289`

So, we need to be mindful of how we call functions when using the `this` keyword. We can reduce the possibility of this kind of error by providing an API to users that fixes the this keyword. Remember that this comes at the expense of flexibility, so count the costs before making a decision.

```
var double = object.double.bind(object);
double();  // no more error
```

## JavaScript `this` and call

The call method is very similar to bind, but the big difference is that `call`, as the name implies, immediately calls/executes the function.

```
var item = {
name: "I am"
};
function print() {
return this.name;
}
// executed right away
var printNameBob = console.log(print.call(item));
```

Most of the use cases with `call`, `apply` and `bind` will overlap. The most important thing as a programmer is to first understand the differences between the three methods and use them according to their design and purpose. Once you understand, you will be able to use them creatively in your code to create powerful constructs.

When working with fixed amount of arguments, it is good to use `call` or `bind`. For example, a `doLogin` function will accept two arguments always: `username` and `password`. In this case, if you need to bind this to a specific object, `call` or `bind` will serve you well.

### How to use call

One of the most common uses in the past was to convert array-like objects such as the `arguments` object into arrays. For example,

```
function convertArgs() {
var convertedArgs = Array.prototype.slice.call(arguments);
console.log(arguments);
console.log(Array.isArray(arguments));  // false
console.log(convertedArgs);
console.log(Array.isArray(convertedArgs)); // true
}
convertArgs(1,2,3,4);
```

In the example above, we used call to convert the `argument` object into an array. In the next example, we will call a method available on the `Array` object, setting the argument object as the this in its method to add up the arguments passed.

```
function add (a, b) { 
return a + b; 
}
function sum() {
return Array.prototype.reduce.call(arguments, add);
}
console.log(sum(1,2,3,4)); // 10
```

We are calling reduce on an array like object. Note that arguments is not an array, but we are giving it access to the reduce method. If you are curious about how reduce works, you can [read about reduce here](https://www.thecodingdelight.com/map-filter-reduce/).

### Exercises

Now, it is time to solidify your newfound knowledge.

1.  [document.querySelectorAll()](https://www.w3schools.com/jsref/met_document_queryselectorall.asp) returns a `NodeList`, which is an array like object. Write a function that takes a CSS selector and returns an array of Nodes selected.
2.  Create a function that accepts an array of key value pairs and sets the value to the item that this keyword is pointing at and return that object. If this is `null` or `undefined`, create a new `object`. E.g. `set.call( {name: "jay"}, {age: 10, email: '[[email protected]](/cdn-cgi/l/email-protection)'}); // return {name: "jay", age: 10, email: '[[email protected]](/cdn-cgi/l/email-protection)'}`

## JavaScript this and apply

The apply is the array accepting version of call. Therefore, when using `apply`, think of arrays.

> Apply a method to a list.

That is how I remember it and it has helped. Apply adds another plethora of possibilities to your already stacked arsenal of tools as you will soon come to see.

When working with a dynamic list of arguments, use apply. Converting a set of data into an array and using apply can allow you to create some powerful and flexible functions that will make your life a lot easier.

### How to use apply

[Math.min](https://www.w3schools.com/jsref/jsref_min.asp) and `max` are functions that accept n number of arguments and returns the max and min respectively. Instead of passing in n arguments, you can put n arguments into an array and pass it into min using `apply`.

```
Math.min(1,2,3,4); // returns 1
Math.min([1,2,3,4]); // returns NaN. Only accepts numbers. 
Math.min.apply(null, [1,2,3,4]); // returns 1
```

Did that bend your mind? If so, allow me to explain. By using apply, we are passing in an array, since it accepts an array as the second arguments. What

```
Math.min.apply(null, [1,2,3,4]); // returns 1
```

is doing is essentially the following

`Math.min(1,2,3,4); // returns 1
`

That is the magic of apply and what i wanted to point out. It works the same way as `call`, but instead of n arguments, we are just passing in an array. Fantastic right? Wait, does that mean `Math.min.call(null, 1,2,3,4);` works the same way as `Math.min.apply(null, [1,2,3,4]);`?

Yep, you bet! You are now starting to get the hang of it 🙂

Let’s look at another application.

```
function logArgs() {
console.log.apply(console, arguments);
}
logArgs(1,3,'I am a string', {name: "jay", age: "1337"}, [4,5,6,7]);
```

Yep, you can even pass in array like objects as the second argument to `apply`. Cool right?

### Exercises

1.  Create a function that accepts an array of key value pairs and sets the value to the item that this keyword is pointing at and return that object. If this is `null` or `undefined`, create a new `object`. E.g. `set.apply( {name: "jay"}, [{age: 10}]); // return {name: "jay", age: 10}`
2.  Create a function similar to `Math.max` and `min`, but one one that applies calculations. The first two arguments should be `numbers`. Make sure to convert the arguments after the second into an **array of functions.** A sample template to get started with is provided below

```
function operate() {
if (arguments.length < 3) {
throw new Error("Must have at least three arguments");
}
if (typeof arguments[0] !== 'number' || typeof arguments[1] !== 'number') {
throw new Error("first two arguments supplied must be a number");
}
// Write code ...
// An array of functions. Hint use either call, apply or bind. Don't iterate over arguments and place functions in new array.
var args;
var result = 0;
// Good luck
}
function sum(a, b) {
return a + b;
}
function multiply(a,b) {
return a * b;
}
console.log(operate(10, 2, sum, multiply));    // must return 32 -> (10 + 2) + (10 * 2) = 32
```

## Additional Resource and Readings

In case my explanations did not make sense to you, below are some additional resources that will help you understand how bind works in JavaScript.

*   [Understanding JavaScript function bind prototype](https://www.smashingmagazine.com/2014/01/understanding-javascript-function-prototype-bind/)
*   [Stackoverflow – Use of the JavaScript bind method](https://stackoverflow.com/questions/2236747/use-of-the-javascript-bind-method)
*   [How-to: call() , apply() and bind() in JavaScript](https://www.codementor.io/niladrisekhardutta/how-to-call-apply-and-bind-in-javascript-8i1jca6jp)
*   [JavaScript .call() .apply() and .bind() — explained to a total noob](https://medium.com/@owenyangg/javascript-call-apply-and-bind-explained-to-a-total-noob-63f146684564)

I also strongly recommend studying up on [JavaScript’s prototype chain](https://www.digitalocean.com/community/tutorials/understanding-prototypes-and-inheritance-in-javascript), because not only is the `this` key word used heavily, it is the standard way of implementing inheritance in JavaScript.

Below are a list of books that will take your knowledge and understanding of how `this` can be used.

*   [Effective JavaScript: 68 Specific Ways to Harness the Power of JavaScript (Effective Software Development Series)](http://amzn.to/2HGhsDP): Although an oldie, the book is well written and provides clear examples of how this, apply, call, bind can be used to improve the way that you write code. The book is written by Dave Hermann a member of [TC39](https://www.ecma-international.org/memento/TC39-M.htm), so you can bet that he knows his JavaScript!
*   [You dont’ know JS – this and Object Prototoypes](https://github.com/getify/You-Dont-Know-JS/tree/master/this%20%26%20object%20prototypes): Kyle Simpson does a great job in explaining how objects and prototypes work with each other in a clear, relatively beginner-friendly manner.

## Conclusion

The JavaScript `this` keyword is here to stay, considering that an unimaginably large amount of code has already been written using it.

A good artisan knows how to use his/her tools. As a JavaScript developer, it is of utmost importance that you know how to utilize its features.

If you would like to see more in-depth explanation regarding a specific aspect of the `this` keyword, or more code, please let me know. Some possible options include posts on the following (but not limited to)

*   `this` and the `new` keyword.
*   The prototype chain in JavaScript.
*   `this` and JavaScript classes.

Additionally, if there are any specific issues or additions that you would like to see in this post, please email me or send me a message. I just updated [my GitHub profile](https://github.com/JWLee89) to display my email address. I am looking forward to building up this guide so that readers will continue to benefit from it, regardless of their level of experience. Let’s partake in this journey together!

Thank you for reading and looking forward to hearing ideas or suggestions on what to add to this guide so that readers get the most out of it.

Take care and until next time!

### About the Author [Jay](https://www.thecodingdelight.com/author/ljay189/)

I am a programmer currently living in Seoul, South Korea. I created this blog as an outlet to express what I know / have been learning in text form for retaining knowledge and also to hopefully help the wider community. I am passionate about data structures and algorithms. The back-end and databases is where my heart is at.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
