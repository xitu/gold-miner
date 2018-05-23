> * 原文地址：[How not to Vue: A list of bad things I’ve found on my new job](https://itnext.io/how-not-to-vue-18f16fe620b5)
> * 原文作者：[Anton Kosykh](https://itnext.io/@kelin2025?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-not-to-vue.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-not-to-vue.md)
> * 译者：[sophiayang1997](https://github.com/sophiayang1997)
> * 校对者：[kezhenxu94](https://github.com/kezhenxu94/)

# 怎样更好地使用 Vue

## 我在新工作中遇到的一些问题清单

![](https://cdn-images-1.medium.com/max/800/1*pWo4h-AhSfgyFHDlAkchcw.png)

下面列举一些人的做法。

不久之前，我找到了新工作。而且当我第一次看到代码库的时候，这真是吓坏我了。因此我想在这里展示一些你应该避免在 Vue.js 应用程序中出现的代码。

### data/computed 中的静态属性

我们没有理由将静态属性传递给 `data` ，特别是 `computed` 。当你这样做时， Vue 将其声明为响应式属性，但是这是不必要的做法。

![](https://cdn-images-1.medium.com/max/800/1*TUsVw4rEJwhw2iFuSyEWkw.png)

**DON’T.** phone 和 city 的响应性毫无用处.

![](https://cdn-images-1.medium.com/max/800/1*HYgxVfj99dt-yaGIeSABGw.png)

**DO.** 将静态属性传给 `$options`. 它更加简短，而且不会做多余的工作。

### 考虑将非响应式（non-reactive）的数据转变为响应式（reactive）

请记住： Vue 不是神通广大的. Vue 并不知道你的 **cookies** 何时才会更新.

我提到 cookies 的原因是：我的同事曾经花两个小时去搞清楚为什么他的计算属性没有更新。

![](https://cdn-images-1.medium.com/max/800/1*mSQ5DXcLOlFK6vfdz-Gyjw.png)

**DON’T.** 计算属性应该只基于 Vue 的响应式数据去使用。否则，它将不会起作用。

![](https://cdn-images-1.medium.com/max/800/1*Q7HhvYfTsHNUZLMcnptbhw.png)

**DO.** 手动更新你的非响应式数据。

此外，我建议你不要在计算属性中使用任何边数据（side-data）。你的计算属性中不应该有任何副作用。这样做会为你节省很多时间。相信我。

### 只应该被调用一次的混入（mixins）对象

一听到我说 mixins 很好，**马上就有人关闭这篇帖子了…** 其实 mixins 在一些情况下还是很好用的：

1. 创建可以修改 Vue 实例的插件，提供新功能。
2. 在不同的组件或者整个应用程序中使用通用的特定方法。

除非有人在 `mounted` 钩子上注册了一个执行效率非常缓慢的全局混入对象。为什么不推荐这样做呢？因为在**每个**组件挂载时该全局混入对象都会被调用，但原则上它只能被调用一次。

我不会展示这一段代码。相反，为了使它更清晰，我会给你一个更简单的例子。

![](https://cdn-images-1.medium.com/max/800/1*qCp4mZoUYKb2PPoqDFeByA.png)

**DON’T.** 避免在混入中（mixins）中执行此操作。它会在每个组件挂载时被调用，即使你并不需要这样做。

![](https://cdn-images-1.medium.com/max/800/1*7-g24ZUvldsPh8XIIPaxTw.png)

**DO.** 在根实例中执行此操作。那么它只会被调用一次。你仍然可以使用 `$root` 访问结果。

#### setTimout/setInterval 的不正确使用

在一次面试中，我团队中一个前端开发者问我是否可以在组件中使用 setTimout/setInterval 。我回答“可以”，但还没来得及解释如何正确使用它，**我就已经被指责不够专业了**。

现在我必须维护某一个人的代码，因此我将这一段文字献给他。

![](https://cdn-images-1.medium.com/max/800/1*FxPRflqqk8K6wRr4jUyFBQ.png)

**DON’T.** 你可以使用间隔（intervals）。但是如果你忘记使用 `clearInterval` ,就会在组件卸载时出错。

![](https://cdn-images-1.medium.com/max/800/1*7kBqD5KNSkCTTpP2O7FUgw.png)

**DO.** 在 `beforeDestroy` 钩子中使用 `clearInterval` 来清除间隔。

![](https://cdn-images-1.medium.com/max/800/1*Tmr7GIY7saojZkOPoVQfuQ.png)

**DO.** 如果你不想这么麻烦，可以考虑使用 [**vue-timers**](https://github.com/kelin2025/vue-timers) 。

### 变异的父实例

这是 Vue 中我最不喜欢的设计了，真心希望有一天能把它移除（雨溪，拜托你了）。

我没有见过使用 `$parent` 的真实用例。它会使组件变得更加呆板，并且会产生一些让你意想不到的问题。

![](https://cdn-images-1.medium.com/max/800/1*MYb4iAVzlvQPZDWqCnJM0w.png)

**DON’T.** 如果你试图去改变 `props` ， Vue 会警告你，但是如果你通过 `$parent` 去改变 `props`，Vue 将无法检测到。

![](https://cdn-images-1.medium.com/max/800/1*pJkabHNu8Gx7f4UMM07FMg.png)

**DO.** 使用事件触发器（events emitter）去监听事件。此外， `v-model` 只是 `value` 属性和 `input` 事件的语法糖。

![](https://cdn-images-1.medium.com/max/800/1*yypns5Qp2y_t7HrsPT5O7g.png)

**DO.** Vue 还有一个语法糖： `.sync` 修饰符用于更新 `update:prop` 事件中的 `prop` 。

### If/else 表单验证

当我发现一些需要手动验证的表单时我感到非常困惑。它会产生大量无用的样板代码。

![](https://cdn-images-1.medium.com/max/800/1*yn_pt6eFfOIz-RvMEA30gQ.png)

**DON’T.** 我在新项目中被类似的代码吓坏了。不要再这样愚蠢了，这个问题有很多可行的解决方案

![](https://cdn-images-1.medium.com/max/800/1*omOSNM6WmpsYSN3C4dy4dw.png)

**DO.** 请使用 [**vuelidate**](https://monterail.github.io/vuelidate/)。对于每个字段只需要一行验证规则，多么整洁且具有声明性的代码。

![](https://cdn-images-1.medium.com/max/800/1*_4S2iHw93lSS_GIeceJ_YA.png)

**DO.** 我也制作了一个允许你使用一个对象声明表单数据和验证的小[**插件**](https://github.com/Kelin2025/vuelidate-forms) 。

### 最后

这些当然不全是 Vue.js 初级开发者的罪过，并且我相信这份问题清单可能是无限的，但我认为这份清单已经足够了。

那么，如果你在 Vue.js 项目中看到了什么“有趣”的东西，可以在这里回复我 :) 。

谢谢阅读！记住不要重复愚蠢的错误 :) 特别鸣谢为 [**carbon.now.sh**](https://carbon.now.sh/) 做出贡献的人。奶思！


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
