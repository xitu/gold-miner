> * 原文地址：[How to use SVG Icons as React Components?](https://www.robinwieruch.de/react-svg-icon-components)
> * 原文作者：[ROBIN WIERUCH](https://www.robinwieruch.de)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/react-svg-icon-components.md](https://github.com/xitu/gold-miner/blob/master/TODO1/react-svg-icon-components.md)
> * 译者：
> * 校对者：

# How to use SVG Icons as React Components?

![react svg icons, react svgr](https://www.robinwieruch.de/static/e6abcd74fe0c908d20be1fbf81b116e1/2b1a3/banner.jpg)

I always struggled to use SVG in my React applications. Every time I searched about the topic online, I've found many ways on how to use SVG in React, but once I implemented the approaches, the success rates were very low. Today I want to give you a straightforward approach on how to use SVG icons as React components for your next React application.

**Note: All icons used in this tutorial are from [Flaticon](https://flaticon.com). If you use icons from there, don't forget to attribute the authors/platform.**

It's possible to have one folder in your React application that holds all your .svg files for your icons. From there, you can generate your React components manually/automatically. I will show you both approaches in the next two sections for creating icon components manually with your command line interface and npm scripts, but also for creating your icon components automatically with Webpack. The tool we are using is called [SVGR](https://github.com/smooth-code/svgr) which is widely used (e.g. [create-react-app](https://github.com/facebook/create-react-app)).

## React SVG Icon Components from CLI

In this section, we will start by generating SVG icons manually for your React application. If you need a starter project, head over to this [Webpack + Babel + React project](https://github.com/rwieruch/minimal-react-webpack-babel-setup) and follow the installation instructions.

Next, put all your .svg icon files into a **/assets** folder next to your **src/** folder. We don't want to have the assets mixed with our source code files, because we will generate JavaScript files based on them. These JavaScript files -- being React icon components -- are mixed with your other source code files then.

```
assets/
-- twitter.svg
-- facebook.svg
-- github.svg
src/
-- index.js
-- App.js
```

Now, create an empty **src/Icons/** folder for all your generated React icon components:

```
assets/
-- twitter.svg
-- facebook.svg
-- github.svg
src/
-- index.js
-- App.js
-- Icons/
```

The desired outcome would be to use the React icon components in our **src/App.js** component:

```jsx
import React from 'react';
import TwitterIcon from './Icons/Twitter.js';
import FacebookIcon from './Icons/Facebook.js';
import GithubIcon from './Icons/Github.js';
const App = () => (
  <div>
    <ul>
      <li>
        <TwitterIcon width="40px" height="40px" />
        <a href="https://twitter.com/rwieruch">Twitter</a>
      </li>
      <li>
        <FacebookIcon width="40px" height="40px" />
        <a href="https://www.facebook.com/rwieruch/">Facebook</a>
      </li>
      <li>
        <GithubIcon width="40px" height="40px" />
        <a href="https://github.com/rwieruch">Github</a>
      </li>
    </ul>
  </div>
);
export default App;
```

However, this doesn't work yet because the **src/Icons/** folder is empty. There are no icon components yet. In the next step, the **assets/** folder will act as **source** folder and the **src/Icons/** as **target** folder. We will add a new npm script to our **package.json** file which will generate the React icon components:

```js
{
  ...
  "main": "index.js",
  "scripts": {
    "svgr": "svgr -d src/Icons/ assets/",
    "start": "webpack-dev-server --config ./webpack.config.js --mode development"
  },
  "keywords": [],
  ...
}
```

Last but not least, install the SVGR CLI package on the command line:

```
npm install @svgr/cli --save-dev
```

Now, after having everything set up properly, you can execute your new npm script with `npm run svgr` on the command line. Reading the command line output, you can see that new JavaScript files are being generated from your svg files. After the command terminates, you should be able to see the svg icons rendered as React components when starting your application. You can also check your **src/Icons** folder to see all generated React icon components. They take [props as arguments](https://www.robinwieruch.de/react-pass-props-to-component/) as well, which makes it possible for us to define their height and width.

That's all it needs to generate React components from SVGs. Every time you have a new SVG file or adjust one of your existing SVG files, you can the `npm run svgr` command again.

## React SVG Icon Components from Webpack

Running the SVGR script every time to update your SVG icons is not the best solution though. What about integrating the whole process in your Webpack configuration? You should start out with an empty **src/Icons** folder. Afterward, move all your SVG files to this folder and remove the **assets/** folder. Your folder structure should look like the following:

```
src/
-- index.js
-- App.js
-- Icons/
---- twitter.svg
---- facebook.svg
---- github.svg
```

Your App component imports SVG files rather than JavaScript files now:

```jsx
import React from 'react';
import TwitterIcon from './Icons/Twitter.svg';
import FacebookIcon from './Icons/Facebook.svg';
import GithubIcon from './Icons/Github.svg';
const App = () => (
  <div>
    <ul>
      <li>
        <TwitterIcon width="40px" height="40px" />
        <a href="https://twitter.com/rwieruch">Twitter</a>
      </li>
      <li>
        <FacebookIcon width="40px" height="40px" />
        <a href="https://www.facebook.com/rwieruch/">Facebook</a>
      </li>
      <li>
        <GithubIcon width="40px" height="40px" />
        <a href="https://github.com/rwieruch">Github</a>
      </li>
    </ul>
  </div>
);
export default App;
```

Starting your application wouldn't work, because we cannot simply import SVG files this way. Fortunately, we can make Webpack doing the work for us implicitly with every application start. Let's add the following configuration to our **webpack.config.js** file:

```js
const webpack = require('webpack');
module.exports = {
  entry: './src/index.js',
  module: {
    rules: [
      {
        test: /\.(js|jsx)$/,
        exclude: /node_modules/,
        use: ['babel-loader'],
      },
      {
        test: /\.svg$/,
        use: ['@svgr/webpack'],
      },
    ],
  },
  ...
};
```

Afterward, install the necessary Webpack package for SVGR:

```
npm install @svgr/webpack --save-dev
```

Once you start your application, Webpack is doing its thing and you don't need to worry about your SVGs anymore. You can put your SVG files anywhere in your **src/** folder and import them wherever you need them as React components. There is no need anymore for the SVGR npm script in your **package.json** file which we have implemented in the previous section.

### Alternative: react-svg-loader

If you are using Webpack, you can also use a simplified SVG loader instead of SVGR. For instance, [react-svg-loader](https://github.com/boopathi/react-svg-loader) can be used within your Webpack configuration. Note that it replaces SVGR:

```js
const webpack = require('webpack');
module.exports = {
  entry: './src/index.js',
  module: {
    rules: [
      {
        test: /\.(js|jsx)$/,
        exclude: /node_modules/,
        use: ['babel-loader'],
      },
      {
        loader: 'react-svg-loader',
        options: {
          jsx: true // true outputs JSX tags
        }
      }
    ],
  },
  ...
};
```

Also you need to install it:

```
npm install react-svg-loader --save-dev
```

Afterward, you can import SVG files the same way as React components as you did before with SVGR. It can be seen as a lightweight alternative to SVGR.

## SVGR Templates for advanced SVGs

When I worked with my last client on their React application, I had the problem of dealing with SVG icons which had only partially the [viewBox](https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/viewBox) attribute. Since this attribute is needed for giving your SVG icons a size, I had to find a way around to introduce this attribute whenever it wasn't present for an icon. Now I could go through every SVG icon to fix this issue, however, dealing with more than 500 icons doesn't make this a comfortable task. Let me show how I dealt with it by using SVGR templates instead.

The default SVGR template in your **webpack.config.js** file looks like the following:

```js
...
module.exports = {
  entry: './src/index.js',
  module: {
    rules: [
      {
        test: /\.(js|jsx)$/,
        exclude: /node_modules/,
        use: ['babel-loader'],
      },
      {
        test: /\.svg$/,
        use: [
          {
            loader: '@svgr/webpack',
            options: {
              template: (
                { template },
                opts,
                { imports, componentName, props, jsx, exports }
              ) => template.ast`
                ${imports}
                const ${componentName} = (${props}) => {
                  return ${jsx};
                };
                export default ${componentName};
              `,
            },
          },
        ],
      },
    ],
  },
  ...
};
```

By having this template at your disposal, you can change the code which is generated from the SVG file. Let's say we want to fill all our icons with a blue color. We just extend the props object with a fill attribute:

```js
...
module.exports = {
  entry: './src/index.js',
  module: {
    rules: [
      {
        test: /\.(js|jsx)$/,
        exclude: /node_modules/,
        use: ['babel-loader'],
      },
      {
        test: /\.svg$/,
        use: [
          {
            loader: '@svgr/webpack',
            options: {
              template: (
                { template },
                opts,
                { imports, componentName, props, jsx, exports }
              ) => template.ast`
                ${imports}
                const ${componentName} = (${props}) => {
                  props = { ...props, fill: 'blue' };
                  return ${jsx};
                };
                export default ${componentName};
              `,
            },
          },
        ],
      },
    ],
  },
  ...
};
```

This should work to give all icons a blue fill attribute. However, simple use cases like this are already provided by SVGR itself. Just check out their documentation on how to add/replace/remove attribute from SVGs.

### SVGR with custom viewBox attribute

In our case, we wanted to compute the viewBox attribute for every SVG icon where the attribute isn't present. First, remove the viewBox attribute from one of your SVGs to see that it's not rendered properly anymore. After confirming the bug, we will try to fix it by using the introduced SVGR template and an external [React Hook](https://www.robinwieruch.de/react-hooks/):

```JSX
import React from 'react';
const useWithViewbox = ref => {
  React.useLayoutEffect(() => {
    if (
      ref.current !== null &&
      // only if there is no viewBox attribute
      !ref.current.getAttribute('viewBox') &&
      // only if not test (JSDOM)
      // https://github.com/jsdom/jsdom/issues/1423
      ref.current.getBBox &&
      // only if rendered
      // https://stackoverflow.com/questions/45184101/error-ns-error-failure-in-firefox-while-use-getbbox
      ref.current.getBBox().width &&
      ref.current.getBBox().height
    ) {
      const box = ref.current.getBBox();
      ref.current.setAttribute(
        'viewBox',
        [box.x, box.y, box.width, box.height].join(' ')
      );
    }
  });
};
export default useWithViewbox;
```

The React hook only needs a reference (ref) to the SVG components in order to set the viewBox attribute. The measurements for the viewBox attribute are computed based on the rendered icon. If the icon hasn't been rendered or the viewBox attribute is already present, we do nothing.

The hook should be somewhere available not far away from our **src/Icons/** folder:

```
src/
-- index.js
-- App.js
-- useWithViewbox.js
-- Icons/
---- twitter.svg
---- facebook.svg
---- github.svg
```

Now, we can use the hook for our SVG template in the **webpack.config.js** file:

```js
...
module.exports = {
  entry: './src/index.js',
  module: {
    rules: [
      ...
      {
        test: /\.svg$/,
        use: [
          {
            loader: '@svgr/webpack',
            options: {
              template: (
                { template },
                opts,
                { imports, componentName, props, jsx, exports }
              ) => template.ast`
                ${imports}
                import useWithViewbox from '../useWithViewbox';
                const ${componentName} = (${props}) => {
                  const ref = React.createRef();
                  useWithViewbox(ref);
                  props = { ...props, ref };
                  return ${jsx};
                };
                export default ${componentName};
              `,
            },
          },
        ],
      },
    ],
  },
  ...
};
```

Having this in place, SVGR's template feature will add the [custom hook](https://github.com/the-road-to-learn-react/use-with-viewbox) to every generated icon component. The hook only runs for icon components which have no viewBox attribute though. If you run your application again, you should see all icon components rendered properly, even though you may have removed the viewBox attribute from one of them.

---

In the end, I hope this walkthrough has helped you to get started with SVG icons in React by using SVGR with your command line/npm scripts or Webpack. The finished application using the Webpack approach and React can be found in this [GitHub repository](https://github.com/rwieruch/minimal-react-webpack-babel-svg-setup). If you run into any bugs, let me know in the comments. Otherwise I am happy to heard about your special use cases which fall into the category of my missing viewBox bug. Let me know about these cases in the comments.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
