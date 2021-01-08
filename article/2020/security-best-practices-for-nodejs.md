> * 原文地址：[Security Best Practices for Node.js](https://blog.appsignal.com/2020/08/12/security-best-practices-for-nodejs.html)
> * 原文作者：[Diogo Souza](https://twitter.com/diogosouzac)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/security-best-practices-for-nodejs.md](https://github.com/xitu/gold-miner/blob/master/article/2020/security-best-practices-for-nodejs.md)
> * 译者：
> * 校对者：

#Security Best Practices for Node.js
# Nodejs 安全编程的最佳实践

Because a lot of systems are connected to the web these days (or, at least, communicate/integrate with it at some level), companies are giving more and more attention to web security.
由于越来越多的系统与web相连，或者至少在某种程度上和web交互，因此互联网企业给予web安全更多的重视。

Web security usually comes to public attention when certain events reach the news, for example, security leakages, hacker activities, and/or data-stealing over big companies, some of them really large (like Google, LinkedIn, etc.).
web安全通常只有在某些新闻出现的时候才会来到大家的视野，比如说，安全泄露问题、黑客活动或者是大公司的数据泄露问题，有些数据窃取问题的规模真的非常大，像是 Google或者LinkdIn的数据窃取事件。

Apart from that showbiz world of giant players that most of us are probably not working for, implementing security on your systems is not only important but impressively underestimated or even forgotten by many devs.
除去那些我们大部分人都不为之工作的娱乐巨头们，在系统上实现安全措施不仅重要，而且被严重低估，甚至被许多开发者遗忘。

Setup, best practices, performance, testing, and metrics are probably things that you consider in your daily programming life. However, unfortunately, that’s not the same for security best practices.
安装、用最好的方法实现、关注性能、测试、度量很可能是你认为你的编程生涯中每天都在做的事情。然而，很不幸，这不等同于安全编程最佳实践。

And it’s not due to warnings. If you work in the open-source universe, within GitHub’s protective arms, chances are that you’ve faced some of its [alerts](https://docs.github.com/en/github/managing-security-vulnerabilities/about-alerts-for-vulnerable-dependencies) for vulnerable dependencies. The code community platform is becoming increasingly good – as well as worried – at detecting vulnerabilities in thousands of different libs across many different languages.
这并不是危言耸听。如果你的工作是开源的，那么在Github的保护机制之下，你有可能会看到一些有缺陷的依赖的提示。Github代码平台变得越来越擅长-也越来越令人担心-在横跨众多语言的数千个依赖库中进行漏洞的探测。

Today, it’s way more accessible for small and medium companies to afford security tools (or perhaps whole platforms) to assist their developers with the gaps in their code and apps.
今天，对于中小企业来说，将它们的开发者的代码整合成为app的可负担的安全工具或者是整个平台越来越容易得到。

Nevertheless, whether you use or don’t use such security platforms, understanding and being aware of the security threats that your apps may suffer from and fighting against them through simple (but powerful) best practices is the main goal of this article.
不仅如此，无论你是否使用这些安全平台，帮助你理解并意识到这些你的应用可能遭受的安全威胁并且通过这些简单但强大的最佳实践来消除这些威胁时这篇文章的主要目的。

Actually, we’ll pick Node.js as the analysis guinea pig, but many of the items here perfectly align with other platforms as well.
事实上，虽然我们将Node.js选择作为实验对象，但是文中提到的很多概念都同样适用于其他平台。

As a matter of reference, the [OWASP](https://owasp.org/) (**Open Web Application Security Project**) will guide us through its [Top Ten](https://owasp.org/www-project-top-ten/) most critical security risks for web applications, in general. It is a consensus board created out of the analysis of its broad list of members. Let’s face it under the light of Node then.
通常，OWASP将会作为参考手册，通过其中的前十个web应用面临的最关键的安全威胁来引导我们。

## Injection Attacks
## 注入攻击

One of the most famous threats to web applications relates to the possibility of an attacker sending pieces of SQL to your back-end code.
web应用面临的一个最著名的安全威胁与攻击者有可能把一段sql代码发送到后端。

It usually happens when developers concatenate important SQL statements directly into their database layers, like so:
这通常发生在开发者直接将重要的sql语句和数据库层相连的情况下，像这样：

```js
// "id" comes directly from the request's params
// "id" 直接来自于已请求参数
db.query('select * from MyTable where id = ' + id);
   .then((users) => {
     // return the users into the response
   });
```

If the developer didn’t sanitize the input parameters arriving within the request, an attacker could pass more than a single integer id, like an SQL instruction that could retrieve sensitive information or even delete it (not to mention the importance of proper backup policies here).
如果开发者没有对请求中携带的输入参数做校验，那么攻击者可以不仅仅只传一个整数ID，还可以传一个能够查询敏感信息甚至删除它的sql注入语句。（此处再次展示了合理备份策略的重要性）

Most of the programming languages, and their respective ORM frameworks, provide ways to avoid SQL injection usually by parameterizing inputs into query statements that, before executing directly into the database, will be validated by the inner logic of your language libs machinery.
大多数的编程语言和他们各自的对象关系映射框架都提供了避免sql注入的方法。这些方法通常是通过将直接在数据库中执行的查询语句的输入进行参数化。这一参数化的过程由编程语言可执行库中的内部逻辑完成。

In this case, it’s very important to know your language/framework closely in order to learn how they do this.
这种情况下，详细了解你的语言/框架来学习它们是怎么做到这一点的就非常重要。

If you make use of [Sequelize](https://sequelize.org/), for example, a simple way to do it would be:
比方说，如果你使用sequeluze来做这件事，那么一个简单的方法如下：

```js
const { QueryTypes } = require('sequelize');

await sequelize.query(
  'select * from MyTable where id = :p1',
  {
    replacements: { p1: id }, // id comes from the request's param
    type: QueryTypes.SELECT
  }
);
```

## Authentication Pitfalls
## 身份验证失误

Authentication is usually a part of the system that requires a lot of attention, especially if you make use of frameworks or tools that easily allow developers to expose sensitive user’s information.
身份认证通常是一个系统中非常值得关注的一部分。在使用了开发者很轻易就能暴露敏感用户信息的框架或者工具的情况下，身份认证尤其值得关注。

OWASP considers this item critical. Standards like [OAuth](https://oauth.net/) (on its 2nd version now, working on the [3rd](https://oauth.net/3/)) are constantly evolving in an attempt to embrace as much as possible the many different realities of the web world.
OWASP认为身份认证很关键。像OAuth这样的标准（以第二版为准，第三版正在筹备中）一直以来都尝试尽可能多的考虑现实生活中的各种不同情况来确保身份验证是有效的。（？）

Its implementation can be tricky, depending on your project’s scenarios or on how your company decides to customize the standard usage.
它的实现很难以捉摸，取决于项目的业务场景或者是你的公司决定如何制定标准。

If your team (and company) can afford to add big – and therefore, mature – players like [Auth0](https://auth0.com/), [Amazon Cognito](https://aws.amazon.com/cognito/), and [many others](https://stackshare.io/auth0/alternatives) in the market to your projects, that would be halfway there.
如果你的团队或公司能够为项目购买大而成熟的安全服务，类似Auth0,Amazon Cognito 或者是其他许多，那么会有事半功倍的效果

When it comes to [implementing OAuth2](https://blog.logrocket.com/implementing-oauth-2-0-in-node-js/) in Node.js, there’s plenty of compliant and open source options that can help you with not starting from scratch. Like the famous [node-oauth2-server](https://github.com/oauthjs/node-oauth2-server) module.
当你想要在nodejs的项目中实现OAuth2协议时，有很多开源和成熟的第三方库可供选择从而使你避免从头开始，就像是著名的node-oauth2-server模块。

Make sure to always refer to the official docs of whatever module or framework you’re adding to your projects (whether it’s open source or paid). Plus, when adding security to your auth flows, never go with small and recent open-source projects (it’s too much of a critical part of the app to take that kind of risk).
确保经常参考您所选用的模块或者框架的官方文档，无论它们是开源或者付费的。另外，当在认证过程中添加安全模块时，不要选用近期刚出现的小的开源项目。（很多app的重要组成部分都承担这种风险）

## Sensitive Data Exposure
## 敏感信息泄露

It’s important to define what sensitive data is. Depending on the type of project, it can vary. However, regardless of the app nature, things like credit card and document ids will always be sensitive, for sure.
在这里，定义什么样的数据是敏感的很重要。这一定义随项目的类型而变化。然而，无论app的目的是要做什么，信用卡信息或者个人证件信息之类的信息一定总是敏感的。

How is that information going to transit over to your system? Is it encrypted? No? Really?
这样的信息如何传播到系统之外呢？是被窃取了嘛？（待考虑）

After you’ve separated what’s “**really important**” from the rest, it’s time to decide what needs to be stored, and for how long.
在你区分清楚真正重要的东西和其他部分之后，现在该决定什么需要存储，以及存储多长时间。

You’d be amazed at the number of apps out there that store sensitive information for no further use, or worse, without the user’s consent. That can easily break the laws of data privacy which, by the way, are different depending on the country your app is running on (another thing to worry about).
你会惊讶于这个世界上有数不清的app存储了无用的敏感信息，或者更糟糕，存储未经用户同意获取的敏感信息。这种行为有可能违背app使用当地国家的法律。

Let’s go to the to-do (**aka** must-to) list:

* Encrypt your sensitive data. Forget about MD5, your data deserves to be strongly protected under the right algorithms. So go for [Scrypt](https://www.npmjs.com/package/scrypt).
* 加密敏感信息。MD5不够强大，你的数据应该有更强大的算法来加密，参见[]
* Warn your users about how your application deals with sensitive info. You can periodically mail them with explaining infographics, pop up some informative modals when logging in, and yes, your terms of use must state this too.
* 提醒用户app需要获取一部分敏感信息。你应该阶段性的发邮件给用户告知有关信息图标的东西，当用户登录的时候推送一些信息模型，当然，你对于信息的使用必须获得法律授权。
* Go for HTTPS. Period. Google won’t like you nowadays if you’re not.
* 选择使用HTTPS。如果不使用，Google可能未来不兼容你。
* If you can, go a bit further and do [HSTS](https://en.wikipedia.org/wiki/HTTP_Strict_Transport_Security). It is a policy mechanism that enhances your web security against the famous [man-in-the-middle](https://en.wikipedia.org/wiki/Man-in-the-middle_attack) attacks.
* 如果你可以更深入一点，进行HSTS。 HSTS是一个允许你的web应用抵御中间人攻击的机制/协议。

Setting HSTS in a Node app is as easy as:
nodejs应用中设置hsts像下面这样简单：

```js
const hsts = require('hsts');

app.use(hsts({
  maxAge: 15552000  // 180 days in seconds
}));
```

You can fine-tune your settings by defining, for example, if subdomains should be included or not:
你可以通过定义中的配置项仔细调试设置，比如，你可以配置是否包含子域名：

```js
app.use(hsts({
  maxAge: 15552000,
  includeSubDomains: false
}));
```

You’ll need, obviously, the [hsts](https://www.npmjs.com/package/hsts) npm package. Make sure to refer to its [official docs](https://helmetjs.github.io/docs/hsts/) for more info.
很明显，你首先需要下载hsts的npm第三方库。请确保你经常查阅官方文档。

## Old XML External Entities (XXE)
## XML外部实体注入

[XXE attacks](https://owasp.org/www-community/vulnerabilities/XML_External_Entity_(XXE)_Processing) occur by exploring the vulnerabilities that older XML processors have, in which they allow attackers to specify external entities and send them to applications that parse XML inputs.
XXE外部实体注入发生在旧的XML处理器中，在这样的处理器中，攻击者可以指定外部实体并将它们送到解析xml输入的应用中。

If the parser is weakly configured, the attacker could have access to sensitive information, confidential data like passwords in a server, among others.
如果解析器的配置不够强大，攻击者就能够窃取类似服务器密码之类的敏感数据。

Consider, as an example, an XML-based Web Service that receives the following XML content as input:
举个例子，想象一下一个基于xml的web服务接收如下的xml内容作为输入：

```
<?xml version="1.0" encoding="ISO-8859-1"?>
   <id>1</id>
   <name>attacker@email.com</name>
   ...
</xml>
```

At first sight, it looks just like all the other inputs you’ve seen so far. However, if your app that’s hosted on a server is not prepared to deal with attacks, something like this could be sent over:
第一眼，这个输入就像你见过的其他输入一样平常。然而，如果你的app部署在一个没有处理这种攻击的服务器上，就可能会发生下面的情况：

```
<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE foo \[
  <!ELEMENT foo ANY >
  <!ENTITY xxe SYSTEM "file:///c:/boot.ini" >\]>
    <id>1</id>
    <name>attacker@email.com</name>
    ...
  <foo>&xxe;</foo>
</xml>
```

And this would return in the response the **boot.ini** file content.
这将在响应中返回 **boot.ini** 文件的内容。

Another good example is if your app deals with uploading files. If, for example, you restrict it to only accepting some group of files, then XML-based formats like DOCX or the famous SVG for images could be accepted and carry on malicious code as well.
另一个好例子是当你的app处理文件上传任务的情况。例如，如果你限制仅仅可以接收某些类型的文件，那么基于xml格式的文档，例如docx或者著名的svg格式的图片可以被接收，恶意代码同样也可以运行。

The easiest way to prevent such attacks is by disabling your library’s parsing features. The [node-libxml](https://www.npmjs.com/package/node-libxml) npm package, for instance, provides a bunch of functions to validate your DTD and helps you secure your apps against these attacks.
最简单的阻止这种攻击的方法就是禁用第三方库的解析特性。例如node-libxml第三方库，就提供了一系列方法来确认文件类型定义并且帮助你的app免于遭受这种攻击。

## Broken Access Control
## 访问控制中断

This item is mostly related to how well-tested an application has been when it comes to user permissions to different areas (or URLs) of it.
这一问题很大程度上取决于这个应用在测试的时候有没有从不同的域或者是url测试用户权限。

In other words, if you’re supposed to have restricted areas on the application, like an admin dashboard, for example, and ordinary users without a proper role can access it anyway, then you have an access vulnerability.
换句话说，当你的应用中有受限访问的部分，比如说管理员面板，这种普通用户无权访问的页面，你就会有访问漏洞。

It is easily correctable and doesn’t require any specific solution, you can go with whatever you’re using already. The only point is the attention to implement it correctly and cover it with proper tests that guarantee the coverage over new endpoints as well.
这种漏洞不需要特别纠正，并且不需要任何特别的解决方案，你可以继续使用自己已经使用的代码。唯一需要注意的就是正确的实现权限控制并且用合适的测试流程测试到他来保证测试同样覆盖到了新的端点。

Node provides plenty of libraries to help with that, as well as middleware to check for the current user’s permissions and you can also implement one on your own.
node提供了一系列库来辅助这个工作，以及提供了一系列中间件来检查当前用户的权限。你同样也可以自己实现这些机制。

## Security Misconfiguration
## 安全配置项错误

It’s common, in the early stages of an app’s life, to define three major environments (development – or stage, QA, and production) and leave the settings equal among them.
在开发一个项目的早期，开发者需要定义开发环境、测试环境和生产环境，并且将这三个环境的设置定义成相同的。

This type of misconfiguration sometimes goes on for ages without being noticed and can lead to critical attacks, since the app is vulnerable considering that staging and QA configurations are weakly protected most of the time.
这种错误的配置可能持续存在很长时间都没有人注意，并且有可能导致严重的袭击事件。考虑到测试环境和生产环境的配置通常只提供了极弱的保护，所以这个应用是易受伤害的。

When we talk about configurations, make sure to associate them to all types of dependencies (databases, external integrations, APIs, gateways, etc.).
当我们谈论配置的时候，请确保我们讨论的是所有类型的依赖项（数据库，外部集成工具，API，网关等等）

It’s fundamental to have well-defined setups, distinct and separated from each other. Also, consider storing your credentials (and sensitive setting’s data) in remote places apart from the project files.
拥有定义完善的配置是很基础的，这样的配置通常域彼此之间不同且独立。通常，我们也会将证书或者敏感信息与项目文件分开存储到一个远程站点。

The cultural aspects of your company may take place here as well. If you use [Splunk](https://www.splunk.com/), for example, or any other logging tool, make sure to have policies (and ways to check that) that force the devs to not log sensitive data since Splunk can be way more easily accessed than the database that stores the same data.
在这个问题上，您的公司使用什么样的技术栈也是有影响的。例如，如果你使用splunk 或者其他日志工具，那么请确保设置了不允许生产环境打印敏感信息的配置或检测这种行为的方法，因为相比起来存储了同样数据的数据库，splunk是更容易接触到的。

That reminds me of a time in a company in which the main database’s password went up to a public GitHub repo due to a developer that “innocently” copied one of the company’s repo to study at home. And don’t get me wrong… I’m not saying that the biggest error was his; it was not.

## The Notorious XSS

XSS is a notorious rebel. Even though it’s insanely famous, everyday rush can easily make you forget about it.

The problem here resembles SQL injection. You have an endpoint in your web app that receives a request and returns a response. Not a big deal. However, it becomes one when you concatenate the request data with the response without sanitizing it.

A classic example would be:

```js
app.get('/users', (req, res) => {
  const user = db.getUserById(req.query.id);
  if (!user) {
    return res.send('<span>Sorry, the user "' + req.query.product + '" was not found!</span>');
  }
  ...
});
```

Guess what’s going to happen when the client sends a request with the following **id** param:

```html
<script>alert(Uh la la, it's me! XSS!!)</script> 
```

For now, it’s just an innocent alert message, but we all know that an attacker would put a bit more of JavaScript code in there.

Node’s [full of options](https://openbase.io/packages/top-nodejs-xss-libraries) to address this issue by simply adding a new middleware. Pick one, implement it properly, and move on.

## Insecure Deserialization

This breach takes place mostly when applications accept serialized objects from untrusted sources that could be tampered with by attackers.

Imagine, for example, that your Node web app communicates with the client and returns after the user has logged in, a serialized object to be persisted in a cookie that will work as the user’s session, storing data like the user id and permissions.

An attacker could then change the cookie object and give an admin role to himself, for example.

Here’s where terms like [CSRF](https://github.com/pillarjs/understanding-csrf) (**Cross-site Request Forgery**) pop up. Basically, the server app generates a token (known as CSRF token) and sends it to the client in every request to be saved in a form’s hidden input.

Every time the form is submitted it sends the token along and the server can check if it has changed or is absent. If that happens, the server will reject the request. In order to get this token, the attacker would have to make use of JavaScript code. If your app, however, doesn’t support [CORS](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS), the attacker has his hands tied and the threat is eliminated.

Again, Node has some great middleware packages to help you out, like the [csurf](https://github.com/expressjs/csurf), one of the most famous. Within less than 2 minutes, you’re safe and sound.

## Insufficient Logging & Monitoring

This item speaks for itself. We’ve talked about Splunk before, but this is just the tip of the iceberg in terms of available options.

Tons of different tools, plenty of them even integrating and talking to each other, provide the perfect layers to enhance your system’s protection, based on information.

Information is crucial to analyze and detect possible invasions and vulnerabilities of your app. You can create lots of routines that execute based on some predefined behaviors of your system.

The logs speak for what’s happening inside your app. So the monitoring represents the voice of it that’ll come at you whenever something wrong is detected.

Here, we won’t talk about specific tools. It’s an open field and you can play with the sea of great solutions out there.

## Wrapping Up

We’ve taken a look at the [OWASP Top Ten](https://owasp.org/www-project-top-ten/) Web Application Security Risks at the time of writing. But obviously, they’re not the only ones you should pay attention to.

The list works as a compass for developers, especially beginners, to better understand how threats exist on the web and how they can affect your apps, even though you disbelieve someone would try to hack you.

Remember, the bigger and important your applications are, the more susceptible to security breaches and bad-intended people they are.

As further reading, I’d very much recommend a tour over the [OWASP website](https://owasp.org/), as well as at its [Source Code Analysis Tools](https://owasp.org/www-community/Source_Code_Analysis_Tools) page. Good luck!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
