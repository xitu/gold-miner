> * 原文地址：[Build a Drag and Drop layout builder with React and ImmutableJS](https://medium.com/javascript-in-plain-english/build-a-drag-and-drop-dnd-layout-builder-with-react-and-immutablejs-78a0797259a6)
> * 原文作者：[Chris Kitson](https://medium.com/@kitson.mac)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/build-a-drag-and-drop-dnd-layout-builder-with-react-and-immutablejs.md](https://github.com/xitu/gold-miner/blob/master/TODO1/build-a-drag-and-drop-dnd-layout-builder-with-react-and-immutablejs.md)
> * 译者：
> * 校对者：

# Build a Drag and Drop layout builder with React and ImmutableJS

![Drag and Drop in React!](https://cdn-images-1.medium.com/max/11812/1*3fSiTsc1lvObuewgJH1J7A.jpeg)

## Build a Drag and Drop (DnD) layout builder with React and ImmutableJS

There is a huge user demand out there for “**drag and drop**” type behaviour such as building websites (**Wix**) or interactive applications (**Trello**). There is no doubt that this type of interaction creates a really cool user experience. Couple this with some of the latest UI technologies and we can create some really nice software.

## What is the end goal of this post?

I want to create a drag and drop layout builder giving users the ability to build layouts from a range of customisable UI components, with the end composition being a website or web app.

## What tools will we be using?

 1. **React**
 2. **ImmutableJS**

Let’s take a moment to explain their roles in building this.

## React

[React](https://reactjs.org/) is based upon declarative programming meaning that it derives it’s render from state. State is really just a JSON object containing properties that tell React how things should look and behave. Unlike DOM manipulation libraries such as jQuery we aren’t changing the DOM directly, we change the state and React takes care of the DOM (w**e will get into that a little later)**.

In this project I envisage that we will have a parent component which will hold the state of our layout (JSON) and this state will be passed to each of our components which will be stateless React components.

The role of the components will be to take the state from the parent component and render itself based on the properties.

Here’s a quick example of state with three link objects:

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

In the above example, we could loop over the links array and create a stateless React component for each link:

```ts
interface ILink {
  name: string;
  url: string;
  selected: boolean;
}

const LinkComponent = ({ name, url, selected }: ILink) =>
<a href={url} className={selected ? 'selected': ''}>{name}</a>;
```

You can see how we are applying the css class “selected” to our link component based on the selected property held in state. This is what would be rendered to the browser:

```html
<a href="http://link.two" class="selected">Link 2</a>
```

## ImmutableJS

We have already learned the importance of state in our project as the **single source of truth** on how things should be rendered using React components. State in React is held in immutable data structures.

In simple terms this means once the data object is created, it **cannot** be changed directly. Instead we must create a new object with the changed state.

Let me illustrate immutability with another quick example:

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

Traditionally in Javascript, you could have done something like below to update the link object:

```js
link.name = 'New name';
```

If our state is immutable this is not possible, instead we must create a new object with the name changed:

```js
link = {...link, name: 'New name' };
```

**Note: To support immutability React gives us a method called `this.setState()` which we can use to tell the component that the state has changed and to re-render itself if they are any changes.**

The above example is basic but what happens if we want to change a property that is nested several layers deep in a complex JSON state structure?

ECMA Script 6 gives us some handy operators and methods to mutate objects but they aren’t great for complex structures, which is why we need [ImmutableJS](https://github.com/immutable-js/immutable-js) to simplify the task.

We will use ImmutableJS later, but right now you just need to know its role in giving us fancy methods to allow use to change complex state.

![](https://cdn-images-1.medium.com/max/2000/1*IugEwe6Lkm5iFB-Q9zvc5w.jpeg)

## HTML5 Drag and Drop (DnD)

So we know that our state is an immutable JSON object and React is taking care of the components, but we need the fun user interaction bit, right?

Thanks to HTML5 this is actually pretty straightforward as it exposes methods we can use to detect when our components are being dragged and where they are being dropped. Since React exposes native HTML elements to the browser, we can just use the native events making our life much simpler.

**Note: I get that there may be quirks with using the HTML5 implementation of DnD but if nothing else this can be a discovery lesson and we can switch it out later if it proves problematic.**

In this project, I will have components (HTML divs) the users can drag. I am going to refer to them as **draggables**.

We will also have areas we are allowing the user to drop the components onto, I am going to call them **droppables**.

Using the native HTML5 events namely `onDragStart`, `onDragOver`, and `onDragDrop` we should have what we need to mutate our application state based on DnD interaction.

**Here’s an example of a draggable component:**

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

In the above snippet we are rendering a React component which uses the `onDragStart` event to tell our parent component that we are starting to drag the component. We can also toggle the ability to drag it by passing the `draggable` prop.

**Here’s an example of a droppable component:**

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

In the above component we are listening on the `onDrop` event so we can update the state based on the new component being dropped into the droppable component.

**OK, time for a quick recap before pulling this all together:**

**We are going to use React to render the entire layout using little decoupled stateless components based on a state object. The user interaction will be handled by HTML5 DnD events which will trigger a change to the state object by using ImmutableJS.**

![](https://cdn-images-1.medium.com/max/2000/1*06515Z0luWKxNzfsz8tKBw.gif)

## Dragging it all together

Now we have a solid understanding of what we are trying to do and how we are going to approach it, let’s consider some of the most important pieces of this puzzle:

 1. The layout state
 2. The drag and drop builder component
 3. Rendering nested components inside a grid

## 1. The layout state

To represent endless combinations of layouts using our components, the state needs to be flexible and scalable. We also need to keep in mind that we essentially want to represent the DOM tree of any given layout which means lots of lovely recursion to support nested structures!

![](https://cdn-images-1.medium.com/max/2000/1*6v0VjyiKNaLp0ounI3pNbA.jpeg)

Our state needs to store lots of components, which could be represented by the following interface:

**If you’re not familiar with interfaces in JavaScript you should check out [TypeScript](https://www.typescriptlang.org/) — you can probably tell I’m a fan. It works nice with React too.**

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

I’ve kept the component definition minimal but you can extend this as required. I’m defining a `renderProps` object here so we can provide props to the component to tell them how to render. The `children` property here is what gives us recursion.

At a higher level I would like to create an array of objects to hold the components, that will appear at the root of the state.

To illustrate this, let’s propose the following as a valid layout marked up in HTML:

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

To represent this in the state, we could define an interface like below for the content panels:

```ts
export interface IContent {
  id: string;
  cssClass: string;
  components: IComponent[];
}
```

Our state then becomes an array of `IContent` like so:

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

By pushing additional components inside the `children` array property, we can then define additional components creating our nested DOM-like tree structure:

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

## 2. The drag and drop layout builder

The layout builder component will perform and range of functions, such as:

* Hold and update the component state
* Render the **draggables** and **droppables**
* Render our nested layout structure
* Triggering the DaD HTML5 events

Let’s take a look at what it might look like:

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

Let’s ignore the `render()` for now as we are going to look at it shortly.

We have three events which we are going to bind to our draggables and droppables.

`onDragStart()` — here we are setting some details about the component in the `event` object, namely `name` and `type`.

`onDragOver()` — we aren’t doing anything with this event right now, in fact we are disabling the default browser behaviour by using `.preventDefault()`.

This leaves `onDragDrop()` which is where the magic happens in changing our immutable state object. In order to change the state we need several pieces of information:

* Name of the component to be dropped — `name` set in the `event` object `onDragStart()`.
* Type of the component to be dropped — `type` set in the `event` object `onDragStart()`.
* Where it is being dropped into — `containerId` passed into this method from the droppable.

The `containerId` must tell us where exactly in the state we must add our new component. There might be a cleaner way to do this but to describe this position I am going to use a list of indexes separated by an underscore.

Referring back to our state model:

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

This could be represented in the string format `cb_index_index_index_index`.

The number of indexes here describe how many levels deep in the nested structure the component should be dropped.

Now we need to call on the power of [**immutableJS**](https://github.com/immutable-js/immutable-js) to help us change the state of our application. We will do this in our `onDragDrop()` method, which might look like this:

```ts
private onDragDrop(event: React.DragEvent <HTMLDivElement>, containerId: string) {
  const name = event.dataTransfer.getData('id');
  const type = event.dataTransfer.getData('type');

  const newComponent: IComponent =  this.generateComponent(name, type);

  const containerArray: string[] = containerId.split('_');
  containerArray.shift(); // ignore first param, it is string prefix

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

The power here comes in the `.setIn()` and `.getIn()` methods that ImmutableJS gives us.

They take an array of strings/values to identify where in the nested state model you want to get or set the value. This is a good fit with how we generated our droppable ids. Isn’t that cool?

The `fromJS()` and `toJS()` methods are converted our JSON to a ImmutableJS object and back again.

**There is so much to ImmutableJS, so I will probably create a dedicated post about it in the future. Apologies this is just a flying visit!**

## 3. Rendering nested components inside a grid

Finally let’s take a quick look at the render method we mentioned earlier. I would like to support a CSS grid system such as [Material responsive grid](https://material.io/design/layout/responsive-layout-grid.html#breakpoints) to make our layouts flexible. It prescribes the HTML layout using a 12 column grid, something like below:

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

Combine this with our nested structures represented by the state and we should have ourselves a pretty powerful layout builder.

For now, I am just going to keep the sizes of the grid fixed to a two column layout (i.e. two columns inside a single droppable with recursion).

To achieve this I want to have a Grid draggable that will contain two droppables (one for each column).

**Here’s one I built earlier:**

![](https://cdn-images-1.medium.com/max/5756/1*k92aZrAjmFEeH_TqJYdXxQ.png)

Above I have a **Grid** component with a **Card** inside the first column and a **Heading** inside the second column.

![](https://cdn-images-1.medium.com/max/5760/1*yeocyMzF3J2iIEHGFRISiw.png)

Now I’ve dropped another **Grid** inside the first column with a **Heading** in the first column and a **Card** in the second column.

**You get the idea?**

**Let me illustrate how to achieve this using pseudo React code:**

 1. Loop through content items (root of our state) and render a ContentBuilderDraggableComponen and a `DroppableComponent`.

 2. Determine if component is of type Grid, then render `ContentBuilderGridComponent`, otherwise render a normal `DraggableComponent`.

 3. Render grid markup with X number of children and a ContentBuilderDraggableComponen and a `DroppableComponent` in each.

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

## What’s next?

We are done for this post, but I will expand upon this in the future. Here’s some ideas:

* Configure render props for components
* Make grid component configurable
* Use server side rendering to generate HTML layout from saved state object

**Hopefully you are able to follow along, but if not, here is a working example on my GitHub, enjoy!!**
[**chriskitson/react-drag-drop-layout-builder**
**Drag and drop (DnD) UI layout builder using React and ImmutableJS - chriskitson/react-drag-drop-layout-builder**github.com](https://github.com/chriskitson/react-drag-drop-layout-builder)

> Thank you for taking the time to read my article.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
