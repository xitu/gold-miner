> * 原文地址：[Exploring SMACSS: Scalable and Modular Architecture for CSS](https://www.toptal.com/css/smacss-scalable-modular-architecture-css)
> * 原文作者：[SLOBODAN GAJIC](https://www.toptal.com/resume/slobodan-gajic)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/smacss-scalable-modular-architecture-css.md](https://github.com/xitu/gold-miner/blob/master/TODO1/smacss-scalable-modular-architecture-css.md)
> * 译者：
> * 校对者：

# Exploring SMACSS: Scalable and Modular Architecture for CSS

When we are working on big projects or with groups of developers, we often find that our code is messy, difficult to read, and hard to extend. This is especially true after time passes and we come back and look at it again—we have to try to be in the same mindset where we were when we wrote it.

So what a lot of people have done is they have created [CSS](https://www.toptal.com/css) architectures to help to style their code so that CSS becomes more readable. **SMACSS**—i.e., **Scalable** and **Modular Architecture** for **CSS**—aims to do just that. It’s a particular set of CSS architecture guidelines from Jonathan Snook that I’ve adopted.

Now, the architectural approach of SMACSS is a bit different from a CSS framework like Bootstrap or Foundation. Instead, it’s a set of rules, more like a template or guide. So let’s dive into some CSS design patterns to find out how we can use them to make our code better, [cleaner](https://www.toptal.com/front-end/frontend-clean-code-guide), easier to read, and more modular.

Every SMACSS project structure uses five categories:

1.  Base
2.  Layout
3.  Modules
4.  State
5.  Theme

## Base

In SMACSS, base styles define what an element should look like anywhere on the page. They are the defaults. If you’re using a reset stylesheet, this ensures that your resulting styles are the same across browsers despite the differences among their internal, hard-coded base CSS defaults.

In a base style, you should only include bare element selectors, or those with pseudo-classes, but not with class or ID selectors. (You should have really good reason to put class or ID inside it, maybe only if you are styling a third-party plugin’s elements and you need to override the default styling for that particular element.)

Here is an example of how a base file unit should look:

```
html {
    margin: 0;
    font-family: sans-serif;
}

a {
    color: #000;
}

button {
    color: #ababab;
    border: 1px solid #f2f2f2;
}
```

So it should include default sizes, margins, colors, borders, and any other default values you plan to use across your website. Your typography and your form elements should have unified styles which appear on every page and give a feel and look that they are part of the same design and theme.

SMACSS or not, I highly recommend avoiding the use of `!important` as much as possible, and not to use deep nesting, but I will talk more about that later in this post. Also if your practice is to use reset CSS, this is the place where you should include it. (I prefer to use Sass, so I just include it at the top of the file, rather than having to copy it in or refer to it separately from each page’s `<head>` element.)

**Related:** [Theming with Sass: An SCSS Tutorial](https://www.toptal.com/sass/theming-scss-tutorial)

## Layout

Layout styles will divide the page into major sections—not sections like navigation or maybe the accordion, for example, but really top-level divisions:

![Example SMACSS layout styles: header, sidebar, content/main, and footer](https://uploads.toptal.io/blog/image/126678/toptal-blog-image-1532005221485-9d465e68a1d43f1f2c19d0cdc8e3b389.png)

SMACSS layout styles are for major sections like header, sidebar, content/main, and footer.

These layouts will hold multiple CSS modules like boxes, cards, unordered lists, galleries, and the like, but I will talk more about modules in the next section. Let’s consider an example web page to see what we can split into layouts:

![An example web page that can be organized into header, main, and footer layout styles using SMACSS](https://uploads.toptal.io/blog/image/126676/toptal-blog-image-1532003633585-029d918ef1d38dd3573bb593bb87cdda.png)

Here we have header, main, and footer. These layouts have modules like links and logo on the header at the top, boxes and articles on main, and links and copyright for the footer. We usually give layouts an ID selector, as they don’t repeat on the page and they are unique.

Also you should prefix rules for layout styles with the letter `l` to distinguish them from module styles. Usually here you would style things specific to layout, like border, alignments, margins, etc. Also the background of that part of the page could make sense, even if it doesn’t seem to be quite as layout-specific.

Here is an example of how it should look:

```
#header {  
    background: #fcfcfc;
}

#header .l-right {
    float: right;
}

#header .l-align-center {
    text-align: center;
}
```

You can also add these helpers for alignments which you can use to easily position elements by just adding the appropriate class to its child or to align its text.

For another example, you could use some default margins on a layout box, like `.l-margin` having a margin of `20px`. Then, wherever you want padding for some container, element, card, or box, you just add the `l-margin` class to it. But you want something reusable:

```
.l-full-width {
    width: 100%;
}
```

Not something internally coupled like this:

```
.l-width-25 {
    width: 25px;
}
```

* * *

I want to take a moment to talk about naming conventions in SMACSS. If you’ve never heard of the concept of namespacing in CSS, it’s basically adding the name to the beginning of another element to help distinguish it from anything else. But why do we need this?

I don’t know if you’ve ever run into the following problem. You’re writing CSS and you have a label on something—you put in whatever styles you like, and call your class `.label`. But then you come to another element later on, and you also want it to be `.label`, but style it differently. So two different things have the same name—a naming conflict.

Namespacing helps you resolve this. Ultimately, they are called the same thing on one level, but they have a different namespace—a different prefix—and thus can represent two different styles:

```
.box--label {
    color: blue;
}

.card--label {
    color: red;
}
```

## Module

Like I mentioned earlier, SMACSS modules are smaller bits of code that are reusable on the page, and they are part of a single layout. These are parts of CSS that we want to store in a separate folder, as we will have a lot of these on a single page. And as a project grows, we can split using folder structure best practices, i.e., by modules/pages:

![An example file/folder hierarchy using SMACSS and Sass](https://uploads.toptal.io/blog/image/126677/toptal-blog-image-1532004385659-636d848a5fbaad6340f79d6ad89ac1d8.png)

So in the previous example, we had an article, which can be a module on its own. How should CSS be structured here? We should have a class `.article` which can have child elements `title` and `text`. So to be able to keep it in the same module, we need to prefix the child elements:

```
.article {
    background: #f32;
}

.article--title {
    font-size: 16px;
}

.article--text {
    font-size: 12px;
}
```

You may notice that we are using two hyphens after the module prefix. The reason is that sometimes module names have two words or their own prefixes like `big-article`. We need to have two hyphens in order to tell what part of it is the child element—e.g. compare `big-article-title` to `big-article--title` and `big-article--text`.

Also, you can nest modules inside modules if a particular module takes a large portion of the page:

```
<div class="box">
    <div class="box--label">This is box label</div>
    <ul class="box--list list">
        <li class="list--li">Box list element</li>
    </ul>
</div>
```

Here, in this simple example, you can see that `box` is a module and `list` is another module inside it. So `list--li` is a child of the `list` module and not of the `box`. One of the key concepts here is to use two selectors max per each CSS rule, but in most scenarios to have only one selector with prefixes.

This way, we can avoid duplicating rules and also having extra selectors on child elements with the same names, thus improving speed. But it also helps us avoid using the unwanted `!important`-style rules, which are a sign of poorly structured CSS projects.

Good (note the single selector):

```
.red--box {
    background: #fafcfe;
}

.red-box--list {
    color: #000;
}
```

Bad (note the repetition within selectors and the overlapping reference method):

```
.red .box {
    background: #fafcfe;
}

.red .box .list {
    color: #000;
}

.box ul {
    color: #fafafa;
}
```

## State

What state defines in SMACSS is a way to describe how our modules look in different dynamic situations. So this part is really for interactivity: We want different behavior if an element is considered to be hidden, expanded, or modified. For example, a jQuery accordion will need help defining when you can or can’t see an element’s content. It helps us to define an element’s style at a specific time.

States are applied to the same element as layout so we are adding an additional rule which will override previous ones, if any. The state rule is given precedence, as it’s the last one in the chain of rules.

As with layout styles, we tend to use prefixes here. This helps us to recognize them and to give them priority. Here we use the `is` prefix, as in `is-hidden` or `is-selected`.

```
<header id="header">
    <ul class="nav">
        <li class="nav--item is-selected">Contact</li>
        <li class="nav--item">About</li>
    </ul>
</header>
```

```
.nav--item.is-selected {
    color: #fff;
}
```

Here, `!important` may be used, as state is often used as a JavaScript modification and not at render time. For example, you have element that’s hidden on page load. On button click, you want to show it. But the default class is like this:

```
.box .element {
    display: none;
}
```

So if you just add this:

```
.is-shown {
    display: block;
}
```

It will remain hidden even after you add the `.is-shown` class to the element via JavaScript. This is because the first rule is two levels deep and will override it.

So you can instead define the state class like this:

```
.is-shown {
    display: block !important;
}
```

This is how we distinguish state modifiers from layout ones, which apply only on a page’s initial load. This will work now while maintaining the advantages of minimal selectors.

## Theme

This one should be the most obvious, as it’s used to contain the rules of the primary colors, shapes, borders, shadows, and such. Mostly these are elements which repeat across a whole website. We don’t want to redefine them each time we create them. Instead we want to define a unique class which we only add on later to a default element.

```
.button-large {
    width: 60px;
    height: 60px;
}
```

```
<button class="button-large">Like</button>
```

Don’t confuse these SMACSS theme rules with base ones, since base rules target only default appearance and they tend to be something like resetting to default browser settings, whereas a theme unit is more of a type of styling where it gives the final look, unique for this specific color scheme.

Theme rules can also be useful if a site has more than a single style or perhaps a couple of themes used in different states and therefore can be easily changed or swapped during some events on a page, e.g. with a theme-switch button. At the very least, they keep all theme styles in one place so you can change them easily and keep them nicely organized.

## CSS Organization Methodologies

I’ve covered some of the key concepts of this CSS architecture idea. If you want to learn more about this concept you can visit [the official website of SMACSS](https://smacss.com/) and get deeper into it.

Yes, you can probably use more advanced methodologies like [OOCSS and BEM](https://medium.com/@Intelygenz/how-to-organize-your-css-with-oocss-bem-smacss-a2317fa083a7). The latter covers almost the complete frontend workflow and its technologies. But some may find BEM selectors too long and overwhelming and also too complicated to use. If you need something simpler that’s easier to pick up and to incorporate into your workflow—and also something that defines ground rules for you and your team—SMACSS is a perfect fit.

It will be easy for new team members not only to understand what previous developers did, but also to start working on it instantly, without any differences in coding style. SMACSS is just a CSS architecture and it does what it says on the tin—nothing more and nothing less.

## UNDERSTANDING THE BASICS

### What are the different types of CSS?

There are three types. Inline CSS is placed directly on an HTML element's style attribute. Internal CSS sits inside style tags in the HTML header. External CSS is a separate file sourced by an HTML file, avoiding duplication both within and between the HTML pages on a website.

### What is meant by "CSS template"?

CSS templates are usually specific layouts defined such that we can use them on multiple pages or even websites. Sometimes they go beyond layout, defining a set of rules for specific types of elements like modals and buttons, or even groups of them. Some also define default styles for HTML elements.

### Why is CSS so important?

CSS is absolutely a must in modern day web pages. Without it, web pages are just plain text and pictures on a blank background. It not only gives style to the page, but also organizes layout and provides effects and animations—so it's important for interactivity as well.

### What are the advantages of using CSS?

One of the main advantages is to have all styles in one place rather than having them across a whole web page on every element. It gives us more formatting options and helps optimize both page load time and code reuse.

### Why is scalability so important?

In general, scalability is important in order to stay extensible and maintainable as a project grows. With CSS in particular, if we don't write scalable and modular code, it quickly grows out of control, becoming hard to understand and to work on, especially for newcomers. Hence the need for SMACSS.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
