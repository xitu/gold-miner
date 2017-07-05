
> * 原文地址：[From Automatons to Deep Learning](https://medium.com/towards-data-science/from-automatons-to-deep-learning-388f7969be34)
> * 原文作者：[Mark Aduol](https://medium.com/@markaduol943)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/from-automatons-to-deep-learning.md](https://github.com/xitu/gold-miner/blob/master/TODO/from-automatons-to-deep-learning.md)
> * 译者：
> * 校对者：

# From Automatons to Deep Learning

***A (very) brief history of artificial intelligence***

Talos was a giant bronze warrior created to guard the island of Crete from pirates and invaders. He circled the island three times daily, and his menacing appearance encouraged would-be pirates to seek treasure elsewhere. But Talos, behind his frightening presence, wasn’t much of a warrior at all. He was an automaton. A scarecrow, made only to project the *image* of a warrior. The faithful however, believed that the craftsmen had imbued creations such as Talos with very real minds, capable of emotion, thought and wisdom. This was of course, false. Talos was simply the latest manifestation of a dream that has consumed the minds of intellectuals for almost all of human history: the desire to create life-like, intelligent beings such as ourselves.

> Or as the author Pamela McCorduck puts it, “an ancient wish to forge the gods.”

Scientists, mathematicians, philosophers and writers have long sought the secret that would allow them to create so called “thinking machines”. And what better example of a “thinking machine” than human beings themselves.

Ever since the creation of animated machines such as Talos, these craftsmen amongst us have no longer been interested in simply imitating intelligence they have sought after the real thing. Mindless automatons gave them a glimpse into what intelligence may look like, but such creations did not actually reveal the true nature of intelligence. For that they had to look into the clearest manifestation of intelligence: the mind of the human being.

> As [The Economist](https://medium.com/@the_economist) says, “[for enlightenment, look within](https://twitter.com/TheEconomist/status/805471780764794882)”.

It was quickly realised that what separates humans from other less intelligent beings is not the size of our brains nor the length of our experience on this Earth, but quite simply, our superior capacity in all sorts of reasoning tasks. So it was no surprise that when the first programmable computers were conceived, it was intended that they should be able to simulate any process of formal reasoning, at least as well as any human being — indeed, the first attested use of the word “computer” dates back to 1640s England, where it meant “one who calculates”.

At first, progress moved slowly. The Harvard Mark I — a state of the art machine in the 1940s — was a 10,000 pound beast driven by thousands of mechanical components. 500 miles of wire were used to bring the machine to life, but despite such an elaborate setup, it was only capable of performing 3 additions per second. But as [Moore’s Law](https://visual.ly/community/infographic/computers/moores-law) came into effect, computers quickly achieved superhuman performance in all sorts of tasks to do with formal reasoning. Researchers, delightedly surprised at their progress, figured that at this rate, it would only be a matter of years until the first fully-fledged “thinking machines” would become a reality. In the 1960s, Herbert Simon, one of the intellectual giants of the 20th century, went so far as to claim that “machines will be capable, within twenty years, of doing any work a man can do”. Well, he was wrong — spectacularly so.

It turned out that while computers were good at solving problems that can be defined by a list of logical, mathematical rules, the greater challenge was getting them to solve problems that cannot be distilled into such formal statements. Problems such as recognising faces in images or translating human speech.

The world has always been a chaotic place and so a machine that was capable of playing chess to a superhuman level, might have been useful for winning chess championships, but throw it out into the real world and it will be about as useful as a rubber duck (unless you engage in [rubber duck debugging](https://rubberduckdebugging.com/), that is).

This realisation led several AI researchers to reject the principle that symbolic AI (an umbrella term for the methods of formal reasoning that had until then dominated AI research) was the best way of creating artificially intelligent machines. Cornerstones of symbolic AI such as the Situation Calculus and First-Order Logic, proved too formal and strict to capture all the uncertainty present in the real world. A new approach was needed.

Some researchers decided to look for answers using the aptly named “Fuzzy Logic”, a logical paradigm where truth values are not simply 0 or 1, but can be any value in between. Others decided to focus their efforts on an emerging field known as “Machine Learning”.

**Machine Learning** was born out of the inadequacy of formal logic to deal with the uncertainty of the real world. Rather than hard-code all of the world’s knowledge into a bundle of strict logical formulae, we could instead teach a computer to derive that knowledge on its own. Rather than tell it “this is a chair” and “that is a table”, we would instead teach the computer to learn to distinguish the concept of a chair from that of a table. Machine learning researchers carefully avoided representing the world in terms of certainties, since such strict characterisations were at odds with the nature of the real world.

Instead, they decided to model the world using the language of statistics and probability.

> Rather than speak in terms of truths and falsehoods, machine learning algorithms would speak in terms of degrees of truth and degrees of falsehood — in other words, probabilities.

This idea that probabilities could capture the numerical uncertainties present in the world, led Bayesian statistics to become a cornerstone of machine learning. “[Frequentists](https://www.explainxkcd.com/wiki/index.php/1132:_Frequentists_vs._Bayesians)” had something to say about that, but that debate is best left as the subject of another article.

Soon enough, simple machine learning algorithms such as **logistic regression** and **naive Bayes **wereteaching computers to separate legitimate email from spam, as well as predict house prices given their size. Logistic regression is a particularly straightforward algorithm: given an input vector **x**,the model simply aims to classify the **x **into one of several categories, **{1, 2, …, k}**.

There is a catch however.

> The performance of these simple algorithms depends heavily on the **representation **of data they are given. (Goodfellow et al. 2017)

To put this into context, try and imagine building a machine learning system that uses logistic regression in determining whether or not to recommend cesarean delivery. The system cannot examine the patient directly, so instead it relies on the information fed to it by a doctor. Such information may include the presence of a uterine scar, the number of months pregnant and the age of the patient. Each individual piece of information is known as a **feature **and put together, they give the AI system a complete **representation** of the patient.

Given some training data, logistic regression can then learn how each of these features of the patient correlate with various outcomes. For example, it may uncover from the training data that the risk of nausea during delivery increases with maternal age, and so the algorithm will therefore be less likely to recommend the procedure for older patients.

But while logistic regression can map representations to outcomes, it cannot actually influence what features make up the patient representation.

> If logistic regression were given an MRI scan of the patient, rather than the doctor’s formalised report, it would not be able to make useful predictions. (Goodfellow et al. 2017)

Individual pixels in an MRI scan tell us little about about whether the patient is at risk of suffering complications during delivery.

This dependence on good representations for good performance is a phenomenon that appears in both computer science and daily life. For instance, you can find any song on Spotify almost instantaneously because their collection of music is likely stored using intelligent data structures such as ternary search tries, as opposed to less sophisticated structures such as unsorted arrays. Another example: children in school can easily perform arithmetic using Arabic numerals but may find arithmetic on Roman numerals prohibitively difficult. Machine learning is no different; the choice of the input representation will have a major effect on the performance of learning algorithms.

![](https://cdn-images-1.medium.com/max/800/1*mjzOs0JuZS7TfP0RXNc8Ew.png)

David Warde-Farley, Goodfellow et al. 2017
For this reason, many problems in artificial intelligence can be reduced to finding the right representation for the input data. For example, suppose we were to design an algorithm that learns to recognise hamburgers in Instagram photos. First of all, we would have to construct a **feature set** from which all burgers can be represented. Our first attempt may be to describe burgers in terms of the raw pixel values of the images. This may seem a sensible idea at first, but you will quickly realise that it is not.

It is difficult to describe what a burger looks like in terms of raw pixels alone — just think about what you do when you order a burger at McDonald’s (if you still eat there anymore). You might describe your order in terms of the various “features” you want on your burger, such as cheese, medium-rare patty, sesame-seed buns, lettuce, red onions and various condiments. Given this, it might be a good idea to construct our feature set in a similar manner. We can describe the burger as a collection of various components and each component can be described in terms of its own set of features. Most of a burger’s components can be described by using their colour and shape, and the whole burger can then be described in terms of the colours and shapes of its various components.

But what happens when the burger is not in the centre of the image, or is placed amongst similarly coloured foods, or is being served at a particularly exotic restaurant that chooses to serve burgers disassembled? How does the algorithm distinguish colours or interpret geometry then? Well, the obvious solution is simply to add more (distinguishing) features, but that is at best a temporary solution; soon enough more edge cases will be discovered that require us to add even more features to our feature set in order to distinguish similar images from one another. Things are further complicated because of the computational cost of working on more complex input representations. So practitioners now have to pay attention not only to the number but also the expressiveness of all the features in their input representation. The task of finding the perfect feature set for any machine learning algorithm is a fiendishly complicated one, requiring a great deal of human time and effort; it can take a experienced community of researchers several decades.

> This problem of determining how best to represent inputs to learning algorithms is colloquially known as the **representation problem.**

Throughout the late 1990s and early 2000s, the weakness of machine learning algorithms in dealing with imperfect input representations, essentially placed a bottleneck on progress in the field of AI. When designing the representations of input features, engineers had no choice but to rely on human ingenuity and prior knowledge about the problem domain, in order to compensate for that weakness. In the long run such “feature engineering” was simply untenable; if a learning algorithm is unable to extract any insights from raw, unfiltered input data, then in a more philosophical sense, it is incapable of understanding the world as is.

Despite these obstacles, researchers quickly found a way to finesse the problem. If machine learning algorithms are built to learn the mapping from representation to output, why not teach them to the learn the representation itself. This is known as **representation learning**. Perhaps the most famous example of it is the **autoencoder **— a type of neural network, which in turn is just a computer system modelled on the human brain and nervous system.

An autoencoder is a nothing more than a combination of an **encoder** function, which transforms input data into a different representation, and a **decoder** function which transforms this intermediate representation back into the original format — retaining as much information as possible. The result is a split right in between the encoder and decoder, into which “noisy” images can be fed and decoded into a more useful representations. For instance, a noisy image might include an Instagram photo of a burger hidden amongst similarly coloured foods. The decoder would then eliminate this “noise”, preserving only the features of the image that describe the burger itself.

![](https://cdn-images-1.medium.com/max/800/1*wKE69-fX180Q_gkzYzGbwg.png)

By Chervinskii — Own work, CC BY-SA 4.0, [https://commons.wikimedia.org/w/index.php?curid=45555552](https://commons.wikimedia.org/w/index.php?curid=45555552)

But even with autoencoders, problems remain. In order to eliminate noise, autoencoders — and any other representation learning algorithms — must be able to determine exactly what factors are most important in describing the input data. We want our algorithm to select factors that allow it to better discriminate between interesting images (such as those that contain burgers) and uninteresting ones. In our burger example, we figured that we may be more lucky in separating burger-containing photos from non-burger-containing ones, if we focus more on the shapes and colours of the components in the image, as opposed to the raw pixel values of the image. This is much easier said than done. The key is to teach our algorithm how to disentangle important factors from unimportant ones — that is, teach it to recognise the so called **factors of variation**.

At a first glance, representation learning does not seem to help us with this problem. But take a closer look.

An encoder takes an input representation and feeds it through a **hidden****layer **(intermediate layer), compressing its input into a slightly smaller format. The decoder does the opposite: decompresses its input back into the original format, preserving as much information as possible. In both cases, the information in the input is best preserved if the hidden layer is aware of what factors are most important in describing the input, and then acts to ensure that these factors are not eliminated from the input as it passes through the layer.

In the diagram above, both the encoder and decoder contain only one hidden layer each: one layer to compress and one to decompress. This lack of granularity in the number of layers means that the algorithm has little flexibility in determining how best to compress and decompress the input, in order to preserve the maximum amount of information. But if we change the design slightly and stack several hidden layers, one after the other, we offer the algorithm greater freedom in determining how best to compress and decompress the input when selecting the factors of importance.

> This approach of using neural networks with multiple hidden layers is known as deep learning.

But that’s not all, deep learning goes one step further. With multiple hidden layers, we can construct complex representations by composing simpler ones. By stacking hidden layers, one after the other, we can identify new factors of variation in every layer. This gives our algorithm the ability to express highly complex concepts in terms of much simpler ones.

![](https://cdn-images-1.medium.com/max/800/1*lXwWR56AEUQs3pWhHeFEEg.jpeg)

Zeiler and Fergus (2014)

Deep learning has a long and rich history. The field’s central ideas were first introduced in the 1960s with the model of multi-layer perceptrons; the bread-and-butter backpropagation algorithm was first formalised in 1970, and the 1980s saw the arrival of artificial neural networks. But despite such early progress, it has taken several decades for these ideas to become useful in practice. The algorithms weren’t poor (as some people suspected), we just didn’t realise how much data was required in order to get them to work.

Smaller data samples are more likely to produce extreme results due to the greater impact of statistical noise. With more data however, this noise loses its importance and a deep learning model is offered a much better idea of precisely what factors best explain the input.

It is no surprise then that it is in the early 21st century that deep learning has finally taken off — at precisely the same time that major tech companies find themselves sitting on mountains worth of untapped data.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
