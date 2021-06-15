> * 原文地址：[What's New In DevTools (Chrome 92)](https://developer.chrome.com/blog/new-in-devtools-92/)
> * 原文作者：[Jecelyn Yeen](https://jec.fyi/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/new-in-devtools-92.md](https://github.com/xitu/gold-miner/blob/master/article/2021/new-in-devtools-92.md)
> * 译者：
> * 校对者：

![](https://developer-chrome-com.imgix.net/image/dPDCek3EhZgLQPGtEG3y0fTn4v82/XtJztwxzQqOWhOHrKmhM.jpg?auto=format)

# What's New In DevTools (Chrome 92)

## CSS grid editor 

A highly requested feature. You can now preview and author CSS Grid with the new CSS Grid editor!

![CSS Grid editor](https://developer-chrome-com.imgix.net/image/dPDCek3EhZgLQPGtEG3y0fTn4v82/mV9Ac7QAD8vVPoiqmii6.png?auto=format)

When an HTML element on your page has `display: grid` or `display: inline-grid` applied to it, you can see an icon appear next to it in the Styles pane. Click the icon to toggle the CSS grid editor. Here you can preview the potential changes with the on screen icons (e.g. `justify-content: space-around`) and author the grid appearance with just one click.

Chromium issue: [1203241](https://crbug.com/1203241)

## Support for `const` redeclarations in the Console 

The Console now supports redeclaration of `const` statement, in addition to the existing [`let` and `class` redeclarations](/blog/new-in-devtools-80/#redeclarations). The inability to redeclare was a common annoyance for web developers who use the Console to experiment with new JavaScript code.

This allows developers to copy-paste code into the DevTools console to see how it works or experiment, make small changes to the code, and repeat the process without refreshing the page. Previously, DevTools threw a syntax error if the code redeclared a `const` binding.

Refer to the example below. `const` redeclaration is supported **across separate REPL scripts** (refer to variable `a`). Take note that the following scenarios are not supported by design:

* `const` redeclaration of page scripts is not allowed in REPL scripts
* `const` redeclaration within the same REPL script is not allowed (refer to variable `b`)

![const redeclarations](https://developer-chrome-com.imgix.net/image/dPDCek3EhZgLQPGtEG3y0fTn4v82/tJCPlokvxw6OWyCAmocM.png?auto=format)

Chromium issue: [1076427](https://crbug.com/1076427)

## Source order viewer 

You can now view the order of source elements on screen for better accessibility inspection.

![Source order viewer](https://developer-chrome-com.imgix.net/image/dPDCek3EhZgLQPGtEG3y0fTn4v82/2QoBtjGjFxgDAkKaO3y2.png?auto=format)

The order of content in an HTML document is important for search engine optimization and accessibility. The newer CSS features allow developers to create content that looks very different in its on-screen order than what is in the HTML document. This is a big accessibility problem as screen reader users would get a different, most likely confusing experience than sighted users.

Chromium issue: [1094406](https://crbug.com/1094406)

## New shortcut to view frame details 

View iframe details by right clicking on the iframe element in the Elements panel, and select **Show frame details**.

![Show frame details](https://developer-chrome-com.imgix.net/image/dPDCek3EhZgLQPGtEG3y0fTn4v82/YdENg6wjsgPNyMODdOHC.png?auto=format)

This takes you to a view of the iframe's details in the Application panel where you can examine document details, security & isolation status, permissions policy, and more to debug potential issues.

![Frame details view](https://developer-chrome-com.imgix.net/image/dPDCek3EhZgLQPGtEG3y0fTn4v82/YdENg6wjsgPNyMODdOHC.png?auto=format)

Chromium issue: [1192084](https://crbug.com/1192084)

## Enhanced CORS debugging support 

Cross-origin resource sharing (CORS) errors are now surfaced in the Issues tab. There are various reasons causing CORS errors. Click to expand each issue to understand the potential causes and solutions.

![CORS issues in the Issues tab](https://developer-chrome-com.imgix.net/image/dPDCek3EhZgLQPGtEG3y0fTn4v82/UpiZQCNnlENB8ZluzeFt.png?auto=format)

Chromium issue: [1141824](https://crbug.com/1141824)

## Network panel updates 

### Rename XHR label to Fetch/XHR 

The XHR label is now renamed to **Fetch/XHR**. This change makes it clearer that this filter includes both [`XMLHttpRequest`](https://xhr.spec.whatwg.org/) and [Fetch API](https://fetch.spec.whatwg.org/) network requests.

![Fetch/XHR label](https://developer-chrome-com.imgix.net/image/dPDCek3EhZgLQPGtEG3y0fTn4v82/I0QOVTO52JRpl0jJO6Zt.png?auto=format)

Chromium issue: [1201398](https://crbug.com/1201398)

### Filter Wasm resource type in the Network panel 

You can now click on the new **Wasm** button to filter the Wasm network requests.

![Filter by Wasm](https://developer-chrome-com.imgix.net/image/dPDCek3EhZgLQPGtEG3y0fTn4v82/vuTMcfCjDWFfVtDN6Dpf.png?auto=format)

Chromium issue: [1103638](https://crbug.com/1103638)

### User-Agent Client Hints for devices in the Network conditions tab 

[User-Agent Client Hints](https://web.dev/user-agent-client-hints) are now applied for devices in the **User agent** field under **Network conditions** tab.

User-Agent Client Hints are a new expansion to the Client Hints API, that enables developers to access information about a user's browser in a privacy-preserving and ergonomic way.

![User-Agent Client Hints for devices in the Network conditions tab](https://developer-chrome-com.imgix.net/image/dPDCek3EhZgLQPGtEG3y0fTn4v82/iMlkTtV9OUdfujSWdHnR.png?auto=format)

Chromium issue: [1174299](https://crbug.com/1174299)

## Report Quirks mode issues in the Issues tab 

DevTools now reports [Quirks Mode](https://quirks.spec.whatwg.org/) and [Limited-quirks Mode](https://dom.spec.whatwg.org/#concept-document-limited-quirks) issues.

Quirks Mode and Limited-quirks Mode are legacy browser modes from before the web standards were made. These modes emulate pre-standard-era layout behaviors that often cause unexpected visual effects.

When debugging layout issues, developers might think they are caused by user-authored CSS or HTML bugs, while the real problem is the Compat Mode the page is in. DevTools provides suggestions for fixing it.

![Report Quirks mode issues in the Issues tab](https://developer-chrome-com.imgix.net/image/dPDCek3EhZgLQPGtEG3y0fTn4v82/XqtqSZPa1S1YnmeIt0ee.png?auto=format)

Chromium issue: [622660](https://crbug.com/622660)

## Include Compute Intersections in the Performance panel 

DevTools now show the **Compute Intersections** in the flame chart. These changes help you to identify the [intersection observers](https://web.dev/intersectionobserver-v2/) events and debug on its potential performance overheads.

![Compute Intersections in the Performance panel](https://developer-chrome-com.imgix.net/image/dPDCek3EhZgLQPGtEG3y0fTn4v82/Nx3K0Lpst0lICGbtpzsW.png?auto=format)

Chromium issue: [1199137](https://crbug.com/1199137)

## Lighthouse 7.5 in the Lighthouse panel 

The Lighthouse panel is now running Lighthouse 7.5. The "missing explicit width and height" warning is now removed for images with `aspect-ratio` defined in CSS. Previously, Lighthouse showed warnings for images without width and height defined.

Check out the [release notes](https://github.com/GoogleChrome/lighthouse/releases/tag/v7.5.0) for a full list of changes.

Chromium issue: [772558](https://crbug.com/772558)

## Deprecated "Restart frame" context menu in the call stack 

The **Restart frame** option is now deprecated. This feature requires further development to work well, it is currently broken and often crashes.

![Deprecated Restart frame context menu](https://developer-chrome-com.imgix.net/image/dPDCek3EhZgLQPGtEG3y0fTn4v82/Alvnt4FkoEFoP0SkdKgi.png?auto=format)

Chromium issue: [1203606](https://crbug.com/1203606)

## \[Experimental\] Protocol monitor 

To enable the experiment, check the **Protocol Monitor** checkbox under **Settings** \> **Experiments**.

Chrome DevTools uses the [Chrome DevTools Protocol (CDP)](https://chromedevtools.github.io/devtools-protocol/) to instrument, inspect, debug and profile Chrome browsers. The **Protocol monitor** provides you a way to view all the CDP requests and responses made by DevTools.

Two new functions added to facilitate the testing of CDP:

The new **Save** button allows you to download the recorded messages as a JSON file A new field that allows you to send a raw CDP command directly

![Protocol monitor](https://developer-chrome-com.imgix.net/image/dPDCek3EhZgLQPGtEG3y0fTn4v82/mRVrHC9WEet7cwA7QAeV.png?auto=format)

Chromium issues: [1204004](https://crbug.com/1204004), [1204466](https://crbug.com/1204466)

## \[Experimental\] Puppeteer Recorder 

To enable the experiment, check the **Recorder** checkbox under **Settings** \> **Experiments**.

The [Puppeteer recorder](/blog/new-in-devtools-89/#record) now generates a list of steps based on your interaction with the browser, whereas previously DevTools generated a Puppeteer script directly instead. A new **Export** button is added to allow you export the steps as a Puppeteer script.

After recording the steps, you can use the new **Replay** button to replay the steps. Follow the [instructions here](/blog/new-in-devtools-89/#record) to learn how to get started with recording.

Please note that this is an early-stage experiment. We plan to improve and expand the Recorder functionality over time.

![Puppeteer Recorder](https://developer-chrome-com.imgix.net/image/dPDCek3EhZgLQPGtEG3y0fTn4v82/kh1Z4jcWxbO6rYCSoIPn.png?auto=format)

Chromium issue: [1199787](https://crbug.com/1199787)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
