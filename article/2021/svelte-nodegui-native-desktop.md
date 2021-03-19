> * 原文地址：[New Svelte NodeGui Allows Creating Native Desktop Applications with Qt and Svelte](https://www.infoq.com/news/2021/03/svelte-nodegui-native-desktop/)
> * 原文作者：[Bruno Couriol](https://www.infoq.com/profile/Bruno-Couriol/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/svelte-nodegui-native-desktop.md](https://github.com/xitu/gold-miner/blob/master/article/2021/svelte-nodegui-native-desktop.md)
> * 译者：
> * 校对者：

# New Svelte NodeGui Allows Creating Native Desktop Applications with Qt and Svelte

[Jamie Birch](https://twitter.com/LinguaBrowse) recently [announced Svelte NodeGui](https://twitter.com/LinguaBrowse/status/1367929896685756422), a framework for developing desktop applications on Windows, Linux, and MacOS. A lighter alternative to Electron, Svelte NodeGui lets developers write their applications with the [Svelte front-end framework and compiler](https://svelte.dev/), the [Qt widget toolkit](https://www.qt.io/), and a subset of HTML and CSS.

Svelte NodeGui documentation presented the rationale and benefits behind the new framework as follows:

> Svelte NodeGui is a Svelte renderer for [NodeGui](https://nodegui.org/), which is an efficient JavaScript binding to a cross-platform graphical user interface (GUI) library `Qt`. Qt is one of the most mature and efficient libraries for building desktop applications. This enabled Svelte NodeGui to be extremely memory and CPU efficient as compared to other popular Javascript Desktop GUI solutions. A *hello world* app built with Svelte NodeGui runs on less than 20Mb of memory.

Some developers have reported the size of a basic *hello world* Electron application to be [as high as 115 MB](https://medium.com/gowombat/how-to-reduce-the-size-of-an-electron-app-installer-a2bc88a37732) or [275 MB](https://stackoverflow.com/questions/59731319/how-can-i-reduce-my-275mb-hello-world-electron-package-size). Svelte NodeGui manages to compile smaller executables with a better memory consumption by not shipping the Chromium web browser together with the web application.

Conversely, Svelte NodeGui applications cannot leverage browser APIs nor the full extent of HTML and CSS. A Svelte NodeGui app is a Node.js app whose user interface is made of Qt widgets (e.g., [`QMainWindow`](https://doc.qt.io/qt-5/qmainwindow.html), [`QCheckBox`](https://doc.qt.io/qt-5/qcheckbox.html)) that can be styled with the subset of CSS supported by [Qt’s stylesheet syntax](https://doc.qt.io/qt-5/stylesheet-syntax.html) and are laid out with [Flexbox](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Flexbox) — a web browser’s one-dimensional layout method. Qt widgets’ surface area may be lower than that of [HTML native elements](https://www.htmlquick.com/reference/tags.html), which effectively limits developers to using a Qt-supported subset of HTML. Svelte NodeGui ships with 13 tags or UI components, including buttons, image tags, editable text areas, progress bars, or native OS windows.

Qt widgets may emit events (called Signals), which can be listened to and programmatically associated with event handlers. NodeGui also provides a set of internal events that the application can listen to ([`QEvents`](https://svelte.nodegui.org/docs/guides/handle-events#event-handling)). Svelte NodeGui’s documentation provides the [following example that illustrates the layout mechanism and event syntax](https://svelte.nodegui.org/docs/guides/handle-events#how-do-i-know-which-events-are-supported-):

```jsx
<script lang="ts">
  import { onMount } from "svelte";
  import { Direction } from "@nodegui/nodegui";
  import type { QPushButtonSignals } from "@nodegui/nodegui";

  let additionalButtons: string[] = [];
  let direction: Direction = Direction.LeftToRight;

  function addHandler(): void {
    additionalButtons = [...additionalButtons, `Button ${additionalButtons.length}`];
  }
  function removeHandler(): void {
    additionalButtons = [...additionalButtons.slice(0, additionalButtons.length - 1)];
  }
  function toggleDirection(): void {
    direction = ((direction + 1) % 4) as Direction;
  }

  onMount(() => {
    (window as any).win = win; // Prevent garbage collection.
    win.nativeView.show();
    return () => {
      delete (window as any).win;
    };
  });
</script>

<window bind:this={win}>
  <boxView direction={direction}>
    <button text="Add" on={addHandler} />
    <button text="Remove" on={removeHandler} />
    <button text="Toggle direction" on={toggleDirection} />
    {#each additionalButtons as additionalButton (additionalButton)}
      <button text={additionalButton}/>
    {/each}
  </boxView>
</window>
```

As the previous code sample shows, the regular [Svelte single-file component syntax](https://svelte.dev/tutorial/basics) is used to describe the application logic. Svelte’s `onMount` lifecycle hook is used to display the native application window. The window’s content is encapsulated within the `window` tag and consists of four buttons that are laid out in a given direction that the user can toggle by clicking on a button. On each toggle, the user interface of the resulting desktop application will oscillate between the two following layouts:

![box layout example 1](https://github.com/nodegui/react-nodegui/raw/gh-pages/img/box-layout-1.png)![box layout example 1](https://github.com/nodegui/react-nodegui/raw/gh-pages/img/box-layout-2.png)  
(source: [documentation](https://svelte.nodegui.org/docs/guides/layout#boxview-layout))

While developers cannot use the fetch browser API, they can pick from the large existing set of Node.js packages (e.g., [Node Fetch](https://github.com/node-fetch/node-fetch)). [Native Node.js modules may also be installed](https://svelte.nodegui.org/docs/guides/using-native-node-modules) and used. Developers can [debug their Svelte NodeGui applications](https://svelte.nodegui.org/docs/guides/debugging) with the [Chromium Developer Tools](https://nodejs.org/en/docs/inspector/), as they would a Node.js application.

The release generated an animated discussion on HackerNews. One user [welcomed the new option for desktop applications](https://news.ycombinator.com/item?id=26361924) while signaling remaining work:

> Looks really good! At first glance, this seems like probably the best Electron alternative I’ve seen posted on HN.
>
> Apart from the consistent GUI layer, I think an underrated reason that many teams stick with Electron is the mature tooling for cross-platform builds and upgrades. It’s pretty painful to DIY.
>
> It looks like NodeGUI doesn’t currently support cross-compilation–is that something that’s on the roadmap? How about upgrade/auto-upgrade tooling? Code signing?

[react-electron-boilerplate](https://electron-react-boilerplate.js.org/), [neutralino](https://neutralino.js.org/), and [tauri](https://tauri.studio/en/) are additional options for the development of lightweight desktop applications with web technologies. Google recently [released Flutter 2](https://www.infoq.com/news/2021/03/flutter-2-released/), a cross-platform UI Toolkit that strives to support developers writing applications for mobile, web, and desktop platforms from a single codebase. One HackerNews reader additionally [mentioned Sciter.js](https://news.ycombinator.com/item?id=26364927) that provides a JavaScript interface to [Sciter](https://sciter.com/), an embeddable HTML/CSS/script engine:

> Same demo in VanilaJS and Sciter.JS : [https://github.com/c-smile/sciter-js-sdk](https://github.com/c-smile/sciter-js-sdk) (see screenshots there).
>
> Binary is ~5MB, and that is HTML/CSS + QuickJS + NodeJS runtime.
>
> Versus 50MB+ of NodeGUI that is Node.JS + QT.
>
> And SvelteJS works in Sciter.JS out of the box too.

Qt is [dual-licensed under commercial and open-source licenses](https://www.qt.io/licensing/). The creator of the [parent NodeGui project](https://docs.nodegui.org/) emphasized the [impact of licensing on software distribution](https://twitter.com/a7ulr/status/1225498258233053184?s=21):

> You can use Qt for commercial apps for free as well as long as you follow LGPL license requirements. For desktop apps, it is relatively easier to do. We need to make sure that you are dynamically linking to Qt libraries + extra license and credit info. More [here](https://www.youtube.com/watch?v=bwTlCBbB3RY).

[Svelte NodeGui](https://github.com/nodegui/svelte-nodegui) is an open-source project distributed under the MIT license.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
