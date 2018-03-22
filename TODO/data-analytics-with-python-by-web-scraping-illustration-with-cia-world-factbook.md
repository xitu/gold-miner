> * 原文地址：[Data Analytics with Python by Web scraping: Illustration with CIA World Factbook](https://towardsdatascience.com/data-analytics-with-python-by-web-scraping-illustration-with-cia-world-factbook-abbdaa687a84)
> * 原文作者：[Tirthajyoti Sarkar](https://towardsdatascience.com/@tirthajyoti?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/data-analytics-with-python-by-web-scraping-illustration-with-cia-world-factbook.md](https://github.com/xitu/gold-miner/blob/master/TODO/data-analytics-with-python-by-web-scraping-illustration-with-cia-world-factbook.md)
> * 译者：
> * 校对者：

# Data Analytics with Python by Web scraping: Illustration with CIA World Factbook

## In this article, we show how to use Python libraries and HTML parsing to extract useful information from a website and answer some important analytics questions afterwards.

![](https://cdn-images-1.medium.com/max/800/1*X2QkNgg-vR3NRnGDquRm9w.png)

In a data science project, almost always the most time consuming and messy part is the data gathering and cleaning. Everyone likes to build a cool deep neural network (or XGboost) model or two and show off one’s skills with cool 3D interactive plots. But the models need raw data to start with and they don’t come easy and clean.

> **Life, after all, is not Kaggle where a zip file full of data is waiting for you to be unpacked and modeled :-)**

**But why gather data or build model anyway**? The fundamental motivation is to answer a business or scientific or social question. _Is there a trend_? _Is this thing related to that_? _Can the measurement of this entity predict the outcome for that phenomena_? It is because answering this question will validate a hypothesis you have as a scientist/practitioner of the field. You are just using data (as opposed to test tubes like a chemist or magnets like a physicist) to test your hypothesis and prove/disprove it scientifically. **That is the ‘science’ part of the data science. Nothing more, nothing less…**

Trust me, it is not that hard to come up with a good quality question which requires a bit of application of data science techniques to answer. Each such question then becomes a small little project of your which you can code up and showcase on a open-source platform like Github to show to your friends. Even if you are not a data scientist by profession, nobody can stop you writing cool program to answer a good data question. That showcases you as a person who is comfortable around data and one who can tell a story with data.

Let’s tackle one such question today…

> **Is there any relationship between the GDP (in terms of purchasing power parity) of a country and the percentage of its Internet users? And is this trend similar for low-income/middle-income/high-income countries?**

Now, there can be any number of sources you can think of to gather data for answering this question. I found that an website from CIA (Yes, the ‘AGENCY’), which hosts basic factual information about all countries around the world, is a good place to scrape the data from.

So, we will use following Python modules to build our database and visualizations,

*   **Pandas**, **Numpy, matplotlib/seaborn**
*   Python **urllib** (for sending the HTTP requests)
*   **BeautifulSoup** (for HTML parsing)
*   **Regular expression module** (for finding the exact matching text to search for)

Let’s talk about the program structure to answer this data science question. The [entire boiler plate code is available here](https://github.com/tirthajyoti/Web-Database-Analytics-Python/blob/master/CIA-Factbook-Analytics2.ipynb) in my [Github repository](https://github.com/tirthajyoti/Web-Database-Analytics-Python). Please feel free to fork and star if you like it.

#### Reading the front HTML page and passing on to BeautifulSoup

Here is how the [front page of the CIA World Factbook](https://www.cia.gov/library/publications/the-world-factbook/) looks like,

![](https://cdn-images-1.medium.com/max/800/1*CjEOFPmEDpz5z-Wc_YOfNg.png)

Fig: CIA World Factbook front page.

We use a simple urllib request with a SSL error ignore context to retrieve this page and then pass it on to the magical BeautifulSoup, which parses the HTML for us and produce a pretty text dump. For those, who are not familiar with the BeautifulSoup library, they can watch the following video or read this [great informative article on Medium](https://medium.freecodecamp.org/how-to-scrape-websites-with-python-and-beautifulsoup-5946935d93fe).

YouTube 视频地址：https://youtu.be/aIPqt-OdmS0

So, here is the code snippet for reading the front page HTML,

```
ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE

# Read the HTML from the URL and pass on to BeautifulSoup
url = 'https://www.cia.gov/library/publications/the-world-factbook/'
print("Opening the file connection...")
uh= urllib.request.urlopen(url, context=ctx)
print("HTTP status",uh.getcode())
html =uh.read().decode()
print(f"Reading done. Total {len(html)} characters read.")
```

Here is how we pass it on to BeautifulSoup and use the `find_all` method to find all the country names and codes embedded in the HTML. Basically, the idea is to **find the HTML tags named ‘option’**. The text in that tag is the country name and the char 5 and 6 of the tag value represent the 2-character country code.

Now, you may ask how would you know that you need to extract 5th and 6th character only? The simple answer is that **you have to examine the soup text i.e. parsed HTML text yourself and determine those indices**. There is no universal method to determine this. Each HTML page and the underlying structure is unique.

```
soup = BeautifulSoup(html, 'html.parser')
country_codes=[]
country_names=[]

for tag in soup.find_all('option'):
    country_codes.append(tag.get('value')[5:7])
    country_names.append(tag.text)

temp=country_codes.pop(0) # To remove the first entry 'World'
temp=country_names.pop(0) # To remove the first entry 'World'
```

#### Crawling: Download all the text data of all countries into a dictionary by scraping each page individually

This step is the essential scraping or crawling as they say. To do this, **the key thing to identify is how the URL of each countries information page is structured**. Now, in general case, this is may be hard to get. In this particular case, quick examination shows a very simple and regular structure to follow. Here is the screenshot of Australia for example,

![](https://cdn-images-1.medium.com/max/800/1*vYfbPogbxVdPhX9hoSUc6g.png)

That means there is a fixed URL to which you have to append the 2-character country code and you get to the URL of that country’s page. So, we can just iterate over the country codes’ list and use BeautifulSoup to extract all the text and store in our local dictionary. Here is the code snippet,

```
# Base URL
urlbase = 'https://www.cia.gov/library/publications/the-world-factbook/geos/'
# Empty data dictionary
text_data=dict()

# Iterate over every country
for i in range(1,len(country_names)-1):
    country_html=country_codes[i]+'.html'
    url_to_get=urlbase+country_html
    # Read the HTML from the URL and pass on to BeautifulSoup
    html = urllib.request.urlopen(url_to_get, context=ctx).read()
    soup = BeautifulSoup(html, 'html.parser')
    txt=soup.get_text()
    text_data[country_names[i]]=txt
    print(f"Finished loading data for {country_names[i]}")
    
print ("\n**Finished downloading all text data!**")
```

#### Store in a Pickle dump if you like

For good measure, I prefer to serialize and **store this data in a** [**Python pickle object**](https://pythontips.com/2013/08/02/what-is-pickle-in-python/)anyway. That way I can just read the data directly next time I open the Jupyter notebook without repeating the web crawling steps.

```
import pickle
pickle.dump(text_data,open("text_data_CIA_Factobook.p", "wb"))

# Unpickle and read the data from local storage next time
text_data = pickle.load(open("text_data_CIA_Factobook.p", "rb"))
```

#### Using regular expression to extract the GDP/capita data from the text dump

This is the core text analytics part of the program, where we take help of [**_regular expression_** module](https://docs.python.org/3/howto/regex.html) to find what we are looking for in the huge text string and extract the relevant numerical data. Now, regular expression is a rich resource in Python (or in virtually every high level programming language). It allows searching/matching particular pattern of strings within a large corpus of text. Here, we use very simple methods of regular expression for matching the exact words like “_GDP — per capita (PPP):_” and then read few characters after that, extract the positions of certain symbols like $ and parentheses to eventually extract the numerical value of GDP/capita. Here is the idea illustrated with a figure.

![](https://cdn-images-1.medium.com/max/800/1*1FgkmYUwds5pKIZC4HvkTw.png)

Fig: Illustration of the text analytics.

There are other regular expression tricks used in this notebook, for example to extract the total GDP properly regardless whether the figure is given in billions or trillions.

```
# 'b' to catch 'billions', 't' to catch 'trillions'
start = re.search('\$',string)
end = re.search('[b,t]',string)
if (start!=None and end!=None):
    start=start.start()
    end=end.start()
    a=string[start+1:start+end-1]
    a = convert_float(a)
    if (string[end]=='t'):
    # If the GDP was in trillions, multiply it by 1000
        a=1000*a
```

Here is the example code snippet. **Notice the multiple error-handling checks placed in the code**. This is necessary because of the supremely unpredictable nature of HTML pages. Not all country may have the GDP data, not all pages may have the exact same wordings for the data, not all numbers may look same, not all strings may have $ and () placed similarly. Any number of things can go wrong.

> It is almost impossible to plan and write code for all scenarios but at least you have to have code to handle the exception if they occur so that your program does not come to a halt and can gracefully move on to the next page for processing.

```
# Initialize dictionary for holding the data
GDP_PPP = {}
# Iterate over every country
for i in range(1,len(country_names)-1):
    country= country_names[i]
    txt=text_data[country]       
    pos = txt.find('GDP - per capita (PPP):')
    if pos!=-1: #If the wording/phrase is not present
        pos= pos+len('GDP - per capita (PPP):')
        string = txt[pos+1:pos+11]
        start = re.search('\$',string)
        end = re.search('\S',string)
        if (start!=None and end!=None): #If search fails somehow
            start=start.start()
            end=end.start()
            a=string[start+1:start+end-1]
            #print(a)
            a = convert_float(a)
            if (a!=-1.0): #If the float conversion fails somehow
                print(f"GDP/capita (PPP) of {country}: {a} dollars")
                # Insert the data in the dictionary
                GDP_PPP[country]=a
            else:
                print("**Could not find GDP/capita data!**")
        else:
            print("**Could not find GDP/capita data!**")
    else:
        print("**Could not find GDP/capita data!**")
print ("\nFinished finding all GDP/capita data")
```

#### Don’t forget to use pandas inner/left join method

One thing to remember is that all these text analytics will produce dataframes with slightly different set of countries as different types of data may be unavailable for different countries. One could use a [**Pandas left join**](https://pandas.pydata.org/pandas-docs/stable/merging.html) to create a dataframe with intersection of all common countries for which all the pieces of data is available/could be extracted.

```
df_combined = df_demo.join(df_GDP, how='left')
df_combined.dropna(inplace=True)
```

#### Ah the cool stuff now, Modeling…but wait! Let’s do filtering first!

After all the hard work of HTML parsing, page crawling, and text mining, now you are ready to reap the benefits — eager to run the regression algorithms and cool visualization scripts! But wait, often you need to clean up your data (particularly for this kind of socio-economic problems) a wee bit more before generating those plots. Basically, you want to filter out the outliers e.g. very small countries (like island nations) who may have extremely skewed values of the parameters you want to plot but does not follow the main underlying dynamics you want to investigate. A few lines of code is good for those filters. There may be more _Pythonic_ way to implement them but I tried to keep it extremely simple and easy to follow. The following code, for example, creates filters to keep out small countries with < 50 billion of total GDP and low and high income boundaries of $5,000 and $25,000 respectively (GDP/capita).

```
# Create a filtered data frame and x and y arrays
filter_gdp = df_combined['Total GDP (PPP)'] > 50
filter_low_income=df_combined['GDP (PPP)']>5000
filter_high_income=df_combined['GDP (PPP)']<25000

df_filtered = df_combined[filter_gdp][filter_low_income][filter_high_income]
```

#### Finally, the visualization

We use [**seaborn regplot** function](https://seaborn.pydata.org/generated/seaborn.regplot.html) to create the scatter plots (Internet users % vs. GDP/capita) with linear regression fit and 95% confidence interval bands shown. They look like following. One can interpret the result as

> There is a strong positive correlation between Internet users % and GDP/capita for a country. Moreover, the strength of correlation is significantly higher for low-income/low-GDP countries than the high-GDP, advanced nations. **That could mean access to internet helps the lower income countries to grow faster and improve the average condition of their citizens more than it does for the advanced nations**.

![](https://cdn-images-1.medium.com/max/800/1*UAMZrO5oXN_vKvwu-Zhaxg.png)

#### Summary

This article goes over a demo Python notebook to illustrate how to crawl webpages for downloading raw information by HTML parsing using BeautifulSoup. Thereafter, it also illustrates the use of Regular Expression module to search and extract important pieces of information what the user demands.

> Above all, it demonstrates how or why there can be no simple, universal rule or program structure while mining messy HTML parsed texts. One has to examine the text structure and put in place appropriate error-handling checks to gracefully handle all the situations to maintain the flow of the program (and not crash) even if it cannot extract data for all those scenarios.

I hope readers can benefit from the provided Notebook file and build upon it as per their own requirement and imagination. For more web data analytics notebooks, [**please see my repository.**](https://github.com/tirthajyoti/Web-Database-Analytics-Python)

* * *

If you have any questions or ideas to share, please contact the author at [**tirthajyoti[AT]gmail.com**](mailto:tirthajyoti@gmail.com). Also you can check author’s [**GitHub repositories**](https://github.com/tirthajyoti?tab=repositories) for other fun code snippets in Python, R, or MATLAB and machine learning resources. If you are, like me, passionate about machine learning/data science, please feel free to [add me on LinkedIn](https://www.linkedin.com/in/tirthajyoti-sarkar-2127aa7/) or [follow me on Twitter.](https://twitter.com/tirthajyotiS)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
