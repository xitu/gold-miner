> * 原文地址：[Incremental vs Virtual DOM](https://blog.bitsrc.io/incremental-vs-virtual-dom-eb7157e43dca)
> * 原文作者：[Chameera Dulanga](https://medium.com/@chameeradulanga)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/incremental-vs-virtual-dom.md](https://github.com/xitu/gold-miner/blob/master/article/2020/incremental-vs-virtual-dom.md)
> * 译者：
> * 校对者：

# Incremental vs Virtual DOM

![Photo by [Cristina Gottardi](https://unsplash.com/@cristina_gottardi?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/9666/0*ivwXO-FM6XbH3ugm)

If you are familiar with React, you have probably heard of the concept of Virtual DOM. It is one of the main contributors to React’s popularity by increasing UI performance.

However, when Angular released their new renderer Angular Ivy back in 2019, many wondered why they chose a concept known as Incremental DOM over Virtual DOM. And still, Angular sticks with the idea. So you might wonder why Angular uses Incremental DOM in the first place and keeps on using it. Let’s find it out.

First and foremost, let’s start with Virtual DOM and understand how it works.

## How Virtual DOM Works

Virtual DOM’s main concept is to keep a virtual representation of UI in the memory and sync it with real DOM using the [reconciliation](https://reactjs.org/docs/reconciliation.html) process. This process consist of 3 main steps:

1. Rendering the entire UI into Virtual DOM when there’s a change in UI.
2. Calculating the difference between previous and current Virtual DOM representations.
3. Updating the real DOM with the changes.

![Authors’ Work: How Virtual DOM Works](https://cdn-images-1.medium.com/max/2000/1*8OCCATi8_5HmWI1QpjrRNA.png)

---

Since you got a basic understanding of Virtual DOM, let’s dive deep into Incremental DOM.

## How Incremental DOM Works

Incremental DOM brings a more straightforward approach than Virtual DOM by using real DOM to locate code changes. So, there won’t be any virtual representation of the real DOM in memory to calculate the difference, and real DOM is used to diff against new trees.

The main idea behind this Incremental DOM concept is to compile every component into a set of instructions. Then, these instructions are used to create the DOM tree and make changes to it.

![Authors’ Work: How Incremental DOM Works](https://cdn-images-1.medium.com/max/2000/1*GHX157rdwWEP1pqfpgMfDQ.png)

## What Makes Incremental DOM So Special?

After going through the above explanations, you must have concluded that the Incremental DOM approach is much simpler. And that’s not all.

> The real benefit of the Incremental DOM is its optimized usage of memory.

This optimization becomes very handy when it comes to devices with low memory capacity like mobile phones. Besides, optimization of memory usage is not an easy task. Also, the memory usage of an application purely depends on the **bundle size** and the **memory footprint**.

Let’s see how Incremental DOM has helped to reduce these two parameters.

#### 1. Incremental DOM is Tree-Shakable

Tree shaking is not a new thing. It refers to the steps of removing unwanted codes during the build process.

Incremental DOM makes the most out of this since it uses an instructions based approach. As mentioned earlier, Incremental DOM compiles each component to a set of instructions before the compilation, and this helps to identify the unused instructions. So, they can be removed at the compilation time.

![Authors’ Work: Tree Shaking](https://cdn-images-1.medium.com/max/3026/1*kgsIwDbufdFqoPnmWf15MQ.png)

Virtual DOM is not tree-shakable since it uses an interpreter, and there is no way to get to know about unused codes at the compile time.

#### 2. Reduces Memory Usage

If you understand the main difference between Virtual DOM and incremental DOM, you should already know the secret behind this.

Unlike the Virtual DOM, Incremental DOM doesn’t generate a copy of real DOM when re-rendering the application UI. Besides, Incremental DOM won’t allocate any memory if there are no changes in the application UI. Most of the time, we re-render the applications without any significant modifications. So following this approach can drastically save the device’s memory.

![Authors’ Work: Reduced Memory usage in Incremental DOM](https://cdn-images-1.medium.com/max/2168/1*4P1uTqoBoU_gd4Z3i6r7sA.png)

It seems that Incremental DOM has a solution to reduce the memory footprint in Virtual DOM. But you might wonder why other frameworks aren’t using it?

#### There is a Tradeoff

Although Incremental DOM reduces memory usage by following a more efficient method to calculate the difference, that method is more time-consuming than Virtual DOM.

> So, there is a tradeoff between speed and memory usage when deciding between Incremental DOM and Virtual DOM.

## Final Thoughts

Out of these two Document Object Models(DOMs), Virtual DOM has been the front runner for a long time. One can argue that saying “Virtual DOM is popular because of React,” and on the other hand, React has mainly been benefited from this Virtual DOM concept.

Therefore it is evident that the speed and performance boost provided by Virtual DOM has helped React to compete with its rivals.

#### Pros and Cons of Virtual DOM

Let’s look at some main advantages of Virtual DOM,

* Efficient “diffing” algorithm.
* Simple and help to boost Performance.
* It can be used without React.
* Lightweight.
* Allows building applications without thinking about state transitions.

> Although It is Fast and Efficient, There is a Catch

This diffing process indeed reduces the workload on real DOM. And it needs to compare the current Virtual DOM state with the previous one to identify the changes. To understand this better, let’s take a small React code example:

```jsx
function WelcomeMessage(props) {
  return (
    <div className="welcome">
      Welcome {props.name}
    </div>
  );
}
```

Assume that the name prop’s initial value was “Chameera,” and it was changed to “Reader” later. The only change in the whole code is the prop, and there is no need to change the DOM node or compare attributes inside the **\<div>** tag. However, with the diffing method, it is necessary to go through all the steps to identify the changes.

We can see an enormous amount of minor changes like that in a development process, and comparing each element in the UI is undoubtedly an overhead. This can be recognized as one of the main disadvantages of Virtual DOM.

> However, Incremental DOM has a solution for this higher memory usage problem.

#### Pros and Cons of Incremental DOM

As I have mentioned earlier, Incremental DOM brings a solution to reduce the memory consumption in Virtual DOM by using real DOM to track changes. This approach has **reduced the calculating overhead drastically and improved the memory usage** of the applications as well.

So, this is the main advantage of using Incremental DOM over Virtual DOM, and we can list down a few other benefits of Incremental DOM as follows:

* Easy to integrates with many other frameworks.
* Its’ simple API makes it powerful for targeting template engines.
* Suitable for mobile device-based applications.

> In most of these cases, Incremental DOM is not the fastest as Virtual DOM.

Although Incremental DOM brings a solution to reduce the memory usage, that solution impacts Incremental DOMs speed since difference calculation takes more time than the Virtual DOM approach. So, we can recognize this as the main disadvantage of using Incremental DOM.

Both these DOMs have strengths of their own, and we can’t just say Virtual DOM is better, or Incremental DOM is better. However, what I can say for sure is that both Virtual DOM and Incremental DOM are excellent options to have, and they can handle dynamic DOM updates without any issue.

So let me stop there and thank you very much for reading this article !!!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
