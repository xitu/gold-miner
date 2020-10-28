> * 原文地址：[Why Deno is Perfectly Ready To Take Over Node.js Now](https://medium.com/front-end-weekly/why-deno-is-perfectly-ready-to-take-over-node-js-now-3f768efe530c)
> * 原文作者：[Charuka Herath](https://medium.com/@charuka09)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/why-deno-is-perfectly-ready-to-take-over-node-js-now.md](https://github.com/xitu/gold-miner/blob/master/article/2020/why-deno-is-perfectly-ready-to-take-over-node-js-now.md)
> * 译者：
> * 校对者：

# Why Deno is Perfectly Ready To Take Over Node.js Now

![Photo by [Thao Le Hoang](https://unsplash.com/@h4x0r3) on [Unsplash](https://unsplash.com/).](https://cdn-images-1.medium.com/max/2000/0*NGYfX_xdVnytqcM1)

Deno is a brand new way to write server-side JavaScript. It solves many of the same problems as Node.js. It was even created by the same programmer who created Node.js. Much like Node, it uses the v8 JavaScript engine under the hood. However, the rest of the runtime is implemented in Rust and JavaScript. Since it was announced, Deno has managed to achieve quite a bit of popularity. You can see it by checking its GitHub repository.

![Figure 1: [GitHub repository](https://github.com/denoland/deno)](https://cdn-images-1.medium.com/max/2668/1*rqRR-dNjpDO0qcF1pfEB4g.png)

Before digging in, let’s set up our machine with the mighty and secure Deno. For Mac and Linux using the shell, run:

```bash
curl -fsSL https://deno.land/x/install/install.sh | sh
```

For Windows using power shell, run:

```cmd
iwr https://deno.land/x/install/install.ps1 -useb | iex
```

Also, you can install Deno using package managers such as Homebrew (Mac), [Chocolatey](https://chocolatey.org/packages/deno) (Windows), scoop(Windows), and cargo:

```bash
brew install deno

choco install deno

scoop install deno

cargo install deno
```

Our journey into Deno begins in a single TypeScript file. In this file, we have access to all the types in the runtime environment. This means we can write strongly typed code and get documentation directly in the IDE without ever needing to touch a TS config file. The features in the runtime can be accessed from the Deno namespace.

Let’s create a TypeScript file named main.ts in a working directory. Then, console.log the current working directory of the file system:

```js
console.log(Deno.cwd());
```

We can execute our script with the following command:

```bash
deno run main.ts
```

![Figure 2: Getting error without permissions.](https://cdn-images-1.medium.com/max/2000/1*9zL2lRaMgBUsfTVcVXiHdQ.png)

#### 1. Built-In Permissions

The code above throws an error because Deno is secure by default. Deno is way better than Node at handling security. In order to run an application, for example, accessing your file system or the internet requires you to explicitly pass permissions.

If you import a package in Node and that package gets corrupted by someone taking over the package and injecting bad code, it would delete all of the files on your computer. But in Deno, unless you explicitly give your program the ability to delete files from your computer, the package that got corrupted is not going to be able to do anything because it doesn’t have the permission to.

Deno takes a great stance on security by having these permissions built-in. You don’t have to worry about other packages doing things that you don’t want them to do on your computer or a web server.

So, we need to give permission to perform different actions in the runtime. Here, we can use the allow-read flag to allow this operation:

```bash
deno run — allow-read main.ts
```

![Figure 3: Correct output](https://cdn-images-1.medium.com/max/2000/1*WCAXkGkBiadzGR56cdCXkQ.png)

#### 2. Promise-Based

It feels as though Deno’s developers have given much more attention to security. But my favorite aspect is how everything asynchronous is promise-based (farewell, callback).

As you can see, we can make a network request using the fetch API just like we do it in the browser. Because it supports top-level wait, we don’t even need an async function here. Not only that, but we can also start resolving promises without any extra boilerplate code:

```js
const url = Deno.args[0];

const res = await fetch(url);
```

#### 3. Deno Attempts to Make Your Code as browser-compatible as Possible

Deno contains a window object with lifecycle events that developers can listen to. Obviously, this makes the developer’s life easier:

```js
window.onload = e => console.log(‘good bye nodejs’);
```

Oh, wait! I forgot to mention that it can also execute web assembly binaries. According to [its own website](https://webassembly.org/), “WebAssembly (abbreviated **Wasm**) is a binary instruction format for a stack-based virtual machine.”

```js
const wbs = new Uint8Array([61,63,73]);

const wsm = new WebAssembly.Module(wbs);
```

#### 4. Includes a Standard Library With a Bunch of Really Useful Packages

Deno takes it a step further and includes a standard library with a bunch of really useful packages for handling the date, time, colors, and things that aren’t already built into the browser. So, this allows you to take what the browser has and add to it.

The great thing about a standard library is that you can use it across all Deno projects instead of having to rely on importing modules from npm.

**“Good code is short, simple and symmetrical — the challenge is figuring out how to get there.” — Sean Parent**

#### 5. No Massive Node Modules Folder

Instead, we import packages using the modern ES module syntax. Here, remote modules are referenced by their URL. When you run your script for the first time, it will download this code locally and cache it. There’s no package JSON and code can be referenced from any URL. It is very similar to how things work in the browser.

As I mentioned before, there is no Node modules folder. All of that is just handled in the background for you. All of your dependencies are saved in a central location on your computer, so you don’t have to worry about having this massive modules folder or this really unwieldy package.json:

```js
import { Response } from “https://deno.land/std@0.63.0/http/server.ts";

import { Server } from “https://deno.land/std@0.63.0/http/server.ts";
```

![Figure 4: Downloaded dependencies](https://cdn-images-1.medium.com/max/2000/1*27PO58pHOLatMzuHKkSn4A.png)

#### 6. Provides a Set of Standard Modules to Solve Common Use Cases

Also, Deno provides a set of standard modules to solve common use cases. For example, we can import serve from the HTTP module. Then we can use it to create a server that is treated as an async alterable. We can then await every request from the server and respond to it accordingly. That’s an awesome starting point for a server-side JavaScript app.

Figure 5: Simple server

This is just a simple introduction to Deno. If you want to find out more about Deno and its programming practices, visit the [official website](https://deno.land/).

#### Conclusion and Drawbacks

As you can see, Deno has a lot of additional features over NodeJS. However, while it is really cool and has a lot of great features coming up, it is still only in its early stages. It just hit version 1 very recently, which means a lot of the things that Deno is trying to do are still on the way. For example, browser compatibility is still not 100%. They’re still implementing browser APIs and they’re going to be continuing to implement those as time goes on.

Also, I mentioned that you don’t use npm with Deno. That is actually a little bit of a downside right now because JavaScript is based around npm. There are so many npm packages out there. The problem is that not all of these packages are going to be compatible with Deno. Also, it doesn’t have all of the Node-based APIs yet, so you are kind of missing out on a huge portion of what makes Node so popular.

I think it is going to take a while before Deno starts to truly take off.

Thanks for reading! I hope you enjoyed the article.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
