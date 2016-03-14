>* 原文链接 : [I’m a web developer and I’ve been stuck with the simplest app for the last 10 days](https://medium.com/@pistacchio/i-m-a-web-developer-and-i-ve-been-stuck-with-the-simplest-app-for-the-last-10-days-fb5c50917df#.1i4q6te4a)
* 原文作者 : [pistacchio](https://medium.com/@pistacchio)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : woota
* 校对者: 
* 状态： 翻译中


#JavaScript生态之乱象
####（原标题：作为一名web开发者，我已经被一个极度简单的app卡了10天）

我是一名全职开发者。我大部分工作的内容是网站的全栈开发。偶尔，我也用**Python**或**Ruby**写写后端的服务器，有时写点儿**C#**。我还用**C++**或**Node.js**开发一些命令行工具，我发现Clojure很有意思，我接触web开发是在多年以前，那时用的是**Perl**和**PHP**，而在我首次进入职业开发道路的时候，我写了几年**Java**。

在我第一次接触**JavaScript**时，它主要用来往网页上写“*现在是几点*”这样的东西。我说的是上个世纪90年代，每个人都想让自己的页面变得更加有趣，*动态地*告诉偶然到来的访客今天是周几（哇！），并以此为乐。这些年来，我们都发现JavaScript能做的远不止这些，我们都想要全效的**DHTML**(Dynamic HTML)。是的，我们的HTML变得充满*动态效果*了！

在过去的几年中，我用过一些不同的框架开发过几个比较大型的单页应用，有时候忙起来，JavaScript代码组织的极烂，把**jQuery**调用写得到处都是。

大概10天前，我想开发一个简单的*SPA*给自己用，把一个小工具改写成一个小项目。这一般也就是两三天的功夫。在过去的这半年，我一直在用C#写一个桌面应用。这是一个相当无聊的工作流管理程序，有一个网络服务后台和winform客户端。

当我起念要开发这个小型web应用的时候，我便预见这是一个尝试新技术的好机会，我曾在网上读到过一些，以此刷新我的web开发工具库并收获一点乐趣。想想都觉得激动，没什么太复杂的东西，也不用太费劲。

可事实证明，我根本无法着手编写这个简单的项目，因为我陷入了一种**分析瘫痪循环**

到目前为止，我已经有了四到五次失败的开始。问题的核心是在*选择*上，以及要如何从过度繁多的工具库中挑选出合适的工具。

谁想写这样的代码

    MyNotReallyClass.prototype.getCarrots = function () {}

ES6*都快*落地了，它有了*近似*真正的类，并且*差不多*得到了完好的支持？市面上有那么多的打包工具，谁还想写十行

    <script src="%E2%80%9Dlibrary-12.js%E2%80%9D"></script>

在页面的顶部？有那么多的框架帮我们组织应用，谁还要写这样的代码

    $(‘.carrots’).innerHTML(myJson.some.property[3]) 

谁又想忽视如今编写浏览器端Javascript代码有了Node.js命令行工具辅助的事实？

所以我深入研究这些新事物，这些我曾经用过现在忘了或是进化了的事物。可天知道，除了一点HTML表单，我一直没能取得任何的进展。

请记住，这是一个简单的个人项目，我主要是想找点儿乐子，因此我的脑袋被设置为零容忍模式。一旦什么东西令我厌烦，我就抛开它去寻找其它的东西来抚平我的体验。

这是今天在Javascript领域尝试新技术，我所期待的几个东西，例举如下

At first I wanted to give **Typescript** a try. Having worked mostly with C# in the last months, I remembered how cool it is to have a statically typed language: it makes you feel more confident about your code, the refactoring is easier and IDEs, with a sensitive autocomplete, write half of your code no matter how messed your classes are.

I needed two external libraries just for the core functionalities. They were not on [DefinitelyTyped](https://github.com/DefinitelyTyped/DefinitelyTyped) , so I spent half of my day learning about **.d.ts** files and writing the wrappers for those libraries. Not something that I call productive, but I went with it.

I wanted to add some testing with **Mocha** from the start. Welcome to hell. I looked for a way to have multiple **.tsconfig.json** files in the project but JetBrains WebStorm didn’t support them, so the compiler kept packing the tests with the actual code. I stared reading guides, gists, **StackOverflow** questions. _Use this_ **_Gulp_** _configuration file. You have to compile the scripts before testing them but hey, are you also writing the tests in Typescrip? Then use this Gulp plugin but it doesn’t work well with_ **_watchify_**. After the first day I had a mess of files being merged, compiled, _src_ and _dest_ and _test_ folders that made unwanted tasks triggered. I stopped being able to follow what was going on in the background. When is something compiled, where are the dependencies, should I **include** or **require** this file? _Fuck with it_.

I had a short but pleasant experience with **React** in a very small project before and I thought of giving it a try. I grabbed some Gulp configurations to get going. Here the problem was with React itself. I’ve already laid out my models, but React.js likes to mix models and states and properties, so I had to rethink it. My app is simple but form-intense. And guess what, from the official React documentation:

> If you’re new to the framework, note that ReactLink is not needed for most applications and should be used cautiously.  
> In React, data flows one way: from owner to child. This is because data only flows one direction in the Von Neumann model of computing. You can think of it as “one-way data binding.”

Yeah, but a form, and a heavy one, is intrinsically a two-way binding artifact. So React, without plugins and mixins, doesn’t work well with you inputting a lot of things into it. You have to decorate all your input fields to support that. It soon became annoying. Also, talking about mixins, I was using ES6 but React classes don’t support them. _Fuck with it_.

So, I need a lot of two-way data binding, right? **Knockout** is excellent in that and I have some experience with it. Again, I tried using ES6 classes but the _this_ binding gets all messed up. Without using classes, the code soon got messed up. Javascript mixed with HTML seems ugly after having tried React. There you have HTML within Javascript but it does make sense since at least you can struture sensible logical units and have them self-contained

_(As a side note of irritation, it seems that no matter what you choose, you need some watch tasks running in the background compiling, linting, packing, testing. I write something in my editor, Cmd+S to save, Cmd+Tab to switch to the editor, Cmd+R to refresh the page and I don’t see any difference. Guess what, sometimes I’m faster that the compiler or the “watch” task didn’t notice my editing or it threw an exception.)_

So, before even starting to write a single line of code, you have to choose what you want to spice up (dependancy management, packagin, testing, building and so on) and each choice opens a world of alternatives that may be either competing, more or less standard, more or less used, with different kind of maturity and that may work more or less well together.

What flavor of Javascript are you going to use? Are you gonna use a transpiler? From what language? Grun? Gulp? Bower? Yeoman? Browserify? Webpack? Babel? Common.js? Amd? Angular? Ember? Linting? What am I talking about? Am I mixing things up? Am I confused? Fuck with it? Yeah, fuck with it.

If you’re still with me, it seems that making a web-app, today, is like playing a very hard **Interactive Fiction** game (a-la **Zork**). Let’s travel back in time and make a program some years ago:

> You are in the room of programs. You can only make a command-line program. You see the C language and the Assembly language  
> > get C language  
> Ok, you can start writing your program

Now, let’s get back to 2016:

> You are in the room of web apps.  
> > make web app  
> Are you making a game? Consider using Unity or GameMaker or similar softwares that export for the web  
> > make web app  
> Have you considered making a desktop program with web technologies? You can use NW.js or Electron, for instance  
> > make web app  
> Some languages appear. You see Javascript, Coffescript, Typescript, Clojurescript, Dart, asm.js. Type “more” if you want the list of all the 127 available languages  
> > get javascript  
> A couple of languages appear: ES5 and ES6  
> > get ES6  
> You are in the room of transpilers. You see Babel, Traceur or you can hope that the browser already supports the features that you’ll use. Type “more” for a list of transpilers and read the book “Transpiler Tools aka Necronomicon”   
> > get Babel  
> You arrive in the corridor of Tasks. You see a Grunt in a corner, a Gulp in the other. A Babelify attacks you, Webpacks gather all around. In a nearby room you hear Browserify screaming and fighting with Require.js. In your inventory you have “transpile on save”.  
> > run away  
> a Yeoman glows in an alcove nearby. In your hand you have npm but your project.json is broken. You hear a Broccoli and a Jasmine howling in the distance.  
> > fuck with it  
> You can’t “fuck with it” because seven rooms ago you chose “npm install node-jsx” and it is not currently compatible with your configuration of “fuck with it”  
> > quit.

#### Update

This post got some interest on [Hacker News](https://news.ycombinator.com/item?id=11080080). I found it quite ironic that some of the comments are:

> > I’ve already laid out my models, but React.js likes to mix models and states and properties, so I had to rethink it  
> => **Redux**  
> > this Gulp configuration file…  
> => **Webpack**

> **ClojureScript**. Just learn that; the ClojureScript community will keep it up with the times, and you can help out too at times. Yes, you’ll have to debug a little under the hood, but your background should be sufficient for that.

> Which combination of tools should you use? **Ember** if you have no idea where to start — otherwise thing about the problem you have with other tools and find tools that solve those problems.

So, I guess, talking to the community about my “analysis paralysis loop” caused by the excessive amount of available tools to choose from and to investigate resulted in the community suggesting to try out, spend time, learn and investigate four more technologies that I haven’t even considered in the first place. Good job, Javascript!
