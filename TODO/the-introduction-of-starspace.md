> * 原文地址：[The Introduction of StarSpace](https://github.com/facebookresearch/StarSpace/blob/master/README.md)
> * 原文作者：[Facebook](https://github.com/facebookresearch/Starspace)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/the-introduction-of-starspace.md](https://github.com/xitu/gold-miner/blob/master/TODO/the-introduction-of-starspace.md)
> * 译者：[Noah Gao](https://noahgao.net) [Sean Wang](https://github.com/SeanW20)
> * 校对者：

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
因此名称中的星号（'*'，通配符）和空格，并在该空间中将它们相互比较。（译者注：因此原词为 hence，在这里没有找到好的译法，请校对的童鞋给点意见）
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
这是一个每行只有一个输入的例子，在最简单的情况下，输入有 k 个单词，后面跟着的每个标签也是一个独立的单词：

    word_1 word_2 ... word_k __label__1 ... __label__r
默认情况下，标签是以字符串 \_\_label\_\_ 为前缀的单词，前缀字符串可以由 `-label` 参数来设置。

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
    * 每个示例都包含一组标签。 在训练时，随机选取集合中的一个标签作为标签量，其余标签作为输入。
    * **用例：**  基于内容或协同过滤进行推荐，参见后面的 PageSpace 示例。
* trainMode = 2:
    * 每个示例都包含一组标签。 在培训的时候，随机选取一个来自集合的标签作为输入量，集合中其余的标签成为标签量。
    * **用例：** 学习从一个对象到它所属的一组对象的映射，例如，从句子（文档内的）到文档。
* trainMode = 3:
    * Each example contains a collection of labels. At training time, two labels from the collection are randomly picked as the input and label.
    * **Use case:** learn pairwise similarity from collections of similar objects, e.g. sentence similiarity.
* trainMode = 4:
    * Each example contains two labels. At training time, the first label from the collection will be picked as input and the second label will be picked as the label.
    * **Use case:** learning from multi-relational graphs.
* trainMode = 5:
    * Each example contains only input. At training time, it generates multiple training examples: each feature from input is picked as label, and other features surronding it (up to distance ws) are picked as input features.
    * **用例：** 通过无监督的方式学习单词嵌入。

# 典型用例

## TagSpace 单词、标签的嵌入

**用途:** Learning the mapping from a short text to relevant hashtags, e.g. as in <a href="https://research.fb.com/publications/tagspace-semantic-embeddings-from-hashtags/">this paper</a>. This is a classical classification setting.

**Model:** the mapping learnt goes from bags of words to bags of tags, by learning an embedding of both. 
For instance,  the input “restaurant has great food <\tab> #restaurant <\tab> #yum” will be translated into the following graph. (Nodes in the graph are entities for which embeddings will be learned, and edges in the graph are relationships between the entities).

![word-tag](https://github.com/facebookresearch/Starspace/blob/master/examples/tagspace.png)

**Input file format**:

    restaurant has great food #yum #restaurant

**Command:**

    $./starspace train -trainFile input.txt -model tagspace -label '#'

### Example scripts:
We apply the model to the problem of text classification on <a href="https://github.com/mhjabreel/CharCNN/tree/master/data/ag_news_csv">AG's News Topic Classification Dataset</a>. Here our tags are news article categories, and we use the hits@1 metric to measure classification accuracy. <a href="https://github.com/facebookresearch/Starspace/blob/master/examples/classification_ag_news.sh">This example script</a> downloads the data and run StarSpace model on it under the examples directory:

    $bash examples/classification_ag_news.sh
    
## PageSpace 用户和页面的嵌入

**Setting:** On Facebook, users can fan (follow) public pages they're interested in. When a user fans a page, the user can receive all things the page posts on Facebook. We want to learn page embeddings based on users' fanning data, and use it to recommend users new pages they might be interested to fan (follow). This setting can be generalized to other recommendation problems: for instance, embedding and recommending movies to users based on movies watched in the past; embed and recommend restaurants to users based on the restaurants checked-in by users in the past, etc.

**Model：** Users are represented as the bag of pages that they follow (fan). That is, we do not learn a direct embedding of users, instead, each user will have an embedding which is the average embedding of pages fanned by the user. Pages are embedded directly (with a unique feature in the dictionary). This setup can work better in the case where the number of users is larger than the number of pages, and the number of pages fanned by each user is small on average (i.e. the edges between user and page is relatively sparse). It also generalizes to new users without retraining. However, the more traditional recommendation setting can also be used.

![user-page](https://github.com/facebookresearch/Starspace/blob/master/examples/user-page.png)

Each user is represented by the bag-of-pages fanned by the user, and each training example is a single user.

**Input file format:**

    page_1 page_2 ... page_M

At training time, at each step for each example (user), one random page is selected as a label and the rest of bag of pages are selected as input. This can be achieved by setting flag -trainMode to 1. 

**Command:**

    $./starspace train -trainFile input.txt -model pagespace -label 'page' -trainMode 1


## DocSpace document recommendation

**Setting:** We want to embed and recommend web documents for users based on their historical likes/click data. 

**Model:** Each document is represented by a bag-of-words of the document. Each user is represented as a (bag of) the documents that they liked/clicked in the past. 
At training time, at each step one random document is selected as the label and the rest of the bag of documents are selected as input. 

![user-doc](https://github.com/facebookresearch/Starspace/blob/master/examples/user-doc.png)


**Input file format:**

    roger federer loses <tab> venus williams wins <tab> world series ended
    i love cats <tab> funny lolcat links <tab> how to be a petsitter  
    
Each line is a user, and each document (documents separated by tabs) are documents that they liked.
So the first user likes sports, and the second is interested in pets in this case.
    
**Command:**

    ./starspace train -trainFile input.txt -model docspace -trainMode 1 -fileFormat labelDoc
    
    
## GraphSpace: Link Prediction in Knowledge Bases ##

**Setting:** Learning the mapping between entities and relations in <a href="http://www.freebase.com">Freebase</a>. In freebase, data comes in the format 

    (head_entity, relation_type, tail_entity)

Performing link prediction can be formalized as filling in incomplete triples like 

    (head_entity, relation_type, ?) or (?, relation_type, tail_entity)

**Model:** We learn the embeddings of all entities and relation types. For each realtion_type, we learn two embeddings: one for predicting tail_entity given head_entity, one for predicting head_entity given tail_entity.

![multi-rel](https://github.com/facebookresearch/StarSpace/blob/master/examples/multi-relations.png)

### Example scripts:
<a href="https://github.com/facebookresearch/Starspace/blob/master/examples/multi_relation_example.sh">This example script</a> downloads the Freebase15k data from <a href="https://everest.hds.utc.fr/doku.php?id=en:transe">here</a> and runs the StarSpace model on it:

    $bash examples/multi_relation_example.sh
   
    
## SentenceSpace: 学习句子的嵌入

**用途：** 学习句子之间的映射。给定一个句子的嵌入，可以找到语义上相似或相关的句子。

**模型：** 每个例子是语义相关的句子的集合。 随机采用 trainMode 3 来选择两个：一个作为输入，一个作为标签，其他句子被挑选为随机的否定。 在没有标注的情况下获取语义相关句子的一个简单方法是考虑同一文档中的所有句子是相关的，然后在这些文档上进行训练。

![sentences](https://github.com/facebookresearch/StarSpace/blob/master/examples/sentences.png)

### 示例脚本：
[这个示例脚本](https://github.com/facebookresearch/Starspace/blob/master/examples/wikipedia_sentence_matching.sh) 会下载一些数据，其中每个示例都是来自同一维基百科页面的一组语句，并在其上运行StarSpace模型：

    $bash examples/wikipedia_sentence_matching.sh
    
为了能运行 [这篇论文](https://arxiv.org/abs/1709.03856) 中提出的 Wikipedia Sentence Matching 问题的完整实验，
请使用 [这个脚本](https://github.com/facebookresearch/Starspace/blob/master/examples/wikipedia_sentence_matching_full.sh)（警告：下载数据和训练模型需要很长时间）：

    $bash examples/wikipedia_sentence_matching_full.sh
    
    
## ArticleSpace：学习句子和文章的嵌入

**Setting:** Learning the mapping between sentences and articles. Given the embedding of one sentence, one can find the most relevant articles.

**Model:** Each example is an article which contains multiple sentences. At training time, one sentence is picked at random as the input, the remaining sentences in the article becomes the label, other articles are picked as random negatives (trainMode 2).

### Example scripts:
<a href="https://github.com/facebookresearch/Starspace/blob/master/examples/wikipedia_article_search.sh">This example script</a> downloads data where each example is a Wikipedia article and runs the StarSpace model on it:

    $bash examples/wikipedia_article_search.sh
    
To run the full experiment on Wikipedia Article Search presented in [this paper](https://arxiv.org/abs/1709.03856), 
use <a href="https://github.com/facebookresearch/Starspace/blob/master/examples/wikipedia_article_search_full.sh">this script</a> (warning: it takes a long time to download data and train the model):

    $bash examples/wikipedia_article_search_full.sh
    
## ImageSpace: Learning Image and Label Embeddings

With the most recent update, StarSpace can also be used to learn joint embeddings with images and other entities. For instance, one can use ResNet features (the last layer of a pre-trained ResNet model) to represent an image, and embed images with other entities (words, hashtags, etc.). Just like other entities in Starspace, images can be either on the input or the label side, depending on your task.

Here we give an example using <a href="https://www.cs.toronto.edu/~kriz/cifar.html">CIFAR-10</a> to illustrate how we train images with other entities (in this example, image class): we train a <a href="https://github.com/facebookresearch/ResNeXt">ResNeXt</a> model on CIFAR-10  which achieves 96.34% accuracy on test dataset, and use the last layer of ResNeXt as the features for each image. We embed 10 image classes together with image features in the same space using StarSpace. For an example image from class 1 with last layer (0.8, 0.5, ..., 1.2), we convert it to the following format:
    
    d1:0.8  d2:0.5   ...    d1024:1.2   __label__1

After converting train and test examples of CIFAR-10 to the above format, we ran <a href="https://github.com/facebookresearch/StarSpace/blob/master/examples/image_feature_example_cifar10.sh">this example script</a>:

    $bash examples/image_feature_example_cifar10.sh

and achieved 96.56% accuracy on an average of 5 runs.

# Full Documentation of Parameters
    
    Run "starspace train ..." or "starspace test ..."
    
    The following arguments are mandatory for train: 
      -trainFile       training file path
      -model           output model file path

    The following arguments are mandatory for test: 
      -testFile        test file path
      -model           model file path

    The following arguments for the dictionary are optional:
      -minCount        minimal number of word occurences [1]
      -minCountLabel   minimal number of label occurences [1]
      -ngrams          max length of word ngram [1]
      -bucket          number of buckets [2000000]
      -label           labels prefix [__label__]. See file format section.

    The following arguments for training are optional:
      -initModel       if not empty, it loads a previously trained model in -initModel and carry on training.
      -trainMode       takes value in [0, 1, 2, 3, 4, 5], see Training Mode Section. [0]
      -fileFormat      currently support 'fastText' and 'labelDoc', see File Format Section. [fastText]
      -saveEveryEpoch  save intermediate models after each epoch [false]
      -saveTempModel   save intermediate models after each epoch with an unique name including epoch number [false]
      -lr              learning rate [0.01]
      -dim             size of embedding vectors [10]
      -epoch           number of epochs [5]
      -maxTrainTime    max train time (secs) [8640000]
      -negSearchLimit  number of negatives sampled [50]
      -maxNegSamples   max number of negatives in a batch update [10]
      -loss            loss function {hinge, softmax} [hinge]
      -margin          margin parameter in hinge loss. It's only effective if hinge loss is used. [0.05]
      -similarity      takes value in [cosine, dot]. Whether to use cosine or dot product as similarity function in  hinge loss.
                       It's only effective if hinge loss is used. [cosine]
      -adagrad         whether to use adagrad in training [1]
      -shareEmb        whether to use the same embedding matrix for LHS and RHS. [1]
      -ws              only used in trainMode 5, the size of the context window for word level training. [5]
      -dropoutLHS      dropout probability for LHS features. [0]
      -dropoutRHS      dropout probability for RHS features. [0]
      -initRandSd      initial values of embeddings are randomly generated from normal distribution with mean=0, standard deviation=initRandSd. [0.001]

    The following arguments for test are optional:
      -basedoc         file path for a set of labels to compare against true label. It is required when -fileFormat='labelDoc'.
                       In the case -fileFormat='fastText' and -basedoc is not provided, we compare true label with all other labels in the dictionary.
      -predictionFile  file path for save predictions. If not empty, top K predictions for each example will be saved.
      -K               if -predictionFile is not empty, top K predictions for each example will be saved.

    The following arguments are optional:
      -normalizeText   whether to run basic text preprocess for input files [0]
      -useWeight       whether input file contains weights [0]
      -verbose         verbosity level [0]
      -debug           whether it's in debug mode [0]
      -thread          number of threads [10]


Note: We use the same implementation of word n-grams for words as in <a href="https://github.com/facebookresearch/fastText">fastText</a>. When "-ngrams" is set to be larger than 1, a hashing map of size specified by the "-bucket" argument is used for n-grams; when "-ngrams" is set to 1, no hash map is used, and the dictionary contains all words within the minCount and minCountLabel constraints.


## Utility Functions

We also provide a few utility functions for StarSpace:
### Show Predictions for Queries

A simple way to check the quality of a trained embedding model is to inspect the predictions when typing in an input. To build and use this utility function, run the following commands:

    make query_predict
    ./query_predict <model> k [basedocs]
    
where "\<model\>" specifies a trained StarSpace model and the optional K specifies how many of the top predictions to show (top ranked first). "basedocs" points to the file of documents to rank, see also the argument of the same name in the starspace main above. If "basedocs" is not provided, the labels in the dictionary are used instead.

After loading the model, it reads a line of entities (can be either a single word or a sentence / document), and outputs the predictions.

### Nearest Neighbor Queries

Another simple way to check the quality of a trained embedding model is to inspect nearest neighbors of entities. To build and use this utility function, run the following commands:

    make query_nn
    ./query_nn <model> [k]
    
where "\<model\>" specifies a trained StarSpace model and the optional K (default value is 5) specifies how many nearest neighbors to search for.

After loading the model, it reads a line of entities (can be either a single word or a sentence / document), and output the nearest entities in embedding space.

### Print Ngrams

As the ngrams used in the model are not saved in tsv format, we also provide a separate function to output n-grams embeddings from the model. To use that, run the following commands:

    make print_ngrams
    ./print_ngrams <model>
    
where "\<model\>" specifies a trained StarSpace model with argument -ngrams > 1.

### Print Sentence / Document Embedding

Sometimes it is useful to print out sentence / document embeddings from a trained model. To use that, run the following commands:

    make embed_doc
    ./embed_doc <model> [filename]
    
where "\<model\>" specifies a trained StarSpace model. If filename is provided, it reads each sentence / document from file, line by line, and outputs vector embeddings accordingly. If the filename is not provided, it reads each sentence / document from stdin.


## Citation

Please cite the [arXiv paper](https://arxiv.org/abs/1709.03856) if you use StarSpace in your work:

```
@article{wu2017starspace,
  title={StarSpace: Embed All The Things!},
  author = {{Wu}, L. and {Fisch}, A. and {Chopra}, S. and {Adams}, K. and {Bordes}, A. and {Weston}, J.},
  journal={arXiv preprint arXiv:{1709.03856}},
  year={2017}
}
```
## Contact
* Facebook group: [StarSpace Users](https://www.facebook.com/groups/532005453808326)
* emails: ledell@fb.com, jase@fb.com


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
