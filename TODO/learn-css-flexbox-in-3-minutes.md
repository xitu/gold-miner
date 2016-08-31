> * 原文地址：[Learn CSS Flexbox in 3 Minutes](https://medium.com/learning-new-stuff/learn-css-flexbox-in-3-minutes-c616c7070672)
* 原文作者：[Per Harald Borgen](https://medium.com/@perborgen)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

![](https://cdn-images-1.medium.com/max/800/1*baslR_nGORHYX4STOjhhpg.png)

In this post you’ll learn the **most important** concepts of the flexbox layout in CSS, which will make your life easier if you find yourself struggling with CSS layouts from time to time.

We’ll only focus on core principles, while leaving out stuff you **shouldn’t care about** until you’ve understood the basics.

**1\. The container and the item**

The two main components of a flexbox layout is the **container** (blue) and the **items** (red). In the example we’ll be looking at in this tutorial, both the **container** and **item** are _div’s._ Check out the [boilerplate code here](https://github.com/perborgen/FlexboxTutorial) if you’re interested.

#### Horizontal layout

To create a flex layout, simply give the **container** the following CSS property.

    .container {
        display: flex;
    }

Which will result in this layout:

![](https://cdn-images-1.medium.com/max/800/1*3zzvOetr1fjDrZKEEmo9dA.png)

Notice that you don’t need to do anything with the **items** yet. They’ll be nicely positioned along the horizontal axis automatically.

#### Vertical layout

In the layout above, the **main axis** is the horizontal one, and the **cross axis** is the vertical one. The concept of **axes** are important to understand in order to use flex properly.

You can swap the two axes by adding _flex-direction_: _column._

    .container {
        display: flex;
        flex-direction: column;
    }



![](https://cdn-images-1.medium.com/max/800/1*yPT-82-JPYk8b2Rh_3K6sQ.png)


Now the **main axis** is vertical and the **cross axis** horizontal, resulting in the **items** being stacked vertically.

### 2\. Justify content and Align items

To make list horizontal again, we can switch the _flex-direction_ from **column** to **row,** as thisflips the flex layout’s axes back again.

The reason the axes are important to understand is because the attributes _justify-content_ and _align-items_ control how the items are positioned along the **main axis** and **cross axis** respectively.

Let’s center all the items along the **main axis** by using **justify-content:**

    .container {
        display: flex;
        flex-direction: row;
        justify-content: center;
    }

![](https://cdn-images-1.medium.com/max/800/1*KAFfHDFWCd12qI3TqSS8DQ.png)

And let’s adjust them along the **cross axis,** using _align-items._

    .container {
        display: flex;
        flex-direction: row;
        justify-content: center;
        align-items: center;
    }



![](https://cdn-images-1.medium.com/max/800/1*S666Y69uJUWgQ0rz8tzjOQ.png)



Below are the other values you can set for _justify-content_ and _align-items:._

**justify-content:**

*   flex-start (**default**)
*   flex-end
*   center
*   space-between
*   space-around

**align-items:**

*   flex-start **(default)**
*   flex-end
*   center
*   baseline
*   stretch

I’d recommend you to play around with the _justify-content_ and _align-items_ properties in combination with the _flex-direction_ being both column & row. That should give you a proper understanding of the concept.

### 3\. The items

The last thing we’ll learn about is the **items** themselves, and how to add specific styles to each of them.

Let’s say we wanna adjust the position of the first item. We do this by giving it a CSS attribute of _align-self_, which accepts the exact same values as _align-items_:

    .item1 {
      align-self: flex-end;
    }

Resulting in the following layout:

![](https://cdn-images-1.medium.com/max/800/1*-NBG56jX-QKYaga6qiF0eg.png)

And that’s it!

There is of course a whole lot more to learn about flexbox, but the concepts above are the once I use the most often, and thus most important to understand properly.

