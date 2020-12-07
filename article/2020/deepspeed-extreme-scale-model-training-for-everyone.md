> * 原文地址：[DeepSpeed: Extreme-scale model training for everyone](https://www.microsoft.com/en-us/research/blog/deepspeed-extreme-scale-model-training-for-everyone/)
> * 原文作者：[DeepSpeed Team](https://www.microsoft.com/en-us/research/project/deepspeed/#!people) [Rangan Majumder](https://www.microsoft.com/en-us/research/people/ranganm/)、Vice President [Junhua Wang](https://www.microsoft.com/en-us/research/people/junhuaw/)、VP、Distinguished Engineer
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/deepspeed-extreme-scale-model-training-for-everyone.md](https://github.com/xitu/gold-miner/blob/master/article/2020/deepspeed-extreme-scale-model-training-for-everyone.md)
> * 译者：
> * 校对者：[zhuzilin](https://github.com/zhuzilin)

# DeepSpeed：所有人都能用的超大规模模型训练工具

我们于今年2月份[发布了DeepSpeed](https://www.microsoft.com/en-us/research/blog/zero-deepspeed-new-system-optimizations-enable-training-models-with-over-100-billion-parameters/)，一个开源深度学习训练优化库，以及库中包含的一个新的显存优化技术——ZeRO（零冗余优化器），通过提升规模、速度，控制成本，提升可用性，极大地推进了大模型训练能力。DeepSpeed让研究人员能创造出图灵自然语言生成模型([Turing-NLG](https://www.microsoft.com/en-us/research/blog/turing-nlg-a-17-billion-parameter-language-model-by-microsoft))，其在发表时为世界上最大的语言模型（拥有170亿参数），并有着最佳的精度。我们在5月份[发布了ZeRO-2](https://www.microsoft.com/en-us/research/blog/zero-2-deepspeed-shattering-barriers-of-deep-learning-speed-scale/)——支持以10倍于当前最先进水平的速度训练有2000亿参数的模型——以及一系列计算、IO和收敛优化功能，从而助力最快速的BERT训练。自那时起，我们持续高速地进行创新，向前推动着深度学习模型训练的速度和规模的边界。

今天，我们非常开心地来分享一些新的进展，这些进展不仅将深度学习训练推至极限，同时也让这份技术的使用范围更加广泛——上至数据科学家们在超算上训练，下至在低端集群甚至仅仅一张GPU上训练。具体来说，DeepSpeed加入了4项系统性新技术来进一步拓展我们的[AI at Scale](https://www.microsoft.com/en-us/research/project/ai-at-scale/)倡议。它们也为微软的AI产品与平台提供创新。这些技术提供了极为高效的计算、显存和通信的利用效率，并助力我们训练十亿至万亿量级的模型。这些技术也让超长序列化输入变得可能，并从GPU单卡、至千卡级别的高端集群、至慢速以太网上的低端集群上均可以使用。

* **用3D并行化实现万亿参数模型训练：** DeepSpeed实现了三种并行方法的灵活组合：ZeRO支持的数据并行，流水线并行和张量切片模型并行。3D并行性适应了不同工作负载的需求，以支持具有**万亿**参数的**超大型模型**，同时实现了近乎完美的显存扩展性和吞吐量扩展效率。此外，其提高的通信效率使用户可以在网络带宽有限的常规群集上以2-7倍的速度训练有数十亿参数的模型。
* **用ZeRO-Offload让单卡能够训练10倍大的模型：** 我们扩展了ZeRO-2以利用CPU和GPU内存来训练大型模型。使用带有**单张英伟达V100 GPU**的机器，我们的用户在不耗尽显存的情况下运行**多达130亿个参数的模型**，模型规模扩展至现有方法的10倍，并保持有竞争力的吞吐量。此功能使数十亿参数的模型训练更加亲民，并为许多深度学习从业人员打开了一扇探索更大更好的模型的窗户。
* **通过DeepSpeed Sparse Attention用6倍速度执行10倍长的序列：** DeepSpeed提供了稀疏attention kernel——一种工具性技术，可支持长序列的模型输入，包括文本输入，图像输入和语音输入。与经典的稠密Transformer相比，它支持的**输入序列长一个数量级**，并在保持相当的精度下获得最高6倍的执行速度提升。它还比最新的稀疏实现快1.5–3倍。此外，我们的稀疏kernel灵活支持稀疏格式，使用户能够通过自定义稀疏结构进行创新。
* **1比特Adam减少5倍通信量：** Adam是一个训练大规模深度学习模型的有效的（也许是最广为应用的）优化器。然而，它与通信效率优化算法往往不兼容。因此，在跨设备进行分布式扩展时，通信开销可能成为瓶颈。我们推出了一种1比特Adam新算法，以及其高效实现。该算法**最多可减少5倍通信量**，同时实现了与Adam相似的收敛率。在通信受限的场景下，我们观察到3.5倍的分布式训练速度提升，这使得该算法可以扩展到不同类型的GPU群集和网络环境。

[![a screenshot of a cell phone](https://www.microsoft.com/en-us/research/uploads/prod/2020/09/Blog_DeepSpeed3_MainHero_HighRes-1024x636.jpg)](https://www.microsoft.com/en-us/research/uploads/prod/2020/09/Blog_DeepSpeed3_MainHero_HighRes-1024x636.jpg)

这篇博文将深入探究这4项技术。我们已经将这些激动人心的优化技术公布在了[开源项目DeepSpeed](https://github.com/microsoft/DeepSpeed)中。

## 3D并行：拓宽至万亿参数模型

随着现代GPU群集上计算量的快速增长，训练具有令人难以置信的功能的强大万亿参数模型不再是遥不可及的梦想，而是不远的将来。DeepSpeed结合了三项强大的技术，可以训练数万亿规模的模型并扩展到数千个GPU：数据并行训练，模型并行训练和流水线并行训练。这三者的共生让深度学习训练的规模远远超出了单独使用每种策略可以企及的。3D并行同时解决了训练万亿参数模型的两个基本挑战：**显存效率**和**计算效率**。因此，DeepSpeed可以扩展至在显存中放下最巨大的模型，而不会牺牲速度。

##### 了解训练巨大模型的显存和计算效率的挑战

**显存效率：** 训练万亿参数模型所需的显存远远超出了单张GPU所能承载的。在使用Adam优化器进行混合精度训练时的模型状态量（参数、梯度和优化器状态量）就需要约16TB的显存。作为比较，最先进的英伟达A100 GPU只有40 GB的显存。仅仅为了存储模型状态，就需要400张这样的GPU。

激活函数额外消耗的显存随batch大小而增加。batch设置为1的情况下，训练万亿参数模型就会产生超过1 TB的激活函数用的显存（后文称为激活显存）。用**checkpoint**处理激活显存，用计算来换显存，可以将该显存减少到大约20 GB，但是对于训练而言仍然过高了。

必须在多个GPU设备之间有效地划分模型状态量和激活显存，才能让这种样的大模型在不耗尽显存的情况下开始训练。

**计算效率：**经估算端到端训练一个万亿参数的模型大约需要5000 Zflops（即5后面带有** 24个零**；这个估算结果基于OpenAI的研究[law of scaling](https://arxiv.org/abs/2001.08361)）。这意味着训练这样一个模型需要4000张A100以50％的计算效率运行大约100天。

尽管大型超级计算GPU集群可以拥有超过4000个GPU，但是由于batch大小的限制，要在这种规模上实现高计算效率仍然是一项挑战。计算效率随着计算时间对通信时间的比例的增加而增加。该比例与batch大小成正比。但是，训练模型的batch大小有一个上限——超过这个上限收敛情况会明显变差。

实际上最大的模型之一，[GPT-3](https://arxiv.org/abs/2005.14165)是用约1500的batch大小训练的。用大约4000张GPU, 即使我们可以自由设置batch大小为4000，每张卡上的batch大小也只有1，这将影响扩展性。

##### 了解数据，模型和流水线并行性的权衡

**数据并行**是深度学习中的一种普遍使用的技术。在该技术中，每批输入的训练数据都在数据并行的worker之间平分。反向传播后需要通信并规约梯度，以保证优化器在各个worker上进行相同的更新。数据并行性具有几个明显的优势，包括计算效率高和实现起来工作量小。但是，数据并行性依赖扩展batch大小来提高worker数量，而我们往往无法在不影响收敛性的情况下一直增加batch大小。 

* **显存效率：**数据并行性会在所有worker之间复制模型和优化器，因此显存效率不高。DeepSpeed开发了[ZeRO]（https://www.microsoft.com/zh-cn/research/blog/zero-deepspeed-new-system-optimizations-enable-training-models-with-over-billion-parameters/ ），一系列用于提高数据并行的显存效率的优化器。 这项工作依赖于ZeRO的阶段1，该阶段在worker之间划分优化器状态量以减少冗余。

* **计算效率：**随着我们提高并行度，每个worker执行的计算量是恒定的。数据并行可以在小规模上实现近乎线性扩展。但是，在worker之间规约梯度的通信开销随模型大小扩张。这限制了大型模型或在通信带宽很低的系统上的计算效率。**梯度累计**是一种用来均摊通信成本的一种常用策略。它会进一步增加batch大小，在本地使用**micro-batch**多次进行正向和反向传播积累梯度后，再进行梯度规约和优化器更新。

**模型并行**是包含范围很广的一类技术。它会在多个worker之间划分模型的各个层。就其本质而言，模型并行性的计算和通信对于模型结构有着特异性，因此在实现上有很大的工作量。DeepSpeed借用了英伟达的[Megatron-LM](https://github.com/NVIDIA/Megatron-LM)来为基于Transformer的语言模型提供大规模模型并行功能。模型并行会根据worker数量成比例地减少显存使用量，也是这三种并行度中显存效率最高的。但是其代价是计算效率最低。
  
* **显存效率：**模型并行会根据worker数量成比例地减少显存使用量。至关重要的是，这是减少单个网络层的激活显存的唯一方法。DeepSpeed通过在模型并行worker之间划分激活显存来进一步提高显存效率。

* **计算效率：**由于每次前向和后向传播中都需要额外通信激活值，模型并行的计算效率很低。模型并行需要高通信带宽，并且不能很好地扩展到通信带宽受限的节点。此外，每个模型并行worker都会减少每个通信阶段之间执行的计算量，从而影响计算效率。模型并行性通常与数据并行性结合使用，以在内存和计算效率之间进行权衡。

**流水线并行**训练引擎也被包含在了这次发布的DeepSpeed中！流水线并行将模型的各层划分为可以并行处理的**阶段**。当一个阶段完成一个micro-batch的正向传递时，激活内存将被通信至流水线的下一个阶段。类似地，当下一阶段完成反向传播时，将通过管道反向通信梯度。必须同时计算多个micro-batch以确保流水线的各个阶段能并行计算。目前已经开发出了几种用于权衡内存和计算效率以及收敛行为的方法，例如[PipeDream](https://www.microsoft.com/zh-cn/research/blog/pipedream-a-more-effective-way-to-train-deep-neural-networks-using-pipeline-parallelism/)。DeepSpeed采用的方法是通过梯度累积来实现并行，并保持与传统数据并行和模型并行训练在相同的总batch大小下相同的收敛情况。

* **显存效率：**流水线并行减少的显存与流水线的阶段数成正比，使模型的大小可以随worker的数量线性扩展。但是，流水线并行不会减少每一层的激活函数的显存占用量。此外，每个worker必须存储同时运行的各个micro-batch的激活值。这导致流水线第一阶段的激活内存与单个mirco batch的总激活内存大致相同。一个万亿参数模型将需要为一个micro batch提供大约19 GB的显存的激活内存，这几乎占到新推出的英伟达A100 GPU总显存的一半。 

* **计算效率：**流水线并行具有最低的通信量，因为它的通信量只和在各阶段边界的各层的激活值大小成正比。但是，它不能无限扩展。像模型并行一样，增加流水线大小会减少每个流水线阶段的计算量，这会降低计算与通信的比率。如果要实现好的计算效率，流水线并行还要求其每个阶段的计算负载完美的均衡。

此外，流水线并行性会在每个batch的开始和结束时因为需要重新填充或排空流水线而产生bubble overhead。使用流水线阶段数的4倍或8倍的梯度累积步骤（以及batch大小）进行训练，相较于只有一个流水线阶段分别达到了81％和90％的扩展性。

### 通过3D并行同时实现高内存效率和高计算效率

数据，模型和流水线并行在提高内存和计算效率方面均起到特定的作用。图1说明了我们的3D策略。

**显存效率：**先将模型的各层划分到不同的流水线阶段，并进一步把每个阶段的层通过模型并行进行划分。这种2D组合同时减少了模型，优化器和激活函数所消耗的内存。不过，我们不能在不引入通信开销的情况下无限地划分模型，而通信开销会限制计算效率。

**计算效率：**为了在不牺牲计算效率的情况下将worker数量扩展至超出模型和流水线并行能支持的规模，我们使用了ZeRO支持的数据并行功能（ZeRO-DP）。ZeRO-DP不仅可以通过划分优化器状态量进一步提高显存利用效率，而且还可以通过利用基于通信拓扑的映射关系，以最小的通信开销扩展到任意数量的GPU。

**基于通信拓扑的3D映射**（图2）**：**：通过利用两个关键的架构属性，我们将3D并行中的每个维度仔细地映射到worker上，以实现最大的计算效率。

1. **优化节点内和节点间的通信带宽**：模型并行是这三种策略中通信开销最大的，因此我们优先考虑将模型并行worker组放置在节点内以利用更大的节点内带宽。这里我们基于英伟达Megatron-LM进行了张量切分式的模型并行。当模型并行组不占满节点内的所有worker时，我们选择将数据并行组放置在节点内。不然就跨节点进行数据并行。流水线并行的通信量最低，因此我们可以跨节点调度流水线的各个阶段阶段，而不受通信带宽的限制。
2. **通过并行通信增大带宽：**每个数据并行组需要通信的梯度量随着流水线和模型并行的规模线性减小，因此总通信量少于单纯使用数据并行。此外，每个数据并行组会在局部的一小部分worker内部独立进行通信，组间通信可以相互并行。这样的结果是，通过减少通信量和增加局部性与并行性，数据并行通信的有效带宽被增大了。

![该图显示了一个有32个worker进行3D并行的例子。神经网络的各层分为四个流水线阶段。每个流水线阶段中的层在四个模型并行worker之间进一步划分。最后，每个流水线阶段有两个数据并行实例，且ZeRO在这2个副本之间划分优化器状态量。](https://www.microsoft.com/en-us/research/uploads/prod/2020/09/Blog_DeepSpeed3_Figure-1_highres-1024x615.png)

图1：一个有32个worker进行3D并行的例子。神经网络的各层分为四个流水线阶段。每个流水线阶段中的层在四个模型并行worker之间进一步划分。最后，每个流水线阶段有两个数据并行实例，且ZeRO在这2个副本之间划分优化器状态量。

![彩色块显示图1中的worker到八个节点（每个节点有四个GPU）的系统上的GPU的映射。同一颜色的GPU在同一节点上。](https://www.microsoft.com/en-us/research/uploads/prod/2020/09/Blog_DeepSpeed3_Figure2_highres.png)

图2：图1中的worker到八个节点（每个节点有四个GPU）的系统上的GPU的映射。同一颜色的GPU在同一节点上。

##### 有关训练万亿参数模型是如何使用3D并行性的更多信息

使用8路模型并行，64路流水线并行和8路数据并行，可以在4096个英伟达A100 GPU上扩展训练一个万亿参数模型。

通过结合模型并行和流水线并行，3D并行可实现出色的内存效率和跨多个节点的高效计算效率。模型并行性提高了节点内的激活内存和模型状态量的存储效率，而流水线并行，相较于仅使用模型并行，则可以在不牺牲计算效率的情况下，跨节点高效存储模型状态。在micro-batch大小为1的万亿参数例子中，在使用激活值checkpoint以及上述3D并行后，模型状态量会消耗30 GB的显存，划分后的激活值消耗2.5 GB的内存。这样总显存占用为32.5 GB，就能够使用具有40 GB内存的英伟达A100 GPU来容纳和训练这样的模型了。

结合模型并行与流水线并行，可以使流水线并行在非常小的batch下以最小的bubble overhead实现高计算效率。在8路模型并行下，每个模型使用micro-batch为1个微批处理将导致每个GPU的有效micro-batch大小为1/8。因此，使用8倍于管道并行度的梯度累加步骤，只会让每张GPU上的总累计batch大小为1，并且流水并行处理可以实现90％的计算效率。与数据并行性结合使用时，这让4096张GPU上的总有效batch大小为4096，并仍然可以达到90％的流水线效率。

**但是数据并行会怎样影响计算效率呢？难道数据并行不是需要每张GPU都有大batch才能保持高效吗？**

模型并行可以将每张GPU上的有效batch大小减小到小于1。这使流水线并行即使在小batch下仍可以隐藏流水线bubble overhead。请注意，通过跨节点使用流水线并行性，我们就可以让流水线每个阶段的数据并行节点之间的独立进行通信，并且与其他流水线阶段并行进行。实际上，在高端GPU集群中常见的完全连接的网络拓扑中，这对可用于数据并行训练的有效通信带宽具有重要意义。由于流水线阶段中的每个节点都可以与其对应的数据并行节点并行通信，因此有效的通信带宽与流水线阶段数成正比。通过设置64个并行流水线阶段，有效带宽将变为往返单个节点的带宽的64倍。流水线并行带给数据并行如此大的有效带宽，这使数据并行在计算与通信比率非常低的小batch情况下，也能实现高效扩展。

### 在线性扩展性下训练万亿参数模型

DeepSpeed可以只用800张英伟达V100 GPU来训练具有一个**万亿**参数的语言模型（图3）。我们展示了模型大小和训练吞吐量，可以观察到显存和计算效率同时随模型的大小的扩展线性增长。在各种配置中，我们可以在每个GPU上训练大约14亿个参数，这是单个GPU在不耗尽内存的情况下可以支持的最大模型大小，这表明了完美的显存扩展性。我们还获得了接近完美的线性计算效率扩展，每张V100 GPU的吞吐量为47 Tflops。对于上述的硬件，这是令人印象深刻的扩展性和吞吐量。

![](https://www.microsoft.com/en-us/research/uploads/prod/2020/09/DeepSpeed-Figure-3_Section-1-1024x508.jpg)

图3：模型大小（以十亿个参数为单位）和训练吞吐量（以Pflops为单位）关于GPU数量的图表。DeepSpeed可以使用800张具有32 GB内存的英伟达V100 Tensor Core GPU训练有1万亿个参数的模型。每种配置都使用[NVIDIA Megatron-LM](https://github.com/NVIDIA/Megatron-LM)提供的16路模型并行性，剩余的GPU负责进行流水线并行。万亿参数模型具有298层Transformer，其隐藏层大小为17408，训练的序列长度为2048，batch大小2048。对于较小的模型，我们根据GPU数量按比例减少了Transformer层的数量。

##### 深入研究3D并行如何加速训练GPT-3规模的模型

[![](https://www.microsoft.com/en-us/research/uploads/prod/2020/09/DeepSpeed-3_Figure-2-_section-2.jpg)](https://www.microsoft.com/en-us/research/blog/zero-deepspeed-new-system-optimizations-enable-training-models-with-over-100-billion-parameters/)

图4：使用2D和3D并行使用800个GPU训练具有1800亿参数的GPT-3规模模型的系统性能。该模型具有100个Transformer层，隐藏层尺寸为12288并有96个attention head。训练使用的batch大小为2048，序列长度为2048。我们在数据并行之余也使用可ZeRO-1。P，M和D分别表示流水线，模型和数据并行维度。

在图4中，我们使用具有超过1,750亿个参数的最新[GPT-3](https://arxiv.org/abs/2005.14165)模型架构作为3D并行性的基准：

* 我们首先评估了**2D配置**（C1-C3）。配置C1和C2仅使用流水线和模型并行——它们可以训练模型，但由于过度分解模型导致吞吐量较低，GPU利用率较低。C3尝试仅使用流水线和数据并行，但无法在不使用Megatron的模型并行来减少激活量的情况下解决模型无法放进显存中的问题。
* **3D配置**（C4-C10）依次增加了流水线并行度；中间的平衡了并行性的配置可以实现最佳性能，实现了显存，计算和通信效率三高。
* 最佳的3D方法每个GPU可实现49 Tflops，超过硬件的理论峰值的40％。

##### 看看混合并行如何在低带宽集群上7倍加速训练GPT-2

我们训练了一个15亿参数的GPT-2模型，并在图5中展示了混合并行的通信优势。为了强调训练的通信阶段，训练在节点间带宽较低的四节点的群集上进行：

* **模型并行**在这种情况下没有优势，因为模型较小，且节点内带宽较低。
* **流水线并行**的通信量比配置数据和模型并行的情况小一个数量级。在小batch时，训练速度快7倍。
* **数据并行**使用通过梯度累积增加batch大小来均摊通信开销，但是在更大的batch大小下，配置了流水线并行的情况的性能仍是数据并行的两倍。
* **混合流水线和数据并行配置**通过将数据并行组限制在节点内的GPU上，避免了梯度通信瓶颈，因此梯度通信受益于更快的节点内带宽。

![](https://www.microsoft.com/en-us/research/uploads/prod/2020/09/DeepSpeed-3_Figure-4_Section-1.jpg)

图5：在训练序列长度为1024的GPT-2（1.5B参数）时，吞吐量与batch大小的关系。使用四个节点，每个节点配备四个具有16 GB内存的V100 GPU训练。GPU之间用每秒50 Gbps的节点内带宽和4 Gbps的节点间带宽连接。DP表示启用ZeRO-1的数据并行性。所有方法都通过增加梯度累积的步数来扩展批量大小。

## ZeRO-Offload：单GPU训练10倍大的模型

ZeRO-Offload通过同时利用GPU和宿主机CPU的计算和存储资源，提升了少GPU资源下可以高效训练的最大模型规模。它让我们可以在单张V100上进行最高至1300亿参数的模型训练，10倍于当前最高水平，同时保持每GPU 30Tflop的高训练吞吐量。

通过让在单GPU上可以训练数十亿参数的模型，ZeRO-Offload让大模型训练变得亲民，让只有有限资源的深度学习从业者也可以参与其中。

![在单GPU上使用默认的PyTorch和ZeRO-Offload能训练的最大模型规模的柱状图。](https://www.microsoft.com/en-us/research/uploads/prod/2020/09/Blog_deepspeed3_figure6_highres-1024x552.jpg)

图6：可以在单GPU上使用默认的PyTorch和ZeRO-Offload训练的最大的模型规模。

ZeRO-Offload背后的核心技术是在[ZeRO-2](https://www.microsoft.com/en-us/research/blog/zero-2-deepspeed-shattering-barriers-of-deep-learning-speed-scale/)的基础上将优化器状态和梯度卸至CPU内存。这个方法让ZeRO-Offload可以最小化拷贝至CPU导致的计算效率损失，同时达到和ZeRO-2相同，甚至有时超过的效率。下图展示了Zero-OffLoad的架构：

![](https://www.microsoft.com/en-us/research/uploads/prod/2020/09/DeepSpeed-3_Figure-2_section-1-1024x546.png)

图7: ZeRO-Offload概述。

##### 了解ZeRO-Offload是如何在单GPU上训练数十亿参数模型的

训练GPT和T5这样有数十亿参数的模型需要多GPU来存储模型和状态量。大模型训练大多通过跨GPU的模型并行来解决显存限制问题。最近，我们发布了ZeRO，一个高效利用显存的优化器，它会将模型状态量（优化器状态量、梯度和模型参数）分布在多个并行GPU上，让数十亿参数模型可以在不使用模型并行的情况下进行训练。然而，ZeRO还是需要大量数据并行的GPU来保存划分后的模型状态量，使得只有少数有大量GPU资源的人才有能力进行这种模型训练。

ZeRO-Offload让单GPU可以进行大模型训练，从而使这种训练变得平民化。为了在不使用多个GPU的情况下训练数十亿个参数的模型，ZeRO-Offload继承了ZeRO-2的划分优化器状态量和梯度的方法。和ZeRO-2不同的地方在于，ZeRO-Offload并没有在每个GPU上保存一部分优化器状态量和梯度，而是把两者都移到了本机内存上。Optimizer状态在整体训练过程中都保存在内存中。梯度则是在反向计算过程中在GPU上进行计算并通过reduce-scatter进行平均，之后每个数据并行进程把自己的那份平均后的梯度卸到CPU上（图7中的g offload）并弃掉不属于自己负责的部分。

一旦梯度到了CPU上，划分后的优化状态量就会并行地在CPU上进行更新(图7中的**p update**)。在更新进行完后，划分后的参数就被移回GPU并用all gather操作进行更新 (图7中的**g swap**）。Zero-Offload也通过使用不同CUDA stream来重叠通信（如**g offload**和**g swap**）和计算（如反向传播和**p update**) 以提高训练效率。

##### 从模型规模，训练速度和扩展性看ZeRO-Offload的优势

**10倍模型扩展：**在单张32GB V100 GPU上，图6显示可以由PyTorch训练的最大模型有13亿个参数，而ZeRO-Offload允许训练130亿个参数的模型，10倍于PyTorch能支持的。这是因为ZeRO-Offload在整个训练过程中将消耗了大部分GPU显存的优化器状态保留在本机内存中，同时还在反向传播过程中将计算出来的梯度移至CPU。因此，节省的GPU显存可用于训练更大的模型。

**高效的训练吞吐量：**如图8所示，在训练100亿参数模型时，即使仅使用单个GPU进行训练，使用ZeRO-Offload仍可让每个GPU有超过30 Tflops的吞吐量，并且其吞吐量随GPU数量增长呈近完美的线性增长。

ZeRO-Offload是ZeRO-2的完美补充，支持在少量GPU上高效训练大型模型。通过利用CPU内存来减少了模型所需的GPU显存，ZeRO-Offload让在1到16个GPU上训练大模型变得可行。在32个GPU上，ZeRO-Offload的性能略高于ZeRO-2; 性能提升来源于ZeRO-Offload节省的GPU显存，它们让我们可以在更大batch下训练了模型，从而才在有拷贝至CPU的开销的基础上仍带来了更高的GPU计算效率。在有更多的GPU（例如64和128）的情况下，ZeRO-2的性能优于ZeRO-Offload，因为两者现在都可以运行类似大小的batch，ZeRO-2没有将数据移至CPU的开销，并且GPU上进行优化器更新要比CPU上快得多。总而言之，ZeRO-Offload是ZeRO-2的补充，并将ZeRO家族的优化范围扩展至从单个设备到数千个设备的整个大型模型训练。

![使用ZeRO-Offload和ZeRO-2在128张GPU上训练有100亿参数的GPT-2模型的的吞吐量的柱状图。](https://www.microsoft.com/en-us/research/uploads/prod/2020/09/Blog_DeepSpeed3_Figure8_HighRes-1024x403.jpg)

图8：使用128张GPU训练100亿参数GPT-2模型的ZeRO-Offload和ZeRO-2的训练吞吐量比较。

## DeepSpeed稀疏注意力机制：用6倍更快的执行速度来执行10倍长的序列

基于注意力机制的深度学习模型（例如，Transformers）在捕获输入序列中的token之间的关系（即使是两者之间距离很长）方面非常有效。因此，它们常与文本，图像和语音相关的输入配合使用。这些输入的序列长度可至数千token。然而，尽管注意力模块有效地捕获了长期依赖关系，在实际应用中，对长序列输入的支持受计算量和显存的限制。计算量和显存需求关于序列长度\\(n\\)呈二次方级增长。

为了解决此限制，**DeepSpeed提供了一套稀疏attention kernel**——一种工具性技术，可以通过块状稀疏计算将attention计算的计算和显存需求降低几个数量级。这套工具不仅缓解了注意力计算的内存瓶颈，而且其稀疏计算非常高效。它的API可以方便地继承进任何基于Transformer的模型。除了提供各种稀疏结构外，它还可以灵活处理任何用户自定义的块状稀疏结构。

更具体地说，稀疏attention（SA）可以设计为计算靠近的token之间的局部attention，或通过使用局部attention计算的summary token来计算全局attention。此外，SA还可以允许随机attention或局部，全局和随机attention的任意组合，如图10中的蓝色，橙色和绿色块。这使SA将内存占用减小到\\(O(wn)\\)，其中1\\(<w≤n \\)是一个参数，其值取决于attention结构。

![彩色小方块显示可变的稀疏度结构](https://www.microsoft.com/en-us/research/uploads/prod/2020/09/Blog_DeepSpeed3_Figure10_Sparse-Attention_highres.jpg)

图10：可变稀疏结构

**在GPU上的高效实现：**尽管稀疏attention的基本实现会节省显存，但在计算上，它可能会比稠密计算要差。这主要是由于稀疏数据整体增加了分支和内存访问分散。开发高效的稀疏内核通常是颇具挑战性的，尤其是在GPU上。DeepSpeed提供了在[Triton](https://github.com/ptillet/triton)中开发的高效的稀疏attention kernel。这些kernel呈块状稀疏范式结构，可实现对齐的内存访问，减少GPU线程分支并平衡处理器上的工作负载。

**系统性能：** 如图11所示，SA支持**10倍长的序列**和**最高6.3倍的计算提速**。左图显示了可在BERT-Base和BERT-Large中运行的最长序列长度。我们的实验有以下三种设置：稠密模式，具有激活checkpoint的稠密模式和具有激活checkpoint的稀疏（SA）模式。与BERT-Base和BERT-Large的稠密模式相比，SA的序列分别长10倍和16倍。 此外，与稠密模式相比，SA减少了总计算量，并提高了训练速度：提高的效率随着序列长度的增加而提高，对于BERT-Base而言，提升速度高达6.3倍，而对于BERT-Large，则高达5.3倍。

[![](https://www.microsoft.com/en-us/research/uploads/prod/2020/09/DeepSpeed-Figure-11_final-1024x576.jpg)](https://www.microsoft.com/en-us/research/uploads/prod/2020/09/Blog_DeepSpeed3_Figure11_updated-v3-1024x465.jpg)

图11：BERT模型的可支持的最大序列长度（左）；在单英伟达V100 GPU上训练具有不同序列长度的BERT-Base（中）和BERT-Large（右）的时间。

##### 了解SA如何获得比全稠密attention相当甚至更高的准确性

涉及稀疏attention的相关工作（[Sparse Transformer](https://arxiv.org/pdf/1904.10509.pdf)，[Longformer](https://arxiv.org/pdf/2004.05150.pdf)，[BigBird](https://arxiv.org/pdf/2007.14062.pdf)）均显示出比全attention高的准确性。我们的经验与其一致。除了降低内存开销和加快计算速度外，我们还在生产模型中观察到SA有更高准确性并更快收敛的情况。下图说明了训练基于BERT的**长文本理解**（序列长度2048）生产模型的准确性。该实验在以下三种设置中进行：从头开始进行稠密训练，从头开始进行SA训练，以及从使用序列长度为512的密集型checkpoint继续进行SA训练。我们已经观察到，对于从头开始进行预训练，SA较于稠密设置收敛的速度更高，精度更好。此外，就时间和准确性而言，从用SA继续训练预先训练好的checkpoint的效果甚至更好。

![](https://www.microsoft.com/en-us/research/uploads/prod/2020/09/DeepSpeed-Figure-12_update-1024x717.jpg)

图12：长文本理解应用的准确性

##### 了解SA与最新的LongFormer的比较情况

我们将SA与Longformer（一种最新的稀疏结构及其实现）进行了比较。在我们的实验中，SA使用“[Fixed](https://arxiv.org/pdf/1904.10509.pdf)”稀疏性。两种实现的准确性相当。在系统性能方面，SA在训练和推断方面均优于Longformer：

* 运行Wikitext103上的预训练MLM的速度提高了1.5倍
* BERT-Base的推理速度提高3倍（batch大小1，序列长度2,048）

**处理任何块状稀疏结构的灵活性：** DeepSpeed稀疏attention套件不针对任何特定的稀疏结构，使模型研究人员能够在有效的系统支持下探索任何块稀疏结构。当前，我们添加了流行的稀疏结构，例如[Fixed](https://arxiv.org/pdf/1904.10509.pdf)（来自OpenAI稀疏Transformer），[BigBird](https://arxiv.org/pdf/2007.14062 .pdf)（来自Google）和BSLongformer（AI2 [Longformer](https://arxiv.org/pdf/2004.05150.pdf)的块稀疏实现）。我们还定义了一个具有“可变”结构的模板，如图10所示，该模板可用于简单地自定义任何随机，局部或全局attention模式的块状稀疏结构。

## 1比特Adam：减少5倍的通信量并提升3.4倍的训练速度

大型模型（如BERT和GPT-3）的扩展训练需要基于模型设计，体系结构和系统功能的仔细优化。从系统的角度来看，通信已成为主要的瓶颈，尤其是在使用标准TCP且网络带宽有限的商用系统上。

通信压缩是减少在此类系统上的训练时间的重要技术。压缩通信的最有效方法之一是误差补偿压缩，即使在1比特压缩下，它也可以提供稳定的收敛速度。但是，最新的误差补偿技术仅适用于一些和梯度线性相关的简单优化器，例如随机梯度下降（SGD）和Momentum SGD。这些技术无法和Adam之类的非线性优化器一起使用，后者在许多任务（包括训练类似BERT的模型）中带来了最好的收敛率和精度。

对于像Adam之类的强大优化器而言，对梯度的非线性依赖性（在方差项上）使开发基于误差补偿的压缩技术面临挑战，从而限制了实际应用最先进的通信压缩技术。

##### 理解经典压缩技术的背景

通信压缩的一种方法是1比特压缩，它可以被表示为：

![](https://www.microsoft.com/en-us/research/uploads/prod/2020/09/LaTex-Equation-1_DeepSpeed-1.jpg)

在这种压缩中，我们用1比特表示每个数字，从而将内存需求减少32倍。问题在于，这种直接的方法会大大降低收敛速度，从而无法实际使用。为了解决这个问题，最近的研究表明，通过使用误差补偿压缩，我们可以期待在通信压缩下保证几乎相同的收敛率。

误差补偿的思想可以概括为：1）进行压缩，2）记忆压缩误差，然后3）在下一次迭代中把压缩误差加回来。 对于SGD，误差压缩相当于：

![](https://www.microsoft.com/en-us/research/uploads/prod/2020/09/LaTex-Equation_2_DeepSpeed.jpg)

其中\\(C(⋅)\\)是1比特压缩算子。这种误差压缩的优点在于压缩误差的历史值\\(e\_t\\)和\\(e\_t-1\\)最终会相互抵消, 这使得：

![](https://www.microsoft.com/en-us/research/uploads/prod/2020/09/LaTex-Equation-3_DeepSpeed.jpg)

该策略已经被证明适用于所有线性依赖于梯度的优化算法，例如SGD和Momentum SGD。

##### 了解将误差补偿应用于Adam的挑战

我们在下面提供了Adam算法的概述。更新规则如下：

![](https://www.microsoft.com/en-us/research/uploads/prod/2020/09/LaTex-Equations-3_DeepSpeed.jpg)

如上图的公式所示，方差项\\(v\_t\\)和梯度\\(g\_t\\)呈非线程关系。如果我们对Adam进行普通的误差补偿，我们会发现（见图13）Adam将无法收敛。

![](https://www.microsoft.com/en-us/research/uploads/prod/2020/09/DeepSpeed-3_Figure-1-_Section-5.png)

图13：由于对梯度的非线性依赖，误差补偿压缩不适用于Adam

#### 用1比特Adam压缩通信

为了在使用Adam优化器时压缩通信，我们开发了**1比特Adam**，它通过预处理解决了梯度中的非线性问题。我们观察到非线性项方差（\\(v\_t\\)）的变化幅度在几个训练周期后显著降低，之后将\\(v\_t\\)设置为常数不改变收敛速度。所以提出的1位Adam优化器由两部分组成（如图14所示）：预热阶段，本质上就是原始的Adam算法。压缩阶段，使方差项保持恒定，并将剩余的线性项（即动量）压缩为1位表示形式。

该算法的压缩阶段由阈值参数控制（如图14所示）。当我们检测到“方差”的变化降至某个阈值以下时，我们切换到压缩阶段。我们的研究表明，热身阶段只需要全部训练步骤的15-20％。

##### 进一步了解1比特Adam在底层机制

1比特Adam的权重按以下公式进行更新。对于第**i**个worker，在压缩阶段：

![a screenshot of text](https://www.microsoft.com/en-us/research/uploads/prod/2020/09/DeepSpeed-Equations-5_Latex-1024x392.jpg)

![a screenshot of a cell phone](https://www.microsoft.com/en-us/research/uploads/prod/2020/09/DeepSpeed-3_Figure-2_Section-4.png)

图14：使用经典Adam和我们提出的的1比特压缩Adam算法进行分布式训练的流程比较

#### 应对1比特Adam的系统挑战

除了算法上的挑战外，在训练系统中应用1比特Adam还有两个系统挑战。首先，我们需要能将动量高效转换为1比特表示形式的kernel。其次，我们需要高效的通信方案来在不同的GPU之间传输压缩后的动量。压缩的目的是减少总体训练时间，以使带宽受限的商品系统可以用来训练大型模型。我们在DeepSpeed中解决了这些挑战，并引入了针对在通信受限上系统进行训练场景进行了完全优化的1比特Adam实现。

#### 1比特Adam在通信受限系统上的优势

1位Adam提供了和Adam相同的收敛能力，并最多可以减少**5倍的通信量**，从而为BERT-Large预训练任务带来了**最高3.5倍的吞吐量**，以及为SQuAD fine-tuning任务带来了**高达2.7倍的高吞吐量**。端到端吞吐量的提高来源于在压缩阶段观察到的6.6倍（图15左）和6.2倍（图15右）速度提升。值得一提的是，我们的1位Adam优化器在40 Gb以太网系统上的扩展性非常好，其性能可与Adam在40 Gb InfiniBand QDR系统上的扩展性相媲美。我们注意到，基于iPerf基准，40 Gb以太网上的有效带宽为4.1 Gbps，而基于InfiniBand perftest微基准，InfiniBand提供了32 Gbps的近峰带宽。

![](https://www.microsoft.com/en-us/research/uploads/prod/2020/09/DeepSpeed-3-Figure-3-Section-4-1024x349.jpg)

图15：NVIDIA V100 GPU上的BERT-Large预训练（左）和SQuAD fine-tuning（右）的1比特Adam扩展性。BERT预训练的batch大小为16/GPU，SQuAD fine-tuning为3/GPU。

##### 深入1比特Adam的评测结果

**与Adam相同的收敛性**：使用1比特Adam的一个主要问题是收敛速度。我们发现在使用相同数量的训练样本时，1比特Adam可以达到相同的收敛速度和相当的性能，见图16。

![](https://www.microsoft.com/en-us/research/uploads/prod/2020/09/DeepSpeed-3_Figure-4_Section-5.png)

图16：使用相同数量的训练样本，1比特Adam可以像Adam一样收敛。

表1显示了BERT-Base和BERT-Large的详细结果。我们看到，对于未压缩和压缩情况，1比特Adam的性能均与原始模型相当，有些则优于原始模型。

![](https://www.microsoft.com/en-us/research/uploads/prod/2020/09/DeepSpeed_Table-1.png)

表1：在各种测试任务上验证1比特Adam的正确性

**最多可减少5倍的通信量：** 1比特Adam提供了与Adam相同的收敛能力，并且在压缩阶段（对于16位（FP16）训练）将通信量减少了16倍。 对于BERT预训练模型，由于我们观察到预热阶段仅为端到端训练时间的15％，因此总体通信减少了5倍。

原始Adam和1比特Adam的通信量之比的公式如下：

1 / (warmup + (1 – warmup)/16)

**1比特Adam使训练BERT-Large的速度快3.5倍：** 我们提供了在两个具有有限带宽限制的系统上训练BERT-Large的结果：1）40 Gbps以太网（图17左）和2）40 Gbps InfiniBand QDR（图17右）。在压缩阶段，我们发现使用以太网的系统吞吐量提高了6.6倍，使用InfiniBand的系统吞吐量提高了2倍，端到端的速度（包括预热和压缩阶段）分别提高了3.5倍和2.7倍。1比特Adam的主要收益来源于通信量减少（因为对动量通信的压缩实现）以及我们自定义的**allreduce**操作，该操作通过高效的1比特无阻塞gather和一个**allgather**操作实现。

值得注意的是，可以使用LAMB而不是Adam优化器进行BERT预训练，通过增加总batch大小以减少通信量。但是，1比特的Adam避免了这种要求严格的超参数调参。根据我们的经验，大batch下进行调参通常会更加困难。此外，1比特Adam对于临界批处理量较小（无法在大batch下良好收敛，例如许多fine-tuning任务）的工作也非常适用。

![](https://www.microsoft.com/en-us/research/uploads/prod/2020/09/DeepSpeed-3_Figure-5_Section-5-1024x343.jpg)

图17：在压缩阶段，在40 Gbps以太网（左）和InfiniBand（右）上进行BERT-Large训练时1比特Adam的性能。

**1比特Adam使SQuAD fine-tuning任务加速2.7倍：** 1比特Adam不仅在大规模训练任务上提供扩展性，而且在SQuAD微调之类的任务上也有效果。如图18所示，1比特Adam可在基于以太网和基于InfiniBand的系统上很好地扩展，并且在基于以太网的系统上提供高达6.2倍的高吞吐量（在压缩阶段），从而带来端到端的2.7倍提速（预热阶段占25％，压缩阶段占75％）。对于SQuAD fine-tuning，我们观察到总batch大小为96时，F1得分最高。 batch大小大于此值会降低收敛率，并需要额外的超参数调整。因此，为了扩展到32个GPU，我们在每个GPU上运行3-4的小batch。这使得fine-tuning任务的通信强度大且难以扩展。1比特Adam很好地解决了扩展性的难题，在不增加批量的情况下减少了3.4倍的通信量，从而实现了2.7倍的端到端加速。

![](https://www.microsoft.com/en-us/research/uploads/prod/2020/09/DeepSpeed-3_Figure-6_Section-5-1024x316.jpg)

图18：在40 Gbps以太网（左）和InfiniBand（右）上的SQuAD fine-tuning任务中使用1比特Adam时，压缩阶段的性能。

------

请访问[DeepSpeed网站](https://www.microsoft.com/en-us/research/project/deepspeed/)以及[Github仓库](https://github.com/microsoft/DeepSpeed)以获取这些新技术的代码、教程和文档！我们也把部分技术整合进了[ONNX Runtime](http://aka.ms/onnxruntime)。

### 关于我们出色的合作者们：

* 我们在此致谢学界合作者，来自哈佛大学的Philippe Tillet。他通过[Triton](http://www.eecs.harvard.edu/~htk/publication/2019-mapl-tillet-kung-cox.pdf)编译器和我们一同开发了稀疏注意力算法的kernel。
* ZeRO-Offload是和来自UC Merced的实习生Jie Ren共同开发的。我们同时也感谢来自UC Merced的Dong Li，以及来自微软的的Bharadwaj Pudipeddi和Maral Mesmakhouroshahi [L2L work](https://arxiv.org/abs/2002.05645)，感谢他们在这个主题上的讨论。
* 1-bit Adam由来自罗切斯特大学的实习生Hanlin Tang共同开发。
* 我们同时感谢来自英伟达的强力合作，尤其是Megatron-LM团队。

### 关于DeepSpeed团队：

我们是一群热衷于大规模系统性能优化的研究员和工程师——Samyam Rajbhandari, Jeff Rasley, Olatunji Ruwase, Reza Yazdani Aminabadi, Elton Zheng, Arash Ashari, Jing Zhao, Minjia Zhang, Niranjan Uma Naresh, Shaden Smith, Ammar Ahmad Awan, Conglong Li, Yuxiong He (team lead)。最近我们专注于深度学习系统，优化深度学习系统的训练速度、收敛速度以及开发速度！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
