> * 原文地址：[How to Hide Secrets in Strings— Modern Text hiding in JavaScript](https://blog.bitsrc.io/how-to-hide-secrets-in-strings-modern-text-hiding-in-javascript-613a9faa5787)
> * 原文作者：[Mohan Sundar](https://medium.com/@itsmohanpierce)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-hide-secrets-in-strings-modern-text-hiding-in-javascript.md](https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-hide-secrets-in-strings-modern-text-hiding-in-javascript.md)
> * 译者：[niayyy](https://github.com/nia3y)
> * 校对者：[FateZeros](https://github.com/FateZeros)、[zenblo](https://github.com/zenblo)

# 如何在字符串中隐藏秘密 —— JavaScript 中的现代文本隐藏

![**All Hallows’ Eve — Illustrated by [Kaiseir](https://dribbble.com/kaiseir)**](https://cdn-images-1.medium.com/max/2000/1*HOGI5cdt1MJ9MBo1qTc1zA.jpeg)

> 最危险的地方就是最安全的地方。

如果你是一个在敌对国家的间谍，那么仅向美国发送信息便是犯罪。如果消息是加密的，那可能导致更大的罪名，当你拒绝为当局解密消息时，情况会变得更糟。**隐写术**，字面意思是“隐藏的文字”，是指隐藏消息的存在。

[**Python Forensics**](http://python-forensics.org/) 的创始人 Chet Hosmer 指出：

> 隐写术掩盖了信息的存在。不像它的表亲密码学一样容易检测，难以破解，隐写术提供最有趣的特点在于“藏在众目睽睽之下”。(Steganography hides the mere existence of the communication. Unlike its cousin cryptography, which is easy to detect but difficult to break, steganography provides the most interesting element of all ‘To Hide in Plain sight’.)

![Cloak of invisibility](https://cdn-images-1.medium.com/max/2000/1*Ze0Yy0Op7kqT8fJ3Le5FSg.gif)

**你是否知道上面的隐写术引用中有一个不为人知的隐藏秘密？** 如果我没有提到它，你是否能够感知它的存在？好吧，请阅读本文的其余部分，以理解其中的意义。

## Unicode 中的不可见字符

零宽度字符是非打印字符，是 Unicode 表的一部分。顾名思义，他们甚至不展示自己的存在。它们用于使长句换行，连接表情符号，将两个字符连接起来，防止它们结合等。

![The characters `zwj` join the emoji’s but they are not visible](https://cdn-images-1.medium.com/max/2000/1*ATrlUYwomSvUtygin5ndIA.png)

这些字符越来越多地发现其隐藏在文本中的方式，它们的完全隐形性是一个了不起的特点。由于它们在多种语言和表情符号中不可或缺，因此无法屏蔽它们。而且，事实证明，ZWC 并不是唯一不可见的字符。例如：隐形的分隔符 —— U+2063。

![The table that contains mostly used invisible characters](https://cdn-images-1.medium.com/max/2000/1*eP3yPonDN-Px68R1gO0PXw.png)

但是这个表格有一个小问题，Gmail 会屏蔽 U+200B（零宽度空格）。更不用说其它软件，Twitter 会将不必要的不可见字符列入黑名单，除 U+200C，U+200D 和 U+180e 之外，表中的所有字符均不起作用。因此，现在我们有了三个字符！

![](https://cdn-images-1.medium.com/max/2160/1*pnl_e3gWWQ3z1l58LTxaBg.jpeg)

哦，等等，U+180e 不是不可见的，并且在 iOS 设备中呈现异常。现在我们只有 2 个字符。

因此，我们打开 Unicode 表，并开始测试每个可能的不可见字符是否具有跨平台 / Web 可见性。幸运的是，我们能够在表格中再添加 4 个字符，总共 6 个不可见字符，我们现在可以使用它们在字符串中的隐藏秘密。可以了，好了！准备战斗..！

![Assemble!](https://cdn-images-1.medium.com/max/2000/1*HSPg4C9SGIT9-O6GWK0img.gif)

## StegCloak 是什么以及如何工作？

StegCloak 是一个纯 JavaScript 的隐写模块，在经过两层最大可能压缩和一层加密后，可用于在纯文本中隐藏秘密。因此，它不仅掩盖了秘密，而且还通过你选择的密码以及一系列其他特性来进行保护。**[在这查看我们的演示](https://www.youtube.com/watch?v=RBDqZwcGvQk)。**

#### 隐藏

![Hiding secrets in tweets](https://cdn-images-1.medium.com/max/2000/1*i-woBuZ902ZSMsrj9xSnoA.gif)

#### 显示

![Extracting hidden secret from the tweet](https://cdn-images-1.medium.com/max/2000/1*DqpMYkBY5NUdbw5wUKXliw.gif)

#### StegCloak 如何隐藏你的秘密并将其压缩的简要说明

步骤 1：**压缩并加密**秘密。

![](https://cdn-images-1.medium.com/max/2000/1*ALhxrbOw6UBJf858ckg9ew.png)

安全策略从未在这些系统入侵事件中发挥作用，我们希望借助 StegCloak 来满足 **[Kerckhoff 原则](https://en.wikipedia.org/wiki/Kerckhoffs%27s_principle)**，其中指出：

> 理想的加密系统应当具备很强的安全保障，能够在除密钥之外的系统全部内容都对外公开的情况下也是安全的。

即使攻击者识别出了算法的工作原理，也应该不可能破解秘密消息。

#### 满足原则

![](https://cdn-images-1.medium.com/max/2000/1*Bqj9PFww4K_VhaWfODqgMg.png)

为此，我们需要基于密码的对称加密。鉴于人们总是习惯使用简单脆弱的密码，以及他们倾向于多次使用相同的密码，我们决定从给定的密码中得出强密钥，并通过引入随机盐来增加密钥的随机性。根据对使用同一密钥生成的多个密文的分析，密钥需要具有随机性以防止攻击。现在，AES 中的常规块密码模式像 ECB 或 CBC 导致至少填充 16 个字节的块。 比如，发送 “Hi” CBC 模式填充 0 使其长度为 16，并在提取过程中将其删除，但这并不是好方法。因此，我们使用流密码模式 CTR（填充较少的密码）来生成密文。

![](https://cdn-images-1.medium.com/max/2000/1*b_0-voMOjqM2Jk1EKCZ1Fw.png)

第 2 步：使用额外的两个字符**再次编码和压缩**。

![](https://cdn-images-1.medium.com/max/2000/1*FEstcl9rEF0eX8Q3n0u4pg.png)

![](https://cdn-images-1.medium.com/max/2000/1*HfXp1u543ZaLCC5MaQ05_w.png)

如上图所示，即使我们有 6 个 ZWC 字符，也只有 4 个被使用，因为 6 不是 2 的幂。两个额外的字符（U+2063，U+2064）被用来做一个额外的抽象霍夫曼层压缩减少冗余。将机密转换为 ZWC 后，将确定流中两个重复最多的 ZWC，例如 U+200D 和 U+200C。现在，每两个连续出现的 U+200D 和 U+200C 被一个 U+2063 或 U+2064 替换。由于经常观察到冗余，因此可以节省很多。

步骤 3：**将不可见的流嵌入**封面文字的开头。

![](https://cdn-images-1.medium.com/max/2000/1*23avUCEVPdvmQr62z1eCzw.gif)

`Hi` 现在隐藏在了 6 个字符的 hello world 中，因此该字符串的总长度为

10 + 6 = 16 个字符

#### 提取

![](https://cdn-images-1.medium.com/max/2000/1*19IYY7Rw7rL76YX0NnmL5Q.gif)

反之亦然，没有什么复杂的，但考虑到当我们添加如加密和不可见性之类的特性时，有效载荷的长度会增加，因此我们进行了两层压缩(之前和之后)以最大程度地降低成本。因此，提取只付出很小代价。

![](https://cdn-images-1.medium.com/max/2000/1*p2dPqMPTmSxW9ndw7OjMKw.gif)

你可以在任何时间关闭某些特性以减少有效载荷长度，我们设计了 StegCloak 以灵活满足用户需求。

## 模块风格

> 当你可以将函数可视化为图形中的曲线时，生活会更加轻松 —— Kyle simpson

StegCloak 遵循编函数式编程范例，并且总体上仅包含两个功能：隐藏和显示。这两个功能是将许多代码段如堆积木般构建而成。这些片段不过是纯函数或柯里化后相同纯函数的不同版本。StegCloak 仅具有 `encrypt()` 不是纯函数，因为它会生成随机盐来增加密码的安全性。

#### 流

![How it works!](https://cdn-images-1.medium.com/max/2000/1*krNVCV3uhVJ2QTHKczM43w.png)

在我看来，采用函数式方法会使你的程序看起来更像流程图，从而提高其可读性。

![**Hide( )** in stegcloak.js](https://cdn-images-1.medium.com/max/3940/1*Vn7gxNmZVkVPQqgZuwOIOQ.png)

![**Reveal( )** in stegcloak.js](https://cdn-images-1.medium.com/max/4096/1*aN2AczUqvlXG6XtijJPNfA.png)

StegCloak 使用称为 RamdaJS 的函数式编程库。R.Pipe 接受输入函数并将参数传递给第一个函数，然后将其输出作为管道中下一个函数的输入。你会看到，可以将这些代码片段代理到另一个管道或在之前对其进行操作，然后再发送到下一个管道。可读性和隐式编程风格是设计的最大重点之一

## 揭开引用句的奥秘

*复制上面 Chet Hosmer 的引用句，并访问[stegcloak.surge.sh](https://stegcloak.surge.sh)
*在 Reveal 中输入密码 —— “Aparecium”

![](https://cdn-images-1.medium.com/max/2000/1*k5OSMLvm-vZesGylNImJEA.png)

* 将复制的句子粘贴到 STEGCLOAKED MESSAGE 文本框中

![](https://cdn-images-1.medium.com/max/2000/1*9Qd64_Y8acVK4uP9E9e9fg.png)

* 单击**获取机密**，看!

## 结论

它是由[我](https://www.linkedin.com/in/mohan-sundar-9881a7180/)和我的两个朋友 [Jyothishmathi CV](https://www.linkedin.com/in/c-v-jyothishmathi-791578181/)、[Kandavel](https://www.linkedin.com/in/ak5123/) 建立的

我们希望你像我们构建它一样喜欢它!

在 [Github](https://github.com/KuroLabs/stegcloak) 上搜索 [StegCloak](https://stegcloak.surge.sh/)或访问 [https://stegcloak.surge.sh](https://stegcloak.surge.sh)。

感谢你阅读本文 🖤。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
