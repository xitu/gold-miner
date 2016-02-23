* 原文链接 : [Debugging Node.js in Chrome DevTools](http://mattdesl.svbtle.com/debugging-nodejs-in-chrome-devtools)
* 原文作者 : [MATT DESLAURIERS](http://mattdesl.svbtle.com/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [认领地址](https://github.com/xitu/gold-miner/issues/128)
* 校对者: 
* 状态 : 认领中


This post introduces a novel approach to developing, debugging, and profiling Node.js applications within Chrome DevTools.

## [ ](http://mattdesl.svbtle.com/debugging-nodejs-in-chrome-devtools#devtool)devtool

Recently I’ve been working on a command-line tool, [devtool](https://github.com/Jam3/devtool), which runs Node.js programs inside Chrome DevTools.

The recording below shows setting breakpoints within an HTTP server.

![movie](/images/loading.png)

This tool builds on [Electron](https://github.com/atom/electron/) to blend Node.js and Chromium features. It aims to provide a simple interface for debugging, profiling, and developing Node.js applications.

You can install it with [npm](http://npmjs.com/):

    npm install -g devtool

## [ ](http://mattdesl.svbtle.com/debugging-nodejs-in-chrome-devtools#repl)REPL

In some ways, we can use it as a replacement to the `node` shell command. For example, we can open a REPL like so:

    devtool

This will launch a new Chrome DevTools instance with Node.js support:

![console](/images/loading.png)

We can require Node modules, local npm modules, and built-ins like `process.cwd()`. We also have access to Chrome DevTools functions like `copy()` and `table()`.

Other examples at a glance:

    # run a Node script
    devtool app.js

    # pipe in content to process.stdin
    devtool < audio.mp3

    # pipe in JavaScript to eval it
    browserify index.js | devtool

## [ ](http://mattdesl.svbtle.com/debugging-nodejs-in-chrome-devtools#development)Development

We can use `devtool` for general purpose module and application development, instead of existing tools like [nodemon](https://www.npmjs.com/package/nodemon).

    devtool app.js --watch

This will launch our `app.js` in a Chrome DevTools console. With `--watch`, saving the file will reload the console.

![console](/images/loading.png)

Clicking on the [`app.js:1`](http://mattdesl.svbtle.com/debugging-nodejs-in-chrome-devtools) link will take us to the relevant line in the `Sources` tab:

![line](/images/loading.png)

While in the `Sources` tab, you can also hit `Cmd/Ctrl + P` to quickly search across required modules. You can even inspect and debug internal modules, such as those of Node.js. You can also use the left-hand panel to browse modules.

![Sources](/images/loading.png)

## [ ](http://mattdesl.svbtle.com/debugging-nodejs-in-chrome-devtools#debugging)Debugging

Since we have access to the `Sources` tab, we can use it for debugging our applications. You can set break points and then reload the debugger (`Cmd/Ctrl + R`), or you can set an initial breakpoint with the `--break` flag.

    devtool app.js --break

![break](/images/loading.png)

Below are a few features that may not be immediately obvious to those learning Chrome DevTools:

*   [Conditional Breakpoints](http://blittle.github.io/chrome-dev-tools/sources/conditional-breakpoints.html)
*   [Pause on Uncaught Exception](http://blittle.github.io/chrome-dev-tools/sources/uncaught-exceptions.html)
*   [Restart Frame](http://blittle.github.io/chrome-dev-tools/sources/restart-frame.html)
*   [Watch Expressions](http://albertlee.azurewebsites.net/using-watch-tools-in-chrome-dev-tools-to-improve-your-debugging/)

> _tip_ – While the debugger is paused, you can hit the `Escape` key to open a console that executes within the current scope. You can change variables and then continue execution.

![Imgur](/images/loading.png)

## [ ](http://mattdesl.svbtle.com/debugging-nodejs-in-chrome-devtools#profiling)Profiling

Another use for `devtool` is profiling applications like [browserify](https://github.com/substack/node-browserify), [gulp](https://github.com/gulpjs/gulp), and [babel](https://github.com/babel/babel).

Here we use [`console.profile()`](https://developer.chrome.com/devtools/docs/console-api), a feature of Chrome, to profile CPU usage of a browser bundler.

    var browserify = require('browserify');

    // Start DevTools profiling...
    console.profile('build');

    // Bundle some browser application
    browserify('client.js').bundle(function (err, src) {
      if (err) throw err;

      // Finish DevTools profiling...
      console.profileEnd('build');
    });

Now we can run `devtool` on our file:

    devtool app.js

After execution, we can see the results in the `Profiles` tab.

![profile](/images/loading.png)

We can use the links on the right side to view and debug the hot code paths:

![debug](/images/loading.png)

## [ ](http://mattdesl.svbtle.com/debugging-nodejs-in-chrome-devtools#advanced-options)Advanced Options

#### [ ](http://mattdesl.svbtle.com/debugging-nodejs-in-chrome-devtools#experiments)Experiments

Chrome is constantly pushing new features and experiments into their DevTools, like the **Promise Inspector**. You can enable it by clicking the three dots in the top right corner, and selecting `Settings -> Experiments`.

![experiments](/images/loading.png)

Once enabled, hit the `Escape` key to bring up a panel with the _Promises_ inspector.

![](/images/loading.png)

> _tip_ – In the _Experiments_ page, if you hit `Shift` 6 times, you will be exposed to some even more experimental (and unstable) features.

#### [ ](http://mattdesl.svbtle.com/debugging-nodejs-in-chrome-devtools#codeconsolecode)`--console`

You can redirect console output back to terminal (`process.stdout` and `process.stderr`), which allows you to pipe it into other processes such as TAP prettifiers.

    devtool test.js --console | tap-spec

#### [ ](http://mattdesl.svbtle.com/debugging-nodejs-in-chrome-devtools#codecode-and-codeprocessargvcode)`--` and `process.argv`

Your scripts can parse `process.argv` like in a regular Node.js application. If you pass a full stop (`--`) to the `devtool` command, anything after it will be used as the new `process.argv`. For example:

    devtool script.js --console -- input.txt

Now, your script can look like this:

    var file = process.argv[2];
    console.log('File: %s', file);

Output:

    File: input.txt

#### [ ](http://mattdesl.svbtle.com/debugging-nodejs-in-chrome-devtools#codequitcode-and-codeheadlesscode)`--quit` and `--headless`

With `--quit`, the process will quit with exit code `1` when it reaches an error (such as a syntax error or uncaught exception).

With `--headless`, the DevTools will not be opened.

This can be used for command-line scripts:

    devtool render.js --quit --headless > result.png

#### [ ](http://mattdesl.svbtle.com/debugging-nodejs-in-chrome-devtools#codebrowserfieldcode)`--browser-field`

Some modules may provide an entry point that is better to run in a browser. You can use `--browser-field` to support the [package.json flag](https://github.com/defunctzombie/package-browser-field-spec) when requiring modules.

For example, we can use [xhr-request](https://github.com/Jam3/xhr-request) which will use XHR when required with the `"browser"` field.

    const request = require('xhr-request');

    request('https://api.github.com/users/mattdesl/repos', {
      json: true
    }, (err, data) => {
      if (err) throw err;
      console.log(data);
    });

And in shell:

    npm install xhr-request --save
    devtool app.js --browser-field

Now, we can inspect requests `Network` tab:

![requests](/images/loading.png)

#### [ ](http://mattdesl.svbtle.com/debugging-nodejs-in-chrome-devtools#codenonodetimerscode)`--no-node-timers`

By default, we shim the global `setTimeout` and `setInterval` so they behave like Node.js (returning an object with `unref()` and `ref()` functions).

However, you can disable this to improve support for Async stack traces.

    devtool app.js --no-node-timers

![async](/images/loading.png)

#### [ ](http://mattdesl.svbtle.com/debugging-nodejs-in-chrome-devtools#v8-flags)V8 Flags

In your current directory, you can add a `.devtoolrc` file that includes advanced settings, such as V8 flags.

    {
      "v8": {
        "flags": [
          "--harmony-destructuring"
        ]
      }
    }

See [here](https://github.com/Jam3/devtool/blob/master/docs/rc-config.md) for more details.

## [ ](http://mattdesl.svbtle.com/debugging-nodejs-in-chrome-devtools#gotchas)Gotchas

Since this is running in a Browser/Electron environment, and not a true Node.js environment, there are [some gotchas](https://github.com/Jam3/devtool#gotchas) to be aware of.

## [ ](http://mattdesl.svbtle.com/debugging-nodejs-in-chrome-devtools#comparisons)Comparisons

There are already some existing debuggers for Node.js, so you may be wondering where the differences lie.

### [ ](http://mattdesl.svbtle.com/debugging-nodejs-in-chrome-devtools#webstorm-debugger)WebStorm Debugger

The [WebStorm](https://www.jetbrains.com/webstorm/) editor includes a very powerful Node.js debugger. This is great if you are already using WebStorm as your code editor.

> ![](/images/loading.png)

However, it lacks some features and polish of Chrome DevTools, such as:

*   A rich and interactive console
*   Pause on Exception
*   Async Stack Traces
*   Promise Inspection
*   Profiles

But since it integrates with your WebStorm workspace, you can make modifications and edit your files while debugging. It also runs in a true Node/V8 environment, unlike `devtool`, so it is more robust for a wide range of Node.js applications.

### [ ](http://mattdesl.svbtle.com/debugging-nodejs-in-chrome-devtools#ironnode)iron-node

![](/images/loading.png)

A similar Electron-based debugger is [iron-node](https://github.com/s-a/iron-node). `iron-node` includes a built-in command to recompile native addons and a complex graphical interface that shows your `package.json` and `README.md`.

Whereas `devtool` is more focused on the command-line, Unix-style piping/redirection, and Electron/Browser APIs for interesting use-cases.

`devtool` shims various features to behave more like Node.js (like `require.main`, `setTimeout` and `process.exit`) and overrides the internal `require` mechanism for source maps, improved error handling, breakpoint injection, and `"browser"` field resolution.

### [ ](http://mattdesl.svbtle.com/debugging-nodejs-in-chrome-devtools#nodeinspector)node-inspector

![](/images/loading.png)

You may also like [node-inspector](https://github.com/node-inspector/node-inspector), which uses remote debugging instead of building on top of Electron.

This means your code will run in a true Node environment, without any `window` or other Browser/Electron APIs that may pollute scope and cause problems with certain modules. It has stronger support for large Node.js applications (i.e. native addons) and more control over the DevTools instance (i.e. can inject breakpoints and support Network requests).

However, since it re-implements much of the debugging experience, it may feel slow, clunky and fragile compared to developing inside the latest Chrome DevTools. It has a tendency to crash often and often leads to frustration among Node.js developers.

Whereas `devtool` aims to make the experience feel more familiar to those coming from Chrome DevTools, and also promotes other features like Browser/Electron APIs.
