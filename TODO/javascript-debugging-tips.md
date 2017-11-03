> * 原文地址：[The 14 JavaScript debugging tips you probably didn't know](https://raygun.com/javascript-debugging-tips)
> * 原文作者：[Luis Alonzo](https://raygun.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/javascript-debugging-tips.md](https://github.com/xitu/gold-miner/blob/master/TODO/javascript-debugging-tips.md)
> * 译者：
> * 校对者：

# The 14 JavaScript debugging tips you probably didn't know

Debug your JavaScript with greater speed and efficiency

Knowing your tools can make a significant difference when it comes to getting things done. Despite JavaScript's reputation as being difficult to debug, if you keep a couple of tricks up your sleeve errors and bugs will take less time to resolve.

**We've put together a list of 14 debugging tips that you may not know**, but might want to keep in mind for next time you find yourself needing to debug your JavaScript code! 

**Let's get to it.**

Most of these tips are for Chrome Inspector and Firefox, although many will also work with other inspectors. 

## 1. ‘debugger;’

After console.log, 'debugger;' is my favorite quick and dirty debugging tool. Once it's in your code, Chrome will automatically stop there when executing. You can even wrap it in conditionals, so it only runs when you need it.

```
if (thisThing) {
    debugger;
}
```

## 2. Display objects as a table

Sometimes, you have a complex set of objects that you want to view. You can either console.log them and scroll through the list, or break out the console.table helper. Makes it easier to see what you’re dealing with!

```
var animals = [
    { animal: 'Horse', name: 'Henry', age: 43 },
    { animal: 'Dog', name: 'Fred', age: 13 },
    { animal: 'Cat', name: 'Frodo', age: 18 }
];

console.table(animals);
```

Will output: 

[![Screenshot showing the resulting table for JavaScript debugging tip 2 ](https://raygun.com/upload/Debugging%202b.png)](https://raygun.com/upload/Debugging%202b.png)

## 3. Try all the sizes

While having every single mobile device on your desk would be awesome, it’s not feasible in the real world. How about resizing your viewport instead? Chrome provides you with everything you need. Jump into your inspector and click the **‘toggle device mode’** button. Watch your media queries come to life!

[![](https://raygun.com/upload/Debugging%201%20.png)](https://raygun.com/upload/Debugging%201%20.png)

## 4. How to find your DOM elements quickly

Mark a DOM element in the elements panel and use it in your console. Chrome Inspector keeps the last five elements in its history so that the final marked element displays with $0, the second to last marked element $1 and so on.

If you mark following items in order ‘item-4′, ‘item-3’, ‘item-2’, ‘item-1’, ‘item-0’ then you can access the DOM nodes like this in the console:

[![](https://raygun.com/upload/Debugging%202.png)](https://raygun.com/upload/Debugging%202.png)

## 5. Benchmark loops using console.time() and console.timeEnd()

It can be super useful to know exactly how long something has taken to execute, especially when debugging slow loops. You can even set up multiple timers by assigning a label to the method. Let’s see how it works:

```
console.time('Timer1');

var items = [];

for(var i = 0; i < 100000; i++){
   items.push({index: i});
}

console.timeEnd('Timer1');
```

This has produced the following result:

[![](https://raygun.com/upload/Debugging%203.png)](https://raygun.com/upload/Debugging%203.png)

## 6. Get the stack trace for a function

You probably know JavaScript frameworks, produce a lot of code – quickly.

It creates views and triggers events, so eventually you'll want to know what caused the function call.

Since JavaScript is not a very structured language, it can sometimes be hard to get an overview of **what** happened and **when**. This is when console.trace (or just trace in the console) comes handy to be able to debug JavaScript.

Imagine you want to see the entire stack trace for the function call funcZ in the car instance on line 33:

```
var car;
var func1 = function() {
	func2();
}

var func2 = function() {
	func4();
}
var func3 = function() {
}

var func4 = function() {
	car = new Car();
	car.funcX();
}
var Car = function() {
	this.brand = ‘volvo’;
	this.color = ‘red’;
	this.funcX = function() {
		this.funcY();
	}

	this.funcY = function() {
		this.funcZ();
	}

	this.funcZ = function() {
		console.trace(‘trace car’)
	}
}
func1();
var car; 
var func1 = function() {
	func2();
} 
var func2 = function() {
	func4();
}
var func3 = function() {
} 
var func4 = function() {
	car = new Car();
	car.funcX();
}
var Car = function() {
	this.brand = ‘volvo’;
	this.color = ‘red’;
	this.funcX = function() {
		this.funcY();
	}
	this.funcY = function() {
		this.funcZ();
	}
 	this.funcZ = function() {
		console.trace(‘trace car’)
	}
} 
func1();
```

Line 33 will output:

[![](https://raygun.com/upload/Debugging%204.png)](https://raygun.com/upload/Debugging%204.png)

Now we can see that **func1** called **func2, **which called **func4**. **Func4** thencreated an instance of **Car** and then called the function **car.funcX**, and so on.

Even though you think you know your script well this can still be quite handy. Let’s say you want to improve your code. Get the trace and your great list of all related functions. Every single one is clickable, and you can now go back and forth between them. It’s like a menu just for you.

## 7. Unminify code as an easy way to debug JavaScript

Sometimes you may have an issue in production, and your source maps didn’t quite make it to the server. **Fear not**. Chrome can unminify your Javascript files to a more human-readable format. The code won’t be as helpful as your real code – but at the very least you can see what’s happening. Click the {} Pretty Print button below the source viewer in the inspector.

[![](https://raygun.com/upload/Debugging%205.png)](https://raygun.com/upload/Debugging%205.png)

## 8. Quick-find a function to debug

Let’s say you want to set a breakpoint in a function.

The two most common ways to do that is:

**1. Find the line in your inspector and add a breakpoint
2. Add a debugger in your script**

In both of these solutions, you have to click around in your files to find the particular line you want to debug

What’s probably less common is to use the console. Use debug(funcName) in the console and the script will stop when it reaches the function you passed in.

It’s quick, but the downside is it doesn’t work on private or anonymous functions. But if that’s not the case, it’s probably the fastest way to find a function to debug. (Note: there’s a function called console.debug which is not the same thing.)

```
var func1 = function() {
	func2();
};

var Car = function() {
	this.funcX = function() {
		this.funcY();
	}

	this.funcY = function() {
		this.funcZ();
	}
}

var car = new Car();
```

Type debug(car.funcY) in the console and the script will stop in debug mode when it gets a function call to car.funcY:

[![](https://raygun.com/upload/Debugging%206.png)](https://raygun.com/upload/Debugging%206.png)

## 9.  Black box scripts that are NOT relevant

Today we often have a few libraries and frameworks on our web apps. Most of them are well tested and relatively bug-free. But, the debugger still steps into all the files that have no relevance for this debugging task. The solution is to black box the script you don’t need to debug. This could also include your own scripts. [Read more about debugging black box in this article. ](https://raygun.com/blog/javascript-debugging-with-black-box/)

## 10. Find the important things in complex debugging

In more complex debugging we sometimes want to output many lines. One thing you can do to keep a better structure of your outputs is to use more console functions, for example, Console.log, console.debug, console.warn, console.info, console.error and so on. You can then filter them in your inspector. But sometimes this is not really what you want when you need to debug JavaScript. It’s now that YOU can get creative and style your messages. Use CSS and make your own structured console messages when you want to debug JavaScript:

```
console.todo = function(msg) {
	console.log(‘ % c % s % s % s‘, ‘color: yellow; background - color: black;’, ‘–‘, msg, ‘–‘);
}

console.important = function(msg) {
	console.log(‘ % c % s % s % s’, ‘color: brown; font - weight: bold; text - decoration: underline;’, ‘–‘, msg, ‘–‘);
}

console.todo(“This is something that’ s need to be fixed”);
console.important(‘This is an important message’);
```

Will output: 

[![](https://raygun.com/upload/Debugging%207.png)](https://raygun.com/upload/Debugging%207.png)

**For example:**

In the console.log() you can set %s for a string, %i for integers and %c for custom style. You can probably find better ways to use this. If you use a single page framework, you maybe want to have one style for view message and another for models, collections, controllers and so on. Maybe also name the shorter like wlog, clog and mlog use your imagination!

## 11. Watch specific function calls and its arguments

In the Chrome console, you can keep an eye on specific functions. Every time the function is called, it will be logged with the values that it was passed in.

```
var func1 = function(x, y, z) {
//....
};
```

Will output: 

[![](https://raygun.com/upload/Debugging%208.png)](https://raygun.com/upload/Debugging%208.png)

This is a great way to see which arguments are passed into a function. But I must say it would be good if the console could tell how many arguments to expect. In the above example, func1 expect 3 arguments, but only 2 is passed in. If that’s not handled in the code it could lead to a possible bug.

## 12. Quickly access elements in the console

A faster way to do a querySelector in the console is with the dollar sign. $(‘css-selector’) will return the first match of CSS selector. $(‘css-selector’) will return all of them. If you are using an element more than once, it’s worth saving it as a variable.

[![](https://raygun.com/upload/Debugging%2010.png)](https://raygun.com/upload/Debugging%2010.png)

## 13. Postman is great (but Firefox is faster)

Many developers are using Postman to play around with ajax requests. Postman is excellent, but it can be a bit annoying to open up a new browser window, write new request objects and then test them.

Sometimes it’s easier to use your browser.

When you do, you no longer need to worry about authentication cookies if you are sending to a password-secure page. This is how you would edit and resend requests in Firefox.

Open up the inspector and go to the network tab. Right-click on the desired request and choose Edit and Resend. Now you can change anything you want. Change the header and edit your parameters and hit resend.

Below I present a request twice with different properties:

![When debugging JavaScript, Chrome lets you pause when a DOM element changes](https://raygun.com/upload/Debugging%2011.png)

## 14. Break on node change

The DOM can be a funny thing. Sometimes things change and you don’t know why. However, when you need to debug JavaScript, Chrome lets you pause when a DOM element changes. You can even monitor its attributes. In Chrome Inspector, right click on the element and pick a break on setting to use:

[![](https://raygun.com/upload/Debugging%2014.png)](https://raygun.com/upload/Debugging%2014.png)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
