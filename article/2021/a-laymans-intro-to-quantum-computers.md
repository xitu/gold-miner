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

A quantum computer operates on its qubits using quantum gates. These move the qubit around the surface of the sphere, meaning the inputs and outputs are the same. For example, one quantum gate might flip the qubit to the opposite part of the sphere or rotate it around one of its axes. Some gates take one input. Others take two or more, where the state of each inputs affects the resulting output state of all. In the image below we see the qubit from before being rotated around its vertical axis by a quantum gate.
量子计算机使用量子门对其量子比特进行运算。这些计算让量子比特围绕球体表面移动，这意味着输入和输出是同一个量子比特的不同状态。例如，一个量子门可能会将量子比特翻转到球体的另一部分或围绕其轴之一旋转。有些门接受一个输入。有些门需要两个或更多，此时每个输入的状态影响所有输出状态。在下图中，我们看到之前的量子比特在被量子门围绕其垂直轴旋转。

![量子门使量子比特在球面上移动。图像来源：作者。](https://cdn-images-1.medium.com/max/2000/1*UsZeojy60miuuh5Wmd1tOg.png)

## 第二个区别：十分不同的逻辑门

经典计算机的门在输出一个新比特的同时并不会改变其输入比特。而量子计算机的门直接改变其输入量子比特的状态，并不创造新的量子比特。此外，所有量子门都是可逆的，但并非所有经典门都是可逆的（见上图的两个门 —— 不是总能从输出推断输入）。最后，数学家已经证明，所有经典的逻辑门都可以使用量子门的组合来创建，但有些量子门不能由经典门创建。换句话说，量子门开启了经典计算机无法做到的新操作。这意味着创造新算法的潜力。

## 量子纠缠

两个或多个量子比特可能会纠缠在一起。这意味着测量一个量子比特会立即影响其他量子比特，即使它们深处宇宙的两侧。一个简单的例子是，如果你有两个量子比特，观察一个会导致另一个在观察时总是产生相反的结果。另一种可能是观察一个量子比特的结果会影响另一个量子比特变为 “0” 或 “1” 的概率。这提供了在整个数据系统上运行的算法，而不是一次一位。

## 第三个区别：比特之间的依赖性

一种理解方式是，两个纠缠的量子比特的状态不再相互独立。

下方的左图显示了两个未纠缠的量子比特 —— 蓝色的 A 和红色的 B。两者都有一半的机会变成 “0” 或 “1”。每种组合的几率是相同的：“00” 的几率为 25%，“01” 的几率为 25%，等等。知道 A 或 B 的值并不能告诉你另一个比特的任何信息。

On the right, it shows two entangled qubits. In thiscase, knowing the value of one qubit also tells you something about the other. If you know that qubit B is `0`, then you also know that qubit A is twice as likely to be `1` than `0`. But if you know qubit B is `1`, then you know qubit A must be `0 `— they are no longer independent.
在下方右图中，显示了两个纠缠的量子比特。在这种情况下，知道一个量子比特的值也能告诉你关于另一个量子比特的一些信息。如果你知道量子比特 B 为 “0”，那么你也知道量子比特 A 为 “1” 的可能性是 “0” 的两倍。但是如果你知道量子比特 B 是 “1”，那么你知道量子比特 A 一定是 “0” —— 它们不再是独立的。

![图片来源：作者。](https://cdn-images-1.medium.com/max/2000/1*aAorGuHgmX7o-HkKhEJkJg.png)

## Superposition

Recall that a qubit, when observed, results in a random outcome. You would intuitively think that the qubit was oscillating between the two states, like a coin flipping heads and tails in the air until it lands where a final result can be observed. Yet, in reality, a qubit is both a `0` and `1` at the same time. This is because the particle that stores the qubit information can have different levels of energy or be in different locations at the same time. When the quantum particle interacts with something else, such as a tool that measures its energy or position, it randomly “collapses” to one of those multiple states.

### Suspend your disbelief

I need to interrupt this description of superposition and address the main stumbling point for most people: disbelief or confusion. Your current thought is probably, “How can something be in two places at once? That’s impossible!”

I posed this question to three Ph.D. quantum physicists. One responded that you just have to suspend disbelief and trust the math and experiments proving it true. The other two gave a more satisfactory answer. The macro world we live in is just radically different than what happens at the most micro levels, and we cannot apply what we observe at our human-sized level of observation to what happens at the most micro-level of the universe.

To help accept this, think about the most macro aspects of the universe. Einstein proved nothing can move faster than light. That also seems intuitively impossible from our human-sized perspective: Why can’t I just step on the gas a little harder when I’m near light speed? Yet it has become commonly accepted in mainstream culture.

So, when I say a qubit can be in two different locations or have two seemingly contradictory energy levels at the same time, just accept it as true and don’t try to think any deeper why.

Now back to explaining superposition…

## Fourth Difference: Exponential Growth

Whereas a classical bit that can only be in the state corresponding to `0` or the state corresponding to `1`, a qubit may be in a superposition of both states simultaneously. A sequence of 32 bits can be in approximately 4 billion combinations. A classical computer can only evaluate one of them at a time. A series of 32 qubits is in all 4 billion combinations at the same time. This means quantum computing power grows at an exponential rate whereas a classical computer grows linearly.

For example, if I want to search for some key combination of 8 bits, a 16-bit computer can perform two searches in parallel, going twice as fast as an 8-bit computer. A 32-bit computer would allow four parallel searches, finishing the search four times as fast as an 8-bit computer. This means the power of a classical computer doubles when the number of its bits doubles.

Contrast that to a quantum computer. If a quantum computer has one qubit, then it’s simultaneously storing two states (`0 1`) and so can search both at the same time. If it has two qubits, then it’s simultaneously storing four states (`00 01 10 11`) and again can simultaneously search all four at once, making it twice as fast as a single qubit computer. If it has three qubits, then it’s simultaneously storing eight states (000 001 010 011 100 101 110 111) and again can simultaneously search all eight at once, so it’s eight times faster than a single qubit computer. Thus the power of a quantum computer doubles with every qubit added to it.

You may recall, though, that there’s one problem with qubits: when we measure them, we get only one of those combinations at random, which isn’t very useful if we want to harness its ability to be in multiple states simultaneously. How do we work around that? The answer is wave interference.

## Wave Interference

In case you forgot from high school science class, let’s review how waves work. You can see in a pool of water that when two waves meet they interfere with each other. When the peaks and troughs of two waves align, they amplify themselves for stronger peaks and troughs. But when a peak meets a trough, they cancel each other out, resulting in no wave.

![Image credit: [Veritasium](https://www.youtube.com/watch?v=Iuv6hY6zsd0) with edits by author](https://cdn-images-1.medium.com/max/2000/1*jR6AB_iN8UKjh-H55KQ3hw.jpeg)

Under the hood, the properties of qubits come from energy waves, which have the same signal interference properties as water waves in a pond. There are complex algorithms (whose math is beyond the scope of this article) that use canceling interference to dampen energy states far from the correct answer while amplifying those closer to the correct answer. By repeating the algorithm multiple times prior to measuring the qubits, the probability of the measurement resulting in an incorrect state goes down while the probability of the measurement resulting in the desired state goes up. Even though the qubits are in all states simultaneously, you can find the correct answer to a problem within a certain degree of confidence by dampening the states you don’t want while amplifying the states you do want.

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
