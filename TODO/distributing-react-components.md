> * 原文链接 : [Distributing React components](http://krasimirtsonev.com/blog/article/distributing-react-components-babel-browserify-webpack-uglifyjs)
* 原文作者 : [Krasimir ](http://krasimirtsonev.com/blog/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者: 
* 状态 :  待定

While I was open sourcing [react-place](https://github.com/krasimir/react-place) I noticed that there is some complexity around preparing the component for releasing. I decided to document the process here so I have a solid resource next time. You may be surprised but writing the working `jsx` file doesn’t mean that the component is ready for publishing and is usable for other developers.

## [](http://krasimirtsonev.com/blog/article/distributing-react-components-babel-browserify-webpack-uglifyjs#the-component)The component

[react-place](https://github.com/krasimir/react-place) is a component that renders an input field. The user starts typing a city name and the component makes predictions/suggestions. The component accepts a property called `onLocationSet`. It is fired once the user selects some of the suggestions. The function receives an object containing short description and geo coordinates of the city. Overall, we have a communication with an external API (Google maps) and a hard dependency involved (autocomplete widget). A demo of how the component works could be seen [here](http://krasimir.github.io/react-place/example/index.html).

Let’s see how the component was done and why after finishing it it wasn’t ready for publishing.
#Toolset
There are few things which are at the top of the wave right now. One of them is React and its [JSX syntax](https://facebook.github.io/react/docs/jsx-in-depth.html). Another one is the new ES6 spec and all these goodies that are landing in our browsers. I wanted to use them as soon as possible but because they are not well supported everywhere I needed a transpiler. Tool that will parse my ES6 code and will produce ES5 version. [Babel](http://babeljs.io/) does the job and plays very well with React. Along with the transpiler I needed a bundler. Something that will resolve the [imports](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/import) and will generate only one file containing my application. My choice for that is [webpack](https://webpack.github.io/).

## [](http://krasimirtsonev.com/blog/article/distributing-react-components-babel-browserify-webpack-uglifyjs#the-base)The base

Before a couple of weeks I created [react-webpack-started](https://github.com/krasimir/react-webpack-starter). It gets JSX file as an input and using Babel generates ES5 file. We have a local dev server running, testing setup and a linter but that’s another story (more about that [here](http://krasimirtsonev.com/blog/article/a-modern-react-starter-pack-based-on-webpack)).

Last half a year I like to use NPM as a place to define the project’s build tasks. Here are the NPM scripts that I was able to run in the beginning:

    // in package.json
    "scripts": {
      "dev": "./node_modules/.bin/webpack --watch --inline",
      "test": "karma start",
      "test:ci": "watch 'npm run test' src/"
    }

`npm run dev` fires the webpack compilation and the dev server. The testing is done with [Karma runner](http://karma-runner.github.io/) and Phantomjs. The directory structure that I used is as follows:

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

The component that I want to publish is placed in `Location.jsx`. In order to test it I created a simple app (`example-es6` folder) that imports the file.

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
