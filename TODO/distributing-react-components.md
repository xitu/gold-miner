> * 原文链接 : [Distributing React components](http://krasimirtsonev.com/blog/article/distributing-react-components-babel-browserify-webpack-uglifyjs)
* 原文作者 : [Krasimir ](http://krasimirtsonev.com/blog/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [aleen42](http://aleen42.github.io/)
* 校对者: 
* 状态 :  待定

&#160; &#160; &#160; &#160;在我开源 [react-place](https://github.com/krasimir/react-place) 项目到时候，我注意到那么一个问题。那就是，在准备构件发布方面上存在着一定的复杂度。因此，我决定在此用文档的形式记录该过程，以便日后遇到同样的问题时可查。
<br />
&#160; &#160; &#160; &#160;在准备构件期间，你会惊奇地发现建立`jsx`文件并不意味着该构件可用于发布，因为`jsx`文件对于其他开发人员来说，是不可重用的东西。

## [](http://krasimirtsonev.com/blog/article/distributing-react-components-babel-browserify-webpack-uglifyjs#the-component)构件

&#160; &#160; &#160; &#160;[react-place](https://github.com/krasimir/react-place) 是一个提供输入服务的构件。当用户输入一个城市的名字时，该构件会作出预测并提供建议选项给该用户。`onLocationSet`是该构件的一个属性值。当用户选择某些建议选项时，它将被进行赋值操作。除此之外，该构件里有那么一个函数，它是接收一个对象作为参数输入。该对象包含有对一个城市的简短描述以及其地理坐标。总的来说，我们是和一个外部 API （谷歌地图）和一个参与的硬关联（自动完成输入组件）进行通信操作。[这里](http://krasimir.github.io/react-place/example/index.html)，有一个展示该构件如何工作的例子。

&#160; &#160; &#160; &#160;我们来一起看看构件是如何完成？为何完成后，该构件还不能被发布？

&#160; &#160; &#160; &#160;时下，有一些概念处于风口浪尖。其中，就有 React 和它的[ JSX 语法](https://facebook.github.io/react/docs/jsx-in-depth.html)。另外，还有新版的 ES6 标准，而所有的这些，都与我们的浏览器息息相关。虽然，我想尽早应用这些新鲜的概念，但我需要一个转译器，用于解决它们兼容性不高的问题。该转译器将需要解析 ES6 版本的代码并生成对应的 ES5 版本的。[Babel](http://babeljs.io/) 就是一款专门做这样工作的转换编译器，并且它能很好地结合于 React 使用。除了转译器之外，我还需要一个代码包装工具。该工具能解析[输入](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/import)并生成一个包含应用的文件。在众多包装工具中，[webpack](https://webpack.github.io/) 就是我的选择。

## [](http://krasimirtsonev.com/blog/article/distributing-react-components-babel-browserify-webpack-uglifyjs#the-base)The base

&#160; &#160; &#160; &#160;两周前，我创建了一个 [react-webpack-started](https://github.com/krasimir/react-webpack-starter)。它接收一个 JSX 文件作为输入并用 Babel 生成对应的 ES5 文件。我们有一部用于服务的本地设备、测试设定以及一个 linter 插件，然而这是另外一个故事，这里并不详述。（在[这里](http://krasimirtsonev.com/blog/article/a-modern-react-starter-pack-based-on-webpack)有相关更多的信息）。

&#160; &#160; &#160; &#160;在半年前，我更喜欢用 NPM 来定义项目的建立任务。下面是我刚开始可以运行的 NPM 脚本：

    // in package.json
    "scripts": {
      "dev": "./node_modules/.bin/webpack --watch --inline",
      "test": "karma start",
      "test:ci": "watch 'npm run test' src/"
    }

&#160; &#160; &#160; &#160;`npm run dev` 该命令将触发 webpack 进行编译并启动设备进行服务。测试是通过 [Karma runner](http://karma-runner.github.io/) 和 Phantomjs 来完成的。而我使用的文件结构则如下所示：

    |
    +-- example-es6
    |   +-- build
    |   |   +-- app.js
    |   |   +-- app.js.map
    |   +-- src
    |   |   +-- index.js
    |   +-- index.html
    +-- src
        +-- vendor
        |   +-- google.js
        + -- Location.jsx

&#160; &#160; &#160; &#160;我要发布的构件是放在`Location.jsx`里。为了测试它，我创建了一个简单的 app 应用（`example-es6` 文件夹）来导入该文件。

I spent some time developing the component and finally it was done. I pushed the changes to the [repository](https://github.com/krasimir/react-place) in GitHub and I thought that it is ready for distributing. Well, five minutes later I realized that it wasn’t enough. Here is why:

*   If I publish the component as a NPM package I’ll need an entry point. Is my JSX file suitable for that? No, it’s not because not every developer likes JSX. The component should be distributed in a non-JSX version.
*   My code is written in ES6\. Not every developer uses ES6 and has a transpiler in its building process. So the entry point should be ES5 compatible.
*   The output of webpack indeed satisfies the two points above but it has one problem. What we have is a bundle. It contains the whole React library. We want to bundle the autocomplete widget but not React.

So, webpack is useful while developing but can’t generate a file that could be required or imported. I tried using the [externals](https://webpack.github.io/docs/library-and-externals.html) option but that works if we have globally available dependencies.

## [](http://krasimirtsonev.com/blog/article/distributing-react-components-babel-browserify-webpack-uglifyjs#producing-es5-entry-point)Producing ES5 entry point

So, defining a new NPM script made a lot of sense. NPM even [has](https://docs.npmjs.com/misc/scripts) a `prepublish` entry that runs before the package is published and local `npm install`. I continued with the following:

    // package.json
    "scripts": {
      "prepublish": "./node_modules/.bin/babel ./src --out-dir ./lib --source-maps --presets es2015,react"
      ...
    }

No webpack, just Babel. It gets everything from the `src` directory, converts the JSX to pure JavaScript calls and ES6 to ES5\. The result is:

    |
    +-- example-es6
    +-- lib
    |   +-- vendor
    |   |   +-- google.js
    |   |   +-- google.js.map
    |   +-- Location.js
    |   +-- Location.js.map
    +-- src
        +-- vendor
        |   +-- google.js
        + -- Location.jsx

The `src` folder is translated to plain JavaScript plus source maps generated. An important role here plays the presets [`es2015`](https://babeljs.io/docs/plugins/preset-es2015/) and [`react`](https://babeljs.io/docs/plugins/preset-react/).

In theory, from within a ES5 code we should be able to `require('Location.js')` and get the component working. However, when I opened the file I saw that there is no `module.exports`. Only

    exports.default = Location;

Which means that I had to require the library with

    require('Location').default;

Thankfully there is plugin [babel-plugin-add-module-exports](https://www.npmjs.com/package/babel-plugin-add-module-exports) that solves the issue. I changed the script to:

    ./node_modules/.bin/babel ./src --out-dir ./lib 
    --source-maps --presets es2015,react 
    --plugins babel-plugin-add-module-exports

## [](http://krasimirtsonev.com/blog/article/distributing-react-components-babel-browserify-webpack-uglifyjs#generating-browser-bundle)Generating browser bundle

The result of the previous section was a file which may be imported/required by any JavaScript project. Any bundling tool like webpack or [Browserify](http://browserify.org/) will resolve the needed dependencies. The last bit that I had to take care is the case where the developer doesn’t use a bundler. Let’s say that I want an already generated JavaScript file add it to my page with a `script>` tag. I assume that React is already loaded on the page and I need only the component with its autocomplete widget included.

To achieve this I effectively used the file under the `lib` folder. I mentioned Browserify above so let’s go with it:

    ./node_modules/.bin/browserify ./lib/Location.js 
    -o ./build/react-place.js 
    --transform browserify-global-shim 
    --standalone ReactPlace

`-o` option is used to specify the output file. `--standalone` is needed because I don’t have a module system and I need a global access to the component. The interesting bit is `--transform browserify-global-shim`. This is the transform plugin that excludes React but imports the autocomplete widget. To make it works I created a new entry in `package.js`:

    // package.json
    "browserify-global-shim": {
      "react": "React",
      "react-dom": "ReactDOM"
    }

I specified the names of the global variables that will be resolve when I call `require('react')` and `require('react-dom')` from within the component. If we open the generated `build/react-place.js` file we will see:

    var _react = (window.React);
    var _reactDom = (window.ReactDOM);

And when I talk about a component that is dropped as a `script>` tag then I think we need a minification. In production we should use a compressed version of the same `build/react-place.js` file. [Uglifyjs](https://www.npmjs.com/package/uglify-js) is a nice module for minifying JavaScript. Just after the Browserify call:

    ./node_modules/.bin/uglifyjs ./build/react-place.js 
    --compress --mangle 
    --output ./build/react-place.min.js 
    --source-map ./build/react-place.min.js.map

## [](http://krasimirtsonev.com/blog/article/distributing-react-components-babel-browserify-webpack-uglifyjs#the-result)The result

The final script is a combination of Babel, Browserify and Uglifyjs:

    // package.json
    "prepublish": "
      ./node_modules/.bin/babel ./src --out-dir ./lib --source-maps --presets es2015,react --plugins babel-plugin-add-module-exports && 
      ./node_modules/.bin/browserify ./lib/Location.js -o ./build/react-place.js --transform browserify-global-shim --standalone ReactPlace && 
      ./node_modules/.bin/uglifyjs ./build/react-place.js --compress --mangle --output ./build/react-place.min.js --source-map ./build/react-place.min.js.map
    ",

_(notice that I added few new lines to make the script readable here but in the [original package.json](https://github.com/krasimir/react-place/blob/master/package.json#L25) file everything is placed onto one line)_

The final directories/files in the project look like the following:

    |
    +-- build
    |   +-- react-place.js
    |   +-- react-place.min.js
    |   +-- react-place.min.js.map
    +-- example-es6
    |   +-- build
    |   |   +-- app.js
    |   |   +-- app.js.map
    |   +-- src
    |   |   +-- index.js
    |   +-- index.html
    +-- lib
    |   +-- vendor
    |   |   +-- google.js
    |   |   +-- google.js.map
    |   +-- Location.js
    |   +-- Location.js.map
    +-- src
        +-- vendor
        |   +-- google.js
        + -- Location.jsx
