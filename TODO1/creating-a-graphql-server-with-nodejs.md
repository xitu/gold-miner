> * 原文地址：[Creating a GraphQL server with NodeJS](https://medium.com/crowdbotics/creating-a-graphql-server-with-nodejs-ef9814a7e0e6)
> * 原文作者：[Aman Mittal](https://medium.com/@amanhimself?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/creating-a-graphql-server-with-nodejs.md](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-a-graphql-server-with-nodejs.md)
> * 译者：[Raoul1996](https://github.com/Raoul1996)
> * 校对者：

# 使用 NodeJS 创建一个 GraphQL 服务器

## Hello World！在这个 GraphQL 的教程中，你可以学到如何使用 Apollo Server 库 2.0 版本来构建一个基于 NodeJS 和 Experss 的 GraphQL 服务器。

![](https://cdn-images-1.medium.com/max/2000/1*mbwU_n49CU8SEJyLPaTAUw.png)

当谈到客户端和应用程序服务器之间的网络请求时，REST（*[表现层状态转换](https://zh.wikipedia.org/wiki/%E8%A1%A8%E7%8E%B0%E5%B1%82%E7%8A%B6%E6%80%81%E8%BD%AC%E6%8D%A2)*的代表）是连接二者最常用的选择之一。在 [REST API](https://medium.com/crowdbotics/building-a-rest-api-with-koajs-417c276929e2) 的世界中，一切都围绕着如何把资源作为可访问的 URL。然后我们会进行 CURD 操作（新建、读取、更新、删除），这些操作是 HTTP 的基本方法，如 GET、POST、PUT 和 DELETE，来与数据进行交互。

这是一个典型的 REST 请求的例子：

```http
// 请求示例
https://swapi.co/api/people/

// 上面请求的 JSON 格式响应
{
	"results": [
		{
			"name": "Luke Skywalker",
			"gender": "male",
			"homeworld": "https://swapi.co/api/planets/1/",
			"films": [
				"https://swapi.co/api/films/2/",
				"https://swapi.co/api/films/6/",
				"https://swapi.co/api/films/3/",
				"https://swapi.co/api/films/1/",
				"https://swapi.co/api/films/7/"
			],
    }
		{
			"name": "C-3PO",
			"gender": "n/a",
			"homeworld": "https://swapi.co/api/planets/1/",
			"films": [
				"https://swapi.co/api/films/2/",
				"https://swapi.co/api/films/5/",
				"https://swapi.co/api/films/4/",
				"https://swapi.co/api/films/6/",
				"https://swapi.co/api/films/3/",
				"https://swapi.co/api/films/1/"
			],
		}
  ]
}
```

REST API 的响应的格式未必会是 JSON，但是这是目前大多数 API 的首选方法。**除了 REST，还出现了另一种处理网络请求的方法：GraphQL。开源于 2015 年，GraphQL 正在改变开发人员在服务端写 API 以及在客户端处理的方式。** GraphQL 由 Facebook 开发并积极维护。


### REST 的弊端

GraphQL 是一种用于 API 开发的查询语言。和 REST（一种架构或者“一种做事方式”）相比，GraphQL 的开发基于一个理念：客户端每次仅从服务端请求所需要的项目集合。

在上面的例子中，使用了 REST 或者其他类似架构。当请求电影时，Luke Skywalker 出现在电影 Star Wars 中，我们得到了一系列的 `电影` 或者 `homeworld` 的名称，他们还包含了不同的 API URL，引导我们去了解不同 JSON 数据集的详细信息。这肯定是一个过度获取（over fetching）的例子。客户端为了去获取人物 Luke Skywalker 出现在电影中的细节以及他家乡星球的名称，只能去向服务端发起多个请求。

使用 GraphQL，就可以将其解析为单个网络请求。转到 API 网址：`https://graphql.github.io/swapi-graphql/`，查看运行以下查询（query）。

*注意：在下面的例子中，你可以不必理会 GraphQL API 幕后的工作方式。我将在本教程后面逐步构建你自己的（可能是第一个）GraphQL API。*

```graphql
{
	allPeople {
		edges {
			node {
				name
				gender
				homeworld {
					name
				}
				filmConnection {
					edges {
						node {
							title
						}
					}
				}
			}
		}
	}
}
```

我们将获取我们需要的数据。例如角色的名称、他们的性别（`gender`）、家园（`homeworld`），以及他们出现的电影（`films`）的标题。运行上述查询，你将获得以下结果：

```
{
	"data": {
		"allPeople": {
			"edges": [
				{
					"node": {
						"name": "Luke Skywalker",
						"gender": "male",
						"homeworld": {
							"name": "Tatooine"
						},
						"filmConnection": {
							"edges": [
								{
									"node": {
										"title": "A New Hope"
									}
								},
								{
									"node": {
										"title": "The Empire Strikes Back"
									}
								},
								{
									"node": {
										"title": "Return of the Jedi"
									}
								},
								{
									"node": {
										"title": "Revenge of the Sith"
									}
								},
								{
									"node": {
										"title": "The Force Awakens"
									}
								}
							]
						}
					}
				},
				{
					"node": {
						"name": "C-3PO",
						"gender": "n/a",
						"homeworld": {
							"name": "Tatooine"
						},
						"filmConnection": {
							"edges": [
								{
									"node": {
										"title": "A New Hope"
									}
								},
								{
									"node": {
										"title": "The Empire Strikes Back"
									}
								},
								{
									"node": {
										"title": "Return of the Jedi"
									}
								},
								{
									"node": {
										"title": "The Phantom Menace"
									}
								},
								{
									"node": {
										"title": "Attack of the Clones"
									}
								},
								{
									"node": {
										"title": "Revenge of the Sith"
									}
								}
							]
						}
					}
				}
			]
		}
	}
}
```

如果应用程序的客户端正在触发上述 GraphQL URL，它只需要咋网络上发一个请求就可以得到所需结果。从而消除了任何会导致过度获取或发送多个请求的可能性。

### 先决条件

要学习本课程，你只需要在本地计算机上安装 `nodejs` 和 `npm` 即可。

*   [Nodejs](http://nodejs.org) `^8.12.0`
*   npm `^6.4.1`

### GraphQL 简述

简而言之，**GraphQL** 是一种用于阐述如何请求 *data* 的语法，通常用于从客户端检索数据（也称为 *query*）或者对其进行更改（也称为 *mutation*）。


GraphQL 几乎没有什么定义特征：

* 它允许客户端准确指定所需的数据。这也成为声明性数据提取。
* 对网络层没有看法
* 使组合来自多个来源的多组数据更容易
* 在以 schema 和 query 的形式声明数据结构时，它使用强类型系统。这有助于在发送网络请求之前校验查询。

### GraphQL API 的构建模块

GraphQL API 有四个构建模块：

*   schema
*   query
*   mutations
*   resolvers

**Schema** 以对象的形式在服务器上定义。每个对象对应于数据类型，以便于去查询他们。例如：

```
type User {
	id: ID!
	name: String
	age: Int
}
```
上面的 schema 定义了一个用户对象的样子。其中必需的字段 `id` 用 `!` 符号标识。还包含其他字段，例如 *string* 类型的 `name` 和 *integer* 类型的 `age`。这也会在查询数据的时候对 `schena` 进行验证。

**Queries** 是你用来向 GraphQL API 发出请求的方法。例如，在我们上面的示例中，就像我们获取 Star Wars 相关的数据时那样。让我们简化一下，如果在 GraphQL 中查询，就是在查询对象的特定字段。例如，使用上面相同的 API，我们呢获取 Star Wars 中所有角色的名称。下面你可以看到差异，在图片的左侧是查询，右侧是结果。（译者注： 原文是 on the right-hand side is the image，译者认为不是很合适）

![](https://cdn-images-1.medium.com/max/1000/1*L-Z_EF1tNkq4jUhsopHasw.png)

使用 GraphQL 查询的好处是它们可以嵌套到你想要的深度。这在 REST API 中很难做到。（在 REST API 中）操作变得复杂得多。

下面是一个更复杂的嵌套查询示例：

![](https://cdn-images-1.medium.com/max/1000/1*ug3h4hZmAeuNHyy93Ygy2Q.png)

**Mutations:** 在 REST 架构中，要修改数据，我们要么使用 `POST` 来添加数据，要么使用 `PUT` 来更新现有字段的数据。在 GraphQL 中，整体的概念是类似的。你可以发送一个 query 来在服务端执行写入操作。但是。这种形式的查询称为 Mutation。

**Resolvers** 是 schema 和 data 之间的纽带。它们提供可用于通过不同操作与数据库交互的功能。

*在这个教程中，你将学习用我们刚刚学到的构件，来使用 [_Nodejs_](https://www.crowdbotics.com/build/node-js?utm_source=medium&utm_campaign=nodeh&utm_medium=node&utm_content=koa-rest-api) 构建 GraphQL 服务器。*

### Hello World! 使用 GraphQL

现在我们来写我们第一个 GraphQL 服务器。本教程中，我们将使用 [Apollo Server](https://www.apollographql.com/docs/apollo-server/)。我们需要为 Apollo Server 安装三个包才能使用现有的 Express 应用程序作为中间件。Apollo Server 的优点在于它可以与 Node.js 的几个流行框架一起使用：Express、[Koa](https://medium.com/crowdbotics/building-a-rest-api-with-koajs-417c276929e2) 和 [Hapi](https://medium.com/crowdbotics/setting-up-nodejs-backend-for-a-react-app-fe2219f26ea4)。Apollo 本身和库无关，因此在客户端和服务器应用程序中，它可以和许多第三方库连接。

打开你的终端安装以下依赖：

```bash
# 首先新建一个空文件夹
mkdir apollo-express-demo

# 然后初始化
npm init -y

# 安装需要的依赖
npm install --save graphql apollo-server-express express
```
让我们简要了解下这些依赖的作用。

* `graphql` 是一个支持库，使我们所期望添加的模块
* 添加到现有应用程序中的 `apollp-server-express` 是相应的 HTTP 服务器支持包
* `express` 是 Nodejs 的 web 框架

你可以在下面的图中看到我安装了全部的依赖，没有出现任何错误。

![](https://cdn-images-1.medium.com/max/800/1*gCozaTuzY6DHaPG4Ya43zA.png)

在你项目的根路径下，新建一个名字为 `index.js` 、包含以下代码的文件。

```js
const express = require('express');
const { ApolloServer, gql } = require('apollo-server-express');

const typeDefs = gql`
	type Query {
		hello: String
	}
`;

const resolvers = {
	Query: {
		hello: () => 'Hello world!'
	}
};

const server = new ApolloServer({ typeDefs, resolvers });

const app = express();
server.applyMiddleware({ app });

app.listen({ port: 4000 }, () =>
	console.log(`🚀 Server ready at http://localhost:4000${server.graphqlPath}`)
);
```
这是我们服务器文件的起点。首先，我们仅仅只需要 `express` 模块。`gql` 是一个模板文字标记，用于将 GraphQL schema 编写为类型。schema 由具有强制 *Query* 类型的类型定义组成，用于读取数据。它还可以包含表示其他数据字段的字段和嵌套字段。在我们上面的例子中，我们定义了 `typeDefs` 来编写 graphQL 的 schema。

然后 `resolvers` 映入眼帘。Resolver 用于从 schema 中返回字段的数据。在我们的示例中，我们定义了一个 resolver，它将函数 `hello()` 映射到我们的 schema 上实现。接下来，我们创建一个 `server`，它使用 `ApolloServer` 类来实例化并启动服务器。由于我们使用了 Express，所以我们需要集成 `ApolloServer` 类。通过 `applyMiddleware()` 作为 `app` 来传递它，来添加 Apollo Server 的中间件。这里的 `app` 是 Express 的一个实例，代表了现有的应用程序。

最后，我们使用 Express 模块提供的 `app.listen()` 来引导服务器。要运行服务器，只需要打开 terminal 并运行命令 `node index.js`。现在，从浏览器窗口访问 url：`http://localhost:4000/graphql` 来看看它的操作。

Apollo Server 为你设置了 GraphQL Playground，供你快速开始运行 query，探索 schema，如下所示。

![](https://cdn-images-1.medium.com/max/1000/1*ba4JULFAk5VbSFRsNxof8g.png)

要运行一个 query，在左侧编辑空白部分，输入以下 query。然后按中间的 ▶ （play）按钮。

![](https://cdn-images-1.medium.com/max/1000/1*SGaIF-GZ0E0QLg2K6sJ7CA.png)

右侧的 schema 卡描述了我们查询 `hello` 的数据类型。这直接来自我们服务器中定义的 `typeDefs`。

![](https://cdn-images-1.medium.com/max/800/1*3v_Uh_k2gjC-XueD9PhWvQ.png)

*瞧！*你刚创建了第一个 GraphQL 服务器。现在让我们拓展下我们对现实世界的认知。

### 使用 GraphQL 构建 API

目前为止我们整理了所有必要的模块以及随附的必要术语。在这一节，我们将用 Apollo Server 为我们的演示去创建一个小的 *Star Wars API*。你可能已经猜到了 Apollo server 是一个库，可以帮助你使用 Nodejs 将 GraphQL schema 连接到 HTTP server。它不局限于特定的 Node 框架。例如上一节中我们使用了 ExpressJS。Apollo Server 支持 [Koa](https://medium.com/crowdbotics/building-a-rest-api-with-koajs-417c276929e2)，Restify，[Hapi](https://medium.com/crowdbotics/setting-up-nodejs-backend-for-a-react-app-fe2219f26ea4) 和 Lambda。对于我们的 API，我们继续使用 Express。

### 使用 Babel 进行编译

如果想从头开始，请继续。从 `Hello World！With GraphQL` 一节安装所有的库。这是我们在前面一节中安装的所有依赖：

```
"dependencies": {
		"apollo-server-express": "^2.1.0",
		"express": "^4.16.4",
		"graphql": "^14.0.2"
	}
```

我将使用相同的项目和相同的文件 `index.js` 去引导服务器启动。但是在我们构建我们的 API 之前，我想告诉你如何在我们的演示项目中使用 ES6 modules。对于使用像 React 和 Angular 这样的前端库，他们已经支持了 ES6 特性。例如 `import` 和 `export default` 这样的语句。Nodejs 版本 `8.x.x` 解决了这个问题。我们所需要的只是一个转换器（transpiler）让我们使用 ES6 特性编写 JavaScript。你完全可以跳过这个步骤使用旧的 `require()` 语句。

那么什么是*转换器*呢？

> *转换器（Transpiler）也被称作‘源到源的编译器’，从一种编程语言写的源码中读取代码转换成另一种语言的等效代码。* 

在 Nodejs 的情况下，我们不会切换编程语言，而是要使用哪些我目前使用的 LTS 版本的 Node 不支持的语言的新特性。我将安装 [**Babel**](https://babeljs.io/) **编译器**，并通过接下来的配置过程在我们的项目中启用它。

首先，你需要安装一些依赖，记得使用 `-D` 参数。因为我们只会在开发环境中用到这些依赖。

```bash
npm install -D babel-cli babel-preset-env babel-watch
```

只要你成功安装了他们，在项目的根目录下添加一个 `.babelrc` 文件并且添加以下配置：

```
{
	"presets": [env]
}
```

配置流程的最后一步是在 `package.json` 中添加一个 `dev` `脚本（script）`。一旦（项目文件）发生变化，babel 编译器将自动运行。这由 `babel-watch` 完成。同时它也负责重新启动 [Nodejs](https://www.crowdbotics.com/build/node-js?utm_source=medium&utm_campaign=nodeh&utm_medium=node&utm_content=koa-rest-api) 网络服务器。

```
"scripts": {
	"dev": "babel-watch index.js"
}
```

要查看它的操作，请将以下代码添加到 `index.js` 中，看看是否一切正常。

```js
import express from 'express';

const app = express();

app.get('/', (req, res) => res.send('Babel Working!'));

app.listen({ port: 4000 }, () =>
	console.log(`🚀 Server ready at http://localhost:4000`)
);
```

在终端中输入 `npm run dev`，不出意外，你可以看到下面的信息：

![](https://cdn-images-1.medium.com/max/800/1*Cix-Zl8mbZf90qpuHxEB8g.png)

你也可以在浏览器中访问 `http://localhost:4000/` 去看看其操作。

### 添加 Schema

我们需要一个 schema 来启动我们的 GraphQL API。让我们在 `api` 目录下创建一个名字为 `api/schema.js` 的新文件。添加以下 schema。

```js
import { gql } from 'apollo-server-express';

const typeDefs = gql`
	type Person {
		id: Int
		name: String
		gender: String
		homeworld: String
	}
	type Query {
		allPeople: [Person]
		person(id: Int!): Person
	}
`;

export default typeDefs;
```

我们的 schema 一共包含两个 query。第一个是 `allPeople`，通过它我们可以列出到 API 中的所有的人物。第二个查询 `person` 是使用他们的 id 检索一个人。这两种查询类型都依赖于一个名为 `Person` 对象的自定义类型，该对象包含四个属性。

### 添加 Resolver

我们已经了解了 resolver 的重要性。它基于一种简单的机制，去关联 schema 和 data。Resolver 是包含 query 或者 mutation 背后的逻辑和函数。然后使用它们来检索数据并在相关请求上返回。

如果在使用 Express 之前构建了服务器，则可以将 resolver 视为控制器，其中每一个控制器都是针对特定路由构建。由于我们不在服务器后面使用数据库，因此我们必须提供一些虚拟数据来模拟我们的 API。

创建一个名为 `resolvers.js` 的新文件并添加下面的文件。

```js
const defaultData = [
	{
		id: 1,
		name: 'Luke SkyWaler',
		gender: 'male',
		homeworld: 'Tattoine'
	},
	{
		id: 2,
		name: 'C-3PO',
		gender: 'bot',
		homeworld: 'Tattoine'
	}
];

const resolvers = {
	Query: {
		allPeople: () => {
			return defaultData;
		},
		person: (root, { id }) => {
			return defaultData.filter(character => {
				return (character.id = id);
			})[0];
		}
	}
};

export default resolvers;
```

首先，我们定义 `defaultData` 数组，其中包含 Star Wars 中两个人物的详细信息。根据我们的 schema ，数组中的这两个对象都有四个属性。接下来是我们的 `resolvers` 对象，它包含两个函数。这里可以使用 `allPeople()` 来检索 `defaultData` 数组中的所有数据。`person()` 箭头函数使用参数 `id` 来检索具有请求 ID 的 person 对象。这个已经在我们的查询中定义了。

你必须导出 resolver 和 schema 对象才能将它们与 Apollo Server 中间件一起使用。

### 实现服务器

现在我们定义了 schema 和 resolver，我们将要在 `index.js` 文件里边实现服务器。首先从 `apollo-server-express` 导入 Apollo-Server。我们还需要从 `api/` 文件夹导入我们的 schema 和 resolvers 对象。然后，使用 Apollo Server Express 库中的 GraphQL 中间件实例化 GraphQL API。

```js
import express from 'express';
import { ApolloServer } from 'apollo-server-express';

import typeDefs from './api/schema';
import resolvers from './api/resolvers';

const app = express();

const PORT = 4000;

const SERVER = new ApolloServer({
	typeDefs,
	resolvers
});

SERVER.applyMiddleware({ app });

app.listen(PORT, () =>
	console.log(`🚀 GraphQL playground is running at http://localhost:4000`)
);
```
最后，我们使用 `app.listen()` 来引导我们的 Express 服务器。你现在可以从终端执行命令 `npm run dev`来运行服务器。服务器节点启动后，将提示成功消息，指示服务器已经启动。

现在要测试我们的 GraphQL API，在浏览器窗口中跳转 `http://localhost:4000/graphql` URL 并运行以下 query。

```
{
  allPeople {
    id
    name
    gender
    homeworld
  }
}
```

点击 *play* 按钮，你将在右侧部分看到熟悉的结果，如下所示。

![](https://cdn-images-1.medium.com/max/1000/1*BnyLxWTl_9yDpoIDLH-Xzg.png)

一切正常，因为我们的查询类型 `allPeople` 具有自定义的业务逻辑，可以使用 resolver 检索所有数据（在我们的例子中，我们在 `resolvers.js` 中作为数据提供的模拟数据）。要获取单个人物对象，请尝试运行类似的其他 query。请记住，必须提供 ID。

```
{
	person(id: 1) {
		name
		homeworld
	}
}
```

运行上面的查询，在结果中，你可以获得得到的每个字段/属性的值以进行查询。你的结果将类似于以下内容。

![](https://cdn-images-1.medium.com/max/1000/1*DOSW6mN894ZYg498rVxNKg.png)

完美！我相信你必须掌握如何创建 GraphQL query 并运行它。Apollo Server 库功能很强大。它让我们能够编辑 playground。*假设我们要编辑 playground 的主题？* 我们要做的就是在创建 `ApolloServer` 实例时提供一个选项，在我们的例子中事 `SERVER`。

```js
const SERVER = new ApolloServer({
	typeDefs,
	resolvers,
	playground: {
		settings: {
			'editor.theme': 'light'
		}
	}
});
```

`playground` 属性有很多功能，例如定义 playground 的默认端点（endpoint）以更改主题。你甚至可以在生产模式启用 playground。更多配置项可以在Apollo Server 的官方文档中找到，[**这里。**]

更改主题后我们获取下面的结果。

![](https://cdn-images-1.medium.com/max/1000/1*cZ7KO6x0FVXql9c04ZshIA.png)

### 结论

如果你一步一步完成教程，那么 *祝贺你！🎉*

你已经学习了如何使用 Apollo 库配置 Express 服务器来设置您自己的 GraphQL API。Apollo Server 是一个开源项目，是为全栈应用程序创建 GraphQL API 的最稳定的解决方案之一。他还支持客户端开箱即用的 React、Vue、Angular、Meteor 和 Ember 以及使用 Swift 和 Java 的 Native 移动开发。有关这方面的更多信息可以在[**这里**](https://www.apollographql.com/docs/react/)找到。

**在此 Github 存储库中查看教程的完整代码 👇**

* [**amandeepmittal/apollo-express-demo**: Apollo Server Express. 通过在 Github 上创建一个账户，为 amandeepmittal/apollo-express-demo 开发做贡献。](https://github.com/amandeepmittal/apollo-express-demo "https://github.com/amandeepmittal/apollo-express-demo")

#### 启动一个新的 Node.js 项目，或者寻找一个 Node 开发者？

[**Crowdbotics 帮助企业利用 Node 构建酷炫的东西**](http://crowdbotics.com/build/node-js?utm_source=medium&utm_campaign=nodeh&utm_medium=node&utm_content=koa-rest-api)  (除此之外)。如果你有一个 Node 项目，你需要其他开发者资源，请给我们留言。 Crowbotics 可以帮助您估算给定产品的功能规格的构建时间，并根据您的需要提供专门的 Node 开发者。**如果你使用 Node 构建，** [**查看 Crowdbotics**](http://crowdbotics.com/build/node-js?utm_source=medium&utm_campaign=nodeh&utm_medium=node&utm_content=koa-rest-api)**.**

感谢 [William Wickey](https://medium.com/@wwickey) 提供编辑方面的帮助。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
