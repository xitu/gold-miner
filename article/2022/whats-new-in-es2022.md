> * 原文地址：[What's new in ES2022?](https://dev.to/jasmin/whats-new-in-es2022-1de6)
> * 原文作者：[Jasmin Virdi](https://dev.to/jasmin)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/whats-new-in-es2022.md](https://github.com/xitu/gold-miner/blob/master/article/2022/whats-new-in-es2022.md)
> * 译者：
> * 校对者：

# What's new in ES2022? 🤔

Soon the new version of ECMA Script will become standard in few months. So let's take a glimpse at the features that will be part of ES2022.

## 1. Method `.at()` of indexable values.

This function let's us reads an element at the given index. It can accept negative indexes to read elements from the end of the given datatype.

For example

```js
[1,2,3,4,5].at(3)  // returns 4

[1,2,3,4,5].at(-2)   // returns 4
```

Datatypes supporting this function.

- String
- Array
- All Typed Array classes: Uint8Array etc.

## 2. RegExp match indices

Adding a flag `/d` to a regular expression produces match objects that records the start and end of each group capture.

There are different ways to match indices

- Match indices for numbered group

```js
const matchObj = /(a+)(b+)/d.exec('aaaabb');

console.log(matchObj);
/*
Output -
['aaaabb', 'aaaa', 'bb', index: 0, input: 'aaaabb', groups: undefined, indices: Array(3)]
*/
```

Due to the regular expression flag `/d`, matchObj also has a property .indices that records for each numbered group where it was captured in the input string.

```js
matchObj.indices[1];
/*
Output -
[0, 4]
*/
```

- Match indices for named groups

```js
const matchObj = /(?<as>a+)(?<bs>b+)/d.exec('aaaabb');

console.log(matchObj);
/*
Output -
['aaaabb', 'aaaa', 'bb', index: 0, input: 'aaaabb', groups: {as: 'aaaa', bs: 'bb'}, indices: Array(3)]
*/
```

Their indices are stored in `matchObj.indices.groups`

```js
matchObj.indices.groups;
/*
Output -
{ as: [0,4], bs: [4,6] }
*/
```

## 3. `Object.hasOwn(obj, propKey)`

It is a safe way to check that `propKey` is the own property of `obj` object. It is similar to `Object.prototype.hasOwnProperty` but it supports all object types.

```js
const proto = {
  protoProp: 'protoProp',
};

const obj = {
  __proto__: proto,
  objProp: 'objProp',
};

console.log('protoProp' in obj); // output - true.
console.log(Object.hasOwn(obj, 'protoProp')) // output - false
console.log(Object.hasOwn(proto, 'protoProp')); // output - true.
```

## 4. `error.cause`

Error and it's subclasses now let us specify the reason behind the error. This is useful in deeply nested function where we have chained error blocks to quickly find the error. [Read here for more info](https://2ality.com/2021/06/error-cause.html)

```js
function readFiles(filePaths) {
  return filePaths.map(
    (filePath) => {
      try {
        // ---
      } catch (error) {
        throw new Error(
          `While processing ${filePath}`,
          {cause: error}
        );
      }
    });
}
```

## 5. Top-level await modules

We can now use await at the top levels of modules and don't have to enter async functions or methods anymore.

- Loading modules dynamically

```js
const messages = await import(`./messages-${language}.mjs`);
```

- Using a fallback if module loading fails

```js
let lodash;
try {
  lodash = await import('https://primary.example.com/lodash');
} catch {
  lodash = await import('https://secondary.example.com/lodash');
}
```

- Using whichever resource loads fastest

```js
const resource = await Promise.any([
  fetch('http://example.com/first.txt')
    .then(response => response.text()),
  fetch('http://example.com/second.txt')
    .then(response => response.text()),
]);
```

## 6. New members of classes

- Public properties can be created via
    - Instance public fields

```js
class InstPublicClass {
  // Instance public field
  instancePublicField = 0; // (A)

  constructor(value) {
    // We don't need to mention .property elsewhere!
    this.property = value; // (B)
  }
}

const inst = new InstPublicClass('constrArg');
```

- Static public fields

```js
const computedFieldKey = Symbol('computedFieldKey');
class StaticPublicFieldClass {
  static identifierFieldKey = 1;
  static 'quoted field key' = 2;
  static [computedFieldKey] = 3;
}
console.log(StaticPublicFieldClass.identifierFieldKey) //output -> 1
console.log(StaticPublicFieldClass['quoted field key']) //output -> 2
console.log(StaticPublicFieldClass[computedFieldKey]) //output -> 3
```

- Private slots are new and can be created via
    - Instance private fields

```js
class InstPrivateClass {
  #privateField1 = 'private field 1'; // (A)
  #privateField2; // (B) required!
  constructor(value) {
    this.#privateField2 = value; // (C)
  }
  /**
   * Private fields are not accessible outside the class body.
   */
  checkPrivateValues() {
  console.log(this.#privateField1); // output -> 'private field 1'
  console.log(this.#privateField2); // output -> 'constructor argument'

  }
}

const inst = new InstPrivateClass('constructor argument');
  inst.checkPrivateValues();

console.log("inst", Object.keys(inst).length === 0) //output -> inst, true
```

- Instance and static private fields

```js
class InstPrivateClass {
  #privateField1 = 'private field 1'; // (A)
  #privateField2; // (B) required!
  static #staticPrivateField = 'hello';
  constructor(value) {
    this.#privateField2 = value; // (C)
  }
  /**
   * Private fields are not accessible outside the class body.
   */
  checkPrivateValues() {
    console.log(this.#privateField1); // output -> 'private field 1'
    console.log(this.#privateField2); // output -> 'constructor argument'

  }

  static #twice() {
    return this.#staticPrivateField + " " + this.#staticPrivateField;
  }

  static getResultTwice() {
    return this.#twice()
  }
}

const inst = new InstPrivateClass('constructor argument');
inst.checkPrivateValues();

console.log("inst", Object.keys(inst).length === 0) //output -> "inst", true
console.log(InstPrivateClass.getResultTwice()); // output -> "hello hello"
```

- Private methods and accessors

```js
class MyClass {
  #privateMethod() {}
  static check() {
    const inst = new MyClass();

    console.log(#privateMethod in inst) // output-> true

    console.log(#privateMethod in MyClass.prototype) // output-> false

    console.log(#privateMethod in MyClass) // output-> false
  }
}
MyClass.check();
```

- Static initialisation blocks in classes. For static data we have Static fieldsand Static Blocks that are executed when the class is created.

```js
class Translator {
  static translations = {
    yes: 'ja',
    no: 'nein',
    maybe: 'vielleicht',
  };
  static englishWords = [];
  static germanWords = [];
  static { // (A)
    for (const [english, german] of Object.entries(this.translations)) {
      this.englishWords.push(english);
      this.germanWords.push(german);
    }
  }
}

console.log(Translator.englishWords, Translator.germanWords)
//Output -> ["yes", "no", "maybe"], ["ja", "nein", "vielleicht"]
```

- Private slot checks - This functionality helps us to check that the object has the given private slot in it.

```js
class C1 {
  #priv() {}
  static check(obj) {
    return #priv in obj;
  }
}

console.log(C1.check(new C1())) // output true
```

These amazing features will help us to enhance our projects and improve our coding techniques. I am really excited to try these features out in my project. 💃

Happy Coding! 👩🏻‍💻

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
