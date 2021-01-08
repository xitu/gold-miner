> * 原文地址：[An Illustrated (and Musical) Guide to Map, Reduce, and Filter Array Methods](https://css-tricks.com/an-illustrated-and-musical-guide-to-map-reduce-and-filter-array-methods/)
> * 原文作者：[Una Kravets](https://css-tricks.com/author/unakravets/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/an-illustrated-and-musical-guide-to-map-reduce-and-filter-array-methods.md](https://github.com/xitu/gold-miner/blob/master/TODO1/an-illustrated-and-musical-guide-to-map-reduce-and-filter-array-methods.md)
> * 译者：[熊贤仁](https://github.com/FrankXiong)
> * 校对者：[Endone](https://github.com/Endone)、[Reaper622](https://github.com/Reaper622)

# 图解 Map、Reduce 和 Filter 数组方法

map、reduce 和 filter 是三个非常实用的 JavaScript 数组方法，赋予了开发者四两拨千斤的能力。我们直接进入正题，看看如何使用（并记住）这些超级好用的方法！

## Array.map()

`Array.map()` 根据传递的转换函数，更新给定数组中的每个值，并返回一个相同长度的新数组。它接受一个回调函数作为参数，用以执行转换过程。

```js
let newArray = oldArray.map((value, index, array) => {
  ...
});
```

> 一个帮助记住 map 的方法：Morph Array Piece-by-Piece（逐个改变数组）

你可以使用 map 代替 for-each 循环，来遍历并对每个值应用转换函数。这个方法适用于当你想更新数组的同时保留原始值。它不会潜在地删除任何值（filter 方法会），也不会计算出一个新的输出（就像 reduce 那样）。map 允许你逐个改变数组。一起来看一个例子：

```js
[1, 4, 6, 14, 32, 78].map(val => val * 10)
// the result is: [10, 40, 60, 140, 320, 780]
```

上面的例子中，我们使用一个初始数组（`[1, 4, 6, 14, 32, 78]`），映射每个值到它自己的十倍（`val * 10`）。结果是一个新数组，初始数组的每个值被这个等式转换：`[10, 40, 60, 140, 320, 780]`。

![本节代码图解](https://css-tricks.com/wp-content/uploads/2019/03/arrays-01.png)


## Array.filter()

当我们想要过滤数组的值到另一个数组，新数组中的每个值都通过一个特定检查，`Array.filter()` 这个快捷实用的方法就派上用场了。

类似搜索过滤器，filter 基于传递的参数来过滤出值。

举个例子，假定有个数字数组，想要过滤出大于 10 的值，可以这样写：

```js
[1, 4, 6, 14, 32, 78].filter(val => val > 10)
// the result is: [14, 32, 78]
```

如果在这个数组上使用 **map** 方法，比如在上面这个例子，会返回一个带有 `val > 10` 判断的和原始数组长度相同的数组，其中每个值都经过转换或者检查。如果原始值大于 10，会被转换为真值。就像这样：

```js
[1, 4, 6, 14, 32, 78].map(val => val > 10)
// the result is: [false, false, false, true, true, true]
```

但是 filter 方法，**只**返回真值。因此如果所有值都执行指定的检查的话，结果的长度会小于等于原始数组。

> 把 filter 想象成一个漏斗。部分混合物会从中穿过进入结果，而另一部分则会被留下并抛弃。

![本节代码图解，演示了数字从漏斗上面进去，其中小部分从下面出来，并附上手写的代码](https://css-tricks.com/wp-content/uploads/2019/03/arrays-02.png)

假设宠物训练学校有一个四只狗的小班，学校里的所有狗都会经过各种挑战，然后参加一个分级期末考试。我们用一个对象数组来表示这些狗狗：

```js
const students = [
  {
    name: "Boops",
    finalGrade: 80
  },
  {
    name: "Kitten",
    finalGrade: 45
  },
  {
    name: "Taco",
    finalGrade: 100
  },
  {
    name: "Lucy",
    finalGrade: 60
  }
]
```

如果狗狗们的期末考试成绩高于 70 分，它们会获得一个精美的证书；反之，它们就要去重修。为了知道证书打印的数量，要写一个方法来返回通过考试的狗狗。不必写循环来遍历数组的每个对象，我们可以用 `filter` 简化代码！

```js
const passingDogs = students.filter((student) => {
  return student.finalGrade >= 70
})

/*
passingDogs = [
  {
    name: "Boops",
    finalGrade: 80
  },
  {
    name: "Taco",
    finalGrade: 100
  }
]
*/
```

你也看到了，Boops 和 Taco 是好狗狗（其实所有狗都很不错），它们取得了通过课程的成就证书！利用箭头函数的隐式返回特性，一行代码就能实现。因为只有一个参数，所以可以删掉箭头函数的括号：

```js
const passingDogs = students.filter(student => student.finalGrade >= 70)

/*
passingDogs = [
  {
    name: "Boops",
    finalGrade: 80
  },
  {
    name: "Taco",
    finalGrade: 100
  }
]
*/
```

## Array.reduce()

`reduce()` 方法接受一个数组作为输入值并返回一个值。这点挺有趣的。reduce 接受一个回调函数，回调函数参数包括一个累计器（数组每一段的累加值，它会[像雪球一样增长](https://css-tricks.com/understanding-the-almighty-reducer/)），当前值，和索引。reduce 也接受一个初始值作为第二个参数：

```js
let finalVal = oldArray.reduce((accumulator, currentValue, currentIndex, array) => {
  ...
}), initalValue;
```

![本节代码图解，演示了用炖锅调制调料，并附上手写的代码](https://css-tricks.com/wp-content/uploads/2019/03/arrays-03.png)

来写一个炒菜函数和一个作料清单：

```js
// our list of ingredients in an array
const ingredients = ['wine', 'tomato', 'onion', 'mushroom']

// a cooking function
const cook = (ingredient) => {
    return `cooked ${ingredient}`
}
```

如果我们想要把这些作料做成一个调味汁（开玩笑的），用 `reduce()` 来归约！

```js
const wineReduction = ingredients.reduce((sauce, item) => {
  return sauce += cook(item) + ', '
  }, '')

// wineReduction = "cooked wine, cooked tomato, cooked onion, cooked mushroom, "
```

初始值（这个例子中的 `''`）很重要，它决定了第一个作料能够进行烹饪。这里输出的结果不太靠谱，自己炒菜时要当心。下面的例子就是我要说到的情况：

```js
const wineReduction = ingredients.reduce((sauce, item) => {
  return sauce += cook(item) + ', '
  })

// wineReduction = "winecooked tomato, cooked onion, cooked mushroom, "
```

最后，确保新字符串的末尾没有额外的空白，我们可以传递索引和数组来执行转换：

```js
const wineReduction = ingredients.reduce((sauce, item, index, array) => {
  sauce += cook(item)
  if (index < array.length - 1) {
        sauce += ', '
        }
        return sauce
  }, '')

// wineReduction = "cooked wine, cooked tomato, cooked onion, cooked mushroom"
```

可以用三目操作符、模板字符串和隐式返回，写的更简洁（一行搞定！）：

```js
const wineReduction = ingredients.reduce((sauce, item, index, array) => {
  return (index < array.length - 1) ? sauce += `${cook(item)}, ` : sauce += `${cook(item)}`
}, '')

// wineReduction = "cooked wine, cooked tomato, cooked onion, cooked mushroom"
```

> 记住这个方法的简单办法就是回想你怎么做调味汁：把多个作料归约到单个。

## 和我一起唱起来！

我想要用一首歌来结束这篇博文，给数组方法写了一个小调，来帮助你们记忆：

[Video](https://youtu.be/-_YEbB_y3Mk)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
