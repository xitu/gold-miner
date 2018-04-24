> * 原文地址：[OPTIMIZING WEBPACK FOR FASTER REACT BUILDS](http://engineering.invisionapp.com/post/optimizing-webpack/)
> * 原文作者：[Jonathan Rowny](http://invisionapp.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/optimizing-webpack-for-faster-react-builds.md](https://github.com/xitu/gold-miner/blob/master/TODO1/optimizing-webpack-for-faster-react-builds.md)
> * 译者：
> * 校对者：

# OPTIMIZING WEBPACK FOR FASTER REACT BUILDS

![](https://imgs.xkcd.com/comics/compiling.png)

If you’ve got a slow Webpack build with a ton of libraries - fear not, there’s a way to increase incremental build speed! Webpack’s `DLLPlugin` lets you build all of your dependencies into a single file. It’s a great alternative to chunking. The file is later consumed by your main Webpack configuration or even on other projects sharing the same set of dependencies. Your typical React app may contain dozens of vendor libs depending on your flavor of Flux, add-ons, router, and other utilities like `lodash`. We’ll save precious build time by allowing Webpack to skip over any reference contained within the DLL.

This article assumes you’re already familiar with a typical Webpack and React setup. If not, please checkout [SurviveJS](http://survivejs.com/webpack_react/webpack/)’s excellent section on Webpack and React and come back here when your build time starts to creep upwards.

## Step 1, List your Vendors

The easiest way to build and maintain a DLL is by creating a JS file in your project, let’s call it `vendors.js` and requiring all of the libs you use. For example, on our recent projects, our `vendors.js` file looks like this:

```
require("classnames");
require("dom-css");
require("lodash");
require("react");
require("react-addons-update");
require("react-addons-pure-render-mixin");
require("react-dom");
require("react-redux");
require("react-router");
require("redux");
require("redux-saga");
require("redux-simple-router");
require("redux-storage");
require("redux-undo");
```

This is the file we will “build” into a DLL. It has no functionality, it just imports the libraries we use.

**Note:** You could also use ES6 style `import` here, but then we’d need Babel just to build the DLL. You can still use `import` and all the rest of the ES2015 sugary goodness in your main project just as you’re used to.

## Step 2, Build your DLL

Now we can create a Webpack configuration to build the DLL. This is **completely separate** from your app’s main Webpack configuration and will result in a few files. It won’t be called by your Webpack middleware, Webpack server, or anything else (except manually or through a pre-build step).

Let’s call this file `webpack.dll.js`

```
var path = require("path");
var webpack = require("webpack");

module.exports = {
    entry: {
        vendor: [path.join(__dirname, "client", "vendors.js")]
    },
    output: {
        path: path.join(__dirname, "dist", "dll"),
        filename: "dll.[name].js",
        library: "[name]"
    },
    plugins: [
        new webpack.DllPlugin({
            path: path.join(__dirname, "dll", "[name]-manifest.json"),
            name: "[name]",
            context: path.resolve(__dirname, "client")
        }),
        new webpack.optimize.OccurenceOrderPlugin(),
        new webpack.optimize.UglifyJsPlugin()
    ],
    resolve: {
        root: path.resolve(__dirname, "client"),
        modulesDirectories: ["node_modules"]
    }
};
```

This is a fairly typical Webpack config except for the `webpack.DLLPlugin`, which contains properties for the name, context, and manifest path. The manifest is very important, it gives other Webpack configurations a map to your already built modules. The context is the root of your client source code and the name is the name of the entry, in this case “vendor”. Go ahead and try running this build with the command `webpack --config=webpack.dll.js`. You should end up with a `dll\vendor-manifest.json` that contains a nice little map to your modules as well as a `dist\dll\dll.vendor.js` which contains a nicely minified package containing all of your vendor libs.

## Step 3, Build your Project

**Note:** The following example does not include sass, assets, nor a hotloader. They should still work just fine if you’ve got them in your config.

Now all we need to do is add the `DLLReferencePlugin` and point it at our already built DLL. Here’s what your `webpack.dev.js` might look like:

```
var path = require("path");
var webpack = require("webpack");

module.exports = {
    cache: true,
    devtool: "eval", //or cheap-module-eval-source-map
    entry: {
        app: path.join(__dirname, "client", "index.js")
    },
    output: {
        path: path.join(__dirname, "dist"),
        filename: "[name].js",
        chunkFilename: "[name].js"
    },
    plugins: [
        //Typically you'd have plenty of other plugins here as well
        new webpack.DllReferencePlugin({
            context: path.join(__dirname, "client"),
            manifest: require("./dll/vendor-manifest.json")
        }),
    ],
    module: {
        loaders: [
            {
                test: /\.jsx?$/,
                loader: "babel",
                include: [
                    path.join(__dirname, "client") //important for performance!
                ],
                query: {
                    cacheDirectory: true, //important for performance
                    plugins: ["transform-regenerator"],
                    presets: ["react", "es2015", "stage-0"]
                }
            }
        ]
    },
    resolve: {
        extensions: ["", ".js", ".jsx"],
        root: path.resolve(__dirname, "client"),
        modulesDirectories: ["node_modules"]
    }
};
```

We’ve also done a few other things to increase performance including:

*   Make sure we have `cache: true`
*   Make sure that the babel loader has `cacheDirectory:true` in the query
*   Used an `include` for the babel loader (you should do this for all loaders)
*   Set devtool to `eval` because we’re optimizing for build time `#nobugs`

## Step 4, include the DLL

At this point, you’ve generated a vendor DLL file and you’ve got a Webpack build going to generate your app.js file. You need to serve and include both files in your template, but the DLL should come first. You’ve likely already got a template set up using the `HtmlWebpackPlugin`. Since we don’t care about hot reloading a DLL, you don’t really need to do anything special except including a `<script src="dll/dll.vendor.js"></script>` before your main app.js. If you’re using `webpack-middleware` or your own custom server, you’ll also need to make sure that DLL is being served. At this point, everything should be running as it was, but incremental builds with Webpack should be blazing fast.

## Step 5, build scripts

We can use NPM and `package.json` to add a few simple scripts to take care of building for us. To clean out the `dist` folder, go ahead and run `npm i rimraf --saveDev`. Now add to your package.json:

```
"scripts": {
    "clean": "rimraf dist",
    "build:webpack": "webpack --config config.prod.js",
    "build:dll": "webpack --config config.dll.js",
    "build": "npm run clean && npm run build:dll && npm run build:webpack",
    "watch": "npm run build:dll && webpack --config config.dev.js --watch --progress"
  }
```

Now you can run `npm run watch`. If you’d rather run `build:dll` manually, you can remove it from the watch script for faster startups.

## That’s all, folks!

I hope this gives you insight into how InVision uses Webpack’s `DLLPlugin` to increase our build speed. If you have any thoughts or questions, feel free to leave a comment!


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
