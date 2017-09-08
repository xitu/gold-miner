
> * 原文地址：[Managing CSS & JS in an HTTP/2 World](https://www.viget.com/articles/managing-css-js-http-2/)
> * 原文作者：[
Trevor Davis](https://www.viget.com/about/team/tdavis)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/managing-css-js-http-2.md](https://github.com/xitu/gold-miner/blob/master/TODO/managing-css-js-http-2.md)
> * 译者：
> * 校对者：

# Managing CSS & JS in an HTTP/2 World

Delivering CSS & JS on your websites is completely different with HTTP/2, and here is a guide on how I've done it.

We have been hearing about HTTP/2 for years now. We've even [blogged](https://www.viget.com/articles/getting-started-with-http-2-part-1) [a little bit](https://www.viget.com/articles/getting-started-with-http-2-part-2) about it. But we hadn't really done much with it. Until now. On a few recent projects, I made it a goal to use HTTP/2 and figure out how to best utilize [multiplexing](https://http2.github.io/faq/#why-is-http2-multiplexed). This post isn't necessarily going to cover why you should use HTTP/2, but it's going to discuss how I've been managing CSS & JS to account for this paradigm shift.

## Breaking Up The CSS

This is the opposite of what we have done as best practice for years now. But in order to take advantage of multiplexing, it's best to break up your CSS into smaller files so that only the necessary CSS is loaded on each page. An example page markup would look something like this:

```html
<html>
<head>
	<!-- Global CSS used on every page, header/footer/etc -->
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

Yes, those are `<link>` tags in the `<body>`. But, don't be alarmed, there is [nothing in the spec disallowing it](https://html.spec.whatwg.org/multipage/semantics.html#allowed-in-the-body). So for each little block of markup, you can have a separate stylesheet that contains only the CSS for that specific markup. Assuming you are building your pages in a modular fashion, this is really easy to set up.

### Managing Files with SCSS

After some experimentation, here is the SCSS file structure I ended up with:

![](https://static.viget.com/blog/_736xAUTO_crop_center-center/http2-assets-stylesheets.png?mtime=20170823121853)

**CONFIG FOLDER**

I use this folder to set a bunch of variables.

![](https://static.viget.com/blog/_1064xAUTO_crop_center-center/http2-assets-config.png?mtime=20170823122448)

The main file in here is the `_index.scss` file, and it gets imported to every other SCSS file so that I have access to variables and mixins. That file looks like this:

```css
@import "variables";
@import "../functions/*";
```

**FUNCTIONS FOLDER**

This folder is pretty self explanatory; it contains custom mixins and functions, one file per mixin or function.

![](https://static.viget.com/blog/_1164xAUTO_crop_center-center/http2-assets-functions.png?mtime=20170823122756)

**GLOBAL FOLDER**

This folder is where I include CSS that is used on every page. This is good for stuff like the site's header, footer, reset, fonts, and other generic styling.

![](https://static.viget.com/blog/_1064xAUTO_crop_center-center/http2-assets-global.png?mtime=20170823150006)

The `index.scss` looks like this:

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

The final line is importing the entire components sub-folder, which is just an easy way to break up additional global styling into more manageable chunks.

**MODULES FOLDER**

This is the most important folder to our HTTP/2 setup. Since I am breaking up the stylesheets into module specific CSS, this folder will contain many, many files. So I start by breaking each module into a sub-folder.

![](https://static.viget.com/blog/_1432xAUTO_crop_center-center/http2-assets-entry-list.png?mtime=20170823150741)

Then, the `index.scss` file for each module looks like this:

```
// Pull in all global variables and mixins
@import "../../config/index";

// Pull in all partials in this module's folder
@import "_*.scss";
```

So I have access to the variables and mixins, and then I can break apart the module CSS into however many partials that are desired, and they all get combined into a single module CSS file.

**PAGES FOLDER**

This is virtually the same as the modules folder, but I use it for page specific content. It's definitely rarer since most of the stuff we build these days is built more modularly, but it's nice to have page specific CSS broken out separately.

![](https://static.viget.com/blog/_1150xAUTO_crop_center-center/http2-assets-pages.png?mtime=20170823150703)

### Tweaks to Blendid

Pretty much every project we start these days uses [Blendid](https://github.com/vigetlabs/blendid) for the build process. In order to get this SCSS setup described above, I need to add the [node-sass-glob-importer](https://www.npmjs.com/package/node-sass-glob-importer) package. Once I've got that installed, I just need to add it to the Blendid `task-config.js`.

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

And boom, I've got an HTTP/2 setup for managing CSSS.

### Bonus: Craft Macro

We've been advocates of [Craft](https://www.viget.com/articles/why-we-love-craft-cms) for a long time here at Viget, and I made a little macro to make it less repetitive to include stylesheets in this manner:

```
{%- macro css(stylesheet) -%}
	<link rel="stylesheet" href="/stylesheets{{ stylesheet }}/index.css" media="not print">
{%- endmacro -%}
```

When I want to include a module's CSS file, I can just do this:

```
{{ macros.css('/modules/image-block') }}
```

That's quite a bit simpler if I need to drop in stylesheet references throughout the site.

## Managing JS

So, just as I did with CSS, I want to break the JS into separate modules so that only the necessary JS is loaded per page. Again, using the [Blendid setup](https://github.com/vigetlabs/blendid), I just need to make a few tweaks to get everything working correctly.

Instead of using Webpack's `require()`, I need to use `import()`. So the `modules/index.js` file now needs to look like this:

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

As noted in the Webpack documentation: "This feature relies on Promise internally. If you use `import()` with older browsers, remember to shim Promise using a polyfill such as es6-promise or promise-polyfill."

So I can easily drop in the [es6-promise polyfill](https://www.npmjs.com/package/es6-promise) into my main `app.js` file and have it polyfill automatically:

```
require('es6-promise/auto');
```

That's really it. Then you can use the same pattern mentioned in the Blendid out of the box setup to trigger module specific JS.

```
<div data-module="carousel">
```

## Is this perfect?

Nope. But it at least gets you to a place where you can start managing HTTP/2 assets in a sane way. I fully expect that this setup will evolve over time as we consider how to break code apart to best utilize HTTP/2.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
