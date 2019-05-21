> * 原文地址：[Tracing or Debugging Vue.js Reactivity: The computed tree](https://medium.com/dailyjs/tracing-or-debugging-vue-js-reactivity-the-computed-tree-9da0ba1df5f9)
> * 原文作者：[Michael Gallagher](https://medium.com/@mike_17305)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/tracing-or-debugging-vue-js-reactivity-the-computed-tree.md](https://github.com/xitu/gold-miner/blob/master/TODO1/tracing-or-debugging-vue-js-reactivity-the-computed-tree.md)
> * 译者：[SHERlocked93](https://github.com/SHERlocked93)
> * 校对者：[Reaper622](https://github.com/Reaper622), [hanxiansen](https://github.com/hanxiansen)

# 监测与调试 Vue.js 的响应式系统：计算属性树（Computed Tree）

![](https://cdn-images-1.medium.com/max/8576/1*0Z1Zbhg127bJ2_wReyrq-A.jpeg)

关于 Vue 的[下一个主版本](https://medium.com/the-vue-point/plans-for-the-next-iteration-of-vue-js-777ffea6fabf)，公布的很多新特性引发了激烈的讨论，但其中有一个特性引起了我的注意：

> 更良好的可调试能力：我们可以精确地追踪到一个组件发生重渲染的触发时机和完成时机，及其原因

在本文中，我们将讨论在 Vue2.x 中如何监测响应式机制，并且将演示一些和性能调优相关的代码段。

![](https://cdn-images-1.medium.com/max/2000/1*4877k4Hq9dPdtmvg9hnGFA.jpeg)

## 为什么响应式系统相关代码需要调优

如果你的项目比较大，那么你很有可能在用 Vuex。你会将 store 分割为模块，并且为了关联数据的访问一致性你甚至需要将你的状态[范式化](https://redux.js.org/recipes/structuring-reducers/normalizing-state-shape)。

你可能使用 Vuex 的 getter 来派生状态，事实上，你还会使用复合的派生数据，即一个 getter 会引用另一个 getter 派生的数据。

在 Vue 组件中，你会使用各种分层的模式，当然也包括经常用的 **slots**。在这样的组件树中，肯定会有计算属性（派生出来的数据）。

当这些发生的时候，从 store 中的状态到渲染的组件之间的响应式依赖关系将很难理清楚。

> 这就是计算属性树了，如果不把它弄清楚的话，那么翻转一个看似不起眼的布尔值可能会触发一百个组件的更新。

## 基础知识

我们将学习一些响应式机制的内部工作原理。如果你还没有（比较深地）理解 Dependency 类（译者注：`Dep` — 为与源码一致，后文都采用 `Dep`）与 Watcher 类之间的关系，可以考虑学习一下内容丰富、条例清晰的高级 Vue 课程：[建立一个响应式系统](https://www.vuemastery.com/courses/advanced-components/build-a-reactivity-system/)。

## 在浏览器开发工具中调试过程中见过 `__ob__` 么？

承认吧，当时是不是有点好奇，`__ob__` 看起来是不是像这样？

![](https://cdn-images-1.medium.com/max/3000/1*7IR58OgtvxiUcgWtCLlvEQ.png)

这些在 `subs` 中的 Watcher 将会在这个响应式数据发生改变的时候更新。

有时候你会在开发者工具中浏览一下这些对象，并且找到一些有用的信息，有时候找不到。有时候你会发现 Watcher 远不止 5 个。

## 举个例子

我们用一些简单的代码说明一下：[JSFiddle](https://jsfiddle.net/mikeapr4/eqLy1ac3/)

这个例子的 store 中的状态有散列数组 `users` 和 `currentUserId` 两个属性。还有一个 getter 用来返回当前用户的信息。另外还有一个 getter 只返回状态为活跃的用户数组。

然后这里有两个组件，其中有三个计算属性：

* `validCurrentUser` — 若当前用户是有效用户则为 true
* `total` — 引用反映当前所有活跃用户的 getter，将返回活跃用户数
* `upperCaseName` — 将用户的姓名映射为大写形式

希望举的这个特别的例子，对理解我们讨论的内容有所帮助。

## 计算属性的响应式机制是如何运转的？

通常，当从一个 Dep 类实例获取到更新的通知时，响应机制将会触发对应的 Watcher 函数。当我变更一个被组件渲染所依赖的响应式数据时，将触发重渲染。

但我们看看派生的数据，它的情况有点复杂。首先，计算属性的值是被缓存起来的，以便在它计算出来之后就一直可用计算后的值，只有当它的缓存失效才会被重新计算，换句话说，只在其依赖的数据发生改变时它们才会重新求值。

我们再来看看[之前的例子](https://jsfiddle.net/mikeapr4/eqLy1ac3/)。`currentUserId` 状态被 `currentUser` 这个 getter 引用了，然后在 `validCurrentUser` 计算属性引用了 `currentUser`，`validCurrentUser` 又是根组件 render 函数的 `v-if` 表达式的一部分。这条引用链看起来不错。

实际上，响应数据的存储是通过一个 Watcher 的配置选项来处理的。当我们使用组件中的 Watcher 时，[API 文档](https://vuejs.org/v2/api/#vm-watch)中介绍了两个可选选项（`deep`，`immediate`），但其实还有一些没被文档记录的选项，我并不推介你使用这些没被记录的选项，但理解他们却很有益处。其中一个选项是 `lazy`，配置它之后 Watcher 将会维护一个 `dirty` 标志，如果依赖的响应数据已经更改但这个 Watcher 还未运行时它将为 true，也就是说，此时缓存已过时。

在我们的例子中，如果 `currentUserId` 被改成 3。任何依赖于它且被设置了 `lazy` 的 Watcher 都会被标记为 dirty，但 Watcher 并没有运行。`currentUser` 和 `validCurrentUser` 都是这个状态的 lazy Watcher。根渲染函数同样会依赖于这个状态，渲染将在下一个 tick 时被触发。当渲染函数执行时，将会访问已经被标记为 dirty 的 `validCurrentUser`，它将重新运行它的 getter 函数，进而访问同样需要更新的 `currentUser`。至此，这个组件将会被正确重渲染，并且相关缓存将被更新。

> 等等，我似乎听见你在问，为什么所有 3 个 Watcher 都是依赖于这个状态的呢？

难道他们不是相互依赖的么？计算属性 watcher 有一个特性就是不仅它自身的值是响应式的，而且当计算属性的 getter 被调用时，如果当前有 Wathcer 在读取这个计算属性的话（即 `Dep.target` 中有值--译者），所有这个计算属性的依赖也将会被这个 Wathcer 收集起来。这种依赖收集关系链的扁平化对性能表现更优，而且也是个比较简单的解决方案。

这意味着一个组件将发生更新，即使它所依赖的计算属性在重新计算后的值并没有发生变化，这种更新显然没有什么意义。

其中一些逻辑可以阅读一下 [watcher 类](https://github.com/vuejs/vue/blob/4f111f9225f938f7a2456d341626dbdfd210ff0c/src/core/observer/watcher.js)源码的优雅实现，代码量 240 行左右。

## 那么从 `__ob__` 中我们可以得到哪些关于计算属性响应式机制的信息呢 

我们可以看到有哪些 Watcher 订阅（`subs`）了响应式数据的更新。记住，响应式机制在下面这些情景下起作用：

* 对象
* 数组
* 对象的属性

最后一个情景很有可能被忽略，因为在开发者工具中是无法浏览它的 Dep 类实例（译者注：`__ob__`）。因为 Dep 类是在最初响应式化的时候就被实例化的，但是并没有在这个对象中的什么地方把它记录下来。稍后我们将回头讨论这个问题，因为我将用一个小技巧来间接拿到它。

然而通过观察对象和数组的 Watcher 也可以让我们收获良多，下面是一个简单的 Watcher：

![](https://cdn-images-1.medium.com/max/3924/1*X-fJ7_K4EFBKUHV9BM93Ug.png)

将[示例](https://jsfiddle.net/mikeapr4/eqLy1ac3/)跑起来之后打开开发者工具，它应该在页面全部渲染完成之后暂停运行。你可以输入下面的表达式，就能看到跟上面这个图一样的情况了：

```javascript
this.$store.state.users[2].__ob__.dep.subs[5]
```

这是一个组件的渲染 Watcher，也是一个对象引用。能看到 `dirty` 和 `lazy` 这两个我之前提到过的标志位。同时，我们还可以知道它不是一个用户创建的 Watcher（译者注：`user` 为 false）。 

有时，试图找出这个 Watcher 是哪个组件的渲染 Watcher 是困难的，因为如果这个组件没有全局注册，或者这个组件没有设置 name 属性，那么基本可以说它是匿名的。然而如果你从另一个组件引用了这个匿名组件的时候，它的 `$vnode.tag` 属性通常包含它被引用时所用的名称。

![](https://cdn-images-1.medium.com/max/3548/1*BaKMMhR47aMvlJ85W98xKQ.png)

上面的这个 Watcher 来自于被其父组件定义为 `Comp` 的子组件。它与 `upperCaseName` 计算属性相关。计算属性通常有一个在 getter 函数上指明的有意义的名称，这是因为计算属性通常被定义为对象属性。

## Vuex 的 getter

通常计算属性会给出他们的名称及其所属的组件，但是 Vuex 的 getter 却并不如此。`currentUser` 这个 Watcher 看起来长这样：

![](https://cdn-images-1.medium.com/max/3322/1*9CNU3NoJf7HCVrDynQteTA.png)

唯一能证明它是 Vuex 中的 getter 的线索是：它的函数体定义在 **vuex.min.js** 中（译者注：`[[FunctionLocation]]`）。

所以我们应该怎样获取 getter 的名称呢？在开发者工具中你通常可以访问 `[[Scopes]]`，你可以在 `[[Scopes]]` 中找到它的名称，然而这并不是通过编程的方式来获取的。

下面是我的一个解决方法，在创建 Vuex 的 store 之后运行：

```javascript
const watchers = store._vm._computedWatchers;
Object.keys(watchers).forEach(key => {
  watchers[key].watcherName = key;
});
```

第一行可能看起来有点奇怪，但其实 Vuex 的 store 中会维护一个 Vue 的实例，来帮助实现 getter 的功能，实际上，getter 就是一个伪装起来的计算属性！

现在，当我们查看 `subs` 数组中的 Watcher 时，我们可以通过获取 `watcherName` 来获取 Vuex 的 getter 的名称。

## 对象属性的 Dep 类实例

上面我提到调试响应式数据时你是看不到对象属性的 Dep 类实例。

在[示例](https://jsfiddle.net/mikeapr4/eqLy1ac3/)中，每个 `user` 对象都有一个 `name` 属性，每个属性都包含各自的 Watcher，这些 Watcher 将会在属性发生变更时收到更新通知。

尽管 Dep 实例并不能直接访问到，但是可以被监听他们的 Watcher 访问到。Watcher 保留有一份它所依赖的所有依赖项的数组。
> # 我的小技巧是给属性增加一个 Watcher，然后拿到这个 Watcher 的依赖项

但是这并不简单，我可以通过 Vue 的 `$watch` 接口来添加一个 Watcher，但是返回的并不是 Watcher **实例**。因此我需要从 Vue 实例的内部属性中获取到 Watcher 实例。

```javascript
const tempVm = new Vue();
tempVm.$watch(() => store.state.users[2].name, () => {});
const tempWatch = tempVm._watchers[0];

// now pull the subs from the deps
tempWatch.deps.forEach(dep => dep.subs
  .filter(s => s !== tempWatch)
  .forEach(s => subs.add(s)));
```

## 想把这个功能包装成一个工具函数吗？

我已经把这些小的代码片段封装到了一个任何人都可以获取到的工具库中：[**vue-pursue**](https://github.com/mikeapr4/vue-pursue)。

可以看看[使用示例](https://jsfiddle.net/mikeapr4/pyn5djg8/)。


例子中的 `() => this.$store.state.users[2].name` 经过 **vue-pursue** 处理后返回：

```json
{
  "computed": [
    "currentUser",
    "validCurrentUser",
    "Comp.upperCaseName"
  ],
  "components": [
    "Comp"
  ],
  "unrecognised": 1
}
```

需要注意的是，根组件将会在操作后更新，但因为根组件没有名称，所以其显示为 `unrecognised`。`currentUser` 这个 Vuex 的 getter 将会更新，且这个更新并不来源于 `name` 的更新。

通过传递一个箭头函数给 vue-pursue，这个箭头函数所具有的所有依赖将会被将会被订阅者考虑在内，这意味着 `users` 和 `users[2]` 对象也包括在内。或者，如果我们传递 `(this.$store.state.users[2], ‘name’)`，输出将会是：

```json
{
  "computed": [
    "validCurrentUser",
    "Comp.upperCaseName"
  ],
  "components": [
    "Comp"
  ],
  "unrecognised": 1
}
```

## 最后一点...

我需要着重强调的是，要谨慎使用任何以下划线作为开头的属性，因为这不是公共 API 的一部分，它们可能会在没有任何警告的情况下被移除。上面介绍的这个功能，一开始就没打算使用于生产环境，也没打算使用在运行时环境，这只是一个方便调试的开发者工具。

最终随着 Vue3.0 的出现，这将会被更全面、更简单易用、更可靠的替代。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
