> * 原文地址：[Design words with data](https://medium.com/dropbox-design/design-words-with-data-fe3c525994e7#.8dg1elnkf)
* 原文作者：[John Saito](https://medium.com/@jsaito)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

![](https://cdn-images-1.medium.com/max/1000/1*M1N7HJEyqpyaT71xVEBVSQ.jpeg)

# Design words with data

## How data informs our writing at Dropbox

Writing is a form of art. Words can make us laugh, move us to tears, or inspire us to do great things.

But I’d say there’s also a science to writing. Data can inform writing choices and help us think more objectively about what we write.

### What’s right and what’s wrong?

As UX writers at Dropbox, our goal is to make sure every word we write makes sense. One wrong word can break a user’s experience. A vague button label or unfamiliar term can easily frustrate users.

To make sure we’re choosing the right words, we use a few different techniques to help us make informed choices about our writing.

### 1. Google Trends

Let’s say you’re trying to decide between a few different terms, and you’re not sure which term is best. For example, which of the following should you use in your product?

- Log in
- Log on
- Sign in
- Sign on

One thing you can try is [Google Trends](https://www.google.com/trends/). Just enter all of these terms, separated by commas. Google Trends compares how often people search for these terms on Google. The search automatically includes phrases like “facebook log in” or “can’t sign in.”

So what does Google Trends say?

![](https://cdn-images-1.medium.com/max/800/1*9NBykN1q0YApaT2h4s4NCw.png)

Ta-da! Looks like “sign in” is the clear winner here. That means people are more likely to use “sign in” when referring to this action. If you want your words to match user expectations, “sign in” is probably a safer choice than the other options.

---

At Dropbox, we realized we were using different terms to refer to our “version history” feature:

![](https://cdn-images-1.medium.com/max/800/1*ohhKBv3jQfTbFB8CJapZ0Q.png)

We knew we wanted to fix these inconsistencies, but we weren’t sure which term to use. Should it be “version history,” “file history,” or maybe even “revision history”? There were a number of things we had to consider, but we used Google Trends as one data point to help inform us.

![](https://cdn-images-1.medium.com/max/800/1*HvjhGsKR3ZtutkZlfDToAQ.png)

Google Trends showed us people were more likely to search for “version history,” and that’s one big reason why we now call it “version history” throughout our product.

### 2. Google Ngram Viewer

[Ngram Viewer](https://books.google.com/ngrams) is similar to Google Trends, except it searches published books, scanned by Google. You can use this data to see which terms are more commonly used in your language.

Dropbox recently launched a new signature tool in our iOS app. On the screen where you draw your signature, the screen showed “Sign Your Signature” before we had a chance to review it.

![](https://cdn-images-1.medium.com/max/800/1*sGngF3GxPZhmfU2G7owU-g.png)

We knew that “sign your signature” sounded funny. But “sounds funny” isn’t a great reason for changing it. How could we convince the team to change it?

That’s when we headed over to Ngram Viewer and compared “sign your signature” with “sign your name.” It showed us that “sign your signature” wasn’t really used at all. When we shared this data with the team, they quickly changed it to “Sign your name.”

![](https://cdn-images-1.medium.com/max/800/1*Pg44k4J9VFHaEjQZcr0UwA.png)

### 3. Readability tests

Over the years, language experts have developed a number of readability tests that measure how easy it is to understand your words.

Many of these tests give you a grade level for your writing. For example, a grade of 8 means that a typical 8th grader in the U.S. should be able to understand your writing.

I ran one of my Medium stories ([*How to design words*](https://medium.com/@jsaito/how-to-design-words-63d6965051e9#.i3r1l4g4h)) through one of these tests. Here’s what it told me:

![](https://cdn-images-1.medium.com/max/800/1*Y-EsgPfmIQ_S-2XxMMA9Tg.png)

There’s a lot of interesting data you can get from here. For example:

- I wrote the story at a **6th-grade level**.
- My tone was **neutral** but **slightly positive.**
- I averaged **10.7 words per sentence. **(At Dropbox, we try to keep our sentences to 15 words or less.)

If you want to give one of these tests a spin, below are a few you can try. Some of these tests even give you suggested edits to make your writing more readable.

- [Readability-Score.com](https://readability-score.com/)
- [Hemingway Editor](http://www.hemingwayapp.com/)
- [The Writer’s Readability Checker](http://www.thewriter.com/what-we-think/readability-checker/)

### 4. Research surveys

Trying to figure out what to name your new feature? Or what value prop to focus on? In cases like these, it can help to set up a research survey.

Many survey tools allow you to choose your target audience, so you can easily get feedback from potential users.

Here are a few places where you can set up research surveys:

- [UserTesting](https://www.usertesting.com/)
- [SurveyMonkey](https://www.surveymonkey.com/)
- [Google Consumer Surveys](https://www.google.com/insights/consumersurveys/home)

Back in the day, Dropbox ran a survey to figure out what was the biggest benefit to using our product. Most people mentioned “access” — the ability to get to your files from any device. As a result, a lot of the messaging we used in our landing page redesign focused on access.

![](https://cdn-images-1.medium.com/max/800/1*bbe8abkKDJ7ijX9wo-sD_A.png)

### 5. User studies

User studies are a great way to get valuable feedback about your writing. In a typical user study, you invite a number of people to read your text or try out a product, and then you ask them questions about it. This can be incredibly helpful for seeing whether your writing makes sense or not.

One of our researchers recently ran a study where we tested a new flow. There was one step that said:

> Select “Remove local copy” to save space.

We asked participants when they might use this feature. Most had a tough time understanding this feature and didn’t think it was useful. So then we flipped the order of the words by putting the user benefit at the front of the sentence:

> Save space by selecting “Remove local copy.”

This time, participants had a much easier time telling us when they’d use this feature. And all we really did was change the order of the words.

This shows how a writer’s hunch can turn into an experiment, and you can test it just like any other design decision.

### Write with your heart, edit with your head

Data can be useful when you’re trying to make specific writing choices. But that doesn’t mean you should write like a machine.

The way I see it, your first draft should always come from the heart. Trust your gut. After you’ve written out your ideas, that’s when you can turn to research and data to refine your words.

Writing is both an art and a science. By writing with your heart and editing with your head, you can craft something that’s both authentic and informative.

Data gives you confidence as a writer. Data is what makes your writing “right.”
