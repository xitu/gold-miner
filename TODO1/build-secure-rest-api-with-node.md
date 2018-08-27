> * 原文地址：[Build a Simple REST API with Node and OAuth 2.0](https://developer.okta.com/blog/2018/08/21/build-secure-rest-api-with-node)
> * 原文作者：[Braden Kelley](https://developer.okta.com/blog/2018/08/21/build-secure-rest-api-with-node)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/build-secure-rest-api-with-node.md](https://github.com/xitu/gold-miner/blob/master/TODO1/build-secure-rest-api-with-node.md)
> * 译者：
> * 校对者：

# Build a Simple REST API with Node and OAuth 2.0

JavaScript is used everywhere on the web - nearly every web page will include at least some JavaScript, and even if it doesn’t, your browser probably has some sort of extension that injects bits of JavaScript code on to the page anyway. It’s hard to avoid in 2018.

JavaScript can also be used outside the context of a browser, for anything from hosting a web server to controlling an RC car or running a full-fledged operating system. Sometimes you want a couple of servers to talk to each other, whether on a local network or over the internet.

Today, I’ll show you how to create a REST API using Node.js, and secure it with OAuth 2.0 to prevent unwarranted requests. REST APIs are all over the web, but without the proper tools require a ton of boilerplate code. I’ll show you how to use a couple of amazing tools that make it all a breeze, including Okta to implement the Client Credentials Flow, which securely connects two machines together without the context of a user.

## Build Your Node Server

Setting up a web server in Node is quite simple using the [Express JavaScript library](https://expressjs.com/). Make a new folder that will contain your server.

```
$ mkdir rest-api
```

Node uses a `package.json` to manage dependencies and define your project. To create one, use `npm init`, which will ask you some questions to help you initialize the project. For now, you can use [standard JS](https://standardjs.com/) to enforce a coding standard, and use that as the tests.

```
$ cd rest-api

$ npm init
This utility will walk you through creating a package.json file.
It only covers the most common items, and tries to guess sensible defaults.

See `npm help json` for definitive documentation on these fields
and exactly what they do.

Use `npm install <pkg>` afterwards to install a package and
save it as a dependency in the package.json file.

Press ^C at any time to quit.
package name: (rest-api)
version: (1.0.0)
description: A parts catalog
entry point: (index.js)
test command: standard
git repository:
keywords:
author:
license: (ISC)
About to write to /Users/Braden/code/rest-api/package.json:

{
  "name": "rest-api",
  "version": "1.0.0",
  "description": "A parts catalog",
  "main": "index.js",
  "scripts": {
    "test": "standard"
  },
  "author": "",
  "license": "ISC"
}


Is this OK? (yes)
```

The default entry point is `index.js`, so you should create a new file by that name. The following code will get you a really basic server that doesn’t really do anything but listens on port 3000 by default.

**index.js**

```
const express = require('express')
const bodyParser = require('body-parser')
const { promisify } = require('util')

const app = express()
app.use(bodyParser.json())

const startServer = async () => {
  const port = process.env.SERVER_PORT || 3000
  await promisify(app.listen).bind(app)(port)
  console.log(`Listening on port ${port}`)
}

startServer()
```

The `promisify` function of `util` lets you take a function that expects a callback and instead will return a Promise, which is the new standard as far as handling asynchronous code. This also lets us use the relatively new `async`/`await` syntax and make our code look much prettier.

In order for this to work, you need to install the dependencies that you `require` at the top of the file. Add them using `npm install`. This will automatically save some metadata to your `package.json` file and install them locally in a `node_modules` folder.

**Note**: You should never commit `node_modules` to source control because it tends to become bloated quickly, and the `package-lock.json` file will keep track of the exact versions you used to that if you install this on another machine they get the same code.

```
$ npm install express@4.16.3 util@0.11.0
```

For some quick linting, install `standard` as a dev dependency, then run it to make sure your code is up to par.

```
$ npm install --save-dev standard@11.0.1
$ npm test

> rest-api@1.0.0 test /Users/bmk/code/okta/apps/rest-api
> standard
```

If all is well, you shouldn’t see any output past the `> standard` line. If there’s an error, it might look like this:

```
$ npm test

> rest-api@1.0.0 test /Users/bmk/code/okta/apps/rest-api
> standard

standard: Use JavaScript Standard Style (https://standardjs.com)
standard: Run `standard --fix` to automatically fix some problems.
  /Users/Braden/code/rest-api/index.js:3:7: Expected consistent spacing
  /Users/Braden/code/rest-api/index.js:3:18: Unexpected trailing comma.
  /Users/Braden/code/rest-api/index.js:3:18: A space is required after ','.
  /Users/Braden/code/rest-api/index.js:3:38: Extra semicolon.
npm ERR! Test failed.  See above for more details.
```

Now that your code is ready and you have installed your dependencies, you can run your server with `node .` (the `.` says to look at the current directory, and then checks your `package.json` file to see that the main file to use in this directory is `index.js`):

```
$ node .

Listening on port 3000
```

To test that it’s working, you can use the `curl` command. There are no endpoints yet, so express will return an error:

```
$ curl localhost:3000 -i
HTTP/1.1 404 Not Found
X-Powered-By: Express
Content-Security-Policy: default-src 'self'
X-Content-Type-Options: nosniff
Content-Type: text/html; charset=utf-8
Content-Length: 139
Date: Thu, 16 Aug 2018 01:34:53 GMT
Connection: keep-alive

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Error</title>
</head>
<body>
<pre>Cannot GET /</pre>
</body>
</html>
```

Even though it says it’s an error, that’s good. You haven’t set up any endpoints yet, so the only thing for Express to return is a 404 error. If your server wasn’t running at all, you’d get an error like this:

```
$ curl localhost:3000 -i
curl: (7) Failed to connect to localhost port 3000: Connection refused
```

## Build Your REST API with Express, Sequelize, and Epilogue

Now that you have a working Express server, you can add a REST API. This is actually much simpler than you might think. The easiest way I’ve seen is by using [Sequelize](http://docs.sequelizejs.com/) to define your database schema, and [Epilogue](https://github.com/dchester/epilogue) to create some REST API endpoints with near-zero boilerplate.

You’ll need to add those dependencies to your project. Sequelize also needs to know how to communicate with the database. For now, use SQLite as it will get us up and running quickly.

```
npm install sequelize@4.38.0 epilogue@0.7.1 sqlite3@4.0.2
```

Create a new file `database.js` with the following code. I’ll explain each part in more detail below.

**database.js**

```
const Sequelize = require('sequelize')
const epilogue = require('epilogue')

const database = new Sequelize({
  dialect: 'sqlite',
  storage: './test.sqlite',
  operatorsAliases: false
})

const Part = database.define('parts', {
  partNumber: Sequelize.STRING,
  modelNumber: Sequelize.STRING,
  name: Sequelize.STRING,
  description: Sequelize.TEXT
})

const initializeDatabase = async (app) => {
  epilogue.initialize({ app, sequelize: database })

  epilogue.resource({
    model: Part,
    endpoints: ['/parts', '/parts/:id']
  })

  await database.sync()
}

module.exports = initializeDatabase
```

Now you just need to import that file into your main app and run the initialization function. Make the following additions to your `index.js` file.

**index.js**

```
@@ -2,10 +2,14 @@ const express = require('express')
 const bodyParser = require('body-parser')
 const { promisify } = require('util')

+const initializeDatabase = require('./database')
+
 const app = express()
 app.use(bodyParser.json())

 const startServer = async () => {
+  await initializeDatabase(app)
+
   const port = process.env.SERVER_PORT || 3000
   await promisify(app.listen).bind(app)(port)
   console.log(`Listening on port ${port}`)
```

You can now test for syntax errors and run the app if everything seems good:

```
$ npm test && node .

> rest-api@1.0.0 test /Users/bmk/code/okta/apps/rest-api
> standard

Executing (default): CREATE TABLE IF NOT EXISTS `parts` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `partNumber` VARCHAR(255), `modelNu
mber` VARCHAR(255), `name` VARCHAR(255), `description` TEXT, `createdAt` DATETIME NOT NULL, `updatedAt` DATETIME NOT NULL);
Executing (default): PRAGMA INDEX_LIST(`parts`)
Listening on port 3000
```

In another terminal, you can test that this is actually working (to format the JSON response I use a [json CLI](https://github.com/trentm/json), installed globally using `npm install --global json`):

```
$ curl localhost:3000/parts
[]

$ curl localhost:3000/parts -X POST -d '{
  "partNumber": "abc-123",
  "modelNumber": "xyz-789",
  "name": "Alphabet Soup",
  "description": "Soup with letters and numbers in it"
}' -H 'content-type: application/json' -s0 | json
{
  "id": 1,
  "partNumber": "abc-123",
  "modelNumber": "xyz-789",
  "name": "Alphabet Soup",
  "description": "Soup with letters and numbers in it",
  "updatedAt": "2018-08-16T02:22:09.446Z",
  "createdAt": "2018-08-16T02:22:09.446Z"
}

$ curl localhost:3000/parts -s0 | json
[
  {
    "id": 1,
    "partNumber": "abc-123",
    "modelNumber": "xyz-789",
    "name": "Alphabet Soup",
    "description": "Soup with letters and numbers in it",
    "createdAt": "2018-08-16T02:22:09.446Z",
    "updatedAt": "2018-08-16T02:22:09.446Z"
  }
]
```

### What’s Going On Here?

Feel free to skip this section if you followed along with all that, but I did promise an explanation.

The `Sequelize` function creates a database. This is where you configure details, such as what dialect of SQL to use. For now, use SQLite to get up and running quickly.

```
const database = new Sequelize({
  dialect: 'sqlite',
  storage: './test.sqlite',
  operatorsAliases: false
})
```

Once you’ve created the database, you can define the schema for it using `database.define` for each table. Create a table called `parts` with a few useful fields to keep track of parts. By default, Sequelize also automatically creates and updates `id`, `createdAt`, and `updatedAt` fields when you create or update a row.

```
const Part = database.define('parts', {
  partNumber: Sequelize.STRING,
  modelNumber: Sequelize.STRING,
  name: Sequelize.STRING,
  description: Sequelize.TEXT
})
```

Epilogue requires access to your Express `app` in order to add endpoints. However, `app` is defined in another file. One way to deal with this is to export a function that takes the app and does something with it. In the other file when we import this script, you would run it like `initializeDatabase(app)`.

Epilogue needs to initialize with both the `app` and the `database`. You then define which REST endpoints you would like to use. The `resource` function will include endpoints for the `GET`, `POST`, `PUT`, and `DELETE` verbs, mostly automagically.

To actually create the database, you need to run `database.sync()`, which returns a Promise. You’ll want to wait until it’s finished before starting your server.

The `module.exports` command says that the `initializeDatabase` function can be imported from another file.

```
const initializeDatabase = async (app) => {
  epilogue.initialize({ app, sequelize: database })

  epilogue.resource({
    model: Part,
    endpoints: ['/parts', '/parts/:id']
  })

  await database.sync()
}

module.exports = initializeDatabase
```

## Secure Your Node + Express REST API with OAuth 2.0

Now that you have a REST API up and running, imagine you’d like a specific application to use this from a remote location. If you host this on the internet as is, then anybody can add, modify, or remove parts at their will.

To avoid this, you can use the OAuth 2.0 Client Credentials Flow. This is a way of letting two servers communicate with each other, without the context of a user. The two servers must agree ahead of time to use a third-party authorization server. Assume there are two servers, A and B, and an authorization server. Server A is hosting the REST API, and Server B would like to access the API.

*   Server B sends a secret key to the authorization server to prove who they are and asks for a temporary token.
*   Server B then consumes the REST API as usual but sends the token along with the request.
*   Server A asks the authorization server for some metadata that can be used to verify tokens.
*   Server A verifies the Server B’s request.
    *   If it’s valid, a successful response is sent and Server B is happy.
    *   If the token is invalid, an error message is sent instead, and no sensitive information is leaked.

### Create an Authorization Server

This is where Okta comes into play. Okta can act as an authorization server to allow you to secure your data. You’re probably asking yourself “Why Okta? Well, it’s pretty cool to build a REST app, but it’s even cooler to build a _secure_ one. To achieve that, you’ll want to add authentication so users have to log in before viewing/modifying groups. At Okta, our goal is to make [identity management](https://developer.okta.com/product/user-management/) a lot easier, more secure, and more scalable than what you’re used to. Okta is a cloud service that allows developers to create, edit, and securely store user accounts and user account data, and connect them with one or multiple applications. Our API enables you to:

*   [Authenticate](https://developer.okta.com/product/authentication/) and [authorize](https://developer.okta.com/product/authorization/) your users
*   Store data about your users
*   Perform password-based and [social login](https://developer.okta.com/authentication-guide/social-login/)
*   Secure your application with [multi-factor authentication](https://developer.okta.com/use_cases/mfa/)
*   And much more! Check out our [product documentation](https://developer.okta.com/documentation/)

If you don’t already have one, [sign up for a forever-free developer account](https://developer.okta.com/signup/), and let’s get started!

After creating your account, log in to your developer console, navigate to **API**, then to the **Authorization Servers** tab. Click on the link to your `default` server.

From this **Settings** tab, copy the `Issuer` field. You’ll need to save this somewhere that your Node app can read. In your project, create a file named `.env` that looks like this:

**.env**

```
ISSUER=https://{yourOktaDomain}/oauth2/default
```

The value for `ISSUER` should be the value from the Settings page’s `Issuer URI` field.

![Higlighting the issuer URL.](/assets/blog/rest-api-node/issuer-afa0da4b4f632196092a4da8f243f3bec37615602dc5b62e8e34546fd1018333.png)

**Note**: As a general rule, you should not store this `.env` file in source control. This allows multiple projects to use the same source code without needing a separate fork. It also makes sure that your secure information is not public (especially if you’re publishing your code as open source).

Next, navigate to the **Scopes** tab. Click the **Add Scope** button and create a scope for your REST API. You’ll need to give it a name (e.g. `parts_manager`) and you can give it a description if you like.

![Add scope screenshot.](/assets/blog/rest-api-node/adding-scope-f3ecb3b4eec06d616a130400245843c0de2dd52a54b2fdcff7449a10a2ce75ed.png)

You should add the scope name to your `.env` file as well so your code can access it.

**.env**

```
ISSUER=https://{yourOktaDomain}/oauth2/default
SCOPE=parts_manager
```

Now you need to create a client. Navigate to **Applications**, then click **Add Application**. Select **Service**, then click **Next**. Enter a name for your service, (e.g. `Parts Manager`), then click **Done**.

This will take you to a page that has your client credentials. These are the credentials that Server B (the one that will consume the REST API) will need in order to authenticate. For this example, the client and server code will be in the same repository, so go ahead and add this data to your `.env` file. Make sure to replace `{yourClientId}` and `{yourClientSecret}` with the values from this page.

```
CLIENT_ID={yourClientId}
CLIENT_SECRET={yourClientSecret}
```

### Create Middleware to Verify Tokens in Express

In Express, you can add middleware that will run before each endpoint. You can then add metadata, set headers, log some information, or even cancel the request early and send an error message. In this case, you’ll want to create some middleware that verifies the token sent by the client. If the token is valid, it will continue to the REST API and return the appropriate response. If the token is invalid, it will instead respond with an error message so that only authorized machines have access.

To validate tokens, you can use Okta’s middleware. You’ll also need a tool called [dotenv](https://github.com/motdotla/dotenv) to load the environment variables:

```
npm install dotenv@6.0.0 @okta/jwt-verifier@0.0.12
```

Now create a file named `auth.js` that will export the middleware:

**auth.js**

```
const OktaJwtVerifier = require('@okta/jwt-verifier')

const oktaJwtVerifier = new OktaJwtVerifier({ issuer: process.env.ISSUER })

module.exports = async (req, res, next) => {
  try {
    const { authorization } = req.headers
    if (!authorization) throw new Error('You must send an Authorization header')

    const [authType, token] = authorization.trim().split(' ')
    if (authType !== 'Bearer') throw new Error('Expected a Bearer token')

    const { claims } = await oktaJwtVerifier.verifyAccessToken(token)
    if (!claims.scp.includes(process.env.SCOPE)) {
      throw new Error('Could not verify the proper scope')
    }
    next()
  } catch (error) {
    next(error.message)
  }
}
```

This function first checks that the `authorization` header is on the request and throws an error otherwise. If it exists, it should look like `Bearer {token}` where `{token}` is a [JWT](https://www.jsonwebtoken.io/) string. This will throw another error if the header doesn’t start with `Bearer` . Then we send the token to [Okta’s JWT Verifier](https://github.com/okta/okta-oidc-js/tree/master/packages/jwt-verifier) to validate the token. If the token is invalid, the JWT verifier will throw an error. Otherwise, it will return an object with some information. You can then verify that the claims include the scope that you’re expecting.

If everything is successful, it calls the `next()` function without any parameters, which tells Express that it’s OK to move on to the next function in the chain (either another middleware or the final endpoint). If you pass a string into the `next` function, Express treats it as an error that will be passed back to the client, and will not proceed in the chain.

You still need to import this function and add it as middleware to your app. You also need to load `dotenv` at the top of your index file to make sure that the environment variables from `.env` are loaded in your app. Make the following changes to `index.js`:

**index.js**

```
@@ -1,11 +1,14 @@
+require('dotenv').config()
 const express = require('express')
 const bodyParser = require('body-parser')
 const { promisify } = require('util')

+const authMiddleware = require('./auth')
 const initializeDatabase = require('./database')

 const app = express()
 app.use(bodyParser.json())
+app.use(authMiddleware)

 const startServer = async () => {
   await initializeDatabase(app)
```

To test that requests are properly blocked, try running it again…

```
$ npm test && node .
```

…then in another terminal run a few `curl` commands to test for:

1.  An authorization header is required

```
$ curl localhost:3000/parts
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Error</title>
</head>
<body>
<pre>You must send an Authorization header</pre>
</body>
</html>
```

2.  A Bearer token is required in the authorization header

```
$ curl localhost:3000/parts -H 'Authorization: Basic asdf:1234'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Error</title>
</head>
<body>
<pre>Expected a Bearer token</pre>
</body>
</html>
```

3.  The Bearer token is valid

```
$ curl localhost:3000/parts -H 'Authorization: Bearer asdf'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Error</title>
</head>
<body>
<pre>Jwt cannot be parsed</pre>
</body>
</html>
```

### Create a Test Client in Node

You have now disabled access to the app for someone without a valid token, but how do you get a token and use it? I’ll show you how to write a simple client in Node, which will also help you test that a valid token works.

```
npm install btoa@1.2.1 request-promise@4.2.2
```

**client.js**

```
require('dotenv').config()
const request = require('request-promise')
const btoa = require('btoa')

const { ISSUER, CLIENT_ID, CLIENT_SECRET, SCOPE } = process.env

const [,, uri, method, body] = process.argv
if (!uri) {
  console.log('Usage: node client {url} [{method}] [{jsonData}]')
  process.exit(1)
}

const sendAPIRequest = async () => {
  const token = btoa(`${CLIENT_ID}:${CLIENT_SECRET}`)
  try {
    const auth = await request({
      uri: `${ISSUER}/v1/token`,
      json: true,
      method: 'POST',
      headers: {
        authorization: `Basic ${token}`
      },
      form: {
        grant_type: 'client_credentials',
        scope: SCOPE
      }
    })

    const response = await request({
      uri,
      method,
      body,
      headers: {
        authorization: `${auth.token_type} ${auth.access_token}`
      }
    })

    console.log(response)
  } catch (error) {
    console.log(`Error: ${error.message}`)
  }
}

sendAPIRequest()
```

Here the code is loading the variables from `.env` into the environment, then grabbing them from Node. Node stores environment variables in `process.env` (`process` is a global variable with a bunch of useful variables and functions).

```
require('dotenv').config()
// ...
const { ISSUER, CLIENT_ID, CLIENT_SECRET, SCOPE } = process.env
// ...
```

Next, since this will be run from the command line, you can use `process` again to grab the arguments passed in with `process.argv`. This gives you an array with all the arguments passed in. The first two commas are there without variable names in front of them because the first two are unimportant in this case; those will just be the path to `node`, and the name of the script (`client` or `client.js`).

The URL is required, which would include the endpoint, but the method and JSON data are optional. The default method is `GET`, so if you’re just fetching data you can leave that out. You also wouldn’t need any payload in that case. If the arguments don’t seem right, then this will exit the program with an error message and an exit code of `1`, signifying an error.

```
const [,, uri, method, body] = process.argv
if (!uri) {
  console.log('Usage: node client {url} [{method}] [{jsonData}]')
  process.exit(1)
}
```

Node currently doesn’t allow for `await` in the main thread, so to make use of the cleaner `async`/`await` syntax, you have to create a function and then call it afterward.

If an error occurs in any of the `await`ed functions, the `try`/`catch` they’ll be printed out to the screen.

```
const sendAPIRequest = async () => {
  try {
    // ...
  } catch (error) {
    console.error(`Error: ${error.message}`)
  }
}

sendAPIRequest()
```

This is where the client sends a request to the authorization server for a token. For authorizing with the authorization server itself, you need to use Basic Auth. Basic Auth is the same thing a browser uses when you get one of those built-in pop-ups asking for a username and password. Say your username is `AzureDiamond` and your password is `hunter2`. Your browser would then concatenate them together with a colon (`:`) and then encode them with base64 (this is what the `btoa` function does) to get `QXp1cmVEaWFtb25kOmh1bnRlcjI=`. It then sends an authorization header of `Basic QXp1cmVEaWFtb25kOmh1bnRlcjI=`. The server can then decode the token with base64 to get the username and password.

Basic authorization isn’t inherently secure because it’s so easy to decode, which is why `https` is important, to prevent a man-in-the-middle attack. Here, the client ID and client secret are the username and password, respectively. That’s also why it’s important to keep your `CLIENT_ID` and `CLIENT_SECRET` private.

For OAuth 2.0, you also need to specify the grant type, which in this case is `client_credentials` since you’re planning to talk between two machines. You also need to specify the scope. There are a lot of other options that could be added here, but this is all we need for this demo.

```
const token = btoa(`${CLIENT_ID}:${CLIENT_SECRET}`)
const auth = await request({
  uri: `${ISSUER}/v1/token`,
  json: true,
  method: 'POST',
  headers: {
    authorization: `Basic ${token}`
  },
  form: {
    grant_type: 'client_credentials',
    scope: SCOPE
  }
})
```

Once you’re authenticated, you’ll get an access token that you can send along to your REST API that should look something like `Bearer eyJra...HboUg` (the actual token is much longer than that – likely somewhere around 800 characters). The token contains all the information needed for the REST API to verify who you are, when the token will expire, and all kinds of other information, like the scopes requested, the issuer, and the client ID used to request the token.

The response from the REST API is then printed to the screen.

```
const response = await request({
  uri,
  method,
  body,
  headers: {
    authorization: `${auth.token_type} ${auth.access_token}`
  }
})

console.log(response)
```

Go ahead and test it out now. Again, start the app with `npm test && node .`, then try out some commands like the following:

```
$ node client http://localhost:3000/parts | json
[
  {
    "id": 1,
    "partNumber": "abc-123",
    "modelNumber": "xyz-789",
    "name": "Alphabet Soup",
    "description": "Soup with letters and numbers in it",
    "createdAt": "2018-08-16T02:22:09.446Z",
    "updatedAt": "2018-08-16T02:22:09.446Z"
  }
]

$ node client http://localhost:3000/parts post '{
  "partNumber": "ban-bd",
  "modelNumber": 1,
  "name": "Banana Bread",
  "description": "Bread made from bananas"
}' | json
{
  "id": 2,
  "partNumber": "ban-bd",
  "modelNumber": "1",
  "name": "Banana Bread",
  "description": "Bread made from bananas",
  "updatedAt": "2018-08-17T00:23:23.341Z",
  "createdAt": "2018-08-17T00:23:23.341Z"
}

$ node client http://localhost:3000/parts | json
[
  {
    "id": 1,
    "partNumber": "abc-123",
    "modelNumber": "xyz-789",
    "name": "Alphabet Soup",
    "description": "Soup with letters and numbers in it",
    "createdAt": "2018-08-16T02:22:09.446Z",
    "updatedAt": "2018-08-16T02:22:09.446Z"
  },
  {
    "id": 2,
    "partNumber": "ban-bd",
    "modelNumber": "1",
    "name": "Banana Bread",
    "description": "Bread made from bananas",
    "createdAt": "2018-08-17T00:23:23.341Z",
    "updatedAt": "2018-08-17T00:23:23.341Z"
  }
]

$ node client http://localhost:3000/parts/1 delete | json
{}

$ node client http://localhost:3000/parts | json
[
  {
    "id": 2,
    "partNumber": "ban-bd",
    "modelNumber": "1",
    "name": "Banana Bread",
    "description": "Bread made from bananas",
    "createdAt": "2018-08-17T00:23:23.341Z",
    "updatedAt": "2018-08-17T00:23:23.341Z"
  }
]
```

## Learn More About Node and OAuth 2.0 Client Credentials with Okta

Hopefully you’ve seen how easy it is to create a REST API in Node and secure it from unauthorized users. Now that you’ve had a chance to make your own sample project, check out some of these other great resources about Node, OAuth 2.0, and Okta. You can also browse the Okta developer blog for other excellent articles.

*   [Implementing the Client Credentials Flow](https://developer.okta.com/authentication-guide/implementing-authentication/client-creds)
*   [Validating Access Tokens](https://developer.okta.com/authentication-guide/tokens/validating-access-tokens)
*   [Customizing Your Authorization Server](https://developer.okta.com/authentication-guide/implementing-authentication/set-up-authz-server)
*   [Tutorial: Build a Basic CRUD App with Node.js](/blog/2018/06/28/tutorial-build-a-basic-crud-app-with-node)
*   [Secure a Node API with OAuth 2.0 Client Credentials](/blog/2018/06/06/node-api-oauth-client-credentials)

As always, you can hit us up in the comments below with feedback or questions, or on Twitter [@oktadev](https://twitter.com/OktaDev). We look forward to hearing from you!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
