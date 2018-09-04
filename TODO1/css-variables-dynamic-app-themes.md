> * 原文地址：[Dynamic App Themes with CSS Variables and JavaScript 🎨](https://itnext.io/css-variables-dynamic-app-themes-86c0db61cbbb)
> * 原文作者：[Mike Wilcox](https://itnext.io/@mjw56?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/css-variables-dynamic-app-themes.md](https://github.com/xitu/gold-miner/blob/master/TODO1/css-variables-dynamic-app-themes.md)
> * 译者：
> * 校对者：

# Dynamic App Themes with CSS Variables and JavaScript 🎨
# 用 CSS 变量和 JavaScript 动态设置应用主题 🎨

![](https://cdn-images-1.medium.com/max/1000/1*tZ4wAfvhrQpuzvM-pZkkmg.jpeg)

Hello there! In this post I’d like to discuss my approach for creating a dynamic theme loader in a web app. I’ll talk a little bit about react, create-react-app, portals, sass, css variables and other fun things. Read on if this is something that interests you!
大家好！在这篇文章中我想讨论我在Web应用程序中创建动态主题加载器的方法。我会讲解一点关于 react，create-react-app，portals，sass，css 变量和其他有意思的东西。如果这是你感兴趣的内容，请继续阅读！

The app that I am working on is a music app that is a mini clone of Spotify. The client side code is [bootstrapped with create-react-app](https://reactjs.org/docs/create-a-new-react-app.html#create-react-app). I added sass support to the CRA setup with [node-sass-chokidar](https://github.com/michaelwayman/node-sass-chokidar).
我正在开发的应用是一个音乐应用程序，它是Spotify的迷你克隆版。前端代码基于[bootstrapped with create-react-app](https://reactjs.org/docs/create-a-new-react-app.html#create-react-app)。添加了[node-sass-chokidar](https://github.com/michaelwayman/node-sass-chokidar)来让 CRA 支持 sass。

![](https://cdn-images-1.medium.com/max/800/1*eONilVt2-KF6bpIu9OxhzQ.png)

sass integration
整合 sass

Adding sass to the CRA setup is not too difficult. I just had to install `node-sass-chokidar` and add a couple of scripts into the package.json file to tell it how to build the sass files and a watch them for re-compile during development. The `include-path` flag is to let it know where to look for files that are imported into sass files via `@import`. The full list of options is [here](https://github.com/michaelwayman/node-sass-chokidar#options).
给 CRA 添加 sass 并不困难。我仅仅需要安装 `node-sass-chokidar` 然后在 package.json 文件添加一些脚本，这些脚本来告诉 `node-sass-chokidar` 怎样去编译 sass 文件并且在开发时监视文件变化以再次编译。`include-path` 标志让 `node-sass-chokidar` 知道去哪寻找通过 `@import` 引入的 sass 文件。[这里](https://github.com/michaelwayman/node-sass-chokidar#options)有一份完整的选项清单。

With sass integration added, the next thing I did was start defining a list of colors that would be a base template for the app. It doesn’t have to be an exhaustive list, only the minimum colors needed for the base template. Next, I defined sections of the app where the colors would be used and gave them descriptive names. With these variables in place, they can then be applied to various components of the app that will define the theme of the app.
整合 sass 之后，我接下来要做的是开始定义一个颜色列表，它将成为应用程序的基本模板。它不必是一个详尽的列表，只需要基本模板所需的最少颜色。接下来，我定义了应用程序中使用颜色的部分，并为它们提供了描述性的名称。有了这些变量，它们就可以应用于应用程序的各种组件，这些组件将决定应用程序的主题。

![](https://cdn-images-1.medium.com/max/800/1*4J5_zY1pkslb8GWLgpVdmA.png)

sass 颜色变量

![](https://cdn-images-1.medium.com/max/800/1*bBXgZI-3qWHiW2k8IeoJhA.png)

sass 主题变量

Here you can see I’ve defined a base set of color variables and applied them to the default sass theme variables. These theme variables will be used throughout the codebase’s stylesheets to apply the color palette to the app and give it life!
在这里，可以看到我已经定义了一组基本颜色变量，并将它们应用于默认的sass主题变量。这些主题变量将贯穿整个代码库的样式表，以将调色盘应用到应用程序并赋予它生命！

Next, I’ll need a way to easily update these variables on the fly. This is where [CSS variables](https://developer.mozilla.org/en-US/docs/Web/CSS/Using_CSS_variables) come into the picture.
下面，我需要一种方法来动态更新这些变量。图片里的是[CSS 变量](https://developer.mozilla.org/en-US/docs/Web/CSS/Using_CSS_variables)。

![](https://cdn-images-1.medium.com/max/800/1*SgLF0GFzpFXgPZZrZkbgQg.png)

CSS 变量的浏览器支持

CSS Variables are a newer browser spec. It’s very close to 100% browser support. With this in mind, the app I am building is a prototype so I am not too worried about supporting older browsers here. That being said, there are some folks who have put out some [shims for IE](https://github.com/luwes/css-var-shim).
CSS 变量是一个较新的浏览器规范并且非常接近100％的浏览器支持。考虑到这一点，因为我正在构建的应用是一个原型程序，因此在这里我不太担心支持旧浏览器。话虽如此，还是有些人推出了一些[IE 补丁](https://github.com/luwes/css-var-shim)。

For my use case, I need to sync the SASS variables to CSS variables. To do this, I chose to use the [css-vars](https://github.com/malyw/css-vars) package.
就我的用例来说，我需要将 SASS 变量同步到 CSS 变量。为此，我选择使用[css-vars](https://github.com/malyw/css-vars)包。

![](https://cdn-images-1.medium.com/max/800/1*--j_jmZ8p1-2awwqDQleVw.png)

css-vars

I basically did the same thing for my app as described above in the `README` …
正如上面在README中描述的那样我对我的应用基本上做了同样的事情……

![](https://cdn-images-1.medium.com/max/800/1*IzkhVzxv991uNSMBBYK1Yg.png)

adding CSS variables support with SASS
使用 SASS 添加 CSS 变量支持

With this now in place, I can use the CSS variables throughout my stylesheets instead of using SASS variables. The important line above is `$css-vars-use-native: true;` This is telling the `css-vars` package that the compiled CSS should compile to actual CSS variables. This will be important later for then needing to update them on the fly.
有了这个，我可以在我的样式表中使用 CSS 变量，而不是使用 SASS 变量。上面的重要一行是 `$css-vars-use-native: true;`，这告诉 css-vars 包，编译的 CSS 应该编译为实际的 CSS 变量。这对于以后需要动态更新它们非常重要。

The next step is to add a “theme picker” to the app. For this, I wanted to have a little fun and chose to add a hidden menu. It gives it a little bit of an easter egg feel and just makes it more fun. I’m not overly concerned about proper UX for this — in the future I will probably move this out to make it more visible. But for now, let’s add a secret menu to the app that will be displayed when the user presses a certain combination of keys on the keyboard.
下一步要在应用中添加一个 “主题选择器”。对此，我希望有一点乐趣并选择添加了一个隐藏的菜单。它有一点复活节彩蛋的感觉并且更加有趣。我并不过于担心正确的用户体验 — 将来我可能会把这个菜单变得可视化。但现在，让我们为应用程序添加一个当用户按下键盘上的某个组合键时将显示的秘密菜单。

![](https://cdn-images-1.medium.com/max/800/1*0z13r6yik2WcRMiNoWHl8g.png)

Modal Container
模式容器

This container will listen for the key combination `CTRL + E` and when it hears it, it will display the hidden menu modal. The `Modal` component here is a react portal …
此容器将监听 `CTRL + E` 组合键，当它监听到时，显示隐藏的菜单。这个 `Modal` 组件是一个 react portal……

![](https://cdn-images-1.medium.com/max/800/1*D3xwDmwtLh7xtP1hRyldGw.png)

Modal Portal
模式 Portal

It attaches and detaches itself from the `modal-root` page element. With this in place, I can create the `Theme` component which contains the select menu to select a variety of different theme palettes.
模式 Portal 可以附着和脱离 `modal-root` 元素。有了它，我就可以创建 `Theme` 组件，这个组件拥有可以选择不同主题的菜单。

![](https://cdn-images-1.medium.com/max/800/1*eozcDZ0mLiymtSeRlsxDLQ.png)

Theme Component
主题组件

Here, I am importing a list of palettes which have color variables that match the variables we defined before. On selection, it is going to set the theme globally in the app state, and then it will call `updateThemeForStyle` which is a function that updates the CSS variables using JavaScript.
这里，我引入了一个拥有和之前定义的变量相匹配的调色板的列表。列表在选择后会全局更新应用的状态，然后调用 `updateThemeForStyle` 通过 Javascript 更新 CSS 变量。

![](https://cdn-images-1.medium.com/max/800/1*DZ7v0KtJ41HtF7dvhEz0fQ.png)

Update CSS variables
更新 CSS 变量

This function takes the name of selected theme, finds the theme palette in the `themeOptions` and then for each property it updates the property on `html` element’s `style`.
这个函数用所选主题的名字在 `themeOptions` 中找到选中的主题调色板，然后更新 `html` 元素的 `style` 的每一个属性。

The theme options is just a list of options that have the same variables as the variables that were defined for the CSS variables.
theme options 仅仅是一个选项列表，这个列表有着和 CSS 变量定义相同的变量。

![](https://cdn-images-1.medium.com/max/800/1*-FaRopFYzpFdf7bjX7Xv8g.png)

Theme Options
主题选项

With all of this in place, the theme selector can now update on the fly!
有了所有所有这些，主题选择器现在可以动态更新！

![](https://cdn-images-1.medium.com/max/800/1*crV1ujG7TsYXjB3LRbgGdw.gif)

Theme Selection
主题选择

And here is the result, dynamic theme updates!
这是动态主题更新的结果！

Here is the [commit](https://github.com/mjw56/wavves/commit/7fd2210c69617c33c4244d4755f1d33770d3c57d) where I added feature. The full codebase is [here](https://github.com/mjw56/wavves).
这是我添加功能的[提交](https://github.com/mjw56/wavves/commit/7fd2210c69617c33c4244d4755f1d33770d3c57d)，完整的代码库请看[这里](https://github.com/mjw56/wavves)。

You can try out a working version of the app [here](https://wavves-amcsxyspgk.now.sh/). (requires premium spotify membership). And yes, if you press `CTRL + e` in the app, the hidden theme modal will display! 😄
你可以[在此](https://wavves-amcsxyspgk.now.sh/)尝试一下这个应用的工作版。（需要 spotify 的高级会员）。并且如果你在应用中按下 `CTRL + e`，隐藏的主题选择模式就会显示！😄
Thank you for reading and happy hacking!
感谢阅读，祝你玩得愉快！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
