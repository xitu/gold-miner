> * 原文地址：[The simple guide to server-side rendering React with styled-components](https://medium.com/styled-components/the-simple-guide-to-server-side-rendering-react-with-styled-components-d31c6b2b8fbf)
> * 原文作者：[Dennis Brotzky](https://medium.com/@JobeirDennis?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-simple-guide-to-server-side-rendering-react-with-styled-components.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-simple-guide-to-server-side-rendering-react-with-styled-components.md)
> * 译者：
> * 校对者：

# The simple guide to server-side rendering React with styled-components

![](https://cdn-images-1.medium.com/max/2000/1*esSohBffpbW40OCldHJ_zA.png)

The goal of this guide is to share the core principles of how to use styled-components in a server side rendered React application. The beauty of styled-components really shines through when you realize how seamless it is to setup in your application. Furthermore, styled-components are easy to integrate into existing applications that are using other methods of styling.

In this guide there are no additional libraries such as Redux, React Router, or concepts such as code splitting — let’s start with the basics.

You can view the final working example at: [**https://github.com/Jobeir/styled-components-server-side-rendering**,](https://github.com/Jobeir/styled-components-server-side-rendering) discuss this post at[**https://spectrum.chat/thread/b95c9ef2-20cb-4bab-952f-fadd90add391**](https://spectrum.chat/thread/b95c9ef2-20cb-4bab-952f-fadd90add391)

### Getting started by setting up our React app

![](https://cdn-images-1.medium.com/max/600/1*wbD3IaUAwYsSHJa9Y6OBBA.png)

Application structure.

First, let’s take a look at how our application will be structured for this guide. We’ll need to have all our dependencies and scripts within`package.json` and our build step will be processed through `webpack.config.js`.

Beyond that, a single `server.js` file will handle our routing and serving of our React application. The `client/` folder contains our the actual application in `App.js`, `Html.js` and `index.js.`

To get started, in a new empty folder of your choice, create an empty `package.json` by running:

`npm init --yes` or `yarn init --yes`

Then paste in the following scripts and dependencies shown below. The dependencies for this application include React, styled-components, Express, Wepback, and Babel.

```
"scripts": {
  "start": "node ./dist/server",
  "build": "webpack"
},
"devDependencies": {
  "babel-core": "^6.10.4",
  "babel-loader": "^7.1.2",
  "babel-preset-env": "^1.6.1",
  "babel-preset-react": "^6.11.1",
  "webpack": "^3.8.1",
  "webpack-node-externals": "^1.2.0"
},
"dependencies": {
  "express": "^4.14.0",
  "react": "^16.2.0",
  "react-dom": "^16.2.0",
  "styled-components": "^2.2.4"
}
```

Now that all our dependancies are accounted for and we’ve setup our scripts to start and build our project we can setup our React application.

**1.**`**src/client/App.js**`

```
import React from 'react';

const App = () => <div>💅</div>;

export default App;
```

`App.js` returns a div wrapping the 💅 emoji. It’s a very basic React component that we will be rendering into the browser.

**2.**`**src/client/index.js**`

```
import React from 'react';
import { render } from 'react-dom';
import App from './App';

render(<App />, document.getElementById('app'));
```

`index.js` is the standard way to mount a React application into the DOM. We’re taking out `App.js` component and rendering it.

**3.**`**src/client/Html.js**`

```
/**
 * Html
 * This Html.js file acts as a template that we insert all our generated
 * application code into before sending it to the client as regular HTML.
 * Note we're returning a template string from this function.
 */
const Html = ({ body, title }) => `
  <!DOCTYPE html>
  <html>
    <head>
      <title>${title}</title>
    </head>
    <body style="margin:0">
      <div id="app">${body}</div>
    </body>
  </html>
`;

export default Html;
```

What we have so far is a `package.json` that contains all our dependencies and scripts along with a basic React app in the `src/client/` folder. This React app will be rendered as HTML through the `Html.js` file that returns a template string.

### Creating the server

![](https://cdn-images-1.medium.com/max/800/1*_o9W9dTKMXheC-LLQC3Bzw.png)

To render our app on the server we’ll need to setup express to handle the request and send back our HTML. With express already added, we can get right into creating server.

`**src/server.js**`

```
import express from 'express';
import React from 'react';
import { renderToString } from 'react-dom/server';
import App from './client/App';
import Html from './client/Html';

const port = 3000;
const server = express();

server.get('/', (req, res) => {
  /**
   * renderToString() will take our React app and turn it into a string
   * to be inserted into our Html template function.
   */
  const body = renderToString(<App />);
  const title = 'Server side Rendering with Styled Components';

  res.send(
    Html({
      body,
      title
    })
  );
});

server.listen(port);
console.log(`Serving at http://localhost:${port}`);
```

### Configuring Webpack

This guide is focused on the very basics so our Webpack config is kept simple. We are using Webpack to build our React app in production mode and with Babel. There is a single entry point at `src/server.js` that will be ouput into `dist/`

```
const webpack = require('webpack');
const nodeExternals = require('webpack-node-externals');
const path = require('path');

module.exports = {
  entry: './src/server.js',
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'server.js',
    publicPath: '/'
  },
  target: 'node',
  externals: nodeExternals(),
  plugins: [
    new webpack.DefinePlugin({
      'process.env': {
        NODE_ENV: `'production'`
      }
    })
  ],
  module: {
    loaders: [
      {
        test: /\.js$/,
        loader: 'babel-loader'
      }
    ]
  }
};
```

Now we have enough to build and serve a server side rendered React application. We can run two commands and be ready.

First, run:

`yarn build` or `npm build`

Then to start application run:

`yarn start` or `npm start`

_If it does not start you may need to add a_ `_.babelrc_` _file in the root of your project._

![](https://cdn-images-1.medium.com/max/800/1*1xXs7xt80kpSk37hCVyQ7w.png)

Visiting [http://localhost:3000](http://localhost:3000) after a successful yarn build and subsequent yarn start.

### Adding styled-components

So far, so good. We’ve successfully created a React application that’s rendered on the server. We don’t have any third party libraries like React Router, Redux, and our Webpack config is straight to the point.

Next, let’s start styling our app with styled-components:

1.  `**src/client/App.js**`

Let’s create our first styled component. To create a styled component import `styled` and define your component.

```
import React from 'react';
import styled from 'styled-components';

// Our single Styled Component definition
const AppContaienr = styled.div`
  display: flex;
  align-items: center;
  justify-content: center;
  position: fixed;
  width: 100%;
  height: 100%;
  font-size: 40px;
  background: linear-gradient(20deg, rgb(219, 112, 147), #daa357);
`;

const App = () => <AppContaienr>💅</AppContaienr>;

export default App;
```

Adding a styled component into our App

**2.** `**src/server.js**`

This is where the biggest changes occur. `styled-components` exposes `ServerStyleSheet` that will allow use to create a stylesheet from all the `styled` components in our `<App />`. This stylesheet gets passed into our `Html` template later on.

```
import express from 'express';
import React from 'react';
import { renderToString } from 'react-dom/server';
import App from './client/App';
import Html from './client/Html';
import { ServerStyleSheet } from 'styled-components'; // <-- importing ServerStyleSheet

const port = 3000;
const server = express();

// Creating a single index route to server our React application from.
server.get('/', (req, res) => {
  const sheet = new ServerStyleSheet(); // <-- creating out stylesheet

  const body = renderToString(sheet.collectStyles(<App />)); // <-- collecting styles
  const styles = sheet.getStyleTags(); // <-- getting all the tags from the sheet
  const title = 'Server side Rendering with Styled Components';

  res.send(
    Html({
      body,
      styles, // <-- passing the styles to our Html template
      title
    })
  );
});

server.listen(port);
console.log(`Serving at http://localhost:${port}`);
```

Adding 5 lines of code to server.js.

**3.** `**src/client/Html.js**`

Adding `styles` as an argument into our `Html` function and inserting the `${styles}` argument into our template string.

```
/**
 * Html
 * This Html.js file acts as a template that we insert all our generated
 * application strings into before sending it to the client.
 */
const Html = ({ body, styles, title }) => `
  <!DOCTYPE html>
  <html>
    <head>
      <title>${title}</title>
      ${styles}
    </head>
    <body style="margin:0">
      <div id="app">${body}</div>
    </body>
  </html>
`;

export default Html;
```

**And that’s it! Let’s build and run our server side rendered React application with styled-components.**

`yarn build` or `npm build`

Then to start application run:

`yarn start` or `npm start`

![](https://cdn-images-1.medium.com/max/1000/1*TuzLZNu5HEHcK4h0cEZNdw.png)

### Conclusion

We’ve created a step-by-step guide of how to server side render a React application with styled-components. There are no bells or whistles around this guide because we wanted to focus on the core concepts. From here, you can use these principles in your existing apps or build on top of this guide to create a more complex app. There are other guides that will help you piece together how to add state management, routing, performance improvements, and more.

* * *

### Don’t stop learning!

Thank you for following this guide and reading through to the end. Hopefully it helped you understand and get started with React/SSR and styled-components. If you know anyone that would benefit from this guide I would love if you recommended it to them!

If you’d like to see a larger code base that’s server side rendered using styled-components you can check out one of my projects, [Jobeir, on Github](https://github.com/Jobeir/jobeir). On top of that, the [styled-components documentation](https://www.styled-components.com/docs/advanced#server-side-rendering) is always a good place to go.

### Using SSR React with styled-components at [Jobeir](https://jobeir.com)

Who am I? I’m the creator of [**Jobeir**](https://jobeir.com), a job board focused on helping everyone find the best jobs in tech. I work as a Senior Frontend developer in Vancouver, Canada. You can ask me questions, say hello on [Twitter](https://twitter.com/jobeirofficial), or even check out our [Github](https://github.com/Jobeir).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
