> * 原文地址：[How I Learned SASS in 20 Hours and Why You Should Too.](https://medium.com/front-end-weekly/how-i-learned-sass-in-20-hours-and-why-you-should-too-a2fb92d0359c)
> * 原文作者：[Deepak](https://medium.com/@deepakgangwar4265)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/how-i-learned-sass-in-20-hours-and-why-you-should-too.md](https://github.com/xitu/gold-miner/blob/master/article/2020/how-i-learned-sass-in-20-hours-and-why-you-should-too.md)
> * 译者：
> * 校对者：

# How I Learned SASS in 20 Hours and Why You Should Too.

![Photo by [Kevin Ku](https://unsplash.com/@ikukevk?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/6706/0*CEjxaCtfB0OSJDzJ)

A Front-end developer’s world revolves around CSS for a lot of time and we love writing CSS and making our websites beautiful. But when it comes to efficiency we may have to consider Sass, a CSS preprocessor with great capabilities.

Vendor prefixes have always irritated me but for cross-browser compatibility you have to write them in CSS. SASS comes up with the solution and a lot more. Sass is simply ‘‘CSS with superpowers’’.

Recently I discovered Learning any skill in 20 hours by Josh Kaufman and it could transform my learning process, so I decided to do it. I set my goal to learn SASS in 20 hours.

I read the basics of what Sass is and an overview of what to expect after I have learned it.

## Deconstructing what I needed to learn

I prepared a syllabus of what I needed to learn to reduce struggle jumping from one resource to another and just wasting my time in tutorial hell. This process helps a lot to give a path to my learning.

1. What is a preprocessor
2. SASS or SCSS
3. Variables in sass
4. Partials
5. Nesting
6. Mixins in sass
7. Mixins with arguments
8. Passing content into mixins
9. Imports in sass
10. Nested media queries in sass
11. Sorting lists and maps in variables
12. Basic arithmetic
13. The sass shell
14. What are functions
15. Built-in functions
16. Inheritance with @extend
17. Sass placeholder
18. @extend vs @mixin
19. Conditional derivatives
20. Loops
21. Sass Frameworks (Susy, breakpoint &co)
22. Installing toolkit and frameworks
23. Compass

This is the syllabus I prepared. You can use it as your guide to what you have to learn in order to get good understanding of SASS.

#### The Process

I designed the syllabus for learning by sorting some of the best courses in SASS on udemy, pluralsight and codecademy and then looking for their common curriculum of SASS. This gives me the overall structure of it.

#### Finding Resources

A prefer to go through the documentation as it has the essence of why the language is born and is a great place to start with. You can also go for a good course if you want. In the case of Sass the official documentation is the best place to learn.

#### Practicing a lot

After learning the concepts, practice comes into the picture. I can’t stress enough on the importance of practice. Learn enough so that you can find mistakes in your own code. Find projects on front-end development or work on your own projects. the goal is **deliberate practice.**

## Why you should learn Sass?

Sass has a large developer community so most of the problems will have solutions available and are just a search away. The main aim is to make the coding process simpler and efficient. Sass has an easy learning curve so you won’t face any difficulty getting a grasp of it and it helps a lot in writing **cleaner, modular code in less time**.

## Guide to SASS for beginners-

* **SASS vs SCSS** The main difference is in the syntax as SCSS has braces and semi-colons like regular CSS whereas SASS is based on indentation, line breaks and tabs will do your job. Sass files have .sass extension and Scss files have .scss extension

```scss
.scss-code {
       color: white;
       background-color: #081018;
}

.sass-code
       color: white
       line-height: 40px
```

* **Variables** Suppose you work for a brand and they opt for a rebrand and change their brand colors. It will be a lot of work to change the color at infinite places, sass can help as you can define variables such as primary-color and change it only once to see the results.

```scss
$primary-color: #081018;

.btn-lg {
       background-color: $primary-color;
}
```

* **Nesting** In SASS you can nest style rules making selection much easier than CSS-

```
ul {
       list-style-type: none;
       li {
            display: inline;
       }
}
```

* **Vendor prefixes** Vendor prefixes are the additional rules we write for properties like box shadow for browser compatibility. In SASS you don’t have to, after compiling it automatically generates vendor prefixes for you.
* **Modular** A lot of times we struggle to find particular style rules for a specific element in that long stylesheet and it can take ages. Sass makes your code modular but implementing partials. You can have separate modules for header, sidebars, navbars, cards, footer, and import them in the main file just using @import or @use rule. This really saves a lot of time and makes the job a lot easier.
* **Extending** Sometimes we have some common rules which are used for many elements so instead of writing them again you can use @extend or @mixins from SASS. Mixins support passing in arguments which is not possible in extend rule.

---

The best place to learn SASS is the [SASS’s website](https://sass-lang.com/) because they have great documentation which makes it fairly easy to learn SASS and once you have a grip of concepts, practice a lot, try to do projects and challenges.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
