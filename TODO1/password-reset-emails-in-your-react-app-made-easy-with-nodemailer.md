> * 原文地址：[Password Reset Emails In Your React App Made Easy with Nodemailer](https://itnext.io/password-reset-emails-in-your-react-app-made-easy-with-nodemailer-bb27968310d7)
> * 原文作者：[Paige Niedringhaus](https://medium.com/@paigen11)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/password-reset-emails-in-your-react-app-made-easy-with-nodemailer.md](https://github.com/xitu/gold-miner/blob/master/TODO1/password-reset-emails-in-your-react-app-made-easy-with-nodemailer.md)
> * 译者：[fireairforce](https://github.com/fireairforce)
> * 校对者：[portandbridge](https://github.com/portandbridge)

# 使用 Nodemailer 轻松构建能通过电子邮件重置密码的 React 应用程序

> 重置 JavaScript 应用程序中的密码没那么复杂

![](https://cdn-images-1.medium.com/max/4552/1*LlYcAoiR_1FakdL5FmTxRw.png)

### MERN 应用程序中的密码重置

在我还没有真正动手尝试，帮我的 MERN 应用程序构建基于电子邮件的密码重置功能时，我高估了这么做的难度。据我所知，在 JavaScript 应用程序中发送电子邮件是很困难的，但我仍然想尝试一下。

几个月来，为了磨练我的 JavaScript 全栈技能，我一直在慢慢构建这个应用并把它添加到一个[用户注册服务](https://github.com/paigen11/mysql-registration-passport)。

首先，我使用 React 作为前端，Express/Node.js 后端和 Docker 驱动的 MySQL 数据库来构建这个应用。我通过 `docker-compose.yml` 来用一个命令启动整个应用程序（如果你想阅读更多关于我使用 Docker 进行开发的内容，你可以看看这篇[博文](https://medium.com/@paigen11/using-docker-docker-compose-to-improve-your-full-stack-application-development-1e41280748f4)）。

在我开始构建应用程序之后，我使用 Passport.js 和 JSON Web Tokens（JWTs）在应用程序中添加权限校验。如果你对这个感兴趣的话，可以去阅读[这篇文章](https://itnext.io/implementing-json-web-tokens-passport-js-in-a-javascript-application-with-react-b86b1f313436)去体会其中的好（nüè）玩（xīn）之处。我花了很多时间 —— 我遇到了很多障碍，使我多次停滞不前。但是决心和我无法解决一个问题一旦在我脑海中生根，我会努力将问题想出来然后继续前进。

当我决定解决通过电子邮件发送密码重置链接的问题时（就像真实的网站一样，包括我自己在内的用户不可避免地会忘记他们的密码），我觉得自己会更加痛苦。尽管实际上每个网站都有这个功能，但是做起来不可能那么简单。但是我错了，我很高兴我错了。

### Nodemailer — The Magic Bullet

![](https://cdn-images-1.medium.com/max/2000/1*srax5uIJJj_5mUkCtEI8xQ.png)

当我开始到处搜索我的密码重置功能的解决方案时，我发现了许多推荐 [nodemail](https://nodemail.com/about/) 的文章。

当我访问它的官网的时候，我最先读到的是：

> Nodemailer 是 Node.js 的一个模块，它可以轻松地发送电子邮件。该项目于 2010 年开始，当时没有更好的解决方案来发送电子邮件消息，今天它是大多数 Node.js 用户默认选择的解决方案。 —— Nodemailer

你知道吗？这并不是在开玩笑。很轻松发邮件并不困难。

当然在我开始之前，我做了更多的调查来确保我对这项技术更有信心，而我在 [NPM](https://www.npmjs.com/package/nodemailer) 和 [Github](https://github.com/nodemailer/nodemailer) 上看见的让我放心。

Nodemailer 有：

* NPM 每周下载量超过 615,000 次，
* Github 上超过 10,000 个 star，
* 截止目前已有 206 个版本，
* 超过 2,500 个依赖包，
* 自 2010 年以来，它以某种形式或时尚存在。

好吧，这似乎值得我在自己的项目里面试一试。

### 在代码中实现 Nodemailer（前端和后端）

我的密码重置功能不需要很多花哨的东西，只需要：

* 一种将电子邮件发送到用户地址的方法，
* 邮件会包含一个链接，链接会重定向到我的网站上的受保护页面，用户在这些页面中重置密码，
* 然后他们可以使用新密码登录，
* 我还希望密码重置链接在一段时间后过期从而具有更好的安全性。

我是这么做的。

### 前端代码（客户端文件夹）—— 发送重置邮件

我首先从 React 代码开始，因为我必须有一个页面，用户可以输入他们的电子邮件地址并使用包含重置链接的电子邮件。

**`ForgotPassword.js`**

![](https://cdn-images-1.medium.com/max/2704/1*r9V8XUjaYw-QBnLqv4kPiA.png)

好吧，我知道这是一个很大的截图，但我会将其分解（我在 VS Code 中使用了 [Polacode](https://github.com/octref/polacode) 来制作这个漂亮的截图，仅供参考）。如果要复制/粘贴实际代码，可以去看看[仓库](https://github.com/paigen11/mysql-registration-passport)。

你真正应该关注的是组件的 `sendEmail` 方法和 `render` 方法。其余的代码只是设置初始状态和变量，以及按钮和元素的样式。

**渲染方法**

![](https://cdn-images-1.medium.com/max/2704/1*xVFpFa-557DJ89nyW8kC6A.png)

请注意 `render` 方法内部，我有一个简单的输入框来让用户输入其电子邮件地址，按下提交按钮会触发 `this.sendEmail()` 方法。除此之外，如果用户没有输入电子邮件，或者如果服务器回复电子邮件已成功发送或者它不是可识别的地址，我会内置一些错误和成功处理。

**发送电子邮件功能**

![](https://cdn-images-1.medium.com/max/2704/1*QFsQudnZUkRdd3PEZdH_fQ.png)

所有的 HTTP 请求都是使用 [Axios](https://www.npmjs.com/package/axios) 来完成的，这使得服务器进行 AJAX 调用非常容易，在我看来，这甚至比内置的 Web API `fetch()` 都简单。

当用户输入他们的电子邮件时，会向服务器发出一个 POST 请求，并等待服务器响应。如果邮件地址找不到，我可以告诉用户地址输错了；或者用户还没注册，他们可以进入一个注册页面并创建一个新的账户；如果邮件地址与我们数据库中的地址匹配，他们将会收到提示密码重置链接已成功发送到他们的电子邮件地址的消息。

我们现在转到后端代码

### 后端代码（API 文件夹）—— 发送重置邮件

**`forgotPassword.js`**

![](https://cdn-images-1.medium.com/max/4500/1*f1W9yIwc0rNyGYLQIpTK-A.png)

后端代码涉及到更多。这就是 Nodemailer 发挥作用的地方。

用户输入的电子邮件地址进入 `forgotPassword` 路由时，Sequelize 方法首先要做的是检查该电子邮件是否存在于我的数据库中。如果用户没有收到通知，他们可能输入错误，如果确实存在，则会启动一系列其他事件。

只有将它们全部衔接起来这一点，一开始做起来有点难。

**第 1 步：生成令牌**

![](https://cdn-images-1.medium.com/max/2604/1*WB1CE9-HxjkbUXMuKX5gkA.png)

确认电子邮件已经关联到数据库的某个用户之后，第一步要做的，是生成可以关联到用户账户的令牌，并设置该令牌的有效时间。

Node.js 有一个叫做 [Crypto](https://nodejs.org/api/crypto.html#crypto_crypto) 的内置模块，它提供加密功能，这是一种高级的说法，我可以用 `crypto.randomBytes(20).toString('hex');` 这行代码很简单的生成一个唯一的哈希令牌。然后，我将这个新令牌保存到数据库中用户的配置文件中，名为 `resetPasswordToken`。我还设置了该令牌有效期的时间戳。发送链接后，我使链接的有效期为 1 小时 —— `Date.now() + 36000`。

**第 2 步：创建 Nodemailer 传输**

![](https://cdn-images-1.medium.com/max/2604/1*41dtjCfN-OV3HLpRvnSCKA.png)

接下来，我创建了 `transporter` 方法实际上是发送密码重置电子邮件链接的帐户。

我选择使用 Gmail，因为我个人使用 Gmail，我创建了一个新的虚拟帐户来发送电子邮件。由于我不想把这个虚拟账户的一些凭证提供给任何人，因此我把凭证放在一个 `.env` 文件中，并且这个文件是被包含在 `.gitignore` 中的，因此它永远不会提交给 Github 或其它任何地方。

NPM 包 `[dotenv](https://www.npmjs.com/package/dotenv)` 用于读取文件的内容和将邮件的地址和密码插入到 Nodemailer 的 `createTransport` 方法中。

**第 3 步：创建邮件选项**

![](https://cdn-images-1.medium.com/max/4488/1*GSXm2RvmB2cccXRTF2J8GA.png)

第三步是创建电子邮件模板，Nodemailer 中它叫做 `mailOptions`，用户将会看到这些信息（这也是他们从前端输入经过验证的电子邮件地址被使用的地方）。

有完整的第三方库可以使用 Nodemailer 模块制作精美的电子邮件，但我只想要一封简单的电子邮件，所以我自己制作了这个。

它包含发送（`from`）邮件的电子邮件地址（mySqlDemoEmail@gmail.com，对我来说地址是这个），用户的邮件地址在 `to` 框中，`subject` 行则是用来存放重置密码链接的行，并且 `text` 是一个包含一些信息和网站 URL 重置路由的简单字符串，包括我之前创建的令牌，添加到最后。这将允许我验证用户是他们在点击链接并转到网站重置密码时所说的用户。

**第 4 步：发送邮件**

![](https://cdn-images-1.medium.com/max/2624/1*_w-0XM0OV5DLmylhmOh5vg.png)

这个文件的最后一步实际上是把我之前创建的代码片段放在一起: `transporter`、`mailOptions` 和 `token` 并且使用 Nodemailer 的 `sendMail()` 功能。如果它工作了，我会得到返回码为 200 的响应，然后我用这个响应来触发对客户端的成功调用，如果出错，我会在日志里记录下错误以便查看哪里出错了。

### 启用 Gmail 发送重置电子邮件

在设置传输器电子邮件时，至少在使用 Gmail 时，需要注意一个额外的陷阱，即所有电子邮件都是从传输器发送过来的。

为了能够从帐户发送电子邮件，必须禁用两步验证，并且必须将 “Allow less secure apps” 的设置切换为开启。见下面的截图。为此，从[这里](https://myaccount.google.com/lesssecureapps)进入了设置中心，并将其打开。

现在，我可以很顺利地发送重置电子邮件。如果您遇到问题，请查看 Nodemailer 的常见问题解答以获取更多帮助。

![这是你应该看到的屏幕，你可以在其中打开不太安全的应用程序。这也是使用虚拟电子邮件帐户而不是实际的 Gmail 帐户的另一个原因。](https://cdn-images-1.medium.com/max/4152/1*R-Ee6gv6v__lBvP0bcuHZg.png)

### 前端代码 —— 更新密码屏幕

太棒了，现在用户应该能在邮箱中收到重置电子邮件了，看起来像这样。

![这是一个简单的电子邮件，但它完成了我需要它做的事情。](https://cdn-images-1.medium.com/max/4844/1*B-_8dljYLsa7ewl22-1Udg.png)

如果你有留意的话，第三行是一个指向我的网站（在本地 3031 端口运行）的链接，另一个叫做“重置”的页面，后面接着我在第一步中使用 Node.js `crypto` 模块生成的一个散列令牌。

当用户单击此链接时，他们将被定向到应用程序中名为“密码重置屏幕”的新页面，该页面只能使用有效的令牌访问。如果令牌已过期或无效，用户将看到一个错误屏幕，其中包含回家或尝试发送新的密码重置电子邮件的链接。

这是重置屏幕的 React 代码。

**`ResetPassword.js`**

![](https://cdn-images-1.medium.com/max/3188/1*Gia0EtrP3EWK9NT5TjAtlw.png)

这里有三个主要的组件来完成繁重的工作。

**初始组件装载了生命周期方法**

![](https://cdn-images-1.medium.com/max/2564/1*ArzihAeJ6jv95v-dGMyeBQ.png)

一旦进入页面中，这个方法就会被触发。它从 URL 查询参数中提取令牌，并将其传给服务器的 `reset` 路由来验证令牌是否合法。

然后，如果服务器响应 “a-ok”，这个令牌是有效的并会与用户关联，如果响应 “no”，那么这个令牌会因为某些原因而失效。

**更改密码功能**

![](https://cdn-images-1.medium.com/max/2604/1*iJgW4i4pBn18lCMGLfWlhQ.png)

如果用户经过身份验证并允许重置密码，则会触发这个方法。它还会访问服务器上的特定路由 `updatePasswordViaEmail`（我这么做，是因为我也为用户提供了另外一个路由，让他们在已登录的状态下更改密码），并且一旦将更新的密码保存到数据库中，成功响应的消息就会被发送回客户端。

**渲染方法**

![](https://cdn-images-1.medium.com/max/2564/1*wmFa05AS8CE-pYLzhOwKpg.png)

该组件的最后一部分是 `render` 方法。最初，在验证令牌的有效性时，会显示 `loading` 消息。

如果链接在某种程度上是无效的，则 `error` 消息将显示在屏幕上，其中包含返回主屏幕或忘记密码页面的链接。

如果用户有权重置密码，他们会有一个输入新的密码输入功能的叫做 `updatePassword()` 方法，一旦服务器响应成功更新密码，`update` 布尔值会被设置为 true，并显示 `Your password has been successfully reset...` 的消息和登录按钮。

### 后端代码 —— 重置密码和更新密码

好的，这个项目已经到了最后的阶段。这是你在服务端需要的最后两个路由。这两个方法对应我刚才在 React `ResetPassword.js` 组件中在客户端进行的两种方法。

**`resetPassword.js`**

![](https://cdn-images-1.medium.com/max/2564/1*wrTzgtWpXLeDyut3JDFw2g.png)

这是在 `componentDidMount` 客户端上调用生命周期方法的路由。它检查从链接的查询参数的 `resetPasswordToken` 和日期时间戳传递的内容，以确保一切正常。

你会注意到 `resetPasswordExpires` 参数具有奇怪的 `$gt: Date.now()` 参数。这是一个 [运算符别名比较器](http://docs.sequelizejs.com/manual/tutorial/querying.html#operators-aliases)，[Sequelize](http://docs.sequelizejs.com/) 允许我使用它，所有的 `$gt:` 代表的都是“优先级高于”，无论它和谁去比较，在这种情况下，它将当前时间与发送重置密码电子邮件时保存到数据库的到期时间戳进行比较，以确保在发送电子邮件后不到一小时内重置密码。

只要两个参数都对该用户有效，就会向客户端发送成功的响应，并且用户可以继续密码重置。

**`updatePasswordViaEmail.js`**

![](https://cdn-images-1.medium.com/max/2568/1*9DsfHUnYVyRXoCJt7S7bFA.png)

这是用户提交他的密码以进行更新时调用的第二条路由。

再一次，我发现数据库中的用户（`username` 从 `reset` 上的路由传回客户端并保持在应用程序的状态，直到调用更新函数），我使用我的 `bcrypt` 模块散列新的密码（就像我的 Passport.js 中间件在最初将新用户写入数据库时执行），用新的散列值更新数据库中该用户的 `password`，并将 `resetPasswordToken` 和 `resetPasswordExpires` 列设置为 null，因此同一个链接不能多次使用。

一旦完成，服务器就会给客户端返回一个状态码为 200 的响应，其中包含成功消息 “Password updated”。

你已经通过电子邮件成功重置用户的密码。并不难。

### 结论

乍一看，通过电子邮件链接重置用户密码似乎有点令人生畏。但 Nodemailer 帮我们简化了一个主要部分（处理电子邮件）。一旦完成，它只是服务器端的几条路由，并在客户端输入，以便为用户更新密码。

几周之后再回来（我的博客）看看，我会写关于使用 Puppeteer 和 headeless Chrome 进行端到端的测试或其它和 web 开发相关的内容，所以请关注我，以免你错过。

感谢阅读，我希望这能让你了解如何使用 Nodemailer 为 MERN 应用程序发送密码重置电子邮件。点赞和分享我将会非常感谢。

**如果您喜欢阅读本文，您可能还会喜欢我的其他一些博客：**

* [调试 Node.js 的绝对最简单的方法 —— 使用 VS Code](https://itnext.io/the-absolute-easiest-way-to-debug-node-js-with-vscode-2e02ef5b1bad)
* [使用 React 在 JavaScrip t应用程序中实现 JSON Web Tokens 和 Passport.js](https://itnext.io/implementing-json-web-tokens-passport-js-in-a-javascript-application-with-react-b86b1f313436)
* [Sequelize：像 Mongoose 但是相对于 SQL](https://medium.com/@paigen11/sequelize-the-orm-for-sql-databases-with-nodejs-daa7c6d5aca3)

***

**参考资料和更多资源:**

* Nodemailer: [https://nodemailer.com/about/](https://nodemailer.com/about/)
* Nodemailer, Github: [https://github.com/nodemailer/nodemailer](https://github.com/nodemailer/nodemailer)
* Nodemailer, NPM: [https://www.npmjs.com/package/nodemailer](https://www.npmjs.com/package/nodemailer)
* 使用 Nodemailer Repo 的MERN应用程序: [https://github.com/paigen11/mysql-registration-passport](https://github.com/paigen11/mysql-registration-passport)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
