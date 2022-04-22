> * 原文地址：[Using Interfaces to Write Better PHP Code](https://dev.to/ashallendesign/using-interfaces-to-write-better-php-code-391f)
> * 原文作者：[Ash Allen](https://dev.to/ashallendesign)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/using-interfaces-to-write-better-php-code.md](https://github.com/xitu/gold-miner/blob/master/article/2021/using-interfaces-to-write-better-php-code.md)
> * 译者：[kamly](https://github.com/kamly)、[jaredliw](https://github.com/jaredliw)
> * 校对者：[Adolescent0](https://github.com/Adolescent0)

# 使用接口编写更优雅的 PHP 代码

![](https://res.cloudinary.com/practicaldev/image/fetch/s--n6v5dklj--/c_imagga_scale,f_auto,fl_progressive,h_420,q_auto,w_1000/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/fn6vfrunv49pxpf8xep6.png)

## 介绍

在编程中，确保代码可读、可维护、可扩展和易于测试是很重要的。而使用接口，恰恰是我们改进代码中所有这些因素的方法之一。

### 目标读者

本文的目标读者是对 OOP （面向对象编程）概念有基本了解并在 PHP 中使用继承的开发人员。如果你知道如何在 PHP 代码中使用继承，那么你应该可以很好地理解本文。

## 什么是接口?

简而言之，接口只是对类应该做什么的描述，它们可用于确保实现该接口的任何类都将包括在其内部定义的每个公共方法。

接口 **可以**：

* 用于定义类的公共方法。
* 用于定义类的常量。

接口 **不可以**：

* 自己实例化。
* 用于定义类的私有或受保护方法。
* 用于定义类的属性。

接口是用来定义一个类应该包括的公共方法的。记住只定义方法的签名，而不需要包含方法的主体（就像通常在类中看到的方法）是很重要的。这是因为接口仅用于定义对象之间的通信，而不是像在类中那样定义通信和行为。为了说明这个问题，以下展示了一个定义了几个公共方法的接口的实例：

```php
interface DownloadableReport
{
    public function getName(): string;

    public function getHeaders(): array;

    public function getData(): array;
}
```

根据 [php.net](https://www.php.net/manual/en/language.oop5.interfaces.php) 文档我们可以知道，接口有两个主要用途：

1. 允许开发者创建不同类别的对象，这些对象可以互换使用，因为它们实现了相同的一个或多个接口。常见的例子是多个数据库访问服务、多个支付网关或不同的缓存策略。不同的实现可以互换，而不需要对使用它们的代码进行任何修改。
2. 允许函数或方法接受符合接口的参数并对其进行操作，而不关心该对象还可以做什么或它是如何实现的。这些接口通常被命名为 `Iterable`、`Cacheable`、`Renderable` 等，以描述行为的重要性。

## 在 PHP 中使用接口

接口是 OOP （面向对象编程）代码能力的重要部分。它们允许我们将代码解耦并提高可扩展性。举个例子，让我们看看下面这个类：

```php
class BlogReport
{
    public function getName(): string
    {
        return 'Blog report';
    }
}
```

如你所见，我们定义了一个类，类中有一个函数，返回字符串。通过这样做，我们定义了该方法的行为，所以我们知道 `getName()` 是如何返回字符串的。不过，假设我们在另一个类调用这个方法。另一个类不会关心这个字符串如何构建，它只关心是否返回内容。例如：让我们看看如何在另一个类调用此方法：

```php
class ReportDownloadService
{
    public function downloadPDF(BlogReport $report)
    {
        $name = $report->getName();

        // Download the file here...
    }
}
```

尽管上面的代码正常运行，但我们设想一下，现在想增加下载用户报告的功能，需要使用 `UsersReport` 类进行调用。当然，我们不能使用 `ReportDownloadService` 中的现有方法，因为我们已经强制规定只能传递 `BlogReport` 类。所以，我们必须重命名现有的方法，然后添加一个新的方法，如下所示：

```php
class ReportDownloadService
{
    public function downloadBlogReportPDF(BlogReport $report)
    {
        $name = $report->getName();

        // Download the file here...
    }

    public function downloadUsersReportPDF(UsersReport $report)
    {
        $name = $report->getName();

        // Download the file here...
    }
}
```

虽然你实际看不到它，但让我们假设上面类中的其余方法使用相同的代码来构建下载方法。我们可以将共享代码提升到方法中，但我们仍然可能有一些共享代码（译者：指的是每个函数中都会有 `$name = $report->getName();`）。除此之外，我们还将有多个进入运行几乎相同代码的类的入口点。这可能会在将来尝试扩展代码或添加测试时导致额外的工作。

例如，假设我们创建了一个新的 `AnalyticsReport`；我们现在需要向该类添加一个新的 `downloadAnalyticsReportPDF()` 方法，来看到下载过程的进度！这可能是一个使用接口的完美地方！

让我们从创建第一个接口开始：让我们将其命名为 `DownloadableReport` ，定义如下：

```php
interface DownloadableReport
{
    public function getName(): string;

    public function getHeaders(): array;

    public function getData(): array;
}
```

我们现在可以更新 `BlogReport` 和 `UsersReport` 来实现 `DownloadableReport` 接口，如下例所示。但是请注意，我故意把 `UsersReport` 代码写错，这样我就可以演示一些东西了！

```php
class BlogReport implements DownloadableReport
{
    public function getName(): string
    {
        return 'Blog report';
    }

    public function getHeaders(): array
    {
        return ['The headers go here'];
    }

    public function getData(): array
    {
        return ['The data for the report is here.'];
    }
}
```

```php
class UsersReport implements DownloadableReport
{
    public function getName()
    {
        return ['Users Report'];
    }

    public function getData(): string
    {
        return 'The data for the report is here.';
    }
}
```
但当我们尝试运行代码的时候，我们将会收到错误，原因如下：

1. 缺少 `getHeaders()` 方法.
2. `getName()` 方法不包括接口的方法签名中定义的返回类型。
3. `getData()` 方法定义了一个返回类型，但它与接口的方法签名中定义的类型不同。

因此，为了修复 `UsersReport` 使其正确实现 `DownloadableReport` 接口，我们可以将其修改为：

```php
class UsersReport implements DownloadableReport
{
    public function getName(): string
    {
        return 'Users Report';
    }

    public function getHeaders(): array
    {
       return [];
    }

    public function getData(): array
    {
        return ['The data for the report is here.'];
    }
}
```

现在我们的两个报表类都实现了相同的接口，可以这样更新我们的 `ReportDownloadService`：

```php
class ReportDownloadService
{
    public function downloadReportPDF(DownloadableReport $report)
    {
        $name = $report->getName();

        // Download the file here...
    }

}
```

我们现在可以把 `UsersReport` 或 `BlogReport` 对象传入 `downloadReportPDF` 方法中，而且不会出现任何错误。这是因为我们知道要实现报告类所需要的必要方法并且以我们期望的类型返回数据。

由于向方法传递了一个接口，而不是一个类，这使得我们可以根据方法的**作用**，而不是方法的**原理**，将 `ReportDownloadService` 和报告类松散地结合起来。

如果我们想创建一个新的 `AnalyticsReport`，我们可以让它实现相同的接口，然后这将允许我们将报告对象传递到相同的 `downloadReportPDF()` 方法中，而不需要添加任何新方法。如果你正在建立你自己的包或框架，并想让开发者有能力创建他们自己的类，这可能特别有用。你可以简单地告诉他们要实现哪个接口，然后他们就可以创建自己的新类。例如，在 [Laravel](https://laravel.com/docs/8.x/cache#adding-custom-cache-drivers) 中，我们可以通过实现 `Illuminate\Contracts\Cache\Store` 接口来创建自己的自定义缓存驱动类。

除了使用接口来改进实际的代码之外，我喜欢使用接口是因为它们起到了代码即文档的作用。例如，如果我想弄清楚一个类能做什么，不能做什么，我倾向于先看接口，然后再看使用它的类。接口能够告诉我们所有可以被调用的方法，而不需要我们过多地关心这些方法的底层实现方式是怎样的。

值得注意的是，我的那些 `Laravel` 读者朋友们，你们肯定会经常看到我交替使用 `contract` 和 `interface` 这两个词语。根据 [Laravel 文档](https://laravel.com/docs/8.x/contracts)， “`Laravel` 的合同是一组定义框架所提供的核心服务的接口”。所以，一定要记住：合同是一个接口，但接口不一定是合同。通常情况下，合同只是框架提供的一个接口。关于使用合同的更多信息，我建议大家可以阅读一下这一篇[文档](https://laravel.com/docs/8.x/contracts)，因为我认为它很好地剖析了合同究竟是什么，也对使用合同的方式与场景做了一定的叙述。

## 小结

希望通过阅读这篇文章，应该让你对什么是接口，如何在 `PHP` 中使用接口，以及使用接口的好处有了一个简单的了解。

对我的那些关注 `Laravel` 的读者朋友们，我将会在下周写一篇新文章，告诉你如何在 `Laravel` 中使用接口的桥梁模式。如果你对此感兴趣，请[订阅我的网站](https://ashallendesign.co.uk/blog)，这样你就可以及时获得我的发布通知。

我很希望能够在评论区看到这篇文章对于你们理解接口有所帮助。让我们一起继续构建令人惊叹的东西吧！🚀

非常感谢来自 [Aditya Kadam](https://www.linkedin.com/in/aditya-kadam-77a594134/) ， [Jae Toole](https://www.linkedin.com/in/jae-toole/) 和 [Hannah Tinkler](https://www.linkedin.com/in/hannah-tinkler-28783792/) 对本文的校对与优化！

更新：关于如何在 `Laravel` 中使用桥接模式的后续文章现已发布。[请查看这里！](https://ashallendesign.co.uk/blog/using-the-bridge-pattern-in-laravel)`

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
