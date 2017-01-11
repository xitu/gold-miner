> * 原文地址：[Form Design for Complex Applications](https://uxdesign.cc/form-design-for-complex-applications-d8a1d025eba6#.l08bq0kbt)
* 原文作者：[Andrew Coyle](https://uxdesign.cc/@CoyleAndrew?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[特伦](https://www.behance.net/Funtrip)
* 校对者：[Mark](https://github.com/marcmoore)、[Freya Yu](https://github.com/ZiXYu)

# 如何为复杂应用设计表单

## 呈现表单的13种方法与数据输入的未来

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/2000/1*RVpQciv-R44ZlAY_dKEXgw.jpeg">

从复杂的 ERP（Enterprise Resource Planning，企业资源计划）系统到 Facebook，是数据的输入让应用们有了意义。表单在许多时候是用户提交数据的一个必经入口。本文介绍了呈现表单的 13 种不同的方法，并探讨了数据输入的未来。

### 模态对话框（Modal）
<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*6zcZuyRJSVwO8KbIg_byLg.jpeg">

简洁的窗口在低复杂度要求和数据有限的情况下很适用。窗口通常很容易实现，并且会有一个很直接了当的用户体验。然而，复杂的交互往往需要额外的窗口或弹出窗口，这会让用户觉得很混乱。当然，窗口可以让用户暂时不与页面的其他部分交互，直到关闭窗口。如果你有一个较长的表单，可以考虑设立一个单独的页面，或者直接在上下文中添加行内编辑的入口。
				

### 多重模态对话框（Multi-modal）

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*JV84BrsVxgFzozI-fHWcpQ.jpeg">

多窗口的表单（也许有一个更好的名称）可呈现为可拖动的窗格，它允许用户一次和多个表单进行交互。用户可以在页面中拖动表单，这使他们可以看到表单下面遮住的内容。多窗口表单可以让重度用户同时输入大量的信息，而不需要打开多个界面或浏览器窗口等等。这样的展示会为初级用户带来一些困扰，因为他们有可能在页面中迷失，或者做出错误的操作。


### 侧边栏（lideouts）

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*_0eKR6PyTRnil20DAw90Dg.jpeg">

侧边栏表单通过滑动主界面中的一部分来展现，或者推动内容来适应表单。和窗口一样，这种展现形式与上下文相关，允许用户在主界面中看到相关的信息。侧边栏通常允许表单的长度更长，因为它占据了整个窗口页面的高度。
				


### 弹出窗口（Popover）

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*k6h1MrBIg-DoCIMzcTmvgw.jpeg">

弹出表单很适合用来实现表单的快速编辑和输入。弹出表单直接在上下文中展现了相关联的数据，因此用户们不会迷失自己在 App 中的位置。
			


### 行内表单（Inline）
<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*woE3kW5k9ec9w7Aw7XfpHA.jpeg">

行内表单允许用户在数据展现的地方直接进入和编辑，而不需要转到另一个界面。行内表单一般有一个编辑和阅读模式，或者当用户与单个字段交互的时候，数据可以被编辑并自动保存。



### 可编辑表格（Editable Table）
<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*nsYFv81hhv5tJPG8wIuJ8Q.jpeg">

与行内表单一样，可编辑表格可以让用户直接在数据展示的地方进行操作。这对于像电子表格或者行列式的发票项目这样平铺数据的情况来说是非常适用的。



### 可延续式窗口（Takeover）

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*uxYT1b0iR93t8M1eIrgVUw.jpeg">

可延续式窗口允许用户与复杂表单数据交互，并且他们能够迅速回到之前的视图。可延续窗口适用于输入系统级的数据而不需要一个后续视图。



### 引导式表单（Wizard）
<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*bUZdK24WxCYo351JD6h8hQ.jpeg">

引导式表单允许用户一步一步按顺序填写信息。引导式适用于那些用户在完成填写之后不会再次交互的复杂表单。当用户对过程很不熟悉的时候应该使用引导式的表单。引导式表单是一种典型的、高使用频率的表单，但它的用户体验较差，且给人居高临下的感觉。



### 章节式表单（Sectioned Form）

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*cXVZjXUt4TRoxnc8HDRhsQ.jpeg">

章节式表单适用于复杂信息的输入。用户可以在表单中看到整个上下文，而不是向导式表单那样的多个页面。用户可以在章节式表单中自由地填写信息，而不需要逐行去填写，这给用户提供了更高的灵活性。



### 拖放（Drag & Drop）
<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*KsKwmpwYGnTbly2JHNy0iQ.jpeg">

虽然这不是一个典型的表单，但拖放编辑器让用户可以从预设的数据中挑选并拖放到一个所见即所得的视图中。通过模拟现实世界的方式，这样的交互模式也显得更加有趣了。



### 所见即所得（WYSIWYG）

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*jID_5VgTs03MaRaxCD4d3Q.jpeg">

所见即所得的编辑器被用在像 Microsoft Word 这样的文字编辑器，MailChimp 这样的邮件编辑器，或是 SquareSpace 这样的网页发布工具上。 所见即所得的编辑器允许用户创建富文本而不需要学习 HTML, CSS 和 JS 的相关知识。


### 填补空白（Fill in the blanks）

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*TO6FcUsAps09_1x1edIUVw.jpeg">

有时候追求最佳的实用性，会忽略审美和有趣的交互。为了不造成一个糟糕的用户体验我写了一篇关于[实用性审美](https://uxdesign.cc/aesthetics-matter-75060b7b572)的文章。在句子或段落中填入当前输入的预设样式，可以帮助用户完成输入他们的数据。



### 对话式用户界面及其未来

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*GZcRV8jv6To_qil0mHSZeQ.jpeg">

对话式用户界面（CUI）通常由一个“[机器人](https://chatbotsmagazine.com/the-complete-beginner-s-guide-to-chatbots-8280b7b906ca)”来回复任意的语音或文字输入。机器人会回答或提供下一步的表单空间来输入请求。机器学习已经被用来更好地理解输入和定制回复。

关于 CUI 的炒作非常之多。许多设计师认为 CUI 是网络表单的未来，微信的成功就提供了一个可靠的例子。然而，正如 [Yunnuo Cheng 和 Jakob Nielsen 所指出的](https://www.nngroup.com/articles/wechat-integrated-ux/)，**微信整体服务的效力更多来源于友好和方便的图形用户界面而不是对话式用户界面。**

CUI 有很多可用性方面的硬伤：缺乏探索性，不固定的完成步骤。CUI 不是表单的未来，但它是许多[聊天软件](https://operator.com/)的未来，它们已经围绕这条路线找到了收集数据的方法。

期待着融合了 CUI 和图形界面的设计出现。迷你的可嵌入的应用程序可以基于用户的数据输入来展现，它能够在一个复杂的应用程序里起到引导作用，比方说有可能是一个对话窗口的形式。又或者，当用户在程序中迷失了方向的时候 CUI 将会很有用处。为了更深入地了解，[Tomaž Štolfa](https://medium.com/@tomazstolfa) 有一篇[关于 CUI 的很好的文章](https://medium.com/the-layer/the-future-of-conversational-ui-belongs-to-hybrid-interfaces-8a228de0bdb5)。



OCR 功能的进步，软件自动化的流程——当数据输入变得更标准化，许多表单都会过时。但是，用户界面却总是需要的。我希望这些不同的展现形式可以帮助你制作一个更好的应用。如果我错过了什么，**请记得告诉我。**

这篇文章是关于如何自主创建一个用户界面库的一部分，专注于实用性和审美。如果你感兴趣，你可以[**订阅并接收更新**](http://ohapollo.com/)。

