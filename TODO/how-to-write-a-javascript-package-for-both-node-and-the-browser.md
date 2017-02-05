> * 原文地址：[How to write a JavaScript package for both Node and the browser](https://nolanlawson.com/2017/01/09/how-to-write-a-javascript-package-for-both-node-and-the-browser/)
* 原文作者：[Nolan Lawson](https://nolanlawson.com/about/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# How to write a JavaScript package for both Node and the browser #

This is an issue that I’ve seen a lot of confusion over, and even seasoned JavaScript developers might have missed some of its subtleties. So I thought it was worth a short tutorial.

Let’s say you have a JavaScript module that you want to publish to npm, available both for Node and for the browser. But there’s a catch! This particular module has a slightly different implementation for the Node version compared to the browser version.

This situation comes up fairly frequently, since there are lots of tiny environment differences between Node and the browser. And it can be tricky to implement correctly, especially if you’re trying to optimize for the smallest possible browser bundle.

### Let’s build a JS package ###

So let’s write a mini JavaScript package, called `base64-encode-string`. All it does is take a string as input, and it outputs the base64-encoded version.

For the browser, this is easy; we can just use the built-in `btoa` function:

```
module.exports = function (string) {
  return btoa(string);
};
```

In Node, though, there is no `btoa` function. So we’ll have to create a `Buffer` instead, and then call [buffer.toString()](https://nodejs.org/api/buffer.html#buffer_buf_tostring_encoding_start_end) on it:

```
module.exports = function (string) {
  return Buffer.from(string, 'binary').toString('base64');
};
```

Both of these should provide the correct base64-encoded version of a string. For instance:


```
var b64encode = require('base64-encode-string');
b64encode('foo');    // Zm9v
b64encode('foobar'); // Zm9vYmFy
```

Now we’ll just need some way to detect whether we’re running in the browser or in Node, so we can be sure to use the right version. Both Browserify and Webpack define a `process.browser` field which returns `true`, whereas in Node it’s falsy. So we can simply do:



```
if (process.browser) {
  module.exports = function (string) {
    return btoa(string);
  };
} else {
  module.exports = function (string) {
    return Buffer.from(string, 'binary').toString('base64');
  };
}
```

Now we just name our file `index.js`, type `npm publish`, and we’re done, right? Well, this works, but unfortunately there’s a big performance problem with this implementation.

Since our `index.js` file contains references to the Node built-in `process` and `Buffer` modules, both Browserify and Webpack will automatically include [the](https://github.com/defunctzombie/node-process)[polyfills](https://github.com/feross/buffer) for those entire modules in the bundle.

From this simple 9-line module, I calculated that Browserify and Webpack will create [a bundle weighing 24.7KB minified](https://gist.github.com/nolanlawson/6891be612c8faca42d2d9492b0d54e24) (7.6KB min+gz). That’s a lot of bytes for something that, in the browser, only needs to be expressed with `btoa`!

### “browser” field, how I love thee ###

If you search through the Browserify or Webpack documentation for tips on how to solve this problem, you may eventually discover [node-browser-resolve](https://github.com/defunctzombie/node-browser-resolve). This is a specification for a `"browser"` field inside of `package.json`, which can be used to define modules that should be swapped out when building for the browser.

Using this technique, we can add the following to our `package.json`:

```
{
  /* ... */
  "browser": {
    "./index.js": "./browser.js"
  }
}
```

And then separate the functions into two different files, `index.js` and `browser.js`:

```
// index.js
module.exports = function (string) {
  return Buffer.from(string, 'binary').toString('base64');
};

// browser.js
module.exports = function (string) {
  return btoa(string);
};
```

After this fix, Browserify and Webpack provide [much more reasonable bundles](https://gist.github.com/nolanlawson/a8945de1dd52fdc9b4772a2056d3c3b7): Browserify’s is 511 bytes minified (315 min+gz), and Webpack’s is 550 bytes minified (297 min+gz).

When we publish our package to npm, anyone running `require('base64-encode-string')` in Node will get the Node version, and anyone doing the same thing with Browserify or Webpack will get the browser version. Success!

For Rollup, it’s a bit more complicated, but not too much extra work. Rollup users will need to use [rollup-plugin-node-resolve](https://github.com/rollup/rollup-plugin-node-resolve) and set `browser` to `true` in the options.

For jspm there is unfortunately [no support for the “browser” field](https://github.com/jspm/jspm-cli/issues/1675), but jspm users can get around it in this case by doing `require('base64-encode-string/browser')` or `jspm install npm:base64-encode-string -o "{main:'browser.js'}"`. Alternatively, the package author can [specify a “jspm” field](https://github.com/jspm/registry/wiki/Configuring-Packages-for-jspm#prefixing-configuration) in their `package.json`.

### Advanced techniques ###

The direct `"browser"` method works well, but for larger projects I find that it introduces an awkward coupling between `package.json` and the codebase. For instance, our `package.json` could quickly end up looking like this:

```
{
  /* ... */
  "browser": {
    "./index.js": "./browser.js",
    "./widget.js": "./widget-browser.js",
    "./doodad.js": "./doodad-browser.js",
    /* etc. */
  }
}
```
So every time you want a browser-specific module, you’d have to create two separate files, and then remember to add an extra line to the `"browser"` field linking them together. And be careful not to misspell anything!

Also, you may find yourself extracting individual bits of code into separate modules, merely because you wanted to avoid an `if (process.browser) {}` check. When these `*-browser.js` files accumulate, they can start to make the codebase a lot harder to navigate.

If this situation gets too unwieldy, there are a few different solutions. My personal favorite is to use Rollup as a build tool, to automatically split a single codebase into separate `index.js` and `browser.js` files. This has the added benefit of de-modularizing the code you ship to consumers, [saving bytes and time](https://nolanwlawson.wordpress.com/2016/08/15/the-cost-of-small-modules/).

To do so, install `rollup` and `rollup-plugin-replace`, then define a `rollup.config.js` file:

```
import replace from 'rollup-plugin-replace';
export default {
  entry: 'src/index.js',
  format: 'cjs',
  plugins: [
    replace({ 'process.browser': !!process.env.BROWSER })
  ]
};
```

(We’ll use that `process.env.BROWSER` as a handy way to switch between browser builds and Node builds.)

Next, we can create a `src/index.js` file with a single function using a normal `process.browser` condition:

```
export default function base64Encode(string) {
  if (process.browser) {
    return btoa(string);
  } else {
    return Buffer.from(string, 'binary').toString('base64');
  }
}
```

Then add a `prepublish` step to `package.json` to generate the files:

```
{
  /* ... */
  "scripts": {
    "prepublish": "rollup -c > index.js && BROWSER=true rollup -c > browser.js"
  }
}
```

The generated files are fairly straightforward and readable:


```
// index.js
'use strict';
 
function base64Encode(string) {
  {
    return Buffer.from(string, 'binary').toString('base64');
  }
}
 
module.exports = base64Encode;

// browser.js
'use strict';
 
function base64Encode(string) {
  {
    return btoa(string);
  }
}
 
module.exports = base64Encode;
```

You’ll notice that Rollup automatically converts `process.browser` to `true` or `false` as necessary, then shakes out the unused code. So no references to `process` or `Buffer` will end up in the browser bundle.

Using this technique, you can have any number of `process.browser` switches in your codebase, but the published result is two small, focused `index.js` and `browser.js` files, with only the Node-related code for Node, and only the browser-related code for the browser.

As an added bonus, you can configure Rollup to also generate ES module builds, IIFE builds, or UMD builds. For an example of a simple library with multiple Rollup build targets, you can check out my project [marky](https://github.com/nolanlawson/marky).

The actual project described in this post (`base64-encode-string`) has also been [published to npm](https://www.npmjs.com/package/base64-encode-string) so that you can inspect it and see how it ticks. The source code is available [on GitHub](https://github.com/nolanlawson/base64-encode-string).
