> * 原文地址：[Dynamic App Themes with CSS Variables and JavaScript 🎨](https://itnext.io/css-variables-dynamic-app-themes-86c0db61cbbb)
> * 原文作者：[Mike Wilcox](https://itnext.io/@mjw56?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/css-variables-dynamic-app-themes.md](https://github.com/xitu/gold-miner/blob/master/TODO1/css-variables-dynamic-app-themes.md)
> * 译者：
> * 校对者：

# Dynamic App Themes with CSS Variables and JavaScript 🎨

![](https://cdn-images-1.medium.com/max/1000/1*tZ4wAfvhrQpuzvM-pZkkmg.jpeg)

Hello there! In this post I’d like to discuss my approach for creating a dynamic theme loader in a web app. I’ll talk a little bit about react, create-react-app, portals, sass, css variables and other fun things. Read on if this is something that interests you!

The app that I am working on is a music app that is a mini clone of Spotify. The client side code is [bootstrapped with create-react-app](https://reactjs.org/docs/create-a-new-react-app.html#create-react-app). I added sass support to the CRA setup with [node-sass-chokidar](https://github.com/michaelwayman/node-sass-chokidar).

![](https://cdn-images-1.medium.com/max/800/1*eONilVt2-KF6bpIu9OxhzQ.png)

sass integration

Adding sass to the CRA setup is not too difficult. I just had to install `node-sass-chokidar` and add a couple of scripts into the package.json file to tell it how to build the sass files and a watch them for re-compile during development. The `include-path` flag is to let it know where to look for files that are imported into sass files via `@import`. The full list of options is [here](https://github.com/michaelwayman/node-sass-chokidar#options).

With sass integration added, the next thing I did was start defining a list of colors that would be a base template for the app. It doesn’t have to be an exhaustive list, only the minimum colors needed for the base template. Next, I defined sections of the app where the colors would be used and gave them descriptive names. With these variables in place, they can then be applied to various components of the app that will define the theme of the app.

![](https://cdn-images-1.medium.com/max/800/1*4J5_zY1pkslb8GWLgpVdmA.png)

sass color variables

![](https://cdn-images-1.medium.com/max/800/1*bBXgZI-3qWHiW2k8IeoJhA.png)

sass theme variables

Here you can see I’ve defined a base set of color variables and applied them to the default sass theme variables. These theme variables will be used throughout the codebase’s stylesheets to apply the color palette to the app and give it life!

Next, I’ll need a way to easily update these variables on the fly. This is where [CSS variables](https://developer.mozilla.org/en-US/docs/Web/CSS/Using_CSS_variables) come into the picture.

![](https://cdn-images-1.medium.com/max/800/1*SgLF0GFzpFXgPZZrZkbgQg.png)

CSS Variables Browser Support

CSS Variables are a newer browser spec. It’s very close to 100% browser support. With this in mind, the app I am building is a prototype so I am not too worried about supporting older browsers here. That being said, there are some folks who have put out some [shims for IE](https://github.com/luwes/css-var-shim).

For my use case, I need to sync the SASS variables to CSS variables. To do this, I chose to use the [css-vars](https://github.com/malyw/css-vars) package.

![](https://cdn-images-1.medium.com/max/800/1*--j_jmZ8p1-2awwqDQleVw.png)

css-vars

I basically did the same thing for my app as described above in the `README` …

![](https://cdn-images-1.medium.com/max/800/1*IzkhVzxv991uNSMBBYK1Yg.png)

adding CSS variables support with SASS

With this now in place, I can use the CSS variables throughout my stylesheets instead of using SASS variables. The important line above is `$css-vars-use-native: true;` This is telling the `css-vars` package that the compiled CSS should compile to actual CSS variables. This will be important later for then needing to update them on the fly.

The next step is to add a “theme picker” to the app. For this, I wanted to have a little fun and chose to add a hidden menu. It gives it a little bit of an easter egg feel and just makes it more fun. I’m not overly concerned about proper UX for this — in the future I will probably move this out to make it more visible. But for now, let’s add a secret menu to the app that will be displayed when the user presses a certain combination of keys on the keyboard.

![](https://cdn-images-1.medium.com/max/800/1*0z13r6yik2WcRMiNoWHl8g.png)

Modal Container

This container will listen for the key combination `CTRL + E` and when it hears it, it will display the hidden menu modal. The `Modal` component here is a react portal …

![](https://cdn-images-1.medium.com/max/800/1*D3xwDmwtLh7xtP1hRyldGw.png)

Modal Portal

It attaches and detaches itself from the `modal-root` page element. With this in place, I can create the `Theme` component which contains the select menu to select a variety of different theme palettes.

![](https://cdn-images-1.medium.com/max/800/1*eozcDZ0mLiymtSeRlsxDLQ.png)

Theme Component

Here, I am importing a list of palettes which have color variables that match the variables we defined before. On selection, it is going to set the theme globally in the app state, and then it will call `updateThemeForStyle` which is a function that updates the CSS variables using JavaScript.

![](https://cdn-images-1.medium.com/max/800/1*DZ7v0KtJ41HtF7dvhEz0fQ.png)

Update CSS variables

This function takes the name of selected theme, finds the theme palette in the `themeOptions` and then for each property it updates the property on `html` element’s `style`.

The theme options is just a list of options that have the same variables as the variables that were defined for the CSS variables.

![](https://cdn-images-1.medium.com/max/800/1*-FaRopFYzpFdf7bjX7Xv8g.png)

Theme Options

With all of this in place, the theme selector can now update on the fly!

![](https://cdn-images-1.medium.com/max/800/1*crV1ujG7TsYXjB3LRbgGdw.gif)

Theme Selection

And here is the result, dynamic theme updates!

Here is the [commit](https://github.com/mjw56/wavves/commit/7fd2210c69617c33c4244d4755f1d33770d3c57d) where I added feature. The full codebase is [here](https://github.com/mjw56/wavves).

You can try out a working version of the app [here](https://wavves-amcsxyspgk.now.sh/). (requires premium spotify membership). And yes, if you press `CTRL + e` in the app, the hidden theme modal will display! 😄

Thank you for reading and happy hacking!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
