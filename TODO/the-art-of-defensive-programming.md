> * 原文地址：[The Art of Defensive Programming](https://dev.to/0x13a/the-art-of-defensive-programming)
* 原文作者：[Diego Mariani](https://dev.to/0x13a)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# The Art of Defensive Programming  #

Why don’t developers write secure code? We’re not talking yet another time about *“clean code”* here. We’re talking about something more, on a pure practical perspective, software’s safety and security. Yes, because an insecure software is pretty much useless. Let’s see what does insecure software mean.

- The **European Space Agency’s Ariane 5 Flight 501** was destroyed 40 seconds after takeoff (June 4, 1996). The **US$1 billion** prototype rocket **self-destructed due to a bug** in the on-board guidance software.

- A **bug in the code controlling the Therac-25 radiation** therapy machine was **directly responsible for at least five patient deaths** in the 1980s when it administered excessive quantities of X-rays.

- The **software error of a MIM-104 Patriot**, caused its system clock to drift by one third of a second over a period of one hundred hours — resulting in failure to locate and intercept an incoming missile. The Iraqi missile impacted in a military compound in Dhahran, Saudi Arabia (February 25, 1991), **killing 28 Americans**.

This should be enough to understand how important is to write secure software, specially in certain contexts. But also in other use cases, we should be aware where our software bugs can lead us to.

### A first sight to Defensive Programming ###

Why do I think Defensive Programming is a good approach to issue these problems in certain kind of projects?

> Defend against the impossible, because the impossible will happen.

There are many definitions for Defensive Programming, it also depends on the level of *“security”* and level of resources you need for your software projects.

**Defensive programming** is a form of [defensive design](https://en.wikipedia.org/wiki/Defensive_design) intended to ensure the continuing function of a piece of [software](https://en.wikipedia.org/wiki/Software) under unforeseen circumstances. Defensive programming practices are often used where high availability, safety or security is needed —[ Wikipedia](https://en.wikipedia.org/wiki/Defensive_programming)*

I personally believe this approach to be suitable when you’re dealing with a big, long-lived project where many people are involved. Also for instance, with an open source project that requires a lot of extensive maintenance.

Let’s explore some of my diluted key points in order to achieve a Defensive Programming approach.

### Never trust user input ###

Assume always you’re going to receive something you don’t expect. This should be your approach as a defensive programmer, against user input, or in general things coming into your system. That’s because as we said we can expect the unexpected. Try to be as strict as possible. [Assert](https://en.wikipedia.org/wiki/Assertion_(software_development)) that your input values are what you expect.

![The best defense is a good offense](https://res.cloudinary.com/practicaldev/image/fetch/s--Pic7qAkP--/c_limit,f_auto,fl_progressive,q_auto,w_725/https://medium2.global.ssl.fastly.net/max/2000/1%2AwJBEFQ8XcNR7RzlMnTF_fw.png) 

*The best defense is a good offense*

Do whitelists not blacklists, for example when validating an image extension, don’t check for the invalid types but check for the valid types, excluding all the rest. In PHP however you also have an infinite number of open source validation libraries to make your job easier.

*The best defense is a good offense.* Be strict

### Use database abstraction ###

The first of **[OWASP Top 10 Security Vulnerabilities](https://www.veracode.com/directory/owasp-top-10)** is Injection. That means someone (a lot of people out there) is yet not using secure tools to query their databases. Please use Database Abstraction packages and libraries. In PHP you can use [PDO](http://php.net/manual/en/book.pdo.php) to [ensure basic injection protection](http://stackoverflow.com/questions/134099/are-pdo-prepared-statements-sufficient-to-prevent-sql-injection).

### Don’t reinvent the wheel ###

You don’t use a framework (or micro framework)? Well you like doing extra work for no reason, congratulations! It’s not only about frameworks, but also for new features where you could easily [use something that’s already out there, well tested, trusted by thousands of developers and stable](https://packagist.org/), rather than crafting something by yourself only for the sake of it. The only reasons why you should build something by yourself is that you need something that doesn’t exists or that exists but doesn’t fit within your needs (bad performance, missing features etc).

That’s what is used to call **intelligent code reuse**. Embrace it

### Don’t trust developers ###

Defensive programming can be related to something called **[Defensive Driving](https://en.wikipedia.org/wiki/Defensive_driving)**. In Defensive Driving we assume that everyone around us can potentially and possibly make mistakes. So we have to be careful even to others’ behavior. The same concept applies to **Defensive Programming where us, as developers shouldn’t trust others developers’ code**. We shouldn’t trust our code neither.

In big projects, where many people are involved, we can have many different ways we write and organize code. This can also lead to confusion and even more bugs. That’s because why we should enforce coding styles and mess detector to make our life easier.

### Write SOLID code ###

That’s the tough part for a (defensive) programmer, *[writing code that doesn’t suck](https://medium.com/web-engineering-vox/how-to-write-solid-code-that-doesnt-suck-2a3416623d48)*. And this is a thing many people know and talk about, but nobody really cares or put the right amount of attention and effort into it in order to achieve *SOLID code*.

Let’s see some bad examples

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

> ### Don’t: Leaking state outside class scope. ###

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

### Conclusions ###

Hope you liked the article. Remember those are just suggestions, it’s up to you to know when, where and if to apply them.


