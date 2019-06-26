> * 原文地址：[Micro Frontends](https://martinfowler.com/articles/micro-frontends.html)
> * 原文作者：[Cam Jackson](https://camjackson.net/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-3.md](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-3.md)
> * 译者：
> * 校对者：

# 微前端：未来前端开发的新趋势 — 第三部分

做好前端开发不是件容易的事情，而比这更难的是扩展前端开发规模以便于多个团队可以同时开发一个大型且复杂的产品。本系列文章将描述一种趋势，可以将大型的前端项目分解成许多个小而易于管理的部分，也将讨论这种体系结构如何提高前端代码团队工作的有效性和效率。除了讨论各种好处和代价之外，我们还将介绍一些可用的实现方案和深入探讨一个应用该技术的完整示例应用程序。

> **建议按照顺序阅读本系列文章：**
>
> * [微前端：未来前端开发的新趋势 — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-1.md)
> * [微前端：未来前端开发的新趋势 — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-2.md)
> * [微前端：未来前端开发的新趋势 — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-3.md)
> * [微前端：未来前端开发的新趋势 — 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-4.md)

## Cross-application communication

One of the most common questions regarding micro frontends is how to let them talk to each other. In general, we recommend having them communicate as little as possible, as it often reintroduces the sort of inappropriate coupling that we're seeking to avoid in the first place.

That said, some level of cross-app communication is often needed. [Custom events](https://developer.mozilla.org/en-US/docs/Web/Guide/Events/Creating_and_triggering_events) allow micro frontends to communicate indirectly, which is a good way to minimise direct coupling, though it does make it harder to determine and enforce the contract that exists between micro frontends. Alternatively, the React model of passing callbacks and data downwards (in this case downwards from the container application to the micro frontends) is also a good solution that makes the contract more explicit. A third alternative is to use the address bar as a communication mechanism, which we'll explore [in more detail later](https://martinfowler.com/articles/micro-frontends.html#Cross-applicationCommunicationViaRouting).

> If you are using redux, the usual approach is to have a single, global, shared store for the entire application. However, if each micro frontend is supposed to be its own self-contained application, then it makes sense for each one to have its own redux store. The redux docs even mention ["isolating a Redux app as a component in a bigger application"](https://redux.js.org/faq/store-setup#can-or-should-i-create-multiple-stores-can-i-import-my-store-directly-and-use-it-in-components-myself) as a valid reason to have multiple stores.

Whatever approach we choose, we want our micro frontends to communicate by sending messages or events to each other, and avoid having any shared state. Just like sharing a database across microservices, as soon as we share our data structures and domain models, we create massive amounts of coupling, and it becomes extremely difficult to make changes.

As with styling, there are several different approaches that can work well here. The most important thing is to think long and hard about what sort of coupling you're introducing, and how you'll maintain that contract over time. Just as with integration between microservices, you won't be able to make breaking changes to your integrations without having a coordinated upgrade process across different applications and teams.

You should also think about how you'll automatically verify that the integration does not break. Functional testing is one approach, but we prefer to limit the number of functional tests we write due to the cost of implementing and maintaining them. Alternatively you could implement some form of [consumer-driven contracts](https://martinfowler.com/articles/consumerDrivenContracts.html), so that each micro frontend can specify what it requires of other micro frontends, without needing to actually integrate and run them all in a browser together.

* * *

## Backend communication

If we have separate teams working independently on frontend applications, what about backend development? We believe strongly in the value of full-stack teams, who own their application's development from visual code all the way through to API development, and database and infrastructure code. One pattern that helps here is the [BFF](https://samnewman.io/patterns/architectural/bff/) pattern, where each frontend application has a corresponding backend whose purpose is solely to serve the needs of that frontend. While the BFF pattern might originally have meant dedicated backends for each frontend channel (web, mobile, etc), it can easily be extended to mean a backend for each micro frontend.

There are a lot of variables to account for here. The BFF might be self contained with its own business logic and database, or it might just be an aggregator of downstream services. If there are downstream services, it may or may not make sense for the team that owns the micro frontend and its BFF, to also own some of those services. If the micro frontend has only one API that it talks to, and that API is fairly stable, then there may not be much value in building a BFF at all. The guiding principle here is that the team building a particular micro frontend shouldn't have to wait for other teams to build things for them. So if every new feature added to a micro frontend also requires backend changes, that's a strong case for a BFF, owned by the same team.

![A diagram showing three pairs of frontends / backends. The first backend talks only to its own database. The other two backends talk to shared downstream services. Both approaches are valid.](https://martinfowler.com/articles/micro-frontends/bff.png)

Figure 7: There are many different ways to structure your frontend/backend relationships

Another common question is, how should the user of a micro frontend application be authenticated and authorised with the server? Obviously our customers should only have to authenticate themselves once, so auth usually falls firmly in the category of cross-cutting concerns that should be owned by the container application. The container probably has some sort of login form, through which we obtain some sort of token. That token would be owned by the container, and can be injected into each micro frontend on initialisation. Finally, the micro frontend can send the token with any request that it makes to the server, and the server can do whatever validation is required.

* * *

## Testing

We don't see much difference between monolithic frontends and micro frontends when it comes to testing. In general, whatever strategies you are using to test a monolithic frontend can be reproduced across each individual micro frontend. That is, each micro frontend should have its own comprehensive suite of automated tests that ensure the quality and correctness of the code.

The obvious gap would then be integration testing of the various micro frontends with the container application. This can be done using your preferred choice of functional/end-to-end testing tool (such as Selenium or Cypress), but don't take things too far; functional tests should only cover aspects that cannot be tested at a lower level of the [Test Pyramid](https://martinfowler.com/bliki/TestPyramid.html). By that we mean, use unit tests to cover your low-level business logic and rendering logic, and then use functional tests just to validate that the page is assembled correctly. For example, you might load up the fully-integrated application at a particular URL, and assert that the hard-coded title of the relevant micro frontend is present on the page.

If there are user journeys that span across micro frontends, then you could use functional testing to cover those, but keep the functional tests focussed on validating the integration of the frontends, and not the internal business logic of each micro frontend, which should have already been covered by unit tests. [As mentioned above,](https://martinfowler.com/articles/micro-frontends.html#Cross-applicationCommunication) consumer-driven contracts can help to directly specify the interactions that occur between micro frontends without the flakiness of integration environments and functional testing.

* * *

## The example in detail

Most of the rest of this article will be a detailed explanation of just one way that our example application can be implemented. We'll focus mostly on how the container application and the micro frontends [integrate together using JavaScript](https://martinfowler.com/articles/micro-frontends.html#Run-timeIntegrationViaJavascript), as that's probably the most interesting and complex part. You can see the end result deployed live at [https://demo.microfrontends.com](https://demo.microfrontends.com), and the full source code can be seen on [Github](https://github.com/micro-frontends-demo).

![A screenshot of the 'browse' landing page of the full micro frontends demo application](https://martinfowler.com/articles/micro-frontends/screenshot-browse.png)

Figure 8: The 'browse' landing page of the full micro frontends demo application

The demo is all built using React.js, so it's worth calling out that React does **not** have a monopoly on this architecture. Micro frontends can be implemented with with many different tools or frameworks. We chose React here because of its popularity and because of our own familiarity with it.

### The container

We'll start with [the container](https://github.com/micro-frontends-demo/container), as it's the entry point for our customers. Let's see what we can learn about it from its `package.json`:

```
{
  "name": "@micro-frontends-demo/container",
  "description": "Entry point and container for a micro frontends demo",
  "scripts": {
    "start": "PORT=3000 react-app-rewired start",
    "build": "react-app-rewired build",
    "test": "react-app-rewired test"
  },
  "dependencies": {
    "react": "^16.4.0",
    "react-dom": "^16.4.0",
    "react-router-dom": "^4.2.2",
    "react-scripts": "^2.1.8"
  },
  "devDependencies": {
    "enzyme": "^3.3.0",
    "enzyme-adapter-react-16": "^1.1.1",
    "jest-enzyme": "^6.0.2",
    "react-app-rewire-micro-frontends": "^0.0.1",
    "react-app-rewired": "^2.1.1"
  },
  "config-overrides-path": "node_modules/react-app-rewire-micro-frontends"
}
```

From the dependencies on `react` and `react-scripts`, we can conclude that it's a React.js application created with [`create-react-app`](https://facebook.github.io/create-react-app/). More interesting is what's **not** there: any mention of the micro frontends that we're going to compose together to form our final application. If we were to specify them here as library dependencies, we'd be heading down the path of build-time integration, which [as mentioned previously](https://martinfowler.com/articles/micro-frontends.html#Build-timeIntegration) tends to cause problematic coupling in our release cycles.

> In version 1 of `react-scripts` it was possible to have multiple applications coexist on a single page without conflicts, but version 2 uses some webpack features that cause errors when two or more apps try to render themselves on the one page. For this reason we use `react-app-rewired` to override some of the internal webpack config of `react-scripts`. This fixes those errors, and lets us keep relying on `react-scripts` to manage our build tooling for us.

To see how we select and display a micro frontend, let's look at `App.js`. We use [React Router](https://reacttraining.com/react-router/) to match the current URL against a predefined list of routes, and render a corresponding component:

```
<Switch>
  <Route exact path="/" component={Browse} />
  <Route exact path="/restaurant/:id" component={Restaurant} />
  <Route exact path="/random" render={Random} />
</Switch>
```

The `Random` component is not that interesting - it just redirects the page to a randomly selected restaurant URL. The `Browse` and `Restaurant` components look like this:

```
const Browse = ({ history }) => (
  <MicroFrontend history={history} name="Browse" host={browseHost} />
);
const Restaurant = ({ history }) => (
  <MicroFrontend history={history} name="Restaurant" host={restaurantHost} />
);
```

In both cases, we render a `MicroFrontend` component. Aside from the history object (which will become important later), we specify the unique name of the application, and the host from which its bundle can be downloaded. This config-driven URL will be something like `http://localhost:3001` when running locally, or `https://browse.demo.microfrontends.com` in production.

Having selected a micro frontend in `App.js`, now we'll render it in `MicroFrontend.js`, which is just another React component:

```
class MicroFrontend extends React.Component {
  render() {
    return <main id={`${this.props.name}-container`} />;
  }
}
```

This is not the entire class, we'll be seeing more of its methods soon.

When rendering, all we do is put a container element on the page, with an ID that's unique to the micro frontend. This is where we'll tell our micro frontend to render itself. We use React's `componentDidMount` as the trigger for downloading and mounting the micro frontend:

> `componentDidMount` is a lifecycle method of React components, which is called by the framework just after an instance of our component has been 'mounted' into the DOM for the first time.

class MicroFrontend…

```
  componentDidMount() {
    const { name, host } = this.props;
    const scriptId = `micro-frontend-script-${name}`;

    if (document.getElementById(scriptId)) {
      this.renderMicroFrontend();
      return;
    }

    fetch(`${host}/asset-manifest.json`)
      .then(res => res.json())
      .then(manifest => {
        const script = document.createElement('script');
        script.id = scriptId;
        script.src = `${host}${manifest['main.js']}`;
        script.onload = this.renderMicroFrontend;
        document.head.appendChild(script);
      });
  }
```

> We have to fetch the script's URL from an asset manifest file, because `react-scripts` outputs compiled JavaScript files that have hashes in their filename to facilitate caching.

First we check if the relevant script, which has a unique ID, has already been downloaded, in which case we can just render it immediately. If not, we fetch the `asset-manifest.json` file from the appropriate host, in order to look up the full URL of the main script asset. Once we've set the script's URL, all that's left is to attach it to the document, with an `onload` handler that renders the micro frontend:

class MicroFrontend…

```
  renderMicroFrontend = () => {
    const { name, history } = this.props;

    window[`render${name}`](`${name}-container`, history);
    // E.g.: window.renderBrowse('browse-container, history');
  };
```

In the above code we're calling a global function called something like `window.renderBrowse`, which was put there by the script that we just downloaded. We pass it the ID of the `<main>` element where the micro frontend should render itself, and a `history` object, which we'll explain soon. **The signature of this global function is the key contract between the container application and the micro frontends**. This is where any communication or integration should happen, so keeping it fairly lightweight makes it easy to maintain, and to add new micro frontends in the future. Whenever we want to do something that would require a change to this code, we should think long and hard about what it means for the coupling of our codebases, and the maintenance of the contract.

There's one final piece, which is handling clean-up. When our `MicroFrontend` component un-mounts (is removed from the DOM), we want to un-mount the relevant micro frontend too. There is a corresponding global function defined by each micro frontend for this purpose, which we call from the appropriate React lifecycle method:

class MicroFrontend…

```
  componentWillUnmount() {
    const { name } = this.props;

    window[`unmount${name}`](`${name}-container`);
  }
```

In terms of its own content, all that the container renders directly is the top-level header and navigation bar of the site, as those are constant across all pages. The CSS for those elements has been written carefully to ensure that it will only style elements within the header, so it shouldn't conflict with any styling code within the micro frontends.

And that's the end of the container application! It's fairly rudimentary, but this gives us a shell that can dynamically download our micro frontends at runtime, and glue them together into something cohesive on a single page. Those micro frontends can be independently deployed all the way to production, without ever making a change to any other micro frontend, or to the container itself.

> **建议按照顺序阅读本系列文章：**
>
> * [微前端：未来前端开发的新趋势 — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-1.md)
> * [微前端：未来前端开发的新趋势 — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-2.md)
> * [微前端：未来前端开发的新趋势 — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-3.md)
> * [微前端：未来前端开发的新趋势 — 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-4.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
