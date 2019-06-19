> * 原文地址：[event.stopPropagation() in a modular system](https://www.moxio.com/blog/19/event-stoppropagation-in-a-modular-system)
> * 原文作者：[Frits van Campen](https://www.moxio.com/blog/blogger/7/frits-van-campen)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/event-stoppropagation-in-a-modular-system.md](https://github.com/xitu/gold-miner/blob/master/TODO1/event-stoppropagation-in-a-modular-system.md)
> * 译者：[Fengziyin1234](https://github.com/Fengziyin1234)
> * 校对者：[sworder](https://github.com/hanxiansen) [shixi-li](https://github.com/shixi-li)

# 模块化系统中的 event.stopPropagation() 

![](https://www.moxio.com/documents/gfx/page_images/blog.header_1.png)

在 Moxio，我们通过叫 widgets 的模块来构建网络应用。一个 widget 里面包含一些逻辑，它将控制一小部分 HTML。就像是 checkbox 元素或者一组其它的 widgets。一个 widget 可以申明它需要的数据和依赖关系，并且可以选择传递资源去它的子组件。模块化可以很好的来管理复杂度，因为所有的资源传输的渠道都被很明确的定义了。模块化也可以允许你通过不同的组合方式来复用 widgets。JavaScript 想要真正的确保模块化约定是有点小困难的，因为你总是可以访问全局作用域，当然，我们也有办法来解决这个问题。

## JavaScript 中的模块化设计

原生 JavaScript 的 API 在设计中并没有考虑到模块化；默认情况下，你可以访问到全局作用域（`global_ scope`）。我们通过将全局资源封装在根目录并向下层传递的方式，来让 wigets 获得到这些资源。我们对一些资源进行了封装，比如 LocalStorage，页面的 URL 以及 viewport（为了观察在页面内的坐标）。我们还封装 DOMElements 和事件。通过这些封装器，我们可以限制和调整功能，进而保证模块化约定的完整。例如：一个 click 事件 可能知道 shift 键是否被按，但是你没法知道 click 事件的目标是什么，因为该点击事件的目标可能是在另一个 widget 内。这个看起来可能有非常大的限制性，但是直到目前，我们还没有发现需要直接暴露目标的需求。

对于每一个特征，我们都找到了一种不破化模块化约定的方法来表达它们。这也引出了我对于 `event.stopPropagation()` 的分析。我们是否需要它？我们如何能够提供它的功能？

## stopPropagation 的栗子🌰

思考一下这个 HTML 的例子：

```html
<div class="table">
    <div class="body">
        <div class="row open">
            <div class="columns">
                <div class="cell">
                    <span class="bullet"></span>
                    <input type="checkbox" />
                    Lorem ipsum dolor sit amet
                </div>
                <div class="cell"><a href="/lorem-ipsum">Lorem ipsum</a></div>
            </div>
            <div class="contents">
                <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
            </div>
        </div>
        <!-- more rows -->
    </div>
</div>
```

加了一点 CSS 后它变成了这样：

![](https://www.moxio.com/documents/gfx/blog.stoppropagation.png)

我们有如下一些交互：

*   点击 checkbox 将选中和取消它，并且使得所在行被“选择”
*   点击第二格里的链接将会打开对应地址
*   点击任何一行将会打开或者关闭该行下显示“内容”

### JavaScript 的事件模型

让我们一起快速的过一遍`事件`在 JavaScript 中是怎么运作的。当你点击一个元素节点（例如一个 checkbox），一个事件诞生，首先它沿着节点树向下传递：table > body > row > columns > cell > input。这是捕捉（capturing）阶段。然后，这个事件按照相反的顺序向上传递，这个冒泡（bubble）阶段：input > cell > columns > row > body > table.

这意味着，对于 checkbox 的点击会造成一个在 checkbox 和 row 上的 click 事件。我们不希望点击 checkbox 会打开/关闭 row，所以我们需要查明这一点。这里我们也就引入了 stopPropagation。

```javascript
function on_checkbox_click(event) {
    toggle_checkbox_state();
    event.stopPropagation(); // prevent this event from bubbling up
}
```

如果处于冒泡（bubble）阶段时，你在 checkbox 中的 click 事件的监听器中加入了 `event.stopPropagation()`，那么这个事件将不会继续向上冒泡传递，也就永远不会到达 row 节点。也就简单明了实现了我们所期待的交互。

## 预期之外的交互

然而，使用 stopPropagation 有一个副作用。点击 checkbox 的事件将 `完全` 不再向上传递。我们的初衷是屏蔽在 row 节点上的点击事件，但我们也屏蔽了所有的父节点。例如说我们有一个如果点击在其他地方，就会被关闭的打开着的菜单。那么那个简单明了的 click 监听器就不再适用，因为我们的 click 事件可能会“消失”。我们依旧能够使用捕捉（capturing）阶段，但是又有什么能够阻止位于父节点中的一个 widget 来屏蔽掉那个事件呢？`stopPropagation` 给我们的模块化带来了矛盾。似乎，在捕捉（capturing）和 冒泡（bubble）阶段中，**禁止在 widgets 中加入 event propagation** 的才是众望所归的选择。

如果我们从封装器中移除对于 stopPropagation 的支持，我们还能够实现我们的上述的交互么？可以的，但是将会很混乱。我们可以做一些簿记，通过记录的方式知晓什么时候我们应该忽略 row 节点上的 click 事件，或者我们可以新建一个事件的目标，又或者我们让你知道事件在哪发生。我们实验了一些解决方法，但是我们并不太喜欢它们。

通过簿记来解决的例子：

```javascript
var checkbox_was_clicked = false;

function on_checkbox_click() {
    checkbox_was_clicked = true;
    handle_checkbox_click();
}

function on_row_click() {
    if (checkbox_was_clicked === false) {
        handle_row_click();
    }
    checkbox_was_clicked = false;
}
```

你可以看出，当我们希望屏蔽更多的元素节点（例如第二行的链接），或者希望屏蔽的元素在次级的 widget 时，这个解决方法将会变得多么的笨重。

## 一个概念上的解决方式

我们可以做的更好。这里有这样一个概念。我们还没有给它想好一个名字，但我们考虑叫它 `significant action`（重大的动作） 类似的名字。当你 click 时，你总是有一个最主要的动作：不管是打开/关闭 row 节点 还是 checkbox，但从来不会是二者同时发生。从 UX 设计的角度来说这很道理的。我的第一个想法是 `stopPropagation` 不应该停止冒泡（bubble），而应该在事件中设定一个标志来表明，一个重要的动作已经被执行了。这个方法的缺点是对于每一个可交互的元素节点来说（checkbox，link，button 等等），你都需要为它们添加一个事件触发（handler）来设置这个标志。那看起来会很是很大的工作量。我们可以稍微改进一点：对于交互元素节点，我们已经知道它们有`significant action`，所以如果目标是交互元素节点，那么就自动设定 `significant` 标志。当我们把这样的逻辑实现在我们的事件封装器时，row 节点现在只需要去检查 `significant` 标志，那么我们就可以忽略来自第一列的 checkbox 和 第二列的链接的点击事件了。

我们可以这样实现我们 row 的 click 事件触发：

```javascript
function on_row_click(event) {
    if (event.is_handled() === false) { // this event had no significant action
        toggle_row_open_state();
    }
}
```

## 总结

我经常被 JavaScript 和它的原生库的设计中的前瞻性所惊艳。总体来说，它工作的很好。它那一种`选择你自己的冒险`式的 API 支持很多的工作流程，也包括我们的。我们的模块化设计和封装让我们可以在原生库上增加我们的概念。我们可以填海移山。

我们依旧允许 `stopPropagation` 的使用，但是我们不鼓励。`significant - 标志`已经在很多的 checkbox-table 中实现了，欢乐多多哟。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
