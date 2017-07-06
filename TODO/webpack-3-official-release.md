> * 原文地址：[webpack 3: Official Release!!](https://medium.com/webpack/webpack-3-official-release-15fd2dd8f07b)
> * 原文作者：[Sean T. Larkin](https://medium.com/@TheLarkInn)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[xilihuasi](https://github.com/xilihuasi)
> * 校对者：[achilleo](https://github.com/achilleo)

---

![](https://cdn-images-1.medium.com/max/1000/1*Ac4K68j43uSbvHnKZKfXPw.jpeg)

终于来了，美妙极了。

# 🍾🚀 webpack 3：官方发布！！ 🚀🍾

## 作用域提升，“魔法注解”，以及其他更多特性！

在我们发布 webpack v2 之后，我们对社区做了一些许诺。我们承诺将在未来发布一些你们投票选出的特性。此外，我们的周期发布将会**更快**，**更稳定**。

不再有一年之久的测试版本，版本之间不再有爆炸性的变化。我们以**你们和社区让 webpack 更繁荣**的名义，保证你们行使自己的权利。

webpack 团队自豪地宣布，今天 webpack 3.0.0 发布啦！！！今天你就可以下载或更新！！

`npm install webpack@3.0.0 --save-dev`

或者

`yarn add webpack@3.0.0 --dev`

---

从 webpack 2 迁移到 3，应该 **只需在 terminal 中执行升级命令。** 因为内部的重大改变可能会影响一些插件，我们把这项特性作为重要更新收录了。

**目前为止98% 的用户在升级后没有影响原有功能的使用**

### 有哪些更新？

正如前面提到的，我们旨在发布你们[投票选出](https://webpack.js.org/vote)的那些特性！由于 GitHub 上大量的贡献，以及来自我们支持者和赞助商的支持，我们已经有实现所有这些特性的能力。 😍

#### 🔬 作用域提升 🔬

作用域提升是 webpack 3 的主要功能。之前版本的 webpack 在打包时的一个妥协是包里面的每个模块都会被包装到一个独立的函数闭包中。这些包装函数使你在浏览器中执行的 JavaScript 代码变得更慢。相比之下，例如 Closure Compiler 和 RollupJs 这样的工具把所有模块的作用域‘提升’或者串联在一个闭包，并且使你的代码在浏览器中有更快的执行时间。

[![](https://ws4.sinaimg.cn/large/006tKfTcgy1fgrga21tuwj30jn0923zk.jpg)](https://twitter.com/tizmagik/status/876128847682523138?ref_src=twsrc%5Etfw&ref_url=https%3A%2F%2Fmedium.com%2Fmedia%2F4533845503a873853b93e6aaf0833c57%3FpostId%3D15fd2dd8f07b)

直至今天，使用 webpack 3，你可以**马上把如下插件添加到你的配置中来启用作用域提升：**

    module.exports = {
      plugins: [
        new webpack.optimize.ModuleConcatenationPlugin()
      ]
    };

具体而言，作用域提升是一个基于 ECMAScript Module 语法的特性。正因如此，webpack 可能会根据你使用的模块种类，以及[其他条件](https://medium.com/webpack/webpack-freelancing-log-book-week-5-7-4764be3266f5)回退到普通的打包方式。

为了随时了解什么触发了这些回退，我们添加了一个 `--display-optimization-bailout` 命令行标志来告诉你什么因素导致了这些回退。

[![](https://ws3.sinaimg.cn/large/006tKfTcgy1fgrgbhk955j30j806lt9e.jpg)](https://twitter.com/jeremenichelli/status/876527176606265344?ref_src=twsrc%5Etfw&ref_url=https%3A%2F%2Fmedium.com%2Fmedia%2F6663aed6525e9200886db81c9415337c%3FpostId%3D15fd2dd8f07b)

因为作用域提升将移除模块的函数包装，你将会看到文件大小的少量精简。然而，更显著的提升在于，浏览器加载 JavaScript 的时候有多么迅速。如果你在做了比较之后感到很爽，或者自由地获取数据响应，那就快去跟朋友分享吧！

#### 🔮 ”魔法注解” 🔮

当我们在 webpack 2 中介绍动态引入语法（ `import()` ）的使用时，用户们担心他们不能像使用 `require.ensure` 一样创建命名块。

我们现在已经采用了社区创造的“魔法注解”，拥有传递块名的能力，[以及其他](https://medium.com/webpack/how-to-use-webpacks-new-magic-comment-feature-with-react-universal-component-ssr-a38fd3e296a)就像 `import()` 语句的行内注释。


```
import(/* webpackChunkName: "my-chunk-name" */ 'module');
```

通过使用注解，我们可以保证加载的规范，并且仍然提供你喜欢的块命名特性。虽然这些技术性的特性我们已经在 v2.4 和 v2.6 中发布了，我们努力提升稳定性及修复 bug 来保证这些特性在 v3 中正式落地。现在已经可以使用和 `require.ensure` 一样灵活的动态引入语法了。

[![](https://ws3.sinaimg.cn/large/006tKfTcgy1fgrgcvddj9j30ie0dodh5.jpg)](https://twitter.com/AdamRackis/status/872602076056088576/photo/1?ref_src=twsrc%5Etfw&ref_url=https%3A%2F%2Fmedium.com%2Fmedia%2Ffd3c12141eb0e7363d3e33feb528480c%3FpostId%3D15fd2dd8f07b)

想要了解更多资讯，来看我们的[代码拆分的最新文档指南](https://webpack.js.org/guides/code-splitting-async)详细了解这些特性！！！

### 😍 然后呢？ 😍

我们还有一些特性和功能加强希望提供给你们！！！但是饭得一口一口吃，事情要一件一件做，在我们的[**投票页面，给投那些你想看到的特性吧！**](http://webpack.js.org/vote)

这里还有一些我们仍然想提供给你们的东西：

- 更好地构建缓存
- 更快的初始和增量版本
- 更好的 TypeScript 体验
- 改进长期缓存
- MASM 模块支持
- 提升用户体验


### 🙇 感谢 🙇

所有我们的用户、贡献者、文档作者、博客主、赞助商、支持者和维护者，都是这些年来帮助我们保证 webpack 成功的投资人。

为此，感谢你们所有人。是你们使这些成为了可能，我们已经迫不及待跟你们分享未来我们还有哪些黑科技了！！

---

**没时间帮助贡献？想用其他方式回馈？我们的 [open collective](http://opencollective.com/webpack)。Open Collective 不仅支撑整个核心团队，而且还帮助那些在业余时间花了大量时间来提升我们组织的贡献者们！ ❤**

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
