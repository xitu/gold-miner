> * 原文地址：[Build a Simple REST API with Node and OAuth 2.0](https://developer.okta.com/blog/2018/08/21/build-secure-rest-api-with-node)
> * 原文作者：[Braden Kelley](https://developer.okta.com/blog/2018/08/21/build-secure-rest-api-with-node)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/build-secure-rest-api-with-node.md](https://github.com/xitu/gold-miner/blob/master/TODO1/build-secure-rest-api-with-node.md)
> * 译者：
> * 校对者：

# 使用 Node 和OAuth 2.0 构建一个简单的 REST API

JavaScript 在 web 是随处可见 —— 几乎每个 web 页面都会或多或少的包含一些 JavaScript，即使没有 JavaScript，你的浏览器也可能存在某种扩展类型向页面中注入一些 JavaScript 代码。在 2018，这些事情都不可避免。

JavaScript 也可以用于浏览器的上下文之外的任何事情，从托管 web 服务器到 RC 汽车或运行成熟的操作系统。有时你想要几个一组无论是在本地网络还是在互联网上都可以相互交流的服务器。

今天，我会向你演示如何使用 Node.js 创建一个 REST API，并使用 OAuth 2.0 保证它的安全性，以此来阻止不必要的请求。REST API 在 web 上比比皆是，但如果没有合适的工具，就需要大量的样板代码。我会向你演示如何使用可以轻松实现客户端认证流的令人惊讶的一些工具，它可以在没有用户上下文的情况下将两台机器安全地连接。

## 构建你的 Node 服务器

使用 [Express JavaScript 库](https://expressjs.com/) 在 Node 中设置 web 服务器非常简单。创建一个包含服务器的新文件夹。

```
$ mkdir rest-api
```

Node 使用 `package.json` 来管理依赖并定义你的项目。我们使用 `npm init` 来新建该文件。该命令会在帮助你初始化项目时询问你一些问题。现在你可以使用[标准 JS](https://standardjs.com/) 来强制执行编码标准，并将其用作测试。

```
$ cd rest-api

$ npm init
这个实用工具将引导你创建 package.json 文件。
它只涵盖最常见的项目，并试图猜测合理的默认值。

请参阅 `npm help json` 
来获取关于这些字段的确切文档以及它们所做的事情。

使用 `npm install <pkg>` 
安装包并将其保存为 package.json 文件中的依赖项。

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

默认的入口端点是 `index.js`，因此你应该以此为名创建一个文件。下面的代码将为你提供一个出了默认监听 3000 端口以外什么也不做的非常基本的服务器。

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

`util` 的 `promisify` 函数允许你接受一个期望回调的函数，然后返回一个 promise，这是处理异步代码的新标准。这还允许我们使用相对较新的 `async`/`await` 语法，并使我们的代码看起来漂亮得多。

为了让它运行，你需要在文件顶部下载你 `require` 的依赖。使用 `npm install` 来添加它们。这会将一些元数据自动保存到你的 `package.json` 文件中，并将它们下载到本地的 `node_modules` 文件中。

**注意**：你永远都不应该向源代码提交 `node_modules`，因为对于源代码的管理，往往会很快就变得臃肿，而 `package-lock.json` 文件将跟踪你使用的确切版本，如果你将其安装在另一台计算机上，它们将得到相同的代码。

```
$ npm install express@4.16.3 util@0.11.0
```

对于一些快速 linting，请安装 `standard` 作为 dev 依赖，然后运行它以确保你的代码达到标准。

```
$ npm install --save-dev standard@11.0.1
$ npm test

> rest-api@1.0.0 test /Users/bmk/code/okta/apps/rest-api
> standard
```

如果一切顺利，你不应该看到任何输出超过 `> standard` 线。如果有错误，可能如下所示：

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

现在，你的代码已经准备好了，也下载了所需的依赖，你可以用 `node .`（）运行服务器了。（`.` 表示查看前目录，然后检查你的 `package.json` 文件，以确定该目录中使用的主文件是 `index.js`）：

```
$ node .

Listening on port 3000
```

为了测试它的工作状态，你可以使用 `curl` 命令。没有终结点，所以 Express 将返回一个错误：

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

即使它报错，那也是非常好的情况。你还没有设置任何端点，因此 Express 唯一要返回的是 404 错误。如果你的服务器根本没有运行，你将得到如下错误：

```
$ curl localhost:3000 -i
curl: (7) Failed to connect to localhost port 3000: Connection refused
```

## 用 Express、Sequelize 和 Epilogue 构建你的 REST API

你现在有了一台正在运行的 Express 服务器，你可以添加一个 REST API。这实际上比你想象中的简单的多。我看过的最简单的方法是使用 [Sequelize](http://docs.sequelizejs.com/) 来定义数据库字段，[Epilogue](https://github.com/dchester/epilogue) 创建带有接近零样板的 REST API 端点。

你需要将这些依赖加入到你的项目中。Sequelize 也需要知道如何与数据库进行通信。现在，使用 SQLite 是因为它能帮助我们快速地启动和运行。

```
npm install sequelize@4.38.0 epilogue@0.7.1 sqlite3@4.0.2
```

新建一个包含以下代码的文件 `database.js`。我会在下面详细解释每一部分。

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

你现在只需要将那些文件导入主应用程序并运行初始化函数即可。在你的 `index.js` 文件中添加以下内容。

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

你现在可以测试语法错误，如果一切 看上去都正常了，就可以启动应用程序了：

```
$ npm test && node .

> rest-api@1.0.0 test /Users/bmk/code/okta/apps/rest-api
> standard

Executing (default): CREATE TABLE IF NOT EXISTS `parts` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `partNumber` VARCHAR(255), `modelNu
mber` VARCHAR(255), `name` VARCHAR(255), `description` TEXT, `createdAt` DATETIME NOT NULL, `updatedAt` DATETIME NOT NULL);
Executing (default): PRAGMA INDEX_LIST(`parts`)
Listening on port 3000
```

在另一个终端，你可以测试它是否实际上已经在工作了（我使用 [json CLI](https://github.com/trentm/json) 来格式化 JSON 响应，使用 `npm install --global json` 进行全局安装）：

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

### 这里发生了什么？

如果你之前一直是按照我们的步骤来的，那么是可以跳过这部分的，因为这部分是我之前承诺过要给出的解释。

`Sequelize` 函数创建了一个数据库。这是配置详细信息的地方，例如要使用 SQL 语句。现在，使用 SQLite 来快速启动和运行。

```
const database = new Sequelize({
  dialect: 'sqlite',
  storage: './test.sqlite',
  operatorsAliases: false
})
```

一旦创建了数据库，你就可以为每个表使用 `database.define` 来定义它的表。用一些有用的字段创建叫做 `parts` 的表来进跟踪 parts。默认情况下，Sequelize 还会在创建和更新时自动创建和更新 `id`、`createdAt` 和 `updatedAt` 字段。

```
const Part = database.define('parts', {
  partNumber: Sequelize.STRING,
  modelNumber: Sequelize.STRING,
  name: Sequelize.STRING,
  description: Sequelize.TEXT
})
```

结语为了添加端点会请求获取你的 Express `app` 访问权限。但 `app` 被定义在另一个文件中。处理这个问题的一个方法就是导出一个函数，该函数接受应用程序并对其进行一些操作。当我们在另一个文件中导入这个脚本时，你可以像运行 `initializeDatabase(app)` 一样运行它。

结语需要同时使用 `app` 和 `database` 来初始化。软化定义你需要使用的 REST 端点。`resource` 函数会包括 `GET`、`POST`、`PUT` 和 `DELETE` 动词的端点，这些动词大多数是自动化的。

想真正创建数据库，你需要运行返回一个 promise 的 `database.sync()`。在你启动服务器之前，你需要等待它执行结束。

`module.exports` 意思是 `initializeDatabase` 函数可以从另一个函数中导入。

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

## 用 OAuth 2.0 保护你的 Node + Express REST API

现在你已经启动并运行了 REST API，想象你希望一个特定的应用程序从远程位置使用这个 API。如果你把它按照原样存放在互联网上，那么任何人都可以随意添加、修改或删除部位。

为了避免这个情况，你可以使用 OAuth 2.0 客户端凭据流。这是一种不需要上下文就可以让两个服务器相互通信的方式。这两个服务器必须事先同意使用第三方授权服务器。假设有两个服务器，A 和 B，以及一个接权服务器。服务器 A 托管 REST API，服务器 B 希望访问该 API。

*   服务器 B 向授权服务器发送一个私钥来证明自己的身份，并申请一个临时令牌。
*   服务器 B 会向往常一样使用 REST API，但会将令牌与请求一起发送。
*   服务器 A 向授权服务器请求一些元数据，这些元数据可用于验证令牌。
*   服务器 A 验证服务器 B 的请求。
    *   如果它是有效的，一个成功的响应将被发送并且服务器 B 正常运行。
    *   如果令牌无效，则将发送错误消息，并且不会泄露敏感信息。

### 创建授权服务器

这就是 OKta 发挥作用的地方。OKta 可以扮演允许你保护数据的服务器的角色。你可能会问自己“为什么是 OKta？”好的，对于构建 REST 应用程序来说，它非常的酷，但是构建一个**安全**的应用程序会更酷。为了实现这个目标，你需要添加身份验证，以便用户在查看/修改组之前必须要登录才可以。在 Okta 中，我们的目标是确保[身份管理](https://developer.okta.com/product/user-management/)比你过去使用的要更容易、更安全、更可扩展。Okta 是一种云服务，它允许开发者创建、编辑和安全存储用户账户以及用户账户数据，并将它们与一个或多个应用程序连接。我们的 API 允许你：

*   [验证](https://developer.okta.com/product/authentication/) 并 [授权](https://developer.okta.com/product/authorization/) 你的用户
*   存储关于用户的数据
*   允许基于密码和[社交的登录方式](https://developer.okta.com/authentication-guide/social-login/)
*   使用[多个代理身份验证](https://developer.okta.com/use_cases/mfa/)来保护你的应用程序
*   还有更多！查看我们的[产品文档](https://developer.okta.com/documentation/)

如果你还没有账户，[可以注册一个永久免费的开发者账号](https://developer.okta.com/signup/)，让我们开始吧！

创建账户后，登录到开发者控制台，导航到 **API**，然后导航到 **Authorization Servers** 选项卡。单击 `default` 服务器的链接。

从这个 **Settings** 选项卡中，复制 `Issuer` 字段。你需要把它保存在你的 Node 应用程序可以阅读的地方。在你的项目中，创建一个名为 `.env` 的文件，如下所示：

**.env**

```
ISSUER=https://{yourOktaDomain}/oauth2/default
```

`ISSUER` 的值应该是设置页面的 `Issuer URI` 字段的值。

![高亮 issuer URL。](/assets/blog/rest-api-node/issuer-afa0da4b4f632196092a4da8f243f3bec37615602dc5b62e8e34546fd1018333.png)

**注意**：一般规则是，你不应该将 `.env` 文件存储在源代码管理中。这允许多个项目同时使用相同的源代码，而不是需要单独的分支。它确保你的安全信息不会被公开（特备是如果你将代码作为开源发布时）。

接下来，导航到 **Scopes** 菜单。单击 **Add Scope** 按钮，然后为 REST API 创建一个作用域。你需要给一个名称（例如，`parts_manager`），如果你愿意，还可以给它一个描述。

![添加范围的截图](/assets/blog/rest-api-node/adding-scope-f3ecb3b4eec06d616a130400245843c0de2dd52a54b2fdcff7449a10a2ce75ed.png)

你还应该将作用域添加到你的 `.env` 文件中，以便你的代码可以访问到它。

**.env**

```
ISSUER=https://{yourOktaDomain}/oauth2/default
SCOPE=parts_manager
```

你现在需要创建一个客户端。导航到  **Applications**，然后单击 **Add Application**。选择 **Service**，然后单击 **Next**。输入服务名（例如 `Parts Manager`）然后单击 **Done**。

这将带你到具体的客户凭据的页面。这些是服务器 B （将消耗 REST API 的服务器）为了进行身份验证所需要的凭据。在本例中，客户端和服务器代码位于同一存储库中，因此继续将这些数据添加到你的 `.env` 文件中。请确保将 `{yourClientId}` 和 `{yourClientSecret}` 替换为此页面中的值。

```
CLIENT_ID={yourClientId}
CLIENT_SECRET={yourClientSecret}
```

### 创建中间件来验证 Express 中的令牌

在 Express 中，你可以添加将在每个端点之前运行的中间件。然后可以添加元数据，设置报头，记录一些信息，甚至可以提前取消请求并发送错误消息。在本例中，你需要创建一些中间件来验证客户端发送的令牌。如果令牌是有效的，它会被送达至 REST API 并返回适当的响应。如果令牌无效，它将使用错误消息进行响应，这样只有授权的机器才能访问。

想要验证令牌，你尅使用 OKta 的中间件。你还需要一个叫做 [dotenv](https://github.com/motdotla/dotenv) 的工具来加载环境变量：

```
npm install dotenv@6.0.0 @okta/jwt-verifier@0.0.12
```

现在创建一个叫做 `auth.js` 的文件，它可以导出中间件：

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

函数首先会检查 `authorization` 报头是否在该请求中，然后抛出一个错误。如果存在，它应该类似于 `Bearer {token}`，其中 `{token}` 是一个 [JWT](https://www.jsonwebtoken.io/) 字符串。如果报头不是以 `Bearer` 开头，则会引发另一个错误。然后我们将令牌发送到 [Okta 的 JWT 验证器](https://github.com/okta/okta-oidc-js/tree/master/packages/jwt-verifier) 来验证令牌。如果令牌无效，JWT 验证器将抛出一个错误，否则，它将返回一个带有一些信息的对象。然后你可以验证要求是否包含你期望的范围。

如果一切顺利，它就会以无参的形式调用 `next()` 函数，这将告诉 Express 可以转到链中的下一个函数（另一个中间件或最终端点）。如果将字符串传递给 `next` 函数，那么 Express 将其视为将被传回客户端的错误，并且不会在链中继续。

你仍然需要导入这个函数并将其作为中间件添加到应用程序中。你还需要在索引文件的顶部加载 `dotenv`，以确保 `.env` 中的环境变量加载到你的应用程序中。对 `index.js` 作以下更改：

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

如果测试请求是否被正确阻止，请尝试再次运行。。。

```
$ npm test && node .
```

然后在另一个终端上运行一些 `curl` 命令来进行检测：

1.  授权报头是否在请求之中

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

2.  在授权请求的报头中是否有 Bearer 令牌

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

3.  Bearer 令牌是否有效

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

### 在 Node 中创建一个测试客户端

你现在已经禁止没有有效令牌的人访问应用程序，但如何获取令牌并使用它呢？我会向你演示如何在 Node 中编写一个简单的客户端，这也将帮助你测试一个有效令牌的工作。

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

这里，代码将 `.env` 中的变量加载到环境中，然后从 Node 中获取它们。节点将环境变量存储在 `process.env`（`process` 是一个具有大量有用变量和函数的全局变量）。

```
require('dotenv').config()
// ...
const { ISSUER, CLIENT_ID, CLIENT_SECRET, SCOPE } = process.env
// ...
```

接下来，由于这将从命令行运行，所以你可以再次使用 `process` 来获取与 `process.argv` 一起传入的参数。这将为你提供一个数组，其中包含传入的所有参数。前两个逗号前面没有任何变量名称，因为在本例中前两个不重要；他们只是通向 `node` 的路径，以及脚本的名称（`client` 或者 `client.js`）。

URL 是必须的，它包括端点，但是方法和 JSON 数据是可选的。默认的方法是 `GET`，因此如果你只是获取数据，就可以忽略它。在这种情况下，你也不需要任何有效负载。如果参数看起来不正确，那么这将使用错误消息和退出代码 `1` 退出程序，这表示错误。

```
const [,, uri, method, body] = process.argv
if (!uri) {
  console.log('Usage: node client {url} [{method}] [{jsonData}]')
  process.exit(1)
}
```

Node 当前不允许在主线程中使用 `await`，因此要使用更干净的 `async`/`await` 语法，你必须创建一个函数，然后调用它。

如果在任何一个 `await` 函数中发生错误，那么屏幕上就会打印出 `try`/`catch`。

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

这是客户端向授权服务器发送令牌请求的地方。对于授权服务器本身的授权，你需要使用 Basic Auth。当你得到一个内置弹出要求用户名和密码时，基本认证是浏览器使用相同的行为。假设你的用户名是 `AzureDiamond` 并且你的密码是 `hunter2`。你的浏览器就会将它们用 （`:`） 连起来，然后 base64（这就是 `btoa` 函数的功能）对它们进行编码，来获取 `QXp1cmVEaWFtb25kOmh1bnRlcjI=`。然后它发送一个授权报头 `Basic QXp1cmVEaWFtb25kOmh1bnRlcjI=`。服务器可以用 base64 对令牌进行解码，以获取用户名和密码。

基础授权本身并不安全，因为它很容易被破解，这就是为什么 `https` 对于中间人攻击很重要。在这里，客户端 ID 和客户端密钥分别是用户名和密码。这也是为什么必须保证 `CLIENT_ID` 和 `CLIENT_SECRET` 是私有的原因。

对于 OAuth 2.0，你还需要制定授权类型，在本例中为 `client_credentials`，因为你计划在两台机器之间进行对话。你还要指定作用域。还有需要其他选项需要在这里进行添加，但这是我们这个示例所需要的所有选项。

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

一旦你通过验证，你就会得到一个访问令牌，你可以将其发送到 REST API，改令牌应该类似于 `Bearer eyJra...HboUg`（实际令牌要长的多 —— 可能在 800 个字符左右）。令牌包含 REST API 需要的所有信息，可以验证令牌的失效时间以及各种其他信息，像请求作用域、发出者和用于令牌的客户端 ID。

来自 REST API 的响应就会打印在屏幕上。

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

现在就尝试一下。同样，用 `npm test && node .` 启动你的应用程序，然后尝试一些像下面的命令：

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

## 了解更多关于 Okta 的 Node 和 OAuth 2.0 客户端凭据的更多信息

希望你已经看到了在 Node 中创建 REST API 并对未经授权的用户进行安全保护是多么容易的。现在，你已经有机会创建自己的示例项目了，请查看有关 Node、OAuth 2.0 和 Okta 的其他一些优秀资源。你还可以浏览 Okta 开发者博客，以获取其他优秀文章。

*   [客户端证书流的实现](https://developer.okta.com/authentication-guide/implementing-authentication/client-creds)
*   [验证访问令牌](https://developer.okta.com/authentication-guide/tokens/validating-access-tokens)
*   [自定义授权服务器](https://developer.okta.com/authentication-guide/implementing-authentication/set-up-authz-server)
*   [教程：用 Node.js 构建一个基本的 CRUD App](/blog/2018/06/28/tutorial-build-a-basic-crud-app-with-node)
*   [使用 OAuth 2.0 客户端证书保护 Node API](/blog/2018/06/06/node-api-oauth-client-credentials)

和以前一样，你可以在下面的评论中或在 Twitter [@oktadev](https://twitter.com/OktaDev) 给我们提供反馈或者提问，我们期待收到你的来信！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
