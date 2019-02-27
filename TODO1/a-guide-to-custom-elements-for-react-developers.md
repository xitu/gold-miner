> * 原文地址：[A Guide to Custom Elements for React Developers](https://css-tricks.com/a-guide-to-custom-elements-for-react-developers/)
> * 原文作者：[CHARLES PETERS](https://css-tricks.com/author/charlespeters/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-guide-to-custom-elements-for-react-developers.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-guide-to-custom-elements-for-react-developers.md)
> * 译者：[子非](https://www.github.com/CoolRice)
> * 校对者：[Xcco](https://github.com/Xcco), [Ivocin](https://github.com/Ivocin)

# 写给 React 开发者的自定义元素指南

最近我需要构建 UI 界面，虽然现在 React.js 是我更为青睐的 UI 解决方案，不过长时间以来我第一次没有选择用它。然后我看了浏览器内置的 API 发现使用[自定义元素](https://css-tricks.com/modular-future-web-components/)（也就是 Web 组件）可能正是 React 开发者需要的方案。

自定义元素可以具有与 React 组件大致相同的优点，而且实现起来无需绑定特定的框架。自定义元素能提供新的 HTML 标签，我们可以使用原生浏览器的 API，用编程的方式操控它。

让我们说说基于组件的 UI 优点：

*  **封装** — 把专注点放在组件的内部实现上
*  **复用** — 当把 UI 分割成更通用的小块时，它们更容易分解为你可以复用的形态
*  **隔离** — 因为组件是被封装过的，你能获得隔离带来的额外好处，即让你更轻松地定位错误和更易修改应用中的特定部分

### 用例

你可能想知道有谁在生产环境中使用自定义元素。比较出名的有：

*   [GitHub](https://githubengineering.com/removing-jquery-from-github-frontend/#custom-elements) 在模态对话框、自动补全和显示时间三个功能上使用了自定义元素。
*   YouTube 的[新 Web 应用](https://youtube.googleblog.com/2017/05/a-sneak-peek-at-youtubes-new-look-and.html)使用了 [Polymer](https://www.polymer-project.org/) 和 Web 组件。

### 和组件 API 的相似点

当试图比较 React 组件和自定义组件时，我发现它们的 API 非常相似：

*   它们都是类，而类已经不是新的概念了，并且都能扩展自基类
*   它们都继承挂载或渲染生命周期
*   它们都需要通过 props 或 attributes 来静态或动态传入数据

### 演示

那么，让我们来构建一个小型应用，提供 GitHub 仓库的详细信息列表。

![结果截图](https://css-tricks.com/wp-content/uploads/2018/10/screenshot-demo.png)

如果我要用 React 来实现，我会定义一个如下的简单组件：

```
<Repository name="charliewilco/obsidian" />
```

这个组件需要一个 prop —— 仓库名，我们要这么实现它：

```
class Repository extends React.Component {
  state = {
    repo: null
  };

  async getDetails(name) {
    return await fetch(`https://api.github.com/repos/${name}`, {
      mode: 'cors'
    }).then(res => res.json());
  }

  async componentDidMount() {
    const { name } = this.props;
    const repo = await this.getDetails(name);
    this.setState({ repo });
  }

  render() {
    const { repo } = this.state;

    if (!repo) {
      return <h1>Loading</h1>;
    }

    if (repo.message) {
      return <div className="Card Card--error">Error: {repo.message}</div>;
    }

    return (
      <div class="Card">
        <aside>
          <img
            width="48"
            height="48"
            class="Avatar"
            src={repo.owner.avatar_url}
            alt="Profile picture for ${repo.owner.login}"
          />
        </aside>
        <header>
          <h2 class="Card__title">{repo.full_name}</h2>
          <span class="Card__meta">{repo.description}</span>
        </header>
      </div>
    );
  }
}
```

请看 Charles ([@charliewilco](https://codepen.io/charliewilco)) 在 [CodePen](https://codepen.io) 上的 [React 演示 — GitHub](https://codepen.io/charliewilco/pen/jeVMvK/)。

来深入看一下，我们有一个组件，这个组件有它自己的状态，即仓库的详细信息。开始时，我们把它设为 `null`，因为此时还没有任何数据，所以在加载数据时会有一个加载提示。

在 React 的生命周期中，我们使用 fetch 从 GitHub 获得数据，创建选项卡，然后在我们拿到返回数据后使用 `setState()` 触发一次重新渲染。所有 UI 使用的不同状态都会在 `render()` 方法里表现出来。

### 定义/使用自定义元素

使用自定义元素实现起来稍有不同。和 React 组件一样，我们的自定义元素也需要一个属性 —— 仓库名，它的状态也是自己管理的。

如下就是我们的元素：

```
<github-repo name="charliewilco/obsidian"></github-repo>
<github-repo name="charliewilco/level.css"></github-repo>
<github-repo name="charliewilco/react-branches"></github-repo>
<github-repo name="charliewilco/react-gluejar"></github-repo>
<github-repo name="charliewilco/dotfiles"></github-repo>
```

请看 Charles ([@charliewilco](https://codepen.io/charliewilco)) 在 [CodePen](https://codepen.io) 上的[自定义元素演示 — GitHub](https://codepen.io/charliewilco/pen/MPbeBv/)。

现在，我们所需要做的就是定义和注册自定义元素，创建一个类，它继承自 `HTMLElement` 类，然后用 `customElements.define()` 注册元素的名字。

```
class OurCustomElement extends HTMLElement {}
window.customElements.define('our-element', OurCustomElement);
```

它是这样调用的：

```
<our-element></our-element>
```

这个新元素现在还不是很有用，但是有它之后，我们能用三个方法来扩展这个元素的功能。这些方法类似于 React 组件的 [生命周期](https://reactjs.org/docs/state-and-lifecycle.html#adding-lifecycle-methods-to-a-class) API。两个和我们最相关的类生命周期函数是 `disconnectedCallBack` 和 `connectedCallback`，而且由于自定义元素是一个类，它自然会有一个构造器。

| 名字 | 何时调用 |
| ---- | ----------- |
| `constructor` | 用来创建或更新元素的实例。常用来初始化状态、设置事件监听或创建 Shadow DOM。如果你想知道在 `constructor` 可以做什么，请查看设计规范。 |
| `connectedCallback` | 在元素被插入 DOM 后调用。用来运行创建任务的代码，例如获取资源或渲染 UI。总体上说，你应该在这里尝试异步任务。 |
| `disconnectedCallback` | 在元素被移出 DOM 后调用。用来运行做清理任务的代码。 |

为了实现我们的自定义元素，我们创建了如下类并设置了和 UI 相关的属性：

```
class Repository extends HTMLElement {
  constructor() {
    super();

    this.repoDetails = null;

    this.name = this.getAttribute("name");
    this.endpoint = `https://api.github.com/repos/${this.name}`    
    this.innerHTML = `<h1>Loading</h1>`
  }
}
```

通过在我们的构造器中调用 `super()`，元素自己的上下文和 DOM 操作 API 就可以使用了。目前，我们已经设置了默认的仓库详情为 `null`，从元素属性取得仓库名，创建一个用来调用的 endpoint，这样我们不用在后面定义，最重要的是，将初始的 HTML 设置成了加载提示。

为了获取关于元素仓库的详情，我们将需要向 GitHub 的 API 发送请求。我们使用 `fetch`，[由于它是基于 Promise 的](https://css-tricks.com/using-data-in-react-with-the-fetch-api-and-axios/)，我们使用 `async` 和 `await` 来使我们的代码更易阅读。你可以[在这里](https://davidwalsh.name/async-await)了解更多关于 `async`/`await` 关键字，并且可以[在这里](https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API)了解更多浏览器的 fetch API 的内容。你还可以[在 Twitter 上和我讨论](https://twitter.com/charlespeters)，了解我是否更喜欢 [Axios](https://www.axios.com/) 库。（提示，这取决于我早餐时喝了茶还是咖啡。）

现在，让我们给这个类添加方一个方法来向 GitHub 查询仓库详情。

```
class Repository extends HTMLElement {
  constructor() {
  // ...
  }

  async getDetails() {
    return await fetch(this.endpoint, { mode: "cors" }).then(res => res.json());
  }
}
```

下面，让我们使用 `connectedCallback` 方法和 Shadow DOM 来使用 `getDetails` 方法的返回值。使用这个方法的效果和我们在 React 示例中调用 `Repository.componentDidMount()` 类似。我们将开始时赋给`this.repoDetails` 的 `null` 替换掉 —— 并将在后面调用模板创建 HTML 时使用它。

```
class Repository extends HTMLElement {
  constructor() {
    // ...
  }

  async getDetails() {
    // ...
  }

  async connectedCallback() {
    let repo = await this.getDetails();
    this.repoDetails = repo;
    this.initShadowDOM();
  }

  initShadowDOM() {
    let shadowRoot = this.attachShadow({ mode: "open" });
    shadowRoot.innerHTML = this.template;
  }
}
```

你会注意到我们正在调用与 Shadow DOM 相关的方法。除了作为被漫威电影拒绝的标题之外，Shadow DOM 还有自己[丰富的 API](https://developer.mozilla.org/en-US/docs/Web/Web_Components/Using_shadow_DOM) 值得研究。为了我们的目标，它将抽象出一种将 `innerHTML` 添加到元素的实现。

现在我们将 `this.template` 赋值给 `innerHTML`。现在来定义 `template`：

```
class Repository extends HTMLElement {
  get template() {
    const repo = this.repoDetails;

    // 如果获取错误信息，向用户显示提示信息
    if (repo.message) {
      return `<div class="Card Card--error">Error: ${repo.message}</div>`
    } else {
      return `
      <div class="Card">
        <aside>
          <img width="48" height="48" class="Avatar" src="${repo.owner.avatar_url}" alt="Profile picture for ${repo.owner.login}" />
        </aside>
        <header>
          <h2 class="Card__title">${repo.full_name}</h2>
          <span class="Card__meta">${repo.description}</span>
        </header>
      </div>
      `
    }
  }
}
```

自定义元素差不多就是这样。自定义元素可以管理自身状态、获取自身数据及将状态体现给用户，同时提供了可以在应用程序里使用的 HTML 元素。

在完成本次练习之后，我发现自定义元素唯一需要的依赖是浏览器的原生 API 而不是另外需要解析和执行的框架。这是一个更具可移植性和可复用性的解决方案，而且这个方案和你喜欢并用之谋生的框架的 API 很相似。

当然，这种方法也有缺点，我们说的是不同浏览器的支持问题和缺乏一致性。此外，DOM 操作 API 可能会十分混乱。有时它们是赋值。有时它们是函数。有时这些方法需要回调函数而有时又不需要。如果你不相信，那就去看一下使用 `document.createElement()` 将类添加进 HTML 元素的方法，这是使用 React 的五大理由之一。基本实现其实并不复杂，但它与其他类似的 `document` 方法不一致。

现实的问题是：它是否会被淘汰？也许会。React 仍然在它该擅长的东西上表现良好：虚拟 DOM、管理应用状态、封装和在树中向下传递数据。现在几乎没有在该框架中使用自定义元素的动力。另一方面，自定义元素在制作浏览器应用上非常简单实用。

### 了解更多

*   [Custom Elements v1：可重用的 Web Components](https://developers.google.com/web/fundamentals/web-components/customelements)
*   [使用 Custom Elements v1 和 Shadow Dom v1 制作原生 Web Components](https://bendyworks.com/blog/native-web-components)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
