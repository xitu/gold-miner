
> * 原文地址：[Managing CSS & JS in an HTTP/2 World](https://www.viget.com/articles/managing-css-js-http-2/)
> * 原文作者：[
Trevor Davis](https://www.viget.com/about/team/tdavis)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/managing-css-js-http-2.md](https://github.com/xitu/gold-miner/blob/master/TODO/managing-css-js-http-2.md)
> * 译者：[sunui](https://github.com/sunui)
> * 校对者：[Usey95](https://github.com/Usey95)、[alfred-zhong](https://github.com/alfred-zhong)

# 在 HTTP/2 的世界里管理 CSS 和 JS

使用了 HTTP/2，在网站中传输 CSS 和 JS 将变得完全不同，本文是结合我实践的一份指南。

我们已经听说 HTTP/2 很多年了。我们甚至写了[一些](https://www.viget.com/articles/getting-started-with-http-2-part-1)[关于它的博客](https://www.viget.com/articles/getting-started-with-http-2-part-2)。但我们的真正实践并不多。一直到现在。在一些最近的项目中，我把使用 HTTP/2 作为一个目标，并弄清楚如何更好地应用[多路复用](https://http2.github.io/faq/#why-is-http2-multiplexed)。本文并不会主要去讲你为什么应该使用 HTTP/2，而是要讨论我是如何管理 CSS 和 JS 的从而解释这一范式转变。

## 拆分 CSS

这是我们多年来作为最佳实践的反例。但为了汲取多路复用的好处，最好的方式还是把你的 CSS 拆分成更小的文件，这样在每一页只加载必要的CSS。应该像这个例子这样：

```html
<html>
<head>
	<!--每一页都是用的全局样式， header/footer/etc -->
	<link href="stylesheets/global/index.css" rel="stylesheet">
</head>
<body>

	<link href="stylesheets/modules/text-block/index.css" rel="stylesheet">
	<div class="text-block">
		...
	</div>

	<link href="stylesheets/modules/two-column-block/index.css" rel="stylesheet">
	<div class="two-column-block">
		...
	</div>

	<link href="stylesheets/modules/image-promos-block/index.css" rel="stylesheet">
	<div class="image-promos-block">
		...
	</div>

</body>
</html>
```

没错，`<link>` 标签放在了 `<body>` 内部，但不必惊慌,这完全[合规](https://html.spec.whatwg.org/multipage/semantics.html#allowed-in-the-body)。因此对于每一个小的标签块，都可以拥有一个独立的只包含相应 CSS 的样式。假如你正在使用模块化风格构建你的页面，这很容易设置。

### 管理 SCSS 文件

经过一些实践，这是我整理的 SCSS 文件结构：

![](https://static.viget.com/blog/_736xAUTO_crop_center-center/http2-assets-stylesheets.png?mtime=20170823121853)

**CONFIG 文件夹**

我使用这个文件夹设置一堆变量：

![](https://static.viget.com/blog/_1064xAUTO_crop_center-center/http2-assets-config.png?mtime=20170823122448)

这里的入口文件是 `_index.scss`，它引入了所有其他 SCSS 文件，所以我可以访问到一些变量和 mixins。它是这样的：

```css
@import "variables";
@import "../functions/*";
```

**FUNCTIONS 文件夹**

顾名思义，它包含了一些常见的 mixins 和函数，每一个 mixin 或函数都对应一个文件。

![](https://static.viget.com/blog/_1164xAUTO_crop_center-center/http2-assets-functions.png?mtime=20170823122756)

**GLOBAL 文件夹**

这个文件夹包含我每一页都使用的 CSS。特别适合放一些类似网站的 header、footer、reset、字体和其他通用样式之类的东西。

![](https://static.viget.com/blog/_1064xAUTO_crop_center-center/http2-assets-global.png?mtime=20170823150006)

`index.scss` 看起来是这样的:

```css
@import "../config/index";
@import "_fonts.scss";
@import "_reset.scss";
@import "_base.scss";
@import "_utility.scss";
@import "_skip-link.scss";
@import "_header.scss";
@import "_content.scss";
@import "_footer.scss";
@import "components/*";
```

最后一行引入了所有 components 的子目录，这是将额外全局样式模块化的捷径。

**MODULES 文件夹**

这是我们 HTTP/2 体系中最重要的文件夹。当我拆分样式到对应的模块，这个文件夹会包含非常非常多的文件。所以我从拆分每一个模块到子目录开始：

![](https://static.viget.com/blog/_1432xAUTO_crop_center-center/http2-assets-entry-list.png?mtime=20170823150741)

每个模块中的 `index.scss` 是这样的：

```
// 导入所有的全局变量和 mixin
@import "../../config/index";

// 导入这个模块文件夹中的所有部分
@import "_*.scss";
```

这样我可以访问到变量和 mixin，然后我可以把模块的 CSS 拆分为许多部分，它们组合成一个单独的 CSS 模块文件。

**PAGES 文件夹**

实质上这个文件夹和 modules 文件夹一样，但我为了页面特定的内容使用它”。这种更模块化的方式在我们最近做的东西里绝对罕见，但是它很好地把页面的特殊样式拆分出来了。

![](https://static.viget.com/blog/_1150xAUTO_crop_center-center/http2-assets-pages.png?mtime=20170823150703)

### 适配 Blendid

最近所有的项目我们都是用 [Blendid](https://github.com/vigetlabs/blendid) 来构建的 。为了实现上文描述的 SCSS 配置，我需要添加 [node-sass-glob-importer](https://www.npmjs.com/package/node-sass-glob-importer)。一旦装好它，我只需把它添加到 Blendid 的 `task-config.js` 中。

```
var globImporter = require('node-sass-glob-importer');

module.exports = {
	stylesheets: {
		...
		sass: {
			importer: globImporter()
		},
  		...
}
```

duang，这样就完成了管理 SCSS 的 HTTP/2 配置。 

### 彩蛋：Craft 宏

很长一段时间以来，我们在 Viget 都主张使用 Craft，我就写了一个宏来减少这种引入样式的方式：

```
{%- macro css(stylesheet) -%}
	<link rel="stylesheet" href="/stylesheets{{ stylesheet }}/index.css" media="not print">
{%- endmacro -%}
```

当我想要引入一个模块的 CSS 文件，我只需这样：

```
{{ macros.css('/modules/image-block') }}
```

如果我需要在整个网站上放置样式表引用，这就更简单了。


## 管理 JS

就像 CSS 一样，我想要把 JS 拆分为模块，这样每一页只加载必要的 JS。一样的，使用 [Blendid 配置](https://github.com/vigetlabs/blendid)，为了一切正常运转我只需要做一点点微调。

我使用的是 `import()`，而非 Webpack 的`require()`，。因此现在的 `modules/index.js` 文件需要看起来是这样的：

```
const moduleElements = document.querySelectorAll('[data-module]');

for (var i = 0; i < moduleElements.length; i++) {
	const el = moduleElements[i];
	const name = el.getAttribute('data-module');

	import(`./${name}`).then(Module => {
		new Module.default(el);
	});
}
```

正如 Webpack 文档中所说：”这个特性内部依赖 Promise。如果你在旧版本浏览器使用 `import()`，记得使用一个 polyfill 来兼容 Promise，比如 es6-promise 或者 promise-polyfill“。

因此我把 [es6-promise polyfill](https://www.npmjs.com/package/es6-promise) 加入到我的入口文件 `app.js` 中，使其自动兼容。


```
require('es6-promise/auto');
```

是的，然后你就可以在 Blendid 开箱即用的模式触发模块生成对应特定的 JS。

```
<div data-module="carousel">
```

## 这很完美吗？

还不,但至少可以引领你开始以合理的方式管理 HTTP/2 资源。随着我们对如何拆分代码来更好地使用 HTTP/2 的思考，我真切地希望这个配置将会越来越完善。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
