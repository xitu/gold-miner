
  > * 原文地址：[How to Write a Perfect Error Message](https://uxplanet.org/how-to-write-a-perfect-error-message-da1ca65a8f36)
  > * 原文作者：[Vitaly Dulenko](https://uxplanet.org/@atko_o)
  > * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
  > * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-to-write-a-perfect-error-message.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-to-write-a-perfect-error-message.md)
  > * 译者：
  > * 校对者：

  # How to Write a Perfect Error Message

  ![](https://cdn-images-1.medium.com/max/2000/1*xzoYpYHX1Cgb9cuUi6w-LQ.png)

Every system can’t work without errors. It can be user’s errors or system’s fails. In both cases, it’s very important to handle errors in a right way as they are crucial for a good user experience.

**Here are 3 vital parts of every good error message:**

1. Clear text message.
2. Right placement.
3. Good visual design.

### **Clear text** message

#### 1. Error message should be clear

The error messages should clearly define what the problem was, why it happened, and what to do about it. Think of your error message as a conversation with your user — it should sound like they’ve been written for humans. Make sure your error message is polite, understandable, friendly and jargon-free.

![](https://cdn-images-1.medium.com/max/1600/1*2RdNRoDJmqfArWaViXal-g.png)

#### 2. Error message should be helpful

It’s not enough to write that something went wrong. Show the users the way how to fix it as soon and easy as possible.

For example, Microsoft describes what’s wrong and provides a solution in the error message so you can immediately fix this issue.

![](https://cdn-images-1.medium.com/max/1600/1*9eTjcpNOWtE7pEWXpiPivA.png)

#### 3. Error message should be specific to the situation

Very often websites use only one error message for all validation states. You left this email field blank — “Enter a valid email address”, you missed the “@” character — “Enter a valid email address”. The MailChimp does it in another way — they have 3 error messages for each state of email validation. The first one checks if the input field isn’t blank when submitting the form. The other two check if there is “@” and “.” characters. (However “Please enter a value” isn’t a great example of the error writing, it is unclear what kind of value you need to enter.) Show your users actual messages instead of general ones.

![](https://cdn-images-1.medium.com/max/1600/1*cbmeYu8zkwhuw-I6fxn5gQ.png)

#### 4. Error message should be polite

Don’t blame your users that they did something wrong even if they did. Be polite to your user, make them feel comfortable and convenient. It’s a great opportunity to use your brand voice and add personality into the errors.

![](https://cdn-images-1.medium.com/max/1600/1*4C2I4mLoV7A2Xclp5xXYmg.png)

#### 5. Use humor if it’s appropriate

Be careful using humor in your error message. First of all the error message should be informative and helpful. Then you can improve user experience adding some humor in your error message if it’s appropriate.

![](https://cdn-images-1.medium.com/max/1600/1*cVp9802WuM8W1pb4kSRH-A.png)

### The right place for error messages

The good error message is that one you can see when needed. Avoid error summaries, place error messages next to the UI elements they are related to.

![](https://cdn-images-1.medium.com/max/1600/1*90bO1c3llbghosgQTH0hwA.png)

### The right visual design for the error message

The error message should be clearly visible. Use contrast text and background colors so the user can easily notice and read the message.

As usual, the red color is used for error message text. In some cases, yellow or orange colors are used as some resources state that red color is too stressful for users. In both cases, be sure that the error text is legible, with noticeable contrast against its background color. Don’t forget to provide a related icon alongside the color to improve the accessibility for people with color-blindness.

![](https://cdn-images-1.medium.com/max/1600/1*Gny4mwee7oJL1vQsNgJhkg.png)

### Conclusion

Error messages are a great opportunity to improve user experience, share your brand voice and personality. Pay attention to all aspects of a good error message — the language, placement, and visual design to make it a really perfect.


  ---

  > [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
  