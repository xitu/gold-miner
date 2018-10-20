> * 原文地址：[8 Tips for Great Code Reviews](https://kellysutton.com/2018/10/08/8-tips-for-great-code-reviews.html)
> * 原文作者：[Kelly Sutton](https://kellysutton.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/8-tips-for-great-code-reviews.md](https://github.com/xitu/gold-miner/blob/master/TODO1/8-tips-for-great-code-reviews.md)
> * 译者：
> * 校对者：

# 8 Tips for Great Code Reviews

_If you’re interested in receiving blog posts like this regularly, join hundreds of developers and [subscribe to my newsletter](https://buttondown.email/kellysutton)._

One of the things they don’t teach you in school is what makes for a great Code Review (CR). You learn algorithms, data structures, programming language fundamentals, but no one sits down and says, “Here’s how to make sure you give great feedback.”

Code reviews are a critical process to creating great software. Code that’s reviewed tends to be of [higher quality and have fewer bugs](https://blog.codinghorror.com/code-reviews-just-do-it/). A healthy code review culture provides ancillary benefits as well: you limit the [bus factor](https://en.wikipedia.org/wiki/Bus_factor), it’s a great tool for training new members, and code reviews are great ways of sharing knowledge.

## Assumptions

Before we dive in, it’s important to lay out a few assumptions for the points in this post. They are the following:

*   You work in a trusting environment, or you and your team are working to improve your trust.
*   You should be able to deliver feedback in non-code scenarios, or are working on delivering feedback within your team.
*   Your team wants to produce better code, and understands that _perfect_ is a verb not an adjective. We might find a better way of doing things tomorrow, and we need to keep an open mind.
*   Your company values high-quality code, and understands that things might not “ship” as fast. Ship is in quotes because many times under-tested and under-reviewed code may not actually work.

Now that we have a few ground rules set, let’s dive in.

## 1. We Are Human

Understand that someone put time into the code you’re about to review. They want it to be great. Your coworkers behave with the best of intentions, and no one wants to ship crappy code.

It can be very tough to remain objective. Make sure you always critique the code itself, and try to understand the context in which it is written. Take the edge off as much as you can. Instead of saying,

> You wrote this method in a confusing way.

Try instead to rephrase things to be about the code itself and your interpretation of it:

> This method is confusing me a little bit. Is there a better name that we can find for this variable?

In this example we’re explaining how we-as-the-reader feel about the code. It’s not about their actions or intentions. It’s about us and our interpretation of the code.

Every Pull Request is its own [Difficult Conversation](https://www.amazon.com/Difficult-Conversations-Discuss-What-Matters/dp/0143118447). Try to achieve shared understanding with your teammate and work toward better code together.

If you’re just getting to know a teammate and you have critical feedback on a Pull Request, walk through the code together. This will be a good chance to start buildling a relationship with your colleague. Do this with each coworker until it stops feeling awkward.

## 2. Automate

If a computer can decide and enforce a rule, let the computer do it. Arguing spaces vs. tabs is not a productive use of human time. Instead, invest the time in getting to agreement on what the rules should be. These are opportunities to see how well your team does with “disagree and commit” in low-risk scenarios.

Languages and modern tooling pipelines have no shortage ways to enforce rules (linting) and repeatedly apply them. In Ruby, you have [Rubocop](https://github.com/rubocop-hq/rubocop); in JavaScript, [eslint](https://eslint.org/). Find your language’s linter and plug it into your build pipeline.

If you find the existing linters lacking, write your own! Writing your own rules is pretty simple. At Gusto, we use custom linter rules to catch deprecated uses of classes or gently remind folks to adhere to some [Sidekiq](https://sidekiq.org/) best practices.

## 3. Everyone Reviews

It can be tempting to give all code review responsibilities to Shirley.

Shirley’s a wizard when it comes to code, and she always knows what’s best. She knows the ins and outs of the system and she’s been at the company longer than the collective tenure of your team.

However just because Shirley understands something does not mean it’s understandable to others on her team. Younger team members might hesitate to point things out on Shirley’s Code Reviews.

I find that distributing reviews around to different members of the team yields healthier team dynamics and better code. One of the most powerful phrases a junior engineer has in a code review is, “I find this confusing.” These are opportunities to make the code clearer and simpler.

Spread those reviews around.

## 4. Make It Readable

At [Gusto](https://gusto.com), we use GitHub to manage our code projects. Just about every `<textarea>` on GitHub supports [Markdown](https://github.github.com/gfm/), a simple way of adding HTML-formatting to your comments.

Embracing Markdown is a great way to make things readable. GitHub or your tool of choice probably has syntax highlighting, which is great for dropping in some code snippets. Using single-backticks (`` ` ``) for inline code or triple-backticks (` ``` `) for code blocks better communicates ideas.

Get comfortable with Markdown syntax, especially when it comes to writing code within comments. Doing so will help keep your reviews concrete and focused.

## 5. Leave at Least One Positive Remark

Code Reviews by their nature are negative affairs. _Tell me what’s wrong with this code before I send it into the ether._ They are raw affairs. Someone spent time on this and there is the expectation that you will point out how it could be better.

For this reason, always leave at least one positive remark. Make it meaningful and personal. If someone has finally gotten the hang of something they’ve been struggling with, call it out. It can be as simple as a 👍 or a “Love this.”

Leaving a few positive bits on each code review are subtle reminders that we’re in this together. We all benefit if we create better code.

## 6. Provide Alternatives

Something that I try to do—especially with those just learning a language or framework—is to provide alternative implementations.

Be careful with this. If presented incorrectly, it can come off as arrogant or selfish: “Here’s the way I would have done it.” Try to keep it objective and discuss the tradeoffs of the alternative you’re providing. Done well, this should help expand everyone’s knowledge of the technologies at hand.

## 7. Latency is Key

Turning around a Code Review quickly is incredibly important. (This is made much easier with the following rule: _Keep It Small_.)

Long Code Review latency can kill productivity and morale. Hearing about a PR you assigned for review 3 days ago is jarring. _Oh, yeah. What was I doing here?_ The back-and-forth is built-in context switching. To correct this, you’ll need to remind your team that progress is measure as a team and not the individual. Get your team caring about code review latency and get better as a team.

If you’re looking to reduce your own review latency, I recommend living by the following rule: _Review code before writing any new code._

As a tactic for addressing latency head on, try pairing on your code reviews. Grab a pairing station or fire up a screen share to walk through and discuss the review. Pair on the solution and get the code to an approved state.

## 8. For the Sender: Keep It Small

The quality of feedback you receive on a Code Review will be inversely proportional to the size of the Pull Request.

In the best interest of keeping the feedback poignant and constructive, know that smaller Pull Requests make it easier for the reader.

If you are keeping Pull Requests small (and avoiding [The Teeth](/2018/07/20/the-teeth.html)), you will need to have a different venue for bigger picture conversations. How does this single Pull Request fit into this week’s or this month’s work? Where are we going, and how does this Pull Request get us there? Whiteboards and ad-hoc conversations are great for these types of discussions. With smaller Pull Requests, it can be difficult to keep in mind the context in which it’s written.

“Small” will vary from language-to-language and team-to-team. For myself, I try to keep Pull Requests fewer than 300 lines total.

## Conclusion

Hopefully these 8 tips help you and your team have better Code Reviews. By improving your Code Review process you’ll have better code, happier teammates, and hopefully a better business.

What tactics do you use on your team for better code reviews? [Let me know on Twitter.](https://twitter.com/kellysutton)

* * *

Looking for more posts on feedback? Try the series [**Feedback for Engineers**](/2018/10/15/feedback-for-engineers.html).

Special thanks to [Omar Skalli](https://www.linkedin.com/in/omarskalli/), [Justin Duke](https://twitter.com/justinmduke), and [Emily Field](https://www.linkedin.com/in/emily-field-50b1a555/) for feedback on early drafts of this post.

If you’re interested in receiving blog posts like this regularly, join hundreds of developers and [subscribe to my newsletter](https://buttondown.email/kellysutton).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
