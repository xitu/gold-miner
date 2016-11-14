> * 原文地址：[6 of the Most Exciting ES6 Features in Node.js v6 LTS](https://nodesource.com/blog/six-of-the-most-exciting-es6-features-in-node-js-v6-lts?utm_source=nodeweekly&utm_medium=email)
* 原文作者：[Tierney Coren](https://nodesource.com/blog/author/bitandbang)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# 6 of the Most Exciting ES6 Features in Node.js v6 LTS
With the release of [Node.js v6 LTS "Boron"](https://nodesource.com/blog/need-to-node-recap-introducing-node-js-v6-lts-boron), there were a suite of updates to Node.js core APIs and its dependencies. The update to V8, the JavaScript engine from Chromium that is at the root of Node.js, is important - it brings [almost complete](http://node.green) support for something that's near and dear to a lot of Node.js and JavaScript developer's hearts: ES6.

With this article, we'll take a look at six of the best new ES6 features that are in the Node.js v6 LTS release.

## Setting defaults for function parameters

The new [default parameters feature](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Default_parameters) for functions enable a default value to be set for function arguments when the function is initially defined.

The addition of default function parameters to ES6, and subsequently Node core, doesn’t necessarily add new functionality that couldn’t have been achieved previously. That said, they are first-class support for configurable argument values, which enables us build more consistent and less opinionated code, across the entire ecosystem.

To get default values for function parameters previously, you would have had to do something along the lines of this:

    function toThePower(val, exponent) {
      exponent = exponent || 2

      // ...

    }

Now, with the new default parameters feature, the parameters can be defined, and defaulted, like this:

    function toThePower(value, exponent = 2) {
      // The rest of your code
    }

    toThePower(1, undefined) // exponent defaults to 2

## Extracting Data from Arrays and Objects with Destructuring

[Destructuring](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment) of arrays and objects gives developers the ability to extract values from either, and then expose them as distinct variables. Destructuring has a wide variety of uses - including cases like where specific values are wanted from a larger set. It provides a method to get that value in a concise way from a built-in feature in the language itself.

The destructuring object syntax is with curly braces (`{}`), and the destructuring array syntax is with square brackets (`[]`)

*   Array case: `const [one, two] = [1, 2]`
*   Object case: `const {a, b} = { a: ‘a’, b: ‘b’ }`
*   Defaults: `const {x = ‘x’, y} = { y: ‘y’ }`

## Destructuring Example 1:

    // fake tuples
    function returnsTuple() {
      return [name, data]
    }

    const [name, data] = returnsTuple()

## Destructuring Example 2:

    const threeValuesIn [,,,three, four, five] = my_array_of_10_elements

## Destructuring Example 3:

The way to grab object values in ES5:

    var person = {
      name: "Gumbo", 
      title: "Developer", 
      data: "yes" 
    }

    var name = person.name
    var title = person.title
    var data = person.data

The way to grab object values in ES6, with Destructuring:

    const { name, title, data } = person

## Checking Array Values with Array#includes()

The built-in [`.includes()`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/includes) method for Arrays (protip: the # means it's a [prototype method](https://twitter.com/bitandbang/status/792113575804272640), and can be called on arrays) is a simple way to check a value against an array to see if it is included somewhere inside of that array. The method will return `true` if the array does indeed contain the specified value. Thankfully, you can now say goodbye to `array.indexOf(item) === -1` forever.

    [1, 2].includes(1) // returns true

    [1, 2].includes(4) // returns false

[Rest parameters](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/rest_parameters) give functions the ability to collect additional arguments outside of the parameters that it has predefined. The contents of these arguments are then collected into an array. This allows a function to capture and parse additional arguments to enable some extended functionality, with far more options for optimization than previously available via the `arguments` object.

Rest parameters also work with arrow functions - this is fantastic, because arrow functions did not have the ability to get this previously as the `arguments` object does not exist within arrow functions.

    function concat(joiner, ...args) {

      // args is an actual Array

      return args.join(joiner)

    }

    concat(‘_’, 1, 2, 3) // returns ‘1_2_3’

## Expanding Arrays with the Spread Operator

The [spread operator](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Spread_operator) is a diverse tool that’s now native to JavaScript. It is a useful as a utility to expand an array into parameters for functions or array literals. One case where this is immensely useful, for example, is in cases where values are reused - the spread allows them to be stored and called with a much smaller footprint than previously needed.

Using the spread operator in function parameters:

    const numbersArray = [1, 2, 3]
    coolFunction(...numbersArray)

    // same as
    coolFunction(1, 2, 3)

Using the spread operator in array literal parameters:

    const arr1 = [1, 2]

    const arr2 = [...arr1, 3, 4]
    // arr2: [1, 2, 3, 4]

One interesting feature of the Spread operator is its interaction with Emoji. Wes Bos [shared](https://twitter.com/wesbos/status/769228067780825088) an interesting use for the spread operator that gives a very visual example of how it can be used - with Emoji. Here’s an example of that:

![Emoji and the JavaScript Spread Operator](https://images.contentful.com/hspc7zpa5cvq/2gYkLeavHOcAEaOyoqAqeq/498511fff19e56f1898aaa8e3d6d2a65/Emoji_and_the_JavaScript_Spread_Operator.png)

Note that neither Hyperterm nor Terminal.app (on an older OS X version) would actually render the new, compound Emoji correctly - it's an interesting example of how JavaScript and Node live on the edge.

## Naming of anonymous functions

In ES6, anonymous functions receive a `name` property. This property is extremely useful when debugging issues with an application - for example, when you get a stack trace caused by an anonymous function, you will be able to get the `name` of that anonymous function.

This is dramatically more helpful than recieving `anonymous` as part of the stack trace, as you would have in ES5 and before, as it gives a precise cause instead of a generic one.

    var x = function() { }; 

    x.name // Returns 'x'

## One last thing…

If you’d like to learn more about the changes to Node.js when the v6 release line became LTS, you can check out our blog post: [The 10 Key Features in Node.js v6 LTS Boron After You Upgrade](https://nodesource.com/blog/the-10-key-features-in-node-js-v6-lts-boron-after-you-upgrade).

Otherwise, for more updates about Node, JavaScript, ES6, Electron, npm, yarn, and more, you should follow [@NodeSource](https://twitter.com/nodesource) on Twitter. We're always around and would love to hear from _you_!