> * 原文地址：[JavaScript Clean Code - Best Practices](https://devinduct.com/blogpost/22/javascript-clean-code-best-practices)
> * 原文作者：[Milos Protic](https://devinduct.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/javascript-clean-code-best-practices.md](https://github.com/xitu/gold-miner/blob/master/TODO1/javascript-clean-code-best-practices.md)
> * 译者：[xilihuasi](https://github.com/xilihuasi)
> * 校对者：[smilemuffie](https://github.com/smilemuffie)、[Xuyuey](https://github.com/Xuyuey)

# JavaScript 简明代码 —— 最佳实践

## 引言

如果你不只是担心你的代码是否能生效，还会关注代码本身及其如何编写，那你可以说你有在关注简明代码并在努力实践。专业的开发者会面向其未来和**其他人**而不仅是为了机器编写代码。你写的任何代码都不会只写一次，而是会待在那等待未来维护代码的人，让他痛苦不堪。希望那个未来的家伙不会是你。

基于上述情况，简明代码可以被定义为**代码以不言自明，易于理解且易于更改或扩展的方式编写**。

回想一下有多少次你接手别人工作时的第一印象是下面几个 **WTF** 问题之一？

**“这 TM 是啥？”**

**“你 TM 在这干了啥”**

**“这 TM 是干啥的？”**

有一个很火的图片描绘了上述场景。

![img](https://camo.githubusercontent.com/2050cd696ecddcabad1380b1964c48a60597323e/687474703a2f2f7777772e6f736e6577732e636f6d2f696d616765732f636f6d6963732f7774666d2e6a7067)

**Robert C. Martin (Bob 叔叔)** 的一句名言应该会启发你思考你的方式。

> **即使是糟糕的代码也能运行。但是如果代码不够简明，它会让开发组织陷入困境。**

在本文中，重点将放在 JavaScript 上，但是原则可以应用于其他编程语言。

## 你要的干货来了 —— 简明代码最佳实践

### 1. 强类型检查

使用 `===` 而不是 `==`

```js
// 如果处理不当，它会在很大程度上影响程序逻辑。就像，你期待向左走，但由于某些原因，你向右走了。
0 == false // true
0 === false // false
2 == "2" // true
2 === "2" // false

// 例子
const value = "500";
if (value === 500) {
  console.log(value);
  // 不会执行
}

if (value === "500") {
  console.log(value);
  // 会执行
}
```

### 2. 变量

变量命名要直接表明其背后的意图。这种方式方便代码搜索并且易于他人理解。

糟糕示例：

```js
let daysSLV = 10;
let y = new Date().getFullYear();

let ok;
if (user.age > 30) {
  ok = true;
}
```

良好示例：

```js
const MAX_AGE = 30;
let daysSinceLastVisit = 10;
let currentYear = new Date().getFullYear();

...

const isUserOlderThanAllowed = user.age > MAX_AGE;
```

不要给变量名称添加不必要的单词。

糟糕示例：

```js
let nameValue;
let theProduct;
```

良好示例：

```js
let name;
let product;
```

不要强制他人记住变量的上下文。

糟糕示例：

```js
const users = ["John", "Marco", "Peter"];
users.forEach(u => {
  doSomething();
  doSomethingElse();
  // ...
  // ...
  // ...
  // ...
  // 这里有 WTF 场景：`u` TM 是啥？
  register(u);
});
```

良好示例：

```js
const users = ["John", "Marco", "Peter"];
users.forEach(user => {
  doSomething();
  doSomethingElse();
  // ...
  // ...
  // ...
  // ...
  register(user);
});
```

不要添加不必要的上下文。

糟糕示例：

```js
const user = {
  userName: "John",
  userSurname: "Doe",
  userAge: "28"
};

...

user.userName;
```

良好示例：

```js
const user = {
  name: "John",
  surname: "Doe",
  age: "28"
};

...

user.name;
```

### 3. 函数

使用长而具有描述性的名称。考虑到它代表某种行为，函数名称应该是暴露其背后意图的动词或者短语，参数也是如此。它们的名称应该表明它们要做什么。

糟糕示例：

```js
function notif(user) {
  // implementation
}
```

良好示例：

```js
function notifyUser(emailAddress) {
  // implementation
}
```

避免使用大量参数。理想情况下，函数参数不应该超过两个。参数越少，函数越易于测试。

糟糕示例：

```js
function getUsers(fields, fromDate, toDate) {
  // implementation
}
```

良好示例：

```js
function getUsers({ fields, fromDate, toDate }) {
  // implementation
}

getUsers({
  fields: ['name', 'surname', 'email'],
  fromDate: '2019-01-01',
  toDate: '2019-01-18'
});
```

使用默认参数代替条件语句。

糟糕示例：

```js
function createShape(type) {
  const shapeType = type || "cube";
  // ...
}
```

良好示例：

```js
function createShape(type = "cube") {
  // ...
}
```

一个函数应该只做一件事。禁止在单个函数中执行多个操作。

糟糕示例：

```js
function notifyUsers(users) {
  users.forEach(user => {
    const userRecord = database.lookup(user);
    if (userRecord.isVerified()) {
      notify(user);
    }
  });
}
```

良好示例：

```js
function notifyVerifiedUsers(users) {
  users.filter(isUserVerified).forEach(notify);
}

function isUserVerified(user) {
  const userRecord = database.lookup(user);
  return userRecord.isVerified();
}
```

使用 `Object.assign` 设置默认对象。

糟糕示例：

```js
const shapeConfig = {
  type: "cube",
  width: 200,
  height: null
};

function createShape(config) {
  config.type = config.type || "cube";
  config.width = config.width || 250;
  config.height = config.width || 250;
}

createShape(shapeConfig);
```

良好示例：

```js
const shapeConfig = {
  type: "cube",
  width: 200
  // Exclude the 'height' key
};

function createShape(config) {
  config = Object.assign(
    {
      type: "cube",
      width: 250,
      height: 250
    },
    config
  );

  ...
}

createShape(shapeConfig);
```

不要使用标志变量作为参数，因为这表明函数做了它不应该做的事。

糟糕示例：

```js
function createFile(name, isPublic) {
  if (isPublic) {
    fs.create(`./public/${name}`);
  } else {
    fs.create(name);
  }
}
```

良好示例：

```js
function createFile(name) {
  fs.create(name);
}

function createPublicFile(name) {
  createFile(`./public/${name}`);
}
```

不要污染全局变量。如果你要扩展一个已存在的对象，使用 ES 类继承而不是在原生对象的原型链上创建函数。

糟糕示例：

```js
Array.prototype.myFunc = function myFunc() {
  // implementation
};
```

良好示例：

```js
class SuperArray extends Array {
  myFunc() {
    // implementation
  }
}
```

### 4. 条件语句

避免使用否定条件。

糟糕示例：

```js
function isUserNotBlocked(user) {
  // implementation
}

if (!isUserNotBlocked(user)) {
  // implementation
}
```

良好示例：

```js
function isUserBlocked(user) {
  // implementation
}

if (isUserBlocked(user)) {
  // implementation
}
```

使用条件语句简写。这可能不那么重要，但是值得一提。仅将此方法用于布尔值，并且确定该值不是 `undefined` 和 `null`。

糟糕示例：

```js
if (isValid === true) {
  // do something...
}

if (isValid === false) {
  // do something...
}
```

良好示例：

```js
if (isValid) {
  // do something...
}

if (!isValid) {
  // do something...
}
```

尽可能避免条件语句，使用多态和继承。

糟糕示例：

```js
class Car {
  // ...
  getMaximumSpeed() {
    switch (this.type) {
      case "Ford":
        return this.someFactor() + this.anotherFactor();
      case "Mazda":
        return this.someFactor();
      case "McLaren":
        return this.someFactor() - this.anotherFactor();
    }
  }
}
```

良好示例：

```js
class Car {
  // ...
}

class Ford extends Car {
  // ...
  getMaximumSpeed() {
    return this.someFactor() + this.anotherFactor();
  }
}

class Mazda extends Car {
  // ...
  getMaximumSpeed() {
    return this.someFactor();
  }
}

class McLaren extends Car {
  // ...
  getMaximumSpeed() {
    return this.someFactor() - this.anotherFactor();
  }
}
```

### 5. ES 类

类是 JavaScript 中的新语法糖。一切都像之前使用原型一样现在只不过看起来不同，并且你应该喜欢它们胜过 ES5 普通函数。

糟糕示例：

```js
const Person = function(name) {
  if (!(this instanceof Person)) {
    throw new Error("Instantiate Person with `new` keyword");
  }

  this.name = name;
};

Person.prototype.sayHello = function sayHello() { /**/ };

const Student = function(name, school) {
  if (!(this instanceof Student)) {
    throw new Error("Instantiate Student with `new` keyword");
  }

  Person.call(this, name);
  this.school = school;
};

Student.prototype = Object.create(Person.prototype);
Student.prototype.constructor = Student;
Student.prototype.printSchoolName = function printSchoolName() { /**/ };
```

良好示例：

```js
class Person {
  constructor(name) {
    this.name = name;
  }

  sayHello() {
    /* ... */
  }
}

class Student extends Person {
  constructor(name, school) {
    super(name);
    this.school = school;
  }

  printSchoolName() {
    /* ... */
  }
}
```

使用方法链。诸如 jQuery 和 Lodash 之类的很多库都使用这个模式。这样的话，你的代码就会减少冗余。在你的类中，只用在每个函数末尾返回 `this`，然后你就可以在它上面链式调用更多的类方法了。

糟糕示例：

```js
class Person {
  constructor(name) {
    this.name = name;
  }

  setSurname(surname) {
    this.surname = surname;
  }

  setAge(age) {
    this.age = age;
  }

  save() {
    console.log(this.name, this.surname, this.age);
  }
}

const person = new Person("John");
person.setSurname("Doe");
person.setAge(29);
person.save();
```

良好示例：

```js
class Person {
  constructor(name) {
    this.name = name;
  }

  setSurname(surname) {
    this.surname = surname;
    // Return this for chaining
    return this;
  }

  setAge(age) {
    this.age = age;
    // Return this for chaining
    return this;
  }

  save() {
    console.log(this.name, this.surname, this.age);
    // Return this for chaining
    return this;
  }
}

const person = new Person("John")
    .setSurname("Doe")
    .setAge(29)
    .save();
```

### 6. 通用原则

一般来说，你应该尽力不要重复自己的工作，意思是你不应该写重复代码，并且不要在你身后留下尾巴比如未使用的函数和死代码。

出于各种原因，你最终可能会遇到重复的代码。例如，你有两个大致相同只有些许不同的东西，它们不同的特性或者时间紧迫使你单独创建了两个包含几乎相同代码的函数。在这种情况下删除重复代码意味着抽象化差异并在该层级上处理它们。

关于死代码，码如其名。它是在我们代码库中不做任何事情的代码，在开发的某个阶段，你决定它不再有用了。你应该在代码库中搜索这些部分然后删除所有不需要的函数和代码块。我可以给你的建议是一旦你决定不再需要它，删除它。不然你就会忘了它的用途。

这有一张图表明你当时可能会有的感受。

![img](https://pics.me.me/sometimes-my-code-dont-know-what-it-does-but-i-49866360.png)

## 结语

这只是改进代码所能做的一小部分。在我看来，这里所说的原则是人们经常不遵循的原则。他们有过尝试，但由于各种原因并不总是奏效。可能项目刚开始代码还是整洁的，但当截止日期快到了，这些原则通常会被忽略，被移入“**待办**”或者“**重构**”部分。在那时候，客户宁愿让你赶上截止日期而不是写简明的代码。

就这样！

感谢阅读，下篇文章见。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
