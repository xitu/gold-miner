> * 原文地址：[How I automated my job with Node.js](https://medium.com/dailyjs/how-i-automated-my-job-with-node-js-94bf4e423017)
> * 原文作者：[Shaun Michael Stone](https://medium.com/@shaunmstone?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-i-automated-my-job-with-node-js.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-i-automated-my-job-with-node-js.md)
> * 译者：
> * 校对者：

# How I automated my job with Node.js

![](https://cdn-images-1.medium.com/max/800/1*S7-c7ZO0w0ocUU8tzkB3zA.jpeg)

You know those tedious tasks you have to do at work: Updating configuration files, copying and pasting files, updating Jira tickets.

Time adds up after a while. This was very much the case when I worked for an online games company back in 2016. The job could be very rewarding at times when I had to build configurable templates for games, but about 70% of my time was spent on making copies of those templates and deploying re-skinned implementations.

### What is a Reskin?

The definition of a reskin at the company was using the same game mechanics, screens and positioning of elements, but changing the visual aesthetics such as colour and assets. So in the context of a simple game like ‘Rock Paper Scissors’, we would create a template with basic assets like below.

![](https://cdn-images-1.medium.com/max/800/1*hgFoiDduNdXaLJ-0seB-Gw.jpeg)

But when we create a reskin of this, we would use different assets and the game would still work. If you look at games like Candy Crush or Angry Birds, you’ll find that they have many varieties of the same game. Usually Halloween, Christmas or Easter releases. From a business perspective it makes perfect sense. Now… back to our implementation. Each of our games would share the same bundled JavaScript file, and load in a JSON file that had different content and asset paths. The result?

![](https://cdn-images-1.medium.com/max/800/1*SYAsVKSmEmcKQ8dEZiisPg.jpeg)

Me and the other developers had stacked daily schedules, and my first thought was, ‘a lot of this could be automated.’ Whenever I created a new game, I had to carry out these steps:

1.  Do a git pull on the templates repository to make sure they were up to date;
2.  Create a new branch — identified by the Jira ticket ID — from the master branch;
3.  Make a copy of the template I needed to build;
4.  Run gulp;
5.  Update the content in a **config.json** file. This would involve asset paths, headings and paragraphs as well as data service requests;
6.  Build locally and check content matched the stakeholder’s word document. _Yeah I know_;
7.  Verify with the designers they are happy with how it looks;
8.  Merge to master branch and move on to the next one;
9.  Update the status of the Jira ticket and leave a comment for the stakeholders involved;
10.  Rinse and repeat.

![](https://cdn-images-1.medium.com/max/800/1*7Jg9xcM_hj6g8QC22vTiiw.jpeg)

Now to me, this felt more administrative than actual development work. I was exposed to Bash scripting in a previous role and jumped on it to create a few scripts to reduce the effort involved. One of the scripts updated the templates and created a new branch, the other script did a commit and merged the project to Staging and Production environments.

Setting up a project would take me three-to-ten minutes to set up manually. Maybe five to ten minutes for deployment. Depending on the complexity of the game, it could take anything from ten minutes to half a day. The scripts helped, but a lot of time was still spent on updating the content or trying to chase down missing information.

![](https://cdn-images-1.medium.com/max/800/0*jxmPvnNgXhpFMV3v.)

Writing code to shave time was not enough. It was thinking of a better approach to our workflow so that I could utilise the scripts more. Move the content from out of the word documents, and into Jira tickets, breaking it out into the relevant custom fields. The Designers, instead of sending a link to where the assets exist on the public drive, it would be more practical to set up a content delivery network (CDN) repository with a Staging and Production URL to the assets.

### Jira API

Things like this can take a while to enforce, but our process did improve over time. I did some research on the API of Jira; our project management tool, and did some requests to the Jira tickets I was working on. I was pulling back _a lot_ of valuable data. So valuable that I made the decision to integrate it into my Bash scripts to read values from Jira tickets, to also post comments and tag stakeholders when I finished.

### Bash Transition to Node

The Bash scripts were good, but if someone was working on a Windows machine, they couldn’t be run. After doing some digging, I made the decision to use JavaScript to wrap the whole process into a bespoke build tool. I called the tool **Mason**, and it would change everything.

### CLI

When you use Git — I assume you do — in the terminal, you will notice it has a very friendly command line interface. If you misspell or type a command incorrectly, it will politely make a suggestion on what it thinks you were trying to type. A library called **commander** applies the same behaviour, and this was one of many libraries I used.

Consider the simplified code example below. It’s bootstrapping a Command Line Interface (CLI) application.

#### src/mason.js

```
#! /usr/bin/env node

const mason = require('commander');
const { version } = require('./package.json');
const console = require('console');

// commands
const create = require('./commands/create');
const setup = require('./commands/setup');

mason
    .version(version);

mason
    .command('setup [env]')
    .description('run setup commands for all envs')
    .action(setup);

mason
    .command('create <ticketId>')
    .description('creates a new game')
    .action(create);

mason
    .command('*')
    .action(() => {
        mason.help();
    });

mason.parse(process.argv);

if (!mason.args.length) {
    mason.help();
}
```

With the use of npm, you can run a link from your **package.json** and it will create a global alias.

```
...
"bin": {
  "mason": "src/mason.js"
},
...
```

When I run npm link in the root of the project.

```
npm link
```

It will provide me with a command I can call, called mason. So whenever I call mason in my terminal, it will run that **mason.js** script. All tasks fall under one umbrella command called mason, and I used it to build games every day. The time I saved was… incredible.

You can see below — in a hypothetical example of what I did back then — that I pass a Jira ticket number to the command as an argument. This would curl the Jira API, and fetch all the information I needed to update the game. It would then proceed to build and deploy the project. I would then post a comment and tag the stakeholder & designer to let them know it was done.

```
$ mason create GS-234
... calling Jira API 
... OK! got values!
... creating a new branch from master called 'GS-234'
... updating templates repository
... copying from template 'pick-from-three'
... injecting values into config JSON
... building project
... deploying game
... Perfect! Here is the live link 
http://www.fake-studio.com/game/fire-water-earth
... Posted comment 'Hey [~ben.smith], this has been released. Does the design look okay? [~jamie.lane]' on Jira.
```

All done with a few key strokes!

I was so happy with the whole project, I decided to rewrite a better version in a book I’ve just released called, **‘Automating with Node.js’:**

![](https://cdn-images-1.medium.com/max/800/1*wOmVnWEaWu-1g-xL874xyg.jpeg)

> **_Colour Print:_**  [_http://amzn.eu/aA0cSnu_](http://amzn.eu/aA0cSnu)**_Kindle:_**  [_http://amzn.eu/dVSykv1_](http://amzn.eu/dVSykv1)**_Kobo:_**  [_https://www.kobo.com/gb/en/ebook/automating-with-node-js_](https://www.kobo.com/gb/en/ebook/automating-with-node-js)  
> **_Leanpub:_** [_https://leanpub.com/automatingwithnodejs_](https://leanpub.com/automatingwithnodejs)**_Google Play:_**  [https://play.google.com/store/books/details?id=9QFgDwAAQBAJ](https://play.google.com/store/books/details?id=9QFgDwAAQBAJ)

The book is broken into two parts:

### Part 1

The first part is a collection of recipes, or instructional building blocks that behave as individual global commands. These can be used as you go about your day, and can be called at any time to speed up your workflow or for pure convenience.

### Part 2

The second part is a walk-through of creating a cross-platform build tool from the ground up. Each script that achieves a certain task will be its own command, with a main umbrella command — usually the name of your project — encapsulating them all.

The project in the book is called **nobot** _(no-bot)_ Based on the little cartoon robot. I hope you enjoy reading it and learn something.

![](https://cdn-images-1.medium.com/max/800/1*fiOf2PARww-2wmOiV66iWA.jpeg)

I understand that circumstances and flows are different in every business, but you should be able to find something, even if it’s small, that can make your day a little easier at the office.

**Spend more time dev’ing and less time doing admin.**

![](https://cdn-images-1.medium.com/max/800/1*4877k4Hq9dPdtmvg9hnGFA.jpeg)

Thanks for reading! If you enjoyed, drop us a few claps below. 👏

For videos on all aspects of software/hardware, check out my YouTube channel: [https://www.youtube.com/channel/UCKr-FjGzNdbbk--gvW5tzaw](https://www.youtube.com/channel/UCKr-FjGzNdbbk--gvW5tzaw)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
