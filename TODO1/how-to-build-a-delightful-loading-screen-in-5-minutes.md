> * 原文地址：[How to Build a Delightful Loading Screen in 5 Minutes](https://medium.freecodecamp.org/how-to-build-a-delightful-loading-screen-in-5-minutes-847991da509f)
> * 原文作者：[Ohans Emmanuel](https://medium.freecodecamp.org/@ohansemmanuel?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-build-a-delightful-loading-screen-in-5-minutes.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-build-a-delightful-loading-screen-in-5-minutes.md)
> * 译者：
> * 校对者：

# How to Build a Delightful Loading Screen in 5 Minutes

First, here is what we will build. Set your timer!

![](https://cdn-images-1.medium.com/max/800/1*AF1rXY_iumutiVOMSXf_LQ.gif)

Here’s the [DEMO](https://codepen.io/ohansemmanuel/pen/ZxOjGx) we’ll build.

Does this look familiar?

If yes, that’s because you’ve seen this somewhere — [Slack](https://slack.com)!

Let’s learn a few things by recreating this with just CSS and some good ol’ HTML.

If you’re excited about writing some code, get on [Codepen](http://codepen.io) and create a new pen.

Now, let’s go!

#### 1. The Markup

The markup required for this is quite simple. Here it is:

```
<section class="loading">

For new sidebar colors, click your workspace name, then     Preferences > Sidebar > Theme

<span class="loading__author"> - Your friends at Slack</span>
    <span class="loading__anim"></span>

</section>
```

Simple, huh?

If you’re not sure why the class names have weird dashes, I explained the reason behind that in [this article](https://medium.freecodecamp.org/css-naming-conventions-that-will-save-you-hours-of-debugging-35cea737d849).

There’s a bunch of text, and a `.loading__anim` span to “impersonate” the animated icon.

The result of this is the simple view below.

![](https://cdn-images-1.medium.com/max/800/1*RpS6k11QbgHRIuAvy1Hw5Q.png)

Not so bad, huh?

#### 2. Center the Content

The result isn’t the prettiest of stuff to behold. Let’s have the entire `.loading`section element entered in the page.

```
body {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
}
```

![](https://cdn-images-1.medium.com/max/800/1*MPjfL4fwZlLkoja4cNg-Zg.png)

Now centered!

Looking better?

#### 3. Style the Loading text

I know. We will get to the animated stuff soon. For now, let’s style the `.loading` text to look a lot better.

```
.loading {
  max-width: 50%;
  line-height: 1.4;
  font-size: 1.2rem;
  font-weight: bold;
  text-align: center;
}
```

![](https://cdn-images-1.medium.com/max/800/1*wmMG_h5lJURLsYEZLv8ltw.png)

#### 4. Style the author text to look slightly different.

```
.loading__author {
  font-weight: normal;
  font-size: 0.9rem;
  color: rgba(189,189,189 ,1);
  margin: 0.6rem 0 2rem 0;
  display: block;
}
```

There you go!

![](https://cdn-images-1.medium.com/max/800/1*uok3Fg7Kqd8ASbONmK1RSA.png)

#### 5. Create the animated loader

The much-anticipated step is here. This is going to be the longest of the steps, because I’ll be spending some time to make sure you understand how it works.

If you get stuck, drop a comment and I’ll be happy to help.

Hey, have a look at the loader again.

![](https://cdn-images-1.medium.com/max/800/1*AF1rXY_iumutiVOMSXf_LQ.gif)

You’ll notice that half of its stroke is blue and the other half is grey. Okay, that’s sorted out. Also, `HTML` elements aren’t rounded by default. Everything is a _box_ element. The first real challenge will be how to give the `.loading__anim` element half borders.

Don’t worry if you don’t understand this yet. I’ll come back to it.

First, let’s sort out the dimensions of the loader.

```
.loading__anim {
  width: 35px;
  height: 35px;
 }
```

Right now, the loader is on the same line as the text. That’s because it is a `span` element which happens to be an `HTML` **inline** element.

Let’s make sure the loader seats on another line, that is it begins on another line as opposed to the default behavior of `inline` elements.

```
.loading__anim {
   width: 35px;
   height: 35px;
   display: inline-block;
  }
```

Finally, let’s make sure the loader has some border set.

```
.loading__anim {
   width: 35px;
   height: 35px;
   display: inline-block;
   border: 5px solid rgba(189,189,189 ,0.25);
  }
```

This will give a _greyish_ `5px` border around the element.

Now, here’s the result of that.

![](https://cdn-images-1.medium.com/max/800/1*6IaPRnPBuODTJT6mm9dNFw.png)

You see the grey borders, right?

Not so great — yet. Let’s make this even better.

An element has four sides, `top`, `bottom`,`left`, and `right`

The `border` declaration we set earlier was applied to all the sides of the element.

To create the loader, we need two sides of the element to have different colors.

It doesn’t matter what sides you choose. I have used the `top` and `left` sides below

```
.loading__anim {
  width: 35px;
  height: 35px;
  display: inline-block;
  border: 5px solid rgba(189,189,189 ,0.25);
  border-left-color: rgba(3,155,229 ,1);
  border-top-color: rgba(3,155,229 ,1);
  }
```

Now, the `left` and `top` sides will have a _blueish_ color for their borders. Here’s the result of that:

![](https://cdn-images-1.medium.com/max/800/1*bq8bUGVNglafbnDDj_beFw.png)

hmmmm. looking nice.

We’re getting somewhere!

The loader is round, NOT rectangular. Let’s change this by giving the `.loader__anim` element a `border-radius` of `50%`

Now we have this:

![](https://cdn-images-1.medium.com/max/800/1*Krr3W7AwgW3ZThim62VZtg.png)

Not so bad, huh?

The final step is to animate this.

```
@keyframes rotate {
 to {
  transform: rotate(1turn)
 }
}
```

Hopefully, you have an idea of how [CSS animations](https://www.w3schools.com/css/css3_animations.asp) work. `1turn` is equal to `360deg` , that is a complete turn rotates 360 degrees.

And apply it like this:

```
animation: rotate 600ms infinite linear;
```

Yo! We did it. Does that all make sense?

By the way, see the result below:

![](https://cdn-images-1.medium.com/max/800/1*DQFXH8zH4RpOFOqOb4DbMg.gif)

lo hicimos! (Spanish)

Pretty cool, huh?

If any of the steps confused you, drop a comment and I’ll be happy to help.

### Ready to become Pro?

I have created a free CSS guide to get your CSS skills blazing, immediately. [Get the free ebook.](http://eepurl.com/dgDVRb)

![](https://cdn-images-1.medium.com/max/800/1*fJabzNuhWcJVUXa3O5OlSQ.png)

Seven CSS Secrets you didn’t know about.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
