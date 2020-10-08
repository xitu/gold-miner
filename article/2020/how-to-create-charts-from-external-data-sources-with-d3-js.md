> * 原文地址：[How to Create Charts from External Data Sources with D3.js](https://blog.bitsrc.io/how-to-create-charts-from-external-data-sources-with-d3-js-4abbcb574706)
> * 原文作者：[Shaumik Daityari](https://medium.com/@ds_mik)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-create-charts-from-external-data-sources-with-d3-js.md](https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-create-charts-from-external-data-sources-with-d3-js.md)
> * 译者：
> * 校对者：

# How to Create Charts from External Data Sources with D3.js

#### Learn how to create amazing data visualizations using D3.Js version 5

![](https://cdn-images-1.medium.com/max/12032/1*_2y7jPirLNtPHduWzlgphQ.jpeg)

Forbes estimated in mid 2018 that humankind collectively generates [about 2.5 quintillion bytes of data every day](https://www.forbes.com/sites/bernardmarr/2018/05/21/how-much-data-do-we-create-every-day-the-mind-blowing-stats-everyone-should-read/). While a lot of effort goes into analyzing this data through machine learning algorithms, powerful visualizations help narrate the findings and put things in the right perspective. Visualizing data also helps the audience process the data faster and remember key takeaways. Over the last decade, the demand for specialists in visualizations has increased too.

D3 is a library in JavaScript to create visualizations for the web. The first version of D3 was released back in 2011 and it has matured with increasing community support. While the learning curve was a little steep for earlier versions of D3, the latest versions have been easier for JavaScript beginners. Most visualizations built for the web rely on dynamic data sources — therefore the target of this post is to enable you to create charts in D3 with external data sources.

**Tip**: Use [**Bit**](https://bit.dev) to build, share and sync your chart components (or any other JS component) between your different apps. Stop wasting time configuring packages or copy-pasting code. [Give it a try.](https://bit.dev)

![Example: A React chart component pushed to Bit’s cloud](https://cdn-images-1.medium.com/max/2000/1*eby7DKoLT-OCpOswu2HEbw.gif)

## A Bar Chart in D3

Before we load data externally in D3, let us create a basic bar chart and replicate the same after loading the data externally. First, load the D3 script by including the following line in your code.

```
<script src="https://d3js.org/d3.v5.min.js"></script>
```

You would find that most tutorials on the web for D3 are based on versions 3 and 4. However, we will use the latest version of D3, v5, which was released in early 2018. The [latest release of D3](https://github.com/d3/d3/releases/tag/v5.12.0) was about a month ago.

The [D3.js changelog](https://github.com/d3/d3/blob/master/CHANGES.md#selections-d3-selection) maintains detailed changes through versions. For the purpose of this post, you should note that the way data is loaded in version 4 is different from version 5.

First, let us define the title and data.

```
var title = "Comments on Posts",
  data = [{type: "Post A", amount: 4},
         {type: "Post B", amount: 2},
         {type: "Post C", amount: 7},
         {type: "Post D", amount: 5},
         {type: "Post E", amount: 6}]
;
```

As you have already included the D3 script, you can perform any D3 related action using the global variable `d3`. Next, create a title for the chart by appending a header element within the `body` tag. If you are creating the chart within a certain `div` element, you may wish to select that elect before creating the header element for the title. Alternately, if you know that the header is going to be the same, you may add it during page load without the use of D3.

```
d3.select("body")
  .append("h3")
  .text(title);
```

Before you proceed, you may wish to add some custom CSS.

```
body {
  background-color: #3c3c3c;
  color: #cfcfcf;
}

div {
  line-height: 15px;
  margin-bottom: 3px;
  background-color: grey;
}
```

At this point, you would notice that a heading has appeared on the page. You can define custom styling to this header in your spreadsheet. Next, create horizontal bars using divisions with widths based on the values of the data points and a constant height.

```
d3.select("body")
  .selectAll("div")
  .data(data)
  .enter()
  .append("div")
  .style("width", function(d) { return d.amount * 40 + "px"; })
  .style("height", "15px");
```

You simple bar graph is ready. You can view the chart on [CodePen](https://codepen.io/shaumik/pen/RwwNLQb). To further add labels to the bars, you would need to loop through the data and add a text element to the respective `div` element representing the bar.

Let us now try and work with external file sources.

## Loading Data from External Data Source

When data is large enough compared to the size of a webpage (~ 2 MB on average), it may create inconvenience by increasing load times if you declare this data inline. Therefore, it is a good practice to save it in a file. The same data in a CSV (Comma Separated Values) file would something like this.

The data that we used to create a bar graph above has been [uploaded on GitHub](https://raw.githubusercontent.com/sdaityari/my_git_project/master/posts.csv) to act as an external source. A CSV (comma separated values) file contains values separated by commas. The contents of the file are as follows:

```
type,amount
Post A,4
Post B,2
Post C,7
Post D,5
Post E,6
```

To read a CSV file through D3, you can use the `csv()` function. We additionally use the `d3.autoType` parsing function to convert the rows in the data set to JavaScript objects. The [documentation](https://github.com/d3/d3-dsv/blob/master/README.md#autoType) lists down the reassignment rules (like empty becomes `null`). To see the converted object, you can print the data on the console once it has been loaded using the `then()` function.

```
d3.csv('https://raw.githubusercontent.com/sdaityari/my_git_project/master/posts.csv',
  d3.autoType)
  .then(function (data) {
    console.log(data)
  });
```

Here is the output from the console of the Chrome Developer Tools, which shows the JavaScript object after conversion.

```
(5) [{…}, {…}, {…}, {…}, {…}, columns: Array(2)]
0: {type: "Post A", amount: 4}
1: {type: "Post B", amount: 2}
2: {type: "Post C", amount: 7}
3:
  amount: 5
  type: "Post D"
  __proto__: Object
4: {type: "Post E", amount: 6}
columns: Array(2)
  0: "type"
  1: "amount"
  length: 2
  __proto__: Array(0)
  length: 5
__proto__: Array(0)
```

A similar function exists to load other types of external files. To load a text file without a parser, use the following code:

```
d3.text("/path/to/file.txt").then(function(text) {
  // do something
});
```

If your file is separated by a different delimiter, you can use the `dsv()` function. The only difference here is the first argument, which is the delimiter for the file. You can also use the `dsv()` function to load a CSV file using the comma delimiter.

```
d3.dsv(',', 'https://raw.githubusercontent.com/sdaityari/my_git_project/master/posts.csv',
  d3.autoType)
  .then(function (data) {
    console.log(data)
  });
```

Additionally, the following functions are also at your disposal:

* `json()`: to load a file containing data in JSON format
* `xml()`: to load a file containing XML data
* `image()`: to load an image
* `svg()`: to load vector graphics

## Creating a Chart with External Data Source

Now that you have successfully loaded the data from an external source, let us create the chart.

```
d3.csv('https://raw.githubusercontent.com/sdaityari/my_git_project/master/posts.csv', d3.autoType).then(function (data) {
  d3.select("body")
    .selectAll("div")
    .data(data)
    .enter()
    .append("div")
    .style("width", function(d) { return d.amount * 40 + "px"; })
    .style("height", "15px");
});
```

The only difference with the previous function is that the `data()` call can be made within the `csv()` function. Since the column names are the same, the rest of the code remains unchanged.

Here is the [CodePen demo](https://codepen.io/shaumik/pen/mGWRzm) for the same bar chart with an external data source.

## Real-Time Data

An advantage of D3 allows you to update charts in real time by changing the element that contains the chart after an event is triggered. The process flow for updating a chart is as follows:

* Catch the trigger of an event and call a function
* Overwrite or update the existing data
* Refresh the visual element containing the chart

Here is a demonstration of this process [using Python and websockets](https://medium.com/@benjaminmbrown/real-time-data-visualization-with-d3-crossfilter-and-websockets-in-python-tutorial-dba5255e7f0e).

## Final Thoughts

With this, we come to the end of the tutorial on creating charts from external data sources with D3. We first created a simple bar chart with D3, explored various ways of reading data from external data sources and finally, created a chart with the newly loaded data.

Also, feel free to check out these chart components on Bit’s cloud (install them using NPM or import them using Bit to develop them in your own project):
[**chart - primereact · Bit**
**Chart components are based on Charts.js, an open source HTML5 based charting library. Tags: Chart, Graph, React, UI…**bit.dev](https://bit.dev/primefaces/primereact/chart)
[**composed-chart - recharts · Bit**
**Composed chart React component is used to combine multiple chart types like bar and line. Tags: Chart, Graph, UI…**bit.dev](https://bit.dev/recharts/recharts/composed-chart)
[**bubble-chart - cscs · Bit**
**Tags: Angular, Chart, Graph, UI Components. Dependencies: d3-color, d3-hierarchy, d3-interpolate, d3-scale. Built with…**bit.dev](https://bit.dev/yangming/cscs/bubble-chart)

## Learn More
[**Let Everyone In Your Company Share Your Reusable Components**
**Share your existing technology in a visual way to help R&D, Product, Marketing and everyone else build together.**blog.bitsrc.io](https://blog.bitsrc.io/let-everyone-in-your-company-see-your-reusable-components-270cd3213fe9)
[**Meet Bit’s Component Cloud**
**Share atomic code in the cloud to build modular software without limits.**blog.bitsrc.io](https://blog.bitsrc.io/meet-bits-atomic-component-cloud-521160de4f0c)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
