> * 原文地址：[6 CSS Properties Nobody Is Talking About](https://js.plainenglish.io/6-css-properties-nobody-is-talking-about-e6cab5138d02)
> * 原文作者：[Anurag Kanoria](https://medium.com/@anuragkanoria)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/6-css-properties-nobody-is-talking-about.md](https://github.com/xitu/gold-miner/blob/master/article/2021/6-css-properties-nobody-is-talking-about.md)
> * 译者：
> * 校对者：

# 6 CSS Properties Nobody Is Talking About

![Photo by [Kristina Flour](https://unsplash.com/@tinaflour?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/9640/0*bs0OAqfhQkkn-9YY)

CSS and HTML have been the cornerstone of the internet for decades.

While HTML was responsible for creating website structures and arranging texts and graphics, it could do little when it came to designing the website.

Designing websites, ever since 1994, has been the sole purpose of CSS. It became the language that described how websites should look and feel.

Over the years, CSS has seen a number of new properties added to it such as Flexbox and Grid.

Despite the immense popularity and rising complexities of creating web apps, there are still a number of CSS properties and tricks that most developers don’t know.

Below are 6 CSS properties that you probably never heard of:

## 1. all

Have you ever used any CSS framework? If yes, I am pretty sure there might have been times when you wanted to override some of the elements to your liking.

While the most common way of doing that is by using the `!important` property in CSS to lay emphasis on the current property, ignoring all other settings and rules.

```css
.header{
    color: blue !important;
    font-size: 14px !important; 
}
```

However, writing the same keyword again and again can make the CSS file look messy.

The easier way to do it is to use the `all` property.

There are 3 property values of `all` — initial, inherit, and unset.

```css
.header{
  all:initial;
  color: blue;
  font-size: 14px; 
}
```

`all:initial` sets all the properties of the element to their fallback or initial values.

Chrome and Firefox support this property starting version 37 and version 27 respectively. This property is also supported on Edge browser, but not on Internet Explorer.

## 2. writing-mode

I wrote a recent article on [some of the amazing places to find design inspirations](https://medium.com/javascript-in-plain-english/8-amazing-places-to-find-design-inspirations-for-free-dd2e64abc1b0) and I stumbled upon many sites that have texts laid out vertically and sideways.

![Source: [httpster](https://httpster.net/2020/dec/).](https://cdn-images-1.medium.com/max/2600/1*m5Ut8kRsp8oSIUogG_EMuw.jpeg)

On the right side(near scrollbar) of the image above, you can see texts laid sideways which is a neat way of showing additional information.

The `writing-mode` property allows you to achieve exactly this.

This property supports the following values:

* `sideways-rl`: Text and other content are laid out vertically from top to bottom and are set sideways toward the right.
* `sideways-lr`: Like `sideways-rl`, text and other content are laid out vertically from top to bottom but set sideways toward the left.
* `vertical-rl`: Text and other content are laid out vertically from top to bottom and right to left horizontally. If there are two or more lines, the lines are **placed to the left** of the previous line.
* `vertical-lr`: Unlike `vertical-rl` , horizontally the text is laid out left to right, and if there are two or more lines, the lines are **placed to the right** of the previous line.

There is also `horizontal-tb` which represents the standard way of how texts are displayed.

![Source: [MDN Web Docs](https://developer.mozilla.org/en-US/docs/Web/CSS/writing-mode)](https://cdn-images-1.medium.com/max/2000/1*enCsNGgsHPLsCxLnu0-FJA.png)

You can find the implementation and code snippets [here](https://developer.mozilla.org/en-US/docs/Web/CSS/writing-mode).

## 3. background-clip

This is an interesting property that allows us to set a custom graphic to our element’s background.

Our custom graphic can extend to the border-box, padding-box, or content-box of the element.

Below is a short implementation of this property:

HTML:

```html
<p class="border-box">The background extends behind the border.</p>
<p class="padding-box">The background extends to the inside edge of the border.</p>
<p class="content-box">The background extends only to the edge of the content box.</p>
<p class="text">The background is clipped to the foreground text.</p>
```

CSS:

```css
p {
  border: .8em darkviolet;
  border-style: dotted double;
  margin: 1em 0;
  padding: 1.4em;
  background: linear-gradient(60deg, red, yellow, red, yellow, red);
  font: 900 1.2em sans-serif;
  text-decoration: underline;
}

.border-box { background-clip: border-box; }
.padding-box { background-clip: padding-box; }
.content-box { background-clip: content-box; }

.text {
  background-clip: text;
  -webkit-background-clip: text;
  color: rgba(0,0,0,.2);
}
```

Output:

![Source: Author](https://cdn-images-1.medium.com/max/2000/1*Ugb8RTSg7qFGkcSFUWfkHw.jpeg)

You can use a custom image and set it as the background of the text as well as shown below:

![Source: Author](https://cdn-images-1.medium.com/max/2000/1*ng2WZRQ1HOIBSHWdizCzBw.jpeg)

It is worth noting that you need to use the `-webkit-background-clip` property for Chrome and make sure text color is set to transparent.

## 4. user-select

If you have any text on your website that you don’t want your users to be able to copy, this is the property that will enable you to do so.

The `user-select` property specifies whether the text of an element can be selected or not.

This does not have any effect on the content loaded except textboxes.

```css
.row-of-icons {   
-webkit-user-select: none;  /* Chrome & Safari all */   
-moz-user-select: none;     /* Firefox all */   
-ms-user-select: none;      /* IE 10+ */   
user-select: none;          
}
```

This property can be used to make sure that an entire element got selected as well.

```css
.force-select {
   user-select: all;  
  -webkit-user-select: all;  /* Chrome 49+ */
  -moz-user-select: all;     /* Firefox 43+ */
       
}
```

You can find the full guide [here](https://developer.mozilla.org/en-US/docs/Web/CSS/user-select).

## 5. white-space

This property is useful when applying `text-overflow` properties as this property allow you to control the flow of text of an element.

It accepts `nowrap`, `pre`, `pre-wrap`, `pre-line` and `normal` as property values.

The `nowrap` prevents the text from wrapping inside the element width and height and allows it to overflow.

The `pre` value forces the browser to render the line breaks and white spaces that appear in the code but are stripped out by default. `The pre-wrap` value does the same except that it also wraps the text in that element.

The`pre-line` property will break lines where they break in code, but extra white space will not be rendered.

This becomes clear with the following example:

HTML:

```html
<div>
<p class='zero'>

Some text
</p>

<p class='first'>

Some text 
</p>
<p class='second'>
Some text 
</p>
<p class='third'>
Some text 
</p>
<p class='fourth'>
Some text 
</p>
</div>
```

CSS:

```css
div{
  width:100px;   
}
p{
  background:red;
  font-size:2rem;
}
.first{
  white-space:nowrap;
}
.second{
  white-space:pre;
}
.third{
  white-space:pre-line;
}
.fourth{
  white-space:nowrap;
  text-overflow:ellipsis;
  overflow:hidden;
}
```

Output:

![Source: Author](https://cdn-images-1.medium.com/max/2000/1*9L39xG8cZkPXO2rkiuvHOg.jpeg)

## 6. `border-image` property

This property is excellent for designing your website.

You can create beautiful borders around your element using this property.

`border-image` allows you to set custom images as borders.

I am going to use this image to demonstrate this property.

![Source: [MDN site.](https://developer.mozilla.org/en-US/docs/Web/CSS/border-image)](https://cdn-images-1.medium.com/max/2000/1*7SOVwmouXHD1lxWGVeSEMw.png)

HTML and CSS are given below:

```html
<body>
   <h1>This is a title</h1>
</body>
```

```css
h1{
  border: 10px solid transparent;
  padding: 15px;
  border-image: url(border.png) 20% round;
}
```

Output:

![Source: Author](https://cdn-images-1.medium.com/max/2716/1*go4Ajp41jzEj5bPsHAnOkQ.jpeg)

This property can be used to create fancy cards or to lay emphasis on certain portions of text.

## Final thoughts

Front-end developers use CSS and HTML all the time besides JavaScript and knowing more about these can help one build better apps quicker, faster, and in a better manner.

While I have shared a handful of less-talked about CSS properties, there are more such properties.

Even though CSS has been here for over 2 decades, it still has a lot of properties and tricks up its sleeve.

Knowing these can facilitate the development of fascinating CSS art and websites.

Thanks for reading!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
