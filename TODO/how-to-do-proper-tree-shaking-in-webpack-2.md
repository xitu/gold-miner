
  > * 原文地址：[How to do proper tree-shaking in Webpack 2](https://blog.craftlab.hu/how-to-do-proper-tree-shaking-in-webpack-2-e27852af8b21)
  > * 原文作者：[Gábor Soós](https://blog.craftlab.hu/@blacksonic86)
  > * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
  > * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-to-do-proper-tree-shaking-in-webpack-2.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-to-do-proper-tree-shaking-in-webpack-2.md)
  > * 译者：
  > * 校对者：

  # How to do proper tree-shaking in Webpack 2

  The term tree-shaking was first introduced by Rich Harris’ module bundler, [Rollup](https://rollupjs.org/). Tree-shaking means that Javascript bundling will only include code that is necessary to run your application. It has been made available by the static nature of ES2015 modules (exports and imports can’t be modified at runtime), which lets us detect unused code at bundle time. This feature has become available to Webpack users with the second version. Now [Webpack](https://webpack.js.org/) has built-in support for ES2015 modules and tree-shaking. In this tutorial I’ll show you how tree-shaking works in Webpack and how to overcome the obstacles that come our way.

![](https://cdn-images-1.medium.com/max/2000/1*djuJdyxfBwGEClfgji8GRw.jpeg)

If you just want to skip to the working examples visit my [Babel](https://github.com/blacksonic/babel-webpack-tree-shaking) or [Typescript](https://github.com/blacksonic/typescript-webpack-tree-shaking) repository.

#### Example application

The way tree-shaking works in Webpack can be best shown through a minimalistic example. I’ll compare it to a car that has a specific engine. The application consists of two files. The first one holds the different engines as classes and their version as a function. Every class and function is exported from its file.

```
export class V6Engine {
  toString() {
    return 'V6';
  }
}

export class V8Engine {
  toString() {
    return 'V8';
  }
}

export function getVersion() {
  return '1.0';
}
```

The next file describes the car with its engine and serves as the entry point for our application. We will start the bundling from this file.

```
import { V8Engine } from './engine';

class SportsCar {
  constructor(engine) {
    this.engine = engine;
  }

  toString() {
    return this.engine.toString() + ' Sports Car';
  }
}

console.log(new SportsCar(new V8Engine()).toString());
```

After defining the car class, we only use the *V8Engine* class, the other exports remain untouched. When running the application it will output *‘V8 Sports Car’*.

With tree-shaking in place we expect the output bundle to only include classes and functions we use. In our case it means the *V8Engine* and the *SportsCar* class only. Let’s see how it works under the hood.

#### Bundling

![](https://cdn-images-1.medium.com/max/1600/1*eXdX_sQKzEZomscFgpEwRQ.png)

When we bundle the application without transformations (like [Babel](https://babeljs.io/)) and minification (like [UglifyJS](https://github.com/mishoo/UglifyJS2)), we will get the following output:

```
(function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* unused harmony export getVersion */
class V6Engine {
  toString() {
    return 'V6';
  }
}
/* unused harmony export V6Engine */

class V8Engine {
  toString() {
    return 'V8';
  }
}
/* harmony export (immutable) */ __webpack_exports__["a"] = V8Engine;

function getVersion() {
  return '1.0';
}

/***/ }),
/* 1 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
Object.defineProperty(__webpack_exports__, "__esModule", { value: true });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__engine__ = __webpack_require__(0);

class SportsCar {
  constructor(engine) {
    this.engine = engine;
  }

  toString() {
    return this.engine.toString() + ' Sports Car';
  }
}

console.log(new SportsCar(new __WEBPACK_IMPORTED_MODULE_0__engine__["a" /* V8Engine */]()).toString());

/***/ })
```

Webpack marks classes and functions with comments which are not used (*/* unused harmony export V6Engine */*) and only exports those which are used (*/* harmony export (immutable) */ __webpack_exports__[“a”] = V8Engine;*). The very first question you may ask is that why is the unused code still there? Tree-shaking isn’t working, is it?

#### Dead code elimination vs live code inclusion

The reason behind this is that Webpack only marks code unused and doesn’t export it inside the module. It pulls in all of the available code and leaves dead code elimination to minification libraries like UglifyJS. UglifyJS gets the bundled code and removes unused functions and variables before minifying. With this mechanism it should remove the *getVersion* function and the *V6Engine* class.

Rollup, on the other hand, only includes the code that is necessary to run the application. When bundling is done, there are no unused classes and functions. Minification only deals with the actually used code.

#### Setting it up

UglifyJS [doesn’t support the new language features of Javascript](https://github.com/mishoo/UglifyJS2/issues/448) (aka ES2015 and above) yet. We need Babel to transpile our code to ES5 and then use UglifyJS to clean up the unused code.

![](https://cdn-images-1.medium.com/max/1600/1*FS50WgvWgoi3hxY_IPqTXw.png)

The most important thing is to leave ES2015 modules untouched by Babel presets. Webpack understands harmony modules and can only find out what to tree-shake if modules are left in their original format. If we transpile them also to CommonJS syntax, Webpack won’t be able to determine what is used and what is not. In the end Webpack will translate them to CommonJS syntax.

We have to tell the preset (in our case [babel-preset-env](https://github.com/babel/babel-preset-env)) to skip the module transpilation.

```
{
  "presets": [
    ["env", {
      "loose": true,
      "modules": false
    }]
  ]
}
```

The corresponding Webpack config part.

```
module: {
  rules: [
    { test: /\.js$/, loader: 'babel-loader' }
  ]
},

plugins: [
  new webpack.LoaderOptionsPlugin({
    minimize: true,
    debug: false
  }),
  new webpack.optimize.UglifyJsPlugin({
    compress: {
      warnings: true
    },
    output: {
      comments: false
    },
    sourceMap: false
  })
]
```

Let’s look at the output what we got after tree-shaking: [link to minified code](https://github.com/blacksonic/babel-webpack-tree-shaking/blob/master/dist/car.prod.bundle.js).

We see the getVersion function removed as expected, but the V6Engine class remained there in the minified code. What can be the problem, what went wrong?

#### Troubles ahead

First Babel detects the ES2015 class and transpiles it down to it’s ES5 equivalent. Then comes Webpack by putting the modules together and in the end UglifyJS removes unused code. We can read what is the exact problem from the output of UglifyJS.

*WARNING in car.prod.bundle.js from UglifyJs
Dropping unused function getVersion [car.prod.bundle.js:103,9]
Side effects in initialization of unused variable V6Engine [car.prod.bundle.js:79,4]*

It tells us that the ES5 equivalent of the *V6Engine* class has side effects at initialization.

```
var V6Engine = function () {
  function V6Engine() {
    _classCallCheck(this, V6Engine);
  }

  V6Engine.prototype.toString = function toString() {
    return 'V6';
  };

  return V6Engine;
}();
```

When we define classes in ES5, class methods have to be assigned to the *prototype* property. There is no way around skipping at least one assignment. UglifyJS can’t tell if it is just a class declaration or some random code with side effects, because it can’t do control flow analysis.

Transpiled code breaks the tree-shaking of classes. It only works for functions out of the box.

There are multiple on-going bug reports related to this on Github in the [Webpack repository](https://github.com/webpack/webpack/issues/2867) and in the [UglifyJS repository](https://github.com/mishoo/UglifyJS2/issues/1261). One solution can be to complete the ES2015 support in UglifyJS. Hopefully it will be released with the [next major version](https://github.com/mishoo/UglifyJS2/issues/1411). Another solution can be to implement an annotation for downleveled classes that mark it as pure (side effect free) for UglifyJS. This way UglifyJS can be sure that this declaration has no side effects. Its support is [already implemented](https://github.com/mishoo/UglifyJS2/pull/1448) but to make it work, transpilers have to support it and emit the @__PURE__ annotation next to the downleveled class. There are ongoing issues implementing this behavior in [Babel](https://github.com/babel/babel/issues/5632) and [Typescript](https://github.com/Microsoft/TypeScript/issues/13721).

#### Babili to the rescue

The developers behind Babel thought why not make a minifier based on Babel that understands ES2015 and above? They created [Babili](https://github.com/babel/babili), which can understand every new language feature that Babel can parse. Babili can transpile ES2015 code into ES5 code and minify it including removal of unused classes and functions. Just like UglifyJS would have already implemented ES2015 support with the addition that it will automatically catch up with the new language features.

Babili will remove unused code before transpilation. It is much easier to spot unused classes before downleveled to ES5. Tree-shaking will also work for class declarations, not just functions.

We only have to replace the UglifyJS plugin with the Babili plugin and remove the loader for Babel. The other way around is to use Babili as a Babel preset and use only the loader. I would recommend using the plugin, because it can also work when we are using a transpiler that is not Babel (for example Typescript).

```
module: {
  rules: []
},

plugins: [
  new BabiliPlugin()
]
```

We always have to pass ES2015+ code down to the plugin, otherwise it won’t be able to remove classes.

ES2015+ is also important when using other transpilers like Typescript. Typescript has to output ES2015+ code and harmony modules to enable tree-shaking. The output of Typescript will be handed over to Babili to remove the unused code.

The output now won’t contain the class *V6Engine*: [link to minified code](https://github.com/blacksonic/babel-webpack-tree-shaking/blob/master/dist/car.es2015.prod.bundle.js).

#### Libraries

The same rules apply for libraries as for our code. It should use the ES2015 modules format. Luckily more and more library authors release their packages in both CommonJS style format and the new module format. The entry point for the new module format is marked with the *module* field in *package.json*.

With the new module format unused functions will be removed, but for classes it is not enough. The library classes also have to be in ES2015 format to be removable by Babili. It is very rare that libraries are published in this format, but for some it is available (for example lodash as lodash-es).

One last culprit can be when the separate files of the library modify other modules by extending them; importing files have side effects. The operators of [RxJs](https://github.com/Reactive-Extensions/RxJS) is good example for this. By importing an operator it modifies one of the classes. These are considered side effects and they stop the code from being tree-shaken.

#### Summary

With tree-shaking you can bring down the size of your application considerable. Webpack 2 has built-in support for it, but works differently from Rollup. It will include everything but will mark unused functions and classes, leaving the actual code removal to minifiers. This is what makes it a bit more difficult for us to tree-shake everything. Going with the default minifier, UglifyJS, it will remove only unused functions and variables. To remove classes also, we have to use Babili which, understands ES2015 classes. We also have to pay special attention to modules, whether they are published in a way that supports tree-shaking.

I hope this article clarifies the inner workings behind Webpack’s tree-shaking and gives you ideas to overcome the obstacles.

You can see the working examples in my [Babel](https://github.com/blacksonic/babel-webpack-tree-shaking) and [Typescript](https://github.com/blacksonic/typescript-webpack-tree-shaking) repository.

---

*Thanks for reading! If you liked this story, please recommend it by clicking the ❤ button on the side and sharing it on social media. Follow me on *[*Medium*](https://medium.com/@blacksonic86)* or *[*Twitter*](https://twitter.com/blacksonic86)* to read more about Javascript!*


  ---

  > [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
  