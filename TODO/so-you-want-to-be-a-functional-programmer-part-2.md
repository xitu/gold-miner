> * 原文地址：[So You Want to be a Functional Programmer (Part 2)](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-2-7005682cec4a#.lvg65qyn8)
* 原文作者：[Charles Scalfani](https://medium.com/@cscalfani)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# So You Want to be a Functional Programmer (Part 2)


Taking that first step to understanding Functional Programming concepts is the most important and sometimes the most difficult step. But it doesn’t have to be. Not with the right perspective.

Previous parts: [Part 1](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-1-1f15e387e536)

#### Friendly Reminder









![](https://cdn-images-1.medium.com/max/1600/1*RYgiClt6s_Xj9OUK9qapIw.png)





Please read through the code slowly. Make sure you understand it before moving on. Each section builds on top of the previous section.

If you rush, you may miss some nuance that will be important later.

#### Refactoring









![](https://cdn-images-1.medium.com/max/1600/1*_GBlt7_8aD19rxHh6f2Uow.png)





Let’s think about refactoring for a minute. Here’s some Javascript code:

    function validateSsn(ssn) {
        if (/^\d{3}-\d{2}-\d{4}$/.exec(ssn))
            console.log('Valid SSN');
        else
            console.log('Invalid SSN');
    }

    function validatePhone(phone) {
        if (/^\(\d{3}\)\d{3}-\d{4}$/.exec(phone))
            console.log('Valid Phone Number');
        else
            console.log('Invalid Phone Number');
    }

We’ve all written code like this before and over time, we start to recognize that these two functions are practically the same and only differ by a few things (shown in bold).

Instead of copying validateSsn and pasting and editing to create validatePhone, we should create a single function and parameterize the things that we edited after pasting.

In this example, we would parameterize the value, the regular expressionand the message printed (at least the last part of the message printed).

The refactored code:

    function validateValue(value, regex, type) {
        if (regex.exec(value))
            console.log('Invalid ' + type);
        else
            console.log('Valid ' + type);
    }

The parameters ssn and phone in the old code are now represented by value.

The regular expressions /^\d{3}-\d{2}-\d{4}$/ and /^\(\d{3}\)\d{3}-\d{4}$/ are represented by regex.

And finally, the last part of the message ‘SSN’ and ‘Phone Number’ are represented by type.

Having one function is much better than having two functions. Or worse three, four or ten functions. This keeps your code clean and maintainable.

For example, if there’s a bug, you only have to fix it in one place versus searching through your whole codebase to find where this function MAY have been pasted and modified.

But what happens when you have the following situation:

    function validateAddress(address) {
        if (parseAddress(address))
            console.log('Valid Address');
        else
            console.log('Invalid Address');
    }

    function validateName(name) {
        if (parseFullName(name))
            console.log('Valid Name');
        else
            console.log('Invalid Name');
    }

Here parseAddress and parseFullName are functions that take a string and return true if it parses.

How do we refactor this?

Well, we can use value for address and name, and type for ‘Address’ and‘Name’ like we did before but there’s a function where our regular expression used to be.

If only we could pass a function as a parameter…

#### Higher-Order Functions









![](https://cdn-images-1.medium.com/max/1600/1*hZyWFJAiDDiqci0ygBLeoA.png)





Many languages do not support passing functions as parameters. Some do but they don’t make it easy.

> In Functional Programming, a function is a first-class citizen of the language. In other words, a function is just another value.

Since functions are just values, we can pass them as parameters.

Even though Javascript is not a Pure Functional language, you can do some functional operations with it. So here’s the last two functions refactored into a single function by passing the parsing function as a parameter called parseFunc:

    function validateValueWithFunc(value, parseFunc, type) {
        if (parseFunc(value))
            console.log('Invalid ' + type);
        else
            console.log('Valid ' + type);
    }

Our new function is called a Higher-order Function.

> Higher-order Functions either take functions as parameters, return functions or both.

Now we can call our higher-order function for the four previous functions (this works in Javascript because Regex.exec returns a truthy value when a match is found):

    validateValueWithFunc('123-45-6789', /^\d{3}-\d{2}-\d{4}$/.exec, 'SSN');
    validateValueWithFunc('(123)456-7890', /^\(\d{3}\)\d{3}-\d{4}$/.exec, 'Phone');
    validateValueWithFunc('123 Main St.', parseAddress, 'Address');
    validateValueWithFunc('Joe Mama', parseName, 'Name');

This is so much better than having four nearly identical functions.

But notice the regular expressions. They’re a bit verbose. Let’s clean up our a code by factoring them out:

    var parseSsn = /^\d{3}-\d{2}-\d{4}$/.exec;
    var parsePhone = /^\(\d{3}\)\d{3}-\d{4}$/.exec;

    validateValueWithFunc('123-45-6789', parseSsn, 'SSN');
    validateValueWithFunc('(123)456-7890', parsePhone, 'Phone');
    validateValueWithFunc('123 Main St.', parseAddress, 'Address');
    validateValueWithFunc('Joe Mama', parseName, 'Name');

That’s better. Now when we want to parse a phone number, we don’t have to copy and paste the regular expression.

But imagine we have more regular expressions to parse, not just parseSsnand parsePhone. Each time we create a regular expression parser, we have to remember to add the .exec to the end. And trust me, this is easy to forget.

We can guard against this by creating a high-order function that returns the exec function:

    function makeRegexParser(regex) {
        return regex.exec;
    }

    var parseSsn = makeRegexParser(/^\d{3}-\d{2}-\d{4}$/);
    var parsePhone = makeRegexParser(/^\(\d{3}\)\d{3}-\d{4}$/);

    validateValueWithFunc('123-45-6789', parseSsn, 'SSN');
    validateValueWithFunc('(123)456-7890', parsePhone, 'Phone');
    validateValueWithFunc('123 Main St.', parseAddress, 'Address');
    validateValueWithFunc('Joe Mama', parseName, 'Name');

Here, makeRegexParser takes a regular expression and returns the execfunction, which takes a string. validateValueWithFunc will pass the string, value, to the parse function, i.e. exec.

parseSsn and parsePhone are effectively the same as before, the regular expression’s exec function.

Granted, this is a marginal improvement but is shown here to give an example of a high-order function that returns a function.

However, you can imagine the benefits of making this change if makeRegexParser was much more complex.

Here’s another example of a higher-order function that returns a function:

    function makeAdder(constantValue) {
        return function adder(value) {
            return constantValue + value;
        };
    }

Here we have makeAdder that takes constantValue and returns adder, a function that will add that constant to any value it gets passed.

Here’s how it can be used:

    var add10 = makeAdder(10);
    console.log(add10(20)); // prints 30
    console.log(add10(30)); // prints 40
    console.log(add10(40)); // prints 50

We create a function, add10, by passing the constant 10 to makeAdderwhich returns a function that will add 10 to everything.

Notice that the function adder has access to constantValue even after makeAddr returns. That’s because constantValue was in its scope when adder was created.

This behavior is very important because without it, functions that return functions wouldn’t be very useful. So it’s important we understand how they work and what this behavior is called.

This behavior is called a Closure.

#### Closures









![](https://cdn-images-1.medium.com/max/1600/1*0phT7qIAPVxG7KXcL-6B5g.png)





Here’s a contrived example of functions that use closures:

    function grandParent(g1, g2) {
        var g3 = 3;
        return function parent(p1, p2) {
            var p3 = 33;
            return function child(c1, c2) {
                var c3 = 333;
                return g1 + g2 + g3 + p1 + p2 + p3 + c1 + c2 + c3;
            };
        };
    }

In this example, child has access to its variables, the parent’s variables and the grandParent’s variables.

The parent has access to its variables and grandParent’s variables.

The grandParent only has access to its variables.

(See pyramid above for clarification.)

Here’s an example of its use:

    var parentFunc = grandParent(1, 2); // returns parent()
    var childFunc = parentFunc(11, 22); // returns child()
    console.log(childFunc(111, 222)); // prints 738
    // 1 + 2 + 3 + 11 + 22 + 33 + 111 + 222 + 333 == 738

Here, parentFunc keeps the parent’s scope alive since grandParent returns parent.

Similarly, childFunc keeps the child’s scope alive since parentFunc, which is just parent, returns child.

When a function is created, all of the variables in its scope at the time of creation are accessible to it for the lifetime of the function. A function exists as long as there still a reference to it. For example, child’s scope exists as long as childFunc still references it.

> A closure is a function’s scope that’s kept alive by a reference to that function.

Note that in Javascript, closures are problematic since the variables are mutable, i.e. they can change values from the time they were closed over to the time the returned function is called.

Thankfully, variables in Functional Languages are Immutable eliminating this common source of bugs and confusion.

#### My Brain!!!!









![](https://cdn-images-1.medium.com/max/1600/1*IK5485-iZaHeZRfP8aWmYg.png)





Enough for now.

In subsequent parts of this article, I’ll talk about Functional Composition, Currying, common functional functions (e.g map, filter, fold etc.), and more.

Up Next: [Part 3](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-3-1b0fd14eb1a7)

If you liked this, click the

