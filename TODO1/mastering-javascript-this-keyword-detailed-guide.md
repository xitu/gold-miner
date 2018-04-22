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

先前假定大家都对执行上下文不熟，于是我们聊了很多关于执行上下文和 this 的知识。

让人欢喜让人忧的是，在 JavaScript 中通过使用内置的特性开发者就可以直接操作**执行上下文**了。这些特性包括：

*   [bind()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/bind)：不需要执行函数就可以将 `this` 的值准确设置到你选择的一个对象上。还可以通过逗号隔开传递多个参数，如 `func.bind(this, param1, param2, ...)` 。
*   [apply()](https://www.w3schools.com/js/js_function_apply.asp)：将 `this` 的值准确设置到你选择的一个对象上。第二个参数是一个数组，数组的每一项是你希望传递给函数的参数。最后，**执行函数**。
*   [call()](https://docs.microsoft.com/en-us/scripting/javascript/reference/call-method-function-javascript)：将 `this` 的值准确设置到你选择的一个对象上，然后想 `bind` 一样通过逗号分隔传递多个参数给函数。如：`print.call(this, param1, param2, ...)`。最后，**执行函数**。

上面提到的所有内置函数都有一个共同点，就是它们都是用来将 `this` 关键词指向到其他地方。这些特性可以让我们玩一些骚操作。只是呢，这个话题太广了都够写好几篇文章了，所以简洁起见，这篇文章我不打算展开它的实际应用。

**重点**：上面那三个函数，只有 `bind()` 在设置好 `this` 关键词后不立刻执行函数。

## 什么时候用 bind、call 和 apply

你可能在想：现在已经很乱了，学习所有这些的目的是什么？

首先，你会看到 bind、call 和 apply 这几个函数到处都会用到，特别是在一些大型的库和框架。如果你没理解它做了些什么，那可怜的你就只用上了 JavaScript 提供的强大能力的一小部分而已。

如果你不想了解一些可能的用法而想立刻读下去，当然了，你可以直接跳过这节，没关系。

下面列出来的应用场景都是一些具有深度和广度的话题（一篇文章基本上是讲不完的），所以我放了一些链接供你深度阅读用。未来我可能会在这篇终极指南里面继续添加新的小节，这样大家就可以一次看过瘾。

1.  [方法借用](https://medium.com/@thejasonfile/borrowing-methods-from-a-function-in-javascript-713a0beed40d)
2.  [柯里化](https://www.sitepoint.com/currying-in-functional-javascript/)
3.  [偏函数应用](http://benalman.com/news/2012/09/partial-application-in-javascript/#partial-application)
4.  [依赖注入](http://krasimirtsonev.com/blog/article/Dependency-injection-in-JavaScript)

如果我漏掉了其他实践案例，请留言告知。我会经常来优化这篇指南，这样你作为读者就可以读到最丰富的内容。

> 阅读高质量的开源代码可以升级你的知识和技能。

讲真，你会在一些开源代码上看到 this 关键词、call、apply 和 bind 的实际应用。我会将这块结合着其他能[帮你成为更好的程序员](https://www.thecodingdelight.com/become-better-programmer/)的方法一起讲。

在我看来，开始阅读最好的开源代码是 [underscore](http://underscorejs.org/)。它并不像其他开源项目，如 [d3](https://github.com/d3/d3)，那样铁板一块，因而它是教学用的最佳选择。另外，它代码简洁，文档详细，编码风格也是相当容易学习。

## JavaScript 的 `this` 和 bind

前面提到了，`bind` 允许你明确设定 this 的指向而不用实际去执行函数。这里是一个简单示例：

```
var bobObj = {
    name: "Bob"
};
function print() {
    return this.name;
}
// 将 this 明确指向 "bobObj"
var printNameBob = print.bind(bobObj);
console.log(printNameBob());    // this 会指向 bob，于是输出结果是 "Bob"
```

在上面的示例中，如果你把 bind 那行去掉，那 this 将会指向全局 `window` 对象。

这好像很蠢，但在你想将 `this` 绑定到具体对象前你就必须用 `bind` 来绑定。在某些场景下，我们可能想从另一个对象中借用一些方法。举个例子，

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
// 在 obj1 中借用 obj2 的方法
var getSecondData = obj2.printSecondData.bind(obj1);
console.log(getSecondData());   // 输出 2
```

在这个代码片段里，`obj2` 有一个名为 `printSecondData` 的方法，而我们想将这个方法借给 `obj1`。在下一行

```
var getSecondData = obj2.printSecondData.bind(obj1);
```

通过使用 bind ，我们让 `obj1` 可以访问 `obj2` 的 `printSecondData` 方法。

### 练习

在下面的代码中

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

怎么让 this 关键词指向 `object`。提示：你并不需要重写 `this.data.forEach`。

##### 答案

在上一节中，我们了解了执行上下文。如果你对匿名函数调用那部分看得够细心，你就知道它并不会作为某个对象的方法被调用。因此，`this` 关键词指向了全局 `window` 对象。

于是我们需要将 object 作为上下文绑定到匿名函数上，使得里面的 this 指向 `object`。现在，`double` 函数跑起来时，是 `object` 调用了它，那么 `double` 里面的 `this` 指向 `object`。

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

那，如果我们像下面这样做呢？

```
var double = object.double;
double();   // ？？
```

`double()` 的调用上下文是什么？是全局上下文。于是，我们就会看到下面的报错。

> `Uncaught TypeError: Cannot read property 'forEach' of undefined`
> `at double (test.html:282)`
> `at test.html:289`

所以，当我们用到 `this` 关键词时，就要小心在意我们调用函数的方式。我们可以在提供 API 给用户时固定 this 关键词，以此减少这种类型的错误。但请记住，这么做的代价是牺牲了灵活性，所以做决定前要考虑清楚。

```
var double = object.double.bind(object);
double();  // 不再报错
```

## JavaScript `this` 和 call

call 方法和 bind 很相似，但就如它名字所暗示的，`call` 会立刻呼起（执行）函数，这是两个函数的最大区别。

```
var item = {
    name: "I am"
};
function print() {
    return this.name;
}
// 立刻执行
var printNameBob = console.log(print.call(item));
```

`call`、`apply`、`bind` 大部分使用场景是重叠的。作为一个程序员最重要的还是先了解清楚这三个方法之间的差异，从而能根据它们的设计和目的的不同来选用。只要你了解清楚了，你就可以用一种更有创意的方式来使用它们，写出更独到精彩的代码。

在参数数量固定的场景，`call` 或 `bind` 是不错的选择。比如说，一个叫 `doLogin` 的函数经常是接受两个参数：`username` 和 `password`。在这个场景下，如果你需要将 this 绑定到一个特定的对象上，`call` 或 `bind` 会挺好用的。

### 如何使用 call

以前一个最常用的场景是把一个类数组对象，比如 `arguments` 对象，转化成数组。举个例子：

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

在上面的例子中，我们使用 call 将 `argument` 对象转化成一个数组。在下一个例子中，我们将会调用一个 `Array` 对象的方法，并将 argument 对象设置为方法的 this，以此来将传进来参数加在一起。

```
function add (a, b) { 
    return a + b; 
}
function sum() {
    return Array.prototype.reduce.call(arguments, add);
}
console.log(sum(1,2,3,4)); // 10
```

我们在一个类数组对象上调用了 reduce 函数。要知道 arguments 不是一个数组，但我们给了它调用 reduce 方法的能力。如果你对 reduce 感兴趣，可以在[这里了解更多](https://www.thecodingdelight.com/map-filter-reduce/)。

### 练习

现在是时候巩固下你新学到的知识。

1.  [document.querySelectorAll()](https://www.w3schools.com/jsref/met_document_queryselectorall.asp) 返回一个类数组对象 `NodeList`。请写一个函数，它接收一个 CSS 选择器，然后返回一个选择到的 DOM 节点数组。
2.  请写一个函数，它接收一个由键值对组成的数组，然后将这些键值对设置到 this 关键词指向的对象上，最后将该对象返回。如果 this 是 `null` 或 `undefined`，那就新建一个 `object`。示例：`set.call( {name: "jay"}, {age: 10, email: '[[email protected]](/cdn-cgi/l/email-protection)'}); // return {name: "jay", age: 10, email: '[[email protected]](/cdn-cgi/l/email-protection)'}`。

## JavaScript this 和 apply

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
