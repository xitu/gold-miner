> * 原文地址：[Universal JavaScript Apps with React Router 4](https://ebaytech.berlin/universal-web-apps-with-react-router-4-15002bb30ccb#.jtt34pxx5)
* 原文作者：[Patrick Hund](https://ebaytech.berlin/@wiekatz)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： 
* 校对者：

# Universal JavaScript Apps with React Router 4

## How to use the latest version of React Router both on the server side and the client side

![](https://cdn-images-1.medium.com/max/800/1*BBX9uxldn-I7nVC-0Mkoyw.png)

[React Router](https://github.com/ReactTraining/react-router/tree/v4) is the most popular library in React-land for rendering different page contents depending on request URLs and manipulating the browser history to keep the URL displayed in the location bar in sync with your app as the user interacts with the page.

### Shiny and New

Recently, version 4 of React Router entered the beta release phase. Bemoaned by some, applauded by others, it is a complete rewrite of the previous version with lots of breaking API changes.

The key idea behind version 4 is “declarative composability” — it embraces the component concept that makes React so great and applies it to routing. Every part of React Router 4 is a React component: [Router](https://reacttraining.com/react-router/#router), [Route](https://reacttraining.com/react-router/#route), [Link](https://reacttraining.com/react-router/#link), etc.

One of the React Router developers, [Ryan Florence](https://medium.com/@ryanflorence), made a short hands-on video introduction to the latest React Router, which I highly recommend:

[![](https://i.ytimg.com/vi_webp/a4kqMQorcnE/maxresdefault.webp)](https://www.youtube.com/embed/a4kqMQorcnE?wmode=opaque&widget_referrer=https%3A%2F%2Febaytech.berlin%2Fmedia%2Feef8fc9b113ad77be4f92d4457afbc37%3FpostId%3D15002bb30ccb&enablejsapi=1&origin=https%3A%2F%2Fcdn.embedly.com&widgetid=1)

### What About the Backend?

The new version of React Router comes with a new web page that has [lots of useful code examples](https://reacttraining.com/react-router/examples). One thing I miss, however, is a practical example on how to use React Router for rendering React-based pages on the server side.

For the project I’m currently working on, search-engine friendliness and optimal site speed are essential, so rendering the whole page on the client side — the way all the examples on the examples page do — is not feasible. We use an [Express](http://expressjs.com/) server to render our React pages in the backend.

In his intro video, Ryan has an *App* component that fetches data from some API to initialize its state, using the [componentDidMount](https://facebook.github.io/react/docs/react-component.html#componentdidmount) lifecycle method. When the asychronous data fetching is done, the component is updated to display that data.

But this doesn’t work when rendering the App component on the server side: when you use [renderToString](https://facebook.github.io/react/docs/react-dom-server.html#rendertostring), the string with HTML code is created synchronously, after calling the component’s render method once. *componentDidMount* is never called.

So if we rendered the App component from Ryan’s video example in the backend, it will just generate the “Loading…” message.

I struggled with this for some time and complained about it on Twitter:

[@Patrick Hund](https://twitter.com/wiekatz/status/828966343156305920?ref_src=twsrc%5Etfw)

Thankfully, Ryan replied to my tweet and pointed me in the right direction:

[@Ryan Florence](https://twitter.com/ryanflorence/status/829421261117730816?ref_src=twsrc%5Etfw)

### The Solution

As a proof of concept, I created a demo app that basically recreates Ryan’s example from the video using server-side rendering.

The app fetches data about Gist code snippets using the [GitHub API](https://developer.github.com/v3/):

![](https://cdn-images-1.medium.com/max/800/1*gTFNHBIV-7GBql17KNjeRg.png)

### Show Me the Code!

You can find the demo app’s source code here on GitHub:

[**GitHub - technology-ebay-de/universal-react-router4: Demo app showing how to use react-router v4…**](https://github.com/technology-ebay-de/universal-react-router4)

In a nutshell, here’s what I did…

#### server/index.js

This is the code that is run with every HTTP request to the Express server:

```
const routes = [
    '/',
    '/g/:gistId'
];

app.get('*', (req, res) => {
    const match = routes.reduce((acc, route) => matchPath(req.url, route, { exact: true }) || acc, null);
    if (!match) {
        res.status(404).send(render(<NoMatch />));
        return;
    }
    fetch('https://api.github.com/gists')
        .then(r => r.json())
        .then(gists => 
            res.status(200).send(render(
                (
                    <StaticRouter context={{}} location={req.url}>
                        <App gists={gists} />
                    </StaticRouter>
                ), gists
            ))
        ).catch(err => res.status(500).send(render(<Error />));
});

app.listen(3000, () => console.log('Demo app listening on port 3000'));
```

*(Note: this is just an excerpt — you can find the* [*full source code on GitHub*](https://github.com/technology-ebay-de/universal-react-router4/blob/master/src/server/index.js)*)*

In [lines 1–4](https://gist.github.com/pahund/f07b12859d3dacf87af81a7bb07a341e#file-server-js-L1-L4), I’m defining an array of routes for my app. The first one is for initial requests for the main page, without any Gists selected. The second route is for displaying a selected Gist.

In [line 6](https://gist.github.com/pahund/f07b12859d3dacf87af81a7bb07a341e#file-server-js-L6), my Express app is told to handle any request that comes in using an asterisk match.

In [line 7](https://gist.github.com/pahund/f07b12859d3dacf87af81a7bb07a341e#file-server-js-L7), I’m reducing my routes array using the [matchPath](https://reacttraining.com/react-router/#match) function from React Router; the result is a match object with information about the matching route and any parameters that may be parsed from the URL path.

In [lines 8–11](https://gist.github.com/pahund/f07b12859d3dacf87af81a7bb07a341e#file-server-js-L8-L11), if there is no matching route, I’m rendering an error page that says: “Page not found”.

The [render](https://github.com/technology-ebay-de/universal-react-router4/blob/master/src/server/render.js) function here is just a wrapper around React’s [renderToString](https://facebook.github.io/react/docs/react-dom-server.html#rendertostring) that adds the basic page HTML code around the React component’s HTML (*<html>*, *<head>*, *<body>*, etc.).

In [lines 12–22](https://gist.github.com/pahund/f07b12859d3dacf87af81a7bb07a341e#file-server-js-L12-L21), I’m fetching the data to populate my App’s state from the GitHub API and rendering my App component.

Most notably, in line 17 I’m using the [StaticRouter](https://reacttraining.com/react-router/#staticrouter) component to initialize React Router. This Router component type is the best choice for server-side rendering. It never changes its location, which is what we want in this case, since on the backend, we are just rendering once and not directly reacting to user interations.

[Line 23](https://gist.github.com/pahund/f07b12859d3dacf87af81a7bb07a341e#file-server-js-L22) catches any errors that accur during the process to render an error page, instead.

#### App.js

My App component looks like this:

```
export default ({ gists }) => (
    <div>
        <Sidebar>
            {
                gists ? gists.map(gist => (
                    <SidebarItem key={gist.id}>
                        <Link to={`/g/${gist.id}`}>
                            {gist.description || '[no description]'}
                        </Link>
                    </SidebarItem>
                )) : (<p>Loading…</p>)
            }
        </Sidebar>
        <Main>
            <Route path="/" exact component={Home} />
            {
                gists && (
                    <Route path="/g/:gistId" render={
                        ({ match }) => (
                            <Gist gist={gists.find(g => g.id === match.params.gistId)} />
                        )
                    } />
                )
            }
        </Main>
    </div>
);
```

*(→* *[*full source code on GitHub*](https://github.com/technology-ebay-de/universal-react-router4/blob/master/src/shared/App.js)* *)*

In [line 1](https://gist.github.com/pahund/abcf4a7dd18955356526bd4cf2fe7cee#file-app-js-L1), the component receives the gists data object as a prop.

[Lines 3–13](https://gist.github.com/pahund/abcf4a7dd18955356526bd4cf2fe7cee#file-app-js-L3-L13) render a [Sidebar](https://github.com/technology-ebay-de/universal-react-router4/blob/master/src/shared/Sidebar.js) component with links to the various Gists. The [SidebarItem](https://github.com/technology-ebay-de/universal-react-router4/blob/master/src/shared/SidebarItem.js) components contained within are only rendered if there is actually gist data available. On the server, this is always the case. We are, however, using this component for both server-side *and* client-side rendering. If the component is rendered in the client, we may be in the process of fetching fresh gist data, so we display a “Loading…” message instead.

[Line 15](https://gist.github.com/pahund/abcf4a7dd18955356526bd4cf2fe7cee#file-app-js-L15) uses a [Route](https://reacttraining.com/react-router/#route) component from the React Router library to display the [Home](https://github.com/technology-ebay-de/universal-react-router4/blob/master/src/shared/Home.js) component when the route matches the path “/”. We are using an exact match here, otherwise any path that simply starts with a slash would match.

If there is some gist data to display, in [line 18](https://gist.github.com/pahund/abcf4a7dd18955356526bd4cf2fe7cee#file-app-js-L18), another Route component is used to display a [Gist](https://github.com/technology-ebay-de/universal-react-router4/blob/master/src/shared/Gist.js) component with details about a selected gist.

#### client/index.js

As mentioned above, this is a [universal JavaScript](https://medium.com/@mjackson/universal-javascript-4761051b7ae9#.esxnb0ulu) application (f.k.a. “isomorphic”), meaning the same code is used to render pages on the server and on the client. Here is an excerpt from the code that initializes the page on the client side:

```
render((
    <BrowserRouter>
        <App gists={window.__gists__} />
    </BrowserRouter>
), document.getElementById('app'));
```

*(→[**full source code on GitHub**](https://github.com/technology-ebay-de/universal-react-router4/blob/master/src/client/index.js)\)*

Much simpler than the server-side version! The *render* function in [line 1](https://gist.github.com/pahund/7c8a3f92800003105ca38bf2cf7eb5b6#file-index-js-L1) is just the [render function of ReactDOM](https://facebook.github.io/react/docs/rendering-elements.html#rendering-an-element-into-the-dom). It attaches the layout rendered by my React components to a DOM node.

In [line 2](https://gist.github.com/pahund/7c8a3f92800003105ca38bf2cf7eb5b6#file-index-js-L2), I’m now using the [BrowserRouter](https://reacttraining.com/react-router/#browserrouter) (instead of the StaticRouter I used for server-side rendering).

Instead of fetching the initial data from the GitHub API, in [line 3](https://gist.github.com/pahund/7c8a3f92800003105ca38bf2cf7eb5b6#file-index-js-L3) I’m instantiating my App component with gist data from a global variable in the browser DOM, which the backend put there via a *<script>* tag.

### That’s basically it!

When I open up my app in the browser, I can click on any of the Gists in the sidebar. The client-side React Router makes sure that with each click on a link, the page’s URL is updated and the parts of the page dependent on the new URL are re-rendered. When I hit the browser’s reload button, the backend’s static router makes sure that the same page with the correct data is displayed.
