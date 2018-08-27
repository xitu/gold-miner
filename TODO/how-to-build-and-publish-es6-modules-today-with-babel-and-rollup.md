>* 原文链接 : [How to Build and Publish ES6 Modules Today, with Babel and Rollup](https://medium.com/@tarkus/how-to-build-and-publish-es6-modules-today-with-babel-and-rollup-4426d9c7ca71#.oqt9xunbj)
* 原文作者 : [Konstantin Tarkus](https://medium.com/@tarkus)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [L9m](https://github.com/L9m)
* 校对者: [yangzj1992](https://github.com/yangzj1992), [malcolmyu](https://github.com/malcolmyu)

# 如何用 Babel 和 Rollup 来构建和发布 ES6 模块

ES2015 规范，也称作 ES6，早在2015年六月被 ECMA 国际（ECMA International）批准为正式标准。在2016年四月，Node.js 基金会发布了支持 93% ES6语言特性的 Node.js 框架 v6，这要归功于 V8（引擎）的 v5.0（Node.js）。

很难说用 ES6 及以上的语法和现有语法特性替代第三方库和 polyfills 有明显的好处。比如语法更加简洁，更可读的代码，更少的抽象，更易于代码库的维护和扩展，能让开发你的库更快，在精益创业术语中意味着**市场首入**。

如果你正在开发一个基于 Node.js 平台的全新 JavaScript 库（npm 模块），或许在优化后的 Node.js v6 环境中将它发布在 NPM , 并对还在使用 Node.js v5 和更早版本的开发者选择性地提供回退可能是一个好主意。好让 Node.js 6 的用户能常规地导入你的库：

    const MyLibrary = require('my-library');

确保代码在 Node.js 6 环境中运行正常。 而且 Node 0.x 、4.x 、5.x 的用户也可以导入你的库的 ES5.1 版本来作为替代（通过 Babel 将 ES6 转换成 ES5.1）：

    var MyLibrary = require('my-library/legacy');

除此之外，在此强烈建议将使用 ES2015 模块语法的另一个版本的库包含到你的 NPM 包中。[模块](https://twitter.com/koistya/status/726042867211325440) 还没有落地到 Node.js 和 V8 中，但是由于 WebPack、Browserify、JSPM 和 Babel 编译器，而在 Node.js 和前端社区中被广泛使用。为此，你需要将源码编译成针对 Node.js 6 优化的一种可分发格式（distributable format），另外要确保源码中的 import/export 声明不会被转换成 ES5 模块的 exports 语法。让我们示范一下使用 Rollup 和 Babel 该怎么做。你项目的目录结构可能如下：

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

这里有一个包含你的库的 （使用）ES2015+ 语法源码的 “src” 文件夹，和一个你创建项目生成的 “dist” （或“build”）文件夹。在 “dist” 文件夹中包含你发布 NPM 的 CommonJS、ES6 和 UMD bundles（用 Babel 和 Rollup 编译）。

“package.json” 文件包含这些依赖包的引用：

      {  
      "name": "my-library",  
      "version": "1.0.0",  
      "main": "main.js",  
      "jsnext:main": "main.mjs",  
      "browser": "main.browser.js",  
      ...  
    }

“tools/build.js” 脚本是配置编译步骤的一个简便方法。它看起来如下：

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



现在你可以通过运行 “node tools/build”（假设你本地已经安装 Node.js）在 “dist” 文件夹中构建你的库并进行 NPM 发布。

我希望这篇文章能有助于开发者了解在 NPM 上发布 ES6 （模块） 的最佳方法。你也可以在这里找到一个预配置的 NPM 库样板： [https://github.com/kriasoft/babel-starter-kit](https://github.com/kriasoft/babel-starter-kit)

如果你有什么意见或建议，欢迎在下方留言。Happy Coding!

