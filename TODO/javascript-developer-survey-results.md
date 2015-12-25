> * 原文链接 : [JavaScript Developer Survey Results](https://ponyfoo.com/articles/javascript-developer-survey-results)
* 原文作者 : [ponyfoo](https://ponyfoo.com/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者: 
* 状态 :  待定

There were over 5000 responses, 5350 to be exact, and I can’t wait to share the details. Before that I want to thank everyone who chipped in. This is a great time to be a part of the JavaScript community, and I’m truly excited for things to come!

I didn’t anticipate such high interest, and next time I’ll make some improvements to the format. Namely, I’ll put the survey up on GitHub first so that the community can collaborate on the questions and options for a couple of weeks before launching the survey. That way, I’ll be able to produce more accurate results and avoid complaints like “I am shocked you didn’t include Emacs!”.

Now, onto the survey results. I’ll remain impartial in delivering the results, so that you can come to your own unbiased conclusions.
##What type of JavaScript do you write?

A whooping 97.4% of respondents write JavaScript for a web browser, while 37% of them write mobile web applications. Over 3000 of them – with 56.6% – also write server-side JavaScript. Among those who took the poll, 5.5% use JavaScript in some sort of embedded environment, such as Tessel or a Raspberry Pi.

A few participants replied they use JavaScript in some other places, notably in developing CLI and desktop applications. A few also mentioned Pebble and Apple TV. These fell in the **Other** category, with 2.2% of the votes.

![An screenshot of the percentages for the first question](https://i.imgur.com/c0q4LvI.png)

## Where do you use JavaScript?

Unsurprisingly, 94.9% of voters use JavaScript at work. However, a large portion of the tallied – with 82.3% of the votes – also use it on side projects. Other responses included for teaching and learning, for fun, and for non-profits.

![An screenshot of the percentages for the second question](https://i.imgur.com/K5nSsyr.png)

## How long have you been writing JavaScript?

Over 33% of the surveyed have been writing JavaScript code for over six years. Out of those who answered the poll, 5.2% started at most a year ago, 12.4% two years ago, and 15.1% three years ago. That makes it 32.7% people who started writing JavaScript in recent years, out of 5350 voters.

![An screenshot of the percentages for the third question](https://i.imgur.com/P5ev9fL.png)

## Which compile-to-JavaScript languages do you use, if any?

A whooping **85%** replied that they compile ES6 into ES5\. Meanwhile 15% still use CoffeeScript, 15.2% use TypeScript, and a measly 1.1% reported they use Dart.

This was one of the questions I wish I’d approached more collaboratively, as it got 13.8% of _“Other”_ responses. The vast majority of these answers were ClojureScript, elm, Flow, and JSX.

![An screenshot of the percentages for the fourth question](https://i.imgur.com/12mL6u6.png)

## What JavaScript stylistic choices do you prefer?

The vast majority of JavaScript developers who answered the poll seem to favor semicolons, at 79.9%. In contrast, 11% indicated they prefer not to use semicolons. When it comes to commas, 44.9% favor to place them after an expression, while 4.9% prefer to use comma-first syntax. When it comes to indentation, 65.5% prefer spaces, while 29.1% would rather use tabs.

![An screenshot of the percentages for the fifth question](https://i.imgur.com/xwFVmS1.png)

## Which ES5 features do you use?

While 79.2% of respondents are on board with functional `Array` methods, and 76.3% indicated they use strict mode, `Object.create` sees a 30% adoption and getters and setters are only used by 28%.

![An screenshot of the percentages for the sixth question](https://i.imgur.com/W9pUOua.png)

## Which ES6 features do you use?

Notably, arrow functions are the most used ES6 feature among those who took the poll: 79.6%. Let and const together took 77.8% of the pollsters, and promises are also strong with 74.4% adoption. Unsurprisingly, only 4% of the respondents have played around with proxies. Only 13.1% of users indicated they’ve used symbols, while over 30% say they use iterators.

![An screenshot of the percentages for the seventh question](https://i.imgur.com/okcvuos.png)

## Do you write tests?

While 21.7% never write any tests, most do write some tests, and 34.8% always write tests.

![An screenshot of the percentages for the eighth question](https://i.imgur.com/0C944YL.png)

## Do you run Continuous Integration tests?

There’s a similar story with CI, although many more people don’t use a CI server – over 40%. Almost 60% of respondents use CI at least sometimes, of which 32% always run tests on a CI serve.

![An screenshot of the percentages for the ninth question](https://i.imgur.com/P04bJHG.png)

## How do you run tests?

59% like to run automated browser tests with PhantomJS or similar, and 51.3% also prefer to perform manual testing on a web browser. Automation in server-side tests amounts to 53.5% votes.

![An screenshot of the percentages for the tenth question](https://i.imgur.com/v09gVdQ.png)

## What unit testing libraries do you use?

It would seem most voters prefer either Mocha or Jasmine to run their JavaScript tests, although Tape received a healthy 9.8% of the ballots.

![An screenshot of the percentages for the eleventh question](https://i.imgur.com/20nUzJu.png)

It would seem like respondents are divided between ESLint and JSHint, but JSLint is surprisingly strong after all these years, at almost 30%.

![An screenshot of the percentages for the 12th question](https://i.imgur.com/RC8ePwr.png)

npm took over as the client-side dependency management system of choice, with 60% of the votes casted their way. Bower still holds 20% of the audience, and plain old `<script>` downloading and insertion managed to get 13.7% votes.

![An screenshot of the percentages for the 13th question](https://i.imgur.com/TOQiSZP.png)

## What’s your preferred build script solution?

Build tooling choices are divided, partially due to the healthy amount of different options to choose from. Gulp is the most popular, with over 40% of the votes. Using `npm run` is close by, at 27.8%, and Grunt got 18.5% of the audience.

![An screenshot of the percentages for the 14th question](https://i.imgur.com/xXlEE3E.png)

## What’s your preferred JavaScript module loading tool?

At the moment, it would seem as most people are torn between Browserify and Webpack, although the latter leads by almost 7 points. 29% of users indicated they use transpile Babel modules first, before presumably using one of the two aforementioned tools to pack their modules together.

![An screenshot of the percentages for the 15th question](https://i.imgur.com/pQPMC7V.png)

## What libraries do you use?

In retrospect, this was one of the questions which would’ve benefitted a lot from collaborative editing. jQuery is still going strong, with over 50% of votes casted its way. Lodash and underscore are used by a significant portion of the JavaScript population that participated in the voting, while the `xhr` micro library only clocked in 8% of the votes.

![An screenshot of the percentages for the 16th question](https://i.imgur.com/7jAwy05.png)

## What frameworks do you use?

Unsurprisingly, React and Angular are leading the pack. Backbone is still in a healthy position, with 22.8% of the votes.

![An screenshot of the percentages for the 17th question](https://i.imgur.com/zpSAISK.png)

## Do you use ES6…

Responses were quite divided in this question, with almost 20% never using ES6, over 10% using it exclusively, close to 30% using it extensively and almost 40% using it occasionally.

![An screenshot of the percentages for the 18th question](https://i.imgur.com/hAnbtfN.png)

## Do you know what’s coming in ES2016?

Roughly speaking, half of the voters don’t know what’s coming in ES2016, while the other half have an idea of what’s coming next.

![An screenshot of the percentages for the 19th question](https://i.imgur.com/DxxOnco.png)

## Do you understand ES6?

Over 60% of respondents seem to understand the basics, while 10% have no idea about ES6 and over 25% consider they understand ES6 really well.

![An screenshot of the percentages for the 20th question](https://i.imgur.com/w6obK3X.png)

## Would you say ES6 is an improvement?

Almost 95% of the respondents consider ES6 to be an improvement to the language. I’ll congratulate TC39 members next time I run into them!

![An screenshot of the percentages for the 21th question](https://i.imgur.com/c0RtfVK.png)

## What are your preferred text editors?

Again, very divided because of the variety of options. Over half the respondents like Sublime Text, and over 30% like to use Atom, its open-source clone. Over 25% voted for WebStorm and also for vi/vim.

![An screenshot of the percentages for the 22th question](https://i.imgur.com/Vt8ve7s.png)

## What’s your preferred development OS?

Over 60% of voters use Mac, while Linux and Windows users are close to 20% each.

![An screenshot of the percentages for the 23th question](https://i.imgur.com/PmLbtAo.png)

Respondents seem to favor GitHub and search engines, but there’s also a healthy dose of blogs, Twitter, and the npm website being consumed.

![An screenshot of the percentages for the 24th question](https://i.imgur.com/HpmV9yz.png)

## Do you engage in social JavaScript events?

Almost 60% have attended at least a conference, while 74% indicated they like going to meetups.

![An screenshot of the percentages for the 25th question](https://i.imgur.com/EnQWGzf.png)

## What browsers do you support in your JavaScript applications?

Quite divided answers, but fortunately most of respondents don’t have to deal with customers on IE6 anymore.

![An screenshot of the percentages for the 26th question](https://i.imgur.com/BV3eU0X.png)

## Do you learn about JavaScript latest features on a regular basis?

Around 80% of respondents try and stay up to date when it comes to the latest JavaScript features.

![An screenshot of the percentages for the 27th question](https://i.imgur.com/5TZUW2i.png)

## Where do you learn about the latest JavaScript features?

Unsurprisingly, the top-notch Mozilla Developer Network is leading the pack in terms of JavaScript documentation and news. JavaScript Weekly is also a very popular source of news and articles at almost 40% of respondents.

![An screenshot of the percentages for the 28th question](https://i.imgur.com/7Jlg7zh.png)

## Which of these features have you heard about?

Over 85% of voters have heard about ServiceWorker, although I’d be curious to know how many of those have played around with it!

![An screenshot of the percentages for the 29th question](https://i.imgur.com/8o3Jq2R.png)

There’s so many languages to choose from, I was bound to forget a few, but the results speak for themselves.

![An screenshot of the percentages for the 30th question](https://i.imgur.com/Tv9NciV.png)

## Thanks!

Lastly, I wanted to thank everyone who took part of the poll. It was far more popular than I anticipated and I’m looking forward to holding a similar poll next year. Hopefully, it’ll be one that’s even more diverse and perhaps a bit less biased.

> What are your take-aways from the survey?
