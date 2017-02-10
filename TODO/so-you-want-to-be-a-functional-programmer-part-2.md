> * 原文地址：[So You Want to be a Functional Programmer (Part 2)](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-2-7005682cec4a#.lvg65qyn8)
* 原文作者：[Charles Scalfani](https://medium.com/@cscalfani)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Airmacho](https://github.com/Airmacho)
* 校对者：[cyseria](https://github.com/cyseria) 和 [Tina92](https://github.com/Tina92)

# 准备充分了嘛就想学函数式编程？(Part 2)

想要理解函数式编程，第一步总是最重要，也是最困难的。但是只要有了正确的思维，其实也不是太难。

之前的部分: [第一部分](https://github.com/xitu/gold-miner/blob/master/TODO/so-you-want-to-be-a-functional-programmer-part-1.md)

#### 友情提示



![](https://cdn-images-1.medium.com/max/1600/1*RYgiClt6s_Xj9OUK9qapIw.png)



请读仔细读代码，确保继续之前你已经理解。每一代码段落都基于它之前的代码。

如果你太急，可能会遗漏一些重要的细节。

#### 重构

![](https://cdn-images-1.medium.com/max/1600/1*_GBlt7_8aD19rxHh6f2Uow.png)

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

我们以前都写过这样的代码，经过一段时间我们会发现，上面两个函数实际上除了些许区别，其实是一样的（黑体高亮）。

我们应该创建一个单独的函数，将上面的区别参数化，而不是通过复制，粘贴，修改 validateSsn 函数，来创建 validatePhone。

此例中，我们可以将要验证的参数，验证用的正则表达式，打印的文本抽象成参数传入方法。

重构后的代码：

    function validateValue(value, regex, type) {
        if (regex.exec(value))
            console.log('Invalid ' + type);
        else
            console.log('Valid ' + type);
    }

旧代码中要验证的参数 ssn，phone，现在都用参数 value 来体现。

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

这里 parseAddress 和 parseFullName 函数都只接受一个字符串参数，并在符合解析条件时返回 true 。

我们怎样重构这段代码？

我们可以用 value 来代替 address 和 name, 用 type 来替换 'Address' 和 'Name'，就像我们之前那样，但之前是将正则表达式作为参数传入，现在是函数。

如果我们能把一个函数当作参数传入就好了。。。

#### 高阶函数

![](https://cdn-images-1.medium.com/max/1600/1*hZyWFJAiDDiqci0ygBLeoA.png)



很多语言并不支持将函数作为参数传入。一些语言虽然支持，但用起来不直观。

> 在函数式编程中，函数是语言的第一公民。换句话说，函数就是另一种值。
>

因为函数是值，我们可以把它们当作参数传入函数。

尽管 JavaSscript 不是一门纯函数式语言，你也可以用它做一些函数式操作。我们可以将之前的两个函数重构成一个叫 parseFunc 的函数，将解析函数作为参数传入：

    function validateValueWithFunc(value, parseFunc, type) {
        if (parseFunc(value))
            console.log('Invalid ' + type);
        else
            console.log('Valid ' + type);
    }

我们的新函数就是高阶函数。

> 高阶函数既可以接受函数作为参数传入，也可以把函数作为返回值返回，或者同时满足两个条件。
>

现在我们可以将前面的四个函数抽象成一个高阶函数（在 JavaScript 里可以这样做，因为如果正则匹配成功，Regex.exec 返回真值）：

    validateValueWithFunc('123-45-6789', /^\d{3}-\d{2}-\d{4}$/.exec, 'SSN');
    validateValueWithFunc('(123)456-7890', /^\(\d{3}\)\d{3}-\d{4}$/.exec, 'Phone');
    validateValueWithFunc('123 Main St.', parseAddress, 'Address');
    validateValueWithFunc('Joe Mama', parseName, 'Name');

这比之前使用四个近乎相同的函数好很多。

但要注意正则表达式。他们还有些冗长。现在我们重构代码来整理一下：

    var parseSsn = /^\d{3}-\d{2}-\d{4}$/.exec;
    var parsePhone = /^\(\d{3}\)\d{3}-\d{4}$/.exec;
    
    validateValueWithFunc('123-45-6789', parseSsn, 'SSN');
    validateValueWithFunc('(123)456-7890', parsePhone, 'Phone');
    validateValueWithFunc('123 Main St.', parseAddress, 'Address');
    validateValueWithFunc('Joe Mama', parseName, 'Name');

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

这里，makeRegexParser 接受一个正则表达式作为参数，返回一个 exec 函数，这个函数接受被验证字符串作为参数。validateValueWithFunc 可以传入字符串，值，给 parse 函数，例如 exec 。

parseSsn 和 parsePhone 和之前用正则表达式的 exec 函数一样可用。

的确，这只是一个微小的提升，但这里向我们展示了高阶函数将函数作为返回值返回的例子。

不过你可以想象如果 makeRegexParser 更复杂，这样改动可以给我们带来的好处。

这是另一个高阶函数返回函数作为返回值的例子：

    function makeAdder(constantValue) {
        return function adder(value) {
            return constantValue + value;
        };
    }

这里 makeAddr 函数接受一个参数 constantValue，返回一个函数 addr，它的返回是 contantValue 与它接受的任意值相加的结果。

它的用法是：

    var add10 = makeAdder(10);
    console.log(add10(20)); // prints 30
    console.log(add10(30)); // prints 40
    console.log(add10(40)); // prints 50

我们通过将 10 作为参数传给 makeAddr，创建了 add10 函数，它接受任意值作为参数，并与 10 求和返回。

需要注意的是，，即使在 makeAddr 返回后，函数 addr 仍可以获取到 constantValue 参数的值。这是因为 constantValue 在 addr 函数被创建时的作用域中。

这种行为非常重要，因为如果不是这样，将函数作为返回值返回的函数就没有多大用处了。所以我们理解它的工作原理非常重要。

这种行为叫做闭包。

#### 闭包

![](https://cdn-images-1.medium.com/max/1600/1*0phT7qIAPVxG7KXcL-6B5g.png)



这有一个故意使用闭包的函数：

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

在这个例子中，child 函数可以获取到定义在它自己，parent 函数和 grandParent 函数作用域中定义的变量值。

parent 函数可以获取到它自己和 grandParent 函数作用域中定义的变量值。

grandParent 只能获取到它自己的变量（为了清晰理解可以参考上面的金字塔结构图）。

这有一个例子：

    var parentFunc = grandParent(1, 2); // returns parent()
    var childFunc = parentFunc(11, 22); // returns child()
    console.log(childFunc(111, 222)); // prints 738
    // 1 + 2 + 3 + 11 + 22 + 33 + 111 + 222 + 333 == 738

这里，parentFunc 可以保持 parent 函数的作用域，因为 grandParent 将 parent 作为返回值返回。

类似的，childFunc 可以保持 child 函数的作用域，因为 parentFunc 其实是返回 child 函数的 parent 函数。

当创建一个函数时，创建时所处的作用域的所有变量都是可以读取的。如果函数仍被引用，作用域保持存活状态。例如 child 函数的作用域只要 childFunc 的引用存在，就算存活。

> 闭包指函数通过被引用，保持其作用域的存活状态。
>

注意在 JavaScript 中，因为变量是可变的，所以闭包可能会引入问题。例如这些变量可能从它们被闭包开始到函数返回的周期里被修改。

值得庆幸的是，函数式语言中的变量是不可变的，所以就可以消除这种常见的错误和混乱。

#### 我的脑子！



![](https://cdn-images-1.medium.com/max/1600/1*IK5485-iZaHeZRfP8aWmYg.png)





到目前暂时足够消化一段了。

在文章接下来的部分里，我会涉及到 函数组合，柯里化，函数式编程中常见的函数（如 map，filter，fold 等）

接下来：【[第三部分](https://github.com/xitu/gold-miner/blob/master/TODO/so-you-want-to-be-a-functional-programmer-part-3.md)】

