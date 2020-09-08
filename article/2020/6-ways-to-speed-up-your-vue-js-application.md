> * 原文地址：[6 Ways to Speed Up Your Vue.js Application](https://medium.com/better-programming/6-ways-to-speed-up-your-vue-js-application-2673a6f1cde4)
> * 原文作者：[Aris Pattakos](https://medium.com/@aris.pattakos)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/6-ways-to-speed-up-your-vue-js-application.md](https://github.com/xitu/gold-miner/blob/master/article/2020/6-ways-to-speed-up-your-vue-js-application.md)
> * 译者：[黄梵高](https://github.com/MangoTsing)
> * 校对者：

# 提升 Vue.js 应用速度的六种办法

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

Rendering full lists or heavy elements more times than needed is quite a sneaky issue, but it’s very easy to make happen.

Let’s say you have a component that has an `entities` property in the data object.

If you followed the previous step, then you probably have a child component to render each entity.

```vue
<entity :entity="entity" v-for="entity in entities" :key="entity.id" />
```

The entity template looks something like this:

```Vue
<template>
  <div>
    <div>{{ user.status }}</div>
    <div>{{ entity.value }}</div>
  </div>
</template>
```

It outputs `entity.value`, but it also uses `user` from the `vuex` state. Now let’s say you have an `auth` function that refreshes the user token, or the global user property is changed in any way. This would cause the entire view to update any time something changes, even if `user.status` stays the same!

There are a few ways to handle it. A simple one would be to pass the `user.status` value as a `userStatus` prop from the parent. If the value is unchanged, Vue will not render it again since it doesn’t have to.

The key here is to be aware of the rendering dependencies. Any prop, data value, or computed value that changes can cause a re-render.

How can you identify duplicate renders?

First of all download the official [Vue.js dev tools](https://chrome.google.com/webstore/detail/vuejs-devtools/nhdogjmejiglipccpnnnanhbledajbpd?hl=en)!

Then use the “Performance tab” to measure your Vue app’s performance. Press start and stop to run a performance check, ideally during the app load.

![Vue.js dev tools Screenshot](https://cdn-images-1.medium.com/max/3710/1*uRo4r7Rbncqnrx8dbhVCtw.png)

And then go to the “Component Render” tab. If your page renders 100 components, then you should see 100 `created` events.

What’s important to note here are the `updated` events. If you have more updated events than created events, without an update in the actual values, it’s likely you have duplicate changes that lead to duplicate rendering.

This can happen if your code changes the `entities` value many times instead of batching the updates. Or it can happen if you’re using some sort of realtime database like Firestore and you’re getting more snapshots than expected. (Firestore can send many snapshots per update, especially if you have Firestore triggers that update related documents).

The solution here is to avoid changing entities more times than is necessary. In the case of Firestore snapshots, you can use debounce or throttle functions to avoid changing the `entities` property too often.

## 3. Optimize Event Handling

Not all events are created equal and as such you have to make sure you’re correctly optimizing for each of them.

Two great examples are `@mouseover` and `window.scroll` events. These two types of events can be triggered many times even with normal usage. If the event handlers you have in place make costly calculations, these calculations will run multiple times per second causing lag in your application. A solution is to use a debounce function to limit how many times you process these events.

## 4. Remove or Reduce Slow Components

When creating new components yourself, but especially when importing third-party components, you need to make sure they perform well.

You can use the Vue.js dev tools performance tab to estimate the rendering time of each component you’re using. When adding a new component, you can see how much time it takes to render in comparison with your own components.

If the new component takes considerably more time than your own components, then you may need to look at alternative components, remove it, or try to reduce its usage.

![](https://cdn-images-1.medium.com/max/2000/1*SLEt6zuG1eYEhKfq9Fxw4A.png)

## 5. Render Once

![](https://cdn-images-1.medium.com/max/2000/1*6PL_PU-Dg-UHrIPZutTLfw.png)

This is from the official Vue.js documentation. If you have elements that once everything is mounted should only be rendered once, you can use the v-once directive.

Let’s say you have a section in your app that requires that data does not change for the entire session. By using the v-once directive you ensure this section is only rendered once.

## 6. Virtual Scrolling

This is the final step towards optimizing your Vue app performance. Have you ever scrolled Facebook on desktop? (Or Twitter, or Instagram, or any popular social media app?) I bet you have! You can scroll endlessly, without the page slowing down. But if you have a huge list to render in your Vue app you will see the page slowing down the longer the page becomes.

If you decide to implement endless scrolling instead of paging, you can and should use one of these two open-source projects for virtual scrollers and rendering huge lists of items:

* [https://github.com/tangbc/vue-virtual-scroll-list](https://github.com/tangbc/vue-virtual-scroll-list)
* [https://github.com/Akryum/vue-virtual-scroller](https://github.com/Akryum/vue-virtual-scroller)

I have used both and in my experience `vue-virtual-scroll-list` is better because it’s easier to use and doesn’t rely on absolute positions that can break the UI.

## Conclusion

Even though this guide doesn’t account for all scenarios, these six ways cover a lot of common performance issues for Vue applications.

Achieving great front end performance is more important than you may realize. Developers usually have much better computers than the users who end up using your app. Your users may not even use computers but rather slow and outdated smartphones.

So it’s up to us, the developers, to do the best in our power and deliver an optimal user experience. You can use these six ways as a checklist to help ensure your Vue app is running smoothly for all users.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
