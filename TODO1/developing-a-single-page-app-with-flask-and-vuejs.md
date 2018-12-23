> * 原文地址：[Developing a Single Page App with Flask and Vue.js](https://testdriven.io/developing-a-single-page-app-with-flask-and-vuejs)
> * 原文作者：[Michael Herman](https://testdriven.io/authors/herman)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/developing-a-single-page-app-with-flask-and-vuejs.md](https://github.com/xitu/gold-miner/blob/master/TODO1/developing-a-single-page-app-with-flask-and-vuejs.md)
> * 译者：[Mcskiller](https://github.com/Mcskiller)

# 用 Flask 和 Vue.js 开发一个单页面应用

![](https://testdriven.io/assets/img/blog/flask-vue/developing_spa_flask_vue.png)

这篇文章会一步一步的教会你如何用 VUE 和 Flask 创建一个基础的 CRUD 应用。我们将从使用 Vue CLI 创建一个新的 Vue 应用开始，接着我们会使用 Python 和 Flask 提供的后端接口 RESTful API 执行基础的 CRUD 操作。

**最终效果：**

![final app](https://testdriven.io/assets/img/blog/flask-vue/final.gif)

**主要依赖：**

*   Vue v2.5.2
*   Vue CLI v2.9.3
*   Node v10.3.0
*   npm v6.1.0
*   Flask v1.0.2
*   Python v3.6.5
    
## 目录

*   [目的](#目的)
*   [什么是 Flask？](#什么是-Flask？)
*   [什么是 Vue？](#什么是-Vue？)
*   [安装 Flask](#安装-Flask)
*   [安装 Vue](#安装-Vue)
*   [安装 Bootstrap](#安装-Bootstrap)
*   [我们的目的是什么？](#我们的目的是什么？)
*   [获取路由](#获取路由)
*   [Bootstrap Vue](#Bootstrap-Vue)
*   [POST 路由](#POST-路由)
*   [Alert 组件](#Alert-组件)
*   [PUT 路由](#PUT-路由)
*   [DELETE 路由](#DELETE-路由)
*   [总结](#总结)

## 目的

在本教程结束的时候，你能够...

1.  解释什么是 Flask
2.  解释什么是 Vue 并且它和其他 UI 库以及 Angular、React 等前端框架相比又如何
3.  使用 Vue CLI 搭建一个 Vue 项目
4.  在浏览器中创建并渲染 Vue 组件
5.  使用 Vue 组件创建一个单页面应用（SPA）
6.  将一个 Vue 应用与后端的 Flask 连接
7.  使用 Flask 开发一个 RESTful API
8.  在 Vue 组件中使用 Bootstrap 样式
9.  使用 Vue Router 去创建路由和渲染组件

## 什么是 Flask？

[Flask](http://flask.pocoo.org/) 是一个用 Python 编写的简单，但是及其强大的轻量级 Web 框架，非常适合用来构建 RESTful API。就像 [Sinatra](http://sinatrarb.com/)（Ruby）和 [Express](https://expressjs.com/)（Node）一样，它也十分简便，所以你可以从小处开始，根据需求构建一个十分复杂的应用。

第一次使用 Flask？看看这下面两个教程吧：

1.  [Flaskr TDD](https://github.com/mjhea0/flaskr-tdd)
2.  [Flask for Node Developers](http://mherman.org/blog/2017/04/26/flask-for-node-developers)

## 什么是 Vue？

[Vue](https://vuejs.org/) 是一个用于构建用户界面的开源 JavaScript 框架。它综合了一些 React 和 Angular 的优点。也就是说，与 React 和 Angular 相比，它更加友好，所以初学者额能够很快的学习并掌握。它也同样强大，因此它能够提供所有你需要用来创建一个前端应用所需要的功能。

有关 Vue 的更多信息，以及使用它与 Angular 和 React 的利弊，请查看以下文章：

1.  [Vue: Comparison with Other Frameworks](https://vuejs.org/v2/guide/comparison.html)
2.  [Angular vs. React vs. Vue: A 2017 comparison](https://medium.com/unicorn-supplies/angular-vs-react-vs-vue-a-2017-comparison-c5c52d620176)

第一次使用 Vue？不妨花点时间阅读官方指南中的 [介绍](https://vuejs.org/v2/guide/index.html)。

## 安装 Flask

首先创建一个新项目文件夹：

```
$ mkdir flask-vue-crud
$ cd flask-vue-crud
```

在 “flask-vue-crud” 文件夹中，创建一个新文件夹并取名为 “server”。然后，在 “server” 文件夹中创建并运行一个虚拟环境：

```
$ python3.6 -m venv env
$ source env/bin/activate
```

> 以上命令因环境而异。

安装 Flask 和 [Flask-CORS](http://flask-cors.readthedocs.io/en/3.0.4/) 扩展：

```
(env)$ pip install Flask==1.0.2 Flask-Cors==3.0.4
```

在新创建的文件夹中添加一个 **app.py** 文件

```
from flask import Flask, jsonify
from flask_cors import CORS


# configuration
DEBUG = True

# instantiate the app
app = Flask(__name__)
app.config.from_object(__name__)

# enable CORS
CORS(app)


# sanity check route
@app.route('/ping', methods=['GET'])
def ping_pong():
    return jsonify('pong!')


if __name__ == '__main__':
    app.run()
```

为什么我们需要 Flask-CORS？为了进行跨域请求 — e.g.，来自不同协议，IP 地址，域名或端口的请求 — 你需要允许 [跨域资源共享](https://en.wikipedia.org/wiki/Cross-origin_resource_sharing)（CORS）。而这正是 Flask-CORS 能为我们提供的。

> 值得注意的是上述安装允许跨域请求在全部路由无论**任何**域，协议或者端口都可用。在生产环境中，你应该**只**允许跨域请求成功在前端应用托管的域上。参考 [Flask-CORS 文档](http://flask-cors.readthedocs.io/) 获得更多信息。

运行应用：

```
(env)$ python app.py
```

开始测试，将你的浏览器指向到 [http://localhost:5000/ping](http://localhost:5000/ping)。你将会看到：

```
"pong!"
```

返回终端，按下 Ctrl+C 来终止服务端然后退回到项目根目录。接下来，让我们把注意力转到前端进行 Vue 的安装。

## 安装 Vue

我们将会使用强力的 [Vue CLI](https://github.com/vuejs/vue-cli) 来生成一个自定义项目模板。

全局安装：

```
$ npm install -g vue-cli@2.9.3
```

> 第一次使用 npm？浏览一下 [什么是 npm?](https://docs.npmjs.com/getting-started/what-is-npm) 官方指南吧

然后，在 “flask-vue-crud” 中，运行以下命令初始化一个叫做 `client` 的新 Vue 项目并包含 [webpack](https://github.com/vuejs-templates/webpack) 配置：

```
$ vue init webpack client
```

> webpack 是一个模块打包构建工具，用于构建，压缩以及打包 JavaScript 文件和其他客户端资源。

它会请求你对这个项目进行一些配置。按下回车键去选择前三个为默认设置，然后使用以下的设置去完成后续的配置：

1.  Vue build: `Runtime + Compiler`
2.  Install vue-router?: `Yes`
3.  Use ESLint to lint your code?: `Yes`
4.  Pick an ESLint preset: `Airbnb`
5.  Set up unit tests: `No`
6.  Setup e2e tests with Nightwatch: `No`
7.  Should we run npm install for you after the project has been created: `Yes, use NPM`

你会看到一些配置请求比如：

```
? Project name client
? Project description A Vue.js project
? Author Michael Herman michael@mherman.org
? Vue build standalone
? Install vue-router? Yes
? Use ESLint to lint your code? Yes
? Pick an ESLint preset Airbnb
? Set up unit tests No
? Setup e2e tests with Nightwatch? No
? Should we run `npm install` for you after the project has been created? (recommended) npm
```

快速浏览一下生成的项目架构。看起来好像特别多，但是我们**只**会用到那些在 “src” 中的文件和 **index.html** 文件。

**index.html** 文件是我们 Vue 应用的起点。

```
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>client</title>
  </head>
  <body>
    <div id="app"></div>
    <!-- built files will be auto injected -->
  </body>
</html>
```

注意那个 `id` 是 `app` 的 `<div>` 元素。那是一个占位符，Vue 将会用来连接生成的 HTML 和 CSS 构建 UI。

注意那些在 “src” 文件夹中的文件夹：

```
├── App.vue
├── assets
│   └── logo.png
├── components
│   └── HelloWorld.vue
├── main.js
└── router
    └── index.js
```

分解：

| 名字 | 作用 |
| ---- | ------- |
| _main.js_ | app 接入点，将会和根组件一起加载并初始化 Vue |
| _App.vue_ | 根组件 —— 起点，所有其他组件都将从此处开始渲染 |
| “assets” | 储存图像和字体等静态资源 |
| “components” | 储存 UI 组件 |
| “router” | 定义 URL 地址并映射到组件 |

查看 **client/src/components/HelloWorld.vue** 文件。这是一个 [单文件组件](https://vuejs.org/v2/guide/single-file-components.html)，它分为三个不同的部分：

1.  **template**：特定组件的 HTML
2.  **script**：通过 JavaScript 实现组件逻辑
3.  **style**：CSS 样式

运行开发服务端：

```
$ cd client
$ npm run dev
```

在你的浏览器中导航到 [http://localhost:8080](http://localhost:8080)。你将会看到：

![default vue app](https://testdriven.io/assets/img/blog/flask-vue/default-vue-app.png)

添加一个新组件在 “client/src/components” 文件夹中，并取名为 **Ping.vue**：

```
<template>
  <div>
    <p>{{ msg }}</p>
  </div>
</template>

<script>
export default {
  name: 'Ping',
  data() {
    return {
      msg: 'Hello!',
    };
  },
};
</script>
```

更新 **client/src/router/index.js** 使 ‘/’ 映射到 `Ping` 组件：

```
import Vue from 'vue';
import Router from 'vue-router';
import Ping from '@/components/Ping';

Vue.use(Router);

export default new Router({
  routes: [
    {
      path: '/',
      name: 'Ping',
      component: Ping,
    },
  ],
});
```

最后，在 **client/src/App.vue** 中，从 template 里删除掉图片：

```
<template>
  <div id="app">
    <router-view/>
  </div>
</template>
```

你现在应该能在浏览器中看见一个 `Hello!`。

为了更好地使客户端 Vue 应用和后端 Flask 应用连接，我们可以使用 [axios](https://github.com/axios/axios) 库来发送 AJAX 请求。

那么我们开始安装它：

```
$ npm install axios@0.18.0 --save
```

然后在 **Ping.vue** 中更新组件的 `script` 部分，就像这样：

```
<script>
import axios from 'axios';

export default {
  name: 'Ping',
  data() {
    return {
      msg: '',
    };
  },
  methods: {
    getMessage() {
      const path = 'http://localhost:5000/ping';
      axios.get(path)
        .then((res) => {
          this.msg = res.data;
        })
        .catch((error) => {
          // eslint-disable-next-line
          console.error(error);
        });
    },
  },
  created() {
    this.getMessage();
  },
};
</script>
```

在新的终端窗口启动 Flask 应用。在浏览器中打开 [http://localhost:8080](http://localhost:8080) 你会看到 `pong!`。基本上，当我们从后端得到回复的时候，我们会将 `msg` 设置为响应对象的 `data` 的值。

## 安装 Bootstrap

接下来，让我们引入一个热门 CSS 框架 Bootstrap 到应用中以方便我们快速添加一些样式。

安装：

```
$ npm install bootstrap@4.1.1 --save
```

> 忽略 `jquery` 和 `popper.js` 的警告。不要把它们添加到你的项目中。稍后会告诉你为什么。

插入 Bootstrap 样式到 **client/src/main.js** 中：

```
import 'bootstrap/dist/css/bootstrap.css';
import Vue from 'vue';
import App from './App';
import router from './router';

Vue.config.productionTip = false;

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  components: { App },
  template: '<App/>',
});
```

更新 **client/src/App.vue** 中的 `style`：

```
<style>
#app {
  margin-top: 60px
}
</style>
```

通过使用 [Button](https://getbootstrap.com/docs/4.0/components/buttons/) 和 [Container](https://getbootstrap.com/docs/4.0/layout/overview/#containers) 确保 Bootstrap 在 `Ping` 组件中正确连接：

```
<template>
  <div class="container">
    <button type="button" class="btn btn-primary">{{ msg }}</button>
  </div>
</template>
```

运行开发服务端：

```
$ npm run dev
```

你应该会看到：

![vue with bootstrap](https://testdriven.io/assets/img/blog/flask-vue/bootstrap.png)

然后，添加一个叫做 `Books` 的新组件到新文件 **Books.vue** 中：

    <template>
      <div class="container">
        <p>books</p>
      </div>
    </template>
    

更新路由：

```
import Vue from 'vue';
import Router from 'vue-router';
import Ping from '@/components/Ping';
import Books from '@/components/Books';

Vue.use(Router);

export default new Router({
  routes: [
    {
      path: '/',
      name: 'Books',
      component: Books,
    },
    {
      path: '/ping',
      name: 'Ping',
      component: Ping,
    },
  ],
  mode: 'hash',
});
```

测试：

1.  [http://localhost:8080](http://localhost:8080)
2.  [http://localhost:8080/#/ping](http://localhost:8080/#/ping)

> 想要摆脱掉 URL 中的哈希值吗？更改 `mode` 到 `history` 以使用浏览器的 [history API](https://developer.mozilla.org/en-US/docs/Web/API/History_API) 来导航：

```
export default new Router({
  routes: [
    {
      path: '/',
      name: 'Books',
      component: Books,
    },
    {
      path: '/ping',
      name: 'Ping',
      component: Ping,
    },
  ],
  mode: 'history',
});
```

> 查看文档以获得更多路由 [信息](https://router.vuejs.org/guide/essentials/history-mode.html)。

最后，让我们添加一个高效的 Bootstrap 风格表格到 `Books` 组件中：

```
<template>
  <div class="container">
    <div class="row">
      <div class="col-sm-10">
        <h1>Books</h1>
        <hr><br><br>
        <button type="button" class="btn btn-success btn-sm">Add Book</button>
        <br><br>
        <table class="table table-hover">
          <thead>
            <tr>
              <th scope="col">Title</th>
              <th scope="col">Author</th>
              <th scope="col">Read?</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>foo</td>
              <td>bar</td>
              <td>foobar</td>
              <td>
                <button type="button" class="btn btn-warning btn-sm">Update</button>
                <button type="button" class="btn btn-danger btn-sm">Delete</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>
```

你现在应该会看到：

![books component](https://testdriven.io/assets/img/blog/flask-vue/books-component-1.png)

现在我们可以开始构建我们的 CRUD 应用的功能。

## 我们的目的是什么？

我们的目标是设计一个后端 RESTful API，由 Python 和 Flask 驱动，对应一个单一资源 — books。这个 API 应当遵守 RESTful 设计原则，使用基本的 HTTP 动词：GET、POST、PUT 和 DELETE。

我们还会使用 Vue 搭建一个前端应用来使用这个后端 API：

![final app](https://testdriven.io/assets/img/blog/flask-vue/final.gif)

> 本教程只设计简单步骤。处理错误是读者（就是你！）的额外练习。通过你的理解解决前后端出现的问题吧。

## 获取路由

### 服务端

添加一个书单到 **server/app.py** 中：

```
BOOKS = [
    {
        'title': 'On the Road',
        'author': 'Jack Kerouac',
        'read': True
    },
    {
        'title': 'Harry Potter and the Philosopher\'s Stone',
        'author': 'J. K. Rowling',
        'read': False
    },
    {
        'title': 'Green Eggs and Ham',
        'author': 'Dr. Seuss',
        'read': True
    }
]
```

添加路由接口：

```
@app.route('/books', methods=['GET'])
def all_books():
    return jsonify({
        'status': 'success',
        'books': BOOKS
    })
```

运行 Flask 应用，如果它并没有运行，尝试在 [http://localhost:5000/books](http://localhost:5000/books) 手动测试路由。

> 想更有挑战性？写一个自动化测试吧。查看 [这个](https://github.com/mjhea0/flaskr-tdd) 资源可以了解更多关于测试 Flask 应用的信息。

### 客户端

更新组件：

```
<template>
  <div class="container">
    <div class="row">
      <div class="col-sm-10">
        <h1>Books</h1>
        <hr><br><br>
        <button type="button" class="btn btn-success btn-sm">Add Book</button>
        <br><br>
        <table class="table table-hover">
          <thead>
            <tr>
              <th scope="col">Title</th>
              <th scope="col">Author</th>
              <th scope="col">Read?</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(book, index) in books" :key="index">
              <td>{{ book.title }}</td>
              <td>{{ book.author }}</td>
              <td>
                <span v-if="book.read">Yes</span>
                <span v-else>No</span>
              </td>
              <td>
                <button type="button" class="btn btn-warning btn-sm">Update</button>
                <button type="button" class="btn btn-danger btn-sm">Delete</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      books: [],
    };
  },
  methods: {
    getBooks() {
      const path = 'http://localhost:5000/books';
      axios.get(path)
        .then((res) => {
          this.books = res.data.books;
        })
        .catch((error) => {
          // eslint-disable-next-line
          console.error(error);
        });
    },
  },
  created() {
    this.getBooks();
  },
};
</script>
```

当组件初始化完成后，通过 [created](https://vuejs.org/v2/api/#created) 生命周期钩子调用 `getBooks()` 方法，它从我们刚刚设置的后端接口获取书籍。

> 查阅 [实例生命周期钩子](https://vuejs.org/v2/guide/instance.html#Instance-Lifecycle-Hooks) 了解更多有关组件生命周期和可用方法的信息。

在模板中，我们通过 [v-for](https://vuejs.org/v2/guide/list.html) 指令遍历书籍列表，每次遍历创建一个新表格行。索引值用作 [key](https://vuejs.org/v2/guide/list.html#key)。最后，使用 [v-if](https://vuejs.org/v2/guide/conditional.html#v-if) 的 `Yes` 或 `No`，来表现用户已读或未读这本书。

![books component](https://testdriven.io/assets/img/blog/flask-vue/books-component-2.png)

## Bootstrap Vue

在下一节中，我们将会使用一个模态去添加新书。为此，我们在本节会加入 [Bootstrap Vue](https://bootstrap-vue.js.org/) 库到项目中，它提供了一组基于 Bootstrap 的 HTML 和 CSS 设计的 Vue 组件。

> 为什么选择 Bootstrap Vue？Bootstrap 的 [模态](http://getbootstrap.com/docs/4.1/components/modal/) 组件使用 [jQuery](https://jquery.com/)，但你应该避免把它和 Vue 在同一项目中一起使用，因为 Vue 使用 [虚拟 DOM](https://vuejs.org/v2/guide/render-function.html#Nodes-Trees-and-the-Virtual-DOM) 来更新 DOM。换句话来说，如果你用 jQuery 来操作 DOM，Vue 不会有任何反应。至少，如果你一定要使用 jQuery，不要在同一个 DOM 元素上同时使用 jQuery 和 Vue。

安装：

```
$ npm install bootstrap-vue@2.0.0-rc.11 --save
```

在 **client/src/main.js** 中启用 Bootstrap Vue 库：

```
import 'bootstrap/dist/css/bootstrap.css';
import BootstrapVue from 'bootstrap-vue';
import Vue from 'vue';
import App from './App';
import router from './router';

Vue.config.productionTip = false;

Vue.use(BootstrapVue);

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  components: { App },
  template: '<App/>',
});
```

## POST 路由

### 服务端

更新现有路由以处理添加新书的 POST 请求：

```
@app.route('/books', methods=['GET', 'POST'])
def all_books():
    response_object = {'status': 'success'}
    if request.method == 'POST':
        post_data = request.get_json()
        BOOKS.append({
            'title': post_data.get('title'),
            'author': post_data.get('author'),
            'read': post_data.get('read')
        })
        response_object['message'] = 'Book added!'
    else:
        response_object['books'] = BOOKS
    return jsonify(response_object)
```

更新 imports：

```
from flask import Flask, jsonify, request
```

运行 Flask 服务端后，你可以在新的终端里测试 POST 路由：

```
$ curl -X POST http://localhost:5000/books -d \
  '{"title": "1Q84", "author": "Haruki Murakami", "read": "true"}' \
  -H 'Content-Type: application/json'
```

你应该会看到：

```
{
  "message": "Book added!",
  "status": "success"
}
```

你应该会在 [http://localhost:5000/books](http://localhost:5000/books) 的末尾看到新书。

> 如果书名已经存在了呢？如果一个书名对应了几个作者呢？通过处理这些小问题可以加深你的理解，另外，如何处理 `书名`，`作者`，以及 `阅览状态` 都缺失的无效负载情况。

### 客户端

在客户端上，让我们添加那个模态以添加一本新书，从 HTML 开始：

```
<b-modal ref="addBookModal"
         id="book-modal"
         title="Add a new book"
         hide-footer>
  <b-form @submit="onSubmit" @reset="onReset" class="w-100">
  <b-form-group id="form-title-group"
                label="Title:"
                label-for="form-title-input">
      <b-form-input id="form-title-input"
                    type="text"
                    v-model="addBookForm.title"
                    required
                    placeholder="Enter title">
      </b-form-input>
    </b-form-group>
    <b-form-group id="form-author-group"
                  label="Author:"
                  label-for="form-author-input">
        <b-form-input id="form-author-input"
                      type="text"
                      v-model="addBookForm.author"
                      required
                      placeholder="Enter author">
        </b-form-input>
      </b-form-group>
    <b-form-group id="form-read-group">
      <b-form-checkbox-group v-model="addBookForm.read" id="form-checks">
        <b-form-checkbox value="true">Read?</b-form-checkbox>
      </b-form-checkbox-group>
    </b-form-group>
    <b-button type="submit" variant="primary">Submit</b-button>
    <b-button type="reset" variant="danger">Reset</b-button>
  </b-form>
</b-modal>
```

在 `div` 标签中添加这段代码。然后简单阅览一下。`v-model` 是一个用于 [表单输入绑定](https://vuejs.org/v2/guide/forms.html) 的指令。你马上就会看到。

> `hide-footer` 具体干了什么？在 Bootstrap Vue 的 [文档](https://bootstrap-vue.js.org/docs/components/modal/) 中了解更多

更新 `script` 部分：

```
<script>
import axios from 'axios';

export default {
  data() {
    return {
      books: [],
      addBookForm: {
        title: '',
        author: '',
        read: [],
      },
    };
  },
  methods: {
    getBooks() {
      const path = 'http://localhost:5000/books';
      axios.get(path)
        .then((res) => {
          this.books = res.data.books;
        })
        .catch((error) => {
          // eslint-disable-next-line
          console.error(error);
        });
    },
    addBook(payload) {
      const path = 'http://localhost:5000/books';
      axios.post(path, payload)
        .then(() => {
          this.getBooks();
        })
        .catch((error) => {
          // eslint-disable-next-line
          console.log(error);
          this.getBooks();
        });
    },
    initForm() {
      this.addBookForm.title = '';
      this.addBookForm.author = '';
      this.addBookForm.read = [];
    },
    onSubmit(evt) {
      evt.preventDefault();
      this.$refs.addBookModal.hide();
      let read = false;
      if (this.addBookForm.read[0]) read = true;
      const payload = {
        title: this.addBookForm.title,
        author: this.addBookForm.author,
        read, // property shorthand
      };
      this.addBook(payload);
      this.initForm();
    },
    onReset(evt) {
      evt.preventDefault();
      this.$refs.addBookModal.hide();
      this.initForm();
    },
  },
  created() {
    this.getBooks();
  },
};
</script>
```

实现了什么？

1. `addBookForm` 的值被 [表单输入绑定](https://vuejs.org/v2/guide/forms.html#Basic-Usage) 到，没错，`v-model`。当数据更新时，另一个也会跟着更新。这被称之为双向绑定。花点时间从 [这里](https://stackoverflow.com/questions/13504906/what-is-two-way-binding) 了解一下吧。想想这个带来的结果。你认为这会使状态管理更简单还是更复杂？React 和 Angular 又会如何做到这点？在我看来，双向数据绑定（可变性）使得 Vue 和 React 相比更加友好，但是从长远看扩展性不足。

2.  `onSubmit` 会在用户提交表单成功时被触发。在提交时，我们会阻止浏览器的正常行为（`evt.preventDefault()`），关闭模态框（`this.$refs.addBookModal.hide()`），触发 `addBook` 方法，然后清空表单（`initForm()`）。

3.  `addBook` 发送一个 POST 请求到 `/books` 去添加一本新书。

4.  根据自己的需要查看其他更改，并根据需要参考 Vue 的 [文档](https://vuejs.org/v2/guide/)。

> 你能想到客户端或者服务端还有什么潜在的问题吗？思考这些问题去试着加强用户体验吧。

最后，更新 template 中的 “Add Book” 按钮，这样一来我们点击按钮就会显示出模态框：

```
<button type="button" class="btn btn-success btn-sm" v-b-modal.book-modal>Add Book</button>
```

那么组件应该是这样子的：

    <template>
      <div class="container">
        <div class="row">
          <div class="col-sm-10">
            <h1>Books</h1>
            <hr><br><br>
            <button type="button" class="btn btn-success btn-sm" v-b-modal.book-modal>Add Book</button>
            <br><br>
            <table class="table table-hover">
              <thead>
                <tr>
                  <th scope="col">Title</th>
                  <th scope="col">Author</th>
                  <th scope="col">Read?</th>
                  <th></th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(book, index) in books" :key="index">
                  <td></td>
                  <td></td>
                  <td>
                    <span v-if="book.read">Yes</span>
                    <span v-else>No</span>
                  </td>
                  <td>
                    <button type="button" class="btn btn-warning btn-sm">Update</button>
                    <button type="button" class="btn btn-danger btn-sm">Delete</button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
        <b-modal ref="addBookModal"
                 id="book-modal"
                 title="Add a new book"
                 hide-footer>
          <b-form @submit="onSubmit" @reset="onReset" class="w-100">
          <b-form-group id="form-title-group"
                        label="Title:"
                        label-for="form-title-input">
              <b-form-input id="form-title-input"
                            type="text"
                            v-model="addBookForm.title"
                            required
                            placeholder="Enter title">
              </b-form-input>
            </b-form-group>
            <b-form-group id="form-author-group"
                          label="Author:"
                          label-for="form-author-input">
                <b-form-input id="form-author-input"
                              type="text"
                              v-model="addBookForm.author"
                              required
                              placeholder="Enter author">
                </b-form-input>
              </b-form-group>
            <b-form-group id="form-read-group">
              <b-form-checkbox-group v-model="addBookForm.read" id="form-checks">
                <b-form-checkbox value="true">Read?</b-form-checkbox>
              </b-form-checkbox-group>
            </b-form-group>
            <b-button type="submit" variant="primary">Submit</b-button>
            <b-button type="reset" variant="danger">Reset</b-button>
          </b-form>
        </b-modal>
      </div>
    </template>
    
    <script>
    import axios from 'axios';
    
    export default {
      data() {
        return {
          books: [],
          addBookForm: {
            title: '',
            author: '',
            read: [],
          },
        };
      },
      methods: {
        getBooks() {
          const path = 'http://localhost:5000/books';
          axios.get(path)
            .then((res) => {
              this.books = res.data.books;
            })
            .catch((error) => {
              // eslint-disable-next-line
              console.error(error);
            });
        },
        addBook(payload) {
          const path = 'http://localhost:5000/books';
          axios.post(path, payload)
            .then(() => {
              this.getBooks();
            })
            .catch((error) => {
              // eslint-disable-next-line
              console.log(error);
              this.getBooks();
            });
        },
        initForm() {
          this.addBookForm.title = '';
          this.addBookForm.author = '';
          this.addBookForm.read = [];
        },
        onSubmit(evt) {
          evt.preventDefault();
          this.$refs.addBookModal.hide();
          let read = false;
          if (this.addBookForm.read[0]) read = true;
          const payload = {
            title: this.addBookForm.title,
            author: this.addBookForm.author,
            read, // property shorthand
          };
          this.addBook(payload);
          this.initForm();
        },
        onReset(evt) {
          evt.preventDefault();
          this.$refs.addBookModal.hide();
          this.initForm();
        },
      },
      created() {
        this.getBooks();
      },
    };
    </script>
    

赶紧测试一下！试着添加一本书：

![add new book](https://testdriven.io/assets/img/blog/flask-vue/add-new-book.gif)

## alert 组件

接下来，让我们添加一个 [Alert](https://bootstrap-vue.js.org/docs/components/alert/) 组件，当添加一本新书后，它会显示一个信息给当前用户。我们将为此创建一个新组件，因为你以后可能会在很多组件中经常用到这个功能。

添加一个新文件 **Alert.vue** 到 “client/src/components” 中：

```
<template>
  <p>It works!</p>
</template>
```

然后，在 `Books` 组件的 `script` 中引入它并注册这个组件：

```
<script>
import axios from 'axios';
import Alert from './Alert';

...

export default {
  data() {
    return {
      books: [],
      addBookForm: {
        title: '',
        author: '',
        read: [],
      },
    };
  },
  components: {
    alert: Alert,
  },

  ...

};
</script>
```

现在，我们可以在 `template` 中引用这个新组件：

```
<template>
  <b-container>
    <b-row>
      <b-col col sm="10">
        <h1>Books</h1>
        <hr><br><br>
        <alert></alert>
        <button type="button" class="btn btn-success btn-sm" v-b-modal.book-modal>Add Book</button>

        ...

      </b-col>
    </b-row>
  </b-container>
</template>
```

刷新浏览器，你会看到：

![bootstrap alert](https://testdriven.io/assets/img/blog/flask-vue/alert.png)

> 从 Vue 官方文档的 [组件化应用构建](https://vuejs.org/v2/guide/index.html#Composing-with-Components) 中获得更多有关组件化应用构建的信息。

接下来，让我们加入 [b-alert](https://bootstrap-vue.js.org/docs/components/alert/) 组件到 template 中：

```
<template>
  <div>
    <b-alert variant="success" show>{{ message }}</b-alert>
    <br>
  </div>
</template>

<script>
export default {
  props: ['message'],
};
</script>
```

记住 `script` 中的 [props](https://vuejs.org/v2/guide/components-props.html) 选项。我们可以从父组件（`Books`）传递信息，就像这样：

```
<alert message="hi"></alert>
```

试试这个：

![bootstrap alert](https://testdriven.io/assets/img/blog/flask-vue/alert-2.png)

> 从 [文档](https://vuejs.org/v2/guide/components.html#Passing-Data-to-Child-Components-with-Props) 中获取更多 props 相关信息。

为了方便我们动态传递自定义消息，我们需要在 **Books.vue** 中使用 [bind](https://vuejs.org/v2/guide/syntax.html#v-bind-Shorthand) 绑定数据。

```
<alert :message="message"></alert>
```

将 `message` 添加到 **Books.vue** 中的 `data` 中：

```
data() {
  return {
    books: [],
    addBookForm: {
      title: '',
      author: '',
      read: [],
    },
    message: '',
  };
},
```

接下来，在 `addBook` 中，更新 message 内容。

```
addBook(payload) {
  const path = 'http://localhost:5000/books';
  axios.post(path, payload)
    .then(() => {
      this.getBooks();
      this.message = 'Book added!';
    })
    .catch((error) => {
      // eslint-disable-next-line
      console.log(error);
      this.getBooks();
    });
},
```

最后，添加一个 `v-if`，以保证只有 `showMessage` 值为 true 的时候警告才会显示。

```
<alert :message=message v-if="showMessage"></alert>
```

添加 `showMessage` 到 `data` 中：

```
data() {
  return {
    books: [],
    addBookForm: {
      title: '',
      author: '',
      read: [],
    },
    message: '',
    showMessage: false,
  };
},
```

再次更新 `addBook`，设定 `showMessage` 的值为 `true`：

```
addBook(payload) {
  const path = 'http://localhost:5000/books';
  axios.post(path, payload)
    .then(() => {
      this.getBooks();
      this.message = 'Book added!';
      this.showMessage = true;
    })
    .catch((error) => {
      // eslint-disable-next-line
      console.log(error);
      this.getBooks();
    });
},
```

赶快测试一下吧！

![add new book](https://testdriven.io/assets/img/blog/flask-vue/add-new-book-2.gif)

> 挑战：
>
> 1.  想想什么情况下 `showMessage` 应该被设定为 `false`。更新你的代码。
> 2.  试着用 Alert 组件去显示错误信息。
> 3.  修改 Alert 为 [可取消](https://bootstrap-vue.js.org/docs/components/alert/#dismissible-alerts) 的样式。

## PUT 路由

### 服务端

对于更新，我们需要使用唯一标识符，因为我们不能依靠标题作为唯一。我们可以使用 Python [基本库](https://docs.python.org/3/library/uuid.html) 提供的 `uuid` 作为唯一。

在 **server/app.py** 中更新 `BOOKS`：

```
BOOKS = [
    {
        'id': uuid.uuid4().hex,
        'title': 'On the Road',
        'author': 'Jack Kerouac',
        'read': True
    },
    {
        'id': uuid.uuid4().hex,
        'title': 'Harry Potter and the Philosopher\'s Stone',
        'author': 'J. K. Rowling',
        'read': False
    },
    {
        'id': uuid.uuid4().hex,
        'title': 'Green Eggs and Ham',
        'author': 'Dr. Seuss',
        'read': True
    }
]
```

不要忘了引入：

```
import uuid
```

我们需要重构 `all_books` 来保证每一本添加的书都有它的唯一 ID：

```
@app.route('/books', methods=['GET', 'POST'])
def all_books():
    response_object = {'status': 'success'}
    if request.method == 'POST':
        post_data = request.get_json()
        BOOKS.append({
            'id': uuid.uuid4().hex,
            'title': post_data.get('title'),
            'author': post_data.get('author'),
            'read': post_data.get('read')
        })
        response_object['message'] = 'Book added!'
    else:
        response_object['books'] = BOOKS
    return jsonify(response_object)
```

添加一个新的路由：

```
@app.route('/books/<book_id>', methods=['PUT'])
def single_book(book_id):
    response_object = {'status': 'success'}
    if request.method == 'PUT':
        post_data = request.get_json()
        remove_book(book_id)
        BOOKS.append({
            'id': uuid.uuid4().hex,
            'title': post_data.get('title'),
            'author': post_data.get('author'),
            'read': post_data.get('read')
        })
        response_object['message'] = 'Book updated!'
    return jsonify(response_object)
```

添加辅助方法：

```
def remove_book(book_id):
    for book in BOOKS:
        if book['id'] == book_id:
            BOOKS.remove(book)
            return True
    return False
```

> 想想看如果你没有 `id` 标识符你会怎么办？如果有效载荷不正确怎么办？重构辅助方法中的 for 循环，让他更加 pythonic。

### 客户端

步骤：

1.  添加模态和表单
2.  处理更新按钮点击事件
3.  发送 AJAX 请求
4.  通知用户
5.  处理取消按钮点击事件

#### （1）添加模态和表单

首先，加入一个新的模态到 template 中，就在第一个模态下面：

```
<b-modal ref="editBookModal"
         id="book-update-modal"
         title="Update"
         hide-footer>
  <b-form @submit="onSubmitUpdate" @reset="onResetUpdate" class="w-100">
  <b-form-group id="form-title-edit-group"
                label="Title:"
                label-for="form-title-edit-input">
      <b-form-input id="form-title-edit-input"
                    type="text"
                    v-model="editForm.title"
                    required
                    placeholder="Enter title">
      </b-form-input>
    </b-form-group>
    <b-form-group id="form-author-edit-group"
                  label="Author:"
                  label-for="form-author-edit-input">
        <b-form-input id="form-author-edit-input"
                      type="text"
                      v-model="editForm.author"
                      required
                      placeholder="Enter author">
        </b-form-input>
      </b-form-group>
    <b-form-group id="form-read-edit-group">
      <b-form-checkbox-group v-model="editForm.read" id="form-checks">
        <b-form-checkbox value="true">Read?</b-form-checkbox>
      </b-form-checkbox-group>
    </b-form-group>
    <b-button type="submit" variant="primary">Update</b-button>
    <b-button type="reset" variant="danger">Cancel</b-button>
  </b-form>
</b-modal>
```

添加表单状态到 `script` 中的 `data` 部分：

```
editForm: {
  id: '',
  title: '',
  author: '',
  read: [],
},
```

> 挑战：不使用新的模态，使用一个模态框处理 POST 和 PUT 请求。

#### （2）处理更新按钮点击事件

更新表格中的“更新”按钮：

```
<button
        type="button"
        class="btn btn-warning btn-sm"
        v-b-modal.book-update-modal
        @click="editBook(book)">
    Update
</button>
```

添加一个新方法去更新 `editForm` 中的值：

```
editBook(book) {
  this.editForm = book;
},
```

然后，添加一个方法去处理表单提交：

```
onSubmitUpdate(evt) {
  evt.preventDefault();
  this.$refs.editBookModal.hide();
  let read = false;
  if (this.editForm.read[0]) read = true;
  const payload = {
    title: this.editForm.title,
    author: this.editForm.author,
    read,
  };
  this.updateBook(payload, this.editForm.id);
},
```

#### （3）发送 AJAX 请求

```
updateBook(payload, bookID) {
  const path = `http://localhost:5000/books/${bookID}`;
  axios.put(path, payload)
    .then(() => {
      this.getBooks();
    })
    .catch((error) => {
      // eslint-disable-next-line
      console.error(error);
      this.getBooks();
    });
},
```

#### （4）通知用户

更新 `updateBook`：

```
updateBook(payload, bookID) {
  const path = `http://localhost:5000/books/${bookID}`;
  axios.put(path, payload)
    .then(() => {
      this.getBooks();
      this.message = 'Book updated!';
      this.showMessage = true;
    })
    .catch((error) => {
      // eslint-disable-next-line
      console.error(error);
      this.getBooks();
    });
},
```

#### （5）处理取消按钮点击事件

添加方法：

```
onResetUpdate(evt) {
  evt.preventDefault();
  this.$refs.editBookModal.hide();
  this.initForm();
  this.getBooks(); // why?
},
```

更新 `initForm`：

```
initForm() {
  this.addBookForm.title = '';
  this.addBookForm.author = '';
  this.addBookForm.read = [];
  this.editForm.id = '';
  this.editForm.title = '';
  this.editForm.author = '';
  this.editForm.read = [];
},
```

在继续下一步之前先检查一下代码。检查结束后，测试一下应用。确保按钮按下后显示模态框，并正确显示输入值。

![update book](https://testdriven.io/assets/img/blog/flask-vue/update-book.gif)

## DELETE 路由

### 服务端

更新路由操作：

```
@app.route('/books/<book_id>', methods=['PUT', 'DELETE'])
def single_book(book_id):
    response_object = {'status': 'success'}
    if request.method == 'PUT':
        post_data = request.get_json()
        remove_book(book_id)
        BOOKS.append({
            'id': uuid.uuid4().hex,
            'title': post_data.get('title'),
            'author': post_data.get('author'),
            'read': post_data.get('read')
        })
        response_object['message'] = 'Book updated!'
    if request.method == 'DELETE':
        remove_book(book_id)
        response_object['message'] = 'Book removed!'
    return jsonify(response_object)
```

### 客户端

更新“删除”按钮：

```
<button
        type="button"
        class="btn btn-danger btn-sm"
        @click="onDeleteBook(book)">
    Delete
</button>
```

添加方法来处理按钮点击然后删除书籍：

```
removeBook(bookID) {
  const path = `http://localhost:5000/books/${bookID}`;
  axios.delete(path)
    .then(() => {
      this.getBooks();
      this.message = 'Book removed!';
      this.showMessage = true;
    })
    .catch((error) => {
      // eslint-disable-next-line
      console.error(error);
      this.getBooks();
    });
},
onDeleteBook(book) {
  this.removeBook(book.id);
},
```

现在，当用户点击删除按钮时，将会触发 `onDeleteBook` 方法。同时，`removeBook` 方法会被调用。这个方法会发送删除请求到后端。当返回响应后，通知消息会显示出来然后 `getBooks` 会被调用。

> 挑战：
> 
> 1.  在删除按钮点击时加入一个确认提示。
> 2.  当没有书的时候，显示一个“没有书籍，请添加”消息。

![delete book](https://testdriven.io/assets/img/blog/flask-vue/delete-book.gif)

## 总结

这篇文章介绍了使用 Vue 和 Flask 设置 CRUD 应用程序的基础知识。

从头回顾这篇文章以及其中的挑战来加深你的理解。

你可以在 [flask-vue-crud](https://github.com/testdrivenio/flask-vue-crud) 仓库 中的 [v1](https://github.com/testdrivenio/flask-vue-crud/releases/tag/v1) 标签里找到源码。感谢你的阅读。

> **想知道更多？** 看看这篇文章的续作 [Accepting Payments with Stripe, Vue.js, and Flask](https://testdriven.io/accepting-payments-with-stripe-vuejs-and-flask)。


> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
