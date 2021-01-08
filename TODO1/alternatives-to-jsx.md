> * 原文地址：[Alternatives to JSX](https://blog.bloomca.me/2019/02/23/alternatives-to-jsx.html)
> * 原文作者：[Seva Zaikov](https://blog.bloomca.me/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/alternatives-to-jsx.md](https://github.com/xitu/gold-miner/blob/master/TODO1/alternatives-to-jsx.md)
> * 译者：[EmilyQiRabbit](https://github.com/EmilyQiRabbit)
> * 校对者：[xionglong58](https://github.com/xionglong58)，[sunui](https://github.com/sunui)

# JSX 的替代方案

如今，JSX 已经是一个非常受欢迎的框架模版了，它的应用也不仅仅局限于 React（或其他 JSX 衍生模版）。但是，如果你并不喜欢它，或者有某些想要避免使用它的项目，或者只是好奇不使用 JSX 该如何书写 React 代码的时候，该怎么办呢？最简单的方法就是去阅读[官方文档](https://reactjs.org/docs/react-without-jsx.html)，但是，官方文档很简短，而在本篇文章中我们为您提供了更多的选择。

> 免责声明：个人来说，我很喜欢 JSX，在我所有的 React 项目中我都使用了它。但是，我对本文主题重新进行了调研，并且希望和你分享我的所见。

## 什么是 JSX

首先，我们需要明白什么是 JSX，这样我们才能在纯 JavaScript 中编写对应的代码。JSX 是一种[特定域编程语言](https://en.wikipedia.org/wiki/Domain-specific_language)，意味着我们需要将 JSX 代码转码，以便得到常规的 JavaScript，否则浏览器将无法解析代码。展望前景光明的未来，如果你想要使用 [modules](https://developers.google.com/web/fundamentals/primers/modules)，并且所有需要的功能都能被目标浏览器支持，你仍然不能完全丢弃转码这一步，这可能是一个问题。

也许理解 JSX 将会被解析成什么最好的方法就是使用 [babel repl](https://babeljs.io/repl) 实际操作一次。你需要点击左侧面板的 `presets` 并且选择 `react`，这样解析器才能正确的解析代码。这之后，你就能在右侧实时看到编译生成的 JavaScript 代码。例如，你可以尝试下这段代码：

```
class A extends React.Component {
    render() {
        return (
            <div className={"class"} onclick={some}>
                {"something"}
                <div>something else</div>
            </div>
        )
    }
}
```

我的运行结果如下：

```
class A extends React.Component {
  render() {
    return React.createElement("div", {
      className: "class",
      onclick: some
    }, "something", React.createElement("div", null, "something else"));
  }
}
```

可以看到，每个 `<%tag%>` 结构都被替换成了函数 [React.createElement](https://reactjs.org/docs/react-api.html#createelement)。第一个参数是 react 组件或者内建标签名字符串（比如 `div` 或 `span`），第二个参数则是组件属性，其他的参数则都被视作组件的子元素。

我强烈推荐你使用不同结构的组件树反复尝试，来观察 React 如何渲染值为 `true`、`false`、数组、或者组件等的属性：即使你只尝试使用 JSX 和一些其他内容的代码，它也很有帮助。

> 如果你想深入学习 JSX，可以参考[官方文档](https://reactjs.org/docs/jsx-in-depth.html)

## 重命名

由于编译结果是固定的，我们其实也可以将所有的 React 代码直接以这种形式写出，但是其实这种方式存在一些问题。

第一个问题就是非常繁琐。**真的**相当繁琐，而罪魁祸首就是 `React.createElement`。所以这个问题的解决方案就是将它简写为一个变量，按照 [hyperscript](https://github.com/hyperhype/hyperscript) 的方式命名为 `h`。这种方式能节省很多代码量，并且可读性也更强。下面我们来重写上面的代码，以便说明：

```
const h = React.createElement;
class A extends React.Component {
  render() {
    return h(
      "div",
      {
        className: "class",
        onclick: some
      },
      "something",
      h("div", null, "something else")
    );
  }
}
```

## Hyperscript

如果 `React.createElement` 或者 `h` 你都已经尝试过了，你就可以看出它们都存在一些缺点。首先，函数需要三个参数，所以在没有属性的情况下，你还是必须传递 `null` 作为参数，同时，`className` 作为一个很常用的属性，在每次使用的时候都需要新建一个对象。

作为一个替代方案，你可以使用 [react-hyperscript](https://github.com/mlmorg/react-hyperscript) 库。它不需要你提供空属性，并且允许你用点号的方式定义 class 和 id（`div#main.content` -> `<div id="main" class="content">`）。这样，你的代码能优化为：

```
class A extends React.Component {
  render() {
    return h("div.class", { onclick: some }, [
      "something",
      h("div", "something else")
    ]);
  }
}
```

## HTM

如果你并不反感 JSX 本身，但是不喜欢必需的代码编译，那么你可以试试看 [htm](https://github.com/developit/htm) 这个项目。它的目标就是完成和 JSX 相同的事情（并且代码看上去也相同），但是使用的是[模版字符串](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals)。它可能会带来一些开销（因为需要在运行时将模版解析），但是在某些情况下也许也是值得的。

它的工作方式是将元素函数包裹起来，也就相当于前面例子中的 `React.createElement`，但是它支持任何其他具有类似 API 的库，同时仅在运行时编译模版并返回和 babel 编译结果一样的代码。

```
const html = htm.bind(React.createElement);
class A extends React.Component {
    render() {
        return html`
            <div className=${"class"} onclick=${some}>
                ${"something"}
                <div>something else</div>
            </div>
        `
    }
}
```

如你所见，结果**几乎**和 JSX 一样，只是我们需要以略微不同的方式插入变量；但是，大部分区别都是很细节的地方，如果你想要展示如何不使用任何构建工具来使用 React，这个工具就很方便。

## 类 Lisp 语法

它的核心思想和 hyperscript 很类似，但它采用了一个很优雅的方式，值得一看。现如今，有很多类似的帮助库，所以到底选择哪个也因人而异；而它们都有可能能给你的项目带来些灵感。

[ijk](https://github.com/lukejacksonn/ijk) 这个库的思路是只用数组来写模版，并将位置作为参数。这样写的优势在于你不需要总是写 `h`（是的，有时候总写 `h` 也会让人觉得很冗余！）。如下是一个使用案例：

```
function render(structure) {
  return h('nodeName', 'attributes', 'children')(structure)
}
class A extends React.Component {
  render() {
    return render([
      'div', { className: 'class', onClick, some}, [
        'something',
        ['div', 'something else']
      ]]);
  }
}
```

## 总结

这篇文章并不是建议你不使用 JSX，也不是说 JSX 有什么不好。但是你可能会好奇如果不用它，你要怎么写代码，还有你的代码可能会是什么样子，本文的目的就只是回答了这个问题。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
