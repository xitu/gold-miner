>* 原文链接 : [Node Hero - Node.js Authentication using Passport.js](https://blog.risingstack.com/node-hero-node-js-authentication-passport-js/)
* 原文作者 : [risingstack](https://blog.risingstack.com)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 :  [circlelove](https://github.com/circlelove)
* 校对者:


This is the 8th part of the tutorial series called Node Hero - in these chapters, you can learn how to get started with Node.js and deliver software products using it.

In this tutorial, you are going to learn how to implement a local Node.js authentication strategy using Passport.js and Redis.

Upcoming and past chapters:

1.  [Getting started with Node.js](/node-hero-tutorial-getting-started-with-node-js)
2.  [Using NPM](/node-hero-npm-tutorial)
3.  [Understanding async programming](/node-hero-async-programming-in-node-js)
4.  [Your first Node.js HTTP server](/your-first-node-js-http-server)
5.  [Node.js database tutorial](/node-js-database-tutorial)
6.  [Node.js request module tutorial](/node-hero-node-js-request-module-tutorial)
7.  [Node.js project structure tutorial](/node-hero-node-js-project-structure-tutorial)
8.  Node.js authentication using Passport.js _[you are reading it now]_
9.  Testing Node.js applications
10.  Debugging Node.js
11.  Securing your application
12.  Deploying Node.js application to a PaaS
13.  Monitoring and operating Node.js applications

## Technologies to use

Before jumping into the actual coding, let's take a look at the new technologies we are going to use in this chapter.

#### What is Passport.js?

> Simple, unobtrusive authentication for Node.js - [passportjs.org](http://passportjs.org/)

![Passport.js is an authentication middleware for Node.js](http://ww4.sinaimg.cn/large/72f96cbagw1f4a78792utj20k0061jry)

Passport is an authentication middleware for Node.js which we are going to use for session management.

#### What is Redis?

> Redis is an open source (BSD licensed), in-memory data structure store, used as database, cache and message broker. - [redis.io](http://redis.io/)

We are going to store our user's session information in Redis, and not in the process's memory. This way our application will be a lot easier to scale.

## The Demo Application

For demonstration purposes, let’s build an application that does only the following:

*   exposes a login form,
*   exposes two protected pages:
    *   a profile page,
    *   secured notes

### The Project Structure

You have already learned [how to structure Node.js projects](https://blog.risingstack.com/node-hero-node-js-project-structure-tutorial/) in the previous chapter of Node Hero, so let's use that knowledge!

We are going to use the following structure:

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

_(Download the full source code at [https://github.com/RisingStack/nodehero-authentication](https://github.com/RisingStack/nodehero-authentication))_

### The Node.js Authentication Flow

Our goal is to implement the following authentication flow into our application:

1.  User enters username and password
2.  The application checks if they are matching
3.  If they are matching, it sends a `Set-Cookie` header that will be used to authenticate further pages
4.  When the user visits pages from the same domain, the previously set cookie will be added to all the requests
5.  Authenticate restricted pages with this cookie

To set up an authentication strategy like this, follow these three steps:

## Step 1: Setting up Express

We are going to use Express for the server framework - you can learn more on the topic by reading our [Express tutorial](https://blog.risingstack.com/your-first-node-js-http-server).

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

First of all, we required all the dependencies that the session management needs. After that we are created a new instance from the `express-session` module, which will store our sessions.

For the backing store, we are using Redis, but you can use any other, like MySQL or MongoDB.

## Step 2: Setting up Passport for Node.js

Passport is a great example of a library using plugins. For this tutorial, we are adding the `passport-local` module which enables easy integration of a simple local authentication strategy using usernames and passwords.

For the sake of simplicity, in this example, we are not using a second backing store, but only an in-memory user instance. In real life applications, the `findUser` would look up a user in a database.

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

If it is a match, we let the user in (by returning the user to passport - `return done(null, user)`), if not we return an unauthorized error (by returning nothing to passport - `return done(null)`).

## Step 3: Adding Protected Endpoints

To add protected endpoints, we are leveraging the middleware pattern Express uses. For that, let's create the authentication middleware first:

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

Using it is as easy as adding a new middleware to the route definition.

    // file:app/user/init.js
    const passport = require('passport')

    app.get('/profile', passport.authenticationMiddleware(), renderProfile)  

## Summary

["Setting up authentication for Node.js with Passport is a piece of cake!” via @RisingStack #nodejs](https://twitter.com/share?text=%22Setting%20up%20authentication%20for%20Node.js%20with%20Passport%20is%20a%20piece%20of%20cake!%E2%80%9D%20via%20%40RisingStack%20%23nodejs;url=https://blog.risingstack.com/node-hero-node-js-authentication-passport-js)

[Click To Tweet](https://twitter.com/share?text=%22Rule+1:+Organize+your+files+around+features,+not+roles!%22+via+%40RisingStack&url=https://blog.risingstack.com/node-hero-node-js-authentication-passport-js)

In this Node.js tutorial, you have learned how to add basic authentication to your application. Later on, you can extend it with different authentication strategies, like Facebook or Twitter. You can find more strategies at [http://passportjs.org/](http://passportjs.org/).

The full, working example is on GitHub, you can take a look here: [https://github.com/RisingStack/nodehero-authentication](https://github.com/RisingStack/nodehero-authentication)

## Next up

The next chapter of Node Hero will be all about testing Node.js applications. You will learn concepts like unit testing, test pyramid, test doubles and a lot more!

Share your questions and feedbacks in the comment section.
