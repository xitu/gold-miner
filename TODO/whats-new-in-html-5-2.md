> * 原文地址：[What’s New in HTML 5.2?](https://bitsofco.de/whats-new-in-html-5-2/)
> * 原文作者：[bitsofco](https://bitsofco.de/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/whats-new-in-html-5-2.md](https://github.com/xitu/gold-miner/blob/master/TODO/whats-new-in-html-5-2.md)
> * 译者：
> * 校对者：

# What’s New in HTML 5.2?

Less than a month ago, HTML 5.2 became an official W3C Recommendation (REC). When a specification reaches the REC stage, this means that it has received the official endorsement of W3C Members and the Director, and that the W3C officially recommends it’s deployment by user agents, and it’s implementation by web page authors.

By the REC stage, [anything new should have had at least 2 independent implementations](https://www.slideshare.net/rachelandrew/where-does-css-come-from/27?src=clipshare). This makes it a great time for us, as web page developers, to begin implementation of any new feature.

In HTML 5.2, there were a number of additions and removals, all of which can be seen on the official [HTML 5.2 Changes](https://www.w3.org/TR/html52/changes.html#changes) page. In this article, I’ll go over some of the changes I think will impact my development the most.

## New Features

### A native `<dialog>` element

Of all the changes in HTML 5.2, I’m the most excited about the introduction of the [`<dialog>` element](https://www.w3.org/TR/html52/interactive-elements.html#elementdef-dialog), a native dialog box. Dialogs are incredibly prevalent on the web, yet every implementation is different in some way. Dialogs are also really difficult to do in a way that is accessible, resulting in most dialogs on the web being practically unusable for users who don’t navigate the web visually.

The new `<dialog>` element aims to change this, providing a simple way to include a modal dialog without having to worry about many of the pitfalls. I will write a separate, detailed article about how this element works, but here are the basics.

The dialog is created using a `<dialog>` element:

```
<dialog>  
  <h2>Dialog Title</h2>
  <p>Dialog content and other stuff will go here</p>
</dialog>  
```

By default, the dialog is hidden from view (and from DOM access) unless the `open` attribute is applied.

```
<dialog open>  
```

The `open` attribute can be toggled by calling the `show()` and `close()` methods, which is available to any `HTMLDialogElement`.

```
<button id="open">Open Dialog</button>  
<button id="close">Close Dialog</button>

<dialog id="dialog">  
  <h2>Dialog Title</h2>
  <p>Dialog content and other stuff will go here</p>
</dialog>

<script>  
const dialog = document.getElementById("dialog");

document.getElementById("open").addEventListener("click", () => {  
  dialog.show();
});

document.getElementById("close").addEventListener("click", () => {  
  dialog.close();
});
</script>  
```

The `<dialog>` element already has support in Chrome, and is behind a flag in Firefox.

[![Data on support for the dialog feature across the major browsers from caniuse.com](https://bitsofco.de/content/images/2018/01/caniuse-dialog.png)](http://caniuse.com/#feat=dialog) 

### Using the Payment Request API from iFrames

The [Payment Request API](https://www.w3.org/TR/payment-request/) is a native alternative to checkout forms. It aims to provide a standardised and consistent method of making payments on the web for users, by moving the handling of retrieving payment information to the browser, instead of individual checkout forms on each website.

Before HTML 5.2, these payment requests couldn’t be made from iframes embedded in a document. This made it essentially impossible for third-party embedded payment solutions (e.g. Stripe, Paystack), to take advantage of this API, since their payment interface is typically handled within an iframe.

HTML 5.2 introduced the `allowpaymentrequest` attribute which, when applied to an iframe, will allow it to use the Payment Request API while the user is on the hosting web page.

```
<iframe allowpaymentrequest>  
```

### Sizes for Apple Icons

To define web page icons, we use the `<link rel="icon">` element in the head of our document. To define different sizes of icons, we use the `sizes` attribute.

```
<link rel="icon" sizes="16x16" href="path/to/icon16.png">  
<link rel="icon" sizes="32x32" href="path/to/icon32.png">  
```

This attribute, although purely advisory, allows user agents to decide which size of icon to use if multiple sizes are available, particularly since most devices have their own different "optimal" icon size.

Before HTML 5.2, the `sizes` attribute was only valid if the link relationship was `icon`. However, Apple’s iOS devices do not support the `sizes` attribute. To get around this, Apple introduced a device-specific relationship, `appple-touch-icon` , which could be used to define the icon used on their devices.

In HTML 5.2, the specification now allows the `sizes` attribute to be used if the relationship is `apple-touch-icon`, no longer _only_ `icon`. This will allow us to provide different sizes of icons for different apple devices. Although, as far as I currently know, Apple devices still do not support the `sizes` attribute, this change will be useful for the future when they eventually do.

## Newly Valid Practices

In addition to new features, HTML 5.2 has validated some practices in writing HTML that were previously invalid.

### Multiple `<main>` elements

The `<main>` element represents the main content of a web page. While content that is repeated across multiple pages can be placed in headers, sections, or any other element, the `<main>` element is reserved for the content that is specific and unique to the particular page. Consequently, before HTML 5.2, the `<main>` element had to be unique within the DOM for the page to be valid.

With the prevalence of Single Page Applications, however, sticking to this rule could be difficult. There may be cases in which there are multiple `<main>` elements in the DOM, but only one being shown to the user at any given time.

With HTML 5.2, we can now have multiple `<main>` elements in our markup, as long as only one is visible to the user at any given time. Any extra elements must be hidden using the `hidden` attribute.

```
<main>...</main>  
<main hidden>...</main>  
<main hidden>...</main>  
```

As we know, there are [several ways to hide an element with CSS](https://bitsofco.de/hiding-elements-with-css/). However, any extra `<main>` elements must be hidden using the `hidden` attribute. Any other method for hiding the element, e.g. `display: none;` or `visibility: hidden;` will not be valid.

### Styles in the `<body>`

Typically, inline CSS defined using the `<style>` element is placed within the `<head>` of the HTML document. With the increase in component-ized development, developers have seen the benefit in writing and placing styles along with the html element they are relevant for.

In HTML 5.2, defining an inline `<style>` block anywhere within the `<body>` of an HTML document is now valid. This means that we can have styles closer to where they are used.

```
<body>  
    <p>I’m cornflowerblue!</p>
    <style>
        p { color: cornflowerblue; }
    </style>
    <p>I’m cornflowerblue!</p>
</body>  
```

However, it is still noted that **styles should preferably be placed in the `<head>`, for performance reasons**. According the the [specification](https://www.w3.org/TR/html52/document-metadata.html#elementdef-style),

> A style element should preferably be used in the head of the document. The use of style in the body of the document may cause restyling, trigger layout and/or cause repainting, and hence, should be used with care.

It should also be noted that, as shown in the example, the styles are not scoped. An inline style defined later in the HTML document will still apply to elements defined before it, which is why it may trigger repainting.

### Headings in a `<legend>`

In forms, the `<legend>` element represents a caption for the form fields within a `<fieldset>`. Before HTML 5.2, the content of a legend had to be plain text. Now, we can include heading elements.

```
<fieldset>  
    <legend><h2>Basic Information</h2></legend>
    <!-- Form fields for basic information -->
</fieldset>  
<fieldset>  
    <legend><h2>Contact Information</h2></legend>
    <!-- Form fields for contact information -->
</fieldset>  
```

This is really useful for when we want to use the `fieldset` element to group different sections of a form. In cases like this, it makes perfect sense to use headings, which would make these form sections more easily navigable for users relying on a document outline.

## Removed Features

In HTML 5.2, a few elements were removed, namely:

* `keygen`: Used to help generating public keys for forms
* `menu` and `menuitem`: Used to create navigation or context menus

## Newly Invalid Practices

Finally, some development practices have been made invalid.

### No inline, floated, or blocked children of `<p>`

In HTML 5.2, the only valid children of a `<p>` element should be phrasing content. This means that the following types of elements should no longer be nested within a paragraph:

* Inline blocks
* Inline tables
* Floated and positioned positioned blocks

### No Strict Doctypes

Finally, we can say goodbye to the following strict document types:

```
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">  
```

```
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">  
```


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
