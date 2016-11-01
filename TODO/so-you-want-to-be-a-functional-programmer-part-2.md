> * 原文地址：[So You Want to be a Functional Programmer (Part 2)](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-2-7005682cec4a#.lvg65qyn8)
* 原文作者：[Charles Scalfani](https://medium.com/@cscalfani)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Airmacho](https://github.com/Airmacho)
* 校对者：

# So You Want to be a Functional Programmer (Part 2)

# 准备充分了嘛就想学函数式编程？(Part 2)


Taking that first step to understanding Functional Programming concepts is the most important and sometimes the most difficult step. But it doesn’t have to be. Not with the right perspective.

Previous parts: [Part 1](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-1-1f15e387e536)



#### Friendly Reminder

#### 友情提示









![](https://cdn-images-1.medium.com/max/1600/1*RYgiClt6s_Xj9OUK9qapIw.png)





Please read through the code slowly. Make sure you understand it before moving on. Each section builds on top of the previous section.

If you rush, you may miss some nuance that will be important later.

请读仔细读代码，确保继续之前你已经理解。每一代码段落都基于它之前的代码。

如果你太急，可能会遗漏一些重要的细节。

#### Refactoring

#### 重构

![](https://cdn-images-1.medium.com/max/1600/1*_GBlt7_8aD19rxHh6f2Uow.png)

Let’s think about refactoring for a minute. Here’s some Javascript code:

让我们先来重构一段 JavaScript 代码：

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

我们以前都写过这样的代码，经过一段时间我们会发现，上面两个函数实际上除了些许区别，其实是一样的（黑体高亮）。

我们应该创建一个单独的函数，将上面的区别参数化，而不是通过复制，粘贴，修改 validateSsn函数，来创建 validatePhone。

此例中，我们可以将要验证的参数，验证用的正则表达式，打印的文本抽象成参数传入方法。

The refactored code:

重构后的代码：

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

旧代码中要验证的参数 ssn，phone 现在用变量 value 来体现。

正则表达式  /^\d{3}-\d{2}-\d{4}$/ 和 /^\(\d{3}\)\d{3}-\d{4}$/ 用变量 regex 体现。

最后，需要打印的文本 'SSN' 和 'Phone Number' 用变量 type 拼接。

只有一个函数要比两个函数，或者更糟糕的情况三个，四个甚至十个函数好得多。这可以使你的代码保持整洁并且易维护。

例如，如果代码中有 bug，你只需要修改一处，而不用在整个代码库查找每一处粘贴或修改过这段代码的地方。

但当你遇到这样的情况：

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

这里 parseAddress 和 parseFullName 函数都接受一个字符串，解析符合条件返回 true 。

我们怎样重构这段代码？

我们可以用 value 来代替 address 和 name, 用 type 来替换 'Address' 和 'Name'，就像我们之前那样，但之前是将正则表达式作为参数传入，现在是函数。

如果我们能把一个函数当作参数传入就好了。。。

#### Higher-Order Functions

#### 高阶函数

![](https://cdn-images-1.medium.com/max/1600/1*hZyWFJAiDDiqci0ygBLeoA.png)





Many languages do not support passing functions as parameters. Some do but they don’t make it easy.

> In Functional Programming, a function is a first-class citizen of the language. In other words, a function is just another value.

Since functions are just values, we can pass them as parameters.

很多语言并不支持将函数作为参数传入。一些语言虽然支持，但用起来不直观。

> 在函数式编程中，函数是语言的第一公民。换句话说，函数就是另一种值。
>

因为函数是值，我们可以把它们当作参数传入函数。

Even though Javascript is not a Pure Functional language, you can do some functional operations with it. So here’s the last two functions refactored into a single function by passing the parsing function as a parameter called parseFunc:

尽管 JavaSscript 不是一门纯函数式语言，你也可以用它做一些函数式操作。我们可以将之前的两个函数重构成一个叫 parseFunc 的函数，将解析函数作为参数传入：

    function validateValueWithFunc(value, parseFunc, type) {
        if (parseFunc(value))
            console.log('Invalid ' + type);
        else
            console.log('Valid ' + type);
    }

Our new function is called a Higher-order Function.

> Higher-order Functions either take functions as parameters, return functions or both.

Now we can call our higher-order function for the four previous functions (this works in Javascript because Regex.exec returns a truthy value when a match is found):

我们的新函数就是高阶函数。

> 高阶函数既可以接受函数作为参数传入，也可以把函数作为返回值返回，或者同时满足两个条件。
>

现在我们可以将前面的四个函数抽象成一个高阶函数（在 JavaScript 里可以这样做，因为如果正则匹配成功，Regex.exec 返回真值）：

    validateValueWithFunc('123-45-6789', /^\d{3}-\d{2}-\d{4}$/.exec, 'SSN');
    validateValueWithFunc('(123)456-7890', /^\(\d{3}\)\d{3}-\d{4}$/.exec, 'Phone');
    validateValueWithFunc('123 Main St.', parseAddress, 'Address');
    validateValueWithFunc('Joe Mama', parseName, 'Name');

This is so much better than having four nearly identical functions.

But notice the regular expressions. They’re a bit verbose. Let’s clean up our a code by factoring them out:

这比之前使用四个近乎相同的函数好很多。

但要注意正则表达式。他们还有些冗长。现在我们重构代码来整理一下：

    var parseSsn = /^\d{3}-\d{2}-\d{4}$/.exec;
    var parsePhone = /^\(\d{3}\)\d{3}-\d{4}$/.exec;
    
    validateValueWithFunc('123-45-6789', parseSsn, 'SSN');
    validateValueWithFunc('(123)456-7890', parsePhone, 'Phone');
    validateValueWithFunc('123 Main St.', parseAddress, 'Address');
    validateValueWithFunc('Joe Mama', parseName, 'Name');

That’s better. Now when we want to parse a phone number, we don’t have to copy and paste the regular expression.

But imagine we have more regular expressions to parse, not just parseSsnand parsePhone. Each time we create a regular expression parser, we have to remember to add the .exec to the end. And trust me, this is easy to forget.

We can guard against this by creating a high-order function that returns the exec function:

好多了，现在如果我们想要检查一个值是否是电话号码，就不用复制，粘贴正则表达式了。

但是设想我们除了 parseSsn 和 parsePhone 还有更多的正则表达式需要匹配。每次我们新建函数都要用一个正则表达式，再调用 .exec。相信我，这很容易遗漏。

我们可以创建另一个高阶函数，在内部调用 exec 来解决这个问题：

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

这里，makeRegexParser 接受一个正则表达式作为参数，返回一个接受将一个被验证字符串作为参数的 exec 函数。validateValueWithFunc 可以传入字符串，值，给 parse 函数，例如 exec 。

parseSsn 和 parsePhone 和之前用正则表达式的 exec 函数一样可用。

的确，这只是一个微小的提升，但这里向我们展示了高阶函数将函数作为返回值返回的例子。

不过你可以想象如果 makeRegexParser 更复杂，这样改动可以给我们带来的好处。

这是另一个高阶函数返回函数作为返回值的例子：

    function makeAdder(constantValue) {
        return function adder(value) {
            return constantValue + value;
        };
    }

Here we have makeAdder that takes constantValue and returns adder, a function that will add that constant to any value it gets passed.

Here’s how it can be used:

这里 makeAddr 函数接受一个参数 constantValue，返回一个函数 addr，它的返回是 contantValue 与它接受的任意值相加的结果。

它的用法是：

    var add10 = makeAdder(10);
    console.log(add10(20)); // prints 30
    console.log(add10(30)); // prints 40
    console.log(add10(40)); // prints 50

We create a function, add10, by passing the constant 10 to makeAdderwhich returns a function that will add 10 to everything.

Notice that the function adder has access to constantValue even after makeAddr returns. That’s because constantValue was in its scope when adder was created.

This behavior is very important because without it, functions that return functions wouldn’t be very useful. So it’s important we understand how they work and what this behavior is called.

This behavior is called a Closure.

我们通过将 10 作为参数传给 makeAddr，创建了 add10 函数，它接受任意值作为参数，并与10求和返回。

需要注意的是，，即使在 makeAddr 返回后，函数 addr 仍可以获取到 constantValue 参数的值。这是因为 constantValue 在 addr 函数被创建时的作用域中。

这种行为非常重要，因为如果不是这样，将函数作为返回值返回的函数就没有多大用处了。所以我们理解它的机制非常重要。

这种行为叫做闭包。

#### Closures

#### 闭包

![](https://cdn-images-1.medium.com/max/1600/1*0phT7qIAPVxG7KXcL-6B5g.png)





Here’s a contrived example of functions that use closures:

这有一个故意的用到闭包的例子：

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

在这个例子中，child 函数可以获取到定义在它自己，parent 函数和 grandParent 函数作用域中定义的变量值。

parent 函数可以获取到它自己和 grandParent 函数作用域中定义的变量值。

grandParent 只能获取到它自己的变量（为了清晰理解可以参考上面的金字塔结构图）。

这有一个例子：

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

这里，parentFunc 可以保持 parent 函数的作用域，因为 grandParent 将 parent 作为返回值返回。

类似的，childFunc 可以保持 child 函数的作用域，因为 parentFunc 其实是返回 child 函数的 parent 函数。

当创建一个函数时，创建时所处的作用域的所有变量都是可以读取的。如果函数仍被引用，作用域保持存活状态。例如 child 函数的作用域只要  childFunc 的引用存在，就算存活。

> 闭包指函数通过被引用，保持其作用域的存活状态。
>

注意在 JavaScript 中，因为变量是可变的，所以闭包可能会引入问题。例如这些变量可能从它们被闭包开始到函数返回的周期里被修改。

#### My Brain!!!!

#### 我的脑子！









![](https://cdn-images-1.medium.com/max/1600/1*IK5485-iZaHeZRfP8aWmYg.png)





Enough for now.

In subsequent parts of this article, I’ll talk about Functional Composition, Currying, common functional functions (e.g map, filter, fold etc.), and more.

Up Next: [Part 3](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-3-1b0fd14eb1a7)

到目前暂时足够消化一段了。

在文章接下来的部分里，我会涉及到 函数组合，柯里化，函数式编程中常见的函数（如 map，filter，fold 等）

If you liked this, click the

