> * 原文地址：[Introduction to Blitz.js](https://blog.bitsrc.io/introduction-to-blitz-js-ff1e48ea5714)
> * 原文作者：[Chidume Nnamdi 🔥💻🎵🎮](https://medium.com/@kurtwanger40)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/introduction-to-blitz-js.md](https://github.com/xitu/gold-miner/blob/master/article/2020/introduction-to-blitz-js.md)
> * 译者：[plusmultiply0](https://github.com/plusmultiply0)
> * 校对者：[JohnieXu](https://github.com/JohnieXu)、[zenblo](https://github.com/zenblo)

# Blitz.js 简介：一个新兴的 React 全栈框架

![](https://cdn-images-1.medium.com/max/2800/0*UyEKhRBaINAtNNiB.png)

JavaScript 社区一直在稳步发展，并且已经推出了数百个框架，这无疑超出了我们的理解和掌握范围，但这并不是新鲜事。

现在，大多数稳定的框架都有基于其进一步构建的框架，同时具有更好的性能以及变得更加复杂。

在本文中，我们将会简单介绍 Blitz.js 框架。

## 为什么我们需要 Blitz.js 框架？

React 增强了我们现在构建应用的方式。[组件驱动设计](https://bit.dev)使得我们更加容易从独立的单元向上构建应用。

但是，构建应用并不仅是在 React 中堆叠组件。我们还必须思考，如何设置配置、遵循最佳设计模式、设置文件夹结构、组织应用的结构、规划应用的路由/页面以及使用什么数据库，服务器和数据库模式模型。

在编写代码前就要决定好上述的所有事情，实在是令人头疼。

Blitz.js 为我们解决了以上的所有问题，它提供了一个完整的全栈服务器端渲染（基于 Next.js）React 应用程序脚手架，并内置了相应的配置和后端。就像 Rails 框架在 Ruby 上所做的那样。

Blitz.js 带来的种种好处，所提高的生产力将远远超出我们的想象。

现在，我们已经知道为什么需要 Blitz.js 了。让我们来看看它的详细功能。

## Blitz.js

Blitz.js 是受 Ruby on Rails 启发，基于 Next.js 构建的零-API（Zero-API）数据层全栈 React 框架。

让我们根据框架作者的话来看看 Blitz.js 的主要功能和优点：

1. “Zero-API” 数据层让你无需手动添加 API 端点（API endpoints）或进行客户端访问和缓存就能直接将服务器代码导入到 React 组件中。
2. 包含了产品级应用所需的一切事物。从数据库到前端的一切的端对端事物。
3. 带来 Ruby on Rails 框架的简洁和约定的同时，保留了我们对 React 中所热爱的一切事物。

#### 安装 & 基础用法

在开始使用 Blitz.js 之前，我们需要安装命令行工具。

Blitz.js 需运行在 Nodejs v12+ 的环境下。

我们在计算机上全局安装 Blitz.js 的命令行工具。

```bash
npm install -g blitz
```

安装以后，我们就可以在任意目录中使用 `blitz` 命令了。

为了创建一个新的 Blitzjs 应用，在 blitz 命令中加上 new 参数：

```bash
blitz new blitz-app
```

`new` 次级命令（sub-command）会创建一个以 `blitz-app` 为名的 Blitz 新项目。

来看看 `blitz-app` 目录结构:

```
blitz-app
│
├── app
│ ├── components
│ │ └── ErrorBoundary.tsx
│ ├── layouts
│ └── pages
│   ├── _app.tsx
│   ├── _document.tsx
│   └── index.tsx
├── db
│ ├── migrations
│ ├── index.ts
│ └── schema.prisma
├── integrations
├── node_modules
├── public
│ ├── favicon.ico
│ └── logo.png
├── utils
├── .babelrc.js
├── .env
├── .eslintrc.js
├── .gitignore
├── .npmrc
├── .prettierignore
├── README.md
├── blitz.config.js
├── package.json
├── tsconfig.json
└── yarn.lock
```

`app/` 目录是项目文件的主要容器，是放置应用组件，页面和路由的地方。如同你的应用中 `src` 目录。

`app/components` 目录用来存放展示组件（presentational components）。展示组件是独立的视图单元，它们唯一的用处就是显示容器组件（container components）传递给它们的数据。

`app/pages` 目录用来存放页面路由。每个页面都是基于文件名和路由产生关联。在 Blitz 中，页面就源于从 pages 目录中 `.js`、`.jsx`、`.ts` 或 `.tsx` 文件导出的 React 组件。

举个例子，如果在我们的应用中有如下的路由：

* /post
* /profile
* /about

那么，在 Blitzjs 的 pages 目录中应有如下的文件夹和文件。

当导航到 "/post" 路由时，`pages/post/index.js` 导出的组件会被渲染。

```js
// pages/post/index.js

function Post() {
    return <div>Post</div>
}

export default Post
```

`pages/profile/index.js` 映射到 `/profile` 路由。`pages/profile/index.js` 导出的组件会在路由被导航到时渲染。

```js
// pages/profile/index.js

function Profile() {
    return <div>Profile</div>
}

export default Profile
```

`pages/about/index.js` 映射到 `/about` 路由。

```js
// pages/about/index.js
function About() {
    return <div>About</div>
}

export default About
```

`db/` 目录用于存放应用的数据库配置。默认情况下，Blitz 使用 Prisma 2（一个强类型数据库客户端）。你可以使用你想用的任何数据库，比如：Mongo，TypeORM 等等。默认情况下，Blitz 使用 SQLite 作为它的数据库。

```ts
datasource db {
    provider = "sqlite"
    url = env("DATABASE_URL")
}
```

`provider` 告诉 Prisma，应用使用 SQLite 数据库。如果我们想使用其他的数据库，以 Postgres 为例，我们可以将 `provider` 的值从 `sqlite` 改成 `postgres`。

```ts
datasource db {
    provider = "postgres"
    url = env("DATABASE_URL")
}
```

在 schema.prisma 文件中，我们可以定义我们的数据库模型：

```ts
datasource db {
    provider = "postgres"
    url = env("DATABASE_URL")
}

model BlogPost {
    id Int @default(autoincrement()) @id
    title String
    description String
}
```

模型（models）映射到位于数据库中的表（tables）。

`node_modules/` 目录存放了你的项目中安装的所有依赖。它的文件体积非常大。

`public/` 目录用于存放静态资源文件，主要是一些图片、音乐、视频、图标等的媒体文件。

`utils/` 目录存放了可以在整个应用中共享或使用的通用文件。

`blitz.config.js` 是 Blitzjs 的配置文件。所有用于 Blitz 应用的自定义配置都可以在这里设置。此文件继承了 `next.config.js` 文件。

## 服务器（Server）

我们可以通过以下的命令开启 Blitz 服务器来运行我们的项目： 

```bash
blitz start
```

注意：你必须位于 `blitz-app` 目录中，才能让命令能加载和运行我们的应用。

现在，我们将会看到以下的输出：

```
✔ Prepped for launch
[ wait ] starting the development server ...
[ info ] waiting on http://localhost:3000 ...
[ info ] bundled successfully, waiting for typecheck results
[ wait ] compiling ...
[ info ] bundled successfully, waiting for typecheck results
[ ready ] compiled successfully - ready on http://localhost:3000
```

我们看到 Blitz 编译成功并开启了一个服务器在 localhost:3000 运行我们的应用程序。现在浏览 [http://localhost:3000](http://localhost:3000) 来看看 Blitz 渲染的结果。

## Blitz 生成（generate）

Blitz 的命令行工具具有高度的自动化。通过使用命令行工具，我们可以用 `generate` 次级命令以在我们的 Blitz 应用中为所有的代码提供脚手架。

命令的格式如下：

```
blitz generate <type> <model_name>
```

`generate` 命令可以生成 Prisma 的 models，mutations，queries 以及 pages 文件。

`\<type>` 参数指定要生成的文件的类型。

`\<type>` 可以有如下的取值：

`all`：用于生成 models，mutations，queries 以及 pages 文件。

举例：

```bash
blitz generate all blogPost
```

我们使用了 `all` 次级命令。这个命令会生成如下的文件：

```
app/blogPosts/pages/blogPosts/[blogPostId]/edit.tsx
app/blogPosts/pages/blogPosts/[blogPostId].tsx
app/blogPosts/pages/blogPosts/index.tsx
app/blogPosts/pages/blogPosts/new.tsx
app/blogPosts/components/BlogPostForm.tsx
app/blogPosts/queries/getBlogPost.ts
app/blogPosts/queries/getBlogPosts.ts
app/blogPosts/mutations/createBlogPost.ts
app/blogPosts/mutations/deleteBlogPost.ts
app/blogPosts/mutations/updateBlogPost.ts
```

`all` 次级命令为 blogPost 生成 pages：

```
app/blogPosts/pages/blogPosts/[blogPostId]/edit.tsx
app/blogPosts/pages/blogPosts/[blogPostId].tsx
app/blogPosts/pages/blogPosts/index.tsx
app/blogPosts/pages/blogPosts/new.tsx
```

当路由匹配浏览到的页面时，这些文件导出的对应组件就会被渲染。

`app/blogPosts/pages/blogPosts/index.tsx` 会被加载，当在浏览器中导航至 `/blogPosts` 路由时。它会渲染数据库中所有的博客文章。

`app/blogPosts/pages/blogPosts/new.tsx` 会在导航至 `/blogPosts/new` 路由时被加载，此页面用来创建一个新的博客文章。

`app/blogPosts/pages/blogPosts/[blogPostId]/edit.tsx` 会在导航至 `/blogPosts/[blogPostId]/edit` 路由时被加载，用于编辑 id 为 `[blogPostId]` 的博客文章。

`app/blogPosts/pages/blogPosts/[blogPostId].tsx` 在导航至 `/blogPosts/[blogPostId]` 路由时加载，相应的页面会渲染 id 为 `[blogPostId]` 的博客文章。

```
app/blogPosts/queries/getBlogPost.ts
app/blogPosts/queries/getBlogPosts.ts
```

`queries` 目录存放用于检索博客文章的文件。`app/blogPosts/queries/getBlogPost.ts` 基于博客文章的 id 返回一篇博客。`app/blogPosts/queries/getBlogPosts.ts` 用于获取数据库中所有的博客文章。

```
app/blogPosts/mutations/createBlogPost.ts
app/blogPosts/mutations/deleteBlogPost.ts
app/blogPosts/mutations/updateBlogPost.ts
```

`mutations` 做着 CRUD 中 CUD 的事情，可以用于创建，更新或删除一篇博客文章。`app/blogPosts/mutations/createBlogPost.ts` 文件用于创建博客文章。`app/blogPosts/mutations/deleteBlogPost.ts` 基于给定的 id 删除博客文章。`app/blogPosts/mutations/updateBlogPost.ts` 用于编辑指定的博客文章。

`resource`：这个次级命令用于创建 models，mutations 以及 queries 文件。

例子：

```bash
blitz generate resource blogPost
```

命令创建的文件如下：

```
app/blogPosts/queries/getBlogPost.ts
app/blogPosts/queries/getBlogPosts.ts
app/blogPosts/mutations/createBlogPost.ts
app/blogPosts/mutations/deleteBlogPost.ts
app/blogPosts/mutations/updateBlogPost.ts
```

`crud`：用于创建 mutations 和 queries。不同于 `resource` ，它不会生成 Prisma 的 model 文件。

示例：

```bash
blitz generate crud blogPost
```

命令生成的文件如下：

```
app/blogPosts/queries/getBlogPost.ts
app/blogPosts/queries/getBlogPosts.ts
app/blogPosts/mutations/createBlogPost.ts
app/blogPosts/mutations/deleteBlogPost.ts
app/blogPosts/mutations/updateBlogPost.ts
```

`queries` 和 `query`：这个次级命令只会生成 queries 文件：

示例：

```bash
blitz generate queries blogPost
```

这个命令会生成如下的文件：

```
app/blogPosts/queries/getBlogPost.ts
app/blogPosts/queries/getBlogPosts.ts
```

`mutations`：这个次级命令只会生成 mutations 文件。没有 queries，pages 或 models 文件。

举例：

```bash
blitz generate mutations blogPost
```

命令生成的文件如下：

```
app/blogPosts/mutations/createBlogPost.ts
app/blogPosts/mutations/deleteBlogPost.ts
app/blogPosts/mutations/updateBlogPost.ts
```

`pages`：这个次级命令只会生成 pages 文件。

示例：

```bash
blitz generate pages blogPost
```

这个命令只会生成下面的文件：

```
app/blogPosts/pages/blogPosts/[blogPostId]/edit.tsx
app/blogPosts/pages/blogPosts/[blogPostId].tsx
app/blogPosts/pages/blogPosts/index.tsx
app/blogPosts/pages/blogPosts/new.tsx
```

`\<model_name>` 参数是待生成的文件的 model 名。

## 总结

让我们来总结一下，Blitz.js 为我们提供了：

* 易用的页面路由
* 数据库的设置与集成
* 支持服务器端渲染（SSR）
* 内置用户权限认证

Blitzjs 是一个非常好的框架。它让一切事情都变得简单起来了，这真的是令人惊叹。只需用相应的脚手架就可以开发你的项目了！！

感谢您的阅读！！！

## Blitz 的相关资源

[Blitz.js — The Fullstack React Framework](https://blitzjs.com)

[Getting Started with Blitz](https://blitzjs.com/docs/getting-started)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
