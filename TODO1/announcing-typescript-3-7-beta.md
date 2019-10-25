> * 原文地址：[Announcing TypeScript 3.7 Beta](https://devblogs.microsoft.com/typescript/announcing-typescript-3-7-beta/)
> * 原文作者：[Daniel](https://devblogs.microsoft.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/announcing-typescript-3-7-beta.md](https://github.com/xitu/gold-miner/blob/master/TODO1/announcing-typescript-3-7-beta.md)
> * 译者：[Xuyuey](https://github.com/Xuyuey)
> * 校对者：[药王](https://github.com/ArcherGrey), [TiaossuP](https://github.com/TiaossuP)

# TypeScript 3.7 Beta 版发布

我们很高兴发布 TypeScript 3.7 Beta 版，它包含了 TypeScript 3.7 版本的所有功能。从现在到最后发布之前，我们将修复错误并进一步提高它的性能和稳定性。

开始使用 Beta 版，你可以通过 [NuGet](https://www.nuget.org/packages/Microsoft.TypeScript.MSBuild) 安装，或者通过 npm 使用以下命令安装：

```bash
npm install typescript@beta
```

你还可以通过以下方式获取编辑器的支持

* [下载 Visual Studio 2019/2017](https://marketplace.visualstudio.com/items?itemName=TypeScriptTeam.typescript-37beta)
* 请遵循有关 [Visual Studio Code](https://code.visualstudio.com/Docs/languages/typescript#_using-newer-typescript-versions) 和 [Sublime Text](https://github.com/Microsoft/TypeScript-Sublime-Plugin/#note-using-different-versions-of-typescript) 的说明。

TypeScript 3.7 Beta 版包括了开发者呼声最高的一些功能！让我们深入研究一下新功能，从 3.7：可选链（Optional Chaining）开始。

## 可选链（Optional Chaining）

TypeScript 3.7 实现了迄今为止需求声最高的 ECMAScript 功能之一：可选链！我们的团队成员一直都在高度参与 TC39 委员会，努力争取将这个新功能加入到 ECMAScript 提案的第三个阶段，以便在未来我们可以将其带给所有的 TypeScript 用户。

那什么是可选链呢？从本质上讲，可选链使我们在编写代码时，如果遇到 `null` 或者 `undefined`，可以立即停止运行某些表达式。可选链的主角是这个为了**可选属性访问**而存在的新运算符 `?.`。当我们像下面这样写代码时：

```ts
let x = foo?.bar.baz();
```

也就是说，当 `foo` 被定义时，`foo.bar.baz()` 将会被计算；但是当 `foo` 是 `null` 或者 `undefined` 时，停下来不继续执行，直接返回 `undefined`。

更明确地说，上面那段代码的意思和下面的这段完全相同。

```ts
let x = (foo === null || foo === undefined) ?
    undefined :
    foo.bar.baz();
```

注意，如果 `bar` 是 `null` 或者 `undefined`，在我们的代码尝试访问 `baz` 时，它仍然会出错。同样，如果 `baz` 是 `null` 或者 `undefined`，在我们调用这个函数时也会报错。`?.` 仅仅检查在它左边的值是否为 `null` 或者 `undefined` —— 不包括在它之后的任何一个属性。

你可能会发现你用 `?.` 替换了很多使用 `&&` 运算符执行中间属性检查的代码。

```ts
// 之前
if (foo && foo.bar && foo.bar.baz) {
    // ...
}

// 之后
if (foo?.bar?.baz) {
    // ...
}
```

请牢记 `?.` 不同于 `&&` 运算符，因为 `&&` 仅仅是针对那些“假”（转换为布尔值为假）数据（例如：空字符串、`0`、`NaN` 以及 `false`）。

可选链还包括其他两个操作。首先是**可选元素访问**，其作用类似于可选属性访问，但允许我们访问非属性标识符属性（例如：任意字符串、数字和 Symbol）

```ts
/**
 * 当我们有一个数组时，返回它的第一个元素
 * 否则返回 undefined。
 */
function tryGetFirstElement<T>(arr?: T[]) {
    return arr?.[0];
    // 等价于
    //   return (arr === null || arr === undefined) ?
    //       undefined :
    //       arr[0];
}
```

这还有一个**可选调用**，它允许我们在表达式不为 `null` 或者 `undefined` 时调用该表达式。

```ts
async function makeRequest(url: string, log?: (msg: string) => void) {
    log?.(`Request started at ${new Date().toISOString()}`);
    // 等价于
    //   if (log !== null && log !== undefined) {
    //       log(`Request started at ${new Date().toISOString()}`);
    //   }

    const result = (await fetch(url)).json();

    log?.(`Request finished at at ${new Date().toISOString()}`);

    return result;
}
```

可选链具有的“短路”行为仅限于“普通”和可选属性的访问、调用以及可选元素的访问 —— 不会在表达式的基础上进一步扩展。换句话说，

```ts
let result = foo?.bar / someComputation()
```

不会阻止除法或者调用 `someComputation()` 的发生。相当于

```ts
let temp = (foo === null || foo === undefined) ?
    undefined :
    foo.bar;

let result = temp / someComputation();
```

这可能会导致除法的结果是 `undefined`，这就是为什么在 `strictNullChecks` 模式下，下面的代码会报错。

```ts
function barPercentage(foo?: { bar: number }) {
    return foo?.bar / 100;
    //     ~~~~~~~~
    // 错误：对象有可能未定义。
}
```

更多的细节，你可以[阅读该提案](https://github.com/tc39/proposal-optional-chaining/) 或者 [查看原始的 pull request](https://github.com/microsoft/TypeScript/pull/33294)。

## 空值合并（Nullish Coalescing）

**空值合并运算符**是另一个即将到来的 ECMAScript 新功能，和可选链是一对好兄弟，我们团队也在努力争取（将这个新功能加入到 ECMAScript 提案的第三个阶段）。

你可以考虑使用这个功能 —— `??` 运算符 —— 作为一种处理 `null` 或者 `undefined` 时“回退”到默认值的方法。当我们像下面这样写代码时

```ts
let x = foo ?? bar();
```

这是一种新的表达方式，告诉我们，当 `foo` “存在”时使用 `foo`；但当它是 `null` 或者 `undefined` 时，在它的位置上计算 `bar()` 的值。

同样，上面的代码和下面的等价。

```ts
let x = (foo !== null && foo !== undefined) ?
    foo :
    bar();
```

当我们尝试使用默认值时，`??` 运算符可以代替 `||`。例如，下面的代码会尝试获取上次保存在 [`localStorage`](https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage) 中的 volume 值（如果曾经保存过）；但是由于使用 `||` 这里存在一个 bug。

```ts
function initializeAudio() {
    let volume = localStorage.volume || 0.5

    // ...
}
```

当 `localStorage.volume` 被置为 `0` 时，页面会意外地将 `0.5` 赋给 volume。`??` 可以避免一些由 `0` 导致的意外行为，`NaN` 和 `""` 都会被 `??` 认为是假。

非常感谢社区成员 [Wenlu Wang](https://github.com/Kingwl) 和 [Titian Cernicova Dragomir](https://github.com/dragomirtitian) 实现这个功能！更多的细节，你可以[查看他们的 pull request](https://github.com/microsoft/TypeScript/pull/32883) 或者 [查看空值合并提案仓库](https://github.com/tc39/proposal-nullish-coalescing/)。

## 断言函数

当错误发生的时候，一组特定的函数会 `throw`（抛出）异常。它们被称为“断言”函数。例如，Node.js 为此有一个专用函数，称为 `assert`。

```ts
assert(someValue === 42);
```

在这个例子中，如果 `someValue` 不等于 `42`，`assert` 将会抛出一个 `AssertionError`。

JavaScript 中的断言通常用于防止传入不正确的类型。例如，

```ts
function multiply(x, y) {
    assert(typeof x === "number");
    assert(typeof y === "number");

    return x * y;
}
```

不幸的是在 TypeScript 中，这些检查永远无法被正确地编码。对于松散类型的代码，这意味着 TypeScript 检查的更少，而对于稍微保守型的代码，则通常迫使用户使用类型断言。

```ts
function yell(str) {
    assert(typeof str === "string");

    return str.toUppercase();
    // 糟糕！我们拼错了 'toUpperCase'。
    // 如果 TypeScript 仍然能捕获了这个错误，那就太好了！
}
```

替代方案是改写代码，以便语言可以对其解析，但这并不方便！

```ts
function yell(str) {
    if (typeof str !== "string") {
        throw new TypeError("str should have been a string.")
    }
    // 捕获错误！
    return str.toUppercase();
}
```

最终 TypeScript 的目标是以最小破坏的方法嵌入现有的 JavaScript 结构中。因此，TypeScript 3.7 引入了一个称为“断言签名（assertion signatures）”的新概念，可以对这些断言函数进行建模。

第一种断言签名对 Node 的 `assert` 函数工作方法进行建模。它确保在函数作用域内的其余部分中，无论检查什么条件都一定为真。

```ts
function assert(condition: any, msg?: string): asserts condition {
    if (!condition) {
        throw new AssertionError(msg)
    }
}
```

`asserts condition` 表示，如果 `assert`（正常）返回了，那么无论传递给 `condition` 的参数是什么，它都一定为 true，否则 `assert` 会抛出一个异常。这意味着对于作用域内的其他部分，这个条件也一定是真的。例如，使用这个断言函数意味着我们**确实**捕获了刚才 `yell` 例子的异常。

```ts
function yell(str) {
    assert(typeof str === "string");

    return str.toUppercase();
    //         ~~~~~~~~~~~
    // 错误：属性 'toUppercase' 在 'string' 类型上不存在。
    //      你是说 'toUpperCase' 吗？
}

function assert(condition: any, msg?: string): asserts condition {
    if (!condition) {
        throw new AssertionError(msg)
    }
}
```

断言签名的另一种类型不检查条件，而是告诉 TypeScript 特定的变量或属性具有不同的类型。

```ts
function assertIsString(val: any): asserts val is string {
    if (typeof val !== "string") {
        throw new AssertionError("Not a string!");
    }
}
```

这里 `asserts val is string` 确保在调用 `assertIsString` 之后，传入的任何变量都是可以被认为是一个 `string`。

```ts
function yell(str: any) {
    assertIsString(str);

    // 现在 TypeScript 知道 'str' 是一个 'string'。

    return str.toUppercase();
    //         ~~~~~~~~~~~
    // 错误：属性 'toUppercase' 在 'string' 类型上不存在。
    //      你是说 'toUpperCase' 吗？
}
```

这些断言签名与编写类型断言签名非常相似：

```ts
function isString(val: any): val is string {
    return typeof val === "string";
}

function yell(str: any) {
    if (isString(str)) {
        return str.toUppercase();
    }
    throw "Oops!";
}
```

就像是类型断言签名，这些断言签名也具有难以置信的表现力。我们可以用它们表达一些相当复杂的想法。

```ts
function assertIsDefined<T>(val: T): asserts val is NonNullable<T> {
    if (val === undefined || val === null) {
        throw new AssertionError(
            `Expected 'val' to be defined, but received ${val}`
        );
    }
}
```

要了解有关断言签名的更多信息，[请查看原始 pull request](https://github.com/microsoft/TypeScript/pull/32695)。

## 更好地支持返回 `never` 的函数

作为断言签名工作的一部分，TypeScript 需要对调用位置和调用函数进行更多编码。这使我们有机会扩展对另一类函数的支持：返回 `never` 的函数。

任何返回 `never` 的函数的意味着是它永远不返回。它表明引发了异常，发生了暂停错误条件或者程序已经退出了。例如，[`@types/node` 中的 `process.exit(...)`](https://github.com/DefinitelyTyped/DefinitelyTyped/blob/5299d372a220584e75a031c13b3d555607af13f8/types/node/globals.d.ts#L874) 被指定为返回 `never`。

为了确保函数永远不会返回 `undefined` 或者可以从所有代码路径中有效地返回，TypeScript 需要一些语法信号 —— 在函数末尾的 `return` 或者 `throw`。因此，用户才能发现他们自己 `return` 错误的函数。

```ts
function dispatch(x: string | number): SomeType {
    if (typeof x === "string") {
        return doThingWithString(x);
    }
    else if (typeof x === "number") {
        return doThingWithNumber(x);
    }
    return process.exit(1);
}
```

现在，当这些返回 `never` 的函数被调用时，TypeScript 可以识别出它们会影响控制流程图并说明原因。

```ts
function dispatch(x: string | number): SomeType {
    if (typeof x === "string") {
        return doThingWithString(x);
    }
    else if (typeof x === "number") {
        return doThingWithNumber(x);
    }
    process.exit(1);
}
```

与断言函数一样，你可以[在相同的 pull request 中阅读更多的细节](https://github.com/microsoft/TypeScript/pull/32695)。

## （更多）递归类型别名

类型别名在如何”递归“引用它们方面一直受到限制。原因是对类型别名的任何使用都必须能够用其别名替换自身。在某些情况下，这是不可能的，因此编译器会拒绝某些递归别名，如下所示：

```ts
type Foo = Foo;
```

这是一个合理的限制，因为对 `Foo` 的任何使用都必须用 `Foo` 替换 `Foo`……好吧，希望你可以理解！最后，没有一种可以代替 `Foo` 的类型。

这与[其他语言对待类型别名的方式是相当一致的](https://en.wikipedia.org/w/index.php?title=Recursive_data_type&oldid=913091335#In_type_synonyms)，但是对于用户如何利用该功能确实引发了一些令人惊讶的场景。例如，在 TypeScript 3.6 和更低的版本中，下面的代码会产生一个错误。

```ts
type ValueOrArray<T> = T | Array<ValueOrArray<T>>;
//   ~~~~~~~~~~~~
// 错误：类型别名 'ValueOrArray' 循环引用自身。
```

这很奇怪，因为从技术上讲，这样使用没有任何错，用户应该总是可以通过引入接口来编写实际上是相同的代码。

```ts
type ValueOrArray<T> = T | ArrayOfValueOrArray<T>;

interface ArrayOfValueOrArray<T> extends Array<ValueOrArray<T>> {}
```

因为接口（和其他对象类型）引入了一个间接级别，并且不需要急切地构建它们的完整结构，所以 TypeScript 在使用这种结构时没有问题。

但是，对于用户而言，引入接口的解决方法并不直观。原则上，`ValueOrArray` 的初始版本直接使用 `Array` 并没有任何错误。如果编译器有点“懒惰”，仅在必要的时候才计算类型参数，那么 TypeScript 可以正确的表示这些参数。

这正是 TypeScript 3.7 引入的。在类型别名的“顶层”，TypeScript 将推迟解析类型参数以允许使用这些模式。

这意味着类似以下的代码正试图表示 JSON……

```ts
type Json =
    | string
    | number
    | boolean
    | null
    | JsonObject
    | JsonArray;

interface JsonObject {
    [property: string]: Json;
}

interface JsonArray extends Array<Json> {}
```

最终可以在没有辅助接口的情况下进行重写。

```ts
type Json =
    | string
    | number
    | boolean
    | null
    | { [property: string]: Json }
    | Json[];
```

这种新的宽松（模式）使我们也可以在元组中递归引用类型别名。下面这个曾经报错的代码现在是有效的 TypeScript 代码。

```ts
type VirtualNode =
    | string
    | [string, { [key: string]: any }, ...VirtualNode[]];

const myNode: VirtualNode =
    ["div", { id: "parent" },
        ["div", { id: "first-child" }, "I'm the first child"],
        ["div", { id: "second-child" }, "I'm the second child"]
    ];
```

更多的细节，你可以[阅读原始的 pull request](https://github.com/microsoft/TypeScript/pull/33050)。

## `--declaration` 和 `--allowJs`

TypeScript 中的 `--declaration` 标志允许我们从 TypeScript 源文件（例如 `.ts` 和 `.tsx`）生成 `.d.ts` 文件（声明文件）。这些 `.d.ts` 文件很重要，因为它们允许TypeScript 对其他项目进行类型检查，而无需重新检查/构建原始源代码。出于相同的目的，使用项目引用时**需要**这个设置。

不幸的是，`--declaration` 不能和 `--allowJs`（允许混合 TypeScript 和 JavaScript 的输入文件） 一起使用。这是一个令人沮丧的限制，因为它意味着即便是 JSDoc 注释，在用户在迁移代码库时也无法使用。

在使用 `allowJs` 时，TypeScript 将尽最大努力理解 JavaScript 源代码，并将其以等效的表达形式存储在一个 `.d.ts` 文件中。这包括它所有的 JSDoc 注释，所以像下面这样的代码：

```ts
/**
 * @callback Job
 * @returns {void}
 */

/** 工作队列 */
export class Worker {
    constructor(maxDepth = 10) {
        this.started = false;
        this.depthLimit = maxDepth;
        /**
         * 注意：队列中的作业可能会将更多项目添加到队列中
         * @type {Job[]}
         */
        this.queue = [];
    }
    /**
     * 在队列中添加一个工作项
     * @param {Job} work 
     */
    push(work) {
        if (this.queue.length + 1 > this.depthLimit) throw new Error("Queue full!");
        this.queue.push(work);
    }
    /**
     * 启动队列，如果它尚未开始
     */
    start() {
        if (this.started) return false;
        this.started = true;
        while (this.queue.length) {
            /** @type {Job} */(this.queue.shift())();
        }
        return true;
    }
}
```

现在会被转换为以下无需实现的 `.d.ts` 文件：

```ts
/**
 * @callback Job
 * @returns {void}
 */
/** 工作队列 */
export class Worker {
    constructor(maxDepth?: number);
    started: boolean;
    depthLimit: number;
    /**
     * 注意：队列中的作业可能会将更多项目添加到队列中
     * @type {Job[]}
     */
    queue: Job[];
    /**
     * 在队列中添加一个工作项
     * @param {Job} work
     */
    push(work: Job): void;
    /**
     * 启动队列，如果它尚未开始
     */
    start(): boolean;
}
export type Job = () => void;
```

更多的细节，你可以[查看原始的 pull request](https://github.com/microsoft/TypeScript/pull/32372)。

## 使用项目引用进行免构建编辑

TypeScript 的项目引用为我们提供了一种简单的方法来分解代码库，从而使我们可以更快地进行编译。不幸的是，编辑尚未建立依赖关系（或者输出过时）的项目意味着这种编辑体验无法正常工作。

在 TypeScript 3.7 中，当打开具有依赖项的项目时，TypeScript 将自动使用源 `.ts`/`.tsx` 文件代替。这意味着使用项目引用的项目现在将获得更好的编辑体验，其中语义化操作是最新且“有效”的。在非常大的项目中使用这个更改可能会影响编辑性能，你可以使用编译器选项 `disableSourceOfProjectReferenceRedirect` 禁用此行为。

你可以[通过阅读原始的 pull request 来了解有关这个更改的更多信息](https://github.com/microsoft/TypeScript/pull/32028)。

## 未调用的函数检查

忘记调用函数是一个常见且危险的错误，特别是当函数没有参数或者以一种暗示它可能是属性而不是函数的方式命名时。

```ts
interface User {
    isAdministrator(): boolean;
    notify(): void;
    doNotDisturb?(): boolean;
}

// 稍后……

// 有问题的代码，请勿使用！
function doAdminThing(user: User) {
    // 糟糕！
    if (user.isAdministrator) {
        sudo();
        editTheConfiguration();
    }
    else {
        throw new AccessDeniedError("User is not an admin");
    }
}
```

在这里，我们忘记了调用 `isAdministrator`，该代码将错误地允许非管理员用户编辑配置！

在 TypeScript 3.7 中，这会被标识为可能的错误：

```ts
function doAdminThing(user: User) {
    if (user.isAdministrator) {
    //  ~~~~~~~~~~~~~~~~~~~~
    // 错误！这个条件将始终返回 true，因为这个函数定义是一直存在的
    //      你的意思是调用它吗？
```

这个检查是一项重大更改，但是由于这个原因，检查非常保守。仅在 `if` 条件中才会产生此错误，并且如果 `strictNullChecks` 关闭或之后在 `if` 中调用此函数或者属性是可选的，将不会产生错误：

```ts
interface User {
    isAdministrator(): boolean;
    notify(): void;
    doNotDisturb?(): boolean;
}

function issueNotification(user: User) {
    if (user.doNotDisturb) {
        // OK，属性是可选的
    }
    if (user.notify) {
        // OK，调用了这个方法
        user.notify();
    }
}
```

如果你打算在不调用函数的情况下对其进行测试，则可以将其定义更正为 `undefined`/`null`，或者使用 `!!`，编写和 `if (!!user.isAdministrator)` 类似的代码，表明强制是有意为之的。

非常感谢 GitHub 用户 [@jwbay](https://github.com/jwbay)，他主动创建了[概念验证](https://github.com/microsoft/TypeScript/pull/32802)，并持续为我们提供[最新的版本](https://github.com/microsoft/TypeScript/pull/33178)。

## TypeScript 文件中的 `// @ts-nocheck`

TypeScript 3.7 允许我们在 TypeScript 文件的顶部添加 `// @ts-nocheck` 注释来禁用语义检查。从历史上看，这个注释只有在 `checkJs` 存在时，才在 JavaScript 源文件中受到重用，但我们已经扩展了对 TypeScript 文件的支持，以使所有用户的迁移更加容易。

## 分号格式化选项

由于 JavaScript 的自动分号插入（ASI）规则，TypeScript 的内置格式化程序现在支持在分号结尾可选的位置插入和删除分号。该设置现在在 [Visual Studio Code Insiders](https://code.visualstudio.com/insiders/) 中可用，可以在 Visual Studio 16.4 Preview 2 中的“工具选项”菜单中找到它。

![VS Code 中新的分号格式化选项](https://devblogs.microsoft.com/typescript/wp-content/uploads/sites/11/2019/10/semicolons-options-3.7.png)

选择“插入”或“删除”的值还会影响自动导入的格式、提取的类型以及 TypeScript 服务提供的其它生成的代码。将设置保存为默认值 “ignore” 会使生成的代码与当前文件中检测到的分号首选项相匹配。

## 重大变更

### DOM 变更

[在 `lib.dom.d.ts` 中的类型已更新](https://github.com/microsoft/TypeScript/pull/33627)。这些更改是和可空性相关的大部分正确性更改，但是影响大小最终取决于你的代码库。

### 函数为真检查

如上所述，当在 `if` 语句条件内存在函数，且看起来似乎没有被调用时，TypeScript 现在会报错。在 `if` 条件中检查函数类型时，将产生错误，除非满足以下任何条件：

* 检查值来自可选属性
* `strictNullChecks` 被禁用
* 该函数稍后在 `if` 中被调用

### 本地和导入类型声明现在会发生冲突

之前由于存在 bug，TypeScript 允许以下构造：

```ts
// ./someOtherModule.ts
interface SomeType {
    y: string;
}

// ./myModule.ts
import { SomeType } from "./someOtherModule";
export interface SomeType {
    x: number;
}

function fn(arg: SomeType) {
    console.log(arg.x); // 错误！'SomeType' 上不存在 'x'
}
```

在这里，`SomeType` 似乎起源于 `import` 声明和本地的 `interface` 声明。也许令人惊讶的是，在模块内部，`SomeType` 只是引用了被 `import` 的定义，而本地声明的 `SomeType` 仅在从另一个文件导入时才可用。这非常令人困惑，我们对极少数这种情况的代码进行的野蛮审查表明，开发人员通常认为正在发生一些不同的事情。

在 TypeScript 3.7 中，[现在可以正确地将其标识为重复标识符错误](https://github.com/microsoft/TypeScript/pull/31231)。正确的解决方案取决于作者的初衷，并应逐案解决。通常，命名冲突是无意的，最好的解决方法是重命名导入的类型。如果要扩展导入的类型，则应编写适当的模块进行扩展。

## 下一步

TypeScript 3.7 的最终版本将在 11 月初发布，在那之前的几周将发布候选版本。我们希望您能试用一下 Beta 版，并让我们知道它工作的如何。如果您有任何建议或遇到任何问题，[请尽情前往问题跟踪页面并提出新问题](https://github.com/microsoft/TypeScript/issues/new/choose)！

Happy Hacking!

—— Daniel Rosenwasser 和 TypeScript 团队

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
