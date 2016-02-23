* 原文链接 : [Seamless Ways to Upgrade Angular 1.x to Angular 2](https://scotch.io/tutorials/seamless-ways-to-upgrade-angular-1-x-to-angular-2)
* 原文作者 : [Chris Nwamba](https://scotch.io/author/chris92)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [认领地址](https://github.com/xitu/gold-miner/issues/127)
* 校对者: 
* 状态 : 认领中


Angular 2 was released a couple of months back and a beta version is just a couple of weeks old. Trust me, I can tell your thoughts about this change. You are probably asking yourself (or actually your computer screen) why on earth would the Angular team make such a huge jump. After all, you are (or at least you think you are) fine with what you already have in Angular 1.

Give your code editor a little break so we can discuss on why this jump is necessary and ways we can _jump_ and not fall.

## Why Turn to Angular 2?

Angular 1.x is fine and here to stay but Angular 2 is better. Do you think the Angular team are just jobless and work on creating something useless? No of course! So sit tight so we can talk about it.

The fact that Angular 2 exists does not mean Angular 1 will be deprecated or lack support. We know how it goes in IT generally, people still use IE 8, older versions of Andriod, Web Forms for .Net developers, etc. This is why Angular 1, for the time being is still here to stay.

Having made this point, let us actually take a look at why you should start considering Angular 2.

### Performance

Performance is always the first point when talking about benefits of Angular 2\. The reason being that critics were on the team’s neck concerning the speed and performance of Angular 1 even as mush. This could be found mostly in Angular’s data binding concept.

Angular 2 had better strategies and concepts to improve the performance of web applications made with Angular.

### Better Mobile Support

Angular 1.x was not built with mobile support in mind, but fortunately frameworks like Ionic found favor in them.

Angular was implemented in frameworks like Ionic in a _hard_ manner which was detrimental to the user’s experience and performance of the application in general.

With all this terrible experience, Angular 2 was designed to be better and ready for any thing coming its way that is mobile oriented.

### Better Learning Path

> It took me three weeks to wrap my head around the concept of Angular 1 but it took my co-developer who never used Angular 1 **four days to understand Angular 2**.

If you have looked at an Angular 2 app file, you should recognize this:

    import {Component} from 'angular2/core';

    @Component({
        selector: 'my-app',
        template: '<h1>{{ title }}</h1>'
    })

    export class AppComponent { 
        title = "My First Angular 2 App"
    }

Looking at this piece of code, might get you intimidated at first but there is nothing more to Angular 2 than just that (and a more of it when your app grows). If you understand that basic syntax, you are good to go.

On the other hand, compare it with the way we learned Angular 1.x. The docs were crazy. There were tons of complicated documentations to study. It took me three weeks to wrap my head around the concept of Angular 1 but it took my co-developer who never used Angular 1 four days to understand Angular 2.

### The Future

Angular 2 uses all the promising features the web as a whole is coming up with. ES2015 also known as ES6 is the major ECMAScript version for Angular implemented with TypeScript.

Web Components are the future of the Web and if you are not planning to accept that yet, then you are driving on the wrong lane.

## Upgrading to Angular 2

Upgrading to Angular 2 is quite an easy step to take, but one that should be made carefully.

There are **two major ways to feel the taste of Angular 2 in your project**. Which you use depends on whatever requirements your project has. The angular team have provided two paths to this:

### ngForward

[![ng-forward-logo](https://scotch.io/wp-content/uploads/2015/12/ng-forward-logo.png)](https://scotch.io/wp-content/uploads/2015/12/ng-forward-logo.png)

[ngForward](https://github.com/ngUpgraders/ng-forward) is not a real upgrade framework for Angular 2 but instead we can use it to create Angular 1 apps that look like Angular 2.

If you still feel uncomfortable upgrading your existing application to Angular 2, you can fall to ngForward to feel the taste and sweetness of the good tidings Angular 2 brings but still remain in your _comfort_ zone.

You can either re-write your angular app gradually to look as if it was written in Angular 2 or add features in an Angular 2 manner leaving the existing project untouched. Another benefit that comes with this is that it prepares you and your team for the future even when you choose to hold onto the past for a little bit longer.

I will guide you through a basic setup to use ngForward but in order to be on track, have a look at the [Quick Start](https://angular.io/docs/ts/latest/quickstart.html) for Angular 2.

In your existing Angular 1.x (should be 1.3+) app run:

    npm i --save ng-forward@latest reflect-metadata

This installs the latest version of `ngForward` and also the `reflect-metadata`module. Now prepare your `index.html` to look like what we have below:

    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="UTF-8" />

        <title>Ng-Forward Sample</title>

        <link rel="stylesheet" href="styles.css" />

        <script data-require="angular.js@1.4.7" data-semver="1.4.7" src="https://code.angularjs.org/1.4.7/angular.js"></script>
        <script data-require="ui-router@0.2.15" data-semver="0.2.15" src="http://rawgit.com/angular-ui/ui-router/0.2.15/release/angular-ui-router.js"></script>

        <script src="http://cdnjs.cloudflare.com/ajax/libs/systemjs/0.18.4/system.js"></script>
        <script src="config.js"></script>

        <script>
          //bootstrap the Angular2 application
          System.import('app').catch(console.log.bind(console));
        </script>
      </head>

      <body>
        <app>Loading...</app>
      </body>

    </html>

Notice the `config.js` we are referencing. We can create it now:

    System.config({
      defaultJSExtensions: true,
      transpiler: 'typescript',
      typescriptOptions: {
        emitDecoratorMetadata: true
      },
      map: {
        'ng-forward': 'https://gist.githubusercontent.com/timkindberg/d93ab6e17fc07b4db7e9/raw/b311a63e0e96078774e69f26d8e8805b7c8b0dd2/ng-forward.0.0.1-alpha.10.js',
        'typescript': 'https://raw.githubusercontent.com/Microsoft/TypeScript/master/lib/typescript.js',
      },
      paths: {
        app: 'src'
      },
      packages: {
        app: {
          main: 'app.ts',
          defaultExtension: 'ts',
        }
      }
    });

If you took time to review the Quick Start as I suggested, you won’t be lost with the configuration. SystemJS is used to load the Angular application after it has been bootstrapped as we will soon see. Finally in our `app.ts`, we can code like it’s Angular 2.

    import {Component,  bootstrap} from 'ng-forward';

    @Component({
        selector: 'my-app',
        template: '<h1>{{title}}</h1>'
    })
    class AppComponent { 
        title = "My First Angular 2 App"
    }
    bootstrap(AppComponent);

You can view a detailed demo [here](http://plnkr.co/edit/tpcJFVkcbSGhsE38lnmh?p=preview)

### ngUpgrade

Writing an Angular 1.x app that looks like Angular 2 is not good enough. We need the real stuff. The challenge then becomes that with a large existing Angular 1.x project, it becomes really difficult to re-write all our app to Angular 2, and even using ngForward would not be ideal. This is where ngUpgrade comes to our aid. ngUpgrade is the real stuff.

Unlike ngForward, ngUpgrade was covered clearly in the Angular 2 docs. If you fall in the category of developers that will take this path, then spare few minutes and digest [this](https://angular.io/docs/ts/latest/guide/upgrade.html).

We’ll also be writing more articles on upgrading to Angular 2 and we’ll focus more on ngUpgrade in a future article.

## Final Remarks

One thing I have observed as an experienced Angular developer is that the Angular team has a good habit of providing tons of option to solve a single problem.

Just as we saw in this guide, you can just use Angular 2 from scratch, write Angular 1 in Angular 2 form or gradually leverage ngUpgrade to upgrade your existing.

## Scotchmas Giveaway Day 7 and 8

Enter for your chance to win a [Misfit Flash](http://misfit.com/products/flash) and a $50 Starbucks Gift Card.

