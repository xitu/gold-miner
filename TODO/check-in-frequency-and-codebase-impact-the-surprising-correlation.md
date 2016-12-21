* 原文地址：[ Prolific Engineers Take Small Bites — Patterns in Developer Impact ](https://blog.gitprime.com/check-in-frequency-and-codebase-impact-the-surprising-correlation/ )
* 原文作者：[ Ben Thompson ]( https://blog.gitprime.com/author/ben-thompson)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Prolific Engineers Take Small Bites — Patterns in Developer Impact 

The work patterns of engineers reveal interesting things about their character, but it’s not what you might imagine.

### Our Hypothesis: Speedy vs. Bulky 

To explore this, we started with a hypothesis that some engineers on a team are better at turning work around fast, while others are better at burning through lots of work. If correct, this would lead to an interesting distribution of engineers across two axes: Frequency and Volume, yielding a chart that looked something like this:

![](https://blog.gitprime.com/hubfs/GitPrime/Blog/eng-character-1assumption-4.png?t=1481225729545)

But what does “volume” even mean?

### Finding ‘Big’ 

We tried all versions of 'big' we could think of. Since Lines of Code (LoC) is simple (though much reviled!), we started there to get a baseline. LoC doesn't actually work as an operational metric, for reasons we explore [in more depth here](//blog.gitprime.com/lines-of-code-is-a-worthless-metric-except-when-it-isnt/), but it did provide a starting point for something better.

The challenge is to find some metric that account for the fact deleting 50 lines of code and replacing them with 5 lines of more efficient code is arguably 'bigger' (e.g. more work) than contributing 100 new lines of un-edited prototype code: purely green-field work is often much easier than hunting down a pesky bug that results in a 4-line change.

We took a run at measuring the “bigness” of work from just about every other conceivable angle: overall code footprint, live lines in the codebase, lines that ‘stick,’ number of files hit, distinct edit locations — pretty much everything we could conceivably measure.

What ended up helping us crack this nut was the impressively large body of scholarly research around engineering work, particularly around commit normality: there is, in fact, such a thing as a ‘normal’ commit, and this ended up being the seed of a very reasonable proxy for engineering work, something we now call [‘Impact’](https://blog.gitprime.com/impact-a-better-way-to-measure-codebase-change).

With impact, we cross-weighted several data points in an attempt to approximate the cognitive load of engineering work and, after a bit of tuning, found something that maps to developer intuitions much better than LoC alone ever could.

### Learning that quick is big 

In analyzing millions of commits across thousands of teams, our initial theory about how engineers work turned out to be completely false.

Checking in frequently has such a tight correlation to an individual’s overall impact on the codebase that they are functional equivalents, resulting in banding that looks like this:

![](https://blog.gitprime.com/hubfs/GitPrime/Blog/eng-character-2actual-1.png?t=1481225729545)

Commit frequency moves in lock-step with overall impact to the codebase, by any other measure we came up up with.

This correlation is so strong, in fact, in analyzing over 20 million commits across thousands of teams, we did not find any strong counter-examples to this.

### High impact engineers take small, rapid bites 

This is sort of fascinating in itself, because saying “we need to do more work” is kind of a crappy way to approach improving throughput of an engineering team. Most engineers are already doing their best, so if the team needs to “do more work,” it’s not immediately obvious how that’s going to happen and just results in bad feelings.

What’s fascinating about this particular data set is that it suggests that there may be structural things to change the way we work that can net out to efficiency gains.

Breaking work into granular bits is already considered a best practice, but this data suggests it may be more than that: encouraging this (and developing feedback loops that help make sure sure it’s happening) looks to be a more actionable path to encouraging higher individual impact.

“Take small bites and check in frequently” is actionable and visible; saying “do more work” just acts as a stressor.

And this is a holistic gain: besides being generally good for an engineer’s ability to make a personal impact, smaller and more frequent commits yield other positive externalities for the rest of the team:

- More granular commits make it easier to find and track down bugs when something breaks
- It’s easier to roll back specific changes instead of a giant change set.
- Smaller work is focused and easier for team mates to review and integrate
- Lower process overhead for everyone with less merge commits

### A successful picture of engineering activity 

We did end up creating something that says a lot about engineering style, but it worked out a bit differently than we thought. We took everything we learned about impact and rolled this up into a single axis called *throughput*. Because of all our exploration, we were able to come up with a way of measuring code-impact that leaves behind the overly reductionist LoC view of software development (you can read more about how we’re calculating impact [here](http://help.gitprime.com/537-calculations/1606-what-is-impact)).

On the other axis, we plotted the *churn* rate — how much of an engineer’s focus is spent re-working recent code.

Plotting the result into a scatterplot can reveal quite a bit about an engineer’s work pattern over a specific timeframe in the context of the rest of the team.

![a successful framework for visualizing how software engineers work](https://blog.gitprime.com/hubfs/GitPrime/Blog/eng-character-3rev2.png?t=1481225729545) 

The resulting visual offers helpful clues about a team:

- In the **bottom left** quadrant, we retained the ‘stuck detector’ that we wanted from our original design.
- The **top left** highlights engineers who are exploring an implementation — we usually see engineers who are rapidly prototyping a new feature in this quadrant.
- The **bottom right** houses the “perfectionists” who have the lowest code churn on the team, but move a bit slower overall.
- Finally, in the **top right** are the engineers who are checking in lots of work, with little need for re-works — it’s generally a good idea to avoid interrupting these people, because they’re on fire!

---

**Notes:**

1. Thanks to [Bobby Wallace](https://twitter.com/bikeath1337) for help renaming the old “Exploring” quadrant, now called “Discovery”. [↩](#fnref:1) )

