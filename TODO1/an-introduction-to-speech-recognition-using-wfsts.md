> * 原文地址：[An Introduction to Speech Recognition using WFSTs](https://medium.com/explorations-in-language-and-learning/an-introduction-to-speech-recognition-using-wfsts-288b6aeecebe)
> * 原文作者：[Desh Raj](https://medium.com/@rdesh26)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/an-introduction-to-speech-recognition-using-wfsts.md](https://github.com/xitu/gold-miner/blob/master/TODO1/an-introduction-to-speech-recognition-using-wfsts.md)
> * 译者：[sisibeloved](https://github.com/sisibeloved)
> * 校对者：[xionglong58](https://github.com/xionglong58), [JackEggie](https://github.com/JackEggie)

# 使用 WFST 进行语音识别

> 之前，我的博客文章都是关于深度学习方法或者它们在 NLP 中的应用。而从几周前，我开始研究自动语音识别（ASR）。因此，我现在也会发布一些语音相关的文章。

ASR 的逻辑非常简单（就是贝叶斯理论，如同机器学习领域的其它算法一样）。本质上，ASR 就是对给定的语音波形进行转换，比如识别与波形对应的文本。假设 **Y** 表示从波形中获得的特征向量（注意：这个“特征提取”本身是一个十分复杂的过程，我将在另一篇文章中详述），**w** 表示任意字符串的话，可以得出以下公式：

![](https://cdn-images-1.medium.com/max/2000/0*EaatvWv4ULPPU2ps.)

公式中的两个似然率是分开训练的。第一个分量，称为**声学建模**，使用包含话语和语音波形的平行语料库进行训练。第二个分量，称为**语言建模**，通过无监督的方式从大量文本中进行训练。

虽然 ASR 训练从抽象层面看起来很简单，但实现它的实现却远要复杂得多。我们通常会使用加权有限状态转换机（WFST）来实现。在这篇文章中，我将介绍 WFST 及其基础算法，并简要介绍如何将它用于语音识别。

### 加权有限状态转换机（Weighted Finite State Transducer，WFST）

如果你之前上过计算机理论课程（译者注：大多数人可能是在编译原理这门课上学的），你可能已经了解了**自动机**的概念。从概念上来说，有限自动机接受一种语言（一组字符串）作为输入。它们由有向图表示，如下所示。

![](https://cdn-images-1.medium.com/max/2000/0*tEJQn7jtZ0ZjUAge.gif)

每个自动机由一个开始状态，一个或多个最终状态，以及用于连接状态的带有标号的边组成。如果字符串在遍历图中的某个路径后以最终状态结束，则接受该字符串。例如，在上述 DFA（deterministic finite automata，确定有限状态自动机）中，**a**、**ac** 和 **ae** 会被接受。

因此**接受器**将任何输入字符串映射成二进制类 {0,1}，具体取决于字符串是否被接受。而**转换机**在每条边上有 2 个标签 —— 输入标签和输出标签。**加权**状态转换机，则更进一步，具有对应于每个边和每个最终状态的权重。

![](https://cdn-images-1.medium.com/max/2000/0*1_8DJQb7LgH1abja.png)

因此，WFST 是从字符串对到权重和的映射。该字符串对由沿着 WFST 的任何路径的输入/输出标签形成。对于图中不可达的节点对，对应边的权重是无穷大。

实际上，绝大部分语言都有对应的实现 WFST 的库。在 C++ 中，[OpenFST](http://www.openfst.org/twiki/bin/view/FST/WebHome) 是个较为流行的库，在 [Kaldi 语音识别工具](http://kaldi-asr.org/)中也有用到。

原则上，我们可以不使用 WFST 实现语音识别算法。但是，这种数据结构具有[多种经过验证的结果](https://cs.nyu.edu/~mohri/pub/csl01.pdf)和算法，可直接用于 ASR，而无需担心正确性和复杂度。这些优点使得 WFST 在语音识别中几乎无可匹敌。接下来我会总结 WFST 上的一些算法。

## WFST 中的基础算法

### 合并

顾名思义，合并是指将 2 个 WFST 组合形成单个 WFST 的过程。如果我们有发音和单词级语法的转换机，这种算法将使我们能够轻松地搭建一个语音转文字的系统。

合并遵循以下 3 个原则：

1. 将原先的 WFST 的初始状态结合成对，形成新 WFST 的初始状态。
2. 类似地，将最终状态结合成对。
3. 如果存在第一个 WFST 的输出标签等于第二个 WFST 的输入标签这种情况，从起点对添加一条边到终点对。边的权重为原始权重之“和”。

以下是一个合并示例：

![](https://cdn-images-1.medium.com/max/2000/1*BFg7_P5AfZH-gAywtKkXxQ.png)

对于边的权重来说，“总和”的定义很重要。借助于[半环](https://en.wikipedia.org/wiki/Semiring)的概念，WFST 可以接受广义上的“语言”。从基本概念上来讲，它是一组具有 2 个运算符的元素，即 ⊕ 和 ⊗。根据半环的类型，这些运算符可以有不同的定义。例如，在热带半环中，⊕ 表示取最小值，⊗ 表示相加。此外，在任意 WFST 中，一整条路径的权重之和等于沿路径的各条边的权重相 ⊗（注意：对于热带半环来说这里的“相乘”意味着相加），多条路径的权重之和等于具有相同的符号序列的路径相 ⊕。

[这里](http://www.openfst.org/twiki/bin/view/FST/ComposeDoc)是 OpenFST 中对于合并的实现。

### 确定化

确定自动机是每个状态中每种标签只有一个转移的自动机。通过这样的表达式，确定化的 WFST 消除了所有冗余并大大降低了基础语法的复杂性。那么，是不是所有 WFST 都可以确定化呢？

**孪生属性**：假设有一个自动机 A，A 中有两个状态 **p** 和 **q**。如果 **p** 和 **q** 都具有相同的字符串输入 **x**，并有相同标签的循环 **y**，则称 **p** 和 **q** 为兄弟状态。从概念上讲，到该状态为止的路径（包括循环在内）的总权重相等，则这两个兄弟状态是孪生的。 

> 当所有兄弟状态是孪生的时，这个 WFST 是可以被确定化的。

这是我之前所说的关于 WFST 是 ASR 中使用的算法的有效实现的一个例子。有几种方法可以确定化 WFST。其中一种算法如下所示：

![](https://cdn-images-1.medium.com/max/2000/1*ArXaKyN2_YiarDX46tPAAQ.png)

该算法简化后的步骤如下：

* 在每个状态下，对于每个输出标签，如果该标签有多个输出边，则将其替换为单个边，其权重为包含该标签的所有边的权重的 ⊕ 总和。

由于这是一种本地算法，因此可以高效地在内存中实现。要了解如何在 OpenFST 中进行确定化，请参阅[此处](http://www.openfst.org/twiki/bin/view/FST/DeterminizeDoc)。

### 最小化

尽管最小化不如确定化那样重要，但它仍然是一种很好的优化技术。它用于最小化确定的 WFST 中的状态和转移的数量。

最小化的步骤分为两步：

1. 权重推移：所有权重都被推往开始状态。请参阅以下示例。

![](https://cdn-images-1.medium.com/max/2000/1*0Hp5qXMWHsyvvFGfLz03vQ.png)

2. 完成此操作后，我们将到最终状态的路径相同的状态组合。例如，在上述 WFST 中，状态 1 和 2 在权重推移后变得相同，因此它们被组合成了一个状态。

在 OpenFST 中，可以在[这里](http://www.openfst.org/twiki/bin/view/FST/MinimizeDoc)找到最小化的具体实现。

下图（来自<sup><a href="#note1">[3]</a></sup>）展示了 WFST 优化的完整流程：

![](https://cdn-images-1.medium.com/max/2000/1*dNGFwfEMWqiVxNKRNjV5MA.png)

### WFST 在语音识别中的应用

在语音识别中，多个 WFST 会被串行组合，顺序如下：

1. 语法（**G**）：使用大型语料库训练的语言模型。
2. 词汇表（**L**）：用于将不包含上下文的语音的似然度的信息编码。
3. 依赖上下文的语音处理（**C**）：类似 n 元语言模型，唯一的不同点是它作用于语音处理。
4. HMM 架构（**H**）：用于处理波形的模型。

总体上，将转换机按 **H** o **C** o **L** o **G** 组合可以表示完整的语音识别的流程。其中每个部分都可以单独改进，从而改善整个 ASR 系统。

**WFST 是 ASR 系统的重要组成部分，这篇文章只是简要地对 WFST 作了介绍。在其它与语音相关的帖子中，我会讨论诸如特征提取，流行的 GMM-HMM 模型和最新的深度学习进展之类的事情。我也在阅读[这些](http://jrmeyer.github.io/asr/2017/04/05/seminal-asr-papers.html)论文，以便更好地了解 ASR 多年来的发展历程。**

## 参考文献

* [1] Gales、Mark 和 Steve Young 著《隐马尔可夫模型在语音识别中的应用》，Foundations and Trends® in Signal Processing 1.3 (2008): 195–304.
* [2] Mohri、 Mehryar、Fernando Pereira 和 Michael Riley 著《语音识别中的加权有限状态机》，Computer Speech & Language 16.1 (2002): 69–88.
* <a name="note1"></a>[3] 江辉教授（约克大学）的[课堂讲义](https://wiki.eecs.yorku.ca/course_archive/2011-12/W/6328/_media/wfst-tutorial.pdf)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
