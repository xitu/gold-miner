> * 原文地址：[Unit testing, Lean Startup, and everything in-between](https://codewithoutrules.com/2017/03/12/software-testing-big-picture/)
* 原文作者：[Itamar Turner-Trauring](https://twitter.com/itamarst)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： 
* 校对者：

# Unit testing, Lean Startup, and everything in-between

Why do we test our software?

I used to think this was in order to produce high-quality code: you should always test you code because you always want to write high-quality code.
But this viewpoint has some problems.

**Sometimes quality is besides the point.**
In his book "Lean Startup" Eric Ries talks about building software only to discover that no one actually wanted to use it.
This was one of his motivations to develop a better methodology for creating startups, a way to figure out if a product will succeed *before* putting the time into building a quality product.
Ensuring high quality is a waste of time if no one will ever use your software.

**Even if quality is necessary, the connection between quality and testing is vague.**
How does testing by a QA team differ from an automated unit test?
They're obviously quite different, but exactly what kind of quality does each give?
When should you use a particular kind of testing?

**In addition, tests have costs: how can you decide if the costs outweigh the benefits?**
For example, consider a company that writes tax preparation software (I've changed the actual details a little.)
They wrote Selenium tests for their web UI... but their application was still buggy, and every time they changed the UI the tests would break.
The tests didn't seem to improve quality, and they wasted developer time maintaining them.
What did they do wrong?

Saying we should all just write high-quality software doesn't help address these issues.
So let's take a step back and think more deeply about testing.

## What does it mean to test?

The [best English dictionary](http://jsomers.net/blog/dictionary) tells us that to test is "to put to the proof; to prove the truth, genuineness, or quality of by experiment, or by some principle or standard."
Quality is in there, yes, but there's much more to it than that.

This is only an English definition, to be sure, and programming is not limited to English-speakers.
But I don't mean to argue that a dictionary definition can dictate what we *ought* to do.
Human language is an accumulation of centuries of looking at the world and trying to understand it, a repository of ideas that we can draw on.

Let's take this definition as a starting point and see what we can learn.

## The first dimension of testing

Is the following code a test?

    def test_add():
        assert add(2, 2) == 5
    

I would say that, yes, that's clearly a test.
Says so right in the function name, even.
The test proves that `add()` does what it ought to do: add two numbers and give us the result.

You've noticed, of course, that this test is *wrong*.
Luckily our development process has another step: code review.
You, dear reader, can act as a code reviewer and tell me that my code is wrong, that 2 + 2 is 4, not 5.

Is code review a form of testing?

According to the dictionary definition it is: the code reviewer is validating the code's "truth, genuineness and quality" by comparing it to a "standard", the arithmetic we all learned as children.

**Let's imagine code review as a form of testing, alongside automated unit tests.**
Even if they're both tests, they're also quite different.
What is the core difference between them?

One form of testing is automated, the other is done by a human.

An automated test is consistent and repeatable.
You can write this:

    def test_add_twice():
        for i in range(10000000):
            assert add(i, i) == 2 * i
    

And the computer will run the exact same code every time.
The code will make sure `add()` consistently returns that particular result for those particular inputs.
A human would face some difficulties in manually verifying ten million different computations: boredom, distraction, errors, slowness.

On the other hand, a human can read this code and tell you it's buggy:

    def add(a, b):
        return a + b + 1
    

Where the computer does what it's told, for good or for bad, a human can provide meaning.
Only a human can tell what the software is *for*.

Now we have one way of understanding what testing means, and how to organize it: **humans test for meaning, whereas automated tests ensure consistency.**

## The second dimension of testing

Let's consider another aspect of testing.
"A/B testing" is a form of testing where you try out two variations and see which produces a better result.
Perhaps you are testing a redesign of your website: you show the current design to 90% of your visitors, the new design to 10% of your visitors, and see which results in more signups for your product.

Is this a test?
It's called "A/B testing", so it seems like it ought to be.

Let's look at the dictionary definition again: "to put to the proof; to prove the truth, genuineness, or quality of **by experiment**, or **by some principle or standard**."

The dictionary thinks it's a test too, a test **"by experiment"**.
We're running an experiment to find out which version of the website will do best.

Unit tests and code review, in contrast, are tests **"by some principle or standard"**.
We have some intended specification for the software, some way we want it to behave, and we are trying to ensure it meets that specification.

Now we have a second way of understanding and organizing tests: **testing by experiment vs. testing against a specification.**

## The testing quadrants

Put both of these together and we get the following chart showing four different types of testing:

![](https://ww2.sinaimg.cn/large/006tKfTcly1fdorbapge0j312c13k0xb.jpg)

### User Behavior

- Will people buy your product?
- Will a design change result in more signups?
- Will users understand how your software works?

These are all questions that cannot be answered by comparing your software to a specification.
Instead you need empirical knowledge: you need to observe what actual human beings do when presented with your software.

### Software Behavior

- How does your software behave under load?
- Is your production system throwing exceptions?

These questions can't be answered by comparing your software to a specification.
You need to actually run your software and observe what happens.

### Correct Functionality

- Does your software actually match the specification?
- Does it do what it's supposed to?

It's tempting to say that automated tests can prove this, but remember the unit test that checked that 2 + 2 is 5.
On a more fundamental level, software can technically match a specification and completely fail to achieve the *goal* of the specification.
Only a human can understand the meaning of the specification and decide if the software matches it.

### Stable Functionality

- Does your public API return the same results for the same inputs?
- Is your code providing the guarantees it ought to provide?

Humans are not a good way to test this.
Humans are pretty good at ignoring small changes: if a button changes from "Send Now" to "Send now" you might not even notice at all.
In contrast, software will break if your API changes from `sendNow()` to `send_now()`, or if the return type changes subtly.

This means a public API, an API that other software relies on, needs stability in order to be correct.
Writing automated tests for private APIs, or code that is changing rapidly, will result in high maintenance costs as you continuously update your tests.

## Applying the model

How can you use this model?

### Choosing how to test

First, the model can help you choose what form of testing to do based on your goals.

Consider a startup building a product no one wants.
Writing automated tests is even more of a waste of a time, since it focuses on implementing a specification before figuring out what users actually want.

One way of doing that is the Lean Startup methodology, which focuses on experiments whose goal is finding what product will meet customers' needs.
That means focusing on the User Behavior quadrant.
Only later is it worth spending the time to have more than the most minimal of specifications, and therefore do more than a minimal amount of testing for Correct Functionality or Stable Functionality.

### Recognize when you've chosen the wrong type of testing

Second, the model can help you change course if you're using the wrong type of testing.
Consider the tax preparation startup that had automated UI tests which didn't find bugs, and broke every time they changed the UI.
Their problem was that their system really had two parts:

1. The tax engine, which is fairly stable: the tax code changes only once per year.
This suggests the need for Stable Functionality tests, e.g. unit tests talking directly to the tax calculation engine.
Correct Functionality could be ensured by code review and feedback from a tax accountant.
2. The web-based user interface
The UI was changing constantly, which suggests Stable Functionality wasn't a goal.
Correct Functionality was still a goal, so the UI should have been tested manually by humans (e.g. the programmers as they wrote the code.)

### A basis for discussing testing

Finally, the model provides a shared terminology that can help you discuss testing in its broadest sense and its many differing goals.

- Instead of getting into fruitless arguments about whether manual testing is a good idea or unit testing is a good idea, you can start with a model that shows very clearly the differences between them.
- You can also discuss testing with other parts of the company (e.g. marketing) that are starting from a very different point of view.

## Summary

- Testing is either automated, providing consistency, or by humans, providing meaning.
- Testing is judged either by the empirical results of an experiment or by comparing to a specification.
- Each combination provides a different form of testing: user behavior, software behavior, correct functionality, stable functionality.
- Make sure you choose the right form of testing to match *your* goals and situation.

Want to discuss this? Email me at [itamar@codewithoutrules.com](mailto:itamar@codewithoutrules.com).