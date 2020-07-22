> * 原文地址：[How to Create a Reusable Web Scraper](https://medium.com/better-programming/how-to-create-a-reusable-web-scraper-5a5aa9af62d9)
> * 原文作者：[David Tippett](https://medium.com/@dtaivpp)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-create-a-reusable-web-scraper.md](https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-create-a-reusable-web-scraper.md)
> * 译者：
> * 校对者：

# How to Create a Reusable Web Scraper

![Photo from [Raconteur](https://www.raconteur.net/sponsored/reduce-reuse-recycle-smart-packaging-to-protect-what-matters).](https://cdn-images-1.medium.com/max/5200/0*b-aN9YmOsw47b5D_.jpg)

Web scrapers are a ton of fun. What isn’t so fun is constantly modifying code as elements change on the web pages. That is why I set out to create a better web scraping project — one that could be updated to scrape new websites with minimal edits.

The first step was separating each part of the web scraper into separate logical pieces:

1. Page requester
2. Page validator
3. Templated page processor

## Page Requester

![Photo from [Toy Bros](https://toybros.com/should-guests-be-able-to-request-music-at-your-wedding/).](https://cdn-images-1.medium.com/max/2000/0*gUnzcgKznbinsJoa.jpg)

The page requester has a few tricks up its sleeve. There is a lot to consider when downloading sites. You want to make sure you are randomizing your user agent and not requesting too frequently from the same domain.

Also, the cost of stopping to analyze why a page did not download can be really expensive — especially if you have a scraper that runs for several hours at a time for several sites. For that reason, we will pickle the requests and save them off as a file.

Saving requests into a file has another big benefit. You don’t have to worry about a missing tag blowing up your web scraper. If your processor is separate and you already have the pages downloaded, you can process them as quickly and frequently as you want. What if you discover there is another data element you want to scrape? No worries. Just add the tag and rerun your processor on your already downloaded page.

Below is some sample code for what this looks like in practice:

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

## Page Validator

![Photo from [Medium](https://medium.com/artisans-of-tech/handling-validating-user-input-more-with-sauciness-in-android-with-java-d1bbf10d767).](https://cdn-images-1.medium.com/max/5200/0*7BSzrpW_zUlqkGMq.jpeg)

The page validator goes through the files and unpickles the requests. It will read off the status code of the request, and if the request code is something along the lines of a 408 (timeout), you can have it re-queue the site for downloading. Otherwise, the validator can move the file to be processed by the actual web scraping module.

You could also collect data on why a page didn’t download. Maybe you requested pages too quickly and were banned. This data can be used to tune your page downloader so that it can run as fast as possible with the minimum amount of errors.

## Templated Page Processor

Here is the magic sauce you have been waiting for. The first step is creating our data model. We start with our URL. For each different site/path, there is likely a different method for extracting data. We start with a dict then, like so:

```python
models = {
  'finance.yahoo.com':{},
  'news.yahoo.com'{},
  'bloomberg.com':{}
}
```

In our use case, we want to extract the article content for these sites. To do this, we will create a selector for the smallest outer element that still contains all our data. For example, here is what the following might look like with a sample page for finance.yahoo.com:

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
        <li>list element<li>
        <a>unrelated link</a>
    </article>
</div>
```

In the snippet above, we want to target the article. So we will use both the article tag and the class as an identifier since that is the smallest containing element with the article content in it.

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

Next, we will want to identify what elements within our article are garbage. We can see one has the `ad` class (keep in mind it will never be this simple in real life). So to specify that we want to remove it, we will create an `unwanted_elements` element in our config model:

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

Now that we have weeded out some of the garbage, we need to note what elements we want to keep. Since we are only looking for article elements, we just need to specify we want to keep the `p` and `h1` elements:

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

Now for the final piece — the master aggregator! I am going to disregard the unpickling and loading of the config file. If I wrote the whole code, this article would never end:

```Python
# Get outer element
def outer_element(page, identifier):
    root = page.find(*identifier)
        if root == None:
        raise Exception("Could not find root element")
     return root


# Remove unwanted elements
def trim_unwanted(page, identifier_list):
    # Check if list has elements
    if len(identifier_list) != 0:
        for identifier in identifier_list:
            for element in page.find_all(*identifier):
                element.decompose()
    return page


# Extract text
def get_text(page, identifier_list):
    # Check if list has elements
    if len(identifier_list) == 0:
        raise Exception("Need text elements")
    page_text = []
    
    for identifier in identifier_list:
        for element in page.find_all(*identifier):
            page_text.append(element.text)
        return page_text


# Get page config
def load_scrape_config():
    '''Loads page scraping config data'''
    return get_scrape_config()  


# Get the scraping config for the site
def get_site_config(url):
    '''Get the scrape config for the site'''
    domain = extract_domain(url)
    config_data = load_scrape_config()
    config = config_data.get(domain, None)
    if config == None:
        raise Exception(f"Config does not exist for: {domain}")
    return config 


# Build Soup
def page_processer(request):
    '''Returns Article Text'''
    # Get the page scrape config
    site_config = get_site_config(request.url)     
    
    # Soupify page
    soup = BeautifulSoup(request.text, 'lxml')
    
    # Retrieve root element    
    root = outer_element(soup, site_config["root_element"])     
    # Remove unwanted elements
    trimmed_tree = trim_unwanted(root, site_config["unwanted"])
    # Get the desired elements
    text = get_text(trimmed_tree, site_config["text_elements"])            
    return " ".join(text)
```

## Conclusion

With this code, you can create a template for extracting the article text from any website. You can see the full code and how I have started implementing this on my [GitHub](https://github.com/dtaivpp/NewsTicker/blob/master/src/scrape_page.py).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
