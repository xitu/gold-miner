> * 原文地址：[5-rules-for-designer-engineer-collaboration: Tips to Improve Quality and Productivity](https://medium.com/tradecraft-traction/5-rules-for-designer-engineer-collaboration-182fd74bd09f?ref=uxdesignweekly)
> * 原文作者：[Andrew Yang](https://medium.com/@andrew.yang804?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/5-rules-for-designer-engineer-collaboration.md](https://github.com/xitu/gold-miner/blob/master/TODO1/5-rules-for-designer-engineer-collaboration.md)
> * 译者：
> * 校对者：

# 5 Rules for Designer-Engineer Collaboration

## Tips to Improve Quality and Productivity

![](https://cdn-images-1.medium.com/max/800/1*hNscHHl45Q6s3dARFiaw0A.jpeg)

Designer vs Engineer via [society6](https://society6.com/).

Designers and engineers are seen as complete opposites. Designers are portrayed to be sensitive creatives, and engineers as cold logisticians. However, as a former software engineer turned product designer, I can say that these opposites _can_ work together effectively in the workplace. With just a bit more understanding of the other’s role, the designer-engineer relationship can be vastly improved. Here are five general guidelines for designers to follow when working with engineers, followed by another five from the engineer’s perspective.

### 5 “Rules” for Designers:

![](https://cdn-images-1.medium.com/max/800/1*RlD_EebvaZt--pxPDmc0rQ.jpeg)

Photo by [William Iven](https://unsplash.com/@firmbee) via [Upslash](https://unsplash.com)

#### 1) Avoid Custom Styles

Practically all front-end engineering teams use some type of library or CSS framework for styles used across the app. These libraries often contain common styles such as pre-defined margins, colors, and other classes that engineers use to make development faster and more consistent. This means that if you decide to sprinkle in a custom margin, font size, or component, the engineer has to write custom CSS from scratch to override base styles. This is fine once in a while, but it gets tedious really quickly. Save these custom styles for special occasions or when absolutely necessary. After all, designing within a framework simplifies many decisions for us, which is often a good thing.

#### 2) Pull Engineers in Early

Let’s be real, unless you’re working for an early stage startup or you’re the VP of engineering, engineers don’t get much product say. Setting product vision is generally up to execs, product managers, and product designers to an extent. However, even if engineers don’t get much input, they can still _feel_ like they do. When you’re in meetings with product managers, pull in an engineering lead. Additionally, set up some design reviews with your engineering team to go over your designs. Explain to them why you made the design decisions you made, and ask them for feedback. If engineers feel like they contributed to the design process, they’ll naturally put more care when implementing your designs.

#### 3) Listen to Engineering Feedback*

Believe it or not, engineers are often pretty decent designers. Particularly regarding UX, I’ve worked with many engineers who have a great design sense. These engineers want to be heard, and their feedback can be very valuable and is often on-point. When engineers you trust give you feedback on your designs, listen. Even better, show them that you’re listening by taking out a notebook and jotting their ideas down. You don’t have to use every idea, but give them their due respect, and some suggestions are bound to stick.

*Of course, not all design feedback from engineers is good. Just take it with a grain of salt, and approach it with an open mind. You’ll often learn something, and everybody likes to be heard.

#### 4) Understand Basic HTML/CSS/JS

![](https://cdn-images-1.medium.com/max/800/1*uL5yjFLIeRYvmZR9w3mLHg.png)

One of the best designers that I worked with while I was a software engineer at [SalesforceIQ](https://www.linkedin.com/company/salesforceiq/) could go directly into the web inspector with me and rapidly prototype with HTML/CSS directly in the console. It’s incredibly reassuring as an engineer to know that the designer you’re working with understands the technology you’re using, and is designing with these constraints in mind. It’s definitely not necessary to have full-on, front-end development skills to be a good product designer, but some basic front-end knowledge goes a long way. Gain the respect of your closest peers — learn some code.

#### 5) Batch Minor Fixes

[Flow](https://en.wikipedia.org/wiki/Flow_%28psychology%29) is a state where engineers are most productive — it pretty much means being “in the zone”. Engineers require large blocks of uninterrupted time to achieve flow. This is why meetings are best scheduled at the beginning or end of the day, and constant interruptions are the bane to an engineer’s existence. Yes, this means that the idea you had while showering this morning of using a darker shade of blue for buttons can wait. Design is an iterative process, and there will undoubtedly be ongoing changes to the product. However, let these small changes accumulate before going to the engineer for an ask. For example, set a baseline of five minor changes before approaching an engineer for a fix. Nothing annoys engineers more than breaking their flow just to change a button’s color seven times.

* * *

### 5 “Rules” for Engineers

![](https://cdn-images-1.medium.com/max/800/1*h-pctC-YtNZT8Os_pb8BxA.jpeg)

Photo by [William Iven](https://unsplash.com/@firmbee) via [Upslash](https://unsplash.com).

#### 1) Understand the Use Case

As an engineer, you have tons of power to create at your fingertips, and it’s really easy to jump right into code. However, with great power comes great responsibility. Take a step back, and understand the “why” of the product or feature that you’re building. Go talk to your product manager and your product designer. Understand why the feature is being built, and why it’s designed the way it is. Without this insight, you’re just pushing pixels around the screen. Alternatively, with an understanding of the product, you’ll be able to consider all the different use cases and edge cases with your implementation, and take your code to the next level.

#### 2) Implement UX First

In an agile environment, design is constantly iterating based on user testing and feedback. The blue button with a five pixel border-radius and box-shadow you painstakingly implemented yesterday is now a green button with flat design and sharp edges. Wrecked. However, don’t get discouraged: just accept that this is a part of the product development process. Implement the UX — the flow, functionality, and general layout of the design first. Get the overall feel down, but don’t go crazy on pixel-perfect implementations yet. Once the design has gone through more iterations of testing and versions have stabilized, gradually incorporate in the visual elements.

#### 3) Push Back

![](https://cdn-images-1.medium.com/max/800/1*595UUrTLxUioKqL6TjMaTg.gif)

Remember the last time your designer asked you to implement a custom component that changes colors and does a flip every other minute? Yeah, don’t do that. Design is a two-way street. Don’t be afraid to push back and give feedback on technical constraints and limitations. For the most part, even the best designers won’t have your technical chops or understanding of the system. However, instead of just pushing back and saying “this can’t be done”, always provide an alternative solution. Try, “this solution will be very costly to implement, may I suggest…”. Remember that most things _can_ be done with the tools we have today, but that doesn’t mean everything _should_ be done. It’s your job as the engineer to help the designer reach the best, most cost effective solution to a problem.

#### 4) Check-in with Designers Often

Communication is really the theme of this article. As you’re implementing a design, make sure to consistently show the designer your progress. Designers love seeing their work come to life, so it’s really a fun thing for everyone. Keeping the designer up to date with your progress will help ensure that your implementation is up to expectations, and there aren’t any surprises down the road. This is also a great opportunity to ask the designer any questions that you may have about the design, or tasks going forward.

#### 5) Fill in the Gaps**

When implementing a design, there will always be points where you need to use your own best judgement to fill in the gaps. The design you implement is not going to look exactly like the design that was handed to you — that’s just the bottom line. There will be points when you realize a larger margin is needed on some screens, or a particular color looks off in the actual application. Don’t go running to the designer with a question every time. Put your designer hat on and make the call yourself on smaller tweaks. You have what it takes.

**But also don’t go too crazy, and communicate with your designer about bigger decisions. Use your best judgement :)

* * *

And there you have it! These are the five rules I compiled for both designers and engineers to improve their workplace collaboration. These rules are all totally subjective, and come from my previous experience as a software engineer, and my current experience as a product designer. Let me know if you agree or disagree with my points, and let’s continue the conversation down below!


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
