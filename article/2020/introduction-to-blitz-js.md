> * 原文地址：[Introduction to Blitz.js](https://blog.bitsrc.io/introduction-to-blitz-js-ff1e48ea5714)
> * 原文作者：[Chidume Nnamdi 🔥💻🎵🎮](https://medium.com/@kurtwanger40)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/introduction-to-blitz-js.md](https://github.com/xitu/gold-miner/blob/master/article/2020/introduction-to-blitz-js.md)
> * 译者：
> * 校对者：

# Introduction to Blitz.js

![](https://cdn-images-1.medium.com/max/2800/0*UyEKhRBaINAtNNiB.png)

Yet another framework on the block. It is no news that the JavaScript community has been growing steadily and with that hundreds of frameworks have been reeled out more than we can comprehend and keep up with.

Now, most of the stable JavaScript frameworks have also frameworks built on top of them, to make them more sophisticated and highly performant.

In this post, we will be introducing the Blitz.js framework.

## Why do we need this blitz.js framework?

Yes, React supercharges the way we build apps these days. The [component driven design](https://bit.dev) makes it very easy to build our app from a single unit of view upwards.

But then, building apps is more than stacks of components in React. We have to think through how to set up the configuration, the best design pattern to follow, how to set up our folder structure, how the app structure is organized, the routes/pages of the app, what database to use, and the server and the database schema model to use.

Deciding on all these things before writing even a single line of code is a serious headache.

Blitz.js plugs all these holes for us, it scaffolds a full-stack monolithic server-side rendered(with Next.js) React app with all the configurations and backend already baked in. Just like the Rails framework does on Ruby.

With these blitz.js makes us far more productive than we ever dreamed was possible.

Now, we have known why we need blitz.js. Let’s see more detailed features of it.

---

Tip: **Share your reusable components** between projects using [**Bit**](https://bit.dev/) ([Github](https://github.com/teambit/bit)).

Bit makes it simple to share, document, and organize independent components from any project**.**

Use it to maximize code reuse, collaborate on independent components, and build apps that scale.

[**Bit**](https://bit.dev/) supports Node, TypeScript, React, Vue, Angular, and more.

![Example: exploring reusable React components shared on [Bit.dev](https://bit.dev/)](https://cdn-images-1.medium.com/max/3678/0*VEkV4XIfo_FtdM9s.gif)

---

## Blitz.js

Blitz.js is a full-stack React framework with a zero-API data layer built on Next.js Inspired by Ruby on Rails.

Let’s see the main features and goodies of Blitz.js according to its creator’s words:

1. “Zero-API” data layer lets you import server code directly into your React components instead of having to manually add API endpoints and do the client-side fetching and caching.
2. Includes everything you need for production apps. Everything end-to-end from the database to the frontend.
3. Brings back the simplicity and conventions of frameworks like Ruby on Rails while preserving everything we love about React

#### Installation & Basic usage

To get started with Blitz.js we first have to install the CLI tool.

Note that Blitz.js runs on Nodejs v12+.

We install the Blitz.js CLI tool globally in our machine.

```
npm install -g blitz
```

With this, we can use the `blitz` command from any directory in our machine.

To create a new Blitzjs app we use the new arg in the blitz command:

```
blitz new blitz-app
```

The `new` sub-command creates a new Blitz project with `blitz-app` as its name.

Let’s look at the `blitz-app` directory:

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

The `app/` directory is the main container for most of your projects. This is where your application components, pages, routes stay. It is just like the `src` of your app.

The `app/components` directory is where presentational will reside. Presentational components are independent single view units, they only work is to display the data passed to them by the container components.

The `app/pages` directory is where the routes reside. Each page is associated with a route based on its file name. In Blitz, a page is a React Component exported from a `.js`, `.jsx`, `.ts`, or `.tsx` file in a pages directory.

For example, if we have routes in our app like this:

* /post
* /profile
* /about

Then, Blitzjs will have the following folders and files in the pages directory

`pages/post/index.js` this exports a component that will be rendered when is the route "/post" is navigated to.

```
// pages/post/index.js

function Post() {
    return <div>Post</div>
}

export default Post
```

pages/profile/index.js maps to the `/profile` route. The pages/profile/index.js exports a React component that will render when the route is navigated to.

```
// pages/profile/index.js

function Profile() {
    return <div>Profile</div>
}

export default Profile
```

`pages/about/index.js` maps to the `/about` route.

```
// pages/about/index.js
function About() {
    return <div>About</div>
}

export default About
```

The `db/` is where the app's database configuration goes. By default, Blitz uses Prisma 2 which is a strongly-typed database client. You can use anything you want, such as Mongo, TypeORM, etc. By default, Blitz uses the local SQLite as the database.

```
datasource db {
    provider = "sqlite"
    url = env("DATABASE_URL")
}
```

The `provider` tells Prisma that the app uses the SQLite database. If we want to use other databases like Postgres for example we will change the value of `provider` from `sqlite` to `postgres`.

```
datasource db {
    provider = "postgres"
    url = env("DATABASE_URL")
}
```

In this schema.prisma file we can define our models:

```
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

```
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

```
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

```
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

```
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

```
blitz generate queries blogPost
```

This command will generate these files:

```
app/blogPosts/queries/getBlogPost.ts
app/blogPosts/queries/getBlogPosts.ts
```

`mutations`: This sub-command will generate mutations files only. No queries, pages, and models.

Example:

```
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

```
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

## Conclusion

Let’s tick them off. Blitz.js offers us:

* Easy page routing
* Database setup and integration
* SSR-enabled application
* Built-in authentication

Blitzjs is awesome. How it made everything simple for us is quite amazing. Just scaffold your project and your good to go!!

If you have any questions regarding this or anything I should add, correct or remove, feel free to comment, email, or DM me.

Thanks !!!

## Learn More
[**Maximizing Code Reuse in React**
**How to speed-up development by sharing ReactJS components from any codebase, using Bit**blog.bitsrc.io](https://blog.bitsrc.io/maximizing-code-reuse-in-react-35ee20ad362c)
[**11 Useful Custom React Hooks for Your Next Web App**
**Top 11 recommended ReactJS custom Hooks — with examples.**blog.bitsrc.io](https://blog.bitsrc.io/11-useful-custom-react-hooks-for-your-next-app-c66307cf0f0c)
[**14 JavaScript Code Optimization Tips for Front-End Developers**
**Tips and tricks to increase performance and website load time**blog.bitsrc.io](https://blog.bitsrc.io/14-javascript-code-optimization-tips-for-front-end-developers-a44763d3a0da)

## Blitz resources
[**Blitz.js — The Fullstack React Framework | Blitz.js ⚡️**
**“Zero-API” data layer lets you import server code directly into your React components instead of having to manually add…**blitzjs.com](https://blitzjs.com)
[**Getting Started with Blitz | Blitz.js ⚡️**
**Before getting started, you should know this is alpha software. Blitz is incomplete. There are rough spots and bugs…**blitzjs.com](https://blitzjs.com/docs/getting-started)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
