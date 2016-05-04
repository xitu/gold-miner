>* 原文链接 : [10 things you probably didn't know about JavaScript (React and Node.js) and GraphQL development at Facebook](https://hashnode.com/post/10-things-you-probably-didnt-know-about-javascript-react-and-nodejs-and-graphql-development-at-facebook-cink0r0e500h5io53fpl7ediu)
* 原文作者 : [Sandeep Panda](https://hashnode.com/@sandeep)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


Recently, Lee Byron ([@leebyron](https://hashnode.com/@leebyron)) from Facebook hosted an [AMA](https://hashnode.com/ama/with-lee-byron-cin0kpe8p0073rb53b19emcda) on Hashnode. There were many interesting questions and Lee revealed some amazing facts and details about how Facebook is utilizing React, GraphQL and React Native. I enjoyed reading his answers in the AMA and thought to summarize it by highlighting 10 interesting points.

So, here we go.

## Inspiration behind React?

React was partly inspired by [XHP](https://github.com/facebook/xhp-lib) which was built by Marcel Laverdet at Facebook in 2009 to componentize Facebook's UI. More details [here](https://hashnode.com/ama/with-lee-byron-cin0kpe8p0073rb53b19emcda#cin120uib00edlv533i6d8yd7).

## Is Facebook going to re-code its mobile app using React Native?

Well, the answer is : _They have already done it_. Some portions of Facebook app are built with React Native and other parts are not. For a detailed answer refer to this [discussion](https://hashnode.com/ama/with-lee-byron-cin0kpe8p0073rb53b19emcda#cin6vg5r201wqjh53ne77tao1).

## What are the areas where Immutable.js is being used?

*   Facebook's Ads Manager on Web and their React Native based Android and iOS apps
*   Messenger Web ([messenger.com](https://hashnode.com/util/redirect?url=http://messenger.com))
*   Writing a new post in Draft.js
*   Commenting anywhere in Facebook's News Feed

## How does Facebook write CSS for React Components?

Lee revealed that they have disallowed importing CSS rules into any file other than the React component. It makes sure that a component should expose the right API via its props to be styled correctly and that other components can't import a rule in order to override it. Also they don't need to import a CSS file by doing some tricks in JavaScript. Rather they follow a convention where `Button.js` sits next to `Button.css`. More details [here](https://hashnode.com/ama/with-lee-byron-cin0kpe8p0073rb53b19emcda#cin5qpdbv01apk85319o2c1fx).

## Does Facebook upgrade the React components with each major release of React?

*   Yes, they do.
*   They usually use the **master** branch of React in production at Facebook.
*   Since 2012, there haven't been many serious changes to the APIs. So, there aren't many instances where the React team had to upgrade the components.
*   If there are breaking changes, Ben Alpert, a member of React team at Facebook, takes the responsibility for making any relevant changes across the whole codebase.
*   They also use automated tools like [jscodeshift](https://github.com/facebook/jscodeshift) to simplify things.

## What's the story behind GraphQL?

GraphQL was born in 2012 when Lee was working on the News Feed on iOS. At that time Facebook was growing the most in places with bad network connections. So, GraphQL was initially designed for slow mobile connections. Later when Relay was getting open sourced it didn't make much sense to do it without GraphQL. They also realized that GraphQL service was written in Hack and most companies outside Facebook didn't use it. So, they decided to present GraphQL in a language agnostic way by writing a spec for it. That's the story behind GraphQL. For more details read [this](https://hashnode.com/ama/with-lee-byron-cin0kpe8p0073rb53b19emcda#cin1gw37n00kwlv53rretxpe8) answer.

## What are the areas where GraphQL is being used at Facebook?

Facebook's iOS and Android apps are almost entirely powered by GraphQL. In some cases, whole apps like Ads Manager use Relay + GraphQL.

Yes, Facebook uses SSR heavily. However, according to Lee, there are very few areas where they use React to render components on server. This was primarily a decision based on their server environment which is Hack.

## Does Facebook use Node.js?

Lee said that many of their client side tools are written in JavaScript and run in Node. One such tool is [remodel](https://github.com/facebook/remodel) which is installed via npm. All of their internal GraphQL client side tools for iOS and Android also use Node. But they don't use Node much on the server side because there has not been a serious need for it so far. Whenever they want to run JavaScript on server (e.g. rendering React on server) they just use V8 directly rather than using Node.

## How does Falcor (by Netflix) compare to GraphQL?

According to Lee, they both try to solve similar problems. When the GraphQL team first heard of it, they met up with the team from Netflix and exchanged notes. However, there are some key differences between Falcor and GraphQL. Read [this](https://hashnode.com/ama/with-lee-byron-cin0kpe8p0073rb53b19emcda#cinj7lim4002lid53x47g060n) answer to know more.

I hope you liked this super quick summary. For detailed answers and discussions head over to the [AMA page](https://hashnode.com/ama/with-lee-byron-cin0kpe8p0073rb53b19emcda).
