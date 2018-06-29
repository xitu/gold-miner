> * 原文地址：[JWT: The Complete Guide to JSON Web Tokens](https://blog.angular-university.io/angular-jwt/)
> * 原文作者：[angular-university](https://blog.angular-university.io)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/angular-jwt.md](https://github.com/xitu/gold-miner/blob/master/TODO/angular-jwt.md)
> * 译者：[rottenpen](https://github.com/rottenpen)
> * 校对者：[FateZeros](https://github.com/FateZeros)，[tvChan](https://github.com/tvChan)

# JWT: JSON Web Tokens 全方位指南

这篇推送是手把手教你在 Angular 应用中使用基于 JWT 验证用户身份两部曲的第一部分（也适用于企业应用程序）

本文的目标是先让我们了解 **JSON Web Tokens（或 JWT）具体是如何工作的**，包括如何将它们用于Web应用程序中的用户身份验证和会话管理。

第二部分，我们将会看到在具有特定上下文的Angular应用中，基于JWT的认证是怎样运用的，但这篇文章只关于 JWTs。

### 为什么需要深入探讨 JWT

对了解 JWTs 至关重要的几个点：

* 实现一种基于 JWT 的认证解决方案
* 各种实际故障排除：理解错误消息，堆栈跟踪
* 选择第三方库并理解他们的文档
* 设计一个内部认证解决方案
* 选择和配置第三方认证服务

即使准备选择使用基于 JWT 的认证解决方案时，仍然会涉及一些编码，特别是在客户端上，还有在服务端上。

在这篇文章的最后，您将深入了解 JWT，包括深入了解他们所基于的密码原语，这些原语在许多其他安全用例中都有使用。

你会知道什么时候用 JWT，为什么会用到它，会了解 JWT 的格式以便手动排除签名故障，还有知道一些在线/Node 工具来实现它。

使用这些工具，您将能够排除许多与 JWT 有关的错误情况。所以，我们不妨开始深入探索我们的 JWT！

### 为什么是 JWTs

JWTs 最大的优势（相对于用户会话管理中使用内存里的随机令牌）是它们可以把认证逻辑委托到第三方服务器：

* 可以是一个集中的内部开发身份验证服务器
* 更典型的是一个商业产品能像 LDAP 服务器一样发布 JWTs
* 甚至可以是一个完全外部的第三方认证供应商，例如 Auth0

外部认证服务器 _可以完全独立于我们的应用服务器_，并且不必与网络的其他元素共享任何密钥，也就是说，在我们的应用服务器上根本就没有密钥，别说是丢失或被盗了。

另外，身份验证服务器或应用服务器之间不需要任何直接的实时链接来进行身份验证（稍后将进一步讨论）。

此外，应用服务器可以 **完全无状态**，因为不需要在请求之间保留内存中的令牌。身份验证服务器可以发出令牌，将其发送回，然后立即丢弃它！

此外，也**不需要在应用程序数据库的存储密码摘要**，因此能被盗的东西更少，而与安全性相关的bug也会更少。

在这个点上，你可能会想：我有一个公司内部的应用，JWTs 是不是一个很好的解决方案？对，在这篇文章的最后一部分会讲到 jwts 在典型的预认证企业中的使用情况。

### 正文目录

在这文章中，我们将涵盖如下章节：

* 什么是JWTs
* JWT的在线认证工具
* JSON Web Token 的规范
* 简单地说下什么是 JWTs：Header, Payload, Signature
* Base64Url （vs Base64）
* 使用JWT的用户会话管理：主体和过期时间
* HS256 JWT 签名 - 是如何运作的
* 数字签名
* hash 函数和 SHA-256
* RS256 JWT 签名 - 我们来讨论下公钥加密
* RS256 vs HS256 签名 - 哪一个更好？
* WKS （JSON Web Key Set）密钥集端点
* 如何实现 JWT 签名周期性的密钥刷新
* jwt在企业中的应用
* 结语

### 什么是JWTs

JSON Web Token（ JWT ）只是一个包含特定声明的 JSON 有效内容。 JWTs的 *关键属性* 在于确认令牌本身是否有效。

我们不需要连接第三方服务器，也不需要在请求间保存JWTs到内存中，来确认它们携带的声明是有效的。

一个 jwt 分为3个部分：头部 header, 载荷 payload, 签名 signature。让我们从载荷开始一个个介绍吧。

#### JWT 的 Payload 长什么样子？

JWT 的载荷只是一个简单的 JavaScript 对象。这是一个载荷的例子：

在这种情况下，一个载荷包含了关于给定用户的身份信息，但一般情况下，载荷可以是其他任何东西例如包括银行转账的信息。

对载荷的内容是没有限制，但是重点是要知道，**JWT 是不加密的**。所以我们放入 token 的任何信息对于拦截 token 的任何人都是可读的。

因此重点是不要在载荷上放任何用户信息给攻击者直接利用。

#### JWT Headers - 为什么它们那么必不可少？

接收方通过检查签名确认载荷的内容。但是签名有多种类型，所以例如接收者需要知道的事情之一是要查找签名是哪种类型。

这种关于令牌本身的技术元数据信息被放置在一个单独的 JavaScript 对象中，并与载荷一起发送。

这个单独的JSON对象被称为JWT头，这里是一个有效头的例子：

正如我们所看到的，它也只是一个简单的 Javascript 对象。在这个头文件中，我们可以看到用于这个 JWT 的签名类型是 RS256。

很快你会看到更多类型的签名，现在我们先重点了解签名的存在对于身份验证的影响。

#### JWT 签名 - 它们是怎么被运用到用户认证的？

JWT的最后一部分是签名，它是一个消息认证码（或 MAC）。JWT 的签名只能由同时拥有载荷（加上头）和密钥的人生成。

下面是如何使用签名来确保身份验证：

* 用户将用户名和密码提交给身份验证服务器，这可能是我们的应用程序服务器，但它通常是一个单独的服务器。
* 验证服务器验证用户名和密码组合，并创建一个 JWT 令牌，其中的载荷包含了用户技术标识符和到期时间戳
* 身份验证服务器随后获得一个密钥，并使用它来标记头部和载荷并将其发送回用户浏览器（稍后我们将介绍签名如何工作的具体细节） 
* 浏览器发送到我们应用服务器的每一个 HTTP 请求都会携带着已签名的 JWT
* 已签名的 JWT 扮演着临时用户凭证，它取代了永久用户凭证，即用户名和密码的组合

看看这里我们的应用服务器和JWT令牌做了什么：

* 我们的应用服务器检查JWT签名并确认确实拥有密钥的用户签署了这个特定的Payload
* 载荷通过技术标识符识别特定的用户
* 只有认证服务器拥有私钥，并且认证服务器仅向提交正确密码的用户发出令牌
* 因此我们的应用程序服务器可以安全地确定这个令牌确实是由认证服务器给予这个特定用户的，这意味着它的确是那个有正确的密码的用户
* 假设这令牌是属于该用户，服务器将继续处理 http 请求。

攻击者冒充用户的唯一方法是窃取其用户名和个人登录密码，或者从认证服务器窃取密钥。

正如我们看到的，签名才是 JWT 的关键部分！

该签名使得完全无状态的服务器能够确定特定的 HTTP 请求属于特定的用户，可以只看请求本身中存在的JWT令牌，并且不强制每次发送请求都带上密码。

#### JWTs 的目标是使服务器无状态吗？

使服务器无状态是只一个不错的副作用，JWTs 关键的好处是，发送JWT的服务器和验证JWT的服务器可以是两个完全独立的服务器。

这意味着我们只需要最小的验证逻辑，即检查 JWT 就能胜任这个水平上服务器的身份验证工作。

可能一个认证服务器将为一群应用提供授权登录/注册服务。

这意味着应用程序服务器更简单，更安全，因为许多身份验证功能都集中在身份验证服务器上，并在应用程序之间重复使用。

现在我们已经知道 JWT 是如何启用无状态的第三方认证的，让我们来详细介绍它们的实现。

### 一个JSON Web Token长什么样子呢？

为了了解JWT的3个组成部分，这里有一个展示代码和一个在线 JWT 验证工具的[视频](https://www.youtube.com/embed/4dmvQlBmr34)



让我们看一个JWT的案例，取自在线JWT验证工具[jwt.io](https://jwt.io):

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWV9.TJVA95OrM7E2cBab30RMHrHDcEfxjoYZgeFONFh7HgQ
```

你可能会想到，JSON 对象去哪了？？我们马上就带它们回来。事实上，在这篇文章的结尾，你将深入了解这个奇怪的字符串的每一个方面。

让我们看一下它：我们能看到它被点（.）分成三个独立的部分。第一部分是在第一个点之前的 JWT 头部：

```
JWT Header: 
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9
```

第二部分是在第一点和第二个点之间的载荷：

```
JWT Payload: eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWV9
```

最后一部分是，第二个点后面的签名：

```
JWT Signature: 
TJVA95OrM7E2cBab30RMHrHDcEfxjoYZgeFONFh7HgQ
```

如果你想要确认这部分信息确实是存在的，只要把整句 JWT 字符串复制到官方的 JWT 验证工具[jwt.io](https://jwt.io/)即可。

但这些字符是什么，我们应该怎么读取JWT中的信息来排查问题呢？jwt.io 是怎么取回 JSON 对象的？

### 是 Base64 还是 Base64Url？

不管你相不相信，载荷，头部，还有签名仍然是以可读形式存在着。

我们只是想确保当我们发送 JWT 时，在网络上不会有那些讨厌的（“乱码” `qÃ®Ã¼Ã¶：Ã`）字符编码问题。

发生这问题是因为世界各地不同的电脑都通过不同的编码来处理字符串，例如 UTF-8, ISO 8859-1等等。

字符串这种问题比比皆是：当我们在任何平台都有一个字符串时，我们都会对其进行编码。哪怕我们没有指定任何编码：

* 要么使用操作系统默认编码
* 要么从服务器的配置参数中获取

我们希望在网络上发送的的字符串不必担心这些问题，因此我们选择了一个所有常见的字符编码都能通过同样方式处理的字符子集，Base64 编码格式应运而生。

### Base64 vs Base64Url

但我们可以看到 JWT 实际上不是 Base64 而是 **Base64Url**。

这就像 base64，但上演着不同的角色，举个真实的例子：如果我们用一个第三方登录页，然后重定向到我们的网站，我们可以轻易地把 JWT 当作 URL 参数发送出去。

所以，如果我们在这个 JWT 提取第二部分内容（在第一个点和第二个点之间），我们得到的载荷是长这样子的：

```
eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWV9
```

让我们在在线解码器上运行它，例如[这个解码器](https://www.base64decode.org/):

我们得到一个 JSON 载荷！对于故障排除来说，它是个很棒的东西。我们也用 Base64 解码，在此之后，让我们马上总结一下到目前为止我们已经：

> 总结：我们现在有一个可读性良好的 JWT 头和载荷：它们只是两个 JavaScript 对象，转换为 JSON，使用 base64url 进行编码的内容会被点分隔开。

这种格式实际上只是通过网络发送 JSON 的一种实用方式。

这段视频展示了如何创建和验证 JWT 的一些代码，包括头和载荷部分细节：[vedio](https://www.youtube.com/embed/c5p4ttLXbgo)



在进入签名之前，让我们讨论一下，在用户身份验证的具体示例中，我们将什么放进载荷中。

### JWT 用户会话管理：主题和过期

正如我们已经提到的，一个 JWT 的载荷原则上可以是任何东西，而不仅仅是用户认证信息。但使用 JWT 认证是常见的情况，这里有两个载荷特性：

* 用户验证
* 会话过期

这是一对最常用的JWT载荷特性：

以下是这些标准属性的含义：

* `iss` 指的是发行实体，在这种情况下是我们的认证服务器
* `iat` 是JWT创建的时间戳（从 Epoch 时间纪元开始的秒数）
* `sub` 包含用户的验证码
* `exp` 包含令牌的过期时间戳

这就是所谓的 Bearer Token，它隐含的意思是：

> 认证服务器确认这个令牌的主人的ID被定义了 `sub` 的属性：让这个用户访问

现在我们已经充分理解到载荷在典型的用户验证中是怎么使用的了，现在让我们重点了解下签名。

JWT 的签名有很多类型，本文将介绍两种：HS256 和 RS256。那我们从第一个签名类型开始：HS256。

### HS256 的 JWT 数字签名 - 它是怎么工作的？

正如大多数签名，HS256 数字签名是基于一个特殊类型的函数：加密 hash 函数。

这听起来很吓人，但这是一个值得学习的概念：这一知识点不管在过去的20年还是将来很长一段时间都很有用。很多实际的安全措施都围绕着 hash，它们在 Web 应用安全无处不在。

好消息是，我们可以通过几段话解释清楚关于 hashing （作为 Web 应用开发者）所需要知道的一切，这就是我们要做的。

我们将分两部来做：首先，我们将讨论 hash 函数是什么，然后我们将看到如何将这样的函数和密码结合生成消息验证代码（数字签名）。

在本章的最后，你可以自己使用在线诊断工具和 npm 包复现这个 HS256 JWT 签名。

#### 什么是 hash 函数？

hash 函数是一种特殊类型的函数，它具有一些非常独特的属性：它具有许多实际有用的用例，如数字签名。

我们将讨论这些函数的4个有趣的属性，然后看看为什么这些属性使我们能够生成可验证的签名。

我们在这里使用的函数被称为[SHA-256](http://www.movable-type.co.uk/scripts/sha256.html)。

#### hash 函数属性1————不可逆性

hash 函数有点像绞肉机：你把牛排放在一端，就可以从另一端得到汉堡包，你没有办法从汉堡包中把牛排放回去：

> 这个函数是真正不可逆的

这意味着如果我们靠头部和载荷运行这个函数，是得不到相同输出的。

想要查看SHA-256的输出示例，可以用这个[在线hash计算器](http://www.xorbin.com/tools/sha256-hash-calculator)实验下：

```
3f306b76e92c8a8fbae88a3ef1c0f9b0a81fe3a953fa9320d5d0281b059887c3
```

这意味 hash 不是加密：加密是一种可逆的行为————我们需要从加密输出中取回原始输入。

#### hash 函数的特性2————可复现的

关于哈希的另一个重要的特性是它是可复现的，这意味着如果我们把相同的输入 eader 和载荷多次的 hash，我们总是会得到完全相同的结果。

这意味着，给定一对输入和一个 hash 输出，我们总是可以验证输出（例如签名）是否正确，因为我们可以很容易复现这个 hash 过程————但前提是我们拥有所有的输入。

#### hash 函数的特征3————无冲突

hash 函数的另一个有趣特性是，如果我们多次向它提交不同的值，根据每次的输入值都会得到唯一的结果。

实际上不存在两个不同的输入值能得到相同结果的情况————一个独特的输入会产生独特的输出。

这意味着如果我们 hash 头跟载荷，我们通常会得到完全相同的结果，而不是不同的数据也能得到相同的 hash 输出————hash 输出实际上输入数据的唯一表现形式。

#### hash函数的特征4————不可预测性

我们将要讨论的是关于 hash 函数的最后一个属性是，根据已知输出是不可能用连续增量逼近的方法来猜测输入的。

假设我们有一个 hash 输出，我们尝试通过观察它来猜测它的输入值，然后看看实际的输入值跟我们猜测的是否接近。

然后我们简单地调整输入中的一个字符，然后再次检查输出，看看它们是否更接近，如果是这样，重复这个过程，直到我们能设法猜测到输入。

这里唯一的问题是：

> 使用 hash 函数，这个策略将不起作用！

这是因为在 hash 函数中，如果我们改变输入中的一个字符（甚至是一个 bit），平均50%的输出 bit 会发生变化！

因此，即使是最小的输入差异，也会产生完全不同的输出。

这一切听起来都很有趣，但您可能正在思考一点:hash 函数是如何启用数字签名的呢？

攻击者不能只用头和载荷来伪造签名吗？

任何人都可以使用 SHA-256 函数得到相同的输出，将它添加到 JWT 的签名，对吗？

### 怎么使用 hash 函数来创建一个签名？

只要最后一部分是 true，任何人都可以重现给定的 header 和 payload 的 hash 值。

但是 HS256 签名不仅仅是这样：相反，我们会带上头部，载荷和我们添加的密码，然后全部一起进行 hash 处理。

得到的结果是一个 SHA-256 HMAC 或者一个 Hash-Based 消息认证代码。例如 HMAC-SHA256 函数，会被用在 HS256 签名上。

这个函数的结果只能被拥有 JWT Header, Payload（所有抓取了 token 的人都能读懂的）和密码的人所重现。

> 这意味着由此产生的 hash 实际上是数字签名的一种形式。

因为 hash 后的结果证明载荷是被密码持有人创建并签名的：别人没办法想出这样独一无二的 hash。

因此，hash 作为一个不可伪造的数字证明的载荷是有效的

然后将 hash 附加到消息中，以便接收者对其进行验证：该散列输出称为 HMAC：基于散列的消息验证代码，这是一种数字签名形式。

JWTs 的真实情况：JWT 的最后一部分（第二点后）是头加上载荷的 SHA-256 hash，编码格式是 base64url。

#### 如何验证一个 JWT 签名？

因此当我们在服务器端收到一个 HS256-signed JWT，我们也需要一个准确的密码，用来验证签名和确认 token 的载荷确实是有效的。

想要检查这个签名，我们只需将密码与 JWT 头跟载荷一起 hash 就可以了。这意味着，在 HS256 的情况下，JWT 接收方需要和发送方具有相同的密码。

如果我们得到与签名相同的 hash 值，则意味着该令牌肯定是有效的，因为只有具有密码的人才可以提供该签名。

总之，这就是数字签名和 HMAC 的工作方式。想不想马上看看它？

### 手动确认 SHA-256 JWT 签名

让我们采用与上述相同的 JWT，并删除签名和第二个点，只留下头部和载荷部分。它看起来像这样：

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWV9
```

现在，如果您将此字符串复制/粘贴到像[这个](https://hash.online-convert.com/sha256-generator)那样的在线 HMAC SHA-256 工具中，并使用密码 `secret` ，我们将返回 JWT 签名！

通常，我们会得到它的 Base64 版本，它通常以 `=` 结尾，这是接近但不完全相同的 Base64Url：

```
TJVA95OrM7E2cBab30RMHrHDcEfxjoYZgeFONFh7HgQ=
```

这个等号会以 `%3D` 在 url 栏显示，这是其中一个麻烦，但它也充分说明了 Base64Url 的重要性，

没有很多在线 Base64Url 转换器可用，但是我们可以在命令行中进行。所以要真正确认这个HS256签名，这里有个[ npm 包](https://www.npmjs.com/package/base64url)，可以实现 Base64Url，以及Base64的正向/反向转换。

#### base64url NPM 包

让我们使用这个包将结果转化成 Base64 URL 来确认签名，同时搞懂它是怎么运作的

```
mkdir quick-test && cd quick-test
npm init
npm install base64url

node
> const base64url = require('base64url');
> base64url.fromBase64("TJVA95OrM7E2cBab30RMHrHDcEfxjoYZgeFONFh7HgQ=")

TJVA95OrM7E2cBab30RMHrHDcEfxjoYZgeFONFh7HgQ
```

所以最后我们得到了这个我们一直试图复现的HS256 JWT签名字符串：

> 这要求 JWT 签名上的每个字母都一摸一样！

那么恭喜你，现在你知道如何深入 HS256 JWT 签名的工作里去了，你将能自己使用这些在线工具和软件包排查问题。

### 为什么还有其他签名呢？

总而言之，这才是 JWT 签名在认证的用法，而 HS256 只是一个特定签名类型的例子。但是还有其他的签名类型，最常用的是 RS256。

有什么不同？ 我们在这里介绍 HS256 的原因主要是因为它可以让我们更容易理解 MAC 代码的概念，而且你很可能在许多应用的生产中发现它。

但总的来说，使用 RS256 签名会**更好**一些，因为我们将在下一节知道，相比 HS256 它有更多优势。

### HS256 签名的缺点

如果输入密匙很弱，HS256 签名很可能会被破解，但这可能涉及许多其他关于密钥的技术。

根据典型的生产密钥大小对比，基于 Hash 的签名比其他替代品更容易破解。

但更重要的是，HS256 的一个实际缺点是，在派发 JWTs 服务器和其他验证用户身份的服务器之间需要一个事先商定的密码的。

#### 不实用的密钥转换

这意味着，如果我们想改变密码，我们需要把它分配并安装到所有需要它的网络节点，这不方便，容易出错，需要协调服务器停机时间。

服务器由一个完全不同的团队管理，甚至由第三方组织管理的情况下，这是不可行的。

#### 令牌的创建和验证是不独立的

这一切都归结于创建和验证 JWT 的能力是一样的：网络中的每个人都可以通过 HS256 创建**和**验证令牌，因为它们都有自己的密码。

这意味着攻击者可以窃取密码的地方更多了，因为密码需要安装在每一个地方，而不是所有的应用程序都具有相同安全级别。

缓解这种问题的一个方法是在每个应用间创建一个共享密码，但是，我们要学习一个新的签名方法，来解决所有这些问题，同时现代基于 JWT 的解决方案都默认使用：RS256。

### RS256 JWT 签名

使用RS256，我们仍然会像以前一样生成一个认证码，但是我们的目标仍然是创建一个数字签名来证明给定的 JWT 是有效的。

但是在这个签名的情况下，我们将分离创建有效令牌的能力，只有验证服务器才能验证JWT令牌，只有我们的应用服务器才能从中受益。

我们要做的是，我们将创建两个密钥来取代它：

* 仍然会有一个私钥，但它只会在验证服务器自己签署 JWTs 时才会用到。
* 私钥可用于签署 JWTs，但不能用于验证
* 第二个密钥叫做公钥，它只被服务器用于验证 JWTs
* 公钥可用于验证 JWT 签名，但不能用于签署新的 JWT
* 公钥一般不需要保密，因为攻击者得到它也没办法伪造签名

### 介绍一下 RSA 加密技术

RS256 使用了一种特定类型的密钥，称为 RSA 密钥。RSA 是一种加密/解密算法的名称，该算法使用一个密钥进行加密，另一个密钥进行解密。

注意，RSA 密钥不是 hash 函数，因为根据定义，加密的结果是可以反转的，我们能找回初始的结果。

让我们看一下一个 RSA _公钥_长怎样的：

```
-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDdlatRjRjogo3WojgGHFHYLugdUWAY9iR3fy4arWNA1KoS8kVw33cJibXr8bvwUAUparCwlvdbH6dvEOfou0/gCFQsHUfQrSDv+MuSUMAe8jzKE4qW+jK+xQU9a03GUnKHkkle+Q0pX/g6jXZ7r1/xAK5Do2kQ+X5xK9cipRgEKwIDAQAB
-----END PUBLIC KEY-----  
```

它看起来有一点可怕，但它其实只是一个像 OpenSSL 这样的命令行工具或[像这个](http://travistidwell.com/jsencrypt/demo/)在线RSA密钥生成工具生成的唯一密钥，

同样，这个密钥 _可以被公开_，它实际上就是公开的，因此攻击者不需要猜测这个密钥：通常他们早已拥有了它。

但也有相应的 RSA 私钥：

```
-----BEGIN RSA PRIVATE KEY-----
MIICWwIBAAKBgQDdlatRjRjogo3WojgGHFHYLugdUWAY9iR3fy4arWNA1KoS8kVw33cJibXr8bvwUAUparCwlvdbH6dvEOfou0/gCFQsHUfQrSDv+MuSUMAe8jzKE4qW+jK+xQU9a03GUnKHkkle+Q0pX/g6jXZ7r1/xAK5Do2kQ+X5xK9cipRgEKwIDAQABAoGAD+onAtVye4ic7VR7V50DF9bOnwRwNXrARcDhq9LWNRrRGElESYYTQ6EbatXS3MCyjjX2eMhu/aF5YhXBwkppwxg+EOmXeh+MzL7Zh284OuPbkglAaGhV9bb6/5CpuGb1esyPbYW+Ty2PC0GSZfIXkXs76jXAu9TOBvD0ybc2YlkCQQDywg2R/7t3Q2OE2+yo382CLJdrlSLVROWKwb4tb2PjhY4XAwV8d1vy0RenxTB+K5Mu57uVSTHtrMK0GAtFr833AkEA6avx20OHo61Yela/4k5kQDtjEf1N0LfI+BcWZtxsS3jDM3i1Hp0KSu5rsCPb8acJo5RO26gGVrfAsDcIXKC+bQJAZZ2XIpsitLyPpuiMOvBbzPavd4gY6Z8KWrfYzJoI/Q9FuBo6rKwl4BFoToD7WIUS+hpkagwWiz+6zLoX1dbOZwJACmH5fSSjAkLRi54PKJ8TFUeOP15h9sQzydI8zJU+upvDEKZsZc/UhT/SySDOxQ4G/523Y0sz/OZtSWcol/UMgQJALesy++GdvoIDLfJX5GBQpuFgFenRiRDabxrE9MNUZ2aPFaFp+DyAe+b4nDwuJaW2LURbr8AEZga7oQj0uYxcYw==
-----END RSA PRIVATE KEY-----  
```

好消息是，攻击者根本无法猜出这一点！

再次记住，这两个键是对应的，一个密钥加密，另一个只能解密。但是我们如何使用它来产生签名呢？

### 为什么不只对载荷 RSA 加密？

下面是使用 RSA 创建数字签名的一个尝试：我们对 Header 和 Payload 使用 RSA 私钥加密，然后发送JWT。

接收者得到 JWT，用公钥解密，然后检查结果。

如果解密过程起到作用，并且输出看起来像一个 JSON 载荷，那么验证服务器一定是创建了这个数据同时对它进行加密。所以它必须是完整的，对吧？

确实如此，证明这个令牌是正确的就足够了。但是由于实际的原因，这不是我们所要做的。

例如与 hash 函数相比，RSA 加密过程相对较慢。对于更大的载荷，这可能是一个问题，这仅仅是其中的一个原因。

那么，实际上 HS256 签名怎么使用 RSA 的呢？

### 用 RSA 和 SHA-256 签署一个 JWT （RSA-SHA256）

在实践中，我们首先要做的是把头部和载荷进行 hash 函数处理，例如使用 SHA-256。

这一步很快就完成了，接下来我们会得到一个唯一的比实际长度要小得多的输入数据。

然后我们获取 hash 输出并使用 RAS 私钥加密获取 RS256 签名，而不是对整个数据（头和载荷）加密！

接着我们把它作为三部分的最后一部分添加到 JWT 并发送。

### 如何接收检查 RS256 签名？

JWT 接收者将会：

* 用 SHA-256 hash 头和载荷
* 用公钥解密签名，并获得签名的 hash
* 接收者对签名的 hash 结果和头加载荷的 hash 结果进行对比

两个 hash 值匹配吗？如果匹配，就可以证明这个 JWT 确实是由认证服务器创建的了！

任何人都可以计算这个 hash，但只有身份验证服务器可以用匹配的 RSA 私钥对它进行加密。

你认为还有更多吗？那么我们来确认一下，并在这个过程中学习如何排查 RS256 签名。

### 手动确认一个 RS256 JWT 签名

让我们在 [jwt.io](https://jwt.io) 开始一个 RS256 签名的 JWT 的例子：
```
eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWV9.EkN-DOsnsuRjRO6BxXemmJDm3HbxrbRzXglbN2S4sOkopdU4IsDxTI8jO19W_A4K8ZPJijNLis4EZsHeY559a4DFOd50_OqgHGuERTqYZyuhtF39yxJPAjUESwxk2J5k_4zM3O-vtd1Ghyo4IbqKKSy6J9mTniYJPenn5-HIirE
```

我们可以看到，这相对 HS256 JWT 来说没有直接的视觉差异，但这是与上面所示的相同的 RSA 的私钥签署。

现在，我们只隔离了头部和载荷，和移除了签名：

```
eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWV9
```

我们现在要做的就是使用 SHA-256 对它进行 hash 处理，并使用上面显示的 RSA 私钥对它进行加密。

得到的结果应该就是 JWT 签名了！让我们来确认一下是否用了 node 内置的 Crypto 模块。不需要额外安装，这是 Node 的内置模块。

这个模块内置了[RSA-SHA256 函数](https://nodejs.org/api/crypto.html#crypto_class_sign) 和许多其他签名函数，我们可以使用它们尝试重现签名。

为了重现它，我们要做的第一件事是，我们需要取得RSA私钥并保存到一个叫 `private.key` 的 text 文件。

然后在命令行中，我们通过node shell执行这个小程序

如果您使用的JWT与我们使用的测试JWT不同，那么您只需将这两个部分复制/粘贴到 `write` 调用中，而不需要 JWT 签名。

这是返回的结果：

```
 EkN+DOsnsuRjRO6BxXemmJDm3HbxrbRzXglbN2S4sOkopdU4IsDxTI8jO19W/A4K8ZPJijNLis4EZsHeY559a4DFOd50/OqgHGuERTqYZyuhtF39yxJPAjUESwxk2J5k/4zM3O+vtd1Ghyo4IbqKKSy6J9mTniYJPenn5+HIirE=
```

这与 JWT 签名完全不同！但是等一下：这里有斜杠，等号，它们是不可能的在没有转义的情况下放入一个 URL 的。

这是因为我们已经创建了 Base64 版本的签名，而我们需要的是 Base64Url 版本。 所以让我们转换它：

```
bash$ node
const base64url = require('base64url');
base64url.fromBase64("EkN+DOsnsuRjRO6BxXemmJDm3HbxrbRzXglbN2S4sOkopdU4IsDxTI8jO19W/A4K8ZPJijNLis4EZsHeY559a4DFOd50/OqgHGuERTqYZyuhtF39yxJPAjUESwxk2J5k/4zM3O+vtd1Ghyo4IbqKKSy6J9mTniYJPenn5+HIirE=");
```

看一下返回什么：

```
EkN-DOsnsuRjRO6BxXemmJDm3HbxrbRzXglbN2S4sOkopdU4IsDxTI8jO19W_A4K8ZPJijNLis4EZsHeY559a4DFOd50_OqgHGuERTqYZyuhtF39yxJPAjUESwxk2J5k_4zM3O-vtd1Ghyo4IbqKKSy6J9mTniYJPenn5-HIirE 
```

这正是我们试图创建的 RS256 签名的一点一滴！

这验证了我们对 RS256 JWT 签名的理解，现在我们知道如何在需要时对它进行故障排除。

总之，RS256 JWT签名只是一个被RSA加密过同时被SHA-256 hash的头和载荷。

所以我们现在知道 RS256 签名是如何工作的，但为什么这些签名比 HS256 更好呢？

### RS256 vs HS256 - 为什么使用 RS256？

通过 RS256 攻击者可以很容易地做到签名创建过程的第一步，即根据被盗的 JWT 头和有效负载的值创建 SHA-256 hash。

但想要从那重新生成签名，就不得不破解RSA，但对一个好的密钥来说破解是[不可能的事](https://crypto.stackexchange.com/questions/3043/how-much-computing-resource-is-required-to-brute-force-rsa)。

但是对于大多数应用，这并不是我们为什么要选择 RS256 而不是 HS256 的最实际的原因。

使用 RS256，我们也知道具有签名令牌功能的私钥只能由认证服务器保存，在那里更加安全 - 这意味着使用 RS256 丢失签名私钥的可能性较小。

但是选择 RS256 有一个更大的实际原因 - 密钥转换。

### 如何证明密钥转换

记住，验证令牌的公钥可以在任何地方发布，但实际上攻击者拿着它也什么都做不了。

毕竟，攻击者验证偷来的 JWT 有什么好处呢？攻击者是想要伪造 JWTs，而不是验证他们。

这样就可以在我们控制的服务器上发布公钥了。

应用服务器只需要连接到该服务器获取公钥，并定期重新检查，以防它发生变化，无论是因为突发事件还是周期性的密钥旋转。

因此，不需要同时关闭应用服务器和认证服务器，并一次性更新密钥。

那公钥是怎么发布的？这有个很可能形式。

### JWKS (JSON Web Key Set)终端
有许多形式可以发布公钥，但是这里有一个让人熟悉的格式：JWKS，它是 Json Web Key Set 的缩写。

使用一些 npm 包来占用这些端点并验证 JWT，我们将在第二部分看到。
这些端点可以发布一系列公钥，而不仅仅是一个公钥。

如果您想知道这种类型的端点是什么样子的，请看一下这个活生生的[例子](https://angularuniv-security-course.auth0.com/.well-known/jwks.json)，在这我们收到HTTP GET request的response。

`kid` 属性是关键标识符，而 `x5c` 属性是一个特定公钥的表现形式。

这种格式的优点在于它是标准的，所以我们只需要 URL 的端点和一个使用 JWKS 的库 - 这让我们可以使用公钥来验证 JWT，而不必在我们的服务器安装它。 

JWTs 往往与公共互联网站点以及第三方社交登录的解决方案有关。那么内部网跟内部应用程序呢？

### 企业中的 JWTs

JWT 也适用于企业，在大家对安全措施的认知里，预认证设置是一个很好的选择。

在许多公司的预验证设置中，应用程序服务器会在私有网络的代理服务器上运行，它只需从 HTTP 报头上检索当前用户。

标识用户的 HTTP 头通常由网络的集中元素填充，通常是在代理服务器上的一个登录页面，该页面负责处理用户会话。

如果会话过期，该服务器将阻止对应用程序的访问，需要用户再次登录后进行身份验证。

之后，它会将所有请求转发到应用程序服务器，并简单地添加一个 HTTP 头来标识用户。

> 问题是，通过这种设置，实际上网络中的任何人都可以通过设置相同的HTTP头轻松地模拟用户！

有些解决方案，比如应用服务器层级的代理服务器IP白名单，或者使用客户端证书，但实际上大多数公司没有这个措施

#### 一个更好的预认证配置版本

预认证的想法很好，因为此设置意味着应用程序开发人员不必在每个应用程序上实现身份验证功能，节省了时间和避免了潜在的安全漏洞。

预认证使我们不需要受困于安全性问题，让我们的应用程序更完备，哪怕只是在私人网络里。难道能够快捷设置预认证不是一件好事吗？

很容易想象到加入JWT的场景：让HTTP头成为一个jwt，而不是仅仅像过往的预认证那样仅仅把用户名放进头部。

让我们把用户名取代JWT的载荷，并在验证服务器中签名。

应用服务器将会第一步验证 JWT，而不仅仅从 header 中提取用户名：

* 如果签名正确，则用户身份正确，请求能够通过
* 如果签名不正确，应用服务器会直接拒绝请求

结果是，我们现在认证工作运作正常，即使是在私人网络上！
我们不再需要盲目相信包含用户名的 HTTP Header。我们可以确认 HTTP header 的正确性，由代理发出，而防止攻击者假装其他用户登录。

### 结语

在这篇文章里，我们对 JWT 有了一个全面的了解，它是什么，它们是怎么被运用于用户验证的。JWTs仅仅是具有易于验证和不可伪造特性的JSON 载荷。

而且，JWT 不是身份验证独有的，我们可以使用它们在网络任何地方发送任何声明。

另一个在使用 JWTs 时常见的安全问题：我们可以在载荷上为用户授权角色：只读用户、管理员等。

在下一篇文章里，我们将会学习到在 Angular 应用中如何使用 JWTs 进行用户验证。

我希望你能享受这篇文章，如果你有什么问题和意见，请在评论区提出，我会与你联系。

注意了！很快就会有更多相关的文章出炉，欢迎订阅！

### 相关链接

[Auth0 JWT 手册](https://auth0.com/e-books/jwt-handbook)

[RS256 和 JWKS 指南](https://auth0.com/blog/navigating-rs256-and-jwks/)

[暴力破解 hs256 是可能的：签署强健 jwts 的重要性](https://auth0.com/blog/brute-forcing-hs256-is-possible-the-importance-of-using-strong-keys-to-sign-jwts/)

[JSON Web Key Set (JWKS)](https://auth0.com/docs/jwks)

### YouTube 上的视频教程

看看 Angular 大学的 Youtube 频道，我们发布了大约25％到三分之一的视频教程，新视频会陆续推出。

[订阅](http://www.youtube.com/channel/UC3cEGKhg3OERn-ihVsJcb7A？sub_confirmation=1)获取新的视频教程：

## 有关 angular 的其他文章

还可以看看其他有趣的文章：

* [开始 Angualr ————在 yarn 下的最佳开发环境，Angular CLI，设置 IDE](http://blog.angular-university.io/getting-started-with-angular-setup-a-development-environment-with-yarn-the-angular-cli-setup-an-ide/)
* [为什么是单页应用？有什么好处？什么是 spa？](http://blog.angular-university.io/why-a-single-page-application-what-are-the-benefits-what-is-a-spa/)
* [Angular 智能组件 vs 展示组件: 有什么区别,什么时候使用它们，为什么？](http://blog.angular-university.io/angular-2-smart-components-vs-presentation-components-whats-the-difference-when-to-use-each-and-why)
* [Angular Router ————如何用 Bootstrap4 和 Nested Routes 创建导航菜单](http://blog.angular-university.io/angular-2-router-nested-routes-and-nested-auxiliary-routes-build-a-menu-navigation-system/)
* [Angular Router————拓展导航，避免常见陷阱](http://blog.angular-university.io/angular2-router/)
* [Angular Components————原理](http://blog.angular-university.io/introduction-to-angular-2-fundamentals-of-components-events-properties-and-actions/)
* [如何使用可观察的数据服务构建 Angular 应用————要避免的陷阱](http://blog.angular-university.io/how-to-build-angular2-apps-using-rxjs-observable-data-services-pitfalls-to-avoid/)
* [Angular Forms 介绍————模版驱动 vs 模型驱动](http://blog.angular-university.io/introduction-to-angular-2-forms-template-driven-vs-model-driven/)
* [Angular ngFor————学习包括 trackby 的所有功能，为什么它不仅对数组能用？](http://blog.angular-university.io/angular-2-ngfor/)
* [Angular university 实战————如何创建 SEO 友好的 Angualr 单页应用](http://blog.angular-university.io/angular-2-universal-meet-the-internet-of-the-future-seo-friendly-single-page-web-apps/)
* [Angular2 的脏值检测是怎么工作的？](http://blog.angular-university.io/how-does-angular-2-change-detection-really-work/)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
