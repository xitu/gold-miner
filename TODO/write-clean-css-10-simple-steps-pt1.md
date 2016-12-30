> * 原文地址：[How to Write Clean CSS in 10 Simple Steps Pt1](http://blog.alexdevero.com/write-clean-css-10-simple-steps-pt1/)
* 原文作者：[Alex Devero](http://blog.alexdevero.com/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[王子建](https://github.com/Romeo0906)
* 校对者：[]()

# How to Write Clean CSS in 10 Simple Steps Pt1

[![How to Write Clean CSS in 10 Simple Steps Pt1](https://i2.wp.com/blog.alexdevero.com/wp-content/uploads/2016/12/How-to-Write-Clean-CSS-in-10-Simple-Steps-Pt1-small.jpg?resize=697%2C464)](https://i2.wp.com/blog.alexdevero.com/wp-content/uploads/2016/12/How-to-Write-Clean-CSS-in-10-Simple-Steps-Pt1-small.jpg)

Do you think you can write clean CSS? There are many web designers and developers convinced that writing good and clean CSS is hard. In a fact, a lot of people don’t like CSS at all. For them, CSS is pain in the butt. Here is a good news. Working with CSS can be actually easy! You can even enjoy it. This mini series, will help you with it. You will learn about 10 simple steps that will help you write cleaner CSS. And, clean CSS is one of the keys to CSS that is easy and pleasant to work with.

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

# Brief intro

There are many candidates that could be the right fit for the number one step to writing clean CSS. Also, there are some steps you may don’t want to use. As a result, it was quite difficult to decide which step should be the first. And, in what order should I outline these 10 steps. After a decent amount of time, and reshuffling items on the list a couple of times, I decided to leave this decision to you. In this two-part mini series I will just give you 10 simple steps for writing clean CSS.

I will give you these steps in a somewhat defined order. I created this order on the amount of knowledge each step theoretically requires. In other words, steps on the beginning will be easier to implement that those on the end. However, keep in mind that this order is not set in stone. It is possible that you will disagree with me. Not only in the order of steps. Also, in the steps themselves. Again, these steps are not set in stone. You can think about it as a buffet.

If you find something tasty, eat it. Otherwise, skip it and move to another dish. All these steps for creating clean CSS are based on the last decade of my work as a web designer. It is okay if you will disagree with some because your own experience tells you something different. However, don’t neglect some steps without even trying them. If something doesn’t work for you try something else, maybe the exact opposite. However, at least try it. Now enjoy the meal.

# No.1: Stick to one naming convention

Have you ever though about how you create CSS classes and IDs (please, avoid IDs)? And, I don’t mean just some quick and shallow stream of thought. I’m talking about minutes spent in deep thinking. Sure, I assume that many of you are using CSS to get the job done. You probably don’t want to get too philosophical about that. In addition, some of you may view CSS as pain in the ass. Another reason to write it quickly and move on to something more interesting, right?

Don’t worry. I will not try to convince you about how easy and simple working with CSS can be. If you don’t like it, it is your choice. However, I will try to convince you to think about trying something. Chances are that you work with CSS often. So, how about making these moments more enjoyable? All I want you to do is to think about implementing good naming convention. And then sticking to it. Why should you do that? It will make your CSS much easier to understand.

When you understand the CSS code, you are able to write it and use it more effectively. As a result, you are more likely to create clean CSS. And, working with clean CSS will be less painful. Again, good naming convention equals easy-to-understand CSS. This leads to higher chances of writing clean CSS. And, this leads to less pain while working with CSS. Sounds simple, right? The question is, how good or meaningful naming convention looks like?

## Good and meaningful CSS classes

I think that good or meaningful naming convention is very easy to recognize. When you look at the stylesheet, you get some idea about what elements is the CSS styling. This is also one way to test how clean CSS are you writing. Do you need to see the HTML or load the website to understand the CSS? Then, I think that it is not clean CSS. At least not as clean as it could potentially be. Put simply, good or meaningful naming convention is descriptive.

In clean CSS there is no space for classes based on someone’s fantasy. If you like to geek out, I would suggest doing it somewhere else. Sure, CSS classes based on you favorite books or movies are not so dangerous. Changing your passwords when you are drunk or high is much worse. Still, this approach is not the way to clean CSS. If some doesn’t know specific movie or book, your CSS will seem like reading a foreign language. Also, what if you find another great book or movie?

Sure, you can rewrite all your CSS every time your book or movie preferences change. However, it is neither productive nor sustainable. CSS, and any code in general, has a tendency to expand with time, just like the universe. The same is true about its complexity. So, it is a good idea to start writing clean CSS soon, from the beginning if possible. If you are in the mess now, you watch what will happen after another month. What other naming convention could you use?

## The beauty of semantic naming convention

One convention that is easy to implement and good for writing clean CSS is based on semantic. Put simply, the class should briefly describe the element. Have you ever worked with [Bootstrap](http://getbootstrap.com/) or [Foundation](http://foundation.zurb.com/) frameworks? Take a look at the documentation to see how semantic classes look like. For example, breadcrumb, btn, dropdown, jumbotron, pagination or nav. You don’t need to see HTML or load the website to understand these classes.

The same approach also works for classes changing states of elements. In this case, class should describe what it does. For example, btn-raised suggests that the button element is raised. On the other hand, btn-disabled suggest that clicking on the button will not lead to any action. Also, sidebar-left suggest sidebar element placed on the left side. Nav-primary and nav-secondary are clear indicators of which navigation is more important.

Do you have to copy these classes in order to write clean CSS? No. You can create and use your own naming convention. You need to keep in mind that your classes must remain descriptive. Another web designer or developer should be able to understand your CSS. This must be doable without having to talk with you or seeing the code or website. If you think you are already there, ask someone to take a look at your CSS. You might be surprised.

One last thing I want to say about naming convention and writing clean CSS. When you choose your naming convention, stick to it. In the best case, you should have one naming convention. Then, you should use it in all projects. It will be easier to orient yourself in older projects. Also, starting work on new projects faster because you will don’t have to think about this every time. My favorite naming convention? Well, it is [BEM](http://blog.alexdevero.com/bem-crash-course-for-web-developers/).

# No.2: Use external stylesheets

This will be a no-brainer for many web designers and developers. Yet, I think that it is still good to at least mention it. The majority of your CSS styles should be in external stylesheet. Why the majority and not all styles? According to [Google’s tips](https://developers.google.com/speed/docs/insights/OptimizeCSSDelivery) for optimizing CSS delivery, small piece of inline CSS might be beneficial. The question is, what is small inlineable piece of CSS? These are those critical styles applied to the content above the fold. Well, does fold even [exist](http://blog.alexdevero.com/50-landing-pages-4-startups-lessons-pt1/)?

Aside from these critical CSS you could write either in the head section or inside small CSS stylesheet, everything else should be inside the main external stylesheet. I should mention that this stylesheet should be minified to [optimize the performance](http://blog.alexdevero.com/performance-budget-website-optimization-the-right-way/) of your website. There are two reasons why having one main external stylesheet is good for writing clean CSS. First, you have all CSS in one place. This helps you manage your CSS files. You are less likely to forget to include some.

The second reason is mostly psychological. It will be harder to ignore messy CSS if you will see it all at once. When you work with small files, you might believe there is an order. Only when you put all these files together you can see the chaos. Working with one external CSS stylesheet can also force you to take care about your CSS. Who wants to scroll through hundreds of lines of CSS to make one small change? Not to mention that you might not be using some of these styles.

After a while, you will decide to stop that nonsense and do something with it. Hopefully, it will be something good. For example, taking some time to turning that mess into clean CSS. In other words, [refactoring your CSS](http://blog.alexdevero.com/refactoring-css-without-losing-client/). Lastly, one stylesheet can help you keep your [CSS DRY](http://csswizardry.com/2013/07/writing-dryer-vanilla-css/). Every line of code counts and every kilobyte you can save is good.

# No.3: Validate your CSS

Another no-brainer right? If you want to write clean CSS, you should make sure it is valid. It is as simple as that. If so, why only so many web designers and developers use any validation service to check their CSS code? Anyway, there are two good reasons for using [CSS validator](http://jigsaw.w3.org/css-validator/#validate_by_input), aside from maintaining clean CSS. First, it is an easy way to make sure you are delivering flawless work to your clients. Sure, it is not very likely that your clients will use validator to test the CSS by themselves.

However, you never know what can happen. And, again, it is just reassurance for you that your work is excellent. It takes only a few seconds for the validator to analyze your CSS code. If there are no problems or warnings, you can pat yourself on the back for doing great job. What if there some problems or warnings? Great! It is an opportunity for you to improve your work and your code. When you think about it, there is no downside. You either pass the test or learn something new.

## Baptism by fire

This brings me to the second reason for using some CSS validator. You can learn about your weaknesses, where you are making mistakes. Then, you can fix these weakness and turn them into your strengths. As a result, you will get one step closer to writing clean CSS. This is something I want to emphasize. Validator is not a tool that should show you how great or bad you are. Also, remember, it is just a tool. So, don’t take the results personally.

As I mentioned, there is no way to fail if you run your CSS code through validator. You either pass the test or you learn about what you need to work on. Well, let me correct it. There is a way to fail. All you have to do is ignore the results decide not to learn how to do a better job the next. Anything else is a victory. This is something many of us have to deal with. We are afraid of testing our skills. In a school, failing a test was usually a bad thing. Getting an F, it was a disaster. Why?

As I mentioned, every test is an opportunity for you. You can find what you are not good and work on it. Otherwise, how do you want to work on your weakness, if you don’t know your weakness? So, validator just kicked your butt? Okay. Open Google and find out what is wrong with your code and why. Or, you can head right on the [Stack Overlow](http://stackoverflow.com/) to find the best answer. Remember, the only way to get good is by learning and working on your weaknesses.

# No.4: Use CSS linter

Have you ever though about validator on steroids? Or, what about validator similar to Tyler Durden from Fight Club? Well, let me introduce you to something called [CSSlint](http://csslint.net/). If you think that CSS validator can kick your butt and hurt feelings, try this tool. What is the difference between these two? Validator will warn you only about code that is not valid. Meaning, the code is deprecated or not fully implement yet. Or, you made a grammar mistake (typo) or used unsupported character.

Linter, on the other hand, is more opinionated. Depending on your selection of rules, it can warn you about many things validator would not care about. Usually, linter tests errors, duplicate CSS, performance, compatibility and accessibility issues. Any time you break some rule, linter will notify you. My opinion is that using linter is better for writing clean CSS than using validator. Or using only validator. In a fact, some of CSS best practices I follow are based on CSS lint.

Do you remember when we talked about [CSS best practices](http://blog.alexdevero.com/css-best-practices-become-css-ninja-pt1/) for the first time? You can test if you follow some of these practices by linting your CSS. For example, you can test for use of important, IDs and overqualified elements. The good thing about linter is that it is up to you to choose which rules you want to follow. For example, if you want to use box-sizing (who wouldn’t?), you can disable this rule. Remember, linter should help you write clean CSS, not cause you headaches.

Also, keep in mind that rules outlined in CSS linter are not set in stone. They are not the best practices everyone has to follow. So, before you use it, I suggest customizing it so it fits your needs. If you don’t like some rules, simply don’t use.

# No.5: Adopt modular CSS

With this fifth step, we are getting to more advanced methods that will help you write clean CSS. Why modular CSS? And, is it really necessary? Let me answer the first question first. Modular CSS can help you structure and organize your CSS styles. Modular CSS is also helpful to keep your code DRY. In other words, it can make it easier for you to write clean CSS. Potential downside of modular CSS is that you may need to use some preprocessor. I should mention that I work with [Sass](http://sass-lang.com/).

Well, you can write plain and clean CSS and keep it modular. The benefit of using preprocessor that it allows you to chunk your CSS. You save every chunk into separate file. Then, you import all these files in a single stylesheet. It is just about managing your code. So, it is not a must for modular CSS. Modular CSS is about writing code that is reusable. You create “modules” you can then use anywhere without writing more code. This can lead to a better performance and maintainable site.

We could spend the whole day just talking about different frameworks. However, this is not the goal of this article. Also, it is already long. For this reason, I will keep it short, hopefully. In the end, there are many frameworks for modular CSS you can use to write clean CSS. So…

## Which modular framework to choose

This brings us to the most important question. Which framework is the best to use? My answer? None. There is no such a thing as the best framework. Everyone has a different approach and everyone has different needs. It is possible that framework that works for one developer will not work for you. Also, you can decide to combine multiple framework and create something new. For this reason, I suggest trying and testing various frameworks. See what works for you.

Let me give you myself as an example. When I decided to use modular CSS, I started with SMACSS. This framework is very easy to learn and implement. It is based on categorization CSS into five types, or categories. These are base, layout, module, state and theme. All you need is to learn the rules to recognize what category this or that CSS code fits the best. Are you interested in learning more about SMACSS? Then, the best will be reading the documentation on its [official website](https://smacss.com/).

I used this framework for a very long time because it worked well. However, when I found Atomic design I decided to switch things up. Atomic design is also built on five categories. These categories are atoms, molecules, organisms, templates and pages. There again clear guidelines to find out which category specific CSS styles belong to. This is my favorite framework, with BEM. I use it in all projects. Do you want to learn more about Atomic design? Then, I have two resources for you.

First is the [official website](http://atomicdesign.bradfrost.com/) of Atomic design. It goes really deep and you will need some time to get through it. The second resource is [this guide](http://blog.alexdevero.com/atomic-design-scalable-modular-css-sass/) to writing scalable & modular CSS using Atomic design. This guide will help you learn all you need to use Atomic design and write modular CSS quickly. I should mention that I published this guide on this blog. Aside from SMACSS and Atomic design, there are at least two more popular frameworks for writing modular and clean CSS.

One is Object Oriented CSS, or OOCSS. Here, content blocks are seen as reusable objects. Since it is still about modular CSS, it works like SMACSS or Atomic design. However, I’ve tried it before so I can really tell you much more than that. To learn more about it, take a look at documentation on [GitHub](https://github.com/stubbornella/oocss/wiki) or [this tutorial](https://www.smashingmagazine.com/2011/12/an-introduction-to-object-oriented-css-oocss/) on Smashing Magazine. The second is quite new [ITCSS](http://itcss.io/). ITCSS is built on seven layers – settings, tools, generic, elements, objects, components and trumps.

ITCSS can look a little bit more difficult on the first sight. However, it is not. Once you understand the rules or guidelines, working with it is very easy. If you are interested in ITCSS, [here](https://www.xfive.co/blog/itcss-scalable-maintainable-css-architecture/) is an extensive tutorial about it. There are many other frameworks for modular CSS. However, I think that these few we discussed will be enough for you to get started. I want to help you start writing clean CSS as soon as possible, not drown you in available options.

## Closing thoughts on writing clean CSS

This is where we will end this first part. Today, you’ve learned about the first five steps for writing clean CSS. Most of them were very easy and you can test and implement them immediately. You can start very easily by validating and linting your CSS. Another very easy step is using external stylesheet. Or, if you like something more interesting, create your own naming convention. And, if you want to challenge yourself, how about trying some framework for creating modular CSS?

If any of these steps looks difficult, remember what is the reason for taking them. These steps will help you write maintainable and clean CSS. Trust me, the potential discomfort is worth it the time and effort. Think about it as an investment into yourself that will pay for itself multiple times in the future. And, what’s coming next? Maybe we could talk a bit about CSS files, automation, technical debt and much more. See you soon!