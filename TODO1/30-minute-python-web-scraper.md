> * 原文地址：[30-minute Python Web Scraper](https://hackernoon.com/30-minute-python-web-scraper-39d6d038e5da)
> * 原文作者：[Angelos Chalaris](https://hackernoon.com/@chalarangelo?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/30-minute-python-web-scraper.md](https://github.com/xitu/gold-miner/blob/master/TODO1/30-minute-python-web-scraper.md)
> * 译者：[kezhenxu94](https://github.com/kezhenxu94/)
> * 校对者：

# 30 分钟 Python 爬虫教程

一直想用 Python 和 [Selenium](http://www.seleniumhq.org/) 写一个网页爬虫，但一直都没去实现。直到几天前我才决定动手实现它。写代码从 [Unsplash](https://unsplash.com/) 网站上抓取一些漂亮的图片，这看起来好像是非常艰巨的事情，但实际上却是极其简单。

![](https://cdn-images-1.medium.com/max/2000/1*9wHrewC1Dyf2Au_qEqwWcg.jpeg)

图片来源: [Blake Connally](https://unsplash.com/@blakeconnally) 发布于 [Unsplash.com](https://unsplash.com/photos/B3l0g6HLxr8)

#### 简单图片爬虫的原料

*   [Python](https://www.python.org/downloads/) (3.6.3 或以上)
*   [Pycharm](https://www.jetbrains.com/pycharm/download/#section=windows) (社区版就已经足够了)
*   pip install [requests](http://docs.python-requests.org/en/master/user/install/#install) [Pillow](https://pillow.readthedocs.io/en/latest/installation.html#basic-installation) [selenium](http://selenium-python.readthedocs.io/installation.html#downloading-python-bindings-for-selenium)
*   [geckodriver](https://github.com/mozilla/geckodriver/releases/latest) (具体见下文)
*   [Mozlla Firefox](https://www.mozilla.org/en-US/firefox/new/) (如果你没有安装过的话)
*   正常的网络连接（显然需要的）
*   你宝贵的 30 分钟（也许更少）

#### 简单图片爬虫的菜谱

以上的所有都安装好了？棒！在我们继续开始写代码前，我先来解释一下以上这些原料都是用来干什么的。

我们首先要做的是利用 **Selenium webdriver** 和 **geckodriver** 来为我们打开一个浏览器窗口。首先，在 **Pycharm** 中新建一个项目，根据你的操作系统下载最新版的 geckodriver，将其解压并把 geckodriver 文件拖到项目文件夹中。Geckodriver 本质上就是一个能让 Selenium 控制 Firefox 的工具，因此我们的项目需要它来让浏览器帮我们做一些事。

接下来我们要做的事就是从 Selenium 中导入 webdriver 到我们的代码中，然后连接到我们想爬取的 URL 地址。说做就做：

```python
from selenium import webdriver
# 我们想要浏览的 URL 链接
url = "https://unsplash.com"
# 使用 Selenium 的 webdriver 来打开这个页面
driver = webdriver.Firefox(executable_path=r'geckodriver.exe')
driver.get(url)
```

打开浏览器窗口到指定的 URL。

![](https://cdn-images-1.medium.com/max/800/1*SXfVW1B1UiQakb200l9EmA.png)

一个远程控制的 Firefox 窗口。

相当容易对吧？如果以上所说你都正确完成了，你已经攻克了最难的那部分了，此时你应该看到一个类似于以上图片所示的浏览器窗口。

接下来我们就应该**向下滚动**以便更多的图片可以加载出来，然后我们才能够将它们下载下来。我们还想再**等几秒钟**，以便万一网络连接太慢了导致图片没有完全加载出来。由于 Unsplash 网站是使用 React 构建的，等个 5 秒钟似乎已经足够”慷慨”了，那就使用 Python 的 `time` 包等个 5 秒吧，我们还要使用一些 Javascript 代码来滚动网页——我们将会用到 `[window.scrollTo()](https://developer.mozilla.org/en-US/docs/Web/API/Window/scrollTo)` 函数来实现这个功能。将以上所说的合并起来，最终你的代码应该像这样：

```python
import time
from selenium import webdriver

url = "https://unsplash.com"

driver = webdriver.Firefox(executable_path=r'geckodriver.exe')
driver.get(url)
# 向下滚动页面并且等待 5 秒钟
driver.execute_script("window.scrollTo(0,1000);")
time.sleep(5)
```

滚动页面并等待 5 秒钟。

测试完以上代码后，你应该会看到浏览器的页面稍微往下滚动了一些。下一步我们要做的就是找到我们要下载的那些图片。在探索了一番 React 生成的代码之后，我发现了我们可以使用一个 **CSS 选择器**来定位到网页上画廊的图片。网页上的布局和代码在以后可能会发生改变，但目前我们可以使用 `#gridMulti img` 选择器来获得屏幕上可见的所有 `<img>` 元素。

我们可以通过 `[find_elements_by_css_selector()](http://selenium-python.readthedocs.io/api.html#selenium.webdriver.remote.webdriver.WebDriver.find_element_by_css_selector)` 得到这些元素的一个列表，但我们想要的是这些元素的 `src` 属性。我们可以遍历这个列表并一一抽取出 `src` 来：

```python
import time
from selenium import webdriver

url = "https://unsplash.com"

driver = webdriver.Firefox(executable_path=r'geckodriver.exe')
driver.get(url)

driver.execute_script("window.scrollTo(0,1000);")
time.sleep(5)
# 选择图片元素并打印出他们的 URL
image_elements = driver.find_elements_by_css_selector("#gridMulti img")
for image_element in image_elements:
    image_url = image_element.get_attribute("src")
    print(image_url)
```

选择图片元素并获得图片 URL。

现在为了真正获得我们找到的图片，我们会使用 `requests` 库和 `PIL` 的部分功能，也就是 `Image`。我们还会用到 `io` 库里面的 `BytesIO` 来将图片写到文件夹 `./images/` 中（在项目文件夹中创建）。现在把这些都一起做了，我们要先往每张图片的 URL 链接发送一个 **HTTP GET 请求**，然后使用 `Image` 和 `BytesIO` 来将返回的图片**存储**起来。以下是实现这个功能的其中一种方式：

```python
import requests
import time
from selenium import webdriver
from PIL import Image
from io import BytesIO

url = "https://unsplash.com"

driver = webdriver.Firefox(executable_path=r'geckodriver.exe')
driver.get(url)

driver.execute_script("window.scrollTo(0,1000);")
time.sleep(5)
image_elements = driver.find_elements_by_css_selector("#gridMulti img")
i = 0

for image_element in image_elements:
    image_url = image_element.get_attribute("src")
    # Send an HTTP GET request, get and save the image from the response
    image_object = requests.get(image_url)
    image = Image.open(BytesIO(image_object.content))
    image.save("./images/image" + str(i) + "." + image.format, image.format)
    i += 1
```

下载图片。

这就是爬取一堆图片所需要做的所有了。很显然的是，除非你想随便找些图片素材来做个设计原型，否则这个小小的爬虫用处可能不是很大。所以我花了点时间来优化它，加了些功能：

*   允许用户通过指定一个命令行参数来指定**搜索查询**，还有一个数值参数指定向下滚动次数，这使得页面可以显示更多的图片可供我们下载。
*   可以自定义的 CSS 选择器。
*   基于搜索查询关键字的自定义**结果文件夹**。
*   通过截断图片的预览图链接来获得全**高清图片**。
*   基于图片的 URL 给图片文件命名。
*   爬取最终结束后关闭浏览器。

你可以（你也应该）尝试自己实现这些功能。全功能版本的爬虫可以在[这里](https://github.com/Chalarangelo/unscrape)下载。记得要先按照文章开头所说的，下载 [geckodriver](https://github.com/mozilla/geckodriver/releases/latest) 然后连接到你的项目中。

* * *

#### 不足之处，注意事项和未来优化项

整个项目是一个简单的“验证概念”，以弄清楚网页爬虫是如何做的，这也就意味着有很多东西可以做，来优化这个小工具：

*   没有致谢图片最开始的上传者是个很不好的做法。Selenium 肯定是有能力处理这种情况的，那么每个图片都带有作者的名字。
*   Geckodriver 不应该被放在项目文件夹中，而是安装在全局环境下，并被放到 `PATH` 系统变量中。
*   搜索功能可以轻易地扩展到多个查询关键字，那么下载很多类型图片地过程就可以被简化了。
*   默认浏览器可以用 Chrome 替代 Firefox，甚至可以用 [PhantomJS](http://phantomjs.org/) 替代，这对这种类型的项目来说是更好的。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
