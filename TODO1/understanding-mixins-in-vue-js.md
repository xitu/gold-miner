> - 原文地址：[Understanding Mixins in Vue JS](https://blog.bitsrc.io/understanding-mixins-in-vue-js-bdcf9e02a7c1)
> - 原文作者：[Nwose Lotanna](https://medium.com/@viclotana)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-mixins-in-vue-js.md](https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-mixins-in-vue-js.md)
> - 译者：[MacTavish Lee](https://github.com/Reaper622)
> - 校对者：[Baddyo](https://github.com/Baddyo), [jilanlan](https://github.com/jilanlan)

# 理解 Vue.js 中的 Mixins

本文是针对 Vue 中的 Mixins 的实用性介绍，探讨了 Mixins 为何重要，以及如何在工作流中使用。

![Photo by [Augustine Fou](https://unsplash.com/@augustinefou?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/12000/0*gtfwEvDVwDgHMv7L)

## 什么是 Mixins？

Vue JS 中的 Mixins 基本上是定义一大堆逻辑的地方，它们以 Vue 规定的特殊方式存储，它们可以反复使用来为 Vue 实例和组件添加功能。因此，Vue mixins 可以在多个 Vue 组件之间共享，而不需要重复写代码块。如果你之前用过 Sass 这个 CSS 预处理器，那么你会对 mixins 有很好的理解。

## 写在开始前

这篇文章更适合于使用 Vue JS 开发的中级前端工程师，因此你需要先熟悉基础概念以及安装过程。在开始使用 Vue CLI 3 之前，已经掌握了这些预备知识。

你需要：

- 安装了 Node.js 10.x 或者更高的版本。你可以在你的终端运行 node -v 来校验你的版本。
- 已经安装了 Node Package Manager 6.7 或者更高的版本（NPM）。
- 一个代码编辑器：高度推荐 Visual Studio Code。 ([推荐理由](https://blog.bitsrc.io/a-convincing-case-for-visual-studio-code-c5bcc18e1693?source=your_stories_page---------------------------))
- 在你的设备上全局安装了 Vue 的最新版本。
- 在你的设备上安装了 Vue CLI 3.0。在安装 3.0，先卸载旧版本的 CLI 工具：

```
npm uninstall -g vue-cli
```

之后安装新的版本：

```
npm install -g @vue/cli
```

或者

- 在这里下载一个 Vue 的启动项目：

[**viclotana/vue-canvas**: 一个经过优化、开箱即用的 Vue 应用、配备了默认的 Babel 和 ESlint 的配置](https://github.com/viclotana/vue-canvas)

- 解压下载的项目
- 进入到解压后的文件之后运行下面的命令来保证所有的依赖都是最新的：

```
npm install
```

## 为什么 Mixins 是重要的

1. 使用 Vue mixins， 你可以轻松地在编程中遵循 DRY 原则(译者注: Don't Repeat Yourself)，它会确保你不会重复自己的代码。
2. 使用 Vue mixins，你也可以变得十分的灵活，一个 mixins 对象包含有 Vue 组件的选项，所以我们可以将 mixin 与 组件混合使用。
3. Vue mixins 也是很安全的，如果你的写法恰当，那么它们是不会对超出定义范围的变更产生影响的。
4. 它们是很棒的代码复用平台。

> Mixins 能够灵活地实现为 Vue 组件分发可复用功能。 — 官方文档

## Mixins 帮助我们解决了什么问题

想要充分理解 Vue 中 mixins 的重要性，有一个方式：看看在实际开发中遇到的重用问题。如果你有两个组件，二者中各有一个目的一致或功能相同的方法，就像在下面这个简单的示例中：

进入的你的项目文件夹之后到 src 文件夹创建一个名为 components 的目录，并在其中创建两个组件：Test.vue 和 Modal.vue。复制下面的代码到你的组件中。

```Vue
// Component 1
// src/components/Test.vue
<template>
  <div>
    <button v-on:click="clicked('you just clicked on button  1')">
      Button 1
    </button>
  </div>
</template>;
export default {
  name: "Test",
  methods: {
    clicked(value) {
      alert(value);
    }
  }
};
```

上面的组件展示了一个按钮，点击它会弹出一个警告框。第二个组件会做确切相同的功能：

```Vue
// Component 2
// src/components/Modal.vue
<template>
  <div>
    <button v-on:click="clicked('you just clicked on button  2')">
      Button 2
    </button>
  </div>
</template>;

export default {
  name: "Modal",
  methods: {
    clicked(value) {
      alert(value);
    }
  }
};
```

你的 App.vue 文件应该引入和声明两个组件，如下所示：

```Vue
<template>
  <div id="app">
    <img alt="Vue logo" src="./assets/logo.png">
    <Test />
    <modal />
  </div>
</template>;
<script>
import Test from "./components/Test.vue";
import Modal from "./components/Modal.vue";
export default {
  name: "app",
  components: {
    Test,
    Modal
  }
};
</script>
```

至此你可以很清楚地看到，两个组件中的点击方法的代码是重复的，并且不完美之处在于这样会浪费内存资源，同时也违反了 DRY 的原则。

## 介绍 Vue Mixins

Vue 的团队现在已经将 mixins 作为这个问题的一个非常好的解决方案，通过 mixins 你可以封装一部分的代码或者功能，然后你可以在需要时将其引入各种组件。

## Mixin 语法

从定义到使用 Vue Mixin 的方式如下：

```Vue
// 定义一个 mixin 对象
var myMixin = {
  created: function() {
    this.hello();
  },
  methods: {
    hello: function() {
      console.log("hello from mixin!");
    }
  }
};
// 定义一个组件来使用这个 mixin
var Component = Vue.extend({
  mixins: [myMixin]
});
var component = new Component(); // => "hello from mixin!"
```

## Demo

现在你可以用 Vue mixins 重构上文中用来例证复用问题的两个组件。在一个 Vue 应用中使用 mixins，要经过四个步骤：

- 撞见混入文件。
- 在需要的组件中引入 mixin 文件。
- 在组件中移除重复的逻辑。
- 注册 mixin。

### 创建 mixin 文件

一个 mixin 文件是一个可导出的 JavaScript 文件，它内部定义了需要在所需的 Vue 组件中导入和重用的代码块和功能块。对于像我这种很喜欢让编程非常模块化的开发者，可以在 src 文件夹中创建一个 Mixins 文件夹之后在内部创建一个 clickMixin.js 文件。在新创建的文件中复制下面的代码：

```JavaScript
// src/mixins/clickMixin.js
export default {
  methods: {
    clicked(value) {
      alert(value);
    }
  }
};
```

这就是一个 mixin 文件，其中包含了实现弹出警告框的简单的点击方法。 它也可以是任何逻辑，也可以有数据选项，计算属性和 Vue 组件可以拥有的任何东西。它的可能性仅局限于你的想象力和开发人员的用例。

### 在组件中导入 mixin 文件

现在一个 mixin 已经被创建了，下一步就是在需要它的组件 —— 需要弹出警告框功能的组件 —— 中注入它。在我们上面的演示中，要插入 mixin 之处就是在文章开头创建的两个组件内部。用下面的代码在两个组件中引入 clickMixin。

```
import clickMixin from ‘../Mixins/clickMixin’
```

### 去除重复的逻辑

在引入了 mixin 后，你要移除即将被 mixin 替代的逻辑代码。在我们的例子中，这意味着你会在两个组件中删除方法的创建逻辑。

```
// 去掉这部分代码块以及它前面的逗号。

methods: {

 clicked(value){

  alert(value);

  }

}
```

### 注册 mixin

这步操作就是你告诉 Vue 应用你要导入 mixin，它会将其中的逻辑视为统一的并执行一些复杂的操作来保证应用的修复功能和方法在组件的适当位置调用。默认情况下，Vue 中的 Mixins 会以数组的形式被注册，如下所示：

```Vue
<script>
import clickMixin from '../Mixins/clickMixin'
export default {
 name: 'Test',
 mixins: [clickMixin]
}
</script>
```

如果你从一开始就跟着我说的写，那么你的应用组件应该像下面这样：

**Test.vue**

```Vue
<template>
  <div>
    <button v-on:click="clicked('you just clicked on button 1')">
      Button 1
    </button>
  </div>
</template>;
<script>
import clickMixin from "../Mixins/clickMixin";
export default {
  name: "Test",
  mixins: [clickMixin]
};
</script>
```

**Modal.vue**

```Vue
<template>
  <div>
    <button v-on:click="clicked('you just clicked on button 2')">
      Button 2
    </button>
  </div>
</template>;
<script>
import clickMixin from "../Mixins/clickMixin";
export default {
  name: "Modal",
  mixins: [clickMixin]
};
</script>
```

**App.vue**

```Vue
<template>
  <div id="app">
    <img alt="Vue logo" src="./assets/logo.png" />
    <Test msg="Welcome to Your Vue.js App" />
    <modal />
  </div>
</template>;
<script>
import Test from "./components/Test.vue";
import Modal from "./components/Modal.vue";
export default {
  name: "app",
  components: {
    Test,
    Modal
  }
};
</script>
<style>
#app {
font-family: 'Avenir', Helvetica, Arial, sans-serif;
-webkit-font-smoothing: antialiased;
-moz-osx-font-smoothing: grayscale;
text-align: center;
color: #2c3e50;
margin-top: 60px;
}
button {
background-color: #10776e; /* Green */
border: none;
margin: 5px;
color: white;
padding: 15px 32px;
text-align: center;
text-decoration: none;
display: inline-block;
font-size: 16px;
}
</style>

```

## Mixins 的类型

在 Vue 中 mixins 有两种类型：

1. **局部 Mixins：** 这就是我们在这篇文章中所处理的类型。它的范围仅局限于导入和注册的组件。局部 mixin 的影响范围由引入它的组件所决定。
2. **全局 Mixins：** 这是一种不同的 mixin，无论在任何 Vue 项目中，它是定义在 Main.js 文件中的。它会影响一个应用中的所有组件，所以 Vue 的开发团队建议要谨慎使用。一个全局 mixin 的定义看起来就像这样：

```JavaScript
Vue.mixin({
  mounted() {
    console.log("hello world!");
  }
});

```

## 特别注明

在 Vue 应用中的事务层结构中，组件内部应默认优先应用 mixins。组件的应用顺序次之，这样它可以在任意情况下重写覆盖 mixin。因此务必谨记，当出现某种权限冲突时，Vue 组件拥有有最终的解释和覆盖权。

## 总结

通过一个简单的示例，本文介绍了 Vue mixin 的概念、类型和使用方法。同样重要的是要坚持使用局部 mixins，并且只在一些极少的必须用到的情况下使用全局 mixins。编码愉快！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
