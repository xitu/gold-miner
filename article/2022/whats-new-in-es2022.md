> * 原文地址：[What's new in ES2022?](https://dev.to/jasmin/whats-new-in-es2022-1de6)
> * 原文作者：[Jasmin Virdi](https://dev.to/jasmin)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/whats-new-in-es2022.md](https://github.com/xitu/gold-miner/blob/master/article/2022/whats-new-in-es2022.md)
> * 译者：[CarlosChenN](https://github.com/CarlosChenN)
> * 校对者：[DylanXie123](https://github.com/DylanXie123) [Baddyo](https://github.com/Baddyo)

# ES2022 有什么新特性？ 🤔

很快，最新版本的 ECMA Script 将在几个月内成为标准。让我们来看看 ES2022 中会包含什么特性吧。

## 1. 可索引值的 `.at()` 方法。

这个函数能够让我们读取给定索引处的元素。它可以接受负数索引，传负数时，会从给定的数据类型末尾读取元素。

举个例子

```js
[1,2,3,4,5].at(3)  // 返回 4

[1,2,3,4,5].at(-2)   // 返回 4
```

支持这个函数的数据类型：

- String
- Array
- 所有类数组类：Uint8Array 等等。

## 2. RegExp 匹配索引

向正则表达式添加 `/d` 标识，生成的匹配对象里，记录着每个匹配组的起始索引。

匹配索引的不同方式

- 编号组的匹配索引

```js
const matchObj = /(a+)(b+)/d.exec('aaaabb');

console.log(matchObj);
/*
输出 -
['aaaabb', 'aaaa', 'bb', index: 0, input: 'aaaabb', groups: undefined, indices: Array(3)]
*/
```

由于正则表达式设置了 `/d` 标识符，匹配对象会额外具有 .indices 属性，用于记录每个在输入字符串中被捕获的编号组的位置。

```js
matchObj.indices[1];
/*
Output -
[0, 4]
*/
```

- 命名组的匹配索引

```js
const matchObj = /(?<as>a+)(?<bs>b+)/d.exec('aaaabb');

console.log(matchObj);
/*
Output -
['aaaabb', 'aaaa', 'bb', index: 0, input: 'aaaabb', groups: {as: 'aaaa', bs: 'bb'}, indices: Array(3)]
*/
```

它们的索引存储在 `matchObj.indices.groups`

```js
matchObj.indices.groups;
/*
输出 -
{ as: [0,4], bs: [4,6] }
*/
```

## 3. `Object.hasOwn(obj, propKey)`

这是检查 `propKey` 是否为 `obj` 对象的自身属性的安全方式。它与 `Object.prototype.hasOwnProperty` 类似，但它支持所有对象类型。

```js
const proto = {
  protoProp: 'protoProp',
};

const obj = {
  __proto__: proto,
  objProp: 'objProp',
};

console.log('protoProp' in obj); // 输出 - true.
console.log(Object.hasOwn(obj, 'protoProp')) // 输出 - false
console.log(Object.hasOwn(proto, 'protoProp')); // 输出 - true.
```

## 4. `error.cause`

现在，我们可以明确指出 Error 及其子类导致错误的原因。这在深度嵌套函数中非常有用，我们可以通过链接错误块来快速找到错误。[更多信息见此](https://2ality.com/2021/06/error-cause.html)

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

## 5. 顶级 await 模块

我们现在可以在顶级模块中使用 await，无需再内嵌到 async 函数或模块中。

- 动态加载模块

```js
const messages = await import(`./messages-${language}.mjs`);
```

- 如果模块加载失败，则使用兜底方案

```js
let lodash;
try {
  lodash = await import('https://primary.example.com/lodash');
} catch {
  lodash = await import('https://secondary.example.com/lodash');
}
```

- 使用加载最快的资源

```js
const resource = await Promise.any([
  fetch('http://example.com/first.txt')
    .then(response => response.text()),
  fetch('http://example.com/second.txt')
    .then(response => response.text()),
]);
```

## 6. Class 的新成员

- 公共属性可以通过实例的公共字段创建

```js
class InstPublicClass {
  // 实例化公共字段
  instancePublicField = 0; // (A)

  constructor(value) {
    // 我们无需在别的地方提及 .property！
    this.property = value; // (B)
  }
}

const inst = new InstPublicClass('constrArg');
```

- 也可以通过静态公共字段创建

```js
const computedFieldKey = Symbol('computedFieldKey');
class StaticPublicFieldClass {
  static identifierFieldKey = 1;
  static 'quoted field key' = 2;
  static [computedFieldKey] = 3;
}
console.log(StaticPublicFieldClass.identifierFieldKey) //输出 -> 1
console.log(StaticPublicFieldClass['quoted field key']) //输出 -> 2
console.log(StaticPublicFieldClass[computedFieldKey]) //输出 -> 3
```

- 新增私有 slot 特性，可以通用以下方式创建
    - 实例化私有字段

```js
class InstPrivateClass {
  #privateField1 = 'private field 1'; // (A)
  #privateField2; // (B) 必要字段！
  constructor(value) {
    this.#privateField2 = value; // (C)
  }
  /**
   * 私有字段不可以在类主体外部访问
   */
  checkPrivateValues() {
  console.log(this.#privateField1); // 输出 -> 'private field 1'
  console.log(this.#privateField2); // 输出 -> 'constructor argument'

  }
}

const inst = new InstPrivateClass('constructor argument');
  inst.checkPrivateValues();

console.log("inst", Object.keys(inst).length === 0) //输出 -> inst, true
```

- 实例化静态私有字段

```js
class InstPrivateClass {
  #privateField1 = 'private field 1'; // (A)
  #privateField2; // (B) required!
  static #staticPrivateField = 'hello';
  constructor(value) {
    this.#privateField2 = value; // (C)
  }
  /**
   * 私有字段不可以在类主体外部访问
   */
  checkPrivateValues() {
    console.log(this.#privateField1); // 输出 -> 'private field 1'
    console.log(this.#privateField2); // 输出 -> 'constructor argument'

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

console.log("inst", Object.keys(inst).length === 0) //输出 -> "inst", true
console.log(InstPrivateClass.getResultTwice()); // 输出 -> "hello hello"
```

- 私有方法和访问器

```js
class MyClass {
  #privateMethod() {}
  static check() {
    const inst = new MyClass();

    console.log(#privateMethod in inst) // 输出-> true

    console.log(#privateMethod in MyClass.prototype) // 输出-> false

    console.log(#privateMethod in MyClass) // 输出-> false
  }
}
MyClass.check();
```

- 类中的静态初始化块。对于静态数据，我们可以在类创建的时候会执行的静态字段和静态块做处理。

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

- 私有 slot 检查 —— 这个功能帮助我们检查对象是否有给定的私有 slot。

```js
class C1 {
  #priv() {}
  static check(obj) {
    return #priv in obj;
  }
}

console.log(C1.check(new C1())) // 输出 true
```

这些惊人的特性将帮助我们提升项目水准，并且提高我们的编码技巧。我非常兴奋，我真的是迫不及待地想在我的项目中试试这些特性了。💃

祝快乐编码! 👩🏻‍💻

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
