> * 原文地址：[Auto-Generated Social Media Images](https://css-tricks.com/auto-generated-social-media-images/)
> * 原文作者：[Chris Coyier](https://css-tricks.com/author/chriscoyier/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/auto-generated-social-media-images.md](https://github.com/xitu/gold-miner/blob/master/article/2021/auto-generated-social-media-images.md)
> * 译者：
> * 校对者：

# Auto-Generated Social Media Images

I’ve been thinking about social media images [again](https://css-tricks.com/tag/social-media-images/). You know, the images that (can) show up when you share a link in places like Twitter, Facebook, or iMessage. You’re essentially leaving money on the table without them, because they turn a regular post with a little ol’ link in it into a post with a big honkin’ attention grabbin’ image on it, with a massive clickable area. Of any image on a website, the social media image might be the #1 most viewed, most remembered, most network-requested image on the site.

It’s essentially this bit of HTML that makes them happen:

```html
<meta property="og:image" content="/images/social-media-image.jpg"/>
```

But make sure to [read up on it](https://css-tricks.com/essential-meta-tags-social-media/) as there are a bunch other other HTML tags to get right.

I think I’m thinking about it again because GitHub seems to have new social media cards. These are new, right?

![](https://i0.wp.com/css-tricks.com/wp-content/uploads/2021/05/Screen-Shot-2021-05-06-at-10.14.23-AM.png?resize=1024%2C952&ssl=1)

[tweet](https://twitter.com/ladyleet/status/1390353733868040196)

![](https://i0.wp.com/css-tricks.com/wp-content/uploads/2021/05/Screen-Shot-2021-05-07-at-10.01.09-AM.png?resize=878%2C1024&ssl=1)

[tweet](https://twitter.com/erikkroes/status/1389889553872392192)

Those GitHub social media images are clearly programmatically generated. Check out [an example URL](https://opengraph.githubassets.com/f55622dadf147f30f9a583a9be18924ac4567e2f8169cab9af601ecb204ec77f/fempire/resources).

### Automation

While I think you can get a lot of bang out of a totally hand-crafted bespoke-designed social media image, that’s not practical for sites with lots of pages: blogs, eCommerce… you know what I mean. The trick for sites like that is to automate their creation via templating somehow. I’ve mentioned other people’s takes on this in the [past](https://css-tricks.com/social-cards-as-a-service/), but let’s recap:

* Drew McLellan: [Dynamic Social Sharing Images](https://24ways.org/2018/dynamic-social-sharing-images/)
* Vercel: [Open Graph Image as a Service](https://og-image.vercel.app/)
* Phil Hawksworth: [social-image-generator](https://github.com/philhawksworth/social-image-generator)
* Ryan Filler: [Automatic Social Share Images](https://www.ryanfiller.com/blog/automatic-social-share-images/)

You know what all those have in common? [Puppeteer](https://github.com/puppeteer/puppeteer).

Puppeteer is a way to spin up and control a headless copy of Chrome. It has this [incredibly useful feature](https://pptr.dev/#?product=Puppeteer&version=v5.2.1&show=api-pagescreenshotoptions) of being able to take a screenshot of the browser window: `await page.screenshot({path: 'screenshot.png'});`. That’s how [our coding fonts website does the screenshots](https://github.com/chriscoyier/coding-fonts/blob/master/takeScreenshots.js). The screenshotting idea is what gets people’s minds going. Why not design a social media template in HTML and CSS, then ask Puppeteer to screenshot it, and use *that* as the social media image?

I love this idea, but it means having access to a Node server (Puppeteer runs on Node) that is either running all the time, or that you can hit as [a serverless function](https://serverless.css-tricks.com/services/functions). So it’s no wonder that this idea has resonated with the Jamstack crowd who are already used to doing things like running build processes and leveraging serverless functions.

I think the idea of “hosting” the serverless function at a URL — and passing it the dynamic values of what to include in the screenshot via URL parameter is also clever.

### The SVG route

I kinda dig the idea of using SVG as the thing that you template for social media images, partially because it has such fixed coordinates to design inside of, which matches my mental model of making the exact dimensions you need to design social media images. I like [how SVG is so composable](https://css-tricks.com/swipey-image-grids/).

George Francis blogged [“Create Your Own Generative SVG Social Images”](https://georgefrancis.dev/writing/generative-svg-social-images/) which is a wonderful example of all this coming together nicely, with a touch of randomization and whimsy. I like the `contenteditable` trick as well, making it a useful tool for one-off screenshotting.

I’ve dabbled in dynamic SVG creation as well: check out [this conference page](https://conferences.css-tricks.com/conferences/2021-magnoliajs/) on our Conferences site.

![](https://i2.wp.com/css-tricks.com/wp-content/uploads/2021/05/CleanShot-2021-05-07-at-10.13.36@2x.png?resize=724%2C719&ssl=1)

![](https://i2.wp.com/css-tricks.com/wp-content/uploads/2021/05/CleanShot-2021-05-07-at-10.13.36@2x.png?resize=724%2C719&ssl=1)

Unfortunately, SVG isn’t a supported image format for social media images. Here’s Twitter specifically:

> URL of image to use in the card. Images must be less than 5MB in size. JPG, PNG, WEBP and GIF formats are supported. Only the first frame of an animated GIF will be used. SVG is not supported.
>
> [Twitter docs](https://developer.twitter.com/en/docs/twitter-for-websites/cards/overview/markup)

Still, composing/templating in SVG can be cool. You convert it to another format for final usage. Once you *have* an SVG, the conversion from SVG to PNG is almost trivially easy. In my case, I used [svg2png](https://www.npmjs.com/package/svg2png) and [a very tiny Gulp task](https://github.com/CSS-Tricks/conferences/blob/master/tasks/svg2png.js) that runs during the build process.

### What about WordPress?

I don’t have a build process for my WordPress site — at least not one that runs every time I publish or update a post. But WordPress would benefit *the most* (in my world) from dynamic social media images.

It’s not that I don’t have them now. [Jetpack goes a long way](https://jetpack.com/support/social/?aff=8638) in making this work nicely. It makes the “featured image” of the post the social media image, allows me to preview it, and auto-posts to social networks. [Here’s a video I did on that.](https://www.youtube.com/watch?v=WEKRuohH43A) That’s gonna get me to a place where the featured images are attached and showing nicely.

![](https://i1.wp.com/css-tricks.com/wp-content/uploads/2021/05/Screen-Shot-2021-05-07-at-12.12.12-PM.png?resize=567%2C533&ssl=1)

But it doesn’t automate their creation. Sometimes a bespoke graphic alone is the way to go (the one above might be a good example of that), but perhaps more often a nicely templated card is the way to go.

Fortunately I caught wind of [Social Image Generator](https://socialimagegenerator.com/) for WordPress from Daniel Post. Look how fancy:

![](https://github.com/PassionPenguin/gold-miner-images/blob/master/auto-generated-social-media-images-editor.gif?raw=true)

This is exactly what WordPress needs!

Daniel himself helped me create a custom template just for CSS-Tricks. I had big dreams of having a bunch of templates to choose from that incorporate the title, author, chosen quotes, featured images, and other things. So far, we’ve settled on just two, a template with the title and author, and a template with a featured image, title, and author. The images are created from that metadata on the fly:

![](https://i1.wp.com/css-tricks.com/wp-content/uploads/2021/05/Screen-Shot-2021-05-10-at-4.49.26-PM.png?resize=369%2C452&ssl=1)

So meta.

This ain’t Puppeteer. This ain’t even the PhantomJS powered svgtopng. This is PHP generated images! And not even [ImageMagick](https://imagemagick.org/index.php), but [straight up GD](https://www.php.net/manual/en/intro.image.php), the thing built right into PHP. So these images are not created in any kind of syntax that would likely feel comfortable to a front-end developer. You’re probably better off using one of the templates, but if you wanna see how my custom one was coded (by Daniel), lemme know and I can post the code somewhere public.

Pretty cool result, right?

![](https://i1.wp.com/css-tricks.com/wp-content/uploads/2021/05/Screen-Shot-2021-05-12-at-3.39.02-PM.png?resize=558%2C484&ssl=1)

[Tweet](https://twitter.com/css/status/1391758245178511366)

I get why it had to be built this way: it’s using technology that will work literally anywhere WordPress can run. That’s very much in the WordPress spirit. But it does make me wish creating the templates could be done in a more modern way. Like wouldn’t it be cool if the template for your social media images was just like `social-image.php` at the root of the theme like any other template file? And you template and design that page with all the normal WordPress APIs? Like an [ACF Block](https://www.advancedcustomfields.com/resources/blocks/) almost? And it gets screenshot and used? I’ll answer for you: Yes, that would be cool.


> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
