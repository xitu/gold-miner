> * 原文地址：[Build an Article Recommendation Engine With AI/ML](https://betterprogramming.pub/build-an-article-recommendation-engine-with-ai-ml-c6e931e34d3b)
> * 原文作者：[Tyler Hawkins](https://medium.com/@thawkin3)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/build-an-article-recommendation-engine-with-ai-ml.md](https://github.com/xitu/gold-miner/blob/master/article/2021/build-an-article-recommendation-engine-with-ai-ml.md)
> * 译者：[jaredliw](https://github.com/jaredliw)
> * 校对者：

# 使用人工智能/机器学习构建文章推荐引擎

![Photo by [Markus Winkler](https://unsplash.com/@markuswinkler?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/7998/0*-gsFtRSjNAsy-v6K)

内容平台因向用户推荐相关内容而蓬勃发展。平台可以提供的相关项目越多，用户在网站上停留的时间就越长，从而转化为公司的广告收入。 

如果你曾经访问过新闻网站、电子出版社或博客平台，那么你可能已经接触过推荐引擎。每一个平台都根据你的阅读历史记录，推荐你可能喜欢的内容。

作为一个简单的解决方案，一个平台可能会实现一个基于标签的推荐引擎 —— 你阅读了一篇「商业」文章，所以这里还有五篇标记为「商业」的文章。然而，构建推荐引擎的更好方法是使用**相似性搜索和机器学习算法**。

在本文中，我们将构建一个 Python Flask 应用程序，该应用程序使用 [Pinecone](https://www.pinecone.io/)（一种相似性搜索服务）来创建我们自己的文章推荐引擎。

## 演示应用程序概览

下面简短的动画演示了我们的应用程序如何工作。最初有十篇文章显示在页面上。用户可以选择任意组合这十篇文章来代表他们的阅读历史。当用户点击提交按钮时，阅读历史作为输入查询文章数据库，然后再向用户显示十篇相关文章。

![演示应用 —— 文章推荐引擎](https://cdn-images-1.medium.com/max/2000/0*jWMKM_QD7TRXYOJK)

可以看到，返回的相关文章异常准确！在此示例中，有 1,024 种可能的阅读历史组合可用作输入，并且每种组合都会产生有意义的结果。

那么我们是如何做到的呢？

在构建应用程序时，我们首先从 Kaggle 找到了一个[新闻文章数据集](https://www.kaggle.com/snapcrack/all-the-news)。该数据集包含来自 15 个主要出版社的 143,000 篇新闻文章，但我们仅使用前 20,000 篇。（完整数据集包含超过 200 万篇文章！）

之后，我们通过重命名几个列并删除不必要的列来清理数据集。接下来，我们通过嵌入模型运行文章以创建[向量嵌入](https://www.pinecone.io/learn/vector-embeddings/) —— 这是机器学习算法确定各种输入之间相似性的元数据。我们使用了[平均词嵌入模型](https://nlp.stanford.edu/projects/glove/)。然后，我们将这些向量嵌入插入到由 Pinecone 管理的[向量索引](https://www.pinecone.io/learn/vector-database/)中。

将向量嵌入添加到索引后，我们就可以开始查找相关内容了。当用户提交他们的阅读历史时，一个请求发送到 API 端点，该端点使用 Pinecone 的 SDK 来查询向量嵌入的索引。端点返回十篇类似的新闻文章并将它们显示在应用程序的 UI 中。 就是这样！够简单了吧？

如果你想亲自尝试一下，你可以[在 GitHub 上找到此应用程序的源码](https://github.com/thawkin3/article-recommendation-service)。在 `README` 中包含了如何在本地设备上运行应用程序的指示和说明。

## Demo App Code Walkthrough

We’ve gone through the inner workings of the app, but how did we actually build it? As noted earlier, this is a Python Flask app that utilizes the Pinecone SDK. The HTML uses a template file, and the rest of the frontend is built using static CSS and JS assets. To keep things simple, all of the backend code is found in the `app.py` file, which we’ve reproduced in full below:

```Python
from dotenv import load_dotenv
from flask import Flask
from flask import render_template
from flask import request
from flask import url_for
import json
import os
import pandas as pd
import pinecone
import re
import requests
from sentence_transformers import SentenceTransformer
from statistics import mean
import swifter

app = Flask(__name__)

PINECONE_INDEX_NAME = "article-recommendation-service"
DATA_FILE = "articles.csv"
NROWS = 20000

def initialize_pinecone():
    load_dotenv()
    PINECONE_API_KEY = os.environ["PINECONE_API_KEY"]
    pinecone.init(api_key=PINECONE_API_KEY)

def delete_existing_pinecone_index():
    if PINECONE_INDEX_NAME in pinecone.list_indexes():
        pinecone.delete_index(PINECONE_INDEX_NAME)

def create_pinecone_index():
    pinecone.create_index(name=PINECONE_INDEX_NAME, metric="cosine", shards=1)
    pinecone_index = pinecone.Index(name=PINECONE_INDEX_NAME)

    return pinecone_index

def create_model():
    model = SentenceTransformer('average_word_embeddings_komninos')

    return model

def prepare_data(data):
    # rename id column and remove unnecessary columns
    data.rename(columns={"Unnamed: 0": "article_id"}, inplace = True)
    data.drop(columns=['date'], inplace = True)

    # extract only first few sentences of each article for quicker vector calculations
    data['content'] = data['content'].fillna('')
    data['content'] = data.content.swifter.apply(lambda x: ' '.join(re.split(r'(?<=[.:;])\s', x)[:4]))
    data['title_and_content'] = data['title'] + ' ' + data['content']

    # create a vector embedding based on title and article columns
    encoded_articles = model.encode(data['title_and_content'], show_progress_bar=True)
    data['article_vector'] = pd.Series(encoded_articles.tolist())

    return data

def upload_items(data):
    items_to_upload = [(row.id, row.article_vector) for i, row in data.iterrows()]
    pinecone_index.upsert(items=items_to_upload)

def process_file(filename):
    data = pd.read_csv(filename, nrows=NROWS)
    data = prepare_data(data)
    upload_items(data)
    pinecone_index.info()

    return data

def map_titles(data):
    return dict(zip(uploaded_data.id, uploaded_data.title))

def map_publications(data):
    return dict(zip(uploaded_data.id, uploaded_data.publication))

def query_pinecone(reading_history_ids):
    reading_history_ids_list = list(map(int, reading_history_ids.split(',')))
    reading_history_articles = uploaded_data.loc[uploaded_data['id'].isin(reading_history_ids_list)]

    article_vectors = reading_history_articles['article_vector']
    reading_history_vector = [*map(mean, zip(*article_vectors))]

    query_results = pinecone_index.query(queries=[reading_history_vector], top_k=10)
    res = query_results[0]

    results_list = []

    for idx, _id in enumerate(res.ids):
        results_list.append({
            "id": _id,
            "title": titles_mapped[int(_id)],
            "publication": publications_mapped[int(_id)],
            "score": res.scores[idx],
        })

    return json.dumps(results_list)

initialize_pinecone()
delete_existing_pinecone_index()
pinecone_index = create_pinecone_index()
model = create_model()
uploaded_data = process_file(filename=DATA_FILE)
titles_mapped = map_titles(uploaded_data)
publications_mapped = map_publications(uploaded_data)

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/api/search", methods=["POST", "GET"])
def search():
    if request.method == "POST":
        return query_pinecone(request.form.history)
    if request.method == "GET":
        return query_pinecone(request.args.get("history", ""))
    return "Only GET and POST methods are allowed for this endpoint"
```

Let’s go over the important parts of the `app.py` file so that we understand it.

On lines 1–14, we import our app’s dependencies. Our app relies on the following:

* `dotenv` for reading environment variables from the `.env` file
* `flask` for the web application setup
* `json` for working with JSON
* `os` also for getting environment variables
* `pandas` for working with the dataset
* `pinecone` for working with the Pinecone SDK
* `re` for working with regular expressions (RegEx)
* `requests` for making API requests to download our dataset
* `statistics` for some handy stats methods
* `sentence_transformers` for our embedding model
* `swifter` for working with the pandas dataframe

On line 16, we provide some boilerplate code to tell Flask the name of our app.

On lines 18–20, we define some constants that will be used in the app. These include the name of our Pinecone index, the file name of the dataset, and the number of rows to read from the CSV file.

On lines 22–25, our `initialize_pinecone` method gets our API key from the `.env` file and uses it to initialize Pinecone.

On lines 27–29, our delete_existing_pinecone_index method searches our Pinecone instance for indexes with the same name as the one we’re using (“article-recommendation-service”). If an existing index is found, we delete it.

On lines 31–35, our `create_pinecone_index` method creates a new index using the name we chose (“article-recommendation-service”), the “cosine” proximity metric, and only one shard.

On lines 37–40, our `create_model` method uses the `sentence_transformers` library to work with the Average Word Embeddings Model. We’ll encode our vector embeddings using this model later.

On lines 62–68, our `process_file` method reads the CSV file and then calls the `prepare_data` and `upload_items` methods on it. Those two methods are described next.

On lines 42–56, our `prepare_data` method adjusts the dataset by renaming the first “id” column and dropping the “date” column. It then grabs the first four lines of each article and combines them with the article title to create a new field that serves as the data to encode. We could create vector embeddings based on the entire body of the article, but four lines will suffice in order to speed up the encoding process.

On lines 58–60, our `upload_items` method creates a vector embedding for each article by encoding it using our model. The vector embeddings are then inserted into the Pinecone index.

On lines 70–74, our `map_titles` and `map_publications` methods create some dictionaries of the titles and publication names to make it easier to find articles by their IDs later.

Each of the methods we’ve described so far is called on lines 98–104 when the backend app is started. This work prepares us for the final step of actually querying the Pinecone index based on user input.

On lines 106–116, we define two routes for our app: one for the home page and one for the API endpoint. The home page serves up the `index.html` template file along with the JS and CSS assets, and the API endpoint provides the search functionality for querying the Pinecone index.

Finally, on lines 76–96, our `query_pinecone` method takes the user’s reading history input, converts it into a vector embedding, and then queries the Pinecone index to find similar articles. This method is called when the `/api/search` endpoint is hit, which occurs any time the user submits a new search query.

For the visual learners out there, here’s a diagram outlining how the app works:

![App architecture and user experience](https://cdn-images-1.medium.com/max/2000/0*9S_7iYqcW3eTghUP)

## 示例场景

那么，将所有的这些综合到一起，用户体验如何？我们来看看三个场景：分别对体育、技术和政治感兴趣的三群用户。

体育用户选择前两篇关于塞雷娜·威廉姆斯（Serena Williams）和安迪·穆雷（Andy Murray）这两位著名网球运动员的文章作为他们的阅读历史。在他们提交选择后，该应用程序会返回有关温布尔登网球锦标赛、美国公开赛、罗杰·费德勒（Roger Federer）和拉斐尔·纳达尔（Rafael Nadal）的文章。准确！

对技术感兴趣的用户选择了有关三星和苹果的文章。在他们提交选择后，该应用会回复有关三星、苹果、谷歌、英特尔和 iPhone 的文章。又是个很好的推荐！

对政治感兴趣的用户选择一篇关于选举舞弊的文章。在他们提交他们的选择后，该应用程序会返回有关选民 ID、美国 2020 年大选、选民投票率和非法选举声言（以及他们为什么不阻止）的文章。

三对三！事实证明，我们的推荐引擎非常有用。

## 结论

我们现在已经创建了一个简单的 Python 应用程序来解决现实生活中的问题。如果内容网站能够向用户推荐相关内容，用户就会更喜欢这些内容，并会在网站上花费更多时间，从而为公司带来更多收入。双赢局面！

相似性搜索有助于为你的用户提供更好的建议。而 Pinecone，作为一个相似性搜索的服务方，可使你能轻松地向用户提供推荐，以便您可以专注于自己最擅长的事情 —— 构建一个充满值得阅读的内容、引人入胜的平台。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
