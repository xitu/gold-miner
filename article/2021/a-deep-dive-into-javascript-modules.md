> - 原文地址：[A Deep Dive Into JavaScript Modules](https://blog.bitsrc.io/a-deep-dive-into-javascript-modules-550ad88d8839)
> - 原文作者：[Fernando Doglio](https://medium.com/@deleteman123)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/a-deep-dive-into-javascript-modules.md](https://github.com/xitu/gold-miner/blob/master/article/2021/a-deep-dive-into-javascript-modules.md)
> - 译者：[regon-cao](https://github.com/regon-cao)
> - 校对者：[PassionPenguin](https://github.com/PassionPenguin) [Ashira97](https://github.com/Ashira97)

# 深入了解 JavaScript 模块

![Image by [HeungSoon](https://pixabay.com/users/heungsoon-4523762/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=3887440) from [Pixabay](https://pixabay.com/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=3887440)](https://cdn-images-1.medium.com/max/3840/1*Dya93Aqh8dXO4ngaaxHsug.jpeg)

所有 JavaScript 开发人员都知道如何导入模块，如果你以前没有这么做过，那么你还没有看过基本的 “helloworld” 示例。模块是 JavaScript 生态系统的基石。

但是你知道 JavaScript 中有不同的模块系统吗？如果你一直使用 Node.js 开发, 你能够很熟练地使用 `require`，如果你一直和 React 打交道，你可能更多的是一个 `import` 开发者。事实上，它们都能完成任务，但是完成的方式并不相同。

了解 JS 模块类型之间的各种差异的最佳方法是从大家熟悉的地方开始，在这里，也就是从这门语言的新标准 ES6 开始。因为不是所有的运行时都兼容 ES6，所以在需要时我会用 Babel 将代码转换成运行时环境所需的风格。

基础代码如下：

```TypeScript
import _ from 'lodash'

export const dummyFunction = () => {
  return _.camelCase('dummy');
}
```

如你所见，代码并不复杂，我们没有做很多事情，只是导入 `lodash` 库并从我们自己的模块中导出一个函数。

为了用 Babel 编译它，我将使用以下配置：

```
{
    "presets": [
      ["@babel/preset-env", {
          "modules": "<my module system>"
      }]
    ]
 }
```

## CommonJS

如果你是一个 Node.js 开发者，你以前可能用过它。CommonJS 是 Node 采用的标准，而它使用的是 `require` 函数。

我们示例的输出如下：

```JavaScript
"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.dummyFunction = void 0;

var _lodash = require("lodash");

var dummyFunction = function dummyFunction() {
  return (0, _lodash.camelCase)('dummy');
};

exports.dummyFunction = dummyFunction;
```

我们首先看到，它向 `exports` 对象添加了两个属性。这个对象将会包含“公共”代码。换句话说，任何不属于此对象的内容都无法从外部访问。此对象可以作为 `require` 函数的返回值。如果向其中添加属性，在加载模块时可以直接访问它们：

```js
//yourmodule.js
exports.prop1 = 42;
exports.myFn = () => console.log(42);

//... 客户端的代码
const { prop1, myFn } = require("./yourmodule.js");
```

上面代码示例的第二个重点是，我们添加了 `__esModule` 属性（值为 `true`）。导入端的辅助函数可以在处理默认导出时利用此属性来确定如何访问所需的方法。

你知道的，CommonJS 没有“默认”导出的概念，如果你像下面一样使用 `require`，那么 `exports` 上的所有属性都将被导出：

```js
const myModule = require("yourmdoule.js");
```

你将得到一个包含一系列属性和方法的对象（即导出的所有内容）。但是，ES6 定义了一种方法来区分默认导出的内容和单独导出的内容。所以你可以这样做：

```JavaScript
//mymodule.js

import { camelCase } from 'lodash';

export const dummyFunction = () => {
  return camelCase('dummy');
};

export const dummyConst = 42;

export default {
  mainMethod: function() {
    //你的逻辑...
  }
}
```

这段代码导出 3 个东西：

- 默认导出包含一个 `mainMethod` 方法的对象。
- 同时也导出一个 `dummyFunction` 函数和一个 `dummyConst` 值。

在导入端，你可以这样做：

```JavaScript
import myModule, {dummyFunction} from 'mymodule.js'

myModule.mainMethod()
dummyFunction()
```

这就是 ES6 和 CommonJS 提供的默认导出之间的主要区别。上面的代码不能直接转译成 CommonJS，因为它没有默认导出的概念。然而，诸如 Babel 之类的工具会通过添加 “相互操作” 代码（比如 `__esModule` 属性）来解决这个问题。

因此，当把上面的代码段转译后，可以得到下面的：

```JavaScript
"use strict";

var _sample = _interopRequireWildcard(require("./sample1"));

function _getRequireWildcardCache() {
    if (typeof WeakMap !== "function") return null;
    var cache = new WeakMap();
    _getRequireWildcardCache = function () {
        return cache;
    };
    return cache;
}

function _interopRequireWildcard(obj) {
    if (obj && obj.__esModule) {
        return obj;
    }
    if (obj === null || typeof obj !== "object" && typeof obj !== "function") {
        return {
            default: obj
        };
    }
    var cache = _getRequireWildcardCache();
    if (cache && cache.has(obj)) {
        return cache.get(obj);
    }
    var newObj = {};
    var hasPropertyDescriptor = Object.defineProperty && Object.getOwnPropertyDescriptor;
    for (var key in obj) {
        if (Object.prototype.hasOwnProperty.call(obj, key)) {
            var desc = hasPropertyDescriptor ? Object.getOwnPropertyDescriptor(obj, key) : null;
            if (desc && (desc.get || desc.set)) {
                Object.defineProperty(newObj, key, desc);
            } else {
                newObj[key] = obj[key];
            }
        }
    }
    newObj.default = obj;
    if (cache) {
        cache.set(obj, newObj);
    }
    return newObj;
}

_sample.default.mainMethod();

console.log((0, _sample.dummyFunction)());
```

我知道这看起来有很多代码，但现在只关注最后两行。请注意，我们的 `mainMethod` 是默认导出的函数，它位于名为 `default` 的新属性中。我们没有声明这个属性，它是 Babel 为了实现与 CommonJS 兼容而添加的属性。还要注意 `dummyFunction` 方法不在 `default` 属性中，因为它是作为单独的实体导出的，实际上也是单独导入的。

`__interopRequiredWilcard` 辅助函数负责将要使用的对象以正确格式返回（换句话说，如果还没有 `default` 属性，它会添加该属性）。

#### CommonJS 和 ES6 之间还有什么不同？

如你所见，ES6 定义了一个 `export default` 语句，这在 CommonJS 世界中毫无意义。但还有其他什么不同呢？

另一个主要区别是，虽然它们看起来是相同的，但 `require` 和 `import` 的工作方式却不同。

一个主要区别是，`require` 在代码中的任何地方都能动态执行，但 `import` 不能。你可以将 `require` 语句视为函数调用，因此，它需要运行才能执行。但是 `import` 语句是静态的，它在解析文件时执行。与 `require` 的工作方式相比，这是一个重大的性能改进。

但是，也有一个缺点：由于 `require` 在运行时工作，我们可以动态定义导入路由，例如：

```js
const myMod = require("./src/" + pathToFile);
```

假设 pathToFile 是一个自定义的字符串，require 会正常工作，但是 import 不允许这么做，因为在解析 import 语句的时候还没有运行时执行环境。

## AMD（异步模块定义）

它代表了[异步模块定义](https://en.wikipedia.org/wiki/Asynchronous_module_definition)，这是一种为前端项目加载模块的模式。过去，在浏览器中定义一系列代码依赖的唯一方法是添加一堆 `script` 标记，并确保它们的顺序正确。一旦文档及其所有资源被完全加载，你的代码就可以运行了。

它是可行的，但还需要一点样板代码才能工作。AMD 就这样诞生了。

它简化了为模块声明特定依赖项的任务，并确保在执行代码之前加载所有依赖项。

它还增加了一个主要的改进：这种方法不必包含所有应用程序的依赖项，也不必在执行一行代码之前加载它们，而是让你可以精确地指定要为代码的每个部分加载哪些依赖项。这反过来又为具有很多外部依赖关系的大型应用带来了性能上的大幅提升。

回到我们的例子，如果我们想添加相同且简单的 ES6 模块，但使用 AMD，我们会这样做：

```JavaScript
define(['lodash'], function(_lodash) {

  const dummyFunction = () => {
    return _lodash.camelCase('dummy');
  }

  return {
    dummyFunction
  }
})
```

使用 AMD 的框架将提供一个 `define` 函数，该函数接受第一个参数，即依赖项列表。一旦加载了依赖项，我们的函数就会被执行。还要注意我们是如何去掉 `export` 语句的，因为函数返回的任何内容都将被导出。

这解决了前端世界的两个主要问题：

1. 在我们需要它们之前，所有依赖项都已正确加载。
2. 我们的代码在安全作用域内运行。通过在函数中编写模块，我们可以避免命名冲突，特别是在依赖项之间。

请记住，AMD 只是一个标准，因此你需要一个实现它的框架为你提供 API，[RequireJS](https://requirejs.org/)就是其中一个框架。

## UMD（通用模块定义）

就像 AMD 试图定义更好的模块加载模式一样，[UMD](https://github.com/umdjs/umd)定义了通用模块定义。换言之，它试图提供一种方法，以一种稍后可以由多个加载程序加载的格式编写模块。

一个 UMD 声明主要是由两个部分组成：

1. 一个立即执行函数，它接收两个参数：`root` 是对全局作用域的引用，`factory` 函数是模块的代码。
2. 我们的 `factory` 函数。它接收依赖项并可以在单独的作用域内执行，就像 AMD 模式一样。

在初始化的立即执行函数中，我们将添加一些样板逻辑，根据我们的需要决定使用哪个模块加载程序。

一旦我们将原始代码转换成 UMD，请查看 Babel 的输出：

```JavaScript
(function (global, factory) {
  if (typeof define === "function" && define.amd) {
    define(["exports", "lodash"], factory);
  } else if (typeof exports !== "undefined") {
    factory(exports, require("lodash"));
  } else {
    var mod = {
      exports: {}
    };
    factory(mod.exports, global.lodash);
    global.sample1 = mod.exports;
  }
})(typeof globalThis !== "undefined" ? globalThis : typeof self !== "undefined" ? self : this, function (_exports, _lodash) {
  "use strict";

  Object.defineProperty(_exports, "__esModule", {
    value: true
  });
  _exports.dummyFunction = void 0;

  const dummyFunction = () => {
    return (0, _lodash.camelCase)('dummy');
  };

  _exports.dummyFunction = dummyFunction;

});
```

立即执行函数首先检查 AMD 是否已定义（它查找 `define` 函数），如果未定义，则查找 `exports` 关键字是否可用。这意味着此时我们正在和一个 CommonJs 加载器打交道。

最后，如果没有定义它们，那么它将继续创建一个公共对象，该对象稍后将被分配给全局作用域。这里的全局作用域由 `global` 变量（接收到的第一个参数）引用。

第二个函数，如你所见，包含我们的示例模块，几乎没有被改动过。唯一的区别是它现在接收两个参数，一个是`__exports`，我们将在其中添加我们要导出的内容，另一个是`__lodash`，包含我们声明的依赖项（lodash）。

这种模式可能需要添加更多的代码来包装你的模块，但它将确保可以与多个系统兼容。如果你要分发一个供许多用户使用的库，那么这绝对是一个有趣的选择。另一方面，如果你只是为自己的系统创建一个模块，那么额外的工作和代码行可能不值得。

## SystemJS

我将在这里介绍的最后一个模块加载器是 [SystemJS](https://github.com/systemjs/systemjs)。它提供了将 ES6 兼容的代码加载到不兼容的运行时环境的另一种方法。换句话说，通过使用自定义的 `import` 函数，你可以直接加载 ES6 代码，而无需将其转换为任何内容。

你可以写出下面的代码：

```JavaScript
var SystemJS = require('systemjs');

SystemJS.config({
    map: {
        'traceur': 'node_modules/traceur/bin/traceur.js',
    }
});

SystemJS.import('./mymodule.js')
    .then(function(main) {
        var t = main.dummyFunction();
        console.log(t);
    })
    .catch(function(e) {
        console.error(e)
    });
```

`traceu` 依赖包是 SystemJS 所必需的，因此我们需要它，但是代码的其余部分正在加载并使用我们在本文开头声明的模块（它只使用 ES6 类型的导出和导入）。

如果我们希望在一个不兼容的运行时环境重用所有与 ES6 兼容的代码，那么这绝对是一个不错的选择。

---

在编写和使用 JavaScript 模块时，有很多选择，这取决于你的需要和偏好，但说实话，在不久的将来，所有运行时都应该迁移到与 ES6 兼容的版本，因为这是语言未来的发展方向。这反过来意味着，除非你是为过时的系统编写代码，否则最好选择原生支持的格式。

**现在，让我来问你：哪一个是你最喜欢的模块加载器？**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
