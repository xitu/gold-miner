> * 原文地址：[What’s new in Vue Devtools 4.0](https://medium.com/the-vue-point/whats-new-in-vue-devtools-4-0-9361e75e05d0)
> * 原文作者：[Guillaume CHAU](https://medium.com/@Akryum?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/whats-new-in-vue-devtools-4-0.md](https://github.com/xitu/gold-miner/blob/master/TODO/whats-new-in-vue-devtools-4-0.md)
> * 译者：[MechanicianW](https://github.com/MechanicianW)
> * 校对者：[okaychen](https://github.com/okaychen) [FateZeros](https://github.com/FateZeros)

# Vue Devtools 4.0 有哪些新内容

几天前，Vue devtools 发布了重大更新。让我们来看看有哪些新特性与改进！🎄（译者注： 以下视频源都是 youtube，需自备梯子）

### 可编辑的组件 data

现在可以直接在组件检查面板中修改组件的 data 了。

1. 选中一个组件
2. 在检查器的 `data` 部分下，将鼠标移到你要修改的字段上
3. 点击铅笔图标
4. 通过点击完成图标或者敲击回车键来提交你的改动。也可以通过敲击 ESC 键来取消编辑

<iframe width="700" height="525" src="https://www.youtube.com/embed/xeBRtXLrQYA" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

字段内容会被序列化为 JSON 。举个例子，如果你想输入一个字符串，则打字输入带双引号的 `"hello"`。数组则应该像 `[1, 2, "bar"]` ，对象则为 `{ "a": 1, "b": "foo" }` 。

目前可以编辑以下几种类型的值：

* `null` 和 `undefined`
* `String`
* 字面量： `Boolean` , `Number` , `Infinity` , `-Infinity` 和 `NaN`
* Arrays
* Plain objects

对于 Arrays 和 Plain objects，可以通过专用图标来增删项。也可以重命名对象的 key 名。

<iframe width="700" height="525" src="https://www.youtube.com/embed/fx1zjvHryJ0" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

如果输入的不是有效的 JSON 则会显示一条警告信息。然而，为了更方便，一些像 `undefined` 或者 `NaN` 的值是可以直接输入的。

未来的新版本会支持更多类型的！

#### 快速编辑

通过 “快速编辑” 功能可以实现仅仅鼠标单击一下，就可以编辑一些类型的值了。

布尔值可以直接通过复选框进行切换：

<iframe width="700" height="525" src="https://www.youtube.com/embed/llNJapRZaHo" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

数值可以通过加号和减号图标进行增减：

<iframe width="700" height="525" src="https://www.youtube.com/embed/ZCToaOpId0w" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

使用键盘的修改键去进行增减会更快一些。

### 在编辑器中打开一个组件

如果项目中使用了 vue-loader 或 Nuxt 的话，现在你就可以在你最喜欢的编辑器里打开选定的组件（只要它是单文件组件）。

1. 按这份 [设置指南](https://github.com/vuejs/vue-devtools/blob/master/docs/open-in-editor.md) 操作 （如果你使用的是 Nuxt，就什么都不用做）
2. 在组件检查器中，将鼠标移动到组件名上 —— 你会看到一个显示文件路径的提示框
3. 单击组件名就会直接在编辑器中打开该组件了

<iframe width="700" height="525" src="https://www.youtube.com/embed/XBKStgyhY18" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

### 显示原始的组件名

这一功能由 [manico](https://github.com/manico) 提出的 PR 实现

默认情况下，组件名都会被格式化为驼峰形式。你可以通过切换组件标签下的 "Format component names" 按钮来禁用这一功能。这个设置将被记住，它也将被应用到 Events 标签页中。

<iframe width="700" height="393" src="https://www.youtube.com/embed/PoZmEcCdSbU" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

### 检查组件更容易

在 Vue devtools 开启的情况下，可以右键单击一个组件进行检查：

![](https://cdn-images-1.medium.com/max/800/1*8fhP5VTb6uev-8HfI4stYw.png)

在页面中右键单击一个组件

也可以通过特殊的方法 `$inspect` 以编程的方式来检查组件：

```
<template>
  <div>
    <button @click="inspect">Inspect me!</button>
  </div>
</template>

<script>
export default {
  methods: {
    inspect () {
      this.$inspect()
    }
  }
}
</script>
```

在组件中使用 `$inspect` 方法。

无论以哪种方式进行，组件树都会自动扩展到新选择的组件。

### 按组件过滤事件

这一功能由 [eigan](https://github.com/eigan) 提出的 PR 实现

现在你可以按发出事件的组件来过滤历史事件了。输入 `<` 符号，后面跟着组件全名或组件名的一部分：

<iframe width="700" height="393" src="https://www.youtube.com/embed/wytquoUPSFo" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

### Vuex 检查器过滤功能

这一功能由 [bartlomieju](https://github.com/bartlomieju) 提出的 PR 实现

Vuex 检查器的输入框现在有了过滤功能：

<iframe width="700" height="393" src="https://www.youtube.com/embed/T095k5hI_pA" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

### 垂直布局

这一功能由 [crswll](https://github.com/crswll) 提出的 PR 实现

devtools 不够宽时，将切换到更方便使用的垂直布局。你可以像水平模式下一样，移动上下窗格间的分隔线。

<iframe width="700" height="525" src="https://www.youtube.com/embed/33tJ_md8bX8" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

### 滚动到组件功能改进

默认情况下，点击组件将不再自动滚动到该组件的视图部分。相反，你需要点击新的 "Scroll into view" 图标才能滚动到该组件：

![](https://cdn-images-1.medium.com/max/800/1*TJEfzB4ifK8t-5kpbZieRw.png)

点击眼睛图标来滚动到组件。

视图将滚动到组件居中于屏幕的位置。

### 可折叠的检查器

现在不同检查器的各部分是可以被折叠的。你可以用键盘修改键来将它们都折叠，或者通过鼠标单击将它们都展开。假设你只专注于 Vuex 标签页的 mutations 详情的话，这就是一个非常有用的功能。

<iframe width="700" height="393" src="https://www.youtube.com/embed/bblGueKPsjE" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

### 以及更多

* 如果运行环境不支持这一功能的话，"Inspect DOM" 按钮会被隐藏。 —— by [michalsnik](https://github.com/michalsnik)
* 支持 `-Infinity` —— by [David-Desmaisons](https://github.com/David-Desmaisons)
* 事件钩子的 issue 修复 —— [maxushuang](https://github.com/maxushuang)
* 代码清理 —— by [anteriovieira](https://github.com/anteriovieira)
* 改进了对 Date， RegExp， Component 的支持 （现在这些类型也可以进行时间旅行了）
* devtools 现在使用 [v-tooltip](https://github.com/Akryum/v-tooltip) 实现更丰富的信息提示与弹出功能

如果你已经安装了扩展，扩展应用将自动更新到 `4.0.1` 版本。你也可以在 [Chrome](https://chrome.google.com/webstore/detail/vuejs-devtools/nhdogjmejiglipccpnnnanhbledajbpd) 和 [Firefox](https://addons.mozilla.org/fr/firefox/addon/vue-js-devtools/) 上安装。

**感谢所有的贡献者们！是你们使得本次更新成为可能！**
如果你发现任何问题或是有新的功能建议，[请分享出来](https://new-issue.vuejs.org/?repo=vuejs/vue-devtools)！
* * *

### 接下来会有什么大动作？

具有更多功能特性的新版本即将发布，如在页面中直接选中组件（选色板风格）和一些 UI 改进。

我们也有一些仍在进行中的工作，比如允许在任意环境（不仅仅是 Chrome 和 Firefox）进行 debug 的独立 Vue devtools app，全新的路由标签页，以及对 `Set` 和 `Map` 类型支持的改进。

敬请关注！


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
