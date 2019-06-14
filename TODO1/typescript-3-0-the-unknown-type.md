> * 原文地址：[TypeScript 3.0: The unknown Type](https://mariusschulz.com/blog/typescript-3-0-the-unknown-type)
> * 原文作者：[Marius Schulz](https://mariusschulz.com) 
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/typescript-3-0-the-unknown-type.md](https://github.com/xitu/gold-miner/blob/master/TODO1/typescript-3-0-the-unknown-type.md)
> * 译者：[shixi-li](https://github.com/shixi-li)
> * 校对者：[Usey95](https://github.com/Usey95), [smilemuffie](https://github.com/smilemuffie)

# TypeScript 3.0: unknown 类型

TypeScript 3.0 引入了新的`unknown` 类型，它是 `any` 类型对应的安全类型。

`unknown` 和 `any` 的主要区别是 `unknown` 类型会更加严格：在对 `unknown` 类型的值执行大多数操作之前，我们必须进行某种形式的检查。而在对 `any` 类型的值执行操作之前，我们不必进行任何检查。

这片文章主要关注于 `unknown` 类型的实际应用，以及包含了与 `any` 类型的比较。如果需要更全面的代码示例来了解 `unknown` 类型的语义，可以看看 Anders Hejlsberg 的[原始拉取请求](https://github.com/Microsoft/TypeScript/pull/24439)。

## `any` 类型

让我们首先看看 `any` 类型，这样我们就可以更好地理解引入 `unknown` 类型背后的动机。

自从 TypeScript 在 2012 年发布第一个版本以来 `any` 类型就一直存在。它代表所有可能的 JavaScript 值 — 基本类型，对象，数组，函数，Error，Symbol，以及任何你可能定义的值。

在 TypeScript 中，任何类型都可以被归为 any 类型。这让 `any` 类型成为了类型系统的 [**顶级类型**](https://en.wikipedia.org/wiki/Top_type) (也被称作 **全局超级类型**)。

这是一些我们赋值给 `any` 类型的代码示例：

```ts
let value: any;

value = true;             // OK
value = 42;               // OK
value = "Hello World";    // OK
value = [];               // OK
value = {};               // OK
value = Math.random;      // OK
value = null;             // OK
value = undefined;        // OK
value = new TypeError();  // OK
value = Symbol("type");   // OK
```

`any` 类型本质上是类型系统的一个逃逸舱。作为开发者，这给了我们很大的自由：TypeScript允许我们对 `any` 类型的值执行任何操作，而无需事先执行任何形式的检查。

在上述例子中，变量 `value` 被定义成类型 `any`。也是因此，TypeScript 认为以下所有操作都是类型正确的：

```ts
let value: any;

value.foo.bar;  // OK
value.trim();   // OK
value();        // OK
new value();    // OK
value[0][1];    // OK
```

这许多场景下，这样的机制都太宽松了。使用`any`类型，可以很容易地编写类型正确但是执行异常的代码。如果我们使用 `any` 类型，就无法享受 TypeScript 大量的保护机制。

但如果能有顶级类型也能默认保持安全呢？这就是 `unknown` 到来的原因。

## `unknown` 类型

就像所有类型都可以被归为 `any`，所有类型也都可以被归为 `unknown`。这使得 `unknown` 成为 TypeScript 类型系统的另一种顶级类型（另一种是  `any`）。

这是我们之前看到的相同的一组赋值示例，这次使用类型为 `unknown` 的变量：

```ts
let value: unknown;

value = true;             // OK
value = 42;               // OK
value = "Hello World";    // OK
value = [];               // OK
value = {};               // OK
value = Math.random;      // OK
value = null;             // OK
value = undefined;        // OK
value = new TypeError();  // OK
value = Symbol("type");   // OK
```

对 `value` 变量的所有赋值都被认为是类型正确的。

当我们尝试将类型为 `unknown` 的值赋值给其他类型的变量时会发生什么？

```ts
let value: unknown;

let value1: unknown = value;   // OK
let value2: any = value;       // OK
let value3: boolean = value;   // Error
let value4: number = value;    // Error
let value5: string = value;    // Error
let value6: object = value;    // Error
let value7: any[] = value;     // Error
let value8: Function = value;  // Error
```

`unknown` 类型只能被赋值给 `any` 类型和 `unknown` 类型本身。直观的说，这是有道理的：只有能够保存任意类型值的容器才能保存 `unknown` 类型的值。毕竟我们不知道变量 `value` 中存储了什么类型的值。

现在让我们看看当我们尝试对类型为 `unknown` 的值执行操作时会发生什么。以下是我们之前看过的相同操作：

```ts
let value: unknown;

value.foo.bar;  // Error
value.trim();   // Error
value();        // Error
new value();    // Error
value[0][1];    // Error
```

将 `value` 变量类型设置为 `unknown` 后，这些操作都不再被认为是类型正确的。通过改变 `any` 类型到 `unknown` 类型，我们的默认设置从允许一切翻转式的改变成了几乎什么都不允许。

这是 `unknown` 类型的主要价值主张：TypeScript 不允许我们对类型为 `unknown` 的值执行任意操作。相反，我们必须首先执行某种类型检查以缩小我们正在使用的值的类型范围。

## 缩小 `unknown` 类型范围

我们可以通过不同的方式将 `unknown` 类型缩小为更具体的类型范围，包括 `typeof` 运算符，`instanceof` 运算符和自定义类型保护函数。所有这些缩小类型范围的技术都有助于 TypeScript 的[基于控制流的类型分析](https://mariusschulz.com/blog/typescript-2-0-control-flow-based-type-analysis)。

以下示例说明了 `value` 如何在两个 `if` 语句分支中获得更具体的类型：

```ts
function stringifyForLogging(value: unknown): string {
  if (typeof value === "function") {
    // Within this branch, `value` has type `Function`,
    // so we can access the function's `name` property
    const functionName = value.name || "(anonymous)";
    return `[function ${functionName}]`;
  }

  if (value instanceof Date) {
    // Within this branch, `value` has type `Date`,
    // so we can call the `toISOString` method
    return value.toISOString();
  }

  return String(value);
}
```

除了使用 `typeof` 或 `instanceof` 运算符之外，我们还可以使用自定义类型保护函数缩小 `unknown` 类型范围：

```ts
/**
 * A custom type guard function that determines whether
 * `value` is an array that only contains numbers.
 */
function isNumberArray(value: unknown): value is number[] {
  return (
    Array.isArray(value) &&
    value.every(element => typeof element === "number")
  );
}

const unknownValue: unknown = [15, 23, 8, 4, 42, 16];

if (isNumberArray(unknownValue)) {
  // Within this branch, `unknownValue` has type `number[]`,
  // so we can spread the numbers as arguments to `Math.max`
  const max = Math.max(...unknownValue);
  console.log(max);
}
```

尽管 `unknownValue` 已经被归为 `unknown` 类型，请注意它如何依然在 if 分支下获取到 `number[]` 类型。

## 对 `unknown` 类型使用类型断言

在上一节中，我们已经看到如何使用 `typeof`，`instanceof` 和自定义类型保护函数来说服 TypeScript 编译器某个值具有某种类型。这是将 “unknown” 类型指定为更具体类型的安全且推荐的方法。

如果要强制编译器信任类型为 `unknown` 的值为给定类型，则可以使用类似这样的类型断言：

```ts
const value: unknown = "Hello World";
const someString: string = value as string;
const otherString = someString.toUpperCase();  // "HELLO WORLD"
```

请注意，TypeScript 事实上未执行任何特殊检查以确保类型断言实际上有效。类型检查器假定你更了解并相信你在类型断言中使用的任何类型都是正确的。

如果你犯了错误并指定了错误的类型，这很容易导致在运行时抛出错误：

```ts
const value: unknown = 42;
const someString: string = value as string;
const otherString = someString.toUpperCase();  // BOOM
```

这个 `value` 变量值是一个数字, 但我们假设它是一个字符串并使用类型断言 `value as string`。所以请谨慎使用类型断言！

## 联合类型中的 `unknown` 类型

现在让我们看一下在联合类型中如何处理 `unknown` 类型。在下一节中，我们还将了解交叉类型。

在联合类型中，`unknown` 类型会吸收任何类型。这就意味着如果任一组成类型是 `unknown`，联合类型也会相当于 `unknown`：

```ts
type UnionType1 = unknown | null;       // unknown
type UnionType2 = unknown | undefined;  // unknown
type UnionType3 = unknown | string;     // unknown
type UnionType4 = unknown | number[];   // unknown
```

这条规则的一个意外是 `any` 类型。如果至少一种组成类型是 `any`，联合类型会相当于 `any`：

```ts
type UnionType5 = unknown | any;  // any
```

所以为什么 `unknown` 可以吸收任何类型（`any` 类型除外）？让我们来想想 `unknown | string` 这个例子。这个类型可以表示任何 unkown 类型或者 string 类型的值。就像我们之前了解到的，所有类型的值都可以被定义为 `unknown` 类型，其中也包括了所有的 `string` 类型，因此，`unknown | string` 就是表示和 `unknown` 类型本身相同的值集。因此，编译器可以将联合类型简化为 `unknown` 类型。

## 交叉类型中的 `unknown` 类型

在交叉类型中，任何类型都可以吸收 `unknown` 类型。这意味着将任何类型与 `unknown` 相交不会改变结果类型：

```ts
type IntersectionType1 = unknown & null;       // null
type IntersectionType2 = unknown & undefined;  // undefined
type IntersectionType3 = unknown & string;     // string
type IntersectionType4 = unknown & number[];   // number[]
type IntersectionType5 = unknown & any;        // any
```

让我们回顾一下 `IntersectionType3`：`unknown & string` 类型表示所有可以被同时赋值给 `unknown` 和 `string` 类型的值。由于每种类型都可以赋值给 `unknown` 类型，所以在交叉类型中包含 `unknown` 不会改变结果。我们将只剩下 `string` 类型。

## 使用类型为 `unknown` 的值的运算符

`unknown` 类型的值不能用作大多数运算符的操作数。这是因为如果我们不知道我们正在使用的值的类型，大多数运算符不太可能产生有意义的结果。

你可以在类型为 `unknown` 的值上使用的运算符只有四个相等和不等运算符：

-   `===`
-   `==`
-   `!==`
-   `!=`

如果要对类型为 `unknown` 的值使用任何其他运算符，则必须先指定类型（或使用类型断言强制编译器信任你）。

## 示例：从 `localStorage` 中读取JSON

这是我们如何使用 `unknown` 类型的真实例子。

假设我们要编写一个从 `localStorage` 读取值并将其反序列化为 JSON 的函数。如果该项不存在或者是无效 JSON，则该函数应返回错误结果，否则，它应该反序列化并返回值。

因为我们不知道在反序列化持久化的 JSON 字符串后我们会得到什么类型的值。我们将使用 `unknown` 作为反序列化值的类型。这意味着我们函数的调用者必须在对返回值执行操作之前进行某种形式的检查（或者使用类型断言）。

这里展示了我们怎么实现这个函数：

```ts
type Result =
  | { success: true, value: unknown }
  | { success: false, error: Error };

function tryDeserializeLocalStorageItem(key: string): Result {
  const item = localStorage.getItem(key);

  if (item === null) {
    // The item does not exist, thus return an error result
    return {
      success: false,
      error: new Error(`Item with key "${key}" does not exist`)
    };
  }

  let value: unknown;

  try {
    value = JSON.parse(item);
  } catch (error) {
    // The item is not valid JSON, thus return an error result
    return {
      success: false,
      error
    };
  }

  // Everything's fine, thus return a success result
  return {
    success: true,
    value
  };
}
```

返回值类型 `Result` 是一个[被标记的联合类型](https://mariusschulz.com/blog/typescript-2-0-tagged-union-types)。在其它语言中，它也可以被称作 `Maybe`、`Option` 或者 `Optional`。我们使用 `Result` 来清楚地模拟操作的成功和不成功的结果。

`tryDeserializeLocalStorageItem` 的函数调用者在尝试使用 `value` 或 `error` 属性之前必须首先检查 `success` 属性：

```ts
const result = tryDeserializeLocalStorageItem("dark_mode");

if (result.success) {
  // We've narrowed the `success` property to `true`,
  // so we can access the `value` property
  const darkModeEnabled: unknown = result.value;

  if (typeof darkModeEnabled === "boolean") {
    // We've narrowed the `unknown` type to `boolean`,
    // so we can safely use `darkModeEnabled` as a boolean
    console.log("Dark mode enabled: " + darkModeEnabled);
  }
} else {
  // We've narrowed the `success` property to `false`,
  // so we can access the `error` property
  console.error(result.error);
}
```

请注意，`tryDeserializeLocalStorageItem` 函数不能简单地通过返回 `null` 来表示反序列化失败，原因如下：

1. `null` 值是一个有效的 JSON 值。因此，我们无法区分是对值 `null` 进行了反序列化，还是由于缺少参数或语法错误而导致整个操作失败。
2. 如果我们从函数返回 `null`，我们无法同时返回错误。因此，我们函数的调用者不知道操作失败的原因。

为了完整性，这种方法的更成熟的替代方案是使用[类型解码器](https://dev.to/joanllenas/decoding-json-with-typescript-1jjc)进行安全的 JSON 解析。解码器需要我们指定要反序列化的值的预期数据结构。如果持久化的JSON结果与该数据结构不匹配，则解码将以明确定义的方式失败。这样，我们的函数总是返回有效或失败的解码结果，就不再需要 `unknown` 类型了。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
