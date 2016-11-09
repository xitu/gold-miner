> * 原文地址：[Tools for Developing Accessible Websites](https://bitsofco.de/tools-for-developing-accessible-websites/)
* 原文作者：[ Ire Aderinokun,](https://bitsofco.de/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Tools for Developing Accessible Websites




Building websites that are accessible can be challenging for developers like myself that have never had to use any assistive technologies. Unlike visual issues such as layout which can be easily seen, accessibility issues can very easily go unnoticed if we don't have the correct tools to test for them.

> Accessibility doesn't have to be perfect, it just needs to be a little bit better than yesterday.
> 
>   
> [Leonie Watson at FronteersConf](https://twitter.com/ireaderinokun/status/784401867447078912)

There are a few tools I use regularly for this purpose that greatly help, so I thought I would share them. Because I do the vast majority of my development in Chrome, this list is biased to tools for Chrome in particular.

[Accessibility Developer Tools](https://chrome.google.com/webstore/detail/accessibility-developer-t/fpkknkljclfencbdbgkenhalefipecmb?hl=en) is an extension for Google Chrome created by the Google Accessibility team. The extension adds an extra panel in the developer tools drawer called "Audits". In this panel, we can run Audits on the page related to Network Utilization, Web Page Performance, and of course Accessibility.

![Screenshot of Panel](https://bitsofco.de/content/images/2016/10/Screen-Shot-2016-10-30-at-16.26.42.png)

The Accessibility Audit will test the web page against a pre-defined list of accessibility checks. It will list, in order of importance, any critical issues that need to be fixed, as well as the tests that were passed by the page.

![Accessibility Audit Results](https://bitsofco.de/content/images/2016/10/Screen-Shot-2016-10-30-at-16.27.51.png)

In addition to the Accessibility Audit, we can inspect any particular element’s accessibility properties in the element inspector. There is a new panel added to the element inspector called "Accessibility Properties", which will list any properties relevant to the particular element.

![Accessibility Properties Inspector](https://bitsofco.de/content/images/2016/10/Screen-Shot-2016-10-30-at-16.29.14.png)

## Accessibility Inspector

As part of an internal Chrome experiment, an [Accessibility Inspector](https://docs.google.com/document/d/1bj9Dc3_DnezF-IeNg51LEG2zfGtxD3YKP5t7SBB_-Dk/edit) has been available in the Chrome Developer Tools (hidden [behind a flag](https://gist.github.com/marcysutton/0a42f815878c159517a55e6652e3b23a)).

The Accessibility Inspector is an extra panel in the element inspector, called "Accessibility". This allows us to inspect particular elements on the page and receive information on it's accessibility properties. Unlike the Accessibility Developer Tools extension, this tool is able to offer us much more in-depth information about an element's accessibility properties due to greater access to the Accessibility API.

![Screenshot](https://bitsofco.de/content/images/2016/10/Screen-Shot-2016-10-30-at-16.31.03.png)

## Tenon

[Tenon](https://tenon.io/) is an extremely useful tool that can identify [WCAG 2.0](https://www.w3.org/TR/WCAG20/) and [Section 508](https://www.section508.gov/) issues in any environment, from local development to production. It is actually an API you pay to have access to, which can be integrated in your development workflow, giving in-depth accessibility analyses every step of the development.

Additionally, there is also a free online tool that will produce an accessibility report on any web page or even snippet of code.

![](https://bitsofco.de/content/images/2016/10/Screen-Shot-2016-10-30-at-16.32.25.png)

## Chrome Vox

Ensuring a website works well on screen readers can be a bit of a guessing game for developers that don't already use screen readers. [Chrome Vox](https://chrome.google.com/webstore/detail/chromevox/kgejglhpjiefppelpmljglcjbhoiplfn) is a simple and easy-to-use screen reader for Google Chrome that can be installed as an extension. Once enabled, it will allow you to navigate any web page through it.

Here's a demo of me using it to navigate the homepage of this blog -

[![Using Chrome Vox Screen Reader](http://bitsofco.de/content/images/2016/10/Screen-Shot-2016-10-31-at-20.25.50.png)](https://www.youtube.com/watch?v=N1c6CfUhdwo) 

Even though not all screen readers work in the same way, Chrome Vox is a simple one to get started and experience what it is like to use a screen reader.

## High Contrast (Extension)

[High Contrast](https://chrome.google.com/webstore/detail/high-contrast/djcfdncoelnlbldjfhinnjlhdjlikmph?hl=en) is an extension for Google Chrome that allows you to change the colour schemes of any page to a high contrast one. Viewing a website through one of these filters can be helpful when making colour choices.

![](https://bitsofco.de/content/images/2016/10/Oct-30-2016-16-34-30.gif)

## Your Keyboard

Finally, one of the simplest and most useful ways to test a website is to try navigating it with only a keyboard, no pointing device.



