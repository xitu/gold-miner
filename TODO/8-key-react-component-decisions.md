> * 原文地址：[8 Key React Component Decisions: Standardize your React development with these key decisions](https://medium.freecodecamp.org/8-key-react-component-decisions-cc965db11594)
> * 原文作者：[Cory House](https://medium.freecodecamp.org/@housecor?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/8-key-react-component-decisions.md](https://github.com/xitu/gold-miner/blob/master/TODO/8-key-react-component-decisions.md)
> * 译者：
> * 校对者：

# 8 Key React Component Decisions

## Standardize your React development with these key decisions

![](https://cdn-images-1.medium.com/max/1000/1*XgHYXVXoyziBKd7Or5IliQ.jpeg)

With this many options, choosing is hard.

React was open-sourced in 2013\. Since then, it has evolved. As you search the web, you’ll stumble across old posts with dated approaches. So, here are eight key decisions your team needs to make when writing React components today.

### Decision 1: Dev Environment

Before you write your first component, your team needs to agree on a dev environment. Lots of options…

![](https://i.loli.net/2017/10/17/59e5d90a25a0a.jpg)

Sure, you can [build a JS dev environment from scratch](https://www.pluralsight.com/courses/javascript-development-environment). 25% of React devs do just that. My current team uses a fork of create-react-app with additional features such as a [realistic mock API that supports CRUD](https://medium.freecodecamp.org/rapid-development-via-mock-apis-e559087be066), a [reusable component library](https://www.pluralsight.com/courses/react-creating-reusable-components), and linting enhancements (we lint our test files too, which create-react-app ignores). I enjoy create-react-app, but [this tool will help you compare many compelling alternatives](http://andrewhfarmer.com/starter-project/). Want to render on the server? Check out [Gatsby](http://gatsbyjs.org) or [Next.js](https://github.com/zeit/next.js/). You can even consider using an online editor like [CodeSandbox](https://codesandbox.io).

### Decision 2: Types

You can ignore types, use [prop-types](https://reactjs.org/docs/typechecking-with-proptypes.html), use [Flow](https://flow.org), or use [TypeScript](https://www.typescriptlang.org). Note that prop-types was extracted to a [separate library](https://www.npmjs.com/package/prop-types) in React 15.5, so older posts will show imports that don’t work anymore.

The community remains divided on this topic:

![](https://i.loli.net/2017/10/17/59e5da85a81b6.jpg)

I prefer prop-types because I find it provides sufficient type safety in React components with little friction. Using the combination of Babel, [Jest tests](https://facebook.github.io/jest/), [ESLint](http://www.eslint.org), and prop-types, I rarely see runtime type issues.

### Decision 3: createClass vs ES Class

React.createClass was the original API, but in 15.5, it was deprecated. Some feel [we jumped the gun moving to ES classes](https://medium.com/dailyjs/we-jumped-the-gun-moving-react-components-to-es2015-class-syntax-2b2bb6f35cb3). Regardless, the createClass style has been moved out of React core and [relegated to a single page called “React without ES6” in the React docs](https://reactjs.org/docs/react-without-es6.html). So it’s clear: ES classes are the future. You can easily convert from createClass to ES Classes using [react-codemod](https://github.com/reactjs/react-codemod).

### Decision 4: Class vs Functional

You can declare React components via a class or a function. Classes are useful when you need refs, and lifecycle methods. Here are [9 reasons to consider using functions when possible](https://hackernoon.com/react-stateless-functional-components-nine-wins-you-might-have-overlooked-997b0d933dbc). But it’s also worth noting that [there are some downsides to functional components](https://medium.freecodecamp.org/7-reasons-to-outlaw-reacts-functional-components-ff5b5ae09b7c).

### Decision 5: State

You can use plain React component state. It’s sufficient. [Lifting state](https://reactjs.org/docs/lifting-state-up.html) scales nicely. Or, you may enjoy Redux or MobX:

![1508235965(1).jpg](https://i.loli.net/2017/10/17/59e5daca05632.jpg)

[I’m a fan of Redux](https://www.pluralsight.com/courses/react-redux-react-router-es6), but I often use plain React since it’s simpler. In my current role, we’ve shipped about a dozen React apps, and decided Redux was worth it for two. I prefer shipping many, small, autonomous apps over a single large app.

On a related note, if you’re interested in immutable state, there are at least [4 ways to keep your state immutable](https://medium.com/@housecor/handling-state-in-react-four-immutable-approaches-to-consider-d1f5c00249d5).

### Decision 6: Binding

There are at least [half a dozen ways you can handle binding](https://medium.freecodecamp.org/react-binding-patterns-5-approaches-for-handling-this-92c651b5af56) in React components. In React’s defense, this is mostly because modern JS offers many ways to handle binding. You can bind in the constructor, bind in render, use an arrow function in render, use a class property, or use decorators. [See the comments on this post](https://medium.freecodecamp.org/react-binding-patterns-5-approaches-for-handling-this-92c651b5af56) for even more options! Each approach has its merits, but assuming you’re comfortable with experimental features, [I suggest using class properties (aka property initializers) by default today](https://medium.freecodecamp.org/react-binding-patterns-5-approaches-for-handling-this-92c651b5af56).

This poll is from Aug 2016\. Since then, it appears class properties have grown in popularity, and createClass has reduced in popularity.

![](https://i.loli.net/2017/10/17/59e5daf6be182.jpg)

**Side note**: Many are confused about why arrow functions and bind in render are potentially problematic. The real reason? [It makes shouldComponentUpdate and PureComponent cranky](https://medium.freecodecamp.org/why-arrow-functions-and-bind-in-reacts-render-are-problematic-f1c08b060e36).

### Decision 7: Styling

Here’s where the options get seriously intense. There are 50+ ways to style your components including React’s inline styles, traditional CSS, Sass/Less, [CSS Modules](https://github.com/css-modules/css-modules), and [56 CSS-in-JS options](https://github.com/MicheleBertoli/css-in-js). Not kidding. I explore React styling approaches in detail [in the styling module of this course](https://www.pluralsight.com/courses/react-creating-reusable-components), but here’s the summary:

![](https://cdn-images-1.medium.com/max/1000/1*5Q3FXqxI6akM-GWV2rqlcw.png)

Red is bad. Green is good. Gray is warning.

See why there is so much fragmentation in React’s styling options? There’s no clear winner.

![](https://cdn-images-1.medium.com/max/800/1*_K-z-ZfTXNFwyedAXrS5sA.png)

Looks like CSS-in-JS is gaining steam. CSS modules is losing steam.

My current team uses Sass with BEM and are happy enough, but I also enjoy [styled-components](https://www.styled-components.com).

### Decision 8: Reusable Logic

React initially embraced [mixins](https://reactjs.org/docs/react-without-es6.html#mixins) as a mechanism for sharing code between components. But mixins caused issues and are [now considered harmful](https://reactjs.org/blog/2016/07/13/mixins-considered-harmful.html). You can’t use mixins with ES class components, so now people [utilize higher-order components](https://reactjs.org/docs/higher-order-components.html) and [render props](https://cdb.reacttraining.com/use-a-render-prop-50de598f11ce) (aka function as child) to share code between components.

![1508236093(1).jpg](https://i.loli.net/2017/10/17/59e5db5a8f656.jpg)

Higher-order components are currently more popular, but I prefer render props since they’re often easier to read and create. [Michael Jackson recently sold me with this](https://cdb.reacttraining.com/use-a-render-prop-50de598f11ce):

[Video-YouTube](https://youtu.be/BcVAq3YFiuc)

### And that’s not all…

There are more decisions:

* Will you use a [.js or .jsx extension](https://github.com/facebookincubator/create-react-app/issues/87#issuecomment-234627904)?
* Will you place [each component in its own folder](https://medium.com/styled-components/component-folder-pattern-ee42df37ec68)?
* Will you enforce one component per file? Will you [drive people nuts by slapping an index.js file in each directory](https://hackernoon.com/the-100-correct-way-to-structure-a-react-app-or-why-theres-no-such-thing-3ede534ef1ed)?
* If you use propTypes, will you declare them at the bottom, or within the class itself using [static properties](https://michalzalecki.com/react-components-and-class-properties/#static-fields)? Will you [declare propTypes as deeply as possible](https://iamakulov.com/notes/deep-proptypes/?utm_content=buffer57abf&utm_medium=social&utm_source=twitter.com&utm_campaign=buffer)?
* Will you initialize state traditionally in the constructor or utilize the [property initializer syntax](http://stackoverflow.com/questions/35662932/react-constructor-es6-vs-es7)?

And since React is mostly just JavaScript, you have the usual long list of JS development style decisions such as [semicolons](https://eslint.org/docs/rules/semi), [trailing commas](https://eslint.org/docs/rules/comma-dangle), [formatting](https://github.com/prettier/prettier), and [event handler naming](https://jaketrent.com/post/naming-event-handlers-react/) to consider too.

### Choose a Standard, Then Automate Enforcement

And all this up, and there are dozens of combinations you may see in the wild today.

So, these next steps are key:

> 1. Discuss these decisions as a team and document your standard.

> 2. Don’t waste time manually policing inconsistency in code reviews. Enforce your standards using tools like [ESLint](https://eslint.org), [eslint-plugin-react](https://github.com/yannickcr/eslint-plugin-react), and [prettier](https://github.com/prettier/prettier).

> 3. Need to restructure existing React components? Use [react-codemod](https://github.com/reactjs/react-codemod) to automate the process.

Other key decisions I’ve overlooked? Chime in via the comments.

### Looking for More on React? ⚛️

I’ve authored [multiple React and JavaScript courses](http://bit.ly/psauthorpageimmutablepost) on Pluralsight ([free trial](http://bit.ly/pstrialimmutablepost)).

[![](https://cdn-images-1.medium.com/max/800/1*BkPc3o2d2bz0YEO7z5C2JQ.png)](https://www.pluralsight.com/authors/cory-house)

* * *

[Cory House](https://twitter.com/housecor) is the author of [multiple courses on JavaScript, React, clean code, .NET, and more on Pluralsight](http://pluralsight.com/author/cory-house). He is principal consultant at [reactjsconsulting.com](http://www.reactjsconsulting.com), a Software Architect at VinSolutions, a Microsoft MVP, and trains software developers internationally on software practices like front-end development and clean coding. Cory tweets about JavaScript and front-end development on Twitter as [@housecor](http://www.twitter.com/housecor).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
