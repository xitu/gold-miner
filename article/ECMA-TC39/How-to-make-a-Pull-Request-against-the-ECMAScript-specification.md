> * 原文地址：[How to make a Pull Request against the ECMAScript specification](https://github.com/tc39/how-we-work/blob/master/pr.md)
> * 原文作者：[Ecma TC39](https://github.com/tc39/how-we-work)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/ECMA-TC39/How-to-make-a-Pull-Request-against-the-ECMAScript-specification.md](https://github.com/xitu/gold-miner/blob/master/article/ECMA-TC39/How-to-make-a-Pull-Request-against-the-ECMAScript-specification.md)
> * 译者：
> * 校对者：
>

# How to make a Pull Request against the ECMAScript specification

All changes to the JavaScript specification ultimately become a pull request (PR) against the [ecma262](https://github.com/tc39/ecma262/) or [ecma402](https://github.com/tc39/ecma402/) repositories.

## Making a PR

To make a pull request (PR), [fork](https://help.github.com/articles/fork-a-repo/) the [ecma262](https://github.com/tc39/ecma262), apply changes to the spec.html, and upload it to your fork on GitHub, using the web interface to file a pull request. Locally, to see how your change renders in HTML, use `npm run build` (via [ecmarkup](https://github.com/bterlson/ecmarkup)) to build spec.html into an actual HTML file.

**Which repo should the PR target?**: Almost all specifications PRs should target the ecma262 repo; ecma402 is just used for the Intl specification, which provides a standard library for internationalization.

Commits in pull requests should have a first line which starts with a tag, followed by a colon, indicating which type of patch they are:

* `Normative:` changes impacting JavaScript behavior in some way. These changes are called "observable" because it is possible to write code to "observe" the change in behavior.
* `Editorial:` any non-normative changes to spec text including typo fixes, changes to the document style, etc.
* `Layering:` refactoring of specification text, algorithms, and/or embedder hooks to enable clean integration of the JavaScript specification with other specifications that use JavaScript.
* `Markup:` non-visible changes to markup in the spec
* `Meta:` changes to documents about this repository (e.g. readme.md or contributing.md) and other supporting documents or scripts (e.g. package.json, design documents, etc.)

## Stage 4 proposal PRs (`Normative:`)

Stage 4 of the [TC39 Stage Process](http://tc39.es/process-document/) requires a proposal to be written up as a PR against the specification; a review of this PR from the [editor group](https://github.com/tc39/how-we-work/blob/master/management.md#ecma-262-editor-group) is required to reach Stage 4, and after Stage 4, the PR is merged.

## Non-normative PRs

Editorial, Layering, Markup, and Meta PRs do not change how JavaScript behaves, but they are useful for people who are reading or working with the JavaScript specification.

If you have a change that you'd like to make to the JavaScript specification, either file an issue for initial discussion, or go straight to putting a PR out for review. Oftentimes, the review can be conducted purely on GitHub, involving the editors and anyone else who wants to participate. Since there is no observable change to JavaScript, these PRs don't require the explicit consensus of the committee, but they may be brought to committee if they are controversial.

## Normative PRs

Normative PRs change what JavaScript programs do, potentially requiring action to adjust from both JavaScript engine implementers as well as developers who program in JavaScript. This is serious business! For this reason, Normative PRs have the following requirements:

- There must be tests proposed in [test262](https://github.com/tc39/test262/) for the PR.
- The PR must be brought up in committee. In some cases, this can be a quick description by editors or the author, and if no concerns are raised, the proposal is considered to "have consensus". Other times, if the proposal is controversial, it's useful to [prepare a presentation](https://github.com/tc39/how-we-work/blob/master/presenting.md) explaining the motivation in more detail, with a discussion following it to discuss whether the committee can come to consensus on the proposal. For this reason, controversial normative PRs are tagged "needs consensus".

If you have a PR that you've proposed, and you'd like to push it forward, write test262 tests for it and put it on the agenda for an upcoming TC39 meeting. If you're not on the committee, it's important to find a TC39 delegate to champion the proposal and help push it through the committee's process, including giving the presentation.

It is encouraged for TC39 delegates to proactively add "needs consensus" PRs to an upcoming meeting agenda and present them; if one is not available, the editors, as time permits, will add these to the agenda.

### "Web reality" PRs

Occasionally, there is a mismatch noticed between what the JavaScript specification says, and what most or all web browsers implement. Given the large quantity of code on the web, there's a decent chance that there are already many websites which expect the unspecified, but broadly shipping, behavior. In these sorts of cases, the most useful thing to do is often to change the specification, rather than change all of the JavaScript implementations, to match "web reality".

### Implementation feedback

In many cases, it's useful to have some feedback about how realistic it is to implement a Normative PR, whether implementations are interested in making some kinds of non-trivial changes, etc. For these cases, the committee may ask for one or more implementations (possibly just in a fork or behind a flag) before merging a Normative PR.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。
---
> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。

