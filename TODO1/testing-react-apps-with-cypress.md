> * 原文地址：[End to End Testing React Apps With Cypress](https://blog.bitsrc.io/testing-react-apps-with-cypress-658bc482678)
> * 原文作者：[Rajat S](https://medium.com/@geeky_writer_)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/testing-react-apps-with-cypress.md](https://github.com/xitu/gold-miner/blob/master/TODO1/testing-react-apps-with-cypress.md)
> * 译者：[stevens1995](https://github.com/stevens1995)
> * 校对者：[yzw7489757](https://github.com/yzw7489757)，[Baddyo](https://github.com/Baddyo)

# 使用 Cypress 进行 React 应用的端到端测试

> 关于如何使用 Cypress 对 React 应用进行端到端的测试的简要指南。

![](https://cdn-images-1.medium.com/max/2562/1*FoCFnUGcQvE2zqiFxitXUg.png)

当我还是一个初级开发者的时候我经常害怕测试我的应用。测试并不容易。但是在正确工具的帮助下，编写测试代码绝对能够变得更容易和有趣。

Cypress 是一个端到端的 JavaScript 测试框架，它使设置、编写、运行、调试测试变得非常简单。

如果你已经尝试过类似 Puppeteer 的端到端测试框架，你会注意到这些框架把浏览器变成一个气隙系统。当我们的应用变得越复杂，测试也会变得越来越难通过。这也是大多数测试人员更喜欢手动运行测试的原因。 

在本文中，我将向你展示 Cypress 如何帮助你构建在一个真实浏览器中运行的测试。Cypress 提供了一个非常易于使用的用于自动化测试的 API。

相比于看着一个充满乱七八糟命令的平淡的终端，Cypress 带有自己的仪表盘，可以准确地向我们展示测试中发生了什么。而且，由于 Cypress 在真实的浏览器中工作，我们可以在使用 Cypress 的同时使用浏览器的开发工具。

**提示**：使用 **React 组件**时，你可能想要记住组件单元测试的重要性。使用 [**Bit**](https://bit.dev/)，你可以在你的项目中创造一个可重复使用的组件目录，并添加独立运行和展示可视化结果的组件测试。快试一试吧。

[**组件发现与协作 · Bit**](https://bit.dev/)

我们开始吧。

---

## 建立

我将使用一个已经存在的项目并在上面运行我的 Cypress 测试，而不是创建一个全新的项目。

这里，我有一个用 React 编写的简单的 ToDo 应用。

[**rajatgeekyants/ToDo-List**](https://github.com/rajatgeekyants/ToDo-List)

![](https://cdn-images-1.medium.com/max/2000/1*sFtLSBvrjPNJkb66q1mIxQ.png)

在你的系统中克隆这个应用并且运行 `yarn install` 安装依赖。

```
$ git clone https://github.com/rajatgeekyants/ToDo-List.git
$ yarn install
```

**注意**：你也可以在 Bit 上查看这个应用。你可以在这里导入应用中任何特定的组件，而不需要关心其他部分。

[**todo by geekrajat · Bit**](https://bit.dev/geekrajat/todo)

有了这个，我现在可以进入应用的测试阶段。让我们安装 Cypress 作为应用的 `dev dependency`。

```
$ yarn add cypress -D
```

现在打开 Cypress，我们所要做的就是运行这个命令。

```
$ node_modules/.bin/cypress open
```

这将在你的系统上打开 Cypress CLI（命令行界面）（或者仪表盘），并且在你应用的根目录创建一个 `cypress.json` 文件和 `cypress` 文件夹。`cypress` 文件夹就是我们将要编写测试的地方。

如果你觉得打开 Cypress 的命令太长或者太难记，你可以在 `package.json` 中创建一个新的脚本：

```
"cypress": "cypress open"
```

因此，如果你使用 NPM/Yarn 运行这个脚本，应该会打开 Cypress CLI（命令行界面）。在 Cypress 文件夹下的 integration 文件夹中创建一个新的测试文件。与普通的我们命名为类似 `App.test.js` 的测试文件不同，在 Cypress 中，测试文件的扩展名为是 `.spec.js`。

```JavaScript
describe ('First Test', () => {
  it ('is working', () => {
    expect (true).to.equal (true);
  });
});
```

这是一个非常简单的测试，只检查 `true` 是否等于 `true` （明显是）。如果你打开 Cypress CLI（命令行界面），你会看到新的测试文件自动列在那里。点击测试文件将会运行测试并且在浏览器中打开仪表盘，你可以在其中看到测试结果。

![](https://cdn-images-1.medium.com/max/2000/1*Wh46Wi_P9a90q6nwwzKJ9w.png)

这个测试与 ToDo 应用无关。我只是展示下如何使用 Cypress 运行测试。现在我们开始编写我们实际应用的测试。
---

## Cypress 中的页面访问

Cypress 测试中的第一步是允许 Cypress 在浏览器中访问应用。让我们创建一个新的测试文件并在其中编写下面的代码。

```JavaScript
describe ('Second Test', () => {
  it ('Visit the app', () => {
    cy.visit ('/');
  });
});
```

在上面的代码中，我有一个叫 `cy` 的对象。这是一个全局对象，使我们可以访问所有在 Cypress API 中展示的命令。我正在使用 `cy` 访问 `visit` 命令。在这个命令中，我将要传入 `'/'`。回到根目录，转到 `cypress.json` 文件，并在文件中写下这个：

```
{
  "baseUrl": "http://localhost:3000"
}
```

现在，确保你使用 `start` 脚本运行应用。然后打开 Cypress CLI（命令行界面）并运行这个新的测试文件。你会看到仪表盘在浏览器中打开，在仪表盘中我们的应用像这样运行：

![](https://cdn-images-1.medium.com/max/2400/1*kpUn1HNHVpKEXAUNPOg3CA.png)

如果你注意到左边的命令日志，你会看到 Cypress 正在调用 XHR，以便让应用在其中打开。 

---

## 检查焦点

这里，我将要运行一个测试来检查加载后焦点是否在输入区域。

在我们做这个之前，确保在 src/components/TodoList/index.js 中的 `输入(input)` 区域有值为 `new task` 的 `className` 属性以及 `autoFocus` 属性。 

```
<input
  autoFocus
  className="new task"
  ref={a => (this._inputElement = a)}
  placeholder="enter task"
/>
```

没有这些属性，我们的测试肯定会失败。创建一个新的包含下面代码的测试文件：

```JavaScript
describe ('Third Test', () => {
  it ('Focus on the input', () => {
    cy.visit ('/');
    cy.focused ().should ('have.class', 'new task');
  });
});
```

首先，我在 Cypress 的仪表盘中 `visit`应用。一旦应用在仪表盘中打开，我就检查 `focused` 元素是否有 `new task` `类（class）`。

![](https://cdn-images-1.medium.com/max/2000/1*egylykedXJ2NpY0K0_t4Ag.png)

---

## 测试受控输入

在这个测试中，我将会检查受控输入是否接收文本并且正确设置其值。

```JavaScript
describe ('Third Test', () => {
  it ('Accepts input', () => {
    const text = 'New Todo';
    cy.visit ('/');
    cy.get ('.new').type (text).should ('have.value', text);
  });
});
```

在这个测试中，我首先在 Cypress 仪表盘中 `visit` 应用。现在我想要 Cypress 在输入区域中输入一些内容。为了找到输入区域正确的选择器，点击 `Open Selector Playground` 按钮并且点击输入区域。

![](https://cdn-images-1.medium.com/max/2000/1*MfeHIpz2_SYwcUY0raMdaQ.gif)

获得输入区域的选择器之后，我将会让 Cypress 在里面输入一些文本。为了确保 Cypress 输入正确的文本，我使用了 `should` 命令。

![](https://cdn-images-1.medium.com/max/2000/1*pVSMDn4gdsvA3iWtucBhJg.png)

---

## 运行不包含任何 UI 的测试

在包含大量测试的情况下， UI 会使我们的应用运行起来很慢。反正在持续集成期间看不到任何 UI，那为什么还要加载它呢？

要在不启动任何 Cypress UI 的情况下运行我们的测试，我们首先在 `package.json` 文件中添加一个新的脚本。

```
"cypress:all": "cypress run"
```

通过运行这个脚本，Cypress 将会运行所有的测试，并直接在命令终端本身提供结果。

![](https://cdn-images-1.medium.com/max/2000/1*5ohUyAlbFGgkmO7_K2hI0w.png)

如果你担心自己实际上没有看到 Cypress 进行测试，Cypress 甚至会录制测试视频供你观看。

---

## 在 Cypress 中创建端到端的测试

当我们将它用于集成测试时，Cypress 最有用。但是端到端测试可以确保整个应用不遗漏任何内容。

```JavaScript
describe ('Sixth Tests', () => {
  context ('No Todos', () => {
    it ('Adds a new todo', () => {
      cy.visit ('/');
      cy.get ('.new').type ('New todo').type ('{enter}');
    });
  });
});
```

这里，我创建了一个端到端测试。我首先让 Cypress `visit` 该应用。然后 Cypress 会用文本框（input）的选择器 .new 获取到它。再然后 Cypress 将会输入文本 `New Todo`。最后我让 Cypress 模拟键入 enter（回车），因此创造了一个新的 Todo。

![](https://cdn-images-1.medium.com/max/2000/1*wcIDOda8sVB_ROYIlCEdww.gif)

---

## 下一步是什么？

Cypress 还可以做许多其他事情。比如，我们可以测试一个功能的变化，或者我们可以访问测试的逐步日志。此外，Cypress 可以在 React 服务端渲染应用做许多其他事情，我将会在下一篇文章中介绍这些内容。

---

## 拓展学习

* [**5 Tools For Faster Development In React**](https://blog.bitsrc.io/5-tools-for-faster-development-in-react-676f134050f2)
* [**Testing your React App with Puppeteer and Jest**](https://blog.bitsrc.io/testing-your-react-app-with-puppeteer-and-jest-c72b3dfcde59)
* [**How to Test React Components using Jest and Enzyme**](https://blog.bitsrc.io/how-to-test-react-components-using-jest-and-enzyme-fab851a43875)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
