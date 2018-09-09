> * 原文地址：[THE DEFINITIVE GUIDE TO JAVASCRIPT DATES](https://flaviocopes.com/javascript-dates/)
> * 原文作者：[flaviocopes.com](https://flaviocopes.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-definitive-guide-to-javascript-dates.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-definitive-guide-to-javascript-dates.md)
> * 译者：
> * 校对者：

# THE DEFINITIVE GUIDE TO JAVASCRIPT DATES

WORKING WITH DATES IN JAVASCRIPT CAN BE COMPLICATED. LEARN ALL THE QUIRKS AND HOW TO USE THEM.

![](https://flaviocopes.com/javascript-dates/banner.jpg)

## Introduction

Working with dates can be _complicated_. No matter the technology, developers do feel the pain.

![](https://flaviocopes.com/javascript-dates/Screen%20Shot%202018-07-06%20at%2007.20.58.png)

JavaScript offers us a date handling functionality through a powerful object: `Date`.

> This article does _not_ talk about [**Moment.js**](http://momentjs.com), which I believe it’s the best library out there to handle dates, and you should almost always use that when working with dates.

## The Date object

A Date object instance represents a single point in time.

Despite being named `Date`, it also handles **time**.

## Initialize the Date object

We initialize a Date object by using

```
new Date()
```

This creates a Date object pointing to the current moment in time.

Internally, dates are expressed in milliseconds since Jan 1st 1970 (UTC). This date is important because as far as computers are concerned, that’s where it all began.

You might be familiar with the UNIX timestamp: that represents the number of _seconds_ that passed since that famous date.

> Important: the UNIX timestamp reasons in seconds. JavaScript dates reason in milliseconds.

If we have a UNIX timestamp, we can instantiate a JavaScript Date object by using

```
const timestamp = 1530826365
new Date(timestamp * 1000)
```

If we pass 0 we’d get a Date object that represents the time at Jan 1st 1970 (UTC):

```
new Date(0)
```

If we pass a string rather than a number, then the Date object uses the `parse` method to determine which date you are passing. Examples:

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

There’s lots of flexibility here. You can add, or omit, the leading zero in months or days.

Be careful with the month/day position, or you might end up with the month being misinterpreted as the day.

You can also use `Date.parse`:

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

`Date.parse` will return a timestamp (in milliseconds) rather than a Date object.

You can also pass a set of ordered values that represent each part of a date: the year, the month (starting from 0), the day, the hour, the minutes, seconds and milliseconds:

```
new Date(2018, 6, 22, 7, 22, 13, 0)
new Date(2018, 6, 22)
```

The minimum should be 3 parameters, but most JavaScript engines also interpret less than these:

```
new Date(2018, 6) //Sun Jul 01 2018 00:00:00 GMT+0200 (Central European Summer Time)
new Date(2018) //Thu Jan 01 1970 01:00:02 GMT+0100 (Central European Standard Time)
```

In any of these cases, the resulting date is relative to the timezone of your computer. This means that **two different computers might output a different value for the same date object**.

JavaScript, without any information about the timezone, will consider the date as UTC, and will automatically perform a conversion to the current computer timezone.

So, summarizing, you can create a new Date object in 4 ways

*   passing **no parameters**, creates a Date object that represents “now”
*   passing a **number**, which represents the milliseconds from 1 Jan 1970 00:00 GMT
*   passing a **string**, which represents a date
*   passing a **set of parameters**, which represent the different parts of a date

## Timezones

When initializing a date you can pass a timezone, so the date is not assumed UTC and then converted to your local timezone.

You can specify a timezone by adding it in +HOURS format, or by adding the timezone name wrapped in parentheses:

```
new Date('July 22, 2018 07:22:13 +0700')
new Date('July 22, 2018 07:22:13 (CET)')
```

If you specify a wrong timezone name in the parentheses, JavaScript will default to UTC without complaining.

If you specify a wrong numeric format, JavaScript will complain with an “Invalid Date” error.

## Date conversions and formatting

Given a Date object, there are lots of methods that will generate a string from that date:

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

## The Date object getter methods

A Date object offers several methods to check its value. These all depends on the current timezone of the computer:

```
const date = new Date('July 22, 2018 07:22:13')

date.getDate() //22
date.getDay() //0 (0 means sunday, 1 means monday..)
date.getFullYear() //2018
date.getMonth() //6 (starts from 0)
date.getHours() //7
date.getMinutes() //22
date.getSeconds() //13
date.getMilliseconds() //0 (not specified)
date.getTime() //1532236933000
date.getTimezoneOffset() //-120 (will vary depending on where you are and when you check - this is CET during the summer). Returns the timezone difference expressed in minutes
```

There are equivalent UTC versions of these methods, that return the UTC value rather than the values adapted to your current timezone:

```
date.getUTCDate() //22
date.getUTCDay() //0 (0 means sunday, 1 means monday..)
date.getUTCFullYear() //2018
date.getUTCMonth() //6 (starts from 0)
date.getUTCHours() //5 (not 7 like above)
date.getUTCMinutes() //22
date.getUTCSeconds() //13
date.getUTCMilliseconds() //0 (not specified)
```

## Editing a date

A Date object offers several methods to edit a date value:

```
const date = new Date('July 22, 2018 07:22:13')

date.setDate(newValue)
date.setDay(newValue)
date.setFullYear(newValue) //note: avoid setYear(), it's deprecated
date.setMonth(newValue)
date.setHours(newValue)
date.setMinutes(newValue)
date.setSeconds(newValue)
date.setMilliseconds(newValue)
date.setTime(newValue)
date.setTimezoneOffset(newValue)
```

> `setDay` and `setMonth` start numbering from 0, so for example March is month 2.

Fun fact: those methods “overlap”, so if you, for example, set `date.setHours(48)`, it will increment the day as well.

Good to know: you can add more than one parameter to `setHours()` to also set minutes, seconds and milliseconds: `setHours(0, 0, 0, 0)` \- the same applies to `setMinutes` and `setSeconds`.

As for get_, also set_ methods have an UTC equivalent:

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

## Get the current timestamp

If you want to get the current timestamp in milliseconds, you can use the shorthand

```
Date.now()
```

instead of

```
new Date().getTime()
```

## JavaScript tries hard to work fine

Pay attention. If you overflow a month with the days count, there will be no error, and the date will go to the next month:

```
new Date(2018, 6, 40) //Thu Aug 09 2018 00:00:00 GMT+0200 (Central European Summer Time)
```

The same goes for months, hours, minutes, seconds and milliseconds.

## Format dates according to the locale

The Internationalization API, [well supported](https://caniuse.com/internationalization) in modern browsers (notable exception: UC Browser), allows you to translate dates.

It’s exposed by the `Intl` object, which also helps localizing numbers, strings and currencies.

We’re interested in `Intl.DateTimeFormat()`.

Here’s how to use it.

Format a date according to the computer default locale:

```
// "12/22/2017"
const date = new Date('July 22, 2018 07:22:13')
new Intl.DateTimeFormat().format(date) //"22/07/2018" in my locale
```

Format a date according to a different locale:

```
new Intl.DateTimeFormat('en-US').format(date) //"7/22/2018"
```

`Intl.DateTimeFormat` method takes an optional parameter that lets you customize the output. To also display hours, minutes and seconds:

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

[Here’s a reference of all the properties you can use](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/DateTimeFormat).

## Compare two dates

You can calculate the difference between two dates using `Date.getTime()`:

```
const date1 = new Date('July 10, 2018 07:22:13')
const date2 = new Date('July 22, 2018 07:22:13')
const diff = date2.getTime() - date1.getTime() //difference in milliseconds
```

In the same way you can check if two dates are equal:

```
const date1 = new Date('July 10, 2018 07:22:13')
const date2 = new Date('July 10, 2018 07:22:13')
if (date2.getTime() === date1.getTime()) {
  //dates are equal
}
```

Keep in mind that getTime() returns the number of milliseconds, so you need to factor in time in the comparison. `July 10, 2018 07:22:13` is **not** equal to new `July 10, 2018`. In this case you can use `setHours(0, 0, 0, 0)` to reset the time.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
