> * 原文地址：[Moving a large and old codebase to Python3](https://medium.com/@boxed/moving-a-large-and-old-codebase-to-python3-33a5a13f8c99)
> * 原文作者：[Anders Hovmöller](https://medium.com/@boxed?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/moving-a-large-and-old-codebase-to-python3.md](https://github.com/xitu/gold-miner/blob/master/TODO/moving-a-large-and-old-codebase-to-python3.md)
> * 译者：
> * 校对者：

# 将项目迁移到 Python 3

一年半前，我们就决定使用 Python 3 了。我们已经讨论了很长时间，现在是时候使用了！ 讨论过程已经结束了,所以我们已经将开发的最后部分改用 Python 3。

*   整个代码库有 240 k 行，不包括空行和注解。
*   这是一个基于 Web 的多批次任务。并且只有一个开发，部署环境。
*   代码库有15年的历史了。
*   虽然这是一个 Django 应用程序，但是预发行版只有部分包含 Django 。

关于 Python 3 的一些基本统计数据是基于对 git 历史的粗略过滤产生的：

*   275 次提交
*   4080 次添加代码行
*   3432  次删除代码行

我发现有 109 个 jira 问题与这个项目相关。

### Py2 → six → py3

我们的理念一直是 py2 ￫py2/py3 ￫ py3  因为我们实在无法在实际开发中实现巨变，这种直觉也以令人惊讶的方式被证明是正确的。 这意味着 [2 到 3](https://docs.python.org/2/library/2to3.html) 是不可能的，我认为这很常见。我们尝试过使用 2 到 3 来检测 Python 3的兼容性问题，但很快这也被发现无法成立。基本上，这样的更改意味着在 Python 2 中的代码将被破坏。这样的改变不可行。

结论是使用 [six](http://six.readthedocs.io), 这是一个库，可以方便的构建一个在 Python 2 和 3 中都有效的代码库。

首当其冲的就是更新以前的依赖关系。这项工作立即开始，之后就会有更多的内容要更新。

### 现代化

[Python-modernize](https://python-modernize.readthedocs.io) 是我们选择进行迁移的工具。It’s a tool to automatically convert from a py2 codebase to a six-compatible code base.  我们首先引入一个测试，作为 CI 的一部分，来检查基于现代化的新代码是否已经准备好了。The biggest effect of this was to make those who still used py2 idioms aware of the new way to do things, but it obviously didn’t help much in moving the existing 240k lines to six. We all had bad habits of using some old syntax so this was a pedagogical win, even it made little difference counting lines of code. It was also used for our experimental branch:

#### Experimental branch

I started a branch called simply “python3” where I did the following:

*   Ran “python-modernize -n -w” on the entire code base. This modifies the code in place. I often did this step and started fixing things without first committing. This was always a mistake that I regretted, more than once forcing me to revert the entire thing and start over. It’s better to commit this stage even if it’s badly broken. Separating things done by a machine vs things done by a human is the important part here.
*   Move all imports for dependencies we still hadn’t fixed for py3 into the function bodies that used them.

The idea here is to “run ahead”, i.e. to see what problems we would get if we didn’t have out of date dependencies. This branch allowed me to very quickly start the application in a super broken state and get at least some unit tests to run. The diff for this branch was of course huge, but I used this to find nice low hanging fruit that I could apply in fairly large chunks. I used the excellent GitUp to split up, combine and move around commits. When a commit looked good I cherry picked it to a new branch that I sent to code review.

No one else could work on this branch because it was constantly being rebased, force pushed and generally abused but it did move us along without having to wait for all dependencies to be updated. I highly recommend this approach!

### 静态分析

We added pre commit hooks so if you edited a file you got nagged to fix all the python3 changes modernize suggested.

Hand rolled static analysis for `quote_plus`: There are some subtleties when dealing with quote_plus and six. We ended up creating our own wrapper and statically enforcing that the code used this wrapper and not the one from the standard lib or the one from six. We also statically checked that you never sent in bytes to quote_plus.

We fixed all python3 issues per django app and enforced this with a whitelist in the CI environment so you couldn’t break an app that was once fixed.

### 依赖

对于我们来说，解决依赖是最困难的部分。我们有很多依赖关系，所以花了很多时间，但有两个依赖关系比较突出：

*   splunk-lib. We have a dependency to splunk and they are to this day ignoring all their [very angry customers who are begging/screaming/asking them to fix their client library for py3](https://github.com/splunk/splunk-sdk-python/issues/91). One person on our team finally [just did it himself](https://github.com/tltx/splunk-sdk-python/). Splunk has really handled this badly and even locked the issue for comments! This is unacceptable.
*   Cassandra. We use this database for a lot of things across the product, but we used an older driver which used an older API model. This was a huge part of the py3 migration for us because we had to basically rewrite all this code piece by piece.

### 测试

We have ~65% code coverage on our tests: unit, integration, and UI combined. We did write more tests but the overall number didn’t change much, not surprising when one considers moving coverage from 65% to 66% means writing tests that cover 2000 lines of code.

We had to skip the tests that required Cassandra while we fixed this dependency. I invented a funny little hack to make that work and [wrote about that separately](https://medium.com/@boxed/use-the-biggest-hammer-8425e4c71882).

### Code changes

Some notes on code changes that either weren’t covered well by documentation on how to do a py2 to six transition (or maybe things we just missed):

#### 字符串 IO

我们在代码中大量使用字符串 IO。第一反应就是使用 six。StringIO but this turns out to be the wrong thing in almost all cases (but not all!). We basically had to think very carefully about every place we used StringIO and try to figure out if we should replace it with io.StringIO, io.BytesIO or six.StringIO. Making mistakes here often meant that the code looked like it was py3 ready and worked in py2 but was broken in py3.

#### from __future__ import unicode_literals

This is a mixed blessing. You find bugs by adding this to a lot of files, but it also introduces bugs in py2 sometimes. It also gets very annoying when logs suddenly write u in front of strings in weird places. Overall not the clear win I was expecting it to be.

#### str/bytes/unicode

This was largely what you’d expect. One surprise to me was the places where you needed str in py2 and py3. If you use the unicode_literals future import some strings need to go from `'foo'` to `str('foo')`.

#### six.moves

The implementation of six.moves is a very strange hack so it doesn’t behave like the normal python module it pretends to be. I also disagree with their choice not to include `mock` in six.moves. We had to add it outselves with their API which was surprisingly difficult to get to work, and it required us to change `from mock import patch` to `from six.moves import mock` which also meant that `patch` now becomes `mock.patch` everywhere.

#### CSV 的解析是不同的

If you use the csv module you need to look at csv342. This should be a part of six in my opinion. That it’s not there means you aren’t made aware that there’s a problem. We got away with not using csv342 in many places though, so your milage may vary.

### 发布顺序

我们首先进行测试：

*   在 CI 中进行单元测试
*   在 CI 中进行集成和UI测试（不包括 Cassandra）
*   在 CI 中进行 Cassandra 测试 (这要晚于之前的步骤!)

Next it was time to move over the product itself. We built the ability to switch one batch machine at a time to py3 and crucially to switch it back. This was very important since things _did_ break in production when on py3. That’s mostly fine for us since we can just requeue the jobs that broke, but we can’t break too much or anything that is actually critical obviously. Because we use Sentry to collect crash logs it was very easy to review all the problems we hit when turning on py3 and when we had fixed them all, we turned on py3 again until we got a few issues, rinse repeat.

我们有如下环境：

*   Devtest: used internally by dev so mostly this is just used to test database migrations. This environment is very lightly used so problems aren’t found here very often.
*   IAT (Internal Acceptance Testing): used to validate changes and perform regression testing before we roll them out to production.
*   UAT (User Acceptance Testing): a test environment that customers can access. Used for changes where we need to prepare customer systems or give customers the ability to see the changes before they go live. This environment gets database migrations a few days before they go live.
*   Production

我们按照以下顺序将 Python 3 发布到这些环境中：

*   Devtest 环境
*   短期 IAT 环境
*   长期 IAT 环境
*   One production batch machine for short periods
*   One production batch machine on during business hours
*   Production SFTP
*   Half of all production batch machines
*   Production batch
*   Production web (after a long manual testing run of the test environment)
*   Production load machines. This is a special subset of the batch processing that do the most CPU and memory heavy part of our product.

The load machines exposed configurations for customer data that was incompatible with Python 3 so we had to implement warnings for these cases in Python 2 and make sure we had fixed them all before turning on Python 3 again. This took a few days because we get customer data once a day, so every time there was even one warning we had to wait one more day.

### Surprises in production

*   `'ß'.upper()` in p2 is `'ß'` but `'SS'`in py3. This caused a crash in production when the last piece of the product moved to py3!
*   Sorting/comparing objects of different types is valid py2 but hides loads of bugs. We got some nasty surprises because this behavior leaked through the stack in some non-obvious ways. Especially that `None` existed in some lists that were being sorted. Overall this was a win since we found quite a few bugs. `None` is sorted first in lists in py2, which might be surprising (you might expect it to be sorted next to zero!), but this was often the behavior we actually wanted. Now we just have to handle this ourselves.
*   `'{}'.format(b'asd')` is `'asd'` in Python 2, but `"b'asd'"` in Python 3. Almost any other behavior in Python 3 would have been better here: hex output (more obviously different), the old behavior (existing code works), or throwing an exception (would have been best!).
*   `int('1_0')` is [10 in py3](https://www.python.org/dev/peps/pep-0515/), but invalid in py2. This even bit us before we switched to py3 because the mismatch caused another team that used py3 before us to send us integer literals that we thought were invalid, but they thought were valid. I personally think this decision was a mistake: very strict parsing is a better default. I fear this will continue to bite us in subtle ways for years to come.

### 结论

最后，我们觉得在这件事上我们真的别无选择:  Python 2 的维护将在某个时刻停止，我们的依赖项仅限于 py 3，最明显的就是 Django。但是，无论如何，我们还是想要进行这种转换，因为我们经常会被字节/Unicode 问题困扰，并且Python 3 仅仅是修复了 Python 2 中的许多小麻烦。这次迁移过程，我们已经在开发过程中发现了一些实际的漏洞/错误配置。我们也期待在任何地方都可以使用 f- 字符串和有序分词。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。