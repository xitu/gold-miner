> - 原文地址：[Understanding Modules and Import and Export Statements in JavaScript](https://www.digitalocean.com/community/tutorials/understanding-modules-and-import-and-export-statements-in-javascript)
> - 原文作者：[Tania Rascia](https://www.digitalocean.com/community/users/taniarascia)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/understanding-modules-and-import-and-export-statements-in-javascript.md](https://github.com/xitu/gold-miner/blob/master/article/2020/understanding-modules-and-import-and-export-statements-in-javascript.md)
> - 译者：[NieZhuZhu（弹铁蛋同学）](https://github.com/NieZhuZhu)
> - 校对者：[zenblo](https://github.com/zenblo)、[Qiaoj](https://github.com/Usualminds)、[lsvih](https://github.com/lsvih)

# 理解 JavaScript 中模块的导入和导出

![](https://user-images.githubusercontent.com/5164225/99609213-6b3c6a00-2a4a-11eb-9fce-6d7b3091a4e9.png)

## 简介

早期的 Web 网站主要由 [HTML](https://www.digitalocean.com/community/tutorial_series/how-to-build-a-website-with-html) 和 [CSS](https://www.digitalocean.com/community/tutorial_series/how-to-build-a-website-with-css) 组成。如果有任何 JavaScript 的代码需要在页面中执行，通常是以小的代码片段的形式来提供功能和交互性。结果就是通常 JavaScript 的代码都会被编写在一个文件中，然后通过 `script` 标签加载到页面中。开发人员可以将 JavaScript 代码拆分成多个 js 文件，但是所有 JavaScript 变量和[函数](<(https://www.digitalocean.com/community/tutorials/how-to-define-functions-in-javascript)>)都会被添加到全局[作用域](https://www.digitalocean.com/community/tutorials/understanding-variables-scope-hoisting-in-javascript)中。

但是随着 [Angular](https://www.digitalocean.com/community/tags/angularjs)、[React](https://www.digitalocean.com/community/tutorial_series/how-to-code-in-react-js) 以及 [Vue](https://www.digitalocean.com/community/tags/vue-js) 等 Web 框架技术的发展，并且大部分公司都在开发高级 Web 应用而非桌面应用，JavaScript 就变得越来越重要了。将能够复用的代码逻辑封装成公共代码，并且在避免全局命名空间污染的前提下，将其模块化，这一需求就成为了必要。

[ECMAScript 2015](http://www.ecma-international.org/ecma-262/6.0/) 规范引入了允许使用 `import` 和 `export` 语句的 **modules** 概念。在本教程中，你将学习什么是 JavaScript 模块以及如何使用 `import` 和` export` 管理代码结构。

## 模块化编程

在 JavaScript 引入模块化概念之前，当开发人员想要将代码封装时，需要创建多个文件并将这些文件链接为单独的脚本。作者为了说明这一点，创建了一个示例：`index.html` 文件和两个 `JavaScript` 文件，`functions.js` 和`script.js`。

`index.html` 文件将显示两个数字的和，差，乘积和商的结果，并在脚本标签中链接到两个 `JavaScript` 文件。 在文本编辑器中新建 `index.html` 并添加以下代码：

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <title>JavaScript Modules</title>
  </head>

  <body>
    <h1>Answers</h1>
    <h2><strong id="x"></strong> and <strong id="y"></strong></h2>

    <h3>Addition</h3>
    <p id="addition"></p>

    <h3>Subtraction</h3>
    <p id="subtraction"></p>

    <h3>Multiplication</h3>
    <p id="multiplication"></p>

    <h3>Division</h3>
    <p id="division"></p>

    <script src="functions.js"></script>
    <script src="script.js"></script>
  </body>
</html>
```

该 HTML 将在 `h2` 标签中显示变量 `x` 和 `y` 的值，并在其下 `p` 元素中显示这些变量的运算值。元素 `id` 属性为了方便 `script.js` 文件中的 [DOM 操作](https://www.digitalocean.com/community/tutorial_series/understanding-the-dom-document-object-model)，`script.js` 文件还会设置 `x` 和 `y` 的值。更多 HTML 相关内容可以参考我的[如何使用 HTML 创建网站](https://www.digitalocean.com/community/tutorial_series/how-to-build-a-website-with-html)系列文章。

`functions.js` 文件则提供第二个脚本中将要使用到的数学函数。打开 `functions.js` 文件并添加以下内容：

```js
function sum(x, y) {
  return x + y;
}

function difference(x, y) {
  return x - y;
}

function product(x, y) {
  return x * y;
}

function quotient(x, y) {
  return x / y;
}
```

最后，`script.js` 文件将计算出 `x` 和 `y` 的值，并显示结果：

```js
const x = 10;
const y = 5;

document.getElementById("x").textContent = x;
document.getElementById("y").textContent = y;

document.getElementById("addition").textContent = sum(x, y);
document.getElementById("subtraction").textContent = difference(x, y);
document.getElementById("multiplication").textContent = product(x, y);
document.getElementById("division").textContent = quotient(x, y);
```

完成上述操作之后, 可以在浏览器中打开 [`index.html`](https://www.digitalocean.com/community/tutorials/how-to-use-and-understand-html-elements#how-to-view-an-offline-html-file-in-your-browser) 查看运行结果:

![Rendered HTML with the values 10 and 5 and the results of the functions.js operations.](https://user-images.githubusercontent.com/5164225/99609235-72fc0e80-2a4a-11eb-93a9-dcf4505f4fd1.png)

对于只有少量 `script` 文件的网站应用，这是个很高效的代码拆分方案。然而，这种做法会存在一些问题：

- **污染全局命名空间**：在脚本中创建的所有变量包括 `sum`, `difference` 等等，都会存在全局 [`window`](https://developer.mozilla.org/en-US/docs/Web/API/Window) 对象中。如果试图在一个文件中使用一个名为 `sum` 的变量，那么就会很难知晓我们使用的是在哪个脚本中的 `sum`，因为它们都是使用的相同全局 `window.sum` 变量。将变量私有化的唯一方法就是将变量放入函数作用域中。DOM 中的名为 `x` 的 `id` 属性和 `var id` 的变量也会存在冲突（因为如果在 DOM 中使用了 `id` 属性，浏览器会声明一个同名的全局变量）。
- **依赖管理**：必须从上到下依次加载 `script`，以确保变量正确可用。将 `<script>` 分成不同文件依次引入会给人分离的错觉，但本质上这种方式与在浏览器页面中使用单个 `<script>` 来引入脚本代码是相同效果的。

在 ES6 将原生模块概念添加到 JavaScript 语言之前，社区尝试了几种解决方案。第一个解决方案就是通过普通的 JavaScript 对象实现的，比如将所有代码写在 [objects](https://www.digitalocean.com/community/tutorials/understanding-objects-in-javascript) 或者[立即调用的函数表达式（IIFE）](https://developer.mozilla.org/en-US/docs/Glossary/IIFE)并将它们放在全局中作用域中的单个对象中。这是对多脚本方法的一种改进，但是仍然会存在将至少一个对象放入全局名称空间的相同问题，并且始终没有解决多个脚本之间共享代码的问题。

之后，出现了一些模块化解决方案：[CommonJS](https://en.wikipedia.org/wiki/CommonJS)，是在 [Node.js](https://www.digitalocean.com/community/tutorial_series/how-to-code-in-node-js) 实现的同步加载模块的方法，[异步模块定义（AMD）](https://en.wikipedia.org/wiki/Asynchronous_module_definition)则是非同步加载模块，还有[通用模块定义（UMD）](https://github.com/umdjs/umd)，旨在成为能够支持两种加载模式的通用的解决方案

这些解决方案的出现使得开发人员更容易地以 **package** 的形式共享和重用代码，这些模块也可以被转发和共享，例如一些能在 [npm](https://www.npmjs.com/) 上找到的 packages。但是, 由于有如此多的解决方案并且没有一个是 JavaScript 原生的，所以为了能在浏览其中使用模块，一些相应的工具出现了，比如 [Babel](https://babeljs.io/)、[Webpack](https://webpack.js.org/) 以及 [Browserify](http://browserify.org/)。

由于多文件方案存在许多问题，并且所提出的解决方案很复杂，因此开发人员对将[模块化编程](https://en.wikipedia.org/wiki/Modular_programming)引入 JavaScript 语言很感兴趣。因此，ECMAScript 2015 支持 JavaScript 模块的使用。

一个**模块**是一段可以为其他模块提供函数功能的代码块，同时也可以依赖别的模块里的功能。模块中 **exports** 用以导出， **imports** 用来引用。模块之所以有用，是因为它们允许开发人员复用代码，它们提供许多开发人员可以使用的稳定、一致的接口，并且它们还不会污染全局命名空间。

模块（有时称为 ECMAScript 模块或 ES 模块）现在可以在 JavaScript 中直接使用，在本教程的剩余部分中，你将探索如何在代码中使用和实现它们。

## 原生 JavaScript 模块

JavaScript 中的模块使用 `import` 和 `export` 关键字:

- `import`: 用于读取从另一个模块导出的代码。
- `export`: 用于向其他模块提供代码。

为了演示如何使用模块的导入导出，请将 `functions.js` 文件中函数使用模块导出。在每个函数的前面添加 `export` 关键字，这可以让导出的函数在其他模块使用。

将以下的代码添加到文件中：

```js
export function sum(x, y) {
  return x + y;
}

export function difference(x, y) {
  return x - y;
}

export function product(x, y) {
  return x * y;
}

export function quotient(x, y) {
  return x / y;
}
```

现在，在 `script.js` 中，你可以在 `functions.js` 文件的顶部使用 `import` 从其他模块引入代码。

**注意**：`import` 必须始终位于文件的顶部。在这个例子中并且还必须使用相对路径（本示例为 `./`）。

将以下代码添加到 `script.js` 中：

```js
import { sum, difference, product, quotient } from "./functions.js";

const x = 10;
const y = 5;

document.getElementById("x").textContent = x;
document.getElementById("y").textContent = y;

document.getElementById("addition").textContent = sum(x, y);
document.getElementById("subtraction").textContent = difference(x, y);
document.getElementById("multiplication").textContent = product(x, y);
document.getElementById("division").textContent = quotient(x, y);
```

请注意，通过在花括号中命名单个函数来导入它们。

为了确保此代码作为模块而不是常规脚本加载，请在 `index.html` 中的 `script` 标签中添加 `type ="module"`。任何使用 `import` 或 `export` 的代码都必须使用这个属性：

```html
...
<script type="module" src="functions.js"></script>
<script type="module" src="script.js"></script>
```

刷新页面以重新加载代码，这时页面就会使用模块进行加载。虽然浏览器对模块的支持度很高，但是我们可以通过 [caniuse](https://caniuse.com/?search=modules) 检查不同浏览器的支持度。请注意，如果将文件作为本地文件的的直链，就会遇到这个错误：

```
OutputAccess to script at 'file:///Users/your_file_path/script.js' from origin 'null' has been blocked by CORS policy: Cross-origin requests are only supported for protocol schemes: http, data, chrome, chrome-extension, chrome-untrusted, https.
```

由于[跨域资源共享](https://en.wikipedia.org/wiki/Cross-origin_resource_sharing)，模块必须在服务器环境中使用，可以本地使用 [http-server](https://www.npmjs.com/package/http-server) 也可以通过托管服务提供商在 Internet 上进行设置。

模块与常规脚本的区别：

- 模块不会向全局（`window`）作用域添加任何内容。
- 模块始终处于[严格模式](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Strict_mode)。
- 在同一文件中引用同一模块多次将无效，因为模块只会被执行一次。
- 模块需要运行在服务器环境。

模块也会经常与打包工具（如 Webpack）一起使用，以增加对浏览器的支持和一些附加功能，但它们也可以直接在浏览器中使用。

接下来，我们将探索更多使用 `import` 和 `export` 语法的方式。

## 按名称导出

如前所述，使用 `export` 语法将允许分别导入按名称导出的值。例如，使用以下简化版本的 `function.js`：

```js
export function sum() {}
export function difference() {}
```

这将允许使用花括号按名称导入 `sum` 和 `difference`：

```js
import { sum, difference } from "./functions.js";
```

也可以使用别名来重命名该函数以避免在同一模块中命名冲突。在此示例中，`sum` 将重命名为 `add`，`difference` 将重命名为 `subtract`。

```js
import { sum as add, difference as subtract } from "./functions.js";

add(1, 2); // 3
```

在这里调用 `add()` 将产生 `sum()` 函数的结果。

使用 `*` 语法，可以将整个模块的内容导入到一个对象中。在下面这种情况下，`sum` 和 `difference` 将成为 `mathFunctions` 对象上的方法。

```js
import * as mathFunctions from "./functions.js";

mathFunctions.sum(1, 2); // 3
mathFunctions.difference(10, 3); // 7
```

基础类型、函数表达式、函数定义式、[异步函数](https://www.digitalocean.com/community/tutorials/understanding-the-event-loop-callbacks-promises-and-async-await-in-javascript#async-functions-with-asyncawait)、[类](https://www.digitalocean.com/community/tutorials/understanding-classes-in-javascript)以及类的实例也可以被导出，只要它们具有标识符即可：

```js
// 基础类型值
export const number = 100;
export const string = "string";
export const undef = undefined;
export const empty = null;
export const obj = { name: "Homer" };
export const array = ["Bart", "Lisa", "Maggie"];

// 函数表达式
export const sum = (x, y) => x + y;

// 函数定义式
export function difference(x, y) {
  return x - y;
}

// 箭头函数
export async function getBooks() {}

// 类
export class Book {
  constructor(name, author) {
    this.name = name;
    this.author = author;
  }
}

// 类的实例
export const book = new Book("Lord of the Rings", "J. R. R. Tolkien");
```

所有这些 `exports` 都可以成功地 `import`。 下一小节我们将探讨的另一种导出类型 —— 默认导出。

## 默认导出

在前面的示例中，我们进行了多个命名的导出，并将它们分别导入或者作为一个对象进行了导入，以及也尝试了将导出看做一个对象，每次导出均作为该对象的方法。模块也可以使用关键字 `default` 包含默认导出。默认导出不是使用大括号导入，而是直接导入到命名标识符中。

例如，将以下内容添加至 `functions.js` 文件：

```js
export default function sum(x, y) {
  return x + y;
}
```

在 `script.js` 文件中，你可以使用以下命令将默认函数导入为 `sum`：

```js
import sum from "./functions.js";

sum(1, 2); // 3
```

这很危险，因为在导入过程中对默认导出的命名没有任何限制。在下面这个例子中，默认函数被导入为 `difference`，尽管它实际上是 `sum` 函数：

```js
import difference from "./functions.js";

difference(1, 2); // 3
```

因此，通常首选应该使用按命名导出。与按命名导出不同，默认导出不需要标识符 —— 基础类型的值或匿名函数都可以用作默认导出。下面是用作默认导出的对象的示例：

```js
export default {
  name: "Lord of the Rings",
  author: "J. R. R. Tolkien",
};
```

你可以使用以下命令将其作为 `book` 导入：

```js
import book from "./functions.js";
```

同样地，下面例子展示了[箭头函数](https://www.digitalocean.com/community/tutorials/understanding-arrow-functions-in-javascript)的默认导出：

```js
export default () => "This function is anonymous";
```

可以像下面这样引入 `script.js` 中的箭头函数：

```js
import anonymousFunction from "./functions.js";
```

按命名导出和默认导出可以同时使用，比如在下面这个模块中，导出两个命名值和一个默认值：

```js
export const length = 10;
export const width = 5;

export default function perimeter(x, y) {
  return 2 * (x + y);
}
```

我们可以使用以下代码导入这些变量和默认函数：

```js
import calculatePerimeter, { length, width } from "./functions.js";

calculatePerimeter(length, width); // 30
```

现在，默认值和命名值都可以在 `script` 中使用。

## 总结

模块化编程设计实践可以将代码拆分到单独的组件中，从而提高代码的复用率和一致性，同时还可以保护全局命名空间不被污染。模块化接口可以用原生 JavaScript 的关键字 `import` 和 `export` 来实现。

通过本文的学习，你了解了 JavaScript 中模块的历史、如何将 JavaScript 文件分离为多个脚本以及如何使用模块化方法按命名的 `import`、`export` 和默认的 `import`、`export` 语法来更新这些文件。

了解更多有关 JavaScript 中模块的信息，请阅读 [Mozilla Modules](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Modules)。如果你想探索 Node.js 中的模块，可以阅读 [How To Create a Node.js Module tutorial](https://www.digitalocean.com/community/tutorials/how-to-create-a-node-js-module)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
