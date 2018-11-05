> * 原文地址：[How to Format Dates in Python](https://stackabuse.com/how-to-format-dates-in-python/)
> * 原文作者：[Nicholas Samuel](https://stackabuse.com/how-to-format-dates-in-python/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-format-dates-in-python.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-format-dates-in-python.md)
> * 译者：
> * 校对者：

# How to Format Dates in Python

## Introduction

Python comes with a variety of useful objects that can be used out of the box. Date objects are examples of such objects. Date types are difficult to manipulate from scratch, due to the complexity of dates and times. However, Python date objects make it extremely easy to convert dates into the desirable string formats.

Date formatting is one of the most important tasks that you will face as a programmer. Different regions around the world have different ways of representing dates/times, therefore your goal as a programmer is to present the date values in a way that is readable to the users.

For example, you may need to represent a date value numerically like "02-23-2018". On the flip side, you may need to write the same date value in a longer textual format like "Feb 23, 2018". In another scenario, you may want to extract the month in string format from a numerically formated date value.

In this article, we will study different types of date objects along with their functionalities.

### The datetime Module

Python's `datetime` module, as you probably guessed, contains methods that can be used to work with date and time values. To use this module, we first import it via the `import` statement as follows:

```
import datetime
```

We can represent time values using the `time` class. The attributes for the `time` class include the hour, minute, second and microsecond.

The arguments for the `time` class are optional. Although if you don't specify any argument you will get back a time of 0, which is unlikely to be what you need most of the time.

For example, to initialize a time object with a value of 1 hour, 10 minutes, 20 seconds and 13 microseconds, we can run the following command:

```
t = datetime.time(1, 10, 20, 13)
```

To see the time, let's use the `print` function:

```
print(t)
```

**Output:**

```
01:10:20.000013
```

You may need to see either the hour, minute, second, or microsecond only, here is how you can do so:

```
print('hour:', t.hour)
```

**Output:**

```
hour: 1
```

The minutes, seconds and microseconds for the above time can be retrieved as follows:

```
print('Minutes:', t.minute)
print('Seconds:', t.second)
print('Microsecond:', t.microsecond)
```

**Output:**

```
Minutes: 10
Seconds: 20
Microseconds: 13
```

The values for the calendar date can be represented via the `date` class. The instances will have attributes for year, month, and day.

Let us call the `today` method to see today's date:

```
import datetime

today = datetime.date.today()
print(today)
```

**Output:**

```
2018-09-15
```

The code will return the date for today, therefore the output you see will depend on the day you run the above script.

Now let's call the `ctime` method to print the date in another format:

```
print('ctime:', today.ctime())
```

**Output:**

```
ctime: Sat Sep 15 00:00:00 2018
```

The `ctime` method uses a longer date-time format than the examples we saw before. This method is primarily used for converting Unix-time (the number of seconds since Jan. 1st, 1970) to a string format.

And here is how we can display the year, the month, and the day using the `date` class:

```
print('Year:', today.year)
print('Month:', today.month)
print('Day :', today.day)
```

**Output**

```
Year: 2018

Month: 9
Day : 15
```

### Converting Dates to Strings with strftime

Now that you know how to create Date and Time objects, let us learn how to format them into more readable strings.

To achieve this, we will be using the `strftime` method. This method helps us convert date objects into readable strings. It takes two parameters, as shown in the following syntax:

```
time.strftime(format, t)
```

The first parameter is the format string, while the second parameter is the time to be formatted, which is optional.

This method can also be used on a `datetime` object directly, as shown in the following example:

```
import datetime

x = datetime.datetime(2018, 9, 15)

print(x.strftime("%b %d %Y %H:%M:%S"))
```

**Output:**

```
Sep 15 2018 00:00:00
```

We have used the following character strings to format the date:

*   `%b`: Returns the first three characters of the month name. In our example, it returned "Sep"
*   `%d`: Returns day of the month, from 1 to 31. In our example, it returned "15".
*   `%Y`: Returns the year in four-digit format. In our example, it returned "2018".
*   `%H`: Returns the hour. In our example, it returned "00".
*   `%M`: Returns the minute, from 00 to 59. In our example, it returned "00".
*   `%S`: Returns the second, from 00 to 59. In our example, it returned "00".

We did not pass a time, hence the values for time are all "00". The following example shows how the time can be formatted as well:

```
import datetime

x = datetime.datetime(2018, 9, 15, 12, 45, 35)

print(x.strftime("%b %d %Y %H:%M:%S"))
```

**Output:**

```
Sep 15 2018 12:45:35
```

#### The Complete Character Code List

Other than the character strings given above, the `strftime` method takes several other directives for formatting date values:

*   `%a`: Returns the first three characters of the weekday, e.g. Wed.
*   `%A`: Returns the full name of the weekday, e.g. Wednesday.
*   `%B`: Returns the full name of the month, e.g. September.
*   `%w`: Returns the weekday as a number, from 0 to 6, with Sunday being 0.
*   `%m`: Returns the month as a number, from 01 to 12.
*   `%p`: Returns AM/PM for time.
*   `%y`: Returns the year in two-digit format, that is, without the century. For example, "18" instead of "2018".
*   `%f`: Returns microsecond from 000000 to 999999.
*   `%Z`: Returns the timezone.
*   `%z`: Returns UTC offset.
*   `%j`: Returns the number of the day in the year, from 001 to 366.
*   `%W`: Returns the week number of the year, from 00 to 53, with Monday being counted as the first day of the week.
*   `%U`: Returns the week number of the year, from 00 to 53, with Sunday counted as the first day of each week.
*   `%c`: Returns the local date and time version.
*   `%x`: Returns the local version of date.
*   `%X`: Returns the local version of time.

Consider the following example:

```
import datetime

x = datetime.datetime(2018, 9, 15)

print(x.strftime('%b/%d/%Y'))
```

**Output:**

```
Sep/15/2018
```

And here is how you can get the month only:

```
print(x.strftime('%B'))
```

**Output:**

```
September
```

Let us display the year:

```
print(x.strftime('%Y'))
```

**Output:**

```
2018
```

In this example we have used the format code `%Y`. Notice that the `Y` is in uppercase. Now write it in lowercase:

```
print(x.strftime('%y'))
```

**Output:**

```
18 
```

This time, the century has been omitted. As you can see, with these formatting codes you can represent the date-time in just about any form that you'd like.

### Converting Strings to Dates with strptime

The `strftime` method helped us convert date objects into more readable strings. The `strptime` method does the opposite, that is, it takes strings and converts them into date objects that Python can understand.

Here is the syntax for the method:

```
datetime.strptime(string, format)
```

The `string` parameter is the value in string format that we want to convert into date format. The `format` parameter is the directive specifying the format to be taken by the date after the conversion.

For example, let's say we need to convert the string "9/15/18" into a `datetime` object.

Let's first import the `datetime` module. We will use the `from` keyword in order to be able to reference the specific module functions without the dot format:

```
from datetime import datetime
```

We can then define the date in the form of a string:

```
str = '9/15/18'
```

Python will not be able to understand the above string as a datetime until we convert it to an actual `datetime` object. We can successfully do so by calling the `strptime` method.

Execute the following command to convert the string:

```
date_object = datetime.strptime(str, '%m/%d/%y')
```

Let's now call the `print` function to display the string in `datetime` format:

```
print(date_object)
```

**Output:**

```
2018-09-15 00:00:00
```

As you can see, the conversion was successful!

You can see that the forward slash "/" has been used to separate the various elements of the string. This tells the `strptime` method what format our date is in, which in our case "/" is used as a separator.

But what if the day/month/year was separated by a "-"? Here is how you'd handle that:

```
from datetime import datetime

str = '9-15-18'
date_object = datetime.strptime(str, '%m-%d-%y')

print(date_object)
```

**Output:**

```
2018-09-15 00:00:00
```

And again, thanks to the format specifier the `strptime` method was able to parse our date and convert it to a date object.

### Conclusion

In this article, we studied how to format dates in Python. We saw how the `datetime` module in Python can be used for the manipulation of date and time values. The module contains a number of classes that can be used for this purpose. For example, the `time` class is used to represent time values while the `date` class is used to represent calendar date values.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
