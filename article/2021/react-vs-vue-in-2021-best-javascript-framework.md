> * 原文地址：[React vs. Vue in 2021: Best JavaScript Framework](https://dzone.com/articles/react-vs-vue-in-2021-best-javascript-framework)
> * 原文作者：[Siddhant Trivedi](https://dzone.com/users/4453916/elizabethlvova.html)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/react-vs-vue-in-2021-best-javascript-framework](https://github.com/xitu/gold-miner/blob/master/article/2021/react-vs-vue-in-2021-best-javascript-framework.md)
> * 译者：
> * 校对者：
> 

# React vs. Vue in 2021: Best JavaScript Framework
We’ve put together this convenient guide to help you better understand the use cases of Vue vs. React and determine which one will work best for your next project.

While JavaScript frameworks are now vital for web app development, many companies struggle to choose between React and Vue for their projects. The short answer is that there is no clear winner in the general React.js vs. Vue.js debate. Each framework has its pros and cons and is useful for different applications. So, we’ve put together this convenient guide to popular frameworks, to help you better understand the use cases of Vue vs. React and determine which one will work best for your next project.

# **Vue.js vs. React — What Are They?**

Both React and Vue are open source JavaScript frameworks that make it easier and faster for developers to build complex user interfaces. Before we get into the React vs. Vue comparison, we’ll give you a brief overview of each one.

The React JavaScript library offers increased flexibility by utilizing 'components,' short, isolated sections of code that developers can use to create more complex logic and UIs. React interacts with HTML documents through a 'virtual DOM,'  which is a copy of the actual DOM, but all of the elements are represented as JavaScript objects. These elements, along with React’s declarative programming style and one-way data binding, simplify and speed up development.

Vue also features two-way binding and components and uses a virtual DOM. However, Vue’s major draw is its progressive design. Vue is designed to allow developers to migrate existing projects to the framework incrementally, moving features one by one, rather than all at once. So, depending on your project’s requirements, you can use Vue as a full framework or as a lightweight library, and anything in between.

# **Similarities**

As you can see, Vue and React are quite similar to one another and have many of the same traits and features. The biggest similarity is the use of the virtual DOM.

In addition, **both** React and Vue:

- Work with any existing web app.
- Suggest quite a lightweight approach for developers to quickly hop on work.
- Feature component-based architecture with lifecycle methods.
- Offer increased flexibility, speed, and performance.
- Have large, active communities.
- Offer a wide selection of libraries and tools.

# **Differences**

While React.js and Vue.js have many similarities, there are a few differences between the two, which have a substantial impact on what each is best suited for. The primary difference lies in the methods used by Vue vs. React for rendering content onto the DOM. Vue uses HTML templates and JSX, while React only uses JSX, which is essentially an extension that allows you to insert HTML directly into JS code. While JSX can speed up and simplify larger, more complex tasks, the downside is that it can also complicate what should be an easy task.

In addition, React’s core offerings are components, DOM manipulation, and component state management. Everything else is developed and supported by the community. While seasoned developers often prefer this level of freedom, newbies may feel overwhelmed by the abundance of third-party libraries and tools.

While Vue has its own wide selection of community-built solutions, its core team also builds and supports commonly used tools and companion libraries, such as Vue-router, Vuex, and Vue CLI. This combination of pre-built and third-party resources helps meet the needs and desires of both beginner and senior developers alike.

# **Vue vs. React Performance**

Since React and Vue share many of the same elements, their general performance is about equal. Both frameworks use virtual DOMs, and lazy loading to boost performance and page loading speeds.

However, there are certain situations where one framework clearly outperforms the other. For example, when you modify a React component state, all of the components in its subtree will re-render as well. However, in Vue, dependencies are tracked to prevent unnecessary re-renders. While you can use immutable data structures, shouldComponentUpdate, or PureComponent to prevent child component re-renders in React, this can add additional complexity and result in DOM state inconsistencies.

# **1. Application Architecture**

React is different from other frameworks and libraries, in that it does not have a built-in architecture pattern. It uses a component-based architecture, which has its pros and cons. React UIs are rendered by components that work as functions and respond to changing data. So, the internal architecture consists of the constant interaction between the state of the components and the users’ actions.

Vue’s focus on the ViewModel approach of the MVVM pattern works well for larger applications. It uses two-way data binding to connect the View and Model. The primary goal of Vue is to provide a simple, flexible view layer, not a full-blown framework.

# **2. Scalability**

When considering the use of React vs. Vue for large applications, React has an edge, due to its easy scalability. Since React apps solely use JavaScript, developers can utilize traditional code organization methods for easy scaling. Component reusability enhances React’s scalability.

While Vue is also scalable, thanks to its wide selection of flexible tools, it is more often used in smaller applications (although the size of the app of course depends on the architecture). Due to the dynamic architecture, you will need to take advantage of Vue’s libraries and Mixin elements to overcome the scaling limitations. So if you’re considering a React vs. Vue enterprise application, React may be more accommodating of future growth.

# **3. Documentation**

Vue is the clear winner when it comes to documentation. Vue’s website features excellent quality, highly-detailed descriptions, offered in multiple languages, and its docs and API references are widely regarded as the best in the industry. You can find clear answers to a number of questions and issues in the docs. However, since the Vue community is not as large as React’s, so you may have more difficulty getting the right answers to questions that are not covered in the documentation.

React’s documentation is nowhere near the level of Vue’s, so you’ll be turning to the community a lot more often to solve challenges and issues. However, React does have a massive, active community, with a huge selection of learning materials.

# **4. Community Support**

This brings us to the topic of React vs. Vue community support. This is a vital part of any technology, since the community provides assistance to both new and experienced developers and creates third-party solutions and tools.

React is developed and maintained by Facebook, which uses it in their own applications. So it has plenty of ongoing support and an active community that consistently builds and maintains new tools.

Vue was started by a developer, not a corporation, so it did not enjoy the immediate popularity boost that React did. In fact, when it was first released, many developers felt it was unreliable and were hesitant to adopt it. However, Vue has seen substantial growth and increase in popularity, thanks to continued support and contributions from the user community.

# **5. Popularity**

With 181K Github stars, Vue is, inarguably, the most popular JavaScript framework. However, React has risen to second place, with 165K stars, and continues to grow and gain new users. Many well-known companies have web apps made with Vue.js and React.

**Vue** users include:

- Gitlab
- Euronews
- Adobe Portfolio
- Behance
- Alibaba
- Trustpilot
- Vice
- Nintendo
- BMW

**React** users include:

- BBC
- Airbnb
- Facebook
- PayPal
- The New York Times
- Netflix
- Instagram
- Twitter
- WhatsApp

# **6. Security**

Both Vue and React have their own security pitfalls, however, Vue apps are a bit easier to secure than React-based apps. While it is not possible to enable automatic protections against things like XSS vulnerabilities, Vue developers can sanitize the HTML code before implementation or utilize external libraries to help protect against attacks. In cases where you know the HTML is safe, you can explicitly render HTML content and protect the application both before and after rendering.

React security relies on the developer using security best practices to protect against XSS vulnerabilities, server-side rendering attacks, SQL injections, and other threats. This may include things like using the serialize-Javascript module, exploiting script-injection flaws, and using secure React Native applications. So, while React is easy to use, it takes a lot of expertise and experience to ensure that React apps are secure.

# **7. Job Market for React vs. Vue**

React’s popularity means that there is a larger pool of experienced developers to hire from. According to the 2019 Front-End Tooling survey, over 48% of developers feel comfortable using React, while only 23% claimed to be able to use Vue at a comfortable level.

However, HackerRank’s Developer Skills Report found that, while 33.2% of companies are looking to hire React developers, only 19% of developers have the skills that are required. Whereas 10% of companies need Vue developers, but only 5.1% of developers are qualified.

Vue continues to increase in popularity though, and it took fourth place in the ranking of technologies that developers wanted to learn in 2020. This growth in popularity, along with Vue’s excellent documentation and ease of learning, will likely result in an increase in qualified Vue developers.

# **The Conclusion**

To summarize, React enjoys more corporate support, greater popularity among developers, and a massive contributing community that can answer any questions you might have. It’s also easier to scale and is typically preferred for complex, enterprise-level applications.

While Vue, on the other hand, is not yet as widely supported and used, it is constantly increasing in popularity, due primarily to its fantastic documentation, ease of use, and incremental adoption capabilities. Vue also has more core support and a wider variety of built-in tools and solutions. When considering React vs. Vue development speed, with Vue CLI 4, it takes as little as a few weeks to set up and deliver a market-ready product.

Clearly, both are excellent frameworks for any modern web application, and the React vs. Vue pros and cons change depending on the use-case. The right solution depends entirely on your project goals and preferences.

**React** is better if you want to:

- Have a wide variety of flexible libraries, tools, and ecosystems.
- Easily use it with TypeScript, Flow, ReasonML, BuckleScript.
- Develop a highly-scalable application with easy testing and debugging.
- Quickly build a complex app.
- Create a high-performing video streaming platform or media site.

Choose **Vue** if you want to:

- Build a progressive web app or SPA.
- Start development immediately.
- Have access to more core tools and support.
- Extend an existing app’s functionality.

We hope this guide helps you settle the React.js vs. Vue.js debate for your next project. If you still have questions about the technologies, or you need a team of experienced developers to help create your project, send us a message using the form below!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
