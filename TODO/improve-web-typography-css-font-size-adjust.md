
> * 原文地址：[Improve Web Typography with CSS Font Size Adjust](https://www.sitepoint.com/improve-web-typography-css-font-size-adjust/?utm_source=SitePoint&utm_medium=email&utm_campaign=Versioning)
> * 原文作者：[Panayotis Matsinopoulos](https://www.sitepoint.com/author/pmatsinopoulos/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/#.md](https://github.com/xitu/gold-miner/blob/master/TODO/#.md)
> * 译者：
> * 校对者：

# Improve Web Typography with CSS Font Size Adjust

The `font-size-adjust` [property](https://drafts.csswg.org/css-fonts-3/#propdef-font-size-adjust) in CSS allows developers to specify the `font-size` based on the height of lowercase letters instead of uppercase letters. This can significantly improve the legibility of text on the web.

In this article, you will learn about the importance of the [font-size-adjust](https://drafts.csswg.org/css-fonts-3/#propdef-font-size-adjust) property and how to use it properly in your projects.

## The Importance of font-size-adjust

Most websites that you visit consist primarily of text. Since the written word is such an important part of a website, it makes sense to pay special attention to the typeface you are using to display your information. Choosing the right typeface can result in a pleasant reading experience. However, using the wrong one can make the website illegible. Once you have decided the typeface you want to use, you generally choose a proper size for it.

The `font-size` property sets the size of all the `font-family` options that you want to use on a website. However, most of the times it is generally chosen in such a way that your first `font-family` option looks good. The problem arises when the first choice is not available for some reason and the browser renders the text using one of the fallback fonts listed in the CSS document.

For instance, given this CSS rule:

```
body {
  font-family: 'Lato', Verdana, sans-serif;
}
```

If ‘Lato’, which your browser downloads from [Google Fonts](https://fonts.google.com/?query=lato&selection.family=Lato), is not available, the next fallback font, in this case Verdana, will be used instead. However, it’s likely that the `font-size` value was chosen with ‘Lato’ in mind, rather than with Verdana.

### What Is the Aspect Value of a Web Font?

The apparent size of a font as well as its legibility can vary greatly for a constant `font-size` value. This is especially true for scripts like Latin that distinguish between upper and lowercase letters. In such cases, the ratio of the height of lowercase letters to their uppercase counterparts is an important factor in deciding the legibility of the given font. This ratio is commonly called the **aspect value** of a font.

As I mentioned earlier, once you set a `font-size` value, it will remain constant for all the font families. However, this may affect the legibility of the fallback font if its aspect value is too different from the aspect value of the first choice font.

The role of the `font-size-adjust` property becomes very important in such situations, as it allows you to set the [x-height](https://typedecon.com/blogs/type-glossary/x-height/) of all the fonts to the same value thereby improving their legibility.

## Choosing the Right Value for font-size-adjust

Now that you know the importance of using the `font-size-adjust` property, it is time to learn how to use it on your website. This property has the following syntax:

```
font-size-adjust: none | <number>
```

The initial value of `font-size-adjust` is `none`. The value `none` means that no adjustment will be made to the value of the `font-size` of different `font-family` options.

You can also set the value of the `font-size-adjust` property to a number. This number is used to calculate the x-height of all the fonts on a webpage to the same value. The x-height is equal to the given number multiplied by the `font-size`. This can improve the readability of fonts at small sizes quite a bit. Here is an example of using the `font-size-adjust` property.

```
font-size: 20px;
font-size-adjust: 0.6;
```

The x-height of all the fonts will now be 20px * 0.6 = 12px. The actual size of a given font can now be changed to make sure that the x-height always stays at 12px. The new adjusted `font-size` of a given font can be calculated using this formula:

```
c = ( a / a' ) s.
```

Here, `c` is the adjusted `font-size` to use, `s` is the specified `font-size` value, a is the aspect value specified by the `font-size-adjust` property and `a'` is the aspect value of the font that needs to be adjusted.

You cannot set `font-size-adjust` to a negative value. A value of 0 will result in text with no height. In other words, the text will effectively be hidden. In older browsers, like Firefox 40, a value of 0 is equivalent to setting `font-size-adjust` to `none`.

In most cases, developers generally experiment with a few `font-size` values to see what looks best for a given font. This means that ideally, they would want the x-height of all the font options to be equal to the x-height of their first choice font. In other words, the most suitable value for the `font-size-adjust` property is the aspect value of your first choice font.

## ow to know the Aspect Value of a Font

To determine the right aspect value for a font, you can rely on the fact that its adjusted `font-size` should be the same as the original font-size that you specified. This means that `a` should be equal to `a'` in the previous equation.

The first step to calculate the aspect value is the creation of two `<span>` elements. Both elements will contain a single letter and a border around each letter (the letters have to be the same for both `<span>` elements because we’ll need to make a comparison between them). Also, both elements will have the same value for the `font-size` property, but only one of them will also use the `font-size-adjust` property. When the value of `font-size-adjust` is equal to the aspect value of a given font, both letters in each `<span>` element will be of the same size.

In the following demo, I have created a border around the letters ‘t’ and ‘b’ and applied a different `font-size-adjust` value for each pair.

Here’s the relevant snippet:

```
.adjusted-a {
  font-size-adjust: 0.4;
}

.adjusted-b {
  font-size-adjust: 0.495;
}

.adjusted-c {
  font-size-adjust: 0.6;
}
```

As you can see in the live demo below, a higher `font-size-adjust` value makes the letters larger and a lower value makes the letters smaller. When `font-size-adjust` becomes equal to the aspect value, the pairs attain equal size.

[![](http://oiklhfczu.bkt.clouddn.com/1504780206%281%29.jpg)](https://codepen.io/SitePoint/pen/YxxbMp)

## Using font-size-adjust on Websites

The following demo uses the `font-size-adjust` value that was calculated in the previous CodePen demo for the ‘Lato’ font to adjust the `font-size` of ‘Verdana’, which acts as fallback font. A button will turn the adjustment on or off so that you can see the difference yourself:

[![](http://oiklhfczu.bkt.clouddn.com/1504780255%281%29.jpg)](https://codepen.io/SitePoint/pen/KvvLOr)

The effect is more noticeable when you are working with a larger amount of text. However, the above example should still be enough to give you an idea of the usefulness of this property.

## Browser Support

At present, only Firefox supports `font-size-adjust` by default. Starting from version 43 and 30, Chrome and Opera support this property behind the “Experimental Web Platform Features” flag that can be enabled in chrome://flags. Edge and Safari don’t support the `font-size-adjust` property at all.

If you decide to use this property, lower browser support should not be an issue at all. This property has been designed with backward compatibility in mind. Non supporting browsers will display the text normally while supporting browsers will adjust the `font-size` based on the `font-size-adjust` property’s value.

## Conclusion

After reading the tutorial, now you know what the `font-size-adjust` property does, why it’s important, and how to work out the aspect value of different fonts.

Because `font-size-adjust` degrades gracefully in older browsers, you can go ahead and start using it today to improve the legibility of text in production websites.

Do you know some other tools or tips that can help users calculate the aspect values of a font quickly? Let fellow readers know in the comments.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
