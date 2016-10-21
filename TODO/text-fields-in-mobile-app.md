>* 原文链接 : [Text Fields in Mobile App](https://uxplanet.org/text-fields-in-mobile-app-11d41f13e31#.pjomtd59r)
* 原文作者 : [Nick Babich](http://babich.biz/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Zhangjd](https://github.com/zhangjd)
* 校对者: [Jasper Zhong](https://github.com/DeadLion), [Velacielad](https://github.com/Velacielad)

# 如何在移动 APP 中设计输入框

![](https://cdn-images-1.medium.com/max/800/1*Mv1Jk8roDxeLZ8j1DoYNfQ.png)

<figcaption>图片来源: Material Design</figcaption>

交互设计在移动设备上遇到了许多挑战。其中一个最具挑战的问题是：在用户输入时如何利用有限的屏幕空间，其关键在于产品设计师、开发者和产品经理需要理解对于用户来说怎么样输入是最为简单的。

这篇文章列出了三个改善数据输入体验的关键因素，分别是 _改进输入速度_，_为用户提供帮助和支援_ 和 _在用户输入时直接指出问题所在_。

### 输入

#### 根据需要输入的文本类型匹配键盘布局

用户喜欢那些在输入文本时能够提供合适键盘布局的应用。不像物理键盘，触摸键盘可以随时调整，根据每个表单域的不同数据类型，为用户提供不同的键盘布局。通常可以进行优化的输入类型包括：

*   _数字_: 电话号、信用卡号、PIN 码
*   _文本_: 固有名称、用户名
*   _混合格式_: 邮箱地址、街道地址、搜索查询

确保这些项可以在你的 app 中 **持续地** 进行优化，而不是只在某些特定任务中优化。

![](https://cdn-images-1.medium.com/max/800/1*kxiM7U6cuaB-NQUpn-Nr8g.png)

<figcaption>图片来源：谷歌</figcaption>

#### 合理配置自动大写功能

如何合理地设置自动大写，对于移动端表单域的可用性是很重要的。如果语言本身有要求，每个文本框的首字母和每句话的开头字母都应该大写。相关例子：

*   询问用户的姓名
*   包含句子的信息，比如短信

但是，要注意不让电子邮件的文本框开启自动首字母大写，当用户发现时，可能会返回删除大写的首字母再改回小写，因为他们会担心邮件不能正常发送。

![](https://cdn-images-1.medium.com/max/800/1*f64JtWvrYIPddHciDaOC0Q.png)

<figcaption>图片来源：Baymard</figcaption>

#### 当词典不够智能时，关闭自动纠错

_用户反感低效的自动纠错功能，如果用户没有发现这个功能，可能还会造成问题。_当用户发现自动纠错功能对于那些单词缩写、街道名称、邮箱、人名和一些不在字典的单词表现非常糟糕的时候，是极其影响用户体验的。

在老版本的亚马逊 app 中，地址栏曾经有自动纠错功能，却导致了正确地址被这个功能改写为错误的。

![](https://cdn-images-1.medium.com/max/800/1*OWDLp1jvxj2PyFy08Bxc4g.png)

<figcaption>图片来源：Baymard</figcaption>

这种情况经常会发生，因为_用户通常只关注了他们正在输入什么，而不是他们已经输入的内容。_对于地址信息，这样会导致用户输入的有效地址被自动纠错改成了无效地址，而用户却没有留意到自动纠错已经发生，最终提交了错误的地址。

#### **固定的输入格式**

_不要使用固定输入格式。_强制使用固定格式的最常见原因，是受到验证脚本的限制（难道后端不能确定所需要的格式？）。在大部分情况下，这是开发的责任，而非用户。与其强迫用户输入某些特定格式，比如电话号码，不如想办法把用户输入转化为你想要显示或者存储的格式。

![](https://cdn-images-1.medium.com/max/800/1*9Khj17wpCJc2RntjrNbsWQ.png)

<figcaption>图片来源：Google</figcaption>

#### 默认值和自动完成

你应该频繁预测用户的选择项，通过提供智能预测的默认值，或者基于过去输入内容的提示，使得用户更加容易地输入内容。比如，你可以通过用户的地理位置信息，预测用户所属国家。

这个解决方案可以和自动完成功能配合使用，让用户输入速度显著提升。自动完成会在下拉列表中实时地列出建议，使得用户可以更加准确和有效地完成输入。这对于那些语言水平不高或者忘记拼写的用户非常有用，尤其是输入非母语的时候。

![](https://cdn-images-1.medium.com/max/800/1*eItk9M2fg9Li6ZEh9xziEg.png)

<figcaption>带有提示的文本域。图片来源：Material Design</figcaption>

### 标签和帮助信息

用户想要知道在输入框中填入哪种信息，清晰的标签正是一种让 UI 更加易于理解的方式。标签告诉用户每个输入框的目的，在表单域获得焦点甚至完成输入后，保持其有效性。

你还应该在表单域的上下文提供帮助信息。提供相关的语境信息，可以帮助用户更加容易地完成操作。

#### 限制单词数

标签并非帮助文字，你应当使用简明扼要的标签（一两个单词），使得用户可以快速了解你的文本域。

![](https://cdn-images-1.medium.com/max/800/1*8qJ_57advUKzVHH73yQ_Pg.png)

<figcaption>‘Phone’, ‘Check in’, ‘Check out’ 都是输入框的标签</figcaption>

如果有需要可以对表单域提供更多信息，当用户面对有用的信息，可以用于消除困惑或者减少潜在的错误。

![](https://cdn-images-1.medium.com/max/800/1*3fHQN7BHQUaBFK31Zr1hbg.png)

<figcaption>在 ‘Phone’ 表单域下面的信息就是帮助文本。图片来源: Google</figcaption>

#### 语言简单化

_从用户的角度出发。_ 未知的术语和词组会增大用户的认知成本。清晰的传达方式和实用性应该总是优先于专业术语和品牌信息。

![](https://cdn-images-1.medium.com/max/800/1*P3dJ7JrBTBNKKqvC3eSVsA.png)

<figcaption>左边：非传统的术语可能让用户感到迷惑。右边：术语更加清晰和易于理解。</figcaption>

#### 内联标签

内联标签（或者占位符文本）对于简单的表单域非常合适，比如用户名或者密码。

![](https://cdn-images-1.medium.com/max/800/1*knRzBR03ppWJJ1Ka5BYkRg.gif)

<figcaption>图片来源: [snapwi](https://www.snapwi.re/)</figcaption>

但是当页面超过两个表单域时，用占位符文本来代替分离的文本标签就不合适了。占位符确实非常流行，看起来也不错，但是它有两个严重的问题：

*   一旦用户点击了文本域，标签就消失了，因此用户不能再次检查输入内容是不是表单要求填写的。
*   当用户看见文本框有内容的时候，可能会以为这个地方预先填充了内容，并因此而忽略填写。

其中一个占位符的优化方案是 _浮动标签 —_ 当用户填写这个表单域时，可浮动的内联标签就会移到表单域的上方。

![](https://cdn-images-1.medium.com/max/800/1*5bTgQotfDCuGQDN2aT1lbA.gif)

<figcaption>浮动内联标签。来源: [Dribbble](https://dribbble.com/shots/1254439--GIF-Float-Label-Form-Interaction)</figcaption>

**建议：** 不要只依赖于占位符或者标签。一旦文本域被填写了内容，占位符文字就看不见了。你可以使用浮动标签，以确保用户可以知道他们填写的内容是否正确。

#### 标签颜色

标签颜色应该和 app 的配色方案相关，同时应该有合适的对比度（不应该太亮或者太暗）。

![](https://cdn-images-1.medium.com/max/800/1*q7wWnvpes3AzaGdI4H7M6g.png)

<figcaption>图片来源: Material Design</figcaption>

### 验证

表单域验证是为了和用户对话，并引导他们处理错误和不确定信息。其输出内容应该是感性而非纯技术的。在数据处理中，其中一个最重要但是通常不被人喜爱的部分就是数据处理。犯错是人之常情，你输入的内容也不例外。如果做得好的话，验证可以把模糊不清的交互步骤变得更加清晰。

#### 实时验证

用户可不喜欢当他们填完了所有信息，最后点击提交的时候，才发现信息有错误。告知用户输入内容是否正确的最佳时机，是在用户填完内容后立刻告知用户。

_实时内联验证_可以马上告知用户输入的正确性。这个方法让用户更快地改正错误，而不需要等到他们按下提交按钮。错误状态可以使用对比色，比如暖色调的红色或者橙色。

![](https://cdn-images-1.medium.com/max/800/1*hwtem6mCBFr-ebuwD7mjGw.png)

<figcaption>提交时验证 vs 实时验证。图片来源: Google</figcaption>

验证过程不仅应该告诉用户他们做错了，还应该告诉用户他们做的不错。这样可以给用户信心来完成余下的输入过程。

![](https://cdn-images-1.medium.com/max/800/1*kuLnXBjp_4KZx9KRktKnSQ.gif)

<figcaption>图片来源: [Dribbble](https://dribbble.com/shots/1059244-OnSite-Form-Validation-GIF)</figcaption>

#### 清晰的反馈

对于用户问题——“刚才发生了什么？为什么会这样？”，应该直接给出答案，有效的回答应该清晰说明：

*   发生了什么错误，可能原因是什么。
*   用户应该做什么来改正错误。

再次提醒，应该避免出现技术术语。这个原则很简单，但是有时候很容易忽略。

#### 正确的颜色

_颜色是设计验证时的最佳工具之一。_ 由于人的视觉本能，红色错误信息、黄色警告信息、绿色成功信息都是非常易于识别的。下图是验证密码强度一个很好的示例：

![](https://cdn-images-1.medium.com/max/800/1*9x2dm9CC2TFSVXLx5IrB7A.png)

<figcaption>密码表单域的警告状态</figcaption>

另一个例子是用于表单域字符限制的提示颜色。字数计数器和边框线条变红的时候，说明字数超过了限制。

![](https://cdn-images-1.medium.com/max/800/1*88yUJWX9w2VH1TxLvDeqGw.png)

<figcaption>图片来源: Material Design</figcaption>

但是不要只依赖于颜色来反馈验证信息！[确保界面对于用户是可理解的](https://uxplanet.org/accessible-interface-design-3c59ee3ec730#.budh6j6jf)，这对于视觉设计执行而言，是一个非常重要的方面。

### 结论

你应该让数据输入的过程尽可能简单。每一个微小的工作，比如自动大写转换或者指明每个表单域填写什么信息，都可以有效提高表单域的可用性和交互设计的质量。深入思考用户实际上是如何使用应用和输入内容的。当设计 app 时，确保没有遗漏上述提及的问题。

