> * 原文地址：[Refactoring -- Not on the backlog!](http://ronjeffries.com/xprog/articles/refactoring-not-on-the-backlog/)
* 原文作者：[Ron Jeffries](http://ronjeffries.com/about.html)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[rottenpen](https://github.com/rottenpen)
* 校对者：[Luoyaqifei](http://www.zengmingxia.com/)   [cyseria](https://github.com/cyseria)

# 重构，不要积压！

最近有很多关于重构的讨论或问题出现在清单和会议上，这些讨论和问题围绕着是否要将重构的“故事”放入积压工作中。即使“技术债”变多，这还是一个毋庸置疑的坏主意。原因如下：
[![Ref01](http://ronjeffries.com/xprog/wp-content/uploads/Ref01-1024x768.jpg)](http://ronjeffries.com/xprog/wp-content/uploads/Ref01.jpg)

项目开始的时候，代码是空白的。工作的区域平坦干净，生活是美好的，这个世界是属于我的。一切看起来都那么美好。
[![Ref02](http://ronjeffries.com/xprog/wp-content/uploads/Ref02-1024x768.jpg)](http://ronjeffries.com/xprog/wp-content/uploads/Ref02.jpg)

我们可以轻松顺利地建立起功能，哪怕我们似乎总会遇到一些波折。除了有点匆忙，一切看起来都是那么完美。我们不会注意到任何弊漏而且会迅速地让新功能上线。
[![Ref03](http://ronjeffries.com/xprog/wp-content/uploads/Ref03-1024x768.jpg)](http://ronjeffries.com/xprog/wp-content/uploads/Ref03.jpg)

然而，我们就让一些灌木丛生长在我们近乎完美的代码中。有时人们称之为 “ 技术债务 ”。但这些灌木丛只不过不是很好的代码，其实它们看起来也不是太糟糕。
[![Ref04](http://ronjeffries.com/xprog/wp-content/uploads/Ref04-1024x768.jpg)](http://ronjeffries.com/xprog/wp-content/uploads/Ref04.jpg)

正如我们画的图，我们不得不绕过这些灌木丛，或者推开它们。通常我们会绕道而行。
[![Ref05](http://ronjeffries.com/xprog/wp-content/uploads/Ref05-1024x768.jpg)](http://ronjeffries.com/xprog/wp-content/uploads/Ref05.jpg)

不可避免的是，这会减慢我们的速度。为了保持速度，我们甚至会比以前更粗心，灌木丛自然而然越冒越多了。
[![Ref06](http://ronjeffries.com/xprog/wp-content/uploads/Ref06-1024x768.jpg)](http://ronjeffries.com/xprog/wp-content/uploads/Ref06.jpg)

新的灌木丛堆在旧的灌木丛上，严重放慢了我们的进程。我们意识到这个问题，但我们太急于抵达终点。我们迫切地想要保持我们早期的速度。
[![Ref07](http://ronjeffries.com/xprog/wp-content/uploads/Ref07-1024x768.jpg)](http://ronjeffries.com/xprog/wp-content/uploads/Ref07.jpg)

不久以后，我们工作中有一半的代码背负着应付杂草、灌木丛、矮树丛和各类障碍。甚至可能有一些旧罐头和脏衣服藏在某处。也许还会遇到一些坑。
[![Ref08](http://ronjeffries.com/xprog/wp-content/uploads/Ref08-1024x768.jpg)](http://ronjeffries.com/xprog/wp-content/uploads/Ref08.jpg)

每趟穿越混乱代码区域的旅程都变成了一场躲避灌木丛、避免踩到坑的长途跋涉。然而，我们还是会掉进其中的一些坑里，然后爬出来。我们会比之前更慢。这时候我们必须要改变。
[![Ref09](http://ronjeffries.com/xprog/wp-content/uploads/Ref09-1024x768.jpg)](http://ronjeffries.com/xprog/wp-content/uploads/Ref09.jpg)

现在我们的问题非常明显，我们看到，我们不能只是在该领域快速地掠过，只做好自己的事。我们还有很多的重构要做，来恢复一片干净的领域。我们不禁要向产品负责人索取重构的时间。这种索求往往是不被允许的。不会有人愿意为我们过去所搞砸的东西背锅。
[![Ref10](http://ronjeffries.com/xprog/wp-content/uploads/Ref10-1024x768.jpg)](http://ronjeffries.com/xprog/wp-content/uploads/Ref10.jpg)

如果我们真的有那个时间，我们也不会得到一个相当好的结果。我们会在可用的时间里，尽我们所能地整理我们所理解的东西，尽管这时间永远不够用。尽管我们花了几个星期来把代码弄得那么糟糕，可是我们肯定不会再去花几个星期把它修改好。

这是一个死胡同。一个巨大的重构 session 是很难出售的，即使卖了，经过长时间的延迟，我们也不会得到我们所期待的回报。这不是一个好主意。我们应该做些什么呢？
[![RefA1](http://ronjeffries.com/xprog/wp-content/uploads/RefA1-1024x768.jpg)](http://ronjeffries.com/xprog/wp-content/uploads/RefA1.jpg)

太简单了！我们要求下一个功能按我们的需求而建造，而不是绕开周围的杂草和灌木。我们花时间清理出一条路来。可能我们也会绕开一些障碍。因为我们只是改进需要使用到的代码，忽略掉没被使用的部分。我们得到了一个干净的工作环境。很可能，我们还会再次访问这个地方：这就是软件开发工作。

也许这个功能需要更多的时间去建设。但通常它不会，因为通过清除可以帮助到我们，哪怕是第一个功能。当然，它也将帮助到任何其他人。 
[![RefA2](http://ronjeffries.com/xprog/wp-content/uploads/RefA2-1024x768.jpg)](http://ronjeffries.com/xprog/wp-content/uploads/RefA2.jpg)

反复清理。每当出现一个新功能，我们就要清洗一遍这片代码区域。在产生垃圾的同时，我们只需要投资多一点时间，不需要多，通常很少。特别是随着过程的推移，从我们清理开始，我们的优势会越来越明显，进程会变得越走越快。
[![RefA3](http://ronjeffries.com/xprog/wp-content/uploads/RefA3-1024x768.jpg)](http://ronjeffries.com/xprog/wp-content/uploads/RefA3.jpg)

很快，通常在我们开始清理的这个迭代周期内，我们能发现后续功能正使用了之前刚清理的这块区域。我们开始从增量重构中得到好处了。如果我们等着在一个大批次进行重构的话，我们需要付出更多努力，任何好处都会被延迟，而且很可能会无功而返。

工作变的更好，代码变得更干净，提供的功能比以前更多。各个方面都得到了显著的提高。 

这事你就这么办吧。


