> * 原文地址：[7 absolute truths I unlearned as junior developer](https://monicalent.com/blog/2019/06/03/absolute-truths-unlearned-as-junior-developer/)
> * 原文作者：[Monica Lent](https://monicalent.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/absolute-truths-unlearned-as-junior-developer.md](https://github.com/xitu/gold-miner/blob/master/TODO1/absolute-truths-unlearned-as-junior-developer.md)
> * 译者：
> * 校对者：

# 7 absolute truths I unlearned as junior developer

![thumbnail](https://monicalent.com/images/typing-with-flowers.jpg)

Next year, I’ll be entering my 10th year of being formally employed to write code. Ten years! And besides actual employment, for nearly 2⁄3 of my life, I’ve been building things on the web. I can barely remember a time in my life where I didn’t know HTML, which is kind of weird when you think about it. Some kids learn to play an instrument or dance ballet, but instead I was creating magical worlds with code in my childhood bedroom.

In reflecting on this first decade of getting regularly paid money to type weird symbols into my Terminal, I wanted to take some time to share **some of the ways my thinking shifted over the years as a developer**.

For today’s junior developers: Maybe you’ll find something here you currently believe, and get inspired to learn more about it and why the topic is so multi-faceted. Or maybe you’ll find this post encouraging because you’re already so far ahead of where I was at your stage.

For today’s senior developers: Maybe you can relate, and also have some funny (and humbling) stories to share about your own life lessons when you were a junior dev.

To be clear, **I think junior developers are awesome** and just showing up to learn already takes a ton of courage. This post is about my own journey and learnings, and isn’t meant to be a generalization about how all junior devs think or behave.

I hope you enjoy the post and can relate a little bit 😄

> **Thanks to [Artem](https://twitter.com/iamsapegin) and [Sara](https://twitter.com/NikkitaFTW) for your feedback on this post!**

## Absolute truths I unlearned as a junior developer

### 1\. I’m a senior developer

I was 19 years old when I applied for my first technical job. The position I was applying for was called “Student Webmaster”. Which is a pretty awesome job title, because you could be considered both a “student” and a “master” at the same time. Nowadays everyone wants to be an “engineer” because it sounds fancier, but if you ask me, “master” is where it’s at. Anyways, my job was to write PHP and MySQL, and maintain our Drupal website as well as building some internal tools.

Since I’d been coding in my bedroom for a couple of years, I was pretty sure those years counted as “years of experience”. So when I was asked about how much experience I had writing PHP, I confidently answered, “3 or 4 years!”

I thought I knew a lot about SQL because I could do outer joins 😎

And when I googled it, 3-4 years of experience meant I should be making 💰

Fast forward to my latest job, which I got after 5 years of “combined” student and professional experience (which I thought was the same as normal experience). Yet in that time, I basically never had my code reviewed. I deployed by ssh-ing into a server and running git pull. I’m rather sure I never had to open a Pull Request. Don’t get me wrong, I learned a ton of awesome stuff at my first two jobs, but I’d never really worked with other devs in the same codebase. And yet, I applied for a position for “Senior Frontend Engineer”, got an offer, and accepted it.

**There I was, a senior developer at the ripe age of 24 years old.**

I mean they wouldn’t have given me this job title if I wasn’t really senior, right?! Surely, my impressive experience had brought me to this point, and people should listen to me!! Already at the pinnacle of my technical career, and the youngest developer in the office.

Like a boss 💅

> #### What I eventually learned
>
> **Not all experience is created equal.** My experience coding in my bedroom, working as a student, working in CS research, and working at a growing startup are all valuable kinds of experience. But they aren’t all the same. Early in your career, you can learn 10x more in a supportive team in 1 year, than coding on your own (or with minimal feedback) for 5 years. If your code is never reviewed by other developers, you will not learn as fast as you can – by an enormous factor.
>
> **That’s why mentors are so important**, and the team you work with is worth so much more than a couple bucks in your paycheck. Don’t accept a junior position where you’ll be working alone, if you can help it! And don’t accept your first role (or, honestly, any role) based on salary alone. The team is where the real value is.
>
> **I also learned that job titles don’t “make” you anything.** It’s kind of like, being a CTO with a 5-person team is different than with a 50-person team or a 500-person team. The job and skills required are totally different, even if the title is identical. So just because I had a “senior” job title did not make me a senior engineer at all. Furthermore, hierarchical titles are inherently flawed, and difficult to compare cross-company. I learned it’s important not to fixate on titles, or use them as a form of external validation.

### 2\. Everyone writes tests

For the first half of my career, I worked in research. Specifically, I worked on an publicly-funded project for about 3 1⁄2 years, and then at a university at the NLP chair for a year and a half. I can tell you one thing: **programming in research is completely different than programming in the industry**.

For the most part, you aren’t building applications. You’re working on algorithms or parsing data sets. Alternatively, if you are building an application, chances are your work is being publicly funded – which means it’s free for others to use and usually open-source. And when something is free, that means, for the most part, you are not **really** responsible to make sure it’s always perfectly available.

Because, well, it’s free.

You’re also not responsible to make any money or produce results, but that is an entirely different blog post ranting about being a developer in academia ✨

**Long story short, I left academia with lots of expectations.**

Expectations about how the industry would work. There would be automated deployment. Pull requests and code review. It was going to be glorious! Finally the [code quality](#4-code-quality-matters-most) I had been longing for! But beyond quality code with **proper standards** and **best practices**, I strongly believed, **everyone in the software industry writes tests**.

**Ahem.**

So imagine my surprise when I showed up at my first day on the job at a startup and found no tests at all. No tests in the frontend. No tests in the backend. Just, no tests.

Nada. Zip. Null. Undefined. NaN tests.

Not only were there **no tests**, but no one seemed to have a problem with the lack of tests! With a bit of naivety, I assumed the reason there were no tests was because people just didn’t know how to write tests for AngularJS. If I taught them how, everything would be OK and we’d start to have tests. Wrong! Long story short, years and years later, we’ve made huge progress on adding automated tests to our code, and it wasn’t as straightforward as I thought it would be.

But not because people didn’t know **how** to write the tests.

They’d either never felt the pain of not having tests, or they’d felt the pain of having **legacy** tests. Two things I’d never experienced for myself.

> #### What I eventually learned
>
> **Loads of companies and startups have little or no tests.** When struggling to find product market fit, or fighting for survival, a lot of companies neglect testing early on. Even companies that look fancy, sponsoring conferences or open-sourcing code – so many still have a big, gnarly monolith with minimal tests they need your help to improve. Ask devs who aren’t trying to recruit you to tell you about the state of the codebase.
>
> **No company has a perfect tech setup.** Every company has problems, every company has technical debt. The question is what they’re doing about it. We should have no illusions when applying for jobs that there is work to be done – or else they wouldn’t be hiring 😉
>
> **Being overly opinionated on topics you lack real-world experience with is pretty arrogant.** I came across as SUCH a know-it-all, insisting there must be tests yet having hardly any experience on what that really looked like at scale. Don’t be like me. It’s important to have principles, but also to be open and truly interested to understand other people’s experiences and perspectives.

### 3\. We’re so far behind everyone else (AKA “tech FOMO”)

This one is closely related to the topic of unit testing. While my company didn’t have many unit tests, **surely all the other companies did, right?**

I read so many blog posts. I watched conference talks on YouTube. I read “that orange website” all the damn time. It seemed like everyone was writing super sophisticated and high-quality applications with great performance and fancy animations, while I was just over here patching some stuff together trying to make it work in time for my deadline.

I basically idolized all the other companies I was reading about, and felt disappointment that my own company and project was so behind.

> #### What I eventually learned
>
> **Many conference talks cover proof of concepts rather than real-world scenarios.** Just because you see a conference talk about a specific technology, doesn’t mean that company is using that tech in their day to day work, or that all of their code is in perfect shape. Often people who give conference talks are presenting toy apps rather than real-world case studies, it’s important to distinguish the two.
>
> **Dealing with legacy is completely normal.** No but seriously, it’s easy to imagine that some other company doesn’t have legacy to handle. But after spending time at conferences talking to people who work at tippy top tech companies, it becomes clear that we are all in the same boat. What company DOESN’T have a huge PHP or Ruby monolith they’re trying to tame (or had to tame at some point)? Legacy code is normal, and learning to deal with it will often teach you more than building apps from scratch because you’ll be more exposed to concepts you don’t understand yet.

### 4\. Code quality matters most

Back in the day, **getting a code review from me could be brutal**.

At least, I was really nitpicky about coding style. MY coding style, which happened to be a modified version of the Airbnb JavaScript styleguide, but conforming to my personal tastes. Things like indendetation, formatting, naming – god forbid you did it differently than I would have. Passing a code review without at least one comment would have involved both mind-reading and winning the lottery.

Imagine 50+ comments on your PR with all the semicolons you missed!

Because I had eyes like an eagle and this eagle wants those high-quality semicolons 🦅

(Luckily I no longer have eagle eyes after staring at the computer for many years, so you’re all spared – #kiddingnotkidding)

> #### What I eventually learned
>
> **Good enough is good enough.** There’s a degree of diminishing returns when it comes to how “good” code needs to be. It doesn’t have to be perfectly clean to get the job done and not be a total disaster to maintain. Often code that is a little more repetitive or a tiny bit more verbose is easier for other people to understand. Also, “good code” is not the same as “code that looks like I wrote it”.
>
> **Architecture is more important than nitpicking.** While a small line of code could be improved, the stuff that tends to cause bigger problems down the line are usually architectural. I should’ve focused more on the structure of the application than tiny bits of code early on.
>
> **Code quality is important**, don’t get me wrong. But code quality wasn’t what I thought it was, which was things like linting and formatting or whatever style was promoted in the latest blog post I had read 🙈

### 5\. Everything must be documented!!!!

When I entered my first company, it was honestly the first time I was working a lot with code other people had written. Sure, I had done it a little bit at my first job, but I never really had to come into an existing codebase and to figure out what the heck was going on. That’s because the one time that happened, I rewrote all the code instead of trying to figure out how it worked.

Anyways.

It didn’t help that it was AngularJS code written by Ruby developers, or that I was a junior developer who didn’t know she was junior 🕵🏻‍♀️

So how did I handle the fact that 300 lines of unfamiliar code made me feel like I was drowning?

JSDOC. EVERYWHERE.

I started commenting **everything** just to try to make sense out of it. Annotations for every function I could get my hands on.

I learned all that fancy Angular-specific JSDoc syntax. My code was always twice as long because it had so much documentation and so many comments 👌

> #### What I eventually learned
>
> **Documentation lies sometimes.** It’s easy to think that documentation is a cure-all solution. “We need docs!” While I didn’t come to the conclusion that just because documentation is hard work, doesn’t mean it’s not worth doing at all, I learned that you have to document the right things in the right way. Over-documentation of the wrong things tends to lead to staleness, which can be just as confusing to people who are trying to fix an issue.
>
> **Focus on automation over documentation where appropriate.** Tests or other forms of automation are less likely to go out of sync. So instead I try to focus on writing good tests with clear language, so developers working on code I wrote are able to see how the project functions with working code. Another example is automating the installation of an application with a few comments, rather than a long and detailed installation guide.

### 6\. Technical debt is bad

If you thought I was neurotic from the last point, just wait until this one! For a while in my career, I thought that any code I considered “messy” was in fact **technical debt**. Technical debt is a funny term because if you ask people to give you an example of what it is, there are so many different things that it could be.

So as someone who viewed any kind of “disorderly” code as technical debt, I immediately tried to eliminate it with the utmost rigor!

I literally once spent a weekend manually fixing 800 linting errors.

That’s how neurotic I was.

**(Disclaimer: This was before auto-fixing was a thing)**

> #### What I eventually learned
>
> **Disorganized or messy code isn’t the same as technical debt.** Just because something doesn’t “feel nice” doesn’t mean it’s technical debt. Technical debt actually slows you down in some way, or makes certain kinds of changes difficult or error prone. If the code is just a little messy, it’s just a little messy. Tidying that up might not be worth my time.
>
> **Having some technical debt is healthy.** Sometimes we take a shortcut because we need to borrow time, and for that we give up some of our speed in the future. Having pieces of code that are in fact “technical debt” is okay, so long as you recognize you’ll likely need to pay that debt back. If you think your codebase is free of technical debt, there is a good chance you’re over-emphasizing **polish** instead of **delivery**. And boy did I do that!

### 7\. Seniority means being the best at programming

Having started at a rather young age to code, I’ve probably been proficient at doing for-loops for like 15+ years. Programming itself is like breathing to me. When a solution is apparent, I can just type away and the code will follow. It’s like writing a blog post or an email. I could code the solution faster than others, and typically took on the more complex projects for myself.

For a long time I thought that was what it meant to to be a senior developer.

Because why not? The job title is “senior developer”, not “senior communicator” or “senior project manager”. I didn’t really understand how many other skills I could possibly need to develop in order to be truly senior.

> #### What I eventually learned
>
> **Senior engineers must develop many skills besides programming.** The sheer number of skills I’ve had to develop in the mean time are astronomical, compared to what I came in with. Ranging from communication and dependency management to sharing context, project management, estimation, and successfully collaborating with non-developer peers. These skills are less quantifiable and take a lot of trial and error to get right.
>
> **Not everyone will become “senior” during their career.** Seniority is the result of many accrued years of experience. And yet, years of experience is a necessary but not sufficient condition for seniority. It also has to be the right kind of experience in which you internalized the right lessons and successfully apply those learnings for the future. Sometimes bigger lessons can take a year or more to fully manifest – that’s why years of experience still matter, even if you’re a really good coder.
>
> **We’re all still junior in some areas.** No matter how much experience you have, there are still places where you don’t know much. Admitting what you don’t know is the first step to filling in that gap and getting help from people who are more experienced.

---

**Bonus** – I really enjoyed this article called [On Being a Senior Engineer](https://www.kitchensoap.com/2012/10/25/on-being-a-senior-engineer/) . It’s a great read if you’re grappling with what point you’re at in your journey and find yourself wondering, “What does it mean to be senior?”

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
