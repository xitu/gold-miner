> * 原文地址：[12 new Project Debater AI technologies available as cloud APIs](https://www.ibm.com/blogs/research/2021/03/project-debater-api/)
> * 原文作者：[Project Debater research team](https://www.ibm.com/blogs/research/author/project-debateril-ibm-com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/ibm-12-project-debater-api.md](https://github.com/xitu/gold-miner/blob/master/article/2021/ibm-12-project-debater-api.md)
> * 译者：
> * 校对者：

# 12 new Project Debater AI technologies available as cloud APIs

Argumentation and debating are fundamental capabilities of our human intelligence. Until recently, they have been totally out of reach of AI.

In February 2019 and after six years of work by natural language processing and machine learning researchers and engineers, an IBM AI dubbed Project Debater became [the first AI system able to debate humans over complex topics](https://ibm.biz/debater-event).

And while it may not have ‘won’ the sparring against debate champion Harish Natarajan in San Francisco that year, Project Debater [demonstrated how AI could help people build persuasive arguments and make well-informed decisions](https://ibm-research.medium.com/augmenting-humans-ibms-project-debater-ai-gives-human-debating-teams-a-hand-at-cambridge-69a29bcd4eff). The AI became the third in the series of IBM Research AI’s grand challenges, following Deep Blue and Watson.

In our recent paper “[An autonomous debating system](https://eorder.sheridan.com/3_0/app/orders/11030/files/assets/common/downloads/Slonim.pdf)” published in *Nature*, we describe Project Debater’s architecture and evaluate its performance. We also [offer free access](https://early-access-program.debater.res.ibm.com/academic_use.html) for academic use to 12 of Project Debater’s underlying technologies as cloud APIs, as well as trial and licensing options for developers.

To debate humans, an AI must be equipped certain skills. It has to be able to pinpoint relevant arguments for a given debate topic in a massive corpus, detect the stance of arguments and assess their quality. It also has to identify general, recurring arguments that are relevant for the specific topic, organize the different types of arguments into a compelling narrative, recognize the arguments made by the human opponent, and make a rebuttal. And it has to be able to use competitive debate techniques, such as asking the opponent questions to frame the discussion in a way that favors its position.

This is exactly what we’ve done with Project Debater. It’s been developed as a collection of components, each designed to perform a specific subtask. Over the years, we published more than 50 [papers](https://www.research.ibm.com/artificial-intelligence/project-debater/research/) describing these components and released many related [datasets](https://www.research.ibm.com/haifa/dept/vst/debating_data.shtml) for academic use.

## Building debating skills

To engage in a debate successfully, a machine requires high level of accuracy from each component. For example, failing to detect the argument’s stance may result in arguing in favor of your opponent – a dire situation in a debate.

This is why it was crucial for us to collect uniquely large-scale, high-quality labeled training datasets for Project Debater. The evidence detection classifier, for instance, was trained on 200,000 labeled examples, and [achieved a remarkable precision](https://arxiv.org/abs/1911.10763) of 95 percent for top 40 candidates.

Another major challenge was scalability. For example, we had to apply “wikification” (identifying mentions of Wikipedia concepts) to our 10 billion-sentence corpus – an impossible task for any existing Wikification tools. So, we [developed a new, fast wikification algorithm](https://arxiv.org/abs/1908.06785) that could be applied to massive corpora and achieve competitive accuracy.

Project Debater’s APIs give access to different capabilities originally developed for the live debating system, as well as related technologies we have developed more recently. The APIs include natural language understanding capabilities that deal with wikification, semantic relatedness [between Wikipedia concepts](https://www.aclweb.org/anthology/L18-1408.pdf), short text clustering, and common theme extraction for texts.

The core set of APIs relates to services for argument mining and analysis. These services include [detection of sentences containing claims and evidence](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&ved=2ahUKEwjezKWPgbXvAhU1JMUKHXjwDQkQFjAAegQIAhAD&url=https%3A%2F%2Farxiv.org%2Fabs%2F1911.10763&usg=AOvVaw0eUm-tVPfKf0OpVrVKvSWh), detecting [claim boundaries](https://www.aclweb.org/anthology/C14-1141/) in a sentence, argument [quality assessment](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&ved=2ahUKEwi43fGrgbXvAhVL2KQKHZt2BLUQFjABegQIAxAD&url=https%3A%2F%2Farxiv.org%2Fabs%2F1911.11408&usg=AOvVaw2vnRuQaiZZ4yLfqoQ4GFur) and [stance classification](https://www.aclweb.org/anthology/E17-1024.pdf) (Pro/Con).

Then there are APIs for two high-level services that create different kinds of summaries*,* Narrative Generation and Key Point Analysis. When given a set of arguments, Narrative Generation constructs a well-structured speech that supports or contests a given topic, according to the specified polarity.

And Key Point Analysis is a new and promising approach for summarization, with an important quantitative angle. This service summarizes a collection of comments on a given topic as a small set of key points, and the prominence of each key point is given by the [number of its matching sentences](https://www.aclweb.org/anthology/2020.acl-main.371.pdf) in the [given comments](https://www.aclweb.org/anthology/2020.emnlp-main.3.pdf).

## Developers are welcome

Key Points Analysis and Narrative Generation have been recently demonstrated in the *[“That’s Debatable”](https://www.research.ibm.com/artificial-intelligence/project-debater/thats-debatable/)* television series and in the *[“Grammy Debates with Watson”](https://www.grammy.com/watson)* backstage experience, where they summarized pro and con arguments contributed online by thousands of people, discussing debate topics ranging from social questions to pop culture.

Developers can access the Project Debater API documentation as guests on the [main documentation site](https://early-access-program.debater.res.ibm.com/). They can login as guests, view the documentation and run online interactive demos of most of the services. They can also see the code of complete end-to-end examples using these services.

![https://www.ibm.com/blogs/research/wp-content/uploads/2021/03/debater-getting-started.jpg](https://www.ibm.com/blogs/research/wp-content/uploads/2021/03/debater-getting-started.jpg)

One example is Mining to Narrative. Given a controversial topic, it demonstrates the creation of a narrative by mining content from a Wikipedia corpus. Another one uses Debater Services to analyze free text surveys for themes, where it identifies themes based on Wikipedia concepts.

Before developers can run code examples or use the Project Debater APIs in their own project, they need to obtain an API key and download the SDK. To request an API key, please visit **[Project Debater for Academic Use](https://early-access-program.debater.res.ibm.com/academic_use.html)** or send an an e-mail request to [project.debater@il.ibm.com](mailto:project.debater@il.ibm.com). You will receive a username and password to login to the Early Access website and can then obtain your personal API key from the API-key tab.

Slonim, N., Bilu, Y., Alzate, C., *et al.* [An autonomous debating system](https://eorder.sheridan.com/3_0/app/orders/11030/files/assets/common/downloads/Slonim.pdf). *Nature* (2021). https://doi.org/10.1038/s41586-021-03215-w

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
