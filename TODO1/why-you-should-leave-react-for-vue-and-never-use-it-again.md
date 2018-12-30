> * 原文地址：[Why I left React for Vue.](https://blog.sourcerer.io/why-you-should-leave-react-for-vue-and-never-use-it-again-5e274bef27c2)
> * 原文作者：[Gwenael P](https://blog.sourcerer.io/@gwenael.pluchon?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/why-you-should-leave-react-for-vue-and-never-use-it-again.md](https://github.com/xitu/gold-miner/blob/master/TODO1/why-you-should-leave-react-for-vue-and-never-use-it-again.md)
> * 译者：
> * 校对者：

# Why I left React for Vue.

![](https://cdn-images-1.medium.com/max/2000/1*QIg6vEjZmT5YMVKU5Rxr2A.png)

[Today’s random Sourcerer profile: https://sourcerer.io/posva]

Recently, Vue.js gained more stars that React on Github. The popularity of this framework is soaring these days, and as it is not backed by a company like Facebook (React) or Google (Angular), it is surprising to see it rising out of nowhere.

### Evolution of web development

Back in the old good days, in the 90’s, when we wrote a website, it was pure HTML, with some poor CSS styling. What was good is that it was pretty easy. What was bad is that we were lacking a lot of features.

Then came PHP, and we were happy to write things like :

![](https://cdn-images-1.medium.com/max/800/1*0QbOoPYacDrJjETxbhHMmw.jpeg)

source : [https://www.webplanex.com/blog/php-good-bad-ugly-wonderful/](https://www.webplanex.com/blog/php-good-bad-ugly-wonderful/)

This nowadays looks terrible, but at that time it was an amazing improvement. This is what it’s all about : using new languages, frameworks, and tools, that we are a fan, until the day a competitor does something much better.

Before React became popular I used Ember. I then switched to React and I felt enlightened by its wonderful way of making us develop everything as web components, its virtual DOM and its efficiency in rendering. Not everything was perfect for me but it was a huge improvement in the way I was coding.

**Then I decided to give Vue.js a try and I won’t go back to React.**

React does not completely suck, but I found it cumbersome, hard to master, and at some point the code I was writing did not look logical to me at all. It was such a relief to discover Vue and how it solves some of its older brother’s problems.

Let me explain why.

### Performance

First, let’s talk about size.

As every web developer is working according to limited network bandwidth, It is very important to limit the size of our webpages. The smaller the web page, the better. This is even more important now than it was a few years ago, with the rise of mobile browsing.

It is really difficult to evaluate and compare the sizes of React and Vue. If you want to build a website with React, you will need React-dom. Also, they come with different sets of features. But Vue is famous by its lightweight size and you will probably result having way less dependancy weight to carry with Vue.

On raw performance, here are some figures:

![](https://cdn-images-1.medium.com/max/800/1*8apjMq6HAKJzu5mkeryLmA.png)

source : [https://www.stefankrause.net/js-frameworks-benchmark6/webdriver-ts-results/table.html](https://www.stefankrause.net/js-frameworks-benchmark6/webdriver-ts-results/table.html)

![](https://cdn-images-1.medium.com/max/800/1*LahiEV9jeiJDNj3AXcSvyg.png)

source : [https://www.stefankrause.net/js-frameworks-benchmark6/webdriver-ts-results/table.html](https://www.stefankrause.net/js-frameworks-benchmark6/webdriver-ts-results/table.html)

As you can see, this benchmark details that a Vue.js web app will take less memory and run faster than one made with React.

Vue will provide you a faster rendering pipeline which will help you build complex webapps. You will feel less concerned about optimising code as your projects will render more efficiently, letting you spend time on features that matter for your project. Mobile performance is here as well and you will rarely have to adapt an algorithm to make it render smoothly on phones.

> You don’t have to compromise between size and performance when choosing Vue.js over React. You have both of them.

### Learning curve

Learning React was quite OK. It was good to see a library built entirely around web components. React core is pretty well done and stable, but I had a lot of problems dealing with the advanced router configuration. What’s the actual thing with all those router versions ? There is 4 until now ( + React-router-dom), and I ended up using v3. It is pretty easy to deal with version selection once you are used to the stack, but when you’re learning, it is a pain.

#### Third party libraries

Most of the recent frameworks share a common design philosophy : A simple core, without a lot of features, and you can enrich them by setting up other libraries on top of it. Building a stack can be really straighforward, with the condition that additional libraries can be integrated without difficulties, and in the same way for each one of them. It is very important for me that this step should be as straighforward as possible.

Both React and Vue have a tool that helps you to kickstart projects configured with additional tools. Available libraries can be pretty hard to master in the React ecosystem, as there are sometimes several libraries to solve the same problem.

On this part, React and Vue did pretty well.

#### Code clarity

In my opinion, React is pretty bad. JSX, the built-in syntax to write html code, is an abomination in terms of clarity.

This is one of the common way to write a “if” condition in JSX :

```
(
	<div>
	  {unreadMessages.length > 0 &&
	    <h1>
	      You have {unreadMessages.length} unread messages.
	    </h1>
	  }
	</div>
);
```

And this is in vue :

```
<template>
	<div v-if="unreadMessages.length > 0">
	    <h1>
	      You have {unreadMessages.length} unread messages.
	    </h1>	
	</div>
</template>
```

You’ll run into other problems. Trying to call methods from component templates will often result having no access to “this”, resulting in that you have to bind them manually : `<div onClick={this.someFunction.bind(this, listItem)} />` .

![](https://cdn-images-1.medium.com/max/800/1*AmMOMOzb_rAfA7MOUPWSfA.gif)

At some point things are getting so illogic with React…

Assuming that you’re probably going to write a lot of conditionals in your app, the JSX way is terrible. That way of writing loops looks like a joke to me. Sure you can change the templating system, remove JSX from a React stack, or use JSX with Vue, but as it’s not the first thing you are going to do when learning a framework, it’s not the point.

Another point, you won’t have to use **setState** or any equivalent with Vue. You will still have to define all the state properties in a “data” method, but if you forget, you will see a notice in the console. The rest is automatically handled internally, just change the value in your component as you do in a regular Javascript object.

You are going to run into a lot of code errors with React. It will make your learning process slow even if the underlying principles are actually simple.

Concerning conciseness, a code written with Vue is way smaller than one written with other frameworks. This is actually the best part of the framework. Everything is simple, and you will find yourself writing complex features with only few understandable lines, while with other frameworks, it will take you 10%, 20%, sometimes 50% more lines.

You don’t need to learn a lot either. Everything is pretty straightforward. Writing Vue.js code gets you pretty close to the conceivable minimal way of implementing your thoughts.

This ease of use makes Vue, a really good tool if you want to adapt and communicate. Either you want to change other parts of your stack, enroll more people in your team for an emergency situation, or do some experimentations on your products, it will definitely take less time, and thus money.

Time estimations are made pretty easy because implementing a feature does not require much more than what the developers estimate, leading to a small number of possible confusions, mistakes or oversights. And the small number of concepts to understand makes communicating with project managers easier.

### Conclusion

Whether speaking on size, performance, simplicity, or a learning curve; embracing Vue.js definitely looks like a good bet nowadays, making you save both time and money.

Its weight and performance also allows you to have a web project with 2 frameworks at the same time (Angular and Vue for instance), and this will allow you an easy transition to Vue.

Concerning the community and the popularity, even if Vue has more stargazers now, we can’t say that it has reached React’s popularity yet. But the fact that a framework became so popular without it being backed by a huge IT company is definitely good to see. Its market share has quickly grown from an unknown project to one of the biggest competitors in front-end development.

The number of modules built on top of Vue is soaring and if you don’t find a specific one to suit your needs, you will not spend a long time developing what you need.

This framework makes understanding, sharing, and editing easy. Not only will you feel comfortable digging into other’s code, but you will also be able to edit their implementations easily. In a matter of months, Vue made me feel way more confident when dealing with sub-projects and external contributions to projects. It made me save time, focus on what I really wanted to design.

React was designed to be used with helpers such as setState, and you **will** forget to use them. You will struggle writing templates, and the way you write them will make your project hard to understand and maintain.

Concerning the use of those frameworks in a large scale project, with React you will need to master other libraries and to train your team to use them. With all the related problems (X does not like this lib, Y don’t understand that). Vue stacks are simpler for the greater good of your team.

> As a developer, I feel happy, confident and free. As a project manager, I can plan and communicate with my teams more easily. And as a freelancer, I save time and money.

There are still some needs that are not yet covered by Vue (especially if you want to build native applications). React performs pretty well in that field, but Evan You and the Vue team is already working hard on that.

> React is popular because of some good concepts and the way these are implemented. But looking back, it looks like a bunch of ideas in an ocean of mess.

Writing React code is about dealing with workarounds all day long (cf “code clarity” part), struggling on code that actually make sense, to finally hack it and produce a really unclear solution. This solution will be hard to read when you come back to it a few months later. You will work harder to release your project, and it will be hard to maintain, have errors and need a lot of training to be modified.

These are negative aspects nobody wants in their projects. Why would you still run into these troubles? Community and third party libraries? So much pain that could be avoided for few points that are becoming less problematic everyday.

After years of dealing with frameworks that in some cases made my life easier, but in some others, complicates a lot the way of implementing a feature, Vue is a relief to me. Implementations are very close to how I plan to develop features, and while developing, there is nearly nothing particular to think about, apart of what you really want to implement. It looks very close to the native Javascript logic (no more **setState**, special ways to implement conditionnals or pieces of algorithms). You just code as you want. It is fast, safe, and it makes you happy :D. I am glad to see Vue being adopted more and more by frontend developers and companies, and I hope it will soon be the end of React.

_Disclaimer : This article is opinionated and shows my point of view at the moment. As technologies evolve, they will be subject to change (for the better or the worse)._

[EDIT] Changed the title, according to a suggestion of [James Y Rauhut](https://medium.com/@seejamescode?source=post_header_lockup).

[EDIT] Changed the paragraph speaking about framework size comparison. As pointed out, it is really difficult to evaluate and will always end up creating arguments between people and their architectures, based on their needs.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
