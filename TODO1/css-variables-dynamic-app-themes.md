> * 原文地址：[Dynamic App Themes with CSS Variables and JavaScript 🎨](https://itnext.io/css-variables-dynamic-app-themes-86c0db61cbbb)
> * 原文作者：[Mike Wilcox](https://itnext.io/@mjw56?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/css-variables-dynamic-app-themes.md](https://github.com/xitu/gold-miner/blob/master/TODO1/css-variables-dynamic-app-themes.md)
> * 译者：https://github.com/CoolRice
> * 校对者：

# CSS 变量和 JavaScript 让应用支持动态主题 🎨

![](https://cdn-images-1.medium.com/max/1000/1*tZ4wAfvhrQpuzvM-pZkkmg.jpeg)

大家好！在这篇文章中我准备讲一讲我在 Web 应用中创建动态主题加载器的方法。我会讲一点关于 react、create-react-app、portals、sass、css 变量还有其它有意思的东西。如果你对此感兴趣，请继续阅读！

我正在开发的应用是一个音乐应用程序，它是 Spotify 的迷你克隆版。前端代码[基于 create-react-app](https://reactjs.org/docs/create-a-new-react-app.html#create-react-app)。添加了 [node-sass-chokidar](https://github.com/michaelwayman/node-sass-chokidar) 使得 CRA 支持 sass。

![](https://cdn-images-1.medium.com/max/800/1*eONilVt2-KF6bpIu9OxhzQ.png)

整合 sass

给 CRA 添加 sass 并不困难。我仅仅需要安装 `node-sass-chokidar` 然后在 package.json 文件添加一些脚本，这些脚本告诉 `node-sass-chokidar` 怎样去编译 sass 文件并且在开发时能够监视文件变化以再次编译。`include-path` 标志让 `node-sass-chokidar` 知道去哪寻找通过 `@import` 引入的 sass 文件。[这里](https://github.com/michaelwayman/node-sass-chokidar#options)有一份完整的选项清单。

整合 sass 之后，我接下来要做的是定义一个颜色列表，它会成为应用程序的基本模板。这个列表用不着非常详细，只需要有基本模板所需最少的颜色就行。接下来，我定义那些使用颜色的部分，并为它们提供了描述性的名字。有了这些变量，它们就可以应用于应用程序的各种组件，这些组件会定义应用的主题。

![](https://cdn-images-1.medium.com/max/800/1*4J5_zY1pkslb8GWLgpVdmA.png)

sass 颜色变量

![](https://cdn-images-1.medium.com/max/800/1*bBXgZI-3qWHiW2k8IeoJhA.png)

sass 主题变量

在这里，可以看到我已经定义了一组基本颜色变量，并将它们应用于默认的sass主题变量。这些主题变量会贯穿整个代码库的样式表，以将调色板应用到程序并赋予它生命！

下面，我需要一种简单的方法来动态更新这些变量。图片里的是[CSS 变量](https://developer.mozilla.org/en-US/docs/Web/CSS/Using_CSS_variables)。

![](https://cdn-images-1.medium.com/max/800/1*SgLF0GFzpFXgPZZrZkbgQg.png)

CSS 变量的浏览器支持

CSS 变量是一个较新的浏览器规范并且几乎 100% 浏览器支持。考虑到我正在构建的应用是一个原型程序，所以我没有过多考虑支持旧浏览器。话虽如此，还是有些人推出了一些[IE 补丁](https://github.com/luwes/css-var-shim)。

就我的用例来说，我需要将 SASS 变量同步到 CSS 变量。为此，我选择了使用 [css-vars](https://github.com/malyw/css-vars) 包。

![](https://cdn-images-1.medium.com/max/800/1*--j_jmZ8p1-2awwqDQleVw.png)

css-vars

正如上面在 `README` 中描述的那样，我对我的应用做了差不多的更改……

![](https://cdn-images-1.medium.com/max/800/1*IzkhVzxv991uNSMBBYK1Yg.png)

用 SASS 添加 CSS 变量支持

有了这个，我可以在我的样式表中使用 CSS 变量，而不是使用 SASS 变量。上面的重要一行是 `$css-vars-use-native: true;`，它告诉 css-vars 包编译的 CSS 应该编译为真正的 CSS 变量。这对于以后需要动态更新它们非常重要。

下一步要在应用中添加一个 “主题选择器”。对此，我希望能有多一点乐趣并选择添加了一个隐藏的菜单。这个隐藏的菜单有一点复活节彩蛋的感觉并且更加有趣。我并不太担心正确的用户体验 — 将来我可能会把这个菜单可视化。不过现在，让我们为应用程序添加一个秘密菜单，当用户按下键盘上的某个组合键时会显示这个菜单。

![](https://cdn-images-1.medium.com/max/800/1*0z13r6yik2WcRMiNoWHl8g.png)

模式容器

此容器将监听 `CTRL + E` 组合键，当它监听到事件时，显示隐藏的菜单。这个 `Modal` 组件其实是一个 react portal……

![](https://cdn-images-1.medium.com/max/800/1*D3xwDmwtLh7xtP1hRyldGw.png)

模式 Portal

模式 Portal 可以附着和脱离 `modal-root` 元素。有了它，我就可以创建 `Theme` 组件，这个组件拥有可以选择不同主题的菜单。

![](https://cdn-images-1.medium.com/max/800/1*eozcDZ0mLiymtSeRlsxDLQ.png)

主题组件

这里，我引入了一个拥有和之前定义的变量相匹配的调色板列表。列表在选择后会全局更新应用的状态，然后调用 `updateThemeForStyle` 使用来 Javascript 更新 CSS 变量。

![](https://cdn-images-1.medium.com/max/800/1*DZ7v0KtJ41HtF7dvhEz0fQ.png)

更新 CSS 变量

这个函数使用所选主题的名字在 `themeOptions` 中找到选中的主题调色板，然后更新 `html` 元素的 `style` 的每一个属性。

主题选项是一个选项列表，这个列表有着和 CSS 变量定义相同的变量。

![](https://cdn-images-1.medium.com/max/800/1*-FaRopFYzpFdf7bjX7Xv8g.png)

主题选项

有了所有的这些更改，主题选择器现在可以动态更新！

![](https://cdn-images-1.medium.com/max/800/1*crV1ujG7TsYXjB3LRbgGdw.gif)

主题选择

这是动态更新主题的效果！

这是我添加功能的[提交](https://github.com/mjw56/wavves/commit/7fd2210c69617c33c4244d4755f1d33770d3c57d)，完整的代码库请看[这里](https://github.com/mjw56/wavves)。

你可以[在此](https://wavves-amcsxyspgk.now.sh/)尝试一下这个应用的工作版。（需要 spotify 的高级会员）。对，如果你在应用中按下 `CTRL + e`，隐藏的主题选择模式就会显示！😄

感谢阅读，祝你玩得愉快！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
