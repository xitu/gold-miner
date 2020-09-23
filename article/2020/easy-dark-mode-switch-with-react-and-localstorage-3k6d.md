> * 原文地址：[Easy Dark Mode Switch with React and localStorage](https://dev.to/alekswritescode/easy-dark-mode-switch-with-react-and-localstorage-3k6d)
> * 原文作者：[Aleks Popovic](https://dev.to/alekswritescode)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/easy-dark-mode-switch-with-react-and-localstorage-3k6d.md](https://github.com/xitu/gold-miner/blob/master/article/2020/easy-dark-mode-switch-with-react-and-localstorage-3k6d.md)
> * 译者：[Inchill](https://github.com/Inchill)
> * 校对者：[plusmultiply0](https://github.com/plusmultiply0)、[HurryOwen](https://github.com/HurryOwen)

# 使用 React 和 localStorage 实现的简易 Dark Mode 开关

![7x4y32vfxgcyhx8rggob](https://user-images.githubusercontent.com/5164225/93171400-990be680-f75b-11ea-809a-0dac5d0f83a8.jpeg)

在网站或应用程序上使用深色模式已经非常流行。许多大型网站和应用程序都在开发自己的版本，如果您想为自己的 React 应用程序制作一个版本，只需很少的 JavaScript 代码和一些自定义 CSS 就可以轻松实现。

我将向您展示如何制作一个简单但多功能的 React 组件，您可以使用该组件将网站的模式从浅色更改为深色。如果需要，您之后可以扩展它来处理多个应用程序皮肤或主题。

我启动了一个新的 create-react-app 项目，并通过向 App 组件中添加一些 HTML 对其进行了一些修改。里面有一个简单的导航栏，一些文本段落和一个图像 div，我们将使用它们来演示如何在不同页面模式之间切换图像背景。

我还在 components 文件夹中创建了一个新组件，并将其命名为 DarkMode.js。我们还将添加一个 CSS 样式文件，命名为 DarkMode.css。我们可以立即将它们都导入 App 组件中。 

```jsx
import React from "react"
import "./styles/App.css"
import DarkMode from "./components/DarkMode"

function App() {
  return (
    <div className="App">
      <nav>
        <a href="/">Home</a>
        <a href="/">Projects</a>
        <a href="/">About</a>
        <a href="/">Contact</a>
        <DarkMode />
      </nav>
      <h1>Hello World</h1>
      <div id="image"></div>
      <p>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum eget
        scelerisque neque, quis scelerisque erat. Quisque venenatis molestie
        sapien, dapibus viverra nulla hendrerit eget. Pellentesque egestas
        ultrices accumsan. Ut ac magna vel ex maximus ultricies. Nulla facilisi.
        Suspendisse gravida sem eu odio mattis ullamcorper. Curabitur feugiat
        ipsum vel vulputate ultricies.
      </p>
      <p>
        Praesent pulvinar faucibus risus in iaculis. Sed erat felis, pretium sit
        amet ultricies non, porta et lacus. Curabitur a urna mi. Sed eleifend
        sed erat eget viverra. Quisque sit amet purus viverra massa posuere
        congue. Suspendisse efficitur venenatis enim, id hendrerit enim ultrices
        sed. Nam sed dapibus nisi.
      </p>
    </div>
  )
}
export default App
```

我们现在开始构建这个组件，使其成为没有输入的常量，并将其默认导出。它的基本功能是返回一个 button 元素，我们将使用它来更改模式或主题。让我们立即导入 CSS 文件，稍后我们将更改其内容。

```jsx
import React from "react";
import "../styles/DarkMode.css";

const DarkMode = () => {
  return (
    <button></button>
  );
};

export default DarkMode;
```

为了使一切正常，我们需要设置一些属性。

```jsx
import React from "react";
import "../styles/DarkMode.css";

const DarkMode = () => {
  let clickedClass = "clicked";
  const body = document.body;
  const lightTheme = "light";
  const darkTheme = "dark";
  let theme;

  return (
    <button></button>
  );
};

export default DarkMode;
```

body 是文档的 body 元素。我们需要对其进行引用，因此当我们点击深色模式按钮时，便可以对其应用不同的样式。lightTheme 和 darkTheme 将成为我们应用于 body 的类名称。theme 是一个本地属性，我们将使用它来处理当前选择的主题或模式。

当我们单击按钮时，clicked 类将被应用于按钮。这样，我们将发出信号通知其状态变更。既然我们提到了状态，您可能会想知道我们是否会使用 React 的 state 来建立我们的逻辑，答案是否，我们不会。我们可以这样做，但这是一个非常简单的用例，并不需要它。我们要做的是使用 localStorage，它是浏览器的内部存储空间，专为这样简单的用法而设计。它的内存容量有限，并且被认为是不安全的，但它非常适合这样一种情况，即只需要跟踪单个属性值。本地存储也非常方便，因为当您切换页面或完全关闭浏览器时，它的值将保持不变，因此您可以设置这些值，而不必担心它们被删除或过期。

就 JavaScript 而言，localStorage 是一个对象，它是 window 对象的一部分，因此我们可以直接访问它并尝试查找存储在其中的项。为此，我们使用 getItem 函数并传入要查找的属性。

```jsx
import React from "react";
import "../styles/DarkMode.css";

const DarkMode = () => {
  let clickedClass = "clicked";
  const body = document.body;
  const lightTheme = "light";
  const darkTheme = "dark";
  let theme;

  if (localStorage) {
    theme = localStorage.getItem("theme");
  }

  if (theme === lightTheme || theme === darkTheme) {
    body.classList.add(theme);
  } else {
    body.classList.add(lightTheme);
  }

  return (
    <button></button>
  );
};

export default DarkMode;
```

在本例中，我们希望找到两个值中的一个 —— light 或 dark，因为这是我们将在 localStorage 中设置的值。如果我们找到这样的值，我们将把 CSS 类添加到文档 body 中。如果没有找到，我们将通过设置 light 类来默认使用浅色模式。当然，如果您想要深色模式作为默认值，您也可以设置 dark 类。

为了使我们的按钮能够在点击时执行某些操作，我们需要为其设置一个点击事件，我们将其称为 switchTheme 函数。我们还将向按钮添加一个 id，以便以后可以更轻松地对其进行样式设置；如果启用了深色模式，我们将向它添加 clicked 类。

```jsx
import React from "react";
import "../styles/DarkMode.css";

const DarkMode = () => {
  let clickedClass = "clicked";
  const body = document.body;
  const lightTheme = "light";
  const darkTheme = "dark";
  let theme;

  if (localStorage) {
    theme = localStorage.getItem("theme");
  }

  if (theme === lightTheme || theme === darkTheme) {
    body.classList.add(theme);
  } else {
    body.classList.add(lightTheme);
  }

  const switchTheme = (e) => {
    if (theme === darkTheme) {
      body.classList.replace(darkTheme, lightTheme);
      e.target.classList.remove(clickedClass);
      localStorage.setItem("theme", "light");
      theme = lightTheme;
    } else {
      body.classList.replace(lightTheme, darkTheme);
      e.target.classList.add(clickedClass);
      localStorage.setItem("theme", "dark");
      theme = darkTheme;
    }
  };

  return (
    <button
      className={theme === "dark" ? clickedClass : ""}
      id="darkMode"
      onClick={(e) => switchTheme(e)}
    ></button>
  );
};

export default DarkMode;
```

switchTheme 函数将检查哪个主题当前处于活动状态，并根据该主题执行一些不同的操作。如果当前处于深色模式，它将把深色主题类替换为浅色主题类。除此之外，它还将从深色模式按钮中删除 clicked 类，并将 localStorage 中存储的 theme 属性设置为 light。最后，我们将 theme 属性设置为 lightTheme，因为深色模式将不再处于活动状态。

如果深色模式已经关闭，而我们想要打开它。为了做到这一点，我们将做几乎和以前一样的事情。我们将浅色主题类 light 替换为深色主题类 dark，并将按钮标记为 clicked，将 localStorage 存储的 theme 属性设置为 dark，最后将 theme 设置为 darkTheme。

这样，我们的组件就完成了，我们可以将其导入到 App 组件中。现在我们需要设置它的 CSS。

```css
#darkMode {
  background: transparent url("../moon.png") no-repeat center;
  background-size: 30px 30px;
  width: 45px;
  height: 45px;
  filter: grayscale(100%);
  border: none;
  border-radius: 50%;
  transition: background-color 0.3s ease-in-out, filter 0.3s ease-in-out;
}

#darkMode:hover,
#darkMode:focus {
  filter: none;
  background-color: black;
  cursor: pointer;
}

#darkMode.clicked {
  filter: none !important;
  background-color: black;
}
```

我们的按钮具有叫做 darkMode 的 id，因此我们将使用它来设置其样式。对于背景图像，我使用在 [flaticon.com](https://www.flaticon.com/free-icon/moon_768442) 上找到的月亮图标。我正在设置其尺寸和边框，使其形状像一个圆形，并为其添加了灰度过滤器，因此在默认的未点击状态下，它看起来是灰色的。

对于悬停和聚焦状态，我们将移除过滤器并将背景设置为黑色，这样图标看起来就像一个以星空为背景的黄色的月亮。我们将对按钮具有的 clicked 类执行相同的操作。

我们的组件 CSS 现在已经设置好了，我们需要处理两个 body 类，一个用于深色模式，一个用于浅色模式。为了在两种不同的外观之间改变，我们将使用 CSS 变量。您可以在 body 元素能访问到的任何地方声明它们。首先，我们将在 root 选择器中添加两个颜色变量。

```css
:root {
  --blue: rgb(26, 57, 87);
  --white: rgb(236, 236, 236);
}
```

为了简化示例，我将在浅色模式下使用白色背景，蓝色文本，并且在打开深色模式时切换成蓝色背景，白色文本。为此，我们将在 light 类选择器中添加并使用更多来自 root 的 CSS 变量。我们还将在切换主题时修改字体权重，以及 hello world 标题下的背景图像。我不建议这样做，尤其是对于背景图像，但如果您想使用它，这是一个选项。

```css
body.light {
  --background-color: var(--white);
  --text-color: var(--blue);
  --font-weight: 400;
  --image: url("../day.jpg");
}
```

对于 dark 类，我们将做类似的事情。我们将切换背景和文本的颜色，赋予字体更大的权重，并使用不同的夜间图像。

```css
body.dark {
  --background-color: var(--blue);
  --text-color: var(--white);
  --font-weight: 500;
  --image: url("../night.jpg");
}
```

现在我们已经设置了 dark 和 light 类，我们需要让 body 选择器使用它们，这很简单。只需设置属性以使用正确的 CSS 变量。我们也可以设置背景和颜色过渡，这样模式切换就不会那么突然。

```css
body {
  background: var(--background-color);
  color: var(--text-color);
  font-weight: var(--font-weight);
  transition: background 0.3s ease-in-out, color 0.6s ease-in-out;
}
```

当然，我们还需要设置图像容器以使用 image 变量。

```css
#image {
  width: 100%;
  height: 300px;
  background-attachment: fixed;
  background-position: center;
  background-repeat: no-repeat;
  background-size: cover;
  transition: background-image 0.7s ease-in-out;
  background-image: var(--image);
}
```

如果我们想更进一步，我们也可以设置导航栏来改变不同模式下的背景和文本颜色。

```css
nav {
  padding: 1rem 25%;
  margin: 0 auto;
  display: flex;
  justify-content: space-evenly;
  align-items: center;
  background: var(--text-color);
}

nav a {
  text-decoration: none;
  text-transform: uppercase;
  color: var(--background-color);
}

```

如果您遵循了所有步骤，现在应该拥有了基于 React 构建的自定义功能的深色模式开关。如果您想进一步查看项目代码，可以在 [GitHub](https://github.com/alekspopovic/DarkMode) 上获取源文件以及我使用的所有图像。


> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
