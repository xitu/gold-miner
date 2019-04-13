> * 原文地址：[Building accessible websites and apps is a moral obligation](https://machinelearningmastery.com/how-to-configure-image-data-augmentation-when-training-deep-learning-neural-networks/)
> * 原文作者：[ChrisFerdinandi](http://twitter.com/ChrisFerdinandi) 
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/building-accessible-websites-and-apps-is-a-moral-obligation.md](https://github.com/xitu/gold-miner/blob/master/TODO1/building-accessible-websites-and-apps-is-a-moral-obligation.md)
> * 译者：
> * 校对者：

# Building accessible websites and apps is a moral obligation

Yesterday, we recorded a [JS Jabber](https://devchat.tv/js-jabber/) episode (I'm a co-host on the show) with [Chris DeMars](http://chrisdemars.com/). (It comes out in a month or two.)

Chris has a strong focus on performance and web accessibility, and at one said something to the effect of:

> Building websites that are accessible is your moral obligation as a web developer.

I expected everyone to nod in agreement, but to my surprise, a few of my co-hosts actually disagreed with this position. At least one of them even said they would *not* want this legally required the way handicapped access is in physical businesses.

## I\'m sorry, what?

I don't think I've ever been quite so frustrated by a podcast episode before. Their positions (not mine!) were as follows:

1.  What's moral/immoral for me might not be the same for someone else.
2.  The beauty of the web is that the friction in starting and growing a business is low, and accessibility adds more friction.
3.  Handicapped people bear some of the responsibility in managing their own condition. This isn't entirely on us as developers.

My co-hosts were quick to point out that they think accessibility is a good thing, but not a *moral obligation*.

Today, I want to write some extended thoughts now that I've had more time to think about the episode and some of the things we talked about.

## Morality is not always relative

There's gray area, of course.

Is stealing immoral? What if the person has a starving, desperate family and no other options? Different people would answer that question differently.

But what about, for example, someone who builds homes for a living.

Let's say there are two ways to frame a house. One of them is simpler and faster, but about 20% of the houses randomly collapse after a couple of years. But there's a second approach, a bit slower, a bit more work, that keeps those houses standing for 100 years or more.

Would you say the builder has a moral obligation to *not* build a house that's going to collapse on people? (*If not, by the way, you might be an asshole.*)

So, too, it goes with websites.

You can quickly slap together a website or app in ways that make it unusable for people with physical and mental disabilities (an estimated 20% of the population), or you can take the time to build it right and make sure it works for everyone.

## You're a web *professional*

This is your fucking job.

You won't get it 100% perfect. It's pretty much impossible. But you need to care. You need to try. You need to educate yourself.

You wouldn't tolerate a builder who didn't bother reading the building code or educating themselves on how to properly build a house.

So why is that OK for us a builders of web things?

## The web is accessible out-of-the-box. *We* break it.

An HTML file with no CSS and no JavaScript is accessible by default.

Sometimes we break it by using the wrong HTML elements for the job. Sometimes we break it with CSS. Often, we break it by trying to do fancy stuff with JavaScript that breaks the way things normally work.

But that complaint about "adding friction" and "slowing down the dev process"... you're doing that to yourself with all of the unnecessary stuff you're trying to add, and you're breaking your own website in the process.

If you want to build something quickly, keep it simple.

## It's not on people with disabilities to tell you how you screwed up

One of my co-hosts argued that if a website is inaccessible, it's on the visitor with the disability to call customer service and let them know.

Nope. Fuck that.

It's not *my* responsibility to tell a builder they violated the building code, and it's not a user's job to tell a company their site isn't usable. It's the company's job.

Again, you're a web *professional*.

## It *should* be easier

One common theme was that accessibility should be easier. Here, I agree.

Often times it actually *is* relatively easy. There's tons of low-hanging fruit we get wrong, including...

1.  Adding `alt` attributes to images.
2.  Using the right elements for things (ex. `button` or link instead of a `span` or `div`for an interactive element).
3.  Not removing focus styles from focusable content.
4.  Using headings (`h1`, `h2`, etc.) that reflect the content structure, not for style purposes.

But for advanced features, things can get confusing. The proper markup structure, keyboard interactions, and aria attributes and roles for things like tabs, accordions, modals, and so on is tricky to get right.

The specs around these things are *not* written for the average person.

I would love more human-readable documentation on how to accessibility structure advanced components. [Dave Rupert's A11Y Nutrition Cards](https://davatron5000.github.io/a11y-nutrition-cards/) are a great start, but we need more, and it shouldn't be on Dave alone to build stuff like that.

Even better, I'd love to see native components for this stuff.

We've got [one for accordions and disclosures](https://gomakethings.com/javascript-free-accordions/) now, which is awesome. There's the `dialog` element for modals, but it has [lots of implementation and accessibility issues](https://www.scottohara.me/blog/2019/03/05/open-dialog.html). A native tab component would be awesome, too.

## This is our job

Regardless of how easy or not it is, this is our job.

If you build for the web, you have a moral obligation to make sure it works right for everyone. Building code is horrible to read, but builders still have to know it. Same goes for accessibility.

And as we've already discussed, the web is accessible by default. If you break it, you have to fix it.

Let's make 2019 the year we do a better job at this.

🚀 *The Vanilla JS Academy is back! The next session of the [Vanilla JS Academy](https://vanillajsacademy.com/)starts on May 6. Register today and make 2019 the year you learn to think in JavaScript.*

*Have any questions or comments about this post? Email me at <chris@gomakethings.com> or contact me on Twitter at [@ChrisFerdinandi](http://twitter.com/ChrisFerdinandi).*

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
