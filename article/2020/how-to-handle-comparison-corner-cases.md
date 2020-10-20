> * 原文地址：[How to handle JavaScript comparison corner cases](https://medium.com/javascript-in-plain-english/how-to-handle-comparison-corner-cases-c96ae9a17d4a)
> * 原文作者：[Alen Vlahovljak](https://medium.com/@AlenVlahovljak)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-handle-comparison-corner-cases.md](https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-handle-comparison-corner-cases.md)
> * 译者：[tonylua](https://github.com/tonylua)
> * 校对者：[Alfxjx](https://github.com/Alfxjx), [nia3y](https://github.com/nia3y)

# 如何处理 JavaScript 比较中的临界情况

![由 [Joshua Aragon](https://unsplash.com/@goshua13?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) 拍摄并发布在 [Unsplash](https://unsplash.com/s/photos/javascript?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/7622/1*cNArmsLDeouV0GoryF4IlA.jpeg)

**“在任何一项足够先进的技术和魔法之间，我们无法做出区分。”** — Arthur C. Clarke （[克拉克基本定律三](https://zh.wikipedia.org/wiki/%E5%85%8B%E6%8B%89%E5%85%8B%E5%9F%BA%E6%9C%AC%E5%AE%9A%E5%BE%8B)）

在我们开始熟悉 JavaScript 的临界情况之前，我想先区分一下 **临界情况（Corner Case）** 和 **边界情况（Edge Case）**。

我们可以说 **边界情况（Edge Case）是一种仅在最小或最大参数时发生的问题**。预测这种问题很重要，因为这些情况可能会被忽视或低估。比如，一台全力运转的 PC 可能会过热，可能会导致性能有所折损。

我也想介绍另一种 **边界情况（Boundary Case）**（这也是一个值得怀疑的问题）。它可能会发生在其中一个参数超出最小或最大限制的时候。

那么 **临界情况** 呢？我并不想给出任何定义，因为在你看过下面的例子之后，你将能自己做到这点。

## 你将难以置信

如果我问你是否有值能强制等于自己的否定，你的答案会是什么？你肯定会说这是一派胡言，但是：

```JavaScript
var arr1 = [];
var arr2 = [];

if (arr1 == !arr2) {
    console.log("Yes, it's true!");
}

if (arr1 != arr2) {
    console.log("It's true again!");
}
```

你可能会认为 JS 是一个疯狂的语言，并且这本不应该发生在 JS 这样流行的语言中。这个例子看起来很愚蠢，因为你在实际中绝不会对变量去比较其自身的否定。**但这是个帮助你理清思绪的绝佳例子。**

**你压根不应该比较数组和数组的否定。** 不应该以这种方式设计代码。上例就是个绝佳的反例。

在下一个例子中，我将细致地解释发生了什么，会让你清楚的认识到运算规则做了什么：

```JavaScript
var arr1 = [];
var arr2 = [];


//1. arr1 == !arr2
//2. [] == false 
//3. "" == false
//4. "" == 0
//5. 0 == 0 
//6. 0 === 0 
if (true) console.log("Yes, it's true!");
```

首先，我将引用 [文档](https://www.ecma-international.org/ecma-262/#sec-abstract-equality-comparison) 中的规则。在以上代码的第 6 行，比较了一个基本类型值和一个非基本类型值。在这种情况下，采用规则 №11 。**该运算的结果是一个空字符串。**

在下一步中，将一个空字符串和 **false** 相比较。根据运算规则，采用规则 №9 。再下一步（第 8 行）则采用规则 №5 。第 5 步成了比较两个数字。因为使用了相等性比较，**我们将会调用严格相等性比较算法**。

最后一步从严格相等性比较中返回了一个 **true**。第二个例子更实用一点，因为我们使用了不等于（双等于号的否定）- **检查是否强制相等**:

```JavaScript
var arr1 = [];
var arr2 = [];


//1. arr1 != arr2
//2. (!(arr1 == arr2))
//3. (!(false))
if (true) console.log("It's true again!");
```

**鉴于我们比较的是两个非基本类型，这意味着会比较变量的标识符。** 等同于采用了严格相等性比较。

## 别惹布尔值

让我们谈谈布尔值及其与抽象相等性的联系。这是你会经常碰到的问题。我们应该看看会发生的临界情况：

```JavaScript
var students = [];


if (students) {
    console.log("You can see this message!");
}

if (students == true) {
    console.log("You can't see this message!");
}

if (students == false) {
    console.log("Working!");
}
```

**明确的比较有时反倒会带来不必要的麻烦。** 在第二个 if 子句中，我们将数组和布尔值做了比较。你可能认为该操作的结果应当为布尔值 **true**，但并非如此。**严格相等性比较也有同样的效果。**

比较一个数组和一个布尔值会引起许多临界情况。在我们看例子之前，我要给你个提示： **永远不要对布尔值（true 和 false）使用双等于号**。让我们分析下是如何运算的：

```JavaScript
var students = [];


//** if(students) **//
// 1. students 
// 2. Boolean(students)
if (true) console.log("You can see this message!");

//** if(students == true) **//
// 1. "" == true
// 2. "" == 1
// 3. 0 === 1
if (false) console.log("You can't see this message!");

//** if(students == false) **//
// 1. "" == false
// 2. "" == 0
// 3. 0 === 0
if (true) console.log("Working!");
```

首个 if 子句是自解释的，所以我不会费时赘述。一如之前的例子，**我引用了 [文档](https://www.ecma-international.org/ecma-262/#sec-abstract-equality-comparison)** 中的规则。当其中一个被比较的值是非基本类型时，比较数组和布尔值会调用 [**ToPrimitive()**](https://www.ecma-international.org/ecma-262/#sec-toprimitive) 抽象操作（规则 №11）。

之后的三步（译注：第二个 if 子句）直接了当。首先，将一个布尔值转换为一个数字（规则 №9：[**ToNumber(true)**](https://www.ecma-international.org/ecma-262/#sec-tonumber)），接下来字符串变为数字（规则 №5：[**ToNumber(“”)**](https://www.ecma-international.org/ecma-262/#sec-tonumber)），最后一步则是执行一次严格相等性比较。第三个子句同样如此。

强制转换的风险之一就是抽象操作 **ToNumber()**。我不确定将空字符串转换为数字是否应该返回 **0**。**返回 NaN 其实会更好，因为 NaN 表示了一个非法的数字。**

推论：**无意识的输入总会产生无意识的输出。不必总是显式比较，隐式比较有时比前者更佳。**

检查数组值的存在性最好的办法就是明确的检查 `.length` 以确定其是个字符串还是个数组：

```JavaScript
const arr1 = [1, 2, 3];
const arr2 = [];


if (arr1) {
    console.log("You should see this message!");
}

if (arr1.length) {
    console.log("Array is not empty!");
}


if (arr2) {
    console.log("You should not see this message!");
}

if (arr2.length) {
    console.log("You can't see this message!");
}
```

深层检测更为可靠。如你所见，一个空数组将返回 **true** （强制转换为布尔值之后）。对于对象也应采用同样的办法 -- **总是做深层检查**。当我们想要确定类型是字符串还是数组时，使用 `typeof` 操作符（或 `Array.isArray()` 方法）。

## 说明

你必须遵守若干准则以避免陷入临界情况的陷阱。**随处使用的非严格相等是把双刃剑。** 应谨记当两侧进行比较的值是 **0**、空字符串或只包含空格的字符串时，使用非严格相等是个不好的做法。

下一件应牢记之事是避免对非基本类型使用非严格相等。**唯一能使用它的时机是一致性检查时。** 但我也不能说 100% 安全，因为它已经足够接近临界情况，不值得冒险。

[ECMAScript 6](https://www.w3schools.com/js/js_es6.asp) 引入了一个新的工具方法 [**Object.is()**](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/is)。借助该方法，我们终于可以在无副作用的情况下执行一致性比较。最后我们可以讲，使用非严格相等只对基本类型安全，对非基本类型则不安全。

最后但也是最重要的是要避免对布尔值（**true** 和 **false**）使用非严格相等。允许隐式的布尔值强制转换（调用 **ToBoolean()** 抽象操作）会更好。如果不能启用隐式强制转换，则只在两边都为布尔值（**true** 和 **false**）的时候使用非严格相等，其他情况应该 **改为严格相等**。

#### 总结

大多数临界情况都能通过重构代码得以避免。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
