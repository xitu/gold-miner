>* 原文链接 : [Understanding JavaScript Promises, Pt. I: Background & Basics](https://scotch.io/tutorials/understanding-javascript-promises-pt-i-background-basics)
* 原文作者 : [Peleke Sengstacke](https://pub.scotch.io/@pelekes)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


## The Promised Land

[Native Promises](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise) are amongst the biggest changes ES2015 make to the JavaScript landscape. They eliminate some of the more substantial problems with callbacks, and allow us to write asynchronous code that more nearly abides by synchronous logic.

It's probably safe to say that promises, together with [generators](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/function*), represent the New Normal™ of asyc. Whether you use them or not, you've _got_ to understand them.

Promises feature a fairly simple API, but come with a bit of a learning curve. They can be conceptually exotic if you've never seen them before, but all it takes to wrap your head around them is a gentle introduction and ample practice.

By the end of this article, you'll be able to:

*   Articulate _why_ we have promises, and what problems they solve;
*   Explain _what_ promises are, from the perspective both of their _implementation_ and their _usage_; and
*   Reimplement common callback patterns using promises.

Oh, one note. The examples assume you're running Node. You can copy/paste the scripts manually, or [clone my repo](https://github.com/Peleke/promises/) to save the trouble.

Just clone it down and checkout the `Part_1` branch:

    git clone https://github.com/Peleke/promises/
    git checkout Part_1-Basics

. . . And you're good to go. The following is our outline for this path of promises:

*   The Problem with Callbacks
*   Promises: Definitions w/ Notes from the A+ Spec
*   Promises & Un-inversion of Control
*   Control Flow with Promises
*   Grokking `then`, `reject`, & `resolve`

## Asynchronicity

If you've spent any time at all with JavaScript, you've probably heard that it's [fundamentally _non-blocking_](https://developer.mozilla.org/en-US/docs/Web/JavaScript/EventLoop), or _asynchronous_. But what doe that mean, exactly?

### Sync & Async

**Synchronous code** runs _before_ any code that follows it. You'll also see the term **blocking** as a synonym for synchronous, since it _block_ the rest of the program from running until it finishes.

    // readfile_sync.js

    "use strict";

    // This example uses Node, and so won't run in the browser. 
    const filename = 'text.txt', 
           fs        = require('fs');

    console.log('Reading file . . . ');

    // readFileSync BLOCKS execution until it returns. 
    //   The program will wait to execute anything else until this operation finishes. 
    const file = fs.readFileSync(`${__dirname}/${filename}`); 

    // This will ALWAYS print after readFileSync returns. . . 
    console.log('Done reading file.');

    // . . . And this will ALWAYS print the contents of 'file'.
    console.log(`Contents: ${file.toString()}`); 

![Predictable results from readFileSync.](https://cdn.scotch.io/1/YFAlIhhTpyghE3mzYSXw_6203660244.png)

**Asynchronous code** is just the opposite: It allows the rest of the program to execute while it handles long-running operations, such as I/O or network operations. This is also called **non-blocking code**. Here's the asynchronous analogue of the above snippet:

    // readfile_async.js

    "use strict";

    // This example uses Node, so it won't run in the browser.
    const filename      = 'text.txt', 
            fs            = require('fs'),
            getContents = function printContent (file) {
            try {
              return file.toString();
            } catch (TypeError) {
              return file; 
            } 
          }

    console.log('Reading file . . . ');
    console.log("=".repeat(76));

    // readFile executes ASYNCHRONOUSLY. 
    //   The program will continue to execute past LINE A while 
    //   readFile does its business. We'll talk about callbacks in detail
    //   soon -- for now, just pay mind to the the order of the log
    //   statements.
    let file;
    fs.readFile(`${__dirname}/${filename}`, function (err, contents) {
      file = contents;
      console.log( `Uh, actually, now I'm done. Contents are: ${ getContents(file) }`);
    }); // LINE A

    // These will ALWAYS print BEFORE the file read is complete.

    // Well, that's both misleading and useless.
    console.log(`Done reading file. Contents are: ${getContents(file)}`); 
    console.log("=".repeat(76));

![Async I/O can make for confusing results.](https://cdn.scotch.io/1/eSFXleTTiVtdfMn2RFng_61ff5d552e.png)

The major advantage to synchronous code is that it's easy to read and reason about: Synchronous programs execute from top to bottom, and line _n_ finishes before line _n + 1_. Period.

The major disadvantage is that synchronous code is slow—often debilitatingly so. Freezing the browser for two seconds every time your user needs to hit the server makes for a lousy user experience.

And this, _mes amis_, is why JavaScript is non-blocking at the core.

### The Challenge of Asynchronicity

Going async buys us speed, but costs us linearity. Even the trivial script above demonstrates this. Note that:

1.  There's no way to know when `file` will be available, other than handing control to `readFile` and letting _it_ notify us when it's ready; and
2.  Our program no longer executes the way it reads, which makes it harder to reason about.

These problems alone are enough to occupy us for the rest of this article.

## Callbacks & Fallbacks

Let's strip our async `readFile` example down a bit.

    "use strict";

    const filename = 'throwaway.txt',
          fs       = require('fs');

    let file, useless;

    useless = fs.readFile(`${__dirname}/${filename}`, function callback (error, contents) {
      file = contents;
      console.log( `Got it. Contents are: ${contents}`);
      console.log( `. . . But useless is still ${useless}.` );
    });

    console.log(`File is ${undefined}, but that'll change soon.`);

Since `readFile` is non-blocking, it must return immediately for the program to continue to execute. Since _Immediately_ isn't enough time to perform I/O, it returns `undefined`, and we execute as much as we can until `readFile` finishes . . . Well, reading the file.

The question is, _how do we know when the read is complete_?

Unfortunately, _we_ can't. But `readFile` can. In the snippet above, we've passed `readFile` two arguments: A filename, and a function, called a **callback**, which we want to execute as soon as the read is finished.

In English, this reads something like: "`readFile`; see what's inside of `${__dirname}/${filename}`, and take your time. Once you know, run this `callback` with the `contents`, and let me know if there was an `error`."

The important thing to take away is that _we_ can't know when the file contents are ready: Only `readFile` can. That's why we hand it our callback, and trust _it_ to do the right thing with it.

This is the pattern for dealing with asynchronous functions in general: Call it with parameters, and pass it a callback to run with the result.

Callbacks are _a_ solution, but they're not perfect. Two bigger problems are:

1.  Inversion of control; and
2.  Complicated error handling.

#### Inversion of Control

The first problem is one of trust.

When we pass `readFile` our callback, we _trust_ it will call it. There is absolutely no guarantee it actually will. Nor is there any guarantee that, if it does call, that it will be with the right parameters, in the right order, the right number of times.

In practice, this obviously hasn't been fatal: We've written callbacks for twenty years without breaking the Internet. And, in this case, we know that it's probably safe to hand control to core Node code.

But handing control over mission-critical aspects of your application to a third party should feel risky, and has been the source of many a hard-to-squash [heisenbug](https://en.wikipedia.org/wiki/Heisenbug) in the past.

#### Implicit Error Handling

In synchronous code, we can use `try`/`catch`/`finally` to handle errors.

    "use strict";

    // This example uses Node, and so won't run in the browser. 
    const filename = 'text.txt', 
           fs        = require('fs');

    console.log('Reading file . . . ');

    let file;
    try {
      // Wrong filename. D'oh!
      file = fs.readFileSync(`${__dirname}/${filename + 'a'}`); 
      console.log( `Got it. Contents are: '${file}'` );
    } catch (err) {
      console.log( `There was a/n ${err}: file is ${file}` );
    }

    console.log( 'Catching errors, like a bo$.' );

Async code lovingly tosses that out the window.

    "use strict";

    // This example uses Node, and so won't run in the browser. 
    const filename = 'throwaway.txt', 
            fs       = require('fs');

    console.log('Reading file . . . ');

    let file;
    try {
      // Wrong filename. D'oh!
      fs.readFile(`${__dirname}/${filename + 'a'}`, function (err, contents) {
        file = contents;
      });

      // This shouldn't run if file is undefined
      console.log( `Got it. Contents are: '${file}'` );
    } catch (err) {
      // In this case, catch should run, but it never will.
      //   This is because readFile passes errors to the callback -- it does /not/
      //   throw them.
      console.log( `There was a/n ${err}: file is ${file}` );
    }

This doesn't work as expected. This is because the `try` block wraps `readFile`, _which will always return successfully with `undefined`_ . This means that `try` will _always_ complete without incident.

The only way for `readFile` to notify you of errors is to pass them to your callback, where we handle them ourselves.

    "use strict";

    // This example uses Node, and so won't run in the browser. 
    const filename = 'throwaway.txt',
            fs       = require('fs');

    console.log('Reading file . . . ');

    fs.readFile(`${__dirname}/${filename + 'a'}`, function (err, contents) {
      if (err) { // catch
        console.log( `There was a/n ${err}.` );
      } else   { // try
        console.log( `Got it. File contents are: '${file}'`);
      }
    });

This example isn't so bad, but propagating information about the error through large programs quickly beomes unwieldly.

Promises address both of these problems, and several others, by _un_inverting control, and "synchronizing" our asynchronous code so as to enable more familiar error handling.

## Promises

Imagine you just ordered the entire [You Don't Know JS](https://github.com/getify/You-Dont-Know-JS/blob/master/README.md#you-dont-know-js-book-series) catalog from O'Reilly. In exchange for your hard-earned cash, they send a receipt acknowledging that you'll receive a shiny new stack of books next Monday. Until then, you don't _have_ that new stack of books. But you can trust that you _will_, because they _promised_ to send it.

That promise is enough that, before they even arrive, you can plan to set aside time to read every day; agree to loan a few of the titles out to friends; and give your boss notice that you'll be too busy reading for a full week to come to the office. You don't need the books to make those plans—you just need to know you'll get them.

Of course, O'Reilly might tell you a few days later that they can't fill the order for whatever reason. At that point, you'll erase that block of daily reading time; let your friends <del>down</del> know the you won't receive the books, after all; and tell your boss you actually _will_ be reporting to work next week.

A **promise** is like that receipt. It's an object that stands in for a value that _is not ready yet_, but _will be ready later_—in other words, a _future value_. You treat the promise as if it were the value you're waiting for, and write your code as if you already had it.

In the event there's a hiccup, Promises handle the interrupted control flow internally, and allow you to use a special `catch` keyword to handle errors. It's a little different from the synchronous version, but nonetheless more familiar than coordinating multiple error handlers across otherwise uncoordinated callbacks.

And, since a promise _hands you_ the value when it's ready, _you_ decide what to do with it. This fixes the inversion of control problem: _You_ handle your application logic directly, without having to hand control to third parties.

### The Promise Life Cycle: A Brief Look at States

Imagine you've used a Promise to make an API call.

Since the server can't respond instantaneously, the Promise doesn't immediately contain its final value, nor will it be able to immediately report an error. Such a Promise is said to be **pending**. This is the case where you're waiting for your stack of books.

Once the server _does_ respond, there are two possible outcomes.

1.  The Promise gets the value it expected, in which case it is **fulfilled**. This is receiving your book order.
2.  In the event there's an error somewhere along the pipeline, the Promise is said to be **rejected**. This is the notification that you won't get your order.

Together, these are the three possible **states** a Promise can be in. Once a Promise is either fulfilled or rejected, it _cannot_ transition to any other state.

Now that the jargon is out of the way, let's see how we actually use these things.

## Fundamental Methods on Promises

To quote the [Promises/A+ spec](https://promisesaplus.com/):

> A promise represents the eventual result of an asynchronous operation. The primary way of interacting with a promise is through its `then` method, which registers callbacks to receive either a promise’s eventual value or the reason why the promise cannot be fulfilled.

This section will take a closer look at the basic usage of Promises:

1.  Creating Promises with the constructor;
2.  Handling success with `resolve`;
3.  Handling errors with `reject`; and
4.  Setting up control flow with `then` and `catch`.

In this example, we'll use Promises to clean up the `fs.readFile` code from above.

## Creating Promises

The most basic way to create a Promise is to use the constructor directly.

    'use strict';

    const fs = require('fs');

    const text = 
      new Promise(function (resolve, reject) {
          // Does nothing
      })

Note that we pass the Promise constructor a function as an argument. This is where we tell the Promise _how_ to execute the asynchronous operation; what to do when we get the value we expect; and what to do if we get an error. In particular:

1.  The `resolve` argument is _also_ a function, and encapsulates what we want to do when we receive the **expected value**. When we get that expected value (`val`), we call `resolve` with it: `resolve(val)`.
2.  The `reject` argument is _also_ a function, and represents what we want to do when we receive an **error**. If we get an error (`err`), we call `reject` with it: `reject(err)`.
3.  Finally, the function we pass to the Promise constructor handles the asynchronous code itself. If it returns as expected, we call `resolve` with the value we get back. If it throws an error, we call `reject` with the error.

Our running example is to wrap `fs.readFile` in a Promise. What should our `resolve` and `reject` look like?

1.  In the event of success, we want to `console.log` the file contents.
2.  In the event of error, we'll do the same thing: `console.log` the error.

That nets us something like this.

    // constructor.js

    const resolve = console.log, 
          reject = console.log;

Next, we need to fill out the function that we pass to the constructor. Remember, our task is to:

1.  Read a file, and
2.  If successful, `resolve` the contents;
3.  Else, `reject` with an error.

Thus:

    // constructor.js

    const text = 
      new Promise(function (resolve, reject) {
        // Normal fs.readFile call, but inside Promise constructor . . . 
        fs.readFile('text.txt', function (err, text) {
          // . . . Call reject if there's an error . . . 
          if (err) 
            reject(err);
          // . . . And call resolve otherwise.
          else
        // We need toString() because fs.readFile returns a buffer.
            resolve(text.toString());
        })
      })

With that, we're technically done: This code creates a Promise that does exactly what we want it to. But, if you run the code, you'll notice that it executes without printing a result or an error.

## She made a Promise, and then . . .

The problem is that we _wrote_ our `resolve` and `reject` methods, but didn't actually pass them to the Promise! For that, we need to introduce the basic function for setting up Promise-based control-flow: `then`.

Every Promise has a method, called `then`, which accepts two functions as arguments: `resolve`, and `reject`, _in that order_. Calling `then` on a Promise and passing it these functions allows the function you passed to the constructor to access them.

    // constructor.js

    const text = 
      new Promise(function (resolve, reject) {
        fs.readFile('text.txt', function (err, text) {
          if (err) 
            reject(err);
          else
            resolve(text.toString());
        })
      })
      .then(resolve, reject);

With that, our Promise reads the file, and calls the `resolve` method we wrote before upon success.

It's also crucial to remember that `then` **always returns a Promise object**. That means you can chain several `then` calls to create complex and synchronous-looking control flows over asynchronous operations. We'll dig into this in much more detail in the next installment, but the `catch` example in the next subsection gives a taste as to what this looks like.

## Syntactical Sugar for Catching Errors

We passed `then` two functions: `resolve`, which we call in the event of success; and `reject`, which we call in the event of error.

Promises also expose a function similar to `then`, called `catch`. It accepts a reject handler as its single argument.

Since `then` always returns a Promise, in the example above, we could have _only_ passed `then` a resolve handler, and chained a `catch` with our reject handler afterwards.

    const text = 
      new Promise(function (resolve, reject) {
        fs.readFile('tex.txt', function (err, text) {
          if (err) 
            reject(err);
          else
            resolve(text.toString());
        })
      })
      .then(resolve)
      .catch(reject);

Finally, it's worth pointing out that `catch(reject)` is just syntactic sugar for `then(undefined, reject)`. So, we could also write:

    const text = 
      new Promise(function (resolve, reject) {
        fs.readFile('tex.txt', function (err, text) {
          if (err) 
            reject(err);
          else
            resolve(text.toString());
        })
      })
      .then(resolve)
      .then(undefined, reject);

. . . But that's much less readable.

## Wrapping Up

Promises are an indispensable tool in the async programming toolkit. They can be intimidating at first, but that's only because they're unfamiliar: Use them a few times, and they'll be as natural as `if`/`else`.

Next time, we'll get some practice by converting callback-based code to use Promises, and take a look at [Q](https://github.com/kriskowal/q), a popular Promises library.

Until then, read Domenic Denicola's [States and Fates](https://github.com/domenic/promises-unwrapping/blob/master/docs/states-and-fates.md) to master the terminology, and read Kyle Simpson's chapter on [Promises](https://github.com/getify/You-Dont-Know-JS/blob/master/async%20%26%20performance/ch3.md) from the book series we ordered earlier.

As always, drop questions in the comments below, or shoot them to me on Twitter ([@PelekeS](http://www.twitter.com/PelekeS)). I promise to respond!

