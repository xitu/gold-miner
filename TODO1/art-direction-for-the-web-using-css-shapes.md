> * 原文地址：[Art Direction For The Web Using CSS Shapes](https://www.smashingmagazine.com/2019/04/art-direction-for-the-web-using-css-shapes/)
> * 原文作者：[Andy Clarke](https://stuffandnonsense.co.uk/about)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/art-direction-for-the-web-using-css-shapes.md](https://github.com/xitu/gold-miner/blob/master/TODO1/art-direction-for-the-web-using-css-shapes.md)
> * 译者：
> * 校对者：

# Art Direction For The Web Using CSS Shapes

> Designer and author of “[Art Direction for the Web](https://www.smashingmagazine.com/printed-books/art-direction-for-the-web/)”, Andy Clarke, has never been afraid of pushing boundaries when using CSS to create exciting new designs. In this tutorial, he goes beyond basic CSS Shapes and shows how you can use them to create five types of distinctive and engaging layouts for your art-directed designs.

Last year, Rachel Andrew wrote an article that took [a new look at CSS Shapes](https://www.smashingmagazine.com/2018/09/css-shapes/) in which she reintroduced readers to the basics of using CSS Shapes. For anyone keen to understand how to use properties like `shape-outside`, `shape-margin`, and `shape-image-threshold`, Rachel’s is the ideal primer.

I’ve seen many examples of using the properties, but very few go beyond Basic Shapes, including `circle()`, `ellipse()`, `inset()`. Even examples using `polygon()` shapes rarely go far beyond them. Considering the creative opportunities CSS Shapes offer, this is disappointing. But, I’m sure that with a little inspiration and imagination, we can make more distinctive and engaging designs. So, I’m going to show you how to use CSS Shapes to create the following five different types of layout:

1. [V-shapes](#v-shapes)
2. [Z-patterns](#z-patterns)
3. [Curved shapes](#curved-shapes)
4. [Diagonal shapes](#diagonal-shapes)
5. [Rotated shapes](#rotated-shapes)

### A Little Inspiration

Sadly, you won’t find many inspiring examples of websites which use CSS Shapes. That doesn’t mean that inspiration isn’t out there — you just have to look a little further afield at advertising, magazine, and poster design. However, it would be foolish for us to merely mimic work from a previous era and medium.

[![You can find inspiration in surprising places, such as these vintage advertisements.](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/a92a6d6e-3e23-44dd-83ac-7d67831e81f4/img-1.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/a92a6d6e-3e23-44dd-83ac-7d67831e81f4/img-1.png)

You can find inspiration in surprising places, such as these vintage advertisements.

For the past few years, I’ve filled Dropbox folders with inspiration and I really ought to move those examples to Pinterest. Fortunately, [Kristopher Van Sant](http://www.kristophervansant.com) has been more diligent than me in compiling a Pinterest board full of inspiring [‘Shapes Of Text’ examples](https://www.pinterest.co.uk/kisstafurr/shapes-of-text/).

Shapes add energy to design, and this movement draws people in. They help to **connect an audience with your story** and make tighter connections between your visual and written content.

When you need content to flow around a shape, use the `shape-outside` property. You must float an element left or right for `shape-outside` to have any effect.

```css
img {
  float: <values>;
  shape-outside: <values>;
}
```

**NB:** **When you flow content around shapes, be careful not to allow any lines of text to become too narrow and fit only one or two words.**

It often needs surprisingly little markup to develop dynamic and original layouts. My HTML for this series of five designs consists only of a header and main elements, figures, and images, and is often no more complicated than this:

```html
<header role="banner">
  <h1>Mini Cooper</h1>
</header>

<figure>
  <img src="mini.png" alt="Mini Cooper">
</figure>

<main>
…
</main>
```

### 1. V-Shapes

For me, one of the most incredible aspects of modern-day CSS is that I can create a shape from the alpha channel of a partially transparent image with no need to draw a polygon path. I only need to create an image, and then a browser will take care of the rest.

I think this is one of the most exciting additions to CSS and it makes developing art direction for the web more straightforward, especially if you work with a content management system and dynamically generated content.

[![Left: Without CSS Shapes, this design feels dull and lifeless. Right: Creating v-shapes makes this design more distinctive and engaging.](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/165e495e-1a22-449a-9d86-192fa6dec7be/img-3-4.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/165e495e-1a22-449a-9d86-192fa6dec7be/img-3-4.png)

Left: Without CSS Shapes, this design feels dull and lifeless. Right: Creating v-shapes makes this design more distinctive and engaging.

To develop shapes from images, they must have an alpha channel which is either entirely or partially transparent. I needn’t draw a polygon to enable content to flow between the triangular shapes either side of my content in this first design; instead, I need only specify the URL of an image file as the `shape-outside` value:

```css
[src*="shape-left"],
[src*="shape-right"] {
  width: 50%;
  height: 100%;
}

[src*="shape-left"] {
  float: left;
  shape-outside: url('alpha-left.png');
}

[src*="shape-right"] {
  float: right;
  shape-outside: url('alpha-right.png');
}
```

[![CSS Shape Example](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/292b2666-7718-49b4-b82a-54052f1bbfc7/img-4.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/292b2666-7718-49b4-b82a-54052f1bbfc7/img-4.png)

Watch out for CORS (cross-origin resource sharing) when using images to develop your shapes. You must host images on the same domain as your product or website. If you use a CDN, make sure it sends the correct headers to enable shapes. It’s also worth noting that the only way to test shapes locally is to use a web server. The `file://` protocol simply won’t work.

#### Generated Content

As Rachel explained in her article:

> “You could also use an image as the path for the shape to create a curved text effect without also including the image on the page. You still need something to float, however, and so for this, we can use Generated Content.”

As an alternative to alpha channel, I can use Generated Content — applied to two pseudo-elements — one for a polygon triangle on the left, the other for the right. My running text will now flow between the two generated shapes:

```css
main::before {
  content: "";
  display: block;
  float: left;
  width: 50%;
  height: 100%;
  shape-outside: polygon(0 0, 0 100%, 100% 100%);
}

main p:first-child::before {
  content: "";
  display: block;
  float: right;
  width: 50%;
  height: 100%;
  shape-outside: polygon(100% 0, 0 100%, 100% 100%);
}
```

**NB:** **Bennett Feely’s [CSS clip-path maker](http://bennettfeely.com/clippy/) is a fabulous tool for working out coordinate values for use with CSS Shapes.**

[![Adjusting the width of alpha images at several breakpoints allows the shape of this running text to best suit its viewport.](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/e55053ee-9096-4093-8bd5-4fd93a4e3411/img-5-6.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/e55053ee-9096-4093-8bd5-4fd93a4e3411/img-5-6.png)

Adjusting the width of alpha images at several breakpoints allows the shape of this running text to best suit its viewport.

### 2. Z-Patterns

A Z-pattern is a familiar path our eyes follow when reading content from left–right, top–bottom. By placing content along the hidden lines which form a Z, these patterns help guide a reader along this path, from where we’d like them to start reading towards a destination such as a call-to-action. Z-patterns can be either discreet — implied by focal points or elements with higher visual weight — or made obvious using CSS Shapes.

[![The z-pattern created by driving a narrow column of running text between two shapes suggests speed and the fun people will have when driving this iconic little car.](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/57236ebd-12ee-4e43-8bde-55ee99b7de76/img-8.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/57236ebd-12ee-4e43-8bde-55ee99b7de76/img-8.png)

The z-pattern created by driving a narrow column of running text between two shapes suggests speed and the fun people will have when driving this iconic little car.

In this next design, a discreet z-pattern is formed as:

1. The large image spans the full page width, the end-point emphasised with a right aligned headline.
2. A block of running text is formed by two CSS Shapes.
3. The thick top border on a figure acting as a footer completes the Z.

There’s no need for complicated markup to implement this design and my simple HTML includes just three elements:

```html
<header role="banner">
  <h1>Mini Cooper:icon of the ’60s</h1>
  <img src="banner.png" alt="Mini Cooper">
</header>

<main>
  <img src="placeholder-left.png" alt="" aria-hidden="true">
  <img src="placeholder-right.png" alt="" aria-hidden="true">
  …
</main>

<figure role="contentinfo">
…
</figure>
```

My page-width spanning header and figure needs no explanation, but flowing text between two triangular shapes is a little more complicated. To implement this z-pattern design, I choose to include two tiny 1×1px placeholder images onto which I apply two larger, shape-forming images using `shape-outside`. By attaching an `aria-hidden` attribute to these images, a screen reader won’t describe them.

After giving the two shape images the same dimensions, I float one image left and the other to the right, which allows my running text to run between them:

```css
[src*="placeholder-left"],
[src*="placeholder-right"] {
  display: block;
  width: 240px;
  height: 100%;
}

[src*="placeholder-left"] {
  float: left;
  shape-outside: url('shape-right.png');
}

[src*="placeholder-right"] {
  float: right;
  shape-outside: url('shape-right.png');
}
```

[![Left: A presentable but predictable design which lacks energy. Right: CSS Shapes suggest fun and speed.](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/e00dcb8e-642b-43ec-947b-349fea165d1d/img-7-8.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/e00dcb8e-642b-43ec-947b-349fea165d1d/img-7-8.png)

Left: A presentable but predictable design which lacks energy. Right: CSS Shapes suggest fun and speed.

The iconic Mini Cooper was fast and fun to drive. While my design would be perfectly presentable without a z-pattern formed by CSS Shapes, this layout looks predictable and lacks energy. The z-pattern created by driving a narrow column of running text between two shapes suggests speed and the fun people will have when driving this iconic little car.

### 3. Curved Shapes

One of the most fascinating aspects of CSS Shapes is how I can create elegant shapes using the alpha channel from a partially transparent image. This shape can be anything I imagine. I only need to create the image, and a browser will flow content around it.

While confining content to within a shape has been proposed in the [CSS Shapes Module Level 2 specification](https://drafts.csswg.org/css-shapes-2/), there’s currently no way to know if and when this might be implemented in browsers. But while `shape-inside` isn’t available (**yet!**), that doesn’t mean I can’t create similar results using `shape-outside`.

[![Left: Another presentable, but predictable design. Right: A more distinctive look created by using CSS Shapes.](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/4913ceec-6073-42f4-bd21-03b6f0ffe3e0/img-9-10.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/4913ceec-6073-42f4-bd21-03b6f0ffe3e0/img-9-10.png)

Left: Another presentable, but predictable design. Right: A more distinctive look created by using CSS Shapes.

By confining my content within a curved image floated right, I can easily add a distinctive look to this next design. To create the shape, I again use the `shape-outside` property, this time with the value being the same URL as my visible image:

```css
[src*="curve"] {
  float: right;
  width: 400px;
  height: 100vh;
  shape-outside: url('curve.png');
}
```

To put some distance between my shape and the content flowing around it, the shape-margin property draws a further shape outside the contours of the first one. I can use any CSS absolute length unit — millimeters, centimeters, inches, picas, pixels, and points — or relative units (`ch`, `em`, `ex`, `rem`, `vh`, and `vw`):

```css
[src*="curve"] {
  shape-margin: 3rem;
}
```

#### More Margins

Adding movement to this curved design relies on more than CSS Shapes. Using viewport width units, I give my headline, image, and running text a different left margin, each one proportional to the width of the viewport. This creates a diagonal from the back of my headline to the front of the car:

```css
h1 {
  margin-left: 5vw;
}

img {
  margin-left: 10vw;
}

p {
  margin-left: 20vw;
}
```

### 4. Diagonal Shapes

Angles can help make layouts look less structured and feel more organic. The absence of clear structure encourages the eye to roam freely around a composition. This movement also causes an arrangement to feel energetic.

I see designs set around horizontal and vertical axes every day, but rarely anything based on a diagonal. Every once in a while, I spot an angled element — perhaps a banner graphic with its bottom sloping — but it’s rarely essential to a design.

[![It’s common to see content flowing around shapes in print design, but this was impossible to achieve on the web before CSS Shapes.](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/b8ab6fcc-9f78-470b-aa03-1b87ec597c6b/img-11-12.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/b8ab6fcc-9f78-470b-aa03-1b87ec597c6b/img-11-12.png)

It’s common to see content flowing around shapes in print design, but this was impossible to achieve on the web before CSS Shapes.

Even though CSS Grid involves setting columns and rows, there’s no reason why it can’t be used to create dynamic diagonals. This next design needs just a header and main element:

```html
<header role="banner">
  <h1>Mini Cooper</h1>
  <img src="banner.png" alt="Mini Cooper">
</header>

<main>
  <img src="shape.png" alt="">
  …
</main>
```

To create the diagonal detail in this design, I again flow content around a shape image which itself is floated left. Again I use the `shape-outside` property with the same URL value as my visible image and a `shape-margin` to put distance between my shape and the content flowing around it:

```css
[src*="shape"] {
  float: left;
  shape-outside: url('shape.png');
  shape-margin: 3rem;
}
```

Given that responsiveness is one of the web’s intrinsic properties, we can rarely predict how content will flow, but we avoid designs like this one. When there’s too little space for all my running text to fit above the shape, the fact that each shape is floated means that content will flow into space below the shape.

### 5. Rotated Shapes

Why settle for just using CSS Grid and Shapes when adding Transforms to the mix can enable layouts which were unimaginable only a few years ago? In this final example, flowing text around the cars in this image, while at the same time rotating the entire composition needed a combination of all those properties.

[![Why settle for using only CSS Grid and Shapes?](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/72c40e9f-fe9c-4253-a146-022ad53778c1/img-13.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/1b743c51-484a-4776-b6d0-b33c8357e030/img-13.png)

Why settle for using only CSS Grid and Shapes?

As the image of these cars has no transparent alpha channel, flowing text around the shapes, it contains needs a second image which includes only alpha channel information.

[![Implementing this design requires two images; one visible, the other proving alpha channel information.](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/4970459c-3ad8-4182-b089-965f233d2671/img-14.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/4970459c-3ad8-4182-b089-965f233d2671/img-14.png)

Implementing this design requires two images; one visible, the other proving alpha channel information.

This time, I float the visible image right and apply the `shape-outside` property with a URL value which matches my alpha channel image:

```css
[src*="shape"] {
  float: right;
  width: 50%;
  shape-outside: url('alpha.png');
  shape-margin: 1rem;
}
```

You may have noticed that both my images contain elements which I rotated clockwise by ten degrees. With those images in place, I can rotate the entire layout ten degrees in the opposite direction to give the illusion that my images are upright:

```css
body {
  transform: rotate(-10deg);
}
```

[![I rotate this layout just enough to make the design more appealing, without sacrificing readability.](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/7b3dddc2-c5b3-4e24-b65a-bc6368981523/img-15-16.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/7b3dddc2-c5b3-4e24-b65a-bc6368981523/img-15-16.png)

I rotate this layout just enough to make the design more appealing, without sacrificing readability.

### Bonus Example: Polygon Shapes Sculpt Columns

**An extract from ‘Art Direction for the Web’ available from 26th March 2019.**

You can create strong, structural shapes with nothing more than type. Combining `polygon()` shapes and pseudo-elements, you can sculpt shapes from solid blocks of running text, in the style of [Alexey Brodovitch](https://en.wikipedia.org/wiki/Alexey_Brodovitch) and his influential work for Harper’s Bazaar.

[![Left: These beautiful numerals are almost too lovely to hide. They’re also perfect for carving into those columns. Right: When I use invisible pseudo-elements with no background or borders to develop polygon shapes, the result is two unusually shaped columns.](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/b7832cb6-7eed-42e9-973b-3ddc0f7d5282/img-17-18.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/b7832cb6-7eed-42e9-973b-3ddc0f7d5282/img-17-18.png)

Left: These beautiful numerals are almost too lovely to hide. They’re also perfect for carving into those columns. Right: When I use invisible pseudo-elements with no background or borders to develop polygon shapes, the result is two unusually shaped columns.

I formed these columns from two article elements, i.e. with a gutter between them and a maximum width, which help maintain a comfortable measure:

```css
body {
  display: grid;
  grid-template-columns: 1fr 1fr;
  grid-gap: 2vw;
  max-width: 48em;
}
```

Because there are two article elements and I also specified two columns for my grid, there’s no need to be specific about the position of those articles. I can let a browser place them for me, and all that remains for me is to apply `shape-outside` to a generated pseudo-element in each column:

```css
article:nth-of-type(1) p:nth-of-type(1)::before {
  content: "";
  float: left;
  width: 160px;
  height: 320px;
  shape-outside: polygon(0px 0px, 90px 0px, [...]);
}

article:nth-of-type(2) p:nth-of-type(2)::before {
  content: "";
  float: right;
  width: 160px;
  height: 320px;
  shape-outside: polygon(20px 220px, 120px 0px, [...]);
}
```

### The Pay-Off

Now that Firefox has released a version which supports CSS Shapes, and has launched a Shape Path Editor inside its Developer Tools, there’s now only Edge without support for Shapes. This situation will soon change now that Microsoft has announced a change from their own EdgeHTML rendering engine to Chromium’s Blink, the same engine as Chrome and Opera.

Tools like CSS Shapes now give us countless opportunities to use art direction to capture readers’ attention and keep them engaged. I hope by now you’re as excited about them as I am!

**Editorial’s Note**: **Andy’s new book, Art Direction for the Web ([pre-order your copy today](https://www.smashingmagazine.com/printed-books/art-direction-for-the-web/)), explores 100 years of art direction and how we can use this knowledge and the newest web technologies to create better digital products. [Read an excerpt chapter](http://provide.smashingmagazine.com/eBooks/Art-direction-FTW-excerpt.pdf?_ga=2.206394323.1550887490.1554923173-204951999.1554923173) to get a taste of what the book has to offer.**

#### Further Resources

* “[Art Direction for the Web](http://artdirectionfortheweb.com),” Andy Clarke
* “[Take A New Look At CSS Shapes](https://www.smashingmagazine.com/2018/09/css-shapes/),” Rachel Andrew
* “[CSS Shapes](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Shapes),” MDN web docs, Mozilla
* “[Edit Shape Paths In CSS](https://developer.mozilla.org/en-US/docs/Tools/Page_Inspector/How_to/Edit_CSS_shapes),” MDN web docs, Mozilla
* “[Art Direction For The Web: A New Smashing Book](https://www.smashingmagazine.com/2019/03/art-direction-release/),” Smashing Magazine

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
