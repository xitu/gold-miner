> * 原文地址：[How to make a beautiful, tiny npm package and publish it](https://medium.freecodecamp.org/how-to-make-a-beautiful-tiny-npm-package-and-publish-it-2881d4307f78)
> * 原文作者：[Jonathan Wood](https://medium.freecodecamp.org/@Bamblehorse?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-make-a-beautiful-tiny-npm-package-and-publish-it.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-make-a-beautiful-tiny-npm-package-and-publish-it.md)
> * 译者：
> * 校对者：

# How to make a beautiful, tiny npm package and publish it

You won’t believe how easy it is!

![](https://cdn-images-1.medium.com/max/800/0*7m8mTkj_Fp916sdm)

Photo by [Chen Hu](https://unsplash.com/@huchenme?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)

If you’ve created lots of npm modules, you can skip ahead. Otherwise, we’ll go through a quick intro.

#### TL;DR

An npm module **only** requires a package.json file with **name** and **version** properties.

### Hey!

There you are.

Just a tiny elephant with your whole life ahead of you.

You’re no expert in making npm packages, but you’d love to learn how.

All the big elephants stomp around with their giant feet, making package after package, and you’re all like:

> “I can’t compete with that.”

Well I’m here to tell that you you can!

No more self doubt.

Let’s begin!

#### You’re not an Elephant

I meant that [metaphorically](https://www.merriam-webster.com/dictionary/metaphorical).

Ever wondered what baby elephants are called?

_Of course you have._ A baby elephant is called a [calf](https://www.reference.com/pets-animals/baby-elephant-called-a3893188e0a63095).

#### I believe in you

[Self doubt](https://en.wikipedia.org/wiki/Impostor_syndrome) is real.

That’s why no one ever does anything cool.

You think you won’t succeed, so instead you do nothing. But then you glorify the people doing all the awesome stuff.

Super ironic.

That’s why I’m going to show you the tiniest possible npm module.

Soon you’ll have hoards of npm modules flying out of your finger tips. Reusable code as far as the eye can see. No tricks — no complex instructions.

### The Complex Instructions

I promised I wouldn’t…

…but I totally did.

They’re not that bad. You’ll forgive me one day.

#### Step 1: npm account

You need one. It’s just part of the deal.

[Signup here](https://www.npmjs.com/signup).

#### Step 2: login

Did you make an npm account?

Yeah you did.

Cool.

I’m also assuming you can use the [command line / console](https://www.davidbaumgold.com/tutorials/command-line/) etc. I’m going to be calling it the terminal from now on. There’s a difference [apparently](https://superuser.com/questions/144666/what-is-the-difference-between-shell-console-and-terminal).

Go to your terminal and type:

```
npm adduser
```

You can also use the command:

```
npm login
```

Pick whichever command jives with you.

You’ll get a prompt for your **username**, **password** and **email**. Stick them in there!

You should get a message akin to this one:

> Logged in as bamblehorse to scope [@username](http://twitter.com/username "Twitter profile for @username") on [https://registry.npmjs.org/](https://registry.npmjs.org/).

Nice!

### Let’s make a package

First we need a folder to hold our code. Create one in whichever way is comfortable for you. I’m calling my package **tiny** because it really is very small. I’ve added some terminal commands for those who aren’t familiar with them.

> [md](https://en.wikipedia.org/wiki/Mkdir) tiny

In that folder we need a [**package.json**](https://docs.npmjs.com/files/package.json) file. If you already use [Node.js](https://en.wikipedia.org/wiki/Node.js) — you’ve met this file before. It’s a [JSON](https://en.wikipedia.org/wiki/JSON) file which includes information about your project and has a plethora of different options. In this tutorial, we are only going to focus on two of them.

> [cd](https://en.wikipedia.org/wiki/Cd_%28command%29) tiny && [touch](https://superuser.com/questions/502374/equivalent-of-linux-touch-to-create-an-empty-file-with-powershell) package.json

#### How small can it really be, though?

Really small.

All tutorials about making an npm package, including the official documentation, tell you to enter certain fields in your package.json. We’re going to keep trying to publish our package with as little as possible until it works. It’s a kind of [TDD](https://en.wikipedia.org/wiki/Test-driven_development) for a minimal npm package.

**Please note:** I’m showing you this to demonstrate that making an npm package doesn’t have to be complicated. To be useful to the community at large, a package needs a few extras, and we’ll cover that later in the article.

#### Publishing: First attempt

To publish your npm package, you run the well-named command: **npm publish.**

So we have an empty package.json in our folder and we’ll give it a try:

```
npm publish
```

Whoops!

We got an error:

```
npm ERR! file package.json
npm ERR! code EJSONPARSE
npm ERR! Failed to parse json
npm ERR! Unexpected end of JSON input while parsing near ''
npm ERR! File: package.json
npm ERR! Failed to parse package.json data.
npm ERR! package.json must be actual JSON, not just JavaScript.
npm ERR!
npm ERR! Tell the package author to fix their package.json file. JSON.parse
```

npm doesn’t like that much.

Fair enough.

#### Publishing: Strike two

Let’s give our package a name in the package.json file:

```
{
"name": "@bamlehorse/tiny"
}
```

You might have noticed that I added my npm username onto the beginning.

What’s that about?

By using the name **@bamblehorse/tiny** instead of just **tiny**, we create a package under the **scope** of our username. It’s called a [**scoped package**](https://docs.npmjs.com/misc/scope). It allows us to use short names that might already be taken, for example the [**tiny** package](https://www.npmjs.com/package/tiny) already exists in npm.

You might have seen this with popular libraries such as the [Angular framework](https://angular.io/) from Google. They have a few scoped packages such as [@angular/core](https://www.npmjs.com/package/@angular/core) and [@angular/http](https://www.npmjs.com/package/@angular/http).

Pretty cool, huh?

We’ll try and publish a second time:

```
npm publish
```

The error is smaller this time — progress.

```
npm ERR! package.json requires a valid “version” field
```

Each npm package needs a version so that developers know if they can safely update to a new release of your package without breaking the rest of their code. The versioning system npm using is called [**SemVer**](https://semver.org/), which stands for **Semantic Versioning**.

Dont worry too much about understanding the more complex version names but here’s their summary of how the basic ones work:

> Given a version number MAJOR.MINOR.PATCH, increment the:
>
> 1. MAJOR version when you make incompatible API changes,
>
> 2. MINOR version when you add functionality in a backwards-compatible manner, and
>
> 3. PATCH version when you make backwards-compatible bug fixes.
>
> Additional labels for pre-release and build metadata are available as extensions to the MAJOR.MINOR.PATCH format.
>
> [https://semver.org](https://semver.org/)

#### **Publishing: The third try**

We’ll give our package.json the version: **1.0.0** — the first major release.

```
{
"name": "@bamblehorse/tiny",
"version": "1.0.0"
}
```

Let’s publish!

```
npm publish
```

Aw shucks.

```
npm ERR! publish Failed PUT 402
npm ERR! code E402
npm ERR! You must sign up for private packages : @bamblehorse/tiny
```

Allow me to explain.

Scoped packages are automatically published privately because, as well as being useful for single users like us, they are also utilized by companies to share code between projects. If we had published a normal package, then our journey would end here.

All we need to change is to tell npm that actually we want everyone to use this module — not keep it locked away in their vaults. So instead we run:

```
npm publish --access=public
```

Boom!

```
+ @bamblehorse/tiny@1.0.0
```

We receive a plus sign, the name of our package and the version.

We did it — we’re in the npm club.

I’m excited.

_You must be excited._

![](https://cdn-images-1.medium.com/max/800/1*oBaHFxAXy-BWtzyAKeMGBQ.png)

redacted in a friendly blue

#### Did you catch that?

> npm loves you

Cute!

[Version one](https://www.npmjs.com/package/@bamblehorse/tiny/v/1.0.0) is out there!

### Let’s regroup

If we want to be taken seriously as a developer, and we want our package to be used, we need to show people the code and tell them how to use it. Generally we do that by putting our code somewhere public and adding a readme file.

We also need some code.

Seriously.

We have no code yet.

GitHub is a great place to put your code. Let’s make a [new repository](https://github.com/new).

![](https://cdn-images-1.medium.com/max/800/1*NGHjzcMgnzBtmSFfQuqVow.png)

#### README!

I got used to typing **README** instead of **readme.**

You don’t have to do that anymore.

It’s a funny convention.

We’re going to add some funky badges from [shields.io](https://shields.io/) to let people know we are super cool and professional.

Here’s one that let’s people know the current version of our package:

![](https://cdn-images-1.medium.com/max/800/1*ZbzgGAfTeBlqNH2gtLy-GQ.png)

**npm (scoped)**

This next badge is interesting. It failed because we don’t actually have any code.

We should really write some code…

![](https://cdn-images-1.medium.com/max/800/1*mxZkgckYLK16mhkRte1Bqw.png)

**npm bundle size (minified)**

![](https://cdn-images-1.medium.com/max/800/1*gY_-15Q4rLU129dXLg5ibQ.png)

Our tiny readme

#### License to code

That title is definitely a [James Bond reference](https://www.imdb.com/title/tt0097742/).

I actually forgot to add a license.

A license just let’s people know in what situations they can use your code. There are [lots of different ones](https://choosealicense.com/).

There’s a cool page called insights in every GitHub repository where you can check various stats — including the community standards for a project. I’m going to add my license from there.

![](https://cdn-images-1.medium.com/max/800/1*hkUyteXGLLTDt0WwKEpZ6A.png)

**Community recommendations**

Then you hit this page:

![](https://cdn-images-1.medium.com/max/800/1*ZWgFtTjkB8RpBDfRsCsLUQ.png)

Github gives you a helpful summary of each license

#### The Code

We still don’t have any code. This is slightly embarrassing.

Let’s add some now before we lose all credibility.

```
module.exports = function tiny(string) {
  if (typeof string !== "string") throw new TypeError("Tiny wants a string!");
  return string.replace(/\s/g, "");
};
```

Useless — but beautiful

There it is.

A **tiny** function that removes all spaces from a string.

So all an npm package requires is an **index.js** file. This is the entry point to your package. You can do it in different ways as your package becomes more complex.

But for now this is all we need.

### Are we there yet?

We’re so close.

We should probably update our minimal **package.json** and add some instructions to our **readme.md**.

Otherwise nobody will know how to use our beautiful code.

#### package.json

```
{
  "name": "@bamblehorse/tiny",
  "version": "1.0.0",
  "description": "Removes all spaces from a string",
  "license": "MIT",
  "repository": "bamblehorse/tiny",
  "main": "index.js",
  "keywords": [
    "tiny",
    "npm",
    "package",
    "bamblehorse"
  ]
}
```

Descriptive!

We’ve added:

*   [description](https://docs.npmjs.com/files/package.json#description-1): a short description of the package
*   [repository](https://docs.npmjs.com/files/package.json#repository): GitHub friendly — so you can write **username/repo**
*   [license](https://docs.npmjs.com/files/package.json#license): MIT in this case
*   [main](https://docs.npmjs.com/files/package.json#main): the entry point to your package, relative to the root of the folder
*   [keywords](https://docs.npmjs.com/files/package.json#keywords): a list of keywords used to discover your package in npm search

#### readme.md

![Informative!](https://i.loli.net/2018/11/26/5bfbdd88d4ac8.png)

Informative!

We’ve added instructions on how to install and use the package. Nice!

If you want a good template for your readme, just check out popular packages in the open source community and use their format to get you started.

### Done

Let’s publish our spectacular package.

#### Version

First we’ll update the version with the [npm version](https://docs.npmjs.com/cli/version) command.

This is a major release so we type:

```
npm version major
```

Which outputs:

```
v2.0.0
```

#### Publish!

Let’s run our new favorite command:

```
npm publish
```

It is done:

```
+ @bamblehorse/tiny@2.0.0
```

### Cool stuff

[Package Phobia](https://packagephobia.now.sh/result?p=%40bamblehorse%2Ftiny) gives you a great summary of your npm package. You can check out each file on sites like [Unpkg](https://unpkg.com/@bamblehorse/tiny@2.0.0/) too.

### Thank you

That was a wonderful journey we just took. I hope you enjoyed it as much as I did.

Please let me know what you thought!

Star the package we just created here:

#### ★ [Github.com/Bamblehorse/tiny](https://github.com/Bamblehorse/tiny)

![](https://cdn-images-1.medium.com/max/800/0*qmkE3zw9beF6fP_0)

“An elephant partially submerged in water.” by [Jakob Owens](https://unsplash.com/@jakobowens1?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)

Follow me on [Twitter](https://twitter.com/Bamblehorse), [Medium](https://medium.com/@Bamblehorse) or [GitHub](https://github.com/Bamblehorse).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
