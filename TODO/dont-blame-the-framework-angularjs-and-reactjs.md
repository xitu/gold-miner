
In the past few years, websites have evolved into complex web applications, and what once was land of simple business informative pages, now is home to Facebook, Slack, Spotify and Netflix, changing the way you communicate, listen to music or watch movies. Front-end development has reached a new level and now requires more attention than it used to.

Just as for many front-end developers, our stack used to consist of HTML and jQuery. We would do AJAX requests to our backend, render the new chunk of UI on JavaScript and insert it into the DOM. User actions were tracked by binding events and callbacks to each of the elements. And don’t take me wrong: this is just fine for most applications.

However, when an application grows considerably, a [couple of issues](https://reinteractive.net/posts/186-lessons-learnt-by-building-single-page-applications) start being more frequent than expected: you forget to update all places where a value is displayed in the UI, no events are bound to the content added by AJAX, just to name some — this list can be very long. These are signs that your code is not maintainable, especially when developing together with a team. Using a front-end framework provides a formal way to write collaborative code that you can read, write and update.

![write_code](https://s3.amazonaws.com/ckl-website-static/wp-content/uploads/2016/05/write_code.gif)

## 1. The Dawn of React

When our team first felt the necessity of applying a front-end framework, we put some options on the table and it came down to – guess what? – [Angular](https://angularjs.org/) and [React](https://facebook.github.io/react/).

Angular was by far the most mature candidate: it had a big community and you could find third-party modules for most of the common use cases.

React was giving the first big steps, its JavaScript-centric code was promising and it was fast. Although still on beta, the “developed by Facebook” label backed it up.

We decided to give it a shot and start using React.

In the beginning, it was really satisfying to do everything using JavaScript: display a chunk of HTML or not, render lists by iterating over an actual array. It was also good to change a variable value and see it propagating to all parts of code via [props](https://facebook.github.io/react/docs/transferring-props.html) (one of React components attributes), to break everything down to [reusable components](https://facebook.github.io/react/docs/reusable-components.html) and to really [stop and think](https://facebook.github.io/react/docs/thinking-in-react.html) before getting our hands dirty with code. It gave us the consistency we needed to develop maintainable code as a team.

![teamwork_1](https://s3.amazonaws.com/ckl-website-static/wp-content/uploads/2016/05/teamwork_1.gif)

## 2. React + Flux = ♥

But down the road, not everything is unicorns and rainbows. The first big challenge we faced — and the one that really put us to think if using React was worth it — was a callbacks maze.

Because of its one-way-data-flow nature, a child component needs to receive a [callback to trigger a state change](https://facebook.github.io/react/tips/communicate-between-components.html) on the parent component. It doesn’t seem a big deal until you realize that your child component that is way down the cascade, now needs to update the state of the root component. You have to go over all files and pass the “this.props.updateCallback” down the stream line.

Despite this, we liked React and kept working with it. An effort that paid off: we met [Flux](https://facebook.github.io/flux/), an architecture to enforce and formalize the unidirectional flow of data. It consists of [four main elements](https://facebook.github.io/flux/docs/overview.html#structure-and-data-flow):

- Store: where data (application state) is stored;
- Action: triggers a state change;
- Dispatcher: manages and routes actions to the right stores;
- View: present data in the store and send out actions — here is where React is *de-facto* used!

With Flux, there’s no need to keep the state on a root component and pass update callbacks to its children. React components get data from the store directly and change the state by calling actions: it’s simple, elegant and prevents you from becoming insane. Flux adds a predictable behavior and some standards to the highly non-opinionated React code.

## 3. A wild Angular appears…

…It uses HTML-centric code and [it’s NOT super effective](http://knowyourmeme.com/memes/its-super-effective).

![pokemon_effective](https://s3.amazonaws.com/ckl-website-static/wp-content/uploads/2016/05/pokemon_effective.jpg)

Recently, I started working on an Angular project. A big part of it was already implemented, so there was no going back, I had to do it. As a loyal React developer, I complained about Angular. I literally cursed it — even if those were the first Angular lines of code I was professionally writing. After all, that’s the way it works: [if you love React, you hate Angular](https://medium.com/@jeffwhelpley/screw-you-angular-62b3889fd678#.oy3ij6ft3).

And I can’t lie to myself, in the beginning I was not enjoying to work on Angular code. Embedding all those framework-specific attributes (or better, directives) to HTML didn’t feel right. I was struggling to get simple things done, like changing the [URL without reloading the controller](https://github.com/angular/angular.js/issues/1699) or do basic templating.

The struggle continued when I had problems in my forms because of [ngIf](https://docs.angularjs.org/api/ng/directive/ngIf) directive creating a new child scope for it. Or when I wanted to remove blank fields from a JSON being sent to the server and it removed that data from the UI as well — oh I see, two-way data binding. Or when I wanted to use [ngShow](https://docs.angularjs.org/api/ng/directive/ngShow) and [ngHide](https://docs.angularjs.org/api/ng/directive/ngHide) to display an HTML block and hide another and, for that hundredth of a second, both are displayed simultaneously. I understand many of these issues were my fault –what I want to point out is that Angular is not predictable, it’s full of these surprises.

![struggle](https://s3.amazonaws.com/ckl-website-static/wp-content/uploads/2016/05/struggle.gif)

But of course, a lot of things were easier to do with Angular. The [built-in HTTP requests module](https://docs.angularjs.org/api/ng/service/%24http) is really good, as well as the promises support. Another thing that I can’t complain at all: the [built-in form controllers](https://docs.angularjs.org/api/ng/type/ngModel.NgModelController)! Input fields have default routines for formatting, parsing and validating fields, as well as a good plugin to display error messages. 

By using Angular it’s also easier to work with a design team. In our team, there was an engineer dedicated to write HTML and CSS, and Angular enabled us to work together really seamlessly: he would worry about the HTML and a few extra tags, while I’d handle the logic. If we were using React, it’d be at least more challenging for him to write components, since he’d have to learn the basics of JSX (or I’d have to copy and paste his work myself).

Remember the URL-replacing and templating issue that I mentioned before? Nevermind, found out that people normally use a different routing library ([ui-router](https://github.com/angular-ui/ui-router)) that does a better work  than the standard one ([ngRoute](https://docs.angularjs.org/api/ngRoute)). In the end, Angular was not as bad as I expected. Most things that I complained about in the beginning were either because I was forcing the React way of doing things to Angular code or because I wasn’t experienced enough. 

![obama_not_bad](https://s3.amazonaws.com/ckl-website-static/wp-content/uploads/2016/05/obama_not_bad.gif)

## 4. Bottom line: AngularJS and ReactJS

React uses the native JavaScript functions to allow developers to create reusable components with a predictable lifecycle and unidirectional data-flow. Combined with Flux architecture (or one of its variations — i.e. Redux) it’s reliable, which makes it easier to work with a team on the long-run — without the constant fear of solving a bug and creating ten others. But it might be an overhead when you have people with expertise on HTML and CSS only, since it changes the traditional development flow. It’s also very dependent on the modules you choose to compose your stack.

Angular, on the other hand, focuses on the design simplicity of two-way data binding — what you change on the controller scope will (I’d say auto-magically) show up in the UI. Its opinionated nature saves setup time, by laying some patterns on how to organize the code and making it unnecessary to choose core modules from hundreds of options. However, the same way that with two-way data binding it’s simpler to develop, it’s also easier to create unexpected bugs when changing parts of code in the long run — especially that colleague’s code that hasn’t been touched in the past few months.

And then, what would I choose to build an app from scratch?

For the long term, I, personally, would choose React, using [Redux](http://redux.js.org/) architecture, [Axios](https://github.com/mzabriskie/axios) for promise-ready HTTP requests and [react-router](https://github.com/reactjs/react-router). But it also depends on the team experience: if there’s a dedicated person for writing HTML and CSS, I would go with Angular for sure. Both of them have pros and cons and what still counts the most for a maintainable project is the developers’ commitment to write good and organized code.

![At the end, Angular was not as bad as I expected.](https://s3.amazonaws.com/ckl-website-static/wp-content/uploads/2016/05/At-the-end-Angular-was-not-as-bad-as-I-expected..gif)
