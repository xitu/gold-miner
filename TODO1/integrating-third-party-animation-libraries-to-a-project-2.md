> * 原文地址：[Integrating Third-Party Animation Libraries to a Project - Part 2](https://css-tricks.com/integrating-third-party-animation-libraries-to-a-project/)
> * 原文作者：[Travis Almand](https://css-tricks.com/author/travisalmand/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/integrating-third-party-animation-libraries-to-a-project-2.md](https://github.com/xitu/gold-miner/blob/master/TODO1/integrating-third-party-animation-libraries-to-a-project-2.md)
> * 译者：
> * 校对者：

# Integrating Third-Party Animation Libraries to a Project - Part 2

> - [Integrating Third-Party Animation Libraries to a Project - Part 1](https://github.com/xitu/gold-miner/blob/master/TODO1/integrating-third-party-animation-libraries-to-a-project-1.md)
> - [Integrating Third-Party Animation Libraries to a Project - Part 2](https://github.com/xitu/gold-miner/blob/master/TODO1/integrating-third-party-animation-libraries-to-a-project-2.md)

## Moving stuff out of the way

When researching for this article, I found that transitions (not to be confused with CSS transitions) are easily the most common type of animations in the third-party libraries. These are simple animations that are built to allow an element to enter or leave the page. A very common pattern seen in modern Single Page Applications is to have one element leave the page while another replaces it by entering the page. Think of the first element fading out and the second fading in. This could be replacing old data with new data, moving to the next panel in a sequence, or moving from one page to another with a router. Both [Sarah Drasner](https://css-tricks.com/native-like-animations-for-page-transitions-on-the-web/) and [Georgy Marchuk](https://css-tricks.com/page-transitions-for-everyone/) have excellent examples of these types of transitions.

For the most part, animation libraries will not provide the means to remove and add elements during the transition animations. The libraries that provide additional JavaScript may actually have this functionality, but since most do not, we’ll discuss how to handle this functionality now.

### Inserting a single element

For this example, we’ll again use Animate.css as our library. In this case, I’ll be using the `fadeInDown` animation.

Now, please keep in mind there are many ways to handle inserting an element into the DOM and I don’t wish to cover them here. I’ll just be showing how to leverage an animation to make the insertion nicer and more natural than the element simply popping into view. For Animate.css (and likely many other libraries), inserting an element with the animation is quite easy.

```javascript
let insertElement = document.createElement('div');
insertElement.innerText = 'this div is inserted';
insertElement.classList.add('animated', 'fadeInDown');

insertElement.addEventListener('animationend', function () {
  this.classList.remove('animated', 'fadeInDown');
});

document.body.append(insertElement);
```

However you decide to create the element doesn’t much matter; you just need to be sure the needed classes are already applied before inserting the element. Then it’ll nicely animate into place. I also included an event listener for the `animationend` event that removes the classes. As usual, there are several ways to go about doing this and this is likely the most direct way to handle it. The reason for removing the classes is to make it easier to reverse the process if we wish. We wouldn’t want the entering animation competing with a leaving animation.

### Removing a single element

Removing a single element is sort of similar to inserting an element. The element already exists, so we just apply the desired animation classes. Then at the `animationend` event we remove the element from the DOM. In this example, we’ll use the `fadeOutDown` animation from Animate.css because it works nicely with the `fadeInDown` animation.

```javascript
let removeElement = document.querySelector('#removeElement');

removeElement.addEventListener('animationend', function () {
  this.remove();
});

removeElement.classList.add('animated', 'fadeOutDown');
```

As you can see, we target the element, add the classes, and remove the element at the end of the animation.

An issue with all this is that with inserting and removing elements this way will cause the other elements on the page to jump around to adjust. You’ll have to account for that in some way, most likely with CSS and the layout of the page to keep a constant space for the elements.

### Get out of my way, I’m coming through!

Now we are going to swap two elements, one leaving while another enters. There are several ways of handling this, but I’ll provide an example that’s essentially combining the previous two examples.

See the Pen [
3rd Party Animation Libraries: Transitioning Two Elements](https://codepen.io/talmand/pen/JqPLbm/) by Travis Almand ([@talmand](https://codepen.io/talmand)) on [CodePen](https://codepen.io).

I’ll go over the JavaScript in parts to explain how it works. First, we cache a reference to a button and the container for the two elements. Then, we create two boxes that’ll be swapped inside the container.

```javascript
let button = document.querySelector('button');
let container = document.querySelector('.container');
let box1 = document.createElement('div');
let box2 = document.createElement('div');
```

I have a generic function for removing the animation classes for each `animationEnd` event.

```javascript
let removeClasses = function () {
  box1.classList.remove('animated', 'fadeOutRight', 'fadeInLeft');
  box2.classList.remove('animated', 'fadeOutRight', 'fadeInLeft');
}
```

The next function is the bulk of the swapping functionality. First, we determine the current box being displayed. Based on that, we can deduce the leaving and entering elements. The leaving element gets the event listener that called the `switchElements` function removed first so we don’t find ourselves in an animation loop. Then, we remove the leaving element from the container since its animation has finished. Next, we add the animation classes to the entering element and append it to the container so it’ll animate into place.

```javascript
let switchElements = function () {
  let currentElement = document.querySelector('.container .box');
  let leaveElement = currentElement.classList.contains('box1') ? box1 : box2;
  let enterElement = leaveElement === box1 ? box2 : box1;
  
  leaveElement.removeEventListener('animationend', switchElements);
  leaveElement.remove();
  enterElement.classList.add('animated', 'fadeInLeft');
  container.append(enterElement);
}
```

We need to do some general setup for the two boxes. Plus, we append the first box to the container.

```javascript
box1.classList.add('box', 'box1');
box1.addEventListener('animationend', removeClasses);
box2.classList.add('box', 'box2');
box2.addEventListener('animationend', removeClasses);

container.appendChild(box1);
```

Finally, we have a click event listener for our button that does the toggling. How these sequences of events are started is technically up to you. For this example, I decided on a simple button click. I figure out which box is currently being displayed, which will be leaving, to apply the appropriate classes to make it animate out. Then I apply an event listener for the `animationEnd` event that calls the `switchElements` function shown above that handles the actual swap.

```javascript
button.addEventListener('click', function () {
  let currentElement = document.querySelector('.container .box');
  
  if (currentElement.classList.contains('box1')) {
    box1.classList.add('animated', 'fadeOutRight');
    box1.addEventListener('animationend', switchElements);
  } else {
    box2.classList.add('animated', 'fadeOutRight');
    box2.addEventListener('animationend', switchElements);
  }
}
```

One obvious issue with this example is that it is extremely hard-coded for this one situation. Although, it can be easily extended and adjusted for different situations. So, the example is useful in terms of understanding one way of handling such a task. Thankfully, some animation libraries, like [MotionUI](https://zurb.com/playground/motion-ui), provide some JavaScript to help with element transitions. Another thing to consider is that some JavaScript frameworks, such as [VueJS](https://vuejs.org/v2/guide/transitions.html)) have functionality to assist with animating element transitions.

I have also created another example that provides a more flexible system. It consists of a container that stores references to leave and enter animations with data attributes. The container holds two elements that will switch places on command. The way this example is built is that the animations are easily changed in the data attributes via JavaScript. I also have two containers in the demo; one using Animate.css and the other using Animista for animations. It’s a large example, so I won’t examine code here; but it is heavily commented, so take a look if it is of interest.

See the Pen [3rd Party Animation Libraries: Custom Transition Example](https://codepen.io/talmand/pen/mYdeBb/) by Travis Almand ([@talmand](https://codepen.io/talmand)) on [CodePen](https://codepen.io).

## Take a moment to consider...

Does everyone actually want to see all these animations? Some people could consider our animations over-the-top and unnecessary, but for some, they can actually cause problems. Some time ago, WebKit introduced the [`prefers-reduced-motion`](https://webkit.org/blog/7551/responsive-design-for-motion/) media query to assist with possible [Vestibular Spectrum Disorder](https://alistapart.com/article/accessibility-for-vestibular/) issues. Eric Bailey also [posted a nice introduction](https://css-tricks.com/introduction-reduced-motion-media-query/) to the media query, as well as [a follow-up with considerations for best practices](https://css-tricks.com/revisiting-prefers-reduced-motion-the-reduced-motion-media-query/). Definitely read these.

So, does your animation library of choice support the `prefers-reduced-motion`? If the documentation doesn’t say that it does, then you may have to assume it does not. Although, it is rather easy to check the code of the library to see if there is anything for the media query. For instance, Animate.css has it in the [`_base.scss`](https://github.com/daneden/animate.css/blob/0ca8f2dc7c74c9e76b93bc378dad8b1cc1590dad/source/_base.css#L46) partial file.

```css
@media (print), (prefers-reduced-motion) {
  .animated {
    animation: unset !important;
    transition: none !important;
  }
}
```

This bit of code also provides an excellent example of how to do this for yourself if the library doesn’t support it. If the library has a common class it uses — like Animate.css uses "animated" — then you can just target that class. If it does not support such a class then you’ll have to target the actual animation class or create your own custom class for that purpose.

```css
.scale-up-center {
  animation: scale-up-center 0.4s cubic-bezier(0.390, 0.575, 0.565, 1.000) both;
}

@keyframes scale-up-center {
  0% { transform: scale(0.5); }
  100% { transform: scale(1); }
}

@media (print), (prefers-reduced-motion) {
  .scale-up-center {
    animation: unset !important;
    transition: none !important;
  }
}
```

As you can see, I just used the example as provided by Animate.css and targeted the animation class from Animista. Keep in mind that you’ll have to repeat this for every animation class you choose to use from the library. Although, in Eric’s follow-up piece, [he suggests treating all animations as progressive enhancement](https://css-tricks.com/revisiting-prefers-reduced-motion-the-reduced-motion-media-query/#article-header-id-4) and that could be one way to both reduce code and make a more accessible user experience.

## Let a framework do the heavy lifting for you

In many ways, the various frameworks such as React and Vue can make using third-party CSS animation easier than with vanilla JavaScript, mainly because you don’t have to wire up the class swaps or `animationend` events manually. You can leverage the functionality the frameworks already provide. The beauty of using frameworks is that they also provide several different ways of handling these animations depending on the needs of the project. The examples below is only a small example of options.

### Hover effects

For hover effects, I would suggest setting them up with CSS (as I suggested above) as the better way to go. If you really need a JavaScript solution in a framework, such as Vue, it would be something like this:

```html
<button @mouseover="over($event, 'tada')" @mouseleave="leave($event, 'tada')">
  tada
</button>
```

```javascript
methods: {
  over: function(e, type) {
    e.target.classList.add('animated', type);
  },
  leave: function (e, type) {
    e.target.classList.remove('animated', type);
  }
}
```

Not really that much different than the vanilla JavaScript solution above. Also, as before, there are many ways of handling this.

### Attention seekers

Setting up the attention seekers is actually even easier. In this case, we’re just applying the classes we require, again, using Vue as an example:

```html
<div :class="{animated: isPulse, pulse: isPulse}">pulse</div>

<div :class="[{animated: isBounce, bounce: isBounce}, 'infinite']">bounce</div>
```

In the pulse example, whenever the boolean `isPulse` is true, the two classes are applied. In the bounce example, whenever the boolean `isBounce` is true the `animated` and `bounce` classes are applied. The `infinite` class is applied regardless so we can have our never-ending bounce until the `isBounce` boolean goes back to false.

### Transitions

Thankfully, Vue’s [transition component](https://vuejs.org/v2/guide/transitions.html) provides an easy way to use third-party animation classes with [custom transition classes](https://vuejs.org/v2/guide/transitions.html#Custom-Transition-Classes). Other libraries, such as React, could offer [similar features or add-ons](https://reactjs.org/docs/animation.html). To make use of the animation classes in Vue, we just implement them in the transition component.

```html
<transition
  enter-active-class="animated fadeInDown"
  leave-active-class="animated fadeOutDown"
  mode="out-in"
>
  <div v-if="toggle" key="if">if example</div>
  <div v-else key="else">else example</div>
</transition>
```

Using Animate.css, we merely apply the necessary classes. For `enter-active`, we apply the required `animated` class along with `fadeInDown`. For `leave-active`, we apply the required `animated` class along with `fadeOutDown`. During the transition sequence, these classes are inserted at the appropriate times. Vue handles the inserting and removing of the classes for us.

For a more complex example of using third-party animation libraries in a JavaScript framework, explore this project:

See the Pen [KLKdJy](https://codepen.io/talmand/pen/KLKdJy/) by Travis Almand ([@talmand](https://codepen.io/talmand)) on [CodePen](https://codepen.io).

## Join the party!

This is a small taste of the possibilities that await your project as there are many, many third-party CSS animation libraries out there to explore. Some are [thorough](http://animista.net/play/basic), [eccentric](http://www.joerezendes.com/projects/Woah.css/), [specific](http://ianlunn.github.io/Hover/), [obnoxious](http://tholman.com/obnoxious/), or just [straight-forward](https://daneden.github.io/animate.css/). There are libraries for complex JavaScript animations such as [Greensock](https://greensock.com/) or [Anime.js](https://animejs.com/). There are even libraries that will target the [characters](http://cssanimation.io/) in an element.

Hopefully all this will inspire you to play with these libraries on the way to creating your own CSS animations.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
