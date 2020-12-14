> * 原文地址：[Security Best Practices for Node.js](https://blog.appsignal.com/2020/08/12/security-best-practices-for-nodejs.html)
> * 原文作者：[Diogo Souza](https://twitter.com/diogosouzac)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/security-best-practices-for-nodejs.md](https://github.com/xitu/gold-miner/blob/master/article/2020/security-best-practices-for-nodejs.md)
> * 译者：
> * 校对者：

# Security Best Practices for Node.js

Because a lot of systems are connected to the web these days (or, at least, communicate/integrate with it at some level), companies are giving more and more attention to web security.

Web security usually comes to public attention when certain events reach the news, for example, security leakages, hacker activities, and/or data-stealing over big companies, some of them really large (like Google, LinkedIn, etc.).

Apart from that showbiz world of giant players that most of us are probably not working for, implementing security on your systems is not only important but impressively underestimated or even forgotten by many devs.

Setup, best practices, performance, testing, and metrics are probably things that you consider in your daily programming life. However, unfortunately, that’s not the same for security best practices.

And it’s not due to warnings. If you work in the open-source universe, within GitHub’s protective arms, chances are that you’ve faced some of its [alerts](https://docs.github.com/en/github/managing-security-vulnerabilities/about-alerts-for-vulnerable-dependencies) for vulnerable dependencies. The code community platform is becoming increasingly good – as well as worried – at detecting vulnerabilities in thousands of different libs across many different languages.

Today, it’s way more accessible for small and medium companies to afford security tools (or perhaps whole platforms) to assist their developers with the gaps in their code and apps.

Nevertheless, whether you use or don’t use such security platforms, understanding and being aware of the security threats that your apps may suffer from and fighting against them through simple (but powerful) best practices is the main goal of this article.

Actually, we’ll pick Node.js as the analysis guinea pig, but many of the items here perfectly align with other platforms as well.

As a matter of reference, the [OWASP](https://owasp.org/) (**Open Web Application Security Project**) will guide us through its [Top Ten](https://owasp.org/www-project-top-ten/) most critical security risks for web applications, in general. It is a consensus board created out of the analysis of its broad list of members. Let’s face it under the light of Node then.

## Injection Attacks

One of the most famous threats to web applications relates to the possibility of an attacker sending pieces of SQL to your back-end code.

It usually happens when developers concatenate important SQL statements directly into their database layers, like so:

```js
// "id" comes directly from the request's params
db.query('select * from MyTable where id = ' + id);
   .then((users) => {
     // return the users into the response
   });
```

If the developer didn’t sanitize the input parameters arriving within the request, an attacker could pass more than a single integer id, like an SQL instruction that could retrieve sensitive information or even delete it (not to mention the importance of proper backup policies here).

Most of the programming languages, and their respective ORM frameworks, provide ways to avoid SQL injection usually by parameterizing inputs into query statements that, before executing directly into the database, will be validated by the inner logic of your language libs machinery.

In this case, it’s very important to know your language/framework closely in order to learn how they do this.

If you make use of [Sequelize](https://sequelize.org/), for example, a simple way to do it would be:

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

Authentication is usually a part of the system that requires a lot of attention, especially if you make use of frameworks or tools that easily allow developers to expose sensitive user’s information.

OWASP considers this item critical. Standards like [OAuth](https://oauth.net/) (on its 2nd version now, working on the [3rd](https://oauth.net/3/)) are constantly evolving in an attempt to embrace as much as possible the many different realities of the web world.

Its implementation can be tricky, depending on your project’s scenarios or on how your company decides to customize the standard usage.

If your team (and company) can afford to add big – and therefore, mature – players like [Auth0](https://auth0.com/), [Amazon Cognito](https://aws.amazon.com/cognito/), and [many others](https://stackshare.io/auth0/alternatives) in the market to your projects, that would be halfway there.

When it comes to [implementing OAuth2](https://blog.logrocket.com/implementing-oauth-2-0-in-node-js/) in Node.js, there’s plenty of compliant and open source options that can help you with not starting from scratch. Like the famous [node-oauth2-server](https://github.com/oauthjs/node-oauth2-server) module.

Make sure to always refer to the official docs of whatever module or framework you’re adding to your projects (whether it’s open source or paid). Plus, when adding security to your auth flows, never go with small and recent open-source projects (it’s too much of a critical part of the app to take that kind of risk).

## Sensitive Data Exposure

It’s important to define what sensitive data is. Depending on the type of project, it can vary. However, regardless of the app nature, things like credit card and document ids will always be sensitive, for sure.

How is that information going to transit over to your system? Is it encrypted? No? Really?

After you’ve separated what’s “**really important**” from the rest, it’s time to decide what needs to be stored, and for how long.

You’d be amazed at the number of apps out there that store sensitive information for no further use, or worse, without the user’s consent. That can easily break the laws of data privacy which, by the way, are different depending on the country your app is running on (another thing to worry about).

Let’s go to the to-do (**aka** must-to) list:

* Encrypt your sensitive data. Forget about MD5, your data deserves to be strongly protected under the right algorithms. So go for [Scrypt](https://www.npmjs.com/package/scrypt).
* Warn your users about how your application deals with sensitive info. You can periodically mail them with explaining infographics, pop up some informative modals when logging in, and yes, your terms of use must state this too.
* Go for HTTPS. Period. Google won’t like you nowadays if you’re not.
* If you can, go a bit further and do [HSTS](https://en.wikipedia.org/wiki/HTTP_Strict_Transport_Security). It is a policy mechanism that enhances your web security against the famous [man-in-the-middle](https://en.wikipedia.org/wiki/Man-in-the-middle_attack) attacks.

Setting HSTS in a Node app is as easy as:

```js
const hsts = require('hsts');

app.use(hsts({
  maxAge: 15552000  // 180 days in seconds
}));
```

You can fine-tune your settings by defining, for example, if subdomains should be included or not:

```js
app.use(hsts({
  maxAge: 15552000,
  includeSubDomains: false
}));
```

You’ll need, obviously, the [hsts](https://www.npmjs.com/package/hsts) npm package. Make sure to refer to its [official docs](https://helmetjs.github.io/docs/hsts/) for more info.

## Old XML External Entities (XXE)

[XXE attacks](https://owasp.org/www-community/vulnerabilities/XML_External_Entity_(XXE)_Processing) occur by exploring the vulnerabilities that older XML processors have, in which they allow attackers to specify external entities and send them to applications that parse XML inputs.

If the parser is weakly configured, the attacker could have access to sensitive information, confidential data like passwords in a server, among others.

Consider, as an example, an XML-based Web Service that receives the following XML content as input:

```
<?xml version="1.0" encoding="ISO-8859-1"?>
   <id>1</id>
   <name>attacker@email.com</name>
   ...
</xml>
```

At first sight, it looks just like all the other inputs you’ve seen so far. However, if your app that’s hosted on a server is not prepared to deal with attacks, something like this could be sent over:

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

Another good example is if your app deals with uploading files. If, for example, you restrict it to only accepting some group of files, then XML-based formats like DOCX or the famous SVG for images could be accepted and carry on malicious code as well.

The easiest way to prevent such attacks is by disabling your library’s parsing features. The [node-libxml](https://www.npmjs.com/package/node-libxml) npm package, for instance, provides a bunch of functions to validate your DTD and helps you secure your apps against these attacks.

## Broken Access Control

This item is mostly related to how well-tested an application has been when it comes to user permissions to different areas (or URLs) of it.

In other words, if you’re supposed to have restricted areas on the application, like an admin dashboard, for example, and ordinary users without a proper role can access it anyway, then you have an access vulnerability.

It is easily correctable and doesn’t require any specific solution, you can go with whatever you’re using already. The only point is the attention to implement it correctly and cover it with proper tests that guarantee the coverage over new endpoints as well.

Node provides plenty of libraries to help with that, as well as middleware to check for the current user’s permissions and you can also implement one on your own.

## Security Misconfiguration

It’s common, in the early stages of an app’s life, to define three major environments (development – or stage, QA, and production) and leave the settings equal among them.

This type of misconfiguration sometimes goes on for ages without being noticed and can lead to critical attacks, since the app is vulnerable considering that staging and QA configurations are weakly protected most of the time.

When we talk about configurations, make sure to associate them to all types of dependencies (databases, external integrations, APIs, gateways, etc.).

It’s fundamental to have well-defined setups, distinct and separated from each other. Also, consider storing your credentials (and sensitive setting’s data) in remote places apart from the project files.

The cultural aspects of your company may take place here as well. If you use [Splunk](https://www.splunk.com/), for example, or any other logging tool, make sure to have policies (and ways to check that) that force the devs to not log sensitive data since Splunk can be way more easily accessed than the database that stores the same data.

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
