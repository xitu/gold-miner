>* 原文链接 : [Your Timeline for Learning React](https://daveceddia.com/timeline-for-learning-react/)
* 原文作者 : [DAVE CEDDIA](https://daveceddia.com/timeline-for-learning-react/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:



This is your timeline for learning React.

Think of these steps as layers in a foundation.

If you were building a house, would you skip some steps to get it done faster? Maybe jump right to the concrete before laying some rocks down? Start building the walls on bare earth?

Or how about making a wedding cake: the top part looks the most fun to decorate, so why not start there! Just figure out the bottom part later.

No?

Of course not. You know those things would lead to failure.

So why would you approach React by trying to learn ES6 + Webpack + Babel + React + Redux + Routing + AJAX _all at once_? Doesn’t that sound like setting yourself up for failure?

So I’ve laid out a timeline. Take these one step at a time. Do not skip ahead. Do not learn 2 steps at the same time.

One foot in front of the other. Setting aside a bit of time each day, this is probably a few weeks of learning.

The theme of this post is: avoid getting overwhelemed. Slow and steady, uh, learns the React.

You can also [snag a printable PDF](https://daveceddia.com/timeline-for-learning-react/#signup-modal)<a></a> of this timeline and check it off as you go!

## Step 0: JavaScript

I assume you already know JavaScript, at least ES5\. If you don’t yet know JS, you should stop what you’re doing, learn the [basics](https://developer.mozilla.org/en-US/Learn/Getting_started_with_the_web/JavaScript_basics), and _only then_ continue onward.

If you already know ES6, go ahead and use it. Just so you know, React’s API has some differences between ES5 and ES6\. It’s useful to know both flavors – when something goes wrong, you’ll find a wider range of usable answers if you can mentally translate between both styles.

## Step 0.5: NPM

NPM is the reigning package manager of the JavaScript world. There isn’t too much to learn here. After you [install it (with Node.js)](https://nodejs.org), all you really need to know is how to install packages (`npm install <package name>`).

## Step 1: React

Start with [Hello World](https://daveceddia.com/test-drive-react). Use either a plain HTML file with some `script` tags ala the [official tutorial](https://facebook.github.io/react/docs/tutorial.html) or use a tool like React Heatpack to get you up and running quickly.

Try out the [Hello World in 3 minutes](https://daveceddia.com/test-drive-react) tutorial!

## Step 2: Build a Few Things, and Throw Them Away

This is the awkward middle step that a lot of people skip.

Don’t make that mistake. Moving forward without having a firm grasp of React’s concepts will lead straight back to overwhelmsville.

But this step isn’t very well-defined: what should you build? A prototype for work? Maybe a fancy Facebook clone, something meaty to really get used to the whole stack?

Well, no, not those things. They’re either loaded with baggage or too large for a learning project.

“Prototypes” for work are especially terrible, because _you absolutely know_ in your heart that a “prototype” will be nothing of the sort. It will live long beyond the prototype phase, morph into shipping software, and never be thrown away or rewritten.

Using a work “prototype” as a learning project is problematic because you’re likely to get all worked up about the _future_. Because you _know_ it’ll be more than just a prototype, you start to worry – shouldn’t it have tests? I should make sure the architecture will scale… Am I going to have to refactor this mess later? And shouldn’t it have tests?

This specific problem is what I’m aiming to tackle with my [React for Angular Developers](https://daveceddia.com/react-for-angular-developers) guide: once you get past “Hello World,” how do you learn to “think in React?”

I’ll give you some idea: the ideal projects are somewhere between “Hello World” and “All of Twitter.”

Build some lists of things (TODOs, beers, movies). Learn how the data flow works.

Take some existing large UIs (Twitter, Reddit, Hacker News, etc) and break off a small chunk to build – carve it up into components, build the pieces, and render it with static data.

You get the idea: small, throwaway apps. They _must be throwaways_ otherwise you’ll get hung up on maintainability and architecture and other crap that just doesn’t matter yet.

I’ll let you know when [React for Angular Developers](https://daveceddia.com/react-for-angular-developers) is ready if you’re [on my subscriber list](https://daveceddia.com/timeline-for-learning-react/#signup-modal).

## Step 3: Webpack

Build tools are a major stumbling block. Setting up Webpack feels like _grunt work_, and it’s a whole different mindset from writing UI code. This is why Webpack is down at Step 3, instead of Step 0.

I recommend [Webpack – The Confusing Parts](https://medium.com/@rajaraodv/webpack-the-confusing-parts-58712f8fcad9) as an introduction to Webpack and its way of thinking.

Once you understand what it does (bundles _every kind of file_, not just JS) – and how it works (loaders for each file type), the Webpack part of your life will be much happier.

## Step 4: ES6

Now that you’re in Step 4, you have all those steps above as _context_. The bits of ES6 you learn now will help you write cleaner, better code – and faster. If you tried to memorize it all in the beginning, it wouldn’t have stuck – but now, you know how it all fits in.

Learn the parts you’ll use most: arrow functions, let/const, classes, destructuring, and `import`.

## Step 5: Routing

Some people conflate React Router and Redux in their head – they’re not related or dependent on each other. You can (and should!) learn to use React Router before diving into Redux.

By this point you’ll have a solid foundation in “thinking in React,” and React Router’s component-based approach will make more sense than if you’d tackled it on Day 1.

## Step 6: Redux

Dan Abramov, the creator of Redux, [will tell you](https://github.com/gaearon/react-makes-you-sad) not to add Redux too early, and for good reason – it’s a dose of complexity that can be disastrous early on.

The concepts behind Redux are fairly simple. But there is a mental leap from understanding the pieces to knowing how to use them in an app.

So, repeat what you did in Step 2: build disposable apps. Build a bunch of little Redux experiements to really internalize how it works.

## Non-steps

Did you see “choose a boilerplate project” anywhere in the list? Nope.

Diving into React by picking one of the bajillion boilerplate projects out there will only confuse you. They include every possible library, and force a directory structure upon you – and neither of these are required for smaller apps, or when you’re getting started.

And if you’re thinking “But Dave I’m not building a small app, I’m building a complex app that will serve millions of users!”… go re-read that bit about prototypes.

## How to tackle this

This is a lot to take in. It’s a lot to learn – but there’s a logical progression. One foot in front of the other.

There are a bunch of steps though, and what if you forget the order and skip ahead?

If only there were a way to keep your eyes on the prize…

Well, there is: I’ve put together a printable PDF of this timeline, and you can sign up to get it below!

