
> * 原文地址：[Better Form Design: One Thing Per Page (Case Study)](https://www.smashingmagazine.com/2017/05/better-form-design-one-thing-per-page/)
> * 原文作者：[Adam Silver](https://www.smashingmagazine.com/author/adamsilver/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译文地址：[github.com/xitu/gold-miner/blob/master/TODO/better-form-design-one-thing-per-page.md](https://github.com/xitu/gold-miner/blob/master/TODO/better-form-design-one-thing-per-page.md)
> * 译者：[horizon13th](https://github.com/horizon13th)
> * 校对者：[LeviDing](https://github.com/leviding), [laiyun90](https://github.com/laiyun90)

# 更好的表单设计: 每一页，一件事（实例研究）

2008 年，我在 Boots.com 工作时，团队提出需求，要设计当时最流行的单页表单进行付款操作，主要技术有折叠选项卡，AJAX，客户端验证。

表单提交的每一步（快递地址，快递方式，付款方式）都是一个折叠模块。每一个模块通过 AJAX 提交，提交成功后当前模块折叠，下一步所在的折叠模块滑动展开。

如下图所示：

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/04/boots1-780w-opt-1.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/04/boots1-large-opt-1.png)

Boots 网站的单页付款图，每一步都是一个折叠模块。([View large version](https://www.smashingmagazine.com/wp-content/uploads/2017/04/boots1-large-opt-1.png)）

用户在提交订单时备受折磨，因为一旦填错内容就很难修改，用户需要上下来来回回滑动屏幕。折叠面板的设计简直太让人不爽了。果不其然，客户提出需求让我们修改。

我们重新设计了页面，将原来的每个折叠模块变成了独立的页面，删掉了折叠面板效果，也不再使用 AJAX，唯独保留了客户端验证，以省去不必要的服务器请求。

更改后的设计如下：

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/04/boots2-780w-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/04/boots2-large-opt.png)

Boots 网站的多页付款图，每一步都是一个单独页面。([View large version](https://www.smashingmagazine.com/wp-content/uploads/2017/04/boots2-large-opt.png)）

这一版本变得好多了。我记不清确切的支持数据，但我记得客户当时很满意。

六年过去了（2014），当我就职于 Just Eat，同样的事情在不同地点又发生了一次。我们又重新设计了单页提交订单页面，将单页的多个模块修改成独立的页面。这次，我记录下了数据。

结果显示，**每年新增订单数量有两百万**。这里要强调一下，这个数字仅仅是订单量，还不是利润。该数据是版本更新一周内的订单统计结果，由付款时订单增加的百分比而得来。我们这个百分比转化成了订单数量，再乘以52周。

下图是一些移动端设计：

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/04/justeat-780w-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/04/justeat-large-opt.png)

Just Eat 的付款被分成了多个页面。我们还提出了一个设计方案使付款更简便：用户可以选择“现金付款”或者“银行卡付款”，然后跳转到相关页面去填写信息。很遗憾，我们从未对此进行测试。([View large version](https://www.smashingmagazine.com/wp-content/uploads/2017/04/justeat-large-opt.png)）

几年过去了（2016），GDS 公司的 Robin Whittleton 告诉我说，把每一件事情放在属于自己一个页面里，这本身是一个设计模式，被称为“每一页，一件事”英文为“One Thing Per Page”。除了数据支持，这个设计模式背后还有可靠的理论依据，我们马上会讲到。

不过在这之前，我们先来看看这个设计模式到底是什么样的。

### “每一页，一件事”到底意味着什么？

“每一页，一件事”，指的并不是在一个页面上只摆放一个元素或者组件（当然了，这样也可以）。不过至少，你也得给加个页眉页脚吧。

同理，它也不是在单页上放置单个表格字段。（尽管，你非要这样做也不是不行）

这种模式是将复杂繁琐的步骤分割成很多个更小的部分，将这些更小的部分格子分布在只属于它们自己的屏幕。

例如，在设计快递地址表单时，我们将这个功能单独放置一页，而不是将它和快递方式，付款方式几个功能挤在同一个页面。

一个快递地址表单有多个字段（城市，街道，邮政编码等），然而终究这些字段共同回答了同一个具体问题。因而在同一页面上解决这个问题是合理的。

下面让我们考虑一下，这种模式究竟为什么这么好。

### 为什么这种模式这么好嘞？

这个模式往往产出奇妙美味的果子（其实是订单啦，原谅我的比喻）能够理解其背后的运作原理，那就好办啦。

#### 1. 减少认知负荷

正如 Ryan Holiday 在 *The Obstacle Is The Way* （最近在美国很火的鸡汤畅销书－－译者注）里所说的那样：

> 还记得你第一次见到复杂的代数方程么？有那么一大堆混淆的符号和未知数。但是当你静下心分解方程式，最终得到的，那就是答案。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/04/algebra-780w-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/04/algebra-large-opt.png)

解决方程式的简单办法就是，分步骤分解等式。([View large version](https://www.smashingmagazine.com/wp-content/uploads/2017/04/algebra-large-opt.png)）

同样的道理可以应用到用户试图填好一份表单，或者任何其它事情。如果屏幕上内容较少，且用户只需做出一种选择，阻力将降到最小。因而用户就会专注停留在任务本身。

#### 2. 简化错误处理

当用户填写一个较小的表格时，一旦犯错能够早发现早处理。如果只有一件事，修复错误会变得很容易，这降低了用户放弃填写表格的几率。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/04/errors-780w-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/04/errors-large-opt.png)

即使有好几个错误发生，Kidly 的地址表单修改起来仍很简便。([View large version](https://www.smashingmagazine.com/wp-content/uploads/2017/04/errors-large-opt.png)）

#### 3. 加快页面加载

当页面设计上遵从“小”的原则，页面加载速度会更快。快速加载的页面降低了用户等不及而离开的风险，在服务上得到了用户的信任。

#### 4. 简化行为追踪

页面内容越多，越难分析用户为什么会离开页面。这里要弄清楚：用户行为分析并不应该作为页面设计的主导，但它作为副产品还是不错的。

#### 5. 简化进度查看和返回上一步操作

如果用户频繁提交信息，我们可以将信息以更细化的方式保存起来。比如当有用户在中途放弃订单，我们可以发邮件以推动他们完成订单。

#### 6. 减少滑动操作

不要搞错了噢，[滑动操作也没什么大不了](http://uxmyths.com/post/654047943/myth-people-dont-scroll)  —— 用户期望网页以滑动的方式运作。但是一旦页面变小了，用户不必再滑动屏幕。而且推广召集活动一般都在折叠面板最顶端，强化了需求，也简化了操作流程。

#### 7. 分支操作更便捷

有时候我们我们会根据用户上一步的操作而决定下一步进入不同的分支操作。举个简单的例子，假设我们有两个下拉选择菜单。用户在第二个菜单看到的选项取决于他在第一个菜单的选择。

每一页只做一件事使其更简单：当用户在第一个下拉菜单选好并点击提交，服务器响应并返回给用户第二个菜单的内容，简单易行。

我们可以使用 JavaScript，但其实构建界面，并保证用户界面可以访问比想象的要复杂。倘若 [JavaScript 出错](https://kryogenix.org/code/browser/everyonehasjs.html)，用户可能会有很不好的用户体验。而且加载页面所有可能的选项也是一笔重量级开销。

我们可以使用 AJAX 代替，但这其实并没有把我们从渲染新页面（模块）中解放出来。更严峻的是，AJAX 也没有减少服务器端的传输开销。

这还不是全部，我们需要发送更多的代码以发送 AJAX 请求，处理错误并显示加载指示器。再强调一下，这些都会使网页加载得更缓慢。

自定义加载进度条也很棘手，和浏览器原生实现的进度条不同，它往往是不准确的。而且每个网站都有自己特定的展现方式，用户对它们并不熟悉。然而，用户的熟悉程度是一个用户体验的公约，在非必需的情况下我们最好不要破坏它。

另外，在单一页面上动态更新两个甚至多个字段，这需要用户**按先后顺序**交互。虽然我们能控制显示隐藏输入框，但这还是过于复杂。

最后，用户可能会更改他所填写的内容。内容更改可能需要后续面板隐藏，或者后续面板内容也更改。这些也很令人困惑。

#### 8. 阅读模式友好

如果页面上内容少，阅读模式下用户不必再迷失于大量的无关信息。用户可以迅速定位标题以与表单更快速地交互。

#### 9. 简化细节修正

想象下某个用户正在确定订单，突然他在付款信息看到一个严重的错误。返回到上一页远比返回一页中的某一部分简单得多。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/04/kidly-780w-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/04/kidly-large-opt.png)

点击“编辑”按钮把用户带回到付款方式页面，页面上有专有标题和相关表单字段。 ([View large version](https://www.smashingmagazine.com/wp-content/uploads/2017/04/kidly-large-opt.png)）

浏览页面中途有其他内容，这是很迷惑的事情。记住噢，点击链接去完成某些操作，这种在页面上做其他事情的交互将会让用户分心。

而且这里面有很多潜在工作。比如说，如果你想在同一个页面上显示隐藏模块，需要额外逻辑来处理。

每一页只做一件事的话，这些问题就会烟消云散啦。

#### 10. 用户可以控制其数据授权

用户不可能只让浏览器加载一半页面，要么全部，要么什么都没有。如果用户想要更多的信息，它可以点击链接，拥有**选择**的权利。只要每一步能让他们更接近目标，[用户一点都不介意多点一下鼠标](http://uxmyths.com/post/654026581/myth-all-pages-should-be-accessible-in-3-clicks)。

#### 11. 解决性能问题

如果所有内容融合成一个庞大的怪物 —— 最极端的的例子就是单页应用 —— 那性能问题是很难解决的。到底是运行时间问题呢？还是内存泄漏？或者 AJAX 调用？

我们很容易想到 AJAX 改善了用户体验，但是代码量的增加应该不会加快用户感受吧。

客户端的复杂性掩盖了服务器端的根本问题。如果一页只做一件事，性能出问题的可能性很小。一旦有了问题，也很容易查找出来。

#### 12. 增加用户感知进度

由于用户不断的移动到下一步，这种进展感给用户积极的感觉，好像在填写表格一样。

#### 13. 减少信息丢失风险

一个长表格需要更多填写的时间。如果花费时间太久，页面可能超时导致信息丢失，给用户带来巨大的挫败感。

又或者，电脑死机，像 *我是 Daniel Blake* 的主角 Daniel 遇到的情况那样。他健康状况日益恶化，从没有使用过电脑，经常遭受电脑死机数据丢失的痛苦，最后只得放弃。

#### 14. 提升老用户体验

如果我们能保存用户的快递地址和付款信息，可以跳过这些页面，引导客户直接到“检查无误确认提交”的页面。这减少了用户阻力，增加用户转化。

#### 15. 补充移动优先设计

移动优先设计激励我们设计出小屏幕中至关重要的元素。一页只做一件事就遵循了这样的方法。

#### 16. 设计流程更简单

当我们设计一个复杂的工作流时，将其分解成原子性的单个页面多个模块，有助于问题的理解。

切换屏幕改变顺序很容易，分析问题的范围也变得容易，正如用户一次只做一件事情那样简单。

这种用户受益模式的很好的副产品，这样还减少了设计精力。

### 这种模式适合所有情景么？

并不是。Caroline Jarrett 在 2015 年第一次写过一篇同样标题的文章[每一页，一件事](https://designnotes.blog.gov.uk/2015/07/03/one-thing-per-page/)。她讲到用户研究会很快显示“一些问题最好归类在一起在长页面中显示”。

然而，相反的是，她也解释说自然地“走到一起”的问题们往往是从设计师的角度来看的，从用户角度来看，这些问题并不需要放在一起。

她举了一个启发性的例子。当为 GOV.UK 做认证时，他们测试将“创建用户名”放在一页，而将“创建密码”放在下一页。

像大多数设计师一样，Caroline 认为将上述两个表单字段放在单独页面上是矫枉过正的。但现实是，用户并没有对此感到太困扰。

关键在于，至少开始于“每一页，一件事”，随着用户研究，找出适合的字段来进行合并分组以优化用户体验。

这并不意味着，最终你总会以把所有页面都合并在一起。在我经验看来，最好的结果往往是将事情拆分。当然了，如果你有更好的经验，我也愿意倾听。

### 总结

这种低调不起眼的 UX 模式也可以设计地具备灵活性，高性能，包容性。它迎合网络大众，使得所有用户群体都能从容应对。

在同一页面上摆放太多内容（甚至全部内容）可能会带来简洁的错觉。但就像代数方程那样，复杂的代数方程如果不分解开来，实际上更难解答。

如果我们把一项任务看作是用户想要完成的交易，将这个流程分步骤处理是很合理的。就好像我们使用网络传输的形式作为逐渐展现页面的形式，这种“One Thing Per Page”背后的隐喻给用户提供了潜意识里的前进感。

至今我还未见到过比“每一页，一件事”更好的设计模式。这就是这个时代：简单，就是这么简单。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
