> * 原文地址：[When a rewrite isn’t: rebuilding Slack on the desktop](https://slack.engineering/rebuilding-slack-on-the-desktop-308d6fe94ae4)
> * 原文作者：[Slack Engineering](https://medium.com/@SlackEng)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/when-a-rewrite-isnt-rebuilding-slack-on-the-desktop.md](https://github.com/xitu/gold-miner/blob/master/TODO1/when-a-rewrite-isnt-rebuilding-slack-on-the-desktop.md)
> * 译者：
> * 校对者：

# When a rewrite isn’t: rebuilding Slack on the desktop

**A new version of Slack is rolling out for our desktop customers, built from the ground up to be faster, more efficient, and easier to work on.**

![Photo by [Caleb George](https://unsplash.com/@seemoris?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/7936/0*cgkWRCMtQXti3jbA)

[Conventional wisdom](https://www.joelonsoftware.com/2000/04/06/things-you-should-never-do-part-i/) holds that you should never rewrite your code from scratch, and that’s good advice. Time spent rewriting something that already works is time that won’t be spent making our customers working lives simpler, more pleasant, and more productive. And running code knows things: hard-won knowledge gained through billions of hours of cumulative usage and tens of thousands of bug fixes.

Still, software codebases have life spans. The desktop version of Slack is our oldest client, growing out of a period of rapid development and experimentation during the earliest moments of our company. During this period, we were optimizing for product-market fit and in a constant sprint to keep up with our customers as their use — and expectations — of the product grew.

Today, after more than half a decade of hyper-growth, Slack is used by millions of people with larger companies working with more data than we ever could have imagined when we first started. Somewhat predictably, a few internal cracks were starting to show in the desktop client’s foundation. Additionally, the technology landscape had shifted away from the tools we chose in late 2012 (jQuery, Signals, and direct DOM manipulation) and toward a paradigm of composable interfaces and clean application abstractions. Despite [our best efforts to keep things snappy](https://slack.engineering/getting-to-slack-faster-with-incremental-boot-ff063c9222e4), it became clear that some fundamental changes would be required to evolve the desktop app and prepare it for the next wave of product development.

The architecture of the existing desktop app had a number of shortcomings:

1. **Manual DOM updates.** Slack’s original UI was built using HTML templates that needed to be manually rebuilt whenever the underlying data changed, making it a pain to keep the data model and user interface in sync. We wanted to adopt React, a popular JavaScript framework that made this sort of thing more automatic and less prone to potential errors.
2. **Eager data loading.** The data model was “complete”, meaning that each user session started by downloading **everything** relevant to the user. While great in theory, in practice this was prohibitively expensive for large workspaces and meant that we had to do a lot of work to keep data models up-to-date over the course of a user’s session.
3. **Multiple processes for multiple workspaces.** When signed into multiple workspaces, each of those workspaces was in fact running a stand-alone copy of the web client inside a separate Electron process, which meant that Slack used more memory than users expected.

The [first](https://slack.engineering/rebuilding-slacks-emoji-picker-in-react-bfbd8ce6fbfe) [two](https://slack.engineering/flannel-an-application-level-edge-cache-to-make-slack-scale-b8a6400e2f6b) problems were the sort of things that we could incrementally improve over time, but getting multiple workspaces to run within a single Electron process meant changing a fundamental assumption of the original design — that there is only ever a single workspace running at a time. Although we made some [incremental improvements](https://slack.engineering/reducing-slacks-memory-footprint-4480fec7e8eb) for folks with lots of idle workspaces, truly solving the multiple process problem meant rewriting Slack’s desktop client from scratch.

## Bit by bit

The [Ship of Theseus](https://en.wikipedia.org/wiki/Ship_of_Theseus) is a thought experiment that considers whether an object that has had each of its pieces replaced one-by-one over time is still the same object when all is said and done. If every piece of wood in a ship has been replaced, is it the same ship? If every piece of JavaScript in an app has been replaced, is it the same app? We sure hoped so, because this seemed like the best course of action.

Our plan was to:

* keep the existing codebase;
* create a “modern” section of the codebase that would be future-proof and work the way we wanted it to;
* modernize the implementation of Slack bit by bit, replacing existing code with modern code incrementally;
* define rules that would enforce a strict interface between existing and modern code so it would be easy to understand their relationship;
* and continually ship all of the above with the existing app, replacing older modules with modern implementations that suited our new architecture.

The final step — and the most important one for our purposes — was to create a modern-only version of Slack that would start out incomplete but gradually work its way toward feature completeness as modules and interfaces were modernized.

We’ve been using this modern-only version of the app internally for much of the last year, and it is now rolling out to customers.

## Modern times

The first order of business was to create the modern codebase. Although this was just a new subdirectory in our codebase, it had three important rules enforced by convention and tooling, each of which was intended to address one of our existing app’s shortcomings:

1. All UI components had to be built with React
2. All data access had to assume a lazily loaded and incomplete data model
3. All code had to be “multi-workspace aware”

The first two rules, while time-consuming to fulfill, were relatively straightforward. However, moving to a multi-workspace architecture was quite the undertaking. We couldn’t expect every function call to pass along a workspace ID, and we couldn’t just set a global variable saying which workspace was currently visible since plenty of things continue to happen behind the scenes regardless of which workspace the user is currently looking at.

The key to our approach ended up being [Redux](https://redux.js.org/), which we were already using to manage our data model. With a bit of consideration and the help of the [redux-thunk](https://github.com/reduxjs/redux-thunk) library, we were able to model virtually everything as actions or queries on a Redux store, allowing Redux to provide a convenient abstraction layer around the concept of individual workspaces. Each workspace would get its own Redux store with everything living within it — the workspace’s data, information about the client’s connectivity status, the WebSocket we use for real-time updates — you name it. This abstraction created a conceptual container around each workspace without having to house that container in its own Electron process, which was what the legacy client did.

With this realization, we had our new architecture in place:

![](https://cdn-images-1.medium.com/max/2612/1*cTUr99NpvxHSZWHfdxu-Rw.png)

![**Architecture comparison.** New client on the right.](https://cdn-images-1.medium.com/max/2612/1*vzAu72QESmgToZY866HP8Q.png)

## A legacy of interoperability

At this point we had a plan and an architecture we thought would work, and we were ready to work our way through the existing codebase, modernizing everything until we were left with a brand new Slack. There was just one last problem to solve.

We couldn’t just start replacing old code with new code willy-nilly; without some type of structure to keep the old and new code separate, they’d end up getting hopelessly tangled together and we’d never have our modern codebase. To solve this problem, we introduced a few rules and functions in a concept called legacy-interop:

* **old code cannot directly import new code:** only new code that has been “exported” for use by the old code is available
* **new code cannot directly import old code:** only old code that has been “adapted” for use by modern code is available.

Exporting new code to the old code was simple. Our original codebase did not use JavaScript modules or imports. Instead, it kept everything on a top-level global variable called TS. The process of exporting new code just meant calling a helper function that made the new code available in a special TS.interop part of that global namespace. For example, TS.interop.i18n.t() would call into our modern, multi-workspace aware string localization function. Since the TS.interop namespace was only used from our legacy codebase, which only loaded a single workspace at a time, we could do a simple look-up to determine the workspace ID behind the scenes without requiring the legacy code to worry about it.

Adapting old code for new code was less trivial. Both the new code and the old code would be loaded when we were running the classic version of Slack, but the modern version would only include the new code. We needed to find a way to make it possible to conditionally tap into old code without causing errors in the new code, and we wanted the process to be as transparent to developers as possible.

Our solution was called adaptFunctionWithFallback, which took a function’s path on our legacy TS object to run, as well as a function to use instead if we were running in the modern-only codebase. This function defaulted to a no-op, which meant that if the underlying legacy code wasn’t present, modern code that tried to call it would have no effect — and produce no errors.

With both of these mechanisms in place, we were able to kick off our modernization effort in earnest. Legacy code could access new code as it got modernized, and new code could access old code **until** it got modernized. As you’d expect, over time there were fewer and fewer usages of old code adapted for use from the modern codebase, trending toward zero as we got ready for release.

## Putting it all together

This new version of Slack has been a long time coming, and it features the contributions of dozens of people who have been working through the last two years to roll it out seamlessly to customers. The key to its success is the incremental release strategy that we adopted early on in the project: as code was modernized and features were rebuilt, we released them to our customers. The first “modern” piece of the Slack app was our emoji picker, which we released more than two years ago — followed thereafter by the channel sidebar, message pane, and dozens of other features.

Had we waited until the entirety of Slack was rewritten before releasing it, our users would have had a worse day-to-day experience with emoji, messages, channel lists, search, and countless other features before we could release a “big bang” replacement. Releasing incrementally allowed us to deliver real value to our customers as soon as possible, helped us stay focused on continuous improvement, and de-risked the release of the new client by minimizing how much completely new code was being used by our customers for the first time.

Conventional wisdom states that rewrites are best avoided, but sometimes the benefits are too great to ignore. One of our primary metrics has been memory usage, and the new version of Slack delivers:

![**Memory usage comparison.** New client on the right.](https://cdn-images-1.medium.com/max/5544/1*d_U8PJR0MA5q8CYddSc18A.png)

These results have validated all of the work that we’ve put into this new version of Slack, and we look forward to continuing to iterate and make it even better as time goes on.

When guided by strategic planning, tempered by judicious releases, and buoyed by talented contributors, incremental rewrites are a great way to right the wrongs of the past, build yourself a brand new ship, and make your users’ working lives simpler, more pleasant, and more productive.

## Stay tuned

We are eager to share more about what we’ve learned during this process. In the coming weeks we’ll be writing more at [https://slack.engineering](https://slack.engineering) about:

* **Slack Kit**, our UI component library
* **“Speedy Boots”**, the prototype that launched this effort
* **Accessibility**, baked in rather than bolted on
* **Gantry**, our app launching framework
* and **rolling out a new client** **architecture** at scale

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
