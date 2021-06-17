> * 原文地址：[How To Make Tree Shakeable Libraries](https://blog.theodo.com/2021/04/library-tree-shaking/)
> * 原文作者：[]()
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/library-tree-shaking.md](https://github.com/xitu/gold-miner/blob/master/article/2021/library-tree-shaking.md)
> * 译者：
> * 校对者：

# How To Make Tree Shakeable Libraries

![How To Make Tree Shakeable Libraries](https://blog.theodo.com/static/dfae80d02f29938244fa328765a243a9/a79d3/tree-shaking.png)

At [Theodo](https://www.theodo.fr), our aim is to build reliable and fast applications for our customers. Some of our projects include improving the performance of already existing applications. During one of these missions, we managed to reduce the bundle size of all our pages by a whopping **500KB Gzipped by tree shaking our internal libraries**.

While doing so, we realized tree shaking is not something we can simply turn on and off. There are many factors that impact the tree shaking quality of libraries.

**This article's aim is to provide an exhaustive guide on making an optimized tree shakeable library. If I had to summarize the procedure:**

* Check whether the library is tree shakeable by testing it against a known application in a controlled environment
* Use ES6 modules so bundlers can detect unused export statements
* Use the side effects optimization and make your library side effects free
* Split the library logic in multiple small modules and preserve the library's module tree
* Do not lose the module tree or the ES modules characteristics when transpiling your library
* Use the latest version of a tree shaking capable bundler

## What is tree shaking and why is it important?

From the [MDN docs](https://developer.mozilla.org/en-US/docs/Glossary/Tree_shaking):

> Tree shaking is a term commonly used within a JavaScript context to describe the removal of dead code.
> 
> It relies on the import and export statements in ES2015 to detect if code modules are exported and imported for use between JavaScript files.

Tree shaking is a way to achieve [dead code elimination](https://en.wikipedia.org/wiki/Dead_code_elimination) by detecting which exports are unused in our application. It is performed by application bundlers such as [Webpack](https://webpack.js.org/) or [Rollup](https://rollupjs.org/guide/en/) but was initially implemented by Rollup.

**So why call it tree shaking?** One can visualize the application's exports and imports in the form of a tree. The healthy leaves and branches represent used imports of the application while dead leaves symbolize unused code separated from the rest of the tree. Shaking the tree would eliminate all our unused code.

**Why is this important?** Tree shaking can have a huge impact on your browser applications. The more code gets bundled in the app, the more time the browser will spend downloading, decompressing, parsing, and executing it. **Removing unused code is thus of the utmost importance to make the fastest applications possible**.

There are many articles and resources out there explaining tree shaking and dead code elimination. Here we will be focusing on libraries that are consumed by applications. A library is considered to be tree shakeable if a consumer application can **successfully eliminate the unused parts of the library**.

 [![A tree shakeable library example](https://blog.theodo.com/static/fc37406e6c71b98a6f32f5b15eafeb71/50383/tree-shakeable-library.png "A tree shakeable library example")](https://blog.theodo.com/static/fc37406e6c71b98a6f32f5b15eafeb71/50383/tree-shakeable-library.png) 

But before we try to make a library tree shakeable, let's first see how we can distinguish one.

## Realize a library is not tree shakeable in a controlled environment

This may sound obvious at first glance. But I noticed a lot of developers assume their library is tree shakeable because it uses ES6 modules (more on that later) or because they have a tree shaking friendly configuration. Unfortunately, this does not automatically imply that your library is in fact tree shakeable!

This brings us to the relevant question: **how can one efficiently check that a library is tree shakeable?**

To do so, we need to understand two things:

* **It is the app's bundler that will ultimately tree shake the library's code, not the library's** (if it even has a bundler at all!). After all, only the app knows which parts of our library are used.
* **The library's job is to make sure it can be tree shaken** by the final bundler

To check whether our library is tree shakeable we will be testing it against a reference application in a controlled environment:

1. Create a simple application (reference app) with a bundler you know how to configure and that supports tree shaking (eg [Webpack](https://webpack.js.org/) or [Rollup](https://rollupjs.org/guide/en/))
2. Set the library you want to test as a dependency of the created application
3. Import only one element of the library and check the output of the application's bundler
4. Check that the bundled output only contains the imported element and its dependencies

This strategy will make the test independent of our existing applications. It makes it easier but also allows us to play with the library without breaking anything. It also makes sure the issue does not come from the application bundler configuration.

We will be doing this for our library called `user-library` that we will test against a `user-app` application bundled with [Webpack](https://webpack.js.org/). You may use whatever bundler you feel more comfortable with.

The `user-library`'s code looks like this:

```js
export const getUserName = () => "John Doe";

export const getUserPhoneNumber = () => "***********";
```

It just exports 2 functions in an index file that we can use via an NPM package.

Let's make our simple `user-app`:

`package.json`

```json
{
  "name": "user-app",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1",
    "build": "webpack"
  },
  "author": "",
  "license": "ISC",
  "devDependencies": {
    "webpack": "^5.18.0",
    "webpack-cli": "^4.3.1"
  },
  "dependencies": {
    "user-library": "1.0.0"
  }
}
```

Notice we are using `user-library` as a dependency.

`webpack.config.js`

```js
const path = require("path");

module.exports = {
  entry: "./src/index.js",
  output: {
    filename: "main.js",
    path: path.resolve(__dirname, "dist"),
  },
  mode: "development",
  optimization: {
    usedExports: true,
    innerGraph: true,
    sideEffects: true,
  },
  devtool: false,
};
```

To understand the Webpack configuration of our reference application, we need to understand how Webpack does tree shaking. Tree shaking is performed using the following steps:

* Identify the application entry file (determined in the Webpack configuration)
* Create an application module tree by looping through all the dependencies and sub dependencies imported by the entry file
* Identify for each module in the tree which export statements are not imported by the other modules
* Eliminate the unused exports and their related code using minification tools like UglifyJS or Terser

This process in done only in **production mode**.

**The issue with production mode is minification**. It becomes very hard to see whether our tree shaking worked because we cannot actually see our named functions in our bundled code.

To get around this, we run Webpack in development mode while still identifying which code is unused and would be removed in production with the `optimization` property set to:

```js
  optimization: {
    usedExports: true,
    sideEffects: true,
    innerGraph: true,
  }
```

The `usedExports` property allows Webpack to identify which module exports are not used by other modules. The other two will be discussed later in the article. For now, let's just say they improve the tree shaking quality of our application.

Our `user-app` entry file: `src/index.js`

```js
import { getUserName } from "user-library";

console.log(getUserName());
```

Once bundled, we now analyze the output:

```js
/***/ "./node_modules/user-library/dist/index.js":
/*!*************************************************!*\
  !*** ./node_modules/user-library/dist/index.js ***!
  \*************************************************/
/***/ ((__unused_webpack_module, exports) => {

var __webpack_unused_export__;

__webpack_unused_export__ = ({ value: true });

const getUserName = () => 'John Doe';

const getUserPhoneNumber = () => '***********';

exports.getUserName = getUserName;
__webpack_unused_export__ = getUserPhoneNumber;
/***/ })
```

Webpack regroups all our code in a single file. Looking at the `getUserPhoneNumber` export, we notice that Webpack has marked it as unused. It will be removed in production mode while `getUserName` is exported as it is used by our `index.js` entry file.

![A simple module graph with a tree shaken library](https://blog.theodo.com/654aef253913c52e28cf32f9254b2ed6/simple-export-module-graph.svg)

The library is tree shaken! You may repeat this step but for multiple imports and look at the output code. **The objective is to make sure unused code in the library is marked as unused by Webpack**.

Everything looks fine for our very simple `user-library`. Let's make it a bit more complicated and as we do so, we will look at some tree shaking requirements and optimizations.

## Use ES6 modules so bundlers can detect unused exports

Ok, this requirement is classic and well documented but is in my opinion a bit misleading. I oftentimes hear developers say we need to use ES6 modules so that our library can be tree shaken. While this statement is completely true, **there is this misconception that using ES6 modules is enough to just make tree shaking work**. Well, were it that simple, you definitely would not have gotten this far in the article!

However, using ES6 modules still is a requirement for tree shaking.

There are a lot of formats in which JavaScript can be bundled: ESM, CJS, UMD, IIFE and so on.

To make things simple, we will consider only two: Ecma Script Modules (ESM or ES6 modules) and CommonJS modules (CJS) as they are the most widely used for application libraries. Most libraries will use CJS modules because it allows them to be run in a node application ([though Node now supports ESM](https://nodejs.medium.com/announcing-core-node-js-support-for-ecmascript-modules-c5d6dc29b663)). ES modules appeared way later than CJS in 2015 with ECMAScript 2015 (also known as ES6) and is considered to be the standardized module system for JavaScript.

CJS syntax example

```js
const { userAccount } = require("./userAccount");

const getUserAccount = () => {
  return userAccount;
};

module.exports = { getUserAccount };
```

ESM syntax example

```js
import { userAccount } from "./userAccount";

export const getUserAccount = () => {
  return userAccount;
};
```

**The big difference between both is that ESM imports are `static` whereas CJS imports are `dynamic`** meaning we could do the following with CJS but not with ESM:

```js
if (someCondition) {
  const { userAccount } = require("./userAccount");
}
```

While this seems to be more flexible, it also means **bundlers cannot make a valid application tree at compile or bundle time**. The `someCondition` variable will be known only at runtime forcing the bundler to import `userAccount` in any case at compile time. This leads bundlers to just include all the CJS style imports directly in the bundle without being able to check whether the imports are actually used.

Let's modify our `user-library` to show this. And to make it a little bit more realistic, it will now have two files:

`src/userAccount.js`

```js
const userAccount = {
  name: "user account",
};

module.exports = { userAccount };
```

`src/index.js`

```js
const { userAccount } = require("./userAccount");

const getUserName = () => "John Doe";

const getUserPhoneNumber = () => "***********";

const getUserAccount = () => userAccount;

module.exports = {
  getUserName,
  getUserPhoneNumber,
  getUserAccount,
};
```

We keep the same entry file in our `user-app` so we do not use the `getUserAccount` function nor its dependency.

```js
/*!*************************************************!*\
  !*** ./node_modules/user-library/dist/index.js ***!
  \*************************************************/
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

const { userAccount } = __webpack_require__(/*! ./userAccount */ "./node_modules/user-library/dist/userAccount.js")

const getUserName = () => 'John Doe'

const getUserPhoneNumber = () => '***********'

const getUserAccount = () => userAccount

module.exports = {
  getUserName,
  getUserPhoneNumber,
  getUserAccount
}
/***/ }),

/***/ "./node_modules/user-library/dist/userAccount.js":
/*!*******************************************************!*\
  !*** ./node_modules/user-library/dist/userAccount.js ***!
  \*******************************************************/
/***/ ((module) => {

const userAccount = {
  name: 'user account'
}

module.exports = { userAccount }
/***/ })
```

All three exports still appear and are not marked by Webpack as unused. This is also the case for our `userAccount` file which will be included in the bundle.

Now let's look at the same example but with ESM by just replacing the require and exports syntax with their ESM counterparts.

```js
/*!*************************************************!*\
  !*** ./node_modules/user-library/dist/index.js ***!
  \*************************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "getUserName": () => /* binding */ getUserName
/* harmony export */ });
/* unused harmony exports getUserAccount, getUserPhoneNumber */
/* harmony import */ var _userAccount_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./userAccount.js */ "./node_modules/user-library/dist/userAccount.js");

const getUserName = () => 'John Doe';

const getUserPhoneNumber = () => '***********';

const getUserAccount = () => userAccount;

/***/ }),
/***/ "./node_modules/user-library/dist/userAccount.js":
/*!*******************************************************!*\
  !*** ./node_modules/user-library/dist/userAccount.js ***!
  \*******************************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

/* unused harmony export userAccount */
const userAccount = {
  name: 'user account'
};
/***/ })
```

Notice that `getUserAccount` and `getUserPhoneNumber` are marked as unused. But so does the `userAccount` export in the other file. Thanks to the `innerGraph` optimization, Webpack is able to link the `userAccount` import in the `index` file to the `getUserAccount` export. **This allows Webpack to work recursively from the entry file and go through all of its dependencies to know which exports are unused in every module**. Since Webpack knows that `getUserAccount` is unused, it can go and check its dependencies in the `userAccount` file and do the same work there etc.

![Exports module graph with ESM library](https://blog.theodo.com/78a14d74268a17ddd6a6416474884a5d/esmodules-module-graph.svg)

ES modules allow us to look for exported code that is used or unused in our application explaining why this module system is so important for tree shaking. It also explains why one should use dependencies that export a ES module compatible build such as [`lodash-es`](https://www.npmjs.com/package/lodash-es), the ESM equivalent of the popular [`lodash`](https://lodash.com/) library.

This being said, **using only ES modules for tree shaking is still a suboptimal approach**. In our example, we noticed Webpack worked recursively in each file to see whether exported code was used or unused. In this case, Webpack could have just totally ignored the `userAccount` file because the only import coming from that file is unused! This leads us to the notion of `side effects` discussed in the next part of the article.

**To sum up this first part:**

* **ESM is a requirement for tree shaking but is not enough to make it optimal**
* **Make sure to always provide an ESM build of your library!** If your consumers require both ESM and CJS builds, provide them both through the package.json with [the `main` and `module` fields](https://github.com/rollup/rollup/wiki/pkg.module).
* **Make sure to use ESM dependencies** when possible as they won't be tree shaked otherwise.

## Use the side effects optimization to make your library side effects free

According to the [Webpack](https://webpack.js.org/) docs, tree shaking can be split in two optimizations:

* **usedExports**: Determine which exports of a module are used and unused
* **sideEffects**: skip over modules that do not have any used exports and that are side effects free

To illustrate side effects, let's take the example that we used before:

```js
import { userAccount } from "./userAccount";

function getUserAccount() {
  return userAccount;
}
```

If `getUserAccount` is unused, can the bundler assume that the `userAccount` module can be removed as well? The answer is no! `userAccount` could do all kinds of stuff affecting other parts of the app. It could inject some variables inside a globally accessible value, like the DOM for instance. It could also be a css module injecting style inside the document. But I think the best example is polyfills as we usually import them like:

```js
import "myPolyfill";
```

Now this module definitely has side effects as it affects the code of the whole app as soon as it is imported. Bundlers will see this module as a possible candidate for removal as we are not using any of its exports. But removing this would break our app.

**Bundlers like [Webpack](https://webpack.js.org/) or [Rollup](https://rollupjs.org/guide/en/#treeshake) will therefore see every module of our library as filled with side effects by default.**

In our case, we know that our library is side effect free! We can therefore help our bundler by informing it of this. To do so, most bundlers [can read the `sideEffects` property inside the `package.json` file](https://webpack.js.org/guides/tree-shaking/#mark-the-file-as-side-effect-free). It is by default set to true when unspecified (there are side effects in every module of the package). You can set it to false (no side effects anywhere) or you may specify an array of files that have side effects.

We add this option to the package.json file of our library:

```json
{
  "name": "user-library",
  "version": "1.0.0",
  "description": "",
  "sideEffects": false,
  "main": "dist/index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "author": "",
  "license": "ISC"
}
```

We then rerun our Webpack build:

```js
/*!*************************************************!*\
  !*** ./node_modules/user-library/dist/index.js ***!
  \*************************************************/
/***/ (__unused_webpack_module, __webpack_exports__, __webpack_require__) => {
  /* harmony export */ __webpack_require__.d(__webpack_exports__, {
    /* harmony export */ getUserName: () => /* binding */ getUserName,
    /* harmony export */
  });
  /* unused harmony exports getUserAccount, getUserPhoneNumber */

  const getUserName = () => "John Doe";

  const getUserPhoneNumber = () => "***********";

  const getUserAccount = () => userAccount;
  /***/
};
```

We see that the `userAccount` file has been removed from the bundle. We still see `getUserAccount` that references `userAccount` but this function has been marked by Webpack as dead code and it will be removed during minification.

![Side effects module graph](https://blog.theodo.com/a824f2dc91a5e2f206a71f44adf756f6/side-effects-module-graph.svg)

**The `sideEffects` flag is especially important for libraries that export their API through an index file** that itself exports functions or variables from internal files. Without the side effects optimization, our bundlers would have to parse all the files where our exported variables are defined.

[As noted by Webpack](https://webpack.js.org/guides/tree-shaking/#clarifying-tree-shaking-and-sideeffects): **"sideEffects is much more effective since it allows to skip whole modules/files and the complete subtree."**

To better understand the difference between how both optimizations intervene:

* `sideEffects` allows us to completely skip an imported module if none of its imported contents are used.
* `usedExports` allows us to completely remove exports that are never imported by any module.

Ok but **how is the result of skipping files different from just saying the exports of those files are unused?**

Most of the time, tree shaking a library with and without the side effects optimization will give the same result. The same amount of code will be included in the final bundle. However, this is not true in some situations when analyzing the code for unused exports becomes too complex. The next part covers two of these situations where only the combination of small modules with the `sideEffects` optimization provides the best result.

**To sum up this part:**

* Tree shaking consists of two parts: the **used exports** optimization and the **side effects** optimization
* The **side effects optimization is way more effective** than just detecting unused export statements in every module
* Make your library side effect free
* Make sure to tell that your library is side effects free through the `sideEffects` property in the `package.json` file.

## Preserve the library's module tree and split your code in small modules to fully benefit from the `sideEffects` optimization

You may have noticed that the example `user-library` we are using in this article is not bundled. The library just exposes a few JS files that I manually added.

Oftentimes, libraries will be bundled for multiple reasons:

* Manage custom import paths
* The library uses specific languages like SASS or TS that need to be transformed to CSS or JS for instance
* The library needs to be available in multiple formats (ESM, CJS, IIFE ...)

Popular bundlers like [Webpack](https://webpack.js.org/), [Rollup](https://rollupjs.org/guide/en/), [Parcel](https://parceljs.org/) or [ESBuild](https://esbuild.github.io/) are made to provide a bundle that can be served to a browser. They will thus have a tendency to create a single file regrouping all of your code so that only a single JS file needs to be sent through the network.

From a tree shaking perspective, this creates one problem: **The side effects optimization is non existent** as no modules can be skipped.

We are going to showcase two situations where splitted modules combined with the `sideEffect` optimization are essential for tree shaking.

#### A library module imports a CJS formatted dependency

To demonstrate the issue, we are going to bundle our library using [Rollup](https://rollupjs.org/guide/en/). And we are going to have one of our library modules import a CJS formatted dependency: [Lodash](https://lodash.com)

`rollup.config.js`

```js
export default {
  input: "src/index.js",
  output: {
    file: "dist/index.js",
    format: "esm",
  },
};
```

`userAccount.js`

```js
import { isNil } from "lodash";

export const checkExistance = (variable) => !isNil(variable);

export const userAccount = {
  name: "user account",
};
```

Notice we are now exporting `checkExistance` and we import it in our library `index` file.

Here is the output in `dist/index.js`

```js
import { isNil } from "lodash";

const checkExistance = (variable) => !isNil(variable);

const userAccount = {
  name: "user account",
};

const getUserAccount = () => {
  return userAccount;
};

const getUserPhoneNumber = () => "***********";

const getUserName = () => "John Doe";

export { checkExistance, getUserName, getUserPhoneNumber, getUserAccount };
```

Everything is bundled within a single file. Notice also that Lodash is imported at the top. We are still importing the same functions in our application meaning `checkExistance` is not used. However, after running Webpack, we see that the whole `Lodash` library is imported even though `checkExistance` is marked as unused:

```js
/***/ "./node_modules/user-library/dist/index.js":
/*!*************************************************!*\
  !*** ./node_modules/user-library/dist/index.js ***!
  \*************************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

"use strict";
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "getUserName": () => (/* binding */ getUserName)
/* harmony export */ });
/* unused harmony exports checkExistance, userAccount, getUserPhoneNumber, getUserAccount */
/* harmony import */ var lodash__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! lodash */ "./node_modules/user-library/node_modules/lodash/lodash.js");
/* harmony import */ var lodash__WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(lodash__WEBPACK_IMPORTED_MODULE_0__);

const checkExistance = (variable) => !isNil(variable);

const userAccount = {
  name: "user account",
};

const getUserPhoneNumber = {
  number: '***********'
};

const getUserAccount = () => {
  return userAccount
};

const getUserName = () => 'John Doe';

/***/ }),

/***/ "./node_modules/user-library/node_modules/lodash/lodash.js":
/*!*****************************************************************!*\
  !*** ./node_modules/user-library/node_modules/lodash/lodash.js ***!
  \*****************************************************************/
/***/ (function(module, exports, __webpack_require__) {

/* module decorator */ module = __webpack_require__.nmd(module);
var __WEBPACK_AMD_DEFINE_RESULT__;/**
 * @license
 * Lodash <https://lodash.com/>
 * Copyright OpenJS Foundation and other contributors <https://openjsf.org/>
 * Released under MIT license <https://lodash.com/license>
 * Based on Underscore.js 1.8.3 <http://underscorejs.org/LICENSE>
 * Copyright Jeremy Ashkenas, DocumentCloud and Investigative Reporters & Editors
 */
// ...
```

Webpack is not able to tree shake `Lodash` because of its CJS format. This is a shame as we explicitly organized our library so `Lodash` would be imported only in the `userAccount` module that is unused in our application. If the module structure was preserved, Webpack would have detected that no `userAccount` exports were used and would simply have skipped the module and thus its `Lodash` import thanks to the `sideEffects` optimization.

[In rollup, we can use the `preserveModules` option to preserve the module structure of our library.](https://rollupjs.org/guide/en/#outputpreservemodules). Equivalents exist for other bundlers.

```js
export default {
  input: "src/index.js",
  output: {
    dir: "dist",
    format: "esm",
    preserveModules: true,
  },
};
```

[Rollup](https://rollupjs.org/guide/en/) now keeps the original file structure. We can now run Webpack again:

```js
/***/ "./node_modules/user-library/dist/index.js":
/*!*************************************************!*\
  !*** ./node_modules/user-library/dist/index.js ***!
  \*************************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "getUserName": () => (/* binding */ getUserName)
/* harmony export */ });
/* unused harmony export getUserAccount */

const getUserAccount = () => {
  return userAccount
};

const getUserName = () => 'John Doe';

/***/ })
```

[Lodash](https://lodash.com/) is now skipped along with the `userAccount` module.

![Preserving the module structure improves tree shaking when using CJS dependencies](https://blog.theodo.com/5048f04d949bc617ef620574bbc2cec3/split-modules-cjs-module-graph.svg)

#### Code splitting

Preserving splitted module structure alongside the `sideEffects` optimization also benefits [Webpack code splitting](https://webpack.js.org/guides/code-splitting/), a key performance optimization for big applications. Code splitting is widely used in web applications with multiple pages. Frameworks like [Nuxt](https://nuxtjs.org/) or [Next](https://nextjs.org/) both use page by page code splitting.

To illustrate the benefit, we will look at what happens when the library is bundled in a single file.

`user-library/src/userAccount.js`

```js
export const userAccount = {
  name: "user account",
};
```

`user-library/src/userPhoneNumber.js`

```js
export const userPhoneNumber = {
  number: "***********",
};
```

`user-library/src/index.js`

```js
import { userAccount } from "./userAccount";
import { userPhoneNumber } from "./userPhoneNumber";

const getUserName = () => "John Doe";

export { userAccount, getUserName, userPhoneNumber };
```

In order to code split our user application, we will use [the Webpack `import` syntax](https://webpack.js.org/api/module-methods/#import-1).

`user-app/src/userService1.js`

```js
import { userAccount } from "user-library";

export const logUserAccount = () => {
  console.log(userAccount);
};
```

`user-app/src/userService2.js`

```js
import { userPhoneNumber } from "user-library";

export const logUserPhoneNumber = () => {
  console.log(userPhoneNumber);
};
```

`user-app/src/index.js`

```js
const main = async () => {
  const { logUserPhoneNumber } = await import("./userService2");
  const { logUserAccount } = await import("./userService1");

  logUserAccount();
  logUserPhoneNumber();
};

main();
```

The app bundle now has 3 files: `main.js`, `src_userService1_js.main.js` and `src_userService2_js.main.js`. Taking a closer look at `src_userService2_js.main.js`, we can see that the entire `user-library` bundle is added:

```js
(self["webpackChunkuser_app"] = self["webpackChunkuser_app"] || []).push([
  ["src_userService1_js"],
  {
    /***/ "./node_modules/user-library/dist/index.js":
      /*!*************************************************!*\
  !*** ./node_modules/user-library/dist/index.js ***!
  \*************************************************/
      /***/ (
        __unused_webpack_module,
        __webpack_exports__,
        __webpack_require__
      ) => {
        "use strict";
        /* harmony export */ __webpack_require__.d(__webpack_exports__, {
          /* harmony export */ userAccount: () => /* binding */ userAccount,
          /* harmony export */ userPhoneNumber: () =>
            /* binding */ userPhoneNumber,
          /* harmony export */
        });
        /* unused harmony export getUserName */
        const userAccount = {
          name: "user account",
        };

        const userPhoneNumber = {
          number: "***********",
        };

        const getUserName = () => "John Doe";

        /***/
      },

    /***/ "./src/userService1.js":
      /*!*****************************!*\
  !*** ./src/userService1.js ***!
  \*****************************/
      /***/ (
        __unused_webpack_module,
        __webpack_exports__,
        __webpack_require__
      ) => {
        "use strict";
        __webpack_require__.r(__webpack_exports__);
        /* harmony export */ __webpack_require__.d(__webpack_exports__, {
          /* harmony export */ logUserAccount: () =>
            /* binding */ logUserAccount,
          /* harmony export */
        });
        /* harmony import */ var user_library__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(
          /*! user-library */ "./node_modules/user-library/dist/index.js"
        );

        const logUserAccount = () => {
          console.log(user_library__WEBPACK_IMPORTED_MODULE_0__.userAccount);
        };

        /***/
      },
  },
]);
```

`userAccount` is not marked as unused even though `userService2` only uses `userPhoneNumber`... But why ?

We need to keep in mind that the `usedExports` optimization checks for used exports only within a module's scope. Only from there can Webpack remove unused code. From the perspective of our library module, both `userAccount` and `userPhoneNumber` are actually used. In this case, Webpack is not able to make a difference between the imports of `userService1` and `userService2` as seen on the following graph (both `userAccount` and `userPhoneNumber` are in green):

![Code splitting introduces issues when it comes to tree shaking](https://blog.theodo.com/bc749d7936558d17bdb54b5181928046/code-splitting-without-preserving-module-structure-graph.svg)

**This means that [Webpack](https://webpack.js.org/) is not able to tree shake the exports of each chunk independently when only relying on the `usedExports` optimization**.

We now preserve our modules when bundling our library to allow for the `sideEffects` optimization:

[Webpack](https://webpack.js.org/) still outputs the same 3 files but this time, `src_userService2_js.main.js` only contains the code coming from `userPhoneNumber`:

```js
(self["webpackChunkuser_app"] = self["webpackChunkuser_app"] || []).push([
  ["src_userService2_js"],
  {
    /***/ "./node_modules/user-library/dist/userPhoneNumber.js":
      /*!***********************************************************!*\
  !*** ./node_modules/user-library/dist/userPhoneNumber.js ***!
  \***********************************************************/
      /***/ (
        __unused_webpack_module,
        __webpack_exports__,
        __webpack_require__
      ) => {
        "use strict";
        /* harmony export */ __webpack_require__.d(__webpack_exports__, {
          /* harmony export */ userPhoneNumber: () =>
            /* binding */ userPhoneNumber,
          /* harmony export */
        });
        const userPhoneNumber = {
          number: "***********",
        };

        /***/
      },

    /***/ "./src/userService2.js":
      /*!*****************************!*\
  !*** ./src/userService2.js ***!
  \*****************************/
      /***/ (
        __unused_webpack_module,
        __webpack_exports__,
        __webpack_require__
      ) => {
        "use strict";
        __webpack_require__.r(__webpack_exports__);
        /* harmony export */ __webpack_require__.d(__webpack_exports__, {
          /* harmony export */ logUserPhoneNumber: () =>
            /* binding */ logUserPhoneNumber,
          /* harmony export */
        });
        /* harmony import */ var user_library__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(
          /*! user-library */ "./node_modules/user-library/dist/userPhoneNumber.js"
        );

        const logUserPhoneNumber = () => {
          console.log(
            user_library__WEBPACK_IMPORTED_MODULE_0__.userPhoneNumber
          );
        };

        /***/
      },
  },
]);
```

`src_userService1_js.main.js` behaves the same way as it includes only the `userAccount` module from our library.

![Preserving the module tree allows Webpack to independently tree shake code splitted chunks](https://blog.theodo.com/5fe908acf0f856a1958e77c400f40408/code-splitting-with-preserving-module-structure-graph.svg)

Looking at the graph, we still see that `userAccount` and `userPhoneNumber` are still considered as **used exports** as they are used at least once in our application. However, this time the `sideEffects` optimization is able to skip the `userAccount` module because it is never **imported** by `userService2`. The same thing happens for `userPhoneNumber` and `userService1`.

We can now understand that preserving the original module structure of the library is important. However, preserving this is useless if the original structure only has one module such as an `index.js` file with all the code inside. **In order to make an optimal tree shakeable library, its code should be divided in multiple small modules that each handle one piece of the logic**.

To use the tree analogy, one should see each leaf of the tree as a module. Smaller and weaker leafs will fall better when the tree is shaked! If the tree has fewer and bigger leafs, shaking it will not give the same result.

**To sum up this part:**

* **We should preserve the module structure of the library** in order to fully benefit from the `sideEffects` optimization.
* **Libraries should be split in multiple small modules**, each module exporting only one piece of logic
* Tree shaking libraries in applications that use code splitting will only work with the `sideEffects` optimization.

## Do not lose the module tree or the ES modules characteristics when transpiling your library

**Bundlers are not the only tools that can harm the tree shaking of your library**. Transpilers are also known to have an undesirable effect on tree shaking by removing ES modules and by not preserving the module tree.

One of the objectives of transpilers is to make your code compatible for browsers that do not necessarily support ES modules. We should remember though that **our libraries are not meant to be served to browsers directly** but should instead be consumed by applications. So transpiling our libraries to target specific browsers should be forbidden for two reasons:

* When making a library, one does not know which browser should be targeted, only the application knows that.
* Transpiling libraries can make them non tree shakeable

If the library needs to be transpiled for some reason, one needs to make sure the transpilation does not remove the ES module syntax or the original module tree for the same reasons explained in the last part of the article.

There are two tools that I know of that transpiled my libraries removing their tree shakeable characteristic.

#### Babel

Babel uses [Babel preset-env](https://babeljs.io/docs/en/babel-preset-env) to make your code compatible with one's target browsers. By default, this plugin will remove ES modules from the library. To make sure this does not happen, set the [modules](https://babeljs.io/docs/en/babel-preset-env#modules) option to false:

```js
module.exports = {
  env: {
    esm: {
      presets: [
        [
          "@babel/preset-env",
          {
            modules: false,
          },
        ],
      ],
    },
  },
};
```

#### Typescript

When compiling your code, typescript will transform your modules depending on the `target` and `module` options you set in the `tsconfig.json` file.

To make sure this does not happen, [set the `target` and `module` options to at least `ES2015` or `ES6`](https://www.typescriptlang.org/tsconfig#module).

**To sum up:**

* **Make sure your transpilers/compilers do not remove the ES module syntax from your library bundle**.
* To check whether this happens, look at the library's output bundle and check for ESM import syntax.

## Use the latest version of a tree shaking capable bundler

Tree shaking in javascript was popularized by [Rollup](https://rollupjs.org/guide/en/). [Webpack supports this since version 2](https://webpack.js.org/guides/tree-shaking/) and bundlers keep getting better and better at optimizing tree shaking.

Remember when we talked about the `innerGraph` optimization that allows Webpack to link module exports to the module's imports? [This optimization was introduced in Webpack 5](https://webpack.js.org/guides/tree-shaking/). We have been using Webpack 5 in this article but it is important to note that this optimization is a game changer as it allows Webpack to recursively look for unused exports!

To show what it actually does, we can consider our `index.js` file in our `user-library`:

```js
import { userAccount } from "./userAccount";

const getUserAccount = () => {
  return userAccount;
};

const getUserName = () => "John Doe";

export { getUserName, getUserAccount };
```

Our `user-app` only uses `getUserName`.

```js
import { getUserName } from "user-library";

console.log(getUserName());
```

We can now compare the outputs with and without the `innerGraph` optimization. We are still using both the `usedExports` and `sideEffects` optimizations:

Without the `innerGraph` optimization (eg with Webpack 4):

```js
/*!*************************************************!*\
  !*** ./node_modules/user-library/dist/index.js ***!
  \*************************************************/
/*! exports provided: userAccount, userPhoneNumber, getUserName, getUserAccount */
/*! exports used: getUserName */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return getUserName; });
/* unused harmony export getUserAccount */
/* harmony import */ var _userAccount_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./userAccount.js */ "./node_modules/user-library/dist/userAccount.js");

const getUserAccount = () => {
  return _userAccount_js__WEBPACK_IMPORTED_MODULE_0__[/* userAccount */ "a"]
};

const getUserName = () => 'John Doe';

/***/ }),

/***/ "./node_modules/user-library/dist/userAccount.js":
/*!*******************************************************!*\
  !*** ./node_modules/user-library/dist/userAccount.js ***!
  \*******************************************************/
/*! exports provided: userAccount */
/*! exports used: userAccount */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return userAccount; });
const userAccount = {
  name: 'user account'
};

/***/ }),
```

With the `innerGraph` optimization (eg with Webpack 5):

```js
/***/ "./node_modules/user-library/dist/index.js":
/*!*************************************************!*\
  !*** ./node_modules/user-library/dist/index.js ***!
  \*************************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "getUserName": () => (/* binding */ getUserName)
/* harmony export */ });
/* unused harmony export getUserAccount */

const getUserAccount = () => {
  return userAccount
};

const getUserName = () => 'John Doe';

/***/ })
```

![Illustration of Webpack's innerGraph optimization](https://blog.theodo.com/864c647dcd0339a67537c146c6b1dca7/inner-graph-optimization-module-graph.svg)

While Webpack 5 is able to completely eliminate the `userAccount` module, this is not the case for Webpack 4 even though `getUserAccount` is marked as unused. This is because the `innerGraph` algorithm allows webpack 5 to link unused elements of our module with its imports. In our case, the `userAccount` module is used only by the `getUserAccount` function and can therefore be skipped.

This optimization does not work using Webpack 4. **Developers should therefore be careful and limit the number of exports in a single file when using this version of Webpack**. I a file contains multiple exports, Webpack will include all the file imports even though they may not be necessary for the desired export.

In general, we should make sure our bundlers are always up to date to benefit from their latest tree shaking optimizations.

## Conclusion

Tree shaking a library is not something one just turns on by adding a specific line in a configuration file. Its quality depends on multiple factors and this article presents only a few of them. In the end though, whatever the issue might be, there are two important things we did in this article that can help anyone tree shake their libraries:

* **In order to see how well our library is tree shaked, we test it in a controlled environment using a bundler we know how to use**.
* **We detect issues with our library setup not by looking at its configuration files but by inspecting its bundled output**. This is what we have been doing all along in this article with our `user-library` and `user-app` examples.

I really hope this article helps you in your evergoing quest to make the best and most optimized libraries possible!

### Further Reading

* [Tree-shaking versus dead code elimination](https://medium.com/@Rich_Harris/tree-shaking-versus-dead-code-elimination-d3765df85c80)
* [Webpack 5 release](https://webpack.js.org/blog/2020-10-10-webpack-5-release/)
* [Tree shaking in JavaScript](https://ageek.dev/tree-shaking)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
