> * 原文地址：[Node.js vs Python – Where to Use and Where not?](https://www.agriya.com/blog/2016/07/13/nodejs-vs-python-where-to-use-and-where-not/)
> * 原文作者：[Agriya](https://www.agriya.com/blog/author/ace/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[ymz1124](https://github.com/ymz1124)
> * 校对者：[zaraguo](https://github.com/zaraguo), [sunui](https://github.com/sunui)

# Node.js 和 Python 对比 —— 哪里使用 Node.js 哪里使用 Python ？

![](https://www.agriya.com/blog/wp-content/uploads/2016/07/nodejs-vs-python.png)

当谈到网站的后端开发时，开发人员可以容易地找到一些优雅的开发语言，比如 PHP、Python、C++ 和 JAVA 都是重要的网站开发语言。话虽如此，但是仍有一些 web 开发公司和开发者在没有任何合理的设计或一个确定的结构就开始创建网站和应用。在这里，他们可以找一些框架助力网站和应用的创建。比如 Laravel, Symfony, cake, Yii 等就是很好的 PHP 框架。简而言之，开发者创建网站和应用的选择非常多。

Node.js 是一个强大的运行环境，开发者和许多 [Node.js 开发公司](https://www.agriya.com/services/node.js-development)用它来创建 web 解决方案。它是纯 JavaScript 的并且很容易学。Python 是一个纯服务器端的脚本语言，它有很多爱好者。有 Java 背景的开发者会觉得从 Java 转到 PHP 是一件很恐怖的事情，但从 Java 转到 Python 会舒服很多。一些资深开发者会同时使用 Node.js 和 Python。为了能在 web 解决方案中完全发挥出 Node.js 和 Python 的长处，开发者必须非常清楚什么情况下能使用，什么情况下不能使用。他们必须对这两个平台的优点、缺点、功能和平台的使用都有充分的了解。

## Node.js 的出色之处

Node.js 是纯 JavaScript 的并且学习曲线很低，很容易学习。在多数情况下，Node.js 比 Python 快。Python 在初始阶段比较慢。也许，Node.js 是目前实时 web 应用最好的平台，这些实时 web 应用需要处理**输入队列、数据流和代理**。Node.js 在聊天应用相关的场景发挥得最好，比如实时**股票交易**。

## Node.js 的逊色之处

Node.js 没有清晰的代码标准。不推荐使用 Node.js 做大型项目，除非你有一个受过编码风格训练的开发团队。项目中的每个开发者必须遵循 **Promise** 库或者 **Bluebird**，并且必须维护一套严格的风格手册以避免项目中断。

在使用 Node.js 实现较大的项目时，调试以及增加新特性可能会给开发者带来痛苦。当使用动态语言时，开发者可能在 IDE 中找不到足够的有用函数。在大型项目中，Node.js 的回调函数、错误处理和整体的可维护性可能会有问题。Node.js 适合在仅实现较少脚本功能的小型项目中使用，并且速度很快。

## Python 的出色之处

使用 Python 最大的优点是你只需要写少量的代码就行，并且它是一个干净的平台。学习这个平台没有那么容易，但是从长远的角度考虑，学习者可以容易地克服这个问题。这个平台可维护性很好，并且可以用更少的时间排错。紧凑的语法使用起来非常简单。它是一种具有价值标准的语言，且很容易调试和修复错误。

Python 由一些比 PHP 好的函数库组成。导入的异常和命名空间真的很好，没有任何问题。简单地讲，Python 可以做任何 PHP 代码可以做的事情，并且这些可以以更快的速度完成。因此，使用 Python 开发大型项目时，开发者可能不会面临任何重大的问题。

## Python 的逊色之处

Python 在运行时环境中的性能没有 Java 快。对于内存密集的活动来说，它不是最佳选择。它是解释型语言，和 Java 或者 C/C++ 相比存在初始性能下降的问题。

简单地说，Python 不适合开发涉及图形和需要更多 CPU 的高档 3D 游戏。Python 还在发展中，新增功能的文档比较糟糕。同样，和 PHP、Java 或者 C 相比，它的教程很少。

## 联合使用

Node.js 使用内置即时编译器的 V8 JavaScript 解释器来提高 web 应用的速度。Python 也有一个叫 PyPy 的内置解释器。不过它还不支持 3.5.1 版本的 Python。最后，古话说，编程语言无好坏之分。让网站或应用焕发生命力的是大脑、眼睛和双手，正是它们在开发之时将语言的精髓运用自如。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
