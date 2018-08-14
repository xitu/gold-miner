> * 原文地址：[How to scrape websites with Python and BeautifulSoup](https://medium.freecodecamp.org/how-to-scrape-websites-with-python-and-beautifulsoup-5946935d93fe)
> * 原文作者：[Justin Yek](https://medium.freecodecamp.org/@jyek?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-scrape-websites-with-python-and-beautifulsoup.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-scrape-websites-with-python-and-beautifulsoup.md)
> * 译者：[geniusq1981](https://github.com/geniusq1981)
> * 校对者：[Park-ma](https://github.com/Park-ma)、[coolseaman](https://github.com/coolseaman)

# 如何使用 Python 和 BeautifulSoup 爬取网站内容

![](https://cdn-images-1.medium.com/max/1600/1*BrUAg3-OqIHkoTz_CRIzTA.png)

互联网上的信息量比任何一个人究其一生所能掌握的信息量都要大的多。所以我们要做的不是在互联网上逐个访问信息，而是需要有一种灵活的方式来收集，整理和分析这些信息。

我们需要爬取网页数据。

网页爬虫可以自动提取出数据并将数据以一种你可以容易理解的形式呈现出来。在本教程中，我们将重点关注爬虫技术在金融市场中的应用，但实际上网络内容爬取可用于多个领域。

如果你是一个狂热的投资者，每天获知收盘价可能会是一件很痛苦的事，特别是当你需要的信息分散在多个网页的时候。我们将通过构建一个网络爬虫来自动从网上检索股票指数，从而简化数据的爬取。

![](https://cdn-images-1.medium.com/max/1600/1*gsn6N_tUoMb8XOWBpqQrNw.jpeg)

### 入门

我们将使用 Python 作为我们的爬虫语言，还会用到一个简单但很强大的库，BeautifulSoup。

* 对于 Mac 用户，OS X 已经预装了 Python。打开终端并输入 `python --version`。你的 Python 的版本应该是 2.7.x。
* 对于 Windows 用户，请通过 [官方网站](https://www.python.org/downloads/) 安装 Python。

接下来，我们需要使用 Python 的包管理工具 `pip` 来安装 BeautifulSoup 库。

在终端中输入：

```Python
easy_install pip  
pip install BeautifulSoup4
```

**注意**：如果你执行上面的命令发生了错误，请尝试在每个命令前面添加 `sudo`。

### 基础知识

在我们真正开始编写代码之前，让我们先了解下 HTML 的基础知识和一些网页爬虫的规则。

**HTML 标签**  
如果你已经理解了 HTML 的标签，请跳过这部分。

```Html
<!DOCTYPE html>  
<html>  
    <head>
    </head>
    <body>
        <h1> First Scraping </h1>
        <p> Hello World </p>
    <body>
</html>
```

下面是一个 HTML 网页的基本语法。网页上的每个标签都定义了一个内容块:
1. `<!DOCTYPE html>`：HTML 文档的开头必须有的类型声明。  
2. HTML 的文档包含在标签 `<html>` 内。  
3. `<head>` 标签里面是元数据和 HTML 文档的脚本声明。
4. `<body>` 标签里面是 HTML 文档的可视部分。 
5. 标题通过 `<h1>` 到 `<h6>` 的标签定义。  
6. 段落内容被定义在 `<p>` 标签里。

其他常用的标签还有，用于超链接的 `<a>` 标签，用于显示表格的 `<table>` 标签，以及用于显示表格行的 `<tr>` 标签，用于显示表格列的 `<td>` 标签。

另外，HTML 标签时常会有 `id` 或者 `class` 属性。`id` 属性定义了标签的唯一标识，并且这个值在当前文档中必须是唯一的。`class` 属性用来给具有相同类属性的 HTML 标签定义相同的样式。我们可以使用这些 id 和 class 来帮助我们定位我们要爬取的数据。

需要更多关于 HTML [标签](http://www.w3schools.com/html/)、 [id](http://www.w3schools.com/tags/att_global_id.asp) 和 [class](http://www.w3schools.com/html/html_classes.asp) 的相关内容，请参考 W3Schools 网站的 [教程](http://www.w3schools.com/)。

**爬取规则**

1. 你应该在爬取之前先检查一下网站使用条款。仔细的阅读其中关于合法使用数据的声明。一般来说，你爬取的数据不能用于商业用途。
2. 你的爬取程序不要太有攻击性地从网站请求数据（就像众所周知的垃圾邮件攻击一样），那可能会对网站造成破坏。确保你的爬虫程序以合理的方式运行（如同一个人在操作网站那样）。一个网页每秒请求一次是个很好的做法。
3. 网站的布局时不时的会有变化，所以要确保经常访问网站并且必要时及时重写你的代码。

### 检查网页

让我们以 [Bloomberg Quote](http://www.bloomberg.com/quote/SPX:IND) 网站的一个页面为例。

因为有些人会关注股市，那么我们就从这个页面上获取指数名称（标准普尔 500 指数）和它的价格。首先，从鼠标右键菜单中点击 Inspect 选项来查看页面。

![](https://cdn-images-1.medium.com/max/1600/1*KOJCuAYQyMIC8QdQyXERyw.png)

试着把鼠标指针悬浮在价格上，你应该可以看到出现了一个蓝色方形区域包裹住了价格。如果你点击，在浏览器的控制台上，这段 HTML 内容就被选定了。

![](https://cdn-images-1.medium.com/max/1600/1*T0t6G2tawfTtKHR4yY_iVQ.png)

通过结果，你可以看到价格被好几层 HTML 标签包裹着，`<div class="basic-quote">` → `<div class="price-container up">` → `<div class="price">`。

类似的，如果你悬浮并且点击“标准普尔 500 指数”，它被包裹在 `<div class="basic-quote">` 和 `<h1 class="name">` 里面。

![](https://cdn-images-1.medium.com/max/1600/1*ga5bmPtLDdWUTvL-pNxBgg.png)

现在我们通过 `class` 标签的帮助，知道了所需数据的确切位置。

### 编写代码

既然我们知道数据在哪儿了，我们就可以编写网页爬虫了。现在打开你的文本编辑器。

首先，需要导入所有我们需要用到的库。

```Python
# import libraries
import urllib2
from bs4 import BeautifulSoup
```

接下来，声明一个网址链接变量。

```Python
# specify the url
quote_page = ‘http://www.bloomberg.com/quote/SPX:IND'
```

然后，使用 Python 的 urllib2 来请求声明的 url 指向的 HTML 网页。
```
# query the website and return the html to the variable ‘page’
page = urllib2.urlopen(quote_page)
```

最后，把页面内容解析成 BeatifulSoup 的格式,以便我们能够使用 BeautifulSoup 去处理。。

```Python
# parse the html using beautiful soup and store in variable `soup`
soup = BeautifulSoup(page, ‘html.parser’)
```

现在我们有一个变量 `soup`，它包含了页面的 HTML 内容。这里我们就可以编写爬取数据的代码了。

还记得数据的独特的层级结构吗？BeautifulSoup 的 `find()` 方法可以帮助我们找到这些层级结构，然后提取内容。在这个例子中，因为这段 HTML 的 class 名称是唯一的，所有我们很容易找到  `<div class="name">`。

```Python
# Take out the <div> of name and get its value
name_box = soup.find(‘h1’, attrs={‘class’: ‘name’})
```

我们可以通过获取标签的 text 属性来获取数据。

```Python
name = name_box.text.strip() # strip() is used to remove starting and trailing
print name
```

类似地，我们也可以获取价格。

```Python
# get the index price
price_box = soup.find(‘div’, attrs={‘class’:’price’})
price = price_box.text
print price
```

当你运行这个程序，你可以看到标准普尔 500 指数的当前价格被打印了出来。

![](https://cdn-images-1.medium.com/max/1600/1*8sCE0XTu0Q0iHi2-QLpgXg.png)

### 输出到 Excel CSV

既然我们有了数据，是时候去保存它了。Excel 的 csv 格式是一个很好的选择。它可以通过 Excel 打开，所以你可以很轻松的打开并处理数据。

但是，首先，我们必须把 Python csv 模块导入进来，还要导入 datetime 模块来获取记录的日期。在 import 部分，加入下面这几行代码。

```Python
import csv
from datetime import datetime
```

在你的代码底部，添加保存数据到 csv 文件的代码。

```Python
# open a csv file with append, so old data will not be erased
with open(‘index.csv’, ‘a’) as csv_file:
 writer = csv.writer(csv_file)
 writer.writerow([name, price, datetime.now()])
```

如果你现在运行你的程序，你应该可以导出一个index.csv文件，然后你可以用 Excel 打开它，在里面可以看到一行数据。

![](https://cdn-images-1.medium.com/max/1600/1*d-27jLzy2GrxmvlLRJ4yVw.png)

如果你每天运行这个程序，你就可以很简单地获取标准普尔 500 指数，而不用重复地通过网页查找。

### 进阶使用 (高级应用)

**多个指数**  
对你来说，只获取一个指数远远不够，对不对？我们可以同时提取多个指数。

首先，将 `quote_page` 变量修改为一个 URL 的数组。

```Python
quote_page = [‘http://www.bloomberg.com/quote/SPX:IND', ‘http://www.bloomberg.com/quote/CCMP:IND']
```

然后我们把数据提取代码变成 `for` 循环，这样可以一个接一个地处理 URL，然后把所有的数据都存到元组 `data` 中。

```Python
# for loop
data = []
for pg in quote_page:
 # query the website and return the html to the variable ‘page’
 page = urllib2.urlopen(pg)

# parse the html using beautiful soap and store in variable `soup`
 soup = BeautifulSoup(page, ‘html.parser’)

# Take out the <div> of name and get its value
 name_box = soup.find(‘h1’, attrs={‘class’: ‘name’})
 name = name_box.text.strip() # strip() is used to remove starting and trailing

# get the index price
 price_box = soup.find(‘div’, attrs={‘class’:’price’})
 price = price_box.text

# save the data in tuple
 data.append((name, price))
```

然后，修改“保存部分”的代码以逐行保存数据。

```Python
# open a csv file with append, so old data will not be erased
with open(‘index.csv’, ‘a’) as csv_file:
 writer = csv.writer(csv_file)
 # The for loop
 for name, price in data:
 writer.writerow([name, price, datetime.now()])
```

重新运行代码，你应该可以同时提取到两个指数了。

### 高级的爬虫技术

BeautifulSoup 是一个简单且强大的小规模的网页爬虫工具。但是如果你对更大规模的网络数据爬虫感兴趣，那么你应该考虑使用其他的替代工具。

1.  [Scrapy](http://scrapy.org/)，一个强大的 Python 爬虫框架
2.  尝试将你的代码与一些公共 API 集成。数据检索的效率要远远高于网页爬虫的效率。比如，看一下 [Facebook Graph API](https://developers.facebook.com/docs/graph-api)，它可以帮助你获取未在 Facebook 网页上显示的隐藏数据。
3.  如果爬取数据过大，请考虑使用一个后台数据库来存储你的数据，比如 [MySQL](https://www.mysql.com/)。

### 采用 DRY 方法

![](https://cdn-images-1.medium.com/max/1600/1*gD4GwO1zV33IIgoeYLVrzA.jpeg)

DRY（Don't Repeat Yourself）代表“不要重复自己的工作”，尝试把你每日工作都自动化，像 [这个人](http://www.businessinsider.com/programmer-automates-his-job-2015-11) 做的那样。可以考虑一些有趣的项目，可能是跟踪你的 Facebook 好友的活跃时间（需要获得他们的同意），或者是获取论坛的演讲列表并尝试进行自然语言处理（这是当前人工智能的一个热门话题）！

如果你有任何问题，可以随时在下面留言。

**参考:**

* [http://www.gregreda.com/2013/03/03/web-scraping-101-with-python/](http://www.gregreda.com/2013/03/03/web-scraping-101-with-python/)  
* [http://www.analyticsvidhya.com/blog/2015/10/beginner-guide-web-scraping-beautiful-soup-python/](http://www.analyticsvidhya.com/blog/2015/10/beginner-guide-web-scraping-beautiful-soup-python/)

**这篇文章最初发表在 _Altitude Labs_ 的 [博客](http://altitudelabs.com/blog/)上，作者是我们的软件工程师 [_Leonard Mok_](https://medium.com/@leonardmok)。[_Altitude Labs_](http://altitudelabs.com) 是一家专门从事 _React_ 移动应用定制开发的软件代理商。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
