> * 原文地址：[Sliding In And Out Of Vue.js](https://www.smashingmagazine.com/2019/02/vue-framework-third-party-javascript/)
> * 原文作者：[Kevin Ball](https://www.smashingmagazine.com/author/kevin-ball/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/sliding-in-and-out-of-vue-js.md](https://github.com/xitu/gold-miner/blob/master/TODO1/sliding-in-and-out-of-vue-js.md)
> * 译者：[LucaslEliane](https://github.com/LucaslEliane)
> * 校对者：[Mcskiller](https://github.com/Mcskiller), [SevenOutman](https://github.com/SevenOutman)

# Vue.js 和第三方 JavaScript 的逐渐集成

**摘要**：Vue.js 的一个主要的优点是可以很好地与其他代码一起工作：也就是说它不仅很容易嵌入到其他的应用程序当中，而且也很容易将非 Vue 代码包装到 Vue 当中。本文讨论了 Vue.js 的第二个优势，包括了三种不同类型的第三方 JavaScript，以及将它们嵌入到 Vue 中的方法。

**Vue.js 在过去几年中实现了非常惊人的使用量增长**。它已经从一个鲜为人知的开源库变成了第二受欢迎的前端框架（仅次于 React.js）。

Vue 用户增长的一个核心原因是：Vue 是一个**渐进式**框架 — 它允许你的页面中部分使用 Vue.js 来进行开发，而不需要一个完整的单页应用。也允许你只加入一个 script 标签，而不是使用一个完整的构建系统就可以启动并且运行。

这种渐进式的哲学让 Vue.js 的碎片化开发非常简单，不需要进行大型架构的重写。然而，有一件事却经常被忽略，不仅将 Vue.js 嵌入到其他框架编写的网站中比较容易。**在 Vue.js 中嵌入其他代码也非常容易**。虽然 Vue 会控制 DOM，但是它也预留了一个出口，允许其他非 Vue 的 JavaScript 控制 DOM。

本文将会探讨当你想要使用不同类型的第三方 JavaScript，并且想将其嵌入到 Vue 项目中的情况，然后介绍最适合嵌入到 Vue 中的几种类型的工具和技术。在最后，我们会考虑这些方法的缺点，以及在决定使用它们的时候需要考虑什么。

**本文假设你熟悉 Vue.js 以及组件和指令的概念。如果你正在寻找 Vue 和这些概念的介绍，可以参考 Sarah Drasner 的 [introduction to Vue.js series](https://css-tricks.com/intro-to-vue-1-rendering-directives-events/) 或者 [Vue 官方文档](https://vuejs.org/v2/guide/)。**

## 第三方 JavaScript 类型

我们将主要的三种第三方 JavaScript 类型按照复杂程度排序：

1. [DOM 无关的库](#DOM-无关的库)
2. [元素扩充库](#元素增强库)
3. [组件和组件库](#组件和组件库)

### DOM 无关的库

第一种第三方 JavaScript 库是仅提供逻辑方面的功能，并不直接访问 DOM，比如用于处理时间的 [moment.js](https://momentjs.com/) 或者用于增强函数式编程能力的 [lodash](https://lodash.com/) 都属于这种类型。

这些库很容易集成到 Vue 应用当中，但是可以多种方式来提供合理的访问方式。这些库一般都是为了提供实用的程序功能，和其他任何类型的 JavaScript 项目都是相融的。

### 元素增强库

元素增强是一种为 DOM 元素添加额外功能的方法，这种方法由来已久。比如可以帮助图片进行懒加载的 [lozad](https://github.com/ApoorvSaxena/lozad.js) 或者为输入框提供输入过滤的 [Vanilla Masker](https://github.com/vanilla-masker/vanilla-masker)。

这些库通常只会一次影响单个元素，他们可能会操纵单个元素，但是不会为 DOM 增加新的元素。

这些工具具有严格的用途，并且和其他解决方案进行交互非常简单。这些库经常会被引入到 Vue 工程中，防止重复造轮子。

### 组件和组件库

这些工具是大型的，并且密集的框架。比如 [Datatables.net](https://datatables.net/)，或者 [ZURB Foundation](https://foundation.zurb.com/)。这些库会创建一个完整的交互式组件。通常具有多个可交互元素。

这些库要么会直接将这些元素注入到 DOM 中，要么期望能够对 DOM 进行高级别的控制。它们通常使用其他的框架或者工具集构建（上面的两个例子都是基于 jQuery 进行构建的）。

这些工具提供了**非常广泛的**功能，并且在没有大量修改的情况下，将其替换成其他的工具是非常具有挑战性的，因此，将他们嵌入到 Vue 中的解决方案，对于迁移一个大型应用来说非常关键。

## 如何在 Vue 中使用

### DOM 无关的库

将 DOM 无关的库集成到 Vue.js 工程中相对简单一些。如果你在使用 JavaScript 模块，那么就像在工程中引入其他模块一样，简单地使用 `import` 或者 `require` 就好了。比如：

```js
import moment from 'moment';

Vue.component('my-component', {
  //…
  methods: {
    formatWithMoment(time, formatString) {
      return moment(time).format(formatString);
    },
});
```

如果使用全局 JavaScript，那么需要在 Vue 工程之前引入这个库：

```html
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.24.0/moment.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/vue/2.5.22/vue.min.js"></script>
<script src="/project.js"></script>
```

另外一种常见的分层方法是使用过滤器或者方法将库中的函数进行包装，以便在模板中比较方便地访问。

#### Vue 过滤器

Vue 的[过滤器](https://vuejs.org/v2/guide/filters.html)是一种模式，允许您直接在模板中内嵌应用文本格式。文档中提供了一个示例，你可以创建一个 'capitalize' 过滤器，然后将其应用到模板中，如下所示：

```js
{{myString | capitalize}}
```

当导入与格式有关的库时，你可能希望能够直接在过滤器中使用。比如，如果你使用 `moment` 来格式化工程中的日期，将其转换为相对时间，我们可以创建一个 `relativeTime` 过滤器。

```js
const relativeTime = function(value) {
  if (!value) return '';
  return moment(value).fromNow();
}
```

然后我们可以使用 `Vue.filter` 方法来将其全局添加到所有的 Vue 组件和实例上：

```js
Vue.filter('relativeTime', relativeTime);
```

或者将其添加到使用了 `filters` 选项的特定组件上：

```js
const myComponent = {
  filters: {
    'relativeTime': relativeTime,
  } 
}
```

你可以试着在 [CodePen](https://codepen.io) 上跑一下这段代码：参阅 Smashing Magazine（[@smashing-magazine](https://codepen.io/smashing-magazine/)）的这段代码片：[Vue 集成：相对时间过滤器](https://codepen.io/smashing-magazine/pen/drbQOo)。

### 元素增强库

与 DOM 无关的库相比，元素增强库的集成稍微复杂一些。如果你不小心，Vue 会和库产生交叉控制，争夺 DOM 的控制权。

为了避免这样的情况发生，你需要将库挂载到 Vue 的生命周期当中，让这些库在 Vue 完成 DOM 操作之后运行，并且正确处理 Vue 触发的更新操作。

这些事可以在组件内部完成，但是由于这些库一般都只会接触一个元素，因此将其封装到自定义指令（directive）中是更加灵活的方法。

#### Vue 指令

Vue 指令是一种修饰符，可以为页面中的元素添加行为。Vue 已经提供了许多你已经熟悉了的內建指令，比如 `v-on`、`v-model` 以及 `v-bind`。并且我们还可以创建**自定义**指令来为元素添加任何类型的行为 — 这正是我们想要实现的。

定义一个自定义指令和定义组件非常相似；使用一组和特定声明周期钩子对应的方法创建一个对象，并且通过执行将其添加到全局：

```js
Vue.directive('custom-directive', customDirective);
```

或者通过在组件内部添加 `directives` 对象来将指令添加到组件本地。

```js
const myComponent = {
  directives: {
    'custom-directive': customDirective,
  } 
}
```

#### Vue 指令钩子

Vue 指令有针对以下可用于自定义行为的钩子。虽然可以在单个指令中使用这些钩子，但是一般情况下只会在一个指令中使用其中的一个到两个钩子。这些生命周期钩子都是可选的，所以请在使用的时候选择需要的即可。

- `bind(el, binding, vnode)`：当指令首次绑定到一个元素上的时候，会且仅会被调用一次。这是一个进行一次性设置工作的好地方，但是要小心，即使元素存在，也有可能还未被实际挂载到文档中。
- `inserted(el, binding, vnode)`：当绑定元素插入到父节点中的时候被调用。这也不能够保证文档中存在这个元素，但是这意味着如果你需要引用父节点，那么是可以引用到的。
- `update(el, binding, vnode, oldVnode)`：当包含组件的 VNode 更新时调用，但是无法保证组件的其他孩子将会更新，并且该指令的值可能已经被更改，也可能还未更改。（你可以通过比较 `binding.value` 和 `binding.oldValue` 来优化掉不必要的更新）。
- `componentUpdated(el, binding, vnode, oldValue)` 和 `update` 非常类似，但是这个钩子会在当前节点包含的所有孩子都更新完成后调用。如果你的指令的行为依赖于当前节点的对等体，（比如 `v-else`），那么可以使用这个钩子来代替 `update`。
- `unbind(el, binding, vnode)` 和 `bind` 类似，这个钩子当且仅当指令从元素上解绑的时候被触发一次。这是一个执行所有卸载代码的好地方。

这些函数的参数如下：

- `el`：指令所绑定的元素；
- `binding`：一个包含了指令参数以及值的相关信息的对象；
- `vnode`：Vue 编译器产出的对应元素的虚拟节点；
- `oldValue`：更新之前的虚拟节点，只会在 `update` 和 `componentUpdated` 中被传入。

**更多信息可以在 [Vue 自定义指令指南](https://cn.vuejs.org/v2/guide/custom-directive.html#hook-arguments-example)中找到。**

#### 在自定义指令中引入 Lozad 库

让我们来看一个使用了 [lozad](https://www.npmjs.com/package/lozad) 的引入例子，lozad 库是一种基于 Intersection Observer API 的懒加载库。使用 lozad 的 API 非常简单：通过 `data-src` 来替换图片的 `src` 属性，并且传递一个选择器或者元素到 `lozad()` 方法中，然后调用的对象中的 `observe` 即可。

```js
const el = document.querySelector('img');
const observer = lozad(el); 
observer.observe();
```

我们可以通过指令中的 `bind` 钩子来很方便地进行实现。

```js
const lozadDirective = {
  bind(el, binding) {
    el.setAttribute('data-src', binding.value) ;
    let observer = lozad(el);
    observer.observe();
  }
}
Vue.directive('lozad', lozadDirective)
```

有了这个，我们可以简单地将源字符串传递给 `v-lozad` 指令，来将图片转变为懒加载：

```html
<img v-lozad="'https://placekitten.com/100/100'" />
```

这段代码片可以在 [CodePen](https://codepen.io) 中查看：参阅 Smashing Magazine（[@smashing-magazine](https://codepen.io/smashing-magazine/)）的这段代码片：[Vue 集成：仅设置 bind 的 Lozad 指令](https://codepen.io/smashing-magazine/pen/aMoQLe)。

我们还没有完成！虽然这样在初始加载的时候可以工作，但是如果源字符串的值是动态的，Vue 会动态改变绑定吗？可以在上面的 CodePen 中通过点击 “Swap Sources” 按钮触发。如果我们只实现 bind，那么当需要动态改变源字符串的话，`data-src` 和 `src` 则不会动态改变。

为了实现这样的效果，我们需要增加 `updated` 钩子：

```js
const lozadDirective = {
  bind(el, binding) {
    el.setAttribute('data-src', binding.value) ;
    let observer = lozad(el);
    observer.observe();
  },
  update(el, binding) {
    if (binding.oldValue !== binding.value) {
      el.setAttribute('data-src', binding.value);
      if (el.getAttribute('data-loaded') === 'true') {
        el.setAttribute('src', binding.value);
      }
    }
  }
}
```

有了这个就好了！我们的指令现在可以在 Vue 更新的时候触发 lozad 了。最后的版本可以通过下面的代码片查看：参阅 [CodePen](https://codepen.io/) 上面 Smashing Magazine（[@smashing-magazine](https://codepen.io/smashing-magazine/)）的这段代码片：[Vue 集成：设置了 update 的 Lozad 指令](https://codepen.io/smashing-magazine/pen/gEYQvR)。

### 组件和组件库

需要集成的最复杂的第三方 JavaScript 是需要控制整个 DOM 区域的，完整的组件或者组件库。这些工具希望能够创建，销毁并且控制 DOM。

对于这些库，将他们集成到 Vue 的最好方法是将其包装到一个专用的组件中，并且大量使用 Vue 的生命周期函数来管理初始化，数据传入，以及事件处理和回调。

我们的目标是完全抽象出第三方库的细节，以便其他的 Vue 代码可以像与原生组件交互一样，和我们包装的组件进行交互。

#### 组件生命周期钩子

要包装更加复杂的组件，我们需要了解组件中可用的所有生命周期钩子函数，这些钩子函数有：

-   `beforeCreate()` 在组件被实例化之前调用，很少使用，但是如果需要类似整合分析功能的时候是有用的。
-   `created()` 在组件被实例化之后，挂载到 DOM 上之前调用，在我们需要一次性的，不依赖 DOM 的设置工作的时候非常有用。
-   `beforeMount()` 在组件挂载到 DOM 之前被调用。（也很少使用）
-   `mounted()` 在组件被挂载到 DOM 之后调用。对于调用时需要依赖 DOM 或者假设 DOM 存在的库来说，这是我们最常使用的钩子函数。
-   `beforeUpdate()` 在 Vue 即将更新渲染模板的时候调用，很少使用，但是同样地，在整合分析的时候也是有用的。
-   `updated()` 当 Vue 完成模板更新的时候调用。适合任何需要重新实例化的过程。
-   `beforeDestroy()` 在 Vue 卸载一个组件之前调用。如果我们需要在第三方组件上调用任何销毁或者卸载的方法，这里是一个完美的地方。
-   `destroyed()` 当 Vue 完成了一个组件的卸载之后调用。

#### 一次包装一个组件，一个钩子函数

来让我们看看流行的 [jquery-multiselect](http://loudev.com/) 库。目前已经有许多 Vue 写的多选组件了，但是这个例子是一个很好的组合：复杂到足够有趣，简单到足够理解。

实现一个第三方组件包装器，首先需要使用到 `mounted` 钩子。由于第三方组件可能希望在调用第三方库之前，DOM 就已经存在，因此需要在这里初始化第三方组件。

例如，开始包装 jquery-multiselect 的时候，我们会写如下代码：

```js
mounted() { 
  $(this.$el).multiselect();
}
```

你可以在 [CodePen](https://codepen.io/) 中查看下面代码片：参阅 Smashing Magazine（[@smashing-magazine](https://codepen.io/smashing-magazine/)）的这段代码片：[Vue 集成：简单的多选包装](https://codepen.io/smashing-magazine/pen/WmeYKy)。

这看起来很不错。如果我们需要在卸载的时候调用某些方法，我们需要添加 `beforeDestroy` 钩子函数，但是这个库没有需要我们调用的任何卸载方法。

#### 将回调转换为事件

我们要对这个库做的下一件事是在用户选择某个选项的时候，提供通知 Vue 应用的能力。jquery-multiselect 库通过 `afterSelect` 以及 `afterDeselect` 函数来进行回调，但是这样并不适合 Vue，我们让这些回调内部触发事件。我们可以简单地将回调函数进行包装：

```js
mounted() { 
  $(this.$el).multiSelect({
     afterSelect: (values) => this.$emit('select', values),
     afterDeselect: (values) => this.$emit('deselect', values)
   });
}
```

然而，如果我们在事件监听器中插入一个 logger，我们会发现并没有真正提供到一个类似 Vue 的接口。在每次选择或者取消选择的时候，我们会收到一个值已经改变了的列表，但是为了更符合 Vue，我们应该让列表触发 change 事件。

我们没有像 Vue 那样的方法去设置值。我们应该考虑使用这些工具其实现类似 `v-model` 的方法，比如 [Vue 提供的原生选择元素](https://vuejs.org/v2/guide/forms.html#Select)。

#### 实现 `v-model`

要在组件上实现 `v-model`，我们需要实现两件事：接收一个 `value` 属性并且将相应的选项设置为选中，然后在选项改变之后触发 `input` 事件并且传入一个新的数组。

这里有四个需要处理的部分：一个特定的初始值，将所有更改传递到父组件，处理从外部组件接收到的所有更改，最后处理对于插槽（选项列表）内部内容的所有变更。

让我们挨个来进行实现。

1. **通过属性来进行初始化设置**

首先，我们需要让组件接收一个属性，并且当我们初始化的时候，告诉多选组件，需要选中哪个。

```js
export default {
  props: {
    value: Array,
    default: [],
  },
  mounted() { 
    $(this.$el).multiSelect();
    $(this.$el).multiSelect('select', this.value);
  },
}
```

2. **处理内部变化**

为了处理因为用户和多选元素的交互所产生的变化，我们可以回到之前探讨过的回调 — 但这次不是那么简单了。我们需要考虑原始值以及发生的变化，而不是简单地将接收到的值传递出去。

```js
mounted() { 
  $(this.$el).multiSelect({
    afterSelect: (values) => this.$emit('input', [...new Set(this.value.concat(values))]),
    afterDeselect: (values) => this.$emit('input', this.value.filter(x => !values.includes(x))),
  });
  $(this.$el).multiSelect('select', this.value);
},
```

这些回调函数看起来有些密集，所以让我们来把它分解一下。

`afterSelect` 方法将新选择的值与我们现有的值连接起来，但是为了确保没有重复，我们采用 Set（保证唯一性）来进行处理。然后将其解构，转换为数组。

`afterDeselect` 方法只是从列表中过滤掉当前取消选择的值，以便传递出去新的列表。

3. **处理外部触发的更新**

接下来我们需要做的是在 `value` 属性更新时，更改 UI 中的选定值。这包括将属性的**声明式**变化转换到多选可用的**必要的**变化。最简单的方式是在 `value` 属性上使用观察者。

```js
watch:
  // don’t actually use this version. See why below
  value() {
    $(this.$el).multiselect('select', this.value);
  }
}
```

但是，有一个问题！因为触发 select 同时会我们的 `onSelect` 处理程序，从而使用更新值。如果我们使用这样的一个简单的观察者，我们会陷入到死循环中。

幸运的是，对于我们来说，Vue 能够让我们同时访问到旧的和新的值。我们可以进行比较，只有在值发生变化的时候才触发 select。在 JavaScript 中，数组的比较可能会比较棘手，但是对于这个例子，我们可以通过 `JSON.stringify` 来直接进行比较，因为我们的数组实际上比较简单（因为没有对象）。在考虑到我们还需要取消选择已经删除的选项之后，我们最后的观察者是这样的：

```js
watch: {
    value(newValue, oldValue) {
      if (JSON.stringify(newValue) !== JSON.stringify(oldValue)) {
        $(this.$el).multiSelect('deselect_all');
        $(this.$el).multiSelect('select', this.value);
      }
    }
  },
```

4. **将外部更新表现在插槽中**

我们还有一件事需要处理：我们的多选元素正在使用通过插槽传入的选项值。如果这组选项发生了变化，我们需要告诉多选元素进行更新，否则新的选项不会展示出来。幸运的是，我们在多选组件的更新中有一个简单的 API（`refresh` 函数和一个明显的 Vue 钩子）。这样就可以简单地处理这种情况了。

```js
updated() {
  $(this.$el).multiSelect('refresh');
},    
```

你可以在 [CodePen](https://codepen.io/) 上查看到这个组件的最终版本：参阅 Smashing Magazine（[@smashing-magazine](https://codepen.io/smashing-magazine/)）的这段代码片：[Vue 集成：具有 v-model 的多选包装器](https://codepen.io/smashing-magazine/pen/QoLJJV)。

## 缺点和其他考虑因素

现在我们已经了解了在 Vue 中使用第三方 JavaScript 是多么简单了，是时候讨论一下这些方法的缺点，以及何时使用它们了。

### 性能影响

在 Vue 中使用**不**是为了 Vue 编写的第三方 JavaScript 的主要缺点之一就是性能 ——— 特别是在引用由其他框架构建的组件以及组件库的时候。在用户与我们的应用程序交互之前，浏览器会需要下载和解析额外的 JavaScript。

比如，如果使用上述的多选组件，需要引入全部的 jQuery 代码。这使得用户需要下载两倍于现在的框架代码，仅仅是为了这样一个组件！显然，使用原生的 Vue.js 组件会更好。

此外，当第三方使用的 API 和 Vue 的声明方式大相径庭的时候，你可能会发现自己的程序需要大量额外的执行时间。同样使用多选的示例，我们不得不每次更换插槽的值的时候，刷新整个组件（需要查看一大堆的 DOM），而 Vue 原生的组件可以通过虚拟 DOM 来使其更新更加高效。

### 何时使用

利用第三方库可以大幅减少你的开发时间，并且通常意味着你可以使用你还没有能力去构建出来的，有着良好维护和测试的组件。

对于那些没有较大依赖关系的库，特别是没有大量 DOM 操作的库，没有理由必须要为了使用 Vue 特定的库，而放弃更加通用的库。因为 Vue 可以很方便的引入其他第三方 JavaScript，所以你只需要根据你的功能和性能需求，选择最合适的工具，而没有必要去特别关注 Vue 特有的库。

对于更为广泛的组件框架，有三种需要将其引入的主要情况：

1.  **项目原型**：在这种情况下，迭代速度的需求远远超过用户性能；只需要使用所有能让你工作效率提升的东西。
2.  **迁移现有的站点**：如果你需要将现有的站点迁移到 Vue，可以通过 Vue 来将现有的东西进行优雅地包装，这样就可以逐步地抽出旧的代码，而不用进行一次大爆炸似的重写。
3.  **当 Vue 组件功能尚不可用的时候**：如果你需要完成特定的，或者具有挑战性的需求的时候，存在第三方库支持，但是 Vue 还没有特定的组件，请务必考虑用 Vue 来包装现有的库。

> [当第三方使用的 API 和 Vue 的声明方式大相径庭的时候，你可能会发现自己的程序需要大量额外的执行时间。](http://twitter.com/share?text=When%20there%20are%20large%20mismatches%20between%20the%20APIs%20used%20by%20third-party%20libraries%20and%20the%20declarative%20approach%20that%20Vue%20takes,%20you%20may%20find%20yourself%20implementing%20patterns%20that%20result%20in%20a%20lot%20of%20extra%20execution%20time.%0a&url=https://smashingmagazine.com%2f2019%2f02%2fvue-framework-third-party-javascript%2f)

### 现有的一些例子

前两个模式在开源生态环境中使用范围非常广泛，所以有非常多的例子可以去参考。由于包装整个组件更像是一种权宜之计/迁移解决方案，我们在外部找不到那么多例子，但是还有有一些现有的例子，我曾经在客户要求下使用了这种方法。下面是三种模式的一些简单的例子：

1.  [Vue-moment](https://www.npmjs.com/package/vue-moment) 包装了 moment.js 库，并且提供了一系列的 Vue 过滤器；
2.  [Awesome-mask](https://www.npmjs.com/package/awesome-mask) 包装了 vanilla-masker 库并且提供了过滤输入的指令；
3.  [Vue2-foundation](https://www.npmjs.com/package/vue2-foundation) 在 Vue 组件内部包装了 ZURB Foundation 组件。

## 结论

Vue.js 的受欢迎程度还没有放缓的迹象，框架的渐进式策略赢得了很多的信任。渐进式策略意味着个人可以逐渐地接入使用，而无需进行大规模的重写。

正如我们看到的那样，这种渐进式也在向另外的方向发展。正如你可以在其他应用程序中嵌入 Vue 一样，也可以在 Vue 内部嵌入其他的库。

需要一些尚未移植到 Vue 组件的功能吗？把它拉进来，把它包起来，你会觉得物超所值的。

### SmashingMag 上的进一步阅读：

-   [Replacing jQuery With Vue.js: No Build Step Necessary](https://www.smashingmagazine.com/2018/02/jquery-vue-javascript/ "Read 'Replacing jQuery With Vue.js: No Build Step Necessary'") by Sarah Drasner
-   [Creating Custom Inputs With Vue.js](https://www.smashingmagazine.com/2017/08/creating-custom-inputs-vue-js/ "Read 'Creating Custom Inputs With Vue.js'") by Joseph Zimmerman
-   [Hit The Ground Running With Vue.js And Firestore](https://www.smashingmagazine.com/2018/04/vuejs-firebase-firestore/ "Read 'Hit The Ground Running With Vue.js And Firestore'") by Lukas van Driel
-   [Serverless Functions And Vue.js](https://vimeo.com/296938039 "Read 'Serverless Functions And Vue.js'") by Sarah Drasner (Video, SmashingConf NYC 2018)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
