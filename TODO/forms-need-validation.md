> * 原文地址：[Forms Need Validation](https://uxdesign.cc/forms-need-validation-2ecbccbacea1#.qeqexxaek)
* 原文作者：[Andrew Coyle](https://uxdesign.cc/@CoyleAndrew?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[ZiXYu](https://github.com/ZiXYu)
* 校对者：

# 表单验证 #

## 内联验证的设计和错误处理 ##

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/2000/1*Q2ZvXIuTtJePjjAZWdSbmg.jpeg">

内联验证是一种验证输入有效性并在表格提交前就提供反馈的方式。它 [显著增强](http://alistapart.com/article/inline-validation-in-web-forms)  It [significantly enhances](http://alistapart.com/article/inline-validation-in-web-forms) 了表单的可用性和用户体验。本文阐述了有关设计表单的内联验证和错误处理的技术。

#### 表单验证 ####

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*GkbL2-v4ZnPCkjX_qENIpg.jpeg">

内联验证的范例

内联验证中比较容易的部分是验证环节。当一个输入条目被成功验证时，我们可以直接用一个简单的复选标记来标记它。而处理内联错误就比较棘手了。

### 显示内联错误 ###

显示内联错误时，应把产生错误的原因以及如何修改它也显示出来。

**显示的方法有很多种，包括如下几种：**

#### 在表单元素上面显示 ####

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*cdCTiOz5VWoYwEbuoIBPtg.jpeg">


#### 在表单元素下面显示 ####

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*2iy-a2-Lz6Xtzr51hpE2Dw.jpeg">


#### 与表单元素内联显示 ####

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*BgIZUKTBA6rZ1-smzNrs_w.jpeg">


#### 用小提示的方法显示 ####

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*jBz0FJcN4v_xDGRgVBmntA.jpeg">


### [什么时候应该提供内联验证和错误显示？](http://ux.stackexchange.com/questions/74531/form-validation-when-should-error-messages-be-triggered) ###

I have distilled 5 ways; each with its trade-offs and limitations. It’s important to address problems early and at their source, but it is easy to make matters worse with an inconsiderate approach.
对于上面的问题，我总结了五个答案，每个答案都有自己的优缺点。显然，从源头快速解决问题是很重要的，但是这也很容易因为没有思虑周全的解决方式让问题变得更糟。

#### 1. When a user click into an input ####
#### 1. 当用户点击一个表单元素时 ####

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*J8Fplefyf7-67jf0f23dqA.jpeg">

Immediately showing an error when a user clicks into a field is annoying, misleading, and distracting. It is like the form is yelling at you before you say anything. Talk about a bad relationship… However, this approach can be done well by presenting helper text in place of an explicit error until the error is confirmed, or the entry validated.
当用户点击一个表单元素时直接显示一个错误是非常恼人的，同时也容易误导用户，让用户分心。这就好像这个表单在用户还没有说任何话之前就已经在超用户咆哮了。 It is like the form is yelling at you before you say anything. Talk about a bad relationship… However, this approach can be done well by presenting helper text in place of an explicit error until the error is confirmed, or the entry validated.


#### 2. As a user types ####

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*P-vT9AnP4iSPE6ob6OSmmg.jpeg">

This approach annoys the user until the entry is validated. The user is harassed with each entered character, providing more frustration than help. It is like arguing with someone who is talking over you…However, this method provides helpful feedback for password strength and username availability.


#### 3. Once the user reaches the character requirement ####

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/600/1*smLh69YQQHeAB_V8IjLVoA.jpeg">

This validation method works for inputs with predictable character lengths like Zip codes, phone numbers, CC numbers, etc. However, this can be problematic for [internationalization](https://uxdesign.cc/form-internationalization-techniques-3e4d394cd7e5#.fqjyl772t) because the intended formate is not always known.


#### 4. When a user leaves the field ####

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/600/1*obM310umFGFCX_WUZm8FYQ.jpeg">

This is probably the best default behavior because validation occurs after the entry is made explicit. However, it can disrupt a user’s flow because it provides feedback after the user has moved on.


#### 5. When a user pauses ####

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/600/1*ukUmHTkQeDce4Ae7nHl-5g.jpeg">

This technique provides feedback when a user pauses. This mitigates the annoyance of inline errors as a user types and provides feedback when they pause or exit the input.


It is surprising how many forms don’t employ simple inline validation and error handling, and it is even more surprising how often it is poorly implemented. I hope this article helps you design better web form validation. I would love to hear your helpful techniques.

**Feel free to reach out to me on** [**Twitter**](https://twitter.com/CoyleAndrew).

This article is part of an initiative to build a user interface pattern library focused on usability and aesthetics. [**Subscribe to receive updates**](http://ohapollo.com/) .

#### If you found this article of value, please click the ❤ below so others can find it too. ####

![Markdown](http://p1.bqimg.com/1949/a9581415d9cb68fb.png)
