> * 原文地址：[Top 3 CSS Grid Features To Start Using in Production](https://medium.com/better-programming/top-3-css-grid-features-to-start-using-in-production-b0fe59b2e0f7)
> * 原文作者：[Jose Granja](https://medium.com/@dioxmio)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/top-3-css-grid-features-to-start-using-in-production.md](https://github.com/xitu/gold-miner/blob/master/article/2021/top-3-css-grid-features-to-start-using-in-production.md)
> * 译者：
> * 校对者：

# Top 3 CSS Grid Features To Start Using in Production

#### A deep dive into some of the widely supported CSS Grid features

![Photo by [Sigmund](https://unsplash.com/@sigmund?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/8096/0*mWiTIfu6BVlYQ5lf)

Grid was initially drafted by the Microsoft team and shipped to Internet Explorer 10 in 2011. After nearly nine years, we now can say that its browser support is becoming good enough that we can use it in production.

We will have a look at the top three features with solid browser support. Even though there are some cool new features like `subgrid` be mindful not to use those in production. It’s always a good practice to check [Can I Use](https://www.caniuse.com) before shipping anything.

---

## A brief refresher

What is a Grid anyway? Grid is a multi-dimensional layout system that is container-centric. In short words: It can grow in any x/y direction, and all the layout information is stored in the parent node. The children mostly hold information on how to position themselves on the grid.

![one-dimensional layout vs. two-dimensional layout](https://cdn-images-1.medium.com/max/2000/1*6YeEVVXSRcJwnZBHo2EgpQ.png)

When developing with Grid, it’s advisable to use Firefox Browser. Its developer tools are better than any of its competitors. It’s the browser with the best Grid support. It’s the only Browser with the `subgrid` implementation currently.

Let’s now deep dive into the top three production-ready CSS Grid features.

---

## 1. Grid Template Areas

This is my all-time favorite CSS Grid feature. It lets you define the grid layout in a declarative manner.

You can create a quite complex and responsive layout with just a few CSS lines:

```HTML
<!DOCTYPE html>
<html>

<head>
    <title>Grid Playground</title>
    <meta charset="UTF-8" />
</head>

<body>
    <style type="text/css">
        body {
            color: white;
            text-align: center;
        }

        #grid {
            background-color: #73937E;
            height: calc(100vh - 20px);
            display: grid;
            grid-template-rows: 1fr 3fr 1fr;
            grid-template-areas:
                "navigation navigation navigation navigation"
                "left content content right"
                "footer footer footer footer";                    
        }

        @media screen and (max-width: 700px) {
            #grid {
                grid-template-rows: 1fr 3fr 1fr 1fr 1fr;
                grid-template-areas:
                    "navigation"
                    "content"
                    "left"
                    "right"
                    "footer";
            }
        }

        .navigation {
            padding: 10px;
            background-color: #471323;
            grid-area: navigation;
        }

        .content {
            padding: 10px;
            background-color: #5B2E48;
            grid-area: content;
        }

        .left {
            padding: 10px;
            background-color: #585563;
            grid-area: left;
        }

        .right {
            padding: 10px;
            background-color: #585563;
            grid-area: right;
        }
        
        .footer {
            padding: 10px;
            background-color: #CEB992;
            grid-area: footer;
        }
    </style>
    <div id="grid">
        <div class="navigation">Nav</div>
        <div class="left">Left</div>
        <div class="content">Content</div>
        <div class="right">Right</div>
        <div class="footer">Footer</div>
    </div>
    </script>
</body>

</html>
```

![Complex grid layout](https://cdn-images-1.medium.com/max/2000/1*kxxETOv_yi4ECBfYz_D-mw.png)

All the magic happens in `grid-templates-areas` and `grid-area`. The former defines all the grid tracks and the latter just positions the grid elements on those areas.

Tip: A grid track is a space between two grid lines.

Let’s check it out with the Firefox inspector to get a clear view of the grid layout we created.

![Internals of the Grid layout](https://cdn-images-1.medium.com/max/2090/1*U9o4_M-wfMeBHindl1H4sw.png)

If we want some empty spacing around the content instead of the right/left column, we can just use `.` / `...` notation.

```
#grid {
  background-color: #73937E;
  height: calc(100vh - 20px);
  display: grid;
  grid-template-rows:1fr 2fr 1fr;
  grid-template-areas:
    "navigation navigation navigation navigation"
    ". content content ."
    "footer footer footer footer";
}
```

![Defining empty grids to the left and right of content div](https://cdn-images-1.medium.com/max/2074/1*frMRKP1wKAGbxlAuQVI_SQ.png)

Note: There are a couple of things you need to pay attention to when using grid areas:

* You can only define each area name once. If cells with the same area name are not connected, they will count as two declarations.
* Grid area cells must form a rectangle. If not, the declaration is invalid.

```
// Example of an invalid Grid
#grid {
  background-color: #73937E;
  height: calc(100vh - 20px);
  display: grid;
  grid-template-areas:
    "navigation navigation navigation navigation"
    "left content content right"
    "content content content content"
    "left content content right"
    "footer footer footer footer";
}
```

The above example does not work. There are two definitions of`right` and `left`. Removing that row "content content content content" will fix it since `left` and `right` will be connected.

```
// Example of an invalid Grid
#grid {
  background-color: #73937E;
  height: calc(100vh - 20px);
  display: grid;
  grid-template-areas:
    "navigation navigation navigation navigation"
    "content right"
    "content content"
    "right"
    "footer";
}
```

The above example does not work. We have described a non-rectangular area. Grid is not built for that and doesn’t support it.

Tip: You can use `grid-template-rows` in conjunction with `grid-template-areas`. However, the result will be different. You have to choose the one that is suitable for your specific scenario.

```
// Approach A
grid-template-rows: 1fr 3fr 1fr;
grid-template-areas:
  "navigation navigation navigation navigation"
  "left content content right"
  "footer footer footer footer";

// Approach B
grid-template-areas:
  "navigation navigation navigation navigation"
  "left content content right"
  "left content content right"
  "left content content right"
  "footer footer footer footer";
```

![Approach A](https://cdn-images-1.medium.com/max/2090/1*U9o4_M-wfMeBHindl1H4sw.png)

![Approach B](https://cdn-images-1.medium.com/max/2082/1*18VMr9MkDmUHOS-biKfckQ.png)

Tip: Grid lines are created for free when using the `grid-template-area`. That means that even when using `grid-template-area`, you can still use the grid lines’ position logic. Let’s briefly check the negative index `-1` then.

```
.customContent {
  background-color: white;
  grid-row: 1 / -1; 
  grid-column: 1;
}
```

Adding a negative index makes your CSS more robust. You become agnostic regarding the number of grid lines: You set your content to expand to the last grid line.

![Result of using a negative index on the row](https://cdn-images-1.medium.com/max/2078/1*mFCCFIxCWZ_EA5H80t-BjQ.png)

---

## 2. Grid Gap

Grid `gap` is super simple and intuitive to use. Use `column-gap` , `row-gap` or `gap` to define gaps in the grid layout.

```
#grid {
  background-color: #73937E;
  height: calc(100vh - 20px);
  display: grid;
  row-gap: 5px;
  column-gap: 15px;
  grid-template-areas:
    "navigation navigation navigation navigation"
    "left content content right"
    "content content content content"
    "left content content right"
    "footer footer footer footer";
}
```

![Using the gap feature](https://cdn-images-1.medium.com/max/2000/1*aajG-IirnfyHHYyPb2YKsw.png)

Note: Don’t use `grid-gap`, `grid-column-gap`, or `grid-column-gap`: Those are now considered obsolete and will see support dropping.

---

## 3. MinMax

At first `MinMax` doesn’t look like an exciting feature. The API is super simple:

```
minmax(min, max)
```

It will be picking up the maximum value between `min` and `max`. It does accept: `length`, `percentage`, `max-content`, `min-content`, and `auto` values. The fact that it’s built for Grid is what makes it super powerful.

Let’s create a layout with three columns and use `minmax` to have them expand across the whole grid area.

```
grid-template-columns: repeat(3, minmax(100px, 1fr));
```

![Defining a three-column layout with minmax](https://cdn-images-1.medium.com/max/2000/1*DqLyXYT5DlN7k8NHejQ1nQ.png)

Note: It looks pretty sweet but there’s a big drawback: If the container is less than `3 * 100px + 2 * 10px`, the content will overflow.

![Not enough space to render the three-column layout with column min-width 100px](https://cdn-images-1.medium.com/max/2000/1*q-y32_HSK0RUABQregRtJw.png)

How can we solve that? Build Grid layouts in a responsive way. We can have the Grid container determine the number of columns itself by using `auto-fill` or `auto-fit`.

With that simple change, our three-column layout is now responsive to the size of the viewport:

```HTML
<!DOCTYPE html>
<html>
    <head>
        <title>Grid Playground</title>
        <meta charset="UTF-8" />
    </head>
    <body>
        <style type="text/css">
            body {
                color: white;
                text-align: center;
                box-sizing: content-box;
            }

            #grid {
                background-color: #73937E;
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
                gap: 10px;
                padding: 20px;
            }

            .item {
                padding: 20px;
                background-color: #5B2E48;
            }
        </style>
        <div id="grid">
            <div class="item"></div>
            <div class="item"></div>
            <div class="item"></div>
            <div class="item"></div>
            <div class="item"></div>
            <div class="item"></div>
            <div class="item"></div>
            <div class="item"></div>
            <div class="item"></div>
            <div class="item"></div>
            <div class="item"></div>
            <div class="item"></div>
            <div class="item"></div>
            <div class="item"></div>
            <div class="item"></div>
            <div class="item"></div>
            <div class="item"></div>
            <div class="item"></div>
            <div class="item"></div>
            <div class="item"></div>
        </div>
        </script>
    </body>
</html>
```

![Responsive Grid layout](https://cdn-images-1.medium.com/max/2000/1*wu16vXlLxgjnrI8Gragp1g.png)

That where all our magic happens:

```
grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
```

We are telling the Grid layout to create tracks that fill the grid space and that they should have a minimum of `200px` and a maximum of `1fr`.

Note: There’s a caveat: you can’t use `auto-fill` and set up a maximum number of columns. It’s just not meant to work that way. For setting a max number of columns, you have to use media queries and tweak the value of `minMax`. Another option is to use `css variables`. Either option requires the use of media queries.

```
// Example of using media queries + css variables to have responsive fixed column layout

.grid {
  --repeat: auto-fit;
}

@media screen and (max-width: 700px) {
  .grid {
    --repeat: 3;
  }
}

grid-template-columns: repeat(var(--repeat, auto-fit), minmax(200px, 1fr));
```

Lastly, let’s fully understand the difference between `auto-fit` and `auto-fill`:

* `auto-fill`: Tries to fill the row with as many columns as it can for the given constraints
* `auto-fit`: Behaves the same way as `auto-fill`, but any empty repeated track will be collapsed and it will be expanding the other ones to take all the available space, if any

![auto-fill vs auto-fit](https://cdn-images-1.medium.com/max/2000/1*Be3yz9t1oZ-OzfWghQ_l0g.png)

When there are enough elements to fill the Grid, both properties will behave the same way. That means that depending on the resolution, they might look the same. That’s why it’s good to know their internals.

![On certain resolutions, they might look the same way](https://cdn-images-1.medium.com/max/2000/1*bjQpF-R9e7ki-5u2c5zOwg.png)

---

## Wrap-Up

![Photo by [Denys Nevozhai](https://unsplash.com/@dnevozhai?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10944/0*qOzhnK7sH5tZyk_T)

We have deep-dived into the main three grid features and how best to use them. You can now build your layouts in a more performant and efficient way with less CSS code. The days of hacking the Flex API are over — empower yourself with Grid.

Unfortunately, we can’t wait for Explorer 11 to disappear as it won’t happen for at least four years’ time. It’s still used at the enterprise level. Just make sure you add some polyfills to give support to 100% of your users.

I hope my article gives you that final push needed to start using Grid in production. Once you start using it, there’s no going back.

If you are curious about Subgrid, I suggest you check this other article:
[**Using CSS Subgrid for Pixel Perfection**
**Exposing the beautiful simplicity of CSS’s subgrid feature**medium.com](https://medium.com/better-programming/using-css-subgrid-for-pixel-perfection-6d4343b057cd)

Cheers!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
