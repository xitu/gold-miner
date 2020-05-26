> * 原文地址：[Schema.org: The Popular Web Standard You’ve Never Heard Of 🤫](https://levelup.gitconnected.com/schema-org-the-popular-web-standard-youve-never-heard-of-d9b7ff28a22d)
> * 原文作者：[dave.js](https://medium.com/@_davejs)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/schema-org-the-popular-web-standard-youve-never-heard-of.md](https://github.com/xitu/gold-miner/blob/master/article/2020/schema-org-the-popular-web-standard-youve-never-heard-of.md)
> * 译者：
> * 校对者：

# Schema.org: The Popular Web Standard You’ve Never Heard Of 🤫

![](https://cdn-images-1.medium.com/max/5868/1*zjJka96wmgZpOMTw5CnCIg.png)

## What is Schema.org?

Established as an open standard by Google, Microsoft, Yahoo, and Yandex, Schema.org cut its v1 release **waaaay** back in April 2013. Yes, it has really been around for **that** long. However, it continues to evolve to support how people use the web in new and unpredictable ways.

So what the heck is it? According to the [Schema.org homepage](https://schema.org/):

> **Schema.org is a collaborative, community activity with a mission to create, maintain, and promote schemas for structured data on the Internet, on web pages, in email messages, and beyond.**

In basic terms: Schema.org helps give meaning to web content. It builds on the concepts of [semantic HTML elements](https://developer.mozilla.org/en-US/docs/Glossary/Semantics#Semantics_in_HTML) and gives richer meaning to web content.

Just like semantic HTML, Schema.org helps with search engine optimization (SEO). By giving more context to your content, search engines can better parse and categorize your content, making it easier for people to find. Search engines can even use this structured data to create rich previews.

![](https://cdn-images-1.medium.com/max/2000/0*WuvNN7OKDhL59cPN.png)

In this preview for **Avengers: Endgame** on IMDb we see rating data has been added to the search result. This is because IMDb has properly tagged the content using Schema.org.

Another way to think of Schema.org is it’s like [ARIA](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA), but for SEO instead of accessibility. It doesn’t change the functionality of your website but enhances it for a specific audience (in this case, that audience is search engines).

## Adding Schema.org to HTML Content

Schema.org supports several encodings, however, the most common one used is **Microdata**, which allows us to directly tag markup with schema data via HTML attributes.

The API is quite simple. There are just three attributes:

* `itemtype`: Defines the schema of an item.
* `itemscope`: Defines the container of an item.
* `itemprop`: Defines a property on an item.

## Basic Usage

Here’s a simple example using the [Person Type](https://schema.org/Person):

```html
<div itemscope itemtype="https://schema.org/Person">
  <img
    src="/david-leger.png"
    alt="mid-twenties male with brown hair and blue eyes"
    itemprop="image"
  />
  <h1 itemprop="name">David Leger</h1>
  <p itemprop="description">
    Hey! I'm dave.js and I'm from <span itemprop="nationality">Canada</span>. I
    love writing <span itemprop="knowsAbout">JavaScript</span>,
    <span itemprop="knowsAbout">HTML</span>, and
    <span itemprop="knowsAbout">CSS</span>!
  </p>
</div>
```

The `itemscope` and `itemtype` are set on the top-level `\<div>` so that every `itemprop` within it belongs to the Person type.

The `itemtype` value is simply the URL of the documentation for the type you want to use. In order to know which `itemtype` and `itemprop` values best fit your content, you can research the Schema.org docs which have detailed descriptions and examples for how each schema type should be used.

Notice how `description` wraps two additional `itemprop`s. Regardless of the level, `itemprops`s will be associated with the closest ancestor `itemscope`. We can also define multiple instances of the same `itemprop` as shown with `knowsAbout`.

## Nested Items

What if we want to nest items within an item though? For that, we can define a new `itemscope`. Let’s expand on our Person item and add a [PostalAddress](https://schema.org/PostalAddress).

```
<div itemscope itemtype="https://schema.org/Person">
  <img
    src="/david-leger.png"
    alt="mid-twenties male with brown hair and blue eyes"
    itemprop="image"
  />
  <h1 itemprop="name">David Leger</h1>
  <p itemprop="description">...</p>
  <address
    itemprop="address"
    itemscope
    itemtype="https://schema.org/PostalAddress"
  >
    <span itemprop="streetAddress">1505 Barrington Street</span><br />
    <span itemprop="addressLocality">Halifax</span><br />
    <span itemprop="addressRegion">Nova Scotia</span>
  </address>
</div>
```

By adding `itemscope` to the `\<address>` element, we are scoping all the `itemprop`s within that tag to the PostalAddress item. The PostalAddress is linked to the Person item by using `itemprop="address"`, without which they would be interpreted as separate, unassociated items.

## Hidden Data

Sometimes we want to give context to search engines that we don’t necessarily want to display on the page. This can be achieved by using `\<meta>` tags. This might seem a bit strange since `\<meta>` tags are usually found in the `\<head>` of a web page, but [Schema.org recommends using meta tags for implicit content](https://schema.org/docs/gs.html#advanced_missing).

For the Person item, let’s add my nickname (dave.js) using a `\<meta>` tag:

```html
<div itemscope itemtype="https://schema.org/Person">
  <img
    src="/david-leger.png"
    alt="mid-twenties male with brown hair and blue eyes"
    itemprop="image"
  />
  <h1 itemprop="name">David Leger</h1>
  <p itemprop="description">...</p>
  <address
    itemprop="address"
    itemscope
    itemtype="https://schema.org/PostalAddress"
  >
    ...
  </address>
  <meta itemprop="alternateName" content="dave.js" />
</div>
```

## Testing Schema.org Items

Testing out your items is simple. Google offers a [Structured Data Testing Tool](https://search.google.com/structured-data/testing-tool) to validate your items. It parses your HTML and shows a tree of how the item attributes are interpreted. It also shows errors and warnings for missing properties that are required or recommended for each `itemtype`.

Here’s our example parsed with the Structured Data Testing Tool.

![](https://cdn-images-1.medium.com/max/2000/0*aXWVolaitY_AbKtL.png)

## A Living Standard

Schema.org is an open-source community project. Although it is supported by major companies such as Google, Microsoft, Mozilla, and more, public contributions are encouraged. Although it’s been around since 2013, Schema.org is a living standard that adapts to the needs of the web. For example, recent releases included item types such as [CovidTestingFacility](https://schema.org/CovidTestingFacility) to help with pandemic relief efforts.

To learn more about Schema.org and its usage check out the [docs](https://schema.org/docs/documents.html). There are so many schemas for countless item types and detailed documentation on how to use them.

If you’d like to contribute to Schema.org head over to the [community page](https://www.w3.org/community/schemaorg/) to see how you can help.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
