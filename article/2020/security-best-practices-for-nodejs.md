> * 原文地址：[Security Best Practices for Node.js](https://blog.appsignal.com/2020/08/12/security-best-practices-for-nodejs.html)
> * 原文作者：[Diogo Souza](https://twitter.com/diogosouzac)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/security-best-practices-for-nodejs.md](https://github.com/xitu/gold-miner/blob/master/article/2020/security-best-practices-for-nodejs.md)
> * 译者：
> * 校对者：

#Security Best Practices for Node.js
# Nodejs 安全编程的最佳实践

Because a lot of systems are connected to the web these days (or, at least, communicate/integrate with it at some level), companies are giving more and more attention to web security.
由于越来越多的系统与网络相连，或者至少在某种程度上和网络交互，因此互联网企业正在给予网络安全更多的重视。

Web security usually comes to public attention when certain events reach the news, for example, security leakages, hacker activities, and/or data-stealing over big companies, some of them really large (like Google, LinkedIn, etc.).
Web 安全通常只有在某些新闻出现的时候才会被大家关注，比如说，安全泄露问题、黑客活动或者是大公司的数据泄露问题，有些数据窃取问题的规模真的非常大，像是 Google 或者 LinkdIn 的数据窃取事件。

Apart from that showbiz world of giant players that most of us are probably not working for, implementing security on your systems is not only important but impressively underestimated or even forgotten by many devs.
除去那些我们大部分人都不为之工作的娱乐巨头们的娱乐圈，在系统上实现安全措施不仅重要，而且被严重低估，甚至被许多开发者遗忘。

Setup, best practices, performance, testing, and metrics are probably things that you consider in your daily programming life. However, unfortunately, that’s not the same for security best practices.
安装、最佳实践、性能、测试、指标很可能是您的的编程生涯中每天都在做的事情。然而，很不幸，它们不等同于安全编程最佳实践。

And it’s not due to warnings. If you work in the open-source universe, within GitHub’s protective arms, chances are that you’ve faced some of its [alerts](https://docs.github.com/en/github/managing-security-vulnerabilities/about-alerts-for-vulnerable-dependencies) for vulnerable dependencies. The code community platform is becoming increasingly good – as well as worried – at detecting vulnerabilities in thousands of different libs across many different languages.
这并不是危言耸听。如果你的工作在开源的环境下，那么在 GitHub 的保护机制之下，你有可能会看到一些有缺陷的依赖的[提示](https://docs.github.com/en/github/managing-security-vulnerabilities/about-alerts-for-vulnerable-dependencies)。GitHub 代码平台变得越来越擅长-也越来越让人担心-在许多不同语言编码的数千个依赖库中进行漏洞的探测。

Today, it’s way more accessible for small and medium companies to afford security tools (or perhaps whole platforms) to assist their developers with the gaps in their code and apps.
有很多安全工具或者平台可以帮助公司的开发者解决代码和应用程序中的漏洞。今天，对于中小企业来说，这样的工具甚至整个平台变得越来越触手可及。

Nevertheless, whether you use or don’t use such security platforms, understanding and being aware of the security threats that your apps may suffer from and fighting against them through simple (but powerful) best practices is the main goal of this article.
然而，无论你是否使用这些安全平台，帮助你理解并意识到这些你的应用可能遭受的安全威胁并且通过这些简单但强大的最佳实践来消除这些威胁时这篇文章的主要目的。

Actually, we’ll pick Node.js as the analysis guinea pig, but many of the items here perfectly align with other platforms as well.
事实上，虽然我们将 Node.js 选择作为实验对象，但是文中提到的很多概念都同样适用于其他平台。

As a matter of reference, the [OWASP](https://owasp.org/) (**Open Web Application Security Project**) will guide us through its [Top Ten](https://owasp.org/www-project-top-ten/) most critical security risks for web applications, in general. It is a consensus board created out of the analysis of its broad list of members. Let’s face it under the light of Node then.
通常，[OWASP](https://owasp.org/)(**开放网络应用安全项目**) 将会作为参考手册，通过其中的[前十个 Web 应用面临的最关键的安全威胁](https://owasp.org/www-project-top-ten/)来引导我们。这十大安全威胁来自于它的广大使用者经分析之后得出的共识。让我们以 Node 项目为例来看一看这些安全威胁。

## Injection Attacks
## 注入攻击

One of the most famous threats to web applications relates to the possibility of an attacker sending pieces of SQL to your back-end code.
Web 应用面临的一个最著名的安全威胁是攻击者有可能把一段sql代码发送到后端。

It usually happens when developers concatenate important SQL statements directly into their database layers, like so:
这通常发生在开发者直接将重要的sql语句和数据库层相连的情况下，像这样：

```js
// "id" 来自于未经处理的请求参数
db.query('select * from MyTable where id = ' + id);
   .then((users) => {
     // return the users into the response
   });
```

If the developer didn’t sanitize the input parameters arriving within the request, an attacker could pass more than a single integer id, like an SQL instruction that could retrieve sensitive information or even delete it (not to mention the importance of proper backup policies here).
如果开发者没有对请求中携带的输入参数做校验，那么攻击者可以不仅仅只传一个整数 ID，还可以传一个能够获取敏感信息甚至删除它的 SQL 命令。（这里不是强调合理的备份策略的重要性）

Most of the programming languages, and their respective ORM frameworks, provide ways to avoid SQL injection usually by parameterizing inputs into query statements that, before executing directly into the database, will be validated by the inner logic of your language libs machinery.
大多数的编程语言和他们各自的对象关系映射框架都提供了避免 SQL 注入的方法。这些方法通常是通过在直接连接数据库执行语句之前，对语句中的输入参数进行参数化。这一参数化的过程由编程语言可执行库中的内部逻辑完成。

In this case, it’s very important to know your language/framework closely in order to learn how they do this.
这种情况下，详细了解你的语言/框架来学习它们是怎么做到这一点的就非常重要。

If you make use of [Sequelize](https://sequelize.org/), for example, a simple way to do it would be:
比方说，如果你使用 [Sequelize](https://sequelize.org/) 来做这件事，那么一个简单的实现如下：

```js
const { QueryTypes } = require('sequelize');

await sequelize.query(
  'select * from MyTable where id = :p1',
  {
    replacements: { p1: id }, // id 来自于请求参数
    type: QueryTypes.SELECT
  }
);
```

## Authentication Pitfalls
## 身份验证失误

Authentication is usually a part of the system that requires a lot of attention, especially if you make use of frameworks or tools that easily allow developers to expose sensitive user’s information.
身份认证通常是一个系统中非常值得关注的一部分，尤其在使用了开发者很轻易就能暴露敏感用户信息的框架或者工具的情况下。

OWASP considers this item critical. Standards like [OAuth](https://oauth.net/) (on its 2nd version now, working on the [3rd](https://oauth.net/3/)) are constantly evolving in an attempt to embrace as much as possible the many different realities of the web world.
OWASP 认为身份认证很关键。像 [OAuth](https://oauth.net/) 这样的标准（以第二版为准，[第三版](https://oauth.net/3/)正在筹备中）一直以来都尝试尽可能多的考虑现实生活中的各种不同情况来确保身份验证是有效的。（？）

Its implementation can be tricky, depending on your project’s scenarios or on how your company decides to customize the standard usage.
它的实现难以捉摸，取决于项目的业务场景或者是你的公司决定如何制定标准用法。

If your team (and company) can afford to add big – and therefore, mature – players like [Auth0](https://auth0.com/), [Amazon Cognito](https://aws.amazon.com/cognito/), and [many others](https://stackshare.io/auth0/alternatives) in the market to your projects, that would be halfway there.
如果你的团队或公司能够为项目购买大而成熟的安全服务，类似 [Auth0](https://auth0.com/), [Amazon Cognito](https://aws.amazon.com/cognito/) 或者是其他许多[别的工具](https://stackshare.io/auth0/alternatives)，那么会有事半功倍的效果。

When it comes to [implementing OAuth2](https://blog.logrocket.com/implementing-oauth-2-0-in-node-js/) in Node.js, there’s plenty of compliant and open source options that can help you with not starting from scratch. Like the famous [node-oauth2-server](https://github.com/oauthjs/node-oauth2-server) module.
当你想要在 Node.js 的项目中[实现 OAuth2](https://blog.logrocket.com/implementing-oauth-2-0-in-node-js/) 协议时，有很多开源和成熟的第三方库可供选择从而使你避免从头开始，比如著名的[node-oauth2-server](https://github.com/oauthjs/node-oauth2-server) 模块。

Make sure to always refer to the official docs of whatever module or framework you’re adding to your projects (whether it’s open source or paid). Plus, when adding security to your auth flows, never go with small and recent open-source projects (it’s too much of a critical part of the app to take that kind of risk).
确保经常参考您所选用的模块或者框架的官方文档，无论它们是开源或者付费的。另外，当在认证过程中添加安全模块时，不要选用近期刚出现的小的开源项目（这样的风险对于应用程序中的关键部分而言实在太大）。

## Sensitive Data Exposure
## 敏感信息泄露

It’s important to define what sensitive data is. Depending on the type of project, it can vary. However, regardless of the app nature, things like credit card and document ids will always be sensitive, for sure.
首先，也是很重要的一点，是定义什么样的数据是敏感的。这一定义随项目的类型而变化。然而，无论应用程序的目的是什么，信用卡信息或者个人证件信息之类的信息一定属于敏感信息。

How is that information going to transit over to your system? Is it encrypted? No? Really?
这样的信息如何传输到系统中？是加密传输的吗？没有？真的吗？

After you’ve separated what’s “**really important**” from the rest, it’s time to decide what needs to be stored, and for how long.
在你区分清楚什么才是“**真正重要**”的东西之后，现在该决定存储什么信息，以及存储多长时间。

You’d be amazed at the number of apps out there that store sensitive information for no further use, or worse, without the user’s consent. That can easily break the laws of data privacy which, by the way, are different depending on the country your app is running on (another thing to worry about).
你会惊讶于许多应用程序存储了无用的敏感信息，或者更糟糕，存储未经用户同意获取的敏感信息。这种行为有可能违背数据隐私保护法律，当然，是否违法取决于你的应用所在的国家。

Let’s go to the to-do (**aka** must-to) list:
让我们看看待办（**也被称作** 一定要做的事情）列表：

* Encrypt your sensitive data. Forget about MD5, your data deserves to be strongly protected under the right algorithms. So go for [Scrypt](https://www.npmjs.com/package/scrypt).
* 加密敏感信息。MD5不够强大，你的数据应该有更强大的算法来加密，请使用 [Scrypt](https://www.npmjs.com/package/scrypt) 进行加密。
* Warn your users about how your application deals with sensitive info. You can periodically mail them with explaining infographics, pop up some informative modals when logging in, and yes, your terms of use must state this too.
* 提醒用户应用程序时如何保护敏感信息的。你应该阶段性的发邮件给用户并附上信息解释图表，当用户登录的时候推送一些信息模式，当然，你的使用条款也必须说明这一点。
* Go for HTTPS. Period. Google won’t like you nowadays if you’re not.
* 选择使用 HTTPS 。如果不使用，Google 可能不兼容你的应用。（？）
* If you can, go a bit further and do [HSTS](https://en.wikipedia.org/wiki/HTTP_Strict_Transport_Security). It is a policy mechanism that enhances your web security against the famous [man-in-the-middle](https://en.wikipedia.org/wiki/Man-in-the-middle_attack) attacks.
* 如果你可以更深入一点，可以实现 [HSTS](https://en.wikipedia.org/wiki/HTTP_Strict_Transport_Security) 协议。 HSTS 是一个帮助应用抵御[中间人攻击](https://en.wikipedia.org/wiki/Man-in-the-middle_attack)的协议。

Setting HSTS in a Node app is as easy as:
Node 应用中像下面这样设置 HSTS ：

```js
const hsts = require('hsts');

app.use(hsts({
  maxAge: 15552000  // 180 days in seconds
}));
```

You can fine-tune your settings by defining, for example, if subdomains should be included or not:
你可以通过不同的定义仔细调试配置项，比如，可以配置是否包含子域名：

```js
app.use(hsts({
  maxAge: 15552000,
  includeSubDomains: false
}));
```

You’ll need, obviously, the [hsts](https://www.npmjs.com/package/hsts) npm package. Make sure to refer to its [official docs](https://helmetjs.github.io/docs/hsts/) for more info.
很明显，你首先需要通过 npm 下载 [hsts](https://www.npmjs.com/package/hsts) 包。请确保您经常通过[官方文档](https://helmetjs.github.io/docs/hsts/)查阅进一步的信息。

## Old XML External Entities (XXE)
## （旧）XML外部实体注入

[XXE attacks](https://owasp.org/www-community/vulnerabilities/XML_External_Entity_(XXE)_Processing) occur by exploring the vulnerabilities that older XML processors have, in which they allow attackers to specify external entities and send them to applications that parse XML inputs.
[XXE 外部实体注入](https://owasp.org/www-community/vulnerabilities/XML_External_Entity_(XXE)_Processing)发生在旧的 XML 处理器中。在这样的处理器中，攻击者可以指定外部实体并将它们送到解析 XML 输入的应用中。

If the parser is weakly configured, the attacker could have access to sensitive information, confidential data like passwords in a server, among others.
如果解析器的配置不够强大，攻击者就能够窃取类似服务器密码之类的敏感数据、机密数据。

Consider, as an example, an XML-based Web Service that receives the following XML content as input:
举个例子，想象一下一个基于 XML 的服务接收如下的 XML 内容作为输入：

```
<?xml version="1.0" encoding="ISO-8859-1"?>
   <id>1</id>
   <name>attacker@email.com</name>
   ...
</xml>
```

At first sight, it looks just like all the other inputs you’ve seen so far. However, if your app that’s hosted on a server is not prepared to deal with attacks, something like this could be sent over:
第一眼看去，这个输入和其他输入一样平常。然而，如果你的应用部署在一个不能处理这种攻击的服务器上，就可能会发生下面的情况：

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
另一个好例子是应用处理文件上传任务的时候。例如，如果你限制仅仅可以接收某些类型的文件，那么可以接收基于 XML 格式的文档，例如 DOCX 或者著名的 SVG 格式的图片，同样可以运行恶意代码。

The easiest way to prevent such attacks is by disabling your library’s parsing features. The [node-libxml](https://www.npmjs.com/package/node-libxml) npm package, for instance, provides a bunch of functions to validate your DTD and helps you secure your apps against these attacks.
最简单阻止这种攻击的方法就是禁用第三方库的解析特性。例如 [node-libxml](https://www.npmjs.com/package/node-libxml) 第三方库，就提供了一系列方法来确认文件类型定义来保护您的应用免于遭受这种攻击。

## Broken Access Control
## 访问控制失效

This item is mostly related to how well-tested an application has been when it comes to user permissions to different areas (or URLs) of it.
这一问题很大程度上取决于这个应用有没有从不同的域或者是 URL 对用户权限进行完善的测试。

In other words, if you’re supposed to have restricted areas on the application, like an admin dashboard, for example, and ordinary users without a proper role can access it anyway, then you have an access vulnerability.
换句话说，当你的应用中有受限访问的部分，比如说管理员面板，这种普通用户无权访问的页面，这样的应用中就会有访问漏洞。

It is easily correctable and doesn’t require any specific solution, you can go with whatever you’re using already. The only point is the attention to implement it correctly and cover it with proper tests that guarantee the coverage over new endpoints as well.
这种漏洞很容易修改并且也不需要特别纠正，并且不需要任何特别的解决方案，你可以继续使用已经使用的代码。唯一需要注意的就是正确的实现权限控制并且用合适的测试流程来保证权限控制范围覆盖到了任何新的端点。

Node provides plenty of libraries to help with that, as well as middleware to check for the current user’s permissions and you can also implement one on your own.
Node 提供了一系列库来辅助这个工作，以及提供了一系列中间件来检查当前用户的权限。这些库和中间件也可以自己实现。

## Security Misconfiguration
## 不正确的安全配置项

It’s common, in the early stages of an app’s life, to define three major environments (development – or stage, QA, and production) and leave the settings equal among them.
在开发项目的早期，开发者需要定义三个主要环境（开发环境、测试环境和生产环境），并且通常用相同配置来初始化这三个环境。

This type of misconfiguration sometimes goes on for ages without being noticed and can lead to critical attacks, since the app is vulnerable considering that staging and QA configurations are weakly protected most of the time.
这种不正确的配置可能持续存在很长时间都没有人注意，并且可能导致严重的袭击事件，因为这个应用是有缺陷的。这些缺陷是因为测试环境和生产环境的配置通常只提供极弱的保护。（？）

When we talk about configurations, make sure to associate them to all types of dependencies (databases, external integrations, APIs, gateways, etc.).
当我们谈论配置的时候，请确保我们讨论的是所有类型的依赖项（数据库，外部集成工具，API，网关等等）

It’s fundamental to have well-defined setups, distinct and separated from each other. Also, consider storing your credentials (and sensitive setting’s data) in remote places apart from the project files.
拥有定义完善的配置是很重要的，这样的配置通常彼此之间不同且独立。通常，我们也会将证书或者敏感信息与项目文件分开存储到另一个远程站点。

The cultural aspects of your company may take place here as well. If you use [Splunk](https://www.splunk.com/), for example, or any other logging tool, make sure to have policies (and ways to check that) that force the devs to not log sensitive data since Splunk can be way more easily accessed than the database that stores the same data.
您的团队的技术选型对这个问题也有一定影响。例如，如果你使用 [Splunk](https://www.splunk.com/) 或者其他日志工具，那么请确保设置了不允许开发环境打印敏感信息的配置或配备有检测这种行为的方法，因为相比起来存储了同样数据的数据库，Splunk 中的敏感数据更容易接触到。

That reminds me of a time in a company in which the main database’s password went up to a public GitHub repo due to a developer that “innocently” copied one of the company’s repo to study at home. And don’t get me wrong… I’m not saying that the biggest error was his; it was not.
这让我想起了有次一个公司的主要数据库密码泄露在了公共的 GitHub 仓库上，这是因为开发者“无意中”复制了公司的仓库回家学习。请注意，在这里我不是说最大的错误在于开发者本人。

## The Notorious XSS
## 令人头疼的XSS

XSS is a notorious rebel. Even though it’s insanely famous, everyday rush can easily make you forget about it.
XSS 非常令人头疼。虽然它很著名，但是每天的繁忙工作很容易让你忘掉它。

The problem here resembles SQL injection. You have an endpoint in your web app that receives a request and returns a response. Not a big deal. However, it becomes one when you concatenate the request data with the response without sanitizing it.
这个问题有点类似 SQL 注入。在你的应用上有一个端点接收请求并返回响应。这不是什么大问题，然而，当您将请求参数直接放在响应中而没有做处理时，问题就来了

A classic example would be:
经典案例如下：

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
猜猜当客户发送下面这段代码作为 **id** 参数会发生什么？

```html
<script>alert(Uh la la, it's me! XSS!!)</script> 
```

For now, it’s just an innocent alert message, but we all know that an attacker would put a bit more of JavaScript code in there.
现在这只是一段无关紧要的alert信息，但是我们都知道攻击者会在代码中注入更多的 JavaScript 代码。

Node’s [full of options](https://openbase.io/packages/top-nodejs-xss-libraries) to address this issue by simply adding a new middleware. Pick one, implement it properly, and move on.
[Node 的完整选项](https://openbase.io/packages/top-nodejs-xss-libraries)通过使用一个新的中间件来解决这个问题。您可以选择其中一个，合适地实现一下，然后这个问题就不会再困扰您了。

## Insecure Deserialization
## 不安全的反序列化

This breach takes place mostly when applications accept serialized objects from untrusted sources that could be tampered with by attackers.
这一情况大多发生在你的应用接受一个不可信来源的序列化对象的时候，因为这样的序列化对象有可能被攻击者篡改。

Imagine, for example, that your Node web app communicates with the client and returns after the user has logged in, a serialized object to be persisted in a cookie that will work as the user’s session, storing data like the user id and permissions.
例如，想象这样一个情况，你的 Node 应用和客户端交互，在客户登陆之后返回一个序列化的对象长时间存储在 cookie 中用作用户的 session ，这里存放着用户的 id 和权限之类的信息

An attacker could then change the cookie object and give an admin role to himself, for example.
一个攻击者能够篡改这样的 cookie 对象然后给自己赋一个管理员权限。

Here’s where terms like [CSRF](https://github.com/pillarjs/understanding-csrf) (**Cross-site Request Forgery**) pop up. Basically, the server app generates a token (known as CSRF token) and sends it to the client in every request to be saved in a form’s hidden input.
这里发生的事情类似于 [CSRF](https://github.com/pillarjs/understanding-csrf) (**跨站请求伪造**)。通常，服务器产生一个 token （也被称作 CSRF token ）然后它跟着每一次请求发送到客户端并存储作为表单提交时的隐藏输入。

Every time the form is submitted it sends the token along and the server can check if it has changed or is absent. If that happens, the server will reject the request. In order to get this token, the attacker would have to make use of JavaScript code. If your app, however, doesn’t support [CORS](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS), the attacker has his hands tied and the threat is eliminated.
表单每次提交的时候都会携带这个 token ，服务器能够检测到 token 改变或者缺失的情况。如果发生了这样的情况，服务器将会拒绝该请求。攻击者会利用 JavaScript 代码来得到 token ，然而如果你的应用不支持[跨域资源共享](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS)，那么攻击者就会束手无策，威胁也随之消除。

Again, Node has some great middleware packages to help you out, like the [csurf](https://github.com/expressjs/csurf), one of the most famous. Within less than 2 minutes, you’re safe and sound.
再次一提，Node 有很多很棒的中间件可以帮助你摆脱这样的威胁，其中一个最著名的就是 [csurf](https://github.com/expressjs/csurf) 。使用这些中间件，用不了两分钟的时间您的应用就变得安全。（？）

## Insufficient Logging & Monitoring
## 不充分的日志和监控

This item speaks for itself. We’ve talked about Splunk before, but this is just the tip of the iceberg in terms of available options.
见名知意。我们之前已经谈论过 Splunk 了，但是它只是可选项的冰山一角。

Tons of different tools, plenty of them even integrating and talking to each other, provide the perfect layers to enhance your system’s protection, based on information.
大量的不同工具，其中的很多甚至和其他的日志工具集成并交互，给你的应用提供了基于信息的更强的保护层。

Information is crucial to analyze and detect possible invasions and vulnerabilities of your app. You can create lots of routines that execute based on some predefined behaviors of your system.
信息对于分析和检测入侵以及应用的缺陷点是至关重要的。你可以在你的系统中定义一系列基于预定义的行为的流程。

The logs speak for what’s happening inside your app. So the monitoring represents the voice of it that’ll come at you whenever something wrong is detected.
日志展示了你的应用内部正在发生什么。所以当有错误被检测到的时候，这样的信息就会在监控中显示。

Here, we won’t talk about specific tools. It’s an open field and you can play with the sea of great solutions out there.
这里我们不会讨论具体的工具，有很多工具你可以选用。

## Wrapping Up
## 总结

We’ve taken a look at the [OWASP Top Ten](https://owasp.org/www-project-top-ten/) Web Application Security Risks at the time of writing. But obviously, they’re not the only ones you should pay attention to.
我们已经看过了 [OWASP Top Ten](https://owasp.org/www-project-top-ten/) web安全漏洞。但很明显，我们不应该止步于此。

The list works as a compass for developers, especially beginners, to better understand how threats exist on the web and how they can affect your apps, even though you disbelieve someone would try to hack you.
这份清单是为开发者，尤其是新人开发者准备的指南，让开发者能够更好的理解网络中的安全威胁以什么样的形式存在，以及它们如何能够影响应用，即使你不相信有人尝试攻破你的应用。

Remember, the bigger and important your applications are, the more susceptible to security breaches and bad-intended people they are.
牢记这一点，你的应用越大越重要，那么它就越容易受到安全威胁并且有更多潜在攻击者。

As further reading, I’d very much recommend a tour over the [OWASP website](https://owasp.org/), as well as at its [Source Code Analysis Tools](https://owasp.org/www-community/Source_Code_Analysis_Tools) page. Good luck!
作为延伸阅读材料，我推荐你浏览 [OWASP](https://owasp.org/) 网页，还有它的[源代码分析工具](https://owasp.org/www-community/Source_Code_Analysis_Tools)工具页面。
祝你好运！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
