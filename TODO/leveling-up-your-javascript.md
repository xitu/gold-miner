* 原文链接 : [Leveling Up Your JavaScript](http://developer.telerik.com/featured/leveling-up-your-javascript/)
* 原文作者 : [Raymond Camden](http://developer.telerik.com/author/rcamden/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Hikerpig](https://github.com/hikerpig)
* 校对者: [Nark Qi](https://github.com/narcotics726), [JasinYip](https://github.com/JasinYip)

# JavaScript 姿势提升简略

JavaScript 是一门入门容易，但是相当难以精通的语言。可现今一些文章总假设你已经精通了它。

我从 1995 年 JavaScript 还以 LiveScript 名字出现的时候就开始用它了，但后来逐渐从前端开发撤回服务器的安全怀抱中，直到五年前才重拾。很高兴看到如今的浏览器更加的强大和易于调试。但 JavaScript 已经演变得越来越复杂且难以精通了。不过最近我终于得出结论，我并不需要_精通_ Javascript，只需要比以前更进一步就好。能成为一个"好"的 JavaScript 开发者我便觉欣慰。

以下是我发现的一些_实用_的 JavaScript 小技巧: [组织代码](#组织代码); [代码检验](#代码检验(Linting)); [测试](#测试); 以及 [使用开发者工具](#浏览器开发者工具)。里面有几条对有经验的 JavaScript 开发者来说可能很显而易见，但是语言初学者很容易养成坏习惯。这些技巧提高了我的技术水平，同时也为我的用户创造了更好的体验。_这_难道不是我们最大的目标么。

> 你可在此处[下载](http://developer.telerik.com/wp-content/uploads/2016/01/code.zip)本文的样例代码。

## 组织代码

JavaScript 初学者总是不可避免地在他们的 HTML 页面里写上一大坨代码。开始的时候都是很简单的，例如使用 jQuery 给一个表单输入自动加上焦点，然后要加上表单验证，然后又要加上一些市场上走俏的模态框组件——就是那些阻止用户往下阅读内容好让他们在 Facebook 上给网站点赞的东西。经过这些七七八八的功能迭代后你的一个文件里 HTML 标签和 JavaScript 都有了几百行。

别再继续这种乱七八糟的方式了。这个技巧太简单了我都不好意思单独把它列出来，但大家还_真的_很难拒绝这种把代码一坨扔上页面的偷懒做法。还请各位务必避之如瘟疫。养成好习惯：在开始的时候就先创建好一个空的 JavaScript 文件，然后用 script 标签引入它。这样一来，之后的交互与其他客户端功能代码就可以直接填入先前准备好的空文件里去了。

把 JavaScript 从 HTML 页面中剥离以后（干净多了是不是？），下一个问题就是关于这些代码的组织形式了。这几百行 JavaScript 也许功能没啥问题，但是几个月后，一旦你开始想调试或是改点东西，你可能特么找不到某个函数在哪了。

若仅仅把代码从 HTML 中剥离到一个单独文件中是不够的，那还能怎么办呢？

### 框架！

显然解决方案是框架。把所有东西用 AngularJS，或 Ember，或 React 或其他几百个框架中某一个写一遍。哼哧哼哧地把整个网站重写为一个单页应用，用上 MVC 什么的。

或者根本不需要。当然了，别误会我，在编写应用的时候我喜欢用 Angular，但是一个"应用"和一个页面的交互复杂度是有区别的。一个用上 Ajax 技术的产品目录页和 Gmail 也是有区别的 - 起码几十万行代码的区别。那么，如果不走框架这条路的话，还有什么选择呢？

### 设计模式

设计模式是对"这是过去人们解决问题的一个方法"这句话的高级说法。Addy Osmani 写过一本关于此的很好的书，[学习 JavaScript 设计模式](http://addyosmani.com/resources/essentialjsdesignpatterns/book/)，可以免费下载阅读。我推荐这本书。但是我对它（以及类似的关于此议题的讨论）有点小看法，因为最后你们写的代码可能变成这样:

    var c = new Car();
    c.startEngine();
    c.drive();
    c.soNotRealistic();

对我来说，设计模式在抽象层面上是有意义的，但是在_实际工作中_，没有什么用。在实际项目的环境下，挑选并应用设计模式是件很困难的事情。

#### 模块

在所有我看过的设计模式中，我觉得模块模式是最简单也是最容易应用到现有代码里的。

纵而览之，模块模式就是一系列代码之外加了个包装。你抽取出一系列功能相关的代码扔到一个模块里，决定需要暴露的部分，也可以把一个模块里的代码放到不同的文件里。然后建立一个易于在项目之间共享的代码黑匣。

看看这个简单的例子。此处的语法乍看可能有点奇怪，起码我一开始是这样觉得的。我们先从"包装"部分开始看，然后我再解释其余部分。

![](http://ww4.sinaimg.cn/large/9b5c8bd8jw1f0zumg7z7gj20kp05ojru.jpg)

模块模式的包装。

只有我一个人被这些括号搞晕了么？我搞不明白这里是干嘛的，这还是在我懂 JavaScript 的前提下。其实这里如果从里往外看，就清晰很多。

![](http://ww2.sinaimg.cn/large/9b5c8bd8jw1f0zuncbxnuj20m805lgly.jpg)

模块的内部只是个普通的函数。

从一个简单的函数开始，在其内部定义该模块的实际需要提供的代码。

![](http://ww1.sinaimg.cn/large/9b5c8bd8jw1f0zunvmhafj20m805ot94.jpg)

圆括号使得这个函数自动执行。

最后的圆括号会让该函数立即执行。我们在函数里返回了什么，模块就是什么。此时我们这里还是空的。不过此时上图高亮的部分还_不是_合法的 JavaScript。那么，怎样让它变得合法呢？

![](http://ww4.sinaimg.cn/large/9b5c8bd8jw1f0zuoenvzjj20m805mdg9.jpg)

外边的圆括号开始发功了。

在`function() { }()` 外的圆括号使得此处成为合法JavaScript。你要是不信我，就打开开发者工具的控制台自己输入看看。

这样就是我们一开始看到的。

![](http://ww1.sinaimg.cn/large/9b5c8bd8jw1f0zuotyvzej20m808ngm7.jpg)

返回值被赋给一个变量。

最后一件事是把返回值赋给一个变量。尽管我自己完全懂得这里，但每次我看见这种代码我都得暂停一秒钟来提醒自己这是什么鬼。说来也不怕羞，我在编辑器里存着这段空模块代码随时快手粘贴。

当我们终于征服了这坨诡异的语法之后，真正的模块模式究竟长啥样呢？

    var counterModule = (function() {
      var counter = 0;

      return {
        incrementCounter: function () {
          return counter++;
        },
        resetCounter: function () {
          console.log("counter value prior to reset: " + counter );
          counter = 0;
        }
      };

    }());

这段代码创建了一个叫做 `counterModule` 的模块。它有两个函数，`incrementCounter` 和 `resetCounter`。可以这样使用它们：

    console.log(counterModule.getCounter()); //0
    counterModule.incrementCounter();
    console.log(counterModule.getCounter()); //1
    counterModule.resetCounter();
    console.log(counterModule.getCounter()); //0

主要的思想就是把 `counterModule` 里的代码好好地封装起来。封装是计算机科学基础概念，将来 JavaScript 还会提供更简单的封装方法，不过就现在来说，我觉得模块模式已是个超级简单和使用的组织代码方案。

#### 一个实用的模块案例

吐槽完网上看到的样例（例如上面那个 Car 的例子）。我们现在需要编写一个符合实际场景需求的简单代码。限于本文篇幅，我会写得尽量简单，但会贴合你在遇到实际 web 项目时的情况。

假设你的网游公司愣天堂 (任粉莫喷)，在用户要创建游戏人物的时候需要一个注册页面。你需要一个可以让用户选择名字的表单。构建名字的规则有点诡异：

*   必须以大写字母开头
*   长度不小于2
*   允许空格，但是不能有标点
*   不能有"敏感"词汇

先写下这个超简单的表单。

    <html>
      <head>

      </head>

      <body>

        <p>Text would be here to describe the rules...</p>

        <form>
          <input type="text" placeholder="Identifer">
          <input type="submit" value="Register Identifer.">
        </form>
        <script src="app.js"></script>
      </body>
    </html>

除了我描述的输入框，表单里还有个提交按钮。然后我加了些有关上面提到的规则的说明，先尽量保持精简。让我们来看看代码。

    var badWords = ["kitten","puppy","beer"];
    function hasBadWords(s) {
      for(var i=0; i < badwords.length; i++) {
        if(s.indexof(badwords[i]) >= 0) return true;
      }
      return false;
    }

    function validIdentifier(s) {
      //是否为空
      if(s === "") return false;
      //至少两个字符
      if(s.length === 1) return false;
      //必须以大写字母开头
      if(s.charAt(0) !== s.charAt(0).toUpperCase()) return false;
      //只允许字母和空格
      if(/[^a-z ]/i.test(s)) return false;
      //没有敏感词
      if(hasBadWords(s)) return false;
      return true;
    }

    document.getElementById("submitButton").addEventListener("click", function(e) {

      var identifier = document.getElementById("identifer").value;

      if(validIdentifier(identifier)) {
        return true;
      } else { console.log('false');
        e.preventDefault();
        return false;
      }
    });

从代码底部开始，你看到我写了点基本的获取页面元素的代码（没错伙计们这里我没有用 jQuery）然后监听 button 上的点击事件。拿到用户输入的用户名字段然后传给验证函数。验证的内容也就是我之前描述的那些。这里代码还没有_太_乱，不过随着之后验证逻辑的增长和页面交互逻辑的增加，代码会越来越难以维护。所以我们把这里重写为模块吧。

首先，创建 game.js 文件并在 index.html 中使用 script 标签引入它。然后把验证逻辑移到一个模块里。

    var gameModule = (function() {

      var badWords = ["kitten","puppy","beer"];

      function hasBadWords(s) {
        for(var i=0; i < badwords.length; i++) {
          if(s.indexof(badwords[i]) >= 0) return true;
        }
        return false;
      }

      function validIdentifier(s) {
        //是否为空
        if(s === "") return false;
        //至少两个字符
        if(s.length === 1) return false;
        //必须以大写字母开头
        if(s.charAt(0) !== s.charAt(0).toUpperCase()) return false;
        //只允许字母和空格
        if(/[^a-z ]/i.test(s)) return false;
        //没有敏感词
        if(hasBadWords(s)) return false;
        return true;
      }

      return {
        valid:validIdentifier
      }

    }());

现在的代码和之前相比没有翻天覆地的差别，只不过是被封装成了一个有一个 `valid` 接口的 `gameModule` 变量。接下来我们来看看 app.js 文件。


    document.getElementById("submitButton").addEventListener("click", function(e) {

      var identifier = document.getElementById("identifer").value;

      if(gameModule.valid(identifier)) {
        return true;
      } else { console.log('false');
        e.preventDefault();
        return false;
      }
    });

看看我们的 DOM 监听函数里少了多少代码。所有的验证逻辑（两个函数和一个敏感词列表）被安全地移到了模块里后，这里的代码就更好维护了。如果你的编辑器支持，你在此处还能有模块方法名的代码补全。

模块化不是什么高深的东西，但它使我们的代码_更干净_，_更简单_ ，这绝对是件好事。

## 代码检验(Linting)

简单给初闻者解释下，代码检验表示使用最佳实践和一些避免出错的规则对代码进行检查。很高大上对不对？这么好的东西，我以前却以为只有挑剔过头的开发者才会考虑这个。当然了，我期望自己写出超棒的代码，但我也需要腾出时间玩游戏。就算我的代码够不上某些高大上的完美标准，但它能好好工作我就能满意了。

然而...

记不记得你有多少次重命名了个函数然后提醒自己之后一定会改？

记不记得你有多少次创建了个有两个形参的函数，其实最后只用了一个？

记不记得你有多少次写过多少蠢代码？我说的是那些根本不能工作的，类似我最爱的 `fuction` 和 `functon`。

代码检验就是这时候站出来帮你的！除了我之外大家都知道，代码检验不只有风格的最佳实践，还包含语法和基本的逻辑检验。还有一个让我从"等我有时间一定或做的" 跳到"我会虔诚地遵循它" 的原因，那就是几乎所有现代编辑器都支持此功能。我目前用的编辑器（ Sublime, Brackets 和 Visual Studio Code）都支持代码实时检验和反馈。

举个例子，以下是 Visual Studio Code 对我一段很挫的代码的提示。当然了，我是故意写得很挫的。

![](http://ww4.sinaimg.cn/large/9b5c8bd8jw1f0zupgeoxdj20m80d1q40.jpg)

Visual Studio Code 代码检验。

上图中，你能看到 Visual Studio Code <strike>抱怨</strike>我代码中的几个错误。Visual Studio Code 的代码检验器，和大多数检验器一样，可配置你关心的检验规则以及对其中"错误"（必须修正）和"警告"(别偷懒啊，总要修复的)的定义。

如果你不想安装任何东西，也不想折腾编辑器，另一种好方法是使用[JSHint.com](http://jshint.com)在线检验代码。JSHint 差不多是最流行的检验器，它基于另一个检验器 JSLint (谁说它们长得像来着？)。JSHint 的诞生一部分原因是由于 JSLint 太过严格。你可以直接在编辑器里或是通过命令行使用 JSHint，最简单的体验方法是在它的网站上试试。

![](http://ww1.sinaimg.cn/large/9b5c8bd8jw1f0zuppot76j20m804w0t8.jpg)

JSHint 网站。

乍看可能不太明显，其实左边是在一个在线代码编辑器。右边的是一份对左边代码的检验报告。要看到检验效果，最简单方式是在代码里随便写错点什么。我这里把 `main` 函数名改成了 `main2`。

    function main2() {
      return 'Hello, World!';
    }

    main();

马上，网页就对此给我报了两个错误。注意了，这并不是语法错误。代码在语法上是完全没问题的，但是 JSHint 发现了你可能忽视了的问题所在（当然了，这里代码只有5行，但想象下一个大文件里函数定义和调用之间隔了好多行的时候）。

![](http://ww4.sinaimg.cn/large/9b5c8bd8jw1f0zuq1qvjvj209t070wei.jpg)

JSHint 错误。

来个更真实的例子如何？以下的代码（嗯现在我_是_用了 jQuery），我写了点简单的 JavaScript 做表单验证。都是些鸡毛蒜皮的东西，不过今天几乎一半的 JavaScript 代码做的都是这些事（哦哦当然还有创建弹出框然后问你要不要"赞"这个网站。真特么爱死这些了）。这些代码可以在 demo_jshint 文件夹的 app_orig.js 中找到。

    function validAge(x) {
      return $.isNumeric(x) && x >= 1;
    }

    function invalidEmail(e) {
      return e.indexOf("@") == -1;
    }

    $(document).ready(function() {

      $("#saveForm").on("submit", function(e) {
        e.preventDefault();

        var name = $("#name").val();
        var age = $("#age").val();
        var email = $("#email").val();

        badForm = false;

        if(name == "") badForm = true;
        if(age == "") badForm = true;
        if(!$.isNumeric(age) || age <= 0) badForm = true;
        if(email == "") badForm = true;
        if(invalidemail(email)) badForm = true;

        console.log(badform);
        if (badform) alert('Bad Form!');
        else {
          // do something on good
        }
      });
    });

开始是两个辅助验证的函数（对年龄和 email）。然后是 `document.ready` 代码块里对表单提交的监听。获取表单中三个字段的值，检查是否为空（或是无效输入），若表单无效就弹出警告，否则继续（在我们的例子里，什么也没发生，表单没变化）。

扔到 JSHint 上看看发生了啥：

![](http://ww3.sinaimg.cn/large/9b5c8bd8jw1f0zuqkjapdj20b90s5q3x.jpg)

JSHint 对我们样例代码的报错。

哇塞好多东西！看起来是类似的问题出现了多次。我开始用检验器的时候这种情况挺常见。我并没有弄出很多种错误，而仅仅是同种错误的重复。第一个非常简单—— 检查相等时使用三等号替代双等号。简单来说就是用更严格的标准检测空字符串。先修复这个(demo_jshint/app_mod1.js)。

    function validAge(x) {
      return $.isNumeric(x) && x >= 1;
    }

    function invalidEmail(e) {
      return e.indexOf("@") == -1;
    }

    $(document).ready(function() {

      $("#saveForm").on("submit", function(e) {
        e.preventDefault();

        var name = $("#name").val();
        var age = $("#age").val();
        var email = $("#email").val();

        badForm = false;

        if(name == "") badForm = true;
        if(age == "") badForm = true;
        if(!$.isNumeric(age) || age <= 0) badForm = true;
        if(email == "") badForm = true;
        if(invalidemail(email)) badForm = true;

        console.log(badform);
        if (badform) alert('Bad Form!');
        else {
          // do something on good
        }
      });
    });

JSHint 报告变成了:

![](http://ww2.sinaimg.cn/large/9b5c8bd8jw1f0zur1n2y4j20am0lb0t8.jpg)

JSHint 对我们样例代码的报错。

算是解决了。下一个错误类型是"未声明变量"。看着有点诡异。如果使用 jQuery 的话，你知道`$` 是存在的。`badForm` 的问题就更简单点——我忘记用 `var` 声明它了。那我们怎么解决`$`的问题呢？JSHint 提供了对代码规则检验方法的配置。在代码里加上一个注释以后，我们告诉 JSHint `$` 变量是作为全局变量可以放心使用。接下来我们补上这个注释，并且加上丢失的 `var` 声明（demo_jshint/app_mod2.js）。

    /* globals $ */
    function validAge(x) {
      return $.isNumeric(x) && x >= 1;
    }

    function invalidEmail(e) {
      return e.indexOf("@") == -1;
    }

    $(document).ready(function() {

      $("#saveForm").on("submit", function(e) {
        e.preventDefault();

        var name = $("#name").val();
        var age = $("#age").val();
        var email = $("#email").val();

        var badForm = false;

        if(name == "") badForm = true;
        if(age == "") badForm = true;
        if(!$.isNumeric(age) || age <= 0) badForm = true;
        if(email == "") badForm = true;
        if(invalidemail(email)) badForm = true;

        console.log(badform);
        if (badform) alert('Bad Form!');
        else {
          // do something on good
        }
      });
    });

JSHint 报告变成了:

![](http://ww4.sinaimg.cn/large/9b5c8bd8jw1f0zurgx350j209204gwed.jpg)

JSHint 对我们样例代码的报错。

哇哦！就快结束了！最后一个问题恰好的展示了 JSHint 在提示最佳代码风格实践和指出错误以外的用途。这里我忘了写过一个处理年龄验证的函数。你看我创建了 `validAge`，但是在表单验证代码区域没使用它。也许我该删了这个函数 —— 反正也只有一行，但我觉得留下来更好——以免以后验证逻辑越来越复杂。以下就是完整的代码了(demo_jshint/app.js)。

    /* globals $ */
    function validAge(x) {
      return $.isNumeric(x) && x >= 1;
    }

    function invalidEmail(e) {
      return e.indexOf("@") == -1;
    }

    $(document).ready(function() {

      $("#saveForm").on("submit", function(e) {
        e.preventDefault();

        var name = $("#name").val();
        var age = $("#age").val();
        var email = $("#email").val();

        var badForm = false;

        if(name === "") badForm = true;
        if(age === "") badForm = true;
        if(!validAge(age)) badForm = true;
        if(email === "") badForm = true;
        if(invalidEmail(email)) badForm = true;

        console.log(badForm);
        if(badForm) alert('Bad Form!');
        else {
          //do something on good
        }
      });
    });

最终版本"通过"了 JSHint 的测试。虽然实际上并不完美。注意到我两个检验函数一个叫 `validAge` 一个叫 `invalidEmail` ，一个返回肯定一个返回否定。更好的做法是保持语义一致性。还有每次这个验证函数运行的时候，jQuery 需要获取DOM 中的三个元素，其实它们只需要被获取一次。我应该在表单提交回调函数外创建这些变量，每次验证的时候重复使用。如我所言，JSHint 不是完美的，但代码最终版本绝对比第一版要好很多，我的修改也没有花多少时间。

不同用途的代码检验器有 JavaScript([JSLint](http://www.jslint.com)和 [JSHint](http://www.jshint.com))，HTML([HTMLHint](http://htmlhint.com/)和 [W3C Validator](https://validator.w3.org/))和CSS ([CSSLint](http://csslint.net/))。如果编辑器支持，而你还是个"前端潮人"，还可以用 Grunt 和 Gulp 工具对这些进行自动化。

## 测试

我不写测试。

没错，我话就撂这儿了。世界不会停止转动。不过，在开发客户端项目时，我其实_是_写测试的（好啦实际是我_尝试_去写测试），但是我的主要工作写博客，和各种功能的样例代码。这些代码只为验证概念而非投入生产环境使用，因此不写测试没什么大不了的。其实，在我成为布道者和不做"实际"工作之前，我也是敢这么放话的，不写测试的借口和不使用代码检验器一样。不过一些给检验器加分的因素放在测试上也很好用。

首先——许多编辑器会为你自动生成测试代码。例如在 Brackets 中，可以使用 [xunit](https://github.com/dschaffe/brackets-xunit) 扩展。借助它你只要在 JavaScript 文件上调出右键菜单就能生成测试代码（支持多种流行测试框架格式）。

![](http://ww1.sinaimg.cn/large/9b5c8bd8jw1f0zus4jz8sj20m80hymy4.jpg)

xunit 创建的测试。

该扩展基于现存代码去生成测试代码。生成的测试代码只是个模板，你需要自己去填写具体内容，这避免了一些无聊的重复劳动。

![](http://ww2.sinaimg.cn/large/9b5c8bd8jw1f0zuthjkyxj20m80hxjtd.jpg)

xunit 创建的测试。

完成了测试细节的填充后，该扩展会帮你自动执行测试。都到了这份上了，不写代码基本上就只是懒了。

![](http://ww2.sinaimg.cn/large/9b5c8bd8jw1f0zutuzzmij20m80l50we.jpg)

测试报告。

你也许听过 TDD (测试驱动开发)。说的是在写具体代码之前先把单元测试写好。本质上是测试主导你的开发。写下代码并看它通过测试的时候，这些通过的测试能让你确保自己没有走错路。

我觉得这个想法不错，不过让所有人都这么做的确是有点困难。我们干脆先从简单点的开始。想象下你手上有一些据你所知功能正常的代码，然后你发现了个 bug。在修复它之前，你可以创建一个测试去检验出此 bug，修复 bug，然后跑跑测试，确保此后相同的 bug _不会_再次出现。如我所言，这不是最理想的实践，但也能算是朝着以后在开发所有阶段实践测试的一个过渡。

我用我写的一个精简数字显示的函数作为 bug 的例子。109203可以精简为109K。更大的例如2190290这样的数可精简为2M。看下代码然后我会说说 bug。

    var formatterModule = (function() {

      function fnum(x) {
        if(isNaN(x)) return x;

        if(x < 9999) {
          return x;
        }

        if(x < 1000000) {
          return Math.round(x/1000) + "K";
        }
        if(x < 10000000) {
          return (x/1000000).toFixed(2) + "M";
        }

        if(x < 1000000000) {
          return Math.round((x/1000000)) + "M";
        }

        if(x < 1000000000000) {
          return Math.round((x/1000000000)) + "B";
        }

        return "1T+";
      }

      return {
        fnum:fnum
      }

    }());

你马上看出问题了？还是放弃了？当输入9999的时候，会返回10K。尽管此精简可能有用，但代码对于所有小于10K的数字应该一视同仁，都返回它们的原始值。这个修正很简单，我们正好当作添加测试的机会。关于测试框架我选择 [Jasmine](http://jasmine.github.io/)。Jasmine 的测试易于编写和运行。最快的使用方法是下载这个库。解压后你会发现 SpecRunner.html 文件。此文件负责引入我们的代码，引入测试，而后运行测试和生成漂亮的报告。它依赖于压缩包中的 lib 文件夹，你一开始可以把 SpecRunner 和 lib 文件夹一起复制到你的服务器某处。

打开 SpecRunner.html 你会看到。

    <!-- include source files here... -->
    script tags here...

    <!-- include spec files here... -->
    more script tags here...

在第一个注释下你需要删除已有的代码然后加上一个 script 标签引入你的代码。如果下载了此文的代码，你可以在 demo4 文件夹里找到 formatter.js 文件。之后你要加一个 script 标签引入测试代码。你可能之前没见过 Jasmine，但你看看这个测试代码，_非常_易读，新手也能懂。

    describe("It can format numbers nicely", function() {

      it("takes 9999 and returns 9999", function() {
        expect(9999).toBe(formatterModule.fnum(9999));
      });

    });

我的测试说的是当9999作为输入时应该返回9999。在浏览器里打开 SpecRunner.html 你就能看到错误报告。

![](http://ww4.sinaimg.cn/large/9b5c8bd8jw1f0zuu5bbhaj20m80e1q61.jpg)

测试失败的报告。

修复起来很简单。把条件里的数字从9999增到10000:

    if(x < 10000) {
      return x;
    }

不论何时再跑测试你能看到一片欢乐。

![](http://ww2.sinaimg.cn/large/9b5c8bd8jw1f0zuuh4xj8j20m804y74k.jpg)

测试成功的报告。

你估计能想出一些相关测试完善这套测试。通常来说，积极地添加测试以覆盖你代码的各种可能使用场景没有任何不妥。关于日期和时间的牛库 [Moment.js](http://momentjs.com/)，不是我骗你，有超过五万七千多个测试。你真没看错，就是几万个。

JavaScript 测试框架的其他选择有 [QUnit](https://qunitjs.com/)和 [Mocha](http://mochajs.org/)。和代码检验一样，你能使用 Grunt 之类的工具自动化测试，甚至可以往全栈靠一点，使用 [Selenium](http://www.seleniumhq.org/) 测试浏览器。

## 浏览器开发者工具

我提到的最后一个工具在浏览器里——开发者工具。你能找到许多关于此的文章、演讲和视频，我亦不需赘言。在今天所说的所有内容中，这一条我认为应该是 web 开发者的**必需知识**。你可以写出不能用的代码，可以不是什么都懂，但起码还有开发者工具帮你找出错误所在，然后你只需要 google 一下问题就能解决了。

再多提一个建议，你不该把自己吊在一个浏览器的开发者工具上。几年前我在鼓捣 App Cache （没错我就是爱自虐），碰上了个只在 Chrome 下出现的问题。当时开着开发者工具，但是没啥用。我灵机一动用 Firefox 打开我的代码，使用它的工具调试，然后我**立刻**就发现了问题所在。Firefox 列出的关于请求的信息比 Chrome 多。我用了一次这个工具立马解决了问题（好吧其实这是胡诌的，Firefox 的确显出问题所在不过我修复问题也用了好些时间）。如果你卡在某个问题上，不如试试打开其他浏览器看看错误报告有没有多说些什么。

万一万一你真从没_见_过开发者工具，以下有些主流浏览器工具阅览指南和极好的详细教程。

### Google Chrome

点击浏览器右上角的汉堡菜单图标，选择"更多工具" -> "开发者工具"。也可以用键盘快捷键打开，例如在 OSX 下快捷键是 `CMD+SHIFT+C`。关于谷歌的开发者工具文档可到 [Chrome 开发者工具纵览](https://developer.chrome.com/devtools)寻找。

### Mozilla Firefox

在主菜单的"工具"栏里，选择 "Web 开发者" -> "切换工具箱"。Firefox 工具栏很酷，在同一菜单下，有许多快速打开开发者工具命令。详情请见 [Firefox 开发者工具](https://developer.mozilla.org/en-US/docs/Tools)

### Apple Safari (传说中用来看 Apple keynotes 的浏览器)

你得先开启"开发"菜单才能使用开发者工具。进入 Safari 偏好设置，选择"高级"，选中"在菜单栏中显示'开发'菜单"。然后就能从"开发菜单"里通过"显示 Web 检查器"（或者其下的其他三个菜单项）打开工具。详情见[关于 Safari Web 检查器](https://developer.apple.com/library/safari/documentation/AppleApplications/Conceptual/Safari_Developer_Guide/Introduction/Introduction.html)。

### Internet Explorer

点击浏览器右上角的设置按钮或按下键盘 F12键打开开发者工具。详情见[使用 F12 开发者工具](https://msdn.microsoft.com/library/bg182326%28v=vs.85%29)。

## 更多学习

有时候感觉像我们这些做开发的，工作就从来没有完成的时候。你知道在这篇文章写作期间有13个新的 JavaScript 框架发布了么？讲真！以下是最后几个让你学习并且跟上潮流的建议，尽量跟上。

学习方面，我选择专注于 [Mozilla Developer Network](http://developer.mozilla.org)(你要是准备 google 什么，最好加上 "mdn" 作为前缀)，[CodeSchool](http://www.codeschool.com) (一个商业的编程学习视频网站，内容还不错), 和 [Khan Academy](https://www.khanacademy.org/)。特别要说下 Mozilla 开发者网络(MDN)，多年来我以为它只有 Netscape/Firefox 知识而忽视了它，蠢死了我。

另一建议是多读代码！你们中许多人都用过 jQuery，但你有打开它的源码看看它的实现么？读别人的代码是一个很好的学习技巧的和方法的途径。还有一个听起来可能有点恐怖，不过我真的强烈建议你分享自己的代码。不光是多了双雪亮的眼睛（或者成千上万双）来审视你的代码，你也许也能帮助其他的人。几年前我看见一个初级程序员分享他的代码，虽然里面有些菜鸟级的错误，但也有一些超棒的技巧。

为获取最新资讯，我订阅了 [Cooper Press](http://cooperpress.com) 发行的一系列周报。有 HTML 的，JavaScript 的，Node 的和移动开发(Mobile) 和其他一系列。信息可能会淹没你，尽你所能阅读就行。当我看到某个新发布的工具有我_并不_需要的 XXX 功能的时候，我也不用去学它。我只要记住"诶哟有个工具有 XXX 功能"，以后我需要这个功能的时候再去学习。

_感谢[Lemsipmatt](https://flic.kr/p/5PS638)提供的首图_
