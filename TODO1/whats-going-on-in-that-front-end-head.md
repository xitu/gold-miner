> * 原文地址：[What’s going on in that front end head?](https://medium.com/front-end-weekly/whats-going-on-in-that-front-end-head-dd443f3fb7d5)
> * 原文作者：[Andreea Macoveiciuc](https://medium.com/@andreea.macoveiciuc)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/whats-going-on-in-that-front-end-head.md](https://github.com/xitu/gold-miner/blob/master/TODO1/whats-going-on-in-that-front-end-head.md)
> * 译者：
> * 校对者：

# What’s going on in that front end head (\<head\>)?

> Must-have tags that FEs should include even if SEOs and marketers don’t ask for them.

![Photo by [Natasha Connell](https://unsplash.com/@natcon773?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/8064/1*lgPqPdewofN-QeUyeocZ8w.jpeg)

While preparing a SEO workshop for stakeholders, I was going through some tags that I assumed we already included in our \<head>. To my surprise, quite some were missing, probably because nobody ever asked for them.

So if you’re a front-ender trying to make friends with marketers and SEOs, or a PO trying to find some quick-wins for improving the search performance of your platform, make sure the tags and attributes below aren’t missing from your code.

## Document language

```html
<html lang=”en”>…</html>
```

The lang attribute is ignored by Google, but is used by Bing and also by screen readers, so it is an important attribute for accessibility and ranking. Well it’s actually not ignored by Google, because it does help in recognizing the document language and providing translation services. But it’s just not important for SEO.

Typically the attribute is included in the \<head>, but can also be used on other tags such as quotes or paragraphs, if the language (the **actual** language) of those elements changes.

For example:

```html
<blockquote lang="fr" cite="URL">Some french quote here</blockquote>
```

## Hreflang tag

If Google is ignoring the lang attribute when looking at the different languages of a document, what does it use? The hreflang tag!

```html
<link rel="alternate" href="https://masterPageURL" hreflang="en-us" />
<link rel="alternate" href="https://DEVersionURL-" hreflang="de-de" />
```

What’s happening in those tags?

The first one tells Google that the language used on that page is English, more specifically for US users.

The second line tells Google that if there are users browsing from Germany, that version of the page — **with the hreflang=”de-de” attribute** — should be served.

The hreflang attribute can be added in the \<head>, as shown, or in the sitemap. This tag is useful if you have content in multiple languages and want to decrease the risk for Spanish users to get Dutch content and so on.

However, note that the lang and the hreflang attributes are both s**ignals**, not directives. This means that SE can still display the “wrong” version of the page.

## Canonical tag

Canonicals are probably the most annoying and confusing of all tags, so here’s the simplest explanation possible, so that you understand what they do, once and for all.

The canonical tag looks like this:

```html
<link rel="canonical" href="https://masterPageURL" />
```

What does it do? It tells the search engines that the URL that’s added in the href attribute is the master page, or the most relevant from a set of duplicate pages.

In a webshop for example, it’s extremely common to have dynamic URLs where the product variations are formed by adding parameters like ?category=… or session IDs.

When this happens, you need to tell Google which of those variants is the master page that should be indexed. You do that by adding the canonical tag and pointing it to the master URL.

Please note that **all the duplicate pages** need to include this tag and to point to the master page.

## Robots meta tags

This is different than the robots.txt file. It’s a tag that looks like this:

```html
<meta name="robots" content="noindex, nofollow" />
```

What does it do? This tag tells search engine bots how to crawl a page — to index or not to index, to follow or not to follow.

Unlike the lang tags and the robots.txt file, the robots meta tag is a **directive**, so it provide strict instructions for the bots.

Possible values are as follows:

* noindex: Tells the SE to not index the page.
* index: Tells the SE to index the page. This is the default value, so you can skip it if you want the page to be indexed anyway.
* nofollow: Tells the crawler to not follow any links from that page and to not pass any link equity.
* follow: Tells the crawlers to follow the links on the page and pass link equity (“juice”). This happens even if the page isn’t indexed.

## Social meta tags: OG

OG stands for Open Graph Protocol and it’s a technology that allows you to control what data is shown when a page is shared in social media. Here’s how the tags look like:

```html
<meta property="og:title" content="The title" />
<meta property="og:type" content="website" />
<meta property="og:url" content="http://page.com" />
<meta property="og:image" content="img.jpg" />
```

The four tags above are mandatory, but you can add many others — you can check the list [here](https://ogp.me/).

If these are missing, you’ll probably hear some complaints sooner or later, as whenever a colleague will share a page in social, the image will be chosen randomly unless specified in the og:image tag.

## Meta title & meta description tags

In all honesty, I don’t think it’s even possible for these to be missing, but just in case, click right & inspect.

These two meta tags are essential, as they tell search engines and social platforms what the page is about, and they are displayed in the snippets in SERPs. Also, the title appears in the browser tab and shows the page name when bookmarked.

Here’s how these tags look like:

```html
<title>This is the page title<title />
<meta name="description" content="This is the meta description, meaning the text that's displayed in SERP snippets." />
```

Now, you may be aware that an old answer from Google, dating back in 2009, said that meta description tags don’t add SEO value. Even so, they are — along with the meta title and page URL — the elements most likely to convince users to click on your snippet. So with or without SEO value, they’re definitely important.

## Responsive design meta tag

This tag isn’t actually called like this, the official name is “viewport” and it looks like this:

```html
<meta name="viewport" content="width=device-width, initial-scale=1" />
```

Adding this to the \<head> of the document ensures that the page is responsive and it behaves correctly on mobile and tablet. As you may know, Google scans and indexes mobile versions of websites first, in an attempt to make the web more mobile-friendly.

While this tag isn’t technically turning your website into a mobile version, it is considered by search engines if no mobile-first design is found. So when the m.site.com is missing, Google will scan the web version and ideally it should find the viewport tag. Pages that aren’t mobile-friendly and responsive are ranked lower.

## Favicon tag

This will make your colleagues happy, as it enables browsers to display a beautiful icon or logo in the tab, next to the site’s name. The tag for adding the favicon looks like this:

```html
<link rel="icon" href="favicon-img.ico" type="image/x-icon" />
```

The image is saved in .ico format, which is better supported than .png and .gif for this purpose.

P.S. As a content-everything turned front end developer, I’m in the middle of this tag war. Shall I keep quiet? :)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
