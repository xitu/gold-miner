> * 原文地址：[CSS Writing Mode](https://ishadeed.com/article/css-writing-mode/)
* 原文作者：[Ahmad Shadeed](https://www.twitter.com/shadeed9)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： [huanglizhuo](https://github.com/huanglizhuo)
* 校对者：[Kulbear](https://github.com/Kulbear) , [shixinzhang](https://github.com/shixinzhang)

# CSS writing-mode 的特别技巧

最近在 Opera inspector 中编辑 CSS 时，我第一次注意到有一个名为 `writing-mode` 的 css 属性。经过一番搜索，发现它是用于垂直排版的语言，比如中文或者日文。然而，有趣的是如果我们把它用在英语中，可以很方便的创建垂直文本。

>  writing-mode 属性定义了文字在文文字块中垂直或者水平方向，参考[MDN](https://developer.mozilla.org/en/docs/Web/CSS/writing-mode)。

## 默认的书写模式

支持这一属性的浏览器默认将这一属性设置为 `horizontal-tb` 。这将作用于水平排版的语言比如英语，法语，阿拉伯语等等。

接下来我们将尝试 ` vertical-lr` 效果，lr 代表 从左到右 (Left to right)。

## 例子1
![](https://ishadeed.com/assets/writing-mode/example1.png)

在上面的设计中，我们在左上角有个段落标题旋转了90度。如果不用 CSS `writing-mode` 来实现的话，我们需要做如下的事：

1. 添加 `position:relative` 给要包裹的元素创建位置上下文。

2. `position:absolute` 给标题添加绝对位置。

3. 根据我们想要的旋转给它添加 transform-orgin 属性。在这个例子中我们想要把它放在左上角，因此我们添加 `transform-origin: left top` 。

4. 添加 `transform: rotate(90deg)` 旋转标题。

5. 最后，需要给包裹的左边元素添加些 padding 以防标题和网格内容重叠。

```
<section class="wrapper">
    <h2 class="section-title">Our Works</h2>  
    <div class="grid">
        <div class="grid__item"></div>
        <div class="grid__item"></div>
        <div class="grid__item"></div>
        <div class="grid__item"></div>
    </div>
</section>
```

    .wrapper {
        position: relative;
        padding-left: 70px;
    }
    
    .section-title {
        position: absolute;
        left: 0;
        transform-origin: left top;
        transform: rotate(90deg);
    }

做这样一个设计就需要这么多代码，好烦。现在看看用 CSS `writing-mode` 怎么 写吧：

    .section-title {
        writing-mode: vertical-lr;
    }

完成，就这么简单！:D 正如你所看到的，并不需要像之前那样，设置什么位置或者添加 padding 。看看下面这个 [Demo ](http://codepen.io/shadeed/pen/13edb031a3d18f30ce22360562039b5e/)

## 例子2
![](https://ishadeed.com/assets/writing-mode/example2.png)

在这次的设计中，我们在内容旁边垂直摆放着一个分享控件。我们确实可以不用 CSS `writing-mode` 就可以简单实现，但有意思的是当我们用 `writing-mdoe` 实现社交分享控件时，我们可以让它垂直居中(居左，居中，或者居右)。

正如例子中那样，社交分享按钮垂直靠在它的父元素顶部。通过改写 CSS `text-align` 属性就可以做到这样，比如：


    .social-widget {
        writing-mode: vertical-lr;
        text-align: right;
    }

![](https://ishadeed.com/assets/writing-mode/example2-2.png)

这次是靠着父元素的底部。很简单，对吧！ 下个例子中，将会垂直居中。

    .social-widget {
        writing-mode: vertical-lr;
        text-align: center;
    }

![](https://ishadeed.com/assets/writing-mode/example2-3.png)

参看 这个 [Demo](http://codepen.io/shadeed/pen/8a7e787c90e25ca3b03fa4c688aab303/)

说明一下：我已经不再用 icon font 而是[切换到](https://ishadeed.com/article/using-svg-icons/) SVG ，我用 icon font 只是为了演示。

## 浏览器支持

情况不错，有84.65%的浏览器支持这个属性。现在起你就可以使用这个属性来获得便利了（就如同在我们的例子中）。

看看下面这一片绿吧 ! :)


![](https://ishadeed.com/assets/writing-mode/caniuse-support.jpg)CSS Writing Mode support from caniuse.com

## 酷炫的前端社区 Demos 

- [Floated title with writing-mode](http://codepen.io/julianlengfelder/pen/VjBjoj) by Julian Lengfelder.
- [Clever Idea to center content horizontally and vertically](http://codepen.io/sleithart/pen/kXjLLk) By Sheffield.

## 延伸阅读

- 
[CSS Writing Mode](https://developer.mozilla.org/en/docs/Web/CSS/writing-mode)

- 
[Vertical text with CSS 3 Writing Modes](http://generatedcontent.org/post/45384206019/writing-modes)

喜欢我的文章，觉得可能帮助其它人 ？ 那么赶快在 [Twitter](http://twitter.com/share?text=CSS%20Writing%20Mode&amp;url=https://ishadeed.com/article/css-writing-mode/) 上分享它吧。

感谢你的阅读
