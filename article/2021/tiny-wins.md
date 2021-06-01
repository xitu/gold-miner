> * 原文地址：[Tiny Wins - The big benefits of little changes](https://joelcalifa.com/blog/tiny-wins/)
> * 原文作者：[notdetails](http://twitter.com/notdetails)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/tiny-wins.md](https://github.com/xitu/gold-miner/blob/master/article/2021/tiny-wins.md)
> * 译者：
> * 校对者：

# Tiny Wins - The big benefits of little changes

Over the years, I’ve worked on many important, large-scale projects, from figuring out high level strategy and blue sky products, to overhauling core flows and IA, to implementing design systems from the ground up. 

Working on these big projects can be exhilarating. They’re often deemed critical by company leadership and various stakeholders, and it’s validating to be trusted with and attached to something so visible and impactful.

I recently shipped two things at GitHub that had an impact beyond my wildest dreams. The amount of gratitude and love that spilled out of the community is like nothing I’ve seen before. But the things I shipped weren’t these huge, meaty projects. They were **tiny**.

---

First, **we made the favicons for GitHub Pull Request pages dynamic**. Now browser tabs will always show a PR’s current build status. Before releasing this, users had to periodically click back into tabs to see if their builds had completed so they could continue their work. Impatient users would click back into various PR tabs a **lot**.

> A little hack week project [@notdetails](https://twitter.com/notdetails?ref_src=twsrc%5Etfw) and I just shipped. [pic.twitter.com/3EvfEmWtan](https://t.co/3EvfEmWtan)
> 
> — Jason Long (@jasonlong) [October 24, 2017](https://twitter.com/jasonlong/status/922900826607190016?ref_src=twsrc%5Etfw)

I put together new favicons and Jason worked on implementing the dynamic switch. This change took less than a week, and hundreds of people noticed it immediately. This is just a small sample of the many delighted responses.

  

My next project was **changing the `...` indicator on new PR pages to an arrow that indicated merge direction**. Before releasing this, people would regularly confuse which branch would be merged into which.

> Ever get confused between your “base” and “compare” branches? Shipped a tiny [@github](https://twitter.com/github?ref_src=twsrc%5Etfw) change today that will hopefully clear things up. [pic.twitter.com/acOddhxLDs](https://t.co/acOddhxLDs)
> 
> — Joel Califa (@notdetails) [December 4, 2017](https://twitter.com/notdetails/status/937823787495571456?ref_src=twsrc%5Etfw)

This was a one-line code change that took a few minutes. I didn’t even design the arrow — it was already in our icon set.

This tiny change solved a seemingly small frustration, but it turned out to be very significant to many of our users. Again, we saw hundreds of enthusiastic responses and shares.
  

## Low effort, high impact

The first of these changes took just under a week and the second took only a few minutes. Both changes affected very small sections of the platform, yet both enjoyed a passionate, almost euphoric reception. Users were **excited**.

That’s not to say that impact can or should be measured by the number of likes received (unlike, say, personal worth). But the individual responses tell a story of how meaningful even the smallest tweak can be to your users.

I can’t count how many times I’ve seen the following graphic in its various forms over the years:

![Matrix of low to high effort and low to high impact](/assets/images/blog/tiny-wins/evaluation.png)

The obvious advice, as seen in this version of it, is to execute on things that take little time and make big dents. Curiously, I haven’t seen many organizations actually take this advice to heart. Considering how valuable this type of work can be, I honestly don’t understand why.

Let’s discuss what changes like this can do for you.

### One small change can add up to a big win

High frequency actions (such as creating new PRs on GitHub) take place millions of times a day. A given user might go through the same flow several times per week, per day, or even per hour. These flows become a part of their lives.

If there is even a slight inefficiency or frustration, it compounds with every use. One confusing moment that takes an extra 5 seconds—repeated multiple times a day in perpetuity—adds up to a lot of anxiety and wasted time.

**That’s** why users are so thankful for these tweaks. They understand the significance of all that future time saved.

We can see similar reactions after Netflix added a button that let users skip a TV show’s intro sequence. Following this change, users no longer had to scrub back and forth through videos until they landed on the exact start of an episode.

  

We can see more responses along the same lines after Chrome released a volume icon that indicated which tabs were making noise. Following this change, users no longer had to click into every open tab to find the source of their discomfort.

  

Nobel prizes all around.

There are many more examples of this kind of overwhelming gratitude following similar tweaks. The changes may seem minor, but they resolved frustrations that were experienced over and over by **millions** of users. 

Imagine that one of your 20 Chrome tabs is currently auto-playing the most obnoxious video on the entire internet. The way you solve this is by trial-and-error clicking through every single tab. You didn’t find it the first time. How is that possible? Ugh, maybe you clicked into it without noticing. Let’s try again and again until finally, defeated, you close your entire browser. Rinse and repeat tomorrow and every other day for the foreseeable future.

![the experience in emoji form](/assets/images/blog/tiny-wins/bad-experience.png)

A dramatized reenactment.

Compare that to the experience of just closing the tab with the noise icon.

![a better experience in emoji form](/assets/images/blog/tiny-wins/good-experience.png)

You can think of the aforementioned changes as shortcuts. The intermediate steps (randomly clicking through your many tabs to find the source of your pain, or racking your brain for which git branch merges into which so you don’t accidentally break your company) are small paper cuts, but they add up. These changes get rid of them.

Getting your personal pet peeve fixed is powerful, often more so than new, more substantial features. Think about all that cumulative impact resulting from such little effort.

This is what I call a Tiny Win.

### Tiny Wins can strengthen your business

Let’s get this out of the way: large projects are important. If a company wants to continue innovating, tiny iterations like the ones above don’t quite cut it. So, to be clear, I’m not suggesting we begin planning roadmaps around these Tiny Wins. Ambitious projects should lead the way.

But large scale projects demand coordination, diligence, and — most of all — time. These things don’t happen overnight. In the time it takes to ship something of substance, a product can begin to feel stagnant. For a startup (especially one with viable competition) that stagnation can spell death.

To combat this, companies have to create an atmosphere of momentum, and prove to their users that they’re both listening and improving. They need to fill the long gaps between ambitious launches with smaller ships.

Many companies try to strike a balance by building MVPs and iterating from there. This, ideally, provides users with regular value along every step of the way. But each of these steps can still take anywhere from a two-week sprint to several months—and the output of each step is not always inherently valuable. It’s often the next small thing on the way to a more complete product.

In contrast, the various improvements I listed above are all self-contained. Netflix’s “skip intro” button is significant to users **in itself**. As is Chrome’s noise indicators and GitHub’s dynamic favicons.

Because of this, these changes were perceived and acknowledged as fresh, complete features. They communicated to users that **they were being listened to**. These features bred excitement, goodwill, and likely loyalty towards their respective companies. Hell, they probably even contributed to some organic growth.

MVPs and iteration are powerful tools that should be leveraged by companies looking to move quickly. But Tiny Wins are much more potent when it comes to filling the gaps, improving retention, and nurturing your community of users.

## Make Tiny Wins work for you

OK, so Tiny Wins are great and they have this cute name to boot. Obviously you’re sold on this. The next step, then, is to leverage them regularly and reap the rewards.

Now, your first instinct might be to open up your user feedback channels and start prioritizing issues. I’d caution against this.

I noticed something weird about the issues we solved with these changes. They were almost never reported.

Hundreds of people were ecstatic when we added that arrow to PR pages. Out of those, not a single one indicated that this flow was confusing. A lot of people assumed it was their own fault for not just “getting” it.

  

Others get so accustomed to these flows that they don’t even notice their anxiety. If they do, it’s just part of life. The status quo. Something to live with, not improve.

How many people recognized the act of scrubbing a video to find the start of an episode as improvable? How many people thought to ask the Chrome team to solve their noisy tab problems?

> Something something faster horses.” —Henry Ford

The lesson here is that you can’t trust your users to bubble up the small stuff, which as we’ve seen can often be the best stuff to build). This means that you can’t exclusively rely on existing user feedback and tickets. You need to dig deeper.

### Make a list, check it twice

Making a list of quick wins isn’t hard, but making sure that what you’re building is worth the effort can be trickier. Not every opportunity will have the kind of impact we saw above, and that’s what Tiny Wins are all about.

**Tiny Wins are standalone.** These changes are small, scoped, and provide their own value. If the change can’t be appreciated on its own, it doesn’t belong on the list.

**Tiny Wins are low effort.** These projects are straightforward, scoped, and takes a short amount of time. If the change requires a significant amount of time and effort, it doesn’t belong on the list.

**Tiny Wins are high impact.** They affect things that the majority of users interact with on a regular basis. If the change won’t have the compounding effects we’ve discussed, it doesn’t belong on the list. This means that something like addressing your system’s [dark corners](http://blog.capwatkins.com/dark-corners), while important and worthwhile, is not right for this list.

**Tiny Wins are often shortcuts.** They save a user’s time by getting rid of existing steps — **physical or mental** — required to perform an action. This is a really useful way to think about the types of changes we saw above, and a good way to differentiate them from other low-hanging fruits that don’t belong on your lists. At least initially, users will still remember the frustrating experiences they once had to deal with. They’ll remember them viscerally. That’s where the love comes from.

---

So start by setting up a meeting with as many perspectives as you can. Designers, Developers, PMs, Customer Success, and Support staff all have equally valuable insights here, but anyone with a finger on the pulse of your user base is especially important. Ask yourselves:

* What are your product’s most frequently used flows?
* What about those flows is frustrating? What regularly takes up time or cognitive load? This could be an extra click or an ambiguous component.
* How frustrating are these moments? What is the sum of time or frustration that fixing each of these small things will save? How many users would be affected?
* Will it be noticeable? Will it be shareable? Will it create joy?

Fresh eyes are extremely useful when it comes to answering these questions. I’d only been at GitHub for a few months when I added the arrow to the PR page, and I did that because it just **didn’t make sense** to me.

Designers, like users, get used to their product and its various quirks. In time, it can become increasingly difficult to see what could be improved. So try to include new employees in this process. Make it a part of your team’s on-boarding. And nurture an atmosphere that encourages your team to continue questioning the status quo even as they get to know the product.

Once you’ve populated the initial list, you can validate individual items with users and prioritize them based on effort/impact, as you would anything else.

### Now do the things on the list

Every organization is different, so there isn’t a universal process that’ll work for everything. What I **can** say is that the key element to make this work is a regular cadence. This is what will create a sense that the company is listening and moving quickly. This is what will breed trust in your user base.

* Include a Tiny Win in every sprint, or fill your downtime by picking items off the list. Make sure these tweaks are shipped frequently.
* Keep the list alive by including new people, adding new items to it, revalidating it, and reprioritizing it often.
* Make it a point to include your social media managers early in the conversation. Highlighting these features the right way is extremely important, and also fun!

That’s it. Not exactly rocket science. Not exactly novel. But very powerful.

I believe that getting into the habit of shipping Tiny Wins can do wonders for your brand. It can set you apart from competitors. It can show your users that you’re listening to them and that they can trust you. It can turn those same users into promoters, boost your NPS, and lead to organic growth. Most importantly, it’ll make your product, and the lives of your users, that much better.

Imagine all of that for such a tiny amount of ongoing effort. 

So… what can you fix today?

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
