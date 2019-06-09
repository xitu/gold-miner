> * 原文地址：[Picking Apart Stack Overflow; What Bugs Developers The Most?](https://www.globalapptesting.com/blog/picking-apart-stackoverflow-what-bugs-developers-the-most)
> * 原文作者：[Nick Roberts](https://www.globalapptesting.com/blog/picking-apart-stackoverflow-what-bugs-developers-the-most)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/picking-apart-stackoverflow-what-bugs-developers-the-most.md](https://github.com/xitu/gold-miner/blob/master/TODO1/picking-apart-stackoverflow-what-bugs-developers-the-most.md)
> * 译者：
> * 校对者：

# Picking Apart Stack Overflow; What Bugs Developers The Most?

Stack Overflow has been swooping to the rescue of all types of developers since its founding in 2008. Since that time, developers have asked millions upon millions of different questions, within all areas of development.

But what are the **kinds** of problems developers are forced to turn to [Stack Overflow](https://www.stackoverflow.com) for?

We picked 11 of the most popular programming languages (measured by frequency of Stack Overflow tags) and ran a study looking to uncover some of the commonalities and differences within these questions.

But before we get there, let’s take a zoomed-out look at the 11 languages we’ve selected, as shown below.

[![JavaScript is the most frequently questioned language on StackOverflow overall.](https://www.globalapptesting.com/hubfs/_all_languages_bar_chart-min.png)](https://www.globalapptesting.com/hubfs/_all_languages_bar_chart-min.png)

In terms of raw volume of questions asked, JavaScript has been the most frequently asked about since Stack Overflow was founded. This is likely due to JavaScripts ubiquity amongst a huge range of different applications and services: if you work in any way with the internet, chances are you’ll need to know a bit of JavaScript.

But while JavaScript may be top **overall**, when we split the data out across time we see a new crown is needed.

[![Python will overtake JavaScript in 2019 as the most questioned language.](https://www.globalapptesting.com/hubfs/javascript_python_timeline-min.png)](https://www.globalapptesting.com/hubfs/javascript_python_timeline-min.png)

In 2011 [Harvard Business Review](https://hbr.org/2012/10/data-scientist-the-sexiest-job-of-the-21st-century) labelled Data Scientist as the “Sexiest Job of the 21st Century”. Since then, Python - one of the go-to-languages of data scientists - has been ever-growing in popularity… so much so that going into 2019 it has dethroned JavaScript as StackOverflows most questioned programming language.

(Either Python is fast becoming the most popular programming language,  or Python just has a bigger proportion of new coders compared to other languages!)

![](https://play.vidyard.com/5SPXJ1gky2WeF3gYUXKwUx.jpg)

But what **exactly** are these developers asking about? What are the most questioned frameworks, packages, functions, and methods? Which data types cause the most pain? And how different are these problems across languages?

To do this, we:

1. extracted 1,000 of the most upvoted Stack Overflow questions for each of the 11 programming languages listed above.
2. did a bit of data cleaning in Python (pandas, naturally)
3. fed these 11,000 questions total (over 96,000 individual words) into a JavaScript word cloud algorithm to give us a birds-eye-view of the general pain points that arise in different languages.

Here are the results.

### JavaScript

[![Most mentioned words for JavaScript on StackOverflow.](https://www.globalapptesting.com/hubfs/_javascript-min.png)](https://www.globalapptesting.com/hubfs/_javascript-min.png)

JavaScript has been around for 23 years; Stack Overflow for 11. And in those 11 years, “**jquery**” (center-left) was by far the most frequently questioned JavaScript framework.

### Python

[![Most mentioned words for Python on StackOverflow.](https://www.globalapptesting.com/hubfs/_python-min.png)](https://www.globalapptesting.com/hubfs/_python-min.png)

Python is actually about 6 years older than JavaScript. First appearing in 1990, [Guido van Rossum](https://gvanrossum.github.io/)’s brainchild has morphed into one the languages of choice for data scientists. Naturally, some of its most frequent pain points connect to data processing libraries: “**pandas**” (centre-left) and “**dataframe**” (center-top) being among them.

  
However, Python is a general purpose duct-tape language and gets involved in many different domains of tech, explaining the relatively frequently questioned “**django**” (center-bottom) web development framework.

### R

[![Most mentioned words for R on StackOverflow.](https://www.globalapptesting.com/hubfs/r-min.png)](https://www.globalapptesting.com/hubfs/r-min.png)

Perhaps the second language of choice for data scientists, R differs from Python in that it is almost exclusively used for that purpose. Data processing specific concepts such as “**dataframe**” (top-right), “**datatable**” (top-right) and “**matrix**” (center) seem to be causing R users some headaches.

Both Python and R have excellent data manipulation libraries, though where data **visualisation** is concerned, some argue R has an edge over Python. Having said this, the data visualisation library “**ggplot**” (center) was by far the most questioned concept in the R language.

So perhaps Python users are finding matplotlib easier to handle!

### Ruby

[![Most mentioned words for Ruby on StackOverflow.](https://www.globalapptesting.com/hubfs/_ruby-min.png)](https://www.globalapptesting.com/hubfs/_ruby-min.png)

First appearing in the mid-90s, Ruby has now found a home as the server-side framework ruby-on-“**rails**” (top-right).

### C#

[![Most mentioned words for C# on StackOverflow.](https://www.globalapptesting.com/hubfs/c-sharp-min.png)](https://www.globalapptesting.com/hubfs/c-sharp-min.png)

C# (C Sharp, 2000) was developed by Microsoft primarily for its .NET framework (“**net**”, center-right).

### C++

[![Most mentioned words for C++ on StackOverflow.](https://www.globalapptesting.com/hubfs/c++-min.png)](https://www.globalapptesting.com/hubfs/c++-min.png)

C++ (1985) has gone on to become the go-to-language for video game developers. The fundamental visual building block of 3D video games is the polygon, and the fundamental building block of the polygon is the “**vector**” (middle-right).

### Java

[![Most mentioned words for Java on StackOverflow.](https://www.globalapptesting.com/hubfs/java-min-1.png)](https://www.globalapptesting.com/hubfs/java-min.png)

Java (1995) was created as a general purpose “write-once-run-anywhere” language. It became popular during the PC boom of the late 90s and the early days of the world wide web and was the driving force behind many Windows applications.

But more recently it’s found a home in “**Android**” (middle-right) app development.

### Objective-C

[![Most mentioned words for Objective-C on StackOverflow.](https://www.globalapptesting.com/hubfs/objective-c-min.png)](https://cdn2.hubspot.net/hubfs/540930/objective-c-min.png)

The most ancient language of the ones in this study, Objective-C (1984) was the predominant language supported by Apple for the OSX operating system, and more recently, for “**iOS**” (bottom-left) apps on the “**iPhone**” (center)... that is, until the introduction of Swift.

### Swift

[![Most mentioned words for Swift on StackOverflow.](https://www.globalapptesting.com/hubfs/swift-min.png)](https://www.globalapptesting.com/hubfs/swift-min.png)

First appearing in 2014, Swift has superseded Objective-C in the Apple development sphere. Though perhaps the frequency of “**objective-c**” mentions (middle-right) in Stack Overflow questions tagged #swift represent the thousands of iOS developers looking to Stack Overflow to update their knowledge.

### PHP

[![Most mentioned words for PHP on StackOverflow.](https://www.globalapptesting.com/hubfs/php-min.png)](https://www.globalapptesting.com/hubfs/php-min.png)

PHP (1995) was designed as a server-side scripting language used for web development. It’s still used for that purpose today, and you can see evidence of this in the frequency of questions surrounding the languages “**laravel**” framework (center-left).

### SQL

[![Most mentioned words for SQL on StackOverflow.](https://www.globalapptesting.com/hubfs/sql-min.png)](https://www.globalapptesting.com/hubfs/sql-min.png)

SQL isn’t a fully featured programming language like some others in this study; it’s designed specifically for one job: data manipulation. Due to this specificity, the most common pain points for SQL are all around database access: “**sever**”, “**mysql**”, “**database**”, “**query**”, “**select**”.

* * *

Each programming language has over time been geared toward - or was even **designed** for - a particular niche within tech. R is to data science as Swift is to iOS development as C++ is to video game development. This explains some of the differences in the types of problems that arise. This explains why we see “**database**” a commonly questioned concept in SQL but not, for example, Objective-C.

Despite these obvious differences, these visualisations represent some fundamental similarities within the different domains. Base-level data types such as strings and arrays (but **not** integers, floats, or boolean values, apparently) are frequent pain points that cause developers of all stripes and creeds to turn to - keyboard-under-hand - to Stack Overflow.

And in the spirit of unity, here’s a word cloud for **all 11,000** of the questions we extracted:

[![Most mentioned words for 12,000 top questions on StackOverflow.](https://www.globalapptesting.com/hubfs/_all_langauges-min.png)](https://www.globalapptesting.com/hubfs/_all_langauges-min.png)

Google can help with some questions...

...but for everything else, there’s Stack Overflow.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
