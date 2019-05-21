> * 原文地址：[How to build a CLI with Node.js](https://www.twilio.com/blog/how-to-build-a-cli-with-node-js)
> * 原文作者：[dkundel](https://twitter.com/dkundel?lang=en)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-build-a-cli-with-node-js.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-build-a-cli-with-node-js.md)
> * 译者：
> * 校对者：

# How to build a CLI with Node.js

![atZ3n9vMFjjXDl_XxDtL_FCRSOt6EF0d8LnbMRCCJQUesMme8lzdGpCyMr4-wt1nlIGuoT29EI_tkVpuD_P2mxzbfhbn-ZPcqmZ5QCY_nM9d4ywWEYQxKYc9mjxUnp_uFJzMOMnr](https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/atZ3n9vMFjjXDl_XxDtL_FCRSOt6EF0d8LnbMRCCJQUesM.width-808.png)

Command-line interfaces (CLIs) built in Node.js allow you to automate repetitive tasks while leveraging the vast Node.js ecosystem. And thanks to package managers like [`npm`](https://www.npmjs.com/) and [`yarn`](https://yarnpkg.com/), these can be easily distributed and consumed across multiple platforms. In this post we'll look at why you might want to write a CLI, how to use Node.js for it, some useful packages and how you can distribute your new CLI.

## Why create CLIs with Node.js

One of the reasons why Node.js got so popular is the rich package ecosystem with over 900,000 packages in the [`npm` registry](https://npmjs.com). By writing your CLIs in Node.js you can tap into this ecosystem including it's big amount of CLI-focused packages. Among others:

* [`inquirer`](http://npm.im/inquirer), [`enquirer`](http://npm.im/enquirer) or [`prompts`](https://npm.im/prompts) for complex input prompts
* [`email-prompt`](http://npm.im/email-prompt) for convenient email input prompts
* [`chalk`](http://npm.im/chalk) or [`kleur`](https://npm.im/kleur) for colored output
* [`ora`](http://npm.im/ora) for beautiful spinners
* [`boxen`](http://npm.im/boxen) for drawing boxes around your output
* [`stmux`](http://npm.im/stmux) for a `tmux` like UI
* [`listr`](http://npm.im/listr) for progress lists
* [`ink`](http://npm.im/ink) to build CLIs with React
* [`meow`](http://npm.im/meow) or [`arg`](http://npm.im/arg) for basic argument parsing
* [ `commander`](http://npm.im/commander) and [`yargs`](https://www.npmjs.com/package/yargs) for complex argument parsing and subcommand support
* [`oclif`](https://oclif.io/) a framework for building extensible CLIs by Heroku ([`gluegun`](https://infinitered.github.io/gluegun/#/) as an alternative)

Additionally there are many convenient ways to consume CLIs published to `npm` from both `yarn` and `npm`. Take as an example `create-flex-plugin`, a CLI that you can use to bootstrap a plugin for [Twilio Flex](https://twilio.com/flex). You can install it as a global command:

```
# Using npm:
npm install -g create-flex-plugin
# Using yarn:
yarn global add create-flex-plugin
# Afterwards you will be able to consume it:
create-flex-plugin
```

Or as project specific dependencies:

```
# Using npm:
npm install create-flex-plugin --save-dev
# Using yarn:
yarn add create-flex-plugin --dev
# Afterwards the command will be in
./node_modules/.bin/create-flex-plugin
# Or via npx using npm:
npx create-flex-plugin
# And via yarn:
yarn create-flex-plugin
```

In fact `npx` supports executing CLIs even when they are not installed yet. Simply run `npx create-flex-plugin` and it will download it into a cache if it can't find a locally- or globally-installed version.

Lastly since `npm` version 6.1, `npm init` and `yarn` supports a way for you to bootstrap projects using CLIs that are named `create-*`. As an example, for our `create-flex-plugin` really all we have to call is:

```
# Using Node.js
npm init flex-plugin
# Using Yarn:
yarn create flex-plugin
```

## Setup Your First CLI

If you prefer following along a video tutorial, [check out this tutorial on our YouTube](https://www.youtube.com/watch?v=s2h28p4s-Xs).

Now that we covered why you might want to create a CLI using Node.js, let's start building one. We'll use `npm` in this tutorial but there are equivalent commands for most things in `yarn`. Make sure you have [Node.js](https://nodejs.org/en/download/) and [`npm`](https://www.npmjs.com/) installed on your system.

In this tutorial we'll create a CLI that bootstraps new projects to your own preferences by running `npm init @your-username/project`.

Start a new Node.js project by running:

```
mkdir create-project && cd create-project
npm init --yes
```

Afterwards create a directory called `src/` in the root of your project and place a file called `cli.js` into it with the following code:

```js
export function cli(args) {
 console.log(args);
}
```

This will be the part where we'll later parse our logic and then trigger our actual business logic. Next we'll need to create our entry point for our CLI. Create a new directory `bin/` in the root of our project and create a new file inside it called `create-project`. Place the following lines of code into it:

```js
#!/usr/bin/env node

require = require('esm')(module /*, options*/);
require('../src/cli').cli(process.argv);
```

There's a few things going on in this small snippet. First we require a module called `esm` that enables us to use `import` in the other files. This is not directly related to building CLIs but we will be using [ES Modules](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/import) in this tutorial and the `esm` package allows us to do so without the need to transpile for Node.js versions without the support. Afterwards we'll require our `cli.js` file and call the `cli` function exposed with [`process.argv`](https://nodejs.org/api/process.html#process_process_argv) which is an array of all the arguments passed to this script from the command line. 

Before we can test our script we'll need to install our `esm` dependency by running:

```
npm install esm
```

We'll also have to inform the package manager that we are exposing a CLI script. We do this by adding the appropriate entry in our `package.json`. Don't forget to also update the `description`, `name`, `keyword` and `main` properties accordingly:

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

If you look at the `bin` key, we are passing in an object with two key/value pairs. Those define the CLI commands that your package manager will install. In our case we'll register the same script for two commands. Once using our own `npm` scope by using our username and once as the generic `create-project` command for convenience.

Now that we have this done, we can test our script. To do so, the easiest way is to use the [`npm link`](https://docs.npmjs.com/cli/link.html) command. Run in your terminal inside your project:

```
npm link
```

This will globally install a symlink linking to your current project so there's no need for you to re-run this when we update our code. After running `npm link` you should have your CLI commands available. Try running:

```
create-project
```

You should see an output similar to this:

```js
[ '/usr/local/Cellar/node/11.6.0/bin/node',
  '/Users/dkundel/dev/create-project/bin/create-project' ]
```

Note that both paths will be different for you depending on where your project lies and where you have Node.js installed. This array will be longer with every argument that you add to this. Try running:

```
create-project --yes
```

And the output should reflect the new argument:

```
[ '/usr/local/Cellar/node/11.6.0/bin/node',
  '/Users/dkundel/dev/create-project/bin/create-project',
  '--yes' ]
```

## Parsing Arguments and Handling Input

We are now ready to parse the arguments that are being passed to our script and we can start making sense of them. Our CLI will support one argument and a few options:

* `[template]`: We'll support different templates out of the box. If this is not passed we'll prompt the user to select a template
* `--git`: This will run `git init` to instantiate a new git project
* `--install`: This will automatically install all the dependencies for the project
* `--yes`: This will skip all prompts and go for default options

For our project we'll use `inquirer` to prompt for missing values and the `arg` library to parse our CLI arguments. Install the missing dependencies by running:

```
npm install inquirer arg
```

Let's first write the logic that will parse our arguments into an `options` object that we can work with. Add the following code to your `cli.js`:

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

Try running `create-project --yes` and you should see `skipPrompt` to turn to `true` or try passing another argument in like `create-project cli` and the `template` property should be set.

Now that we are able to parse the CLI arguments, we'll need to add the functionality to prompt for the missing information as well as skip the prompt and resort to default arguments if the `--yes` flag is passed. Add the following code to your `cli.js` file:

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

Save the file and run `create-project` and you should be prompted with a template selection prompt:

![](https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/yfGSsiUKImPbvqn6_YlDO5TyLhCF9qT953-6KN4vStg5Wl.width-500.png)

And afterwards you'll be prompted with a question whether you want to initialize `git`. Once you selected both you should see output like this printed:

```
{ skipPrompts: false,
  git: false,
  template: 'JavaScript',
  runInstall: false }
```

Try to run the same command with `-y` and the prompts should be skipped. Instead you'll immediately see the determined options output.

![](https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/JhCdQpSDKZzTbIW7stxZScvwr5ak8IZzjvlyLtPihPovb-.width-500.png)

## Writing the Logic

Now that we are able to determine the respective options through prompts and command-line arguments, let's write the actual logic that will create our projects. Our CLI will write into an existing directory similar to `npm init` and it will copy all files from a `templates` directory in our project. We'll allow the target directory to be also modified via the options in case you want to re-use the same logic inside another project.

Before we write the actual logic, create a `templates` directory in the root of our project and place two directories with the names `typescript` and `javascript` into it. Those are the lower-cased versions of the two values that we prompted the user to pick from. This post will use these names but feel free to use other names you'd like. Inside that directory place any `package.json` that you would like to use as the base of your project and any kind of files you want to have copied into your project. Our code will later simply copy those files into the new project. If you need some inspiration, you can check out my files at github.com/dkundel/create-project.

In order to do recursive copying of the files we'll use a library called `ncp`. This library supports recursive copying cross-platform and even has a flag to force override existing files. Additionally we'll install `chalk` for colored output. To install the dependencies run:

```
npm install ncp chalk
```

We'll place all of our core logic into a `main.js` file inside the `src/` directory of our project. Create the new file and add the following code:

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

This code will export a new function called `createProject` that will first check if the specified template is indeed an available template, by checking the `read` access (`fs.constants.R_OK`) using [`fs.access`](https://nodejs.org/api/fs.html#fs_fs_access_path_mode_callback) and then copy the files into the target directory using `ncp`. Additionally we'll log some colored output saying `DONE Project ready` when we successfully copied the files.

Afterwards update your `cli.js` to call the new `createProject` function:

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

To test our progress, create a new directory somewhere like `~/test-dir` on your system and run inside it the command using one of your templates. For example:

```
create-project typescript --git
```

You should see a confirmation that the project has been created and the files should be copied over to the directory.

![](https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/hJhXfoE6BvWWHNFzomCs4YD5D4fLUWQqHmR-am2wzAGszS.width-500.png)Now there are two more steps we want our CLI to do. We want to optionally initialize `git` and install our dependencies. For this we'll use three more dependencies:

* [`execa`](http://npm.im/execa) which allows us to easily run external commands like `git`
* [`pkg-install`](http://npm.im/pkg-install) to trigger either `yarn install` or `npm install` depending on what the user uses
* [`listr`](http://npm.im/listr) which let's us specify a list of tasks and gives the user a neat progress overview

Install the dependencies by running:

```
npm install execa pkg-install listr
```

Afterwards update your `main.js` to contain the following code:

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

This will run `git init` whenever `--git` is passed or the user chooses `git` in the prompt and it will run `npm install` or `yarn` whenever the user passes `--install`, otherwise it will skip the task with a message informing the user to pass `--install` if they want automatic install.

Give it a try by deleting your existing test folder first and creating a new one. Then run:

```
create-project typescript --git --install
```

You should see now both a `.git` folder in your folder indicating that `git` has been initialized and a `node_modules` folder with your dependencies that were specified in the `package.json` installed.

![](https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/_vaH2-wgo0HxH7o6NVcQwlb-h7MihVzFVO_6MsTcw71qB8.width-500.png)

Congratulations you got your first CLI ready to go!

![](https://s3.amazonaws.com/com.twilio.prod.twilio-docs/original_images/Hlw2ROeuFERjiDODTmaGu6z7YtmcGN0yTWiPeRLRRr6EENm7HJ8s3laAGZGdd54NefTAJPut5nZCDe)

If you want to make your code consumable as an actual module so that others can reuse your logic in their code, we'll have to add an `index.js` file to our `src/` directory that exposes the content from `main.js`:

```js
require = require('esm')(module);
require('../src/cli').cli(process.argv);
```

## What's Next?

Now that you have your CLI code ready there are a few ways you can go from here. If you just want to use this yourself and don't want to share it with the world you can just keep on going along the path of using `npm link`. In fact try running `npm init project` and it should trigger your code.

If you want to share your templates with the world either push your code to GitHub and consume it from there or even better push it as a scoped package to the `npm` registry with [`npm publish`](https://docs.npmjs.com/cli/publish). Before you do so, you should make sure to add a `files` key in your `package.json` to specify which files should be published.

```js
 },
 "files": [
   "bin/",
   "src/",
   "templates/"
 ]
}
```

If you want to check which files will be published, run `npm pack --dry-run` and check the output. Afterwards use `npm publish` to publish your CLI. You can find my project under [`@dkundel/create-project`](http://npm.im/@dkundel/create-project) or try run `npm init @dkundel/project`.

There's also lots of functionality that you can add. In my case I added some additional dependencies that will create a `LICENSE`, `CODE_OF_CONDUCT.md` and `.gitignore` file for me. You can [find the source code for it on GitHub](http://github.com/dkundel/create-project) or check out some of the libraries mentioned above for some additional functionality. If you have a library I didn't list and you believe it should totally be in the list or if you want to show me your own CLI, feel free to send me a message!

* Email: [dkundel@twilio.com](mailto:dkundel@twilio.com)
* Twitter: [@dkundel](https://twitter.com/dkundel?lang=en)
* GitHub: [dkundel](https://github.com/dkundel)
* [dkundel.com](https://dkundel.com/)

Build More With JavaScript

* [Changelog: Twilio Chat JavaScript SDK](https://www.twilio.com/docs/chat/javascript/changelog)
* [Sync SDK for JavaScript](https://www.twilio.com/docs/sync/javascript-sdk-changelog)
* [How to Build a Real Time MMS Photostream with Twilio and Socket.IO](https://www.twilio.com/blog/2014/11/how-to-build-a-real-time-mms-photostream-with-twilio-and-socket-io.html)
* [Implementing Chat in JavaScript, Node.js and React Apps](https://www.twilio.com/blog/2017/10/implement-chat-javascript-nodejs-react-apps.html)
* [How to play music over phone calls with Twilio Voice and JavaScript](https://www.twilio.com/blog/2015/08/playing-tunes-over-the-phone-with-the-twilio-nodejs-library-in-es6.html)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
