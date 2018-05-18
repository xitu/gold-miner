> * 原文地址：[The most uncommon HTML5 tags you can use right now](https://codeburst.io/the-most-uncommon-html5-tags-52273fabc0a7)
> * 原文作者：[Pedro M. S. Duarte](https://codeburst.io/@pedromsduarte?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-most-uncommon-html5-tags.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-most-uncommon-html5-tags.md)
> * 译者：
> * 校对者：

# The most uncommon HTML5 tags you can use right now

## <!DOCTYPE html> it was published in October 2014 by the World Wide Web Consortium (W3C) to improve the language with support for the latest multimedia, while keeping it both easily readable by humans and consistently understood by computers and devices such as web browsers, parsers, etc.

![](https://cdn-images-1.medium.com/max/800/1*V91sgvnersFg5tXuhjVl8A.png)

[http://www.geekchamp.com](http://www.geekchamp.com/html5-tutorials/introduction)

I’m pretty sure that you all are using HTML5 based files, using the most known tags as, `<header>`, `<section>`, `<article>` and `<footer>`, among others, but there are a couple of those missing in order to correctly use the semantics of this language.

I’m listing here the most important ones that will help you to develop and follow the semantic of HTML5.

#### <details>

The tag `<details>` specifies additional details that the user can view or hide on demand. Use it to create an interactive widget that the user can open and close. Semantically you can use any type of content inside it and should not be visible unless the open attribute is set.

`<details open><p>Credit card required at time of booking.</p></details>`

#### <dialog>

`<dialog>` defines a dialog box element or window.

`<dialog open><p>Welcome do our hotel.</p></dialog>`

#### <mark>

The `<mark>` tag defines marked text, to highlight parts of your text.

`<p>Credit card required at time of **<mark>**booking.</mark></p>`

#### <summary>

The `<summary>` tag defines a visible heading for the `<details>` element. The heading can be clicked to view/hide the details.

`<details><summary>Payment conditions</summary><p>Credit card required at time of booking.</p></details>`

#### <time> and <datetime>

The `<time>` tag defines a human-readable date/time. This element can also be used to encode dates and times in a machine-readable way so that user agents can offer to add birthday reminders or scheduled events to the user’s calendar, and search engines can produce smarter search results.

`<p>Breakfast buffet starts at<time>7.00 AM</time>at the restaurant.</p>`

`<p>Concert at the lobby in<time datetime="2018-06-20T19:00">June 20th 7.00 PM</time></p>`

#### <small>

The specification for the `<small>` tag explains that this tag should be used to lower the importance of text or information. Browsers interpret this by making the font smaller so it has less visible impact.

`<p>Cancelations must be canceled up to 48h, <small>to avoid penalty of one night per room.</small></p>`

#### <datalist>

You can now use the `<datalist>` element to define the list of valid choices for your various `<input>` tags. This component is slightly different on various browsers, but the common way it works is by showing a small drop-down arrow to the right of the field indicating that this field has options. Check codepen [here](https://codepen.io/pedromsduarte/pen/GxdNaB).

`<datalist><option value="Master Card"><option value="Visa"><option value="American Express"></datalist>`

#### <progress>

The HTML `<progress>` element displays an indicator showing the completion progress of a task, typically displayed as a progress bar.

`<progress value="70" max="100">70 %</progress>`


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
