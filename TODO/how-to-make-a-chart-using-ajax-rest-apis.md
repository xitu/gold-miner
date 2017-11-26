> * 原文地址：[How To Make A Chart Using AJAX & REST API's](https://blog.zingchart.com/2017/11/16/how-to-make-a-chart-using-ajax-rest-apis/?utm_source=frontendfocus&utm_medium=email)
> * 原文作者：[Derek Fletes](https://blog.zingchart.com/author/derek/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-to-make-a-chart-using-ajax-rest-apis.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-to-make-a-chart-using-ajax-rest-apis.md)
> * 译者：
> * 校对者：

# How To Make A Chart Using AJAX & REST API's
# 如何使用 AJAX 和 REST API创建一个图表

Pulling data from REST API's is a very common programming pattern. Using this data to render charts is equally as common.
从 REST API获取数据是一种很常见的变成模式。运用这些数据渲染成图标也很常用。

I figured we (ZingChart) should write a tutorial on how exactly to do this since a lot of our users are probably doing this for their own web applications.
因为很多我们的用户正在针对他们的 web 应用使用，所以我认为我们（ZingChart）应该写一篇如何正确地使用的教程。

REST API's are basically an exposed data set (usually in JSON) that lives at a certain URL and is available to access programmatically through HTTP requests.
REST API 基本上是一个暴露的数据集（通常是JSON），它依赖于某个 URL 中，并且可以通过 HTTP 请求以编程方式访问。

**Disclaimer, this tutorial will be done in vanilla JavaScript.**
**免责声明，本教程将在一般的 JavaScript 中运用。**

I have chosen the [Star Wars REST API](https://swapi.co/) as the REST endpoint we will be retrieving data from. I just chose it because we don't need authentication & it returns JSON data that is easy to work with.
我选择了[Star Wars REST API]（https://swapi.co/）作为REST端点，我们将从中获取数据。 我选择它，是因为我们不需要身份验证，它会返回易于使用的JSON数据。

## Table Of Contents
## 目录

*   [AJAX Request](#ajaxrequest)
*   [Working With Response Text](#workingwithresponse)
*   [Rendering A Chart](#renderingachart)
*   [AJAX 请求](#ajaxrequest)
*   [使用响应式文本](#workingwithresponse)
*   [渲染图表](#renderingachart)

**If you don't want to read the tutorial, you can just see the full code (with comments) here[](http://)**
**如果你不想阅读教程，你可以在这里看到完整的代码（带注释）[](http://)**

## AJAX Request
## AJAX 请求

AJAX stands for asynchronous JavaScript and XML. Ajax is a set of strategies to make HTTP requests (GET, POST, PUT, DELETE) asynchronously. In this case, asynchronously means we don't have to reload our page every time we make an HTTP request. An AJAX request consists of 5 steps:
AJAX 是异步 JavaScript 和 XML 。 Ajax 是一组用于异步 HTTP 请求（GET，POST，PUT，DELETE）的方法。在这种情况下，异步意味着我们不必每次发出 HTTP 请求就重新加载页面。 一个 AJA X请求由5个步骤组成：

1.  Creating a new HTTP request.
1.  创建一个新的 HTTP 请求。

2.  Loading the request.
2.  加载请求。

3.  Working with response data.
3.  使用响应的数据。

4.  Opening the request.
4.  打开请求。

5.  Sending the request.
5.  发送请求。

## Creating A New HTTP Request
## 创建一个新的 HTTP 请求

To initialize an AJAX request, we have to create a new instance and store it in a variable like so:
要初始化一个 AJAX 请求，我们必须创建一个新的实例并将其存储在一个变量中，如下所示：

```
var xhr = new XMLHttpRequest();  

```
```
var xhr = new XMLHttpRequest();  

```

Storing it in a variable allows us to use other AJAX methods on it later. I call it 'xhr' because that is a quick abbreviation I can remember, however you can call if whatever you like.
将它存储在一个变量中允许我们后期使用其他的 AJAX 方法。 我称之为 'xhr' ，因为这是一个简短的缩写，但是如果你喜欢，你可以调用。

## Loading The Request
## 加载请求

The next step in our AJAX process will be to add an event listener to our request. Our event listener will be responding to a `load` event that will fire once our request has loaded. This will be followed by a callback function.
我们的AJAX过程的下一步将是添加一个事件监听器到我们的请求。 我们的事件监听器将响应一个 `load` 事件，一旦我们的请求加载就会触发。 接下来是一个回调函数。

The callback function in our event listener will operate in an if statement flow. If we receive a `200` status (which means ok) from the API endpoint, then we do something.
在我们的事件监听器中，回调函数将在if语句流中运行。 如果我们从 API 端点收到“200”状态（意思是好的），那么我们会做一些事情。

The entire sequence will look like this:
整个顺序将如下所示：

```
xhr.addEventListener('load', function() {  
  if (this.status == 200) {
    // do something 
  }
});
```
```
xhr.addEventListener('load', function() {  
  if (this.status == 200) {
    // do something 
  }
});
```

## Working With Response
## 与响应一起工作

Every AJAX request will send us back data. The tricky part is making sure we can work with this data in the way we want. There are going to be 4 steps in our process to receive data we can work with from this response:
每个 AJAX 请求都会将数据返回给我们。 微妙的部分是确保我们能够以我们想要的方式处理这些数据。 在这个过程中将会有4个步骤，接收我们可以从这个响应中处理的数据：

1.  Parsing the response to JSON and storing it in variables.
1.  将响应解析成 JSON 并将其存储在变量中。

2.  Creating empty arrays we can push our desired data into.
2.  创建空数组，可以存放我们想要的数据。

3.  Looping through the response and pushing values we want to extract into our empty array.
3.  循环访问响应并将值放入我们的空数组中。

4.  Converting array values into workable data.
4.  将数组中的值转换为可用数据。

***Each of these steps will be executed within the if statement inside of our event listener.**
***这些步骤中的每一个都将在我们的事件监听器内的if语句中执行。****


### Parsing The Response
### 解析响应

Each response returns back a string of data. We want a JSON object so we can loop through these values. We can convert the response string into JSON using the `JSON.parse()` method. We can store this in a variable called `response` so we can work with this later like so:
每个响应都会返回一串数据。 我们需要一个 JSON 对象，这样我们就可以遍历这些值。 我们可以使用 `JSON.parse（）` 方法将响应字符串转换为JSON格式。 我们可以将它存储在一个名为 `response` 的变量中，以便后期我们可以像这样处理它：

```
var response = JSON.parse(this.responseText);  
```
```
var response = JSON.parse(this.responseText);  
```

Now we have an array of objects stored in a variable. You can `console.log(response);` to see the full array.
现在我们有一个存储在变量中的对象数组。 你可以通过  `console.log（response）;`  来查看完整的数组。

Within this array, there is one specific object we want to work with called `results`. This object contains Star Wars characters and information about them. We are going to save this object in a variable so we can loop through in the next steps.
在这个数组中，有一个我们想要使用的特定对象叫做 `results` 。 这个对象包含 Star Wars 的特征和关于他们的信息。 我们将把这个对象保存在一个变量中，这样我们就可以在接下来的步骤中循环。

We can access this object using JSON dot notation on our existing `response` variable. We are going to save it in a variable called `characters`. It will look like this:
我们可以在我们现有的 `response` 变量上使用 JSON 点符号来访问这个对象。 我们将把它保存在一个名为 `characters` 的变量中。 它看起来像这样：

```
var characters = response.results;  
```
```
var characters = response.results;  
```

### Creating Empty Arrays
### 创建空数组

Next we will need to create a variable to hold an empty array, we will call this `characterInfo`. When we loop through our object later we can push values into this array. Check it out below:
接下来我们需要创建一个变量来保存一个空数组，我们将称之为`characterInfo`。 当我们稍后循环我们的对象时，我们可以将值推送到这个数组中。 看看下面：

```
var characterInfo = [];  
```
```
var characterInfo = [];  
```

***We can place array of arrays directly into ZingChart and render a chart with both x-axis and y-axis values. It's pretty useful.**
***我们可以将数组中的数组直接放到 ZingChart 中，并使用x轴和y轴的值来绘制图表。 这非常有用。***

### Looping Through The Response
### 循环访问响应

Since our `character` variable will be stored in an array of objects, we can use the `forEach` method to loop through this.
由于我们的`character`变量将被存储在一个对象数组中，我们可以使用`forEach`方法来遍历它。

The `forEach` method takes in a callback function that will take in a `character` as a parameter. The character parameter serves the same purpose `characters[i]` would inside of a for loop. It stands for the object it is currently looping through. We can use JSON dot notation to access any piece of the object we desire during the loop.
`forEach` 方法需要一个回调函数，它将一个 `character` 作为参数。 character 参数与 for 循环中的 `character[i]` 相同。 它代表着它正在循环的对象。 我们可以使用 JSON 点符号来访问我们在循环过程中需要的任何对象。

There are two pieces of data we are going to pull from each object; `name` & `height`. This is where our empty array from earlier will come into play. In each object we loop through, we can use the `array.push()` method inside of our callback function to push values to the end of our empty `characterInfo` array.
我们将从每个对象中提取两条数据; `name` 和 `height`。 这是我们之前的空数组发挥作用的地方。 在我们循环的每个对象中，我们可以使用回调函数内的`array.push（）` 方法将值推送到我们空的`characterInfo`数组的末尾。

We can push values in array format so we can have an array of arrays containing character name and height. These values will be returned as string values, which is fine for the name attribute. However, we can use the `parseInt()` method to typecast each height value into a number from a string.
我们可以以数组格式插入值，以便我们可以有一个包含 character name 和 height 的数组数组。 这些值将作为字符串值返回，这对于name属性是很好的。 但是，我们可以使用 `parseInt（）` 方法将每个高度值从一个字符串转换为一个数字。

Altogether from our code will look like this:
我们的代码将如下所示：

```
xhr.addEventListener('load', function() {  
  if (this.status == 200) {
    var response = 
    JSON.parse(this.responseText);
    var characters = response.results;
    var characterData = [];
    characters.forEach(function(character) {
      characterData.push([character.name, 
      parseInt(character.height)]);
    });
  });
```
```
xhr.addEventListener('load', function() {  
  if (this.status == 200) {
    var response = 
    JSON.parse(this.responseText);
    var characters = response.results;
    var characterData = [];
    characters.forEach(function(character) {
      characterData.push([character.name, 
      parseInt(character.height)]);
    });
  });
```

## Opening The Request
## 打开请求

The last two steps of this AJAX request are what actually makes this thing go. First, is the open method. This opens our request. This request is going to be a GET request. Which is the HTTP part of this `XMLHttpRequest();` method.

This GET request is what actually reaches this API endpoint and retrieves data. I'll show you what it looks like and then we will dissect this.

```
xhr.open('GET', 'https://swapi.co/api/people/');  
```
```
xhr.open('GET', 'https://swapi.co/api/people/');  
```

With `.open` we are opening this request to the URL specified which is `https://swapi.co/api/people/`. This will return an array of objects that contains Star Wars characters and some additional data about them. REST API's generally have an API URL you can reach to grab data. If you are curious check out the Star Wars API [docs](https://swapi.co/documentation) to see the different sets of data you can retrieve.
使用 `.open` ，我们打开这个请求到指定的 URL: `https://swapi.co/api/people/` 。 这将返回一个包含 Star Wars 特征和一些额外的数据的对象数组。 REST API 通常具有一个可以获取数据的API URL。 如果您感兴趣，请查看Star Wars API [docs]（https://swapi.co/documentation）查看您可以获取的不同数据集。

REST API's pretty much let you dictate what data you want by manipulating the URL. Play around with the Star Wars API in your own demo later to see exactly what you can get.
REST API 几乎可以让你通过操作 URL 来指定你想要的数据。 稍后在自己的演示中玩 Star Wars API，看看你能得到什么。

## Sending The Request
## 发送请求

The last step is arguably the most important piece of your AJAX request. **If you don't do it, none of this tutorial will function**. We have to use the `.send()` method on our `xhr` variable in order to actually send the request like so:
最后一步可以说是您的 AJAX 请求中最重要的一部分。 **如果你不这样做，这个教程没有任何功能**。 我们必须在我们的 `xhr` 变量上使用 `.send（）` 方法来实际发送请求，像这样：

```
xhr.send();  
```
```
xhr.send();  
```

Now that we have the skeleton of our AJAX request, we can work with the response we get sent back from the Star Wars REST API endpoint.
现在我们已经有了AJAX请求的框架，我们可以使用从 Star Wars REST API 端点返回的响应。

## Rendering A Chart
## 渲染一个图表

Rendering a chart consists of four steps:
渲染图表包括四个步骤：

1.  HTML: Creating a `<div>` with a unique id.
1.  HTML:创建一个唯一ID的 `<div>` 。

2.  CSS: Giving this `<div>` a height and width.
2.  CSS: 给这个 `</div>` 赋值高度和宽度。

3.  JS: Creating a chart configuration variable.
3.  JS: 创建一个图表配置变量。

4.  JS: Using the `zingchart.render({});` method to render the chart.
4.  JS: 使用 `zingchart.render（{}）;` 方法来呈现图表。

### HTML
### HTML

In order to render out a chart we will need a chart container. We can use a `<div>` to do this. We will also need to give this `<div>` a unique ID like this:
为了渲染一个图表，我们需要一个图表容器。 我们可以用 `<div>` 做这个。 我们还需要给这个 `<div>` 唯一的ID：

```
<div id="chartOne"></div>  
```
```
<div id="chartOne"></div>  
```

I use the numbered chart method because it's easy to find in the code if we need to reference later.
我使用编号图表方法，如果我们后期需要参考，在代码中很容易找到。

### CSS
### CSS

We will use that unique ID in our css to declare a height & width:
我们将在我们的CSS中使用这个唯一的ID来声明一个高度和宽度：

```
#chartOne {
  height: 200px;
  width: 200px;
}
```
```
#chartOne {
  height: 200px;
  width: 200px;
}
```

If we fail to declare a height & width, our chart will not render.
如果我们不能声明高度和宽度，图表将不会呈现。

### Chart Configuration Variable
### 图表配置变量

You can name this demo whatever makes sense to you within your application. I chose to name it **'chartOneData'** as we can easily tie this back to our **'chartOne'** ID.
您可以在您的应用程序中为您命名这个演示。 我选择将其命名为**'chartOneData'**，因为我们可以轻松地将其绑定至**'chartOne'** ID。

There are really only two important aspects of this variable:
这个变量实际上只有两个重要的方面：

1.  Declaring a chart type (we are using bar in this example).
1.  声明一个图表类型（在这个例子中我们使用的是bar）。

2.  Adding values to our chart.
2.  将值添加到我们的图表。

***All of our chart information will be placed in our event listener callback function.***
***我们所有的图表信息将被放置在我们的事件监听器回调函数中。***

### Declaring A Chart Type
### 声明一个图表类型

ZingChart has a declarable syntax, so choosing a chart type is as easy as declaring a key value pair like this:
ZingChart有一个可声明的语法，所以选择一个图表类型就像声明一个键值对一样简单：

```
var chartOneData = {  
  type: 'bar'
};
```
```
var chartOneData = {  
  type: 'bar'
};
```

### Adding Values To The Chart
### 将值添加到图表

Adding values to our chart is done in similar fashion to declaring a chart type. This time we will ad a key value pair with a nested key value pair. `series` will take an object called values.
向我们的图表添加值是以类似的方式来声明一个图表类型。 这一次，我们将使用嵌套键值对来添加键值对。 `series` 将采取一个名为值的对象。

Within this values object we can pass in the array we pushed data into. This holds all of our character information. It will look like this:
在这个值对象中，我们可以将数据传入到数组中。 这包含了我们所有的角色信息。 它看起来像这样：

```
var chartOneData = {  
  type: 'bar',
  series: [
    {
      values: characterInfo
    }
  ]
}
```
```
var chartOneData = {  
  type: 'bar',
  series: [
    {
      values: characterInfo
    }
  ]
}
```

### Rendering Our Chart
### 渲染图表

Rendering our chart is pretty simple as well. There is a built in render method we can use and all you have to do is pass in a few key value pairs which are:
渲染我们的图表也非常简单。 我们可以使用一个内置的渲染方法，你所要做的就是传入几个关键值对，它们是：

1.  `id`: this is the id we passed into our `<div>` element.
1.  `id`:这是我们传入我们的`<div>`元素的id。

2.  `data`: this will be the name of the chart variable we declared previously.
2.  `data`: 他将是我们之前声明的图表变量的名称。

3.  `height`: this will be a value of **'100%'** to fill our container.
3.  `height`: 这将是**'100％'** 的值来填充我们的容器。

4.  `width`: this will also be a value of **'100%'** to fill our container.
4.  `width`: 这也将是**'100％'** 的价值来填补我们的容器。

```
zingchart.render({  
  id: 'chartOne',
  data: chartOneData,
  height: '100%',
  width: '100%'
})
```
```
zingchart.render({  
  id: 'chartOne',
  data: chartOneData,
  height: '100%',
  width: '100%'
})
```

Now that we have this going we should have a full chart rendered that has successfully pulled data from a REST API. Nice!
现在我们已经完成了，我们应该有一个完整的图表，它已经成功地从REST API中提取数据。太好了！

## Full Demo

<iframe height="500" scrolling="no" title="REST API AJAX Request" src="//codepen.io/zingchart/embed/de8544d3f634ae7c88144b3b237f19c0/?height=500&amp;theme-id=dark,result&amp;embed-version=2" frameborder="no" allowtransparency="true" allowfullscreen="true" style="width: 100%;">See the Pen <a href='https://codepen.io/zingchart/pen/de8544d3f634ae7c88144b3b237f19c0/'>REST API AJAX Request</a> by ZingChart (<a href='https://codepen.io/zingchart'>@zingchart</a>) on <a href='https://codepen.io'>CodePen</a>.</iframe>

## 完整演示
<iframe height="500" scrolling="no" title="REST API AJAX Request" src="//codepen.io/zingchart/embed/de8544d3f634ae7c88144b3b237f19c0/?height=500&amp;theme-id=dark,result&amp;embed-version=2" frameborder="no" allowtransparency="true" allowfullscreen="true" style="width: 100%;">See the Pen <a href='https://codepen.io/zingchart/pen/de8544d3f634ae7c88144b3b237f19c0/'>REST API AJAX Request</a> by ZingChart (<a href='https://codepen.io/zingchart'>@zingchart</a>) on <a href='https://codepen.io'>CodePen</a>.</iframe>


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
