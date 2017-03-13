> * 原文地址：[Where is WebAssembly now and what’s next?](https://hacks.mozilla.org/2017/02/where-is-webassembly-now-and-whats-next/)
* 原文作者：[Lin Clark](http://code-cartoons.com/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Where is WebAssembly now and what’s next? #

*This is the sixth part in a series on WebAssembly and what makes it fast. If you haven’t read the others, we recommend [starting from the beginning](https://hacks.mozilla.org/2017/02/a-cartoon-intro-to-webassembly/).*

On February 28, the four major browsers [announced their consensus](https://lists.w3.org/Archives/Public/public-webassembly/2017Feb/0002.html) that the MVP of WebAssembly is complete. This provides a stable initial version that browsers can start shipping.

![Personified logos of 4 major browsers high-fiving](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/06-01-logo_party01-500x182.png)

This provides a stable core that browsers can ship. This core doesn’t contain all of the features that the community group is planning, but it does provide enough to make WebAssembly fast and usable.

With this, developers can start shipping WebAssembly code. For earlier versions of browsers, developers can send down an asm.js version of the code. Because asm.js is a subset of JavaScript, any JS engine can run it. With Emscripten, you can compile the same app to both WebAssembly and asm.js.

Even in the initial release, WebAssembly will be fast. But it should get even faster in the future, through a combination of fixes and new features.

## Improving WebAssembly performance in browsers ##

Some speed improvements will come as browsers improve WebAssembly support in their engines. The browser vendors are working on these issues independently.

### Faster function calls between JS and WebAssembly ###

Currently, calling a WebAssembly function in JS code is slower than it needs to be. That’s because it has to do something called “trampolining”. The JIT doesn’t know how to deal directly with WebAssembly, so it has to route the WebAssembly to something that does. This is a slow piece of code in the engine itself, which does setup to run the optimized WebAssembly code.

![Person jumping from JS on to a trampoline setup function to get to WebAssembly](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/06-02-trampoline01-500x399.png)

This can be up to 100x slower than it would be if the JIT knew how to handle it directly.

You won’t notice this overhead if you’re passing a single large task off to the WebAssembly module. But if you have lots of back-and-forth between WebAssembly and JS (as you do with smaller tasks), then this overhead is noticeable.

### Faster load time ###

JITs have to manage the tradeoff between faster load times and faster execution times. If you spend more time compiling and optimizing ahead of time, that speeds up execution, but it slows down start up.

There’s a lot of ongoing work to balance up-front compilation (which ensures there is no jank once the code starts running) and the basic fact that most parts of the code won’t be run enough times to make optimization worth it.

Since WebAssembly doesn’t need to speculate what types will be used, the engines don’t have to worry about monitoring the types at runtime. This gives them more options, for example parallelizing compilation work with execution.

Plus, recent additions to the JavaScript API will allow streaming compilation of WebAssembly. This means that the engine can start compiling while bytes are still being downloaded.

In Firefox we’re working on a two-compiler system. One compiler will run ahead of time and do a pretty good job at optimizing the code. While that’s running code, another compiler will do a full optimization in the background. The fully-optimized version of the code will be swapped in when it’s ready.

## Adding post-MVP features to the spec ##

One of the goals of WebAssembly is to specify in small chunks and test along the way, rather than designing everything up front.

This means there are lots of features that are expected, but haven’t been 100% thought-through yet. They will have to go through the specification process, which all of the browser vendors are active in.

These features are called future features. Here are just a few.

### Working directly with the DOM ###

Currently, there’s no way to interact with the DOM. This means you can’t do something like `element.innerHTML` to update a node from WebAssembly.

Instead, you have to go through JS to set the value. This can mean passing a value back to the JavaScript caller. On the other hand, it can mean calling a JavaScript function from within WebAssembly—both JavaScript and WebAssembly functions can be used as imports in a WebAssembly module.

![Person reaching around from WebAssembly through JS to get to the DOM](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/06-03-dom01-500x418.png)

Either way, it is likely that going through JavaScript is slower than direct access would be. Some applications of WebAssembly may be held up until this is resolved.

### Shared memory concurrency ###

One way to speed up code is to make it possible for different parts of the code to run at the same time, in parallel. This can sometimes backfire, though, since the overhead of communication between threads can take up more time than the task would have in the first place.

But if you can share memory between threads, it reduces this overhead. To do this, WebAssembly will use JavaScript’s new SharedArrayBuffer. Once that is in place in the browsers, the working group can start specifying how WebAssembly should work with them.

### SIMD ###

If you read other posts or watch talks about WebAssembly, you may hear about SIMD support. The acronym stands for single instruction, multiple data. It’s another way of running things in parallel.

SIMD makes it possible to take a large data structure, like a vector of different numbers, and apply the same instruction to different parts at the same time. In this way, it can drastically speed up the kinds of complex computations you need for games or VR.

This is not too important for the average web app developer. But it is very important to developers working with multimedia, such as game developers.

### Exception handling ###

Many code bases in languages like C++ use exceptions. However, exceptions aren’t yet specified as part of WebAssembly.

If you are compiling your code with Emscripten, it will emulate exception handling for some compiler optimization levels. This is pretty slow, though, so you may want to use the [DISABLE_EXCEPTION_CATCHING](https://kripken.github.io/emscripten-site/docs/optimizing/Optimizing-Code.html#c-exceptions) flag to turn it off.

Once exceptions are handled natively in WebAssembly, this emulation won’t be necessary.

### Other improvements—making things easier for developers ###

Some future features don’t affect performance, but will make it easier for developers to work with WebAssembly.

- **First-class source-level developer tools** . Currently, debugging WebAssembly in the browser is like debugging raw assembly. Very few developers can mentally map their source code to assembly, though. We’re looking at how we can improve tooling support so that developers can debug their source code.
- **Garbage collection** . If you can define your types ahead of time, you should be able to turn your code into WebAssembly. So code using something like TypeScript should be compilable to WebAssembly. The only hitch currently, though, is that WebAssembly doesn’t know how to interact with existing garbage collectors, like the one built in to the JS engine. The idea of this future feature is to give WebAssembly first-class access to the builtin GC with a set of low-level GC primitive types and operations.
- ES6 **Module integration** . Browsers are currently adding support for loading JavaScript modules using the `script` tag. Once this feature is added, a tag like `<script src=url type="module">` could work even if url points to a WebAssembly module.

## Conclusion ##

WebAssembly is fast today, and with new features and improvements to the implementation in browsers, it should get even faster.
