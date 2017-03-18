> * 原文地址：[A Map To Modern JavaScript Development](https://hackernoon.com/a-map-to-modern-javascript-development-2017-16d9eb86309c#.5veb58lh7)
> * 原文作者：[Santiago de León](https://hackernoon.com/@sdeleon28?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# A Map To Modern JavaScript Development (2017) #

So you’ve been doing REST APIs for the past 5 years. Or perhaps you’ve been optimizing searches for your company’s gigantic database. Maybe writing the embedded software for a microwave oven? It’s been a while since you were rocking some Prototype.js to do proper OOP in the browser. And now you’ve decided it’s time to get up to speed with your frontend skills. You take a look at the landscape and it looks like [this](https://thefullfool.files.wordpress.com/2010/09/wheres-waldo1.jpg) .

Of course you’re not looking for Waldo. You’re looking for 25 random guys and don’t even know what their names are. This feeling of being overwhelmed is so common in the JavaScript community that the term “JavaScript fatigue” actually exists. When you have time for some comedy about the subject, [this post](https://hackernoon.com/how-it-feels-to-learn-javascript-in-2016-d3a717dd577f#.1ubvm0x0u) reflects the phenomenon brilliantly.

But you don’t have the time for that now. You’re in a giant maze, and you need a map. So I made a map.

A little disclaimer first: This is a cheat-sheet to get you up and running fast without having to make too many decisions by yourself. Basically I will be laying out a set of tools that just work together for general-purpose frontend development. This will get you comfortable with the environment and will save you a few headaches. Once you’re done with these topics, you’ll be confident enough to adjust the stack to your needs.

#### Structure of the map ####

I will divide the map into problems that you’ll need to tackle. For each problem, I will:

- Describe the problem or the need for a tool
- Decide which tool you will use to solve the problem
- Explain why I chose that tool
- Give a few alternatives

#### Package management ####

- **Problem:** Need to organize your project and your dependencies.
- **Solution:** NPM and Yarn
- **Reason:** NPM is pretty much the de-facto package manager. Yarn runs on top of NPM but optimizes dependency resolution and keeps a lock file of the exact version of your libraries (use it in tandem with NPM’s semantic versioning, they’re not exclusive, they complement each other).
- **Alternatives:** None that I know of.

#### **JavaScript flavor** ####

- **Problem:** ECMAScript 5 (aka old-school JavaScript) sucks.
- **Solution:** ES6
- **Reason:** It’s the future JavaScript but you can use it right now. Incorporates many useful features that have been available to other programming languages for a long time. Interesting new features: arrow functions, module import/export capabilities, de-structuring, template strings, let and const, generators, promises. If you’re a Python coder you’ll feel at home.
- **Alternatives:** TypeScript, CoffeeScript, PureScript, Elm

#### Transpiling ####

- **Problem:** Many browsers that are still massively in use don’t implement ES6. You need a program that translates (transpiles) your modern ES6 into equivalent, well-supported ES5.
- **Solution:** babel
- **Reason:** Works perfectly and it’s pretty much the de-facto standard. Transpiles server-side.
- **Alternatives:** Traceur
- **Notes:** You will use babel-loader, a Webpack loader (more on that later on). You’ll need transpiling if you plan to use any of the other JavaScript flavors as well.

#### **Linting** ####

- **Problem:** There’s a zillion ways of writing JavaScript and consistency is hard to achieve. Some bugs can be prevented with a linter.
- **Solution:** ESLint
- **Reason:** Great code insight and very configurable. The airbnb preset is all you need to get up and running. Really helps you get used to the new syntax.
- **Alternatives:** JSLint

#### Bundling ####

- **Problem:** You are no longer using a flat file or sequence of files. Dependencies need to be resolved and loaded properly.
- **Solution:** Webpack
- **Reason:** Highly configurable. Can load all sorts of dependencies and assets. It’s pluggable. It’s pretty much the de-facto bundler for React projects.
- **Alternatives:** Browserify
- **Disadvantages:** Can be a little hard to configure at first.
- **Notes:** You’ll want to spend some time really understanding how this guy works. You should also learn about babel-loader, style-loader, css-loader, file-loader, url-loader.

#### Testing ####

- **Problem:** Your app is fragile. It will fall apart. You need tests.
- **Solution:** mocha (test runner), chai (assertion library) and chai-spies (for spies, fake objects that you can query for certain events that should or shouldn’t have happened).
- **Reason:** Easy to use and powerful.
- **Alternatives:** Jasmine, Jest, Sinon, Tape.

#### UI framework / state management ####

- **Problem:** This is one of the big ones. SPAs have grown more and more complex. Mutable state is particularly troublesome.
- **Solution:** React and Redux
- **Reasons for using React:** Mind-blowing paradigm shift, breaks a lot of dogmas as old as the web and does it amazingly. Better separation of concerns than traditional approach: instead of separating by technology (HTML/CSS/JavaScript) you break things up by their functionality (cohesive components). Your UI is a pure function of your state.
- **Reasons for using Redux:** If your app is non-trivial, you need a tool to manage the state (otherwise you’ll be doing gymnastics for your components to talk to each other, learn vanilla inter-component communication first to experience the limitations). Every tutorial on the web will walk you through the confusing, abstract Flux pattern and all implementations that there have ever been. Save yourself a decent amount of time and go straight to Redux. It implements the pattern in a very simple manner. Even Facebook uses this. Extra awesomeness: reload and keep application state, time travel, testability.
- **Alternatives:** Angular2, Vue.js.
- **Warning:** You might feel an urge to pry your eyes out with a rusty spoon the first time you see JSX code. Resist the temptation to find a forum and yell in outrage. This is just cognitive dissonance caused by years of indoctrination. Turns out mixing HTML, JavaScript and CSS in a single file is super awesome. Believe me! — Achievement unlocked for using two lame references in a single bullet.

#### DOM manipulation and animations ####

- **Problem:** Guess what? You’ll still need occasional quickfixes where you’ll have to target selectors and perform operations directly on DOM nodes.
- **Solution:** Plain ES6 or jQuery.
- **Reason:** Yes, jQuery is still alive and well. React and jQuery aren’t mutually exclusive. Although, be aware that you should be able to do most of what you need with vanilla React (and `querySelector`). Adding jQuery will also increase your bundle’s footprint slightly. I’d say that using jQuery on top of React is a smell and you should avoid it whenever possible. If you hit a certain corner case that you can’t figure out with just React + ES6 features, or if you’re dealing with some annoying cross-browser quirk, jQuery might save the day.
- **Alternatives:** Dojo (does that still even exist?).

#### Styling ####

- **Problem:** Now that you have proper modules, you want them to be self-contained, reusable pieces of software that you can move around. Component styles should be as portable as the components themselves.
- **Solution:** CSS modules.
- **Reason:** As much as I love inline styles (and use them extensively), I must admit that they’re rather limited. Yes, it’s totally OK to use inline styles in React, but you can’t target pseudo-class selectors (like `:hover`) with them, which is a deal-breaker in many cases.
- **Alternatives:** Inline styles. What I particularly like about inline styles in React is that they allow you to treat styles as regular JavaScript objects, which lets you process them programatically. Also, they live in the same file as your component, which makes them super easy to maintain. Some people still advocate for SASS/SCSS/Less. These languages imply an extra build step and aren’t as portable as CSS modules/inline styles but are as powerful as they’ve ever been.

#### That’s it! ####

You now have a metric shit-ton of stuff to study, but at least you won’t need to spend so much time doing research. Do you think I missed something? Did I drop the ball somewhere? Leave a comment or reach me on twitter [@bug_factory](http://twitter.com/bug_factory).
