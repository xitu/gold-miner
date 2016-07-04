>* 原文链接 : [Vectors For All (slight return)](https://blog.stylingandroid.com/vectors-for-all-slight-return/)
* 原文作者 : [stylingandroid](https://blog.stylingandroid.com)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [huanglizhuo](https://github.com/huanglizhuo)
* 校对者: [circlelove](https://github.com/circlelove) , [edvardHua](https://github.com/edvardHua)


大多数 Styling Android 的读者都知道我特别喜欢 _VectorDrawable_ 和 _AnimatedVectorDrawable_。 然而（在我写这篇文章时）我们仍然在期待 _VectorDrawableCompat_ 发布，现在我们现在只能在 API 21 (Lollipop) 以及更高的版本上使用。 然而，Android Studio 添加了一些向后兼容的构建工具，这样我们就能在 Lolipop 之前的版本中使用 _VectorDrawable_ 。这篇文章中会讲它是怎么工作的。

[![svg_logo2](https://i0.wp.com/blog.stylingandroid.com/wp-content/uploads/2015/12/svg_logo2.png?w=300%20300w,%20https://i0.wp.com/blog.stylingandroid.com/wp-content/uploads/2015/12/svg_logo2.png?resize=150%2C150%20150w)](https://i0.wp.com/blog.stylingandroid.com/wp-content/uploads/2015/12/svg_logo2.png?ssl=1)

在[之前的文章](https://blog.stylingandroid.com/vectors-for-all-almost/) 中我们知道 _VectorDrawable_ 的支持是在 Android Studio 1.4 时添加的，并且发现他缺少一些关键部分区域。首先 SVG 导入工具并不能很好的导入 SVG 素材；其次，为 API21 之前设备准备的自动将 SVG 转为 PNG 的工具会导致我们的图片错位。

随着 Android Studio 2.0 预览版的到来（写这篇文章的时候谷歌刚好开放了下载链接），我们再回头来看看这个工具是否有了改进。

和以前一样，我们将使用官方 SVG logo 作为我们的基准，因为它用了 SVG 很多方面来避免渐变（事实上因为性能问题而获得支持不太可能。）

如果我们通过 `New|Vector Asset|Local SVG File` 引入这个 logo （可以在 [SVG 论坛](http://www.w3.org/Icons/SVG/svg-logo-v.svg) 找到），在引入时不会有解析错误，但引入的东西却并不正确：

[![](http://ww3.sinaimg.cn/large/a490147fgw1f3qdvqii2ej208c08c745.jpg)](https://i0.wp.com/blog.stylingandroid.com/wp-content/uploads/2015/12/svg_logo3.png?ssl=1)

因为一个未支持的 SVG 特性导致这个问题，那就是本地 IRI 引用未支持。本地 IRI 应用允许特定的形状定义一次，然后在文档中多次使用，不论是笔画，填充，或是转换。官方的 SVG logo 定义了一个哑铃型的形状（一条线两端是圆）并用黑色和黄色填充，加上大量旋转形成像花一样的 SVG logo。类似的字母 ‘S’，‘V’，& ‘G’ 也是用同样的方法定义，导致也没有渲染出来。

退一步来讲，手动编辑 SVG 源文件然后将本地的 IRI 引用替换成形状定义并不是很难，但却是一个繁重的工作。

为了完整性我也尝试用 [Juraj Novák’s 在线转换工具](http://inloop.github.io/svg2android/), 做过转换，估计不会有更好的了-因为有本地 IRI 引用:

[![](http://ww3.sinaimg.cn/large/a490147fgw1f3qdwanyr0j208c08ca9z.jpg)](https://i1.wp.com/blog.stylingandroid.com/wp-content/uploads/2015/12/svg_logo4.png?ssl=1)

因此导入和转换 SVG 资料作为 VectorDrawable 还是有问题的。但公平来讲比上次我尝试的时候已经有很大的进步了。上次，我只得到了一堆没有意义的错误信息并不能帮助我定位问题。我猜对于不依赖本地 IRI 引用的 SVG 材料会有很大的概率成功-也就是说确实有提升。

那么把注意力放在工具链的另一部分：在编译时期将 _VectorDrawable_ 生成 PNG 文件。重述一下：如果你将 minSDKVersion 设为 21 以下，这将是构建工具的一部分，VectorDrawable 会自动生成对应的PNG 文件。当你的 APK 运行在 API 21 或者之后的设备上将会使用 VectorDrawable，在之前的设备上将会使用对应的 PNG 文件。换句话说，你只需要添加 VectorDrawable 文件编译工具会需要的时候自动帮你转换。

之前当我尝试这个的时候，我发现 _VectorDrawable_  中的 `<group></group>` 元素会被忽略，因此很多应用在 group 级的转译也会被忽略，最后 PNG 图片不会被正确渲染。

我现在可以激动的宣布这个问题已经被解决了，前面那张图经过我手工转换（去除本地 IRI 引用）之后可以完美的呈现出来了（这是我真实编译后的 PNG ）


[![](http://ww1.sinaimg.cn/large/a490147fgw1f3qdwqyc6nj208c08caaj.jpg)](https://i0.wp.com/blog.stylingandroid.com/wp-content/uploads/2015/12/svg_logo2.png?ssl=1)

不得不说我在写上一篇关于众多问题文章的时候相当失望，当时这些问题折腾了很久才勉强得出这个工具不能真正的用在工程当中。现在这些问题很多都已经解决了，而且很多工具我可以用在实际的工程当中。但是还存在很多导入和转换的问题，但总会有像 SVG 格式这样的问题会出现 - 没有两个 SVG 作者（不管是人还是软件）会用同一种方式做事情。但是如果这个工具以这种速度优化和完善的话或许能解决这些问题，但是谁又知道呢？

这篇文章并没有真正写代码，但前一篇的代码可以在 [这](https://github.com/StylingAndroid/Vectors4All/tree/master) 找到。


