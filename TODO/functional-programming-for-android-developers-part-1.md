> * 原文地址：[Functional Programming for Android developers — Part 1](https://medium.com/@anupcowkur/functional-programming-for-android-developers-part-1-a58d40d6e742#.it6ndspj6)
* 原文作者：[Anup Cowkur](https://medium.com/@anupcowkur)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： 
* 校对者：

---

# Functional Programming for Android developers — Part 1

![](https://cdn-images-1.medium.com/max/2000/1*DCzEYU60hk2pO7WCJj3GoQ.jpeg)

Lately, I’ve been spending a lot of time learning [Elixir](http://elixir-lang.org/) — An awesome functional programming language that is friendly to beginners.

This got me thinking. Why not use some of the concepts and techniques from the functional world in Android programming?

When most people hear the term *Functional Programming,* they think of Hacker News posts yammering on about Monads, Higher Order Functions and Abstract Data Types. It seems to be a mystical universe far removed from the toils of the daily programmer, reserved only for mightiest hackers descended from the the realm of Númenor.

Well, *screw that* ! I’m here to tell you that you too can learn it. You too can use it. You too can create beautiful apps with it. Apps that have elegant, readable codebases and have fewer errors.

Welcome to Functional Programming(FP) for Android developers. In this series, we’re gonna learn the fundamentals of FP and how we can use them in good old Java. The idea is to keep the concepts grounded in practicality and avoid as much academic jargon as possible.

FP is a huge subject. We’re gonna learn only the concepts and techniques that are useful to writing Android code. We might visit a few concepts that we can’t directly use for the sake of completeness but I’ll try to keep the material as relevant as possible.

Ready? Let’s go.

### What is Functional Programming and why should I use it?

Good question. The term *Functional programming* is an umbrella for a range of programming concepts which the moniker doesn’t quite do justice to. At it’s core, It’s a style of programming that treats programs as evaluation of mathematical functions and avoids *mutable state* and *side effects* (we’ll talk about these soon enough).

At it’s core, FP emphasises :

- **Declarative code** — Programmers should worry about the *what* and let the compiler and runtime worry about the *how* ***.***
- **Explicitness** — Code should be as obvious as possible. In particular, Side effectsare to be isolated to avoid surprises. Data flow and error handling are explicitly defined and constructs like *GOTO* statements and *Exceptions* are avoided since they can put your application in unexpected states.
- **Concurrency** — Most functional code is concurrent by default because of a concept known as *functional purity*. The general agreement seems to be that this trait in particular is causing functional programming to rise in popularity since CPU cores aren’t getting faster every year like they used to (see [Moore’s law](https://en.wikipedia.org/wiki/Moore%27s_law)) and we have to make our programs more concurrent to take advantage of multi-core architectures.
- **Higher Order Functions** — Functions are first class members just like all the other language primitives. You can pass functions around just like you would a string or an int.
- **Immutability** — Variables are not to be modified once they’re initialised. Once a thing is created, it is that thing forever. If you want it to change, you create a new thing. This is another aspect of explicitness and avoiding side effects. If you know that a thing cannot change, you have much more confidence about its state when you use it.

Declarative, Explicit and Concurrent code that is easier to reason about and is designed to avoid surprises? I hope I’ve piqued your interest.

In this first part of the series, let’s start with some of the most fundamental concepts in FP : *Purity*, *Side effects* and *Ordering*.

### Pure functions

A function is pure if its output depends only on its input and has no *side effects* (we’ll talk about the side effects bit right after this). Let’s see an example, shall we?

Consider this simple function that adds two numbers. It reads one number from a file and the other number is passed in as a parameter.

    int add(int x) {
        int y = readNumFromFile();
        return x + y;
    }

This function’s output is not dependent solely on its input. Depending on what *readNumFromFile()* returns, it can have different outputs for the same value of *x*. This function is said to be *impure*.

Let’s convert it into a pure function.

    int add(int x, int y) {
        return x + y;
    }

Now the function’s output is only dependent on its inputs. For a given *x* and *y,* The function will always return the same output. This function is now said to be *pure*. Mathematical functions also operate in the same way. A mathematical functions output only depends on its inputs — This is why functional programming is much closer to math than the usual programming style we are used to.

P.S. An empty input is still an input. If a function takes no inputs and returns the same constant every time, it’s still pure.

P.P.S. The property of always returning the same output for a given input is also known as *referential transparency* and you might see it used when talking about pure functions.

### Side effects

Let’s explore this concept with the same addition function example. We’ll modify the addition function to also write the result to a file.

    int add(int x, int y) {
        int result = x + y;
        writeResultToFile(result);
        return result;
    }

This function is now writing the result of the computation to a file. i.e. it is now modifying the state of the outside world. This function is now said to have a *side effect* and is no longer a pure function.

Any code that modifies the state of the outside world — changes a variable, writes to a file, writes to a DB, deletes something etc — is said to have a side effect.

Functions that have side effects are avoided in FP because they are no longer pure and depend on *historical context*. The context of the code is not self contained. This makes them much harder to reason about.

Let’s say you are writing a piece of code that depends on a cache. Now the output of your code depends on whether someone wrote to the cache, what was written in it, when it was written, if the data is valid etc. You can’t understand what your program is doing unless you understand all the possible states of the cache it depends on. If you extend this to include all the other things your app depends on — network, database, files, user input and so on, it becomes very hard to know what exactly is going on and to fit it all into your head at once.

Does this means we don’t use network, databases and caches then? Of course not. At the end of the execution, you want the app to do something. In the case of Android apps, it usually means updating the UI so that the user can actually get something useful from our app.

FP’s greatest idea is not to completely forego side effects but to contain and isolate them. Instead of having our app littered with functions that have side effects, we push side effects to the edges of our system so they have as little impact as possible, making our app easier to reason about. We’ll talk about this in detail when we explore a *functional architecture* for our apps later in the series.

### Ordering

If we have a bunch of pure functions that have no side effects, then the order in which they are executed becomes irrelevant.

Let’s say we have a function that calls 3 pure functions internally:

    void doThings() {
        doThing1();
        doThing2();
        doThing3();
    }

We know for sure that these functions don’t depend on each other (since the output of one is not the input of another) and we also know that they won’t change anything in the system (since they are pure). This makes the order in which they are executed completely interchangeable.

The order of execution can be re-shuffled and optimised for independent pure functions. Note that if the input of *doThing2()* were the result of *doThing1()* then these would have to be executed in order, but *doThing3()* could still be re-ordered to execute before *doThing1().*

What does this ordering property get us though? *Concurrency,* that’s what! We can run these functions on 3 separate CPU cores without worrying about screwing anything up!

In many cases, compilers in advanced pure functional languages like [Haskell](https://www.haskell.org/) can tell by formally analysing your code whether it’s concurrent or not, and can stop you from shooting yourself in the foot with deadlocks, race conditions and the like. These compilers can theoretically also auto-parallelise your code (this doesn’t actually exist in any compiler I know of at the moment but research is ongoing).

Even if your compiler is not looking at this stuff, as a programmer, it’s great to be able to tell whether your code is concurrent just by looking at the function signatures and avoid nasty threading bugs trying to parallelise imperative code which might be full of hidden side effects.

### Summary

I hope this first part has intrigued you about FP. Pure, Side effect free functions make it much easier to reason about code and are the first step to achieving concurrency.

Before we get to concurrency though, we have to learn about *immutability*. We’ll do just that in Part 2 of this series and see how pure functions and immutability can help us write simple and easy to understand concurrent code without resorting to locks and mutexes.