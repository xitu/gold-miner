> * 原文地址：[5 Secret features of JSON.stringify()](https://medium.com/javascript-in-plain-english/5-secret-features-of-json-stringify-c699340f9f27)
> * 原文作者：[Prateek Singh](https://medium.com/@prateeksingh_31398)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/5-secret-features-of-json-stringify.md](https://github.com/xitu/gold-miner/blob/master/TODO1/5-secret-features-of-json-stringify.md)
> * 译者：[zoomdong](https://github.com/fireairforce)
> * 校对者：[Long Xiong](https://github.com/xionglong58), [niayyy](https://github.com/niayyy-S)

# JSON.stringify() 的 5 个秘密特性

![Credits: [Kirmeli.com](https://www.google.com/url?sa=i&url=https%3A%2F%2Fahmedalkiremli.com%2Fwhy-to-learn-what-to-learn-and-how-to-learn%2F&psig=AOvVaw3IGik44VGBXe661UZsW5Mh&ust=1581750442478000&source=images&cd=vfe&ved=0CAMQjB1qFwoTCMj-5Oi90OcCFQAAAAAdAAAAABAR)](https://cdn-images-1.medium.com/max/2000/1*aQy1TrGzC_n_UC0j9hXBbw.jpeg)

> JSON.stringify() 方法能将一个 JavaScript 对象或值转换成一个 JSON 字符串。

作为一名 JavaScript 开发人员，`JSON.stringify()` 是用于调试的最常见函数。但是它的作用是什么呢，难道我们不能使用 `console.log()` 来做同样的事情吗？让我们试一试。

```js
//初始化一个 user 对象
const user = {
 "name" : "Prateek Singh",
 "age" : 26
}

console.log(user);

// 结果
// [object Object]
```

哦！`console.log()` 没有帮助我们打印出期望的结果。它输出 `**[object Object]**`，**因为从对象到字符串的默认转换是 `[object Object]`**。因此，我们使用 `JSON.stringify()` 首先将对象转换成字符串，然后在控制台中打印，如下所示。

```js
const user = {
 "name" : "Prateek Singh",
 "age" : 26
}

console.log(JSON.stringify(user));

// 结果
// "{ "name" : "Prateek Singh", "age" : 26 }"
```

---

一般来说，开发人员使用 `stringify` 函数的场景较为普遍，就像我们在上面做的那样。但我要告诉你一些隐藏的秘密，这些小秘密会让你开发起来更加轻松。

## 1: 第二个参数（数组）

是的，`stringify` 函数也可以有第二个参数。它是要在控制台中打印的对象的键数组。看起来很简单？让我们更深入一点。我们有一个对象 **product** 并且我们想知道 product 的 name 属性值。当我们将其打印出来：
 console.log(JSON.stringify(product)); 
它会输出下面的结果。

```js
{"id":"0001","type":"donut","name":"Cake","ppu":0.55,"batters":{"batter":[{"id":"1001","type":"Regular"},{"id":"1002","type":"Chocolate"},{"id":"1003","type":"Blueberry"},{"id":"1004","type":"Devil’s Food"}]},"topping":[{"id":"5001","type":"None"},{"id":"5002","type":"Glazed"},{"id":"5005","type":"Sugar"},{"id":"5007","type":"Powdered Sugar"},{"id":"5006","type":"Chocolate with Sprinkles"},{"id":"5003","type":"Chocolate"},{"id":"5004","type":"Maple"}]}
```

在日志中很难找到 **name** 键，因为控制台上显示了很多没用的信息。当对象变大时，查找属性的难度增加。
stringify 函数的第二个参数这时就有用了。让我们重写代码并查看结果。

```js
console.log(JSON.stringify(product,['name' ]);

// 结果
{"name" : "Cake"}
```

问题解决了，与打印整个 JSON 对象不同，我们可以在第二个参数中将所需的键作为数组传递，从而只打印所需的属性。

## 2: 第二个参数（函数）

我们还可以传入函数作为第二个参数。它根据函数中写入的逻辑来计算每个键值对。如果返回 `undefined`，则不会打印键值对。请参考示例以获得更好的理解。

```js
const user = {
 "name" : "Prateek Singh",
 "age" : 26
}
```

![Passing function as 2nd argument](https://cdn-images-1.medium.com/max/2000/1*V3EQcCdgRLDish8PkY0s5A.png)

```js
// 结果
{ "age" : 26 }
```

只有 `age` 被打印出来，因为函数判断 `typeOf` 为 String 的值返回 `undefined`。

## 3: 第三个参数为数字

第三个参数控制最后一个字符串的间距。如果参数是一个**数字**，则字符串化中的每个级别都将缩进这个数量的空格字符。

```js
// 注意：为了达到理解的目的，使用 '--' 替代了空格

JSON.stringify(user, null, 2);
//{
//--"name": "Prateek Singh",
//--"age": 26,
//--"country": "India"
//}
```

## 4: 第三个参数为字符串

如果第三个参数是 **string**，那么将使用它来代替上面显示的空格字符。

```js
JSON.stringify(user, null,'**');
//{
//**"name": "Prateek Singh",
//**"age": 26,
//**"country": "India"
//}
// 这里 * 取代了空格字符
```

## 5: toJSON 方法

我们有一个叫 `toJSON` 的方法，它可以作为任意对象的属性。`JSON.stringify` 返回这个函数的结果并对其进行序列化，而不是将整个对象转换为字符串。参考下面的例子。

```js
const user = {
 firstName : "Prateek",
 lastName : "Singh",
 age : 26,
 toJSON() {
    return { 
      fullName: `${this.firstName} + ${this.lastName}`
    };
 }
}

console.log(JSON.stringify(user));

// 结果
// "{ "fullName" : "Prateek Singh"}"
```

这里我们可以看到，它只打印 `toJSON` 函数的结果，而不是打印整个对象。

我希望你能学到 `stringify()` 的一些基本特征。

如果你觉得这篇文章有用，请点赞，然后跟我读更多类似的精彩文章。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
