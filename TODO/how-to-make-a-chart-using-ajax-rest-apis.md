> * 原文地址：[How To Make A Chart Using AJAX & REST API's]()https://blog.zingchart.com/2017/11/16/how-to-make-a-chart-using-ajax-rest-apis/?utm_source=frontendfocus&utm_medium=email
> * 原文作者：[Derek Fletes](https://blog.zingchart.com/author/derek/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-to-make-a-chart-using-ajax-rest-apis.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-to-make-a-chart-using-ajax-rest-apis.md)
> * 译者：
> * 校对者：

# How To Make A Chart Using AJAX & REST API's

Pulling data from REST API's is a very common programming pattern. Using this data to render charts is equally as common.

I figured we (ZingChart) should write a tutorial on how exactly to do this since a lot of our users are probably doing this for their own web applications.

REST API's are basically an exposed data set (usually in JSON) that lives at a certain URL and is available to access programmatically through HTTP requests.

**Disclaimer, this tutorial will be done in vanilla JavaScript.**

I have chosen the [Star Wars REST API](https://swapi.co/) as the REST endpoint we will be retrieving data from. I just chose it because we don't need authentication & it returns JSON data that is easy to work with.

## Table Of Contents

*   [AJAX Request](#ajaxrequest)
*   [Working With Response Text](#workingwithresponse)
*   [Rendering A Chart](#renderingachart)

**If you don't want to read the tutorial, you can just see the full code (with comments) here[](http://)**

## AJAX Request

AJAX stands for asynchronous JavaScript and XML. Ajax is a set of strategies to make HTTP requests (GET, POST, PUT, DELETE) asynchronously. In this case, asynchronously means we don't have to reload our page every time we make an HTTP request. An AJAX request consists of 5 steps:

1.  Creating a new HTTP request.

2.  Loading the request.

3.  Working with response data.

4.  Opening the request.

5.  Sending the request.

## Creating A New HTTP Request

To initialize an AJAX request, we have to create a new instance and store it in a variable like so:

```
var xhr = new XMLHttpRequest();  

```

Storing it in a variable allows us to use other AJAX methods on it later. I call it 'xhr' because that is a quick abbreviation I can remember, however you can call if whatever you like.

## Loading The Request

The next step in our AJAX process will be to add an event listener to our request. Our event listener will be responding to a `load` event that will fire once our request has loaded. This will be followed by a callback function.

The callback function in our event listener will operate in an if statement flow. If we receive a `200` status (which means ok) from the API endpoint, then we do something.

The entire sequence will look like this:

```
xhr.addEventListener('load', function() {  
  if (this.status == 200) {
    // do something 
  }
});
```

## Working With Response

Every AJAX request will send us back data. The tricky part is making sure we can work with this data in the way we want. There are going to be 4 steps in our process to receive data we can work with from this response:

1.  Parsing the response to JSON and storing it in variables.

2.  Creating empty arrays we can push our desired data into.

3.  Looping through the response and pushing values we want to extract into our empty array.

4.  Converting array values into workable data.

***Each of these steps will be executed within the if statement inside of our event listener.**

### Parsing The Response

Each response returns back a string of data. We want a JSON object so we can loop through these values. We can convert the response string into JSON using the `JSON.parse()` method. We can store this in a variable called `response` so we can work with this later like so:

```
var response = JSON.parse(this.responseText);  
```

Now we have an array of objects stored in a variable. You can `console.log(response);` to see the full array.

Within this array, there is one specific object we want to work with called `results`. This object contains Star Wars characters and information about them. We are going to save this object in a variable so we can loop through in the next steps.

We can access this object using JSON dot notation on our existing `response` variable. We are going to save it in a variable called `characters`. It will look like this:

```
var characters = response.results;  
```

### Creating Empty Arrays

Next we will need to create a variable to hold an empty array, we will call this `characterInfo`. When we loop through our object later we can push values into this array. Check it out below:

```
var characterInfo = [];  
```

***We can place array of arrays directly into ZingChart and render a chart with both x-axis and y-axis values. It's pretty useful.**

### Looping Through The Response

Since our `character` variable will be stored in an array of objects, we can use the `forEach` method to loop through this.

The `forEach` method takes in a callback function that will take in a `character` as a parameter. The character parameter serves the same purpose `characters[i]` would inside of a for loop. It stands for the object it is currently looping through. We can use JSON dot notation to access any piece of the object we desire during the loop.

There are two pieces of data we are going to pull from each object; `name` & `height`. This is where our empty array from earlier will come into play. In each object we loop through, we can use the `array.push()` method inside of our callback function to push values to the end of our empty `characterInfo` array.

We can push values in array format so we can have an array of arrays containing character name and height. These values will be returned as string values, which is fine for the name attribute. However, we can use the `parseInt()` method to typecast each height value into a number from a string.

Altogether from our code will look like this:

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

The last two steps of this AJAX request are what actually makes this thing go. First, is the open method. This opens our request. This request is going to be a GET request. Which is the HTTP part of this `XMLHttpRequest();` method.

This GET request is what actually reaches this API endpoint and retrieves data. I'll show you what it looks like and then we will dissect this.

```
xhr.open('GET', 'https://swapi.co/api/people/');  
```

With `.open` we are opening this request to the URL specified which is `https://swapi.co/api/people/`. This will return an array of objects that contains Star Wars characters and some additional data about them. REST API's generally have an API URL you can reach to grab data. If you are curious check out the Star Wars API [docs](https://swapi.co/documentation) to see the different sets of data you can retrieve.

REST API's pretty much let you dictate what data you want by manipulating the URL. Play around with the Star Wars API in your own demo later to see exactly what you can get.

## Sending The Request

The last step is arguably the most important piece of your AJAX request. **If you don't do it, none of this tutorial will function**. We have to use the `.send()` method on our `xhr` variable in order to actually send the request like so:

```
xhr.send();  
```

Now that we have the skeleton of our AJAX request, we can work with the response we get sent back from the Star Wars REST API endpoint.

## Rendering A Chart

Rendering a chart consists of four steps:

1.  HTML: Creating a `<div>` with a unique id.

2.  CSS: Giving this `<div>` a height and width.

3.  JS: Creating a chart configuration variable.

4.  JS: Using the `zingchart.render({});` method to render the chart.

### HTML

In order to render out a chart we will need a chart container. We can use a `<div>` to do this. We will also need to give this `<div>` a unique ID like this:

```
<div id="chartOne"></div>  
```

I use the numbered chart method because it's easy to find in the code if we need to reference later.

### CSS

We will use that unique ID in our css to declare a height & width:

```
#chartOne {
  height: 200px;
  width: 200px;
}
```

If we fail to declare a height & width, our chart will not render.

### Chart Configuration Variable

You can name this demo whatever makes sense to you within your application. I chose to name it **'chartOneData'** as we can easily tie this back to our **'chartOne'** ID.

There are really only two important aspects of this variable:

1.  Declaring a chart type (we are using bar in this example).

2.  Adding values to our chart.

***All of our chart information will be placed in our event listener callback function.**

### Declaring A Chart Type

ZingChart has a declarable syntax, so choosing a chart type is as easy as declaring a key value pair like this:

```
var chartOneData = {  
  type: 'bar'
};
```

### Adding Values To The Chart

Adding values to our chart is done in similar fashion to declaring a chart type. This time we will ad a key value pair with a nested key value pair. `series` will take an object called values.

Within this values object we can pass in the array we pushed data into. This holds all of our character information. It will look like this:

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

Rendering our chart is pretty simple as well. There is a built in render method we can use and all you have to do is pass in a few key value pairs which are:

1.  `id`: this is the id we passed into our `<div>` element.

2.  `data`: this will be the name of the chart variable we declared previously.

3.  `height`: this will be a value of **'100%'** to fill our container.

4.  `width`: this will also be a value of **'100%'** to fill our container.

```
zingchart.render({  
  id: 'chartOne',
  data: chartOneData,
  height: '100%',
  width: '100%'
})
```

Now that we have this going we should have a full chart rendered that has successfully pulled data from a REST API. Nice!

## Full Demo

<iframe height="500" scrolling="no" title="REST API AJAX Request" src="//codepen.io/zingchart/embed/de8544d3f634ae7c88144b3b237f19c0/?height=500&amp;theme-id=dark,result&amp;embed-version=2" frameborder="no" allowtransparency="true" allowfullscreen="true" style="width: 100%;">See the Pen <a href='https://codepen.io/zingchart/pen/de8544d3f634ae7c88144b3b237f19c0/'>REST API AJAX Request</a> by ZingChart (<a href='https://codepen.io/zingchart'>@zingchart</a>) on <a href='https://codepen.io'>CodePen</a>.</iframe>


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
