> * 原文地址：[How to build a CLI with Node.js](https://www.twilio.com/blog/how-to-build-a-cli-with-node-js)
> * 原文作者：[dkundel](https://twitter.com/dkundel?lang=en)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-build-a-cli-with-node-js.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-build-a-cli-with-node-js.md)
> * 译者：[EmilyQiRabbit](https://github.com/EmilyQiRabbit)
> * 校对者：[suhanyujie](https://github.com/suhanyujie)

# 如何使用 Node.js 构建一个命令行应用（CLI）

![atZ3n9vMFjjXDl_XxDtL_FCRSOt6EF0d8LnbMRCCJQUesMme8lzdGpCyMr4-wt1nlIGuoT29EI_tkVpuD_P2mxzbfhbn-ZPcqmZ5QCY_nM9d4ywWEYQxKYc9mjxUnp_uFJzMOMnr](https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/atZ3n9vMFjjXDl_XxDtL_FCRSOt6EF0d8LnbMRCCJQUesM.width-808.png)

Node.js 内建的命令行应用（CLI）让你能够在使用其庞大的生态系统的同时自动化地执行重复性的任务。并且，多亏了像 [`npm`](https://www.npmjs.com/) 和 [`yarn`](https://yarnpkg.com/) 这样的包管理工具，让这些命令行应用可以很容易就在多个平台上分发和使用。在本篇文章中，我将会讲述为何需要写 CLI，如何使用 Node.js 完成它，一些实用的包，以及你如何发布你新写好的 CLI。

## 为什么要用 Node.js 创建命令行应用

Node.js 能够如此流行的原因之一就是它有丰富的包生态系统，如今在 [`npm` 注册处](https://npmjs.com) 已经有超过 900000 个包。通过在 Node.js 中写你自己的 CLI，你就可以进入这个生态系统，而其中也包含了巨额数目的针对 CLI 的包。包括：

* [`inquirer`](http://npm.im/inquirer)，[`enquirer`](http://npm.im/enquirer) 或者 [`prompts`](https://npm.im/prompts)，可用于处理复杂的输入提示
* [`email-prompt`](http://npm.im/email-prompt) 可方便地提示邮箱输入
* [`chalk`](http://npm.im/chalk) 或 [`kleur`](https://npm.im/kleur) 可用于彩色输出
* [`ora`](http://npm.im/ora) 是一个好看的加载提示
* [`boxen`](http://npm.im/boxen) 可以用于在你的输出外加上边框
* [`stmux`](http://npm.im/stmux) 可以提供一个和 `tmux` 类似的多终端界面
* [`listr`](http://npm.im/listr) 可以展示进程列表
* [`ink`](http://npm.im/ink) 可以使用 React 构建 CLI
* [`meow`](http://npm.im/meow) 或者 [`arg`](http://npm.im/arg) 可以用于基本的参数解析
* [ `commander`](http://npm.im/commander) 和 [`yargs`](https://www.npmjs.com/package/yargs) 可以用来比较复杂的参数解析，并支持子命令
* [`oclif`](https://oclif.io/) 是一个用于构建可扩展 CLI 的框架，作者是 Heroku（[`gluegun`](https://infinitered.github.io/gluegun/#/) 可作为替换方案）

还有很多方便的方法可以用来使用 CLI，它们都发布在 `npm` 上，可以同时使用 `yarn` 和 `npm` 进行管理。例如 `create-flex-plugin`，是一个可以用来为 [Twilio Flex](https://twilio.com/flex) 创建插件的 CLI。你可以使用全局命令来安装它：

```
# 使用 npm 安装：
npm install -g create-flex-plugin
# 使用 yarn 安装：
yarn global add create-flex-plugin
# 安装之后你就可以使用了：
create-flex-plugin
```

或者它也可以作为项目依赖：

```
# 使用 npm 安装：
npm install create-flex-plugin --save-dev
# 使用 yarn 安装：
yarn add create-flex-plugin --dev
# 安装之后命令将被保存在
./node_modules/.bin/create-flex-plugin
# 或者通过由 npm 支持的 npx 使用：
npx create-flex-plugin
# 以及通过 yarn 使用：
yarn create-flex-plugin
```

事实上，`npx` 能支持在没有安装的时候就执行 CLI。只需要运行 `npx create-flex-plugin`，这时候如果找不到本地或者全局的已安装版本，它将会自动下载这个包并放入缓存中。

从 `npm` 6.1 版本后，`npm init` 和 `yarn` 都支持使用 CLI 来构建项目，命令的名字形如 `create-*`。例如，刚才说的 `create-flex-plugin`，我们要做的就是：

```
# 使用 Node.js：
npm init flex-plugin
# 使用 Yarn：
yarn create flex-plugin
```

## 构建第一个 CLI

如果你更喜欢看视频学习，[点击这里在 YouTube 观看教程](https://www.youtube.com/watch?v=s2h28p4s-Xs)。

目前我们已经解释过用 Node.js 创建 CLI 的原因，现在就让我们开始构建一个 CLI 吧。在本篇教程里，我们会使用 `npm`，但如果你想用 `yarn`，绝大多数的命令也都是相同的。确保你的系统中已经安装了 [Node.js](https://nodejs.org/en/download/) 和 [`npm`](https://www.npmjs.com/)。

本篇教程中，我们将会创建一个 CLI，通过运行命令 `npm init @your-username/project`，它可以根据你的偏好构建一个新的项目。

通过运行如下代码，开始一个新的 Node.js 项目：

```
mkdir create-project && cd create-project
npm init --yes
```

之后在项目的根目录下创建一个名为 `src/` 的目录，然后将一个名为 `cli.js` 的文件放在这个目录下，并在文件中写入代码：

```js
export function cli(args) {
 console.log(args);
}
```

在这个函数中，我们将会解析参数逻辑并触发实际需要的业务逻辑。接下来，我们需要创建 CLI 的入口。在项目根目录下创建目录 `bin/` 然后创建一个名为 `create-project` 的文件。写入代码：

```js
#!/usr/bin/env node

require = require('esm')(module /*, options*/);
require('../src/cli').cli(process.argv);
```

在这一小片代码中，完成了几件事情。首先，我们引入了一个名为 `esm` 的模块，这个模块让我们能在其他文件中使用 `import`。这和构建 CLI 并不直接相关，但是本篇教程中我们需要使用 [ES 模块](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/import)，而包 `esm` 让我们能在 Node.js 版本不支持时无需代码转换而使用 ES 模块。然后我们引入 `cli.js` 文件并调用函数 `cli`，并将 [`process.argv`](https://nodejs.org/api/process.html#process_process_argv) 传入，它是从命令行传入函数脚本的参数数组。

在我们测试脚本之前，需要通过运行如下命令安装 `esm` 依赖：

```
npm install esm
```

另外，我们还要将暴露 CLI 脚本的需求同步给包管理器。方法是在 `package.json` 文件中添加合适的入口。别忘了也要更新属性 `description`、`name`、`keyword` 和 `main`：

```js
{
 "name": "@your_npm_username/create-project",
 "version": "1.0.0",
 "description": "A CLI to bootstrap my new projects",
 "main": "src/index.js",
 "bin": {
   "@your_npm_username/create-project": "bin/create-project",
   "create-project": "bin/create-project"
 },
 "publishConfig": {
   "access": "public"
 },
 "scripts": {
   "test": "echo \"Error: no test specified\" && exit 1"
 },
 "keywords": [
   "cli",
   "create-project"
 ],
 "author": "YOUR_AUTHOR",
 "license": "MIT",
 "dependencies": {
   "esm": "^3.2.18"
 }
}
```

如果你注意到 `bin` 属性，你会发现我们将其定义为一个具有两个键值对的对象。这个对象内定义的是包管理器将会安装的 CLI 命令。在上述的例子中，我们为同一段脚本注册了两个命令。一个通过加上了我们的用户名来使用自己的 `npm` 作用域，另一个是为了方便使用的通用的 `create-project` 命令。

做好了这些，我们可以测试脚本了。最简单的测试方法是使用 [`npm link`](https://docs.npmjs.com/cli/link.html) 命令。在你的项目终端中运行：

```
npm link
```

这个命令将会全局地安装你当前项目的链接，所以当你更新代码的时候，也并不需要重新运行 `npm link` 命令。在运行 `npm link` 命令后，你的 CLI 命令应该已经可用了。试着运行：

```
create-project
```

你应该可以看到类似的输出：

```js
[ '/usr/local/Cellar/node/11.6.0/bin/node',
  '/Users/dkundel/dev/create-project/bin/create-project' ]
```

注意，这两个地址依赖于你的项目地址和 Node.js 安装地址，并会随之变化而不同。并且这个数组会随着你增加参数而变长。试试运行：

```
create-project --yes
```

此时输出可以反映出添加了新的参数：

```
[ '/usr/local/Cellar/node/11.6.0/bin/node',
  '/Users/dkundel/dev/create-project/bin/create-project',
  '--yes' ]
```

## 参数解析与输入处理

现在我们准备解析传入脚本的参数，并赋予其逻辑意义。我们的 CLI 支持一个参数及多个选项：

* `[template]`：我们支持开箱即用的多模版。如果用户没有传入这个参数，我们将给出提示让用户选择
* `--git`：它将会运行 `git init`，来实例化一个新的 git 项目
* `--install`：它将会自动地为项目安装所有依赖
* `--yes`：它将会跳过所有提示，直接使用默认选项

对于我们的项目，将会使用 `inquirer` 来提示输入参数，并使用 `arg` 库来解析 CLI 参数。通过运行如下命令来安装依赖：

```
npm install inquirer arg
```

首先我们来写解析参数的逻辑，解析过程将会把参数解析为一个 `options` 对象，供我们使用。将如下代码加入到 `cli.js` 中：

```js
import arg from 'arg';

function parseArgumentsIntoOptions(rawArgs) {
 const args = arg(
   {
     '--git': Boolean,
     '--yes': Boolean,
     '--install': Boolean,
     '-g': '--git',
     '-y': '--yes',
     '-i': '--install',
   },
   {
     argv: rawArgs.slice(2),
   }
 );
 return {
   skipPrompts: args['--yes'] || false,
   git: args['--git'] || false,
   template: args._[0],
   runInstall: args['--install'] || false,
 };
}

export function cli(args) {
 let options = parseArgumentsIntoOptions(args);
 console.log(options);
}
```

运行 `create-project --yes`，你将能看到 `skipPrompt` 会变成 `true`，或者试着传递其他参数例如 `create-project cli`，那么 `template` 属性就会被设置。

现在我们已经能解析 CLI 参数了，我们还需要添加方法来提示用户输入参数信息，以及当 `--yes` 标志被输入的时候，略过提示信息并使用默认参数。将如下代码加入 `cli.js` 文件：

```js
import arg from 'arg';
import inquirer from 'inquirer';

function parseArgumentsIntoOptions(rawArgs) {
// ...
}

async function promptForMissingOptions(options) {
 const defaultTemplate = 'JavaScript';
 if (options.skipPrompts) {
   return {
     ...options,
     template: options.template || defaultTemplate,
   };
 }

 const questions = [];
 if (!options.template) {
   questions.push({
     type: 'list',
     name: 'template',
     message: 'Please choose which project template to use',
     choices: ['JavaScript', 'TypeScript'],
     default: defaultTemplate,
   });
 }

 if (!options.git) {
   questions.push({
     type: 'confirm',
     name: 'git',
     message: 'Initialize a git repository?',
     default: false,
   });
 }

 const answers = await inquirer.prompt(questions);
 return {
   ...options,
   template: options.template || answers.template,
   git: options.git || answers.git,
 };
}

export async function cli(args) {
 let options = parseArgumentsIntoOptions(args);
 options = await promptForMissingOptions(options);
 console.log(options);
}
```

保存文件并运行 `create-project`，你将会看到这样的模版选择提示：

![](https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/yfGSsiUKImPbvqn6_YlDO5TyLhCF9qT953-6KN4vStg5Wl.width-500.png)

之后，你将会被询问是否要初始化 `git`。两个问题都作出先择后，你将看到打印出了这样的输出：

```
{ skipPrompts: false,
  git: false,
  template: 'JavaScript',
  runInstall: false }
```

尝试运行 `create-project -y` 命令，此时所有的提示都会被忽略。你将会马上看到命令行输入的选项：

![](https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/JhCdQpSDKZzTbIW7stxZScvwr5ak8IZzjvlyLtPihPovb-.width-500.png)

## 编写代码逻辑

现在我们已经可以通过提示信息以及命令行参数来决定对应的逻辑选项，下面我们来写能够创建项目的逻辑代码。我们的 CLI 将会和 `npm init` 命令类似，写入一个已经存在的目录，并会将所有在 `templates` 目录下的文件拷贝到项目中。我们也允许通过选项修改目标目录地址，这样你可以在其他项目中重用这段逻辑。

在我们写逻辑代码之前，在项目根目录下创建一个名为 `templates` 的目录，并将目录 `typescript` 和 `javascript` 放在此目录下。它们的名字都是小写的版本，我们将会提示用户从中选择一个。在本篇文章中，我们就使用这两个名字，但其实你可以使用你任意喜欢的命名。在这个目录下，放入文件 `package.json` 并加入任意你需要的项目基础依赖，以及任意你需要拷贝到项目中的文件。之后我们的代码将会把这些文件全都拷贝到新的项目中。如果你需要一些创作灵感，你可以在 github.com/dkundel/create-project 查看我使用的文件。

为了递归的拷贝所有的文件，我们将会使用一个名为 `ncp` 的库。这个库能够支持跨平台的递归拷贝，甚至有标识可以支持强制覆盖已有文件。另外，为了能够展示彩色输出，我们还将安装 `chalk`。运行如下代码来安装依赖：

```
npm install ncp chalk
```

我们将会把项目核心的逻辑都放到 `src/` 目录下的 `main.js` 文件中。创建新文件并将如下代码加入：

```js
import chalk from 'chalk';
import fs from 'fs';
import ncp from 'ncp';
import path from 'path';
import { promisify } from 'util';

const access = promisify(fs.access);
const copy = promisify(ncp);

async function copyTemplateFiles(options) {
 return copy(options.templateDirectory, options.targetDirectory, {
   clobber: false,
 });
}

export async function createProject(options) {
 options = {
   ...options,
   targetDirectory: options.targetDirectory || process.cwd(),
 };

 const currentFileUrl = import.meta.url;
 const templateDir = path.resolve(
   new URL(currentFileUrl).pathname,
   '../../templates',
   options.template.toLowerCase()
 );
 options.templateDirectory = templateDir;

 try {
   await access(templateDir, fs.constants.R_OK);
 } catch (err) {
   console.error('%s Invalid template name', chalk.red.bold('ERROR'));
   process.exit(1);
 }

 console.log('Copy project files');
 await copyTemplateFiles(options);

 console.log('%s Project ready', chalk.green.bold('DONE'));
 return true;
}
```

这段代码会导出一个名为 `createProject` 的新函数，这个函数会首先检查指定的模版是否是可用的，检查的方法是使用 [`fs.access`](https://nodejs.org/api/fs.html#fs_fs_access_path_mode_callback) 来检查文件的可读性（`fs.constants.R_OK`），然后使用 `ncp` 将文件拷贝到指定的目录下。另外，在拷贝成功后，我们还要输出一些带颜色的日志，内容为 `DONE Project ready`。

之后，更新 `cli.js`，加入对新函数 `createProject` 的调用：

```js
import arg from 'arg';
import inquirer from 'inquirer';
import { createProject } from './main';

function parseArgumentsIntoOptions(rawArgs) {
// ...
}

async function promptForMissingOptions(options) {
// ...
}

export async function cli(args) {
 let options = parseArgumentsIntoOptions(args);
 options = await promptForMissingOptions(options);
 await createProject(options);
}
```

为了测试我们的进度，在你的系统中某个位置例如 `~/test-dir` 中创建一个新目录，然后在这个文件夹内使用某个模版运行命令。比如：

```
create-project typescript --git
```

你应该能看到一个通知，表明项目已经被创建，并且文件已经被拷贝到了这个目录下。

![](https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/hJhXfoE6BvWWHNFzomCs4YD5D4fLUWQqHmR-am2wzAGszS.width-500.png)

现在还有另外两步需要做。我们希望可配置的初始化 `git` 并安装依赖。为了完成这个，我们需要另外三个依赖：

* [`execa`](http://npm.im/execa) 用于让我们能在代码中很便捷的运行像 `git` 这样的外部命令
* [`pkg-install`](http://npm.im/pkg-install) 用于基于用户使用什么而触发命令 `yarn install` 或 `npm install`
* [`listr`](http://npm.im/listr) 让我们能指定任务列表，并给用户一个整齐的进程概览

通过运行如下命令来安装依赖：

```
npm install execa pkg-install listr
```

之后更新 `main.js`，加入如下代码：

```js
import chalk from 'chalk';
import fs from 'fs';
import ncp from 'ncp';
import path from 'path';
import { promisify } from 'util';
import execa from 'execa';
import Listr from 'listr';
import { projectInstall } from 'pkg-install';

const access = promisify(fs.access);
const copy = promisify(ncp);

async function copyTemplateFiles(options) {
 return copy(options.templateDirectory, options.targetDirectory, {
   clobber: false,
 });
}

async function initGit(options) {
 const result = await execa('git', ['init'], {
   cwd: options.targetDirectory,
 });
 if (result.failed) {
   return Promise.reject(new Error('Failed to initialize git'));
 }
 return;
}

export async function createProject(options) {
 options = {
   ...options,
   targetDirectory: options.targetDirectory || process.cwd()
 };

 const templateDir = path.resolve(
   new URL(import.meta.url).pathname,
   '../../templates',
   options.template
 );
 options.templateDirectory = templateDir;

 try {
   await access(templateDir, fs.constants.R_OK);
 } catch (err) {
   console.error('%s Invalid template name', chalk.red.bold('ERROR'));
   process.exit(1);
 }

 const tasks = new Listr([
   {
     title: 'Copy project files',
     task: () => copyTemplateFiles(options),
   },
   {
     title: 'Initialize git',
     task: () => initGit(options),
     enabled: () => options.git,
   },
   {
     title: 'Install dependencies',
     task: () =>
       projectInstall({
         cwd: options.targetDirectory,
       }),
     skip: () =>
       !options.runInstall
         ? 'Pass --install to automatically install dependencies'
         : undefined,
   },
 ]);

 await tasks.run();
 console.log('%s Project ready', chalk.green.bold('DONE'));
 return true;
}
```

这段代码将会在传入 `--git` 或者用户在提示中选择了 `git` 的时候运行 `git init`，并且会在传入 `--install` 的时候运行 `npm install` 或者 `yarn`，否则它将会跳过这两个任务，并用一段消息通知用户如果他们想要自动安装，请传入 `--install`。

首先删除掉已经存在的测试文件夹然后创建一个新的，然后试一下效果如何。运行命令：

```
create-project typescript --git --install
```

在你的文件夹中，你应该能看到 `.git` 文件夹和 `node_modules` 文件夹，表示 `git` 已经被初始化，以及 `package.json` 中指定的依赖已经被安装了。

![](https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/_vaH2-wgo0HxH7o6NVcQwlb-h7MihVzFVO_6MsTcw71qB8.width-500.png)

恭喜你，你的第一个 CLI 已经整装待发了！

![](https://s3.amazonaws.com/com.twilio.prod.twilio-docs/original_images/Hlw2ROeuFERjiDODTmaGu6z7YtmcGN0yTWiPeRLRRr6EENm7HJ8s3laAGZGdd54NefTAJPut5nZCDe)

如果你希望你的代码能作为实际的模块使用，这样其他人可以在他们的代码中复用你的逻辑，你还需要在目录 `src/` 下添加文件 `index.js`，这个文件暴露出了 `main.js` 的内容：

```js
require = require('esm')(module);
require('../src/cli').cli(process.argv);
```

## 接下来做什么？

现在你的 CLI 代码已经准备好，你可以由此为基础，向更多的方向发展。如果你仅仅想自己使用，而不想和其他人分享，那么你就需要继续沿用 `npm link` 即可。事实上，运行 `npm init project` 试试看，你的代码也将被触发。

如果你想要和其他人分享你的代码模版，你可以将代码推送到 GitHub 来供参阅，或者更好的方法是，使用 [`npm publish`](https://docs.npmjs.com/cli/publish) 将它作为一个包推送到 `npm` 注册处。在你发布之前，你还需要确保在 `package.json` 文件中添加一个 `files` 属性，来指明那些文件应该被发布：

```js
 },
 "files": [
   "bin/",
   "src/",
   "templates/"
 ]
}
```

如果你想要检查那个文件将会被发布，运行 `npm pack --dry-run` 然后查看输出。之后使用 `npm publish` 来发布你的 CLI。你可以在 [`@dkundel/create-project`](http://npm.im/@dkundel/create-project) 找到我的项目，或者试试看运行 `npm init @dkundel/project`。

还有很多的功能你可以加入进来。在我的项目中，我还添加了一些依赖，用于为我创建 `LICENSE`、`CODE_OF_CONDUCT.md` 和 `.gitignore`。你可以[在 GitHub 找到实现这些功能的源代码](http://github.com/dkundel/create-project)，或着查看上面提到的仓库来扩充附加功能。如果你发现某个你觉得应该被列出在文章中而我并没有列出的库，或者想要给我看你的 CLI，尽管发送消息给我！

* Email：[dkundel@twilio.com](mailto:dkundel@twilio.com)
* Twitter：[@dkundel](https://twitter.com/dkundel?lang=en)
* GitHub：[dkundel](https://github.com/dkundel)
* [dkundel.com](https://dkundel.com/)

使用 JavaScript 还可以构建更多：

* [Changelog: Twilio Chat JavaScript SDK](https://www.twilio.com/docs/chat/javascript/changelog)
* [Sync SDK for JavaScript](https://www.twilio.com/docs/sync/javascript-sdk-changelog)
* [How to Build a Real Time MMS Photostream with Twilio and Socket.IO](https://www.twilio.com/blog/2014/11/how-to-build-a-real-time-mms-photostream-with-twilio-and-socket-io.html)
* [Implementing Chat in JavaScript, Node.js and React Apps](https://www.twilio.com/blog/2017/10/implement-chat-javascript-nodejs-react-apps.html)
* [How to play music over phone calls with Twilio Voice and JavaScript](https://www.twilio.com/blog/2015/08/playing-tunes-over-the-phone-with-the-twilio-nodejs-library-in-es6.html)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
