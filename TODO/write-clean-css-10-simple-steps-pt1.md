> * 原文地址：[How to Write Clean CSS in 10 Simple Steps Pt1](http://blog.alexdevero.com/write-clean-css-10-simple-steps-pt1/)
* 原文作者：[Alex Devero](http://blog.alexdevero.com/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[王子建](https://github.com/Romeo0906)
* 校对者：[]()

# How to Write Clean CSS in 10 Simple Steps Pt1

[![How to Write Clean CSS in 10 Simple Steps Pt1](https://i2.wp.com/blog.alexdevero.com/wp-content/uploads/2016/12/How-to-Write-Clean-CSS-in-10-Simple-Steps-Pt1-small.jpg?resize=697%2C464)](https://i2.wp.com/blog.alexdevero.com/wp-content/uploads/2016/12/How-to-Write-Clean-CSS-in-10-Simple-Steps-Pt1-small.jpg)

Do you think you can write clean CSS? There are many web designers and developers convinced that writing good and clean CSS is hard. In a fact, a lot of people don’t like CSS at all. For them, CSS is pain in the butt. Here is a good news. Working with CSS can be actually easy! You can even enjoy it. This mini series, will help you with it. You will learn about 10 simple steps that will help you write cleaner CSS. And, clean CSS is one of the keys to CSS that is easy and pleasant to work with.

你是不是觉得自己可以写干净的 CSS 代码呢？许多网站的设计者和开发者都认为编写良好、干净的 CSS 代码很难。事实上，许多人根本就不喜欢 CSS，对他们来说，CSS 是一个痛点。好消息来了，使用 CSS 实际上可以变得很简单！你甚至可以乐在其中。这个系列，可以助你实现这个目的。你将会学习 10 条简单的不着来书写更加干净的 CSS 代码。要知道，书写干净的 CSS 代码是简单愉快地使用 CSS 的关键呢！

## Table of Contents:

Brief intro

No.1: Stick to one naming convention

Good and meaningful CSS classes

The beauty of semantic naming convention

No.2: Use external stylesheets

No.3: Validate your CSS

Baptism by fire

No.4: Use CSS linter

No.5: Adopt modular CSS

Which modular framework to choose

No.6-10 in [part 2](http://blog.alexdevero.com/write-clean-css-10-simple-steps-pt2/).

##　内容列表：

简介

No.1: 坚持一种命名规范

良好的有意义的 CSS 类名

语义化命名规范之美

No.2: 使用外链样式表文件

No.3: 验证 CSS 代码

火的淬炼

No.4: 使用 CSS 代码 linter

No.5: 采用模块化的 CSS 代码

如何选择模块化框架

No.6-10 在[第二部分]() 

# Brief intro

# 简介

There are many candidates that could be the right fit for the number one step to writing clean CSS. Also, there are some steps you may don’t want to use. As a result, it was quite difficult to decide which step should be the first. And, in what order should I outline these 10 steps. After a decent amount of time, and reshuffling items on the list a couple of times, I decided to leave this decision to you. In this two-part mini series I will just give you 10 simple steps for writing clean CSS.

有许多方法可以称得上书写干净的 CSS 代码的第一要务，同时，也会有一些你不想使用的方法。因此，很难决定哪个方法是最重要的，也很难对这 10 个方法进行排序。考虑良久，对这些内容重排了许多次，最后我决定把这个问题留给你们。在这个只有两部分的系列文章中，我仅仅是展现给你们书写干净的 CSS 代码的 10 个简单的方法而已。

I will give you these steps in a somewhat defined order. I created this order on the amount of knowledge each step theoretically requires. In other words, steps on the beginning will be easier to implement that those on the end. However, keep in mind that this order is not set in stone. It is possible that you will disagree with me. Not only in the order of steps. Also, in the steps themselves. Again, these steps are not set in stone. You can think about it as a buffet.

我以一种既定的顺序把这些方法呈现给你，这是按照理论上每个方法所需的知识量来排序的。换句话说，前面的方法会比后面的方法容易实现。然而，这种顺序也不是一成不变的。很可能你会在顺序或者内容上与我产生分歧，因此你可以把它想象成餐台，请各取所需。

If you find something tasty, eat it. Otherwise, skip it and move to another dish. All these steps for creating clean CSS are based on the last decade of my work as a web designer. It is okay if you will disagree with some because your own experience tells you something different. However, don’t neglect some steps without even trying them. If something doesn’t work for you try something else, maybe the exact opposite. However, at least try it. Now enjoy the meal.

如果你发现了美味，拿走不谢，否则跳过然后继续。所有这些书写干净的 CSS 代码的方法都是基于十年来我从事的网站设计工作。如果实践中另有所得，你完全可以有不同的见解，但请不要不加尝试就否定它。一些内容没有生效的话，请试试其他方法，或者反其道而行之。最起码，你要尝试一下吧。没时间啰嗦了，快上车~

# No.1: Stick to one naming convention

# No.1: 坚持一种命名规范

Have you ever though about how you create CSS classes and IDs (please, avoid IDs)? And, I don’t mean just some quick and shallow stream of thought. I’m talking about minutes spent in deep thinking. Sure, I assume that many of you are using CSS to get the job done. You probably don’t want to get too philosophical about that. In addition, some of you may view CSS as pain in the ass. Another reason to write it quickly and move on to something more interesting, right?

你考虑过你该如何创建 CSS 类和 ID（请尽量避免 ID）吗？我不是指一闪而过的念头，而是花费若干时间来深度思考。我想当然地假定你们许多人都使用 CSS 来完成工作。你也许并不想让写代码变成一件太深沉的事情，另外还有一些人将 CSS 视为芒刺在背，这又是一个学习快速地书写代码并把它变成一种乐趣的原因，对吧？

Don’t worry. I will not try to convince you about how easy and simple working with CSS can be. If you don’t like it, it is your choice. However, I will try to convince you to think about trying something. Chances are that you work with CSS often. So, how about making these moments more enjoyable? All I want you to do is to think about implementing good naming convention. And then sticking to it. Why should you do that? It will make your CSS much easier to understand.

别担心，我不是来说服你使用 CSS 是一件多简单的事情。如果你不喜欢它，那也是你的选择。然而，我会试着说服你尝试一些其他内容。很可能你会经常使用 CSS，那么怎样变得有趣一点呢？你只需思考如何实现好的命名规范，然后坚持下去。为什么要这样做呢？这会让你的 CSS 代码变得更具可读性。

When you understand the CSS code, you are able to write it and use it more effectively. As a result, you are more likely to create clean CSS. And, working with clean CSS will be less painful. Again, good naming convention equals easy-to-understand CSS. This leads to higher chances of writing clean CSS. And, this leads to less pain while working with CSS. Sounds simple, right? The question is, how good or meaningful naming convention looks like?

当你理解了 CSS 代码，你就能更高效地书写和使用它，然后你就更容易写出干净的 CSS 代码，也就不会那么痛苦了。也就是说，好的命名规范就等于容易理解的 CSS 代码，这很可能写出干净的 CSS 代码，并且在使用时也就没那么痛苦了。听起来很简单，是吗？问题是，良好的有意义的命名规范长什么样呢？

## Good and meaningful CSS classes

## 良好的有意义的 CSS 类名

I think that good or meaningful naming convention is very easy to recognize. When you look at the stylesheet, you get some idea about what elements is the CSS styling. This is also one way to test how clean CSS are you writing. Do you need to see the HTML or load the website to understand the CSS? Then, I think that it is not clean CSS. At least not as clean as it could potentially be. Put simply, good or meaningful naming convention is descriptive.

我觉得良好的或者有意义的命名规范很容易辨认。当看到样式表内容的时候，你就能大致了解这段代码所控制的元素，这也是用来测试你写的代码有多干净的方法。你是否需要查看 HTML 代码或者加载网站才能理解 CSS 代码？如果是这样的，我认为你的 CSS 代码还不够干净，至少还有进步的空间。简言之，良好的有意义的命名规范应具有描述性。

In clean CSS there is no space for classes based on someone’s fantasy. If you like to geek out, I would suggest doing it somewhere else. Sure, CSS classes based on you favorite books or movies are not so dangerous. Changing your passwords when you are drunk or high is much worse. Still, this approach is not the way to clean CSS. If some doesn’t know specific movie or book, your CSS will seem like reading a foreign language. Also, what if you find another great book or movie?

干净的 CSS 代码中没有基于某人天马行空的想象而命名的类，如果你想要这样做，我会建议你用在其他地方。确实，以你最喜欢的书或者电影命名的类并不会危害人类，但在酩酊大醉或者磕了药的时候修改密码就非常糟糕了，一时的心血来潮起的类名与此如出一辙，因此并不是书写干净的 CSS 代码的正确方法。如果别人并不知道你写下的电影或者书名，读你的代码就像是在读火星文一样。并且，万一你发现了另外一本好书或者电影，你还要换类名吗？

Sure, you can rewrite all your CSS every time your book or movie preferences change. However, it is neither productive nor sustainable. CSS, and any code in general, has a tendency to expand with time, just like the universe. The same is true about its complexity. So, it is a good idea to start writing clean CSS soon, from the beginning if possible. If you are in the mess now, you watch what will happen after another month. What other naming convention could you use?

当然，你可以按你自己的喜好改变而重写你所有的 CSS 代码，但是这既不高产也无法忍受。通常来说 CSS 或者其他任何代码都必须要如洪荒宇宙一般经得住时间的考验，其复杂性也要如此。因此最好的办法是尽快开始书写干净的 CSS 代码，最好是从一开始就这样。如果你现在还一头雾水，那就一个月之后再回过头来看。你可以使用其他哪些命名规范呢？

## The beauty of semantic naming convention

## 语义化命名规范之美

One convention that is easy to implement and good for writing clean CSS is based on semantic. Put simply, the class should briefly describe the element. Have you ever worked with [Bootstrap](http://getbootstrap.com/) or [Foundation](http://foundation.zurb.com/) frameworks? Take a look at the documentation to see how semantic classes look like. For example, breadcrumb, btn, dropdown, jumbotron, pagination or nav. You don’t need to see HTML or load the website to understand these classes.

易实现且有助于写出干净的 CSS 代码的命名规范都是基于语义化的。简言之，类名应当可以清楚地描述其元素。你用过 [Bootstrap](http://getbootstrap.com/) 或者 [Foundation](http://foundation.zurb.com/) 框架吗？去查看一下他们的文档你就能明白什么是语义化的类名，比如：breadcrumb、btn、dropdown、jumbotron、pagination 或者 nav。你不用其查看 HTML 代码也不用加载网站就能明白这些类名的含义。

The same approach also works for classes changing states of elements. In this case, class should describe what it does. For example, btn-raised suggests that the button element is raised. On the other hand, btn-disabled suggest that clicking on the button will not lead to any action. Also, sidebar-left suggest sidebar element placed on the left side. Nav-primary and nav-secondary are clear indicators of which navigation is more important.

同样，这种方法也可以用于通过类名改变状态的元素。这种情况下，类名应当描述其作用，比如：btn-raised 表明按钮凸起，btn-disabled 表明按钮失效，sidebar-left 表明侧边栏在左边，nav-primary 和 nav-secondary 清楚地说明了导航的重要级。

Do you have to copy these classes in order to write clean CSS? No. You can create and use your own naming convention. You need to keep in mind that your classes must remain descriptive. Another web designer or developer should be able to understand your CSS. This must be doable without having to talk with you or seeing the code or website. If you think you are already there, ask someone to take a look at your CSS. You might be surprised.

你需要拷贝这些类名写干净的 CSS 代码吗？不，你可以使用自己的命名规范创建类名。你必须要牢记于心，类名必须具有描述性，无需沟通或者查看代码或者网站，其他的网站设计开发人员就能能够读懂你的 CSS 代码。如果你自我感觉良好，那么让其他人来看一下你的 CSS 代码，结果可能会令你大吃一惊。

One last thing I want to say about naming convention and writing clean CSS. When you choose your naming convention, stick to it. In the best case, you should have one naming convention. Then, you should use it in all projects. It will be easier to orient yourself in older projects. Also, starting work on new projects faster because you will don’t have to think about this every time. My favorite naming convention? Well, it is [BEM](http://blog.alexdevero.com/bem-crash-course-for-web-developers/).

关于命名规范和书写干净的 CSS 代码，我最后想要提醒的事情就是，当你选择了自己的命名规范之后要坚持下去。最好的情况就是，你只会一种命名规范，然后你会在所有的项目中都使用它。这会让你适应原来的项目，并且在新项目中也会进展神速，因为你不必每次都去琢磨起名字的事情了。我最喜欢的命名规范是啥？是 [BEM](http://blog.alexdevero.com/bem-crash-course-for-web-developers/)！

# No.2: Use external stylesheets

# No.2: 使用外链样式表文件

This will be a no-brainer for many web designers and developers. Yet, I think that it is still good to at least mention it. The majority of your CSS styles should be in external stylesheet. Why the majority and not all styles? According to [Google’s tips](https://developers.google.com/speed/docs/insights/OptimizeCSSDelivery) for optimizing CSS delivery, small piece of inline CSS might be beneficial. The question is, what is small inlineable piece of CSS? These are those critical styles applied to the content above the fold. Well, does fold even [exist](http://blog.alexdevero.com/50-landing-pages-4-startups-lessons-pt1/)?

对网站设计开发者来说，原始人都会这样做。但是，我认为提示一下总是有益无害的。你的大部分 CSS 样式都应该在外链样式表中，为什么是大部分而不是全部呢？根据谷歌对于优化 CSS 传输的[建议](https://developers.google.com/speed/docs/insights/OptimizeCSSDelivery)，少量的内联 CSS 代码很有益处。问题是，哪些是少量的可内联的 CSS 代码呢？有一些关键的样式，请戳[这里](http://blog.alexdevero.com/50-landing-pages-4-startups-lessons-pt1/)。

Aside from these critical CSS you could write either in the head section or inside small CSS stylesheet, everything else should be inside the main external stylesheet. I should mention that this stylesheet should be minified to [optimize the performance](http://blog.alexdevero.com/performance-budget-website-optimization-the-right-way/) of your website. There are two reasons why having one main external stylesheet is good for writing clean CSS. First, you have all CSS in one place. This helps you manage your CSS files. You are less likely to forget to include some.

除了这些关键的 CSS 样式你可以写在 head 标签内或者小的 CSS 样式文件中，其他都应当写在主要的外链样式表文件中。要注意，这个文件需要经过压缩处理来[优化](http://blog.alexdevero.com/performance-budget-website-optimization-the-right-w)网站的性能。一个主要的外链的样式表文件有助于书写干净的 CSS 代码，原因有二：

第一，所有的 CSS 代码都集中在一个文件内，有助于 CSS 文件的管理，不太可能会漏掉引入某个文件。

The second reason is mostly psychological. It will be harder to ignore messy CSS if you will see it all at once. When you work with small files, you might believe there is an order. Only when you put all these files together you can see the chaos. Working with one external CSS stylesheet can also force you to take care about your CSS. Who wants to scroll through hundreds of lines of CSS to make one small change? Not to mention that you might not be using some of these styles.

第二个原因主要是心理上的，你很难对那些突然映入眼帘的乱糟糟的 CSS 文件视而不见。在写那些小的 CSS 样式文件的时候，你会觉得它们是有顺序的，只有当所有的文件都归结到一起的时候，你才会发现那真是一团乱麻。只写一个外链的 CSS 样式表文件能迫使你关注自己的 CSS 代码。谁会愿意翻几百行的代码去改一点点内容呢？更不要说你可能根本没在用那些样式。

After a while, you will decide to stop that nonsense and do something with it. Hopefully, it will be something good. For example, taking some time to turning that mess into clean CSS. In other words, [refactoring your CSS](http://blog.alexdevero.com/refactoring-css-without-losing-client/). Lastly, one stylesheet can help you keep your [CSS DRY](http://csswizardry.com/2013/07/writing-dryer-vanilla-css/). Every line of code counts and every kilobyte you can save is good.

一段时间之后，你就会决定停止这种荒唐的做法，并做出些改变。庆幸的是，这是好事，比如你会花一些时间将那一团乱麻整理成干净的 CSS 代码。即[重构你的 CSS 代码](http://blog.alexdevero.com/refactoring-css-without-losing-client/)。最后，一个样式表文件可以助你保持你的 [CSS DRY](http://csswizardry.com/2013/07/writing-dryer-vanilla-css/)，你节省的每一行甚至每一 kB 都是好的。

# No.3: Validate your CSS

# No.3: 验证 CSS 代码

Another no-brainer right? If you want to write clean CSS, you should make sure it is valid. It is as simple as that. If so, why only so many web designers and developers use any validation service to check their CSS code? Anyway, there are two good reasons for using [CSS validator](http://jigsaw.w3.org/css-validator/#validate_by_input), aside from maintaining clean CSS. First, it is an easy way to make sure you are delivering flawless work to your clients. Sure, it is not very likely that your clients will use validator to test the CSS by themselves.

又一个无脑的建议哈？如果你想写干净的 CSS 代码，你应该确保它生效。如果这真的非常简单，那为什么只有为数不多的网页设计开发者使用验证服务来检查他们的 CSS 代码呢？不管怎么说，除了维护干净的 CSS 代码，还有两个使用 [CSS 验证](http://jigsaw.w3.org/css-validator/#validate_by_input)的理由。

第一，这很容易确保你向客户机传送了完美的内容，当然，客户机不大可能会自行验证 CSS 代码。

However, you never know what can happen. And, again, it is just reassurance for you that your work is excellent. It takes only a few seconds for the validator to analyze your CSS code. If there are no problems or warnings, you can pat yourself on the back for doing great job. What if there some problems or warnings? Great! It is an opportunity for you to improve your work and your code. When you think about it, there is no downside. You either pass the test or learn something new.

然而，你永远不会知道发生了什么，并且，这仅仅是确保你工作的完美。验证器只需几秒钟时间分析 CSS 代码，如果没有问题或者警告，你可以奖励自己一个朵大红花。但是如果出现了问题或者警告呢？太棒了！这是你提高工作水平和代码质量的好机会！当你思考的时候，你就在走上坡路了！整个过程中，你或者通过了验证，或者就是学到了新东西，何乐而不为呢？

## Baptism by fire

## 火的淬炼

This brings me to the second reason for using some CSS validator. You can learn about your weaknesses, where you are making mistakes. Then, you can fix these weakness and turn them into your strengths. As a result, you will get one step closer to writing clean CSS. This is something I want to emphasize. Validator is not a tool that should show you how great or bad you are. Also, remember, it is just a tool. So, don’t take the results personally.

接下来是我们使用 CSS 验证器的第二个理由，你可以发现自己的弱点、发现自己出错的地方，然后，你可以修正弱点并将其转变成自己的长处。那么，你将会距离干净的 CSS 更近了一步。我想强调一件事情，验证器并不是用来评判你的优劣的工具，要记住，他只是个工具而已。所以，不要太看重结果而背离了初衷。

As I mentioned, there is no way to fail if you run your CSS code through validator. You either pass the test or you learn about what you need to work on. Well, let me correct it. There is a way to fail. All you have to do is ignore the results decide not to learn how to do a better job the next. Anything else is a victory. This is something many of us have to deal with. We are afraid of testing our skills. In a school, failing a test was usually a bad thing. Getting an F, it was a disaster. Why?

我上文提到，使用验证器跑一下 CSS 代码有利无害，你或者通过测试或者学到必要的知识。现在，我要修正一下，如果你忽视结果并决定放弃学习如何更好地工作，这还是一个坏处，其他的任何情况对你而言都是胜利。还有一些我们需要处理的内容，比如我们害怕技能测试。上学的时候，考试不及格是非常糟糕的事情，拿到一个 F 简直就是灾难，为什么？

As I mentioned, every test is an opportunity for you. You can find what you are not good and work on it. Otherwise, how do you want to work on your weakness, if you don’t know your weakness? So, validator just kicked your butt? Okay. Open Google and find out what is wrong with your code and why. Or, you can head right on the [Stack Overlow](http://stackoverflow.com/) to find the best answer. Remember, the only way to get good is by learning and working on your weaknesses.

如我所言，每一次测试都是你的机会。你能发现你不擅长的东西并且巩固它，不然，如果连自己的弱点都不知道，你怎样巩固它呢？因此，验证器是否正中下怀？是的！打开 Google 找到你的代码哪里出错了，为什么会错，或者你可以在 [Stack Overlow](http://stackoverflow.com/) 上寻找最佳答案。记住，变的优秀的唯一的办法就是不断学习和巩固你的弱点。

# No.4: Use CSS linter

# No.4: 使用 CSS linter

Have you ever though about validator on steroids? Or, what about validator similar to Tyler Durden from Fight Club? Well, let me introduce you to something called [CSSlint](http://csslint.net/). If you think that CSS validator can kick your butt and hurt feelings, try this tool. What is the difference between these two? Validator will warn you only about code that is not valid. Meaning, the code is deprecated or not fully implement yet. Or, you made a grammar mistake (typo) or used unsupported character.

你是不是觉得验证器就像是打了鸡血一样？或者像是搏击俱乐部的 Tyler Durden？那么我来给你介绍一个名为 [CSSlint](http://csslint.net/) 的东西。如果你认为 CSS 验证器正中下怀并且有点伤感情，尝试一下这个工具吧。这两者有什么区别吗？验证器只会提示你无效的代码。这意味着，代码不支持或者没有被完全实现，或者是语法错误、使用了不支持的内容之类的。

Linter, on the other hand, is more opinionated. Depending on your selection of rules, it can warn you about many things validator would not care about. Usually, linter tests errors, duplicate CSS, performance, compatibility and accessibility issues. Any time you break some rule, linter will notify you. My opinion is that using linter is better for writing clean CSS than using validator. Or using only validator. In a fact, some of CSS best practices I follow are based on CSS lint.

从另一方面来说，linter 更加主观一些。基于自定义的规则，它可以提示许多验证器并不管的内容。通常，linter 测试错误、重复的 CSS 样式、性能、兼容性和可及性的问题。一旦你违反了规则，linter 都会提示你。我的意见是，使用 linter 更容易写出干净的 CSS 代码。或者，你也可以只使用验证器。实际上，我关注的一些 CSS 的最佳实践都是基于 CSS lint 的。

Do you remember when we talked about [CSS best practices](http://blog.alexdevero.com/css-best-practices-become-css-ninja-pt1/) for the first time? You can test if you follow some of these practices by linting your CSS. For example, you can test for use of important, IDs and overqualified elements. The good thing about linter is that it is up to you to choose which rules you want to follow. For example, if you want to use box-sizing (who wouldn’t?), you can disable this rule. Remember, linter should help you write clean CSS, not cause you headaches.

你记得我们第一次讨论过的 [CSS 最佳实践](http://blog.alexdevero.com/css-best-practices-become-css-ninja-pt1/)吗？如果你关注了这些内容，你可以使用 linter 测试一下。比如，你可以测试重要元素的使用、ID 和过时的元素。Linter 的好处就在于你可以自己选择要检查的规则。比如，你想使用 box-sizing（谁不想呢？），你就把该条规则禁用掉。要记得，linter 应该帮你书写干净的 CSS 代码，而不是给你造成麻烦。

Also, keep in mind that rules outlined in CSS linter are not set in stone. They are not the best practices everyone has to follow. So, before you use it, I suggest customizing it so it fits your needs. If you don’t like some rules, simply don’t use.

同样要记住 CSS linter 中的规则并不是一成不变的，也并没有每个人必须关注的最佳实践。因此，在你使用之前，我建议按照自己的需求自定义设置，如果你不喜欢一些规则，不要使用就是了。

# No.5: Adopt modular CSS

# No.5: 采用模块化的 CSS 代码

With this fifth step, we are getting to more advanced methods that will help you write clean CSS. Why modular CSS? And, is it really necessary? Let me answer the first question first. Modular CSS can help you structure and organize your CSS styles. Modular CSS is also helpful to keep your code DRY. In other words, it can make it easier for you to write clean CSS. Potential downside of modular CSS is that you may need to use some preprocessor. I should mention that I work with [Sass](http://sass-lang.com/).


在第五个方法中，我们将接触更高级一点的书写干净的 CSS 代码的方法。为什么要 CSS 代码模块化？真的有必要吗？我先回答第一个问题。CSS 代码模块化有助于我们构建和识别 CSS 样式，也有助于代码 DRY。换句话说，它让你更容易写出干净的 CSS 代码。模块化 CSS 代码潜在的没落的原因就是需要使用预处理器，我使用的是 [Sass](http://sass-lang.com/)。

Well, you can write plain and clean CSS and keep it modular. The benefit of using preprocessor that it allows you to chunk your CSS. You save every chunk into separate file. Then, you import all these files in a single stylesheet. It is just about managing your code. So, it is not a must for modular CSS. Modular CSS is about writing code that is reusable. You create “modules” you can then use anywhere without writing more code. This can lead to a better performance and maintainable site.

你可以书写清楚明白干净的 CSS 代码并将其模块化。使用预处理器的好处就是能够切分 CSS 代码。你可以分别存储每一部分代码，然后在一个单独的样式表文件中引入所有的文件。这属于管理代码的范畴了，因此并不是 CSS 代码模块化的必须方式。CSS 代码模块化是指书写可重用的代码，你可以创造可以在其它任何地方使用的模块，而不用书写更多的代码，这能优化性能也有利于网站维护。

We could spend the whole day just talking about different frameworks. However, this is not the goal of this article. Also, it is already long. For this reason, I will keep it short, hopefully. In the end, there are many frameworks for modular CSS you can use to write clean CSS. So…

我们可以花一整天的时间来讨论各种各样的框架，然而，这并不是本文的目的。另外，本文也已经够长了，因此我尽可能地长话短说。最后，有许多模块化的  CSS 框架，你可以用来书写干净的 CSS 代码。因此……

## Which modular framework to choose

## 如何选择模块化框架

This brings us to the most important question. Which framework is the best to use? My answer? None. There is no such a thing as the best framework. Everyone has a different approach and everyone has different needs. It is possible that framework that works for one developer will not work for you. Also, you can decide to combine multiple framework and create something new. For this reason, I suggest trying and testing various frameworks. See what works for you.

最重要的问题来了，哪个才是最好的框架呢？我的答案是没有。根本就没有最好一说，实现方法和需求因人而异，适用于我的框架也许并不适合你，另外你也可以博采众长创造一个新的框架。因此，我建议尝试多个框架，并找到适合你的那个。

Let me give you myself as an example. When I decided to use modular CSS, I started with SMACSS. This framework is very easy to learn and implement. It is based on categorization CSS into five types, or categories. These are base, layout, module, state and theme. All you need is to learn the rules to recognize what category this or that CSS code fits the best. Are you interested in learning more about SMACSS? Then, the best will be reading the documentation on its [official website](https://smacss.com/).

拿我自己举个例子吧。我决定使用模块化的 CSS 代码的时候，刚开始使用的是 SMACSS。这个框架简单易学容易实现，基于 CSS 代码的五种分类，即基础代码、布局、模块、状态和主题，你需要学习的就是如何识别 CSS 代码的分类。你对 SMACSS 感兴趣吗？最好的方式是阅读官方文档，[官网地址](https://smacss.com/)。

I used this framework for a very long time because it worked well. However, when I found Atomic design I decided to switch things up. Atomic design is also built on five categories. These categories are atoms, molecules, organisms, templates and pages. There again clear guidelines to find out which category specific CSS styles belong to. This is my favorite framework, with BEM. I use it in all projects. Do you want to learn more about Atomic design? Then, I have two resources for you.

由于性能很好，我很长一段时间都在使用 SMACSS。但是，当发现 Atomic design 的时候，我决定要上升一个档次。Atomic design 也是基于五个分类，即原子、分子、物体、模板和页面，也清楚地说明了每个特定的 CSS 样式所属的分类。我最喜欢将 Atomic design 和 BEM 一起使用，并用在了所有的项目中。你想学习更多内容吗？那么，我给你推荐两个资源。

First is the [official website](http://atomicdesign.bradfrost.com/) of Atomic design. It goes really deep and you will need some time to get through it. The second resource is [this guide](http://blog.alexdevero.com/atomic-design-scalable-modular-css-sass/) to writing scalable & modular CSS using Atomic design. This guide will help you learn all you need to use Atomic design and write modular CSS quickly. I should mention that I published this guide on this blog. Aside from SMACSS and Atomic design, there are at least two more popular frameworks for writing modular and clean CSS.

第一个就是 Atomic design 的[官网](http://atomicdesign.bradfrost.com/)，介绍的地非常深入，因此你需要时间来消化。第二个就是这个[利用 Atomic design 书写可扩展的 & 模块化的 CSS 代码指南](http://blog.alexdevero.com/atomic-design-scalable-modular-css-sass/)，这个文章会帮助你学习利用 Atomic design 快速书写模块化 CSS 代码的所有内容。BTW，我在我的博客上也发布了这篇指南。除了 SMACSS 和 Atomic design，还有至少两个更流行的书写模块化和干净的 CSS 代码的框架。

One is Object Oriented CSS, or OOCSS. Here, content blocks are seen as reusable objects. Since it is still about modular CSS, it works like SMACSS or Atomic design. However, I’ve tried it before so I can really tell you much more than that. To learn more about it, take a look at documentation on [GitHub](https://github.com/stubbornella/oocss/wiki) or [this tutorial](https://www.smashingmagazine.com/2011/12/an-introduction-to-object-oriented-css-oocss/) on Smashing Magazine. The second is quite new [ITCSS](http://itcss.io/). ITCSS is built on seven layers – settings, tools, generic, elements, objects, components and trumps.

一个是 Object Oriented CSS，也称 OOCSS，其中，内容区块被视作可重用的对象。因为这仍然是模块化 CSS 代码，因此它的工作原理类似 SMACSS 和 Atomic design。我以前使用过它，可以提供更多的信息，想要了解更多内容请查看 GitHub 上的[文档](https://github.com/stubbornella/oocss/wiki)或者这篇 Smashing Magazine 上的[说明](https://www.smashingmagazine.com/2011/12/an-introduction-to-object-oriented-css-oocss/)。第二个是相当新的 [ITCSS](http://itcss.io/)。ITCSS 基于七个层——设置层、工具层、一般层、元素层、对象层、组件层和最高层。

ITCSS can look a little bit more difficult on the first sight. However, it is not. Once you understand the rules or guidelines, working with it is very easy. If you are interested in ITCSS, [here](https://www.xfive.co/blog/itcss-scalable-maintainable-css-architecture/) is an extensive tutorial about it. There are many other frameworks for modular CSS. However, I think that these few we discussed will be enough for you to get started. I want to help you start writing clean CSS as soon as possible, not drown you in available options.

ITCSS 乍看之下稍有难度，然而它并不难，一旦你理解了规则和思路，使用起来非常简单。如果你对 ITCSS 感兴趣，欢迎查看 [ITCSS 全方位简介](https://www.xfive.co/blog/itcss-scalable-maintainable-css-architecture/)。弱水三千，只取一瓢，我认为今天讨论的这些足够你起步了。我希望能尽快帮助你书写干净的 CSS 代码，而不是将你淹没在可能的选项中。

## Closing thoughts on writing clean CSS

## 写在文末

This is where we will end this first part. Today, you’ve learned about the first five steps for writing clean CSS. Most of them were very easy and you can test and implement them immediately. You can start very easily by validating and linting your CSS. Another very easy step is using external stylesheet. Or, if you like something more interesting, create your own naming convention. And, if you want to challenge yourself, how about trying some framework for creating modular CSS?

第一部分到这里就结束了。今天，我们学习了五个书写干净的 CSS 代码的方法，大部分都很简单，你可以马上测试并实现。你可以很简单地从验证和检查 CSS 代码开始，也可以使用外链的层叠样式表文件。或者，如果喜欢更有趣的内容，你可以创造你自己的命名规范，如果你想挑战自己，不如来尝试一些框架书写模块化的 CSS 代码？

If any of these steps looks difficult, remember what is the reason for taking them. These steps will help you write maintainable and clean CSS. Trust me, the potential discomfort is worth it the time and effort. Think about it as an investment into yourself that will pay for itself multiple times in the future. And, what’s coming next? Maybe we could talk a bit about CSS files, automation, technical debt and much more. See you soon!

如果这些方法看起来很难，请记住我们为什么要这样做，这些方法有助于你书写易于维护的干净的 CSS 代码。相信我，最初的不适应是值得你去花费时间和精力去渡过的，把它想象成对自己的投资，并且将会在未来收获成倍的回报。预知后事如何？我们会讨论一些关于 CSS 文件、自动操作、技术债务和更多内容，回见！