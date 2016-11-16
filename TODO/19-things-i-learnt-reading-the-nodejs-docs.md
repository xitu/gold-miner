> * 原文地址：[19 things I learnt reading the NodeJS docs](https://hackernoon.com/19-things-i-learnt-reading-the-nodejs-docs-8a2dcc7f307f#.8iaiz8xls)
* 原文作者：[David Gilbertson](https://hackernoon.com/@david.gilbertson)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# 19 things I learnt reading the NodeJS docs


I’d like to think I know Node pretty well. I haven’t written a web site that _doesn’t_ use it for about 3 years now. But I’ve never actually sat down and read the docs.

As long-time readers will know, I am on a journey of writing out every interface, prop, method, function, data type, etc related to web development, so that I can fill in the gaps of what I don’t know. The Node docs were my last stop, having finished HTML, DOM, the Web APIs, CSS, SVG, and EcmaScript.

This held the most unknown gems for me, so I thought I’d share them in this little listicle. I will present them in descending order of appeal. As I do with my outfits when I meet someone new.

### The querystring module as a general purpose parser

Let’s say you’ve got data from some weirdo database that gives you an array of key/value pairs in the form `name:Sophie;shape:fox;condition:new`. Naturally you think this might be nice as a JavaScript object. So you create a blank object, then you create an array by splitting the string on `;`, loop over it, for each item, split it again on `:` and add the first item in that array as a prop of your object setting the second as the value.

Right?

No! You use `querystring`

    const weirdoString = `name:Sophie;shape:fox;condition:new`;
    const result = querystring.parse(weirdoString, `;`, `:`);

    // result:
    // {
    //   name: `Sophie`,
    //   shape: `fox`,
    //   condition: `new`,
    // };

[**Query String | Node.js v7.0.0 Documentation**  
_By default, percent-encoded characters within the query string will be assumed to use UTF-8 encoding. If an alternative…_nodejs.org](https://nodejs.org/api/querystring.html#querystring_querystring_parse_str_sep_eq_options "https://nodejs.org/api/querystring.html#querystring_querystring_parse_str_sep_eq_options")

### V8 Inspector

Run node with `--inspect`, it will tell you a URL. Paste that URL into Chrome. Boom, debugging Node in the Chrome DevTools. Happy days. There’s a [how-to by Paul Irish over here](https://medium.com/@paul_irish/debugging-node-js-nightlies-with-chrome-devtools-7c4a1b95ae27#.evhku718w).

It’s still ‘experimental’, but so is my medication and I’M DOING FINE.

[**Debugger | Node.js v7.0.0 Documentation**  
_Node.js includes a full-featured out-of-process debugging utility accessible via a simple TCP-based protocol and built…_nodejs.org](https://nodejs.org/api/debugger.html#debugger_v8_inspector_integration_for_node_js "https://nodejs.org/api/debugger.html#debugger_v8_inspector_integration_for_node_js")

### The difference between nextTick and setImmediate

As with so many things, remembering the difference between these two is easy if you imagine they had different names.

`process.nextTick()` should be `process.sendThisToTheStartOfTheQueue()`.

`setImmediate()` should be called `sendThisToTheEndOfTheQueue()`.

(Unrelated: I always thought that in React, `props` should be called `stuffThatShouldStayTheSameIfTheUserRefreshes` and `state` should be called `stuffThatShouldBeForgottenIfTheUserRefreshes`. The fact that they’re the same length is just a bonus.)

[**Node.js v7.0.0 Documentation**  
_Stability: 3 — Locked The timer module exposes a global API for scheduling functions to be called at some future period…_nodejs.org](https://nodejs.org/api/timers.html#timers_setimmediate_callback_args "https://nodejs.org/api/timers.html#timers_setimmediate_callback_args")

[**process | Node.js v7.0.0 Documentation**  
_A process warning is similar to an error in that it describes exceptional conditions that are being brought to the user…_nodejs.org](https://nodejs.org/api/process.html#process_process_nexttick_callback_args "https://nodejs.org/api/process.html#process_process_nexttick_callback_args")

[**Node v0.10.0 (Stable)**  
_I am pleased to announce a new stable version of Node. This branch brings significant improvements to many areas, with…_nodejs.org](https://nodejs.org/en/blog/release/v0.10.0/#faster-process-nexttick "https://nodejs.org/en/blog/release/v0.10.0/#faster-process-nexttick")

### Server.listen takes an object

I’m a fan of passing a single ‘options’ parameter rather than five different parameters that are unnamed and must be in a particular order. As it turns out, you can do this when setting up a server to listen for requests.

    require(`http`)
      .createServer()
      .listen({
        port: 8080,
        host: `localhost`,
      })
      .on(`request`, (req, res) => {
        res.end(`Hello World!`);
      });

This is a sneaky one, because it’s not actually listed in the docs for `http.Server`, you will only find it in the `net.Server` documentation (which `http.Server` inherits from).

[**net | Node.js v7.0.0 Documentation**  
_Stops the server from accepting new connections and keeps existing connections. This function is asynchronous, the…_nodejs.org](https://nodejs.org/api/net.html#net_net_createserver_options_connectionlistener "https://nodejs.org/api/net.html#net_net_createserver_options_connectionlistener")

### Relative paths

The path you pass to the `fs` module methods can be relative. It’s relative to `process.cwd()`. This is probably something that most people already knew, but I always thought it had to be a full path.

    const fs = require(`fs`);
    const path = require(`path`);

    // why have I always done this...
    fs.readFile(path.join(__dirname, `myFile.txt`), (err, data) => {
      // do something
    });

    // when I could just do this?
    fs.readFile(`./path/to/myFile.txt`, (err, data) => {
      // do something
    });

[**File System | Node.js v7.0.0 Documentation**  
_birthtime “Birth Time” — Time of file creation. Set once when the file is created. On filesystems where birthtime is…_nodejs.org](https://nodejs.org/api/fs.html#fs_file_system "https://nodejs.org/api/fs.html#fs_file_system")

### Path parsing

One of the many things I’ve unnecessarily fiddled with regexes for is getting filenames and extensions from paths, when all I needed to do was:

    myFilePath = `/someDir/someFile.json`;
    path.parse(myFilePath).base === `someFile.json`; // true
    path.parse(myFilePath).name === `someFile`; // true
    path.parse(myFilePath).ext === `.json`; // true

[**Node.js v7.0.0 Documentation**  
_Stability: 2 — Stable The path module provides utilities for working with file and directory paths. It can be accessed…_nodejs.org](https://nodejs.org/api/path.html#path_path_parse_path "https://nodejs.org/api/path.html#path_path_parse_path")

### Logging with colors

I’m going to pretend I didn’t already know that `console.dir(obj, {colors: true})` will print the object with props/values as different colors, making them much easier to read.

[**Console | Node.js v7.0.0 Documentation**  
_The console functions are usually asynchronous unless the destination is a file. Disks are fast and operating systems…_nodejs.org](https://nodejs.org/api/console.html#console_console_dir_obj_options "https://nodejs.org/api/console.html#console_console_dir_obj_options")

### You can tell setInterval() to sit in the corner

Let’s say you use `setInterval()` to do a database cleanup once a day. By default, Node’s event loop won’t exit while there is a `setInterval()`pending. If you want to let Node sleep (I have no idea what the benefits of this are) you can do this.

    const dailyCleanup = setInterval(() => {
      cleanup();
    }, 1000 * 60 * 60 * 24);

    dailyCleanup.unref();

Careful though, if you have nothing else pending (e.g. no http server listening), Node will exit.

[**Node.js v7.0.0 Documentation**  
_Stability: 3 — Locked The timer module exposes a global API for scheduling functions to be called at some future period…_nodejs.org](https://nodejs.org/api/timers.html#timers_timeout_unref "https://nodejs.org/api/timers.html#timers_timeout_unref")

### Using the signal constants

If you enjoy killing, you may have done this before:

    process.kill(process.pid, `SIGTERM`);

Nothing wrong with that. If no bug involving a typo had ever existed in the history of computer programming. But since that second parameter takes a string _or_ the equivalent int, you can use the more robust:

    process.kill(process.pid, os.constants.signals.SIGTERM);

### IP address validation

There’s a built in IP address validator. I have written out a regex to do exactly this more than once. Stupid David.

`require(`net`).isIP(`10.0.0.1`)` will return `4`.

`require(`net`).isIP(`cats`)` will return `0`.

Because cats aren’t an IP address.

If you haven’t noticed, I’m going through a phase of using only backticks for strings. It’s growing on me but I’m aware it looks odd so I’m mentioning it and quite frankly wondering what the point of mentioning it is and am now concerned with how I’m going to wrap up this sentence, I shou

[**net | Node.js v7.0.0 Documentation**  
_Stops the server from accepting new connections and keeps existing connections. This function is asynchronous, the…_nodejs.org](https://nodejs.org/api/net.html#net_net_isip_input "https://nodejs.org/api/net.html#net_net_isip_input")

### os.EOL

Have you ever hard-coded an end-of-line character?

Egad!

Just for you, there is `os.EOL` (which is `\r\n` on Windows and `\n`elsewhere). [Switching to os.EOL](https://github.com/sasstools/sass-lint/pull/92/files) will ensure your code behaves consistently across operating systems.

    const fs = require(`fs`);

    // bad
    fs.readFile(`./myFile.txt`, `utf8`, (err, data) => {
      data.split(`\r\n`).forEach(line => {
        // do something
      });
    });

    // good
    const os = require(`os`);
    fs.readFile(`./myFile.txt`, `utf8`, (err, data) => {
      data.split(os.EOL).forEach(line => {
        // do something
      });
    });

[**OS | Node.js v7.0.0 Documentation**  
_{ model: ‘Intel(R) Core(TM) i7 CPU 860 @ 2.80GHz’, speed: 2926, times: { user: 252020, nice: 0, sys: 30340, idle…_nodejs.org](https://nodejs.org/api/os.html#os_os_eol "https://nodejs.org/api/os.html#os_os_eol")

### Status code lookup

There is a lookup of common HTTP status codes and their friendly names. `http.STATUS_CODES` is the object of which I speak, where each key is a status code, and the matching value is the human readable description.









![](https://d262ilb51hltx0.cloudfront.net/max/1600/1*68Kp8_XfEM3gUoS__WGx9Q.png)





So you can do this:

    someResponse.code === 301; // true
    require(`http`).STATUS_CODES[someResponse.code] === `Moved Permanently`; // true

[**HTTP | Node.js v7.0.0 Documentation**  
_The HTTP interfaces in Node.js are designed to support many features of the protocol which have been traditionally…_nodejs.org](https://nodejs.org/api/http.html#http_http_status_codes "https://nodejs.org/api/http.html#http_http_status_codes")

### Preventing unnecessary crashes

I always thought it was a bit ridiculous that the below would actually stop a server:

    const jsonData = getDataFromSomeApi(); // But oh no, bad data!
    const data = JSON.parse(jsonData); // Loud crashing noise.

To prevent silly things like this from ruining your day, you can put `process.on(`uncaughtException`, console.error);` right at the top of your Node app.

Of course, I’m a sane person so I use [PM2](http://pm2.keymetrics.io/) and wrap everything in `try...catch` if I’m being paid, but for personal projects…

Warning, this is [not best practice](https://nodejs.org/api/process.html#process_warning_using_uncaughtexception_correctly), and in a large complex app is probably a bad idea. I’ll let you decide if you want to trust some dude’s blog post or the official docs.

[**process | Node.js v7.0.0 Documentation**  
_A process warning is similar to an error in that it describes exceptional conditions that are being brought to the user…_nodejs.org](https://nodejs.org/api/process.html#process_event_uncaughtexception "https://nodejs.org/api/process.html#process_event_uncaughtexception")

### Just this once()

In addition to `on()`, there is a `once()` method for all EventEmitters. I’m quite sure I’m the last person on earth to learn this. So … that’s everyone then.

    server.once(`request`, (req, res) => res.end(`No more from me.`));

[**Events | Node.js v7.0.0 Documentation**  
_Much of the Node.js core API is built around an idiomatic asynchronous event-driven architecture in which certain kinds…_nodejs.org](https://nodejs.org/api/events.html#events_emitter_once_eventname_listener "https://nodejs.org/api/events.html#events_emitter_once_eventname_listener")

### Custom console

You can create your own console with `new console.Console(standardOut, errorOut)` and pass in your own output streams.

Why? I have no idea. Maybe you want to create a console that outputs to a file, or a socket, or a third thing.

[**Console | Node.js v7.0.0 Documentation**  
_The console functions are usually asynchronous unless the destination is a file. Disks are fast and operating systems…_nodejs.org](https://nodejs.org/api/console.html#console_new_console_stdout_stderr "https://nodejs.org/api/console.html#console_new_console_stdout_stderr")

### DNS lookup

A little birdy told me that Node [doesn’t cache DNS lookups](https://github.com/nodejs/node/issues/5893). So if you’re hitting a URL again and again you’re wasting valuable milliseconds. In which case you could get the domain yourself with `dns.lookup()` and cache it. Or [here’s one](https://www.npmjs.com/package/dnscache) someone else created earlier.

    dns.lookup(`www.myApi.com`, 4, (err, address) => {
      cacheThisForLater(address);
    });

[**DNS | Node.js v7.0.0 Documentation**  
_2) Functions that connect to an actual DNS server to perform name resolution, and that always use the network to…_nodejs.org](https://nodejs.org/api/dns.html#dns_dns_lookup_hostname_options_callback "https://nodejs.org/api/dns.html#dns_dns_lookup_hostname_options_callback")

### The `fs` module is a minefield of OS quirks

If, like me, your style of writing code is read-the-absolute-minimum-from-the-docs-then-fiddle-till-it-works, then you’re probably going to run into trouble with the `fs` module. Node does a great job of ironing out the differences between operating systems, but there’s only so much they can do, and a number of OS differences poke through the ocean of code like the jagged protrusions of a reef. A reef that has a minefield in it. You’re a boat.

Unfortunately, these differences aren’t all “Window vs The Others”, so we can’t simply invoke the “pffft, no one uses Windows” defence. (I wrote a whole big rant about the anti-Windows sentiment in web development but deleted it because it got so preachy even I was rolling my eyes at myself.)

Here is a spattering of things from the `fs` module that could bite you in your downstairs area:

*   The `mode` property of the object returned by `fs.stats()` will be different on Windows and other operating systems (on Windows they may not match the file mode constants such as `fs.constants.S_IRWXU`).
*   `fs.lchmod()` is only available on macOS.
*   Calling `fs.symlink()` with the `type` parameter is only supported on Windows.
*   The `recursive` option that can be passed to `fs.watch()` works on macOS and Windows only.
*   The `fs.watch()` callback will only receive a filename on Linux and Windows.
*   Using `fs.open()` on a directory with the flag `a+` will work on FreeBSD and Windows, but fail on macOS and Linux.
*   A `position` parameter passed to `fs.write()` will be ignored on Linux when the file is opened in append mode (the kernel will ignore the position and append to the end of the file).

(I’m so hip I’m already calling it macOS when OS X has only been in the grave for 49 days.)

[**File System | Node.js v7.0.0 Documentation**  
_birthtime “Birth Time” – Time of file creation. Set once when the file is created. On filesystems where birthtime is…_nodejs.org](https://nodejs.org/api/fs.html "https://nodejs.org/api/fs.html")

### The net module is twice as fast as http

Reading the docs, I learnt that the `net` module is a thing. And that it underpins the `http` module. Which got me thinking, if I wanted to do server-to-server communication (as it turns out, I do) should I just be using the `net` module?

Networking folk will find it difficult to believe that I couldn’t intuit the answer, but as a web developer that has fallen ass-first into the server world, I know HTTP and not much else. All this TCP, socket, stream malarkey is a bit like [Japanese rap](https://www.youtube.com/watch?v=FQgH4G3qypI) to me. Which is to say, I don’t really get it, but I’m intrigued.

To play and compare, I set up a couple of servers (I trust you’re listening to Japanese rap right now) and fired some requests at them. End result, `http.Server` handles ~3,400 requests per second, `net.Server` handles ~5,500 requests per second.

It’s simpler too.

This is the code, if you’re interested. If you’re not interested then I’m sorry I’m making you scroll so much.

    // This makes two connections, one to a tcp server, one to an http server (both in server.js)
    // It fires off a bunch of connections and times the response

    // Both send strings.

    const net = require(`net`);
    const http = require(`http`);

    function parseIncomingMessage(res) {
      return new Promise((resolve) => {
        let data = ``;

        res.on(`data`, (chunk) => {
          data += chunk;
        });

        res.on(`end`, () => resolve(data));
      });
    }

    const testLimit = 5000;

    /*  ------------------  */
    /*  --  NET client  --  */
    /*  ------------------  */
    function testNetClient() {
      const netTest = {
        startTime: process.hrtime(),
        responseCount: 0,
        testCount: 0,
        payloadData: {
          type: `millipede`,
          feet: 100,
          test: 0,
        },
      };

      function handleSocketConnect() {
        netTest.payloadData.test++;
        netTest.payloadData.feet++;

        const payload = JSON.stringify(netTest.payloadData);

        this.end(payload, `utf8`);
      }

      function handleSocketData() {
        netTest.responseCount++;

        if (netTest.responseCount === testLimit) {
          const hrDiff = process.hrtime(netTest.startTime);
          const elapsedTime = hrDiff[0] * 1e3 + hrDiff[1] / 1e6;
          const requestsPerSecond = (testLimit / (elapsedTime / 1000)).toLocaleString();

          console.info(`net.Server handled an average of ${requestsPerSecond} requests per second.`);
        }
      }

      while (netTest.testCount  {
          httpTest.responseCount++;

          if (httpTest.responseCount === testLimit) {
            const hrDiff = process.hrtime(httpTest.startTime);
            const elapsedTime = hrDiff[0] * 1e3 + hrDiff[1] / 1e6;
            const requestsPerSecond = (testLimit / (elapsedTime / 1000)).toLocaleString();

            console.info(`http.Server handled an average of ${requestsPerSecond} requests per second.`);
          }
        });
      }

      while (httpTest.testCount  {
      console.info(`Starting testNetClient()`);
      testNetClient();
    }, 50);

    setTimeout(() => {
      console.info(`Starting testHttpClient()`);
      testHttpClient();
    }, 2000);

    // This sets up two servers. A TCP and an HTTP one.
    // For each response, it parses the received string as JSON, converts that object and returns a string
    const net = require(`net`);
    const http = require(`http`);

    function renderAnimalString(jsonString) {
      const data = JSON.parse(jsonString);
      return `${data.test}: your are a ${data.type} and you have ${data.feet} feet.`;
    }

    /*  ------------------  */
    /*  --  NET server  --  */
    /*  ------------------  */

    net
      .createServer((socket) => {
        socket.on(`data`, (jsonString) => {
          socket.end(renderAnimalString(jsonString));
        });
      })
      .listen(8888);

    /*  -------------------  */
    /*  --  HTTP server  --  */
    /*  -------------------  */

    function parseIncomingMessage(res) {
      return new Promise((resolve) => {
        let data = ``;

        res.on(`data`, (chunk) => {
          data += chunk;
        });

        res.on(`end`, () => resolve(data));
      });
    }

    http
      .createServer()
      .listen(8080)
      .on(`request`, (req, res) => {
        parseIncomingMessage(req).then((jsonString) => {
          res.end(renderAnimalString(jsonString));
        });
      });

[**net | Node.js v7.0.0 Documentation**  
_Stops the server from accepting new connections and keeps existing connections. This function is asynchronous, the…_nodejs.org](https://nodejs.org/api/net.html "https://nodejs.org/api/net.html")

### REPL tricks

1.  If you’re in the REPL (that is, you’ve typed `node` and hit enter in your terminal) you can type `.load someFile.js` and it will load that file in (for example you might load a file that sets a bunch of constants).
2.  You can set the environment variable `NODE_REPL_HISTORY=""` to disable writing the repl history to a file. I also learnt (was reminded at least) that the REPL history is written to `~/.node_repl_history`, if you’d like a trip down memory lane.
3.  `_` is a variable that holds the result of the last evaluated expression. Mildly handy!
4.  When the REPL starts, all modules are loaded for you. So, for example, you can just type `os.arch()` so see what your architecture is. You don’t need to do `require(`os`).arch();`. (Edit: OK to be precise, modules are loaded on demand.)

