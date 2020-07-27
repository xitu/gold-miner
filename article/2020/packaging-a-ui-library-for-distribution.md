> * 原文地址：[Packaging a UI Library for Distribution](https://blog.bitsrc.io/packaging-a-ui-library-for-distribution-d153219def28)
> * 原文作者：[Tally Barak](https://medium.com/@tally_b)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/packaging-a-ui-library-for-distribution.md](https://github.com/xitu/gold-miner/blob/master/article/2020/packaging-a-ui-library-for-distribution.md)
> * 译者：
> * 校对者：

# Packaging a UI Library for Distribution - Guidelines you may want to follow if you are publishing a UI components library.

![Image by [Arek Socha](https://pixabay.com/users/qimono-1962238/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=1893642) from [Pixabay](https://pixabay.com/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=1893642)](https://cdn-images-1.medium.com/max/2560/1*EXcun_D11oz0ceMYlJ0yQA.jpeg)

## The problem

The JavaScript world has a unique feature: it has multiple runtime environments all running the same code. On one side we have the browsers, provided by different manufacturers and in different versions. On the other side, we have Nodejs running on the server, also in different versions. (Side note: you probably want to watch out Deno, an interesting server runtime).

After almost two decades of hibernation of the language, JavaScript gained huge momentum with new features coming to the language daily (well, yearly, but the metaphor works better this way). At the same time, new flavors of JS, such as Typescript and Flow showed up, adding additional syntax to the language.

We end up with a mixture of dialects, execution platforms, and evolving standards. All leading to the fact that building a UI components package in Javascript and sharing it with the world is anything but simple.

Anyone publishing a library should consider how the components are going to be consumed: as a browser tag, installed as an NPM module on the server, or compiled with bundlers like Webpack for the browser.

## What to deliver then?

Here are my suggestions for the formats that you want to deliver for your package, and in the last section, we will go through the tools that can help you get there.

![mage by [Annalise Batista](https://pixabay.com/users/AnnaliseArt-7089643/?utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=image&amp;utm_content=5293336) from [Pixabay](https://pixabay.com/?utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=image&amp;utm_content=5293336) (modified)](https://cdn-images-1.medium.com/max/2560/1*xPmTGN5rwQH_IQ94TRIhmw.png)

I will discuss the delivery of the package in the following 4 aspects. But worth noticing that they are interrelated.

* ES syntax format
* Module format
* Files bundling
* Package distribution

You will also notice that the discussion is completely framework agnostic. The guidelines discussed here are cross-framework and are relevant to components written in Angular, React, and Vue.

#### ES Syntax Format

Most web browsers as well as Nodejs are supporting at least ES2015 syntax, and most of them are evergreen and are up to date on new features of the language. The infamous exception is IE11, which its market share is thankfully declining. Unless explicit support for IE11 is needed, it is ok to assume that ES2015 can be considered as the lingua franca of the JS environment. Modern browsers and NodeJs newer formats such as ES2017 can also be acceptable.

Recommendation:

> Use ES5 if you are targeting old browsers, ES2015, or ES2017 for modern browsers and NodeJS.

#### Module Format

It was not until 2015 that Javascript, or Ecamscript as it is officially known, has a norm for module format — the ES6 Module format (AKA ESM, ES2015 Modules). During this twilight zone, multiple formats were created by the community but with not a single standard to adhere to.

formats were created to support browsers and NodeJS.

* AMD (Asynchronous Module Definition) — Requirejs describe the reasons for developing it back in 2011. [https://requirejs.org/docs/whyamd.html](https://requirejs.org/docs/whyamd.html)
* CommonJS / CJS — developed for server-side modules.
* UMD (Universal Module Definition) is a pattern for supporting both client and server and combines AMD with CJS.
* ESM / ES Modules / ES6 Modules / ES2015 modules — the standard format introduced in ES6. Support is still experimental in NodeJS 14 and before that was behind a flag ( — experimental-modules).

This table summarizes some of the differences between the formats:

![](https://cdn-images-1.medium.com/max/2000/1*ohOcheaTdGZpG4nnK97swg.png)

To get the feeling of the differences, we look at how Typescript code is compiled to the different formats:

![](https://cdn-images-1.medium.com/max/2000/1*X9Mvq1jM5-uw__W6WABTTQ.png)

Recommendation:

> Generate your library with multiple formats: ESM, CJS, and UMD / AMD.

#### Files Bundling

When distributing as an NPM package for browser-based or server-based applications, it is acceptable to provide a directory with multiple files. The server can easily read them one by one, while the browser is likely to have a preparation step that bundles the whole application into a single file (or split into chunks).

However, to use the components as a script tag, you might want to generate a single file that contains all of the library code. A single file can also improve the performance of the bundlers as it reduces the number of disk accesses during the process.

Recommendation:

> Provide UMD formats in a single file for the browser and ESM / CJS formats in separate files and a single file format.

#### Package Distribution

Most packages are available via the NPM registry. This is the common method of publishing them. Publishing a package to NPM also makes it available on CDN for directly used in the browser (via script tags).

Recommendation:

> Make sure your package is providing a UMD format, so it is available via unpkg as well.

Note: New CDN is coming that support ES Module format. Pika.dev is the one to look at!.

## Tools

The tools for creating those files are:

* Transpilers
* Bundlers
* Manifest (package.json)

#### Transpilers

For code written in modern ES formats or Typescript, you should use Babel or Typescript transpilers. Both of them support JS syntax and TS syntax, but [with some differences](https://blog.logrocket.com/choosing-between-babel-and-typescript-4ed1ad563e41/#:~:text=TypeScript%20by%20default%20compiles%20an,that%20require%20reading%20multiple%20files.&text=A%20const%20enum%20is%20an%20enum%20that%20TypeScript%20compiles%20away%20to%20nothing)[.](https://blog.logrocket.com/choosing-between-babel-and-typescript-4ed1ad563e41/#:~:text=TypeScript%20by%20default%20compiles%20an,that%20require%20reading%20multiple%20files.&text=A%20const%20enum%20is%20an%20enum%20that%20TypeScript%20compiles%20away%20to%20nothing.)

**Babel** includes transformation plugins that transform the code, such as [transform-modules-commonjs](https://babeljs.io/docs/en/babel-plugin-transform-modules-commonjs) and [transform-modules-umd](https://babeljs.io/docs/en/babel-plugin-transform-modules-umd) . They will generate the relevant module format.

**Typescript** compiler can also produce different formats using the “module” property in the tsconfig.json is responsible for generating the relevant module output.

#### Bundlers

Bundlers usually run plugins that execute the transpilation. This includes the language and module format but also generates additional assets such as CSS and images.

bundlers work best with ES Modules format as it has the best support for tree shaking unused code done by the

The common tools are:

**Webpack**, up until version 4, can only generate UMD and CommonJS bundles. It also contains some more fine-grained definitions (such as CommonJS2). Read the details [here](https://webpack.js.org/configuration/output/#outputlibrarytarget).

**Rollup** is the other bundler. Rollup can export ES modules as an [output format](https://rollupjs.org/guide/en/#outputformat).

[This article](https://medium.com/webpack/webpack-and-rollup-the-same-but-different-a41ad427058c) summarizes the differences (as of 2017…), but with a conclusion that is probably still valid: Use Webpack for apps, and Rollup for libraries.

#### Manifest

Package.json is the way to manifest the contents of the library. Besides the name of the version, it should point to relevant files in the directory or bundle.

Sadly, as there is no official standard, some ad-hoc tools are using agreed-upon properties for different uses:

Some attribute to note:

* **main**: should point to the main file (the default is index.js at the root). For files that are transpiled it should point to the dist folder, e.g. dist/index.js. Normally this should point to a CJS bundle, as it is the most common format.
* **module**: this should point to an ES entry point or file. Bundlers such as Webpack know to search for this entry when bundling. Using ES6 for bundling can improve tree shaking.
* **browser**: should point to an AMD / UMD entry. Usually a single file.
* **typings**: points to the definitions of the types as used by the Typescript compiler. This is a d.ts file. e.g. dist/index.d.ts
* **unpkg**: points to the UMD single file that is available via CDN. Unpkg uses this property if exist, or falls back to main.
* **type**: setting a type field to **module** makes node identifies it as ESM and tries to load it as such.

## Conclusion

In the future, hopefully, in the short future, we are likely to see the Javascript ecosystem converged into a standard format for syntax and modules.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
