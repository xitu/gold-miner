> * 原文地址：[Everything You Need To Know About Parcel: The Blazing Fast Web App Bundler 🚀](https://medium.freecodecamp.org/all-you-need-to-know-about-parcel-dbe151b70082)
> * 原文作者：[Indrek Lasn](https://medium.freecodecamp.org/@wesharehoodies?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/all-you-need-to-know-about-parce.md](https://github.com/xitu/gold-miner/blob/master/TODO/all-you-need-to-know-about-parce.md)
> * 译者：
> * 校对者：

# Everything You Need To Know About Parcel: The Blazing Fast Web App Bundler 🚀

![](https://cdn-images-1.medium.com/max/800/1*-Tcq85crClCEu_gYzn06gg.gif)

_Really?_ Yet another bundler/build tool? Yep — you betcha, evolution and innovation combined brings you [Parcel](https://parceljs.org/).

![](https://cdn-images-1.medium.com/max/800/1*Gjhk6qvPM5zAy1iPPS1ttg.png)

#### **What’s so special about Parcel and why should I care?**

While webpack brings a lot of configurability with the cost of complexity — **Parcel brings simplicity**. Parcel brands itself as “zero configuration”.

_Unravelling the above_ — Parcel has a development server built in out of the box. The development server will automatically rebuild your app as you change files and supports [hot module replacement](https://parceljs.org/hmr.html) for fast development.

#### **What are the benefits of Parcel?**

* Fast bundle times — Parcel is faster than Webpack, Rollup and Browserify.

![](https://cdn-images-1.medium.com/max/800/1*jovxixL_dfSEnp9f6r8eEA.png)

Parcel benchmarks

Something to consider: Webpack is still awesome and sometimes can be faster

![](https://cdn-images-1.medium.com/max/800/1*e9ZNxTRvxQSgAHFIegC-6w.png)

[Source](https://github.com/TheLarkInn/bundler-performance-benchmark/blob/master/README.md)

* Parcel has out of the box support for JS, CSS, HTML, file assets, and more — **no plugins needed — More user friendly.**
* Zero configuration required. Out of the box code splitting, hot module reloading, css preprocessors, development server, caching, and many more!
* Friendlier error logs.

![](https://cdn-images-1.medium.com/max/800/1*miFAZZhZpaloYs1fj3jB0A.png)

![](https://cdn-images-1.medium.com/max/400/1*2MnJM2-lQHND-icGggt4Ug.png)

Parcel error handling

#### Alright — so when should I use Parcel, Webpack or Rollup?

It’s completely up to you but I personally would use each bundler in the following situations:

**_Parcel _**— Small to medium sized projects (<15k lines of code)

**_Webpack_** — Large to enterprise sized projects.

**_Rollup_** — For NPM packages.

_Let’s give Parcel a shot!_

* * *

#### Installation is fairly straight-forward

```
npm install parcel-bundler --save-dev
```

We installed the [parcel-bundler npm package](https://www.npmjs.com/package/parcel-bundler) locally. Now we need to initialize a node project.

![](https://cdn-images-1.medium.com/max/800/1*ncsWSVcZ9H2GvCryk1bjbw.png)

Next, create `index.html` and `index.js` file.

![](https://cdn-images-1.medium.com/max/800/1*42o-xydISJg7RFPJEV8vXQ.png)

Let’s connect our `index.html` and `index.js`

![](https://cdn-images-1.medium.com/max/600/1*mnvGwOAj77U0ukki4s4LZQ.png)

![](https://cdn-images-1.medium.com/max/600/1*0SsOP82bxYkYIt-H9XL8Zw.png)

And finally add parcel script to our `package.json`

![](https://cdn-images-1.medium.com/max/800/1*n3Al1gXiv4tNNGo3pWc-ug.png)

That’s all there is to configuration — amazing time saver!

Next up — let’s start our server.

![](https://cdn-images-1.medium.com/max/600/1*Yq8tQPP6Qv80xwV3N-1lIw.gif)

![](https://cdn-images-1.medium.com/max/600/1*tWzj5lTbPm2rEZKndCgKhQ.png)

Work like a charm! Notice the build times.

![](https://cdn-images-1.medium.com/max/800/1*6PKBaYyEQrK889opDE72Vg.png)

**_15ms?!_ **Wow, that’s blazing fast indeed!

How’s the HMR?

![](https://cdn-images-1.medium.com/max/800/1*KHATEDXNqL5fshf3S0B5Zw.gif)

Also feels very fast.

* * *

### SCSS

![](https://cdn-images-1.medium.com/max/800/1*dMNikHR10Nfw1Z0PtmITXA.png)

All we need is the `node-sass` package and we’re good to go!

```
npm i node-sass && touch styles.scss
```

Next up, add some styling and import the `styles.scss` to `index.js`

![](https://cdn-images-1.medium.com/max/600/1*lhF1lxmw4RQNyTpI1Y1Hdw.png)

![](https://cdn-images-1.medium.com/max/600/1*SSv27gQ34310LyJBHqo8ZQ.png)

>![](https://cdn-images-1.medium.com/max/1000/1*r8zgxebzyd-KV7LU63qfww.png)

* * *

### Production Build

All we need is to add a `build` script to our `package.json`

![](https://cdn-images-1.medium.com/max/800/1*BbfYCV5-PaFwDX_Y68oXgw.png)

Running our build script.

![](https://cdn-images-1.medium.com/max/800/1*bPzZxDj7qAwfMFkPBy44Ow.gif)

See how easy Parcel makes our lives?

![](https://cdn-images-1.medium.com/max/800/1*TVPM_3Zm60KkLxnhdDVMOQ.png)

You can specify a specific build path like so:

```
parcel build index.js -d build/output
```

* * *

### React

![](https://cdn-images-1.medium.com/max/800/1*6kK9j74vyOmXYm1gN6ARhQ.png)

Setting up react is really simple, all we need to do is install our dependencies and setup our `.babelrc`

```
npm install --save react react-dom babel-preset-env babel-preset-react && touch .babelrc
```

![](https://cdn-images-1.medium.com/max/800/1*8LV0jtqGPIRN-Z05nZjWZQ.png)

Alllllriiighty, let’s bring out the big guns! Try writing our initial react component yourself before scrolling!

![](https://cdn-images-1.medium.com/max/600/1*w6prJQoCeWWClTIGe-2eCg.png)

![](https://cdn-images-1.medium.com/max/600/1*JcIe-GLpc9yiNnWauvobrQ.png)

![](https://cdn-images-1.medium.com/max/1000/1*7ME5571Q3BlWNAgFwSGxHg.png)

* * *

### Vue

![](https://cdn-images-1.medium.com/max/800/1*lJPS840gMBZYhHeZ6aop_g.png)

**As requested, here’s the Vue example.**

Start by installing `vue` and `parcel-plugin-vue` — the latter for `.vue` components support.

```
$ npm i --save vue parcel-plugin-vue
```

We need to add our root element, import the vue index file and initialize Vue.

Start by making a vue directory and let’s also create`index.js` and `app.vue`

```
$ npm i --save vue parcel-plugin-vue
```

We need to add our root element, import the vue index file and initialize Vue.

Start by making a vue directory and let’s also create `index.js` and `app.vue`

```
$ mkdir vue && cd vue && touch index.js app.vue
```

Now lets hook our `index.js` and `index.html`

![](https://cdn-images-1.medium.com/max/800/1*PJ7L4G15cDpvreu6NkdXLQ.png)

Finally, let’s initialize vue and write our first vue component!

![](https://cdn-images-1.medium.com/max/600/1*EHKOgp5Yc69NBCImVJUJcg.png)

![](https://cdn-images-1.medium.com/max/600/1*TCyx5wWr5GK1O9E6bKllUA.png)

![](https://cdn-images-1.medium.com/max/1000/1*XDZ71d55e8vGY8QoVeJGlw.png)

Voila! We have Vue installed with `.vue` support!

* * *

### TypeScript

![](https://cdn-images-1.medium.com/max/800/1*SwI4JNcok6yj8b6a0Mykvg.png)

This one is extremely easy. Just install TypeScript and we’re good to go!

```
npm i --save typescript
```

Make a file called `index.ts` and insert it into the `index.html`

![](https://cdn-images-1.medium.com/max/600/1*zp1272l6v1XxLmX8QSndkA.png)

![](https://cdn-images-1.medium.com/max/600/1*mR0wngPbI4UfHtMZxletxQ.png)

![](https://cdn-images-1.medium.com/max/1000/1*QpIDy402yydKokM1bO5l7A.png)

Good to go!

### [Github Source Code](https://github.com/wesharehoodies/parcel-examples-vue-react-ts)

* * *

If you found this useful, please give me some claps so more people can see it!

Make sure to follow my [twitter](https://twitter.com/lasnindrek) for more!

Thanks for reading! ❤


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
