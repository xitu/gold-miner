> * 原文地址：[CSS Writing Mode](https://ishadeed.com/article/css-writing-mode/)
* 原文作者：[Ahmad Shadeed](https://www.twitter.com/shadeed9)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： 
* 校对者： 

Recently, while editing some CSS in Opera inspector, I noticed a CSS property called `writing-mode`, this was the first time that I know of it. After some research, I learned that its purpose is for vertical language scripts, like Chinese or Japanese. However, the interesting thing is that when using it with English, we can create a vertical text very easily.

> The writing-mode property defines whether lines of text are laid out horizontally or vertically and the direction in which blocks progress. As of [MDN](https://developer.mozilla.org/en/docs/Web/CSS/writing-mode)

## The default writing mode

Browser agents that support this propery will have `horizontal-tb` as the default value. This work for horizontal language scripts like: English, French, Arabic.. etc

We will explore the value of `vertical-lr`, lr stands for (Left to right).

## Example 1
![](https://ishadeed.com/assets/writing-mode/example1.png)Example 1 - CSS Writing Mode
In the above design, we have a section title that is rotated 90deg around the top left of it’s origin. If you want to this without CSS `writing-mode`, we need to do the following: 

1. Create a positioning context for the wrapper element by adding `position:relative`.
2. Position the title absolutely by adding `position: absolute`. 
3. Change the transform origin based on how we want to rotate it. In our case we want to change it to the top left corner, so we add `transform-origin: left top`.
4. Rotate the title by adding `transform: rotate(90deg)`.
5. Finally, we need to add some padding on the left side of the wrapper element in order to prevent the overlap between the section title and grid items.

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

A lot of work to do for such design, right? Lets explore how this could be done using CSS `writing-mode`:

    .section-title {
        writing-mode: vertical-lr;
    }

We’re done! :D As you see, there is no need to position anything or add padding as we did. Checkout the demo below:
[See the Pen](http://codepen.io/shadeed/pen/13edb031a3d18f30ce22360562039b5e/)

## Example 2
![](https://ishadeed.com/assets/writing-mode/example2.png)Example 2 - CSS Writing Mode
With the above design, we have a sharing widget that is placed vertically beside the content. It’s true that we can make this easily without CSS `writing-mode`, but the interseting thing is that when using it with the social widget, we will get the ability to vertically center it (left, center or right). 

As in the example, the social widget is vertically aligned to the top of it’s parent. By changing CSS `text-align` propery, we can change the position of it. For example:

    .social-widget {
        writing-mode: vertical-lr;
        text-align: right;
    }

![](https://ishadeed.com/assets/writing-mode/example2-2.png)Example 2 - CSS Writing Mode
This will align it to the bottom of it’s parent! Easy, right? In the next example, it will be centered vertically.

    .social-widget {
        writing-mode: vertical-lr;
        text-align: center;
    }

![](https://ishadeed.com/assets/writing-mode/example2-3.png)Example 2 - CSS Writing Mode
And here is the demo for the social widget:
[See the Pen](http://codepen.io/shadeed/pen/8a7e787c90e25ca3b03fa4c688aab303/)

Disclaimer: I stopped using icon fonts and [switched](https://ishadeed.com/article/using-svg-icons/) to SVG, I’m using the icon fonts for the sake of the demo only.

## Browsers Support

The global support is 84.65% and this is really good. You can use the property today in order to get benefit like we did in our examples.

Look at that green! :)

![](https://ishadeed.com/assets/writing-mode/caniuse-support.jpg)CSS Writing Mode support from caniuse.com

## Demos from our awesome Front-End Community

- [Floated title with writing-mode](http://codepen.io/julianlengfelder/pen/VjBjoj) by Julian Lengfelder.
- [Clever Idea to center content horizontally and vertically](http://codepen.io/sleithart/pen/kXjLLk) By Sheffield.

## Further reading

- 
[CSS Writing Mode](https://developer.mozilla.org/en/docs/Web/CSS/writing-mode)

- 
[Vertical text with CSS 3 Writing Modes](http://generatedcontent.org/post/45384206019/writing-modes)

Liked my article and think others might find it useful?
  [Share it on Twitter](http://twitter.com/share?text=CSS%20Writing%20Mode&amp;url=https://ishadeed.com/article/css-writing-mode/)

Thank you for reading.
