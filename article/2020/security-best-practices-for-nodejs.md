> * 原文地址：[Security Best Practices for Node.js](https://blog.appsignal.com/2020/08/12/security-best-practices-for-nodejs.html)
> * 原文作者：[Diogo Souza](https://twitter.com/diogosouzac)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/security-best-practices-for-nodejs.md](https://github.com/xitu/gold-miner/blob/master/article/2020/security-best-practices-for-nodejs.md)
> * 译者：[Ashira97](https://github.com/Ashira97)
> * 校对者：[PassionPenguin](https://github.com/PassionPenguin)、[samyu2000](https://github.com/samyu2000)

# Node.js 安全编程的最佳实践

如今大多数系统都是联网的，或者至少在某种程度上和网络交互，因此互联网企业变得更加重视网络安全。

长期以来，只有当新闻报道安全泄露问题、黑客活动或者是公司的数据被窃取（其中不乏一些巨型公司，诸如 Google 或者 LinkedIn 等）的事件时，网络安全才会引起公众的注意。

在我们大部分人都并不为之工作的巨头们的光怪陆离的世界之外的系统上采取相关的安全措施是非常重要的，但是这种重要性往往被忽视，甚至有些开发者都会忘记采取这些安全措施。

安装、最佳实践、优化性能、测试、关注指标很可能是您的编程生涯中每天都在做的事情。然而，很不幸，它们不等同于安全编程最佳实践。

这并不是危言耸听。如果您的工作是开源的，那么由于 Github 的保护机制，会出现一些关于依赖缺陷的[提示信息](https://docs.github.com/en/github/managing-security-vulnerabilities/about-alerts-for-vulnerable-dependencies)。GitHub 代码平台变得越来越善于在多种不同语言的数千个依赖库中进行漏洞的探测，这也是一件令人担忧的事。

现在有很多安全工具或者平台可以帮助开发者解决代码和应用程序中的漏洞，他们让中小企业更容易在系统上采取安全措施。

不管怎样，无论你是否使用这些安全平台，你都应当理解并意识到应用程序可能遭受的安全威胁，并且通过一些简单而有效的最佳实践来消除这些威胁，这也是本文的主题。

事实上，虽然我们选择 Node.js 作为目标对象，但是文中提到的很多概念同样适用于其他平台。

作为参考手册，[OWASP](https://owasp.org/) (**开放网络应用安全项目**)会通过其中的[前十个 Web 应用面临的最关键的安全威胁](https://owasp.org/www-project-top-ten/)来引导我们防范这些威胁。这十大安全威胁来自于它的广大使用者经分析之后得出的共识。让我们以 Node 项目为例来了解这些安全威胁。

## 注入攻击

Web 应用面临的一个最大的安全威胁之一就是：攻击者有可能把一段具有破坏性的 SQL 代码发送到后端并执行它。

这种情况通常发生在开发者直接调用数据层对象并执行重要的 SQL 语句时，像这样：

```js
// "id" 来自于未经处理的请求参数
db.query('select * from MyTable where id = ' + id);
   .then((users) => {
     // 在响应中返回用户信息
   });
```

如果开发者没有对请求中携带的输入参数做校验，那么攻击者可以不仅仅只传一个整数 ID，还可以传一个能够获取敏感信息甚至删除它的 SQL 命令。（这里不是强调合理的备份策略的重要性）

大多数的编程语言和他们各自的对象关系映射框架都提供了避免 SQL 注入的方法。这些方法通常是在直接连接数据库执行语句之前，对语句中的输入参数进行参数化。这一参数化的过程由编程语言可执行库中的内部逻辑完成。

在这种情况下，你需要深入了解这门语言/框架，并学习它如何实现这些功能，这非常重要。

比方说，你使用 [Sequelize](https://sequelize.org/) 来做这件事，那么一个简单的实现如下：

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

## 身份验证失误

身份认证是一个系统中需要重点关注的一部分功能，尤其是所使用的框架或者工具未能隐蔽用户敏感信息的时候。

OWASP 很注重身份认证。像 [OAuth](https://oauth.net/) 这样的标准（现在普遍使用的是第二版，[第三版](https://oauth.net/3/)正在设计中）已经面世，它会持续升级，并尝试兼容各种各样的网络环境。

实现它的方式多种多样，具体如何实现取决于项目的业务场景，公司也可以自行定制合适的标准用法。

如果您的团队或公司能够为项目购买大而成熟的安全服务，类似 [Auth0](https://auth0.com/), [Amazon Cognito](https://aws.amazon.com/cognito/) 或者是其他许多[别的工具](https://stackshare.io/auth0/alternatives)，那么可以说，在进行安全最佳实践的路上，您已经成功了一半。

如果您需要在 Node.js 的项目中[实现 OAuth2](https://blog.logrocket.com/implementing-oauth-2-0-in-node-js/) 协议，为了避免从头开发，可以从众多的开源和成熟的第三方库中选择某个来使用，比如著名的 [node-oauth2-server](https://github.com/oauthjs/node-oauth2-server) 模块。

无论所选用的模块或者框架是开源的还是付费的，您都需要经常浏览官方文档。另外，在为身份认证功能添加安全模块时，不要选用近期面世的小型开源项目（因为这样的风险对于应用程序中的关键模块而言实在太大）。

## 敏感信息泄露

首先，也是很重要的一点，是定义什么样的数据是敏感敏感数据。这一定义因项目而异。然而，无论在何种应用程序中，信用卡或者个人证件之类的信息一定属于敏感信息。

这样的信息如何传输到系统中？是加密传输的吗？没有？真的吗？

在您区分清楚什么才是“**真正重要**”的东西之后，现在该决定存储什么信息，以及存储多长时间。

您会惊讶地发现，许多应用程序存储了无用的敏感信息，甚至是在未经用户同意地情况下获取和存储的

让我们看看待办（**也被称作**一定要做的事情）列表：

* 加密敏感信息。MD5不够强大，你的数据应该有更强大的算法来加密，请使用 [Scrypt](https://www.npmjs.com/package/scrypt) 进行加密。
* 提醒用户应用程序是如何保护敏感信息的。你应该定期发邮件给用户并附上信息解释图表，在用户登录的时候推送一些信息模式，当然，您的使用条款也必须说明这一点。
* 应用程序需要基于 HTTPS 协议。否则，Google 可能不兼容您的应用。
* 如果您可以更深入一点，那么请采用 [HSTS](https://en.wikipedia.org/wiki/HTTP_Strict_Transport_Security) 协议。 HSTS 是一个帮助应用抵御[中间人攻击](https://en.wikipedia.org/wiki/Man-in-the-middle_attack)的协议。

Node 应用中像下面这样设置 HSTS：

```js
const hsts = require('hsts');

app.use(hsts({
  maxAge: 15552000  // 180 days in seconds
}));
```

您可以通过不同的定义对配置项做出微调，比如，可以配置是否包含子域名：

```js
app.use(hsts({
  maxAge: 15552000,
  includeSubDomains: false
}));
```

显然，您需要通过 npm 下载 [hsts](https://www.npmjs.com/package/hsts) 包。欲了解更多信息，请您查阅[官方文档](https://helmetjs.github.io/docs/hsts/)。

## （旧） XML 外部实体注入

攻击者可能会通过定义外部实体，利用应用程序解析 XML 文件的过程中的漏洞把那些外部实体注入到应用程序中。旧版本的 XML 解析器比较容易受到这种攻击，我们称之为 [XXE 外部实体注入](https://owasp.org/www-community/vulnerabilities/XML_External_Entity_(XXE)_Processing)

如果解析器的配置不够强大，攻击者就能够窃取类似敏感数据和机密信息，比如服务器密码等。

让我们来想象这样一个例子，一个基于 XML 的服务接收如下的 XML 内容作为输入：

```
<?xml version="1.0" encoding="ISO-8859-1"?>
   <id>1</id>
   <name>attacker@email.com</name>
   ...
</xml>
```

乍一看，这个输入和其他输入一样平常。但是，如果服务器不能识别这种攻击，而您的应用部署在这样的服务器上，就可能会发生下面的情况：

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

这将在响应中返回 **boot.ini** 文件的内容。

另一个例子是处理文件上传任务的时候。例如，如果您只对接收的文件类型作了限制，由于 DOCX 格式的文档或 SVG 格式的图片都是基于 XML 的，也可以被系统接收，因此也可以运行恶意代码。

阻止这种攻击最简单的方法就是禁用第三方库的解析特性。例如 [node-libxml](https://www.npmjs.com/package/node-libxml) 第三方库，就提供了一系列方法来验证文件类型，保护您的应用免受这种攻击。

## 访问控制失效

这一问题是否存在很大程度上取决于这个应用有没有从不同的域或者是 URL 对用户权限进行完善的测试。

换句话说，当您的应用中有受限访问的部分，比如说管理员面板这种普通用户无权访问的页面，您的应用中就会有访问漏洞。

这种漏洞很容易修改并且不需要刻意纠正和任何特别的解决方案，您可以继续使用原有的代码。唯一需要注意的就是正确地实现权限控制并且用合适的测试流程来保证权限控制范围覆盖到任何新的端点。

Node 提供了一系列库来辅助这个工作，以及一系列中间件来检查当前用户的权限。这些库和中间件也可以自己实现。

## 不正确的安全配置项

在开发项目的早期，开发者需要定义三个主要环境（开发环境、测试环境和生产环境），并且通常用相同配置来初始化这三个环境。

这种不正确的配置可能持续存在很长时间都没有人注意，并且可能导致严重的袭击事件。因为测试环境和生产环境的配置通常只提供极弱的保护，所以这样的应用非常脆弱。

当我们谈论配置的时候，请确保我们讨论的是所有类型的依赖项（数据库，外部集成，API，网关等等）。

拥有定义完善的配置是很重要的，这样的配置通常彼此之间不同且独立。通常，我们将证书或者敏感信息与项目文件分开存储到另一个远程站点。

您的团队的技术选型对这个问题也有一定影响。例如，如果您使用 [Splunk](https://www.splunk.com/) 或者其他日志工具，那么请确保设置了不允许开发环境打印敏感信息的配置或配备有检测这种行为的方法，因为相比起来存储了同样数据的数据库，Splunk 中的敏感数据更容易接触到。

这让我想起了有次一个公司的主要数据库密码泄露在了公共的 GitHub 仓库上，这是因为开发者“无意中”复制了公司的仓库回家学习。请注意，在这里我不是说最大的错误在于开发者本人。

## 令人头疼的　XSS

XSS 令人头疼。每天的繁忙工作让开发者经常忘记处理这种著名的问题。

这个问题有点类似 SQL 注入。在你的应用上有一个端点接收请求并返回响应。这不是什么大问题，然而，当您将请求参数直接放在响应中而没有做处理时，问题就来了。

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

猜猜当客户发送下面这段代码作为 **id** 参数会发生什么？

```html
<script>alert(Uh la la, it's me! XSS!!)</script> 
```

现在这只是一段无关紧要的提示信息，但是我们都知道攻击者会在代码中注入更多的 JavaScript 代码。

[Node 的完整选项](https://openbase.io/packages/top-nodejs-xss-libraries)通过使用新的中间件来解决这个问题。您可以选择其中一个，实现一下，然后这个问题就不会再困扰您了。

## 不安全的反序列化

这一情况大多发生在您的应用接受一个来源不可信的序列化对象的时候，因为这样的序列化对象有可能被攻击者篡改。

例如，想象这样一个情况，您的 Node 应用和客户端交互，在客户登录之后返回一个序列化的对象长时间存储在 cookie 中用作用户的 session ，这里存放着用户的 id 和权限之类的信息

一个攻击者能够篡改这样的 cookie 对象然后给自己赋一个管理员权限。

这里发生的事情类似于 [CSRF](https://github.com/pillarjs/understanding-csrf) (**跨站请求伪造**)。通常，服务器产生一个 token （也被称作 CSRF token ）然后它跟着每一次请求发送到客户端并存储下来，之后作为表单提交时的隐藏输入。

表单每次提交的时候都会携带这个 token ，服务器能够检测到 token 改变或者缺失的情况。如果发生了这样的情况，服务器将会拒绝该请求。攻击者会利用 JavaScript 代码来得到 token ，然而如果您的应用不支持[跨域资源共享](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS)，那么攻击者就会束手无策，威胁也随之消除。

再次一提，Node 有很多很棒的中间件可以帮助您摆脱这样的威胁，其中一个最著名的就是 [csurf](https://github.com/expressjs/csurf) 。使用这些中间件方便而快捷，用不了多长时间，您的应用就安全了。

## 不充分的日志和监控

见名知意。我们之前已经谈论过 Splunk 了，但是它只是可供选择的冰山一角。

大量不同的工具和其他的日志工具集成并交互，给您的应用提供基于信息的完善的保护。

信息对于分析和检测入侵以及应用的缺陷点是至关重要的。您可以在您的系统中定义一系列基于预定义的行为的流程来进行这样的检测。

日志展示了应用内部的情况。所以当有错误被检测到的时候，相应的信息就会显示在监控中。

这里我们不会讨论具体的工具，但有很多工具可以供您选用。

## 总结

我们已经看过了 [OWASP Top Ten](https://owasp.org/www-project-top-ten/) web 安全漏洞。但很明显，我们不应该止步于此。

这份清单是为开发者，尤其是新人开发者准备的入门读物，目的是让开发者能够更好的理解网络中的安全威胁以什么样的形式存在，以及它们如何能够影响应用 —— 即使你不相信有人尝试攻破你的应用。

牢记这一点，你的应用越大越重要，那么它就越容易受到安全威胁并且有更多潜在攻击者。

作为延伸阅读材料，推荐您浏览 [OWASP](https://owasp.org/) 网页，还有它的[源代码分析工具](https://owasp.org/www-community/Source_Code_Analysis_Tools)页面。
祝您好运！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
