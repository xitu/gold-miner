> * 原文地址：[5 Advanced TypeScript Tips To Make You a Better Programmer](https://levelup.gitconnected.com/5-advanced-typescript-tips-to-make-you-a-better-programmer-bd4070aa2ab4)
> * 原文作者：[Anthony Oleinik](https://medium.com/@anth-oleinik)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/5-advanced-typescript-tips-to-make-you-a-better-programmer.md](https://github.com/xitu/gold-miner/blob/master/article/2021/5-advanced-typescript-tips-to-make-you-a-better-programmer.md)
> * 译者：[Usualminds](https://github.com/Usualminds)
> * 校对者：[PassionPenguin](https://github.com/PassionPenguin)、[zenblo](https://github.com/zenblo)

# 掌握这 5 个 TypeScript 高级技巧，成为更好的开发者

![Beautiful :)](https://cdn-images-1.medium.com/max/3200/0*RKICUYO863Mu_2mX.png)

Typescript 是一门神奇的语言 —— 相比 JavaScript 可以实现的所有功能，它只用十分之一的调试时间就可以完成，主要包括以下几点：

* 通过编写强类型和可读性更高的代码来减少 bug
* 代码中可以集成更多有价值的功能，从而避免重复造轮子

以下 5 条 TypeScript 的高级使用技巧，可让你写出更好的 TypeScript 代码。

#### 1. is 运算符 / 类型保护

Swagger 极大地帮助我们了解后端可以提供什么样的服务 —— 但是，通常情况下，开发者往往会得到和约定不一致的 API，其中某些 API 属性可能存在，也可能不存在，或者是根据状态返回不同的对象。

不幸的是，如果你不知道 API 会返回什么结果，就无法在编译时捕获它们，但我们可以做的是，使其在运行时更加易于处理（和上报！）。

API 调用一般是 TypeScript 错误的出处 —— 我们通常会将 API 调用的返回结果像下面这样强制转换：

```ts
const myApiResult = await callApi("url.com/endpoint") as IApiResult
```

甚至更糟糕…

```ts
const myApiResult = await callApi("url.com/endpoint") as any
```

这两种方法都会导致编译器关闭，但是第一种方法明显比第二种方法的健壮性更高 —— 事实上，第二种方法处理的返回结果和 JavaScript 没什么区别。

但如果 API 返回的结果不是 `IApiResult` 类型怎么办？其返回值类型和我们期望的不同，我们可以定义一个随机的 `MyApiResult` 类型？其结果显而易见会存在问题，并且会 100% 地导致输入类型错误。

我们可以使用 TS 的类型保护来处理以上问题:

```ts
interface IApiResponse { 
   bar: string
}

const callFooApi = async (): Promise<IApiResponse> => {
 let response = await httpRequest('foo.api/barEndpoint') // 返回值类型未知
 if (responseIsbar(response)) {
   return response
 } else {
   throw Error("response is not of type IApiResponse")
 }
}

const responseIsBar = (response: unknown): response is IApiResponse => {
    return (response as IApiResponse).bar !== undefined
        && typeof (response as IApiResponse).bar === "string"
}
```

通过 `responseIsBar` 方法，我们可以提前判断返回值类型是否为 ` IApiResponse` ，从而防止出现类型转换错误。

实际使用场景中，你可以提示用户“服务器返回异常，请重试”，或者提示与之类似的错误信息，而不是显示 `属性 'bar' 不存在`。

`is` 操作符的一般含义是：`value is type` 实际上是一个布尔值，当输入 `true` 时，意味着告诉了 TypeScript 返回值的类型确实是我们所期望的类型。

#### 2. As Const / Readonly

这是一个更简洁的类型语法糖。很多人都知道，在给接口赋值时，可以通过 `readonly` 声明使该属性只能被读取而不能被写入

```ts
interface MyInterface {
  readonly myProperty: string
}

let t: MyInterface = {
  myProperty: 'hi'
}

t.myProperty = "bye" // 编译错误, myProperty 是只读属性.
```

这样处理就很棒，如果你哪天遇到了比较复杂返回结果数据集，比如 API 返回结果。接着你可以根据每个属性的 readonly 标识符，识别其为简单的数据集。

Typescript 支持在类型声明后加上 `as const`，这样我们就相当于给每个属性添加 `readonly`。

```ts
let t = {
 myProperty: "hi",
 myArr: [1, 2, 3]
} as const 
```

现在，T 的所有属性值都是不可修改的。例如，`t.myArr.push(1)` 不能编译，给 `myProperty` 属性重新赋值同样也不能编译。

我认为对我们最有帮助的场景与之前一样 —— 不同的是，在这里我们不是返回一个接口，而是想通过代理的方法修改 API 对象中的部分属性，使其成为一个数据对象，所以，结合前面的技巧:

```ts
const callFooApi = async () => {
 let response = await httpRequest('foo.api/barEndpoint') // 返回值类型未知
 if (responseIsbar(response)) {
   // 过滤掉不需要掉数据，在这里对数据进行自定义格式化处理
   return {
      firstLastName: [response.firstName, response.lastName]
   } as const
 } else {
   throw Error("response is not of type IApiResponse")
 }
}
```

使用这个方法的开发者想必都会喜出望外 —— 它不仅可以识别返回值类型（来自 `response ` 的类型变量），而且数据还是不可变的（immutable）。当我们调用 API 时，可以通过这个简单的方法验证返回值是否符合我们的期望。这对每个开发者而言都是一种进步！

做一个小提示，如果你只想进行类型声明，而不想让其属性只读，你可以这样做：`type MyTypeReadonly = Readonly<MyType>` 。我们将会在后面的第 5 点更深入地讨论这个问题。

#### 3. 扩展性更好的 Switch Case

扩展枚举（enum）通常是一件叫人头疼的事情，因为我们需要在所有使用枚举的地方都添加新的 Case。如果我们忘记了其中某一个跳转条件，我们的程序就会跳转到默认情况 (如果有的话) 或者失败，这可能会导致出乎意料的问题。

没有人喜欢这样。

许多语言解决这个问题的方法是：必须有明确 Switch 和 Case 场景，或者显式声明一个 `default` 状态。Typescript 编译器不支持这种情况，但我们可以这样创建 `switch case`：如果我们扩展了枚举（enum）或其他可能的值，我们的程序就不会编译，直到我们显式地处理了这种情况。

我们所说的方法如下：

```ts
enum Directions {
   Left,
   Right
}

const turnTowards = randomEnum(Direction)

switch (turnTowards) {
      case Directions.Right:
         console.log('we\'re going right!')
         break
      case Directions.Left:
         console.log('Turning left!')
         break
}
```

即使是初级的开发者也可以看懂我们这个程序到意思是向左转或向右转。在这里添加默认（default）语句似乎并不必要，这里只有两个枚举值。但是请记住，我们编写代码不仅仅是为了完成它，而且要考虑代码到可维护性！

假设两年后，另一个开发人员决定添加一个新的方向：Forward 。现在，枚举（enum）看起来是这样的：

```ts
enum Directions {
   Left,
   Right,
   Forward
}
```

程序里的 `switch case` 知道这一点，但它**不在乎**。它会很自然地尝试打开 `goingTowards` ，如果它遇到 forward，它也会很自然地出错。两年是很长的一段时间，开发者忘记了之前都在哪里使用了 `switch case` 代码。对此，我们可以添加一个针对默认值的异常处理，让其在编译时抛出异常，这样总比运行时错误好。

所以我们可以添加默认情况如下：

```ts
default:
   const exhaustiveCheck: never = myDirection
   throw new Error(exhaustiveCheck)
```

如果我们处理了 `Forward` 这个情况，那么一切都正常。如果我们不这样做，那么我们的程序将无法编译！( `throw` 这一行是可选的，我这样做只是为了关闭 eslint 对未使用变量的校验报错)

这降低了我们每次改变枚举（enum）时的记忆负担，我们可以通过编译器找到它们。

#### 4. 使用 Null 代替 ? 操作符

许多使用过其他语言的开发者都会认为 `null === undefined`，事实并非如此（不用担心，这个技巧会变得更好）

`undefined` 是可以通过 JavaScript 赋值的 —— 例如，如果我们有一个文本框，它没有输入值，那它就是 `undefined`。可以把 `undefined` 看作是 JavaScript 的一个自动触发的空值。

我们通常很难判断一个字段是设计里本来就没有，还是无意中留下的。如果我专门为一个字段设置默认值，我会用 `null`。这样，每个人都知道这个字段是专门置空的。

这里有一个例子：

```ts
interface Foo {
   bar?: string
}
```

属性 `bar` 以问号结尾，意味着这个字段可能是 `undefined`，因此 `let baz: Foo = {}` 会通过编译（另外, `let baz: Foo = {bar: null} ` 也能通过编译）。然而开发者无法通过上述代码知道我是故意让 `bar` 取空值还是无意的。 一个更好表述我声明意图的示例如下：

```ts
interface Foo {
  bar: string | null
}
```

现在，我必须 **明确地声明 `bar` 的取值为 `null`。** 我的意图不会被混淆 — `bar` 没有明确的取值。

这不仅适用于接口声明 —— 我还会在函数不返回任何内容时使用它。这在编译时很有帮助:

```ts
// 如果我们忘记指定了函数的返回值，编译器会返回默认值
const myFunc = (): string | void => {
   console.log('blah')
}
```
```ts
// 如果我们忘记指定了函数的返回值，编译器会返回 null
const myFunc = (): string | null => {
 // 编译错误时不会返回 null
}
```

#### 5. Utility Types

如果你在大型的 TS 项目里写过代码，你就会发现接口声明无处不在。有些接口与其他接口名称一样，有些接口属性重复，有些接口属性和名称都一样。

如果真是这样的话，先不用惊慌。你正在按照预期使用 TS：那就是类型安全。但是，如果你没有利用 TS 的内置类型，那你可能写了太多的重复代码。下面是 [你至少应该知道存在的内建类型的链接](https://www.typescriptlang.org/docs/handbook/utility-types.html)，以便你可以在代码中使用。

我将介绍我最喜欢的和最常用的一些内置类型，但是你知道的越多，你就能把你的代码写得越好。

**Partial**

将所有类型字段设置为可选。当你想要对一个对象执行更新时，这是很有用的，例如:

```ts
function updateBook<T extends Book>(book: T, updates: Partial<T>) {
   const updatedBook = {...book, ...updates }
   notifyServer(updatedBook)
   return updatedBook
}
```

**Readonly**

它将所有字段设置为只读。我使用它作为返回值，主要是在返回数据时。

```ts
function generateData(): Readonly<T>
```

**NonNullable**

创建一个新类型，不包含 null / undefined 属性。如果我们正在增加或填写一些数据，这是很有用的，可以保证它是有值的。

```ts
interface IPerson {
  name: string
}

type MaybePerson = Person | null

const fillMaybePerson = (maybe: MaybePerson): NonNullable<MaybePerson> ...
```

**ReturnType**

Type 是函数的返回类型。如果你写的 API 涉及到了函数，并且不想约束函数，这很有用。

```ts
const getMoney = (): number => {
  return 100000
}

ReturnType<getMoney> //number
```

**Required**

从接口声明中移除具有 `?` 属性的值。

```ts
interface T {
  maybeName?: string
}

type CertainT = Required<T> // 等价于 { maybeName: string }
```

---

关于 TS，我要说的就这么多了！如果你在任何地方发现了错误，请告诉我，这样我可以在其他人学到错误知识之前修复它。如果你认为我遗漏了什么知识点，也请让告诉我！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
