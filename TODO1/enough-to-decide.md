> * 原文地址：[How I decide between many programming languages](https://drewdevault.com/2019/09/08/Enough-to-decide.html)
> * 原文作者：[Drew DeVault](https://drewdevault.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/enough-to-decide.md](https://github.com/xitu/gold-miner/blob/master/TODO1/enough-to-decide.md)
> * 译者：[Badd](https://juejin.im/user/5b0f6d4b6fb9a009e405dda1)
> * 校对者：[jiapengwen](https://github.com/jiapengwen)，[acev](https://github.com/acev-online)

# 这么多编程语言，我该怎么选？

在我的工具库中，有一些经典搭配是我最常用的，但我仍然想要学习足够多的编程语言，这样，当我遇到某个使用案例时，我就有足够的选项来衡量哪一个是最合适的。最佳方式就是边做边学，因此对各种语言的功能形成一个大概印象，能帮你弄清楚这些语言是否对某个特定的问题有用，即使你对这些语言还并不熟稔。

我在这里列出的语言，都是我对其熟悉到了有资格评论的程度，还有很多并不在此列，我鼓励大家自己去探索。

## C

优点：性能优良；能访问底层工具；适合系统开发；支持静态类型；规范而且古老；全世界通用、全平台支持。<sup>[1](#footnote1)</sup>

缺点：字符处理、可扩展编程是短板；在特定【领域人体工程学中】（ergonomic）库的可用性很差；坑用户，但也有些程序员认为这些坑也是有用的。

## Go

优点：迅速、谨慎；包管理器好用、语言生态健康；有精心设计的标准库；在处理很多问题方面都是同类中最优秀的；一个规格、多种有用实现；和 C 交互起来非常方便。

缺点：运行时太过复杂；虚拟线程和真实线程无差别（也就是说，所有的程序都要处理后者的问题）。

## Rust

优点：**安全**；适合系统开发；优于 C++；语言生态多样，却没有 npm 的弊病；和 C 交互起来非常方便。

缺点：体积太过庞大；没做到标准化；仅有一个有意义的实现。

## Python

优点：解决起问题来简单而迅捷；包的设计非常精巧，包生态多样化；深度可扩展，适合服务端的 Web 软件。

缺点：臃肿；性能不强；数据类型是动态的；CPython 的内部开放导致了实现的单一性。

## JavaScript

**包括本尊及继承了其弊端的所有衍生语言。**

优点：功能性强却兼具直观明了的、类 C 的语法；ES6 在许多方面都有所改进；async/await/promise 设计优良；不涉及线程处理。

缺点：动态类型；包生态动荡不安；很多 JavaScript 开发者并不精通却硬造生态库；诞生于 Web 浏览器，因而继承了不少瑕疵。

## Java

**包括本尊及继承了其弊端的所有衍生语言。**

优点：历经长足发展；易于理解、相当迅速。

缺点：模板泛滥；缺少很多有用的东西；包管理器,XML 到处都是；不适合底层编程（这一点对所有 Java 系的语言都适用）。

## C#

优点：没有 Java 那么多模板；包生态非常健康；良好支持与 C 交互的底层工具；async/await 的发源地。

缺点：因为 Microsoft 没有保留单一版本，导致语言生态混乱；开源过晚，对 Mono 不友好。

## Haskell

**本尊及该谱系所有的功能性编程语言，例如 elixir、erlang、大部分的 lisp 类语言，即使它们并不愿意被混为一谈**

优点：**功能性强**；相当迅速；当你不关心解决方式而只看重问题的答案时，它非常有用；适合研究级别<sup>[2](#footnote2)</sup>的编译器。

缺点：**功能性强**；有些难以捉摸；包管理器很糟糕；不能与其环境很好地适配；其作者希望整个世界都用一个单纯的函数设计软件来描述，就好像能做到似的。

## Perl

优点：[好玩](https://github.com/Perl/perl5/blob/blead/Configure)；处理正则表达式和字符串的能力是同类中最好的；当需要构建拼接程序（hacky kludge）时，用 Perl 很合适。

缺点：难以捉摸；过度扩展；垃圾代码泛滥。

## Lua

优点：可嵌入、易于接入宿主程序；非常简单、便携。

缺点：客观地说，从 1 开始索引很不可取；上游维护者好像有点心不在焉，没人对它是真爱。

## POSIX Shell 脚本

优点：没有什么能比把命令串在一起的做法更好了；只要学会了九成，你就可以写出很优秀、很直观的程序来解决同一类问题了；标准化（我不用 bash）。

缺点：大多数人只学会了一成，因此写出的程序非常烂、非常抽象；处理不了大多数复杂的任务。

---

免责声明：剩下的这些编程语言，我不喜欢，也不会用它们去解决任何问题。如果你不想让你的信仰受到冲击，请不要再往下看了。

## C++

优点：无。

缺点：语义含糊不清；过于臃肿；**面向对象**；为了兼容 C 而变得复杂；生态乌烟瘴气；水平低的开发者才会喜欢它。

## PHP

优点：无。

缺点：每个 PHP 开发者都不懂编程；这个语言就是被设计用来确保让开发者每搬一块砖都砸在自己脚上（或者头上）的，因此整个语言生态就是一地鸡毛。别顶嘴，PHP 7 并没有什么改善。赶紧去用一门真正的编程语言吧，蠢材。

## Ruby

优点：既**商务**又**炫酷**，因此能够有效地将一群初级到中级的程序员集中带向一个特定的方向，也就是你的创业公司的安全出口。

体型臃肿；性能糟糕；在 Node.js 崛起前，那帮程序员都用这个。

## Scala

优点：比 Java 更明了；适合处理**大数据量**的问题。

缺点：Java 的派生物；要是没有博士学历就别想弄明白它的类型系统；过于脱离 Java，就是说作为 Java 生态的一部分，它继承了所有缺点，但优点却没怎么吸收；其类型系统毫无必要的复杂性让其自身的优点大打折扣。

<a name="footnote1">1</a>：只有一个平台不支持，但我才不在乎呢。
    
<a name="footnote2">2</a>：但不适用于生产级别的编译器。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
