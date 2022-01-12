> * 原文地址：[Stop Building Your UI Components like this❌](https://dev.to/harshkc/stop-building-your-ui-components-like-this-19il)
> * 原文作者：[Harsh Choudhary](https://dev.to/harshkc)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/Stop-Building-Your-UI-Components-like-this❌.md](https://github.com/xitu/gold-miner/blob/master/article/2022/Stop-Building-Your-UI-Components-like-this❌.md)
> * 译者：[Zavier](https://github.com/zaviertang)
> * 校对者：[PingHGao](https://github.com/PingHGao)、[tinnkm](https://github.com/tinnkm)

# 停止这样构建你的组件❌
![Cover image for Stop Building Your UI Components like this❌](https://res.cloudinary.com/practicaldev/image/fetch/s--PzuOdW7I--/c_imagga_scale,f_auto,fl_progressive,h_420,q_auto,w_1000/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/j0zvwcrp5zjkq1dd6yl0.jpg)


确实，每个人都很乐意将常用的逻辑抽象成可重用的组件。但简单潦草的抽象也容易适得其反，当然这是另一个话题了，今天我们要讨论的是如何设计**真正**可重用的组件。

通常我们通过定义一些参数来进行组件的抽象。而且，你很可能也见过拥有超过 50 个参数的所谓的“可重用”组件！这样的组件最终将会变得很难使用和维护，同时也会带来性能问题和难以追踪的 bug。

为满足新的需求而增加一个参数不像多写一条 `if` 逻辑这么简单，最终你将会因此增加大量的代码导致组件变得非常庞大和难以维护。

但是，如果我们谨慎地去设计抽象组件，我们就可以写出真正易于使用和维护的组件，没有愚蠢的 bug，也不会复杂到令使用者望而却步。

Kent C dodd's 曾深入分析过这个问题，可以看看：
[Simply React](https://www.youtube.com/watch?v=AiJ8tRRH0f8&list=PLV5CVI1eNcJgNqzNwcs4UKrlJdhfDjshf)

### [](https://dev.to/harshkc/stop-building-your-ui-components-like-this-19il#how-does-a-reusable-component-looks-like)可重用的组件是什么样的？

这里有一个 `LoginFormModal` 组件，它抽象了登录和注册表单的模态框。组件本身并不是那么复杂，只接受少数几个属性，但它非常不灵活。在我们的应用中可能需要创建大量的模态框，所以我们想要一种更灵活的组件。 

```jsx
<LoginFormModal
  onSubmit={handleSubmit}
  modalTitle="Modal title"
  modalLabelText="Modal label (for screen readers)"
  submitButton={<button>Submit form</button>}
  openButton={<button>Open Modal</button>}
/>

```



最后，我们将创建可以像这样被使用的组件：

```jsx
<Modal>
  <ModalOpenButton>
    <button>Open Modal</button>
  </ModalOpenButton>
  <ModalContents aria-label="Modal label (for screen readers)">
    <ModalDismissButton>
      <button>Close Modal</button>
    </ModalDismissButton>
    <h3>Modal title</h3>
    <div>Some great contents of the modal</div>
  </ModalContents>
</Modal>
```


但是，这并不是从代码量上看起来更复杂了。我们已将控制组件行为的能力赋予给了组件的使用者而不是创建者，这称为控制反转。它肯定比我们现有的 `LoginFormModal` 组件有更多的代码，但它更简单，更灵活，适合我们未来的用例，而且不会变得更加复杂。

例如，考虑这样一种情况：我们不想只渲染表单，而是想要渲染我们喜欢的任何内容。我们的 `Modal` 支持这一点，但 `LoginFormModal` 需要接受一个新的参数。或者，如果我们希望关闭按钮显示在内容的下方，该怎么办？我们需要一个名为 `renderCloseBelow` 的特殊参数。但是对于我们的 `Modal`，这显而易见可以轻松做到。你只需将 `ModalCloseButton` 组件移动到所需的位置即可。

更加灵活，更少的接口暴露。

这种模型称为复合组件 - 多个组件组合成所需的 UI。典型的例子是 HTML 中的 `<select>` 和 `<option>`。

它广泛用于许多实际的库中，例如：

-   [Reach UI](https://reacttraining.com/reach-ui)
-   [MUI](https://mui.com/)

让我们创建第一个复合组件，同时创建一个可重用的 `modal`。

### [](https://dev.to/harshkc/stop-building-your-ui-components-like-this-19il#building-our-first-compound-component)创建我们的第一个复合组件

```jsx
import * as React from 'react'
import VisuallyHidden from '@reach/visually-hidden'

/* Here the Dialog and CircleButton is a custom component 
Dialog is nothing button some styles applied on reach-dialog 
component provided by @reach-ui */
import {Dialog, CircleButton} from './lib'

const ModalContext = React.createContext()
//this helps in identifying the context while visualizing the component tree
ModalContext.displayName = 'ModalContext'

function Modal(props) {
  const [isOpen, setIsOpen] = React.useState(false)

  return <ModalContext.Provider value={[isOpen, setIsOpen]} {...props} />
}

function ModalDismissButton({children: child}) {
  const [, setIsOpen] = React.useContext(ModalContext)
  return React.cloneElement(child, {
    onClick: () => setIsOpen(false),
  })
}

function ModalOpenButton({children: child}) {
  const [, setIsOpen] = React.useContext(ModalContext)
  return React.cloneElement(child, {
    onClick: () => setIsOpen(true),
})
}

function ModalContentsBase(props) {
  const [isOpen, setIsOpen] = React.useContext(ModalContext)
  return (
    <Dialog isOpen={isOpen} onDismiss={() => setIsOpen(false)} {...props} />
  )
}

function ModalContents({title, children, ...props}) {
  return (
    //we are making generic reusable component thus we allowed user custom styles
   //or any prop they want to override
    <ModalContentsBase {...props}>
      <div>
        <ModalDismissButton>
          <CircleButton>
            <VisuallyHidden>Close</VisuallyHidden>
            <span aria-hidden>×</span>
          </CircleButton>
        </ModalDismissButton>
      </div>
      <h3>{title}</h3>
      {children}
    </ModalContentsBase>
  )
}

export {Modal, ModalDismissButton, ModalOpenButton, ModalContents}
```

耶！我们实现了很多的逻辑了，现在可以使用上面的组件，例如： 

```jsx
<Modal>
     <ModalOpenButton>
         <Button>Login</Button>
     </ModalOpenButton>
     <ModalContents aria-label="Login form" title="Login">
         <LoginForm
            onSubmit={register}
            submitButton={<Button>Login</Button>}
          />
      </ModalContents>
  </Modal>
```

现在代码更具可读性和灵活性了。

[![elegant,gorgeous code](https://i.giphy.com/media/XxSIGiSOCEBr8G6cxB/giphy-downsized.gif)](https://i.giphy.com/media/XxSIGiSOCEBr8G6cxB/giphy-downsized.gif)

### [](https://dev.to/harshkc/stop-building-your-ui-components-like-this-19il#bonus-allowing-users-to-pass-their-own-onclickhandler)

允许用户传递自己定义的 `onClickHandler`

`ModalOpenButton` 和 `ModalCloseButton` 设置其子按钮的 `onClick` 事件，以便我们可以打开和关闭模态框。但是，如果这些组件的用户想要在用户单击按钮时执行某些操作（除了打开/关闭模态框之外）（例如：触发分析业务），该怎么办？

我们创建一个 `callAll` 方法，它执行传递给它的所有方法，如下：

```js
callAll(() => setIsOpen(false), ()=>console.log("I ran"))
```

我从 Kent 的 [Epic React workshop](https://epicreact.dev/) 中学到了这一点。这太聪明了，我喜欢它。 

```js
const callAll = (...fns) => (...args) => fns.forEach(fn => fn && fn(...args))
```

让我们在我们的组件中使用它：

```jsx
function ModalDismissButton({children: child}) {
  const [, setIsOpen] = React.useContext(ModalContext)
  return React.cloneElement(child, {
    onClick: callAll(() => setIsOpen(false), child.props.onClick),
  })
}

function ModalOpenButton({children: child}) {
  const [, setIsOpen] = React.useContext(ModalContext)
  return React.cloneElement(child, {
    onClick: callAll(() => setIsOpen(true), child.props.onClick),
  })
}
```

这让我们可以通过将 `onClickHandler` 传递给我们的自定义按钮来使用，如下所示：

```jsx
<ModalOpenButton>
  <button onClick={() => console.log('sending data to facebook ;)')}>Open Modal</button>
</ModalOpenButton>
```

[![Celebrating guy](https://i.giphy.com/media/Kg8U9SYO3yBHlG7gIC/giphy.gif)](https://i.giphy.com/media/Kg8U9SYO3yBHlG7gIC/giphy.gif)

### [](https://dev.to/harshkc/stop-building-your-ui-components-like-this-19il#conclusion)总结

不要匆忙地就进行组件的抽象，也不要把一切都留给参数。也许它现在是一个简单的组件，但你不知道将来需要实现哪些用例，不要认为这是时间和可维护性之间的权衡，复杂性可能会呈指数级增长。

在 React 中发挥复合组件的优势，让你的生活更轻松。

另外，请查看 Kent 的 [Epic React Course](https://epicreact.dev/)，在那里我了解到了复合组件模式（Compound Components）等等。

关于我，我叫 Harsh，我喜欢写代码。我从 16 岁开始就一直在做这件事。在使用 React 构建 Web 应用程序时，我感到宾至如归。我目前正在学习 **Remix**。


_如果你喜欢这篇博客，那关注我吧！我正计划分享更多习惯的内容。_

[Twitter](https://www.twitter.com/harshkc99)  
[Linkedin](https://www.linkedin.com/in/harshkc99)

进一步了解我: [Harsh choudhary](https://harshkc.tech/)

欢迎阅读其他博客 [测试你的 hook](https://dev.to/harshkc/a-quick-guide-to-testing-custom-react-hooks-48ce) 或者 [如何编写自定义 hook](https://dev.to/harshkc/i-promise-this-hook-will-blow-up-your-1000-lines-of-async-codept-2-3ofb).

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
