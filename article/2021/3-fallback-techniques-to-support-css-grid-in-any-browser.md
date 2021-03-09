> * 原文地址：[3 Fallback Techniques To Support CSS Grid in Any Browser](https://betterprogramming.pub/3-fallback-techniques-to-support-css-grid-in-any-browser-1740454d7cdb)
> * 原文作者：[Jose Granja](https://medium.com/@dioxmio)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/3-fallback-techniques-to-support-css-grid-in-any-browser.md](https://github.com/xitu/gold-miner/blob/master/article/2021/3-fallback-techniques-to-support-css-grid-in-any-browser.md)
> * 译者：
> * 校对者：

# 3 Fallback Techniques To Support CSS Grid in Any Browser

#### Understanding the use of CSS Grid in production

![Photo by [John Schnobrich](https://unsplash.com/@johnschno?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral).](https://cdn-images-1.medium.com/max/9662/0*z99PsHMNipBY051X)

CSS Grid has great support amongst browsers nowadays — roughly 95% for its basic functionality. However, sometimes you can’t ignore that 5%, as you might want your web application’s layout to look great across all browsers. You might even want to use newer Grid features that have less support.

What should we do? Should we avoid using Grid in production? Should we ignore users with older browsers? Should we wait for the feature to have better coverage? Definitely not. There are plenty of fallback techniques to overcome these issues.

In this article, we will be exploring the top three techniques that will help us gracefully fall back from our Grid layouts. We will be adapting our web page design according to the browser features available. It will be progressively adaptive.

Before diving into the technical aspects, we need to define a strategy. Having a proper strategy is key to success. It will give us a sense of direction and consistency.

---

## Defining a Strategy

The most common usage of Grid is to build multi-dimensional layouts that adapt to the user’s screen resolution. What should you do when the Grid is not available? How can you make a flexible and responsive layout with something other than Grid?

You could try to replicate that same layout by using Flexbox, but it would add too much code. Moreover, Flexbox isn’t built for the same purpose and you would likely struggle.

What should you do? The solution is very simple: As a fallback, just present the user with the mobile layout. Only desktop users with an outdated browser will notice something. That’s a very low percentage of your total user base. The site should be usable and consistent. It’s a fair trade-off.

What about using the newest Grid features? The same strategy applies: Try to fall back to a decent similar layout.

In summary: our layout will be enhanced progressively. Users with older browsers will be presented with a simpler, yet usable, version of the layout. Users with the latest browser will be receiving the full UX experience.

Let’s look at the top 3 tools at our disposal.

---

## 1. Using CSS Feature Queries

Let’s start by describing what these are:

> “Feature queries are created using the CSS at-rule [@supports](https://developer.mozilla.org/en-US/docs/Web/CSS/@supports), and are useful as they give web developers a way to test to see if a browser has support for a certain feature, and then provide CSS that will only run based on the result of that test. In this guide you will learn how to implement progressive enhancement using feature queries.” — [MDN Web Docs](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Conditional_Rules/Using_Feature_Queries)

If you have ever used media queries, you will be very familiar with the syntax. It is the same. Instead of conditioning your layout based on the browser’s viewport size, you are doing the same but basing it on the validity of CSS properties.

As per our strategy:

1. We will build a mobile layout version using Flexbox and use it as the default.
2. By using `@supports`, we will check if the browser supports Grid. If it does, we will enhance our layout by using Grid.

In this example, since we are just interested in the standard Grid behavior, we will query `@supports` for the basic `display: grid` feature:

```
@supports (display: grid) {
  //... code here
}
```

Let’s see a full example:

```HTML
<!DOCTYPE html>
<html>
  <head>
    <title>Grid in Production</title>
    <meta charset="UTF-8" />
  </head>

  <body>
    <style type="text/css">
        #container {
            display: flex;
            flex-direction: column;
            gap: 10px;
            border: 1px solid #000;
            padding: 10px;
        }
        @supports (display: grid) {
            #container {
                display: grid;
            }
            @media (min-width: 768px) {
                #container {
                    grid-template-columns: 100px 1fr 100px;
                }
            }
        }
        .side1 {
            padding: 10px;
            background-color: #CEB992;
        }
        .side2 {
            padding: 10px;
            background-color: #CEB992;
        }
        .content {
            padding: 10px;
            min-height: 400px;
            background-color: #5B2E48;
        }

        body {
            color: #FFF;
            font-weight: 500;
        }
    </style>
    <div id="container">
      <div class="side1">
        Side Panel
      </div>
      <div class="content">
        Main Content
      </div>
      <div class="side2">
        Side Panel
      </div>
    </div>
  </body>
</html>
```

Note that we are not asserting against this Grid feature: `grid-template-columns`. What would happen if the browser doesn’t support it? In that scenario, Grid will fall back to the default positioning algorithm. It will stack the `divs`. For our example, that works, so we won’t need any extra work.

Let’s see the results.

This is the result from a Grid-capable browser on a desktop resolution:

![Layout when supporting Grid](https://cdn-images-1.medium.com/max/2000/1*DuwFq17QtSj96yMWa7KGwA.png)

This is the result from a Grid-capable browser on a mobile resolution:

![Layout when supporting Grid](https://cdn-images-1.medium.com/max/2000/1*nm0t3NbuJboHpmEACBUsIw.png)

This is the result from a non-Grid-capable browser on any resolution:

![Fallback layout](https://cdn-images-1.medium.com/max/2000/1*YfV-AKl5U5bRzX9BVYtMGg.png)

The layout is not broken and still usable and accessible for all browser engines. Only users who access it from a desktop will see a difference.

---

## 2. Using CSS Feature Queries Programmatically

Sometimes it is not possible to achieve what you want only with CSS Feature Queries on your CSS styles. As powerful as they are, they have limits. You might want to programmatically add or remove elements based on your browser features. How is that achieved?

Luckily, the CSS features can be invoked programmatically on the JavaScript side. The `@supports` can be accessed via the CSS object model interface `[CSSSupportsRule](https://developer.mozilla.org/en-US/docs/Web/API/CSSSupportsRule)`.

> # “The `**CSSSupportsRule**` interface represents a single CSS `@supports` `at-rule`.” — [MDN Web Docs](https://developer.mozilla.org/en-US/docs/Web/API/CSSSupportsRule)

Let’s see the interface definition:

```
function supports(property: string, value: string): boolean;
```

Let’s use it in a dummy example. Let’s warn the user if they are using a browser that doesn’t support the Grid layout feature. Never do that in production. This is just a dummy example for fun.

This is how we conditionally check if Grid is not supported:

```
if (!CSS || !CSS.supports('display', 'grid')) {
  ...
}
```

Be aware that `CSS.supports` might not be supported on some browsers, hence the null check.

Let’s see a working code example:

```HTML
<!DOCTYPE html>
<html>
  <head>
    <title>Grid in Production</title>
    <meta charset="UTF-8" />
  </head>
  <body>
    <style type="text/css">
        #container {
            display: flex;
            flex-direction: column;
            gap: 10px;
            border: 1px solid #000;
            padding: 10px;
        }
        @supports (display: grid) {
            #container {
                display: grid;
            }
            @media (min-width: 768px) {
                #container {
                    grid-template-columns: 100px 1fr 100px;
                }
            }
        }
        .side1 {
            padding: 10px;
            background-color: #CEB992;
        }
        .side2 {
            padding: 10px;
            background-color: #CEB992;
        }
        .content {
            padding: 10px;
            min-height: 400px;
            background-color: #5B2E48;
        }

        body {
            color: #FFF;
            font-weight: 500;
        }
    </style>
    <script>
        (function warnSupport(){
            if (!CSS || !CSS.supports('display', 'grid')) {
                alert('Warning your Browser does not support the latests features. Consider switching to a newer one')
            }
        })();
    </script>
    <div id="container">
      <div class="side1">
        Side Panel
      </div>
      <div class="content">
        Main Content
      </div>
      <div class="side2">
        Side Panel
      </div>
    </div>
  </body>
</html>
```

`CSS.supports` is a great tool for creating fallback layouts in a programmatic way. If you have to deal with very complex layouts, you might want to pick this technique instead of CSS Feature Queries. You can use it to create web components with their programmatic fallbacks.

---

## 3. Overriding Properties

Sometimes you don’t need fancy things like CSS Feature Queries. You can take advantage of how CSS properties work: When redefining properties in a CSS class, the last valid one is the one to be used.

What does that mean? How is this cool? You can define fallbacks just by overriding a CSS property:

```
#container {
  display: flex;
  display: grid;

  // if grid is not available this will be invalid and it will apply the previous property value: flex
}
```

We can redo our previous CSS Feature Queries example in a simpler way:

```HTML
<!DOCTYPE html>
<html>
  <head>
    <title>Grid in Production</title>
    <meta charset="UTF-8" />
  </head>
  <body>
    <style type="text/css">
        #container {
            display: flex;
            display: grid;
            flex-direction: column;
            gap: 10px;
            border: 1px solid #000;
            padding: 10px;
        }
        @media (min-width: 768px) {
            #container {
                grid-template-columns: 100px 1fr 100px;
            }
        }
        .side1 {
            padding: 10px;
            background-color: #CEB992;
        }
        .side2 {
            padding: 10px;
            background-color: #CEB992;
        }
        .content {
            padding: 10px;
            min-height: 400px;
            background-color: #5B2E48;
        }

        body {
            color: #FFF;
            font-weight: 500;
        }
    </style>
    <script>
        (function warnSupport(){
            if (!CSS || !CSS.supports('display', 'grid')) {
                alert('Warning your Browser does not support the latests features. Consider switching to a newer one')
            }
        })();
    </script>
    <div id="container">
      <div class="side1">
        Side Panel
      </div>
      <div class="content">
        Main Content
      </div>
      <div class="side2">
        Side Panel
      </div>
    </div>
  </body>
</html>
```

This fallback is simple yet powerful. It is useful in many scenarios. You can’t possibly use support queries for all Grid features that you want to use.

Let’s use it to fall back from one of the newest Grid features: `subgrid`. How should we use it?

Let’s check a scenario where we want to use `subgrid` for our nested Grid template columns. Here’s the gist of it:

```
#content {
  grid-template-columns: inherit;
  grid-template-columns: subgrid;
}
```

In this example, when the subgrid is not supported, it will just inherit the parent’s Grid definition. That will create a roughly similar layout.

This is just a simple example. You can fine-tune the `grid-template-columns` to some fixed sizes or whatever works best in your particular scenario.

Here is the full example:

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
                margin: 20px;
                
            }

            .palette-1 {
                background-color: #CEB992;
            }

            .palette-2 {
                background-color: #471323;
            }

            .palette-3 {
                background-color: #73937E;
            }

            .palette-4 { 
                background-color: #5B2E48;
            }

            .palette-5 { 
                background-color: #585563;
            }

            #container {
                padding: 10px;
                background-color: #73937E;
                height: 500px;
                width: calc(100vw - 60px);
                display: grid;
                grid-template-rows: repeat(8, 1fr);
                grid-template-columns: max-content 1fr 1fr 1fr;
                row-gap: 1rem;
                
            }

            .item {
                padding: 20px;
            }

            .content-main {
                grid-column: span 3;
            }

            #content {
                background-color: #73937E;
                grid-column: 1 / -1;
                display: grid;
                grid-template-columns: inherit;
                grid-template-columns: subgrid;
                column-gap: 1rem;
            }

            
        </style>
        <div id="container">
            <div id="content">
                <div class="content-left item palette-5">
                    Content Title
                </div>
                <div class="content-main item palette-4">
                </div>
            </div>
            <div id="content">
                <div class="content-left item palette-5">
                    Another Content Title
                </div>
                <div class="content-main item palette-4">
                </div>
            </div>
        </div>
        </script>
    </body>
</html>
```

As for the results:

![subgrid is available.](https://cdn-images-1.medium.com/max/2000/1*vk89GdczF9r3hEZI6841gw.png)

![subgrid is not available.](https://cdn-images-1.medium.com/max/2000/1*j8rPVYjENApqFPg--2Be_A.png)

As you can see, the results are 100% equal, but they are very similar. That’s what we are aiming for. As more browsers adopt `subgrid`, more users will be seeing the pixel-perfect version of your layout.

## Conclusion

Grid and Flexbox are meant to solve different scenarios. We can’t keep building everything with Flexbox because there’s still a minority of browsers not supporting it.

Upgrading from Flexbox to Grid should not mean layouts suddenly break on old devices. In this article, we explored how easy and fun it is to build progressive layouts. As we saw at the start, it is very important to have a strategy for how to proceed.

These strategies are not just meant to add the basic Grid functionality. You take advantage of the latest features like `subgrid` as long as you provide a sensible fallback.

I hope this motivates you to progressively start using Grid in production when it’s needed. You don’t have to hide behind Flexbox anymore.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
