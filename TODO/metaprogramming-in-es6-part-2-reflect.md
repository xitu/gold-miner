> * 原文地址：[Metaprogramming in ES6: Part 2 - Reflect](https://www.keithcirkel.co.uk/metaprogramming-in-es6-part-2-reflect/)
> * 原文作者：[Keith Cirkel](https://twitter.com/keithamus)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/metaprogramming-in-es6-part-2-reflect.md](https://github.com/xitu/gold-miner/blob/master/TODO/metaprogramming-in-es6-part-2-reflect.md)
> * 译者：
> * 校对者：

# Metaprogramming in ES6: Part 2 - Reflect

In [my last post we had a look at Symbols](/metaprogramming-in-es6-symbols/), and how they add useful new metaprogramming features to JavaScript. This time, we’re (finally!) going to talk all about Reflect. If you haven’t read [Part 1: Symbols](/metaprogramming-in-es6-symbols/), then I’d recommend you do. In the last post, I made a key point which I’m going to reiterate:

> * Symbols are all about Reflection within implementation - you sprinkle them on your existing classes and objects to change the behaviour.
> * Reflect is all about Reflection through introspection - used to discover very low level information about your code.
> * Proxy is all about Reflection through intercession - wrapping objects and intercepting their behaviours through traps.

`Reflect` is a new global Object (like `JSON` or `Math`) that provides a bunch of useful introspection methods (introspection is really just a fancy word for “looking at stuff”). Introspection tools already exist in JavaScript; `Object.keys`, `Object.getOwnPropertyNames`, etc. So why the need for a new API when these could just be added to `Object`?

## “Internal Methods”

All JavaScript specs, and therefore engines, come with a series of “internal methods”. Effectively these let the JavaScript engine perform essential operations on your Objects as it hops around your code. If you read through the spec, you’ll find these everywhere, things like `[[Get]]`, `[[Set]]`, `[[HasOwnProperty]]` and so on (if you’re having trouble sleeping, the full list of internal methods in [ES5 Section 8.12](https://es5.github.io/#x8.12)/[ES6 Section 9.1](https://www.ecma-international.org/ecma-262/6.0/index.html#sec-ordinary-object-internal-methods-and-internal-slots)).

Some of these “internal methods” were hidden from JavaScript code, others were applied in part by some methods, and even if there were available, they were tucked away inside various crevices, for example `Object.prototype.hasOwnProperty` is an implementation of `[[HasOwnProperty]]`, except not every object inherits from Object, and so you have to perform convoluted incantations just to use it - for example:

```
var myObject = Object.create(null); // Happens more often than you might think (especially with new ES6 classes)
assert(myObject.hasOwnProperty === undefined);
// If you want to use hasOwnProperty on `myObject`:
Object.prototype.hasOwnProperty.call(myObject, 'foo');
```

As another example, the `[[OwnPropertyKeys]]` internal method gets all of an Objects String keys and Symbol keys as one Array. The only way to get these (outside of Reflect) is to combined the results of `Object.getOwnPropertyNames` and `Object</span><span class="p">.getOwnPropertySymbols`:

```
var s = Symbol('foo');
var k = 'bar';
var o = { [s]: 1, [k]: 1 };
// Simulate [[OwnPropertyKeys]]
var keys = Object.getOwnPropertyNames(o).concat(Object.getOwnPropertySymbols(o));
assert.deepEqual(keys, [k, s]);
```

## Reflect methods

Reflect is effectively a collection of all of those _“internal methods”_ that were available exclusively through the JavaScript engine internals, now exposed in one single, handy object. You might be thinking “yeah, but why not just attach these to Object like `Object.keys`, `Object.getOwnPropertyNames` etc are?”. Here is why:

1. Reflect has methods that are not meant just for Objects, for example `Reflect.apply` - which targets a Function. Calling `Object.apply(myFunction)` would just look weird.
2. Having a single object to house these methods is a great way to keep the rest of JavaScript clean, rather than dotting Reflection methods throughout constructors and prototypes - or worse - globals.
3. `typeof`, `instanceof`, and `delete` already exist as Reflection operators - adding new keywords like this is not only cumbersome for developers, but also a nightmare for backwards compatibility and explodes the number of reserved words.

### Reflect.apply ( target, thisArgument [, argumentsList] )

`Reflect.apply` is pretty much just `Function#apply` - it takes a function, and calls it with a context, and an array of arguments. From this point on you _could_ consider the `Function#call`/`Function#apply` versions deprecated. This isn’t mind blowing, but it makes good sense. Here’s how you use it:

```
var ages = [11, 33, 12, 54, 18, 96];

// Function.prototype style:
var youngest = Math.min.apply(Math, ages);
var oldest = Math.max.apply(Math, ages);
var type = Object.prototype.toString.call(youngest);

// Reflect style:
var youngest = Reflect.apply(Math.min, Math, ages);
var oldest = Reflect.apply(Math.max, Math, ages);
var type = Reflect.apply(Object.prototype.toString, youngest);
```

The real benefit of Reflect.apply over Function.prototype.apply is defensibility: any code could trivially change the functions `call` or `apply` method, leaving you stuck with broken code or horrible workarounds. This doesn’t really end up being a huge deal in the real world, but code like the following could certainly exist:

```
function totalNumbers() {
  return Array.prototype.reduce.call(arguments, function (total, next) {
    return total + next;
  }, 0);
}
totalNumbers.apply = function () {
  throw new Error('Aha got you!');
}

totalNumbers.apply(null, [1, 2, 3, 4]); // throws Error('Aha got you!');

// The only way to defensively do this in ES5 code is horrible:
Function.prototype.apply.call(totalNumbers, null, [1, 2, 3, 4]) === 10;

//You could also do this, which is still not much cleaner:
Function.apply.call(totalNumbers, null, [1, 2, 3, 4]) === 10;

// Reflect.apply to the rescue!
Reflect.apply(totalNumbers, null, [1, 2, 3, 4]) === 10;
```

### Reflect.construct ( target, argumentsList [, constructorToCreateThis] )

Similar to `Reflect.apply` - this lets you call a Constructor with a set of arguments. This will work with Classes, and sets up the correct object so that Constructors have the right `this` object with the matching prototype. In ES5 land, you’d use the `Object.create(Constructor.prototype)` pattern, and pass that to `Constructor.call` or `Constructor.apply`. The difference with `Reflect.construct` is that rather than passing an object, you just pass the constructor - and `Reflect.construct` will handle all that jazz (alternatively, just omit it and it’ll default to the `target` argument). The old style of doing this was quite cumbersome, the new style can be much more succinct, as little as a one liner:

```
class Greeting {

    constructor(name) {
        this.name = name;
    }

    greet() {
      return `Hello ${name}`;
    }

}

// ES5 style factory:
function greetingFactory(name) {
    var instance = Object.create(Greeting.prototype);
    Greeting.call(instance, name);
    return instance;
}

// ES6 style factory
function greetingFactory(name) {
    return Reflect.construct(Greeting, [name], Greeting);
}

// Or, omit the third argument, and it will default to the first argument.
function greetingFactory(name) {
  return Reflect.construct(Greeting, [name]);
}

// Super slick ES6 one liner factory function!
const greetingFactory = (name) => Reflect.construct(Greeting, [name]);
```

### Reflect.defineProperty ( target, propertyKey, attributes )

`Reflect.defineProperty` pretty much takes over from `Object.defineProperty` - it lets you define metadata about a property. It fits much better here because Object.* implies that it acts on object literals (it is, after all, the Object literal constructor), while Reflect.defineProperty just implies that what you’re doing is Reflection, which is more semantic.

An important note is that `Reflect.defineProperty` - just like `Object.defineProperty` - will throw a `TypeError` for invalid `target`s, such Number or String primitives ( `Reflect.defineProperty(1, 'foo')`). This is a good thing, because throwing errors for wrong argument types notifies you of problems much better than silently failing.

Once again, you could consider `Object.defineProperty` pretty much deprecated from here on out. Use `Reflect.defineProperty` instead.

```
function MyDate() {
  /*…*/
}

// Old Style, weird because we're using Object.defineProperty to define
// a property on Function (why isn't there a Function.defineProperty?)
Object.defineProperty(MyDate, 'now', {
  value: () => currentms
});

// New Style, not weird because Reflect does Reflection.
Reflect.defineProperty(MyDate, 'now', {
  value: () => currentms
});
```

### Reflect.getOwnPropertyDescriptor ( target, propertyKey )

This, once again, pretty much replaces `Object.getOwnPropertyDescriptor`, getting the descriptor metadata of a property. The key difference is that while `Object.getOwnPropertyDescriptor(1, 'foo')` silently fails, returning `undefined`, `Reflect.getOwnPropertyDescriptor(1, 'foo')` will throw a `TypeError` - it throws for invalid arguments, just like `Reflect.defineProperty` does. You’re probably getting the idea by now - but `Reflect.getOwnPropertyDescriptor` pretty much deprecates `Object.getOwnPropertyDescriptor`.

```
var myObject = {};
Object.defineProperty(myObject, 'hidden', {
  value: true,
  enumerable: false,
});
var theDescriptor = Reflect.getOwnPropertyDescriptor(myObject, 'hidden');
assert.deepEqual(theDescriptor, { value: true, enumerable: true });

// Old style
var theDescriptor = Object.getOwnPropertyDescriptor(myObject, 'hidden');
assert.deepEqual(theDescriptor, { value: true, enumerable: true });

assert(Object.getOwnPropertyDescriptor(1, 'foo') === undefined)
Reflect.getOwnPropertyDescriptor(1, 'foo'); // throws TypeError
```

### Reflect.deleteProperty ( target, propertyKey )

`Reflect.deleteProperty` will, surprise surprise, delete a property off of the target object. Pre ES6, you’d typically write `delete obj.foo`, now you can write `Reflect.deleteProperty(obj, 'foo')`. This is slightly more verbose, and the semantics are slightly different to the delete keyword, but it has the same basic effect for objects. Both of them call the internal `target[[Delete]](propertyKey)` method - but the `delete` operator also “works” for non-object references (i.e. variables), and so it does more checking on the operand passed to it, and has more potential to throw:

```
var myObj = { foo: 'bar' };
delete myObj.foo;
assert(myObj.hasOwnProperty('foo') === false);

myObj = { foo: 'bar' };
Reflect.deleteProperty(myObj, 'foo');
assert(myObj.hasOwnProperty('foo') === false);
```

Once again, you could consider this to be the “new way” to delete properties - if you wanted to. It’s certainly more explicit to its intention.

### Reflect.getPrototypeOf ( target )

The theme of replacing/deprecating Object methods continues - this time `Object.getPrototypeOf`. Just like its siblings, the new `Reflect.getPrototypeOf` method will throw a `TypeError` if you give it an invalid `target` such as a Number or String literal, `null` or `undefined`, where `Object.getPrototypeOf` coerces the `target` to be an object - so `'a'` becomes `Object('a')`. Syntax otherwise, is exactly the same.

```
var myObj = new FancyThing();
assert(Reflect.getPrototypeOf(myObj) === FancyThing.prototype);

// Old style
assert(Object.getPrototypeOf(myObj) === FancyThing.prototype);

Object.getPrototypeOf(1); // undefined
Reflect.getPrototypeOf(1); // TypeError
```

### Reflect.setPrototypeOf ( target, proto )

Of course, you couldn’t have `getPrototypeOf` without `setPrototypeOf`. Now, `Object.setPrototypeOf` will throw for non-objects, but it tries to coerce the given argument into an Object, and also if the `[[SetPrototype]]` internal operation fails, it’ll throw a `TypeError`, if it succeeds it’ll return the `target` argument. `Reflect.setPrototypeOf` is much more basic - if it receives a non-object it’ll throw a `TypeError`, but other than that, it’ll just return the result of `[[SetPrototypeOf]]` - which is a Boolean indicating if the operation was successful. This is useful because then you can manage the outcome without resorting to using a `try`/`catch` which will also catch any other `TypeErrors` from passing in incorrect arguments.

```
var myObj = new FancyThing();
assert(Reflect.setPrototypeOf(myObj, OtherThing.prototype) === true);
assert(Reflect.getPrototypeOf(myObj) === OtherThing.prototype);

// Old style
assert(Object.setPrototypeOf(myObj, OtherThing.prototype) === myObj);
assert(Object.getPrototypeOf(myObj) === FancyThing.prototype);

Object.setPrototypeOf(1); // TypeError
Reflect.setPrototypeOf(1); // TypeError

var myFrozenObj = new FancyThing();
Object.freeze(myFrozenObj);

Object.setPrototypeOf(myFrozenObj); // TypeError
assert(Reflect.setPrototypeOf(myFrozenObj) === false);
```

### Reflect.isExtensible (target)

Ok, once again this one is just a replacement of `Object.isExtensible` - but its a bit more complicated than that. Prior to ES6 (so… ES5) `Object.isExtensible` threw a `TypeError` if you fed it a non-object (`typeof target !== 'object'`). ES6 semantics have changed this (Gasp! A change to the existing API!) so that passing in a non-object to `Object.isExtensible` will now return `false` - because non-objects are all not extensible. So code like `Object.isExtensible(1) === false` would throw, whereas ES6 runs the statement like you’d expect (evaluating to true).

The point of the brief history lesson is that `Reflect.isExtensible` uses the old behavior, of throwing on non-objects. I’m not really sure why it does, but it does. So technically `Reflect.isExtensible` changes the semantics against `Object.isExtensible`, but `Object.isExtensible` changed anyway. Here’s some code to illustrate:

```
var myObject = {};
var myNonExtensibleObject = Object.preventExtensions({});

assert(Reflect.isExtensible(myObject) === true);
assert(Reflect.isExtensible(myNonExtensibleObject) === false);
Reflect.isExtensible(1); // throws TypeError
Reflect.isExtensible(false);  // throws TypeError

// Using Object.isExtensible
assert(Object.isExtensible(myObject) === true);
assert(Object.isExtensible(myNonExtensibleObject) === false);

// ES5 Object.isExtensible semantics
Object.isExtensible(1); // throws TypeError on older browsers
Object.isExtensible(false);  // throws TypeError on older browsers

// ES6 Object.isExtensible semantics
assert(Object.isExtensible(1) === false); // only on newer browsers
assert(Object.isExtensible(false) === false); // only on newer browsers
```

### Reflect.preventExtensions ( target )

This is the last method in the Reflection object that borrows from Object. This follows the same story as `Reflect.isExtensible`; ES5’s `Object.preventExtensions` used to throw on non-objects, but now in ES6 it returns the value back, while `Reflect.preventExtensions` follows the old ES5 behaviour - throwing on non-objects. Also, while `Object.preventExtensions` has the potential to throw, `Reflect.preventExtensions` will simply return `true` or `false`, depending on the success of the operation, allowing you to gracefully handle the failure scenario.

```
var myObject = {};
var myObjectWhichCantPreventExtensions = magicalVoodooProxyCode({});

assert(Reflect.preventExtensions(myObject) === true);
assert(Reflect.preventExtensions(myObjectWhichCantPreventExtensions) === false);
Reflect.preventExtensions(1); // throws TypeError
Reflect.preventExtensions(false);  // throws TypeError

// Using Object.isExtensible
assert(Object.isExtensible(myObject) === true);
Object.isExtensible(myObjectWhichCantPreventExtensions); // throws TypeError

// ES5 Object.isExtensible semantics
Object.isExtensible(1); // throws TypeError
Object.isExtensible(false);  // throws TypeError

// ES6 Object.isExtensible semantics
assert(Object.isExtensible(1) === false);
assert(Object.isExtensible(false) === false);
```

### Reflect.enumerate ( target )

> Update: This was removed in ES2016 (aka ES7). `myObject[Symbol.iterator]()` is the only way to enumerate an Object’s keys or values now.

Finally a completely new Reflect method! `Reflect.enumerate` uses the same semantics as the new `Symbol.iterator` function (discussed in the previous article), both use the hidden `[[Enumerate]]` method that JavaScript engines are aware of. In other words, the only alternative to `Reflect.enumerate` is `myObject[Symbol.iterator]()`, except of course the `Symbol.iterator` can be overridden, while `Reflect.enumerate` can never be overridden. Used like so:

```
var myArray = [1, 2, 3];
myArray[Symbol.enumerate] = function () {
  throw new Error('Nope!');
}
for (let item of myArray) { // error thrown: Nope!
}
for (let item of Reflect.enumerate(myArray)) {
  // 1 then 2 then 3
}
```

### Reflect.get ( target, propertyKey [ , receiver ])

Reflect.get is also a completely new method. It’s quite a simple method; it effectively calls  `target[propertyKey]`. If `target` is a non-object, the function call will throw - which is good because currently if you were to do something like `1['foo']` it just silently returns `undefined`, `while Reflect.get(1, 'foo')` will throw a `TypeError`! One interesting part of `Reflect.get` is the receiver argument, which essentially acts as the `this` argument if `target[propertyKey]` is a getter function, for example:

```
var myObject = {
  foo: 1,
  bar: 2,
  get baz() {
    return this.foo + this.bar;
  },
}

assert(Reflect.get(myObject, 'foo') === 1);
assert(Reflect.get(myObject, 'bar') === 2);
assert(Reflect.get(myObject, 'baz') === 3);
assert(Reflect.get(myObject, 'baz', myObject) === 3);

var myReceiverObject = {
  foo: 4,
  bar: 4,
};
assert(Reflect.get(myObject, 'baz', myReceiverObject) === 8);

// Non-objects throw:
Reflect.get(1, 'foo'); // throws TypeError
Reflect.get(false, 'foo'); // throws TypeError

// These old styles don't throw:
assert(1['foo'] === undefined);
assert(false['foo'] === undefined);
```

### Reflect.set ( target, propertyKey, V [ , receiver ] )

You can probably guess what this method does. It’s the sibling to `Reflect.get`, and it takes one extra argument - the value to set. Just like `Reflect.get`, `Reflect.set` will throw on non-objects, and has a special `receiver` argument which acts as the `this` value if `target[propertyKey]` is a setter function. Obligatory code example:

```
var myObject = {
  foo: 1,
  set bar(value) {
    return this.foo = value;
  },
}

assert(myObject.foo === 1);
assert(Reflect.set(myObject, 'foo', 2));
assert(myObject.foo === 2);
assert(Reflect.set(myObject, 'bar', 3));
assert(myObject.foo === 3);
assert(Reflect.set(myObject, 'bar', myObject) === 4);
assert(myObject.foo === 4);

var myReceiverObject = {
  foo: 0,
};
assert(Reflect.set(myObject, 'bar', 1, myReceiverObject));
assert(myObject.foo === 4);
assert(myReceiverObject.foo === 1);

// Non-objects throw:
Reflect.set(1, 'foo', {}); // throws TypeError
Reflect.set(false, 'foo', {}); // throws TypeError

// These old styles don't throw:
1['foo'] = {};
false['foo'] = {};
assert(1['foo'] === undefined);
assert(false['foo'] === undefined);
```

### Reflect.has ( target, propertyKey )

`Reflect.has` is an interesting one, because it is essentially the same functionality as the `in` operator (outside of a loop). Both use the `[[HasProperty]]` internal method, and both throw if the `target` isn’t an object. Because of this there’s little point in using `Reflect.has` over `in` unless you prefer the function-call style, but it has important use in other parts of the language, which will become clear in the next post. Anyway, here’s how you use it:

```
myObject = {
  foo: 1,
};
Object.setPrototypeOf(myObject, {
  get bar() {
    return 2;
  },
  baz: 3,
});

// Without Reflect.has
assert(('foo' in myObject) === true);
assert(('bar' in myObject) === true);
assert(('baz' in myObject) === true);
assert(('bing' in myObject) === false);

// With Reflect.has:
assert(Reflect.has(myObject, 'foo') === true);
assert(Reflect.has(myObject, 'bar') === true);
assert(Reflect.has(myObject, 'baz') === true);
assert(Reflect.has(myObject, 'bing') === false);
```

### Reflect.ownKeys ( target )

This has already been discussed a tiny bit in this article, you see `Reflect.ownKeys` implements `[[OwnPropertyKeys]]` which if you recall above is a combination of `Object.getOwnPropertyNames` and `Object.getOwnPropertySymbols`. This makes `Reflect.ownKeys` uniquely useful. Lets see shall we:

```
var myObject = {
  foo: 1,
  bar: 2,
  [Symbol.for('baz')]: 3,
  [Symbol.for('bing')]: 4,
};

assert.deepEqual(Object.getOwnPropertyNames(myObject), ['foo', 'bar']);
assert.deepEqual(Object.getOwnPropertySymbols(myObject), [Symbol.for('baz'), Symbol.for('bing')]);

// Without Reflect.ownKeys:
var keys = Object.getOwnPropertyNames(myObject).concat(Object.getOwnPropertySymbols(myObject));
assert.deepEqual(keys, ['foo', 'bar', Symbol.for('baz'), Symbol.for('bing')]);

// With Reflect.ownKeys:
assert.deepEqual(Reflect.ownKeys(myObject), ['foo', 'bar', Symbol.for('baz'), Symbol.for('bing')]);
```

## Conclusion

We’ve pretty exhaustively gone over every Reflect method. We’ve seen some are newer versions of common existing methods, sometimes with a few tweaks, and some are entirely new methods - allowing new levels of Reflection within JavaScript. If you want to - you could totally ditch `Object`.`*/Function.*` methods and use the new `Reflect` ones instead, if you don’t want to - don’t sweat it, nothing bad will happen.

Now, I don’t want you to go away empty handed. If you want to use `Reflect`, then I’ve got your back - as part of the work behind this post, I submitted a [pull request to eslint](https://github.com/eslint/eslint/pull/2996) and as of `v1.0.0`, [ESlint has a](http://eslint.org/docs/rules/prefer-reflect) `prefer-reflect` [rule](http://eslint.org/docs/rules/prefer-reflect) which you can use to get ESLint to tell you off when you use the older version of Reflect methods. You could also take a look at my [eslint-config-strict](https://github.com/keithamus/eslint-config-strict) config, which has the `prefer-reflect` turned on (plus a bunch of others). Of course, if you decide you want to use Reflect, you’ll probably need to polyfill it; luckily there’s some good polyfills out there, such as [core-js](https://github.com/zloirock/core-js) and [harmony-reflect](https://github.com/tvcutsem/harmony-reflect).

What do you think about the new Reflect API? Plan on using it in your project? Let me know, in the comments below or on Twitter, where I’m [@keithamus](https://twitter.com/keithamus).

Oh - also don’t forget, the third and final part of this series - Part 3 Proxies - will be out soon, and I’ll try not to take 2 months to release it again!

Lastly, thanks to [@mttshw](https://twitter.com/mttshw) and [@WebReflection](https://twitter.com/WebReflection) for scrutinising my work and making this post much better than it would have been.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
