> * 原文地址：[Developing Games with React, Redux, and SVG - Part 2](https://auth0.com/blog/developing-games-with-react-redux-and-svg-part-2/)
> * 原文作者：[Auth0](https://auth0.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/developing-games-with-react-redux-and-svg-part-2.md](https://github.com/xitu/gold-miner/blob/master/TODO1/developing-games-with-react-redux-and-svg-part-2.md)
> * 译者：[zephyrJS](https://github.com/zephyrJS)
> * 校对者：[anxsec](https://github.com/anxsec)、[smileShirely](https://github.com/smileShirely)

**TL;DR:** 在这个系列里，您将学会用 React 和 Redux 来控制一些 SVG 元素来创建一个游戏。通过本系列的学习，您不仅能创建游戏，还能用 React 和 Redux 来开发其他类型的动画。源码请参考 GitHub 仓库：[Aliens Go Home - Part 2](https://github.com/auth0-blog/aliens-go-home-part-2) 。

* * *

## React 游戏：Aliens, Go Home!

在这个系列里您将要开发的游戏叫做 Aliens, Go Home! 这个游戏的想法很简单，您将拥有一座炮台，然后您必须消灭那些试图入侵地球的飞碟。为了消灭这些飞碟，您必须在 SVG 画布上通过瞄准和点击来操作炮台的射击。

如果您很好奇, 您可以找到 [the final game up and running here](http://bang-bang.digituz.com.br/)。但别太沉迷其中，您还要完成它的开发！

> “我用 React、Redux 和 SVG 创建了一个游戏。”

## 前文概要 Part 1

在 [本系列的第一部分](https://auth0.com/blog/developing-games-with-react-redux-and-svg-part-1/)，您使用 [`create-react-app`](https://github.com/facebookincubator/create-react-app) 来开始您的 React 应用并安装和配置了 Redux 来管理游戏的状态。之后，您学会了如何将 SVG 和 React 组合在一起来创建诸如 `Sky`、`Ground`、`CannonBase` 和 `CannonPipe` 等游戏元素。最后，为了给炮台添加瞄准功能，您使用了一个事件监听器和 [JavaScript interval](https://www.w3schools.com/jsref/met_win_setinterval.asp) 触发 Redux _action_ 来更新 `CannonPipe` 的角度。

前面的这些学习是为了更好地理解如何使用 React、Redux 和 SVG 来创建游戏（或动画）而做准备。

> **注意：**不管出于什么原因，如果您没有 [本系列第一部分](https://auth0.com/blog/developing-games-with-react-redux-and-svg-part-1/) 的源码，您可以很容易的从 [这个 GitHub 仓库](https://github.com/auth0-blog/aliens-go-home-part-1) 进行克隆。在克隆完之后，您只需要按照下面几节中的说明进行操作即可。

## 创建更多的 React 组件

下面的几节将向您展示如何创建其余的游戏元素。尽管它们看起来很长，但它们都非常的简单和相似。按照指示去做，您可能几分钟就搞定了。

在这之后，您将看到本章最有趣的部分。它们分别是 **使飞碟随机出现** 和 **使用 CSS 动画移动飞碟**。

### 创建 Cannonball 组件

接下来您将创建 `CannonBall` 组件。请注意，目前它还不会动。但别担心！很快（在创建完其他组件之后），您将用炮台发射多个炮弹并杀死一些外星人。

为了创建这组件，需要在 `./src/components` 创建 `CannonBall.jsx` 文件并添加如下代码：

```JavaScript
import React from 'react';
import PropTypes from 'prop-types';

const CannonBall = (props) => {
  const ballStyle = {
    fill: '#777',
    stroke: '#444',
    strokeWidth: '2px',
  };
  return (
    <ellipse
      style={ballStyle}
      cx={props.position.x}
      cy={props.position.y}
      rx="16"
      ry="16"
    />
  );
};

CannonBall.propTypes = {
  position: PropTypes.shape({
    x: PropTypes.number.isRequired,
    y: PropTypes.number.isRequired
  }).isRequired,
};

export default CannonBall;
```

如您所见，要使炮弹出现在画布中，您必须向它传递一个包含 `x` 和 `y` 属性的对象。如果您对 `prop-types` 还不熟，这可能是您第一次使用 `PropTypes.shape`。幸运的是，这个特性不言自明。

创建此组件后，您可能希望在画布上看到它。为此，在 `Canvas` 组件里的 `svg` 元素中添加如下代码（当然您还需要加上 `import CannonBall from './CannonBall';`）：

```
<CannonBall position={{x: 0, y: -100}}/>
```

请记住，如果把它放在同一位置的元素之前，您将看不到它。因此，为了安全起见，将把它放在最后（就是 `<CannonBase />` 之后）。之后，您就可以在浏览器里看到您的新组件了。

> 如果您忘记了怎么操作的，您只需在项目根目录运行 `npm start` 然后在浏览器打开 [http://localhost:3000](http://localhost:3000) 。此外，**千万别**忘记在进行下一步之前把代码提交到您的仓库里。

### 创建 Current Score 组件

接下来您将创建另一个组件 `CurrentScore`。顾名思义，您将使用该组件向用户显示他们当前的分数。也就是说，每当他们消灭一只飞碟时，在这个组件中代表分数的值将会加一，并显示给他们。

在创建此组件之前，您可能需要添加并使用一些漂亮字体。实际上，您可能希望在整个游戏中配置和使用字体，这样看起来就不会像一个单调的游戏了。您可以从任何地方浏览并选择一种字体，但如果您想不花时间在这个上面，您只需在 `./src/index.css` 文件的顶部添加如下代码即可：

```JavaScript
@import url('https://fonts.googleapis.com/css?family=Joti+One');

/* other rules ... */
```

这将使您的游戏载入 [来自 Google 的 Joti One 字体](https://fonts.google.com/specimen/Joti+One)。

之后，您可以在 `./src/components` 目录下创建 `CurrentScore.jsx` 文件并添加如下代码：

```JavaScript
import React from 'react';
import PropTypes from 'prop-types';

const CurrentScore = (props) => {
  const scoreStyle = {
    fontFamily: '"Joti One", cursive',
    fontSize: 80,
    fill: '#d6d33e',
  };

  return (
    <g filter="url(#shadow)">
      <text style={scoreStyle} x="300" y="80">
        {props.score}
      </text>
    </g>
  );
};

CurrentScore.propTypes = {
  score: PropTypes.number.isRequired,
};

export default CurrentScore;
```

> **注意：** 如果您尚未配置 Joti One（或者配置了其他字体），您将需要修改相应的代码。如果您以后创建的其他组件也会用到该字体，请记住，您也需要更新这些组件。

如您所见，`CurrentScore` 组件仅需要一个属性：`score`。由于您的游戏还没有计算分数，为了马上看到这个组件，您需要传入一个硬编码的值。因此，在 `Canvas` 组件里，往 `svg` 中末尾添加 `<CurrentScore score={15} />`。另外，还需要添加 `import` 语句来获取这个组件（`import CurrentScore from './CurrentScore';`）。

如果您想现在就看到新组件，您**将无法**如愿以偿。这是因为组件使用了叫做 `shadow` 的 `filter`。尽管它不是必须的，但它将使您的游戏更加好看。另外，[给 SVG 元素添加阴影是十分简单的](https://www.w3schools.com/graphics/svg_feoffset.asp)。为此，仅需要在 `svg` 顶部添加如下代码：

```JavaScript
<defs>
  <filter id="shadow">
    <feDropShadow dx="1" dy="1" stdDeviation="2" />
  </filter>
</defs>
```

最后，您的 `Canvas` 将如下所示：

```JavaScript
import React from 'react';
import PropTypes from 'prop-types';
import Sky from './Sky';
import Ground from './Ground';
import CannonBase from './CannonBase';
import CannonPipe from './CannonPipe';
import CannonBall from './CannonBall';
import CurrentScore from './CurrentScore';

const Canvas = (props) => {
  const viewBox = [window.innerWidth / -2, 100 - window.innerHeight, window.innerWidth, window.innerHeight];
  return (
    <svg
      id="aliens-go-home-canvas"
      preserveAspectRatio="xMaxYMax none"
      onMouseMove={props.trackMouse}
      viewBox={viewBox}
    >
      <defs>
        <filter id="shadow">
          <feDropShadow dx="1" dy="1" stdDeviation="2" />
        </filter>
      </defs>
      <Sky />
      <Ground />
      <CannonPipe rotation={props.angle} />
      <CannonBase />
      <CannonBall position={{x: 0, y: -100}}/>
      <CurrentScore score={15} />
    </svg>
  );
};

Canvas.propTypes = {
  angle: PropTypes.number.isRequired,
  trackMouse: PropTypes.func.isRequired,
};

export default Canvas;
```

而您的游戏看起来将会是这样：

![Showing current score and cannonball in the Alien, Go Home! app.](https://cdn.auth0.com/blog/aliens-go-home/current-score-and-cannon-ball.png)

还不错，对吧？！

### 创建 Flying Object 组件

现在如何创建 React 组件来展示飞碟呢？飞碟既不是圆形，也不是矩形。它们通常有两个部分 (顶部和底部)，这些部分一般是圆形的。这就是为什么您将需要用 `FlyingObjectBase` 和 `FlyingObjectTop` 这个组件来创建飞碟的原因。

其中一个组件将使用贝塞尔三次曲线来定义其形状。另一个则是一个椭圆。

先从第一个组件 `FlyingObjectBase` 开始，在 `./src/components` 目录下创建 `FlyingObjectBase.jsx` 文件。并在该组件里添加如下代码：

```JavaScript
import React from 'react';
import PropTypes from 'prop-types';

const FlyingObjectBase = (props) => {
  const style = {
    fill: '#979797',
    stroke: '#5c5c5c',
  };

  return (
    <ellipse
      cx={props.position.x}
      cy={props.position.y}
      rx="40"
      ry="10"
      style={style}
    />
  );
};

FlyingObjectBase.propTypes = {
  position: PropTypes.shape({
    x: PropTypes.number.isRequired,
    y: PropTypes.number.isRequired
  }).isRequired,
};

export default FlyingObjectBase;
```

之后，您可以定义飞碟的顶部。为此，在 `./src/components` 目录下创建 `FlyingObjectTop.jsx` 文件并添加如下代码：

```JavaScript
import React from 'react';
import PropTypes from 'prop-types';
import { pathFromBezierCurve } from '../utils/formulas';

const FlyingObjectTop = (props) => {
  const style = {
    fill: '#b6b6b6',
    stroke: '#7d7d7d',
  };

  const baseWith = 40;
  const halfBase = 20;
  const height = 25;

  const cubicBezierCurve = {
    initialAxis: {
      x: props.position.x - halfBase,
      y: props.position.y,
    },
    initialControlPoint: {
      x: 10,
      y: -height,
    },
    endingControlPoint: {
      x: 30,
      y: -height,
    },
    endingAxis: {
      x: baseWith,
      y: 0,
    },
  };

  return (
    <path
      style={style}
      d={pathFromBezierCurve(cubicBezierCurve)}
    />
  );
};

FlyingObjectTop.propTypes = {
  position: PropTypes.shape({
    x: PropTypes.number.isRequired,
    y: PropTypes.number.isRequired
  }).isRequired,
};

export default FlyingObjectTop;
```

如果您还不知道贝塞尔三次曲线的核心工作原理，[您可以查看上一篇文章](https://auth0.com/blog/developing-games-with-react-redux-and-svg-part-1/) 来学习。

但为了让它们在游戏中能够随机的出现，我们很容易的能够想到将这些组件作为一个个单独的元素。为此，需在另外两个文件旁边创建一个名为 `FlyingObject.jsx` 的新文件，并添加如下代码：

```JavaScript
import React from 'react';
import PropTypes from 'prop-types';
import FlyingObjectBase from './FlyingObjectBase';
import FlyingObjectTop from './FlyingObjectTop';

const FlyingObject = props => (
  <g>
    <FlyingObjectBase position={props.position} />
    <FlyingObjectTop position={props.position} />
  </g>
);

FlyingObject.propTypes = {
  position: PropTypes.shape({
    x: PropTypes.number.isRequired,
    y: PropTypes.number.isRequired
  }).isRequired,
};

export default FlyingObject;
```

现在，想要在游戏中添加飞碟，只需使用一个 React 组件即可。为了达到目的，在 `Canvas` 组件添加如下代码：

```JavaScript
// ... other imports
import FlyingObject from './FlyingObject';

const Canvas = (props) => {
  // ...
  return (
    <svg ...>
      // ...
      <FlyingObject position={{x: -150, y: -300}}/>
      <FlyingObject position={{x: 150, y: -300}}/>
    </svg>
  );
};

// ... propTypes and export
```

![Creating flying objects in your React game](https://cdn.auth0.com/blog/aliens-go-home/flying-objects.png)

### 创建 Heart 组件

接下来您需要创建显示玩家生命值的组件，没有什么词是比用 `Heart` 更能代表生命了。所以，在 `./src/components` 目录下创建 `Heart.jsx` 文件并添加如下代码：

```JavaScript
import React from 'react';
import PropTypes from 'prop-types';
import { pathFromBezierCurve } from '../utils/formulas';

const Heart = (props) => {
  const heartStyle = {
    fill: '#da0d15',
    stroke: '#a51708',
    strokeWidth: '2px',
  };

  const leftSide = {
    initialAxis: {
      x: props.position.x,
      y: props.position.y,
    },
    initialControlPoint: {
      x: -20,
      y: -20,
    },
    endingControlPoint: {
      x: -40,
      y: 10,
    },
    endingAxis: {
      x: 0,
      y: 40,
    },
  };

  const rightSide = {
    initialAxis: {
      x: props.position.x,
      y: props.position.y,
    },
    initialControlPoint: {
      x: 20,
      y: -20,
    },
    endingControlPoint: {
      x: 40,
      y: 10,
    },
    endingAxis: {
      x: 0,
      y: 40,
    },
  };

  return (
    <g filter="url(#shadow)">
      <path
        style={heartStyle}
        d={pathFromBezierCurve(leftSide)}
      />
      <path
        style={heartStyle}
        d={pathFromBezierCurve(rightSide)}
      />
    </g>
  );
};

Heart.propTypes = {
  position: PropTypes.shape({
    x: PropTypes.number.isRequired,
    y: PropTypes.number.isRequired
  }).isRequired,
};

export default Heart;
```

如您所见，要想用 SVG 创建心形，您需要两条三次 Bezier 曲线：爱心的两边各一条。您还须向该组件添加一个 `position` 属性。这是因为游戏会给玩家提供不只一条生命，所以这些爱心需要显示在不同的位置。

现在，您可以先将一颗心添加到画布中，这样您就可以确认一切工作正常。为此，打开 `Canvas` 组件并添加如下代码：

```JavaScript
<Heart position={{x: -300, y: 35}} />
```

这必须是 `svg` 里最后一个元素。另外，别忘了添加 import 语句（`import Heart from './Heart';`）。

### 创建 Start Game 按钮组件

每个游戏都需要一个开始按钮。因此，为了创建它，在其他组件旁创建 `StartGame.jsx` 并添加如下代码：

```JavaScript
import React from 'react';
import PropTypes from 'prop-types';
import { gameWidth } from '../utils/constants';

const StartGame = (props) => {
  const button = {
    x: gameWidth / -2, // half width
    y: -280, // minus means up (above 0)
    width: gameWidth,
    height: 200,
    rx: 10, // border radius
    ry: 10, // border radius
    style: {
      fill: 'transparent',
      cursor: 'pointer',
    },
    onClick: props.onClick,
  };

  const text = {
    textAnchor: 'middle', // center
    x: 0, // center relative to X axis
    y: -150, // 150 up
    style: {
      fontFamily: '"Joti One", cursive',
      fontSize: 60,
      fill: '#e3e3e3',
      cursor: 'pointer',
    },
    onClick: props.onClick,
  };
  return (
    <g filter="url(#shadow)">
      <rect {...button} />
      <text {...text}>
        Tap To Start!
      </text>
    </g>
  );
};

StartGame.propTypes = {
  onClick: PropTypes.func.isRequired,
};

export default StartGame;
```

由于不需要同时显示多个 `StartGame` 按钮，您需要为该组件在游戏里设置固定的位置（`x: 0` and `y: -150`）。该组件与您之前定义的其他组件之间还有另外两个不同之处：

*   首先，这个组件需要一个名为 `onClick` 的函数。这个函数是用来监听按钮点击事件，并将触发一个 Redux action 来使您的应用开始一个新的游戏。
*   其次，这个组件正在使用一个您还没有定义的常量 `gameWidth`。这个常数将表示可用的区域。除了您的应用所占据的位置之外，其他区域都将不可用。

为了定义 `gameWidth` 常量，需要打开 `./src/utils/constants.js` 文件并添加如下代码：

```JavaScript
export const gameWidth = 800;
```

之后，您可以将 `StartGame` 组件添加到 `Canvas` 中，方式是往 `svg` 元素中的末尾添加 `<StartGame onClick={() => console.log('Aliens, Go Home!')} />`。跟之前一样，别忘了添加 import 语句（`import StartGame from './StartGame';`）。

![Aliens, Go Home! game with the start game button](https://cdn.auth0.com/blog/aliens-go-home/adding-start-button.png)

### 创建 Title 组件

`Title` 组件是本篇文章您将创建最后一个组件. 您已经为您的游戏起了名字了：**Aliens, Go Home!**。因此，创建 `Title.jsx`（在 `./src/components` 目录下)文件来作为标题并添加如下代码：

```JavaScript
import React from 'react';
import { pathFromBezierCurve } from '../utils/formulas';

const Title = () => {
  const textStyle = {
    fontFamily: '"Joti One", cursive',
    fontSize: 120,
    fill: '#cbca62',
  };

  const aliensLineCurve = {
    initialAxis: {
      x: -190,
      y: -950,
    },
    initialControlPoint: {
      x: 95,
      y: -50,
    },
    endingControlPoint: {
      x: 285,
      y: -50,
    },
    endingAxis: {
      x: 380,
      y: 0,
    },
  };

  const goHomeLineCurve = {
    ...aliensLineCurve,
    initialAxis: {
      x: -250,
      y: -780,
    },
    initialControlPoint: {
      x: 125,
      y: -90,
    },
    endingControlPoint: {
      x: 375,
      y: -90,
    },
    endingAxis: {
      x: 500,
      y: 0,
    },
  };

  return (
    <g filter="url(#shadow)">
      <defs>
        <path
          id="AliensPath"
          d={pathFromBezierCurve(aliensLineCurve)}
        />
        <path
          id="GoHomePath"
          d={pathFromBezierCurve(goHomeLineCurve)}
        />
      </defs>
      <text {...textStyle}>
        <textPath xlinkHref="#AliensPath">
          Aliens,
        </textPath>
      </text>
      <text {...textStyle}>
        <textPath xlinkHref="#GoHomePath">
          Go Home!
        </textPath>
      </text>
    </g>
  );
};

export default Title;
```

为了使标题弯曲显示，您使用了 `path` 和 `textPath` 元素与三次贝塞尔曲线的组合。此外，您还使用了固定的坐标位置，就像 `StartGame` 按钮组件那样。

现在，要将该组件添加到画布中，只需将 `<title/>` 组件添加到 `svg` 元素中，并在 `Canvas.jsx` 文件的顶部添加 import 语句即可（`import Title from './Title';`）。但是，如果您现在运行您的应用程序，您将发现您的新组件没有出现在屏幕上。这是因为您的应用程序还没有足够的垂直空间用于显示。

## 让您的 React Game游戏自适应

为了改变游戏的尺寸并使其自适应，您将需要做以下两件事。首先，您将需要添加 `onresize` 事件监听器到全局 `window` 对象上。很简单，您仅需要打开 `./src/App.js` 文件并将如下代码添加到  `componentDidMount()` 方法中：

```JavaScript
window.onresize = () => {
  const cnv = document.getElementById('aliens-go-home-canvas');
  cnv.style.width = `${window.innerWidth}px`;
  cnv.style.height = `${window.innerHeight}px`;
};
window.onresize();
```

这将使您应用的大小和用户看到的窗口大小保持一致，即使他们改变了窗口大小也没关系。当应用程序第一次出现时，它还将强制执行 `window.onresize` 函数。

其次，您需要更改画布的 `viewBox` 属性。现在，不需要再 Y 轴上定义最高点：`100 - window.innerHeight`（如果您不记得为什么要使用这个公式，[请看一下本系列的第一部分](https://auth0.com/blog/developing-games-with-react-redux-and-svg-part-1/)）并且 `viewBox` 高度等于 `window` 对象上 `innerHeight` 的值，下列使您将用到的代码：

```JavaScript
const gameHeight = 1200;
const viewBox = [window.innerWidth / -2, 100 - gameHeight, window.innerWidth, gameHeight];
```

在这个新版本中，您使用的值为 `1200`，这样您的应用就能正确地显示新的标题组件。此外，这个新的垂直空间将给您的用户足够的时间来看到和消灭那些外星飞碟。这将给到他们足够的时间来射击和消灭这些飞碟。

![Changing your React, Redux, and SVG game dimensions and making it responsive](https://cdn.auth0.com/blog/aliens-go-home/react-game-with-title.png)

## 让用户开始游戏

当把这些新组件按的尺寸放在对应的位置以后，您就可以开始考虑怎么让用户开始玩游戏了。无论何时，当用户点了 Start Game 这个按钮，您就需要能游戏切换到开始状态，这将导致游戏一连串的状态变化。为了更便于用户操作，当用户点击了这个按钮的时候，您就可以开始将 `Title` 和 `StartGame` 这两个组件从当前的屏幕上移除。

为此，您将需要创建一个新的 Redux action，它将传入到 Redux reducer 中来改变游戏的状态。为了创建这个新的 action，打开 `./src/actions/index.js` 并添加如下代码（保留之前的代码不变）：

```JavaScript
// ... MOVE_OBJECTS
export const START_GAME = 'START_GAME';

// ... moveObjects

export const startGame = () => ({
  type: START_GAME,
});
```

接着，您可以重构 `./src/reducers/index.js` 来处理这个新 action。文件的新版本如下所示：

```JavaScript
import { MOVE_OBJECTS, START_GAME } from '../actions';
import moveObjects from './moveObjects';
import startGame from './startGame';

const initialGameState = {
  started: false,
  kills: 0,
  lives: 3,
};

const initialState = {
  angle: 45,
  gameState: initialGameState,
};

function reducer(state = initialState, action) {
  switch (action.type) {
    case MOVE_OBJECTS:
      return moveObjects(state, action);
    case START_GAME:
      return startGame(state, initialGameState);
    default:
      return state;
  }
}

export default reducer;
```

如您所见，现在在 `initialState` 中有一个子对象，它包含三个跟游戏有关的属性：

1.  `started`: 一个表示是否开始运行游戏的标识；
2.  `kills`: 一个保存用户消灭的飞碟数量的属性；
3.  `lives`: 一个保存用户还有多少条命的属性；

此外，您还需要在 `switch` 语句中添加一个新的 `case`。这个新的 `case` (包含 `type` `START_GAME` 的 action 传入到 reducer 时触发）调用 `startGame` 函数。这个函数的作用是将 `gameState` 里的 `started` 属性设置为 true。此外，每当用户开始一个新的游戏，这个函数将 `kills` 计数器设置为零并让用户一开始有三条命。

要实现 `startGame` 函数，需要在 `./src/reducers` 目录下创建 `startGame.js` 文件并添加如下代码：

```JavaScript
export default (state, initialGameState) => {
  return {
    ...state,
    gameState: {
      ...initialGameState,
      started: true,
    }
  }
};
```

如您所见，这个新文件中的代码非常简单。它只是返回新的 state 对象到 Redux store 中，并将  `started` 设置为 `true` 同时重置 `gameState` 中的所有其他属性。这将使用户再次获得三条命，并将 `kills` 计数器设置为零。

实现这个函数之后，您必须将其传递给您的游戏。您还须将新的 `gameState` 属性传递给它。所以，为了做到这一点，您需要修改 `./src/containers/Game.js` 文件，代码如下所示：

```JavaScript
import { connect } from 'react-redux';
import App from '../App';
import { moveObjects, startGame } from '../actions/index';

const mapStateToProps = state => ({
  angle: state.angle,
  gameState: state.gameState,
});

const mapDispatchToProps = dispatch => ({
  moveObjects: (mousePosition) => {
    dispatch(moveObjects(mousePosition));
  },
  startGame: () => {
    dispatch(startGame());
  },
});

const Game = connect(
  mapStateToProps,
  mapDispatchToProps,
)(App);

export default Game;
```

总而言之，您在此文件中所做的更改如下：

*   `mapStateToProps`: 现在，`App` 组件关注 `gameState` 属性已经告知了 Redux。
*   `mapDispatchToProps`: 您也告知了 Redux 需要将 `startGame` 函数传递给 `App` 组件，这样它就可以触发这个新 action。

这些新的 `App` 属性（`gameState` 和 `startGame`）不会被 `App` 组件直接使用。实际上，使用它们的是 `Canvas` 组件，所以您必须将它们传递给它。因此，打开 `./src/App.js` 文件并按如下方式重构：

```JavaScript
// ... import statements ...

class App extends Component {
  // ... constructor(props) ...

  // ... componentDidMount() ...

  // ... trackMouse(event) ...

  render() {
    return (
      <Canvas
        angle={this.props.angle}
        gameState={this.props.gameState}
        startGame={this.props.startGame}
        trackMouse={event => (this.trackMouse(event))}
      />
    );
  }
}

App.propTypes = {
  angle: PropTypes.number.isRequired,
  gameState: PropTypes.shape({
    started: PropTypes.bool.isRequired,
    kills: PropTypes.number.isRequired,
    lives: PropTypes.number.isRequired,
  }).isRequired,
  moveObjects: PropTypes.func.isRequired,
  startGame: PropTypes.func.isRequired,
};

export default App;
```

然后，打开 `./src/components/Canvas.jsx` 文件并替换成如下代码：

```JavaScript
import React from 'react';
import PropTypes from 'prop-types';
import Sky from './Sky';
import Ground from './Ground';
import CannonBase from './CannonBase';
import CannonPipe from './CannonPipe';
import CurrentScore from './CurrentScore'
import FlyingObject from './FlyingObject';
import StartGame from './StartGame';
import Title from './Title';

const Canvas = (props) => {
  const gameHeight = 1200;
  const viewBox = [window.innerWidth / -2, 100 - gameHeight, window.innerWidth, gameHeight];
  return (
    <svg
      id="aliens-go-home-canvas"
      preserveAspectRatio="xMaxYMax none"
      onMouseMove={props.trackMouse}
      viewBox={viewBox}
    >
      <defs>
        <filter id="shadow">
          <feDropShadow dx="1" dy="1" stdDeviation="2" />
        </filter>
      </defs>
      <Sky />
      <Ground />
      <CannonPipe rotation={props.angle} />
      <CannonBase />
      <CurrentScore score={15} />

      { ! props.gameState.started &&
        <g>
          <StartGame onClick={() => props.startGame()} />
          <Title />
        </g>
      }

      { props.gameState.started &&
        <g>
          <FlyingObject position={{x: -150, y: -300}}/>
          <FlyingObject position={{x: 150, y: -300}}/>
        </g>
      }
    </svg>
  );
};

Canvas.propTypes = {
  angle: PropTypes.number.isRequired,
  gameState: PropTypes.shape({
    started: PropTypes.bool.isRequired,
    kills: PropTypes.number.isRequired,
    lives: PropTypes.number.isRequired,
  }).isRequired,
  trackMouse: PropTypes.func.isRequired,
  startGame: PropTypes.func.isRequired,
};

export default Canvas;
```

如您所见，在这个新版本中，只有当 `gameState.started` 设置为 false 时 `StartGame` 和 `Title` 才会可见。此外，您还隐藏了 `FlyingObject` 组件直到用户点击 **Start Game** 按钮才会出现。

如果您现在运行您的应用程序（如果它还没有运行，在 terminal 里运行 `npm start`），您将看到这些新的变化。虽然用户还不能玩您的游戏，但您已经完成一个小目标了。

## 让飞碟随机出现

现在您已经实现了 **Start Game** 功能，您可以重构您的游戏来让飞碟随机出现。您的用户需要消灭一些飞碟，所以您还需要让它们飞起来（即往屏幕下方移动）。但首先，您必须集中精力让它们以某种方式出现。

要做到这一点，第一件事是定义这些对象将出现在何处。您还必须给飞行物体设置一些间隔和最大数量。为了使事情井然有序，您可以定义常量来保存这些规则。所以，打开 `./src/utils/constants.js` 文件添加如下代码：

```JavaScript
// ... keep skyAndGroundWidth and gameWidth untouched

export const createInterval = 1000;

export const maxFlyingObjects = 4;

export const flyingObjectsStarterYAxis = -1000;

export const flyingObjectsStarterPositions = [
  -300,
  -150,
  150,
  300,
];
```

上面的规则规定游戏将每秒（`1000` 毫秒）出现新的飞碟，同一时间不会超过四个（`maxFlyingObjects`）。它还定义了新对象在 Y 轴（`flyingObjectsStarterYAxis`）上出现的位置为 `-1000`。文件中最后一个常量（`flyingObjectsStarterPositions`）定义了四个值表示对象在 X 轴可以显示的位置。您将随机选择其中一个值来创建飞碟。

要实现使用这些常量的函数，需在 `./src/reducers` 目录下创建 `createFlyingObjects.js` 文件并添加如下代码：

```JavaScript
import {
  createInterval, flyingObjectsStarterYAxis, maxFlyingObjects,
  flyingObjectsStarterPositions
} from '../utils/constants';

export default (state) => {
  if ( ! state.gameState.started) return state; // game not running

  const now = (new Date()).getTime();
  const { lastObjectCreatedAt, flyingObjects } = state.gameState;
  const createNewObject = (
    now - (lastObjectCreatedAt).getTime() > createInterval &&
    flyingObjects.length < maxFlyingObjects
  );

  if ( ! createNewObject) return state; // no need to create objects now

  const id = (new Date()).getTime();
  const predefinedPosition = Math.floor(Math.random() * maxFlyingObjects);
  const flyingObjectPosition = flyingObjectsStarterPositions[predefinedPosition];
  const newFlyingObject = {
    position: {
      x: flyingObjectPosition,
      y: flyingObjectsStarterYAxis,
    },
    createdAt: (new Date()).getTime(),
    id,
  };

  return {
    ...state,
    gameState: {
      ...state.gameState,
      flyingObjects: [
        ...state.gameState.flyingObjects,
        newFlyingObject
      ],
      lastObjectCreatedAt: new Date(),
    }
  }
}
```

第一看上去，可能会觉得这段代码很复杂。然而，情况却恰恰相反。它的工作原理总结如下：

1.  如果游戏没有运行（即 `! state.gameState.started`），这代码返回当前未更改的 state。
2.  如果游戏正在运行，这个函数依据 `createInterval` 和 `maxFlyingObjects` 常量来决定是否创建新的飞行对象。这些逻辑构成了 `createNewObject` 常量。
3.  如果 `createNewObject` 常量的值设置为 `true`，这个函数使用 `Math.floor` 获取 0 到 3 的随机数（`Math.random() * maxFlyingObjects`）来决定新的飞碟将出现在哪。
4.  有了这些数据，这个函数将创建带有 `position` 属性 `newFlyingObject` 对象。
5.  最后，该函数返回一个带有新飞行对象的新状态对象，并更新 `lastObjectCreatedAt` 的值。

您可能已经注意到，您刚刚创建的函数是一个 reducer。因此，您可能希望创建一个 action 来触发这个  reducer，但事实上您并不需要这样做。因为您的游戏有一个每 `10` 毫秒触发一个 `MOVE_OBJECTS` 的 action，您可以利用这个 action 来触发这个新的 reducer。因此，您必须按如下方式重新实现  `moveObjects` reducer（`./src/reducers/moveObjects.js`），代码实现如下：

```JavaScript
import { calculateAngle } from '../utils/formulas';
import createFlyingObjects from './createFlyingObjects';

function moveObjects(state, action) {
  const mousePosition = action.mousePosition || {
    x: 0,
    y: 0,
  };

  const newState = createFlyingObjects(state);

  const { x, y } = mousePosition;
  const angle = calculateAngle(0, 0, x, y);
  return {
    ...newState,
    angle,
  };
}

export default moveObjects;
```

新版本的 `moveObjects` reducer 跟之前不一样的有：

*   首先，如果在 `action` 对象中没有传入 `mousePosition` 常量，则强制创建它。这样做的原因是如果没有传递 `mousePosition` 则上一个版本 reducer 将停止运行。
*   其次，它从 `createFlyingObjects` reducer 中获取 `newState` 对象，以便在需要的时候创建新的飞碟。
*   最后，它会根据上一步检索到的 `newState` 对象返回新的对象。

在重构 `App` 和 `Canvas` 组件来通过这段的代码显示新的飞碟前，您将需要更新 `./src/reducers/index.js` 文件来给 `initialState` 对象添加两个新属性：

```JavaScript
// ... import statements ...

const initialGameState = {
  // ... other initial properties ...
  flyingObjects: [],
  lastObjectCreatedAt: new Date(),
};

// ... everything else ...
```

这样做之后，您需要做的就是在 `App` 组件的 `propTypes` 对象中添加 `flyingObjects`：

```JavaScript
// ... import statements ...

// ... App component class ...

App.propTypes = {
  // ... other propTypes definitions ...
  gameState: PropTypes.shape({
    // ... other propTypes definitions ...
    flyingObjects: PropTypes.arrayOf(PropTypes.shape({
      position: PropTypes.shape({
        x: PropTypes.number.isRequired,
        y: PropTypes.number.isRequired
      }).isRequired,
      id: PropTypes.number.isRequired,
    })).isRequired,
    // ... other propTypes definitions ...
  }).isRequired,
  // ... other propTypes definitions ...
};

export default App;
```

接着让 `Canvas` 遍历这个属性，来显示新的飞碟。请确保使用如下代码替换 `FlyingObject` 组件的静态定位实例：

```
// ... import statements ...

const Canvas = (props) => {
  // ... const definitions ...
  return (
    <svg ... >
      // ... other SVG elements and React Components ...

      {props.gameState.flyingObjects.map(flyingObject => (
        <FlyingObject
          key={flyingObject.id}
          position={flyingObject.position}
        />
      ))}
    </svg>
  );
};

Canvas.propTypes = {
  // ... other propTypes definitions ...
  gameState: PropTypes.shape({
    // ... other propTypes definitions ...
    flyingObjects: PropTypes.arrayOf(PropTypes.shape({
      position: PropTypes.shape({
        x: PropTypes.number.isRequired,
        y: PropTypes.number.isRequired
      }).isRequired,
      id: PropTypes.number.isRequired,
    })).isRequired,
  }).isRequired,
  // ... other propTypes definitions ...
};

export default Canvas;
```

就是这样！现在，在用户开始游戏时，您的应用程序将创建并随机显示飞碟。

> **注意：** 如果您现在运行您的应用程序并点击 **Start Game** 按钮，您最终可能只看到一只飞碟。 这是因为没有什么能阻止飞碟出现在 X 轴相同的位置。在下一节中，您将使您的飞行物体沿着 Y 轴移动。这将确保您和您的用户能够看到所有的飞碟。

### 使用 CSS 动画来移动飞碟

有两种方式可以让您的飞碟移动。第一种显而易见的方式是使用 JavaScript 代码来改变他们的位置。尽管这种方法看起来很容易实现，但它事实上是行不通的，因为它会降低游戏的性能。

第二种也是首选的方法是使用 CSS 动画。[这种方法的优点是它使用 GPU 对元素进行动画处理](https://www.smashingmagazine.com/2016/12/gpu-animation-doing-it-right/)，从而提高了应用程序的性能。

您可能认为这种方法很难实现，但如您所见，事实却并非如此。最棘手的部分是，您将需要另一个 NPM 包来将  CSS 动画和 React 结合起来。也就是说，您需要安装 [`styled-components` 包](https://www.styled-components.com/)。

> **“通过使用标记模板字面量（JavaScript 最新添加）和 CSS 的强大功能，styled-components 允许您使用原生的 CSS 代码定义您组件的样式。它也删除了 components 和 styles 之间的映射 —— 将组件用作低级样式构造是不容易的！”** —[`styled-components`](https://github.com/styled-components/styled-components)

要安装这个 package，您需要停止您的 React 应用（即他已经启动和正在运行）并使用以下命令：

```Bash
npm i styled-components
```

安装完以后，您可以使用下列代码替换 `FlyingObject` 组件（`./src/components/FlyingObject.jsx`）：

```JavaScript
import React from 'react';
import PropTypes from 'prop-types';
import styled, { keyframes } from 'styled-components';
import FlyingObjectBase from './FlyingObjectBase';
import FlyingObjectTop from './FlyingObjectTop';
import { gameHeight } from '../utils/constants';

const moveVertically = keyframes`
  0% {
    transform: translateY(0);
  }
  100% {
    transform: translateY(${gameHeight}px);
  }
`;

const Move = styled.g`
  animation: ${moveVertically} 4s linear;
`;

const FlyingObject = props => (
  <Move>
    <FlyingObjectBase position={props.position} />
    <FlyingObjectTop position={props.position} />
  </Move>
);

FlyingObject.propTypes = {
  position: PropTypes.shape({
    x: PropTypes.number.isRequired,
    y: PropTypes.number.isRequired
  }).isRequired,
};

export default FlyingObject;
```

在这个新版本中，您已经将 `FlyingObjectBase` 和 `FlyingObjectTop` 组件放到新的组件 `Move` 里面。这个组件只是使用一个 `moveVertically` 变换来定义 SVG 的 `g` 元素的 `styled` 样式。为了学习更多关于变换的知识以及如何使用 `styled-components`，您可以在这里查阅 [官方文档](https://www.styled-components.com/docs/) 以及 [MDN 网站上的 **使用 CSS 动画**](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Animations/Using_CSS_animations) 来学习这些知识。

最后，为了替换纯的/不动的飞碟，您需要添加带有 transformation（一个 CSS 规则）的飞碟，它们将从起始位置（`transform: translateY(0);`）移动到游戏的底部（`transform: translateY(${gameHeight}px);`）。

当然，您必须将 `gameHeight` 常量添加到 `./src/utils/constants.js` 文件中。另外，由于您需要更新该文件，所以您可以替换 `flyingObjectsStarterYAxis` 来使对象在用户看不到的位置启动。但现在的当前值却是飞碟刚好出现在可视区域的中央，这会令最终用户感到奇怪。

为了更正它，您需要打开 `constants.js` 文件并进行如下更改：

```JavaScript
// keep other constants untouched ...

export const flyingObjectsStarterYAxis = -1100;

// keep flyingObjectsStarterPositions untouched ...

export const gameHeight = 1200;
```

最后，你需要在 4 秒后消灭飞碟，这样新的飞碟将会出现并在画布中移动。为了实现这一点，您可以在 `./src/reducers/moveObjects.js` 文件中的代码进行如下更改：

```JavaScript
import { calculateAngle } from '../utils/formulas';
import createFlyingObjects from './createFlyingObjects';

function moveObjects(state, action) {
  const mousePosition = action.mousePosition || {
    x: 0,
    y: 0,
  };

  const newState = createFlyingObjects(state);

  const now = (new Date()).getTime();
  const flyingObjects = newState.gameState.flyingObjects.filter(object => (
    (now - object.createdAt) < 4000
  ));

  const { x, y } = mousePosition;
  const angle = calculateAngle(0, 0, x, y);
  return {
    ...newState,
    gameState: {
      ...newState.gameState,
      flyingObjects,
    },
    angle,
  };
}

export default moveObjects;
```

如您所见，我们为 `gameState` 对象的 `flyingObjects` 属性添加了新的代码过滤器，它移除了大于或等于 `4000`（4 秒）的对象。

如果您现在重新启动您的应用程序（`npm start`）并点击 **Start Game** 按钮，您将看到飞碟在画布中自顶向上地移动。此外，您会注意到，游戏在创建新的飞碟之后，现有的飞碟都会移动到画布的底部。

![Using CSS animation with React](https://cdn.auth0.com/blog/aliens-go-home/flying-objects-moving.png)

> "在 React 中使用 CSS 动画是很简单的，而且会提高您应用的性能。"

## 总结和下一步

在本系列的第二部分中，您通过使用 React、Redux 和 SVG 创建了您游戏所需大部分元素。最后，您还使飞碟不同的位置随机出现，并利用 CSS 动画，使他们顺利飞行。

[在本系列的下一篇也是最后一篇中](https://auth0.com/blog/developing-games-with-react-redux-and-svg-part-3/)，您将实现游戏剩余的功能。也就是说，您将实现：使用您的大炮消灭飞碟；控制您的用户的生命条；以及记录您的用户将会杀死多少只飞碟。您还将使用 [Auth0](https://auth0.com/)  和 [Socket.IO](https://socket.io/) 来实现实时排行榜。请继续关注！


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。


