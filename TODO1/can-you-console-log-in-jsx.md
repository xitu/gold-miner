> * 原文地址：[Can you console.log in JSX?](https://medium.com/javascript-in-plain-english/can-you-console-log-in-jsx-732f2ad46fe1)
> * 原文作者：[Llorenç Muntaner](https://medium.com/@lmuntaner)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/can-you-console-log-in-jsx.md](https://github.com/xitu/gold-miner/blob/master/TODO1/can-you-console-log-in-jsx.md)
> * 译者：
> * 校对者：

# Can you console.log in JSX?

## TLDR: You can’t do it!

![](https://cdn-images-1.medium.com/max/2000/1*OIfGKWZBZRsvKQZxQtr3Yw.jpeg)

As a coding instructor, I have seen many students trying this:

```jsx
render() {
  return (
    <div>
      <h1>List of todos</h1>
      console.log(this.props.todos)
    </div>
  );
}
```

This will not print the expected list in the console. It will just render the string *console.log(this.props.todos)* in the browser.

Let’s first take a look at some solutions which are very straightforward, then we will explain the reason.

## The most used solution:

Embed the expression in your JSX:

```jsx
render() {
  return (
    <div>
      <h1>List of todos</h1>
      { console.log(this.props.todos) }
    </div>
  );
}
```

## Another popular solution:

Place your `console.log` before the `return()`:

```jsx
render() {
  console.log(this.props.todos);
  return (
    <div>
      <h1>List of todos</h1>
    </div>
  );
}
```

## A fancy solution:

Get fancy by writing and using your own `<ConsoleLog>` Component:

```jsx
const ConsoleLog = ({ children }) => {
  console.log(children);
  return false;
};
```

Then use it:

```jsx
render() {
  return (
    <div>
      <h1>List of todos</h1>
      <ConsoleLog>{ this.props.todos }</ConsoleLog>
    </div>
  );
}
```

## Why is that so?

We have to remember that JSX is not vanilla JavaScript, nor is it HTML. It is a syntax extension.

Ultimately, JSX gets compiled into vanilla JavaScript.

For example, if we write the following JSX:

```jsx
const element = (
  <h1 className="greeting">
    Hello, world!
  </h1>
);
```

It will get compiled down to:

```jsx
const element = React.createElement(
  'h1',
  {className: 'greeting'},
  'Hello, world!'
);
```

Let’s review the parameters of `React.createElement`:

* `'h1'`: This is the name of the tag, as a string

* `{ className: 'greeting' }`: These are the props used in `<h1>` . It is converted to an object. The key of the object is the name of the prop and the value, its value.

* `'Hello, world!'`: This is called the `children`. It’s whatever is passed between the opening tag `<h1>` and the closing tag `</h1>`.

Let’s now review the failing console.log that we tried to write at the start of this article:

```jsx
<div>
  <h1>List of todos</h1>
  console.log(this.props.todos)
</div>
```

This would get compiled down to:

```jsx
// when more than 1 thing is passed in, it is converted to an array

React.createElement(
  'div',
  {}, // no props are passed/
  [ 
    React.createElement(
      'h1',
      {}, // no props here either
      'List of todos',
    ),
    'console.log(this.props.todos)'
  ]
);
```

See how the `console.log` is passed as a string to `createElement`. It is not executed.

It makes sense, above we have the title `List of todos`. How could the computer know which text needs to be executed and which is something you want to render?

**Answer**: It considers both as a string. It ALWAYS considers the text as a string.

Hence, if you want that to be executed, you need to specify to JSX to do so. By embedding it as an expression with `{}`.

And there you go! Now you know where, when and how `console.log` can be used inside of JSX!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
