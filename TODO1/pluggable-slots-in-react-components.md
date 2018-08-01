> * 原文地址：[Pass Multiple Children to a React Component with Slots](https://daveceddia.com/pluggable-slots-in-react-components/)
> * 原文作者：[Dave Ceddia](https://daveceddia.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/pluggable-slots-in-react-components.md](https://github.com/xitu/gold-miner/blob/master/TODO1/pluggable-slots-in-react-components.md)
> * 译者：
> * 校对者：

# Pass Multiple Children to a React Component with Slots

![](https://daveceddia.com/images/slots@2x.png)

You need to create a reusable component. But the `children` prop won’t cut it. This component needs to be able to accept _multiple_ children and place them in the layout as it sees fit – not right next to each other.

Maybe you’re creating a `Layout` with a header, a sidebar, and a content area. Maybe you’re writing a `NavBar` with a left side and a right side that need to be dynamic.

These cases are all easy to accomplish with the “slots” pattern – a.k.a. passing JSX into a prop.

_TL;DR_: You can pass JSX into _any_ prop, not only the one named `children`, and not only by nesting JSX inside a component’s tag – and it can simplify data passing and make components more reusable.

## Quick Review of React Children

So that we’re all on the same page: React allows you to pass _children_ to a component by nesting them inside its JSX tag. These elements (zero, one, or more) are made available inside that component as a prop called `children`. React’s `children` prop is similar to Angular’s transclusion or Vue’s `<slot>`s.

Here’s an example of passing children to a `Button` component:

```
<Button>
  <Icon name="dollars"/>
  <span>BUY NOW</span>
</Button>
```

Let’s zoom in on the implementation of `Button` and see what it does with the children:

```
function Button(props) {
    return (
    <button>
        {props.children}
    </button>
    );
}
```

The `Button` effectively just wraps the stuff you pass in with a `button` element. Nothing groundbreaking here, but it’s a useful ability to have. It gives the receiving component the ability to put the children anywhere in the layout, or wrap them in a `className` for styling. The rendered HTML output might look something like this:

```
<button>
    <i class="fa fa-dollars"></i>
    <span>BUY NOW</span>
</button>
```

(This, by the way, assumes that the `Icon` component rendered out the `<i>` tag there).

### Children is a Normal Prop Too

Here’s a cool thing about the way React handles children: the nested elements get assigned to the `children` prop, but it’s not a magical special prop. You can assign it just like any other. Behold:

```
// This code...
<Button children={<span>Click Me</span>} />

// Is equivalent to this code...
<Button>
  <span>Click Me</span>
</Button>
```

So not only can you pass `children` as a regular prop, but you can _pass JSX_ into a prop? WHAT.

Yep. And this ability isn’t only for the prop named “children”…

## Use Props as Named Slots

What if I told you, you can pass JSX into _any_ prop?

(You already figured that out, didn’t you.)

Here’s an example of these “slots” props at work – invoking a component named `Layout` with 3 props:

```
<Layout
  left={<Sidebar/>}
  top={<NavBar/>}
  center={<Content/>}
/>
```

Inside the `Layout` component, it can do whatever it needs with the `left`, `top` and `center` props. Here’s a simple example:

```
function Layout(props) {
  return (
    <div className="layout">
      <div className="top">{props.top}</div>
      <div className="left">{props.left}</div>
      <div className="center">{props.center}</div>
    </div>
  );
}
```

You could imagine that `Layout` could be much more complex internally, with lots of nested `div`s or Bootstrap classes for styling or whatever. Or it could pass the sections down to specialized components. Whatever `Layout` needs to do, its user only needs to worry about passing in those 3 props `left`, `top`, and `center`.

### Use Children to Pass Props Directly

Another nice thing about passing children as a prop (whether that’s `children` proper, or some other prop) is this: at the point where you pass in the child prop, you’re in the _parent’s_ scope, so you can pass down whatever you need.

It’s like _skipping a level_. For instance: instead of having to pass, say, a “user” to a Layout and have the Layout pass the “user” to the NavBar, you can create a NavBar (with the user already set) and pass the whole thing into Layout.

This can help avoid the “prop drilling” problem where you’ve gotta thread a prop down through multiple layers.

```
function App({ user }) {
	return (
		<div className="app">
			<Nav>
				<UserAvatar user={user} size="small" />
			</Nav>
			<Body
				sidebar={<UserStats user={user} />}
				content={<Content />}
			/>
		</div>
	);
}

// Accept children and render it/them
const Nav = ({ children }) => (
  <div className="nav">
    {children}
  </div>
);

// Body needs a sidebar and content, but written this way,
// they can be ANYTHING
const Body = ({ sidebar, content }) => (
  <div className="body">
    <Sidebar>{sidebar}</Sidebar>
    {content}
  </div>
);

const Sidebar = ({ children }) => (
  <div className="sidebar">
    {children}
  </div>
);

const Content = () => (
  <div className="content">main content here</div>
);
```

Now compare that to this solution, where the Nav and Body accept a `user` prop and are then responsible for manually passing it down to their children, and those children must pass it down to _their_ children…

```
function App({ user }) {
	return (
		<div className="app">
			<Nav user={user} />
			<Body user={user} />
		</div>
	);
}

const Content = () => <div className="content">main content here</div>;

const Sidebar = ({ user }) => (
  <div className="sidebar">
    <UserStats user={user} />
  </div>
);

const Body = ({ user }) => (
  <div className="body">
    <Sidebar user={user} />
    <Content user={user} />
  </div>
);

const Nav = ({ user }) => (
  <div className="nav">
    <UserAvatar user={user} size="small" />
  </div>
);
```

Not as nice, right? Threading props down this way (aka “prop drilling”) couples the components together more than you might want – not always a bad thing, but good to be conscious of. Using children as in the previous example can avoid having to reach for more complex solutions like context, Redux, or MobX (to name just a few).

### Be Mindful of PureComponent / shouldComponentUpdate

If you need to implement `shouldComponentUpdate` (or `PureComponent`) on a component that takes children, and it prevents a re-render, that’ll prevent the children from rendering, too. So, just keep that in mind. In practice, components that have “slots” are probably pretty likely to be minimal and quick to render, anyway, and therefore less likely to need performance optimizations.

If you run into a situation where you _do_ need to optimize performance of a “slotted” component, consider extracting the slow-performing part into a separate component, and optimizing it independently.

Learning React can be a struggle -- so many libraries and tools!  
My advice? Ignore all of them :)  
For a step-by-step approach, read my book [Pure React](https://daveceddia.com/pure-react/?utm_campaign=after-post).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
