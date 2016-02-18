> * 原文链接 : [A GENTLE INTRODUCTION TO FUNCTIONAL JAVASCRIPT: PART 1](https://infinum.co/the-capsized-eight/articles/top-five-android-libraries-every-android-developer-should-know-about-v2015)
* 原文作者 : [James Sinclair](http://jrsinclair.com/about.html)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者: 
* 校对者: 
* 状态: 待认领<https://github.com/xitu/gold-miner/issues/105>

# A GENTLE INTRODUCTION TO FUNCTIONAL JAVASCRIPT: PART 1

This is part one of a <strike>three</strike>four-part series introducing 'functional' programming in JavaScript. In this article we take a look at the building blocks that make JavaScript a 'functional' language, and examine why that might be useful.

*   Part 1: [Building blocks and motivation](/articles/2016/gentle-introduction-to-functional-javascript-intro/),
*   Part 2: [Working with Arrays and Lists](/articles/2016/gentle-introduction-to-functional-javascript-arrays/)
*   Part 3: [Functions for making functions](/articles/2016/gentle-introduction-to-functional-javascript-functions/)
*   Part 4: [Doing it with style](/articles/2016/gentle-introduction-to-functional-javascript-style/)

## What the Func?

What is all the hype about Functional JavaScript? And why is it called _functional_? It's not as though anyone sets to write _dys_functional or non-functioning Javascript. What is it good for? Why would you bother?

To me, learning functional programming is a little bit like [getting a Thermomix](http://youtu.be/4yr_etbfZtQ):

*   It takes a bit of up-front investment;
*   You'll start telling all your friends and family about it how awesome it is; and
*   They start to wonder if you've joined some kind of cult.

But, it does make certain tasks a whole lot easier. It can even automate certain things that would otherwise be fairly tedious and time-consuming.

## Building Blocks

Let's start with some of the basic features of JavaScript that make 'functional' programming possible, before we move on to why it's a good idea. In JavaScript we have two key building blocks: _variables_ and _functions_. Variables are sort-of like containers that we can put things in. You can create one like so:

    var myContainer = "Hey everybody! Come see how good I look!";

That creates a container called `myContainer` and sticks a string in it.

Now, a function, on the other hand, is a way to bundle up some instructions so you can use them again, or just keep things organised so you're not trying to think about everything all at once. One can create a function like so:

    function log(someVariable) {
        console.log(someVariable);
        return someVariable;
    }

And you can call a function like this:

    log(myContainer);
    // Hey everybody! Come see how good I look!

But, the thing is, if you've seen much JavaScript before, then you'll know that we could also write and call our function like this:

    var log = function(someVariable) {
        console.log(someVariable);
        return someVariable;
    }

    log(myContainer);
    // Hey everybody! Come see how good I look!

Let's look at this carefully. When we write the function definition this way, it looks like we've created a variable called `log` and stuck a function in it. And that's exactly what we have done. Our `log()` function _is_ a variable; which means that we can do the same things with it that we can do with other variables.

Let's try it out. Could we, maybe, pass a function as a parameter to another function?

    var classyMessage = function() {
        return "Stay classy San Diego!";
    }

    log(classyMessage);
    // [Function]

Hmmmm. Not super useful. Let's try it a different way.

    var doSomething = function(thing) {
        thing();
    }

    var sayBigDeal = function() {
        var message = "I'm kind of a big deal";
        log(message);
    }

    doSomething(sayBigDeal);
    // I'm kind of a big deal

Now, this might not be terribly exciting to you, but it gets computer scientists quite fired up. This ability to put functions into variables is sometimes described by saying “functions are first class objects in JavaScript.” What that means is just that functions (mostly) aren't treated differently to other data types like objects or strings. And this one little feature is surprisingly powerful. To understand why though, we need to talk about DRY code.

## Don't Repeat Yourself

Programmers like to talk about the DRY principle—Don't Repeat Yourself. The idea is that if you need to do the same set of tasks many times, bundle them up into some sort of re-usable package (like a function). This way, if you ever need to tweak that set of tasks, you can do it in just one spot.

Let's look at an example. Say we wanted to put three carousels on a page using a carousel library (an imaginary library for the sake of example):

    var el1 = document.getElementById('main-carousel');
    var slider1 = new Carousel(el1, 3000);
    slider1.init();

    var el2 = document.getElementById('news-carousel');
    var slider2 = new Carousel(el1, 5000);
    slider2.init();

    var el3 = document.getElementById('events-carousel');
    var slider3 = new Carousel(el3, 7000);
    slider3.init();

This code is somewhat repetitive. We want to initialise a carousel for the elements on the page, each one with a specific ID. So, let's describe how to initialise a carousel in a function, and then call that function for each ID.

    function initialiseCarousel(id, frequency) {
        var el = document.getElementById(id);
        var slider = new Carousel(el, frequency);
        slider.init();
        return slider;
    }

    initialiseCarousel('main-carousel', 3000);
    initialiseCarousel('news-carousel', 5000);
    initialiseCarousel('events-carousel', 7000);

This code is clearer and easier to maintain. And we have a pattern to follow: when we have the same set of actions we want to take on different sets of data, we can wrap those actions up in a function. But what about if we have a pattern where the action changes?

    var unicornEl = document.getElementById('unicorn');
    unicornEl.className += ' magic';
    spin(unicornEl);

    var fairyEl = document.getElementById('fairy');
    fairyEl.className += ' magic';
    sparkle(fairyEl);

    var kittenEl = document.getElementById('kitten');
    kittenEl.className += ' magic';
    rainbowTrail(kittenEl);

This code is a little bit trickier to refactor. There is definitely a repeated pattern, but we're calling a different function for each element. We could get part of the way there by wrapping the `document.getElementById()` call and adding the `className` up into a function. That would save us a little bit of repetition:

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

But we can make this even more DRY, if we remember that JavaScript lets us pass functions as parameters to other functions:

    function addMagic(id, effect) {
        var element = document.getElementById(id);
        element.className += ' magic';
        effect(element);
    }

    addMagic('unicorn', spin);
    addMagic('fairy', sparkle);
    addMagic('kitten', rainbow);

This is much more concise. And easier to maintain. The ability to pass functions around as variables opens up a lot of possibilities. In the next part we'll look at using this ability to make working with arrays more pleasant.

[Read on…](http://jrsinclair.com/articles/2016/gentle-introduction-to-functional-javascript-arrays/)
