> * 原文地址：[10 Fun Things You Can Do With GitHub.dev](https://dev.to/lostintangent/10-awesome-things-you-can-do-with-github-dev-5fm7)
> * 原文作者：[Jonathan Carter](https://dev.to/lostintangent)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/10-awesome-things-you-can-do-with-github-dev.md](https://github.com/xitu/gold-miner/blob/master/article/2021/10-awesome-things-you-can-do-with-github-dev.md)
> * 译者：
> * 校对者：

# 10 Fun Things You Can Do With GitHub.dev 😎

GitHub recently released [github.dev](https://github.dev), which allows you to press `.` on any repo in order to open it in VS Code, directly from your browser (🤯). This simple gesture provides you with a significant productivity boost for reading, editing, and sharing code on GitHub. Including from an iPad!

> **Note: In addition to the `.` key, you can also change “.com” to “.dev” in your URL bar, in order to achieve the same effect 👍**

![](https://res.cloudinary.com/practicaldev/image/fetch/s--VJkNTHVS--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://pbs.twimg.com/media/E8hp-_MWEAQRYeB.jpg)

However, what might not be immediately obvious, is that github.dev enables something even more compelling: the opportunity to customize and create entirely new **GitHub-native workflows**. Instead of relying on [browser extensions](https://github.com/collections/github-browser-extensions) or 3rd party services to augment github.com, you can simply take advantage of the editor you already love, along with its [**prolific** ecosystem](https://marketplace.visualstudio.com/vscode), to enhance GitHub directly. To illustrate what I mean, let's take a look at 10 examples of what Github.dev makes possible today 🚀

## 1. 💄 Personalizations

Developers **love** to personalize their editor, in order to make it more efficient, ergonomic, and visually appealing. Since github.dev is based on VS Code, you can customize your keybindings, color theme, file icons, snippets, and more. Even cooler, you can enable [settings sync](https://code.visualstudio.com/docs/editor/settings-sync) and roam your personalizations between VS Code, github.dev and [Codespaces](https://github.com/features/codespaces). That way, no matter where you're reading/editing code, you'll immediately feel at home 💖

![](https://res.cloudinary.com/practicaldev/image/fetch/s--RSG3mtK5--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://pbs.twimg.com/media/E9lhmoeXIAM7-Bl.jpg)

## 2. Sharing Deep Links

In addition to pressing `.` from a repo page, you can also press `.` when viewing a specific file on GitHub.com. Furthermore, if you select some text in the currently opened file, and press `.`, then when VS Code is opened, it will focus the file and highlight your text selection. You can then copy the URL in your browser, and send that to others, in order to share that **exact same context**. This can enable new and interesting ways to communicate about code 🔥

![](https://res.cloudinary.com/practicaldev/image/fetch/s--yElJmPGE--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://pbs.twimg.com/media/E9pdcqiVUAEa13W.jpg)

> **Demo:** Click [this link](https://github.dev/lostintangent/gitdoc/blob/master/src/extension.ts#L26-L27) to see how the [GitDoc extension](https://aka.ms/gitdoc) subscribes to repo events in VS Code.

## 3. ✅ Pull Request Reviews

In addition to hitting `.` on a repo or file on github.com, you can also press it when viewing a pull request. This enables you to review the PR using a rich, multi-file view, that includes the ability to view & reply to comments, suggest changes, and even approve/merge the PR directly from the editor. This has to potential to reduce “superficial reviews”, by giving developers better tools, without needing to clone or switch branches 🙅‍♂️

![](https://res.cloudinary.com/practicaldev/image/fetch/s--AYrXWxQm--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://pbs.twimg.com/media/E9I5DW-X0AUINAA.jpg)

> **Demo:** Click [this link](https://github.dev/microsoft/codetour/pull/153) to review the PR for adding a regex parser to the [CodeTour extension](https://aka.ms/codetour).

## 4. 📊 Editing Images + Diagrams

Beyond editing text files, VS Code also allows extensions to contribute [custom editors](https://code.visualstudio.com/api/extension-guides/custom-editors), which enables you to edit any file type in your project. For example, if you install the [Drawio extension](https://marketplace.visualstudio.com/items?itemName=hediet.vscode-drawio), you can view and edit rich diagrams.

![](https://res.cloudinary.com/practicaldev/image/fetch/s--WDkqu00U--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://pbs.twimg.com/media/E8mbuSaX0AAAkEp.jpg)

Additionally, if you install the [Luna Paint extension](https://marketplace.visualstudio.com/items?itemName=Tyriar.luna-paint) you can edit images (PNG, JPG, etc.).

In each case, your edits are automatically saved, and you can commit/push changee back to your GitHub repo via the `Source Control` tab. Even cooler, you can share a deep link for an image/diagram with others, and as long as they install neccessary extension(s), they'll be able to collaborate with you via the exact same experience. This effectively makes github.dev a hackable "canvas" for any file type that is stored in GitHub 😎

## 5. 🗺 Codebase Walkthroughs

Learning a new codebase is hard, since it's typically unclear where to start, or how various files/folders relate to each other. With github.dev, you can install the [CodeTour extension](https://aka.ms/codetour), which allows you to create and playback guided walkthroughs of a codebase. Since github.dev is available entirely in the browser, this makes it easy for anyone on the team, or in your community, to get up to speed quickly, without needing to install anything locally.

> **Demo:** Open [this repo](https://github.dev/microsoft/codetour) and install CodeTour. You'll be presented with a toast that asks if you'd like to take the `Getting Started` tour.

## 6. 📕 Code Snippets + Gists

[Gists](https://gist.github.com) are a popular way for developers to manage and share code snippets, config files, notes, and more. In github.dev, you can install the [GistPad extension](https://aka.ms/gistpad) and view/edit your gists. This allows you to maintain code snippets across multiple repos, and access them from both your desktop editor, as well as whenever you're browsing/editing code on GitHub.

![](https://res.cloudinary.com/practicaldev/image/fetch/s--W9WuEbZ9--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://pbs.twimg.com/media/E8w8aCiVoAIYOLl.jpg)

## 7. 🎢 Web Playgrounds + Tutorials

Coding playgrounds (e.g. CodePen, JSFiddle) are a popular way to learn programming languages/libraries, and then share them with others. With github.dev, you can install the [CodeSwing extension](https://aka.ms/codeswing) and begin creating web playgrounds, using your existing editor setup, and with your files persisted back to GitHub.

> **Demo:** Open [this repo](https://github.dev/lostintangent/rock-paper-scissors) and install CodeSwing + CodeTour. After a few seconds, you'll be presented with the playground environment.

## 8. ✏️ Notetaking + Knowledge Bases

VS Code is a world-class markdown editor, and therefore, you can start using github.dev to edit and preview all of your personal notes/documentation. Even cooler, you can install the [WikiLens extension](https://aka.ms/wikilens) in order to get a Roam/Obsidian-like editing experience, for maintaining a knowledge base, that's stored in GitHub and is able to benefit from the ecosystem of extensions/personalizations for VS Code.

## 9. 📓 Jupyter Notebooks

In addition to coding playgrounds, another popular way to learn and share code, is via Jupyter notebooks. If you open an `.ipynb` file in github.dev, you can immediately view the cells and cached outputs of the notebook. Even better, you can install the [Pyodide extension](https://marketplace.visualstudio.com/items?itemName=joyceerhl.vscode-pyodide) in order to actually run Python code, entirely in your browser!

## 10. 🛠 Creating Your Own Extension!

As you probably noticed, most of the items above were enabled by means of an extension, that someone created and published to the marketplace. Since VS Code is [fully extensible](https://code.visualstudio.com/api/references/vscode-api), using simple JavaScript APIs, you can create your own extensions that support not only VS Code desktop, but also, [github.dev](https://github.com/microsoft/vscode-docs/blob/vnext/api/extension-guides/web-extensions.md). So if you have an awesome idea, for how to make coding on GitHub more productive and fun, then you now have everything you need to get started 🏃

## 🔮 Looking Forward

While there’s already a ton of use cases for GitHub.dev, it’s still early days, and so this is a space worth watching, as the ecosystem continues to innovate. For example, I’m excited to see [real-time collaboration](https://aka.ms/vsls), [classroom assignments](https://marketplace.visualstudio.com/items?itemName=GitHub.classroom), and [presentations](https://marketplace.visualstudio.com/items?itemName=marp-team.marp-vscode), become examples of scenarios that can soon be performed 💯 in the browser, and built on top of GitHub repositories. Exciting times 🙌

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
