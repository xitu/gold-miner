> * 原文地址：[A Guide To CSS Support In Browsers](https://www.smashingmagazine.com/2019/02/css-browser-support/)
> * 原文作者：[Rachel Andrew](https://www.smashingmagazine.com/author/rachel-andrew)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-guide-to-css-support-in-browsers.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-guide-to-css-support-in-browsers.md)
> * 译者：
> * 校对者：

# A Guide To CSS Support In Browsers

Quick summary: It can be frustrating when you want to use a feature and discover that it is not supported or behaves differently across browsers. In this article, Rachel Andrew details the different types of browser support issues, and shows how CSS is evolving to make it easier to deal with them.

We will never live in a world where everyone viewing our sites has an identical browser and browser version, just as we will never live in a world where everyone has the same size screen and resolution. This means that dealing with old browsers — or browsers which do not support something that we want to use — is part of the job of a web developer. That said, things are far better now than in the past, and in this article, I’m going to have a look at the different types of browser support issues we might run into. I’m going to show you some ways to deal with them, and also look at things which might be coming soon which can help.

### Why Do We Have These Differences?

Even in a world where the majority of browsers are Chromium-based, those browsers are not all running the same version of Chromium as Google Chrome. This means that a Chromium-based browser such as Vivaldi, might be a few versions behind Google Chrome.

And, of course, users do not always quickly update their browsers, although that situation has improved in recent years with most browsers silently upgrading themselves.

There is also the manner in which new features get into browsers in the first place. It is not the case that new features for CSS are designed by the CSS Working Group, and a complete spec handed down to browser vendors with an instruction to implement it. Quite often it is only when an experimental implementation happens, that all the finer details of the specification can be worked out. Therefore, **feature development is an iterative process** and requires that browsers implement these specifications in development. While implementation happens these days most often behind a flag in the browser or available only in a Nightly or preview version, once a browser has a complete feature, it is likely to switch it on for everyone even if no other browser yet has support.

All this means that — as much as we might like it — we will never exist in a world where features are magically available on every desktop and phone simultaneously. If you are a professional web developer then your job is to deal with that fact.

### Bugs vs. Lack Of Support

There are three issues that we face with regard to browser support:

1. [No Support Of A Feature](#no-support-of-feature): The first issue (and easiest to deal with) is when a browser does not support the feature at all.

2. [Dealing With Browser “Bugs”](#dealing-with-browser-bugs): The second is when the browser claims to support the feature, but does so in a way that is different to the way that other browsers support the feature. Such an issue is what we tend to refer to as a “browser bug” because the end result is inconsistent behavior.

3. [Partial Support Of CSS Properties](#partial-support-css-properties): This one is becoming more common; a situation in which a browser supports a feature — but only in one context.

It’s helpful to understand what you are dealing with when you see a difference between browsers, so let’s have a look at each of these issues in turn.

### 1. No Support Of A Feature

If you use a CSS property or value that a browser does not understand, the browser will ignore it. This is the same whether you use a feature that is unsupported, or make up a feature and try to use it. If the browser does not understand that line of CSS, it just skips it and gets on with the next thing it does understand.

This design principle of CSS means that you can cheerfully use new features, in the knowledge that nothing bad will happen to a browser that doesn’t have support. For some CSS, used purely as an enhancement, that is all you need to do. Use the feature, make sure that when that feature is not available the experience is still good, and that’s it. This approach is the basic idea behind progressive enhancement, using this feature of the platform which enables the safe use of new things in browsers which don’t understand them.

_If you want to check whether a feature you are using is supported by browsers then you can look at the [Can I Use](https://caniuse.com/) website. Another good place to look for fine-grained support information is the page for each CSS property on [MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference). The browser support data there tends to be very detailed._

#### New CSS Understands Old CSS

As new CSS features are developed, care is taken in terms of how they interact with existing CSS. For example, in the Grid and Flexbox specification, it is detailed in terms of how `display: grid` and `display: flex` deal with scenarios such as when a floated item becomes a grid item, or a multicol container is turned into a grid. This means that certain behaviors are ignored, helping you to simply overwrite the CSS for the nonsupporting browser. These overrides are detailed in the page for [Progressive enhancement and Grid Layout on MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Grid_Layout/CSS_Grid_and_Progressive_Enhancement).

#### Detecting Support With Feature Queries

The above method only works if the CSS you need to use does not need other properties to go along with it. You might need to add additional properties to your CSS for older browsers which would then also be interpreted by the browsers which support the feature too.

A good example of this can be found when using Grid Layout. While a floated item which becomes a grid item loses all float behavior, it is likely that if you are trying to create a fallback for a grid layout with float, you will have added percentage widths and possibly margins to the items.

```
.grid > .item {
    width: 23%;
    margin: 0 1%;
}
```

[![A four column layout](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/22e70228-0261-4038-9dff-0bb32828f08c/feature-queries1.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/22e70228-0261-4038-9dff-0bb32828f08c/feature-queries1.png) 

Using floats we can create a four column layout, widths and margins need to be set in `%`. ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/22e70228-0261-4038-9dff-0bb32828f08c/feature-queries1.png))

These widths and margins will then still apply when the floated item is a grid item. The width becomes a percentage of the grid track rather than the full width of the container; any margin will then be applied as well as a gap you may have specified.

```
.grid > .item {
    width: 23%;
    margin: 0 1%;
}

.grid {
    display: grid;
    grid-template-columns: 1fr 1fr 1fr 1fr;
    column-gap: 1%;
}
```

[![A four column layout with squished columns](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/11787bcb-ac53-41ba-8390-7eb1a6b8ac79/feature-queries2.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/11787bcb-ac53-41ba-8390-7eb1a6b8ac79/feature-queries2.png) 

The width is now a percentage of the grid track — not the container. ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/11787bcb-ac53-41ba-8390-7eb1a6b8ac79/feature-queries2.png))

Thankfully, there is a feature built into CSS and implemented into modern browsers which helps us deal with this situation. Feature Queries allow us to directly ask the browser what they support and then act on the response. Just like a Media Query — which tests for some properties of the device or screen — Feature Queries test for support of a CSS property and value.

##### Test For Support

Testing for support is the simplest case, we use `@supports` and then test for a CSS property and value. The content inside the Feature Query will only run if the browser responds with true, i.e. it does support the feature.

##### Test For No Support

You can ask the browser if it does not support a feature. In this case, the code inside the Feature Query will only run if the browser indicates it has no support.

```
@supports not (display: grid) {
    .item {
        /* CSS from browsers which do not support grid layout */
    }
}
```

##### Test For Multiple Things

If you need more than one property to be supported, use `and`.

```
@supports (display: grid) and (shape-outside: circle()){
    .item {
        /* CSS from browsers which support grid and CSS shapes */
    }
}
```

If you need support of one property or another, use `or`.

```
@supports (display: grid) or (display: flex){
    .item {
        /* CSS from browsers which support grid or flexbox */
    }
}
```

##### Picking A Property And Value To Test For

You don’t need to test for every property you want to use — just something which would indicate support for the features you are planning to use. Therefore, if you want to use Grid Layout, you might test for `display: grid`. In the future (and once [subgrid support](https://www.smashingmagazine.com/2018/07/css-grid-2/) lands in browsers), you might need to be more specific and test for subgrid functionality. In that case, you would test for `grid-template-columns: subgrid` to get a true response from only those browsers which had implemented subgrid support.

If we now return to our floated fallback example, we can see how feature queries will sort it out for us. What we need to do is to query the browser to find out if it supports grid layout. If it does, we can set the width on the item back to `auto` and the margin to `0`.

```
.grid > .item {
    width: 23%;
    margin: 0 1%;
}

@supports(display: grid) {
    .grid {
        display: grid;
        grid-template-columns: 1fr 1fr 1fr 1fr;
        column-gap: 1%;
    }

    .grid > .item {
        width: auto;
        margin: 0;
    }
}
```

See the Pen [Feature Queries and Grid](https://codepen.io/smashing-magazine/pen/daNaaV/) by ([Rachel Andrew](https://codepen.io/huijing/pen/daNaaV)) on [CodePen](https://codepen.io).

Note that while I have included all of the grid code inside my feature query, I don’t need to. If a browser didn’t understand the grid properties it would ignore them so they could safely be outside of the feature query. The things that must be inside a feature query in this example are the margin and width properties, as these are needed for the old browser code but would also be applied by supporting browsers.

#### Embrace The Cascade

A very simple way to offer fallbacks is to utilize the fact that browsers ignore CSS that they don’t understand, and the fact that where everything else has equal specificity, source order is taken into account in terms of which CSS is applied to an element.

You first write your CSS for browsers which do not support the feature. Then test for support of property you want to use, if the browser confirms it has support overwrite the fallback code with your new code.

This is pretty much the same procedure that you might use when using media queries for responsive design, following a mobile-first approach. In that approach, you start with your layout for smaller screens, then add or overwrite things for larger ones as you move up through your breakpoints.

[Can I Use CSS Feature Queries?](http://caniuse.com/#feat=css-featurequeries) Data on support for CSS Feature Queries across the major browsers from caniuse.com.

The above way of working means that you do not need to worry about browsers which do not support Feature Queries. As you can see from _Can I Use_, Feature Queries have really great support. The standout browsers that do not support them being any version of Internet Explorer.

It is likely, however, that the new feature you want to use is also not supported in IE. So, at the present time you will almost always start by writing CSS for browsers without support, then you test with a Feature Query. This Feature Query should test _for_ support.

1.  Browsers which support Feature Queries will return true if they have support and so the code inside the query will be used, overwriting the code for older browsers.
2.  If the browser supports Feature Queries but not the feature being tested, it will return false. The code inside the feature query will be ignored.
3.  If the browser does not support Feature Queries then everything inside the Feature Query block will be ignored, which means that a browser such as IE11 will use your old browser code, which is very likely exactly what you want!

### 2. Dealing With Browser “Bugs”

The second browser support issue is thankfully becoming less common. If you read “[What We Wished For](https://www.smashingmagazine.com/2018/12/internet-explorer-what-we-wished-for/)” (published at the end of last year), you can get a little tour into some of the more baffling browser bugs of the past. That said, any software is liable to have bugs, browsers are no exception. And, if we add to that the fact that due to the circular nature of specification implementation, sometimes a browser implemented something and then the spec changed so they now need to issue an update. Until that update ships, we might be in a situation where browsers do something different to each other.

Feature Queries can’t help us if the browser reports support of something supports it badly. There is no mode by which the browser can say, “_Yes, but you probably won’t like it_.” When an actual interoperability bug shows up, it is in these situations where you might need to be a little more creative.

If you think you are seeing a bug then the first thing to do is confirm that. Sometimes when we think we see buggy behavior, and browsers doing different things, the fault lies with us. Perhaps we have used some invalid syntax, or are trying to style malformed HTML. In those cases, the browser will try to do something; however, because you aren’t using the languages as they were designed, each browser might cope in a different way. A quick check that your HTML and CSS is valid is an excellent first step.

At that point, I’d probably do a quick search and see if my issue was already widely understood. There are some repos of known issues, e.g. [Flexbugs](https://github.com/philipwalton/flexbugs) and [Gridbugs](https://github.com/rachelandrew/gridbugs). However, even just a well-chosen few keywords can turn up Stack Overflow posts or articles that cover the subject and may hand you a workaround.

But let’s say you don’t really know what is causing the bug, which makes it pretty hard to search for a solution. So, the next step is to create a reduced test case of your issue, i.e. stripping out anything irrelevant to help you identify exactly what triggers the bug. If you think you have a CSS bug, can you remove any JavaScript, or recreate the same styling outside of a framework? I often use CodePen to pop together a reduced test case of something I am seeing; this has the added advantage of giving me the code in a way I can easily share with someone else if I need to ask about it.

Most of the time, once you have isolated the issue, it is possible to think up an alternate way of achieving your desired result. You will find that someone else has come up with a cunning workaround, or you can post somewhere to ask for suggestions.

With that said, if you think you have a browser bug and can’t find anyone else talking about the same issue, it is quite possible you have found something new that should be reported. With all of the new CSS that has landed recently, issues can sometimes show up as people start to use things in combination with other parts of CSS.

_Check out this post from Lea Verou about reporting such issues, “[Help The Community! Report Browser Bugs!](https://www.smashingmagazine.com/2011/09/help-the-community-report-browser-bugs/)”. The article also has great tips for creating a reduced test case._

### 3. Partial Support Of CSS Properties

The third type of issue has become more common due to the way that modern CSS specifications are designed. If we think about Grid Layout and Flexbox, these specs both use the properties and values in Box Alignment Level 3, to do alignment. Therefore, properties such as `align-items`, `justify-content`, and `column-gap` are specified to be used in both Grid and Flexbox as well as other layout methods.

At the time of writing, however, the `gap` properties work in Grid Layout in all grid-supporting browsers, and `column-gap` works in Multicol; however, only Firefox has implemented these properties for Flexbox.

If I were to use margins to create a fallback for Flexbox, then test for `column-gap` and remove the margins, my boxes will have no space between them in browsers which support `column-gap` in Grid or multicol, so my fallback spacing will be removed.

```
@supports(column-gap: 20px) {
    .flex {
        margin: 0; /* almost everything supports column-gap so this will always remove the margins, even if we do not have gap support in flexbox. */
    }
}
```

This is a current limitation of Feature Queries. We don’t have a way to test for support of a feature in another feature. In the above situation, what I want to ask the browser is, “Do you have support for column-gap in Flexbox?” This way, I can get a negative response so I can use my fallback.

There is a similar issue with the CSS fragmentation properties `break-before`, `break-after`, and `break-inside`. As these have better support when the page is printed, browsers will often claim support. However, if you are testing for support in multicol, you get what appear to be false positives. [I’ve raised an issue over at the CSS Working Group for this issue](https://github.com/w3c/csswg-drafts/issues/3559), however, it isn’t a straightforward problem to solve. If you have thoughts, please do add them there.

### Testing For Selector Support

Currently, Feature Queries can only test for CSS Properties and Values. Another thing we might like to test for is the support of newer selectors, such as those in Level 4 of the Selectors specification. There is [an explainer note](https://github.com/dbaron/css-supports-functions/blob/master/explainer.md) and also an implementation behind a flag in Firefox Nightly of a new feature for Feature Queries which will achieve this.

If you visit `about:config` in Firefox and enable the flag `layout.css.supports-selector.enabled` then you can test to see if various selectors are supported. The syntax is currently very straightforward, for example to test for the `:has` selector:

```
@supports selector(:has){
  .item {
      /* CSS for support of :has */
  }
}
```

This is a specification in development, however, you can see how features to help us manage the ever-present issues of browser support are being added as we speak.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
