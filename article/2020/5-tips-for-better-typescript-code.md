> * 原文地址：[5 Tips for Better TypeScript Code](https://levelup.gitconnected.com/5-tips-for-better-typescript-code-5603c26206ef)
> * 原文作者：[Anthony Oleinik](https://medium.com/@anth-oleinik)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/5-tips-for-better-typescript-code.md](https://github.com/xitu/gold-miner/blob/master/article/2020/5-tips-for-better-typescript-code.md)
> * 译者：[Zavier](https://github.com/zaviertang)
> * 校对者：[regonCao](https://github.com/regon-cao)、[niayyy](https://github.com/nia3y)

# TypeScript 的 5 个建议

![5 Tips for Better TypeScript](https://cdn-images-1.medium.com/max/2000/1*VGWjFbzekvE7WD3e5fGQHQ.png)

原生的 JavaScript 存在不少的问题，TypeScript 对此也有许多解决方案，其中一些需要我们稍微挖掘以一下才能发现。

在我刚开始学习前端的时候，我了解到 TypeScript 是用来解决 JavaScript 存在的各种问题的。比如：传递错误的参数、杂乱的类型互换、访问空值等日常开发经常遇到的问题。

使用 TypeScript 让我的开发效率大大提高。同时，我也一直在学习和研究 TypeScript 的细节，这里和大家分享我所学到的一些内容。

## 1. 空值合并运算符

有时，在访问属性时 TypeScript 会自动帮你插入可选链操作符。类似 `let t = myObj?.property `，这样的话变量 `t` 将被赋值为 `property` 或 `undefined`。这样做非常棒，但重要的是我们要确切地知道这里发生了什么，这样你就可以得心应手的使用它，而不只是把它当作是 TypeScript 自动完成的功能。

如果我们使用常规的方式访问属性，像这样：`myObj.property`，如果 `myObj` 是`undefined`，将会报错：“Cannot access property 'property' of undefined”。这显然不是我们预期的，所以使用 `?.` 意思是如果 `myObj` 是 `undefined`，我们就停止访问属性并把 `t` 赋值为 `undefined`。

这对于避免错误是非常有用，但有时我们需要一个默认的值。例如，如果我们有一个用户从未访问的文本域，这样内部的值是 `undefined`，该怎么办？我们预期不是传送 `undefined` 给后端。我们可以使用**可选链操作符**（我们刚刚提及的 `?.` ）配合**空值合并运算符**。如下：

```ts
sendFieldToServer(textField?.text ?? '')
```

这是非常优雅的方式，可以很安全地处理很多边界情况。也就是说，它保证了 `undefined` 不可能传递给函数，TypeScript 会将一个字符串传递给 `sendFieldToServer` 函数。

这是因为当左边的值是 `undefined` 时空值合并运算符会将右边的值传递给函数，也就是一个空字符串。

在 JavaScript 中，很容易忽略代码中所有可能是 `undefined` 的地方。幸运的是，TS 会帮我们发现错误，并警告你 `sendFieldToServer` 不能接受 `undefined` 作为参数。同时我们使用可选链操作符和空值合并运算符来保证代码的严谨性。

## 2. 不要使用默认导出

TypeScript 优于 JavaScript 的一个原因是代码的自动补全能力。因为在 TypeScript 中，编辑器能够确切地知道你正在访问的对象以及哪些属性是可以访问的。比如你有一个 `dog` 对象，编辑器将提示你可以访问它的 `bark` 方法。

也就是说，如果 `dog` 在作用域内。

如果我们在 `dog.ts` 中默认导出 `Dog`，如下：

```ts
default export interface Dog {
     bark: () => void,
}
```

然后，我们导入时可以给它任意命名。比如可以从其他文件中导入 dog 命名为 cat，如下：

```ts
import cat from 'dog.ts'

cat.bark()
```

这是正确的 TypeScript 代码。这意味着如果我们这样：

```ts
let t: dog = {
   bark: () => console.log('woof!')
}
```

TypeScript 不知道 `dog` 是什么。在 `dog` 下面会有一条红线表示 `dog` 没有定义。你需要找到定义 `dog` 的位置，然后手动导入，并确保将其命名为 `dog`。

这就是默认导出的后果。导出 `dog` 要像下面这样：

```ts
export interface dog {..} //export without 'default'
```

这意味着现在，在我们的另一个文件中，当我们键入 `let t: dog` 时，TypeScript 知道去哪寻找一个叫做 `dog` 的接口。编辑器将自动为你导入，TypeScript 也能够知道你可以访问 `bark` 方法。

代码补全是一个很好的特性。我发现没有理由选择默认的导出方式，因为常规导出实际上更有用。即使你只需导出一个，常规导出仍然可以轻松地处理。

eslint 有一个 `no default export` 规则，它可以发现任何的默认导出。

## 3. 限制字符串的可选值

枚举算是编程语言中非常棒的能力了，当 JavaScript 决定不包含枚举时，可以说它的优越性大大下降。

虽然 TypeScript 本身就有枚举类型，但你并不是一定需要使用它们。定义枚举类型也要一定的开销。TypeScript 还有更好的方式。

```ts
t: "left" | "right" | "middle" = "middle"
```

这样做也算是枚举。这里，你只能给 `t` 赋值给限定的这 3 个值。这里我们在一行代码中定义了它，TypeScript 会限制不能给 `t` 赋值其他任何值。如果我们尝试 `t="center"`， TypeScript 会报错。我们可以 100% 确定 `t` 的值是这三个值中的一个，所以当我们在访问 `t` 时，可以推断 `t` 的值是什么。

同时，`t` 仍然是一个普通的字符串。我们可以正常的将它和其他字符串拼接，显示到界面上。

## 4. 使用 Map\<T>

JavaScript 的一个优点是它有一个灵活的原型机制。你可以在任何对象上添加任何属性。`myObj.nonExistantField = "Is This" + 12312 + "A string or a number? Who Cares!" * 4`，但是，我们忽略了一些，比如：

1. 原型访问相对较慢；
2. 不容易遍历（你需要使用 `Object.keys(myOjb)` 或其他方式）；
3. 如果每个程序员只是直接向对象中添加属性，将很难处理；
4. 可能存在未定义的属性。

你也可以在 TypeScript 中做同样类似的事情，比如允许值的类型为 any，但不推荐这么做。

反而，我们可以使用 `Map`。它也存在于原生 JS 中，但在 JS 中它没有类型限制，所以它没有那么有用。如下：

```ts
let myMap: Map<string, string> = new Map()
```

这将创建一个映射，可以解决我提到的基于原型的 key-value 映射所存在的问题。

1. 它访问非常快：HashMap 只需要 O(1) 的时间复杂度，添加也是；
2. 使用 `map.forEach()`，可以很方便地进行遍历；
3. 只要键和值的类型正确，你可以将任何内容放入其中；
4. 可以避免 undefined（只要限制类型不包括 undefined 即可）。

Map 很有用，在面试中它也是最常被问及的数据结构的问题。在我看来，它们比基于原型的映射要好得多。如果你试图允许随意定义对象的键，那么可能使用了错误的数据结构。

## 5. 配置 eslint config / tsconfig

一般来说，使用 eslint 或 tsconfig 配置代码格式是很有必要的。例如，我之前使用的是 python，我比较喜欢行末无分号的风格。我进行了 eslint 的相关配置，所以当我不小心输入了分号时，编辑器将会立刻警告我。

在我看来，保持双引号的一致性可以让代码看起来更漂亮，所以我也在 eslint 中添加了双引号的配置。

我是模式匹配的超级粉丝，因此我在我的 tsconfig 配置它为强制的。

我更喜欢 no-default-export，所以我也把它设置为强制的。

我强烈地建议你花些时间来检查一下 `.tsconfig` 或者 `.eslintrc` 中所有的配置，并进行个性化地设置。然后，将这些文件备份，当你开始一个新项目时，就可以轻松地粘贴到那里。

有时，当我看到我的代码都保持着统一的风格时，我会感到非常的欣慰。同时还有另一个好处，就是当有其他人参与到这个项目时，他也要遵循在 `.tsconfig` 和 `.eslintrc` 约定的规则，这样我们就可以保证整个项目代码风格的一致性。

---

好了！这就是我对 TypeScript 编码的 5 个建议。同时我也一直在寻找更多的建议，所以如果你有任何你认为值得关注的点，可以给我留言！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
