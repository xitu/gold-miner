> * 原文地址：[Forms Need Validation](https://uxdesign.cc/forms-need-validation-2ecbccbacea1#.qeqexxaek)
* 原文作者：[Andrew Coyle](https://uxdesign.cc/@CoyleAndrew?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[ZiXYu](https://github.com/ZiXYu)
* 校对者：[marcmoore](https://github.com/marcmoore), [zhouzihanntu](https://github.com/zhouzihanntu)

# 每一个表单都渴望验证 #

## 内联验证的设计和错误处理 ##

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/2000/1*Q2ZvXIuTtJePjjAZWdSbmg.jpeg">

内联验证是一种验证输入有效性并在表格提交前就提供反馈的方式。它 [显著增强](http://alistapart.com/article/inline-validation-in-web-forms) 了表单的可用性和用户体验。本文阐述了有关设计表单的内联验证和错误处理的技术。

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

对于上面的问题，我总结了五个答案，每个答案都有自己的优缺点。显然，快速定位表单中出了问题的部分是很重要的，但是如果采用了不妥当的方式反而容易让问题变得更糟糕。

#### 1. 当用户点击一个表单元素时 ####

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*J8Fplefyf7-67jf0f23dqA.jpeg">

当用户点击一个表单元素时直接显示一个错误信息是非常恼人的，同时也容易误导用户，让用户分心。这就好像这个表单在用户还没有说任何话之前就已经在朝用户咆哮了。然而，我们可以选择显示帮助文本来替代错误提示，这样就可以很好的实现这个方式。帮助文本可以一直存在，直到错误的部分被纠正或者输入条目被验证正确。


#### 2. 当用户在进行输入时 ####

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*P-vT9AnP4iSPE6ob6OSmmg.jpeg">

这个方式会在输入条目被验证有效前一直使用户感到不舒服。用户每输入一个字符就会被骚扰一次，这种方式提供的更多是挫败感而不是合理的帮助。这就像在不停地和一个试图说服你的人争论一般。然而，这种方式在用户输入密码和用户名时，可以对密码强度和用户名可用性提供很有帮助的反馈。

#### 3. 当用户的输入到达字符限制时 ####

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/600/1*smLh69YQQHeAB_V8IjLVoA.jpeg">

这种验证方式适用于验证可预测字符长度的输入，例如邮政编码，电话号码，银行汇款号码等。然而，这可能会对表单实现 [国际化](https://uxdesign.cc/form-internationalization-techniques-3e4d394cd7e5#.fqjyl772t) 造成一点困扰，因为输入的格式并不总是已知的。


#### 4. 当用户离开表单元素时 ####

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/600/1*obM310umFGFCX_WUZm8FYQ.jpeg">

这种在输入明确完成之后的验证方式可能是最好的默认行为了。然而，它可能打断用户的输入流程，因为它是在用户完成输入移动到下一个表单元素后才提供反馈的。


#### 5. 当用户停下输入时 ####

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/600/1*ukUmHTkQeDce4Ae7nHl-5g.jpeg">

这种方式是在用户停下输入的时候提供反馈的。这种方式可以减轻用户在键入时产生内联错误的不适感，同时又可以在用户暂停或者退出输入时提供合理的反馈。


可是，令人惊讶的是现在很多的表单并没有采用任何简单的内联验证和错误处理，更令人惊讶的是它们更多的是用很差劲的方式来实现的。我希望这篇文章可以帮助开发者设计一种更好的网页表单验证方式。如果你们有更有帮助的解决方案，我也很期待听到你的回音。

**如果想要联系我，请随时通过** [**Twitter**](https://twitter.com/CoyleAndrew).


这这篇文章作为一个倡导的一部分，目的是搭建一个专注于可用性和美学的UI模式库。[**订阅来获取最新消息**](http://ohapollo.com/)。



![Markdown](http://p1.bqimg.com/1949/a9581415d9cb68fb.png)
