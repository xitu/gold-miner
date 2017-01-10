> * 原文地址：[The Art of Defensive Programming](https://dev.to/0x13a/the-art-of-defensive-programming)
* 原文作者：[Diego Mariani](https://dev.to/0x13a)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[GiggleAll](https://github.com/GiggleAll)
* 校对者：

# The Art of Defensive Programming  #

Why don’t developers write secure code? We’re not talking yet another time about *“clean code”* here. We’re talking about something more, on a pure practical perspective, software’s safety and security. Yes, because an insecure software is pretty much useless. Let’s see what does insecure software mean.

- The **European Space Agency’s Ariane 5 Flight 501** was destroyed 40 seconds after takeoff (June 4, 1996). The **US$1 billion** prototype rocket **self-destructed due to a bug** in the on-board guidance software.

- A **bug in the code controlling the Therac-25 radiation** therapy machine was **directly responsible for at least five patient deaths** in the 1980s when it administered excessive quantities of X-rays.

- The **software error of a MIM-104 Patriot**, caused its system clock to drift by one third of a second over a period of one hundred hours — resulting in failure to locate and intercept an incoming missile. The Iraqi missile impacted in a military compound in Dhahran, Saudi Arabia (February 25, 1991), **killing 28 Americans**.

This should be enough to understand how important is to write secure software, specially in certain contexts. But also in other use cases, we should be aware where our software bugs can lead us to.
# 防守式编程的艺术 #

为什么开发人员不编写安全代码？ 我们不再在这里讨论 *“干净的代码”* 。我们从一个纯粹的角度，软件的安全和安全性来讨论更多的东西。是的，因为一个不安全的软件几乎是没用的。让我们来看看不安全的软件意味着什么。

- **欧洲航天局的 Ariane 5 Flight 501** 在起飞后 40 秒（1996年6月4日）被毁。**10 亿美元的**原型火箭**由于机载指导软件中的错误**而自毁。 

- 在 20 世纪 80 年代，因为治疗机中控制 Therac-25 辐射的的代码错误，导致其施用过量的 X 射线致使至少五名患者死亡。

- MIM-104 爱国者的软件错误导致其系统时钟在 100 小时时段内偏移三分之一秒，以至于无法定位和拦截来袭导弹。伊拉克导弹袭击了沙特阿拉伯 - 达哈兰一个军事大院（ 1991 年 2 月 25 日 ），杀害了 28 名美国人。

这些例子足以让我们认识到编写安全的软件，特别是在某些情况下是多么重要。但在其他使用情况下，我们也应该知道我们软件错误会带给我们什么。
### A first sight to Defensive Programming ###

Why do I think Defensive Programming is a good approach to issue these problems in certain kind of projects?

> Defend against the impossible, because the impossible will happen.

There are many definitions for Defensive Programming, it also depends on the level of *“security”* and level of resources you need for your software projects.

**Defensive programming** is a form of [defensive design](https://en.wikipedia.org/wiki/Defensive_design) intended to ensure the continuing function of a piece of [software](https://en.wikipedia.org/wiki/Software) under unforeseen circumstances. Defensive programming practices are often used where high availability, safety or security is needed —[ Wikipedia](https://en.wikipedia.org/wiki/Defensive_programming)*

I personally believe this approach to be suitable when you’re dealing with a big, long-lived project where many people are involved. Also for instance, with an open source project that requires a lot of extensive maintenance.

Let’s explore some of my diluted key points in order to achieve a Defensive Programming approach.

### 防守式编程角度一 ###

为什么我认为防守式编程在某些项目中是一个发布这些问题的好方法？

> 防御不可能，因为不可能将可能发生。

对于防御性编程有很多定义，它还取决于**安全性**的级别和您的软件项目所需的资源级别。

**防守式编程**是一种[防守式设计](https://en.wikipedia.org/wiki/Defensive_design),旨在确保在意外的情况下[软件](https://en.wikipedia.org/wiki/Software)的持续性功能,防守式编程实践常被用在高可用性，安全或安全的地方 — [维基百科](https://en.wikipedia.org/wiki/Defensive_programming)

我个人认为这种方法适合当你处理一个大的，长期的项目，有许多人参与。 例如，对于需要大量维护的开源项目。

让我们了解一些我的浅薄的关键点，为了实现防守式编程方法。

### Never trust user input ###

Assume always you’re going to receive something you don’t expect. This should be your approach as a defensive programmer, against user input, or in general things coming into your system. That’s because as we said we can expect the unexpected. Try to be as strict as possible. [Assert](https://en.wikipedia.org/wiki/Assertion_(software_development)) that your input values are what you expect.

![The best defense is a good offense](https://res.cloudinary.com/practicaldev/image/fetch/s--Pic7qAkP--/c_limit,f_auto,fl_progressive,q_auto,w_725/https://medium2.global.ssl.fastly.net/max/2000/1%2AwJBEFQ8XcNR7RzlMnTF_fw.png) 

*The best defense is a good offense*

Do whitelists not blacklists, for example when validating an image extension, don’t check for the invalid types but check for the valid types, excluding all the rest. In PHP however you also have an infinite number of open source validation libraries to make your job easier.

*The best defense is a good offense.* Be strict

### 从不相信用户输入 ###

假设你总是会收到你意料之外的东西。这应该是你作为防守式程序员的方法，针对用户输入，或者平常进入你的系统。因为我们可以预料到意想不到的，尽量做到尽可能严格。[断言](https://en.wikipedia.org/wiki/Assertion_(software_development))你的输入值是你期望的。

![The best defense is a good offense](https://res.cloudinary.com/practicaldev/image/fetch/s--Pic7qAkP--/c_limit,f_auto,fl_progressive,q_auto,w_725/https://medium2.global.ssl.fastly.net/max/2000/1%2AwJBEFQ8XcNR7RzlMnTF_fw.png) 

*进攻就是最好的防守*

列入白名单不是黑名单，例如，当验证图像扩展名时，不检查无效的类型，但检查有效的类型，排除所有其余的类型。 在PHP中，你也有无数的开源验证库，使您的工作更容易。

*进攻就是最好的防守*要严格。

### Use database abstraction ###

The first of **[OWASP Top 10 Security Vulnerabilities](https://www.veracode.com/directory/owasp-top-10)** is Injection. That means someone (a lot of people out there) is yet not using secure tools to query their databases. Please use Database Abstraction packages and libraries. In PHP you can use [PDO](http://php.net/manual/en/book.pdo.php) to [ensure basic injection protection](http://stackoverflow.com/questions/134099/are-pdo-prepared-statements-sufficient-to-prevent-sql-injection).

### 使用数据抽象 ###

 **[OWASP 十大安全漏洞](https://www.veracode.com/directory/owasp-top-10)** 中的第一个是注入。这意味着有人（很多人在这儿）还没有使用安全工具来查询他们的数据库。请使用数据库抽象包和库。在PHP中你可以使用 [PDO](http://php.net/manual/en/book.pdo.php) 来[确保基本的注入保护](http://stackoverflow.com/questions/134099/are-pdo-prepared-statements-sufficient-to-prevent-sql-injection)。

### Don’t reinvent the wheel ###

You don’t use a framework (or micro framework)? Well you like doing extra work for no reason, congratulations! It’s not only about frameworks, but also for new features where you could easily [use something that’s already out there, well tested, trusted by thousands of developers and stable](https://packagist.org/), rather than crafting something by yourself only for the sake of it. The only reasons why you should build something by yourself is that you need something that doesn’t exists or that exists but doesn’t fit within your needs (bad performance, missing features etc).

That’s what is used to call **intelligent code reuse**. Embrace it

### 不要造轮子 ###

你不使用框架（或微框架）？ 你喜欢做额外的工作，没有理由，恭喜你！ 它不仅仅是框架，而且对于新的功能，你可以很容易地[使用已经在那里，经过测试，受到成千上万的开发人员和稳定的信任](https://packagist.org/)，而不是只因为他的缘故而亲手制作它。 你应该自己创建一个东西的唯一原因是你需要一些不存在或存在但不适合你的需要（性能不佳，缺少的功能等）。

那个（使用框架）我们称它为**智能代码重用**，它值得拥有。
### Don’t trust developers ###

Defensive programming can be related to something called **[Defensive Driving](https://en.wikipedia.org/wiki/Defensive_driving)**. In Defensive Driving we assume that everyone around us can potentially and possibly make mistakes. So we have to be careful even to others’ behavior. The same concept applies to **Defensive Programming where us, as developers shouldn’t trust others developers’ code**. We shouldn’t trust our code neither.

In big projects, where many people are involved, we can have many different ways we write and organize code. This can also lead to confusion and even more bugs. That’s because why we should enforce coding styles and mess detector to make our life easier.

### 不要信任开发人员 ###

防守式编程可以与称为**[防御性驾驶](https://en.wikipedia.org/wiki/Defensive_driving)**的东西相关。在防御驾驶中，我们假设我们周围的每个人都有可能和可能犯错误。 所以我们必须小心别人的行为。这些同样适用于**我们的防守式编程，作为开发者，我们不应该相信其他开发者**。我们也同样不应该信任我们的代码。

在大项目中，许多人参与，我们可以有许多不同的方式来编写和组织代码。 这也可能导致混乱，甚至更多的错误。 这是因为为什么我们应该实施编码风格和乱码检测器，使我们的生活更轻松。

### Write SOLID code ###

That’s the tough part for a (defensive) programmer, *[writing code that doesn’t suck](https://medium.com/web-engineering-vox/how-to-write-solid-code-that-doesnt-suck-2a3416623d48)*. And this is a thing many people know and talk about, but nobody really cares or put the right amount of attention and effort into it in order to achieve *SOLID code*.

Let’s see some bad examples

### 写SOLID代码 ###

这是对一个防守式程序员困难的地方，*[writing code that doesn’t suck](https://medium.com/web-engineering-vox/how-to-write-solid-code-that-doesnt-suck-2a3416623d48)*。这是许多人知道和谈论的事情，但没有人真正关心或投入正确的注意力和努力来实现 *SOLID代码*。

让我们来看一些不好的例子。

> ### Don’t: Uninitialized properties ###

```

<?php

class BankAccount
{
	protected $currency = null;
	public function setCurrency($currency) { ... }
	public function payTo(Account $to,$amount)
	{ 
		// sorry for this silly example
		$this->transaction->process($to,$amount,$this->currency);
	}
}

// I forgot to call $bankAccount->setCurrency('GBP');
$bankAccount->payTo($joe,100);

```

In this case we have to remember that for issuing a payment we need to call first *setCurrency*. That’s a really bad thing, a state change operation like that (issuing a payment) shouldn’t be done in two steps, using *two(n)* public methods. We can still have many methods to do the payment, but **we must have only one simple public method in order to change the status (Objects should never be in an inconsistent state)**.

In this case we made it even better, encapsulating the uninitialised property into the *Money* object.

```

<?php

class BankAccount
{
	public function payTo(Account$to,Money$money){ ... }
}

$bankAccount->payTo($joe,newMoney(100,newCurrency('GBP')));
```

Make it foolproof. **Don’t use uninitialized object properties**

> ### 不要：未初始化的属性 ###

```

<?php

class BankAccount
{
	protected $currency = null;
	public function setCurrency($currency) { ... }
	public function payTo(Account $to,$amount)
	{ 
		// sorry for this silly example
		$this->transaction->process($to,$amount,$this->currency);
	}
}

// I forgot to call $bankAccount->setCurrency('GBP');
$bankAccount->payTo($joe,100);

```

在这种情况下，我们必须记住，为了发出付款，我们需要先调用 *setCurrency *。 这是一个非常糟糕的事情，像这样的状态更改操作（发出付款）不应该使用 two（n）公共方法在两个步骤。 我们仍然可以有很多方法来付款，但是我们必须只有一个简单的公共方法，以改变状态（对象应该永远不会处于不一致的状态）。

在这种情况下，我们可以做得更好，将未初始化的属性封装到 **Money** 对象中。

```

<?php

class BankAccount
{
	public function payTo(Account$to,Money$money){ ... }
}

$bankAccount->payTo($joe,newMoney(100,newCurrency('GBP')));
```

使它万无一失。 **不要使用未初始化的对象属性**。

> ### Don’t: Leaking state outside class scope. ###

> ### 不要：类作用域之外的暴露状态。
```

<?php

class Message
{
	protected $content;
	public function setContent($content)
	{
		$this->content=$content;
	}
}

class Mailer
{
	protected $message;
	public function__construct(Message$message)
	{
		$this->message=$message;
	}
	public function sendMessage(
	{
		var_dump($this->message);
    }
}

$message = new Message();
$message->setContent("bob message");
$joeMailer = new Mailer($message);

$message->setContent("joe message");
$bobMailer = new Mailer($message);

$joeMailer->sendMessage();
$bobMailer->sendMessage();
```

In this case *Message* is passed by reference and the result will be in both cases *“joe message”*. A solution would be either cloning the message object in the Mailer constructor. But what we should always try to do is to use a (*immutable*) [value object](https://en.wikipedia.org/wiki/Value_object) instead of a plain *Message* mutable object. **Use immutable objects when you can.**

在这种情况下，**消息**通过引用传递，结果将在两种情况下都是 *“joe message”* 。 解决方案是在 Mailer 构造函数中克隆消息对象。 但是我们应该总是尝试使用一个（**不可变的**）[值对象](https://en.wikipedia.org/wiki/Value_object)去替代一个简单的 _Message_ mutable对象。**当你可以的时候使用不可变对象**。
```

<?php

class Message
{
    protected $content;
    public function __construct($content)
    {
        $this->content = $content;
    }
}

class Mailer 
{
    protected $message;
    public function __construct(Message $message)
    {
        $this->message = $message;
    }
    public function sendMessage()
    {
        var_dump($this->message);
    }
}

$joeMailer = new Mailer(new Message("bob message"));
$bobMailer = new Mailer(new Message("joe message"));

$joeMailer->sendMessage();
$bobMailer->sendMessage();
```

### Write tests ###

We still need to say that? Writing unit tests will help you adhering to common principles such as *High Cohesion, Single Responsibility, Low Coupling and right object composition*. It helps you not only testing the working small unit case but also the way you structured your object’s. Indeed you’ll clearly see when testing your small functions how many cases you need to test and how many objects you need to mock in order to achieve a 100% code coverage.

### 写测试 ###

我们还需要说些什么？ 写单元测试将帮助您遵守共同的原则，如**高聚合，单一责任，低耦合和正确的对象组合**。 它不仅帮助你测试小单元，而且也能测试你的对象的结构的方式。 事实上，你会清楚地看到，当测试你的小功能需要测试多少个单元和需要模拟多少个对象，以实现100％的代码覆盖率。
### Conclusions ###

Hope you liked the article. Remember those are just suggestions, it’s up to you to know when, where and if to apply them.

### 总结 ###

希望你喜欢这篇文章。 记住这些只是建议，这是由你知道什么时候，在哪里和如果应用他们。