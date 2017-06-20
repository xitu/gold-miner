> * 原文地址：[webpack 3: Official Release!!](https://medium.com/webpack/webpack-3-official-release-15fd2dd8f07b)
> * 原文作者：[Sean T. Larkin](https://medium.com/@TheLarkInn)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

---

![](https://cdn-images-1.medium.com/max/1000/1*Ac4K68j43uSbvHnKZKfXPw.jpeg)

It’s finally here. And it’s beautiful.

# 🍾🚀 webpack 3: Official Release!! 🚀🍾

## Scope Hoisting, “magic comments”, and more!

After we released webpack v2, we made some promises to the community. We promised that we would deliver the features you voted for. Moreover, we promised to deliver them in a ***faster***, ***more stable*** release cycle.

No more year-long betas, no breaking changes between release candidates. We promised to do you right by***you,**** the community that makes webpack thrive.*

The webpack team is proud to announce that today we have released webpack 3.0.0!!! You can download or upgrade to it today!!

`npm install webpack@3.0.0 --save-dev`

or with

`yarn add webpack@3.0.0 --dev`

---

Migrating from webpack 2 to 3, should involve ***no effort beyond running the upgrade commands in your terminal.*** We marked this as a Major change because of internal breaking changes that could affect some plugins.

***So far we’ve seen 98% of users upgrade with no breaking functionality at all!!!***

### What’s new?

As we mentioned, we aimed to deliver the features that you [voted for](https://webpack.js.org/vote)! Because of the overwhelming GitHub contributions, support from our backers and sponsors, we have been able to hit each one. 😍

#### 🔬 Scope Hoisting 🔬

Scope Hoisting is the flagship feature of webpack 3. One of webpack’s trade-offs when bundling was that each module in your bundle would be wrapped in individual function closures. These wrapper functions made it slower for your JavaScript to execute in the browser. In comparison, tools like Closure Compiler and RollupJS ‘hoist’ or concatenate the scope of all your modules into one closure and allow for your code to have a faster execution time in the browser.

[![](https://ws4.sinaimg.cn/large/006tKfTcgy1fgrga21tuwj30jn0923zk.jpg)](https://twitter.com/tizmagik/status/876128847682523138?ref_src=twsrc%5Etfw&ref_url=https%3A%2F%2Fmedium.com%2Fmedia%2F4533845503a873853b93e6aaf0833c57%3FpostId%3D15fd2dd8f07b)

As of today, with webpack 3, you can **now add the following plugin to your configuration to enable scope hosting:**

    module.exports = {
      plugins: [
        new webpack.optimize.ModuleConcatenationPlugin()
      ]
    };

Scope Hoisting is specifically a feature made possible by ECMAScript Module syntax. Because of this webpack may fallback to normal bundling based on what kind of modules you are using, and [other conditions](https://medium.com/webpack/webpack-freelancing-log-book-week-5-7-4764be3266f5).

To stay informed on what triggers these fallbacks, we’ve added a `--display-optimization-bailout` cli flag that will tell you what caused the fallback.

[![](https://ws3.sinaimg.cn/large/006tKfTcgy1fgrgbhk955j30j806lt9e.jpg)](https://twitter.com/jeremenichelli/status/876527176606265344?ref_src=twsrc%5Etfw&ref_url=https%3A%2F%2Fmedium.com%2Fmedia%2F6663aed6525e9200886db81c9415337c%3FpostId%3D15fd2dd8f07b)

Because scope hoisting will remove function wrappers around your modules, you may see some small size improvements. However, the significant improvement will be how fast the JavaScript loads in the browser. If you have awesome before and after comparisons, feel free to respond with some data as we’d be honored to share it!

#### 🔮 ”Magic Comments” 🔮

When we introduced in webpack 2 the ability to use the dynamic import syntax ( `import()` ), users expressed their concerns that they could not create named chunks like they were able to with `require.ensure`.

We have now introduced what the community has coined “magic comments”, the ability to pass chunk name, [and more](https://medium.com/webpack/how-to-use-webpacks-new-magic-comment-feature-with-react-universal-component-ssr-a38fd3e296a) as an inline comment to your `import()` statements.

```
import(/* webpackChunkName: "my-chunk-name" */ 'module');
```

By using comments, we are able to stay true to the load specification, and still give you the great chunk naming features you love.
Although these are technically features we released in v2.4 and v2.6, we worked to stabilize and fix bugs for these features that have landed in v3. This now allows the dynamic import syntax to have the same flexibility as `require.ensure`.

[![](https://ws3.sinaimg.cn/large/006tKfTcgy1fgrgcvddj9j30ie0dodh5.jpg)](https://twitter.com/AdamRackis/status/872602076056088576/photo/1?ref_src=twsrc%5Etfw&ref_url=https%3A%2F%2Fmedium.com%2Fmedia%2Ffd3c12141eb0e7363d3e33feb528480c%3FpostId%3D15fd2dd8f07b)

To learn more information, see our [newest documentation guide on code-splitting](https://webpack.js.org/guides/code-splitting-async) that highlights these features!!!

### 😍 What’s next? 😍

We have quite a few features and enhancements that we are hoping to bring you!!! But to take control of the ones we should be working one, stop by our[* vote page, and upvote the features you would like to see!*](http://webpack.js.org/vote)

Here are some of those things we are hoping to bring you still:

- Better Build Caching
- Faster initial and incremental builds
- Better TypeScript experience
- Revamped Long term caching
- WASM Module Support
- Improve User Experience

### 🙇Thank you 🙇

All of our users, contributors, documentation writers, bloggers, sponsors, backers, and maintainers are all shareholders in helping us ensure webpack is successful for years to come.

For this, we thank you all. It is not possible without you and we can’t wait to share what is in store for the future!!

---

*No time to help contribute? Want to give back in other ways? ****Become a Backer or Sponsor to webpack by donating to our ***[***open collective***](http://opencollective.com/webpack)***.**** Open Collective not only helps support the Core Team, but also supports contributors who have spent significant time improving our organization on their free time! ❤*

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
