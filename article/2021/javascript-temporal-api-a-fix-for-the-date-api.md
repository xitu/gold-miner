> * 原文地址：[JavaScript Temporal API- A Fix for the Date API](https://blog.bitsrc.io/javascript-temporal-api-a-fix-for-the-date-api-aa8381a4234c)
> * 原文作者：[Nathan Sebhastian](https://medium.com/@nathansebhastian)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/javascript-temporal-api-a-fix-for-the-date-api.md](https://github.com/xitu/gold-miner/blob/master/article/2021/javascript-temporal-api-a-fix-for-the-date-api.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[Chorer](https://github.com/Chorer)、[Usualminds](https://github.com/Usualminds)

# JavaScript Temporal API —— Date API 问题的一个解决方案

![](https://cdn-images-1.medium.com/max/2024/1*iq9Xe8BZue94e2BD4ecpqA.png)

JavaScript 的日期处理 API 比较糟糕，因为它是直接对 [Java 的 `Date` 类](https://docs.oracle.com/javase/6/docs/api/java/util/Date) 进行复制来实现了 `Date` 对象，而 Java 维护者最终弃用了许多 `Date` 类的方法，并于 1997 年创建了 `Calendar` 类以取代它。

但是 JavaScript 的 `Date` API 还没有进行进一步修复，这就是为什么我们今天会遇到以下问题：

* `Date` 对象是可变的
* 用于日期和时间计算的混乱 API（例如，天数的加减）
* 仅支持 UTC 和本地时区
* 从字符串中解析日期的不可靠
* 不支持公历以外的其他历法

但由于目前 `Date` API 被广泛地应用于各种库和浏览器引擎中，我们暂时不可能修复其错误部分。如果我们更改它的底层实现，就会很可能对许多现有的网站和库造成破坏性影响。

新的 `Temporal` API 提案旨在解决 `Date` API 的问题，它对 JavaScript 的日期和时间操作进行了以下改进：

* 仅创建和处理不可变的 `Temporal` 对象
* 用于日期和时间计算的简单 API
* 支持所有时区
* 遵循 ISO-8601 格式进行严格的日期解析
* 支持非公历的历法

> 请记住，`Temporal` 提案[当前处于第二阶段](https://github.com/tc39/proposal-temporal#status)，尚未准备好用于生产环境中。

让我们借助代码示例理解 `Temporal` API 的功能吧。下文中的所有 `Temporal` API 代码都是使用 [Temporal Polyfill](https://www.npmjs.com/package/proposal-temporal) 创建的。

## 不可变的日期对象

使用 JavaScript 的 `new Date()` 构造器创建的 `Date` 对象是可变的，意味着你可以在初始化以后修改它的值：

```js
let date = new Date("2021-02-20");
console.log(date); // 2021-02-20T00:00:00.000Z
date.setYear(2000);
console.log(date); // 2000-02-20T00:00:00.000Z
```

尽管看似无关紧要，但这种可变的对象在处理不当时可能会导致错误，其中一种情况就是当我们尝试将天数添加到当前日期时。

例如，这是一个将当前日期增加一周的功能。 由于 `setDate` 会修改对象本身，因此我们会得到**两个具有相同日期值的对象**：

```js
function addOneWeek(date) {
    date.setDate(date.getDate() + 7);
    return date;
}

let today = new Date();
let oneWeekLater = addOneWeek(today);

console.log(today);
console.log(oneWeekLater); //  值和变量 today 一样
```

`Temporal` 提供了不直接修改对象的方法，进而修复了这个问题，例如下面就是使用 `Temporal` API 添加一周的例子：

```js
const date = Temporal.now.plainDateISO();
console.log(date); // 2021-02-20
console.log(date.add({days: 7})); // 2021-02-27
console.log(date); // 2021-02-20
```

如上面的代码所示，`Temporal` 为我们提供了 `.add()` 方法，让我们能将天、周、月或年添加到当前日期对象中而不会修改原始值。

## 用于日期和时间计算的 API

前面的 `Temporal` 示例中我们了解到了 `.add()` 方法，它能帮助我们对日期对象执行计算。我们现在使用的 `Date` API 仅提供了获取和设置日期值的方法，不如 `Temporal` 来得简单直接。

`Temporal` 还为我们提供了多个 API 来计算日期值。比如说 `until()` 方法，它可以计算 `firstDate` 和 `secondDate` 之间的时间差。

而如果使用 `Date` API，我们需要手动计算两个日期之间的天数，如下所示：

```js
const oneDay = 24 * 60 * 60 * 1000;
const firstDate = new Date(2008, 1, 12);
const secondDate = new Date(2008, 1, 22);

const diffDays = Math.round(Math.abs((firstDate - secondDate) / oneDay));
console.log(diffDays); // 10
```

如果是 `Temporal` API，我们可以通过 `until()` 方法简单地计算 `diffDays`：

```js
const firstDate = Temporal.PlainDate.from('2008-01-12');
const secondDate = Temporal.PlainDate.from('2008-01-22');

const diffDays = firstDate.until(secondDate).days;
console.log(diffDays); // 10
```

其他的帮助我们计算的方法还有：

* [`.subtract()` 方法](https://tc39.es/proposal-temporal/docs/plaindate.html#subtract)，用于减少当前日期的天数、月数或年数。
* [`.since()` 方法](https://tc39.es/proposal-temporal/docs/plaindate.html#since)，用于计算一个特定日期迄今为止所经历的天数、月数或年数。
* [`.equals()` 方法](https://tc39.es/proposal-temporal/docs/plaindate.html#equals)，用于比较两个日期是否相同。

这些 API 能够帮助我们去完成计算，而无需自己创建解决方案。

## 支持所有时区

当前的 `Date` API 在系统中以 UTC 标准跟踪时间，通常会在计算机的时区中生成日期对象，操纵时区没有简单的方法。

我发现操纵时区的一种方式是使用 `Date.toLocaleString()` 方法，如下所示：

```js
let date = new Date();
let tokyoDate = date.toLocaleString("en-US", {
    timeZone: "Asia/Tokyo"
});
let singaporeDate = date.toLocaleString("en-US", {
    timeZone: "Asia/Singapore",
});

console.log(tokyoDate); // 2/21/2021, 1:36:46 PM
console.log(singaporeDate); // 2/21/2021, 12:36:46 PM
```

但是由于此方法返回一个字符串，因此进一步的日期和时间操作要求我们先将字符串转换回日期。

而 `Temporal` API 允许我们在使用 `zonedDateTimeISO()` 方法创建日期的时候去定义时区。我们可以使用 `.now` 对象去获取当前的日期、时间：

```js
let tokyoDate = Temporal.now.zonedDateTimeISO('Asia/Tokyo');
let singaporeDate = Temporal.now.zonedDateTimeISO('Asia/Singapore');

console.log(tokyoDate);
// 2021-02-20T13:48:24.435904429+09:00[Asia/Tokyo]
console.log(singaporeDate);
// 2021-02-20T12:48:24.429904404+08:00[Asia/Singapore]
```

由于返回的值仍然是 `Temporal` 日期，因此我们可以使用 `Temporal` 本身的方法进一步对其进行操作：

```js
let date = Temporal.now.zonedDateTimeISO('Asia/Tokyo');
let oneWeekLater = date.add({weeks: 1});

console.log(oneWeekLater);
// 2021-02-27T13:48:24.435904429+09:00[Asia/Tokyo]
```

`Temporal` API 遵循使用类型的约定，其中以 `Plain` 开头的名称是没有时区的（`.PlainDate`、`.PlainTime`、`.PlainDateTime`），而 `.ZonedDateTime` 则相反。

## 遵循 ISO-8601 标准进行严格的日期解析

现有的从字符串解析日期的方式是不可靠的，因为当我们传递 ISO-8601 格式的日期字符串时，返回值将根据是否传递了时区偏移量而有所不同。

考虑以下示例：

```js
new Date("2021-02-20").toISOString();
// 2021-02-20T00:00:00.000Z
new Date("2021-02-20T05:30").toISOString();
// 2021-02-20T10:30:00.000Z
```

上面的第一个 `Date` 构造器将字符串视为 UTC+0 时区，而第二个构造器将字符串视为 UTC-5 时区（我当前所在的时区），因此返回值会被调整到 UTC+0 时区**（5:30 UTC-5 相当于 10:30 UTC+0）**。

`Temposal` 提案通过区分 `PlainDateTime` 和 `ZonedDateTime` 来解决此问题，如下所示：

![来源：[临时提案文档](https://tc39.es/proposal-temporal/docs/index.html#string-persistence)](https://cdn-images-1.medium.com/max/2000/1*Y4XViVCg-Cl6KtivlWbF5A.png)

当我们想要使日期成为包含时区的对象时，我们需要使用 [ZonedDateTime](https://tc39.es/proposal-temporal/docs/index.html#Temporal-ZonedDateTime) 对象，反之则使用 [PlainDateTime](https://tc39.es/proposal-temporal/docs/index.html#Temporal-PlainDateTime) 对象。

通过分开创建包含时区和不包含时区的日期，`Temporal` API 可帮助我们从提供的字符串中解析正确的日期、时间组合：

```js
Temporal.PlainDateTime.from("2021-02-20");
// 2021-02-20T00:00:00

Temporal.PlainDateTime.from("2021-02-20T05:30");
// 2021-02-20T05:30:00

Temporal.ZonedDateTime.from("2021-02-20T05:30[Asia/Tokyo]");
// 2021-02-20T05:30:00+09:00[Asia/Tokyo]
```

从上面的示例中可以看到，`Temporal` API 不会对你所在的时区进行预设。

## 支持公历以外的历法

尽管公历是世界上使用最广泛的日历系统，但有时我们可能需要使用其他日历系统以查看具有文化或宗教意义的特殊日期。

`Temporal` API 允许我们指定要用于日期、时间计算的日历系统。

日历的 NPM Polyfill 实现尚未完成，因此我们需要尝试使用 Browser Polyfill 中的 `withCalendar()` 方法。请访问 [Temporal 文档页面](https://tc39.es/proposal-temporal/docs/)，然后将以下代码粘贴到浏览器的控制台中：

```js
Temporal.PlainDate.from("2021-02-06").withCalendar("gregory").day;
// 6

Temporal.PlainDate.from("2021-02-06").withCalendar("chinese").day;
// 25

Temporal.PlainDate.from("2021-02-06").withCalendar("japanese").day;
// 6

Temporal.PlainDate.from("2021-02-06").withCalendar("hebrew").day;
// 24

Temporal.PlainDate.from("2021-02-06").withCalendar("islamic").day;
// 24
```

一旦提案通过，[Intl.DateTimeFormat](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/DateTimeFormat/DateTimeFormat#parameters) 中所有可能的日历值都将被实现。

## 结论

`Temporal` API 是针对 JavaScript 的一项新提案，有望为该语言提供现代化的日期和时间 API。而根据我基于 Polyfill 的测试，该 API 确实提供了更简单的日期和时间操作，同时也考虑到了时区和日历的差异。

该提案本身仍处于第三阶段，因此，如果你有兴趣了解更多信息并提供反馈，你可以访问 [Temporal 文档](https://tc39.es/proposal-temporal/docs/index.html) 并尝试其提供的 [Polyfill NPM 包](https://www.npmjs.com/package/proposal-temporal)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
