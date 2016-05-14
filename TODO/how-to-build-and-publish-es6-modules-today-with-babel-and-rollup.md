>* 原文链接 : [How to Build and Publish ES6 Modules Today, with Babel and Rollup](https://medium.com/@tarkus/how-to-build-and-publish-es6-modules-today-with-babel-and-rollup-4426d9c7ca71#.oqt9xunbj)
* 原文作者 : [Konstantin Tarkus](https://medium.com/@tarkus)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:

The ES2015 specification, also referred to as ES6, has been approved by ECMA International back in June 2015\. In April 2016, Node.js Foundation team has released Node.js framework v6 supporting 93% of ES6 language features, thanks to V8 v5.0.
ES2015 规范，也被称为 ES6，在2015年六月被 ECMA 国际批准成为正式标准。而在2016年四月，Node.js 基金会就发布了支持93%的 ES6 语言特性的 Node.js 框架 v6，多亏了 V8引擎 v5.0版本。

It’s hard to argue that having a JavaScript library written by using ES6+ syntax and existing language features instead of relying on 3rd party libraries and plyfills has clear benefits. Such as having less verbose, more readable code, using fewer abstractions, having the codebase that is easy to maintain and extend, being able to develop your library faster, **first to market** in the Lean Startup terminology.
很难去争辩用 ES6 及以上的语法和现有语言特性替代第三方库和 plyfills 有明显好处。比如更加简洁，更可读的代码，更少的抽象化，更利于维护和扩展代码库，开发你的库更快，**市场首入** 是一个精益术语。

If you’re developing a brand new JavaScript library (npm module) targeting Node.js platform, it might be a good idea to publish it on NPM optimized for Node.js v6 environment, and optionally provide a fallback for developers who are still forced to use v5 and earlier versions of Node.js. So that, Node 6 users could import your library as regular:
如果你正在开发一个 Node.js 上全新 JavaScript 库(npm 模块)，对 Node.js v6 环境进行优化可能是一个好主意，然后对还在使用 Node.js v5 和更早版本选择性地提供回退。

    const MyLibrary = require('my-library');

Yet being sure that the code will operate well in Node.js 6 environment. Whereas Node 0.x, 4.x, 5.x users would import ES5.1 version of your library instead (transpiled from ES6 to ES5.1 via Babel):
然而确保代码在 Node.js 环境中运行正常。尽管 Node 0.x ，4.x ，5.x 用户 可以通过 Babel 将 ES6 翻译成 ES5.1 来导入你的库。

    var MyLibrary = require('my-library/legacy');

In addition to that, it is highly recommended to include yet another version of the library into your NPM package that is using ES2015 modules syntax. [Modules](https://twitter.com/koistya/status/726042867211325440) haven’t landed yet in Node.js and V8 but are widely used in Node.js and frontend communities thanks to module bundlers such as Webpack, Browserify, JSPM and Babel compiler. In order to do so, you need to compile the source code into a distributable format optimized for Node.js 6 but additionally make sure that the import/export statements in the original source code are not transpiled into ES5 module.exports syntax. Let me show you how to do it with Babel and Rollup. The directory structure of your project may look as follows:
除此之外，在此强烈推荐将又一个这个库的版本使用 ES2015 模块语法包括在 NPM 模块中。

    .
    ├── /dist/                  # Temp folder for compiled output
    │   ├── /legacy/            # Legacy bundle(s) for Node 0.x, 4.x
    │   │   ├── /main.js        # ES5.1 bundle for Node 0.x, 4.x
    │   │   └── /package.json   # Legacy NPM module settings
    │   ├── /main.js            # ES6 bundle /w CommonJS for Node v6
    │   ├── /main.mjs           # ES6 bundle /w Modules for cool kids
    │   ├── /main.browser.js    # ES5.1 bundle for browsers
    │   ├── /my-library.js      # UMD bundle for browsers
    │   ├── /my-library.min.js  # UMD bundle, minified and optimized
    │   └── /package.json       # NPM module settings
    ├── /node_modules/          # 3rd-party libraries and utilities
    ├── /src/                   # ES2015+ source code
    │   ├── /main.js            # The main entry point
    │   ├── /sub-module-a.js    # A module referenced in main.js
    │   └── /sub-module-b.js    # A module referenced in main.js
    ├── /test/                  # Unit and end-to-end tests
    ├── /tools/                 # Build automation scripts and utilities
    │   └── /build.js           # Builds the project with Babel/Rollup
    └── package.json            # Project settings

Where you have the “src” folder containing ES2015+ source code of your library, and a “dist” (or “build”) folder, that is created on the fly when you build the project. From that “dist” folder you will publish your NPM library containing CommonJS, ES6 and UMD bundles compiled with Babel and Rollup.

The “package.json” file will contain references to these bundles:

      {  
      "name": "my-library",  
      "version": "1.0.0",  
      "main": "main.js",  
      "jsnext:main": "main.mjs",  
      "browser": "main.browser.js",  
      ...  
    }

“tools/build.js” script is a handy way to configure that compilation step. It may look as follows:

    'use strict';

    const fs = require('fs');
    const del = require('del');
    const rollup = require('rollup');
    const babel = require('rollup-plugin-babel');
    const uglify = require('rollup-plugin-uglify');
    const pkg = require('../package.json');

    const bundles = [
      {
        format: 'cjs', ext: '.js', plugins: [],
        babelPresets: ['stage-1'], babelPlugins: [
          'transform-es2015-destructuring',
          'transform-es2015-function-name',
          'transform-es2015-parameters'
        ]
      },
      {
        format: 'es6', ext: '.mjs', plugins: [],
        babelPresets: ['stage-1'], babelPlugins: [
          'transform-es2015-destructuring',
          'transform-es2015-function-name',
          'transform-es2015-parameters'
        ]
      },
      {
        format: 'cjs', ext: '.browser.js', plugins: [],
        babelPresets: ['es2015-rollup', 'stage-1'], babelPlugins: []
      },
      {
        format: 'umd', ext: '.js', plugins: [],
        babelPresets: ['es2015-rollup', 'stage-1'], babelPlugins: [],
        moduleName: 'my-library'
      },
      {
        format: 'umd', ext: '.min.js', plugins: [uglify()]
        babelPresets: ['es2015-rollup', 'stage-1'], babelPlugins: [],
        moduleName: 'my-library', minify: true
      }
    ];

    let promise = Promise.resolve();

    // Clean up the output directory
    promise = promise.then(() => del(['dist/*']));

    // Compile source code into a distributable format with Babel and Rollup
    for (const config of bundles) {
      promise = promise.then(() => rollup.rollup({
        entry: 'src/main.js',
        external: Object.keys(pkg.dependencies),
        plugins: [
          babel({
            babelrc: false,
            exclude: 'node_modules/**',
            presets: config.babelPresets,
            plugins: config.babelPlugins,
          })
        ].concat(config.plugins),
      }).then(bundle => bundle.write({
        dest: `dist/${config.moduleName || 'main'}${config.ext}`,
        format: config.format,
        sourceMap: !config.minify,
        moduleName: config.moduleName,
      })));
    }

    // Copy package.json and LICENSE.txt
    promise = promise.then(() => {
      delete pkg.private;
      delete pkg.devDependencies;
      delete pkg.scripts;
      delete pkg.eslintConfig;
      delete pkg.babel;
      fs.writeFileSync('dist/package.json', JSON.stringify(pkg, null, '  '), 'utf-8');
      fs.writeFileSync('dist/LICENSE.txt', fs.readFileSync('LICENSE.txt', 'utf-8'), 'utf-8');
    });

    promise.catch(err => console.error(err.stack)); // eslint-disable-line no-console



Now you can build your library by running “node tools/build” (assuming you have Node.js 6 installed on your local machine) and publish it from inside the “dist” folder to NPM registry.

I hope this post will be helpful for developers trying to figure out what’s the best way to publish ES6 on NPM. You can also find a pre-configured NPM library boilerplate here: [https://github.com/kriasoft/babel-starter-kit](https://github.com/kriasoft/babel-starter-kit)

If you think something is missing or inaccurate, please comment below. Happy coding!

