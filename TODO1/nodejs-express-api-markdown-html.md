> * 原文地址：[Building A Node.js Express API To Convert Markdown To HTML](https://www.smashingmagazine.com/2019/04/nodejs-express-api-markdown-html/)
> * 原文作者：[Sameer Borate](https://www.smashingmagazine.com/author/sameer-borate)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/nodejs-express-api-markdown-html.md](https://github.com/xitu/gold-miner/blob/master/TODO1/nodejs-express-api-markdown-html.md)
> * 译者：[Baddyo](https://github.com/Baddyo)
> * 校对者：[fireairforce](https://github.com/fireairforce), [JackEggie](https://github.com/JackEggie)

# 化 Markdown 为 HTML：用 Node.js 和 Express 搭建接口

> 快速摘要：搭建一个把 Markdown 语法转换为 HTML 的应用，通过该实践来学习如何使用 Node.js 和 Express 框架创建接口端点。

Markdown 是一种轻量级的文本标记语言，能将带标记的文本转换为各种格式。发明 Markdown 的初衷，是为了让人们能“用易读易写的纯文本格式来书写”，并可以按需转换为有效的 XHTML（或者 HTML）。目前，随着 WordPress 的支持，Markdown 语法越来越流行了。

本文旨在向读者展示如何用 Node.js 和 Express 框架创建接口端点。我们会搭建一个将 Markdown 转换为 HTML 的应用，在搭建过程中学习 Node.js 和 Express。我们还会给接口添加验证机制，以防我们的应用被滥用。

### 一个基于 Node.js 的 Markdown 应用

我们把这个小巧玲珑的应用叫做 “Markdown 转换器”，我们把 Markdown 语法的文本上传给它，然后得到 HTML 格式的版本。该应用使用 Node.js 的框架 Express 实现，并支持对转换请求的验证。

我们会化整为零地实现这个应用 —— 先用 Express 创建一个基本框架，然后再添加验证机制等功能。那就让我们开始搭建基本框架吧！

### 第一阶段：初始化 Express

假设你已经在操作系统里安装了 Node.js，现在我们创建一个文件夹（就叫它 “`markdown-api`” 吧）来存放代码，并进入该文件夹：

```bash
$ mkdir markdown-api
$ cd markdown-api
```

使用 npm init 命令创建一个 **package.json** 文件。该命令会提示你输入诸如应用名称、版本之类的信息。

就本次实践来说，你只需按下 Enter 键使用那些默认信息就好。我把 **index.js** 做为默认入口文件，但你也可以按自己喜好设置成 **app.js** 或别的文件。

现在我们在 `markdown-api` 目录下安装 Express，并将其列入依赖包列表：

```bash
$ npm install express --save
```

在当前目录（`markdown-api`）创建一个 **index.js** 文件，把下列代码添加进去来测试 Express 框架是否安装成功：

```javascript
const express = require('express');
var app = express();
 
app.get('/', function(req, res){
    res.send('Hello World!');
});
 
app.listen(3000);
```

访问 `http://localhost:3000` ，看看测试文件是否成功运行起来了。如果一切顺利，我们能在浏览器中看到 “Hello World!” 字样，那接下来就可以构建 Markdown 转 HTML 的基本接口了。

### 第二阶段：构建基本接口

该接口的主要作用是把 Markdown 转为 HTML，它将有两个端点：

* `/login`
* `/convert`

`login` 端点用来验证有效请求；`convert` 端点用来进行 Markdown 到 HTML 的转换。

以下是调用两个端点的基本接口代码。调用 `login` 会返回一个 “Authenticated” 字符串，而调用 `convert` 会返回你上传的 Markdown 文本。主方法仅返回一个 “Hello World!” 字符串。

```javascript
const express = require("express");
const bodyParser = require('body-parser');
    
var app = express();
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
 
app.get('/', function(req, res){
    res.send('Hello World!');
});
 
app.post('/login', function(req, res) {
    res.send("Authenticated");
  },
);
 
app.post("/convert", function(req, res, next) {
    console.log(req.body);
    if(typeof req.body.content == 'undefined' || req.body.content == null) {
        res.json(["error", "No data found"]);
    } else {
        res.json(["markdown", req.body.content]);
    }
});
 
app.listen(3000, function() {
 console.log("Server running on port 3000");
});
```

我们使用中间件 `body-parser` 来辅助解析收到的请求。该中间件将解析结果放在 `req.body` 属性中供你使用。虽说不借助中间件也能解析请求，但那样就太麻烦了。

用 npm 就可以安装 `body-parser`：

```javascript
$ npm install body-parser
```

现在万事俱备，我们得用 Postman 测试一下。先简单介绍一下 Postman 吧。

#### Postman 简介

Postman 是一种接口开发工具，使用其网页版或者桌面客户端（网页版下架了）可以极为方便地搭建、修改以及测试接口端点。它可以生成各种类型的 HTTP 请求，例如 GET、POST、PUT 和 PATCH。Postman 支持 Windows、macOS 和 Linux。

来一睹 Postman 的风采吧：

[![Postman 的界面](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/462c5b77-18e5-498d-a06e-f59276859c4f/nodejs-express-api-markdown-html-postman-intro.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/462c5b77-18e5-498d-a06e-f59276859c4f/nodejs-express-api-markdown-html-postman-intro.png)

（[高清大图](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/462c5b77-18e5-498d-a06e-f59276859c4f/nodejs-express-api-markdown-html-postman-intro.png)）

要想调用一个接口端点，你需要遵循以下步骤：

1. 在顶部的地址栏输入目标 URL；
2. 在地址栏左侧选择 HTTP 方法；
3. 点击“发送”按钮。

Postman 会把请求发送给应用，取得响应信息并显示在界面下方的窗口中。这就是 Postman 的基本用法。在我们的应用中，我们还要给请求添加其他参数，这一块内容后面会说到。

### 使用 Postman

大概熟悉了 Postman 之后，我们就要实际使用它了。

用命令行启动 `markdown-api` 应用：

```bash
$ node index.js
```

为了测试基本接口代码，我们要用 Postman 调用接口。注意，我们用 POST 方法把要转换的文本传给应用。

我们的应用通过 POST 方法的 `content` 参数接收待转换的文本。我们把它作为 URL 编码格式传递。字符串以 JSON 的格式返回 —— 第一个字段总会返回字符串 `markdown`，而第二个字段返回转换后的文本。然后，当我们添加了 Markdown 处理代码，它就会返回转换后的文本。

### 第三阶段：添加 Markdown 转换代码

应用的基本框架搭建好了，我们就来看看 `showdown` 这个 JavaScript 库，我们要用此库把 Markdown 转换为 HTML。`showdown` 是用 JavaScript语言实现的，支持 Markdown 和 HTML 之间的双向转换。

[![用 Postman 测试](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/7634b6ea-e153-48cc-8001-67c21e08e3ac/nodejs-express-api-markdown-html-base-postman-test.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/7634b6ea-e153-48cc-8001-67c21e08e3ac/nodejs-express-api-markdown-html-base-postman-test.png)

([高清大图](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/7634b6ea-e153-48cc-8001-67c21e08e3ac/nodejs-express-api-markdown-html-base-postman-test.png))

用 npm 安装 `showdown`：

```bash
$ npm install showdown
```

添加所需的 showdown 代码后，我们的代码应该是这样的：

```javascript
const express        = require("express");
const bodyParser = require('body-parser');
const showdown   = require('showdown');
    
var app = express();
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
 
converter = new showdown.Converter();

app.get('/', function(req, res){
    res.send('Hello World!');
});
 
app.post('/login', function(req, res) {
    res.send("Authenticated");
  },
);
 
app.post("/convert", function(req, res, next) {
    if(typeof req.body.content == 'undefined' || req.body.content == null) {
        res.json(["error", "No data found"]);
    } else {
        text = req.body.content;
        html = converter.makeHtml(text);
        res.json(["markdown", html]);
    }
});
 
app.listen(3000, function() {
 console.log("Server running on port 3000");
});
```

转换格式的核心代码在 `/convert` 端点中，如下所示。这段代码会把你上传的 Markdown 文本转换为 HTML 版本，并返回 JSON 格式的结果。

```javascript
...
} else {
        text = req.body.content;
        html = converter.makeHtml(text);
        res.json(["markdown", html]);
    }
```

`converter.makeHtml(text)` 就是负责转换的方法。用 `setOption` 方法可以对转换过程进行各种配置：

```javascript
converter.setOption('optionKey', 'value');
```

例如，可以配置成自动插入特定的 URL 而不用任何标记。

```javascript
converter.setOption('simplifiedAutoLink', 'true');
```

在 Postman 的例子中，如果我们把 `simplifiedAutoLink` 的值配置为 `true`，传一个简单的字符串（例如 `Google home http://www.google.com/`）时就会返回如下结果：

```html
<p>Google home <a href="http://www.google.com/">http://www.google.com/</a></p>
```

否则，要实现相同效果，我们必须要添加标记信息才行：

```markup
Google home <http://www.google.com/>
```

还有很多配置项可以控制 Markdown 的转换过程。你可以在[这里](https://www.npmjs.com/package/showdown)找到完整的配置项列表。

现在，我们实现了一个能将 Markdown 转为 HTML 的“转换器”端点。让我们继续深入来添加验证功能吧。

### 第四阶段：用 Passport 实现接口验证功能

不给接口添加恰当的验证机制就把它扔出去给别人使用，就是在鼓励使用者无限制地使用你的接口。这会招致某些无耻之徒滥用接口，蜂拥而至的请求会拖垮你的服务器。为了避免这样的局面，我们必须给接口添加恰当的验证机制。

我们将用 Passport 包来实现验证机制。正如之前用到的 `body-parser` 中间件一样，Passport 是一个基于 Node.js 的验证中间件。使用它的原因在于，它支持各种验证机制（用户名和密码验证、Facebook 账号验证、Twitter 账号验证等等），这样我们可以灵活选择验证方式。添加 Passport 中间件很简单，无需更改过多代码。

用 npm 安装 Passport：

```bash
$ npm install passport
```

我们还要使用 `local` 策略来进行验证，稍后我会详细说明。因此要把 `passport-local` 也安装上。

```bash
$ npm install passport-local
```

你还需要编码/解码模块 JWT（JSON Web Token）：

```bash
$ npm install jwt-simple
```

#### Passport 中的策略

Passport 中间件使用策略的概念来验证请求。这里所谓的策略就是一系列方法，它们帮你验证各种请求，从简单的用户名密码验证，到开放授权验证（Facebook 或 Twitter 账号验证），再到 OpenID 验证，皆可胜任。一个应用所使用的验证策略需要预先配置才能去验证请求。

在我们自己的应用中，我们会用个简单的用户名密码验证方案，这样便于理解和编码。目前，Passport 支持超过 300 种验证策略。

虽然 Passport 的设计很复杂，但实际使用却很简单。下面的例子就展示了 `/convert` 端点如何添加验证机制。如你所见，轻而易举。

```javascript
app.post("/convert", 
         passport.authenticate('local',{ session: false, failWithError: true }), 
         function(req, res, next) {
        // 若此函数被调用，说明验证成功。
        // 请求内容为空与否。
        if(typeof req.body.content == 'undefined' || req.body.content == null) {
            res.json(["error", "No data found"]);
        } else {
            text = req.body.content;
            html = converter.makeHtml(text);
            res.json(["markdown", html]);
        }}, 
        // 验证失败，返回 “Unauthorized” 字样
        function(err, req, res, next) {
            return res.status(401).send({ success: false, message: err })
        });
```

现在，除了要转换的 Markdown 字符串，我们还要发送用户名和密码，与应用的用户名密码比对验证。因为我们使用的是本地验证策略，验证凭证就会存储在代码本身中。

可能这样的验证手段看起来太简陋了，但对于一个 demo 级别的应用来说已经足够。简单的例子也有助于我们理解验证过程。顺便说一句，有种常见的安全措施是把凭证存到环境变量中。当然，很多人对这种方式不以为然，但我觉得这是个相对安全的方法。

验证功能的完整示例如下：

```javascript
const express = require("express");
const showdown  = require('showdown');
const bodyParser = require('body-parser');
const passport = require('passport');
const jwt = require('jwt-simple');
const LocalStrategy = require('passport-local').Strategy;
 
    
var app = express();
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
 
converter = new showdown.Converter();
 
const ADMIN = 'admin';
const ADMIN_PASSWORD = 'smagazine';
const SECRET = 'secret#4456';
 
passport.use(new LocalStrategy(function(username, password, done) {
  if (username === ADMIN && password === ADMIN_PASSWORD) {
    done(null, jwt.encode({ username }, SECRET));
    return;
  }
  done(null, false);
}));
 
app.get('/', function(req, res){
    res.send('Hello World!');
});
 
 
app.post('/login', passport.authenticate('local',{ session: false }),
                function(req, res) {
                // 若此函数被调用，说明验证成功。
                // 返回 “Authenticated” 字样。
                res.send("Authenticated");
  });
  
 
app.post("/convert", 
         passport.authenticate('local',{ session: false, failWithError: true }), 
         function(req, res, next) {
        // 若此函数被调用，说明验证成功。
        // 请求内容为空与否。
        if(typeof req.body.content == 'undefined' || req.body.content == null) {
            res.json(["error", "No data found"]);
        } else {
            text = req.body.content;
            html = converter.makeHtml(text);
            res.json(["markdown", html]);
        }}, 
        // 验证失败，返回 “Unauthorized” 字样
        function(err, req, res, next) {
            return res.status(401).send({ success: false, message: err })
        });
 
 
app.listen(3000, function() {
 console.log("Server running on port 3000");
});
```

一个带验证的 Postman 会话如下所示：

[![用 Postman 测试最终应用](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/ae32fa60-d46d-4065-8966-b5e9ce0b32b9/nodejs-express-api-markdown-html-base-postman-auth.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/ae32fa60-d46d-4065-8966-b5e9ce0b32b9/nodejs-express-api-markdown-html-base-postman-auth.png)

用 Postman 测试最终应用（[高清大图](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/ae32fa60-d46d-4065-8966-b5e9ce0b32b9/nodejs-express-api-markdown-html-base-postman-auth.png)）

在此可见，我们上传了一段 Markdown 语法的文本，然后得到了经过正确转换的 HTML 版本的结果。我们只是测试了一行文本，但这个接口是有转换大段文本的能力的。

这就是我们此次对 Node.js 和 Express 的浅尝 —— 搭建一个接口端点。构建接口是一个复杂的课题，在你想构建一个接口的时候，有些细节你应该清楚，但时间有限，很抱歉不能在本文中展开了，但可能会在后续文章中详细探讨。

### 在其他应用中访问我们的接口

既然已经搭建好了接口，那我们就可以写一个基于 Node.js 的小脚本来证明接口可用。在本例中，我们需要安装 `request` 包以便于发送 HTTP 请求。（很可能你已经安装过了）

```bash
$ npm install request --save
```

下面所示代码向我们的接口发送了一个请求，并得到了响应。如你所见，`request` 包大大简化了步骤。待转换的 Markdown 文本存放于 `textToConvert` 变量中。

在运行下列脚本之前，你要确保接口应用已经处于运行状态。你需要在另外的命令窗口中运行脚本。

**注意：在变量 `textToConvert` 中，我们使用了 “ ` ” 符号来包裹多行 JavaScript 代码，它不是单引号哦。**

```javascript
var Request = require("request");
 
// Markdown 文本的开头
var textToConvert = `Heading
=======
## Sub-heading
 
Paragraphs are separated
by a blank line.
 
Two spaces at the end of a line  
produces a line break.
 
Text attributes _italic_, 
**bold**, 'monospace'.
A [link](http://example.com).
Horizontal rule:`;
 
// Markdown 文本的结尾
                    
Request.post({
    "headers": { "content-type": "application/json" },
    "url": "http://localhost:3000/convert",
    "body": JSON.stringify({
        "content": textToConvert,
        "username": "admin",
        "password": "smagazine"
    })
}, function(error, response, body){
    // 连接失败时，退出。
    if(error) {
        return console.log(error);
    }
    // 显示转换后的文本
    console.dir(JSON.parse(body));
});
```

当发送 POST 请求到接口时，我们需要提供要转换的 Markdown 文本和身份凭证。如果凭证错误，我们会收到错误提示信息。

```javascript
{
  success: false,
  message: {
    name: 'AuthenticationError',
    message: 'Unauthorized',
    status: 401
  }
}
```

对于一个验证通过的请求，上述 Markdown 样例会被转换为如下格式：

```html
[ 'markdown',
  `<h1 id="heading">Heading</h1>
  <h2 id="subheading">Sub-heading</h2>
  <p>Paragraphs are separated by a blank line.</p>
  <p>Two spaces at the end of a line<br />
  produces a line break.</p>
  <p>Text attributes <em>italic</em>, 
  <strong>bold</strong>, 'monospace'.
  A <a href="http://example.com">link</a>.
  Horizontal rule:</p>` ]
```

在例子中我们刻意写了一段 Markdown 文本，实际情况中的文本可能来自文件、web 表单等多种来源。但请求过程都是一样的。

注意：当我们使用 `application/json` 格式发送请求时，我们需要用 JSON 格式解析响应体，故而要调用 `JSON.stringify` 函数。如你所见，测试或者接口应用仅需一个小例子，在此不赘述。

### 总结

在本文中，我们以学习使用 Node.js 和 Express 框架搭建接口为目的组织了一次教程。与其漫无目的地做一些没意思的应用，不如搭建一个把 Markdown 转换为 HTML 的接口，这才算是有用的实践。通过整个过程的实践，我们学会了给接口端点添加验证机制，还学会了用 Postman 测试应用的几种方式。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
