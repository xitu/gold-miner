> * 原文地址：[Using Interfaces to Write Better PHP Code](https://dev.to/ashallendesign/using-interfaces-to-write-better-php-code-391f)
> * 原文作者：[Ash Allen](https://dev.to/ashallendesign)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/using-interfaces-to-write-better-php-code.md](https://github.com/xitu/gold-miner/blob/master/article/2021/using-interfaces-to-write-better-php-code.md)
> * 译者：
> * 校对者：

# Using Interfaces to Write Better PHP Code

![](https://res.cloudinary.com/practicaldev/image/fetch/s--n6v5dklj--/c_imagga_scale,f_auto,fl_progressive,h_420,q_auto,w_1000/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/fn6vfrunv49pxpf8xep6.png)

## Introduction

In programming, it's important to make sure that your code is readable, maintainable, extendable and easily testable. One of the ways that we can improve all of these factors in our code is by using interfaces.

### Intended Audience

This article is aimed at developers who have a basic understanding of OOP (object oriented programming) concepts and using inheritance in PHP. If you know how to use inheritance in your PHP code, this article should hopefully be understandable.

## What Are Interfaces?

In basic terms, interfaces are just descriptions of what a class should do. They can be used to ensure that any class implementing the interface will include each public method that is defined inside it.

Interfaces **can** be:

* Used to define public methods for a class.
* Used to define constants for a class.

Interfaces **cannot** be:

* Instantiated on their own.
* Used to define private or protected methods for a class.
* Used to define properties for a class.

Interfaces are used to define the public methods that a class should include. It's important to remember that only the method signatures are defined and that they don't include the method body (like you would typically see in a method in a class). This is because the interfaces are only used to define the communication between objects, rather than defining the communication and behaviour like in a class. To give this a bit of context, this example shows an example interface that defines several public methods:

```php
interface DownloadableReport
{
    public function getName(): string;

    public function getHeaders(): array;

    public function getData(): array;
}
```

According to [php.net](https://www.php.net/manual/en/language.oop5.interfaces.php), interfaces serve two main purposes:

1. To allow developers to create objects of different classes that may be used interchangeably because they implement the same interface or interfaces. A common example is multiple database access services, multiple payment gateways, or different caching strategies. Different implementations may be swapped out without requiring any changes to the code that uses them.
2. To allow a function or method to accept and operate on a parameter that conforms to an interface, while not caring what else the object may do or how it is implemented. These interfaces are often named like Iterable, Cacheable, Renderable, or so on to describe the significance of the behavior.

## Using Interfaces in PHP

Interfaces can be an invaluable part of OOP (object oriented programming) codebases. They allow us to decouple our code and improve extendability. To give a example of this, let's take a look at this class below:

```php
class BlogReport
{
    public function getName(): string
    {
        return 'Blog report';
    }
}
```

As you can see, we have defined a class with a method that returns a string. By doing this, we have defined the behaviour of the method so we can see how `getName()` is building up the string that is returned. However, let's say that we call this method in our code inside another class. The other class won't care how the string was built up, it will just care that it was returned. For example, let's look at how we could call this method in another class:

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

Although the code above works, let's imagine that we now wanted to add the functionality to download a users report that's wrapped inside a `UsersReport` class. Of couse, we can't use the existing method in our `ReportDownloadService` because we have enforced that only a `BlogReport` class can be passed. So, we'll have to rename the existing method and then add a new method, like below:

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

Although you can't actually see it, let's assume that the rest of the methods in the class above use identical code to build the download. We could lift the shared code into methods but we will still likely have some shared code. As well as this, we're going to have multiple points of entry into the class that runs near-identical code. This can potentially lead to extra work in the future when trying to extend the code or add tests.

For example, let's imagine that we create a new `AnalyticsReport`; we'd now need to add a new `downloadAnalyticsReportPDF()` method to the class. You can likely see how this file could start growing quickly. This could be a perfect place to use an interface!

Let's start by creating one; we'll call it `DownloadableReport` and define it like so:

```php
interface DownloadableReport
{
    public function getName(): string;

    public function getHeaders(): array;

    public function getData(): array;
}
```

We can now update the `BlogReport` and `UsersReport` to implement the `DownloadableReport` interface like seen in the example below. But please note, I have purposely written the code for the `UsersReport` wrong so that I can demonstrate something!

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

If we were to try and run our code, we would get errors for the following reasons:

1. The `getHeaders()` method is missing.
2. The `getName()` method doesn't include the return type that is defined in the interface's method signature.
3. The `getData()` method defines a return type, but it isn't the same as the one defined in the interface's method signature.

So, to update the `UsersReport` so that it correctly implements the `DownloadableReport` interface, we could change it to the following:

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

Now that we have both of our report classes implementing the same interface, we can update our `ReportDownloadService` like so:

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

We could now pass in a `UsersReport` or `BlogReport` object into the `downloadReportPDF()` method without any errors. This is because we now know that the necessary methods needed on the report classes exist and return data in the type that we expect.

As a result of passing in an interface to the method rather than a class, this has allowed us to loosely-couple the `ReportDownloadService` and the report classes based on **what** the methods do, rather than **how** they do it.

If we wanted to create a new `AnalyticsReport`, we could make it implement the same interface and then this would allow us to pass the report object into the same `downloadReportPDF()` method without needing to add any new methods. This can be particularly useful if you are building your own package or framework and want to give the developer the ability to create their own class. You can simply tell them which interface to implement and they can then create their own new class. For example, in [Laravel](https://laravel.com/docs/8.x/cache#adding-custom-cache-drivers), you can create your own custom cache driver class by implementing the `Illuminate\Contracts\Cache\Store` interface.

As well as using interfaces to improve the actual code, I tend to like interfaces because they act as code-as-documentation. For example, if I'm trying to figure out what a class can and can't do, I tend to look at the interface first before a class that is using it. It tells you all of the methods that be called without me needing to care too much about how the methods are running under the hood.

It's worth noting for any of my Laravel developer readers that you'll quite often see the terms "contract" and "interface" used interchangeably. According to the [Laravel documentation](https://laravel.com/docs/8.x/contracts), "Laravel's contracts are a set of interfaces that define the core services provided by the framework". So, it's important to remember that a contract is an interface, but an interface isn't necessarily a contract. Usually, a contract is just an interface that is provided by the framework. For more information on using the contracts, I'd recommend giving the [documentation](https://laravel.com/docs/8.x/contracts) a read as I think it does a good job of breaking down what they are, how to use them and when to use them.

## Conclusion

Hopefully, through reading this article, it should have given you a brief overview of what interfaces are, how they can be used in PHP, and the benefits of using them.

For any of my Laravel developer readers, I will be writing a new blog post for next week that will show you how to use the bridge pattern in Laravel using interfaces. If you're interested in this, feel free to [subscribe to my newsletter on my website](https://ashallendesign.co.uk/blog) so that you can get notified when I release it.

I'd love to hear in the comments if this article has helped with your understanding of interfaces. Keep on building awesome stuff! 🚀

Massive thanks for [Aditya Kadam](https://www.linkedin.com/in/aditya-kadam-77a594134/), [Jae Toole](https://www.linkedin.com/in/jae-toole/) and [Hannah Tinkler](https://www.linkedin.com/in/hannah-tinkler-28783792/) for proof-reading this post and helping me improve it!

UPDATE: The follow-up post about how to use the bridge pattern in Laravel has now been published. [Check it out here!](https://ashallendesign.co.uk/blog/using-the-bridge-pattern-in-laravel)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
