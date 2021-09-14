> - 原文地址：[Passwordless Authentication for Better Security](https://blog.bitsrc.io/passwordless-authentication-for-better-security-ba986df663b7)
> - 原文作者：[Pavindu Lakshan](https://medium.com/@pavindulakshan)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/passwordless-authentication-for-better-security.md](https://github.com/xitu/gold-miner/blob/master/article/2021/passwordless-authentication-for-better-security.md)
> - 译者：[NieZhuZhu（弹铁蛋同学）](https://github.com/NieZhuZhu)
> - 校对者：[greycodee](https://github.com/greycodee)、[jaredliw](https:github.com/jaredliw)

# 无密码认证，安全更有保障

![](https://cdn-images-1.medium.com/max/5760/1*fFag6UPoX_EoUotZnZj9uQ.jpeg)

密码是网络应用中最常用的认证机制之一。但是在实践中使用它们会带来安全风险和复杂问题。

因此，在这篇文章中，我将讨论 SRP，一种无密码认证机制，帮助你解决密码认证中的一些主要安全挑战。

## 什么是 SRP？

[[SRP(Secure Remote Password) protocol]](http://srp.stanford.edu/index.html) 是一个增强的密码认证的密钥交换协议。

> 它是一个[零知识证明](https://baike.baidu.com/item/%E9%9B%B6%E7%9F%A5%E8%AF%86%E8%AF%81%E6%98%8E/8804311)的认证协议，这意味着服务器和客户端都不需要传输或存储与密码有关的信息。但是，他们仍然可以安全地验证对方的身份。

SRP 减轻了传统认证的复杂性，因为你不需要担心在服务器内或在客户与服务器通信之间保护与密码有关的信息。

因此，让我们看看 SRP 是如何工作的以及是如何解决一些与密码有关的核心安全挑战。

## SRP 工作原理

让我们看看 SRP 是如何实现无密码认证的目标的。为了便于理解，我将该协议分为三个步骤进行描述。如需更深入的了解，请参考[官方文档](http://srp.stanford.edu/design.html)。

### 第 1：注册

当用户使用用户名和密码注册时，会产生一个 salt（随机字符串）。这个 salt 与用户的证书一起用于生成一个密钥。

然后使用秘钥和指定的 SRP 组生成一个验证器。最后，验证器、salt 和 [SRP 组](https://datatracker.ietf.org/doc/html/rfc5054#page-16)被发送到服务器，而不是实际的用户名和密码。

> 因此，简而言之，没有机密信息被发送到服务器。因此，没有中间人可以使用验证器 salt 和 SRP 组来造成伤害。

```js
salt = client.generateRandomSalt();
secret_key = client.KDF(username, password, salt);
verifier = client.genVerifier(secret_key, SRP_group);
client.send_to_server(verifier, salt, SRP_group);
```

![SRP 协议中的注册过程](https://cdn-images-1.medium.com/max/2048/1*3c_w9py-f7jhDEVniLKHLQ.png)

### 第 2 步：认证

当认证时，客户端请求服务器为给定的用户名获取 salt 和 SRP 组。利用这些信息，客户端计算出一个秘钥和一个公钥。公钥被发送到服务器，私钥保留在客户端。

```js
salt, SRP_group = client.getData(username);
c_secret_key = client.KDF(username, password, salt);
c_public_key, c_private_key = client.generateKeyPair(SRP_group);
client.sendToServer(c_public_key);
```

服务器也将使用 SRP 组计算一个密钥对，并将公钥送回给客户端。

```js
s_public_key, s_private_key = server.generateKeyPair(SRP_group);
server.sendToClient(s_public_key);
```

之后，客户端和服务器将拥有以下信息。

```
client-side: c_secret_key, c_private_key, s_public_key
server-side: verifier, s_private_key, c_public_key
```

![SRP 协议的认证过程](https://cdn-images-1.medium.com/max/2048/1*wp92woniVZBYPsNFI6yMdw.png)

> 同样，在客户端和服务器之间没有任何机密信息是通过网络发送的。

### 第 3 步：验证

利用认证过程中获得的信息，客户端和服务器独立计算出一个类似的密钥，称为会话加密密钥。这在随后的请求中被用来在客户端和服务器之间交换信息。

```js
// client side
session_key = client.genSessionKey(c_secret_key, c_private_key, s_public_key);

// server side
session_key = server.genSessionKey(verifier, s_private_key, c_public_key);
```

> 这些被称为基于 Diffie-Hellman 的验证者密钥交换协议。

客户端使用**会话加密密钥**对信息进行加密，并将其发送给服务器。然后服务器对信息进行解密并进行验证。如果验证失败，客户端的请求被拒绝。否则，服务器使用其**会话加密密钥**对消息进行加密，并将其发回给客户端，以解密和验证。

我想现在你明白了 SRP 的工作原理，让我们看看如何在实践中实现它。

## 在实践中使用 SRP

> **注意**：由于 SRP 涉及复杂的密码学操作，我们鼓励使用现有的经过验证的实现，而不是从头开始编程。已经有[许多用不同语言完成的实现](https://en.wikipedia.org/wiki/Secure_Remote_Password_protocol#Implementations)，可以在你的项目中使用其中一个。

在这个例子中，我将使用 [thinbus-srp-npm-starter](https://github.com/simbo1905/thinbus-srp-npm-tester) 项目，它使用 `thinbus-srp-js`，一个标准的 JavaScript SRP 实现。

首先，你需要克隆项目，安装 NPM 依赖，并在本地运行该项目。

```bash
git clone https://github.com/simbo1905/thinbus-srp-npm-tester.git
cd thinbus-srp-npm-tester
npm install
npm start
```

然后，尝试在 [http://localhost:8080/register](http://localhost:8080/register) 用用户名和密码进行注册。如果我们看一下此时的网络请求，它将看起来像这样。

![网络请求信息](https://cdn-images-1.medium.com/max/2034/1*XEWIcLgoW7cI2sVEzTflIg.png)

在 [http://localhost:8080/login](http://localhost:8080/login) 登录时，客户端将首先通过 `/challenge` 向服务器请求用户的 salt 和 SRP 组。

![](https://cdn-images-1.medium.com/max/2000/1*ajRkQhiayDNFMp1pN74vaA.png)

利用这些信息，客户端计算出它的公钥和加密的信息。然后，客户端用计算出的数据和用户名调用 `/authenticate` 端点。

![`/authenticate` 接口请求信息](https://cdn-images-1.medium.com/max/2190/1*tHtw0uoqUS2q4BeZwPxItw.png)

- A —— 在客户端生成的公钥（暂时性的）。
- M1 —— 在客户端用生成的会话加密密钥加密的信息。

服务器将回应客户的请求，发送一个信息回来（M2），该信息用相同的会话加密密钥进行加密。然后，客户端使用客户端的私钥对其进行解密和验证。

最后，客户端和服务器已经确认了彼此的真实性，并继续在它们之间分享信息。

![来自服务器的加密信息](https://cdn-images-1.medium.com/max/2000/1*QBhZ1ov9TtiGEA-Z9bu5bQ.png)

## 最后的思考

密码是网络应用中最常用的认证机制。然而，要实现一个完美无缺的密码认证机制并不容易。尽管我们有安全的传输和存储技术，但只要攻击者有足够的耐心和资源，他们仍然可以获取密码。

SRP 协议为此提供了一个解决方案，引入了一种无需传输或存储任何形式的密码相关信息的认证方法。

因此，我邀请你在你的下一个项目中尝试 SRP，体验它带来的不同。另外，别忘了在评论区分享你的经验。

谢谢你的阅读！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
