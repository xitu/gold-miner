> * 原文链接 : [JavaScript Developer Survey Results](https://ponyfoo.com/articles/JavaScript-developer-survey-results)
* 原文作者 : [ponyfoo](https://ponyfoo.com/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [sqrthree(根号三)](https://github.com/sqrthree)
* 校对者: [Zhangdroid](https://github.com/Zhangdroid)
* 状态 :  完成

# JavaScript 开发者年度调查报告

截至目前有超过了 5000 人参与了(该次调查)，准确的说是 5350 人。我迫不及待的想要和大家分享一下这次调查的细节。在分享之前我想要感谢参与调查的每一个人。这是 JavaScript 社区一个伟大的时刻，我对未来的事情感到无比激动。

我没有想到大家如此积极，下一次我一定会对版式做一些改进。换句话说，就是我会先将问卷调查放到 [Github](https://github.com/) 上，以便于在开始调查之前，社区有一到两周的时间来收集改进问题和选项。这样，我就可以得到更精确的结果，也可以避免出现诸如 "我很震惊你竟然没有包含 Emacs" 这样的抱怨。

现在，基于调查结果。我将保持中立的态度发表一下调查结果，这样你就可以得出自己的公正的结论。

## 你写什么类型的 JavaScript？

有高达 97.4% 的受访者用 JavaScript 写 web 浏览器程序，其中有 37% 的受访者写移动端 web 程序。超过 3000 人(56.6%) 也写服务端的 JavaScript。在这些参与调查者的人中间，有 5.5% 的人还在一些嵌入式环境中使用 JavaScript，例如 Tessel 或 a Raspberry Pi (树莓派)。

少数参与者表示他们也在其他一些地方使用 JavaScript，尤其是在开发 CLI 和桌面应用方面。还有少数提到了 Pebble 和 Apple TV. 这些都归类在 **Other(其他)** 一类中，占总票数的 2.2%。

![An screenshot of the percentages for the first question](https://i.imgur.com/c0q4LvI.png)

## 你在哪里使用 JavaScript？

不出所料地，有 94.9% 的参与者在工作中使用 JavaScript，但是，统计中也有很大一部分(占总票数的 82.3%) 参与者也在其他项目中使用。其他的回复则包括了教学，好玩，和非盈利目的的使用。

![An screenshot of the percentages for the second question](https://i.imgur.com/K5nSsyr.png)

## 你写 JavaScript 多长时间了？

超过 33% 的受访者表示他们写 JavaScript 代码已经超过了 6 年时间。除了这些人之外，有 5.2% 的人一年前开始写 JavaScript 代码，12.4% 的人是两年前，还有 15.1% 的人是三年前。这说明在 5350 个投票者中，有 32.7% 的人是在近几年才开始写 JavaScript 的。

![An screenshot of the percentages for the third question](https://i.imgur.com/P5ev9fL.png)

## 如果可以的话，你使用哪种 compile-to-JavaScript(编译为 JavaScript 的) 语言？

有高达 **85%** 的受访者表示他们使用 ES6 编译成 ES5。与此同时，有 15% 的人仍然使用 `CoffeeScript`，15.2% 的人使用 `TypeScript`，只有区区 1.1% 的人使用 `Dart`。

这是我想进一步探讨的问题之一，因为有 13.8% 的人选择了 _“Other(其他)”_，选择 _“Othe(其他)”_ 的绝大部分的回答是 `ClojureScript`, `elm`, `Flow`, 和 `JSX`。

![An screenshot of the percentages for the fourth question](https://i.imgur.com/12mL6u6.png)

## 你更喜欢哪一种 JavaScript 编程风格？

回答这个问题的绝大多数开发者(79.9%)都选择了分号。相反，有 11% 的开发者指出更喜欢不使用分号。

逗号方面，44.9% 的开发者喜欢将逗号放在表达式的末尾，然而有 4.9% 的开发者喜欢先写逗号。

缩进方面，65.5% 的开发者更喜欢使用空格，然而有 29.1% 的开发者则更喜欢使用制表符(Tab)。

![An screenshot of the percentages for the fifth question](https://i.imgur.com/xwFVmS1.png)

## 你使用过 ES5 的哪些特性？

79.2% 的受访者都使用过 `Array(数组)` 的一些实用的方法，76.3% 的开发者使用严格模式。30% 的开发者使用 `Object.create`，而使用过 getters 和 setters 的开发者仅占了 28%.

![An screenshot of the percentages for the sixth question](https://i.imgur.com/W9pUOua.png)

## 你使用过 ES6 的哪些特性？

显然，在这些投票中，箭头函数是使用最多的 ES6 特性，占了 79.6%。在所有调查者中，Let 和 const 加在一起一共占了 77.8% 。promises 也有 74.4% 的开发者采用。不出所料，只有 4% 的参与者使用 proxies，只有 13.1% 的用户表示他们使用 symbols，同时有超过 30% 的人说他们使用 iterators。

![An screenshot of the percentages for the seventh question](https://i.imgur.com/okcvuos.png)

## 你写测试么？

有 21.7% 的开发者表示他们从不写任何测试。大部分人偶尔写一些测试。34.8% 的人总是写测试。

![An screenshot of the percentages for the eighth question](https://i.imgur.com/0C944YL.png)

## 你运行持续集成测试吗？

和 CI 类似，尽管许多人(超过40%)不使用 CI 服务器，但是差不多有 60% 的人表示在少数时间会使用 CI，其中有 32% 的人总是在 CI 服务器上运行测试代码。

![An screenshot of the percentages for the ninth question](https://i.imgur.com/P04bJHG.png)

## 你怎么运行测试代码？

59% 的开发者喜欢使用 PhantomJS 或是类似的工具来运行自动化浏览器测试。也有 51.3% 的开发者喜欢在 web 浏览器上手动运行测试。有 53.5% 的投票者会在服务器端进行自动化测试。

![An screenshot of the percentages for the tenth question](https://i.imgur.com/v09gVdQ.png)

## 你使用过哪个单元测试库？

似乎大部分投票者都使用 Mocha 或是 Jasmine 来运行他们的 JavaScript 测试用例。而 Tape 收到了 9.8% 的选票。

![An screenshot of the percentages for the eleventh question](https://i.imgur.com/20nUzJu.png)

## 你使用过哪个代码质量检测工具？

看起来受访者在 ESLint 和 JSHint 之间分成了两派，但是 JSLint 还是有差不多 30% 的投票率，在这么多年之后势头还是惊人的强劲。

![An screenshot of the percentages for the 12th question](https://i.imgur.com/RC8ePwr.png)

## 你通过哪种方式来处理客户端依赖关系？

npm 接管了客户端依赖管理系统的天下，有超过 60% 的投票就是证明它的方式。Bower 仍然有 20% 的观众，而通过下载和插入 `<script>` 标签来管理的普通旧式方法则获得了 13.7% 的选票。

![An screenshot of the percentages for the 13th question](https://i.imgur.com/TOQiSZP.png)

## 你首选的脚本构建方案是什么？

构建工具的选择很分散，部分原因是有太多的不同的选项可供选择。Gulp 最流行，有着超过 40% 的选票，紧接着的是使用 `npm run`，有 27.8%。Grunt 得到了 18.5% 的支持者。

![An screenshot of the percentages for the 14th question](https://i.imgur.com/xXlEE3E.png)

## 你首选的 JavaScript 模块加载工具是什么？

目前，看起来大部分开发者都在 Browserify 和 Webpack 之间徘徊，而后者高出了 7 个百分点。29% 的用户表示他们在使用前面提到的这两个工具打包他们的模块之前会先使用 Babel 进行转换。

![An screenshot of the percentages for the 15th question](https://i.imgur.com/pQPMC7V.png)

## 你使用过哪些库？

现在回顾起来，这是一个受益于协同编辑的问题之一。jQuery 获得了超过 50% 的选票证明了它的势头依然很强劲。在参与投票的 JavaScript 使用者中，Lodash 与 Underscore 也被很大一部分开发者使用。 `xhr` 微型库只获得了 8% 的票数。

![An screenshot of the percentages for the 16th question](https://i.imgur.com/7jAwy05.png)

## 你使用过哪些框架？

毫无意外地，React 和 Angular 遥遥领先于其他框架，有着 22.8% 的 Backbone 仍然处在一个安全的位置。

![An screenshot of the percentages for the 17th question](https://i.imgur.com/zpSAISK.png)

## 你使用 ES6 吗？

受访者在这个问题上的反应相当分歧，有近 20% 的人几乎从不使用 ES6，超过 10% 的人只写 ES6，接近 30% 的人广泛使用 ES6，近 40% 的人偶尔使用。

![An screenshot of the percentages for the 18th question](https://i.imgur.com/hAnbtfN.png)

## 你知道在即将到来的 ES2016 中会有什么特性吗？

粗略地说，有超过一半的投票者表示不知道即将到来的 ES2016 中会有什么特性。另一半则对接下来的版本有所了解。

![An screenshot of the percentages for the 19th question](https://i.imgur.com/DxxOnco.png)

## 你了解 ES6 吗？

超过 60% 的受访者似乎了解基本的概念。10% 的人对 ES6 毫不了解，有 25% 的受访者认为他们非常了解 ES6。

![An screenshot of the percentages for the 20th question](https://i.imgur.com/w6obK3X.png)

## 你认为 ES6 是一个进步吗？

超过 95% 的受访者认为 ES6 是对于 JavaScript 语言来说是一个进步，下一次碰到 TC39 的会员我得祝贺他们。

![An screenshot of the percentages for the 21th question](https://i.imgur.com/c0RtfVK.png)

## 你更喜欢什么文本编辑器？

再一次，由于存在各种各样的选择导致结果非常分散。超过一半的受访者喜欢 [Sublime Text](http://www.sublimetext.com/)，超过 30% 的受访者喜欢使用 [atom](https://atom.io/) 和 它的开源克隆版。超过 25% 的选票投给了 WebStorm，也有 25% 的选票投给了 vi/vim。

![An screenshot of the percentages for the 22th question](https://i.imgur.com/Vt8ve7s.png)

## 你更喜欢使用什么操作系统作为开发环境?

超过 60% 的投票者使用 Mac，使用 Linux 和 Windows 的用户都接近 20%。

![An screenshot of the percentages for the 23th question](https://i.imgur.com/PmLbtAo.png)

## 你是通过哪种方式搜索到可重用的代码、库和工具的？

受访者似乎更青睐于 [GitHub](https://github.com) 和搜索引擎，但是也有一部分人使用博客，Twitter 和 npm 网站。

![An screenshot of the percentages for the 24th question](https://i.imgur.com/HpmV9yz.png)

## 你参加过 JavaScript 的社交活动吗？

有近 60% 的人参加过至少一次，74% 的人表示他们喜欢参加聚会。

![An screenshot of the percentages for the 25th question](https://i.imgur.com/EnQWGzf.png)

## 在你的 JavaScript 应用中，你都支持哪些浏览器？

回答相当分散，但是好在大多数受访者表示他们不再处理使用 IE6 的客户(的问题)了。

![An screenshot of the percentages for the 26th question](https://i.imgur.com/BV3eU0X.png)

## 你会定期了解有关 JavaScript 的最新特性吗？

有 80% 的受访者会尝试实时了解并持续学习 JavaScript 的最新特性。

![An screenshot of the percentages for the 27th question](https://i.imgur.com/5TZUW2i.png)

## 你在哪了解最新的 JavaScript 特性？

不出所料地，[Mozilla 开发者网络](https://developer.mozilla.org/) 在 JavaScript 文档和新闻方面处于领先地位。[JavaScript 周刊](http://JavaScriptweekly.com/) 也是一个非常受欢迎的新闻和文章的直接来源，它有着超过 40% 的投票。

![An screenshot of the percentages for the 28th question](https://i.imgur.com/7Jlg7zh.png)

## 你听说过下面哪些新特性？

超过 85% 的人听说过 ServiceWorker，我很想知道这些人中有多少人使用过它。

![An screenshot of the percentages for the 29th question](https://i.imgur.com/8o3Jq2R.png)

## 除了 JavaScript，你还主要使用哪些语言？

这有太多的语言可供选择，我肯定会漏掉一些。但是结果不言自明。

![An screenshot of the percentages for the 30th question](https://i.imgur.com/Tv9NciV.png)

## 谢谢

最后，我想感谢参与此次调查的每一个人。这次调查的受欢迎程度超出了我的预期，我很期待明年再进行一次类似的调查。我希望，那将会是一个更多样性的，也许会再少一点倾向性的调查。

> 你从这次调查中获得了什么呢？
