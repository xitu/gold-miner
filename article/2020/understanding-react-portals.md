> - 原文地址：[Understanding React Portals](https://blog.bitsrc.io/understanding-react-portals-ab79827732c7)
> - 原文作者：[Madushika Perera](https://medium.com/@LMPerera)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/understanding-react-portals.md](https://github.com/xitu/gold-miner/blob/master/article/2020/understanding-react-portals.md)
> - 译者：[NieZhuZhu（弹铁蛋同学）](https://github.com/NieZhuZhu)
> - 校对者：[zenblo](https://github.com/zenblo)

# 了解 React Portals（传送门）

![Photo by [Daniel Jerez](https://unsplash.com/@danieljerez?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10368/0*FjXAcqaJwbGxRLfV)

React Portal 提供了一种将子节点渲染到父组件以外的 DOM 节点的优秀解决方案。Portal 的最常见用例是子组件需要从视觉上脱离父容器，如下所示。

- 模态对话框
- 工具提示
- 悬浮卡
- 加载动画

可以使用 `ReactDOM.createPortal(child,container)` 创建一个 Portal。这里的 **child** 是一个 React 元素，fragment 片段或者是一个字符串，**container** 是 Portal 要插入的 DOM 节点的位置。

下面是使用 `ReactDOM.createPortal(child,container)` 创建的一个简单 modal 组件。

```jsx
const Modal = ({ message, isOpen, onClose, children }) => {
  if (!isOpen) return null;
  return ReactDOM.createPortal(
    <div className="modal">
      <span className="message">{message}</span>
      <button onClick={onClose}>Close</button>
    </div>,
    domNode
  );
};
```

即使 Portal 是在父级 DOM 元素之外呈现的，他的表现行为也跟平常我们在 React 组件中使用是一样的。它能够接受 **props** 以及 **context** API。这是因为 Portal 驻留在 React Tree 层次结构内（也就是保证在同一颗 React Tree 上）。

## 为什么我们需要它呢

当我们在特定元素（父组件）中使用模态弹窗时，模态的高度和宽度就会从模态弹窗所在的组件继承，也就是说模态弹窗的样式可能会被父组件影响。传统的模态框需将需要 CSS 属性，例如 `overflow：hidden` 和 `z-index` 来避免这个问题。

![A typical modal where the parent component overrides the height and width](https://cdn-images-1.medium.com/max/2000/1*YHOfHKctYUVbUkZP7JtMSw.png)

上面的代码示例将导致模态框在 `root` 下的嵌套组件内部渲染。当使用浏览器检查元素时，如下所示。

![Modal rendered without React Portal.](https://cdn-images-1.medium.com/max/2000/1*ZXYIAy1ab0hCnGIg_CAfpw.png)

接下来，让我们看看 React Portal 是如何被使用的。下面的代码使用 **createPortal()** 在 **root** 树层次结构之外创建 DOM 节点来解决此问题。

```jsx
const Modal = ({ message, isOpen, onClose, children }) => {
  if (!isOpen) return null;
  return ReactDOM.createPortal(
    <div className="modal">
      <span>{message}</span>
      <button onClick={onClose}>Close</button>
    </div>,
    document.body
  );
};

function Component() {
  const [open, setOpen] = useState(false);
  return (
    <div className="component">
      <button onClick={() => setOpen(true)}>Open Modal</button>
      <Modal
        message="Hello World!"
        isOpen={open}
        onClose={() => setOpen(false)}
      />
    </div>
  );
}
```

下面显示的是 DOM 树层次结构，这是在使用 React Portal 时得到的，其中模态框组件将被注入 **root** 之外，并且与 **root** 处于同一层级。

![Modal rendered with React Portal](https://cdn-images-1.medium.com/max/2000/1*xR30uJTAiBlGwAp6cmLKEg.png)

由于这个模态框是在根层次结构之外渲染的，因此模态框的大小不会因为继承父级组件而被更改。

![A model rendered as a Portal](https://cdn-images-1.medium.com/max/2000/1*xdXdvfFul8rrk4Ra1SzTEg.png)

你可在 [CodeSandbox](https://codesandbox.io/s/react-portals-l0sy5) 中找到这个例子，你可以在其中查看并修改代码以查看门户的工作方式，并解决我们讨论的问题。

## 什么时候使用 Portal 呢

使用 React Portal 时，你应该注意几个方面。除非你了解 React Portal，否则下面这些行为不容易被察觉。因此，在这里提及。

- **事件冒泡会正常工作** —— 通过将事件传播到 React 树的祖先，事件冒泡将按预期工作，而与 DOM 中的 Portal 节点位置无关。
- **React 可以控制 Portal 节点及其生命周期** — 当通过 Portal 渲染子元素时，React 仍然可以控制它们的生命周期。
- **React Portal 只影响 DOM 结构** —— Portal 只会影响 HTML DOM 结构，而不会影响 React 组件树。
- **预定义的 HTML 挂载点** —— 使用 React Portal 时，你需要提前定义一个 HTML DOM 元素作为 Portal 组件的挂载。

## 结论

在我们需要在正常 DOM 层次结构之外呈现子组件而又不通过 React 组件树层次结构破坏事件传播的默认行为时，React Portal（传送门）会派上用场。比如在渲染模态框，工具提示，弹出消息之类的组件时，这很有用。

你可以在 [React 官方文档](https://reactjs.org/docs/portals.html)中找到更多关于 Portal 的描述。

感谢你抽出时间来阅读本文。我想在下面的评论部分中能看到你对这个主题的问题和评论。

---

干杯！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
