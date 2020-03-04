> * 原文地址：[Making Logs Colorful in NodeJS](https://medium.com/front-end-weekly/making-logs-colorful-in-nodejs-b26b6cf9f0bf)
> * 原文作者：[Prateek Singh](https://medium.com/@prateeksingh_31398)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/making-logs-colorful-in-nodejs.md](https://github.com/xitu/gold-miner/blob/master/TODO1/making-logs-colorful-in-nodejs.md)
> * 译者：
> * 校对者：

# Making Logs Colorful in NodeJS

![Image Credits: [Bapu Graphics](https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.bapugraphics.com%2Fmultimediacoursetips%2F7-nodejs-tips-and-also-tricks-for-javascript-developers%2F&psig=AOvVaw3ZA2cfk0Y7Q-TxrYBfFgd0&ust=1580829786882000&source=images&cd=vfe&ved=0CAMQjB1qFwoTCMiwnIfYtecCFQAAAAAdAAAAABAD)](https://cdn-images-1.medium.com/max/2000/1*fVkQKafnrC3U6YL7yynPag.jpeg)

Logging is a very important part of any application. It helps us to debug the issues, display important stats using [Splunk](https://en.wikipedia.org/wiki/Splunk) & a lot more. From the very start of our coding days, Logs are our true friends and helps us a lot. So basically Logs are one of the most required aspect of any server-side code architecture. There are many logging libraries available in the market like [Winston](https://github.com/winstonjs/winston), [Loggly](https://www.loggly.com/docs/api-overview/), [Bunyan](https://github.com/trentm/node-bunyan), etc. But when it comes to debugging our APIs or we need to check the value of some variable we simply call our best friend in JavaScript **console.log().** Let’s check some of the examples, How generally people put logs in their codes.

```js
console.log("MY CRUSH NAME");
console.log("AAAAAAA");
console.log("--------------------");
console.log("Step 1");
console.log("Inside If");
```

Why we put logs like this? Is it because we are lazy? No, we put logs like this because we need to differentiate it from other logs printing on the console.

![Image 1](https://cdn-images-1.medium.com/max/2730/1*UdH0W6yGIk3z3ptPrO5nog.png)

For the moment we need only currently added console.log(“Got the packets”) on the terminal and not other logs. Are you able to see the “Got the packets” printed in the logs(Image 1)? I know its difficult to figure out the log. So what to do? How we can make our life easy and logs beautiful.

## Colorful Logs

If I tell you that, these logs can be printed in different & multiple colors at the same time. Life would be much easier, right? Let’s take a look at the next image and try to find the same log “**Got the packets**”.

![Image 2](https://cdn-images-1.medium.com/max/2732/1*yPiqGs3XlYqywqZ0AdoTAg.png)

“**Got the packets**” is now clearly visible in Red color. Isn’t it great? We can put different logs in different colors. I bet this is gonna change your logging style and make it a lot easier. See one more example…

![Image 3](https://cdn-images-1.medium.com/max/2732/1*puJJ71wiSgqCv_h_L4qREg.png)

The newly added log is clearly visible. Now let’s take a look at the implementation of this functionality. We can achieve this by adding the **Chalk** module into our code.

## Install

```bash
npm install chalk
```

## Usage

```js
const chalk = require('chalk');
console.log(chalk.blue('Hello world!'));//Print String in Blue Color
```

You can also customize your own theme and use it like this.

```js
const chalk = require('chalk');

const error = chalk.bold.red;

const warning = chalk.keyword('orange');

console.log(error('Error!'));
console.log(warning('Warning!'));
```

So basically it's like chalk[MODIFIER][COLOR] & we are good to go to print colorful logs in our code 😊. “**Chalk**” module gives us numbers of modifiers and colors to print in.

## Modifier

* `reset` - Resets the current color chain.
* `bold` - Make text bold.
* `dim` - Emitting only a small amount of light.
* `italic` - Make text italic. **(Not widely supported)**
* `underline` - Make text underline. **(Not widely supported)**
* `inverse`- Inverse background and foreground colors.
* `hidden` - It prints the text but makes it invisible.
* `strikethrough` - Puts a horizontal line through the center of the text. **(Not widely supported)**
* `visible`- Prints the text only when Chalk has a color level > 0. It can be useful for things that are purely cosmetic.

## Colors

* `black`
* `red`
* `green`
* `yellow`
* `blue`
* `magenta`
* `cyan`
* `white`
* `blackBright` (alias: `gray`, `grey`)
* `redBright`
* `greenBright`
* `yellowBright`
* `blueBright`
* `magentaBright`
* `cyanBright`
* `whiteBright`

Thanks for reading the article. In the future, I will update you with some of the less-known tricks and tips of JavaScript which will make your development quite easy.

![](https://cdn-images-1.medium.com/max/2000/1*puO9QPsENQ5ww1QKNuf6tw.gif)

> # **Happy Coding || Write to Learn**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
