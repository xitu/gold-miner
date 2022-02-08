> * 原文地址：[How to Write Cleaner React code](https://medium.com/front-end-weekly/how-to-write-cleaner-react-code-a46aa179a0a1)
> * 原文作者：[Aditya Tyagi](https://medium.com/@aditya-tyagi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/how-to-write-cleaner-react-code.md](https://github.com/xitu/gold-miner/blob/master/article/2022/how-to-write-cleaner-react-code.md)
> * 译者：
> * 校对者：

![](https://miro.medium.com/max/1400/1*hSeo2BvnGmzh-ORp8mVEXQ.png)

# How to Write Cleaner React code

## Avoid unnecessary tags in React

After getting my hands dirty with over 10 production level React projects, one thing that was consistent with most of them was the use of unnecessary HTML elements/tags. It is highly important that your code is easier to maintain, write, read and debug. As a thumb rule, you can follow this to identify if your code follows clean code guidelines:

![](https://miro.medium.com/max/1280/1*i2B00WGhKkEWP-HhQGkc5A.jpeg)

These tags were polluting the DOM for no reason at all. But they introduced these tags to overcome the drawback of JSX in React. The drawback is that JSX should always [return a single root HTML element](https://adityatyagi.com/index.php/2022/01/15/need-for-jsx-in-react/).

In other words, this is invalid JSX:

```jsx
// The parenthesis helps to write multi-line HTML
const element = (
  
  // 1st div block
  <div>
    <h1>Hello!</h1>
    <h2>Good to see you here.</h2>
  </div>
  // 2st div block
  <div>
    <h1>Sibling element</h1>
    <h2>I will break JSX element</h2>
  </div>
);
```

Because of this drawback, many developers add `div` tags to wrap enormous blocks of code. Hence, resolving the drawback of JSX.

```jsx
const element = (
  
  // The wrapper
  <div>
      // 1st div block
      <div>
        <h1>Hello!</h1>
        <h2>Good to see you here.</h2>
      </div>
      // 2st div block
      <div>
        <h1>Sibling element</h1>
        <h2>I will break JSX element</h2>
      </div>
  </div>
);
```

Now, this works for minor projects. I am guilty of going this route as well. Won't lie. But then as I started working on gigantic React oriented projects, I found the DOM code filled with `div` tags throughout. This sooner or later resulted in a "*div soup*"

![](https://miro.medium.com/max/1400/0*wV-LndzxvOaGKBmT.png)

## What is a div soup?

An example will make it much clearer than me slapping the keyboard to vomit out explanatory paragraphs!

Consider this piece of React code:

```jsx
return (
    // This div does nothing but wraps the two children
    <div>
      <h1>This is heading</h1>
      <h2>This is a sub-heading</h2>
    </div>
  )
```

The result of this in the DOM will be:

![](https://miro.medium.com/max/646/0*WmEjvNdAptr1Y7CH.png)

This is a minor example. Real React apps are way more complex. You can have a deeply nested parent-children relationships between components. For example:

```jsx
return (
    <div>
      <h1>This is heading</h1>
      <h2>This is a sub-heading</h2>
      <Child1>
        <Child2>
          <Child3>
            <Child4/>  
          </Child3>
        </Child2>
      </Child1>
    </div>
  )
```

Where the children are:

```jsx
// Every React JSX element inherently receives the "props" argument
const Child1 = (props) => (
  <div>
    <h3>I am child 1</h3>
    {/* Anything that is passed between <Child1> and </Child1> */}
    {props.children}
  </div>
);
const Child2 =  (props) => (
  <div>
    <h3>I am child 2</h3>
    {props.children}
  </div>
);
const Child3 = (props) => (
  <div>
    <h3>I am child 3</h3>
    {props.children}
  </div>
);
const Child4 = () => (
  <div>
    <h3>I am child 4</h3>
  </div>
);
```

This will produce DOM:

![](https://miro.medium.com/max/714/1*dvdO6M6jYg608Nb4zR2HVA.png)

If you carefully check the generated DOM, you'll see a ton of `div` tags which serves has no purpose but to wrap the code and overcome the JSX limitation. Eventually, this will cause a div soup.

This can exponentially increase the time of debugging and hence can affect faster delivery and bug-fixes!

![](https://miro.medium.com/max/1400/1*Js5FBm_cgl9py24Uyf9zRg.png)

## Avoid a DIV soup

Eagle-eyed readers must have noticed the solution in the problematic code itself. All we have to do is create a wrapper React component which returns the passed component without the `div`:

```jsx
// Wrapper component that returns any DOM element passed between <Wrapper> and </Wrapper>
// The props inherently have the children property on it
// All react JSX elements should be Capitalized as a naming convention 

const Wrapper = (props) => {
  return props.children;
}
```

Refactoring the previous code:

```jsx
// Children with Wrapper component
// Every React JSX element inherently receives the "props" argument
const Child1 = (props) => (
  <Wrapper>
    <h3>I am child 1</h3>
    {/* Anything that is passed between <Child1> and </Child1> */}
    {props.children}
  </Wrapper>
);
const Child2 =  (props) => (
  <Wrapper>
    <h3>I am child 2</h3>
    {props.children}
  </Wrapper>
);
const Child3 = (props) => (
  <Wrapper>
    <h3>I am child 3</h3>
    {props.children}
  </Wrapper>
);
const Child4 = () => (
  <Wrapper>
    <h3>I am child 4</h3>
  </Wrapper>
);
```

and:

```jsx
// Parent component with Wrapper
return (
    <Wrapper>
      <h1>This is heading</h1>
      <h2>This is a sub-heading</h2>
      <Child1>
        <Child2>
          <Child3>
            <Child4/>  
          </Child3>
        </Child2>
      </Child1>
    </Wrapper>
  )
```

This will remove the unnecessary `div` tags and hence prevent the soup!

![](https://miro.medium.com/max/800/0*ARchCEaEa-0P10M_.png)

# React Fragments

It will be difficult and an added effort to introduce this `Wrapper` component in every React project, and we developers try to avoid exactly such situations.

Introducing React Fragments.

According to the official documentation:

> A common pattern in React is for a component to return multiple elements. Fragments let you group a list of children without adding extra nodes to the DOM.
>
> -- [ReactJs.org](https://reactjs.org/docs/fragments.html)

You can do this in two ways:

1. Using `[React.Fragment](https://reactjs.org/docs/fragments.html)`
2. Using a [short syntax](https://reactjs.org/docs/fragments.html#short-syntax) of `React.Fragment` which is `<>` and `</>`

Let me show you via our code above with this:

```jsx
// Parent component wrapper with React.Fragment
return (
    <React.Fragment>
      <h1>This is heading</h1>
      <h2>This is a sub-heading</h2>
      <Child1>
        <Child2>
          <Child3>
            <Child4/>  
          </Child3>
        </Child2>
      </Child1>
    </React.Fragment>
  )
```

Using a short-hand is much better for lazy developers like me:

```jsx
// Parent with shorthand of React.Fragment
return (
    <>
      <h1>This is heading</h1>
      <h2>This is a sub-heading</h2>
      <Child1>
        <Child2>
          <Child3>
            <Child4/>  
          </Child3>
        </Child2>
      </Child1>
      
    </>
  )
```

The final code will look like this:

```jsx
// Children with shorthand
const Child1 = (props) => (
  <>
    <h3>I am child 1</h3>
    {/* Anything that is passed between <Child1> and </Child1> */}
    {props.children}
  </>
);
const Child2 =  (props) => (
  <>
    <h3>I am child 2</h3>
    {props.children}
  </>
);
const Child3 = (props) => (
  <>
    <h3>I am child 3</h3>
    {props.children}
  </>
);
const Child4 = () => (
  <>
    <h3>I am child 4</h3>
  </>
);
```

This will help you get the same results, avoiding the `div` soup.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
