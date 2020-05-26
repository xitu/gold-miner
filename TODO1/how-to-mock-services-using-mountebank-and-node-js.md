> * 原文地址：[How To Mock Services Using Mountebank and Node.js](https://www.digitalocean.com/community/tutorials/how-to-mock-services-using-mountebank-and-node-js)
> * 原文作者：[Dustin Ewers](https://www.digitalocean.com/community/users/dustinjewers) 
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-mock-services-using-mountebank-and-node-js.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-mock-services-using-mountebank-and-node-js.md)
> * 译者：[Pingren](https://github.com/Pingren)
> * 校对者：[Mononoke](https://github.com/imononoke)，[TiaossuP](https://github.com/TiaossuP)

# 如何使用 Mountebank 和 Node.js 来 Mock 服务

## 前言

复杂的[面向服务架构（SOA）](https://en.wikipedia.org/wiki/Service-oriented_architecture)程序中，通常需要调用多个服务来运行一个完整的工作流。尽管一切服务就绪时没有问题，但如果你的代码依赖一个正在开发的服务，你就不得不等待其它团队完成任务之后才能开始工作。此外，你可能需要使用外部供应商的服务，比如天气 API 或者记录系统。供应商通常不会提供足够的环境供你使用，控制他们系统的测试数据也不容易。面对这些未完成的和没有控制权的服务，代码测试让人感到沮丧。

解决这些问题的办法是创建一个 **服务 mock**。服务 mock 用于模拟最终产品中提供的服务，但相对真正的服务而言更加轻量、简单且易于控制。你可以设置 mock 服务的响应的默认值，或者设置返回特定的测试数据，然后就可以运行你想要测试的程序，就像所依赖的服务已经就绪了一样。如此一来，灵活的 mock 服务使你的工作流更加迅速高效。

在企业环境中，创建 mock 服务有时候也叫服务虚拟化。服务虚拟化通常与昂贵的企业级工具有关，但你并不需要昂贵的工具来 mock 服务。[Mountebank](http://www.mbtest.org/)是一个免费并开源的服务 mock 工具。你可以用它 mock HTTP 服务，包括 [REST](https://en.wikipedia.org/wiki/Representational_state_transfer) 和 [SOAP](https://en.wikipedia.org/wiki/SOAP) 服务。你还可以用它 mock [SMTP](https://en.wikipedia.org/wiki/Simple_Mail_Transfer_Protocol) 或 [TCP](https://en.wikipedia.org/wiki/Transmission_Control_Protocol) 请求。

在本教程中，你将使用 [Node.js](https://nodejs.org/en/about/) 和 Mountebank 搭建两个灵活的服务 mock 程序。它们都将监听一个特定的端口的 HTTP REST 请求。除了这个简单的 mock 行为之外，这个服务还将从 [**逗号分隔值** (CSV) 文件](https://en.wikipedia.org/wiki/Comma-separated_values)中获取 mock 数据。完成教程后，你将能 mock 各种各样的服务行为，更轻松地开发和测试程序。

### 前提

为了学习本教程，你需要：

- 在你的机器上安装 8.10.0 及以上版本的 Node.js。本教程将使用 8.10.0 版。要安装 Node.js，请查看[如何在 Ubuntu 18.04 上安装 Node.js](https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-18-04) 或 [如何在 macOS 上安装 Node.js 和创建本地开发环境](https://www.digitalocean.com/community/tutorials/how-to-install-node-js-and-create-a-local-development-environment-on-macos)。
- 发送 HTTP 请求的工具，比如 [cURL](https://curl.haxx.se/) 或 [Postman](https://www.getpostman.com/)。本教程将使用 cURL，因为大多数机器上都默认安装了它；如果你的机器上没有 cURL，请看看这个[安装文档](https://curl.haxx.se/docs/install.html)。

### 第 1 步 —— 启动 Node.js 程序

此步骤中，你将创建一个基本的 Node.js 程序，作为你在后续步骤中创建的 Mountebank 实例以及 mock 服务的基础。

请注意：你可以使用命令 `npm install -g mountebank` 全局安装 Mountebank ，将其作为独立的应用程序。然后你可以使用 `mb` 命令运行它，并用 REST 请求添加 mock。

虽然这是运行 Mountebank 的最快方法，但是自己搭建的 Mountebank 程序可以在启动时运行一系列的预定义 mock，而这些又可以被保存在源码管理中并与团队共享。本教程将会手动构建有这种优点的 Mountebank 程序。

首先，创建一个新目录保存你的程序。你可以根据需要命名，但在本教程中我们将它命名为 `app`：

```bash
mkdir app
```

使用以下命令进入新创建的目录：

```bash
cd app
```

为了启动新的 Node.js 应用程序，请运行 `npm init` 并根据提示继续：

```bash
npm init
```

根据提示输入的数据将用于填写你的 `package.json` 文件，这个文件描述了你的程序，它的依赖，以及它使用的不同脚本。在一个 Node.js 程序中，脚本定义了构建，运行，测试程序的命令。你可以使用提示中的默认值，或者手动填写你的包名，版本号等信息。

在你完成这条命令后，你将得到一个基本的 Node.js 程序，包括这个 `package.json` 文件。

现在使用以下命令安装 Mountebank npm 软件包：

```bash
npm install -save mountebank
```

这条命令将获取 Mountebank 软件包并将它安装到你的程序中。请确保使用 `-save` 标记更新你的 `package.json` 文件，使它将 Mountebank 作为依赖。

接下来，向你的 `package.json` 添加一个执行 `node src/index.js` 的启动脚本。此脚本将 `index.js` 定义为程序入口，你将在之后的步骤中创建它。

用文本编辑器打开 `package.json`。你可以使用你喜欢的文本编辑器，但是本教程中将使用 nano。

```bash
nano package.json
```

定位到 `"scripts"` 部分并添加一个启动应用的 `start` 命令：`"start": "node src/index.js"`。

你的 `package.json` 文件应该和它类似，这取决于你如何填写初始的命令提示：

```json
{
  "name": "diy-service-virtualization",
  "version": "1.0.0",
  "description": "An application to mock services.",
  "main": "index.js",
  "scripts": {
    "start": "node src/index.js"
  },
  "author": "Dustin Ewers",
  "license": "MIT",
  "dependencies": {
    "mountebank": "^2.0.0"
  }
}
```

通过创建你的程序、安装 Mountebank、添加一个启动脚本，你现在拥有了 Mountebank 程序的基础。接下来，你将添加一个配置文件，来保存程序特定的设置。

### 第 2 步 —— 创建配置文件

此步骤中，你将创建一个配置文件，它决定了 Mountebank 实例和两个 mock 服务将会监听的端口。

每次运行 Mountebank 实例或 mock 服务时，你将需要指定服务所使用的网络端口（例如，`http://localhost:5000/`）。将这些放在配置文件中，程序的其他部分将能够在它们需要时导入服务和 Mountebank 实例的端口号。你可以直接将它作为常量编写到你的程序中，但储存在文件中使得未来修改配置更简单。这样一来，你只需要更改一处的值。

首先，从 `app` 目录中创建一个 `src` 目录：

```bash
mkdir src
```

导航到刚创建的文件夹：

```bash
cd src
```

创建名为 `settings.js` 的文件并在你的文本编辑器中打开它：

```bash
nano settings.js
```

接下来，为你将要创建的主 Mountebank 实例和两个 mock 服务添加端口配置：

```js
module.exports = {
    port: 5000,
    hello_service_port: 5001,
    customer_service_port: 5002
}
```

这个配置文件有三个条目：`port: 5000` 将端口 `5000` 分配给主 Mountebank 实例，`hello_service_port: 5001` 将端口 `5001` 分配给你将创建的 Hello World 测试服务，`customer_service_port: 5002` 将端口 `5002` 分配给使用 CSV 响应的 mock 服务。如果这些端口被占用，请根据需要修改它们。其它文件可以通过 `module.exports =` 来导入这些配置。

此步骤中，你用了 `settings.js` 来定义 Mountebank 和两个 mock 服务将会监听的端口，并使其可用于你程序的其它部分。接下来，你将会使用这些配置来构建初始化脚本，启动 Mountebank。

### 第 3 步 —— 构建初始化脚本

此步骤中，你将创建一个文件来启动 Mountebank 实例。这个文件将会成为程序的入口，即当你运行程序时，这个脚本将会首先运行。当你构建新的服务 mock 时，你将向此文件添加更多内容。

在 `src` 目录中，创建名为 `index.js` 的文件并在你的文本编辑器中打开它：

```bash
nano index.js
```

为了启动一个 Mountebank 实例，并使其运行在上一步创建的 `settings.js` 文件中指定的端口上，请向此文件添加以下的代码：

```js
const mb = require('mountebank');
const settings = require('./settings');

const mbServerInstance = mb.create({
        port: settings.port,
        pidfile: '../mb.pid',
        logfile: '../mb.log',
        protofile: '../protofile.json',
        ipWhitelist: ['*']
    });
```

这段代码做了三件事。首先，它导入了你之前安装的 Mountebank npm 软件包（`const mb = require('mountebank');`）。接着，它导入了你在上一步创建的配置模块（`const settings = require('./settings');`）。最后，它使用 `mb.create()` 创建了一个 Moutebank 服务器实例。

这个服务器将会监听配置文件中指定的端口，文件中的 `pidfile`，`logfile` 和 `protofile` 参数用于 Mountebank 内部记录它的进程 ID、指定日志位置、设置加载自定义协议实现的文件。`ipWhitelist` 设置指定了允许与 Moutebank 服务器通信的 IP 地址。在这个例子中，你将允许所有 IP 地址。

保存并关闭文件。

在这个文件就绪后，输入以下命令来运行你的程序：

```bash
npm start
```

命令提示符将会消失，你将看到以下内容：

```
info: [mb:5000] mountebank v2.0.0 now taking orders - point your browser to http://localhost:5000/ for help
```

这代表着你的程序已经打开并准备好接收请求。

接下来，检查你的进度。打开一个新的终端窗口并使用 `curl` 向 Moutebank 服务器发送以下 `GET` 请求：

```bash
curl http://localhost:5000/
```

这将返回以下 JSON 响应：

```json
Output{
    "_links": {
        "imposters": {
            "href": "http://localhost:5000/imposters"
        },
        "config": {
            "href": "http://localhost:5000/config"
        },
        "logs": {
            "href": "http://localhost:5000/logs"
        }
    }
}
```

Mountebank 返回的 JSON 描述了可添加或删除对象的三个不同端点。通过使用 `curl` 向这些端点发送请求，你可以与 Mountebank 实例交互。

当你完成了，切换回你的你一个终端窗口并使用 `CTRL` + `C` 退出程序。这将退出你的 Node.js 程序以便继续添加和修改功能。

现在你有了一个成功运行 Mountebank 实例的程序。接下来，你将会创建一个使用 REST 请求添加 mock 服务的 Mountebank 客户端。

### 第 4 步 —— 构建 Mountebank 客户端

Mountebank 使用 REST API 通信。你可以向上一步中提过的不同端点发送 HTTP 请求来管理 Mountebank 实例的资源。要添加 mock 服务，[*imposter*](http://www.mbtest.org/docs/mentalModel) 代表 Mountebank 中的 mock 服务。取决于你想在 mock 中实现的行为，Imposters 可以是简单或者复杂的。

此步骤中，你将构建一个向 Mountebank 服务自动发送 `POST` 请求的 Mountebank 客户端。你可以使用 `curl` 或者 Postman 向 imposters 端点发送一个 `POST` 请求，但是你每次重启测试服务器的时候，必须发送相同的请求。如果你正在运行一个具有多个 mock 的 API 示例，编写一个客户端脚本执行这个操作将会更有效率。

首先安装 `node-fetch`：

```bash
npm install -save node-fetch
```

[`node-fetch` 库](https://www.npmjs.com/package/node-fetch) 提供了一个 JavaScript Fetch API 的实现，你可以使用它来编写更简短的 HTTP 请求。你可以使用标准的 `http` 库，但是使用 `node-fetch` 是一个更加轻量的方案。

现在，创建一个向 Mountebank 发送请求的客户端模块。你只需要向 imposters 发送 post 请求，因此这个模块将只有一个方法。

使用 `nano` 创建一个名为 `mountebank-helper.js` 的文件：

```bash
nano mountebank-helper.js
```

为了设置客户端，将以下代码放入这个文件中：

```js
const fetch = require('node-fetch');
const settings = require('./settings');

function postImposter(body) {
    const url = `http://127.0.0.1:${settings.port}/imposters`;

    return fetch(url, {
                    method:'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(body)
                });
}

module.exports = { postImposter };
```

这段代码首先导入了 `node-fetch` 库和你的配置文件。接着这个模块公开声明了一个函数 `postImposter`向 Mountebank 发送 post 请求。接着，`body:` 表示这个方法会使用一个 JavaScript 对象：`JSON.stringify(body)`。这是你将向 Mountebank 服务 `POST` 的对象。由于这个方法在本地运行，你的请求将会发送至 `127.0.0.1`（`localhost`）。fetch 方法使用了参数中的对象并向 `url` 发送 `POST` 请求。

此步骤中，你创建了一个 Mountebank 客户端，它向 Mountebank 服务器提交新的 mock 服务。在下一步中，你将使用这个客户端创建你的第一个 mock 服务。

### 第 5 步 —— 创建你的第一个 mock 服务

在之前的步骤中，你构建了一个程序，创建 Mountebank 服务器并编写了请求服务器的代码。现在是时候使用这些代码来构建一个 imposter，即 mock 服务。

在 Mountebank 中，每个 imposter 包含了 [*stubs*](http://www.mbtest.org/docs/mentalModel)。Stubs 是决定 imposter 返回内容的配置集合。Stubs 可以被细分成多个 [**断言**和**响应**](http://www.mbtest.org/docs/mentalModel) 的组合。断言是触发 imposter 响应的规则。断言可以使用许多不同类型的信息，包括了 URL，请求内容（使用 XML 或 JSON），以及 HTTP 方法。

从[模型 - 视图 - 控制器（MVC）](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller)程序的角度来看，imposter 像控制器而 stubs 像控制器中的行为。断言则是指向特定控制器的行为的路由规则。

要创建你的第一个 mock 服务，请创建一个名为 `hello-service.js` 的文件。这个文件将包含了 mock 服务的定义。

在文本编辑器中打开 `hello-service.js`：

```bash
nano hello-service.js
```

接着添加以下代码：

```js
const mbHelper = require('./mountebank-helper');
const settings = require('./settings');

function addService() {
    const response = { message: "hello world" }

    const stubs = [
        {
            predicates: [ {
                equals: {
                    method: "GET",
                    "path": "/"
                }
            }],
            responses: [
                {
                    is: {
                        statusCode: 200,
                        headers: {
                            "Content-Type": "application/json"
                        },
                        body: JSON.stringify(response)
                    }
                }
            ]
        }
    ];

    const imposter = {
        port: settings.hello_service_port,
        protocol: 'http',
        stubs: stubs
    };

    return mbHelper.postImposter(imposter);
}

module.exports = { addService };
```

这段代码定义了一个 imposter，它使用了一个含有一个断言和一个响应的 stub。接着它将这个对象发送至 Mountebank 服务器。这段代码将会添加一个在根 `url` 监听 `GET` 请求并在触发时返回 `{ message: "hello world" }`的 mock 服务。

一起来看看以上代码中的 `addService()` 函数。首先，它定义了一条响应消息 `hello world`：

```js
    const response = { message: "hello world" }
...
```

接着，它定义了一个 stub：

```js
...
        const stubs = [
        {
            predicates: [ {
                equals: {
                    method: "GET",
                    "path": "/"
                }
            }],
            responses: [
                {
                    is: {
                        statusCode: 200,
                        headers: {
                            "Content-Type": "application/json"
                        },
                        body: JSON.stringify(response)
                    }
                }
            ]
        }
    ];
...
```

这个 stub 有两个部分。断言部分查找一个根（`/`）URL 的 `GET` 请求。这意味着这个 `stub` 将在有人向 mock 服务的根 URL 发送 `GET` 请求时返回响应。stub 的第二部分是 `responses` 数组。在这个例子中，将会返回一个 HTTP 状态码为`200` 的 JSON 结果。

最后一步定义了含有这个 stub 的 imposter：

```js
...
    const imposter = {
        port: settings.hello_service_port,
        protocol: 'http',
        stubs: stubs
    };
...
```

这是你将发往 `/imposters` 端点的对象，用于创建 mock 单个端点服务的 imposter。通过将 `port` 设置为你在配置文件中决定的端口，`protocol` 设置为 HTTP，`stubs`设置为 imposter 的 stubs，以上代码定义了 imposter。

现在你有了一个 mock 服务，以下代码将它发往 Mountebank 服务器：

```js
...
    return mbHelper.postImposter(imposter);
...
```

如之前所述，Mountebank 使用 REST API 来管理它的对象。这段代码使用你之前定义的 `postImposter()` 函数向服务器发送一个 `POST` 请求来激活这个服务。

当你完成了 `hello-service.js`，保存并关闭文件。

接下来，在 `index.js` 中调用刚创建的 `addService()` 函数。在文本编辑器中打开文件：

```bash
nano index.js
```

为了确保 Mountebank 实例创建时调用这个函数，添加以下高亮行：

```js
const mb = require('mountebank');
const settings = require('./settings');
const helloService = require('./hello-service');

const mbServerInstance = mb.create({
        port: settings.port,
        pidfile: '../mb.pid',
        logfile: '../mb.log',
        protofile: '../protofile.json',
        ipWhitelist: ['*']
    });

mbServerInstance.then(function() {
    helloService.addService();
});
```

当 Mountebank 实例创建时，它返回一个 *promise*。promise 是一个稍后才能确定其值的对象。这可以用于简化异步函数调用。以上代码中，`.then(function(){...})` 函数在 Mountebank 服务器初始化时才执行，而这在 promise resolve 时发生。

保存并关闭 `index.js`。

为了测试 Mountebank 初始化时创建了这个 mock 服务，启动程序：

```bash
npm start
```

Node.js 进程将会占领终端，所以打开一个新的终端窗口并向 `http://localhost:5001/` 发送 `GET` 请求：

```bash
curl http://localhost:5001
```

你将会接收以下响应，这表明了这个服务正常运行：

```
Output{"message": "hello world"}
```

现在你已经测试了你的程序，切换回第一个终端窗口并使用 `CTRL` + `C` 退出 Node.js 程序。

此步骤中，你创建了你的第一个 mock 服务。这是一个对 `GET` 请求响应 `hello world` 测试 mock。这个 mock 主要是为了展示而创建的；实际上，即使不用它，你通过构建一个小型 Express 程序能达到同样的结果。下一步中，你将创建一个更加复杂的 mock，它利用了一些 Mountebank 的功能。

### 第 6 步 —— 构建一个数据驱动的 mock 服务

尽管你在上一步创建的服务类型足以应付一些场景，绝大多数的测试需要更复杂的响应。此步骤中，你将创建一个服务，它使用 URL 中的参数查询 CSV 文件中的一条记录。

首先，导航至主 `app` 目录：

```bash
cd ~/app
```

创建一个名为 `data` 的文件夹：

```bash
mkdir data
```

打开一个名为 `customers.csv` 的顾客数据文件：

```bash
nano data/customers.csv
```

添加以下测试数据以便你的 mock 服务检索：

```csv
id,first_name,last_name,email,favorite_color
1,Erda,Birkin,ebirkinb@google.com.hk,Aquamarine
2,Cherey,Endacott,cendacottc@freewebs.com,Fuscia
3,Shalom,Westoff,swestoffd@about.me,Red
4,Jo,Goulborne,jgoulbornee@example.com,Red
```

这是一个由 API mocking 工具 [Mockaroo](https://mockaroo.com/)生成的假客户数据，类似你将加载到服务本身的顾客表中的假数据。

保存并关闭文件。

接着，在 `src` 目录下创建一个名为 `customer-service.js` 的新模块：

```bash
nano src/customer-service.js
```

为了创建一个在 `/customers/` 端点上监听 `GET` 请求的 imposter，添加以下代码：

```js
const mbHelper = require('./mountebank-helper');
const settings = require('./settings');

function addService() {
    const stubs = [
        {
            predicates: [{
                and: [
                    { equals: { method: "GET" } },
                    { startsWith: { "path": "/customers/" } }
                ]
            }],
            responses: [
                {
                    is: {
                        statusCode: 200,
                        headers: {
                            "Content-Type": "application/json"
                        },
                        body: '{ "firstName": "${row}[first_name]", "lastName": "${row}[last_name]", "favColor": "${row}[favorite_color]" }'
                    },
                    _behaviors: {
                        lookup: [
                            {
                                "key": {
                                  "from": "path",
                                  "using": { "method": "regex", "selector": "/customers/(.*)$" },
                                  "index": 1
                                },
                                "fromDataSource": {
                                  "csv": {
                                    "path": "data/customers.csv",
                                    "keyColumn": "id"
                                  }
                                },
                                "into": "${row}"
                              }
                        ]
                    }
                }
            ]
        }
    ];

    const imposter = {
        port: settings.customer_service_port,
        protocol: 'http',
        stubs: stubs
    };

    return mbHelper.postImposter(imposter);
}

module.exports = { addService };
```

这段代码定义了一个服务 mock，它寻找 URL 格式为 `customers/<id>` 的 `GET` 请求。当收到一个请求时，它将在 URL 上查询顾客的 `id`，并从 CSV 文件里返回相应的记录。

相比上一步创建的 `hello` 服务，这段代码使用了更多的 Mountebank 功能。首先，它用了 Mountebank 的 [*behaviors*](http://www.mbtest.org/docs/mentalModel)。行为是一种为 stub 添加功能的方式。这个例子中，你正在使用 `lookup` 行为来查询 CSV 文件中的一条记录：

```js
...
  _behaviors: {
      lookup: [
          {
              "key": {
                "from": "path",
                "using": { "method": "regex", "selector": "/customers/(.*)$" },
                "index": 1
              },
              "fromDataSource": {
                "csv": {
                  "path": "data/customers.csv",
                  "keyColumn": "id"
                }
              },
              "into": "${row}"
            }
      ]
  }
...
```

`key` 属性使用了一个正则表达式来解析传入的路径。在这个例子中，你将得到 URL 中 `customers/` 之后的 `id`。

`fromDataSource` 属性指向了你储存测试数据的文件。

`into` 属性将结果注入了一个变量 `${row}`。这个变量在接下来的 `body` 部分中被引用：

```js
...
  is: {
      statusCode: 200,
      headers: {
          "Content-Type": "application/json"
      },
      body: '{ "firstName": "${row}[first_name]", "lastName": "${row}[last_name]", "favColor": "${row}[favorite_color]" }'
  },
...
```

这个 row 变量用于填充响应的 body。在这个例子中，它是一个包含客户数据的 JSON 字符串。

保存并关闭文件。

接着，打开 `index.js` 将新的服务 mock 添加进初始化函数：

```bash
nano src/index.js
```

添加以下高亮行：

```js
const mb = require('mountebank');
const settings = require('./settings');
const helloService = require('./hello-service');
const customerService = require('./customer-service');

const mbServerInstance = mb.create({
        port: settings.port,
        pidfile: '../mb.pid',
        logfile: '../mb.log',
        protofile: '../protofile.json',
        ipWhitelist: ['*']
    });

mbServerInstance.then(function() {
    helloService.addService();
    customerService.addService();
});
```

保存并关闭文件。

现在使用 `npm start` 启动 Mountebank。这将隐藏提示符，因此打开另一个终端窗口。通过发送 `GET` 请求至 `localhost:5002/customers/3` 来测试你的服务。这将查找 `id=3` 的用户信息。

```bash
curl localhost:5002/customers/3
```

你将会看到以下响应：

```json
Output{
    "firstName": "Shalom",
    "lastName": "Westoff",
    "favColor": "Red"
}
```

此步骤中，你创建了一个 mock 服务，它从 CSV 文件中读取数据并且返回一个 JSON 响应。从这里开始，您可以配合你需要测试的服务，继续构建更复杂的 mock。

## 总结

在本文中，你用 Mountebank 和 Node.js 创建了自己的服务 mock 程序。现在，你可以构建 mock 服务并与团队共享。无论是涉及供应商的服务的复杂情景，还是需要在等待其他团队完成工作时进行一个简单的 mock，你都可以通过创建 mock 服务来保持团队任务的推进。

如果你想了解更多 Mountebank 的信息，请查看他们的[文档](http://www.mbtest.org/)。如果你想将这个程序容器化，请查看[使用 Docker Compose 容器化 Node.js 开发环境](https://www.digitalocean.com/community/tutorials/containerizing-a-node-js-application-for-development-with-docker-compose)。如果你想在类生产环境中运行此程序，请查看[如何在 Ubuntu 18.04 上设置 Node.js 生产环境]((https://www.digitalocean.com/community/tutorials/how-to-set-up-a-node-js-application-for-production-on-ubuntu-18-04))。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
