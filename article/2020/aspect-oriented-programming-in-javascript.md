> * 原文地址：[Aspect-Oriented Programming in JavaScript](https://blog.bitsrc.io/aspect-oriented-programming-in-javascript-c4cb43f6bfcc)
> * 原文作者：[Fernando Doglio](https://medium.com/@deleteman123)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/aspect-oriented-programming-in-javascript.md](https://github.com/xitu/gold-miner/blob/master/article/2020/aspect-oriented-programming-in-javascript.md)
> * 译者：
> * 校对者：

# Aspect-Oriented Programming in JavaScript

#### We all know about Object-Oriented Programming and Functional Programming, but have you heard about Aspect-Oriented Programming before?

![Image by [Arturs Budkevics](https://pixabay.com/users/artursfoto-3533503/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=1744952) from [Pixabay](https://pixabay.com/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=1744952)](https://cdn-images-1.medium.com/max/3840/1*sfjo3NiG4oHxwXQpdqCu9g.jpeg)

We all know about Object-Oriented Programming, and we’ve probably, at least, heard of Functional Programming in the JavaScript world, but have you ever heard of Aspect-Oriented Programming?

I know, it sounds like something you would hear in an episode of Power Rangers Mystic Force. However, AOP is a thing, and not only that, it’s a thing we’re not using and could use for several common use cases we see every day.

And the best part of it all is that just like with OOP and FP in JavaScript, you can use a mixture of AOP with FP or OOP without breaking a sweat. So let’s first understand what this aspect deal is, and how useful it can really be for JavaScript developers.

---

## A brief introduction to AOP

Aspect-Oriented Programming provides a way for us to inject code into existing functions or objects, without modifying the target logic.

The injected code, although not required, is meant to have cross-cutting concerns, such as adding logging functionality, debugging metadata, or something less generic, but that could inject extra behavior without affecting the original code.

To give you a good example, imagine having written your business logic but now you realize that you have no logging code. The normal approach to this would be to centralize your logging logic inside a new module and the go function by function adding logging information.

However, if you could grab that same logger and inject it into every method you’re looking to log, at very specific points during their execution with a single line of code, then this would definitely give you a lot of value. Wouldn’t you agree?

#### Aspects, Advice, and Pointcuts or What, When, and Where

In order to formalize a bit the definition above, let’s take the example of the logger and cover these 3 concepts about AOP that are going to help you out if you decide to look further into this paradigm:

* **Aspects (**What**):** These are the “aspects” or behavior you’re looking to inject into your target code. In our context (JavaScript), these will be functions that encapsulate the behavior you’re looking to add.
* **Advice (**When**):** When do you want the aspect to run? They specify some common moments when you want your aspect’s code to be executed, such as “before”, “after”, “around”, “whenThrowing”, and the like. They, in turn, refer to the moment in time-related to the execution of the code. For the ones referring to after the code is executed, the aspects will intercept the returned value and potentially overwrite it if they needed to.
* **Pointcut (**Where**):** They reference the place in your target code where you want to inject the aspect. In theory, you could pinpoint anywhere in your target code when you want your code to be executed. In practice, this is not that realistic, but you can potentially specify things such as: “all methods of my object”, or “only this particular method”, or we could even get fancy with something like “all methods starting with get_”.

With this explanation, you could argue that creating an AOP-based library to add logging logic to existing OOP-based business logic (for example) is relatively easy. All you’d have to do is replace the existing matching methods of the target object, with a custom function that would add the aspect’s logic at the right time and then call the original method.

---

## A basic implementation

Just because I’m a visual learner, I think showing a basic example of how you’d go about implementing a sort of `inject` method to add AOP-based behavior would come a long way.

The following example should clarify both, how easy it is to implement it and the type of benefits it brings to your code.

```JavaScript

/** Helping function used to get all methods of an object */
const getMethods = (obj) => Object.getOwnPropertyNames(Object.getPrototypeOf(obj)).filter(item => typeof obj[item] === 'function')

/** Replace the original method with a custom function that will call our aspect when the advice dictates */
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
    //Main method exported: inject the aspect on our target when and where we need to
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

Very simple, as I mentioned, the above code doesn’t cover every use case, but it should be enough to cover the next example.

But before we move forward, notice the `replaceMethod` function, that’s where all the magic happens. That’s where the new function is created and where we decide when to call our aspect and what to do with its returned value.

And here is how you’d use our new library:

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

Nothing too fancy, a basic object with 3 methods. We want to inject two aspects that are generic to all of them. One to log the attributes received and one to analyze their returned value and log their type. Two aspects, two lines of code (instead of the six we would need).

And to close this example here is the output you’d get:

![](https://cdn-images-1.medium.com/max/2000/1*9KZBwObbqAEuJAv1GWSryg.png)

---

## Benefits of AOP

Now that you’ve seen what it is and what it does, you’ve probably guessed why people would want to use Aspect-Oriented Programming, but let’s quickly do a round-up:

* **Great way to encapsulate cross-cutting concerns**. I’m a big fan of encapsulation because it means you get easier to read and easier to maintain code that can be re-used all across your project.
* **Flexible logic**. The logic around your implementation of the advice and pointcuts can give you a lot of flexibility when it comes to injecting your aspects. This in turn can help to dynamically turn on and off different aspects (pun definitely intended) of your logic.
* **Re-use aspects across projects.** You can think of aspects as components, small and decoupled pieces of code that can run anywhere. If you write your aspects correctly, you can share them across different projects with ease.

## The main problem with AOP

Because not everything is perfect, some detractors speak against this paradigm.

Their main problem with it is that its main benefit is actually hiding logic and complexity, potentially causing side effects without being too clear about it.

And if you think about it, they’re kind of right, AOP gives you a lot of power to add unrelated behavior into existing methods or even replace their entire logic. Of course, that might not be exactly why this pattern was introduced, and it’s certainly not the intention of the example I provided above.

However, it does provide you with the ability to do whatever you want, and that, coupled with a lack of understanding of good programming practices, can cause a really big mess.

And without trying to sound too cliched here, paraphrasing Uncle Ben:

> # With big power, comes great responsibility

And with AOP comes the obligation to understand software development best practices if you want to use it correctly.

But if you ask me, just because with this tool you can cause a lot of harm, it doesn’t mean it’s bad, because you can also cause a lot of good (i.e you can extract a lot of common logic into a centralized location and inject it wherever you need, with a single line of code). That to me is a powerful tool worth learning about and definitely, worth using.

---

Aspect-Oriented Programming is a perfect complement to OOP, especially thanks to JavaScript’s dynamic nature, we can implement it very easily (as demonstrated here). It provides a great level of power, the ability to modularize and decouple a lot of logic that you can later even share with other projects.

You can make a mess if you don’t use it properly, yes, but you can definitely take advantage of it to simplify and clean a lot of code. That’s what I think about AOP anyway, what about you? Have you heard of AOP before? Have you used it in the past? Leave a comment down below and share your thoughts about it!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
