> * 原文地址：[Progressive Web Apps with React.js: Part 4 — Progressive Enhancement](https://medium.com/@addyosmani/progressive-web-apps-with-react-js-part-4-site-is-progressively-enhanced-b5ad7cf7a447#.7fmhi469z)
* 原文作者：[Addy Osmani](https://medium.com/@addyosmani)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[rccoder](https://github.com/rccoder)
* 校对者：

# 使用 React.js 的渐进式 Web 应用程序：第 4 部分 - 逐步增强

### 渐进增强

> Progressive enhancement means that everyone can access the **basic content** and functionality of a page in any browser, and those without certain browser features may receive a reduced but still functional experience — Lighthouse

> 渐进式增强(PE)意味着所有人都可以在任意一款浏览器中访问页面的**基本内容**和页面功能，浏览器功能有点缺失的用户可能会得到一个稍有删减但基本功能没有太大问题的体验 - 灯塔

Well built web apps should work for the majority of users in that market. If they are built for resilience, they can avoid users staring at a white screen for seconds on first load, rather than the basic content for the experience:

一个比较完善的网络应用程序应该适用于市场的大多数用户。如果这个应用在功能上是有弹性的开发的，那么他们可以避免用户在第一次加载时是白屏而非页面内容的场景：

![](https://cdn-images-1.medium.com/max/2000/1*1ORn_gBszpIr5grUWB1k_A.png)


A [comparison](https://www.webpagetest.org/video/compare.php?tests=161010_Y3_1CPD,161010_SF_1C24) of rendering strategies for ReactHN. It’s _important to note YMMV — server-side rendering HTML for an entire view may make sense for content-heavy sites but this comes at a cost. On repeat visits, client-side rendering with an application shell architecture that is cached locally might perform better. Measure what makes sense for you._

一份 ReactHN 的渲染策略 [比较](https://www.webpagetest.org/video/compare.php?tests=161010_Y3_1CPD,161010_SF_1C24)。在服务器端渲染 HTML 对内容比较重的网站是有意义的，但相应的也有一系列的代价 —— 在重复访问的时候，客户端渲染可以利用本地缓存呈现出更好的性能表现。在衡量的时候谨记什么是对你更有意义的！

Aaron Gustafson, a web standards advocate, likened [progressive enhancement](http://alistapart.com/article/understandingprogressiveenhancement) (PE) to a peanut M&M. The peanut is your content, the chocolate coating is your presentation layer and your JavaScript is the hard candy shell. This layer can vary in color and the experience can vary depending on the capabilities of the browser using it.

Aaron Gustafson，网络标准的布道师，将 [渐进增强](http://alistapart.com/article/understandingprogressiveenhancement) 比作为花生糖。花生就网站的内容，巧克力是让他吃起来更好的涂层，同理，JavaScript 就是这层硬硬的糖壳。这个涂层的颜色可能会不同，体验也会因为浏览器的各种问题而让体验不同。

Think of the candy shell as where many Progressive Web App features can live. They are experiences that combine the best of the web and the best of apps. They are useful to users from the very first visit in a browser tab, no install required. As the user builds a relationship with these apps through repeated use, they make the candy shell even sweeter.

仔细想想，糖果壳就是是许多渐进增强功能可以居住的地方。这层决定着网站和应用的体验。它对于使用浏览器第一次访问的用户非常有用。随着用户多次使用与这些应用程序建立关系，会使这层糖果壳更甜。

[](https://cdn-images-1.medium.com/max/1200/1*I_VmDeAtxyCc9ZaqkRcvEw.png)

If your PWA is progressively enhanced and contains content when scripts are unavailable, Lighthouse will give you the all clear.

如果你的网站是渐进增强的，即在脚本没有加载的时候也有基本的内容，灯塔将给你指路。

**In my view, PE is** [**_not_ about making the web work for users without JavaScript turned on**](https://jakearchibald.com/2013/progressive-enhancement-is-faster/)**, nor** [**SEO**](https://plus.google.com/+JohnMueller/posts/LT4fU7kFB8W)**, but about making it resilient to** [**lie-fi**](https://twitter.com/jaffathecake/status/733283736343576576) **and spotty network connectivity blocking users from getting a meaningful experience.** When it comes to PE with JavaScript libraries and frameworks, server-side rendering is a useful tool in your arsenal.

在我看来，渐进增强不仅仅是 [让网站在没有加载脚本的条件下正常工作](https://jakearchibald.com/2013/progressive-enhancement-is-faster/)，也不是所谓的 [SEO](ttps://plus.google.com/+JohnMueller/posts/LT4fU7kFB8W)，而是让网站充满弹性到一种 [看上去是谎言的地步](https://twitter.com/jaffathecake/status/733283736343576576)，防止各种各样的问题阻挡用户获得有意义的体验。用 JavaScript 的库或者框架来实现渐进增强的话， 服务端渲染是一种有用的手段。
### Universal rendering
### 通用渲染
**So, what is** [**Server-side rendering**](http://andrewhfarmer.com/server-side-render/) **(SSR) again?** Modern web apps typically render most or all of their content using client-side JavaScript. This means first render is blocked not only by fetching your HTML file (and its JS and CSS dependencies), but by executing JavaScript code. With SSR, the initial content for the page is generated on the server so the browser can fetch a page with HTML content already there.

那么，话说回来，什么是 [服务端渲染](http://andrewhfarmer.com/server-side-render/) SSR？现代网络应用通常是在客户端使用 JavaScript 来呈现其大部分或全部内容。 这意味着，第一次的渲染不仅受到HTML文件（及其JS和CSS依赖项）的约束，于此同时也被可执行的 JavaScript 所约束着。使用SSR，让页面的初始内容在服务器上生成，这样的话浏览器可以直接获取已经存在HTML内容的页面。


[Universal JavaScript](https://strongloop.com/strongblog/node-js-react-isomorphic-javascript-why-it-matters/) is where you server-side render the markup for your JavaScript app on the server & pipe it down as the complete HTML to the browser. JavaScript can then take over (or hydrate) the page to bootstrap the interactive portions. Effectively it enables code sharing on the server and client and in React, gives us a way to server-side render code giving us “free” progressive enhancement.

[通用JavaScript](https://strongloop.com/strongblog/node-js-react-isomorphic-javascript-why-it-matters) 是在服务器端为 JavaScript 应用程序标记渲染位置，然后把它作为完整的HTML输出到浏览器。然后在客户端上，JavaScript 可以接管页面来引导交互式部分。这种方式能有效地使服务器和客户端上的代码共享，在React中，我们一种方式实现服务器端渲染，给我们“自由”渐进增强。

This concept is [popular](https://www.smashingmagazine.com/2015/04/react-to-the-future-with-isomorphic-apps/) in the React community for several reasons: the application can render content to the screen faster without the network being a bottleneck, it works even if JavaScript fails to load on spotty connections and it allows the client to progressively hydrate to a better experience with the JS does finally kick in.

这个概念在React社区是[流行](https://www.smashingmagazine.com/2015/04/react-to-the-future-with-isomorphic-apps/)有下面几个原因：应用程序可以以更快的速度在页面上呈现内容，没有网络太差这个大瓶颈；即使 JavaScript 无法加载，他也会正常工作；它允许客户逐步接管页面，达到更好的交互体验。

React makes universal rendering relatively straight-forward thanks to [**renderToString()**](http://facebook.github.io/react/docs/top-level-api.html#reactdomserver.rendertostring) (which renders a component to its initial HTML), however there are a number of steps you usually have to work through to get this setup. A couple of [guides](https://ifelse.io/2015/08/27/server-side-rendering-with-react-and-react-router/) walk through getting SSR setup, including one we’ll be walking through shortly.

React使得通用渲染，感谢[** renderToString（）**](http://facebook.github.io/react/docs/top-level-api.html#reactdomserver.rendertostring)(它渲染一个 组件到它的初始HTML)，但是有很多步骤，你通常需要通过以获得此设置。 这里有几个获取SSR设置的[指南](https://ifelse.io/2015/08/27/server-side-rendering-with-react-and-react-router/），包括一个我们即将叙述的。

_Related: Universal routing refers to the ability to recognize views associated with a route from both the client and server (_[_React Router supports this very well_](https://github.com/ReactTraining/react-router/blob/master/docs/guides/ServerRendering.md)_). Universal data fetching refers to accessing data (e.g an API) through both the client and server. I use_ [_isomorphic-fetch_](https://www.npmjs.com/package/isomorphic-fetch) _(based on the Fetch API polyfill) for this._

联系：通用路由是指能够同时承接客户端和服务器的两者的视图（ [React Router支持这个很好]（https://github.com/ReactTraining/react-router/blob/master/docs/guides/ServerRendering.md）。 通用数据的提取是指通过客户端和服务器访问数据（例如API）。 我使用 [_isomorphic-fetch_](https://www.npmjs.com/package/isomorphic-fetch)（基于Fetch API polyfill）去做这件事。

![](https://cdn-images-1.medium.com/max/1200/1*hXtLt6n7FYlkLQ-pd3e3Yg.png)



The [Selio](https://selio.com/) Progressive Web App uses Universal rendering to ship a static version of their experience that works without JS if the network is taking time to load it up but can hydrate to improve the experience once all scripts are loaded.

 渐进式Web应用程序 [Selio](https://selio.com/) 使用通用渲染来发布他们静态版本，在网络条件允许的条件下，所有脚本都会被加载，静态文件可以被脚本接管，以改善体验。。

Specific to the [Application Shell architecture](https://developers.google.com/web/fundamentals/architecture/app-shell), you can use Universal rendering to render your Shell on the server _as well as_ the content (e.g article text) if you find that’s important to your users. How and what you ultimately decide to server-render is your call.

特定于[应用程序Shell体系结构](https://developers.google.com/web/fundamentals/architecture/app-shell)，您可以使用通用渲染在服务器上呈现您的Shell，以及内容（例如文章 文字）。如果你发现这样做对你的用户很重要，你将会自然的选择使用这种服务器端渲染。

![](https://cdn-images-1.medium.com/max/1600/0*bIfkiNN8A_q3plJh.)


Other PWAs, like Housing, [Flipkart](https://speakerdeck.com/abhinavrastogi/next-gen-web-scaling-progressive-web-apps) and AliExpress serve down a server-rendered shell with [skeleton screens](http://www.lukew.com/ff/entry.asp?1797) to make it feel like content is loading immediately even when it isn’t. This improves perceived performance.

其他PWA，如Housing，[Flipkart](https://speakerdeck.com/abhinavrastogi/next-gen-web-scaling-progressive-web-apps) 和AliExpress服务器渲染的shell与[屏幕](http ：//www.lukew.com/ff/entry.asp？1797)，使其感觉内容即时加载，即使不是。 这提高了感知的性能。

_Note: Server-rendering can mean_ **_more work_** _for your server and can increase the complexity of your codebase as your React components will need Node to be available. Keep this in mind when making a call on whether SSR is feasible for you. Devon Lindsey has a great talk on_ [_SSR perf with React_](https://www.youtube.com/watch?v=PnpfGy7q96U) _worth watching._

注意：服务器渲染可以意味着你的服务端要做**更多的工作** ，并可能会增加您的代码库的复杂性，因为您的React组件将需要标记可用。 在决定是否使用 SSR 的时候，请记住这一点。 德文林赛有一个伟大的演讲在[_SSR perf with React_](https://www.youtube.com/watch?v=PnpfGy7q96U)，非常值得去观看！

Enough with the theory, let’s dive into some code!

有了这些足够的理论，让我们深入一些代码！

### Universal Rendering with React Router
### 用 React Router 的通用渲染

[_Pro React_](http://www.pro-react.com/) _(by Cassio Zen) has a fantastic chapter on Isomorphic JS with React and I recommend checking it out. This section is modeled on a simpler version of the Pro React Isomorphic chapter updated for more recent versions of React Router._

[Pro React](http://www.pro-react.com/)（Cassio Zen       著作）中有一个关于Isomorphic JS 与 React 的神奇章节，我建议你读一下他。 这部分也因为新版本的 React Router 有了新的版本

React has baked-in support for server rendering components using [ReactDOMServer.renderToString()](https://facebook.github.io/react/docs/top-level-api.html#reactdomserver.rendertostring). Given a component, it will generate the HTML markup to be shipped down to the browser. React can take this markup and using [ReactDOM.render()](https://facebook.github.io/react/docs/top-level-api.html#reactdom.render) hydrate it, attach events, make it interactive and provide a fast first paint on first load.

React已经使用 [ReactDOMServer.renderToString（）](https://facebook.github.io/react/docs/top-level-api.html#reactdomserver.rendertostring) 对服务器渲染组件提供了支持。 给定一个组件，它将生成要发送到浏览器的HTML标记。 React可以接受这个标记，并使用 [ReactDOM.render（）](https://facebook.github.io/react/docs/top-level-api.html#reactdom.render)加强它，附加于事件，使其交互 并在第一次装载时提供快速的第一涂料。

Rendering a React component with Express might look a little like this for a hypothetical Hacker News App.

为这样一个假的 Hacker News App 使用Express渲染React组件可能看起来像这样:

    // server.js
    import express from 'express';
    import React from 'react';
    import fs from 'fs';
    import { renderToString } from 'react-dom/server';
    import HackerNewsApp from './app/HackerNewsApp';

    const app = express();
    app.set('views', './');
    app.set('view engine', 'ejs');
    app.use(express.static(__dirname + '/public'));

    const stories = JSON.parse(fs.readFileSync(__dirname + '/public/stories.json', 'utf8'));
    const HackerNewsFactory = React.createFactory(HackerNewsApp);

    app.get('/', (request, response) => {
      const instanceOfComponent = HackerNewsFactory({ data: stories });
      response.render('index', {
          content: renderToString(instanceOfComponent)
      });
    });

#### Universal mounting
#### 通用 mount
Mounting React so it works with server-rendered components requires that we supply the **same props on both the client and server** otherwise React will have no choice but to rerender the DOM and you’ll see React complain about this. It will also have an impact on the perceived user experience. But the problem is: How do we make the data that the server passed as props also available on the client, so it can be passed as props as well? One common pattern is injecting all the props needed into a script tag in our main HTML file. Our client-side JS can then use these props directly. We’ll refer to this as the “boot-up data” or “initial data”.

mount React，它与服务器渲染组件一起工作，需要我们**在客户端和服务器上提供相同的 props**，否则React将无法选择，只能重新渲染DOM，你会感觉 React 抱怨你的这个愚蠢写法。它还将对感知的用户体验产生影响。 但问题是：我们如何使服务器作为props传递的数据也可在客户端上使用，然后把它作为 props 传播？一个常见的模式是将所有需要的 props 用 script 标签注入我们主 HTML 文件中。我们的客户端JS可以直接使用这些道具。 我们将其称为“启动数据”或“初始数据”。

Here’s an example of an index page using EJS templating where one script has the initial data and props required by our React components and the other contains the rest of our React app bundle.

下面是使用EJS模板的索引页面的示例，其中一个脚本具有我们的React组件所需的初始数据和props，另一个脚本包含我们的React应用程序包的其余部分。

    <! — index.html →
    div id=”container”><%- content %></div>
    <script type=”application/json” id=”bootupData”>
     <% reactBootupData %>
    </script>
    <script src=”bundle.js”></script>

And over in our Express code we can populate our bootup data as follows:

在我们的Express代码中，我们可以填充我们的启动配置数据如下：

    // ...
    const stories = JSON.parse(fs.readFileSync(__dirname + '/public/stories.json', 'utf8'));
    const HackerNewsFactory = React.createFactory(HackerNewsApp);

    app.get('/', (request, response) => {
      const instanceOfComponent = HackerNewsFactory({ data: stories });
      response.render('index', {
          reactBootupData: JSON.stringify(stories),
          content: renderToString(instanceOfComponent)
      });
    });

Now we hop back to the client. It’s important that we pass the same props to our client that we did when they were rendered by the server because if we don’t, React isn’t going to be able to mount on our prerendered components. In our client-side code, we can ensure this by just making sure the initial “bootupData” to our components gets seeded by the above script tag and can then use it:

现在我们回到客户端。重要的是，我们将相同的道具传递给我们的客户端，当我们通过服务器渲染它们时，如果没有，React将无法挂载到我们的预渲染组件。 在我们的客户端代码中，我们可以确保这一点，只需确保我们的组件的初始 “bootupData” 通过上面的脚本标记种子，然后可以使用它：

    import React from 'react';
    import { render } from 'react-dom';
    import HackerNewsApp from './app/HackerNewsApp';

    let bootupData = document.getElementById('bootupData').textContent;
    if (bootupData !== undefined) {
        bootupData = JSON.parse(bootupData);
    }

    render(, document.getElementById('container'));

This enables our client-side React code to mount our server-rendered component.

这使我们的客户端 React 代码能够挂载到服务器渲染的组件。

#### Universal Data-fetching
#### 通用的数据拉取
A typical SPA will have many routes but it doesn’t make sense to load up data for **all** of our routes at once. Instead, we need the server to understand what data is required by the components mapping to the current route on so we can serve exactly what is needed. We also need to dynamically fetch data if the user transitions from one route to another. This means we need a strategy that supports both data fetching on the client and data *pre*fetching on the server.

典型的SPA将有许多路由，但是一次为我们的所有路由加载所有数据是没有意义的。 相反，我们需要通过路由的映射来告知服务当前路由的组件需要什么数据，以便我们可以准确满足需要。如果用户从一个路由过渡到另一个路由，我们还需要动态拉取数据。这意味着我们需要一个支持在客户端上拉取数据和在服务器预上提取数据的策略。

A common solution to universal data-fetching is using [React’s support for ‘statics’](https://facebook.github.io/react/docs/component-specs.html) to create a static ‘fetchData’ method on each component defining what data it needs. This method can be accessed at all times, even if a component has yet to be instantiated, which is important for prefetching to work.

通用数据拉取的常见解决方案是使用[React对'statics'的支持](https://facebook.github.io/react/docs/component-specs.html)在每个组件上创建静态“fetchData”方法，定义它需要什么数据。此方法可以随时访问，即使组件尚未实例化，这对于预取工作很重要。

Below is a quick snippet of updating a component to use a static fetchData method. We can also take advantage of componentDidMount on the client to check whether the server supplied our bootupData (or whether we need to fetch the bootup data ourselves).

下面是一个简单的组件使用静态fetchData方法的代码片段。我们还可以利用客户端上的 componentDidMount 来检查服务器是否提供了我们的 bootupData(否则我们是否需要自己获取启动数据)。

    // Fetch for Node and the browser
    import fetch from 'isomorphic-fetch'; 
    // ...
    class HackerNewsApp extends Component {
        constructor() {
            super(...arguments);
            this.state = {
                stories: this.props.data || []
            }
        },
        componentDidMount() {
            if (!this.props.data) {
                HackerNewsApp.fetchData().then( stories => {
                    this.setState({ stories });
                })
            }
        },
        render() {
            // ...
        }
    }

    // ...
    HackerNewsApp.propTypes = {
        data: PropTypes.any
    }

    HackerNewsApp.fetchData = () => {
        return fetch('http://localhost:8080/stories.json')
        .then((response => response.json()));
    };

    export default HackerNewsApp;

Next, let’s look at rendering routes on the server.

接下来，让我们看看在服务器上渲染路由。

[React Router](https://github.com/ReactTraining/react-router) has supported server-rendering since 1.0\. Unlike client-side rendering there are a few additions concerns to think about, like sending 30x responses for redirects and fetching data before rendering. To help with these problems, we can use the lower-level API which gives us [match](https://github.com/ReactTraining/react-router/blob/master/docs/API.md#match-routes-location-history-options--cb) for matching routes to a location without rendering and [RouterContext](https://github.com/ReactTraining/react-router/blob/master/docs/API.md) for sync rendering of route components.

[React Router](https://github.com/ReactTraining/react-route)自 1.0 以来支持服务器渲染。这里有一些与客户端渲染不同的东西需要添加进来考虑，例如发送 30x 响应重定向和拉取数据之前渲染。 为了帮助解决这些问题，我们可以使用提供给我们的下级API [match](https://github.com/ReactTraining/react-router/blob/master/docs/API.md#match-routes-location -history-options - cb)用于将路由匹配到不渲染的位置，[RouterContext](https://github.com/ReactTraining/react-router/blob/master/docs/API.md)用于路由的异步渲染组件。

We can also iterate through our renderProps to check for the existence of a static fetchData method, prefetching data and passing it as props if present. In Express, we’ll also need to change the entry points for our routes from “/” to the wildcard “*” to ensure all routes a user lands on invoke the right callback.

我们还可以遍历 renderProps 来检查是否存在静态 fetchData 方法，预取数据并将其作为 props 传递（如果存在）。在Express中，我们还需要将路由的入口点从 “/” 更改为通配符 “*”，以确保用户所访问的所有路由都调用正确的回调。

Looking at a hypothetical server.js again:

再次查看一个假设的server.js：

    import express from "express";
    import fs from 'fs';
    import React from 'react';
    import { renderToString } from 'react-dom/server';
    import { match, RouterContext } from 'react-router';
    import routes from './app/routes';

    const app = express();

    app.set('views', './');
    app.set('view engine', 'ejs');
    app.use(express.static(__dirname + '/public'));

    const stories = JSON.parse(fs.readFileSync(__dirname + '/public/stories.json', 'utf8'));

    // Helper function: Loop through all components in the renderProps object
    // and returns a new object with the desired key
    let getPropsFromRoute = ({routes}, componentProps) => {
      let props = {};
      let lastRoute = routes[routes.length - 1];
      routes.reduceRight((prevRoute, currRoute) => {
        componentProps.forEach(componentProp => {
          if (!props[componentProp] && currRoute.component[componentProp]) {
            props[componentProp] = currRoute.component[componentProp];
          }
        });
      }, lastRoute);
      return props;
    };

    let renderRoute = (response, renderProps) => {
      // Loop through renderProps object looking for ’fetchData’
      let routeProps = getPropsFromRoute(renderProps, ['fetchData']);
      if (routeProps.fetchData) {
        // If one of the components implements ’fetchData’, invoke it.
        routeProps.fetchData().then((data)=>{
          // Overwrite the react-router create element function
          // and pass the pre-fetched data as data/bootupData props
          let handleCreateElement = (Component, props) =>(
            
          );
          // Render the template with RouterContext and loaded data.
          response.render('index',{
            bootupData: JSON.stringify(data),
            content: renderToString(
              
            )
          });
        });
      } else {
        // No components in this route implements ’fetchData’.
        // Render the template with RouterContext and no bootupData.
        response.render('index',{
        bootupData: null,
        content: renderToString()
        });
      }
    };

    app.get('*', (request, response) => {
      match({ routes, location: request.url }, (error, redirectLocation, renderProps) => {
        if (error) {
          response.status(500).send(error.message);
        } else if (redirectLocation) {
          response.redirect(302, redirectLocation.pathname + redirectLocation.search);
        } else if (renderProps) {
          renderRoute(response, renderProps);
        } else {
          response.status(404).send('Not found');
        }
      });
    });

    app.listen(3000, ()=>{
      console.log("Express app listening on port 3000");
    });

We need to make similar adjustments on the client. When we’re rendering a route, we check for any bootup data. We then pass it as props to the component for the current route. [React Router’s createElement](https://github.com/ReactTraining/react-router/blob/master/docs/API.md#createelementcomponent-props) is used to initialize elements we pass to bootupData as props for a component with a fetchData method.

我们需要对客户进行类似的调整。 当我们渲染路由时，我们检查任何启动数据。 然后我们将它作为 props 传递给当前路由的组件。 [React Router的createElement](https://github.com/ReactTraining/react-router/blob/master/docs/API.md#createelementcomponent-props) 用于初始化我们传递给 bootupData 的元素作为组件的props fetchData 方法。

    let handleCreateElement = (Component, props) => {
        if (Component.hasOwnProperty('fetchData') {
            let bootupData = document.getElementById('bootupData').textContent;
            if (!bootupData == undefined) {
                bootupData = JSON.parse(bootupData);
            }
            return ;
        } else {
            return ;
        }
    }

    render((
        {routes}
    ), document.getElementById('container'))

That’s it. There’s a wealth of knowledge written up about universal rendering with React, diving into where other architectures like [Flux](https://facebook.github.io/flux/) and libraries like [Redux](https://github.com/reactjs/redux) fit in. I strongly encourage reading some of the links to get a more holistic feel for patterns that worked for others here.

仅此。 有很多关于使用React的通用渲染的知识，潜入其他架构像[Flux](https://facebook.github.io/flux/)和像[Redux](https://github.com/reactjs/redux)的库适合。我强烈鼓励阅读一些链接，以获得一个更加整体的感觉为模式，方便和其他人一起工作。

### Data-flow tips

### 数据流提示

When using React on the server, it’s not possible to request data in [componentDidMount](https://facebook.github.io/react/docs/component-specs.html) (as you would in the browser). That code doesn’t get called by renderToString and if it was possible for it to, your async data requests wouldn’t be serializable as Jonas has pointed out in his [Isomorphic React in Real Life](https://jonassebastianohlsson.com/blog/2015/03/24/isomorphic-react-in-real-life/) post (which you should read).

当在服务器上使用React时，不可能在[componentDidMount]（https://facebook.github.io/react/docs/component-specs.html）中请求数据（就像在浏览器中一样）。 该代码不会被renderToString调用，如果它是可能的，你的异步数据请求将不会序列化，如Jonas在他的[Isomorphic React in Real Life]中指出的那样（https://jonassebastianohlsson.com/ blog / 2015/03/24 / isomorphic-react-in-real-life /）post（你应该阅读）。

For asynchronous data, the answer is “it’s a little more complicated”. You can set initial state indicating user data is being fetched, like a placeholder or loader icon or try to properly async fetch + render.

对于异步数据，答案是“它有点复杂”。 您可以设置指示正在获取用户数据的初始状态，如占位符或加载程序图标，或尝试正确异步提取+渲染。

A few tips:

*   [**componentWillMount**](https://facebook.github.io/react/docs/component-specs.html#mounting-componentwillmount) is invoked both on the client and server right before rendering of your components occur. You can use this for fetching data before rendering.
*   [**statics**](http://facebook.github.io/react/docs/component-specs.html#statics) allow you to define data requests inside components but access them before rendering on the server. This enables calling something like Component.fetchData() (something you would define inside statics for Component) to access requests before they are rendered and generally works with React Router well too. Requests get executed on the server, we wait on them and then render React. This is the opposite of rendering React on the client and waiting for the data before re-rendering.
*   For **async data flow with React Router** [this](http://stackoverflow.com/a/34955577) is a strategy I have used a few times that plays well with SSR. You use a static fetchData function in your top-level component which you find server-side and invoke before rendering. Thanks to React Router’s match(), we can get back all the renderProps containing our matched components and just loop over them to grab all fetchData functions and run them on the server. [ifelse](https://ifelse.io/2015/08/27/server-side-rendering-with-react-and-react-router/)also documents another strategy for SSR with React Router that includes data fetching.
*   [React Resolver](https://github.com/ericclemmons/react-resolver) allows you to define data requirements on a per-component level, handling nested async rendering on both the client and the server. It aims to result in components that are pure, stateless and easy to test. See [Resolving on the server](https://github.com/ericclemmons/react-resolver/blob/master/docs/getting-started/ServerRendering.md) for an example of what this might look like to setup.
*   You can also use [Redux stores](https://medium.com/@navgarcha7891/react-server-side-rendering-with-simple-redux-store-hydration-9f77ab66900a) for data hydration on the server. A common approach is to use async action creators to request data from the server. This can be called on componentWillMount, where you can have a Redux reducer store data from the action, connect your component to the Redux reducer and trigger a render change. For a few more ideas on this space, see [this](https://www.reddit.com/r/reactjs/comments/3gplr2/how_do_you_guys_fetch_data_for_a_react_app_fully/) Reddit thread. Statics are [also recommended by Redux](http://redux.js.org/docs/recipes/ServerRendering.html) if using React Router “you might also want to express your data fetching dependencies as static fetchData() methods on your route handler components. They may return async actions, so that your handleRender function can match the route to the route handler component classes, dispatch fetchData() result for each of them, and render only after the Promises have resolved.”
*   [Async Props](https://github.com/ryanflorence/async-props#server) provides co-located data fetching it before new screens load. It also supports working on the server.
*   [React Refetch](https://github.com/heroku/react-refetch) by Heroku is another project that attempts to help in this space. It wraps components in a connect() decorator but rather than mapping state to props it maps props to URLs to props (allowing components to be stateless).

### Guarding against globals
### 再一次保卫全局变量
When Universal rendering, we also need to remember that node has no notion of a **document** or **window** object to use. [react-dom](https://www.npmjs.com/package/react-dom) seems to solve this problem, but if you’re using third-party components you need to watch out for dependencies relying on window/document/etc that require wrapping or guarding.

当普通渲染时，我们还需要记住，该节点没有**文档的概念**或**窗口对象**使用。 [react-dom]（https://www.npmjs.com/package/react-dom）似乎解决了这个问题，但如果你使用第三方组件，你需要注意依赖窗口/文档 / etc，需要包装或保护。

This might catch you out if relying on browser APIs such as [Web Storage](https://developer.mozilla.org/en-US/docs/Web/API/Web_Storage_API). In ReactHN, we ended up doing this as follows:

如果依赖于[Web Storage]（https://developer.mozilla.org/en-US/docs/Web/API/Web_Storage_API）等这些浏览器API，这可能会捆绑住您。 在ReactHN中，我们最终如下：

    // Deserialize caches from sessionStorage
    loadSession() {
     if (typeof window === 'undefined') return
     idCache = parseJSON(window.sessionStorage.idCache, {})
     itemCache = parseJSON(window.sessionStorage.itemCache, {})
    }

    // Serialize caches to sessionStorage as JSON
    saveSession() {
     if (typeof window === 'undefined') return
     window.sessionStorage.idCache = JSON.stringify(idCache)
     window.sessionStorage.itemCache = JSON.stringify(itemCache)
    }

_Note: Although the above is a reasonable approach, a better one would be using the “browser” key in package.json as_ [_Webpack can use this_](https://github.com/webpack/webpack/issues/151) _to automatically swap out versions for the browser vs Node. Practically, this means creating a “component.js” and “component-browser.js” and include a “browser” key as follows:_

注意：虽然上面是一个合理的方法，一个更好的是使用package.json中的“browser” 这个属性， [然后利用 Webpack 使用这些信息]（https://github.com/webpack/webpack/issues/151）自动生成浏览器与节点的版本。实际上，这意味着创建一个“component.js”和“component-browser.js”，并包含一个“browser”属性，如下

      "browser": {
        "/path/to/component.js": "/path/to/component-browser.js"
      }

_This is nice because there’s no unnecessary code for Node shipped to the browser and if you’re doing code coverage (e.g with Instanbul) there’s no need to add ignore statements all over the place._

这是看上去是挺好的，因为没有冗余的代码，Node发送到浏览器，如果你做代码覆盖（例如使用Instanbul），没有必要在所有地方添加ignore语句

### Remember: interactivity is key
### 谨记：交互是关键
#### Server rendering is a lot like giving users a hot apple pie. It looks ready but that doesn’t mean they can interact with it.

#### 服务器渲染很像给用户一个热苹果派。 它看起来准备好了，但这并不意味着他们可以与它进行交互

![](https://cdn-images-1.medium.com/max/1200/1*Znj9U-1dPk3L1WtlthETUg.png)

Progressive Bootstrapping as visually [illustrated](https://twitter.com/aerotwist/status/729712502943174657) by Paul Lewis

渐进式的渲染如上图所示

Your user-interface might include buttons, links and forms that don’t do anything when tapped because the JS required for this behavior hasn’t loaded in time. A basic experience can be offered for these features in the form of [layers](https://soledadpenades.com/2016/09/15/progressive-enhancement-does-not-mean-works-when-javascript-is-disabled/). A forward-thinking way of tackling this problem maybe **focusing on interactivity**through **Progressive rendering & bootstrapping.**


我们的用户界面可能包含按钮，链接和表格，由于需要的 JS 可能没有加载，在一些场景下点击按钮的时候可能不会产生任何效果。 可以以[layers](https://soledadpenades.com/2016/09/15/progressive-enhancement-does-not-mean-works-when-javascript-is-disabled /)的形式为这些功能提供基本体验。一个解决这个问题的比较前瞻性的方法可能通过渐进渲染和引导**聚焦在互动**。

This means you send a functionally viable, but minimal, view in HTML for a route including JS and CSS. As more resources arrive, the app progressively unlocks more features. We covered this concept and a pattern that implements it (PRPL) in [Part 2](https://medium.com/@addyosmani/progressive-web-apps-with-react-js-part-2-page-load-performance-33b932d97cf2) of this series.

这意味着您可以在HTML中为包括JS和CSS的路由发送功能上可行但最小的视图。 随着更多的资源到达，应用程序逐步解锁更多的功能。 我们在[第2部分]中讨论了这个概念和实现它的模式（PRPL）（https://medium.com/@addyosmani/progressive-web-apps-with-react-js-part-2-page-load- 性能-33b932d97cf2）。

#### Practical implementation: ReactHN
#### 实践：ReactHN
![](https://cdn-images-1.medium.com/max/1200/1*HFaR46vKjYoiWgufKXXejQ.png)

Without JS: links point to /story/:id. With JS: links point to #/story/:id

没有 JS，链接指向是这样的：/story/:id，有 JS 的情况下，链接的指向是这样的：#/story/:id

[ReactHN](https://react-hn.appspot.com/) tackled PE by offering up server-side rendered versions of our homepage and comment pages. **It was possible to navigate between these two using regular anchor tags**. When the JavaScript for a route was loaded, it would hydrate the view and all subsequent navigations would use an SPA-style model for navigation — fetching content using JS and taking advantage of the application shell already being cached using Service Worker. Thanks to route-based chunking, our [next version](https://twitter.com/addyosmani/status/784957162128744448) also ensures that ReactHN becomes interactive really quickly.

[ReactHN](https://react-hn.appspot.com/)通过提供我们的主页和评论页面的服务器端渲染解决了PE。 **可以使用常规锚标签**在这两个之间导航。 当加载路由的JavaScript时，它将接管页面，所有后续导航将使用 SPA 样式模型进行导航 - 使用JS提取内容，并利用已使用Service Worker缓存的应用程序shell。 由于基于路由的分块，我们的[下一个版本]（https://twitter.com/addyosmani/status/784957162128744448）还确保ReactHN变得很快交互。

**Other things we learned:**

**一些其他我们需要学习的东西：**
*   **100% parity between the server and client-rendered versions of your PWA is absolutely not a requirement.** In React HN, we noticed the two most popular views were stories and comments. We implemented server-rendering for these two parts and otherwise fully client-side render less popular views like User Profiles. As we’re caching them using Service Worker, they can still load instantly on repeat visits.
*   **Feel free to leave out some features (layer wisely!)**. Our client-side comments page can update in real-time, highlighting in yellow newly posted comments. This made more sense with JS and was left out on the server.

* **在服务器和客户端的PWA之间寻求100％的平衡是绝对不需要的。**在React HN中，我们注意到两个最受欢迎的页面是故事和评论。 我们为这两个部分实现了服务器渲染，否则完全是客户端渲染不太受欢迎的视图，如用户配置文件。 当我们使用Service Worker缓存它们时，他们仍然可以立即加载重复访问。
* **留下一些功能(明智的)**。我们的客户端评论页面可以实时更新，以黄色新发布的评论突出显示。这样把这部分 JS 留在服务器上更有意义。

### Testing Progressive Enhancement

### 测试渐进式增强

![](https://cdn-images-1.medium.com/max/1600/1*oWnsYNhEtyc3Sc8dtoWbAg.png)

Chrome DevTools supports both network throttling and disabling JS via the Settings panel

Chrome DevTools 支持通过“设置”面板设置网络限制和禁用JS

Although modern debugging tools (like the Chrome DevTools) support disabling JavaScript outright, I would strongly encourage testing with [network throttling](https://developers.google.com/web/tools/chrome-devtools/network-performance/network-conditions) on instead. This better reflects how soon a user will be able to view and interact with your PWA. It also provides an eye-opening view on the impact of just shipping the minimal function code to get a route booted up, perf of your server-side rendering implementation and so on.

尽管现代调试工具（如Chrome DevTools）支持直接禁用 JavaScript，但我强烈建议使用[网络限制]进行测试(https://developers.google.com/web/tools/chrome-devtools/network-performance/network- 条件)。 这更好地反映了用户能够多久查看并与您的渐进式增强应用进行交互。 它还提供了一个开放的视图，只是运输最小功能代码的影响，以获得路由启动，完美的服务器端渲染实现等。

### 阅读拓展

Below are reads on PE and SSR with React that I’ve found A+:

**Universal/Isomorphic Rendering and data-fetching**

*   [React on the server for beginners](https://scotch.io/tutorials/react-on-the-server-for-beginners-build-a-universal-react-and-node-app)
*   [Server-side rendering with React and React-router](https://ifelse.io/2015/08/28/server-side-rendering-with-react-and-react-router/)
*   Progressive enhancement with React [Part 1](https://medium.com/@jacobp100/progressive-enhancement-techniques-for-react-part-1-7a551966e4bf#.8r5tojosb), [Part 2](https://medium.com/@jacobp/progressive-enhancement-techniques-for-react-part-2-5cb21bf308e5#.ugemu980s) and [Part 3](https://medium.com/@jacobp/progressive-enhancement-techniques-for-react-part-3-117e8d191b33#.nhrqqjxyu)
*   [Server-side rendering with React, Node and Express](https://www.smashingmagazine.com/2016/03/server-side-rendering-react-node-express/)
*   [React AJAX Best Practices](http://andrewhfarmer.com/react-ajax-best-practices)
*   [Improving React server-side render perf using Electrode](https://medium.com/walmartlabs/using-electrode-to-improve-react-server-side-render-performance-by-up-to-70-e43f9494eb8b#.97w7lud3n)
*   [Universal Data Population with React Router and Reflux](https://lorefnon.me/2016/04/04/universal-data-population-with-react--react-router-and-reflux.html#)

**Progressive Enhancement**

*   [Progressive enhancement is still important](https://jakearchibald.com/2013/progressive-enhancement-still-important/) and is [faster](https://jakearchibald.com/2013/progressive-enhancement-is-faster/)
*   [Why we use Progressive Enhancement to build Gov.uk](https://gdstechnology.blog.gov.uk/2016/09/19/why-we-use-progressive-enhancement-to-build-gov-uk/)
*   [Progressive enhancement is not about JavaScript availability](http://www.christianheilmann.com/2015/02/18/progressive-enhancement-is-not-about-javascript-availability/)
*   [Progressive enhancement for JavaScript app developers](https://www.voorhoede.nl/en/blog/progressive-enhancement-for-javascript-app-developers/)
*   [Be Progressive](https://adactio.com/journal/7706)

..and, that’s a wrap!

In Part 5 of this series, we’ll look at **how to reduce the size of your React.js bundles further,** improving load performance and helping your PWA become interactive even sooner.

在本系列的第5部分中，我们将介绍如何进一步减少React.js包的大小，提高负载性能，以及帮助您的渐进增强更早地实现。

If you’re new to React, I’ve found [**React for Beginners**](https://goo.gl/G1WGxU) by Wes Bos excellent.

如果你是 React 新手，建议你阅读 Wes Bos 的 [给新手的 React 指南](https://goo.gl/G1WGxU)





