> * 原文地址：[Can you console.log in JSX?](https://medium.com/javascript-in-plain-english/can-you-console-log-in-jsx-732f2ad46fe1)
> * 原文作者：[Llorenç Muntaner](https://medium.com/@lmuntaner)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/can-you-console-log-in-jsx.md](https://github.com/xitu/gold-miner/blob/master/TODO1/can-you-console-log-in-jsx.md)
> * 译者：[EmilyQiRabbit](https://github.com/EmilyQiRabbit)
> * 校对者：[noahziheng](https://github.com/noahziheng)，[hanxiansen](https://github.com/hanxiansen)

# 在 JSX 代码中可以加入 console.log 吗？

## 结论：不行！

![](https://cdn-images-1.medium.com/max/2000/1*OIfGKWZBZRsvKQZxQtr3Yw.jpeg)

作为一名编程老师，我曾看到过我的学生写出了这样的代码：

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

这样写不会在控制台打印出期望的内容。而是在浏览器上渲染出 **console.log(this.props.todos)** 这个字符串。

我们先来看一些很直接的解决方案，然后我们将会解释原理。

## 最常用的解决方式：

在 JSX 中嵌入表达式：

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

## 另一个很受欢迎的方式：

在 `return()` 语句之前加 `console.log`：

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

## 一种更高级的方式：

使用自定义的 `<ConsoleLog>` 组件是更高级的方法：

```jsx
const ConsoleLog = ({ children }) => {
  console.log(children);
  return false;
};
```

然后使用它：

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

## 为什么是这样？

我们必须记住：JSX 不是原生的 JavaScript，也不是 HTML。它是一种语法扩展。

最终，JSX 会被编译成原生 JavaScript。

例如，如果我们写了如下的 JSX：

```jsx
const element = (
  <h1 className="greeting">
    Hello, world!
  </h1>
);
```

它将会被编译成：

```jsx
const element = React.createElement(
  'h1',
  {className: 'greeting'},
  'Hello, world!'
);
```

我们来回顾一下方法 `React.createElement` 的参数：

* `'h1'`：标签名，是一个字符串类型

* `{ className: 'greeting' }`：`<h1>` 的属性。它会被转换成一个对象。对象的键就是属性名，对象的键值就是属性的值。

* `'Hello, world!'`：它被称为 `children`。位于起始符标签 `<h1>` 和结束符 `</h1>` 之间的内容都会被传递进去。

我们现在来回顾一下文章开始的时候写的失败的 console.log：

```jsx
<div>
  <h1>List of todos</h1>
  console.log(this.props.todos)
</div>
```

这段代码将会被编译为：

```jsx
// 当一个以上的元素被传递进去，第三个参数将会变成一个数组

React.createElement(
  'div',
  {}, // 没有属性
  [ 
    React.createElement(
      'h1',
      {}, // 也没有属性
      'List of todos',
    ),
    'console.log(this.props.todos)'
  ]
);
```

`console.log` 被当成一个字符串传递到了方法 `createElement`。它并没有被执行。

这说得通，上面我们也看到了标题 `List of todos`。计算机如何能知道，哪段代码是需要被执行的，哪段是你希望渲染的呢？

**答案**：计算机认为两者都是字符串。计算机一定会将文字作为字符串处理。

所以，如果你希望这段代码被执行，你需要 JSX 中表明，好让它知道如何处理。你可以将代码作为表达式放在 `{}` 中。

这样就好了！现在你已经知道了在哪里，在何时，如何将 `console.log` 用于 JSX 代码中了！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
