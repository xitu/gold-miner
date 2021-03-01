> * 原文地址：[JavaScript Temporal API- A Fix for the Date API](https://blog.bitsrc.io/javascript-temporal-api-a-fix-for-the-date-api-aa8381a4234c)
> * 原文作者：[Nathan Sebhastian](https://medium.com/@nathansebhastian)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/javascript-temporal-api-a-fix-for-the-date-api.md](https://github.com/xitu/gold-miner/blob/master/article/2021/javascript-temporal-api-a-fix-for-the-date-api.md)
> * 译者：
> * 校对者：

# JavaScript Temporal API- A Fix for the Date API

![](https://cdn-images-1.medium.com/max/2024/1*iq9Xe8BZue94e2BD4ecpqA.png)

JavaScript has a bad date handling API because the `Date` object implementation was copied directly from [Java’s `Date` Class](https://docs.oracle.com/javase/6/docs/api/java/util/Date.html). Java maintainers eventually deprecated many of `Date` class methods and created the `Calendar` Class in 1997 to replace it.

But JavaScript’s `Date` API never got a proper fix, which is why we have the following problems with it today:

* `Date` object is mutable
* Messy API for date and time computations (for example, adding and subtracting days )
* Only support UTC and the local timezone
* Parsing date from a string is unreliable
* No support for non-Gregorian calendars

Currently, there’s no way to fix the bad parts of the `Date` API because of its widespread use in libraries and browser engines. Changing the way `Date` API works will most likely break many websites and libraries out there.

The new `Temporal` API proposal is designed to solve the problems with the `Date` API. It brings the following fixes to JavaScript date/time manipulation:

* Creating and dealing only with immutable `Temporal` objects
* Straightforward API for date and time computations
* Support for all timezones
* Strict date parsing from ISO-8601 format
* Support for non-Gregorian calendars

> Please keep in mind that the Temporal proposal is [currently at stage 2](https://github.com/tc39/proposal-temporal#status), so it’s not ready for production use yet.

Let’s see how Temporal API feature works with code examples. All Temporal API code is created using the [Temporal Polyfill](https://www.npmjs.com/package/proposal-temporal).

## Immutable date objects

The `Date` object created through JavaScript’s `new Date()` construct is mutable, which means you can change the value of the object after its initialization:

```js
let date = new Date("2021-02-20");
console.log(date); // 2021-02-20T00:00:00.000Z
date.setYear(2000);
console.log(date); // 2000-02-20T00:00:00.000Z
```

Although it may seem harmless, this kind of mutable object will cause bugs when not handled properly. One case may occur when you try to add days to the current date.

For example, here’s a function that adds one week to the current date. Since `setDate` modifies the object itself, you will end up with **two objects holding the same date value**:

```js
function addOneWeek(date) {
    date.setDate(date.getDate() + 7);
    return date;
}

let today = new Date();
let oneWeekLater = addOneWeek(today);

console.log(today);
console.log(oneWeekLater); // same with today
```

`Temporal` will fix this problem by providing methods that won’t modify the object directly. For example, here’s how you can add a week using `Temporal` API:

```js
const date = Temporal.now.plainDateISO();
console.log(date); // 2021-02-20
console.log(date.add({ days: 7 })); // 2021-02-27
console.log(date); // 2021-02-20
```

As seen in the code above, `Temporal` provides you with the `.add()` method that allows you to add days, weeks, months, or years into the current date object, but the method won’t modify the original value.

## APIs for date and time computations

The previous `Temporal` example already shows you the `.add()` method, which helps you to perform computations on a date object. It’s much easier and more straightforward than the current `Date` API, which only provides you with methods to get and set your date values.

Temporal also provides you with several more APIs to compute your date values. One example is the `until()` method, which calculates the difference between the `firstDate` and the `secondDate` .

With the `Date` API, you need to calculate the number of days between two dates manually as follows:

```js
const oneDay = 24 * 60 * 60 * 1000; 
const firstDate = new Date(2008, 1, 12);
const secondDate = new Date(2008, 1, 22);

const diffDays = Math.round(Math.abs((firstDate - secondDate) / oneDay));
console.log(diffDays); // 10
```

With the `Temporal` API, you can easily calculate the `diffDays` with the `.until()` method:

```js
const firstDate = Temporal.PlainDate.from('2008-01-12');
const secondDate = Temporal.PlainDate.from('2008-01-22');

const diffDays = firstDate.until(secondDate).days;
console.log(diffDays); // 10
```

Other methods to help you perform computations include:

* The [`.subtract()` method](https://tc39.es/proposal-temporal/docs/plaindate.html#subtract) to decrement days, months, or years from your date
* The [`.since()` method](https://tc39.es/proposal-temporal/docs/plaindate.html#since) to calculate how many days, months, or years have passed since a specified date
* The [.equals() method](https://tc39.es/proposal-temporal/docs/plaindate.html#equals) to compare if two dates are the same

These APIs will help you to perform computations, so you don’t need to create your own solutions.

## Support for all timezones

The current Date API internally tracks time in UTC standard, and it generally produces date objects in the computer’s timezone. There’s no easy way for manipulating the timezone.

One option I found to manipulate the timezone is by using the `Date.toLocaleString()` method as follows:

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

But since this method returns a string, further date and time manipulation requires you to turn the string back into date first.

Temporal API allows you to define the timezone when you create a date using the `zonedDateTimeISO` method. You can get the current date/time using the `.now` object:

```js
let tokyoDate = Temporal.now.zonedDateTimeISO('Asia/Tokyo');
let singaporeDate = Temporal.now.zonedDateTimeISO('Asia/Singapore');

console.log(tokyoDate);
// 2021-02-20T13:48:24.435904429+09:00[Asia/Tokyo]
console.log(singaporeDate); 
// 2021-02-20T12:48:24.429904404+08:00[Asia/Singapore]
```

Since the value returned is still a `Temporal` date, you can further manipulate it with methods from `Temporal` itself:

```js
let date = Temporal.now.zonedDateTimeISO('Asia/Tokyo');
let oneWeekLater = date.add({weeks: 1});

console.log(oneWeekLater);
// 2021-02-27T13:48:24.435904429+09:00[Asia/Tokyo]
```

The `Temporal` API follows a convention of using types, where names that start with “Plain” doesn't have an associated timezone (`.PlainDate`, `.PlainTime`, `.PlainDateTime`) as opposed to `.ZonedDateTime`

## Strict date parsing from ISO-8601 format

The current Date parsing from a string is unreliable because when you pass a date string in ISO-8601 format, the return value will be **different** depending on whether you pass the timezone offset or not.

Consider the following example:

```js
new Date("2021-02-20").toISOString();
// 2021-02-20T00:00:00.000Z
new Date("2021-02-20T05:30").toISOString();
// 2021-02-20T10:30:00.000Z
```

The first `Date` construct above considers the string to be UTC+0 timezone, while the second construct considers the string to be UTC-5 timezone (the timezone I’m currently at) and so it adjusts the returned value to UTC+0 timezone **(5:30 UTC-5 equals 10:30 UTC+0)**

The `Temporal` proposal solves this issue by making a distinction between `PlainDateTime` and `ZonedDateTime` as follows:

![Source: [Temporal proposal doc](https://tc39.es/proposal-temporal/docs/index.html#string-persistence)](https://cdn-images-1.medium.com/max/2000/1*Y4XViVCg-Cl6KtivlWbF5A.png)

When you need the date to be timezone-aware, you need to use the [ZonedDateTime](https://tc39.es/proposal-temporal/docs/index.html#Temporal-ZonedDateTime) object. Otherwise, you can use the [PlainDateTime](https://tc39.es/proposal-temporal/docs/index.html#Temporal-PlainDateTime) object.

By separating the creation of date with and without the timezone, `Temporal` API helps you to parse the right date/time combination from the provided string:

```js
Temporal.PlainDateTime.from("2021-02-20");
// 2021-02-20T00:00:00

Temporal.PlainDateTime.from("2021-02-20T05:30");
// 2021-02-20T05:30:00

Temporal.ZonedDateTime.from("2021-02-20T05:30[Asia/Tokyo]");
// 2021-02-20T05:30:00+09:00[Asia/Tokyo]
```

As you can see from the examples above, `Temporal` API won’t make assumptions about your timezone.

## Support for non-Gregorian calendars

Although Gregorian calendar was the most used calendar system in the world, there are times when you may need to use other calendar systems to observe special dates with cultural or religious significance.

The `Temporal` API allows you to specify the calendar system you want to use with your date/time calculations.

The NPM Polyfill implementation of the calendars are not finished yet, so you need to try `withCalendar()` method from the Browser Polyfill. Visit the [Temporal documentation page](https://tc39.es/proposal-temporal/docs/) and paste the following code into your browser’s console:

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

All possible calendar values from [Intl.DateTimeFormat](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/DateTimeFormat/DateTimeFormat#parameters) are expected to be implemented when the proposal is finished.

## Conclusion

The `Temporal` API is a new proposal for JavaScript that promises to offer a modern date/time API for the language. Based on my test with the Polyfill, the API does provide easier date/time manipulation while taking the timezone and calendar differences into account.

The proposal itself is still at stage 2, so if you’re interested to learn more and provide feedback, you can visit [Temporal documentation](https://tc39.es/proposal-temporal/docs/index.html) and try out its [Polyfill NPM package](https://www.npmjs.com/package/proposal-temporal).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
