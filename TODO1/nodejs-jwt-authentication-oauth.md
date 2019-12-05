> * 原文地址：[You don't need passport.js - Guide to node.js authentication](https://softwareontheroad.com/nodejs-jwt-authentication-oauth/)
> * 原文作者：[Sam Quinn](https://softwareontheroad.com/author/santypk-4/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/nodejs-jwt-authentication-oauth.md](https://github.com/xitu/gold-miner/blob/master/TODO1/nodejs-jwt-authentication-oauth.md)
> * 译者：[HytonightYX](https://github.com/HytonightYX)
> * 校对者：[HZNU-Qiu](https://github.com/HZNU-Qiu),[xionglong58](https://github.com/xionglong58)

# 🛑你不需要 passport.js — node.js认证指南 ✌️

![](https://softwareontheroad.com/static/24082354f482634f69457ebac008be39/2f86d/passport.jpg)

# 简介

诸如 Google Firebase，AWS Cognito 以及 Auth0 这样的第三方认证服务越来越流行，类似于 passport.js 这样的一站式解决方案也成为了业界标准，但是一个普遍情况是，开发者们其实并不清楚完整的认证流程到底涉及那些部分。

这一系列关于 node.js 认证的文章，旨在让你搞清楚一些概念，比如 JSON Web Token (JWT)、社交账号登录 (OAuth2)、用户模仿（一个管理员无需密码便能作为特定用户登录）。

当然，文末也给你准备好了一个完整的 node.js 认证流程的代码库，放在GitHub上了，你可以作为你自己项目的基础来使用。

# 前置知识 ✍️

在阅读之前，你需要先了解：

* 数据库中如何存储用户的 email 和密码，或者客户端ID和客户端密钥，或者其他的密钥对。
* 至少一种健壮且高效的加密算法。

在我写下这篇文章之时，我认为 Argon2 是目前最好的加密算法，请不要用 SHA256，SHA512 或者 MD5 这类简单的加密算法了。

有关这点，有兴趣的话可以去看看这篇非常棒的文章 [choosing a password hashing algorithm（如何选择密码哈希算法）](https://medium.com/@mpreziuso/password-hashing-pbkdf2-scrypt-bcrypt-and-argon2-e25aaf41598e)。

## 写一个注册程序 🥇

新用户创建账户时，必须对密码进行哈希处理并将其与电子邮件和其他详细信息（比如用户配置文件、时间戳等等）一起存储在数据库中。 

**提示:你可以去之前的文章了解 node.js 的项目结构 [Bulletproof node.js project architecture 🛡️](https://softwareontheroad.com/ideal-nodejs-project-structure)**

```javascript
import * as argon2 from 'argon2';

class AuthService {
  public async SignUp(email, password, name): Promise<any> {
    const passwordHashed = await argon2.hash(password);

    const userRecord = await UserModel.create({
      password: passwordHashed,
      email,
      name,
    });
    return {
      // 绝对不要返回用户的密码!!!!
      user: {
        email: userRecord.email,
        name: userRecord.name,
      },
    }
  }
}
```

数据库中，这名用户的记录看起来就是这样：

 [![User record - Database MongoDB](https://softwareontheroad.com/static/023165f3aa33ad9cb61f3f2cca383596/17e02/1-store_secure_password.jpg)](https://softwareontheroad.com/static/023165f3aa33ad9cb61f3f2cca383596/17e02/1-store_secure_password.jpg) **Robo3T for MongoDB**

## 再来写一个登录程序 🥈

 [![Sign-In Diagram](https://softwareontheroad.com/static/f44c38e035dab0cfb5c415d05a22d191/22543/6-sign_in_diagram.jpg)](https://softwareontheroad.com/static/f44c38e035dab0cfb5c415d05a22d191/22543/6-sign_in_diagram.jpg) 

当一名用户想要登录时，会发生下面的事情：

客户端发送成对的**公共标识（Public Identification）**和**私钥（Private key）**
  
* 服务端根据发来的 email 去数据库查找用户记录。
  
* 如果找到了，服务端会将收到的密码进行哈希，然后和数据库中已经哈希过的密码进行比对。
  
* 如果这两个哈希值对上了，那么服务端就发一个 JSON Web Token (JWT)。
  

这个 JWT 就是一个临时 key，客户端每次发器请求都需要带上这个 Token

```javascript
import * as argon2 from 'argon2';

class AuthService {
  public async Login(email, password): Promise<any> {
    const userRecord = await UserModel.findOne({ email });
    if (!userRecord) {
      throw new Error('User not found')
    } else {
      const correctPassword = await argon2.verify(userRecord.password, password);
      if (!correctPassword) {
        throw new Error('Incorrect password')
      }
    }

    return {
      user: {
        email: userRecord.email,
        name: userRecord.name,
      },
      token: this.generateJWT(userRecord),
    }
  }
}
```

这里密码认证使用了 argon2 库来防止时序攻击（timing-based attacks），也就是说，当攻击者试图靠蛮力破解口令时需要严格遵循[服务器响应时间](https://en.wikipedia.org/wiki/Timing_attack)的相关准则。

接下来我们将讨论一下如何生成 JWT。

# 但是，JWT到底是啥？ 👩‍🏫

一个 JSON Web Token or JWT 是一个以字符串或者 Token 形式存储的、经过编码的 JSON 对象。

你可以认为它是 cookie 的替代者。

Token 有下面三个部分（不同颜色标注）

[![JSON Web Token example](https://softwareontheroad.com/static/66d3aec1bdfa120ef1d6f746e8ffeecc/92307/2-jwt_example.jpg)](https://softwareontheroad.com/static/66d3aec1bdfa120ef1d6f746e8ffeecc/92307/2-jwt_example.jpg) 

JWT 中的数据可以无需**密钥（Secret）**或**签名（Signature)**在客户端解码。

因此对于用户角色信息、配置文件、令牌过期时间等这些前端领域常见的信息或元数据（metadata）来说，编码在 JWT 中一起传输就变得很方便。

[![JSON Web Token decoded example](https://softwareontheroad.com/static/0fd720e1243c124a745782badbbe4240/ae760/3-jwt_decoded.jpg)](https://softwareontheroad.com/static/0fd720e1243c124a745782badbbe4240/ae760/3-jwt_decoded.jpg) 

# node.js 中如何创建 JWT？ 🏭

我们实现一个 generateToken 方法来完善我们的认证服务程序吧。

通过使用 `jsonwebtoken` 这个库（你可以在 npmjs.com 找到它），我们就能创建一个 JWT 了。

```javascript
import * as jwt from 'jsonwebtoken'
class AuthService {
  private generateToken(user) {

    const data =  {
      _id: user._id,
      name: user.name,
      email: user.email
    };
    const signature = 'MySuP3R_z3kr3t';
    const expiration = '6h';

    return jwt.sign({ data, }, signature, { expiresIn: expiration });
  }
}
```

重要的是，永远不要在编码数据中包含用户的敏感信息。

上面 signature 变量其实就是用来生成 JWT 的密钥（secret），而且你要确保这个 signature 不会泄漏出去。

如果攻击者通过某种方法获取了 signature，他就能生成令牌并且伪装成用户从而窃取他们的会话（session）。

## 保护端点以及验证 JWT ⚔️

现在，前端需要在每个请求中带上 JWT 才能访问到安全目标（secure endpoint）了。

一个比较好的做法是在请求的 header 中附带 JWT，通常是 Authorization 消息头（Authorization header）。

[![Authorization Header](https://softwareontheroad.com/static/d5bf3b450e326091acc2f79885ca1bfd/909d6/4-authorization_header.jpg)](https://softwareontheroad.com/static/d5bf3b450e326091acc2f79885ca1bfd/909d6/4-authorization_header.jpg) 

现在，我们需要在后端中创建一个 express 的中间件。

**中间件 isAuth**

```javascript
import * as jwt from 'express-jwt';

// 我们假定 JWT 将会在 Authorization 请求头上，但是它也可以放在 req.body 或者 query 参数中，你只要根据业务场景选个合适的就好
const getTokenFromHeader = (req) => {
  if (req.headers.authorization && req.headers.authorization.split(' ')[0] === 'Bearer') {
    return req.headers.authorization.split(' ')[1];
  }
}

export default jwt({
  secret: 'MySuP3R_z3kr3t', // 必须和上一节的代码的 signature 一样

  userProperty: 'token', // this is where the next middleware can find the encoded data generated in services/auth:generateToken -> 'req.token'

  getToken: getTokenFromHeader, // 从 request 中获取到 auth token 的方法
})
```

创建一个能从数据库中获取到完整用户记录的中间件，并且将这些用户信息放进 request 中。

```javascript
export default (req, res, next) => {
 const decodedTokenData = req.tokenData;
 const userRecord = await UserModel.findOne({ _id: decodedTokenData._id })

 req.currentUser = userRecord;

 if(!userRecord) {
   return res.status(401).end('User not found')
 } else {
   return next();
 }
}
```

现在就可以跳转到用户请求的路由了

```javascript
  import isAuth from '../middlewares/isAuth';
  import attachCurrentUser from '../middlewares/attachCurrentUser';
  import ItemsModel from '../models/items';

  export default (app) => {
    app.get('/inventory/personal-items', isAuth, attachCurrentUser, (req, res) => {
      const user = req.currentUser;

      const userItems = await ItemsModel.find({ owner: user._id });

      return res.json(userItems).status(200);
    })
  }
```

经过两个中间件访问到的 inventory/personal-items 路由就是安全的。你需要有效的 JWT 才能访问这个路由，当然喽，路由也需要 JWT 中的用户信息才能去数据库中正确查找相应的信息。

## 为什么 JWT 是安全的 ?

你读到这里，通常会想到这么一个问题：

Q：如果可以在客户端中解码 JWT 数据的话，别人能否修改其中用户 id 或者其它的数据呢？

A：虽然你可以轻易地解码 JWT，但是没有 JWT 生成时的密钥（Secret）就无法对修改后的新数据进行编码。

也是因为这个原因，千万不要泄漏密钥（secret）。

我们的服务端会在 `IsAuth` 这个使用了 `express-jwt` 库的中间件中校验密钥。

现在我们已经明白了 JWT 是如何工作的，我们接下来去看一个很酷的功能。

## 如何模拟一个用户 🕵️

用户模拟是一种可以在无需用户密码的情况下，以一个特定用户的身份登录的技术。

对于超级管理员（super admins）来说，这是一个非常有用的功能，能够帮他解决或调试一个仅会话可见的用户的问题。

没有必要去知道用户的密码，只需要以正确的密钥和必要的用户信息来创建一个 JWT 就可以了。

我们来创建一个路径，来生成模拟生成特定用户登录的 JWT。这个路径只能被超级管理员账户使用。

首先，我们需要为超级管理员创建一个更高等级的角色，方法有很多，比较简单的一种就是直接去数据库中给用户记录添加一个“role”字段。

[![super admin role in user database record](https://softwareontheroad.com/static/07b91c5e21f1a0475501f7a2612fcb71/b9324/5-superadmin_role.jpg)](https://softwareontheroad.com/static/07b91c5e21f1a0475501f7a2612fcb71/b9324/5-superadmin_role.jpg) 

然后，我们创建一个新的中间件来检查用户角色。

```js
export default (requiredRole) => {
  return (req, res, next) => {
    if(req.currentUser.role === requiredRole) {
      return next();
    } else {
      return res.status(401).send('Action not allowed');
    }
  }
}
```

这个中间件需要放在 `isAuth` 和 `attachCurrentUser` 之后。

最后，这个路径将会生成一个能够模拟用户的 JWT 。

```javascript
  import isAuth from '../middlewares/isAuth';
  import attachCurrentUser from '../middlewares/attachCurrentUser';
  import roleRequired from '../middlwares/roleRequired';
  import UserModel from '../models/user';

  export default (app) => {
    app.post('/auth/signin-as-user', isAuth, attachCurrentUser, roleRequired('super-admin'), (req, res) => {
      const userEmail = req.body.email;

      const userRecord = await UserModel.findOne({ email: userEmail });

      if(!userRecord) {
        return res.status(404).send('User not found');
      }

      return res.json({
        user: {
          email: userRecord.email,
          name: userRecord.name
        },
        jwt: this.generateToken(userRecord)
      })
      .status(200);
    })
  }
```

所以，这里并没有什么黑魔法，超级管理员只需要知道需要被模拟的用户的Email（并且这里的逻辑与登录十分相似，只是无需检查口令的正确性）就可以模拟这个用户了。

当然，也正是因为不需要密码，这个路径的安全性就得靠 roleRequired 中间件来保证了。

# 结论 🏗️

虽然依赖第三方认证服务和库很方便，节约了开发时间，但是我们也需要了解认证背后的底层逻辑和原理。

在这篇文章中我们探讨了 JWT 的功能，为什么选择一个好的加密算法非常重要，以及如何去模拟一个用户，如果你使用的是 passport.js 这样的库，就很难做到这些事。

在本系列的下一篇文章中，我们将探讨通过使用 OAuth2 协议和更简单的替代方案（如 Firebase 等第三方用于身份验证的库）来为客户提供“社交登录”身份验证的不同方法。

### [这里是示例仓库 🔬](https://github.com/santiq/nodejs-auth)

### 参考资料

* [What is the recommended hash to store passwords: bcrypt, scrypt, Argon2?](https://security.stackexchange.com/questions/193351/in-2018-what-is-the-recommended-hash-to-store-passwords-bcrypt-scrypt-argon2)
* [Timing attack](https://en.wikipedia.org/wiki/Timing_attack)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
