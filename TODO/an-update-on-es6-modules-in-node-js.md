> * 原文地址：[An Update on ES6 Modules in Node.js ](https://medium.com/@jasnell/an-update-on-es6-modules-in-node-js-42c958b890c#.o3doprfmu)
* 原文作者：[James M Snell](https://medium.com/@jasnell?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# An Update on ES6 Modules in Node.js #

A few months ago I wrote an [article](https://hackernoon.com/node-js-tc-39-and-modules-a1118aecf95e) describing the various differences that exist between Node.js CommonJS modules and the new ES6 Module system; and described a number of challenges inherent with implementing the new model in Node.js core. Here, I want to provide an update on how things are progressing.

### Knowing when you know what you need to know ###

If you haven’t done so already, before progressing to far here, take a moment to read through my first [post](https://hackernoon.com/node-js-tc-39-and-modules-a1118aecf95e)  as it describes many of the fundamental differences that exist between the two module architectures. Boiling it down to the most simplistic terms: the key difference between CommonJS and ES6 modules comes down to when the shape of the module is known and can be used by code.

For instance, suppose I have the following simple CommonJS module (let’s call the module `'foobar'`) :

```
function foo() {
  return 'bar';
}
function bar() {
  return 'foo';
}
module.exports.foo = foo;
module.exports.bar = bar;
```

Now let’s make use of the module in a *.js file named `app.js` :

```
const {foo, bar} = require('foobar');
console.log(foo(), bar());
```

When I run `$node app.js` , the Node.js binary loads the `app.js` file, parses it, and begins evaluating the code. While evaluating, the `require()` function is called, which *synchronously* loads the contents of `foobar.js` in memory, *synchronously* parses and compiles the JavaScript code, and *synchronously* evaluates the code, returning the value of `module.exports` as the return value of `require('foobar')` in `app.js` . As soon as the `require()` function returns in `app.js` , the shape of the `foobar` module is known and can be used. All of this happens within the course of the same Node.js event loop tick.

Critical to understanding the difference between CommonJS and ES6 modules is the fact that the shape (the API) of a CommonJS module cannot be determined until after the code is evaluated — and even after evaluation, the shape can be mutated by other code at any time.

Here is the “equivalent” module written using ES6 syntax:

```
export function foo() {
  return 'bar';
}

export function bar() {
  return 'foo';
}
```

And the code using it:

```
import {foo, bar} from 'foobar';
console.log(foo());
console.log(bar());
```

What happens with the ES6 module, according to the ECMAScript standard, is a very different set of steps than what is implemented in the CommonJS case. The first step, loading the contents of the file disk is largely the same but may happen *asynchronously*. When the contents of the file are available, they are parsed. While parsing, the shape of the module as defined by the export statements is determined *prior* to evaluating the code. Once the shape is determined, the code is then evaluated. It’s important to keep in mind that all import and export statements are resolved to their targets before any code is actually evaluated. It is also important to note that the ES6 specification allows this resolution step to occur *asynchronously*. In Node.js terms, this means loading the contents of the script, resolution of the module imports and exports, and evaluation of the module code would occur over multiple turns of the event loop.

### Timing is Everything ###

One of the key goals we first set out when evaluating the feasibility of implementing ES6 Modules is providing as seamless an implementation as possible. We hoped, for instance, that it would be possible to implement support for both models in way that would make it largely transparent to the user (e.g. `require('es6-module')` and `import from 'commonjs-module'` would Just Work.

Unfortunately, it’s just not going to be that easy.

Specifically, because ES6 modules are loaded, resolved and evaluated asynchronously, it will not be possible to `require()` an ES6 module. The reason is because `require()` is a fully synchronous function. It would be far too disruptive a change to the ecosystem for us to modify the semantics of `require()` to allow it to do asynchronous loading. We are therefore considering the possibility of implementing a `require.import()` function that is modeled after the proposed ES6 `import()`function (see [here](https://github.com/tc39/proposal-dynamic-import) ). This function would return a `Promise` that completes when the ES6 module is loaded. This is not optimal, but it would allow ES6 modules to be used from within existing CommonJS style Node.js code.

One bit of good news, however, is that it should be easily possible to use CommonJS modules from inside an ES6 module using the `import` statement. This is because asynchronous loading is not always required. There are a number of modifications to the ECMAScript language specification that will better support this, but when all is said and done it should just work.

There is one significant caveat tho…

### Alas, the poor Named Import ###

Named imports are a fundamental feature of ES6 Modules. For instance, in the example:

```
import {foo, bar} from 'foobar';
```

The variables `foo` and `bar` are imported from `foobar` during the resolution phase — *before* any of the code is actually evaluated. The is possible in the ES6 Module world because the shape of the module is known in advance.

With CommonJS, on the other hand, the shape of a module is not known until after the code is evaluated. What this means is, without making significant changes to the ECMAScript language spec, it will not be possible to use Named Imports from a CommonJS module. Instead, developers will be required to use what ES6 Modules call the “default” export. For example, using the CommonJS module example at the opening of this post, the import using it would be:

```
import foobar from 'foobar';
console.log(foobar.foo(), foobar.bar());
```

The difference here is subtle but important. When using the `import` statement to import from a CommonJS module, it will simply not be possible to use the syntax:

```
import {foo, bar} from 'foobar';
```

And have`foo` and `bar` resolve to the `foo()` and `bar()` functions exported by the CommonJS module.

### But it works in Babel! ###

Anyone currently using a transpiler like Babel to work with ES6 module syntax is likely familiar with using Named Imports. The way Babel works, that ES6 syntax is converted under the covers to CommonJS style code that can work within Node.js. While the syntax is conformant to ES6, the *implementation is not*. This is critically important to understand. ES6 Named Imports in Babel are fundamentally not the same thing as ES6 Named Imports using a fully spec-compliant implementation.

### Michael Jackson Script ###

Another key difference between CommonJS and ES6 Modules lies in the fact that the ECMAScript code compiler must know in advance whether it is loading CommonJS or ES6 module code. The reason for this goes back to how ES6 modules must have `import` and `export` statements resolved before evaluating the code.

What this means practically is that Node.js will need to have some kind of mechanism for identifying in advance what kind of file is being loaded. While many options have been explored, the solution that we keep coming back to as being the least bad is introducing a new `*.mjs` file extension to explicitly identity JavaScript files to be handled as ES6 Modules. (We have affectionately called these “Michael Jackson Script” files in the past).

In other words, given two files `foo.js` and `bar.mjs` , using `import * from 'foo'` will treat `foo.js` as CommonJS while `import * from 'bar'` will treat `bar.mjs` as an ES6 Module.

### Timeline ###

At the current point in time, there are still a number of specification and implementation issues that need to happen on the ES6 and Virtual Machine side of things before Node.js can even begin working up a supportable implementation of ES6 modules. Work is in progress but it is going to take some time — We’re currently looking at around a year *at least*.
