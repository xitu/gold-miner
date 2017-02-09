> * 原文地址：[How to write a JavaScript package for both Node and the browser](https://nolanlawson.com/2017/01/09/how-to-write-a-javascript-package-for-both-node-and-the-browser/)
* 原文作者：[Nolan Lawson](https://nolanlawson.com/about/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[luoyaqifei](http://www.zengmingxia.com)
* 校对者：[fghpdf](https://github.com/fghpdf)，[Romeo0906](https://github.com/Romeo0906)

# 怎样写一个能同时用于 Node 和浏览器的 JavaScript 包？#

我在这个问题上见过很多困惑，即使是很有经验的 JavaScript 开发者也可能难以把握其中的巧妙之处。因此我认为值得为它书写一小段教程。

假设你有一个 JavaScript 的模块想要发布到 npm 上，它是同时适用于 Node 和浏览器的。但是请注意！这个特殊的模块在 Node 版本和浏览器版本上的实现有着细微的区别。

这种情况出现得实在频繁，因为在 Node 和浏览器间有着很多微小的环境差别。在这种情况下，可以用比较巧妙的方法来正确地实现，尤其是当你在尝试着使用最小的 browser 包（bundle）来优化的时候。

### 让我们构建一个 JS 包 ###

因此让我们来写一个小的 JavaScript 包，叫做 `base64-encode-string`。它所做的只是接收一个字符串作为输入，输出其 base64 编码的版本。

对于浏览器来说，这很简单：我们只需要使用自带的 `btoa` 函数：

```
module.exports = function (string) {
  return btoa(string);
};
```

然而在 Node 里并没有 `btoa` 函数。因此，作为替代，我们需要自己创建一个 `Buffer`，然后在上面调用 [buffer.toString()](https://nodejs.org/api/buffer.html#buffer_buf_tostring_encoding_start_end)：

```
module.exports = function (string) {
  return Buffer.from(string, 'binary').toString('base64');
};
```

对于一个字符串，这两者都应提供其正确的 base64 编码版本，比如：


```
var b64encode = require('base64-encode-string');
b64encode('foo');    // Zm9v
b64encode('foobar'); // Zm9vYmFy
```

现在我们只需要一些方法来检测我们究竟是在浏览器上运行还是在 Node 上，好让我们能保证使用正确的版本。Browserify 和 Webpack 都定义了一个叫 `process.browser` 的字段，它会返回 `true`（译者注：即浏览器环境下），然而在 Node 上这个字段返回 `false`。所以我们只需要简单地：



```
if (process.browser) {
  module.exports = function (string) {
    return btoa(string);
  };
} else {
  module.exports = function (string) {
    return Buffer.from(string, 'binary').toString('base64');
  };
}
```

现在我们只需要把我们的文件命名为 `index.js`，键入 `npm publish`，我们就完成了，对不对？好的吧，这个方法有效，但不幸的是，这种实现有一个巨大的性能问题。

因为我们的 `index.js` 文件包含了对 Node 自带的 `process` 和 `Buffer` 模块的引用，Browserify 和 Webpack 都会自动引入 [其](https://github.com/defunctzombie/node-process) [polyfill](https://github.com/feross/buffer)，来将它们打包进这些模块。

对于这个简单的九行模块，我算了一下， Browserify 和 Webpack 会创建 [一个压缩后有 24.7KB 的包](https://gist.github.com/nolanlawson/6891be612c8faca42d2d9492b0d54e24) (7.6KB min+gz)。对于这种东西，用掉的空间实在是太多，因为在浏览器里，只需要 `btoa` 就能表示这个。

### “browser” 字段，我该如何爱你 ###

如果你在 Browserify 或者 Webpack 文档里找解决这个问题的提示，你可能最后会发现 [node-browser-resolve](https://github.com/defunctzombie/node-browser-resolve)。这是一个对于 `package.json` 内 `"browser"` 字段的规范，可以被用于定义在浏览器版本构建时需要被换掉的东西。

使用这种技术，我们可以将接下来这段加入我们的 `package.json`：

```
{
  /* ... */
  "browser": {
    "./index.js": "./browser.js"
  }
}
```

然后将函数分割成两个不同的文件：`index.js` 和 `browser.js`：

```
// index.js
module.exports = function (string) {
  return Buffer.from(string, 'binary').toString('base64');
};

// browser.js
module.exports = function (string) {
  return btoa(string);
};
```

有了这次改进以后，Browserify 和 Webpack 会给出 [更加合理的包](https://gist.github.com/nolanlawson/a8945de1dd52fdc9b4772a2056d3c3b7)：Browserify 的包压缩后是 511 字节（315 min+gz)，Webpack 的包压缩后是 550 字节（297 min+gz）。

当我们将我们的包发布到 npm 时，在 Node 里运行 `require('base64-encode-string')` 的人将得到 Node 版的代码，在 Browserfy 和 Webpack 里跑的人会得到浏览器版的代码。

对于 Rollup 来说，这就有点复杂了，但也不需要太多额外的工作。Rollup 用户需要使用 [rollup-plugin-node-resolve](https://github.com/rollup/rollup-plugin-node-resolve) 并在选项里将 `browser` 设置为 `true`。

对 jspm 来说，很不幸地，[没有对 “browser” 字段的支持](https://github.com/jspm/jspm-cli/issues/1675)，但是 jspm 用户可以通过 `require('base64-encode-string/browser')` 或者 `jspm install npm:base64-encode-string -o "{main:'browser.js'}"` 来迂回地解决问题。另一种方法是，包的作者可以在他们的 `package.json` 里 [指定一个 “jspm” 字段](https://github.com/jspm/registry/wiki/Configuring-Packages-for-jspm#prefixing-configuration)。

### 进阶技巧 ###

这种直接使用的 `"browser"` 方法可以工作得很好，但是对于大型项目来说，我发现它在 `package.json` 和代码库间引入了一种尴尬的耦合。比如说，我们的 `package.json` 会很快长成这样：

```
{
  /* ... */
  "browser": {
    "./index.js": "./browser.js",
    "./widget.js": "./widget-browser.js",
    "./doodad.js": "./doodad-browser.js",
    /* etc. */
  }
}
```
在这种情况下，任何时候你想要一个适配于浏览器的模块，都需要分别创建两个文件，并且要记住在 `"browser"` 字段上添加额外行来将它们连接起来。还要注意不能拼错任何东西！

并且，你会发现你在费尽心机地将微小的代码提取到分离的模块里，仅仅是因为你想要避免 `if (process.browser) {}` 检查。当这些 `*-browser.js` 文件积累起来的时候，它们会开始让代码库变得很难跳转。

如果这种情况变得实在太笨重了，有一些别的解决方案。我自己的偏好是使用 Rollup 作为构建工具，来自动地将单个代码库分割到不同的 `index.js` 和 `browser.js` 文件里。这对于将你提供给用户的代码的解模块化有额外的价值，[节省了空间和时间](https://nolanwlawson.wordpress.com/2016/08/15/the-cost-of-small-modules/)。

要这样做的话，先安装 `rollup` 和 `rollup-plugin-replace`，然后定义一个 `rollup.config.js` 文件：

```
import replace from 'rollup-plugin-replace';
export default {
  entry: 'src/index.js',
  format: 'cjs',
  plugins: [
    replace({ 'process.browser': !!process.env.BROWSER })
  ]
};
```

（我们将使用 `process.env.BROWSER` 作为一种方便地在浏览器构建和 Node 构建间切换的方式。）

接下来，我们可以创建一个带有单个函数的 `src/index.js` 文件，使用普通的 `process.browser` 条件：

```
export default function base64Encode(string) {
  if (process.browser) {
    return btoa(string);
  } else {
    return Buffer.from(string, 'binary').toString('base64');
  }
}
```

然后将 `prepublish` 步骤添加到 `package.json` 内，来生成文件：

```
{
  /* ... */
  "scripts": {
    "prepublish": "rollup -c > index.js && BROWSER=true rollup -c > browser.js"
  }
}
```

生成的文件都相当直白易读：


```
// index.js
'use strict';

function base64Encode(string) {
  {
    return Buffer.from(string, 'binary').toString('base64');
  }
}

module.exports = base64Encode;

// browser.js
'use strict';

function base64Encode(string) {
  {
    return btoa(string);
  }
}

module.exports = base64Encode;
```

你将注意到，Rollup 会按需自动地将 `process.browser` 转换成 `true` 或者  `false`，然后去掉那些无用代码。所以在生成的浏览器包里不会有对于  `process` 或者 `Buffer` 的引用。

使用这个技巧，在你的代码库里可以有任意个的 `process.browser` 切换，并且发布的结果是两个小的集中的 `index.js` 和 `browser.js` 文件，其中对于 Node 只有 Node 相关的代码，对于浏览器只有浏览器相关的代码。

作为附带的福利，你可以配置 Rollup 来生成 ES 模块构建，IIFE 构建，或者 UMD 构建。如果你想要示例的话，可以查看我的项目 [marky](https://github.com/nolanlawson/marky)，这是一个拥有多个 Rollup 构建目标的简单库。

在这篇文章里描述的实际项目（`base64-encode-string`）也同样被 [发布到 npm 上](https://www.npmjs.com/package/base64-encode-string) ，你可以审视它，看看它是怎么做到的。源码 [在 GitHub 上](https://github.com/nolanlawson/base64-encode-string)。
