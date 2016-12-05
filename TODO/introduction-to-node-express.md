> * 原文地址：[Introduction to Node & Express](https://medium.com/javascript-scene/introduction-to-node-express-90c431f9e6fd#.xffyxajza)
* 原文作者：[Eric Elliott](https://medium.com/@_ericelliott)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Introduction to Node & Express








> This post series has companion videos and exercises for members of [“Learn JavaScript with Eric Elliott”](https://ericelliottjs.com/product/lifetime-access-pass/). For members, the video lessons are here: [“Introduction to Node and Express” video course](https://ericelliottjs.com/premium-content/introduction-to-node-express/). Not a member yet? [Sign up now](https://ericelliottjs.com/product/lifetime-access-pass/).











* * *







Node is a JavaScript environment built on the same JavaScript engine used in Google’s Chrome web browser. It has some great features that make it an attractive choice for building server-side application middle tiers, including web servers and web services for platform APIs.

The non-blocking event driven I/O model gives it very attractive performance, easily beating threaded server environments like PHP and Ruby on Rails, which block on I/O and handle multiple simultaneous users by spinning up separate threads for each.

I’ve ported production apps with tens of millions of users from both PHP and Ruby on Rails to Node, leading to 2x — 10x improvements of both response handling time and the number of simultaneous users handled by a single server.

**Node Features:**

*   Fast! (Non-blocking I/O by default).
*   Event driven.
*   First class networking.
*   First class streaming API.
*   Great standard libraries for interfacing with the OS, filesystem, etc…
*   Support for compiled binary modules when you need to extend Node’s capabilities with a lower-level language like C++.
*   Trusted and backed by large enterprises running mission-critical apps. (Adobe, Google, Microsoft, Netflix, PayPal, Uber, Walmart, etc…).
*   Easy to get started.

### Installing Node

Before we jump in, let’s make sure you’ve got Node installed. There are always two supported versions of Node, the Long Term Support version (stable), and the current release. For production projects, try the LTS version. If you want to play with cutting edge features from the future, pick the current version.

#### Windows

Hit the [Node website](https://nodejs.org/en/) and click one of the big green install buttons.

#### Mac or Linux

If you’re on a Mac or Linux system, my favorite way to install Node is with nvm.

To install or update nvm, you can use the [install script](https://github.com/creationix/nvm/blob/v0.32.1/install.sh) using cURL:

curl -o- [https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh](https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh) | bash

or Wget:

wget -qO- [https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh](https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh) | bash

Once nvm is installed, you can use it to install any version of Node.

### Hello, World!

Node & Express are easy enough that you get a basic web server to serve “Hello, world!” in about 12 lines of code:

    const express = require('express');

    const app = express();
    const port = process.env.PORT || 3000;

    app.get('/', (req, res) => {
      res.send('\n\nHello, world!\n\n');
    });

    app.listen(port, () => {
      console.log(`listening on port ${ port }`);
    });

Before this code will run, you’ll need to set up your app a little. Start by creating a new git repo:

    mkdir my-node-app && cd my-node-app
    git init

You need a `package.json` file to store your apps configuration. To create one, use `npm`, which comes installed with Node:

    npm init

Answer a few questions (app name, git repo, etc…) and you’ll be ready to roll. Then you’ll need to install Express:

    npm install --save express

With the dependencies installed, you can run your app by typing:

    node index.js

Test it with `curl`:

curl localhost:3000

Or visit `localhost:3000` in your browser.

That’s it! You’ve just built your first Node app.

### Environment Variables

You can use environment variables to configure your Node application. That makes it easy to use different configurations in different environments, such as the developer’s local machine, a testing server, a staging server, and production servers.

You should also use environment variables to inject app secrets, such as API keys into the app, without checking them into source control. Some deployment environments let you use `.env` files that contain the configuration settings for your app, but then you’re left with the question, “how do I load the `.env` settings into environment variables that the app can use?”

For that, try [dotenv](https://github.com/motdotla/dotenv) for Node:

    npm install --save dotenv

Then add one line to the top of your entry file:

    require('dotenv').config();

Now you can load the `port` setting from a `.env` file. Create a new file called `.env` in your project root with the following:

    PORT=5150

Save it, and relaunch the app, and you should see:

    listening on port 5150

You don’t want to check your `.env` file into Git, so add it to your `.gitignore` file. In fact, while we’re at it, let’s add some other stuff, too:

    node_modules
    build
    npm-debug.log
    .env
    .DS_Store

You still want to document the settings that are required for your app, so I like to check in a copy of the `.env` file with app secrets redacted. New users of the app can copy the file, name it `.env`, customize the settings, and be off and running. I name the checked-in copy `.env.example` and include instructions for developers in the project’s `README.md` file.

PORT=5150
AWS_KEY=

Note that you should be careful that all the app secrets are all redacted in your `.env.example` file, as demonstrated.

> Don’t check your app secrets into the Git repository.

### Testing Node Apps

I like to test Node apps with [Supertest](https://github.com/visionmedia/supertest), which abstracts away http connection issues and provides a simple, Fluent API. For http endpoints, I use [functional tests](https://www.sitepoint.com/javascript-testing-unit-functional-integration/), which means that I don’t worry about mocking databases and so on. I just hit the API with some values and expect a specific response back.

Here’s a simple example with Supertest and [Tape](https://medium.com/javascript-scene/why-i-use-tape-instead-of-mocha-so-should-you-6aa105d8eaf4):

    const test = require('tape');
    const request = require('supertest');

    const app = require('app');

    test('get /', assert => {
      request(app)
        .get('/')
        .expect(200)
        .end((err, res) => {
          const msg = 'should return 200 OK';
          if (err) return assert.fail(msg);

I also write [unit tests](https://medium.com/javascript-scene/what-every-unit-test-needs-f6cd34d9836d) for any smaller, reusable modules I use to build the API.

Note that instead of dealing with the network, we’re directly importing the express app. Supertest doesn’t need to read your app config to know what port to connect to. It handles all those details under the covers, but for this to work, you’ll want to export your app… in your app file:

    module.exports = app;

For this and other reasons, I split my app into a couple different pieces, `app.js` where I build and configure the app itself, and `server.js`, where I import the app, handle the networking details, and call `app.listen()`.

#### Setting the Node Path

When you start splitting your app into modules, you may get sick of relative path requires like this:

const app = require('../../app');

Luckily, you don’t need to use them. Put your app files in a directory named `source` or `src` and then set the `NODE_PATH` environment variable. You can use `cross-env` to set environment variables so they’ll work cross-platform (read, run your app on Windows):

    npm install --save cross-env

Then in your `package.json` scripts, you can safely set your environment variables:

     "scripts": {
        "start": "cross-env NODE_PATH=source node source/server.js",
        "debug": "cross-env NODE_PATH=source node --debug-brk --inspect source/server.js",
        "test": "cross-env NODE_PATH=source node source/test/index.js"
      }

With `NODE_PATH` set, you can require modules like this:

const app = require('app');

Much better!

### Middleware

[Express](http://expressjs.com/) is the most popular framework for Node apps, and it features middleware using continuation passing. When you want to run the same code for potentially many different routes, the right place for that code is probably middleware.

Middleware is a function that gets passed the request and response objects, along with a continuation function to call, called `next()`. Imagine you want to add a `requestId` to each request/response pair so that you can easily trace them back to the individual request when you’re debugging or searching your logs for something.

You can write some middleware like this:

    require('dotenv').config();
    const express = require('express');
    const cuid = require('cuid');

    const app = express();

    // request id middleware
    const requestId = (req, res, next) => {
      const requestId = cuid();
      req.id = requestId;
      res.id = requestId;

      // pass continuation to next middleware

### Memory Management

Since Node is single-threaded, that means that all your users are going to be sharing the same memory space. In other words, unlike in the browser, you have to be careful not to store user-specific data in closures where other connections can get at it. For this reason, I like to use `res.locals` to store temporary user data that’s only available during that user’s request/response cycle:

This is also a better way to store the `requestId` mentioned above.

### Debugging Node Apps

Node v6.4.x+ ships with an integrated Chrome debugger, so you can hook up Node to use the same tools you use to debug your JS apps in the browser.

To use it, simply add debugger statements anywhere you want to set a breakpoint, then run:

node --debug-brk --inspect source/app.js

Open the provided URL in the browser, and you’ll get an interactive debugging environment.

I use `--debug-brk` by default to tell it to break at the beginning, but you can leave it out. Remember, you’ll probably need to hit your route in a browser or from curl to trigger the route handlers and hit your breakpoints.

As you probably already know, Chrome’s dev tools are packed with valuable debugging insights. You can profile, inspect the memory management and watch for memory leaks, step through the code a line at a time, hover over variables to see values, etc…

### Let it Crash

Processes crash. Like all things, your server’s runtime will probably encounter an error it can’t handle at some point. Don’t sweat it. Log the error, shut down the server, and launch a new instance.

What you absolutely must not do is this:

    process.on('uncaughtException', (err) => {
      console.log('Oops!');
    });

You must shut down the process when there is an uncaught exception, because by definition, if you don’t know what went wrong with the app, your app is in an unknown, undefined state, and just about anything could be going wrong.

You could be leaking resources. Your users may not be seeing the correct data. You could have all kinds of crazy, undefined behaviors. When there is an exception you haven’t specifically planned for, log the error, clean up whatever resources you can, and shut down the process.

I wrote a module to make graceful error handling easy with Node. Check out [express-error-handler](https://github.com/ericelliott/express-error-handler).

#### Crash Recovery

There are a wide range of server monitor utilities to detect crashes and repair the service in order to keep things running smoothly, even in the face of unexpected exceptions.

I highly recommend [PM2](http://pm2.keymetrics.io/) for this. I use it, and it’s trusted by companies like Microsoft, IBM, and PayPal.

To install, run `npm install -g pm2`. Install locally using `npm install --save-dev pm2`. Then you can launch the app using `pm2 start source/app.js`.

You can manage running app instances with `pm2 list` and stop instances with `pm2 stop`. See the [quick start](http://pm2.keymetrics.io/docs/usage/quick-start/) for details.

Bonus: PM2 can be configured to integrate with [Keymetrics](https://keymetrics.io/), which can provide great insights into your production app instances with a friendly web interface.

### Conclusion

We’ve only just scratched the surface of Node. There’s a lot more to learn about, including session management, token authentication, API design, etc… I’ve covered some of those topics in much more depth in [“Programming JavaScript Applications”](http://pjabook.com/) (free online).











* * *







Want to learn a lot more about Node? We’re launching a new Node video series for members of EricElliottJS.com. If you’re not a member, you’re missing out.











* * *







**_Eric Elliott_** _is the author of_ [_“Programming JavaScript Applications”_](http://pjabook.com/) _(O’Reilly), and_ [_“Learn JavaScript with Eric Elliott”_](http://ericelliottjs.com/product/lifetime-access-pass/)_. He has contributed to software experiences for_ **_Adobe Systems_**_,_ **_Zumba Fitness_**_,_ **_The Wall Street Journal_**_,_**_ESPN_**_,_ **_BBC_**_, and top recording artists including_ **_Usher_**_,_ **_Frank Ocean_**_,_**_Metallica_**_, and many more._

_He spends most of his time in the San Francisco Bay Area with the most beautiful woman in the world._







