> * 原文地址：[What’s new in PHP 7.4? Top 10 features that you need to know](https://medium.com/@daniel.dan/whats-new-in-php-7-4-top-10-features-that-you-need-to-know-e0acc3191f0a)
> * 原文作者：[Daniel Dan](https://medium.com/@daniel.dan)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/whats-new-in-php-7-4-top-10-features-that-you-need-to-know.md](https://github.com/xitu/gold-miner/blob/master/TODO1/whats-new-in-php-7-4-top-10-features-that-you-need-to-know.md)
> * 译者：
> * 校对者：

# What’s new in PHP 7.4? Top 10 features that you need to know

> In just 7 days, we’ll see the release of PHP 7.4. With new updates, reduced memory usage, and a significant performance increase will be achieved. Take a look at the 10 main features of PHP 7.4 in this article!

![](https://cdn-images-1.medium.com/max/2880/1*8mxvcgkYyzk_7o_e6Wp_qw.jpeg)

Why are some programming languages so popular while others are seldom used for project development and sometimes even fall into oblivion? There are plenty of reasons for that. The simplicity of syntax, functionality, development network, and community support affect the demand level for each technology.

As the world of IT is constantly developing, coding technologies have to keep pace with the changing environment by providing new features, updates, and enhancements. This is one of the most important elements of language success.

In our company, I enjoy PHP due to the frequent improvements being performed each year and believe that it will be popular for many years to come. Since the release of PHP 5 in 2004, its performance has doubled and perhaps, even tripled. This is one of the reasons why we use PHP in our [software development company](https://y-sbm.com/).

It’s no wonder that for the second year in a row, PHP is among the top 10 most popular programming languages according to [StackOverflow Developer Survey 2019](https://insights.stackoverflow.com/survey/2019#technology). This year, it took the 8th place which is one rank higher than [in the previous year](https://insights.stackoverflow.com/survey/2019#technology).

In just **7 days**, on Thursday, November 28th, we’ll see the new release of PHP — PHP 7.4, which will become one of the most feature-packed versions ever. In this article, I will list and cover the updated features overview of PHP 7.4. Let’s get started!

## What’s new in PHP 7.4? PHP features list

#### 1. Arrow functions’ support

Since anonymous functions, or closures, are mainly applied in JS, they seem to be verbose in PHP. Their implementation and maintenance procedures are also more complex.

The introduction of arrow functions’ support will enable PHP developers to dramatically clean up their code and make the syntax more concise. As a result, you will get a higher level of code readability and simplicity. Take a look at the example below.

So, if you previously had to write this piece of code:

```
function cube($n){

return ($n * $n * $n);

}

$a = [1, 2, 3, 4, 5];

$b = array_map('cube', $a);

print_r($b);
```

With PHP 7.4, you will be able to rewrite it in the following way:

```
$a = [1, 2, 3, 4, 5];

$b = array_map(fn($n) => $n * $n * $n, $a);

print_r($b);
```

Thanks to the ability to create neat, shorter code, the web development process will go faster, allowing you to save time.

#### 2. Typed properties’ support

The introduction of typed properties in the next release will likely be considered one of the most important updated PHP features. While previously there was no possibility to use declaration methods for class variables and properties (including static properties), now programmers can easily code it without creating specific getter and setter methods.

Due to declaration types (excluding void and callable), you can use nullable types, int, float, array, string, object, iterable, self, bool, and parent.

If a web developer tries to assign an irrelevant value from the type, for instance, declaring $name as string, he or she will get a TypeError message.

Like arrow functions, typed properties also let PHP engineers make their code shorter and cleaner

#### 3. Preloading

The main purpose of this cool new feature is to increase PHP 7.4 performance. Simply put, preloading is the process of loading files, frameworks, and libraries in [OPcache](https://www.php.net/manual/en/book.opcache.php) and is definitely a great addition to the new release. For example, if you use a framework, its files had to be downloaded and recompiled for each request.

When configuring OPcache, for the first time these code files participate in the request processing and then they are checked for changes each time. Preloading enables the server to load the specified code files into shared memory. It’s important to note that they will be constantly available for all subsequent requests without additional checks for file changes.

It is also noteworthy to mention that during preloading, PHP also eliminates needless includes and resolves class dependencies and links with traits, interfaces, and more.

#### 4. Covariant returns & contravariant parameters

At the moment, PHP has mostly invariant parameter types and invariant return types which presents some constraints. With the introduction of covariant (types are ordered from more specific to more generic) returns and contravariant (types are ordered from more generic to more specific) parameters, PHP developers will be able to change the parameter’s type to one of its supertypes. The returned type, in turn, can be easily replaced by its subtype.

#### 5. Weak References

In PHP 7.4, the WeakReference class allows web developers to save a link to an object that does not prevent its destruction. Don’t confuse it with the WeakRef class of the Weakref extension. Due to this feature, they can more easily implement cache-like structures.

See the example of using this class:

```
<?php

$obj = new stdClass;

$weakref = WeakReference::create($obj);

var_dump($weakref->get());

unset($obj);

var_dump($weakref->get());

?>
```

Also, note that you can’t serialize Weak References.

#### 6. Coalescing assign operator

A coalesce operator is another new feature available in PHP 7.4. It’s very helpful when you need to apply a ternary operator together with isset(). This will enable you to return the first operand if it exists and is not NULL. If not, it will just return the second operand.

Here is an example:

```
<?php

// Fetches the value of $_GET['user'] and returns 'nobody'

// if it does not exist.

$username = $_GET['user'] ?? 'nobody';

// This is equivalent to:

$username = isset($_GET['user']) ? $_GET['user'] : 'nobody';

// Coalescing can be chained: this will return the first

// defined value out of $_GET['user'], $_POST['user'], and

// 'nobody'.

$username = $_GET['user'] ?? $_POST['user'] ?? 'nobody';

?>
```

#### 7. A spread operator in array expression

PHP 7.4 will give engineers the ability to use spread operators in arrays that are faster compared to array_merge. There are two key reasons for that. First, a spread operator is considered to be a language structure and array_merge is a function. The second reason is that now your compile-time can be optimized for constant arrays. As a consequence, you will have increased PHP 7.4 performance.

Take a look at the example of argument unpacking in array expression:

```
$parts = ['apple', 'pear'];

$fruits = ['banana', 'orange', ...$parts, 'watermelon'];

var_dump($fruits);
```

Also, it will be possible to expand the same array multiple times. Furthermore, since normal elements can be added before or after the spread operator, PHP developers will be able to use its syntax in the array.

#### 8. A new custom object serialization mechanism

In the new version of PHP, two new methods become available: __serialize and __unserialize. Combining the versatility of the Serializable interface with the approach of implementing __sleep / __ wakeup methods, this serialization mechanism will allow PHP developers to avoid customization issues associated with the existing methods. Find out [more information about this PHP feature](https://wiki.php.net/rfc/custom_object_serialization).

#### 9. Reflection for references

Libraries, such as symfony/var-dumper, heavily rely on ReflectionAPI to accurately display variables. Previously, there was no proper support for reference reflection, which forced these libraries to rely on hacks to detect references. PHP 7.4 adds the ReflectionReference class which solves this problem.

#### 10. Support for throwing exceptions from __toString()

Previously there was no ability to throw exceptions from the __toString method. The reason for that is the conversion of objects to strings is performed in many functions of the standard library, and not all of them are ready to “process” exceptions correctly. As part of this RFC, a comprehensive audit of string conversions in the codebase was carried out and this restriction was removed.

## Final thoughts

In just a week, PHP 7.4 will be released. There are plenty of new PHP features that reduce memory usage and greatly increase PHP 7.4 performance. You will gain the ability to avoid some previous limitations of this programming language, write cleaner code, and create web solutions faster.

The Beta 3 version is already available for downloading and testing on dev servers. However, I wouldn’t recommend using it on your production servers and live projects. If you have questions about PHP 7.4/PHP development or just enjoyed the article, feel free to leave your comments below.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
