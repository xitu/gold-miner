> * 原文地址：[A Layman’s Intro to Quantum Computers](https://betterprogramming.pub/a-laymans-intro-to-quantum-computers-67b7a7126695)
> * 原文作者：[David Mooter](https://medium.com/@davidmooter)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/a-laymans-intro-to-quantum-computers.md](https://github.com/xitu/gold-miner/blob/master/article/2021/a-laymans-intro-to-quantum-computers.md)
> * 译者：
> * 校对者：

# A Layman’s Intro to Quantum Computers

## A Layman’s Introduction to Quantum Computers

#### Get started with quantum computing—no Ph.D. required

![Photo by [Zoltan Tasi](https://unsplash.com/@zoltantasi?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/9792/0*FPUtmaqNJ12IcZx8)

Quantum computers have the potential to revolutionize information technology. Many analysts view current quantum computers as on par with the room-sized computers of the 1940s. Over the coming decades, they may advance at the same exponential rate as classical computers have done. Unfortunately, literature on quantum computing is often written **by** people with physics degrees **for** people with physics degrees. Here, I will explain quantum computing in layman’s terms: how it works, how it differs from classical computing, and why it will be revolutionary for your business.

## Classical Bits vs. Qubits

A classical computer has a memory made up of bits, where each bit has two states representing either `0` or `1`. As you string together more bits, you can store more combinations of information.

For example, with two bits you have four possible states: `00 01 10 11`. With three bits you have eight possible states: 000 001 010 011 100 101 110 111.

At a physical level, these bits are electrical circuits where the `0` and `1` represent different levels of electrical current flowing through them.

A quantum computer maintains a sequence of qubits which also each have two states that can represent `0` or `1`. These qubits, though, are not electrical circuits. Instead, they are subatomic particles held in one place — immobile. They represent `0` or `1` through various means, depending on the type of quantum computer, but that level of detail is not important for understanding their uses.

Unlike a classical bit, when you measure the qubit you do not always get the same result. Rather, a qubit’s state can be thought of as being on the surface of a sphere. The north and south poles represent final states `0` and `1`, respectively. When the qubit’s state is closer to a pole, it represents higher odds of going to the `0` state when measured, etc. For example, a qubit on its equator would have a 50/50 chance of going either way. When measuring the qubit in the diagram below, it has a significantly higher chance of coming out `0` (north) than `1` (south) due to being closer to the north pole than the south pole.

![A representation of a qubit as a point on the surface of a sphere. Image credit: Author.](https://cdn-images-1.medium.com/max/2000/1*6ek0KRvlg8Q22Bs0vij9YA.png)

## First Difference: Definite vs. Probabilistic State

This brings us to the first difference from a classical computer. A classical bit holds a definite `0` or `1`. By contrast, a qubit holds a **probability** of becoming `0` or `1`. For example, if a qubit has a 60% probability of becoming `1`, then you can think of it as storing the value `60%`. By repeating a quantum computation many times and observing the outcome, you can determine what that probability is to some degree of certainty. Thus it can store an infinite number of values from zero to one but at the expense of always having some level of statistical uncertainty about what that value truly is. Quantum algorithms are often probabilistic in that they provide the correct solution only within a certain known probability of confidence. In contrast, classical computers are at their heart deterministic systems that output one answer with complete confidence. As any computer scientist knows, making classical computers truly random is quite difficult since they are so oriented towards deterministic “yes” or “no” answers.

## Classical Gates vs. Quantum Gates

Computers compute things by running their bits through gates. These usually take two inputs, or sometimes one, and output a new value based on those inputs. For example, the gate called the `AND`gate outputs `1` if both its inputs are also `1`; else it outputs `0`. Two example gates are shown here:

![Two common classical logic gates. Image credit: Author.](https://cdn-images-1.medium.com/max/2000/1*nnCAiy_9xEhyqQwmToybyw.png)

A quantum computer operates on its qubits using quantum gates. These move the qubit around the surface of the sphere, meaning the inputs and outputs are the same. For example, one quantum gate might flip the qubit to the opposite part of the sphere or rotate it around one of its axes. Some gates take one input. Others take two or more, where the state of each inputs affects the resulting output state of all. In the image below we see the qubit from before being rotated around its vertical axis by a quantum gate.

![Quantum gates move the qubit around the surface of the sphere. Image credit: Author.](https://cdn-images-1.medium.com/max/2000/1*UsZeojy60miuuh5Wmd1tOg.png)

## Second Difference: Very Different Gates

Classical computer gates output a new bit while leaving their input bits unchanged. A quantum computer changes the state of its input bits without creating new output bits. Furthermore, all quantum gates are reversible, but not all classical gates are (see above diagram of two gates — there is no way to always infer the inputs from the output). Lastly, mathematicians have proven that all classical computer gates can be created using combinations of quantum gates, but some quantum gates cannot be created by classical gates. In other words, quantum gates open up new operations that classical computers just can’t do. This means the potential for new algorithms.

## Entanglement

It is possible for two or more qubits to become entangled. What this means is that measuring one qubit will instantly affect the others even if they are moved to opposite sides of the universe. A simple example is if you have two qubits and observing one will cause the other to always result in the inverse when it is observed. Another could be that the outcome of observing one qubit affects the probability of the other qubit becoming `0` or `1`. This opens up algorithms that operate on the entire system of data, rather than one bit at a time.

## Third Difference: Dependency Between Bits

One way to think of it is that the states of the two entangled qubits are no longer independent of each other.

The left diagram below shows two unentangled qubits — A in blue and B in red. Both have a 50/50 chance of becoming `0` or `1`. The odds of each combination is the same: 25% chance of `00`, 25% chance of `01`, etc. Knowing the value of A or B tells you nothing about the other.

On the right, it shows two entangled qubits. In thiscase, knowing the value of one qubit also tells you something about the other. If you know that qubit B is `0`, then you also know that qubit A is twice as likely to be `1` than `0`. But if you know qubit B is `1`, then you know qubit A must be `0 `— they are no longer independent.

![Image credit: Author.](https://cdn-images-1.medium.com/max/2000/1*aAorGuHgmX7o-HkKhEJkJg.png)

## Superposition

Recall that a qubit, when observed, results in a random outcome. You would intuitively think that the qubit was oscillating between the two states, like a coin flipping heads and tails in the air until it lands where a final result can be observed. Yet, in reality, a qubit is both a `0` and `1` at the same time. This is because the particle that stores the qubit information can have different levels of energy or be in different locations at the same time. When the quantum particle interacts with something else, such as a tool that measures its energy or position, it randomly “collapses” to one of those multiple states.

#### Suspend your disbelief

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
