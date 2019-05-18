> * 原文地址：[Styling HTML checkboxes is hard - here's why](https://areknawo.com/styling-html-checkboxes-is-hard-heres-why/)
> * 原文作者：[Areknawo](https://areknawo.com/author/areknawo/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/styling-html-checkboxes-is-hard-heres-why.md](https://github.com/xitu/gold-miner/blob/master/TODO1/styling-html-checkboxes-is-hard-heres-why.md)
> * 译者：
> * 校对者：

# Styling HTML checkboxes is hard - here's why

![](https://images.unsplash.com/photo-1484480974693-6ca0a78fb36b?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjExNzczfQ)

In today's world, most web developers consider mastering **JavaScript** as the main priority, and for a good reason. JS is **the scripting language** of the web. While HTML and CSS make the websites look... how they look, JS with the access to HTML and CSS API, very good performance and its versatility is web developers' favorite. This trend can be seen with **libraries** and frameworks such as React, Vue, and Angular or solution like **CSS-in-JS** that aim to make managing our styles easier.

Sadly, all this goodness also has some side-effects. With web developers immediately going for using e.g. React, instead of **learning HTML** first - me being one of them. Going even further we see the growing reliance on **UI components libraries** that just provide everything one needs in a nice package. It's all good - it follows the DRY rule, developers don't have to do the whole work themselves and etc. But, from what I've personally experienced, such practices can leave us not even knowing about some important aspects of HTML...

## HTML form elements

To the point then. Recently I started to create a component library of my own. To not get too much inspired (copy-paste), I decided to skip all framework-bound component libraries and first try to implement some **CSS-only** ones. This let me to noticing how all form-related components were separated and how some libraries didn't really style **checkboxes** at all! For HTML pros out there this might be something really casual but, for me, what I came to realize later, was completely unexpected - styling checkboxes is harder than one could think!

Because of the way it's come to exist, HTML isn't really an expressive language on its own. **Form elements**, like checkboxes, radio buttons, and switches, due to their dynamic nature, have a hard time fitting in with the rest of HTML elements. This can especially be seen when trying to style one of these elements. Although there are tutorials about that on the internet, in this post, we're going to style HTML checkbox **step-by-step** (instead of just throwing code in your face) both in **raw CSS** and, in an easier way - with the help of **JavaScript**.

## CSS-only way

### Base

Basic styling of the checkbox on modern browsers can be done with nothing more than just some CSS and `:checked` pseudo-class. If you want some deeper customization tho (like custom icon), or want to support older browsers, things start to get complicated. In this case, we'll tackle this problem by hiding the original checkbox and **creating our own**, nice-looking version on top of it, while still listening to events on the original one. Let's start with full-fledged HTML first.

```html
<label class="checkbox">
  <input type="checkbox"/>
  <span class="overlay">
      <svg class="icon"/>
  </span>
</label>  
```

With the code above we're wrapping our original checkbox element and its inline overlay (`<span/>` element) in one element. Also, we set up our **SVG check icon** for later use. Now, it's time to write some CSS!

### Hide original

```css
.checkbox input {
    position: absolute;
    opacity: 0;
}
```

Here, we're hiding the original checkbox element by setting its `opacity` to `0`. Other tricks, such as setting `display` to `none` or `visibility` to `hidden` won't work as they'll make some (or all) events of the checkbox not working which, in our case, is a requirement.

### Unchecked state

From this point on, there's nothing more left to do than just style our overlay accordingly for the checked and unchecked state.

```css
.checkbox .overlay {
  position: absolute;
  top: 0px;
  left: 0px;
  height: 24px;
  width: 24px;
  background-color: transparent;
  border-radius: 8px;
  border: 2px solid #F39C12;
  transform: rotate(-90deg);
  transition: all 0.3s;
}

.checkbox .overlay .icon {
  color: white;
  display: none;
}
```

First, let's style our unchecked checkbox. All the above CSS is generally mostly cosmetic and just makes our form element look cooler. For example, we sneakily added some transforms and transitions (remember prefixes for older browsers!) to add at least some **motion** to out checkbox. But, apparently, the `display: none` applied to our icon is the most important detail. Here, as we don't need to listen to icon's events, we can hide it completely using `display` property.

## SVG icon

This brings us to the icon itself. Here, we'll be using simple, nicely rounded check **vector icon** taken straightly from a nice set of MIT-licensed icons called **[Feather](https://feathericons.com/)**. Here's how it looks like code-wise:

```html
<svg xmlns="http://www.w3.org/2000/svg"
    width="24"
    height="24"
    viewBox="0 0 24 24"
    fill="none"
    stroke="currentColor"
    stroke-width="2"
    stroke-linecap="round"
    stroke-linejoin="round"
    class="icon">
        <polyline points="20 6 9 17 4 12"/>
</svg>
```

### Checked state

Finally, for our checked state:

```css
.checkbox input:checked ~ .overlay {
  background-color: #F39C12;
  border-radius: 8px;
  transform: rotate(0deg);
  opacity: 1;
  border: 2px solid #F39C12;
}

.checkbox input:checked ~ .overlay .icon {
  display: block;
}
```

Here, we make good use of CSS `~` selector, applying styles to each element that is preceded by the one specified before it. Next, we make our check icon visible and rotate the checkbox to its original position. For the complete code, you can view the CodePen below.

See the Pen [CSS Checkbox](https://codepen.io/areknawo/pen/GaRLYm/) by Arek Nawo ([@areknawo](https://codepen.io/areknawo)) on [CodePen](https://codepen.io).

## JS method

### Why?

Now, there are some things to note here. Some examples use a **rotated rectangle** with a small border and some CSS pseudo-classes, instead of SVG for their check icons. In the code above we've used the SVG icon as it allows for more customization (e.g. rounded corners) and is just simpler to use. Next, we only apply some small rotation and color change animation, but if you want to do something more, I recommend trying out `stroke-dasharray`, `stroke-dashoffset`, and some **keyframe animations** to make your SVG icon appear smoothly. But, keep in mind that as you add more and more features to your checkbox, your CSS can rapidly become more and **more bloated**. Sure, CSS is easy on computing power, but it doesn't make that much of a difference when compared to JS - especially on modern devices. With that said, if you want to truly unleash your creativity, you'll most likely need to use some JS.

### Setup

With no CSS-only limitation, we don't have to be so much creative with our selectors. We'll keep our existing HTML structure and start by accessing all required elements inside the **JS code**.

```
const checkboxes = document.querySelectorAll(".checkbox");
checkboxes.forEach(checkbox => {
  const input = checkbox.children[0];
  const overlay = checkbox.children[1];
  const icon = overlay.children[0];
});
```

We use the code to apply our JS to every existing checkbox, but keep in mind that you most likely won't do it that way in **"production"**. Instead, with a **component-based library** like React, you'll be creating your checkboxes as components and using e.g. advanced **animation libraries** to keep things ticking. But, for an example as simple as the one here, it would be pointless to use such big libraries. Let's stick to the basics.

### CSS changes

```css
.checkbox input {
  position: absolute;
  opacity: 0;
}

.checkbox .overlay {
  position: absolute;
  top: 0px;
  left: 0px;
  height: 24px;
  width: 24px;
  background-color: #F39C12;
  border-radius: 8px;
  border: 2px solid #F39C12;
}

.checkbox .overlay .icon {
  color: white;
}

.checkbox .overlay.checked {
  border-radius: 8px;
  opacity: 1;
  border: 2px solid #F39C12;
}
```

Now, here's our CSS, but **"flattened"**, as I like to call it. Changes that we did here include the removal of `~` selectors in favor of simple CSS sub-class named `checked`, and some other styling including the one for checked icon in favor of our up-coming **JS animations**.

Such an approach comes with its own benefits. The main one being its **structure**. Such **"flattened"** CSS, without any complex selectors included, is much easier to implement in various **CSS-in-JS** libraries and, as we all know, such solution makes our CSS much more **expressive** and **manageable** at the same time.

```javascript
// ...
input.addEventListener("change", () => {
    if (input.checked) {
        overlay.classList.add("checked");
        icon.classList.add("checked");
    } else {
        overlay.classList.remove("checked");
        icon.classList.remove("checked");
    }
});
// ...
```

### Event listeners

On JS side, we can listen to `change` event that occurs whenever any kind of change takes place. It's supported by most, if not all, form elements. Then, with the help of `checked` property that exists on all input elements with type equal to `checkbox` we decide whether we should add or remove our classes. As a side-note, the `classList` property, in its basic form, [is supported](https://caniuse.com/#feat=classlist) by all **modern browsers** - including IE 10!

And finally, to make use of the power that JS provides us, we make our SVG appear smoothly - just like a good check icon should. For this part and the complete code with some more changes, you can check out the CodePen below.

See the Pen [JS Checkbox](https://codepen.io/areknawo/pen/BeyLeJ/) by Arek Nawo ([@areknawo](https://codepen.io/areknawo)) on [CodePen](https://codepen.io).

## Do you like this one?

So, I hope this **quick tutorial** made you know more about checkboxes and HTML in general. There's a lot to uncover - especially when not talking about libraries of any kind. I hope you enjoy this short, but a nice read. Let me know in **the comment section** and with **a reaction** below if you'd like to **see more** of such type of content on this blog. If you want to consider **sharing this tutorial**, **following me** [**on Twitter**](https://twitter.com/areknawo), **[on my Facebook page](https://www.facebook.com/areknawoblog)** and signing up for the **weekly newsletter**. Thank you very much for reading this one through and I'll see you in **the next one**!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
