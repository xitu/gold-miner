>* 原文链接 : [Node Hero - Node.js Authentication using Passport.js](https://blog.risingstack.com/node-hero-node-js-authentication-passport-js/)
* 原文作者 : [risingstack](https://blog.risingstack.com)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [circlelove](https://github.com/circlelove)
* 校对者:


This is the 8th part of the tutorial series called Node Hero - in these chapters, you can learn how to get started with Node.js and deliver software products using it.

这是称为 Node Hero 系列教程的第八部分——在这些章节里面，你将学到如何开始 Node.js 的旅程以及如何用它来交付软件产品。

In this tutorial, you are going to learn how to implement a local Node.js authentication strategy using Passport.js and Redis.
这个教程当中，你将学习如何利用 Node.js 和 Redis 来实施本地化的 Node.js 身份验证策略。 

Upcoming and past chapters:
即将开始的和从前期的章节：

1.  [Getting started with Node.js](/node-hero-tutorial-getting-started-with-node-js) 
从 Node.js 开始

2.  [Using NPM](/node-hero-npm-tutorial)
使用NPM

3.  [Understanding async programming](/node-hero-async-programming-in-node-js)
理解异步程序

5.  [Node.js database tutorial](/node-js-database-tutorial)
 Node.js 数据库教程

6.  [Node.js request module tutorial](/node-hero-node-js-request-module-tutorial)
 Node.js 必须模块教程

7.  [Node.js project structure tutorial](/node-hero-node-js-project-structure-tutorial)
 Node.js 项目架构教程

8.  Node.js authentication using Passport.js _[you are reading it now]_
 利用 Passport.js 进行 Node.js 身份验证 _[也就是你正在读的这章]_

9.  Testing Node.js applications 
测试 Node.js 应用

10.  Debugging Node.js 
调试 Node.js

11.  Securing your application 
巩固你的应用

12.  Deploying Node.js application to a PaaS
为 PaaS 部署 Node.js 应用
13.  Monitoring and operating Node.js applications
监控和执行 Node.js 应用

## Technologies to use
会用到的技术

Before jumping into the actual coding, let's take a look at the new technologies we are going to use in this chapter.
在真正进入实际编程前，我们来看一看在这一章要用到的新技术。

#### What is Passport.js?
Pasport.js 是什麽。

> Simple, unobtrusive authentication for Node.js - [passportjs.org](http://passportjs.org/)
简单，低调的 Node.js 身份验证。

![Passport.js is an authentication middleware for Node.js](http://ww4.sinaimg.cn/large/72f96cbagw1f4a78792utj20k0061jry)
Passport.js 是 Node.js 的身份验证中间件。

Passport is an authentication middleware for Node.js which we are going to use for session management.
Passport.js 是 Node.js 的身份验证中间件，我们可以用它来进行会话管理。

#### What is Redis?
Redis 是什么

> Redis is an open source (BSD licensed), in-memory data structure store, used as database, cache and message broker. - [redis.io](http://redis.io/)
Redis 是一个开源的（BSD 许可的），内存数据结构存储，用作数据库、缓存和消息代理。

We are going to store our user's session information in Redis, and not in the process's memory. This way our application will be a lot easier to scale.
我们将在 Redis 里面存储我们用户的会话信息，而不是在进程的内存当中。这样一来我们的应用相当容易衡量。

## The Demo Application
应用样品

For demonstration purposes, let’s build an application that does only the following:
处于展示的目的，让我们只执行以下步骤构建一个应用：
*   exposes a login form,
*   exposes two protected pages:
    *   a profile page,
    *   secured notes


显示登录表单
显示2个受保护的页面
概述页
可靠票据

### The Project Structure
项目结构

You have already learned [how to structure Node.js projects](https://blog.risingstack.com/node-hero-node-js-project-structure-tutorial/) in the previous chapter of Node Hero, so let's use that knowledge!
我们已经在前一个章节 Node Hero中学了【如何构建 Node.js 项目】，因此让我们应用这些知识吧！
We are going to use the following structure:
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


As you can see we will organize files and directories around features. We will have a user page, a note page, and some authentication related functionality.
如你所见，我们将围绕特性组织文件和目录。我们也会设置功能性的用户页，注释页，以及相关的身份验证。
_(Download the full source code at [https://github.com/RisingStack/nodehero-authentication](https://github.com/RisingStack/nodehero-authentication))_
在 下载所有的源代码。

### The Node.js Authentication Flow
Node.js 身份验证流。

Our goal is to implement the following authentication flow into our application:
我们的目标是在我们的应用当中实现如下的身份验证流：

1.  User enters username and password
1.用户输入用户名和密码
2.  The application checks if they are matching
2.应用检查用户名和密码是否相符
3.  If they are matching, it sends a `Set-Cookie` header that will be used to authenticate further pages
3.如果相符，则提交一个 ' Set-Cookie ' 的报头，用于下一级网页进行身份验证。
4.  When the user visits pages from the same domain, the previously set cookie will be added to all the requests
4.用户用同样的域名访问的时候，预先设置的 cookie 会加入到所有的请求中。
5.  Authenticate restricted pages with this cookie
5.带有这样 cokie 的身份验证受限页面


To set up an authentication strategy like this, follow these three steps:
为了设置像这样的身份验证策略，按照以下三步进行：

## Step 1: Setting up Express
步骤1.设置Express
We are going to use Express for the server framework - you can learn more on the topic by reading our [Express tutorial](https://blog.risingstack.com/your-first-node-js-http-server).

我们将为服务器框架配置Expres——通过阅读我们的[Express 教程]你会学到比主题更多的东西
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

What did we do here?
我们在这里做了哪些事情？
First of all, we required all the dependencies that the session management needs. After that we are created a new instance from the `express-session` module, which will store our sessions.
首先，我们需要会话管理需要的所有依赖。之后，从'express-session' 模块创建一个新的例子，用它来储存我们的会话。
For the backing store, we are using Redis, but you can use any other, like MySQL or MongoDB.
对于后备存储，我们现在使用的是 Redis ，不过你也可以用其他的，像 MySQL 、 MongoDB 之类的。

## Step 2: Setting up Passport for Node.js
第二步，为 Node.js 配置 Passport

Passport is a great example of a library using plugins. For this tutorial, we are adding the `passport-local` module which enables easy integration of a simple local authentication strategy using usernames and passwords.
Passprot 是插件库的一个很棒的例子。这个教程当中，我们加入了 ' passport-local '模块，实现了利用用户名和密码的本地身份验证策略更加简单的集成。

For the sake of simplicity, in this example, we are not using a second backing store, but only an in-memory user instance. In real life applications, the `findUser` would look up a user in a database.
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

Once the `findUser` returns with our user object the only thing left is to compare the user-fed and the real password to see if there is a match.
一旦用户对象的'findUser' 返回，唯一剩下的就是用户供应的对比以及世界密码检测是否相符。

If it is a match, we let the user in (by returning the user to passport - `return done(null, user)`), if not we return an unauthorized error (by returning nothing to passport - `return done(null)`).
如果符合，我们允许用户登入（用户返回到通行证，返回结束）如果不符合，返回未验证错误。
## Step 3: Adding Protected Endpoints
第三步，添加受保护节点

To add protected endpoints, we are leveraging the middleware pattern Express uses. For that, let's create the authentication middleware first:
为了添加受保护节点，我们利用中间件模式表示使用。为此，我们首先创建身份验证中间件

    // file:app/authentication/middleware.js
    function authenticationMiddleware () {  
      return function (req, res, next) {
        if (req.isAuthenticated()) {
          return next()
        }
        res.redirect('/')
      }
    }

It only has one role if the user is authenticated (has the right cookies) it simply calls the next middleware; otherwise it redirects to the page where the user can log in.

如果用户通过验证（拥有正确的 cookies ） 它就只有一个作用，只是调用下一个中间件，否则它就需要对用户可以登录的位置重新定向。

Using it is as easy as adding a new middleware to the route definition.
利用它就和向路由添加新的中间件一样简单。

    // file:app/user/init.js
    const passport = require('passport')

    app.get('/profile', passport.authenticationMiddleware(), renderProfile)  

## Summary
总结
["Setting up authentication for Node.js with Passport is a piece of cake!” via @RisingStack #nodejs](https://twitter.com/share?text=%22Setting%20up%20authentication%20for%20Node.js%20with%20Passport%20is%20a%20piece%20of%20cake!%E2%80%9D%20via%20%40RisingStack%20%23nodejs;url=https://blog.risingstack.com/node-hero-node-js-authentication-passport-js)
@RisingStack 说 为带有 Passport 的 Node.js 配置身份验证就是小菜一碟。

[Click To Tweet](https://twitter.com/share?text=%22Rule+1:+Organize+your+files+around+features,+not+roles!%22+via+%40RisingStack&url=https://blog.risingstack.com/node-hero-node-js-authentication-passport-js)
点击推特

In this Node.js tutorial, you have learned how to add basic authentication to your application. Later on, you can extend it with different authentication strategies, like Facebook or Twitter. You can find more strategies at [http://passportjs.org/](http://passportjs.org/).
这次的 Node.js 教程当中，你学习了如何为应用添加基本的身份验证。之后，你可以通过像 Facebook 或者 Twitter之类 不同的身份验证策略丰富这个主题。在（）里你可以发现更多的策略

The full, working example is on GitHub, you can take a look here: [https://github.com/RisingStack/nodehero-authentication](https://github.com/RisingStack/nodehero-authentication)
全部的代码和实例都在 Github 上面，你可以看一下。

## Next up
接下来
The next chapter of Node Hero will be all about testing Node.js applications. You will learn concepts like unit testing, test pyramid, test doubles and a lot more!
Node Hero 的下一章都是关于测试 Node.js 应用的。你会学到单元测试，测试金字塔，测试模块等等更多的东西

Share your questions and feedbacks in the comment section.
请在评论部分分享你的问题和反馈。
