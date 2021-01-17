> * 原文地址：[A Deep Dive Into JavaScript Modules](https://blog.bitsrc.io/a-deep-dive-into-javascript-modules-550ad88d8839)
> * 原文作者：[Fernando Doglio](https://medium.com/@deleteman123)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/a-deep-dive-into-javascript-modules.md](https://github.com/xitu/gold-miner/blob/master/article/2021/a-deep-dive-into-javascript-modules.md)
> * 译者：
> * 校对者：

# A Deep Dive Into JavaScript Modules

![Image by [HeungSoon](https://pixabay.com/users/heungsoon-4523762/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=3887440) from [Pixabay](https://pixabay.com/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=3887440)](https://cdn-images-1.medium.com/max/3840/1*Dya93Aqh8dXO4ngaaxHsug.jpeg)

All JavaScript developers know how to import a module, if you haven’t done it before, then you’ve not gone past the basic “hello world” example. Modules are the cornerstone of the JavaScript ecosystem.

But did you know there are different module systems in JavaScript though? If you’ve only been working with Node.js for example, you’re probably familiar with using `require` and if you’ve been dealing with React, maybe you’re more of an `import` developer. Truth is, they all get the job done, however, not all of them do it in the same way.

The best way to review the various differences between the JS module types is to start from a commonplace, in our case, that would be ES6, the new standard for the language. And because not all runtimes are still fully compatible with it, I’ll be using Babel to transpile the code into its different flavors, whenever required.

The code we’ll be using as a basis is:

```TypeScript
import _ from 'lodash'

export const dummyFunction = () => {
  return _.camelCase('dummy');
}
```

As you can see, the code is not complex, we’re not doing much, we’re just importing the `lodash` library and exporting a function from our own module.

And to compile it with Babel, I’ll use the following configuration:

```
{
    "presets": [
      ["@babel/preset-env", {
          "modules": "<my module system>"
      }]
    ]
 }
```

## CommonJS

If you’re a Node.js developer, you’ve probably used this one before. This is the standard adopted by Node and thus, the one that makes use of the `require` function.

The output for our example, is the following:

```JavaScript
"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.dummyFunction = void 0;

var _lodash = require("lodash");

var dummyFunction = function dummyFunction() {
  return (0, _lodash.camelCase)('dummy');
};

exports.dummyFunction = dummyFunction;
```

The first thing we see, is that it adds two properties to the `exports` object. This object is the one that will contain the “public” code. In other words, anything that’s not part of this object will not be accessible from outside. One more way of thinking about this object is as the return value from the `require` function. If you add properties to it, you can then access them directly when you require the module:

```js
//yourmodule.js
exports.prop1 = 42
exports.myFn = () => console.log(42)

//... client code
const {prop1, myFn} = require("./yourmodule.js")
```

The second highlight from the above code sample, is that we’re adding the `__esModule` property (with a value of `true`). This property can be used by a helper function on the importing side, to determine how to access the needed method when dealing with default exports.

You see, CommonJS has no concept of “default” export. Everything you add to the `exports` object will be exported and if you `require` it like this:

```js
const myModule = require('yourmdoule.js')
```

You’ll get, as a result, an object with a list of properties and methods (i.e everything that was exported). However, ES6 defined a way to differentiate what you export by default and what you export individually. So you can do something like this:

```JavaScript
//mymodule.js

import { camelCase } from 'lodash';

export const dummyFunction = () => {
  return camelCase('dummy');
};

export const dummyConst = 42;

export default {
  mainMethod: function() {
    //your logic here...
  }
}
```

That code is telling you that you’re exporting 3 things:

* By default you’re exporting an object that contains a method (called `mainMethod`)
* But you’re also exporting a `dummyFunction` and a `dummyConst` value.

On the importing side, you can do:

```JavaScript
import myModule, {dummyFunction} from 'mymodule.js'

myModule.mainMethod()
dummyFunction()
```

That’s the main difference between the default export provided by ES6 and CommonJS. The above code can’t be directly transpiled to CommonJS, because it doesn’t have the concept of default export. However, tools such as Babel take care of that by adding this “interop” code (like the `__esModule` property).

Thus, when transpiled a code like the last snippet, you get the following:

```JavaScript
"use strict";

var _sample = _interopRequireWildcard(require("./sample1"));

function _getRequireWildcardCache() {
    if (typeof WeakMap !== "function") return null;
    var cache = new WeakMap();
    _getRequireWildcardCache = function () {
        return cache;
    };
    return cache;
}

function _interopRequireWildcard(obj) {
    if (obj && obj.__esModule) {
        return obj;
    }
    if (obj === null || typeof obj !== "object" && typeof obj !== "function") {
        return {
            default: obj
        };
    }
    var cache = _getRequireWildcardCache();
    if (cache && cache.has(obj)) {
        return cache.get(obj);
    }
    var newObj = {};
    var hasPropertyDescriptor = Object.defineProperty && Object.getOwnPropertyDescriptor;
    for (var key in obj) {
        if (Object.prototype.hasOwnProperty.call(obj, key)) {
            var desc = hasPropertyDescriptor ? Object.getOwnPropertyDescriptor(obj, key) : null;
            if (desc && (desc.get || desc.set)) {
                Object.defineProperty(newObj, key, desc);
            } else {
                newObj[key] = obj[key];
            }
        }
    }
    newObj.default = obj;
    if (cache) {
        cache.set(obj, newObj);
    }
    return newObj;
}

_sample.default.mainMethod();

console.log((0, _sample.dummyFunction)());
```

I know that looks like a lot of code, but just focus on the last two lines for now. Notice how our `mainMethod`, which was the default export, is inside a new property called `default`. We didn’t declare it, but Babel added it to add compatibility with CommonJS. Also notice how the `dummyFunction` method is not inside the `default` property, since it was exported as a separate entity and was in fact, imported separately as well.

The `_interopRequiredWilcard` helper function just takes care of returning the object we’re going to be using with the proper shape (in other words, it adds the `default` property if it doesn’t already have it).

#### What else is different between CommonJS and ES6?

As you saw, ES6 defines an `export default` sentence that makes no sense in the CommonJS world. But what else is different?

The other major difference, is that while they might seem identical, `require` and `import` don’t work the same way.

One major difference, is that while `require` works dynamically from anywhere in your code, `import` doesn’t. The `require` statement can be considered a function call, and as such, it needs to run to be executed. However, `import` statements are static and are executed during parsing of the file. This is a major performance improvement over how `require` works.

However, there is one downside: because `require` works during runtime, you can have dynamically defined importing routes, such as:

```js
const myMod = require('./src/' + pathToFile);
```

Assuming of course that `pathToFile` is a string, this will work without a problem. But `import` will not allow for that since there is no runtime execution when they’re parsed.

## AMD

Stands for [Asynchronous Module Definition](https://en.wikipedia.org/wiki/Asynchronous_module_definition) and it’s mean to be a pattern of loading modules for front-end projects. Back in the day, the only way you had to define a list of dependencies for your code in browser-land, was to add a bunch of `script` tags and make sure they were correctly ordered. Once the document and all its resources were fully loaded, your code could run.

It worked, it also required a bit of boilerplate code to make it work. Thus AMD was born.

It simplified the task of declaring the specific dependencies for your modules and making sure they would all be loaded before your code would be executed.

It also added a major improvement: instead of having to include all your app’s dependencies and having them loaded before a single line of code could be executed, this approach made it so you could specify exactly which dependencies to load for each section of your code. This in turn provided a major performance boost for big applications with many external dependencies.

Back to our example, if we wanted to add the same simple ES6 module but using AMD, we would do something like this:

```JavaScript
define(['lodash'], function(_lodash) {

  const dummyFunction = () => {
    return _lodash.camelCase('dummy');
  }
  
  return {
    dummyFunction
  }
})
```

The framework using AMD will provide a `define` function that takes a first parameter which is a list of dependencies. Once the dependencies are loaded, our function will be executed. Also notice how we did away with the `export` statement, since anything that is returned by our function will be exported.

This ensures two major issues in front-end world:

1. That all dependencies have been correctly loaded before we need them.
2. That our code is running inside a safe scope. By having our module being written inside a function, we avoid naming conflicts, specially between our dependencies.

Remember, AMD is nothing but a standard, so you’ll need a framework around it that will provide you with the API and [RequireJS](https://requirejs.org/) is one of those frameworks.

## UMD

Just like AMD tries to define a better module loading pattern, [UMD](https://github.com/umdjs/umd) defines a Universal Module Definition. In other words, it tries to provide a way of writing your modules in a format that can later be loaded by multiple loaders. Hence, the universal part.

A UMD declaration is composed of two major parts:

1. An IIFE that receives two parameters: the `root` which is a reference to the global scope, and a `factory` function, which is the code of our module.
2. Our factory function. It receives the dependencies and can be executed, just like with the AMD pattern, in a separate scope.

Inside the initial IIFE, we’ll add some boilerplate logic that will decide which module loader to use, based on our needs.

Look at the output from Babel once we transpile our original code to UMD:

```JavaScript
(function (global, factory) {
  if (typeof define === "function" && define.amd) {
    define(["exports", "lodash"], factory);
  } else if (typeof exports !== "undefined") {
    factory(exports, require("lodash"));
  } else {
    var mod = {
      exports: {}
    };
    factory(mod.exports, global.lodash);
    global.sample1 = mod.exports;
  }
})(typeof globalThis !== "undefined" ? globalThis : typeof self !== "undefined" ? self : this, function (_exports, _lodash) {
  "use strict";

  Object.defineProperty(_exports, "__esModule", {
    value: true
  });
  _exports.dummyFunction = void 0;

  const dummyFunction = () => {
    return (0, _lodash.camelCase)('dummy');
  };

  _exports.dummyFunction = dummyFunction;
 
});
```

The body of the IIFE is first checking if AMD is defined (it’s looking for the `define` function), then if it isn’t, it’s looking for the `exports` keyword to be available. It would imply we’re dealing with a CommonJS loader.

Finally if none of them are defined, then it’ll proceed to create a common object that will later be assigned to the global scope. Here the global scope is referenced by the `global` variable (the first parameter received).

The second function, which as you can see, contains our example module, remains almost untouched. The only difference is that it now receives two arguments, an `_exports` one, which is where we’ll add whatever we’re exporting, and `_lodash` containing the dependency we declared (lodash).

This pattern might require adding a bit more code to wrap your modules, but it’ll make sure it works with multiple systems. It’s definitely an interesting option if you’re distributing a library to be used by many users. If on the other hand, you’re just creating a module for your own system, the extra work and lines of code, might not be worth it.

## SystemJS

The last module loader I’ll cover here is [SystemJS](https://github.com/systemjs/systemjs) which provides yet another way of loading ES6 compatible code into non-compatible runtimes. In other words, by using a custom `import` function, you can load your ES6 code directly without translating it into anything.

You can write the following code:

```JavaScript
var SystemJS = require('systemjs');

SystemJS.config({
    map: {
        'traceur': 'node_modules/traceur/bin/traceur.js',
    }
});

SystemJS.import('./mymodule.js')
    .then(function(main) {
        var t = main.dummyFunction();
        console.log(t);
    })
    .catch(function(e) {
        console.error(e)
    });
```

The `traceur` dependency is required by SystemJS, so we need it, but the rest of the code is loading and using the module we declared at the start of this article (which only uses ES6-type exports and imports).

This is definitely a good alternative if we’re hoping to re-use all of our ES6 compatible code inside a runtime that’s not yet compatible with it.

---

There are many options when it comes to writing and using JavaScript modules, depending on your needs and your preferences, but truth be told, all runtimes should be migrating to be ES6-compatible in the near future, since that is the path the language is taking. This in turn, means that unless you’re writing code for outdated systems, your best bet is to go for the natively supported format.

**Now, let me ask you: which one is your favorite module loader?**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
