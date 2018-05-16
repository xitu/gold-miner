> * 原文地址：[Machine Learning for Humans🤖👶](https://medium.com/machine-learning-for-humans/why-machine-learning-matters-6164faf1df12)
> * 原文作者：[Vishal Maini](https://medium.com/@v_maini?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/why-machine-learning-matters.md](https://github.com/xitu/gold-miner/blob/master/TODO1/why-machine-learning-matters.md)
> * 译者：
> * 校对者：

# Machine Learning for Humans🤖👶

## Simple, plain-English explanations accompanied by math, code, and real-world examples.

![](https://cdn-images-1.medium.com/max/800/1*Vkf6A8Mb0wBoL3Fw1u0paA.jpeg)

```
**[Update 9/1/17]** This series is now available as a full-length e-book! [Download here](https://www.dropbox.com/s/e38nil1dnl7481q/machine_learning.pdf?dl=0).
```

### Roadmap

[**Part 1: Why Machine Learning Matters**](https://medium.com/machine-learning-for-humans/why-machine-learning-matters-6164faf1df12)**.** The big picture of artificial intelligence and machine learning — past, present, and future.

[**Part 2.1: Supervised Learning**](https://medium.com/@v_maini/supervised-learning-740383a2feab)**.** Learning with an answer key. Introducing linear regression, loss functions, overfitting, and gradient descent.

[**Part 2.2: Supervised Learning II**](https://medium.com/@v_maini/supervised-learning-2-5c1c23f3560d)**.** Two methods of classification: logistic regression and SVMs.

[**Part 2.3: Supervised Learning III**](https://medium.com/@v_maini/supervised-learning-3-b1551b9c4930)**.** Non-parametric learners: k-nearest neighbors, decision trees, random forests. Introducing cross-validation, hyperparameter tuning, and ensemble models.

[**Part 3: Unsupervised Learning**](https://medium.com/@v_maini/unsupervised-learning-f45587588294)**.** Clustering: k-means, hierarchical. Dimensionality reduction: principal components analysis (PCA), singular value decomposition (SVD).

[**Part 4: Neural Networks & Deep Learning**](https://medium.com/@v_maini/neural-networks-deep-learning-cdad8aeae49b)**.** Why, where, and how deep learning works. Drawing inspiration from the brain. Convolutional neural networks (CNNs), recurrent neural networks (RNNs). Real-world applications.

[**Part 5: Reinforcement Learning**](https://medium.com/@v_maini/reinforcement-learning-6eacf258b265)**.** Exploration and exploitation. Markov decision processes. Q-learning, policy learning, and deep reinforcement learning. The value learning problem.

[**Appendix: The Best Machine Learning Resources**](https://medium.com/@v_maini/how-to-learn-machine-learning-24d53bb64aa1)**.** A curated list of resources for creating your machine learning curriculum.

### Who should read this?

*   Technical people who want to get up to speed on machine learning quickly
*   Non-technical people who want a primer on machine learning and are willing to engage with technical concepts
*   Anyone who is curious about how machines think

This guide is intended to be accessible to anyone. Basic concepts in probability, statistics, programming, linear algebra, and calculus will be discussed, but it isn’t necessary to have prior knowledge of them to gain value from this series.

```
This series is a guide for getting up-to-speed on high-level machine learning concepts in ~2-3 hours.

If you're more interested in figuring out which courses to take, textbooks to read, projects to attempt, etc., take a look at our recommendations in the [Appendix: The Best Machine Learning Resources](https://medium.com/machine-learning-for-humans/how-to-learn-machine-learning-24d53bb64aa1).
```

### Why machine learning matters

Artificial intelligence will shape our future more powerfully than any other innovation this century. Anyone who does not understand it will soon find themselves feeling left behind, waking up in a world full of technology that feels more and more like magic.

The rate of acceleration is already astounding. After a couple of [AI winters and periods of false hope](https://en.wikipedia.org/wiki/History_of_artificial_intelligence#The_first_AI_winter_1974.E2.80.931980) over the past four decades, rapid advances in data storage and computer processing power have dramatically changed the game in recent years.

In 2015, Google trained a conversational agent (AI) that could not only convincingly interact with humans as a tech support helpdesk, but also discuss morality, express opinions, and answer general facts-based questions.

![](https://cdn-images-1.medium.com/max/800/1*P1H87bkqILoGBVVT7g0T0A.png)

([Vinyals & Le, 2017](https://arxiv.org/abs/1506.05869))

The same year, DeepMind developed an [agent](https://storage.googleapis.com/deepmind-media/dqn/DQNNaturePaper.pdf) that surpassed human-level performance at 49 Atari games, receiving only the pixels and game score as inputs. Soon after, in 2016, DeepMind obsoleted their own achievement by releasing a new [state-of-the-art gameplay method](https://arxiv.org/pdf/1602.01783.pdf) called A3C.

Meanwhile, [AlphaGo](https://deepmind.com/research/publications/mastering-game-go-deep-neural-networks-tree-search/) defeated one of the best human players at Go — an extraordinary achievement in a game dominated by humans for two decades after machines first conquered chess. Many masters could not fathom how it would be possible for a machine to grasp the full nuance and complexity of this ancient Chinese war strategy game, with its 10¹⁷⁰ possible board positions (there are only [10⁸⁰atoms in the universe](http://www.slate.com/articles/technology/technology/2016/03/google_s_alphago_defeated_go_champion_lee_sedol_ken_jennings_explains_what.html)).

![](https://cdn-images-1.medium.com/max/800/1*2pYq0Qc3oMDYoVoEA9-6cg.png)

Professional Go player Lee Sedol reviewing his match with AlphaGo after defeat. Photo via [The Atlantic](https://www.theatlantic.com/technology/archive/2016/03/the-invisible-opponent/475611/).

In March 2017, OpenAI created agents that [invented their own language](https://blog.openai.com/learning-to-communicate/) to cooperate and more effectively achieve their goal. Soon after, Facebook reportedly successfully training agents to [negotiate](https://code.facebook.com/posts/1686672014972296/deal-or-no-deal-training-ai-bots-to-negotiate/) and even [lie](https://www.theregister.co.uk/2017/06/15/facebook_to_teach_chatbots_negotiation/).

Just a few days ago (as of this writing), on August 11, 2017, OpenAI reached yet another incredible milestone by defeating the world’s top professionals in 1v1 matches of the online multiplayer game Dota 2.

![](https://cdn-images-1.medium.com/max/800/1*eWnzwOQX5QgkQ4FRU_I6sg.png)

See the full match at The International 2017, with Dendi (human) vs. OpenAI (bot), on [YouTube](https://www.youtube.com/watch?v=wiOopO9jTZw).

Much of our day-to-day technology is powered by artificial intelligence. Point your camera at the menu during your next trip to Taiwan and the restaurant’s selections will magically appear in English via the Google Translate app.

![](https://cdn-images-1.medium.com/max/800/1*x8IgnfzPL7iLZHa9Uhy50g.png)

Google Translate overlaying English translations on a drink menu in real time using convolutional neural networks.

Today AI is used to design [evidence-based treatment plans](https://www.ibm.com/watson/health/oncology-and-genomics/oncology/) for cancer patients, instantly analyze results from medical tests to [escalate to the appropriate specialist](https://deepmind.com/applied/deepmind-health/) immediately, and conduct [scientific research](http://benevolent.ai/) for drug discovery.

![](https://cdn-images-1.medium.com/max/800/1*GEo3QHtN3gcWt0b2k08q7w.png)

A bold proclamation by London-based BenevolentAI (screenshot from [About Us](http://benevolent.ai/about-us/) page, August 2017).

In everyday life, it’s increasingly commonplace to discover machines in roles traditionally occupied by humans. Really, don’t be surprised if a little housekeeping delivery bot shows up instead of a human next time you call the hotel desk to send up some toothpaste.

![](https://i.loli.net/2018/05/16/5afb8c9f2b861.png)

In this series, we’ll explore the core machine learning concepts behind these technologies. By the end, you should be able to describe how they work at a conceptual level and be equipped with the tools to start building similar applications yourself.

### The semantic tree: artificial intelligence and machine learning

> One bit of advice: it is important to view knowledge as sort of a **semantic tree** — make sure you understand the fundamental principles, ie the trunk and big branches, before you get into the leaves/details or there is nothing for them to hang on to. — Elon Musk, [Reddit AMA](https://www.reddit.com/r/IAmA/comments/2rgsan/i_am_elon_musk_ceocto_of_a_rocket_company_ama/cnfre0a/)

![](https://cdn-images-1.medium.com/max/800/1*QJG2nMIqWHmLp2j4c0GVuQ.png)

Machine learning is one of many subfields of artificial intelligence, concerning the ways that computers learn from experience to improve their ability to think, plan, decide, and act.

**Artificial intelligence is the study of agents that perceive the world around them, form plans, and make decisions to achieve their goals.** Its foundations include mathematics, logic, philosophy, probability, linguistics, neuroscience, and decision theory. Many fields fall under the umbrella of AI, such as computer vision, robotics, machine learning, and natural language processing.

**Machine learning is a subfield of artificial intelligence**. Its goal is to enable computers to learn on their own. A machine’s learning algorithm enables it to identify patterns in observed data, build models that explain the world, and predict things without having explicit pre-programmed rules and models.

```
**The AI effect: what actually qualifies as “artificial intelligence”?**

The exact standard for technology that qualifies as “AI” is a bit fuzzy, and interpretations change over time. The AI label tends to describe machines doing tasks traditionally in the domain of humans. Interestingly, once computers figure out how to do one of these tasks, humans have a tendency to say it wasn’t _really_ intelligence. This is known as the [**AI effect**](https://en.wikipedia.org/wiki/AI_effect).

For example, when IBM’s Deep Blue defeated world chess champion [Garry Kasparov](https://medium.com/@GarryKasparov) in 1997, people complained that it was using "brute force" methods and it wasn’t “real” intelligence at all. As Pamela McCorduck wrote, _“It’s part of the history of the field of artificial intelligence that every time somebody figured out how to make a computer do something — play good checkers, solve simple but relatively informal problems — there was chorus of critics to say, ‘that’s not thinking’”_([McCorduck, 2004](http://www.pamelamc.com/html/machines_who_think.html)).

Perhaps there is a certain _je ne sais quoi_ inherent to what people will reliably accept as “artificial intelligence”:

"AI is whatever hasn't been done yet." - Douglas Hofstadter

So does a calculator count as AI? Maybe by some interpretation. What about a self-driving car? Today, yes. In the future, perhaps not. Your cool new chatbot startup that automates a flow chart? Sure… why not.
```

### Strong AI will change our world forever; to understand how, studying machine learning is a good place to start

The technologies discussed above are examples of **artificial narrow intelligence (ANI)**, which can effectively perform a narrowly defined task.

Meanwhile, we’re continuing to make foundational advances towards human-level **artificial general intelligence (AGI),** also known as [**strong AI**](https://en.wikipedia.org/wiki/Artificial_general_intelligence). The definition of an AGI is an artificial intelligence that can successfully perform _any intellectual task that a human being can_, including learning, planning and decision-making under uncertainty, communicating in natural language, making jokes, manipulating people, trading stocks, or… reprogramming itself.

And this last one is a big deal. Once we create an AI that can improve itself, it will unlock a cycle of recursive self-improvement that could lead to an **intelligence explosion** over some unknown time period, ranging from many decades to a single day.

> Let an ultraintelligent machine be defined as a machine that can far surpass all the intellectual activities of any man however clever. Since the design of machines is one of these intellectual activities, an ultraintelligent machine could design even better machines; there would then unquestionably be an ‘intelligence explosion,’ and the intelligence of man would be left far behind. Thus the first ultraintelligent machine is the last invention that man need ever make, provided that the machine is docile enough to tell us how to keep it under control. — I.J. Good, 1965

You may have heard this point referred to as the **singularity**. The term is borrowed from the gravitational singularity that occurs at the center of a black hole, an infinitely dense one-dimensional point where the laws of physics as we understand them start to break down.

![](https://cdn-images-1.medium.com/max/800/1*rR4Hp7-pfgGBDqyPdcnh8g.png)

We have zero visibility into what happens beyond the event horizon of a black hole because no light can escape. Similarly, **after we unlock AI’s ability to recursively improve itself, it’s impossible to predict what will happen, just as** **mice who intentionally designed a human might have trouble predicting what the human would do to their world.** Would it keep helping them get more cheese, as they originally intended? (Image via [WIRED](http://www.wired.co.uk/article/what-black-holes-explained))

A recent report by the Future of Humanity Institute surveyed a panel of AI researchers on timelines forAGI, and found that **“researchers believe there is a 50% chance of AI outperforming humans in all tasks in 45 years”** ([Grace et al, 2017](https://arxiv.org/pdf/1705.08807.pdf))**.** We’ve personally spoken with a number of sane and reasonable AI practitioners who predict much longer timelines (the upper limit being “never”), and others whose timelines are alarmingly short — as little as a few years.

![](https://cdn-images-1.medium.com/max/800/0*2TpuuqUKnhdnr5eK.)

Image from Kurzweil’s The Singularity Is Near, published in 2005. Now, in 2017, only a couple of these posters could justifiably remain on the wall.

The advent of greater-than-human-level **artificial superintelligence (ASI)** could be one of the best or worst things to happen to our species.It carries with it the immense challenge of specifying what AIs will _want_ in a way that is friendly to humans.

While it’s impossible to say what the future holds, one thing is certain: **2017 is a good time to start understanding how machines think.** To go beyond the abstractions of a philosopher in an armchair and intelligently shape our roadmaps and policies with respect to AI, we must engage with the details of how machines see the world — what they “want”, their potential biases and failure modes, their temperamental quirks — just as we study psychology and neuroscience to understand how humans learn, decide, act, and feel.

```
There are complex, high-stakes questions about AI that will require  our careful attention in the coming years.

How can we combat AI’s propensity to [further entrench systemic biases](https://www.google.com/intl/en/about/gender-balance-diversity-important-to-machine-learning/) evident in existing data sets? What should we make of fundamental [disagreements among the world’s most powerful technologists](http://fortune.com/2017/07/26/mark-zuckerberg-argues-against-elon-musks-view-of-artificial-intelligence-again/) about the potential risks and benefits of artificial intelligence? What will happen to humans' sense of purpose in a world without work?
```

Machine learning is at the core of our journey towards artificial general intelligence, and in the meantime, it will change every industry and have a massive impact on our day-to-day lives. That’s why we believe it’s worth understanding machine learning, at least at a conceptual level — and we designed this series to be the best place to start.

### How to read this series

You don’t necessarily need to read the series cover-to-cover to get value out of it. Here are three suggestions on how to approach it, depending on your interests and how much time you have:

1.  **T-shaped approach.** Read from beginning to end. Summarize each section in your own words as you go (see: [Feynman technique](https://mattyford.com/blog/2014/1/23/the-feynman-technique-model)); this encourages active reading & stronger retention. Go deeper into areas that are most relevant to your interests or work. We’ll include resources for further exploration at the end of each section.
2.  **Focused approach.** Jump straight to the sections you’re most curious about and focus your mental energy there.
3.  [**80/20 approach**](https://www.thebalance.com/pareto-s-principle-the-80-20-rule-2275148)**.** Skim everything in one go, make a few notes on interesting high-level concepts, and call it a night. 😉

### About the authors

![](https://cdn-images-1.medium.com/max/800/1*UWNsFVQBaDW5dq1HnW9k4w.png)

“Ok, we have to be done with gradient descent by the time we finish this ale.” @ [The Boozy Cow](https://medium.com/@TheBoozyCow) in Edinburgh

[Vishal](https://www.linkedin.com/in/vishalmaini/) most recently led growth at [Upstart](https://www.upstart.com/about#future-of-credit-2), a lending platform that utilizes machine learning to price credit, automate the borrowing process, and acquire users. He spends his time thinking about startups, applied cognitive science, moral philosophy, and the ethics of artificial intelligence.

[Samer](https://www.linkedin.com/in/samer-sabri-8995a717/) is a Master’s student in Computer Science and Engineering at UCSD and co-founder of [Conigo Labs](http://www.conigolabs.com/). Prior to grad school, he founded TableScribe, a business intelligence tool for SMBs, and spent two years advising Fortune 100 companies at McKinsey. Samer previously studied Computer Science and Ethics, Politics, and Economics at Yale.

Most of this series was written during a 10-day trip to the United Kingdom in a frantic blur of trains, planes, cafes, pubs and wherever else we could find a dry place to sit. Our aim was to solidify our own understanding of artificial intelligence, machine learning, and how the methods therein fit together — and hopefully create something worth sharing in the process.

And now, without further ado, let’s dive into machine learning with [**Part 2.1: Supervised Learning**](https://medium.com/@v_maini/supervised-learning-740383a2feab)!

* * *

More from** Machine Learning for Humans** 🤖👶

*   **Part 1: Why Machine Learning Matters ✅**
*   [Part 2.1: Supervised Learning](https://medium.com/@v_maini/supervised-learning-740383a2feab)
*   [Part 2.2: Supervised Learning II](https://medium.com/@v_maini/supervised-learning-2-5c1c23f3560d)
*   [Part 2.3: Supervised Learning III](https://medium.com/@v_maini/supervised-learning-3-b1551b9c4930)
*   [Part 3: Unsupervised Learning](https://medium.com/@v_maini/unsupervised-learning-f45587588294)
*   [Part 4: Neural Networks & Deep Learning](https://medium.com/@v_maini/neural-networks-deep-learning-cdad8aeae49b)
*   [Part 5: Reinforcement Learning](https://medium.com/@v_maini/reinforcement-learning-6eacf258b265)
*   [Appendix: The Best Machine Learning Resources](https://medium.com/@v_maini/how-to-learn-machine-learning-24d53bb64aa1)

#### Contact: [ml4humans@gmail.com](mailto:ml4humans@gmail.com)

A special thanks to [_Jonathan Eng_](https://www.linkedin.com/in/jonathaneng1/)_,_ [_Edoardo Conti_](https://www.linkedin.com/in/edoardoconti/)_,_ [_Grant Schneider_](https://www.linkedin.com/in/grantwschneider/)_,_ [_Sunny Kumar_](https://www.linkedin.com/in/sunnykumar1/)_,_ [_Stephanie He_](https://www.linkedin.com/in/stephanieyhe/)_,_ [_Tarun Wadhwa_](https://www.linkedin.com/in/tarunw/)_, and_ [_Sachin Maini_](https://www.linkedin.com/in/sachinmaini/) (series editor) for their significant contributions and feedback.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
