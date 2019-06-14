> * 原文地址：[8 Useful JavaScript Tricks](https://devinduct.com/blogpost/26/8-useful-javascript-tricks)
> * 原文作者：[Milos Protic](https://devinduct.com/blogpost/26/8-useful-javascript-tricks)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/8-useful-javascript-tricks.md](https://github.com/xitu/gold-miner/blob/master/TODO1/8-useful-javascript-tricks.md)
> * 译者：[Xuyuey](https://github.com/Xuyuey)
> * 校对者：[twang1727](https://github.com/twang1727), [smilemuffie](https://github.com/smilemuffie)

# 8 个实用的 JavaScript 技巧

## 介绍

每种编程语言都它独特的技巧。其中很多都是为开发人员所熟知的，但其中一些相当的 hackish。在这边篇文章中，我将向你展示一些我觉得有用的技巧。其中一些我在实践中使用过，而另一些则是解决老问题的新方法。Enjoy！

## 1. 确保数组的长度

不知道你是否遇见过这样的情况，在处理网格结构的时候，如果原始数据每行的长度不相等，就需要重新创建该数据。好吧，我遇到过！为了确保每行的数据长度相等，你可以使用 `Array.fill` 方法。

```js
let array = Array(5).fill('');
console.log(array); // 输出（5）["", "", "", "", ""]
```

## 2. 数组去重

ES6 提供了几种非常简洁的数组去重的方法。但不幸的是，它们并不适合处理非基本类型的数组。稍后你可以在[棘手的数组去重](https://devinduct.com/blogpost/17/handling-array-duplicates-can-be-tricky)一文中读到更多有关它的信息。这里我们只关注基本类型的数组去重。

```js
const cars = [
    'Mazda', 
    'Ford', 
    'Renault', 
    'Opel', 
    'Mazda'
]
const uniqueWithArrayFrom = Array.from(new Set(cars));
console.log(uniqueWithArrayFrom); // 输出 ["Mazda", "Ford", "Renault", "Opel"]

const uniqueWithSpreadOperator = [...new Set(cars)];
console.log(uniqueWithSpreadOperator);// 输出 ["Mazda", "Ford", "Renault", "Opel"]
```

## 3. 用扩展运算符合并对象和对象数组

合并对象并不是一个罕见的问题，你很有可能已经遇到过这个问题，并且在不远的未来还会再次遇到。不同的是，在过去你手动完成了大部分工作，但从现在开始，你将使用 ES6 的新功能。

```js
// 合并对象
const product = { name: 'Milk', packaging: 'Plastic', price: '5$' }
const manufacturer = { name: 'Company Name', address: 'The Company Address' }

const productManufacturer = { ...product, ...manufacturer };
console.log(productManufacturer); 
// 输出 { name: "Company Name", packaging: "Plastic", price: "5$", address: "The Company Address" }

// 将对象数组合并成一个对象
const cities = [
    { name: 'Paris', visited: 'no' },
    { name: 'Lyon', visited: 'no' },
    { name: 'Marseille', visited: 'yes' },
    { name: 'Rome', visited: 'yes' },
    { name: 'Milan', visited: 'no' },
    { name: 'Palermo', visited: 'yes' },
    { name: 'Genoa', visited: 'yes' },
    { name: 'Berlin', visited: 'no' },
    { name: 'Hamburg', visited: 'yes' },
    { name: 'New York', visited: 'yes' }
];

const result = cities.reduce((accumulator, item) => {
  return {
    ...accumulator,
    [item.name]: item.visited
  }
}, {});

console.log(result);
/* 输出
Berlin: "no"
Genoa: "yes"
Hamburg: "yes"
Lyon: "no"
Marseille: "yes"
Milan: "no"
New York: "yes"
Palermo: "yes"
Paris: "no"
Rome: "yes"
*/
```

## 4. 数组映射（不使用 `Array.map`）

你知道这里有另外一种方法可以实现数组映射，而不使用 `Array.map` 吗？如果不知道，请继续往下看。

```js
const cities = [
    { name: 'Paris', visited: 'no' },
    { name: 'Lyon', visited: 'no' },
    { name: 'Marseille', visited: 'yes' },
    { name: 'Rome', visited: 'yes' },
    { name: 'Milan', visited: 'no' },
    { name: 'Palermo', visited: 'yes' },
    { name: 'Genoa', visited: 'yes' },
    { name: 'Berlin', visited: 'no' },
    { name: 'Hamburg', visited: 'yes' },
    { name: 'New York', visited: 'yes' }
];

const cityNames = Array.from(cities, ({ name}) => name);
console.log(cityNames);
// 输出 ["Paris", "Lyon", "Marseille", "Rome", "Milan", "Palermo", "Genoa", "Berlin", "Hamburg", "New York"]
```

## 5. 根据条件添加对象属性

现在，你不再需要根据条件创建两个不同的对象，以使其具有特定属性。扩展操作符将是一个完美的选择。

```js
const getUser = (emailIncluded) => {
  return {
    name: 'John',
    surname: 'Doe',
    ...(emailIncluded ? { email : 'john@doe.com' } : null)
  }
}

const user = getUser(true);
console.log(user); // 输出 { name: "John", surname: "Doe", email: "john@doe.com" }

const userWithoutEmail = getUser(false);
console.log(userWithoutEmail); // 输出 { name: "John", surname: "Doe" }
```

## 6. 解构原始数据

你曾经有处理过拥有非常多属性的对象吗？我相信你一定有过。可能最常见的情况是我们有一个用户对象，它包含了所有的数据和细节。这里，我们可以调用新的 ES 解构方法来处理这个大麻烦。让我们看看下面的例子。

```js
const rawUser = {
   name: 'John',
   surname: 'Doe',
   email: 'john@doe.com',
   displayName: 'SuperCoolJohn',
   joined: '2016-05-05',
   image: 'path-to-the-image',
   followers: 45
   ...
}
```

通过把上面的对象分成两个，我们可以用更能传递上下文含义的方式来表示这个对象，如下所示：

```js
let user = {}, userDetails = {};
({ name: user.name, surname: user.surname, ...userDetails } = rawUser);

console.log(user); // 输出 { name: "John", surname: "Doe" }
console.log(userDetails); // 输出 { email: "john@doe.com", displayName: "SuperCoolJohn", joined: "2016-05-05", image: "path-to-the-image", followers: 45 }
```

## 7. 动态设置对象属性名

在过去，如果我们需要动态设置对象的属性名，我们必须首先声明一个对象，然后再给它分配一个属性。这不可能以单纯声明的方式实现。今时不同往日，现在我们可以通过 ES6 的功能实现这一目标。

```js
const dynamic = 'email';
let user = {
    name: 'John',
    [dynamic]: 'john@doe.com'
}
console.log(user); // 输出 { name: "John", email: "john@doe.com" }
```

## 8. 字符串插值

最后尤为重要的是拼接字符串的新方法。如果你想在一个辅助程序中构建模版字符串，这会非常有用。它使动态连接字符串模版变得更简单了。

```js
const user = {
  name: 'John',
  surname: 'Doe',
  details: {
    email: 'john@doe.com',
    displayName: 'SuperCoolJohn',
    joined: '2016-05-05',
    image: 'path-to-the-image',
    followers: 45
  }
}

const printUserInfo = (user) => { 
  const text = `The user is ${user.name} ${user.surname}. Email: ${user.details.email}. Display Name: ${user.details.displayName}. ${user.name} has ${user.details.followers} followers.`
  console.log(text);
}

printUserInfo(user);
// 输出 'The user is John Doe. Email: john@doe.com. Display Name: SuperCoolJohn. John has 45 followers.'
```

## 总结

JavaScript 的世界正在迅速扩展。这里有许多很酷的功能，可以随时使用。棘手和耗时的问题正逐渐淡出过去，而且借助 ES6 的新功能，我们有了很多开箱即用的新解决方案。

这就是今天我想分享的全部内容。如果你也喜欢这篇文章，请转发或者点赞呦。

谢谢你的阅读，我们下次再见。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
