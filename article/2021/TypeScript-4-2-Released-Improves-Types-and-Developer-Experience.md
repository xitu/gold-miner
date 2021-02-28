> * 原文地址：[Typescript 4.2 Released, Improves Types and Developer Experience](https://www.infoq.com/news/2021/02/typescript-4-2-released/)
> * 原文作者：[Bruno-Couriol](https://www.infoq.com/profile/Bruno-Couriol/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/TypeScript-4-2-Released-Improves-Types-and-Developer-Experience.md](https://github.com/xitu/gold-miner/blob/master/article/2021/TypeScript-4-2-Released-Improves-Types-and-Developer-Experience.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：

# TypeScript 4.2 正式发布：优化了类型和开发者体验

TypeScript 团队宣布了 [TypeScript 4.2](https://devblogs.microsoft.com/typescript/announcing-typescript-4-2/) 版本的发布！该版本的 TypeScript 拥有了更灵活的类型注释，更严格的检查，额外的配置选项以及一些其他的重大变化。我们现在可以在元组的类型定义中的任意位置使用 rest 参数（而不是只能在末尾使用）。类型别名不再在类型错误消息中扩展，从而提供了更好的开发人员体验。

TypeScript 4.2 [支持元组类型中任何位置的其余参数](https://github.com/microsoft/TypeScript/pull/41544)：

```ts
type T1 = [...string[], number];  // 任意个 string 以及一个 number
type T2 = [number, ...boolean[], string, string];  // 一个 number，跟着任意个 boolean，跟着两个 string
```

在以前的版本中，rest 参数只能在末尾处使用，例如 **`type T1 = [number, ...string[]];`**。因此我们不可能在以固定的参数结尾的函数定义中使用可变数量的参数以使用强类型定义。

```ts
function f1(...args: [...string[], number]) {
    const strs = args.slice(0, -1) as string[];
    const num = args[args.length - 1] as number;
    // ...
}

f1(5);
f1('abc', 5);
f1('abc', 'def', 5);
f1('abc', 'def', 5, 6);  // Error
```

函数 **`f1`** 的 `string` **参数个数是不确定的，后面跟着一个** `number` **类型的参数**。`f1` **现在我们可以精准定义类型了，但仍然不允许使用多个其余元素。可选元素不能在必需元素之前，也不能在其余元素之后。以下的类型是支持的：

```ts
type Tup3<T extends unknown[], U extends unknown[], V extends unknown[]> = [...T, ...U, ...V];

type TN1 = Tup3<[number], string[], [number]>;  // [number, ...string[], number]
// Optional element following required element
type TN2 = Tup3<[number], [string?], [boolean]>;  // [number, string | undefined, boolean]
type TN3 = Tup3<[number], string[], [boolean?]>;  // [number, ...(string | boolean | undefined)[]]
type TN4 = Tup3<[number], string[], boolean[]>;  // [number, ...(string | boolean)[]]
type TN5 = Tup3<string[], number[], boolean[]>;  // (string | number | boolean)[] 
```

TypeScript 4.2 还让我们在使用类型别名时候拥有更好的开发者体验：

![https://imgur.com/rQkqilu.png](https://imgur.com/rQkqilu.png)

前面的示例表明，类型别名 ``BasicPrimitive` **以前在某些情况下（即，扩展为 **number | string | boolean**）已经被扩展（规范化）了。发行说明还强调了在 TypeScript 使用中的不同地方中都做出了改进的开发人员体验：

> 你可以避免显示一些可怕的巨大的类型定义，通常会在快速的信息和签名帮助中转化为更好的 `.d.ts` 文件输出，错误消息以及编辑器中的类型显示。这可以使 TypeScript 对于新手来说更加友善。

**`abstract`** 修饰符现在可以在构造函数签名上使用。

实例。

```ts
abstract class Shape {
    abstract getArea(): number;
}

// 这是个错误！我们不能实例化一个抽象的类 
new Shape();

interface HasArea {
    getArea(): number;
}

// 这是一个错误！我们不能赋予抽象的构造器类型给一个不是抽象的构造器类型
let Ctor: new  () => HasArea = Shape;

// 这就很棒啦
let Ctor: abstract
new ()
=>
HasArea = Shape;
//          ^^^^^^^^
```

**`abstract`** 修饰符的新语义允许我们[以支持抽象类的方式编写 *mixin* 构造器](https://github.com/microsoft/TypeScript/pull/36392)。

我们现在可以将已解构的变量明确标记为未使用，而一些开发人员以前会写：

```ts
const [Input, /* state */, /* actions */, meta] = input 
```

为了更好的维护和阅读性，而非：

```ts
const [Input, , , meta] = input 
```

这些开发者现在可以在未使用的变量名称的前面使用一个下划线标记：

```ts
const [Input, _state, _actions, meta] = input
```

新版本的 TypeScript 还对 `in` 运算符提供了更严格的检查：`"foo" in 42` 将触发类型错误。而 TypeScript 的未调用函数检查现在适用于 `&&` 和 `||` 表达式。[当类型具有字符串索引签名时，设置 `noPropertyAccessFromIndexSignature` 标志不再使使用点运算符（例如person.name），让我们进行属性访问成为可能](https://devblogs.microsoft.com/typescript/announcing-typescript-4-2/#no-property-access-index-signature)。该 `explainFiles` 编译器标志（例如 `tsc --explainFiles`）大约有解决和处理的文件，编译器产生详细的信息：

```sh
TS_Compiler_Directory/4.2.2/lib/lib.es5.d.ts
  Library referenced via 'es5' from file 'TS_Compiler_Directory/4.2.2/lib/lib.es2015.d.ts'
TS_Compiler_Directory/4.2.2/lib/lib.es2015.d.ts
  Library referenced via 'es2015' from file 'TS_Compiler_Directory/4.2.2/lib/lib.es2016.d.ts'

... More Library References...

foo.ts
  Matched by include pattern '**/*' in 'tsconfig.json'
```

TypeScript 4.2 还包含一些重大更改。[JavaScript 中的类型参数不会解析为类型参数](https://devblogs.microsoft.com/typescript/announcing-typescript-4-2/#type-arguments-in-javascript-are-not-parsed-as-type-arguments)，这意味着有效的 TypeScript 代码 `f<T>(100)` 将按照 JavaScript 规范解析到 JavaScript 文件中 `(f < T) > (100)`。`.d.ts`扩展名不能在导入路径中使用：`import { Foo } from "./foo.d.ts;`。我们可以用以下任何一种替换：

```ts
import {Foo} from "./foo.js";
import {Foo} from "./foo";
import {Foo} from "./foo/index.js";
```

TypeScript 4.2 使 TypeScript 更加接近其在运行 JavaScript 的任何规模下准确键入 JavaScript 的目标。但是，在每个发行版中，TypeScript 都会增加其复杂性。一位开发商指出：

> 由于对 TypeScript 进行了如此多的更新，人们开始怀疑是否会出现[…何时]变得太复杂而无法全部了解的问题，就像 C++ 一样。

TypeScript 包含其他功能和重大更改。欢迎开发人员阅读完整的发行说明。TypeScript 是基于 Apache 2 许可的开源软件。鼓励通过 TypeScript GitHub 项目进行贡献和反馈，并应遵循 TypeScript 贡献准则和 Microsoft 开源行为准则。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
