> * 原文地址：[Bootstrap considered harmful](https://hiddedevries.nl/en/blog/2016-08-09-bootstrap-considered-harmful)
* 原文作者：[Hidde de Vries](https://hiddedevries.nl/en/about-me/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： 
* 校对者： 

Bootstrap has become a very popular tool in front-end projects over the years, and it can have huge benefits. However, if your team has a front-end developer on board, I would argue you may be better off without Bootstrap. In some instances, it can do more harm than good.

## What Bootstrap is great for

Bootstrap comes with a grid, but also with styles and scripts for many components, including tables, navigation bars, progress bars, paginations, form styling, modals and tooltips. In this article, by ‘Bootstrap’, I mean the practice to include all of it (as opposed to choosing to include part(s) only, i.e. _just_ its grid).

Bootstrap is a great tool for back-end developers who need markup to output their program into, and don’t want to worry about styling the result. If for some reason, budget or otherwise, there are no front-end developers or designers in a team, Bootstrap is great to fill that gap.

For designers, Bootstrap has its place too: it can be a valuable tool to move quickly from design software into the browser, without worrying too much about front-end coding strategies.

Even for front-end developers that mostly work with data and less with UI and layout, Bootstrap can be fantastic at letting a developer focus on building the application itself.

## When you’re better off without it

However, if you have a front-end developer on your team, using Bootstrap could potentially waste their dear time, and shift their focus away from solving real problems. Bootstrap does the very thing front-end developers have expertise in, but it does them in a very generalised way. Your website or web app is very specific, so if you use a generalised system it is likely not going to fit. This means that your code will contain a whole lot of exceptions, to make all the specific possible.

### When lots of exceptions are required to unset Bootstrap’s styles

Bootstrap was once made by developers at Twitter to systemise the style of _their_ web app. When your web app is not styled like theirs, this means you will have to unset what they do.

Most websites are not styled like Twitter. Therefore, if they load Bootstrap, they will need to unset a lot.

In some websites I worked on, I saw as many as 9 out of 10 Bootstrap styles being unset by the site’s own styles. To put it quite frankly, that’s ridiculous.

### When it makes simple things complex

CSS is made to add _simple_ sets of style rules to web pages, which can be conditionally overridden. When Bootstrap’s CSS is in your site, almost all the things are already set using a _complex_ set of style rules. Any exceptions go on top of that. The issue with most sites is that most of their styles will be exceptions to Bootstrap styles.

Bootstrap’s styles are complex: you can have a grid that has 12 columns which can be used in any combination you want, with special classes taking care of skipping columns and setting column structures differently based on the user’s viewport. Many websites are simple: they only have no columns on small screens and one or two on larger screens.

### When it creates technical debt

The longer a front-end code base relies on Bootstrap, the more it gets entangled with it, and the more rules it contains that exist just to unset Bootstrap stuff. This, more often than not, leaves the codebase in huge technical debt, especially if front-end code is implemented in the back-end in a way that requires manual updating (which is often the case). Removing Bootstrap will be harder over time, as too much relies on it.

### When it introduces naming conventions that may not be your app’s

Naming things is hard, and it takes time to come up with sensible naming conventions that work for your team and app. Using proper nouns for component names doesn’t mix well with classnames like ‘btn’ that are abbreviations of proper nouns.

## Conclusion

Bootstrap and friends can be beneficial for all kinds of stages in the process of making websites. They are however not a magic bullet that will make everything easier: on the contrary, there are many downsides that can be avoided by having a front-end developer focus on coding the UI by hand.


</div>
