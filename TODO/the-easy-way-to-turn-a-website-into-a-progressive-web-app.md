> * 原文地址：[The easy way to turn a website into a Progressive Web App](https://dev.to/pixeline/the-easy-way-to-turn-a-website-into-a-progressive-web-app-77g)
> * 原文作者：[Alexandre Plennevaux](https://dev.to/pixeline)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/the-easy-way-to-turn-a-website-into-a-progressive-web-app.md](https://github.com/xitu/gold-miner/blob/master/TODO/the-easy-way-to-turn-a-website-into-a-progressive-web-app.md)
> * 译者：
> * 校对者：

## What is a Progressive Web App?

Basically, a PWA is a website that, when visited on a mobile phone, can be saved on the user's device and thus feels and behaves just as a Native application. There is a loading screen, you get to remove the chrome UI ,and, should the connection drop, it still displays content. Best of all it boosts user engagement : if Android's Chrome browser (not sure about other mobile browsers) detects that the website is a PWA, it prompts the user to save it on its device's homescreen using the icon of your choice.

## Why is it important?

**PWA are good for your client's business**. Alibaba, the Chinese Amazon, notices a 48% increase in user engagement thanks to the browser's prompt to "install" the website ([source](https://developers.google.com/web/showcase/2016/alibaba)).

This makes the effort totally worth fighting for!

This bounty is possible thanks to a technology called **Service Workers** that allows you to save static assets in the user system (html,css, javascript,json...), alongside a `manifest.json` that specifies how the website should behave as an installed application.

## Examples

These were made by me using the same technique described here.

* [plancomptablebelge.be](https://plancomptablebelge.be) (a single-page website)
* [didiermotte.be](https://didiermotte.be) (a WordPress-based website)

Many more examples are available here : [pwa.rocks](https://pwa.rocks)

## Setup

Turning a website into a PWA may sound complicated (Service workers whaaaat ?), but it's not that difficult.

### 1. requirement: https instead of http

The hardest part is that it will only work on a website running on a secure domain (behind **https**:// instead of http://).
These are usually very hard to set up manually, but thanksfully, if you have your own server, you can use [letsencrypt](https://letsencrypt.org/) to make that super easy and automatic. And... FREE.

### 2. Tools

#### 2.1 lighthouse test

* the [lighthouse test](https://developers.google.com/web/tools/lighthouse/) is an automated test created and maintained by Google that test websites against three criteria : Progressive, Performance, Accessibility. It gives a score in percent for each, and advises on how to solve each issue. It's a great learning tool. ![Lighthouse test result for didiermotte.be](https://res.cloudinary.com/practicaldev/image/fetch/s--DigZaUAj--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://www.dropbox.com/s/rwfesahj7haglsc/Capture%2520d%2527%25C3%25A9cran%25202017-11-21%252010.03.29.png%3Fdl%3D1)
* [realfavicongenerator.net](https://realfavicongenerator.net)
* the [UpUp.js library](https://www.talater.com/upup/getting-started-with-offline-first.html)

#### 2.2 realfavicongenerator.net

[realfavicongenerator.net](https://realfavicongenerator.net) takes care of the visual layer of your PWA. It generates the manifest.json file mentioned above, alongside all the versions of your icons necessary when saving the website onto any mobile device, and an html snippet to add to your page's `<head>` tag.
**ADVISE**: although RFG offers you to put your assets in a subfolder, it will make it a lot harder to enable the PWA. So, keep it simple and put all images and manifest in the root folder of your website.

#### 2.3 service workers, via upup.js

Service Workers is a javascript technology. I found it hard to grasp for my tired and impatient brain, but luckily, [a smart girl from Germany](https://vimeo.com/103221949) pointed me to [Tal Atler](https://twitter.com/TalAter), wanting to push forward the "Offline First" philosophy, created a javascript library that makes it _über_ easy to make your website behave nicely when the connexion drops. _danke schön, Ola Gasidlo !_

Just do the quick [UpUp tutorial](https://www.talater.com/upup/getting-started-with-offline-first.html) and you're good to go.

### 3. Methodology

1. Use Realfavicongenerator and generate the html and image code. Add them to your website code.
2. Publish on your https domain.
3. Do the lighthouse test.
4. Analyse results.
5. Fix each issue one by one.
6. Go back to 3, rince and repeat.
7. Iterate until you get as close to 100 everywhere, and 100 in "Progressive".
8. Test on your mobile phone and see what happens. With chance, on Android you'll see a popup at the bottom, inviting you to save the website onto your phone homescreen! ![](https://res.cloudinary.com/practicaldev/image/fetch/s--YezWkN00--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://github.com/becodeorg/Lovelace-promo-2/raw/master/Parcours/PWA%2520-%2520progressive%2520web%2520apps/assets/add-to-homescreen.jpg)

## Deeper into the rabbit hole...

You can find all the information you need on PWA in this book:

[Building Progressive Web Apps

![](https://res.cloudinary.com/practicaldev/image/fetch/s--joTnFRw3--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://images-na.ssl-images-amazon.com/images/I/51xL1wjYrHL._SX379_BO1%2C204%2C203%2C200_.jpg)](https://www.amazon.fr/_/dp/1491961651?tag=oreilly20-20).

That's it! Happy PWA-ing!


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
