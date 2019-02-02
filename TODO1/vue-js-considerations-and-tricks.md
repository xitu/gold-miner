> * 原文地址：[Vue.js — Considerations and Tricks](https://blog.webf.zone/vue-js-considerations-and-tricks-fa7e0e4bb7bb)
> * 原文作者：[Harshal Patil](https://blog.webf.zone/@mistyHarsh)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/vue-js-considerations-and-tricks.md](https://github.com/xitu/gold-miner/blob/master/TODO1/vue-js-considerations-and-tricks.md)
> * 译者：
> * 校对者：

# Vue.js — 注意事项和技巧

![](https://cdn-images-1.medium.com/max/1600/1*Agh6VagdEwoIziUUnbxgOg.png)

Vue.js 很棒。但是， 当你开始构建大型 JavaScript 应用时，你将开始触及 Vue.js 的边界。实际上这些边界并不是框架的限制；相反，这些边界是 Vue.js 团队不断进步地重要设计决策。

与 React 或 Angular 不同，Vue.js 迎合不同级别的开发人员。对于初学者它友好，易用，并且对于专家它同样灵活。它不会试图回避 DOM。相反，它发挥得很好。

话虽如此，但这篇文章更像是我在 Vue.js 启蒙途中遇到的一些重要 **讨论，问题和技巧** 的目录。了解这些关键的设计方面有助于我们构建大型的web应用程序。

同样，这些讨论在 2018 年 5 月 18 日的今天有效。当框架升级，底层浏览器和 JS API 将发生改变，它们可能无效和不直观。

* * *

#### 1. 为什么 Vue.js 不使用开箱即用的 ES 类组件？

如果你来自类似 Angular 的框架或一些后端 OOP 的重语言，你的第一个问题将是 - 为什么不是组件类？

Vue.js 作者, [尤雨溪](https://medium.com/@youyuxi), 在 GitHub 评论中已经很好地回答了这个问题：

- [**使用标准 js 类而不是自定义语法？ · Issue #2371 · vuejs/vue**](https://github.com/vuejs/vue/issues/2371#issuecomment-284052430 "https://github.com/vuejs/vue/issues/2371#issuecomment-284052430")

不将类作为默认机制有三个主要的原因：

1.  ES 类不足以满足 Vue.js 当前 API 的需求。ES 课程没有完全发展，经常被批评为错误方向的一步。具有私有字段和装饰器的类一旦稳定（至少第 3 阶段）可能会有所帮助。
2.  ES 课程只适用于熟悉基于类的语言的人。它很容易排除不使用复杂构建工具或转换器的大型 web 社区。
3.  **构建出色的 UI 组件层次结构是关于出色的组件组成。它与伟大的继承层次结构无关。不幸的是，ES 类在后者方面更胜一筹。**

* * *

#### 2. 如何构建自己的抽象组件？

如果构建大型 web 应用是不够的，那么你有一些疯狂的想法来实现一个抽象组件，如 `<transition>` 或 `<router-view>`。这肯定有关于此的讨论，但它真的没有通过。

- [**任何抽象组件的文档计划？ · Issue #720 · vuejs/vuejs.org**](https://github.com/vuejs/vuejs.org/issues/720 "https://github.com/vuejs/vuejs.org/issues/720")

但是不要害怕，通过对插槽的充分理解，你可以构建自己的抽象组件。这有一篇非常好的博客文章来解释如何做到这一点。

- [**用 Vue.js 编写抽象组件**](https://alligator.io/vuejs/vue-abstract-components/ "https://alligator.io/vuejs/vue-abstract-components/")

但在你这样做之前还是要三思而行。我们一直依靠 mixins 和 plain 函数来解决一些极端情况。只需将 minxins 视为您的抽象组件：

- [**如何在一个单文件组件中扩展另一个 Vue.js 组件？（ES6 vue-loader）**](https://stackoverflow.com/a/35964246/5723098 "https://stackoverflow.com/a/35964246/5723098")

* * *

#### 3. 我真的对用 Vue.js 单文件组件 不舒服。我更喜欢把 HTML，CSS 和 JavaScript 分开。

没有人阻止你这么做。如果你是老派的 Separation of Concern 哲学家，喜欢将单独的东西放在单独的文件中，或者你讨厌代码编辑器围绕 `.vue` 文件的不稳定行为，那么它肯定是可能的。所以你需要做的：

```
<!--https://vuejs.org/v2/guide/single-file-components.html -->

<!-- my-component.vue -->
<template src="./my-component.html"></template>
<script src="./my-component.js"></script>
<style src="./my-component.css"></style>
```

但是，紧接着就出现了下一个问题 ——**我总是要为了我的组件需要 4 个文件（vue + html + js + css）吗。我可以以某种方式去掉** `**.vue**` **文件吗？**答案肯定是可以，你可以这样做。使用 `vue-template-loader`。

- [**ktsn/vue-template-loader**: vue-template-loader - Vue.js 2.0 template loader for webpack](https://github.com/ktsn/vue-template-loader "https://github.com/ktsn/vue-template-loader")

我的同事写了一篇关于它的很好的博客：

- [**Using vue-template-loader with Vue.js to Compile HTML Templates**: Using vue-template-loader to eliminate need for .vue files in Vue apps, if you're feeling so inclined!](https://alligator.io/vuejs/vue-template-loader/ "https://alligator.io/vuejs/vue-template-loader/")

* * *

### 4. 函数组件

感谢 React.js，函数组件是现在的热潮，虽然有充分的理由。它们 **快速，无状态且易于测试**。但是，它们有一些问题。

#### 4.1 为什么我不能为函数组件使用基于类的 @Component 装饰器？

又回到类上，应该注意的是，类是旨在保持本地状态的一种数据结构。如果函数组件是无状态的，那么 @Component 真的没有意义。

相关讨论可在以下网站查阅：

- [**怎样在 @Component 中创建函数组件？ · Issue #120 · vuejs/vue-class-component**](https://github.com/vuejs/vue-class-component/issues/120 "https://github.com/vuejs/vue-class-component/issues/120")

#### 4.2 外部类和样式不适用于函数组件

函数组件没有像普通组件那样的类和样式绑定。必须在渲染函数中手动应用这些绑定。

- [**DOM class attribute not rendered properly with functional components · Issue #1014 ·…**](https://github.com/vuejs/vue-loader/issues/1014 "https://github.com/vuejs/vue-loader/issues/1014")

- [**class attribute ignored on functional components · Issue #7554 · vuejs/vue**](https://github.com/vuejs/vue/issues/7554 "https://github.com/vuejs/vue/issues/7554")

#### 4.3 函数组件总是重新渲染？

> TLDR: 在函数组件中使用 **有数据的** **组件** 时要小心

- [**Functional components are re-rendered when props are unchanged. · Issue #4037 · vuejs/vue**](https://github.com/vuejs/vue/issues/4037#issuecomment-258164999 "https://github.com/vuejs/vue/issues/4037#issuecomment-258164999")

函数组件非常 **渴望** 直接使用组件的渲染函数。这也意味着你应该：

> 避免在渲染函数中直接使用有状态的组件，因为这会在每一次调用渲染函数时创建不同的组件定义。

**如果函数组件是子组件，它们会更好地被使用**。应该注意的是，这种行为也适用于 React.js。

#### 4.4 如何从 Vue.js 函数组件中发出事件？

从函数组件中发出事件并不是直接了当的。不幸的是，文档中没有提到这一点。`$emit` 方法在函数组件中不可用。以下 stack overflow 问题将在这方面有所帮助：

- [**How to emit an event from Vue.js Functional component?**: This is explained in the docs Passing Attributes and Events to Child Elements/Components: If you are using...](https://stackoverflow.com/questions/50288996/how-to-emit-an-event-from-vue-js-functional-component "https://stackoverflow.com/questions/50288996/how-to-emit-an-event-from-vue-js-functional-component")

* * *

#### 5. Vue.js 透明包装组件

透明包装组件包装一些 DOM 结构，但暴露该 DOM 结构的事件而不是根 DOM 元素。例如，

```
<!-- Wrapper component for input -->
<template>
    <div class="wrapper-comp">
        <label>My Label</label>
        <input @focus="$emit('focus')" type="text"/>
    </div>
</template>
```

这里，我们真的对 `input` 标签 感兴趣而不是 根 `div` 元素，因为它主要用于添加样式和装饰的。该组件的用户可能对来自 input 的几个事件感兴趣，例如 `blur`，`focus`，`click`，`hover`等。这意味着我们必须重新发出每个事件。我们的组件看起来像这样。

```
<!-- Wrapper component for input -->
<template>
    <div class="wrapper-comp">
        <label>My Label</label>
        <input type="text"
            @focus="$emit('focus')"
            @click="$emit('click')"
            @blur="$emit('blur')"
            @hover="$emit('hover')"
        />
    </div>
</template>
```

现在是 **anti-DRY 且看起来很乱**。简单的解决方案是使用 Vue 实例上的 `vm.$listeners` 属性简单地将事件侦听重新绑定到所需的 DOM 元素：

```
<!-- Notice the use of $listeners -->
<template>
    <div class="wrapper-comp">
        <label>My Label</label>
        <input v-on="$listeners" type="text"/>
    </div>
</template>
<!-- Uses: @focus event will bind to internal input element -->
<custom-input @focus="onFocus"></custom-input>
```

* * *

#### 6. 为什么你不能从插槽中 v-on 或 emit

我经常看到一些开发者试图从插槽中发出事件或者在一个插槽中监听事件。

组件 `slot` 由调用父组件提供。这意味着所有事件都应与调用组件关联。试图监听这些变化意味着你的父组件和子组件是紧密耦合的，还有另外一个方法可以做到这一点，[Evan You](https://medium.com/@youyuxi) 解释得很漂亮：

- [**Is it possible to emit event from component inside slot · Issue #4332 · vuejs/vue**](https://github.com/vuejs/vue/issues/4332#issuecomment-263444492 "https://github.com/vuejs/vue/issues/4332#issuecomment-263444492")

- [**Suggestion: v-on on slots · Issue #4781 · vuejs/vue**](https://github.com/vuejs/vue/issues/4781 "https://github.com/vuejs/vue/issues/4781")

* * *

#### 7. 插槽中的插槽（读取后代插槽）

在某些时候，你会遇到这种情况。想象一下，你有一个组件，比如 A，接受一些插槽。遵循组合原则，你会使用组件 **A** 创建另一个组件 **B**。现在你获取组件 **B** 并在组件 **C** 中使用它。

> 问题是 — 如何将组件 **C** 中的插槽传递给 **A**？

**这个问题的答案取决于你使用的是什么？** 如果你使用渲染函数，那么它非常简单。组件 B 的渲染函数将是：

```
// Render function for component B
function render(h) {
    return h('component-a', {
        // Passing slots as they are to component A
        scopedSlot: this.$scopedSlots
    }
}
```

但是，如果你使用基于模板的渲染函数，那么你就不走运了。幸运的是，这个问题正在取得进展，我们可能会为基于模板的组件提供一些东西：

- [**feat(core): support passing down scopedSlots with v-bind by yyx990803 · Pull Request #7765 ·…**](https://github.com/vuejs/vue/pull/7765 "https://github.com/vuejs/vue/pull/7765")

* * *

希望这篇文章能够深入了解 Vue.js 的设计要点和在 Vue.js 中使用高级场景的提示/技巧。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
