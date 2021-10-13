> * 原文地址：[What’s new in PHP 7.4? Top 10 features that you need to know](https://medium.com/@daniel.dan/whats-new-in-php-7-4-top-10-features-that-you-need-to-know-e0acc3191f0a)
> * 原文作者：[Daniel Dan](https://medium.com/@daniel.dan)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/whats-new-in-php-7-4-top-10-features-that-you-need-to-know.md](https://github.com/xitu/gold-miner/blob/master/TODO1/whats-new-in-php-7-4-top-10-features-that-you-need-to-know.md)
> * 译者：[司徒公子](https://github.com/stuchilde)
> * 校对者：[江五渣](http://jalan.space)、[suhanyujie](https://github.com/suhanyujie)

# PHP 7.4 有什么新功能？你必须掌握的 10 大特性

> 在短短 7 天之内，我们看到了 PHP 7.4 的发布。更新包括：减少内存的使用、性能显著提升。看下本文中 PHP 7.4 的 10 大主要特性。

![](https://blog-private.oss-cn-shanghai.aliyuncs.com/20191204181917.png)

为什么有些编程语言如此的流行，而其他编程语言却很少用于项目开发，有时甚至被遗忘。有很多原因，语法的简洁性、函数化程度、开发生态以及社区支持对于每项技术需求层级的影响。

随着全世界 IT 的不断发展，编码技术必须要通过提供、更新或者增强新特性来应对不断变化的环境。这也是一门编程语言成功最重要的因素之一。

在我们公司，由于每年都频繁地改进并优化性能，因此，我很喜欢 PHP，并且我相信在未来几年也会广受欢迎。自从 2004 年 PHP 5 发布以来，它的性能已经翻倍或许甚至翻了三倍，这就是为什么我们[软件开发公司](https://y-sbm.com/)会使用 PHP 语言来开发的原因之一。

毫无疑问，根据 [2019 StackOverflow 开发者调查结果](https://insights.stackoverflow.com/survey/2019#technology)，PHP 连续第二年成为十大最受欢迎的编程语言之一。今年，它排在第八位，比[去年排名](https://insights.stackoverflow.com/survey/2018#technology)高出一位。

在 7 天之后，也就是 11 月 28 日星期四，我们会看到 PHP 新版本的发布 —— PHP 7.4，它将成为有史以来功能最丰富的版本之一。这篇文章，我将列出并介绍 PHP 7.4 的更新特性概述。让我们开始吧！

## PHP 7.4 的新功能是什么？PHP 特性列表

#### 1. 箭头函数的支持

由于匿名函数或闭包主要应用于 JS 中，因此，他们在 PHP 中似乎很啰嗦，他们的实现和程序的维护也会更复杂一些。

引入对箭头函数的支持使得 PHP 开发者大大简化他们的代码并且使语法更加简洁。这样，你代码的可读性和简洁性会大大提高。看下面的例子。

因此，如果是以前的话，你必须按以下代码块写：

``` php
function cube($n){

return ($n * $n * $n);

}

$a = [1, 2, 3, 4, 5];

$b = array_map('cube', $a);

print_r($b);
```

在 PHP 7.4 发布后，你就可以按如下的方法写：

``` php
$a = [1, 2, 3, 4, 5];

$b = array_map(fn($n) => $n * $n * $n, $a);

print_r($b);
```

由于拥有了创建整齐、更短代码的能力。web 开发过程将会更快，也节省了你的时间。

#### 2. 类型化属性的支持

在下一个版本引入类型化属性可能被视为 PHP 最重要的特性更新之一。虽然之前不可能将声明方法用于类变量和属性（包括静态属性），但现在程序员能很轻松地进行编码，而无需创建特定的 getter 和 setter 方法。

由于声明类型（不包括 void 和 callable），你可以使用可为空（Nullable）类型，即 int、float、array、string、object、iterable、self、bool 和 parent。

如果一位 web 开发者尝试从类型中分配一个不相关的值，例如，声明 name 变量为字符串类型，他或她就会接收到 TypeError 的报错。

像箭头函数一样，类型化属性也能让 PHP 工程师写出更简短和清晰的代码。

#### 3. 预加载

这个很酷新特性的主要目的是提升 PHP 7.4 的性能。简而言之，预加载是在 [OPcache](https://www.php.net/manual/en/book.opcache.php) 中加载文件、框架和库的过程，绝对是新版本的最佳补充。例如，如果你使用框架，则必须为每个请求下载并重新编译其文件。

在配置 OPcache 的时候，这些代码文件首次参与请求处理，然后每次都检查它们的更改。预加载使服务器可以将指定的代码文件加载到共享内存中。请务必注意，它们将始终可用于后续所有的请求，而无需检查其他文件的改变。

还值得一提的是，在预加载期间，PHP 还消除了不必要的包含，并解决了类依赖以及具有 Traits 和 Interfaces 等的链接。

#### 4. 协变量返回和协变量参数

目前，PHP 中大多数是不变的参数类型和不变的返回类型，这带来了一些约束。随着协变量（类型从更具体到更通用）返回和协变量（类型从更通用到更具体）参数的引入，PHP 开发者们将能够将参数类型更改为超类型之一。

#### 5. 弱引用

在 PHP 7.4 中，弱引用类（WeakReference class）允许 web 开发者们将链接保存到不阻止其销毁的对象中。请勿将弱引用类和弱引用扩展混淆。由于这些特性，它们更容易实现类似缓存的结构。

请参考使用此类的示例：

``` php
<?php

$obj = new stdClass;

$weakref = WeakReference::create($obj);

var_dump($weakref->get());

unset($obj);

var_dump($weakref->get());

?>
```

另外，请注意，你无法序列化弱引用。

#### 6. 合并分配运算符

合并运算符是 PHP 7.4 提供的另一个新功能。当你需要将三元运算符和 isset 方法一起使用时非常有用。如果它存在且不为空，那么就会返回第一个操作数，否则就会返回第二个操作数。

这就是个例子：

``` php
<?php

// 获取 $_GET['user'] 的值，如果它不存在则返回 nobody

$username = $_GET['user'] ?? 'nobody';

// 这等价于：

$username = isset($_GET['user']) ? $_GET['user'] : 'nobody';

// 链式合并：将返回 $_GET['user']、$_POST['user'] 以及 noboody 中第一个不为 NULL 的值

$username = $_GET['user'] ?? $_POST['user'] ?? 'nobody';

?>
```

#### 7. 数组表达式中的展开运算符

与 array_merge 相比，在 PHP 7.4 中，工程师们能在数组中使用展开运算符。有两个主要原因，首先，展开运算符被认为是一种语言结构，而 array_merge 是一个函数，其次是针对常量数组“编译时”的优化。因此 PHP 7.4 的性能将会提升。

看一下数组表达式中的参数解压缩示例：

``` php
$parts = ['apple', 'pear'];

$fruits = ['banana', 'orange', ...$parts, 'watermelon'];

var_dump($fruits);
```

同样，它也有可能展开同一数组多次。此外，由于可以在扩展运算符的前后添加普通元素，因此 PHP 开发人员将能够在数组中使用其语法。

#### 8. 新的自定义对象序列化机制

在 PHP 新的版本中，有两种新的可用方法 __serialize 和 __unserialize。将 Serializable 接口的多功能性与实现 __sleep 和 __wakeup 方法结合起来，这种序列化机制使得 PHP 开发者可以避免与已存在的方法产生一些自定义的问题。发现[有关 PHP 特性的更多信息](https://wiki.php.net/rfc/custom_object_serialization)。

#### 9. 为引用提供的反射

类似于 symfony/var-dumper 之类的库，严重依赖 Reflection API 来准确罗列变量。原来，对于引用反射没有很好的支持，这迫使这些库只能依靠 hack 的方式来检测引用。在 PHP 7.4 中添加了 ReflectionReference 类来解决此问题。

#### 10. 支持从 __toString() 方法抛出异常

之前无法从 __toString 方法中抛出异常。原因是标准库中的许多函数都执行从对象到字符串的转化，它们当中并非所有的都准备好正确的“处理”异常。作为该 RFC 的一部分，对代码库中的字符串转换进行了全面的审核，并取消了此限制。

## 最后的思考

在短短的一周之内，PHP 7.4 将发布。有许多新的 PHP 特性会减少内存的使用并且大大提升 PHP 7.4 的性能。你将能够避免此编程语言之前的某些限制，编写更加简洁的代码，并更快地创建 web 解决方案。

Beta 3 版本已经可以下载并用于测试服务器的测试了。然而，我并不建议你在生产环境或者正在开发的项目中使用它。如果你对于 PHP 7.4 或者 PHP 开发还有疑惑，或者仅仅只是喜欢这篇文章，欢迎在下方留下你的评论。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
