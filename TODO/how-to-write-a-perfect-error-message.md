
  > * 原文地址：[How to Write a Perfect Error Message](https://uxplanet.org/how-to-write-a-perfect-error-message-da1ca65a8f36)
  > * 原文作者：[Vitaly Dulenko](https://uxplanet.org/@atko_o)
  > * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
  > * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-to-write-a-perfect-error-message.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-to-write-a-perfect-error-message.md)
  > * 译者： [Cherry](https://github.com/sunshine940326)
  > * 校对者：[lampui](https://github.com/lampui) [shawnchenxmu](https://github.com/shawnchenxmu)

# 怎么写出完美的错误消息
  
![](https://cdn-images-1.medium.com/max/2000/1*xzoYpYHX1Cgb9cuUi6w-LQ.png)

每一个系统都会出现错误。这可能是用户的错误也可能是系统的错误。在这两种情况下，正确处理错误非常重要，因为它们对于良好的用户体验至关重要。

**一个好的错误消息应该包括下面这 3 个重要部分：**


1. 明确的文字信息。
2. 合适的显示位置。
3. 好的视觉设计。

### **明确的文字**信息

#### 1. 错误消息应该明确

错误消息应该明确地定义是什么错误，错误是怎样发生的并且应该怎样处理。将错误消息想象为你和用户之间的对话：这就应该使得错误消息被拟人化。确保你的错误消失是礼貌的、易懂的、友好的和无术语的。

![](https://cdn-images-1.medium.com/max/1600/1*2RdNRoDJmqfArWaViXal-g.png)

#### 2. 错误信息应该是有用的
只告诉用户哪些地方出错了是不够的。你要告诉读者怎样才能又快又方便的解决问题。

例如，微软描述了错误，并在错误消息中提供了一个解决方案，这样你就可以立即修复这个问题。

![](https://cdn-images-1.medium.com/max/1600/1*9eTjcpNOWtE7pEWXpiPivA.png)

#### 3. 错误消息应该针对具体情况
很多时候，网站对于所有的验证状态只使用一条错误消息。你没有填写邮箱 — 网站提示“请输入有效的邮箱地址”，你漏了“@”符号 — 网站也是提示“请输入有效的邮箱地址”。MailChimp 处理这种情况有另一种方式：他们有 3 个错误消息对应不同的邮箱验证状态。第一个检查是检查在提交表单的时候检查输入是否为空。其他的两个检查是检查是否有“@”符号和“.”符号（“请输入内容”并不是一个很好的例子，因为还并不清楚你需要输入什么样的值。） 向用户显示实际的错误消息，而不是通用的错误消息。

![](https://cdn-images-1.medium.com/max/1600/1*cbmeYu8zkwhuw-I6fxn5gQ.png)

#### 4. 错误信息应该是礼貌的
如果你的用户犯了错误请不要粗鲁地对待他们。对你的用户客气一点，让他们感觉舒适和方便。使用你品牌的声音和个性化的错误消息是一个好的选择。

![](https://cdn-images-1.medium.com/max/1600/1*4C2I4mLoV7A2Xclp5xXYmg.png)

#### 5. 适当的时候使用幽默的语言
在你的错误消息中小心地使用幽默。首先，错误信息应该是提供信息和有用的。然后，您可以改进用户体验，如果适当的话，在错误消息中添加一些幽默性。

![](https://cdn-images-1.medium.com/max/1600/1*cVp9802WuM8W1pb4kSRH-A.png)

### 将错误消息放置在合适的位置
好的错误信息是在需要时可以看到的错误信息。避免错误摘要，在与它们相关的 UI 元素旁边放置错误消息。

![](https://cdn-images-1.medium.com/max/1600/1*90bO1c3llbghosgQTH0hwA.png)

### 为错误消息提供合适的视觉设计
错误消息应该清晰可见。使用对比强烈的文本颜色和背景颜色，这样用户就可以很容易地注意到和阅读消息。

通常情况下，红色用于错误消息文本。在某些情况下，使用黄色或橙色作为某些资源状态因为红色对用户来说过于紧张。在这两种情况下，请确保错误文本是易读的，与背景颜色有明显的对比。别忘了在颜色旁边提供一个相关的图标，帮助色盲人士阅读。

![](https://cdn-images-1.medium.com/max/1600/1*Gny4mwee7oJL1vQsNgJhkg.png)

### 结语
错误消息是改善用户体验、分享您的品牌声音和个性的绝佳机会。注重良好的错误消息，要综合考虑语言、布局和视觉设计等各个方面。使它成为一个真正的完美的产品。


  ---

  > [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
  
