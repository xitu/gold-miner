> * 原文地址：[What is the State of jQuery in 2021?](https://javascript.plainenglish.io/jquery-7be2b63d720e)
> * 原文作者：[Louis Petrik](https://medium.com/@louispetrik)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/so-whats-the-state-of-jquery-in-2021.md](https://github.com/xitu/gold-miner/blob/master/article/2021/so-whats-the-state-of-jquery-in-2021.md)
> * 译者：
> * 校对者：

# What is the State of jQuery in 2021?

![Source: [pixabay.com](https://pixabay.com/de/photos/technologie-computer-code-1283624/)](https://cdn-images-1.medium.com/max/3840/1*Tc90FhOr8U4x04kzqguVuA.jpeg)

Normal people think of nostalgia as old photos, music, or places. 
On the other hand, I have been using jQuery today — after all these years & many projects. The library appeared in 2006, many years before React, Vue, and even Angular.js.

jQuery was once the linchpin of the JavaScript world. It made developing dynamic web apps much easier for us. Especially when it comes to DOM manipulation and network requests, jQuery is more straightforward.

But what about now, with the classic library? What has changed, who still uses it, and what about its popularity? Here are the answers.

## So, what’s new in jQuery?

I made an effort: I went back to 2016 on the official jQuery blog page and looked to see what changes were noted.

The answer: To be honest, not much has happened. Yes, there are many changes with jQuery 3 — but none of them are really that noteworthy. There hasn’t been an update like the introduction of hooks in React.js in the last few years.

The minor changes are Support for the for-of loop so that it can now be used with jQuery objects. Under the hood, jQuery now also uses the`requestAnimationFrame()` to perform animations.

However, there are no more significant changes. The reason is simple: jQuery already does what it is supposed to do to a sufficient degree.

## Do companies still use it?

When it comes to choosing a technology, the big players in the market play an important role. When competent teams of developers choose a technology, it carries a lot of weight. Even though jQuery is losing popularity, it still plays a huge role on the web.

According to [Wappalyzer](https://www.wappalyzer.com/technologies/javascript-libraries), jQuery still accounts for a gigantic share of over 34% of all websites that use JavaScript libraries.

![Source: [Wappalyzer](https://www.wappalyzer.com/technologies/javascript-libraries)](https://cdn-images-1.medium.com/max/2410/1*TOg5oguzp81TxE6AWYNk0w.png)

Of course, such data should be taken with a grain of salt: Just because there are thousands, or millions, of websites still using this technology doesn’t mean it was a good decision. jQuery has also managed to become essential for other libraries.

One of the great uses is Bootstrap. The CSS framework used jQuery for all DOM manipulations until recently. It was only with Bootstrap 5 that the inclusion of jQuery was abolished.

But now to the companies that use jQuery: On the internet, I found many companies that supposedly use jQuery. However, the tech stack is constantly changing, and the question is always where exactly jQuery is used.

In fact, Stack Overflow still uses jQuery. Other companies that use jQuery include the following:

* Wellsfargo.com
* Microsoft.com
* Salesforce.com

Yes, even Microsoft. Despite that, I wouldn’t take the tech stack of companies as the only truth. Even their websites are staffed by people who make mistakes or don’t have the time to optimize.

## If it’s dead, then not because of what we think is the reason

I don’t like declaring technology “dead.” The tech industry is not a hospital, after all. Still, you have to admit that jQuery has lost extreme popularity, especially in the last five years:

![source: [trends.google.com](https://trends.google.de/trends/explore?date=today%205-y&q=jquery)](https://cdn-images-1.medium.com/max/2306/1*Avjfb5ifyoBK0FGVccZ5Yw.png)

But why is that? Well, because frameworks & libraries like React, Vue, and Angular have become more popular, many think. But that is certainly not the cause. The popular frameworks and jQuery have entirely different approaches. Yes, the focus of both is to make building web applications easier. Still, there are significant differences.

The frameworks are all about reusable components, data binding, state, and single-page apps. jQuery, on the other hand, should always be like an accent for pure JavaScript, as you can see well in the following example:

```js
let el = document.getElementById('contents'); 

// the jQuery way: 
let el = $('#contents');
```

You shouldn’t use React, Vue, or Angular for everything. For sites that can get by without, jQuery can still be a big help.

Frameworks have not killed jQuery.

Vanilla JavaScript killed jQuery.

Especially the function`document.querySelector()` many jQuery fans cite as the reason they switched. (I also often used jQuery just because of the practical `$()`-syntax).

The evolution of JavaScript makes it easier and more accessible for us to access the DOM. Even network requests, which jQuery handles very well, have become much more straightforward in JavaScript.

## We might incorrectly evaluate how jQuery affects performance

Sure, libraries aren’t all that great for your website’s performance. Especially if they are large, the loading time increases. But with its 30 kb, jQuery is not that big. For comparison, take a look at the compressed and minified NPM packages of Vue, React.js, and Angular:

* `vue`: 22 kb
* `react-dom` + `react`: 41 kb
* `angular`: 62 kb

Important: This is only the size of the packages. The size of the production bundles of an app is much larger! So when it comes to loading time, jQuery does quite well.

#### But what about rendering performance?

The big frameworks like to fight over who has the best performance. The benchmarks are usually the rendering of huge tables or thousands of state updates simultaneously. You can already see a difference in such experiments — and vanilla JS beats them all, of course.

But to be honest, the benchmarks are often not that meaningful. Especially for websites just displaying content and not “apps,” rendering performance of the library hardly matters. The user will not notice that a “slow” library was used for a dropdown.

## Final thoughts

I don’t think it’s so wrong to use jQuery still. The library can still be quite helpful in many cases, especially if you’ve already mastered it. However, it’s worth giving modern JavaScript a try.

If you want to optimize your web app for performance down to the last detail, jQuery serves no purpose. You can save the 30 kb of code by writing everything in vanilla JS — and you don’t lose any “philosophy” like reusable components or the MVVM.

jQuery always was and is more for sites that are about content, not about features. In more complex web apps, the component philosophy of React and co. is a good entry point.

Thank you for reading!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
