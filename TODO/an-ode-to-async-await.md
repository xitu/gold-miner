> * 原文地址：[An Ode to Async-Await](https://hackernoon.com/an-ode-to-async-await-7da2dd3c2056#.pdydhv9a0)
* 原文作者：[Tal Kol](https://hackernoon.com/@talkol)
* 译文出自：[]()
* 译者：[]()
* 校对者：[]()

# An Ode to Async-Await

![](https://cdn-images-1.medium.com/max/2000/1*xB_H7hyiX3-K7wbf4hH9Yw.jpeg)

*With the *[*news*](https://blog.risingstack.com/async-await-node-js-7-nightly/)* of async-await coming natively to Node 7 (no transpilation needed), I’ve decided to dedicate a post to celebrate this wonderful language construct. In recent years async-await has become my favorite way to implement asynchronous business logic. An excellent example how a higher order abstraction can make a big impact on our daily work — with code that is simpler, more readable, contains less boilerplate and yet remains as efficient as the best of the alternatives.

---

#### Some things in life take time

Not everything completes immediately. Some operations in software take a short while to finish — which presents a very interesting challenge to implement on systems that are designed for serial execution. If you need to access a server over the network, you’ll have to wait until it responds. Since CPUs are designed to run opcodes one after the other without waiting, what do they do in the meantime?

That’s the basis behind *asynchronicity* and *concurrency*.

#### Why not just block?

Suppose we could halt execution and block until the anticipated response arrives. This normally isn’t a good idea because our program will remain unresponsive to anything else going on. If we’re implementing a frontend application — what happens if the user tries to interact with it while we block? If we’re implementing a backend service — what happens if a new request suddenly comes in?

Let’s start pure, with minimal abstractions and low-level API from the likes of the immortal `[selec](http://man7.org/linux/man-pages/man2/select.2.html)t` function. If we don’t want to block, the alternative is returning immediately — or in other words, *polling*. This also feels wrong, [busy-wait](https://en.wikipedia.org/wiki/Busy_waiting) never sounds like a good idea.

We need something else. We need abstractions.

#### Why multi-threading is evil

The traditional solution to this problem has been an abstraction offered on the operating-system level — [*multi-threading*](https://en.wikipedia.org/wiki/Thread_%28computing%29). We want to block, but we don’t want to block the main execution context. So let’s create additional execution contexts that could run in parallel. But what if we only have a single CPU with a single core? That’s where the abstraction comes in — the OS will multiplex and transparently jump between multiple execution threads for us.

This approach is so popular in fact, that the majority of web content on the Internet is served this way. [Apache HTTP Server](https://httpd.apache.org/), the world’s most popular web server having over [40% market share](https://news.netcraft.com/archives/2016/07/19/july-2016-web-server-survey.html), traditionally relies on a [separate thread](https://httpd.apache.org/docs/2.4/mod/worker.html) to handle every concurrent client.

The problem with relying on threads to magically solve the concurrency problem is that threads are generally expensive in terms of resources and also introduce significant additional complexity when used.

Let’s start with complexity. Threaded code may seem to be simpler because it can be *synchronous* and block until things are ready. The problem is that we usually have little control over when one thread stops running and another starts (a context switch). If we have a shared data structure that several threads rely on, we need to be very careful. If one thread starts updating data and is switched from before completing the update, another thread can pick up from an inconsistent state. This problem introduces synchronization mechanisms such as [mutexes](https://en.wikipedia.org/wiki/Lock_%28computer_science%29) and [semaphores](https://en.wikipedia.org/wiki/Semaphore_%28programming%29) that are never a [delight](http://blog.nahurst.com/thread-synchronization-issues-romance) to work with.

The second problem is cost, or more specifically the resource overhead that threads incur. The *scheduler* is the entity in the OS charged with [orchestrating](https://en.wikipedia.org/wiki/Scheduling_%28computing%29) when threads run. The more threads you have, the more time the OS spends on deciding who should run instead of actually running them. Even more serious is the problem of memory. Every thread has an execution [stack](https://en.wikipedia.org/wiki/Call_stack) that usually reserves several MBs of memory, some of which even has to be [non-paged](https://blogs.technet.microsoft.com/askperf/2007/03/07/memory-management-understanding-pool-resources/) (so [virtual memory](https://en.wikipedia.org/wiki/Virtual_memory) doesn’t necessarily help). This oftens becomes the bottleneck when running large amounts of threads.

These are not theoretical problems, they influence the world around us in some very practical ways. For starters, they contribute to a very poor standard of load acceptable today on the Internet. Ridiculous things like the [Reddit hug of death](http://www.urbandictionary.com/define.php?term=reddit%20hug%20of%20death) constantly happen because many servers can’t handle more than a few thousands of concurrent connections. This is known as the [C10K](http://www.kegel.com/c10k.html) problem. It’s ridiculous because with a slightly different architecture (not based on threads), these same servers could handle hundreds of thousands of concurrent connections with ease.

#### So threads are bad — now what?

It’s not really that threads are bad, it’s more that we shouldn’t rely on them as the *only* concurrency abstraction we have. We must develop abstractions that provide the same freedom of concurrency even on *single-threaded systems*.

This is why I love [Node](https://nodejs.org). JavaScript, due to an [unrelated](http://stackoverflow.com/questions/39879/why-doesnt-javascript-support-multithreading) limitation, forces us to work with a single execution thread. This may seem at first like a big drawback of this ecosystem, but is actually a blessing in disguise. If we don’t have the luxury of threads, we must evolve powerful concurrency tools that are not dependent on them.

What if we have more than one CPU or more than one core? How can we make use of them if Node is single-threaded? In this case we can simply run multiple instances of Node on the same machine.

#### Let’s play with a real-life example

To keep the discussion grounded, let’s take a realistic scenario that we want to implement. Let’s build a service like [Pingdom](https://www.pingdom.com/). Given an array of server URLs, our service will “ping” each one by issuing an HTTP request exactly 3 times in intervals of 10 seconds.

The service will return the list of servers that failed to reply and the number of times they didn’t respond properly. There’s no need to ping different servers in parallel, so we’ll process the list one by one. And lastly, while we wait for a server to respond, we won’t block the main execution thread.

We can summarize our entire service by implementing the following `pingServers` function:

```
const servers = [
  'http://www.sevengramscaffe.com',
  'http://www.hernanparra.co',
  'http://www.thetimeandyou.com',
  'http://www.luchoycarmelo.com'
 ];
pingServers(servers, function (failedServers) {
  for (const url in failedServers) {
    console.log(`${url} failed ${failedServers[url]} times`);
  }
});
```

#### Pseudocode implementation with threads

If we were using multi-threading and allowed ourselves to block, pseudocode of the implementation would have been:

```
function pingServers(servers) {
  let failedServers = {};
  for (const url of servers) {
    let failures = 0;
    for (let i = 0 ; i < 3 ; i++) {
      const response = blockingHttpRequest(url);
      if (!response.ok) failures++;
      blockingSleep(10000);
    }
    if (failures > 0) failedServers[url] = failures;
  }
  return failedServers;
}
```

To make sure we don’t accidently rely on threading, in the next sections we’ll implement the service on Node — using *asynchronous code.*

#### First approach — callbacks

Node relies on the JavaScript [event loop](https://developer.mozilla.org/en/docs/Web/JavaScript/EventLoop). Since it’s single-threaded, API calls normally don’t block execution. Instead, commands that aren’t completed immediately post an event when they do. We can specify a callback function to run when the event is posted, and place the remainder of our business logic there.

The standard complaint about callbacks is the famous *pyramid of doom*, where your code ends up looking like an indented [mess](http://callbackhell.com/). My biggest problem with callbacks is actually different and is that they don’t deal well with *control flow*.

What is control flow? It’s the `for` loops and `if` statements that you need to implement basic business logic rules like pinging every server exactly ***3 times***, and including this server in the result only ***if*** it failed. Try using a `[forEach](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/forEach)` and `[setTimeout](https://developer.mozilla.org/en-US/docs/Web/API/WindowTimers/setTimeout)` to implement this logic and you’ll see that it simply doesn’t work as easily with callbacks as you’d think.

So what do we do instead? One of the more flexible ways I know to implement non-trivial control flow with callbacks is building a [state machine](https://en.wikipedia.org/wiki/Finite-state_machine):

```
import request from 'request';

export function pingServers(servers, onComplete) {
  let state = {
    servers,
    currentServer: 0,
    currentPingNum: 0,
    failedServers: {}
  };
  handleState(state, onComplete);
}

function handleState(state, onComplete) {
  if (state.currentServer >= state.servers.length) {
    onComplete(state.failedServers);
    return;
  }
  if (state.currentPingNum >= 3) {
    state.currentServer++;
    state.currentPingNum = 0;
    setImmediate(() => handleState(state, onComplete));
    return;
  }
  const url = state.servers[state.currentServer];
  request(url, (error, response) => {
    if (error || response.statusCode !== 200) {
      if (!state.failedServers[url]) state.failedServers[url] = 0;
      state.failedServers[url]++;
    }
    state.currentPingNum++;
    setTimeout(() => handleState(state, onComplete), 10000);
    return;
  });
}
```

This works but isn’t as straightforward as I’d like. Let’s explore an alternative implementation using an additional dependency — a library dedicated for callback control flow called [async](https://github.com/caolan/async):

```

import request from 'request';
import asyncLib from 'async';

export function pingServers(servers, onComplete) {
  let failedServers = {};
  asyncLib.eachSeries(servers, (url, onNextUrl) => {
    let failures = 0;
    asyncLib.timesSeries(3, (n, onNextAttempt) => {
      request(url, (error, response) => {
        if (error || response.statusCode !== 200) failures++;
        setTimeout(onNextAttempt, 10000);
      });
    }, () => {
      if (failures > 0) failedServers[url] = failures;
      onNextUrl();
    });
  }, () => {
    onComplete(failedServers);
  });
}
```

This is a little better and shorter. Is this straightforward and easy to understand at a quick glance ? I think we can do better.

#### Second approach — promises

We’re not perfectly happy with the first approach and the way to improve is using a higher level of abstraction. [Promises](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Promise) hold “future” values that haven’t necessarily been resolved yet. It’s a placeholder of sorts that is returned immediately, even if the asynchronous action that defines it hasn’t completed. The interesting thing about promises is that they allow us to start working with this future value immediately and keep chaining actions to it that will actually take place in the future when it’s finally resolved.

We’ll change `pingServers` to return a promise, and alter its usage to:

```
const servers = [
  'http://www.sevengramscaffe.com',
  'http://www.hernanparra.co',
  'http://www.thetimeandyou.com',
  'http://www.luchoycarmelo.com'
 ];
pingServers(servers).then( function (failedServers) {
  for (const url in failedServers) {
    console.log(`${url} failed ${failedServers[url]} times`);
  }
});
```

Most modern asynchronous APIs favor promises to callbacks. In our case, we’ll base our HTTP requests on the [Fetch API](https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API/Using_Fetch) that is promise-based.

We still have the issue of control flow. How can our simple logic be achieved with promises? In my opinion, [functional programming](https://en.wikipedia.org/wiki/Functional_programming) works best with promises, and in JavaScript this usually means pulling out [lodash](https://lodash.com/).

If we had wanted to ping the servers in parallel, things would have been quite easy and we could use an operation like `[map](https://lodash.com/docs#map)` to transform our array of URLs into an array of promises that resolve to the number of failures in each URL. Since we want to ping the servers sequentially, things are a little more tricky. Since each promise needs to be chained to the `[then](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/then)` of the previous one, we’ll need to pass data between the different iterations. This can be achieved with an *accumulator* in operations like `[reduce](https://lodash.com/docs#reduce)` or `[transform](https://lodash.com/docs#transform)`:

```
import _ from 'lodash';
import fetch from 'node-fetch';
import delay from 'delay';

export function pingServers(servers) {
  return _.reduce(servers, (failedServersAccumulator, url) => {
    return failedServersAccumulator.then((failedServers) => {
      return _.reduce(_.range(3), (failuresAccumulator) => {
        return failuresAccumulator.then(delay(10000)).then((failures) => {
          return fetch(url).then((response) => {
            return response.ok ? failures : failures + 1;
          });
        });
      }, Promise.resolve(0)).then((failures) => {
        if (failures > 0) failedServers[url] = failures;
        return failedServers;
      });
    });
  }, Promise.resolve({}));
}
```

Hmmm.. I have to say this isn’t easy on the eyes either. I actually have a hard time following what goes in there 5 minutes after writing it. To help clarify this mess, I think it’s easier if we split the same exact implementation into two separate smaller functions:

```
import _ from 'lodash';
import fetch from 'node-fetch';
import delay from 'delay';

export function pingServers(servers) {
  return _.reduce(servers, (failedServersAccumulator, url) => {
    return failedServersAccumulator.then((failedServers) => {
      return pingOneServer(url).then((failures) => {
        if (failures > 0) failedServers[url] = failures;
        return failedServers;
      });
    });
  }, Promise.resolve({}));
}

function pingOneServer(url) {
  return _.reduce(_.range(3), (failuresAccumulator) => {
    return failuresAccumulator.then(delay(10000)).then((failures) => {
      return fetch(url).then((response) => {
        return response.ok ? failures : failures + 1;
      });
    });
  }, Promise.resolve(0));
}
```

This is a little clearer… but the accumulator still complicates the whole thing.

#### Third approach — async-await bliss

Come on, all we’re trying to do is ping a few servers in order. The previous two approaches gave us valid implementations, but they weren’t exactly trivial to follow. Why is that? Maybe it’s because us humans tend to find procedural thinking a little more intuitive for business logic.

I’ve first [met](http://stackoverflow.com/questions/18498942/why-shouldnt-all-functions-be-async-by-default) the *async-await* pattern while I was doing a side project on Microsoft Azure and learned a little [C# and .NET](https://msdn.microsoft.com/en-us/library/mt674882.aspx) by proxy. I was immediately blown away. This was the best of both worlds — straightforward procedural thinking without the thread block penalties. These guys did an awesome job!

I was delighted to see this pattern seeping into many other languages like [JavaScript](https://github.com/tc39/ecmascript-asyncawait), [Python](https://www.python.org/dev/peps/pep-0492/), [Scala](http://docs.scala-lang.org/sips/pending/async.html), [Swift](https://github.com/yannickl/AwaitKit) and more.

I think the best introduction to async-await is to simply jump into the code and let is speak for itself:

```
import _ from 'lodash';
import fetch from 'node-fetch';
import delay from 'delay';

export async function pingServers(servers) {
  let failedServers = {};
  for (const url of servers) {
    let failures = 0;
    for (const i of _.range(3)) {
      const response = await fetch(url);
      if (!response.ok) failures++;
      await delay(10000);
    }
    if (failures > 0) failedServers[url] = failures;
  }
  return failedServers;
}
```

Now we’re talking. Easy to write, easy to read. What the code is doing is finally obvious from a quick glance. And it’s completely *asynchronous*. Yay.
I can’t put it any better than the words of [Jake Archibald](https://jakearchibald.com/2014/es7-async-functions/):

> They’re brilliant. They’re brilliant and I want laws changed so I can marry them.

Notice how the implementation resembles the synchronous flow we could previously only achieve using threads and blocking. How is it doing it without blocking? There’s a lot of magic happening behind the scenes. I won’t get into it, but the `await` keyword does not block, it yields execution to other things in the event loop. When the result being awaited on is ready, execution can resume from this point.

In addition, the way to call this version of `pingServers` is identical to the previous version with promises. An `async` function returns a `promise`, making integration with existing code as simple as possible.

#### Summary

We’ve severed our dependency on threads for concurrency and played with 3 different flavors of *asynchronous* code. *Callbacks*, *promises* and *async-await* are different abstractions designed for similar purposes. Which one is better? It’s a matter of personal taste.

It’s also nice to see how historically these 3 flavors signify 3 generations of JavaScript. Callbacks ruling in the early days until ES5. Promises prominent in the ES6 era, where JavaScript as a whole took a big step towards modern syntax. And of course, the subject of our celebration — async-await, in the bleeding edge of ES7. It’s a marvelous tool, use it!
