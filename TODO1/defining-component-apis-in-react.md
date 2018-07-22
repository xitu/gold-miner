> * 原文地址：[Defining Component APIs in React](http://jxnblk.com/writing/posts/defining-component-apis-in-react/)
> * 原文作者：[Jxnblk](http://jxnblk.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/defining-component-apis-in-react.md](https://github.com/xitu/gold-miner/blob/master/TODO1/defining-component-apis-in-react.md)
> * 译者：[Gavin-Gong](https://github.com/Gavin-Gong)
> * 校对者：[xunge0613](https://github.com/xunge0613) [sunui](https://github.com/sunui)

# 设计 React 组件 API

多年来，我致力于一系列处理组件 API 和构建应用程序、库的模式。以下是一系列如何设计组件 API 的想法、观点和建议，这会让组件更灵活、更具有组合性、更容易理解。这些规则都不是硬性的，但它们帮助我想明白了如何组织和创建组件。

## 提供最少的 API

正如 React 库本身的目标是 [最少化 API](https://www.youtube.com/watch?v=4anAwXYqLG8) 一样，我建议在设计组件 API 时采用类似的观点。需要学习的新内容越少，其他人就越容易知道如何使用你创建的组件，从而使它们更容易被重用。如果有人不理解你的组件 API，那么他们重复你的工作的可能性就会增加。这是我如何创建组件的核心理念，我发现在我工作中牢记它很有帮助。

## 让你的代码更容易被找到

从扁平目录结构开始，不要过早地组织代码库。人类喜欢整理东西，但我们在这方面做得很糟糕。命名已经足够困难了，为组件库创建目录结构，您可能会做更多的工作，最终使其他人更难找到你所写的代码。

一个单独存放组件的目录在变得难以管理之前会变得相当大。如果所有的组件都在一个文件夹中，在大多数文件系统工具中会自动按照字母进行排序，这有助于为其他人提供更完整的代码库概览。

## 避免 renderXXX 方法

如果您在组件中定义了以 render 开头的自定义方法，那么它很可能应该被定义为自有组件。正如 [Chris Biscardi](https://mobile.twitter.com/chrisbiscardi/status/1004559213320814592) 所说，**“高效意味着有有足够的复杂度值得被分解”**。React 能明智地决定是否渲染的时机，因此，将这些组件拆分为自有组件，可以帮助 React 更好地运行。

```jsx
// 不要这样写
class Items extends React.Component {
  renderItems ({ items }) {
    return items.map(item => (
      <li key={item.id}>
        {renderItem(item)}
      </li>
    ))
  }

  renderItem (item) {
    return (
      <div>
        {item.name}
      </div>
    )
  }

  render () {
    return (
      <ul>
        {renderItems(this.props)
      </ul>
    )
  }
}
```

```jsx
// 这样写
const ItemList = ({ items }) =>
  <ul>
    {items.map(item => (
      <li key={item.id}>
        <Item {...item} />
      </li>
    )}
  </ul>

const Item = ({ name }) =>
  <div>{item.name}</div>

class Items extends React.Component {
  render () {
    const { items } = this.props
    return <ItemList items={items} />
  }
}
```

## 在数据界限上分割组件

通常，组件应该由数据的形状来定义

> 既然你经常向用户展示 JSON 数据模型，你会发现，如果你的模型构建正确，你的 UI（以及你的组件结构）会被很好地映射。

– [React 理念](https://facebook.github.io/react/docs/thinking-in-react.html)

我经常看到 React 新手尝试复制我所说的 "[Bootstrap](https://getbootstrap.com)" 组件，即具有视觉边界，但与任何数据结构都没有直接联系的 UI 组件。React 组件和 BEM 风格、基于 CSS 的组件有着不同的关注点。不应该创建一个需要定制 props 的通用 Card 组件来显示图像、标题和链接，而是为你需要展示的数据创建组件。也许通用的 Card 组件应该是一个接受来自数据库的 product 对象的 ProductCard 组件。

```jsx
// 不要这样写
<Card
  image={product.thumbnail}
  title={product.name}
  text={product.description}
  link={product.permalink}
/>

// 这样写
<ProductCard {...product} />
```

很可能，你需要的 ProductCard 的特定样式并不都是可重用的，而且你可能只在代码库中的一个地方定义了这个样式。在这种情况下，你可以遵循 [三次法则](<https://en.wikipedia.org/wiki/Rule_of_three_(computer_programming)>)。如果你已经在代码库中复制了三次 Card 组件结构，那么将其抽象出自有组件可能是值得的。

## 避免繁多的 props

正如 [Jenn Creighton](https://twitter.com/gurlcode) 所说，避免 [繁多的 props]((https://speakerdeck.com/jenncreighton/flexible-architecture-for-react-components?slide=10))。不要害怕创建一个新的组件，而不是向组件添加一些任意的 props 和附加的逻辑。例如，Button 组件可以接受不同颜色、大小和形状的 props，但并不总是需要这么多的 props。

```jsx
// 不要这要写
<Button
  variant='secondary'
  size='large'
  outline
  label='Buy Now'
  icon='shoppingBag'
  onClick={handleClick}
/>

// 这要写
<SecondaryButton
  size='large'
  onClick={handleClick}>
  <Icon name='shoppingBag' />
  Buy Now
</SecondaryButton>
```

你的需求可能会有所不同，但是减少组件所需的自定义 props 的数量通常很有帮助，并且减少 render 函数中的逻辑数量可以使代码库更简单，更适合于代码分割。

## 使用组合

不要重新发明 `props.children`。如果你已经定义了 props 接收不基于数据结构的任意文本字符串，那么最好使用组合。

```jsx
// 不要这样写
<Header
  title='Hello'
  subhead='This is a header'
  text='And it has arbitrary props'
/>

// 这样写
<Header>
  <Heading>Hello</Heading>
  <Subhead>This is a header</Subhead>
  <Text>And it uses composition</Text>
</Header>
```

如果你熟悉 React，那么你可能已经知道了组合版本组件的 API，它不会像之前那样需要那么多的文档。在你的应用中，你可以将组合版本的组件封装到另一个与数据结构绑定组件中，而且你可能只需要在代码库中定义一次组件结构。

```jsx
// 对于一个基于数据的组件而言，这样写很有用
const PageHeader = ({
  title,
  description
}) =>
  <Header>
    <Heading>{title}</Heading>
    <Text>{description}</Text>
  </Header>

// 理想情况下可以这样使用
<PageHeader {...page} />
```

## 避免枚举布尔 props

使用 [布尔 props](https://mobile.twitter.com/satya164/status/1015206655997472768) 是一种在组件变量之间进行切换的便捷方式，这很有吸引力，但它有时会产生一个令人困惑的 API。
查看下面的例子：

```jsx
<Button primary />
<Button secondary />
```

下面的情况会发生什么？

```jsx
<Button primary secondary />
```

如果不深入到代码库或文档中，就无法理解。相反，试试以下：

```jsx
<Button variant="primary" />
```

这样需要打更多的字，但是可以说更加具有可读性。

## 保持 props 并行

只要有可能，复用其他组件的 props。例如，如果你正在写一个日期选择器，请使用与原生 `<input type='date' />` 相同的 props。这样将更容易猜测组件是如何运作的，也更容易记住这些 API。

```jsx
// 不要这样写
<DatePicker
  date={date}
  onSelect={handleDateChange}
/>

// 这样写
<DatePicker
  value={date}
  onChange={handleDateChange}
/>
```

[Styled System](https://jxnblk.com/styled-system) 库鼓励跨多个组件使用并行风格的 props API。例如，color props 对 [Rebass](https://jxnblk.com/rebass) 中的所有组件都起作用，最终达到一次学习，到处使用的效果。

```jsx
// 来自 Rebass 的例子
<Box color='tomato' />
<Heading color='tomato' />
```

## 和你的队友沟通

这些只是我自己对如何设计组件 API 的一些想法，它们可能无法满足您的需求。我能给出的最好建议是与你的队友沟通，创建 RFC 和 PR，并尝试 [Readme 驱动开发](https://ponyfoo.com/articles/readme-driven-development)。编写 React 组件很容易。为你的团队创建一个运行良好的组件库花费时间和精力是非常值得的。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。
---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
