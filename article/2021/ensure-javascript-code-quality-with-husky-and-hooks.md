> * 原文地址：[Ensure JavaScript Code Quality with Husky and Hooks](https://blog.bitsrc.io/ensure-javascript-code-quality-with-husky-and-hooks-6e338222662)
> * 原文作者：[Viduni Wickramarachchi](https://medium.com/@viduniwickramarachchi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/ensure-javascript-code-quality-with-husky-and-hooks.md](https://github.com/xitu/gold-miner/blob/master/article/2021/ensure-javascript-code-quality-with-husky-and-hooks.md)
> * 译者：[Usualminds](https://github.com/Usualminds)
> * 校对者：

# 使用 Husky 和 Hooks 保证 JavaScript 代码质量

![](https://cdn-images-1.medium.com/max/5760/1*HZ5lACmwUy-Zo8jTzWEmZw.jpeg)

对于一个可维护和可扩展的应用程序来讲，保证代码质量无疑至关重要。但我们如何在项目中执行与质量相关的标准呢？

在 JavaScript 中，你可以使用 ESLint 来定义编码规范，同时可以使用 Prettier 来实现统一的代码风格配置。如果你已经配置了这两个工具，那就已经完成了保证代码质量的第一步。

现在我们已经有了相关的质量标准，如何执行它们？这时候就需要 Husky 了。在基于 Git 项目中，Husky 常常用于保证关于质量标准的执行。它的作用类似于 [Bit](https://bit.dev) 在[单组组件](https://blog.bitsrc.io/independent-components-the-webs-new-building-blocks-59c893ef0f65) 发布新版本之前需要强制执行代码规范，最终导出在各个远程分支使用。

## 什么是 Hooks

当你使用 Git (`git init` ) 初始化一个项目时，它会自动为你提供一个名为 Hooks 的钩子。你可以在 `[项目根目录]/.git/hooks` 下查看它。

你会看到有许多 Git Hooks。部分如下：

* `pre-commit` —— 用于保证代码提交前执行所有编码规范标准的钩子。它将在你执行 `git commit` 命令时运行。
* `pre-push` —— 用于保证代码在推送到远程仓库之前符合编码规范。
* `pre-rebase` —— 类似于上面的作用，它是在 rebase 操作完成之前执行的。

所有可用的 Hooks 和它们的用法都可以在[这里](https://git-scm.com/docs/githooks)找到。

然而，手动编写这些 Hooks 并保证所有开发人员都在他们的设备上遵循这些规则是一个极为繁琐的过程。这时候就需要 Husky 了。

## 什么是 Husky

Husky 让 Hooks 的添加过程自动化了。当项目中的依赖安装完成后，Husky 会保证所有 Hooks 正确地安装在开发者设备的项目中，并且是基于项目中 `package.json` 配置。这使得管理和分发 Hooks 简单了很多，不需要在手动编写了。

使用 Husky，会开启如下的流程：

* 本地创建 Hooks 钩子。
* 相关的 Git 命令调用时会自动执行 Hooks 钩子。
* 对参与项目代码贡献的人来说，项目中定义的编码规范是强制执行的。

### 项目中开始使用 Husky

你可以使用如下的命令安装 Husky。

```bash
npm install husky --save-dev
```

配置 Husky 非常简单。它到配置可以添加到 `package.json` 中。

```javascript
"husky": {
  "hooks": {
    "pre-commit": "",  // pre-commit 命令添加到这里
    "pre-push": "",    // pre-push 命令添加到这里
    "...": "..."
  }
}
```

因此，你需要到任何钩子都可以配置在这里。

让我们看一个例子。

如果你想保证在代码提交前满足所有的 lint 规则校验，可以进入如下操作。

```json
{
  "scripts": {
    "lint": "eslint . --ext .js",
  },
  "husky": {
    "hooks": {
      "pre-commit": "npm run lint"
     }
  }
}
```

这个配置应该添加到 `package.json` 中。它会保证代码在没有通过 `esLint` 校验到情况下无法完成 Git 提交。

## Husky 在实践中到更多应用

到目前为止，我们已经了解了 Husky 的基本用法。我们可以用这个包配置做更多的事情吗？让我们看看。

1. Husky 能够运行任何命令，它可以和其他包进行组合（比如：Prettier、EsLint，检查 linting 是否使用 lint-staged 提交文件等）。
2. Husky 能够验证提交信息时使用等 `commit-msg`，类似于 `pre-commit` 校验规则。
3. 我们可以使用 `pre-commit` 命令运行所有单元测试和集成测试，这就确保不会提交任何破坏性修改。

然而，需要注意的是，如果你在 Git 命令中使用了 `no-verify` 标志，就可以跳过 Husky 命令了。

### 支持的 Hooks

Husky 支持[这里](https://git-scm.com/docs/githooks)定义的所有的 Git Hooks。服务端 Hooks（`pre-receive`、`update` 和 `post-receive`）这些不支持。

## Husky 的特点

Husky 有几个突出的优势，我想提一下。

* 零依赖和轻量化（6KB）
* 由当下Git 的新特性 (`core.hooksPath`) 驱动
* 遵循 [npm](https://docs.npmjs.com/cli/v7/using-npm/scripts#best-practices) 和 [Yarn](https://yarnpkg.com/advanced/lifecycle-scripts#a-note-about-postinstall) 自动安装的最佳实践
* 友好的用户消息提示
* 选择性安装
* Husky 4 支持 macOS、Linux 和 Windows 平台
* 进一步，它支持 Git GUIs、自定义目录和 Monorepos

## 总结

使用 Husky 和 Git Hooks 可以实现格式化、符合 lint 规则无错误的代码构建。这让执行编码规范变得非常简单和快速。

或者，你可以考虑使用 [Bit](https://bitdev) 之类的工具来提高代码质量。

从我开始在我的项目（小规模或企业级项目）中使用 Husky 的那天起，编码生活变得更简单了。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
