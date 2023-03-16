> * 原文地址：[A step-by-step guide to building a chatbot based on your own documents with GPT](https://bootcamp.uxdesign.cc/a-step-by-step-guide-to-building-a-chatbot-based-on-your-own-documents-with-gpt-2d550534eea5)
> * 原文作者：[Guodong (Troy) Zhao](https://medium.com/@guodong_zhao)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/itcodes/gold-miner/blob/master/article/2023/A-step-by-step-guide-to-building-a-chatbot-based-on-your-own-documents-with-GPT.md](https://github.com/itcodes/gold-miner/blob/master/article/2023/A-step-by-step-guide-to-building-a-chatbot-based-on-your-own-documents-with-GPT.md)
> * 译者：
> * 校对者：

Chatting with ChatGPT is fun and informative — I’ve been chit-chatting with it for past time and exploring some new ideas to learn. But these are more casual use cases and the novelty can quickly wean off, especially when you realize that it can generate hallucinations.

How might we use it in a more productive way? With the recent release of the GPT 3.5 series API by OpenAI, we can do much more than just chit-chatting. One very productive use case for businesses and your personal use is QA (Question Answering) — **you ask the bot in natural language about your own documents/data, and it can quickly answer you by retrieving info from the documents and generating a response** \[1\]. You can use it for customer support, synthesizing user research, your personal knowledge management, and more!

![](https://miro.medium.com/v2/resize:fit:1400/1*gUE4sFAEIhoR07IMUhzLaA.jpeg)

Ask a bot for document-related questions. Image generated with Stable Diffusion.

In this article, I will explore how to build your own Q&A chatbot based on your own data, including why some approaches won’t work, and a step-by-step guide for building a document Q&A chatbot in an efficient way with llama-index and GPT API.

(If you only want to know how to build the Q&A chatbot, you can jump directly to the section “Building document Q&A chatbot step-by-step”)

## Exploring different approaches

My day job is as a product manager — reading customer feedback and internal documents takes a big chunk of my life. When ChatGPT came out, I immediately thought of the idea of using it as an assistant to help me synthesize customer feedback or find related old product documents about the feature I’m working on.

I first thought of fine-tuning the GPT model with my own data to achieve the goal. But fine-tuning costs quite some money and requires a big dataset with examples. It’s also impossible to fine-tune every time when there is a change to the document. An even more crucial point is that fine-tuning simply CANNOT let the model “know” all the information in the documents, but rather it teaches the model a new skill. Therefore, for (multi-)document QA, fine-tuning is not the way to go.

The second approach that comes into my mind is prompt engineering by providing the context in the prompts. For example, instead of asking the question directly, I can append the original document content before the actual question. But the GPT model has a limited attention span — it can only take in a few thousand words in the prompt (about 4000 tokens or 3000 words). It’s impossible to give it all the context in the prompt, provided that we have thousands of customer feedback emails and hundreds of product documents. It’s also costly if you pass in a long context to the API because the pricing is based on the number of tokens you use.

```
I will ask you questions based on the following context:— Start of Context —YOUR DOCUMENT CONTENT— End of Context—My question is: “What features do users want to see in the app?”
```

(If you want to learn more about fine-tuning and prompt engineering for GPT, you can read the article: [https://medium.com/design-bootcamp/3-ways-to-tailor-foundation-language-models-like-gpt-for-your-business-e68530a763bd](https://medium.com/design-bootcamp/3-ways-to-tailor-foundation-language-models-like-gpt-for-your-business-e68530a763bd))

Because the prompt has limitations on the number of input tokens, I came up with the idea of first using an algorithm to search the documents and pick out the relevant excerpts and then passing only these relevant contexts to the GPT model with my questions. While I was researching this idea, I came across a library called gpt-index (now renamed to LlamaIndex), which does exactly what I wanted to do and it is straightforward to use \[2\].

![](https://miro.medium.com/v2/resize:fit:1400/1*Zi85PvOv8tpaB4SvpTRlHw.png)

Extract relevant parts from the documents and then feed them to the prompt. Icons from [https://www.flaticon.com/](https://www.flaticon.com/)

In the next section, I’ll give a step-by-step tutorial on using LlamaIndex and GPT to build a Q&A chatbot on your own data.

## Building document Q&A chatbot step-by-step

In this section, we will build a Q&A chatbot based on existing documents with LlamaIndex and GPT (text-davinci-003), so that you can ask questions about your document and get an answer from the chatbot, all in natural language.

## Prerequisites

Before we start the tutorial, we need to prepare a few things:

-   Your OpenAI API Key, which can be found at [https://platform.openai.com/account/api-keys](https://platform.openai.com/account/api-keys).
-   A database of your documents. LlamaIndex supports many different data sources like Notion, Google Docs, Asana, etc \[3\]. For this tutorial, we’ll just use a simple text file for demonstration.
-   A local Python environment or an online [Google Colab notebook](https://colab.research.google.com/).

## Workflow

The workflow is straightforward and takes only a few steps:

1.  Build an index of your document data with LlamaIndex
2.  Query the index with natural language
3.  LlamaIndex will retrieve the relevant parts and pass them to the GPT prompt
4.  Ask GPT with the relevant context and construct a response

What LlamaIndex does is convert your original document data into a vectorized index, which is very efficient to query. It will use this index to find the most relevant parts based on the similarity of the query and the data. Then, it will plug in what’s retrieved into the prompt it will send to GPT so that GPT has the context for answering your question.

**Setting Up**

We’ll need to install the libraries first. Simply run the following command in your terminal or on Google Colab notebook. These commands will install both LlamaIndex and OpenAI.

```
!pip install llama-index!pip install openai
```

Next, we'll import the libraries in python and set up your OpenAI API key in a new .py file.

```
from llama_index import GPTSimpleVectorIndex, Document, SimpleDirectoryReaderimport osos.environ['OPENAI_API_KEY'] = 'sk-YOUR-API-KEY'
```

**Constructing the index and saving it**

After we installed the required libraries and import them, we will need to construct an index of your document.

To load your document, you can use the SimpleDirectoryReader method provided by LllamaIndex or you can load it from strings.

```
documents = SimpleDirectoryReader('your_directory').load_data()text_list = [text1, text2, ...]documents = [Document(t) for t in text_list]
```

LlamaIndex also provides a variety of data connectors, including Notion, Asana, Google Drive, Obsidian, etc. You can find the available data connectors at [https://llamahub.ai/](https://llamahub.ai/).

After loading the documents, we can then construct the index simply with

```
index = GPTSimpleVectorIndex(documents)
```

If you want to save the index and load it for future use, you can use the following methods

```
index.save_to_disk('index.json')index = GPTSimpleVectorIndex.load_from_disk('index.json')
```

**Querying the index and getting a response**

Querying the index is simple

```
response = index.query("What features do users want to see in the app?")print(response)
```

![](https://miro.medium.com/v2/resize:fit:1400/1*g0YR2LwF1oa1mfP4U0ZBcQ.png)

An example response.

And voilà! You will get your answer printed. Under the hood, LlamaIndex will take your prompt, search for relevant chunks in the index, and pass your prompt and the relevant chunks to GPT.

**Some notes for advanced usage**

The steps above show only a very simple starter usage for question answering with LlamaIndex and GPT. But you can do much more than that. In fact, you can configure LlamaIndex to use a different large language model (LLM), use a different type of index for different tasks, update existing indices with a new index, etc. If you’re interested, you can read their doc at [https://gpt-index.readthedocs.io/en/latest/index.html](https://gpt-index.readthedocs.io/en/latest/index.html).

## Some final words

In this post, we’ve seen how to use GPT in combination with LlamaIndex to build a document question-answering chatbot. While GPT (and other LLM) is powerful in itself, its powers can be much amplified if we combine it with other tools, data, or processes.

What would you use a document question-answering chatbot for?



> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
