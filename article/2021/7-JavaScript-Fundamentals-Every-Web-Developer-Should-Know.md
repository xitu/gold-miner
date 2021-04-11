> * 原文地址：[7 JavaScript Fundamentals Every Web Developer Should Know](https://betterprogramming.pub/7-javascript-fundamentals-every-web-developer-should-know-8c0f7e491167)
> * 原文作者：[Cristian Salcescu](https://cristiansalcescu.medium.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/7-JavaScript-Fundamentals-Every-Web-Developer-Should-Know.md](https://github.com/xitu/gold-miner/blob/master/article/2021/7-JavaScript-Fundamentals-Every-Web-Developer-Should-Know.md)
> * 译者：[Hyde Song](https://github.com/HydeSong)
> * 校对者：[PassionPenguin](https://github.com/PassionPenguin)、[greycodee](https://github.com/greycodee)

# 每位 Web 开发者都应该知道的 7 个 JavaScript 基础知识

### 函数是值，对象继承其他对象等等

![[Erik Brolin](https://unsplash.com/@erik_brolin?utm_source=medium&utm_medium=referral) 拍摄，发布在 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)。](https://cdn-images-1.medium.com/max/12000/0*s4pg_I-HRI_qKGGM)

在本文中，我们将讨论我认为 JavaScript 最重要、最独特的一些特性。

## 1、函数是独立的行为单元

函数是基本单位，但这里重要的一点是，函数是独立的！在 Java 或 C# 等其他语言中，函数必须在类内声明，但在 JavaScript 中不是这样的。

函数可以在全局中被定义，也可以在模块里定义为可重用的单位。

## 2、对象是属性的动态集合

对象实际上只是属性的集合。在其他语言中，它们被称为 Map、HashMap 或 HashTable。

对象是动态的，即一旦创建，就可以添加、编辑或删除属性。

下面是一个使用字面量语法定义的简单对象。它有两个属性：

```js
const game = {
  title : 'Settlers',
  developer: 'Ubisoft'
}
```

## 3、对象继承自其他对象

如果你曾经使用的语言是类似于 Java 或 C# 等基于 `class` 的语言，你可能习惯于从其他 `class` 继承 `class`。但是，JavaScript 不是这样的。

对象继承自称为 `prototypes` 的对象。

如前所述，在这种语言中，对象是属性的集合。当创建一个对象时，他有一个名为 `__proto__` 的隐藏属性，它引用其他对象。这个被引用的对象称为 `prototype`。

下面是一个创建空对象的例子（可以说，没有属性的对象）：

```js
const obj = {};
```

即使 obj 看起来是空的没有任何属性，它实际上也是有一个隐藏属性 `__proto__` 的：

```js
obj.__proto__ === Object.prototype;
//true
```

在这类对象上，我们可以访问还没有定义的方法，例如 `toString` 方法，即使我们还没有定义这样的方法。这怎么可能呢？

此方法继承自 `Object.prototype`。当尝试访问该方法时，JS 引擎首先尝试在当前对象上查找该方法，然后再查找其原型上的属性。

不要被 `class` 关键字误导了。`class` 只是原型系统的语法糖，帮助来自基于 `class` 语言的开发者熟悉 JavaScript。

## 4、函数就是值

在 JavaScript 中，函数就是值。就像其他值一样，函数可以赋值给变量：

```js
const sum = function(x,y){ return x + y }
```
这在其他编程语言中是做不到的。

与其他值一样，函数可以传递给不同的函数或被函数返回。下面是一个函数返回另一个函数的示例：

```js
function startsWith(text){
  return function(name){
    return name.startsWith(text);
  }
}

const games = ['Fornite', 'Overwatch', 'Valorant'];
const newGames = games.filter(startsWith('Fo'));
console.log(newGames);
//["Fornite"]
```

在同一个示例中，我们可以看到 `startsWith` 函数返回的函数是如何作为参数发送到 `filter` 数组方法的。

## 5、函数可以闭包

函数内部可以定义函数。内部函数可以引用其他函数的变量。

而且，外部函数执行后，内部函数可以引用外部函数的变量。下面是关于这方面的例子；

```js
function createCounter(){
  let x = 0;
  return function(){
    x = x + 1;
    return x;
  }
}

const count = createCounter();
console.log(count());//1
console.log(count());//2
console.log(count());//3
```

`count` 函数可以从 `createCounter` 父函数访问 `x` 变量，即使在执行之后也是如此。`count` 就是闭包函数。

## 6、基本数据类型被视为对象

JavaScript 把基本类型当作对象，从而给人一种错觉。实际上，基本类型并不是对象. 基本类型不是属性的集合。

然而，我们可以在基本类型上调用方法。比如，我们可以在字符串上调用 `toUpperCase` 方法：

```js
const upperText = 'Minecraft'.toUpperCase();
console.log(upperText);
//'MINECRAFT'
```

像 `Minecraft` 这样的简单文本是基本类型，自身没有任何方法。不过 JavaScript 会使用内置的 String 构造函数将其转换为对象，然后我们就能够对新创建的对象执行 `toUpperCase` 方法。

通过在底层把基本类型转换为包装对象，JavaScript 允许你调用方法，从而视它们为对象。

## 7、JavaScript 是一种单线程语言

JavaScript 单线程的。这意味着在特定时间只执行一条语句。

在主线程中，两个函数不能同时执行。

你也许听说过像 [web workers](https://developer.mozilla.org/en-US/docs/Web/Guide/Performance/Using_web_workers) 这种并行执行函数的方式，但是 workers 不会和主线程共享数据。它们只通过信息传递来通信 —— 什么都不是共享的。

这就容易理解了，我们只需要注意让函数执行更快就好了。耗费长时间去执行一个函数会让页面无响应。

谢谢阅读。编码快乐!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
