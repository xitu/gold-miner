> * 原文地址：[Crafting Better Code Reviews](https://medium.com/@vaidehijoshi/crafting-better-code-reviews-1a5fc00a9312)
> * 原文作者：[Vaidehi Joshi](https://medium.com/@vaidehijoshi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# Crafting Better Code Reviews #

*Adapted and reworked from a talk originally given at RailsConf 2017.*

The intersection between humans and technology has never been simple or easy. This truth is particularly evident when it comes to the humans who *create* technology. As a human who also happens to write code for a living, I feel this the most during the code review process.

Most developers tend think of their code as a craft and — as seems to be the case with artists and most creators of all kinds — we become incredibly attached to our code. We’ve been told to be [egoless programmers](https://blog.codinghorror.com/the-ten-commandments-of-egoless-programming/), to critique not just our own code, but every single line of code that crosses our desk, as it waits to be merged into a project’s codebase. We’ve heard that having our own code reviewed by our peers and reviewing the code of our colleagues are both Very Good Things™, that [we should all be doing](https://blog.codinghorror.com/code-reviews-just-do-it/) . And a good many of us already happen to be doing all of these highly-recommended things.

But when was the last time we evaluated these methodologies? Are any of us sure that our code review processes are actually *working*? Are we certain that they’re serving the roles that they were originally intended to fill?

And if not: how can we try and make them better?

![](https://cdn-images-1.medium.com/max/800/1*INwRDJ_vspfJKkyFpv5jww.png)

© geek & poke, [http://geek-and-poke.com](http://geek-and-poke.com)

### Why even *bother* with review? ###

Before we can really understand the *practical* benefits of peer code review, it’s helpful to know why they even started in the first place. There has been a decent amount of [research](https://en.wikipedia.org/wiki/Code_review#References) around code review best practices, but I think that Steve McConnell’s research in [*Code Complete*](https://www.amazon.com/Code-Complete-Practical-Handbook-Construction/dp/0735619670) (originally published in 1993) is a good place to start.

In his book, he describes code reviews, and what function they *ought* to serve. He writes:

> One part of managing a software-engineering process is catching problems at the “lowest-value” stage — that is, at the time at which the least investment has been made and at which problems cost the least to correct. To achieve such a goal, developers use “quality gates”, periodic tests or reviews that determine whether the quality of the product at one stage is sufficient to support moving on to the next.

The most powerful aspect of McConnell’s case for code review on every single team is the way that he ties it back to something he terms the “Collective Ownership in Construction”: the idea that all code is owned by a group of contributors, who can each equally access, change, and modify the collectively-owned project.

> The original intent behind code reviews was that they would help us take collective ownership in the creation of our software. In other words, we’d each be stakeholders in our development process by having a hand in controlling the quality of our products.

McConnell goes on to highlight a few different types of code review processes that an engineering team can adopt into their everyday workflows. I strongly recommend that you pick up a copy of *Code Complete* and learn more about each of these techniques; for our purposes, however, a summary will suffice. There are three formats for a code review:

#### **1. Inspections** ####

Inspections are longer code reviews that are meant to take approximately an hour, and include a moderator, the code’s author, and a reviewer.

When used effectively, inspections typically catch about *60% of defects* (either bugs or errors) in a program. According to McConnell’s research, inspections result in *20–30% fewer defects per 1000 lines of code* than less formalized review practices.

#### **2. Walkthroughs** ####

A walkthough is a 30–60 minute working meetings, usually intended to provide teaching opportunities for senior developers to explain concepts to newer programmers, while also giving junior engineers the chance to push back on old methodologies.

Walkthroughs can sometimes be very effective, but they’re not nearly as impactful as a more formalized code review process, such as an inspection. A walkthrough can usually reveal *20–40% of errors* in a program.

#### **3. Short code reviews** ####

Short reviews are, as their name would suggest, much faster; however, they are still very much in-depth reviews of small changes, including single-line changes, that tend to be the most error-prone.

McConnell’s research uncovered the following about shorter code review:

> An organization that introduced reviews for one-line changes found that its error rate went from 55 percent before reviews to 2 percent afterward. A telecommunications organization in the late 80’s went from 86 percent correct before reviewing code changes to 99.6 percent afterward.

The data — at least McConnell’s *subset* of collected data — seems to suggest that every software team should be conducting *some* combination of these three types of code reviews.

However, McConnell’s book was first researched and written back in 1993. Our industry has changed since then and, arguably, so have our peer review methodologies. But are our implementations of code review today actually effective? How are we putting the *theory* behind code reviews into *practice*?

To find the answer to these questions, I did what any determined (but a little unsure of where to start) developer would do: I asked the Internet!

[![Markdown](http://i4.buimg.com/1949/4bcc14c27f51262e.png)](https://twitter.com/vaidehijoshi)

Well, okay — I asked Twitter.

### What do developers think of code reviews? ###

Before I dive into the results of the survey, a quick disclaimer: *I am not a data scientist.* (I wish I were, because I’d probably be a lot better at analyzing all of the responses to this survey, and maybe I’d even be halfway-decent at plotting graphs in R!). Ultimately, this means is that my dataset is limited in *many* ways, the first of which being that it was a self-selecting survey on Twitter, and the second being the fact that the survey itself presupposed a branch/pull request based team.

Okay, now that we have that out of the way: *what do developers think of code reviews?*

#### The quantitative data ####

We’ll try to answer this question by looking at the quantitative data to start.

First off, the answer to this question depends a lot on *which* developers you ask. At the time that I am writing this, I have received a little over 500 responses to my survey.

The developers who responded primarily worked in Java, Ruby, or JavaScript. Here’s how those responses break down in terms of developers and the primary language that they and their team work in.

![](https://cdn-images-1.medium.com/max/600/1*hiGuGx5OvayL4dPu1tSC4w.png)

I asked every respondent to the survey to what extent they agreed with the statement: *Code reviews are beneficial to my team*.

Overall, Swift developers found code reviews the *most* beneficial to their teams, averaging a 9.5 on a scale of 1–10, where 1 was *strongly disagree*, and 10 was *strongly agree*. Ruby developers came in a close second, averaging about 9.2.

![](https://cdn-images-1.medium.com/max/800/1*1zSl-fd9hygIBzxp52yHOQ.jpeg)

While the majority of survey respondents (approximately 70%) stated that all pull requests were reviewed stated that every single pull request was reviewed by someone on the team before being merged, this wasn’t the case on all teams. About 50 respondents (approximately 10% of the entire dataset) stated that pull requests were only peer reviewed in their teams when a review was *requested* by them.

![](https://cdn-images-1.medium.com/max/800/1*fVl3H0KGsauN1Bxs_jsN7A.jpeg)

The data seemed to suggest that this distribution, for the most part, carried across languages and frameworks. No one single language seemed to have an overwhelmingly different result in terms of whether all pull requests were reviewed, or if reviews had to first be requested. In other words, it would appear that it is not the language or the framework that results in a more consistent code review culture, but more likely, the team itself.

![](https://cdn-images-1.medium.com/max/800/1*jFZ_2zCzHM78m_L_p0OK8A.jpeg)

Finally, for those developers who were working on teams that *did* require for pull requests to be reviewed before being merged, it appeared that the majority of teams only needed one other person to peer review before merging code into the shared codebase.

![](https://cdn-images-1.medium.com/max/800/1*KsuH1lurvkf5wpoXZ2queQ.png)

#### The qualitative data ####

So what about the *unquantifiable* stuff? In addition to multiple choice questions, the survey also allowed respondents to fill in their own answers. And this is where the results actually proved to be the most *illuminating*, not to mention the most useful.

There were a few overarching themes that popped up repeatedly in the anonymized responses.

> Ultimately, what seemed to make or break a code review experience depended upon two things: how much energy was spent during the review process, and how much substance the review itself had.

A code review was bad (and left a bad taste in the reviewer’s and reviewee’s mouth) if there wasn’t enough energy spend on the review, or if it lacked substance. On the other hand, if a code review process was thorough, and time was spent reviewing aspects of the code in a substantive way, it left a much more positive impression overall on both the reviewer and the reviewee.

But what do we mean by *energy* and *substance*, exactly?

#### Energy ####

Another way of determining the **energy behind a code review** is by answering the question: *Who all is doing the review?**And how much time are they spending on it?*

A lot of respondents were conducting code reviews, but many seemed to be unhappy with who was doing them, and how much time they ended up spending while reviewing — or waiting to be reviewed.

Below are just a few of the anonymized responses to the survey:

> We have one dev who just blindly thumbs-up every PR and rarely leaves comments. That person is attempting to game the rule of “at least two approvals”. It is easy to tell, because inside of one minute they will suddenly have approved 5–6 PRs.

> I find that the 2nd or 3rd reviewer is often more likely to rubber stamp after seeing one approval.

> There have been times when the same code has been reviewed differently depending on who submits the PR.

> Everyone on the team should receive equal review. I feel like it’s so common for senior people to get no feedback because people assume they can do no wrong but they totally can, and might want feedback. And junior people get nit picked to death… remember people’s self esteem is likely to be affected and they’re being vulnerable.

> Commits are too big, so PR’s take long to review. People don’t check out the branch locally to test.

> Especially long PR’s take longer to be reviewed, which is an issue because they have the most effect on future branches/PRs/merges.

The overarching takeaways when it came to *how**much* energy was being spent (or not spent) on a code review boiled down to three things:

1. No one feels good about a code review process that’s just a formality & doesn’t carry any weight.
2. It’s not fun to review a long PR with code that you’re unfamiliar with, or have no context for.
3. To err is human, and we’re all human. We should all be reviewed, and review others fairly.

#### Substance ####

The **substance of a code review** boils down to the answer to one question question: *What exactly is someone saying, doing, or making another person feel while they review their code?*

The responses connected to the substance of a code review were, for the most part, grounded in what people were saying in their reviews, and how they were saying it.

Here are a few of the anonymized responses from the survey:

> I take any feedback on PR’s at face value. If changing that string to a symbol will make you happy, let’s do that and move on. I’m not going to try and justify an arbitrary decision. It’s not unlike working in an IDE environment, it’s very easy for my brain to fall into a “see red squiggle, fix red squiggle” mindset. I don’t really care why it’s upset, just make it stop yelling at me.

> Do not do big picture or architectural critiques in a review. Have offline conversations. Too easy to send folks down a rabbit hole and create frustration.

> I feel pretty strongly that it’s annoying when people demand changes, especially if they don’t take the time to explain why they’re doing so, or leave room for the possibility that they’re wrong. Especially when people just rewrite your code in a comment and tell you to change to their version.

> If a comment thread is getting long, it’s an indication a verbal conversation should be had (report the consensus back in the comment thread)

> People need to do better jobs distinguishing between their own stylistic preferences and feedback that makes a functional difference. It can be tough for a more junior person to figure out which is which. It’s also frustrating when multiple seniors give conflicting feedback (e.g. What to call a route and why).

The main themes when it came to the *substance* of a code review could be summarized into the following:

1. Comments nitpicking purely at syntax lead to a negative experience. Style and semantics are not the same thing. (Interestingly, 5% of respondents used the word ***nitpick***to describe code review comments in a negative context.)
2. The words we use to review one another’s code really do matter. An unkind review can break someone’s self-confidence.

### How do we do better? ###

Although this data may not be the most complete, full, or even the most *accurate* representation of our industry’s code review culture, there is one thing that seems like a fair claim to make: we could all stand to revisit our code review processes on our teams and within the larger community.

This anonymous survey response highlights the immense impact that a review process can have on members of an engineering team:

> A bad code review almost made me leave the company. A great code review leaves me feeling better equipped to tackle future projects.

Indeed, having *some* sense of a formalized code review is incredibly beneficial and statistically powerful; both Steve McConnell’s research and this small survey both seem to support this fact. But, it’s not just enough to implement a code review culture and then never think about it again. In fact, a code review process where members of a team are simply going through the actions of reviewing can be detrimental and discouraging to the team as a whole.

> Instead, it is the act of introspection, reflection, and reevaluation of our collective code review culture that will allow us to build upon any kind of formalized review process we might have.

In other words, it’s the act of asking ourselves whether our code reviews are effective, and whether they’re making a difference — both on the entire team, as well as the individuals who form it.

#### Easy ways to improve your code review process ####

There are a few ways to immediately make the code review process more painless and enjoyable for your team. Here are a few things to help you get started:

- Implement [linters](https://github.com/showcases/clean-code-linters) or a code analyzer (if available) in order to eliminate the need for syntactical comments on a pull request.
- Use [Github templates](https://quickleft.com/blog/pull-request-templates-make-code-review-easier/) for every pull request, complete with a checklist to make it easy for the author of the code and the reviewer to know what to add, and what to check for.
- Add screenshots and detailed explanations to help provide context to teammates who might not be familiar with the codebase.
- Aim for small, concise commits, and encapsulated pull requests that aren’t massive in size, and thus much easier and quicker to review.
- Assign specific reviewers to a PR — more than one, if possible. Make sure that the role of reviewing is equally distributed amongst engineers of each and every level.

#### The harder things — but the most important ####

Once you’ve picked off some of the low-hanging fruit, there are some bigger changes you can help bring about, too. These are actually the most important things to do if you want to change your code review culture.

And, let me warn you: that’s probably what makes them so hard.

- ***Develop a sense of empathy on your team.*** The greatest burden of making this happen falls on the shoulders of senior, more experienced engineers. Build empathy with people who are newer to the team or the industry.

[![Markdown](http://i1.piimg.com/1949/36f270199929bb1e.png)](https://twitter.com/sarahmei)

- ***Push for a culture that values vulnerability — both in actions and in words.*** This means reevaluating the language used in pull request comments, identifying when a review is on track to turn into a downward spiral, and determining when to take conversations offline, rather than questioning the author of the code publicly.

[![Markdown](http://i1.piimg.com/1949/51bfec74a7cf1e42.png)](https://twitter.com/j3)

- ***Have a conversation.*** Sit your team down, start a Slack channel, create an anonymized survey — whichever fits your group’s culture best. Have the conversation that will make everyone comfortable enough to share whether they are each happy with the current code review process, and what they wish the team did differently.

I saved the most important one for last because, honestly, if you’ve stuck with me and read this far, you must really want to change the status quo. And that really *is* a Very Good Thing™! Ultimately, though, having the conversation with your team is the most important first step to take in making that change happen.

This survey response summarizes why, far better than I ever could:

> I love code reviews in theory. In practice, they are only as good as the group that’s responsible for conducting them in the right manner.

#### Resources ####

If you’d like to view a larger collection of curated, anonymized survey responses, you can view the website that accompanies this project:

[![Markdown](http://i1.piimg.com/1949/2b892fa3a6988b39.png)](http://bettercode.reviews)

#### Acknowledgements ####

First and foremost, I’m deeply grateful to the hundreds of developers who took the time and effort to answer my survey.

A huge thank you to [Kasra Rahjerdi](https://medium.com/@jc4p), who helped me analyze the responses to my survey and created many of the graphs in this project.

Thank you to [Jeff Atwood](https://blog.codinghorror.com/code-reviews-just-do-it/), for his articles on peer reviews, Karl Wiegers for his work in [*Humanizing Peer Reviews*](http://www.processimpact.com/articles/humanizing_reviews.html), and Steve McConnell for his extensive research on code review processes in [*Code Complete*](https://www.amazon.com/Code-Complete-Practical-Handbook-Construction/dp/0735619670) . I hope you’ll consider supporting these authors by reading their writing or purchasing their books.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
