> * 原文地址：[A tale of Webpack 4 and how to finally configure it in the right way. Updated.](https://hackernoon.com/a-tale-of-webpack-4-and-how-to-finally-configure-it-in-the-right-way-4e94c8e7e5c1)
> * 原文作者：[Margarita Obraztsova](https://hackernoon.com/@riittagirl)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-tale-of-webpack-4-and-how-to-finally-configure-it-in-the-right-way.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-tale-of-webpack-4-and-how-to-finally-configure-it-in-the-right-way.md)
> * 译者：
> * 校对者：

# A tale of Webpack 4 and how to finally configure it in the right way. Updated.

Spoiler: there is no right way. #justwebpackthings

![](https://cdn-images-1.medium.com/max/2560/1*f2JinK5jRjYoLJ31kAKyLQ.jpeg)

Original photo: https://www.instagram.com/p/BhPo4pqBytk/?taken-by=riittagirl

> This blogpost has been last updated 28.12.2018 with webpack v4.28.0

* * *

> Update 23.06.2018: I have received a bunch of comments about what worked and what can be improved! Thank you for your feedback! I have tried to take every comment into consideration here! At a certain point I have also decided to create a webpack boilerplate project on github, were you can git pull the latest webapck.config! Thank you for your support! Link: [https://github.com/marharyta/webpack-boilerplate](https://github.com/marharyta/webpack-boilerplate)

* * *

> Update: this article is now a part of a series of articles about Webpack and React.js set ups. Read the next part about configuring dev environment with React here: [https://medium.com/@riittagirl/how-to-develop-react-js-apps-fast-using-webpack-4-3d772db957e4](https://medium.com/@riittagirl/how-to-develop-react-js-apps-fast-using-webpack-4-3d772db957e4)

* * *

> _Thanks for giving my tutorial so much feedback. I am proud to say that Webpack has twitted about it the other day and it was officially approved by a couple of contributors!_

![](https://cdn-images-1.medium.com/max/600/1*LMP6qbC151q2eJ7efXurmA.jpeg)

![](https://cdn-images-1.medium.com/max/600/1*UVme7DsXop97cirV0TuaWw.jpeg)

thanks!

* * *

There are a million tutorials online, so you probably have seen a thousand different ways to configure Webpack file. And all of them will be working examples. Why is it so? Webpack itself has been evolving really fast and a lot of loaders and plugins have to keep up. This is a major reason why the configuration files are so different: with a different version combination of the same tools things might work, or break.

Let me just say one thing, and this is my sincere opinion: a lot of people have been complaining about webpack and how cumbersome it is. This is true in many ways, although I have to say with my experience of working with **gulp and grunt**, you stumble upon the same type of errors there too, meaning that when you use **npm modules**, it’s inevitable that some versions would be incompatible.

Webpack 4 so far is the popular module bundler that has just undergone a massive update. There is a lot of new things it has to offer, such as **zero configuration, reasonable defaults, performance improvement, optimisation tools out of the box.**

If you are completely new to webpack, a great way to start would be to read the docs. [Webpack has a pretty nice documentation](https://webpack.js.org/concepts/) with many parts explained, so I will go through them very briefly.

**Zero config:** webpack 4 does not require a configuration file, this is new for the version 4. Webpack kinda grows step by step, so there is no need to do a monstrous configuration from the start.

**Performance improvement:** webpack 4 is the fastest version of webpack so far.

**Reasonable** **defaults:** webpack 4  main concepts are _entry, output, loaders, plugins_. I will not cover these in details, although the difference between loaders and plugins is very vague. It all depends on how library author has implemented it.

### Core concepts

#### Entry

This should be your _.js_ file. Now you will probably see a few configurations where people include _.scss_ or _.css_ file there. This is a major hack and can lead to a lot of unexpected errors. Also sometimes you see an entry with a few _.js_ files. While some solutions allow you to do so, I would say it usually adds more complexity and only do it when you really know why you are doing it.

#### Output

This is your _build/_ or _dist/_ or _wateveryounameit/_ folder where your end js file will be hosted. This is your end result comprised of modules.

#### Loaders

They mostly compile or transpile your code, like postcss-loader will go through different plugins. You will see it later.

#### Plugins

Plugins play a vital role in outputting your code into files.

### Quickstart

Create a new directory and move into it:

```
mkdir webpack-4-tutorial
cd webpack-4-tutorial
```

Initialize a package.json :

```
npm init

or

yarn init
```

We need to download **webpack v4** as a module and **webpack-cli** to run it from your terminal.

```
npm install webpack webpack-cli --save-dev

or

yarn add webpack webpack-cli --dev
```

Make sure you have version 4 installed, if not, you can explicitly specify it in your _package.json_ file. Now open up _package.json_ and add a build script:

```
"scripts": {
  "dev": "webpack"
}
```

Trying to run it, you will most likely see a warning:

```
WARNING in configuration

The ‘mode’ option has not been set, webpack will fallback to ‘production’ for this value. Set ‘mode’ option to ‘development’ or ‘production’ to enable defaults for each environment.

You can also set it to ‘none’ to disable any default behavior. Learn more: https://webpack.js.org/concepts/mode/
```

### Webpack 4 modes

You need to edit your script to contain mode flag:

```
"scripts": {
  "dev": "webpack --mode development"
}

ERROR in Entry module not found: Error: Can’t resolve ‘./src’ in ‘~/webpack-4-quickstart’
```

This means webpack is looking for a folder _.src/_ with an _index.js_ file. This is a default behaviour for webpack 4 since it requires zero configuration.

Let`s go create a directory with a _.js_ file like this **./src/index.js** and put some code there.

```
console.log("hello, world");
```

Now run the dev script:

```
npm run dev

or

yarn dev
```

If at this point you ran into an error, read the update of this section below. Otherwise, now you have a **./dist/main.js** directory. This is great since we know our code compiled. But what did just happen?

> By default, webpack requires zero configuration meaning you do not have to fiddle with webpack.config.js to get started using it. Because of that, it had to assume some default behaviour, such that it will always look for ./src folder by default and index.js in it and output to ./dist/main.js main.js is your compiled file with dependencies.

* * *

> Update 23.12.2018
>
> If you have run into this error:

```
ERROR in ./node_modules/fsevents/node_modules/node-pre-gyp/lib/publish.js

Module not found: Error: Can't resolve 'aws-sdk' in '/Users/mobr/Documents/workshop/test-webpack-4-setup/node_modules/fsevents/node_modules/node-pre-gyp/lib'
```

> described [here](https://github.com/webpack/webpack/issues/8400) in more details, then you are most likely using one of more mature webpack v4 releases.
>
> Unfortunately, you cannot solve it without creating a webpack.config.js file (I will show you how to do it below in this article). Just follow my tutorial till the ‘Transpile your .js code’ and copy-paste the config file. You will need to download [webpack-node-externals](https://github.com/liady/webpack-node-externals)

```
npm install webpack-node-externals --save-dev

or

yarn add webpack-node-externals --dev
```

> and import the following code there:

```
const nodeExternals = require('webpack-node-externals');
...
module.exports = {
    ...
    target: 'node',
    externals: [nodeExternals()],
    ...
};
```

> from this [module](https://github.com/liady/webpack-node-externals).

* * *

Having 2 configuration files is a common practice in webpack, especially in big projects. Usually you would have one file for development and one for production. In webpack 4 you have modes: _production_ and _development_. That eliminates the need for having two files (for medium-sized projects).

```
"scripts": {
  "dev": "webpack --mode development",
  "build": "webpack --mode production"
}
```

If you paid close attention, you have checked your _main.js_ file and saw it was not minified.

_I will use build script in this example since it provides a lot of optimisation out of the box, but feel free to use any of them from now on. The core difference between build and dev scripts is how they output files. Build is created for production code. Dev is created for development, meaning that it supports hot module replacement, dev server, and a lot of things that assist your dev work._

You can override defaults in npm scripts easily, just use flags:

```
"scripts": {
  "dev": "webpack --mode development ./src/index.js --output ./dist/main.js",
  "build": "webpack --mode production ./src/index.js --output ./dist/main.js"
}
```

This will override the default option without having to configure anything yet.

As an exercise, try also these flags:

*   — watch flag for enabling watch mode. It will watch your file changes and recompile every time some file has been updated.

```
"scripts": {
  "dev": "webpack --mode development ./src/index.js --output ./dist/main.js --watch",
  "build": "webpack --mode production ./src/index.js --output ./dist/main.js --watch"
}
```

*   — entry flag. Works exactly like output, but rewrites the entry path.

### Transpile your .js code

Modern JS code is mostly written is ES6, and ES6 is not supported by all the browsers. So you need to transpile it — a fancy word for turn your ES6 code into ES5. You can use **babel** for that — the most popular tool to transpile things now. Of course, we do not only do it for ES6 code, but for many JS implementations such as TypeScript, React, etc.

```
npm install babel-core babel-loader babel-preset-env --save-dev

or

yarn add babel-core babel-loader babel-preset-env --dev
```

This is the part when you need to create a config file for babel.

```
nano .babelrc
```

paste there:

```
{
"presets": [
  "env"
  ]
}
```

We have two options for configuring babel-loader:

*   using a configuration file **webpack.config.js**
*   using --module-bind in your **npm scripts**

You can technically do a lot with new flags webpack introduces but I would prefer **webpack.config.js** for simplicity reasons.

### Configuration file

Although webpack advertises itself as a zero-configuration platform, it mostly applies to general defaults such as entry and output.

At this point we will create **webpack.config.js** with the following content:

```
// webpack v4

const path = require('path');

// update from 23.12.2018
const nodeExternals = require('webpack-node-externals');

module.exports = {
  entry: { main: './src/index.js' },
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'main.js'
  },
  target: 'node', // update from 23.12.2018
  externals: [nodeExternals()], // update from 23.12.2018
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader"
        }
      }
    ]
  }
};
```

also we will remove flags from our npm scripts now.

```
"scripts": {
  "build": "webpack --mode production",
  "dev": "webpack --mode development"
},
```

Now when we run **_npm run build or yarn build_** it should output us a nice minified _.js_ file into _./dist/main.js_ If not, try re-installing **babel-loader.**

* * *

> Update 23.12.2018
>
> If you run into a **module ‘@babel/core’ conflict,** it means that some of your preloaded babel dependencies are not compatible. In my case, I got

```
Module build failed: Error: Cannot find module '@babel/core'

babel-loader@8 requires Babel 7.x (the package '@babel/core'). If you'd like to use Babel 6.x ('babel-core'), you should install 'babel-loader@7'.
```

> which I solved by

```
yarn add @babel/core --dev
```

* * *

> The most common pattern of webpack is to use it to compile React.js application. While this is true, we will not concentrate on React part in this tutorial since I want it to be framework agnostic. Instead, I will show you how to proceed and create your .html and .css configuration.

### HTML and CSS imports

Lets create a small _index.html_ file first in our _./dist_ folder

```
<html>
  <head>
    <link rel="stylesheet" href="style.css">
  </head>
  <body>
    <div>Hello, world!</div>
    <script src="main.js"></script>
  </body>
</html>
```

As you can see, we are importing here _style.css_ Lets configure it! As we agreed, we ca only have one entry point for webpack. So where do we put our css to?Create a _style.css_ in our _./src_ folder

```
div {
  color: red;
}
```

Do not forget to include it into your .js file:

```
import "./style.css";
console.log("hello, world");
```

> Spoiler: in certain articles, you will hear that ExtractTextPlugin does not work with webpack 4. It worked for me for webpack v4.2 but stopped working as I used webpack v4.20. It proves my point of modules ambiguity in set-up and if it absolutely does not work for you, you can switch to MiniCssExtractPlugin. I will show you how to configure another one later in this article.
>
> For backwards compatibility, I will still show ExtractTextPlugin example, yet feel free to skim it and move to a part where I am using MiniCssExtractPlugin.

In webpack create a new rule for css files:

```
// webpack v4
const path = require('path');

// update from 23.12.2018
const nodeExternals = require('webpack-node-externals');

const ExtractTextPlugin = require('extract-text-webpack-plugin');

module.exports = {
  entry: { main: './src/index.js' },
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'main.js'
  },
  target: 'node', // update from 23.12.2018
  externals: [nodeExternals()], // update from 23.12.2018  
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader"
        }
      },
      {
        test: /\.css$/,
        use: ExtractTextPlugin.extract(
          {
            fallback: 'style-loader',
            use: ['css-loader']
          })
      }
    ]
  }
};
```

in terminal run

```
npm install extract-text-webpack-plugin --save-dev
npm install style-loader css-loader --save-dev

or

yarn add extract-text-webpack-plugin style-loader css-loader --dev
```

We need to use extract text plugin to compile our **.css**. As you can see, we also added a new rule for **.css**. Since version 4, Webpack 4 has problems with this plugin, so you might run into this error:

- [**Webpack 4 compatibility · Issue #701 · webpack-contrib/extract-text-webpack-plugin**](https://github.com/webpack-contrib/extract-text-webpack-plugin/issues/701 "https://github.com/webpack-contrib/extract-text-webpack-plugin/issues/701")

To fix it, you can run

```
npm install -D extract-text-webpack-plugin@next

or

yarn add --dev extract-text-webpack-plugin@next
```

> Pro tip: google errors you get and try to find similar question in Github issues or just ask a question on StackOverflow.

After that, your css code should compile to _./dist/style.css_

At this point in my package.json my dev dependencies look like this:

```
"devDependencies": {
    "babel-core": "^6.26.0",
    "babel-loader": "^7.1.4",
    "babel-preset-env": "^1.6.1",
    "css-loader": "^0.28.11",
    "extract-text-webpack-plugin": "^4.0.0-beta.0",
    "style-loader": "^0.20.3",
    "webpack": "^4.4.1",
    "webpack-cli": "^2.0.12"
  }
```

your versions might differ and it is ok!

Please, note that another combination might not work since even updating webpack-cli v2.0.12 to 2.0.13 can break it. #justwebpackthings

So now it should output your _style.css_ into _./dist_ folder.

![](https://cdn-images-1.medium.com/max/800/1*q72pzP6EMWubm7J_IESMaw.png)

### Mini-CSS plugin

The Mini CSS plugin is meant to replace extract-text plugin and provide you with better future compatibility. I have restructured my webpack file to compile style.css with [**/mini-css-extract-plugin**](https://github.com/webpack-contrib/mini-css-extract-plugin "https://github.com/webpack-contrib/mini-css-extract-plugin") **and it works for me.**

```
npm install mini-css-extract-plugin --save-dev

or

yarn add mini-css-extract-plugin --dev
```

and

```
// webpack v4
const path = require('path');

// update from 23.12.2018
const nodeExternals = require('webpack-node-externals');

// const ExtractTextPlugin = require('extract-text-webpack-plugin');
const MiniCssExtractPlugin = require("mini-css-extract-plugin");

module.exports = {
  entry: { main: './src/index.js' },
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: '[name].[chunkhash].js'
  },
  target: 'node', // update from 23.12.2018
  externals: [nodeExternals()], // update from 23.12.2018
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader"
        }
      },
      {
        test: /\.css$/,
        use:  [  'style-loader', MiniCssExtractPlugin.loader, 'css-loader']
      }
    ]
  },
  plugins: [
    new MiniCssExtractPlugin({
      filename: 'style.css',
    })
  ]
};
```

As Nikolay Volkov pointed out, ‘style-loader’ might not be necessary anymore since **MiniCssExtractPlugin.loader does the same.** Though it might be true I would still recommend to leave it for the fallback.

### How do Webpack rules work?

> A quick description of how rules usually work:

```
{
        test: /\.YOUR_FILE_EXTENSION$/,
        exclude: /SOMETHING THAT IS THAT EXTENSION BUT SHOULD NOT BE PROCESSED/,
        use: {
          loader: "loader for your file extension  or a group of loaders"
        }
}
```

**We need to use** **MiniCssExtractPlugin because webpack by default only understands _.js_ format. MiniCssExtractPlugin gets your _.css_ and extracts it into a separate _.css_ file in your _./dist_ directory.**

### Configure support for SCSS

It is very common to develop websites with SASS and POSTCSS, they are very helpful. So we will include support for SASS first. Let`s rename our _./src/style.css_ and create another folder to store _.scss_ files in there. Now we need to add support for _.scss_ formatting.

```
npm install node-sass sass-loader --save-dev

or

yarn add node-sass sass-loader --dev
```

replace style.css with **_./scss/main.scss_** in your _.js_ file. Change test to support _.scss_

```
// webpack v4
const path = require('path');
// update 23.12.2018
const nodeExternals = require('webpack-node-externals');

const MiniCssExtractPlugin = require("mini-css-extract-plugin");

module.exports = {
  entry: { main: './src/index.js' },
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'main.js'
  },
  target: "node", // update 23.12.2018
  externals: [nodeExternals()], // update 23.12.2018
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader"
        }
      },
      {
        test: /\.scss$/,
        use: [
          "style-loader",
          MiniCssExtractPlugin.loader,
          "css-loader",
          "sass-loader"
        ]
      }
    ]
  } ...
```

### HTML template

Now lets create _.html_ file template. Add _index.html_ to _./src_ file with exactly the same structure.

```
<html>
  <head>
    <link rel="stylesheet" href="style.css">
  </head>
  <body>
    <div>Hello, world!</div>
    <script src="main.js"></script>
  </body>
</html>
```

We will need to use html plugin for this file in order to use it as a template.

```
npm install html-webpack-plugin --save-dev

or

yarn add html-webpack-plugin --dev
```

Add it to your webpack file:

```
// webpack v4
const path = require('path');
// update 23.12.2018
const nodeExternals = require('webpack-node-externals');

const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
  entry: { main: './src/index.js' },
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'main.js'
  },
  target: "node", // update 23.12.2018
  externals: [nodeExternals()], // update 23.12.2018

  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader"
        }
      },
      {
        test: /\.scss$/,
        use: [
          "style-loader",
          MiniCssExtractPlugin.loader,
          "css-loader",
          "sass-loader"
        ]
      }
    ]
  },
  plugins: [ 
    new MiniCssExtractPlugin({
      filename: "style.css"
    }),
    new HtmlWebpackPlugin({
      inject: false,
      hash: true,
      template: './src/index.html',
      filename: 'index.html'
    })
  ]
};
```

Now your file from _./src/index.html_ is a template for your final index.html file. To check that everything works, delete every file from _./dist_ folder and the folder itself.

```
rm -rf ./dist
npm run dev

or
 
yarn dev
```

You will see that _./dist_ folder was created on its own and there are three files: **index.html, style.css, main.js.**

### Caching and Hashing

One of the most common problems in development is implementing caching. It is very important to understand how it works since you want your users to always have the best latest version of your code.

Since this blogpost is mainly about webpack configuration, we will not concentrate on how caching works in details. I will just say that one of the most popular ways to solve caching problems is adding a **_hash number_** to asset files, such _style.css_ and _script.js_. **You can read about it** [**here**](https://developers.google.com/web/fundamentals/performance/webpack/use-long-term-caching#split-the-code-into-routes-and-pages)**.** Hashing is needed to teach our browser to only request changed files.

Webpack 4 has a prebuilt functionality for it implemented via [**chunkhash**](https://webpack.js.org/guides/caching/). It can be done with:

```
// webpack v4
const path = require('path');

// update 23.12.2018
const nodeExternals = require("webpack-node-externals");

const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
  entry: { main: './src/index.js' },
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: '[name].[chunkhash].js'
  },
  target: "node",
  externals: [nodeExternals()],
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader"
        }
      },
      {
        test: /\.scss$/,
        use: [
            "style-loader",
            MiniCssExtractPlugin.loader,
            "css-loader",
            "sass-loader"
          ]
       }
    ]
  },
  plugins: [ 
    new MiniCssExtractPlugin({
     filename: "style.[contenthash].css"
    }),

    new HtmlWebpackPlugin({
      inject: false,
      hash: true,
      template: './src/index.html',
      filename: 'index.html'
    })
  ]
};
```

In your _./src/index.html_ file add

```
<html>
  <head>
    <link rel="stylesheet" href="<%=htmlWebpackPlugin.files.chunks.main.css %>">
  </head>
  <body>
    <div>Hello, world!</div>
    <script src="<%= htmlWebpackPlugin.files.chunks.main.entry %>"></script>
  </body>
</html>
```

This syntax will teach your template to use hashed files. This is a new feature implemented after this issue:

- [**Support for .css and .manifest files and cache busting by jantimon · Pull Request #14**](https://github.com/jantimon/html-webpack-plugin/pull/14 "https://github.com/jantimon/html-webpack-plugin/pull/14")

We will use **htmlWebpackPlugin.files.chunks.main** pattern described there. Check our **_./dist_** file **index.html**

![](https://cdn-images-1.medium.com/max/800/1*eAcjaMGzriv946f1lI3-Hw.png)

![](https://cdn-images-1.medium.com/max/800/1*Ccl_haaqqZ4OrEco0ZCZtQ.png)

If we do not change anything in our _.js_ and. _css_ file and run

```
npm run dev
```

no matter how many times you run it, the numbers in hashes should be identical to each other in both files.

### Problem with CSS hashing and how to solve it

* * *

> Update 28.12.2018
>
> This problem might exist if you are using ExtractTextPlugin for your CSS with webpack 4. If you use MiniCssExtractPlugin, this problem should not occur, yet it is beneficial to read about it!

* * *

Although we have the working implementation here, it is not perfect yet. What if we change some code in our _.scss_ file? Go ahead, change some scss there and run dev script again. Now the new file hash is not generated. What if we add a new console.log to our _.js_ file like this:

```
import "./style.css";
console.log("hello, world");
console.log("Hello, world 2");
```

If you run a dev script again, you will see that hash number has been updated in both files.

This issue is known and there is even a stack overflow question about it:

- [**Updating chunkhash in both css and js file in webpack**: I have only got the JS file in the output whereas i have used the ExtractTextPlugin to extract the Css file.Both have…](https://stackoverflow.com/questions/44491064/updating-chunkhash-in-both-css-and-js-file-in-webpack "https://stackoverflow.com/questions/44491064/updating-chunkhash-in-both-css-and-js-file-in-webpack")

#### Now how to fix that?

After trying a lot of plugins that claim they solve this problem I have finally came to two types of solution.

#### Solution 1

There might also be some conflicts still, so **now lets try** [**mini-css-extract plugin**](https://github.com/webpack-contrib/mini-css-extract-plugin)**.**

#### Solution 2

Replace **[chukhash]** with just **[hash]** in _.css_ extract plugin. This was one of the solutions to the [issue](https://github.com/webpack-contrib/extract-text-webpack-plugin/issues/763). This appears to be a conflict with webpack 4.3 which introduced a `[contenthash]` variable of its [own](https://github.com/webpack/webpack/releases/tag/v4.3.0). In conjunction, use this plugin: [**webpack-md5-hash**](https://www.npmjs.com/package/webpack-md5-hash) **(see more below).**

Now lets test our _.js_ files: both files change hash.

### Problem with JS hashing and how to solve it

In case if you are already using MiniCssExtractPlugin you have an opposite problem: **every time you change something in your SCSS, both .js file and .css output files change hashes.**

#### Solution:

Use this plugin: [**webpack-md5-hash**](https://www.npmjs.com/package/webpack-md5-hash)  If you make changes to your _main.scss_ file and run dev script, only a new _style.css_ should be generated with a new hash, not both.

```
// webpack v4
const path = require('path');
// update 23.12.2018
const nodeExternals = require("webpack-node-externals");

const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const HtmlWebpackPlugin = require("html-webpack-plugin");
const WebpackMd5Hash = require("webpack-md5-hash");

module.exports = {
  entry: { main: './src/index.js' },
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: '[name].[chunkhash].js'
  },
  target: "node", // update 23.12.2018
  externals: [nodeExternals()], // update 23.12.2018
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader"
        }
      },
      {
        test: /\.scss$/,
        use: ExtractTextPlugin.extract(
          {
            fallback: 'style-loader',
            use: ['css-loader', 'sass-loader']
          })
      }
    ]
  },
  plugins: [ 
    new MiniCssExtractPlugin({
      filename: "style.[contenthash].css"
    }),
    new HtmlWebpackPlugin({
      inject: false,
      hash: true,
      template: "./src/index.html",
      filename: "index.html"
    }),
    new WebpackMd5Hash()
  ]
};
```

> Now when I edit main.scss a new hash for style.css is generated. And when I edit css only css hash changes and when I edit ./src/script.js only script.js hash changes!

### Integrating PostCSS

To have out output _.css_ polished, we can add PostCSS on top.

[PostCSS](https://github.com/postcss/postcss) provides you with **autoprefixer, cssnano** and other nice and handy stuff. I will show what I am using on a daily basis. We will need **postcss-loader.** We will also install autoprefixer as we will need it later.

```
npm install postcss-loader --save-dev
npm i -D autoprefixer

or

yarn add postcss-loader autoprefixer --dev
```

> Spoiler: you do not have to use webpack to benefit from PostCSS, it has a pretty decent [post-css-cli](https://github.com/postcss/postcss-cli) plugin that allows you to use it in npm script.

Create _postcss.config.js_ where you require relevant plugins, paste

```
module.exports = {
    plugins: [
      require('autoprefixer')
    ]
}
```

Our _webpack.config.js_ now should look like this:

```
// webpack v4
const path = require('path');
// update 23.12.2018
const nodeExternals = require("webpack-node-externals");

const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const HtmlWebpackPlugin = require("html-webpack-plugin");
const WebpackMd5Hash = require("webpack-md5-hash");

module.exports = {
  entry: { main: './src/index.js' },
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: '[name].[chunkhash].js'
  },
  target: "node",
  externals: [nodeExternals()],
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader"
        }
      },
      {
        test: /\.scss$/,
        use:  [  'style-loader', MiniCssExtractPlugin.loader, 'css-loader', 'postcss-loader', 'sass-loader']
      }
    ]
  },
  plugins: [
    new MiniCssExtractPlugin({
      filename: 'style.[contenthash].css',
    }),
    new HtmlWebpackPlugin({
      inject: false,
      hash: true,
      template: './src/index.html',
      filename: 'index.html'
    }),
    new WebpackMd5Hash()
  ]
};
```

Please, pay attention to the order of plugins we use for our .scss

```
use:  [  'style-loader', MiniCssExtractPlugin.loader, 'css-loader', 'postcss-loader', 'sass-loader']
```

The loader uses plugins from the end to the beginning.

You can test [**autoprefixer**](https://github.com/postcss/autoprefixer) by adding more code to your .scss files and checking the output. There is also a way to fix the output by specifying which browser you want to support in the _.browserslistrc_ file.

I would direct you to [https://www.postcss.parts/](https://www.postcss.parts/) to explore the plugins available for PostCSS, such as:

*   [utilities](https://github.com/ismamz/postcss-utilities)
*   [cssnano](https://github.com/ben-eb/cssnano)
*   [style-lint](https://github.com/stylelint/stylelint)

I will use **cssnano** to minify my output file and [css-mqpacker](https://github.com/hail2u/node-css-mqpacker) to arrange my media queries. I also have received some messages that:

![](https://cdn-images-1.medium.com/max/800/1*8TyHjIG5jTjPFn51icEVtA@2x.jpeg)

Feel free to try **cleancss** if you want to.

### Version controlling

To keep your dependencies in place, I recommend using **yarn** instead of **npm to install modules. Long story short, this will lock every package and when you do node modules reinstallation, you will avoid many incompatibility surprises.**

### Keeping it clean and fresh

We can try importing **clean-webpack-plugin** to clean our _./dist_ folder before we regenerate files.

```
// webpack v4
const path = require('path');
// update 23.12.2018
const nodeExternals = require("webpack-node-externals");

const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const HtmlWebpackPlugin = require("html-webpack-plugin");
const WebpackMd5Hash = require("webpack-md5-hash");
const CleanWebpackPlugin = require('clean-webpack-plugin');

module.exports = {
  entry: { main: './src/index.js' },
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: '[name].[chunkhash].js'
  },
  target: "node",
  externals: [nodeExternals()],

  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader"
        }
      },
      {
        test: /\.scss$/,
        use:  [  'style-loader', 
                 MiniCssExtractPlugin.loader, 
                 'css-loader', 
                 'postcss-loader', 
                 'sass-loader']
      }
    ]
  },
  plugins: [ 
    new CleanWebpackPlugin('dist', {} ),
    new MiniCssExtractPlugin({
      filename: 'style.[contenthash].css',
    }),
    new HtmlWebpackPlugin({
      inject: false,
      hash: true,
      template: './src/index.html',
      filename: 'index.html'
    }),
    new WebpackMd5Hash()
  ]
};
```

Now that we have our configuration clean and neat, we can rock on!

> Here I have provided you with my configuration file and my way to configure it step by step. Note: since a lot of npm dependencies might change by the time you read this the same config might not work for you! I kindly ask you to leave your errors in the comments below so that I can edit it later. Today is 05.04.2018

* * *

**The latest revision of this article is 28.12.2018**

The _package.json_ with the latest versions of plugins has the following structure:

```
{
 “name”: “webpack-test”,
 “version”: “1.0.0”,
 “description”: “”,
 “main”: “index.js”,
 “scripts”: {
 “build”: “webpack --mode production”,
 “dev”: “webpack --mode development”
 },
 “author”: “”,
 “license”: “ISC”,
 "devDependencies": {
   "@babel/core": "^7.2.2",
   "autoprefixer": "^9.4.3",
   "babel-core": "^6.26.3",
   "babel-loader": "^8.0.4",
   "babel-preset-env": "^1.7.0",
   "css-loader": "^2.0.2",
   "html-webpack-plugin": "^3.2.0",
   "mini-css-extract-plugin": "^0.5.0",
   "node-sass": "^4.11.0",
   "postcss-loader": "^3.0.0",
   "sass-loader": "^7.1.0",
   "style-loader": "^0.23.1",
   "webpack": "4.28",
   "webpack-cli": "^3.1.2"
},

 "dependencies": {
   "clean-webpack-plugin": "^1.0.0",
   "webpack-md5-hash": "^0.0.6",
   "webpack-node-externals": "^1.7.2"
 }
}
```

* * *

> Read the next part about configuring dev environment with React here: [How to streamline your React.js development process using Webpack 4](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-develop-react-js-apps-fast-using-webpack-4.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
