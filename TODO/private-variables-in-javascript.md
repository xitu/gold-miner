> * 原文地址：[Private Variables in JavaScript](https://marcusnoble.co.uk/2018-02-04-private-variables-in-javascript/)
> * 原文作者：[Marcus Noble](https://marcusnoble.co.uk/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/private-variables-in-javascript.md](https://github.com/xitu/gold-miner/blob/master/TODO/private-variables-in-javascript.md)
> * 译者：
> * 校对者：

# Private Variables in JavaScript

JavaScript has had a lot of improvements lately with new syntax and features being added all the time. But some things don't change, everything is still an object, pretty much everything can be altered at runtime and there is no concept of public/private properties. But there are some tricks we can use to change some of this ourselves, in this post I am going to look at the various ways in which we can implement private properties.

In 2015 JavaScript had [classes](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Classes) introduced that provided a familiar way of working with objects for those coming from more classical C-based languages like Java and C#. It becomes quickly apparent though that these classes aren't quite like what you are used to - there are no modifiers for properties to control access and all properties need to be defined within functions.

So how can we go about protecting data that shouldn't change during runtime? Let's take a look at some options.

> Throughout this post I will reuse an example class that is used to build a shape. Its width and height can only be set when initialised and provides a property to get the area. For more information on the `get` keyword used in these examples take a look at my last post on [Getters and Setters](https://marcusnoble.co.uk/2018-01-26-getters-and-setters-in-javascript)

## Naming convention

The first and most established method was to use a specific naming convention to indicate that a property should be treated as private. This usually had the property name prefixed with an underscore (e.g. `_count`). This didn't prevent the value from being access or modified but rather relied on an understanding between different developers that this value should be treated as off-limits.

```
class Shape {
  constructor(width, height) {
    this._width = width;
    this._height = height;
  }
  get area() {
    return this._width * this._height;
  }
}

const square = new Shape(10, 10);
console.log(square.area);    // 100
console.log(square._width);  // 10
```

## WeakMap

For a slightly more restrictive option you can use a WeakMap to store all the private values in. This still doesn't prevent access to the data but it does separate it from the object the user interacts with. For this technique we set the key of the WeakMap to be the instance of the object the private properties belong to and we use a function (which we've called `internal`) to create or return an object that all properties will be stored within. This technique has the benefit of not having the private properties shown on the instance when iterating over the properties or when doing `JSON.stringify` but it relies on a WeakMap being available outside of the class itself which could be accessed and manipulated.

```
const map = new WeakMap();

// Create an object to store private values in per instance
const internal = obj => {
  if (!map.has(obj)) {
    map.set(obj, {});
  }
  return map.get(obj);
}

class Shape {
  constructor(width, height) {
    internal(this).width = width;
    internal(this).height = height;
  }
  get area() {
    return internal(this).width * internal(this).height;
  }
}

const square = new Shape(10, 10);
console.log(square.area);      // 100
console.log(map.get(square));  // { height: 100, width: 100 }
```

## Symbols

Symbols can be used similar to a WeakMap. Here we create a property on the instance using a [Symbol](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Symbol) as the key. This will prevent the property from being visible when iterating or when using `JSON.stringify`. This technique does require a symbol to be created for each private property though. You can still access the property from outside the class if you also have access to the symbol.

```
const widthSymbol = Symbol('width');
const heightSymbol = Symbol('height');

class Shape {
  constructor(width, height) {
    this[widthSymbol] = width;
    this[heightSymbol] = height;
  }
  get area() {
    return this[widthSymbol] * this[heightSymbol];
  }
}

const square = new Shape(10, 10);
console.log(square.area);         // 100
console.log(square.widthSymbol);  // undefined
console.log(square[widthSymbol]); // 10
```

## Closure

All of the techniques shown so far still allow private properties to be accessed from outside the class, closures gives us a way of fixing that. Closures can be used along with a WeakMap or Symbols if you wish but work just as well with a standard JavaScript object too. The idea behind a closure is to encapsulate data within a function scope that is created when called but returns the result of a function from within, thus making the scope inaccessible from the outside.

```
function Shape() {
  // private vars
  const this$ = {};

  class Shape {
    constructor(width, height) {
      this$.width = width;
      this$.height = height;
    }

    get area() {
      return this$.width * this$.height;
    }
  }

  return new Shape(...arguments);
}

const square = new Shape(10, 10);
console.log(square.area);  // 100
console.log(square.width); // undefined
```

There is a slight problem with this technique though, we now have two different `Shape` objects. The code will call and interact with the external `Shape` but the instance returned will be of the inner `Shape`. This might not be a big deal most of the time but it would cause `square instanceof Shape` to return `false` which could be a problem in your code.

A solution to this is to set the outer Shape as the prototype of the instance that is returned:

```
return Object.setPrototypeOf(new Shape(...arguments), this);
```

Unfortunately this isn't enough, updating only this line now leaves `square.area` as undefined. This is due to the way the `get` keyword works behind the scenes. We can solve this by specifying the getter manually within the constructor.

```
function Shape() {
  // private vars
  const this$ = {};

  class Shape {
    constructor(width, height) {
      this$.width = width;
      this$.height = height;

      Object.defineProperty(this, 'area', {
        get: function() {
          return this$.width * this$.height;
        }
      });
    }
  }

  return Object.setPrototypeOf(new Shape(...arguments), this);
}

const square = new Shape(10, 10);
console.log(square.area);             // 100
console.log(square.width);            // undefined
console.log(square instanceof Shape); // true
```

Alternatively, we can set the instances prototype to have `this` as its prototype allowing us to use both `instanceof` and `get`. In the example below we have a prototype chain of `Object -> Outer Shape -> Inner Shape Prototype -> Inner Shape`.

```
function Shape() {
  // private vars
  const this$ = {};

  class Shape {
    constructor(width, height) {
      this$.width = width;
      this$.height = height;
    }

    get area() {
      return this$.width * this$.height;
    }
  }

  const instance = new Shape(...arguments);
  Object.setPrototypeOf(Object.getPrototypeOf(instance), this);
  return instance;
}

const square = new Shape(10, 10);
console.log(square.area);             // 100
console.log(square.width);            // undefined
console.log(square instanceof Shape); // true
```

## Proxies

[Proxies](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy) are a fascinating new feature in JavaScript that allows you to effectively wrap an object in this thing called a proxy and intercept all interaction with that object. We're going to have them create private variables using the 'naming convention' method above but with access to the values restricted from outside the class.

A proxy can intercept many different types of interaction but what we're going to focus on here is [`get`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy/handler/get) and [`set`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy/handler/set) which allows us to intercept a property being read and a property being wrote to respectively. When creating a proxy you provide it with two parameters, the first is the instance you plan to wrap around, the second is a "handler" object that defines the different methods you wish to intercept.

Our handler will look a little something like this:

```
const handler = {
  get: function(target, key) {
    if (key[0] === '_') {
      throw new Error('Attempt to access private property');
    }
    return target[key];
  },
  set: function(target, key, value) {
    if (key[0] === '_') {
      throw new Error('Attempt to access private property');
    }
    target[key] = value;
  }
};
```

In each case, we check if the name of the property being accessed begins with an underscore, if it does we throw an error thus preventing access to it.

```
class Shape {
  constructor(width, height) {
    this._width = width;
    this._height = height;
  }
  get area() {
    return this._width * this._height;
  }
}

const handler = {
  get: function(target, key) {
    if (key[0] === '_') {
      throw new Error('Attempt to access private property');
    }
    return target[key];
  },
  set: function(target, key, value) {
    if (key[0] === '_') {
      throw new Error('Attempt to access private property');
    }
    target[key] = value;
  }
}

const square = new Proxy(new Shape(10, 10), handler);
console.log(square.area);             // 100
console.log(square instanceof Shape); // true
square._width = 200; // Error: Attempt to access private property
```

As you can see in this example, we retain the ability to use `instanceof` so shouldn't have any unexpected consequences there.

Unfortunately, this has a problem when we try to do `JSON.stringify` as it attempts to stringify the private properties. To get around this we need to override the `toJSON` function to only return the "public" properties. We can do this by updating our get handler with a specific case for `toJSON`:

> Note: This will override any custom `toJSON` functions defined.

```
get: function(target, key) {
  if (key[0] === '_') {
    throw new Error('Attempt to access private property');
  } else if (key === 'toJSON') {
    const obj = {};
    for (const key in target) {
      if (key[0] !== '_') { // Only copy over the public properties
        obj[key] = target[key];
      }
    }
    return () => obj;
  }
  return target[key];
}
```

We now have our private properties closed off while expected functionality remains, the only caveat being that our private properties are still iterable. `for (const key in square)` will list out `_width` and `_height`. Thankfully there is a handler for this too! We can also intercept calls to `getOwnPropertyDescriptor` and manipulate the output for our private properties:

```
getOwnPropertyDescriptor(target, key) {
  const desc = Object.getOwnPropertyDescriptor(target, key);
  if (key[0] === '_') {
    desc.enumerable = false;
  }
  return desc;
}
```

Now putting it all together:

```
class Shape {
  constructor(width, height) {
    this._width = width;
    this._height = height;
  }
  get area() {
    return this._width * this._height;
  }
}

const handler = {
  get: function(target, key) {
    if (key[0] === '_') {
      throw new Error('Attempt to access private property');
    } else if (key === 'toJSON') {
      const obj = {};
      for (const key in target) {
        if (key[0] !== '_') {
          obj[key] = target[key];
        }
      }
      return () => obj;
    }
    return target[key];
  },
  set: function(target, key, value) {
    if (key[0] === '_') {
      throw new Error('Attempt to access private property');
    }
    target[key] = value;
  },
  getOwnPropertyDescriptor(target, key) {
    const desc = Object.getOwnPropertyDescriptor(target, key);
    if (key[0] === '_') {
      desc.enumerable = false;
    }
    return desc;
  }
}

const square = new Proxy(new Shape(10, 10), handler);
console.log(square.area);             // 100
console.log(square instanceof Shape); // true
console.log(JSON.stringify(square));  // "{}"
for (const key in square) {           // No output
  console.log(key);
}
square._width = 200;                  // Error: Attempt to access private property
```

Proxies are currently my favourite method of creating private properties in JavaScript. The class is built in a way that is familiar to old-school JS developers and because of this can be applied to old, existing code by wrapping them in the same proxy handlers.

## Sidenote - TypeScript

For those that don't know [TypeScript](https://www.typescriptlang.org/) is a types based superset of JavaScript that compiles to plain JavaScript. Part of the TypeScript language allows you to specify private, public and protected properties.

```
class Shape {
  private width;
  private height;

  constructor(width, height) {
    this.width = width;
    this.height = height;
  }

  get area() {
    return this.width * this.height;
  }
}
const square = new Shape(10, 10)
console.log(square.area); // 100
```

The important thing to note with TypeScript is that it is only at _compile_ time that types are known and that private/public modifiers make any difference. If you try and access `square.width`, you can. TypeScript will give you an error at compile time but wouldn't stop the compilation for it.

```
// Compile time error: Property 'width' is private and only accessible within class 'Shape'.
console.log(square.width); // 10
```

TypeScript doesn't do anything clever to try and prevent access to private properties at runtime. I only list it here to make people aware that it doesn't solve any of the issues we've looked at. You can [take a look](https://www.typescriptlang.org/play/index.html#src=class%20Shape%20%7B%0D%0A%20%20private%20width%3B%0D%0A%20%20private%20height%3B%0D%0A%0D%0A%20%20constructor(width%2C%20height)%20%7B%0D%0A%20%20%20%20this.width%20%3D%20width%3B%0D%0A%20%20%20%20this.height%20%3D%20height%3B%0D%0A%20%20%7D%0D%0A%0D%0A%20%20get%20area()%20%7B%0D%0A%20%20%20%20return%20this.width%20*%20this.height%3B%0D%0A%20%20%7D%0D%0A%7D%0D%0A%0D%0Aconst%20square%20%3D%20new%20Shape(10%2C%2010)%0D%0Aconsole.log(square.area)%3B%20%20%2F%2F%20100%0D%0Aconsole.log(square.width)%3B%20%2F%2F10)  [for yourself](https://www.typescriptlang.org/play/index.html#src=class%20Shape%20%7B%0D%0A%20%20private%20width%3B%0D%0A%20%20private%20height%3B%0D%0A%0D%0A%20%20constructor(width%2C%20height)%20%7B%0D%0A%20%20%20%20this.width%20%3D%20width%3B%0D%0A%20%20%20%20this.height%20%3D%20height%3B%0D%0A%20%20%7D%0D%0A%0D%0A%20%20get%20area()%20%7B%0D%0A%20%20%20%20return%20this.width%20*%20this.height%3B%0D%0A%20%20%7D%0D%0A%7D%0D%0A%0D%0Aconst%20square%20%3D%20new%20Shape(10%2C%2010)%0D%0Aconsole.log(square.area)%3B%20%20%2F%2F%20100%0D%0Aconsole.log(square.width)%3B%20%2F%2F10) at what JavaScript would be created from the above TypeScript.

## Future

I've covered the methods that can be used today, but what about the future? Well, the future look interesting. There is currently a proposal to introduce [private fields](https://github.com/tc39/proposal-class-fields#private-fields) to JavaScript classes that makes use of the `#` symbol to indicate it's private. It is used in a very similar way to the naming convention technique but provides actual restrictions on access.

```
class Shape {
  #height;
  #width;

  constructor(width, height) {
    this.#width = width;
    this.#height = height;
  }

  get area() {
    return this.#width * this.#height;
  }
}

const square = new Shape(10, 10);
console.log(square.area);             // 100
console.log(square instanceof Shape); // true
console.log(square.#width);           // Error: Private fields can only be referenced from within a class.
```

If you're interested you can read the [full proposal](https://tc39.github.io/proposal-class-fields/) to get all the nitty-gritty details. The bit that I found interesting was that private fields would need to be defined up-front and cannot be created or destroyed ad-hoc. This feels like a very alien concept in JavaScript to me so would be interesting to see how that develops as the proposal moves forward. Currently the proposal focuses on private class properties and not private functions or private members of object literals, these may come later.

## NPM Package - Privatise

While writing this post I also released an NPM package to help create private properties - [privatise](https://www.npmjs.com/package/@averagemarcus/privatise). I used the Proxy method described above with some additional handlers to allow a class to be passed in rather than an instance. All the code can be found on [GitHub](https://github.com/AverageMarcus/privatise) and I welcome any pull request or issues.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
