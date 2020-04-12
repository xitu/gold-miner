> * 原文地址：[How to use SVG Icons as React Components?](https://www.robinwieruch.de/react-svg-icon-components)
> * 原文作者：[ROBIN WIERUCH](https://www.robinwieruch.de)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/react-svg-icon-components.md](https://github.com/xitu/gold-miner/blob/master/TODO1/react-svg-icon-components.md)
> * 译者：[TiaossuP](https://github.com/tiaossup)
> * 校对者：[vitoxli](https://github.com/vitoxli)、[ZavierTang](https://github.com/ZavierTang)

# 如何将 SVG 图标用做 React 组件？

![react svg icons, react svgr](https://www.robinwieruch.de/static/e6abcd74fe0c908d20be1fbf81b116e1/2b1a3/banner.jpg)

我一直在 React 应用中使用 SVG 感到困惑。我在网上看到了很多在 React 中使用 SVG 的方案，但真正实践起来时，几乎都没成功过。现在我要介绍一个非常简单易行的方式来解决这个问题。

**提示：这篇文章中的图标均来自 [Flaticon](https://flaticon.com)。如果你用了这个网站的图标，别忘了向作者 / 平台表示感谢！**

你可以在你的 React 项目中创建一个专门用来存放 .svg 图标文件的文件夹。以此，你可以手动/自动生成 React 组件。接下来的两个章节，我将展示两种方式，一种是使用命令行与 npm 命令手动创建图标组件，另一种是使用 webpack 自动创建 React 组件。这两种方式都使用了一个名为 [SVGR](https://github.com/smooth-code/svgr) 的工具（这个工具也被 [create-react-app](https://github.com/facebook/create-react-app) 等工具广泛使用）。

## 通过命令行创建 React SVG 图标组件

在这个章节，我们从手动创建 SVG 图标开始。如果你需要本文的 starter 项目，可以戳 [webpack + Babel + React 项目](https://github.com/rwieruch/minimal-react-webpack-babel-setup)并参考其安装说明。

接下来，在你的 `src/` 目录下建立一个 `/assets` 目录，把你的所有 .svg 图标全都放在里面。我们并不希望把资源文件与源码弄混，因为我们接下来会基于这些资源文件生成 JavaScript 文件。这些手动生成的 JavaScript 文件 —— 即 React 图标组件，会跟你的其他源码混在一起。

```
assets/
-- twitter.svg
-- facebook.svg
-- github.svg
src/
-- index.js
-- App.js
```

现在，为你的 React 图标组件创建一个 `src/Icons/`文件夹：

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

我们希望最终生成的 React 图标组件在 **src/App.js**  中使用：

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

不过，目前并没有产生任何效果，因为现在 `src/Icons` 目录是空的，里面没有任何图标组件。下一步，我们将以 `assets` 文件夹为源文件夹，`src/Icons`为目标文件夹，通过在 `package.json` 中添加一个新的 npm 脚本，来生成 React 图标组件。

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

最后，使用命令行安装 SVGR CLI 包。

```
npm install @svgr/cli --save-dev
```

现在，已经万事俱备，你可以在命令行中输入 `npm run svgr` 来执行你的新 npm 命令。你可以在命令行的输出中，看到根据 SVG 文件生成的 JavaScript 文件。在命令执行完成后，你就可以启动应用，在页面中看到被渲染为 React 组件的 SVG 图标。你可以在 `src/Icons` 目录中看到所有生成的 React 图标组件。这些组件同样可以[把 props 作为参数](https://www.robinwieruch.de/react-pass-props-to-component/)，这意味着你可以自行定义图标的宽高。

这就是从 SVG 生成 React 组件的完整步骤，每次你加入了一个新 SVG 文件或者修改了原有的 SVG 文件时，你都需要再次运行 `npm run svgr` 命令。

## 使用  webpack 生成 React SVG 图标组件

每次更新 SVG 文件，都手动执行命令并不是一个最佳方案。你可以将其集成到 webpack 配置中。现在你可以把你的 `src/Icons` 文件夹清空，把 `assets/` 文件夹中的 SVG 文件移动到 `src/Icons` 下，并删掉 `assets/` 文件夹了。现在你的目录结构将如下所示：

```
src/
-- index.js
-- App.js
-- Icons/
---- twitter.svg
---- facebook.svg
---- github.svg
```

现在你可以直接在 App 组件中直接引用 SVG 文件。

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

现在启动应用会失败，引入 SVG 文件显然没有这么简单。不过，我们可以让 webpack 在每次启动应用时，都自动引入正确的 SVG 文件。参考下面的代码，修改你的 `webpack.config.js` 文件。

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

然后，为 SVGR 安装必要的 webpack 包

```
npm install @svgr/webpack --save-dev
```

一旦应用启动，webpack 就会自动工作，你就再也不需要纠结于 SVG 文件了。你可以把你的 SVG 文件放在 `src/` 目录的任意位置，并被任意 React 组件所引用。现在，我们也不再需要 `package.json` 文件里面的 SVGR 命令了。

### 另一个可选方案：react-svg-loader

如果你使用 webpack，你可以使用一些更简单的 SVG loader 来代替 SVGR。譬如，可以在你的 webpack 配置中使用 [react-svg-loader](https://github.com/boopathi/react-svg-loader) 来代替 SVGR：

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

当然你需要先安装它：

```
npm install react-svg-loader --save-dev
```

然后，你依然可以用与 SVGR 一样的方式来引入并使用你的 SVG 文件。这相当于一个 SVGR 的轻量级替代方案。

## 使用 SVGR 模板来做一些高级应用

在我最近一次开发 React 应用时，我遇到了一些有问题的 SVG 图标，这些图标的 [viewBox](https://developer.mozilla.org/zh-CN/docs/Web/SVG/Attribute/viewBox) 属性并不完整。由于这个属性是为 SVG 图标提供大小所必需的，所以只要这个属性没有出现在图标中，我就必须找到一种方法来引入这个属性。本来，我可以遍历每个 SVG 图标来修复这个问题，但是，处理 500 多个图标并不是一项轻松的任务。接下来我将介绍如何用 SVGR 模板功能来解决这个问题。

`webpack.config.js` 文件中的 SVGR 默认模板看起来像是下面这样：

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

通过使用这个模板，你可以更改 SVG 文件生成的代码。假设我们想要用蓝色填充所有的图标。则只需要用 `fill` 属性扩展 `props` 对象：

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

这就可以给所有的图标都增加 `fill: blue` 属性了。 SVGR 本身已经提供了类似的简单用例。只需查看他们的文档，就可以了解如何给 SVG 添加 / 替换 / 删除属性。

### 使用 SVGR 来自定义 `viewBox` 属性

在我们的例子中，我们希望为每个不存在 `viewBox` 属性的 SVG 图标都添加该属性。首先，我们把一个正常的 SVG 中的 `viewBox` 属性删除，现在它就肯定无法正常显示了。确认了问题已经出现后，我们尝试使用上面介绍的 SVGR 模板和一个额外的 [React Hook](https://www.robinwieruch.de/react-hooks/) 来修复此问题：

```JSX
import React from 'react';
const useWithViewbox = ref => {
  React.useLayoutEffect(() => {
    if (
      ref.current !== null &&
      // 当没有 viewBox 属性时
      !ref.current.getAttribute('viewBox') &&
      // 当 jsdom 没 bug 时
      // https://github.com/jsdom/jsdom/issues/1423
      ref.current.getBBox &&
      // 当其已经被渲染
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

React hook 需要这个 SVG 组件的引用（ref）来为其设置 `viewBox` 属性。现在 `viewBox` 属性将根据渲染出的图标来计算。如果图标尚未被渲染，或者已经存在 `viewBox` 属性时，我们就不会做任何事情。

这个 hook 应该放在离 `src/Icons` 目录不远的地方。

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

现在，我们可以在 `webpack.config.js` 文件中为 SVG 模板添加 hook：

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

有了这个功能，SVGR的模板功能将向每个生成的图标组件添加 [自定义 hook](https://github.com/the-road-to-learn-react/use-with-viewbox) 。这个 hook 只在没有 `viewBox` 属性的图标组件中执行。此时再次运行应用，就会发现所有图标组件都能正确显示了 —— 即使你可能已经从某个组件中删除了 `viewBox` 属性。

---

最后，我希望通过这篇文章，你可以学到在命令行 / npm 命令或 webpack 中使用 SVGR 来在 React 中引入 SVG 图标的方法。使用 webpack 实现的最终版 React 应用可以在这个 [GitHub repo](https://github.com/rwieruch/minimal-react-webpack-babel-svg-setup) 中找到。如果你遇到任何 bug，请在评论中告诉我。我也很乐于得知一些与「`viewBox`属性丢失」类似的问题。请在评论中告诉我这些情况。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
