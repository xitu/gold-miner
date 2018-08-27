> * 原文地址：[A Quick Introduction to Functional Javascript](https://hackernoon.com/a-quick-introduction-to-functional-javascript-7e6fe520e7fa)
> * 原文作者：[Angelos Chalaris](https://hackernoon.com/@chalarangelo?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-quick-introduction-to-functional-javascript.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-quick-introduction-to-functional-javascript.md)
> * 译者：
> * 校对者：

# A Quick Introduction to Functional Javascript

**Functional programming** is one of the hottest trends right now and there’s a lot of good arguments about why one might want to utilize it in their code. I’m not going to go into a lot of detail about all of the concepts and ideas of functional programming here, however I will try to provide a demonstrative guide of how to use functional programming in everyday situations involving **Javascript**.

![](https://cdn-images-1.medium.com/max/2000/1*w91eh65v6nxTs2AhLhyRNA.jpeg)

> Functional programming is a programming paradigm that treats computation as the evaluation of mathematical functions and avoids changing-state and mutable data.

#### Redefining functions

Before we get into the nitty-gritty of Javascript’s functional programming paradigm, it’s important to understand what a **higher-order function** is, why it’s useful and the implications stemming from this definition. A higher-order function can take a function as an argument or return one as a result. You should always remember that **functions are values**, meaning you can pass them around, much like you can do with variables.

So for example, in Javascript, you can do this:

```
// Create a function.
function f(x){
  return x * x;
}
// Use the function.
f(5); // 25

// Create an anonymous function and assign 
// it to a variable.
var g = function(x){
  return x * x;
}
// Now you can pass the function around.
var h = g;
// And use it
h(5); // 25
```

Using a function as a value

Using the technique showcased above, you can make your code more reusable, while gaining more versatility. We’ve all been in situations where we wished we could pass a function to some other function to execute a task, but we had to write some code to work around this problem, right? Using functional programming, you won’t need any more workarounds and you can make your code significantly cleaner and easier to read.

* [**Why functional programming matters**: Why testing for functional programming skills at software developer interviews is good for your business_](https://hackernoon.com/why-functional-programming-matters-c647f56a7691)

The only catch is that _proper_ functional code is characterized by the **absence of side-effects**, meaning that functions should rely solely on their arguments as input and they should not affect their environment in any way, meaning you should not use or alter anything outside the function itself. This, however, has some important implications, such as the fact that a function will always return the same output provided the same input and the fact that, if the result of a functional call is not used, it can be removed without causing any other changes in the code.

* * *

#### Using the array prototype’s built-in methods

`[Array.prototype](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/prototype)` is where you should start when getting into functional programming in Javascript. It contains a plethora of useful methods for **applying transformations to arrays**, which is a very common use-case scenario in most modern applications.

* [**Array.prototype**: The Array.prototype property represents the prototype for the Array constructor and allows you to add new properties…_](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/prototype)

Starting with `[Array.prototype.sort()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/sort)` seems like a good idea, as this is a pretty straightforward transformation, which, unsurprisingly, you can use to **sort an array**. `.sort()` only takes one argument, a function that is used to compare two elements, returning a value below zero if the first one should go before the second one or a value above zero if the opposite is true.

Sorting sounds very simple, until you run into a scenario where you need to compare something more complex than your usual numbers array. For this example, we will have an array of objects, the weights of which are either in pounds (_lbs_) or kilograms (_kg_) and we need to sort them in ascending order based on weight. Let’s look what this would look like:

```
// Definition of our comparison function.
var sortByWeight = function(x,y){
  var xW = x.measurement == "kg" ? x.weight : x.weight * 0.453592;
  var yW = y.measurement == "kg" ? y.weight : y.weight * 0.453592;
  return xW > yW ? 1 : -1;
}

// Just two slightly different lists of data,
// that need to be sorted based on weight.
var firstList = [
  { name: "John", weight: 220, measurement: "lbs" },
  { name: "Kate", weight: 58, measurement: "kg" },
  { name: "Mike", weight: 137, measurement: "lbs" },
  { name: "Sophie", weight: 66, measurement: "kg" },
];
var secondList = [
  { name: "Margaret", weight: 161, measurement: "lbs", age: 51 },
  { name: "Bill", weight: 76, measurement: "kg", age: 62 },
  { name: "Jonathan", weight: 72, measurement: "kg", age: 43 },
  { name: "Richard", weight: 74, measurement: "kg", age: 29 },
];

// Using the sorting function we defined to
// sort both lists.
firstList.sort(sortByWeight); // Kate, Mike, Sophie, John 
secondList.sort(sortByWeight); // Jonathan, Margaret, Richard, Bill
```

An example of using functional programming to sort two arrays

In the above example, you can clearly see how using a higher-order function can save you space, time and make your code easier to read and more reusable. If you were to write this without using `.sort()`, you would have to write two loops and repeat the logic for the most part, resulting in longer, bloated and frankly less understandable code.

* * *

Sorting isn’t the only thing you do often in a array. In my experience, f**iltering an array** based on a property is pretty common and what better way to filter an array than `[Array.prototype.filter()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/filter)`. Filtering is not difficult, as you only need to pass a function as an argument, which will return `false` for any items that need to be filtered out, otherwise it will return `true`. Simple, right? Let’s see it in practice:

```
// An array of people.
var myFriends = [
  { name: "John", gender: "male" },
  { name: "Kate", gender: "female" },
  { name: "Mike", gender: "male" },
  { name: "Sophie", gender: "female" },
  { name: "Richard", gender: "male" },
  { name: "Keith", gender: "male" }
];

// A simple filter based on gender.
var isMale = function(x){
  return x.gender == "male";
}

myFriends.filter(isMale); // John, Mike, Richard, Keith
```

A simple example of filtering

While `.filter()` returns all the elements in the array that match a condition, you can also use `[Array.prototype.find()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/find)` to get only the first element in the array that matches a condition or `[Array.prototype.findIndex()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/findIndex)` to get the first matched element’s index in the array. Similarly, you can use `[Array.prototype.some()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/some)` to test if at least one element matches a provided condition and `[Array.prototype.every()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/every)` to see if all elements of the array match a condition. These can be particularly useful in some kinds of applications, so let’s have a look at an example using a combination of these methods:

```
// An array of high scores. Notice that some
// of them don't have a name specified.
var highScores = [
  {score: 237, name: "Jim"},
  {score: 108, name: "Kit"},
  {score: 91, name: "Rob"},
  {score: 0},
  {score: 0}
];

// Simple reusable functions that check if
// an item has a name or not and if an item
// has a score larger than zero.
var hasName = function(x){
  return typeof x['name'] !== 'undefined';
}
var hasNotName = function(x){
  return !hasName(x);
}
var nonZeroHighScore = function(x){
  return x.score != 0;
}

// Fill in the blank names until none exist.
while (!highScores.every(hasName)){
  var highScore = highScores.find(hasNotName);
  highScore.name = "---";
  var highScoreIndex = highScores.findIndex(hasNotName);
  highScores[highScoreIndex] = highScore;
}

// Check if non-zero scores exist and print
// them out.
if (highScores.some(nonZeroHighScore))
  console.log(highScores.filter(nonZeroHighScore));
else 
  console.log("No non-zero high scores!");
```

Using functional programming to structure data

At this point everything should start coming together. In the above example, you can clearly see how higher-order functions spared you a lot of repetitive and difficult to understand code. Even in this very simple example, you can see how legible the code is, in contrast to what you would write if you didn’t use the functional programming paradigm.

* * *

Taking a step back from the complex logic of the previous example, we sometimes want to just **transform an array to a different one** with more or less fields, without altering the data all that much. Here’s where `[Array.prototype.map()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/map)` comes in, allowing us to transform the objects in an array. The difference between `.map()` and the previous methods is that the higher-order function that it uses as its argument should return an object, which can be pretty much anything you want. Let me demonstrate with a simple example:

```
// An array of objects.
var myFriends = [
  { name: "John", surname: "Smith", age: 52},  
  { name: "Sarah", surname: "Smith", age: 49},  
  { name: "Michael", surname: "Jones", age: 46},  
  { name: "Garry", surname: "Thomas", age: 48}
];

// A simple function to get just the name and
// surname in one string.
var fullName = function(x){
  return x.name + " " + x.surname;
}

myFriends.map(fullName);
// Should output
// ["John Smith", "Sarah Smith", "Michael Jones", "Garry Thomas"]
```

Mapping the objects of an array

In the above example, by applying `.map()` to our array, we easily got an array, the objects of which only contain the desired properties. In this case we only wanted the string representation of the objects’ `name` and `surname` fields, thus we created an array of strings from an array of objects, using a simple mapping. Mapping is more common than you might think and it can be a very powerful tool in every web developer’s arsenal, so if there’s one takeaway from this article is that you should learn how to use `.map()`.

* * *

Last, but definitely not least, you should pay attention to the **general-purpose array transformation** that is `[Array.prototype.reduce()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/reduce)`. `.reduce()` is slightly different from all the other methods mentioned above, as it uses a higher-order function as its argument, as well as an **accumulator**. This might sound a little bit confusing at first, so an example should help you grasp the basic idea behind `.reduce()`:

```
// Arrays of expenses.
var oldExpenses = [
  { company: "BigCompany Co.", value: 1200.10},
  { company: "Pineapple Inc.", value: 3107.02},
  { company: "Office Supplies Inc.", value: 266.97}
];
var newExpenses = [
  { company: "Office Supplies Inc.", value: 108.11},
  { company: "Megasoft Co.", value: 1208.99}
];

// Simple summation function
var sumValues = function(sum, x){
  return sum + x.value;
}

// Reducing the first array to a sum of values.
var oldExpensesSum = oldExpenses.reduce(sumValues, 0.0);
// Reducing the second array to a sum of values.
console.log(newExpenses.reduce(sumValues, oldExpensesSum)); // 5891.19
```

Reducing arrays to sums

The above example should not be particularly confusing to anyone who has ever had to sum the values of an array. We first define a reusable higher-order function that we use to sum the values of each array. Then, we actually use this function to sum the values of the first array and then, using the already accumulated value of the first array’s sum as our starting value, we feed this sum to the second array summation function, so that all values in the second array will be added to that, instead of zero.

* [**Reduce (Composing Software)**: Note: This is part of the “Composing Software” series on learning functional programming and compositional software…](https://medium.com/javascript-scene/reduce-composing-software-fe22f0c39a1d)

Of course, `.reduce()` can do a whole lot more than just adding up the values in an array. Most **complex transformations** that do not fit into any of the other methods can be easily implemented with `.reduce()` and an array or object accumulator. A practical example would be transforming an array of articles, each with a title and some tags into an array of tags, each with its article count and the array of said articles. Let’s see what this would look like:

```
// An array of articles with their tags.
var articles = [
  {title: "Introduction to Javascript Scope", tags: [ "Javascript", "Variables", "Scope"]},
  {title: "Javascript Closures", tags: [ "Javascript", "Variables", "Closures"]},
  {title: "A Guide to PWAs", tags: [ "Javascript", "PWA"]},
  {title: "Javascript Functional Programming Examples", tags: [ "Javascript", "Functional", "Function"]},
  {title: "Why Javascript Closures are Important", tags: [ "Javascript", "Variables", "Closures"]},
];

// A function that reduces the above array to an
// array based on tags.
var tagView = function(accumulator, x){
  // For every tag in the article's tag array
  x.tags.forEach(function(currentTag){
    // Create a function to check if it matches
    var findCurrentTag = function(y) { return y.tag == currentTag; };
    // Check if it's already in the accumulator array
    if (accumulator.some(findCurrentTag)){
      // Find it and get its index
      var existingTag = accumulator.find(findCurrentTag);
      var existingTagIndex = accumulator.findIndex(findCurrentTag);
      // Update the number and array of articles
      accumulator[existingTagIndex].count += 1;
      accumulator[existingTagIndex].articles.push(x.title);
    }
    // Otherwise add the tag to the accumulator array
    else {
      accumulator.push({tag: currentTag, count: 1, articles: [x.title]});
    }
  });
  // Return the accumulator array
  return accumulator;
}

// Transform the original array
articles.reduce(tagView,[]);
// Output:
/*
[
 {tag: "Javascript", count: 5, articles: [
    "Introduction to Javascript Scope", 
    "Javascript Closures",
    "A Guide to PWAs", 
    "Javascript Functional Programming Examples",
    "Why Javascript Closures are Important"
 ]},
 {tag: "Variables", count: 3, articles: [
    "Introduction to Javascript Scope", 
    "Javascript Closures",
    "Why Javascript Closures are Important"
 ]},
 {tag: "Scope", count: 1, articles: [ 
    "Introduction to Javascript Scope" 
 ]},
 {tag: "Closures", count: 2, articles: [
    "Javascript Closures",
    "Why Javascript Closures are Important"
 ]},
 {tag: "PWA", count: 1, articles: [
    "A Guide to PWAs"
 ]},
 {tag: "Functional", count: 1, articles: [
    "Javascript Functional Programming Examples"
 ]},
 {tag: "Function", count: 1, articles: [
    "Javascript Functional Programming Examples"
 ]}
]
*/
```

Using reduce() to apply a complex transformation

The above example might seem slightly more complicated than it is, so let’s break it down. First off, we want to get an array as our final result, thus our accumulator’s starting value will be `[]`. Then, we want each object in the array to contain the name of the tag, the count and the actual list of articles. We also know that each tag must appear only once in the array, so we will have to check if it exists using `.some()`, `.find()` and `.findIndex()` like before to transform the existing tag’s object instead of adding a new one.

The tricky part here is that we cannot define a function to check if each one of the tags exists (otherwise we need 7 different functions), so we define our higher-order function inside the loop for the current tag. That way we can reuse it and we avoid rewriting code. Note that this can also be accomplished by currying, but I will not explain this technique in this article.

* [**Currying in the real world**: When I started to learn functional programming, I learned a lot of interesting concepts. But I was wondering where I…](https://hackernoon.com/currying-in-the-real-world-b9627d74a554)

After we get the tag’s object in the accumulator array, we need only increment its count and add the current article to its array of articles. Finally, we return the accumulator and that’s pretty much all there is to it. The code is pretty short and quite easy to understand after reading it carefully, while the corresponding non-functional code would be a very confusing and significantly longer mess.

#### In conclusion

Functional programming is one of the hottest trends right now and for a good reason. It allows us to write cleaner, leaner and meaner code without having to worry about side-effects and changing-state. Javascript’s `[Array.prototype](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/prototype)` methods are really useful in many everyday situations and allow us to apply simple and complex transformations to arrays without repeating ourselves.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
