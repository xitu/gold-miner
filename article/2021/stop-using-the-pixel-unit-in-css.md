> * 原文地址：[Stop Using the Pixel Unit in CSS](https://betterprogramming.pub/stop-using-the-pixel-unit-in-css-8b8788a1301f)
> * 原文作者：[Jose Granja](https://medium.com/@dioxmio)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/stop-using-the-pixel-unit-in-css.md](https://github.com/xitu/gold-miner/blob/master/article/2021/stop-using-the-pixel-unit-in-css.md)
> * 译者：
> * 校对者：

# Stop Using the Pixel Unit in CSS

![Photo by [Alexander Andrews](https://unsplash.com/@alex_andrews?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral).](https://cdn-images-1.medium.com/max/12450/0*5eX8OB4YTWwqM1RV)

Why do web developers use the `px` unit so blindly? It is just a bad habit? Is it because of a lack of knowledge of other units? Maybe because the design teams rely on `px` and `pt` for their mocks? It is unclear why the pixel is the current go-to unit for most teams.

Maybe, the main reason is that it looks simple and convenient. Intuitively, we think we understand this unit because it looks as though it is mapping our pixel screen.

The `px` unit is something that gets you started very easily, but it turns into a problem later down the road. In this article, I will expose the top three reasons to avoid the pixel unit. We will discuss the problems with its usage and some possible solutions.

---

## 1. They Are Just Optical Reference Units

Pixel values are no longer based on a hardware pixel. It just wouldn’t work and will look very different for many screens and resolutions. They are instead based on an optical reference unit. So the part that we found more intuitive about that unit is no longer there.

Hardware is changing by the day and pixel densities are growing. We can’t rely on the assumption that devices have a pixel density of `96dpi`. They are no longer a stable point of reference.

> “Note that if the anchor unit is the pixel unit, the physical units might not match their physical measurements. Alternatively if the anchor unit is a physical unit, the pixel unit might not map to a whole number of device pixels.
>
> Note that this definition of the pixel unit and the physical units differs from previous versions of CSS. In particular, in previous versions of CSS the pixel unit and the physical units were not related by a fixed ratio: the physical units were always tied to their physical measurements while the pixel unit would vary to most closely match the reference pixel. (This change was made because too much existing content relies on the assumption of 96dpi, and breaking that assumption breaks the content.)” — [W3C](https://www.w3.org/TR/2011/WD-css3-values-20110906/)

In summary, it means that the pixel is unreliable. Because of its unreliable nature achieving pixel-perfect layouts might be not possible.

Let’s see the equivalence of 1mm to pixels with different dots-per-inch resolutions:

![mm to pixel on an average Macbook dpi on Pixelcalculator](https://cdn-images-1.medium.com/max/2000/1*xgFl-SLMot8k2KR0HEn4mQ.png)

![mm to pixel on an average iPhone dpi on Pixelcalculator](https://cdn-images-1.medium.com/max/2000/1*qBVYc5fFUBNnzgTMJYHtoQ.png)

Long gone are the days when you could distinguish pixels on our screens. We have grown used to that limitation, and it’s an idea we need to drop. The sense of the word **pixel** has lost its meaning over time, and it’s time to stop making it the default unit in our CSS code.

---

## 2. They Are Absolute Values

Looking at the problem above, why is it happening? Why can’t our layout reach pixel perfection? Because the pixel unit is an absolute one. That means that it is not going to adapt to our browser’s pixel ratio/resolution/size/etc.

Absolute values are normally not very useful if you want to satisfy a broad audience. Is `px` the only absolute unit? No, there are six more absolute units supported by CSS. Find a reference below:

![List of absolute units supported by CSS](https://cdn-images-1.medium.com/max/NaN/1*aXVUdpRMgeFox_6uHkR_SA.png)

That means that if you use those units, your audience will have a wide variety of layout outputs. It is not reasonable to test your page for any kind of resolution it might be displayed into.

How can we solve that problem? How can we make our layout responsive? By using `relative units`. What are those anyway?

> # “Relative length units are relative to something else, perhaps the size of the parent element’s font, or the size of the viewport.” — [MDN Web Docs](https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/Values_and_units)

Let’s check out the most relevant units that we have at our disposal:

![List of relevant relative units available in CSS](https://cdn-images-1.medium.com/max/2000/1*4AZByHrtdOwFI_bDnfMKmQ.png)

You can see that the list of relative units is bigger than the absolute one. Why are there so many?

Each of those has some specific scenarios where it is more suited to be used. Having lots is great news since we know there are a lot of different use cases we can cover. That’s why it becomes important to understand each of them.

Let’s say we want to display one column with a maximum of 20 characters per line.

What are most developers currently doing? Measuring the average length of a character by its font/family/size and weight and multiplying it by 20.

This approach results in a hardcoded pixel value. That means that if the font size changes, you will have to do the calculation again. That approach is just an approximation and won’t work consistently across devices.

What is a better solution? Using the `ch` unit. You can base the target column width on a multiple of the `ch` unit.

Let’s see the code to better understand that:

```HTML
<!DOCTYPE html>
<html>
    <head>
        <title>Units Playground</title>
        <meta charset="UTF-8" />
    </head>
    <body>
        <style type="text/css">
            body {
                color: white;
                text-align: center;
                box-sizing: content-box;
                margin: 1em;
            }

            #container {
                color: white;
                display: grid;
                gap: 1rem;
                grid-template-columns: max-content 1fr;
            }

            #content {
                padding: 1em;
                margin: 0;
                background-color: #5B2E48;
                color: white;
                max-width: 20ch;
            }

            #photo {
                background-color: #CEB992;
            }
        </style>
        <div id="container">
            <p id="content">
                Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum
            </p>
            <div id="photo">
            </div>
        </div>
    </body>
</html>
```

![Example of using the ch unit to design a dynamic content width.](https://cdn-images-1.medium.com/max/2000/1*1K2l3CJ41vA1UMqLOVbp_Q.png)

As you can see above, we are limiting the `max-width` of our `content` to `20ch`.

```
#content {
 ...
 max-width: 20ch;
}
```

The above is just an example. There are many replacements for the pixel unit. Sometimes, you don’t need a relative unit. You can use the power of `flex` and `grid` layouts to adjust your layout accordingly. Not relying on an absolute unit will keep your layouts consistent. It is always preferred to rely on the browser to do all the heavy lifting for us.

---

## 3. Accessibility: They Don’t Adapt to the User’s Default Font Size

Accessibility is a forgotten subject that we all should be paying more attention to. How does the usage of pixel units impact accessibility?

Browsers let you configure your default base `font-size`. By default, it is set to `16px`, but it can be easily changed. That is very useful for people with visual impairment. The browser then gives us a hint about the preferred user’s `font-size` by setting the base `font-size` to that value.

However, if developers use absolute pixel values, that information will be ignored. The base `font-size` won’t have any impact on our application layout. The font size will be the same for all users. That is a bad thing since you are ignoring your user’s preferences and hurting your page’s accessibility.

How can we honor that base font size? By using relative units like `rem` and `em`. What are `rem` and `em`? The `rem` and `em` units are expressing the size of the font relative to the base font for anything from boxes to text. To put it in simple words, it means that your text font sizes will be a multiple of the user’s preferred font size. What is the difference between both?

* `rem` will express it relative to the root `font-size`.
* `em` will express it relative to the element size.

You are not limited to using those units only on the `font-size` property. They can be used anywhere in your CSS elements. That means that you can create an adaptive layout based on the user setup. You can ensure a proper experience for your users.

Let’s check out an example where we will be adapting the whole layout based on the user's base font size. For this particular example, we will be relying on `rem` to design an adaptative layout:

```HTML
<!DOCTYPE html>
<html>
    <head>
        <title>Units Playground</title>
        <meta charset="UTF-8" />
    </head>
    <body>
        <style type="text/css">
            body {
                color: white;
                text-align: center;
                box-sizing: content-box;
            }

            h1 {
                font-size: 1.9rem;
            }

            h2 {
                font-size: 1.5rem;
            }

            p {
                font-size: 1.2rem;
                color: #5B2E48;
            }
            
            .main-article {
                padding: 1em;
                margin: 0;
                background-color: #5B2E48;
                color: white;
                width: 30em;
            }

            .sub-article {
                padding: 1em;
                margin: 0;
                background-color: #CEB992;
                color: white;
                margin-bottom: 1em;
            }
        </style>
        <article class="main-article">
            <h1>Weather forecast for Barcelona</h1>
            <article class="sub-article">
                <h2>10 May 2021</h2>
                <p>Cloudy</p>
            </article>
            <article class="sub-article">
                <h2>11 May 2021</h2>
                <p>Sunny</p>
            </article>
            <article class="sub-article">
                <h2>12 May 2021</h2>
                <p>Sunny</p>
            </article>
        </article>
    </body>
</html>
```

![Side-by-side accessible component using a different font size.](https://cdn-images-1.medium.com/max/2400/1*OHY0OQ7_MXRAbx9J5mmFTg.png)

Note that we have used `rem` for the `padding`, `width`, and `font-size` properties.

```CSS
...
p {
  font-size: 1.2rem;
  color: #5B2E48;
}
.main-article {
  padding: 1em;
  margin: 0;
  background-color: #5B2E48;
  color: white;
  width: 30em;
}
...
```

We can see above how the layout is able to adapt to the user’s browser settings. The fonts are bigger, but so are the articles. They grow to preserve the proportions. Even though they are different in size for different users, they stay consistent in shape.

---

## Bonus Tip

When working with `rem` and `rem` units, you might find it cumbersome to express everything for a default base font of `16px`. There is a very popular trick for that situation:

```
html {
  font-size: 62.5%; /* font-size 1em = 10px on default browser settings */
}
```

Using this trick, now all font sizes will be based on a `10px` factor for a default `16px` base font. It will make your code a bit less messy. It won’t hurt accessibility. It will just make your life a bit easier.

---

## Final Thoughts

We have seen three powerful reasons why we should ditch the pixel unit. Relying on relative units or layout features will ensure that your layout stays consistent across devices and resolutions.

Fortunately, the usage of relative units like `rem` and `em` is growing. Meanwhile, browsers are doing their best to come up with some solutions. When using absolute values, if users are zooming, the browser unit will scale to match the proper zoom applied by the user. Not the perfect experience, but a decent fallback.

I hope this article has given you the last little push to stay as far away from the pixel unit as possible.

---

## Related Articles
[**Grid vs. Flexbox — Which One Should You Use?**
**A journey toward finding the right tool for the right job**betterprogramming.pub](https://betterprogramming.pub/grid-vs-flexbox-which-one-should-you-be-using-471cb955d3b5)
[**7 Habits of Productive Developers**
**Build the right habits to stay productive on a daily basis**betterprogramming.pub](https://betterprogramming.pub/7-habits-of-productive-developers-bce60d880907)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
