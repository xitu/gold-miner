> * 原文地址：[Tools for Developing Accessible Websites](https://bitsofco.de/tools-for-developing-accessible-websites/)
* 原文作者：[ Ire Aderinokun,](https://bitsofco.de/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[王子建](https://github.com/Romeo0906)
* 校对者：

# Tools for Developing Accessible Websites

# 无障碍网站开发工具




Building websites that are accessible can be challenging for developers like myself that have never had to use any assistive technologies. Unlike visual issues such as layout which can be easily seen, accessibility issues can very easily go unnoticed if we don't have the correct tools to test for them.

构建一个无障碍网站对于像我这样从没用过任何辅助性技术的开发人员来说非常的具有挑战性。可及性问题不像布局等可视问题一样那么容易被发现，如果我们没有用合适的工具测试，它很容易就会被忽视掉。

> Accessibility doesn't have to be perfect, it just needs to be a little bit better than yesterday.
> 
>   
> [Leonie Watson at FronteersConf](https://twitter.com/ireaderinokun/status/784401867447078912)

> 可及性设计并不是一定要做得完美无缺，它只需日渐精进就够了。
> 
>   
> [Leonie Watson at FronteersConf](https://twitter.com/ireaderinokun/status/784401867447078912)

There are a few tools I use regularly for this purpose that greatly help, so I thought I would share them. Because I do the vast majority of my development in Chrome, this list is biased to tools for Chrome in particular.

有一些我经常使用并且对可及性开发大有裨益的工具，我想应该和大家一起分享。由于我大部分都是在做 Chrome 开发，所以这些工具尤其适用于 Chrome。

[Accessibility Developer Tools](https://chrome.google.com/webstore/detail/accessibility-developer-t/fpkknkljclfencbdbgkenhalefipecmb?hl=en) is an extension for Google Chrome created by the Google Accessibility team. The extension adds an extra panel in the developer tools drawer called "Audits". In this panel, we can run Audits on the page related to Network Utilization, Web Page Performance, and of course Accessibility.

[Accessibility Developer Tools](https://chrome.google.com/webstore/detail/accessibility-developer-t/fpkknkljclfencbdbgkenhalefipecmb?hl=en) 是一款由谷歌可访问性团队开发的谷歌 Chrome 浏览器的扩展。这款扩展在开发者工具界面添加了一个名为“Audits”的嵌板，通过 Audits 我们能得到网页的网络利用率、网页性能，当然也包括可及性。

![Screenshot of Panel](https://bitsofco.de/content/images/2016/10/Screen-Shot-2016-10-30-at-16.26.42.png)

The Accessibility Audit will test the web page against a pre-defined list of accessibility checks. It will list, in order of importance, any critical issues that need to be fixed, as well as the tests that were passed by the page.

这款可及性检测工具会按照预定的可及性检查项对网页进行测试。它将会按照重要性列出任何需要修复的关键问题，同时也会列出已经通过测试的项目。

![Accessibility Audit Results](https://bitsofco.de/content/images/2016/10/Screen-Shot-2016-10-30-at-16.27.51.png)

In addition to the Accessibility Audit, we can inspect any particular element’s accessibility properties in the element inspector. There is a new panel added to the element inspector called "Accessibility Properties", which will list any properties relevant to the particular element.


除了可及性检测之外，我们能在元素审查中审查任何特定元素的可及性属性。在元素审查项中有一个新的名为“Accessibility Properties”的嵌板，它能够列出某特定元素的所有可及性相关的属性。


![Accessibility Properties Inspector](https://bitsofco.de/content/images/2016/10/Screen-Shot-2016-10-30-at-16.29.14.png)

## Accessibility Inspector

As part of an internal Chrome experiment, an [Accessibility Inspector](https://docs.google.com/document/d/1bj9Dc3_DnezF-IeNg51LEG2zfGtxD3YKP5t7SBB_-Dk/edit) has been available in the Chrome Developer Tools (hidden [behind a flag](https://gist.github.com/marcysutton/0a42f815878c159517a55e6652e3b23a)).

作为 Chrome 的内测部分，一款 [Accessibility Inspector](https://docs.google.com/document/d/1bj9Dc3_DnezF-IeNg51LEG2zfGtxD3YKP5t7SBB_-Dk/edit) 已经可以在 Chrome 开发者工具中使用了（隐藏在[标记](https://gist.github.com/marcysutton/0a42f815878c159517a55e6652e3b23a)下）。

The Accessibility Inspector is an extra panel in the element inspector, called "Accessibility". This allows us to inspect particular elements on the page and receive information on it's accessibility properties. Unlike the Accessibility Developer Tools extension, this tool is able to offer us much more in-depth information about an element's accessibility properties due to greater access to the Accessibility API.

这款可及性审查工具是元素检测中附加的嵌板，名为“Accessibility”。这款工具让我们能够审查页面中的特定元素，并获取其可及性属性的信息。与可及性开发者工具扩展不同的是，这款工具有更大的访问可及性 API 的权限，它可以提供给更加深入的元素可及性信息。

![Screenshot](https://bitsofco.de/content/images/2016/10/Screen-Shot-2016-10-30-at-16.31.03.png)

## Tenon

[Tenon](https://tenon.io/) is an extremely useful tool that can identify [WCAG 2.0](https://www.w3.org/TR/WCAG20/) and [Section 508](https://www.section508.gov/) issues in any environment, from local development to production. It is actually an API you pay to have access to, which can be integrated in your development workflow, giving in-depth accessibility analyses every step of the development.

[Tenon](https://tenon.io/) 是一款极其有用的工具，它能在任何环境下鉴别 [WCAG 2.0](https://www.w3.org/TR/WCAG20/) 和 [Section 508](https://www.section508.gov/) 的问题，无论是本地开发环境还是生产环境。实际上它是一款付费的 API，也可以被整合到你的开发工作中，并且能提供每一步开发进展的深入的可及性分析。

Additionally, there is also a free online tool that will produce an accessibility report on any web page or even snippet of code.

另外，也有在线的免费工具，能够生成任何页面甚至一小段代码的可及性报告。

![](https://bitsofco.de/content/images/2016/10/Screen-Shot-2016-10-30-at-16.32.25.png)

## Chrome Vox

Ensuring a website works well on screen readers can be a bit of a guessing game for developers that don't already use screen readers. [Chrome Vox](https://chrome.google.com/webstore/detail/chromevox/kgejglhpjiefppelpmljglcjbhoiplfn) is a simple and easy-to-use screen reader for Google Chrome that can be installed as an extension. Once enabled, it will allow you to navigate any web page through it.

对于还没有使用电子阅读器的开发者来说，确保网站能够适应电子阅读器有点像猜谜游戏。[Chrome Vox](https://chrome.google.com/webstore/detail/chromevox/kgejglhpjiefppelpmljglcjbhoiplfn) 就是一款可以用于 Chrome 扩展安装的简单易用的电子阅读器。安装成功之后，你可以通过它操控任何页面。

Here's a demo of me using it to navigate the homepage of this blog -

以下是我利用 Chrome Vox 做的一个导航至博客主页的样例 -

[![Using Chrome Vox Screen Reader](http://bitsofco.de/content/images/2016/10/Screen-Shot-2016-10-31-at-20.25.50.png)](https://www.youtube.com/watch?v=N1c6CfUhdwo) 

Even though not all screen readers work in the same way, Chrome Vox is a simple one to get started and experience what it is like to use a screen reader.

即便电子阅读器五花八门，Chrome Vox 也是一款能够简易上手并模拟体验电子阅读器的工具。

## High Contrast (扩展)

[High Contrast](https://chrome.google.com/webstore/detail/high-contrast/djcfdncoelnlbldjfhinnjlhdjlikmph?hl=en) is an extension for Google Chrome that allows you to change the colour schemes of any page to a high contrast one. Viewing a website through one of these filters can be helpful when making colour choices.

[High Contrast](https://chrome.google.com/webstore/detail/high-contrast/djcfdncoelnlbldjfhinnjlhdjlikmph?hl=en) 是谷歌 Chrome 浏览器的一个扩展插件，它能够提高页面调色方案的对比度，通过此类工具来查看页面能够在配色的选择上助我们一臂之力。

![](https://bitsofco.de/content/images/2016/10/Oct-30-2016-16-34-30.gif)

## Your Keyboard

Finally, one of the simplest and most useful ways to test a website is to try navigating it with only a keyboard, no pointing device.

最后，最简单也最有效的一个测试方法，试着只用键盘不用任何点击设备来操作网站。
