> * 原文地址：[JavaScript Clean Code - Best Practices](https://devinduct.com/blogpost/22/javascript-clean-code-best-practices)
> * 原文作者：[Milos Protic](https://devinduct.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/javascript-clean-code-best-practices.md](https://github.com/xitu/gold-miner/blob/master/TODO1/javascript-clean-code-best-practices.md)
> * 译者：
> * 校对者：

# JavaScript Clean Code - Best Practices

## Introduction

If you care about the code itself and how it is written, instead only worrying does it work or not, you can say that you practice and care about the clean code. A professional developer will write the code for the future self and for the **"other guy"** not just for the machine. Any code you write is never written just once rather it will sit down and wait for the future guy and make him miserable. Hopefully, that future guy won't be you.

Based on that, the clean code can be defined as the **code written in such a manner that is self-explanatory, easy to understand by humans and easy to change or extend**.

Ask your self how many times did you continue someone else's work when the first impression was one of the **"WTF"** questions?

**"WTF is that?"**

**"WTF did you do here?"**

**"WTF is this for?"**

Here is a popular image expressing the above.

![img](https://camo.githubusercontent.com/2050cd696ecddcabad1380b1964c48a60597323e/687474703a2f2f7777772e6f736e6577732e636f6d2f696d616765732f636f6d6963732f7774666d2e6a7067)

And a quote by **Robert C. Martin (Uncle Bob)** that should make you think about your ways.

> **Even bad code can function. But if the code isn’t clean, it can bring a development organization to its knees.**

In this article, the focus will be on JavaScript, but the principles can be applied to other programming languages.

## The actual part you came here to read - Clean Code Best Practices

### 1. Strong type checks

Use `===` instead of `==`

```js
// If not handled properly, it can dramatically affect the program logic. It's like, you expect to go left, but for some reason, you go right.
0 == false // true
0 === false // false
2 == "2" // true
2 === "2" // false

// example
const value = "500";
if (value === 500) {
  console.log(value);
  // it will not be reached
}

if (value === "500") {
  console.log(value);
  // it will be reached
}
```

### 2. Variables

Name your variables in a way that they reveal the intention behind it. This way they become searchable and easier to understand after a person sees it.

Bad:

```js
let daysSLV = 10;
let y = new Date().getFullYear();

let ok;
if (user.age > 30) {
  ok = true;
}
```

Good:

```js
const MAX_AGE = 30;
let daysSinceLastVisit = 10;
let currentYear = new Date().getFullYear();

...

const isUserOlderThanAllowed = user.age > MAX_AGE;
```

Don't add extra unneeded words to the variable names.

Bad:

```js
let nameValue;
let theProduct;
```

Good:

```js
let name;
let product;
```

Don't enforce the need for memorizing the variable context.

Bad:

```js
const users = ["John", "Marco", "Peter"];
users.forEach(u => {
  doSomething();
  doSomethingElse();
  // ...
  // ...
  // ...
  // ...
  // Here we have the WTF situation: WTF is `u` for?
  register(u);
});
```

Good:

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

Don't add unnecessary context.

Bad:

```js
const user = {
  userName: "John",
  userSurname: "Doe",
  userAge: "28"
};

...

user.userName;
```

Good:

```js
const user = {
  name: "John",
  surname: "Doe",
  age: "28"
};

...

user.name;
```

### 3. Functions

Use long and descriptive names. Considering that it represents a certain behavior, a function name should be a verb or a phrase fully exposing the intent behind it as well as the intent of the arguments. Their name should say what they do.

Bad:

```js
function notif(user) {
  // implementation
}
```

Good:

```js
function notifyUser(emailAddress) {
  // implementation
}
```

Avoid a long number of arguments. Ideally, a function should have two or fewer arguments specified. The fewer the arguments, the easier is to test the function.

Bad:

```js
function getUsers(fields, fromDate, toDate) {
  // implementation
}
```

Good:

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

Use default arguments instead of conditionals.

Bad:

```js
function createShape(type) {
  const shapeType = type || "cube";
  // ...
}
```

Good:

```js
function createShape(type = "cube") {
  // ...
}
```

A function should do one thing. Avoid executing multiple actions within a single function.

Bad:

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

Good:

```js
function notifyVerifiedUsers(users) {
  users.filter(isUserVerified).forEach(notify);
}

function isUserVerified(user) {
  const userRecord = database.lookup(user);
  return userRecord.isVerified();
}
```

Use `Object.assign` to set default objects.

Bad:

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

Good:

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

Don't use flags as parameters because they are telling you that the function is doing more than it should.

Bad:

```js
function createFile(name, isPublic) {
  if (isPublic) {
    fs.create(`./public/${name}`);
  } else {
    fs.create(name);
  }
}
```

Good:

```js
function createFile(name) {
  fs.create(name);
}

function createPublicFile(name) {
  createFile(`./public/${name}`);
}
```

Don't pollute the globals. If you need to extend an existing object use ES Classes and inheritance instead of creating the function on the prototype chain of the native object.

Bad:

```js
Array.prototype.myFunc = function myFunc() {
  // implementation
};
```

Good:

```js
class SuperArray extends Array {
  myFunc() {
    // implementation
  }
}
```

### 4. Conditionals

Avoid negative conditionals.

Bad:

```js
function isUserNotBlocked(user) {
  // implementation
}

if (!isUserNotBlocked(user)) {
  // implementation
}
```

Good:

```js
function isUserBlocked(user) {
  // implementation
}

if (isUserBlocked(user)) {
  // implementation
}
```

Use conditional shorthands. This might be trivial, but it's worth mentioning. Use this approach only for boolean values and if you are sure that the value will not be `undefined` or `null`.

Bad:

```js
if (isValid === true) {
  // do something...
}

if (isValid === false) {
  // do something...
}
```

Good:

```js
if (isValid) {
  // do something...
}

if (!isValid) {
  // do something...
}
```

Avoid conditionals whenever possible. Use polymorphism and inheritance instead.

Bad:

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

Good:

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

### 5. ES Classes

Classes are the new syntactic sugar in JavaScript. Everything works just as it did before with prototype only it now looks different and you should prefer them over ES5 plain functions.

Bad:

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

Good:

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

Use method chaining. Many libraries such as jQuery and Lodash use this pattern. As a result, your code will be less verbose. In your class, simply return `this` at the end of every function, and you can chain further class methods onto it.

Bad:

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

Good:

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

### 6. Avoid In General

In general, you should do your best not to repeat yourself, meaning you shouldn't write duplicate code, and not to leave tails behind you such as unused functions and dead code.

You can end up with duplicate code for various reasons. For example, you can have two slightly different things that share a lot of in common and the nature of their differences or tight deadlines forces you to create separate functions containing almost the same code. Removing duplicate code in this situation means to abstract the differences and handle them on that level.

And about the dead code, well it is what its name says. Its the code sitting there in our code base not doing anything because, at some point of development, you've decided that it no longer has a purpose. You should search your code base for these parts and delete all unneeded functions and code blocks. An advice I can give to you is as soon you decide it's no longer needed, delete it. Later you might forget what it was used for.

Here is an image illustrating the feeling you would have at that point.

![img](https://pics.me.me/sometimes-my-code-dont-know-what-it-does-but-i-49866360.png)

## Conclusion

This is only a fraction of what you could do to improve your code. In my opinion, the principles alleged here are the ones which people often don't follow. They try to, but not always succeed for various reasons. Maybe at the start of the project, the code is neat and clean but when it comes to meeting deadlines the principles are often ignored and moved into a **"TODO"** or **"REFACTOR"** section. At that point, your client would rather have you to meet the deadline instead of writing the clean code.

That's it!

Thank you for reading and see you in the next article.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
