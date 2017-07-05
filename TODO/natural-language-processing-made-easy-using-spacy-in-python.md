
> * 原文地址：[Natural Language Processing Made Easy – using SpaCy (​in Python)](https://www.analyticsvidhya.com/blog/2017/04/natural-language-processing-made-easy-using-spacy-%E2%80%8Bin-python/)
> * 原文作者：[Shivam Bansal](https://www.analyticsvidhya.com/blog/author/shivam5992/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/natural-language-processing-made-easy-using-spacy-in-python.md](https://github.com/xitu/gold-miner/blob/master/TODO/natural-language-processing-made-easy-using-spacy-in-python.md)
> * 译者：
> * 校对者：

# Natural Language Processing Made Easy – using SpaCy (​in Python)

## Introduction

Natural Language Processing is one of the principal areas of Artificial Intelligence. NLP plays a critical role in many intelligent applications such as automated chat bots, article summarizers, multi-lingual translation and opinion identification from data. Every industry which exploits NLP to make sense of unstructured text data, not just demands accuracy, but also swiftness in obtaining results.

Natural Language Processing is a capacious field, some of the tasks in nlp are – text classification, entity detection, machine translation, question answering, and concept identification. In one of my last [article](https://www.analyticsvidhya.com/blog/2017/01/ultimate-guide-to-understand-implement-natural-language-processing-codes-in-python/), I discussed various tools and components that are used in the implementation of NLP. Most of the components discussed in the article were described using venerated library – [NLTK](http://www.nltk.org/)(Natural Language Toolkit).

In this article, I will share my notes on one of the powerful and advanced libraries used to implement nlp – spaCy.

** **

## Table of Content

1. About spaCy and Installation
2. SpaCy pipeline and properties
	- Tokenization
	- Pos Tagging
	- Entity Detection
	- Dependency Parsing
3. Noun Phrases
4. Word Vectors
5. Integrating spaCy with Machine Learning
6. Comparison with NLTK and CoreNLP

** **

## 1. About spaCy and Installation

### 1.1 About

Spacy is written in cython language, (C extension of Python designed to give C like performance to the python program). Hence is a quite fast library. spaCy provides a concise API to access its methods and properties governed by trained machine (and deep) learning models.

** **

### 1.2 Installation

Spacy, its data, and its models can be easily installed using python package index and setup tools. Use the following command to install spacy in your machine:

    sudo pip install spacy

In case of Python3, replace “pip” with “pip3” in the above command.

OR download the source from [here](https://pypi.python.org/pypi/spacy) and run the following command, after unzipping:

    python setup.py install

To download all the data and models, run the following command, after the installation:

    python -m spacy.en.download all

You are now all set to explore and use spacy.



## 2. SpaCy Pipeline and Properties

Implementation of spacy and access to different properties is initiated by creating pipelines. A pipeline is created by loading the models. There are different type of [models](https://github.com/explosion/spacy-models/) provided in the package which contains the information about language – vocabularies, trained vectors, syntaxes and entities.

We will load the default model which is english-core-web.

    import spacy
    nlp = spacy.load(“en”)

The object “nlp” is used to create documents, access linguistic annotations and different nlp properties. Let’s create a document by loading a text data in our pipeline. I am using reviews of a hotel obtained from tripadvisor’s website. The data file can be downloaded [here](https://s3-ap-south-1.amazonaws.com/av-blog-media/wp-content/uploads/2017/04/04080929/Tripadvisor_hotelreviews_Shivambansal.txt).

    document = unicode(open(filename).read().decode('utf8'))
    document = nlp(document)

The document is now part of spacy.english model’s class and is associated with a number of properties. The properties of a document (or tokens) can listed by using following command:

    dir(document)
    >> [ 'doc', 'ents', … 'mem']

This outputs a wide range of document properties such as – tokens, token’s reference index, part of speech tags, entities, vectors, sentiment, vocabulary etc. Let’s explore some of these properties.



### 2.1 Tokenization

Every spaCy document is tokenized into sentences and further into tokens which can be accessed by iterating the document:

    # first token of the doc
    document[0]
    >> Nice

    # last token of the doc  
    document[len(document)-5]
    >> boston

    # List of sentences of our doc
    list(document.sents)
    >> [ Nice place Better than some reviews give it credit for.,
     Overall, the rooms were a bit small but nice.,
    ...
    Everything was clean, the view was wonderful and it is very well located (the Prudential Center makes shopping and eating easy and the T is nearby for jaunts out and about the city).]



### 2.2 Part of Speech Tagging

Part-of-speech tags are the properties of the word that are defined by the usage of the word in the grammatically correct sentence. These tags can be used as the text features in information filtering, statistical models, and rule based parsing.

Lets check all the pos tags of our document

    # get all tags
    all_tags = {w.pos: w.pos_ for w in document}
    >> {97:  u'SYM', 98: u'VERB', 99: u'X', 101: u'SPACE', 82: u'ADJ', 83: u'ADP', 84: u'ADV', 87: u'CCONJ', 88: u'DET', 89: u'INTJ', 90: u'NOUN', 91: u'NUM', 92: u'PART', 93: u'PRON', 94: u'PROPN', 95: u'PUNCT'}

    # all tags of first sentence of our document
    for word in list(document.sents)[0]:  
        print word, word.tag_
    >> ( Nice, u'JJ') (place, u'NN') (Better, u'NNP') (than, u'IN') (some, u'DT') (reviews, u'NNS') (give, u'VBP') (it, u'PRP') (creit, u'NN') (for, u'IN') (., u'.')



Let’s explore some top unigrams of the document. I have created a basic preprocessing and text cleaning function.

    #define some parameters  
    noisy_pos_tags = [“PROP”]
    min_token_length = 2

    #Function to check if the token is a noise or not  
    def isNoise(token):     
        is_noise = False
        if token.pos_ in noisy_pos_tags:
            is_noise = True
        elif token.is_stop == True:
            is_noise = True
        elif len(token.string) <= min_token_length:
            is_noise = True
        return is_noise**
    **def cleanup(token, lower = True):
        if lower:
           token = token.lower()
        return token.strip()

    # top unigrams used in the reviews
    from collections import Counter
    cleaned_list = [cleanup(word.string) for word in document if not isNoise(word)]
    Counter(cleaned_list) .most_common(5)
    >> [( u'hotel', 683), (u'room', 652), (u'great', 300),  (u'sheraton', 285), (u'location', 271)]



### 2.3 Entity Detection

Spacy consists of a fast entity recognition model which is capable of identifying entitiy phrases from the document. Entities can be of different types, such as – person, location, organization, dates, numerals, etc. These entities can be accessed through “.ents” property.

Let’s find all the types of named entities from present in our document.

    labels = set([w.label_ for w in document.ents])
    for label in labels:
        entities = [cleanup(e.string, lower=False) for e in document.ents if label==e.label_]
        entities = list(set(entities))
        print label,entities



### 2.4 Dependency Parsing

One of the most powerful feature of spacy is the extremely fast and accurate syntactic dependency parser which can be accessed via lightweight API. The parser can also be used for sentence boundary detection and phrase chunking. The relations can be accessed by the properties “.children” , “.root”, “.ancestor” etc.

    # extract all review sentences that contains the term - hotel
    hotel = [sent for sent in document.sents if 'hotel' in sent.string.lower()]

    # create dependency tree
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

Let’s parse the dependency tree of all the sentences which contains the term hotel and check what are the adjectival tokens used for hotel. I have created a custom function that parses a dependency tree and extracts relevant pos tag.

    # check all adjectives used with a word
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



### 2.5 Noun Phrases

Dependency trees can also be used to generate noun phrases:

    # Generate Noun Phrases
    doc = nlp(u'I love data science on analytics vidhya')
    for np in doc.noun_chunks:
        print np.text, np.root.dep_, np.root.head.text
    >> I nsubj love
       data science dobj love
       analytics pobj on



## 3. Word to Vectors Integration

Spacy also provides inbuilt integration of dense, real valued vectors representing distributional similarity information. It uses [GloVe](https://nlp.stanford.edu/projects/glove/)vectors to generate vectors. GloVe is an unsupervised learning algorithm for obtaining vector representations for words.

Let’s create some word vectors and perform some interesting operations.

    from numpy import dot
    from numpy.linalg import norm
    from spacy.en import English
    parser = English()

    #Generate word vector of the word - apple  
    apple = parser.vocab[u'apple']

    #Cosine similarity function
    cosine = lambda v1, v2: dot(v1, v2) / (norm(v1) * norm(v2))
    others = list({w for w in parser.vocab if w.has_vector and w.orth_.islower() and w.lower_ != unicode("apple")})

    # sort by similarity score
    others.sort(key=lambda w: cosine(w.vector, apple.vector))
    others.reverse()


    print "top most similar words to apple:"
    for word in others[:10]:
        print word.orth_
    >> apples iphone f ruit juice cherry lemon banana pie mac orange



## 4. Machine Learning with text using Spacy

Integrating spacy in machine learning model is pretty easy and straightforward. Let’s build a custom text classifier using sklearn. We will create a sklearn pipeline with following components: cleaner, tokenizer, vectorizer, classifier. For tokenizer and vectorizer we will built our own custom modules using spacy.

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

    #Custom transformer using spaCy
    class predictors(TransformerMixin):
        def transform(self, X, **transform_params):
            return [clean_text(text) for text in X]
        def fit(self, X, y=None, **fit_params):
            return self
        def get_params(self, deep=True):
            return {}

    # Basic utility function to clean the text
    def clean_text(text):     
        return text.strip().lower()

Let’s now create a custom tokenizer function using spacy parser and some basic cleaning. One thing to note here is that, the text features can be replaced with word vectors (especially beneficial in deep learning models)

    #Create spacy tokenizer that parses a sentence and generates tokens
    #these can also be replaced by word vectors
    def spacy_tokenizer(sentence):
        tokens = parser(sentence)
        tokens = [tok.lemma_.lower().strip() if tok.lemma_ != "-PRON-" else tok.lower_ for tok in tokens]
        tokens = [tok for tok in tokens if (tok not in stopwords and tok not in punctuations)]     return tokens

    #create vectorizer object to generate feature vectors, we will use custom spacy’s tokenizer
    vectorizer = CountVectorizer(tokenizer = spacy_tokenizer, ngram_range=(1,1)) classifier = LinearSVC()

We are now ready to create the pipeline, load the data (sample here), and run the classifier model.

    # Create the  pipeline to clean, tokenize, vectorize, and classify
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

    # Create model and measure accuracy
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

## 5. Comparison with other libraries

Spacy is very powerful and industrial strength package for almost all natural language processing tasks. If you are wondering why?

Let’s compare Spacy with other famous tools to implement nlp in python – CoreNLP and NLTK.

### Feature Availability

| Feature | Spacy | NLTK | Core NLP |
| Easy installation | Y | Y | Y |
| Python API | Y | Y | N |
| Multi Language support | N | Y | Y |
| Tokenization | Y | Y | Y |
| Part-of-speech tagging | Y | Y | Y |
| Sentence segmentation | Y | Y | Y |
| Dependency parsing | Y | N | Y |
| Entity Recognition | Y | Y | Y |
| Integrated word vectors | Y | N | N |
| Sentiment analysis | Y | Y | Y |
| Coreference resolution | N | N | Y |

### Speed: Key Functionalities – Tokenizer, Tagging, Parsing

| **Package** | **Tokenizer** | **Tagging** | **Parsing** |
| spaCy | 0.2ms | 1ms | 19ms |
| CoreNLP | 2ms | 10ms | 49ms |
| NLTK | 4ms | 443ms | – |

### Accuracy: Entity Extraction

| **Package** | **Precition** | **Recall** | **F-Score** |
| spaCy | 0.72 | 0.65 | 0.69 |
| CoreNLP | 0.79 | 0.73 | 0.76 |
| NLTK | 0.51 | 0.65 | 0.58 |

## End Notes

In this article we discussed about Spacy – a complete package to implement NLP tasks in python. We went through various examples showcasing the usefulness of spacy, its speed and accuracy. Finally we compared the package with other famous nlp libraries – corenlp and nltk.

Once the concepts described in this article are understood, one can implement (really) challenging problems exploiting text data and natural language processing.

I hope you enjoyed reading this article, feel free to post your doubts, questions or any thoughts in the comments section.

Author

[Shivam Bansal](https://www.analyticsvidhya.com/blog/author/shivam5992/)

Shivam Bansal is a data scientist with exhaustive experience in Natural Language Processing and Machine Learning in several domains. He is passionate about learning and always looks forward to solving challenging analytical problems.

- [https://twitter.com/shivamshaz](https://twitter.com/shivamshaz)
- [https://www.linkedin.com/in/shivambansal1](https://www.linkedin.com/in/shivambansal1)
- [https://github.com/shivam5992](https://github.com/shivam5992)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
