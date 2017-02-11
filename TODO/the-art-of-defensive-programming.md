> * 原文地址：[The Art of Defensive Programming](https://dev.to/0x13a/the-art-of-defensive-programming)
* 原文作者：[Diego Mariani](https://dev.to/0x13a)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[GiggleAll](https://github.com/GiggleAll)
* 校对者：[tanglie1993](https://github.com/tanglie1993) , [fghpdf](https://github.com/fghpdf)

# 防守式编程的艺术 #

为什么开发人员不编写安全代码？ 我们不再在这里讨论 “**干净的代码**” 。我们从一个纯粹的角度，软件的安全性来讨论更多的东西。是的，因为一个不安全的软件几乎是没用的。让我们来看看不安全的软件意味着什么。

- **欧洲航天局的 Ariane 5 Flight 501** 在起飞后 40 秒（1996年6月4日）被毁。**10 亿美元的**原型火箭**由于机载导航软件中的错误**而自毁。 

- 在 20 世纪 80 年代，一个治疗机中控制 Therac-25 辐射的的代码错误，导致其施用过量的 X 射线致使至少五名患者死亡。

- MIM-104 爱国者的软件错误导致其系统时钟在 100 小时时段内偏移三分之一秒，以至于无法定位和拦截来袭导弹。伊拉克导弹袭击了沙特阿拉伯在达哈兰的一个军事大院（ 1991 年 2 月 25 日 ），杀害了 28 名美国人。

这些例子足以让我们认识到编写安全的软件，特别是在某些情况下是多么重要。在其他使用情况下，我们也应该知道我们软件错误会带给我们什么。

### 防守式编程角度一 ###

为什么我认为防守式编程在某些项目中是一个发现这些问题的好方法？

> 防御不可能，因为不可能将可能发生。

对于防御性编程有很多定义，它还取决于**安全性**的级别和您的软件项目所需的资源级别。

**防守式编程**是一种[防守式设计](https://en.wikipedia.org/wiki/Defensive_design)，旨在确保在意外的情况下[软件](https://en.wikipedia.org/wiki/Software)的持续性功能,防守式编程实践常被用在高可用性，需要安全的地方 — [维基百科](https://en.wikipedia.org/wiki/Defensive_programming)

我个人认为这种方法适合当你处理一个大的、长期的、有许多人参与的项目。 例如，需要大量维护的开源项目。

为了实现防守式编程方法，让我谈谈我个人简陋的观点。


### 从不相信用户输入 ###

假设你总是会收到你意料之外的东西。这应该是你作为防守式程序员的方法，针对用户输入，或者平常进入你的系统的各种东西。因为我们可以预料到意想不到的，尽量做到尽可能严格。[断言](https://en.wikipedia.org/wiki/Assertion_(software_development))你的输入值是你期望的。

![The best defense is a good offense](https://res.cloudinary.com/practicaldev/image/fetch/s--Pic7qAkP--/c_limit,f_auto,fl_progressive,q_auto,w_725/https://medium2.global.ssl.fastly.net/max/2000/1%2AwJBEFQ8XcNR7RzlMnTF_fw.png) 

**进攻就是最好的防守**

（将输入）列入白名单而不是把它放到黑名单中，例如，当验证图像扩展名时，不检查无效的类型，而是检查有效的类型，排除所有其余的类型。 在 PHP 中，也有无数的开源验证库来使你的工作更容易。

**进攻就是最好的防守**，控制要严格。

### 使用数据抽象 ###

 **[OWASP 十大安全漏洞](https://www.veracode.com/directory/owasp-top-10)** 中的第一个是注入。这意味着有人（很多人）还没有使用安全工具来查询他们的数据库。请使用数据库抽象包和库。在 PHP 中你可以使用 [PDO](http://php.net/manual/en/book.pdo.php) 来[确保基本的注入保护](http://stackoverflow.com/questions/134099/are-pdo-prepared-statements-sufficient-to-prevent-sql-injection)。

### 不要重复造轮子 ###

你不用框架（或微框架）？ 你就是喜欢没有理由的做额外的工作。恭喜你！只要是经过良好测试、广受信任的稳定的代码，你就可以尽管用于各种新特性（不仅是框架）的开发，而不是只因为它是已经造好的轮子的缘故而重新造轮子。你自己造轮子的唯一原因是你需要一些不存在或存在但不适合你的需求（性能不佳，缺少的功能等）。

那个（使用框架）我们称它为**智能代码重用**，它值得拥有。

### 不要信任开发人员 ###

防守式编程可以与称为**[防御性驾驶](https://en.wikipedia.org/wiki/Defensive_driving)**的东西相关。在防御驾驶中，我们假设我们周围的每个人都有可能犯错误。 所以我们必须小心别人的行为。这些同样适用于**我们的防守式编程，作为开发者，我们不应该相信其他开发者**。我们也同样不应该信任我们的代码。

在许多人参与的大项目中，我们可以有许多不同的方式来编写和组织代码。 这也可能导致混乱，甚至更多的错误。 这就是为什么我们统一编码风格和使用代码检测器会使我们的生活更加轻松。

### 写SOLID代码 ###

这是对一个防守式程序员困难的地方，**[writing code that doesn’t suck](https://medium.com/web-engineering-vox/how-to-write-solid-code-that-doesnt-suck-2a3416623d48)**。这是许多人知道和谈论的事情，但没有人真正关心或投入正确的注意力和努力来实现 **SOLID代码**。

让我们来看一些不好的例子。


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

在这种情况下，我们必须记住，为了发出付款，我们需要先调用 _setCurrency_ 。 这是一个非常糟糕的事情，像这样的状态更改操作（发出付款）不应该在两个步骤使用两个（或多个）公共方法。 我们仍然可以有很多方法来付款，但是我们必须只有一个简单的公共方法，以改变状态（对象应该永远不会处于不一致的状态）。

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


### 写测试 ###

我们还需要说些什么？ 写单元测试将帮助您遵守共同的原则，如**高聚合，单一责任，低耦合和正确的对象组合**。 它不仅帮助你测试小单元，而且也能测试你的对象的结构的方式。 事实上，你会清楚地看到，为了测试你的小功能需要测试多少个单元和你需要模拟多少个对象，以实现100％的代码覆盖率。

### 总结 ###

希望你喜欢这篇文章。 记住这些只是建议，何时、何地采纳这些建议，这取决于你。
