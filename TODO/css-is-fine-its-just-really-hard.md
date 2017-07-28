> * 原文地址：[CSS is Fine, It’s Just Really Hard](https://medium.com/@jdan/css-is-fine-its-just-really-hard-638da7a3dce0)
> * 原文作者：该文章已获原作者 [Jordan Scales](https://medium.com/@jdan) 授权
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者： [ZhangFe](https://github.com/ZhangFe)
> * 校对者：[bambooom](https://github.com/bambooom)，[gy134340](https://github.com/gy134340)

---

# CSS很棒，只是真的太难了

大家对CSS再次感到不安。现在是时候站在制高点 [写一些讽刺性的文章](https://medium.com/friendship-dot-js) 让自己感觉好一些了，不过今天说的是一些热门话题。

CSS 很棒。它只是太难了，所以我对它进行了一些编译。

—

我叫 Jordan ，我写过很多的 JavaScript 和 CSS，而且我真的非常擅长这两件事。如果 CSS 是奥运会项目的话我很容易就能获得参赛资格，但是可能得不到奖牌。不过我并不需要一个奖牌，因为我有一个计算机相关的奖杯。

![](https://cdn-images-1.medium.com/max/1600/1*ioYNZ-FgsSpoos6b3iKblg.png)

很长一段时间以来，我在电脑和手机上画了很多很多的矩形。我写了很多糟糕的 CSS，成千上万行差劲的 Less 代码和大量可怕的 Sass。他们已经融入我的血液了。

但是我也写过很多很棒的 CSS！我使用 borders 画过三角形，使用 CSS transforms 绘制贝塞尔曲线，制作 60fps 的滚动动画，以及会让你大吃一惊的工具提示。

CSS 是一项非常棒的技术。给我 30 秒我可以写一些纯 HTML 并且使用你见过的最丑的蓝色和 Times New Roman 字体展示一些文本和超链接。再给我 30 秒我又会使那个蓝色好看一些，并且我可以用一个漂亮的字体。

它非常直观。如果我想我所有的链接看起来一样，我随时可以办到。希望图片有漂亮的边框和外边距？没问题。这就是 CSS 被创造的原因。

CSS性能极高。长久以来，很多人都在为了让 CSS 更快速，可调试以及看起来更舒适做出努力。CSS 现在也是这么发展的，并且我们可以免费使用这些复杂的工具，这简直太棒了。更不用说我们可以利用 Google 搜索快速检索到无数的博客和超酷的示例。

—

当我年轻的时候，我发现每当我想让边框和超链接文本是同一个颜色的时候我都需要在两三个不同的地方去修改，这真是太可怕了。然后我发现了 LESS。现在我可以定义一个 `@wonderfulBlue` 并且在任何地方去使用它。**喂，Jordan，现在的 CSS 也有变量了...**


然后我开始考虑为什么要为解释 `#left-section` 的宽度是546px（250 * 2 + 23 * 2）留下很长的注释？我开始使用 Less 写我的数学表达式：`2 * @sectionWidth + 2 * @sectionPadding`。**我猜测你不熟悉 calc()，因为它浏览器兼容性不好**

当年 `border-radius` 需要被 polyfill 时，我在所有使用到的地方添加前缀。后来我使用了 `border-radius()` mixin，这样只要在我需要使用的时候把代码添加上就可以了。**好吧如果你只用到了组件分类呢 —**。伙计你能停一停么？让我完成我的文章先。**我错了 —**。没事，别担心，继续听下去。

当 CSS 解决不了我的问题时，我开始写 Less。它们会被编译成 CSS，并且它在我的用户的设备上工作的非常棒。只是我比原来忙了 10 倍，我无法单独去编写它了。

—

我开始[团队协作](https://www.khanacademy.org/)，在这些大型页面上有很多类和变量。我的工作就是对现有的标记做导航，复用变量，将常见的模式重构为自己的实用类和方法，以及其他所有开发者应该做的事。

他们中的某些页面已经很庞大了，因此通常我们会将我们的 CSS （好吧，Less）和 JavaScript 分割成独立的文件，这样用户就不必下载练习页面的代码来观看视频。

有些时候，我们移除了很多代码后样式看起来就不对了。因为我们的主页菜单可能希望有一个 `.left-arrow` 类，但是现在这个 class 的样式在 `exercise.css` 文件里。通常我们注意不到这点，因为导航条被鼠标点击几次后 `.left-arrow` 会被整齐地卷起来。**这么看来你应该有截图测试或更严格的 QA 过程**，我刚才说了什么来着？

唉，这是很辛苦的工作！但是代码就是偶尔会出 bug，修复它们并且继续前进，这是件很酷的事。

解决这个问题的方案就是使用 [BEM](http://getbem.com/) 和 [SMACSS](https://smacss.com/) 的形式。你会发现这些带有短横线和下划线的新颖类名是一个非常棒的组织你代码的形式。

但是，呃，这很奇怪。为什么我要花时间手动地将我们的 CSS 重构成这些类名呢？它应该是自动化的，是 grunt 的工作，但是现在它充满了人为错误。

—

现在是时候讲一个有关我祖母手工为打卡机编写机器码的个人故事了。好吧，我的祖母并没有这么做，她为福利委员会的参议员工作，即便她已经很聪明了，她也没有足够的时间去做计算机相关的事。我可以撒谎，但是为什么要做这种事呢？

不管怎样，想象一下假如我的祖母真的为打卡机写了机器码呢？又一次充满着人为的错误！出了一个 bug？重新敲一遍。卡片丢地上了？捡起来然后重新排序，或者直接重新开始。很奇怪吧？我们不能让机器帮我们做这些事么？


这正是我理论上的祖母做的，她制作了一个机器为她打卡。好吧，她没这么做，但是别人做了！我们有很酷的东西，如汇编语言，FORTRAN，和C语言。人们会把新技术发展的每一步都发布到 twitter 上并且批评它。**只需要用打卡机！只需要用 FORTRAN！只需要用 C —**。好吧，我猜大家也是这么做的。

—

这就引申到到我这篇文章的重点。

CSS很好，速度很快，它已经发展了有20多年了，并且适用于各种应用程序。

但是我真的不喜欢写 CSS。很多人也不喜欢，所以我们开发了这些很棒的模式去写 CSS。但是我也不喜欢以这些模式去写，我有更好的事情要去做。并且 JavaScript 也很酷。**实际上 JavaScript 有更多的可能性**。[所以我用 JavaScript 去编写我的 CSS](https://github.com/khan/aphrodite).


把这样的代码:

    const Example = () => (
      <h1 className={css(styles.heading, styles.callout)}>
        Hello, world!
      </h1>
    )

    const styles = StyleSheet.create({
      heading: {
        fontFamily: "Comic Sans MS",
      },
      callout: {
        color: "tomato",
      },
      unused: {
        width: 600,
      },
    })

变成这个样子:

    <h1 class="heading_1flg42u-o_O-callout_1ih983s">Hello, world!</h1>

    ...

    .heading_1flg42u-o_O-callout_1ih983s {
        font-family: Comic Sans MS !important;
        color: tomato !important;
    }

看到没？依然是 CSS，干净、完美、教科书般的 CSS。但它不是我写的，机器完成了这件事。没用到的代码也被移除了，我可以在任何地方渲染 `<Example>` 并且能确保样式。

[我可以在任何地方呈现可汗学院的学习菜单](https://medium.com/@jdan/rendering-khan-academys-learn-menu-wherever-i-please-4b58d4a9432d)


—

我和你们是同一阵营的。CSS 非常棒，并且一次性把他们全部替代了是非常愚蠢的。就像 FORTRAN 没有替代低级汇编代码一样，[aphrodite](https://github.com/khan/aphrodite) 和 [styled-components](https://github.com/styled-components/styled-components) 并没有替换 CSS。他们正在编写 CSS。


但是请别再和我说去学学 CSS 了。我了解 CSS。往上翻，我有一个计算机奖杯。我的 CSS 非常棒，但现在更好，因为我正在尽可能的从中移除人为错误。我们不应该庆祝么？

嘿，我也答应你我会停止说 CSS 的坏话，如果写的话字数要比本文少得多，它更适合一个主题标签，让我们和好吧？

—

去关注我的 [twitter](https://twitter.com/jdan)，这样我们就可以互相争论了。如果我有一本书，我可能会链接到这里，但是没人会给我出书的邀约的。希望你喜欢这篇文章 ❤

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。


