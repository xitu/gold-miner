
  > * 原文地址：[How to do proper tree-shaking in Webpack 2](https://blog.craftlab.hu/how-to-do-proper-tree-shaking-in-webpack-2-e27852af8b21)
  > * 原文作者：[Gábor Soós](https://blog.craftlab.hu/@blacksonic86)
  > * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
  > * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-to-do-proper-tree-shaking-in-webpack-2.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-to-do-proper-tree-shaking-in-webpack-2.md)
  > * 译者：[薛定谔的猫](https://github.com/Aladdin-ADD/)
  > * 校对者：[lsvih](https://github.com/lsvih)、[lampui](https://github.com/lampui)

  # 如何在 Webpack 2 中使用 tree-shaking

tree-shaking 这个术语首先源自 [Rollup](https://rollupjs.org/) -- Rich Harris 写的模块打包工具。它是指在打包时只包含用到的 Javascript 代码。它依赖于 ES6 静态模块（exports 和 imports 不能在运行时修改），这使我们在打包时可以检测到未使用的代码。Webpack 2 也引入了这一特性，[Webpack 2](https://webpack.js.org/) 已经内置支持 ES6 模块和 tree-shaking。本文将会介绍如何在 webpack 中使用这一特性，如何克服使用中的难点。

![](https://cdn-images-1.medium.com/max/2000/1*djuJdyxfBwGEClfgji8GRw.jpeg)

如果想跳过，直接看例子请访问 [Babel](https://github.com/blacksonic/babel-webpack-tree-shaking)、[Typescript](https://github.com/blacksonic/typescript-webpack-tree-shaking)。

#### 应用举例

理解在 Webpack 中使用 tree-shaking 的最佳的方式是通过一个微型应用例子。我将它比作一个汽车有特定的引擎，该应用由 2 个文件组成。第 1 个文件有：一些 class，代表不同种类的引擎；一个函数返回其版本号 -- 都通过 export 关键字导出。

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

第 2 个文件表示一个汽车拥有它自己的引擎，将这个文件作为应用打包的入口（entry）。

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

通过定义类 SportsCar，我们只使用了 *V8Engine*，而没有用到 *V6Engine*。运行这个应用会输出：*‘V8 Sports Car’*。

应用了 tree-shaking 后，我们期望打包结果只包含用到的类和函数。在这个例子中，意味着它只有 *V8Engine* 和 *SportsCar* 类。让我们来看看它是如何工作的。

#### 打包

![](https://cdn-images-1.medium.com/max/1600/1*eXdX_sQKzEZomscFgpEwRQ.png)

我们打包时不使用编译器（[Babel](https://babeljs.io/) 等）和压缩工具（[UglifyJS](https://github.com/mishoo/UglifyJS2) 等），可以得到如下输出：
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

Webpack 用注释 */\*unused harmony export V6Engine\*/* 将未使用的类和函数标记下来，用 */\*harmony export (immutable)\*/ __webpack_exports__[“a”] = V8Engine;* 来标记用到的。你应该会问未使用的代码怎么还在？tree-shaking 没有生效吗？

#### 移除未使用代码（Dead code elimination）vs 包含已使用代码（live code inclusion）

背后的原因是：Webpack 仅仅标记未使用的代码（而不移除），并且不将其导出到模块外。它拉取所有用到的代码，将剩余的（未使用的）代码留给像 UglifyJS 这类压缩代码的工具来移除。UglifyJS 读取打包结果，在压缩之前移除未使用的代码。通过这一机制，就可以移除未使用的函数 *getVersion* 和类 *V6Engine*。

而 Rollup 不同，它（的打包结果）只包含运行应用程序所必需的代码。打包完成后的输出并没有未使用的类和函数，压缩仅涉及实际使用的代码。

#### 设置

UglifyJS [不支持 ES6](https://github.com/mishoo/UglifyJS2/issues/448)（又名 ES2015）及以上。我们需要用 Babel 将代码编译为 ES5，然后再用 UglifyJS 来清除无用代码。

![](https://cdn-images-1.medium.com/max/1600/1*FS50WgvWgoi3hxY_IPqTXw.png)

最重要的是让 ES6 模块不受 Babel 预设（preset）的影响。Webpack 认识 ES6 模块，只有当保留 ES6 模块语法时才能够应用 tree-shaking。如果将其转换为 CommonJS 语法，Webpack 不知道哪些代码是使用过的，哪些不是（就不能应用 tree-shaking了）。最后，Webpack将把它们转换为 CommonJS 语法。

我们需要告诉 Babel 预设（在这个例子中是[babel-preset-env](https://github.com/babel/babel-preset-env)）不要转换 module。

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

对应 Webpack 配置：

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

来看一下 tree-shaking 之后的输出: [link to minified code](https://github.com/blacksonic/babel-webpack-tree-shaking/blob/master/dist/car.prod.bundle.js).

可以看到函数 getVersion 被移除了，这是我们所预期的，然而类 V6Engine 并没有被移除。这是什么原因呢？

#### 问题

首先 Babel 检测到 ES6 模块将其转换为 ES5，然后 Webpack 将所有的模块聚集起来，最后 UglifyJS 会移除未使用的代码。我们来看一下 UglifyJS 的输出，就可以找到问题出在哪里。

*WARNING in car.prod.bundle.js from UglifyJs
Dropping unused function getVersion [car.prod.bundle.js:103,9]
Side effects in initialization of unused variable V6Engine [car.prod.bundle.js:79,4]*

它告诉我们类 *V6Engine* 转换为 ES5 的代码在初始化时有副作用。
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

在使用 ES5 语法定义类时，类的成员函数会被添加到属性 *prototype*，没有什么方法能完全避免这次赋值。UglifyJS 不能够分辨它仅仅是类声明，还是其它有副作用的操作 -- UglifyJS 不能做控制流分析。

编译过程阻止了对类进行 tree-shaking。它仅对函数起作用。

在 Github 上，有一些相关的 bug report：[Webpack repository](https://github.com/webpack/webpack/issues/2867)、[UglifyJS repository](https://github.com/mishoo/UglifyJS2/issues/1261)。一个解决方案是 UglifyJS 完全支持 ES6，希望[下个主版本](https://github.com/mishoo/UglifyJS2/issues/1411)能够支持。另一个解决方案是将其标记为 pure（无副作用），以便 UglifyJS 能够处理。这种方法[已经实现](https://github.com/mishoo/UglifyJS2/pull/1448)，但要想生效，还需编译器支持将类编译后的赋值标记为 @\__PURE\__。实现进度：[Babel](https://github.com/babel/babel/issues/5632)、[Typescript](https://github.com/Microsoft/TypeScript/issues/13721)。

#### 使用 Babili

Babel 的开发者们认为：为什么不开发一个基于 Babel 的代码压缩工具，这样就能够识别 ES6+ 的语法了。所以他们开发了[Babili](https://github.com/babel/babili)，所有 Babel 可以解析的语言特性它都支持。Babili 能将 ES6 代码编译为 ES5，移除未使用的类和函数，这就像 UglifyJS 已经支持 ES6 一样。

Babili 会在编译前删除未使用的代码。在编译为 ES5 之前，很容易找到未使用的类，因此 tree-shaking 也可以用于类声明，而不再仅仅是函数。

我们只需用 Babili 替换 UglifyJS，然后删除 babel-loader 即可。另一种方式是将 Babili 作为 Babel 的预设，仅使用 babel-loader（移除 UglifyJS 插件）。推荐使用第一种（插件的方式），因为当编译器不是 Babel（比如 Typescript）时，它也能生效。

```
module: {
  rules: []
},

plugins: [
  new BabiliPlugin()
]
```

我们需要将 ES6+ 代码传给 BabiliPlugin，否则它不用移除（未使用的）类。

使用 Typescript 等编译器时，也应当使用 ES6+。Typescript 应当输出 ES6+ 代码，以便 tree-shaking 能够生效。

现在的输出不再包含类 *V6Engine*：[压缩后代码](https://github.com/blacksonic/babel-webpack-tree-shaking/blob/master/dist/car.es2015.prod.bundle.js)。

#### 第三方包

对第三方包来说也是，应当使用 ES6 模块。幸运的是，越来越多的包作者同时发布 CommonJS 格式 和 ES6 格式的模块。ES6 模块的入口由 *package.json* 的字段 *module* 指定。

对 ES6 模块，未使用的函数会被移除，但 class 并不一定会。只有当包内的 class 定义也为 ES6 格式时，Babili 才能将其移除。很少有包能够以这种格式发布，但有的做到了（比如说 lodash 的 lodash-es）。

罪魁祸首是当包的单独文件通过扩展它们来修改其他模块时，导入文件有副作用。[RxJs](https://github.com/Reactive-Extensions/RxJS)就是一个例子。通过导入一个运算符来修改其中一个类，这些被认为是副作用，它们阻止代码进行 tree-shaking。

#### 总结

通过 tree-shaking 你可以相当程度上减少应用的体积。Webpack 2 内置支持它，但其机制并不同于 Rollup。它会包含所有的代码，标记未使用的函数和函数，以便压缩工具能够移除。这就是对所有代码都进行 tree-shake 的困难之处。使用默认的压缩工具 UglifyJS，它仅移除未使用的函数和变量；Babili 支持 ES6，可以用它来移除（未使用的）类。我们还必须特别注意第三方模块发布的方式是否支持 tree-shaking。

希望这篇文章为您清楚阐述了 Webpack tree-shaking 背后的原理，并提供了克服困难的思路。

实际例子请访问 [Babel](https://github.com/blacksonic/babel-webpack-tree-shaking)、[Typescript](https://github.com/blacksonic/typescript-webpack-tree-shaking)。

---

*感谢阅读！喜欢本文请点击[原文](https://blog.craftlab.hu/how-to-do-proper-tree-shaking-in-webpack-2-e27852af8b21)中的 ❤，然后分享到社交媒体上。欢迎关注 [Medium](https://medium.com/@blacksonic86)，[Twitter](https://twitter.com/blacksonic86) 阅读更多有关 Javascript 的内容！*


  ---

  > [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
  
