> * 原文地址：[New Node.js 12 features will see it disrupt AI, IoT and more surprising areas](https://tsh.io/blog/new-node-js-features/)
> * 原文作者：[Adam Polak](https://pl.linkedin.com/in/adam-polak-3267a99b)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/.md](https://github.com/xitu/gold-miner/blob/master/TODO1/.md)
> * 译者：
> * 校对者：

# New Node.js 12 features will see it disrupt AI, IoT and more surprising areas

**New Node.js features isn’t the usual selling point of this platform. Node.js is primarily well-known for its [speed and simplicity](https://tsh.io/blog/node-js-tutorial-for-beginners/). This is why so many companies are willing to give it a shot. However, with the release of a new LTS (long-term support) version, Node.js will gain a lot of new features [every Node.js developer](https://tsh.io/services/web-development/node/) can be excited about. Why? That’s because the new Node.js 12 features and the possibilities they create are simply that amazing!**

## Threads are almost stable!

With the last LTS we’ve got access to threads. Of course, it was an experimental feature and required a special flag called **–experimental-worker** for it to work.

With the upcoming LTS (Node 12) it’s still experimental, but won’t require a flag anymore. We are getting closer to a stable version!

## ES modules support

Let’s face it, ES modules are currently the way to go in JavaScript development. We are using it in our frontend apps. We are using it on our desktop or even mobile apps. And yet, in case of Node we were stuck with common.js modules.

Of course, we could use Babel or Typescript, but since Node.js is a backend technology, the only thing we should care about is a Node version installed on the server. We don’t need to care about multiple different browsers and support for them, so what’s the point of installing a tool that was made precisely with that in mind (Babel/Webpack etc.)?

With Node 10, we could finally play a little with ES modules (current LTS has experimental implementation for modules), but it required us to use special file extension **– .mjs** (module javascript).

With Node 12, it’s getting a little bit easier to work with. Much like it is with web apps, we get a special property type called that will define if code should be treated like common.js or es module.

The only thing you need to do to treat all your files as a module is to add the property **type** with the value **module** to your package.json.

```json
{
  "type": "module"
}
```

From now on, if this package.json is the **closest** to our .js file, it will be treated like a module. No more **mjs** (we can still use it if we want to)!

So, what if we wanted to use some common.js code?

As long as the closest package.json does not contain a module type property, it will be treated like common.js code.

What’s more, we are getting new an extension called **cjs** – a common.js file.

Every **mjs** file is treated as a module and every **cjs** as a common.js file.

If you didn’t have a chance to try it out, now is the time!

## JS and private variables

When it comes to JavaScript, we have always struggled to protect some data in our classes/functions from the outside.

JS is famous for its monkey patching, meaning we could always somehow access almost everything.

We tried with closures, symbols and more to simulate private-like variables. Node 12 ships with the new V8 and so we’ve got access to one cool feature – private properties in the class.

I’m sure you all remember the old approach to privates in Node:

```js
class MyClass {
  constructor() {
    this._x = 10
  }
  
  get x() {
    return this._x
  }
}
```

We all know it’s not really a private – we are still able to access it anyway, but most of IDEs treated it like a private field and most of Node devs knew about this convention. Finally, we can all forget about it.

```js
class MyClass {
  #x = 10
  
  get x() {
    return this.#x
  }
}
```

Can you see the difference? Yes, we use **#** character to tell Node that this variable is private and we want it to be accessible only from the inside of this class.

Try to access it directly, you’ll get an error that this variable does not exists.

Sadly some IDE do not recognize them as proper variables yet.

## Flat and flatMap

With Node 12, we’re getting access to new JavaScript features.

First of all, we’re getting access to new array methods – **flat** and **flatMap**. The first one is similar to **Lodash’s** **flattenDepth** method.

If we pass a nested arrays to it, we will get a flatten array as a result.

```js
[10, [20, 30], [40, 50, [60, 70]]].flat() // => [10, 20, 30, 40, 50, [60, 70]]
[10, [20, 30], [40, 50, [60, 70]]].flat(2) // => [10, 20, 30, 40, 50, 60, 70]
```

As you can see, it also has a special parameter – **depth**. By using it, you can decide how many levels down you want to flatten.

The second one – **flatMap** – works just like **map**, followed by **flat** 🙂

## Optional catch binding

Another new feature is **optional catch binding.** Until now we always had to define an error variable for **try** – **catch.**

```js
try {
  someMethod()
} catch(err) {
  // err is required
}
```

With Node 12 we can’t skip the entire catch clause, but we can skip the variable at least.

```js
try {
  someMethod()
} catch {
  // err is optional
}
```

## Object.fromEntries

Another new JavaScript feature is the **Object.fromEntries** method. It’s main usage is to create an object either from **Map** or from a **key/value** array.

```js
Object.fromEntries(new Map([['key', 'value'], ['otherKey', 'otherValue']]));
// { key: 'value', otherKey: 'otherValue' }


Object.fromEntries([['key', 'value'], ['otherKey', 'otherValue']]);
// { key: 'value', otherKey: 'otherValue' }
```

## V8 changes

I did mention that the new Node comes with the V8. This gives us not only access to the private field, but also some performance optimizations.

Awaits should work much faster, as should JS parsing.

Our apps should load quicker and asyncs should be much easier to debug, because we’re finally getting stack traces for them.

What’s more, the heap size is getting changed. Until now, it was either 700MB (for 32bit systems) or 1400MB (for 64bit). With new changes, it’s based on the available memory!

## 12 is coming!

I don’t know about you, but I’m waiting for Node 12. We are still a few months (October 2019 is the planned release date) from an official change to 12 as LTS, but the features we are getting are very promising.

Just a few more months!

## The new Node.js is all about threads!

If there is one thing we can all agree on, it’s that **every programming language has its pros and cons**. Most popular technologies have found their own niche in the world of technology. Node.js is no exception.  
  
We’ve been told for years that [Node.js is good for API gateways](https://tsh.io/blog/serverless-in-node-js-beginners-guide/) and real-time dashboards ([e.g. with websockets](https://tsh.io/blog/php-websocket/)). As a matter of fact, its design itself forced us to depend on the microservice architecture to overcome some of its common obstacles.  
  
At the end of the day, we knew that Node.js was simply not meant for time-consuming, CPU-heavy computation or blocking operations due to its single-threaded design. This is the nature of the event loop itself.  
  
If we block the loop with a complex synchronous operation, it won’t be able to do anything until it’s done. That’s the very reason we use async so heavily or move time-consuming logic to a separate microservice.  
  
This workaround may no longer be necessary thanks to new Node.js features that debuted in its 10 version. **The tool that will make the difference are worker threads**. Finally, Node.js will be able to excel in fields where normally we would use a different language.

A good example could be AI, machine learning or big data processing. Previously, all of those required CPU-heavy computation, which left us no choice, but to build another service or pick a better-suited language. No more.

## Threads!? But how?

This new Node.js feature is still experimental – it’s not meant to be used in a production environment just yet. Still, we are free to play with it. So where do we start?

Starting from Node 12+ we no longer need to use special feature flag **–experimental-worker.** Workers are on by default!

**node index.js**

Now we can take full advantage of the **worker_threads** module. Let’s start with a simple HTTP server with two methods:

* GET /hello (returning JSON object with “Hello World” message),
* GET /compute (loading a big JSON file multiple times using a synchronous method).

```js
const express = require('express');
const fs = require('fs');

const app = express();

app.get('/hello', (req, res) => {
  res.json({
    message: 'Hello world!'
  })
});

app.get('/compute', (req, res) => {
  let json = {};
  for (let i=0;i<100;i++) {
    json = JSON.parse(fs.readFileSync('./big-file.json', 'utf8'));
  }

  json.data.sort((a, b) => a.index - b.index);

  res.json({
    message: 'done'
  })
});

app.listen(3000);
```

The results are easy to predict. When **GET /compute** and **/hello** are called simultaneously, we have to wait for the **compute** path to finish before we can get a response from our **hello** path. The Event loop is blocked until file loading is done.

Let’s fix it with threads!

```js
const express = require('express');
const fs = require('fs');
const { Worker, isMainThread, parentPort, workerData } = require('worker_threads');

if (isMainThread) {
  console.log("Spawn http server");

  const app = express();

  app.get('/hello', (req, res) => {
    res.json({
      message: 'Hello world!'
    })
  });

  app.get('/compute', (req, res) => {

    const worker = new Worker(__filename, {workerData: null});
    worker.on('message', (msg) => {
      res.json({
        message: 'done'
      });
    })
    worker.on('error', console.error);
	  worker.on('exit', (code) => {
		if(code != 0)
          console.error(new Error(`Worker stopped with exit code ${code}`))
    });
  });

  app.listen(3000);
} else {
  let json = {};
  for (let i=0;i<100;i++) {
    json = JSON.parse(fs.readFileSync('./big-file.json', 'utf8'));
  }

  json.data.sort((a, b) => a.index - b.index);

  parentPort.postMessage({});
}
```

As you can see, the syntax is very similar to what we know from Node.js scaling with Cluster. But the interesting part begins here.

Try to call both paths at the same time. Noticed something? Indeed, the event loop is no longer blocked so we can call **/hello** during file loading.

Now, this is something we have all been waiting for! All that’s left is to wait for a stable API.

## Want even more new Node.js features? Here is an N-API for building C/C++ modules!

The raw speed of Node.js is one of the reason we choose this technology. Worker threads are the next step to improve it. But is it really enough?

Node.js is a C-based technology. Naturally, we use JavaScript as a main programming language. But what if we could use C for more complex computation?

Node.js 10 gives us a stable **N-API.** It’s a standardized API for native modules, making it possible to build modules in C/C++ or even Rust. Sounds cool, doesn’t it?

![C++ logo](https://tsh.io/wp-content/uploads/2018/12/c-logo-267x300.png)

Building native Node.js modules in C/C++ has just got way easier

A very simple native module can look like this:

```cpp
#include <napi.h>
#include <math.h>

namespace helloworld {
    Napi::Value Method(const Napi::CallbackInfo& info) {
        Napi::Env env = info.Env();
        return Napi::String::New(env, "hello world");
    }

    Napi::Object Init(Napi::Env env, Napi::Object exports) {
        exports.Set(Napi::String::New(env, "hello"),
                    Napi::Function::New(env, Method));
        return exports;
    }

    NODE_API_MODULE(NODE_GYP_MODULE_NAME, Init)
}
```

If you have a basic knowledge of C++, it’s not too hard to write a custom module. The only thing you need to remember is to convert C++ types to Node.js at the end of your module.

Next thing we need is **binding**:

```gyp
{
    "targets": [
        {
            "target_name": "helloworld",
            "sources": [ "hello-world.cpp"],
            "include_dirs": ["<!@(node -p \"require('node-addon-api').include\")"],
            "dependencies": ["<!(node -p \"require('node-addon-api').gyp\")"],
            "defines": [ 'NAPI_DISABLE_CPP_EXCEPTIONS' ]
        }
    ]
}
```

This simple configuration allows us to build *.cpp files, so we can later use them in Node.js apps.

Before we can make use of it in our JavaScript code, we have to build it and configure our package.json to look for gypfile (binding file).

```json
{
  "name": "n-api-example",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "install": "node-gyp rebuild"
  },
  "gypfile": true,
  "keywords": [],
  "author": "",
  "license": "ISC",
  "dependencies": {
    "node-addon-api": "^1.5.0",
    "node-gyp": "^3.8.0"
  }
}
```

Once the module is good to go, we can use the **node-gyp rebuild** command to build and then require it in our code. Just like any popular module we use!

```js
const addon = require('./build/Release/helloworld.node');

console.log(addon.hello());
```

Together with worker threads, N-API gives us a pretty good set of tools to build high-performance apps. Forget APIs or dashboards – even complex data processing or machine learning systems are far from impossible. Awesome!

**See also: **[Swoole – Is it Node in PHP? ](https://tsh.io/blog/swoole-is-it-node-in-php-or-am-i-wrong/)

## Full support for HTTP/2 in Node.js? Sure, why not!

We’re able to **compute faster**. We’re able to **compute in parallel**. So how about **assets and pages serving**?

For years, we were stuck with the good old **http** module and HTTP/1.1. As more and more assets are being served by our servers, we increasingly struggle with loading times. Every browser has a maximum number of simultaneous persistent connections per server/proxy, especially for HTTP/1.1. With HTTP/2 support, we can finally kiss this problem goodbye.

So where do we start? Do you remember this basic Node.js server example from every tutorial on web ever? Yep, this one:

```js
const http = require('http');

http.createServer(function (req, res) {
  res.write('Hello World!');
  res.end();
}).listen(3000);
```

With Node.js 10, we get a new **http2** module allowing us to use HTTP/2.0! Finally!

```js
const http = require('http2');
const fs = require('fs');

const options = {
  key: fs.readFileSync('example.key'),
  cert: fs.readFileSync('example.crt')
 };

http.createSecureServer(options, function (req, res) {
  res.write('Hello World!');
  res.end();
}).listen(3000);
```

![Http/2 protocol logo](https://tsh.io/wp-content/uploads/2018/12/https2-logo-300x300.png)

Full HTTP/2 support in Node.js 10 is what we have all been waiting for

## With these new features, the future of Node.js is bright

The new Node.js features bring fresh air to our tech ecosystem. They open up completely new possibilities for Node.js. Have you ever imagined that this technology could one day be used for image processing or data science? Neither have I.

This version gives us even more long-awaited features such as support for **es modules** (still experimental, though) or changes to **fs** methods, which finally use promises rather than callbacks.

Want **even more new Node.js features**? Watch [this short video](https://youtu.be/FuWZeUfaI4s).

As you can see from the chart below, the popularity of Node.js seems to have peaked in early 2017, after years and years of growth. It’s not really a sign of slowdown, but rather of  maturation of this technology.

![Popularity of Node.js over time chart, peaked in 2017](https://tsh.io/wp-content/uploads/2018/12/node-popularity-over-the-years-chart-1024x425.png)

However, I can definitely see how all of these new improvements, as well as the growing popularity of Node.js blockchain apps (based on the truffle.js framework), may give Node.js a further boost so that it can blossom again – in new types of projects, roles and circumstances.

The TSH Node.js team is so looking forward to 2020!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
