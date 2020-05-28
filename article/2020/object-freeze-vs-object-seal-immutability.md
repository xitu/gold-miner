> * 原文地址：[Object.freeze vs Object.seal — Immutability](https://medium.com/javascript-in-plain-english/object-freeze-vs-object-seal-immutability-7c22f80aa8ae)
> * 原文作者：[Moon](https://medium.com/@moonformeli)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/object-freeze-vs-object-seal-immutability.md](https://github.com/xitu/gold-miner/blob/master/article/2020/object-freeze-vs-object-seal-immutability.md)
> * 译者：
> * 校对者：

# Object.freeze vs Object.seal — Immutability

![Photo by [Christine Donaldson](https://unsplash.com/@christineashleydonaldson?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/7060/0*1n-sZ1kdhyX6Wf8_)

Data immutability has kept been very important in the Programming languages, in JavaScript as well. Here, there two JavaScript methods for partially guaranteeing immutability — Object.freeze and Object.seal. In this post, I will give you a comparison of those two methods, which are quite confusing.

## Object defineProperty

Before getting to know about each `freeze` and `seal` , we need to know what is the `defineProperty` method in Object, first. When an object is created by you or by the engine during the initial processing, JavaScript gives the basic attributes to the object, which is newly created, to handle the request from the outside, such as accessing or removing properties.

The attributes you can modify or set are as follows.

* value — The value of the property
* enumerable — If true, this lets the property be searchable by `for-in` loop or `Object.keys()` . Defaults to `false`.
* writable — If false, you can’t modify the property. It throws an error within the strict mode. Defaults to `false`.
* configurable — If false, this makes the property of an object non-enumerable, non-writable, non-deletable and non-configurable. Defaults to `false`.
* get — A function called ahead of time when you try to access the property. Defaults to `undefined`.
* set — A function called ahead of time when you try to set some value to the property. Defaults to `undefined`.

I know you’d be thinking what I’m talking about. So let’s take a look at some simple examples.

#### Enumerable

```js
const obj = {};

Object.defineProperty(obj, 'a', {
  value: 100,
  enumerable: false
});

for (const key in obj) {
  console.log(key);
}
// undefined

Object.keys(obj);
// []
```

#### Writable

```js
const obj = {};

Object.defineProperty(obj, 'a', {
  value: 100,
  writable: false
});

obj.a = 200;
obj.a === 100; // true

(() => {
  'use strict';
  obj.a = 100; 
  // TypeError in the strict mode
})()
```

#### Configurable

```js
const obj = {};

Object.defineProperty(obj, 'a', {
  value: 100,
  configurable: false
});

// 1. non-enumerable
for (const key in obj) {
  console.dir(key);
}
// undefined

Object.keys(obj);
// [

// 2. non-writable
(() => {
  'use strict';
  obj.a = 200;
  // TypeError in the strict mode
})()

// 3. non-deletable
delete obj.a;
obj.a === 100; // true
```

However, when `writable` or `enumerable` is `true` , `configurable: false` is ignored.

## Object.Seal

![Photo by [戸山 神奈](https://unsplash.com/@samuelsparkle?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/12000/0*8hPZaRH0h2uk2UpX)

What do you think of when you hear the word “seal”? The first meaning of “seal” is a stamp or a wax that closes a letter or something. In JavaScript, `Object.seal` also does the same thing as the “seal” does.

`Object.seal` makes all the properties of an object passed into it non-configurable. Let’s take an example.

```js
const obj = { a: 100 };
Object.getOwnPropertyDescriptors(obj);

/* { 
 *   a: { 
 *        configurable: true,
 *        enumerable: true,
 *        value: 100,
 *        writable: true
 *      }
 * }
 * 
 */

Object.seal(obj);
Object.getOwnPropertyDescriptors(obj);

/* { 
 *   a: { 
 *        configurable: false,
 *        enumerable: true,
 *        value: 100,
 *        writable: true
 *      }
 * }
 * 
 */

obj.a = 200;
console.log(obj.a);
// 200

delete obj.a;
console.log(obj.a);
// 200

obj.b = 500;
console.log(obj.b);
// undefined
```

So, the object `obj` has one property inside which the value is 100. And the initial descriptors of `obj` was like the above, `configurable`, `enumerable` and `writable` were all `true`. Then I sealed the object with `Object.seal` and look at what descriptors were changed and what weren’t — only `configurable`’s changed to `false`.

```js
obj.a = 200;
```

Even though the sealed object’s `configurable` is now false, the existing property value is changed to 200. As I explained earlier, setting `configurable` to `false` makes the property non-writable, it doesn’t work if `writable` is explicitly `true` , though. And when you create an object and set a new property, it has `writable: true` by default.

```js
delete obj.a;
```

Sealing the object makes every property non-configurable, which prevents them from non-deletable.

```js
obj.b = 500;
```

This failed after sealing the object, but why? When `Object.seal` or `Object.freeze` is called, the object passed into those turns into a non-extensible object, which means you can’t delete any properties from it or add any properties into it.

## Object.freeze

This restricts the passed object more than `Object.seal` . Let’s also take a similar example.

```js
const obj = { a: 100 };
Object.getOwnPropertyDescriptors(obj);

/* { 
 *   a: { 
 *        configurable: true,
 *        enumerable: true,
 *        value: 100,
 *        writable: true
 *      }
 * }
 * 
 */

Object.freeze(obj);
Object.getOwnPropertyDescriptors(obj);

/* { 
 *   a: { 
 *        configurable: false,
 *        enumerable: true,
 *        value: 100,
 *        writable: false
 *      }
 * }
 * 
 */

obj.a = 200;
console.log(obj.a);
// 100

delete obj.a;
console.log(obj.a);
// 200

obj.b = 500;
console.log(obj.b);
// undefined
```

So, the difference from `Object.seal` is that `writable` is also set to `false` , after freezing it.

```js
obj.a = 200;
```

Thus, modifying the exiting property always fails.

```js
delete obj.a;
```

Like `Object.seal` , `Object.freeze` also makes the passed object non-configurable, which makes every property inside it non-deletable.

```js
obj.b = 500;
```

Freezing the object also makes the object non-extensible.

## What do they have in common?

1. The passed object becomes non-extensible, meaning that you can’t add new properties.
2. Every element inside the passed object becomes non-configurable, meaning that you can’t delete them.
3. Both methods could throw an error if the operation is called in ‘use strict’ mode, such as `obj.a = 500` in the strict mode.

## Comparison

`Object.seal` lets you modify the property and `Object.freeze` does not.

## Flaw

Both `Object.freeze` and `Object.seal` have a “flaw” in terms of “practical”, they only freezes/seals the object’s first depth.

Here’s the quick comparison.

```js
const obj = {
  foo: {
    bar: 10
  }
};
```

Now `obj` has the nested object inside, `foo` . It has `bar` inside.

```js
Object.getOwnPropertyDescriptors(obj);
/* { 
 *   foo: { 
 *        configurable: true,
 *        enumerable: true,
 *        value: {bar: 10},
 *        writable: true
 *      }
 * }
 */

Object.getOwnPropertyDescriptors(obj.foo);
/* { 
 *   bar: { 
 *        configurable: true,
 *        enumerable: true,
 *        value: 10,
 *        writable: true
 *      }
 * }
 */
```

And after sealing or freezing it,

```js
Object.seal(obj);
Object.freeze(obj);

// Either way is fine for this test
```

Let’s see how descriptors got changed.

```js
Object.getOwnPropertyDescriptors(obj);
/* { 
 *   foo: { 
 *        configurable: false,
 *        enumerable: true,
 *        value: {bar: 10},
 *        writable: false
 *      }
 * }
 */

Object.getOwnPropertyDescriptors(obj.foo);
/* { 
 *   bar: { 
 *        configurable: true,
 *        enumerable: true,
 *        value: 10,
 *        writable: true
 *      }
 * }
 */
```

`foo` ’s descriptors got changed but `obj.foo` the nested object. This means it’s still be modifiable.

```js
obj.foo = { bar: 50 };
// Doesn't work
```

Since `obj.foo` doesn’t let you change its value because it’s frozen,

```js
obj.foo.bar = 50;
// It works
```

`obj.foo.bar` still lets you change its value because it isn’t frozen.

Then how can you freeze/seal the object to the bottommost nested object? MDN suggests you the [workaround](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/freeze#What_is_shallow_freeze) for this.

```js
function deepFreeze(object) {

  // Retrieve the property names defined on object
  var propNames = Object.getOwnPropertyNames(object);

  // Freeze properties before freezing self
  
  for (let name of propNames) {
    let value = object[name];

    if(value && typeof value === "object") { 
      deepFreeze(value);
    }
  }

  return Object.freeze(object);
}
```

The result of testing is as follows.

```js
const obj = { foo: { bar: 10 } };
deepFreeze(obj);

obj.foo = { bar: 50 };
// Doesn't work

obj.foo.bar = 50;
// Doesn't work
```

## Conclusion

`Object.freeze` and `Object.seal` could be definitely useful methods. But you should consider that the nested objects also should be frozen as well, using `deepFreeze`.

## Resources

* [Object.definedProperty — MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/defineProperty)
* [Object.freeze — MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/freeze)
* [Object.seal — MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/seal)
* [Object.getOwnPropertyDescriptors — MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/getOwnPropertyDescriptors)
* [Difference between Configurable and Writable attributes of an Object](https://stackoverflow.com/questions/23590502/difference-between-configurable-and-writable-attributes-of-an-object)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
