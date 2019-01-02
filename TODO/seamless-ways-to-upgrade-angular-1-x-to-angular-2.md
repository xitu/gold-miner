* 原文链接 : [Seamless Ways to Upgrade to Angular 2](https://scotch.io/tutorials/seamless-ways-to-upgrade-angular-1-x-to-angular-2)
* 原文作者 : [Chris Nwamba](https://scotch.io/author/chris92)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [CoderBOBO](https://github.com/CoderBOBO)
* 校对者: [根号三](https://github.com/sqrthree) [Adam Shen](https://github.com/shenxn)

# 如何从 Angular 1.x 无缝升级到 Angular 2

Angular 2 已经发布了数月，两三周前也刚发布了一个新的 beta 版本。相信我，我绝对能猜到各位对此次优化改动的想法。你可能会问自己（或是对着你的计算机屏幕自言自语）：Angular 团队究竟凭借什么实现如此大的飞跃。毕竟，你（或至少你认为你）觉得Angular1 就已经能满足所有个人需求了。
先暂时停下手上正在使用的代码编辑器吧，一起来讨论下为什么这是一次志在必行的大调整，以及我们通过哪些方法促使我们成功迈出这一大步。

## 为什么转向研发Angular2 ？

Angular 1.x性能优良，并且会继续投入使用，而Angular2 将会有更加杰出的表现。各位是否认为Angular 团队是一群无所事事的团队，所以忙于创造一些无用的东西？不，当然不是这样！那么，请你耐心地和我们一起讨论一下Angular2 吧！

事实上，Angular 2 的存在并不意味着 Angular 1 会被遗弃或者失去支持。我们都很清楚IT行业一般是如何运作的。大家依然会使用IE 8、安卓的老版本及网络开发者使用的Web窗体等。这就是为什么Angular1直到现在还存在的原因。
阐明这个观点后，让我们来看看到底为什么你应该开始考虑使用Angular2。

### 性能

当我们谈起Angular2 的优点时，性能永远是排在第一位的。通常对于那些认为 Angular 1 的速度和性太低的团队来说至关重要。在大部分的Angular数据绑定概念中有证可寻。
Angular2 具有更好的策略和概念，能够改善使用Angular开发的Web应用程序的性能。

### 更好的移动端支持

Angular 1.x 在开发时并没有考虑到移动端支持
。幸运的是，这样的设计有利于像 Ionic 这样的框架。
我们使用了较为粗暴的方法将 Angular 植入到像 Ionic 这样的框架当中，这样做影响了用户在执行应用程序时的体验及性能。
正因有了这些可怕的体验，Angular 2 才被设计的更好，Angular2 已准备好应对移动端的一切情况。

### 更好的学习途径

> 我花了三个星期才能理解 Angular1 的概念。尽管我的合作开发伙伴从未使用过 Angular1，**却仅用了四天时间就能理解 Angular2 **。

如果你已经看过Angular2的应用文件，你应该认识下边的代码：

    import {Component} from 'angular2/core';

    @Component({
        selector: 'my-app',
        template: '<h1>{{ title }}</h1>'
    })

    export class AppComponent { 
        title = "My First Angular 2 App"
    }

如果光看这段代码，刚开始时你可能会吓一跳。不过 Angular2 也就只有这些代码（当你的应用程序增长时也只是更多类似的代码）。掌握基本语法之后，你便可以开始使用它了。
另一方面，与我们学习 Angular 1.x. 的方式相比。Angular 1.x 的文档简直要让人抓狂，居然有一大堆复杂的文件要学。我用了三个星期才理解了 Angular1 的概念，尽管我的合作开发伙伴从未使用过 Angular1，却只用了 1 天时间就掌握 了Angular2。

### 关于未来

Angular 2 采用了所有整个 Web 领域趋向流行的那些具备潜质的功能在使用 TypeScript 植入 Angular 时，被称为 ES6 的 ES2015 是主要的ECMAScript 版本。
Web组件就是Web的未来。若各位还不打算接受这一事实的话，那意味着你的方向已经走偏了。

## 升级到Angular 2

升级到Angular2仅需一个非常简单的步骤，但仍需小心升级。
有2种主要方式可以体验到 Angular2 为你的项目带来的变化：使用哪种方法取决于你的项目需求。Angular 团队提供了2种途径去实现：

### ngForward

[![ng-forward-logo](https://scotch.io/wp-content/uploads/2015/12/ng-forward-logo.png)](https://scotch.io/wp-content/uploads/2015/12/ng-forward-logo.png)

[ngForward](https://github.com/ngUpgraders/ng-forward)并不是 Angular2 真正的升级框架，但我们可以用它来创建一个形似 Angular2 的 Angular 1 应用程序。

要是你还不愿意将现有应用程序升级到 Angular2 的话，你可以退一步先使用 ngForward，这既能让你感受到 Angular 2优势所产生的优质变化，同时又能让你继续待在自己的舒适区当中。

又或者，你可以慢慢重新编写你的 angular 应用程序，使它看起来像用 Angular2 编写一样；你也能用 Angular2 的方式增加一些特征，仅现有项目不受到影响。而它带来的其他好处是：在你选择尽可能长久时间地坚持使用过去的框架时，它已经为你及你团队的未来打好了基础。

我将引导你通过一个基本设置来使用 ngForward 入门，但是为了能够步入正轨，你还是应该看一看 Angular 2 的 快速入门

在你现有的 Angular1.x（应该是1.3 +）应用程序上运行：


    npm i --save ng-forward@latest reflect-metadata

安装最新版 ngForward 及reflect-metadata。现在，请准备好你的 index.html，使得它看起来像下面这样：

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

请注意我们正在引用的 config.js。现在我们可以创建它：

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

如果你听取了我的建议，能够花些时间去回顾一下快速启动内容的话，那你就不会被这些配置绕晕。SystemJS 被引导后（这点我们很快就会看到），它将用于加载 Angular 应用。最后，在我们的 app.ts 中，我们可以把它当做 Angular2 对其进行编写。

    import {Component,  bootstrap} from 'ng-forward';

    @Component({
        selector: 'my-app',
        template: '<h1>{{title}}</h1>'
    })
    class AppComponent { 
        title = "My First Angular 2 App"
    }
    bootstrap(AppComponent);

在这里，你可以看到详细的演示过程。 [演示](http://plnkr.co/edit/tpcJFVkcbSGhsE38lnmh?p=preview)

### ngUpgrade

编写一个形似Angular2 的 Angular1.x 应用并非尽善尽美。我们需要的是真正的法宝。一个大型现有 Angular1.x 项目成为最大的挑战，将我们所有的应用重新编写到 Angular2 会变得非常困难，甚至即使使用 ngForward 也并不理想。这时候，ngUpgrade 便派上用场了。ngUpgrade 才是我们真正需要的法宝。

与 ngForward 不同，ngUpgrade 清晰地覆盖在 Angular2 文件上。如果你还未掌握这种途径的开发者目录，那先腾出几分钟消化下这些知识。[知识](https://angular.io/docs/ts/latest/guide/upgrade.html).

此外，我们还会写更多关于升级到 Angular2 的文章。在日后的文章中，我们会侧重说明 ngUpgrade 的相关问题。

## 结语

作为一个有经验的Angular开发者，我注意到 Angular 团队有一个好习惯，那就是提供无数方案去解决一个问题。

正如在本教程所看到的一样，你可以从零开始学习使用 Angular2 ，用 Angular2 的形式编写 Angular1 ，或者通过一步步使用 ngUpgrade ，对你现有的软件进行升级。



