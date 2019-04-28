> * 原文地址：[How do you figure?](https://www.scottohara.me/blog/2019/01/21/how-do-you-figure.html)
> * 原文作者：[scottohara](https://www.scottohara.me)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-do-you-figure.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-do-you-figure.md)
> * 译者：[Hyde Song](https://github.com/HydeSong)
> * 校对者：[xionglong58](https://github.com/xionglong58), [xujiujiu](https://github.com/xujiujiu)

# [译] 你认为“figure”怎么用？

作为 HTML5 新引入的元素，`figure` 和 `figcaption` 元素是为了创建有意义的标记结构：

* 为一段内容提供一个描述性标签，
* 该标签与当前文件相关，但用户对它的理解并不重要。

为了得到更具体的信息，让我们分别来了解一下这些元素。

## `figure` 元素

通常 `figure` 元素被认为用来包裹图或图表，它还可以承载文档主要内容中引用的但不是冗余信息的任何内容(代码片段、引用、音频、视频等)。在文档流中可以把 `figure` 完全删除，而不会影响用户对主要内容的理解。

例如，描述 unladen Swallow 空速的文档，可能有一节描述南非燕子和欧洲燕子之间的差异。伴随文本内容的可能是一个 `figure` 标签，并排展示了这两种鸟类的差异，以补充文档中描述的信息。

![一篇文章的截图，使用与主要内容错开的图像来表示南非燕子和欧洲燕子之间的视觉差异。图片的文字说明左边是南非燕子，右边是欧洲燕子。](https://scottohara.me/assets/img/articles/swallow-figure.jpg)

在这个基本的例子中，`figure` 和 `figcaption` 起到了引用前文内容的作用。如果去掉它们，目前为止所有的文本信息依然起到了 `figure` 的作用。

[图片源（2003）](http://style.org/unladenswallow/)。

使用 `figure` 时可以加上或不加 `figcaption` 标签。但是，不加 `figcaption` 标签，或者不提供其他可访问的属性（比如 `aria-label`），单独使用 `figure` 在表达其语义上价值不大。在某些情况下，如果没有给定可访问的属性，可能表达不出任何语义。

## `figcaption` 元素

`figcaption` 为 `figure` 所含的内容提供标题或摘要。如果在 `figure` 上不使用 `aria-label` 或 `aria-labelledby` 属性，`figcaption` 会成为 `figure` 元素的可访问属性。

`figcaption` 可以放在 `figure` 的主要内容之前或之后，但是它必须是 `figure` 元素的直接子元素。

推荐的用法：

```
<figure>
  <figcaption>...</figcaption>
  <!-- figure 的内容 -->
</figure>

<figure>
  <!-- figure 的内容 -->
  <figcaption>...</figcaption>
</figure>

<figure>
  <figcaption>
    <div>
      ...
    </div>
  </figcaption>
  <!-- figure 的内容 -->
</figure>
```

不推荐的用法：

```
<figure>
  <div>
    <figcaption>...</figcaption>
  </div>
  <!-- figure 的内容 -->
</figure>

<figure>
  <!-- figure 的内容 -->
  <div>
    <figcaption>...</figcaption>
  </div>
</figure>
```

`figcaption` 可能包含 [流式内容](https://html.spec.whatwg.org/multipage/dom.html#flow-content-2)，它将 `body` 元素的大多数子元素进行分类。但是，由于 `figcaption` 元素的作用是为 `figure` 的内容提供标题，所以通常更倾向于使用简洁的描述性文本。`figcaption` 不应该重复 `figure` 的内容，或者重复主文档中的其他内容。

### `figcaption` 不能代替 `alt` 文本

对于 `figure` 中使用的图像，使用 `figcaption` 时最大的误解之一是它用于替代图像 `alt` 文本。[HTML 5.2](https://www.w3.org/TR/html52/semantics-embedded-content.html#when-a-text-alternative-is-not-available-at-the-time-of-publication) 中规定，这种做法是只有当作者没有为图片提供适当的 `alt` 文本时，力求传递有意义信息的最后的“杀手锏”。

一段来自 HTML 5.2 的说明：

> 这种情况应保持在绝对最低限度。如果作者有能力提供真正的替代文本，那么省略 `alt` 属性是不可接受的。

`figcaption` 是用来为 `figure` 提供标题和摘要的，将其与包含 `figure` 的文档关联起来，或者传递附加的信息，这些信息可能在查看 `figure` 本身时并不明显。

如果给一张图片一个空的 `alt`，那么 `figcaption` 实际上什么也没有描述。这说不通，对吧？

换句话说，让我们看看一个包含 Sass 代码片段的 `figure`：

```
<figure>
  <pre><code>
    $align-list: center, left, right;

    @each $align in $align-list {
      .txt-#{$align} {
        text-align: $align;
      }
    }
  </code></pre>
  <figcaption>
    使用 Sass 的 @each 循环控制指令编译成
    三个 CSS class；.txt-center，.txt-left，和 .txt-right。
  </figcaption>
</figure>
```

与 `figure` 中 `alt` 为空的图像相比，这就像在代码段中放入 `aria-hidden="true"`。这样做将使屏幕阅读器和其他辅助技术无法解析标题引用的内容。然而，不幸的是，这反映了 `figure` 中图片通常发生的情况。

你可能会认为，“很明显，标题的作用应该跟图片的 `alt` 文本一样，不是吗？”。这个假设有两个问题：

**首先**，什么是图片？当图片的 `alt` 为空时，屏幕阅读器不会显示出这张图片，也不会被发现。如果图片中没有 `alt` 键，**某些**屏幕阅读器会显示图像的文件名，但不是所有的屏幕阅读器都会这样（比如 JAWS，有调整这些行为的设置。但默认忽略这些图像）。

**其次**，`alt` 属性传达图片呈现的重要信息。`figcaption` 应该提供上下文，以便将 `figure`（图片）与主文档关联起来，或者显示需要注意的特定信息。如果 `figcaption` 代替了 `alt`，那么这就为无视力障碍的用户创建了重复的信息。

误用 `figcaption` 代替图像 `alt` 还有其他问题。但要发现这些问题，我们需要了解屏幕阅读器如何解析 `figure`。

## `figure` 元素和屏幕阅读器

既然我们已经知道了应该如何使用 `figure` 及其标题，那么这些元素在屏幕阅读器上是如何表现的呢?

理想情况下，`figure` 应该声明 role 属性和 `figcaption` 的内容作为可访问属性。然后，用户应该能够找到 `figure` ，并独立地与 `figure` 和 `figcaption` 的内容进行交互。对于不完全支持 `figure` 的浏览器，像 Internet Explorer 11, [ARIA 的 `role="figure"` 属性](https://www.w3.org/TR/wai-aria-1.1/#figure) 和 `aria-label` 属性可用于帮助提高某些屏幕阅读器识别标签的可能性。

以下是测试过的屏幕阅读器在默认设置下如何在不同的浏览器中显示（或不显示）这些信息的摘要：

### JAWS 18 的 2018 和 2019 版本

JAWS 对原生 figure 和 标题有最好的支持，尽管根据浏览器和 JAWS 的详细设置，支持并不完美和一致。

IE11 需要使用 `role="figure"`、`aria-label` 或 `aria-labelledby` 指向 `figcaption` 来模拟原生元素的属性。IE11 不支持原生元素并不奇怪，因为 [HTML5 可访问性的 IE11 浏览器评级](https://www.html5accessibility.com/)永远不会改进。但至少 ARIA 可以提供语义。

无论是否使用 ARIA，Edge 都不会声明 figure 的 role 属性。一旦 [Edge 浏览器切换到 Chromium 内核](https://www.windowscentral.com/faq-edge-chromium)，这种情况可能会改变。

Chrome 和 Firefox 提供了类似的支持，但是如果一个图片有一个空的 `alt` 或缺少 `alt` 属性，JAWS（默认的详细设置）Chrome 会**完全忽略** `figure`（包括它的 `figcaption` 的内容）。

这意味着 [在各种 Medium 文章中](https://twitter.com/aardrian/status/923536098734891009) 那些伴随图片的标题，都被与 Chrome 配合使用的 JAWS 完全忽略了。如果 JAWS 的设置更新能声明所有图像（例如没有提供 `alt` 属性或值的图片），那么 JAWS 使用 Chrome 声明这些 figure 标题。

不像 Chrome，在 JAWS 上使用 Firefox，图片的 `alt` 为空或缺失，`figure` 和 `figcaption` **仍然会被识别**。但是由于图片将被完全忽略，使用屏幕阅读器的人不得不推断 figure 的主要内容是不是图片。

### NVDA 屏幕阅读器

在使用 IE11、Edge、Firefox 64.0.2 和 Chrome 71 测试 NVDA 2018.4.1 版本时，没有发现任何 figure。最接近的迹象是 NVDA + IE11 在声明图片或 `figcaption` 内容之前声明 “edit”（不过 “edit” 没有任何意义...）。测试 `role="figure"` 模式并没有改变缺少声明的情况。figure 的内容仍然可以访问，但是不会表现内容和标题之间的关系。

### VoiceOver（macOS）

测试在 macOS 10.14.2 上使用 Safari（12.0.2）和 Chrome（71.0.3578.98）进行，并使用了 VoiceOver 9。

#### Safari

当使用 Safari 进行测试时，`figure` 将会显示出它的 role 属性。如果没有语义化的属性（例如没有 `figcaption`, `aria-label` 等），则不会显示出 `figure` 的 role 属性。

VoiceOver 可以导航到 `figure`，并单独与 `figure` 和 `figcaption` 的主要内容进行交互。

#### Chrome

尽管 Chrome 的可访问性检查器指出 `figure` 的语义正在被揭示，可访问属性由标题提供，但 VoiceOver 并不像 Safari 那样定位或声明 `figure` 的存在。除非 `figure` 特别有一个 `aria-label ` 属性。使用 `figure` 上的 `aria-labelledby` 或 `aria-labelledby` 指向 `figcaption`，`figure` **不会**被 VoiceOver 识别 。为了正确地向 VoiceOver 传达 figure，使用 Chrome 时需要以下标记：

```
<!-- 
  aria-label 需要重复 figcaption 的内容，按预期声明 figure。
-->
<figure aria-label="Figcaption 内容放这儿。">
  <!-- figure 内容 -->
  <figcaption>
    Figcaption 内容放这儿。
  </figcaption>
</figure>
```

在 `figure` 元素上加一个 `role="figure"` 属性，或者用其他元素替代 `<figure>`，仍然需要添加 `aria-label` 来让 VoiceOver 使用 Chrome 时识别 role 属性。

### VoiceOver（iOS 12.1.2）

在用 VoiceOver 测试 Safari 和 Chrome 时，没有显示出 `figure`，也没有显示出 `figure` 的内容和标题之间的关系。`<figure>` 和 `role="figure"` 模式都产生了相同的结果。

### TalkBack（Android 8.1 上的 7.2 版）

在测试 Chrome（70）和 Firefox（63.0.2）时，没有显示出任何 `figure`，也没有显示出 `figure` 内容与其标题之间的关系。`<figure>` 和 `role="figure"` 模式都产生了相同的结果。

### Narrator & Edge 42 / EdgeHTML 17

Narrator 根本没有显示出 `figure` 的 role。但是，原生元素和 `role="figure"` 确实对 `figure` 的内容的声明方式有影响。当 `figure` 具有语义化属性时，`figure` 的内容（例如图像的 `alt` 文本）和 `figure` 的语义化属性（`figcaption` 内容或 `aria-label`）将同时显示。如果图片的 `alt` 值为空，则会完全忽略 `figure` 及其 `figcaption`。

## 总结

根据 `figure` 及其标题的预期用例，以及目前屏幕阅读器对这些元素的支持，如果你想确保语义传达给尽可能多的受众，应该考虑以下标记模式：

```
<figure role="figure" aria-label="repeat figcaption content here">
  <!-- figure content. if an image, provide alt text -->
  <figcaption>
    figure 的标题。
  </figcaption>
</figure>

<!--
  使用 aria-label 兼容 macOS VoiceOver 和 Chrome
  使用 role="figure" 兼容 IE11。

  IE11 需要一个可访问的属性（由 aria-label 提供）。
  如果不是因为 VO + Chrome 不支持
  可访问的属性：aria-labelledby，该属性
  会被优先/指向 <figcaption> 的 ID。
-->
```

此模式将确保下面的搭配显示 `figure` 的 role 属性及其标题：

* JAWS 配备 Chrome、Firefox 和 IE11。
* macOS VoiceOver 配备 Safari 和 Chrome。
* Edge 和 Narrator 将创建一个关系，但不会声明 `figure` 的 role 属性。

目前，移动屏幕阅读器不会显示 `figure`，Edge 浏览器也不会，除非与 Narrator（类似）配对使用，或任何浏览器与 NVDA 配对使用。但不要让这些差距阻碍你按照规范的预期使用元素。

随着 Edge 转为 Chromium内核，更好的支持在不久的将来可能成为现实。虽然 NVDA 和移动屏幕阅读器没有声明语义，但内容仍然是可访问的。[把 bug 记录下来](https://github.com/nvaccess/nvda/issues/9177) 是我们目前能为这些漏洞带来改变做的最好的事情。

感谢大家点击 [Steve Faulkner](https://twitter.com/stevefaulkner) 来评审我的测试并阅读本篇文章。

### 拓展阅读

下面是更多关于 `figure` 的和 `figcaption` 的资源和上文使用的测试页面/结果，以及 JAWS 和 NVDA 归档的 bug：

*   [HTML Accessibility API Mappings 1.0: `figure` and `figcaption` elements](https://w3c.github.io/html-aam/#figure-and-figcaption-elements), W3C
*   [HTML5 Accessibility](https://www.html5accessibility.com/)
*   [HTML5 Doctor: `figure` and `figcaption`](http://html5doctor.com/the-figure-figcaption-elements/), (2010)
*   [HTML5 Accessibility Chops: the figure and figcaption elements](https://developer.paciellogroup.com/blog/2011/08/html5-accessibility-chops-the-figure-and-figcaption-elements/), Steve Faulkner (2011)
*   [ARIA 1.1: `figure` role](https://www.w3.org/TR/wai-aria-1.1/#figure)
*   [`figure` and `figcaption` test page](https://scottaohara.github.io/testing/figure/)
*   [JAWS + Chrome bug filed](https://github.com/FreedomScientific/VFO-standards-support/issues/161)
*   [NVDA bug to support `figure`s](https://github.com/nvaccess/nvda/issues/9177)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
