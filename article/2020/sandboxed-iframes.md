> * 原文地址：[Play safely in sandboxed IFrames](https://www.html5rocks.com/en/tutorials/security/sandboxed-iframes/)
> * 原文作者：[Mike West](https://www.html5rocks.com/en/profiles/#mikewest)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/sandboxed-iframes.md](https://github.com/xitu/gold-miner/blob/master/article/2020/sandboxed-iframes.md)
> * 译者：[Gesj-yean](https://github.com/Gesj-yean)
> * 校对者：[TUARAN](https://github.com/TUARAN)，[rachelcdev](https://github.com/rachelcdev)

# 如何使用内联框架元素 IFrames 的沙箱属性提高安全性

想要构建一个体验丰富的网站，嵌入组件和内容几乎是不可避免的，而这些组件和内容你是无法真正控制的。第三方组件可以提高用户参与度并且在整个用户体验中起重要作用，且有时用户自定义内容甚至比网站本地的内容更重要。我们不能放弃使用第三方组件和用户自定义内容，但这两种方法都增加了网站的风险。你嵌入的每一个组件 —— 广告、社交媒体都可能含有恶意的攻击：

![](https://user-gold-cdn.xitu.io/2020/5/21/17235058edb61722?w=1004&h=446&f=png&s=59576)

[内容安全政策 (CSP)](http://www.html5rocks.com/en/tutorials/security/content-security-policy/) 允许白名单中的可信源嵌入脚本和其他内容，以减少第三方组件和用户自定义内容带来的风险。这是正确且重要的一步，但需要注意的是，大多数 CSP 指令只有两种情况：要么被允许，要么不被允许。有时会遇到这种矛盾的情况：我不确定内容的来源是否可 **信任** ，但我想在浏览器中嵌入它。

## 最小特权

本质上，我们正在寻找一种只授予其完成工作所需的最小权限的机制。如果组件不 **需要** 弹出一个新窗口，就禁止访问 window.open。如果组件不需要 Flash，就关闭对 Flash 插件的支持。当我们遵守 [最小特权原则](http://en.wikipedia.org/wiki/Principle_of_least_privilege)，关闭与功能不直接相关的权限，那就会很安全了。

`iframe` 元素是为这种解决方案构建良好框架的第一步。在 `iframe` 中加载不信任的组件时，它将提供应用程序与加载内容的分离：嵌入的内容不能访问页面的 DOM 或本地存储的数据，也不能在页面上任意位置绘图；它的作用范围仅限于被嵌入的元素。然而，这种分离并不是真正可靠的。被嵌入的页面仍然有许多令人讨厌或恶意的行为：比如自动播放的视频、多余的插件和弹出窗口，而这些只是冰山一角。

[`iframe` 元素的 **`sandbox`** 属性 ](http://www.whatwg.org/specs/web-apps/current-work/multipage/the-iframe-element.html#attr-iframe-sandbox)加强了对框架内容的限制。我们可以指示浏览器在低权限环境中加载特定框架的内容，只允许完成所需功能子集。

### 先去除，再校验

Twitter 的 "Tweet" 按钮是个很好的示例，它可以通过沙箱更安全地嵌入到站点中。Twitter 允许你 [通过 iframe 嵌入按钮](https://dev.twitter.com/docs/tweet-button#using-an-iframe)，用以下代码：

```html
<iframe src="https://platform.twitter.com/widgets/tweet_button.html"
        style="border: 0; width:130px; height:20px;"></iframe>
```

为了确定我们可以锁定哪些内容，需要仔细检查按钮有哪些功能。被加载的 HTML 从 Twitter 的服务器上执行一系列 JavaScript 代码，并在点击时弹出一个有推文接口的窗口。同时，为了绑定推文到正确的账号，接口需要访问 Twitter 的 cookies，最后再提交包含推文内容的表单。

沙箱工作在白名单的基础上。我们首先删除所有可能的权限，然后通过向沙箱的配置中添加特定的标志，最后再重新启用各个权限。对于 Twitter 组件，我们决定启用 JavaScript、弹出窗口、表单提交和获取 twitter.com 的 cookie 的权限。我们可以通过添加一个 `sandbox` 属性到 `iframe` ，如下:

```html
<iframe sandbox="allow-same-origin allow-scripts allow-popups allow-forms"
    src="https://platform.twitter.com/widgets/tweet_button.html"
    style="border: 0; width:130px; height:20px;"></iframe>
```

如上，我们已经为框架提供了它所需要的功能，浏览器将拒绝任何没有被 `sandbox` 属性授予的权限的访问。

### 权限的粒度控制

在上面的例子中可以看到一些可能的沙箱标志，现在让我们更详细地挖掘属性的内部工作机制。

给定一个带有空沙箱属性的 iframe（`<iframe sandbox src="..."> </iframe>`），框架文件将会被完全沙箱化，并有以下限制:

- JavaScript 将不会在框架文档中执行。这不仅包括通过 script 标签加载的 JavaScript，还包括内联事件处理程序和 javascript: URLs。这还意味着 noscript 标签中的内容会被显示，就像用户自己禁用了脚本一样。
- 框架文档被加载到唯一的源，这意味着所有同源检查都将失败；唯一的源不匹配其他源，甚至它们自己。在其他影响中，这意味着文档不能访问其他源的 cookie 或任何其他存储机制（ DOM 存储、索引数据库等）中的数据。
- 框架文档不能创建新窗口或对话框（例如，通过 `window.open` 或 `target="_blank"`）。
- 表单不能提交。
- 插件不会被加载。
- 框架文档只能导航自己，而不能导航其顶级父文档。设置 `window.top.location` 将抛出一个异常，点击带有 `target="_top"` 的链接将不起作用。
- 自动触发的功能（自动聚焦的表单元素、自动播放视频等）将被阻止。
- 无法获得 Pointer lock。
- 在框架文档包含的 `iframes` 上忽略 `seamless` 属性。

文件被加载到一个完全沙箱化的 `iframe` 中，带来的风险非常小，但这是十分苛刻的。当然，这样做也没有太大的价值：对于一些静态内容，可以使用一个完整的沙箱，但大多数情况下，可以放宽松一些。

除了插件之外，这些限制都可以通过向 sandbox 属性的值添加一个标志来解除。沙箱化的文件是不能运行插件的，因为插件源码未被沙箱化，除此之外其他的都一样：

- **`allow-forms`** 允许提交表单。
- **`allow-popups`** 允许（`window.open()`, `showModalDialog()`, `target="_blank"` 等）弹出。
- **`allow-pointer-lock`** 允许鼠标指针锁住.
- **`allow-same-origin`** 允许文档维持源；加载自 `https://example.com/` 的页面将保留对该源数据的访问权。
- **`allow-scripts`** 允许 JavaScript 执行，也允许特性自动触发(因为通过 JavaScript 实现这些特性是琐碎的)。
- **`allow-top-navigation`** 允许文档通过导航顶级窗口跳出框架。

由此，我们可以准确地知道为什么我们在上面的 Twitter 例子中使用了一组特定的沙箱标志：

- **`allow-scripts`** 是必须的，因为当页面加载到框架时，需要执行 JavaScript 来处理用户交互。
- **`allow-popups`** 是必须的，因为按钮需要在新窗口弹出表单。
- **`allow-forms`** 是必须的，因为表单内容需要提交。
- **`allow-same-origin`** 是必须的，否则 twitter.com 的 cookies 将无法访问，用户无法登录发布表单。

需要注意的重要一点是，应用于框架的沙箱标记也适用于在沙箱中创建的任何窗口或框架。这意味着我们必须将 **`allow-forms`** 添加到框架的沙箱中，即使表单只存在于框架弹出的窗口中。

有了 `sandbox` 属性后，组件只获得所需的权限，插件、顶部导航和 pointer lock 等功能仍然被禁用。我们降低了嵌入组件的风险，且没有产生不良影响。

## 分离权限

为了在低权限环境中运行不受信任的代码，对第三方内容进行沙箱化是非常有益的。但对于你自己的代码呢？你肯定相信自己，那为什么还担心沙箱化呢？

试问一下：如果你的代码不需要插件，为什么给它插件的权限？最好的情况，你不会用到这个权限；但最坏的情况，对于攻击者来说，这给了攻击者一个可乘之机。每个人的代码都有 bug，几乎每个应用程序都容易受到各式各样的攻击。代码沙箱化意味着即使一个攻击者成功的破坏你的应用，他们也不会被赋予对你应用程序 **完整** 的访问权；他们只能够做应用程序可以做的事情。虽然这样已经很糟糕，但还没到糟糕透顶的程度。

你可以通过将应用程序拆分成逻辑块，并使用尽可能少的特权对每个块进行沙箱化，以达到进一步减少危险的目的。这个方法在源码中很常见：例如 Chrome，将自己分解为一个高权限的浏览器进程，用于访问本地硬盘和网络连接；以及许多低权限的呈现进程，用于负责解析不受信任的内容。属于低权限的渲染器不需要接触磁盘，浏览器会提供渲染页面所需的所有信息。即使黑客找到了破坏渲染器的方法，也不会有什么进展，因为所有高权限访问都必须通过浏览器的进程路由。攻击者须在系统的不同部分找出漏洞，才可进行破坏，这样做就大大降低了风险。

### 安全的沙箱：`eval()` 方法

通过沙箱和 [`postMessage` API](https://developer.mozilla.org/en-US/docs/DOM/window.postMessage)，这个模型可以成功的应用到 web 上。应用程序的各个部分可以放置在沙箱化的 `iframe` 中，父文档可以通过发布消息和侦听响应使各个部分之间通信。

[Evalbox](https://www.html5rocks.com/static/demos/evalbox/index.html) 可以将字符串解析成 JavaScript 代码。而这就是你一直期待的。当然，这是一个相当危险的应用程序，因为允许任意的 JavaScript 执行意味着源提供的任何数据都是可获取的。我们通过确保代码在沙箱中执行来降低风险，从框架的内容开始，从内到外完成代码：

```html
<!-- frame.html -->
<!DOCTYPE html>
<html>
 <head>
   <title>Evalbox's Frame</title>
   <script>
     window.addEventListener('message', function (e) {
       var mainWindow = e.source;
       var result = '';
       try {
         result = eval(e.data);
       } catch (e) {
         result = 'eval() threw an exception.';
       }
       mainWindow.postMessage(result, event.origin);
     });
   </script>
 </head>
</html>
```

在框架内部，我们有一个最小的文档，它通过连接到 `window` 对象的 `message` 事件来侦听来自其父对象的消息。每当父进程对 iframe 的内容执行 postMessage 时，这个事件就会触发，然后执行父进程希望我们执行的字符串。

在处理程序中，用父窗口获取事件的 `source` 属性。一旦我们完成工作，就用它发送结果。然后，将数据传递给 `eval()` 来完成繁重的工作。这个调用包括在 try 块中，因为在沙箱化的 `iframe` 中禁止的操作经常会生成 DOM 异常；我们将捕获它们并报告一个友好的错误消息。最后，我们将结果发布回父窗口。整个过程是很简单的。

父类也同样简单。我们会创建一个小的 UI 层，代码有一个 `textarea`，和一个可执行的 `button`，我们会通过一个只允许执行脚本的沙箱 `iframe` 嵌入到 `frame.html`：

```html
<textarea id='code'></textarea>
<button id='safe'>eval() in a sandboxed frame.</button>
<iframe sandbox='allow-scripts'
        id='sandboxed'
        src='frame.html'></iframe>
```

现在来写一个方法执行吧。首先，利用 window.addEventListener 侦听来自 `iframe` 和 `alert()` 的响应。一个真正的应用程序应该简洁明确：

```js
window.addEventListener('message',
    function (e) {
      // iframe 的 sandbox 属性值不为“allow-same-origin”时，
      // 嵌入内容的来源将被视为一个null而不是有效来源。
      // 这意味着你必须小心那些通过 API 接收的数据。
      // 这种情况下，你需要检查源，并验证输入。
      var frame = document.getElementById('sandboxed');
      if (e.origin === "null" && e.source === frame.contentWindow)
        alert('Result: ' + e.data);
    });
```

接着，我们在 `按钮` 上挂载一个单击事件。当用户点击时，我们会抓取 `textarea` 的内容，并将其传递到 iframe 中执行:

```js
function evaluate() {
  var frame = document.getElementById('sandboxed');
  var code = document.getElementById('code').value;
  // 注意，我们正发送信息给“*”，而不是特定源。
  // iframe 的 sandbox 属性值不为“allow-same-origin”时，
  // 发送的信息就没有目标源，这就会导致一些不寻常的攻击。
  // 所以你必须要校验你的输出！
  frame.contentWindow.postMessage(code, '*');
}

document.getElementById('safe').addEventListener('click', evaluate);
```

是不是很简单？我们写了一个简单的评估 API，同时确保被评估的代码不会访问敏感信息，比如 cookie 或 DOM 存储。同样，被评估的代码也不能加载插件，弹出新窗口，或者其他一些糟糕的恶意行为。

在这里检查一下你自己的代码：

- [`Evalbox Demo`](https://www.html5rocks.com/static/demos/evalbox/index.html)
- [`index.html`](https://www.html5rocks.com/static/demos/evalbox/index.html)
- [`frame.html`](https://www.html5rocks.com/static/demos/evalbox/frame.html)

你可以把程序解构为单一用途的组件，然后对自己的代码执行评估操作。就像上面代码所示，每个组件都可以封装在一个简单的消息传递 API 中。高权限父窗口可以充当控制器和调度程序，将消息发送到每个模块中，而模块只拥有完成工作的最少特权。我们只要侦听结果，并确保每个模块只获得所需的信息就可以了。

但是请注意，你需要非常小心的处理来自与父元素相同源的框架内容。如果 `https://example.com/` 上的某个页面构建了同源的另一个页面（这个页面的 sandbox 值包括 **`allow-same-origin`** 和 **`allow-scripts`** ），那么被构建页面的权限可以向上达到父页面，并完全删除沙箱属性。

## 你该如何使用沙箱

你可以在各种浏览器中使用沙箱，例如 Firefox 17+、IE10+ 和 Chrome。也可以根据 [最新的支持表](http://caniuse.com/#feat=iframe-sandbox) 查看是否可以使用。在 `iframes` 中使用 `sandbox` 属性，允许你授予 **仅** 保证内容正常运行的特权。这帮你大大减少了第三方内容风险，甚至超出了[内容安全策略](http://www.html5rocks.com/en/tutorials/security/content-securpolicy/)所能提供的安全范围。

此外，沙箱非常强大，可以降低攻击者巧妙利用你代码中漏洞的风险。通过将单个应用程序分离到一组沙箱服务中，每个沙箱服务只负责一小块自己的功能。这样做攻击者除了要破坏特定的构建内容，还要破坏它们的控制器。这样做很困难，特别是因为控制器的作用域可以大大减少。如果你请求浏览器帮助你完成剩下的工作，那么你可以多做审核 **这种** 代码的工作。

这并不是说沙盒是互联网安全问题的完整解决方案。它提供了深度防御，但是除非你能够控制用户的客户端，否则不要依赖于浏览器支持（如果你真的控制了比如企业环境这种的用户客户端，那是最理想的）。现在沙盒是被用来加强防御的另一层保护，但这不是能完全依赖的防御。尽管如此，我还是建议使用它。

## 进一步了解

- "[HTML5 应用中的权限分离](http://www.cs.berkeley.edu/~devdatta/LeastPrivileges.pdf)" 是一篇有趣的文章，讲述了一个小框架的设计，以及它在三个 HTML5 app 中的应用。
- 当沙箱结合两个新的 iframe 属性时，可以更加灵活：[`srcdoc`](http://www.whatwg.org/specs/web-apps/current-work/multipage/the-iframe-element.html#attr-iframe-srcdoc) 和 [`seamless`](http://www.whatwg.org/specs/web-apps/current-work/multipage/the-iframe-element.html#attr-iframe-seamless)。前者允许您用内容填充框架，而不需要 HTTP 请求的开销，后者允许样式应用到框架内容中。两者目前浏览器的支持度不高（只有 Chrome 和 WebKit nightlies）。但这将是未来一个有趣的组合。例如，你可以通过以下代码对一篇文章进行沙盒注释:

```html
<iframe sandbox seamless
        srcdoc="<p>This is a user's comment!
                   It can't execute script!
                   Hooray for safety!</p>"></iframe>
```

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
