> * 原文地址：[Build a Drag and Drop layout builder with React and ImmutableJS](https://medium.com/javascript-in-plain-english/build-a-drag-and-drop-dnd-layout-builder-with-react-and-immutablejs-78a0797259a6)
> * 原文作者：[Chris Kitson](https://medium.com/@kitson.mac)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/build-a-drag-and-drop-dnd-layout-builder-with-react-and-immutablejs.md](https://github.com/xitu/gold-miner/blob/master/TODO1/build-a-drag-and-drop-dnd-layout-builder-with-react-and-immutablejs.md)
> * 译者：[fireairforce](https://github.com/fireairforce)
> * 校对者：[Eternaldeath](https://github.com/Eternaldeath), [portandbridge](https://github.com/portandbridge)

# 使用 React 和 ImmutableJS 构建一个拖放布局构建器
 
![Drag and Drop in React!](https://cdn-images-1.medium.com/max/11812/1*3fSiTsc1lvObuewgJH1J7A.jpeg)

## 使用 React 和 ImmutableJS 构建一个拖放（DnD）布局构建器 

『**拖放**』这一类的行为存在着巨大的用户需求，例如构建网站（Wix）或交互式应用程序（Trello）。毫无疑问，这种类型的交互创造了非常酷的用户体验。如果再加上一些最新的 UI 技术，我们可以创建一些非常好的软件。

## 这篇文章的最终目标是什么？

我想构建一个能让用户使用一系列可定制 UI 组件来构建布局的拖放布局构建器，最终能构建出一个网站或者是 web 应用程序。 　

## 我们会用到哪些库？

 1. **React**
 2. **ImmutableJS**

下面花一点时间来解释它们在构建这个项目时所起的作用。

## React

[React](https://reactjs.org/) 基于声明式编程，这意味着它根据状态来进行渲染。状态（State）实际上只是一个 JSON 对象，它具有告诉 React 应该怎么去渲染（样式和功能）的属性。与操作 DOM 的库（例如 jQuery）不同，我们不直接改变 DOM，而是通过修改状态（state）然后让 React 去负责 DOM（**稍后会介绍 DOM**）。

在这个项目中，假设有一个父组件来保存布局的状态（JSON 对象），并且这个状态将被传递给其他的组件，这些组件都是 React 中的无状态组件。

这些组件的作用是从父组件中获取状态，然后根据其属性来渲染本身。

以下是一个具有三个 link 对象的状态的简单示例：

```js
{
  links:  [{
    name: "Link 1",
    url: "http://link.one",
    selected: false
  }, {
    name: "Link 2",
    url: "http://link.two",
    selected: true
  }, {
    name: "Link 3",
    url: "http://link.three",
    selected: false
  }]
}
```

通过上面的例子，我们可以遍历 links 数组来为每个元素创建一个无状态组件：

```ts
interface ILink {
  name: string;
  url: string;
  selected: boolean;
}

const LinkComponent = ({ name, url, selected }: ILink) =>
<a href={url} className={selected ? 'selected': ''}>{name}</a>;
```

你可以看到我们如何根据状态中保存的选定属性将 css 类『selected』应用到 links 数组组件。下面是呈现给浏览器的内容：

```html
<a href="http://link.two" class="selected">Link 2</a>
```

## ImmutableJS

我们已经了解了状态在我们项目中的重要性，它是使 React 组件如何渲染的**唯一真实的数据来源**。React 中的状态保存在不可变的数据结构中。

简而言之，这意味着一旦创建了数据对象，**就不能**直接去修改它。除非我们创建一个具有更改状态的新对象。

让我们用另外一个简单的例子来说明不变性：

```ts
interface ILink {
  name: string;
  url: string;
  selected: boolean;
}

const link: ILink = {
    name: "Link 1",
    url: "http://link.one",
    selected: false
}
```

在传统的 JavaScript 中，你可以通过下面的操作来更新 link 对象：

```js
link.name = 'New name';
```

如果我们的状态是不可变的，那么上面操作不可能完成的，那么我们必须要创建一个 name 属性已经被修改的新对象。

```js
link = {...link, name: 'New name' };
```

**注意：为了支持不变性，React 为我们提供了一个方法 `this.setState()`，我们可以使用它来告诉组件状态已经改变，并且组件还需要重新进行渲染如果状态发生任何改变。**

上面只是基本示例，但是如果想要在复杂的 JSON 状态结构中更改嵌套了多层的属性应该怎么做？

ECMA Script 6 为我们提供了一些方便的操作符和方法来改变对象，但它们并不适用于复杂的数据结构，这就是我们需要 [ImmutableJS](https://github.com/immutable-js/immutable-js) 来简化任务的原因。 

稍后我们会使用 ImmutableJS，但是现在你只需要知道它具有给我们提供简便的方法用来改变复杂的状态方面的作用。

![](https://cdn-images-1.medium.com/max/2000/1*IugEwe6Lkm5iFB-Q9zvc5w.jpeg)

## HTML5 拖放（DnD）

所以我们知道我们的状态是一个不可变的 JSON 对象，而 React 来负责处理组件，但我们需要有趣的用户交互体验，对吧？

幸亏有了 HTML5 使得这实际上非常简单，因为它提供了我们可以用来检测拖动组件的时间和放置它们的位置的方法。由于 React 将原生 HTML 元素暴露给浏览器，因此我们可以使用原生的事件方法使我们的实现更加简单。

**注意：我得知使用 HTML5 实现的 DnD 可能存在一些问题但如果没有其它的问题，这可能是一个探究课程，如果发现有问题的话，我们之后可以换掉它。**

在这个项目中，我们拥有用户可以拖动的组件（HTML divs），我称他们为**可拖动组件**。

同时我们也拥有允许用户放置组件的区域， 我称他们为**可放置组件**。

使用原生 HTML5 事件如 `onDragStart`、`onDragOver` 和 `onDragDrop`，我们也应该拥有基于 DnD 交互更改应用程序状态所需要的东西。

**以下是一个可拖动组件的实例：**

```ts
export interface IDraggableComponent {
  name: string;
  type: string;
  draggable?: boolean;
  onDragStart: (ev: React.DragEvent<HTMLDivElement>, name: string, type: string) => void;
}

export const DraggableComponent = ({
  name,
  type,
  onDragStart,
  draggable = true
}: IDraggableComponent) =>
<div className='draggable-component' draggable={draggable} onDragStart={(ev) => onDragStart(ev, name, type)}>{name}</div>;
```

在上面的代码片段中，我们渲染了一个 React 组件，该组件使用 `onDragStart` 事件告诉父组件我们正开始拖动组件。我们还可以通过传递 `draggable` 属性来切换拖动它的能力。

**以下是一个可放置组件的实例：**

```ts
export interface IDroppableComponent {
  name: string;
  onDragOver: (ev: React.DragEvent<HTMLDivElement>) => void;
  onDrop: (ev: React.DragEvent<HTMLDivElement>, componentName: string) => void;
}

export const DroppableComponent = ({
  name,
  onDragOver,
  onDrop
}: IDroppableComponent) =>
<div className='droppable-component'
  onDragOver={(ev: React.DragEvent<HTMLDivElement>) => onDragOver(ev)}
  onDrop={(ev: React.DragEvent<HTMLDivElement>) => onDrop(ev, name)}>
  <span>Drop components here!</span>
</div>;
```

在上面的组件中，我们正在监听 `onDrop` 事件，因此我们可以根据放进可放置组件的新组件来更新状态。

**好的，是时候快速回顾一下，然后将他们全部放到一起：**

**我们将使用 React 中基于状态对象的少量解耦无状态组件来渲染整个布局。用户交互将由 HTML5 DnD 事件来处理，而时间会使用 ImmutableJS 来触发对状态对象的更改。**

![](https://cdn-images-1.medium.com/max/2000/1*06515Z0luWKxNzfsz8tKBw.gif)

## 拖动全部

现在我们已经对要做的事情以及如何处理它们有了深刻的了解，让我们考虑一下这个难题中的一些最重要的部分：

 1. 布局状态
 2. 拖放构建器组件
 3. 渲染网格内的嵌套组件

## 1. 布局状态

为了使我们的组件能表示无限的布局组合，状态需要灵活且可拓展。我们还需要记住的是，如果想要表示任何给定布局的 DOM 树，意味着需要很多令人愉快的递归来支持嵌套结构！

![](https://cdn-images-1.medium.com/max/2000/1*6v0VjyiKNaLp0ounI3pNbA.jpeg)

我们的状态需要存储大量组件，可以通过以下接口表示：

**如果你不熟悉 JavaScript 中的接口，你应该看看 [TypeScript](https://www.typescriptlang.org/) — 你大概能看出我是它的粉丝。它很适用于 React。** 

```ts
export interface IComponent {
  name: string;
  type: string;
  renderProps?: {
    size?: 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12
  };
  children?: IComponent[];
}
```

我会使组件的定义最小化，但是你可以根据需要拓展它。我在 `renderProps` 这里定义一个对象，所以我们可以为组件提供状态来告诉它如何渲染，`children` 的属性为我们提供了递归。

对于更高层次，我会创建一个对象数组来保存组件，它们将出现在状态的根部。

为了说明这一点，我们建议将以下内容作为 HTML 中标记的有效布局：

```html
<div class="content-panel-1">
  <div class="component">
    Component 1
  </div>
  <div class="component">
    Component 2
  </div>
</div>
<div class="content-panel-2">
  <div class="component">
    Component 3
  </div>
</div>
```

为了在状态中表示这一点，我们可以为内容面板定义如下所示的接口：

```ts
export interface IContent {
  id: string;
  cssClass: string;
  components: IComponent[];
}
```

然后我们的状态将会成为一个像如下 `IContent` 数组：

```ts
const state: IContent[] = [
  {
    id: 'content-panel-1',
    cssClass: 'content-panel-1',
    components: [{
      type: 'component1',
      renderProps: {},
      children: []
    },
    {
      type: 'component2',
      renderProps: {},
      children: []
    }]
  },
  {
    id: 'content-panel-2',
    cssClass: 'content-panel-2',
    components: [{
      type: 'component3',
      renderProps: {},
      children: []
    }]
  }
];
```

通过在 `children` 数组属性中推送其他组件，我们可以定义其他组件来创建嵌套的类似 DOM 的树结构：

```
[0]
  components:
    [0]
      children:
        [0]
          children:
            [0]
               ...
```

![](https://cdn-images-1.medium.com/max/2000/1*S6XF_dPgkDax70QjkXLNVQ.jpeg)

## 2. 拖放布局构建器

布局构建器组件将执行一系列功能，例如：

* 保持并更新组件状态
* 渲染 **可拖动组件** 和 **可放置组件**
* 渲染嵌套布局结构
* 触发 DnD HTML5 事件

代码大概是这样的：

```ts
export class BuilderLayout extends React.Component {

  public state: IBuilderState = {
    dashboardState: []
  };

  constructor(props: {}) {
    super(props);

    this.onDragStart = this.onDragStart.bind(this);
    this.onDragDrop = this.onDragDrop.bind(this);
  }

  public render() {

  }

  private onDragStart(event: React.DragEvent <HTMLDivElement>, name: string, type: string): void {
    event.dataTransfer.setData('id', name);
    event.dataTransfer.setData('type', type);
  }

  private onDragOver(event: React.DragEvent<HTMLDivElement>): void {
    event.preventDefault();
  }

  private onDragDrop(event: React.DragEvent <HTMLDivElement>, containerId: string): void {

  }


}
```

我们先暂时不用管 `render()` 函数，后面很快会再见到它。

我们有三个事件，我们将绑定它们到我们的『可拖动组件』和『可放置组件』上。

`onDragStart()` ——这个事件这里我们设置一些关于 `event` 对象中组件的细节，即 `name` 和 `type`。

`onDragOver()` ——我们现在不会对这个事件做任何事情，事实上我们通过 `.preventDefault()` 函数禁用浏览器的默认行为。

这就留下了 `onDragDrop()` 事件，这就是修改不可变状态的神奇之处。为了改变状态，我们需要几条信息：

* 要放置组件的名称 —— `name` 在 `event` 对象中设置 `onDragStart()`。
* 要放置组件的类型 —— `type` 在 `event` 对象中设置 `onDragStart()`。
* 组件被放置的位置 —— `containerId` 从可放置的组件中传入这个方法。

在 `containerId` 中必须告诉我们，新的组件具体要放在状态里的什么位置。可能有一种更简洁的方法可以做到这一点，但为了描述这个位置，我将使用一个下划线分隔的索引列表。

回顾我们的状态模型：

```
[index]
  components:
    [index]
      children:
        [index]
          children:
            [index]
               ...
```

用字符串格式表示为 `cb_index_index_index_index`。

此处的索引数描述了应该删除组件的嵌套结构中的深度级别。

现在我们需要调用 [**immutableJS**](https://github.com/immutable-js/immutable-js) 中的强大功能来帮助我们改变应用程序的状态。我们将在 `onDragDrop()` 方法中执行此操作，改方法可能如下所示：

```ts
private onDragDrop(event: React.DragEvent <HTMLDivElement>, containerId: string) {
  const name = event.dataTransfer.getData('id');
  const type = event.dataTransfer.getData('type');

  const newComponent: IComponent =  this.generateComponent(name, type);

  const containerArray: string[] = containerId.split('_');
  containerArray.shift(); // 忽略第一个参数，它是字符串前缀

  const componentsPath: Array<number | string> = []   containerArray.forEach((id: string, index: number) => {
  componentsPath.push(parseInt(id, INT_LENGTH));
  componentsPath.push(index === 0 ? 'components' : 'children');
});

  const { dashboardState } = this.state;
  let componentState = fromJS(dashboardState);

  componentState = componentState.setIn(componentsPath,       componentState.getIn(componentsPath).push(newComponent));

  this.setState({ dashboardState: componentState.toJS() });

}
```

这里的功能来自于 ImmutableJS 提供给我们的 `.setIn()` 和 `.getIn()` 方法。

它们采用一组字符串/值以确定要在嵌套状态模型中获取或设置值的位置。这与我们生成可放置的 ids 方式很吻合。很酷吧？

`fromJS()` 和 `toJS()` 方法转变 JSON 对象到 ImmutableJS 对象，然后再返回。

**关于 ImmutableJS 有很多东西，我可能会在未来写一篇关于它的专门的帖子。很抱歉，这次只是一次简单的介绍！**

## 3. 渲染网格内的嵌套组件

最后让我们快速看一下前面提到的渲染方法。我想支持一个 CSS 网格系统类似于 [Material responsive grid](https://material.io/design/layout/responsive-layout-grid.html#breakpoints) 来使我们的布局更加灵活。它使用 12 列网格来规定 HTML 布局，如下所示：

```html
<div class="mdc-layout-grid">
  <div class="mdc-layout-grid__inner">
    <div class="mdc-layout-grid__cell mdc-layout-grid__cell--span-6">
      Left column
    </div>
    <div class="mdc-layout-grid__cell mdc-layout-grid__cell--span-6">
      Right column
    </div>
  </div>
</div>
```

将它与我们的状态所代表的嵌套结构相组合，我们可以得到一个非常强大的布局构建器。

现在，我只是将网格的大小固定为两列布局（即单个可放置组件中的两列具有的递归）。

为了实现这一点，我们有一个可拖动组件的网格，它将包含两个可放置的（每列一个）。

**这是我之前创建的一个：**

![](https://cdn-images-1.medium.com/max/5756/1*k92aZrAjmFEeH_TqJYdXxQ.png)

上面我有一个**Grid**，第一列中有一个**Card**，第二列中有一个**Heading**。

![](https://cdn-images-1.medium.com/max/5760/1*yeocyMzF3J2iIEHGFRISiw.png)

现在我在第一列中放置了另一个**Grid**，第一列中有一个**Heading**，第二列中有一个**Card**。

**你明白了吗？**

**举个例子来说明如何使用 React 伪代码实现这个目的：**

 1. 循环遍历内容项（我们状态的根）并且渲染一个 `ContentBuilderDraggableComponent` 和一个 `DroppableComponent`。

 2. 确定组件是否为 Grid 类型，然后渲染 `ContentBuilderGridComponent`，否则渲染一个常规的 `DraggableComponent`。

 3. 渲染被 X 个子项目标记的 Grid 组件，每个子项目中都有一个 `ContentBuilderDraggableComponent` 和一个 `DroppableComponent`。

```ts
class ContentBuilderComponent... {
  render() {
    return (
      <ContentComponent>
        components.map(...) {
          <ContentBuilderDraggableComponent... />
        }
        <DroppableComponent... />
      </ContentComponent>
    )
  }
}

class ContentBuilderDraggableComponent... {
  render() {
    if (type === GRID) {
      return <ContentBuilderGridComponent... />
    } else {
      return <DraggableComponent ... />
    }
  }
}

class ContentBuilderGridComponent... {
  render() {
    <GridComponent...>
      children.map(...) {
        <GridItemComponent...>
          gridItemChildren.map(...) {
            <ContentBuilderDraggableComponent... />
            <DroppableComponent... />
          }
        </GridItemComponent>
      }
    </GridComponent>
  }
}
```

## 下一步是什么？

我们已经完成了这篇文章，但我将来会对此进行一些拓展。这是一些想法：

* 配置组件的渲染道具
* 使网格组件可配置
* 使用服务端呈现从已保存的状态对象生成 HTML 布局

**希望你能 follow 我，如果你没有，这是我在 GitHub 上的一个工作示例，希望你能欣赏它。**

- [**chriskitson/react 拖放布局构建器**：使用 React 和 ImmutableJS 拖放（DnD）UI 布局构建器](https://github.com/chriskitson/react-drag-drop-layout-builder)

> 感谢您抽出宝贵时间阅读我的文章。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
