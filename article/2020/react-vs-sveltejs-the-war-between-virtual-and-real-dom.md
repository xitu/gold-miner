> * 原文地址：[React vs. Svelte: The War Between Virtual and Real DOM](https://blog.bitsrc.io/react-vs-sveltejs-the-war-between-virtual-and-real-dom-59cbebbab9e9)
> * 原文作者：[Keshav Kumaresan](https://medium.com/@keshavkumaresan1002)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/react-vs-sveltejs-the-war-between-virtual-and-real-dom.md](https://github.com/xitu/gold-miner/blob/master/article/2020/react-vs-sveltejs-the-war-between-virtual-and-real-dom.md)
> * 译者：
> * 校对者：

# React vs. Svelte: The War Between Virtual and Real DOM

I recently had the pleasure of playing around with Svelte and learned how to build a simple shopping cart application. Moreover, I couldn’t help but notice many similarities it has with React. It’s surprising to see how well of a contender it can be, to one of the most popular JavaScript libraries for building user interfaces. In this article, I’m going to compare Svelte vs. React and how they fare against each other behind the scenes.

![Image by [Iván Tamás](https://pixabay.com/users/thommas68-2571842/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=2354583) from [Pixabay](https://pixabay.com/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=2354583)](https://cdn-images-1.medium.com/max/3840/1*SVLGTQm3xUZgU8n2QJfmyA.jpeg)

## Svelte is a Compiler while React uses Virtual DOM

React and Svelte, both provide a similar component-based architecture — that means both enable a CDD bottom-up development, and both enable sharing their components between apps.

The significant difference between them is that Svelte is a compiler that converts your application into ideal JavaScript during build time as opposed to React, which uses a virtual DOM to interpret the application code during runtime. Yes, that was quite a lot of jargon, let me break it down.

![Svelte vs. React Behind the Scenes](https://cdn-images-1.medium.com/max/5916/1*_7upPeJparkaxnpBhOkZig.png)

#### React Virtual DOM

React uses a concept known as Virtual DOM (VDOM), where a virtual representation of the UI is kept in memory and synced with the real DOM through a process called [reconciliation](https://reactjs.org/docs/reconciliation.html). The reconciliation process will find the difference (diffing) between the Virtual DOM (An object in memory, where we push the latest updates to the UI) and the real DOM (DOM holding the previously rendered UI). Using specific heuristic algorithms, it decides how to update the UI. This process, for the most part, is fast, reliable, and immensely reactive. Pun intended 😄.

To achieve this, React bundles a certain amount of overhead code, which will run in the browser’s JS engine to monitor and update the DOM based on various user interactions.

#### Svelte Compiler

Svelte is purely a compiler, that converts your application into ideal JavaScript code when you build the application for production. Meaning it won’t inject any overhead code to run in the browser when your application is running to update the DOM.

This approach is relatively new when compared to React, which generally takes advantage of the virtual DOM.

## Where Svelte is Strong

Let’s find out what are key benefits we can gain by using Svelte.

1. The building time is blazing fast when compared to React or even other frameworks. Usage of rollup plugin as the bundler might be the secret here.
2. Bundle size is smaller and tiny when gzipped when compared to React, and this is a huge plus point. Even with the shopping cart application I built, the initial load time and the duration to render the UI is extremely low, only the chunky images I have added takes some time :).
3. Binding classes and variables are relatively easy, and custom logic is not needed when binding classes.
4. Scoping CSS `\<style>` within the component itself allows flexible styling.
5. Easier to understand and get started when compared to other frameworks as the significant portion of Svelte is plain JavaScript, HTML, and CSS.
6. More straightforward store implementation when compared to React’s context API, granted context API provides more features, and Svelte might be simple enough for common scenarios.

## Where Svelte Falls Behind

Let’s find out where Svelte has its downsides.

1. Svelte won’t listen for reference updates and array mutations, which is a bummer, and developers need to actively look out for this and make sure arrays are reassigned so the UI will be updated.
2. Usage style for DOM events can also be annoying, as we need to follow Svelte’s specific syntax instead of using the predefined JS syntax. Cannot directly use `onClick` like in React, but instead, have to use special syntax such as `on:click`.
3. Svelte is a new and young framework with minimal community support, thereby doesn’t have support for a wide range of plugins and integrations that might be required by a heavy production application. React is a powerful contender here.
4. No additional improvements. Ex- React suspense actively controls your code and how it runs and tries to optimize when the DOM is updated and sometimes even provide automatic loading spinners when waiting for data. These extra features and continued improvements are relatively low in Svelte.
5. Some developers might not prefer using special syntaxes such as `#if` and `#each` within their templates and instead would want to use plain JavaScript, which React allows. This might come down to personal preferences.

## Conclusion

Svelte’s blazing fast build time and tiny bundle sizes are quite appealing when compared to React, especially for small everyday applications. Yet the enhanced features (context API, suspense, etc.), community support, a wide range of plugins and integrations along with certain syntax simplifications does render React attractive as well.

**Is Svelte better than react or vice versa?**

Well, Svelte does provide noticeable improvements in certain features when compared to React. But it may not still be significant or large enough to replace React completely. React is still robust and broadly adopted. Svelte has quite some catching up to do. But concept-wise, the compiling approach taken by Svelte has proven that virtual DOM diffing isn’t the only approach to build fast reactive applications, and a good enough compiler can get the same job done as good as it gets.

**So which framework should you use for your next application?**

When weighing the Pros and Cons, In my opinion, if you are building a small application, like a simple e-commerce application for your startup, I would recommend Svelte. If you have a good knowledge of JS, HTML, and CSS, its easier to master Svelte. You can also build some powerful fast and lightweight applications with Svelte.

For huge production applications that require several integrations and specific plugins, then maybe React still might be the way to go. Then again, much like React provides Next.js, Svelte also provides its production-ready Single Page Application framework called [Sapper](https://sapper.svelte.dev/), which might be worth looking into.

Both contenders are practical and efficient tools to build brilliant user interfaces. Choosing between the two as of now is mostly based on your scenario and preferences. As I have mentioned above, it’s challenging to announce one winner since they both perform beautifully to achieve their primary goals.

I hope this article gave you a quick comparison of React and Svelte. And it would be helpful to decide which library to choose for your next application. Cheers!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
