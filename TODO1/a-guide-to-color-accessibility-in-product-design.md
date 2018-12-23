> * 原文地址：[A guide to color accessibility in product design](https://medium.com/inside-design/a-guide-to-color-accessibility-in-product-design-516e734c160c)
> * 原文作者：[InVision](https://medium.com/@InVisionApp?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-guide-to-color-accessibility-in-product-design.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-guide-to-color-accessibility-in-product-design.md)
> * 译者：
> * 校对者：

# A guide to color accessibility in product design

## There’s a lot of talk about accessible design, but have you ever thought about color accessibility?

Recently, a client brought in a project with very specific, complex implementations of an accessible color system. This opened my eyes not only to how important this subject is, but also how much there is to learn.

![](https://cdn-images-1.medium.com/max/800/1*U3GwUaniqzo5nZYd2LkaUA.png)

This story is by [Justin Reyna](https://twitter.com/justinreyreyna)

Let’s learn how to go color accessible using the design principles you already know.

### Why’s accessibility so important?

[Accessibility](https://invisionapp.com/inside-design/accessibility-for-developers/) in digital product design is the practice of crafting experiences for all people, including those of us with visual, speech, auditory, physical, or cognitive disabilities. As designers, developers, and general tech people, we have the power to create a web we’re all proud of: an inclusive web made for and consumable by all people.

Also, not creating accessible products is just rude, so don’t be rude.

[Color accessibility](https://invisionapp.com/inside-design/guide-web-content-accessibility/) enables people with visual impairments or color vision deficiencies to interact with digital experiences in the same way as their non-visually-impaired counterparts. In 2017, [The World Health Organization](http://www.who.int/en/news-room/fact-sheets/detail/blindness-and-visual-impairment) estimated that roughly 217 million people live with some form of moderate to severe vision impairment. That statistic alone is reason enough to design for accessibility.

> _“Not creating accessible products is just rude, so don’t be rude.”_

Apart from accessibility being an ethical best practice, there are also potential legal implications for not complying with regulatory requirements around accessibility. In 2017, plaintiffs filed at least [814 federal lawsuits](https://www.adatitleiii.com/2018/01/2017-website-accessibility-lawsuit-recap-a-tough-year-for-businesses/) about allegedly inaccessible websites, including a number of class actions. Various organizations have sought to establish accessibility standards, most notably the United States Access Board (Section 508) and the World Wide Web Consortium (W3C). Here’s an overview of these standards:

*   **Section 508:** 508 compliance refers to Section 508 of the Rehabilitation Act of 1973. You can read the in-depth ordinance [here](https://www.section508.gov/manage/laws-and-policies), but to summarize, Section 508 requires that your site needs to be accessible if you are a federal agency or create sites on behalf of a federal agency (like contractors).
*   **W3C:** The World Wide Web Consortium (W3C) is an international, voluntary community that was established in 1994 and develops open standards for the web. The W3C outlines their guidelines for web accessibility within [WCAG 2.1](https://www.w3.org/TR/WCAG21/), which is essentially the gold standard for web accessibility best practices.

### Ensuring your product is color-accessible

Accounting for accessibility early on in a product’s life cycle is best — it reduces the time and money you’ll spend to make your products accessible retroactively. Color accessibility requires a little up-front work when selecting your product’s color palette, but ensuring your colors are accessible will pay dividends down the road.

Here are some quick tips to ensure you’re creating color-accessible products.

#### Add enough contrast

To meet [W3C’s minimum AA rating](https://www.w3.org/TR/UNDERSTANDING-WCAG20/visual-audio-contrast-contrast.html), your background-to-text contrast ratio should be at least 4.5:1. So, when designing things like buttons, cards, or navigation elements, be sure to check the contrast ratio of your color combinations.

![](https://cdn-images-1.medium.com/max/800/1*PZXhnoxM0Sza0AJWp8G1BA.png)

There are lots of tools to help you test the accessibility of color combinations, but the ones I’ve found most helpful are [Colorable](https://colorable.jxnblk.com/ffffff/6b757b) and [Colorsafe](http://colorsafe.co/). I like Colorable because it has sliders that allow you to adjust Hue, Saturation, and Brightness in real time to see how it affects the accessibility rating of a particular color combination.

#### Don’t rely solely on color

You can also ensure accessibility by making sure you don’t rely on color to relay crucial system information. So, for things like error states, success states, or system warnings, be sure to incorporate messaging or iconography that clearly calls out what’s going on.

![](https://cdn-images-1.medium.com/max/800/1*gmsRDSNDAzUqs-SG-D5P4Q.png)

Also, when displaying things like graphs or charts, giving users the option to add texture or patterns ensures that those who are colorblind can distinguish between them without having to worry about color affecting their perception of the data. [Trello](https://www.trello.com/) does a great job of this with their [Colorblind-Friendly Mode](https://twitter.com/trello/status/543420024166174721?lang=en).

![](https://cdn-images-1.medium.com/max/800/1*D6PDBf8Y7YNof6Fkh9X5gQ.png)

### Focus state contrast

Focus states help people to navigate your site with a keyboard by giving them a visual indicator around elements. They’re helpful for people with visual impairments, people with motor disabilities, and people who just like to navigate with a keyboard.

All browsers have a default focus state color, but if you plan on overriding that within your product, it’s crucial to ensure you’re providing enough color contrast. This ensures those with visual impairments or color deficiencies can navigate with focus states.

#### Document and socialize color system

Lastly, the most important aspect of creating an accessible color system is giving your team the ability to reference it when needed, so everyone is clear about proper usage. This not only reduces confusion and churn, but also ensures that accessibility is always a priority for your team. In my experience, explicitly calling out the accessibility rating of a specific color combination within a UI Kit or Design System is most effective, especially when socializing that across the team with a tool (like [InVision Craft](https://www.invisionapp.com/craft) or [InVision DSM](https://support.invisionapp.com/hc/en-us/articles/115005685166-Introduction-to-Design-System-Manager)). Here’s an example of how to document background to text color combinations and the accessibility rating of each combination.

![](https://cdn-images-1.medium.com/max/800/1*N_9UOR4mnJyxJq4Cg071LQ.png)

### Let’s get accessible

These are just a few tips to make your product more accessible, but keep in mind, these only relate to color accessibility. To understand accessibility guidelines in detail, I recommend familiarizing yourself with [WCAG 2.1](https://www.w3.org/TR/WCAG21/). While these guidelines can be a bit daunting, there are _tons_ of resources out there to help you along the way, and when in doubt, don’t hesitate to reach out to designers in your area (or via the internet) for help.

**Originally published at [_invisionapp.com_](https://www.invisionapp.com/inside-design/color-accessibility-product-design).**

*   [Accessibility](https://medium.com/tag/accessibility?source=post)
*   [UX Design](https://medium.com/tag/ux-design?source=post)
*   [Desig](https://medium.com/tag/design?source=post)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
> * 原文地址：[A guide to color accessibility in product design](https://medium.com/inside-design/a-guide-to-color-accessibility-in-product-design-516e734c160c)
> * 原文作者：[InVision](https://medium.com/@InVisionApp?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-guide-to-color-accessibility-in-product-design.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-guide-to-color-accessibility-in-product-design.md)
> * 译者：
> * 校对者：

# A guide to color accessibility in product design

## There’s a lot of talk about accessible design, but have you ever thought about color accessibility?

Recently, a client brought in a project with very specific, complex implementations of an accessible color system. This opened my eyes not only to how important this subject is, but also how much there is to learn.

![](https://cdn-images-1.medium.com/max/800/1*U3GwUaniqzo5nZYd2LkaUA.png)

This story is by [Justin Reyna](https://twitter.com/justinreyreyna)

Let’s learn how to go color accessible using the design principles you already know.

### Why’s accessibility so important?

[Accessibility](https://invisionapp.com/inside-design/accessibility-for-developers/) in digital product design is the practice of crafting experiences for all people, including those of us with visual, speech, auditory, physical, or cognitive disabilities. As designers, developers, and general tech people, we have the power to create a web we’re all proud of: an inclusive web made for and consumable by all people.

Also, not creating accessible products is just rude, so don’t be rude.

[Color accessibility](https://invisionapp.com/inside-design/guide-web-content-accessibility/) enables people with visual impairments or color vision deficiencies to interact with digital experiences in the same way as their non-visually-impaired counterparts. In 2017, [The World Health Organization](http://www.who.int/en/news-room/fact-sheets/detail/blindness-and-visual-impairment) estimated that roughly 217 million people live with some form of moderate to severe vision impairment. That statistic alone is reason enough to design for accessibility.

> _“Not creating accessible products is just rude, so don’t be rude.”_

Apart from accessibility being an ethical best practice, there are also potential legal implications for not complying with regulatory requirements around accessibility. In 2017, plaintiffs filed at least [814 federal lawsuits](https://www.adatitleiii.com/2018/01/2017-website-accessibility-lawsuit-recap-a-tough-year-for-businesses/) about allegedly inaccessible websites, including a number of class actions. Various organizations have sought to establish accessibility standards, most notably the United States Access Board (Section 508) and the World Wide Web Consortium (W3C). Here’s an overview of these standards:

*   **Section 508:** 508 compliance refers to Section 508 of the Rehabilitation Act of 1973. You can read the in-depth ordinance [here](https://www.section508.gov/manage/laws-and-policies), but to summarize, Section 508 requires that your site needs to be accessible if you are a federal agency or create sites on behalf of a federal agency (like contractors).
*   **W3C:** The World Wide Web Consortium (W3C) is an international, voluntary community that was established in 1994 and develops open standards for the web. The W3C outlines their guidelines for web accessibility within [WCAG 2.1](https://www.w3.org/TR/WCAG21/), which is essentially the gold standard for web accessibility best practices.

### Ensuring your product is color-accessible

Accounting for accessibility early on in a product’s life cycle is best — it reduces the time and money you’ll spend to make your products accessible retroactively. Color accessibility requires a little up-front work when selecting your product’s color palette, but ensuring your colors are accessible will pay dividends down the road.

Here are some quick tips to ensure you’re creating color-accessible products.

#### Add enough contrast

To meet [W3C’s minimum AA rating](https://www.w3.org/TR/UNDERSTANDING-WCAG20/visual-audio-contrast-contrast.html), your background-to-text contrast ratio should be at least 4.5:1. So, when designing things like buttons, cards, or navigation elements, be sure to check the contrast ratio of your color combinations.

![](https://cdn-images-1.medium.com/max/800/1*PZXhnoxM0Sza0AJWp8G1BA.png)

There are lots of tools to help you test the accessibility of color combinations, but the ones I’ve found most helpful are [Colorable](https://colorable.jxnblk.com/ffffff/6b757b) and [Colorsafe](http://colorsafe.co/). I like Colorable because it has sliders that allow you to adjust Hue, Saturation, and Brightness in real time to see how it affects the accessibility rating of a particular color combination.

#### Don’t rely solely on color

You can also ensure accessibility by making sure you don’t rely on color to relay crucial system information. So, for things like error states, success states, or system warnings, be sure to incorporate messaging or iconography that clearly calls out what’s going on.

![](https://cdn-images-1.medium.com/max/800/1*gmsRDSNDAzUqs-SG-D5P4Q.png)

Also, when displaying things like graphs or charts, giving users the option to add texture or patterns ensures that those who are colorblind can distinguish between them without having to worry about color affecting their perception of the data. [Trello](https://www.trello.com/) does a great job of this with their [Colorblind-Friendly Mode](https://twitter.com/trello/status/543420024166174721?lang=en).

![](https://cdn-images-1.medium.com/max/800/1*D6PDBf8Y7YNof6Fkh9X5gQ.png)

### Focus state contrast

Focus states help people to navigate your site with a keyboard by giving them a visual indicator around elements. They’re helpful for people with visual impairments, people with motor disabilities, and people who just like to navigate with a keyboard.

All browsers have a default focus state color, but if you plan on overriding that within your product, it’s crucial to ensure you’re providing enough color contrast. This ensures those with visual impairments or color deficiencies can navigate with focus states.

#### Document and socialize color system

Lastly, the most important aspect of creating an accessible color system is giving your team the ability to reference it when needed, so everyone is clear about proper usage. This not only reduces confusion and churn, but also ensures that accessibility is always a priority for your team. In my experience, explicitly calling out the accessibility rating of a specific color combination within a UI Kit or Design System is most effective, especially when socializing that across the team with a tool (like [InVision Craft](https://www.invisionapp.com/craft) or [InVision DSM](https://support.invisionapp.com/hc/en-us/articles/115005685166-Introduction-to-Design-System-Manager)). Here’s an example of how to document background to text color combinations and the accessibility rating of each combination.

![](https://cdn-images-1.medium.com/max/800/1*N_9UOR4mnJyxJq4Cg071LQ.png)

### Let’s get accessible

These are just a few tips to make your product more accessible, but keep in mind, these only relate to color accessibility. To understand accessibility guidelines in detail, I recommend familiarizing yourself with [WCAG 2.1](https://www.w3.org/TR/WCAG21/). While these guidelines can be a bit daunting, there are _tons_ of resources out there to help you along the way, and when in doubt, don’t hesitate to reach out to designers in your area (or via the internet) for help.

**Originally published at [_invisionapp.com_](https://www.invisionapp.com/inside-design/color-accessibility-product-design).**

*   [Accessibility](https://medium.com/tag/accessibility?source=post)
*   [UX Design](https://medium.com/tag/ux-design?source=post)
*   [Desig](https://medium.com/tag/design?source=post)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
