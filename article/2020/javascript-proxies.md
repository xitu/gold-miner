> * 原文地址：[JavaScript Proxies](https://medium.com/javascript-in-plain-english/javascript-proxies-b41abcdd2bda)
> * 原文作者：[Dornhoth](https://medium.com/@dornhoth)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/javascript-proxies.md](https://github.com/xitu/gold-miner/blob/master/article/2020/javascript-proxies.md)
> * 译者：[Badd](https://juejin.im/user/5b0f6d4b6fb9a009e405dda1)
> * 校对者：[IAMSHENSH](https://github.com/IAMSHENSH)、[Gesj-yean](https://github.com/Gesj-yean)

# 小品 JavaScript Proxy

![图片来自 [Unsplash](https://unsplash.com/s/photos/private?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) 的 [Tim Mossholder](https://unsplash.com/@timmossholder?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/13200/1*MrmHIH3lN9LjMFcWS8GSVQ.jpeg)

Proxy 是一个 ES6 特性，可以用来监控给定对象的访问方式。比如说，我们有一个对象 `alice`，它包含关于 Alice 的一些信息，诸如生日、年龄、身高、体重以及 BMI 值。

```js
const alice = {
  birthdate: '2000-04-06',
  age: 20,
  height: 170,
  weight: 65,
  bmi: 22.5,
};
```

对象中的属性可以像这样来读取和写入：

```js
console.log(alice.height);
console.log(alice.age);
alice.weight = 64;
```

这个对象可能会被其他代码更改，这样就会出现一些问题。我们可以允许对象的外部消费者更改 Alice 的体重，但不能改生日。如果她是成年人，那么她的身高也是不能更改的。当她的体重发生变化，就应该重新计算 BMI 值。而且，她的年龄应该在每次被请求时都计算一次。

有一种思路是创建像 `getAge` 或 `setWeight` 这样的方法。部分情况下这种思路是有效的，但类似 `alice.weight = 64` 这样的操作，它是无法阻止的。原生的 JavaScript 没有私有字段。

原生的 JavaScript 方案是使用代理 —— Proxy。代理只不过是在原始对象（即 **target**）上包装了一层。

```js
const handler = {};
const proxy = new Proxy(alice, handler);
```

调用 `Proxy` 构造器，向它传入 **target** 对象（即本例的 `alice`）、**handler** 作为参数，这样就生成了一个 Proxy 实例。**handler** 是一个对象，我们在其中定义目标对象中每个属性被访问的方式。在本例中，**handler** 是一个空对象，因此 proxy 对象仅仅是把每个访问都原封不动地传达给目标对象。

```js
console.log(proxy.age); // 20
console.log(proxy.height); // 170
```

现在，我们用 **handler** 来定义读取 `age` 属性时的返回值。

```js
const handler = {
  get (target, key) {
    if (key === 'age') {
      return calculateAge(new Date(target.birthdate));
    }
    return target[key];
  }
};
const proxy = new Proxy(alice, handler);
```

如果你在跟着我测试 Proxy 的特性，那么你可以用下面这个 `calculateAge` 函数：

```js
const calculateAge = (birthdate) => {
  const today = new Date();
  let age = today.getFullYear() - birthdate.getFullYear();
  const m = today.getMonth() - birthdate.getMonth();
  if (m < 0 || (m === 0 && today.getDate() < birthdate.getDate())) {
    age--;
  }
  return age;
}
```

现在，我们这个 **handler** 包含了一个 `get` **拦截器（Trap）**。每当我们读取 proxy 对象的任意属性时，这个接收 `target`（即对象 `alice`）和对应的 `key` 为参数的 `get` 函数就会被调用。在读取 `age` 属性时，返回的是根据 `birthdate` 计算得出的值，而非 `alice.age`。而对于其他属性，就只返回 `target[key]`。

你可以这样试试：

```js
alice.age = 22;
console.log(proxy.age); // 20
console.log(proxy.height); // 170
```

我们还可以定义一个 `set` 拦截器，决定属性是否可以被写入、以何种方式写入。例如，我们想防止 birthdate 属性被改写，且在 weight 改变时重新计算 BMI 值：

```js
const handler = {
  get (target, key) {
    ...
  },
  set (target, key, value) {
    if (key === 'birthdate') {
      throw new Error('Birthdate is readonly');
    } else if (key === 'weight') {
      const { height } = target;
      target.bmi = Math.round(
        value / (height / 100 * height / 100) * 100
      ) / 100;
    }
    return true;
  }
};
```

当你试图更改 birthdate 属性的值，你会看到这样的报错信息：

![](https://cdn-images-1.medium.com/max/2000/1*F8c3i-QoEFYTEsXGLSAbiA.png)

而其他属性的值都可以更改（这就是 `return true;` 的作用）。当 weight 的值更新时，BMI 值就会被重新计算。验证代码如下：

```js
console.log(proxy.bmi); // 22.5
proxy.weight = 63;
console.log(proxy.bmi); // 21.8
```

我们可以对像 `age` 和 `height` 这样的其他只读属性进行类似的定义。还可以在只读属性的名称前加上 `_`，然后定义一个 `set` 拦截器，使得每次访问名称开头带有 `_` 的属性时都会抛出一个错误。

顺便提一句，仅当你只访问 `proxy 对象`而不触碰 `alice` 对象时，上述拦截器才起作用。也就是说 `alice` 对象是不应该对外暴露的。

除了 `set` 和 `get`，还有许多的拦截器可以用。比如，你可以按照下列情形定义行为：

* 用 `deleteProperty` 拦截器监控删除属性（`delete alice.height;`）的行为。
* 用 `has` 拦截器监控检查属性是否存在于对象中（`console.log('age' in proxy);`）的行为。
* 用 `defineProperty` 拦截器监控在 proxy 对象上定义新属性（`proxy.name = 'Alice';`）的行为。

Proxy 支持的拦截器有一长列，我只是列举了最常用的几个。你可以点击[这里](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy)查看完整列表。

---

Proxy 使你能够控制属性的访问方式，可否以及如何读取、修改、添加或删除，你几乎可以监控一切对对象的操作行为。它能得力地帮助你在 JavaScript 中实现封装。举个例子，Proxy 可以用来校验合法性（在 `set` 拦截器中写入校验逻辑）、在写入某个属性值之前先更改它（如把 `string` 变为 `Date`），或者跟踪并记录某个对象的变更。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
