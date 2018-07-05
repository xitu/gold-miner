> * 原文地址：[Announcing the Alexa Skills Kit for Node.js](https://developer.amazon.com/zh/blogs/post/Tx213D2XQIYH864/announcing-the-alexa-skills-kit-for-node-js)
> * 原文作者：[David Isbitski](https://developer.amazon.com/blogs/alexa/author/David+Isbitski)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/announcing-the-alexa-skills-kit-for-node-js.md](https://github.com/xitu/gold-miner/blob/master/TODO1/announcing-the-alexa-skills-kit-for-node-js.md)
> * 译者：
> * 校对者：

# Announcing the Alexa Skills Kit for Node.js

Today we’re happy to announce the new [alexa-sdk](https://github.com/alexa/alexa-skill-sdk-for-nodejs) for Node.js to help you build skills faster and with less complexity. Creating an Alexa skill using the [Alexa Skills Kit](http://developer.amazon.com/ask), [Node.js](https://nodejs.org/en/) and [AWS Lambda](https://aws.amazon.com/lambda/) has become one of the most popular ways we see skills created today. The event-driven, non-blocking I/O model of Node.js is well suited for an Alexa skill and Node.js is one of the largest ecosystems of open source libraries in the world. Plus, with AWS Lambda is free for the first one million calls per month, which can support skill hosting for most developers. And you don’t need to manage any SSL certificates when using AWS Lambda (since the Alexa Skills Kit is a trusted trigger).

While setting up an Alexa skill using AWS Lambda, Node.js and the Alexa Skills Kit has been a simple process, the actual amount of code you have had to write has not. We have seen a large amount of time spent in Alexa skills on handling session attributes, skill state persistence, response building and behavior modeling. With that in mind the Alexa team set out to build an Alexa Skills Kit SDK specifically for Node.js that will help you avoid common hang-ups and focus on your skill’s logic instead of boiler plate code. 

## Enabling Faster Alexa Skill Development with the Alexa Skills Kit for Node.js (alexa-sdk)

With the new alexa-sdk, our goal is to help you build skills faster while allowing you to avoid unneeded complexity. Today, we are launching the SDK with the following capabilities:

*   Hosted as NPM package allowing simple deployment to any Node.js environment
*   Ability to build Alexa responses using built-in events
*   Helper events for new sessions and unhandled events that can act as a ‘catch-all’ events
*   Helper functions to build state-machine based Intent handling
    *   This makes it possible to define different event handlers based on the current state of the skill
*   Simple configuration to enable attribute persistence with DynamoDB
*   All speech output is automatically wrapped as SSML
*   Lambda event and context objects are fully available via this.event and this.contextAbility to override built-in functions giving you more flexibility on how you manage state or build responses. For example, saving state attributes to AWS S3.

## Installing and Working with the Alexa Skills Kit for Node.js (alexa-sdk)

The alexa-sdk is immediately available on [github here](https://github.com/alexa/alexa-skill-sdk-for-nodejs) and can be deployed as a node package using the following command from within your Node.js environment:

```
npm install --save alexa-sdk
```

In order to start using the alexa-sdk you will need to first import the library. To do this within your own project simply create a file named index.js and add the following to it:

```
var Alexa = require('alexa-sdk');

exports.handler = function(event, context, callback){

    var alexa = Alexa.handler(event, context);

};
```

This will import the alexa sdk and set up an alexa object for us to work with. Next, we need to handle when the intents for our skill. Thankfully, the alexa-sdk makes it simple to have a function fire on every Intent we would like. For example, to create a handler for a ‘HelloWorldIntent’ we simply add the following:

```
var handlers = {

    'HelloWorldIntent': function () {

        this.emit(':tell', 'Hello World!');

                  }

};
```

Notice the new syntax above for “:tell”? The alexa-sdk follows a tell/ask response methodology for generating your [outputSpeech response objects](https://developer.amazon.com/public/solutions/alexa/alexa-skills-kit/docs/alexa-skills-kit-interface-reference#Response Format). If we wanted to ask the user for information we would replace the above with:

```
    this.emit(‘:ask’, ’What would you like to do?’, ’Please say that again?’);
```

In fact, many of the responses you would generate for your skill follow this same syntax! Here are some additional examples for common skill response generation:

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

this.emit(':responseReady'); // Called after the response is built but before it is returned to the Alexa service. Calls :saveState.

this.emit(':saveState', false); // Handles saving the contents of this.attributes and the current handler state to DynamoDB and then sends the previously built response to the Alexa service. Override if you wish to use a different persistence provider. The second attribute is optional and can be set to ‘true’ to force saving.

this.emit(':saveStateError'); // Called if there is an error while saving state. Override to handle any errors yourself.
```

Once we have set up our event handlers, in this case for our NewSession, we need to register them using the registerHandlers function of the alexa object we just created.

```
exports.handler = function(event, context, callback){

    var alexa = Alexa.handler(event, context);

    alexa.registerHandlers(handlers);

};
```

You can also register multiple handler objects at once. So instead of just the handlers object, we create for NewSession we could have many different types of handles for other events and register them all at once like this:

```
    alexa.registerHandlers(handlers, handlers2, handlers3, ...);
```

The handlers you define can call each other, making it possible to ensure your responses are uniform.  Here is an example where our LaunchRequest and IntentRequest (of HelloWorldIntent) both return the same ‘Hello World’ message.

```
var handlers = {

    'LaunchRequest': function () {

        this.emit('HelloWorldIntent');

    },

    'HelloWorldIntent': function () {

        this.emit(':tell', 'Hello World!');

};
```

Once you are done registering all of your intent handler functions, you simply use the execute function from the alexa object to run your skill’s logic. The final line would look like this:

```
exports.handler = function(event, context, callback){

    var alexa = Alexa.handler(event, context);

    alexa.registerHandlers(handlers);

    alexa.execute();

};
```

You can download a full working sample off github. We have also updated the following Node.js sample skills to work with the alexa-sdk: [Fact](https://github.com/alexa/skill-sample-nodejs-fact), [HelloWorld](https://github.com/alexa/skill-sample-nodejs-hello-world), [HighLow](https://github.com/alexa/skill-sample-nodejs-highlowgame), [HowTo](https://github.com/alexa/skill-sample-nodejs-howto) and [Trivia](https://github.com/alexa/skill-sample-nodejs-trivia).

## Making Skill State Management Simpler

The alexa-sdk will route incoming intents to the correct function handler based on state. It is simply a string stored in your session attributes indicating the current state of the skill. You can emulate the built-in intent routing by appending the state string to the intent name when defining your intent handlers, but the alexa-sdk helps do that for you.

For example, let's create a simple number-guessing game with "start" and "guess" states based on our previous example of handling a NewSession event.

```
var states = {
    GUESSMODE: '_GUESSMODE', // User is trying to guess the number.
    STARTMODE: '_STARTMODE'  // Prompt the user to start or restart the game.
};

var newSessionHandlers = {

 // This will short-cut any incoming intent or launch requests and route them to this handler.

  'NewSession': function() {

    this.handler.state = states.STARTMODE;

    this.emit(':ask', 'Welcome to The Number Game. Would you like to play?.');

   }

 };
```

Notice that when a new session is created we simply set the state of our skill into STARTMODE using this.handler.state. The skills state will automatically be persisted in your skill's session attributes, and will be optionally persisted across sessions if you set a DynamoDB table.

It is also important point out that NewSession is a great catch-all behavior and a good entry point but it is not required. NewSession will only be invoked if a handler with that name is defined. Each state you define can have its own NewSession handler which will be invoked if you are using the built-in persistence. In the above example we could define different NewSession behavior for both states.STARTMODE and states.GUESSMODE giving us added flexibility.

In order to define intents that will respond to the different states of our skill we need to use the Alexa.CreateStateHandler function. Any intent handlers defined here will only work when the skill is in a specific state, giving us even greater flexibility!

For example, if we are in the GUESSMODE state we defined above we want to handle a user responding to a question. This can be done using StateHandlers like this:

```
var guessModeHandlers = Alexa.CreateStateHandler(states.GUESSMODE, {

    'NewSession': function () {

        this.handler.state = '';

        this.emitWithState('NewSession'); // Equivalent to the Start Mode NewSession handler

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

            // With a callback, use the arrow function to preserve the correct 'this' context

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

On the flip side, if I am in STARTMODE I can define my StateHandlers to be the following:

```
var startGameHandlers = Alexa.CreateStateHandler(states.STARTMODE, {

    'NewSession': function () {

        this.emit('NewSession'); // Uses the handler in newSessionHandlers

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

Take a look at how AMAZON.YesIntent and AMAZON.NoIntent are not defined in the guessModeHandlers object, since it doesn’t make sense for a “yes” or “no” response in this state. Those intents will be caught by the ‘Unhandled’ handler.

Also, notice the different behavior for NewSession and Unhandled across both states? In this game, we ‘reset’ the state by calling a NewSession handler defined in the newSessionHandlers object. You can also skip defining it and alexa-sdk will call the intent handler for the current state. Just remember to register your State Handlers before you call alexa.execute() or they will not be found.

Your attributes will be automatically saved when you end the session, but if the user ends the session you have to emit the ‘:saveState’ event (this.emit(‘:saveState’, true) to force a save. You should do this in your SessionEndedRequest handler which is called when the user ends the session by saying ‘quit’ or timing out. Take a look at the example above.

We have wrapped up the above example into a high/low number guessing game skill you can [download here](https://github.com/alexa/skill-sample-nodejs-highlowgame).

## Persisting Skill Attributes through DynamoDB

Many of you would like to persist your session attribute values into storage for further use. The alexa-sdk integrates directly with [Amazon DynamoDB](https://aws.amazon.com/dynamodb/) (a NoSQL database service) to enable you to do this with a single line of code.

Simply set the name of the DynamoDB table on your alexa object before you call alexa.execute.

```
exports.handler = function(event, context, callback) {
    var alexa = Alexa.handler(event, context);
    alexa.appId = appId;
    alexa.dynamoDBTableName = ’YourTableName'; // That’s it!
    alexa.registerHandlers(State1Handlers, State2Handlers);
    alexa.execute();
};
```

Then later on to set a value you simply need to call into the attributes property of the alexa object. No more put and get separate functions!

```
this.attributes[”yourAttribute"] = ’value’;
```

You can [create the table manually](http://docs.aws.amazon.com/amazondynamodb/latest/developerguide/SampleData.CreateTables.html) beforehand or simply give your Lambda function DynamoDB [create table permissions](http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_CreateTable.html) and it will happen automatically. Just remember it can take a minute or so for the table to be created on the first invocation.

Try extending the HighLow game:

*   Have it store your average number of guesses per game
*   Add [sound effects](https://developer.amazon.com/public/solutions/alexa/alexa-skills-kit/docs/speech-synthesis-markup-language-ssml-reference#audio)
*   Give the player a limited amount of guesses

For more information about getting started with the Alexa Skills Kit, check out the following additional assets:

[Alexa Skills Kit for Node.js](https://github.com/alexa/alexa-skill-sdk-for-nodejs)  
[Alexa Dev Chat Podcast](http://bit.ly/alexadevchat)  
[Alexa Training with Big Nerd Ranch](https://developer.amazon.com/public/community/blog/tag/Big+Nerd+Ranch)  
[Intro to Alexa Skills On Demand](https://goto.webcasts.com/starthere.jsp?ei=1087595)  
[Voice Design 101 On Demand](https://goto.webcasts.com/starthere.jsp?ei=1087592)  
[Alexa Skills Kit (ASK)](https://developer.amazon.com/ask)  
[Alexa Developer Forums](https://forums.developer.amazon.com/forums/category.jspa?categoryID=48)

-Dave ([@TheDaveDev](http://twitter.com/thedavedev))

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
