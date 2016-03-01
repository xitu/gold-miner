> * 原文链接: [Disassembling JavaScript's IIFE Syntax](https://blog.mariusschulz.com/2016/01/13/disassembling-javascripts-iife-syntax)
* 原文作者 : [Marius Schulz](https://blog.mariusschulz.com/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者 : 
* 状态 : 认领中


If you've spent even just a little time in the JavaScript world, you've likely come across the following pattern quite frequently. It's called an _IIFE_, which stands for _immediately invoked function expression_:

    (function() {
        // ...
    })();

A lot of the time, the function scope of an IIFE is used to prevent leaking local variables to the global scope. Similarly, IIFEs can be used to wrap state (or data in general) that's meant to be private. The basic pattern is the same in both cases.

> Check out [this excellent post](https://toddmotto.com/what-function-window-document-undefined-iife-really-means/) by [@toddmotto](https://twitter.com/toddmotto) for more information on what IIFEs can be used for — better minification results, for instance!

However, you might've been wondering why we write IIFEs the way we do. They look a little odd, after all. Let's inspect the IIFE syntax and disassemble it into its parts.

## [The IIFE Syntax](https://blog.mariusschulz.com/2016/01/13/disassembling-javascripts-iife-syntax#the-iife-syntax)

At the heart of each IIFE is the function itself. It spans from the `function` keyword to the closing brace:

    function() {
        // ...
    }

This piece of code alone is **not** valid JavaScript, though. When the parser sees the `function` keyword at the beginning of the statement, it expects a function declaration to follow. Since the function doesn't have a name, it doesn't follow the grammar rules of a function declaration. Therefore, the parsing attempt fails and we get a syntax error.

We somehow have to make the JavaScript engine parse a _function expression_ rather than a _function declaration_. If you're unsure about the difference, please refer to my post on the different kinds of [function definitions in JavaScript](https://blog.mariusschulz.com/2016/01/06/function-definitions-in-javascript).

The trick is quite simple, actually. We can fix the syntax error by wrapping the function within parentheses, which results in the following code:

    (function() {
        // ...
    });

Once the parser encounters the opening parenthesis, it expects an expression, followed by a closing parenthesis. Contrary to function declarations, function expressions don't have to be named, so the above (parenthesized) function expression is a valid piece of JavaScript code.

> If you're interested in the ECMAScript language grammar, the _ParenthesizedExpression_ production is detailed in [section 12.2 of the specification](http://www.ecma-international.org/ecma-262/6.0/#sec-primary-expression).

The only part that's left now is to invoke the function expression we've just created. Right now, the function never executes because it's never invoked, and without being assigned to anything, there's no way of getting hold of it later. We'll add a pair of parentheses at the end:

    (function() {
        // ...
    })();

And here we go — that's the IIFE we've been looking for. If you think about the name for a second, it perfectly describes what we've put together: an _immediately invoked function expression_.

The remainder of this post gives an overview over some variations of the IIFE syntax that exist for different reasons.

## [Where do the parentheses go?](https://blog.mariusschulz.com/2016/01/13/disassembling-javascripts-iife-syntax#where-do-the-parentheses-go)

So far, we've been placing the parentheses that invoke the function right after the closing wrapper parenthesis:

    (function() {
        // ...
    })();

However, some people like Douglas Crockford [famously don't like the aesthetics](https://www.youtube.com/watch?v=eGArABpLy0k&feature=youtu.be&t=1m10s) of a dangling pair of parentheses, so they place them within the wrapper:

    (function() {
        // ...
    }());

Both approaches are perfectly fine and semantically equivalent, so just pick (and stick to) the one you find more appealing.

## [Named IIFEs](https://blog.mariusschulz.com/2016/01/13/disassembling-javascripts-iife-syntax#named-iifes)

The function that's being wrapped is a regular function expression, which means you can give it a name and turn it into a [named function expression](https://blog.mariusschulz.com/2016/01/06/function-definitions-in-javascript#function-expressions), if you like:

    (function iife() {
        // ...
    })();

Note that you still cannot leave out the wrapping parentheses around the function. This piece of code is still **not** valid JavaScript:

    function iife() {
        // ...
    }();

The parser can now successfully parse a function declaration. Immediately after it, though, it unexpectedly encounters the `(` token and throws a syntax error. That's because unlike function expressions, function declarations cannot be immediately invoked.

## [Preventing Issues when Concatenating Files](https://blog.mariusschulz.com/2016/01/13/disassembling-javascripts-iife-syntax#preventing-issues-when-concatenating-files)

Sometimes, you might encounter an IIFE that has a leading semicolon in front of the opening wrapping parenthesis:

    ;(function() {
        // ...
    })();

This [defensive semicolon](https://blog.mariusschulz.com/2016/01/13/disassembling-javascripts-iife-syntax) exists to prevent issues that might arise when concatenating together two JavaScript files. Imagine the first file contains the following code:

    var foo = bar

Note there's no semicolon terminating the variable declaration statement. If the second JavaScript file contained an IIFE without a leading semicolon, the concatenated result would be as follows:

    var foo = bar
    (function() {
        // ...
    })();

This might look like an assignment of the identifier `bar` to the variable `foo` followed by an IIFE, but it's not. Instead, `bar` is attempted to be invoked as a function that gets passed another function as an argument. Removing the line break after `bar` should make the code clearer:

    var foo = bar(function() {
        // ...
    })();

The leading semicolon prevents this unwanted function invocation:

    var foo = bar;
    (function() {
        // ...
    })();

Even if the leading semicolon is not preceded by any other code, it is a grammatically correct language construct. In that case, it would be parsed as an _empty statement_, which simply doesn't do anything and therefore does no harm.

The rules for JavaScript's [automatic semicolon insertion](http://www.ecma-international.org/ecma-262/6.0/#sec-automatic-semicolon-insertion) are tricky and easily lead to unexpected errors. I recommend you always explicitly write out semicolons instead of having them inserted automatically.

## [Arrow Functions Instead of Function Expressions](https://blog.mariusschulz.com/2016/01/13/disassembling-javascripts-iife-syntax#arrow-functions-instead-of-function-expressions)

With ECMAScript 2015, JavaScript was extended by the arrow function syntax for function definitions. Just like function expressions, arrow functions are expressions, not statements. This means that we could create an _immediately invoked arrow function_ if we wanted to:

    (() => {
        // ...
    })();

I wouldn't recommend you write your IIFEs this way, though; I find the classic version using the `function` keyword much easier to read.
