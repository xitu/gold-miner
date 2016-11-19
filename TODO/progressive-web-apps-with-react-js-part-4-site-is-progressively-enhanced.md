> * 原文地址：[Progressive Web Apps with React.js: Part 4 — Progressive Enhancement](https://medium.com/@addyosmani/progressive-web-apps-with-react-js-part-4-site-is-progressively-enhanced-b5ad7cf7a447#.7fmhi469z)
* 原文作者：[Addy Osmani](https://medium.com/@addyosmani)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[rccoder](https://github.com/rccoder)
* 校对者：

# 使用 React.js 的渐进式 Web 应用程序：第 4 部分 - 渐进增强

### 渐进增强(Progressive Enhancement)

> 渐进增强 (Progressive Enhancement) 意味着所有人都可以在任意一款浏览器中访问页面的**基本内容**和页面功能，对于那些浏览器功能不健全用户可能会得到一个稍有删减但基本功能没有太大问题的体验 - 灯塔

Well built web apps should work for the majority of users in that market. If they are built for resilience, they can avoid users staring at a white screen for seconds on first load, rather than the basic content for the experience:

一个比较完善的 Web 应用要让他要立足的市场的大多数用户能自然的使用。如此，如果一个Web 应用遵循弹性开发的理念，那么它可以避免用户在第一次进入应用时遭受到白屏而非正常要展示的内容的情况：

![](https://cdn-images-1.medium.com/max/2000/1*1ORn_gBszpIr5grUWB1k_A.png)

> 这是一份 ReactHN 的渲染策略 [比较](https://www.webpagetest.org/video/compare.php?tests=161010_Y3_1CPD,161010_SF_1C24)。在服务器端渲染 HTML 对于内容比较重要的网站是很有意义的，但相应的也会付出一系列的代价 —— 在用户多次访问 Web 应用的时候，客户端渲染可以利用本地缓存表现出更好的性能，而服务端渲染每次都需要重新下载。我们在做抉择的时候，谨记什么是对我们更有意义的！

Aaron Gustafson，Web 标准的布道师，将 [渐进增强](http://alistapart.com/article/understandingprogressiveenhancement) 比作为花生糖。花生就是网站的内容，巧克力涂层就是你的表现层，JavaScript 就是这层硬硬的糖壳。这个涂层的颜色可能会不同，体验也会因为浏览器的各种问题而让体验不同。

仔细想想，糖果壳就是是许多渐进增强功能可以居住的地方。这层决定着网站和应用的体验。它对于使用浏览器第一次访问的用户非常有用。随着用户多次使用与这些应用程序建立关系，会使这层糖果壳更甜。

[](https://cdn-images-1.medium.com/max/1200/1*I_VmDeAtxyCc9ZaqkRcvEw.png)

如果你的 Web 应用是渐进增强的，即在脚本没有加载的时候也有基本的内容，灯塔将给你指路。

在我看来，渐进增强不仅仅是 [让网站在没有加载脚本的条件下正常工作](https://jakearchibald.com/2013/progressive-enhancement-is-faster/)，也不是所谓的 [SEO](ttps://plus.google.com/+JohnMueller/posts/LT4fU7kFB8W)，而是让网站充满弹性到一种 [看上去是谎言的地步](https://twitter.com/jaffathecake/status/733283736343576576)，防止各种各样的问题阻挡用户获得有意义的体验。用 JavaScript 的库或者框架来实现渐进增强的话， 服务端渲染是一种有用的手段。

### 通用渲染(Universal rendering)

那么，话说回来，什么是 [服务端渲染](http://andrewhfarmer.com/server-side-render/) SSR？现代网络应用通常是在客户端使用 JavaScript 来呈现其大部分或全部内容。 这意味着，第一次的渲染不仅受到HTML文件（及其JS和CSS依赖项）的约束，与此同时也被可执行的 JavaScript 所约束着。使用SSR，让页面的初始内容在服务器上生成，这样的话浏览器可以直接获取已经存在HTML内容的页面。

[通用JavaScript (Universal JavaScript)](https://strongloop.com/strongblog/node-js-react-isomorphic-javascript-why-it-matters) 就是只在服务器端为 JavaScript 应用程序标记渲染位置，然后把它作为完整的 HTML 输出到浏览器。然后在客户端上，JavaScript 可以接管页面来引导交互式部分。这种方式能有效地使服务器和客户端上的代码共享，在React中，我们一种方式实现服务器端渲染，给我们“自由”渐进增强。

这个概念在React社区 [流行](https://www.smashingmagazine.com/2015/04/react-to-the-future-with-isomorphic-apps/) 有下面几个原因：应用程序可以以更快的速度在页面上呈现内容，没有网络太差这个大瓶颈；即使 JavaScript 无法加载，他也会正常工作；它允许客户逐步接管页面，达到更好的交互体验。

React使得通用渲染标准化，感谢 [**renderToString（**](http://facebook.github.io/react/docs/top-level-api.html#reactdomserver.rendertostring)(它渲染一个组件到它的初始HTML)，但是有很多步骤，你通常需要通过以获得此设置。 这里有几个获取SSR设置的[指南](https://ifelse.io/2015/08/27/server-side-rendering-with-react-and-react-router/)，包括一个我们即将叙述的。

联系：通用路由(Universal routing)是指能够同时承接客户端和服务器的两者的视图（ [React Router支持这个很好](https://github.com/ReactTraining/react-router/blob/master/docs/guides/ServerRendering.md)。 通用数据(Universal data)的提取是指通过客户端和服务器访问数据（例如API）。 我使用  [isomorphic-fetch](https://www.npmjs.com/package/isomorphic-fetch) （基于Fetch API polyfill）去做这件事。

![](https://cdn-images-1.medium.com/max/1200/1*hXtLt6n7FYlkLQ-pd3e3Yg.png)

渐进式Web应用程序 [Selio](https://selio.com/) 使用通用渲染来发布他们静态版本，在网络条件允许的条件下，所有脚本都会被加载，静态文件可以被脚本接管，以改善体验。。


特定于[应用程序Shell体系结构](https://developers.google.com/web/fundamentals/architecture/app-shell)，您可以使用通用渲染在服务器上呈现您的Shell，以及内容（例如文章 文字）。如果你发现这样做对你的用户很重要，你将会自然而然的选择使用这种服务器端渲染。

![](https://cdn-images-1.medium.com/max/1600/0*bIfkiNN8A_q3plJh.)


其他PWA，如Housing，[Flipkart](https://speakerdeck.com/abhinavrastogi/next-gen-web-scaling-progressive-web-apps) 和AliExpress服务器渲染的shell与[屏幕](http ：//www.lukew.com/ff/entry.asp?1797)，使其感觉内容即时加载，即使不是。 这提高了感知的性能。


注意：服务器渲染可以意味着你的服务端要做 **更多的工作** ，并可能会增加您的代码库的复杂性，因为您的React组件将需要标记可用。 在决定是否使用 SSR 的时候，请记住这一点。 德文林赛有一个伟大的演讲在[SSR perf with React](https://www.youtube.com/watch?v=PnpfGy7q96U)，非常值得去观看！

有了这些足够的理论，让我们看看代码吧！

### 用 React Router 的通用渲染(Universal Rendering with React Router)

[Pro React](http://www.pro-react.com/)（Cassio Zen 著作）中有一个关于Isomorphic JS 与 React 的神奇章节，我建议你读一下他。 这部分也因为新版本的 React Router 有了新的版本

React已经使用 [ReactDOMServer.renderToString（）](https://facebook.github.io/react/docs/top-level-api.html#reactdomserver.rendertostring) 对服务器渲染组件提供了支持。 给定一个组件，它将生成要发送到浏览器的HTML标记。 React可以接受这个标记，并使用 [ReactDOM.render（）](https://facebook.github.io/react/docs/top-level-api.html#reactdom.render) 加强它，附加于事件，使其交互 并在第一次装载时提供快速的第一涂料。

为这样一个第三方的 Hacker News App 使用Express渲染React组件可能看起来像这样:

``` javascript
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
```

#### 通用渲染(Universal mounting)

与服务器渲染组件一起渲染 React 工作，需要我们 **在客户端和服务器上提供相同的 props**，否则React将无法选择，只能重新渲染DOM，你会感觉 React 在抱怨你的这个愚蠢写法。它还将对感知的用户体验产生影响。 但问题是：我们如何使服务器作为 props 传递的数据也可在客户端上使用，然后把它作为 props 传播？一个常见的模式是将所有需要的 props 用 script 标签注入我们主 HTML 文件中。我们的客户端JS可以直接使用这些道具。 我们将其称为 “启动数据” 或 “初始数据”。

下面是使用EJS模板的索引页面的示例，其中一个脚本具有我们的React组件所需的初始数据(initial data) 和 props，另一个脚本包含我们的React应用程序包的其余部分。

``` javascript
<! — index.html →
div id=”container”><%- content %></div>
<script type=”application/json” id=”bootupData”>
 <% reactBootupData %>
</script>
<script src=”bundle.js”></script>
```

在我们的Express代码中，我们可以配置我们的启动配置数据如下：

``` javascript
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
```
现在我们回到客户端。将相同的 props 传递给我们的客户端无疑是重要的，如果没有这点，当我们通过服务器渲染它们时，React将无法挂载到我们的预渲染组件。 在我们的客户端代码中，我们可以确保功能的正常使用，前提是确保我们的组件的初始 “bootupData” 通过上面的脚本标记种子，然后可以使用它：

``` javascript
import React from 'react';
import { render } from 'react-dom';
import HackerNewsApp from './app/HackerNewsApp';

let bootupData = document.getElementById('bootupData').textContent;
if (bootupData !== undefined) {
    bootupData = JSON.parse(bootupData);
}

render(, document.getElementById('container'));
```

这使我们的客户端 React 代码能够挂载到服务器渲染的组件。

#### 通用的数据请求(Universal Data-fetching)

典型的SPA将有许多路由，但是一次为我们的所有路由加载所有数据是没有意义的。 相反，我们需要通过路由的映射来告知服务当前路由的组件需要什么数据，以便我们可以准确满足需要。如果用户从一个路由过渡到另一个路由，我们还需要动态拉取数据，这意味着我们需要一个支持在客户端上拉取数据和在服务器预拉取数据的策略。

通用数据请求的常见解决方案是使用[React对'statics'的支持](https://facebook.github.io/react/docs/component-specs.html)在每个组件上创建静态“fetchData”方法，定义它需要什么数据。此方法可以随时访问，即使组件尚未实例化，这对于预拉取工作很重要。

下面是一个简单的组件使用静态fetchData方法的代码片段。我们还可以利用客户端上的 componentDidMount 来检查服务器是否提供了我们的 bootupData(否则我们是否需要自己获取启动数据)。
``` javascript
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
```

接下来，让我们看看在服务器上渲染路由。

[React Router](https://github.com/ReactTraining/react-route)自 1.0 以来支持服务器渲染。这里有一些与客户端渲染不同的东西需要添加进来考虑，例如发送 30x 响应重定向和拉取数据之前渲染。 为了帮助解决这些问题，我们可以使用提供给我们的下级API [match](https://github.com/ReactTraining/react-router/blob/master/docs/API.md#match-routes-location-history-options-cb)用于将路由匹配到不渲染的位置，[RouterContext](https://github.com/ReactTraining/react-router/blob/master/docs/API.md)用于路由的异步渲染组件。

我们还可以遍历 renderProps 来检查是否存在静态 fetchData 方法，预拉取数据并将其作为 props 传递（如果存在）。在Express中，我们还需要将路由的入口点从 “/” 更改为通配符 “*”，以确保用户所访问的所有路由都调用正确的回调。

再次查看一个 server.js：

``` javascript
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
```

我们需要对客户进行类似的调整。 当我们渲染路由时，我们检查任何启动数据。 然后我们将它作为 props 传递给当前路由的组件。 [React Router的createElement](https://github.com/ReactTraining/react-router/blob/master/docs/API.md#createelementcomponent-props) 用于初始化我们传递给 bootupData 的元素作为组件的props fetchData 方法。

``` javascript
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
```

仅此。 有很多关于使用React的通用渲染的知识，潜入其他架构像[Flux](https://facebook.github.io/flux/)和像[Redux](https://github.com/reactjs/redux)的库适合。我强烈鼓励阅读一些链接，以获得一个更加整体的感觉为模式，方便和其他人一起工作。

### 数据流技巧(Data-flow tips)


当在服务器上使用React时，不可能在 [componentDidMount](https://facebook.github.io/react/docs/component-specs.html) 中请求数据（就像在浏览器中一样）。 该代码不会被renderToString调用，如果它是可能的，你的异步数据请求将不会序列化，如Jonas在他的 [Isomorphic React in Real Life](https://jonassebastianohlsson.com/blog/2015/03/24/isomorphic-react-in-real-life/)中指出的那样（你应该阅读）。

对于异步数据，答案是“它有点复杂”。 您可以设置指示正在获取用户数据的初始状态，如占位符或加载程序图标，或尝试正确异步提取+渲染。

一些小提示:)

* [**componentWillMount**](https://facebook.github.io/react/docs/component-specs.html#mounting-componentwillmount) 在客户端和服务端都能被调用，并且这个调用发生在组件渲染之前，你可以在这个生命周期里面请求数据
* 允许你在组件里面请求数据，然后在服务器渲染之前访问他。这就意味着像 Component.fetchData() (一些你会在组件里面定义的东西)会在渲染之前请求数据，这种方式也会和 React-Route 配合使用。请求在服务器上执行，然后等待，最后渲染。这与在客户端在重新渲染之前等待请求数据不同。
* 对于 [React Router 上的异步数据流]，我在 SSR 中使用了几次。您在您的顶层组件中使用一个静态 fetchData 函数，它位于服务器端，并在渲染之前调用。 感谢React Router的match()，我们可以找回包含我们匹配的组件的所有 renderProps，并且循环遍历它们以捕获所有 fetchData 函数并在服务器上运行它们。 [ifelse](https://ifelse.io/2015/08/27/server-side-rendering-with-react-and-react-router/）也记录了包含数据获取的 React Router 的另一个SSR策略。
* [React Resolver](https://github.com/ericclemmons/react-resolver) 允许你在在每个组件级别定义数据需求，在客户端和服务器上处理嵌套的异步渲染。 它旨在产生纯净，无状态和易于测试的组件，详细请看[Resolving on the server](https://github.com/ericclemmons/react-resolver/blob/master/docs/getting-started/ServerRendering.md) 
* 你也可以在服务端使用 Redux Store 让数据变得容易管理。一种常见的方法是使用异步Action Creators 从服务器请求数据。 这可以在 componentWillMount 上调用，您可以使用 Redux reducer 存储操作中的数据，将组件连接到 Redux reducer 并触发渲染更改。 关于他们的几个想法，参见[这个](https://www.reddit.com/r/reactjs/comments/3gplr2/how_do_you_guys_fetch_data_for_a_react_app_fully)的Reddit线程。 Static[也由Redux推荐](http://redux.js.org/docs/recipes/ServerRendering.html) ,如果使用 React Route, “您可能还想把您的数据获取依赖作为静态fetchData()方法作为路由处理组件。 他们可能返回异步动作，所以你的handleRender 函数可以匹配路由到路由处理程序组件类，dispatch fetchData() 之后产生结果，并只有在 Promises resolved 之后才渲染。
* [异步 Props](https://github.com/ryanflorence/async-props#server)提供在屏幕加载之前获取它的本地数据。它还支持在服务器上工作
* Heroku 的 [React Refetch](https://github.com/heroku/react-refetch) 是另外一个试图帮助这个领域的项目。它将组件包装在 connect() 装饰器中，而不是映射state到 props，它将 props 映射到URL（允许组件是无状态的）

### 再一次保卫全局变量(Guarding against globals)

当通用渲染时，我们还需要记住，该节点没有 **document** 或 **window** 来使用。 [react-dom](https://www.npmjs.com/package/react-dom)似乎解决了这个问题，但如果你使用第三方组件，你需要注意依赖 document, window 等，需要包装或保护。

如果依赖于 [Web Storage](https://developer.mozilla.org/en-US/docs/Web/API/Web_Storage_API) 等这些浏览器API，这可能会捆绑住您。 在ReactHN中，我们最终如下：

``` javascript
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
```

注意：虽然上面是一个合理的方法，一个更好的方法是使用 package.json中 的“browser” 这个属性， [然后利用 Webpack 使用这些信息](https://github.com/webpack/webpack/issues/151)自动生成浏览器与节点的版本。实际上，这意味着创建一个“component.js”和“component-browser.js”，并包含一个“browser”属性，如下

``` javascript
      "browser": {
        "/path/to/component.js": "/path/to/component-browser.js"
      }
```

这是看上去是挺好的，因为没有冗余的代码，Node发送到浏览器，如果你做代码覆盖（例如使用Instanbul），没有必要在所有地方添加ignore语句
 
### 谨记：交互是关键(Remember: interactivity is key)

#### 服务器渲染很像给用户一个热苹果派。 它看起来准备好了，但这并不意味着他们可以与它进行交互(Server rendering is a lot like giving users a hot apple pie. It looks ready but that doesn’t mean they can interact with it.)

![](https://cdn-images-1.medium.com/max/1200/1*Znj9U-1dPk3L1WtlthETUg.png)

渐进式的渲染如上图所示

我们的用户界面可能包含按钮，链接和表格，由于需要的 JS 可能没有加载，在一些场景下点击按钮的时候可能不会产生任何效果。 可以以 [layers](https://soledadpenades.com/2016/09/15/progressive-enhancement-does-not-mean-works-when-javascript-is-disabled/) 的形式为这些功能提供基本体验。一个解决这个问题的比较前瞻性的方法可能通过渐进渲染和引导**聚焦在互动**。

这意味着您可以在HTML中为包括JS和CSS的路由发送功能上可行但最小的视图。 随着更多的资源到达，应用程序逐步解锁更多的功能。 我们在[第2部分]中讨论了这个概念和实现它的模式[PRPL](https://medium.com/@addyosmani/progressive-web-apps-with-react-js-part-2-page-load-性能-33b932d97cf2)。

#### 实践：ReactHN(Practical implementation: ReactHN)

![](https://cdn-images-1.medium.com/max/1200/1*HFaR46vKjYoiWgufKXXejQ.png)


没有 JS，链接指向是这样的：`/story/:id`，有 JS 的情况下，链接的指向是这样的：`#/story/:id`

[ReactHN](https://react-hn.appspot.com/)通过提供我们的主页和评论页面的服务器端渲染解决了PE。 **可以使用常规锚标签**在这两个之间导航。 当加载路由的JavaScript时，它将接管页面，所有后续导航将使用 SPA 样式模型进行导航 - 使用JS提取内容，并利用已使用Service Worker缓存的应用程序shell。 由于基于路由的分块，我们的[下一个版本](https://twitter.com/addyosmani/status/784957162128744448)还确保ReactHN变得很快交互。

**一些其他我们需要学习的东西：**

* **在服务器和客户端的PWA之间寻求100％的平衡是绝对不需要的。**在React HN中，我们注意到两个最受欢迎的页面是故事和评论。 我们为这两个部分实现了服务器渲染，否则完全是客户端渲染不太受欢迎的视图，如用户配置文件。 当我们使用Service Worker缓存它们时，他们仍然可以立即加载重复访问。
* **留下一些功能(明智的)**。我们的客户端评论页面可以实时更新，以黄色新发布的评论突出显示。这样把这部分 JS 留在服务器上更有意义。

### 测试渐进式增强(Testing Progressive Enhancement)

![](https://cdn-images-1.medium.com/max/1600/1*oWnsYNhEtyc3Sc8dtoWbAg.png)

Chrome DevTools 支持通过“设置”面板设置网络限制和禁用JS


尽管现代调试工具（如Chrome DevTools）支持直接禁用 JavaScript，但我强烈建议使用[网络限制]进行测试(https://developers.google.com/web/tools/chrome-devtools/network-performance/network- 条件)。 这更好地反映了用户能够多久查看并与您的渐进式增强应用进行交互。 它还提供了一个开放的视图，只是运输最小功能代码的影响，以获得路由启动，完美的服务器端渲染实现等。

### 阅读拓展

下面是一些我找到的与 PE、SSR 相关的优秀文章:

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

在本系列的第5部分中，我们将介绍如何进一步减少React.js包的大小，提高负载性能，以及帮助您的渐进增强更早地实现。

如果你是 React 新手，建议你阅读 Wes Bos 的 [给新手的 React 指南](https://goo.gl/G1WGxU)

