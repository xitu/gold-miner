> * 原文地址：[Using Typescript to make invalid states irrepresentable](http://www.javiercasas.com/articles/typescript-impossible-states-irrepresentable)
> * 原文作者：[Javier Casas](http://www.javiercasas.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/typescript-impossible-states-irrepresentable.md](https://github.com/xitu/gold-miner/blob/master/TODO1/typescript-impossible-states-irrepresentable.md)
> * 译者：[solerji](https://github.com/solerji)
> * 校对者：[lgh757079506](https://github.com/lgh757079506)

# 使用 Typescript 使无效状态不可恢复

有一种好的 Haskell 编程原则，同样也是一种好的函数式编程原则，叫做使无效状态不可恢复原则。这是什么原则呢？通常我们使用类型系统来构建对数据和状态施加约束的类型，从而达到可以代表已存在状态的效果。现在，在类型级别上，我们设法消除了无效状态，但类型系统每次试图构造无效状态时都会介入无效状态，并给我们带来麻烦。如果我们不能构造一个无效的状态，我们的程序就很难以无效的状态结束，因为为了达到无效的状态，程序必须遵循一系列构造无效状态的操作。但是这样的程序在类型级别上是无效的，排版检查程序会告诉我们：我们做了一些错误的事情。这很棒，由于类型系统会为我们记住数据的约束条件，所以我们不必依赖爱忘事的内存来记住它们。

幸运的是，这项技术的许多结果可以应用于其他编程语言，今天我们将在 Typescript 中进行试验。

## 一个例子

让我们来研究一个示例问题，这样我们就可以尝试理解如何使用它。我们将使用代数数据类型来约束一个函数的类型，这样我们就可以防止对它使用无效参数。我们的小例子如下：

* 我们有一个接受单个参数的函数：一个对象有两个字段，称为 `field1` 和 `field2`。
* 对象不能同时具有这两个字段。
* 对象可能只有 `field1`，没有 `field2`。
* 只有当对象有 `field1` 时，它才能有 `field2`。
* 因此，具有 `field2` 的对象而没有 `field1` 的对象无效。
* 为简单起见，当存在 `field1` 或 `field2` 时，它们将是 `string` 类型，但它们本身可以是任何类型的。

### 缺乏经验的解决方案

让我们从最简单的方法开始。由于 `field1` 和 `field2` 都可以存在，或者不存在，所以我们只是让它们成为可选的。

```typescript
interface Fields {
  field1?: string;
  field2?: string;
};

function receiver(f: Fields) {
  if (f.field1 === undefined && f.field2 !== undefined) {
    throw new Error("Oh noes, this should be impossible!");
  }
  // 其他逻辑代码
}
```

不幸的是，这并不能阻止编译时的任何操作，还需要在运行时检查可能的错误。

```typescript
// 这不会在编译时引发任何错误
// 所以我们必须在运行时发现它
receiver({field2: "Hahaha, I didn't put a field1!"})
```

### 基本 ADT 解决方案

所以我们连续几次在一行中用错误的字段调用 `receiver`，我们的应用程序就会出问题。我么似乎该做些什么了。让我们再看一下这些示例，以便我们可以查看是否可以生成正确的类型：

* 对象不能同时具有这两个字段。
* 对象只能有 `field1`，不能有 `field2`。
* 只有当对象有 `field1` 时，它才能有 `field2`。因此，在本例中，对象同时具有 `field1` 和 `field2`。
* 具有 `field2` 的对象无效，而不是具有 `field1` 的对象。

让我们把它记录成这种类型：

```typescript
interface NoFields {};

interface Field1Only {
  field1: string;
};

interface BothField1AndField2 {
  field1: string;
  field2: string;
};

interface InvalidObject {
  field2: string;
};
```

我们这里也包括 `InvalidObject`，但是写它有点傻，因为我们不希望它真的存在。我们可以将其作为文档保存，或者删除它，以便进一步确认它不应该存在。现在让我们为 `Fields` 字段编写一个类型：

```typescript
type Fields = NoFields | Field1Only | BothField1AndField2;  // 我故意把放在这里的无效对象忘了
```

有了这种处理方式，就很难将 `InvalidObject` 发送给 `receiver` ：

```typescript
receiver({field2: "Hahaha, I didn't put a field1!"});  // 类型错误！这个对象和 `Fields` 不匹配
```

我们还需要稍微调整一下 `receiver` 函数，主要是因为字段现在可能不存在，排版检查程序现在需要证明你将要读取的字段是否实际存在：

```typescript
function receiver(f: Fields) {
  if ("field1" in f) {
    if ("field2" in f) {
      // 为 f.field1 和 f.field2 做些操作
    } else {
      // 为 f.field1 做些操作， 但 f.field2 不存在
    }
  } else {
    // f 是个空字段
  }
}
```

#### 结构类型的限制

不幸的是，无论好坏， Typescript 都是一个结构类型系统，如果我们不小心的话，它会允许我们绕过一些安全问题。 Typescript 中的 `NoFields` 类型（空对象、`{}`）。在 Typescript 中，这意味着与我们希望它做的完全不同的事情。实际上，当我们写的时候，它是这样：

```typescript
interface Foo {
  field: string;
};
```

Typescript 会理解任何带有 `field` ，类型为 `string` 的 `object` 都是可行的，除了我们创建新对象的情况，例如：

```typescript
const myFoo : Foo = { field: "asdf" };  // 在这种情况下，我们无法添加更多字段
```

但是，在赋值时，将 Typescript 测试用做类型脚本，这意味着我们的对象，可能会以我们希望它们具有的更多字段结束：

```typescript
const getReady = { field: "asdf", unexpectedField: "hehehe" };
const myFoo : Foo = getReady;  // 这不是一个错误
```

因此，当我们将这个想法扩展到空对象 `{}` 时，发现在赋值时，只要该值是一个对象，并且具有所需的所有字段， Typescript 就会接受任何值。因为类型不需要字段，所以第二个条件对于任何 `object` 都非常成功，这完全不是我们想要它做的。

### 禁止意外字段

让我们试着为没有字段的对象创建一个类型，这样我们实际上就不得不用自己的方法来愚弄类型检查器。我们已经知道 `never`，这是一种永远无法满足的类型。现在我们需要另一种成分来表示“每一个可能的领域”。这个成分是：`[键：字符串]：类型`。有了这两个，我们就可以在没有字段的情况下构造对象。

```typescript
type NoFields = {
  [key: string]: never;
};
```

此类型表示：这是一个对象，其字段类型为 `never`。由于不能构造 `never`，无法为此对象的字段生成有效值。所以，唯一的解决方案是创建一个没有字段的对象。现在，我们必须更加谨慎地打破这些类型：

```typescript
type NoFields = {
  [key: string]: never;
};

interface Field1Only {
  field1: string;
};

interface BothField1AndField2 {
  field1: string;
  field2: string;
};

type Fields = NoFields | Field1Only | BothField1AndField2;

const broken = {field2: "asdf"};

// Bypass1： 遍历空对象类型
// Empty object is a well known code smell in Typescript
const bypass1 : {} = broken;
const brokenThroughBypass1 : Fields = bypass1;

// Bypass2： 使用 `any` 转移 hatch
// any 在 Typescript 是另一个有名的代码 
const bypass2 : any = broken;
const brokenThroughBypass2 : Fields = bypass2;
```

现在看来，我们需要两个非常具体的步骤来破坏这个系统，这肯定是非常困难的。如果我们必须深入地构建一个程序，我们应该注意到一些问题。

## 结论

今天，我们看到了一种通过类型保证程序正确性的方法，它应用于一种更主流的语言：Typescript。虽然 Typescript 不能保证与 Haskell 相同的安全级别，但这并不妨碍我们将 Haskell 的一些想法应用于 Typescript。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
