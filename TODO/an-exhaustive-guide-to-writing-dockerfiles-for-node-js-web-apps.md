> * 原文地址：[An Exhaustive Guide to Writing Dockerfiles for Node.js Web Apps](https://blog.hasura.io/an-exhaustive-guide-to-writing-dockerfiles-for-node-js-web-apps-bbee6bd2f3c4)
> * 原文作者：[Praveen Durairaj](https://blog.hasura.io/@praveenweb.d?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/an-exhaustive-guide-to-writing-dockerfiles-for-node-js-web-apps.md](https://github.com/xitu/gold-miner/blob/master/TODO/an-exhaustive-guide-to-writing-dockerfiles-for-node-js-web-apps.md)
> * 译者：
> * 校对者：

# An Exhaustive Guide to Writing Dockerfiles for Node.js Web Apps

![](https://cdn-images-1.medium.com/max/800/1*4KhmpXFJ_Etczs6awRnAbg.png)

### TL;DR

This post is filled with examples ranging from a simple Dockerfile to multistage production builds for Node.js web apps. Here’s a quick summary of what this guide covers:

* Using an appropriate base image (carbon for dev, alpine for production).
* Using `nodemon` for hot reloading during development.
* Optimising for Docker cache layers — placing commands in the right order so that `npm install` is executed only when necessary.
* Serving static files (bundles generated via React/Vue/Angular) using `serve` package.
* Using multi-stage `alpine` build to reduce final image size for production.
* #ProTips — 1) Using COPY over ADD 2) Handling CTRL-C Kernel Signals using `init` flag.

If you’d like to jump right ahead to the code, check out the [GitHub repo](https://github.com/praveenweb/node-docker).

### **Contents**

1. [Simple Dockerfile and .dockerignore](#d392)
2. [Hot Reloading with nodemon](#bbcd)
3. [Optimisations](#5ece)
4. [Serving Static Files](#fa44)
5. [Single Stage Production Build](#3fd7)
6. [Multi Stage Production Build](#224e)

Let’s assume a simple directory structure. The application is called node-app. The top level directory has a `Dockerfile`and `package.json` The source code of your node app will be in `src` folder. For brevity, let’s assume that server.js defines a node express server running on port 8080.

```
node-app
├── Dockerfile
├── package.json
└── src
    └── server.js
```

### **1. Simple Dockerfile Example**

```
FROM node:carbon

# Create app directory
WORKDIR /app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

RUN npm install
# If you are building your code for production
# RUN npm install --only=production

# Bundle app source
COPY src /app

EXPOSE 8080
CMD [ "node", "server.js" ]
```

For the base image, we have used the latest LTS version`node:carbon`

During image build, docker takes all files in the `context` directory. To increase the docker build’s performance, exclude files and directories by adding a `.dockerignore` file to the context directory.

Typically, your `.dockerignore` file should be:

```
.git
node_modules
npm-debug
```

Build and run this image:

```
$ cd node-docker
$ docker build -t node-docker-dev .
$ docker run --rm -it -p 8080:8080 node-docker-dev
```

The app will be available at `[http://localhost:8080](http://localhost:8080.)`. Use `Ctrl+C` to quit.

Now let’s say you want this to work every time you change your code. i.e local development. Then you would mount the source code files into the container for starting and stopping the node server.

```
$ docker run --rm -it -p 8080:8080 -v $(pwd):/app \
             node-docker-dev bash
root@id:/app# node src/server.js
```

### 2. Hot Reloading with Nodemon

[nodemon](https://www.npmjs.com/package/nodemon) is a popular package which will watch the files in the directory in which it was started. If any files change, nodemon will automatically restart your node application.

```
FROM node:carbon

# Create app directory
WORKDIR /app

# Install nodemon for hot reload
RUN npm install -g nodemon

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

RUN npm install

# Bundle app source
COPY src /app

EXPOSE 8080
CMD [ "nodemon", "server.js" ]
```

We’ll build the image and run nodemon so that the code is rebuilt whenever there is any change inside the `app` directory.

```
$ cd node-docker
$ docker build -t node-hot-reload-docker .
$ docker run --rm -it -p 8080:8080 -v $(pwd):/app \
             node-hot-reload-docker bash
root@id:/app# nodemon src/server.js
```

All edits in the`app`directory will trigger a rebuild and changes will be available live at `[http://localhost:8080](http://localhost:8080.)`. Note that we have mounted the files into the container so that nodemon can actually work.

### 3. Optimisations

In your Dockerfile, prefer COPY over ADD unless you are trying to add auto-extracting tar files, according to [Docker’s best practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#add-or-copy).

Bypass `package.json` ‘s `start` command and bake it directly into the image itself. So instead of

```
$ CMD ["npm","start"]
```

you would use something like

```
$ CMD ["node","server.js"]
```

in your Dockerfile CMD. This reduces the number of processes running inside the container and it also causes exit signals such as `SIGTERM` and `SIGINT` to be received by the Node.js process instead of npm swallowing them. (Reference — [Node.js Docker Best Practices](https://github.com/nodejs/docker-node/blob/master/docs/BestPractices.md#cmd))

You can also use the `--init` flag to wrap your Node.js process with a [lightweight init system](https://github.com/krallin/tini), which will respond to Kernel Signals like `SIGTERM` (`CTRL-C`) etc. For example, you can do:

```
$ docker run --rm -it --init -p 8080:8080 -v $(pwd):/app \
             node-docker-dev bash
```

### 4. Serving Static Files

The above Dockerfile assumed that you are running an API server with Node.js. Let’s say you want to serve your React.js/Vue.js/Angular.js app using Node.js.

```
FROM node:carbon

# Create app directory
WORKDIR /app

# Install app dependencies
RUN npm -g install serve
# A wildcard is used to ensure both package.json AND package-lock.json are copied
COPY package*.json ./

RUN npm install

# Bundle app source
COPY src /app
#Build react/vue/angular bundle static files
RUN npm run build

EXPOSE 8080
# serve dist folder on port 8080
CMD ["serve", "-s", "dist", "-p", "8080"]
```

As you can see above, we are using the npm package `[serve](https://www.npmjs.com/package/serve)` to serve static files. Assuming you are building a UI app using React/Vue/Angular, you would ideally build your final `bundle` using `npm run build` which would generate a minified JS and CSS file.

The other alternative is to either 1) build the files locally and use an nginx docker to serve these static files or 2) via a CI/CD pipleline.

### 5. Single Stage Production Build

```
FROM node:carbon

# Create app directory
WORKDIR /app

# Install app dependencies
# RUN npm -g install serve

# A wildcard is used to ensure both package.json AND package-lock.json are copied
COPY package*.json ./

RUN npm install

# Bundle app source
COPY src /app

# Build react/vue/angular bundle static files
# RUN npm run build

EXPOSE 8080
# If serving static files
#CMD ["serve", "-s", "dist", "-p", "8080"]
CMD [ "node", "server.js" ]
```

Build and run the all-in-one image:

```
$ cd node-docker
$ docker build -t node-docker-prod .
$ docker run --rm -it -p 8080:8080 node-docker-prod
```

The image built will be ~700MB (depending on your source code), due to the underlying Debian layer. Let’s see how we can cut this down.

### 6. Multi Stage Production Build

With multi stage builds, you use multiple `FROM` statements in your Dockerfile but the final build stage will be the one used, which will ideally be a tiny production image with only the exact dependencies required for a production server.

```
# ---- Base Node ----
FROM node:carbon AS base
# Create app directory
WORKDIR /app

# ---- Dependencies ----
FROM base AS dependencies  
# A wildcard is used to ensure both package.json AND package-lock.json are copied
COPY package*.json ./
# install app dependencies including 'devDependencies'
RUN npm install

# ---- Copy Files/Build ----
FROM dependencies AS build  
WORKDIR /app
COPY src /app
# Build react/vue/angular bundle static files
# RUN npm run build

# --- Release with Alpine ----
FROM node:8.9-alpine AS release  
# Create app directory
WORKDIR /app
# optional
# RUN npm -g install serve
COPY --from=dependencies /app/package.json ./
# Install app dependencies
RUN npm install --only=production
COPY --from=build /app ./
#CMD ["serve", "-s", "dist", "-p", "8080"]
CMD ["node", "server.js"]
```

With the above, the image built with Alpine comes to around ~70MB, a 10X reduction in size. The `alpine` variant is usually a very safe choice to reduce image sizes.

Any suggestions to improve the ideas above? Any other use-cases that you’d like to see? Do let me know in the comments.

Join the discussion on [Reddit](https://www.reddit.com/r/node/comments/7vw6gj/an_exhaustive_guide_to_writing_dockerfiles_for/) / [HackerNews](https://news.ycombinator.com/item?id=16330793) :)

* * *

Psst…. Have you tried deploying a Node.js web-app on Hasura? It is literally the fastest way in the world for deploying Node.js apps to an HTTPS domain (with just a git push). Get started with any of the project boilerplates here: [https://hasura.io/hub/nodejs-frameworks](https://hasura.io/hub/nodejs-frameworks). All project boilerplates on Hasura come with a Dockerfile and Kubernetes spec files that you can customize as you wish!

Thanks to [Tanmai Gopal](https://medium.com/@tanmaig?source=post_page).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
