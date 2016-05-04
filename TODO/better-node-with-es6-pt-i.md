>* 原文链接 : [Better Node with ES6, Pt. I](https://scotch.io/tutorials/better-node-with-es6-pt-i)
* 原文作者 : [Peleke](https://github.com/Peleke)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


## Introduction

With the ES2015 spec finalized and Node.js shipping with a substantial subset of its functionailty, it's safe to say it: The Future is Upon Us.

. . . I've always wanted to say that.

But, it's true. The [V8 Engine is swiftly approaching spec-compliance](http://v8project.blogspot.com/2016/03/v8-release-50.html), and [Node ships with a good selection of ES2015 features ready for production](https://nodejs.org/en/docs/es6/). It's this latter list of features that I consider the Essentials™, as it represents the set of feature we can use without a transpiler like [Babel](https://babeljs.io/) or [Traceur](https://github.com/google/traceur-compiler).

This article will cover three of the more popular ES2015 features available in Node:

*   Block scoping with `let` and `const`;
*   Arrow functions; and
*   Shorthand properties & methods.

Let's get to it.

## Block Scope with `let` and `const`

**Scope** refers to where in your program your variables are visible. In other words, it's the set of rules that determines where you're allowed to use the variables you've declared.

We've mostly all heard the claim that JavaScript only creates new scopes inside of functions. While a good 98% of the useful scopes you've created were, in fact, function scopes, there are actually _three_ ways to create a new scope in JavaScript. You can:

1.  **Create a function**. You probably know this already.
2.  **Create a `catch` block**. [I'm not kidding](https://github.com/getify/You-Dont-Know-JS/blob/master/scope%20&%20closures/apB.md).
3.  **Create a code block**. If you're writing ES2015\. declaring variables with `let` or `const` within a code block restricts their visibility _to that block **only**_. This is called _block scoping_.

A _block_ is just a section of code wrapped in curly braces. `{ like this }`. They appear naturally around `if`/`else` statements and `try`/`catch`/`finally` blocks. You can also wrap arbitrary sections of code in braces to create a code block, if you want to take advantage of block-scoping.

Consider this snippet.

    // You have to use strict to try this in Node
    "use strict";

    var foo = "foo";
    function baz() {
        if (foo) {
            var bar = "bar";
            let foobar = foo + bar;
        }
        // Both foo and bar are visible here
        console.log("This situation is " + foo + bar + ". I'm going home.");

        try {
            console.log("This log statement is " + foobar + "! It threw a ReferenceError at me!");
        } catch (err) {
            console.log("You got a " + err + "; no dice.");
        }

        try {
            console.log("Just to prove to you that " + err + " doesn't exit outside of the above `catch` block.");
        } catch (err) {
            console.log("Told you so.");
        }
    }

    baz();

    try {
        console.log(invisible);
    } catch (err) {
        console.log("invisible hasn't been declared, yet, so we get a " + err);
    }
    let invisible = "You can't see me, yet"; // let-declared variables are inaccessible before declaration

A few things to note.

*   Notice that `foobar` isn't visible outside of the `if` block, because we declared it with `let`;
*   We can use `foo` anywhere, because we defined it as a `var` in the global scope; and
*   We can use `bar` anywhere inside of `baz`, because `var`-declared variables are accessible throughout the entirety of the scope they're defined.
*   We can't use `let` or `const`-declared variables before we've defined them. In other words, they're not hoisted by the compiler, as `var`-declarations are.

The `const` keyword behaves similarly to `let`, with two differences.

1.  You _must_ assign a value to a const-declared variable when you create it. You can't create it first and assign it later.
2.  You _cannot_ change the vaue of a `const`-declared variable after you create it. If you try, you'll get a `TypeError`.

### `let` & `const`: Who Cares?

Since we've gotten by just fine with `var` for a good twenty years, now, you might be wondering if we _really_ need new variables.

Good question. The short answer -- no. Not _really_. But there are a few good reasons to use `let` and `const` where possible.

*   Neither `let` nor `const`-declared variables are hoisted to the top of their scopes, which can make for more readable, less confusing code.
*   They limit your variables' visibility as much as possible, which helps prevent confusing namespace collisions.
*   It's easier to reason about programs that reassign variables only when absolutely necesary. `const` helps enforce immutable variable references.

Another use case is that of `let` in `for` loops.

    "use strict";

    var languages = ['Danish', 'Norwegian', 'Swedish'];

    // Pollutes global namespace. Ew!
    for (var i = 0; i < languages.length; i += 1) {
        console.log(`${languages[i]} is a Scandinavian language.`);
    }

    console.log(i); // 4

    for (let j = 0; j < languages.length; j += 1) {
        console.log(`${languages[j]} is a Scandinavian language.`);
    }

    try {
        console.log(j); // Reference error
    } catch (err) {
        console.log(`You got a ${err}; no dice.`);
    }

Using `var` to declare the counter in a `for` loop doesn't _actually_ keep the counter local to the loop. Using `let` instead does.

`let` also has the major advantage of rebinding the loop variable on every iteration, so each loop gets its _own_ copy, rather than sharing the globally-scoped variable.

    "use strict";

    // Simple & Clean
    for (let i = 1; i < 6; i += 1) {
        setTimeout(function() {
            console.log("I've waited " + i + " seconds!");
        }, 1000 * i);
    }

    // Totally dysfunctional
    for (var j = 0; j < 6; j += 1) {
            setTimeout(function() {
            console.log("I've waited " + j + " seconds for this!");
        }, 1000 * j);
    }

The first loop does what you think it does. The bottom one prints "I've waited 6 seconds!", every second.

Pick your poison.

## The Quirks of Dynamic `this`

JavaScript's `this` keyword is notorious for doing basically everything except for you want it to.

The truth is, the [rules are really quite simple](https://github.com/getify/You-Dont-Know-JS/tree/master/this%20%26%20object%20prototypes). Regardless, there are situations where `this` can encourage awkward idioms.

    "use strict";

    const polyglot = {
        name : "Michel Thomas",
        languages : ["Spanish", "French", "Italian", "German", "Polish"],
        introduce : function () {
            // this.name is "Michel Thomas"
            const self = this;
            this.languages.forEach(function(language) {
                // this.name is undefined, so we have to use our saved "self" variable 
                console.log("My name is " + self.name + ", and I speak " + language + ".");
            });
        }
    }

    polyglot.introduce();

Inside of `introduce`, `this.name` is `undefined`. Right outside of the callback, in our `forEach` loop, it refers to the `polyglot` object. Often, what we want in cases like this is for `this` within our inner function to refer to the same object that `this` refers to in the outer function.

The problem is that functions in JavaScript always define their own `this` values upon invocation, according to a [well-established set of four rules](https://github.com/getify/You-Dont-Know-JS/blob/master/this%20&%20object%20prototypes/ch2.md). This mechanim is known as _dynamic `this`_.

Not a single one of these rules involves looking up what `this` means "nearby"; there is no conceivable way for the JavaScript engine to define `this` based on its meaning within a surrounding scope.

This all means that, when the engine looks up the value of `this`, it _will_ find one, but it will _not_ be the same as the value outside of the callback. There are two traditional workarounds to the problem.

1.  Save `this` in the outer function to a variable, usually called `self`, and use that within the inner function; or
2.  Call [`bind`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/bind) on the inner function to permanently set its `this` value.

These methods work, but they can be noisy.

If, on the other hand, inner functions did _not_ set their own `this` values, JavaScript would look up the value of `this` just as it would look up the value of any other variable: By stepping through parent scopes until it finds one with the same name. That would let us use the value of `this` from "nearby" source code, and is known as _lexical `this`_.

Quite a bit of code would be quite a bit cleaner if we had such a feature, don't you think?

### Lexical `this` with Arrow Functions

With ES2015, we do. Arrow functions do _not_ bind a `this` value, allowing us to take advantage of lexical binding of the `this` keyword. We can refactor the broken code from above like this:

    "use strict";

    let polyglot = {
        name : "Michel Thomas",
        languages : ["Spanish", "French", "Italian", "German", "Polish"],
        introduce : function () {
            this.languages.forEach((language) => {
                console.log("My name is " + this.name + ", and I speak " + language + ".");
            });
        }
    }

. . . And all would work as expected.

Arrow functions have a few types of syntax.

    "use strict";

    let languages = ["Spanish", "French", "Italian", "German", "Polish"];

    // In a multiline arrow function, you must use curly braces, 
    //  and you must include an explicit return statement.
    let languages_lower = languages.map((language) => {
        return language.toLowerCase()
    });

    // In a single-line arrow function, curly braces are optional,
    //   and the function implicitly returns the value of the last expression.
    //   You can include a return statement if you'd like, but it's optional.
    let languages_lower = languages.map((language) => language.toLowerCase());

    // If your arrow function only takes one argument, you don't need to wrap it in
    //   parentheses. 
    let languages_lower = languages.map(language => language.toLowerCase());

    // If your function takes multiple arguments, you must wrap them in parentheses.
    let languages_lower = languages.map((language, unused_param) => language.toLowerCase());

    console.log(languages_lower); // ["spanish", "french", "italian", "german", "polish"]

    // Finally, if your function takes no arguments, you must include empty parentheses before the arrow.
    (() => alert("Hello!"))();

[The MDN docs on arrow functions](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Arrow_functions) are great for reference.

## Shorthand Properties & Methods

ES2015 also gives us a few new ways to define properties and methods on objects.

### Shorthand Methods

In JavaScript, a _method_ is a property on an object that has a function value:

    "use strict";

    const myObject = {
        const foo = function () {
            console.log('bar');
        },
    }

In ES2015, we can simply write:

    "use strict";

    const myObject = {
        foo () {
            console.log('bar');
        },
        * range (from, to) {
            while (from < to) {
                if (from === to)
                    return ++from;
                else
                    yield from ++;
            }
        }
    }

Note that you can use generators to define methods, too. All you need to do is prepend the function's name with an asterisk (*).

These are called _method definitions_. They're similar to traditional functions-as-properties, but have a few key differences:

*   You can _only_ call `super` from a _method definition_;
*   You are _not_ allowed to call a method definition with `new`.

I'll cover classes and the `super` keyword in a later article. If you just can't wait, [Exploring ES6](http://exploringjs.com/es6/ch_classes.html) has all the goodies.

### Shorthand & Computed Properties

ES6 also introduces _shorthand_ and _computed properties_.

If the name of your object's keys are identical to the variables naming their values, you can initialize your object literal with just the _variable names_, rather than defining it as a redundant key-value pair.

    "use strict";

    const foo = 'foo';
    const bar = 'bar';

    // Old syntax
    const myObject = {
        foo : foo,
        bar : bar
    };

    // New syntax
    const myObject = { foo, bar }

Both syntaxes create an object with `foo` and `bar` keys that refer to the values of the `foo` and `bar` variables. The latter approach is semantically identical; it's just syntactically sweeter.

I often take advantage of shorthand properties to write succinct definitions of public APIs when using the [revealing module pattern](https://addyosmani.com/resources/essentialjsdesignpatterns/book/#revealingmodulepatternjavascript).

    "use strict";

    function Module () {
        function foo () {
            return 'foo';
        }

        function bar () {
            return 'bar';
        }

        // Write this:
        const publicAPI = { foo, bar }

        /* Not this:
        const publicAPI =  {
           foo : foo,
           bar : bar
        } */ 

        return publicAPI;
    };

Here, we create and return a `publicAPI` object, whose key `foo` refers to the `foo` method, and whose key `bar` refers to the `bar` method.

### Computed Property Names

This is a _bit_ of a niche case, but ES6 also allows you to use expressions as property names.

    "use strict";

    const myObj = {
      // Set property name equal to return value of foo function
        [foo ()] () {
          return 'foo';
        }
    };

    function foo () {
        return 'foo';
    }

    console.log(myObj.foo() ); // 'foo'

According to Dr. Raushmayer in [Exploring ES6](http://exploringjs.com/), the main use case for this feature is in setting property names equal to [Symbol](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Symbol) values.

### Getter & Setter Methods

Finally, I'd like to remind you of the `get` and `set` methods, which have been around since ES5\.

    "use strict";

    // Example adapted from MDN's page on getters
    //   https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/get
    const speakingObj = {
        // Track how many times "speak" has been called 
        words : [],

        speak (word) {
            this.words.push(word);
            console.log('speakingObj says ' + word + '!');
        },

        get called () {
            // Returns latest word
            const words = this.words;
            if (!words.length)
                return 'speakingObj hasn\'t spoken, yet.';
            else
                return words[words.length - 1];
        }
    };

    console.log(speakingObj.called); // 'speakingObj hasn't spoken, yet.'

    speakingObj.speak('blargh'); // 'speakingObj says blargh!'

    console.log(speakingObj.called); // 'blargh'

There are a few things to keep in mind when using getters:

*   Getters can't take arguments;
*   You can't have properties with the same names as your getter functions;
*   You can create a getter dynamically by using `Object.defineProperty(OBJECT, "property name", { get : function () { . . . } })`

As an example of this last point, we could have defined the above getter this way:

    "use strict";

    const speakingObj = {
        // Track how many times "speak" has been called 
        words : [],

        speak (word) {
            this.words.push(word);
            console.log('speakingObj says ' + word + '!');
        }
    };

    // This is just to prove a point. I definitely wouldn't write it this way.
    function called () {
        // Returns latest word
        const words = this.words;
        if (!words.length)
            return 'speakingObj hasn\'t spoken, yet.';
        else
            return words[words.length - 1];
    };

    Object.defineProperty(speakingObj, "called", get : getCalled ) 

In addition to getters, we have setters. Unsurprsingly, they set properties on an object with custom logic.

    "use strict";

    // Create a new globetrotter!
    const globetrotter = {
        // Language spoken in the country our globetrotter is currently in
        const current_lang = undefined,

        // Number of countries our globetrotter has travelled to
        let countries = 0,

        // See how many countries we've travelled to
        get countryCount () {
            return this.countries;
        }, 

        // Reset current language whenever our globe trotter flies somewhere new
        set languages (language) {
            // Increment number of coutnries our globetrotter has travelled to
            countries += 1;

            // Reset current language
            this.current_lang = language; 
        };
    };

    globetrotter.language = 'Japanese';
    globetrotter.countryCount(); // 1

    globetrotter.language = 'Spanish';
    globetrotter.countryCount(); // 2

Everything we said about getters above applies to setters as well, with one difference:

*   Unlike getters, which can take _no_ arguments, setters _must_ take _exactly one_ argument

Breaking either of these rules throws an error.

Now that Angular 2 is bringing TypeScript and the `class` keyword to the fore, I expect `get` and `set` to spike in popularity. . . But I kind of hope they don't.

## Conclusion

Tomorrow's JavaScript is happening today, and it's high time to get a grip on what it has to offer. In this article, we've looked at three of the more popular features from ES2015:

*   Block scoping with `let` and `const`;
*   Lexical scoping of `this` with arrow functions;
*   Shorthand object properties and methods, plus a review of getter and setter functions.

For detailed thoughts on `let`, `const`, and the notion of block scoping, read [Kyle Simpson's take on block scoping](https://davidwalsh.name/for-and-against-let). If all you need is a quick practical reference, check the MDN pages for [`let`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/let) and [`const`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/const).

Dr Rauschmayer has a [wonderful article on arrow functions and lexical `this`](http://www.2ality.com/2012/04/arrow-functions.html). It's great reading if you want a bit more detail than I had room to cover here.

Finally, for an exhaustive take on all of what we've talked about here -- and a great deal more -- Dr Rauschmayer's book, [Exploring ES6](http://exploringjs.com/), is the best all-in-one reference the web has to offer.

What ES2015 feature are you most excited about? Is there anything you'd like to see covered in a future article? Let me know in the comments below, or hit me on Twitter ([@PelekeS](http://twitter.com/PelekeS)) -- I'll do my best to get back to everyone individually.

