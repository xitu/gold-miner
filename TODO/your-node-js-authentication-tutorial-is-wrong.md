
  > * 原文地址：[Your Node.js authentication tutorial is (probably) wrong](https://medium.com/@micaksica/your-node-js-authentication-tutorial-is-wrong-f1a3bf831a46)
  > * 原文作者：[micaksica](https://medium.com/@micaksica)
  > * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
  > * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/your-node-js-authentication-tutorial-is-wrong.md](https://github.com/xitu/gold-miner/blob/master/TODO/your-node-js-authentication-tutorial-is-wrong.md)
  > * 译者：[MuYunyun](https://github.com/MuYunyun)
  > * 校对者：[jasonxia23](https://github.com/jasonxia23)、[lampui](https://github.com/lampui)

  # 关于 Node.js 的认证方面的教程（很可能）是有误的

  我搜索了大量关于 Node.js/Express.js 认证的教程。所有这些都是不完整的，甚至以某种方式造成安全错误，可能会伤害新用户。当其他教程不再帮助你时，你或许可以看看这篇文章，这篇文章探讨了如何避免一些常见的身份验证陷阱。同时我也一直在 Node/Express 中寻找强大的、一体化的解决方案，来与 Rails 的 [devise](https://github.com/plataformatec/devise) 竞争。

> **更新 (8.7)**: 在他们的教程中，RisingStack 已经声明，[不要再以明文存储密码](https://github.com/RisingStack/nodehero-authentication/commit/9d69ea70b68c4971466c64382e5f038e3eda8d8a)，在示例代码和教程中选择使用了 bcrypt。

> **更新 (8.8)**: 编辑标题 **关于 Node.js 的认证方面的教程（很可能）是有误的**，这篇文章已经对这些教程中的一些错误点进行了改正。

在业余时间，我一直在挖掘各种 Node.js 教程，似乎每个 Node.js 开发人员都有一个博客用来发布自己的教程，讲述如何以**正确的方式**做事，或者更准确地说，**他们做事的方式**。数以千计的前端开发人员被投入到服务器端的 JS 漩涡中，试图通过拷贝式的操作或无偿使用的 **npm install** 将这些教程中的可操作的知识拼凑在一起，从而在外包经理或广告代理商给出的期限内完成开发。

Node.js 开发中一个更有问题的事情就是身份验证的程序很大程度上是开发人员在摸索中完成开发的。事实上 Express.js 世界中的认证解决方案是 [Passport](http://passportjs.org/)，它提供了许多用于身份验证的**策略**。如果你想要一个类似于 [Plataformatec 的 devise](https://github.com/plataformatec/devise) 的 Ruby on Rails 的强大的解决方案，你可能会对 [Auth0](https://auth0.com/) 感兴趣，它是一个使认证成为服务的开创项目。

与 Devise 相比，Passport 只是身份验证中间件，不会处理任何其他身份验证：这意味着 Node.js 开发人员可能会定制自己的 API 令牌机制、密码重置令牌机制、用户认证路由、端点、多种模板语言，因此，有很多教程专门为你的 Express.js 应用程序设置 Passport，但是几乎没有完全正确的教程，没有一个正确地实现出 Web 应用程序所需的完整堆栈。

> **请注意**: 我不是故意针对这些教程的开发人员，而是使用他们的身份验证所存在的漏洞后会让自己的身份验证系统产生安全问题。如果你是教程作者，请在更新教程后随时与我联系。让 Node/Express 成为开发人员使用的更安全的生态系统。

### 错误一：凭证存储

让我们从凭证存储开始。存储和调用凭证对于身份管理来说是非常标准的，而传统的方法是在你自己的数据库或应用程序中进行存储或者调用。凭证，作为中间件，简单地说就是“这个用户可以通过”或“这个用户不可以通过”，需要 [passport-local](https://github.com/jaredhanson/passport-local) 模块来处理在你自己的数据库密码存储，这个模块也是由 Passport.js 作者写的。

在我们进入这个教程的兔子洞之前，请记住 OWASP 的[密码存储作弊表](https://www.owasp.org/index.php/Password_Storage_Cheat_Sheet)，它归结为“存储具有独特盐和单向自适应成本函数的高熵密码”。或者先看下 Coda Hale 的 [bcrypt meme](https://codahale.com/how-to-safely-store-a-password/)，即使[有一些争论](https://security.stackexchange.com/a/6415)。

作为一个新的 Express.js 和 Passport 用户，我第一个要讲的地方将是 **passport-local** 本身的示例代码，[十分感谢 passport 官方提供了一个可以克隆和扩展的 Express.js 4.0 应用程序示例](https://github.com/passport/express-4.x-local-example)，从而我可以克隆和扩展。但是，如果我只是拷贝这个例子，我讲不了太多，因为没有数据库支持的例子，它假设我只是使用一些设置好的帐户。

没关系，对吧？**这只是一个内联网应用程序**，开发人员说，**下周将分配给我另外四个项目**。当然，该示例的密码不会以任何方式散列，[并且与本示例中的验证逻辑一起存储在明文中](https://github.com/passport/express-4.x-local-example/blob/master/db/users.js)。在这一点上，甚至没有考虑到凭证存储。

让我们来 google 另一个使用 **passport-local** 的教程。我发现[这个来自 RisingStack 的一个叫“Node Hero”系列的快速教程](https://blog.risingstack.com/node-hero-node-js-authentication-passport-js/)，但从这个教程中我没找到很有用的帮助。他们也[在 GitHub 上提供了一个示例应用程序](https://github.com/RisingStack/nodehero-authentication)，
但[它与官方的问题相同](https://github.com/RisingStack/nodehero-authentication/blob/7f808f5c8ea756155099b7b4a88390c356cf31be/app/authentication/init.js#L8)。（Ed。8/7/17：RisingStack [**现在使用 bcrypt**](https://github.com/RisingStack/nodehero-authentication/commit/9d69ea70b68c4971466c64382e5f038e3eda8d8a) 在他们的教程应用。）

接下来，[这是第四个结果](http://mherman.org/blog/2015/01/31/local-authentication-with-passport-and-express-4/)，来自写于 2015 年的 Google 产出的 **express js passport-local 教程**。它使用 Mongoose ODM，实际上从我的数据库读取凭据。 这一个教程算是比较完整的，包括集成测试，是的，你可以使用另一个样板。但是，Mongoose ODM [也存储类型为 **String** 的密码](https://github.com/mjhea0/passport-local-express4/blob/master/models/account.js#L7)，所以这些密码也存储在明文中，只是这一次在 MongoDB 实例上。（[人人都知道 MongoDB 实例通常是非常安全的](https://www.shodan.io/report/nlrw9g59)）

你可以指责我择优挑选教程，如果择优挑选意味着从 Google 搜索结果的第一页进行选择，那么你会是对的。让我们选择 [TutsPlus 上更高排名的 **passport-local** 教程](https://code.tutsplus.com/tutorials/authenticating-nodejs-applications-with-passport--cms-21619)。这一个更好，因为[它使用 brypt 的因子为 10 的密码哈希](https://github.com/tutsplus/passport-mongo/blob/master/passport/login.js)，并使用 **process.nextTick** 延迟同步 bcrypt 哈希检查。Google 的最高成绩[来自 scotch.io 的教程](https://scotch.io/tutorials/easy-node-authentication-setup-and-local)，也使用 [成本因子较低为 8 的 bcrypt](https://github.com/scotch-io/easy-node-authentication/blob/local/app/models/user.js#L37)。这两个值都很小，但是 8 真的很小。大多数 **bcrypt** 库现在使用 12。[选择 8 作为成本因子是因为管理员帐户是**十八年前的**](https://www.usenix.org/legacy/publications/library/proceedings/usenix99/provos/provos_html/node6.html)，这个因子数在那时候就能满足需求了。

除了密码存储之外，这些教程都不会实现密码重置功能，这将作为开发人员的一个挑战，并且它附带着自己的陷阱。

### 错误二：密码重置

密码存储的一个姐妹安全问题是密码重置，并且没有一个顶级的基础教程解释了如何使用 Passport 来完成此操作。你必须另寻他法。

有一千种方法去搞砸这个问题。我见过的最常见人们重新设置密码错误是：

1. **可预见的令牌。** 基于当前时间的令牌是一个很好的例子。不良伪随机数发生器产生的令牌相对好些。
2. **存储不良。** 在数据库中存储未加密的密码重置令牌意味着如果数据库遭到入侵，那些令牌就是明文密码。使用加密安全的随机数生成器生成长令牌会阻止对重置令牌的远程强力攻击，但不会阻止本地攻击。重置令牌是凭据，应该这样处理。
3. **无令牌到期。** 令牌如果没有到期时间会给攻击者更多的时间利用重置窗口。
4. **无次要数据验证。**安全问题是**重置**的事实上的数据验证。当然，开发商必须选择一个**好的安全问题**。[安全问题有自己的问题](https://www.kaspersky.com/blog/security-questions-are-insecure/13004/)。虽然这可能看起来像安全性过度，电子邮件地址是你拥有的，而不是你认识的内容，并且会将身份验证因素混合在一起。你的电子邮件地址成为每个帐户的关键，只需将重置令牌发送到电子邮件。

如果你是第一次接触这些内容，请尝试 OWASP 的[密码重置工作表](https://www.owasp.org/index.php/Forgot_Password_Cheat_Sheet)。让我们回到 Node 中看看它为此提供给我们的东西。

我们将转移到 **npm** 一秒钟，并[重新查找密码重置](https://www.npmjs.com/search?q=password%20reset&amp;page=1&amp;ranking=popularity)，看看是否已有人做到这一点。有一个已有五年历史的 package（通常意味着它很棒）。在 Node.js 的时间轴上，这个模块就像是侏罗纪时代的，如果我想要鸡蛋里挑骨头，[Math.random() 可以在 V8 中预测](https://security.stackexchange.com/questions/84906/predicting-math-random-numbers)，因此[它不应该用于令牌生成码](https://github.com/substack/node-password-reset/blob/master/index.js#L73)。此外，它不使用 Passport，所以我们继续前进。

Stack Overflow 上获取不了太多的帮助，因为一个名叫 Stormpath 的公司的开发人员喜欢在可以想象到的每一个跟这个相关的的帖子上都插入他们的 IaaS 启动教程。[他们的文档也随处可见](https://docs.stormpath.com/client-api/product-guide/late%20Passwordword_reset.html)，他们也有[关于密码重置的博客广告](https：//stormpath.com/blog/the-pain-of-password-reset)。但是，所有这一切都随着 Stormpath 的停业已经停止了，它们公司于 2017 年 8 月 17 日[完全关闭](https://stormpath.com/)。

好的，回到谷歌，这里似乎存在唯一的教程。我们找到了 Google 搜索 **express passport 密码重置的**[第一个结果](http://sahatyalkabov.com/how-to-implement-password-reset-in-nodejs/)。还是我们的老朋友 **bcrypt**。文章中使用了更小的成本因子 5，这远远低于了现代使用的成本因素。

但是，与其他教程相比，这篇教程相当实用，因为它使用 **crypto.randomBytes** 来生成真正的随机标记，如果不使用它们，则会过期。然而，上述实践中的 ＃2 和 ＃4 与这个全面的教程不符，因此密码令牌本身容易受到认证错误，凭据存储的影响。

幸运的是，由于重置到期，这是有限的使用。但是，如果攻击者通过 BSON 注入对数据库中的用户对象进行读取访问，或由于配置错误，可以自由访问 Mongo，这些令牌将非常危险了。攻击者只需为每个用户发出密码重置，从 DB 读取未加密的令牌，并为用户帐户设置自己的密码，而不必经历使用 GPU 装备对 bcrypt 散列进行的昂贵的字典攻击过程。

### 错误三：API 令牌

API 令牌是凭据。它们与密码或重置令牌一样敏感。大多数开发人员都知道这一点，并尝试将他们的 AWS 密钥、Twitter 秘密等保留在他们胸前，但是这似乎并没有转移到被编写的代码中。

让我们使用 [JSON Web 令牌](https://jwt.io/)获取 API 凭据。拥有一个无状态的、可添加黑名单的、可自定义的令牌比十年来使用的旧 API 密钥/私密模式更好。也许我们的初级 Node.js 开发人员曾经听说过 JWT，或者看到过 **passport-jwt**，并决定实施 JWT 策略。无论如何，接触 JWT 的人都会或多或少地受到 Node.js 的影响。（尊敬的[Thomas Ptacek 会认为 JWT 不好](https://news.ycombinator.com/item?id=13866883)，但恐怕船已经在这里航行。）

我们在 Google 上搜索 **express js jwt**，然后找到 [Soni Pandey](https://medium.com/@pandeysoni) 的教程[使用 Node.js 中的 JWT（JSON Web 令牌）进行用户验证](https://medium.com/@pandeysoni/user-authentication-using-jwt-json-web-token-in-node-js-using-express-framework-543151a38ea1)，。不幸的是，这教程实际上并不帮助我们，因为它没使用凭证，但是当我们在这里时，我们会很快注意到凭据存储中的错误：

1. 我们将 [以明文形式将 JWT 密钥存储在存储库中](https://github.com/pandeysoni/User-Authentication-using-JWT-JSON-Web-Token-in-Node.js-Express/blob/master/server/config/config.js#L13)。
2. 我们将[使用对称密码存储密码](https://github.com/pandeysoni/User-Authentication-using-JWT-JSON-Web-Token-in-Node.js-Express/blob/master/server/config/common.js#L54)。这意味着我可以获得加密密钥，并在发生违规时解密所有密码。加密密钥与 JWT 秘密共享。
3. 我们将使用 AES-256-CTR 进行密码存储。我们不应该使用 AES 来启动，而且这种操作模式没有什么帮助。我不知道为什么选择这个特别的模式，但是[单一的选择让密文具有延展性](https://crypto.stackexchange.com/a/33861)。

让我们回到 Google，接着寻找下一个教程。Scotch，在 passport-local 教程中做了一个密码存储的工作，比如[只是忽略他们以前告诉你的东西，并将密码存储在明文中](https://github.com/scotch-io/node-token-authentication/blob/master/app/models/user.js#L7)。

好吧，我们会给出一个简短的凭证教程，但这并不能帮助只是拷贝的开发者。因为更有趣的是，这个教程[将这个 mongoose User 对象序列化到 JWT 中](https://github.com/scotch-io/node-token-authentication/blob/master/server.js#L81)。

让我们克隆 Scotch 的这个资源库，按照说明进行运行。可以无视一些来自 Mongoose 的警告，我们可以输入 [**http://localhost:8080/setup**](http://localhost:8080/setup) 来创建用户，然后通过使用 “Nick Cerminara” 和 “password” 的默认凭证调用 /api/authenticate 拿到令牌。这个令牌返回并显示在了 Postman 上。

![](https://cdn-images-1.medium.com/max/1600/1*wvb2F4-Rx4I1ji2EJIyXZg.png)

从 Scotch 教程返回的 JWT 令牌。

请注意，JSON Web 令牌已签名但未加密。这意味着两个时期之间的大斑点是一个 Base64 编码对象。快速解码后，我们得到一些有趣的东西。

![](https://cdn-images-1.medium.com/max/1600/1*5KcDyNtIfWXVe9uVUD0A_g.png)

我喜欢在明文的密码中使用令牌。
现在，任何一个包括存储在 Mongoose 模型**甚至过期的令牌**都有你的密码。鉴于这个来自HTTP，我可以把它从线上找出来。

下一个教程怎么样呢？下一个教程，[**针对初学者的 Express、Passport 和 JSON Web 令牌（jwt)**](https://jonathanmh.com/express-passport-json-web-token-jwt-authentication-beginners/)，包含相同的信息泄露漏洞。下篇教程来自 [SlatePeak 的一篇做了同样的序列化文章](http://blog.slatepeak.com/creating-a-simple-node-express-api-authentication-system-with-passport-and-jwt/)。在这一点上，我放弃了阅读。

### 错误四：限速

如上所述，我没有在任何这些身份验证教程中找到关于速率限制或帐户锁定的问题。

没有速率限制，攻击者可以执行在线字典攻击，比如运行 [Burp Intruder](https://portswigger.net/burp/help/intruder_using.html) 等工具，去获得获取访问密码较弱的帐户。帐户锁定还可以通过在下次登录时要求用户填写扩展登录信息来帮助解决此问题。

请记住，速率限制还有助于可用性。**跨平台文件加密工具**是一个 CPU 密集型功能，没有速率限制功能，使用跨平台文件加密工具会让应用程序拒绝服务，特别是在 CPU 高数运行时。比如用户注册或检查登录密码的多个请求尽管是轻量级的 HTTP 的请求，但是会花费服务器大量的昂贵时间。

虽然我没有教程可以证明这点，但 Express 有很多速率限制的技术，例如 [express-rate-limit](https://github.com/nfriedly/express-rate-limit)，[express-limiter](https://www.npmjs.com/package/express-limiter) 以及 [express-brute](https://github.com/AdamPflug/express-brute)。我不能评价这些模块的安全性，甚至没有看过它们；无论你的负载平衡用的是什么，通常我[推荐在生产中运行逆向代理](https://expressjs.com/en/advanced/best-practice-performance.html#use-a-reverse-proxy)，并允许[由 nginx 限制请求处理速率](https://www.nginx.com/blog/rate-limiting-nginx/)。

### 身份验证是困难的

我相信这些有错误的教程开发人员会辩解说，“这只是为了解释基础！没有人会在生产中这样做的！”但是，我再三强调了**这是多么错误**。当你的教程中的代码被放在这里时，人们就会参考并使用你的代码，毕竟，你比他们有更多的专业知识。

**如果你是初学者，请不要信任你的教程。** 拷贝教程中的例子可能会让你、你的公司和你的客户在 Node.js 世界中遇到身份验证问题。如果你真的需要强大的生产完善的一体化身份验证库，那么可以使用更好的手段，比如使用具有更好的稳定性，而且更加经验证的 Rails/Devise。

Node.js 生态系统虽然容易接近，但对需要匆忙编写部署于生产环境的 Web 应用程序的 JavaScript 开发人员来说，仍然有很多尖锐的未解决的点。如果你有前端的背景，不知道其他的编程语言，我个人认为，使用 Ruby 是一个不错的选择，毕竟站在巨人的肩膀上比从头开始学习这些类型的东西要容易。

如果你是教程作者，请更新你的教程，**特别是**样板代码。这些代码将可能被其他人拷贝到生产环境中的 web 应用程序。

如果你是一个 Node.js 的铁杆使用者，希望你在这篇文章中学到一些关于使用用凭证验证身份的知识。你可能会遇到什么问题。这篇文章中我还没有找到完美的方法来完全避免以上错误。为你的 Express 应用程序增加凭证验证不应该是你的工作。应该有更好的办法。

如果你有兴趣更好地维护 Node 生态系统，请在 Twitter 上发送给我 [@_micaksica](https://twitter.com/_micaksica)。

  ---

  > [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
