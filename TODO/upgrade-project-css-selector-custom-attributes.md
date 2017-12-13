> * 原文地址：[Upgrade Your Project with CSS Selector and Custom Attributes](https://www.sitepoint.com/upgrade-project-css-selector-custom-attributes/?utm_source=SitePoint&utm_medium=email&utm_campaign=Versioning)
> * 原文作者：[Tim Harrison](https://www.sitepoint.com/author/tharrison/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/upgrade-project-css-selector-custom-attributes.md](https://github.com/xitu/gold-miner/blob/master/TODO/upgrade-project-css-selector-custom-attributes.md)
> * 译者：
> * 校对者：

# 用 CSS 选择器和自定义属性来升级你的项目

_这篇文章原文刊登在 [TestProject](https://blog.testproject.io/2017/08/10/css-selector-custom-attributes/)。感谢你们的支持，让 SitePoint 成为可能。_

[Selenium WebDriver](https://blog.testproject.io/2016/11/07/selenium-webdriver-3/) 的元素选择器是一种 [自动化框架](https://blog.testproject.io/2017/03/26/test-automation-infrastructure-fundamentals/) 的核心组件，同时也是与 web 应用进行交互的关键。在对 [自动化元素选择器](https://blog.testproject.io/2017/02/09/inspect-web-elements-chrome-devtools/) 的回顾中， 我们讨论了很多不同的选择器应用策略，探究其功能，权衡优缺点，最终我们推荐 [最佳的选择器应用策略](https://blog.testproject.io/2017/08/10/css-selector-custom-attributes/#CustomAttributes) —— 带有自定义属性的 CSS 选择器。

## Selenium 的元素选择器

选择最好的 [元素选择器](https://blog.testproject.io/2017/02/09/inspect-web-elements-chrome-devtools/#ElementSelector) 策略是成功的关键，也减轻了自动化工作的维护压力。因此，做出选择的时候应该从使用难度，多功能性，是否具有在线支持，文档丰富程度以及性能等多方面进行考虑。前期的充分考虑是有回报的，自动化工作会更容易维护。

就像从技术方面考虑一样，也要考虑到团队文化。在自动化工作中采用元素选择器时，开发者与 QA 成熟的协作文化可以解锁更高成就，取得更好的效果。夯实软件开发周期中其它方面的协作基础不仅对自动化工作有益，更是对团队有益。

所有的代码示例都是由 [Python](https://www.python.org/) 和 [Selenium WebDriver](https://blog.testproject.io/2016/11/07/selenium-webdriver-3/) 命令编写而成，但也普适于其它编程语言与框架。

### HTML 代码示例:

在每一段的示例中，都是使用以下导航菜单的 HTML 片段代码：

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

## 糟糕的选择器： 标签名，链接文本，部分链接文本和 name 属性选择器

关于这部分内容不需要花太多时间来讲，因为这些选择器的使用场景都很有限。在整个自动化框架中广泛使用这些选择器不是一个好选择。它们解决了可以通过其它元素选择器轻松实现的特定需求。只在有特定需求去处理特殊场景的时候使用这几种选择器。即使如此，大多数特殊场景并没有特殊到非要使用这几种选择器才能解决。你可以在没有其他选择器选项可用（例如自定义标签或 id ）的情况下使用。

### 举个栗子：

使用标签名称选择器，会选择到非常多的匹配到标签名称的元素。它的用途非常有限，只能作为在需要选择相同类型的大量元素的这一唯一情况下的解决方案。下面这个例子会返回示例 HTML 代码中全部 4个 div 元素。

```
driver.find_elements(By.TAG_NAME, "div")
```

也可以像下面的例子这样通过链接来选择。 如你所见，这样只能定位到锚点标签而且只能定位这些锚点标签的文本：

```
driver.find_elements(By.LINK_TEXT, "Home")
driver.find_elements(By.PARTIAL_LINK_TEXT, "Sprock")
```

最近，也可以通过 name 属性来选择元素， 但是在 HTML 代码示例中可以看出，是没有标签具有 name 属性的。这在任何应用中都是一个常见问题，因为给每个 HTML 属性中添加一个 nmae 属性不是常规的代码实践。假如主菜单元素有一个 name 属性：

```
<div id="main-menu" name="menu"></div>
```

就可以这样选择到这个元素：

```
driver.find_elements(By.NAME, "menu")
```

如你所见，以上这些元素选择策略的使用场景都很有限。下面的方法都会更好一些，它们更灵活多变。

### 总结: 标签名，链接文本，部分链接文本和 name 属性选择器

| **优点** | **缺点** |
| -------- | -------- |
| 使用简单 | 不够灵活 |
| 使用场景极其有限 |
| 在某些场景甚至可能用不了 |

## 好的选择器： XPath

XPath 是一种灵活多变的选择器策略。这也是我个人喜欢的一种。XPath 可以选择页面中的任意元素，无论它有没有 class 和 id （虽然没有 class 和 id 的话很难维护）。 它是一个通用选项，因为你可以选择 [父元素](https://www.w3schools.com/jsref/prop_node_parentelement.asp)。XPath也有许多内置的功能，可以让你自定义元素选择。

但是，多功能性也带来了复杂性。鉴于 XPath 可以做这么多事，相比于其它选择器，它的学习曲线也更陡峭。这一不足是可以被它非常赞的在线文档抵消的。一个很不错的资源是 [W3Schools.com 上找到的 XPath 入门指南](https://www.w3schools.com/xml/xpath_intro.asp)。

还应该指出，使用 XPath 的时候有一件事需要进行权衡。虽然可以通过 XPath 选择父元素并使用一系列内置函数，但是 XPath 在 IE 浏览器的表现不佳。进行元素选择器策略的选择时，应该考虑这个问题。如果你有选择父元素的需要的话，要考虑它对 IE 上进行的 [跨浏览器](https://blog.testproject.io/2017/02/09/cross-browser-testing-selenium-webdriver/) 测试的影响。本质上，在 IE 中运行自动化测试的耗时更长。如果你的用户群体的 IE 使用率不高的话，考虑到在 IE 上跑测试的时候更少，XPath 依然是一个好选择。如果你的用户基本上都是 IE 重度使用者的话，XPath 就只能作为没有其它更好方式时的备胎选择了。

### 举个栗子：

如果你有需求要选择父元素，那就必须采用 XPath。下面是做法，依然使用我们的示例，假设你要定位一个基于锚点元素的主菜单元素的父元素：

```
driver.find_elements(By.XPATH, "//a[id=menu]/../")
```

这个元素选择器会定位到第一个 id 等于 “menu” 的锚点标签，然后通过 “/../” 定位到它的父元素。最终结果就是你会定位到主菜单元素。

### 总结： XPath

| **优点** | **缺点** |
| -------- | -------- |
| 可以定位到父元素 | IE 上表现欠佳 |
| 非常灵活 | 陡峭的学习曲线 |
| 非常多的在线支持 |



## 炒鸡棒的元素选择器： ID 和 Class

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

## 最佳的元素选择器: 具有自定义属性的 CSS 选择器

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
