>* 原文链接 : [I’m a web developer and I’ve been stuck with the simplest app for the last 10 days](https://medium.com/@pistacchio/i-m-a-web-developer-and-i-ve-been-stuck-with-the-simplest-app-for-the-last-10-days-fb5c50917df#.1i4q6te4a)
* 原文作者 : [pistacchio](https://medium.com/@pistacchio)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者: 
* 状态： 认领中




I’m a full time developer. Most of my work is developing web sites full-stack. Sometimes I write backend servers in **Python** or **Ruby**, sometimes I work with **C#**. I also develop command line utilities in **C++** or **Node.js**, I find Clojure fun, I approached web development years ago with **Perl** and **PHP** and when I first entered the professional world of development I worked for years with **Java**.

When I first encountered **Javascript** it was mainly used to add “_The current time is_” on pages. I’m talking about the Nineties here and everybody wanted to spice up their pages telling the occasional visitor what day of the week it was _dynamically (!)_ and it felt good. Over the years we all discovered that Javascript can do so much more than that and we all went full **DHTML**. Yes, our HTML went full _dynamic_!

In the last years I’ve developed pretty large Single Page Applications with various frameworks or, when in a rush, mostly a mess of badly organized Javascript code that vomits **jQuery** calls here and there.

Some ten days ago I wanted to program a very simple _SAP_ for my personal use, a little utility to grow as a pet project. I’m talking about a two, three days effort here. In the last six months I’ve been working on a C# Desktop app. It is a rather boring workflow management program with a webservice backend and winforms on the client.

As the idea of this little web app popped into my mind, I envisioned the opportunity to try out a few new things I’ve been reading about online, refresh my web-dev tools and have some fun. Pretty exciting, nothing too complicated or demanding.

As it turned out, I haven’t been able to program that simple project because I’m stuck in an **analysis paralysis loop**.

I’ve already had four or five “false starts” so far. The core of the problem is _choice_ and the overwhelming abundance of tools to choose from.

Who wants to write

    MyNotReallyClass.prototype.getCarrots = function () {}

when ES6 is _almost_ here, it has _almost_ real classes and it’s _almost_ well supported? Who wants to have ten

    <script src="%E2%80%9Dlibrary-12.js%E2%80%9D"></script>

on top of the page when there multiple packers out there? Who want to write

    $(‘.carrots’).innerHTML(myJson.some.property[3]) 

when there are so many frameworks out there to help you structure your app? Who wants to ignore the fact that now browser Javascript is written with the help of Node.js command line tools?

So I went knee deep into the pool of new things, things I’ve used in the past and I’ve forgotten or have evolved and so on. And man, apart for a few HTML forms I haven’t been able to make any progress so far.

Remember, this is a simple personal project, I mostly wanted to have fun, so my mind was set to zero-tolerance mode. As soon as something annoyed me I went away looking for something else to smoothen my experience.

These are just a couple of examples of what to expect when trying out new things in Javascript-land today

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
