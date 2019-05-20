> * 原文地址：[Using ES6 and npm modules in Google Apps Script](http://blog.gsmart.in/es6-and-npm-modules-in-google-apps-script/)
> * 原文作者：[Prasanth Janardanan](http://blog.gsmart.in/author/prasanth3628/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/es6-and-npm-modules-in-google-apps-script.md](https://github.com/xitu/gold-miner/blob/master/TODO1/es6-and-npm-modules-in-google-apps-script.md)
> * 译者：[xingqiwu55555](https://github.com/xingqiwu55555)
> * 校对者：[Baddyo](https://github.com/Baddyo) [shixi-li](https://github.com/shixi-li)

# 在 Google Apps 脚本中使用 ES6 和 npm 模块

> 所有的 JavaScript 开发者都应该对 Google 的 Apps 脚本感兴趣。  
> Apps 脚本有利于实现自动化。通过它，你可以直接访问 Google 的很多服务，比如 Google 表格、Google 邮箱、Google 文档和 Google 日历等。
> 只需要一点点想象力，你就可以使用 Google Apps 脚本创建非常激动人心的 Apps 和 插件。

与首先要求你提供信用卡的 AppEngine 不同，Apps 脚本目前仍是免费的。至少，Apps 脚本适用于快速创建“概念验证”模型或原型。

Apps 脚本有不同的用例。它主要用于为 Google 表格、文档或表单创建插件。但是，它也可以创建“独立”的 web 应用。

我们将探究创建独立的 web 应用这一使用场景。

虽然使用 Apps 脚本有很多令人兴奋的地方，但是它仍有一些令人非常痛苦的限制，比如：

1. Apps 脚本支持很老版本的 JavaScript（JavaScript 1.6）。因此，你可能想要使用的许多现代化的 JavaScript 特性在 Apps 脚本中都是不可用的。
2. 没有直接的方式来使用 npm modules（但还是有办法可用的，下面我会向你展示）。
3. 创建一个好的 UI 界面（使用 bootstrap、Vue，甚至是自定义 CSS）是相当困难的。我们必须找到将自定义脚本内联到 HTML 页面中的方法。
4. 你的 web app 的访问地址将会是一串冗长而丑陋的 URL。难以分享，更别提用这样的地址提供商业服务。
5. “Apps 脚本” 这个名字真让人难受。顺便说一下，正确的名字确实是 “Apps” 后面跟空格，然后是 “Script”。对于这件事来说，没有比这更缺乏想象力的名字了。有些人可能喜欢这个名字，但我还没有遇到声称喜欢它的人！ 当你在网上搜索 Apps 脚本功能的参考或示例时，你会更加讨厌它。有一个流行的缩略：GAS （Google Apps Script）。但是，如果你搜索“在表格中使用 GAS”，我真的怀疑就连 Google 自己也不能弄明白。

本系列文章旨在规避 Apps 脚本的限制，并为“独立”的 web apps 和插件添加一些非常棒的功能。

首先，我们会使用 webpack 和 babel，从 ES6 Javascript 代码创建一个包。接下来，我会在我们的 Apps 脚本项目中使用 npm 包。并在本系列的下面部分，在你的 Apps 脚本项目中我们利用 CSS 框架和 VueJS 或 ReactJS 来开发现代化的用户界面。让我们深入探讨吧！

## 设置你的本地 Apps 脚本环境

首先，你必须熟悉 Apps 脚本环境。Google 提供了一个命令行工具叫 **clasp** 来在本地管理 Apps 脚本项目。

安装 clasp 命令行工具：

```
npm install @google/clasp -g
```

安装后，登录你的 Google 账号。

```
clasp login
```

这将在你的浏览器里打开一个授权页面。你必须完成这些步骤。

授权完成后，你已经做好了创建你的第一个 Apps 脚本项目的准备。

## 一个简单的基于 Apps 脚本的独立 web app

新建一个文件夹。打开终端并转到这个新建的文件夹。运行下面的命令来创建一个新的 Apps 脚本项目：

```
clasp create --type standalone --title "first GAS App"
```

在同样的文件夹里新建一个 app.js。并在 app.js 文件里添加下面的函数：

app.js

```JavaScript
function  doGet(){
 return  ContentService.createTextOutput("Hello World!");
}
```

为了 webapp 类型的 Appscript 项目，你需要有一个名为 doGet() 的函数。doGet() 是执行页面渲染的函数。  
在上面的例子里，输出结果是一段简单的文本。常见的 webapp 应该返回一个完整的 HTML 页面。为了保持第一个项目尽可能简单，我们将继续使用简单的文本。

打开 appscript.json。这个文件包含你的 apps 脚本设置。更新文件，如下所示：

appscript.json

```JavaScript
{
  "timeZone":  "America/New_York",
  "dependencies":  {
},
  "webapp":  {
  "access":  "MYSELF",
  "executeAs":  "USER_DEPLOYING"
},
  "exceptionLogging":  "STACKDRIVER"
}
```

保存文件。  
转到终端且输入下面的命令将这个文件推送回 Google 服务器：

```
clasp push
```

然后输入下面的命令在浏览器中打开项目

```
clasp open  --webapp
```

该命令会打开浏览器，展示刚刚创建的 web 应用。

![](http://blog.gsmart.in/wp-content/uploads/2019/03/word-image-89.png)

## 创建包 —— 使用 WebPack 和 Babel

接下来我们在 Apps 脚本中使用 [ES6](https://en.wikipedia.org/wiki/ECMAScript)。我们将使用 [babel](https://babeljs.io/) 对 ES6 进行编译并使用 [webpack](https://webpack.js.org/) 并对生成的代码进行分块打包。

我这有一个简单的 Apps 脚本项目：

[https://github.com/gsmart-in/AppsCurryStep1](https://github.com/gsmart-in/AppsCurryStep1)

让我们来看看这个项目的结构。

![](http://blog.gsmart.in/wp-content/uploads/2019/03/word-image-90.png)

“server” 子文件夹包含代码。api.js 文件包含暴露给 Apps 脚本的函数。

在 **lib.js** 文件里我们会看到 es6 代码。在 lib 模块，我们可以引入其他 es6 文件和 npm 包。

![](http://blog.gsmart.in/wp-content/uploads/2019/03/word-image-91.png)

我们使用 webpack 来对代码进行分块打包，并使用 babel 来编译。

现在我们看看 webpack.gas.js 文件：

这是 webpack 配置文件。总之，这个配置文件告诉 webpack 的是

* 使用 babel 将 server/lib.js 文件编译为向后兼容的 Javascript 代码。然后把打包后的文件放在 “dist” 目录下
* 复制 api.js 文件且不更改输入文件夹 “dist”
* 复制一些配置文件（appsscript.js 和 .clasp.json 文件到输出文件夹 ‘dist’ 目录下）

重点注意这几行代码：

webpack.gas.js

```JavaScript
module.exports  =  {
  mode:  'development',
  entry:{
    lib:'./server/lib.js'
  },
  output:{
     filename:  '\[name\].bundle.js',
     path:  path.resolve(__dirname,  'dist'),
     libraryTarget:  'var',
     library:  'AppLib'
  }
}
```

这意味着 webpack 将暴露一个全局变量 AppLib，通过该变量可以访问打包后文件可以导出的类和函数。

现在来看 api.js 文件。

api.js
```JavaScript
function  doGet(){
  var  output  =  AppLib.getObjectValues();
  return  ContentService.createTextOutput(output);
}
```

server/lib.js 文件

lib.js

```JavaScript
function  getObjectValues(){
  let options  =  Object.assign({},  {source_url:null,  header_row:1},  {content:"Hello, World"});
  return(JSON.stringify(options));
}

export  {
  getObjectValues
};
```

我们正在使用 Apps 脚本不支持的 Object.assign() 方法。当使用 babel 编译成 lib.js 文件时，它将生成 Apps 脚本支持的兼容代码。

现在让我们看看 package.json 文件

package.json

```JavaScript
{
  "name": "AppsPackExample1",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "gas": "webpack --config webpack.gas.js ",
    "deploy": "npm run gas && cd dist && clasp push && clasp open --webapp"
  },
  "keywords": [],
  "author": "",
  "license": "MIT",
  "devDependencies": {
    "@babel/core": "^7.4.0",
    "@babel/preset-env": "^7.4.2",
    "babel-loader": "^8.0.5",
    "copy-webpack-plugin": "^5.0.1",
    "webpack": "^4.29.6",
    "webpack-cli": "^3.3.0"
  },
  "dependencies": {
    "@babel/polyfill": "^7.4.0"
  }
}
```

当你运行如下命令时：

```
$>  npm run gas
```

Webpack 将 lib.js 代码（以及你导入的其它模块）编译并打包到单个 JavaScript 文件中，并将文件放在 “dist” 文件夹中。

然后我们可以使用 “clasp” 上传代码。

参考 package.json 文件中的脚本 “deploy”。

它运行 webpack，然后执行 “clasp push” 和 “clasp open” 命令。

## 部署 “AppsCurryStep1”

如果上面步骤未完成，请在本地克隆示例项目代码库。

```
git clone  git@github.com:gsmart-in/AppsCurryStep1.git
```

打开终端并转到 AppsCurryStep1 目录下。

执行下面的命令：

```
clasp create  --type standalone  --title  "Apps Script with Webpack and babel"
```

这将在你的账户中创建一个独立的脚本项目。

现在执行：

```
npm run deploy
```

这将在你的浏览器中打开你的 web app。

## 将 npm 模块与你的 Apps 脚本项目集成

Apps 脚本的一个限制特性是没有简单的方法可以将 npm 之类的包集成到你的项目中。

例如，你可能想在项目中使用 [momentjs](https://momentjs.com/) 来处理日期，或者 [lodash](https://lodash.com/) 工具集方法。

实际上，[Apps 脚本是有库功能的](https://developers.google.com/apps-script/guides/libraries)，但是它有几个限制。我们不会在这篇文章中探索这个库的功能；我们将安装 npm 模块并使用 webpack 打包这些模块来创建与 Apps 脚本兼容的包。

因为我们已经开始使用 webpack 来创建可以集成到 apps 脚本的包，所以我们现在添加一些 npm 包应该更容易。让我们开始使用 moment.js 吧！

打开终端，转到你上一步创建的 AppsCurryStep1 目录下，添加 momentjs。

```
npm install moment  --save
```

现在让我们在 Apps 脚本项目中使用一些 momentjs 的功能。

在 lib.js 文件中添加一个新的函数。

server/lib.js

```JavaScript
import * as moment from "moment";

function getObjectValues() {
  let options = Object.assign(
    {},
    { source_url: null, header_row: 1 },
    { content: "Hello, World" }
  );

  return JSON.stringify(options);
}

function getTodaysDateLongForm() {
  return moment().format("LLLL");
}

export { getObjectValues, getTodaysDateLongForm };
```

**提示：** 不要忘记导出新函数。

现在让我们在 api.js 文件中使用这个新函数吧。

server/api.js

```JavaScript
function doGet() {
  var output = "Today is " + AppLib.getTodaysDateLongForm() + "\\n\\n";

  return ContentService.createTextOutput(output);
}
```

转到终端并输入：

```
npm run deploy
```

这个更新了的脚本会打开浏览器，并打印今天的日期。

打印今天的日期并没有多少乐趣。让我们添加另一个有更多功能的函数。

server/lib.js

```JavaScript
function  getDaysToAnotherDate(y,m,d){
  return  moment().to(\[y,m,d\]);
}
```

现在在 api.js 文件中更新 doGet() 并调用 getDaysToAnotherDate()。

server/api.js

```JavaScript
function  doGet(){
  var  output  =  'Today is '+AppLib.getTodaysDateLongForm()+"\\n\\n";
  output  +=  "My launch date is "+AppLib.getDaysToAnotherDate(2020,3,1)+"\\n\\n";
  return  ContentService.createTextOutput(output);
}
```

下面，让我们添加 lodash。

首先，执行下面的命令：

```
npm install lodash  --save
```

然后我们使用 lodash 添加一个随机数生成器。

server/lib.js

```JavaScript
function  printSomeNumbers(){
  let out  =  _.times(6,  ()=>{
    return  _.padStart(_.random(1,100).toString(),  10,  '.')+"\\n\\n";
  });
  return  out;
}
```

让我们在 api.js 中调用该函数：

server/api.js

```JavaScript
function  doGet(){
  var  output  =  'Today is '+AppLib.getTodaysDateLongForm()+"\\n\\n";
  output  +=  "My launch date is "+AppLib.getDaysToAnotherDate(2020,3,1)+"\\n\\n";
  output  +=  "\\n\\n";
  output  +=  "Random Numbers using lodash\\n\\n";
  output  +=  AppLib.printSomeNumbers();
  return  ContentService.createTextOutput(output);
}
```

再次部署这个项目：

```
npm run deploy
```

你应该可以在线上看到你的 web 应用页面的随机数字。

第 2 部分的源代码（与 npm 模块集成）可在此处获得： 
[https://github.com/gsmart-in/AppsCurryStep2](https://github.com/gsmart-in/AppsCurryStep2)

## 下一步

既然添加 npm 包到你的 Apps 脚本项目中如此容易，那我们可以开始创建一些 npm 包了。

封装 Google APIs、Gmail、Google 表格、Google Docs和其它公共的 API 的包，将会带来很多的乐趣！

另一个重要的部分还没说到。目前我们看到 web 应用只是一个简单的文本界面。试试使用现代化 CSS 框架，bootstrap、bulma、material design 以及 VueJS 和 React，并用 Apps 脚本创建一些单页面 Web 应用？对，我们会这样做的。我们会在客户端使用 bootstrap 和 Vuejs，在服务端使用 Apps 脚本，并构建一个单页应用。

多么令人兴奋啊！请继续关注本系列的文章。

### 更新

在第二部分，我们将使用 bootstrap 和 VueJS 构建我们的 web 应用的客户端。点击此处阅读全部：  
[在 Google Apps 脚本中（使用 Vue 和 Bootstrap）构建单页应用](http://blog.gsmart.in/single-page-apps-vue-bootstrap-on-google-apps-script/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
