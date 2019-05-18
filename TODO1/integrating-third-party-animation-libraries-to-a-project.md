> * 原文地址：[Integrating Third-Party Animation Libraries to a Project](https://css-tricks.com/integrating-third-party-animation-libraries-to-a-project/)
> * 原文作者：[Travis Almand](https://css-tricks.com/author/travisalmand/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/integrating-third-party-animation-libraries-to-a-project.md](https://github.com/xitu/gold-miner/blob/master/TODO1/integrating-third-party-animation-libraries-to-a-project.md)
> * 译者：
> * 校对者：

# Integrating Third-Party Animation Libraries to a Project

Creating CSS-based animations and transitions can be a challenge. They can be complex and time-consuming. Need to move forward with a project with little time to tweak the perfect transition? Consider a third-party CSS animation library with ready-to-go animations waiting to be used. Yet, you might be thinking: What are they? What do they offer? How do I use them?

Well, let’s find out.

## A (sort of) brief history of :hover

Once there was a time that the concept of a hover state was a trivial example of what is offered today. In fact, the idea of having a reaction to the cursor passing on top of an element was more-or-less nonexistent. Different ways to provide this feature were proposed and implemented. This small feature, in a way, opened the door to the idea of CSS being capable of animations for elements on the page. Over time, the increasing complexity possible with these features have led to CSS animation libraries.

**Macromedia’s Dreamweaver** was introduced in [December 1997](https://en.wikipedia.org/wiki/Adobe_Dreamweaver) and offered what was a simple feature, an image swap on hover. This feature was implemented with a JavaScript function that would be embedded in the HTML by the editor. This function was named `MM_swapImage()` and has become a bit of web design folklore. It was an easy script to use, even outside of Dreamweaver, and it’s popularity has resulted in it still being in use even today. In my initial research for this article, I found a question pertaining to this function from 2018 on **Adobe’s Dreamweaver** (Adobe acquired Macromedia in 2005) help forum.

The JavaScript function would swap an image with another image through changing the src attribute based on **mouseover** and **mouseout** events. When implemented, it looked something like this:

```html
<a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('ImageName','','newImage.jpg',1)">
  <img src="originalImage.jpg" name="ImageName" width="100" height="100" border="0">
</a>
```

By today’s standards, it would be fairly easy to accomplish this with JavaScript and many of us could practically do this in our sleep. But consider that JavaScript was still this new scripting language at the time (created in 1995) and sometimes looked and behaved differently from browser to browser. Creating cross-browser JavaScript was not always an easy task and not everyone creating web pages even wrote JavaScript. ([Though that has certainly changed.](https://css-tricks.com/the-great-divide/)) Dreamweaver offered this functionality through a menu in the editor and the web designer didn’t even need to write the JavaScript. It was based around a set of "behaviors" that could be selected from a list of different options. These options could be filtered by a set of targeted browsers; 3.0 browsers, 4.0 browsers, IE 3.0, IE 4.0, Netscape 3.0, Netscape 4.0. Ah, the [good old days](https://css-tricks.com/the-ecological-impact-of-browser-diversity/).

![A screenshot of a Netscape browser window.](https://css-tricks.com/wp-content/uploads/2019/05/mm_browsers.png)

Choosing Behaviors based on browser versions, circa 1997.

![A screenshot from the Dreamweaver application that shows the options panel for toggling an element's behavior in HTML.](https://css-tricks.com/wp-content/uploads/2019/05/s_EBCAC238906FAA6EECC38BE5A80726DC08BADA1B9C984153FFCE3F96AC775B6A_1554670455957_mm_swap.png)

The Swap Image Behaviors panel in Macromedia Dreamweaver 1.2a

About a year after Dreamweaver was first released, the CSS2 specification from W3C mentioned `:hover` in a working draft dated [January 1998](https://www.w3.org/TR/1998/WD-css2-19980128/). It was specifically mentioned in terms of anchor links, but the language suggests it could have possibly been applied to other elements. For most purposes it would seem this pseudo selector would be the beginning of an easy alternative to `MM_swapImage()`, since `background-image` was in the same draft. Although browser support was an issue as it took years before enough browsers properly supported CSS2 to make it a viable option for many web designers. There was finally a W3C recommendation of CSS2.1, this could be considered to be the basis of "modern" CSS as we know it, which was published in [June 2011](https://www.w3.org/TR/CSS2/).

In the middle of all this, **jQuery** came along in [2006](https://en.wikipedia.org/wiki/JQuery). Thankfully, jQuery went a long way in simplifying JavaScript among the different browsers. One thing of interest for our story, the first version of jQuery offered the [`animate()`](https://api.jquery.com/animate/) method. With this method, you could animate CSS properties on any element at any time; not just on hover. By its sheer popularity, this method exposed the need for a more robust CSS solution baked into the browser — a solution that wouldn’t require a JavaScript library that was not always very performant due to browser limitations.

The `:hover` pseudo-class only offered a hard swap from one state to another with no support for a smooth transition. Nor could it animate changes in elements outside of something as basic as hovering over an element. jQuery’s `animate()` method offered those features. It paved the way and there was no going back. As things go in the dynamic world of web development, a working draft for solving this was well underway before the recommendation of CSS2.1 was published. The first working draft for [CSS Transitions Module Level 3](https://www.w3.org/TR/2009/WD-css3-transitions-20090320/) was first published by the W3C in March 2009. The first working draft for [CSS Animations Module Level 3](https://www.w3.org/TR/2009/WD-css3-animations-20090320/) was published at roughly the same time. Both of these CSS modules are still in a working draft status as of October 2018, but of course, we are already making heavy use of them

So, what first started as a JavaScript function provided by a third-party, just for a simple hover state, has led to transitions and animations in CSS that allow for elaborate and complex animations — complexity that many developers wouldn’t necessarily wish to consider as they need to move quickly on new projects. We have gone full circle; today many third-party CSS animation libraries have been created to offset this complexity.

## Three different types of third-party animation libraries

We are in this new world capable of powerful, exciting, and complex animations in our web pages and apps. Several different ideas have come to the forefront on how to approach these new tasks. It’s not that one approach is better than any other; indeed, there is a good bit of overlap in each. The difference is more about how we implement and write code for them. Some are full-blown JavaScript-only libraries while others are CSS-only collections.

### JavaScript libraries

Libraries that operate solely through JavaScript often offer capabilities beyond what common CSS animations provide. Usually, there is overlap as the libraries may actually use CSS features as part of their engine, but that would be abstracted away in favor of the API. Examples of such libraries are [Greensock](https://greensock.com/) and [Anime.js](https://animejs.com/). You can see the extent of what they offer by looking at the demos they provide (Greensock has a [nice collection over on CodePen](https://codepen.io/GreenSock/)). They’re mostly intended for highly complex animations, but can be useful for more basic animations as well.

### JavaScript and CSS libraries

There are third-party libraries that primarily include CSS classes but provide some JavaScript for easy use of the classes in your projects. One library, [Micron.js](https://webkul.github.io/micron/), provides both a JavaScript API and data attributes that can be used on elements. This type of library allows for easy use of pre-built animations that you can just select from. Another library, [Motion UI,](https://zurb.com/blog/introducing-the-new-motion-ui) is intended to be used with a JavaScript framework. Although, it also works on a similar notion of a mixture of a JavaScript API, pre-built classes, and data attributes. These types of libraries provide pre-built animations and an easy way to wire them up.

#### CSS libraries

The third kind of library is CSS-only. Typically, this is just a CSS file that you load via a link tag in your HTML. You then apply and remove specific CSS classes to make use of the provided animations. Two examples of this type of library are [Animate.css](https://daneden.github.io/animate.css/) and [Animista](http://animista.net/). That said, there are even major differences between these two particular libraries. Animate.css is a total CSS package while Animista provides a slick interface to choose the animations you want with provided code. These libraries are often easy to implement but you have to write code to make use of them. These are the type of libraries this article will focus on.

## Three different types of CSS animations

Yes, there’s a pattern; the [rule of threes](https://en.wikipedia.org/wiki/Rule_of_three_(writing)) is everywhere, after all.

In most cases, there are three types of animations to consider when making use of third-party libraries. Each type suits a different purpose and has different ways to make use of them.

### Hover animations

![An illustration of a black button on the left and an orange button with a mouse cursor over it as a hover effect.](https://css-tricks.com/wp-content/uploads/2019/05/button-hover.png)

These animations are intended to be involved in some sort of hover state. They’re often used with buttons, but another possibility is using them to highlight sections the cursor happens to be on. They can also be used for focus states.

### Attention animations

![An illustration of a webpage with gray boxes and a red alert at the top of the screen to show an instance of an element that seeks attention.](https://css-tricks.com/wp-content/uploads/2019/05/attention.png)

These animations are intended to be used on elements that are normally outside of the visual center of the person viewing the page. An animation is applied to a section of the display that needs attention. Such animations could be subtle in nature for things that need eventual attention but not dire in nature. They could also be highly distracting for when immediate attention is required.

### Transition animations

![An illustration of concentric circles stacked vertically going from gray to black in ascending order.](https://css-tricks.com/wp-content/uploads/2019/05/transition.png)

These animations are often intended to have an element replace another in the view, but can be used for one element as well. These will usually include an animation for "leaving" the view and mirror animation for "entering" the view. Think of fading out and fading in. This is commonly needed in single page apps as one section of data would transition to another set of data, for example.

So, let’s go over examples of each of these type of animations and how one might use them.

## Let’s hover it up!

Some libraries may already be set for hover effects, while some have hover states as their main purpose. One such library is [Hover.css](http://ianlunn.github.io/Hover/), which is a drop-in solution that provides a nice range of hover effects applied via class names. Sometimes, though, we want to make use of an animation in a library that doesn’t directly support the `:hover` pseudo-class because that might conflict with global styles.

For this example, I shall use the **tada** animation that [Animate.css](https://daneden.github.io/animate.css/) provides. It’s intended more as an attention seeker, but it will nicely suffice for this example. If you were to [look through the CSS of the library](https://github.com/daneden/animate.css/blob/master/animate.css), you’ll find that there’s no `:hover` pseudo-class to be found. So, we’ll have to make it work in that manner on our own.

The `tada` class by itself is simply this:

```css
.tada {
  animation-name: tada;
}
```

A low-lift approach to make this react to a hover state is to make our own local copy of the class, but extend it just a bit. Normally, Animate.css is a drop-in solution, so we won’t necessarily have the option to edit the original CSS file; although you could have your own local copy of the file if you wish. Therefore, we only create the code we require to be different and let the library handle the rest.

```css
.tada-hover:hover {
  animation-name: tada;
}
```

We probably shouldn’t override the original class name in case we actually want to use it elsewhere. So, instead, we make a variation that we can place the `:hover` pseudo-class on the selector. Now we just use the library’s required `animated` class along with our custom `tada-hover` class to an element and it will play that animation on hover.

If you wouldn’t want to create a custom class in this way, but prefer a JavaScript solution instead, there’s a relatively easy way to handle that. Oddly enough, it’s a similar method to the `MM_imageSwap()` method from Dreamweaver we discussed earlier.

```javascript
// Let's select elements with ID #js_example
var js_example = document.querySelector('#js_example');

// When elements with ID #js_example are hovered...
js_example.addEventListener('mouseover', function () {
  // ...let's add two classes to the element: animated and tada...
  this.classList.add('animated', 'tada');
});
// ...then remove those classes when the mouse is not on the element.
js_example.addEventListener('mouseout', function () {
  this.classList.remove('animated', 'tada');
});
```

There are actually multiple ways to handle this, depending on the context. Here, we create some event listeners to wait for the mouse-over and mouse-out events. These listeners then apply and remove the library’s `animated` and `tada` classes as needed. As you can see, extending a third-party library just a bit to suit our needs can be accomplished in relatively easy fashion.

## Can I please have your attention?

Another type of animation that third-party libraries can assist with are attention seekers. These animations are useful for when you wish to draw attention to an element or section of the page. Some examples of this could be notifications or unfilled required form inputs. These animations can be subtle or direct. Subtle for when something needs eventual attention but does not need to be resolved immediately. Direct for when something needs resolution now.

Some libraries have such animations as part of the whole package, while some are built specifically for this purpose. Both Animate.css and Animista have attention seeking animations, but they are not the main purpose for those libraries. An example of a library built for this purpose would be [CSShake](https://elrumordelaluz.github.io/csshake/). Which library to use depends on the needs of the project and how much time you wish to invest in implementing them. For example, CSShake is ready to go with little trouble on your part — simply apply classes as needed. Although, if you were already using a library such as Animate.css, then you’re likely not going to want to introduce a second library (for performance, reliance on dependencies, and such).

So, a library such as Animate.css can be used but needs a little more setup. The library’s [GitHub page has examples](https://github.com/daneden/animate.css) of how to go about doing this. Depending on the needs of a project, implementing these animations as attention seekers is rather straightforward.

For a subtle type of animation, we could have one that just repeats a set number of times and stops. This usually involves adding the library’s classes, applying an animation iteration property to CSS, and waiting for the animation end event to clear the library’s classes.

Here’s a simple example that follows the same pattern we looked at earlier for hover states:

```javascript
var pulse = document.querySelector('#pulse');

function playPulse () {
  pulse.classList.add('animated', 'pulse');
}

pulse.addEventListener('animationend', function () {
  pulse.classList.remove('animated', 'pulse');
});

playPulse();
```

The library classes are applied when the `playPulse` function is called. There’s an event listener for the `animationend` event that will remove the library’s classes. Normally, this would only play once, but you might want to repeat multiple times before stopping. Animate.css doesn’t provide a class for this, but it’s easy enough to apply a CSS property for our element to handle this.

```css
#pulse {
  animation-iteration-count: 3; /* Stop after three times */
}
```

This way, the animation will play three times before stopping. If we needed to stop the animation sooner, we can manually remove the library classes outside of the `animationend` function. The library’s documentation actually provides an example of a reusable function for applying the classes that removes them after the animation; very similar to the above code. It would even be rather easy to extend it to apply the iteration count to the element.

For a more direct approach, let’s say an infinite animation that won’t stop until after some sort of user interaction takes place. Let’s pretend that clicking the element is what starts the animation and clicking again stops it. Keep in mind that however you wish to start and stop the animation is up to you.

```javascript
var bounce = document.querySelector('#bounce');

bounce.addEventListener('click', function () {
  if (!bounce.classList.contains('animated')) {
    bounce.classList.add('animated', 'bounce', 'infinite');
  } else {
    bounce.classList.remove('animated', 'bounce', 'infinite');
  }
});
```

Simple enough. Clicking the element tests if the library’s "animated" class has been applied. If it has not, we apply the library classes so it starts the animation. If it has the classes, we remove them to stop the animation. Notice that `infinite` class on the end of the `classList`. Thankfully, Animate.css provides this for us out-of-the-box. If your library of choice doesn’t offer such a class, then this is what you need in your CSS:

```css
#bounce {
  animation-iteration-count: infinite;
}
```

Here’s a demo showing how this code behaves:

See the Pen [3rd Party Animation Libraries: Attention Seekers](https://codepen.io/talmand/pen/pmzLzR/) by Travis Almand ([@talmand](https://codepen.io/talmand)) on [CodePen](https://codepen.io).

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
