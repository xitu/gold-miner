> * 原文地址：[React’s JSX vs Vue’s templates: a showdown on the front end](https://medium.freecodecamp.com/reacts-jsx-vs-vue-s-templates-a-showdown-on-the-front-end-b00a70470409#.wbkkiga1e)
* 原文作者：[Juan Vega](https://medium.freecodecamp.com/@juanmvega)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[ZhangFe](https://github.com/ZhangFe)
* 校对者：[Tina92](https://github.com/Tina92)  [zhouzihanntu](https://github.com/zhouzihanntu)

---

# React JSX vs Vue 模板：前端界的一次对决
![](https://cdn-images-1.medium.com/max/2000/1*QH4RGlNwXUFnJSytytvb6A.jpeg)

React.js 与 Vue.js 是地球上最受欢迎的两个 JavaScript 库。他们都非常强大并且相对容易上手和使用。

React 和 Vue 的共同点:

- 使用虚拟 DOM
- 提供响应式的视图组件
- 保持对视图的关注

伴随着如此多的相同点，你可能会怀疑它们就是同一个库的不同版本。

不过这两个库有一个主要的区别：就是他们如何授权给你（开发者）创建你自己的视图组件，甚至是你的应用。

React 使用 JSX（由 React 小组创建的名词）在 DOM 中渲染内容。那么什么是 JSX ？实际上，JSX 是一个 JavaScript 渲染函数，它帮助你将你的 HTML 插入到你的 JavaScript 代码中。

Vue 采用了不同的方式，它使用的是类 HTML 模板。使用 Vue 的模板和使用 JSX 非常相似因为他们都是用 JavaScript 创建的。主要区别就是 JSX 函数永远不会在实际的 HTML 文件中使用，但 Vue 模板会。

### **React JSX**

让我们深入讨论一下 JSX 是如何工作的。假设你有一个你们公司最近招聘的新员工的姓名列表，并且你想在 DOM 中展示它。

如果你使用简单的 HTML，你可能首先需要创建一个 index.html 文件，然后添加下面几行代码

    <ul>

      <li> John </li>

      <li> Sarah </li>

      <li> Kevin </li>

      <li> Alice </li>

    <ul>

这里没什么特殊的，只是 HTML 代码。

那么怎么使用 JSX 完成同样的事呢？第一步是创建另一个 index.html 文件。不过你只需要添加一个简单的 `div` 标签而不是像你之前做的那样添加完整的 HTML。这个 `div` 将成为渲染你的 React 代码的容器元素。 

这个 `div` 需要有一个唯一的 ID 以便于 React 知道如何找到它。Facebook 往往青睐于用 root 关键字，所以我们也跟着这么做了。
   
    <div id=root></div>

现在，到了最重要的一步。创建一个保存所有 React 代码的 JavaScript 文件。给这个命名为 app.js。

现在，你只差一件最主要的事情，使用 JSX 将所有新招聘员工展示在 DOM 中。

首先你需要创建一个包含新招聘员工姓名的数组

    const names = [‘John’, ‘Sarah’, ‘Kevin’, ‘Alice’];

之后创建一个 React 元素来动态渲染整个姓名列表。这里不需要手动地去展示每一个。

    const displayNewHires = (

      <ul>

        {names.map(name => <li>{name}</li> )}

      </ul>

    );

这里需要注意的关键点是你不需要创建单个的 `<li>` 元素。你只需要描述你希望他们每个是如何展示的，React 将处理剩下的事情。这是一个非常强大的功能。毕竟这里你只有几个名字，想想如果你有一个成千上万的列表呢！尤其是当 `<li>` 元素比这里使用到的更复杂时，你将发现这是一个很好的方法。

将内容呈现到屏幕上所需要的最后一点代码是 ReactDom 的 render 函数。

    ReactDOM.render(

      displayNewHires,

      document.getElementById(‘root’)

    );

这里你告诉 React 将 `displayNewHires` 里的内容渲染到 ID 为 root的 `div` 元素中。

你最终的 React 代码应该看起来像这样：

    const names = [‘John’, ‘Sarah’, ‘Kevin’, ‘Alice’];

    const displayNewHires = (

      <ul>

        {names.map(name => <li>{name}</li> )}

      </ul>

    );

    ReactDOM.render(

      displayNewHires,

      document.getElementById(‘root’)

    );

请记住一个关键点，这里全部都是 React 代码。这意味着它将全部编译成简单的旧的 JavaScript 。这里是它最终看起来的样子：

    ‘use strict’;

    var names = [‘John’, ‘Sarah’, ‘Kevin’, ‘Alice’];

    var displayNewHires = React.createElement(

      ‘ul’,

      null,

      names.map(function (name) {

        return React.createElement(

          ‘li’,

          null,

          name

        );

      })

    );

    ReactDOM.render(displayNewHires, document.getElementById(‘root’));

这里就是全部的代码了。你现在有一个简单的 React 应用来展示一个姓名列表。没什么可详述的，但是它应该已经让你粗略的看到了 React 的能力。

### **Vue.js 模板**

与上个例子一样，你要再创建一个在浏览器中展示姓名列表的简单应用。

你要做的第一件事是创建一个空的 index.html。在这个文件里你再创建一个 id 为 root 的空 `div`。但请记住 root 只是个人喜好，你可以使用任何你喜欢的 id，只要确保之后你把 html 同步到你的 JavaScript 代码时这个 id 可以匹配上。

这个 div 的功能与在 React 中一样。它将告诉 JavaScript 库（在这里指的是 Vue）当它想要进行更改时在哪里可以查找到这个 DOM。

完成这步之后，继续创建一个包含全部 Vue 代码的 JavaScript 文件。为了保持一致，将它命名为 app.js。

现在你已经准备好了你的文件。让我们看看 Vue 是如何在浏览器中展示元素的。

Vue 使用类似于模板的方法来操作 DOM。这意味着像 React 一样，你的 HTML 文件不会仅仅只有一个空的 `div`。实际上你要在你的 HTML 文件中编写一部分代码。

为了给你一个更好的思路，回想一下用简单的 HTML 是如何创建一个姓名列表的。就是在一个 `<ul>` 元素里添加几个 `<li>` 元素。在 Vue 里，你将做几乎完全相同的事，只不过增加了一点变化。

创建一个 `<ul>` 元素。

    <ul>

    </ul>

现在在 `<ul>` 元素里添加一个空的 `<li>` 元素。
 
    <ul>

      <li>

      </li>

    </ul>

这不是什么新内容。通过给你的 `<li>` 元素添加一个指令 (一个 Vue 的自定义属性) 来做一些改变。

    <ul>

      <li v-for=’name in listOfNames’>

      </li>

    </ul>

指令是 Vue 将 JavaScript 的功能直接添加到 HTML 上的方式。他们都以 v- 开头并且跟上一些描述性的名字以便于你知道他们的功能。在这个例子里，它是一个 for 循环。对于你的姓名列表 `listOfNames` 里的每一个名字，你都要复制这个 `<li>` 元素并将其替换成一个新的包含姓名的 `<li>`。

现在，代码还差最后一步。目前，它为你的列表里的每个姓名展示一个 `<li>` 元素，但你实际上并没有告诉它在浏览器上显示实际的名字。为了完成这个，你需要在你的 `<li>` 元素里添加一些 mustache 语法。你可能在其他一些 JavaScript 库中看到过。

    <ul>

      <li v-for=’name in listOfNames’>

        {{name}}

      </li>

    </ul>

现在 `<li>` 元素已完成。它将展示 listOfNames 这个列表里的每个元素。请记住 **name** 这个单词是任意的。你也可以叫它 **item**，但是它的目的是相同的。所有的关键字所做的只是一个占位符并且将被用于遍历列表。

你要做的最后一件事是创建一个数据集并且在您的应用中实例化 Vue。

为了完成这个，你需要创建一个新的 Vue 实例。通过将它分配给一个名为 app 的变量来实例化它。

    let app = new Vue({

    });

现在，这个对象需要接收几个参数。第一个参数 `el` (element) 是最重要的，它告诉 Vue 从哪开始向 DOM 里添加内容。就像你在 React 的例子里做的那样。

    let app = new Vue({

      el:’#root’,

    });

最后一步是给 Vue 应用添加数据。在 Vue 里，所有传递给应用的数据都会像这样作为参数传递给 Vue 实例。并且，对于每种类型的参数，每个 Vue 实例里只能有一个。虽然有很多参数类型，在这个例子里你只需要关注两个，`el` 和 `data`。

    let app = new Vue({

      el:’#root’,

      data: {

        listOfNames: [‘Kevin’, ‘John’, ‘Sarah’, ‘Alice’]

      }

    });

data 对象将要接收一个名为 `listOfNames` 的数组。现在，无论何时要在应用程序中使用该数据集，只需要使用指令调用它，很简单，对吧？

这里是完整的应用：

#### **HTML**

    <div id=”root”>

      <ul>

        <li v-for=’name in listOfNames’>

          {{name}}

        </li>

      </ul>

    </div>

#### **JavaScript**

    new Vue({

      el:”#root”,

      data: {

        listOfNames: [‘Kevin’, ‘John’, ‘Sarah’, ‘Alice’]

      }

    });

### **结论**

现在你知道如何使用 React 和 Vue 创建两个简单的应用了。他们都提供了大量的功能，不过 Vue 往往更容易使用一些。并且，请一定记住，尽管 JSX 不是 Vue 首选的实现方法，但在 Vue 中也是被允许使用的。

无论哪种方式，这两个都是非常强大的库并且无论你选谁都不会错。

