> * 原文地址：[Best Practices for Search Results](https://uxplanet.org/best-practices-for-search-results-1bbed9d7a311#.8pysknjlm)
> * 原文作者：[Nick Babich](https://uxplanet.org/@101?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[sunui](http://suncafe.cc)
> * 校对者：[iloveivyxuan](https://github.com/iloveivyxuan)、[Graning](https://github.com/Graning)

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*HgoOq5VKfmNfswUF8GM7pg.jpeg">

# 搜索结果页的最佳实践 #

搜索就像是用户和系统之间的一次对话：用户用一次查询来表达他们需要的信息，而系统用一组结果做为回应。搜索结果页恰恰是整个搜索体验中的一个关键部分：它提供了让用户参与对话的机会，来指导用户的信息需求。

这篇文章中，我愿意分享 10 个最佳实践，来帮助你提升搜索结果页的用户体验。

### 1. 点击搜索按钮后，不要清除用户的查询内容 ###

**保留用户输入的原始文字。** 再次查询是信息检索中关键的一步。如果用户没有找到他们想要的信息，他们可能会把一部分查询内容改为更清晰的关键词再搜索一遍。为了方便用户进行查询，在搜索框中留下初始的关键词，让用户不至于重复输入。

### 2. 提供准确而且相关的搜索结果 ###

**搜索结果的第一页是黄金位置。** 搜索结果页是一次搜索体验最核心的地方，它可以提升一个网站的转化率也可以毁掉它。通常用户可以基于一两组搜索结果就可以快速判断一个网站是否存在价值。

将准确的结果返回给用户显然非常重要，否则他们将不再相信这个搜索工具。所以你的搜索工具必须以合理的方式确定结果的优先级，并把所有重要的结果放置在第一页。

### 3. 使用有效的自动提示 ###

**无效的自动提示会让搜索体验大打折扣。** 请确保自动提示是有效的。当用户输入文字时，像识别词根、预测文本、搜索建议都是一些对用户很有帮助的功能。这些做法有助于加快搜索进度，并让用户在跳转间依旧保持工作状态。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*AQFWWqXrznprydFeOL-axg.png">

图片来源: ThinkWithGoogle

### 4. 纠正拼写错误 ###

**打字本来就很容易出错。** 如果用户错误的输入了搜索关键词，而你可以检测到这个错误，那么可以针对系统猜测或“更正”后的关键词来显示搜索结果。这样就避免了由于没有返回结果，用户不得不再次输入关键词的尴尬。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*U3xATz5_lkAgYsjJXNlH7g.png">

不支持搜索重组的苹果商店上没有搜索到结果页面。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*i0oGvymAq0dl7rhLjdLvug.png">

Asos 网站在用户打字错误时，很好地显示了一组代替结果来避免激怒用户。它会这样提示用户：“您的初始搜索为 ‘Overcoatt’，我们也为您搜索了‘Overcoats’的相关结果”

### 5. 显示搜索结果的数量 ###

显示相关搜索结果的数量，让与用户能够知道他们大概会花费多长时间来浏览这些搜索结果。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*WC83Jp1xpJtLdMbuc5hhiQ.png">

相关结果数量能够让用户更清楚如何进行再次搜索。

### 6. 保留用户最近的搜索记录 ###

即使用户很熟悉搜索引擎的功能，搜索这件事仍然需要用户从他们的记忆里唤起信息。为了想出一个有意义的关键词，用户需要考虑到他要查找的目标所具有的相关属性，并将它们融合到查询条件中。设计搜索体验时，你应该时刻记住基本的可用性原则：

> 尊重用户的努力

你的网站应该 **保存所有最近的站内搜索记录**, 当用户下一次创建搜索的时候把这些记录提供给他们.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*F5VdrzysdFsaIBLQqxJvdw.png">

保存最近搜索记录的好处是用户再次搜索同样的内容时可以节约他们的时间和精力。

**提示:** 提供的条目不要超过 10 个 (并且不要有滚动条) 这样不会让用户觉得信息过载。

### 7. 选择合适的页面布局 ###

显示搜索结果的一个挑战是不同的页面内容需要不同的布局来支撑。内容展现最基本的两种布局分别是列表视图和网格视图。一个经验法则：

> 列表用于详情展示，网格用于图片展示

不妨一起在产品页面中验证一下这个法则。这时产品的细节特征在就显得尤为重要了。对于类似家用电器这样的产品，诸如型号、评级和尺寸等 **细节** 是用户在 **选择购买过程中** 关注的重要因素，因此列表视图更有意义。

![](https://cdn-images-1.medium.com/max/800/1*K7ITLIzXP57remQneOi9nw.png)

列表布局更适合细节导向的布局

对于一些 **需要更少的产品细节信息** 的产品，**网格视图** 是一个更好的选择。比如服装这样的产品，用户在挑选产品的过程中对文字描述信息不会太关心，而是依赖于 **产品外观** 做决定。对于这类产品用户更关心产品间的视觉差异，并且更愿意在一个长页面上来回滚动挑选，而不是在一个列表页和产品详情页面里反复切换。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*HplfdblSUuoURLFBCEWDfg.png">

网格布局更适合视觉导向的布局

**提示:**

- 允许用户为搜索结果选择“列表视图”或“网格视图”，让用户选择他们自己更期望的方式来浏览他们的查询结果。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*ebjnL_m2ojhNM9duJac9qg.png">

允许用户通过一个功能菜单来更改布局

- 设计网格布局的时候，选择一个合适的图片尺寸，既要足够大到清晰识别细节，又要足够小到让用户一次尽量看到更多的条目。

### 8. 显示搜索进度 ###

理想状况下，搜索结果应该 **立即** 显示，但如果做不到，应该使用进度条来为用户提供系统的反馈。你应该给你的用户一个清晰的指示，让他们知道还要等待多久。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*SXF1nALfezQeQyYOSu1l-A.gif">

Aviasales 网站提示用户 **搜索需要一些时间**

**提示:** 如果搜索过于耗时，你可以使用动画. 好的动画能够分散访客的注意力，让他们忽略漫长的等待。

### 9. 提供排序和筛选的选项 ###

用户搜索返回的结果和关键词相关度较低或者结果太多的时候，他们往往感觉很迷茫。你应该提供给用户一些与其搜索相关的筛选选项，并且在他们应用筛选选项的时候要支持多选。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*sKSFUtpTpH1KH6rKtJrDYQ.png">

筛选选项可以帮助用户减少搜索结果并对其排序，不然会需要大量的（过多的）滚动和分页。

**提示:**

- 不要给用户过多的筛选选项这一点很重要。如果你的搜索需要大量的筛选，应该为它们设定默认值。
- 不要在筛选功能中隐藏排序功能，它们是不一样的。
- 当用户限制了搜索范围，在搜索结果页的顶部要明确说明这这个范围。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*ScC1SnfDGtI6fZ6UUpvNPg.png">

### 10. 不要反馈 “没有找到相关结果” ###

把一个没有搜索结果的页面丢给用户会令他很沮丧。如果他们搜索了多次都返回这样的结果那就更过分了。 当它们的搜索没有匹配到结果时 **应该避免让他们陷入死胡同** ，为他们提供有价值的替代品。（例如，网店可以从相似类别的商品中为用户推荐替代商品）

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*vWXgR6cGUC7oMrjGw1xwMg.png">

惠普网站的“没有找到相关结果”页就是一个死胡同的例子。它与在无结果页面上显示有价值的替代品的页面形成鲜明对比，例如亚马逊的页面。

### 结论 ###

搜索引擎是构建一个优秀网站的关键要素。用户在寻找和学习事物时期望一个流畅的体验，而且他们通常基于一两组搜索结果的质量对网站的价值做出非常快速的判断。一个优秀的搜索工具应当能够帮助用户快速而简单地查找他们想要的结果。

谢谢!

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
