> * 原文地址：[Aspect-Oriented Programming in JavaScript](https://blog.bitsrc.io/aspect-oriented-programming-in-javascript-c4cb43f6bfcc)
> * 原文作者：[Fernando Doglio](https://medium.com/@deleteman123)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/aspect-oriented-programming-in-javascript.md](https://github.com/xitu/gold-miner/blob/master/article/2020/aspect-oriented-programming-in-javascript.md)
> * 译者：[Liusq-Cindy](https://github.com/Liusq-Cindy)
> * 校对者：[Chorer](https://github.com/Chorer)、[nia3y](https://github.com/nia3y)

# JavaScript 的面向切面编程

![Image by [Arturs Budkevics](https://pixabay.com/users/artursfoto-3533503/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=1744952) from [Pixabay](https://pixabay.com/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=1744952)](https://cdn-images-1.medium.com/max/3840/1*sfjo3NiG4oHxwXQpdqCu9g.jpeg)

我们都知道面向对象编程，或者至少听说过 JavaScript 领域的函数式编程，但是，你听说过面向切面编程吗？

我知道，它听起来像是《魔法战队》中某一集出现的东西。然而，AOP 是实际存在的。此外，虽然我们现在没有使用它，但它却可以被应用于我们日常会见到的一些用例中。

它最大的优势在于，你可以毫不费力的将 AOP 与 FP 或 OOP 结合使用，就像 JavaScript 中的 OOP 和 FP 一样。 因此，首先让我们了解这个切面的作用，以及它对 JavaScript 开发人员的实际用途。

## AOP 简介

面向切面编程给我们提供了一个方法，让我们可以在不修改目标逻辑的情况下，将代码注入到现有的函数或对象中。

虽然不是必须的，但注入的代码意味着具有横切关注点，比如添加日志功能、调试元数据或其它不太通用的但可以注入额外的行为，而不影响原始代码的内容。

给你举一个合适的例子，假设你已经写好了业务逻辑，但是现在你意识到没有添加日志代码。通常的方法是将日志逻辑集中到一个新的模块中，然后逐个函数添加日志信息。

然而，如果你可以获取同一个日志程序，在你想要记录的每个方法执行过程中的特定节点，只需一行代码就可将程序注入，那么这肯定会给你带来很多便利。难道不是吗？

#### 切面、通知和切点（是什么、在何时、在何地）

为了使上面的定义更形式化一点，让我们以日志程序为例，介绍有关 AOP 的三个概念。如果你决定进一步研究这个范式，这些将对你有所帮助：

* **切面 (**是什么**)：** 这是你想要注入到你的目标代码的 “切面” 或者行为。在我们的上下文环境（JavaScript）中，这指的是封装了你想要添加的行为的函数。
* **通知 (**在何时**)：** 你希望这个切面什么时候执行？“通知” 指定了你想要执行切面代码的一些常见的时刻，比如 “before”、“after”、“around”、“whenThrowing” 等等。反过来，它们指的是与代码执行相关的时间点。对于在代码执行后引用的部分，这个切面将拦截返回值，并可能在需要时覆盖它。
* **切点 (**在何地**)：** 他们引用了你想要注入的切面在你的目标代码中的位置。理论上，你可以明确指定在目标代码中的任何位置去执行切面代码。实际上这并不现实，但你可以潜在地指定，比如：“我的对象中的所有方法”，或者“仅仅是这一个特定方法”，或者我们甚至可以使用“所有以 `get_` 开头的方法”之类的内容。

有了这些解释，你会发现创建一个基于 AOP 的库来向现有的基于 OOP 的业务逻辑（举个例子）添加日志逻辑是相对容易的。你所要做的就是用一个自定义函数替换目标对象现有的匹配方法，该自定义函数会在适当的时间点添加切面逻辑，然后再调用原有的方法。

## 基本实现

因为我是一个视觉学习者，所以我认为，展示一个基本的例子说明如何实现一种 `切面` 方法来添加基于 AOP 的行为将是个漫长的过程。

下面的示例将阐明实现它有多容易以及它给你的代码带来的好处。

```JavaScript
/** 用于获取一个对象中所有方法的帮助函数 */
const getMethods = (obj) => Object.getOwnPropertyNames(Object.getPrototypeOf(obj)).filter(item => typeof obj[item] === 'function')

/** 将原始方法替换为自定义函数，该函数将在通知指示时调用我们的切面 */
function replaceMethod(target, methodName, aspect, advice) {
    const originalCode = target[methodName]
    target[methodName] = (...args) => {
        if(["before", "around"].includes(advice)) {
            aspect.apply(target, args)
        }
        const returnedValue = originalCode.apply(target, args)
        if(["after", "around"].includes(advice)) {
            aspect.apply(target, args)
        }
        if("afterReturning" == advice) {
            return aspect.apply(target, [returnedValue])
        } else {
            return returnedValue
        }
    }
}

module.exports = {
    // 导出的主要方法：在需要的时间和位置将切面注入目标
    inject: function(target, aspect, advice, pointcut, method = null) {
        if(pointcut == "method") {
            if(method != null) {
                replaceMethod(target, method, aspect, advice)    
            } else {
                throw new Error("Tryin to add an aspect to a method, but no method specified")
            }
        }
        if(pointcut == "methods") {
            const methods = getMethods(target)
            methods.forEach( m => {
                replaceMethod(target, m, aspect, advice)
            })
        }
    }
}
```

非常简单，正如我提到的，上面的代码并没有涵盖所有的用例，但是它应该足以涵盖下一个示例。

但是在我们往下看之前，注意一下这个 `replaceMethod` 函数，这就是“魔法”生效的地方。它能够创建新函数，也可以决定我们何时调用我们的切面以及如何处理它的返回值。

接下来说明这个库的用法：

```JavaScript
const AOP = require("./aop.js")

class MyBussinessLogic {

    add(a, b) {
        console.log("Calling add")
        return a + b
    }

    concat(a, b) {
        console.log("Calling concat")
        return a + b
    }

    power(a, b) {
        console.log("Calling power")
        return a ** b
    }
}

const o = new MyBussinessLogic()

function loggingAspect(...args) {
    console.log("== Calling the logger function ==")
    console.log("Arguments received: " + args)
}

function printTypeOfReturnedValueAspect(value) {
    console.log("Returned type: " + typeof value)
}

AOP.inject(o, loggingAspect, "before", "methods")
AOP.inject(o, printTypeOfReturnedValueAspect, "afterReturning", "methods")

o.add(2,2)
o.concat("hello", "goodbye")
o.power(2, 3)
```

这只是一个包含三个方法的基本对象，没什么特别的。我们想要去注入两个通用的切面，一个用于记录接收到的属性，另一个用于分析他们的返回值并记录他们的类型。两个切面，两行代码（并不需要六行代码）。

这个示例到这里就结束了，这里是你将得到的输出：

![](https://cdn-images-1.medium.com/max/2000/1*9KZBwObbqAEuJAv1GWSryg.png)

## AOP 的优点

在知道了 AOP 的概念及用途后，也行你已经猜到了为什么人们会想要使用面向切面编程，不过还是让我们做一个快速汇总吧：

* **封装横切关注点的好方法**。我非常喜欢封装，因为它意味着更容易阅读和维护可以在整个项目中重复使用的代码。
* **灵活的逻辑**。在注入切面时，围绕通知和切入点实现的逻辑可以为你提供很大的灵活性。反之这又有助于你动态地打开和关闭代码逻辑的不同切面（有意的双关）。
* **跨项目重复使用切面**。你可以将切面视为组件，即可以在任何地方运行的小的、解耦的代码片段。如果你正确地编写了切面代码，就可以轻松地在不同的项目中共享它们。

## AOP 的主要问题

因为并非每件事都是完美的，这种范式遭到了一些批评者的反对。

他们提出的主要问题是，它的主要的优势实际上隐藏了代码逻辑和复杂性，在不太清楚的情况下可能会产生副作用。

如果你仔细想想，他们说的有一定道理，AOP 给了你很多能力，可以将无关的行为添加到现有的方法中，甚至可以替换它们的整个逻辑。当然，这可能不是引入此范式的确切原因，而且它肯定不是我上面提供的示例的意图。

然而，它确实可以让你去做任何你想做的事情，再加上缺乏对良好编程实践的理解，可能会导致非常大的混乱。

为了不让自己听起来太老套，我转述一下 Uncle Ben 的话:

> 能力越大，责任越大

如果你想正确地使用 AOP ，那么就必须理解软件开发的最佳实践。

在我看来，仅仅因为你使用这个工具之后可能会带来很大的损害，并不足以说明这个工具就是不好的，因为它也会带来很多的好处（即你可以将很多常见的逻辑提取到一个集中的位置，并可以在你需要的任何地方用一行代码注入它）。对我来说，这是一个强大的工具，值得学习，也绝对值得使用。

---

面向切面编程是 OOP 的完美补充，特别是得益于 JavaScript 的动态特性，我们可以非常容易地实现它（如这里的代码演示）。它提供了强大的功能，能够对大量逻辑进行模块化和解耦，以后甚至可以与其他项目共享这些逻辑。

当然，如果你不正确地使用它，你会把事情搞得一团糟。但是你绝对可以利用它来简化和清理大量的代码。这就是我对 AOP 的看法，你呢？你曾经听说过 AOP 吗？你以前使用过它吗？请在下面留言并分享你的想法！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
