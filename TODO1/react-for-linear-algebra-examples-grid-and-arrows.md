> * 原文地址：[React for Linear Algebra Examples: Grid and Arrows](https://medium.com/@geekrodion/react-for-linear-algebra-examples-grid-and-arrows-f34c07132921)
> * 原文作者：[Rodion Chachura](https://medium.com/@geekrodion)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/react-for-linear-algebra-examples-grid-and-arrows.md](https://github.com/xitu/gold-miner/blob/master/TODO1/react-for-linear-algebra-examples-grid-and-arrows.md)
> * 译者：
> * 校对者：

# React for Linear Algebra Examples: Grid and Arrows

This is part of the course “[Linear Algebra with JavaScript](https://medium.com/@geekrodion/linear-algebra-with-javascript-46c289178c0)”.

![[GitHub Repository with Source Code](https://github.com/RodionChachura/linear-algebra)](https://cdn-images-1.medium.com/max/2000/1*4yaaTk2eqnmn19nyorh-HA.png)

Just recently I finished [the first story](https://medium.com/@geekrodion/linear-algebra-vectors-f7610e9a0f23) in upcoming series about linear algebra. And right before starting the new one I had a thought that would be cool to develop a React project showcasing examples from the series… GitHub repository can be found [there](https://github.com/RodionChachura/linear-algebra) and commit with the state of this story [there](https://github.com/RodionChachura/linear-algebra/tree/813cfecfda70cb3a9415c21ead97e09242e08f49).

## Goal

Since on the moment of writing, there is only one story that covers basic operations on vectors in series. It would be enough for now to implement components that will help us to render two-dimensional grid and vectors as arrows. The end result for this part shown below, also you can play with it [here](https://rodionchachura.github.io/linear-algebra/).

![basic vectors operation in two-dimensional space](https://cdn-images-1.medium.com/max/3830/1*38t6SAlScgmBGjXQn9cTuA.gif)

## Create React App

There is an entire story about best practices of how to start to react project, but for this case, we will go with as little libraries as possible and with simplest setup possible.

```bash
create-react-app linear-algebra-demo
cd linear-algebra-demo
npm install --save react-sizeme styled-components
```

The first library will be used to re render the **Grid** component when its size changes and the second one to make styling of components easier. To use **linear-algebra** library we are developing in series, we need to reference it in **package.json**.

```
"dependencies": {
    "linear-algebra": "file:../library",
    ...
}
```

## Project Structure

![project structure](https://cdn-images-1.medium.com/max/2000/1*EWFF0Gih-K8lchpTLnGemQ.png)

For each example we have it is own component in views folder. From **index.js** we export an object where the key is the name of an example and value is component.

```JavaScript
import { default as VectorLength } from './vector-length'
import { default as VectorScale } from './vector-scale'
import { default as VectorsAddition } from './vectors-addition'
import { default as VectorsSubtraction } from './vectors-subtraction'
import { default as VectorsDotProduct } from './vectors-dot-product'

export default {
  'vectors: addition': VectorsAddition,
  'vectors: subtraction': VectorsSubtraction,
  'vectors: length': VectorLength,
  'vectors: scale': VectorScale,
  'vectors: dot product': VectorsDotProduct
}
```

Then we can import this object in the main component and list all of its keys in the menu. After the user selects an example in the menu, the component state will be updated, and the new view will be rendered.

```JavaScript
import React from 'react'
import styled from 'styled-components'

import views from './views'
import MenuItem from './menu-item'

const Container = styled.div`
  ...
`

const Menu = styled.div`
  ...
`

class Main extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      view: Object.keys(views)[0]
    }
  }

  render() {
    const { view } = this.state
    const View = views[view]
    const viewsNames = Object.keys(views)
    const MenuItems = () =>
      viewsNames.map(name => (
        <MenuItem
          key={name}
          selected={name === view}
          text={name}
          onClick={() => this.setState({ view: name })}
        />
      ))
    return (
      <Container>
        <View />
        <Menu>
          <MenuItems />
        </Menu>
      </Container>
    )
  }
}

export default Main
```

## Grid

To render vectors and other stuff from upcoming stories we need to have a nice component that will provide the function to project coordinates from the format we are accustomed to — when **(0,0)** on the center of the view and the y-axis pointing up to **SVG** coordinates where **(0,0)** is in top-left corner and y- axis pointing down.

```JavaScript
this.props.updateProject(vector => {
  // we don't have transformation method in vector class yet, so:
  const scaled = vector.scaleBy(step)
  const withNegatedY = new Vector(
    scaled.components[0],
    -scaled.components[1]
  )
  const middle = getSide(size) / 2
  return withNegatedY.add(new Vector(middle, middle))
})
```

To catch the moment when the container of the **Grid** changes its size we wrap our component with function from the **react-size** library.

```JavaScript
...
import { withSize } from 'react-sizeme'
...

class Grid extends React.Component {
  updateProject = (size, cells) => {
    const step = getStepLen(size, cells)
    this.props.updateProject(() => /...)
  }

  componentWillReceiveProps({ size, cells }) {
    if (this.props.updateProject) {
      const newStepLen = getStepLen(size, cells)
      const oldStepLen = getStepLen(this.props.size, cells)
      if (newStepLen !== oldStepLen) {
        this.updateProject(size, cells)
      }
    }
  }

  componentDidMount() {
    if (this.props.updateProject) {
      this.updateProject(this.props.size, this.props.cells)
    }
  }
}

export default withSize({ monitorHeight: true })(Grid)
```

To make it easier to use the grid in different examples we write a **GridExample** component that receives two parameters — function that will render information, such as names and components of vectors, and function, that will render content on the grid, such as arrows.

```JavaScript
...
import Grid from './grid'
...
class Main extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      project: undefined
    }
  }
  render() {
    const { project } = this.state
    const { renderInformation, renderGridContent } = this.props
    const Content = () => {
      if (project && renderGridContent) {
        return renderGridContent({ project })
      }
      return null
    }
    const Information = () => {
      if (renderInformation) {
        return renderInformation()
      }
      return null
    }
    return (
      <Container>
        <Grid cells={10} updateProject={project => this.setState({ project })}>
          <Content />
        </Grid>
        <InfoContainer>
          <Information />
        </InfoContainer>
      </Container>
    )
  }
}

export default Main
```

Then we can use this component in our views. Let’s take a look at an example showing vectors addition.

```JavaScript
import React from 'react'
import { withTheme } from 'styled-components'
import { Vector } from 'linear-algebra/vector'

import GridExample from '../grid-example'
import Arrow from '../arrow'
import VectorView from '../vector'

const VectorsAddition = ({ theme }) => {
  const one = new Vector(0, 5)
  const other = new Vector(6, 2)
  const oneName = 'v⃗'
  const otherName = 'w⃗'
  const oneColor = theme.color.green
  const otherColor = theme.color.red
  const sum = one.add(other)
  const sumColor = theme.color.blue
  const sumText = `${oneName} + ${otherName}`

  const renderInformation = () => (
    <>
      <VectorView components={one.components} name={oneName} color={oneColor} />
      <VectorView
        components={other.components}
        name={otherName}
        color={otherColor}
      />
      <VectorView components={sum.components} name={sumText} color={sumColor} />
    </>
  )
  const renderGridContent = ({ project }) => (
    <>
      <Arrow project={project} vector={one} text={oneName} color={oneColor} />
      <Arrow
        project={project}
        vector={other}
        text={otherName}
        color={otherColor}
      />
      <Arrow project={project} vector={sum} text={sumText} color={sumColor} />
    </>
  )
  const props = { renderInformation, renderGridContent }

  return <GridExample {...props} />
}

export default withTheme(VectorsAddition)

```

## Arrow

Arrow consists of three **SVG** element — **line** to represent arrow, **polygon** to represent the head of an arrow, and **text** to show the name of a vector. To place an arrow the right way relative to the grid we receive the **project** function.

```JavaScript
import React from 'react'
import styled from 'styled-components'
import { Vector } from 'linear-algebra/vector'

const Arrow = styled.line`
  stroke-width: 2px;
  stroke: ${p => p.color};
`

const Head = styled.polygon`
  fill: ${p => p.color};
`

const Text = styled.text`
  font-size: 24px;
  fill: ${p => p.color};
`

export default ({ vector, text, color, project }) => {
  const direction = vector.normalize()

  const headStart = direction.scaleBy(vector.length() - 0.6)
  const headSide = new Vector(
    direction.components[1],
    -direction.components[0]
  ).scaleBy(0.2)
  const headPoints = [
    headStart.add(headSide),
    headStart.subtract(headSide),
    vector
  ]
    .map(project)
    .map(v => v.components)

  const projectedStart = project(new Vector(0, 0))
  const projectedEnd = project(vector)

  const PositionedText = () => {
    if (!text) return null
    const { components } = project(vector.withLength(vector.length() + 0.2))
    return (
      <Text color={color} x={components[0]} y={components[1]}>
        {text}
      </Text>
    )
  }
  return (
    <g>
      <Arrow
        color={color}
        x1={projectedStart.components[0]}
        y1={projectedStart.components[1]}
        x2={projectedEnd.components[0]}
        y2={projectedEnd.components[1]}
      />
      <Head color={color} points={headPoints} />
      <PositionedText />
    </g>
  )
}
```

[Next part ->](https://medium.com/@geekrodion/linear-algebra-vectors-f7610e9a0f23)

***

A lot of interesting stuff can be done by combining **React** and **SVG**, and in this series, we are going to add more features to this project to visualize examples that are coming next. There is also a similar article, about making of sophisticated bar charts with **React** and **SVG**, you can check out it [here](https://medium.com/@geekrodion/bar-chart-with-react-3b20b7907633).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
