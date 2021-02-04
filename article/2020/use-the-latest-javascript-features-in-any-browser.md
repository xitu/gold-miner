> * 原文地址：[How to use the latest JavaScript features in any browser](https://medium.com/javascript-in-plain-english/use-the-latest-javascript-features-in-any-browser-f047f5c426a8)
> * 原文作者：[Kesk -*-](https://medium.com/@kesk)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/use-the-latest-javascript-features-in-any-browser.md](https://github.com/xitu/gold-miner/blob/master/article/2020/use-the-latest-javascript-features-in-any-browser.md)
> * 译者：[MangoTsing](https://github.com/MangoTsing)
> * 校对者：[Chorer](https://github.com/Chorer) [Isildur46](https://github.com/Isildur46)

# 如何利用 Polyfill 和转译在所有浏览器中使用 JavaScript 的最新特性

![照片中展现了一杯咖啡和两个握紧的拳头](https://camo.githubusercontent.com/268fc311379dc699f151a1675106395018081b75/68747470733a2f2f63646e2d696d616765732d312e6d656469756d2e636f6d2f6d61782f393835362f312a6754465634696e7833754435313932413945694777412e6a706567)

JavaScript 是一门发展非常迅速的语言，如果我们想使用它的最新特性，但浏览器或运行环境不能直接支持这些特性时，就必须将代码进行转译后，才能运行。

转译（Transpiling）的意思是将一种编程语言编写的源代码，在维持同等抽象程度的情况下，转换成另一种语言。因此，在 JavaScript 中，转译器可以将旧浏览器无法理解的语法转换为它们可以理解的语法。

#### Polyfilling 与 Transpiling 的异同之处

这两种做法的目的是一致的：不管用哪个方式，都能让我们在目标环境中使用它未实现的新特性。

作为一种变通方案，polyfill 包含一段代码，这段代码替旧浏览器实现它不支持的新特性。

Transpiling 是两个词的组合：转换（transforming ）和编译（compiling）。有时，较新的语法无法使用 polyfill 模拟，这时我们就要使用转译器。

让我们假设使用的旧浏览器不支持 ES6 规范中引入的 `Number.isNaN` 功能。为了使用这个功能，我们需要为这个方法去创建一个 polyfill，但仅仅在浏览器不支持的情况下才需要这么做。

为此，我们将创建一个模拟 `isNaN` 特性的函数，并将其添加为 Number 的原型的属性。

```js
//模拟 isNaN 特性
if (!Number.isNaN) {//没有提供此方法
    Number.prototype.isNaN = function isNaN(n) {
        return n !== n;
    };
}

let myNumber = 100;
console.log(myNumber.isNaN(100));
```

现在，让我们来想象一种新出现的特性，大多数浏览器都不能执行它的代码，我们也无法创建 polyfill 来模拟这种行为，这意味着我们得转译它的代码。要在 Internet Explorer 11 上运行以下代码，我们就要用转译器对其进行转译：

```js
class mySuperClass {
  constructor(name) {
    this.name = name;
  }

hello() {
    return "Hello:" +this.name;
  }
}

const mySuperClassInstance = new mySuperClass("Rick");
console.log(mySuperClassInstance.hello()); 
//Hello Rick
```

这里的代码已经用 **[Babel 在线转译器](https://babeljs.io/en/repl)** 转译过了，现在我们可以在 Internet Explorer 11 中运行它了：

```js
"use strict";

function _instanceof(left, right) { if (right != null && typeof Symbol !== "undefined" && right[Symbol.hasInstance]) { return !!right[Symbol.hasInstance](left); } else { return left instanceof right; } }

function _classCallCheck(instance, Constructor) { if (!_instanceof(instance, Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

var mySuperClass = /*#__PURE__*/function () {
  function mySuperClass(name) {
    _classCallCheck(this, mySuperClass);

this.name = name;
  }

_createClass(mySuperClass, [{
    key: "hello",
    value: function hello() {
      return "Hello:" + this.name;
    }
  }]);

return mySuperClass;
}();

var mySuperClassInstance = new mySuperClass("Rick");
console.log(mySuperClassInstance.hello()); //Hello Rick
```

Babel 是最常见的 JavaScript 转译器之一。Babel 可以将 JavaScript 转译为不同版本，可以通过 Node 包管理器（npm）进行安装。

当浏览器不支持 ECMAScript 应用程序时，可将其转译为浏览器能运行的版本，Babel 基本上已经成为了这种转译的参照标准。它还可以转译其它版本的 ECMAScript，例如 React JSX。

在接下来的步骤中，我们将演示如何在安装了旧版本 Nodejs 的 Linux 系统中，使用 Babel 来转换和执行先前的 `mySuperMethod` 类。在 Windows 10 或 macOS 等其它操作系统中，遵循的步骤相似。

> 注意：你需要在计算机中安装 [Node.js](https://nodejs.org/en/)。Npm 是 Node.js 安装包自带的。

1. 打开命令行，并创建一个名为 babelExample 的目录：

```bash
/mkdir babelExample
/cd babelExample
```

2. 创建一个 [npm](https://www.npmjs.com/) 项目并使用默认配置。以下命令将创建一个名为 package.json 的文件：

```bash
npm init
```

![执行 npm init 命令后的 package.json 文件截图](https://cdn-images-1.medium.com/max/2000/1*9Vr8T71sWnkXpMEeFeuwSw.png)

这里的「index.js」（也可以是其他的文件）作为我们应用的一个入口文件。我们在此处编写 JavaScript 代码，因此需要创建一个「index.js」文件并写入下面的代码：

```js
class mySuperClass {
  constructor(name) {
    this.name = name;
  }

hello() {
    return "Hello:" +this.name;
  }
}

const mySuperClassInstance = new mySuperClass("Rick");
console.log(mySuperClassInstance.hello()); 
//Hello Rick
```

3. 尽管 Babel CLI 是可以全局安装的，但我们最好分别安装到每个项目的子目录中去。下一条命令将添加 node_modules 目录并修改 package.json 文件以添加 Babel 的依赖项：

```bash
npm install -save-dev @babel/core @babel/cli
```

![package.json 与 babel 依赖关系的截图](https://cdn-images-1.medium.com/max/2000/1*dp_jnVa5YeBAPp1MDg-zWQ.png)

4. 在你的项目根目录下添加 .babelrc 配置文件，并启用插件来转换 ES2015+。

> 注意：在 Babel 中，每一个转换器都是一个 plugin，我们可以单独安装。每一个 preset 都是相关 plugin 的集合，使用 **preset** 后，我们就不需要再独立安装、更新数十个 plugin 了。**

安装所有 ES6 功能的 preset（包含一组 plugin）：

```bash
npm install @babel/preset-env --save-dev
```

![package.json 与 babel preset-env 的截图](https://cdn-images-1.medium.com/max/2000/1*pWq8uX0turri10aG-TXaIw.png)

编辑您的 .babelrc 文件并添加以下配置，这会启用 ES6 转换。

.babelrc 文件：

```json
{
  "presets": ["@babel/preset-env"]
}
```

5. 用法

> 注意：如果您使用的是 Windows 10 PowerShell，请谨慎对待文件编码，因为在运行 Babel 时可能会遇到解析错误。建议文件的编码为 UTF-8。

* 输入：index.js
* 输出：out 目录（Babel 将会在这里保存已转译的文件）

直接在控制台中执行下一个命令：

```bash
./node_modules/.bin/babel index.js -d out
```

要使用 npm 脚本，你需要将下面这行添加到 package.json 文件：

```bash
"build": "babel index.js -d out"
```

![package.json 添加 build 脚本后的截图](https://cdn-images-1.medium.com/max/2000/1*IAlvZL-QsbkAhrB2ayu9LA.png)

执行以下命令：

```bash
npm run build
```

在这两种情况下，您都将在 /out 目录中获得已转译的文件，这些文件可以在不支持 ES6 类语法的浏览器中使用：

```js
"use strict";

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

var mySuperClass = /*#__PURE__*/function () {
  function mySuperClass(name) {
    _classCallCheck(this, mySuperClass);

this.name = name;
  }

_createClass(mySuperClass, [{
    key: "hello",
    value: function hello() {
      return "Hello:" + this.name;
    }
  }]);

return mySuperClass;
}();

var mySuperClassInstance = new mySuperClass("Rick");

console.log(mySuperClassInstance.hello());
```

#### 总结

JavaScript 语言一直都在不断变化。即便并非所有版本的浏览器都有相关实现，借助这些工具，我们也可以在编写代码时使用上新特性和新语法。

希望您喜欢这篇文章，感谢您的阅读。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
