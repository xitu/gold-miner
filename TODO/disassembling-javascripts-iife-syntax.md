> * 原文链接 : [Disassembling JavaScript's IIFE Syntax](https://blog.mariusschulz.com/2016/01/13/disassembling-javascripts-iife-syntax)
* 原文作者 : [Marius Schulz](https://blog.mariusschulz.com/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 :  [huxpro](https://github.com/Huxpro)
* 校对者 : [L9m](https://github.com/L9m), [sqrthree](https://github.com/sqrthree)


# 揭秘 IIFE 语法


只要你稍微接触过一些 JavaScript，你一定会频繁地接触到下面这个模式 —— *IIFE*，其全称为 *immediately invoked function expression*，即“立即调用的函数表达式”：

    (function() {
        // ...
    })();



一直以来，IIFE 创造的函数作用域被用于防止局部变量泄漏至全局作用域中。类似地，我们可以用 IIFE 来包裹私有状态（或广而言之，数据），这两者本质上是相通的。



> 想知道 IIFE 的更多用途吗，比如提高代码压缩率？不妨看看[@toddmotto](https://twitter.com/toddmotto) 的[这篇文章](https://toddmotto.com/what-function-window-document-undefined-iife-really-means/)



不过，你可能还是会好奇为什么 IIFE 的语法是这样的？它看上去的确有一点点奇怪，让我们一点一点地来揭开她神秘的面纱吧。


## IIFE 语法


IIFE 的核心无非就是一个函数，从 `function` 关键字开始，到右花括号结束：


    function() {
        // ...
    }

不过，这可**不是**一段合法的 JavaScript 代码。当 parser（语法分析器）看到这段语句由 `function` 关键字开头时，它就会按照函数声明（Function Declaration）的方式开始解析了。可是这段函数声明并没有声明函数名，不符合语法规则。因此解析失败，我们只会得到一个语法错误。

所以我们得想个办法让 JavaScript 引擎把它作为*函数表达式（Function Expression）*而非*函数声明（Function Declaration）*来解析。如果你还不知道这两者的区别，可以看看原作者这篇有关 [JavaScript 中不同声明函数方式差异](https://blog.mariusschulz.com/2016/01/06/function-definitions-in-javascript)的文章。


我们使用的技巧其实非常简单。用一个圆括号将函数包裹起来其实就可以消除语法错误了，我们得到以下代码：

    (function() {
        // ...
    });



一旦遭遇到未闭合的圆括号，parser 就会把两个圆括号之间的语句作为表达式来看待。与函数声明相比，函数表达式可以是匿名的，所以上面这段（被圆括号包着的）函数表达式就成为了一段合法的 JavaScript 代码。



> 如果你想继续了解 ECMAScript 语法，_ParenthesizedExpression_ 这个部分被详细叙述在[规范的 12.2 节](http://www.ecma-international.org/ecma-262/6.0/#sec-primary-expression).



最后剩下的，就是调用这个函数表达式了。目前为止，这个函数还未被执行。我们也没有将它赋值给任何变量 ，因此我们无法持有它的引用从而之后能用来调用它。我们将要做的是在它后面再加上一对圆括号：

    (function() {
        // ...
    })();


传说中的 IIFE 就这么出现了。如果你稍微回想一下，就会觉得这个名字再合适不过了：一个*被立即调用的函数表达式（immediately invoked function expression）*



接下来，我们来看几个在不同原因催生下的 IIFE 变种。



## 圆括号应该放哪？


我们刚才的做法，是把用于调用函数表达式的圆括号直接放在用于包裹的圆括号之后：

    (function() {
        // ...
    })();


不过，Douglas Crockford 等人觉得悬荡在外的圆括号[太不美观了](https://www.youtube.com/watch?v=eGArABpLy0k&feature=youtu.be&t=1m10s)！所以它们把圆括号移到了里面：

    (function() {
        // ...
    }());


其实两种做法从功能还是语义上来说都差不多，所以选择一种你喜欢的并坚持下去就好了。


## 实名 IIFE



被包裹起来的函数其实就是个普通的函数表达式，所以你也可以给它个名字让它变成[实名的函数表达式](https://blog.mariusschulz.com/2016/01/06/function-definitions-in-javascript#function-expressions)：


    (function iife() {
        // ...
    })();



注意你仍然不能省略用于包裹的括号，下面这段代码仍然是**无效的**：


    function iife() {
        // ...
    }();


虽然 parser 现在可以成功地把它作为函数声明来解析，但很快，紧跟的 `(` 符号就会抛出语法错误了。与函数表达式不同，函数声明并不可以被立刻调用。


## 避免文件合并时遇到问题


有时，你会看到 IIFE 的前面放了个分号：

    ;(function() {
        // ...
    })();


这个分号被称为[防御性分号](https://blog.mariusschulz.com/2016/01/13/disassembling-javascripts-iife-syntax)，用于防止两个 JavaScript 文件合并时可能产生的问题。想象一下假设第一个文件的代码是这样的：

    var foo = bar


可以看到这个变量声明语句并没有以分号结尾。如果第二个 JS 文件中的 IIFE 前面没有放分号，合并的结果就会是这样：

    var foo = bar
    (function() {
        // ...
    })();



第一眼看上去好像是一个赋值操作与一个 IIFE。可是事与愿违，我们把 `bar` 后面的换行去掉就能看清楚了： `bar` 会被当作一个接受函数类型参数的函数……

    var foo = bar(function() {
        // ...
    })();


而防御性分号就可以解决这个问题：

    var foo = bar;
    (function() {
        // ...
    })();


就算这个分号前面什么代码也没有，在语法上其实这也是正确的：它会被当做一个*空声明（empty statement）*，无伤大雅。


JavaScript [自动添加分号](http://www.ecma-international.org/ecma-262/6.0/#sec-automatic-semicolon-insertion)的特性很容易让意想不到的错误发生。我建议你永远显式地写好分号，以防解释器自己添加。


## 用箭头函数代替函数表达式



随着 ECMAScript 2015 的到来，JavaScript 的函数声明方式中又多了一个箭头函数（Arrow Function）。箭头函数与函数表达式同属于表达式而非声明语句。所以我们同样可以用它来创造 IIFE：

    (() => {
        // ...
    })();


不过我并不建议你这么做；我觉得传统的 `function` 关键字写法的可读性要好得多。
