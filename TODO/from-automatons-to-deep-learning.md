
> * 原文地址：[From Automatons to Deep Learning](https://medium.com/towards-data-science/from-automatons-to-deep-learning-388f7969be34)
> * 原文作者：[Mark Aduol](https://medium.com/@markaduol943)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/from-automatons-to-deep-learning.md](https://github.com/xitu/gold-miner/blob/master/TODO/from-automatons-to-deep-learning.md)
> * 译者：
> * 校对者：

# From Automatons to Deep Learning
# 从金属巨人到深度学习
***A (very) brief history of artificial intelligence***
**AI 简史**

Talos was a giant bronze warrior created to guard the island of Crete from pirates and invaders. He circled the island three times daily, and his menacing appearance encouraged would-be pirates to seek treasure elsewhere. But Talos, behind his frightening presence, wasn’t much of a warrior at all. He was an automaton. A scarecrow, made only to project the *image* of a warrior. The faithful however, believed that the craftsmen had imbued creations such as Talos with very real minds, capable of emotion, thought and wisdom. This was of course, false. Talos was simply the latest manifestation of a dream that has consumed the minds of intellectuals for almost all of human history: the desire to create life-like, intelligent beings such as ourselves.
塔罗斯是一个青铜巨人战士，被创造出来守护克里特岛，抵御海盗和入侵者的攻击。他每天绕克里特岛三周，他凶狠的外表迫使海盗去别的地方寻找宝藏。但是在他凶狠外表的背后，塔罗斯根本算不上一个战士。他只是一个机器人。一个按照战士的**样子**做出来的稻草人。但是我们仍然相信造物主给类似塔罗斯这样的生物注入了非常真实的思考、情感、想法和智慧。这当然是无稽之谈。塔罗斯仅仅是人类历史长河最近的一个关于智能思想的梦想：创造生物的渴望，创造像我们自己一样智能生物的梦想。

> 用作家 Pamela McCorduck 的话来说就是："一个模仿上帝的古老愿望。"
> Or as the author Pamela McCorduck puts it, “an ancient wish to forge the gods.”

Scientists, mathematicians, philosophers and writers have long sought the secret that would allow them to create so called “thinking machines”. And what better example of a “thinking machine” than human beings themselves.
科学家、数学家、哲学家和作家们一直在寻找创造“会思考的机器”的秘诀。比人类本身更好的”会思考的机器“。

Ever since the creation of animated machines such as Talos, these craftsmen amongst us have no longer been interested in simply imitating intelligence they have sought after the real thing. Mindless automatons gave them a glimpse into what intelligence may look like, but such creations did not actually reveal the true nature of intelligence. For that they had to look into the clearest manifestation of intelligence: the mind of the human being.
从创造出塔罗斯这样会动的机器开始，人类中的创造者已经不满足与简单的模仿，而是开始寻求内在的东西。无意识的机器人让它们窥见了智能应该是什么样子，但是这种创造物并不能揭示智能的实质。因此，他们不得不考虑最清晰的智能的表现：人类的思想。

> 向[经济学人](https://medium.com/@the_economist)说的那样：“[为了启蒙，审视内心](https://twitter.com/TheEconomist/status/805471780764794882)”。
> As [The Economist](https://medium.com/@the_economist) says, “[for enlightenment, look within](https://twitter.com/TheEconomist/status/805471780764794882)”.

It was quickly realised that what separates humans from other less intelligent beings is not the size of our brains nor the length of our experience on this Earth, but quite simply, our superior capacity in all sorts of reasoning tasks. So it was no surprise that when the first programmable computers were conceived, it was intended that they should be able to simulate any process of formal reasoning, at least as well as any human being — indeed, the first attested use of the word “computer” dates back to 1640s England, where it meant “one who calculates”.
但是很快我们发现，人类区别与低等生物的主要原因并不是我们脑容量的大小，也不是我们在地球上生存的经验，而是我们强大的处理各种推理任务的能力。所以当我们构思出第一台可编程的计算机时，并没有什么好惊讶的，并且这个计算机还可以模拟任何正式的推理过程，至少要和人类一样，经考证单词 "computer" 第一次被使用实在 1940 年代的英格兰，当时它的意思是”一个会计算的机器“。

At first, progress moved slowly. The Harvard Mark I — a state of the art machine in the 1940s — was a 10,000 pound beast driven by thousands of mechanical components. 500 miles of wire were used to bring the machine to life, but despite such an elaborate setup, it was only capable of performing 3 additions per second. But as [Moore’s Law](https://visual.ly/community/infographic/computers/moores-law) came into effect, computers quickly achieved superhuman performance in all sorts of tasks to do with formal reasoning. Researchers, delightedly surprised at their progress, figured that at this rate, it would only be a matter of years until the first fully-fledged “thinking machines” would become a reality. In the 1960s, Herbert Simon, one of the intellectual giants of the 20th century, went so far as to claim that “machines will be capable, within twenty years, of doing any work a man can do”. Well, he was wrong — spectacularly so.
起初，发展的很慢。马克一号 — 一个艺术机器在 1940 年代诞生了 — 它是由上千个机械组件构成的重达 10,000 磅的庞然大物。使用了 500 英里的电线给它供电，但是即使是这样精心制作的配置，每秒钟也只能执行 3 次加法。但是随着[摩尔定理](https://visual.ly/community/infographic/computers/moores-law)的问世，计算机性能飞速发展，并且在各种各样任务的形式推理中拥有着超人表现。研究人员对这一进展既高兴又惊讶，并且指出以目前的进步的速度来看，第一个完全成熟的”会思考的机器“即将诞生。在 1960 年代， 20 世纪人类知识巨匠之一的赫伯特·西蒙曾声称”在 20 年之内，机器将能够胜任任何人类可以做的事情”，毫无疑问，他错了。

It turned out that while computers were good at solving problems that can be defined by a list of logical, mathematical rules, the greater challenge was getting them to solve problems that cannot be distilled into such formal statements. Problems such as recognising faces in images or translating human speech.
事实证明，计算机擅长于解决特定条件下的问题。如可以被一个逻辑或者数学规则列表定义的问题。更大的挑战则是让计算机解决那些不能被抽象成正规的声明语句的问题。比如识别图片中的人脸或者是翻译人类的语音。

The world has always been a chaotic place and so a machine that was capable of playing chess to a superhuman level, might have been useful for winning chess championships, but throw it out into the real world and it will be about as useful as a rubber duck (unless you engage in [rubber duck debugging](https://rubberduckdebugging.com/), that is).
在一个如此嘈杂的世界里，一台能够和超人下国际象棋的机器对于赢得冠军或许是有用的，但是在真实的世界里，它的作用就如同小黄鸭一样不值一提(除非你的工作就是[调试小黄鸭](https://rubberduckdebugging.com/))。

This realisation led several AI researchers to reject the principle that symbolic AI (an umbrella term for the methods of formal reasoning that had until then dominated AI research) was the best way of creating artificially intelligent machines. Cornerstones of symbolic AI such as the Situation Calculus and First-Order Logic, proved too formal and strict to capture all the uncertainty present in the real world. A new approach was needed.
这个认识导致几个 AI 研究员否认了符号 AI（曾经一度统治 AI 研究的形式推理方法的一个术语）是创造人造智能机器最好方法的基本原则。符号 AI 的基石像情景推演和谓词逻辑都被证明太严苛以致于捕捉不到现实世界中的一些不确定因素。AI 领域需要一个全新的方法。

Some researchers decided to look for answers using the aptly named “Fuzzy Logic”, a logical paradigm where truth values are not simply 0 or 1, but can be any value in between. Others decided to focus their efforts on an emerging field known as “Machine Learning”.
一些研究员决定使用一个叫做“模糊逻辑”的方法来寻求答案，模糊逻辑是一种真值不仅仅是 0 或者 1 还可以是任何中间值的逻辑范式。另外一些研究员则把所有努力都放在了叫做“机器学习”的新兴领域。

**Machine Learning** was born out of the inadequacy of formal logic to deal with the uncertainty of the real world. Rather than hard-code all of the world’s knowledge into a bundle of strict logical formulae, we could instead teach a computer to derive that knowledge on its own. Rather than tell it “this is a chair” and “that is a table”, we would instead teach the computer to learn to distinguish the concept of a chair from that of a table. Machine learning researchers carefully avoided representing the world in terms of certainties, since such strict characterisations were at odds with the nature of the real world.
**机器学习**是由于形式推理处理真实世界的不确定性因素的不足而诞生的。它不是将世界上的知识进行一个严格的逻辑公式的绑定，而是让计算机自己去学习知识。不是简单的告诉它“这是椅子”，"这是桌子"，而是教计算机学习椅子和桌子概念的区别 。机器学习研究员们一直避免使用必然的事件来代表世界，因为严格的特征条件并不是真实世界的本质。

Instead, they decided to model the world using the language of statistics and probability.
相反，他们决定用统计和概率来模型化这个世界。

> Rather than speak in terms of truths and falsehoods, machine learning algorithms would speak in terms of degrees of truth and degrees of falsehood — in other words, probabilities.
> 机器学习算法不是使用真和假来判断，而是用真的可能性和假的可能性来判断。换句话说就是 — 概率。

This idea that probabilities could capture the numerical uncertainties present in the world, led Bayesian statistics to become a cornerstone of machine learning. “[Frequentists](https://www.explainxkcd.com/wiki/index.php/1132:_Frequentists_vs._Bayesians)” had something to say about that, but that debate is best left as the subject of another article.
使用概率来量化真实世界的不确定性使得贝叶斯统计成为了机器学习的基石。对此，“[频率学派](https://www.explainxkcd.com/wiki/index.php/1132:_Frequentists_vs._Bayesians)” 也是有话要说的，但是关于频率学派和贝叶斯学派的争论我们最好在另一篇文章详述。

Soon enough, simple machine learning algorithms such as **logistic regression** and **naive Bayes **wereteaching computers to separate legitimate email from spam, as well as predict house prices given their size. Logistic regression is a particularly straightforward algorithm: given an input vector **x**,the model simply aims to classify the **x **into one of several categories, **{1, 2, …, k}** 中的一个就可以了。.
很快，像”逻辑回归“和”朴素贝叶斯“这样的简单的机器学习算法就已经可以告诉计算机如何过滤垃圾邮件以及根据房屋大小来预估价格了。逻辑回归是一个非常直接的算法：给一个输入向量 **x**，模型只需要将 **x** 分类到 **{1, 2, …, k}** 中的一个就可以了。

There is a catch however.
不过有一个条件。

> The performance of these simple algorithms depends heavily on the **representation **of data they are given. (Goodfellow et al. 2017)
> 这些简单算法的表现严重依赖于训练数据的表现。(Goodfellow et al. 2017)

To put this into context, try and imagine building a machine learning system that uses logistic regression in determining whether or not to recommend cesarean delivery. The system cannot examine the patient directly, so instead it relies on the information fed to it by a doctor. Such information may include the presence of a uterine scar, the number of months pregnant and the age of the patient. Each individual piece of information is known as a **feature **and put together, they give the AI system a complete **representation** of the patient.
总的来说就是，想象这样一个场景，你做了一个使用逻辑回归来决定是否剖腹产的机器学习系统。这个系统无法直接检测病人，而是由一个医生来给这个系统喂信息。这些信息可能会包含子宫疤痕、怀孕了几个月以及病人的年龄。没一个单独的信息都是一个**特征**，把它们合在一起，对于 AI 系统来说就是这个病人的**表示**。

Given some training data, logistic regression can then learn how each of these features of the patient correlate with various outcomes. For example, it may uncover from the training data that the risk of nausea during delivery increases with maternal age, and so the algorithm will therefore be less likely to recommend the procedure for older patients.
通过一些训练数据的训练，逻辑回归可以获得病人的这些特征中每一项与不同结果的关系。举例来说就是如果训练数据中没有包含分娩过程中恶心的概率和母亲年龄增长之间的关系的话，那么这个算法就不太可能为年纪大的父母推荐处理流程。

But while logistic regression can map representations to outcomes, it cannot actually influence what features make up the patient representation.
但是当逻辑回归可以将表示映射到结果上时，它就不能真切的影响到组成病人表示的特征。

> If logistic regression were given an MRI scan of the patient, rather than the doctor’s formalised report, it would not be able to make useful predictions. (Goodfellow et al. 2017)
> 如果逻辑回归不是从医生那里获得一份正式的报告，而是浏览了一张病人的核磁共振图，那么它就不能做出游泳的预测。(Goodfellow et al. 2017)

Individual pixels in an MRI scan tell us little about about whether the patient is at risk of suffering complications during delivery.
在分娩时期病人是否会有并发症的风险这个方面，核磁共振图的每一个独立的像素能告诉我们的信息太少了。

This dependence on good representations for good performance is a phenomenon that appears in both computer science and daily life. For instance, you can find any song on Spotify almost instantaneously because their collection of music is likely stored using intelligent data structures such as ternary search tries, as opposed to less sophisticated structures such as unsorted arrays. Another example: children in school can easily perform arithmetic using Arabic numerals but may find arithmetic on Roman numerals prohibitively difficult. Machine learning is no different; the choice of the input representation will have a major effect on the performance of learning algorithms.
这取决于有一个良好的表示，如果有优秀的表现那么无论对于计算机科学还是每日的生活都是一个伟大的贡献。举例来说就是你可以在 Spotify 上快速的搜索到你想要找的歌曲，因为它们的音乐集是使用一种类似于三叉树的只能数据结构，而不是用类似于乱序数据的粗旷解构来存储的。还有一个例子就是，学校里的孩子可以轻松的处理阿拉伯数字的算术，而处理罗马数字的算术却异常困难。机器学习没什么不同，输入表示的不同将会对你的学习算法的表现产生巨大的影响。

![](https://cdn-images-1.medium.com/max/800/1*mjzOs0JuZS7TfP0RXNc8Ew.png)

David Warde-Farley, Goodfellow et al. 2017

For this reason, many problems in artificial intelligence can be reduced to finding the right representation for the input data. For example, suppose we were to design an algorithm that learns to recognise hamburgers in Instagram photos. First of all, we would have to construct a **feature set** from which all burgers can be represented. Our first attempt may be to describe burgers in terms of the raw pixel values of the images. This may seem a sensible idea at first, but you will quickly realise that it is not.
由于这个原因，在人工智能领域中很多问题最后都可以归结为寻找合适的表示并把它作为输入数据。举个例子，假设我们设计了一个算法用于识别 Instagram 照片中的汉堡。首先，我们要根据所有的汉堡构建出一个**特征集**。首先我们要尝试的或许就是通过图片的原始像素的值来描述汉堡。起初这或许是一个明智的做法，但是很快你就会发现并不是。

It is difficult to describe what a burger looks like in terms of raw pixels alone — just think about what you do when you order a burger at McDonald’s (if you still eat there anymore). You might describe your order in terms of the various “features” you want on your burger, such as cheese, medium-rare patty, sesame-seed buns, lettuce, red onions and various condiments. Given this, it might be a good idea to construct our feature set in a similar manner. We can describe the burger as a collection of various components and each component can be described in terms of its own set of features. Most of a burger’s components can be described by using their colour and shape, and the whole burger can then be described in terms of the colours and shapes of its various components.
单纯凭借原始像素来描述汉堡长啥样是十分困难的，其实你可以想一下在麦当劳点汉堡的情景。当你点你想要的汉堡时，你应该会通过各种”特征“来描述要点的汉堡，比如奶酪、中间的肉饼、芝麻、生菜、红洋葱以及其他的调味料。我们可以通过不同的成分的集合来描述汉堡，每一个成分又可以用它本身的特征集来描述。大部分汉堡的成分可以用它们的的颜色和外形来描述，那么一个汉堡就可以它的不同的成分的颜色和外形来描述了。

But what happens when the burger is not in the centre of the image, or is placed amongst similarly coloured foods, or is being served at a particularly exotic restaurant that chooses to serve burgers disassembled? How does the algorithm distinguish colours or interpret geometry then? Well, the obvious solution is simply to add more (distinguishing) features, but that is at best a temporary solution; soon enough more edge cases will be discovered that require us to add even more features to our feature set in order to distinguish similar images from one another. Things are further complicated because of the computational cost of working on more complex input representations. So practitioners now have to pay attention not only to the number but also the expressiveness of all the features in their input representation. The task of finding the perfect feature set for any machine learning algorithm is a fiendishly complicated one, requiring a great deal of human time and effort; it can take a experienced community of researchers several decades.
但是当汉堡不在图片的中心位置，或者被放置在一个与之颜色相近的食物旁边，又或者在一个异域风情的饭店里汉堡是被分开提供的时候会发生什么呢？这时我们的算法又将如何区分以及解构汉堡呢？一个显而易见的办法是添加更多的(不同的)特征，但是这只是临时的解决办法。很快，我们就会发现更多的边界条件，然后我们就又要在我们的特征集里面添加更多的特征来区别相似的图片。随着输入表示的复杂，计算成本也随之提高，事情就变的更加复杂了。现在的开发者不仅要关注特征的数量还要还要关注输入表示的所有特征的表达力是否足够。寻找完美特征集对于任何机器学习算法来说都是一个艰苦卓绝的任务，研究人员同时也耗时耗力。一个经验丰富的社区可能都要研究几十年。

> This problem of determining how best to represent inputs to learning algorithms is colloquially known as the **representation problem.**
> 对于学习算法来说衡量表示输入好坏的问题又被称作**表示问题**。

Throughout the late 1990s and early 2000s, the weakness of machine learning algorithms in dealing with imperfect input representations, essentially placed a bottleneck on progress in the field of AI. When designing the representations of input features, engineers had no choice but to rely on human ingenuity and prior knowledge about the problem domain, in order to compensate for that weakness. In the long run such “feature engineering” was simply untenable; if a learning algorithm is unable to extract any insights from raw, unfiltered input data, then in a more philosophical sense, it is incapable of understanding the world as is.
从 1990 年后期到 2000 年早期，机器学习算法在处理不完美输入表示的弱点本质上其实是 AI 领域研究过程中的瓶颈。当设计输入特征的表示时，为了弥补算法上的弱点，工程师们除了依赖于人类的灵感和问题领域的前置知识以外别无他法。从长远来看，这样的"特征工程"其实是站不住脚的。如果一个学习算法不能够从原始数据和未被过滤的数据中获取有利信息，那么从一个更哲学角度讲，这些算法是不能理解这个世界的。

Despite these obstacles, researchers quickly found a way to finesse the problem. If machine learning algorithms are built to learn the mapping from representation to output, why not teach them to the learn the representation itself. This is known as **representation learning**. Perhaps the most famous example of it is the **autoencoder **— a type of neural network, which in turn is just a computer system modelled on the human brain and nervous system.
尽管有这么多的障碍，研究人员们依然很快就发现了解决问题的方法。如果一个机器学习算法可以把表示映射到输出，那么为什么让这些算法学习表示本身呢。这就是**表示学习**。关于表示学习最著名的例子应该就是**自编码**（神经网络的一种）了，它是基于人类大脑和神经系统建模的计算机系统。

An autoencoder is a nothing more than a combination of an **encoder** function, which transforms input data into a different representation, and a **decoder** function which transforms this intermediate representation back into the original format — retaining as much information as possible. The result is a split right in between the encoder and decoder, into which “noisy” images can be fed and decoded into a more useful representations. For instance, a noisy image might include an Instagram photo of a burger hidden amongst similarly coloured foods. The decoder would then eliminate this “noise”, preserving only the features of the image that describe the burger itself.
一个自编码实际上就是一个可以将输入转化为不同表示的**编码**函数和一个可以将中间表示转换回它的原始格式（尽可能多的保留信息）的**解码**函数的组合。举例来说就是一张拥有在相似颜色中隐藏的汉堡的 Instagram 图片。这个解码器将会消除这个”噪音“，仅仅保留可以描述汉堡本身的的特征。

![](https://cdn-images-1.medium.com/max/800/1*wKE69-fX180Q_gkzYzGbwg.png)

By Chervinskii — Own work, CC BY-SA 4.0, [https://commons.wikimedia.org/w/index.php?curid=45555552](https://commons.wikimedia.org/w/index.php?curid=45555552)

But even with autoencoders, problems remain. In order to eliminate noise, autoencoders — and any other representation learning algorithms — must be able to determine exactly what factors are most important in describing the input data. We want our algorithm to select factors that allow it to better discriminate between interesting images (such as those that contain burgers) and uninteresting ones. In our burger example, we figured that we may be more lucky in separating burger-containing photos from non-burger-containing ones, if we focus more on the shapes and colours of the components in the image, as opposed to the raw pixel values of the image. This is much easier said than done. The key is to teach our algorithm how to disentangle important factors from unimportant ones — that is, teach it to recognise the so called **factors of variation**.
但是对于自编码来说，问题仍然存在。为了消除噪音，自编码和一些其他的表示学习算法必须能够准确的决定对于输入数据的描述来说什么是最重要的因素。我们想要我们的算法更好的分辨出哪些是我们感兴趣的图片(包含汉堡的)和哪些是我们不感兴趣的图片。对于这个例子来说，如果我们不是关注图片原始像素的值，而是将更多的注意力放在图片成分的外形和颜色上，那么在分辨有汉堡图片和无汉堡图片这个问题上显然更有优势。当然了，说比做总是要容易的多。关键点就是告诉算法如何从没用的因子中解构出有用的因子，这就是**变量因子**。

At a first glance, representation learning does not seem to help us with this problem. But take a closer look.
乍一看，表示学习似乎无法为我们提供帮助，但是让我们再研究研究。

An encoder takes an input representation and feeds it through a **hidden****layer **(intermediate layer), compressing its input into a slightly smaller format. The decoder does the opposite: decompresses its input back into the original format, preserving as much information as possible. In both cases, the information in the input is best preserved if the hidden layer is aware of what factors are most important in describing the input, and then acts to ensure that these factors are not eliminated from the input as it passes through the layer.
一个编码器通过**隐藏层**(中间层)获取一个输入表示，将这个输入压缩成一个较小的格式。解码器做一个相反的事情：将输入解压回到原来的格式，尽可能多的保留数据。在这两个情况下，如果隐藏层知道哪些因子是描述输入最重要的，那么输入的信息将会得到最好的保留，然后确保这些因子没有在输入中被清除并传递到下一层。

In the diagram above, both the encoder and decoder contain only one hidden layer each: one layer to compress and one to decompress. This lack of granularity in the number of layers means that the algorithm has little flexibility in determining how best to compress and decompress the input, in order to preserve the maximum amount of information. But if we change the design slightly and stack several hidden layers, one after the other, we offer the algorithm greater freedom in determining how best to compress and decompress the input when selecting the factors of importance.
在上面的图标中，编码器和解码器都只包含一个隐藏层，一个被压缩，一个被解压。层的数量导致粒度的匮乏意味着这个算法为了最大限度的保留信息，会在判断输入的压缩和解压的好坏时弹性不足。但是如果我们做一个小调整，将几个隐藏层堆叠起来，一个接一个，那么我们就会给算法提供更大的自由度，同时算法也会在选择权重因子时对输入的压缩和解压达到最好的效果。

> This approach of using neural networks with multiple hidden layers is known as deep learning.
> 这种使用多个隐藏层的神经网络算法就是深度学习。

But that’s not all, deep learning goes one step further. With multiple hidden layers, we can construct complex representations by composing simpler ones. By stacking hidden layers, one after the other, we can identify new factors of variation in every layer. This gives our algorithm the ability to express highly complex concepts in terms of much simpler ones.
但是这并没有结束，深度学习还要再深入一步。在使用多个隐藏层时，我们可以组合多个简单的层来构建复杂的表示。通过一个一个的堆叠隐藏层，我们可以分辨出每一个层的变量因子。这会让我们的算法拥有用通过多个简单层的来表达高深复杂的概念的能力。

![](https://cdn-images-1.medium.com/max/800/1*lXwWR56AEUQs3pWhHeFEEg.jpeg)

Zeiler and Fergus (2014)

Deep learning has a long and rich history. The field’s central ideas were first introduced in the 1960s with the model of multi-layer perceptrons; the bread-and-butter backpropagation algorithm was first formalised in 1970, and the 1980s saw the arrival of artificial neural networks. But despite such early progress, it has taken several decades for these ideas to become useful in practice. The algorithms weren’t poor (as some people suspected), we just didn’t realise how much data was required in order to get them to work.
深度学习历史悠久。这个领域的核心观点在 1960 年代就通过多层感知器被提出来了。反向传播算法在 1970 年被正式提出，1980 年代各种人工神经网络也开始陆续登场。但是这些早期的成果又经历了几十年才在实践中得以运用。没有差的算法(有些人并不这样认为)，只是我们还没有意识到需要多大的数据量才能让它们变的有用。

Smaller data samples are more likely to produce extreme results due to the greater impact of statistical noise. With more data however, this noise loses its importance and a deep learning model is offered a much better idea of precisely what factors best explain the input.
越小的数据样本越容易产生极端的结果（因为在统计噪音上会有更大的影响）。越大的数据样本则会减弱噪音的影响并让深度学习模型更精确的知道哪些因子可以最好的描述输入。

It is no surprise then that it is in the early 21st century that deep learning has finally taken off — at precisely the same time that major tech companies find themselves sitting on mountains worth of untapped data.
在 21 世纪初期深度学习取得如此成就一点也不意外，而几乎同时，大部分科技公司也都发现了它们正坐在一座座未被开发的数据的金山上。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
