>* 原文链接 : [Vectors For All (slight return)](https://blog.stylingandroid.com/vectors-for-all-slight-return/)
* 原文作者 : [stylingandroid](https://blog.stylingandroid.com)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


Regular readers of Styling Android will know of my love of _VectorDrawable_ and _AnimatedVectorDrawable_. While (at the time of writing) we’re still waiting for _VectorDrawableCompat_ so we can only use them on API 21 (Lollipop) and later. However, Android Studio keeps added some backwards compatibility to the build tools so we can actually begin to use _VectorDrawable_ for pre-Lollipop. In this article we’ll take a look at how this works.  

[![svg_logo2](https://i0.wp.com/blog.stylingandroid.com/wp-content/uploads/2015/12/svg_logo2.png?w=300%20300w,%20https://i0.wp.com/blog.stylingandroid.com/wp-content/uploads/2015/12/svg_logo2.png?resize=150%2C150%20150w)](https://i0.wp.com/blog.stylingandroid.com/wp-content/uploads/2015/12/svg_logo2.png?ssl=1)In a [previous article](https://blog.stylingandroid.com/vectors-for-all-almost/) we looked at the _VectorDrawable_ support that was added to Android Studio 1.4 and found it was lacking in a few key areas. Firstly the SVG import tool really did not do a great job of importing SVG assets; Secondly, the auto conversion of SVG to PNG for pre-API21 devices mangled our graphics when it generated the PNGs.

With the arrival of Android Studio 2.0 Preview releases (at the time of writing Preview 2 has just been released) it seemed a good time to re-visit this and see if anything has improved.

As before we’re going to use the official SVG logo as our benchmark as it uses many aspects of SVG whilst avoiding gradients (which realistically are unlikely to be supported any time soon for performance reasons).

If we import the logo (available in [SVG form](http://www.w3.org/Icons/SVG/svg-logo-v.svg)) using `New|Vector Asset|Local SVG File` we no longer get a parsing error when we import, but what actually gets imported isn’t quite right:

[![](http://ww3.sinaimg.cn/large/a490147fgw1f3qdvqii2ej208c08c745.jpg)](https://i0.wp.com/blog.stylingandroid.com/wp-content/uploads/2015/12/svg_logo3.png?ssl=1)

There is only really one missing aspect of SVG support which is causing this: Local IRI references are not supported. Local IRI references allow a specific shape to be defined once, and then used multiple times within the document with different strokes, fills and transformations. The official SVG logo defines a dumbbell-like shape (a line with circles at each end) in such a way and uses it with a black and yellow fills, plus various rotations to get the flower-like component of the SVG logo. Similarly the letters ‘S’, ‘V’, & ‘G’ are defined in the same way and do not get rendered as a result.

It isn’t overly difficult to manually edit the source SVG and replace any Local IRI references with copies of the shape definition that they are referencing, but it is an onerous task, to say the least.

For the sake of completeness I also tried converting the logo using the [Juraj Novák’s online conversion tool](http://inloop.github.io/svg2android/), which fared no better – again because of local IRI references:

[![](http://ww3.sinaimg.cn/large/a490147fgw1f3qdwanyr0j208c08ca9z.jpg)](https://i1.wp.com/blog.stylingandroid.com/wp-content/uploads/2015/12/svg_logo4.png?ssl=1)

So there are still issues with importing / converting SVG assets as VectorDrawable but I think it only fair to say that there has been a vast improvement since I last tried. Previously I just got some fairly meaningless errors messages which did not help me to determine where the problem lay. I suspect that for SVG assets which do not rely on local IRI references there will be a much higher success rate than before – so there is a definite improvement!

So now let’s turn our attention to the other part of the tool-chain: Generating PNGs from _VectorDrawable_ assets at build-time. Just to recap: This is now part of the build tools that if you set a minSdkVersion below 21, the PNG assets will automatically be generated from any VectorDrawable assts within your project. When your APK is run on API 21 and later devices it will use your VectorDrawable, but on earlier devices it will use the appropriate PNGs instead. In other words, you only need to add assets as _VectorDrawable_s and the build tools will convert them automagically, if required.

When I tried this previously, I found that `<group></group>` elements within the _VectorDrawable_ files were being ignored and so any translations that were being applied at group level were also being ignored and so the PNGs were not being rendered correctly.

I am extremely happy to report that this issue has now been resolved, and the conversion of my hand-tweaked (to remove the local IRI references) which I used in previously now renders beautifully to a PNG (this is the actual PNG that was produced by a build):

[![](http://ww1.sinaimg.cn/large/a490147fgw1f3qdwqyc6nj208c08caaj.jpg)](https://i0.wp.com/blog.stylingandroid.com/wp-content/uploads/2015/12/svg_logo2.png?ssl=1)

I must say that I was rather disappointed at the time I wrote the previous article about the many issues that I hit and somewhat reluctantly reached the conclusion that the tools were really not ready to use in real projects. However, I think that many of those issues have been resolved and these tools are reaching a point where I would be happy to use them is real projects. There are still some import / conversion issues but that is always going to be the case with a format like SVG which is very open to interpretation – no two SVG authors (be they human or software) will do a particular thing in the same way. But if the tools keep improving at the rate that they have already, then who knows!

