> * 原文地址：[THE DEFINITIVE GUIDE TO JAVASCRIPT DATES](https://flaviocopes.com/javascript-dates/)
> * 原文作者：[flaviocopes.com](https://flaviocopes.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-definitive-guide-to-javascript-dates.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-definitive-guide-to-javascript-dates.md)
> * 译者：[CoderMing](https://github.com/coderming)
> * 校对者：

# JAVASCRIPT 日期权威指南

在 JavaScript 中使用日期是很复杂的。请试着学习所有特性并学会如何使用它。

![](https://flaviocopes.com/javascript-dates/banner.jpg)

## 引言

在工作中使用日期是非常复杂的。无论开发人员的技术如何，都会感受到相当痛苦。

![](https://flaviocopes.com/javascript-dates/Screen%20Shot%202018-07-06%20at%2007.20.58.png)

JavaScript 通过一个强大的 `Date` 内建对象来提供处理日期的功能。

> 这篇文章不会讨论 [**Moment.js**](http://momentjs.com) 这个我认为是处理日期的最好的库，你应该在绝大多数场景下用它来处理日期。

## Date 对象

一个 Date 对象实例描述一个单一的时间点。

尽管其被命名为 `Date`，但其也操纵着 **具体的时间**（译者注：意为其也可以描述时分秒）。

## 初始化一个 Date 对象

我们通过以下方式初始化一个 Date 对象：

```
new Date()
```

这将会创造一个指向当前时刻的 Date 对象。

从内部来看，Date 对象是表示距离 1970年1月1日(UTC) 所过去的毫秒数。这一天（1970 年1月1日）是非常重要的，因为就计算机而言，这是一切开始的地方。

你可能比较熟悉 UNIX 时间戳：它表示距离众人皆知的那天（1970年1月1日）所过去的秒数。

> 要点：UNIX 时间戳的结果是“秒“，JavaScript 的 Date 对象的结果是”毫秒“

如果我们有一个 UNIX 时间戳，我们可以通过下面的方法类比出一个 JavaScript Date 对象：

```
const timestamp = 1530826365
new Date(timestamp * 1000)
```

如果我们传值为 0，我们将会得到一个表示 1970年1月1日的 JavaScript Date 对象：

```
new Date(0)
```

如果我们传值一个字符串而不是数字，那么Date对象将会调用 `parse` 去确定你想传入的日期。例如：

```
new Date('2018-07-22')
new Date('2018-07') //July 1st 2018, 00:00:00
new Date('2018') //Jan 1st 2018, 00:00:00
new Date('07/22/2018')
new Date('2018/07/22')
new Date('2018/7/22')
new Date('July 22, 2018')
new Date('July 22, 2018 07:22:13')
new Date('2018-07-22 07:22:13')
new Date('2018-07-22T07:22:13')
new Date('25 March 2018')
new Date('25 Mar 2018')
new Date('25 March, 2018')
new Date('March 25, 2018')
new Date('March 25 2018')
new Date('March 2018') //Mar 1st 2018, 00:00:00
new Date('2018 March') //Mar 1st 2018, 00:00:00
new Date('2018 MARCH') //Mar 1st 2018, 00:00:00
new Date('2018 march') //Mar 1st 2018, 00:00:00
```

这个方法非常灵活。你可以在月份或者日期字段添加或省略前导零。

小心月份/日期的位置，不然你或许会将月份错看成是日期。

你也可以使用 `Date.parse` 方法：

```
Date.parse('2018-07-22')
Date.parse('2018-07') //July 1st 2018, 00:00:00
Date.parse('2018') //Jan 1st 2018, 00:00:00
Date.parse('07/22/2018')
Date.parse('2018/07/22')
Date.parse('2018/7/22')
Date.parse('July 22, 2018')
Date.parse('July 22, 2018 07:22:13')
Date.parse('2018-07-22 07:22:13')
Date.parse('2018-07-22T07:22:13')
```

`Date.parse` 方法将会返回一个时间戳（以毫秒计）而不是 Date 对象。

你也可以通过设置一串有序的表示以一个日期的各个部分的数值来创建一个 Date 对象：年份，月份（从0开始），日期，小时，分钟，秒数和毫秒数：

```
new Date(2018, 6, 22, 7, 22, 13, 0)
new Date(2018, 6, 22)
```

这个方法最少需要三个参数，但是大多数 JavaScript 引擎也可以解析更少参数的情况：

```
new Date(2018, 6) //Sun Jul 01 2018 00:00:00 GMT+0200 (Central European Summer Time)
new Date(2018) //Thu Jan 01 1970 01:00:02 GMT+0100 (Central European Standard Time)
```

在上述所用的情况下，所生成的 Date 都是与你现在所在的时区相关联的。这意味着 **两个不同的电脑可能将同一个 Date 对象实例解释成不同的值。** 

JavaScript 在没有找到任何关于时区的信息时，会把时区设置成 UTC，同时也会自动地（对非当前时区的 Date 对象）进行到当前计算机时区的转换。

总结一下，你可以通过四种方式来创建一个 Date 对象：

*   **不传任何参数** ，这将创建一个指向“当前时刻”的 Date 对象
*   传递 **一个数字**，该参数将表示创建的 Date 对象距离 1970年一月一日 00:00（GMT）所过去的毫秒数
*   传递 **一个字符串**，该字符串应该是一个描述日期的字符串
*   传递 **一串参数** ，这些参数会分别描述一个 Date 对象的某一部分

## 时区

当你初始化一个 Date 对象时可以选择时区，这样做的话 Date 对象不会是默认的 UTC 时区，同时也会覆盖你所在的时区。

你可以通过添加 +HOURS 的格式，或者通过一个被圆括号包裹的时区名来描述一个时区：

```
new Date('July 22, 2018 07:22:13 +0700')
new Date('July 22, 2018 07:22:13 (CET)')
```

如果你使用时区名的方式但在圆括号中定义了一个错误的时区名，JavaScript 将会静默地将时区设置为默认的 UTC。

如果你使用 +HOURS 的方式但传入的数字格式是错误的，JavaScript 将会抛出一个 “Invalid Date” 的 Error。

## Date 转换及格式化

给定一个 Date 对象，会有许多种可以生成与该时间相关的字符串的方式。

```
const date = new Date('July 22, 2018 07:22:13')

date.toString() // "Sun Jul 22 2018 07:22:13 GMT+0200 (Central European Summer Time)"
date.toTimeString() //"07:22:13 GMT+0200 (Central European Summer Time)"
date.toUTCString() //"Sun, 22 Jul 2018 05:22:13 GMT"
date.toDateString() //"Sun Jul 22 2018"
date.toISOString() //"2018-07-22T05:22:13.000Z" (ISO 8601 format)
date.toLocaleString() //"22/07/2018, 07:22:13"
date.toLocaleTimeString()	//"07:22:13"
date.getTime() //1532236933000
date.getTime() //1532236933000
```

## Date 对象的 get（获取）方法

一个 Date 对象会提供如下方法去查看它的值。这些值会取决于你计算机所处的时区。

```
const date = new Date('July 22, 2018 07:22:13')

date.getDate() //22
date.getDay() //0 (0 表示周日, 1 表示周一..)
date.getFullYear() //2018
date.getMonth() //6 (从0开始计)
date.getHours() //7
date.getMinutes() //22
date.getSeconds() //13
date.getMilliseconds() //0 (未标明)（译者注：此处的意思为 Date 对象创建时指定毫秒值，JavaScript 默认将毫秒数设置为0）
date.getTime() //1532236933000
date.getTimezoneOffset() //-120 (将会取决于你在哪和你查看的时间 - 例子中的值表示在 CET 时区的夏天). 返回以分钟表示的时间差（译者注：此处涉及到协调世界时及夏令时）
```

这儿还有一些相似的使用 UTC 时区的方法，它们会使用 UTC 时区而不是你所在的时区。

```
date.getUTCDate() //22
date.getUTCDay() //0 (0 表示周日, 1 表示周一..)
date.getUTCFullYear() //2018
date.getUTCMonth() //6 (从0开始计)
date.getUTCHours() //5 (看吧，不是上面的结果“7”)
date.getUTCMinutes() //22
date.getUTCSeconds() //13
date.getUTCMilliseconds() //0 (未标明)
```

## 修改 Date

一个 Date 对象提供以下修改 Date 值的方法：

```
const date = new Date('July 22, 2018 07:22:13')

date.setDate(newValue)
date.setDay(newValue)
date.setFullYear(newValue) //note: 不要使用 setYear()，它已经被废弃了
date.setMonth(newValue)
date.setHours(newValue)
date.setMinutes(newValue)
date.setSeconds(newValue)
date.setMilliseconds(newValue)
date.setTime(newValue)
date.setTimezoneOffset(newValue)
```

> `setDay` 和 `setMonth` 的取值范围从 0 开始，举个例子，三月的值为 2。

一个有趣的事实是：这些方法是互相重合的，举个例子，如果你运行 `date.setHours(48)`，这也会将日期数变大。

很棒的知识点：你可以对 `setHours()` 添加超过一个参数来设置分钟，秒钟和毫秒：`setHours(0, 0, 0, 0)` ——这也适用于 `setMinutes` 和 `setSeconds`。（译者注：即 `setMinutes` 可以设置分钟，秒和毫秒， `setSeconds` 可以设置秒和毫秒）

和 get（获取）方法一样，set（修改）方法也有相同的 UTC 版本：

```
const date = new Date('July 22, 2018 07:22:13')

date.setUTCDate(newalue)
date.setUTCDay(newValue)
date.setUTCFullYear(newValue)
date.setUTCMonth(newValue)
date.setUTCHours(newValue)
date.setUTCMinutes(newValue)
date.setUTCSeconds(newValue)
date.setUTCMilliseconds(newValue)
```

## 获取正确的时间戳

如果你想获得以毫秒计的时间戳，你可以使用如下简写：

```
Date.now()
```

下面这种方式更加复杂：

```
new Date().getTime()
```

## JavaScript 费尽心思让代码工作正常

请注意。如果你定义的日期天数超过了一个月，这将不会报错，同时 Date 对象将会指向下一个月

```
new Date(2018, 6, 40) //Thu Aug 09 2018 00:00:00 GMT+0200 (Central European Summer Time)
```

这对月份，小时，分钟，秒钟，毫秒同样有效。

## 基于你的地点来格式化 Date

全球化的API，在现代化的浏览器中 [被很好地支持](https://caniuse.com/internationalization) （值得注意的例外：UC 浏览器），而这允许你去转化（世界各地的）日期。

这些方法由 `Intl` 项目公布，它同时也帮助我们本地化数字，字符串和货币。

我们对 `Intl.DateTimeFormat()`非常有兴趣。

这里说的是如何使用它：

按照电脑所在地区来格式化一个 Date 对象：

```
// "12/22/2017"
const date = new Date('July 22, 2018 07:22:13')
new Intl.DateTimeFormat().format(date) //"22/07/2018"是我所在地区的格式
```

按照不同地区来格式化一个 Date 对象：

```
new Intl.DateTimeFormat('en-US').format(date) //"7/22/2018"
```

`Intl.DateTimeFormat` 方法有一个可选的参数可以去自定义输出。下面是同时展示小时，分钟和秒数的方法：

```
const options = {
  year: 'numeric',
  month: 'numeric',
  day: 'numeric',
  hour: 'numeric',
  minute: 'numeric',
  second: 'numeric'
}

new Intl.DateTimeFormat('en-US', options).format(date) //"7/22/2018, 7:22:13 AM"
new Intl.DateTimeFormat('it-IT', options2).format(date) //"22/7/2018, 07:22:13"
```

[这里是你可用参数的参考](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/DateTimeFormat).

## 对比两个 Date 

你可以通过 `Date.getTime()`的值来比较两个 Date 对象：

```
const date1 = new Date('July 10, 2018 07:22:13')
const date2 = new Date('July 22, 2018 07:22:13')
const diff = date2.getTime() - date1.getTime() //以毫秒计的差距
```

同样的方法，你也可以去检查两个 Date 对象是否相等：

```
const date1 = new Date('July 10, 2018 07:22:13')
const date2 = new Date('July 10, 2018 07:22:13')
if (date2.getTime() === date1.getTime()) {
  // 它们相等时所执行的代码
}
```

谨记，`getTime()`方法返回以毫秒计的数字，所以你需要将当日时刻计入对照之中。 `July 10, 2018 07:22:13` **不等于** `July 10, 2018`。在这种情况下，你可以使用`setHours(0, 0, 0, 0)`来重置当日时刻。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
