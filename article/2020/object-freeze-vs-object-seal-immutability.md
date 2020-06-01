> * 原文地址：[Object.freeze vs Object.seal — Immutability](https://medium.com/javascript-in-plain-english/object-freeze-vs-object-seal-immutability-7c22f80aa8ae)
> * 原文作者：[Moon](https://medium.com/@moonformeli)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/object-freeze-vs-object-seal-immutability.md](https://github.com/xitu/gold-miner/blob/master/article/2020/object-freeze-vs-object-seal-immutability.md)
> * 译者：[Gesj-yean](https://github.com/Gesj-yean)
> * 校对者：[rachelcdev](https://github.com/rachelcdev)

# Object.freeze VS Object.seal —— JavaScript 数据不变性

![图片来自 [Christine Donaldson](https://unsplash.com/@christineashleydonaldson?utm_source=medium&utm_medium=referral) 在 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/7060/0*1n-sZ1kdhyX6Wf8_)

在编程语言中，数据的不变性一直是非常重要的，在 JavaScript 中也是如此。这里有两种 JavaScript 方法可以保证数据部分不变性—— Object.freeze 和 Object.seal。在这篇文章中，我将比较这两种令人相当困惑的方法。

## Object 中 defineProperty 方法

在了解 `freeze` 和 `seal` 之前，我们首先需要知道 Object 中的 `defineProperty` 方法是什么。当你或者浏览器引擎在初始化进程中创建对象时，JavaScript 会为新创建的对象提供基本属性，以处理来自外部的请求，例如访问或删除对象的属性。

可以像下面这样修改或设置对象的属性。

* value —— 属性的值。
* enumerable —— 可枚举性，当它为真时，就可以让 `for-in` 或 `Object.keys()` 遍历到。 可枚举性默认为 `false`。
* writable —— 可写性，当它为假时，就不能修改属性。在严格模式下它会抛出错误。默认为 `false`。
* configurable —— 可配置性，当它为假时，它使得对象的属性不可枚举、不可写、不可删除和不可配置。默认为 `false`。
* get —— 当你访问属性时提前调用的函数。 默认为 `undefined`。
* set —— 当你为属性设置某个值时提前调用的函数。 默认为 `undefined`.

我知道你和我想的一样。我们来看一些简单的例子吧。

### 可枚举性 Enumerable

```js
const obj = {};

Object.defineProperty(obj, 'a', {
  value: 100,
  enumerable: false
});

for (const key in obj) {
  console.log(key);
}
// 输出：undefined

Object.keys(obj);
// 输出：[]
```

### 可写性 Writable

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
  // 在严格模式下回抛出 TypeError 错误
})()
```

### 可配置性 Configurable

```js
const obj = {};

Object.defineProperty(obj, 'a', {
  value: 100,
  configurable: false
});

// 1. 不可枚举
for (const key in obj) {
  console.dir(key);
}
// 输出：undefined

Object.keys(obj);
// 输出：[]

// 2. 不可写
(() => {
  'use strict';
  obj.a = 200;
  // 在严格模式下回抛出 TypeError 错误
})()

// 3. 不可删除
delete obj.a;
obj.a === 100; // 输出：true
```

但是当 `writable` 或 `enumerable` 为 `true` 时，`configurable: false` 就会无效。

## Object.Seal

![图片来自 [戸山 神奈](https://unsplash.com/@samuelsparkle?utm_source=medium&utm_medium=referral) 在 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/12000/0*8hPZaRH0h2uk2UpX)

当你听到 “seal” 这个词时，你会想到什么？ “seal” 的第一个意思是印章或者蜜蜡之类封信件的东西。在 JavaScript 中 `Object.seal` 的作用与 “密封” 相同。

`Object.seal` 使传入对象的所有属性都不可配置。来举个例子。

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
// 输出：200

delete obj.a;
console.log(obj.a);
// 输出：200

obj.b = 500;
console.log(obj.b);
// 输出：undefined
```

对象 `obj` 只有一个值为 100 的属性。`obj` 的基本属性就像上面一样，`configurable`, `enumerable` 和 `writable` 都是 `true`。然后我用 `Object.seal` 把它封起来，想要看看哪些基本属性被修改了，哪些没有。结果是，只有 `configurable` 被改成了 `false`。

```js
obj.a = 200;
```

即使被密封对象的基本属性 `configurable` 现在为 false，但属性值也被更改为 200。如前所述，将 `configurable`设置为 `false` 将使属性不可写，但如果 `writable` 已经写明为 `true` 时，`configurable`设置为 `false` 将不会生效。当你创建一个对象并添加一个新属性时，默认情况下它是 `writable: true` 。

```js
delete obj.a;
```

封装对象使每个属性变为不可配置，从而使属性不可删除。

```js
obj.b = 500;
```

Object.seal 后删除属性失败了是为什么呢？因为当调用 `Object.seal` 或 `Object.freeze` 时，传递给这些方法的对象变成不可扩展的对象，这意味着不能删除其中的任何属性或向其中添加任何属性。

## Object.freeze

`Object.freeze` 对传递的对象的限制比 `Object.seal` 更多。让我们再举一个例子。

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
// 输出：100

delete obj.a;
console.log(obj.a);
// 输出：100

obj.b = 500;
console.log(obj.b);
// 输出：undefined
```

所以， `Object.freeze` 和 `Object.seal` 的区别是在使用后，`Object.freeze` 的 `writable` 会被设置为 `false` 而 `Object.seal` 仍然为 `true` 。

```js
obj.a = 200;
```

因此，修改现有属性总是失败。

```js
delete obj.a;
```

就像 `Object.seal` 一样， `Object.freeze` 也使得传递的对象不可配置，这使得其中的每个属性都不可删除。

```js
obj.b = 500;
```

冻结对象也会使对象不可扩展。

## `Object.seal` 和 `Object.freeze` 的共同点

1. 作用的对象变得不可扩展，这意味着不能再添加新属性。
2. 作用的对象中的每个元素都变得不可配置，这意味着不能删除属性。
3. 如果在 ‘use strict’ 模式下使用，这两个方法都可能抛出错误，例如在严格模式下修改 `obj.a = 500`。

## `Object.seal` 和 `Object.freeze` 的不同点

`Object.seal` 能让你修改属性的值，但 `Object.freeze` 不能.

## 缺陷

`Object.freeze` 和 `Object.seal` 在 “实用性” 方面都有 ”缺陷“，他们只冻结/封印对象的第一深度。

这里有一个简单的比较。

```js
const obj = {
  foo: {
    bar: 10
  }
};
```

现在 `obj` 内部嵌套了一个对象 `foo`。 它内部有一个 `bar` 属性.

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

使用 `Object.freeze` 和 `Object.seal` 之后，

```js
Object.seal(obj);
Object.freeze(obj);

// 这两种方法都会导致相同结果
```

让我们看看基础属性是如何变化的。

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

`foo` 的基础属性已经改变但嵌套的 `obj.foo` 基础属性并没有变。这意味着嵌套的第二层仍然是可修改的。

```js
obj.foo = { bar: 50 };
// 没有生效
```

Since `obj.foo` doesn’t let you change its value because it’s frozen,
因为 `obj` 被冻结了，所以 `obj.foo` 不允许改变它的值，

```js
obj.foo.bar = 50;
// 生效了
```

但 `obj.foo.bar` 仍然允许你改变它的值，因为它没有被冻结。

那么如何将对象冻结/密封到最深层的嵌套对象呢？在 MDN 上可以查看到[解决方案](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/freeze#What_is_shallow_freeze)。

```js
function deepFreeze(object) {

  // 检索在对象上定义的属性名
  var propNames = Object.getOwnPropertyNames(object);

  // 在冻结自己之前先冻结属性
  
  for (let name of propNames) {
    let value = object[name];

    if(value && typeof value === "object") { 
      deepFreeze(value);
    }
  }

  return Object.freeze(object);
}
```

测试结果如下。

```js
const obj = { foo: { bar: 10 } };
deepFreeze(obj);

obj.foo = { bar: 50 };
// 不会生效

obj.foo.bar = 50;
// 不会生效
```

## 总结

`Object.freeze` 和 `Object.seal` 肯定是有用的方法。但是你应该考虑使用 `deepFreeze` 来冻结嵌套对象。

## 其他资源

* [Object.definedProperty — MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/defineProperty)
* [Object.freeze — MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/freeze)
* [Object.seal — MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/seal)
* [Object.getOwnPropertyDescriptors — MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/getOwnPropertyDescriptors)
* [Difference between Configurable and Writable attributes of an Object](https://stackoverflow.com/questions/23590502/difference-between-configurable-and-writable-attributes-of-an-object)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
