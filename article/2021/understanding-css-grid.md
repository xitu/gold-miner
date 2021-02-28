> * 原文地址：[Responsive CSS Grid: The Ultimate Layout Freedom](https://medium.muz.li/understanding-css-grid-ce92b7aa67cb)
> * 原文作者：[Christine Vallaure](https://medium.com/@christinevallaure)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/understanding-css-grid.md](https://github.com/xitu/gold-miner/blob/master/article/2021/understanding-css-grid.md)
> * 译者：
> * 校对者：

# Responsive CSS Grid: The Ultimate Layout Freedom

![](https://cdn-images-1.medium.com/max/2800/0*MJfiLHUiFLi5M2sm.png)

CSS Grid is a new way to create two-dimensional layouts on the web. With just a few lines of CSS, you can create a grid that was hardly possible before without JavaScript. No plugin or complicated installs, no heavy additional files, no more design limitations due to 12-columns only.

## What kind of grids are possible?

In short: Actually, **almost all grids** that come to mind and many more. Choose the space, size and location of different grid items freely. A good overview of the most common grids with markup can be found at [Grid by Example](https://gridbyexample.com/examples/).

#### Let’s get started! HTML markup for our example:

A `div` with the class of `.container` holds 5 `div`/items (can, of course, be more or less). If you like, you can experiment with the [HTML and CSS markup in CodePen](https://codepen.io/chrisvall/pen/YJJdxQ) directly.

```html
<div class="container">
   <div class="item color-1"> item-1 </div>
   <div class="item color-2"> item-2 </div>
   <div class="item color-3"> item-3 </div>
   <div class="item color-4"> item-4 </div>
   <div class="item color-5"> item-5 </div>
 </div>
```

![I added some CSS styling for better understanding, not relevant for the grid](https://cdn-images-1.medium.com/max/2800/0*lCX1UQBdGhuXCuJl.jpeg)

#### Base: Set Grid, Columns and Rows in the CSS

In the **CSS**, we turn the `.container` class into a grid by adding `display:grid`. With `grid-template-columns` we activate the desired columns, in this case, 5 columns with `250px` each. With `grid-template-rows`we can set the height of the row (if needed), in this case `150px`. And that's it, the first grid is done!

```css
.container{
  display: grid;
  grid-template-columns: 250px 250px 250px 250px 250px;
  grid-template-rows: 150px;
}
/* short form: */ 
grid-template-columns: repeat(5, 250px);
```

![](https://cdn-images-1.medium.com/max/2800/0*yYYJTjLzTLzogzyu.jpeg)

#### Setting the gutter

Any desired distance between the items can be created with `grid-gap` for all items or separate for horizontal and vertical distances with `column-gap` and `row-gap`. By the way, you can use all common units, for example `px` for fixed gutters or `%` for flexible gutters.

```css
.container{
  display: grid;
  grid-template-columns: repeat(5, 250px);
  grid-template-rows: 150px;
  grid-gap: 30px;
}
```

![Note that on the left and right of the container its always half a gutter! So 15px in this example (same for most other grids too)](https://cdn-images-1.medium.com/max/2800/0*CR0ENpYQu_-fNCuD.png)

#### Automatic distribution to the available screen area with “fr”

A designer’s dream! With **Fractional Units** short `fr` you can divide the available space according to your wishes! Here, for example, we divide the screen size into 6 parts. The first column takes 1/6 = `1fr` of the space, the second column 3/6= `3fr` and the third column 2/6= `2fr`. You can of course also add `grid-gap` if you wish.

```css
.container{
  display: grid;
  grid-template-columns: 1fr 3fr 2fr;
}
```

![](https://cdn-images-1.medium.com/max/2980/0*yh7hFOcFs43LM9q8.gif)

all rows flexible

#### px and fr mixing for fixed and flexible columns

`px`and ****`fr `****can be mixed in any desired way the rest will adapt to the available space. Works like a charm!

```css
.container{
  display: grid;
  grid-template-columns: 300px 3fr 2fr;
}
```

![the first row fixed by px, remaining layout flexible](https://cdn-images-1.medium.com/max/2000/0*9buHg29Y9pG0bJir.gif)

#### Absolute freedom of arrangement

The best thing is, all items can take up as much space as you like even within the gird! For this purpose, a starting point is set with `grid-column-start` and the end with `grid-column-end`. Or in short grid-column: startpoint / endpoint;

```css
.container{
  display: grid;
  grid-template-columns: 1fr 3fr 2fr;
}
.item-1 {
 grid-column: 1 / 4;
}
.item-5 {
 grid-column: 3 / 4;
}
```

![](https://cdn-images-1.medium.com/max/2800/0*fGVZP5_NMbf9UJs3.png)

Don’t get confused by the grid lines, they start at the very beginning of the first item!

#### The same applies to vertical or full-area distribution!

Here CSS Grid can shine and prove its superiority over Boostrap and Co. Items can take all vertical sizes and positions with the help of `grid-row`. As we will see in the next example, this is an absolute advantage for adapting to different screen sizes and devices.

```css
.container{
  display: grid;
  grid-template-columns: 1fr 3fr 2fr;
}
.item-2 {
 grid-row: 1 / 3;
}
.item-1 {
 grid-column: 1 / 4;
 grid-row: 3 / 4;
}
```

![Any vertical width and position](https://cdn-images-1.medium.com/max/2800/0*a3fS5-GjETjWhArV.png)

#### Adapting to different screen sizes and devices? Of course!

Here CSS Grid also has a clear advantage over conventional grids, depending on the screen size you can not only switch from flexible to fixed elements with media queries, but you can also adjust the position of entire items!

```css
.container{
 display: grid;
 grid-template-columns: 250px 3fr 2fr;
}
.item-1 {
 grid-column: 1 / 4;
}
.item-2 {
 grid-row: 2 / 4;
}
@media only screen and (max-width: 720px){
  .container{
   grid-template-columns: 1fr 1fr;
  } 
  .item-1 {
   grid-column: 1 / 3;
   grid-row: 2 / 3;
  } 
  .item-2 {
   grid-row: 1 / 1;
  }
}
```

![](https://cdn-images-1.medium.com/max/2856/0*zF54G2_cLwYLyNh-.gif)

## Browser support

CSS Grid is now natively supported by all modern browsers (Safari, Chrome, Firefox, Edge). With global support of 87.85%, CSS Grids are already an alternative to Boostrap and Co.

![Status: October 2020 via [caniuse.com](https://caniuse.com/#search=CSS%20Grid)](https://cdn-images-1.medium.com/max/2430/0*JIVUYk-7ASagbEy0.jpeg)

## Real-life examples with CSS Grid

- [christinevallaure.com,](http://www.christinevallaure.com,) UX/UI Design
- [moonlearning.io](https://moonlearning.io/), UX/UI courses online
- [Slack](https://slack.com/intl/de-de/), Company Website
- [Medium](https://medium.com/), right here :)
- [Skyler Hughes](https://photo.skylerhughes.com/), Photography
- [Max Böck](https://mxb.at/), front-end developer
- [Design+Code](https://designcode.io/), tutorials for web designers
- [Hi Agency, Deck](http://www.hi.agency/deck/), template page

## Before you go

You might also like my other articles and courses on [moonlearning.io](https://moonlearning.io/) or the [full Design Handoff to Development course](http://UI Design Handoff to Development. Course for UX/UI Designer I remember handing off my first web design for development. I was super excited and spent hours getting everything…www.udemy.com) (more on how to use Grids!).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
