> * 原文链接: [Designing an in-app Survey](https://medium.com/budi-brain/designing-in-app-survey-6163304e88dd)
* 原文作者: [Budi Harto Tanrim](https://medium.com/@buditanrim)
* 译文出自: [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者: [Gran](https://github.com/graning)
* 校对者:


![](http://ac-Myg6wSTV.clouddn.com/1df377425299748db94f.gif)


Last week, one of my favorite apps sent me an email to take a survey. So, I thought why not helping them to improve their app? I tried to fill the survey out, but I just couldn’t finish the survey — it was too painful. One of the main problems is they asked 2–3 questions on one page that required me to move my screen a lot vertically or horizontally.

Horrible, horrible experience.

Later that evening, some ideas mixed up in my head about the possibility to make mobile-survey’s experience better. In this article, I’ll share my ideas, thoughts and processes on how I designed an in-app mobile surveyto get product feedbackfrom users.

There are a lot of elements to make a survey successful. But at the end of the day, all that matters is how to make a user willing to **take** the survey and committed to **complete** it. The survey has to be enjoyable in order to capture the optimal result that can be used for making a better business decision.

### The goals

So I decided to design an app that would:

*   Catch a user’s emotion and feedback quickly
*   Make a user complete the survey with minimum effort & pain
*   Design the least annoying approach to ask user to take the survey
*   Design a custom format and mixed it with the traditional survey knowledge.

This led me to achieve 2 main goals.

> **1st goal: Make the user willing to take the survey.
> 2nd goal: Design the survey for user so they can fill it out with minimum effort.**

![](http://ac-Myg6wSTV.clouddn.com/2bfba656090d9f59d0bb.jpeg)

### Understanding the user

Okay, everyone know that no one is really interested in “helping” the company to be better — matter of fact, no one give a sh*t. People are busy and are getting bombarded with a lot of notifications and emails. So, it is important to play this nicely and gently.

#### Know the timing

The first thing that I stressed on is to finding the best time to send out the survey. I have to find a sweet spot when the user is happy and excited, therefore they have more willingness to at least take the survey.

People called this a “post-event-survey”. Here is an example, let’s say.. today you have received a 27" monitor or backpack from Amazon you bought while ago. You are happy, excited to use it and the smile is still on your face. Chances are this is the moment it’s most likely for you to take the survey.

It‘s important not to sending out the survey to a new user that never experienced the product at all. From my point of view, a user who has been using our app for 2–4 times would have thoughts on what they were wish to improve. And hopefully, users are experiencing a positive experience which will build more willingness to take a survey. Make sense?

#### Ask gently

As you may have experienced before, pop-up are total crap. So, my next question would be what is the least annoying approach to ask user for take our survey?

> No matter what you ended up doing, some of your user will still get annoyed.

I explored many approaches, but I ended up with one winner at the time being. I would call it the “chameleon” method — basically the _request UI_ has to blended within the interface naturally. Unlike the pop-up method, this won’t require user any immediate action from the user. It’s there, and user will apparently take or reject it whenever they are ready.

![](http://ac-Myg6wSTV.clouddn.com/ba951989a233aaf03fbf.jpeg)

#### The exit scenario

Everyone makes mistakes, and there are a times where we mess up and we have to apologize to our users. If this is happens, instead of throwing the survey to an angry customer we can just ask for a simple feedback on what’s happening.

![](http://ac-Myg6wSTV.clouddn.com/dbbfad5e6ed8e082225a.jpeg)

It’s either get the feedback or get the survey; or get lost!

#### Incentivise the user

An additional point to encourage user is to give them a reward simply because they spare their time to answer the survey which will give us great data to work with. In my case, we will give a 50% discount for the next transaction.

I think this is the most debatable topic — whether or not we should give the user an incentive. The risk is that users might not be honest with their answers and are just aiming for the reward. Either way, I still think a reward is important, but to reduce this risk, I wouldn’t give a huge reward — on the other hand we cannot give a small reward, so we have to find a happy medium amount to keep things balanced, remember that we want users to feel appreciated.

_Great, we got this! At least we have one idea on how to make a user willing to take the survey._

![](http://ac-Myg6wSTV.clouddn.com/8a38c6f72e28fbed1a88.png)

Still hanging around here? Cool, here it comes for the fun part!

### The design process

What I aim for in the design is to creat a delightful experience for the user.

#### Creating low-fi prototype

This time, I borrowed a traditional animation technique. I drew a quick interaction in Photoshop to get the general feeling. With this, I can eliminate some concepts that I don’t like and focus on getting the optimal result. My main focus is finding the best layout for each question type such as Multiple choice, Rate scale and Rating order.

![](http://ac-Myg6wSTV.clouddn.com/accbc610aa69259bb97c.gif)

CAUTION: You might be disoriented and dizzy if you stare at this image too long because it’s not looped well.

#### Developing the look and tone

If you followed me on [Dribbble](http://dribbble.com/buditanrim), I have been designing for this concept project called [Shipp](https://dribbble.com/buditanrim/projects/375567-Shipp). By using the established design language I have, this allows me to quickly turned the wireframe into a higher fidelity design.

![](http://ac-Myg6wSTV.clouddn.com/5a026bd73925c9915206.jpeg)

#### Interaction design

I jumped into After Effects just to provide informations about page transitions and all interactions. _Usually this will help the developer and to help pitch the idea to the client._

![](http://ac-Myg6wSTV.clouddn.com/b0c23a662c7528572b9d.gif)

Opening — Rating Scale interaction

![](http://ac-Myg6wSTV.clouddn.com/b68f97712ac7f52c6cac.gif)

Checkboxes & Radios Interaction

#### Designing the emotion

As I mentioned in the title, I’m trying to capture user’s emotion. The idea is to ask user how do they feel about our main feature and let them express it with a simple answer. I was i**nspired by Facebook’s Reaction** on how do they capture expressions easily through emoticons.

At the beginning, I thought it would be best to have 5 emotions to mimic the “Likert scale” with an answer : _Extremely Happy, Happy, Neutral, Unhappy, Extremely Unhappy._

I could be wrong, but when I put myself as the user with these options — it’s a little bit overwhelming, I mean.. how can I tell the difference between extremely happy versus happy? In order to make this simple and straightforward, I decided to just have three obvious options such as:

*   Unhappy (Angry face)
*   Neutral (Flat face)
*   Happy (Happy face)

![](http://ac-Myg6wSTV.clouddn.com/cd4f0c0e3a802651ace6.jpeg)

Exploration for the emotion feedback icon

The happy face with hearts might be too much, but I just wanna having fun with this project. That being said, in the real world project — I might reconsider that one. But anyway…

#### Bring the emotion to life

After many exploration stages, I wanted to ask about important features such as our customer support relationship. I created this subtle animated emoticons to help user easily choose how they feel about our Support line. On top of that — I want to understand why do they feel that way. The first thing that crossed my mind was to provide a text-field where the user could type their reason. However, I don’t think that will be convenient for the user.

![](http://ac-Myg6wSTV.clouddn.com/2d141a6501cddb5996bc.gif)

Unhappy, Neutral, Satisfied.

So.. I came up with this solution.

![](http://ac-Myg6wSTV.clouddn.com/fe809b8ef108ec3be5a9.jpeg)

First, ask how do they feel.. then why.

![](http://ac-Myg6wSTV.clouddn.com/c79b4fc141d870c14b0b.gif)

I did some research and collect some data that make sense for me, I come up with some rule of thumbs. Below are the dos & don’ts and my assumptions.

#### Do(s):

*   **One question per page** — Don’t make your user scroll up and down, that’s just annoying.
*   **Consider the touch-space** — Optimize the space, don’t annoy your user by having them perform taps that accidentally miss the answer. It’s all about making a delightful experience.
*   **Keep it under 8 questions** — Most of the expert recommends say to keep things short. I think under 8 questions would be ideal. It’s better to optimize a small number of questions and make them really count.

### Don’t(s):

*   **Avoid drop-down** — Drop down is never a good idea; displaying the options on the screen right away is much better.
*   **Avoid use matrix table** — Don’t even think about it.
*   **Avoid use close-ended question **— Don’t give your user with yes/no questions. Let your user express themselves as openly as possible.
*   **Avoid typing action** — If possible, don’t make user type on mobile. It’s not a big deal, but I believe it might give you higher responses.

#### Things to consider:

*   **Incentive **— Many people agree that incentive is great and trigger user’s willingness. However, this is not always true. You have to figure out your customer and look at the context before deciding to give rewards or not.
*   **Progress bar **— It is true progress bar will let your respondent know how far done they are. However, if you have too many questions (which you should avoid anyway), consider not using progress bar since it might overwhelm your respondent.
*   **Use 3rd party surveys app** — Many services out there provide a service to make in-app surveys. However, you might not be able to tweak the design too much.
*   **Find industry benchmark** — Each industries’ response rate is different, try to find the ideal response rate in your industry for benchmarking.

#### Related links

*   [**Shipp**](https://dribbble.com/buditanrim/projects/375567-Shipp)_Project I used in this article_
*   [**chromaicon.com**](http://www.chromaicon.com)
    _Icon set I used in this project (still WIP)_
*   [**apptentive.com**](http://apptentive.com)[**converser.io**](http://converser.io)_Third party app for building in-app survey._

### What’s next?

#### So far, what I have is an assumption and concept.

I’m looking for an opportunity to use this concept in my future projects with great clients, and to see how effective these concepts are in real world projects.

If I get that chance, I will definitely share my process and talk more about how I process all the data to make a better design decision. Hopefully this concept somewhat helped and inspired you.

**Like this article will support me in writing and sharing more design ideas.**

**_Warmest_**_,
_[_Budi_](http://dribbble.com/buditanrim/)💐

_Special thanks to_ [_Adam Winn_](https://twitter.com/ajwinn) _for proof-reading this article._
