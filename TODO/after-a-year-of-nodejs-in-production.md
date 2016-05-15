>* 原文链接 : [AFTER A YEAR OF USING NODEJS IN PRODUCTION](http://geekforbrains.com/post/after-a-year-of-nodejs-in-production)
* 原文作者 : [GEEK FOR BRAINS](http://geekforbrains.com/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


This is a follow-up to my original [“Why I’m switching from Python to Node.js”](http://geekforbrains.com/post/why-im-switching-from-python-to-node-js) post. I wrote it just over a year ago in response to my frustrations with Python and why I was going to try Node instead.

Fast-forward a year of in-house CLI tools, client projects and updates to [our company’s](http://inputlogic.ca) products and this is what I’ve learned. Not only about Node, but Javascript in general as well.

### Easy to learn, impossible to master

Node is so easy to learn. Especially if you already know some Javascript. Google a few beginner tutorials, play with Express and you’re off to the races, right? Then you realize you’ll need to settle on a database. No problem, lets search NPM. Oh, theres a handful of decent SQL packages. Later you realize all the ORM tools suck and a basic driver is your best bet. Now you’re stuck implementing redundant model and validation logic. Shortly after that, you start writing more complex queries and start getting lost in callbacks. Naturually you read about callback hell, chop down your christmas tree and start using one of the many promise libraries. Now you just “Promisify” all the things and grab a beer.

All this to say that it feels like the Node ecosystem is constantly moving. Not in a good way. New tools that “trump” old tools seem to come out daily. Theres always a new shiny thing to replace the other. You’ll be surprised on how easily this happens to you and the community seems to encourage it. You use Grunt!? Everyone uses Gulp!? Wait no, use native NPM scripts!

Packages that consist of trivial code no more than 10 lines of code are downloaded in the thousands every day from NPM. Seriously!? You need a dependancy for array type checking? And these packages are used by some huge tools such as React and Babel.

You’ll never master something that moves at break-neck speed, not to mention the potential of dependancy instability.

### Good luck handling errors

Coming from other languages such as Python, Ruby or PHP you’d expect throwing and catching errors, or even returning an error from a function would be a straightforward way of handling errors. Not so with Node. Instead, you get to pass your errors around in your callbacks (or promises) - thats right, no throwing of exceptions. This works until you’re more than a few callbacks deep and trying to follow a stack trace. Not to mention if you forget to return your callback on an error, it continues to run and triggers another set of errors after you returned the initial one. You’ll need to double your client invoices to makeup for debug time.

Even if you do manage to come up with a solid standard for your own errors, you cant confirm (without reading the source) that the many of the NPM packages you have installed follow the same pattern.

These issues have lead to the use of “catchall” exception handlers that can log an issue and allow your app to gracefully shit its pants. Remember, Node is single threaded. If something locks up the process, everything comes crashing down. But its cool, you’re using Forever, Upstart and Monit right?

### Callbacks, promises or generators!?

To handle callback-hell, error handling and general hard-to-read logic, more and more developers have started using Promises. These are basically a way to write what looks like synchronous code without crazy callback logic. Unfortunately, there isn’t any one “standard” (like everything else in Javascript) for implementing or using Promises.

The most notable library right now is [Bluebird](http://bluebirdjs.com/docs/getting-started.html). Its quite good, fast and does a nice job of making things “just work”. However, I find having to wrap my requirements in `Promise.promisifyAll()` extremely hacky.

For the most part, I ended up using the excellent [async](https://github.com/caolan/async) library to keep my callbacks at bay. This felt more natural.

Nearing the end of my expereince with Node, Generators become more popular. I never really ended up getting too deep into them and thus don’t have much to give feedback on. Would love to hear someones experience with them.

### Bad standards

The last thing that I found frustrating was the lack of standards. Everyone seems to have their own idea of how the above points should be handled. Callbacks? Promises? Error handling? Build scripts? Its endless.

Thats just scratching the surface too. Nobody can seem to agree on how to write standard Javascript either. Just do a quick Google of “Javascript Coding Standards” and you’ll see what I mean.

I realize that many languages don’t have a strict structure, but they DO usually have a standard guideline created by the actual maintainers of the language.

The only one I thought was any good for Javascript is written by [Mozilla](https://developer.mozilla.org/en-US/docs/Mozilla/Developer_guide/Coding_Style).

### Final thoughts on Node

I spent a year trying to make Javascript and more specifically Node work for our team. Unfortunately during that time we spent more hours chasing docs, coming up with standards, arguing about libraries and debugging trivial code more than anything.

Would I recommend it for large-scale products? Absolutely not. Do people do that anyway? Of course they do. I tried to.

I would however recommend Javascript for front-end development such as Angular or React (like you have another choice).

I would also recommend Node for simple back-end servers mainly used for websockets or API relay. This can be done easily with Express and we do exactly that for our [Quoterobot](https://quoterobot.com/) PDF processing server. Its a single file containing 186 lines of code including white space and comments. It does its job damn well too.

### Back to Python

So you might be wondering, what am I doing now? For now, I’m still writing the major parts of our web products and API’s using Python. Mainly in Flask or Django using either Postgres or MongoDb.

Its stood the test of time, has some great standards, libraries, its easy to debug and performs very well. Sure it has its worts. Everything does when you start writing in it. For some reason Node managed to catch my eye and draw me in. I don’t regret trying to embrace it, but I do feel like I wasted more time than I should have.

I hope Javascript and Node improve in the future. I’d be happy to revisit it.

Whats your experience? Have you run into similar issues that I did? Did you end up switching back to a more comfortable language?

