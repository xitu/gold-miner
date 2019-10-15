> * 原文地址：[CSS Quickies: CSS Variables - Or how you create a 🌞white/🌑dark theme easily](https://dev.to/lampewebdev/css-quickies-css-variables-or-how-you-create-a-white-dark-theme-easily-1i0i)
> * 原文作者：[lampewebdev](https://dev.to/lampewebdev)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/css-quickies-css-variables-or-how-you-create-a-white-dark-theme-easily.md](https://github.com/xitu/gold-miner/blob/master/TODO1/css-quickies-css-variables-or-how-you-create-a-white-dark-theme-easily.md)
> * 译者：
> * 校对者：

# CSS Quickies: CSS Variables - Or how you create a 🌞white/🌑dark theme easily

![lampewebdev profile image](https://res.cloudinary.com/practicaldev/image/fetch/s--4OXdDnPC--/c_imagga_scale,f_auto,fl_progressive,h_420,q_auto,w_1000/https://res.cloudinary.com/practicaldev/image/fetch/s--2-YUNNqu--/c_imagga_scale%2Cf_auto%2Cfl_progressive%2Ch_420%2Cq_auto%2Cw_1000/https://thepracticaldev.s3.amazonaws.com/i/vhv9dhjxosxtrvezecuy.png)

### What is CSS Quickes?

I started to ask my beloved community on Instagram: "what CSS properties are confusing for you?"

In "CSS Quickies" I will explain one CSS property in depth. These are community requested properties. If you also confused about a CSS property, then write to me on [Instagram](https://www.instagram.com/lampewebdev/) or [Twitter](https://twitter.com/lampewebdev) or down below in the comments! I answer all questions.

I'm also live streaming while coding on [twitch.tv](https://www.twitch.tv/lampewebdev/) if you want to spend some fun time or you can ask me any question!

### Let's talk about `Custom properties` aka `CSS Variables`.

Finally! If you ever have worked with CSS and wanted to keep your design consistent? Or was it more like at some pages, your website had different padding, margin or colors?

Maybe you wanted to implement a dark theme? It was possible, but now it has become easier!

Of course, if you have used LESS or SASS, then you know variables, and now they are finally supported natively. 😁

Let's have a look at it!

#### Defining a CSS variable

You define a CSS variable with prefixing a CSS property with `--`. Let's look at some examples.  

```
:root{
  --example-color: #ccc;
  --example-align: left;
  --example-shadow: 10px 10px 5px 0px rgba(0,0,0,0.75);
}
```

Your first question is: "What is that ':root' pseudo-class?".  
Good question! The `:root` pseudo-class is as you would use the `html` selector except that the specificity is higher of the ':root' pseudo-class. This means that if you set properties in the `:root` pseudo-class it will win over the `html` selector.

Okay, the rest is pretty simple. The custom property `--example-color` has the value of `#ccc`. When we use the custom property, for example, on the `background-color` property, the background of that element will be a light gray. Cool right?

You can give the custom property, aka CSS variable every value you could give any other property in CSS. It is okay to use `left` for example or `10px` and so on.

#### [](#using-css-variables)Using CSS variables

Now that we know how to set CSS variables, we need to learn how to use them!

For this, we need to learn the `var()` function.  
The `var()` can have two arguments. The first argument needs to be a custom property. If the custom property is not valid, you want to have a fallback value. To achieve this, you simply need to set the second argument of the `var()` function. Let's look at an example.  

```
:root{
  --example-color: #ccc;
}

.someElement {
  background-color: var(--example-color, #d1d1d1);
}
```

This should be now pretty straightforward for you to understand. We are setting the `--example-color` to `#ccc` and then we are using it in `.someElement` to set the background color. If something goes wrong and our `--example-color` is not valid, we have a fallback value of `#d1d1d1`.

What happens if you don't set a fallback value and your custom variable is invalid? The browser then will act as if this property was not specified and do its regular job.

#### Tips and tricks

##### Multiple fallback values

What if you want to have multiple fallback values? So you would think you could do the following:  

```
.someElement {
  background-color: var(--first-color, --second-color, white);
}
```

This will not work. After the first comma `var()` treats everything even the commas as a value. The browser would change this into `background-color: --second-color, white;`. This is not what we want.

To have multiple values, we can simply call `var()` inside a `var()`. Here comes an example:  

```
.someElement {
  background-color: var(--first-color, var(--second-color, white));
}
```

Now this would produce our desired outcome. When both `--first-color` and `--second-color` are invalid then the browser will set the background to `white`.

##### [](#what-if-my-fallback-value-needs-a-comma)What if my fallback value needs a comma?

What to do if for example, you want to set a `font-family` in in the fallback value and you need to specify more then one font? Looking back at the tip before this should be now straight forward. We simply write it with the commas. Example time:  

```
.someElement {
    font-family: var(--main-font, "lucida grande" , tahoma, Arial);
}

```

Here we can see the after the first comma the `var()` function treats everything like one value.

##### [](#setting-and-getting-custom-properties-in-javascript)Setting and getting custom properties in Javascript

In more complex apps and websites, you will javascript for state management and rendering. You also can get and set custom properties with javascript. Here is how you can do it:  

```
    const element = document.querySelector('.someElement');
   // Get the custom propety
    element.style.getPropertyValue("--first-color");
   // Set a custom propety
   element.style.setProperty("--my-color", "#ccc");
```

We can get and set the custom properties like any other property. Isn't that cool?

#### Making a theme switcher with custom variables

Let's first have a look at what we will do here:  

##### The HTML markup

```
<div class="grid theme-container">
  <div class="content">
    <div class="demo">
      <label class="switch">
        <input type="checkbox" class="theme-switcher">
        <span class="slider round"></span>
      </label>
    </div>
  </div>
</div>
```

Really nothing special here.  
We will use CSS `grid` to center the content that's why we have a `.grid` class on our first element the `.content` and `.demo` Classes are just for styling. The two crucial classes here are `.theme-container` and `.theme.switcher`.

##### The Javascript code

```
const checkbox = document.querySelector(".theme-switcher");

checkbox.addEventListener("change", function() {
  const themeContainer = document.querySelector(".theme-container");
  if (themeContainer && this.checked) {
    themeContainer.classList.add("light");
  } else {
    themeContainer.classList.remove("light");
  }
});
```

First we are selecting our `.theme-switcher` input and the `.theme-container` element.  
Then we are adding an event listener that listens if a change happens. This means that every time you click on the input, the callback for that event listener will run.  
In the `if` clause we are checking if there is a `.themeContainer` and if the checkbox input is checked.  
When this check is true, we are adding the `.light` class to the `.themeContainer` and if it is false, we are removing it.

Why are we removing and adding the `.light` Class? We will answer this now.

##### The CSS code

Since this code is lengthy, I will show it to you step by step!  

```
.grid {
  display: grid;
  justify-items: center;
  align-content: center;
  height: 100vh;
  width: 100vw;
}
```

Lets first center our content. We are doing this with css `grid`. We will cover the `grid` feature in another CSS quickies!  

```
:root {
  /* light */
  --c-light-background: linear-gradient(-225deg, #E3FDF5 0%, #FFE6FA 100%);
  --c-light-checkbox: #fce100;
  /* dark */
  --c-dark-background:linear-gradient(to bottom, rgba(255,255,255,0.15) 0%, rgba(0,0,0,0.15) 100%), radial-gradient(at top center, rgba(255,255,255,0.40) 0%, rgba(0,0,0,0.40) 120%) #989898; 
  --c-dark-checkbox: #757575;
}
```

This is a lot of code and numbers but actually we are not doing much here. We are preparing our custom properties to be used for our theme. `--c-dark-` and `--c-light-` is what I have chosen to prefix my custom properties. We have defined a light and a dark theme here. For our example we just need the `checkbox` color and the `background` property which is a gradient in our demo.  

```
.theme-container {
  --c-background: var(--c-dark-background);
  --c-checkbox: var(--c-dark-checkbox);
  background: var(--c-background);
  background-blend-mode: multiply,multiply;
  transition: 0.4s;
}
.theme-container.light {
  --c-background: var(--c-light-background);
  --c-checkbox: var(--c-light-checkbox);
  background: var(--c-background);
}
```

Here comes an integral part of the code. We now see why we named the `.theme-container` How we did. It is our entrance to have now global custom variables. We don't want to use the specific custom variables. What we want is to use global custom variables. This is why we are setting `--c-background`. From now on, we will only use our global custom variables. Then we are setting the `background`.  

```
.demo {
  font-size: 32px;
}

/* The switch - the box around the slider */
.switch {
  position: relative;
  display: inline-block;
  width: 60px;
  height: 34px;
}

/* Hide default HTML checkbox */
.switch .theme-switcher {
  opacity: 0;
  width: 0;
  height: 0;
}
```

This is just some boilerplate code to set our style. In the `.demo` selector, we are setting the `font-size`. This is the size of our symbols for the toggle. In the `.switch` selector the `height` and `width` is how long and wide the element behind our toggle symbol is.  

```
/* The slider */
.slider {
  position: absolute;
  cursor: pointer;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: var(--c-checkbox);
  transition: 0.4s;
}

.slider:before {
  position: absolute;
  content: "🌑";
  height: 0px;
  width: 0px;
  left: -10px;
  top: 16px;
  line-height: 0px;
  transition: 0.4s;
}

.theme-switcher:checked + .slider:before {
  left: 4px;
  content: "🌞";
  transform: translateX(26px);
}
```

Here we can finally see our custom properties in action besides using them directly in the `.theme.container` and again a lot of boilerplate code. As you can see, the toggle symbols are simple Unicode symbols. This is why the toggle will look different on every OS and mobile phone vendor. You have to keep this in mind. Important to know here is that in the `.slider:before` Selector, we are moving our symbol around with the `left` and `top` properties. We are doing that also in the `.theme-switcher:checked + .slider:before` but only with the `left` property.  

```
/* Rounded sliders */
.slider.round {
  border-radius: 34px;
}
```

This again is just for styling. To make our switch rounded on the corners.

That is it! We now have a theme switcher which is extendable. ✌😀

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
