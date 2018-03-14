> * 原文地址：[Everything you need to know about CSS Variables](https://medium.freecodecamp.org/everything-you-need-to-know-about-css-variables-c74d922ea855)
> * 原文作者：[Ohans Emmanuel](https://medium.freecodecamp.org/@ohansemmanuel?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/everything-you-need-to-know-about-css-variables.md](https://github.com/xitu/gold-miner/blob/master/TODO/everything-you-need-to-know-about-css-variables.md)
> * 译者：[MechanicianW](https://github.com/MechanicianW)
> * 校对者：

# 关于 CSS 变量，你需要了解的一切

![](https://cdn-images-1.medium.com/max/1000/1*Im5WsB6Y7CubjWRx9hH7Gg.png)

本文是[我新写的电子书](https://gumroad.com/l/lwaUh)的第一章（电子书目前已支持 pdf 和 mobi 格式下载）。

大多数编程语言都支持变量。然而遗憾的是，CSS 从一开始就缺乏对原生变量的支持。

你写 CSS 吗？如果写的话你就知道是没法使用变量的。当然了，除非你使用像 Sass 这样的预处理器。

像 Sass 这样的预处理器是把变量的使用作为一个大型扩展。这是一个非常好的理由去尝试使用这类预处理器。

Web 技术发展是非常快的，在此我很高兴地报告 **现在 CSS 支持变量了**。

然而预处理器还支持更多优秀特性，CSS 变量仅仅是其中之一。这些特性使得 Web 技术更加贴近未来。

这篇指南将向你展示变量是如何在原生 CSS 中工作的，以及怎样使用变量让你的编程工作更轻松。

### 你将学到

首先我将带你粗略过一遍 CSS 变量的基础知识。我相信任何理解 CSS 变量的尝试都必须从这里开始。

学习基础知识是一件非常酷的事。更酷的是使用基础知识来构建一个可以工作的应用。

因此我将把这两件事结合起来，通过向你展示如何构建三个项目来体现 CSS 变量的使用和易用性。下面是对这三个项目的快速预览。

#### 项目 1： 使用 CSS 变量创建一个有变化效果的组件
可能已经构建过一个有变化效果的组件了。无论你是使用 React，Angular 还是 Vue，使用 CSS 变量都会让构建过程更简单。

![](https://cdn-images-1.medium.com/max/800/1*qElS3I43_SdpdRA8-m2iew.gif)

使用 CSS 变量创建一个有变化效果的组件。

可以在 [Codepen](https://codepen.io/ohansemmanuel/full/PQYzvv/) 上查看这个项目。

#### 项目 2： 使用 CSS 变量实现主题定制

可能你已经看过这个项目了。我会向你展示使用 CSS 变量来定制全站主题有多么容易。

![](https://cdn-images-1.medium.com/max/800/1*r2TrlsC-gWRD5Hu6Tp2gjQ.gif)

使用 CSS 变量定制全站主题。

可以在 [Codepen](https://codepen.io/ohansemmanuel/full/xYKgwE/) 上查看这个项目。

#### 项目 3： 构建 CSS 变量展位

这是最后一个项目了，不要在意这个项目名，我想不出更好的名字了。

![](https://cdn-images-1.medium.com/max/800/1*E6H-wT6a0BDR9OJK7Z0dTA.gif)

盒子的颜色是动态更新的。

请注意盒子的颜色是如何动态更新的，以及盒子容器是如何随着输入范围值的变化进行 3D 旋转的。

![](https://cdn-images-1.medium.com/max/800/1*iy_MjZVlp-H0KUQa7H7fUg.gif).

这个项目展示了使用 JavaScript 更新 CSS 变量的便利性，从中你还会尝到响应式编程的甜头。

#### 这会是非常好玩的！

花点时间在 [Codepen](https://codepen.io/ohansemmanuel/full/EoBLgd/) 上玩一玩。

注意：本文假定你对 CSS 已驾轻就熟。如果你对 CSS 掌握地不是很好，或者想学习如何创作出惊艳的 UI 效果，我建议你去学习我的 [CSS 进阶课程](https://bit.ly/learn_css)（共 85 课时的付费课程）。本文内容是该课程的一个节选。😉

### 为何变量如此重要

如果你对预处理器和原生 CSS 中的变量并不熟悉的话，以下几个原因可以为你解答为何变量如此重要。

#### **原因 #1：使得代码更可读**

无需多言，你就可以判断出，变量使得代码可读性更好，更易于维护。

#### **原因 #2：易于在大型文档中进行修改**

如果把所有的常量都维护在一个单独文件中，想改动某一变量时就无需在上千行代码进行修改。

这变得非常容易，仅仅在一个地方进行修改，就搞定了。

#### **原因 #3：定位打字错误更快**

在行行代码中定位错误非常痛苦，更痛苦的是错误是由打字错误造成的，它们非常难定位。善于使用变量可以免除这些麻烦。

至此，可读性和可维护性是主要优点。

感谢 CSS 变量，现在我们在原生 CSS 中也能享受到以上这些优点了。

### 定义 CSS 变量

先以你已经很熟悉的东西开始：JavaScript 中的变量。

JavaScript 中，一个简单的变量声明会像这样：

```
var amAwesome;
```

然后你像这样可以赋值给它：

```
amAwesome = "awesome string"
```

在 CSS 中，以两个横线开头的“属性”都是 CSS 变量。

```
/*你可以找到变量吗？ */
.block {
 color: #8cacea;
--color: blue
}
```

![](https://cdn-images-1.medium.com/max/800/0*2Pl5qBF8DCTGL_np.png)

CSS 变量也被称为“自定义属性”。

### CSS 变量作用域

还有一点需要注意。

请记住 JavaScript 中变量是有作用域的，要么是`全局作用域`，要么就是`局部作用域`。

CSS 变量也是如此。

思考一下下面这个例子：

```
:root {
  --main-color: red
}
```

`:root` 选择器允许你定位到 DOM 中的最顶级元素或文档树。

所以，这种方式声明的变量就属于具有全局作用域的变量。

明白了吗？

![](https://cdn-images-1.medium.com/max/1600/0*GLjARI5CCGA3xJAx.png)

局部变量与全局变量。

### 示例 1

假设你想创建一个 CSS 变量来存储主题站点的主要颜色。

你会怎么做呢？

1. 创建一个选择器。通过 `:root` 创建一个全局变量。

```
:root {

}
```

2. 定义变量

```
:root {
 --primary-color: red
}
```

请记住，在 CSS 中，以两个横线开头的“属性”都是 CSS 变量，比如 `--color`

就是这么简单。

### 使用 CSS 变量

变量一旦被定义并赋值，你就可以在属性值内使用它了。

但是有个小问题。

如果你用过预处理器的话，一定已经习惯通过引用变量名来使用该变量了。比如：

```
$font-size: 20px

.test {
  font-size: $font-size
}
```

原生 CSS 变量有些不同，你需要通过 `var()` 函数来引用变量。

在上面这个例子中，使用 CSS 变量就应该改成这样：

```
:root {
  --font-size: 20px
}

.test {
  font-size: var(--font-size)
}
```

两种写法大不一样。

![](https://cdn-images-1.medium.com/max/800/0*Gv8Nci9VTrJBxpBe.png)

请记得使用 var 函数。

一旦你习惯了这种方式，就会爱上 CSS 变量的。

另一个重要的注意事项是，在 Sass 这类预处理器中，你可以在任意地方使用变量，做各种计算，但是需要注意，在原生 CSS 中，你只能将变量设置为属性值。

```
/*这是错的*/
.margin {
--side: margin-top;
var(--side): 20px;
}
```

![](https://cdn-images-1.medium.com/max/800/0*vtIhP9EGm_vTxeio.png)

由于属性名非法，这段声明会抛出语法错误

CSS 变量也不能做数学计算。如果需要的话，可以通过 CSS 的 `calc()` 函数进行计算。接下来我们会通过示例来阐述。

```
/*这是错的*/
.margin {
--space: 20px * 2;
font-size:  var(--space);  //not 40px
}
```

如果你必须要做数学计算的话，可以像这样使用 calc() 函数：

```
.margin {
--space: calc(20px * 2);
font-size:  var(--space);  /*等于 40px*/
}
```

### 关于属性的一些事

以下是几个需要阐述的属性行为：

#### 1. 自定义属性就是普通属性，可以在任意元素上声明自定义属性

在 p，section，aside，root 元素，甚至伪元素上声明自定义属性，都可以运行良好。

![](https://cdn-images-1.medium.com/max/800/0*plpQVof3v3JrzC1P.png)

这些自定义属性工作时与普通属性无异。

#### 2. CSS 变量由普通的继承与级联规则解析

请思考以下代码：

```
div {
  --color: red;
}

div.test {
  color: var(--color)
}

div.ew {
  color: var(--color)
}
```

像普通变量一样，`--color` 的值会被 div 元素们继承。

![](https://cdn-images-1.medium.com/max/800/0*GNSU5IDdk7dx3B8t.png)

#### 3. CSS 变量可以通过 `@media` 和其它条件规则变成条件式变量

和其它属性一样，你可以通过 `@media` 代码块或者其它条件规则改变 CSS 变量的值。

举个例子，以下代码会在大屏设备下改变变量 gutter 的值。

```
:root {
 --gutter: 10px
}

@media screen and (min-width: 768px) {
    --gutter: 30px
}
```

![](https://cdn-images-1.medium.com/max/800/0*qmsVGjnWjLCKfyvt.png)

对于响应式设计很有用。

#### 4. HTML 的 style 属性中可以使用 CSS 变量。

你可以在行内样式中设置变量值，变量依然会如期运行。

```
<!--HTML-->
<html style="--color: red">

<!--CSS-->
body {
  color: var(--color)
}
```

![](https://cdn-images-1.medium.com/max/800/0*EQiFgdDyNBQ1AfDk.png)

行内设置变量值。

要注意这一点，CSS 变量是区分大小写的。我为了减小压力，选择都采用小写形式，这件事见仁见智。

```
/*这是两个不同的变量*/
:root {
 --color: blue;
--COLOR: red;
}
```

### Resolving Multiple Declarations

As with other properties, multiple declarations are resolved with the standard cascade.

Let’s see an example:

```
/*define the variables*/
:root { --color: blue; }
div { --color: green; }
#alert { --color: red; }

/*use the variable */
* { color: var(--color); }
```

With the variable declarations above, what will be the color of the following elements?

```
<p>What's my color?</p>
<div>and me?</div>
<div id='alert'>
  What's my color too?
  <p>color?</p>
</div>
```

Can you figure that out?

The first paragraph will be `blue`. There is no direct `--color` definition set on a `p` selector, so it inherits the value from `:root`

```
:root { --color: blue; }
```

The first `div` will be `green` . That’s pretty clear. There’s a direct variable definition set on the `div`

```
div { --color: green; }
```

The `div` with the ID of `alert` will NOT be green. It will be `red`

```
#alert { --color: red; }
```

The ID has a direct variable scoping. As such, the value within the definition will override the others. The selector `#alert` is more specific.

Finally, the `p` within the `#alert` will be… `red`

There’s no variable declaration on the paragraph element. You may have expected the color to be `blue` owing to the declaration on the `:root` element.

```
:root { --color: blue; }
```

As with other properties, CSS variables are inherited. The value is inherited from the parent, `#alert`

```
#alert { --color: red; }
```

![](https://cdn-images-1.medium.com/max/800/1*lGioVJqkKo0N91R9eMvywQ.png)

The solution to the Quiz.

### Resolving Cyclic Dependencies

A cyclic dependency occurs in the following ways:

1. When a variable depends on itself. That is, it uses a `var()` that refers to itself.

```
:root {
  --m: var(--m)
}

body {
  margin: var(--m)
}
```

2. When two or more variables refer to each other.

```
:root {
  --one: calc(var(--two) + 10px);
  --two: calc(var(--one) - 10px);
}
```

Be careful not to create cyclic dependencies within your code.

### What Happens with Invalid Variables?

Syntax errors are discarded, but invalid `var()` substitutions default to either the initial or inherited value of the property in question.

Consider the following:

```
:root { --color: 20px; }
p { background-color: red; }
p { background-color: var(--color); }
```

![](https://cdn-images-1.medium.com/max/800/0*fa59XRLGKo5Rsqm4.png)

As expected, `--color` is substituted into `var()` but the property value, `background-color: 20px` is invalid after the substitution. Since `background-color` isn’t an inheritable property, the value will default to its `initial` value of `transparent`.

![](https://cdn-images-1.medium.com/max/800/0*uVic7R1o96n-T1l5.png)

Note that if you had written `background-color: 20px` without any variable substitutes, the particular background declaration would have been invalid. The previous declaration will then be used.

![](https://cdn-images-1.medium.com/max/800/0*9HzCVQdyvqeo5dZq.png)

The case is differrent when you write the declaration yourself.

### Be Careful While Building Single Tokens

When you set the value of a property as indicated below, the `20px` is interpreted as a single token.

```
font-size: 20px
```

A simple way to put that is, the value `20px` is seen as a single ‘entity.’

You need to be careful when building single tokens with CSS variables.

For example, consider the following block of code:

```
:root {
 --size: 20
}

div {
  font-size: var(--size)px /*WRONG*/
}
```

You may have expected the value of `font-size` to yield `20px`, but that is wrong.

The browser interprets this as `20 px`

Note the space after the `20`

Thus, if you must create single tokens, have a variable represent the entire token. For example, `--size: 20px`, or use the `calc` function e.g `calc(var(--size) * 1px)` where `--size` is equal to `20`

Don’t worry if you don’t get this yet. I’ll explain it in more detail in a coming example.

### Let’s build stuff!

Now this is the part of the article we’ve been waiting for.

I’ll walk you through practical applications of the concepts discussed by building a few useful projects.

Let’s get started.

### Project 1: Creating Component Variations using CSS Variables

Consider the case where you need to build two different buttons. Same base styles, just a bit of difference.

![](https://cdn-images-1.medium.com/max/800/1*qElS3I43_SdpdRA8-m2iew.gif)

In this case, the properties that differ are the `background-color` and `border-color` of the variant.

So, how would you do this?

Here’s the typical solution.

Create a base class, say `.btn` and add the variant classes. Here’s an example markup:

```
<button class="btn">Hello</button>
<button class="btn red">Hello</button>
```

`.btn` would contain the base styles on the button. For example:

```
.btn {
  padding: 2rem 4rem;
  border: 2px solid black;
  background: transparent;
  font-size: 0.6em;
  border-radius: 2px;
}

/*on hover */
.btn:hover {
  cursor: pointer;
  background: black;
  color: white;
}
```

So, where does the variant come in?

Here:

```
/* variations */

.btn.red {
  border-color: red
}
.btn.red:hover {
  background: red
}
```

You see how we are duplicating code here and there? This is good, but we could make it better with CSS variables.

What’s the first step?

Substitute the varying colors with CSS variables, and don’t forget to add default values for the variables!

```
.btn {
   padding: 2rem 4rem;
   border: 2px solid var(--color, black);
   background: transparent;
   font-size: 0.6em;
   border-radius: 2px;
 }

 /*on hover*/
 .btn:hover {
  cursor: pointer;
   background: var(--color, black);
   color: white;
 }
```

When you do this: `background: **var(--color, black)**`you’re saying, set the background to the value of the variable `--color` . However, if the variable doesn't exist, use the default value of `**black**`

This is how you set default variable values. Just like you do in JavaScript or any other programming language.

Here’s the good part.

With the variants, you just supply the new value of the CSS variable as under:

```
.btn.red {
   --color: red
 }
```

That’s all. Now when the `.red` class is used, the browser notes the different `--color` variable value, and immediately updates the appearance of the button.

This is really good if you spend a lot of time building reusable components.

Here’s a side by side comparison:

![](https://cdn-images-1.medium.com/max/800/1*bdT9ITBx1wpXjLOYoWBI7w.png)

Without CSS Variables VS with CSS Variables.

Oh, and if you had more variants, you just saved yourself a lot of extra typing.

![](https://cdn-images-1.medium.com/max/800/1*erZb3Z5FtTIR8EV9fl0QOA.png)

See the difference??

### Project 2: Themed Sites with CSS Variables

I’m sure you’ve come across them before. Themed sites give the user the feel of customization. Like they are in control.

Below is the basic example we’ll build.

![](https://cdn-images-1.medium.com/max/800/1*r2TrlsC-gWRD5Hu6Tp2gjQ.gif)

So, how easy do the CSS variables make this?

We’ll have a look.

Just before that, I wanted to mention that this example is quite important. With this example, I’ll introduce the concept of updating CSS variables with JavaScript.

It is fun!

You’ll love it.

### What we really want to do.

The beauty of CSS variables is their reactive nature . As soon as they are updated, whatever property has the value of the CSS variable gets updated as well.

Conceptually, here’s an image that explains the process with regards to the example at hand.

![](https://cdn-images-1.medium.com/max/800/1*ZONC-xXCXnGc8nr_QMv8rg.png)

The process.

So, we need some JavaScript for the click listener.

For this simple example, the background and color of the text of the entire page is based off of CSS variables.

When you click any of the buttons above, they set the CSS variable to some other color. As a result of that, the background of the page is updated.

Hey, that’s all there is to it.

Uh, one more thing.

When I say the CSS variable is set to some other value, how’s that done?

![](https://cdn-images-1.medium.com/max/800/1*FeTfEPsJuDQNGDuZQQBIew.png)

Set the variable inline.

CSS variables will take effect even if they are set inline. With JavaScript, we get a hold of the root document, and we set the new value for the CSS variable inline.

Got that?

That’s a lot of talking — let’s do the real thing.

### The initial markup

The initial markup needed is this:

```
<div class="theme">
  <button value="dark">dark</button>
  <button value="calm">calm</button>
  <button value="light">light</button>
</div>

<article>
...
</article>
```

The markup consists of three buttons within a `.theme` parent element. To keep things short I have truncated the content within the `article` element. Within this `article` element is the content of the page.

### Styling the Page

The success of this project begins with the styling of the page. The trick is simple.

Instead of just setting the `background-color` and `color` of the page in stone, we will set them based on variables.

Here’s what I mean.

```
body {
  background-color: var(--bg, white);
  color: var(--bg-text, black)
}
```

The reason for this is kind of obvious. Whenever a button is clicked, we will change the value of both variables within the document.

Upon this change, the overall style of the page will be updated. Easy-peasy.

![](https://cdn-images-1.medium.com/max/800/1*HmDLDbOPHpEE2F8x4aSDYA.png)

So, let’s go ahead and handle the update from JavaScript.

#### Getting into the JavaScript

I’ll go ahead and spit out all the JavaScript needed for this project.

```
const root = document.documentElement
const themeBtns = document.querySelectorAll('.theme > button')

themeBtns.forEach((btn) => {
  btn.addEventListener('click', handleThemeUpdate)
})

function handleThemeUpdate(e) {
  switch(e.target.value) {
    case 'dark':
      root.style.setProperty('--bg', 'black')
      root.style.setProperty('--bg-text', 'white')
      break
    case 'calm':
       root.style.setProperty('--bg', '#B3E5FC')
       root.style.setProperty('--bg-text', '#37474F')
      break
    case 'light':
      root.style.setProperty('--bg', 'white')
      root.style.setProperty('--bg-text', 'black')
      break
  }
}
```

Don’t let that scare you. It’s a lot easier than you probably think.

First off, keep a reference to the root element, `const root = document.documentElement`

The root element here is the `HTML` element. You’ll see why this is important in a bit. If you’re curious, it is needed to set the new values of the CSS variables.

Also, keep a reference to the buttons too, `const themeBtns = document.querySelectorAll('.theme > button')`

`querySelectorAll` yields an array-like data structure we can loop over. Iterate over each of the buttons and add an event listener to them, upon click.

Here’s how:

```
themeBtns.forEach((btn) => {
  btn.addEventListener('click', handleThemeUpdate)
})
```

Where’s the `handleThemeUpdate` function? I’ll discuss that next.

Every button being clicked will have the `handleThemeUpdate` as its callback function. It becomes important to note what button was clicked and then perform the right operation.

In the light of that, a switch `operator` is used, and some operations are carried out based on the value of the button being clicked.

Go ahead and take a second look at the block of JavaScript code. You’ll understand it a lot better now.

### Project 3: Building the CSS Variable Booth 🤣

In case you missed it, here’s what we’ll build:

![](https://cdn-images-1.medium.com/max/800/1*E6H-wT6a0BDR9OJK7Z0dTA.gif)

Remember that the color of the boxes are dynamically updated, and that the box container is rotated in 3d space as the range input is changed.

![](https://cdn-images-1.medium.com/max/800/1*iy_MjZVlp-H0KUQa7H7fUg.gif)

You can go ahead and play with it on [Codepen](https://codepen.io/ohansemmanuel/full/EoBLgd/).

This is a superb example of updating CSS variables with JavaScript and the reactivity that comes with it.

Let’s see how to build this.

#### The Markup

Here are the needed components.

1.  A range input
2.  A container to hold the instructions
3.  A section to hold a list of other boxes, each containing input fields

![](https://cdn-images-1.medium.com/max/800/1*39k9sbEsldtRtJ1-Woq0rQ.png)

The markup turns out simple.

Here it is:

```
<main class="booth">
  <aside class="slider">
    <label>Move this 👇 </label>
    <input class="booth-slider" type="range" min="-50" max="50" value="-50" step="5"/>
  </aside>

  <section class="color-boxes">
    <div class="color-box" id="1"><input value="red"/></div>
    <div class="color-box" id="2"><input/></div>
    <div class="color-box" id="3"><input/></div>
    <div class="color-box" id="4"><input/></div>
    <div class="color-box" id="5"><input/></div>
    <div class="color-box" id="6"><input/></div>
  </section>

  <footer class="instructions">
    👉🏻 Move the slider<br/>
    👉🏻 Write any color in the red boxes
  </footer>
</main>
```

Here are a few things to point your attention to.

1.  The range input represents values from `-50` to `50` with a step value of `5` Also, the value of the range input is the minimum value, `-50`
2.  If you aren’t sure how the range input works, check it out on [w3schools](https://www.w3schools.com/jsref/dom_obj_range.asp)
3.  Note how the section with class `.color-boxes` contains other `.color-box` containers. Within these containers exist input fields.
4.  It is perhaps worth mentioning that the first input has a default value of red.

Having understood the structure of the document, go ahead and style it like so:

![](https://cdn-images-1.medium.com/max/800/1*LbgNgLeTjACXCfDBExkqgg.png)

1.  Take the `.slider` and `.instructions` containers out of the document flow. Position them absolutely.
2.  Give the `body` element a sunrise background color and garnish the background with a flower in the bottom left corner
3.  Position the `color-boxes` container in the center
4.  Style the `color-boxes` container

Let’s knock these off.

The following will fix the first task.

```
/* Slider */
.slider,
.instructions {
  position: absolute;
  background: rgba(0,0,0,0.4);
  padding: 1rem 2rem;
  border-radius: 5px
}
.slider {
  right: 10px;
  top: 10px;
}
.slider > * {
  display: block;
}


/* Instructions */
.instructions {
  text-align: center;
  bottom: 0;
  background: initial;
  color: black;
}
```

The code snippet isn’t as complex as you think. I hope you can read through and understand it. If not, drop a comment or tweet.

Styling the `body` is a little more involved. Hopefully, you understand CSS well.

Since we aspire to style the element with a background color and a background image, it’s perhaps the best bet to use the `background` shorthand property to set multiple backgrounds.

Here it is:

```
body {
  margin: 0;
  color: rgba(255,255,255,0.9);
  background: url('http://bit.ly/2FiPrRA') 0 100%/340px no-repeat, var(--primary-color);
  font-family: 'Shadows Into Light Two', cursive;
}
```

The `url` bit is the link to the sunrise flower.

The next set of properties `0 100%` represent the background position of the image.

Here’s an illustration of how CSS background positioning works:

![](https://cdn-images-1.medium.com/max/800/1*uFlBKNdQ-FOcZ-XaACi4uA.png)

From: [the advanced guide to CSS](http://bit.ly/learn_css)

![](https://cdn-images-1.medium.com/max/800/1*NOPEnEV_H2RB8XYFxEcFpA.png)

From: [the advanced guide to CSS](http://bit.ly/learn_css)

The other bit after the forward slash represents the `background-size` This has been set to `340px` If you made this smaller, the image would be smaller too.

`no-repeat`, you might figure out what that does. It prevents the background from repeating itself.

Finally, anything that comes after the comma is a second background declaration. This time we’ve only set the `background-color` to `var(primary-color)`

Oops, that’s a variable.

The implication of this is that you have to define the variable. Here’s how:

```
:root {
  --primary-color: rgba(241,196,15 ,1)
}
```

The primary color there is the sunrise yellow color. No big deal. We’ll set some more variables in there soon.

Now, let’s center the `color-boxes`

```
main.booth {
  min-height: 100vh;

  display: flex;
  justify-content: center;
  align-items: center;
}
```

The main container acts as a flex container and rightly positions the direct child in the center of the page. This happens to be our beloved `color-box` container

Let’s make the color-boxes container and its children elements pretty.

First, the child elements:

```
.color-box {
  padding: 1rem 3.5rem;
  margin-bottom: 0.5rem;
  border: 1px solid rgba(255,255,255,0.2);
  border-radius: 0.3rem;
  box-shadow: 10px 10px 30px rgba(0,0,0,0.4);
}
```

That will do it. There’s a beautiful shadow added too. That’ll get us some cool effects.

That is not all. Let’s style the overall `container-boxes` container:

```
/* Color Boxes */
.color-boxes {
  background: var(--secondary-color);
  box-shadow: 10px 10px 30px rgba(0,0,0,0.4);
  border-radius: 0.3rem;

  transform: perspective(500px) rotateY( calc(var(--slider) * 1deg));
  transition: transform 0.3s
}
```

Oh my!

There’s a lot in there.

Let me break it down.

Here’s the simple bit:

```
.color-boxes {
   background: var(--secondary-color);
   box-shadow: 10px 10px 30px rgba(0,0,0,0.4);
   border-radius: 0.3rem;
}
```

You know what that does, huh?

There’s a new variable in there. That should be taken of by adding it to the root selector.

```
:root {
  --primary-color: rgba(241,196,15 ,1);
  --secondary-color: red;
}
```

The secondary color is red. This will give the container a red background.

Now to the part that probably confused you:

```
/* Color Boxes */
.color-boxes {
  transform: perspective(500px) rotateY( calc(var(--slider) * 1deg));
  transition: transform 0.3s
}
```

For a moment, we could simplify the value of the transform property above.

![](https://cdn-images-1.medium.com/max/800/1*oNaNYDRDRZPSEga9Oo4bPw.png)

For example:

```
transform: perspective(500px) rotateY( 30deg);
```

The transform shorthand applies two different functions. One, the perspective, and the other, the rotation along the Y axis.

Hmmm, so what’s the deal with the `perspective` and `rotateY` functions?

The perspective() function is applied to an element that is being transformed in 3D space. It activates the three dimensional space and gives the element depth along the z-axis.

You can read more about the perspective function on [codrops](https://tympanus.net/codrops/css_reference/transform/#section_perspective).

The `rotateY` function, what’s the deal with that?

Upon activation the 3d space, the element has the planes x, y, z. The `rotateY` function rotates the element along the `Y` plane.

The following diagram from [codrops](https://tympanus.net/codrops/css_reference/transform/#section_rotate3d) is really helpful for visualizing this.

![](https://cdn-images-1.medium.com/max/800/1*kFdzSl4wwyPJt_Crmbtuow.png)

[Codrops](https://tympanus.net/codrops/css_reference/transform/#section_rotate3d)

I hope that blew off some of the steam.

Back to where we started.

![](https://cdn-images-1.medium.com/max/800/1*oNaNYDRDRZPSEga9Oo4bPw.png)

When you move the slider, do you know what function affects the rotation of the `.container-box`?

It’s the rotateY function being invoked. The box is rotated along the Y axis.

Since the value passed into the rotateY function will be updated via JavaScript, the value is represented with a variable.

![](https://cdn-images-1.medium.com/max/800/1*oL_Ik1Xg_ByTc28g2B1ESg.png)

So, why multiply by the variable by 1deg?

As a general rule of thumb, and for explicit freedom, it is advised that when building single tokens, you store values in your variables without units.

You can convert them to any unit you want by doing a multiplication via the `calc` function.

![](https://cdn-images-1.medium.com/max/800/1*jsB27oUUYY48n3s9wAmd_Q.png)

This allows you to do ‘whatever’ you want with these values when you have them. Want to convert to `deg` or as a ratio of the user’s viewport `vw` , you can whatever you want.

In this case, we are converting the number to have a degree by multiplying the “number” value by 1deg

![](https://cdn-images-1.medium.com/max/800/1*5j1qhUmE2pB99qw17Zp4iA.png)

Since CSS doesn’t understand math, you have to pass this arithmetic into the calc function to be properly evaluated by CSS.

Once that is done, we’re good to go. The value of this variable can be updated in JavaScript as much as we like.

Now, there’s just one bit of CSS remaining.

Here it is:

```
/* Handle colors for each color box */
.color-box:nth-child(1) {
  background: var(--bg-1)
}
.color-box:nth-child(2) {
  background: var(--bg-2)
}
.color-box:nth-child(3) {
  background: var(--bg-3)
}
.color-box:nth-child(4) {
  background: var(--bg-4)
}
.color-box:nth-child(5) {
  background: var(--bg-5)
}
.color-box:nth-child(6) {
  background: var(--bg-6)
}
```

So, what’s this voodoo?

First off, the nth-child selector selects each of the child boxes.

![](https://cdn-images-1.medium.com/max/800/1*T5oqa3Kh5ChIcgi5ldqXKg.png)

There’s a bit of foresight needed here. We know we will be updating the background color of each box. We also know that this background color has to be represented by a variable so it is accessible via JavaScript. Right?

We could go ahead and do this:

```
.color-box:nth-child(1) {
  background: var(--bg-1)
}
```

Easy.

There’s one problem though. If this variable isn’t present, what happens?

We need a fallback.

This works:

```
.color-box:nth-child(1) {
  background: var(--bg-1, red)
}
```

In this particular case, I have chosen NOT to provide any fallbacks.

If a variable used within a property value is invalid, the property will take on its initial value.

Consequently, when `--bg-1` is invalid or NOT available, the background will default to its initial value of transparent.

Initial values refer to the values of a property when they aren’t explicitly set. For example, if you don’t set the `background-color` of an element, it will default to `transparent`

Initial values are kind of default property values.

### Let’s write some JavaScript

There’s very little we need to do on the JavaScript side of things.

First let’s handle the slider.

We just need 5 lines for that!

```
const root = document.documentElement
const range = document.querySelector('.booth-slider')

//as slider range's value changes, do something
range.addEventListener('input', handleSlider)

function handleSlider (e) {
  let value = e.target.value
  root.style.setProperty('--slider', value)
}
```

That was easy, huh?

Let me explain just in case I lost you.

First off, keep a reference to the slider element, `const range = document.querySelector('.booth-slider')`

Set up an event listener for when the value of the range input changes, `range.addEventListener('input', handleSlider)`

Write the callback, `handleSlider`

```
function handleSlider (e) {
  let value = e.target.value
  root.style.setProperty('--slider', value)
}
```

![](https://cdn-images-1.medium.com/max/800/1*bQwZp0psRdiNn2harZW-HQ.png)

`root.style.setProperty('--slider', value)` says, get the `root` element (HTML) , grab its style, and set a property on it.

### Handling the color changes

This is just as easy as handling the slider value change.

Here’s how:

```
const inputs = document.querySelectorAll('.color-box > input')

//as the value in the input changes, do something.
inputs.forEach(input => {
  input.addEventListener('input', handleInputChange)
})

function handleInputChange (e) {
  let value = e.target.value
  let inputId = e.target.parentNode.id
  let inputBg = `--bg-${inputId}`
  root.style.setProperty(inputBg, value)
}
```

Keep a reference to all the text inputs, `const inputs = document.querySelectorAll('.color-box > input')`

Set up an event listener on all the inputs:

```
inputs.forEach(input => {
   input.addEventListener('input', handleInputChange)
})
```

Write the `handleInputChange` function:

```
function handleInputChange (e) {
  let value = e.target.value
  let inputId = e.target.parentNode.id
  let inputBg = `--bg-${inputId}`
  root.style.setProperty(inputBg, value)
}
```

![](https://cdn-images-1.medium.com/max/800/1*A3e4duLT1V1-8_NqVF1DGg.png)

Phew…

That’s it!

Project’s done.

### How did I miss this?

I had completed and edited the initial draft of this article when I noticed I didn’t mention browser support anywhere. So, let me fix my mess.

Browser support for CSS variables (aka custom properties) isn’t bad at all. It’s pretty good, with decent support across all modern browsers (over 87% at the time of this writing).

![](https://cdn-images-1.medium.com/max/800/1*JdhBIufk2SvuY-8U2POD8g.png)

[caniuse](https://caniuse.com/#search=css%20var)

So, can you use CSS variables in production today? I’ll say yes! Be sure to check what the adoption rate is for yourself, though.

On the bright side, you can use a preprocessor like [Myth](http://www.myth.io). It’ll preprocess your ‘future’ CSS into something you use today. How cool, huh?

If you have some experience using [postCSS](http://postcss.org), that’s equally a great way to use future CSS today. Here’s a [postCSS module for CSS variables](https://www.npmjs.com/package/postcss-css-variables).

That’s it. I’m done here.

### Oops, but I’ve got Questions!

![](https://cdn-images-1.medium.com/max/600/1*Bb085Ip_NKnPDVY7g3lL3g.png)

[Get the Ebook](https://gum.co/lwaUh) for offline reading, and also get a **private** slack invite where you can ask me anything.

That’s a fair deal, right?

Catch you later! 💕


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
