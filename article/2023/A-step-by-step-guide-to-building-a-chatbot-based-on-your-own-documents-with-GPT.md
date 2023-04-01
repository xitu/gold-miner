> * 原文地址：[A step-by-step guide to building a chatbot based on your own documents with GPT](https://bootcamp.uxdesign.cc/a-step-by-step-guide-to-building-a-chatbot-based-on-your-own-documents-with-gpt-2d550534eea5)
> * 原文作者：[Guodong (Troy) Zhao](https://medium.com/@guodong_zhao)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/itcodes/gold-miner/blob/master/article/2023/A-step-by-step-guide-to-building-a-chatbot-based-on-your-own-documents-with-GPT.md](https://github.com/itcodes/gold-miner/blob/master/article/2023/A-step-by-step-guide-to-building-a-chatbot-based-on-your-own-documents-with-GPT.md)
> * 译者：[tong-h](https://github.com/Tong-H)
> * 校对者：[grejioh](https://github.com/grejioh) [Quincy-Ye](https://github.com/Quincy-Ye)

与 ChatGPT 聊天是有趣且丰富的，过去一段时间我一直在与它闲聊并探索新的想法。但这些都是比较随意的用例，新奇感很快就减弱，尤其是当你意识到它可以产生幻觉的时候。

我们如何以更高效的方式使用它？随着 OpenAI 最近发布的 GPT 3.5 系列 API，我们能做的事远不止是闲聊。对于企业和个人使用来说更高效的用例是 QA （问答）—— **你用自然语言向机器人询问你自己的文档/数据，它可以通过从文档中检索信息并生成回应以快速地回答你**<sup><a href="#note1">[1]</a></sup>。你可以用它来做客户支持，综合用户研究，你的个人知识管理等等。

![](https://miro.medium.com/v2/resize:fit:1400/1*gUE4sFAEIhoR07IMUhzLaA.jpeg)

向机器人询问与文档有关的问题。由 Stable Diffusion 生成的图像。

在本文中，我将探讨如何基于自己的数据创建问答机器人，包括为什么有些方法不生效，以及使用 llama-index 和 GPT API 高效地创建文档问答聊天机器人的逐步引导。

(如果你只想知道如何建立问答聊天机器人，你可以直接跳到“逐步创建文档问答聊天机器人”部分)

## 探索不同的方法

我的日常工作是担任产品经理 —— 阅读用户反馈以及内部文档占据了我生活的很大一部分。当 ChatGPT 出现的时候，我马上就想到了将它当作助手使用，来帮助我综合用户反馈，或者查找和我现在正在做的功能相关的旧产品文档。

我首先想到的是使用我自己的数据对 GPT 模型微调（fine-tuning）来实现目标。但微调的花费不少，而且需要一个有案例的大型数据集。同样，也不可能每当文档发生改变时，都去做微调。更关键的是微调根本不能让模型“知道”文档中的所有信息，而是教给模型新技能。因此，对多文档问答来说，微调并不是一个可行的方式。

我想到的第二个方法是通过在提示中提供上下文来进行提示工程。比如，我可以在真实问题之前附加原始文档内容，而不是直接提问。但是 GPT 模型的注意广度是受限的，它只能接受提示中的几千个单词（大约 4000 个 token 或者 3000 个单词）。我们有成千封用户反馈邮件和数百份产品文档，所以把所有内容放在提示中是不可能的。往 API 传递长字符串的成本也是比较高的， 因为定价是基于使用的 token 数量。

```
我将根据下面的内容向你询问：—上下文的开始—你的文档内容—上下文的结束—我的问题是：“用户希望在 app 中看到什么特性？”
```

（如果你想要学习更多关于 GPT 的微调和提示工程，你可以阅读这篇文章：[为个人业务量身定制的基础语言模型（如GPT）的3种方法](https://medium.com/design-bootcamp/3-ways-to-tailor-foundation-language-models-like-gpt-for-your-business-e68530a763bd)）

由于提示对输入 token 数量有限制，所以我想出了一个主意，首先使用算法搜索文档并选择相关的摘要，然后只将这些相关的内容以及我的问题传递给 GPT。当我研究这个想法的时候，我偶然发现一个叫 gpt-index 的库（现在更名为 LlamaIndex），这个库完全符合我的想法，而且使用简单<sup><a href="#note2">[2]</a></sup>。

![](https://miro.medium.com/v2/resize:fit:1400/1*Zi85PvOv8tpaB4SvpTRlHw.png)

从文件中提取相关部分，然后将其反馈给提示。图标来自[https://www.flaticon.com/](https://www.flaticon.com/)

在下一节中，我将给出一个使用 LlamaIndex 和 GPT 来创建基于您自己的数据的问答聊天机器人的分步教程。

## 逐步创建文档问答聊天机器人

在本节中，我们将基于现有的文档用 LlamaIndex 和 GPT (text-davinci-003) 创建一个问答聊天机器人，这样你可以就你的文档提出问题，并从聊天机器人获得答案，全部都是使用自然语言。

## 前提条件

在开始之前，我们需要准备一些东西：

- 你的 OpenAI API Key，可以在 [https://platform.openai.com/account/api-keys](https://platform.openai.com/account/api-keys) 中找到。
- 你的文档的数据库。LlamaIndex 支持多种不同的数据来源，比如 Notion、Google Docs、Asana 等等 \[3\]。在本教程中，我们只使用一个简单的 text 文件来做示范。
-  一个本地 Python 环境或者在线 [Google Colab notebook](https://colab.research.google.com/)。

## 工作流程

这个工作流程简单易懂，只需要几个步骤：

1. 使用 LlamaIndex 创建文档数据的索引。
2. 使用自然语言查询索引。
3. LlamaIndex 将检索相关部分并传递给 GPT 提示。
4. 结合相关上下文询问 GPT，并构建回复。

LlamaIndex 所做的是将原始的文档数据转化为矢量索引，这会使查询变得非常高效。LlamaIndex 将基于查询和数据的相似性来使用这个索引去找到最相关的部分。再将检索到的信息插入到提示中发送给 GPT，这样 GPT 就有了回答问题的上下文。

**设置**

我们需要先安装 LlamaIndex，只需要在终端或者 Google Colab notebook 中运行以下命令。这些命令会安装 LlamaIndex 和 OpenAI。

```
!pip install llama-index!pip install openai
```

下一步，我们将在 python 中导入这些库，然后在一个新的 .py 文件中设置你的 OpenAI API key。

```
from llama_index import GPTSimpleVectorIndex, Document, SimpleDirectoryReaderimport osos.environ['OPENAI_API_KEY'] = 'sk-YOUR-API-KEY'
```

**构建索引并保存**

在安装以及导入了所需的库之后，我们需要去构建文档的索引。

我们可以使用 LllamaIndex 提供的 SimpleDirectoryReader 方法来加载文档，或者也可以从字符串中加载。

```
documents = SimpleDirectoryReader('your_directory').load_data()text_list = [text1, text2, ...]documents = [Document(t) for t in text_list]
```

LlamaIndex 也提供多种不同的数据连接器，包括 Notion，Asana，Google Drive，Obsidian 等等。你可以在 [https://llamahub.ai/](https://llamahub.ai/) 中找到可用的数据连接器。

在文档加载后，我们可以用以下方法简单地构建索引

```
index = GPTSimpleVectorIndex(documents)
```

如果你想要保存索引以便后续加载使用，你可以使用以下方法

```
index.save_to_disk('index.json')index = GPTSimpleVectorIndex.load_from_disk('index.json')
```

**查询索引并获取响应**

查询索引是很简单的

```
response = index.query("What features do users want to see in the app?")print(response)
```

![](https://miro.medium.com/v2/resize:fit:1400/1*g0YR2LwF1oa1mfP4U0ZBcQ.png)

一个回复案例。

然后就可以了！你就能得到回答了。在后台，LlamaIndex 会接受你的提示并在索引中搜索相关的语块，然后将你的提示以及相关的语块传递给 GPT。

**一些关于高级使用的说明**

上面的步骤仅仅展示了 LlamaIndex 和 GPT 非常简单的回答问题的入门用法。但你可以做更多。事实上，你可以配置 LlamaIndex 去使用不同的大型语言模型（LLM），使用不同类型的索引去做不同的任务，用一个新的索引来更新现有的索引等等。如果你感兴趣，可以阅读他们的文档 [https://gpt-index.readthedocs.io/en/latest/index.html](https://gpt-index.readthedocs.io/en/latest/index.html)。

## 结语

在这篇文章中，我们看到了如何将 GPT 与 LlamaIndex 结合起来，来建立一个文档问答聊天机器人。虽然 GPT（和其他 LLM）本身就很强大，但如果我们把它与其他工具、数据或流程结合起来，它的能力就可以大大放大。

你会用一个文档问答聊天机器人做什么？

1. <a name="note1"></a> [What Is Question Answering? — Hugging Face. 5 Dec. 2022](https://huggingface.co/tasks/question-answering)
2. <a name="note2"></a> [Liu, Jerry. LlamaIndex. Nov. 2022. GitHub](https://github.com/jerryjliu/llama_index)
> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
