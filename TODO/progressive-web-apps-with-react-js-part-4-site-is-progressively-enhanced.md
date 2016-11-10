> * 原文地址：[Progressive Web Apps with React.js: Part 4 — Progressive Enhancement](https://medium.com/@addyosmani/progressive-web-apps-with-react-js-part-4-site-is-progressively-enhanced-b5ad7cf7a447#.7fmhi469z)
* 原文作者：[Addy Osmani](https://medium.com/@addyosmani)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Progressive Web Apps with React.js: Part 4 — Progressive Enhancement






### Progressive Enhancement

> Progressive enhancement means that everyone can access the **basic content** and functionality of a page in any browser, and those without certain browser features may receive a reduced but still functional experience — Lighthouse

Well built web apps should work for the majority of users in that market. If they are built for resilience, they can avoid users staring at a white screen for seconds on first load, rather than the basic content for the experience:













![](https://cdn-images-1.medium.com/max/2000/1*1ORn_gBszpIr5grUWB1k_A.png)



A [comparison](https://www.webpagetest.org/video/compare.php?tests=161010_Y3_1CPD,161010_SF_1C24) of rendering strategies for ReactHN. It’s _important to note YMMV — server-side rendering HTML for an entire view may make sense for content-heavy sites but this comes at a cost. On repeat visits, client-side rendering with an application shell architecture that is cached locally might perform better. Measure what makes sense for you._







Aaron Gustafson, a web standards advocate, likened [progressive enhancement](http://alistapart.com/article/understandingprogressiveenhancement) (PE) to a peanut M&M. The peanut is your content, the chocolate coating is your presentation layer and your JavaScript is the hard candy shell. This layer can vary in color and the experience can vary depending on the capabilities of the browser using it.

Think of the candy shell as where many Progressive Web App features can live. They are experiences that combine the best of the web and the best of apps. They are useful to users from the very first visit in a browser tab, no install required. As the user builds a relationship with these apps through repeated use, they make the candy shell even sweeter.









![](https://cdn-images-1.medium.com/max/1200/1*I_VmDeAtxyCc9ZaqkRcvEw.png)



If your PWA is progressively enhanced and contains content when scripts are unavailable, Lighthouse will give you the all clear.



**In my view, PE is** [**_not_ about making the web work for users without JavaScript turned on**](https://jakearchibald.com/2013/progressive-enhancement-is-faster/)**, nor** [**SEO**](https://plus.google.com/+JohnMueller/posts/LT4fU7kFB8W)**, but about making it resilient to** [**lie-fi**](https://twitter.com/jaffathecake/status/733283736343576576) **and spotty network connectivity blocking users from getting a meaningful experience.** When it comes to PE with JavaScript libraries and frameworks, server-side rendering is a useful tool in your arsenal.

### Universal rendering

**So, what is** [**Server-side rendering**](http://andrewhfarmer.com/server-side-render/) **(SSR) again?** Modern web apps typically render most or all of their content using client-side JavaScript. This means first render is blocked not only by fetching your HTML file (and its JS and CSS dependencies), but by executing JavaScript code. With SSR, the initial content for the page is generated on the server so the browser can fetch a page with HTML content already there.

[Universal JavaScript](https://strongloop.com/strongblog/node-js-react-isomorphic-javascript-why-it-matters/) is where you server-side render the markup for your JavaScript app on the server & pipe it down as the complete HTML to the browser. JavaScript can then take over (or hydrate) the page to bootstrap the interactive portions. Effectively it enables code sharing on the server and client and in React, gives us a way to server-side render code giving us “free” progressive enhancement.

This concept is [popular](https://www.smashingmagazine.com/2015/04/react-to-the-future-with-isomorphic-apps/) in the React community for several reasons: the application can render content to the screen faster without the network being a bottleneck, it works even if JavaScript fails to load on spotty connections and it allows the client to progressively hydrate to a better experience with the JS does finally kick in.

React makes universal rendering relatively straight-forward thanks to [**renderToString()**](http://facebook.github.io/react/docs/top-level-api.html#reactdomserver.rendertostring) (which renders a component to its initial HTML), however there are a number of steps you usually have to work through to get this setup. A couple of [guides](https://ifelse.io/2015/08/27/server-side-rendering-with-react-and-react-router/) walk through getting SSR setup, including one we’ll be walking through shortly.

_Related: Universal routing refers to the ability to recognize views associated with a route from both the client and server (_[_React Router supports this very well_](https://github.com/ReactTraining/react-router/blob/master/docs/guides/ServerRendering.md)_). Universal data fetching refers to accessing data (e.g an API) through both the client and server. I use_ [_isomorphic-fetch_](https://www.npmjs.com/package/isomorphic-fetch) _(based on the Fetch API polyfill) for this._









![](https://cdn-images-1.medium.com/max/1200/1*hXtLt6n7FYlkLQ-pd3e3Yg.png)



The [Selio](https://selio.com/) Progressive Web App uses Universal rendering to ship a static version of their experience that works without JS if the network is taking time to load it up but can hydrate to improve the experience once all scripts are loaded.



Specific to the [Application Shell architecture](https://developers.google.com/web/fundamentals/architecture/app-shell), you can use Universal rendering to render your Shell on the server _as well as_ the content (e.g article text) if you find that’s important to your users. How and what you ultimately decide to server-render is your call.









![](https://cdn-images-1.medium.com/max/1600/0*bIfkiNN8A_q3plJh.)





Other PWAs, like Housing, [Flipkart](https://speakerdeck.com/abhinavrastogi/next-gen-web-scaling-progressive-web-apps) and AliExpress serve down a server-rendered shell with [skeleton screens](http://www.lukew.com/ff/entry.asp?1797) to make it feel like content is loading immediately even when it isn’t. This improves perceived performance.

_Note: Server-rendering can mean_ **_more work_** _for your server and can increase the complexity of your codebase as your React components will need Node to be available. Keep this in mind when making a call on whether SSR is feasible for you. Devon Lindsey has a great talk on_ [_SSR perf with React_](https://www.youtube.com/watch?v=PnpfGy7q96U) _worth watching._

Enough with the theory, let’s dive into some code!

### Universal Rendering with React Router

[_Pro React_](http://www.pro-react.com/) _(by Cassio Zen) has a fantastic chapter on Isomorphic JS with React and I recommend checking it out. This section is modeled on a simpler version of the Pro React Isomorphic chapter updated for more recent versions of React Router._

React has baked-in support for server rendering components using [ReactDOMServer.renderToString()](https://facebook.github.io/react/docs/top-level-api.html#reactdomserver.rendertostring). Given a component, it will generate the HTML markup to be shipped down to the browser. React can take this markup and using [ReactDOM.render()](https://facebook.github.io/react/docs/top-level-api.html#reactdom.render) hydrate it, attach events, make it interactive and provide a fast first paint on first load.

Rendering a React component with Express might look a little like this for a hypothetical Hacker News App.

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

Mounting React so it works with server-rendered components requires that we supply the **same props on both the client and server** otherwise React will have no choice but to rerender the DOM and you’ll see React complain about this. It will also have an impact on the perceived user experience. But the problem is: How do we make the data that the server passed as props also available on the client, so it can be passed as props as well? One common pattern is injecting all the props needed into a script tag in our main HTML file. Our client-side JS can then use these props directly. We’ll refer to this as the “boot-up data” or “initial data”.

Here’s an example of an index page using EJS templating where one script has the initial data and props required by our React components and the other contains the rest of our React app bundle.

    <! — index.html →
    

    
     
    
    

And over in our Express code we can populate our bootup data as follows:

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

    import React from 'react';
    import { render } from 'react-dom';
    import HackerNewsApp from './app/HackerNewsApp';

    let bootupData = document.getElementById('bootupData').textContent;
    if (bootupData !== undefined) {
        bootupData = JSON.parse(bootupData);
    }

    render(, document.getElementById('container'));

This enables our client-side React code to mount our server-rendered component.

#### Universal Data-fetching

A typical SPA will have many routes but it doesn’t make sense to load up data for **all** of our routes at once. Instead, we need the server to understand what data is required by the components mapping to the current route on so we can serve exactly what is needed. We also need to dynamically fetch data if the user transitions from one route to another. This means we need a strategy that supports both data fetching on the client and data *pre*fetching on the server.

A common solution to universal data-fetching is using [React’s support for ‘statics’](https://facebook.github.io/react/docs/component-specs.html) to create a static ‘fetchData’ method on each component defining what data it needs. This method can be accessed at all times, even if a component has yet to be instantiated, which is important for prefetching to work.

Below is a quick snippet of updating a component to use a static fetchData method. We can also take advantage of componentDidMount on the client to check whether the server supplied our bootupData (or whether we need to fetch the bootup data ourselves).

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

[React Router](https://github.com/ReactTraining/react-router) has supported server-rendering since 1.0\. Unlike client-side rendering there are a few additions concerns to think about, like sending 30x responses for redirects and fetching data before rendering. To help with these problems, we can use the lower-level API which gives us [match](https://github.com/ReactTraining/react-router/blob/master/docs/API.md#match-routes-location-history-options--cb) for matching routes to a location without rendering and [RouterContext](https://github.com/ReactTraining/react-router/blob/master/docs/API.md) for sync rendering of route components.

We can also iterate through our renderProps to check for the existence of a static fetchData method, prefetching data and passing it as props if present. In Express, we’ll also need to change the entry points for our routes from “/” to the wildcard “*” to ensure all routes a user lands on invoke the right callback.

Looking at a hypothetical server.js again:

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

### Data-flow tips

When using React on the server, it’s not possible to request data in [componentDidMount](https://facebook.github.io/react/docs/component-specs.html) (as you would in the browser). That code doesn’t get called by renderToString and if it was possible for it to, your async data requests wouldn’t be serializable as Jonas has pointed out in his [Isomorphic React in Real Life](https://jonassebastianohlsson.com/blog/2015/03/24/isomorphic-react-in-real-life/) post (which you should read).

For asynchronous data, the answer is “it’s a little more complicated”. You can set initial state indicating user data is being fetched, like a placeholder or loader icon or try to properly async fetch + render.

A few tips:

*   [**componentWillMount**](https://facebook.github.io/react/docs/component-specs.html#mounting-componentwillmount) is invoked both on the client and server right before rendering of your components occur. You can use this for fetching data before rendering.
*   [**statics**](http://facebook.github.io/react/docs/component-specs.html#statics) allow you to define data requests inside components but access them before rendering on the server. This enables calling something like Component.fetchData() (something you would define inside statics for Component) to access requests before they are rendered and generally works with React Router well too. Requests get executed on the server, we wait on them and then render React. This is the opposite of rendering React on the client and waiting for the data before re-rendering.
*   For **async data flow with React Router** [this](http://stackoverflow.com/a/34955577) is a strategy I have used a few times that plays well with SSR. You use a static fetchData function in your top-level component which you find server-side and invoke before rendering. Thanks to React Router’s match(), we can get back all the renderProps containing our matched components and just loop over them to grab all fetchData functions and run them on the server. [ifelse](https://ifelse.io/2015/08/27/server-side-rendering-with-react-and-react-router/)also documents another strategy for SSR with React Router that includes data fetching.
*   [React Resolver](https://github.com/ericclemmons/react-resolver) allows you to define data requirements on a per-component level, handling nested async rendering on both the client and the server. It aims to result in components that are pure, stateless and easy to test. See [Resolving on the server](https://github.com/ericclemmons/react-resolver/blob/master/docs/getting-started/ServerRendering.md) for an example of what this might look like to setup.
*   You can also use [Redux stores](https://medium.com/@navgarcha7891/react-server-side-rendering-with-simple-redux-store-hydration-9f77ab66900a) for data hydration on the server. A common approach is to use async action creators to request data from the server. This can be called on componentWillMount, where you can have a Redux reducer store data from the action, connect your component to the Redux reducer and trigger a render change. For a few more ideas on this space, see [this](https://www.reddit.com/r/reactjs/comments/3gplr2/how_do_you_guys_fetch_data_for_a_react_app_fully/) Reddit thread. Statics are [also recommended by Redux](http://redux.js.org/docs/recipes/ServerRendering.html) if using React Router “you might also want to express your data fetching dependencies as static fetchData() methods on your route handler components. They may return async actions, so that your handleRender function can match the route to the route handler component classes, dispatch fetchData() result for each of them, and render only after the Promises have resolved.”
*   [Async Props](https://github.com/ryanflorence/async-props#server) provides co-located data fetching it before new screens load. It also supports working on the server.
*   [React Refetch](https://github.com/heroku/react-refetch) by Heroku is another project that attempts to help in this space. It wraps components in a connect() decorator but rather than mapping state to props it maps props to URLs to props (allowing components to be stateless).

### Guarding against globals

When Universal rendering, we also need to remember that node has no notion of a **document** or **window** object to use. [react-dom](https://www.npmjs.com/package/react-dom) seems to solve this problem, but if you’re using third-party components you need to watch out for dependencies relying on window/document/etc that require wrapping or guarding.

This might catch you out if relying on browser APIs such as [Web Storage](https://developer.mozilla.org/en-US/docs/Web/API/Web_Storage_API). In ReactHN, we ended up doing this as follows:

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

      "browser": {
        "/path/to/component.js": "/path/to/component-browser.js"
      }

_This is nice because there’s no unnecessary code for Node shipped to the browser and if you’re doing code coverage (e.g with Instanbul) there’s no need to add ignore statements all over the place._

### Remember: interactivity is key

#### Server rendering is a lot like giving users a hot apple pie. It looks ready but that doesn’t mean they can interact with it.









![](https://cdn-images-1.medium.com/max/1200/1*Znj9U-1dPk3L1WtlthETUg.png)



Progressive Bootstrapping as visually [illustrated](https://twitter.com/aerotwist/status/729712502943174657) by Paul Lewis



Your user-interface might include buttons, links and forms that don’t do anything when tapped because the JS required for this behavior hasn’t loaded in time. A basic experience can be offered for these features in the form of [layers](https://soledadpenades.com/2016/09/15/progressive-enhancement-does-not-mean-works-when-javascript-is-disabled/). A forward-thinking way of tackling this problem maybe **focusing on interactivity**through **Progressive rendering & bootstrapping.**

















This means you send a functionally viable, but minimal, view in HTML for a route including JS and CSS. As more resources arrive, the app progressively unlocks more features. We covered this concept and a pattern that implements it (PRPL) in [Part 2](https://medium.com/@addyosmani/progressive-web-apps-with-react-js-part-2-page-load-performance-33b932d97cf2) of this series.

#### Practical implementation: ReactHN









![](https://cdn-images-1.medium.com/max/1200/1*HFaR46vKjYoiWgufKXXejQ.png)



Without JS: links point to /story/:id. With JS: links point to #/story/:id



[ReactHN](https://react-hn.appspot.com/) tackled PE by offering up server-side rendered versions of our homepage and comment pages. **It was possible to navigate between these two using regular anchor tags**. When the JavaScript for a route was loaded, it would hydrate the view and all subsequent navigations would use an SPA-style model for navigation — fetching content using JS and taking advantage of the application shell already being cached using Service Worker. Thanks to route-based chunking, our [next version](https://twitter.com/addyosmani/status/784957162128744448) also ensures that ReactHN becomes interactive really quickly.

**Other things we learned:**

*   **100% parity between the server and client-rendered versions of your PWA is absolutely not a requirement.** In React HN, we noticed the two most popular views were stories and comments. We implemented server-rendering for these two parts and otherwise fully client-side render less popular views like User Profiles. As we’re caching them using Service Worker, they can still load instantly on repeat visits.
*   **Feel free to leave out some features (layer wisely!)**. Our client-side comments page can update in real-time, highlighting in yellow newly posted comments. This made more sense with JS and was left out on the server.

### Testing Progressive Enhancement









![](https://cdn-images-1.medium.com/max/1600/1*oWnsYNhEtyc3Sc8dtoWbAg.png)



Chrome DevTools supports both network throttling and disabling JS via the Settings panel



Although modern debugging tools (like the Chrome DevTools) support disabling JavaScript outright, I would strongly encourage testing with [network throttling](https://developers.google.com/web/tools/chrome-devtools/network-performance/network-conditions) on instead. This better reflects how soon a user will be able to view and interact with your PWA. It also provides an eye-opening view on the impact of just shipping the minimal function code to get a route booted up, perf of your server-side rendering implementation and so on.

### Further Reading

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

If you’re new to React, I’ve found [**React for Beginners**](https://goo.gl/G1WGxU) by Wes Bos excellent.

_With thanks to Nolan Lawson, Cassio Zen, Gray Norton, Sean Larkin, Sunil Pai, Max Stoiber, Simon Boudrias, Jack Franklin, Kyle Mathews and Owen Campbell-Moore for their reviews._





