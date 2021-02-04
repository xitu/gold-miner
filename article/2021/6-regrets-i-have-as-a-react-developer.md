> * 原文地址：[6 Regrets I Have As a React Developer](https://medium.com/better-programming/6-regrets-i-have-as-a-react-developer-52e95a8ff8a4)
> * 原文作者：[Mohammad Faisal](https://medium.com/@56faisal)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/6-regrets-i-have-as-a-react-developer.md](https://github.com/xitu/gold-miner/blob/master/article/2021/6-regrets-i-have-as-a-react-developer.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：

# 我后悔没有在成为 React 开发者之时做的 6 件事

![Photo by [Francisco Gonzalez](https://unsplash.com/@franciscoegonzalez?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/sadness?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/8396/1*b_I4LDS0bICAcnC1bdOM2g.jpeg)

React 是一个很好的去学习的工具，它让我们能够以我们自己的方法编写代码完成任务。它是非常强大，但是它也有不少的限制。

对于新的开发者而言，没有明确的指南告诉我们哪一款语言对应哪一种情况是最好的工具，因此对于每一个问题而言，都有各种各样的解决方案。并且我非常肯定的是，我同样掉到了这个坑里面，并且已经无力回天去适应别的更好的实践方法了。

今天我将要分享我最应该在我的 React 开发旅程前期应该开始做的 6 件事。

## 1. 测试

长期以来，测试是我的弱项。我并没有为 React 的组件编写测试，并且正如预期的那样，我常常不得不为了某些输入错误而调试。

但即便测试这个词语看起来很令人畏缩，在 React 中进行测试真的是很简单的一件事情（对于大多数情况而言）。

只需要花费两分钟去编写代码我们就可以添加一个非常简单的测试，但是这个测试可以在未来的运行中节省大量的时间去调试。这里就是一个测试 `Title` 组件渲染是否正确的测试：

```js
it('checks if the title component is in the document', () => {
    expect(screen.getByText('Title')).toBeInTheDocument()
})
```

而如果你使用的是 `create-react-app` 命令创建你的 React 应用程序，那系统已经正确地为你设置好了测试套件，只需要尽早地开始编写测试代码即可。

## 2. 使用正确的文件夹结构

我想作为一名 React 的新手，我最大的错误是没有使用正确的文件夹结构。本质上我将文件按照他们的类别分类：

```
|-store
  |--actions
    |---UserAction.js
    |---ProductAction.js
    |---OrderAction.js
  |--reducers
    |---UserReducer.js
    |---ProductReducer.js
    |---OrderReducer.js
```

但当项目逐步变大以后，我发现寻找文件变得困难了许多。

因此我最终还是开始按照文件的功能去整理排序，这意味着所有类似的文件将放在一个同样的文件夹下面，例如：

```
|-store
  |--user
    |---UserAction.js
    |---UserReducer.js
  |--product    
    |---ProductAction.js
    |---ProductReducer.js
  |--order    
    |---OrderAction.js
    |---OrderReducer.js
```

现在对我而言在文件系统中导航到我想要查看的文件变得简单了许多！

## 3. 使用样式化的组件

我一开始使用 `css` 文件去给我的组件添加样式，但是随着时间的推进以及项目的扩大，这真的变得越发混乱。

在一段时间以后我了解并学习了 `sass`，而它真是棒极了！虽然它在原味 `css` 上提供了些语法糖，但给我的组件加样式还是真的困难，尤其是在重复使用某些样式的时候 —— 我总是会忘记我已经编写了这一种样式在我的样式表中了。

```
// inside jsx
<button className="btn-submit">

<button/>


// inside css files
.btn-submit {

}
```

同样对我来说，我并不喜欢 `JSX` 的 `className` 属性。

过了一段时间我发现了一个可以拯救我的叫做 `styled-components` 的库。现在我仅仅需要对不同的组件定义我的样式，而我的代码也变得干净了许多，阅读起来也舒服、轻松了许多。

同样的，这个组件也支持 `props` 属性，帮助我大量地减少了特定条件下的特殊样式。

```jsx
const Button = styled.button`
  font-size: 1em;
  margin: 1em;
  padding: 0.25em 1em;
  border-radius: 3px;
`;
```

## 4. 尽早转向使用功能化控件

在一开始我被介绍使用 `class-components` 然后对于接下来的一年我甚至**只**使用了基于类的控件。

当我转向使用给予功能的控件后，我发现了它们巨大的好处。我想 `react-hooks` 是自 React 出现以来的唯一的最好的东西。

但现在几乎没有任何原因让人们尝试使用基于类的组件。

而现在，我正尝试着将所有组件重写为功能组件。

## 5. 使用表单处理库

处理表单可能是任何应用程序中最常见的功能之一，但当我花了很多时间尝试使用原生的 `onChange` 方法的时候，我发现使用这个功能处理数据和验证真的非常痛苦！

**直到我发现 `Formik` 和 `react-hook-form`。**

使用这两个库能让表单处理变得更加容易和简洁。最重要的是，表单验证现在对我来说是简单声明就可完成的，变得极度容易。

## 6.使用 Linter 和 Formatter

长时间以来，手动格式化我的代码是一件很麻烦的事情。我喜欢我的代码整洁干净，因此每次需要：

* 删除未使用的变量
* 删除未使用的功能
* 删除未使用的进口
* 使用适当的缩进

而在遇到`Eslint`和`Prettier`之前，我不得不手动完成这些。但我发现了这两个库能让痛苦的格式化工作变得容易！

因此，这些是我希望在职业生涯早期开始使用的前 6 个库，你的想法是什么呢？

感谢阅读，祝你有个明媚的好日子嗷！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
