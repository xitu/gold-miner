> * 原文地址：[14 JavaScript Code Optimization Tips for Front-End Developers](https://blog.bitsrc.io/14-javascript-code-optimization-tips-for-front-end-developers-a44763d3a0da)
> * 原文作者：[Mahdhi Rezvi](https://medium.com/@mahdhirezvi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/14-javascript-code-optimization-tips-for-front-end-developers.md](https://github.com/xitu/gold-miner/blob/master/article/2020/14-javascript-code-optimization-tips-for-front-end-developers.md)
> * 译者：
> * 校对者：

# 14 JavaScript Code Optimization Tips for Front-End Developers

![](https://cdn-images-1.medium.com/max/2560/1*MgoAGKBmwDGomYOe4hspxw.jpeg)

JavaScript has become one of the most popular programming languages of all time. It is used by almost 96% of websites all over the world according to [W3Tech](https://w3techs.com/technologies/details/cp-javascript). One key fact you should know about the web is that you have no control over the hardware specifications of the devices your user would access your website on. The end-user may access your website on a high-end or a low-end device with either great or poor internet connection. This means that you have to make sure your website is optimized as much as possible for you to be able to satisfy the requirements of any user.

Here are a few tips for you to have a better-optimized JavaScript code that would result in greater performance.

As a side-note, make sure to share and reuse your JS components to keep the right balance between high-quality code (that takes time to produce) and reasonable delivery times. You can use popular tools like [**Bit**](https://bit.dev) ([Github](https://github.com/teambit/bit)), to share components (vanilla JS, TS, React, Vue, etc.) from any project to Bit’s [component hub](https://bit.dev), without losing too much time over it.

## 1. Remove Unused Code and Features

The more code your application contains, the more data needs to be transmitted to the client. It would also require more time for the browser to analyze and interpret the code.

Sometimes, you might include features that are not used at all. It is better to keep this extra code only in the development environment, and not to push it for production so that you would not burden the client’s browser with unused code.

**Always ask yourself whether that function, feature, or piece of code is a necessity.**

You can remove unused code manually or by using tools such as [Uglify](https://github.com/mishoo/UglifyJS#compressor-options) or [Google’s Closure Compiler](https://developers.google.com/closure/compiler/docs/api-tutorial3). You can even use a technique called tree shaking which removes unused code from your application. Bundlers such as Webpack provide this technique. You can read more about tree shaking over [here](https://medium.com/@bluepnume/javascript-tree-shaking-like-a-pro-7bf96e139eb7). If you want to remove unused npm packages, you can use the command `npm prune` . More info can be read from [NPM docs.](https://docs.npmjs.com/cli-commands/prune.html)

## 2. Cache Whenever Possible

Caching increases the speed and performance of your website by reducing latency and network traffic and thus lessening the time needed to display a representation of a resource. This can be achieved with the help of the [Cache API](https://developer.mozilla.org/en-US/docs/Web/API/Cache) or [HTTP caching](https://developer.mozilla.org/en-US/docs/Web/HTTP/Caching). You might wonder what happens when your content changes. The above caching mechanisms are capable of handling and regenerating the cache when certain conditions are met such as the publishing of new content.

## 3. Avoid Memory Leaks

Being a high-level language, JS looks after several low-level management such as memory management. Garbage collection is a process common for most programming languages. Garbage Collection in layman terms is simply collecting and freeing back memory of which has been allocated to objects but which is not currently in use in any part of our program. In programming languages like C, the developer has to take care of memory allocation and deallocation using `malloc()` and `dealloc()` functions.

Even though garbage collection is performed automatically in JavaScript, there can be certain instances where it will not be perfect. In JavaScript ES6, Map and Set were introduced with their “weaker” siblings. This “weaker” counterpart known as WeakMap and WeakSet hold “weak” references to objects. They enable unreferenced values to be garbage collected and thereby prevent memory leaks. You can read more about WeakMaps [here](https://blog.bitsrc.io/understanding-weakmaps-in-javascript-6e323d9eec81).

## 4. Try to Break Out of Loops Early

Looping for large cycles can definitely consume a lot of precious time. That is why you should always try to break out of a loop early. You can do this with the help of the `break` keyword and `continue` keyword. It is your responsibility to write the most efficient code.

In the below example, if you did not `break` from the loop, your code will run the loop 1000000000 times which is clearly in an overload.

```js
let arr = new Array(1000000000).fill('----');
arr[970] = 'found';
for (let i = 0; i < arr.length; i++) {
  if (arr[i] === 'found') {
        console.log("Found");
        break;
    }
}
```

In the below example, if you did not `continue` when the loop does not match your condition, you will still be running the function 1000000000 times. We only process the array element if it is in even position. This reduces the loop execution by almost half.

```js
let arr = new Array(1000000000).fill('----');
arr[970] = 'found';
for (let i = 0; i < arr.length; i++) {
  if(i%2!=0){
        continue;
    };
    process(arr[i]);
}
```

You can read more about loops and performance over [here](https://www.oreilly.com/library/view/high-performance-javascript/9781449382308/ch04.html).

## 5. Minimize the Number of Times the Variables Get Computed

To reduce the number of times a variable gets computed, you can use closures. In layman terms, closures in JavaScript gives you access to an outer functions scope from an inner function. The closures are created every time a function is created-**not called**. The inner functions will have access to the variables of the outer scope, even after the outer function has returned.

Let’s see two examples to see this in action. These examples are inspired from Bret’s blog.

```js
function findCustomerCity(name) {
  const texasCustomers = ['John', 'Ludwig', 'Kate']; 
  const californiaCustomers = ['Wade', 'Lucie','Kylie'];
  
  return texasCustomers.includes(name) ? 'Texas' : 
    californiaCustomers.includes(name) ? 'California' : 'Unknown';
};
```

If we call the above functions several times, each time a new object is created. For every call, memory is unnecessarily re-allocated to the variables `texasCustometrs` and `californiaCustomers` .

By using a solution with closures, we can instantiate the variables only once. Let’s look at the below example.

```js
function findCustomerCity() {
  const texasCustomers = ['John', 'Ludwig', 'Kate']; 
  const californiaCustomers = ['Wade', 'Lucie','Kylie'];
  
  return name => texasCustomers.includes(name) ? 'Texas' : 
    californiaCustomers.includes(name) ? 'California' : 'Unknown';
};

let cityOfCustomer = findCustomerCity();

cityOfCustomer('John');//Texas
cityOfCustomer('Wade');//California
cityOfCustomer('Max');//Unknown
```

In the above example, with the help of closures, the inner function which is being returned to the variable `cityOfCustomer` has access to the constants of the outer function `findCustomerCity()` . And whenever the inner function is being called with the name passed as a parameter, it does not need to instantiate the constants again. To learn more about closures, I suggest you go through this [blog post](https://medium.com/@prashantramnyc/javascript-closures-simplified-d0d23fa06ba4) by Prashant.

## 6. Minimize DOM Access

Accessing the DOM is slow, compared to other JavaScript statements. If you make changes to the DOM that would trigger re-painting of the layout, this is where things can get quite slow.

To reduce the number of times you access a DOM element, access it once, and use it as a local variable. When the need is complete, make sure to remove the value of the variable by setting it to `null` . This would prevent memory leakage as it would allow the garbage collection process to take place.

## 7. Compress Your Files

By using compression methods such as Gzip, you can reduce the file size of your JavaScript files. These smaller files would result in an increase in your website performance as the browser would need to download smaller assets.

These compressions can reduce your file size by up to 80%. Read more about compression [here](https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/optimize-encoding-and-transfer#text_compression_with_gzip).

![Photo by [JJ Ying](https://unsplash.com/@jjying?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10944/0*yUVIcTARWrjWiaPw)

## 8. Minify Your Final Code

Some people believe that minification and compression are the same. But on the contrary, they are different. In compression special algorithms are used to change the output size of the file. In minification, the comments and extra spaces in JavaScript files, need to be removed. This process can be done with the help of many tools and packages that can be found online. Minification has become standard practice for page optimization and a major component of front end optimization.

Minification can reduce your file size by up to 60%. You can read more about minification [here](https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/optimize-encoding-and-transfer#minification_preprocessing_context-specific_optimizations).

## 9. Use Throttle and Debounce

By using these two techniques, we can strictly enforce the number of times your event needs to be handled by your code.

Throttling is where you specify a maximum number of times a function can be called overtime. For example, “execute the `onkeyup` event function at most once every 1000 milliseconds”. This would mean that if you type 20 keys per second, the event will be fired only once every second. This would reduce the load on your code.

On the other hand, debouncing is where you specify a minimum duration of time for a function to be run again since the previous execution of the same function. In other words, “execute this function only if 600 milliseconds have passed without it being called”. This would mean that your function would not be called until 600 milliseconds have passed since the last execution of the same function. To know more about throttling and debouncing, here is a [quick read for you](https://css-tricks.com/the-difference-between-throttling-and-debouncing/).

You can either implement your own debounce and throttle functions or you can import them from libraries such as [Lodash](https://lodash.com/) and [Underscore](http://underscorejs.org/).

## 10. Avoid Using the Delete Keyword

The `delete` keyword is used to remove a property from an object. There have been several complaints regarding the performance of this `delete` keyword. You can view them [here](https://github.com/googleapis/google-api-nodejs-client/issues/375) and [here](https://stackoverflow.com/questions/43594092/slow-delete-of-object-properties-in-js-in-v8/44008788). It was expected to be fixed in future updates.

As an alternative, you can simply to set the unwanted property as `undefined`.

```js
const object = {name:"Jane Doe", age:43};
object.age = undefined;
```

You can also use the Map object as it’s `delete` method is known to be faster according to [Bret](https://jsperf.com/delete-vs-map-prototype-delete).

## 11. Use Asynchronous Code to Prevent Thread Blocking

You should know that JavaScript is synchronous by default and **is also single-threaded**. But there can be instances where your code requires a lot of time to compute. Being synchronous in nature would mean that, this piece of code would block other code statements from running until it is done executing. This would reduce your performance overall.

But we can avert this situation by implementing asynchronous code. Asynchronous code was earlier written in the form of callbacks, but a new style of handling asynchronous code was introduced with ES6. This new style was called promises. You can learn more about callbacks and promises in the [official docs of MDN](https://developer.mozilla.org/en-US/docs/Learn/JavaScript/Asynchronous/Introducing).

**But wait…**

> JavaScript is synchronous by default and **is also single-threaded**.

How can you run on a single thread yet still manage to run asynchronous code? This is where a lot of people get confused. This is possible thanks to the JavaScript engine that runs under the browser hood. A JavaScript engine is a computer program or an interpreter which executes JavaScript code. A JavaScript engine can be written in a wide variety of languages. For example, the V8 engine which powers Chrome browsers was written in C++, while the SpiderMonkey engine which powers Firefox browsers was written in C and C++.

These JavaScript engines can handle tasks in the background. According to [Brian](https://dev.to/steelvoltage/if-javascript-is-single-threaded-how-is-it-asynchronous-56gd), the callstack recognizes functions of the Web API and hands them off to be handled by the browser. Once those tasks are finished by the browser, they return and are pushed onto the stack as a callback.

You might sometimes wonder, how does things happen with Node.js as it has no help of the browser to run. In fact, the same V8 engine that powers Chrome also powers Node.js as well. Here is an awesome [blog post](https://medium.com/better-programming/is-node-js-really-single-threaded-7ea59bcc8d64) by Salil that explains this process on the Node ecosystem.

## 12. Use Code Splitting

If you have experience with Google Light House, you would be familiar with a metric called “first contentful paint”. It is one of the six metrics tracked in the Performance section of the Lighthouse report.

First Contentful Paint(FCP)measures how long it takes the browser to render the first piece of DOM content after a user navigates to your page. Images, non-white `\<canvas>` elements and SVGs on your page are considered DOM content; anything inside an iframe **isn't** included.

One of the best ways to achieve a higher FCP score is to use code splitting. Code splitting is a technique where you send only the necessary modules to the user in the beginning. This would greatly impact the FCP score by reducing the size of the payload transmitted initially.

Popular module bundlers such as webpack provide you with code splitting functionality. You can also get the help of native ES modules, to get individual modules loaded. You can read more about native ES modules in detail over [here](https://blog.bitsrc.io/understanding-es-modules-in-javascript-a28fec420f73).

## 13. Use async and defer

In modern websites, scripts are more intensive than HTML, where their size is bigger and they consume more processing time. By default, the browser must wait until the script downloads, execute it, and then it processes the rest of the page.

This can lead to your bulky script blocking the loading of your webpage. In order to escape this, JavaScript provides us with two techniques known as async and defer. You have to simply add these attributes to the `\<script>` tags.

Async is where you tell the browser to load your script without affecting the rendering. In other words, the page doesn’t wait for async scripts, the contents are processed and displayed.

Defer is where you tell the browser to load the script after your rendering is complete. If you specify both, `async` takes precedence on modern browsers, while older browsers that support `defer` but not `async` will fallback to `defer`

These two attributes can greatly help you reduce your page loading time. I highly advise you to read [this blog post](https://flaviocopes.com/javascript-async-defer/) by Flavio.

## 14. Use Web Workers to Run CPU Intensive Tasks in the Background

Web Workers allow you to run scripts in background threads. If you have some highly intensive tasks, you can assign them to web workers which would run them without interfering with the user interface. After creation, the web worker can communicate with the JavaScript code by posting messages to an event handler specified by that code. This can happen vice versa as well.

To know more about web workers, I suggest you go through the [MDN Docs](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Using_web_workers).

---

That’s it for this post. Drop your queries in the comments.

Happy Coding!!

---

**Resources**

- [Blog post by Nodesource](https://nodesource.com/blog/improve-javascript-performance/)
- [Blog post by Bret Cameron](https://medium.com/@bretcameron/13-tips-to-write-faster-better-optimized-javascript-dc1f9ab063d8)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
