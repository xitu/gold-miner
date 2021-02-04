> * 原文地址：[How I Learned SASS in 20 Hours and Why You Should Too.](https://medium.com/front-end-weekly/how-i-learned-sass-in-20-hours-and-why-you-should-too-a2fb92d0359c)
> * 原文作者：[Deepak](https://medium.com/@deepakgangwar4265)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/how-i-learned-sass-in-20-hours-and-why-you-should-too.md](https://github.com/xitu/gold-miner/blob/master/article/2020/how-i-learned-sass-in-20-hours-and-why-you-should-too.md)
> * 译者：[z0gSh1u](https://github.com/z0gSh1u)
> * 校对者：[Rachel Cao](https://github.com/rachelcdev)、[hansonfang](https://github.com/hansonfang)

# 我是如何用 20 小时学会 Sass 的以及为什么你也应该这么做

![Photo by [Kevin Ku](https://unsplash.com/@ikukevk?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/6706/0*CEjxaCtfB0OSJDzJ)

一名前端开发人员的世界在很多时候围着 CSS 转，并且我们喜欢写 CSS 来让网站变漂亮。但当涉及到效率时，我们可能必须考虑 Sass，一款功能强大的 CSS 预处理器。

浏览器产商前缀一直搞得我很烦，但为了跨浏览器兼容性，你又必须在 CSS 里写。Sass 带来了解决方案和其他很多东西。Sass 就是“超能力版 CSS”。

最近，我从 Josh Kaufman 那发现了用 20 小时学会任何技能的方法，并且可以迁移到我的学习过程中，所以我就决定这么做了。我设定了一个目标：用 20 小时学会 Sass。

我阅读了 Sass 的基础知识，并大概了解了我学完它后应该获得什么。

## 分解看看我需要学什么

我准备了一份需要学什么的大纲，从而减少在各个资源之间漫游、在教程的海洋中浪费时间的情况。这个流程极大地帮助了我确定一条学习路线。

1. 预处理器是什么
2. Sass 还是 Scss
3. Sass 中的变量
4. 局部文件
5. 嵌套
6. Sass 中的 Mixin
7. 带参 Mixin
8. 向 Mixin 传递内容
9. Sass 中的导入
10. Sass 中的嵌套媒体查询
11. 排序变量中的 List 和 Map
12. 算术基础
13. Sass 的 Shell
14. 函数是什么
15. 内建函数
16. 使用 @extend 实现继承
17. Sass 占位符
18. @extend 还是 @mixin
19. 有条件的派生
20. 循环
21. Sass 框架（Susy、breakpoint 和 co）
22. 安装工具包和框架
23. Compass

这是我准备的大纲。你可以把它当作你必须要学的内容的学习指南，从而更好地理解 Sass。

#### 过程

我通过整理在 udemy、pluralsight 和 codecademy 上面的关于 Sass 的优质课程，探究了一下它们间的相似之处，设计了这份大纲。这给我的 Sass 学习构建了一个大概的结构。

#### 寻找资源

我更喜欢通读文档，因为它包括了这门语言为什么诞生的精髓，同时也是很好的入门资源。如果你想，你也可以去找一个好的课程。对于 Sass 来说，官方文档就是最好的学习之处。

#### 多加练习

在学习了概念后，就需要进行练习。我再怎么强调练习的重要性也是不够的。充分地学习，从而你能找到自己代码中的错误。找一些前端项目，或者做一做你自己的项目，目的就是主动地练习。

## 为什么你应该学 Sass？

Sass 拥有一个大的开发者社区环境，所以大多数问题都有现成的解决方案，只需要搜索即可。最主要的目标就是让编码过程简单而高效。Sass 有着平滑的学习曲线，所以你在掌握它的过程中不会遇到什么困难，并且它会极大地帮助你，花更少的时间写出更加简洁、模块化的代码。

## 给 Sass 初学者的指引

* **Sass 还是 Scss** 最主要的区别是语法方面的，Scss 有大括号和分号，就像平常的 CSS 一样，而 Sass 是基于缩进、换行和制表符的。Sass 文件的后缀是 .sass，Scss 文件的后缀是 .scss。

```scss
.scss-code {
       color: white;
       background-color: #081018;
}

.sass-code
       color: white
       line-height: 40px
```

* **变量** 设想你为某品牌工作，他们打算重做一下商标，改变商标的颜色。到处修改颜色属性会很费工夫，而 Sass 可以帮你，因为你可以定义变量，比如 primary-color，然后修改一次就能看到结果。

```scss
$primary-color: #081018;

.btn-lg {
       background-color: $primary-color;
}
```

* **嵌套** 在 Sass 中，你可以用比 CSS 简单得多的选择器来嵌套样式规则。

```
ul {
       list-style-type: none;
       li {
            display: inline;
       }
}
```

* **浏览器产商前缀** 浏览器产商前缀是我们为了浏览器兼容性，给 box-shadow 之类的属性添加的额外规则。在 Sass 中你不需要这么做。在编译后，它会为你自动生成浏览器厂商前缀。
* **模块化** 长期以来，我们经常要花很多工夫在长长的样式表中，找到一个特定元素的样式规则。Sass 让你的代码模块化、实现局部化。你可以为 header、sidebar、navbar、cards、footer 编写独立的规则文件，然后只需用 @import 或者 @use 就可以在主文件中导入它们。这真的会省很多时间，也让事情变得简单多了。
* **继承** 有时候，我们会有在很多元素上使用的公共的样式。无需再写一次，你可以使用 Sass 中的 @extend 或 @mixins。mixins 支持传入参数，extend 就不支持了。

---

学 Sass 最好的地方就是 [Sass 的官网](https://sass-lang.com/)，因为他们写了很棒的文档，使得学习 Sass 相当的简单。你把握了主要概念后，就多加练习，试着做一些项目和挑战。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
