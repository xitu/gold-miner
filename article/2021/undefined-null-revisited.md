> * 原文地址：[undefined vs. null revisited](https://2ality.com/2021/01/undefined-null-revisited.html)
> * 原文作者：[Dr. Axel Rauschmayer](http://dr-axel.de/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/undefined-null-revisited.md](https://github.com/xitu/gold-miner/blob/master/article/2021/undefined-null-revisited.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[Moonball](https://github.com/Moonball)、[felixliao](https://github.com/felixliao)

# 重新审视 undefined 和 null

很多的编程语言都有一种表示空值的类型，叫做 `null`。它指示了一个变量当前并没有指向任何对象 —— 例如，某个变量还没有初始化的时候。

作为不同，JavaScript 则拥有两种表示空值的类型，一种是 `undefined`，另一种则是 `null`。在这篇文章中，我们将测试它们的区别，以及如何去挑选最佳的类型或避免去使用它们。

## `undefined` vs. `null`

两个值都很是相像，并且通常被相互替代着使用，也因此，他们之间的区别很是细微。

### `undefined`、`null` 在ECMAScript 语言标准上的对比

ECMAScript 语言标准按照如下内容描述他们：

* `undefined` 是在一个变量还没有被赋值时候使用的。<sup>[出处](https://tc39.es/ecma262/#sec-undefined-value)</sup>
* `null` 表示任何有意地缺省对象值。<sup>[出处](https://tc39.es/ecma262/#sec-null-value)</sup>

我们等下就会探索一下作为程序员，我们应该如何去以最佳的方式使用这两个值。

### 两个空值 —— 一个不能弥补的错误

在 JavaScript 中同时有两个表示空值的值现在被认为是一个设计错误（哪怕是 JavaScript 之父 Brendan Eich 也这么认为）。

那么为什么不从 JavaScript 中删除这两个值之一呢？JavaScript 的一项核心原则是永不破坏向后的兼容性。该原则具有[好处](https://exploringjs.com/impatient-js/ch_history.html#backward-compatibility)，但同时也拥有着最大的缺点，即无法弥补设计错误。

### `undefined` 和 `null` 的历史

在 Java（影响了 JavaScript 很多方面的语言）中初始值依赖于一个变量的静态类型：

* 以对象值为类型的变量初始化为 `null`。
* 每个基本类型都拥有它的初始值，例如 `int` 整型对应 `0`。

在 JavaScript 中，每一个变量都可以存储对象值或原始值，意味着如果 `null` 表示不是一个对象，那么 JavaScript 也同时需要一个初始值表示既不是一个对象也不拥有原始值，这就是 `undefined`。

## `undefined` 的出现场合

如果一个变量 `myVar` 还没有被初始化，那么它的值就是 `undefined`：

```js
let myVar;
assert.equal(myVar, undefined);
```

如果一个属性 `.unknownProp` 不存在，访问这个属性就会生成 `undefined` 值：

```js
const obj = {};
assert.equal(obj.unknownProp, undefined);
```

如果一个函数没有明确返回任何内容，那么默认就会返回 `undefined`：

```js
function myFunc() {
}

assert.equal(myFunc(), undefined);
```

如果一个函数拥有一个 `return` 语句但没有指定任何返回值，那么也会默认返回 `undefined`：

```js
function myFunc() {
    return;
}

assert.equal(myFunc(), undefined);
```

如果一个参数 `x` 没有传实参，那么就会被初始化为 `undefined`：

```js
function myFunc(x) {
    assert.equal(x, undefined);
}

myFunc();
```

通过 `obj?.someProp` 访问的[可选链](https://exploringjs.com/impatient-js/ch_single-objects.html#optional-chaining)在` obj` 是 `undefined` 或 `null` 的时候返回 `undefined`：

```repl
> undefined?.someProp
undefined
> null?.someProp
undefined
```

## `null` 的出现场合

一个对象的原型要么是另一个对象，要么是原型链末尾的 `null`。`Object.prototype` 没有原型：

```repl
> Object.getPrototypeOf(Object.prototype)
null
```

如果我们使用一个正则表达式（例如 `/a/`）匹配一个字符串（例如 `x`），我们要么得到一个存储着匹配数据的对象（如果匹配成功），要么得到 `null`（如果匹配失败）。

```repl
> /a/.exec('x')
null
```

[JSON 数据格式](https://exploringjs.com/impatient-js/ch_json.html) 不支持 `undefined`，只支持 `null`：

```repl
> JSON.stringify({a: undefined, b: null})
'{"b":null}'
```

## 专门用来对付 `undefined` 和 `null` 的操作符

### `undefined` 以及默认参数值

一个参数的默认值会在以下情况下被使用：

* 这个参数被我们忽略掉了。
* 这个参数被赋予 `undefined` 值。

举个例子：

```js
function myFunc(arg = 'abc') {
    return arg;
}

assert.equal(myFunc('hello'), 'hello');
assert.equal(myFunc(), 'abc');
assert.equal(myFunc(undefined), 'abc');
```

当指向它的值为一个元值时，`undefined` 也会触发默认参数值。

以下的例子示范了这个特性有用的地方：

```js
function concat(str1 = '', str2 = '') {
    return str1 + str2;
}

function twice(str) { // (A)
    return concat(str, str);
}
```

在 A 行，我们并没有制定参数 `str` 的默认值，而当这个参数被忽略掉的时候，我们将该状态转发到 `concat()`，让其选择默认值。

### `undefined`，解构默认值

解构下的默认值的工作方式与参数默认值类似 —— 如果变量在数据中不匹配或与 `undefined` 匹配，则使用它们：

```js
const [a = 'a'] = [];
assert.equal(a, 'a');

const [b = 'b'] = [undefined];
assert.equal(b, 'b');

const {prop: c = 'c'} = {};
assert.equal(c, 'c');

const {prop: d = 'd'} = {prop: undefined};
assert.equal(d, 'd');
```

### `undefined`、`null` 和可选链

如果通过 `value?.prop` 使用了[可选链](https://exploringjs.com/impatient-js/ch_single-objects.html#optional-chaining)：

* 如果 `value` 是 `undefined` 或 `null` 的，将会返回 `undefined`。也就是说，如果 `value.prop` 抛出错误，就会返回 `undefined`。
* 否则会返回 `value.prop`.

```js
function getProp(value) {
    // 可选的静态属性访问
    return value?.prop;
}

assert.equal(
    getProp({prop: 123}), 123);
assert.equal(
    getProp(undefined), undefined);
assert.equal(
    getProp(null), undefined);
```

以下的两个操作也很是类似的工作：

```js
obj?.[«expr»] // 可选的动态属性访问
func?.(«arg0», «arg1») // 可选的函数或方法调用
```

### `undefined`、`null` 和空合并

[空合并操作符 `??`](https://exploringjs.com/impatient-js/ch_operators.html#nullish-coalescing-operator) 可让我们在一个值是 `undefined` 或 `null` 时，使用默认值：

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

[空合并赋值操作符 `??=`](https://2ality.com/2020/06/logical-assignment-operators.html) 合并了空合并操作符与赋值操作符：

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

## 处理 `undefined` 与 `null`

以下的部分解释了在我们代码中最常见的处理 `undefined` 和 `null` 的方法：

### 实际值既不是 `undefined` 也不是 `null`

例如，我们可能希望属性 `file.title` 始终存在并且始终是字符串，那么有两种常见的方法可以实现此目的。

请注意，在此博客文章中，我们仅检查 `undefined` 和 `null`，而不检查值是否为字符串。你需要自己决定是否要添加检查器，作为附加的安全保障措施。

#### 同时禁止 `undefined` 和 `null`

例如：

```js
function createFile(title) {
    if (title === undefined || title === null) {
        throw new Error('`title` must not be nullish');
    }
    // ···
}
```

为什么选择这个方法？

* 我们希望以相同的方式处理 `undefined` 和 `null`，因为 JavaScript 代码就是经常那样做，例如：

    ```js
    // 检查一个属性是否存在
    if (!obj.requiredProp) {
      obj.requiredProp = 123;
    }
    
    // 通过空合并操作符使用默认值
    const myValue = myParameter ?? 'some default';
    
    ```

* 如果我们的代码中出现了问题，让 `undefined` 或 `null` 出现了，我们需要让它尽早结束执行并抛出错误。

#### 同时对 `undefined` 和 `null` 使用默认值

例如：

```js
function createFile(title) {
    title ??= '(Untitled)';
    // ···
}
```

我们不能使用参数默认值，因为它只会被 `undefined` 触发。在这里，我们依赖于[空合并赋值运算符 `??=`](https://2ality.com/2020/06/logical-assignment-operators.html)。

为什么选择这个方法？

* 我们希望以相同方式对待 `undefined` 和 `null`（见上文）。
* 我们希望我们的代码无声但有力地对待 `undefined` 和 `null`。

### `undefined` 或 `null` 是一个被忽略的值

例如，我们可能希望属性 `file.title` 是字符串或是被忽略的值（即 `file` 没有标题），那么有几种方法可以实现此目的。

#### `null` 是被忽略值

例如：

```js
function createFile(title) {
    if (title === undefined) {
        throw new Error('`title` 不应该是 undefined');
    }
    return {title};
}
```

或者，`undefined` 也可以触发默认值：

```js
function createFile(title = '(Untitled)') {
    return {title};
}
```

为什么要选择这个方法？

* 我们需要一个空值来表示被忽略。
* 我们不希望空值触发参数默认值并破坏默认值。
* 我们想将空值字符串化为 JSON（这是我们无法对 `undefined` 进行的处理）。

#### `undefined` 是被忽略的值

例如：

```js
function createFile(title) {
    if (title === null) {
        throw new Error('`title` 不应该是 null');
    }
    return {title};
}
```

为什么选择这种方法？

* 我们需要一个空值来表示被忽略。
* 我们确实希望空值触发参数或解构默认值。

`undefined` 的一个缺点是它通常是在 JavaScript 中意外赋予的 —— 在未初始化的变量，属性名称中的错字，忘记从函数中返回内容等。

#### 为什么不同时将 `undefined` 和 `null` 看作是被忽略的值？

当接收到一个值时，将 `undefined` 和 `null` 都视为 “空值” 是有意义的。 但是，当我们创建值时，我们不希望模棱两可，以避免不必要的麻烦。

这指向了另一种角度：如果我们需要一个被忽略的值，但又不想使用 `undefined` 或 `null` 作为被忽略值时该怎么办？看看下文吧：

### 其他处理被忽略值的方法

#### 特殊值

我们可以创建一个特殊值，每当属性被忽略时 `.title` 时就使用该值：

```js
const UNTITLED = Symbol('UNTITLED');
const file = {
    title: UNTITLED,
};
```

#### Null 对象模式

**Null 对象模式** 来自 OOP（面对对象编程）：

* 一个公共超类的所有子类都具有相同的接口。
* 每个子类实现一种不同的模式供其实例使用。
* 这些模式之一是 `null`。

在下文中，`UntitledFile` 继承了 “null” 模式。

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

我们也可以只为标题（而不是整个文件对象）使用空对象模式。

#### “也许”类型

“也许”类型是一种函数编程技术：

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

我们本可以通过数组对 "just" 和 "nothing" 进行编码，但我们的方法的好处是 TypeScript 对其有很好的支持（通过[可辨识联合](https://www.typescriptlang.org/docs/handbook/unions-and-intersections.html#discriminate-unions)）。

## 我的方法

我不喜欢将 `undefined` 用作被忽略的值的原因有三个：

* `undefined` 通常是在 JavaScript 中意外出现的。
* `undefined` 会触发参数和解构的默认值（出于某些原因，某些人更喜欢 `undefined`）。

因此，如果需要特殊值，可以使用以下两种方法之一：

* 我将 `null` 用作被忽略的值。（顺便说一句，TypeScript 相对较好地支持了这种方法。）
* 我通过上述的其中一种技术避免了同时出现 `undefined` 和 `null` 的情况，优点在乎让代码更干净，而缺点在于需要做出更多的工作。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
