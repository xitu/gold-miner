
> * 原文地址：[Contextual Chatbots with Tensorflow](https://chatbotsmagazine.com/contextual-chat-bots-with-tensorflow-4391749d0077)
> * 原文作者：[gk_](https://chatbotsmagazine.com/@gk_)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/contextual-chat-bots-with-tensorflow.md](https://github.com/xitu/gold-miner/blob/master/TODO/contextual-chat-bots-with-tensorflow.md)
> * 译者：[edvardhua](https://github.com/edvardHua)
> * 校对者：[lileizhenshuai](https://github.com/lileizhenshuai), [jasonxia23](https://github.com/jasonxia23)

# 基于 TensorFlow 的上下文机器人

在对话中， **语境决定了一切！** ，在这篇文章中我们将使用 TensorFlow 构建一个能够处理上下文的聊天机器人框架。

有没有想过为什么大多数聊天机器人都不能够理解语境的上下文？

怎么可能在所有的对话中考虑到上下文的重要性？

我们将创建一个“聊天机器人”框架，并为一个岛上的汽车出租店建立一个会话模型，这个小型的聊天机器人需要能够处理关于时间计算，预订选择等简单的功能。我们还希望他能够响应一些上下文的操作，譬如询问当天的租金。这样的话，我们的工作就可以减轻不少。

我们将通过下面三步来实现这个功能：

- 首先，把对话意图的定义转换成 TensoFlow 模型
- 接下来，我们构建一个聊天机器人框架来处理响应
- 最后，我们将展示如何将基本的上下文合并到我们的相应处理模块中

我们将使用在 TensorFlow 上构建的高层次 API，也即  [**tflearn**](http://tflearn.org/) ，当然还有 [**Python**](https://www.python.org/) ，同时还使用 [**iPython notebook**](https://ipython.org/notebook.html) 来更好的完成我们的工作


---

#### 将会话意图的定义转换为 TensorFlow 模型

这一部分的完整笔记在[这里](https://github.com/ugik/notebooks/blob/master/Tensorflow%20chat-bot%20model.ipynb)

一个聊天机器人框架需要一个结构，而其中就定义了会话的意图，在这里我们使用了 json 文件来定义他，如这个[文件](https://github.com/ugik/notebooks/blob/master/intents.json)中所示

![](https://cdn-images-1.medium.com/max/800/1*pcbw_Y4acT750-lL98iw2Q.png)

聊天机器人的意图
每个对话的意图都包含：

- 一个 **标签**（tag，唯一标识的名字）
- **模式**（神经网络文本分类器的句子模式）
- **响应**（用作响应）

晚些我们将 **添加一些基本的上下文元素**

首先 import 需要的库

```Python
# NLP 相关的处理库
import nltk
from nltk.stem.lancaster import LancasterStemmer
stemmer = LancasterStemmer()

# TensorFlow 相关的库
import numpy as np
import tflearn
import tensorflow as tf
import random
```

如果你想入门 TensorFlow ，可以看[这篇文章](https://chatbotslife.com/deep-learning-in-7-lines-of-code-7879a8ef8cfb)，若要进一步的了解的话可以看[这篇文章](https://chatbotslife.com/tensorflow-demystified-80987184faf7)。

```Python
# import our chat-bot intents file
import json
with open('intents.json') as json_data:
    intents = json.load(json_data)
```


意图的 JSON 文件被加载后，我们现在可以开始组织我们的文档、文字和分类器对应的类别。


```Python
words = []
classes = []
documents = []
ignore_words = ['?']
# 根据意图遍历所有的句子
for intent in intents['intents']:
    for pattern in intent['patterns']:
        # 分词
        w = nltk.word_tokenize(pattern)
        # 将词添加到列表中
        words.extend(w)
        # 将文档添加到词料库
        documents.append((w, intent['tag']))
        # 将 Tag 添加到类别中
        if intent['tag'] not in classes:
            classes.append(intent['tag'])

# 将词小写然后去掉忽略的词
words = [stemmer.stem(w.lower()) for w in words if w not in ignore_words]
words = sorted(list(set(words)))

# 使用 set 去掉重复的词
classes = sorted(list(set(classes)))

print (len(documents), "documents")
print (len(classes), "classes", classes)
print (len(words), "unique stemmed words", words)
```

我们创建了一个文档（句子）列表，每个句子都是一个词干的列表，每个文档都与一个意图（一个类）相关。

```Python
27 documents
9 classes ['goodbye', 'greeting', 'hours', 'mopeds', 'opentoday', 'payments', 'rental', 'thanks', 'today']
44 unique stemmed words ["'d", 'a', 'ar', 'bye', 'can', 'card', 'cash', 'credit', 'day', 'do', 'doe', 'good', 'goodby', 'hav', 'hello', 'help', 'hi', 'hour', 'how', 'i', 'is', 'kind', 'lat', 'lik', 'mastercard', 'mop', 'of', 'on', 'op', 'rent', 'see', 'tak', 'thank', 'that', 'ther', 'thi', 'to', 'today', 'we', 'what', 'when', 'which', 'work', 'you']
```

词干 "tak" 将会和 "take", "taking","takers" 等词匹配。我们可以清理单词列表并删除无用的条目，但这就足够了。

但是目前的数据结构不能够被 TensorFlow 利用，我们需要进一步的转换它： **也即将文档中的词转换成数字的张量。**


```Python
# 创建训练数据
training = []
output = []
# 创建一个空数组来储存输出
output_empty = [0] * len(classes)

# 每个句子的训练集和词袋
for doc in documents:
    # 初始化词袋
    bag = []
    # 列出文档中所有的词
    pattern_words = doc[0]
    # 让词成为词干
    pattern_words = [stemmer.stem(word.lower()) for word in pattern_words]
    # 创建我们的词袋数组
    for w in words:
        bag.append(1) if w in pattern_words else bag.append(0)

    # 如果是当前的标记输出 1 ，否的话输出 0
    output_row = list(output_empty)
    output_row[classes.index(doc[1])] = 1

    training.append([bag, output_row])

# 打乱训练集并且转换成 np.array 类型
random.shuffle(training)
training = np.array(training)

# 创建训练集
train_x = list(training[:,0])
train_y = list(training[:,1])
```

注意，我们的数据被打乱了。TensorFlow 会使用其中一部分数据用作测试， **以评估训练模型的准确性。**

下面是一个 x 和 y 的列表元素，也即[词袋](https://en.wikipedia.org/wiki/Bag-of-words_model)数组，一个是意图的模式，另一个是意图所对应的类。

```Python
train_x example: [0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1]
train_y example: [0, 0, 1, 0, 0, 0, 0, 0, 0]
```

我们已经准备好了，可以创建我们的模型了。

```Python
# 重置底层图数据
tf.reset_default_graph()
# 创建神经网络
net = tflearn.input_data(shape=[None, len(train_x[0])])
net = tflearn.fully_connected(net, 8)
net = tflearn.fully_connected(net, 8)
net = tflearn.fully_connected(net, len(train_y[0]), activation='softmax')
net = tflearn.regression(net)

# 定义模型并创建 tensorboard
model = tflearn.DNN(net, tensorboard_dir='tflearn_logs')
# 使用梯度下降方法训练模型
model.fit(train_x, train_y, n_epoch=1000, batch_size=8, show_metric=True)
model.save('model.tflearn')
```

这个张量的结构与我们[之前在一篇文章](https://chatbotslife.com/deep-learning-in-7-lines-of-code-7879a8ef8cfb)中使用的 2 层神经网络是相同的，训练模型的方式是不会过时的。


![](https://cdn-images-1.medium.com/max/800/1*5UIqnedBzsYTXJ81wEU-vg.gif)

使用 tflearn 交互式构建模型
为了完成这部分的工作，我们将序列化保存（pickle）模型和文档以便我们在以后的 Jupyter Notebook 中可以使用他们。

```Python
# 保存我们所有的数据结构
import pickle
pickle.dump( {'words':words, 'classes':classes, 'train_x':train_x, 'train_y':train_y}, open( "training_data", "wb" ) )
```

---


#### 创建我们的聊天机器人框架

这部分的完整 notebook 在[这里](https://github.com/ugik/notebooks/blob/master/Tensorflow%20chat-bot%20response.ipynb)可以下载。

我们创建了一个简单的状态机来处理响应，用我们的意图模型（上一步训练的结果）作为分类器。 [聊天机器人是如何工作的](https://medium.freecodecamp.com/how-chat-bots-work-dfff656a35e2)

> 上下文的聊天机器人框架是 **状态机** 内的一个分类器。

加载相同的导入模块后，我们将 **反序列化** 我们的模型和文档并且重新加载我们的意图文件。记住我们的 chat-bot 框架是和我们的模型分开来构建的—你不需要重新构建你的模型除非意图模式发生改变。因为有几百个意图和数千个模式，所以这个模型可能需要几分钟的时间来构建。

```Python
# 重置变量
import pickle
data = pickle.load( open( "training_data", "rb" ) )
words = data['words']
classes = data['classes']
train_x = data['train_x']
train_y = data['train_y']

# 导入聊天机器人的意图文件
import json
with open('intents.json') as json_data:
    intents = json.load(json_data)
```

接下来将加载我们保存在 TensorFlow (tflearn framework) 上的模型。首先我们需要和前面章节所述的一样来定义 TensorFlow 模型的结构。

```Python
# 加载保存的模型
model.load('./model.tflearn')
```

在开始处理意图之前，我们需要 **从用户的输入** 中生成词袋（bag-of-words），这和我们之前创建训练文档时使用的技术是一样的。

```Python
def clean_up_sentence(sentence):
    # 分词
    sentence_words = nltk.word_tokenize(sentence)
    # 转换句子为词干
    sentence_words = [stemmer.stem(word.lower()) for word in sentence_words]
    return sentence_words

# 返回词袋数组，每个数组的下标表示词的序号，如果句子包含该词，则该数组词为 1，否为 0
def bow(sentence, words, show_details=False):
    # pattern 分词
    sentence_words = clean_up_sentence(sentence)
    # 词袋
    bag = [0]*len(words)
    for s in sentence_words:
        for i,w in enumerate(words):
            if w == s:
                bag[i] = 1
                if show_details:
                    print ("found in bag: %s" % w)

    return(np.array(bag))
```

```
p = bow("is your shop open today?", words)
print (p)
[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0]
```

我们现在可以构建我们的响应处理器了。

```Python
ERROR_THRESHOLD = 0.25
def classify(sentence):
    # 得出预测的概率
    results = model.predict([bow(sentence, words)])[0]
    # 根据概率值过滤结果
    results = [[i,r] for i,r in enumerate(results) if r>ERROR_THRESHOLD]
    # 根据返回值长度降序排序
    results.sort(key=lambda x: x[1], reverse=True)
    return_list = []
    for r in results:
        return_list.append((classes[r[0]], r[1]))
    # 返回包含意图和概率的元组
    return return_list

def response(sentence, userID='123', show_details=False):
    results = classify(sentence)
    # results 不为空则循环找到匹配的 tag
    if results:
        # 循环找到匹配的 tag
        while results:
            for i in intents['intents']:
                # 是否匹配
                if i['tag'] == results[0][0]:
                    # 随机输出一个响应？？
                    return print(random.choice(i['responses']))
            results.pop(0)
```

句子传递到 response() 方法后会被分类。我们分类器使用 **model.predict()** 方法是响应很快的。模型返回的响应结果的概率列表是和我们的意图定义一起处理的。

如果一个或多个分类器超过一个阈值，那么我们就会看到一个标记是否匹配一个意图然后再处理它。分类器列表将会当成栈，然后不断的从栈中弹出一个元素来进行匹配是否符合，直到空栈为止。

让我们来看一个分类器的例子，我们看到最可能的标记和它所对应的概率值被返回了。

```Python
classify('is your shop open today?')
[('opentoday', 0.9264171123504639)]
```

注意到“你的商店今天营业吗”并不是这种意图的模式之一： **模式：["你今天开着吗?"，"你今天什么时候开?"，"你今天营业几小时?"]** ，然而词“开”和“今天”对我们的模式来说是很重要的（也就是说他们决定了模型会选择什么意图）。

所以我们就可以根据用户的输入生成一个 chat-bot 的回应

```Python
response('is your shop open today?')
Our hours are 9am-9pm every day
```

下面是另外一个上下文无关的响应。

```Python
response('do you take cash?')
We accept VISA, Mastercard and AMEX
response('what kind of mopeds do you rent?')
We rent Yamaha, Piaggio and Vespa mopeds
response('Goodbye, see you later')
Bye! Come back again soon.
```

---


让我们给出租汽车的聊天机器人加入一些基本的上下文吧。

#### 情景化

我们想要让聊天机器人处理关于出租汽车的对话，比如询问客户是否要今天租赁。这个问题是一个简单的上下文响应，如果用户回复“今天”，那么上下文就是租赁时间，这个时候就赶紧给租赁公司打电话吧，他不想错过这个订单的。

为了实现这一目的，我们在框架中添加了状态这个概念。这由一个保存状态的数据结构和操作状态的特定代码组成，以便处理意图。

因为状态机（state-machine）需要很容易地持久化、恢复、复制等等，所以把它保存在像字典这样的数据结构中是很重要的。

以下是我们对基本情景化的反应过程：

```Python

# 字典储存上下文
context = {}
ERROR_THRESHOLD = 0.25
def classify(sentence):
    # 得到的预测的结果（概率）列表
    results = model.predict([bow(sentence, words)])[0]
    # 根据错误阈值筛选预测的结果
    results = [[i,r] for i,r in enumerate(results) if r>ERROR_THRESHOLD]
    # 根据概率值倒序排序
    results.sort(key=lambda x: x[1], reverse=True)
    return_list = []
    for r in results:
        return_list.append((classes[r[0]], r[1]))
    # 返回意图和概率的元组
    return return_list

def response(sentence, userID='123', show_details=False):
    results = classify(sentence)
    # 根据分类结果匹配意图标签
    if results:
        # 循环匹配
        while results:
            for i in intents['intents']:
                # 寻找与第一个结果匹配的标签
                if i['tag'] == results[0][0]:
                    # 在必要时为这个意图设置上下文
                    if 'context_set' in i:
                        if show_details: print ('context:', i['context_set'])
                        context[userID] = i['context_set']
                    # 检查这个意图是否与上下文相关然后与当前用户关联
                    if not 'context_filter' in i or \
                        (userID in context and 'context_filter' in i and i['context_filter'] == context[userID]):
                        if show_details: print ('tag:', i['tag'])
                        # 返回响应
                        return print(random.choice(i['responses']))
            results.pop(0)
```

我们的上下文状态是一个字典，他将包含每个用户的状态。每个用户都有唯一的标识符，从而达到让我们的框架能够 **无缝地维持多个用户之间的状态。**

> # 使用字典来维持用户的上下文
> context = {}

上下文处理程序被添加到意图处理流中，如下所示:

```Python
	if i['tag'] == results[0][0]:
	# 在必要时为这个意图设置上下文
	if 'context_set' in i:
		if show_details: print ('context:', i['context_set'])
		context[userID] = i['context_set']
		# 检查这个意图是否与上下文相关然后与当前用户关联
		if not 'context_filter' in i or \
			(userID in context and 'context_filter' in i and i['context_filter'] == context[userID]):
			if show_details: print ('tag:', i['tag'])
			# 返回响应
			return print(random.choice(i['responses']))
```

如果一个意图想要设置上下文，他可以这样做：

```Python
{“tag”: “rental”,
 “patterns”: [“Can we rent a moped?”, “I’d like to rent a moped”, … ],
 “responses”: [“Are you looking to rent today or later this week?”],
 “context_set”: “rentalday”
 }
```

如果另外一个意图想要和上下文联系，那么他可以这样做：

```Python
{“tag”: “today”,
 “patterns”: [“today”],
 “responses”: [“For rentals today please call 1–800-MYMOPED”, …],
“context_filter”: “rentalday”
 }
```

用这种方式，当用户只是意料之外地输入“今天“的的时候（没有上下文），“今天” 这个意图就不会被处理。当他们输入的 “今天” 作为回复我们提出的问题的时候，那么这个意图就会被处理。

```Python
response('we want to rent a moped')
Are you looking to rent today or later this week?
response('today')
Same-day rentals please call 1-800-MYMOPED
```

我们的上下文状态就会改变

```
context
{'123': 'rentalday'}
```

我们定义“问候”的语句来清除上下文，就像闲聊时经常发生的那样。我们添加了一个 “查看详情” 的参数来帮助我们查看内部的运作。

```
response("Hi there!", show_details=True)
context: ''
tag: greeting
Good to see you again
```

让我们再尝试一下输入 “今天”，这里有一些需要注意的东西...

```Python
response('today')
We're open every day from 9am-9pm
classify('today')
[('today', 0.5322513580322266), ('opentoday', 0.2611265480518341)]
```

首先，我们对上下文无关的“今天”的反应是不同的。我们的分类产生了 2 个合适的意图，但是 'opentoday' 被选中， 'today' 意图虽然具备更高的可能性，但是却被限制在一个不再合适的环境中，**所以说上下文很重要**。

```Python
response("thanks, your great")
Happy to help!
```

---

在语境化发生的情况下有几件事情需要考虑。

#### 维持状态

没错，你的聊天机器人将不再是一种 **无状态的服务**。

除非你想重新构建状态，重新加载模型和文档—每次调用你的聊天机器人框架时，你都需要使其成为有状态的。

这并不是那么难，你可以运行一个有状态的聊天机器人框架的过程，也即使用远程过程调用 RPC 或者远程方法调用 RMI，在这里我推荐使用 [Pyro](http:/。pythonhosted.org/Pyro4/)。

![](https://cdn-images-1.medium.com/max/600/1*hpbuSvovqSyVY-nhBcoIaQ.jpeg)

RMI 客户端和服务器设置
用户界面（客户端）通常是无状态的，例如。HTTP 或 SMS。

你 **客户端** 的聊天机器人将会创建一个 Pyro 函数调用，你的有状态服务将会处理他。

这里有一篇一步一步指导你构建 Twilio SMS 聊天机器人客户端的[文章](https://chatbotslife.com/build-a-working-sms-chat-bot-in-10-minutes-b8278d80cc7a)，另外一篇[文章](https://chatbotnewsdaily.com/build-a-facebook-messenger-chat-bot-in-10-minutes-5f28fe0312cd)是关于构建 FB Messenger 的。

#### 不可将状态储存在局部变量中

所有的状态信息都必须放在像字典这样的数据结构中，很容易持久化、重新加载或复制。

每个用户的对话都将承载为该用户提供状态的上下文。用户的唯一标识 ID 可以是手机号，Facebook 的用户 ID 或者其他的唯一标识符

在一些场景中用户的对话状态需要被复制然后重新储存起来被意图所处理。如果你的状态机携带的一些状态的变量在框架中是共用的话，则很难在实际场景中实现这一工作。

> Python 字典是你的朋友

---

现在你已经知道如何构建一个聊天机器人的框架以及使它具备有服务状态的方法，[大部分聊天机器人框架都能够无缝地处理上下文](https://medium.com/@gk_/the-future-of-messaging-apps-590720cfa792)。

多想一些有创意的方法来影响聊天机器人对不同上下文所做出设置。你的用户的上下文字典可以包含各种各样的对话上下文。

**享受它吧！**


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
