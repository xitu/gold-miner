
> * 原文地址：[Server-Side React Rendering](https://css-tricks.com/server-side-react-rendering/)
> * 原文作者：[Roger Jin](https://css-tricks.com/author/rogerjin/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/server-side-react-rendering.md](https://github.com/xitu/gold-miner/blob/master/TODO/server-side-react-rendering.md)
> * 译者：
> * 校对者：

# Server-Side React Rendering

React is best known as a client-side JavaScript framework, but did you know you can (and perhaps should!) render React server-side?

Suppose you've built a zippy new event listing React app for a client. The app is hooked up to an API built with your favorite server-side tool. A couple weeks later the client tells you that their pages aren't showing up on Google and don't look good when posted to Facebook. Seems solvable, right?

You figure out that to solve this you'll need to render your React pages from the server on initial load so that crawlers from search engines and social media sites can read your markup. There is evidence showing that Google sometimes executes javascript and can index the generated content, but not always. So server-side rendering is always recommended if you want to ensure good SEO and compatibility with other services like Facebook, Twitter.

In this tutorial, we'll take you through a server side rendering example step-by-step. including working around a common roadblock for React apps that talk to APIs.

#The Benefits of Server-Side Rendering

SEO might be the conversation that starts your team talking about server-side rendering, but it's not the only potential benefit.

Here's the big one: server-side rendering displays pages faster. With server-side rendering, your server's response to the browser is the HTML of your page that is ready to be rendered so the browser can start rendering without having to wait for all the JavaScript to be downloaded and executed. There's no "white page" while the browser downloads and executes the JavaScript and other assets needed to render the page, which is what might happen in an entirely client-rendered React site.

#Getting Started

Let's go through how to add server-side rendering to a basic client rendered React app with Babel and Webpack. Our app will have the added complexity of getting the data from a third-party API. We've provided starter code on GitHub where you can see the complete example.

The starter code has just one React component, hello.js, that makes an asynchronous request to the ButterCMS API and renders the returned JSON list of blog posts. ButterCMS is an API-based blog engine that's free for personal use, so it's great for testing out a real-life use case. The starter code comes hooked up with an API token, but if you want you can get your own API token by signing into ButterCMS with your GitHub account.

```
import React from 'react';
import Butter from 'buttercms'

const butter = Butter('b60a008584313ed21803780bc9208557b3b49fbb');

var Hello = React.createClass({
  getInitialState: function() {
    return {loaded: false};
  },
  componentWillMount: function() {
    butter.post.list().then((resp) => {
      this.setState({
        loaded: true,
        resp: resp.data
      })
    });
  },
  render: function() {
    if (this.state.loaded) {
      return (
        <div>
          {this.state.resp.data.map((post) => {
            return (
              <div key={post.slug}>{post.title}</div>
            )
          })}
        </div>
      );
    } else {
      return <div>Loading...</div>;
    }
  }
});

export default Hello;
```

Here's what else is included in the starter code:

- package.json - for dependencies
- Webpack and Babel configuration
- index.html - the HTML for the app
- index.js - loads React and renders the Hello component

To get the app running, first clone the repository:

```
git clone ...
cd ..
```

Install the dependencies:

```
npm install
```

Then start the development server:

```
npm run start
```

Browse to http://localhost:8000 to view the app: 

![](https://res.cloudinary.com/css-tricks/image/upload/c_scale,w_1000,f_auto,q_auto/v1497358286/localhost_r84tot.png)

If you view the source code of the rendered page, you'll see that the markup sent to the browser is just a link to a JavaScript file. This means that the contents of the page are not guaranteed to be crawlable by search engines and social media platforms: 

![](https://res.cloudinary.com/css-tricks/image/upload/c_scale,w_1000,f_auto,q_auto/v1497358332/some-html_mrmpfj.png)

#Adding Server Side Rendering

Next we'll implement server side rendering so that fully generated HTML is sent to the browser. If you want to view all the changes at once, view the diff on GitHub.

To get started, we'll install Express, a Node.js server side application framework:

```
npm install express --save
```

We want to create a server that renders our React component:

```
import express from 'express';
import fs from 'fs';
import path from 'path';
import React from 'react';
import ReactDOMServer from 'react-dom/server';
import Hello from './Hello.js';

function handleRender(req, res) {
  // Renders our Hello component into an HTML string
  const html = ReactDOMServer.renderToString(<Hello />);

  // Load contents of index.html
  fs.readFile('./index.html', 'utf8', function (err, data) {
    if (err) throw err;

    // Inserts the rendered React HTML into our main div
    const document = data.replace(/<div id="app"><\/div>/, `<div id="app">${html}</div>`);

    // Sends the response back to the client
    res.send(document);
  });
}

const app = express();

// Serve built files with static files middleware
app.use('/build', express.static(path.join(__dirname, 'build')));

// Serve requests with our handleRender function
app.get('*', handleRender);

// Start server
app.listen(3000);
```

Let's break down whats happening...

The handleRender function handles all requests. The ReactDOMServer class imported at the top of the file provides the renderToString() method that renders a React element to its initial HTML.

```
ReactDOMServer.renderToString(<Hello />);
```

This returns the HTML for the Hello component, which we inject into the HTML of index.html to generate the full HTML for the page on the server.

```
const document = data.replace(/<div id="app"><\/div>/,`<div id="app">${html}</div>`);
```

To start the server, update the start script in package.json and then run npm run start:

```
"scripts": {
  "start": "webpack && babel-node server.js"
},
```

Browse to http://localhost:3000 to view the app. Voila! Your page is now being rendered from the server. But there's a problem. If you view the page source in the browser. You'll notice that the blog posts are still not included in the response. What's going on? If we open up the network tab in Chrome, we'll see that the API request is happening on the client. 

![](https://res.cloudinary.com/css-tricks/image/upload/c_scale,w_1000,f_auto,q_auto/v1497358447/devtools_qx5y1o.png)

Although we're rendering the React component on the server, the API request is made asynchronously in componentWillMount and the component is rendered before the request completes. So even though we're rendering on the server, we're only doing so partially. Turns out, there's an issue on the React repo with over 100 comments discussing the problem and various workarounds.

#Fetching data before rendering

To fix this, we need to make sure the API request completes before the Hello component is rendered. This means making the API request outside of React's component rendering cycle and fetching data before we render the component. We'll take you through this step-by-step, but you can view the complete diff on GitHub.

To move data fetching before rendering, we'll install react-transmit:

```
npm install react-transmit --save
```

React Transmit gives us elegant wrapper components (often referred to as "higher-order components") for fetching data that work on the client and server.

Here's what our component looks like with React Transmit implemented:

```
import React from 'react';
import Butter from 'buttercms'
import Transmit from 'react-transmit';

const butter = Butter('b60a008584313ed21803780bc9208557b3b49fbb');

var Hello = React.createClass({
  render: function() {
    if (this.props.posts) {
      return (
        <div>
          {this.props.posts.data.map((post) => {
            return (
              <div key={post.slug}>{post.title}</div>
            )
          })}
        </div>
      );
    } else {
      return <div>Loading...</div>;
    }
  }
});

export default Transmit.createContainer(Hello, {
  // These must be set or else it would fail to render
  initialVariables: {},
  // Each fragment will be resolved into a prop
  fragments: {
    posts() {
      return butter.post.list().then((resp) => resp.data);
    }
  }
});
```

We've wrapped our component in a higher-order component that fetches data using Transmit.createContainer. We've removed the lifecycle methods from the React component since there's no need to fetch data twice. And we've changed the render method to use props references instead of state, since React Transmit passes data to the component as props.

To make sure the server fetches data before rendering, we import Transmit and use Transmit.renderToString instead of the ReactDOM.renderToString method.

```
import express from 'express';
import fs from 'fs';
import path from 'path';
import React from 'react';
import ReactDOMServer from 'react-dom/server';
import Hello from './Hello.js';
import Transmit from 'react-transmit';

function handleRender(req, res) {
  Transmit.renderToString(Hello).then(({reactString, reactData}) => {
    fs.readFile('./index.html', 'utf8', function (err, data) {
      if (err) throw err;

      const document = data.replace(/<div id="app"><\/div>/, `<div id="app">${reactString}</div>`);
      const output = Transmit.injectIntoMarkup(document, reactData, ['/build/client.js']);

      res.send(document);
    });
  });
}

const app = express();

// Serve built files with static files middleware
app.use('/build', express.static(path.join(__dirname, 'build')));

// Serve requests with our handleRender function
app.get('*', handleRender);

// Start server
app.listen(3000);
```

Restart the server browse to http://localhost:3000. View the page source and you'll see that the page is now being fully rendered on the server! 

![](https://res.cloudinary.com/css-tricks/image/upload/c_scale,w_1000,f_auto,q_auto/v1497358548/rendered-react_t5neam.png)

#Going further

We've done it! Using React on the server can be tricky, especially when fetching data from API's. Luckily the React community is thriving and creating lots of helpful tools. If you're interested in frameworks for building large React apps that render on the client and server, check out the Electrode by Walmart Labs or Next.js. Or if you want to render React in Ruby, check out AirBnB's Hypernova.



---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
