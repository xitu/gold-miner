> * 原文地址：[Announcing the Alexa Skills Kit for Node.js](https://developer.amazon.com/zh/blogs/post/Tx213D2XQIYH864/announcing-the-alexa-skills-kit-for-node-js)
> * 原文作者：[David Isbitski](https://developer.amazon.com/blogs/alexa/author/David+Isbitski)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/announcing-the-alexa-skills-kit-for-node-js.md](https://github.com/xitu/gold-miner/blob/master/TODO1/announcing-the-alexa-skills-kit-for-node-js.md)
> * 译者：[Yuhanlolo] (https://github.com/Yuhanlolo)
> * 校对者：

# 基于 Node.js 的 Alexa Skills Kit 发布了！

我们今天很高兴地发布了最新的基于 Node.js 的 [alexa-sdk](https://github.com/alexa/alexa-skill-sdk-for-nodejs) 来帮助开发者们更加简单和快捷地开发 Alexa skill。通过 [Alexa Skills Kit](http://developer.amazon.com/ask)、 [Node.js](https://nodejs.org/en/)，和 [AWS Lambda](https://aws.amazon.com/lambda/) 开发 Alexa skill 如今已成为最受欢迎的 skill 开发方式。Node.js 事件驱动，非阻塞的特性，使它非常适合开发 Alexa skill，并且 Node.js 也是世界上最大开源系统之一。除此之外，为每个月前一百万个网络请求提供免费服务的亚马逊网络服务系统 (AWS) Lambda，能够支持大部分开发者从事 skill 的开发。在使用 AWS Lambda 的同时，你不需要担心管理任何 SSL 证书的问题 (因为 Alexa Skills Kit 是被 AWS 信任的触发器)。

在使用 AWS Lambda 创建 Alexa skill 的时候，加入 Node.js 和 Alexa Skills Kit 只是一个简单的流程，但你实际上所需要写的代码要比这复杂得多。我们已经意识到大部分开发 skill 的时间和精力都花在了处理时域 (session) 的属性、skill 的状态留存，创建回复以及行为模式上面。因此，Alexa 团队着手于开发一个基于 Node.js 的 Alexa Skills Kit SDK 来帮助你避免这些常见的烦恼，从而专注于你的 skill 自身的逻辑开发而不是样板化编码。 

##  在基于 Node.js 的 Alexa Skills Kit (alexa-sdk) 的帮助下，Alexa Skill 的开发将会变得更快捷

通过新版 alexa-sdk，我们的目标是帮助你在能够避免不必要的复杂度的情况下，更快捷地开发 skills。如今我们发布了这一版本的 SDK，它具备以下几个特点：  

*   能够承载 NPM 安装包从而让你的 Node.js 开发环境更加简洁  
*   可以通过内置事件创建 Alexa 的回复  
*   为新的 session 内置帮助事件 (Helper events)，并且添加了未处理事件 (unhandled events) 来捕捉所有异常  
*   根据用户意图 (intent) 处理使用帮助函数 (Helper function) 去创建状态机  
    *   这让根据当前 skill 的状态定义不同的事件管理器成为现实  
*   通过动态数据库 (Amazon DynamoDB)，属性留存的配置变得更加简单   
*   所有输出的语音将自动封装在 SSML 下  
*   Lambda 事件和和上下文对象 (context objects) 将通过 this.event 读取，并且可以通过 this.contextAbility 重写内置函数，从而让你的状态管理和回复创建更加灵活。例如，将状态属性储存到 AWS S3 上。  

## 安装和调试基于 Node.js 的 Alexa Skills Kit (alexa-sdk)

alexa-sdk 已经上传到了 [github](https://github.com/alexa/alexa-skill-sdk-for-nodejs)，并且可以以一个 node 包的形式通过下面的指令在你的 Node.js 环境下安装：

```
npm install --save alexa-sdk
```

为了开始使用 alexa-sdk，你需要首先倒入它的库。你只需要在你的项目里简单地创建一个名为 index.js 的文件然后加入以下代码：  

```
var Alexa = require('alexa-sdk');

exports.handler = function(event, context, callback){

    var alexa = Alexa.handler(event, context);

};
```

这几行代码将会导入 alexa sdk 并且为我们创建一个 alexa 对象以便之后使用。接着，我们需要处理与 skill 交互的️ intent。多亏了 alexa-sdk 使得每个函数能够按照我们想要的方式，在对应的 intent 输入时被激活。例如，创建一个为 ‘HelloWorldIntent’ 服务的事件管理器，我们只需要简单地用以下代码实现：  

```
var handlers = {

    'HelloWorldIntent': function () {

        this.emit(':tell', 'Hello World!');

                  }

};
```

注意这里以上语法规则 “:tell”? alexa-sdk 遵循 tell/ask 回复的方式以此来生成你的 [语音输出回复对象](https://developer.amazon.com/public/solutions/alexa/alexa-skills-kit/docs/alexa-skills-kit-interface-reference#Response Format)。如果我们想要问用户问题的话，我们需要把以上代码改成：  

```
    this.emit(‘:ask’, ’What would you like to do?’, ’Please say that again?’);
```

事实上，你的 skill 生成的许多回复都遵循一样的语法规则。下面是一些常见的 skill 回复生成的例子：  

```
var speechOutput = 'Hello world!';

var repromptSpeech = 'Hello again!';

this.emit(':tell', speechOutput);

this.emit(':ask', speechOutput, repromptSpeech);

var cardTitle = 'Hello World Card';

var cardContent = 'This text will be displayed in the companion app card.';

var imageObj = {

    smallImageUrl: 'https://imgs.xkcd.com/comics/standards.png',

    largeImageUrl: 'https://imgs.xkcd.com/comics/standards.png'

};

this.emit(':askWithCard', speechOutput, repromptSpeech, cardTitle, cardContent, imageObj);

this.emit(':tellWithCard', speechOutput, cardTitle, cardContent, imageObj);

this.emit(':tellWithLinkAccountCard', speechOutput);

this.emit(':askWithLinkAccountCard', speechOutput);

this.emit(':responseReady'); // 在回复创建之后立即被调用，但是调用发生在返回 Alexa 服务之前。Calls :saveState.

this.emit(':saveState', false); // 事件管理器将 this.attributes 的内容和当前管理器到动态数据库的状态储存起来，然后将之前内置的回复发送到 Alexa 服务。如果你想用别的方式处理留存状态，可以重写它。其中的第二个属性是可选的并且可以通过将它设置为 “true” 以强制储存。

this.emit(':saveStateError'); // 在存储状态的过程出错时被调用。如果你想自己处理异常的话，可以重写它。
```

一旦我们创建好事件管理器，在新的 session 场景下，我们需要用之前创建的 alexa 对象中的 registerHandlers 函数去注册这些管理器。  

```
exports.handler = function(event, context, callback){

    var alexa = Alexa.handler(event, context);

    alexa.registerHandlers(handlers);

};
```

你也可以同时注册多个事件管理器。与其创建单个管理器对象，我们创建了一个新的 session，其中有许多处理不同事件的不同管理器，并且我们可以通下面的代码同时注册它们：  

```
    alexa.registerHandlers(handlers, handlers2, handlers3, ...);
```

你所定义的事件管理器可以相互调用，从而保证你的 skill 的回复是统一的。下面是 LaunchRequest 和 IntentRequest 的一个例子(在 HelloWorldIntent 中)都返回 “Hello World” 消息的一个例子。

```
var handlers = {

    'LaunchRequest': function () {

        this.emit('HelloWorldIntent');

    },

    'HelloWorldIntent': function () {

        this.emit(':tell', 'Hello World!');

};
```

一旦你注册了所有的管理器函数，你只需要简单地用 alexa 对象里的执行函数去运行 skill 的逻辑就可以了。最后一行代码是这样的：  

```
exports.handler = function(event, context, callback){

    var alexa = Alexa.handler(event, context);

    alexa.registerHandlers(handlers);

    alexa.execute();

};
```

你可以从 github 上下载完整的示例。我们还提供了最新的基于 Node.js 和 alexa-sdk 开发的 skill 示例：   [Fact](https://github.com/alexa/skill-sample-nodejs-fact)， [HelloWorld](https://github.com/alexa/skill-sample-nodejs-hello-world)， [HighLow](https://github.com/alexa/skill-sample-nodejs-highlowgame)， [HowTo](https://github.com/alexa/skill-sample-nodejs-howto) 和 [Trivia](https://github.com/alexa/skill-sample-nodejs-trivia)。

## 让 Skill 的状态管理更简单

alexa-sdk 会根据当前状态把即将接受的 intent 传送给正确的管理器函数。它其实只是 session 属性中一个简单的字符串，用来表示 skill 的状态。在定义 intent 管理器的时候，你也可以通过将表示状态的字符串添加到 intent 的名称后面来模仿这个内置传送的过程，但事实上 alexa-sdk 已经帮你做到了。

比如说，让我们根据上一个管理新的 session 事件的例子，创建一个简单的有“开始”和“猜数”两个状态的猜数字游戏。  

```
var states = {
    GUESSMODE: '_GUESSMODE', // User is trying to guess the number.
    STARTMODE: '_STARTMODE'  // Prompt the user to start or restart the game.
};

var newSessionHandlers = {

 // 以下代码将会切断任何即将输入的 intent 或者启动请求，并且把它们都传送给这个管理器。

  'NewSession': function() {

    this.handler.state = states.STARTMODE;

    this.emit(':ask', 'Welcome to The Number Game. Would you like to play?.');

   }

 };
```

注意当一个新的 session 被创建时，我们简单地通过 this.handler.state 把 skill 的状态设置为 STARTMODE。此时skill 的状态将会自动被留存在 session 的属性中，如果你设置了动态数据库表格的话，你可以选择将它留存于各个 session 当中。

值得注意的是，NewSession 是一个很棒的捕捉各种行为的管理器，同时也是一个很好的 skill 入口，但它不是必须的。NewSession 只会在一个以它命名的函数中被唤醒。你所定义的每一个状态都可以有它们自己的 NewSession 管理器，在你使用内置留存时被唤醒。在上面的例子中，我们可以更加灵活地为 states.STARTMODE 和 states.GUESSMODE 定义不同的 NewSession 行为。  

为了定义回复 skill 在不同状态下的 intents，我们需要使用 Alexa.CreateStateHandler 函数。任何在这里定义的 intent 管理器将只会在特定状态下工作，这让我们的开发操作更加灵活！

例如，如果我们在上面定义的 GUESSMODE 状态下，我们想要处理用户对一个问题的回复。这可以通过 StateHandlers 实现，就像这样：   

```
var guessModeHandlers = Alexa.CreateStateHandler(states.GUESSMODE, {

    'NewSession': function () {

        this.handler.state = '';

        this.emitWithState('NewSession'); // 等同于 Start Mode 下的 NewSession handler

    },

    'NumberGuessIntent': function() {

        var guessNum = parseInt(this.event.request.intent.slots.number.value);

        var targetNum = this.attributes["guessNumber"];

        console.log('user guessed: ' + guessNum);



        if(guessNum > targetNum){

            this.emit('TooHigh', guessNum);

        } else if( guessNum < targetNum){

            this.emit('TooLow', guessNum);

        } else if (guessNum === targetNum){

            // 通过一个 callback 函数，用 arrow 函数储存正确的 “this” context

            this.emit('JustRight', () => {

                this.emit(':ask', guessNum.toString() + 'is correct! Would you like to play a new game?',

                'Say yes to start a new game, or no to end the game.');

        })

        } else {

            this.emit('NotANum');

        }

    },

    'AMAZON.HelpIntent': function() {

        this.emit(':ask', 'I am thinking of a number between zero and one hundred, try to guess and I will tell you' +

            ' if it is higher or lower.', 'Try saying a number.');

    },

    'SessionEndedRequest': function () {

        console.log('session ended!');

        this.attributes['endedSessionCount'] += 1;

        this.emit(':saveState', true);

    },

    'Unhandled': function() {

        this.emit(':ask', 'Sorry, I didn\'t get that. Try saying a number.', 'Try saying a number.');

    }

});
```

另一方面，如果我们在 STARTMODE 状态下，我可以用以下方式定义 StateHandlers：  

```
var startGameHandlers = Alexa.CreateStateHandler(states.STARTMODE, {

    'NewSession': function () {

        this.emit('NewSession'); // 在 newSessionHandlers 使用管理器

    },

    'AMAZON.HelpIntent': function() {

        var message = 'I will think of a number between zero and one hundred, try to guess and I will tell you if it' +

            ' is higher or lower. Do you want to start the game?';

        this.emit(':ask', message, message);

    },

    'AMAZON.YesIntent': function() {

        this.attributes["guessNumber"] = Math.floor(Math.random() * 100);

        this.handler.state = states.GUESSMODE;

        this.emit(':ask', 'Great! ' + 'Try saying a number to start the game.', 'Try saying a number.');

    },

    'AMAZON.NoIntent': function() {

        this.emit(':tell', 'Ok, see you next time!');

    },

    'SessionEndedRequest': function () {

        console.log('session ended!');

        this.attributes['endedSessionCount'] += 1;

        this.emit(':saveState', true);

    },

    'Unhandled': function() {

        var message = 'Say yes to continue, or no to end the game.';

        this.emit(':ask', message, message);

    }
```

我们可以看到 AMAZON.YesIntent 和 AMAZON.NoIntent 在 guessModeHandlers 对象中是没有被定义的，因为对于该状态来说，“是”或者“不是” 的回复是没有意义的。这样的回复将会被 “Unhandled” 管理器捕捉到。

还有就是，注意在 NewSession 和 Unhandled 这两个状态中的不同行为。在这个游戏中，我们通过调用 newSessionHandlers 对象中的 NewSession 管理器“重置” skill 的状态。你也可以跳过这一步，然后 alexa-sdk 将会为当前状态调用 intent 管理器。你只需要记住在调用 alexa.execute() 之前去注册你的状态管理器，否则它们将不会被找到。

所有属性将会在你的 skill 结束 session 时自动保存，但是如果用户自己结束了当前的 session，你需要 emit “:saveState” 事件 (this.emit(‘:saveState’, true) 来强制保存这些属性。 你应该在 SessionEndedRequest 管理器中做这件事，因为 SessionEndedRequest 管理器将会在用户通过“退出”或回复超时结束当前 session 的时候被调用。你可以看看以上的代码示例。

我们将上面的例子写在了一个高/低猜数字游戏中，你可以点击[这里下载](https://github.com/alexa/skill-sample-nodejs-highlowgame).

## 通过动态数据库 (DynamoDB) 留存 Skill 属性

很多人喜欢将 session 属性值储存到数据库中以便日后使用。alexa-sdk 直接结合了 [Amazon DynamoDB](https://aws.amazon.com/dynamodb/) (一个非 SQL 的数据库服务) 让你只需要几行代码就可以实现属性存储。

简单地在你调用 alexa.execute 之前为 alexa 对象中的 DynamoDB 的表格设置一个名字。

```
exports.handler = function(event, context, callback) {
    var alexa = Alexa.handler(event, context);
    alexa.appId = appId;
    alexa.dynamoDBTableName = ’YourTableName'; // That’s it!
    alexa.registerHandlers(State1Handlers, State2Handlers);
    alexa.execute();
};
```

之后，你只需要调用 alexa 对象的 attributes 为你的属性设置一个值。不再需要其他输入而得到单独的函数！

```
this.attributes[”yourAttribute"] = ’value’;
```

你可以提前[手动创建一个表格](http://docs.aws.amazon.com/amazondynamodb/latest/developerguide/SampleData.CreateTables.html) 或者为你的 Lambda 函数的 DynamoDB [创建表格权限](http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_CreateTable.html) 然后一切都会自动生成。只需记住在第一次唤醒 skill 的时候，创建表格可能会花费几分钟的时间。  

尝试扩展高低猜数字游戏：  

*   让它能够储存你一次游戏中所猜的平均数  
*   加入 [声音效果](https://developer.amazon.com/public/solutions/alexa/alexa-skills-kit/docs/speech-synthesis-markup-language-ssml-reference#audio)
*   给玩家有限的猜数字时间  

想要获取更多关于学习使用 Alexa Skills Kit 开发的信息，可以看看下面的链接：  

[基于 Node.js 的 Alexa Skills Kit](https://github.com/alexa/alexa-skill-sdk-for-nodejs)  
[Alexa 开发者播客](http://bit.ly/alexadevchat)  
[Alexa 开发培训](https://developer.amazon.com/public/community/blog/tag/Big+Nerd+Ranch)  
[关于 Alexa Skills 的介绍](https://goto.webcasts.com/starthere.jsp?ei=1087595)  
[101 条语音交互设计指南](https://goto.webcasts.com/starthere.jsp?ei=1087592)  
[Alexa Skills Kit (ASK)](https://developer.amazon.com/ask)  
[Alexa 开发者论坛](https://forums.developer.amazon.com/forums/category.jspa?categoryID=48)

-Dave ([@TheDaveDev](http://twitter.com/thedavedev))

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
