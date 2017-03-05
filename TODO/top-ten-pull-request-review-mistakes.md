> * 原文地址：[Top ten pull request review mistakes](https://blog.scottnonnenberg.com/top-ten-pull-request-review-mistakes/)
* 原文作者：[Scott Nonnenberg](https://scottnonnenberg.com/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： 
* 校对者：

# Top ten pull request review mistakes

I’ve worked on a whole lot of [GitHub](https://github.com/)-hosted projects, whether [personal](/star-wars-cards/#geeking-out), [open-source](https://scottnonnenberg.com/open-source/), or [on contract](https://scottnonnenberg.com/work). Sometimes using the public GitHub, and other times [GitHub Enterprise](https://enterprise.github.com/). But one thing is the same: it’s pretty easy to [submit a pull request](https://help.github.com/articles/about-pull-requests/), but it’s really hard to review a pull request well.

Without further ado, the **top ten pull request review mistakes** and some ideas on how to do better!

## 1. The mindless +1

It’s so tempting. The pull request is really big, and the submitter is someone you trust. They’ve been working in this part of the code for a while, and it has always worked out well. Not to mention that you have your own deadlines to hit!

    +1
    LGTM
    Ship it!
    

Snap out of it!

You need to spend real time to review that code. Everyone makes mistakes - seniority level is no magical ward against them. And your role, as the reviewer, is to use your creativity and expertise to reduce the chance that this pull request makes the codebase worse in any way.

That’s really the goal, isn’t it? If every pull request makes the codebase better, maybe the project really has some long-term potential!

## 2. Procrastination

Why review it now? After all, it really is a big pull request. And your current task is too important. You’ll eventually get around to it, right? Or, maybe you’ll just wait for others to chime in…

Search your feelings! Let the force flow through you! You might have some very real complaints behind that resistance.

Now that you’ve identified your real concerns, take action!

- If there isn’t enough guidance from the submitter on what’s going on in all these changes, ask for it! For example, where are the original requirements?
- If the changes are just too substantial to review at once, ask for them to be split up!
- If you don’t understand something, break through your pride and ask about it!
- If you’ve found a whole lot of problems/concerns, it may be time for some face-to-face interaction with the submitter.

## 3. Unified diffs

Are you reviewing gibberish? The default diff view on Github and GitHub Enterprise is ‘Unified.’ In this mode, to render a set of changes to a file, the software looks at added and removed lines and attempts to group blocks of changes intelligently, all inline. But you know what? In most cases, ‘Unified’ diffs are very hard to read. That intelligent block selection really isn’t.

The good news is that both [GitHub and GitHub Enterprise support ‘Split’ diffs](https://github.com/blog/1884-introducing-split-diffs). On the left is the old file, and on the right is the new file. You’ll see empty sections on the right if code was removed, or on the left if code was added. Either way, you can clearly see what the file looked like before and after, leading to better review decisions.

Don’t settle for the gibberish. Click on ‘Split’ in the top-right of the diff.

## 4. Style over substance

Very little time, if any, should be spent discussing code style and formatting during a pull request review. I’ve written before about [the need to use tools like ESLint to make these kinds of things completely automated](/eslint-part-3-analysis/#trying-to-adapt). Why? Because it’s a waste of time!

A good code reviewer spends the time to try to understand the [ultimate goals of the code changes](/understand-the-problem-dev-productivity-tip-1/), by going back to the original requirements. Is there a work item tracking this? A spec? What exactly was it asking for?

Only with that context can true review happen. What may look reasonable during a superficial structure/style review can become unacceptable when the ultimate goal is understood.

Yes, you might shy away from bringing up ‘big’ things like this because so much time has already been spent on the existing changes, but it’s worth talking about better solutions. It’s an opportunity to learn for everyone. You might even be wrong in your belief that there’s a better solution, but it takes a discussion with the original submitter to figure that out.

## 5. Not catching incomplete changes

Diffs are really great for showing you what has changed. But that’s the thing! By definition they don’t show you what *hasn’t* changed. Be on the lookout for changes which should have been applied more widely, like a find/replace that maybe didn’t cover the entire codebase.

Or a change that only hit a subset of the components it should have.

Or entirely missing tests. Tests are an important part of any change, but it’s actually very easy to forget about them if they’re not in the diff at all. You won’t be prompted to think about them.

I’ll admit, this is really hard! This is the hardest kind of review. It might help to do some quick sanity check searches in either the submitter’s branch or whatever you have on your own machine. Or you could ask the submitter about what kinds of comprehensiveness checks they’ve done beyond the code changes you can see.

## 6. Glossing over test code

Once there are some test code updates in the pull request, it’s easy to get lulled into a false sense of security. If they put some tests in, they must be high-quality and comprehensive. Right?

Wrong!

Testing is an art. It takes a lot of context to properly balance risk mitigation against testing cost, as appropriate for the area of the code and culture of the team. Pull request reviews are a great place for the team to build that shared context.

Some questions to consider:

- Are the test titles adequately descriptive?
- Are key scenarios captured?
- Are enough edge cases covered for comfort?
- What parts of the application are exercised by a single test? Too much? Too little?
- Are the tests written with good assertions? Can they ever fail? Will they fail too often?
- If a test fails, would it be easy track down the error?
- If new frontend behavior has been added, has it been added to the [manual test script](/web-application-test-strategy/#stage-0-real-usage)? [Browser automation tests](/web-application-test-strategy/#stage-4-automating-a-browser)?

## 7. Discounting frontend complexity

If a change is in the CSS and HTML, the inclination is to treat it like an algorithmic code change. You see well-formed changes and imagine what they would do in the browser. “Seems reasonable,” you say.

But it’s not so simple. What the user ultimately sees comes from the complicated interactions between your application and various rendering engines.

Get out of your head, and pull the branch down. Try it in multiple browsers and screen sizes, because this stuff is really tricky. Even if you’re an expert frontend developer, don’t trust yourself to eyeball this stuff. This is why [CodePen](https://codepen.io/) and [the like](https://www.sitepoint.com/7-code-playgrounds/) exist!

## 8. The narrow mindset

This is another area where you can be lulled to sleep by well-formed code in the diff. But it’s important to consider the large scale. With this new code now in the project, what changes? What could happen?

Some questions to get you started:

- Does this impact the size of the download for the user? Perception of performance? Does it change the user experience enough that it should be in the release notes, or an email to users?
- Does it introduce a new kind of code or feature? Does it require a new testing approach, new logging or monitoring techniques, or a deployment process change?
- Can it be exercised by users today, or is it behind a flag? What systems are in place to validate things behind flags?
- How hard is this to test comprehensively? What might be different in staging or production?

## 9. Short-term thinking

On some pull requests there is quite a bit of back and forth, maybe due to disagreements or just the need for clarification. This is really good stuff - it’s building shared context. But what happens when the next developer comes along and encounters this code? They won’t have easy access to this discussion.

Some ideas to build accessible context for the future:

- Capture key pull request discussion in code comments.
- Change code that was hard for reviewers to understand - it will be hard for others in the future as well!
- Create a place in the project for full conceptual documentation covering more involved, widely-applicable topics.
- Make sure all `TODO`s in the code are paired an item in your work item database, with enough detail to make it actionable by someone other than the original reporter.
- When reviewing, consider long-term maintenance of the code -  will it be easy to change? Easy to maintain in production? What’s the long-term cost?

## 10. Cursory review of amendments

Finally! The pull request has seen some lively attention, and it’s back in the submitter’s court. You’ve given your feedback, and the submitter is making some changes in response.

Now is not the time to forget about the pull request. You’ve discussed needed changes with the submitter, but that doesn’t mean those changes will be correct! Or even made at all!

Pull request amendments are some of the highest risk changes a developer will ever make, because everyone just wants to move on. Less care given in development, less care given in review.

Look especially closely at any updates to the original pull request, even though, yes, you’ve already reviewed the pull request comprehensively. If the new changes are separated into their own commits, this is easier. If the whole pull request has been newly [rebased/squashed](https://git-scm.com/book/en/v2/Git-Tools-Rewriting-History), then this can be a bit frustrating.

## It’s not easy!

It’s a hard job to design and implement software. Why would it be any easier to review it? In fact, review is probably harder because you have a whole lot less time to build up the right context to provide reasonable feedback.

But we can’t give up - it’s extremely important!

Use this article as a starting checklist, or an inspiration for one. Over time, you and your team can build up a custom list of reminders for important but easily-forgotten considerations. Eventually, your pull request process will become a powerful [feedback loop](/the-why-of-agile/#feedback-loops) for improving your team’s culture and code quality.