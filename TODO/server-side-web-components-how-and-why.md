> * 原文链接: [Server-side Web Components: How and Why?](https://scotch.io/tutorials/server-side-web-components-how-and-why)
* 原文作者: [Jordan Last](https://pub.scotch.io/@lastmjs)
* 译文出自: [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者: 
* 校对者:

No, I’m not just talking about server-side rendered web components. I’m talking about web components that you can use to build servers.

As a refresher, web components are a set of [proposed standards](https://github.com/w3c/webcomponents) that offer a way to modularize and package UI and functionality into reusable and declarative components that can be easily shared and composed to create entire applications. Currently their greatest use has been in front-end web development. What about the back-end? It turns out that web components are not only useful for UI, as the [Polymer project](https://elements.polymer-project.org) has shown us, but they are also useful for raw functionality. We'll look at how these can be used, and talk about the key benefits:

*   Declarative
*   Modular
*   Universal
*   Shareable
*   Debuggable
*   Smaller Learning Curve
*   Client-side Structure

## Declarative

First off, you get declarative servers. Here’s a quick sample of an Express.js application, written with [Express Web Components](https://github.com/scramjs/express-web-components):

```
<link rel="import" href="bower_components/polymer/polymer.html">
<link rel="import" href="bower_components/express-web-components/express-app.html">
<link rel="import" href="bower_components/express-web-components/express-middleware.html">
<link rel="import" href="bower_components/express-web-components/express-router.html">

<dom-module id="example-app">
    <template>
        <express-app port="5000">
            <express-middleware method="get" path="/" callback="[[indexHandler]]"></express-middleware>
            <express-middleware callback="[[notFound]]"></express-middleware>
        </express-app>
    </template>

    <script>
        class ExampleAppComponent {
            beforeRegister() {
                this.is = 'example-app';
            }

            ready() {
                this.indexHandler = (req, res) => {
                    res.send('Hello World!');
                };

                this.notFound = (req, res) => {
                    res.status(404);
                    res.send('not found');
                };
            }
        }

        Polymer(ExampleAppComponent);
    </script>
</dom-module>
```

Instead of writing routes purely in JavaScript imperatively, you can write them declaratively in HTML. You can actually build a visual hierarchy of your routes, which is easier to visualize and understand than the equivalent in pure JavaScript. Taking a look at the example above, all endpoints/middleware pertaining to the Express application are nested in an `<express-app>` element, and middleware is hooked up to the app in the order that it is written in the HTML with `<express-middleware>` elements. Routes can be nested easily as well. Every middleware inside of an `<express-router>` is hooked up to that router, and you can even have `<express-route>` elements inside of `<express-router>` elements.

## Modular

We already have modularity with vanilla Express and Node.js, but I feel like modular web components are even easier to reason about. Let’s take a look at a [good example](https://github.com/scramjs/node-api) of modular custom elements with Express Web Components:

```
<!--index.html-->

<!DOCTYPE html>

<html>
    <head>
        <script src="../../node_modules/scram-engine/filesystem-config.js"></script>
        <link rel="import" href="components/app/app.component.html">
    </head>

    <body>
        <na-app></na-app>
    </body>

</html>
```

Everything starts out in the `index.html` file. There is really only one place to go, `<na-app></na-app>`:

```
<!--components/app/app.component.html-->

<link rel="import" href="../../../../bower_components/polymer/polymer.html">
<link rel="import" href="../../../../bower_components/express-web-components/express-app.html">
<link rel="import" href="../../../../bower_components/express-web-components/express-middleware.html">
<link rel="import" href="../api/api.component.html">

<dom-module id="na-app">
    <template>
        <express-app port="[[port]]" callback="[[appListen]]">
            <express-middleware callback="[[morganMW]]"></express-middleware>
            <express-middleware callback="[[bodyParserURLMW]]"></express-middleware>
            <express-middleware callback="[[bodyParserJSONMW]]"></express-middleware>
            <na-api></na-api>
        </express-app>
    </template>

    <script>
        class AppComponent {
            beforeRegister() {
                this.is = 'na-app';
            }

            ready() {
                const bodyParser = require('body-parser');
                const morgan = require('morgan');

                this.morganMW = morgan('dev'); // log requests to the console

                // configure body parser
                this.bodyParserURLMW = bodyParser.urlencoded({ extended: true });
                this.bodyParserJSONMW = bodyParser.json();

                this.port = process.env.PORT || 8080; //set our port

                const mongoose = require('mongoose');
                mongoose.connect('mongodb://@localhost:27017/test'); // connect to our database

                this.appListen = () => {
                    console.log(`Magic happens on port ${this.port}`);
                };
            }
        }

        Polymer(AppComponent);
    </script>
</dom-module>
```

We start up an Express app listening on port `8080` or `process.env.PORT`, and then we declare three middleware, and one custom element. I'm hoping that intuition leads you to believe that those three middleware will be run before anything inside of `<na-api></na-api>`, because that's exactly how it works:

```
<!--components/api/api.component.html-->

<link rel="import" href="../../../../bower_components/polymer/polymer.html">
<link rel="import" href="../../../../bower_components/express-web-components/express-middleware.html">
<link rel="import" href="../../../../bower_components/express-web-components/express-router.html">
<link rel="import" href="../bears/bears.component.html">
<link rel="import" href="../bears-id/bears-id.component.html">

<dom-module id="na-api">
    <template>
        <express-router path="/api">
            <express-middleware callback="[[allMW]]"></express-middleware>
            <express-middleware method="get" path="/" callback="[[indexHandler]]"></express-middleware>
            <na-bears></na-bears>
            <na-bears-id></na-bears-id>
        </express-router>
    </template>

    <script>
        class APIComponent {
            beforeRegister() {
                this.is = 'na-api';
            }

            ready() {
                // middleware to use for all requests with /api prefix
                this.allMW = (req, res, next) => {
                    // do logging
                    console.log('Something is happening.');
                    next();
                };

                // test route to make sure everything is working (accessed at GET http://localhost:8080/api)
                this.indexHandler = (req, res) => {
                    res.json({ message: 'hooray! welcome to our api!' });
                };
            }
        }

        Polymer(APIComponent);
    </script>
</dom-module>
```

Everything inside of `<na-api></na-api>` is wrapped inside of an `<express-router></express-router>`. All middleware in this component are available at `/api`. Let's continue following to `<na-bears></na-bears>` and `<na-bears-id></na-bears-id>`:

```
<!--components/bears/bears.component.html-->

<link rel="import" href="../../../../bower_components/polymer/polymer.html">
<link rel="import" href="../../../../bower_components/express-web-components/express-middleware.html">
<link rel="import" href="../../../../bower_components/express-web-components/express-route.html">

<dom-module id="na-bears">
    <template>
        <express-route path="/bears">
            <express-middleware method="post" callback="[[createHandler]]"></express-middleware>
            <express-middleware method="get" callback="[[getAllHandler]]"></express-middleware>
        </express-route>
    </template>

    <script>
        class BearsComponent {
            beforeRegister() {
                this.is = 'na-bears';
            }

            ready() {
                var Bear = require('./models/bear');

                // create a bear (accessed at POST http://localhost:8080/bears)
                this.createHandler = (req, res) => {
                    var bear = new Bear();      // create a new instance of the Bear model
                    bear.name = req.body.name;  // set the bears name (comes from the request)

                    bear.save(function(err) {
                        if (err)
                            res.send(err);
                        res.json({ message: 'Bear created!' });
                    });
                };

                // get all the bears (accessed at GET http://localhost:8080/api/bears)
                this.getAllHandler = (req, res) => {
                    Bear.find(function(err, bears) {
                        if (err)
                            res.send(err);
                        res.json(bears);
                    });
                };
            }
        }

        Polymer(BearsComponent);
    </script>
</dom-module>
```

```
<!--components/bears-id/bears-id.component.html-->

<link rel="import" href="../../../../bower_components/polymer/polymer.html">
<link rel="import" href="../../../../bower_components/express-web-components/express-middleware.html">
<link rel="import" href="../../../../bower_components/express-web-components/express-route.html">

<dom-module id="na-bears-id">
    <template>
        <express-route path="/bears/:bear_id">
            <express-middleware method="get" callback="[[getHandler]]"></express-middleware>
            <express-middleware method="put" callback="[[updateHandler]]"></express-middleware>
            <express-middleware method="delete" callback="[[deleteHandler]]"></express-middleware>
        </express-route>
    </template>

    <script>
        class BearsIdComponent {
            beforeRegister() {
                this.is = 'na-bears-id';
            }

            ready() {
                var Bear = require('./models/bear');

                // get the bear with that id
                this.getHandler = (req, res) => {
                    console.log(req.params);
                    Bear.findById(req.params.bear_id, function(err, bear) {
                        if (err)
                            res.send(err);
                        res.json(bear);
                    });
                };

                // update the bear with this id
                this.updateHandler = (req, res) => {
                    Bear.findById(req.params.bear_id, function(err, bear) {
                        if (err)
                            res.send(err);
                        bear.name = req.body.name;
                        bear.save(function(err) {
                            if (err)
                                res.send(err);
                            res.json({ message: 'Bear updated!' });
                        });
                    });
                };

                // delete the bear with this id
                this.deleteHandler = (req, res) => {
                    Bear.remove({
                        _id: req.params.bear_id
                    }, function(err, bear) {
                        if (err)
                            res.send(err);
                        res.json({ message: 'Successfully deleted' });
                    });
                };
            }
        }

        Polymer(BearsIdComponent);
    </script>
</dom-module>
```

As you can see, all of the routers are split into their own components, and are easily included into the main app. The `index.html` file is the beginning of an easy-to-follow series of imports that lead you through the flow of routes.

## Universal

One of the reasons I love JavaScript is the possibility of sharing code across client and server. To some extent that is possible today, but there are still client-side libraries that don't work server-side because of missing APIs, and vice-versa from the server to the client. Basically, Node.js and browsers are still different platforms offering different APIs. What if you could combine both? That’s what Electron is for. Electron combines Node.js and the Chromium project into a single runtime, allowing us to use client-side and server-side code together.

> [Scram.js](https://github.com/scramjs/scram-engine) is a small project that helps run Electron in a headless state, making it possible to run your server-side web components just like you would run any other Node.js application.

I already have some basic apps working in a production environment using Dokku. If you’re curious, check out the [Dokku Example](http://scramjs.org).

Now let me explain one of the neatest things that I've seen while developing with server-side web components. I was using [this client-side JavaScript library](https://github.com/adlnet/xAPIWrapper) to make some specific API requests. It became apparent that the library was compromising the credentials to our database by providing them client-side. That wasn't going to work for us. We needed to keep those credentials secure, which meant that we needed to perform the requests server-side. It could have taken a significant amount of effort to rewrite the functionality of the library to work in Node.js, but with Electron and Scram.js, I just popped the library in and was able to use it server-side without modification!

> I just popped the library in and was able to use it server-side without modification!

Also, I had been working on some mobile apps built with JavaScript. We were using [localForage](https://github.com/mozilla/localForage) as our client-side database. The apps were being designed to communicate with each other without any central authority, using a distributed database design. I wanted to be able to use localForage in Node.js so that we could reuse our models and have things work without major modifications. We couldn’t before, but now we can.

> Electron with Scram.js offers access to LocalStorage, Web SQL, and IndexedDB, which makes localForage possible. Simple server-side databases!

I'm not sure how the performance will scale, but at least it’s a possibility.

Also, now you should be able to use components like [iron-ajax](https://elements.polymer-project.org/elements/iron-ajax) and my [redux-store-element](https://github.com/lastmjs/redux-store-element) server-side, just like you would client-side. I’m hoping this will allow reuse of paradigms that work well on the client, and close the gap between the context-shifting that inevitably occurs when going from the client to the server.

## Shareable

This benefit just comes with web components. One of the major hopes of web components is that we will be able to share them easily, use them across browsers, and stop reimplementing the same solutions over and over again, just because frameworks and libraries change. This sharing is possible because web components are based on current or proposed standards that all major browser vendors are working to implement.

> That means web components don’t rely on any one framework or library, but will work universally on the platform of the web.

I'm hoping many people will create server-side web components that package functionality just like front-end components. I’ve started with Express components, but imagine components for Koa, Hapi.js, Socket.io, MongoDB, etc.

## Debuggable

Scram.js has an option `-d` allowing you to open up an Electron window when you are debugging. Now you have all of the Chrome dev tools available to you to help debug your server. Breakpoints, console logging, network info...it’s all there. Server-side debugging in Node.js has always seemed second-class to me. Now it’s built right into the platform:

![](https://cdn.scotch.io/1614/CILiuE9kThuL1iqBuEij_Screenshot%20from%202016-06-07%2013:17:24.png)

## Smaller Learning Curve

Server-side web components could help level the playing field of back-end programming. There are a lot of people, web designers, UX people, and others who might not know "programming" but do understand HTML and CSS. Server-side code as it is today probably seems untouchable to some of them. But if it's written partly in the familiar language of HTML, and especially the semantic language of custom elements, they might be able to work with server-side code more easily. At the least we can lower the learning curve.

## Client-side Structure

The structure of client-side and server-side apps can now mirror each other more closely. Each app can start with an `index.html` file, and then use components from there. This is just one more way to unify things. In the past I’ve found it somewhat difficult to find where things start in server-side apps, but `index.html` seems to have become the standard starting place for front-end apps, so why not for the back-end?

Here's an example of a generic structure for a client-side application built with web components:

```
app/
----components/
--------app/
------------app.component.html
------------app.component.js
--------blog-post/
------------blog-post.component.html
------------blog-post.component.js
----models/
----services/
----index.html
```

Here's an example of a generic structure for a server-side application built with web components:

```
app/
----components/
--------app/
------------app.component.html
------------app.component.js
--------api/
------------api.component.html
------------api.component.js
----models/
----services/
----index.html
```

Both structures potentially work equally well, and now we've reduced the amount of context switching necessary to go from the client to the server and vice-versa.

## Possible Problems

The biggest thing that could bring this crashing down is the performance and stability of Electron in a production server environment. That being said, I don’t foresee performance being much of a problem, because Electron just spins up a renderer process to run the Node.js code, and I assume that process will run Node.js code more or less just like a vanilla Node.js process would. The bigger question is if the Chromium runtime is stable enough to run without stopping for months at a time (memory leaks).

Another possible problem is verbosity. It will take more lines of code to accomplish the same task using server-side web components versus vanilla JavaScript because of all the markup. That being said, my hope is that the cost of verbose code will be made up by that code being easier to understand.

## Benchmarks

For the curious, I’ve done some basic benchmarks to compare the performance of [this basic app](https://github.com/azat-co/rest-api-express) written for and running on vanilla Node.js with Express, versus the same app written with Express Web Components and running on Electron with Scram.js. The graphs below show the results of some simple stress tests on the main route using [this library](https://github.com/doubaokun/node-ab). Here are the parameters of the tests:

*   Run on my local machine
*   100 GET request increase per second
*   Run until 1% of requests return unsuccessfully
*   Run 10 times for the Node.js app and the Electron/Scram.js app
*   Node.js app
    *   Using Node.js v6.0.0
    *   Using Express v4.10.1
*   Electron/Scram.js app
    *   Using Scram.js v0.2.2
        *   Default settings (loading starting html file from local server)
        *   Debug window closed
    *   Using Express v4.10.1
    *   Using electron-prebuilt v1.2.1
*   Run with this library: [https://github.com/doubaokun/node-ab](https://github.com/doubaokun/node-ab)
*   Run with this command: `nab http://localhost:3000 --increase 100 --verbose`

Here are the results (QPS stands for "Queries Per Second"):

![](https://cdn.scotch.io/1614/THvMpsJNTtmW14Mlad0D_electron-and-node.png)

![](https://cdn.scotch.io/1614/qvjN1PkpRi2F1AexzP7Y_electron.png)

![](https://cdn.scotch.io/1614/yVMSAsmTnCaT9HbjOknQ_node.png)

Surprisingly, Electron/Scram.js outperformed Node.js...we should probably take these results with a grain of salt, but I will conclude from these results that using Electron as a server is not drastically worse than using Node.js as a server, at least as far as short spurts of raw request performance are concerned. These results add validity to my statement earlier when I said that "I don’t foresee performance being much of a problem".

## Wrap Up

Web components are awesome. They are bringing a standard declarative component model to the web platform. It’s easy to see the benefits on the client, and there are so many benefits to be gained on the server. The gap between the client and server is narrowing, and I believe that server-side web components are a huge step in the right direction. So, go build something with them!

*   Running Electron on the server: [Scram.js](https://github.com/scramjs/scram-engine)
*   Basic server-side web components: [Express Web Components](https://github.com/scramjs/express-web-components)
*   Live demo: [Dokku Example](http://scramjs.org/)
*   Example 1: [Simple Express API](https://github.com/scramjs/rest-api-express)
*   Example 2: [Modular Express API example](https://github.com/scramjs/node-api)
*   Example 3: [Todo App](https://github.com/scramjs/node-todo)
*   Example 4: [Simple REST SPA](https://github.com/scramjs/node-tutorial-2-restful-app)
*   Example 5: [Basic App for Frontend Devs](https://github.com/scramjs/node-tutorial-for-frontend-devs)

## Credits

Node.js is a trademark of Joyent, Inc. and is used with its permission. We are not endorsed by or affiliated with Joyent.
