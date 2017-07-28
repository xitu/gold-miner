> * 原文地址：[Life after JavaScript: The Benefits of Learning a 2nd Language](https://www.sitepoint.com/life-after-js-learning-2nd-language/)
> * 原文作者：本文已获原作者 [Nilson Jacques](https://www.sitepoint.com/author/njacques/) 授权
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[gy134340](https://github.com/gy134340)
> * 校对者：[Tina92](https://github.com/Tina92),[lsvih](https://github.com/lsvih)


# 生活在 JavaScript 之中：学习第二门语言的好处 #

 
	

	





	
	
你会多少种编程语言？根据最近的调查，大约 80% 的读者至少会两种。超过半数的人经常使用 PHP，我敢打赌大多数人就像我一样使用这门语言开始他们的 Web 开发。

最近我准备向我的简历上添加一门别的编程语言（好像在我的“待学习”清单里没有足够的东西）。最终我决定在网上学习 Scala 教程。对于不熟悉它的人来说，Scala 就是一门通用的强类型的编译语言（像 Java，它编译成可移植的字节码）。虽然像 JavaScript 一样它是多范式的编程语言，但它有很多存在于函数式编程语言中先进的函数式编程（FP）特性，比如说 Haskell。如果你对最近函数式编程语言的流行很感兴趣，那你可以仔细研究一下 Scala。

![Silhouette of a person made from programming terms and language names](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2017/03/1490029714Fotolia_101549014_Subscription_Monthly_M-300x267.jpg)

你也许在想“为什么我现在要再多学一门语言，我准备一辈子都用 JavaScript 了！”又可能你有一堆 JavaScript 的东西要学习。仍然有一些很好的理由去学习一门新的语言。真正掌握概念的好方法，如静态类型、编程范例，或者函数式编程，是用一种语言工作，这会迫使你使用这些东西。JavaScript 的灵活性很是吸引人，但它也可能导致一些问题。学习另一种语言写代码的方式会教会你不同看待与处理问题的方法，这也会改变你写 JavaScript 的方式。另外，有了语言所限制的编程风格将会真正帮助你了解它的优劣。

接触新的编程范式、概念和风格对我们这些没接受过正规训练的自学者会有莫大的帮助。计算机科学的毕业生可能已经将许多这些概念作为他们学习的一部分。为了更好的成长，需要考虑学习那些与 JavaScript 完全不同的语言。

值得一提的是，一些现在流行的库和设计模式正是从其他语言中提取出来的概念。Redux，一个 React 的状态管理插件，是借鉴 Elm 中数据流系统。Elm 本身是受 Haskell 启发的一门编译成 JavaScript 的语言。学习别的编程语言可以更好的帮助你更好的理解这些库和它们背后的概念。如果呆在 JavaScript 的舒适区中，你就只能依靠别人从别的编程语言中提取这些见解，并以比较浅显的方式展现出来。


学习新的语言也会影响你看待第一门语言的方式。当我开始学习葡萄牙语时，它改变了我看待英语的方式。当你不得不以一种其他的方式做事情时，它会强迫你以母语来思考如何做。你不再觉得理所当然，而是会开始追根溯源。你可以看到一些语言的相似之处：例如葡萄牙语和英语都是起源于拉丁语，它们的一些动词很接近，你可以轻易猜出它们的意思。对于编程语言也是一样，特别是你还只会一个的时候。接触其他语言下将会帮助你思考设计 JavaScript 时所采取的设计选择。一个更为具体的例子是，学习一门支持类继承的语言可以让你对比其与 JavaScript 原型对象继承体系的不同之处。

WebAssembly (WASM)，一个实验中的偏底层语言，将很快可以在浏览器中使用。C 和 C++ 等高级语言将可以编译成 WASM，并获得比 JavaScript 更小的文件和更出色的表现。这将把浏览器向其他语言开放，在未来将一定会有越来越多的语言可以被编译成 WASM。JavaScript 的创造者 Brendan Eich 最近说他可以预见 [JavaScript 在未来可能会过时](http://www.infoworld.com/article/3175024/web-development/brendan-eich-tech-giants-could-botch-webassembly.html)。可以确定的是，JavaScript 将会在长时间内依然重要，但使用另一门语言肯定不会伤害你的就业前景，也可以避免你被局限于 JavaScript 开发的小笼子里。

### 更多篇文章 ###


* [Behind the Scenes: A Look at SitePoint's Peer Review Program](https://www.sitepoint.com/behind-the-scenes-sitepoints-peer-review-program/?utm_source=sitepoint&amp;utm_medium=relatedinline&amp;utm_term=&amp;utm_campaign=relatedauthor)
* [SitePoint Needs You: The 2017 JavaScript Survey](https://www.sitepoint.com/2017-javascript-survey/?utm_source=sitepoint&amp;utm_medium=relatedinline&amp;utm_term=&amp;utm_campaign=relatedauthor)

如果你真的没有时间学习新的语言，你不必远离 JavaScript 就可以获得我刚刚提到的好处。上周我们出版了完全用 TypeScript 编写的[the second part of our Angular 2 tutorial series](https://www.sitepoint.com/understanding-component-architecture-angular/)。TypeScript 是 JavaScript 的超集，所以你知道的大部分都会应用。它添加了静态类型和接口以及装饰器的概念（后者将会出现在 JavaScript 下一个版本中）。花费一些时间学习 TypeScript 将会加深你对静态语言和动态语言的理解，也会扩展你作为 JavaScript 程序员的知识面和就业能力。作为 Angular 2 的默认编程语言，就业前景很广阔。你从中学习到的理念会让你将来学习 Java 或者 Scala 更为简单。

你会用除了 JavaScript 之外的编程语言吗？对于 JavaScript 程序员学习的第二门语言又有什么好的建议？WebAssembly 将会改变游戏规则吗？我很乐意听取你们的意见，在下方给我评论吧！

这篇文章有用吗？
