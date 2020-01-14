> * 原文地址：[Build a blog with Nuxt (Vue.js), Strapi and Apollo](https://strapi.io/blog/build-a-blog-using-nuxt-strapi-and-apollo)
> * 原文作者：[Maxime Castres](https://slack.strapi.io/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/build-a-blog-using-nuxt-strapi-and-apollo.md](https://github.com/xitu/gold-miner/blob/master/TODO1/build-a-blog-using-nuxt-strapi-and-apollo.md)
> * 译者：
> * 校对者：

# Build a blog with Nuxt (Vue.js), Strapi and Apollo

## Introduction

A few weeks ago, I was thinking about my own Internet habit and, more specifically, about what I really like when I chill out reading stuff. Here’s what I usually do: I run a query, and then I just let myself be guided by the most interesting links. I always find myself reading blog posts about someone’s experience that is entirely unrelated to the query I initially typed!

Blogging is excellent to let you share experiences, beliefs, or testimonials. And Strapi is useful at helping you create your blog! So, I am pretty sure that you now understand what this post is about. Let’s learn how to create a blog with your favorite tech: Strapi.

## Goal

If you are familiar with our blog, you should have already learned how to create a blog with [Gatsby](https://strapi.io/blog/building-a-static-website-using-gatsby-and-strapi). But what if you would instead use another language? Let me tell you that I got that covered as today, we are going to learn how to do it with Vue.js.

The goal here is to be able to create a blog website using Strapi as the backend, Nuxt for the frontend, and Apollo for requesting the Strapi API with GraphQL.

The source code is available on GitHub: [https://github.com/strapi/strapi-tutorials/tree/master/tutorials/nuxt-strapi-apollo-blog/](https://github.com/strapi/strapi-tutorials/tree/master/tutorials/nuxt-strapi-apollo-blog/)

## Prerequisites

To follow this tutorial, you'll need to have Strapi and Nuxt installed on your computer, but don't worry, we are going to install these together!

**This tutorial use Strapi v3.0.0-beta.17.5.**

**You need to have node v.12 installed and that's all.**

## Setup

Create a blog-strapi folder and get inside!

* `mkdir blog-strapi && cd blog-strapi`

#### Back-end setup

So that's the easy part, since the beta.9 we have an awesome package [create strapi-app]([https://www.npmjs.com/package/create-strapi-app](https://www.npmjs.com/package/create-strapi-app)) that allows you to create a Strapi project in seconds without needing to install Strapi globally so let's try it out.

(For the tutorial we will use `yarn` as your package manager)

* `yarn create strapi-app backend --quickstart --no-run`.

This single command line will create all you need for your back-end. Make sure to add the `--no-run` flag as it will prevent your app from automatically starting the server because **SPOILER ALERT: we need to install some awesome Strapi plugins.**

Now that you know that we need to install some plugins to enhance your app, let's install one of our most popular. The `graphql` plugin:

* `yarn strapi install graphql`

Once the installation is completed, you can finally start your Strapi server `strapi dev` and create your first Administrator. That's the one that has all the rights in your application, so please make sure to enter a proper password (**password123**) is really not safe...

![](https://blog.strapi.io/content/images/2019/11/Creation-admin.png)

Don't forget that Strapi is running on [http://localhost:1337](http://localhost:1337)

**Nice!** Now that Strapi is ready, you are going to create your Nuxt application.

#### Front-end setup

Well, the easiest part has been completed, let's get our hands dirty developing our blog!

**Nuxt setup**

Create a Nuxt `frontend` server by running the following command:

* `yarn create nuxt-app frontend`

**Note:** The terminal will prompt for some details about your project. As they are not really relevant to our blog, you can ignore them. I strongly advise you to read the documentation, though. So go ahead, enjoy yourself, and press enter all the way!

Again, once the installation is over, you can start your front-end app to make sure everything went ok.

```
cd frontend  
yarn dev
```

As you might want people to read your blog or to make it "cute & pretty" we will use a popular CSS framework for styling: `UiKit` and also `Apollo` to query Strapi with **GraphQL:**

****Dependencies setup****

Make sure you are in the `frontend` folder before running the following commands:

**Apollo setup**

* `yarn add @nuxtjs/apollo graphql`

Modules and Apollo settings must be referenced in `nuxt.config.js`

* Add the following module and the apollo configuration to your `nuxt.config.js`:

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

(No need of the graphql plugin install since we already did it in the backend setup plus it's more consistent this way).

**Uilkit setup**

UIkit is a lightweight and modular front-end framework for developing fast and powerful web interfaces.

* `yarn add uikit`

Now you need to initialize UIkit's Js in your Nuxt application. You are going to do this by creating a plugin.

* Create a `/frontend/plugins/uikit.js` file and copy/paste the following code:

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

As you can see, you are including both UIkit and `main.css` configuration! We just need to create the `main.css` file.

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

**Note:** You don't need to understand what's in this file. It's just some styling ;)

Let's add a beautiful font (Staatliches) to the project!

* Add the following object to your `link` array in your `nuxt.config.js`

```js
link: [  
      { rel: 'stylesheet', href: 'https://fonts.googleapis.com/css?family=Staatliches' }
    ]
```

**Perfect!** Restart your server and be prepared to get impressed by the front page of your application!

![](https://blog.strapi.io/content/images/2019/11/Capture-d-e-cran-2019-11-06-a--15.30.14.png)

#### Designing the data structure

Finally! we are going to structure the data shape of our article by creating an `Article` content type

* Dive in your strapi admin panel and click on the `Content Type Builder` link in the sidebar

![](https://blog.strapi.io/content/images/2019/11/Capture-d-e-cran-2019-11-06-a--15.39.45.png)

* Click on `Add A Content Type` and call it `article`

![](https://blog.strapi.io/content/images/2019/11/Capture-d-e-cran-2019-11-06-a--15.39.53.png)

Now you'll be asked to create all the fields for your content-type:

![](https://blog.strapi.io/content/images/2019/11/Capture-d-e-cran-2019-11-06-a--15.40.02.png)

* Create the following ones:
    * `title` with type **String** (**required**)
    * `content` with type **Rich Text** (**required**)
    * `image` with type **Media** and (**required**)
    * `published_at` with type **Date** (**required**)

**Press Save!** Here you go, your first content type has been created. Now you may want to create your first article, but we have one thing to do before that: **Open the article content type permissions**

* Click on the [Roles & Permission](http://localhost:1337/admin/plugins/users-permissions/roles) and click on the `public` role.
* Check the article `find` and `findone` routes and save

![](https://blog.strapi.io/content/images/2019/11/Capture-d-e-cran-2019-11-06-a--16.00.00.png)

**Awesome!** You should be ready to create your first article right now and fetch it on the GraphQL Playground

* Create your first article and many more!

**Here's an example** ![](https://blog.strapi.io/content/images/2019/11/Capture-d-e-cran-2019-11-13-a--16.51.46.png)

**Great!** Now you may want to reach the moment when you can actually fetch your articles through the API!

* Go to [http://localhost:1337/articles](http://localhost:1337/articles)

Isn't that cool! You can also play with the [GraphQL Playground](http://localhost:1337/graphql)

![](https://blog.strapi.io/content/images/2019/11/Capture-d-e-cran-2019-11-06-a--16.30.06.png)

#### Create categories

You may want to assign a category to your article (news, trends, opinion). You are going to do this by creating another content type in strapi.

* Create a `category` content type with the following fields
    * `name` with type **String**

**Press save!**

* Create a **new field** in the **Article** content type which is a **Relation** `Category has many Articles` like below

![](https://blog.strapi.io/content/images/2019/11/Capture-d-e-cran-2019-11-13-a--16.43.33.png)

* Click on the [Roles & Permission](http://localhost:1337/admin/plugins/users-permissions/roles) and click on the `public` role. And check the category `find` and `findone` routes and save

Now you'll be able to select a category for your article in the right sidebox.

![](https://blog.strapi.io/content/images/2019/11/Capture-d-e-cran-2019-11-13-a--16.51.46-1.png)

Now that we are good with Strapi, let's work on the frontend part!

#### Create the layout of the application

Nuxt stores the default layout of the application in the `layouts/default.vue` file. Let's modify it to have your own!

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

As you can see, two code blocks are commented on.

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

In fact, you want to be able to list every category in your navbar. To do this, we need to fetch them with Apollo, let's write the query!

* Create a `apollo/queries/category` folder and a `categories.gql` file inside with the following code:

```graphql
query Categories {  
  categories {
    id
    name
  }
}
```

* Uncomment the comments and replace the `script` tag in your `default.vue` file by the following code

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

**Note** The current code is not suited to display a lot of categories as you may encounter a UI issue. Since this blog post is supposed to be short, I will let you improve the code to maybe add a lazy load or something.

For now, the links are not working, you'll work on it later on the tutorial ;)

### Create the Articles component

This component will display all your articles on different pages, so listing them through a component is not a bad idea.

* Create a `components/Articles.vue` file containing the following:

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

As you can see, you are fetching articles thanks to a GraphQl query, let's write it!

* Create a `apollo/queries/article/articles.gql` file containing the following:

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

**Awesome!** Now you can create your main page

### Index page

You want to list every article on your index page, let's use our new component!

* Update the code in your `pages/index.vue` file with:

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

**Great!** You have now reached the moment when you can actually fetch your articles through the GraphQL API!

![](https://blog.strapi.io/content/images/2019/11/Capture-d-e-cran-2019-11-13-a--15.38.17.png)

### Article page

You can see that if you click on the article, there is nothing. Let's create the article page together!

* Create a `pages/articles` folder and a `_id.vue` file inside containing the following:

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

Here you are fetching just one article, let's write the query behind!

* Create a `apollo/queries/article/article.gql` containing the following:

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

Alright, you may want to display your content as Markdown?

* Install `markdownit` with `yarn add @nuxtjs/markdownit`
* Add it to your modules inside your `nuxt.config.js` file and add the mardownit object configuration just under

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

* Use it to display your content inside your `_id.vue` file by replacing the line responsible for displaying the content.

```html
...
<div v-if="article.content" id="editor" v-html="$md.render(article.content)"></div>  
...
```

![](https://blog.strapi.io/content/images/2019/11/Capture-d-e-cran-2019-11-13-a--16.26.32.png)

### Categories

Let's create a page for each category now!

* Create a `pages/categories` folder and a `_id.vue` file inside containing the following:

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

And don't forget the query!

* Create a `apollo/queries/article/articles-categories` containing the following:

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

**Awesome!** You can now navigate through categories :)

### Conclusion

Huge congrats, you successfully achieved this tutorial. I hope you enjoyed it!

![](http://giphygifs.s3.amazonaws.com/media/b5LTssxCLpvVe/giphy.gif)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
