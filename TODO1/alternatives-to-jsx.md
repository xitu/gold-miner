> * 原文地址：[Alternatives to JSX](https://blog.bloomca.me/2019/02/23/alternatives-to-jsx.html)
> * 原文作者：[Seva Zaikov](https://blog.bloomca.me/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/alternatives-to-jsx.md](https://github.com/xitu/gold-miner/blob/master/TODO1/alternatives-to-jsx.md)
> * 译者：
> * 校对者：

# Alternatives to JSX

JSX is a very popular choice nowadays for templating in various frameworks, not just in React (or JSX inspired templates). However, what if you don’t like it, or have a project where you want to avoid using it, or just curious how you can write your React code without it? The simplest answer is to read the [official documentation](https://reactjs.org/docs/react-without-jsx.html), however, it is a bit short, and there are couple more options.

> Disclaimer: Personally, I like JSX and use it in all my projects with React. However, I researched this topic for a bit and would like to share my findings.

## What is JSX

First, we need to understand what JSX _is_ in order to write matching code in pure JavaScript. JSX is a [domain-specific language](https://en.wikipedia.org/wiki/Domain-specific_language), which means that we need to transform our code with JSX in order to get regular JavaScript, otherwise browsers won’t understand our code. In the bright future, if you want to use [modules](https://developers.google.com/web/fundamentals/primers/modules) and all required features are supported in your targeted browsers, you still won’t be able to drop transformation completely, which might be an issue.

Probably the best way to understand what JSX is transpiled into is to actually do that using [babel repl](https://babeljs.io/repl). You’ll need to click on `presets` (should be in the left panel) and choose `react` there, so that it will parse it correctly. After that you’ll be able to see JavaScript code in real time on the right side. For example, you can type something like this:

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

For me, the resulted code is the following:

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

You can see that every `<%tag%>` construction was replaced with a function call [React.createElement](https://reactjs.org/docs/react-api.html#createelement). First parameter is either a react component or a string with built-in tag value (like `div` or `span`), second one is about props, and all the rest parameters are considered as children.

I highly recommend to play a bit with different trees, to see, for example, how React renders properties with `true` or `false` values, arrays, components and so on: it is helpful even if you use only JSX and pretty content with it.

> To read about JSX in depth, there is an [offical docs page](https://reactjs.org/docs/jsx-in-depth.html)

## Renaming

While the resulting code is perfectly valid, and we can write all our React code in this style, there are several problems with this approach.

The first problem is that it is extremely verbose. Like _really_ verbose, and the main offender here is `React.createElement`. So the first solution is just to save it into a variable, usually named `h` after [hyperscript](https://github.com/hyperhype/hyperscript). This will already save you a lot of text, and make it more readable. To illustrate that, let’s rewrite out past example:

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

If you play a bit with either `React.createElement` or `h`, you can see that it has several flaws. To start with, this function _requires_ 3 arguments, so in case there are no properties, you have to provide `null`, and `className`, probably the most common property, requires to write a new object every time.

As an alternative, you can use [react-hyperscript](https://github.com/mlmorg/react-hyperscript) library. It does not require to provide empty props, and also allows you to specify classes and ids in emmet-like style (`div#main.content` -\> `<div id="main" class="content">`). So, our code will become slightly better:

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

If you are not against JSX per se, but don’t like the necessity to transpile your code, then there is a project called [htm](https://github.com/developit/htm). It aims to do the same (and look the same) as JSX, but using [template literals](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals). This definitely adds some overhead (you have to parse these templates in the runtime), but it might worth it in your case.

It works by wrapping element function, which is `React.createElement` in our case, but it can be any other library with similar API, and returns a function which will parse our template and return exactly the same code as babel did, but only in the runtime.

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

As you can see, it is _almost_ the same as real JSX, we just need to insert variables in a slightly different manner; however, these are mostly details, and if you want to show how to use React without any tool setup, this might be handy.

## Lisp-like Syntax

The idea of this one is similar to hyperscript, however, it is an elegant approach worth looking at. There are many other similar helper libraries, so the choice is pure subjective; it might give an inspiration for your own projects.

The library [ijk](https://github.com/lukejacksonn/ijk) brings the idea of writing your templates using only arrays, using positions as arguments. The main advantage is that you don’t need to write `h` constantly (yes, even that can be repetetive!). Here is an example how to use it:

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

## Conclusion

This article does not say that you should not use JSX, or whether it is a bad idea. You might wonder, though, how can you write your code without it, and how your code can possibly look like, and the goal of this article was to merely answer this question.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
