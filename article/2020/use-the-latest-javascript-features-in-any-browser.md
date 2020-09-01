> * 原文地址：[How to use the latest JavaScript features in any browser](https://medium.com/javascript-in-plain-english/use-the-latest-javascript-features-in-any-browser-f047f5c426a8)
> * 原文作者：[Kesk -*-](https://medium.com/@kesk)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/use-the-latest-javascript-features-in-any-browser.md](https://github.com/xitu/gold-miner/blob/master/article/2020/use-the-latest-javascript-features-in-any-browser.md)
> * 译者：
> * 校对者：

# How to use the latest JavaScript features in any browser - from Polyfilling to Transpiling

![Photo of Lukas in Pexels showing a keyboard and two closed fists](https://cdn-images-1.medium.com/max/9856/1*gTFV4inx3uD5192A9EiGwA.jpeg)

JavaScript is a language that progresses very fast, and sometimes we want to use its latest functions but, if our browser or environment does not allow it directly, we will have to transpile it so that it can do it.

Transpiling is to take the source code written in one language and transforming it into another language with a comparable level of abstraction. Therefore, in JavaScript case, a transpiler takes the syntax that older browsers don’t understand and turns them into syntax that they understand.

#### Polyfilling vs. Transpiling

Both methods work for the same purpose: We can write code that uses new features that are not implemented in our target environment, and then apply one of the above procedures.

A polyfill is a portion of code or workaround where modern features are coded to run on older versions of the browser.

Transpiling is a combination of two words: transforming and compiling. Sometimes, the newer syntax cannot be replicated using polyfills, and here is where we use a transpiler.

Let’s imagine that we are using an old browser that not support the Number.isNaN feature introduced in ES6 specification. To use this feature, we need to create a polyfill for the method, but we will only want to build it if it is not already available on the browser.

To achieve this, we are going to create a function that simulates the isNaN feature behavior and adds it to the Number prototype property.

```js
//Simulates the isNaN feature
if (!Number.isNan) {//not already available.
    Number.prototype.isNaN = function isNaN(n) {
        return n !== n;
    };
}

let myNumber = 100;
console.log(myNumber.isNaN(100));
```

Now, we are going to transpile the code for a newly invented feature in which we are going to imagine that most browsers cannot execute it, and in this case, we can’t create a polyfill to emulate the behavior. We want to run the following code on internet explorer 11, so we are going to transform it with a transpiler:

```js
class mySuperClass {
  constructor(name) {
    this.name = name;
  }

hello() {
    return "Hello:" +this.name;
  }
}

const mySuperClassInstance = new mySuperClass("Rick");
console.log(mySuperClassInstance.hello()); 
//Hello Rick
```

The resulting code has been transpiled with **[Babel online transpiler](https://babeljs.io/en/repl),** and now, ****we can execute it on internet explorer 11:

```js
"use strict";

function _instanceof(left, right) { if (right != null && typeof Symbol !== "undefined" && right[Symbol.hasInstance]) { return !!right[Symbol.hasInstance](left); } else { return left instanceof right; } }

function _classCallCheck(instance, Constructor) { if (!_instanceof(instance, Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

var mySuperClass = /*#__PURE__*/function () {
  function mySuperClass(name) {
    _classCallCheck(this, mySuperClass);

this.name = name;
  }

_createClass(mySuperClass, [{
    key: "hello",
    value: function hello() {
      return "Hello:" + this.name;
    }
  }]);

return mySuperClass;
}();

var mySuperClassInstance = new mySuperClass("Rick");
console.log(mySuperClassInstance.hello()); //Hello Rick
```

One of the most common transpilers for JavaScript is Babel. Babel is a tool that was created to help in the transpilation between different versions of JavaScript and can be installed through the Node package manager (npm).

Babel has become a standard for compiling ECMAScript applications into a version of ECMAScript that run in browsers that do not support such applications. Babel can compile other versions of ECMAScript like React JSX.

In the next steps where are going to see how to use Babel to transpile and execute the previous “mySuperMethod” class in a Linux machine with an old Nodejs installed. In other operating systems like Windows 10 or macOS, In the next steps where are going to see how to use Babel to transpile and execute the previous “mySuperMethod” class in a Linux machine with an old Nodejs installed. In other operating systems like Windows 10 or macOS, the steps to follow are similar.

> Note: You need to have [Node.js](https://nodejs.org/en/) installed in your machine. Npm is added as a feature in Node.js installer.

1. Open a command line, and create a directory called babelExample:

```bash
/mkdir babelExample
/cd babelExample
```

2. Create an [npm](https://www.npmjs.com/) project and leave the default values. The following command will create a file called package.json:

```bash
npm init
```

![package.json file image after executing the npm init command](https://cdn-images-1.medium.com/max/2000/1*9Vr8T71sWnkXpMEeFeuwSw.png)

Here “index.js” (can be another) is the entry point to our application. Here we are going to put our javascript code, therefore create an index.js file a put the following code:

```js
class mySuperClass {
  constructor(name) {
    this.name = name;
  }

hello() {
    return "Hello:" +this.name;
  }
}

const mySuperClassInstance = new mySuperClass("Rick");
console.log(mySuperClassInstance.hello()); 
//Hello Rick
```

3. While we can install Babel CLI globally, it’s better to do it locally project by project. The next command will add the node_modules directory and modify the package.json file to add Babel’s dependencies:

```bash
npm install -save-dev @babel/core @babel/cli
```

![package.json image with babel dependencies](https://cdn-images-1.medium.com/max/2000/1*dp_jnVa5YeBAPp1MDg-zWQ.png)

4. Add a .babelrc config file into your project root folder and enable the plugins for ES2015+transforms.

> Note: In Babel, each transformer is a plugin that we can install individually. Each preset is a collection of related plugins. Using a **preset**, we don’t have to install and update dozens of plugins independently.**

Install the preset for all ES6 features(contains a group of plugins):

```bash
npm install @babel/preset-env --save-dev
```

![package.json image with babel preset-env dependency](https://cdn-images-1.medium.com/max/2000/1*pWq8uX0turri10aG-TXaIw.png)

Edit your .babelrc file and add the following configuration, which enables transforms for ES6.

.babelrc file:

```json
{
  "presets": ["@babel/preset-env"]
}
```

5. Usage

> Note: If you are using Windows 10 PowerShell, be careful about encoding your files because you may get parsing errors when running Babel. It is advisable that the encoding of the files is UTF-8.

* in: index.js
* out: the out folder (Here Babel will leave the transpiled files)

Directly, executing the next command in your console:

```bash
./node_modules/.bin/babel index.js -d out
```

With an npm script adding the following line to your package.json file:

```bash
"build": "babel index.js -d out"
```

![Image of package.json after adding the build script](https://cdn-images-1.medium.com/max/2000/1*IAlvZL-QsbkAhrB2ayu9LA.png)

Execute the following command:

```bash
npm run build
```

In both cases, you obtain in the /out folder the file(or files) transpiled ready to work in browsers that not support the ES6 Class syntax:

```js
"use strict";

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

var mySuperClass = /*#__PURE__*/function () {
  function mySuperClass(name) {
    _classCallCheck(this, mySuperClass);

this.name = name;
  }

_createClass(mySuperClass, [{
    key: "hello",
    value: function hello() {
      return "Hello:" + this.name;
    }
  }]);

return mySuperClass;
}();

var mySuperClassInstance = new mySuperClass("Rick");

console.log(mySuperClassInstance.hello());
```

#### Conclusion

JavaScript language is changing continuously, and thanks to these tools, we can write code with new syntax and new features not yet implemented by all browser versions.

I hope you enjoyed this article. Thanks for reading me.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
