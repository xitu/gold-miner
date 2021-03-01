> * 原文地址：[undefined vs. null revisited](https://2ality.com/2021/01/undefined-null-revisited.html)
> * 原文作者：[Dr. Axel Rauschmayer](http://dr-axel.de/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/undefined-null-revisited.md](https://github.com/xitu/gold-miner/blob/master/article/2021/undefined-null-revisited.md)
> * 译者：
> * 校对者：

# undefined vs. null revisited

Many programming languages have one “non-value” called null. It indicates that a variable does not currently point to an object – for example, when it hasn’t been initialized yet.

In contrast, JavaScript has two such non-values: `undefined` and `null`. In this blog post, we examine how they differ and how to best use or avoid them.

## `undefined` vs. `null`

Both values are very similar and often used interchangeably. How they differ is therefore subtle.

### The ECMAScript language specification on `undefined` vs. `null`

The ECMAScript language specification describes them as follows:

* `undefined` is “used when a variable has not been assigned a value” [(source)](https://tc39.es/ecma262/#sec-undefined-value).
* `null` “represents the intentional absence of any object value” [(source)](https://tc39.es/ecma262/#sec-null-value).

We’ll see later how to best handle these two values as a programmer.

### Two non-values – a mistake that can’t be removed

Having two non-values in JavaScript is now considered a design mistake (even by JavaScript’s creator, Brendan Eich).

Why isn’t one of those values removed from JavaScript, then? One core principle of JavaScript is to never break backward compatibility. That principle has [many upsides](https://exploringjs.com/impatient-js/ch_history.html#backward-compatibility). Its biggest downside is that design mistakes can’t be removed.

### The history of `undefined` and `null`

In Java (which inspired many aspects of JavaScript), initialization values depend on the static type of a variable:

* Variables with object types are initialized with `null`.
* Each primitive type has its own initialization value. For example, `int` variables are initialized with `0`.

In JavaScript, each variable can hold both object values and primitive values. Therefore, if `null` means “not an object”, JavaScript also needs an initialization value that means “neither an object nor a primitive value”. That initialization value is `undefined`.

## Occurrences of `undefined` in the language

If a variable `myVar` has not been initialized yet, its value is `undefined`:

```js
let myVar;
assert.equal(myVar, undefined);
```

If a property `.unknownProp` is missing, accessing the property produces the values `undefined`:

```js
const obj = {};
assert.equal(obj.unknownProp, undefined);
```

If a function does not explicitly return anything, the function implicitly returns `undefined`:

```js
function myFunc() {}
assert.equal(myFunc(), undefined);
```

If a function has a `return` statement without an argument, the function implicitly returns `undefined`:

```js
function myFunc() {
  return;
}
assert.equal(myFunc(), undefined);
```

If a parameter `x` is omitted, the language initializes that parameter with `undefined`:

```js
function myFunc(x) {
  assert.equal(x, undefined);
}
myFunc();
```

[Optional chaining](https://exploringjs.com/impatient-js/ch_single-objects.html#optional-chaining) via `obj?.someProp` returns `undefined` if `obj` is `undefined` or `null`:

```repl
> undefined?.someProp
undefined
> null?.someProp
undefined
```

## Occurrences of `null` in the language

The prototype of an object is either an object or, at the end of a chain of prototypes, `null`. `Object.prototype` does not have a prototype:

```repl
> Object.getPrototypeOf(Object.prototype)
null
```

If we match a regular expression (such as `/a/`) against a string (such as `'x'`), we either get an object with matching data (if matching was successful) or `null` (if matching failed):

```repl
> /a/.exec('x')
null
```

The [JSON data format](#ch_json) does not support `undefined`, only `null`:

```repl
> JSON.stringify({a: undefined, b: null})
'{"b":null}'
```

## Operators that treat `undefined` and/or `null` specially

### `undefined` and parameter default values

A parameter default value is used if:

* A parameter is missing.
* A parameter has the value `undefined`.

For example:

```js
function myFunc(arg='abc') {
  return arg;
}
assert.equal(myFunc('hello'), 'hello');
assert.equal(myFunc(), 'abc');
assert.equal(myFunc(undefined), 'abc');
```

That `undefined` also triggers the parameter default value points towards it being a metavalue.

The following example demonstrates where that is useful:

```js
function concat(str1='', str2='') {
  return str1 + str2;
}
function twice(str) { // (A)
  return concat(str, str);
}
```

In line A, we don’t specify a parameter default value for `str`. When this parameter is missing, we forward that status to `concat()` and let it pick a default value.

### `undefined` and destructuring default values

Default values in destructuring work similarly to parameter default values – they are used if a variable either has no match in the data or if it matches `undefined`:

```js
const [a='a'] = [];
assert.equal(a, 'a');

const [b='b'] = [undefined];
assert.equal(b, 'b');

const {prop: c='c'} = {};
assert.equal(c, 'c');

const {prop: d='d'} = {prop: undefined};
assert.equal(d, 'd');
```

### `undefined` and `null` and optional chaining

When there is [optional chaining](https://exploringjs.com/impatient-js/ch_single-objects.html#optional-chaining) via `value?.prop`:

* If `value` is `undefined` or `null`, return `undefined`. That is, this happens whenever `value.prop` would throw an exception.
* Otherwise, return `value.prop`.

```js
function getProp(value) {
  // optional static property access
  return value?.prop;
}
assert.equal(
  getProp({prop: 123}), 123);
assert.equal(
  getProp(undefined), undefined);
assert.equal(
  getProp(null), undefined);
```

The following two operations work similarly:

```js
obj?.[«expr»] // optional dynamic property access
func?.(«arg0», «arg1») // optional function or method call
```

### `undefined` and `null` and nullish coalescing

The [nullish coalescing operator `??`](https://exploringjs.com/impatient-js/ch_operators.html#nullish-coalescing-operator) lets us use a default value if a value is `undefined` or `null`:

```repl
> undefined ?? 'default value'
'default value'
> null ?? 'default value'
'default value'

> 0 ?? 'default value'
0
> 123 ?? 'default value'
123
> '' ?? 'default value'
''
> 'abc' ?? 'default value'
'abc'
```

The [nullish coalescing assignment operator `??=`](https://2ality.com/2020/06/logical-assignment-operators.html) combines nullish coalescing with assignment:

```js
function setName(obj) {
  obj.name ??= '(Unnamed)';
  return obj;
}
assert.deepEqual(
  setName({}),
  {name: '(Unnamed)'}
);
assert.deepEqual(
  setName({name: undefined}),
  {name: '(Unnamed)'}
);
assert.deepEqual(
  setName({name: null}),
  {name: '(Unnamed)'}
);
assert.deepEqual(
  setName({name: 'Jane'}),
  {name: 'Jane'}
);
```

## Handling `undefined` and `null`

The following subsections explain the most common ways of handling `undefined` and `null` in our own code.

### Neither `undefined` nor `null` are used as actual values

As an example, we may want a property `file.title` to always exist and to always be a string. There are two common ways to achieve this.

Note that, in this blog post, we only check for `undefined` and `null` and not whether a value is a string or not. You have to decide for yourself if you want to implement that as an additional security measure or not.

#### Both `undefined` and `null` are forbidden

This looks as follows:

```js
function createFile(title) {
  if (title === undefined || title === null) {
    throw new Error('`title` must not be nullish');
  }
  // ···
}
```

Why choose this approach?

* We want to treat `undefined` and `null` the same because JavaScript code often does – for example:
    
    ```js
    // Detecting if a property exists
    if (!obj.requiredProp) {
      obj.requiredProp = 123;
    }
    
    // Default values via nullish coalescing operator
    const myValue = myParameter ?? 'some default';
    
    ```
    
* If there is an issue in our code and either `undefined` or `null` appears, we want it to fail as quickly as possible.
    

#### Both `undefined` and `null` trigger defaults

This looks as follows:

```js
function createFile(title) {
  title ??= '(Untitled)';
  // ···
}
```

We can’t use a parameter default value here because it is only triggered by `undefined`. Instead, we rely on the [nullish coalescing assignment operator `??=`](https://2ality.com/2020/06/logical-assignment-operators.html).

Why choose this approach?

* We want to treat `undefined` and `null` the same (see previous section).
* We want our code to deal robustly and silently with `undefined` and `null`.

### Either `undefined` or `null` is a “switched off” value

As an example, we may want a property `file.title` to be either a string or “switched off” (`file` doesn’t have a title). There are several ways to achieve this.

#### `null` is the “switched off” value

This looks as follows:

```js
function createFile(title) {
  if (title === undefined) {
    throw new Error('`title` must not be undefined');
  }
  return {title};
}
```

Alternatively, `undefined` can trigger a default value:

```js
function createFile(title = '(Untitled)') {
  return {title};
}
```

Why choose this approach?

* We need a non-value that means “switched off”.
* We don’t want our non-value to trigger parameter default values and destructuring default values.
* We want to stringify the non-value as JSON (something that we can’t do with `undefined`).

#### `undefined` is the “switched off” value

This looks as follows:

```js
function createFile(title) {
  if (title === null) {
    throw new Error('`title` must not be null');
  }
  return {title};
}
```

Why choose this approach?

* We need a non-value that means “switched off”.
* We do want our non-value to trigger parameter default values and destructuring default values.

One downside of `undefined` is that it is often created accidentally in JavaScript: by an uninitialized variable, a typo in a property name, forgetting to return something from a function, etc.

#### Why not use both `undefined` and `null` as “switched off” values?

When receiving a value, it can make sense to treat both `undefined` and `null` as “not a value”. However, when we are creating values, we want to be unambiguous so that handling those values remains simple.

This points toward a different approach: What if we need a “switched off” value, but don’t want to use either `undefined` or `null` as such a value? Read on for details.

### Other ways of handling “switched off”

#### Special value

We can create a special value that we use whenever the property `.title` is switched off:

```js
const UNTITLED = Symbol('UNTITLED');
const file = {
  title: UNTITLED,
};
```

#### Null object pattern

The **null object pattern** comes from object oriented programming:

* All subclasses of a common superclass have the same interface.
* Each subclass implements a different mode in which an instance operates.
* One of those modes is “null”.

In the following example, `UntitledFile` implements the “null” mode.

```js
// Abstract superclass
class File {
  constructor(content) {
    if (new.target === File) {
      throw new Error('Can’t instantiate this class');
    }
    this.content = content;
  }
}

class TitledFile extends File {
  constructor(content, title) {
    super(content);
    this.title = title;
  }
  getTitle() {
    return this.title;
  }
}

class UntitledFile extends File {
  constructor(content) {
    super(content);
  }
  getTitle() {
    return '(Untitled)';
  }
}

const files = [
  new TitledFile('Dear diary!', 'My Diary'),
  new UntitledFile('Reminder: pick a title!'),
];

assert.deepEqual(
  files.map(f => f.getTitle()),
  [
    'My Diary',
    '(Untitled)',
  ]);
```

We also could have used the null object pattern for just the title (instead of for the whole file object).

#### Maybe type

The Maybe type is a function programming technique:

```js
function getTitle(file) {
  switch (file.title.kind) {
    case 'just':
      return file.title.value;
    case 'nothing':
      return '(Untitled)';
    default:
      throw new Error();
  }
}

const files = [
  {
    title: {kind: 'just', value: 'My Diary'},
    content: 'Dear diary!',
  },
  {
    title: {kind: 'nothing'},
    content: 'Reminder: pick a title!',
  },
];

assert.deepEqual(
  files.map(f => getTitle(f)),
  [
    'My Diary',
    '(Untitled)',
  ]);
```

We could have encoded “just” and “nothing” via Arrays. The benefit of our approach is that it is well supported by TypeScript (via [discriminating unions](https://www.typescriptlang.org/docs/handbook/unions-and-intersections.html#discriminating-unions)).

## My approach

There are three reasons why I don’t like to use `undefined` as a “switched off” value:

* `undefined` often appears accidentally in JavaScript.
* `undefined` triggers default values for parameters and destructuring (some people prefer `undefined` for the same reason).

Therefore I use either of the following two approaches if I need a special value:

* I use `null` as a “switched off” value. (As an aside, this approach is relatively well supported by TypeScript.)
* I avoid both `undefined` and `null` via one of the techniques described above. This has the upside of being cleaner and the downside of involving more work.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
