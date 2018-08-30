> * 原文地址：[A Quick Introduction to Functional Javascript](https://hackernoon.com/a-quick-introduction-to-functional-javascript-7e6fe520e7fa)
> * 原文作者：[Angelos Chalaris](https://hackernoon.com/@chalarangelo?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-quick-introduction-to-functional-javascript.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-quick-introduction-to-functional-javascript.md)
> * 译者：
> * 校对者：

# 函数式 JavaScript 快速入门

**函数式编程**是目前最热门的趋势之一，有很多好的论点解释了人们为什么想在代码中使用它。我并不打算在这里详细介绍所有函数式编程的概念和想法，而是会尽力给你演示在日常情况下和 **JavaScript** 打交道的时候如何用上这种编程。

![](https://cdn-images-1.medium.com/max/2000/1*w91eh65v6nxTs2AhLhyRNA.jpeg)

> 函数式编程是一种编程范例，它将计算机运算视为数学上的函数计算，并且避免了状态的改变和易变的数据。

#### 重新定义函数

在深入接触 JavaScript 的函数式编程范例之前，咱们得先知道什么是 **高阶函数**、它的用途以及这个定义本身究竟有什么含义。高阶函数既可以把函数当成参数来接收，也可以作为把函数作为结果输出。你应该要记住 **函数其实是值**，也就是说你可以像传递变量一样去传递函数。

所以呢，在 JavaScript 里其实你可以这么做：

```
// 创建函数
function f(x){
  return x * x;
}
// 调用该函数
f(5); // 25

// 创建匿名函数
// 并赋值一个变量
var g = function(x){
  return x * x;
}
// 传递函数
var h = g;
// And use it
h(5); // 25
```

把函数当成值来使用

一旦使用上面这个技巧，你的代码更容易被重复利用，同时功能也更加强大。咱们都经历过这样的情况：想要把一个函数传到另一个函数里去执行任务，但需要写一些额外的代码来实现这一点，对吧？使用函数式编程的话，你将不再需要写额外的代码，并且可以使你的代码变得很干净、易于理解。

* [**为什么函数式编程很重要**：在面试软件工程师的时候测试泛函编程为何会对你的企业有好处](https://hackernoon.com/why-functional-programming-matters-c647f56a7691)

有一点要注意，正确的泛函代码的特点是**没有副作用**，也就是说函数的输入只应依赖于它们的参数，并且不应该使用或者改变任何函数之外的环境。这个特点有重要的含义，举个例子：如果传递进函数的参数相同，那么输出的结果也总是相同的；如果一个被调用的函数所输出的结果并没有被用到，那么这个结果即使被删掉也不会影响别的代码。

* * *

#### 使用数组原型的内置方法

`[Array.prototype](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/prototype)` 应该是你学习 JavaScript 函数式编程的第一步，它涵盖了很多**数组转化**的使用方法，这些方法在现代网页应用里相当的常见。

* [**Array.prototype**: Array.prototype 属性表示数组构造函数的原型，并允许你添加新属性……](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/prototype)

先来看看这个叫 `[Array.prototype.sort()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/sort)` 的方法会很不错，因为这个转化挺直白的。顾名思义，咱可以用这个方法来**给数组排序**。`.sort()` 只接收一个参数(即一个用于比较两个元素的函数）。如果第一个元素在第二个元素的前面，结果返回的是小于零的值。反之，则返回大于零的值。

排序听起来非常简单，然而当你需要给比一般数字数组复杂得多的数组排序时，可能就不那么简单了。在下面这个例子里，我们有一个对象的数组，其体重以磅（**lbs**）或千克（**kg**）为单位，咱们需要对这些人的体重进行升序排列。代码看起来会是这样：

```
// 咱们这个比较函数的定义
var sortByWeight = function(x,y){
  var xW = x.measurement == "kg" ? x.weight : x.weight * 0.453592;
  var yW = y.measurement == "kg" ? y.weight : y.weight * 0.453592;
  return xW > yW ? 1 : -1;
}

// 两组数据有细微差别
// 要根据体重来对它们进行排序
var firstList = [
  { name: "John", weight: 220, measurement: "lbs" },
  { name: "Kate", weight: 58, measurement: "kg" },
  { name: "Mike", weight: 137, measurement: "lbs" },
  { name: "Sophie", weight: 66, measurement: "kg" },
];
var secondList = [
  { name: "Margaret", weight: 161, measurement: "lbs", age: 51 },
  { name: "Bill", weight: 76, measurement: "kg", age: 62 },
  { name: "Jonathan", weight: 72, measurement: "kg", age: 43 },
  { name: "Richard", weight: 74, measurement: "kg", age: 29 },
];

// 用开头定义的函数
// 对两组数据进行排序
firstList.sort(sortByWeight); // Kate, Mike, Sophie, John 
secondList.sort(sortByWeight); // Jonathan, Margaret, Richard, Bill
```

用函数式编程来对两个数组进行排序的例子

在上面的例子里，你可以很清楚地观察到使用高阶函数带来的好处：节省了空间、时间，也让你的代码更能被读懂、更容易被重复利用。如果你不打算用 `.sort()` 来写的话，你得另外写两个循环并重复大部分的逻辑。坦率来说，那样将导致更冗长、臃肿且不易理解的代码。

* * *

通常你对数组的操作也不单只是排序而已。就我的经验而言，根据属性来**过滤一个数组**很常见，而且没有什么方法比 `[Array.prototype.filter()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/filter)` 更加合适。过滤数组并不困难，因为你只需将一个函数作为参数，对于那些需要被过滤掉的元素，该函数会返回 `false`。反之，该函数会返回 `true`。很简单，不是吗？咱们来看看实例：

```
// 一群人的数组
var myFriends = [
  { name: "John", gender: "male" },
  { name: "Kate", gender: "female" },
  { name: "Mike", gender: "male" },
  { name: "Sophie", gender: "female" },
  { name: "Richard", gender: "male" },
  { name: "Keith", gender: "male" }
];

// 基于性别的简易过滤器
var isMale = function(x){
  return x.gender == "male";
}

myFriends.filter(isMale); // John, Mike, Richard, Keith
```

关于过滤的一个简单例子

虽然 `.filter()` 会返回数组中所有符合条件的元素，你也可以用 `[Array.prototype.find()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/find)` 提取数组中第一个符合条件的元素，或是用 `[Array.prototype.findIndex()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/findIndex)` 来提取数组中第一个匹配到的元素索引。同理，你可以使用 `[Array.prototype.some()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/some)` 来测试是否至少有一个元素符合条件，抑或是用 `[Array.prototype.every()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/every)` 来检查是否所有的元素都符合条件。这些方法在某些应用中可以变得相当使用，所以咱们来看一个囊括了这几种方法的例子：

```
// 一组关于分数的数组
// 不是每一项都标注了人名
var highScores = [
  {score: 237, name: "Jim"},
  {score: 108, name: "Kit"},
  {score: 91, name: "Rob"},
  {score: 0},
  {score: 0}
];

// 这些简单且能重复使用的函数
// 是用来查看每一项是否有名字
// 以及分数是否为正数
var hasName = function(x){
  return typeof x['name'] !== 'undefined';
}
var hasNotName = function(x){
  return !hasName(x);
}
var nonZeroHighScore = function(x){
  return x.score != 0;
}

// 填充空白的名字，直到所有空白的名字都有“---”
while (!highScores.every(hasName)){
  var highScore = highScores.find(hasNotName);
  highScore.name = "---";
  var highScoreIndex = highScores.findIndex(hasNotName);
  highScores[highScoreIndex] = highScore;
}

// 检查非零的分数是否存在
// 并在 console 里输出
if (highScores.some(nonZeroHighScore))
  console.log(highScores.filter(nonZeroHighScore));
else 
  console.log("No non-zero high scores!");
```

使用函数式编程来构造数据

到这一步，你应该会有些融会贯通的感觉了。上面的例子清楚地体现出高阶函数是如何使你避免了大量重复且难以理解的代码。这个例子虽然简单，但你也能看出代码的简洁之处，与你在未使用函数式编程范例时所编写的内容形成鲜明对比。

* * *

先撇开上面例子里复杂的逻辑，咱们有的时候只想要**将数组转化成另一个数组**，且无需对数组里的数据做那么多的改变。这个时候 `[Array.prototype.map()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/map)` 就派上用场了，我们可以用这个方法来转化数组中的对象。`.map()`和之前例子所用到的方法并不相同，区别在于其作为参数的高阶函数会返回一个对象，可以是任何你想写的对象。让我用一个简单的例子来演示一下：

```
// 一个有 4 个对象的数组
var myFriends = [
  { name: "John", surname: "Smith", age: 52},  
  { name: "Sarah", surname: "Smith", age: 49},  
  { name: "Michael", surname: "Jones", age: 46},  
  { name: "Garry", surname: "Thomas", age: 48}
];

// 一个简单的函数
// 用来把名和姓放在一起
var fullName = function(x){
  return x.name + " " + x.surname;
}

myFriends.map(fullName);
// 应输出
// ["John Smith", "Sarah Smith", "Michael Jones", "Garry Thomas"]
```

对数组里的对象进行 mapping 操作

从上面这个例子可以看出，一旦对数组使用了 `.map()` 方法，很容易就能得到一个仅包含咱们所需属性的数组。在这个例子里，咱只想要对象中 `name` 和 `surname` 这两行文本，所以才使用简单的 mapping（译者注：即使用 map 方法） 来利用原来包含很多对象的数组上创建了另一个只包含文本的数组。Mapping 这种方式可能比你想象的还要常用，它在每个网页开发者的口袋中可以成为很强大的工具。所以说，这整篇文章里你如果别的没记住的话，没关系，但千万要记住如何使用 `.map()`。

* * *

最后还有一点非常值得你注意，那就是**常规目的数组转化**中的 `[Array.prototype.reduce()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/reduce)`。`.reduce()` 与上面提到的所有方法都有所不同，因为它的参数不仅仅是一个高阶函数，还包含一个**累加器**。一开始听起来可能有些令人困惑，所以先看一个例子来帮助你理解 `.reduce()` 背后的基础概念吧：

```
// 关于不同公司支出的数组
var oldExpenses = [
  { company: "BigCompany Co.", value: 1200.10},
  { company: "Pineapple Inc.", value: 3107.02},
  { company: "Office Supplies Inc.", value: 266.97}
];
var newExpenses = [
  { company: "Office Supplies Inc.", value: 108.11},
  { company: "Megasoft Co.", value: 1208.99}
];

// 简单的求和函数
var sumValues = function(sum, x){
  return sum + x.value;
}

// 将第一个数组降为几个数值之和
var oldExpensesSum = oldExpenses.reduce(sumValues, 0.0);
// 将第二个数组降为几个数值之和
console.log(newExpenses.reduce(sumValues, oldExpensesSum)); // 5891.19
```

将数组降为和值

对于任何曾经把数组中的值求和的人来说，理解上面这个例子应该不会特别困难。一开始咱们定义了一个可重复使用的高阶函数，用于把数组中的 value 都加起来。之后，咱们用这个函数来给第一个数组中的支出数值求和，并把求出来的值当成初始值，而不是从零开始地去累加第二个数组中的支出数值。所以最后得出的是两个数组的支出数值总和。

* [**Reduce (编写软件)**：注意：这是关于学习函数式编程和编写软件的“Composing Software”系列的一部分……](https://medium.com/javascript-scene/reduce-composing-software-fe22f0c39a1d)

当然了，`.reduce()` 可以做的事情远不止在数组中求和而已。大多数别的方法解决不了的**复杂转化**，都可以使用 `.reduce()` 与一个数组或对象的累加器来轻松解决。一个实用的例子是转化一个有很多篇文章的数组，每一篇文章有一个标题和一些标签。原来的数组会被转化成标签的数组，每一项中有使用该标签的文章数目以及这些文章的标题构成的数组。咱们来看看代码：

```
// 一个带有标签的文章的数组
var articles = [
  {title: "Introduction to Javascript Scope", tags: [ "Javascript", "Variables", "Scope"]},
  {title: "Javascript Closures", tags: [ "Javascript", "Variables", "Closures"]},
  {title: "A Guide to PWAs", tags: [ "Javascript", "PWA"]},
  {title: "Javascript Functional Programming Examples", tags: [ "Javascript", "Functional", "Function"]},
  {title: "Why Javascript Closures are Important", tags: [ "Javascript", "Variables", "Closures"]},
];

// 一个能够将文章数组降为标签数组的函数
// 
var tagView = function(accumulator, x){
  // 针对文章的标签数组（原数组）里的每一个标签
  x.tags.forEach(function(currentTag){
    // 写一个函数看看标签是否匹配
    var findCurrentTag = function(y) { return y.tag == currentTag; };
    // 检查是否该标签已经出现在累积器数组
    if (accumulator.some(findCurrentTag)){
      // 找到标签并获得索引
      var existingTag = accumulator.find(findCurrentTag);
      var existingTagIndex = accumulator.findIndex(findCurrentTag);
      // 更新使用该标签的文章数目，以及文章标题的列表
      accumulator[existingTagIndex].count += 1;
      accumulator[existingTagIndex].articles.push(x.title);
    }
    // 否则就在累积器数组中增添标签
    else {
      accumulator.push({tag: currentTag, count: 1, articles: [x.title]});
    }
  });
  // 返回累积器数组
  return accumulator;
}

// 转化原数组
articles.reduce(tagView,[]);
// 输出:
/*
[
 {tag: "Javascript", count: 5, articles: [
    "Introduction to Javascript Scope", 
    "Javascript Closures",
    "A Guide to PWAs", 
    "Javascript Functional Programming Examples",
    "Why Javascript Closures are Important"
 ]},
 {tag: "Variables", count: 3, articles: [
    "Introduction to Javascript Scope", 
    "Javascript Closures",
    "Why Javascript Closures are Important"
 ]},
 {tag: "Scope", count: 1, articles: [ 
    "Introduction to Javascript Scope" 
 ]},
 {tag: "Closures", count: 2, articles: [
    "Javascript Closures",
    "Why Javascript Closures are Important"
 ]},
 {tag: "PWA", count: 1, articles: [
    "A Guide to PWAs"
 ]},
 {tag: "Functional", count: 1, articles: [
    "Javascript Functional Programming Examples"
 ]},
 {tag: "Function", count: 1, articles: [
    "Javascript Functional Programming Examples"
 ]}
]
*/
```

使用 reduce（）来进行一项复杂的转化

上面这个例子可能看起来会有些小复杂，所以需要一步一步来研究。首先呢，咱想要的最终结果是一个数组，所以累加器的初始值就成了`[]`。然后，咱想要数组中的每一个对象都包含标签名、使用该标签的文章数目以及文章标题的列表。不但如此，每一个标签在数组中只能出现一次，所以咱必须用 `.some()`、`.find()` 和 `.findIndex()` 来检查标签是否存在，之后将现有标签的对象进行转化，而不是另加一个新的对象。

棘手的地方在于，咱不能定义一个函数来检查每个标签是否都存在（否则需要 7 个不同的函数）。所以咱们才在当前标签的循环里定义高阶函数，这样一来就可以再次使用高阶函数，避免重写代码。对了，其实这也可以通过 Currying 来完成，但我不会在本文中解释这个技巧。

* [**现实中的 Currying**： 当我开始学习函数式编程时，我学到了很多有趣的概念……](https://hackernoon.com/currying-in-the-real-world-b9627d74a554)

当咱们在累加器数组中获取标签的对象之后，只需要把使用该标签的文章数目递增，并且将当前标签下的文章添加到其文章数组中就行了。最后，咱们返回累加器，大功告成。仔细阅读的话会发现代码不但非常简短，而且很容易理解。相同情况下，非函数式编程的代码将会看起来非常令人困惑，而且明显会更冗杂。

#### 结语

函数式编程作为目前最热门的趋势之一，是有其充分原因的。它使咱们在写出更清晰、更精简和更“吝啬”代码的同时，不必去担心副作用和状态的改变。JavaScript 的`[Array.prototype](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/prototype)`  方法在许多日常情况下非常实用，并且让咱们在对数组进行简单和复杂的转化，也不必去写太多重复的代码。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
