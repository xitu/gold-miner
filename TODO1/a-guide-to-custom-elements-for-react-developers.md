> * 原文地址：[A Guide to Custom Elements for React Developers](https://css-tricks.com/a-guide-to-custom-elements-for-react-developers/)
> * 原文作者：[CHARLES PETERS](https://css-tricks.com/author/charlespeters/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-guide-to-custom-elements-for-react-developers.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-guide-to-custom-elements-for-react-developers.md)
> * 译者：
> * 校对者：

# A Guide to Custom Elements for React Developers

I had to build a UI recently and (for the first time in a long while) I didn't have the option of using React.js, which is my preferred solution for UI these days. So, I looked at what the built-in browser APIs had to offer and saw that using [custom elements](https://css-tricks.com/modular-future-web-components/) (aka Web Components) may just be the remedy that this React developer needed.

Custom elements can offer the same general benefits of React components without being tied to a specific framework implementation. A custom element gives us a new HTML tag that we can programmatically control through a native browser API.

Let's talk about the benefits of component-based UI:

*   **Encapsulation** — concerns scoped to that component remain in that component's implementation
*   **Reusability** — when the UI is separated into more generic pieces, they're easier to break into patterns that you're more likely to repeat
*   **Isolation** — because components are designed to be encapsulated and with that, you get the added benefit of isolation, which allows you scope bugs and changes to a particular part of your application easier

### Use cases

You might be wondering who is using custom elements in production. Notably:

*   [GitHub](https://githubengineering.com/removing-jquery-from-github-frontend/#custom-elements) is using custom elements for their modal dialogs, autocomplete and display time.
*   YouTube's [new web app](https://youtube.googleblog.com/2017/05/a-sneak-peek-at-youtubes-new-look-and.html) is built with [Polymer](https://www.polymer-project.org/) and web components.

### Similarities to the Component API

When trying to compare React Components versus custom elements, I found the APIs really similar:

*   They're both classes that aren't "new" and are able that extend a base class
*   They both inherit a mounting or rendering lifecycle
*   They both take static or dynamic input via props or attributes

### Demo

So, let's build a tiny application that lists details about a GitHub repository.

![Screenshot of end result](https://css-tricks.com/wp-content/uploads/2018/10/screenshot-demo.png)

If I were going to approach this with React, I would define a simple component like this:

```
<Repository name="charliewilco/obsidian" />
```

This component takes a single prop — the name of the repository — and we implement it like this:

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

See the Pen [React Demo - GitHub](https://codepen.io/charliewilco/pen/jeVMvK/) by Charles ([@charliewilco](https://codepen.io/charliewilco)) on [CodePen](https://codepen.io).

To break this down further, we have a component that has its own state, which is the repo details. Initially, we set it to be `null` because we don't have any of that data yet, so we'll have a loading indicator while the data is fetched.

During the React lifecycle, we'll use fetch to go get the data from GitHub, set up the card, and trigger a re-render with `setState()` after we get the data back. All of these different states the UI takes are represented in the `render()` method.

### Defining / Using a Custom Element

Doing this with custom elements is a little different. Like the React component, our custom element will take a single attribute — again, the name of the repository — and manage its own state.

Our element will look like this:

```
<github-repo name="charliewilco/obsidian"></github-repo>
<github-repo name="charliewilco/level.css"></github-repo>
<github-repo name="charliewilco/react-branches"></github-repo>
<github-repo name="charliewilco/react-gluejar"></github-repo>
<github-repo name="charliewilco/dotfiles"></github-repo>
```

See the Pen [Custom Elements Demo - GitHub](https://codepen.io/charliewilco/pen/MPbeBv/) by Charles ([@charliewilco](https://codepen.io/charliewilco)) on [CodePen](https://codepen.io).

To start, all we need to do to define and register a custom element is create a class that extends the `HTMLElement` class and then register the name of the element with `customElements.define()`.

```
class OurCustomElement extends HTMLElement {}
window.customElements.define('our-element', OurCustomElement);
```

And we can call it:

```
<our-element></our-element>
```

This new element isn't very useful, but with custom elements, we get three methods to expand the functionality of this element. These are almost analogous to React’s [lifecycle methods](https://reactjs.org/docs/state-and-lifecycle.html#adding-lifecycle-methods-to-a-class) for their Component API. The two lifecycle-like methods most relevant to us are the `disconnectedCallBack` and the `connectedCallback` and since this is a class, it comes with a constructor.

| Name | Called when |
| ---- | ----------- |
| `constructor` | An instance of the element is created or upgraded. Useful for initializing state, settings up event listeners, or creating Shadow DOM. See the spec for restrictions on what you can do in the `constructor`. |
| `connectedCallback` | The element is inserted into the DOM. Useful for running setup code, such as fetching resources or rendering UI. Generally, you should try to delay work until this time. |
| `disconnectedCallback` | When the element is removed from the DOM. Useful for running clean-up code. |

To implement our custom element, we'll create the class and set up some attributes related to that UI:

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

By calling `super()` in our constructor, the context of this is the element itself and all the DOM manipulation APIs can be used. So far, we've set the default repository details to `null`, gotten the repo name from element's attribute, created an endpoint to call so we don't have to define it later and, most importantly, set the initial HTML to be a loading indicator.

In order to get the details about that element’s repository, we’re going to need to make a request to GitHub’s API. We’ll use `fetch` and, [since that's Promise-based](https://css-tricks.com/using-data-in-react-with-the-fetch-api-and-axios/), we'll use `async` and `await` to make our code more readable. You can learn more about the `async`/`await` keywords [here](https://davidwalsh.name/async-await) and more about the browser's fetch API [here](https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API). You can also [tweet at me](https://twitter.com/charlespeters) to find out whether I prefer it to the [Axios](https://www.axios.com/) library. (Hint, it depends if I had tea or coffee with my breakfast.)

Now, let's add a method to this class to ask GitHub for details about the repository.

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

Next, let's use the `connectedCallback` method and the Shadow DOM to use the return value from this method. Using this method will do something similar as when we called `Repository.componentDidMount()` in the React example. Instead, we'll override the `null` value we initially gave `this.repoDetails` — we'll use this later when we start to call the template to create the HTML.

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

You'll notice that we're calling methods related to the Shadow DOM. Besides being a rejected title for a Marvel movie, the Shadow DOM has its own [rich API](https://developer.mozilla.org/en-US/docs/Web/Web_Components/Using_shadow_DOM) worth looking into. For our purposes, though, it's going to abstract the implementation of adding `innerHTML` to the element.

Now we're assigning the `innerHTML` to be equal to the value of `this.template`. Let's define that now:

```
class Repository extends HTMLElement {
  get template() {
    const repo = this.repoDetails;
  
    // if we get an error message let's show that back to the user
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

That's pretty much it. We've defined a custom element that manages its own state, fetches its own data, and reflects that state back to the user while giving us an HTML element to use in our application.

After going through this exercise, I found that the only required dependency for custom elements is the browser's native APIs rather than a framework to additionally parse and execute. This makes for a more portable and reusable solution with similar APIs to the frameworks you already love and use to make your living.

There are drawbacks of using this approach, of course. We're talking about various browser support issues and some lack of consistency. Plus, working with DOM manipulation APIs can be very confusing. Sometimes they are assignments. Sometimes they are functions. Sometimes those functions take a callback and sometimes they don't. If you don't believe me, take a look at adding a class to an HTML element created via `document.createElement()`, which is one of the top five reasons to use React. The basic implementation isn’t that complicated but it is inconsistent with other similar `document` methods.

The real question is: does it even out in the wash? Maybe. React is still pretty good at the things it's designed to be very very good at: the virtual DOM, managing application state, encapsulation, and passing data down the tree. There's next to no incentive to use custom elements inside that framework. Custom elements, on the other hand, are simply available by virtue of building an application for the browser.

### Learn more

*   [Custom Elements v1: Reusable Web Components](https://developers.google.com/web/fundamentals/web-components/customelements)
*   [Make a Native Web Component with Custom Elements v1 and Shadow DOM v1](https://bendyworks.com/blog/native-web-components)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
