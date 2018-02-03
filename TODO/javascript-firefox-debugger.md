> * 原文地址：[Debugging JavaScript With A Real Debugger You Did Not Know You Already Have](https://www.smashingmagazine.com/2018/02/javascript-firefox-debugger/)
> * 原文作者：[Dustin Driver](https://www.smashingmagazine.com/author/dustindriver-jasonlaster)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/javascript-firefox-debugger.md](https://github.com/xitu/gold-miner/blob/master/TODO/javascript-firefox-debugger.md)
> * 译者：
> * 校对者：

# Debugging JavaScript With A Real Debugger You Did Not Know You Already Have

`console.log` can tell you a lot about your app, but it can't truly debug your code. For that, you need a full-fledged JavaScript debugger. The new Firefox JavaScript debugger can help you write fast, bug-free code. Here's how it works.

In this example, we'll crack open a very simple to-do app with Debugger. [Here's the app](https://mozilladevelopers.github.io/sample-todo/01-variables/), based on basic open-source JavaScript frameworks. Open it up in the latest version of [Firefox Developer Edition](https://www.mozilla.org/firefox/developer/) and then launch `debugger.html` by hitting `Option` + `Cmd` + `S` on Mac or `Shift` + `Ctrl` + `S` on Windows. The Debugger is divided into three panes: the source list pane, the source pane, and the tool pane.

![](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_2000/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/dd605d5c-e94d-43e3-a7ef-94eea52cff9e/image2.png)

[Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/dd605d5c-e94d-43e3-a7ef-94eea52cff9e/image2.png)

The Tools pane is further divided into the toolbar, watch expressions, breakpoints, the call stack, and scopes.

![](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/2b99b781-28e8-4bff-a5ff-d1ee43c2d432/image3.png)

[Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/2b99b781-28e8-4bff-a5ff-d1ee43c2d432/image3.png)

### Stop Using `console.log`

It's tempting to use `console.log` to debug your code. Just stick a call into your code to find the value of a variable, and you're set, right? Sure, that can work, but it can be cumbersome and time-consuming. In this example, we'll use `debugger.html` to step through the todo app code to find the value of a variable.

We can use `debugger.html` to dive deeper into the todo app by simply adding a breakpoint to a line of code. Breakpoints tell the Debugger to pause on a line so you can click into the code to see what's going on. In this example, we'll add a breakpoint to line 13 of the `app.js` file.

![](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/a3633871-65f2-4815-9270-2b5e19b316f4/image5.gif)

[Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/a3633871-65f2-4815-9270-2b5e19b316f4/image5.gif)

Now add a task to the list. The code will pause at the addTodo function, and we can dive into the code to see the value of the input and more. Hover over a variable to see the value and more. You can see anchors and applets and children and all sorts of things:

![](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/5f23c4d0-5b4d-41ff-9367-e534d0f96168/image4.png)

[Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/5f23c4d0-5b4d-41ff-9367-e534d0f96168/image4.png)

You can also dive into the Scopes panel to get the same info.

Now that the script is paused, we can step through it using the Toolbar. The play/pause button does just what it says on the tin. "Step Over" steps across the current line of code, "Step In" steps into the function call, and "Step Out" runs the script until the current function exits.

![](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/2c04dd57-b4b4-42c7-be87-685a71c8df56/image1.png)

[Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/2c04dd57-b4b4-42c7-be87-685a71c8df56/image1.png)

We can also use a watch expression to keep an eye on the value of a variable. Just type an expression in the Watch Expression field, and the debugger will keep an eye on it as you step through the code. In the example above, you can add the expressions "title" and "to-do" and the debugger will spit out the values when they're available. This is especially useful when:

* You're stepping and want to watch values change;
* You're debugging the same thing many times and want to see common values;
* You're trying to figure out why that damn button won't work.

You can also use `debugger.html` to debug your React/Redux apps. Here's how it works:

* Navigate to a component you want to debug.
* See the component outline on the left (functions in the class).
* Add breakpoints to the relevant functions.
* Pause and see component props and state.
* The call stack is simplified so that you see your application code interleaved with the framework.

Finally, `debugger.html` lets you see obfuscated or minified code that could be triggering errors, which is especially useful when you're dealing with common frameworks like React/Redux. The Debugger knows about components you're paused in and will show a simplified call stack, component outline, and properties. Here's developer Amit Zur explaining how he uses the Firefox debugger to dive into code at [JS Kongress](https://2017.js-kongress.de/):

<iframe width="841" height="400" src="https://www.youtube.com/embed/Rop3EgPvBMw" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

If you're interested in an in-depth walkthrough on the new `debugger.html`, head over to the [Mozilla Developer Playground](https://mozilladevelopers.github.io/playground/debugger). We've built a tutorial series to help developers learn how to effectively use the tool to debug their code.

### Open-Source DevTools

The [`debugger.html` project](https://github.com/devtools-html/debugger.html) was launched about two years ago along with a full overhaul of all the Firefox DevTools. We wanted to rebuild DevTools using modern web technologies, to open them up to developers around the world. And when a technology is open, it's free to grow beyond anything our small group at Mozilla can imagine.

JavaScript is essential to any advanced web app, so a strong debugger was a key part of the toolset. We wanted to build something that was fast, easy to use, and adaptable—able to debug any new JavaScript frameworks that may emerge. We decided to use popular web technologies because we wanted to work closer with the community. This approach would also improve the Debugger itself — if we adopted WebPack and started using a build tool and source maps internally, we'd want to improve source mapping and hot reloading.

The `debugger.html` is built with React, Redux, and Babel. The React components are lightweight, testable, and easy to design. We use React Storybook for quick UI prototyping and documenting shared components. Our Components are tested with Jest and Enzyme, which make it easier to iterate on top of the UI. This makes it easier to work with various JavaScript frameworks (like React). Our Babel front-end lets us do things like show the Component class and its functions in the left sidebar. We are also able to do cool things like pinning breakpoints to functions, so they don't move when you change your code.

The Redux actions are a clean API for the UI, but could just as easily be used to build a standalone CLI JS Debugger. The Redux store has selectors for querying the current debugging state. Our redux unit test fires Redux actions and simulates browser responses. Our integration tests drive the browser with debugger Redux actions. The functional architecture itself is designed to be testable.

We relied on the Mozilla developer community every step of the way. The project was posted on [GitHub](https://github.com/devtools-html/debugger.html) and our team reached out to developers worldwide to help out. When we started, automated tests were a critical component for community development. Tests prevent regressions and document behavior that's easy to miss. This is why one of the first steps we took was to add unit tests for Redux actions and Flow types for the Redux store. In fact, the community ensured that our Flow and Jest coverage would help make sure every file was typed and tested.

As developers, we believe tools are stronger the more people are involved. Our core team has always been small (2 people), but we average 15 contributors a week. The community brings a diversity of perspectives that helps us anticipate challenges and build features we would not have dreamed of. We now format call stacks for 24 different libraries, many of which we had never heard of. We also show WebPack and Angular maps in the source tree.

We plan to move all the Firefox DevTools to GitHub so they can be used and improved by a wider audience. We'd love for you to contribute. Head over to our GitHub project page for `[debugger.html](https://github.com/devtools-html/debugger.html)` to get started. We've created a full list of instructions on how to run the debugger on your own machine, where you can modify it to do whatever you'd like. Use it to debug JavaScript code for anything — browsers, terminals, servers, phones, robots. And if you see ways to improve it, let us know via GitHub.

_You can download the latest version of Firefox (and DevTools) over [here](https://www.mozilla.org/firefox)._


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
