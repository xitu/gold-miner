> * 原文地址：[Packaging a UI Library for Distribution](https://blog.bitsrc.io/packaging-a-ui-library-for-distribution-d153219def28)
> * 原文作者：[Tally Barak](https://medium.com/@tally_b)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/packaging-a-ui-library-for-distribution.md](https://github.com/xitu/gold-miner/blob/master/article/2020/packaging-a-ui-library-for-distribution.md)
> * 译者：[plusmultiply0](https://github.com/plusmultiply0)
> * 校对者：[zenblo](https://github.com/zenblo)、[rocwong-cn](https://github.com/rocwong-cn)

# 打包用于分发的 UI 库 —— 当你要发布一个 UI 组件库时，你可能需要遵守的指南

![Image by [Arek Socha](https://pixabay.com/users/qimono-1962238/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=1893642) from [Pixabay](https://pixabay.com/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=1893642)](https://cdn-images-1.medium.com/max/2560/1*EXcun_D11oz0ceMYlJ0yQA.jpeg)

## 问题的由来

JavaScript 有个特性：对于相同的代码，可以运行在多个运行时（runtime）环境。其中一个环境，是由众多厂商生产提供的不同版本的浏览器。而另一个，则是运行在服务器端的不同版本的 Nodejs。（附注：你可能需要注意一下 Deno，一个有趣的服务器端运行时环境）

经历了将近 20 年的蛰伏后，JavaScript 获得了巨大的发展势头，每天都有新的功能被添加到语言中。（好吧，应该是每年不是每天，但是这样修饰更恰当） 与此同时，新的 JS 风格，比如：TypeScript 和 Flow 的出现，为语言增加了额外的语法。

我们最终都要面对夹杂着其它语言特性的 JavaScript，多种执行环境以及不断发展的标准。所有这些导致以 Javascript 构建 UI 组件包然后与世界共享，并非易事。

任何人在发布一个库的时候都应该考虑库会被如何使用：以浏览器标签引入，在服务器端以 NPM 模块安装或者由 webpack 等打包工具编译后再提供给浏览器。

## 如何交付 package？

以下是我为你想要分发的 package 的格式提供的一些建议。在最后一部分，我们将通过一些工具来实现这些。

![mage by [Annalise Batista](https://pixabay.com/users/AnnaliseArt-7089643/?utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=image&amp;utm_content=5293336) from [Pixabay](https://pixabay.com/?utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=image&amp;utm_content=5293336) (modified)](https://cdn-images-1.medium.com/max/2560/1*xPmTGN5rwQH_IQ94TRIhmw.png)

我将在以下四个方面讨论 package 的交付。但值得注意的是，它们是互相关联的。

* ES 语法格式（ES Syntax Format）
* 模块格式（Module Format）
* 文件打包（Files Bundling）
* Package 分发（Package distribution）

你同样会注意到这里的讨论与框架无关。这里讨论的守则都是跨框架的，而且与用 Angular，React，Vue 编写的组件是无关的。

#### ES 语法格式（ES Syntax Format）

大多数的 web 浏览器和 Nodejs 都支持 ES2015 的语法，并且紧跟语言的新特性。其中臭名昭著的例外是 IE 浏览器，幸好它的市场份额正在不断缩减。 除非明确需要支持 IE11，否则的话，将 ES2015 视为 JS 环境的通用标准是可行的。 现代浏览器和 Nodejs 对于较新的语法（如：ES2017）也都是支持的。

建议：

> 在老的浏览器上使用 ES5，将 ES2015 或者 ES2017 用于现代浏览器和 NodeJS。

#### 模块格式（Module Format）

直到 2015 年，JavaScript（即众所周知的 ECMAScript ）才有了模块格式的规范 —— ES6 模块格式（也被称为 ESM，ES2015 模块）。 在这个混沌时期，社区创建了多种格式，但没有一个统一的标准可遵循。

用于支持浏览器和 NodeJS 的模块格式：

* AMD (Asynchronous Module Definition) —— Requirejs 中描述了在 2011 年开发它的原因，见[此处](https://requirejs.org/docs/whyamd.html)。
* CommonJS / CJS —— 开发用于服务器端的模块格式。
* UMD (Universal Module Definition) 结合 AMD 和 CJS 并支持浏览器和服务器端的模式。
* ESM / ES Modules / ES6 Modules / ES2015 modules —— 在 ES6 中引入的标准语法格式。在 NodeJS 14 中还是试验性质的支持，使用时需要带有标志（如：--experimental-modules）。

如下表格总结了各种模块格式间的一些差异：

![](https://cdn-images-1.medium.com/max/2000/1*ohOcheaTdGZpG4nnK97swg.png)

为了进一步感受模块格式之间的差异，我们来看一下将 Typescript 代码编译为不同的模块格式的结果。

![](https://cdn-images-1.medium.com/max/2000/1*X9Mvq1jM5-uw__W6WABTTQ.png)

建议：

> 使用多种模块格式来生成库，如：ESM，CJS，以及 UMD / AMD 。

#### 文件打包（Files Bundling）

用于浏览器或服务器端的应用的 NPM 包在分发时，可以提供一个包含多个文件的目录。服务器可以轻松地一一读取目录中的文件，而在浏览器端需要预先将整个应用打包为一个文件（或者几个 chunk）后才能使用。

为了能将代码通过 script 标签引入，你需要生成一个包含了所有库的代码的文件。使用单个文件可以提升打包工具的性能，因为这可以减少处理过程中磁盘访问的次数。

建议：

> 为浏览器提供使用 UMD 格式的单个文件，ESM / CJS 模块用单独文件夹或单个文件创建。

#### Package 分发（Package distribution）

大多数 package 在 NPM 注册表（registry）上都是可用的。这是一种常见的方法来发布 package。将 package 发布到 NPM 同样会使得 package 在 CDN 上可用，因此能直接用于浏览器（通过 script 标签）。

建议：

> 确保你的 package 提供了 UMD 格式，并且通过 unpkg 也是可用的。

注：新的 CDN 即将支持 ES 模块语法，具体请见[此处](https://www.pika.dev/)

## 工具

创建打包文件的工具有：

* 转译器（Transpilers）
* 打包工具（Bundlers）
* Manifest（如：package.json）

#### 转译器（Transpilers）

对于使用 ES 语法或者 Typescript 编写的代码，你应该使用 Babel 或者 Typescript 转译器。这两个转译器都支持 JS 和 TS 语法，但是有一些[区别](https://blog.logrocket.com/choosing-between-babel-and-typescript-4ed1ad563e41/#:~:text=TypeScript%20by%20default%20compiles%20an,that%20require%20reading%20multiple%20files.&text=A%20const%20enum%20is%20an%20enum%20that%20TypeScript%20compiles%20away%20to%20nothing)[.](https://blog.logrocket.com/choosing-between-babel-and-typescript-4ed1ad563e41/#:~:text=TypeScript%20by%20default%20compiles%20an,that%20require%20reading%20multiple%20files.&text=A%20const%20enum%20is%20an%20enum%20that%20TypeScript%20compiles%20away%20to%20nothing.)

**Babel** 包含有转换代码的转换插件，比如 [transform-modules-commonjs](https://babeljs.io/docs/en/babel-plugin-transform-modules-commonjs) 和 [transform-modules-umd](https://babeljs.io/docs/en/babel-plugin-transform-modules-umd)。他们会生成相关的模块格式。

**Typescript** 转译器，通过使用 tsconfig.json 中负责生成相关模块输出的 “module” 属性，也能生成不同模块格式。

#### 打包工具（Bundlers）

Bundlers 通常运行插件来执行转译过程。转译不仅包括语言和模块的转换，还会生成额外的资源文件如：CSS 和图片。

在 ES 模块语法下，使用 bundlers 的效果很好，因为这为 tree shaking 未使用的代码提供了极好的支持。

常见的打包工具有：

**Webpack**，直到第 4 版，才刚刚能生成 UMD 和 CommonJS 的包。webpack 还包含了一些精细的定义（如：CommonJS2）。[此处](https://webpack.js.org/configuration/output/#outputlibrarytarget)了解详细信息。

**Rollup** 是另一个打包工具。Rollup 可以将 ES 模块作为[输出格式](https://rollupjs.org/guide/en/#outputformat)导出。

[本文](https://medium.com/webpack/webpack-and-rollup-the-same-but-different-a41ad427058c)总结了两个打包工具间的差异。虽然文章写于 2017，但其结论如今仍然有效：将 Webpack 用于应用程序打包，Rollup 用于库的打包。

#### Manifest

Package.json 用于表示库的内容。除了版本名称外，它还应该指向目录或包（bundles）中的相关文件。

遗憾的是，由于没有正式的标准，一些工具会将约定的属性用于其他的用途。

一些需要注意的属性：

* **main**: 应该指向主文件（默认值是根目录的 index.js 文件）。对于被转译的多个文件，它应该指向 dist 文件夹，比如，dist/index.js。通常应该指向一个 CJS 包，因为这是最常用的格式。
* **module**: 这个应该指向一个 ES 入口项或入口文件。打包工具中的 Webpack 在打包时，可以根据入口项来进行搜索。使用 ES6 进行打包可以提升 tree shaking 的效果。
* **browser**: 应该指向一个 AMD/UMD 入口项。通常是一个单独的文件。
* **typings**: 指向 Typescript 编译器使用的类型定义。比如：一个 d.ts 文件，可以这样写：dist/index.d.ts
* **unpkg**: 指向通过 CDN 可用的 UMD 单个文件。unpkg 会使用此属性（如果存在），或者回退使用 main 属性的值。
* **type**: 为模块设置一个 type 域，来让 node 将其视作 ESM 并按此加载。

## 最后

希望在不久的未来，我们能看到 Javascript 生态系统对于语法和模块拥有一个统一的标准。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
