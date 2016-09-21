> * 原文地址：[利用 Cordova 和 Vue.js 构建移动应用](https://coligo.io/building-a-mobile-app-with-cordova-Vuejs/)
* 原文作者：[Michael Viveros](https://coligo.io/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[circlelove](https://github.com/circlelove)
* 校对者：

[获取代码](https://github.com/coligo-io/random-word-generator-cordova-Vuejs)


[Cordova](https://cordova.apache.org/) 是一个你可以利用HTML, Javascript 和 CSS 等 web 技术开发移动应用的框架。它支持利用一套基本代码面向多平台，如 Android 和 iOS 。尽管你仍然需要平台指定的技术，例如 Android SDK 和 XCode 来开发应用，就无需再编写 Android 或者 iOS 代码。

既然你能够掌握 HTML 和 Javascript 代码的编写，利用[Vue.js](https://Vuejs.org/) 这样配有 Cordova 的  Javascript 库就是小菜一碟了。

这个教程将为您展示如何利用 Cordova 和 Vue.js 开发一个简单的生成随机单词的移动应用。


# 准备工作

* 下载 [Node.js](https://nodejs.org/en/)
* 安装 Cordova: `npm install -g cordova`
* [Vue.js 基础](https://coligo.io/Vuejs-the-basics/)

# 配置一个 Cordova 工程

创建一个名为 RandomWord 的工程：

    cordova create RandomWord
    cd RandomWord

将会创建一个 Cordova 工程的目录结构：


![Cordova Vue.js Directory Structure](https://coligo.io/building-a-mobile-app-with-cordova-Vuejs/directory-structure.png)


*   **config.xml** -包含有关应用的信息，需要的插件和面向的平台
*   **platforms** -  包含应用运行需要面向的平台例如 Android 和 iOS 上的 Cordova 库 
*   **plugins** - 包含应用所需插件的 Cordova 库，使得应用能够访问例如照相机和电池状态相关的事项。
*   **www** -  包含应用源代码，例如 HTML, Javascript 和 CSS 文件
*   **hooks** - 包含为个性化应用编译系统所需的脚本

在安卓平台上添加：

    cordova platform add android --save

这样就可以将安卓平台库添加到平台目录(platforms/android)当中。

它也可以添加白名单插件用于限制应用访问或在浏览器当中打开指定 URL 地址。随机单词生成器应用无需这种功能，但是你可以了解关于白名单的更多事项。[这里](https://cordova.apache.org/docs/en/latest/reference/cordova-plugin-whitelist/)。

`--save` flag 将平台引擎添加到 config.xml ，是[cordova prepare](https://cordova.apache.org/docs/en/latest/reference/cordova-cli/#cordova-prepare-command) 从一个 **config.xml** 文件初始化 Cordova 工程需要的命令。
  
      
   ...
    <engine name="android" spec="~5.2.1" />
</widget>   

检查你是否具备利用 Cordova 开发/运行 Android 应用的条件：

    cordova requirements

If missing requirements, see the [Cordova Docs for Android](https://cordova.apache.org/docs/en/latest/guide/platforms/android/) and the Help section at the bottom of the tutorial. This is definitely the hardest part of the tutorial. Just be patient and refer to the links mentioned. Once you get all the requirements working, the rest of the tutorial is a breeze.
如果未达到要求，查看[ Android 版 Cordova 文档](https://cordova.apache.org/docs/en/latest/guide/platforms/android/) 以及Help 部分底部的教程。这的确是教程当中最难的部分。耐心一点，参考链接提到的部分。一旦所有需求都满足了，教程剩下的部分就是小意思了。

开发一个 Android 应用：

    cordova build android

将手机连接在电脑上，运行该 Android 程序：

    cordova run android

如果没有 Android 手机可以连接到电脑，Cordova 将在仿真器上运行应用。

实例应用相当简单，它做的一切只是更改标签的背景色。

![Cordova Sample Screen](https://coligo.io/building-a-mobile-app-with-cordova-Vuejs/cordova-sample-app.png)

要用 iOS 替代 Android ，按上述步骤进行操作，只需把 `android` 换成 `ios` 。如果不满足条件，查看[iOS 版 Cordova 文档](https://cordova.apache.org/docs/en/latest/guide/platforms/ios/)  以及 Help 底部的教程。如果在 Windows 系统的电脑上运行 Cordova ，你*无法*运行 iOS 应用，因为 iOS Cordova 需要苹果系统。


或者，你可以利用你的浏览器而不是手机设备当中使用 `browser` 平台。同样按上述步骤，只需把 `android` 换成 `browser`。

在 **config.xml** 文件中更改有关随机单词生成器应用的信息：
    
    
    <?xml version='1.0' encoding='utf-8'?>
    <widget id="io.coligo.randomword" version="1.0.0" xmlns="http://www.w3.org/ns/widgets" xmlns:cdv="http://cordova.apache.org/ns/1.0">
    <name>RandomWord</name>
    <description>
        A mobile app for generating a random word.
    </description>
    <author email="michaelviveros@gmail.com" href="http://www.michaelviveros.com/">
        Michael Viveros
    </author>
    ...

# 添加 Vue.js

与所有的 HTML 文件一样，添加 Vue.js CDN 到 **www/index.html** 底部：

    ...
            <script type="text/javascript" src="cordova.js"></script>
            <script src="http://cdn.jsdelivr.net/Vue/1.0.16/Vue.js"></script>
            <script type="text/javascript" src="js/index.js"></script>
        </body>
    </html>






为了使应用可以访问 Vue.js 库，我们还需要添加以下代码到www/index.html内容安全协议(CSP) `meta` 标签的底部；

    ; script-src 'self' http://cdn.jsdelivr.net/Vue/1.0.16/Vue.js 'unsafe-eval'

内容安全协议的网页允许你创建来自可信来源的白名单并引导浏览器只从那些源从进行实施和渲染资源。这和上面提到的白名单插件不同，因为白名单插件主要用于定义应用允许访问什么链接，而 CSP 拥有定义应用可以执行何种脚本以及应用向哪个 url 提出 http 请求。

CSP `meta` 标签的 `script-src` 部分定义了应用可以执行的脚本。

*   ’self’ - 允许统一来源的脚本，例如 www/js/index.js
*   [http://cdn.jsdelivr.net/Vue/1.0.16/Vue.js](http://cdn.jsdelivr.net/Vue/1.0.16/Vue.js) - allows the Vue.js library 允许 the Vue.js 库
*   ’unsafe-eval’ - 允许不安全的动态代码评估，因为部分Vue.js 库使用了字符串生成函数

CSP meta 标签看起来应该像这样 
    
    <meta http-equiv="Content-Security-Policy" content="default-src 'self' data: gap: https://ssl.gstatic.com 'unsafe-eval'; style-src 'self' 'unsafe-inline'; media-src *; script-src 'self' http://cdn.jsdelivr.net/Vue/1.0.16/Vue.js 'unsafe-eval'">


获得有关 CSP 的更多内容, 查看 [html5rocks](http://www.html5rocks.com/en/tutorials/security/content-security-policy/) 和 [Cordova 文档](https://github.com/apache/cordova-plugin-whitelist/blob/master/README.md#content-security-policy).

利用 Vue.js 替换 **www/index.html** 中 `body` 部分代码显示随机单词并移除一些注释后，**wwww/index.html** 就会像这样

    <!DOCTYPE html>
    <html>
    <head>
        <meta http-equiv="Content-Security-Policy" content="default-src 'self' data: gap: https://ssl.gstatic.com 'unsafe-eval'; style-src 'self' 'unsafe-inline'; media-src *; script-src 'self' http://cdn.jsdelivr.net/Vue/1.0.16/Vue.js 'unsafe-eval'">
        <meta name="format-detection" content="telephone=no">
        <meta name="msapplication-tap-highlight" content="no">
        <meta name="viewport" content="user-scalable=no, initial-scale=1, maximum-scale=1, minimum-scale=1, width=device-width">
        <link rel="stylesheet" type="text/css" href="css/index.css">
        <title>Random Word</title>
    </head>
    <body>
        <div id="Vue-instance" class="app">
            <h1>Random Word</h1>
            <button id="btn-get-random-word" @click="getRandomWord">Get Random Word</button>
            <p>{{ randomWord }}</p>
        </div>
        <script type="text/javascript" src="cordova.js"></script>
        <script src="http://cdn.jsdelivr.net/Vue/1.0.16/Vue.js"></script>
        <script type="text/javascript" src="js/index.js"></script>
    </body>
    </html>
    ```        
            
            
            
        
    

现在我们将添加一些 Javascript 来生成随机单词进行展示。

当应用接收到 `deviceready` 事件时，**www/js/index.js** 即可生成改变标签背景色的代码。接收我们简单的随机单词生成器的 `deviceready` 事件后，我们无需做其他多余的事情，不过最好知道你可以用 `bindEvents` 方法在应用运行周期的不同阶段做不同的事情。查看  [Cordova Events](https://cordova.apache.org/docs/en/latest/cordova/events/events.html) 获得更多信息。




我们将在 **www/js/index.js** 添加一个名叫 `setupVue` 方法，它可以创建一个新的 Vue 实例，并装载到随机单词 `div` 。新的 Vue 实例会利用 `getRandomWord` 方法，单击 Get Random Word  按键即可从列表中随机提取单词。我么也需要从 `initialize` 方法中调用 `setupVue`。

    var app = {
        initialize: function() {
            this.bindEvents();
            this.setupVue();
        },
        ...
        setupVue: function() {
            var vm = new Vue({
                el: "#Vue-instance",
                data: {
                    randomWord: '',
                    words: [
                        'formidable',
                        'gracious',
                        'daft',
                        'mundane',
                        'onomatopoeia'
                    ]
                },
                methods: {
                    getRandomWord: function() {
                        var randomIndex = Math.floor(Math.random() * this.words.length);
                        this.randomWord = this.words[randomIndex];
                    }
                }
            });
        }
    };

    app.initialize();


在 `receivedEvent`  移除过去的改变标签背景色代码和注释后， **www/js/index.js** 看上去是这样的：

    var app = {
        initialize: function() {
            this.bindEvents();
            this.setupVue();
        },
        bindEvents: function() {
            document.addEventListener('deviceready', this.onDeviceReady, false);
        },
        onDeviceReady: function() {
            app.receivedEvent('deviceready');
        },
        receivedEvent: function(id) {
            console.log('Received Event: ' + id);
        },
        setupVue: function() {
            var vm = new Vue({
                el: "#Vue-instance",
                data: {
                    randomWord: '',
                    words: [
                        'formidable',
                        'gracious',
                        'daft',
                        'mundane',
                        'onomatopoeia'
                    ]
                },
                methods: {
                    getRandomWord: function() {
                        var randomIndex = Math.floor(Math.random() * this.words.length);
                        this.randomWord = this.words[randomIndex];
                    }
                }
            });
        }
    };

    app.initialize();

创建，连接手机然后运行：

    cordova build android
    cordova run android

该应用长这个样子：

![Random Word App Cordova Vue.js](https://coligo.io/building-a-mobile-app-with-cordova-Vuejs/random-word-cordova-Vuejs.png)

#  vue-resource 发起 HTTP 请求

该应用没有从硬编码的单词列表中提取随机单纯，而是从可以生成随机单词的 API 中发起请求的，例如 [Wordnik Random Word API](http://developer.wordnik.com/docs.html#!/words/getRandomWord_get_4) 。

为了能够向随机单词 API 发起请求， 需要在 CSP 元标签最后添加下面代码。

    ; connect-src http://api.wordnik.com:80/v4/words.json/randomWord

The `connect-src` part of the CSP meta tag defines which origins the app can make http requests to.
CSP 元标签的 `connect-src` 部分定义了应用发起 HTTP 请求的来源。

该应用可以利用[Vue-resource library](https://github.com/Vuejs/Vue-resource)  发起 HTTP 请求，那样我们就可以添加 Vue 源到 CSP 元标签 `script-src` 部分以及添加 Vue 源 CDN 。

**index.html** 将变成:

    <!DOCTYPE html>
        ...
            <meta http-equiv="Content-Security-Policy" content="default-src 'self' data: gap: https://ssl.gstatic.com 'unsafe-eval'; style-src 'self' 'unsafe-inline'; media-src *; script-src 'self' http://cdn.jsdelivr.net/Vue/1.0.16/Vue.js https://cdn.jsdelivr.net/Vue.resource/0.7.0/Vue-resource.min.js 'unsafe-eval'; connect-src http://api.wordnik.com:80/v4/words.json/randomWord">
    ...
            <script src="http://cdn.jsdelivr.net/Vue/1.0.16/Vue.js"></script>
            <script src="https://cdn.jsdelivr.net/Vue.resource/0.7.0/Vue-resource.min.js"></script>
            <script type="text/javascript" src="js/index.js"></script>
        </body>
    </html>


为了向随机单词 API 发起 http 请求，我们可利用 Vue 来源库当中的 [http service](https://github.com/Vuejs/Vue-resource/blob/master/docs/http.md) ，这是来自 **www/js/index.js**里 Vue 实例中的 `getRandomWord` 方法。

    ... 
        setupVue: function() {
            var vm = new Vue({
                el: "#Vue-instance",
                data: {
                    randomWord: ''
                },
                methods: {
                    getRandomWord: function() {
                        this.randomWord = '...';
                        this.$http.get(
                            'http://api.wordnik.com:80/v4/words.json/randomWord?api_key=a2a73e7b926c924fad7001ca3111acd55af2ffabf50eb4ae5'
                        ).then(function (response) {
                            this.randomWord = response.data.word;
                        }, function (error) {
                            alert(error.data);
                        });
                    }
                }
            });
        }
    };

    app.initialize();

创建，连接手机并运行：

    cordova build android
    cordova run android

应用和之前看起来一样，但是现在它可以从 API 当中获取随机单词了。

# 使用 Vue 组件

[Vueify](https://github.com/Vuejs/Vueify)  是一个 Vue.js 库，他可以帮你将 UI 变成独立的带有各自 HTML, JavaScript 和 CSS 的组件。这令你的应用更加的模块化，也方便你利用层级方式定义组件。

利用 Vue 组件需要在你的编译系统中添加额外的步骤以合并所有组件。有了 [hooks](https://cordova.apache.org/docs/en/latest/guide/appdev/hooks/) 这个指定编译系统中额外脚本运行的东西，Cordova 就可以将该过程变得详单简单。

这就是添加 Vue 组件之后目录的样子：

![Cordova Vue.js Directory Structure](https://coligo.io/building-a-mobile-app-with-cordova-Vuejs/directory-structure-2.png)

创建一个带有随机单词生成器所有代码的组件，命名为**www/js/random-word.Vue**：
    
    <template>
      <div class="app">      
    <h1>Random Word</h1>
    <button id="btn-get-random-word" @click="getRandomWord">Get Random Word</button>
    <p>{{randomWord}}</p>
      </div>
    </template>


    <script>
    export default {
      data () {
        return {
         randomWord: ''
        }
      },
      methods: {
         getRandomWord: function() {
            this.randomWord = '...';
            this.$http.get(
                'http://api.wordnik.com:80/v4/words.json/randomWord?api_key=a2a73e7b926c924fad7001ca3111acd55af2ffabf50eb4ae5'
            ).then(function (response) {
                this.randomWord = response.data.word;
            }, function (error) {
            alert(error.data);
            });
        }
    }
    }
    </script>




**www/index.html**的 HTML 放入 `template` 标签，而 Javascript 放入 **random-word.Vue**的 `script` 标签

创建一个新的包含随机单词组件的 Vue 实例文件，命名 **www/js/main.js**：

    var Vue = require('Vue');
    var VueResource = require('Vue-resource');
    var RandomWord = require('./random-word.Vue');

    Vue.use(VueResource);

    var vm = new Vue({
      el: 'body',
      components: {
        'random-word': RandomWord
      }
    });

为了合并组件，我们需要使用 [browserify](http://browserify.org/) 并 Vueify 以创建一个 名为 bundle.js 的文件。构建一个新的名为 scripts 的目录，新建 **Vueify-build.js** 文件，其中包含了需要合并的随机单词组件的代码。

过去，Vueify-build.js 要进入 hooks 目录中，从 `cordova create` 被创建，但是 hooks 目录被[废弃了](https://cordova.apache.org/docs/en/latest/guide/appdev/hooks/index.html#via-hooks-directory-deprecated)。所以你可以删除了 hooks 目录并用 scipts 目录代替。

**scripts/Vueify-build.js** 就会像这样:

    var fs = require('fs');
    var browserify = require('browserify');
    var Vueify = require('Vueify');

    browserify('www/js/main.js')
      .transform(Vueify)
      .bundle()
      .pipe(fs.createWriteStream('www/js/bundle.js'))

从前，我们利用 **www/index.html** 当中的 CDN 来引用 Vue.js 库，但是现在 **www/js/main.js** 用的是 Javascript 来做。所以我们需要添加一个 **package.json** 文件为 Vue.js 库来定义所有需要的依赖。

    {
      "name": "random-word",
      "version": "1.0.0",
      "description": "A mobile app for generating a random word",
      "main": "index.js",
      "dependencies": {
        "browserify": "~13.0.1",
        "Vue": "~1.0.24",
        "Vue-resource": "~0.7.4",
        "Vueify": "~8.5.4",
        "babel-core": "6.9.1",
        "babel-preset-es2015": "6.9.0",
        "babel-runtime": "6.9.2",
        "babel-plugin-transform-runtime": "6.9.0",
        "Vue-hot-reload-api": "2.0.1"
      },
      "author": "Michael Viveros",
      "license": "Apache version 2.0"
    }

所有的标签模块，browserify 和 Vue-hot-reload-api 由 Vueify 使用，参考 [Vueify 文档](https://github.com/Vuejs/Vueify#usage)。

在 **package.json** 中获取定义以来的所有 node 模块：

    npm install

开发应用其他部分之前，在 **config.xml** 底部添加一个 hook 来告知 Cordova 绑定随机单词组件：

    ...
        <hook type="before_compile" src="scripts/Vueify-build.js" />
    </widget>
    
调用 scripts/Vueify-build.js 将产生合并的组件并放入 www/js/bundle.js 中。
  

通过向 `random-word` 和 `script` 标签添加指向合并组件的方式向 **www/index.html** 主体添加随机单词组件。

```
...
        <link rel="stylesheet" type="text/css" href="css/index.css">
        <title>Random Word</title>
    </head>
    <body>
        <random-word></random-word>
        <script src="js/bundle.js"></script>

        <script type="text/javascript" src="js/index.js"></script>
        <script type="text/javascript" src="cordova.js"></script>
    </body>
</html>
```
  

注意到 **www/index.html** 中链接标签定义了应用的 CSS 和 **www/js/random-word.Vue** 中的 `div` 。在 CSS 中使用了 "app" 类定义。

由于随机单词组件包含生成随机单词的所有代码，我们可以从 **www/js/index.js** 中删除 `setupVue` 方法，就会像这样：

    var app = {
        initialize: function() {
            this.bindEvents();
        },
        bindEvents: function() {
            document.addEventListener('deviceready', this.onDeviceReady, false);
        },
        onDeviceReady: function() {
            app.receivedEvent('deviceready');
        },
        receivedEvent: function(id) {
            console.log('Received Event: ' + id);
        }
    };

    app.initialize();

创建，连接手机并运行：

    cordova build android
    cordova run android

应用外观和功能和先前一样，但是我们现在有使用 Vue 组件。

# 总结

一切都结束了。

Cordova 令利用 web 技术开发移动应用变得超简单。 连接 Cordova 和 Vue.js 也很方便就能让你利用Vue.js 之类很酷的东西


本教程涵盖：

*   开发一个 Cordova 工程
*   链接 Cordova 和 Vue.js
*   Cordova app 通过更新内容安全策略来发出 http 申请  by updating it's Content Security Policy
*   添加 Hooks 在 Cordova 应用中使用 Vue 组件


# 帮助

### Android

安装好 Android SDK 之后，你可以运行下面的命来来打开 Android SDK 管理器。

    /Users/your_username/Library/Android/sdk/tools/android sdk

我安装了下面这些包：

**工具**

*   Android SDK 工具
*   Android SDK 平台工具
*   Android SDK 开发工具

**Android 6.0 (API 23)**


*   SDK 平台
*   Intel x86 Atom_64 系统映象

**额外**

*   Intel x86 仿真器加速设备 (HAXM Installer)

### iOS

通过 npm 安装 iOS 依赖的时候我犯了个错误，运行了 OS X El Capitan 10.11，可以运行下面代码来解决：

    sudo npm install -g ios-deploy –unsafe-perm=true

见 [StackOverflow](http://stackoverflow.com/questions/34195673/ios-deploy-fail-to-install-on-mac-os-x-el-capitan-10-11)


# 关于作者


我叫 Michael Viveros 。今年是我学习软件工程的第五年。我是个充满热情的程序员，难得一见的没准的高尔夫球手和会挖苦人的机智的说笑话的家伙。我正在开发一个高尔夫球跟踪网站，还有个用到 Cordova 和 Vue.js 的移动应用。  你可以在下面的网站看到更多 [michaelviveros.com](http://www.michaelviveros.com/) 。



