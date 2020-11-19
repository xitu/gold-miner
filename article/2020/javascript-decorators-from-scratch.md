> * 原文地址：[JavaScript Decorators From Scratch](https://blog.bitsrc.io/javascript-decorators-from-scratch-c4cfd6c33d70)
> * 原文作者：[Mahdhi Rezvi](https://medium.com/@mahdhirezvi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/javascript-decorators-from-scratch.md](https://github.com/xitu/gold-miner/blob/master/article/2020/javascript-decorators-from-scratch.md)
> * 译者：
> * 校对者：

# JavaScript Decorators From Scratch

![Photo by [Manja Vitolic](https://unsplash.com/@madhatterzone?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10368/0*9zWhtS-gknJ6IVc3)

## What is a Decorator?

A decorator is simply a way of wrapping a function with another function to extend its existing capabilities. You “decorate” your existing code by wrapping it with another piece of code. This concept will not be new to those who are familiar with functional composition or higher-order functions.

Decorators aren’t something new. They have been present in other languages such as Python and even in JavaScript under functional programming. We will speak about this later on.

## Why Use a Decorator?

Decorators allow you to write cleaner code and achieve composition. It also helps you extend the same functionality to several functions and classes. Thereby enabling you to write code that is easier to debug and maintain.

Decorators also allow your code to be less distracting as it removes all the feature enhancing code away from the core function. It also enables you to add features without making your code complex.

Being in the stage 2 proposal, there can be many additions to the class decorator proposal which can be beneficial.

## Function Decorators

#### What Are Function Decorators?

Function decorators are simply functions. They receive a function as an argument and return another function that enhances and extends the function argument. The new function does not modify the function argument, but rather uses the function argument in its body. This is very much similar to higher order functions as I’ve mentioned before.

#### How Does a Function Decorator Work?

Let’s understand function decorators with an example.

Argument validation is a common practice in programming. With languages like Java, if your function expects two arguments and three arguments are passed, you will receive an exception. But with JavaScript, you will not receive any error as the additional parameters are simply ignored. This behavior can either be irritating or beneficial at times.

To make sure the arguments being passed on to a function are valid, we can validate them upon entry. This is a straightforward process where you check each and every parameter for the required data type and make sure the number of arguments does not exceed the required number of parameters.

But repeating this same process for several functions can lead to repeated code. You can simply use a decorator to help you with the validation and reuse it wherever parameter validation is required.

```JavaScript
//decorator function
const allArgsValid = function(fn) {
  return function(...args) {
  if (args.length != fn.length) {
      throw new Error('Only submit required number of params');
    }
    const validArgs = args.filter(arg => Number.isInteger(arg));
    if (validArgs.length < fn.length) {
      throw new TypeError('Argument cannot be a non-integer');
    }
    return fn(...args);
  }
}

//ordinary multiply function
let multiply = function(a,b){
	return a*b;
}

//decorated multiply function that only accepts the required number of params and only integers
multiply = allArgsValid(multiply);

multiply(6, 8);
//48

multiply(6, 8, 7);
//Error: Only submit required number of params

multiply(3, null);
//TypeError: Argument cannot be a non-integer

multiply('',4);
//TypeError: Argument cannot be a non-integer
```

`allArgsValid` is a decorator function that receives a function as an argument. This decorator function returns another function that wraps the function argument. Moreover, it only calls the argument function, when the arguments being passed onto the argument function are valid integers. Otherwise, an error is thrown. It also checks for the number of parameters being passed on and makes sure that it does not exceed or deceed the required number of parameters.

Later, we assign a function that multiplies two numbers to a variable named `multiply`. We pass this multiply function to the `allArgsValid` decorator function which returns another function as we saw earlier. This returned function is assigned to the `multiply` variable again. This makes it easier for it to be reused whenever required.

```js
//ordinary add function
let add = function(a,b){
	return a+b;
}

//decorated add function that only accepts the required number of params and only integers
add = allArgsValid(add);

add(6, 8);
//14

add(3, null);
//TypeError: Argument cannot be a non-integer

add('',4);
//TypeError: Argument cannot be a non-integer
```

## TC39 Class Decorator Proposal

Function decorators have been existing in JavaScript for a long time under functional programming. The proposed class decorators are in stage 2.

JavaScript classes are not really classes. They are simply syntactic sugar for the prototypal pattern. The class syntax makes it easier and simpler for developers to work with.

Now we can come to the conclusion that classes are simply functions. You might now wonder, why cannot we simply use the function decorators in classes. It’s totally possible.

Let’s have a look at an example of how this can be implemented.

```js
function log(fn) {
  return function() {
    console.log("Execution of " + fn.name);
    console.time("fn");
    let val = fn();
    console.timeEnd("fn");
    return val;
  }
}

class Book {
  constructor(name, ISBN) {
    this.name = name;
    this.ISBN = ISBN;
  }

  getBook() {
    return `[${this.name}][${this.ISBN}]`;
  }
}

let obj = new Book("HP", "1245-533552");
let getBook = log(obj.getBook);
console.log(getBook());
//TypeError: Cannot read property 'name' of undefined
```

The reason for the error is because, when the `getBook` method is called, it actually calls the anonymous function returned by the `log` decorator function. Within this anonymous function, the `obj.getBook` method is called. But the value of `this` within the anonymous function refers to the global object, not the book object. Hence, we receive the Type error.

We can fix this issue by passing the book object instance to the `getBook` method.

```js
function log(classObj, fn) {
  return function() {
    console.log("Execution of " + fn.name);
    console.time("fn");
    let val = fn.call(classObj);
    console.timeEnd("fn");
    return val;
  }
}

class Book {
  constructor(name, ISBN) {
    this.name = name;
    this.ISBN = ISBN;
  }

  getBook() {
    return `[${this.name}][${this.ISBN}]`;
  }
}

let obj = new Book("HP", "1245-533552");
let getBook = log(obj, obj.getBook);
console.log(getBook());
//[HP][1245-533552]
```

We also have to pass the bookObj into the log decorator function, in order to be able to pass it as `this` to the `obj.getBook` method.

**Although this solution works perfectly, it’s kind of like a workaround. With the new proposal, the syntax is more streamlined making it easier to implement these solutions.**

> **Note — In order to run the below examples, you can use Babel. Jsfiddle is an easier alternative for you to try out these examples online. Since these proposals are not finalized, you should avoid using them in production as there can be changes in the future and the performance at the moment is not perfect.**

## Class Decorators

The new proposal decorators use a special syntax where they are prefixed with the `@` symbol. Our log decorator function will be called by using the syntax as shown below.

```
@log
```

There are some changes to the decorator function in this proposal. When a decorator function is applied to a Class, the decorator function will only receive one argument. This argument is called the target, which is basically the object of the class being decorated.

Being able to access the target argument, you can modify the class as per your requirement. You can change the constructor of the class, add new prototypes, etc.

Let’s look at an example involving the Book class we had used previously.

```js
function log(target) {
  return function(...args) {
    console.log("Constructor called");
    return new target(...args);
  };
}

@log
class Book {
  constructor(name, ISBN) {
    this.name = name;
    this.ISBN = ISBN;
  }

  getBook() {
    return `[${this.name}][${this.ISBN}]`;
  }
}

let obj = new Book("HP", "1245-533552");
//Constructor Called
console.log(obj.getBook());
//HP][1245-533552]
```

As you can see above, the `log` decorator receives the `target` argument and returns an anonymous function that performs a log statement and creates and returns a new instance of the `target` which is basically the Book Class. You can also add prototypes to the `target` by using `target.prototype.property` .

Furthermore, several decorator functions can be used on a Class as shown below.

```js
function logWithParams(...params) {
  return function(target) {
    return function(...args) {
      console.table(params);
      return new target(...args);
    }
  }
}

@log
@logWithParams('param1', 'param2')
class Book {
	//Class implementation as before
}

let obj = new Book("HP", "1245-533552");
//Constructor called
//Params will be consoled as a table
console.log(obj.getBook());
//[HP][1245-533552]
```

## Class Property Decorators

Similar to the Class decorator, the Class property decorators are also used with a similar syntax. The decorator function is prefixed with the `“@”` symbol. You can also pass parameters to the decorator function with class properties as shown in the above examples.

#### Class Method Decorators

The arguments being passed on to a class method decorator would be different from a class decorator. A class method decorator would receive three parameters instead of one. They are as follows.

* Target — target refers to an object which contains the constructor and methods within the class.
* Name — name refers to the name of the method the decorator is being called upon.
* Descriptor — descriptor refers to the descriptor object of the method being called upon. You can read more about property descriptors over [here](https://flaviocopes.com/javascript-property-descriptors/).

It is the descriptor argument that will be manipulated most of the time to fulfill a requirement. The descriptor object has 4 attributes when used on a class method. They are as follows.

* Configurable — a boolean attribute which determines whether the property descriptors can be changed
* Enumerable — a boolean attribute which determines whether the property will be visible during the enumeration of the object
* Value — this simply refers to the value of the property. In this case, a function.
* Writable — a boolean attribute that determines whether the property can be overwritten.

Let’s have a look at an example involving our Book class.

```js
//readonly decorator function
function readOnly(target, name, descriptor) {
  descriptor.writable = false;
  return descriptor;
}

class Book {
  //Implementation here
  @readOnly
  getBook() {
    return `[${this.name}][${this.ISBN}]`;
  }

}

let obj = new Book("HP", "1245-533552");

obj.getBook = "Hello";

console.log(obj.getBook());
//[HP][1245-533552]
```

The above example uses a `readOnly` decorator function which makes the `getBook` method in the `Book` class read-only. This is achieved by setting the writable property of the descriptor to `false` . This property is set to `true` by default.

If the writable property was not manipulated, you can easily overwrite the getBook property as below.

```js
obj.getBook = "Hello";

console.log(obj.getBook);
//Hello
```

#### Class Field Decorators

Similar to the class methods, class fields also can be decorated. Although class fields are supported in typescript, they are still in the stage 3 proposal for JavaScript.

The arguments passed on to a decorator function when used on class fields are the same as the arguments passed when used on class methods. The only difference lies in the descriptor object. Unlike a class method, the descriptor object will not contain a `value` attribute when used on a class field. This attribute will be replaced by an attribute called the `initializer` which is a function. Since class fields are still in the proposal stage, you can read more about the initializer function in the [docs](https://github.com/tc39/proposal-class-fields#execution-of-initializer-expressions). The initializer function would return the initial value of class field variable.

Moreover, the `writable` attribute of the descriptor object, will not be present when the field value is undefined.

Let’s look at an example to understand this further. We will again use our `Book` class.

```js
function upperCase(target, name, descriptor) {
  if (descriptor.initializer && descriptor.initializer()) {
    let val = descriptor.initializer();
    descriptor.initializer = function() {
      return val.toUpperCase();
    }
  }

}

class Book {
  
  @upperCase
  id = "az092b";

  getId() {
    return `${this.id}`;
  }

  //other implementation here
}

let obj = new Book("HP", "1245-533552");

console.log(obj.getId());
//AZ092B
```

The above example converts the value of the `id` property to uppercase. It uses a decorator function called upperCase which checks whether the initializer is present to be sure that the value is not `undefined`, checks whether the value is truthy and then converts it into uppercase. When the `getId` method is called, the uppercase value can be seen. Similar to other decorator functions, you can pass parameters when decorators are used on class fields as well.

## Use Cases

The use cases of decorators are quite limitless actually. There are several instances where decorators are used in real-world applications.

#### Decorators in Angular

If anyone is familiar with typescript and Angular, they would have definitely come across decorators being used within Angular classes. You can find decorators such as “@Component”, “@NgModule”, “@Injectable”, “@Pipe” and more. These decorators come loaded built-in and decorate the Class.

#### MobX

MobX heavily used and encouraged decorators before version 6. The decorators used were “@observable”, “@computed” and “@action”. But MobX currently does not encourage the use of decorators as this proposal has not been standardized yet. The documentation states as follows,

> However, decorators are currently not an ES standard, and the process of standardization is taking a long time. It also looks like the standard will be different from the way decorators were implemented previously.

#### Core Decorators JS

This JavaScript library provides readymade decorators out of the box. Although this library is based on the stage 0 decorator proposal, the author of the library is waiting until the proposal reaches stage 3, to update the library.

This library comes with decorators such as “@readonly”, “@time”, “@deprecate” and more. You can check out more over [here](https://github.com/jayphelps/core-decorators).

#### Redux Library in React

The Redux library for React contains a `connect` method that allows you to connect a React component to a Redux store. The library allows for the `connect` method to be used as a decorator as well.

```js
//Before decorator
class MyApp extends React.Component {
  // ...define your main app here
}
export default connect(mapStateToProps, mapDispatchToProps)(MyApp);

//After decorator
@connect(mapStateToProps, mapDispatchToProps)
export default class MyApp extends React.Component {
  // ...define your main app here
}
```

Felix Kling’s Stack Overflow [answer](https://stackoverflow.com/a/32675956) explains this.

Furthermore, although `connect` supports the decorator syntax, it has been discouraged by the redux team at the moment. This is mostly because the decorator proposal in stage 2 can accommodate changes in the future.

---

Decorators are a powerful tool that enables you to create code that is very flexible. There is a very high chance you will come across them quite often in the near future.

Thank you for reading & happy coding

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
