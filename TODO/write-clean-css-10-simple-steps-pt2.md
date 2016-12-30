> * 原文地址：[How to Write Clean CSS in 10 Simple Steps Pt2](http://blog.alexdevero.com/write-clean-css-10-simple-steps-pt2/)
* 原文作者：[Alex Devero](http://blog.alexdevero.com/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[王子建](https://github.com/Romeo0906)
* 校对者：[]()

# How to Write Clean CSS in 10 Simple Steps Pt2

[![How to Write Clean CSS in 10 Simple Steps Pt2](https://i0.wp.com/blog.alexdevero.com/wp-content/uploads/2016/12/How-to-Write-Clean-CSS-in-10-Simple-Steps-Pt2-small.jpg?resize=697%2C464)](https://i0.wp.com/blog.alexdevero.com/wp-content/uploads/2016/12/How-to-Write-Clean-CSS-in-10-Simple-Steps-Pt2-small.jpg)

Do you know how to write and maintain clean CSS? You can write CSS that is easy to read, understand and maintain. You only need to know some simple steps. Today, you will learn about five of them. We will discuss file structure. Then, we will talk about mixing CSS and JavaScript, and why it is a bad idea. We will also discuss how to prefix CSS better and how to automate it. Finally, you will learn how to deal with technical debt. So, let’s learn how to finally write clean CSS!

## Table of Contents:

**No.1-5 in** [**part 1**](http://blog.alexdevero.com/write-clean-css-10-simple-steps-pt1/).

**No.6: Lay out your file structure**

Keep it simple

How to structure your CSS code in a single file

**No.7: Keep CSS and JavaScript separate**

Why mixing CSS and JavaScript is a bad idea

How to use CSS and JavaScript in a smarter way

**No.8: Take care about vendor prefixes and fallbacks**

Avoid bloated CSS

**No.9: Make vendor maintenance easier, automate it**

**No.10: Manage your technical debt**

# No.6: Lay out your file structure

We ended the first part on how to write clean CSS by talking about modular CSS. Before we move to another step we should briefly discuss file structure. Modular CSS is useful on its own. However, it can quickly become overwhelming. Chances are that you are used to using a single stylesheet for all your CSS code. Then, going from one CSS stylesheet to, let’s say, 10 or 20 is a big difference. Let me give you one example of file structure following ITCSS.

Example:

    @import "settings.colors";
    @import "settings.global";
    
    @import "tools.mixins";
    @import "normalize-scss/normalize.scss";
    @import "generic.reset";
    @import "generic.box-sizing";
    @import "generic.shared";
    
    @import "elements.headings";
    @import "elements.hr";
    @import "elements.forms";
    @import "elements.links";
    @import "elements.lists";
    @import "elements.page";
    @import "elements.quotes";
    @import "elements.tables";
    
    @import "objects.animations";
    @import "objects.drawer";
    @import "objects.list-bare";
    @import "objects.media";
    @import "objects.layout";
    @import "objects.overlays";
    
    @import "components.404";
    @import "components.about";
    @import "components.archive";
    @import "components.avatars";
    @import "components.blog-post";
    @import "components.buttons";
    @import "components.callout";
    @import "components.clients";
    @import "components.comments";
    @import "components.contact";
    @import "components.cta";
    @import "components.faq";
    @import "components.features";
    @import "components.footer";
    @import "components.forms";
    @import "components.header";
    @import "components.headings";
    @import "components.hero";
    @import "components.jobs";
    @import "components.legal-nav";
    @import "components.main-cta";
    @import "components.main-nav";
    @import "components.newsletter";
    @import "components.page-title";
    @import "components.pagination";
    @import "components.post-teaser";
    @import "components.process";
    @import "components.quote-banner";
    @import "components.offices";
    @import "components.sec-nav";
    @import "components.services";
    @import "components.share-buttons";
    @import "components.social-media";
    @import "components.team";
    @import "components.testimonials";
    @import "components.topbar";
    @import "components.reasons";
    @import "components.wordpress";
    @import "components.work-list";
    @import "components.work-detail";
    
    @import "vendor.prism";
    
    @import "trumps.clearfix";
    @import "trumps.utilities";
    
    @import "healthcheck";

The example above contains 65(!) files. Now, tell me if this is not overwhelming. 65 files is a lot even for veteran web designer or developer. If you are a beginner, this can look like a madness. Sure, this example is not so usual. Also, the number of files depends on what methodology you choose. However, you should keep this on mind when you start new project. You should plan file structure for your project ahead. Don’t wait until you have no other option.

## Keep it simple

I will suggest doing two things. First, keep it simple. Second, find what works for you. You don’t have to use the same approach as is shown in the example above. I believe that one of the keys for using any architecture for modular CSS is customization. You don’t have to use it as it is, you can change it as you wish. In addition, you are free to combine multiple architectures. For example, in the first part, I told you that I use [Atomic design](http://blog.alexdevero.com/atomic-design-scalable-modular-css-sass/) with [BEM](http://blog.alexdevero.com/bem-crash-course-for-web-developers/) and a little bit of [SMACSS](https://smacss.com/).

You can do the same! If you like architecture X and also architecture Y, you don’t have to choose between them. You can take all the parts you like and use them. The same is true for file structure. If you want, use folders. If not, then don’t use any folders at all. Well, it might be better to use folders as it can help you with file management. However, it is up to you to decide. Just make sure you are comfortable working with it. Let me give example of structure I used in one of my projects.

Example:

    // Project imports
    // Import settings
    @import '_settings/config';
    
    // Import tools
    @import '_tools/functions';
    @import '_tools/mixins';
    
    // Import base
    @import '_base/normalize';
    @import '_base/base';
    @import '_base/typography';
    
    // Import atoms
    @import '_atoms/animations';
    @import '_atoms/buttons';
    @import '_atoms/inputs';
    @import '_atoms/inserts';
    @import '_atoms/labels';
    @import '_atoms/links';
    
    // Import molecules
    @import '_molecules/forms';
    @import '_molecules/gallery';
    @import '_molecules/jumbotron';
    @import '_molecules/navigation';
    @import '_molecules/pagination';
    @import '_molecules/parallax';
    @import '_molecules/slider';
    
    // Import organisms
    @import '_organisms/footer';
    @import '_organisms/grid';
    @import '_organisms/header';
    @import '_organisms/sections';
    
    // Import pages
    @import '_pages/404';
    @import '_pages/about';
    @import '_pages/contact';
    @import '_pages/homepage';
    @import '_pages/prices';
    @import '_pages/faq';
    
    // Import templates
    @import '_templates/print';

As you can see, I like to use folders to keep different layers of my architecture separate. I also like to keep the structure relatively simple compared to the first example of ITCSS. Remember, I use this because it works for me. If you like any of these examples, use it. If not, then don’t. The goal here is to use meaningful structure to avoid writing repetitive code. This is one of the biggest obstacles from writing clean CSS. Clean CSS is DRY CSS.

## How to structure your CSS code in a single file

The last thing we should talk about is how to structure your CSS if you use a single file. For the sake of this moment, let’s also assume that you are not using any preprocessor. Because the truth is that you don’t have to use any. Using preprocessor will not help you write good or clean CSS. A well-known fact is that if your CSS sucks, then preprocessor will usually only make it worse, not better. So, if you decide to use some, make sure to work on your CSS skills first.

That was a little sidetrack. The easiest way to organize your CSS code, and also a good practice, is to use comments. I use comments to organize my code in individual stylesheets as well. The reason is making the compiled CSS file more readable. Otherwise, it would be harder to understand where one import begins and another ends. Now, in my workflow I usually use two types of comments. Well, I use three types, but the third works only with Sass. Also, it is not compiled into CSS.

These two types of comments are single- and multi-line comments. I use multi-line comments to mark every import. In other words, I begin every import file with this type of comment. Then, when I want to indicate beginning of a sub-section, I will use a single-line comment. And, what about that third comment from Sass? I use this type when I want to explain some snippet or for to-dos. These notes have value only in development. They don’t have to be in code for production.

Example 1:

    /**
     * Section heading
     */
    
     /* Sub-section heading */

Again, remember that you don’t have to use the same comment style. There are many other comment styles. Let me give you a number of examples to fuel your imagination.

Example 2:

    /*
     * === SECTION HEADING ===
     */
    
    /*
     * — Sub-section Heading —
     */

Example 3:

    /* ==========================================================================
    SECTION HEADING
    ========================================================================== */
    
    /**
    * Sub-section Heading
    */

Example 4:

    /***************************
    ****************************
    Section heading
    ****************************
    ***************************/
    
    /***************************
    Sub-section heading
    ***************************/

# No.7: Keep CSS and JavaScript separate

Modular CSS and meaningful use of comments is great for maintaining clean CSS. However, none of these steps will work if you spread CSS code everywhere. What do I mean? Web designers are quite often defining CSS styles inside JavaScript. I think that this practice is more common among people using jQuery or some other JavaScript library. It is easier and faster to change CSS with jQuery than with vanilla JavaScript. However, this doesn’t mean that it is a good thing to do.

## Why mixing CSS and JavaScript is a bad idea

The problem with mixing CSS and JavaScript is that it is easy to lose track of it. It is something different to maintain clean CSS code across one or more CSS stylesheets. When you add JavaScript files to this, you are making your work harder. In addition, if you are also using preprocessor for JavaScript, you are really asking for a good labor. Should you avoid mixing CSS with JavaScript at all costs? Well, maybe not if you need to make a small change once or twice.

When you want to change one or two properties once or twice, JavaScript is an option. However, I wouldn’t recommend this if you want to change or set a set of properties. Or, if you want to make some styling change repeatedly. Then, you will have to write this code more than once. As a result, you will not maintain DRY code, not to mention clean CSS. Sure, you can use function to do the job. However, there is one thing you need to consider. Some devices may block JavaScript.

Although we are living in an era where technology is advancing fast, JavaScript is not something you can rely on on 100%. Thinking something else is stupid and arrogant. There is a chance that your website will be accessed by someone not using JavaScript. And, if some of your styles depend on JavaScript, they will not work. So, even if you don’t care that much about code organization, mixing CSS and JavaScript might not be a good idea.

## How to use CSS and JavaScript in a smarter way

So, the question is, how else can you dynamically change CSS styles and maintain clean CSS? Start by defining new CSS class with a set of rules in your CSS stylesheet. Then, use JavaScript to add to or remove this class from specific element as you wish. That’s it. You will not have to write the CSS code multiple times in JavaScript or use any functions to use it. One problem is that this will not help you solve the problem with blocked or disabled JavaScript.

This problem will require solution unique to your current situation. You can create a fallback that will work only if JavaScript is not supported. When JavaScript is supported, you will remove class for the fallback. As a result, these styles will not be applied. Feature-detection library [Modernizr](https://modernizr.com/) works in a similar way. We discussed how to use Modernizr for feature-detection and progressive enhancement [here](http://blog.alexdevero.com/html5-css3-feature-detection-modernizr/). For now, this is beyond the scope of this article.

So, to recap. For the sake of writing clean CSS, I would suggest keeping CSS and JavaScript code separate. If you need to change styles dynamically, use CSS class. Don’t change styles directly in JavaScript. Possible exception are changes on very small scale or changes you want to only once. And, if you have any problems with creating fallback for non-JavaScript situations, let me know.

# No.8: Take care about vendor prefixes and fallbacks

The eight step to writing clean CSS is using only the code that is relevant. This means that you should regularly review your CSS and remove old vendor prefixes and fallbacks. I am a huge proponent of using the latest CSS and JavaScript features. Yes, I like to experiment with these less or more experimental technologies. I think that web designers and developers should have the courage to use these technologies. And, not only in development, but also in production.

However, this also requires adopting more responsible approach to web development. You need to choose what browsers you want your website to support. Supporting only the latest version usually doesn’t work. You have to make sure your website is usable on a little bit wider range of browsers. For example, I usually include focus on IE11+, Google Chrome 49+, Firefox 49+ and Safari 9+. I test my projects on these browsers and use necessary prefixes and fallbacks.

This is only one part of the process. Another one is to revisit this code as browser usages changes and new features are implemented. When some browser is no longer relevant, you should remove prefixes and fallbacks you wrote for that browser. You should do this regularly if you want to maintain clean CSS. Otherwise, your CSS will become bloated. It will be full of code you no longer need. Browsers ignore prefixes when they fully support the features.

## Avoid bloated CSS

Unfortunately, all these prefixes are still present in your CSS. And, they make your CSS bigger than it could be. This is not such a problem in case of small projects. However, if you work with CSS on a large scale, these prefixes can cost add kilobytes to the size of stylesheet. In the terms of performance, every kilobyte matters. Also, more and more people are using mobile devices to access the web. And, not all of these people are using high-speed Internet connection.

It is a paradox. These devices are often running browsers that require all those prefixes. Yet, these devices also often use connections on which every kilobyte can make an impact. Finally, these users are also often less patient. Conclusion? You should make it part of your process to revisit outdated prefixes and fallbacks and remove this code. As a result, you will maintain clean CSS and your website will retain high performance. You can find more tips on website maintenance [here](http://blog.alexdevero.com/website-maintenance-web-designers-pt1/).

# No.9: Make vendor maintenance easier, automate it

Removing old prefixes is important for maintaining clean CSS. However, it can also be a pain in the butt. Who wants to every couple of months revisit the code and manually remove outdated code? Probably no one. There are much better things to do instead. Fortunately, there is a way to “outsource” this task. Well, there are two. Your first option is using task runner such as [Gulp](http://gulpjs.com/), [Grunt](http://gruntjs.com/) or [Webpack](https://webpack.github.io/).

These task runners will allow you to use plugins such as [autoprefixer](https://www.npmjs.com/package/autoprefixer). Thanks to this plugin you can outsource both tasks. When you run the task with this plugin, it will add prefixes only when it is necessary. And, it will also scan the stylesheet and remove prefixes that are outdated. All you need is to run the task. Your second option is to use small tool called [prefix-free](https://leaverou.github.io/prefixfree/). There is small difference is between autoprefixer and prefix-free.

As we discussed, autoprefixer works with task runners, as postprocessor. When you want to use prefix-free, you need to include it either in head or in body of your page. Then, it will run when the website is loaded and add necessary prefixes. Downsides? Another external resource and increase in bandwidth. Also, what if user has blocked or disabled JavaScript? However, it is still better than not prefixing at all. It is also easier than learning how to use task runners.

My suggestion? It depends :-). In the short term, and as a quick fix, prefix-free can be a better choice. Otherwise, I recommend taking aside some time and learning to use task runners. Learning to use task runner is worth your time. Task runners can make your life easier and work faster. My favorite is Gulp. You can learn to use this one in [Gulp for Web Designers](http://blog.alexdevero.com/gulp-web-designers-want-know/) article.

# No.10: Manage your technical debt

Let’s talk about the last step for maintaining clean CSS. Have you ever heard about something called technical debt? Technical debt occurs every time you quickly “hack” something together in order to solve some problem. This debt increases when you use code that is easy to implement instead of using the best overall solution. Technical debt is common in projects where you need to move fast and ship often. In other words, it is quite common in startups.

The problem with this debt is not that you are creating it. There are times when you can’t afford to spend days on creating perfect solution. Sometimes, it is necessary to use ugly solution you can implement immediately. For example, let’s say that you or someone else found a major issue with your website or product. And, this website or some other product is already in use. Then, you need to create fix quickly. Otherwise, you may lose a client or customer. The result is technical debt.

As I said, the problem is not creating technical debt. The real problem is forgetting about it. When you create technical debt, you should do only as temporary solution. Then, when you have more time, you should go back and replace that quick fix with some better solution. As a result, you will maintain clean CSS in the longer term. Unfortunately, I can’t tell you exactly how to reduce this debt. You need solution unique to your situation. However, I can give you three tips.

First, use some type of a backlog. Create a task every time you use scrappy solution. Don’t rely on your memory. Second, dedicate portion of your time to revisiting this backlog and work on individual tasks. Don’t let that debt and amount of tasks to become too big. Otherwise, it can be too overwhelming. You will not know where to start. Third, regularly refactor your CSS. Maintain clean CSS by keeping it [DRY](http://csswizardry.com/2013/07/writing-dryer-vanilla-css/). Reduce repetitive code. Use it often, but write it only once.

## Closing thoughts on how to write clean CSS

Congrats, you’ve just finished this second part and also this mini series! I hope these 10 tips we discussed will help you write clean CSS. I also hope that you will be able to maintain it in the long term. Let me tell you one secret. It is not so difficult to write clean CSS. What is difficult is being able to keep your CSS clean with time. It is also much harder to do that if you are not the only person writing it. However, if you start writing CSS with this intention, it can get easier.