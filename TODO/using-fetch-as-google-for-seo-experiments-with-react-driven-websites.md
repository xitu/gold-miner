> * 原文地址：[Testing a React-driven website’s SEO using “Fetch as Google”](https://medium.freecodecamp.com/using-fetch-as-google-for-seo-experiments-with-react-driven-websites-914e0fc3ab1#.sv5ov6im3)
* 原文作者：[Patrick Hund](https://medium.freecodecamp.com/@wiekatz)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Nicolas(Yifei) Li](https://github.com/yifili09)
* 校对者：[markzhai](https://github.com/markzhai), [Romeo0906](https://github.com/Romeo0906)

# 使用 `Google` 抓取方式，测试 `React` 驱动的网站 `SEO`
我最近进行了一项测试，它有关客户端渲染的网站是否能避免被搜索引擎的机器人爬取内容。就如我[此文](https://medium.freecodecamp.com/seo-vs-react-is-it-neccessary-to-render-react-pages-in-the-backend-74ce5015c0c9#.eg3w0nh17)所述，`React` 并不会破坏搜索引擎的索引。

现在，我开始实施我的下一个步骤。为了了解 `Google` 到底能爬取和索引哪些内容，我建立了一个 `React` 的沙盒项目。

### 建立一个小型的网页应用程序

我的目标只是建立一个单纯的 `React` 应用程序，用最少的时间配置 `Babel`, `webpack` 和其他一些工具。之后，我会尽可能快地把这个应用程序部署到公网环境。

我也想能在几秒内就把更新部署到生产环境中。

考虑到要实现这些目标，理想的工具是 [`create-react-app`](https://github.com/facebookincubator/create-react-app) 和 `GitHub Pages`。

有了 _create-react-app_，我能在 30 分钟内创建一个小型的 `React` 应用程序。只需要输入这些指令:

    create-react-app seo-sandbox
    cd seo-sandbox/
    npm start

我更改了默认的文本和 `logo`，修改了一些格式，然后瞧瞧看 —— 一个 100% 由客户端程序渲染的网页完成了，让 `Googlebot` 好好琢磨一下。

你可以访问我 [Github 上的项目工程了解更多](https://github.com/pahund/seo-sandbox)。

### 部署到 `GitHub Pages`

_create-react-app_ 非常有用。简直和我心有灵犀。在我执行了 _npm run build_ 指令后，它就识别出我准备计划在 `GitHub Pages` 上发布我的项目，并且告诉我应该这么做:









![](https://cdn-images-1.medium.com/max/1600/1*7CQ1cPQcIOdIX_a_lYqiew.png)





这是我托管在 `GitHub Pages` 上的 [`SEO` 沙盒](https://pahund.github.io/seo-sandbox/)









![](https://cdn-images-1.medium.com/max/1600/1*Gt05ZDhSLvblN6MSmZ3xSg.png)



我把这个网站的名字设定为 `"Argelpargel"`，因为这个词从未被 `Google` 收录过。



### 配置 `Google` 搜索终端

`Google` 为网站所有者提供了一份免费的套件工具叫做 [Google 搜索终端](https://www.google.com/webmasters/tools)，它可以被用于测试他们的网站。

为了建立这个服务，我为这个网站增加一个称为 `property` 的东西:









![](https://cdn-images-1.medium.com/max/1600/1*nub51dXnRU6rkpDjU2tkvQ.png)





为了证明我就是这个网站的所有者，我不得不向 `Google` 上传一个特别的文件来找到这个网站。多亏了这个有用的方法 _npm rum deploy_，让我在很快的时间内就完成了。
 
### `Google` 眼中我们网站长什么样

环境配置完毕以后，我现在能使用 `"Fetch as Google"` 工具，用 `Googlebot` 的方式看看我们的 `SEO` 沙盒页面:








![](https://cdn-images-1.medium.com/max/1600/1*JEcIMWqYZUEud80zFUjppQ.png)






当我点击 `"Fetch and Render"` 按钮，就能检查到由 `React` 驱动的页面上哪一部分能真正被 `Googlebot` 检索到:









![](https://cdn-images-1.medium.com/max/1600/1*DSNHJvO_S2H3oAJHKiWkCw.png)





### 目前我所发现的

#### 发现 #1: `Googlebot` 以异步加载的形式来阅读内容

我想最先测试的是 `Googlebot` 会不会对异步渲染的内容进行检索或者爬取。

在页面被加载完毕后，我的 `React` 应用程序为数据发送了一个 `Ajax` 请求，并用这些数据更新了部分页面上的内容。

为了模拟这个过程，我为应用程序的组件增加了一个构造器，它通过使用一个 [window.setTimeout](https://developer.mozilla.org/en-US/docs/Web/API/WindowTimers/setTimeout) 方法为组件设定状态。

    constructor(props) {
        super(props);
        this.state = {
            choMessage: null,
            faq1: null,
            faq2: null,
            faq3: null
        };
        window.setTimeout(() => this.setState(Object.assign(this.state, {
            choMessage: 'yada yada'
        })), 10);
        window.setTimeout(() => this.setState(Object.assign(this.state, {
            faq1: 'bla bla'
        })), 100);
        window.setTimeout(() => this.setState(Object.assign(this.state, {
            faq2: 'shoo be doo'
        })), 1000);
        window.setTimeout(() => this.setState(Object.assign(this.state, {
            faq3: 'yacketiyack'
        })), 10000);
    }

→ [源代码已提交到 GitHub](https://github.com/pahund/seo-sandbox/blob/v1.0.0/src/App.js#L14)

我使用了 4 种超时时间，10 毫秒， 100 毫秒， 1 秒 和 10 秒。

结果表明，`Googlebot` 只会在 10 秒的超时时间上失败。但是其他 3 个超时时间都成功了，并且对应的文本块都会显示在 `"Fetch as Google"` 窗体内。









![](https://cdn-images-1.medium.com/max/1600/1*rsEVVsvrbTyOJtQHh24Xfg.png)





#### `React Router` 让 `Googlebot` 迷了眼

我把 [`React Router`](https://react-router.now.sh/) (version 4.0.0-alpha.5) 添加到网页应用程序中，它能创建一个菜单条加载不同的子页面（从他们的文档里直接复制粘贴过来）:









![](https://cdn-images-1.medium.com/max/1600/1*aZPZSQDC7WyneE2PcHRCvA.png)





太出乎意料了 - 当我点击了 `“Fecth As Google”`后，我只看到了一片绿色背景的页面:









![](https://cdn-images-1.medium.com/max/1600/1*nq4ujsqCxHz5zeMEuxuPoA.png)





以客户端渲染的界面使用 `React Router` 影响了搜索引擎的友好性。但这是否只是 `React Router 4` 上的问题仍旧需要观察，或者 `React Router 3` 稳定版本上也存在这样的问题。

### 下一步

以下是我想继续测试的内容:

* `Googlebot` 会沿着异步渲染文本块中的链接继续爬取内容么？
* 我能在 `React` 应用程序中异步地设定元标签，例如 _description_，并且让 `Googlebot` 理解它们么？
* `Googlebot` 需要花费多少时间才能爬取一个通过 `React` 渲染并且包含有很多很多的页面的网站？

我暂且抛砖引玉，请您不吝赐教！
