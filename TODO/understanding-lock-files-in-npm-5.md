> * 原文地址：[Understanding lock files in NPM 5](http://jpospisil.com/2017/06/02/understanding-lock-files-in-npm-5.html)
> * 原文作者：[Jiří Pospíšil](https://twitter.com/JiriPospisil)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[Changkun Ou](https://github.com/changkun/)
> * 校对者：[JackGit](https://github.com/JackGit), [Aladdin-ADD](https://github.com/Aladdin-ADD)

# 理解 NPM 5 中的 lock 文件

NPM 的下个主版本（NPM 5）在速度、安全性和一堆其他[时髦的东西](blog.npmjs.org/post/161276872334/npm5-is-now-npmlatest)上，相比较前一个版本带来了一些改进。然而从用户的角度来看，最突出的就是全新的 lock 文件，**不止一个** lock 文件。我们一会儿再谈论这个。对于新手来说，一个 `package.json` 文件使用了[语义化版本规范](https://github.com/xitu/gold-miner/pull/1763/semver.org)，去描述对于其他包的直接依赖，而这些包可能依赖于其他包等等，以此类推。lock 文件则是整个依赖关系树的快照，包含了所有包及其解析的版本。

与之前版本相反，lock 文件现在包含一个 integrity 字段，它使用 [Subresource Integrity](https://w3c.github.io/webappsec-subresource-integrity/) 来验证已安装的软件包是否被改动过，换句话来说，验证包是否已失效。它依旧支持旧版本 NPM 中对包的加密算法 SHA-1，但是以后将默认使用 SHA-512 进行加密。

这个文件目前**取消**了 `from` 字段。众所周知，这个字段和时常发生不一致的 `version` 字段一起，给代码审查看文件改动差异时，带来了不少痛苦。不过现在应该变得更加整洁了。

该文件现在增加了 `lockfileVersion` 字段来指定的 lock 格式的版本，并将其设置为1。这是为了使将来的格式更新时，不用去猜测该文件使用什么特定版本。以前的 lock 格式仍然支持并被识别为版本 `0`。


```
{
  "name": "package-name",
  "version": "1.0.0",
  "lockfileVersion": 1,
  "dependencies": {
    "cacache": {
      "version": "9.2.6",
      "resolved": "https://registry.npmjs.org/cacache/-/cacache-9.2.6.tgz",
      "integrity": "sha512-YK0Z5Np5t755edPL6gfdCeGxtU0rcW/DBhYhYVDckT+7AFkCCtedf2zru5NRbBLFk6e7Agi/RaqTOAfiaipUfg=="
    },
    "duplexify": {
      "version": "3.5.0",
      "resolved": "https://registry.npmjs.org/duplexify/-/duplexify-3.5.0.tgz",
      "integrity": "sha1-GqdzAC4VeEV+nZ1KULDMquvL1gQ=",
      "dependencies": {
        "end-of-stream": {
          "version": "1.0.0",
          "resolved": "https://registry.npmjs.org/end-of-stream/-/end-of-stream-1.0.0.tgz",
          "integrity": "sha1-1FlucCc0qT5A6a+GQxnqvZn/Lw4="
        },
```

你可能已经注意到了，指向特定 URI 的文件的 `resolved` 字段仍然得到了保留。注意，NPM 现在可以（根据 .npmrc 中的设置）解析机器配置使用的不同仓库，这样的话，与 integrity 字段一起配合，只要签名是匹配的，包的来源并无关紧要。

值得一提的是，lock 文件精确描述了 `node_modules` 目录中所列出的目录的物理树。其优点是，即使不同的开发人员使用不同版本的 NPM，他们仍然不仅能够得到相同版本的依赖，还可以使用完全相同的目录树。 这与其他包管理器（如 [Yarn](https://yarnpkg.com/en/) ）不同。 Yarn 仅以 [flatten 格式](https://github.com/yarnpkg/yarn/blob/46750b2bebd487fb2d2011b9c4b7646ec6e2d8a3/yarn.lock) 描述各个包之间的依赖关系，并依赖于其当前实现来创建目录结构。这意味着如果其内部算法发生变化，结构也会发生变化。如果你想了解更多关于 Yarn 和 NPM 5 之间 lock 文件的区别，请查看 [Yarn determinism](https://yarnpkg.com/blog/2017/05/31/determinism/)。

## 双 lock 文件

上面已经提到过 lock 文件不止一个。当安装新的依赖关系或文件不存在时，NPM 将**自动**生成一个名为 `package-lock.json` 的 lock 文件。如开始所述，lock 文件是当前依赖关系树的快照，允许不同机器间的重复构建。因此，建议将它添加到您的版本控制中去。

你可能会认为，使用 `npm shrinkwrap` 及其 `npm-shrinkwrap.json` 可以实现同样的效果。你的想法没错，但创建新 lock 文件的原因是，这样能够更好的传达一个信息，就是 NPM 真正支持了 locking 机制，这在以前确实是一个显著的问题。

不过还是有一些区别。首先，NPM 强制该 `package-lock.json` 不会被发布。 即使你将其显式添加到软件包的 `files` 属性中，它也不会是已发布软件包的一部分。这种情况同样不适用于 `npm-shrinkwrap.json` 文件，哪怕这个文件**可以**是发布包的一部分、即便存在嵌套的依赖关系，NPM 也会遵守它。你可以简单的通过运行 `npm pack` 来查看生成的归档内部的内容。

接下来，您可能会想知道在已经包含 `package-lock.json` 的目录中运行 `npm shrinkwrap` 时会发生什么。答案很简单，NPM 仅仅会把 `package-lock.json` 重命名为 `npm-shrinkwrap.json`。因为文件的格式是完全一样的。

最好奇的还会问，当两个文件都存在时会发生什么。 在这种情况下，NPM将完全忽略 `package-lock.json`，只使用 `npm-shrinkwrap.json`。 当只使用 NPM 操纵文件时，这种情况不应该发生。

### 总结:

- NPM 会在安装包时自动创建 `package-lock.json`，除非已经有 `npm-shrinkwrap.json`，并在必要时更新它。

- 新的 `package-lock.json` 永远不会被发布，而且应该将其添加到你的版本控制系统中去。

- 运行已经带有 `package-lock.json` 文件的 `npm shrinkwrap` 命令将只会对其重命名为 `npm-shrinkwrap.json`。

- 当两个文件处于某些原因同时存在时，`package-lock.json` 将被忽略。

这很酷，但是什么时候使用新的 lock 文件而不是旧的 shrinkwrap？ 它通常取决于您正在处理的包的类型。

## 当开发库时

如果你正在开发一个库（如其他人所依赖的软件包），则应使用新的 lock 文件。 另一种替代方案是使用 shrinkwrap，并确保它不会随包发布（新的 lock 文件不会自动发布）。 但为什么不发布 shrinkwrap 呢？ 这是因为 NPM 遵守在包中找到的 shrinkwraps，并且由于 shrinkwrap 总是指向单个包的特定版本，所以你无法利用 NPM 可以使用相同的包来满足多个包的要求（在 [semver](//semver.org) 允许范围内）的优势。 换句话说，通过不去强制 NPM 来安装特定的版本，您可以让 NPM 更好的复用包，并使结果更小更快地组合。

这里有一个警告。当你正在开发库时，因为仓库中存在 `package-lock.json` 或 `npm-shrinkwrap.json`，所以每次都会获得完全相同的依赖关系，这对于你的持续集成服务器也是如此。现在想象你的 `package.json` 指定某个包的依赖关系为 `^1.0.0`，也恰好是 lock 文件中指定的版本，并且每次安装。到目前为止一切正常。但如果依赖项发布了一个新版本，并且意外的破坏了 semver 和你开发的包，这时候会发生什么？

遗憾的是，在出现错误报告之前，你可能无法注意到这个问题。在没有 lock 文件的仓库中，你的构建至少在 CI 服务器上会失败，因为它总是尝试去安装依赖的 `latest` 版本，从而运行出错的版本（只要该版本定期运行，而不仅仅是针对 PR）。 然而，当 lock 文件出现后，它将始终安装能正常工作的被 lock 的版本。

然而，对于这个问题有几个其他的解决方案。 首先，你可以牺牲问题重现的精确性，而**不**将 lock 文件添加到版本控制系统中。 其次，你可以做一个分离的配置来进行构建，在运行测试之前运行 `npm update`。 第三，你可以简单的在你运行测试之前删除 lock。 如何处理发现的损坏依赖是另一个话题了，其主要原因是因为 NPM 实现的 semver 不仅没有涉及如此广范围的问题，而且还不支持特定版本的黑名单特性。

这当然就会引起一个问题，在开发库的时候，是否真的值得将 lock 文件添加到版本控制中去。要记住的是，lock 文件不仅包含依赖关系，还包含 **dev** 的依赖关系。在这种意义下来讲，开发库与开发应用时类似（见下一节），无论什么时候都有着完全相同的 dev 依赖关系，并且不同设备也算一种优势。

## 当开发应用时

好，那么最终用户在终端中使用的包或打包的可执行文件会是个什么情况？在这种情况下，包就是最终结果，即应用。你想要确保最终用户总能获得你发布时所具有的确切依赖性。确保在安装时让 NPM 遵守规则，这就是您想要使用 shrinkwrap 的地方。 记住，使用 `npm pack` 发布包时，你可以随时查看软件包的情况。

注意，在 `package.json` 中指定一个特定版本依赖是不够的，因为你希望确保最终用户获得完全相同的依赖关系树，包括其所有子依赖关系。而 `package.json` 中的一个特定版本保证只会发生在顶层。

其他类型的应用怎么样，比如在仓库内启动的项目？这种情况并不重要。重要的是安装正确的依赖项，而两个 lock 都满足这一点要求。随你怎么选。

## 结束

没了，就这么多。如果有哪里不对或者有一些一般性的意见，请随时在 Tweitter 上联系我。如果你发现拼写错误或语法问题，则可以在 GitHub 上找到这个文章。感谢你的帮助！

如果你喜欢这篇文章，你可以在 Twitter 上关注 [@JiriPospisil](https://twitter.com/JiriPospisil) 并通过 [feed](/feed.xml) 订阅。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
