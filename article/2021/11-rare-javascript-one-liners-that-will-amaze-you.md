> * 原文地址：[11 Rare JavaScript One-Liners That Will Amaze You](https://betterprogramming.pub/11-rare-javascript-one-liners-that-will-amaze-you-331659832301)
> * 原文作者：[Can Durmus](https://medium.com/@candurmuss)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/11-rare-javascript-one-liners-that-will-amaze-you.md](https://github.com/xitu/gold-miner/blob/master/article/2021/11-rare-javascript-one-liners-that-will-amaze-you.md)
> * 译者：
> * 校对者：

# 11 Rare JavaScript One-Liners That Will Amaze You

#### Because who doesn’t love to build things with just a single line

![Source: [Pexels](https://www.pexels.com/photo/blue-eyed-man-staring-at-the-mirror-54377/)](https://cdn-images-1.medium.com/max/8576/1*-0ag6JFjkLmmXTJVVZPVmA.jpeg)

What is the thing you do if you want to impress a professional developer? It’s simple: Solve a complex problem with simple logic and as few lines of code as possible. With the introduction of ES6 arrow functions, it is possible to create one-liners that look elegant and simple.

In this article, you will learn 11 one-liners that are kind of rare to find, yet so powerful. Then, get ready, and let’s start with the first one!

## 1. Get the Character Count In A String

Getting character count is a useful utility and can be useful in many scenarios. You can use it to get the count of spaces and subsequently count of words, or this can be used to get the count of a certain separator in a string.

![](https://cdn-images-1.medium.com/max/2412/1*4JTq7Wv6G1Tu0GUkHjJqNA.png)

```
const characterCount = (str, char) => str.split(char).length - 1
```

The idea is completely simple. We split the string using the passed parameter `char` and get the length of the returning array. As every time the string is split, there will be one piece more than the splitter; so 1 is subtracted and there we have a `characterCount` one-liner.

## 2. Check if an Object Is Empty

Checking the emptiness of an object is actually way harder than it seems. Checking if an object is equal to `{}` will return false every time even though the object is empty.

Fortunately, the one-liner below does exactly what we want.

![](https://cdn-images-1.medium.com/max/3100/1*raLs5fvNEPlEUQnU4z-Chw.png)

```
const isEmpty = obj => Reflect.ownKeys(obj).length === 0 && obj.constructor === Object
```

In this one-liner, we check if the length of the keys of the object is equal to zero and if the parameter passed is an actual object.

## 3. Wait for a Certain Time Before Execution

In this one-liner, we will get our hands dirty with some asynchronous programming. The idea is simple. While running code, if you want to wait for a certain amount of time, here is the `wait` one-liner:

![](https://cdn-images-1.medium.com/max/3448/1*zED3kVo1HB1p-rMsEB-rbw.png)

```
const wait = async (milliseconds) => new Promise((resolve) => setTimeout(resolve, milliseconds));
```

In `wait` one-liner, we create a promise and resolve it after the given amount of time using `setTimeout` function.

## 4. Get The Day Difference Between Two Dates

While developing web apps, date is generally the most confusing part to implement because there are many concepts that could be easily miscalculated.

Here is a powerful one-liner to calculate the day difference between two dates. But there is more to go. As I did, you can create your own one-liner to calculate month, year difference, etc.

![](https://cdn-images-1.medium.com/max/3416/1*pWjSKnUvpmNYGi2F7VZWLQ.png)

```
const daysBetween = (date1, date2) => Math.ceil(Math.abs(date1 - date2) / (1000 * 60 * 60 * 24))
```

The logic behind this one-liner is pretty easy to understand. When two dates are subtracted, the return value is the difference in milliseconds. To convert the milliseconds to days, we have to divide it by milliseconds, seconds, minutes, and hours one by one.

## 5. Redirect to Another URL

If you ever created a real-life website, I’m pretty sure you encountered authentication logic. For instance, a non-admin user shouldn’t be able to access `/admin` route. If the user tries, then you have to redirect it to another URL.

This one-liner is exactly for the situation I mentioned above but I think you can find many more use cases for this one.

![](https://cdn-images-1.medium.com/max/2000/1*Ab_JYkkPUZ1wdOksFFqGZQ.png)

```
const redirect = url => location.href = url
```

`location` is a method on global `window` object and the behavior of setting `href` property is the same as a user clicking link.

## 6. Check for Touch Support On Device

As the devices that can connect to the internet gets more and more, the necessity of creating responsive websites increases. 20 years ago, the developer should have thought about the desktop version of the website but today more than 50% of the web traffic comes from touch devices. So, taking some actions based on the touch support of the device is such an important concept.

![](https://cdn-images-1.medium.com/max/4056/1*hCg1ziRq2M2JniqKfc2sBA.png)

```
const touchSupported = () => ('ontouchstart' in window || DocumentTouch && document instanceof DocumentTouch)
```

In this one-liner, we are checking whether the document has `touchstart` event supported or not.

## 7. Insert a String of HTML After An Element

Developing web apps, it’s such a common thing to update the DOM using JavaScript. There are some basic methods to get things done but when the situation gets complex, it can be hard to overcome.

Here is a one-liner to inject a string of HTML right after an HTML element. With a few minutes of thinking and Googling, I’m sure you can find the **before** version of this one-liner.

![](https://cdn-images-1.medium.com/max/2840/1*52MWqa-s4AMOMSKOIqgODw.png)

```
const insertHTMLAfter = (html, el) => el.insertAdjacentHTML('afterend', html)
```

## 8. Shuffle An Array

Shuffling a set of data in development is a common situation that you can encounter anytime and unfortunately, there is no `shuffle` method built-in arrays in JavaScript.

However, here is a `shuffle` one-liner that you can use daily:

![](https://cdn-images-1.medium.com/max/2336/1*__MeJCilbgX-QPSqpquOYQ.png)

```
const shuffle = arr => arr.sort(() => 0.5 - Math.random())
```

It utilizes the `sort` method of arrays and randomly sorts before or after the previous element of the array.

## 9. Get Selected Text On Webpage

Browsers have a built-in method named `getSelection` on global `windows` object. Using this method, you can create a one-liner that returns the highlighted or selected text on a webpage.

![](https://cdn-images-1.medium.com/max/2840/1*HKml5QxPBuZWWymaNC26GQ.png)

```
const getSelectedText = () => window.getSelection().toString()
```

## 10. Get a Random Boolean

While programming, especially if you’re coding games, there are some times that you’d want to take action randomly. In these kinds of cases, the one-liner below comes very handy.

![](https://cdn-images-1.medium.com/max/2080/1*xpI9zORD0YwiQwtd1Qr_0w.png)

```
const getRandomBoolean = () => Math.random() >= 0.5
```

The one-liner above has a 50/50 chance of returning `true` or `false`. Because the probability that the generated random number is greater than 0.5 is equal to the probability of being smaller.

However, for instance, if you want to get a random Boolean with a probability of 70% `false`, then you can simply change 0.5 to 0.7 and so on.

## 11. Calculate the Average of An Array

The average of an array can be calculated using many ways. But the logic is the same for all. You have to get the sum of the array and its length; then the division gives the average.

![](https://cdn-images-1.medium.com/max/2652/1*z2pUB4_rZKS7vfbW4YDubw.png)

```
const average = (arr) => arr.reduce((a, b) => a + b) / arr.length
```

In the `average` one-liner, we use reduce to get the sum of the array in one line rather than using a loop. Then, we divide it by array length and this is the average of an array.

---

That’s it, everyone! Now you know 11 simple yet powerful JavaScript one-liners. I tried to choose the ones that are not quite popular and well-known so that you can learn new things. I use all of them on a daily basis, and I think you will, too.

Thank you for reading. If you liked it, make sure you clap, and if you have anything to say about the article, leave a response. See you in the next article.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
