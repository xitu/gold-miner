> * 原文地址：[HEX vs RGB vs HSL: What is the Best Method to set CSS Color Property](https://blog.bitsrc.io/hex-vs-rgb-vs-hsl-what-is-the-best-method-to-set-css-color-property-f45d2debeee)
> * 原文作者：[Nethmi Wijesinghe](https://medium.com/@wnethmi96)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/hex-vs-rgb-vs-hsl-what-is-the-best-method-to-set-css-color-property.md](https://github.com/xitu/gold-miner/blob/master/article/2021/hex-vs-rgb-vs-hsl-what-is-the-best-method-to-set-css-color-property.md)
> * 译者：
> * 校对者：

# HEX vs RGB vs HSL: What is the Best Method to set CSS Color Property

## HEX vs RGB vs HSL: What is the Best Method to set CSS Color Property?

#### The pros and cons of different color formats

![](https://cdn-images-1.medium.com/max/5760/1*fjzP30im_c--lgsIKqhj0g.jpeg)

Do you know the difference between HEX, RGB, and HSL and why someone wants to use one or the other?

---

Before diving into that question, let’s get a brief idea of what each color method is about.

## The Definitions

**Hex** color values are among the most popular ways to set CSS color properties, especially among developers. It is supported in almost all browsers.

We can define the color Purple in the Hex color code as follow:

```
#800080
```

Here the color is specified in the #RRGGBB format where RR (Red), GG (Green), and BB (Blue) are hexadecimal integers between 00 and FF, indicating the intensity of the color.

## The Difference Between HEX and RGB

**RGB** or **Red/Green/Blue** is another well-liked method used to define color properties in CSS. RGB color scheme is a three-channel format containing the amount of Red, Green, and Blue as an integer between 0 and 255. Following is an example of RGB color:

```
rgb(128, 0, 128)
```

This is the RGB code for the same color we specified using the Hex color code above. You might be wondering why we would even use RGB because the Hex color code is much easier to remember and type out.

> # Well, each color method has there own benefits. The beauty of RGB is that it allows you to add opacity to your color.

This is where the **RGBA** comes into the scene 😎. In CSS 3, an additional channel has been added to the RGB color scheme called **alpha** to indicate the opacity of a color.

## The New Comer, HSL!

**HSL,** which stands for Hue Saturation and Lightness, is another way of declaring colors in CSS. HSL color value for the Purple color can be specified as follow:

```
hsl(300, 100%, 25.1%)
```

As you can see, the first parameter is used to define the **Hue**, which is the value of the actual pure color, such as Red, Yellow, Green, Blue, Magenta, and so on, as represented on a color wheel. The values are in degrees, from 0 to 360. Here 0 and 360 degrees are for the color Red, 120 degrees is Green, and 240 degrees is for Blue.

Unlike in RGB, in HSL, both the Saturation and Lightness of a color can change.

And these colors can be dull or vivid. The less of the color there is, the more it turns into a shade of grey. **Saturation** is how much of the color is present in the mix, and it ****controls how vivid or dull a color is.

![Saturation demonstrated using the [HSL Color Picker by Brandon Mathis](https://hslpicker.com/#ff5100)](https://cdn-images-1.medium.com/max/2044/1*-eXO8dohWa8I60_Qo-AKyQ.gif)

As you can see, when the value of Saturation is changing from 100% to 0% along the line, the color changes from a pure hue to a dull hue.

Moreover, the third parameter, **Lightness,** is again a percentage value, from 0% to 100%, which describes how much black or white exists in color.

![Lightness demonstrated using the [HSL Color Picker by Brandon Mathis](https://hslpicker.com/#ff5100)](https://cdn-images-1.medium.com/max/2000/1*1s0MaASIXSV9vJw6oFvjgg.gif)

This is similar to the use of watercolors in painting. If you want to make a color lighter, you can add white, and if you’re going to make it darker, you can add black. Therefore, 100% Lightness means completely white, 50% means the actual hue color, and 0% is pure black.

Similar to the RGBA, **HSLA** is an extension of HSL, which carrying out a fourth channel named alpha to represent the opacity of a color. Opacity specifies in a decimal value as it does in RGBA, where 1 represents the complete opaqueness, 0 illustrates fully transparent, and everything in between is partially opaque.

However, although RGB and Hex color codes are supported in most browsers, HSL colors are mainly supported in HTML5 based browsers.

---

You might have used all or some of these methods to set color properties in CSS. Hex is my personal favorite, but are there any advantages in using one method over the other? Without further ado, let’s find it out!

## Tip: Build & share independent components with Bit

[**Bit**](https://bit.dev/) is an extensible tool that lets you create **truly** modular applications ****with **independently** authored, versioned, and maintained components.

Use it to build modular apps & design systems, author and deliver micro frontends, or simply share components between applications.

---

![A React ‘card’ component independently developed and source-controlled with an auto-generated dependency tree.](https://cdn-images-1.medium.com/max/3840/0*rxoHrIUo9BcOkekb.png)

## What is the Best Way to Specify Colors in CSS?

If you’re used to HTML, you might probably more comfortable using Hex color values since it has been used a lot in HTML. But if you’re from a designing background, you’re likely to use the RGB notation because it is the most commonly used format in most design software like Photoshop, Corel, and Illustrator.

What I recommend is, if you’re a pure developer and just want to get your project finished, go ahead and use the color notation you’re most familiar with.

> # Because the browser doesn’t really care about which color format you’re using, even though there are minor performance changes between the different methods, the performance difference is negligible.

Other than that, if you’re worried about the usability, decision’s effect on the developer(s), and so on, let’s see what method suits best to your situation.

Let’s start with the Hex notation. Hex is very attractive due to its short and simple notation. Many developers find Hex values quite simple to read and easier to copy to their preferred text editor than RGB and HSL.

However, Hex might not work well in every situation. Especially when you need to change the opacity level of the color, you might have to consider one of the other two methods. Both of them have their pluses and minuses.

> # When it comes to animating the colors, RGB and HSL are preferable over Hex, and their additional channel for alpha value comes in handy when you want to play with the opacity of a color.

In addition to that, RGB is well known and supported in older versions of Internet Explorer (9 and older).

#### HSL is meant to be More Human Understandable!

Formats like RGB and Hex are more machine-readable than human-readable. HSL, the opposite, is meant to be understandable by humans better. HSL is a more recent and spontaneous way to work with colors.

> # Unlike in Hex and RGBA, where you have to meddle with some numbers to get the color you want, in HSL, we can define the color using the Hue and play with the second and third parameter percentages to get the saturation and lightness levels you need.

If I told you the web page heading needs to be `#578557` or `rgb(87, 133, 87)`, can you guess what the color could be? 😵 Nope, not unless you’re a computer. But, at the same time, if I give you the color in HSL: `hsl(120, 21%, 43%)`? Now the guessing is kind of easy right? The Hue value is 120°, meaning it is pure Green. Next, it is 61% saturated, indicating that it is 21 steps from being the dull grey, a pretty desaturated green. Then Lightness 43% means the color is seven steps to the darker side from the pure color.

Okay, think you want to make the button color lighter on hover and a bit darker on a click. It’s a snap of a finger with HSL. Just increase and decrease the value of lightning, and that’s all. AWESOME!! 😎 But doing this with Hex or RGB without using a tool or a designer’s help is impossible.

> # HSL is an intuitive color notation that mimics the real world.

For example, let’s consider a light blue color paper. Its color values in three formats would be:

```
Hex: #ADD8E6;
RGB: rgb(173, 216, 230);
HSL: hsl(195, 53.3%, 79%);
```

Okay, now hold your hand like a couple of inches above the surface. The shadow of your hand made the surface bit darker, right? It is impossible to represent this change in color using RGB or Hex notations without changing the color itself. But in HSL, just tweak the Lightness value a bit, and BAM! 💥You don’t need to make any changes to the original color. Isn’t it really cool?

```
OLD VALUES                    NEW VALUES 
Hex: #4f2017 ------------------> #2F819D;
RGB: rgb(79, 32, 23) ----------> rgb(47, 129, 157);
HSL: hsl(195, 53.3%, 79%) -----> hsl(195, 53.3%, 50%);
```

---

As you can see, Hex and RGB values have completely changed, whereas, in HSL, only one aspect has changed. HSL is, without a doubt, the most useful when building a color scheme. Start with the base color, and just tweak the saturation and lightness as needed, and that’s it! With HSL building a color scheme, all by yourself is a piece of cake. 😋

#### Ultimately, It all Comes Down to the Personal Preference!

Now you might think HSL is the best color notation to use. However, as I have mentioned above, HSL isn’t supported by the older versions of Internet Explorer. Likewise, every color notation has its pros and cons. The thing is, it doesn’t matter too much.

> # The most important thing is to keep consistency in the type you’re using in a project as much as possible because it helps productivity.

Although the Hex has the limitation of not supporting transparency and RGBA, it is challenging to adjust colors without using a specific tool, and HSLA is not supported in older browsers; if provided, it’s not a special case; you can go with any format. You can consider the following factors when choosing the best method to set CSS color properties in your project.

1. Use the same format which the rest of your dev team use to ease the maintainability.
2. Use RGB if you’re already familiar with that format.
3. Use Hex if your target visitors use severely outdated browsers to view your site or use a fallback code like below:

```
p { 
    color: #FF0000;
    color: hsla(0, 100%, 50%, 1);
}
```

---

4. If the first three points don’t take you in any other direction, use HSLA. HSLA allows you to have transparency like RGBA but in a way that is human accessible.

#### What are the Alternatives?

Apart from the methods mentioned above, there are few other methods that you can use to set color properties in CSS.

* **Using color names**: all the modern browsers support 140 standard CSS color names. A color name is a keyword representing a specific color, like `coral`.
* `**currentcolor**` **keyword**: if you need to refer to the color of an element, you can use this keyword.
* **HWB values:** HWB stands for Hue, Whiteness, Blackness. Although it’s not currently supported in HTML, it is suggested as a new standard inCSS4.
---

* **CMYK values**: CMYK is a combination of colors Cyan, Magenta, Yellow, and Black. Although computer screens use RGB values to display colors, printers often present colors using CMYK color values. Similar to HWB, CMYK is not supported in HTML yet but is suggested as a new standard in CSS4.

#### Final Words

Colors play a vital role in a webpage. In CSS, we use methods like RGB, Hex, and HSL to define colors. In this article, I’ve discussed the main three methods used to set color properties in CSS, their differences, their pluses and minuses, and other alternative ways which you can use to define color properties in CSS.

> # Although HSLA has a minor edge over the other two methods due to its human readability, it doesn’t matter if it’s not for a particular case. And you can use any way you’re comfortable with.

Looking at the different pros and cons, each method has over the other, in summary, the decision on which way you’re going to use on setting the color properties in CSS should depend on the following three factors:

* Preference
* Maintainability
* Performance

So, what do you prefer to use to set colors in CSS? Hex, RGBA, HSLA, or something else? and Why? Let me know in the comments section. 😃

---

See you again in another exciting article. Until then, happy coding! 💻

## Read More
[**Building a React Design System for Adoption and Scale**
**Achieve DS scale and adoption via independent components and a composable architecture — with examples.**blog.bitsrc.io](https://blog.bitsrc.io/building-a-react-design-system-for-adoption-and-scale-1d34538619d1)
[**How to Set Up Airbnb Style Guide for React Projects**
**Create your own Airbnb Style Guide ESLint / Prettier setup for React Projects**blog.bitsrc.io](https://blog.bitsrc.io/how-to-set-up-airbnb-style-guide-for-react-projects-fc7dfb1f3d68)
[**5 Ways to Improve UI Consistency**
**Useful developer workflows and tools for maintaining UI consistency across screens and apps.**blog.bitsrc.io](https://blog.bitsrc.io/5-ways-to-improve-ui-consistency-99013bf20417)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
