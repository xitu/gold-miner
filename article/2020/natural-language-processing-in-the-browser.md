> * 原文地址：[Natural Language Processing in the Browser](https://medium.com/better-programming/natural-language-processing-in-the-browser-8ca5fdf2488b)
> * 原文作者：[Martin Novák](https://medium.com/@ragnarecek)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/natural-language-processing-in-the-browser.md](https://github.com/xitu/gold-miner/blob/master/article/2020/natural-language-processing-in-the-browser.md)
> * 译者：
> * 校对者：

# Natural Language Processing in the Browser

![Image source: Author](https://cdn-images-1.medium.com/max/3192/1*X-jYECtYbLdX_c7GRz_DTQ.png)

It is possible to build a chatbot for your own website without dependency on a third-party service like [Dialogflow](https://cloud.google.com/dialogflow/docs) or [Watson](https://www.ibm.com/watson), and without a server. I will show you how to build a chatbot that will completely run in the browser.

I will assume that you have some understanding of JavaScript and insight into how natural language processing works. No advanced knowledge or machine learning experience is needed.

If anyone tells you that it’s crazy to do machine learning in a browser using JavaScript, then don’t listen to that, because soon you will know better yourself.

Our code will be based on [NLP.js](https://github.com/axa-group/nlp.js) version 4. [NLP](https://github.com/axa-group/nlp.js) is an open source library for natural language processing written in JavaScript. The project will allow you to train the NLP directly in a browser from a corpus and add a Hook to any intent to programmatically change the answer.

The final project can be found on my GitHub repository: [https://github.com/MeetMartin/nlpjs-web](https://github.com/MeetMartin/nlpjs-web). You can download it, open index.html, and just play with the final chatbot.

Every true developer nowadays should have some experience with artificial intelligence, and what is more sci-fi than talking to your computer using something that you have developed yourself.

## Install Packages

Create a new npm project in any folder and install NLP packages:

```bash
npm i -D @nlpjs/core @nlpjs/lang-en-min @nlpjs/nlp @nlpjs/request-rn@nlpjs/request-rn
```

We will also need [browserify](https://github.com/browserify/browserify#usage) and [terser](https://terser.org/docs/cli-usage) to be able to build NLP for browser use:

```bash
npm i -D browserify terser
```

Enjoy the smell of a new project with freshly installed packages. You deserve it.

## Build NLP

The first step is to build NLP using browserify and terser. For that we just need to create a basic setup in buildable.js:

```JavaScript
const core = require('@nlpjs/core');
const nlp = require('@nlpjs/nlp');
const langenmin = require('@nlpjs/lang-en-min');
const requestrn = require('@nlpjs/request-rn');

window.nlpjs = { ...core, ...nlp, ...langenmin, ...requestrn };
```

We are using only the core of NLP and a small English package. To build everything, just add a build command into your `package.json`:

```JSON
{
  "name": "nlpjs-web",
  "version": "1.0.0",
  "scripts": {
    "build": "browserify ./buildable.js | terser --compress --mangle > ./dist/bundle.js",
  },
  "devDependencies": {
    "@nlpjs/core": "^4.14.0",
    "@nlpjs/lang-en-min": "^4.14.0",
    "@nlpjs/nlp": "^4.15.0",
    "@nlpjs/request-rn": "^4.14.3",
    "browserify": "^17.0.0",
    "terser": "^5.3.8"
  }
}

```

Now run the build:

```bash
npm run build
```

You should end up with `./dist/bundle.js` with just about 137 KB. It is also good to note that NLP has a [very impressive list of supported languages](https://github.com/axa-group/nlp.js/blob/master/docs/v4/language-support.md#supported-languages). However, only English has an optimized version for a browser.

## Train NLP in a Browser

Now that we have created our bundle, we can train our NLP in a browser. Create this `index.html`:

```HTML
<html>
<head>
    <title>NLP in a browser</title>
    <script src='./dist/bundle.js'></script>
    <script>
        const {containerBootstrap, Nlp, LangEn, fs} = window.nlpjs;

        const setupNLP = async corpus => {
            const container = containerBootstrap();
            container.register('fs', fs);
            container.use(Nlp);
            container.use(LangEn);
            const nlp = container.get('nlp');
            nlp.settings.autoSave = false;
            await nlp.addCorpus(corpus);
            nlp.train();
            return nlp;
        };

        (async () => {
            const nlp = await setupNLP('https://raw.githubusercontent.com/jesus-seijas-sp/nlpjs-examples/master/01.quickstart/02.filecorpus/corpus-en.json');
        })();
    </script>
</head>
<body>
    <h1>NLP in a browser</h1>
    <div id="chat"></div>
    <form id="chatbotForm">
        <input type="text" id="chatInput" />
        <input type="submit" id="chatSubmit" value="send" />
    </form>
</body>
</html>
```

The function `setupNLP` for us takes care of the setup of the library as well as the training. A corpus is a JSON file that defines the conversation for our chatbot in this format:

```JSON
{
  "name": "Corpus",
  "locale": "en-US",
  "data": [
    {
      "intent": "agent.acquaintance",
      "utterances": [
        "say about you",
        "why are you here",
        "what is your personality",
        "describe yourself",
        "tell me about yourself",
        "tell me about you",
        "what are you",
        "who are you",
        "I want to know more about you",
        "talk about yourself"
      ],
      "answers": [
        "I'm a virtual agent",
        "Think of me as a virtual agent",
        "Well, I'm not a person, I'm a virtual agent",
        "I'm a virtual being, not a real person",
        "I'm a conversational app"
      ]
    },
    {
      "intent": "agent.age",
      "utterances": [
        "your age",
        "how old is your platform",
        "how old are you",
        "what's your age",
        "I'd like to know your age",
        "tell me your age"
      ],
      "answers": [
        "I'm very young",
        "I was created recently",
        "Age is just a number. You're only as old as you feel"
      ]
    }
  ]
}
```

The **intent** is a unique identifier of a conversation node, and its name should represent the intention of the user that the chatbot reacts to. **Utterances** are a set of training examples of what a user can say to trigger the intent. **Answers** are then an array of responses that the chatbot will randomly choose from.

To train our chatbot, we are borrowing a larger corpus from the libraries’ examples: [https://raw.githubusercontent.com/jesus-seijas-sp/nlpjs-examples/master/01.quickstart/02.filecorpus/corpus-en.json](https://raw.githubusercontent.com/jesus-seijas-sp/nlpjs-examples/master/01.quickstart/02.filecorpus/corpus-en.json). But for your use case, feel free to create your own corpus. Just remember that the library expects to read the corpus from some URL.

When you open `index.html` in a browser, you should see a simple chat form that doesn’t do anything yet.

![](https://cdn-images-1.medium.com/max/2000/1*jcgI1OlIsUD8VcGVzxAiYw.png)

But if you open a browser console, you can already see successful training output:

![](https://cdn-images-1.medium.com/max/2828/1*GddApxHIsJ5K4AzzjEIiOw.png)

The training is super fast and makes the trained model available to your chatbot in the browser. This is a more efficient approach because a corpus file is significantly smaller than the resulting model.

It feels great to train your first machine learning code. You have just become a legend and one of few people on the planet that can say: “Yeah, I trained an AI once, it was no big deal.”

## Chatbot HTML

Now we will make the chatbot form work. Extend your `index.html` by adding the `onChatSubmit` function:

```HTML
<html>
<head>
    <title>NLP in a browser</title>
    <script src='./dist/bundle.js'></script>
    <script>
        const {containerBootstrap, Nlp, LangEn, fs} = window.nlpjs;

        const setupNLP = async corpus => {
            const container = containerBootstrap();
            container.register('fs', fs);
            container.use(Nlp);
            container.use(LangEn);
            const nlp = container.get('nlp');
            nlp.settings.autoSave = false;
            await nlp.addCorpus(corpus);
            nlp.train();
            return nlp;
        };

        const onChatSubmit = nlp => async event => {
            event.preventDefault();
            const chat = document.getElementById('chat');
            const chatInput = document.getElementById('chatInput');
            chat.innerHTML = chat.innerHTML + `<p>you: ${chatInput.value}</p>`;
            const response = await nlp.process('en', chatInput.value);
            chat.innerHTML = chat.innerHTML + `<p>chatbot: ${response.answer}</p>`;
            chatInput.value = '';
        };

        (async () => {
            const nlp = await setupNLP('https://raw.githubusercontent.com/jesus-seijas-sp/nlpjs-examples/master/01.quickstart/02.filecorpus/corpus-en.json');
            const chatForm = document.getElementById('chatbotForm');
            chatForm.addEventListener('submit', onChatSubmit(nlp));
        })();
    </script>
</head>
<body>
<h1>NLP in a browser</h1>
<div id="chat"></div>
<form id="chatbotForm">
    <input type="text" id="chatInput" />
    <input type="submit" id="chatSubmit" value="send" />
</form>
</body>
</html>
```

Now you can play with your new chatbot:

![](https://cdn-images-1.medium.com/max/2000/1*uxgIOaFQgJD-w3NEFL_UgQ.png)

Explore your corpus or the corpus on [https://raw.githubusercontent.com/jesus-seijas-sp/nlpjs-examples/master/01.quickstart/02.filecorpus/corpus-en.json](https://raw.githubusercontent.com/jesus-seijas-sp/nlpjs-examples/master/01.quickstart/02.filecorpus/corpus-en.json) to learn what conversation topics are supported.

Now this is something that you can show your friends in a pub and easily get their admiration, for now you are a true hacker.

## Adding Hooks to Intents

You might want your chatbot to be able to call some additional code with each intent or replace the answer for some intent with some API calls. Let's extend our `index.html` to its final version.

```HTML
<html>
<head>
    <title>NLP in a browser</title>
    <script src='./dist/bundle.js'></script>
    <script>
        const {containerBootstrap, Nlp, LangEn, fs} = window.nlpjs;

        function onIntent(nlp, input) {
            console.log(input);
            if (input.intent === 'greetings.hello') {
                const hours = new Date().getHours();
                const output = input;
                if(hours < 12) {
                    output.answer = 'Good morning!';
                } else if(hours < 17) {
                    output.answer = 'Good afternoon!';
                } else {
                    output.answer = 'Good evening!';
                }
                return output;
            }
            return input;
        }

        const setupNLP = async corpus => {
            const container = containerBootstrap();
            container.register('fs', fs);
            container.use(Nlp);
            container.use(LangEn);
            const nlp = container.get('nlp');
            nlp.onIntent = onIntent;
            nlp.settings.autoSave = false;
            await nlp.addCorpus(corpus);
            nlp.train();
            return nlp;
        };

        const onChatSubmit = nlp => async event => {
            event.preventDefault();
            const chat = document.getElementById('chat');
            const chatInput = document.getElementById('chatInput');
            chat.innerHTML = chat.innerHTML + `<p>you: ${chatInput.value}</p>`;
            const response = await nlp.process('en', chatInput.value);
            chat.innerHTML = chat.innerHTML + `<p>chatbot: ${response.answer}</p>`;
            chatInput.value = '';
        };

        (async () => {
            const nlp = await setupNLP('https://raw.githubusercontent.com/jesus-seijas-sp/nlpjs-examples/master/01.quickstart/02.filecorpus/corpus-en.json');
            const chatForm = document.getElementById('chatbotForm');
            chatForm.addEventListener('submit', onChatSubmit(nlp));
        })();
    </script>
</head>
<body>
<h1>NLP in a browser</h1>
<div id="chat"></div>
<form id="chatbotForm">
    <input type="text" id="chatInput" />
    <input type="submit" id="chatSubmit" value="send" />
</form>
</body>
</html>
```

To our `setupNLP` we added a line:

```js
nlp.onIntent = onIntent;
```

And we created the `onIntent` function. Notice that `onIntent` logs the response object into your console for each intent. It also adds logic to `greetings.hello` intent by replacing its output with an answer based on the current time of the user. In my case it is now afternoon:

![](https://cdn-images-1.medium.com/max/2770/1*2mIHjtgl0fjEYs2xJaolgw.png)

Isn’t this awesome? High five if you are rightfully feeling ready to create your own AI startup.

## Known Limitations

Please notice that the browser version of NLP does not support some common natural language processing features, such as named entities or entity extractions that are available in the full library.

NLP as a library also currently doesn’t support stories or follow-up intents. These are part of the current development of chatbot orchestration, but the feature is still experimental at the time of writing this article.

## Security and Privacy Considerations

When using this solution, please keep in mind that the whole corpus and its functionality are available in the browser to anyone who will visit your website. That also gives anyone the ability to simply download your corpus, manipulate it, and otherwise use it. Make sure that your bot doesn’t expose any private information.

Using a browser-only solution gives certain advantages but also removes some opportunities, as you would still need some back-end solution in order to be able to record what users are talking about with your chatbot. At the same time, if you record whole conversations, please consider privacy implications, especially in the context of legislation like GDPR.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
