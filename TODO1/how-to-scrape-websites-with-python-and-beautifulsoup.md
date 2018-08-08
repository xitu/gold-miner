> * 原文地址：[How to scrape websites with Python and BeautifulSoup](https://medium.freecodecamp.org/how-to-scrape-websites-with-python-and-beautifulsoup-5946935d93fe)
> * 原文作者：[Justin Yek](https://medium.freecodecamp.org/@jyek?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-scrape-websites-with-python-and-beautifulsoup.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-scrape-websites-with-python-and-beautifulsoup.md)
> * 译者：[geniusq1981](https://github.com/geniusq1981)
> * 校对者：

# 如何使用 Python 和 BeautifulSoup 抓取网站内容 

![](https://cdn-images-1.medium.com/max/1600/1*BrUAg3-OqIHkoTz_CRIzTA.png)

互联网上的信息量比任何人究其一生掌握的信息量大的多。所以你需要做的不是逐个访问这些信息，而是需要有一种灵活的方式可以收集，组织和分析这些信息。

你需要进行网页内容爬取。

网页爬取可以自动提取出数据并可以转换成您容易理解的格式而呈现。在本教程中，我们将重点关注其在金融市场中的应用，但实际上网络抓取可用于多种情况下。

如果你是一个狂热的投资者，每天获知收盘价可能会是很痛苦的一件事，特别是当你需要的信息分散在多个网页上的时候。我们将通过构建一个网络爬虫来自动从网上检索股票指数，从而简化数据的提取。

![](https://cdn-images-1.medium.com/max/1600/1*gsn6N_tUoMb8XOWBpqQrNw.jpeg)

### 入门

我们将使用 Python 作为我们的脚本语言，还会用到一个简单但很强大的库，BeautifulSoup。

* 对于 Mac 用户，OS X 已经预装了 Python。打开终端并输入 `python --version`。你应该看到你的 Python 的版本是2.7.x。
* 对于 Windows 用户，请通过 [官方网站](https://www.python.org/downloads/) 安装 Python。

接下来，我们需要使用 Python 的包管理工具 `pip` 来安装 BeautifulSoup 库。

在终端中输入：

```Python
easy_install pip  
pip install BeautifulSoup4
```

**注意**：如果你执行上面的命令发生了错误，请尝试在每个命令前面添加 `sudo`。

### 基础知识

在我们开始真正的代码之前，让我们先了解下 HTML 的基础知识和一些网页抓取的规则。

**HTML tags**  
如果你已经理解了 HTML 的标签，请跳过这部分。

```Python
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
1. `<!DOCTYPE html>`: HTML 文档的开头必须有的类型声明。  
2. HTML 的文档包含在标签`<html>` 内。  
3. `<head>` 标签里面是元数据和脚本声明。
4. `<body` 标签里面是 HTML 文档的可视部分。 
5. 标题通过 `h1` 到 `h6` 的标签定义。  
6. 段落内容被定义在 `<p>` 标签里。

其他常用的标签还有，用于超链接的 `a` 标签，用于显示表格的 `<table>` 标签，以及用于显示表格行的 `tr` 标签，用于显示表格列的 `<td>` 标签。

另外，HTML 标签时常会有 `id` 或者 `class` 属性。`id` 属性定义了标签的唯一标识，并且这个值在当前文档中必须是唯一的。`class` 属性attribute is used to define equal styles for HTML tags with the same class. We can make use of these ids and classes to help us locate the data we want.

For more information on HTML [tags](http://www.w3schools.com/html/), [id](http://www.w3schools.com/tags/att_global_id.asp) and [class](http://www.w3schools.com/html/html_classes.asp), please refer to W3Schools [Tutorials](http://www.w3schools.com/).

**抓取规则**

1.  你应该在抓取之前先检查一下网站使用条款。仔细的阅读其中关于合法使用数据的表述内容。一般来说，你抓取的数据不能用于商业用途。
2.  你的抓取程序不要太有攻击性地从网站抓取数据（就像众所周知的垃圾邮件攻击一样），那会引起网站异常而被注意。让你的抓取程序看起来像是合理的行为（如同一个人在操作网站那样）。一秒钟访问网站一次是一个不错的方式。
3.  网站的布局时不时的会有变化，所以要确保经常访问网站并且必要时及时重写你的代码。

### 检查网页

让我们以 [Bloomberg Quote](http://www.bloomberg.com/quote/SPX:IND) 网站的一个页面为例。

因为有些人会关注股市，我们就从这个页面上获取指数名称（标准普尔 500 指数）和它的价格。首先，从鼠标右键菜单中点击 iispect 打开检查器来查看页面。

![](https://cdn-images-1.medium.com/max/1600/1*KOJCuAYQyMIC8QdQyXERyw.png)

把鼠标指针悬放在价格上，你应该可以看到出现了一个蓝色方形区域包裹住了价格。如果你点击，在浏览器的控制台上，这段 HTML 内容就被选定了。

![](https://cdn-images-1.medium.com/max/1600/1*T0t6G2tawfTtKHR4yY_iVQ.png)

通过结果，你可以看到价格被包裹在一组的 HTML 标签里面，`<div class="basic-quote">` → `<div class="price-container up">` → `<div class="price">`。

类似的，如果你点击“标准普尔 500 指数”，它被包裹在 `<div class="basic-quote">` 和 `<h1 class="name">` 里面.

![](https://cdn-images-1.medium.com/max/1600/1*ga5bmPtLDdWUTvL-pNxBgg.png)

现在我们通过 `class` 标签的帮助，知道了所需数据的确切位置。

### Jump into the Code

现在我们知道数据在哪儿，我们可以编写我们的网页爬虫。现在打开你的文本编辑器。

首先，我们需要导入所有我们将要用到的库。

```Python
# import libraries
import urllib2
from bs4 import BeautifulSoup
```

接下来，定义网页的网址变量。

```Python
# specify the url
quote_page = ‘http://www.bloomberg.com/quote/SPX:IND'
```

然后，使用 Python 的 urllib2 来请求定义的 url 指向的 HTML 网页。
```
# query the website and return the html to the variable ‘page’
page = urllib2.urlopen(quote_page)
```

最后，把页面内容解析成 BeatifulSoup 的格式,那么我们就可以使用 BeatifulSoup 来处理它了。

```Python
# parse the html using beautiful soup and store in variable `soup`
soup = BeautifulSoup(page, ‘html.parser’)
```

现在我们有一个变量 `soup`，它包含了页面的 HTML 内容。这里我们就可以编写抽取数据的代码了。

还记得你需要的数据所在的位置吗？通过 BeautifulSoup 的 `find()` 方法，可以帮助我们找到位置并提取其中内容。在这个例子中，因为这段 HTML 的 class 名称是唯一的，所有我们很简单的查找  `<div class="name">`。

```Python
# Take out the <div> of name and get its value
name_box = soup.find(‘h1’, attrs={‘class’: ‘name’})
```

获取这个标签之后，我们可以通过 `text` 来获取数据。

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

现在我们有了数据，是时候去保存它了。The Excel Comma Separated Format 是一个好的选择。它可以通过 Excel 打开，所以你可以很轻松的打开并处理。

但是，首先，我们必须把 Python csv 模块导入进来，还要导入 datetime 模块来获取记录的日期。在 import 部分，加入下面这几行代码。

```Python
import csv
from datetime import datetime
```

在这些代码下面，增加向 csv 文件中写数据的代码。

```Python
# open a csv file with append, so old data will not be erased
with open(‘index.csv’, ‘a’) as csv_file:
 writer = csv.writer(csv_file)
 writer.writerow([name, price, datetime.now()])
```

现在如果运行你的程序，你应该可以输出一个 `index.csv` 文件，你可以使用 Excel 打开它，在里面可以看到一行数据。

![](https://cdn-images-1.medium.com/max/1600/1*d-27jLzy2GrxmvlLRJ4yVw.png)

如果你每天运行这个程序，你就可以很简单地获取标准普尔 500 指数，而不用重复地通过网页查找。

### 进阶使用 (高级应用)

**多个指数**  
对你来说，只获取一个指数远远不够，对不对？我们可以同时提取多个指数。

首先，修改 `quote_page` 变量为一组 URLs.

```Python
quote_page = [‘http://www.bloomberg.com/quote/SPX:IND', ‘http://www.bloomberg.com/quote/CCMP:IND']
```

然后我们把数据提取代码变成 `for` 循环，这样可以一个接一个地处理 URLs，然后把所有的数据都存到云数组 `data` 中。

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

然后，修改保存部分代码，把数据一行一行地写到文件中。

```Python
# open a csv file with append, so old data will not be erased
with open(‘index.csv’, ‘a’) as csv_file:
 writer = csv.writer(csv_file)
 # The for loop
 for name, price in data:
 writer.writerow([name, price, datetime.now()])
```

返回程序，这样你应该可以同时提取两个指数了！

### 高级的爬虫技术

BeautifulSoup 是一个很棒的简单小型化的网页爬虫工具。但是如果你对更大规模的网络数据爬取感兴趣，那么你应该考虑使用其他一些工具。

1.  [Scrapy](http://scrapy.org/), 一个强大的 Python 爬虫框架
2.  Try to integrate your code with some public APIs. The efficiency of data retrieval is much higher than scraping webpages. For example, take a look at [Facebook Graph API](https://developers.facebook.com/docs/graph-api), which can help you get hidden data which is not shown on Facebook webpages.
3.  Consider using a database backend like [MySQL](https://www.mysql.com/) to store your data when it gets too large.

### Adopt the DRY Method

![](https://cdn-images-1.medium.com/max/1600/1*gD4GwO1zV33IIgoeYLVrzA.jpeg)

DRY 代表“不要重复自己的工作”, 尝试把你每日工作都自动化，像 [这个人](http://www.businessinsider.com/programmer-automates-his-job-2015-11) 做的那样。Some other fun projects to consider might be keeping track of your Facebook friends’ active time (with their consent of course), or grabbing a list of topics in a forum and trying out natural language processing (which is a hot topic for Artificial Intelligence right now)!

If you have any questions, please feel free to leave a comment below.

**References:**

* [http://www.gregreda.com/2013/03/03/web-scraping-101-with-python/](http://www.gregreda.com/2013/03/03/web-scraping-101-with-python/)  
* [http://www.analyticsvidhya.com/blog/2015/10/beginner-guide-web-scraping-beautiful-soup-python/](http://www.analyticsvidhya.com/blog/2015/10/beginner-guide-web-scraping-beautiful-soup-python/)

_This article was originally published on Altitude Labs’_ [_blog_](http://altitudelabs.com/blog/) _and was written by our software engineer,_ [_Leonard Mok_](https://medium.com/@leonardmok)_._ [_Altitude Labs_](http://altitudelabs.com) _is a software agency that specializes in personalized, mobile-first React apps._

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
