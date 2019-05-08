> * 原文地址：[Tips to use VSCode more efficiently](https://sudolabs.io/blog/tips-to-use-VSCode-more-efficiently/)
> * 原文作者：[sudolabs](https://sudolabs.io)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/tips-to-use-VSCode-more-efficiently.md](https://github.com/xitu/gold-miner/blob/master/TODO1/tips-to-use-VSCode-more-efficiently.md)
> * 译者：
> * 校对者：

# Tips to use VSCode more efficiently

[![vscode customized](https://sudolabs.io/static/9c2742ceaf5b57f1c81558b3c19baee6/c4067/vscode-customized.png)](/static/9c2742ceaf5b57f1c81558b3c19baee6/5642a/vscode-customized.png) 

Say you’ve already been using VSCode for some time now. You’ve changed the color theme (if not, I highly recommend [material theme](https://material-theme.site/)), you’ve tweaked some essential settings and installed a couple of popular extensions.

Maybe you know your way around it enough to get the work done. That’s perfectly fine, but there’s a good chance you’re missing out on some of its many features

This is a collection of settings, extensions and shortcuts, that proved especially useful for my job as a web developer.

### jsconfig.json

One of the most overlooked essential features of VSCode is `jsconfig.json`. If you open your JS project in VSCode, it doesn’t know the files in it are related. It treats every file as an individual unit. You can tell it about your project by creating `jsconfig.json` file at the root of your project.

`jsconfig.json` (among other things ) enables smart go to definition, that works with various module resolution algorithms. In practice - it means that you can now `⌘ click` on various references in your code, and it’ll take you to the definitions of them. I highly recommend you [reading more about it](https://code.visualstudio.com/docs/languages/jsconfig), but this is what I use most of the time:

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

### A settings primer

**Note: If you already know where to find VSCode settings and how to edit them, jump to the next section**

VSCode stores settings in a JSON-like (the so-called [`jsonc`](https://code.visualstudio.com/docs/languages/json#_json-with-comments) \- JSON with comments mode) file. It can be accessed with `⌘ ,` shortcut, or through `Code > Preferences > Settings`. ([Go here](https://code.visualstudio.com/docs/getstarted/settings) to learn more about VSCode settings)

After you open up the settings, you won’t see the raw JSON right away. VSCode has received a nice UI for them lately, but for the purpose of this article it’s easier to share the settings in raw key-value form, so we won’t be using it.

You can access the settings JSON by clicking on the `{ }` icon in the tab bar.

In case it’s empty (you haven’t made any modification to the default settings yet), let’s create an empty object, so it’s a valid JSON:

[![vscode settings](https://sudolabs.io/static/f078c5e598c1d3b816baf18a94fb234b/c4067/vscode-settings.png)](/static/f078c5e598c1d3b816baf18a94fb234b/5642a/vscode-settings.png) 

### Theme

This might seem basic, but it doesn’t mean it’s not important. You spend a lot of time looking at code, so you might as well spend some time choosing a theme that’s easy on your eyes, and make the code look pretty as well.

As I’ve already mentioned, I’m using [Material Theme](https://material-theme.site/) Ocean High Contrast variant. I’ve tried many over the years, but settled on this one.

One more thing - those nice file / folder icons are achieved through [Material Theme Icons](https://marketplace.visualstudio.com/items?itemName=Equinusocio.vsc-material-theme-icons) extension:

[![sidebar customized](https://sudolabs.io/static/64c815da3b7aa728bc4f2430596ddbe1/05210/sidebar-customized.png)](/static/64c815da3b7aa728bc4f2430596ddbe1/05210/sidebar-customized.png) 

This is how your settings (and editor) now look like:

[![vscode settings edited](https://sudolabs.io/static/7d24d00917578b6586ae5630164973a8/c4067/vscode-settings-edited.png)](/static/7d24d00917578b6586ae5630164973a8/5642a/vscode-settings-edited.png) 

Nice right?

Quick tip: You can change Material Theme accent color by searching „accent“ in command palette.

### Font

The right font can make your code more legible and pleasant to look at. My programming font of choice is [`Fira Code`](https://github.com/tonsky/FiraCode) \- a robust & well-made programming font with beautiful ligatures. [Try it](https://github.com/tonsky/FiraCode/wiki/VS-Code-Instructions)! Did I mention it’s free?

### Indentation

Whatever side in “tabs vs spaces” debate you’re on, you can set it up like this:

```json
"editor.detectIndentation": true,
"editor.insertSpaces": true
"editor.tabSize": 2
```

### Switching between editor and explorer

You can easily toggle between code editor and project files explorer with `⌘ ⇧ E` shortcut. When you’re inside the explorer, you can use the same keys for common operations as in MacOS finder - arrow keys to navigate, `↵` to rename file / folder and `⌘ ↓` to open current file.

Quick tip: Reveal the focused file / folder in native MacOS finder with `⌥ ⌘ R`.

### Emmet

[Emmet](https://emmet.io/) is a plugin for many popular text editors which greatly improves HTML & CSS workflow by enabling clever abbreviations, expansions, common actions (wrapping element inside other element) and so on. You may argue you’re not writing HTML directly, but it can be easily configured to play nicely with frameworks like React and Vue, because they use similar html-like markup.

VSCode [ships with Emmet](https://code.visualstudio.com/docs/editor/emmet) support out of the box for `html`, `haml`, `jade`, `slim`, `jsx`, `xml`, `xsl`, `css`, `scss`, `sass`, `less` and `stylus` files.

So, by default, you’d have to use `.jsx` file extension, to get Emmet support for JSX files. Say you only work with `.js` files, so you have two options:

1. tell Emmet to run in `.js` files:
    
    ```json
    "emmet.includeLanguages": {
    "javascript": "javascriptreact",
    }
    ```
    
    (enable `javascriptreact` Emmet syntax in `javascript` files)
    
2. tell VSCode to treat any `.js` file just like `.jsx` (it means to use `javascriptreact` syntax for all `.js` files as well), so Emmet sees is as if it was a `.jsx` file:
    
    ```json
    "files.associations": {
    "*.js": "javascriptreact"
    }
    ```
    

I went for the second one - I never use `.jsx` file extension, so I want to have VSCode React support in `.js` files anyway.

These Emmet commands are my most-used ones:

* `expand abbreviation` \- to expand string to JSX element
* `wrap with abbreviation` \- to wrap existing JSX with another element
* `split / join tag` \- making self-closing tags from tag pairs (e.g. from the output of `expand abbreviation`) and vice versa

Emmet is really powerful and can save you a lot of time, so I highly recommend you checking out their demos on emmet.io site.

### Quick-Open files for real

Let’s open a file using Quick Open command: `⌘ P`.

Notice the tab bar - file name being written in italics means the tab is in **preview** mode. By default, if you select the file from the sidebar or quick open (`⌘ P`), and then select / quick open another one, it reuses the preview tab, until it’s **pinned** (double-clicked, or the file is edited).

This behavior makes sense if you’re going through files in sidebar, possibly just peeking into files, but if you want to quick-open something, you probably know you want to have it open „for real“.

To achieve this, set the following:

```json
"workbench.editor.enablePreviewFromQuickOpen": false
```

Now try to `⌘ P` \- your file will no longer open in preview mode.

### Breadcrumbs

[![vscode breadcrumbs](https://sudolabs.io/static/a81dc2739c14f1ebcd95b79df42096d1/c4067/vscode-breadcrumbs.png)](/static/a81dc2739c14f1ebcd95b79df42096d1/a260b/vscode-breadcrumbs.png) 

Breadcrumbs (displayed underneath the title bar) is a useful feature of VSCode that shows your location in the codebase. If you click on one of the segments, it shows you your current location, and files / symbols on the same level, serving as a quick navigation as well.

Enable them with this setting:

```json
"breadcrumbs.enabled": true
```

There are two useful shortcuts when it comes to breadcrumbs:

* `⌘ ⇧ .` \- Focus Breadcrumbs: It will select that last element and open a dropdown that allows you to navigate to a sibling file or symbol.
* `⌘ ⇧ ;` \- Focus last element of Breadcrumbs without opening it - so you can move inside the path hierarchy with arrows.

Quick tip: You can type inside the breadcrumb popup to filter files and folders / symbols, and focus on them with `↵`.

### Hide Open Editors section

You see open files in tabs anyway.

```json
  "explorer.openEditors.visible": 0
```

### Customize the title bar

Default VSCode title is not very useful. It only shows current file name and project name. Here’s how you can improve it:

```json
"window.title": "${dirty} ${activeEditorMedium}${separator}${rootName}"
```

* `${dirty}`: a dirty indicator if the active editor is dirty.
* `${activeEditorMedium}`: the path of the file relative to the workspace folder (e.g. `myFolder/myFileFolder/myFile.txt`)
* `${separator}`: a conditional separator (” - ”) that only shows when surrounded by variables with values or static text.
* `${rootName}`: name of the workspace (e.g. myFolder or myWorkspace).

You can see all available options [here](https://code.visualstudio.com/docs/getstarted/settings).

### Minimap

You probably know the famous minimap widget from Sublime Text. It’s turned on by default, but looks quite awful:

[![minimap default](https://sudolabs.io/static/05493f1269f9601e0205ab6a894238cb/722f5/minimap-default.png)](/static/05493f1269f9601e0205ab6a894238cb/722f5/minimap-default.png) 

Lets’ improve it.

First, let’s use color blocks instead of minified characters. Then set the max horizontal columns, and finally, always show the “slider” so we can glance at the minimap to see where in the file is the screen located.

```json
"editor.minimap.renderCharacters": false,
"editor.minimap.maxColumn": 200,
"editor.minimap.showSlider": "always"
```

[![minimap customized](https://sudolabs.io/static/cd8fc34e366c20ecbd38366bc02266c2/722f5/minimap-customized.png)](/static/cd8fc34e366c20ecbd38366bc02266c2/722f5/minimap-customized.png) 

### Whitespace

You probably want to see all the characters:

```json
"editor.renderWhitespace": "all"
```

### Smooth scrolling

```json
"editor.smoothScrolling": true
```

### Caret improvements

There’s something oddly satisfying about the cursor that’s phasing instead of blinking:

```json
"editor.cursorBlinking": "phase"
```

Also, the cursor is easier to follow, when there’s a slight animation on its movement:

```json
"editor.cursorSmoothCaretAnimation": true
```

### Final new line

It’s a [common practice](https://unix.stackexchange.com/a/18789/315296) to include a new line at the end of your file:

```json
"files.insertFinalNewline": true
```

### Trim trailing whitespace

```json
"files.trimTrailingWhitespace": true
```

### [Telemetry](https://code.visualstudio.com/docs/supporting/FAQ#_how-to-disable-telemetry-reporting)

I like to have telemetry disabled:

```json
"telemetry.enableCrashReporter": false
"telemetry.enableTelemetry": false,
```

also, there’s [Natural language search](https://code.visualstudio.com/blogs/2018/04/25/bing-settings-search) enabled by default, which [sends your keystrokes](https://github.com/Microsoft/vscode/issues/49161) to Bing when searching settings. In case you want to turn it off as well, add this to your settings:

```json
"workbench.settings.enableNaturalLanguageSearch": false
```

### Copy file path

When talking about code, it’s often useful to be able to point to a specific file. VSCode offers copying both absolute and relative file paths of active file through command palette `⌘ P`, but it’s quicker to [set your own keyboard shortcuts](https://code.visualstudio.com/docs/getstarted/keybindings#_keyboard-shortcuts-editor).

Open your keyboard shortcuts file with `⌘ K, ⌘ S` (commad + K immediately followed by commad + S), and add the following (or any key combination you like)

copy relative path

```json
{
	"key": "shift+cmd+c",
	"command": "copyRelativeFilePath"
}
```

copy absolute path

```json
{
	"key": "shift+alt+cmd+c",
	"command": "copyFilePath"
}
```

### Hide feedback smiley in the bottom bar

```json
"workbench.statusBar.feedback.visible": false
```

## Extensions

[Rich extensions ecosystem](https://marketplace.visualstudio.com/) is one of the reasons VSCode took off. Here are the ones that proved themselves useful:

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
