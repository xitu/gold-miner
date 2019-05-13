> * 原文地址：[Tips to use VSCode more efficiently](https://sudolabs.io/blog/tips-to-use-VSCode-more-efficiently/)
> * 原文作者：[sudolabs](https://sudolabs.io)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/tips-to-use-VSCode-more-efficiently.md](https://github.com/xitu/gold-miner/blob/master/TODO1/tips-to-use-VSCode-more-efficiently.md)
> * 译者：[Baddyo](https://github.com/Baddyo)
> * 校对者：[xionglong58](https://github.com/xionglong58), [hzdaqo](https://github.com/hzdaqo)

# 帮你高效使用 VS Code 的秘诀

[![VS Code 自定义配置](https://sudolabs.io/static/9c2742ceaf5b57f1c81558b3c19baee6/c4067/vscode-customized.png)](https://sudolabs.io/static/9c2742ceaf5b57f1c81558b3c19baee6/5642a/vscode-customized.png) 

假设你已经用过一段时间的 VS Code 了。你已经更改了颜色主题（如果还没有，那我强烈推荐 [material 主题](https://material-theme.site/)），调整了基本设置，并且安装了一些流行的插件。

可能你感觉这种程度足以满足日常工作需求。这很棒，但这样你就很可能与 VS Code 的诸多功能擦肩而过了。

本文荟萃了一些设置、插件和窍门，它们都对我的 Web 开发工作有莫大帮助。

### jsconfig.json

VS Code 的基本功能中，`jsconfig.json` 是最容易被忽视的一个。当你在 VS Code 中打开 JS 项目，VS Code 并不知道项目中的文件是相关联的。它把每个文件当作单独个体。而通过在项目根目录创建 `jsconfig.json` 文件，你可以把项目信息传达给 VS Code。

`jsconfig.json`（连同其他配置一起）实现了“智能跳转到定义处”的功能，此中用到了各种模块解析算法。在实践过程中，你可以对代码中的各种引用使用组合键 `⌘ 点击`，然后就能跳转到该引用定义之处。我强烈建议你读读[官方文档](https://code.visualstudio.com/docs/languages/jsconfig)，而我个人最常用的配置是这样的：

```js
{
  "compilerOptions": {
    "baseUrl": "src/",
    "target": "esnext",
    "module": "commonjs"
  },
  "exclude": [
    "node_modules",
  ]
}
```

### 配置入门

**注意：若你已经知道从何找到 VS Code 的设置，也知道如何编辑设置，就直接跳过本段吧。**

VS Code 把配置信息放在一个类 JSON 格式（所谓的 [`jsonc`](https://code.visualstudio.com/docs/languages/json#_json-with-comments) —— 带注释模式的 JSON）的文件中。可以通过 `⌘` 键、快捷方式，或者 `文件 > 首选项 > 设置` 打开。（[点击这里](https://code.visualstudio.com/docs/getstarted/settings)了解更多设置）

打开设置页面后，你不会直接看到源 JSON 文件。VS Code 精心优化了设置页面的界面，但本文出于便于分享的目的，将不使用该界面，而是以键值对的形式展现。

你可以通过点击标签栏上的 `{ }` 按钮来打开 JSON 配置文件。

如果该文件是空的（你还没有针对默认设置做任何修改），那我们需要创建一个空对象，它得是有效的 JSON 格式：

[![VS Code 设置](https://sudolabs.io/static/f078c5e598c1d3b816baf18a94fb234b/c4067/vscode-settings.png)](https://sudolabs.io/static/f078c5e598c1d3b816baf18a94fb234b/5642a/vscode-settings.png) 

### 主题

这个设置项似乎很基础，但并不代表它不重要。你有大量的时间在看代码，所以不妨再花点时间选一款让眼睛舒适的主题，这也能让代码看起来更悦目。

正如上文提到的，我在用 [Material](https://material-theme.site/) 主题下的 Ocean High Contrast。这些年我试用过很多主题，最终还是钟爱这一款。

另外 —— [Material Theme Icons](https://marketplace.visualstudio.com/items?itemName=Equinusocio.vsc-material-theme-icons) 插件收集了很多好看的文件/文件夹图标：

[![自定义侧边栏](https://sudolabs.io/static/64c815da3b7aa728bc4f2430596ddbe1/05210/sidebar-customized.png)](https://sudolabs.io/static/64c815da3b7aa728bc4f2430596ddbe1/05210/sidebar-customized.png) 

现在，你的设置信息（以及编辑器）应该是这样的：

[![更改设置后的 VS Code](https://sudolabs.io/static/7d24d00917578b6586ae5630164973a8/c4067/vscode-settings-edited.png)](https://sudolabs.io/static/7d24d00917578b6586ae5630164973a8/5642a/vscode-settings-edited.png) 

很棒，对吧？

快速提示：你可以通过在命令面板中搜索 "accent"，来更改 Material 主题的高亮色。

### 字体

合适的字体能让你的代码看起来更清晰优美。我选择的代码字体是 [`Fira Code`](https://github.com/tonsky/FiraCode) —— 一种强大而制作精良的编程字体，带有漂亮的连字。[快试试吧](https://github.com/tonsky/FiraCode/wiki/VS-Code-Instructions)！我刚刚说过它是免费的吧？

### 缩进

无论你站在 “tabs vs spaces” 之争的哪一边，你都可以像这样设置：

```json
"editor.detectIndentation": true,
"editor.insertSpaces": true
"editor.tabSize": 2
```

### 在编辑器和文件管理器之间切换

使用 `⌘ ⇧ E` 快捷键，你可以轻松切换代码编辑器和项目文件管理器。当你处于文件管理器中，你可以像在 macOS 的 Finder 中那样用相同的快捷键进行常规操作，比如用方向键导航、用 `↵` 键给文件或文件夹重命名、用 `⌘ ↓` 打开当前文件等。

快速提示：在 VS Code 中，通过 `⌥ ⌘ R` 组合键使用 macOS Finder 快速定位到当前选中的文件或文件夹。

### Emmet

[Emmet](https://emmet.io/) 是一个支持众多流行编辑器的插件，通过提供智能缩写、扩展、常规操作（如以元素包裹其他元素）等功能，它显著改善了 HTML 和 CSS 的工作流。也许你会说你并没有直接用 HTML 开发，但它经过简单配置就能兼容诸如 React 和 Vue 这类框架，因为它们用的都是相似的类 HTML 标记语言。

[集成 Emmet](https://code.visualstudio.com/docs/editor/emmet) 的 VS Code 无需配置即可支持 `html`、`haml`、`jade`、`slim`、`jsx`、`xml`、`xsl`、`css`、`scss`、`sass`、`less` 和 `stylus` 文件。

因此，默认情况下，你需要用 `.jsx` 文件扩展名来获得 Emmet 支持。要是你只用到 `.js` 文件，那么你有两种选择：

1. 让 Emmet 在 `.js` 中运行：

```json
"emmet.includeLanguages": {
"javascript": "javascriptreact",
}
```

（使 `javascriptreact` 这个 Emmet 语法在 `javascript` 文件中生效）

2. 让 VS Code 像处理 `.jsx` 文件那样处理 `.js` 文件（即对所有 `.js` 文件使用 `javascriptreact` 语法），这样 Emmet 就会把 `.js` 文件视为 `.jsx` 文件：

```json
"files.associations": {
"*.js": "javascriptreact"
}
```

我个人选第二种 —— 我从来不用 `.jsx` 文件扩展名，因此我要让 VS Code 总是在 `.js` 文件中支持 React 语法。

以下是我最常用的 Emmet 命令：

* `expand abbreviation` —— 把字符串扩展为 JSX 元素
* `wrap with abbreviation` —— 用另一个元素包裹已有元素
* `split / join tag` —— 把标签组变为自闭合标签（例如从 `expand abbreviation` 的输出变为自闭合），反之亦然

Emmet 着实强大，能为你节省大量时间，因此我强烈推荐你看看 [Emmet 官网](https://emmet.io/) 的 demo。

### 真正的秒开文件

让我们用 `⌘ P` 打开一个文件。

注意标签栏 —— 文件名为斜体代表着当前标签页处于**预览**模式。默认情况下，如果你从侧边栏选中或者按 `⌘ P` 打开某文件，然后再选中或者 `⌘ P` 打开另一个文件，你会发现新打开的文件直接占用了上一个**预览**模式的标签页，除非它被「钉」住了（发生双击或编辑操作）。

当你在侧边栏中浏览文件，可能只想瞥一眼文件内容，那么这种方式就很合理，但有时候，你会想要真正地「快速打开」它。

要满足该需求，可以这样设置：

```json
"workbench.editor.enablePreviewFromQuickOpen": false
```

现在你再试试 `⌘ P`  —— 文件不再以预览模式打开。

### 导航路径

[![VS Code 导航路径](https://sudolabs.io/static/a81dc2739c14f1ebcd95b79df42096d1/c4067/vscode-breadcrumbs.png)](https://sudolabs.io/static/a81dc2739c14f1ebcd95b79df42096d1/a260b/vscode-breadcrumbs.png) 

导航路径（显示在标题栏下方）是一个有用的功能，它展示了当前代码在代码库中的位置。如果你点击导航路径其中一个节点，它会显示你的当前位置、同级文件或标记，亦可做为快速导航使用。

激活方法如下：

```json
"breadcrumbs.enabled": true
```

以下是导航路径的两个有用的快捷键：

* `⌘ ⇧ .` — 聚焦导航路径：选中末尾元素，打开下拉菜单供你导航到同级文件或标记。
* `⌘ ⇧ ;` — 聚焦导航路径的末尾元素但不打开，通过方向键在路径层次中移动。

快速提示：你可以在导航路径中输入关键词来过滤文件、文件夹和标记，并用 `↵` 来聚焦。

### 隐藏「打开的编辑器」窗格

这样就能总是在标签页中打开文件

```json
  "explorer.openEditors.visible": 0
```

### 自定义标题栏

VS Code 的默认标题栏不是很得力。它只显示当前文件名和项目名。优化方法如下：

```json
"window.title": "${dirty} ${activeEditorMedium}${separator}${rootName}"
```

* `${dirty}`: 当文件修改后未保存时，显示一个圆点。
* `${activeEditorMedium}`: 当前文件相对于工作区文件夹的路径（例如 `myFolder/myFileFolder/myFile.txt`）
* `${separator}`: 一个条件分隔符（"-"），仅当被带有值或静态文本的变量包围时才显示。
* `${rootName}`: 工作区名称（例如 "myFolder" 或 "myWorkspace"）。

在[这里](https://code.visualstudio.com/docs/getstarted/settings)可以看到所有可供配置的选项。

### 代码缩略图

也许你知道 Sublime Text 的著名工具“代码缩略图”。它默认开启，但十分难看：

[![默认的代码缩略图](https://sudolabs.io/static/05493f1269f9601e0205ab6a894238cb/722f5/minimap-default.png)](https://sudolabs.io/static/05493f1269f9601e0205ab6a894238cb/722f5/minimap-default.png) 

让我们来优化一下吧。

首先，用色块代替缩小的字符。然后，设置水平最大列数，最后，始终显示「滑块」以便瞥一眼就能知道当前代码在文件中的位置。

```json
"editor.minimap.renderCharacters": false,
"editor.minimap.maxColumn": 200,
"editor.minimap.showSlider": "always"
```

[![自定义的代码缩略图](https://sudolabs.io/static/cd8fc34e366c20ecbd38366bc02266c2/722f5/minimap-customized.png)](https://sudolabs.io/static/cd8fc34e366c20ecbd38366bc02266c2/722f5/minimap-customized.png) 

### 空格

也许你希望所有字符都可见：

```json
"editor.renderWhitespace": "all"
```

### 平滑滚动

```json
"editor.smoothScrolling": true
```

### 优化插入符

把光标的动画从 "blink" 改为 "phase" ，那种一明一灭的动画让人有种奇怪的愉悦感：

```json
"editor.cursorBlinking": "phase"
```

让光标移动时带有小动画，这样让我们的目光很容易追踪到它：

```json
"editor.cursorSmoothCaretAnimation": true
```

### 文件末尾另起一行

在文件末尾处插入一个空行，这是一个[惯例](https://unix.stackexchange.com/a/18789/315296)

```json
"files.insertFinalNewline": true
```

### 剪裁尾部空格

```json
"files.trimTrailingWhitespace": true
```

### [遥测](https://code.visualstudio.com/docs/supporting/FAQ#_how-to-disable-telemetry-reporting)

我个人倾向于禁用上传数据（崩溃报告、使用数据、错误）到 Microsoft 联机服务：

```json
"telemetry.enableCrashReporter": false
"telemetry.enableTelemetry": false,
```

另外，[自然语言搜索](https://code.visualstudio.com/blogs/2018/04/25/bing-settings-search)也是默认激活的，在你搜索设置时，该功能会把你的[键盘动作](https://github.com/Microsoft/vscode/issues/49161)发送给 Bing。要是你也想把这个关闭，就增加如下配置信息：

```json
"workbench.settings.enableNaturalLanguageSearch": false
```

### 复制文件路径

说起代码，能够指向一个特定的文件往往大有裨益。借助命令面板 `⌘ P`，VS Code 可提供活动文件的绝对路径和相对路径，但[设置自己的快捷键](https://code.visualstudio.com/docs/getstarted/keybindings#_keyboard-shortcuts-editor)要更快一些。

按组合键 `⌘ K` 后紧接着按 ` ⌘ S`，可以打开快捷键配置文件，添加如下配置信息（或者任意你想要的组合）：

复制相对路径

```json
{
	"key": "shift+cmd+c",
	"command": "copyRelativeFilePath"
}
```

复制绝对路径

```json
{
	"key": "shift+alt+cmd+c",
	"command": "copyFilePath"
}
```

### 隐藏底部状态栏的反馈笑脸图标

```json
"workbench.statusBar.feedback.visible": false
```

## 插件

[丰富的插件生态](https://marketplace.visualstudio.com/)是 VS Code 流行的原因之一。下面列出一些切实有用的插件：

* [Settings Sync](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync)
* [Babel JavaScript](https://marketplace.visualstudio.com/items?itemName=mgmcdermott.vscode-language-babel)
* [ESLint](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint)
* [Path Intellisense](https://marketplace.visualstudio.com/items?itemName=christian-kohler.path-intellisense)
* [vscode-styled-components](https://marketplace.visualstudio.com/items?itemName=jpoissonnier.vscode-styled-components)
* [GitLens — Git supercharged](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens)
* [LintLens — ESLint rules made easier](https://marketplace.visualstudio.com/items?itemName=ghmcadams.lintlens)
* [DotENV](https://marketplace.visualstudio.com/items?itemName=mikestead.dotenv)
* [Guides](https://marketplace.visualstudio.com/items?itemName=spywhere.guides)
* [Bracket Pair Colorizer](https://marketplace.visualstudio.com/items?itemName=CoenraadS.bracket-pair-colorizer)
* [ES7 React/Redux/GraphQL/React-Native snippets](https://marketplace.visualstudio.com/items?itemName=dsznajder.es7-react-js-snippets)
* [Advanced New File](https://marketplace.visualstudio.com/items?itemName=dkundel.vscode-new-file)
* [Duplicate action](https://marketplace.visualstudio.com/items?itemName=mrmlnc.vscode-duplicate)
* [Color Highlight](https://marketplace.visualstudio.com/items?itemName=naumovs.color-highlight)
* [gitignore](https://marketplace.visualstudio.com/items?itemName=codezombiech.gitignore)
* [TODO Highlight](https://marketplace.visualstudio.com/items?itemName=wayou.vscode-todo-highlight)
* [Sort JSON objects](https://marketplace.visualstudio.com/items?itemName=richie5um2.vscode-sort-json)
* [EditorConfig for VS Code](https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig)
* [Image preview](https://marketplace.visualstudio.com/items?itemName=kisstkondoros.vscode-gutter-preview)
* [Markdown All in One](https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one)
* [Markdown Preview Github Styling](https://marketplace.visualstudio.com/items?itemName=bierner.markdown-preview-github-styles)
* [Align](https://marketplace.visualstudio.com/items?itemName=steve8708.Align)
* [HTML CSS Support](https://marketplace.visualstudio.com/items?itemName=ecmel.vscode-html-css)
* [Sort lines](https://marketplace.visualstudio.com/items?itemName=Tyriar.sort-lines)
* [Toggle Quotes](https://marketplace.visualstudio.com/items?itemName=BriteSnow.vscode-toggle-quotes)
* [Version Lens](https://marketplace.visualstudio.com/items?itemName=pflannery.vscode-versionlens)
* [Visual Studio IntelliCode - Preview](https://marketplace.visualstudio.com/items?itemName=VisualStudioExptTeam.vscodeintellicode)
* [VS Live Share](https://marketplace.visualstudio.com/items?itemName=MS-vsliveshare.vsliveshare)
* [Polacode](https://marketplace.visualstudio.com/items?itemName=pnp.polacode)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
