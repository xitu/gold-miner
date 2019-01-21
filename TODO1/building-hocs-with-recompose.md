> * 原文地址：[Building HOCs with Recompose](https://medium.com/front-end-developers/building-hocs-with-recompose-7debb951d101)
> * 原文作者：[Abhi Aiyer](https://medium.com/@abhiaiyer)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/building-hocs-with-recompose.md](https://github.com/xitu/gold-miner/blob/master/TODO1/building-hocs-with-recompose.md)
> * 译者：
> * 校对者：

# Building HOCs with Recompose

At [Workpop](http://www.workpop.com/careers), we are constantly iterating through different Component design patterns to navigate the opinion-less sea that is the React ecosystem. Early on, we started finding solace in the “Higher Order” Component pattern.

#### What is a Higher Order Component?

_A Higher Order Component is just a function that returns a function used to render React Components._

Here’s an example:

```
import { Component } from 'React';

export function enhancer() {
 return (BaseComponent) => {
   return class extends Component {
     constructor() {
        this.state = { visible: false }; 
     }
     componentDidMount() {
        this.setState({ visible: true });
     }
     render() {
       return <BaseComponent {...this.props} {...this.state} />;
     }
   }  
 };
}
```

As you can see here, we just have a function that gives functionality to a component of your choosing. In this case, we added some state to control visibility.

We can see it’s use here:

```
// Presentational component

function Sample({ visible }) {
 return visible ? <div> I am Visible </div> : <div> I am not Visible </div>
}

export default enhance()(Sample);
```

#### What’s the point of this pattern?

When architecting your components, I strongly advocate a split between Presentational Components and “Enhancers”/HOCs. I like the term “enhancer” for a HOC because it allows us to understand what they are trying to achieve.

An **Enhancer’s** job is to:

*   Allow you to reuse the same enhancement to another Presentational Component.
*   Clean up bloated components that may be hard to read.
*   Can manipulate the rendering of the component to your choosing.
*   Can add “state” to any component which means you don’t have to rely Redux for everything (if you are doing so now)
*   Manipulate the props you send down to the Presentational Component (map, reduce, w/e you want!)

#### Why not use classes and be done with it?

Use Es6 Classes if you want!! I personally prefer composing my application’s UI from many functional stateless components.

```
function HellWorld({ message = 'Hello World' }) {
  return <h1>{message}</h1>;
}
```

By using Functional components you encourage:

*   Modular code — Reusable pieces that can plug in across your site
*   Reliance on a props-only interface — Stateless interface by default
*   Easily Unit Tested — Easily test interface with enzyme/jest
*   Easily Mocked — Easily mock props for different situations

#### The path we traveled

And there we were, digging the pattern, and off to the races. We hit a couple problems along the way. It became super tedious to constantly write the same HOC syntax for simple things, we didn’t have patterns for combining multiple enhancers together, and we couldn’t prevent the development of duplicate enhancers (this annoys me the most, but I know happens). It was getting hard to prove the value of this pattern as people were getting bogged down in the syntax and the ideas of HOCs (much like engineers do).

We needed something that

*   Enforced Patterns
*   Easily composed
*   Easy to use

That’s when we turned to [**Recompose**](https://github.com/acdlite/recompose)

#### Enter Recompose

> Recompose is a React utility belt for function components and higher-order components. Think of it like lodash for React.

Yes. Exactly what we need. Our team loves lodash, and now explaining to them that building HOC will be the same developer experience as lodash. Promising.

Let’s write a quick example:

Suppose we have a component spec:

*   Need state to represent visibility
*   Need to attach handlers to our component to toggle visibility
*   Need to add some props to the component

#### Step 1 — Write Presentational Component

```
export default function Presentation({ title, message, toggleVisibility, isVisible }) {
 return  (
   <div>
     <h1>{title}</h1>
     {isVisible ? <p>I'm visible</p> : <p> Not Visible </p>}
     <p>{message}</p>
     <button onClick={toggleVisibility}> Click me! </button>
   </div> 
 );
}
```

Okay so now we know what we need to do to enhance this component.

#### Step 2 — Setup your container

I usually compose many Recompose enhancers together. So my step here is to setup your composition:

```
import { compose } from 'recompose';

export default compose(
  /*********************************** 
   *
   * We will be adding enhancers here 
   *
   ***********************************/
)(Presentation);
```

What is compose? Compose literally is the same thing as `flowRight` from `lodash`

We use compose to turn multiple higher-order components into a single higher-order component.

#### Step 3 — Get your state right

Okay now we need to get the state setup for this component

In Recompose we can use the `withState` enhancer to setup internal Component state and the `withHandlers` enhancer to setup event handlers for the component.

```
import { compose, withState, withHandlers } from 'recompose';

export default compose(
  withState('isVisible', 'toggleVis', false),  
  withHandlers({
    toggleVisibility: ({ toggleVis, isVisible }) => {
     return (event) => {
       return toggleVis(!isVisible);
     };
    },
  })
)(Presentation);
```

Here we setup the state key `isVisible` , we setup a method to `toggleVis` and an initial state of false.

`withHandlers` create higher-order functions that accept a set of props and return a function handler, in this case responsible for toggling visibility state. The `toggleVisibility` function will be available to our Presentation component as a prop.

#### Step 4 — Wrap it up with some props

Last thing we need to do is attach some props to our Component.

```
import { compose, withState, withHandlers, withProps } from 'recompose';

export default compose(
  withState('isVisible', 'toggleVis', false),  
  withHandlers({
    toggleVisibility: ({ toggleVis, isVisible }) => {
     return (event) => {
       return toggleVis(!isVisible);
     };
    },
  }),
  withProps(({ isVisible }) => {
    return {
      title: isVisible ? 'This is the visible title' : 'This is the default title',
      message: isVisible ? 'Hello I am Visible' : 'I am not visible yet, click the button!',
    };
  })
)(Presentation);
```

The cool thing about this pattern is we can now manipulate props for the Component. Here, based on our visibility state, we show different titles and messages. In my opinion, this is A LOT more clean in this enhancer than right in your render function.

#### Conclusion

There you have it! Now we have a reusable HOC that we could potentially apply to other presentational components. Also, we can see that we’ve removed a lot of boilerplate in HOC construction.

There is so many more useful APIs in Recompose, check them out [here](https://github.com/acdlite/recompose/blob/master/docs/API.md)! It really is like `lodash`, just open up the docs and start coding!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
