> * 原文地址：[Mastering JavaScript this Keyword – Detailed Guide](https://www.thecodingdelight.com/javascript-this/#ftoc-heading-2)
> * 原文作者：[Jay](https://www.thecodingdelight.com/author/ljay189/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/mastering-javascript-this-keyword-detailed-guide.md](https://github.com/xitu/gold-miner/blob/master/TODO1/mastering-javascript-this-keyword-detailed-guide.md)
> * 译者：[老教授](https://juejin.im/user/58ff449a61ff4b00667a745c)
> * 校对者：

# 深入浅出 JavaScript 关键词 -- this

要说 JavaScript 这门语言最容易让人困惑的知识点，`this` 关键词肯定算一个。JavaScript 语言面世多年，一直在进化完善，现在在服务器上还可以通过 node.js 来跑 JavaScript。显然，这门语言还会活很久。

所以说，我一直相信，如果你是一个 JavaScript 开发者或者说 Web 开发者，学好 JavaScript 的运作原理以及语言特点肯定对你以后大有好处。

## 开始之前

在开始正文之前，我强烈推荐你先掌握好下面的知识：

*   [变量作用域和作用域提升](https://www.thecodingdelight.com/variable-scope-hoisting-javascript/)
*   [JavaScript 的函数](https://www.codecademy.com/courses/functions-in-javascript-2-0/0/1)
*   [闭包](https://medium.com/dailyjs/i-never-understood-javascript-closures-9663703368e8)

如果没有对这些基础知识掌握踏实，直接讨论 JavaScript 的 `this` 关键词只会让你感到更加地困惑和挫败。

## 我为什么要学 `this`？

如果上面的简单介绍没有说服你来深入探索 `this` 关键词，那我用这节来讲讲为什么要学。

考虑这样一个重要问题，假设开发者，比如 Douglas Crockford （译者注：JavaScript 领域必知牛人），不再使用 `new` 和 `this`，转而使用完完全全的函数式写法来做代码复用，会怎样？

事实上，基于 JavaScript 内置的现成的[原型继承](https://developer.mozilla.org/en-US/docs/Learn/JavaScript/Objects/Inheritance)功能，我们已经使用并且将继续广泛使用 `new` 和 `this` 关键词来实现代码复用。

理由1，如果只能使用自己写过的代码，你是没法工作的。现有的代码以及你读到这句话时别人正在写的代码都很有可能包含 `this` 关键词。那么学习怎么用好它是不是很有用呢？

因此，即使你不打算在你代码基础上使用它，深入掌握 `this` 的原理也能让你在接手别人的代码理解其逻辑时事半功倍。

理由2，**拓展你的编码视野和技能**。使用不同的设计模式会加深你对代码的理解，怎么去看、怎么去读、怎么去写、怎么去理解。我们写代码不仅是给机器去解析，还是写给我们自己看的。要写出可读性高的代码并不是简简单单地写过几句 JavaScript 就能做到的。

> 随着对编程理念的逐步深入理解，它会逐渐塑造你的编码风格，不管你用的是什么语言什么框架。

就像毕加索会为了获得灵感而涉足那些他并不是很赞同很感兴趣的领域，学习 this 会拓展你的知识，加深对代码的理解。

## 什么是 `this` ？

[![JavaScript this 指向](//personalzone-hulgokm2zfcmm9u.netdna-ssl.com/wp-content/uploads/2018/03/JavaScript-this-call-context.jpg)](//personalzone-hulgokm2zfcmm9u.netdna-ssl.com/wp-content/uploads/2018/03/JavaScript-this-call-context.jpg)

在我开始讲解前，如果你学过一门基于类的面向对象编程语言（比如 C#，Java，C++），那请将你对 `this` 这个关键词应该是做什么用的先入为主的概念扔到垃圾桶里。JavaScript 的 `this` 关键词是很不一样，因为 JavaScript 本来就不是一门基于类的[面向对象编程语言](https://en.wikipedia.org/wiki/Class-based_programming)。

虽说 ES6 里面 JavaScript 提供了类这个特性给我们用，但它只是一个[语法糖](https://www.quora.com/What-is-syntactic-sugar-in-programming-languages)，一个基于原型继承的语法糖。

** `this` 就是一个指针，指向我们调用函数的对象。**

我难以强调上一句话有多重要。请记住，在 Class 添加到 ES6 之前，JavaScript 中没有 Class 这种东西。[Class](http://2ality.com/2015/02/es6-classes-final.html) 只不过是一个将对象串在一起表现得像类继承一样的语法糖，以一种我们已经习惯的写法。所有的魔法背后都是用原型链编织起来的。

如果上面的话不好理解，那你可以这样想，this 的上下文跟英语句子的表达很相似。比如下面的例子

`Bob.callPerson(John);`

就可以用英语写成 “Bob called a person named John”。由于 `callPerson()` 是 Bob 发起的，那 `this` 就指向 Bob。我们将在下面的章节深入更多的细节。到了这篇文章结束时，你会对 `this` 关键词有更好的理解（和信心）。

## 执行上下文

> _执行上下文_是语言规范中的一个概念，用通俗的话讲，大致等同于函数的执行“环境”。具体的有：变量作用域（和_作用域链条_，闭包里面来自外部作用域的变量），函数参数，以及 `this` 对象的值。
> 
> 引自: [Stackoverflow.com](https://stackoverflow.com/questions/9384758/what-is-the-execution-context-in-javascript-exactly)

记住，现在起，我们专注于查明 `this` 关键词到底指向哪。因此，我们现在要思考的就一个问题：

*   是什么调起函数？是哪个对象调起了函数？

为了理解这个关键概念，我们来测一下下面的代码。

```
var person = {
    name: "Jay",
    greet: function() {
        console.log("hello, " + this.name);
    }
};
person.greet();
```

谁调用了 _greet 函数_？是 `person` 这个对象对吧？在 `greet()` 调用的左边是一个 person 对象，那么 this 关键词就指向 `person`，`this.name` 就等于 `"Jay"`。现在，还是用上面的例子，我加点料：

```
var greet = person.greet; // 将函数引用存起来;
greet(); // 调用函数
```

你觉得在这种情况下控制台会输出什么？“Jay”？`undefined`？还是别的？

正确答案是 `undefined`。如果你对这个结果感到惊讶，不必惭愧。你即将学习的东西将帮助你在 JavaScript 旅程中打开关键的大门。

> `this` 的值并不是由函数定义放在哪个对象里面决定，而是函数执行时由谁来唤起决定。

对于这个意外的结果我们暂且压下，继续看下去。（感觉前后衔接得不够流畅）

带着这个困惑，我们接着测试下 `this` **三种**不同的定义方式。

## 找出 `this` 的指向

上一节我们已经对 `this` 做了测试。但是这块知识实在重要，我们需要再好好琢磨一下。在此之前，我想用下面的代码给你出个题：

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

`console.log()` 将会输出什么，把你的答案写下来。如果你还想不清楚，复习下上一节。

准备好了吗？放松心情，我们来看下面的答案。

### 答案和解析

##### person.details.print()

首先，谁调用了 print 函数？在 JavaScript 中我们都是从左读到右。于是 this 指向 `details` 而不是 `person`。这是一个很重要的区别，如果你对这个感到陌生，那赶紧把它记下。

`print` 作为 `details` 对象的一个 key，指向一个返回 `this.name` 的函数。既然我们已经找出 this 指向 details ，那函数的输出就应该是 `'Jay Details'`。

##### person.print()

再来一次，找出 `this` 的指向。`print()` 是被 `person` 对象调用的，没错吧？

在这种情况，`person` 里的 `print` 函数返回 `this.name`。`this` 现在指向 `person` 了，那 `'Jay Person'` 就是返回值。

##### console.log(name1)

这一题就有点狡猾了。在上一行有这样一句代码：

```
var name1 = person.print;
```

如果你是通过这句来思考的，我不会怪你。很遗憾，这样去想是错的。要记住，`this` 关键词是在函数调用时才做绑定的。`name1()` 前面是什么？什么都没有。因此 `this` 关键词就将指向全局的 `window` 对象去。

因此，答案是 `'Jay Global'`。

##### name2.print()

看一下 `name2` 指向哪个对象，是 `details` 对象没错吧？

所以下面这句会打印出什么呢？如果到目前为止的所有小点你都理解了，那这里稍微思考下你就自然有答案了。

```
console.log(name2.print()) // ??
```

答案是 `'Jay Details'`，因为 `print` 是 `name2` 调起的，而 `name2` 指向 `details`。

### 词法作用域

你可能会被问：“什么是词法作用域？”

逗我呢，我们不是在探讨 `this` 关键词吗，这个又是哪里冒出来的？好吧，当我们用起 ES6 的箭头函数，这个就要考虑了。如果你已经写了不止一年的 JavaScript，那你很可能已经碰到箭头函数。随着 ES6 逐渐成为现实标准，箭头函数也变得越来越常用。

[JavaScript 的词法作用域](https://toddmotto.com/everything-you-wanted-to-know-about-javascript-scope/#lexical-scope) 并不好懂。 如果你 [理解闭包](https://www.thecodingdelight.com/javascript-closure/)，那要理解这个概念就容易多了。来看下下面的小段代码。 

```
// outerFn 的词法作用域
var outerFn = function() {
    var n = 5;
    console.log(innerItem);
    // innerFn 的词法作用域
    var innerFn = function() {  
        var innerItem = "inner";    // 错了。只能坐着电梯向上，不能向下。
        console.log(n);
    };
    return innerFn;
};
outerFn()();
```

想象一下一栋楼里面有一架只能向上走的诡异电梯。

[![JavaScript lexical scope is a lot like a building with an elevator that only goes up](//personalzone-hulgokm2zfcmm9u.netdna-ssl.com/wp-content/uploads/2018/03/JavaScript-lexical-scope-building.jpg)](//personalzone-hulgokm2zfcmm9u.netdna-ssl.com/wp-content/uploads/2018/03/JavaScript-lexical-scope-building.jpg)

建筑的顶层就是全局 windows 对象。如果你现在在一楼，你就可以看到并访问那些放在楼上的东西，比如放在二楼的 `outerFn` 和放在三楼的 `window` 对象。

这就是为什么我们执行代码 `outerFn()()`，它在控制台打出了 5 而不是 `undefined`。

然而，当我们试着在 `outerFn` 词法作用域下打出日志 `innerItem`，我们遇到了下面的报错。请记住，JavaScript 的词法作用域就好像建筑里面那个只能向上走的诡异电梯。由于 outerFn 的词法作用域在 innerFn 上面，所以它不能向下走到 innerFn 的词法作用域里面并拿到里面的值。这就是触发下面报错的原因：

```
test.html:304 Uncaught ReferenceError: innerItem is not defined
at outerFn (test.html:304)
at test.html:313
```

### `this` 和箭头函数

在 [ES6](http://es6-features.org/#ExpressionBodies) 里面，不管你喜欢与否，[箭头函数](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Arrow_functions)被引入了进来。对于那些还没用惯箭头函数或者新学 JavaScript 的人来说，当箭头函数和 `this` 关键词混合使用时会发生什么，这个点可能会给你带来小小的困惑和淡淡的忧伤。那这个小节就是为你们准备的！

> 当涉及到 `this` 关键词，_箭头函数_ 和 _普通函数_ 主要的不同是什么？

**回答：**

> 箭头函数按**词法作用域**来绑定它的上下文，所以 `this` 实际上会引用到原来的上下文。
> 
> 引自：[hackernoon.com](https://hackernoon.com/javascript-es6-arrow-functions-and-lexical-this-f2a3e2a5e8c4)

我实在没法给出比这个更好的总结。

箭头函数保持它当前执行上下文的[词法作用域](https://stackoverflow.com/questions/1047454/what-is-lexical-scope)不变，而普通函数则不会。换句话说，箭头函数从包含它的词法作用域中继承到了 `this` 的值。

我们不妨来测试一些代码片段，确保你真的理解了。想清楚这块知识点未来会让你少点头痛，因为你会发现 `this` 关键词和箭头函数太太太经常一起用了。

### 示例

仔细阅读下面的代码片段。

```
var object = {
    data: [1,2,3],
    dataDouble: [1,2,3],
    double: function() {
        console.log("this inside of outerFn double()");
        console.log(this);
        return this.data.map(function(item) {
            console.log(this);      // 这里的 this 是什么？？
            return item * 2;
        });
    },
    doubleArrow: function() {
        console.log("this inside of outerFn doubleArrow()");
        console.log(this);
        return this.dataDouble.map(item => {
            console.log(this);      // 这里的 this 是什么？？
            return item * 2;
        });
    }
};
object.double();
object.doubleArrow();
```

如果我们看执行上下文，那这两个函数都是被 `object` 调用的。所以，就此断定这两个函数里面的 this 都指向 `object` 不为过吧？是的，但我建议你拷贝这段代码然后自己测一下。

这里有个大问题：

> `arrow()` 和 `doubleArrow()` 里面的 `map` 函数里面的 `this` 又指向哪里呢？

[![this 和箭头函数](//personalzone-hulgokm2zfcmm9u.netdna-ssl.com/wp-content/uploads/2018/03/this-and-arrow-function.jpg)](//personalzone-hulgokm2zfcmm9u.netdna-ssl.com/wp-content/uploads/2018/03/this-and-arrow-function.jpg)

上一张图已经给了一个大大的提示。如果你还不确定，那请花5分钟将我们上一节讨论的内容再好好想想。然后，根据你的理解，在实际执行代码前把你认为的 this 应该指向哪里写下来。在下一节我们将会回答这个问题。

### 回顾执行上下文

这个标题已经把答案泄露出来了。在你看不到的地方，map 函数对调用它的数组进行遍历，将数组的每一项传到回调函数里面并把执行结果返回。如果你对 JavaScript 的 map 函数不太了解或有所好奇，可以读读[这个](https://www.thecodingdelight.com/functional-programming-javascript-map/)了解更多。

总之，由于 `map()` 是被 `this.data` 调起的，于是 this 将指向那个存储在 `data` 这个 key 里面的数组，即 `[1,2,3]`。同样的逻辑，`this.dataDouble` 应该指向另一个数组，值为 `[1,2,3]`。

现在，如果函数是 `object` 调用的，我们已经确定 this 指向 `object` 对吧？好，那来看看下面的代码片段。

```
double: function() {
    return this.data.map(function(item) {
        console.log(this);      // 这里的 this 是什么？？
        return item * 2;
    });
}
```

这里有个很有迷惑性的问题：传给 `map()` 的那个[匿名函数](https://en.wikibooks.org/wiki/JavaScript/Anonymous_functions)是谁调用的？答案是：这里没有一个对象是。为了看得更明白，这里给出一个 `map` 函数的基本实现。

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

`fn(this[i]));` 前面有什么对象吗？没。因此，`this` 关键词指向全局的 windows 对象。那，为什么 `this.dataDouble.map` 使用了箭头函数会使得 this 指向 `object` 呢？

我想再说一遍这句话，因为它实在很重要：

> 箭头函数按词法作用域将它的上下文绑定到 <span style="text-decoration: underline;">**原来的上下文**</span>

现在，你可能会问：原来的上下文是什么？问得好！

谁是 `doubleArrow()` 的初始调用者？就是 `object` 对吧？那它就是原来的上下文 🙂

## this 和 `use strict`

为了让 JavaScript 更加健壮及尽量减少人为出错，ES5 引进了[严格模式](https://docs.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/dev-guides/hh673540(v=vs.85))。一个典型的例子就是 this 在严格模式下的表现。你如果想按照严格模式来写代码，你只需要在你正在写的代码的作用域最顶端加上这么一行 `"use strict;"`。

记住，传统的 JavaScript 只有函数作用域，没有块作用域。举个例子：

```
function strict() {
    // 函数级严格模式写法
    'use strict';
    function nested() { return 'And so am I!'; }
    return "Hi!  I'm a strict mode function!  " + nested();
}
function notStrict() { return "I'm not strict."; }
```

代码片段来自 [Mozilla Developer Network](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Strict_mode)。

不过呢，ES6 里面通过 [let 关键词](https://www.thecodingdelight.com/javascript-es6-best-parts/#ftoc-heading-7)提供了块作用域的特性。

现在，来看一段简单代码，看下 this 在严格模式和非严格模式下会怎么表现。在继续之前，请将下面的代码运行一下。

```
(function() {
    "use strict";
    console.log(this);
})();
(function() {
    // 不使用严格模式
    console.log(this);
})();
```

正如你看到的，`this` 在严格模式下指向 `undefined`。相对的，非严格模式下 `this` 指向全局变量 `window`。大部分情况下，开发者使用 this ，并不希望它指向全局 window 对象。严格模式帮我们在使用 `this` 关键词时，尽量少做搬起石头砸自己脚的蠢事。

举个例子，如果全局的 window 对象刚好有一个 key 的名字和你希望访问到的对象的 key 相同，会怎样？上代码吧：

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

这段代码有两个问题。

1.  `this` 将不会指向 `item`。
2.  如果程序在非严格模式下运行，将不会有错误抛出，因为全局的 `window` 对象也有一个名为 `document` 的属性。

在这个简单示例中，因为代码较短也就不会形成大问题。

如果你是在生产环境像上面那样写，当用到 `getDoc` 返回的数据时，你将收获一堆难以定位的报错。如果你代码库比较大，对象间互动比较多，那问题就更严重了。

值得庆幸的是，如果我们是在严格模式下跑这段代码，由于 this 是 `undefined`，于是立刻就有一个报错抛给我们：

> `test.html:312 Uncaught TypeError: Cannot read property 'document' of undefined`
> `at getDoc (test.html:312)`
> `at test.html:316`
> `at test.html:317`

## 明确设置执行上下文

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
