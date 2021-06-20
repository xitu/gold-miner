> * 原文地址：[A Layman’s Intro to Quantum Computers](https://betterprogramming.pub/a-laymans-intro-to-quantum-computers-67b7a7126695)
> * 原文作者：[David Mooter](https://medium.com/@davidmooter)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/a-laymans-intro-to-quantum-computers.md](https://github.com/xitu/gold-miner/blob/master/article/2021/a-laymans-intro-to-quantum-computers.md)
> * 译者：[PingHGao](https://github.com/PingHGao)
> * 校对者：

# 外行说量子计算机

![照片由 [Zoltan Tasi](https://unsplash.com/@zoltantasi?utm_source=medium&utm_medium=referral) 发布于 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/9792/0*FPUtmaqNJ12IcZx8)

量子计算机具有彻底改变信息技术的潜力。许多分析师认为当前的量子计算机还处于初级阶段，与 1940 年代房间大小的计算机一样。在接下来的几十年里，它们可能会以与经典计算机相同的指数速度发展。不幸的是，关于量子计算的文献通常是**由**内行人（拥有物理学学位的人）**写给**内行人看的。在这里，我将用通俗的语言解释量子计算：它是如何工作的，它与经典计算有何不同，以及为什么它是革命性的。

## 经典比特 vs 量子比特

经典计算机有一个由经典比特组成的内存，其中每个比特都有两种状态，表示 “0” 或 “1” 。随着你使用的比特数越来越多，你可以存储更多的信息。

例如，对于两个比特，你有四种可能的状态：“00 01 10 11”。使用三个比特，你有八种可能的状态：“000 001 010 011 100 101 110 111”。

从物理角度理解，这些经典比特可以看做是电流，其中 “0” 和 “1” 代表流过它们的电流的不同大小。

量子计算机维持着一系列的量子比特，每个量子比特也有两种状态，可以用 “0” 或 “1” 表示。然而，这些量子比特并不是电流。相反，它们是固定在一个地方的亚原子粒子 —— 固定不动。它们通过各种方式来表示 “0” 或 “1”，具体取决于量子计算机的类型，但这一细节对于理解它们的用途来说并不重要。

与经典比特不同，当你测量量子比特时，并不总是能得到相同的结果。相反，量子比特的状态可以被认为是在一个球体的表面上。北极和南极分别代表最终状态 “0” 和 “1”。当量子比特的状态更接近北极点时，它表示在测量时进入 “0” 状态的几率更高，以此类推。例如，位于赤道上的量子比特有一半的的机会走向任一方向。在测量下图中的量子比特时，由于离北极更近，它出现 “0”（北）的几率明显高于 “1”（南）。

![将量子比特的状态表示为球体表面上的一个点。图片来源：作者。](https://cdn-images-1.medium.com/max/2000/1*6ek0KRvlg8Q22Bs0vij9YA.png)

## 第一个区别：确定的状态 vs 概率的状态

这给我们带来了与经典计算机的第一个区别。经典比特对应明确的 “0” 或 “1”。相比之下，一个量子比特对应成为 “0” 或 “1” 的**概率**。例如，如果一个量子比特有 60% 的概率成为 “1”，那么你可以将其视为存储着 “60%” 这个值。通过重复多次量子计算并观察结果，你可以在一定程度上确定该概率是多少。因此，它可以存储从 0 到 1 的无限数量的值，但代价这一结果始终具有某种程度的统计不确定性。量子算法通常是概率性的，因为它们提供的结果的正确性在某个已知的置信概率内。相比之下，经典计算机的本质是确定性的，可以完全确定的输出一个答案。任何计算机科学家都知道，让经典计算机真正随机化是相当困难的，因为它们非常倾向于给出确定性的答案。

## 经典逻辑门 vs 量子逻辑门

计算机通过各种逻辑门来进行运算。这些们通常需要两个输入，有时也只需要一个，并根据这些输入输出一个新值。例如，对于“与”们来说，如果两个输入是 “1”，其输出也是 “1”；否则它输出 “0”。下面展示了两个逻辑门：

![两个经典的逻辑门。图片来源：作者。](https://cdn-images-1.medium.com/max/2000/1*nnCAiy_9xEhyqQwmToybyw.png)

量子计算机使用量子门对其量子比特进行运算。这些计算让量子比特围绕球体表面移动，这意味着输入和输出是同一个量子比特的不同状态。例如，一个量子门可能会将量子比特翻转到球体的另一部分或围绕其轴之一旋转。有些门接受一个输入。有些门需要两个或更多，此时每个输入的状态影响所有输出状态。在下图中，我们看到之前的量子比特在被量子门围绕其垂直轴旋转。

![量子门使量子比特在球面上移动。图像来源：作者。](https://cdn-images-1.medium.com/max/2000/1*UsZeojy60miuuh5Wmd1tOg.png)

## 第二个区别：十分不同的逻辑门

经典计算机的门在输出一个新比特的同时并不会改变其输入比特。而量子计算机的门直接改变其输入量子比特的状态，并不创造新的量子比特。此外，所有量子门都是可逆的，但并非所有经典门都是可逆的（见上图的两个门 —— 不是总能从输出推断输入）。最后，数学家已经证明，所有经典的逻辑门都可以使用量子门的组合来创建，但有些量子门不能由经典门创建。换句话说，量子门开启了经典计算机无法做到的新操作。这意味着创造新算法的潜力。

## 量子纠缠

两个或多个量子比特可能会纠缠在一起。这意味着测量一个量子比特会立即影响其他量子比特，即使它们深处宇宙的两侧。一个简单的例子是，如果你有两个量子比特，观察一个会导致另一个在观察时总是产生相反的结果。另一种可能是观察一个量子比特的结果会影响另一个量子比特变为 “0” 或 “1” 的概率。这提供了在整个数据系统上运行的算法，而不是一次一位。

## 第三个区别：比特之间的依赖性

一种理解方式是，两个纠缠的量子比特的状态不再相互独立。

下方的左图显示了两个未纠缠的量子比特 —— 蓝色的 A 和红色的 B。两者都有一半的机会变成 “0” 或 “1”。每种组合的几率是相同的：“00” 的几率为 25%，“01” 的几率为 25%，等等。知道 A 或 B 的值并不能告诉你另一个比特的任何信息。

在下方右图中，显示了两个纠缠的量子比特。在这种情况下，知道一个量子比特的值也能告诉你关于另一个量子比特的一些信息。如果你知道量子比特 B 为 “0”，那么你也知道量子比特 A 为 “1” 的可能性是 “0” 的两倍。但是如果你知道量子比特 B 是 “1”，那么你知道量子比特 A 一定是 “0” —— 它们不再是独立的。

![图片来源：作者。](https://cdn-images-1.medium.com/max/2000/1*aAorGuHgmX7o-HkKhEJkJg.png)

## 量子叠加

回想一下，当观察到一个量子比特时，会产生一个随机结果。你会直觉地认为量子比特在这两种状态之间振荡，就像硬币在空中翻转、正反交替，直到它落地才能知道最终结果。然而，实际上，一个量子比特同时是 “0” 和 “1”。这是因为存储量子比特信息的粒子可以同时具有不同的能量水平或位于不同的位置。当量子粒子与其他事物（例如测量其能量或位置的工具）相互作用时，它会随机“坍缩”到某个状态。

### 放下你的怀疑

我需要打断对叠加态的描述，并解决大多数人的主要绊脚石：难以置信或困惑。你现在的想法可能是，“一个东西怎么会同时出现在两个地方？这不可能！”

我向三位量子物理学博士提出了这个问题。其中一位回答说，你只需要停止怀疑，相信已有的数学和实验已经证明它是正确的。另外两人给出了比较满意的回答。我们生活的宏观世界与最微观层面发生的事情完全不同，我们无法将我们在宏观上观察到的情况应用到宇宙最微观层面。

为了帮助接受这一点，请考虑宇宙最宏观的层面。爱因斯坦证明没有什么能比光速更快。从我们人类大小的角度来看，这在直觉上似乎也是不对的：当我接近光速时，为什么我不能在踩一点油门？然而，这一理论已被普遍接受。

因此，当我说一个量子比特可以同时位于两个不同的位置或同时具有两个看似矛盾的能级时，请接受它，不要试图更深入地思考原因。

现在在回到介绍叠加态的地方 ...

## 第四个区别：指数增长

经典比特只能处于 “0” 和 “1” 两种确定的状态，而量子比特可能同时处于两种状态的叠加。一个长度为 32 的经典比特序列可以有大约 40 亿种组合。一台经典计算机一次只能评估其中一个。长为 32 的量子比特序列能同时处于所有 40 亿个状态。这意味着量子计算能力呈指数增长，而经典计算机呈线性增长。

例如，如果我想搜索某个 8 位的键值，16 位得计算机可以一次执行两次并行搜索，搜索速度是 8 位计算机的两倍。 32 位计算机将允许一次进行四次并行搜索，搜索速度是 8 位计算机的四倍。这意味着当其位数加倍时，经典计算机的能力加倍。

将其与量子计算机进行对比。如果量子计算机有一个量子位，那么它同时存储两个状态（“0 1”），因此可以同时搜索这两个状态。如果它有两个量子比特，那么它会同时存储四个状态（“00 01 10 11”），并且可以同时搜索所有四个状态，使其速度是单个量子比特计算机的两倍。如果它有三个量子比特，那么它会同时存储八个状态 (“000 001 010 011 100 101 110 111”)，并且可以同时搜索所有八个状态，因此它比单个量子比特计算机快 4 倍。因此，每增加一个量子比特，量子计算机的能力就会加倍。

不过，你可能还记得，量子比特有一个问题：当我们测量它们时，我们只能随机得到这些组合中的一种，如果我们想利用其同时处于多种状态的能力，这不是很有用。我们如何解决这个问题？答案是波干涉。

## 波干涉

如果你忘记了高中科学课，让我们回顾一下波的原理。您可以在水池中看到，当两个波浪相遇时，它们会相互影响。当两个波的波峰和波谷对齐时，它们会相互增强，有更强的波峰和波谷。但是当波峰和波谷对齐时，它们会相互抵消，导致没有波浪。

![图像来源： [Veritasium](https://www.youtube.com/watch?v=Iuv6hY6zsd0) with edits by author](https://cdn-images-1.medium.com/max/2000/1*jR6AB_iN8UKjh-H55KQ3hw.jpeg)

从本质上来说，量子比特的特性来自于能量波，它与池塘中的水波具有相同的特性。有一些复杂的算法（其数学原理超出了本文的范围）通过波的干涉效应来抑制错误的能量状态，同时放大正确的能量状态。通过在测量量子比特之前多次重复该算法，使得错误状态的测量概率下降，期望状态的测量概率上升。即使量子比特同时处于所有状态，你也可以通过在放大你想要的状态的同时抑制不想要的状态，从而在一定的置信度内找到问题的正确答案。

## Applications

Quantum computers are expected to surpass classical computers in certain areas. Here are some examples.

* **Artificial intelligence and data science.** Much of AI is built on complex statistics and searching for patterns in complex data. The ability to search all states simultaneously makes quantum algorithms uniquely suited for finding patterns in complex data, which will have uses not just in AI but in other areas of data science.
* **Cryptography.** [Shor’s Algorithm](https://en.wikipedia.org/wiki/Shor%27s_algorithm) is a theoretical quantum algorithm that can crack most asymmetrical ciphers. On the other hand, entanglement opens the possibility of new modes of encryption. Two entangled qubits have a correlation with each other even if they move to opposite sides of the universe. Encryption using entangled qubits is mathematically unbreakable since there is no shared key. For example, if I have a pair of entangled qubits such that they always evaluate to the same value, I can give one to my message recipient, then force the other to the value I want. When my recipient reads the value of the other qubit, he gets the same value to which I set mine without any information being passed through a wire.
* **Financial and weather models.** The random element of qubits makes them more suitable for modeling complex random systems like financial markets and weather. Investors often wish to evaluate the probability of various outcomes under an extremely large number of scenarios generated at random. The weather has so many complex variables that it can take a classical computer more time to compute a forecast than it takes for the weather to evolve. Furthermore, MIT researchers have shown that the equations governing the weather possess a hidden wave nature which is amenable to solution by a quantum computer.
* **Molecular modeling.** The complexity of molecules is so great that only the simplest of molecules can be modeled in classical computers. Chemistry industries see great potential to harness quantum computers to model complex molecules for the development of new compounds.

## Next Steps for Your IT Org

There are two key limitations to quantum adoption. The biggest is that quantum computers are still in their infancy. There are very few commercially viable options at this time. The second is that quantum computers will never beat classical computers in all areas. Rather, they are superior only for certain specific types of computational tasks. Classical computers will remain superior to quantum computers for most computational tasks. That means classical computers are here to stay.

Nonetheless, there are steps your business can take now to beat your competition in quantum. Quantum computers have evolved enough that data scientists can identify algorithms that will be uniquely suited for quantum computers and identify use cases where quantum computers would be beneficial were they to exist now. Begin developing quantum algorithm skills in your data science teams. Have them identify which computation tasks are better suited for quantum. More specifically, identify certain patterns that work better with quantum and document these so that other data scientists can recognize when a data set has the traits that will benefit from quantum. This will allow data teams to create a list of which current business cases (and future business cases as they arise) are suitable for quantum, including what level of maturity quantum computers need to achieve to trigger their viability. Finally, create a strategic plan for exploiting quantum computing based on which business problems your data scientists identify as good candidates for it.

Some resources where you can begin developing quantum skills include:

* [Quantum Computing Playground](http://www.quantumplayground.net/) is a quantum simulator you can run in a web browser. It won’t have the power of a real quantum computer, but it’s an opportunity to learn its concepts.
* Microsoft has released a [quantum language called Q#](https://www.microsoft.com/en-us/quantum/development-kit) that can also run in a quantum computer simulator.
* Finally, the [IBM Quantum Experience](https://quantum-computing.ibm.com/) has a real quantum computer connected to the Internet. With an IBMid account, you can write code to run on their quantum computer and gain access to their quantum community forum.

Quantum computing is advancing quickly. By planting the seeds of quantum skills in your data science organization and developing this strategic plan now, the day will come when your organization will be able to exploit the benefits of quantum computing while your competition starts from square one.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
