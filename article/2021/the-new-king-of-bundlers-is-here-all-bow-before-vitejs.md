> * 原文地址：[The New King of Bundlers Is Here: All Bow Before Vitejs](https://blog.bitsrc.io/the-new-king-of-bundlers-is-here-all-bow-before-vitejs-fe6f42c97ce9)
> * 原文作者：[Fernando Doglio](https://medium.com/@deleteman123)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/the-new-king-of-bundlers-is-here-all-bow-before-vitejs.md](https://github.com/xitu/gold-miner/blob/master/article/2021/the-new-king-of-bundlers-is-here-all-bow-before-vitejs.md)
> * 译者：
> * 校对者：

# The New King of Bundlers Is Here: All Bow Before Vitejs

![Photo by [Paweł Furman](https://unsplash.com/@pawelo81?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/king?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/13714/1*LlgpXcXbw-wEPTqxiRDDDw.jpeg)

Back when I started coding, JavaScript was used only to add some fancy effects to your website. Remember that trailing effect you could add to your mouse? Or how you could change the colors of your links during a hover event?

Of course, web development has evolved so much over the years that now the amount of JavaScript used on web applications is growing exponentially. It is because of that, that JavaScript is becoming its own bottleneck due to bundle size.

Bundle size for some applications are starting to affect the time users need to begin using your application (they can’t use it until the bundled code is downloaded), the bundling process itself is causing development times to increase (sometimes changing a single line of code can trigger a bundling process that takes several minutes), and while there are techniques around to help solve this problem, not all of them are hitting the mark and the ones that do require a lot of effort to achieve — which as a user of these tools, you shouldn’t care, but if you’re working on them, then it becomes a real pain to maintain.

That is why today I want to tell you about a tool that promises to solve all these problems: [ViteJS](https://vitejs.dev/).

## What makes ViteJS so great?

That is, without a doubt, the first question you should be asking yourself.

There are way too many bundlers out there already, do you need one more? Yes, yes you do.

ViteJS is not just a bundler, and that is the key aspect of it. In fact, ViteJS is aiming to be your go-to tool for starting any new JavaScript-based project. It changes the way normal bundlers think about dependencies by working directly with ES Modules and letting the browser do some of the work.

It also relies heavily on HTTP to cache non-changing code. So, instead of working with a huge bundled file where you’re sending all the code to the client, it is the client that decides what to keep and what to refresh often (more on this in a second).

Some of the main features from ViteJS that you might want to pay attention to are:

* **Built with speed in mind.** The little bundling and transpiling ViteJS does, does so using [esbuild](https://esbuild.github.io/), which is built in Go. This in turn provides a faster experience (10x to 20x times faster than any JavaScript-based bundlers according to them).
* **Compatible with TypesScript**. While it does not perform type-checking, normally your IDE will take care of that, and you can even add a quick one-liner to the build script to do it for you (a quick `tsc --noEmit` and that’s it).
* **It has support for Hot Module Replacement (HMR)**. ViteJS provides an [API](https://vitejs.dev/guide/api-hmr.html#hot-data) for any ESM-compatible framework to use.
* **Improved code-splitting techniques**. ViteJS implements some improvement over the browser’s normal chunk-loading process. This ensures that if there is a chance to load several chunks in parallel, they will be loaded that way.

The list of interesting features goes on actually, so make sure to check out their site for more details.

## The plugin system

One of the main advantages of ViteJS is that it has a plugin system built-in, which means the community can (and has) add extra features and integrations with other frameworks (such as React and Vue).

### Using ViteJS for your Vue projects

[The list of plugins for Vue](https://github.com/vitejs/awesome-vite#vue) is quite extensive, the only thing you need to pay attention to, is that they’re not all compatible with the same version of the framework (some of them work for Vue 2, while others only for Vue 3, and some work for both).

To get your Vue App started, you can use a plugin such as [Vitesse](https://github.com/antfu/vitesse) which you can simply clone and rename. It comes prepacked with multiple built-in features and plugins, such as:

* [**WindiCSS**](https://github.com/windicss/windicss) as its UI framework and **[WindiCSS Typography](https://windicss.netlify.app/guide/plugins.html#typography).**
* [**Iconify**](https://iconify.design/) allows you to use icons from multiple icon sets around the web.
* **ViteJS’ [Vue i18n plugin](https://github.com/intlify/vite-plugin-vue-i18n)**. So that’s already backed-in, no need to worry about adding internationalization support.
* **A group of VS Code extensions** (for Vite’s dev server, i18n ally, WindiCSS, Iconify Intellisense, and others), which is great if you’re a VS Code user, otherwise they won’t do any good.

There are more built-in features, so make sure to check out their [Repo](https://github.com/antfu/vitesse).

If, on the other hand, you just want to start from scratch, and build your own thing, you can also simply use ViteJS’ CLI tool:

```bash
# If you're using npm 7
$ npm init @vitejs/app my-vue-app -- --template vue 

# If you're using npm 6
$ npm init @vitejs/app my-vue-app --template vue

# And if you're a yarn-biased developer
$ yarn create @vitejs/app my-vue-app --template vue
```

Either one of these commands will generate the same output:

![](https://cdn-images-1.medium.com/max/2860/1*2pPul6Se15bcLeUJpwTHDA.png)

It’s really fast (under a second) and after following those 3 extra steps, your Vue app is up and running.

![](https://cdn-images-1.medium.com/max/2092/1*hfPIpmBPpAffHUcwhMa1Qg.png)

#### ViteJS and React

You’re not a Vue type of dev? No problem, Vite has you covered.

Just use the same line as before, but instead of `vue` use `react` or `react-ts` and you’re done.

```bash
$ npm init @vitejs/app my-react-app --template react-ts
$ cd my-react-app
$ npm install
$ npm run dev
```

The above lines will output the equivalent React application using TypeScript:

![](https://cdn-images-1.medium.com/max/2368/1*UMWnw5t9qw1Lj2Ffo-UxLA.png)

Do you want more presets? You can find 2 plugins, depending on your needs:

1. If you’re looking for a React project with TypeScript, [Chakra](https://chakra-ui.com/) and [Cypress](https://www.cypress.io/), you have [this plugin](https://github.com/Dieman89/vite-reactts-chakra-starter).
2. If instead of Chakra, you’re looking to create an Electron app, you have [this one.](https://github.com/maxstue/vite-reactts-electron-starter) This one also comes with [TailwindCSS](https://tailwindcss.com/) included.

Both options work with TypeScript, and if you’re familiar with any of those combinations, I would suggest picking them up instead of starting from scratch. Mind you, the default starter project is perfectly fine, but you get part of your boilerplate setup already done with these plugins.

## What about other bundlers?

ViteJS is not the first tool to attempt to do this, and it’s definitely not the most known either. But it was created because the current ruling class is not tackling the performance problem with the latest trends in the industry. They’re still trying to solve problems that given today’s state-of-the-art shouldn’t exist.

The main difference between Vite and other bundlers such as Webpack, is that the latter will try to go through your dependency tree, compile and optimize the packaged code in a way that is better for any browser to get your code. Notice the word “any” there, since that will be the major problem for Vite. This process however, takes time, and if you’ve been using any of these established bundlers you probably know what I mean. It takes a while, but the end result is good for any client.

On the other side of the spectrum, we have Vite, which like I already mentioned, takes advantage of the browser’s ES Module support. This means the browser will be in charge of capturing the `import` and `export` and request them individually. This means you can get your app running in no time, but it also means only new browsers will be compatible with your app.

As you can see, from the following table showing support for `import` taken from [Mozilla’s site](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Modules), support is coming along nicely, however, older versions will never be able to catch up:

![Screen taken from Mozilla’s site](https://cdn-images-1.medium.com/max/4020/1*A3skPd6C2oiKF743LgwO0A.png)

There is still work to be done compatibility-wise, so if you’re thinking about using ViteJS for your next project, make sure your target audience tends to update their browsers regularly.

---

ViteJS has the potential of dethroning the current industry standards when it comes to bundler tools. It has the technology, it has the plugin ecosystem and it has the required features. The only thing stopping it from getting the crown of de-facto bundler, is its compatibility with older browsers.

This is definitely a problem today, but it’s a problem for a diminishing section of our industry, so keep an eye open for Vite, since it’ll be growing as browsers get older.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
