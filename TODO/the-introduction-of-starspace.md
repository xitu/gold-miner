> * 原文地址：[The Introduction of StarSpace](https://github.com/facebookresearch/StarSpace/blob/master/README.md)
> * 原文作者：[Facebook](https://github.com/facebookresearch/Starspace)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/the-introduction-of-starspace.md](https://github.com/xitu/gold-miner/blob/master/TODO/the-introduction-of-starspace.md)
> * 译者：[Noah Gao](https://noahgao.net) [Sean Wang](https://github.com/SeanW20)
> * 校对者：[ryouaki](https://github.com/ryouaki)

<p align="center"><img width="15%" src="https://github.com/facebookresearch/StarSpace/raw/master/examples/starspace.png" /></p>

# Facebook 的 AI 万金油：StarSpace 神经网络模型简介

StarSpace 是一个用于解决各种问题、进行高效的实体嵌入（译者注：entity embeddings，一种流行的类别特征处理方法）学习的通用神经网络模型:

- 学习单词、句子或是文档级别的嵌入。
- 信息检索：对实体或文档的集合完成排序，例如：Web 文档的排名。
- 文本分类或是其他打标签形式的任务。
- 度量学习、相似性学习，例如：对句子或文档的相似性进行学习。
- 基于内容或是协同过滤进行推荐，例如：推荐音乐和视频。
- 图嵌入，例如：完成像 Freebase 一样的多关系图。
- <img width="5%" src="https://github.com/facebookresearch/StarSpace/raw/master/examples/new2.gif" /> 图片的分类、排名或检索（例如：使用已存在的 ResNet 特性）。

在一般情况下，它会学习如何将不同类型的对象表示为一个常见的矢量嵌入空间，
从名称中的星号（'*'，通配符）和空格开始，并在该空间中将它们相互比较。
它还会学习对给定查询数据的一组实体/文档或对象进行排序，查询所用的数据不一定与该集合中的项目类型相同。

看一看 [这篇论文](https://arxiv.org/abs/1709.03856) 来进一步了解它是如何工作的。

# 最新消息

- 使用了新的许可证和专利权声明：现在 StarSpace 已经开始基于 BSD 许可证。阅读 [LICENSE 文件](https://github.com/facebookresearch/StarSpace/blob/master/LICENSE.md) 和 [PATENTS 文件](https://github.com/facebookresearch/StarSpace/blob/master/PATENTS) 可获得更多信息。
- 我们新增了对实值输入和标签权重的支持：阅读 [文件格式](#file-format) 和 [ImageSpace](#imagespace-learning-image-and-label-embeddings) 来获取更多有关如何在输入和标签中使用权重的信息。

# 依赖

StarSpace 可在现代的 Mac OS 和 Linux 发行版上构建。鉴于它使用了 C++11 的特性，所以他需要与一个具有良好的 C++11 支持的编译器。包括：

* gcc-4.6.3 以上或是 clang-3.3 以上

编译将会借助一个 Makefile 文件来执行，所以你需要一个能正常工作的 **make** 命令。

你还需要安装一个 [Boost](http://www.boost.org) 库并在 makefile 中指定 boost 库的路径译运行 StarSpace。简单地来说就是：

    $wget https://dl.bintray.com/boostorg/release/1.63.0/source/boost_1_63_0.zip
    $unzip boost_1_63_0.zip
    $sudo mv boost_1_63_0 /usr/local/bin

可选步骤：如果你希望能在 src 目录中运行单元测试，你会需要 [google test](https://github.com/google/googletest) 并将 makefile 中的 'TEST_INCLUDES' 配置为它的路径。

# 构建 StarSpace

想要构建 StarSpace 的话，按顺序执行：

    git clone https://github.com/facebookresearch/Starspace.git
    cd Starspace
    make

# 文档格式

StarSpace 通过以下格式进行文件的输入。
每一行都作为一个输入例子，在最简单的情况下，输入有 k 个单词，后面跟着的每个标签也是一个独立的单词：

    word_1 word_2 ... word_k __label__1 ... __label__r
这种描述格式与 [fastText](https://github.com/facebookresearch/fastText) 一样，默认情况下，标签是以字符串 \_\_label\_\_ 为前缀的单词，前缀字符串可以由 `-label` 参数来设置。

执行这条命令来学习这种嵌入：

    $./starspace train -trainFile data.txt -model modelSaveFile

这里的 data.txt 是一个包含utf-8编码文本的训练文件。在优化结束时，程序将保存两个文件：model 和 modelSaveFile.tsv。modelSaveFile.tsv 是一个包含实体嵌入向量的标准tsv格式文件，每行一个。modelSaveFile 是一个二进制文件，包含模型的参数以及字典，还包括所有超参数。二进制文件稍后可用于计算实体嵌入的向量或运行评估任务。

在更普遍的情况下，每个标签也会包含单词：

    word_1 word_2 ... word_k <tab> label_1_word_1 label_1_word_2 ... <tab> label_r_word_1 ..

嵌入向量将学习每个单词和标签，并将相似的输入和标签组合在一起。

为了学习更一般情况下的嵌入，每个标签由单词组成，需要指定 `-fileFormat` 标志为”labelDoc”，如下所示：

    $./starspace train -trainFile data.txt -model modelSaveFile -fileFormat labelDoc

我们还可以通过将参数 `-useWeight` 设置为 true（默认为 false）来扩展文件格式以支持实值权值（在输入和标签空间中）。如果 `-useWeight` 为 true，我们支持使用以下格式定义权重。

    word_1:wt_1 word_2:wt_2 ... word_k:wt_k __label__1:lwt_1 ...    __label__r:lwt_r

例如，

    dog:0.1 cat:0.5 ...

对于不包括权重的任意单词和标签，其默认权重为 1。

## 训练模式

StarSpace 支持下列几种训练模式（默认是第一个）：

* trainMode = 0:
  * 每个实例都包括输入和标签。
  * 如果文件格式是‘fastText’，那么标签会有特定的独立特征或是单词（例如，带有 __label__前缀，参见上面的 **文件格式** 一节。
  * **用例：**  分类任务，参见后面的 TagSpace 示例。
  * 如果文件格式是‘labelDoc’那么这些标签就是特征包，其中一个包被选中（参见上面的 **文件格式** 一节）。
  * **用例：**  检索/搜索任务，每个例子包括一个后跟了一组相关文件的查询。
* trainMode = 1:
  * 每个示例都包含一组标签。在训练时，随机选取集合中的一个标签作为标签量，其余标签作为输入。
  * **用例：**  基于内容或协同过滤进行推荐，参见后面的 PageSpace 示例。
* trainMode = 2:
  * 每个示例都包含一组标签。在培训的时候，随机选取一个来自集合的标签作为输入量，集合中其余的标签成为标签量。
  * **用例：** 学习从一个对象到它所属的一组对象的映射，例如，从句子（文档内的）到文档。
* trainMode = 3:
  * 每个示例都包含一组标签。在训练时，随机选取集合中的两个标签作为输入量和标签量。
  * **用例：** 从类似对象的集合中学习成对的相似性，例如：句子的相似性。
* trainMode = 4:
  * 每个示例都包含两个标签。在训练时，集合中的第一个标签将被选为输入量，第二个标签将被选为标签量。
  * **用例：** 从多关系图中学习。
* trainMode = 5:
  * 每个示例只包含输入量。在训练期间，它会产生多个训练样例：从输入的每个特征被选为标签量，其他特征（到距离 ws（译者注：单词级别训练的上下文窗口大小，一个可选的输入参数））被挑选为输入特征。
  * **用例：** 通过无监督的方式学习单词嵌入。

# 典型用例

## TagSpace 单词、标签的嵌入

**用途:** 学习从短文到相关主题标签的映射,例如，在 [这篇文章](https://research.fb.com/publications/tagspace-semantic-embeddings-from-hashtags/) 中的描述。这是一个典型的分类应用。

**模型：** 通过学习两者的嵌入，学习的映射从单词集到标签集。
例如，输入“restaurant has great food <\tab> #restaurant <\tab> #yum”将被翻译成下图。（图中的节点是要学习嵌入的实体，图中的边是实体之间的关系。

![word-tag](https://github.com/facebookresearch/Starspace/blob/master/examples/tagspace.png)

**输入文件的格式**:

    restaurant has great food #yum #restaurant

**命令**：

    $./starspace train -trainFile input.txt -model tagspace -label '#'

### 示例脚本：

我们将该模型应用于 [AG的新闻主题分类数据集](https://github.com/mhjabreel/CharCNN/tree/master/data/ag_news_csv) 的文本分类问题。在这一问题中我们的标签是新闻文章类别，我们使用 hit@1 度量来衡量分类的准确性。[这个示例脚本](https://github.com/facebookresearch/Starspace/blob/master/examples/classification_ag_news.sh) 下载数据并在示例目录下运行StarSpace模型：

    $bash examples/classification_ag_news.sh

## PageSpace 用户和页面的嵌入

**用途：** 在Facebook上，用户可以粉（关注）他们感兴趣的公共页面。当用户浏览页面时，用户可以在 Facebook 上收到所有页面发布的内容。 我们希望根据用户的喜爱数据学习页面嵌入，并用它来推荐用户可能感兴趣（可能关注）的新页面。 这个用法可以推广到其他推荐问题：例如，根据过去观看的电影记录学习嵌入，向用户推荐电影; 根据过去用户登录的餐厅学习嵌入，向用户推荐餐馆等。

**模型：** 用户被表示为他们关注的页面（粉了）。也就是说，我们不直接学习用户的嵌入，相反，每个用户都会有一个嵌入，这个嵌入就是用户煽动的页面的平均嵌入。页面直接嵌入（在字典中具有独特的功能）。在用户数量大于页面数量的情况下，这种设置可以更好地工作，并且每个用户喜欢的页面平均数量较少（即用户和页面之间的边缘相对稀疏）。它也推广到新用户而无需再重新训练。 也可以使用更传统的推荐设置。

![user-page](https://github.com/facebookresearch/Starspace/blob/master/examples/user-page.png)

每个用户都由用户展开的集合表示，每个训练实例都是单个用户。

**输入文件格式**：

    page_1 page_2 ... page_M

在训练时，在每个实例（用户）的每个步骤中，选择一个随机页面作为标签量，并且剩余的页面被选择为输入量。 这可以通过将标志 -trainMode 设置为 1 来实现。

**命令**：

    $./starspace train -trainFile input.txt -model pagespace -label 'page' -trainMode 1

## DocSpace 文档推荐

**用途：** 我们希望根据用户的历史喜好和点击数据为用户生成嵌入和推荐网络文档。

**模型：** 每个文件都由文件的一个集合来表示。 每个用户都被表示为他们过去喜欢/点击过的文档（集合）。
在训练时，在每一步选择一个随机文件作为标签量，剩下的文件被选为输入量。

![user-doc](https://github.com/facebookresearch/Starspace/blob/master/examples/user-doc.png)

**输入文件格式**：

    roger federer loses <tab> venus williams wins <tab> world series ended
    i love cats <tab> funny lolcat links <tab> how to be a petsitter  

每行是一个用户，每个文档（由标签分隔的文档）是他们喜欢的文档。
所以第一个用户喜欢运动，而第二个用户对这种情况感兴趣。

**命令**：

    ./starspace train -trainFile input.txt -model docspace -trainMode 1 -fileFormat labelDoc

## GraphSpace 知识库中的链接预测

**用途：** 学习 [Freebase](http://www.freebase.com) 中的实体与关系之间的映射。在 freebase 中，数据以格式输入。

    (head_entity, relation_type, tail_entity)

执行链接预测可以将数据格式化为填充不完整的三元组

    (head_entity, relation_type, ?) or (?, relation_type, tail_entity)

**模型：** 我们学习所有实体和关系类型的嵌入。对于每一个 realtion_type，我们学习两个嵌入：一个用于预测给定 head_entity 的 tail_entity，一个用于预测给定 tail_entity 的 head_entity。

![multi-rel](https://github.com/facebookresearch/StarSpace/blob/master/examples/multi-relations.png)

### 示例脚本：

[这个示例脚本](https://github.com/facebookresearch/Starspace/blob/master/examples/multi_relation_example.sh) 将会从 [这里](https://everest.hds.utc.fr/doku.php?id=en:transe) 下载 Freebase15k 数据并在其上运行 StarSpace 模型：

    $bash examples/multi_relation_example.sh

## SentenceSpace 学习句子的嵌入

**用途：** 学习句子之间的映射。给定一个句子的嵌入，可以找到语义上相似或相关的句子。

**模型：** 每个例子是语义相关的句子的集合。 随机采用 trainMode 3 来选择两个：一个作为输入，一个作为标签，其他句子被挑选为随机的否定。 在没有标注的情况下获取语义相关句子的一个简单方法是考虑同一文档中的所有句子是相关的，然后在这些文档上进行训练。

![sentences](https://github.com/facebookresearch/StarSpace/blob/master/examples/sentences.png)

### 示例脚本：

[这个示例脚本](https://github.com/facebookresearch/Starspace/blob/master/examples/wikipedia_sentence_matching.sh) 会下载一些数据，其中每个示例都是来自同一维基百科页面的一组语句，并在其上运行StarSpace模型：

    $bash examples/wikipedia_sentence_matching.sh

为了能运行 [这篇论文](https://arxiv.org/abs/1709.03856) 中提出的 Wikipedia Sentence Matching 问题的完整实验，
请使用 [这个脚本](https://github.com/facebookresearch/Starspace/blob/master/examples/wikipedia_sentence_matching_full.sh)（警告：下载数据和训练模型需要很长时间）：

    $bash examples/wikipedia_sentence_matching_full.sh

## ArticleSpace 学习句子和文章嵌入

**用途：** 学习句子和文章之间的映射关系。给定句子的嵌入，可以找到相关文章。

**模型：** 每个例子都是包含多个文章的句子。 训练时，随机选取的句子作为输入，那么文章中剩余的句子成为标签，其他文章可以作为随机底片。 (trainMode 2).

### 示例脚本：

[这个示例脚本](https://github.com/facebookresearch/Starspace/blob/master/examples/wikipedia_article_search.sh) 将下载数据，其中的每个示例都是维基百科的文章，并在其上运行 StarSpace 模型：

    $bash examples/wikipedia_article_search.sh
    
为了能运行 [这篇论文](https://arxiv.org/abs/1709.03856) 中提出的 Wikipedia Sentence Matching 问题的完整实验，
请使用 [这个脚本](https://github.com/facebookresearch/Starspace/blob/master/examples/wikipedia_article_search_full.sh)（提示：这将需要一些时间去下载数据并训练模型）：

    $bash examples/wikipedia_article_search_full.sh
    
## ImageSpace 学习图像和标签的嵌入

通过最新的更新，StarSpace 也可以用来学习图像和其他实体的嵌入。例如，可以使用 ResNet 特征（预先训练的 ResNet 模型的最后一层）来表示图像，并将图像和其他实体（单词，主题标签等）一起嵌入。就像 StarSpace 中的其他实体一样，图像可以在输入或标签上，这取决于不同的任务。

这里我们给出一个使用 [CIFAR-10](https://www.cs.toronto.edu/~kriz/cifar.html) 的例子以说明我们如何与其他实体进行图像训练 (在这个例子中，指为图像类)：我们训练模型 [ResNeXt](https://github.com/facebookresearch/ResNeXt) 在 CIFAR-10  在测试数据集上达到 96.34％ 的准确率，并将最后一层 ResNet 作为每幅图像的特征。我们使用 StarSpace 将 10 个图像类与图像特征一起嵌入到相同的空间中。对于最后一层（0.8,0.5，...，1.2）的类 1 的示例，我们将其转换为以下格式：

    d1:0.8  d2:0.5   ...    d1024:1.2   __label__1

将 CIFAR-10 的训练和测试例转换成上述格式后，我们运行 [这个示例脚本](https://github.com/facebookresearch/StarSpace/blob/master/examples/image_feature_example_cifar10.sh)：

    $bash examples/image_feature_example_cifar10.sh

平均每 5 次达到 96.56％ 的准确度。

# 完整的参数文档

```plain
    运行 "starspace train ..." 或 "starspace test ..."

    以下参数是训练时必须的：
      -trainFile       训练文件路径。
      -model           模型文件输出路径。

    以下参数是训练时必须的：
      -testFile        测试文件路径。
      -model           模型文件路径。

    以下是字典相关的可选参数：
      -minCount        单词量的最少个数，默认为 1。
      -minCountLabel   标签量的最少个数，默认为 1。
      -ngrams          单词元数的最大长度，默认为 1。
      -bucket          buckets 的数量，默认为 2000000。
      -label           标签量前缀，默认为 __label__，可参加文件格式一节。

    以下参数是训练时可选的：
      -initModel       如果非空，则在 -initModel 中加载先前训练过的模型并进行训练。
      -trainMode       选择 [0, 1, 2, 3, 4, 5] 中的一个值，参见训练模式一节，默认为 0。
      -fileFormat      当前支持‘fastText’和‘labelDoc’，参见文件格式一节，默认为 fastText。
      -saveEveryEpoch  在每次迭代后保存中间模型，默认为 false。
      -saveTempModel   在每次迭代之后用包括迭代词的的唯一名字保存中间模型，默认为 false。
      -lr              学习速度，默认为 0.01。
      -dim             嵌入矢量的大小，默认为 10。
      -epoch           迭代次数，默认为 5。
      -maxTrainTime    最长训练时间（秒），默认为 8640000。
      -negSearchLimit  抽样中的拒绝上限，默认为 50。
      -maxNegSamples   一批更新中的拒绝上限，默认为 10。
      -loss            loss 函数，可能是 hinge 或 softmax 中的一个，默认为 hinge。
      -margin          hinge loss 的边缘参数。只在 loss 为 hinge 时有意义，默认为0.05。
      -similarity      选择 [cosine, dot] 中的一个，用于在 hinge loss 选定相似度函数。
                       只在 loss 为 hinge 时有意义，默认为 cosine。
      -adagrad         是否在训练中使用 adagrad，默认为 1。
      -shareEmb        是否对LHS和RHS使用相同的嵌入矩阵，默认为 1。
      -ws              在 trainMode 5 时有效，单词级别训练的上下文窗口大小，默认为 5。
      -dropoutLHS      LHS特征的放弃概率，默认为 0。
      -dropoutRHS      RHS特征的放弃概率，默认为 0。
      -initRandSd      嵌入的初始值是从正态分布随机生成的，其中均值为 0，标准差为 initRandSd，默认为 0.001。

    以下参数是测试时可选的：
      -basedoc         一组标签的文件路径与真实标签进行比较。 -fileFormat='labelDoc' 时需要。
                       在 -fileFormat ='fastText' 且 不提供 -basedoc 的情况下，我们将会对真正的标签与字典中的所有其他标签进行比较。
      -predictionFile  保存预测的文件路径。如果不为空，则将保存每个示例的前K个预测。
      -K               如果 -predictionFile 参数非空，为每个实例进行的顶层的 K 预测将被保存。

    以下参数是可选的：
      -normalizeText   是否为输入文件运行基本的文本预处理，默认为 0，不进行预处理。
      -useWeight       输入文件是否自带权重，默认为 0，不自带权重。
      -verbose         消息输出详细程度，默认为 0，普通输出。
      -debug           是否使用调试模式，默认为 0，关闭调试模式。
      -thread          线程数量，默认为 10。
```

注意：我们使用与在 [fastText](https://github.com/facebookresearch/fastText) 中相同的单词 n-gram 实现。当“-ngrams”被设置为大于1时，由“-bucket”参数指定的大小的哈希映射被用于 n-gram；当“-ngrams”设置为 1 时，不使用哈希映射，并且该字典包含 minCount 和 minCountLabel 约束内的所有单词。

## Utility Functions

我们还为 StarSpace 提供了一些实用功能：

### 显示查询的预测

检查经过训练的嵌入模型质量的一个简单方法是在键入输入时检查预测。要构建和使用该实用程序功能，请运行以下命令：

    make query_predict
    ./query_predict <model> k [basedocs]

其中 `<model>` 指定一个受过训练的 StarSpace 模型，可选的 K 指定显示多少个顶部预测（排名第一）。 “basedocs” 指向要排序的文件的文件，也参见上面主要 StarSpace 中同名的参数。如果没有提供“基类”，则使用词典中的标签。

加载模型后，它读取一行实体（可以是一个单词或一个句子/文档），并输出预测。

### 最近相邻量查询

检查训练好的嵌入模型质量的另一种简单方法是检查实体的最近相邻量。 要构建和使用该实用程序功能，请运行以下命令：

    make query_nn
    ./query_nn <model> [k]

其中 `<model>` 指定一个受过训练的 StarSpace 模型，可选的 K（ 默认值是 5 ） 指定要搜索的最近相邻量。

加载模型后，它读取一行实体（可以是一个单词或一个句子/文档），并在嵌入空间输出最近的实体。

### 打印 Ngrams

由于模型中使用的 ngram 不是以 tsv 格式保存的，我们还提供了一个单独的函数来输出模型中的 n 元嵌入。要使用它，请运行以下命令：

    make print_ngrams
    ./print_ngrams <model>

其中 `<model>` 指定了的参数 -ngrams > 1 的受过训练的StarSpace模型。

### 打印句子/文档嵌入

在有时需要从训练的模型中打印句子或文档的嵌入时是非常有用的。 要使用它，请运行以下命令：

    make embed_doc
    ./embed_doc <model> [filename]

其中 `<model>` 指定了训练过的 StarSpace 模型。如果提供了文件名，则从文件逐行读取每个句子/文档，并相应地输出向量嵌入。如果没有提供文件名，它会从 stdin 中读取每个句子/文档。

## 引用

如果您在工作中使用了 StarSpace，请引用这篇 [arXiv 论文](https://arxiv.org/abs/1709.03856)：

```plain
@article{wu2017starspace,
  title={StarSpace: Embed All The Things!},
  author = {{Wu}, L. and {Fisch}, A. and {Chopra}, S. and {Adams}, K. and {Bordes}, A. and {Weston}, J.},
  journal={arXiv preprint arXiv:{1709.03856}},
  year={2017}
}
```

## 联系我们

* Facebook 小组: [StarSpace Users](https://www.facebook.com/groups/532005453808326)
* emails: ledell@fb.com, jase@fb.com

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
