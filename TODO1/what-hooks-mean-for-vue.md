> * 原文地址：[What Hooks Mean for Vue](https://css-tricks.com/what-hooks-mean-for-vue/)
> * 原文作者：[Sarah Drasner](https://css-tricks.com/author/sdrasner/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/what-hooks-mean-for-vue.md](https://github.com/xitu/gold-miner/blob/master/TODO1/what-hooks-mean-for-vue.md)
> * 译者：[Ivocin](https://github.com/Ivocin)
> * 校对者：[LeoYang](https://github.com/LeoooY), [TUARAN](https://github.com/TUARAN)

# Hooks 对 Vue 而言意味着什么

不要把 Hooks 和 Vue 的[生命周期钩子（Lifecycle Hooks）](https://css-tricks.com/intro-to-vue-3-vue-cli-lifecycle-hooks/#article-header-id-1) 弄混了，[Hooks](https://reactjs.org/docs/hooks-intro.html) 是 React 在 V16.7.0-alpha 版本中引入的，而且几天后 Vue 发布了其概念验证版本。虽然 Hooks 是由 React 提出的，它是一个对各 JavaScript 框架生态系统都有价值的、重要的组合机制，因此我们今天会花一点时间讨论 Hooks 意味着什么。

Hooks 主要是对模式的复用提供了一种更明确的思路 —— 避免重写组件本身，并允许有状态逻辑的不同部分能无缝地进行协同工作。

### 最初的问题

就 React 而言，问题在于：在表达状态的概念时，类是最常见的组件形式。无状态函数式组件也非常受欢迎，但由于它们只能单纯地渲染，所以它们的用途仅限于展示任务。

类本身存在一些问题。例如，随着 React 变得越来越流行，类的问题也普遍成为新手的阻碍。开发者为了理解 React，也必须理解类。绑定使得代码冗长且可读性差，并且需要理解 JavaScript 中的 `this`。[这里](https://reactjs.org/docs/hooks-intro.html#classes-confuse-both-people-and-machines)还讨论了使用类所带来的一些优化障碍。

在逻辑复用方面，我们通常使用 render props 和高阶组件等模式。但使用这些模式后会发现自己处于类似的[“厄运金字塔”](https://en.wikipedia.org/wiki/Pyramid_of_doom_(programming))中 —— 样式实现地狱，即过度使用嵌套可能会导致组件难以维护。这导致我想对 Dan Abramov 像喝醉了一样大吼大叫，没有人想要那样。

Hooks 允许我们使用函数调用来定义组件的有状态逻辑，从而解决这些问题。这些函数调用变得更具有组合性、可复用性，并且允许我们在使用函数式组件的同时能够访问和维护状态。React 发布 Hooks 时，人们很兴奋 —— 下面你可以看到 Hooks 展示的一些优势，关于它们如何减少代码和重复：

> 将 [@dan_abramov](https://twitter.com/dan_abramov?ref_src=twsrc%5Etfw) 的代码（来自 [#ReactConf2018](https://twitter.com/hashtag/ReactConf2018?src=hash&ref_src=twsrc%5Etfw)）可视化，你能看到 React Hooks 为我们带来的好处。[pic.twitter.com/dKyOQsG0Gd](https://t.co/dKyOQsG0Gd)
> 
> — Pavel Prichodko (@prchdk) [2018 年 10 月 29 日](https://twitter.com/prchdk/status/1056960391543062528?ref_src=twsrc%5Etfw)

在维护方面，简单性是关键，Hooks 提供了一种单一的、函数式的方式来实现逻辑共享，并且可能代码量更小。

### 为什么 Vue 中需要 Hooks？

读到这里你肯定想知道 Hooks 在 Vue 中必须提供什么。这似乎是一个不需要解决的问题。毕竟，类并不是 Vue 主要使用的模式。Vue 提供无状态函数式组件（如果需要它们），但为什么我们需要在函数式组件中携带状态呢？[我们有 mixins](https://css-tricks.com/using-mixins-vue-js/) 用于组合可以在多个组件复用的相同逻辑。问题解决了。

我想到了同样的事情，但在与 Evan You 交谈后，他指出了我忽略的一个主要用例：mixins 不能相互消费和使用状态，但 Hooks 可以。这意味着如果我们需要链式封装逻辑，可以使用 Hooks。

Hooks 实现了 mixins 的功能，但避免了 mixins 带来的两个主要问题：

*   允许相互传递状态。
*   明确指出逻辑来自哪里。

如果使用多个 mixins，我们不清楚哪个属性是由哪个 mixins 提供的。使用 Hooks，函数的返回值会记录消费的值。

那么，这在 Vue 中如何运行呢？我们之前提到过，在使用 Hooks 时，逻辑在函数调用时表达从而可复用。在 Vue 中，这意味着我们可以将数据调用、方法调用或计算属性调用封装到另一个自定义函数中，并使它们可以自由组合。数据、方法和计算属性现在可用于函数式组件了。

### 例子

让我们来看一个非常简单的 hook，以便我们在继续学习 Hooks 中的组合例子之前理解构建块。

#### useWat?

好的，Vue Hooks 和 React Hooks 之间存在交叉部分。使用 `use` 作为前缀是 React 的约定，所以如果你在 React 中查找 Hooks，你会发现 Hooks 的名称都会像 `useState`、`useEffect` 等。[更多信息可以查看这里。](https://reactjs.org/docs/hooks-overview.html#-state-hook)

在 [Evan 的在线 demo 里](https://codesandbox.io/s/jpqo566289)，你可以看到他在何处访问 `useState` 和 `useEffect` 并用于 render 函数。

如果你不熟悉 Vue 中的 render 函数，那么看一看[官网文档](https://vuejs.org/v2/guide/render-function.html)可能会有所帮助。

但是当我们使用 Vue 风格的 Hooks 时，我们会如何命名呢 —— 你猜对了 —— 比如：`useData`，`useComputed`等。

因此，为了让我们看看如何在 Vue 中使用 Hooks，我创建了一个示例应用程序供我们探索。

详见视频演示：https://css-tricks.com/wp-content/uploads/2019/01/hooks-demo-shorter.mp4

[演示网站](https://sdras.github.io/vue-hooks-foodapp/)

[GitHub 仓库](https://github.com/sdras/vue-hooks-foodapp)

在 src/hooks 文件夹中，我创建了一个 hook，它在 `useMounted` hook 上阻止了滚动，并在 `useDestroyed` 上重新启用滚动。这有助于我在打开查看内容的对话框时暂停页面滚动，并在查看对话框结束时再次允许滚动。这是一个好的抽象功能，因为它在整个应用程序中可能会多次使用。

```
import { useDestroyed, useMounted } from "vue-hooks";

export function preventscroll() {
  const preventDefault = (e) => {
    e = e || window.event;
    if (e.preventDefault)
      e.preventDefault();
    e.returnValue = false;
  }

  // keycodes for left, up, right, down
  const keys = { 37: 1, 38: 1, 39: 1, 40: 1 };

  const preventDefaultForScrollKeys = (e) => {
    if (keys[e.keyCode]) {
      preventDefault(e);
      return false;
    }
  }

  useMounted(() => {
    if (window.addEventListener) // older FF
      window.addEventListener('DOMMouseScroll', preventDefault, false);
    window.onwheel = preventDefault; // modern standard
    window.onmousewheel = document.onmousewheel = preventDefault; // older browsers, IE
    window.touchmove = preventDefault; // mobile
    window.touchstart = preventDefault; // mobile
    document.onkeydown = preventDefaultForScrollKeys;
  });

  useDestroyed(() => {
    if (window.removeEventListener)
      window.removeEventListener('DOMMouseScroll', preventDefault, false);

    //firefox
    window.addEventListener('DOMMouseScroll', (e) => {
      e.stopPropagation();
    }, true);

    window.onmousewheel = document.onmousewheel = null;
    window.onwheel = null;
    window.touchmove = null;
    window.touchstart = null;
    document.onkeydown = null;
  });
} 
```

然后我们可以在像 AppDetails.vue 一样的 Vue 组件中调用它：

```
<script>
import { preventscroll } from "./../hooks/preventscroll.js";
...

export default {
  ...
  hooks() {
    preventscroll();
  }
}
</script>
```

我们不仅可以在该组件中使用它，还可以在整个应用程序中使用相同的功能！

#### 能够相互理解的两个 Hooks

我们之前提到过，Hooks 和 mixins 之间的主要区别之一是 Hooks 实际上可以互相传值。让我们看一下这个简单但有点不自然的例子。

在我们的应用程序中，我们需要在一个可复用的 hook 中进行计算，还有一些需要使用该计算结果的东西。在我们的例子中，我们有一个 hook，它获取窗口宽度并将其传递给动画，让它知道只有当我们在更大的屏幕上时才会触发。

详见视频演示：https://css-tricks.com/wp-content/uploads/2019/01/hook-logo.mp4

第一个 hook:

```
import { useData, useMounted } from 'vue-hooks';

export function windowwidth() {
  const data = useData({
    width: 0
  })

  useMounted(() => {
    data.width = window.innerWidth
  })

  // this is something we can consume with the other hook
  return {
    data
  }
}
```

然后，在第二个 hook 中，我们使用它来创建一个触发动画逻辑的条件：

```
// the data comes from the other hook
export function logolettering(data) {
  useMounted(function () {
    // this is the width that we stored in data from the previous hook
    if (data.data.width > 1200) {
      // we can use refs if they are called in the useMounted hook
      const logoname = this.$refs.logoname;
      Splitting({ target: logoname, by: "chars" });

      TweenMax.staggerFromTo(".char", 5,
        {
          opacity: 0,
          transformOrigin: "50% 50% -30px",
          cycle: {
            color: ["red", "purple", "teal"],
            rotationY(i) {
              return i * 50
            }
          }
        },
        ...
```

然后，在组件内部，我们将一个 hook 作为参数传递给另一个 hook：

```
<script>
import { logolettering } from "./../hooks/logolettering.js";
import { windowwidth } from "./../hooks/windowwidth.js";

export default {
  hooks() {
    logolettering(windowwidth());
  }
};
</script>
```

现在我们可以在整个应用程序中使用 Hooks 来编写逻辑！再提一下，这是一个用于演示目的不太自然的例子，但你可以看到这对于大型应用程序，将逻辑保存在较小的、可复用的函数中是有效的。

### 未来的计划

**Vue Hooks 现在已经可以与 Vue 2.x 一起使用了，但仍然是实验性的**。我们计划将 Hooks 集成到 Vue 3 中，但在我们自己的实现中可能会偏离 React 的 API。我们发现 React Hooks 非常鼓舞人心，正在考虑如何向 Vue 开发人员介绍其优势。我们想以一种符合 Vue 习惯用法的方式来做，所以还有很多实验要做。

你可以查看[这个仓库](https://github.com/yyx990803/vue-hooks)作为起步。Hooks 可能会成为 mixins 的替代品，所以虽然这个功能还处于早期阶段，但是一个在此期间探索其概念是有好处的。

**（真诚地感谢 Evan You 和 Dan Abramov 为本文审阅。）**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
