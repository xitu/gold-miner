> * 原文地址：[Basic Color Theory for Web Developers](https://dev.to/nzonnenberg/basic-color-theory-for-web-developers-15a0)
> * 原文作者：[Nicole Zonnenberg](https://dev.to/nzonnenberg)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/basic-color-theory-for-web-developers.md](https://github.com/xitu/gold-miner/blob/master/TODO1/basic-color-theory-for-web-developers.md)
> * 译者：
> * 校对者：

# Basic Color Theory for Web Developers

You would be hard-pressed to find an art class without a color wheel hanging somewhere on its walls. If you’ve ever taken an art class, you might have been introduced to paints and mixing paints by creating one of your own.

[![](https://res.cloudinary.com/practicaldev/image/fetch/s--OE8uCwmx--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/cgr160zn3evkbry9h3l7.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--OE8uCwmx--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/cgr160zn3evkbry9h3l7.png)

You would have learned about _primary_ and _secondary_ colors. Maybe even _tertiary colors_ if you continued to take art after elementary school.

[![](https://res.cloudinary.com/practicaldev/image/fetch/s--jDnCmgm0--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/h1li6xy7lsolpx1pfd7y.jpg)](https://res.cloudinary.com/practicaldev/image/fetch/s--jDnCmgm0--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/h1li6xy7lsolpx1pfd7y.jpg)

But unless you studied art in any capacity at a high school level or higher, you probably did not realize that the color wheel is the simplest way to demonstrate [color theory](https://en.wikipedia.org/wiki/Color_theory), the practice of mixing colors and the study of specific color combinations.

## But what _is_ color theory?

**A brief history**: Color theory emerged when impressionists like Edouard Manet, Edgar Degas, and Claude Monet (you might have heard of them) started experimenting with capturing _light_ rather than a perfect likeness.

[![](https://res.cloudinary.com/practicaldev/image/fetch/s--8liyegSH--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/qg743mrylv8mon76b4z0.jpg)](https://res.cloudinary.com/practicaldev/image/fetch/s--8liyegSH--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/qg743mrylv8mon76b4z0.jpg)  

_Monet's Haystacks_

**Short answer**: It comes down to how the human eye translates light waves into colors. Colors that match have similar or complementary waves.

Color theory can get into the science of light waves, and why colors look the way they do. For the purposes of this article however, we are going to focus on the questions:

*   Why do certain colors match?
*   How do I pick the "right" colors?

Color matching seems to be a "you either have it or you don't" kind of thing. Or the longest, most excruciating part of designing a webpage or an app is determining which exact green to use for your background.

Whatever your color-related woes are, here's a little cheat sheet to look at:

## Level One: Monochromatic

**Monochromatic** is simply one or various shades of one color.

> **In WebDev**: This is choosing a single [Hex Code](https://www.w3schools.com/colors/colors_picker.asp) and making it lighter or darker without effecting the hue.

[![](https://res.cloudinary.com/practicaldev/image/fetch/s--T_AVlepc--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/48ktxlwm7qq095mkwuoa.jpg)](https://res.cloudinary.com/practicaldev/image/fetch/s--T_AVlepc--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/48ktxlwm7qq095mkwuoa.jpg)

This is the simplest way to color your webpage. Sites such as [Facebook](http://facebook.com) and [Twitter](http://twitter.com) use the (mostly) monochromatic color scheme to their advantage. Black, white, and a sky blue, this color palette is part of what makes these social media apps so easy to use.

The only differentiating colors come from users' avatars, links and photos, which can become recognizable to frequent users, making it easy to find posts by their favorite accounts.

If there were more colors on Twitter's webpage, it would be harder to differentiate separate posts and who posted what.

As a rule, even if you want more than one color, it's good to have one main color--either as the background color or the main header color.

> **Pro-Tip**: If your webpage is only monochromatic make sure each shade is easily discernible from one another. Otherwise your webpage may not be user friendly if they cannot read text or separate the webpage's elements.

## Level Two: Complementary Colors

But what if you want more than just different shades of orange? What if you want your links to stand out but not clash with the nav bar or the background color?

If we're following basic color theory, one of the best ways to choose a color for immediate emphasis is to look for a **complementary** color.

A **complementary** color of another can be found at the exact opposite of side of the color wheel.

[![](https://res.cloudinary.com/practicaldev/image/fetch/s--laijYZC7--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/3fj00kbhg6s8nqpm3ut9.jpg)](https://res.cloudinary.com/practicaldev/image/fetch/s--laijYZC7--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/3fj00kbhg6s8nqpm3ut9.jpg)

Each **primary** color matches with one **secondary** color for their complementary color. An easy way to remember which colors to match is that the **secondary** color matches with the **primary** color it does not use. For example: red's complementary color is green, which is made out of blue and yellow.

> **Pro Tip**: Add colors one at time and keep it simple. Do not sacrifice a clean, usable layout for a full rainbow. Otherwise you might accidentally channel the classic 90s websites like [this](https://spacejam.com/).

## Leveling Up

As you get more comfortable with your burgeoning design skills, feel free to push the envelope. Color should never be scary work to with. Always be on the look out for [developers](https://www.alispit.tel/#/) and designers who utilize color masterfully. Ask what you like about it, what you don't like, and why. This is how you build your own tastes and brand.

## WebDev Hack

Create color combinations/palettes with their hex codes/RBG numbers on hand. Or if you're a fan of SASS, store them in files to import on bigger projects. Especially if your job is to create the structure, not the look (which is determined by someone else, a customer or manager), then just view these colors as place holders that make the website easy to look at.

Just make sure:

*   Everything is readable.
*   Links, headers, anything you want to put emphasis on is obviously different from plain text.
*   A user can easily discern different parts of your webpage (i.e. the nav bar, main content, separate the articles, etc.).

## Online Tools

*   [Palleton.com](http://paletton.com/)
*   [Coolors.co](https://coolors.co/)

Shout out to [Doug R. Thomas, Esq.](https://dev.to/ferkungamaboobo) for the following links:

*   [Color.Adobe.com](https://color.adobe.com/)
*   [WebAIM - Color Contrast Checker](https://webaim.org/resources/contrastchecker/) \- makes sure that text is readable over backgrounds.
*   [Coblis — Color Blindness Simulator](https://www.color-blindness.com/coblis-color-blindness-simulator/) - tests screenshots of layout with colorblindness filters to make sure your content is readable for all audiences.

## Continued Reading

Hopefully picking a color or a color palette for your website, page, or app is less daunting after reading this article. If this topic interests you, I highly recommend [reading more](https://www.colormatters.com/color-and-design/basic-color-theory) about the subject. We've only really touched the surface, but you can get into [hues and shades and more](https://99designs.com/blog/tips/the-7-step-guide-to-understanding-color-theory/).

Ultimately, there is no “wrong” answer when it comes to color, especially if you are making a project for yourself. Many assume taste is something you’re born with, but really it’s looking at successful designs and taking inspiration, trying different combinations, and finding what works best for you and your brand. Good luck and go create!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
