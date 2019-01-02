> * 原文地址：[Contributing to Django Framework is easier than you think](https://www.vinta.com.br/blog/2017/contributing-hugh-lib/?hmsr=pycourses.com&utm_source=pycourses.com&utm_medium=pycourses.com)
> * 原文作者：[Anderson Resende](https://www.vinta.com.br/blog/author/andersonresende/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/contributing-hugh-lib.md](https://github.com/xitu/gold-miner/blob/master/TODO/contributing-hugh-lib.md)
> * 译者：[JayZhaoBoy](https://github.com/JayZhaoBoy)
> * 校对者：[song-han](https://github.com/song-han), [Tina92](https://github.com/Tina92)

# 为 Django Framework 贡献你的力量并没有想象中的那么难

当我们准备开始编码并开源的时候，总感觉无从下手。我知道，给一个精彩绝伦的代码库贡献代码的这个想法听起来是有一点吓人的。不过幸运的是，只要你愿意，很多这样的开源库会为你提供大显身手的空间。他们同样会给予我们所需要的支持。听起来很不错吧？

你知道那个著名的 python 框架吗？[Django](https://www.djangoproject.com/)！他们的网站上有一个部分叫 [Easy Pickings](https://code.djangoproject.com/query?status=!closed&easy=1)。假如你准备开始参与开源工作并为一个精彩的代码库做贡献，这就是为你而准备的！

在这篇博客中，我将逐步向你展示如何通过修复 Django easy pick 问题来为开源代码库做贡献的，通过这几个简单的步骤你也可以做到。接下来我将通过修复一个缺陷来从头到尾讲解这个过程，跟我来！

## 发现/定位一个 bug

首先你要做的是访问 Django 的 [Easy pickings](https://code.djangoproject.com/query?status=!closed&easy=1)部分。在那里你可以找到易于修复 ticket 和小 bug。每天都会有新的 ticket。找到没有分配给任何人的 ticket。如下图所示： 

![Alt text](https://vinta-cms.s3.amazonaws.com/media/filer_public/d7/a3/d7a34921-1f76-49f3-89e0-e0d35c0d552c/easy_pickings_search.png)

本文中我选择的是 [bug ticket #26026](https://code.djangoproject.com/ticket/26026) 并把它分配给我自己，接下来我们要深入的了解这个问题。在下图中，我只是显示了 ticket 的头部。请记得阅读完整的 ticket。

![Alt text](https://vinta-cms.s3.amazonaws.com/media/filer_public/25/92/2592c87c-c1e0-4a32-b8d5-97e35df7dcd6/easy_bug_card.png)

正如我之前所说，我已经解决了这个 bug。所以当我把这个 bug 分配给我自己，bug 将被关闭，并有一些相关的 PR。因此当你选择一个 bug 时，千万不要忘记把它分配给自己。这是为了防止其他人重复选择这个 bug。你需要在 Django 的网站上登录，在 ticket 页面的顶部有链接。

如果你打开 ticket 页面，你可能会看到一些关于如何解决问题的意见和方案。通常这些对你都是很有帮助的。

好了！我们现在已经找到并理解了一个公开的 ticket 是什么样子的。

## 开始编码

第一步先 fork [Django repo](https://github.com/django/django)仓库。第二步，编写你的代码，并按照建议的风格进行提交[Django's guidelines](https://docs.djangoproject.com/en/1.10/internals/contributing/committing-code/#committing-guidelines)。可以参考一下我的提交： _[1.9.x] Fixed #26026 -- Checked if the QuerySet is empty_。最后发起 pull request。

让我们来看一下我的 pull request 并检查一下我的代码。可以看到我用了包含 ticket 的链接来注释这个 PR。

![Alt text](https://vinta-cms.s3.amazonaws.com/media/filer_public/03/35/03350a59-e487-4d51-bcee-01a86e5c9bed/unmerged_pr.png)

![Alt text](https://vinta-cms.s3.amazonaws.com/media/filer_public/c3/c8/c3c817a7-bef7-4fda-96ea-12f01d016847/unmerged_pr_code.png)

简单吧，你觉得呢？这是我的解决方案，只有一行代码。但是看了下面的答案我发现：

![Alt text](https://vinta-cms.s3.amazonaws.com/media/filer_public/d0/78/d07800d2-d0a4-42db-a285-a011eb4744f9/unmerge_pr_comment.png)

额... 问题的原因是我对错误的 Django 版本进行了 pull request。而且我忘记了写我的修复测试。让我们来解决这个问题！

这是我的第二次 PR，针对 master 对我已经编写的代码进行测试。请注意我的提交名称已经变了（和我的 PR 名称一致）。

![Alt text](https://vinta-cms.s3.amazonaws.com/media/filer_public/0d/fc/0dfcc5a4-dd68-4c39-b7ea-151c44933799/merged_commit_pr.png)

![Alt text](https://vinta-cms.s3.amazonaws.com/media/filer_public/3c/1b/3c1b3d9c-f8fc-4a3a-a393-2e6fa8af52d5/merged_pr_code.png)

完成！我的 PR 已经被合并和关闭。我已经为了不起的 Django 库做出了我的贡献！

![Alt text](https://vinta-cms.s3.amazonaws.com/media/filer_public/fb/08/fb08867f-2c67-4bed-a7ee-d66839d92cae/dead.gif)

**更多来自Vinta**

- [**Controlling access: a Django permission apps comparison**](https://www.vinta.com.br/blog/2016/controlling-access-a-django-permission-apps-comparison/)
- [**Python API clients with Tapioca**](https://www.vinta.com.br/blog/2016/python-api-clients-with-tapioca/)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
