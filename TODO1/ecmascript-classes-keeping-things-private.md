> * 原文地址：[]()
> * 原文作者：[]()
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/.md](https://github.com/xitu/gold-miner/blob/master/TODO1/.md)
> * 译者：
> * 校对者：

## **topic: JavaScript****by Milos Protic** **relates to: Advice, Web Development** **on May, 23 2019**

# ECMAScript Classes - Keeping Things Private

## Introduction

As usual, we will start with a few theoretical explanations. ES Classes are the new syntactic sugar in JavaScript. They provide a neat way of writing and achieving the same thing as if we used a prototype chain. The only difference is that it looks better and, if you came from the C# or Java world, feels more natural. One might say that they are not meant for JavaScript, but for me, I don't have a problem using classes or ES5 prototype standards.

They provide an easier way of encapsulation and creation of a fixed set of methods operating on that entity with the valid internal state. Basically, we can write less to achieve more, which is the whole point. With them, JavaScript is moving towards Object-Oriented way of doing things and by using them we are splitting the application into objects instead of into functions. Don't get me wrong, splitting the application into functions is not a bad thing, actually, it's a great thing and it can provide certain benefits over classes, but that is a topic for another article.

In a more practical way, we could say that whenever we want to describe a model from the real world within our application we would use a class to do it. For example, a building, a car, a motorcycle...etc. They represent a real-world entity.

## The Scope

In server-side languages, we have something called **access modifiers** or **levels of visibility** such as `public`, `private`, `protected`, `internal`, `package`...Unfortunately, only the first two, in their own way, are supported in JavaScript. We do not write access modifiers (`public` or `private`) to declare our fields and JavaScript, in a way, assumes you to have everything scoped public which is the reason why I'm writing this post.

Note that we have a way of declaring a private and public field on our class, but these field declarations are an experimental feature and therefore not safe to be used yet.

```js
class SimCard {
  number; // public field
  type; // public field
  #pinCode; // private field
}

```

> ****The field declarations like the ones above are not supported without a compiler like, for example, Babel****.

## Keeping Things Private - The Encapsulation

Encapsulation is the term used in programming when we want to say that something is protected or hidden from the outer world. By keeping the data private and visible only to the owner entity we are **encapsulating** it. In this article, we will use a couple of ways to encapsulate our data. Let's dive into it.

### 1\. By Convention

This is nothing else but faking the `private` state of our data or variables. In reality, they are public and accessible to everyone. The two most common conventions for keeping things private that I've encountered are the `$` and `_` prefixes. If something is prefixed with one of these signs (usually only one is used across the application) then it should be handled as a non-public property of that specific object.

```js
class SimCard {
  constructor(number, type, pinCode) {
    this.number = number;
    this.type = type;
    
    // this property is intended to be a private one
    this._pinCode = pinCode;
  }
}

const card = new SimCard("444-555-666", "Micro SIM", 1515);

// here we would have access to the private _pinCode property which is not the desired behavior
console.log(card._pinCode); // outputs 1515

```

### 2\. Privacy with Closures

Closures are extremely useful when it comes to keeping a variable scope. They go a long way back and were used by JavaScript developers for decades. This approach gives us the real privacy and the data is not accessible to the outside world. It can be managed only by the owner entity. What we will do here is create local variables within the class constructor and capture them with closures. To make it work, the methods must be attached to the instance, not defined on the prototype chain.

```js
class SimCard {
  constructor(number, type, pinCode) {
    this.number = number;
    this.type = type;

    let _pinCode = pinCode;
    // this property is intended to be a private one
    this.getPinCode = () => {
        return _pinCode;
    };
  }
}

const card = new SimCard("444-555-666", "Nano SIM", 1515);
console.log(card._pinCode); // outputs undefined
console.log(card.getPinCode()); // outputs 1515

```

### 3\. Privacy with Symbols and Getters

Symbol is a new primitive data type in JavaScript. It was introduced in ECMAScript version 6. Every value returned by the `Symbol()` call is a unique one, and the main purpose of this type is to be used as an object property identifier.

Since our intention is to create symbols outside of the class definition and yet not global a module has been introduced. By doing this, we are able to create our private fields on the module level, attach them to the class object within the constructor and return the symbol key from the class getter. Note that instead of getter we could use standard methods created on the prototype chain. I've chosen the approach with a getter due to the fact that we do not need to invoke the function to retrieve the value.

```js
const SimCard = (() => {
  const _pinCode = Symbol('PinCode');

  class SimCard {
    constructor(number, type, pinCode) {
      this.number = number;
      this.type = type;
      this[_pinCode] = pinCode;
    }

    get pinCode() {
       return this[_pinCode];
    }
  }
  
  return SimCard;
})();

const card = new SimCard("444-555-666", "Nano SIM", 1515);
console.log(card._pinCode); // outputs undefined
console.log(card.pinCode); // outputs 1515

```

One thing to point out here is the `Object.getOwnPropertySymbols` method. This method can be used to access the fields we intended to keep private. The `_pinCode` value from our class can be retrieved like this:

```js
const card = new SimCard("444-555-666", "Nano SIM", 1515);
console.log(card[Object.getOwnPropertySymbols(card)[0]]); // outputs 1515

```

### 4\. Privacy with Map and Getters

Map and WeakMap were also introduced in ECMAScript version 6. They store data in a key/value pair format which makes them a good fit for storing our private variables. In our example, a map is defined on a module level and in the class constructor each private key is set. The value is retrieved by the class getter, and again, it has been chosen due to the fact that we do not need to invoke the function to retrieve the value. Also, do note that we don't need to define a map for each private property considering the structure of the `Map` itself.

```js
const SimCard = (() => {
  const _privates = new Map();

  class SimCard {
    constructor(number, type, pinCode, pukCode) {
      this.number = number;
      this.type = type;
      _privates.set('pinCode', pinCode);
      _privates.set('pukCode', pukCode);
    }

    get pinCode() {
       return _privates.get('pinCode');
    }

    get pukCode() {
       return _privates.get('pukCode');
    }
  }
  
  return SimCard;
})();

const card = new SimCard("444-555-666", "Nano SIM", 1515, 45874589);
console.log(card.pinCode); // outputs 1515
console.log(card.pukCode); // outputs 45874589
console.log(card._privates); // outputs undefined

```

Note that in this approach we could use a plain object instead of `Map` and dynamically assign the values to it inside the constructor.

## Conclusion and Further Reading

Hopefully, you will find these examples useful and they will find a place somewhere in your workflow. If that is the case, and you liked what you've read, do share it. I have implemented only Twitter share button, lol :) But I'm working on the others.

For further reading, I would recommend the post about [JavaScript Clean Code - Best Practices](https://devinduct.com/blogpost/22/javascript-clean-code-best-practices).

Thank you for reading and see you in the next post.

Subscribe to get the latest posts delivered right to your inbox

Subscribe

![img](/Uploads/PostImages/f6ac3f9b-e1b6-4318-a5c8-698e8ef737fe.png)

**Image source:** https://images.unsplash.com

[Write an Article](/blogpost) [👏 2](/login?ReturnUrl=blogpost%2F23%2Fecmascript-classes-keeping-things-private)

About the author

Milos Protic

Passionate tech guy and a healthy lifestyle lover

* More from this topic
* [
    
    8 Useful JavaScript Tricks
    
    May, 27 2019
    
    ](/blogpost/26/8-useful-javascript-tricks)
* [
    
    JavaScript Clean Code - Best Practices
    
    May, 19 2019
    
    ](/blogpost/22/javascript-clean-code-best-practices)
* [
    
    13 JavaScript Methods Useful For DOM Manipulation
    
    May, 13 2019
    
    ](/blogpost/20/13-javascript-methods-useful-for-dom-manipulation)
* [
    
    Handling Array Duplicates Can Be Tricky
    
    May, 11 2019
    
    ](/blogpost/17/handling-array-duplicates-can-be-tricky)
* [
    
    Vanilla JS Data Binding With Classes From Scratch
    
    May, 07 2019
    
    ](/blogpost/15/vanilla-js-data-binding-with-classes-from-scratch)

Share

[![share-twitter](/Content/images/icons/twitter-icon.png)](https://twitter.com/intent/tweet?text=ECMAScript%20Classes%20-%20Keeping%20Things%20Private%20https://devinduct.com/blogpost/23/ecmascript-classes-keeping-things-private&hashtags=DEVCommunity,%20programming)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
