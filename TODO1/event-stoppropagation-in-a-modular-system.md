> * 原文地址：[event.stopPropagation() in a modular system](https://www.moxio.com/blog/19/event-stoppropagation-in-a-modular-system)
> * 原文作者：[Frits van Campen](https://www.moxio.com/blog/blogger/7/frits-van-campen)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/event-stoppropagation-in-a-modular-system.md](https://github.com/xitu/gold-miner/blob/master/TODO1/event-stoppropagation-in-a-modular-system.md)
> * 译者：
> * 校对者：

# event.stopPropagation() in a modular system
# 模块化系统中的 event.stopPropagation() 


![](https://www.moxio.com/documents/gfx/page_images/blog.header_1.png)

在 Moxio，我们通过叫 widgets 的模块来构建网络应用。一个 widget 里面包含一些逻辑，和一点对于 HTML 的控制。就像是 checkbox 或者一组其他的 widgets。 一个 widget 可以申明他需要的数据和依赖关系，并且可以选择传递资源去他的子组件。模块化可以很好的来管理复杂度，因为所有资源传输的渠道都被很清楚的定义了。它同样可以允许你通过结合不同的方式来重用 widgets。JavaScript 想要真正的确保模块化约定是有点小困难的，因为你总是可以访问全局作用域， 当然，我们也有办法管理这个问题。

## JavaScript 中的模块化设计

原生 JavaScript 的 API 在设计中并没有考虑到模块化；你总是默认可以访问 _全局_ 作用域。我们通过将全局资源包装在根目录并向下层传递的方式，来让 wigets 获得到这些资源。我们有的包装器包括 LocalStorage，页面的 URL 以及 viewport（为了观察在页面内的坐标）。我们还包装 DOMElements 和事件。 通过这些包装器，我们可以限制和调整功能，进而保证模块化约定的完整。例如： 一个 click 事件 可能知道 shift 是否被按，但是你没法知道 click 事件的目标是什么，这个目标可能是在另一个 widget 内。这个看起来可能有非常大的限制性，但是知道目前，我们还没有发现需要直接暴露目标的需求。

对于每一个需求，我们都找到了在不破坏模块化约定的前提下的表达方法。这也引出了我对于 `event.stopPropagation()` 的分。我们是否需要它？我们如何能够提供它的功能？

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

加了一点 CSS i 后它变成了这样：

![](https://www.moxio.com/documents/gfx/blog.stoppropagation.png)

我们有如下一些交互：

*   点击 checkbox 将选中和取消它，并且使得所在行被“选择”
*   点击每一行末尾的链接将会打开对应地址
*   点击任何一行将会打开或者关闭改行下显示“内容”

### JavaScript 的事件模型

让我们一起快速的过一遍`事件`在 JavaScript 中是怎么运作的。当你点击一个元素节点（例如一个 checkbox），一个事件将诞生，首先它沿着节点树向下传递：table > body > row > columns > cell > input。这是捕捉（capturing）阶段。然后，这个事件按照相反的顺序向上传递，这个冒泡（bubble）阶段：input > cell > columns > row > body > table.

The implication of this is that a click on the checkbox causes a click event on the checkbox _and_ on the row. We don't expect that clicking the checkbox will also toggle the row so we need to detect this. This is where stopPropagation comes in.
这意味着，对于 checkbox 的点击会造成一个在 checkbox 和 row 上的 click 事件。我们不希望点击 checkbox 会打开或关闭 row， 所以我们需要检测它。这里我们也就引入了 stopPropagation。

```javascript
function on_checkbox_click(event) {
    toggle_checkbox_state();
    event.stopPropagation(); // prevent this event from bubbling up
}
```

如果冒泡（bubble）阶段，你在 click 的监听器中加入了 `event.stopPropagation()`， 那个这个事件将不会继续向上传递，也就永远不会到达 row 节点。也就简单明了实现了我们所期待的交互。

## Undesirable interactions

Using stopPropagation has a side effect however. Clicks on the checkbox don't make it back up to the top _at all_. Our intent was to block the click on the row but we blocked it for _all_ our parents. Let's say for instance we have an open menu that needs to collapse when you click 'somewhere else on the page'. Suddenly a straightforward click listener doesn't work anymore because our click events might 'disappear'. We could use the capturing phase but what's to stop a widget above us from blocking _that_ event? stopPropagation gives us a conflict in our modularity contract. It seems desirable that **widgets should not be allowed to interfere with event propagation** during capturing or bubbling.

If we were to remove support for stopPropagation from our wrapper, can we still make an implementation for our row interactions? We can, but it's messy. We can do some bookkeeping so we know when to ignore a click event on the row, or we could open up the event target, or we could allow inspection of where the event has been. We have experimenting with some solutions but we don't really like them.

Bookkeeping workaround example:

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

You can see how this workaround becomes cumbersome if we have more elements that we want to block clicks from (such as the link in the second column), or if the element is in a sub-widget.

## A conceptual solution

We can do better. There is a concept here. We haven't found a good name for it yet but consider it something like a 'significant action'. When you click you always have at most one significant action: either you toggle the row or the checkbox, but never both. From a UX design point of view this makes a lot of sense. My first thought was that stopPropagation shouldn't cancel the bubble but instead it sets a flag on the event that indicates that a significant action has already been executed. A drawback is that for every interactable element (checkboxes, links, buttons etc.) you still need to add a click handler that sets the significant flag. That seems like a lot of work. We can do a little bit better: for interactable elements we already know that they have a signification action, so if the target of an event is an interactable element we can set the significant flag automatically. With this logic being performed in our event wrapper, the row now only needs to check the significant flag so we can ignore clicks from the checkbox in the first column and the link in the second column.

We can now implement our row click handler as such:

```javascript
function on_row_click(event) {
    if (event.is_handled() === false) { // this event had no significant action
        toggle_row_open_state();
    }
}
```

## Conclusion

I'm often amazed at the foresight in the design of JavaScript and its native libraries. In general things work really well. It's a kind of 'choose your own adventure' style API that supports many workflows, including ours. Our modular design and wrapping allows us to augment the native libraries with our own concepts. We can fill in the gaps and smooth out the bumps.

We still allow stopPropagation but discourage its use. The significant-flag has been implemented in many a checkbox-table and there was much rejoicing.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
