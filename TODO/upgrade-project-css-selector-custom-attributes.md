> * 原文地址：[Upgrade Your Project with CSS Selector and Custom Attributes](https://www.sitepoint.com/upgrade-project-css-selector-custom-attributes/?utm_source=SitePoint&utm_medium=email&utm_campaign=Versioning)
> * 原文作者：[Tim Harrison](https://www.sitepoint.com/author/tharrison/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/upgrade-project-css-selector-custom-attributes.md](https://github.com/xitu/gold-miner/blob/master/TODO/upgrade-project-css-selector-custom-attributes.md)
> * 译者：
> * 校对者：

# Upgrade Your Project with CSS Selector and Custom Attributes

_This article was originally published by [TestProject](https://blog.testproject.io/2017/08/10/css-selector-custom-attributes/). Thank you for supporting the partners who make SitePoint possible._

Element selectors for [Selenium WebDriver](https://blog.testproject.io/2016/11/07/selenium-webdriver-3/) are one of the core components of an [automation framework](https://blog.testproject.io/2017/03/26/test-automation-infrastructure-fundamentals/) and are the key to interaction with any web application. In this review of [automation element selectors](https://blog.testproject.io/2017/02/09/inspect-web-elements-chrome-devtools/), we will discuss the various strategies, explore their capabilities, weigh their pros and cons, and eventually recommend the [best selector strategy](https://blog.testproject.io/2017/08/10/css-selector-custom-attributes/#CustomAttributes) – custom attributes with CSS selector.

## Selenium Element Selectors

Choosing the best [element selector](https://blog.testproject.io/2017/02/09/inspect-web-elements-chrome-devtools/#ElementSelector) strategy is critical to the success and ease of maintenance of your automation effort. Therefore, when choosing your selector, you should consider aspects such as ease of use, versatility, online support, documentation and performance. Strong consideration for a proper selector strategy will pay dividends in the future through easy to maintain automation.

Just as the technological aspect of element selectors should be considered, so too should the culture of your organization. A mature culture of collaboration between developers and QA will unlock high tiers of success when implementing element selectors in your automation. This benefits the organization beyond just the automation effort by laying the foundation for collaboration in other areas of the Software Development Life Cycle.

All code examples will be in [Python](https://www.python.org/) and [Selenium WebDriver](https://blog.testproject.io/2016/11/07/selenium-webdriver-3/) commands but should be generally applicable to any programming language and framework.

### HTML Example:

I will use the following HTML snippet of a navigation menu for examples in each section:

```
<div id="main-menu">
  <div class="menu"><a href="/home">Home</a></div>
  <div class="menu"><a href="/shop">Shop</a>
    <div class="submenu">
      <a href="/shop/gizmo">Gizmo</a>
      <a href="/shop/widget">Widget</a>
      <a href="/shop/sprocket">Sprocket</a>
    </div>
  </div>
</div>
```

## Bad: Tag Name, Link Text, Partial Link Text and Name

I won’t spend too much time on these because they all have limited use. They are generally not a good option for wide adoption across the entire automation framework. They solve specific needs that can be easily covered with other element selector strategies. Only use these if you have a specific need to handle a special case. Even then, most special cases are not special enough to use these. You would use these in a scenario where there is no other selector option available to you (such as custom tags or id).

### Example:

With tag name, you can select large groups of elements that all match the tag name you provided. This has limited use because it would only work as a solution in situations where you need to select large groups of elements of the same type. The example below would return all 4 div elements in the example HTML.

```
driver.find_elements(By.TAG_NAME, "div")
```

You can select the links with these examples below. As you can see, they can only target anchor tags and only the text of those anchor tags:

```
driver.find_elements(By.LINK_TEXT, "Home")
driver.find_elements(By.PARTIAL_LINK_TEXT, "Sprock")
```

Lastly, you can select elements by the name attribute, but as you can see in the example HTML, there are no tags with a name attribute. This would be a common problem in almost any application, since adding a name attribute in every HTML attribute is not a common practice. If the main menu element had a name attribute like this:

```
<div id="main-menu" name="menu"></div>
```

You could select it like this:

```
driver.find_elements(By.NAME, "menu")
```

As you can see, these element selector strategies have limited use. The approaches that follow are all better approaches because they are much more versatile and capable.

### Summary: Tag Name, Link Text, Partial Link Text, and Name

| **Pros** | **Cons** |
| -------- | -------- |
| Easy to use | Not versatile |
| Extremely limited use |
| May not even apply in some cases |

## Good: XPath

XPath is a versatile and capable element selector strategy. This is also my personal preference and favorite. XPath can select any element in the page regardless of whether or not you have classes and IDs to use (although without classes or IDs, it becomes difficult to maintain and sometimes brittle). This option is particularly versatile because you can select [parent elements](https://www.w3schools.com/jsref/prop_node_parentelement.asp). XPath also has many built-in functions which allow you to customize your element selection.

However, with versatility comes complexity. Given the ability to do so much with XPath, you also have a steeper learning curve compared to other element selector strategies. This is offset by great online documentation which is easily found. One great resource is the [XPath tutorial found at W3Schools.com](https://www.w3schools.com/xml/xpath_intro.asp)

It should also be noted that there is a trade-off when using XPath. While you can select parent elements and have use of very versatile built-in functions, XPath performs poorly in Internet Explorer. You should consider this trade-off when selecting your element selector strategy. If you need to be able to select parent elements, you need to consider the impact it will have on your [cross-browser](https://blog.testproject.io/2017/02/09/cross-browser-testing-selenium-webdriver/) testing in Internet Explorer. Essentially, it will take longer to run your automated tests in Internet Explorer. If your application’s user base does not have high Internet Explorer usage, this would be a good option for you as you might consider running tests in Internet Explorer less often than other browsers. If your user base has significant Internet Explorer usage, you should consider XPath only as a fallback if other better approaches do not work for your organization.

### Example:

If you have a requirement to select parent elements, you must select XPath. Here’s how you do that: using our example, let’s say you want to target the parent main-menu element based on one of the anchor elements:

```
driver.find_elements(By.XPATH, "//a[id=menu]/../")
```

This element selector will target the first instance of the anchor tag that has the id equal to “menu”, then with “/../”, targets the parent element. The result is that you will have targeted the main-menu element.

### Summary: XPath

| **Pros** | **Cons** |
| -------- | -------- |
| Can select parent element | Poor performance in IE |
| Highly versatile | Slight learning curve |
| Lots of support online |

<div class="widget maestro maestro-content-type-html " id="maestro-652"><span data-sumome-listbuilder-embed-id="a5047315669ea28f9652485dfd816e21a7b7d3873736b516d897111b300bf50b"></span><script>ga('SitePointPlugin:observeImpressions', 'maestro-652')</script></div>

## Great: ID and Class

ID and Class element selectors are two different options in automation and perform different functions in an application. However, for considering what element selector strategy to use in your automation, they differ so little, that we don’t need to consider them separately. In the application, the “id” and “class” attributes of elements, when defined, allow the UI developer to manipulate and style the application. For automation, we use it to target a specific element for interaction in automation.

A large benefit to using IDs and Class element selectors is that they are least impacted by structural changes in the application. Hypothetically speaking, if you were to create an XPath or CSS selector that relied on a chain of few elements and some [child elements](https://www.w3schools.com/jsref/prop_element_children.asp), what happens when a feature request interrupts that chain by adding new elements? When using ID and Class element selectors, you can target specific elements instead of relying on page structure. You retain the robustness of your automation without being too lenient on change. Change should be detected through automation by creating test cases that focus on the location of specific elements. Change should not break your entire automation suite. However, if the developer makes a change directly to an ID or class utilized in automation, that will impact your tests.

This element selector strategy would not be usable if the application under test does not implement IDs and classes as a part of development best practices. If HTML tags do not have IDs and classes you can use in your automation, this approach becomes hard to use.

### Example:

In our example, if we were to select the top level menu element, that would look like this:

```
driver.find_elements(By.ID, "main-menu")
```

If we were to select the first menu item, that would look like this:

```
driver.find_elements(By.CLASS_NAME, "menu")
```

### Summary: ID and Class

| **Pros** | **Cons** |
| -------- | -------- |
| Easy to maintain | Developer may change them, breaking automation |
| Easy to learn |
| Least impacted by page structure change |

## Best: Custom Attributes­­­­­­­­ with CSS Selector

If your QA organization has a good collaborative relationship with development, chances are you will be able to use this best practice approach for your automation. Using custom attributes and CSS Selectors to target elements has multiple benefits for both the QA team and the organization. For the QA team, this allows automation engineers to target specific elements they need without creating complicated element selectors. However, this requires the ability to add custom attributes that the automation team can use in the application. To take advantage of this best practice approach, your development and QA teams should work in cooperation to implement this strategy.

I’d like to take a minute to note that the CSS Selector approach is not dependent on custom attributes. CSS Selectors can target any tag and attribute within an HTML document just like XPath.

Now let’s look at what this approach entails. To best execute this, your automation team should understand what they want to target in their automation. Working with the developers, most likely the front end engineers, they would then work out a pattern for a custom attribute to place into each target the automation team needs to hook into. For this example, we attach a “tid” attribute to the target elements.

One technical note to highlight here is a limitation in CSS Selectors. They are intentionally not allowed to select parent elements like XPath can. This is done to avoid infinite loops in CSS styling on web pages. While this is a good thing for web design, it is a limitation for its use as an automation element selector strategy. Fortunately, this limitation can be avoided with custom attributes implemented by development. QA should request the appropriate custom attributes so that there is no need to select a parent element.

If the collaboration between your development and QA team doesn’t exist yet in your organization, don’t worry! You should implement this strategy because it can be the mechanism that drives that collaboration. Regardless of whether that culture exists or not, you should take on this approach and watch what comes of it. Not only will you have an easy to maintain element selector strategy, but you will see benefits from the collaboration spill-over into other areas of your organization. The collaborative relationship this will build will benefit you across many aspects of quality assurance such as reduced defects, reduced time to market, and increased productivity.

To best implement this element selector strategy and to create that collaboration, your QA team should be involved with the design process from the beginning. Working with development, they should review the requirements. As development designs the feature, QA should suggest where custom attributes can be implemented to best support the automation effort. By encouraging this collaboration at the beginning of the design phase, you will move the QA and development teams closer together in terms of collaboration and improve efficiency in the development process. This will likely have a beneficial spill-over effect into other areas of the Software Development Life Cycle. Encouraging collaboration here will familiarize development and QA with each other so that collaboration in other areas is likely to occur as well.

### Example:

Implementing custom attributes on the anchor tags in our example HTML would result in something like this:

```
<div id="main-menu">
  <div class="menu"><a tid="home-link" href="/home">Home</a></div>
  <div class="menu"><a tid="shop-link" href="/shop">Shop</a>
    <div class="submenu">
      <a tid="gizmo-link" href="/shop/gizmo">Gizmo</a>
      <a tid="widget-link" href="/shop/widget">Widget</a>
      <a tid="sprocket-link" href="/shop/sprocket">Sprocket</a>
    </div>
  </div>
</div>
```

Notice the new attribute in some of the elements. We created a new attribute that does not conflict with any standard HTML attribute called “tid”. With this custom attribute, we can use a CSS selector to target it:

```
driver.find_element(By. CSS_SELECTOR, "[tid=home-link]")
```

Let’s say you wanted to select all of the links in the menu, regardless of whether it’s a top level menu item or a submenu. With CSS Selectors, you can create highly versatile element selectors:

```
driver.find_element(By.CSS_SELECTOR, "#main-menu [tid*='-link']")
```

What the “*=” does is do a wildcard search for the value “-link” within the tid field of any element. Placing this behind the #main-menu ID specifier, it focuses the search for elements to within the main menu.

If you want to select this strategy without the use of custom attributes, you are still on the right track. For example, you can target the links in the Shop submenu using the following approach:

```
driver.find_element(By. CSS_SELECTOR, "#main-menu .submenu a")
```

This strategy will allow automation engineers the ability to create solid automation that is easy to maintain and is not broken by irrelevant changes in the UI. Selecting this strategy is the best possible approach. It will not only be an easily maintainable solution for automation but will encourage collaboration between your QA team and your developers.

### Summary: Custom Attributes with CSS Selectors

| **Pros** | **Cons** |
| -------- | -------- |
| Easy to learn | Initial effort involved in establishing a collaborative relationship with the development team |
| Lots of support online |
| Versatile |
| Excellent performance in all browsers |

## Conclusion

There are some great options for implementing an enterprise standard element selector strategy in your automation framework. Options like the tag name or link text should be avoided unless it’s your only option. XPath, ID, and Class selectors are a good route. By far, the best approach is to implement custom attributes and target them with CSS Selectors. This also encourages collaboration between the development and QA team.

Here are your options compared side-by-side:

![1511434384(1).jpg](https://i.loli.net/2017/11/23/5a16a89cdb6db.jpg)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
