> * 原文地址：[5 Strategies to Reduce Frontend Build Time with CI/CD](https://blog.bitsrc.io/5-strategies-to-reduce-frontend-build-time-with-ci-cd-3ce429304d1a)
> * 原文作者：[Bhagya Vithana](https://medium.com/@bhagya-16)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/5-strategies-to-reduce-frontend-build-time-with-ci-cd.md](https://github.com/xitu/gold-miner/blob/master/article/2021/5-strategies-to-reduce-frontend-build-time-with-ci-cd.md)
> * 译者：
> * 校对者：

# 5 Strategies to Reduce Frontend Build Time with CI/CD

![](https://cdn-images-1.medium.com/max/2560/1*4QARtPZqNOK5peGb0vFLSg.jpeg)

Today, using CI/CD tools is a must for web application development. As a part of the critical development path, speeding up our build system is vital to improve developer productivity.

So, In this article will take you through four different strategies to optimize the front-end build time with CI/CD.

## 1. Using Parallel Web Packs

> Parallel-Webpack allows you to run your application builds in parallel, helping to reduce build times significantly.

You can get started using Parallel-Webpack easily with NPM using the following command:

```bash
npm install parallel-webpack —-save-dev
```

To get a better understanding of Parallel-Webpack configuration, let’s go through this simple example.

```js
var path = require('path');
module.exports = [{
  entry: './firstjob.js',
  output: {
    path: path.resolve(__dirname, './dist'),
   filename: 'task1.bundle.js'
  }
}, 
{
  entry: './secondjob.js',
  output: {
    path: path.resolve(__dirname, './dist'),
    filename: 'task2.bundle.js'
  }
}];
```

The above configuration includes two separate build tasks as `firstjob` and `secondjob.` Parallel-Webpack will run both these entries simultaneously, and you will find out that **task1.bundle.js** is built at the same time as **task2.bundle.js**.

> Parallel-Webpack allows you to control parallelism and includes features from the normal Webpack like the watcher and retry limit.

### Controlling Parallelism

Sometimes, you may want to limit the usage of CPU cores available for Parallel-Webpack. In such cases, you can specify the number of allowed CPU cores using `parallel-webpack -p=2` command.

### Running The Watcher

One of the features which make the Webpack so influential is its watcher that continuously rebuilds your application. You can use the same feature effortlessly with Parallel-Webpack by adding the watch flag to the command.

```bash
parallel-webpack --watch
```

Likewise, there are many exciting features in Parallel-Webpack that can be integrated into your CI/CD pipeline to speed it up. And you can find more information about them in their [documentation](https://github.com/trivago/parallel-webpack).

## 2. Splitting Your Application into Micro Frontends

If we consider traditional monolithic frontend systems, most of them have only a single build pipeline and a single release pipeline. So there is a possibility of breaking the entire build phase in the CI/CD pipeline if there is a bug fix or new feature update.

However, if we move into Micro-frontends, we can separate functionalities of the application and maintain separate build and release pipelines to constantly deliver updates and bug fixes.

![Micro Frontend Architecture](https://cdn-images-1.medium.com/max/2000/1*_wBCz4UeRf6qW8Dk38zs1A.png)

Basically, it is possible to integrate and deploy each app independently, allowing you to deliver critical fixes more quickly. So, this really helps a lot to make the CI/CD processes much faster.

## 3. Component-Driven CI: “Ripple CI”

A component-driven CI is a CI that runs only on modified components and all their dependencies (i.e, affected components). It does not treat the entire project as a single entity. A typical example of Ripple CI is [Bit](https://gihub.com/teambit/bit).

## 4. Optimizing Web Pack Performance

We typically use Webpack with default settings. However, do you know that we can further optimize it by using plugins and custom configurations?

### Use the uglifyjs-webpack-plugin v1

Minification is the process of minimizing code, markup, and script files in your web pages. It is one of the main methods used to reduce the build time.

But this modification process itself can take a considerable amount of time as the project size increases.

So if your project is scaling, you can use `uglifyjs-webpack-plugin v1` to optimize the modification time. This plugin provides the ability to run multi-process parallel and caching support, which significantly improved build efficiency.

### Use loaders on the minimum of modules

Webpack uses loaders to transform other types of files into valid modules. These modules are then consumed by your application and added to the dependency graph.

> So, it’s essential to specify the relevant file directories to reduce the unwanted module loading.

You can easily use the Webpack configuration to specify the file directories using the `include` option :

```js
const path = require('path');

module.exports = {
  //...
  module: {
    rules: [
      {
        test: /\.js$/,
        include: path.resolve(__dirname, 'src'),
        loader: 'css-loader',
      },
    ],
  },
};
```

## 5. Pipeline Caching for NPM Module Install

As we all know, installing node modules takes time. We can see this issue, especially in pipelines since they install node modules each time they run.

> NPM caching is a simple caching mechanism we can use in the build pipelines to avoid running npm install every time.

This caching mechanism will make your build pipeline similar to your local development environment. You need to install node modules only once, and the same modules will be used for subsequent builds.

For example, let’s consider an Azure DevOps pipeline for a NodeJS project.

The most recommended way to cache NPM modules for a NodeJs project is using NPM’s [shared cache directory](https://docs.npmjs.com/misc/config#cache). This directory includes a cached version of all downloaded modules. Whenever we run `npm install` command, NPM will first check this directory and get the stored packages in there.

**Example code:**

```yml
variables: 
npm_config_cache: $(Pipeline.Workspace)/.npm 

steps: 
— task: Cache@2 
  inputs: 
    key: ‘npm | “$(Agent.OS)” | package-lock.json’ 
    restoreKeys: | 
      npm | “$(Agent.OS)” 
    path: $(npm_config_cache) 
  displayName: Cache npm

— script: npm ci
```

## Conclusion

As you have learned, there are several techniques out there to speed up the front-end application’s building time. Besides, there are many techniques out there that might fit your technology and development workflow. You have to choose what works for your use case.

However, I hope the strategies discussed here will help you understand the various strategies to speed up the frontend building time with your CI/CD process.

Thank you for reading…!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
