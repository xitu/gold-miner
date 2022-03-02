> * 原文地址：[How to Write Cleaner React code](https://medium.com/front-end-weekly/how-to-write-cleaner-react-code-a46aa179a0a1)
> * 原文作者：[Aditya Tyagi](https://medium.com/@aditya-tyagi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/how-to-write-cleaner-react-code.md](https://github.com/xitu/gold-miner/blob/master/article/2022/how-to-write-cleaner-react-code.md)
> * 译者：[Z招锦](https://github.com/zenblofe)
> * 校对者：[zaviertang](https://github.com/zaviertang)

![](https://miro.medium.com/max/1400/1*hSeo2BvnGmzh-ORp8mVEXQ.png)

# 如何编写更简洁优雅的 React 代码

## 避免使用不必要的标签

在接触了十多个生产级别的 React 项目之后，我发现在大多数项目中都存在一个问题，那就是使用了不必要的 HTML 元素或标签。保持代码容易维护、编写、阅读和调试是非常重要的，你可以按照以下方法，来判断代码是否遵循清洁代码准则。

![](https://miro.medium.com/max/1280/1*i2B00WGhKkEWP-HhQGkc5A.jpeg)

这些不必要的标签造成了 DOM 污染。虽然引入这些标签是为了克服 React 中 JSX 的缺点（JSX 应该总是[返回单个 HTML 根元素](https://adityatyagi.com/index.php/2022/01/15/need-for-jsx-in-react/)）。

换句话说，这是无效的 JSX：

```jsx
// 括号有助于编写多行 HTML
const element = (
  
  // 第 1 个 div 块
  <div>
    <h1>Hello!</h1>
    <h2>Good to see you here.</h2>
  </div>
  // 第 2 个 div 块
  <div>
    <h1>Sibling element</h1>
    <h2>I will break JSX element</h2>
  </div>
);
```

很多开发者通过添加 `div` 标签包裹代码块来解决 JSX 的这个问题。

```jsx
const element = (
  
  // div 包裹
  <div>
      // 第 1 个 div 块
      <div>
        <h1>Hello!</h1>
        <h2>Good to see you here.</h2>
      </div>
      // 第 2 个 div 块
      <div>
        <h1>Sibling element</h1>
        <h2>I will break JSX element</h2>
      </div>
  </div>
);
```

目前这个方法适用于小型项目。当我开始在开发大型 React 项目时，发现代码中充满了 div 标签。这迟早会导致出现 `div soup`。

![](https://miro.medium.com/max/1400/0*wV-LndzxvOaGKBmT.png)

## 什么是 `div soup`

接下来看一个示例。

请看以下这段 React 代码：

```jsx
return (
    // 这个 div 什么也没做，只是包裹了两个子标签
    <div>
      <h1>This is heading</h1>
      <h2>This is a sub-heading</h2>
    </div>
  )
```

这在 DOM 中的结果将会是这样：

![](https://miro.medium.com/max/646/0*WmEjvNdAptr1Y7CH.png)

这只是一个小示例，真正的 React 应用要复杂得多。你可以在组件之间有一个深度嵌套的父子关系。例如：

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

再来看子标签的代码：

```jsx
// 每个 React JSX 元素都接收 props 参数
const Child1 = (props) => (
  <div>
    <h3>I am child 1</h3>
    {/* 在 <Child1> 和 </Child1> 之间传递的任何内容 */}
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

最终的 DOM 将会是这样：

![](https://miro.medium.com/max/714/1*dvdO6M6jYg608Nb4zR2HVA.png)

如果你仔细检查生成的 DOM，会看到大量的 div 标签，这些标签没有任何作用，只是为了包裹代码和克服 JSX 的限制。最终，这将会导致一个 `div soup`。

这可能会成倍地增加调试时间，对更快的交付和错误修复造成影响。

![](https://miro.medium.com/max/1400/1*Js5FBm_cgl9py24Uyf9zRg.png)

## 如何避免 `div soup`

目光敏锐的读者一定已经注意到了问题代码的解决方案。我们所要做的就是创建一个封装的 React 组件，它可以返回不带 `div` 的传递组件：

```jsx
// 包裹组件，返回 <Wrapper> 和 </Wrapper> 之间传递的任何 DOM 元素
// 在 props 上本来就有 children 属性
// 所有的 React JSX 元素都应该大写，作为一种命名规范

const Wrapper = (props) => {
  return props.children;
}
```

重构之前的代码：

```jsx
// 带有 Wrapper 组件的 Children
// 每个 React JSX 元素都接收 props 参数
const Child1 = (props) => (
  <Wrapper>
    <h3>I am child 1</h3>
    {/* 在 <Child1> 和 </Child1> 之间传递的任何内容 */}
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

同时：

```jsx
// 带有 Wrapper 组件的 Parent
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

这将删除不必要的 `div` 标签，从而防止出现 `div soup`。

![](https://miro.medium.com/max/800/0*ARchCEaEa-0P10M_.png)

# 使用 React Fragments

在每个 React 项目中引入这个 `Wrapper` 组件是很困难的，也是一种额外的耗费，开发者正是要避免这种情况。

React Fragments 的简介。

根据官方文档的说明：

> React 中一个常见的模式是一个组件返回多个元素。Fragments 可以对子元素列表进行分组，而无需向 DOM 添加额外的节点。
>
> -- [ReactJs.org](https://reactjs.org/docs/fragments.html)

可以通过两种方式来实现：

1. 使用 [`React.Fragment`](https://reactjs.org/docs/fragments.html)
2. 使用 `React.Fragment` 的[简写语法](https://reactjs.org/docs/fragments.html#short-syntax)，即 `<>` 和 `</>`。

通过代码示例来说明：

```jsx
// 使用 React.Fragment 包裹 Parent 组件
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

使用使用 React.Fragment 简写语法会更好。

```jsx
// 使用 React.Fragment 简写语法的 Parent 组件
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

最终的代码将是这样：

```jsx
//  使用 React.Fragment 简写语法的 Children 组件
const Child1 = (props) => (
  <>
    <h3>I am child 1</h3>
    {/* 在 <Child1> 和 </Child1> 之间传递的任何内容 */}
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

这将帮助你获得同样的结果，避免了 `div soup`。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
