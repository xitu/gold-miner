> - 原文地址：[Natural Language Processing in the Browser](https://medium.com/better-programming/natural-language-processing-in-the-browser-8ca5fdf2488b)
> - 原文作者：[Martin Novák](https://medium.com/@ragnarecek)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/natural-language-processing-in-the-browser.md](https://github.com/xitu/gold-miner/blob/master/article/2020/natural-language-processing-in-the-browser.md)
> - 译者：[regon-cao](https://github.com/regon-cao)
> - 校对者：[zenblo](https://github.com/zenblo) [NieZhuZhu](https://github.com/NieZhuZhu) [lsvih](https://github.com/lsvih)

# 在浏览器中做自然语言处理

![Image source: Author](https://cdn-images-1.medium.com/max/3192/1*X-jYECtYbLdX_c7GRz_DTQ.png)

在不依赖诸如 [Dialogflow](https://cloud.google.com/dialogflow/docs) 等第三方服务和服务端的情况下，搭建自己网站的聊天机器人也是可行的。我会教你如何搭建一个完全运行在浏览器中的聊天机器人。

我假设你对 JavaScript 和自然语言处理的工作原理有一定的了解。完成这项任务不需要其他高级的知识或机器学习经验。

如果有人告诉你在浏览器中使用 JavaScript 进行机器学习简直是疯了，不要理他，因为很快你就会明白该怎么做。

我们的代码基于 [NLP.js](https://github.com/axa-group/nlp.js) 第 4 版。[NLP](https://github.com/axa-group/nlp.js) 是一个用 JavaScript 编写的用于自然语言处理的开源库。该项目可以让你直接在浏览器从语料库中训练 NLP 模型，并能添加一个钩子以编程方式更改答案。

完整的项目在我的 GitHub 仓库：[https://github.com/MeetMartin/nlpjs-web](https://github.com/MeetMartin/nlpjs-web)。你可以下载并打开 index.html 就可以和聊天机器人玩耍了。

如今每一个真正的开发者都应该有一些人工智能的开发经验。还有什么事会比用你自己开发的东西和你的电脑说话更科幻呢？

## 安装软件包

在任一文件夹中创建新的 npm 项目并安装 NLP 包：

```bash
npm i -D @nlpjs/core @nlpjs/lang-en-min @nlpjs/nlp @nlpjs/request-rn@nlpjs/request-rn
```

我们还需要安装 [browserify](https://github.com/browserify/browserify#usage) 和 [terser](https://terser.org/docs/cli-usage) 来构建浏览器使用的 NLP 包：

```bash
npm i -D browserify terser
```

享受一下刚安装完软件包的新项目带来的愉悦吧。这是你应得的。

## 构建 NLP 包

第一步是使用 browserify 和 terser 构建 NLP 包。为此我们只需要在 buildable.js 里创建基础代码：

```JavaScript
const core = require('@nlpjs/core');
const nlp = require('@nlpjs/nlp');
const langenmin = require('@nlpjs/lang-en-min');
const requestrn = require('@nlpjs/request-rn');

window.nlpjs = { ...core, ...nlp, ...langenmin, ...requestrn };
```

我们只使用 NLP 的核心代码和一个小的英语语言包。要构建所有内容，只需要向你的 `package.json` 里加入以下命令：

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

现在运行下面的命令：

```bash
npm run build
```

你应该得到了一个大约有 137 KB 的 `./dist/bundle.js`。值得注意的是 NLP 包拥有一个[非常棒的支持语言列表](https://github.com/axa-group/nlp.js/blob/master/docs/v4/language-support.md#supported-languages)。然而，只有英文才有针对浏览器优化的版本。

## 在浏览器中训练 NLP 模型

现在我们已经创建了包，我们可以在浏览器中训练 NLP 模型了。创建 `index.html`：

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

函数 `setupNLP` 负责处理库的安装和训练。语料库是一个 JSON 文件，它以下面的格式定义了聊天机器人的对话：

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

**intent** 是会话节点的唯一标识符，它的值应该代表与机器人对话的用户的意图。**Utterances** 是一系列关于用户可以说什么来触发意图的训练样本。**Answers** 是一组聊天机器人可以从里面随机选择的回答。

为了训练聊天机器人，我们从 [https://raw.githubusercontent.com/jesus-seijas-sp/nlpjs-examples/master/01.quickstart/02.filecorpus/corpus-en.json](https://raw.githubusercontent.com/jesus-seijas-sp/nlpjs-examples/master/01.quickstart/02.filecorpus/corpus-en.json) 借用更大的语料库。你也可以为你的用例随意创建自己的语料库。只要记住一点，NLP 库需要从 URL 读取语料库。

当你在浏览器中打开 `index.html`，你应该看到了一个简单的啥都没做的聊天机器人。

![](https://cdn-images-1.medium.com/max/2000/1*jcgI1OlIsUD8VcGVzxAiYw.png)

但是如果你打开了浏览器控制台，你已经可以看到成功的训练输出了：

![](https://cdn-images-1.medium.com/max/2828/1*GddApxHIsJ5K4AzzjEIiOw.png)

训练速度非常快，你的聊天机器人可以在浏览器中使用训练过的模型。因为语料库文件比生成的模型小得多所以是一种更有效的方法。

训练你的第一个机器学习代码感觉很太棒了。你刚刚成为了一个传奇，是这个星球上为数不多的可以说“是的，我曾经训练过一个人工智能，没什么大不了的。“的人之一。

## 聊天机器人 HTML

我们让这个聊天机器人表单开始工作。在你的 `index.html` 加入 `onChatSubmit` 函数：

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

现在你可以和聊天机器人互动了：

![](https://cdn-images-1.medium.com/max/2000/1*uxgIOaFQgJD-w3NEFL_UgQ.png)

查看你的语料库或者 [https://raw.githubusercontent.com/jesus-seijas-sp/nlpjs-examples/master/01.quickstart/02.filecorpus/corpus-en.json](https://raw.githubusercontent.com/jesus-seijas-sp/nlpjs-examples/master/01.quickstart/02.filecorpus/corpus-en.json) 去了解哪些对话是被支持的。

现在，这是一个你可以向你的朋友展示，并且很容易得到他们的羡慕的东西。现在你是个真正的黑客。

## 给 Intents 添加钩子

你可能希望你的聊天机器人能够在处理每个意图的时候附加一些代码，或者用一些 API 调用替换某些意图的答案。我们来把 `index.html` 扩展到最终版。

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

我们在 `setupNLP` 函数里添加了一行：

```js
nlp.onIntent = onIntent;
```

我们创建了 `onIntent` 函数。注意 `onIntent` 在控制台里打印了每次会话的相应对象。 在 `greetings.hello` 意图里添加了逻辑，将当前用户的时间作为回答替换了原来的输出。在我的例子里现在是下午：

![](https://cdn-images-1.medium.com/max/2770/1*2mIHjtgl0fjEYs2xJaolgw.png)

是不是很棒？如果你已经准备好创建自己的人工智能创业公司，让我们来击个掌吧！

## 已知的局限

请注意，NLP 库的浏览器版本不支持一些常见的自然语言处理功能，例如完整库中可用的命名实体或实体提取。

NLP 作为一个库目前暂不支持场景或流程控制对话。这些都是当前开发流程型聊天机器人的一部分，但在撰写本文时，该特性仍处于试验阶段。

## 安全和隐私考虑

使用此方案时，请记住，所有访问你网站的人都可以在浏览器中使用整个语料库及其功能。这也让任何人都可以简单地下载、操作和使用你的语料库。请确保你的机器人不会暴露任何私人信息。

采用纯浏览器方案有一定的优势，但也会缺失一些机会，您仍然需要一些后端解决方案，以便能够记录用户使用聊天机器人谈论的内容。同时，如果你记录了整个对话，请考虑隐私问题，尤其是在 GDPR 这样的法律背景下。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
