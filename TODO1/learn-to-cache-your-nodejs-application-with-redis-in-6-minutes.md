> * 原文地址：[Learn to Cache your NodeJS Application with Redis in 6 Minutes!](https://itnext.io/learn-to-cache-your-nodejs-application-with-redis-in-6-minutes-745a574a9739)
> * 原文作者：[Abdullah Amin](https://medium.com/@abdamin)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/learn-to-cache-your-nodejs-application-with-redis-in-6-minutes.md](https://github.com/xitu/gold-miner/blob/master/TODO1/learn-to-cache-your-nodejs-application-with-redis-in-6-minutes.md)
> * 译者：[Jessica](https://github.com/cyz980908)
> * 校对者：[lsvih](https://github.com/lsvih)，[GPH](https://github.com/PingHGao)

# 用 6 分钟学习如何用 Redis 缓存您的 NodeJS 应用！

![](https://cdn-images-1.medium.com/max/4800/1*4DX0Dj0zI2q4MnqeO_Bfbg.png)

缓存您的 web 应用非常重要，并且在应用扩展时缓存可以提高系统性能。Redis 可以是一个 **搜索引擎**，可以用最小的延迟来响应频繁查询的请求；可以是一个**短链接生成器**，可以更快地重定向到经常访问的 URL；可以是一个**社交网络**，可以更快地得到红人的用户资料。还可以是一个非常简单的从第三方 web API 请求数据的 web 服务器，它在项目扩展和缓存数据的情况下，表现是相当出色的！

## 什么是 Redis？为什么要用 Redis？

**Redis** 是一个高性能的开源 **NoSQL** 数据库，主要是被用作各种类型的应用的缓存解决方案。它将所有数据存储在 RAM 中，并提供高度优化的数据读写。Redis 还支持许多不同的数据类型和基于很多不同编程语言的客户端。您可以在[这里](https://redis.io/topics/introduction)找到更多关于 **Redis** 的信息。

## 概述

今天，我们将在 **NodeJS** web 应用上实现基本的缓存机制，我们的 web 应用将会从 **[Star Wars API](https://swapi.co)** 请求**星球大战的星际飞船信息**。我们将学习如何将频繁请求的星际飞船数据存储到我们的缓存中。之后我们 web 服务器的请求将首先搜索缓存，如果缓存不包含我们请求的数据，再向 [**Star Wars API**](https://swapi.co) 发送请求。这将使我们向第三方 API 发送更少的请求，从而总体上加快了我们应用的速度。为确保我们的缓存是最新的，缓存的数据将被设置生存时间（TTL），数据在一定时间后过期。听起来是不是很有意思？让我们开始吧！

## 安装 Redis

如果您已经在本地机器上安装了 Redis，或者正在使用 Redis 云托管解决方案，就可以跳过这一步。

#### 在 Mac 上安装

在 Mac 上 可以使用 **Homebrew** 来安装 Redis。如果您的 Mac 上没有安装 Homebrew，您可以在终端上运行以下命令来安装它。

```bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

现在，您可以通过在终端上运行以下命令来安装 Redis。

```bash
brew install redis
```

#### 在 Ubuntu 上安装

您可以使用这个[简易指南](https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-redis-on-ubuntu-18-04)在您的 Ubuntu 机器上安装 Redis。

#### 在 Windows 上安装

您可以使用这个[简易指南](https://redislabs.com/blog/redis-on-windows-8-1-and-previous-versions/)在您的 Windows 机器上安装 Redis。

## 启动 Redis 服务端 和 Redis CLI 客户端

在您的终端上，您可以运行以下命令在本地启动您的 Redis 服务端。

```bash
redis-server
```

![启动 Redis 服务端](https://cdn-images-1.medium.com/max/4866/1*X8YnTE55NZbp-V7ER4iKLw.png)

要使用 Redis CLI 客户端，您可以新建一个终端窗口或者终端选项卡后，运行以下命令。

```bash
redis-cli
```

![Redis CLI](https://cdn-images-1.medium.com/max/2874/1*lPYgPudVRWd1HoJA5khQsQ.png)

就像在您的机器上安装的任何其他数据库解决方案一样，您可以使用 Redis 的 CLI 与它进行交互。关于 [Redis CLI](https://redis.io/topics/rediscli) 我推荐看它的官方指南。但是，在这里我们只关注于将 Redis 用于我们的 NodeJS web 应用的缓存解决方案，并只通过我们的 web 服务器与它进行交互。

## NodeJS 项目安装

在一个单独的文件夹中，运行 **npm init**  来构建您的 NodeJS 项目。

![使用 **npm init** 来构建 NodeJS 应用](https://cdn-images-1.medium.com/max/3728/1*sVU5v2M6FEOMd9LtLaMoOQ.png)

#### 项目依赖

我们将在 NodeJS 应用中使用一系列的依赖项。在您的项目目录下的终端中运行以下命令。

```bash
npm i express redis axios
```

**Express** 将帮助我们设置服务器。我们将使用 **redis** 包来将我们的应用与在我们机器上本地运行的 Redis 服务端相连，我们还将使用 **axios** 向 [**Star Wars API**](https://swapi.co) 请求数据。

#### 开发依赖

我们还将使用 **nodemon** 作为我们的 **开发依赖** 从而能够在项目代码更改保存后立即运行到我们的服务器而不必重新启动它（译者注：也就是热更新）。在我们的项目目录的终端中运行以下命令。

```bash
npm i -D nodemon
```

#### 在 package.json 中设置启动脚本

用以下脚本替换 **package.json** 中的现有脚本，以便我们可以使用 **nodemon** 运行服务器。

```
"start": "nodemon index"
```

```JSON
{
  "name": "redis-node-tutorial",
  "version": "1.0.0",
  "description": "A step by step guide to setup caching with Redis on a NodeJS Web Application",
  "main": "index.js",
  "scripts": {
    "start": "nodemon index"
  },
  "repository": {
    "type": "git",
    "url": "git+https://github.com/abdamin/redis-node-tutorial.git"
  },
  "author": "Abdullah Amin",
  "license": "ISC",
  "bugs": {
    "url": "https://github.com/abdamin/redis-node-tutorial/issues"
  },
  "homepage": "https://github.com/abdamin/redis-node-tutorial#readme",
  "dependencies": {
    "axios": "^0.19.0",
    "express": "^4.17.1",
    "redis": "^2.8.0"
  },
  "devDependencies": {
    "nodemon": "^1.19.4"
  }
}

```

#### 设置我们的初始服务器的入口文件：index.js

在我们的项目目录的终端中运行以下命令来创建 **index.js** 文件。

```bash
touch index.js
```

下面是 **index.js** 文件添加了一些代码后的样子。

```JavaScript
//设置依赖
const express = require("express");
const redis = require("redis");
const axios = require("axios");
const bodyParser = require("body-parser");

//设置端口常量
const port_redis = process.env.PORT || 6379;
const port = process.env.PORT || 5000;

//配置 Redis 客户端使用 6379 端口
const redis_client = redis.createClient(port_redis);

//配置 express 服务器
const app = express();

//Body 解析中间件
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

//监听 5000 端口
app.listen(port, () => console.log(`Server running on Port ${port}`));
```

如果您以前使用过 **NodeJS** 和 **ExpressJS**，那么这应该难不倒您。首先，我们设置之前使用 npm 安装的依赖项。接着，我们设置端口常量并创建我们的 Redis 客户端。最后，我们在**6379 端口** 上配置我们的 Redis 客户端，在 **5000 端口**上配置我们的 Express 服务器。我们还在服务器上设置了 **Body-Parser**，来解析 JSON 数据。您可以在终端中运行以下命令来使用 **package.json** 中的启动脚本运行 web 服务器。

```bash
npm start
```

**注意**，如前所述，我们的 Redis 服务端应该运行在另一个终端上，以便成功地将我们的NodeJS 应用连接到 Redis。

您现在应该能够在终端上看到以下输出，它表明您的 web 服务器正在 **5000 端口** 上运行。

![](https://cdn-images-1.medium.com/max/2876/1*1W6F-j0EtdYKDrgJj4hjHg.png)

## 发送请求到 Star Wars API

现在我们已经完成了我们的项目设置，让我们编写一些代码来发送一个 **GET** 请求到  **Star Wars API** 来获得星际飞船的数据。

注意，我们将向 **[https://swapi.co/api/starships/](https://swapi.co/api/starships/${id}):id** 发送一个 GET 请求来获取与 URL 中的标识符 **id** 相对应的星际飞船的数据。

下面是后端代码的样子。

```js
// 请求路由： GET /starships/:id

// @desc 返回特定 id 星际飞船的飞船数据
app.get("/starships/:id", async (req, res) => {
  try {
       const { id } = req.params;
       const starShipInfo = await axios.get(
       `https://swapi.co/api/starships/${id}`
       );
       //从响应中获取数据
       const starShipInfoData = starShipInfo.data;
       return res.json(starShipInfoData);
  } 
  catch (error) {
       console.log(error);
       return res.status(500).json(error);
   }
});
```

我们将使用一个带有 try 和 catch 块的传统**异步**回调函数和 **axios** 向 **Star Wars API** 发出 GET 请求。如果成功，我们的请求路由将返回与 URL 中 id 对应的星际飞船数据。否则，我们的请求将返回一个错误。这很简单吧。

```JavaScript
//设置依赖
const express = require("express");
const redis = require("redis");
const axios = require("axios");
const bodyParser = require("body-parser");

//设置端口常量
const port_redis = process.env.PORT || 6379;
const port = process.env.PORT || 5000;

//配置 Redis 客户端使用 6379 端口
const redis_client = redis.createClient(port_redis);

//配置 express 服务器
const app = express();

//Body 解析中间件
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

//  请求路由： GET /starships/:id
//  @desc 返回特定 id 星际飞船的飞船数据
app.get("/starships/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const starShipInfo = await axios.get(
      `https://swapi.co/api/starships/${id}`
    );

    //从响应中获取数据
    const starShipInfoData = starShipInfo.data;

    return res.json(starShipInfoData);
  } catch (error) {
    console.log(error);
    return res.status(500).json(error);
  }
});

app.listen(port, () => console.log(`Server running on Port ${port}`));
```

让我们尝试通过运行我们的代码来搜索 **id=9** 的星际飞船。

![http://localhost:5000/starships/9](https://cdn-images-1.medium.com/max/5684/1*8omThnreKe-2gQHS29U9Rw.png)

哇！请求成功了。但是您注意到完成请求所花费的时间了吗? 您可以在浏览器的 Chrome 开发工具下检查网络选项卡来查看花费的时间。

**769 ms。** 太慢了！这就是 **Redis** 的用武之地了。

## 为服务实现 Redis 缓存 

#### 添加到缓存

由于Redis 将数据以键值对的形式进行储存，我们需要确保无论何时向 Star Wars API 发出请求并成功接收到响应，我们就马上将星际飞船的 id 与其数据一起存储在缓存中。

为此，我们将添加以下代码到接收到的来自 Star Wars API 的响应的那段代码后。

```js
//向 Redis 增加数据

redis_client.setex(id, 3600, JSON.stringify(starShipInfoData));
```

上面代码的意思是我们将 **key=id**、**expiration=3600s**、**value=JSON 字符串格式化后的星际飞船数据**添加到缓存中。现在我们的 **index.js** 是这个样子。

```JavaScript
//设置依赖
const express = require("express");
const redis = require("redis");
const axios = require("axios");
const bodyParser = require("body-parser");

//设置端口常量
const port_redis = process.env.PORT || 6379;
const port = process.env.PORT || 5000;

//配置 Redis 客户端使用 6379 端口
const redis_client = redis.createClient(port_redis);

//配置 express 服务器
const app = express();

//Body 解析中间件
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

//  请求路由： GET /starships/:id
//  @desc 返回特定 id 星际飞船的飞船数据
app.get("/starships/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const starShipInfo = await axios.get(
      `https://swapi.co/api/starships/${id}`
    );

    //从响应中获取数据
    const starShipInfoData = starShipInfo.data;

    //向 Redis 增加数据
    redis_client.setex(id, 3600, JSON.stringify(starShipInfoData));

    return res.json(starShipInfoData);
  } catch (error) {
    console.log(error);
    return res.status(500).json(error);
  }
});

app.listen(port, () => console.log(`Server running on Port ${port}`));
```

现在如果我们打开浏览器，对星际飞船发送 GET 请求，它的数据就会被添加到我们的 Redis 缓存中。

![向 id 为 9 的星际飞船发送 GET 请求](https://cdn-images-1.medium.com/max/5760/1*0uTJdzOcDvPlEX7r3QumHw.png)

如前所述，您可以使用以下命令从终端访问 Redis CLI 客户端。

```bash
redis-cli
```

![](https://cdn-images-1.medium.com/max/2884/1*fhmGALJ_lJ6WksnQ9fo1_A.png)

运行命令 **get 9** 表明，**id=9**的星际飞船数据确实添加到了我们的缓存中！

#### 从缓存中检查并检索数据

现在，只有在缓存中不存在所需的数据时，我们才需要向 **Star Wars API** 发送 GET 请求。我们将使用 **Express 中间件**来实现这个函数，它在执行向 **Star Wars API** 的请求之前会检查缓存。它将作为**第二个参数**传递到我们之前写好的请求函数中。

中间件函数如下所示。

```js
//用于检查缓存的中间件函数
checkCache = (req, res, next) => {
       const { id } = req.params;
       //得到 key = id 的数据
       redis_client.get(id, (err, data) => {
           if (err) {
               console.log(err);
               res.status(500).send(err);
           }
           //如果没有找到对应的数据
           if (data != null) {
               res.send(data);
           } 
           else {
               //继续下一个中间件函数
               next();
           }
        });
};
```

添加 checkCache 中间件函数后的 index.js：

```JavaScript
//设置依赖
const express = require("express");
const redis = require("redis");
const axios = require("axios");
const bodyParser = require("body-parser");

//设置端口常量
const port_redis = process.env.PORT || 6379;
const port = process.env.PORT || 5000;

//配置 Redis 客户端使用 6379 端口
const redis_client = redis.createClient(port_redis);

//配置 express 服务器
const app = express();

//Body 解析中间件
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

//用于检查缓存的中间件函数
checkCache = (req, res, next) => {
  const { id } = req.params;

  redis_client.get(id, (err, data) => {
    if (err) {
      console.log(err);
      res.status(500).send(err);
    }
    //如果没有找到对应的数据
    if (data != null) {
      res.send(data);
    } else {
      //继续下一个中间件函数
      next();
    }
  });
};

//  请求路由： GET /starships/:id
//  @desc 返回特定 id 星际飞船的飞船数据
app.get("/starships/:id", checkCache, async (req, res) => {
  try {
    const { id } = req.params;
    const starShipInfo = await axios.get(
      `https://swapi.co/api/starships/${id}`
    );

    //从响应中获取数据
    const starShipInfoData = starShipInfo.data;

    //向 Redis 增加数据
    redis_client.setex(id, 3600, JSON.stringify(starShipInfoData));

    return res.json(starShipInfoData);
  } catch (error) {
    console.log(error);
    return res.status(500).json(error);
  }
});

app.listen(port, () => console.log(`Server running on Port ${port}`));
```

让我们再次发送一个 GET 请求向我们 **id=9** 的星际飞船。

![](https://cdn-images-1.medium.com/max/5760/1*Jmu98b42pna6v4t626M7gg.png)

**115 ms。**性能几乎提升了 **7 倍**！

## 总结

值得注意的是，我们在本教程中只是讲了些皮毛而已，Redis 还有很多更多的功能！我强烈建议您查看它的[官方文档](https://redis.io/documentation)。[**这个链接**](https://github.com/abdamin/redis-node-tutorial)是我们应用的完整代码的 Github 仓库地址。

如果您有任何问题，请尽管留言。另外，如果这篇文章对您有帮助，您请可以帮忙转发分享。我会定期发布与 web 开发相关的文章。您可以在[**此处输入您的电子邮件**](https://abdullahsumsum.com/subscribe)以获取有关 web 开发相关的文章和教程的最新信息。您还可以在 [**abdullahsumsum.com**](http://abdullahsumsum.com/) 上找到有关我的更多信息。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
