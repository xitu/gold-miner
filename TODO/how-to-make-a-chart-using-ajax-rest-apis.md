> * 原文地址：[How To Make A Chart Using AJAX & REST API's](https://blog.zingchart.com/2017/11/16/how-to-make-a-chart-using-ajax-rest-apis/?utm_source=frontendfocus&utm_medium=email)
> * 原文作者：[Derek Fletes](https://blog.zingchart.com/author/derek/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-to-make-a-chart-using-ajax-rest-apis.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-to-make-a-chart-using-ajax-rest-apis.md)
> * 译者：[sakila1012](https://github.com/sakila1012)
> * 校对者：[easy-blue](https://github.com/easy-blue)，[Usey95](https://github.com/usey95)

# 如何使用 AJAX 和 REST API 创建一个图表

从 REST API 获取数据是一种很常见的编程模式，使用这些数据来绘制图表同样常见。

我们的很多用户可能正在为他们的 Web 应用程序这么做，所以我想我们（ZingChart）应该写一篇关于如何正确使用的教程。

REST API 基本上是一个公开的数据集（通常是 JSON），它位于某个 URL 中，并且可以通过 HTTP 请求以编程方式访问。

**免责声明，本教程将在一般的 JavaScript 中运用。**

我选择了 [Star Wars REST API](https://swapi.co/)作为 REST 端点，从中获取数据。我之所以选择它，是因为它会返回易于使用的 JSON 数据，还不需要身份验证。

## 目录

*   [AJAX 请求](#ajaxrequest)
*   [使用响应式文本](#workingwithresponse)
*   [渲染图表](#renderingachart)

**如果你不想阅读教程，你可以在这里看到完整的代码（带注释）[](http://)**

## AJAX 请求

AJAX 是异步 JavaScript 和 XML。Ajax 是一组用于异步 HTTP 请求（GET，POST，PUT，DELETE）的方法。在这种情况下，异步意味着我们不必每次发出 HTTP 请求就重新加载页面。一个 AJAX 请求由 5 个步骤组成：

1. 创建一个新的 HTTP 请求。

2. 加载请求。

3. 使用响应的数据。

4. 创建请求。

5. 发送请求。

## 创建一个新的 HTTP 请求

要初始化一个 AJAX 请求，我们必须创建一个新的实例并将其存储在一个变量中，如下所示：

```
var xhr = new XMLHttpRequest();  

```

将它存储在一个变量中允许我们后期使用其他的 AJAX 方法。我称之为 'xhr'，因为这是一个简短的缩写，你也可以起一个你喜欢的变量名。

## 加载请求

我们的 AJAX 过程的下一步将是添加一个事件监听器到我们的请求。我们的事件监听器将响应一个 `load` 事件，一旦我们的请求加载就会触发。接下来是一个回调函数。

在我们的事件监听器中，回调函数将在 if 语句流中运行。如果我们从 API 端点收到 “200” 状态（意味着请求完成），那么我们会做一些事情。

整个顺序将如下所示：

```
xhr.addEventListener('load', function() {  
  if (this.status == 200) {
    // do something 
  }
});
```

## 处理响应

每个 AJAX 请求都会将数据返回给我们。微妙的部分是确保我们能够以我们想要的方式处理这些数据。在这个过程中将会接收我们可以从这个响应中处理的数据有四个步骤：

1. 将响应解析成 JSON 并将其存储在变量中。

2. 创建空数组，可以存放我们想要的数据。

3. 遍历响应并将值放入我们的空数组中。

4. 将数组中的值转换为可用数据。

***这里每个步骤都将在我们事件监听器内部的 if 语句中执行。****

### 解析响应

每个响应都会返回一串数据。我们需要一个 JSON 对象，这样我们就可以遍历这些值。我们可以使用 `JSON.parse()` 方法将响应字符串转换为 JSON 格式。我们可以将它存储在一个名为 `response` 的变量中，以便后期我们可以像这样处理它：

```
var response = JSON.parse(this.responseText);  
```

现在我们有一个存储在变量中的对象数组。你可以通过 `console.log(response);` 来查看完整的数组。

在这个数组中，有一个我们想要使用的特定对象叫做 `results`。这个对象包含 Star Wars 的 `characters` 和关于他们的信息。我们将把这个对象保存在一个变量中，这样我们就可以在接下来的步骤中循环。

我们可以在我们现有的 `response` 变量上使用 JSON 点符号来访问这个对象。我们将把它保存在一个名为 `characters` 的变量中。它看起来像这样：

```
var characters = response.results;  
```

### 创建空数组

接下来我们需要创建一个变量来保存一个空数组，我们将称之为 `characterInfo`。当后期我们遍历对象时，可以将值推送到这个数组中。看看下面：

```
var characterInfo = [];  
```

***我们可以将数组中的数组直接放到 ZingChart 中，并使用x轴和y轴的值来绘制图表。这非常有用。***

### 遍历响应

由于我们的 `character` 变量将被存储在一个对象数组中，我们可以使用 `forEach` 方法来遍历它。

`forEach` 方法需要一个回调函数，它将传入一个 `character` 参数。character 参数与 for 循环中的 `character[i]` 相同。它代表着它正在循环的对象。我们可以使用 JSON 点符号来访问我们在循环过程中需要的任何对象。

我们将从每个对象中提取两条数据：`name` 和 `height`。这是我们之前的空数组发挥作用的地方。在我们循环的每个对象中，我们可以使用回调函数内的`array.push()` 方法将值推送到我们空的 `characterInfo` 数组的末尾。

我们可以以数组格式插入值，以便我们可以有一个包含 character name 和 height 数组的数组。这些值将作为字符串值返回，这对于 name 属性是很好的。但是，我们可以使用 `parseInt()` 方法将每个高度值从一个字符串转换为一个数字。

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

## 创建请求

AJAX 请求的最后两个步骤实际上是促使其发生的。首先是 open 方法，打开了我们的请求。这个请求是一个 GET 请求，是 XMLHttpRequest()方法的 HTTP 部分。

GET 请求是实际到达 API 端点并获取数据。我会告诉你它是什么样子，然后我们解析它。

```
xhr.open('GET', 'https://swapi.co/api/people/');  
```

使用 `.open`，我们打开这个请求到指定的 URL: `https://swapi.co/api/people/`。这将返回一个包含 Star Wars characters 和一些额外的数据的对象数组。 REST API 通常具有一个可以获取数据的 API URL。如果您感兴趣，请查看 Star Wars API [docs](https://swapi.co/documentation)查看您可以获取的不同数据集。

REST API 几乎可以让你通过操作 URL 来指定你想要的数据。稍后在自己的 demo 中使用 Star Wars API，看看你能得到什么。

## 发送请求

最后一步可以说是您的 AJAX 请求中最重要的一部分。**如果你不这样做，这个教程将失效**。我们必须在我们的 `xhr` 变量上使用 `.send()` 方法来实际发送请求，像这样：

```
xhr.send();  
```

现在我们已经有了 AJAX 请求的框架，我们可以使用从 Star Wars REST API 端点返回的响应。

## 渲染一个图表

渲染图表包括四个步骤：

1. HTML：创建一个唯一 ID 的 `<div>`。

2. CSS：给这个 `</div>` 赋值高度和宽度。

3. JS：创建一个图表配置变量。

4. JS：使用 `zingchart.render({});` 方法来呈现图表。

### HTML

为了渲染一个图表，我们需要一个图表容器。我们可以用 `<div>` 做这个。我们还需要给这个 `<div>` 唯一的 ID：

```
<div id="chartOne"></div>  
```

我使用编号图表方法，如果我们后期需要参考，在代码中很容易找到。

### CSS

我们将在我们的 CSS 中使用这个唯一的 ID 来声明一个高度和宽度：

```
#chartOne {
  height: 200px;
  width: 200px;
}
```

如果我们不能声明高度和宽度，图表将不会呈现。

### 图表配置变量

您可以在您的应用程序中为您命名这个演示。 我选择将其命名为 **'chartOneData'**，因为我们可以轻松地将其绑定至 **'chartOne'** ID。

这个变量实际上只有两个重要的方面：

1. 声明一个图表类型（在这个例子中我们使用的是柱形图）。

2. 将值添加到我们的图表。

***我们所有的图表信息将被放置在我们的事件监听器回调函数中。***

### 声明一个图表类型

ZingChart 有一个可声明的语法，所以选择一个图表类型就像声明一个键值对一样简单：

```
var chartOneData = {  
  type: 'bar'
};
```

### 将值添加到图表

向我们的图表添加值是以类似的方式来声明一个图表类型。这一次，我们将使用嵌套键值对来添加键值对。`series` 将采取一个名为值的对象。

在这个值对象中，我们可以将数据传入到数组中。这包含了我们所有的角色信息。它看起来像这样：

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

### 渲染图表

渲染我们的图表也非常简单。我们可以使用一个内置的渲染方法，你所要做的就是传入几个键值对，它们是：

1. `id`：这是我们传入我们的 `<div>` 元素的 id。

2. `data`：他将是我们之前声明的图表变量的名称。

3. `height`：这将是 **'100％'** 的值来填充我们的容器。

4. `width`：这也将是 **'100％'** 的值来填补我们的容器。

```
zingchart.render({  
  id: 'chartOne',
  data: chartOneData,
  height: '100%',
  width: '100%'
})
```

现在我们已经完成了，我们应该有一个完整的图表，它已经成功地从 REST API 中提取数据。太好了！


## 完整 demo

<iframe height="500" scrolling="no" title="REST API AJAX Request" src="//codepen.io/zingchart/embed/de8544d3f634ae7c88144b3b237f19c0/?height=500&amp;theme-id=dark,result&amp;embed-version=2" frameborder="no" allowtransparency="true" allowfullscreen="true" style="width: 100%;">See the Pen <a href='https://codepen.io/zingchart/pen/de8544d3f634ae7c88144b3b237f19c0/'>REST API AJAX Request</a> by ZingChart (<a href='https://codepen.io/zingchart'>@zingchart</a>) on <a href='https://codepen.io'>CodePen</a>.</iframe>


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
