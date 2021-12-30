> - 原文地址：[How to Create a Reusable Web Scraper](https://medium.com/better-programming/how-to-create-a-reusable-web-scraper-5a5aa9af62d9)
> - 原文作者：[David Tippett](https://medium.com/@dtaivpp)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-create-a-reusable-web-scraper.md](https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-create-a-reusable-web-scraper.md)
> - 译者：[YueYongDEV](https://github.com/YueYongDev)
> - 校对者：[acev](https://github.com/acev-online)、[shixi-li](https://github.com/shixi-li)

# 如何创建一个可复用的网页爬虫

![照片来自 [Raconteur](https://www.raconteur.net/sponsored/reduce-reuse-recycle-smart-packaging-to-protect-what-matters).](https://cdn-images-1.medium.com/max/5200/0*b-aN9YmOsw47b5D_.jpg)

网页爬虫是个非常有趣的玩具。不过不好玩的是，我们需要根据不同网页上的元素不断的调整自己的代码。这就是为什么我要着手实现一个更好的网页爬虫项目——通过该项目可以以最少的更改实现对新网页的爬取。

第一步是将网页爬虫按照逻辑分成每个独立的部分：

1. 页面请求器
2. 页面验证器
3. 模板页面处理器

## 页面请求器

![照片来自 [Toy Bros](https://toybros.com/should-guests-be-able-to-request-music-at-your-wedding/).](https://cdn-images-1.medium.com/max/2000/0*gUnzcgKznbinsJoa.jpg)

页面请求器的实现有一些技巧。下载网页时要考虑很多因素。你需要确保你可以随机的使用用户代理，并且不要过于频繁地从同一域中请求。

此外，停下手头的工作去分析为什么网页无法下载是一件出力不讨好的事。尤其是当你的爬虫已经在多个站点运行了好几个小时的情况下。因此，我们会处理一些请求，并将它们另存为文件。

将请求保存到文件中还有另一个好处。你不必担心一个标签的消失会影响你的爬虫。如果页面处理器是独立的，并且你已经完成了页面的下载，你还可以根据需要快速且频繁的对其进行处理。如果发现有另一个要抓取的数据元素怎么办？别担心。只需添加一个标签，然后在你已下载的页面上重新运行处理器即可。

以下是一些实际情况下的示例代码：

```Python
import requests
import pickle
from random import randint
from urllib.parse import urlparse
def _random_ua():
    ua_list = ["user agent1, user agent2", "user agent3"]
    random_num = randint(0, len(ua_list))
    return ua_list[random_num]
def _headers():
    return { 'user-agent': _random_ua() }
def _save_page(response):
    uri = urlparse(response.url)
    filename = uri.netloc + ".pickle"
    with open(filename, 'wb+') as pickle_file:
        pickle.dump(response, pickle_file)
def download_page(url):
    response = requests.get(url)
    _save_page(request)
```

## 页面验证器

![照片来自 [Medium](https://medium.com/artisans-of-tech/handling-validating-user-input-more-with-sauciness-in-android-with-java-d1bbf10d767).](https://cdn-images-1.medium.com/max/5200/0*7BSzrpW_zUlqkGMq.jpeg)

页面验证器浏览文件并释放请求。它将读取请求的状态码，如果请求代码类似于 408（超时），您可以让它重新排队下载网页。否则，验证器可以将文件移动到实际的 web 抓取模块中进行处理。

你还可以收集为什么页面没有下载的数据。也许你请求页面的速度太快而被禁止了。此数据可用于调整你的页面下载器，以便它可以运行尽可能快且错误量最小。

## 模板页面处理器

这是你一直在等待的东西。第一步是创建我们的数据模型。我们从 URL 开始。对于每个不同的站点/路径，可能都有不同的提取数据的方法。我们从一个字典开始，就像这样：

```python
models = {
  'finance.yahoo.com':{},
  'news.yahoo.com'{},
  'bloomberg.com':{}
}
```

在我们的用例中，我们想要提取这些网站的 article 内容。要做到这一点，我们将创建一个包含所有数据的最小外部元素的选择器。举个例子，下面是 finance.yahoo.com 的示例页面:

```html
Webpage Sample
<div>
  <a>some link</a>
  <p>some content</p>
  <article class="canvas-body">
    <h1>Heading</h1>
    <p>article paragraph 1</p>
    <p class="ad">Ad Link</p>
    <p>article paragraph 2</p>
    <li>list element</li>
    <li>
      <a>unrelated link</a>
    </li>
  </article>
</div>
```

在上面的代码段中，我们希望定位 article 元素。因此，我们将使用 article 标签和 class 作为标识符，因为这是包含 article 内容的最小元素。

```python
models = {
  'finance.yahoo.com':{
    'root-element':[
            'article',
            {'class': "canvas-body"}
     ]
  },
  'news.yahoo.com'{},
  'bloomberg.com':{}
}
```

接下来，我们将确定本文中的哪些元素是无用的。我们可以看到一个有 `ad` 类（值得注意的是，在真实场景中它永远不会这么简单）。因此，为了指定我们想要删除的元素，我们将在配置模型中创建一个 `unwanted_elements` 元素：

```python
models = {
  'finance.yahoo.com':{
       'root-element':[
            'article',
            {'class': "canvas-body"}
        ],
        'unwanted_elements': [
            'p',
            {'class': "ad"}
        ]
  },
  'news.yahoo.com'{},
  'bloomberg.com':{}
}
```

现在我们已经清除了一些无用元素，我们要注意哪些元素需要保留。因为我们只寻找 article 元素，所以我们只需要指定保留 `p` 和 `h1` 元素即可:

```python
models = {
  'finance.yahoo.com':{
       'root-element':[
            'article',
            {'class': "canvas-body"}
        ],
        'unwanted_elements': [
            'p',
            {'class': "ad"}
        ]
        'text_elements': [
            ['p'],
            ['li']
        ]  },
  'news.yahoo.com'{},
  'bloomberg.com':{}
}
```

现在是最后一部分——主聚合器！这里我将不关注配置文件的解析和加载。如果我把所有代码都放上来，一篇文章不足以全部介绍完。

```Python
# 获取外部元素
def outer_element(page, identifier):
    root = page.find(*identifier)
        if root == None:
        raise Exception("Could not find root element")
     return root


# 移除不需要的元素
def trim_unwanted(page, identifier_list):
    # 判断 list 中是否有该元素
    if len(identifier_list) != 0:
        for identifier in identifier_list:
            for element in page.find_all(*identifier):
                element.decompose()
    return page


# 提取文字
def get_text(page, identifier_list):
    # 判断 list 中是否有该元素
    if len(identifier_list) == 0:
        raise Exception("Need text elements")
    page_text = []

    for identifier in identifier_list:
        for element in page.find_all(*identifier):
            page_text.append(element.text)
        return page_text


# 获取页面配置
def load_scrape_config():
    '''加载页面爬取配置数据'''
    return get_scrape_config()


# 获取站点的抓取配置
def get_site_config(url):
    '''获取站点的抓取配置'''
    domain = extract_domain(url)
    config_data = load_scrape_config()
    config = config_data.get(domain, None)
    if config == None:
        raise Exception(f"Config does not exist for: {domain}")
    return config


# 构建返回字段
def page_processer(request):
    '''返回文本'''
    # 获取站点的抓取配置
    site_config = get_site_config(request.url)

    # 解析页面
    soup = BeautifulSoup(request.text, 'lxml')

    # 获取根元素
    root = outer_element(soup, site_config["root_element"])
    # 移除不需要的元素
    trimmed_tree = trim_unwanted(root, site_config["unwanted"])
    # 获得所需的元素
    text = get_text(trimmed_tree, site_config["text_elements"])
    return " ".join(text)
```

## 总结

使用此代码，你可以创建一个模板，从任何网站提取文章文本。你可以在我的 [GitHub](https://github.com/dtaivpp/NewsTicker/blob/master/src/scrape_page.py) 上看到完整的代码并查看我是如何实现它的。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
