> * 原文地址：[CSS in 3D: Learning to Think in Cubes Instead of Boxes](https://css-tricks.com/css-in-3d-learning-to-think-in-cubes-instead-of-boxes/)
> * 原文作者：[Jhey Tompkins](https://css-tricks.com/author/jheytompkins/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/css-in-3d-learning-to-think-in-cubes-instead-of-boxes.md](https://github.com/xitu/gold-miner/blob/master/article/2021/css-in-3d-learning-to-think-in-cubes-instead-of-boxes.md)
> * 译者：
> * 校对者：

# CSS in 3D: Learning to Think in Cubes Instead of Boxes

My path to learning CSS was a little unorthodox. I didn’t start as a front-end developer. I was a Java developer. In fact, my earliest recollections of CSS were picking colors for things in Visual Studio.

It wasn’t until later that I got to tackle and find my love for the front end. And exploring CSS came later. When it did, it was around the time CSS3 was taking off. 3D and animation were the cool kids on the block. They almost shaped my learning of CSS. They drew me in and *shaped* (pun intended) my understanding of CSS more than other things, like layout, color, etc.

What I’m getting at is I’ve been doing the whole 3D CSS thing a minute. And as with anything you spend a lot of time with, you end up refining your process over the years as you hone that skill. This article is a look at how I’m currently approaching 3D CSS and goes over some tips and tricks that might help you!

[Codepen jh3y/mLaXRe](https://codepen.io/jh3y/pen/mLaXRe)

## Everything’s a cuboid

For most things, we can use a cuboid. We can create more complex shapes, for sure but they usually take a little more consideration. Curves are particularly hard and there are some tricks for handling them (but more on that later).

We aren’t going to walk through how to make a cuboid in CSS. We can reference [Ana Tudor’s post](https://css-tricks.com/simplifying-css-cubes-custom-properties/) for that, or check out this screencast of me making one:

[Screencast of making a cuboid](https://css-tricks.com/wp-content/uploads/2020/10/use-css-transforms-to-create-configurable-3d-cuboids.mp4).

At its core, we use one element to wrap our cuboid and then transform six elements within. Each element acts as a side to our cuboid. It’s important that we apply `transform-style: preserve-3d`. And it’s not a bad idea to apply it everywhere. It’s likely we’ll deal with nested cuboids when things get more complex. Trying to debug a missing `transform-style` while hopping between browsers can be painful.

```css
* {
    transform-style: preserve-3d;
}
```

[Codepen jh3y/QWELPQg](https://codepen.io/jh3y/pen/QWELPQg)

For your 3D creations that are more than a few faces, try and imagine the whole scene built from cuboids. For a real example, consider this demo of a 3D book. It’s four cuboids. One for each cover, one for the spine, and one for the pages. The use of `background-image` does the rest for us.

[Codepen jh3y/ZEOzNbm](https://codepen.io/jh3y/pen/ZEOzNbm)

## Setting a scene

We’re going to use cuboids like LEGO pieces. But, we can make our lives a little easier by setting a scene and creating a plane. That plane is where our creation will sit and makes it easier for us to rotate and move the whole creation.

[Codepen jh3y/pobzmNx](https://codepen.io/jh3y/pen/pobzmNx)

For me, when I create a scene, I like to rotate it on the X and Y axis first. Then I lay it flat with `rotateX(90deg)`. That way, when I want to add a new cuboid to the scene, I add it inside the plane element. Another thing I will do here is to set `position: absolute` on all cuboids.

```css
.plane {
    transform: rotateX(calc(var(--rotate-x, -24) * 1deg)) rotateY(calc(var(--rotate-y, -24) * 1deg)) rotateX(90deg) translate3d(0, 0, 0);
}
```

## Start with a boilerplate

Creating cuboids of various sizes and across a plane makes for a lot of repetition for each creation. For this reason, I use Pug to create my cuboids via a mixin. If you’re not familiar with Pug, I wrote a [5-minute intro](https://dev.to/jh3y/pug-in-5-minutes-272k).

A typical scene looks like this:

```pug
//- Front
//- Back
//- Right
//- Left
//- Top
//- Bottom
mixin cuboid(className)
  .cuboid(class=className)
    - let s = 0
    while s < 6
      .cuboid__side
      - s++
.scene
  //- Plane that all the 3D stuff sits on
  .plane
    +cuboid('first-cuboid')
```

As for the CSS. My cuboid class is currently looking like this:

```css
.cuboid {
    /* Defaults */
    --width: 15;
    --height: 10;
    --depth: 4;
    height: calc(var(--depth) * 1vmin);
    width: calc(var(--width) * 1vmin);
    transform-style: preserve-3d;
    position: absolute;
    font-size: 1rem;
    transform: translate3d(0, 0, 5vmin);
}

.cuboid > div:nth-of-type(1) {
    height: calc(var(--height) * 1vmin);
    width: 100%;
    transform-origin: 50% 50%;
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%) rotateX(-90deg) translate3d(0, 0, calc((var(--depth) / 2) * 1vmin));
}

.cuboid > div:nth-of-type(2) {
    height: calc(var(--height) * 1vmin);
    width: 100%;
    transform-origin: 50% 50%;
    transform: translate(-50%, -50%) rotateX(-90deg) rotateY(180deg) translate3d(0, 0, calc((var(--depth) / 2) * 1vmin));
    position: absolute;
    top: 50%;
    left: 50%;
}

.cuboid > div:nth-of-type(3) {
    height: calc(var(--height) * 1vmin);
    width: calc(var(--depth) * 1vmin);
    transform: translate(-50%, -50%) rotateX(-90deg) rotateY(90deg) translate3d(0, 0, calc((var(--width) / 2) * 1vmin));
    position: absolute;
    top: 50%;
    left: 50%;
}

.cuboid > div:nth-of-type(4) {
    height: calc(var(--height) * 1vmin);
    width: calc(var(--depth) * 1vmin);
    transform: translate(-50%, -50%) rotateX(-90deg) rotateY(-90deg) translate3d(0, 0, calc((var(--width) / 2) * 1vmin));
    position: absolute;
    top: 50%;
    left: 50%;
}

.cuboid > div:nth-of-type(5) {
    height: calc(var(--depth) * 1vmin);
    width: calc(var(--width) * 1vmin);
    transform: translate(-50%, -50%) translate3d(0, 0, calc((var(--height) / 2) * 1vmin));
    position: absolute;
    top: 50%;
    left: 50%;
}

.cuboid > div:nth-of-type(6) {
    height: calc(var(--depth) * 1vmin);
    width: calc(var(--width) * 1vmin);
    transform: translate(-50%, -50%) translate3d(0, 0, calc((var(--height) / 2) * -1vmin)) rotateX(180deg);
    position: absolute;
    top: 50%;
    left: 50%;
}
```

Which, by default, gives me something like this:

## Powered by CSS variables

You may have noticed a fair few CSS variables (aka custom properties) in there. This is a big time-saver. I’m powering my cuboids with CSS variables.

* `--width`: The width of a cuboid on the plane
* `--height`: The height of a cuboid on the plane
* `--depth`: The depth of a cuboid on the plane
* `--x`: The X position on the plane
* `--y`: The Y position on the plane

I use `vmin` mostly as my sizing unit to keep everything responsive. If I’m creating something to scale, I might create a responsive unit. We mentioned this technique in a [previous article](https://css-tricks.com/advice-for-complex-css-illustrations/). Again, I lay the plane down flat. Now I can refer to my cuboids as having height, width, and depth. This demo shows how we can move a cuboid around the plane changing its dimensions.

[Codepen jh3y/BaKqQLJ](https://codepen.io/jh3y/pen/BaKqQLJ)

## Debugging with dat.GUI

You might have noticed that little panel in the top right for some of the demos we’ve covered. That’s [dat.](https://github.com/dataarts/dat.gui)[GUI](https://github.com/dataarts/dat.gui)[.](https://github.com/dataarts/dat.gui) It’s a lightweight controller library for JavaScript that super useful for debugging 3D CSS. With not much code, we can set up a panel that allows us to change CSS variables at runtime. One thing I like to do is use the panel to rotate the plane on the X and Y-axis. That way, it’s possible to see how things are lining up or work on a part that you might not see at first.

```javascript
const {
    dat: {GUI},
} = window
const CONTROLLER = new GUI()
const CONFIG = {
    'cuboid-height': 10,
    'cuboid-width': 10,
    'cuboid-depth': 10,
    x: 5,
    y: 5,
    z: 5,
    'rotate-cuboid-x': 0,
    'rotate-cuboid-y': 0,
    'rotate-cuboid-z': 0,
}
const UPDATE = () => {
    Object.entries(CONFIG).forEach(([key, value]) => {
        document.documentElement.style.setProperty(`--${key}`, value)
    })
}
const CUBOID_FOLDER = CONTROLLER.addFolder('Cuboid')
CUBOID_FOLDER.add(CONFIG, 'cuboid-height', 1, 20, 0.1)
    .name('Height (vmin)')
    .onChange(UPDATE)
CUBOID_FOLDER.add(CONFIG, 'cuboid-width', 1, 20, 0.1)
    .name('Width (vmin)')
    .onChange(UPDATE)
CUBOID_FOLDER.add(CONFIG, 'cuboid-depth', 1, 20, 0.1)
    .name('Depth (vmin)')
    .onChange(UPDATE)
// You have a choice at this point. Use x||y on the plane
// Or, use standard transform with vmin.
CUBOID_FOLDER.add(CONFIG, 'x', 0, 40, 0.1)
    .name('X (vmin)')
    .onChange(UPDATE)
CUBOID_FOLDER.add(CONFIG, 'y', 0, 40, 0.1)
    .name('Y (vmin)')
    .onChange(UPDATE)
CUBOID_FOLDER.add(CONFIG, 'z', -25, 25, 0.1)
    .name('Z (vmin)')
    .onChange(UPDATE)
CUBOID_FOLDER.add(CONFIG, 'rotate-cuboid-x', 0, 360, 1)
    .name('Rotate X (deg)')
    .onChange(UPDATE)
CUBOID_FOLDER.add(CONFIG, 'rotate-cuboid-y', 0, 360, 1)
    .name('Rotate Y (deg)')
    .onChange(UPDATE)
CUBOID_FOLDER.add(CONFIG, 'rotate-cuboid-z', 0, 360, 1)
    .name('Rotate Z (deg)')
    .onChange(UPDATE)
UPDATE()
```

If you watch the timelapse video in this tweet. You’ll notice that I rotate the plane a lot as I build up the scene.

[Twitter jh3yy](https://twitter.com/jh3yy/status/1312126353177673732?s=20)

That dat.GUI code is a little repetitive. We can create functions that will take a configuration and generate the controller. It takes a little tinkering to cater to your needs. I started playing with dynamically generated controllers in [this demo](https://codepen.io/jh3y/pen/GRJoWyp).

## Centering

You may have noticed that by default each cuboid is half under and half above the plane. That’s intentional. It’s also something I only recently started to do. Why? Because we want to use the containing element of our cuboids as the center of the cuboid. This makes animation easier. Especially, if we’re considering rotating around the Z-axis. I found this out when creating “CSS is Cake”. After making the cake, I then decided I wanted each slice to be interactive. I then had to go back and change my implementation to fix the rotation center of the flipping slice.

[Codepen jh3y/KKVGoGJ](https://codepen.io/jh3y/pen/KKVGoGJ)

Here I’ve broken that demo down to show the centers and how having an offset center would affect the demo.

[Codepen jh3y/XWKrLwe](https://codepen.io/jh3y/pen/XWKrLwe)

## Positioning

If we are working with a scene that’s more complex, we may split it up into different sections. This is where the concept of sub-planes comes in handy. Consider this demo where I’ve recreated my personal workspace.

[Twitter jh3yy](https://twitter.com/jh3yy/status/1310658720746045440?s=20).

There’s quite a bit going on here and it’s hard to keep track of all the cuboids. For that, we can introduce sub-planes. Let’s break down that demo. The chair has its own sub-plane. This makes it easier to move it around the scene and rotate it — among other things — without affecting anything else. In fact, we can even spin the top without moving the feet!

[Codepen jh3y/QWELerg](https://codepen.io/jh3y/pen/QWELerg)

## Aesthetics

Once we’ve got a structure, it’s time to work on the aesthetics. This all depends on what you’re making. But you can get some quick wins from using certain techniques. I tend to start by making things “ugly” then go back and make CSS variables for all the colors and apply them. Three shades for a certain thing allows us to differentiate the sides of a cuboid visually. Consider this toaster example. Three shades cover the sides of the toaster:

[Codepen jh3y/KKVjLrx](https://codepen.io/jh3y/pen/KKVjLrx)

Our Pug mixin from earlier allows us to define class names for a cuboid. Applying color to a side usually looks something like this:

```css
/* The front face uses a linear-gradient to apply the shimmer effect */
.toaster__body > div:nth-of-type(1) {
    background: linear-gradient(120deg, transparent 10%, var(--shine) 10% 20%, transparent 20% 25%, var(--shine) 25% 30%, transparent 30%), var(--shade-one);
}

.toaster__body > div:nth-of-type(2) {
    background: var(--shade-one);
}

.toaster__body > div:nth-of-type(3),
.toaster__body > div:nth-of-type(4) {
    background: var(--shade-three);
}

.toaster__body > div:nth-of-type(5),
.toaster__body > div:nth-of-type(6) {
    background: var(--shade-two);
}
```

It’s a little tricky to include extra elements with our Pug mixin. But let’s not forget, every side to our cuboid offers two pseudo-elements. We can use these for various details. For example, the toaster slot and the slot for the handle on the side are pseudo-elements.

Another trick is to use `background-image` for adding details. For example, consider the 3D workspace. We can use background layers to create shading. We can use actual images to create textured surfaces. The flooring and the rug are a repeating `background-image`. In fact, using a pseudo-element for textures is great because then we can transform them if needed, like rotating a tiled image. I’ve also found that I get flickering in some cases working directly with a cuboid side.

[Codepen jh3y/XWdQBRx](https://codepen.io/jh3y/pen/XWdQBRx)

One issue with using an image for texture is how we create different shades. We need shades to differentiate the different sides. That’s where the `filter` property can help. Applying a `brightness``()` filter to the different sides of a cuboid can lighten or darken them. Consider this CSS flipping table. All the surfaces are using a texture image. But to differentiate the sides, brightness filters are applied.

[Codepen jh3y/xJXvjP](https://codepen.io/jh3y/pen/xJXvjP)

How about shapes — or features we want to create that seem impossible — using a finite set of elements? Sometimes we can trick the eye with a little smoke and mirrors. We can provide a “faux” like sense of 3D. The [Z](https://zzz.dog)[dog](https://zzz.dog) [library](https://zzz.dog) does this well and is a good example of this.

Consider this bundle of balloons. The strings holding them use the correct perspective and each has its own rotation, tilt, etc. But the balloons themselves are flat. If we rotate the plane, the balloons maintain the counter plane rotation. And this gives that “faux” 3D impression. Try out the demo and switch off the countering.

[Codepen jh3y/NWNVgJw](https://codepen.io/jh3y/pen/NWNVgJw)

Sometimes it takes a little out-of-the-box thinking. I had a house plant suggested to me as I built the 3D workspace. I have a few in the room. My initial thought was, “No, I can make a square pot, and how would I make all the leaves?” Well actually, we can use some eye tricks on this one too. Grab a stock image of some leaves or a plant. Remove the background with a tool like [remove.bg](https://www.remove.bg). Then position many images in the same spot but rotate them each a certain amount. Now, when they’re rotated, we get the impression of a 3D plant.

[Codepen jh3y/oNLNZMR](https://codepen.io/jh3y/pen/oNLNZMR)

## Tackling awkward shapes

Awkward shapes are tough to cover in a generic way. Every creation has its own hurdles. But, there is a couple of examples that could help give you ideas for tackling things. I recently read an article about the [UX of LEGO interface panels](https://www.designedbycave.co.uk/2020/LEGO-Interface-UX/). In fact, approaching 3D CSS work like it’s a LEGO set isn’t a bad idea. But the LEGO interface panel is a shape we could make with CSS (minus the studs — I only recently learned this is what they are called). It’s a cuboid to start with. Then we can clip the top face, make the end face transparent, and rotate a pseudo-element to join it up. We can use the pseudo-element for adding the details with some background layers. Try turning the wireframe on and off in the demo below. If we want the exact heights and angles for the faces, we can use some math to workout the hypoteneuse etc.

[Codepen jh3y/PozojYe](https://codepen.io/jh3y/pen/PozojYe)

Another awkward thing to cover is curves. Spherical shapes are not in the CSS wheelhouse. We have various options at this point. One option is to embrace that fact and create polygons with a finite number of sides. Another is to create rounded shapes and use the rotation method we mentioned with the plant. Each of these options could work. But again, it’s on a use case basis. Each has pros and cons. With the polygon, we surrender the curves or use so many elements that we get an almost curve. The latter could result in performance issues. With the perspective trick, we may also end up with performance issues depending. We also surrender being able to style the “sides” of the shape as there aren’t any.

[Codepen jh3y/wvWvqqM](https://codepen.io/jh3y/pen/wvWvqqM)

## Z fighting

Last, but not least, it’s worth mentioning “Z-fighting.” This is where certain elements on a plane may overlap or cause an undesirable flicker. It’s hard to give good examples of this. There’s not a generic solution for it. It’s something to tackle on a case-by-case basis. The main strategy is to order things in the DOM as appropriate. But sometimes that’s not the only issue.

Being accurate can sometimes cause issues. Let’s refer to the 3D workspace again. Consider the canvas on the wall. The shadow is a pseudo-element. If we place the canvas exactly against the wall, we are going to hit issues. If we do that, the shadow and the wall are going to fight for the front position. To combat this, we can translate things by a slight amount. That will solve the issue and declare what should sit in front.

[Codepen jh3y/PozoYWK](https://codepen.io/jh3y/pen/PozoYWK)

Try resizing this demo with the “Canvas offset” on and off. Notice how the shadow flickers when there is no offset? That’s because the shadow and the wall are fighting for view. The offset sets the `--x` to a fraction of `1vmin` that we’ve named `--cm`. That’s a responsive unit being used for that creation.

## That’s “it”!

Take your CSS to another dimension. Use some of my tips, create your own, share them, and share your 3D creations! Yes, making 3D things in CSS can be tough and is definitely a process that we can refine as we go along. Different approaches work for different people and patience is a required ingredient. I’m interested to see where you take your approach!

The most important thing? Have fun with it!

[Codepen jh3y/MWeWvGO](https://codepen.io/jh3y/pen/MWeWvGO)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
