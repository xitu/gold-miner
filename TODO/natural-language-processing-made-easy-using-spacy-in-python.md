
> * 原文地址：[Natural Language Processing Made Easy – using SpaCy (in Python)](https://www.analyticsvidhya.com/blog/2017/04/natural-language-processing-made-easy-using-spacy-%E2%80%8Bin-python/)
> * 原文作者：[Shivam Bansal](https://www.analyticsvidhya.com/blog/author/shivam5992/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/natural-language-processing-made-easy-using-spacy-in-python.md](https://github.com/xitu/gold-miner/blob/master/TODO/natural-language-processing-made-easy-using-spacy-in-python.md)
> * 译者：[lsvih](https://github.com/lsvih)
> * 校对者：[yzgyyang](https://github.com/yzgyyang),[sqrthree](https://github.com/sqrthree)

# 使用 Python+spaCy 进行简易自然语言处理

## 简介

自然语言处理（NLP）是人工智能领域最重要的部分之一。它在许多智能应用中担任了关键的角色，例如聊天机器人、正文提取、多语翻译以及观点识别等应用。业界 NLP 相关的公司都意识到了，处理非结构文本数据时，不仅要看正确率，还需要注意是否能快速得到想要的结果。

NLP 是一个很宽泛的领域，它包括了文本分类、实体识别、机器翻译、问答系统、概念识别等子领域。在我最近的一篇[文章](https://www.analyticsvidhya.com/blog/2017/01/ultimate-guide-to-understand-implement-natural-language-processing-codes-in-python/)中，我探讨了许多用于实现 NLP 的工具与组件。在那篇文章中，我更多的是在描述[NLTK](http://www.nltk.org/)（Natural Language Toolkit）这个伟大的库。

在这篇文章中，我会将 spaCy —— 这个现在最强大、最先进的 NLP python 库分享给你们。

** **

## 内容提要

1. spaCy 简介及安装方法
2. spaCy 的管道与属性
	- Tokenization
	- 词性标注
	- 实体识别
	- 依存句法分析
	- 名词短语

3. 集成词向量计算
4. 使用 spaCy 进行机器学习
5. 与 NLTK 和 CoreNLP 对比

** **

## 1. spaCy 简介及安装方法

### 1.1 简介

spaCy 由 cython（Python 的 C 语言拓展，旨在让 python 程序达到如同 C 程序一样的性能）编写，因此它的运行效率非常高。spaCy 提供了一系列简洁的 API 方便用户使用，并基于已经训练好的机器学习与深度学习模型实现底层。

** **

### 1.2 安装

spaCy 及其数据和模型可以通过 pip 和安装工具轻松地完成安装。使用下面的命令在电脑中安装 spaCy：

    sudo pip install spacy

如果你使用的是 Python3，请用 “pip3” 代替 “pip”。

或者你也可以在 [这儿](https://pypi.python.org/pypi/spacy) 下载源码，解压后运行下面的命令安装：

    python setup.py install

在安装好 spacy 之后，请运行下面的命令以下载所有的数据集和模型：

    python -m spacy.en.download all

一切就绪，现在你可以自由探索、使用 spacy 了。



## 2. spaCy 的管道（Pipeline）与属性（Properties）

spaCy 的使用，以及其各种属性，是通过创建管道实现的。在加载模型的时候，spaCy 会将管道创建好。在 spaCy 包中，提供了各种各样的[模块](https://github.com/explosion/spacy-models/)，这些模块中包含了各种关于词汇、训练向量、语法和实体等用于语言处理的信息。

下面，我们会加载默认的模块（english-core-web 模块）。

    import spacy
    nlp = spacy.load(“en”)

“nlp” 对象用于创建 document、获得 linguistic annotation 及其它的 nlp 属性。首先我们要创建一个 document，将文本数据加载进管道中。我使用了来自猫途鹰网的旅店评论数据。这个数据文件可以在[这儿](https://s3-ap-south-1.amazonaws.com/av-blog-media/wp-content/uploads/2017/04/04080929/Tripadvisor_hotelreviews_Shivambansal.txt)下载。

    document = unicode(open(filename).read().decode('utf8'))
    document = nlp(document)

这个 document 现在是 spacy.english 模型的一个 class，并关联上了许多的属性。可以使用下面的命令列出所有 document（或 token）的属性：

    dir(document)
    >> [ 'doc', 'ents', … 'mem']

它会输出 document 中各种各样的属性，例如：token、token 的 index、词性标注、实体、向量、情感、单词等。下面让我们会对其中的一些属性进行一番探究。



### 2.1 Tokenization

spaCy 的 document 可以在 tokenized 过程中被分割成单句，这些单句还可以进一步分割成单词。你可以通过遍历文档来读取这些单词：

    # document 的首个单词
    document[0]
    >> Nice
    
    # document 的最后一个单词  
    document[len(document)-5]
    >> boston
    
    # 列出 document 中的句子
    list(document.sents)
    >> [ Nice place Better than some reviews give it credit for.,
     Overall, the rooms were a bit small but nice.,
    ...
    Everything was clean, the view was wonderful and it is very well located (the Prudential Center makes shopping and eating easy and the T is nearby for jaunts out and about the city).]



### 2.2 词性标注(POS Tag)

词性标注即标注语法正确的句子中的词语的词性。这些标注可以用于信息过滤、统计模型，或者基于某些规则进行文本解析。

来看看我们的 document 中所有的词性标注：

    # 获得所有标注
    all_tags = {w.pos: w.pos_ for w in document}
    >> {97:  u'SYM', 98: u'VERB', 99: u'X', 101: u'SPACE', 82: u'ADJ', 83: u'ADP', 84: u'ADV', 87: u'CCONJ', 88: u'DET', 89: u'INTJ', 90: u'NOUN', 91: u'NUM', 92: u'PART', 93: u'PRON', 94: u'PROPN', 95: u'PUNCT'}
    
    # document 中第一个句子的词性标注
    for word in list(document.sents)[0]:  
        print word, word.tag_
    >> ( Nice, u'JJ') (place, u'NN') (Better, u'NNP') (than, u'IN') (some, u'DT') (reviews, u'NNS') (give, u'VBP') (it, u'PRP') (creit, u'NN') (for, u'IN') (., u'.')



来看一看 document 中的最常用词汇。我已经事先写好了预处理和文本数据清洗的函数。

    #一些参数定义
    noisy_pos_tags = [“PROP”]
    min_token_length = 2
    
    #检查 token 是不是噪音的函数
    def isNoise(token):     
        is_noise = False
        if token.pos_ in noisy_pos_tags:
            is_noise = True
        elif token.is_stop == True:
            is_noise = True
        elif len(token.string) <= min_token_length:
            is_noise = True
        return is_noise
    def cleanup(token, lower = True):
        if lower:
           token = token.lower()
        return token.strip()
    
    # 评论中最常用的单词
    from collections import Counter
    cleaned_list = [cleanup(word.string) for word in document if not isNoise(word)]
    Counter(cleaned_list) .most_common(5)
    >> [( u'hotel', 683), (u'room', 652), (u'great', 300),  (u'sheraton', 285), (u'location', 271)]



### 2.3 实体识别

spaCy 拥有一个快速实体识别模型，这个实体识别模型能够从 document 中找出实体短语。它能识别各种类型的实体，例如人名、位置、机构、日期、数字等。你可以通过“.ents”属性来读取这些实体。

下面让我们来获取我们 document 中所有类型的命名实体：

    labels = set([w.label_ for w in document.ents])
    for label in labels:
        entities = [cleanup(e.string, lower=False) for e in document.ents if label==e.label_]
        entities = list(set(entities))
        print label,entities



### 2.4 依存句法分析

spaCy 最强大的功能之一就是它可以通过调用轻量级的 API 来实现又快又准确的依存分析。这个分析器也可以用于句子边界检测以及区分短语块。依存关系可以通过“.children”、“.root”、“.ancestor”等属性读取。

    # 取出所有句中包含“hotel”单词的评论
    hotel = [sent for sent in document.sents if 'hotel' in sent.string.lower()]
    
    # 创建依存树
    sentence = hotel[2] for word in sentence:
    print word, ': ', str(list(word.children))
    >> A :  []  cab :  [A, from]
    from :  [airport, to]
    the :  []
    airport :  [the]
    to :  [hotel]
    the :  [] hotel :  
    [the] can :  []
    be :  [cab, can, cheaper, .]
    cheaper :  [than] than :  
    [shuttles]
    the :  []
    shuttles :  [the, depending]
    depending :  [time] what :  []
    time :  [what, of] of :  [day]
    the :  [] day :  
    [the, go] you :  
    []
    go :  [you]
    . :  []

解析所有居中包含“hotel”单词的句子的依存关系，并检查对于 hotel 人们用了哪些形容词。我创建了一个自定义函数，用于分析依存关系并进行相关的词性标注。

    # 检查修饰某个单词的所有形容词
    def pos_words (sentence, token, ptag):
        sentences = [sent for sent in sentence.sents if token in sent.string]     
        pwrds = []
        for sent in sentences:
            for word in sent:
                if character in word.string:
                       pwrds.extend([child.string.strip() for child in word.children
                                                          if child.pos_ == ptag] )
        return Counter(pwrds).most_common(10)
    
    pos_words(document, 'hotel', “ADJ”)
    >> [(u'other', 20), (u'great', 10), (u'good', 7), (u'better', 6), (u'nice', 6), (u'different', 5), (u'many', 5), (u'best', 4), (u'my', 4), (u'wonderful', 3)]



### 2.5 名词短语（NP）

依存树也可以用来生成名词短语：

    # 生成名词短语
    doc = nlp(u'I love data science on analytics vidhya')
    for np in doc.noun_chunks:
        print np.text, np.root.dep_, np.root.head.text
    >> I nsubj love
       data science dobj love
       analytics pobj on



## 3. 集成词向量

spaCy 提供了内置整合的向量值算法，这些向量值可以反映词中的真正表达信息。它使用 [GloVe](https://nlp.stanford.edu/projects/glove/) 来生成向量。GloVe 是一种用于获取表示单词的向量的无监督学习算法。

让我们创建一些词向量，然后对其做一些有趣的操作吧：

    from numpy import dot
    from numpy.linalg import norm
    from spacy.en import English
    parser = English()
    
    # 生成“apple”的词向量 
    apple = parser.vocab[u'apple']
    
    # 余弦相似性计算函数
    cosine = lambda v1, v2: dot(v1, v2) / (norm(v1) * norm(v2))
    others = list({w for w in parser.vocab if w.has_vector and w.orth_.islower() and w.lower_ != unicode("apple")})
    
    # 根据相似性值进行排序
    others.sort(key=lambda w: cosine(w.vector, apple.vector))
    others.reverse()


    print "top most similar words to apple:"
    for word in others[:10]:
        print word.orth_
    >> apples iphone f ruit juice cherry lemon banana pie mac orange



## 4. 使用 spaCy 对文本进行机器学习

将 spaCy 集成进机器学习模型是非常简单、直接的。让我们使用 sklearn 做一个自定义的文本分类器。我们将使用 cleaner、tokenizer、vectorizer、classifier 组件来创建一个 sklearn 管道。其中的 tokenizer 和 vectorizer 会使用我们用 spaCy 自定义的模块构建。

    from sklearn.feature_extraction.stop_words import ENGLISH_STOP_WORDS as stopwords
    from sklearn.feature_extraction.text import CountVectorizer
    from sklearn.metrics import accuracy_score
    from sklearn.base import TransformerMixin
    from sklearn.pipeline import Pipeline
    from sklearn.svm import LinearSVC
    
    import string
    punctuations = string.punctuation
    
    from spacy.en import English
    parser = English()
    
    # 使用 spaCy 自定义 transformer
    class predictors(TransformerMixin):
        def transform(self, X, **transform_params):
            return [clean_text(text) for text in X]
        def fit(self, X, y=None, **fit_params):
            return self
        def get_params(self, deep=True):
            return {}
    
    # 进行文本清洗的实用的基本函数
    def clean_text(text):     
        return text.strip().lower()

现在让我们使用 spaCy 的解析器和一些基本的数据清洗函数来创建一个自定义的 tokenizer 函数。值得一提的是，你可以用词向量来代替文本特征（使用深度学习模型效果会有较大的提升）

    #创建 spaCy tokenizer，解析句子并生成 token
    #也可以用词向量函数来代替它
    def spacy_tokenizer(sentence):
        tokens = parser(sentence)
        tokens = [tok.lemma_.lower().strip() if tok.lemma_ != "-PRON-" else tok.lower_ for tok in tokens]
        tokens = [tok for tok in tokens if (tok not in stopwords and tok not in punctuations)]     return tokens
    
    #创建 vectorizer 对象，生成特征向量，以此可以自定义 spaCy 的 tokenizer
    vectorizer = CountVectorizer(tokenizer = spacy_tokenizer, ngram_range=(1,1)) classifier = LinearSVC()

现在可以创建管道，加载数据，然后运行分类模型了。

    # 创建管道，进行文本清洗、tokenize、向量化、分类操作
    pipe = Pipeline([("cleaner", predictors()),
                     ('vectorizer', vectorizer),
                     ('classifier', classifier)])
    
    # Load sample data
    train = [('I love this sandwich.', 'pos'),          
             ('this is an amazing place!', 'pos'),
             ('I feel very good about these beers.', 'pos'),
             ('this is my best work.', 'pos'),
             ("what an awesome view", 'pos'),
             ('I do not like this restaurant', 'neg'),
             ('I am tired of this stuff.', 'neg'),
             ("I can't deal with this", 'neg'),
             ('he is my sworn enemy!', 'neg'),          
             ('my boss is horrible.', 'neg')]
    test =   [('the beer was good.', 'pos'),     
             ('I do not enjoy my job', 'neg'),
             ("I ain't feelin dandy today.", 'neg'),
             ("I feel amazing!", 'pos'),
             ('Gary is a good friend of mine.', 'pos'),
             ("I can't believe I'm doing this.", 'neg')]
    
    # 创建模型并计算准确率
    pipe.fit([x[0] for x in train], [x[1] for x in train])
    pred_data = pipe.predict([x[0] for x in test])
    for (sample, pred) in zip(test, pred_data):
        print sample, pred
    print "Accuracy:", accuracy_score([x[1] for x in test], pred_data)
    
    >>    ('the beer was good.', 'pos') pos
          ('I do not enjoy my job', 'neg') neg
          ("I ain't feelin dandy today.", 'neg') neg
          ('I feel amazing!', 'pos') pos
          ('Gary is a good friend of mine.', 'pos') pos
          ("I can't believe I'm doing this.", 'neg') neg
          Accuracy: 1.0

## 5. 和其它库的对比

Spacy 是一个非常强大且具备工业级能力的 NLP 包，它能满足大多数 NLP 任务的需求。可能你会思考：为什么会这样呢？

让我们把 Spacy 和另外两个 python 中有名的实现 NLP 的工具 —— CoreNLP 和 NLTK 进行对比吧！

### 支持功能表

| 功能         | Spacy | NLTK | Core NLP |
| ---------- | ----- | ---- | -------- |
| 简易的安装方式    | Y     | Y    | Y        |
| Python API | Y     | Y    | N        |
| 多语种支持      | N     | Y    | Y        |
| 分词         | Y     | Y    | Y        |
| 词性标注       | Y     | Y    | Y        |
| 分句         | Y     | Y    | Y        |
| 依存性分析      | Y     | N    | Y        |
| 实体识别       | Y     | Y    | Y        |
| 词向量计算集成    | Y     | N    | N        |
| 情感分析       | Y     | Y    | Y        |
| 共指消解       | N     | N    | Y        |

### 速度：主要功能（Tokenizer、Tagging、Parsing）速度

| **库**   | **Tokenizer** | **Tagging** | **Parsing** |
| ------- | ------------- | ----------- | ----------- |
| spaCy   | 0.2ms         | 1ms         | 19ms        |
| CoreNLP | 2ms           | 10ms        | 49ms        |
| NLTK    | 4ms           | 443ms       | –           |

### 准确性：实体抽取结果

| **库**   | **准确率** | **Recall** | **F-Score** |
| ------- | ------- | ---------- | ----------- |
| spaCy   | 0.72    | 0.65       | 0.69        |
| CoreNLP | 0.79    | 0.73       | 0.76        |
| NLTK    | 0.51    | 0.65       | 0.58        |

## 结束语

本文讨论了 spaCy —— 这个基于 python，完全用于实现 NLP 的库。我们通过许多用例展示了 spaCy 的可用性、速度及准确性。最后我们还将其余其它几个著名的 NLP 库 —— CoreNLP 与 NLTK 进行了对比。

如果你能真正理解这篇文章要表达的内容，那你一定可以去实现各种有挑战的文本数据与 NLP 问题。

希望你能喜欢这篇文章，如果你有疑问、问题或者别的想法，请在评论中留言。


作者介绍：

[Shivam Bansal](https://www.analyticsvidhya.com/blog/author/shivam5992/)

Shivam Bansal 是一位数据科学家，在 NLP 与机器学习领域有着丰富的经验。他乐于学习，希望能解决一些富有挑战性的分析类问题。

- [https://twitter.com/shivamshaz](https://twitter.com/shivamshaz)
- [https://www.linkedin.com/in/shivambansal1](https://www.linkedin.com/in/shivambansal1)
- [https://github.com/shivam5992](https://github.com/shivam5992)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。


