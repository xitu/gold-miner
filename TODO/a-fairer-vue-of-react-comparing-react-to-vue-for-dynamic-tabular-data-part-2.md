>* 原文链接 : ["A fairer Vue of React" - Comparing React to Vue for dynamic tabular data, part 2.](https://engineering.footballradar.com/a-fairer-vue-of-react-comparing-react-to-vue-for-dynamic-tabular-data-part-2/)
* 原文作者 : [Max Willmott](https://engineering.footballradar.com/author/max-willmott/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [wildflame](https://github.com/wildflame)
* 校对者:[hikerpig](https://github.com/hikerpig), [JolsonZhu](https://github.com/JolsonZhu), [godofchina](https://github.com/godofchina)

# 较为完整的 React.js / Vue.js 的性能比较 Part 1

_有关第一部分的文章，请访问 [https://engineering.footballradar.com/from-a-react-point-of-vue-comparing-reactjs-to-vuejs-for-dynamic-tabular-data/](https://engineering.footballradar.com/from-a-react-point-of-vue-comparing-reactjs-to-vuejs-for-dynamic-tabular-data/) 。第一篇文章的实验结果已经被证明有错误，但是它为这篇文章奠定了基础。_

五月23日，周一，我们发布了一篇关于比较 React 和 Vue 的性能的文章，其实验数据比较了二者谁更适合处理频繁更新的列表数据，特别是在对性能要求非常高的情况下。比方说我们手头上的一个足球雷达（Football Radar）的项目。

最初我们对实验结果信心满满，但发现几个较为重要的错误后，才知道实验结果并非像我们预期的那样。我们非常感谢在 React 和 Vue 社区里的宝贵意见 —— 特别是 React 的核心工程师克里斯托弗(Christopher Chedeau) ([@vjeux](https://twitter.com/vjeux))，和 Vue 的创始人尤雨溪([@youyuxi](https://twitter.com/youyuxi))—— 因为你们，我们才能快速的锁定这次测试中的出现的问题，可以说是因祸得福，因为尽管错误被公开使我感到有一些小小的尴尬，但我的确学到了很多，所以衷心的感谢你们的讨论。

鉴于我们已为第一篇文章做了许多改进，不能否定还有进一步改进的余地，因此这篇文章比起来，更像是一篇游记，而不是一个全面完善的结果。

这里首先，我想重申一下这次实验的目的，然后讲一下我们所犯的错误 —— 掌声送给那些帮助我们改正错误的人 —— 最后我会公布更新的更公正的测试结果。

## 测试

这个实验的输出是一组足球比赛，每一个都一秒更新一次数据。在实验中，为了测试性能及可拓展性，我们会修改两组独立的数据：足球比赛数量和每次更新之间的延迟。

![](http://ac-Myg6wSTV.clouddn.com/5be4086d861ed7351bab.png)

为了模拟页面加载情况及测量其可扩展性，我们分别使用 Vue 和 React 测试了50，100，500场比赛，其延迟分别是100ms，1s，然后看其可拓展性如何。

我们的第一次结果不太客观，显示 Vue 的性能表现比 React 要好很多，其实是因为测试运行在开发模式（Development Mode），而这个疏忽直接造成了结果偏差。感谢克里斯多弗（@Christopher）提出这个问题：[https://github.com/footballradar/VueReactPerf/pull/3](https://github.com/footballradar/VueReactPerf/pull/3)。在生产模式（Production Mode）运行 React 忽略了一些消耗资源较大的进程，包括了 prop-types 的检查和警告。尽管这是一个非常明显的优化，但由于 React 默认运行在开发模式，所以这个优化很容易被忽略掉。我们要强调的是 Vue 也是运行在开发模式的，二者都同样被影响到了。那篇 pull-request 里接下来的相关讨论都非常醍醐灌顶。

我们也用了一些无效的测试数据，这使得 Vue 比起 React 在同等条件下快了10倍。在我们的测试中，两个框架都具有相同的测试数据。但是 Github 上的 pull-request 里的那个版本并没有确保这点一致性，所以其他测试的人也许会看到这个具有误导性的结论。

## 与上一个测试相比的改变

*   在[生产模式](https://github.com/footballradar/VueReactPerf/pull/3)下运行。
*   添加了 `webpack.optimize.UglifyJsPlugin` 
*   添加了 [babel-react-optimize preset](https://github.com/thejameskyle/babel-react-optimize)

## 新发现

以下是部分的开发者工具 timeline 的概要，在下面的这个项目里有实际的栈和 timeline 的截图：[[https://github.com/footballradar/VueReactPerf/tree/master/results/v2](https://github.com/footballradar/VueReactPerf/tree/master/results/v2)

有意思的是，Chrome 的开发工具在获取 Vue 的 500 场比赛测试结果的 30s 时间线时崩溃了，但 React 的 500 场比赛测试却没有。我们截取了 15s 的结果以取代它，但是让人不解的是，Vue 相比于 React，其实有更多的空闲时间。

所有下面的结果都共享同一个主题：由于 React 的虚拟 Dom 的实现，它的 scripting 上运行的时间更长；Vue 由于要直接更改 Dom ，所以它有关在 painting 和 rendering 工作上更耗费资源。然而，所有工作都做完以后，Vue 在大多数情况下仍然比 React 快25%。这虽然不同于我们最初的巨大区别，仍然是一个值得关注的问题。

##### 50 场比赛，100ms 的延迟
React:  
![](http://ww2.sinaimg.cn/large/a490147fgw1f4mtuj37onj207f04l74d.jpg)

Vue:  
![](http://ac-Myg6wSTV.clouddn.com/29bf60c3f146eab2c6dc.png)
##### 50 场比赛，1s的延迟
React:  
![](http://ac-Myg6wSTV.clouddn.com/b0b15f794c9a2070a533.png)

Vue:  
![](http://ac-Myg6wSTV.clouddn.com/f6d6c16641bcdbfdc6cb.png)
##### 100 场比赛，100ms 的延迟
React:  
![](http://ac-Myg6wSTV.clouddn.com/72c40b5122614ecb66af.png)

Vue:  
![](http://ac-Myg6wSTV.clouddn.com/239e96ce2a5037dd7a9a.png)
##### 100 场比赛，1s 的延迟
React:  
![](http://ac-Myg6wSTV.clouddn.com/902c1fe2a6c6d5d9671f.png)

Vue:  
![](http://ac-Myg6wSTV.clouddn.com/5490fb9635b763d94c05.png)
##### 500 场比赛，100ms 的延迟
React:  
![](http://ac-Myg6wSTV.clouddn.com/352538cf119141efb387.png)

Vue:  
![](http://ac-Myg6wSTV.clouddn.com/20251f4ab6a45b138669.png)
##### 500 场比赛，1s 的延迟
React:  
![](http://ac-Myg6wSTV.clouddn.com/04278f218752b89c2042.png)

Vue:  
![](http://ac-Myg6wSTV.clouddn.com/f6095bbea3543f55a175.png)

## 结论

总的来说，最初那个 Vue 比 React 表现好的结论在_这个用例_上仍然是有价值的，但是明显还有很多可以优化的地方，特别是 React。一个附带的结论是是，需要多少的工作和相关知识，才能提高 React 的性能，而 Vue 在开箱即用的情况下就优化的很好。但不管我们说些什么，Vue 的开发者体验毫无疑问是更棒的。
