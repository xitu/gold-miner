> * 原文地址：[JavaScript Symbols: But Why?](https://medium.com/intrinsic/javascript-symbols-but-why-6b02768f4a5c)
> * 原文作者：[Thomas Hunter II](https://medium.com/@tlhunter)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/javascript-symbols-but-why.md](https://github.com/xitu/gold-miner/blob/master/TODO1/javascript-symbols-but-why.md)
> * 译者：
> * 校对者：

# JavaScript Symbols: But Why?

![](https://cdn-images-1.medium.com/max/3840/1*-6P9pSYh8qCbyzKu4AG88w.jpeg)

Symbols, the newest JavaScript primitive, bring a few benefits to the language and are particularly useful when used as object properties. But, what can they do for us that strings cannot?

Before we explore symbols too much let’s first look at some JavaScript features which many developers might not be aware of.

## Background

There are essentially two types of values in JavaScript. The first type is primitives, and the second type is objects (which also includes functions). Primitive values include simple value types such as numbers (which includes everything from integers to floats to `Infinity` to `NaN`), booleans, strings, `undefined`, and `null` (note: even though `typeof null === 'object'`, `null` is a still primitive value).

Primitive values are also immutable. They can’t be changed. Of course, a variable with a primitive assigned **can** be reassigned. For example, when you write the code `let x = 1; x++;`, you've reassigned the variable `x`. But, you haven't mutated the primitive numeric value of `1`.

Some languages, such as C, have the concept of pass-by-reference and pass-by-value. JavaScript sort of has this concept too, though, it’s inferred based on the type of data being passed around. If you ever pass a value into a function, reassigning that value will not modify the value in the calling location. However, if you **modify** a non-primitive value, the modified value **will** also be modified where it has been called from.

Consider the following example:

```js
function primitiveMutator(val) {
  val = val + 1;
}

let x = 1;
primitiveMutator(x);
console.log(x); // 1

function objectMutator(val) {
  val.prop = val.prop + 1;
}

let obj = { prop: 1 };
objectMutator(obj);
console.log(obj.prop); // 2
```

Primitive values (except for the mystical `NaN` value) will always be exactly equal to another primitive with an equivalent value. Check it out here:

```js
const first = "abc" + "def";
const second = "ab" + "cd" + "ef";

console.log(first === second); // true
```

However, constructing equivalent non-primitive values will **not** result in values which are exactly equal. We can see this happening here:

```js
const obj1 = { name: "Intrinsic" };
const obj2 = { name: "Intrinsic" };

console.log(obj1 === obj2); // false

// Though, their .name properties ARE primitives:
console.log(obj1.name === obj2.name); // true
```

Objects play an elemental role in the JavaScript language. They’re used **everywhere**. They’re often used as collections of key/value pairs. However, this is a big limitation of using them in this manner: Until symbols existed, object keys could only be strings. If we ever attempt to use a non-string value as a key for an object, the value will be coerced to a string. We can see this feature here:

```js
const obj = {};
obj.foo = 'foo';
obj['bar'] = 'bar';
obj[2] = 2;
obj[{}] = 'someobj';

console.log(obj);
// { '2': 2, foo: 'foo', bar: 'bar',
     '[object Object]': 'someobj' }
```

**Note**: It’s slightly off topic, but the `Map` data structure was created in part to allow for key/value storage in situations where a key is not a string.

## What is a Symbol?

Now that we know what a primitive value is, we’re finally ready to define what a symbol is. A symbol is a primitive which cannot be recreated. In this case a symbols is similar to an object as creating multiple instances will result in values which are not exactly equal. But, a symbol is also a primitive in that it cannot be mutated. Here is an example of symbol usage:

```js
const s1 = Symbol();
const s2 = Symbol();

console.log(s1 === s2); // false
```

When instantiating a symbol there is an optional first argument where you can choose to provide it with a string. This value is intended to be used for debugging code, it otherwise doesn’t really affect the symbol itself.

```js
const s1 = Symbol('debug');
const str = 'debug';
const s2 = Symbol('xxyy');

console.log(s1 === str); // false
console.log(s1 === s2); // false
console.log(s1); // Symbol(debug)
```

## Symbols as Object Properties

Symbols have another important use. They can be used as keys in objects! Here is an example of using a symbol as a key within an object:

```js
const obj = {};
const sym = Symbol();
obj[sym] = 'foo';
obj.bar = 'bar';

console.log(obj); // { bar: 'bar' }
console.log(sym in obj); // true
console.log(obj[sym]); // foo
console.log(Object.keys(obj)); // ['bar']
```

Notice how they are not returned in the result of `Object.keys()`. This is, again, for the purpose of backwards compatibility. Old code isn't aware of symbols and so this result shouldn't be returned from the ancient `Object.keys()` method.

At first glance, this almost looks like symbols can be used to create private properties on an object! Many other programming languages have hidden properties in their classes and this omission has long been seen as a shortcoming of JavaScript.

Unfortunately, it is still possible for code which interacts with this object to access properties whose keys are symbols. This is even possible in situations where the calling code does **not** already have access to the symbol itself. As an example, the `Reflect.ownKeys()` method is able to get a list of **all** keys on an object, both strings and symbols alike:

```js
function tryToAddPrivate(o) {
  o[Symbol('Pseudo Private')] = 42;
}

const obj = { prop: 'hello' };
tryToAddPrivate(obj);

console.log(Reflect.ownKeys(obj));
        // [ 'prop', Symbol(Pseudo Private) ]
console.log(obj[Reflect.ownKeys(obj)[1]]); // 42
```

**Note**: There is currently work being done to tackle the issue of adding private properties to classes in JavaScript. The name of this feature is called [Private Fields](https://github.com/tc39/proposal-class-fields#private-fields), and although this won’t benefit **all** objects, it will benefit objects which are class instances. Private Fields are available as of Chrome 74.

## Preventing Property Name Collisions

Symbols may not directly benefit JavaScript for providing private properties to objects. However, they are beneficial for another reason. They are useful in situations where disparate libraries want to add properties to objects without the risk of having name collisions.

Consider the situation where two different libraries want to attach some sort of metadata to an object. Perhaps they both want to set some sort of identifier on the object. By simply using the two character string `id` as a key, there is a huge risk that multiple libraries will use the same key.

```js
function lib1tag(obj) {
  obj.id = 42;
}

function lib2tag(obj) {
  obj.id = 369;
}
```

By making use of symbols, each library can generate their required symbols upon instantiation. Then the symbols can be checked on objects, and set to objects, whenever an object is encountered.

```js
const library1property = Symbol('lib1');
function lib1tag(obj) {
  obj[library1property] = 42;
}

const library2property = Symbol('lib2');
function lib2tag(obj) {
  obj[library2property] = 369;
}
```

For this reason it would seem that symbols **do** benefit JavaScript.

However, you may be wondering, why can’t each library simply generate a random string, or use a specially namespaced string, upon instantiation?

```js
const library1property = uuid(); // random approach
function lib1tag(obj) {
  obj[library1property] = 42;
}

const library2property = 'LIB2-NAMESPACE-id'; // namespaced approach
function lib2tag(obj) {
  obj[library2property] = 369;
}
```

Well, you’d be right. This approach is actually pretty similar to the approach with symbols. Unless two libraries would choose to use the same property name, then there wouldn’t be a risk of overlap.

At this point the astute reader would point out that the two approaches haven’t been entirely equal. Our property names with unique names still have a shortcoming: their keys are very easy to find, especially when code runs to either iterate the keys or to otherwise serialize the objects. Consider the following example:

```js
const library2property = 'LIB2-NAMESPACE-id'; // namespaced
function lib2tag(obj) {
  obj[library2property] = 369;
}

const user = {
  name: 'Thomas Hunter II',
  age: 32
};

lib2tag(user);

JSON.stringify(user);
// '{"name":"Thomas Hunter II","age":32,"LIB2-NAMESPACE-id":369}'
```

If we had used a symbol for a property name of the object then the JSON output would not contain its value. Why is that? Well, just because JavaScript gained support for symbols doesn’t mean that the JSON spec has changed! JSON only allows strings as keys and JavaScript won’t make any attempt to represent symbol properties in the final JSON payload.

We can easily rectify the issue where our library object strings are polluting the JSON output by making use of `Object.defineProperty()`:

```js
const library2property = uuid(); // namespaced approach
function lib2tag(obj) {
  Object.defineProperty(obj, library2property, {
    enumerable: false,
    value: 369
  });
}

const user = {
  name: 'Thomas Hunter II',
  age: 32
};

lib2tag(user);

// '{"name":"Thomas Hunter II",
   "age":32,"f468c902-26ed-4b2e-81d6-5775ae7eec5d":369}'
console.log(JSON.stringify(user));
console.log(user[library2property]); // 369
```

String keys which have been “hidden” by setting their `enumerable` [descriptor](https://medium.com/intrinsic/javascript-object-property-descriptors-proxies-and-preventing-extension-1e1907aa9d10) to false behave very similarly to symbol keys. Both are hidden by `Object.keys()`, and both are revealed with `Reflect.ownKeys()`, as seen in the following example:

```js
const obj = {};
obj[Symbol()] = 1;
Object.defineProperty(obj, 'foo', {
  enumberable: false,
  value: 2
});

console.log(Object.keys(obj)); // []
console.log(Reflect.ownKeys(obj)); // [ 'foo', Symbol() ]
console.log(JSON.stringify(obj)); // {}
```

At this point we’ve **nearly** recreated symbols. Both our hidden string properties and symbols are hidden from serializers. Both properties can be extracted using the `Reflect.ownKeys()` method and are therefor not actually private. Assuming we use some sort of namespace / random value for the string version of the property name then we've removed the risk of multiple libraries accidentally having a name collision.

But, there’s still just one tiny difference. Since strings are immutable, and symbols are always guaranteed to be unique, there is still the potential for someone to generate every single possible string combination and come up with a collision. Mathematically this means symbols do provide a benefit that we just can’t get from strings.

In Node.js, when inspecting an object (such as using `console.log()`), if a method on the object named `inspect` is encountered, that function is invoked and the output is used as the logged representation of the object. As you can imagine, this behavior isn't expected by everyone and the generically-named `inspect` method often collides with objects created by users. There is now a symbol available for implementing this functionality and is available at require('util').inspect.custom. The `inspect` method is deprecated in Node.js v10 and entirely ignored in v11. Now no one will ever change the behavior of inspect by accident!

## Simulating Private Properties

Here’s an interesting approach that we can use to simulate private properties on an object. This approach will make use of another JavaScript feature available to us today: proxies. A proxy essentially wraps an object and allows us to interpose on various interactions with that object.

A proxy offers many ways to intercept actions performed on an object. The one we’re interested in affects when an attempt at reading the keys of an object occurs. I’m not going to entirely explain how proxies work, so if you’d like to learn more, check out our other post: [JavaScript Object Property Descriptors, Proxies, and Preventing Extension](https://medium.com/intrinsic/javascript-object-property-descriptors-proxies-and-preventing-extension-1e1907aa9d10).

We can use a proxy to then lie about which properties are available on our object. In this case we’re going to craft a proxy which hides our two known hidden properties, one being the string `_favColor`, and the other being the symbol assigned to `favBook`:

```js
let proxy;

{
  const favBook = Symbol('fav book');

  const obj = {
    name: 'Thomas Hunter II',
    age: 32,
    _favColor: 'blue',
    [favBook]: 'Metro 2033',
    [Symbol('visible')]: 'foo'
  };

  const handler = {
    ownKeys: (target) => {
      const reportedKeys = [];
      const actualKeys = Reflect.ownKeys(target);

      for (const key of actualKeys) {
        if (key === favBook || key === '_favColor') {
          continue;
        }
        reportedKeys.push(key);
      }

      return reportedKeys;
    }
  };

  proxy = new Proxy(obj, handler);
}

console.log(Object.keys(proxy)); // [ 'name', 'age' ]
console.log(Reflect.ownKeys(proxy)); // [ 'name', 'age', Symbol(visible) ]
console.log(Object.getOwnPropertyNames(proxy)); // [ 'name', 'age' ]
console.log(Object.getOwnPropertySymbols(proxy)); // [Symbol(visible)]
console.log(proxy._favColor); // 'blue'
```

It’s easy to come up with the `_favColor` string: just read the source code of the library. Additionally, dynamic keys (e.g., the `uuid` example from before) can be found via brute force. But without a direct reference to the symbol, no one can access the 'Metro 2033' value from the `proxy` object.

**Node.js Caveat**: There is a feature in Node.js which breaks the privacy of proxies. This feature doesn’t exist in the JavaScript language itself and doesn’t apply in other situations, such as a web browser. It allows one to gain access to the underlying object when given a proxy. Here is an example of using this functionality to break the above private property example:

```js
const [originalObject] = process
  .binding('util')
  .getProxyDetails(proxy);

const allKeys = Reflect.ownKeys(originalObject);
console.log(allKeys[3]); // Symbol(fav book)
```

We would now need to either modify the global `Reflect` object, or modify the `util` process binding, to prevent them from being used in a particular Node.js instance. But that's one heck of a rabbit hole. If you're interested in tumbling down such a rabbit hole, check out our other blog post: [Protecting your JavaScript APIs](https://medium.com/intrinsic/protecting-your-javascript-apis-9ce5b8a0e3b5).

This article was written by me, Thomas Hunter II. I work at a company called [Intrinsic](https://intrinsic.com/) (btw, [we’re hiring](mailto:jobs@intrinsic.com)!) where we specialize in writing software for securing Node.js applications. We currently have a product which follows the Least Privilege model for securing applications. Our product proactively protects Node.js applications from attackers, and is surprisingly easy to implement. If you are looking for a way to secure your Node.js applications, give us a shout at [hello@intrinsic.com](mailto:hello@intrinsic.com).

---

**Banner photo by [Chunlea Ju](https://unsplash.com/photos/8fs1X0JFgFE?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
