> * 原文地址：[Build a blog with Nuxt (Vue.js), Strapi and Apollo](https://strapi.io/blog/build-a-blog-using-nuxt-strapi-and-apollo)
> * 原文作者：[Maxime Castres](https://slack.strapi.io/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/build-a-blog-using-nuxt-strapi-and-apollo.md](https://github.com/xitu/gold-miner/blob/master/TODO1/build-a-blog-using-nuxt-strapi-and-apollo.md)
> * 译者：[vitoxli](https://github.com/vitoxli)
> * 校对者：[Jessica](https://github.com/cyz980908)

# 使用 Nuxt (Vue.js)、Strapi 和 Apollo 构建博客

## 介绍

几周前，我对自己上网的习惯进行了思考，具体来说，我主要思考了在放松状态下自己喜欢读些什么。通常我是这样做的：先进行搜索，然后去浏览最让我感兴趣的链接。然而最后发现，我总是在阅读有关别人人生经历的文章，而这与我最初搜索的内容相去甚远！

博客非常适合分享经验，想法或感言。而 Strapi 可以帮助你方便地创建博客！所以，你肯定已经猜到这篇文章是关于什么的了。让我们学习如何使用 Strapi 来创建博客吧。

## 目标

如果你关注我们的博客，你应该已经学习了如何使用 [Gatsby](https://strapi.io/blog/building-a-static-website-using-gatsby-and-strapi) 来创建博客。但是，如果改用另一种语言该怎么实现呢？今天我们就是要学习如何使用 Vue.js 来创建博客。

本文的目标是创建一个博客网站，这个网站使用 Strapi 作为后端，使用 Nuxt 作为前端，并使用 Apollo 通过 GraphQL 请求 Strapi API。

可以在 GitHub 中获取源码：[https://github.com/strapi/strapi-tutorials/tree/master/tutorials/nuxt-strapi-apollo-blog/](https://github.com/strapi/strapi-tutorials/tree/master/tutorials/nuxt-strapi-apollo-blog/)

## 准备工作

要学习本教程，你的计算机上需要安装 Strapi 和 Nuxt，但是不用担心，我们来一起安装它们！

**本教程使用 Strapi v3.0.0-beta.17.5。**

**你需要确保安装了 v.12 版的 node。**

## 安装

创建一个名为 blog-strapi 的文件夹并跳转到这个文件夹中！

* `mkdir blog-strapi && cd blog-strapi`

#### 安装后端

这部分很容易，因为在 beta.9 中有了一个很棒的软件包 [create strapi-app]([https://www.npmjs.com/package/create-strapi-app](https://www.npmjs.com/package/create-strapi-app))，你无需全局安装 Strapi 便可在几秒钟内创建一个 Strapi 项目，所以让我们尝试一下。

（在这篇教程中，我们会使用 `yarn` 作为包管理工具）

* `yarn create strapi-app backend --quickstart --no-run`.

这条命令行将创建后端所需的全部内容。记得添加 `--no-run`，因为它会阻止应用自动启动服务，之所以这么做，是因为**剧透：我们需要安装一些很棒的 Strapi 插件。**

既然你已经知道我们需要安装一些插件来增强应用了，那让我们来安装广受欢迎的 `graphql` 插件吧：

* `yarn strapi install graphql`

安装完成后，你可以通过 `strapi dev` 来启动 Strapi 服务并且创建你的第一个管理员账号。这个账号拥有应用的所有权限，所以选择一个合适的密码吧，像（**password123**）这种密码就太不安全了。

![](https://blog.strapi.io/content/images/2019/11/Creation-admin.png)

Strapi 运行在 [http://localhost:1337](http://localhost:1337)

**很好！** 现在 Strapi 已经就绪了，我们可以开始创建 Nuxt 应用了。

#### 安装前端

好啦，最简单的部分已经完成了，现在让我们开发我们的博客吧！

**安装 Nuxt**

通过以下命令来创建 Nuxt `前端`服务：

* `yarn create nuxt-app frontend`

**注意：** 终端将提示一些有关项目的详细信息。这些信息与我们的博客关联性不大，因此可以忽略它们。不过，我仍强烈建议你阅读官方文档。让我们继续吧，一直按 Enter 键就好！

同样，安装结束后，可以启动前端应用以确保进展顺利。

```
cd frontend  
yarn dev
```

你可能希望有人阅读你的博客或者你想让你的博客“可爱又好看”，我们将使用流行的 CSS 框架 `UiKit` 来设置样式并使用 `Apollo` 通过 **GraphQL** 来查询 Strapi。

**安装依赖**

在运行以下命令前，先确保你在 `frontend` 文件夹中：

**安装 Apollo**

* `yarn add @nuxtjs/apollo graphql`

必须在 `nuxt.config.js` 中进行模块和 Apollo 的设置。

* 在 `nuxt.config.js` 中添加以下模块和 apollo 配置：

`/frontend/nuxt.config.js`

```js
...
modules: [  
  '@nuxtjs/apollo',
],
apollo: {  
  clientConfigs: {
    default: {
      httpEndpoint: process.env.BACKEND_URL || "http://localhost:1337/graphql"
    }
  }
},
...
```

（因为我们已经在安装后端时安装了 graphql 插件，所以无需再次安装。这种方式可以让项目更加一致）。

**安装 Uilkit**

UIkit 是一个轻量级的模块化前端框架，用于开发快速而强大的 Web 界面。

* `yarn add uikit`

现在，你需要通过创建一个插件来在 Nuxt 应用中初始化 UIkit 的 Js。

* 创建 `/frontend/plugins/uikit.js` 文件并复制/粘贴下面的代码：

```js
import Vue from 'vue'

import UIkit from 'uikit/dist/js/uikit-core'  
import Icons from 'uikit/dist/js/uikit-icons'

UIkit.use(Icons)  
UIkit.container = '#__nuxt'

Vue.prototype.$uikit = UIkit  
```

* Add the following part in your `nuxt.config.js` file

```css
...
css: [  
    'uikit/dist/css/uikit.min.css',
    'uikit/dist/css/uikit.css',
    '@assets/css/main.css'
  ],
  /*
  ** Plugins to load before mounting the App
  */
  plugins: [
    { src: '~/plugins/uikit.js', ssr: false }
  ],
...
```

如你所见，我们同时配置了 UIkit 和 `main.css`！现在，我们需要创建 `main.css` 文件。

```css
a {  
  text-decoration: none;
}

h1  {  
  font-family: Staatliches;
  font-size: 120px;
}

#category {
   font-family: Staatliches;
   font-weight: 500;
}

#title {
  letter-spacing: .4px;
  font-size: 22px;
  font-size: 1.375rem;
  line-height: 1.13636;
}

#banner {
  margin: 20px;
  height: 800px;
}

#editor {
  font-size: 16px;
  font-size: 1rem;
  line-height: 1.75;
}

.uk-navbar-container {
  background: #fff !important;
  font-family: Staatliches;
}

img:hover {  
  opacity: 1;
  transition: opacity 0.25s cubic-bezier(0.39, 0.575, 0.565, 1);
}
```

**注意：** 你无需理解这个文件中的内容。只是一些样式 ;）

让我们为项目添加漂亮的字体（Staatliches）吧！

* 将下面的对象添加到 `nuxt.config.js` 文件中的 `link` 数组中

```js
link: [  
      { rel: 'stylesheet', href: 'https://fonts.googleapis.com/css?family=Staatliches' }
    ]
```

**完美！** 重启服务，并准备好被你应用的前端页面惊艳吧！

![](https://blog.strapi.io/content/images/2019/11/Capture-d-e-cran-2019-11-06-a--15.30.14.png)

#### 设计数据结构

终于到了这一步！我们将通过创建 `article` 内容类型来构建文章的数据结构：

* 查看你的 strapi 管理面板，然后点击侧边栏中的 `Content Type Builder`

![](https://blog.strapi.io/content/images/2019/11/Capture-d-e-cran-2019-11-06-a--15.39.45.png)

* 点击 `Add A Content Type` 并命名为 `article`

![](https://blog.strapi.io/content/images/2019/11/Capture-d-e-cran-2019-11-06-a--15.39.53.png)

现在，你将为你的内容类型创建所有字段：

![](https://blog.strapi.io/content/images/2019/11/Capture-d-e-cran-2019-11-06-a--15.40.02.png)

* 创建如下字段：
    * `title`：**String** 类型 (**必填**)
    * `content`：**Rich Text** 类型 (**必填**)
    * `image`：**Media** 类型 (**必填**)
    * `published_at`：**Date** 类型 (**必填**)

**点击保存！** 现在，你的第一个内容类型就创建好了。可能现在你就想创建你的第一篇文章，但是在此之前我们还要做一件事：**开放文章内容类型权限**

* 点击 [Roles & Permission](http://localhost:1337/admin/plugins/users-permissions/roles) 然后选择 `public`。
* 选中文章的`find` 和 `findone` 选项并保存。

![](https://blog.strapi.io/content/images/2019/11/Capture-d-e-cran-2019-11-06-a--16.00.00.png)

**棒极了！** 现在你可以创建你的第一篇文章了，并可以在 GraphQL Playground 中获取到它。

* 创建你的第一篇文章还有更多内容！

**例子如下** ![](https://blog.strapi.io/content/images/2019/11/Capture-d-e-cran-2019-11-13-a--16.51.46.png)

**棒极了！** 现在，你可能想通过 API 真正地获取到文章！

* 访问 [http://localhost:1337/articles](http://localhost:1337/articles)

这是不是很棒！你还可以使用 [GraphQL Playground](http://localhost:1337/graphql) 尝试获取文章

![](https://blog.strapi.io/content/images/2019/11/Capture-d-e-cran-2019-11-06-a--16.30.06.png)

#### 创建分类

你可能想为文章设置一个分类（新闻、趋势、看法）。你将通过在 strapi 中创建另一种内容类型来做到这一点。

* 创建一个具有如下字段的 `category` 内容类型
    * `name`：**String** 类型

**点击保存!**

* 在 **Article** 内容类型中创建 **Relation** 的**新字段**，如下图所示，`一个分类下有很多文章`。

![](https://blog.strapi.io/content/images/2019/11/Capture-d-e-cran-2019-11-13-a--16.43.33.png)

* 点击 [Roles & Permission](http://localhost:1337/admin/plugins/users-permissions/roles) 并点击 `public`。 选择分类的 `find` 和 `findone` 选项并保存。

现在，你可以在右侧的边栏中为文章选择一个类别。


![](https://blog.strapi.io/content/images/2019/11/Capture-d-e-cran-2019-11-13-a--16.51.46-1.png)

现在我们已经熟悉了 Strapi，让我们开始前端的部分吧！

#### 为应用创建布局

Nuxt 将默认的布局存储在 `layouts/default.vue` 文件中。让我们将其修改为我们自己的！

```html
<template>  
  <div>

    <nav class="uk-navbar-container" uk-navbar>
        <div class="uk-navbar-left">

          <ul class="uk-navbar-nav">
              <li><a href="#modal-full" uk-toggle><span uk-icon="icon: table"></span></a></li>
              <li>
                <a href="/">Strapi Blog
                </a>
              </li>
          </ul>

        </div>

        <div class="uk-navbar-right">
          <ul class="uk-navbar-nav">
              <!-- <li v-for="category in categories">
                <router-link :to="{ name: 'categories-id', params: { id: category.id }}" tag="a">{{ category.name }}
                </router-link>
              </li> -->
          </ul>
        </div>
    </nav>

    <div id="modal-full" class="uk-modal-full" uk-modal>
        <div class="uk-modal-dialog">
            <button class="uk-modal-close-full uk-close-large" type="button" uk-close></button>
            <div class="uk-grid-collapse uk-child-width-1-2@s uk-flex-middle" uk-grid>
                <div class="uk-background-cover" style="background-image: url('https://images.unsplash.com/photo-1493612276216-ee3925520721?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=3308&q=80 3308w');" uk-height-viewport></div>
                <div class="uk-padding-large">
                    <h1 style="font-family: Staatliches;">Strapi blog</h1>
                    <div class="uk-width-1-2@s">
                        <ul class="uk-nav-primary uk-nav-parent-icon" uk-nav>
                          <!-- <li v-for="category in categories">
                            <router-link class="uk-modal-close" :to="{ name: 'categories-id', params: { id: category.id }}" tag="a">{{ category.name }}
                            </router-link>
                          </li> -->
                        </ul>
                    </div>
                    <p class="uk-text-light">Built with strapi</p>
                </div>
            </div>
        </div>
    </div>

    <nuxt />
  </div>
</template>

<script>

export default {  
}

</script>
```

如你所见，两段代码被注释了。

```html
  <!-- <li v-for="category in categories">
                <router-link :to="{ name: 'categories-id', params: { id: category.id }}" tag="a">{{ category.name }}
                </router-link>
              </li> -->
...

        <!-- <li v-for="category in categories">
                            <router-link class="uk-modal-close" :to="{ name: 'categories-id', params: { id: category.id }}" tag="a">{{ category.name }}
                            </router-link>
                          </li> -->

```

实际上，你希望能够列出导航栏中的每个分类。为此，我们需要使用 Apollo 来获取它们，让我们来编写查询！

* 创建 `apollo/queries/category` 文件夹并在其中创建 `categories.gql` 文件，文件内容如下：

```graphql
query Categories {  
  categories {
    id
    name
  }
}
```

* 取消注释并用下面的代码替换 `default.vue` 文件中 `script` 标签中的内容。

```html
<script>  
import categoriesQuery from '~/apollo/queries/category/categories'

export default {  
  data() {
    return {
      categories: [],
    }
  },
  apollo: {
    categories: {
      prefetch: true,
      query: categoriesQuery
    }
  }
}

</script>  
```

**注意**当前代码不适合展示很多分类，所以你可能会遇到一些 UI 的问题。而且本篇文章应该要简短一些，所以你可以通过懒加载等方式来自己改进代码。

目前，链接不起作用，我们将在教程后面部分进行处理 ;)

### 创建文章组件

这个组件将在不同的页面上显示你所有文章，因此通过一个组件列出它们并不是一个坏主意。

* 创建 `components/Articles.vue` 文件并包含如下内容：

```html
<template>  
  <div>

    <div class="uk-child-width-1-2" uk-grid>
        <div>
          <router-link v-for="article in leftArticles" :to="{ name: 'articles-id', params: {id: article.id} }" class="uk-link-reset">
            <div class="uk-card uk-card-muted">
                 <div v-if="article.image" class="uk-card-media-top">
                     <img :src="'http://localhost:1337' + article.image.url" alt="" height="100">
                 </div>
                 <div class="uk-card-body">
                   <p id="category" v-if="article.category" class="uk-text-uppercase">{{ article.category.name }}</p>
                   <p id="title" class="uk-text-large">{{ article.title }}</p>
                 </div>
             </div>
         </router-link>

        </div>
        <div>
          <div class="uk-child-width-1-2@m uk-grid-match" uk-grid>
            <router-link v-for="article in rightArticles" :to="{ name: 'articles-id', params: {id: article.id} }" class="uk-link-reset">
              <div class="uk-card uk-card-muted">
                   <div v-if="article.image" class="uk-card-media-top">
                       <img :src="'http://localhost:1337/' + article.image.url" alt="" height="100">
                   </div>
                   <div class="uk-card-body">
                     <p id="category" v-if="article.category" class="uk-text-uppercase">{{ article.category.name }}</p>
                     <p id="title" class="uk-text-large">{{ article.title }}</p>
                   </div>
               </div>
             </router-link>
          </div>

        </div>
    </div>

  </div>
</template>

<script>  
import articlesQuery from '~/apollo/queries/article/articles'

export default {  
  props: {
    articles: Array
  },
  computed: {
    leftArticlesCount(){
      return Math.ceil(this.articles.length / 5)
    },
    leftArticles(){
      return this.articles.slice(0, this.leftArticlesCount)
    },
    rightArticles(){
      return this.articles.slice(this.leftArticlesCount, this.articles.length)
    }
  }
}
</script>  
```

如你所见，多亏了 GraphQL 查询，你可以获取文章，让我们来编写它！

* 创建一个 `apollo/queries/article/articles.gql` 文件并包含如下内容：

```graphql
query Articles {  
  articles {
    id
    title
    content
    image {
      url
    }
    category{
      name
    }
  }
}
```

**太棒了！** 现在可以创建你的主页面了。

### 索引页

让我们使用新组件来列出索引页上的每篇文章！

* 更新 `pages/index.vue` 文件中的代码:

```html
<template>  
  <div>

    <div class="uk-section">
      <div class="uk-container uk-container-large">
        <h1>Strapi blog</h1>

        <Articles :articles="articles"></Articles>

      </div>
    </div>

  </div>
</template>

<script>  
import articlesQuery from '~/apollo/queries/article/articles'  
import Articles from '~/components/Articles'

export default {  
  data() {
    return {
      articles: [],
    }
  },
  components: {
    Articles
  },
  apollo: {
    articles: {
      prefetch: true,
      query: articlesQuery,
      variables () {
        return { id: parseInt(this.$route.params.id) }
      }
    }
  }
}
</script>
```

**太棒了！** 现在你可以通过 GraphQL API 真正地获取到文章了！

![](https://blog.strapi.io/content/images/2019/11/Capture-d-e-cran-2019-11-13-a--15.38.17.png)

### 文章页

如果你点击文章，现在是没有任何东西的。让我们一起来创建文章页吧！

* 创建 `pages/articles` 文件夹并在其中创建 `_id.vue` 文件，文件代码如下：

```html
<template>  
  <div>

      <div v-if="article.image" id="banner" class="uk-height-small uk-flex uk-flex-center uk-flex-middle uk-background-cover uk-light uk-padding" :data-src="'http://localhost:1337' + article.image.url" uk-img>
        <h1>{{ article.title }}</h1>
      </div>

      <div class="uk-section">
        <div class="uk-container uk-container-small">
            <div v-if="article.content" id="editor">{{ article.content }}</div>
            <p v-if="article.published_at">{{ moment(article.published_at).format("MMM Do YY") }}</p>
        </div>
      </div>

  </div>
</template>

<script>  
import articleQuery from '~/apollo/queries/article/article'  
var moment = require('moment')

export default {  
  data() {
    return {
      article: {},
      moment: moment,
    }
  },
  apollo: {
    article: {
      prefetch: true,
      query: articleQuery,
      variables () {
        return { id: parseInt(this.$route.params.id) }
      }
    }
  }
}
</script>  
```

这里只需要获取一篇文章，让我们编写查询！

* 创建 `apollo/queries/article/article.gql`，包含如下代码：

```graphql
query Articles($id: ID!) {  
  article(id: $id) {
    id
    title
    content
    image {
      url
    }
    published_at
  }
}

```

![](https://media.giphy.com/media/fwDprKZ2a3dqUwvEtK/giphy.gif)

好了，你可能想用 Markdown 语法来展示博客内容？

* 通过 `yarn add @nuxtjs/markdownit` 安装 `markdownit`。
* 将其添加到 `nuxt.config.js` 文件的模块中，并在下面添加 mardownit 对象的配置：

```js
...
modules: [  
    '@nuxtjs/apollo',
    '@nuxtjs/markdownit'
],
markdownit: {  
    preset: 'default',
    linkify: true,
    breaks: true,
    injected: true
  },
...
```

* 通过替换负责显示内容的代码，来显示 `_id.vue` 文件中的内容。

```html
...
<div v-if="article.content" id="editor" v-html="$md.render(article.content)"></div>  
...
```

![](https://blog.strapi.io/content/images/2019/11/Capture-d-e-cran-2019-11-13-a--16.26.32.png)

### 分类

现在让我们为每个分类创建一个页面!

* 创建 `pages/categories` 文件夹并在其中创建 `_id.vue` 文件，该文件包含如下代码：

```html
<template>  
  <div>

    <client-only>
    <div class="uk-section">
      <div class="uk-container uk-container-large">
        <h1>{{ category.name }}</h1>

        <Articles :articles="category.articles || []"></Articles>

      </div>
    </div>
  </client-only>
  </div>
</template>

<script>  
import articlesQuery from '~/apollo/queries/article/articles-categories'  
import Articles from '~/components/Articles'

export default {  
  data() {
    return {
      category: []
    }
  },
  components: {
    Articles
  },
  apollo: {
    category: {
      prefetch: true,
      query: articlesQuery,
      variables () {
        return { id: parseInt(this.$route.params.id) }
      }
    }
  }
}
</script>  
```

别忘记写查询！

* 创建 `apollo/queries/article/articles-categories` 包含以下内容：

```graphql
query Category($id: ID!){  
  category(id: $id) {
    name
    articles {
         id
      title
      content
      image {
        url
      }
      category {
        id
        name
      }
    }
  }
}
```

![](https://blog.strapi.io/content/images/2019/11/Capture-d-e-cran-2019-11-14-a--10.57.13.png)

**太棒了！** 现在可以通过分类来导航了 :)

### 总结

恭喜，你成功地完成了本教程。希望你喜欢它！

![](http://giphygifs.s3.amazonaws.com/media/b5LTssxCLpvVe/giphy.gif)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
