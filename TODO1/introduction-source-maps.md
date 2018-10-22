> * 原文地址：[An Introduction to Source Maps](https://blog.teamtreehouse.com/introduction-source-maps)
> * 原文作者：[Matt West](https://blog.teamtreehouse.com/author/mattwest)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/introduction-source-maps.md](https://github.com/xitu/gold-miner/blob/master/TODO1/introduction-source-maps.md)
> * 译者：[EmilyQiRabbit](https://github.com/EmilyQiRabbit)
> * 校对者：[calpa](https://github.com/calpa)，[Raoul1996](https://github.com/Raoul1996)

# 源代码映射（Source Map）简介

![](https://3wga6448744j404mpt11pbx4-wpengine.netdna-ssl.com/wp-content/uploads/2013/10/programming1.png)

合并与压缩 JavaScript 和 CSS 的代码，是能为你的网站提升性能的最简单的举措之一。但是如果想要调试这些压缩过的文件，又会怎么样呢？那简直是噩梦了。但是别怕，眼前就有一个解决办法，它就是源代码映射。

源代码映射提供了一个映射，将压缩后的文件和原始文件联系起来。这就意味着 —— 借助一点软件的帮助 —— 就算是资源被压缩过，你也能很轻松的调试应用。Chrome 和 Firefox 开发者工具都内建支持源代码映射。

在这篇博客文章中，你将会学习到源代码映射是如何工作的，并且了解它们是怎么生成的。我们将主要关注 JavaScript 代码的源代码映射，但这些原则也适用于 CSS 源代码映射。

* * *

**注**：在 Firefox 的开发者工具里，源代码映射是默认开启的。而 Chrome 则需要手动的开启支持（自 Chrome 39 开始 Source Maps 也已经默认处于启用状态，译者注）。开启的方法是，启动 Chrome 的开发工具然后打开 **Settings** 面板（右下角的小齿轮）。在 **General** 标签中确保 **Enable JS source maps** 和 **Enable CSS source maps** 都被勾选了。

* * *

## 源代码映射是如何工作的

顾名思义，源代码映射包含了将压缩后文件代码映射回源代码的所有信息。你可以为每个压缩文件指定不同的源映射。

通过向被优化文件的底部添加一个特殊注释，你可向浏览器指示源代码映射可用。

```
//# sourceMappingURL=/path/to/script.js.map
```

此注释通常由生成源代码映射的程序添加。只有在启用了对源代码映射的支持并打开开发工具时，开发者工具才会加载此文件。

通过响应对压缩的 JavaScript 文件请求的时带 X-SourceMap HTTP 首部的方式，你同样可以声明源代码映射可用。

```
X-SourceMap: /path/to/script.js.map
```

源代码映射文件包含一个 JSON 对象，里面有映射本身和源 JavaScript 文件的信息。这是一个简单的例子：

```
{
    version: 3,
    file: "script.js.map",
    sources: [
        "app.js",
        "content.js",
        "widget.js"
    ],
    sourceRoot: "/",
    names: ["slideUp", "slideDown", "save"],
    mappings: "AAA0B,kBAAhBA,QAAOC,SACjBD,OAAOC,OAAO..."
}
```

我们来仔细研究一下这些属性。

*   `version` – 此属性指示文件所遵循的[源映射规范](https://docs.google.com/document/d/1U1RGAehQwRypUTovF1KRlpiOFze0b-_2gc6fAH0KY0k/edit)的版本。
*   `file` – 源代码映射文件的名称。
*   `sources` – 一个由源文件的 URL 组成的数组。
*   `sourceRoot` – （可选参数）所有 `sources` 包含的 URL 被解析的路径。
*   `names` – 一个包含所有源文件变量和函数名的数组。
*   `mappings` – 一个 [Base64 VLQs](http://www.html5rocks.com/en/tutorials/developertools/sourcemaps/#toc-base64vlq) 的字符串，包含了实际的代码映射。（这就是魔法发生的地方）

## 使用 UglifyJS 生成源文件映射

[UglifyJS](https://github.com/mishoo/UglifyJS2) 是一个很流行的命令行工具，它可以帮助你合并和压缩 JavaScript 文件。版本 2 提供了很多命令行参数，帮助生成源文件映射。

*   `--source-map` – 源文件映射的输出文件。
*   `--source-map-root` – （可选参数）它将填充映射文件中的 `Sourceroot` 属性。
*   `--source-map-url` – （可选参数）服务器中源文件映射的路径。它将会被放置在被优化文件中的注释使用。`//# sourceMappingURL=/path/to/script.js.map`
*   `--in-source-map` – （可选参数）输入源代码映射。当你正在压缩那些已经在别处生成过源代码映射的 JavaScript 文件的时候，这个参数就很有用了。比如 JavaScript 库。
*   `--prefix` 或 `-p` – （可选参数）从 `sources` 属性的文件路径中，移除 `n` 个目录。例如，`-p 3` 将会从文件路径中移除前三个目录，那么 `one/two/three/file.js` 就会成为 `file.js`。使用 `-p relative` 将会让 UgulifyJS 为您计算源文件映射和原始文件之间的相对路径。

这是一个命令的例子，它使用了一些上述的命令行参数。

```
uglifyjs [input files] -o script.min.js --source-map script.js.map --source-map-root http://example.com/js -c -m
```

* * *

**注意**：如果你为 Grunt 使用了 `grunt-contrib-uglify` 插件，请参考关于如何在 Gruntfile 文件中配置这些选项的[文档信息](https://github.com/gruntjs/grunt-contrib-uglify#sourcemap)

* * *

还有很多其他可用的工具支持生成源文件映射，一些可选项在下文列出：


*   [Closure](http://www.html5rocks.com/en/tutorials/developertools/sourcemaps/#toc-howgenerate)
*   [CoffeeScript Compiler](http://coffeescript.org/#source-maps)
*   [GruntJS Task for JSMin](https://github.com/twolfson/grunt-jsmin-sourcemap)

## Chrome 开发工具中的源文件映射

[![The Sources Tab in Chrome Dev Tools](https://3wga6448744j404mpt11pbx4-wpengine.netdna-ssl.com/wp-content/uploads/2013/12/chrome-tools.png)](https://3wga6448744j404mpt11pbx4-wpengine.netdna-ssl.com/wp-content/uploads/2013/12/chrome-tools.png)

Chrome 开发工具中的 Sources 标签

如果你已经正确的设置好了源文件映射，那么你将会看到所有的原始 JavaScript 文件在 **Sources** 标签的面板中被列出。

检查页面的 HTML，你将能够确认它其实只引用了压缩的 JavaScript 文件。开发工具将为您加载源文件映射文件，然后获取每个原始文件。

[试试这个例子](http://demos.mattwest.io/source-maps/)

## Firefox 开发者工具中的源文件映射

[![The Debugger Tab in the Firefox Developer Tools](https://3wga6448744j404mpt11pbx4-wpengine.netdna-ssl.com/wp-content/uploads/2013/12/firefox-tools.png)](https://3wga6448744j404mpt11pbx4-wpengine.netdna-ssl.com/wp-content/uploads/2013/12/firefox-tools.png)

Firefox 开发者工具中的 Debugger 标签

Firefox 用户可以在开发者工具的 **Debugger** 标签看到独立的源文件。同样，开发工具已经确定源映射是可用的之后，才获取每个引用的源文件。

如果希望查看压缩版本，请单击选项卡右上角的齿轮图标，并取消选择 **Show original sources**。


[试试这个例子](http://demos.mattwest.io/source-maps/)

## 最后总结

使用源代码映射可以让开发人员维护一个可以直接调试的环境，同时也可以优化网站的性能。

在这篇文章中，您学习了源代码映射是如何工作的，并了解了如何使用 UgulifyJS 生成它们。如果你曾经用压缩过的文件（你应该这么做）发布网站，那么花点时间把源文件映射创建集成到你的工作流程中是非常值得的。

## 一些有价值的链接

*   [Source Maps Revision 3 Proposal](https://docs.google.com/document/d/1U1RGAehQwRypUTovF1KRlpiOFze0b-_2gc6fAH0KY0k/edit)
*   [UglifyJS](https://github.com/mishoo/UglifyJS2)
*   [Source Maps Demo](http://demos.mattwest.io/source-maps/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
