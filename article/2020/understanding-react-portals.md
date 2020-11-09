> * 原文地址：[Understanding React Portals](https://blog.bitsrc.io/understanding-react-portals-ab79827732c7)
> * 原文作者：[Madushika Perera](https://medium.com/@LMPerera)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/understanding-react-portals.md](https://github.com/xitu/gold-miner/blob/master/article/2020/understanding-react-portals.md)
> * 译者：
> * 校对者：

# Understanding React Portals

![Photo by [Daniel Jerez](https://unsplash.com/@danieljerez?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10368/0*FjXAcqaJwbGxRLfV)

React Portal is a first-class way to render child components into a DOM node outside of the parent DOM hierarchy defined by the component tree hierarchy. The Portal's most common use cases are when the child components need to visually break out of the parent container as shown below.

* Modal dialog boxes
* Tooltips
* Hovercards
* Loaders

A Portal can be created using ReactDOM.createPortal(child, container). Here the **child** is a React element, fragment, or a string, and the **container** is the DOM location(node) to which the portal should be injected.

Following is a sample modal component created using the above API.

```jsx
const Modal =({ message, isOpen, onClose, children })=> {
  if (!isOpen) return null
  return ReactDOM.createPortal(    
    <div className="modal">
      <span className="message">{message}</span>
      <button onClick={onClose}>Close</button>
    </div>,
    domNode)
}
```

Even though a Portal is rendered outside of the parent DOM element, it behaves similarly to a regular React component within the application. It can access **props** and the **context** API. This is because the Portal resides inside the React Tree hierarchy.

## Why do we need it?

When we use a modal inside a particular element (a parent component), the modal's height and width will be inherited from the component in which the modal resides. So there is a possibility that the modal will be cropped and not be shown properly in the application. A traditional modal will require CSS properties like `overflow:hidden` and `z-index` to avoid this issue.

![A typical modal where the parent component overrides the height and width](https://cdn-images-1.medium.com/max/2000/1*YHOfHKctYUVbUkZP7JtMSw.png)

The above code example will result in rendering the modal inside the nested components under the root. When you inspect the application using your browser, it will display the elements, as shown below.

![Modal rendered without React Portal.](https://cdn-images-1.medium.com/max/2000/1*ZXYIAy1ab0hCnGIg_CAfpw.png)

Let's see how React Portal can be used here. The following code will resolve this issue using the **createPortal()** to create a DOM node outside of the **root** tree hierarchy.

```jsx
const Modal =({ message, isOpen, onClose, children })=> {
  if (!isOpen) return null;
  return ReactDOM.createPortal(
     <div className="modal">
      <span>{message}</span>
      <button onClick={onClose}>Close</button>
     </div>
    ,document.body);
  }

function Component() {
  const [open, setOpen] = useState(false)
  return (
    <div className="component">
      <button onClick={() => setOpen(true)}>Open Modal</button>
      <Modal 
       message="Hello World!" 
       isOpen={open} 
       onClose={() => setOpen(false)}
      />
    </div>
  )
}
```

Shown below is the DOM tree hierarchy, which will be resulted when using React Portals, where the modal will be injected outside of the **root,** and it will be at the same level as the **root**.

![Modal rendered with React Portal](https://cdn-images-1.medium.com/max/2000/1*xR30uJTAiBlGwAp6cmLKEg.png)

Since this modal is rendered outside of the root hierarchy, its dimensions would not be inherited or altered by the parent components.

![A model rendered as a Portal](https://cdn-images-1.medium.com/max/2000/1*xdXdvfFul8rrk4Ra1SzTEg.png)

You can find this example through this [CodeSandbox](https://codesandbox.io/s/react-portals-l0sy5), where you can play around with the code, see how the portal works, and address the issues being discussed.

## Things to consider when using Portals

When using React Portals, there are several areas you should be mindful of. These behaviors are not visible directly unless you get to know them. Therefore I thought of mentioning them here.

* **Event Bubbling will work as usual** — Event bubbling will work as expected by propagating events to the React tree ancestors, regardless of the Portal node location in the DOM.
* **React has control over Portal nodes and its lifecycle** — When rendering child elements through Portals, React still has control over their lifecycle.
* **Portals only affect the DOM structure** — Portals only affect the HTML DOM structure and not impact the React components tree.
* **Predefine HTML mount point** — When using Portals, you need to define an HTML DOM element as the Portal component’s mount point.

## Conclusion

React Portal comes in handy when we need to render child components outside the normal DOM hierarchy without breaking the event propagation's default behavior through the React component tree hierarchy. This is useful when rendering components such as modals, tooltips, popup messages, and so much more.

You can find more information on Portals in the [React official documentation](https://reactjs.org/docs/portals.html).

Thank you for taking the time to read this. I would like to see your questions and comments on this topic in the comments section below.

---

Cheers!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
