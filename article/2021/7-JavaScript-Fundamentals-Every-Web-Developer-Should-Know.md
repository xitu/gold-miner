> * 原文地址：[7 JavaScript Fundamentals Every Web Developer Should Know](https://betterprogramming.pub/7-javascript-fundamentals-every-web-developer-should-know-8c0f7e491167)
> * 原文作者：[Cristian Salcescu](https://cristiansalcescu.medium.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/7-JavaScript-Fundamentals-Every-Web-Developer-Should-Know.md](https://github.com/xitu/gold-miner/blob/master/article/2021/7-JavaScript-Fundamentals-Every-Web-Developer-Should-Know.md)
> * 译者：
> * 校对者：

## 每个Web开发者都应该知道的 7 个 JavaScript 基础知识

### Functions are values, objects inherit from other objects, and more

![Photo by [Erik Brolin](https://unsplash.com/@erik_brolin?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral).](https://cdn-images-1.medium.com/max/12000/0*s4pg_I-HRI_qKGGM)

在本文中，我们将讨论我认为JavaScript最重要、最独特的一些特性。

## 1. Functions Are Independent Units of Behavior

Functions are units of behavior, but the important part here is that they are independent. In other languages like Java or C#, functions must be declared inside a class. This is not the case in JavaScript.

Functions can be declared in the global scope or defined inside a module as independent units that can be reused.

## 2. Objects Are Dynamic Collections of Props

Objects are indeed just a collection of properties. In other languages, they are called maps, hash maps, or hash tables.

They are dynamic in the sense that, once created, properties can be added, edited, or deleted.

Below is a simple object defined using the object's literal syntax. It has two properties:

    const game = {
      title : 'Settlers',
      developer: 'Ubisoft'
    }

## 3. Objects Inherit From Other Objects

If you are coming from class-based languages like Java or C#, you may be used to classes inheriting from other classes. Again, that is not the case in JavaScript.

Objects inherit from other objects called prototypes.

As mentioned earlier, in this language, objects are collections of properties. When creating an object, it has a “hidden” property called __proto__ that keeps a reference to another object. This referenced object is called a prototype.

Below is an example of creating an empty object (an object with no properties, one may say):

    const obj = {};

Even if it seems to be empty and have no properties, it has a reference to the Object.prototype object. It has the __proto__ hidden property:

    obj.__proto__ === Object.prototype;
    //true

On this kind of object, we can access, for example, the toString method even if we haven’t defined such a method. How is that possible?

This method is inherited from the Object.prototype. When trying to access the method, the engine first tries to find it on the current object, then it looks at the properties of its prototype.

Don’t get misled by the class keyword. It is just syntactic sugar over the prototype system trying to make the language familiar to developers coming from a class-based language.

## 4. Functions Are Values

Functions are values in JavaScript. Like other values, they can be assigned to variables:

    const sum = function(x,y){ return x + y }

This is not something that can be done in any other language.

Like other values, functions can be passed to different functions or returned from functions. Below is an example of a function returning another function:

 <iframe src="https://medium.com/media/05fdebef4666b4521504b135aa7b4685" frameborder=0></iframe>

In the same example, we can see how the returned function from the startsWith function is sent as an argument to the filter array method.

## 5. Functions Can Become Closures

Functions can be defined inside other functions. The inner function can reference variables from the other functions.

What’s more, the inner function can reference variables from the outer function after the outer function has executed. Below is an example of this:

 <iframe src="https://medium.com/media/5f2da0a6d087ea65982f87757c602d99" frameborder=0></iframe>

The count function has access to the x variable from the createCounter parent function even after it has been executed. count is a closure.

## 6. Primitives Are Treated as Objects

JavaScript gives the illusion that primitives are objects by treating them as such. The fact is that primitives are not objects. Primitives are not collections of properties.

However, we can call methods on primitives. For example, we can invoke the toUpperCase method on a string:

    const upperText = 'Minecraft'.toUpperCase();
    console.log(upperText);
    //'MINECRAFT'

A simple text like 'Minecraft' is a primitive and has no methods. JavaScript converts it into an object using the built-in String constructor and then runs the toUpperCase method on the newly created object.

By converting primitives to wrapper objects behind the scenes, JavaScript allows you to call methods on them and thus treats them as objects.

## 7. JavaScript 是一种单线程语言

JavaScript 单线程的。这意味着在特定时间只执行一条语句。

在主线程中，两个函数不能同时执行。

你也许听说过像 [web workers](https://developer.mozilla.org/en-US/docs/Web/Guide/Performance/Using_web_workers) 这种并行执行函数的方式，但是 workers 不会和主线程共享数据。它们只通过信息传递来通信 —— 什么都不是共享的。

这就容易理解了，我们只需要注意让函数执行更快就好了。耗费长时间去执行一个函数会让页面无响应。

谢谢阅读。Happy coding!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。