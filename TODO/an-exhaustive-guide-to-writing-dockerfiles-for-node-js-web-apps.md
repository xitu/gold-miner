> * 原文地址：[An Exhaustive Guide to Writing Dockerfiles for Node.js Web Apps](https://blog.hasura.io/an-exhaustive-guide-to-writing-dockerfiles-for-node-js-web-apps-bbee6bd2f3c4)
> * 原文作者：[Praveen Durairaj](https://blog.hasura.io/@praveenweb.d?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/an-exhaustive-guide-to-writing-dockerfiles-for-node-js-web-apps.md](https://github.com/xitu/gold-miner/blob/master/TODO/an-exhaustive-guide-to-writing-dockerfiles-for-node-js-web-apps.md)
> * 译者：[lsvih](https://github.com/lsvih)
> * 校对者：[Raoul1996](https://github.com/Raoul1996), [song-han](https://github.com/song-han)

# 一份为 Node.js 应用准备的 Dockerfile 指南

![](https://cdn-images-1.medium.com/max/800/1*4KhmpXFJ_Etczs6awRnAbg.png)

### TL;DR

本文涵盖了从创建简单的 Dockerfile 到生产环境多级构建 Node.js Web 应用的例子。以下为本指南的内容摘要：

* 使用合适的基础镜像（开发环境使用 carbon，生产环境使用 alpine）。
* 在开发时使用 `nodemon` 进行热加载。
* 优化 Docker 的 cache layer（缓存层）—— 按照正确的顺序使用命令，仅在需要时运行 `npm install`。
* 使用 `serve` 包部署静态文件（比如 React、Vue、Angular 生成的 bundle）。
* 使用 `alpine` 进行生产环境下的多级构建，减少最终镜像文件的大小。
* #建议 — 1) 使用 COPY 代替 ADD 2) 使用 `init` 标识，处理 CTRL-C 等内核信号。

如果你需要以上步骤的代码，请参考 [GitHub repo](https://github.com/praveenweb/node-docker)。

### **内容**

1. 简单的 Dockerfile 样例与 .dockerignore 文件
2. 使用 nodemon 实现热更新
3. 优化
4. 部署静态文件
5. 生产环境中的直接构建
6. 生产环境中的多级构建

让我们先假设一个名为 node-app 的应用，一个简单的目录结构。在顶级目录下，包含 `Dockerfile` 以及 `package.json`，node app 的代码将存于 `src` 目录下。为了简洁起见，我们假设 server.js 定义了一个运行于 8080 端口的 node express 服务。

```
node-app
├── Dockerfile
├── package.json
└── src
    └── server.js
```

### **1. 简单的 Dockerfile 样例**

```
FROM node:carbon

# 创建 app 目录
WORKDIR /app

# 安装 app 依赖
# 使用通配符确保 package.json 与 package-lock.json 复制到需要的地方。（npm 版本 5 以上） COPY package*.json ./

RUN npm install
# 如果你需要构建生产环境下的代码，请使用：
# RUN npm install --only=production

# 打包 app 源码
COPY src /app

EXPOSE 8080
CMD [ "node", "server.js" ]
```

我们将使用最新的 LTS 版本 `node:carbon` 作为基础镜像。

在构建镜像时，docker 会获取所有位于 `context` 目录下的文件。为了增加 docker 构建的速度，可以在 context 目录中添加 `.dockerignore` 文件来排除不需要的文件与目录。

通常，你的 `.dockerignore` 文件件应该如下所示：

```
.git
node_modules
npm-debug
```

构建并运行此镜像：

```
$ cd node-docker
$ docker build -t node-docker-dev .
$ docker run --rm -it -p 8080:8080 node-docker-dev
```

你将能在 `[http://localhost:8080](http://localhost:8080.)` 访问此 app。使用 `Ctrl+C` 组合键可以退出程序。

现在，假设你希望在每次修改代码（比如在本地部署时）时都运行以上代码，那么你需要在启停 node 服务时将代码源文件挂载到容器中。

```
$ docker run --rm -it -p 8080:8080 -v $(pwd):/app \
             node-docker-dev bash
root@id:/app# node src/server.js
```

### 2. 使用 Nodemon 实现热更新

[nodemon](https://www.npmjs.com/package/nodemon) 是一款很受欢迎的包，它在运行时会监视目录中的文件，当任何文件发生了改变时，nodemon 将会自动重启你的 node 应用。

```
FROM node:carbon

# 创建 app 目录
WORKDIR /app

# 安装 nodemon 以实现热更新
RUN npm install -g nodemon

# 安装 app 依赖
# 使用通配符确保 package.json 与 package-lock.json 复制到需要的地方。（npm 版本 5 以上）COPY package*.json ./

RUN npm install

# 打包 app 源码
COPY src /app

EXPOSE 8080
CMD [ "nodemon", "server.js" ]
```

我们将构建镜像并运行 nodemon，以便在 `app` 目录下文件发生变动时对代码进行 rebuild。

```
$ cd node-docker
$ docker build -t node-hot-reload-docker .
$ docker run --rm -it -p 8080:8080 -v $(pwd):/app \
             node-hot-reload-docker bash
root@id:/app# nodemon src/server.js
```


一切在 `app` 目录下的更改都会触发 rebuild，发生的变化都能在 `[http://localhost:8080](http://localhost:8080.)` 上实时展示。请注意，我们已经将文件挂载到了容器中，因此 nodemon 才能正常工作。

### 3. 优化

在你的 Dockerfile 中，除非你需要自动解压 tar 文件（参考 [Docker 最佳实践](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#add-or-copy)），否则最好使用 COPY 来代替 ADD。

绕过 `package.json` 的 `start` 命令，而是直接将 app “烧录”至镜像文件中。因此在 Dockerfile CMD 中不要使用：

```
$ CMD ["npm","start"]
```

而应当使用：

```
$ CMD ["node","server.js"]
```

来代替。这样可以减少在容器中运行的进程数量，同时还能让 Node.js 进程接收到 `SIGTERM` 与 `SIGINT` 等退出信号，如若是 npm 进程则会无视这些信号（参考 [Node.js Docker 最佳实践](https://github.com/nodejs/docker-node/blob/master/docs/BestPractices.md#cmd)）。

你还可以使用 `--init` 标志，用 [tini](https://github.com/krallin/tini) 轻量集初始化系统来包装你的 Node.js 进程，它们也能响应一些 `SIGTERM`（`CTRL-C`）之类的内核信号。例如，你可以使用：

```
$ docker run --rm -it --init -p 8080:8080 -v $(pwd):/app \
             node-docker-dev bash
```

### 4. 部署静态文件

前文的 Dockerfile 是假设你运行了由 Node.js 构建的 API 服务。那么下面说说如果你想要用 Node.js 部署 React.js、Vue.js、Angular.js 应用时该怎么做。

```
FROM node:carbon

# 创建 app 目录
WORKDIR /app

# 安装 app 依赖
RUN npm -g install serve
# 使用通配符复制 package.json 与 package-lock.json
COPY package*.json ./

RUN npm install

# 打包 app 源码
COPY src /app
# 将 react、vue、angular 打包构建成静态文件
RUN npm run build

EXPOSE 8080
# 将 dist 目录部署于 8080 端口
CMD ["serve", "-s", "dist", "-p", "8080"]
```

如你所见，当你需要构建 React、Vue、Angular 制作的 UI app 时，使用 `npm run build` 来压缩 JS 与 CSS 文件，生成最终的 `bundle` 包，在这儿我们使用了 npm 的 `[serve](https://www.npmjs.com/package/serve)` 包来部署静态文件。

此外，可以使用一些替代方案：1) 在本地构建打包文件，然后使用 nginx docker 来部署这些静态文件。2) 使用 CI/CD 工作流进行构建。

### 5. 生产环境中的直接构建

```
FROM node:carbon

# 创建 app 目录
WORKDIR /app

# 安装 app 依赖
# RUN npm -g install serve

# 使用通配符复制 package.json 与 package-lock.json
COPY package*.json ./

RUN npm install

# 打包 app 源码
COPY src /app

# 如需对 react/vue/angular 打包，生成静态文件，使用：
# RUN npm run build

EXPOSE 8080
# 如需部署静态文件，使用：
#CMD ["serve", "-s", "dist", "-p", "8080"]
CMD [ "node", "server.js" ]
```

构建并运行这个一体化镜像：

```
$ cd node-docker
$ docker build -t node-docker-prod .
$ docker run --rm -it -p 8080:8080 node-docker-prod
```

由于底层为 Debian，构建完成后镜像约为 700MB（具体数值取决于你的源码）。下面探讨如何减小这个文件的大小。

### 6. 生产环境中的多级构建

使用多级构建时，将在 Dockerfile 中使用多个 `FROM` 语句，但最后仅会使用最终阶段构建的文件。这样，得到的镜像将仅包含生产服务器中所需的依赖，理想情况下文件将非常小。

```
# ---- Base Node ----
FROM node:carbon AS base
# 创建 app 目录
WORKDIR /app

# ---- Dependencies ----
FROM base AS dependencies  
# 使用通配符复制 package.json 与 package-lock.json
COPY package*.json ./
# 安装在‘devDependencies’中包含的依赖
RUN npm install

# ---- Copy Files/Build ----
FROM dependencies AS build  
WORKDIR /app
COPY src /app
# 如需对 react/vue/angular 打包，生成静态文件，使用：
# RUN npm run build

# --- Release with Alpine ----
FROM node:8.9-alpine AS release  
# 创建 app 目录
WORKDIR /app
# 可选命令：
# RUN npm -g install serve
COPY --from=dependencies /app/package.json ./
# 安装 app 依赖
RUN npm install --only=production
COPY --from=build /app ./
#CMD ["serve", "-s", "dist", "-p", "8080"]
CMD ["node", "server.js"]
```

使用上面的方法，用 Alpine 构建的镜像文件大小约 70MB，比之前少了 10 倍。使用 `alpine` 版本进行构建能有效减小镜像的大小。

如果你对前面的方法有任何建议，或希望看到别的用例，请告知作者。

加入 [Reddit](https://www.reddit.com/r/node/comments/7vw6gj/an_exhaustive_guide_to_writing_dockerfiles_for/) / [HackerNews](https://news.ycombinator.com/item?id=16330793) 讨论:)

* * *

此外，你是否试过将 Node.js web 应用部署在 Hasura 上呢？这其实是将 Node.js 应用部署于 HTTPS 域名的最快的方法（仅需使用 git push）。尝试使用 [https://hasura.io/hub/nodejs-frameworks](https://hasura.io/hub/nodejs-frameworks) 的模板快速入门吧！Hasura 中所有的项目模板都带有 Dockerfile 与 Kubernetes 标准文件，你可以自由进行定义。

感谢 [Tanmai Gopal](https://medium.com/@tanmaig?source=post_page)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。


