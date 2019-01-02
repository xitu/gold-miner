> * 原文链接 : [A GENTLE INTRODUCTION TO FUNCTIONAL JAVASCRIPT: PART 1](http://jrsinclair.com/articles/2016/gentle-introduction-to-functional-javascript-intro/)
* 原文作者 : [James Sinclair](http://jrsinclair.com/about.html)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者: [Zhangjd](https://github.com/zhangjd)
* 校对者: [markzhai](https://github.com/markzhai), [sqrthree](https://github.com/sqrthree)

# 函数式 JavaScript 教程（一）

本文是介绍 JavaScript 函数式编程的四部分之首篇。在这篇文章里，我们来看一下那些让 JavaScript 适合作为函数式编程语言的组成部分，并探讨为什么函数式编程可能是有用的。

*   Part 1: [组成部分与动机](http://jrsinclair.com/articles/2016/gentle-introduction-to-functional-javascript-intro/)
*   Part 2: [处理数组和列表](http://jrsinclair.com/articles/2016/gentle-introduction-to-functional-javascript-arrays/)
*   Part 3: [生成函数的函数](http://jrsinclair.com/articles/2016/gentle-introduction-to-functional-javascript-functions/)
*   Part 4: [函数式风格编程](http://jrsinclair.com/articles/2016/gentle-introduction-to-functional-javascript-style/)

## 什么是函数？

函数式 JavaScript 因为什么而热门？为什么称之为_函数式_？那应该也不是任何一个选择写不良的或者非函数式js的人选择写它们的原因，函数式编程适合用在什么地方？为什么你会感到困扰？

对于我而言，学习函数式编程有点像 [得到了一个全能料理机](http://youtu.be/4yr_etbfZtQ):

*   它需要一点前期的学习成本;
*   之后你会开始告诉你的朋友和亲人们它有多酷炫;
*   他们会开始怀疑你是不是加入了某种邪教。

但是，函数式编程确实让某些任务变得轻松很多，它甚至可以自动化某些本来是无聊耗时的工作。

## 组成部分

在进入正题之前，我们先介绍一下 JavaScript 的那些让函数式编程成为可能的基本特征。在 JavaScript 中，有两个关键的组成部分：_变量_ 和 _函数_。变量有点像容器，我们可以把内容放进去，比如你可以这样写：

    var myContainer = "Hey everybody! Come see how good I look!";

这句话创建了一个名为 `myContainer` 的容器，并把一个字符串放了进去。

现在来看看函数，函数是一种封装若干指令，使其便于重复利用的方式；也可以理解为把若干事情先组织起来，使你不必立即想清楚一切。我们可以创建一个像这样的函数：

    function log(someVariable) {
        console.log(someVariable);
        return someVariable;
    }

然后这样调用：

    log(myContainer);
    // Hey everybody! Come see how good I look!

如果你熟悉 JavaScript，应该还知道我们可以像这样定义和调用函数：

    var log = function(someVariable) {
        console.log(someVariable);
        return someVariable;
    }

    log(myContainer);
    // Hey everybody! Come see how good I look!

认真观察下，当我们以这种方式定义函数时，看起来就像定义了一个 `log` 变量，并且把函数放进了这个变量，而这正是我们所做的。我们的 `log()` 函数确实是一个变量，这意味着我们可以对它做与其它变量一样的事情。

让我们试一试，能否把函数作为参数，传递给另一函数呢？

    var classyMessage = function() {
        return "Stay classy San Diego!";
    }

    log(classyMessage);
    // [Function]

嗯，这太小儿科了，换个花样试试：

    var doSomething = function(thing) {
        thing();
    }

    var sayBigDeal = function() {
        var message = "I'm kind of a big deal";
        log(message);
    }

    doSomething(sayBigDeal);
    // I'm kind of a big deal

现在你可能觉得这个结果没什么特别的，但对于计算机科学家而言就非常兴奋了。这种把函数放进变量的特性，有时候会被称为 “函数是 JavaScript 的一等公民” （functions are first class objects in JavaScript.）。这意味着大部分时候，可以把函数和其他数据类型（比如对象或字符串）等同对待。这个看起来小的特征可是相当的强大，不过在理解原因之前，我们需要先来介绍一下 DRY 原则。

## 不要重复你自己

程序员都喜欢提及 DRY 原则 - 不要重复你自己（Don't Repeat Yourself）。其思想就是，如果你需要多次进行相同的工作，那就把它们打包起来，放入到某种可重用的包装里（比如函数）。通过这种方式，一旦想要调整那个任务集，你就只需要改动一个地方。

看这个例子，我们使用了一个轮播库，创建三个轮播组件，并放到页面中：

    var el1 = document.getElementById('main-carousel');
    var slider1 = new Carousel(el1, 3000);
    slider1.init();

    var el2 = document.getElementById('news-carousel');
    var slider2 = new Carousel(el1, 5000);
    slider2.init();

    var el3 = document.getElementById('events-carousel');
    var slider3 = new Carousel(el3, 7000);
    slider3.init();

这段代码看起来有点重复，我们想要初始化页面中的轮播组件，而每个组件有一个特定的 ID。因此，让我们看看如何在一个函数中初始化轮播组件，并且为每一个组件 ID 调用该函数：

    function initialiseCarousel(id, frequency) {
        var el = document.getElementById(id);
        var slider = new Carousel(el, frequency);
        slider.init();
        return slider;
    }

    initialiseCarousel('main-carousel', 3000);
    initialiseCarousel('news-carousel', 5000);
    initialiseCarousel('events-carousel', 7000);

这段代码更加清晰和易于维护。我们需要遵循一个模式：当我们想要对不同的数据集合进行相同的操作时，只需把这些操作包装进函数中。但是，如果我们进行的操作不尽相同呢？

    var unicornEl = document.getElementById('unicorn');
    unicornEl.className += ' magic';
    spin(unicornEl);

    var fairyEl = document.getElementById('fairy');
    fairyEl.className += ' magic';
    sparkle(fairyEl);

    var kittenEl = document.getElementById('kitten');
    kittenEl.className += ' magic';
    rainbowTrail(kittenEl);

要重构这段代码就有一点棘手了，代码当中肯定有重复的行为，但是也为每个元素调用了不同的函数。我们可以把调用 `document.getElementById()` 和添加 `className` 打包到一个函数中，这样可以降低一点重复度：

    function addMagicClass(id) {
        var element = document.getElementById(id);
        element.className += ' magic';
        return element;
    }

    var unicornEl = addMagicClass('unicorn');
    spin(unicornEl);

    var fairyEl = addMagicClass('fairy');
    sparkle(fairyEl);

    var kittenEl = addMagicClass('kitten');
    rainbow(kittenEl);

但我们还能让代码更加 DRY，还记得 JavaScript 可以把函数作为参数传递给其它函数吗？

    function addMagic(id, effect) {
        var element = document.getElementById(id);
        element.className += ' magic';
        effect(element);
    }

    addMagic('unicorn', spin);
    addMagic('fairy', sparkle);
    addMagic('kitten', rainbow);

这段代码就简洁多了，也更易于维护。这种把函数作为变量并传递给另一函数的能力，为我们的代码提供了更多可能性。在下一节，我们会试着在数组中运用这种能力，让数组变得更加方便使用。

[阅读下一节…](http://jrsinclair.com/articles/2016/gentle-introduction-to-functional-javascript-arrays/)
