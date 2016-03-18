> * 原文链接: [Disassembling JavaScript's IIFE Syntax](https://blog.mariusschulz.com/2016/01/13/disassembling-javascripts-iife-syntax)
* 原文作者 : [Marius Schulz](https://blog.mariusschulz.com/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 :  @huxpro
* 校对者 : 
* 状态 : 待校对

# 揭秘 IIFE 语法


If you've spent even just a little time in the JavaScript world, you've likely come across the following pattern quite frequently. It's called an _IIFE_, which stands for _immediately invoked function expression_:

只要你稍微接触过一些 JavaScript，你一定会频繁地接触到下面这个模式 —— *IIFE*，其全称为 *immediately invoked function expression*，即“立即调用的函数表达式”：

    (function() {
        // ...
    })();


A lot of the time, the function scope of an IIFE is used to prevent leaking local variables to the global scope. Similarly, IIFEs can be used to wrap state (or data in general) that's meant to be private. The basic pattern is the same in both cases.

一直以来，IIFE 创造的函数作用域被用于防止局部变量的泄漏。类似地，我们可以用 IIFE 来包裹私有状态（广义上说，一切数据），这两者本质上是相通的。


> Check out [this excellent post](https://toddmotto.com/what-function-window-document-undefined-iife-really-means/) by [@toddmotto](https://twitter.com/toddmotto) for more information on what IIFEs can be used for — better minification results, for instance!

> 想知道 IIFE 的更多用途吗，比如提高代码压缩率？不妨看看[@toddmotto](https://twitter.com/toddmotto) 的[这篇文章](https://toddmotto.com/what-function-window-document-undefined-iife-really-means/)



However, you might've been wondering why we write IIFEs the way we do. They look a little odd, after all. Let's inspect the IIFE syntax and disassemble it into its parts.

不过，你可能还是会好奇为什么 IIFE 的语法是这样的？它看上去的确有一点点奇怪，让我们一点一点来的揭开她神秘的面纱吧

## [The IIFE Syntax](https://blog.mariusschulz.com/2016/01/13/disassembling-javascripts-iife-syntax#the-iife-syntax)

## [IIFE 语法](https://blog.mariusschulz.com/2016/01/13/disassembling-javascripts-iife-syntax#the-iife-syntax)

At the heart of each IIFE is the function itself. It spans from the `function` keyword to the closing brace:

IIFE 的核心无非就是一个函数，从 `function` 关键字开始，到右花括号结束：


    function() {
        // ...
    }


This piece of code alone is **not** valid JavaScript, though. When the parser sees the `function` keyword at the beginning of the statement, it expects a function declaration to follow. Since the function doesn't have a name, it doesn't follow the grammar rules of a function declaration. Therefore, the parsing attempt fails and we get a syntax error.

不过，这可**不是**一段有效的 JavaScript 代码。当 parser（语法分析器）看到这段语句由 `function` 关键字开头时，它就会按照函数声明（Function Declaration）的方式开始解析了。可是这段函数声明并没有声明函数名，不符合语法规则。因此解析失败，我们只会得到一个语法错误。


We somehow have to make the JavaScript engine parse a _function expression_ rather than a _function declaration_. If you're unsure about the difference, please refer to my post on the different kinds of [function definitions in JavaScript](https://blog.mariusschulz.com/2016/01/06/function-definitions-in-javascript).

所以我们得想个办法让 JavaScript 引擎把它作为*函数表达式（Function Expression）*而非*函数声明（Function Declaration）*来解析。如果你还不知道这两者得区别，可以看看原作者这篇有关 [JavaScript 中不同声明函数方式差异的文章](https://blog.mariusschulz.com/2016/01/06/function-definitions-in-javascript).


The trick is quite simple, actually. We can fix the syntax error by wrapping the function within parentheses, which results in the following code:

我们使用的技巧其实非常简单。用一个圆括号将函数包裹起来其实就可以消除语法错误了，我们得到一段这样的代码：

    (function() {
        // ...
    });

Once the parser encounters the opening parenthesis, it expects an expression, followed by a closing parenthesis. Contrary to function declarations, function expressions don't have to be named, so the above (parenthesized) function expression is a valid piece of JavaScript code.

一旦遭遇到未闭合的圆括号，parser 就会把两个圆括号之间的语句作为表达式来看待。与函数声明相比，函数表达式可以是匿名的，所以上面这段（被圆括号包着的）函数表达式就成为了一段有效的 JavaScript 代码。


> If you're interested in the ECMAScript language grammar, the _ParenthesizedExpression_ production is detailed in [section 12.2 of the specification](http://www.ecma-international.org/ecma-262/6.0/#sec-primary-expression).

> 如果你想继续了解 ECMAScript 语法，_ParenthesizedExpression_ 这个部分被详细叙述在[规范的 12.2 节](http://www.ecma-international.org/ecma-262/6.0/#sec-primary-expression).


The only part that's left now is to invoke the function expression we've just created. Right now, the function never executes because it's never invoked, and without being assigned to anything, there's no way of getting hold of it later. We'll add a pair of parentheses at the end:

最后剩下的，就是调用这个函数表达式了。目前为止，我们既没有调用这个函数，也没有将它赋值给任何一个变量，所以我们没有任何办法可以持有它的引用然后过一会儿再来调用它。我们将要做的是再它后面再加上一对圆括号：

    (function() {
        // ...
    })();

And here we go — that's the IIFE we've been looking for. If you think about the name for a second, it perfectly describes what we've put together: an _immediately invoked function expression_.

传说中过的 IIFE 就这么出现了。如果你稍微回想一下它的名字，就会觉得这个名字再合适不过了：一个*被立即调用的函数表达式（immediately invoked function expression）*


The remainder of this post gives an overview over some variations of the IIFE syntax that exist for different reasons.

接下来，我们来看几个在不同原因催生下的 IIFE 变种。


## [Where do the parentheses go?](https://blog.mariusschulz.com/2016/01/13/disassembling-javascripts-iife-syntax#where-do-the-parentheses-go)

## [圆括号应该放哪？](https://blog.mariusschulz.com/2016/01/13/disassembling-javascripts-iife-syntax#where-do-the-parentheses-go)

So far, we've been placing the parentheses that invoke the function right after the closing wrapper parenthesis:

我们刚才的做法，是把用于调用函数表达式的圆括号直接放在用于包裹的圆括号之后：

    (function() {
        // ...
    })();

However, some people like Douglas Crockford [famously don't like the aesthetics](https://www.youtube.com/watch?v=eGArABpLy0k&feature=youtu.be&t=1m10s) of a dangling pair of parentheses, so they place them within the wrapper:

不过，Douglas Crockford 等人觉得悬挂在外的括号[太不美观了](https://www.youtube.com/watch?v=eGArABpLy0k&feature=youtu.be&t=1m10s)！所以它们把括号放到了里面：

    (function() {
        // ...
    }());

Both approaches are perfectly fine and semantically equivalent, so just pick (and stick to) the one you find more appealing.

其实两种做法从功能还是语义上来说都没什么问题，所以选择你自己拥护的就好啦。

## [Named IIFEs](https://blog.mariusschulz.com/2016/01/13/disassembling-javascripts-iife-syntax#named-iifes)

## [实名 IIFE](https://blog.mariusschulz.com/2016/01/13/disassembling-javascripts-iife-syntax#named-iifes)

The function that's being wrapped is a regular function expression, which means you can give it a name and turn it into a [named function expression](https://blog.mariusschulz.com/2016/01/06/function-definitions-in-javascript#function-expressions), if you like:

被包裹起来的函数其实就是个普通的函数表达式，所以你也可以给它个名字让它变成[实名的函数表达式](https://blog.mariusschulz.com/2016/01/06/function-definitions-in-javascript#function-expressions)：


    (function iife() {
        // ...
    })();

Note that you still cannot leave out the wrapping parentheses around the function. This piece of code is still **not** valid JavaScript:

注意你仍然不能省略用于包裹的括号，下面这段代码仍然是**无效的**：


    function iife() {
        // ...
    }();

The parser can now successfully parse a function declaration. Immediately after it, though, it unexpectedly encounters the `(` token and throws a syntax error. That's because unlike function expressions, function declarations cannot be immediately invoked.

虽然 parser 现在可以成功地把它作为函数声明来解析，但很快，紧跟的 `(` 符号就会抛出语法错误了。与函数表达式不同，函数声明并不可以被立刻调用。

## [Preventing Issues when Concatenating Files](https://blog.mariusschulz.com/2016/01/13/disassembling-javascripts-iife-syntax#preventing-issues-when-concatenating-files)

## [避免文件合并时遇到问题](https://blog.mariusschulz.com/2016/01/13/disassembling-javascripts-iife-syntax#preventing-issues-when-concatenating-files)

Sometimes, you might encounter an IIFE that has a leading semicolon in front of the opening wrapping parenthesis:

有时，你会看到 IIFE 的前面放了个分号：

    ;(function() {
        // ...
    })();

This [defensive semicolon](https://blog.mariusschulz.com/2016/01/13/disassembling-javascripts-iife-syntax) exists to prevent issues that might arise when concatenating together two JavaScript files. Imagine the first file contains the following code:

这个分号被称为[防御性分号](https://blog.mariusschulz.com/2016/01/13/disassembling-javascripts-iife-syntax)，用于防止两个 JavaScript 文件合并时可能产生的问题。想象一下假设第一个文件的代码是这样的：

    var foo = bar

Note there's no semicolon terminating the variable declaration statement. If the second JavaScript file contained an IIFE without a leading semicolon, the concatenated result would be as follows:

可以看到这个变量声明语句并没有以分号结尾。如果第二个 JS 文件中的 IIFE 前面没有放分号，合并的结果就会是这样：

    var foo = bar
    (function() {
        // ...
    })();

This might look like an assignment of the identifier `bar` to the variable `foo` followed by an IIFE, but it's not. Instead, `bar` is attempted to be invoked as a function that gets passed another function as an argument. Removing the line break after `bar` should make the code clearer:

第一眼看上去好像是一个赋值操作与一个 IIFE。可是事与愿违，我们把 `bar` 后面的换行去掉就能看清楚了： `bar` 会被当作一个接受函数类型参数的函数……

    var foo = bar(function() {
        // ...
    })();

The leading semicolon prevents this unwanted function invocation:

而防御性分号就可以解决这个问题：

    var foo = bar;
    (function() {
        // ...
    })();

Even if the leading semicolon is not preceded by any other code, it is a grammatically correct language construct. In that case, it would be parsed as an _empty statement_, which simply doesn't do anything and therefore does no harm.

就算这个分号前面什么代码也没有，在语法上其实这也是正确的：它会被当做一个*空声明（empty statement）*，无伤大雅。

The rules for JavaScript's [automatic semicolon insertion](http://www.ecma-international.org/ecma-262/6.0/#sec-automatic-semicolon-insertion) are tricky and easily lead to unexpected errors. I recommend you always explicitly write out semicolons instead of having them inserted automatically.

JavaScript [自动添加分号](http://www.ecma-international.org/ecma-262/6.0/#sec-automatic-semicolon-insertion)的特性很容易让这种意想不到的错误发生。我的建议是永远显式的写好分号，而不要让它被自己添加。

## [Arrow Functions Instead of Function Expressions](https://blog.mariusschulz.com/2016/01/13/disassembling-javascripts-iife-syntax#arrow-functions-instead-of-function-expressions)

## [箭头函数！](https://blog.mariusschulz.com/2016/01/13/disassembling-javascripts-iife-syntax#arrow-functions-instead-of-function-expressions)

With ECMAScript 2015, JavaScript was extended by the arrow function syntax for function definitions. Just like function expressions, arrow functions are expressions, not statements. This means that we could create an _immediately invoked arrow function_ if we wanted to:

随着 ECMAScript 2015 的到来，JavaScript 的函数声明方式中又多了一个箭头函数（Arrow Function）。箭头函数与函数表达式同属于表达式而非声明语句。所以我们同样可以用它来创造 IIFE：

    (() => {
        // ...
    })();

I wouldn't recommend you write your IIFEs this way, though; I find the classic version using the `function` keyword much easier to read.

不过我并不建议你这么做；我觉得传统的 `function` 关键字写法的可读性要好得多。
