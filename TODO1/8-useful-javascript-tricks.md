> * 原文地址：[8 Useful JavaScript Tricks](https://devinduct.com/blogpost/26/8-useful-javascript-tricks)
> * 原文作者：[Milos Protic](https://devinduct.com/blogpost/26/8-useful-javascript-tricks)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/8-useful-javascript-tricks.md](https://github.com/xitu/gold-miner/blob/master/TODO1/8-useful-javascript-tricks.md)
> * 译者：
> * 校对者：

# 8 Useful JavaScript Tricks

## Introduction

Each programming language has its own tricks up in its sleeve. Many of them are known to developers, and yet some of them are pretty hackish. In this article, I will show you a couple of tricks I find useful. Some of them I've used in practice and others are the new way of solving old problems. Enjoy!

## 1. Ensure Array Values

Ever worked on a grid where the raw data needs to be recreated with the possibility that columns length might mismatch for each row? Well, I have! For ensuring the length equality between the mismatching rows you can use `Array.fill` method.

```js
let array = Array(5).fill('');
console.log(array); // outputs (5) ["", "", "", "", ""]
```

## 2. Get Array Unique Values

ES6 provides a couple of very neat ways of extracting the unique values from an array. Unfortunately, they do not do well with arrays filled with non-primitive types. You can read more about it later at this link [Handling Array Duplicates Can Be Tricky](https://devinduct.com/blogpost/17/handling-array-duplicates-can-be-tricky). In this article, we will focus on the primitive data types.

```js
const cars = [
    'Mazda', 
    'Ford', 
    'Renault', 
    'Opel', 
    'Mazda'
]
const uniqueWithArrayFrom = Array.from(new Set(cars));
console.log(uniqueWithArrayFrom); // outputs ["Mazda", "Ford", "Renault", "Opel"]

const uniqueWithSpreadOperator = [...new Set(cars)];
console.log(uniqueWithSpreadOperator);// outputs ["Mazda", "Ford", "Renault", "Opel"]
```

## 3. Merge Objects and Array of Objects Using Spread Operator

Object merging is not a rare task and there is a great chance you've done this in the past and that you will do it in the future. The difference is that in the past you did most of the work manually, but now and in the future, you will use new ES6 features.

```js
// merging objects
const product = { name: 'Milk', packaging: 'Plastic', price: '5$' }
const manufacturer = { name: 'Company Name', address: 'The Company Address' }

const productManufacturer = { ...product, ...manufacturer };
console.log(productManufacturer); 
// outputs { name: "Company Name", packaging: "Plastic", price: "5$", address: "The Company Address" }

// merging an array of objects into one
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
/* outputs
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

## 4. Map the Array (without the `Array.map`)

Did you know that there is another way of mapping the array values which doesn't include the `Array.map` method? If not, check it out below.

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
// outputs ["Paris", "Lyon", "Marseille", "Rome", "Milan", "Palermo", "Genoa", "Berlin", "Hamburg", "New York"]
```

## 5. Conditional Object Properties

It's no longer needed to create two different objects based on a condition in order for it to have a certain property. For this purpose, the spread operator is the perfect fit.

```js
const getUser = (emailIncluded) => {
  return {
    name: 'John',
    surname: 'Doe',
    ...(emailIncluded ? { email : 'john@doe.com' } : null)
  }
}

const user = getUser(true);
console.log(user); // outputs { name: "John", surname: "Doe", email: "john@doe.com" }

const userWithoutEmail = getUser(false);
console.log(userWithoutEmail); // outputs { name: "John", surname: "Doe" }
```

## 6. Destructuring the Raw Data

Have you ever worked with an object with too much data in it? I'm pretty sure you have. Probably the most common situation is when we have a user object containing the overall data together with details. Here we can call the new ES destructuring feature to the rescue. Let's back up this with an example.

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

The object above can be represented in a more contextual manner by splitting into two, like this:

```js
let user = {}, userDetails = {};
({ name: user.name, surname: user.surname, ...userDetails } = rawUser);

console.log(user); // outputs { name: "John", surname: "Doe" }
console.log(userDetails); // outputs { email: "john@doe.com", displayName: "SuperCoolJohn", joined: "2016-05-05", image: "path-to-the-image", followers: 45 }
```

## 7. Dynamic Property Names

Back in the days, we would first have to declare an object and then assign a property if that property name needed to be dynamic. This was not possible to achieve in a declarative manner. These days are behind us and with the ES6 features, we can do this.

```js
const dynamic = 'email';
let user = {
    name: 'John',
    [dynamic]: 'john@doe.com'
}
console.log(user); // outputs { name: "John", email: "john@doe.com" }
```

## 8. String Interpolation

Last but not least is the new way of concatenating strings. The use-case where this can really shine is if you're building a template based helper components. It makes dynamic template concatenation a lot easier.

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
// outputs 'The user is John Doe. Email: john@doe.com. Display Name: SuperCoolJohn. John has 45 followers.'
```

## Conclusion

JavaScript world is expanding rapidly. A lot of cool features are here and ready to be used. Problems that were tricky and time-consuming are slowly fading into the past, and with ES6 new features, the solutions are provided out of the box.

That's all I have for today. If you liked this article please do share/like it.

Thanks for reading and see you in the next post.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
