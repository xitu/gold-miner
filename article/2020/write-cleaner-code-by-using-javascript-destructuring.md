> * 原文地址：[Write Cleaner Code by Using JavaScript Destructuring](https://medium.com/better-programming/write-cleaner-code-by-using-javascript-destructuring-cd6b55c25bac)
> * 原文作者：[Juan Cruz Martinez](https://medium.com/@bajcmartinez)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/write-cleaner-code-by-using-javascript-destructuring.md](https://github.com/xitu/gold-miner/blob/master/article/2020/write-cleaner-code-by-using-javascript-destructuring.md)
> * 译者：[zenblo](https://github.com/zenblo)
> * 校对者：[NieZhuZhu](https://github.com/NieZhuZhu)、[regon-cao](https://github.com/regon-cao)

# 使用 JavaScript 解构让代码更优雅

![作者图片](https://cdn-images-1.medium.com/max/2560/1*h-mNn0rVcSdzJ4FZq_Oj9w.jpeg)

解构是我最喜欢的 JavaScript 特性之一。简单地说，解构可以将复杂结构（如数组或对象）分解为更简单的部分，虽然还有很多内容，但是相对简化了代码结构。

让我们通过一个例子来更好地了解：

```JavaScript
const article = {
  title: "My Article",
  rating: 5,
  author: {
    name: "Juan",
    twitter: "@bajcmartinez"
  }
}
// 现在把它打印出来
console.log(`"${article.title}" by ${article.author.name} had ${article.rating} stars`)
// 通过使用解构同样能完成
const { title, rating, author: { name } } = article
console.log(`"${title}" by ${name} had ${rating} stars`)
------------------------
Output
------------------------
"My Article" by Juan had 5 stars
"My Article" by Juan had 5 stars
```

现在，一部分人已经采用解构开发了一段时间，或许是在构建 React 应用时候，但是他们并不完全了解它。对其他人来说，这可能是第一次用到解构。因此，本文将从头到尾完成整个过程，最终使得大家对解构的认知都能达到同一水平。

## 解构对象

在上面的例子中，所有隐藏的内容都发生在下面这行代码：

```js
const { title, rating, author: { name } } = article
```

现在，在表达式左侧使用这样的大括号似乎有点奇怪，但这就是我们告诉 JavaScript 正在分解对象的方式。

解构对象可以绑定到对象里的任一层级的任何属性上。让我们从一个更简单的示例开始：

```js
const me = {
  name: "Juan"
}

const { name } = me
```

在上面的例子中，我们声明了一个名为 `name` 的变量，该变量将从对象 `me` 中获得相同名称的初始化属性，因此当我们对 `name` 求值时，我们得到 `Juan`。太棒了！这个操作同样适用于任意层级的属性。回到我们的例子：

```js
const { title, rating, author: { name } } = article
```

对于 `title` 和 `rating`，和我们之前的讲解一样。但是在 `author` 这里，事情有点不同。当我们遇到一个是对象或数组的属性时，我们可以选择是创建一个变量 `author` 的引用对象 `article.author`，或者进行深度解构并立即访问内部对象的属性。

访问对象属性：

```JavaScript
const { author } = article
console.log(author.name)
------------------------
Output
------------------------
Juan
```

执行深度或嵌套解构：

```JavaScript
const { author: { name } } = article
console.log(name)
console.log(author)
------------------------
Output
------------------------
Juan
Uncaught ReferenceError: author is not defined
```

上面的示例怎么回事？如果解构了 `author`，但是它为什么没有被定义？其实挺简单的。当我们要求 JavaScript 也对 `author` 对象进行解构时，绑定本身并没有被创建，取而代之的是我们可以访问我们选择的所有 `author` 属性，请记住这点。

扩展运算符（`...`）：

```JavaScript
const article = {
  title: "My Article",
  rating: 5,
  author: {
    name: "Juan",
    twitter: "@bajcmartinez"
const { title, ...others } = article
console.log(title)
console.log(others)
------------------------
Output
------------------------
My Article
> {rating: 5, author: {name: "Juan", twitter: "@bajcmartinez" }}
```

此外，我们可以使用扩展运算符 `...` 创建一个包含所有未被解构属性的对象。

如果你有兴趣了解更多关于扩展运算符的知识，请查看[我的文章](https://medium.com/@bajcmartinez/how-to-use-the-spread-operator-in-javascript-3aff104adb71)。

### 重命名属性

解构的一个重要特性是：能够为我们提取的属性选择不同的变量名。让我们看看下面的例子：

```JavaScript
const me = { name: "Juan" }
const { name: myName } = me
console.log(myName)
------------------------
Output
------------------------
Juan
```

通过在一个属性上使用 `:` 我们可以为它提供一个新的名称（在我们的例子中是 `newName`）。然后我们可以在代码中访问这个变量。需要注意的是，原始属性 `name` 的变量并没有被定义。

### 缺少属性

那么，如果我们试图解构一个没有在对象中定义的属性，会发生什么呢？

```JavaScript
const { missing } = {}
console.log(missing)
------------------------
Output
------------------------
undefined
```

在这种情况下，变量的值是 `undefined`。

### 默认值

扩展缺失的属性，当属性不存在时，可以指定一个默认值。让我们来看一些例子：

```JavaScript
const { missing = "missing default" } = {}
const { someUndefined = "undefined default" } = { someUndefined: undefined }
const { someNull = "null default" } = { someNull: null }
const { someString = "undefined default" } = { someString: "some string here" }
console.log(missing)
console.log(someUndefined)
console.log(someNull)
------------------------
Output
------------------------
missing default
undefined default
null
some string here
```

这些都是解构对象赋值的例子，默认值仅在属性 `undefined` 分配。例如，如果属性的值为 `null` 或 `string`，则不会分配默认值，但属性的实际值会被分配。

## 解构数组和可迭代对象

我们已经看到了一些解构对象的例子，但是同样的例子也适用于数组或可迭代对象。让我们从一个例子开始：

```JavaScript
const arr = [1, 2, 3]
const [a, b] = arr
console.log(a)
console.log(b)
------------------------
Output
------------------------
1
2
```

当我们需要解构一个数组时，我们需要使用 `[]` 而不是 `{}`，我们可以用不同的变量映射数组的每个位置。但是也有一些不错的方法：

### 跳过元素

通过使用 `,` 运算符，我们可以跳过可迭代数据项中的一些元素，如下所示：

```JavaScript
const arr = [1, 2, 3]
const [a,, b] = arr
console.log(a)
console.log(b)
------------------------
Output
------------------------
1
3
```

请注意，在 `,` 之间留一个空格会跳过元素。这是小细节，但对结果有很大影响。

你还能做什么？你也可以使用扩展运算符 `...` 进行如下操作：

```JavaScript
const arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
const [a,, b, ...z] = arr
console.log(a)
console.log(b)
console.log(z)
------------------------
Output
------------------------
1
3
(7) [4, 5, 6, 7, 8, 9, 10]
```

在这种情况下，`z` 将获得 `b` 之后的所有值成为数组。或者你有一个更具体的需求，你想在数组中的特定位置解构。没问题，JavaScript 依然可以做到：

```JavaScript
const arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
const { 4: fourth, 9: ninth } = arr
console.log(fourth)
console.log(ninth)
------------------------
Output
------------------------
5
10
```

如果我们把一个数组当作一个对象来解构，我们可以把索引作为属性，来访问数组中的任何位置的值。

### 缺少属性

与对象的情况一样，也可以为数组中未定义的元素设置默认值。让我们看一些例子：

```JavaScript
const [missing = 'default missing'] = []
const [a, b, c = "missing c", ...others] = [1, 2]
console.log(missing)
console.log(a)
console.log(b)
console.log(c)
console.log(others)
------------------------
Output
------------------------
default missing
1
2
missing c
[]
```

当解构数组时，也可以为 `undefined` 属性设置默认值。但是，当我们使用扩展运算符 `...` 时，则不能为变量设置默认值。在使用 `...` 解构 `undefined` 时，它将返回一个空数组：

## 交换变量

这是一个有趣的解构示例。在一个表达式中可以交换两个变量：

```JavaScript
let a = 1
let b = 5
[a, b] = [b, a]
console.log(a)
console.log(b)
------------------------
Output
------------------------
5
1
```

## 使用计算属性进行解构

直到现在，任何时候我们想要解构一个对象的属性或者一个可迭代的元素，我们都使用静态键。如果我们想要动态键(比如存储在变量中的键)，我们需要使用计算属性：

这里有一个示例：

```JavaScript
const me = { name: "Juan" }
let dynamicVar = 'name'
let { [dynamicVar]: myName } = me
console.log(myName)
------------------------
Output
------------------------
Juan
```

通过在 `[]` 中使用变量，我们可以在赋值之前计算它的值。因此，尽管必须为该新变量提供名称，但可以进行动态解构。

## 解构函数参数

解构变量可以在我们声明变量的任何地方使用（例如，通过使用 `let`、`const` 或 `var`），也可以解构函数参数。这是一个简单的示例：

```JavaScript
const me = { name: "Juan" }
function printName({ name }) {
    console.log(name)
}
printName(me)
------------------------
Output
------------------------
Juan
```

非常简单。此外，我们之前讨论过的所有规则都适用。

## 结论

在开始使用解构时可能会不舒服，但一旦你习惯了，就再也回不去了。它真的可以让你的代码更简洁，这是一个需要了解的概念。

你知道在导入模块时也可以使用解构吗？看看我关于这个话题的[文章](https://levelup.gitconnected.com/an-intro-to-javascript-modules-36c07c5d4c9c)。

感谢阅读！希望你喜欢。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
