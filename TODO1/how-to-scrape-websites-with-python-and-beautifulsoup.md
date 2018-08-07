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

下面是一个 HTML 网页的基本语法。每个This is the basic syntax of an HTML webpage. Every `<tag>` serves a block inside the webpage:  
1. `<!DOCTYPE html>`: HTML 文档的开头必须有类型声明。  
2. HTML 的文档包含在标签`<html>` 和 `</html>`内。  
3. `<head>` 和 `</head>`之间是元数据和脚本声明。
4. HTML 文档的可视部分被包裹在<body> 和 </body> 之间。 
5. Title headings are defined with the `<h1>` through `<h6>` tags.  
6. Paragraphs are defined with the `<p>` tag.

Other useful tags include `<a>` for hyperlinks, `<table>` for tables, `<tr>` for table rows, and `<td>` for table columns.

Also, HTML tags sometimes come with `id` or `class` attributes. The `id` attribute specifies a unique id for an HTML tag and the value must be unique within the HTML document. The `class` attribute is used to define equal styles for HTML tags with the same class. We can make use of these ids and classes to help us locate the data we want.

For more information on HTML [tags](http://www.w3schools.com/html/), [id](http://www.w3schools.com/tags/att_global_id.asp) and [class](http://www.w3schools.com/html/html_classes.asp), please refer to W3Schools [Tutorials](http://www.w3schools.com/).

**Scraping Rules**

1.  You should check a website’s Terms and Conditions before you scrape it. Be careful to read the statements about legal use of data. Usually, the data you scrape should not be used for commercial purposes.
2.  Do not request data from the website too aggressively with your program (also known as spamming), as this may break the website. Make sure your program behaves in a reasonable manner (i.e. acts like a human). One request for one webpage per second is good practice.
3.  The layout of a website may change from time to time, so make sure to revisit the site and rewrite your code as needed

### Inspecting the Page

Let’s take one page from the [Bloomberg Quote](http://www.bloomberg.com/quote/SPX:IND) website as an example.

As someone following the stock market, we would like to get the index name (S&P 500) and its price from this page. First, right-click and open your browser’s inspector to inspect the webpage.

![](https://cdn-images-1.medium.com/max/1600/1*KOJCuAYQyMIC8QdQyXERyw.png)

Try hovering your cursor on the price and you should be able to see a blue box surrounding it. If you click it, the related HTML will be selected in the browser console.

![](https://cdn-images-1.medium.com/max/1600/1*T0t6G2tawfTtKHR4yY_iVQ.png)

From the result, we can see that the price is inside a few levels of HTML tags, which is `<div class="basic-quote">` → `<div class="price-container up">` → `<div class="price">`.

Similarly, if you hover and click the name “S&P 500 Index”, it is inside `<div class="basic-quote">` and `<h1 class="name">`.

![](https://cdn-images-1.medium.com/max/1600/1*ga5bmPtLDdWUTvL-pNxBgg.png)

Now we know the unique location of our data with the help of `class` tags.

### Jump into the Code

Now that we know where our data is, we can start coding our web scraper. Open your text editor now!

First, we need to import all the libraries that we are going to use.

```
# import libraries
import urllib2
from bs4 import BeautifulSoup
```

Next, declare a variable for the url of the page.

```
# specify the url
quote_page = ‘http://www.bloomberg.com/quote/SPX:IND'
```

Then, make use of the Python urllib2 to get the HTML page of the url declared.

```
# query the website and return the html to the variable ‘page’
page = urllib2.urlopen(quote_page)
```

Finally, parse the page into BeautifulSoup format so we can use BeautifulSoup to work on it.

```
# parse the html using beautiful soup and store in variable `soup`
soup = BeautifulSoup(page, ‘html.parser’)
```

Now we have a variable, `soup`, containing the HTML of the page. Here’s where we can start coding the part that extracts the data.

Remember the unique layers of our data? BeautifulSoup can help us get into these layers and extract the content with `find()`. In this case, since the HTML class `name` is unique on this page, we can simply query `<div class="name">`.

```
# Take out the <div> of name and get its value
name_box = soup.find(‘h1’, attrs={‘class’: ‘name’})
```

After we have the tag, we can get the data by getting its `text`.

```
name = name_box.text.strip() # strip() is used to remove starting and trailing
print name
```

Similarly, we can get the price too.

```
# get the index price
price_box = soup.find(‘div’, attrs={‘class’:’price’})
price = price_box.text
print price
```

When you run the program, you should be able to see that it prints out the current price of the S&P 500 Index.

![](https://cdn-images-1.medium.com/max/1600/1*8sCE0XTu0Q0iHi2-QLpgXg.png)

### Export to Excel CSV

Now that we have the data, it is time to save it. The Excel Comma Separated Format is a nice choice. It can be opened in Excel so you can see the data and process it easily.

But first, we have to import the Python csv module and the datetime module to get the record date. Insert these lines to your code in the import section.

```
import csv
from datetime import datetime
```

At the bottom of your code, add the code for writing data to a csv file.

```
# open a csv file with append, so old data will not be erased
with open(‘index.csv’, ‘a’) as csv_file:
 writer = csv.writer(csv_file)
 writer.writerow([name, price, datetime.now()])
```

Now if you run your program, you should able to export an `index.csv` file, which you can then open with Excel, where you should see a line of data.

![](https://cdn-images-1.medium.com/max/1600/1*d-27jLzy2GrxmvlLRJ4yVw.png)

So if you run this program everyday, you will be able to easily get the S&P 500 Index price without rummaging through the website!

### Going Further (Advanced uses)

**Multiple Indices**  
So scraping one index is not enough for you, right? We can try to extract multiple indices at the same time.

First, modify the `quote_page` into an array of URLs.

```
quote_page = [‘http://www.bloomberg.com/quote/SPX:IND', ‘http://www.bloomberg.com/quote/CCMP:IND']
```

Then we change the data extraction code into a `for` loop, which will process the URLs one by one and store all the data into a variable `data` in tuples.

```
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

Also, modify the saving section to save data row by row.

```
# open a csv file with append, so old data will not be erased
with open(‘index.csv’, ‘a’) as csv_file:
 writer = csv.writer(csv_file)
 # The for loop
 for name, price in data:
 writer.writerow([name, price, datetime.now()])
```

Rerun the program and you should be able to extract two indices at the same time!

### Advanced Scraping Techniques

BeautifulSoup is simple and great for small-scale web scraping. But if you are interested in scraping data at a larger scale, you should consider using these other alternatives:

1.  [Scrapy](http://scrapy.org/), a powerful python scraping framework
2.  Try to integrate your code with some public APIs. The efficiency of data retrieval is much higher than scraping webpages. For example, take a look at [Facebook Graph API](https://developers.facebook.com/docs/graph-api), which can help you get hidden data which is not shown on Facebook webpages.
3.  Consider using a database backend like [MySQL](https://www.mysql.com/) to store your data when it gets too large.

### Adopt the DRY Method

![](https://cdn-images-1.medium.com/max/1600/1*gD4GwO1zV33IIgoeYLVrzA.jpeg)

DRY stands for “Don’t Repeat Yourself”, try to automate your everyday tasks like [this person](http://www.businessinsider.com/programmer-automates-his-job-2015-11). Some other fun projects to consider might be keeping track of your Facebook friends’ active time (with their consent of course), or grabbing a list of topics in a forum and trying out natural language processing (which is a hot topic for Artificial Intelligence right now)!

If you have any questions, please feel free to leave a comment below.

**References:**

* [http://www.gregreda.com/2013/03/03/web-scraping-101-with-python/](http://www.gregreda.com/2013/03/03/web-scraping-101-with-python/)  
* [http://www.analyticsvidhya.com/blog/2015/10/beginner-guide-web-scraping-beautiful-soup-python/](http://www.analyticsvidhya.com/blog/2015/10/beginner-guide-web-scraping-beautiful-soup-python/)

_This article was originally published on Altitude Labs’_ [_blog_](http://altitudelabs.com/blog/) _and was written by our software engineer,_ [_Leonard Mok_](https://medium.com/@leonardmok)_._ [_Altitude Labs_](http://altitudelabs.com) _is a software agency that specializes in personalized, mobile-first React apps._

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
