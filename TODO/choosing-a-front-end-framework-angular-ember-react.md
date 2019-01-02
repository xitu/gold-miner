>* 原文链接 : [CHOOSING A FRONT END FRAMEWORK: ANGULAR VS. EMBER VS. REACT](http://smashingboxes.com/blog/choosing-a-front-end-framework-angular-ember-react)
* 原文作者 : [Zach Kuhn](http://smashingboxes.com/bio/zach-kuhn)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者: 
* 状态： 认领中


As front end engineers, we live in exciting times. The big three of web frameworks are all approaching or have had major new releases. Ember released 2.0 less than two months ago by making it a stealthily easy upgrade from its previous version. Just a couple weeks ago [React released 0.14](https://facebook.github.io/react/blog/2015/10/07/react-v0.14.html), a major step on its march to 1.0\. AngularConnect, a conference in London later this week, will likely shine light on Angular 2’s timeline.  

There are, of course, many other client side frameworks. There are libraries who have been around for some time but whose popularity are waning, like Backbone and Knockout. There are also new and interesting entrants, like Aurelia. But if you are making a decision on creating a web app today, Angular, Ember or React are the safest bets for long term support and active communities. Which one is best for you? Let’s explore what each of these new major releases bring to the table and what benefits each one offers.

### ![AngularJS 2.0 Strengths and Weaknesses](http://smashingboxes.com/media/W1siZiIsIjIwMTUvMTAvMjAvMTAvNDEvNDgvOTE5L2FuZ3VsYXJfMi4wLnBuZyJdXQ/angular%202.0.png?sha=c182c65bfad4aa24)  

### Angular 2.0 (is a dramatic change from before)

Angular is currently the most popular of the three and for good reason. It was the first released and represented a large improvement over the previous generation of client-side MVC frameworks. Angular took a pragmatic approach that resonated with its adopters.

All this was jeopardized with the announcement of Angular 2.0\. It was a bit of a fiasco. Unlike Ember’s approach, the second version of Angular reinvisioned what the framework could be. This meant big, dramatic changes to almost every piece of code. It would have made reusing code from version 1.X almost impossible. The upgrade path was all but impassable.

Then a relative miracle of software engineering happened. The Angular team devised a way [to allow projects to run both Angular 1.X and 2.0 code at the same time](http://angularjs.blogspot.com/2015/08/angular-1-and-angular-2-coexistence.html). Upgrading could now be a gradual process. In my opinion, this saved the framework from almost certain stagnation and the horror of thousands of challenging to maintain, legacy code bases.

Having dodged that demise, most projects created today should still use the latest 1.X release of Angular and plan to gradually embrace version 2.0 once it is out. If you can afford to be on the bleeding edge and don’t intend to release this year, by all means start using their new version. Do expect the API’s to change, though, which can eat up more and more time as your project grows.

#### What should you look forward to in version 2.0?

Lots. This framework is undergoing the largest change between versions by far.

Development on Angular 2.0 emphasizes removing the framework’s unnecessary complexity. They removed and replaced directives, controllers, modules, scopes and nearly every other concept from version 1.X. What’s left is a framework that uses features of ES2015 and ES2016 to the fullest and makes different design decisions that the team hopes will make the framework easier to learn.

Beyond the focus on making the framework simpler, there are several other notable goals for version 2.0:

*   Performance improvements
*   Native app support
*   Server-side rendering

These changes are huge for Angular and would have been challenging to build with 1.X. Let’s go into a little bit of detail about these three changes and what they mean for the framework.

##### Performance

Improving performance was one of the top items on anyone’s wish list for Angular’s next version. If you’ve worked enough with Angular, you’ve hit points where the simple implementation breaks down and an app starts to crawl. There almost always exists a way to fix the performance problems, but the framework didn’t guide you away from shooting yourself in the foot.

Angular hamstrung its performance with how it polled state. During every digest cycle, the framework checks if any of hundreds or thousands of values in your app changed. Its new model adopts a practice React popularized: one-way data flow and immutable data. By embracing these, Angular now only updates once the data changes. Detecting change becomes a quick check of an object’s reference and not all its values.

##### Native Apps

Creating native apps using Angular is a big advancement planned on the roadmap for 2.0\. The Angular team met with the React team and discussed how this could be done. It looks as though they are building 2.0’s native app rendering using React Native underneath, allowing it to piggyback on that piece of technology. This will usher in a new generation of hybrid apps that perform like native but share logic across multiple platforms.

##### Server-Side Rendering

Another long requested feature for Angular is the ability to render on the server. Server-side rendering speeds up initial page load times and improves SEO by making dynamic pages easy to crawl. Seeing pages render faster is going to greatly improve the feel of the next generation of web apps written in Angular.

#### ![Angular 2.0 JavaScript Framework Strengths and Weaknesses | Smashing Boxes Blog](http://smashingboxes.com/media/W1siZiIsIjIwMTUvMTAvMjAvMTAvMzEvNTkvNTUzL1NjcmVlbl9TaG90XzIwMTVfMTBfMjBfYXRfMTAuMjcuMTdfQU0ucG5nIl1d/Screen%20Shot%202015-10-20%20at%2010.27.17%20AM.png?sha=b9885a92578605b6)

#### Who should use Angular?

Angular will likely maintain as the most popular client side framework for quite some time. This makes it a safe choice for anyone starting a new project. 2.0 represents a gigantic shift from the first version of Angular. In fact, the shift is similar to how Ember became so different from SproutCore (fun fact, Ember was originally SproutCore 2.0).

Angular 2.0 is written in TypeScript, a programming language from Microsoft that adds type checking and other enhancements to JavaScript. In fact, [in a recent poll of its community](http://angularjs.blogspot.com/2015/09/angular-2-survey-results.html), the largest group of developers said they too would be using TypeScript. This and other features of the framework make it reasonable to assume Angular will remain the framework of choice for large enterprises. As of today it is risky to start using 2.0, but its time may come soon.

![Ember JS Strengths and Weaknesses](http://smashingboxes.com/media/W1siZiIsIjIwMTUvMTAvMjAvMTAvNDMvMzkvNTMzL2VtYmVyXzIuMC5wbmciXV0/ember%202.0.png?sha=5256dc85a2ad31a0)

### Ember 2.0 (snuck up on us)  

Ember is a framework that positions itself as _the_ framework for ambitious projects. Some apps built with Ember include many of Apple’s properties, Discourse (a new take on forums by Jeff Atwood), and Ghost (a modern blogging engine). Ember is driven by two legendary software engineers in the industry, Yehuda Katz and Tom Dale. Unlike the other frameworks discussed here, however, Ember is not built by a mega-corporation. Though it does have an amazing, passionate, and active community around it.

Prior to 1.0, Ember grew notorious for its changing API’s as they discovered where they wanted to take the framework. Afterwards, to the credit of the team working on it, they’ve proven capable of making large underlying changes while only gradually changing the user facing parts. They took this approach with the release earlier this year of Glimmer, a high speed rendering engine. With 2.0 they removed the deprecated parts that couldn’t take advantage of this new engine. Any app that runs with Ember 2.X will fly.

#### What’s coming in the future of version 2.X?

*   Further adoption of ES2015 features like modules, classes, and decorators
*   A departure from the Mustache templating and the use of bracket syntax for components
*   A change to the project layout structure to what are called pods—instead of grouping by function (controllers, models, components, etc.), now the top levels will be by feature
*   Controllers will be removed in favor of routable components
*   Advancement of their server side renderer to help reduce page load times and improve search engine optimization

#### ![Ember 2.0 JavaScript Framework Strengths and Weaknesses | Smashing Boxes Blog](http://smashingboxes.com/media/W1siZiIsIjIwMTUvMTAvMjAvMTAvMzIvMzYvMzMyL1NjcmVlbl9TaG90XzIwMTVfMTBfMjBfYXRfMTAuMjYuNTdfQU0ucG5nIl1d/Screen%20Shot%202015-10-20%20at%2010.26.57%20AM.png?sha=a3cf15093adcd58c)

#### Who should use Ember?

Ember makes a great choice for writing web apps. As mentioned above, many ambitious apps are built using the framework. It has been particularly well received by the Ruby community, including our own Ruby devs at Smashing Boxes. If you are a Ruby shop, Ember is a fantastic choice. A ton of documentation, articles, and blogs exist on combining these two technologies. Want to know how to combine Rails with the Ember CLI? [Easy, here is a series telling you how](http://smashingboxes.com/ideas/merging-rails-and-ember-cli).

Ember is also the best solution for those who buy into the all-tools-included framework approach. Often we waste time discovering, researching, and gluing together libraries that don’t mesh well. Ember makes so many decisions for you, which provides surprising value. There are pros and cons to both approaches, but those who want everything to just work well together will love Ember.

![React JS Strengths and Weaknesses | Smashing Boxes Blog](http://smashingboxes.com/media/W1siZiIsIjIwMTUvMTAvMjAvMTAvNDQvNTMvNjk3L1JlYWN0XzEuMC5wbmciXV0/React%201.0.png?sha=886b9b43c826ec79)

### React 1.0 (will likely look a lot like 0.14)

React is the lightest weight of the three being compared here. In fact, it can’t even be considered a framework. It does one thing really well: render UI components. Many even pair it with the above frameworks. However, a more common scenario is to use it with a Flux architecture.

Flux is a different take on Model-View-Controller. Like the rest of the React ecosystem, however, it is still just a library to handle one thing. In this case, it communicates actions from the view layer down to the model layer it changes. It still doesn’t contain other typical parts of a framework like communicating with a server, validating models, or injecting dependencies. There are of course other libraries for handling those things if your project needs them.

Facebook created React to solve the problems they were having with keeping their UI consistent across the page. It made a splash with its release because it offered incredible performance and server side rendering—two features that competing frameworks struggle with. It is interesting to see that Angular and Ember are catching up with their new releases.

React continues to make large innovations in the space. Most notable is React Native. Facebook got the speed of native apps while sharing code across mobile phone platforms. Earlier last month [they open sourced the Android part of React Native](https://code.facebook.com/posts/1189117404435352/react-native-for-android-how-we-built-the-first-cross-platform-react-native-app/), making it a serious option for anyone wanting to make a native app.

#### What are some of the React team’s big goals for their 1.0 release?

*   Revamped project website
*   Improved documentation
*   Robust handling of animations

Most of them revolve around making a better developer experience. The big feature missing right now is an easy way to create animations with React elements. With so few planned changes, it looks like the 1.0 release may happen soon.

#### ![React 1.0 JavaScript Framework Strengths and Weaknesses | Smashing Boxes Blog](http://smashingboxes.com/media/W1siZiIsIjIwMTUvMTAvMjAvMTAvMzIvNTkvNzAyL1NjcmVlbl9TaG90XzIwMTVfMTBfMjBfYXRfMTAuMjcuMzFfQU0ucG5nIl1d/Screen%20Shot%202015-10-20%20at%2010.27.31%20AM.png?sha=4a027d6af769157b)

#### Who should use React?

React is a great choice for new and existing projects alike. It is easy to pull out pieces of your UI and redo them within React. This makes it an appropriate choice if you need to gradually modernize an existing code base. At Smashing Boxes, many of our front end engineers have grown to love the library. React and Flux help trivialize some of the most challenging parts of building web apps.

React has been at the forefront of client-side MVC advancements for the last couple years. Other frameworks are playing catch-up with many of the things React can do. You also see this with how the community embraces new technology. React projects are commonly written in ES2015, ahead of browser support for it. If you value being on the cutting edge or simple libraries over complete frameworks, React is your choice.

### Head to Head to Head Comparison

Having built the [TodoMVC app](http://todomvc.com/) with each of these, I have a few thoughts on each. First, these frameworks feel like they are converging. Although they all have unique features, many of the best ideas end up in all three. One-way data flow is an example of this. Also, components as XML elements will soon be in all three.  

Of these frameworks, Ember was the quickest to get something started. Immediately you have a web server that reloads the page on changes and best practices right out of the box. With the other two, you might spend time configuring Webpack or Gulp to get a project off the ground. You might fiddle with how you want the project laid out. Or you might spend time searching for a boilerplate project to copy. By virtue of being opinionated, Ember removes all that friction.

Yet, for me, Ember took the longest to learn of the three. For such a small toy project, it felt like overkill. Also, it seems there are specific ways Ember wants you to do things and going outside of that is difficult. It’s no surprise, these two things are often said about Rails. To me that signals Ember would scale well to long-lived projects with many developers.  

In comparison, the other two frameworks eagerly played along with whatever I wanted to do. Angular 2.0 surprised me a little. It is nothing like Angular 1.X, but it was easy to build the app once I found some examples to learn from.

In the final code, the Angular app had the fewest lines. React came in second. It is strange to describe, but when writing React code I find it easier to think, “OK, I should pull this chunk of logic out into its own component.” This adds to the lines of code but makes future changes much easier. In Angular and Ember, it’s a little too easy to continue adding lines to the template and new functionality to the component.

The final products were within 100KB of one another and loaded in around 300ms when serving locally. The TodoMVC is too small to stress out the performance of any of these frameworks. However, looking at [something like DBMonster tells you a bit about these frameworks](https://www.youtube.com/watch?v=z5e7kWSHWTg&feature=youtu.be&t=2m30s). This app became the onus for Ember’s Glimmer engine. Now it is safe to say all three frameworks perform admirably in that benchmark.

### Who Wins?

![Javascript framework comparison: Angular vs Ember vs. React](http://smashingboxes.com/media/W1siZiIsIjIwMTUvMTAvMjIvMTQvMDEvMjQvMjUvU2NyZWVuX1Nob3RfMjAxNV8xMF8yMl9hdF8yLjAwLjIwX1BNLnBuZyJdXQ/Screen%20Shot%202015-10-22%20at%202.00.20%20PM.png?sha=690cea3d157763dc)

It is easy to see why these three frameworks are so popular. They all have a lot of strengths. Because of that, I suggest you learn and work with all three like we do here at Smashing Boxes. There is no clear winner. Some frameworks fit some situations better than the others. Even if nothing else, learning all three will help you write better code by taking what you’ve learned from each framework with you to the next one.  

As for myself, I am really enjoying React and the ecosystem around it. [Its basic concepts are simple to learn](http://smashingboxes.com/ideas/learn-react-part-1). It is easy to work with for small proofs of concept and it scales well as a project grows. I can’t quantify this, but its concepts help me write correct, bug-free code. If I were starting a new project today, React would be the tool I would choose.

Having said that, the future is bright for all three of these frameworks. The next generation of these frameworks will be blazing fast and support server-side rendering. Angular and React will support native UI components on iOS and Android. We are able to do even more things with these frameworks than we ever could in the past. Already well acquainted with JS frameworks but want to dive deeper with interesting work? [Apply to work with us](http://smashingboxes.com/jobs).
