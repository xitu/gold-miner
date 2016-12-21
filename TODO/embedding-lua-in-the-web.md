>* 原文链接 : [Embedding Lua in the Web](http://starlight.paulcuth.me.uk/docs/embedding-lua-in-the-web)
* 原文作者 : [paulcuth](https://github.com/paulcuth)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [narcotics726](https://github.com/narcotics726)
* 校对者: [markzhai](https://github.com/markzhai), [yangzj1992](https://github.com/yangzj1992)

# Starlight - 在网页中运行 Lua

Starlight 可以让你通过「将 Lua 代码置于 `<script>` 标签内」的方式在网页内运行 Lua 脚本。

### Hello world

这里是个简单示例：

[JS Bin on jsbin.com](http://jsbin.com/rovibad/embed?html,console)

可以看到，我们把 Lua 代码包围在一个 `type="application/lua"` 的 `<script>` 标签内部。这样的标签告诉浏览器不要把这段代码当作 JavaScript，也通知 Starlight 对该标签的代码进行解析。

同时我们在浏览器环境中也引入了 Babel，因为 Starlight 输出的是 ES6 代码。并且至少到目前为止，大多数的浏览器也尚未全面支持 ES6。希望在不远的未来我们对于「引入 Babel」的需求可以大大降低。也可以参见 [使用 Grunt 与 Starlight 协作](http://starlight.paulcuth.me.uk/docs/using-starlight-with-grunt) 来学习如何通过预编译来避免引入 Babel。

我们还需要引入 Starlight 本身。在这里，我们使用 `data-run-script-tags` 这个布尔属性来告诉 Starlight 在页面载入时运行脚本。缺少这个属性的话，这些脚本就只能被手动执行了。

到这里为止就不需要其他准备工作了。注意 `print()` 方法会把内容输出到浏览器的控制台窗口。这一行为可以在 Starlight 的配置中修改。

#### MIME  类型

Starlight 会解析所有含有以下 `type` 的标签：

*   text/lua
*   text/x-lua
*   application/lua
*   application/x-lua

### 引入远端脚本

如同 JavaScript 一样，你也可以利用 `src` 属性来引入并运行远端的 Lua 脚本。但有一点不同，远端的文件是通过 [<attr title="XMLHttpRequest">XHR</attr>](https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest) 载入的，因此远端需要做出相应的 [<attr title="Cross-Origin Resource Sharing">CORS</attr>](https://developer.mozilla.org/en-US/docs/Web/HTTP/Access_control_CORS) 配置。

[counter-app.lua](http://paulcuth.me.uk/starlight/lua/counter-app.lua) [JS Bin on jsbin.com](http://jsbin.com/mohoci/embed?html,output)

脚本会按照在页面出现的顺序进行解析。要实现非阻塞的加载，你可以添加一个 `defer` 属来将某个脚本的加载动作延迟到其余所有脚本都加载完毕之后。在内联脚本标签中，`defer` 会被忽略。

### 在JavaScript中直接执行Lua代码

使用 starlight.parser.parse() ，就可以用 Starlight 在 JavaScript 中执行任意 Lua 代码。

[JS Bin on jsbin.com](http://jsbin.com/rutoni/embed?html,console,output)

在这种场景下，使用解析器（parser）的一个优秀范例是：将 Lua 代码放置在 `script` 标签中，然后按需执行它们。这样的话，要记得不要在页面加载时就执行这些 Lua 代码，也就是说，不要加上 `data-run-script-tags` 这个属性。

[JS Bin on jsbin.com](http://jsbin.com/coheya/embed?html,console,output)

### 模块

通过 `data-modname` 这个属性，我们可以将 `script` 标签转变成一个 Lua 模块。这个标签会被预加载但不会立刻执行，同时，可以被之后其他的 Lua 代码引用（require）。但要保证这个模块所在的标签出现在其他引用它的脚本之前。

[JS Bin on jsbin.com](http://jsbin.com/gadequp/embed?html,console)

`data-modname` 这个属性同样可以被用在远端 `script` 标签上。使用 `script`标签时，所有模块必须在当前页面上显式定义。除非被引用的代码在页面上定义过，否则使用相对文件路径进行 `require()` 都会失败。以上规则不适用于使用 Starlight 进行预编译的情况，参见 [使用 Grunt 与 Starlight 协作](http://starlight.paulcuth.me.uk/docs/using-starlight-with-grunt) 来获取更多信息。

[fibonacci-module.lua](http://paulcuth.me.uk/starlight/lua/fibonacci-module.lua) / [fibonacci-app.lua](http://paulcuth.me.uk/starlight/lua/fibonacci-app.lua) [JS Bin on jsbin.com](http://jsbin.com/xumoka/embed?html,output)

### 配置

通过在引入 Starlight 浏览器端库 _之前_ 在 JavaScript 中创建一个配置对象，我们可以对 Starlight 进行配置。

这个对象就是 `window.starlight.config`，目前可以通过这个对象来覆盖 `stdout` 的目标位置，以及向 Lua 的全局命名空间中添加变量。

接下来的例子中，我们将把 `stdout` 的输出从浏览器的控制台重定向到 DOM 元素中。

[JS Bin on jsbin.com](http://jsbin.com/silezu/embed?html,output)

要使用该配置对象来初始化 Lua 的全局环境，参见 [与 JavaScript 交互](http://starlight.paulcuth.me.uk/docs/interacting-with-javascript)。
