> * 原文地址：[Tutorial: Building a D3.js Calendar Heatmap (to visualize StackOverflow Usage Data)](https://blog.risingstack.com/tutorial-d3-js-calendar-heatmap/)
> * 原文作者：[matehusz](https://blog.risingstack.com/author/matehusz/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/tutorial-d3-js-calendar-heatmap-(to-visualize-StackOverflow-Usage-Data).md](https://github.com/xitu/gold-miner/blob/master/article/tutorial-d3-js-calendar-heatmap-(to-visualize-StackOverflow-Usage-Data).md)
> * 译者：
> * 校对者：

# Tutorial: Building a D3.js Calendar Heatmap (to visualize StackOverflow Usage Data)
> Let's take a look at StackOverflow’s usage statistics by creating an interactive calendar heatmap using D3.js!

Wakey, wakey, welcome everyone to my next D3.js tutorial!

**Today we’re going to take a look at StackOverflow’s usage statistics by creating an interactive calendar heatmap using D3.js!**

![https://blog.risingstack.com/content/images/2019/05/d3js-interactive-calendar-heatmap-animated.gif](https://blog.risingstack.com/content/images/2019/05/d3js-interactive-calendar-heatmap-animated.gif)

This calendar heatmap shows the numbers of answers posted to StackOverflow in an interactive way, therefore it will allow us to make assumptions about the site's popularity and several insights into it's users behaviors.

- -

In the previous installment of this blogpost series, we checked the **[most loved programming languages on bar charts made with D3.js,](https://blog.risingstack.com/d3-js-tutorial-bar-charts-with-javascript/)** gathered by StackOverflow’s survey.

Let’s stick with StackOverflow in this post as well because they expose a cozily reachable API to their **[data source](https://data.stackexchange.com/)**.

**We’re going to answer the following questions:**

- Is StackOverflow’s popularity still unrivaled?
- How active is the community around it?
- What would be an ideal data source and how should I process it?

Well, let’s see how far I can get by creating a calendar heatmap with D3.js.

## **Sounds cool but what’s a calendar heatmap?**

I believe the common ground with my readers is that we all have met GitHub at some point in our lives. If that’s the case, you are already familiar with this chart aka your contribution chart.

![https://blog.risingstack.com/content/images/2019/05/calendar-heatmap-built-with-d3js-like-github.png](https://blog.risingstack.com/content/images/2019/05/calendar-heatmap-built-with-d3js-like-github.png)

It displays your daily contribution (commits, pull requests, etc.) in the past year. Generally, a calendar heatmap comes handy when you want to display values over a longer period.

## **Let’s get started with building our D3.js chart.**

We’re going to build on some of the concepts which have already been introduced in the last article. If you’re new to D3.js, take a look at the previous **[post](https://blog.risingstack.com/d3-js-tutorial-bar-charts-with-javascript/)** where I covered the basics of SVGs, DOM manipulation with d3, scaling, etc.

## **Extracting the data from StackOverflow for our Calendar Heatmap**

I wrote a SQL query that fetches all daily posted answers on StackOverflow over a period.

```
SELECT FORMAT(DATEADD(DAY, -DATEDIFF(DAY, CreationDate, GETDATE()), GETDATE()), 'yyyy-MM-dd'),
COUNT(*) AS 'AnswerCount' FROM Posts
WHERE PostTypeId = 2 /* question = 1, answer = 2 */AND CreationDate > '2010-04-01'
GROUP BY DATEDIFF(DAY, CreationDate, GETDATE())

```

The next step was to export it in a CSV file and convert it to JSON format. I used the **[csvtojson](https://www.npmjs.com/package/csvtojson)** NPM library and ended up with the following format:

```
{"date":"2015-12-20","value":"19"},
{"date":"2015-12-21","value":"18"},
{"date":"2015-12-22","value":"25"},
{"date":"2015-12-23","value":"28"},

```

I always maintain a sequential series of data that carries information about the value of the domain on a specific day. It’s important to abstract the code logic from the domain, so the functionality stays reusable and does not require refactoring to work on other data sources.

## **Time Travel in D3.js**

JavaScript has its nuances when it comes to **[Date](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date)** objects.

For example:

- You have to number the months starting from zero when you want to create a `new Date(2019, 3, 15) // 2019-04-15`;
- The display format depends on the user machine’s settings and geographical location;
- The date object does not support time zones, only time zone offsets that might change due to daylight saving mode.

I bumped to the daylight saving problem myself which resulted in displaying two identical days because of the daylight saving mode.

To overcome this problem we’re using **[d3-time](https://github.com/d3/d3-time)** library that eases the pain coming from time zones, leap years or daylight saving mode. I convert all my Date objects to D3.js’s own wrapper around native Date objects.

## **Grouping Data Values**

We have a list of date and value pairs that we would like to display year by year. I would like some kind of data structure that holds all the values for all years. D3’s **[collection](https://github.com/d3/d3-collection)** library has the right tool for us.

```
const years = d3.nest()
   .key(d => d.date.getUTCFullYear())
   .entries(dateValues)
   .reverse()

```

The `nest` function transforms the input list based on the `key` function. We get a list of objects that include `key` and the corresponding `values`. `entries` take the data source I want to group.

In our case, the year is the `key` and all the date and value pairs in a year are the `values`.

## **Drawing the days in our calendar heatmap**

Now as the input is ready, we can start drawing. Each day will be demonstrated as a rectangle, but before that, we need to define a few helper functions.

First, we need to decide whether we would like Sunday or Monday to be the starting point of the week. I’m creating a Monday based calendar in this example.

Also, I define a function to get the name of the day based on the index of the day on a week. To get the index of a day, I’m using `getUTCDay()`.

Besides these functions, there are a few initial values for sizing the rectangles and groups.

```
const cellSize = 15
const yearHeight = cellSize * 7 + 25
const formatDay = d => ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"][d.getUTCDay()]
const countDay = d => d.getUTCDay()
const timeWeek = d3.utcSunday
const formatDay = ...

```

Now let’s append a group for each year we would like to display. These groups are the “containers” of the days.

```
const year = group.selectAll('g')
   .data(years)
   .join('g')
   .attr('transform', (d, i) => `translate(40, ${yearHeight * i + cellSize * 1.5})`

```

The `transform` attribute sets the offset of the group to be 40 on the left side and the `y` coordinate is calculated based on the height of the `cellSize`.

For each group, I append a caption displaying the year.

```
year.append('text')
   .attr('x', -5)
   .attr('y', -30)
   .attr("text-anchor", "end")
   .attr('font-size', 16)
   .attr('font-weight', 550)
   .attr('transform', 'rotate(270)')
   .text(d => d.key);

```

Remember, the `.text(d => d.key)` refers to the nested array which groups the values under a year category.

Like what you read? Help us reach others! Thanks. :)

> Another week, another long-form tutorial on the RisingStack blog! This time we're teaching how you can create a Github-like Calendar Heatmap with @d3js_org. To make it interesting, we're visualizing @StackOverflow usage statistics.Take a look:https://t.co/AHdhgj4O67 pic.twitter.com/DkdSU9rwnE— RisingStack ? Node.js, K8S & Microservices (@RisingStack) May 8, 2019

I want to show the names of the days on the left side of the calendar.

```
 year.append('g')
   .attr('text-anchor', 'end')
   .selectAll('text')
   .data(d3.range(7).map(i => new Date(1999, 0, i)))
   .join('text')
   .attr('x', -5)
   .attr('y', d => (countDay(d) + 0.5) * cellSize)
   .attr('dy', '0.31em')
   .text(formatDay);

```

Now, here comes the essence of the calendar. One rectangle stands for each day that represents a value.

```
year.append('g')
   .selectAll('rect')
   .data(d => d.values)
   .join('rect')
   .attr("width", cellSize - 1.5)
   .attr("height", cellSize - 1.5)
   .attr("x", (d, i) => timeWeek.count(d3.utcYear(d.date), d.date) * cellSize + 10)
   .attr("y", d => countDay(d.date) * cellSize + 0.5)

```

Okay, let’s take a step back, and break down what the code does:

1. Append a `group` for each year;
2. Select all `rect` in this group;
3. Bind input data to rectangles;
4. Create a rectangle for each piece of data that need to be appended;
5. Set `width` and `height`;
6. Calculate the `x` coordinate which depends on the week count;
7. Set the `y` coordinate based on the index of the day on a week.

The result is the following black & white beauty.

![https://blog.risingstack.com/content/images/2019/05/d3js-calendar-heatmap-in-black-and-white.png](https://blog.risingstack.com/content/images/2019/05/d3js-calendar-heatmap-in-black-and-white.png)

## **Adding Color & Legend to the Heatmap**

Shake things up a little, let’s bring in some colors and also add a legend!

Did I mention how D3 has the right tool for a bunch of problems? For instance, if I would spend my whole day choosing the right colors for every piece of square this post would never end up in the blog. Instead, I am using **[d3-scale-chromatic](https://github.com/d3/d3-scale-chromatic)** that can generate color on a palette scheme by providing it a value between 0 and 1.

I’m feeling more comfy with this solution, but if you want to manipulate colors in the browser, there’s a library for that too! See **[d3-color](https://github.com/d3/d3-color)** in case you want to convert, fade, brighten, etc colors.

Introducing this feature to the code:

```
const colorFn = d3.scaleSequential(d3.interpolateBuGn).domain([
   Math.floor(minValue),
   Math.ceil(maxValue)
 ])

```

I create a helper function to color as well so it’s easier to change it later. I pass the min and max values of the domain so the function can determine a number between 0 and 1 based on the actual domain value. Then I call `.attr("fill", d => colorFn(d.value))` on the drawn rectangles.

![https://blog.risingstack.com/content/images/2019/05/colors-added-to-d3js-calendar-heatmap.png](https://blog.risingstack.com/content/images/2019/05/colors-added-to-d3js-calendar-heatmap.png)

Moving on to the legend. I would like to indicate what ranges the different color tones mean.

First, I append a new legend group and move it to the end of the years.

```
 const legend = group.append('g')
   .attr('transform', `translate(10, ${years.length * yearHeight + cellSize * 4})`)

```

Then I divide the range between the min and max value into equal parts. Also, I generate a color for each using the defined `colorFn` utility function.

```
const categoriesCount = 10;

const categories = [...Array(categoriesCount)].map((_, i) => {
   const upperBound = maxValue / categoriesCount * (i + 1);
   const lowerBound = maxValue / categoriesCount * i;

   return {
     upperBound,
     lowerBound,
     color: d3.interpolateBuGn(upperBound / maxValue)
   };
 });

```

Next step is to draw a rectangle for each category that we just created.

```
legend
   .selectAll('rect')
   .data(categories)
   .enter()
   .append('rect')
   .attr('fill', d => d.color)
   .attr('x', (d, i) => legendWidth * i)
   .attr('width', legendWidth)
   .attr('height', 15)

```

Adding labels is more of a copy paste job, so I just assume you’re already familiar with it. If not, here’s the link to the **[code](https://gist.github.com/matehuszarik/b1a8004c52334d8efcd0f9aaad195cf9)**.

![https://blog.risingstack.com/content/images/2019/05/calendar-heatmap-interactive-selector.png](https://blog.risingstack.com/content/images/2019/05/calendar-heatmap-interactive-selector.png)

## **Adding Interactivity to the Heatmap**

Now as the image already indicates I’m going to add some interactivity to the chart. I would like to hide/display specific squares on the chart depending on their category.

What is the point? - You may ask. Well, I’m looking for patterns on the SVG that can help me find characteristics in StackOverflow’s usage.

Are there specific days with outstanding values?Which year has the most active days?

Let the investigation begin.

## **D3.js Data Binding**

Now, to get these answers, we need to visit the topic of data binding first. D3 is not only a DOM manipulation library but also has a data binding mechanism underneath.

This is how it works:

Whenever I assign a `datum()` or `data()` to a specific element, I have the opportunity to define a key function as a second parameter. This function can help to find a specific piece of data with a specific HTML/SVG element.

I create a `toggle` function that handles whenever the user clicks on one of the range values.

```
function toggle(legend) {
   const { lowerBound, upperBound, selected } = legend;

   legend.selected = !selected;

   const highlightedDates = years.map(y => ({
     key: y.key,
     values: y.values.filter(v => v.value > lowerBound && v.value <= upperBound)
   }));

   year.data(highlightedDates)
     .selectAll('rect')
     .data(d => d.values, d => d.date)
     .transition()
     .duration(500)
     .attr('fill', d => legend.selected ? colorFn(d.value) : 'white')
 }

```

I add this function to the legend group by calling `.on('click', toggle)`.

First I mark if the selected legend is `selected` or not. Based on this boolean value, I can change the color of the assigned rectangles.

What is more interesting in this example is how the data binding and update work. First, I subselect values that fit in the clicked range into the `highlightedDates` variable. Then, I pass it in the `.data(d => d.values, d => d.date)` function.

Notice the second parameter. This is the key function that helps d3 decide which element it should update. All elements that are appended based on data have a `__data__` property that holds the assigned value. The key function identifies the one matching and I can decide whether to execute `update`, `enter` or `exit` operations. I’m going to change the attributes of the elements so I’m using the update operation.

I’m not gonna write about `enter` or `exit` now but if you want to know more, read this great **[article](https://bost.ocks.org/mike/selection/#enter-update-exit)** by Mike Bostock, the creator of d3.

Back to the code example.

On user click, I filter all the data within the range and look for all the elements that match the data based on the key function. Then, I update their attribute by calling the `transition()` function and delay it by 500 milliseconds. Finally, I set the color by calling the `colorFn` or if not selected set it white.

## **Understanding our Calendar Heatmap**

Once we have finished that we can have a look at all the historical data in the past 10 years and decide whether StackOverflow is still as beloved as a few years ago.

I’m interested in the peak usage of the site, so I just start hiding the days starting with the lowest range.

![https://blog.risingstack.com/content/images/2019/05/d3js-interactive-calendar-heatmap-animated.gif](https://blog.risingstack.com/content/images/2019/05/d3js-interactive-calendar-heatmap-animated.gif)

By hiding all daily post counts that are under ~10800 we get a clear result.

**2013, 2014 and parts of 2015 and 2016 have the most answered questions on the site. So the community was the most active in these years.**

It’s interesting to see that by hiding the ranges one by one, 2010 is the first one to disappear. It is one of the early years of StackOverflow as the site was created in 2008. Its popularity skyrocketed and reached its peak usage in 2013-14. Since then, there’s a slight decrease.

This does not necessarily mean the end of an era just yet. A possible reason for this downturn is that commonly occurring problems are all answered. StackOverflow is still the number one place to go when you’re bumping your head into the keyboard.

Also, not a surprise but Saturdays and Sundays are the most inactive days. However, the past years got my attention. Mondays and Fridays got lazy.

Hello there three day work week!

![https://blog.risingstack.com/content/images/2019/05/busy-days-of-stackoverflow-based-on-calendar-heatmap.png](https://blog.risingstack.com/content/images/2019/05/busy-days-of-stackoverflow-based-on-calendar-heatmap.png)

Enough of silly me, I’m just making assumptions on a green field.

Jokes aside, building a calendar heatmap is a really effective way to analyze a time series of data. My guesses might be incorrect but I just wanted to show you a few examples that can be extracted with very little effort supported with a spectacular visual experience.

## **Conclusions of building our D3.js Calendar Heatmap**

In this tutorial, I introduced you a use case for calendar heatmap and investigated the daily usage of StackOverflow based on the daily posted answers.

We have gone through the steps to prepare the input data, created the chart with D3 and done some deductions based on the result.

Thanks for your attention and here’s your link to the **[source code](https://gist.github.com/matehuszarik/b1a8004c52334d8efcd0f9aaad195cf9)**!

Have you noticed any other anomalies on the chart? Drop a comment!

If you have a D3 project and you're in need of help, feel free to ping us using **[this form](https://rstck.typeform.com/to/PbubEn)**, or simply drop a mail to `info@risingstack.com`!
> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
