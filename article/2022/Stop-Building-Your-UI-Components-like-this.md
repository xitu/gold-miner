> * 原文地址：[Stop Building Your UI Components like this❌](https://dev.to/harshkc/stop-building-your-ui-components-like-this-19il)
> * 原文作者：[Harsh Choudhary](https://dev.to/harshkc)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/Stop-Building-Your-UI-Components-like-this❌.md](https://github.com/xitu/gold-miner/blob/master/article/2022/Stop-Building-Your-UI-Components-like-this❌.md)
> * 译者：
> * 校对者：

# Stop Building Your UI Components like this❌
![Cover image for Stop Building Your UI Components like this❌](https://res.cloudinary.com/practicaldev/image/fetch/s--PzuOdW7I--/c_imagga_scale,f_auto,fl_progressive,h_420,q_auto,w_1000/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/j0zvwcrp5zjkq1dd6yl0.jpg)


It is true everyone feels elated abstracting the most often copy-pasted code in the codebase into a reusable component. One bad effect of that is hasty abstractions which is a story for another day, today's agenda is to learn how to make _actually_ reusable components.

Lots of the time while abstracting the reusable component it turns into a mess of props. You've probably seen "reusable" components with over 50 props! Those end up being enormously difficult to use and **maintain**, at the same time it brings performance problems and actual bugs that are hard to track.

Adding one prop for a new use-case is not just an if statement and you end up making a lot of changes in the component making the code size huge and unmaintainable.

But if we're mindful of the kinds of abstractions we create, then we can make something truly easy to use and maintain, is bug-free, and not so big that users pay the download penalty.

Kent C dodd's has explained the problem in-depth, give it a watch:  
[Simply React](https://www.youtube.com/watch?v=AiJ8tRRH0f8&list=PLV5CVI1eNcJgNqzNwcs4UKrlJdhfDjshf)

### [](https://dev.to/harshkc/stop-building-your-ui-components-like-this-19il#how-does-a-reusable-component-looks-like)How does a reusable component looks like?

We've got a `LoginFormModal` component that's abstracted the modal for the login and registration forms. The component itself isn't all that complicated and only accepts a handful of props, but it's pretty inflexible and we'll need to create more modals throughout the application so we want something that's a lot more flexible.  

```
<LoginFormModal
  onSubmit={handleSubmit}
  modalTitle="Modal title"
  modalLabelText="Modal label (for screen readers)"
  submitButton={<button>Submit form</button>}
  openButton={<button>Open Modal</button>}
/>

```

Enter fullscreen mode Exit fullscreen mode

Towards the end, we will create our component which can be used like this:  

```
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

Enter fullscreen mode Exit fullscreen mode

But isn't this more code and more complex than just passing the prop😒.  
We have passed the responsibility to the user of the component rather than the creator, this is called inversion of control. It's definitely more code to use than our existing `LoginFormModal`, but it is simpler and more flexible and will suit our future use cases without getting any more complex.

For example, consider a situation where we don't want to only render a form but  
want to render whatever we like. Our `Modal` supports this, but the  
`LoginFormModal` would need to accept a new prop. Or what if we want the close  
button to appear below the contents? We'd need a special prop called  
`renderCloseBelow`. But with our `Modal`, it's obvious. You just move the  
`ModalCloseButton` component to where you want it to go.

Much more flexible, and less API surface area.

This pattern is called Compound Component - components that work together to form a complete UI. The classic example of this is `<select>` and `<option>` in HTML.

It is widely used in many real-world libraries like:

-   [Reach UI](https://reacttraining.com/reach-ui)
-   [MUI](https://mui.com/)

Let's create our first Compound Component while building a reusable `modal`.

### [](https://dev.to/harshkc/stop-building-your-ui-components-like-this-19il#building-our-first-compound-component)Building our first compound component

```
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

Enter fullscreen mode Exit fullscreen mode

Yay! We did quite some work, we can now use the above component like:  

```
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

Enter fullscreen mode Exit fullscreen mode

The code is more readable and flexible now.

[![elegant,gorgeous code](https://i.giphy.com/media/XxSIGiSOCEBr8G6cxB/giphy-downsized.gif)](https://i.giphy.com/media/XxSIGiSOCEBr8G6cxB/giphy-downsized.gif)

### [](https://dev.to/harshkc/stop-building-your-ui-components-like-this-19il#bonus-allowing-users-to-pass-their-own-onclickhandler)Bonus: Allowing users to pass their own onClickHandler

The `ModalOpenButton` and `ModalCloseButton` set the `onClick`  
of their child button so that we can open and close the modal. But what if the users  
of those components want to do something when the user clicks the button (in  
addition to opening/closing the modal) (for example, triggering analytics).

we want to create a callAll method which runs all the methods passed to it like this:  

```
callAll(() => setIsOpen(false), ()=>console.log("I ran"))
```

Enter fullscreen mode Exit fullscreen mode

I learned this from Kent's [Epic React workshop](https://epicreact.dev/). This is so clever, I love it.  

```
const callAll = (...fns) => (...args) => fns.forEach(fn => fn && fn(...args))
```

Enter fullscreen mode Exit fullscreen mode

Let's use this in our components:  

```
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

Enter fullscreen mode Exit fullscreen mode

The power can be used by passing an `onClickHandler` to our custom button like this:  

```
<ModalOpenButton>
  <button onClick={() => console.log('sending data to facebook ;)')}>Open Modal</button>
</ModalOpenButton>
```

Enter fullscreen mode Exit fullscreen mode

[![Celebrating guy](https://i.giphy.com/media/Kg8U9SYO3yBHlG7gIC/giphy.gif)](https://i.giphy.com/media/Kg8U9SYO3yBHlG7gIC/giphy.gif)

### [](https://dev.to/harshkc/stop-building-your-ui-components-like-this-19il#conclusion)Conclusion

Don't make hasty abstractions and don't leave everything to props. Maybe it is a simple component now but you don't know what use-cases you would need to cover in future, don't think of this as the trade-off between time and maintainability, the complexity can grow exponentially.

Levitate the power of composition in React with compound components and make your life easier.

Also, check Kent's [Epic React Course](https://epicreact.dev/) where I learnt about Compound components patterns and a lot more.

A little about me I am Harsh and I love to code. I have been doing this since 16. I feel at home while building web apps with React. I am currently learning **Remix**.

_If you liked the blog, Let's Connect! I am planning to bring more such blogs in the Future._

[Twitter](https://www.twitter.com/harshkc99)  
[Linkedin](https://www.linkedin.com/in/harshkc99)

Know more about me: [Harsh choudhary](https://harshkc.tech/)

Check my [Testing hooks](https://dev.to/harshkc/a-quick-guide-to-testing-custom-react-hooks-48ce) blog or [how to build generic custom hook](https://dev.to/harshkc/i-promise-this-hook-will-blow-up-your-1000-lines-of-async-codept-2-3ofb) blog.
---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
