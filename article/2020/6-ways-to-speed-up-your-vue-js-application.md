> * 原文地址：[6 Ways to Speed Up Your Vue.js Application](https://medium.com/better-programming/6-ways-to-speed-up-your-vue-js-application-2673a6f1cde4)
> * 原文作者：[Aris Pattakos](https://medium.com/@aris.pattakos)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/6-ways-to-speed-up-your-vue-js-application.md](https://github.com/xitu/gold-miner/blob/master/article/2020/6-ways-to-speed-up-your-vue-js-application.md)
> * 译者：[黄梵高](https://github.com/MangoTsing)
> * 校对者：

# 加速 Vue.js 应用的六种绝技

![](https://cdn-images-1.medium.com/max/2400/1*aW-r70mA9ByajQQfiFh5hQ.png)

如果你曾经使用过谷歌的 Pagespeed Insights 或者 Google Lighthouse，那你肯定会看到如下图的网页性能评估：

![](https://cdn-images-1.medium.com/max/2000/1*UzMBfW8YlXv39Mc9vfKt6Q.png)

你会收到一组统计数据，还有一些对于你的网站究竟是快还是慢的诊断。

有些诊断非常实用，可以指出一些简单的修改意见，未使用的文件，以及速度过慢或资源过大的一些请求。

至于其他的诊断，比如主线程的一些运行和 JavaScript 执行代码所消耗的时间过长，这会提示可能存在的问题，但这些并不能真正的帮助你去修复它。

在本文中，你可以通过遵循下面这些步骤，确保你的 Vue 应用尽可能快的运行。并且通过这些步骤，也可以准确知道那里需要修复，而不用仅仅靠猜。

## 1. 只更新需要更新的内容

当使用 VueJS 时可能会遇到最麻烦的问题之一就是，渲染相同的元素或元素列表的次数，超过预计的次数。为了理解为什么会发生这样的事情，我们不得不先理解一下 Vue 中的响应式对象。

下面这个例子出自 Vue.js 官方文档，并且它显示了哪些属性是具有响应性，哪些属性不具有。Vue 中有许多的响应式元素：分配给 data 对象的属性，计算属性，以及依赖于响应式 methods 中的方法。

```JavaScript
var vm = new Vue({
  data: {
    a: 1
  }
})
// `vm.a` 现在是响应式的了

vm.b = 2
// `vm.b` 并不是响应式
```

但是一段普通的 JavaScript 代码，例如 `{{ 'value' }}` 或 `{{ new Date() }}`，是不会被作为响应式属性被监测。

那么响应式对象是怎么样去进行重复渲染的呢？

让我们假设在你的 `data` 对象中，你有一个类似以下对象的数组：

```
values: [{id: 1, t: 'a'}, {id: 2, t: 'b'}]
```

并且你使用 `v-for` 命令来渲染它：

```vue
<div v-for="value in values" :key="value.id">{{ value.t }}</div>
```

当一个新的元素被添加到这个列表中，Vue 将会重新渲染整个列表。难以置信吗？试一试就知道了：

```vue
<div v-for="value in values" :key="value.id">
  {{ value.t }}
  {{ new Date() }}
</div>
```

因为 JavaScript 的 `Date` 对象并不是响应式的，因此它不会影响渲染。只有在必须再次渲染的时候才会调用它。在这个例子中你可以看到，每次在 `values` 中添加或删除值时，所有渲染完成的元素上都会弹出一个新的日期。

在这个优化后的页面里你期待看到的结果是什么？你应该只希望新的或者发生变化的元素展示一个新的 `Date`，而不是重新渲染所有元素。

所以，`key` 是做什么的？我们为什么要传这个值？其实 `key` 这个属性可以帮助 Vue 理解哪个元素的唯一标识。如果数组的顺序发生变化，`key` 可以帮助 Vue 将元素无序的排列到适当的位置，而不是重复逐个去遍历。

指定一个 `key` 很重要，但这还不够。为了确保能获得最佳的性能，你还需要创建一个 `Child` 组件。没错，解决办法很简单，你需要把你的 Vue 应用分成几个小组件。

```vue
<item :itemValue="value" v-for="item in items" :key="item.id"></item>
```

item 组件只会在具有明确的响应式数据变化时更新（举个例子 [Vue.set](https://vuejs.org/v2/api/#Vue-set)）

使用组件来渲染列表可以让性能得到巨大提升。如果从数组中添加或删除元素，Vue 将不会再次逐个渲染所有的组件。如果这个数组重新排序，Vue 只需要根据元素依赖的 `key` 来重新排序并渲染。

如果是轻量级的组件，你还可以做另一个优化。可以传入一个私有属性（字符串或数字）类似 `value.t`，而不是传入一个完整的对象类似 `value`。这么做的话，只有当传入的值发生更改时，`<item>` 组件才会被重新渲染。这一点也告诉我们，即使我们不需要更新，但响应式对象发生变化也会导致重复渲染。

## 2. 消除重复渲染

渲染完整的列表或复杂的元素时，超过预计渲染次数是一个很难发现的问题，但它非常容易发生。

让我们假设一个组件在它的 data 对象内有一个 `entities` 属性。

如果你按照上面的步骤进行，那大概会有一个子组件来渲染每一块内容。

```vue
<entity :entity="entity" v-for="entity in entities" :key="entity.id" />
```

这个 entity 组件的模版如下所示：

```Vue
<template>
  <div>
    <div>{{ user.status }}</div>
    <div>{{ entity.value }}</div>
  </div>
</template>
```

它输出 `entity.value`，同时也使用了来自 `vuex` 中 state 的 `user` 对象。现在我们假设有一个 `auth` 方法可以刷新用户的 token，或者有任意的方式导致全局的 user 对象属性发生了改变。这将导致整个 entire 的视图每当 user 对象发生改变都会重新渲染，即使 `user.status` 保持不变！

有几种方法可以解决这个问题。一种简单的办法就是将 `user.status` 的值作为父组件一个 `userStatus` 属性传进来。如果这个值保持不变，那么 Vue 就不会也没必要将它重复渲染。

这里的关键是要注意渲染的依赖关系。更改任何 prop 属性，data 中的值，或者计算属性的值都有可能会造成重复渲染。

那我们怎么样才能识别出来重复渲染呢？

首先让我们下载官方的 [Vue.js dev tools](https://chrome.google.com/webstore/detail/vuejs-devtools/nhdogjmejiglipccpnnnanhbledajbpd?hl=en)!

然后进入 Performance 选项来测试你 Vue 应用的性能。按下 start 和 stop 运行性能检查，当然最好是在这个 app 加载的期间。

![Vue.js dev tools 截图](https://cdn-images-1.medium.com/max/3710/1*uRo4r7Rbncqnrx8dbhVCtw.png)

然后我们前往 Component Render 选项。如果你的页面渲染了 100 个组件，那你应该看见 100 个 `created` 事件。

这里需要注意的是 `updated` 事件。如果 `updated` 事件超过 `created` 事件，但实际上值并没有更新，那有可能存在重复的数据更改，导致重复渲染。

如果代码多次更改 `entities` 的值而不是批处理更新，则很有可能出现这个问题。或者，如果你在使用某种实时数据库，类似 Firestore，并且你每次获得的快照都比预期的多，也有可能会出现这个问题。（Firestore 可以在每次更新时发送许多快照，特别是当你设置了频繁更新相关文本的 Firestore 触发器时）

这个问题的解决方案是避免更改内容的次数，超过必要的次数。对于 Firestore 快照，你可以使用节流或者防抖函数去别面过于频繁的更改 `entities` 对象的属性。

## 3. 优化事件监听

并非所有的事件生而平等，因此你不得不确认是否合理优化了每一个事件。

有两个很好的例子是 `@mouseover` 和 `window.scroll` 事件。这两种类型事件即使在正常情况下也会多次触发。如果你的事件监听函数进行了很复杂的计算，这些计算每一秒都会运行很多次，结果就是导致应用程序出现延迟。解决方案之一就是使用防抖函数来限制这些事件的处理次数。

## 4. 删除或减少过慢的组件

当你自己创建新的组件，尤其是引入第三方组件时，你需要确认他们的性能良好。

你可以进入并使用 Vue.js 开发工具的 performance 选项来预估每个组件的渲染时间。当增加一个新组件时，可以看到与自己的组件相比，渲染所需要的时间。

如果这个新组件花费的时间比你自己的组件更长，那你可能需要去查找一些其他的组件，删除这个组件，或者尝试减少使用这个组件。

![](https://cdn-images-1.medium.com/max/2000/1*SLEt6zuG1eYEhKfq9Fxw4A.png)

## 5. 只渲染一次

![](https://cdn-images-1.medium.com/max/2000/1*6PL_PU-Dg-UHrIPZutTLfw.png)

这是 Vue.js 的官方文档。如果你有一个元素希望每次组件触发 mounted 后只会被渲染一次，那么你可以使用 v-once 命令。

假设你的应用程序有一部分内容在整个会话期间，数据不会发生变化。那么使用 v-once 命令可以确保你的这个部分内容只会渲染一次。

## 6. 虚拟滚动

这是优化 Vue 应用性能的最后一步啦。你曾经在屏幕上滚动过 Facebook 嘛？（或者是 Twitter，Instagram，或者任何流行的社交软件）我打赌你有过！你可以无尽的滚动，并且页面不会越来越卡顿。但如果你有一个巨大的列表要在你的 Vue 应用中渲染，你会看到页面随着长度变长越来越卡顿。

如果你决定实现无限的滚动，而不是分页功能，那么你应该可以使用下面两个开源项目之一，来实现虚拟滚动条和渲染大量的列表：

* [https://github.com/tangbc/vue-virtual-scroll-list](https://github.com/tangbc/vue-virtual-scroll-list)
* [https://github.com/Akryum/vue-virtual-scroller](https://github.com/Akryum/vue-virtual-scroller)

这两个我都使用过，个人体验 `vue-virtual-scroll-list` 更好一点，使用起来更容易，而且不依赖绝对定位来破坏用户本身的 UI。

## 结论

虽然这篇指南没有包含所有可能遇到的情况，但这六种方法涵盖了 Vue 应用程序的许多常见性能问题。

维护优秀的前端性能可能比你想象的更重要。开发人员的计算机通常有比最终使用 app 的用户更好。甚至你的用户可能都不使用电脑，而是速度慢并且已经过时的智能手机。

因此我们被赋予了这项重任，作为开发人员尽可能的做到最好，提供最佳的用户体验。你可以使用这六种绝招作为一个自测清单，用来帮助确认你的 Vue 应用程序可以让所有的用户顺利运行。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
