> * 原文地址：[Why Deno is Perfectly Ready To Take Over Node.js Now](https://medium.com/front-end-weekly/why-deno-is-perfectly-ready-to-take-over-node-js-now-3f768efe530c)
> * 原文作者：[Charuka Herath](https://medium.com/@charuka09)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/why-deno-is-perfectly-ready-to-take-over-node-js-now.md](https://github.com/xitu/gold-miner/blob/master/article/2020/why-deno-is-perfectly-ready-to-take-over-node-js-now.md)
> * 译者：[samyu2000](https://github.com/samyu2000)
> * 校对者：[Inchill](https://github.com/Inchill), [regon-cao](https://github.com/regon-cao)

# 为什么如今 Deno 正全面取代 Node.js

![Photo by [Thao Le Hoang](https://unsplash.com/@h4x0r3) on [Unsplash](https://unsplash.com/).](https://cdn-images-1.medium.com/max/2000/0*NGYfX_xdVnytqcM1)

Deno 是一个编写服务端 JavaScript 的新工具。它的功能与 Node 不相上下。它的发明者同时也是 Node.js 的发明者。跟 Node.js 类似，它使用的是 v8 JavaScript 引擎。也有一部分功能基于 Rust 和 JavaScript 实现。Deno自面世以来就非常受欢迎。你可以通过访问它的 Github 仓库来了解相关内容。

![图 1: [GitHub repository](https://github.com/denoland/deno)](https://cdn-images-1.medium.com/max/2668/1*rqRR-dNjpDO0qcF1pfEB4g.png)

在深入研究之前，我们需要先在计算机上安装 Deno 环境。在 Mac 和 Linux 操作系统中，我们使用 shell 运行命令：

```bash
curl -fsSL https://deno.land/x/install/install.sh | sh
```

在 Windows 操作系统中我们使用 PowerShell 运行命令：

```cmd
iwr https://deno.land/x/install/install.ps1 -useb | iex
```

你也可以使用包管理工具来安装 Deno， 比如 Mac 系统中的 Homwbrew，Windows 系统中的 Chocolatey、scoop，或 Cargo（Windows,macOS,Linux均有相应版本）：

```bash
brew install deno

choco install deno

scoop install deno

cargo install deno
```

现在，我们从一个简单的 TypeScript 文件开始，研究 Deno 的使用。在这个文件中，我们可以使用运行时环境中的一切数据类型。这意味着我们可以编写强类型的代码，直接从 IDE 获得文档提示，而且不需要创建 TS 的配置文件。运行时的特性可以从 Deno 的命名空间中获得。

我们在工作目录中创建一个 TypeScript 文件，命名为 main.ts。接着，使用 console.log 输出当前文件系统的工作目录：

```js
console.log(Deno.cwd());
```

我们可以使用以下命令来执行脚本:

```bash
deno run main.ts
```

![Figure 2: Getting error without permissions.](https://cdn-images-1.medium.com/max/2000/1*9zL2lRaMgBUsfTVcVXiHdQ.png)

#### 1. 内置的权限系统

运行上述代码，结果抛出了错误，这是因为 Deno 默认启动了安全模式。Deno 在安全性处理方面优于 Node。例如，为了正常运行上述程序，需要授予访问文件系统或网络的权限。

在 Node 中，如果您导入一个被别人篡改过的包，而且这个包注入了恶意代码，可能导致整台机器上的文件都被删除。而在 Deno 中，除非您声明允许程序删除所有文件，被篡改的包在没有得到授权的情况下是无法执行任何操作的。

Deno 非常重视安全性，因此设计了内嵌的权限系统。您不必担心其他包在您的机器或服务器上执行违背您的意图的任何操作。

所以，我们需要在运行程序时授予各种权限。现在我们使用 allow-read，声明允许读取文件系统：

```bash
deno run — allow-read main.ts
```

![Figure 3: Correct output](https://cdn-images-1.medium.com/max/2000/1*WCAXkGkBiadzGR56cdCXkQ.png)

#### 2. 基于 Promise

使用 Deno 的开发人员似乎更加关注安全性。但我认为 Deno 的亮点在于，任何异步操作都基于 Promise（再见，回调函数）。

如你所见，我们可以像在浏览器中那样使用 fetch API 发起网络请求。由于 Deno 支持顶级 wait，我们甚至不需要定义异步函数。而且我们还可以在没有额外的样板代码的情况下对 promise 进行解析:

```js
const url = Deno.args[0];

const res = await fetch(url);
```

#### 3. Deno 旨在使代码尽可能兼容各种浏览器

Deno 提供了 window 对象，这个对象包含了可监听的生命周期事件。很显然，这使程序的生命周期管理更方便:

```js
window.onload = e => console.log('good bye nodejs');
```

哦，我想起来了。Deno 也可执行 WebAssembly 程序。正如 [WebAssembly 官网](https://webassembly.org/)上所说，“WebAssembly（缩写为Wasm）是一种基于堆栈的虚拟机的二进制指令格式。”

```js
const wbs = new Uint8Array([61,63,73]);

const wsm = new WebAssembly.Module(wbs);
```

#### 4. 提供了一套常用功能的标准库

更进一步，Deno 提供了一套标准库，其中包含了一些非常有用的包，用于处理日期、时间、颜色和浏览器中没有内置的功能。所以，使用 Deno 可以调用浏览器的某些功能。

标准库的好处是您可以在所有 Deno 项目中使用它，不需要从 npm 中导入模块。

**“优良的代码应该是简短、简单且对称的，难点在于理解如何达到这种标准。” — Sean Parent**

#### 5. 没有大量的 Node Modules 包

相反的，我们使用现代的 ES Module 语法导入包。远程的模块以其 URL 来表示。你第一次运行脚本时，这些程序会下载到本地并缓存。JSON 包是不存在的，代码可以从任何的 URL 引用。这跟浏览器的工作原理很相似。

正如我前面提到的，Deno 中不存在模块目录。所有的跟模块有关的配置都在后台进行。一切依赖关系也保存在本地，所以你不必为繁杂的模块目录或笨重的 package.json 文件发愁。

```js
import { Response } from "https://deno.land/std@0.63.0/http/server.ts";

import { Server } from "https://deno.land/std@0.63.0/http/server.ts";
```

![Figure 4: Downloaded dependencies](https://cdn-images-1.medium.com/max/2000/1*27PO58pHOLatMzuHKkSn4A.png)

#### 6. 提供一系列标准模块来实现通用的功能

Deno 也提供一系列标准模块来实现通用的功能。例如，我们可以使用 HTTP 模块导入服务器的功能。接着，我们用它来创建服务端，它可以视为异步可变的。然后我们让服务端等待每个请求，并逐个做出响应。

图 5: 简易的服务器

以上是对 Deno 的简单介绍。如果你需要了解更多关于 Deno 和相关编程实践，请访问[官网](https://deno.land/)。

#### 结论及不足之处

你应该看到，Deno 跟 Node.js 相比，增加了很多功能。虽然它的功能强大，有很多优良的特性，但它仍然处于早期阶段。最近 Deno 只发布了第 1 个版本，这意味着它的很多目标还没实现。例如浏览器兼容性方面，还没有做到 100% 的兼容。与浏览器有关的 API 还有待实现，而且会随着时间推移持续更新。

同时我也要指出，不要同时使用 Deno 和 npm。这实际上是一个缺点，因为 JavaScript 是基于 npm 的。问题在于，不是所有的包都与 Deno 兼容。基于 Node 的 API 也还没有面世。所以，你并不了解 Node 如此受欢迎的原因。

我认为，Deno 离广泛使用还有一段时间。

感谢您阅读本文！希望你能喜欢它。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
