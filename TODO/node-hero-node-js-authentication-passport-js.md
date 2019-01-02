>* 原文链接 : [Node Hero - Node.js Authentication using Passport.js](https://blog.risingstack.com/node-hero-node-js-authentication-passport-js/)
* 原文作者 : [risingstack](https://blog.risingstack.com)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [circlelove](https://github.com/circlelove)
* 校对者:[wild-flame](https://github.com/wild-flame); [godofchina](https://github.com/godofchina)

# 教程：使用 Passport.js 来做后台用户验证

这是称为 Node Hero 系列教程的第八部分——在这些章节里面，你将学到如何开始 Node.js 的旅程以及如何用它来交付软件产品。

这个教程当中，你将学习如何利用 Node.js 和 Redis 来实现本地化的 Node.js 身份验证策略。 

即将开始的和从前期的章节：

1.  [从 Node.js 开始](/node-hero-tutorial-getting-started-with-node-js) 


2.  [使用NPM](/node-hero-npm-tutorial)


3.  [理解异步程序](/node-hero-async-programming-in-node-js)

4.  [你的第一个 Node.js HTTP 服务器](/your-first-node-js-http-server)
 
5.  [ Node.js 数据库教程](/node-js-database-tutorial)

6.  [ Node.js 必须模块教程](/node-hero-node-js-request-module-tutorial)

7.  [ Node.js 项目架构教程](/node-hero-node-js-project-structure-tutorial)

8.   利用 Passport.js 进行 Node.js 身份验证 _[也就是你正在读的这章]_

9. 测试 Node.js 应用

10. 调试 Node.js

11. 巩固你的应用

12.  为 PaaS 部署 Node.js 应用

13.  监控和执行 Node.js 应用


## 会用到的技术

在真正进入实际编程前，我们来看一看在这一章要用到的新技术。

#### Pasport.js 是什麽?

> 简单，低调的 Node.js 身份验证。 - [passportjs.org](http://passportjs.org/)


![Passport.js 是 Node.js 的身份验证中间件。](http://ww4.sinaimg.cn/large/72f96cbagw1f4a78792utj20k0061jry)


Passport.js 是 Node.js 的身份验证中间件，我们可以用它来进行会话管理。

#### Redis 是什么?


> Redis 是一个开源的（BSD 许可的），内存数据结构存储，用作数据库、缓存和消息代理。--[redis.io](http://redis.io/)

我们将在 Redis 里面存储我们用户的会话信息，而不是在进程的内存当中。这样一来我们的应用相当容易衡量。

## 应用样品

出于展示的目的，让我们只执行以下步骤构建一个应用：
*   显示登录表单,
*   显示2个受保护的页面:
    *   概述页,
    *   可靠票据







### 项目结构


我们已经在前一个章节 Node Hero中学了 [如何构建 passport.js 项目 ](https://blog.risingstack.com/node-hero-node-js-project-structure-tutorial/) ，因此让我们应用这些知识吧！

我们将利用以下结构

    ├── app
    |   ├── authentication
    |   ├── note
    |   ├── user
    |   ├── index.js
    |   └── layout.hbs
    ├── config
    |   └── index.js
    ├── index.js
    └── package.json


如你所见，我们将围绕特性组织文件和目录。我们也会设置功能性的用户页，注释页，以及相关的身份验证。
_(在 [https://github.com/RisingStack/nodehero-authentication](https://github.com/RisingStack/nodehero-authentication)下载所有的源代码。)_
 

### Node.js 身份验证流。

我们的目标是在我们的应用当中实现如下的身份验证流：

1.用户输入用户名和密码
2.应用检查用户名和密码是否相符
3.如果相符，则提交一个 ' Set-Cookie ' 的报头，用于下一级网页进行身份验证。
4.用户用同样的域名访问的时候，先前保存的 cookie 会加入到所有的请求中。
5.带有这样 cokie 的认证验证受限页面


为了设置像这样的身份验证策略，按照以下三步进行：

## 步骤1.设置 Express

我们将为服务器框架配置 Expres ----通过阅读我们的[Express 教程](https://blog.risingstack.com/your-first-node-js-http-server).你会学到比主题更多的东西



// file:app/index.js
    const express = require('express')  
    const passport = require('passport')  
    const session = require('express-session')  
    const RedisStore = require('connect-redis')(session)

    const app = express()  
    app.use(session({  
      store: new RedisStore({
        url: config.redisStore.url
      }),
      secret: config.redisStore.secret,
      resave: false,
      saveUninitialized: false
    }))
    app.use(passport.initialize())  
    app.use(passport.session())  


我们在这里做了哪些事情？

 首先，我们要'require' 所有的依赖以管理会话。之后，从'express-session' 模块创建一个新的例子，用它来储存我们的会话。

对于后备存储，我们现在使用的是 Redis ，不过你也可以用其他的，像 MySQL 、 MongoDB 之类的。

## 第二步，为 Node.js 配置 Passport


Passprot 是插件库的一个很棒的例子。这个教程当中，我们加入了 ' passport-local '模块，实现了利用用户名和密码的本地身份验证策略更加简单的集成。

简单起见，本例当中我们没有使用了二级后备存储，只有一个内存的用户实例。在实际的应用当中，' findUser '会在数据库当中查找用户。

    // file:app/authenticate/init.js
    const passport = require('passport')  
    const LocalStrategy = require('passport-local').Strategy

    const user = {  
      username: 'test-user',
      password: 'test-password',
      id: 1
    }

    passport.use(new LocalStrategy(  
      function(username, password, done) {
        findUser(username, function (err, user) {
          if (err) {
            return done(err)
          }
          if (!user) {
            return done(null, false)
          }
          if (password !== user.password  ) {
            return done(null, false)
          }
          return done(null, user)
        })
      }
    ))

一旦用户对象的'findUser' 返回，唯一剩下的就是用户供应的对比以及实际密码检测是否相符。

如果符合，我们允许用户登入（用户返回到 Passport --'返回完成( null , user )'）如果不符合，返回未验证错误。
(不向 passport 返回-- '返回完成（null ）'）

## 第三步，添加受保护节点

为了添加受保护节点，我们利用中间件模式 Express 使用。为此，我们首先创建身份验证中间件

    // file:app/authentication/middleware.js
    function authenticationMiddleware () {  
      return function (req, res, next) {
        if (req.isAuthenticated()) {
          return next()
        }
        res.redirect('/')
      }
    }


如果用户通过验证（即拥有正确的 cookies ） ，程序就会调用下一个中间件，否则它就会重定向到用户的登录页。

利用它就和向路由添加新的中间件一样简单。

    // file:app/user/init.js
    const passport = require('passport')

    app.get('/profile', passport.authenticationMiddleware(), renderProfile)  

## 总结

["@RisingStack 说 为带有 Passport 的 Node.js 配置身份验证就是小菜一碟。 #nodejs](https://twitter.com/share?text=%22Setting%20up%20authentication%20for%20Node.js%20with%20Passport%20is%20a%20piece%20of%20cake!%E2%80%9D%20via%20%40RisingStack%20%23nodejs;url=https://blog.risingstack.com/node-hero-node-js-authentication-passport-js)


[点击推特](https://twitter.com/share?text=%22Rule+1:+Organize+your+files+around+features,+not+roles!%22+via+%40RisingStack&url=https://blog.risingstack.com/node-hero-node-js-authentication-passport-js)


这次的 Node.js 教程当中，你学习了如何为应用添加基本的身份验证。之后，你可以使用更丰富的验证策略，比如使用 facebook 和 twitter。在[http://passportjs.org/](http://passportjs.org/).里你可以发现更多的策略

全部的代码和实例都在 Github 上面，你可以看一下： [https://github.com/RisingStack/nodehero-authentication](https://github.com/RisingStack/nodehero-authentication)


## 接下来

Node Hero 的下一章都是关于测试 Node.js 应用的。你会学到单元测试，测试金字塔，测试模块等等更多的东西


请在评论部分分享你的问题和反馈。
