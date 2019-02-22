> * 原文地址：[medium.com](https://medium.com/thelaunchpad/what-is-the-next-big-thing-in-ai-and-ml-904a3f3345ef)
> * 原文作者：[Max Grigorev](https://medium.com/@forwidur)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/keeping-up-with-ai-in-2019.md](https://github.com/xitu/gold-miner/blob/master/TODO1/keeping-up-with-ai-in-2019.md)
> * 译者：
> * 校对者：

# Keeping up with AI in 2019: What is the next big thing in AI and ML?

The past year has been rich in events, discoveries and developments in AI. It is hard to sort through the noise to see if the signal is there and, if it is, what is the signal saying. This post attempts to get you exactly that: I’ll try to extract some of the patterns in the AI landscape over the past year. And, if we are lucky, we’ll see how some of the trends extend into the near future.

> Confucius is quoted saying: “The hardest thing of all is to find a black cat in a dark room, especially if there is no cat.” Wise man.

![](https://cdn-images-1.medium.com/max/1600/0*NVLoi3vu-9kry4t2)

See that cat?

Make no mistake: this is an opinion piece. I am not trying to establish some comprehensive record of accomplishments for the year. I am merely trying to outline **some** of these trends. Another caveat : this review is US-centric. A lot of interesting things are happening, say, in China, but I, unfortunately, am not familiar with that exciting ecosystem.

Who is this post for? If you are still reading, it is probably for you: an engineer, who wants to widen their horizons; an entrepreneur, looking where to direct their energy next; a venture capitalist, looking for their next deal; or just a technology cheerleader, who can’t wait to see where this whirlwind is taking us next.

### Algorithms

The algorithmic discourse was, undoubtedly, dominated by the Deep Neural Networks. Of course, you would hear about someone deploying a “classical” machine learning model (like Gradient Boosted trees or Multi-armed bandits) here and there. And claiming that it’s the only thing anyone ever needed. There are proclamations, that [deep learning is at its death throes](https://www.technologyreview.com/s/612768/we-analyzed-16625-papers-to-figure-out-where-ai-is-headed-next/). Even top researchers are questioning the [efficiency](https://arxiv.org/abs/1711.11561) and [robustness](https://arxiv.org/abs/1811.02553) of some DNN architectures. But, like it or not, DNNs were everywhere: in self-driving cars, natural language systems, robots — you name it. None of the leaps in DNNs were as pronounced as in **Natural Language Processing**, **Generative Adversarial Networks**, and deep **Reinforcement Learning**.

#### Deep NLP: BERT et al.

Though before 2018 there had been several breakthroughs in using DNNs for text (word2vec, GLOVE, LSTM-based models come to mind), one key conceptual element was missing: [transfer learning](https://machinelearningmastery.com/transfer-learning-for-deep-learning/). That is, training a model on a large amount of publicly available data, and then “fine-tuning” it on the specific dataset you are working with. In computer vision, using the patterns discovered on the famous ImageNet dataset to a specific problem was, usually, a part of a solution.

The problem was, the techniques used for transfer learning didn’t really apply well to NLP problems. In some sense, the pre-trained embeddings like word2vec were filling that role, but they work on a single word level and fail to capture the high level structure of language.

In 2018, however, this has changed. [ELMo](https://allennlp.org/elmo), contextualized embeddings became the first significant step to improved transfer learning in NLP. [ULMFiT](https://arxiv.org/abs/1801.06146) went even further: not satisfied with the semantic capturing capability of embeddings, the authors figured out a way to do a transfer learning for the entire model.

![](https://cdn-images-1.medium.com/max/1600/0*S5L044q215w-mg6j)

The important guy.

But the most interesting development was, definitely, the introduction of [BERT](https://ai.googleblog.com/2018/11/open-sourcing-bert-state-of-art-pre.html). By letting the language model learn from the entire collection of articles from English Wikipedia, the team was able to achieve state-of-the-art results on 11 NLP tasks — quite a feat! Even better, both the code and the pre-trained modes were published online — so you can apply this breakthrough to your own problem.

#### Many Faces of GANs

![](https://cdn-images-1.medium.com/max/1600/0*4CIByVmyt17M-iQW)

CPU speeds are not growing exponentially any more, but the number of academic papers on Generative Adversarial Networks surely seems to be continuing to grow. GANs have been an academic darling for many years now. The real life applications seem to be few and far between though, and it changed very little in 2018. Still GANs have amazing potential waiting to be realized.

A new approach, that emerged, was an idea of progressively growing GANs: getting the generator to increase the resolution of its output progressively throughout the training process. One of the more impressive papers that used this approach was employing [style transfer techniques to generate realistic looking photos](https://arxiv.org/abs/1812.04948). How realistic? You tell me:

![](https://cdn-images-1.medium.com/max/1600/0*Sn_Uz3dzQzkw0AJu)

Which one of this photos is of a real person? Trick question: none of them are.

How and why do the GANs really work though? We haven’t had deep insight into that yet, but there are important steps being made: a team at MIT has done a [a high quality study](https://arxiv.org/abs/1811.10597) of that problem.

Another interesting development, though not technically a GAN, was [Adversarial Patch](https://arxiv.org/pdf/1712.09665.pdf). The idea was to use both black-box (basically, not looking at the internal state of a neural network) and white-box methods to craft a “patch”, that would deceive a CNN-based classifier. This is an important result: it guided us towards better intuition about _how_ DNNs work and how far we are still from a human-level conceptual perception.

![](https://cdn-images-1.medium.com/max/1600/0*lJRt4MvyHBfVg2RR)

Can you tell a the banana from a toaster? AI still can’t.

#### We need Reinforcement

Reinforcement learning has been in the spotlight since [AlphaGo defeated Lee Sedol](https://en.wikipedia.org/wiki/AlphaGo_versus_Lee_Sedol) in 2016. With AI dominating the last “classic” game though, what else there is to conquer? Well, the rest of the world! Specifically, computer games and robotics.

For it’s training, reinforcement learning relies on the “reward” signal, a scoring of how well it did in it’s last attempt. Computer games provide a natural environment, where such signal is readily available, as opposed to the real life. Hence all the attention RL researches are giving to teaching AI how to play Atari games.

Talking about DeepMind, their new creation, [AlphaStar](https://deepmind.com/blog/alphastar-mastering-real-time-strategy-game-starcraft-ii/) just made news again. This new model has defeated one of the top StarCraft II professional players. StarCraft is much more complex than chess or Go, with a huge action space and crucial information hidden from a player, unlike in most board games. This victory is a very significant leap for the field as a whole.

OpenAI, another important player in the space or RL, did not sit idle either. Their claim to fame is OpenAI Five, a system that in August defeated a team of 99.95th percentile players in Dota 2, an extremely complex esports game.

Though OpenAI has been giving a lot of attention to computer games, they haven’t ignored a real potential application for RL: robots. In real world, the feedback one might give to a robot is rare and expensive to create: you basically need a human babysitting your R2D2, while it’s trying to take its first “steps”. And you need millions of these data points. To bridge that gap, the recent trend was to learn to simulate an environment and run a large number of those scenarios in parallel to teach a robot basic skills, before moving on to the real world. Both [OpenAI](https://blog.openai.com/generalizing-from-simulation/) and [Google](https://ai.googleblog.com/2018/06/scalable-deep-reinforcement-learning.html) are working on that approach.

#### Honorable mention: Deepfakes

Deepfakes are images or videos that show (usually) a public figure doing or saying something they never did or said. They are created by training a GAN on a large amount of footage of the “target” person, and then generating new media with desired actions performed in it. A desktop application called FakeApp released in January 2018 allows anyone with a computer and zero computer science knowledge to create deepfakes. And while the videos it produces can be easily spotted as non genuine, the technology has progressed very far. Just watch this [video](https://youtu.be/cQ54GDm1eL0) to see how much.

Thanks, Obama?

### Infrastructure

#### TensorFlow vs PyTorch

There are many deep learning frameworks out there. The field is vast, and this variety makes sense on the surface.But in practice, lately most people were using either Tensorflow or PyTorch. If you cared about reliability, ease of deployment, model re-loading, the things that SREs usually care about, you probably chose Tensorflow. If you were writing a research paper, and didn’t work for Google — you probably used PyTorch.

#### ML as a service everywhere

This year we saw even more AI solutions, packaged as an API for consumption by a software engineer not blessed with a machine learning PhD from Stanford. Both Google Cloud and Azure improved the old services and added new ones. AWS Machine Learning service list is starting to look seriously intimidating.

![](https://cdn-images-1.medium.com/max/1600/0*NeMASS_FiI3NruBW)

Man, AWS will soon need 2-level folder hierarchy for their services.

Multiple startups threw their gauntlets down, though the frenzy has cooled down a little bit. Everyone is promising speed of model training, ease of use during inference and amazing model performance. Just type in your credit card, upload your dataset, give the model some time to train or finetune, call a REST (or, for more forward looking startups, GraphQL) API and become the master of AI without ever figuring out what dropout is.

With that wealth of choice, why would anyone even bother building out a model and infrastructure themselves? In practice, it seems, off the shelf MLaaS products do very well with 80% of use cases. If you want the remaining 20% to work well too — you are out of luck: not only you can’t really choose the model, you can’t even control the hyperparameters. Or if you need to do inference somewhere outside the comfort of the cloud — you usually can’t. Definitely a tradeoff here.

#### Honorable mention: AutoML and AI Hub

The two particularly interesting services, unveiled this year, were both launched by Google.

First, [Google Cloud AutoML](https://cloud.google.com/automl/), is a set of custom NLP and computer vision model training products. What does that mean? AutoML designers solve model customization by automatically fine-tuning several pre-trained ones and choosing the one that performs best. This means that you, most likely, won’t need to bother with customizing the model yourself. Of course, if you want to do something really new or different, this service is not for you. But, as a side benefit, Google pre-trains their models on a large amount of proprietary data. Think of all those [cat pictures](https://www.google.com/search?tbm=isch&q=kitten); those must generalize way better than just Imagenet!

Second, [AI Hub](https://cloud.google.com/ai-hub/) and [TensorFlow Hub](https://www.tensorflow.org/hub). Before those two, re-using someone’s model was a real chore. Random code off GitHub rarely worked, was usually poorly documented and is, generally, not a joy to deal with. And the pre-trained weights for transfer learning… let’s say you don’t want to even try to get those to work. That’s exactly the problem TF Hub was built to solve: it’s a reliable, curated repository of models you can fine-tune or build upon. Just include a couple of lines of code — and the TF Hub client will fetch both the code and corresponding weights from Google’s servers — and _voilá_, it just works! AI Hub goes further: it allows you to share entire ML pipelines, not just models! It’s still in alpha, but it’s already better than a random repository with the newest file “modified 3 years ago”, if you know what I mean.

### Hardware

#### Nvidia

If you were serious about ML in 2018, especially DNNs, you were using a GPU (or multiple). In its turn, the GPU leader had a very busy year. On the heels of the cooling of crypto frenzy and the subsequent stock price plunge, Nvidia has released an entire generation of new consumer grade cards based on Turing architecture. Just with the professional cards released in 2017 and based on the Volta chips, the new cards contain new high-speed matrix multiplication hardware, called Tensor Cores. Matrix multiplication lies at the core of how DNNs operate, so speeding up those operations will greatly increase the speed of neural network training on the new GPUs.

For those, not satisfied with the “small” and “slow” gaming GPUs, Nvidia updated their enterprise “supercomputer”. DGX-2 is a monster box with 16 Tesla Vs for 480 TFLOPs of FP16 operations. The price got updated too, to an impressive $400,000.

The autonomous hardware got updated too. Jetson AGX Xavier is a board that, Nvidia hopes, is going to power the next generation of self-driving cars. An eight-core CPU, a vision accelerator, deep learning accelerator — everything the growing autonomous driving industry needs.

In an interesting development, Nvidia launched a DNN-based feature for their gaming cards: Deep Learning Super Sampling. The idea is to replace anti-aliasing, that is currently mostly done by rendering a picture in higher resolution than required (say 4x) and then scaling it to the native monitor resolution. Now Nvidia allows developers to train an image transformation model on the game running at extremely high quality before releasing it. Afterwards, the game is shipped to the end users with that pre-trained model. During a game session, instead of incurring the cost of old-style anti-aliasing, the frames are run through that model to improve the picture quality.

#### Intel

Intel was definitely not a trailblazer in the world of AI hardware in 2018. But it seems they would like to change that.

Most activity happened, surprisingly, in the field of software. Intel is trying to make their existing and upcoming hardware to be more developer-friendly. With that in mind, they’ve released a pair of (surprisingly, competing) toolkits: [OpenVINO](http://www.openvino.org/) and [nGraph](https://www.intel.ai/ngraph-a-new-open-source-compiler-for-deep-learning-systems/#gs.zJSQNhZI).

They’ve updated their [Neural Compute Stick](https://newsroom.intel.com/news/intel-unveils-intel-neural-compute-stick-2/): a small USB device, that can accelerate DNNs running on anything with USB port, even a Raspberry Pi.

And there was more and more intrigue around a rumored Intel discrete GPU. The gossip is becoming more and more persistent, but it remains to be seen how applicable the new device will be to the DNNs training. What will definitely be applicable to deep learning are the pair of rumored specialized deep learning cards, codenamed Spring Hill and Spring Crest, the latter being based on the technology of Nervana, a startup Intel acquired several years ago.

#### Custom hardware from the usual (and unusual) suspects

Google unveiled their 3rd generation [TPUs](https://en.wikipedia.org/wiki/Tensor_processing_unit): an ASIC-based DNN-specific accelerator with an amazing 128Gb of HMB memory. 256 such devices are assembled into a pod with over a hundred petaflops of performance. This year, instead of just teasing the rest of the world with the power of these devices, Google [made the TPUs available](https://cloud.google.com/tpu/) to general public on Google Cloud.

In a similar move, but mostly directed towards inference applications, Amazon has deployed [AWS Inferentia](https://aws.amazon.com/machine-learning/inferentia/): a cheaper, more efficient way to run the models in production.

![](https://cdn-images-1.medium.com/max/1600/0*nTqHAwzY8MINf5j-)

Google also announced [Edge TPU](https://cloud.google.com/edge-tpu/): a little brother of the big bad cards discussed above. The chip is tiny: 10 of them would fit on a surface of a 1 cent coin. At the same time, it’s good enough to run DNNs on real-time video and barely consumes any energy.

An interesting potential new entrant is [Graphcore](https://www.graphcore.ai/). The British company has raised an impressive $310M, and in 2018 has shipped their first product, the GC2 chip. According to [benchmarks](https://cdn2.hubspot.net/hubfs/729091/NIPS2017/NIPS%2017%20-%20benchmarks%20final.pdf), GC2 obliterates the top Nvidia server GPU card while doing inference, while consuming significantly less power.

#### Honorable mention: AWS Deep Racer

In a completely unexpected move, but, somewhat mirroring their previous move with [DeepLens](https://aws.amazon.com/deeplens/), Amazon unveiled a small-scale self-driving car, [DeepRacer](https://aws.amazon.com/deepracer/) and a racing league for it. The $400 car sports an Atom processor, 4MP camera, wifi, several USB ports and enough power to run for several hours. Self-driving models can be trained using a 3d simulation environment completely in the cloud and then deployed directly to the car. If you always dreamed of building your own self-driving car, this is your chance to do so without starting a VC-backed company.

### What’s next?

#### Shifting focus to decision intelligence

Now that the components — algorithms, infrastructure, and hardware — for making AI useful are better than ever, businesses are realizing that the biggest stumbling block to getting started with applying AI is on the [practical side](http://bit.ly/quaesita_fail): how do you actually take an AI applied from an idea to an effective, safe, reliable system running in production? Applied AI, or applied Machine Learning (ML), also referred to as [Decision Intelligence](http://bit.ly/di_wiki), is the science of creating AI solutions to real-world problems. While the past put much of the focus on the science behind the algorithms, the future is likely to see more equal attention paid to the end-to-end application side of the field.

#### AI seems to be creating more jobs than it destroys

“AI will take all our jobs” is the common refrain in the media and a common fear among blue collar and white collar workers alike. And, on the surface it seems like a reasonable prediction. But so far, the opposite seems to be the truth. For instance, a lot of people [are getting paid to create labeled datasets](https://www.nytimes.com/2018/11/25/business/china-artificial-intelligence-labeling.html).

It goes beyond the usual data farms in low income countries: several apps, like LevelApp allow refugees to make money by labeling their data just using their cellphones. Harmoni went further: they are even providing devices to the migrants in the refugee camps so that people can contribute and make a living.

On top of data labeling, entire industries are being created by the new AI technology. We are able to do things, that were unthinkable even several years ago, like self driving cars or [drug discovery](https://blog.benchsci.com/startups-using-artificial-intelligence-in-drug-discovery).

#### More ML-related compute is going to happen on the edge

The way data-oriented systems work, more data is usually available at the very edge of the system, on the ingestion side. Later stages of a pipeline usually down-sample or in other ways reduce the the fidelity of the signals. On the other hand, with increasingly complex AI models are performing better with more data. Would not it make sense to move the AI component closer to the data, to the edge?

A simple example: imagine a high resolution camera, that produces a high-quality video at 30fps. The computer vision model, that processes that video, runs on a server with. The camera streams the video to the server, but the uplink bandwidth is limited, so the video is shrunk and highly-compressed. Why not move the vision model to the camera and consume the pristine video stream?

There were always multiple hurdles with that, primarily: the amount of compute capability available on the edge devices and the complexity of management (such as pushing updated models to the edge). The compute limitation is being cancelled out by the advent of specialized hardware (such as Google’s Edge TPU, Apple’s Neural Engine etc.), more efficient models and optimized software. The management complexity is constantly addressed by improvements in ML frameworks and tooling.

#### Consolidation in the AI infrastructure space

The preceding years were full of activity in AI infrastructure: grand announcements, hefty funding rounds and lofty promises. In 2018, it seems, the race in the space cooled down, and, while there were still significant new entrances, most of the contributions were done by large existing players.

One of the possible explanations maybe that our understanding of what the ideal infrastructure for an AI system looks like is [not mature enough](https://ai.google/research/pubs/pub43146). As the problem is complex. It will require long term, persistent, focused, well-resourced effort to produce a viable solution — something startups and smaller companies are just not good at. It would be really surprising, if a startup “solved” AI infra out of the blue.

On the other hand, ML infrastructure engineers are rare and far between. A struggling startup with several of those on staff becomes an obvious and valuable acquisition target for a larger player. And there are at least several of those playing this game for the win, both building out internal and external tooling. For instance, for both AWS and Google Cloud, AI infrastructure services are a major selling points.

Put it all together and a major consolidation of the space becomes a reasonable forecast.

#### Even more custom hardware

[Moore’s law is dead](https://www.nextplatform.com/2019/02/05/the-era-of-general-purpose-computers-is-ending/), at least for CPUs, and has been for many years now. GPUs are soon going to encounter a similar fate. And while our models are becoming more efficient, to solve some more advanced problems we’ll need to get our hands on more computing power. This can be solved with distributed training, but it has its own limits and tradeoffs.

Moreover, if you want to run some of the bigger models on a resource-constrained device, distributed training is not going to help. Enter custom AI accelerators. Depending on how custom you want or can go, you could [save an order of magnitude](http://web.eecs.umich.edu/~shihclin/papers/AutonomousCar-ASPLOS18.pdf) of power, cost or [latency](https://www.microsoft.com/en-us/research/wp-content/uploads/2016/10/Cloud-Scale-Acceleration-Architecture.pdf).

In some way, even Nvidia’s Tensor Cores are an example of this trend. With no general-purpose hardware, we will see even more of those.

#### Less reliance on training data

Labeled data is, generally, either expensive, inaccessible or both. There are few exceptions to this rule. Open high quality datasets like MNIST, ImageNet, COCO, Netflix prize and IMDB reviews were a source of incredible innovation. But many problems don’t have a corresponding dataset to work with. While building a dataset is not a great career move for a researcher, big companies, who could sponsor or release one are not in a hurry: they are building the huge datasets alright, but keeping those close to their chest.

So how does a small independent entity, like startup or a university research group, produce interesting solutions to hard problems? By building systems that rely less and less on supervised signals and more and more on unlabeled and unstructured data — which is abundant thanks to the internet and proliferation in cheap sensors.

This somewhat explains the explosion of interest in GANs, transfer and reinforcement learning: all of these techniques require less (or no) investment in a training dataset.

### So, it’s all just a bubble, right?

So is there a cat in that dark room? I think there definitely is, and not just one, but multiple. And while some of cats have four legs, tails, and whiskers — you know, the usual deal — some are weird beasts that we are only starting to see the basic outlines of.

The industry has entered year seven of the hot AI “summer”. An amazing amount of research effort, academic grants, venture capital, media attention and lines of code were poured into the space over that time. But one would be justified in pointing out, that the promises of AI are still mostly unfulfilled. That their last Uber ride still had a human driver behind the wheel. That they there is still no helpful robot making eggs in the morning. I even have to tie my shoelaces myself, for crying out loud!

And yet, the efforts of countless graduate students and software engineers are not in vain. It seems like every large company either already relies heavily on AI, or has plans to in the future. [AI art sells](https://www.nytimes.com/2018/10/25/arts/design/ai-art-sold-christies.html). If the self driving cars are not yet here, they soon will be.

Now, if only someone figured out those pesky shoelaces! Wait, what? [They did](https://www.theverge.com/2019/2/4/18210711/puma-fi-self-lacing-shoes-nike-hyperadapt-bb)?

* [Click here](https://www.youtube.com/embed/nU-XDVyYqMs) to watch the full video.

_Huge thanks to Malika Cantor, Maya Grossman, Tom White, Cassie Kozyrkov and Peter Norvig for reading the draft versions of this post._

[_Max Grigorev_](https://www.linkedin.com/in/grigorev/) _has built ML systems at Google, Airbnb and multiple startups. He hopes to build many more. He is also a_ [_Google Developers Launchpad_](https://developers.google.com/programs/launchpad/) _mentor._

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
