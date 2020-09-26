> * 原文地址：[Introduction to Blitz.js](https://blog.bitsrc.io/introduction-to-blitz-js-ff1e48ea5714)
> * 原文作者：[Chidume Nnamdi 🔥💻🎵🎮](https://medium.com/@kurtwanger40)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/introduction-to-blitz-js.md](https://github.com/xitu/gold-miner/blob/master/article/2020/introduction-to-blitz-js.md)
> * 译者：[plusmultiply0](https://github.com/plusmultiply0)
> * 校对者：

# Blitz.js 简介

![](https://cdn-images-1.medium.com/max/2800/0*UyEKhRBaINAtNNiB.png)

Yet another framework on the block. JavaScript 社区一直在稳步发展，这已经不是什么新闻了，并且已经推出了数百个框架，这无疑超出了我们的理解和掌握范围。

现在，大多数稳定的框架都有基于其构建的框架，使其更复杂以及具有更高的性能。

在本文，我们将会简单介绍 Blitz.js 框架。

## 为什么我们需要 blitz.js 框架？

是的，React 增强了我们现在构建应用的方式。[组件驱动设计](https://bit.dev) 使得我们从单个的单元向上构建应用更加容易。

但是，构建应用并不仅是在 React 中堆叠组件。我们必须思考，如何设置配置、遵循最佳设计模式、建立文件夹结构，组织应用的结构、规划应用的路由/页面以及使用什么数据库，服务器以及数据库模式模型。

在编写代码前就要决定好上述的所有事情，实在是令人头疼。

Blitz.js 为我们解决了以上的所有问题，它提供了一个全栈整体的服务器端渲染 React 应用程序脚手架，并内置了相应的配置和后端。就像 Rails 框架在 Ruby 上所做的。

通过 blitz.js 带来的好处，所提高的生产力将远远超出我们的想象。

现在，我们已经知道为什么需要 blitz.js 了。让我们来看看更加详细的功能。

## Blitz.js

Blitz.js 是受 Ruby on Rails 启发，基于 Next.js 构建的零-API（Zero-API）数据层全栈 React 框架。

让我们根据框架作者的话来看看 Blitz.js 的主要功能和优点：

1. “Zero-API” 数据层让你无需手动添加 API 端点（API endpoints）或进行客户端访问和缓存（fetching and caching）就能直接将服务器代码导入到 React 组件中。
2. 包含了产品级应用所需的一切事物。从数据库到前端的一切的端对端事物。
3. 带来 Ruby on Rails 框架的简洁和约定的同时，保留了我们对 React 中所热爱的一切事物。

#### 安装 & 基础用法

要开始使用 Blitz.js ，首先，我们需要安装命令行工具。

Blitz.js 需运行在 Nodejs v12+。

我们在计算机上全局安装 Blitz.js 的命令行工具。

```bash
npm install -g blitz
```

安装以后，我们就可以在任意目录中使用 `blitz` 命令了。

为了创建一个新的 Blitzjs 应用，在 blitz 命令中加上 new 参数：

```bash
blitz new blitz-app
```

`new` 子命令（sub-command）会创建一个以 `blitz-app` 为名的 Blitz 新项目。

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

`app/` 目录是大多数项目的主要容器。就是放置应用组件，页面和路由的地方。如同你的应用中 `src` 目录。

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

The `db/` is where the app's database configuration goes. By default, Blitz uses Prisma 2 which is a strongly-typed database client. You can use anything you want, such as Mongo, TypeORM, etc. By default, Blitz uses the local SQLite as the database.

```ts
datasource db {
    provider = "sqlite"
    url = env("DATABASE_URL")
}
```

The `provider` tells Prisma that the app uses the SQLite database. If we want to use other databases like Postgres for example we will change the value of `provider` from `sqlite` to `postgres`.

```ts
datasource db {
    provider = "postgres"
    url = env("DATABASE_URL")
}
```

In this schema.prisma file we can define our models:

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

The models map to the tables in the database.

The `node_modules/` directory holds the dependencies installed in your project. This is very much quite heavy in size.

The `public/` directory holds the static assets. The static assets are media files like images, music, video files, favicons, etc.

The `utils/` directory houses the utility files that can be shared or used in the whole app.

`blitz.config.js` is a Blitzjs configuration file. All the custom configurations for your Blitz app is set here. It extends `next.config.js`.

## Server

We can start the Blitz server to serve our project by running the command:

```bash
blitz start
```

Note: you must be inside the `blitz-app` directory for the command to load and serve our app.

Now, we will see the following output:

```
✔ Prepped for launch
[ wait ] starting the development server ...
[ info ] waiting on http://localhost:3000 ...
[ info ] bundled successfully, waiting for typecheck results
[ wait ] compiling ...
[ info ] bundled successfully, waiting for typecheck results
[ ready ] compiled successfully - ready on http://localhost:3000
```

We see that Blitz has compiled and started a server at localhost:3000 to serve our app. Now navigate to [http://localhost:3000](http://localhost:3000) to see the Blitz rendered.

## Blitz generate

The Blitz CLI tool is quite automated. With this CLI tool, we can use the `generate` sub-command to scaffold all code we want in our Blitz app.

It goes like this:

```
blitz generate <type> <model_name>
```

The blitz ‘generate’ command can scaffold/generate Prisma models, mutations, queries, pages.

The `\<type>` argument specifies the type of file to generate.

The `\<type>` can have the following values:

`all`: These generate model, queries, mutations, pages files.

Example:

```bash
blitz generate all blogPost
```

See we used the `all` sub-command. This command will generate these files:

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

The `all` sub-command generates pages for the blogPost:

```
app/blogPosts/pages/blogPosts/[blogPostId]/edit.tsx
app/blogPosts/pages/blogPosts/[blogPostId].tsx
app/blogPosts/pages/blogPosts/index.tsx
app/blogPosts/pages/blogPosts/new.tsx
```

All these files export components that will be rendered when the route matching the page is navigated to.

app/blogPosts/pages/blogPosts/index.tsx will be loaded when the route `/blogPosts` is navigated to in the browser. It will render all blog posts in the database.

app/blogPosts/pages/blogPosts/new.tsx will be loaded on `/blogPosts/new` route navigation. The page will be to create a new blog post.

app/blogPosts/pages/blogPosts/[blogPostId]/edit.tsx will be loaded on `/blogPosts/[blogPostId]/edit` route navigation. This will be to edit a blog post with its id `[blogPostId]`.

app/blogPosts/pages/blogPosts/[blogPostId].tsx will be loaded on `/blogPosts/[blogPostId]` route navigation. This will render the blog post by its id `[blogPostId]`.

```
app/blogPosts/queries/getBlogPost.ts
app/blogPosts/queries/getBlogPosts.ts
```

The queries houses files that retrieve a blog post or blog posts. app/blogPosts/queries/getBlogPost.ts returns a blog post given the blog post id. app/blogPosts/queries/getBlogPosts.ts retrieves all the blog posts in the database.

```
app/blogPosts/mutations/createBlogPost.ts
app/blogPosts/mutations/deleteBlogPost.ts
app/blogPosts/mutations/updateBlogPost.ts
```

The mutations do the CUD in CRUD, they can create, update, or delete a blog post. app/blogPosts/mutations/createBlogPost.ts this file creates a new blog post. app/blogPosts/mutations/deleteBlogPost.ts delete a blog post given the id. app/blogPosts/mutations/updateBlogPost.ts edit a given blog post.

`resource`: This sub-command creates model, queries, and mutations.

Example:

```bash
blitz generate resource blogPost
```

This command will generate these files:

```
app/blogPosts/queries/getBlogPost.ts
app/blogPosts/queries/getBlogPosts.ts
app/blogPosts/mutations/createBlogPost.ts
app/blogPosts/mutations/deleteBlogPost.ts
app/blogPosts/mutations/updateBlogPost.ts
```

`crud`: This will create queries and mutations. Unlike `resource` it will generate the Prisma model.

Example:

```bash
blitz generate crud blogPost
```

This command will generate these files:

```
app/blogPosts/queries/getBlogPost.ts
app/blogPosts/queries/getBlogPosts.ts
app/blogPosts/mutations/createBlogPost.ts
app/blogPosts/mutations/deleteBlogPost.ts
app/blogPosts/mutations/updateBlogPost.ts
```

`queries` and `query`: This sub-commands will only generate queries files:

Example:

```bash
blitz generate queries blogPost
```

This command will generate these files:

```
app/blogPosts/queries/getBlogPost.ts
app/blogPosts/queries/getBlogPosts.ts
```

`mutations`: This sub-command will generate mutations files only. No queries, pages, and models.

Example:

```bash
blitz generate mutations blogPost
```

This command will generate these files:

```
app/blogPosts/mutations/createBlogPost.ts
app/blogPosts/mutations/deleteBlogPost.ts
app/blogPosts/mutations/updateBlogPost.ts
```

`pages`: This sub-command will generate only pages files.

Example:

```bash
blitz generate pages blogPost
```

This command will generate these files:

```
app/blogPosts/pages/blogPosts/[blogPostId]/edit.tsx
app/blogPosts/pages/blogPosts/[blogPostId].tsx
app/blogPosts/pages/blogPosts/index.tsx
app/blogPosts/pages/blogPosts/new.tsx
```

The `\<model_name>` argument is the model name to generate files for.

## 总结

Let’s tick them off. Blitz.js offers us:

* Easy page routing
* Database setup and integration
* SSR-enabled application
* Built-in authentication

Blitzjs is awesome. How it made everything simple for us is quite amazing. Just scaffold your project and your good to go!!

If you have any questions regarding this or anything I should add, correct or remove, feel free to comment, email, or DM me.

谢谢！！！

## Blitz 的相关资源

[Blitz.js — The Fullstack React Framework](https://blitzjs.com)

[Getting Started with Blitz](https://blitzjs.com/docs/getting-started)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
