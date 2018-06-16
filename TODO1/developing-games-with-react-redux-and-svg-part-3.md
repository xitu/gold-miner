> * 原文地址：[Developing Games with React, Redux, and SVG - Part 3](https://auth0.com/blog/developing-games-with-react-redux-and-svg-part-3/)
> * 原文作者：[Bruno Krebs](https://twitter.com/brunoskrebs)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/developing-games-with-react-redux-and-svg-part-3.md](https://github.com/xitu/gold-miner/blob/master/TODO1/developing-games-with-react-redux-and-svg-part-3.md)
> * 译者：[xueshuai](https://github.com/xueshuai)
> * 校对者：[jasonxia23](https://github.com/jasonxia23) [smileforward123](https://github.com/smileforward123)

# 使用 React, Redux, and SVG 开发游戏 - 第 3 部分

**提示：** 在这个系列中，你将学习如何使用 React 和 Redux 控制一堆 SVG 元素来创建一个游戏。这个系列所需要的知识同样也可以使你创建使用 React 和 Redux 的其他类型的动画，而不只是游戏。你能够在下面的 GitHub 仓库中找到文章中开发的最终代码：[Aliens Go Home - 第 3 部分](https://github.com/auth0-blog/aliens-go-home-part-3)

* * *

## React 游戏：Aliens, Go Home!

在这个教程中你开发的游戏叫做 _Aliens, Go Home!_ 这个游戏的想法很简单，你有一门大炮，你将必须杀掉尝试入侵地球的飞行物体。要杀掉这些飞行的物体，你将必须标示和点击 SVG canvas 来使你的大炮发射。

如果你有些疑惑，你可以发现[完成了的游戏并在这里运行它](http://bang-bang.digituz.com.br/)。但是不要玩的太多，你还有工作必须做。

> “我正在用 React，Redux 和 SVG元素

创建一个游戏。”

## 之前，在第一部分和第二部分

在[这个系列的第一部分](https://auth0.com/blog/developing-games-with-react-redux-and-svg-part-1/)，你已经使用 [`create-react-app`](https://github.com/facebookincubator/create-react-app) 来启动你的 React 应用，你已经安装和配置了 Redux 来管理游戏的状态。之后，在创建游戏的元素时，例如  `Sky`， `Ground`， `CannonBase` 和 `CannonPipe`, 你已经学习了如何在 React 组件中使用 SVG。最终，你通过使用事件监听方法给你的大炮添加动画效果和一个 [JavaScript interval](https://www.w3schools.com/jsref/met_win_setinterval.asp) 来触发 Redux 的 _action_ 更新 `CannonBase` 的角度。

这些为你提供了理解如何使用React,Redux和SVG来创建你的游戏（和其他动画）的方法。

在 [第二部分](https://auth0.com/blog/developing-games-with-react-redux-and-svg-part-2/)，你已经创建了游戏中其他的必须元素（例如 `Heart`， `FlyingObject` 和 `CannonBall`），使你的玩家能够开始游戏，并使用 CSS 动画让飞行物体飞起来（这就是他们应该做的事，对么？）。

就算是我们有了这些非常好的特性，但是他们还没有构成一个完整的游戏。你仍然需要使你的大炮发射炮弹，并完成一个算法来检测飞行物体和炮弹的碰撞。除此之外，你必须在你的玩家杀死外星人的时候，增加 `CurrentScore`。

杀死外星人和看到当前分数的增长很酷，但是你可能会使这个游戏更有吸引力。。这就是为什么你要在你的游戏中增加一个排行榜特性。这将会使你的玩家花费更多的时间来达到排行榜的高位。


有了这些特性，你可以说你有了一个完整的游戏。所以，为了节约时间，是时候关注他们了。

> **提示：** 如果（无论是什么原因）你没有 [前面两部分](https://auth0.com/blog/developing-games-with-react-redux-and-svg-part-2/) 创建的代码，你可以从 [这个 GitHub 仓库](https://github.com/auth0-blog/aliens-go-home-part-2) 克隆他们。克隆之后，你能够继续跟随接下来板块中的指示。

## 在你的 React 游戏里实现排行榜特性

第一件你要做的使你的游戏看起来更像一个真正的游戏的事情就是实现排行榜特性。这个特性将使玩家能够登陆，所以你的游戏能够跟踪他们的最高分数和他们的排名。

## 整合 React 和 Auth0

要使 Auth0 管理你的玩家的身份，你必须有一个 Auth0 账户。如果你还没有，你可以 [在这里 **注册一个免费 Auth0 账户**](https://auth0.com/signup)。

注册完你的账户之后，你只需要创建一个  [Auth0 应用](https://auth0.com/docs/applications) 来代表你的游戏。要做这个，前往 [Auth0 的仪表盘中的 Application 页面](https://manage.auth0.com/#/applications) ，然后点击 _Create Application_ 按钮。仪表盘将会给你展示一个表单，你必须输入你的应用的 _name_ 和 _type_ 。你能输入 _Aliens, Go Home!_ 作为名字，并选择  _Single Page Web Application_ 作为类型（毕竟你的游戏是基于 React 的 SPA）。然后，你可以点击  _Create_。

![创建 Auth0 应用来代表你的游戏。](https://cdn.auth0.com/blog/aliens-go-home/creating-the-auth0-client-for-your-react-game.png)

当你点击这个按钮，仪表盘将会把你重定向到你的新应用的 _Quick Start_ 标签页。正如你将在这篇文章中学习如何整合 React 和 Auth0，你不需要使用这个标签页。取而代之的，你将需要使用 _Settings_ 标签页，所以我们前往这个页面。

这里有三件事你需要在这个标签页做。第一件是添加 `http://localhost:3000` 到名为 _Allowed Callback URLs_ 的字段。正如仪表盘解释的， _在你的玩家认证之后, Auth0 只会回跳到这个字段 URLs 中的一个_ 。所以，如果你想在网络上发布你的游戏，不要忘了在那里同样加入你的外网 URL （例如 `http://aliens-go-home.digituz.com.br`）。

在这个字段输入你所有的 URLs 之后，点击 _Save_ 按钮或者按下 `ctrl` + `s` （如果你是用的是 MacBook，你需要按下 `command` + `s`）。

你需要做的最后两件事是复制 _Domain_ 和 _Client ID_ 字段的值。不管怎样，在你使用这些值之前，你需要敲一些代码。

对于初学者，你将需要在你游戏的根目录下输入以下命令来安装 `auth0-web` 包：

```
npm i auth0-web
```

正如你将看到的，这个包将有助于整合 Auth0 和 SPAs。

下一步是在你的游戏中增加一个登陆按钮，使你的玩家能够通过 Auth0\ 认证。完成这个，要在 `./src/components` 目录下创建一个名为 `Login.jsx` 的文件，加入以下的代码：

```
import React from 'react';
import PropTypes from 'prop-types';

const Login = (props) => {
  const button = {
    x: -300, // half width
    y: -600, // minus means up (above 0)
    width: 600,
    height: 300,
    style: {
      fill: 'transparent',
      cursor: 'pointer',
    },
    onClick: props.authenticate,
  };

  const text = {
    textAnchor: 'middle', // center
    x: 0, // center relative to X axis
    y: -440, // 440 up
    style: {
      fontFamily: '"Joti One", cursive',
      fontSize: 45,
      fill: '#e3e3e3',
      cursor: 'pointer',
    },
    onClick: props.authenticate,
  };

  return (
    <g filter="url(#shadow)">
      <rect {...button} />
      <text {...text}>
        Login to participate!
      </text>
    </g>
  );
};

Login.propTypes = {
  authenticate: PropTypes.func.isRequired,
};

export default Login;
```

你刚刚创建的组件当被点击的时候会做什么是不可知的。你需要在把它加入 `Canvas` 组件的时候定义它的操作。所以，打开 `Canvas.jsx` 文件，参照下面更新它：

```
// ... other import statements
import Login from './Login';
import { signIn } from 'auth0-web';

const Canvas = (props) => {
  // ... const definitions
  return (
    <svg ...>
      // ... other elements

      { ! props.gameState.started &&
      <g>
        // ... StartGame and Title components
        <Login authenticate={signIn} />
      </g>
      }

      // ... flyingObjects.map
    </svg>
  );
};
// ... propTypes definition and export statement
```

正如你看见的，在这个新版本里，你已经引入了 `Login` 组件和 `auth0-web` 包里的 `signIn` 方法。然后，你已经把你的新组件加入到了代码块中，只在玩家没有开始游戏的时候出现。同样的，你已经预料到，当点击的时候，登陆按钮一定会触发 `signIn` 方法。

当这些变化发生的时候，最后一件你必须做的事是在你的 Auth0 应用的属性中配置 `auth0-web`。要做这件事，需要打开 `App.js` 文件并按照下面更新它：

```
// ... other import statements
import * as Auth0 from 'auth0-web';

Auth0.configure({
  domain: 'YOUR_AUTH0_DOMAIN',
  clientID: 'YOUR_AUTH0_CLIENT_ID',
  redirectUri: 'http://localhost:3000/',
  responseType: 'token id_token',
  scope: 'openid profile manage:points',
});

class App extends Component {
  // ... constructor definition

  componentDidMount() {
    const self = this;

    Auth0.handleAuthCallback();

    Auth0.subscribe((auth) => {
      console.log(auth);
    });

    // ... setInterval and onresize
  }

  // ... trackMouse and render functions
}

// ... propTypes definition and export statement
```

> **提示：** 你必须使用从你的 Auth0 应用中复制的 _Domain_ 和 _Client ID_ 字段的值来替换`YOUR_AUTH0_DOMAIN` 和 `YOUR_AUTH0_CLIENT_ID`。除此之外，当你在网络上发布你的游戏的时候，你同样需要替换 `redirectUri` 的值。

这个文件里的增强的点十分简单。这个列表总结了他们：

1.  `configure`：你使用这个函数，协同你的 Auth0 应用的属性，来配置 `auth0-web` 包。
2.  `handleAuthCallback`：你在 [`componentDidMount` 生命周期的钩子函数](https://reactjs.org/docs/react-component.html#componentdidmount) 触发这个方法，来检测用户是否是经过 Auth0 认证的。这个方法只是尝试从 URL 抓取 tokens，并且如果成功，抓取用户的文档并把所有的信息存储到 `localstorage`。
3.  `subscribe`：你使用这个方法来记录玩家是否是经过认证的（`true` 代表认证过，否则 `false`）。

就是这样，你的游戏已经 [使用 Auth0 作为它的身份管理服务](https://auth0.com/learn/cloud-identity-access-management/)。如果你现在启动你的应用（`npm start`）并且在你的浏览器中浏览 ([`http://localhost:3000`](http://localhost:3000))，你讲看到登陆按钮。点击它，它会把你重定向到 [Auth0 登陆页面](https://auth0.com/docs/hosted-pages/login)，在这里你可以登陆。

当你完成了流程中的注册，Auth0 会再一次把你重定向到你的游戏，`handleAuthCallback` 方法将会抓去你的 tokens。然后，正如你已经告诉你的应用 `console.log` 所有的认证状态的变化，你将能够看到它在你的浏览器控制台打印了 `true`。

![在你的 React 和 Redux 游戏中展示登陆按钮](https://cdn.auth0.com/blog/aliens-go-home/showing-the-login-button-in-your-react-game.png)

> “使用 Auth0 来保护你的游戏是简单和痛苦小的。”

## 创建 Leaderboard React 组件

现在你已经配置了 Auth0 作为你的身份管理系统，你将需要创建展示排行榜和当前玩家最大分数的组件。为此，你将创建两个组件：`Leaderboard` 和 `Rank`。你将需要将这个特性拆分成两个组件，因为正如你所看到的，友好的展示玩家的数据（比如最大分数，姓名，位置和图片）并不是简单的事。其实也并不困难，但是你需要编写一些好的代码。所以，把所有的东西加到一个组件之中会看起来很笨拙。

正如你的游戏还没有任何玩家，第一件事你需要做的就是定义一些 mock 数据来填充排行榜。做这件事最好的地方就是在 `Canvas` 组件中。同样，因为你正要去更新你的 canvas，你能够继续深入，使用 `Leaderboard` 替换 `Login` 组件（你一会儿将在 `Leaderboard` 中加入 `Login`）：

```
// ... other import statements
// replace Login with the following line
import Leaderboard from './Leaderboard';

const Canvas = (props) => {
  // ... const definitions
  const leaderboard = [
    { id: 'd4', maxScore: 82, name: 'Ado Kukic', picture: 'https://twitter.com/KukicAdo/profile_image', },
    { id: 'a1', maxScore: 235, name: 'Bruno Krebs', picture: 'https://twitter.com/brunoskrebs/profile_image', },
    { id: 'c3', maxScore: 99, name: 'Diego Poza', picture: 'https://twitter.com/diegopoza/profile_image', },
    { id: 'b2', maxScore: 129, name: 'Jeana Tahnk', picture: 'https://twitter.com/jeanatahnk/profile_image', },
    { id: 'e5', maxScore: 34, name: 'Jenny Obrien', picture: 'https://twitter.com/jenny_obrien/profile_image', },
    { id: 'f6', maxScore: 153, name: 'Kim Maida', picture: 'https://twitter.com/KimMaida/profile_image', },
    { id: 'g7', maxScore: 55, name: 'Luke Oliff', picture: 'https://twitter.com/mroliff/profile_image', },
    { id: 'h8', maxScore: 146, name: 'Sebastián Peyrott', picture: 'https://twitter.com/speyrott/profile_image', },
  ];
  return (
    <svg ...>
      // ... other elements

      { ! props.gameState.started &&
      <g>
        // ... StartGame and Title
        <Leaderboard currentPlayer={leaderboard[6]} authenticate={signIn} leaderboard={leaderboard} />
      </g>
      }

      // ... flyingObjects.map
    </svg>
  );
};

// ... propTypes definition and export statement
```

在这个文件的新版本中，你定义一个存储假玩家的叫做 `leaderboard` 的数组常量。这些玩家有以下属性：`id`、`maxScore`、`name` 和 `picture`。然后，在 `svg` 元素中，你增加具有以下参数的 `Leaderboard` 组件：

*   `currentPlayer`: 这个定义了当前玩家的身份。现在，你正在使用之前定义的假玩家中的一个，所以你能够看到每一件事是怎么工作的。传递这个参数的目的是使你的排行榜高亮当前玩家。
*   `authenticate`: 这个和你加入到之前版本的 `Login` 组件中的参数是一样的。
*   `leaderboard`: 这个是家玩家的数组列表。你的排行榜将会使用这个来展示当前的排行。

现在，你必须定义 `Leaderboard` 组件。要做这个，需要在 `./src/components` 目录下创建一个名为 `Leaderboard.jsx` 的新文件，并且加入如下代码：

```
import React from 'react';
import PropTypes from 'prop-types';
import Login from './Login';
import Rank from "./Rank";

const Leaderboard = (props) => {
  const style = {
    fill: 'transparent',
    stroke: 'black',
    strokeDasharray: '15',
  };

  const leaderboardTitle = {
    fontFamily: '"Joti One", cursive',
    fontSize: 50,
    fill: '#88da85',
    cursor: 'default',
  };

  let leaderboard = props.leaderboard || [];
  leaderboard = leaderboard.sort((prev, next) => {
    if (prev.maxScore === next.maxScore) {
      return prev.name <= next.name ? 1 : -1;
    }
    return prev.maxScore < next.maxScore ? 1 : -1;
  }).map((member, index) => ({
    ...member,
    rank: index + 1,
    currentPlayer: member.id === props.currentPlayer.id,
  })).filter((member, index) => {
    if (index < 3 || member.id === props.currentPlayer.id) return member;
    return null;
  });

  return (
    <g>
      <text filter="url(#shadow)" style={leaderboardTitle} x="-150" y="-630">Leaderboard</text>
      <rect style={style} x="-350" y="-600" width="700" height="330" />
      {
        props.currentPlayer && leaderboard.map((player, idx) => {
          const position = {
            x: -100,
            y: -530 + (70 * idx)
          };
          return <Rank key={player.id} player={player} position={position}/>
        })
      }
      {
        ! props.currentPlayer && <Login authenticate={props.authenticate} />
      }
    </g>
  );
};

Leaderboard.propTypes = {
  currentPlayer: PropTypes.shape({
    id: PropTypes.string.isRequired,
    maxScore: PropTypes.number.isRequired,
    name: PropTypes.string.isRequired,
    picture: PropTypes.string.isRequired,
  }),
  authenticate: PropTypes.func.isRequired,
  leaderboard: PropTypes.arrayOf(PropTypes.shape({
    id: PropTypes.string.isRequired,
    maxScore: PropTypes.number.isRequired,
    name: PropTypes.string.isRequired,
    picture: PropTypes.string.isRequired,
    ranking: PropTypes.number,
  })),
};

Leaderboard.defaultProps = {
  currentPlayer: null,
  leaderboard: null,
};

export default Leaderboard;
```

不要害怕！这个组件的代码非常简单：

1. 你定义常量 `leaderboardTitle` 来设置你的排行榜标题是什么样的。
2. 你定义常量 `dashedRectangle` 来设置作为你的排行榜容器的 `rect` 元素的样式。
3. 你调用 `props.leaderboard` 变量的 `sort` 方法来排序。之后，你的排行榜就会使最高分在上面，最低分在下面。同样，如果有两个玩家打平手，你根据姓名将他们排序。
4. 你在上一步（`sort` 方法）的结果上调用 `map` 方法，使用他们的 `rank` 和 具有 `currentPlayer` 的标志来补充玩家信息。你将使用这个标志来高亮当前玩家出现的行。
5. 你在上一步（`map` 方法）的结果上调用 `filter` 方法来删除每一个不在前三名玩家的人。事实上，如果当前玩家不属于这个筛选组，你要使当前玩家保留在最终的数组里。
6. 最后，如果有一个用户登陆（`props.currentPlayer && leaderboard.map`）或者正在展示 `Login` 按钮，你遍历过滤过得数组来展示 `Rank` 元素。

最后一件你需要做的事就是创建 `Rank` React 组件。要完成这个，创建一个名为 `Rank.jsx` 新文件，同时包括具有以下代码的 `Leaderboard.jsx` 文件：

```
import React from 'react';
import PropTypes from 'prop-types';

const Rank = (props) => {
  const { x, y } = props.position;

  const rectId = 'rect' + props.player.rank;
  const clipId = 'clip' + props.player.rank;

  const pictureStyle = {
    height: 60,
    width: 60,
  };

  const textStyle = {
    fontFamily: '"Joti One", cursive',
    fontSize: 35,
    fill: '#e3e3e3',
    cursor: 'default',
  };

  if (props.player.currentPlayer) textStyle.fill = '#e9ea64';

  const pictureProperties = {
    style: pictureStyle,
    x: x - 140,
    y: y - 40,
    href: props.player.picture,
    clipPath: `url(#${clipId})`,
  };

  const frameProperties = {
    width: 55,
    height: 55,
    rx: 30,
    x: pictureProperties.x,
    y: pictureProperties.y,
  };

  return (
    <g>
      <defs>
        <rect id={rectId} {...frameProperties} />
        <clipPath id={clipId}>
          <use xlinkHref={'#' + rectId} />
        </clipPath>
      </defs>
      <use xlinkHref={'#' + rectId} strokeWidth="2" stroke="black" />
      <text filter="url(#shadow)" style={textStyle} x={x - 200} y={y}>{props.player.rank}º</text>
      <image {...pictureProperties} />
      <text filter="url(#shadow)" style={textStyle} x={x - 60} y={y}>{props.player.name}</text>
      <text filter="url(#shadow)" style={textStyle} x={x + 350} y={y}>{props.player.maxScore}</text>
    </g>
  );
};

Rank.propTypes = {
  player: PropTypes.shape({
    id: PropTypes.string.isRequired,
    maxScore: PropTypes.number.isRequired,
    name: PropTypes.string.isRequired,
    picture: PropTypes.string.isRequired,
    rank: PropTypes.number.isRequired,
    currentPlayer: PropTypes.bool.isRequired,
  }).isRequired,
  position: PropTypes.shape({
    x: PropTypes.number.isRequired,
    y: PropTypes.number.isRequired
  }).isRequired,
};

export default Rank;
```

这个代码同样没有什么可怕的。唯一不平常的事就是你加入到这个组件的是 [`clipPath` 元素](https://developer.mozilla.org/en-US/docs/Web/SVG/Element/clipPath) 和一个在 `defs` 元素中的 `rect` 元素来创建一个圆的肖像。

有了这些新文件，你能够前往你的应用（[`http://localhost:3000/`](http://localhost:3000/)）来看看你的新排行榜特性。

![在你的 React 游戏中展示排行榜](https://cdn.auth0.com/blog/aliens-go-home/showing-the-leaderboard-in-your-react-game.png)

## 使用 Socket.IO 开发一个实时排行榜

帅气，你已经使用 Auth0 作为你的身份管理服务，并且你也创建了需要展示排行榜的组件。之后，你需要做什么？对了，你需要一个能出发实时事件的后端来更新排行榜。

这可能使你想到：开发一个实时后端服务器困难么？不，不困难。使用 [Socket.IO](https://socket.io/)，你可以在很短的时间实现这个特性。不管怎样，在深入之前，你可能想要好糊这个后端服务，对不对？要做这个，你需要创建一个 [Auth0 API](https://auth0.com/docs/apis) 来代表你的服务。

这样做很简单。前往 [你的 Auth0 仪表盘的 APIs 页面](https://manage.auth0.com/#/apis) 并且点击  _Create API_ 按钮，Auth0 会想你展示一个有三个信息需要填的表单：

1. API的 _Name_ ：这里，你仅仅需要声明一个友好的名字使你不至于忘掉这个 API 代表的什么。所以，在这个区域输入 _Aliens, Go Home!_ 就好啦。
2. API的 _Identifier_ ：这里建议的值是你游戏的最终 URL，但是事实上这可以是任何东西，虽然这样，在这里输入 `https://aliens-go-home.digituz.com.br`。
3. _Signing Algorithm_ ：这里有两个选项， _RS256_ 和 _HS256_ 。你最好不要修改这个字段（例如，保持 _RS256_）。你过你想要学习他们之间的不同，查看 [这个答案](https://community.auth0.com/answers/6945/view)。

![为 Socket.IO 实时服务创建 Auth0 API](https://cdn.auth0.com/blog/aliens-go-home/creating-the-auth0-api-for-the-socket-io-server.png)

在你填完这个表单后，点击  _Create_ 按钮。会将你重定向到你的新 API 中叫做  _Quick Start_ 的标签页。在那里，点击 _Scopes_ 标签并且添加叫做 `manage:points` 的新作用域，他有以下的描述：“读和写最大的分数”。[在 Auth0 APIs 上定义作用域是很好的实践](https://auth0.com/docs/scopes/current#api-scopes)


添加完这个作用域之后，你能够继续编程。来完成你的实时排行榜服务，按照下面的做：

```
# 在项目根目录创建一个服务目录
mkdir server

# 进入服务目录
cd server

# 作为一个 NPM 项目启动它
npm init -y

# 安装一些依赖
npm i express jsonwebtoken jwks-rsa socket.io socketio-jwt

# 创建一个保存服务器源代码的文件
touch index.js
```

然后，在这个新文件中，添加以下代码：

```
const app = require('express')();
const http = require('http').Server(app);
const io = require('socket.io')(http);
const jwt = require('jsonwebtoken');
const jwksClient = require('jwks-rsa');

const client = jwksClient({
  jwksUri: 'https://YOUR_AUTH0_DOMAIN/.well-known/jwks.json'
});

const players = [
  { id: 'a1', maxScore: 235, name: 'Bruno Krebs', picture: 'https://twitter.com/brunoskrebs/profile_image', },
  { id: 'c3', maxScore: 99, name: 'Diego Poza', picture: 'https://twitter.com/diegopoza/profile_image', },
  { id: 'b2', maxScore: 129, name: 'Jeana Tahnk', picture: 'https://twitter.com/jeanatahnk/profile_image', },
  { id: 'f6', maxScore: 153, name: 'Kim Maida', picture: 'https://twitter.com/KimMaida/profile_image', },
  { id: 'e5', maxScore: 55, name: 'Luke Oliff', picture: 'https://twitter.com/mroliff/profile_image', },
  { id: 'd4', maxScore: 146, name: 'Sebastián Peyrott', picture: 'https://twitter.com/speyrott/profile_image', },
];

const verifyPlayer = (token, cb) => {
  const uncheckedToken = jwt.decode(token, {complete: true});
  const kid = uncheckedToken.header.kid;

  client.getSigningKey(kid, (err, key) => {
    const signingKey = key.publicKey || key.rsaPublicKey;

    jwt.verify(token, signingKey, cb);
  });
};

const newMaxScoreHandler = (payload) => {
  let foundPlayer = false;
  players.forEach((player) => {
    if (player.id === payload.id) {
      foundPlayer = true;
      player.maxScore = Math.max(player.maxScore, payload.maxScore);
    }
  });

  if (!foundPlayer) {
    players.push(payload);
  }

  io.emit('players', players);
};

io.on('connection', (socket) => {
  const { token } = socket.handshake.query;

  verifyPlayer(token, (err) => {
    if (err) socket.disconnect();
    io.emit('players', players);
  });

  socket.on('new-max-score', newMaxScoreHandler);
});

http.listen(3001, () => {
  console.log('listening on port 3001');
});
```

在学习这部分代码做什么之前，使用你的 Auth0 域（和你添加到 `App.js` 文件是一样那个）替换 `YOUR_AUTH0_DOMAIN`。你可以在 `jwksUri` 属性值中找到这个占位符。

现在，为了理解这个事情是怎么工作的，查看这个列表：

*   `express` 和 `socket.io`：这只是一个通过 Socket.IO 加强的 [Express](https://expressjs.com/) 服务器来使它具备实时的特性。如果你以前没有用过 Socket.IO，查看他们的 _Get Started_ 教程。它真的很简单。
*   `jwt` 和 `jwksClient`：当 Auth0 认证的时候，你的玩家（在其他事情之外）会在 JWT (JSON Web Token) 表单中得到一个 `access_token`。因为你使用 _RS256_ 签名算法，你需要使用 `jwksClient` 包来获取正确的公钥来认证 JWTs。你收到的 JWTs 中包含一个  `kid` 属性（Key ID），你可以使用这个属性得到正确的公钥（如果你感到困惑，[你可以在这儿了解更多地 JWKS](https://auth0.com/docs/jwks)）。
*   `jwt.verify`：在找到正确的钥匙之后，你可以使用这个方法来解码和认证 JWTs。如果他们都很好，你就给请求的人发送 `players` 列表。如果他们没有经过认证，你 `disconnect` 这个 `socket`（用户）。
*   `on('new-max-score', ...)`：最后，你在 `new-max-score` 事件上附加 `newMaxScoreHandler` 方法。因此，无论什么时候你需要更新一个用户的最高分，你会需要在你的 React 应用中触发这个事件。

剩余的代码非常直观。因此，你能关注在你的游戏中集成这个服务。

## Socket.IO 和 React

在创建你的实时后端服务之后，是时候将它集成到你的 React 游戏中了。使用 React 和 Socket.IO 最好的方式是安装 [`socket.io-client` 包](https://github.com/socketio/socket.io-client)。你可以在你的 React 应用根目录下输入以下命令来安装它：

```
npm i socket.io-client
```

然后，在那之后，无论什么时候玩家认证，你将使你的游戏连接你的服务（你不需要给没有认证的玩家显示排行榜）。因为你使用 Redux 来保存游戏的状态，你需要两个 actions 来保持你的 Redux 存储最新。因此，打开 `./src/actions/index.js` 文件并且按照下面来更新它：

```
export const LEADERBOARD_LOADED = 'LEADERBOARD_LOADED';
export const LOGGED_IN = 'LOGGED_IN';
// ... MOVE_OBJECTS and START_GAME ...

export const leaderboardLoaded = players => ({
  type: LEADERBOARD_LOADED,
  players,
});

export const loggedIn = player => ({
  type: LOGGED_IN,
  player,
});

// ... moveObjects and startGame ...
```

这个新版本定义在两种情况下会被触发的 actions：

1. `LOGGED_IN`：当一个玩家登陆，你使用这个 action 连接你的 React 游戏到实时服务。
2. `LEADERBOARD_LOADED`：当实时服务发送玩家列表，你使用这个 action 用这些玩家来更新 Redux 存储。

要使你的 Redux 存储回应这些 actions，打开 `./src/reducers/index.js` 文件并且按照下面来更新它：

```
import {
  LEADERBOARD_LOADED, LOGGED_IN,
  MOVE_OBJECTS, START_GAME
} from '../actions';
// ... other import statements

const initialGameState = {
  // ... other game state properties
  currentPlayer: null,
  players: null,
};

// ... initialState definition

function reducer(state = initialState, action) {
  switch (action.type) {
    case LEADERBOARD_LOADED:
      return {
        ...state,
        players: action.players,
      };
    case LOGGED_IN:
      return {
        ...state,
        currentPlayer: action.player,
      };
    // ... MOVE_OBJECTS, START_GAME, and default cases
  }
}

export default reducer;
```

现在，无论你的游戏什么时候触发  `LEADERBOARD_LOADED` action，你会使用新的玩家数组列表来更新你的 Redux 存储。除此之外，无论什么时候一个玩家登陆（`LOGGED_IN`），你将在你的存储中更新 `currentPlayer` 。

然后，为了是你的游戏使用这些新的 actions， 打开 `./src/containers/Game.js` 文件并且按照下面来更新它：

```
// ... other import statements
import {
  leaderboardLoaded, loggedIn,
  moveObjects, startGame
} from '../actions/index';

const mapStateToProps = state => ({
  // ... angle and gameState
  currentPlayer: state.currentPlayer,
  players: state.players,
});

const mapDispatchToProps = dispatch => ({
  leaderboardLoaded: (players) => {
    dispatch(leaderboardLoaded(players));
  },
  loggedIn: (player) => {
    dispatch(loggedIn(player));
  },
  // ... moveObjects and startGame
});

// ... connect and export statement
```

有了它，你准备好了使你的游戏接入实时服务来加载和更新排行榜。因此，打开 `./src/App.js` 文件并且按照下面来更新它：

```
// ... other import statements
import io from 'socket.io-client';

Auth0.configure({ 
  // ... other properties
  audience: 'https://aliens-go-home.digituz.com.br',
});

class App extends Component {
  // ... constructor

  componentDidMount() {
    const self = this;

    Auth0.handleAuthCallback();

    Auth0.subscribe((auth) => {
      if (!auth) return;

      const playerProfile = Auth0.getProfile();
      const currentPlayer = {
        id: playerProfile.sub,
        maxScore: 0,
        name: playerProfile.name,
        picture: playerProfile.picture,
      };

      this.props.loggedIn(currentPlayer);

      const socket = io('http://localhost:3001', {
        query: `token=${Auth0.getAccessToken()}`,
      });

      let emitted = false;
      socket.on('players', (players) => {
        this.props.leaderboardLoaded(players);

        if (emitted) return;
        socket.emit('new-max-score', {
          id: playerProfile.sub,
          maxScore: 120,
          name: playerProfile.name,
          picture: playerProfile.picture,
        });
        emitted = true;
        setTimeout(() => {
          socket.emit('new-max-score', {
            id: playerProfile.sub,
            maxScore: 222,
            name: playerProfile.name,
            picture: playerProfile.picture,
          });
        }, 5000);
      });
    });

    // ... setInterval and onresize
  }

  // ... trackMouse

  render() {
    return (
      <Canvas
        angle={this.props.angle}
        currentPlayer={this.props.currentPlayer}
        gameState={this.props.gameState}
        players={this.props.players}
        startGame={this.props.startGame}
        trackMouse={event => (this.trackMouse(event))}
      />
    );
  }
}

App.propTypes = {
  // ... other propTypes definitions
  currentPlayer: PropTypes.shape({
    id: PropTypes.string.isRequired,
    maxScore: PropTypes.number.isRequired,
    name: PropTypes.string.isRequired,
    picture: PropTypes.string.isRequired,
  }),
  leaderboardLoaded: PropTypes.func.isRequired,
  loggedIn: PropTypes.func.isRequired,
  players: PropTypes.arrayOf(PropTypes.shape({
    id: PropTypes.string.isRequired,
    maxScore: PropTypes.number.isRequired,
    name: PropTypes.string.isRequired,
    picture: PropTypes.string.isRequired,
  })),
};

App.defaultProps = {
  currentPlayer: null,
  players: null,
};

export default App;
```

正如你在上面看到的代码，你做了这些：

1. 配置了 `Auth0` 模块上的 `audience` 属性；
2. 抓去了当前玩家的个人数据（`Auth0.getProfile()`）来创建 `currentPlayer` 常量，并且更新了 Redux 存储（`this.props.loggedIn(...)`）；
3. 用玩家的 `access_token` 连接你的实时服务（`io('http://localhost:3001', ...)`）；
4. 监听实时服务触发的玩家事件，更新 Redux 存储（`this.props.leaderboardLoaded(...)`）；

然后，你的游戏还没有完成，你的玩家还不能杀死外星人，你加入一些临时代码模拟 `new-max-score` 事件。第一，你出发一个新的 `120` 分的 `maxScore`，把登陆的玩家放在第五的位置。然后，五秒钟（`setTimeout(..., 5000)`）之后，你出发一个新的 `222` 分的 `maxScore`，把登陆的玩家放在第二的位置。

除了这些变化，你向你的 `Canvas` 传入两个新的属性： `currentPlayer` 和 `players`。因此，你需要打开 `./src/components/Canvas.jsx` 并且更新它：

```
// ... import statements

const Canvas = (props) => {
  // ... gameHeight and viewBox constants

  // REMOVE the leaderboard constant !!!!

  return (
    <svg ...>
      // ... other elements

      { ! props.gameState.started &&
      <g>
        // ... StartGame and Title
        <Leaderboard currentPlayer={props.currentPlayer} authenticate={signIn} leaderboard={props.players} />
      </g>
      }

      // ... flyingObjects.map
    </svg>
  );
};

Canvas.propTypes = {
  // ... other propTypes definitions
  currentPlayer: PropTypes.shape({
    id: PropTypes.string.isRequired,
    maxScore: PropTypes.number.isRequired,
    name: PropTypes.string.isRequired,
    picture: PropTypes.string.isRequired,
  }),
  players: PropTypes.arrayOf(PropTypes.shape({
    id: PropTypes.string.isRequired,
    maxScore: PropTypes.number.isRequired,
    name: PropTypes.string.isRequired,
    picture: PropTypes.string.isRequired,
  })),
};

Canvas.defaultProps = {
  currentPlayer: null,
  players: null,
};

export default Canvas;
```

在这个文件里，你需要做以下的变更：

1. 删除常量 `leaderboard`。现在，你通过你的实时服务加载这个常量。
2. 更新 `<Leaderboard />` 元素。你现在已经有了更多地真是数据了：`props.currentPlayer` and `props.players`。
3. 加强 `propTypes` 的定义使  `Canvas` 组件能够使用 `currentPlayer` 和 `players` 的值。

好了！你已经整合了你的 React 游戏排行榜和 Socket.IO 实时服务。要测试所有的事务，执行以下的命令：

```
# 进入实时服务的目录
cd server

# 在后台运行这个命令
node index.js &

# 回到你的游戏
cd ..

# 启动 React 开发服务
npm start
```

然后，在浏览器中打开你的游戏（[`http://localhost:3000`](http://localhost:3000)）。这样，在登陆之后，你就能看到你出现在了第五的位置，5秒钟之后，你就会跳到第二的位置。

![测试你的 React 游戏的 Socket.IO 实时排行榜](https://cdn.auth0.com/blog/aliens-go-home/real-time-leaderboard.png)

## 实现剩余的部分

现在，你已经差不多完成了你的游戏的所有东西。你已经创建了游戏需要的 React 元素，你已经添加了绝大部分的动画效果，你已经实现了排行榜特性。这个难题的遗失的部分是：

*   _Shooting Cannon Balls_ ：为了杀外星人，你必须允许你的玩家射击大炮炮弹。
*   _Detecting Collisions_ ：正像你的游戏会有大炮炮弹，飞行的物体到到处动，你必须实现一个检测这些物体碰撞的算法。
*   _Updating Lives and the Current Score_ ：在实现你的玩家杀死飞行物体之后，你的游戏必须增加他们当前的分数，以至于他们能够达到新的最大分数。同样的，你需要在飞行物体入侵地球之后减掉生命。
*   _Updating the Leaderboard_ ：当实现了上面的所有特性，最后一件你需要做的事是用新的最高分数更新排行榜。

所以，在接下来的部分，你将关注实现这些部分来完成你的游戏。

### 发射大炮炮弹

要使你的玩家射击大炮炮弹，你将在你的 `Canvas` 添加一个 `onClick` 时间侦听器。然后，当点击的时候，你的 canvas 会触发 Redux 的  action 添加一个炮弹到 Redux store（实际上就是你的游戏的 state）。炮弹的移动将被 `moveObjects` reducer 处理。

要开始实现这个特性，你可以从创建 Redux action 开始。要做这个，打开 `./src/actions/index.js` 文件，加入以下代码：

```
// ... other string constants

export const SHOOT = 'SHOOT';

// ... other function constants

export const shoot = (mousePosition) => ({
  type: SHOOT,
  mousePosition,
});
```

然后，你能够准备 reducer（`./src/reducers/index.js`）来处理这个 action：

```
import {
  LEADERBOARD_LOADED, LOGGED_IN,
  MOVE_OBJECTS, SHOOT, START_GAME
} from '../actions';
// ... other import statements
import shoot from './shoot';

const initialGameState = {
  // ... other properties
  cannonBalls: [],
};

// ... initialState definition

function reducer(state = initialState, action) {
  switch (action.type) {
    // other case statements
    case SHOOT:
      return shoot(state, action);
    // ... default statement
  }
}
```

正如你看到的，你的 reducer 的新版本在接收到 `SHOOT` action 时，使用 `shoot` 方法。你仍然需要定义这个方法。所以，在和 reducer 同样的目录下创建一个名为 `shoot.js` 的文件，并加入以下代码：

```
import { calculateAngle } from '../utils/formulas';

function shoot(state, action) {
  if (!state.gameState.started) return state;

  const { cannonBalls } = state.gameState;

  if (cannonBalls.length === 2) return state;

  const { x, y } = action.mousePosition;

  const angle = calculateAngle(0, 0, x, y);

  const id = (new Date()).getTime();
  const cannonBall = {
    position: { x: 0, y: 0 },
    angle,
    id,
  };

  return {
    ...state,
    gameState: {
      ...state.gameState,
      cannonBalls: [...cannonBalls, cannonBall],
    }
  };
}

export default shoot;
```

这个方法从检查这个游戏是否启动为开始。如果没有启动，它只是返回当前的状态。否则，它会检查游戏中是否已经有两个炮弹。你通过限制炮弹的数量来使游戏变得更困难一点。如果玩家发射了少于两发的炮弹，这个函数使用 `calculateAngle` 定义新炮弹的弹道。然后，最后，这个函数创建了一个新的代表炮弹的对象并且返回了一个新的 Redux store 的 state。

在定义这个 action 和 reducer 处理它之后，你将更新 `Game` 容器给 `App` 组件提供 action。所以，打开 `./src/containers/Game.js` 文件并且按照下面的来更新它：

```
// ... other import statements
import {
  leaderboardLoaded, loggedIn,
  moveObjects, startGame, shoot
} from '../actions/index';

// ... mapStateToProps

const mapDispatchToProps = dispatch => ({
  // ... other functions
  shoot: (mousePosition) => {
    dispatch(shoot(mousePosition))
  },
});

// ... connect and export
```

现在，你需要更新 `./src/App.js` 文件来使用你的 dispatch wrapper：

```
// ... import statements and Auth0.configure

class App extends Component {
  constructor(props) {
    super(props);
    this.shoot = this.shoot.bind(this);
  }

  // ... componentDidMount and trackMouse definition

  shoot() {
    this.props.shoot(this.canvasMousePosition);
  }

  render() {
    return (
      <Canvas
        // other props
        shoot={this.shoot}
      />
    );
  }
}

App.propTypes = {
  // ... other propTypes
  shoot: PropTypes.func.isRequired,
};

// ... defaultProps and export statements
```

正如你在这里看到的，你在 `App` 的类中定义一个新的方法使用 `canvasMousePosition` 来调用 `shoot` dispatcher。然后，你传递把这个新的方法传递到 `Canvas` 组件。所以，你仍然需要加强这个组件，将这个方法附加到 `svg` 元素的 `onClick` 事件监听器并且使它渲染加农炮弹：

```
// ... other import statements
import CannonBall from './CannonBall';

const Canvas = (props) => {
  // ... gameHeight and viewBox constant

  return (
    <svg
      // ... other properties
      onClick={props.shoot}
    >
      // ... defs, Sky and Ground elements

      {props.gameState.cannonBalls.map(cannonBall => (
        <CannonBall
          key={cannonBall.id}
          position={cannonBall.position}
        />
      ))}

      // ... CannonPipe, CannonBase, CurrentScore, etc
    </svg>
  );
};

Canvas.propTypes = {
  // ... other props
  shoot: PropTypes.func.isRequired,
};

// ... defaultProps and export statement
```


> **提示：** 在 `CannonPipe` _之前_ 添加 `cannonBalls.map` 很重要，否则炮弹将和大炮自身重叠。

这些改变足够是你的游戏在炮弹的初始位置添加炮弹了（`x: 0`, `y: 0`）并且 他们的弹道（`angle`）已经定义好。现在的问题是这些对象是没有动画的（其实就是他们不会动）。

要使他们动，你将需要在 `./src/utils/formulas.js` 文件中添加两个函数：

```
// ... other functions

const degreesToRadian = degrees => ((degrees * Math.PI) / 180);

export const calculateNextPosition = (x, y, angle, divisor = 300) => {
  const realAngle = (angle * -1) + 90;
  const stepsX = radiansToDegrees(Math.cos(degreesToRadian(realAngle))) / divisor;
  const stepsY = radiansToDegrees(Math.sin(degreesToRadian(realAngle))) / divisor;
  return {
    x: x +stepsX,
    y: y - stepsY,
  }
};
```

> **提示：** 要学习上面工作的的公式，[看这里](https://answers.unity.com/questions/491719/how-to-calculate-a-new-position-having-angle-and-d.html)

你将在新的名为 `moveCannonBalls.js` 的文件中使用 `calculateNextPosition` 方法。所以，在 `./src/reducers/` 目录中创建这个文件，并加入以下代码：

```
import { calculateNextPosition } from '../utils/formulas';

const moveBalls = cannonBalls => (
  cannonBalls
    .filter(cannonBall => (
      cannonBall.position.y > -800 && cannonBall.position.x > -500 && cannonBall.position.x < 500
    ))
    .map((cannonBall) => {
      const { x, y } = cannonBall.position;
      const { angle } = cannonBall;
      return {
        ...cannonBall,
        position: calculateNextPosition(x, y, angle, 5),
      };
    })
);

export default moveBalls;
```

在这个文件暴露的方法中，你做了两件重要的事情。第一，你使用 `filter` 方法去除了没有再特定区域中的 `cannonBalls`。这就是，你删除了 Y-axis 坐标小于 `-800`，或者向左边移动太多的（小于 `-500`），或者向右边移动太多的（大于 `500`）。

最后，要使用这个方法，你将需要将 `./src/reducers/moveObjects.js` 按照下面来重构：

```
// ... other import statements
import moveBalls from './moveCannonBalls';

function moveObjects(state, action) {
  if (!state.gameState.started) return state;

  let cannonBalls = moveBalls(state.gameState.cannonBalls);

  // ... mousePosition, createFlyingObjects, filter, etc

  return {
    ...newState,
    gameState: {
      ...newState.gameState,
      flyingObjects,
      cannonBalls,
    },
    angle,
  };
}

export default moveObjects;
```

在这个文件的新版本中，你简单的加强了之前的 `moveObjects` reducer 来使用新的 `moveBalls` 函数。然后，你使用这个函数的结果来给 `gameState` 的 `cannonBalls` 属性定义一个新数组。

现在，完成了这些更改之后，你的玩家能够发射炮弹了。你可以在一个浏览器中通过测试你的游戏来查看这一点。

![在一个使用 React，Redux 和 SVGs 的游戏中使玩家能够发射炮弹](https://cdn.auth0.com/blog/aliens-go-home/shooting-cannon-balls.png)

### 检测碰撞

现在你的游戏支持发射炮弹并且这里有飞行的物体入侵地球，这是一个好的时机添加一个检测碰撞的算法。有了这个算法，你可以删除相碰撞的炮弹和飞行物体。这也使你能够继续接下来的特性：**增加当前的分数。**

一个好的实现这个检测碰撞算法的策略是把炮弹和飞行物体想象成为矩形。尽管这个策略不如按照物体真实形状实现的算法准确，但是把它们作为矩形处理会使每件事情变得简单。除此之外，对于这个游戏，你不需要很精确，因为，幸运的是，你不需要这个算法杀死真的外星人。


在脑袋中有这个想法之后，添加接下来的方法到 `./src/utils/formulas.js` 文件中：

```
// ... other functions

export const checkCollision = (rectA, rectB) => (
  rectA.x1 < rectB.x2 && rectA.x2 > rectB.x1 &&
  rectA.y1 < rectB.y2 && rectA.y2 > rectB.y1
);
```

正像你看到的，把这些对象按照矩形来看待，使你在这些简单的情况下检测是否重叠。现在，为了使用这个函数，在 `./src/reducers` 目录下，创建一个名为 `checkCollisions.js` 的新文件，添加以下的代码：

```
import { checkCollision } from '../utils/formulas';
import { gameHeight } from '../utils/constants';

const checkCollisions = (cannonBalls, flyingDiscs) => {
  const objectsDestroyed = [];
  flyingDiscs.forEach((flyingDisc) => {
    const currentLifeTime = (new Date()).getTime() - flyingDisc.createdAt;
    const calculatedPosition = {
      x: flyingDisc.position.x,
      y: flyingDisc.position.y + ((currentLifeTime / 4000) * gameHeight),
    };
    const rectA = {
      x1: calculatedPosition.x - 40,
      y1: calculatedPosition.y - 10,
      x2: calculatedPosition.x + 40,
      y2: calculatedPosition.y + 10,
    };
    cannonBalls.forEach((cannonBall) => {
      const rectB = {
        x1: cannonBall.position.x - 8,
        y1: cannonBall.position.y - 8,
        x2: cannonBall.position.x + 8,
        y2: cannonBall.position.y + 8,
      };
      if (checkCollision(rectA, rectB)) {
        objectsDestroyed.push({
          cannonBallId: cannonBall.id,
          flyingDiscId: flyingDisc.id,
        });
      }
    });
  });
  return objectsDestroyed;
};

export default checkCollisions;
```

文件中的这些代码基本上做了下面几件事：

1. 定义了一个名为 `objectsDestroyed` 的数组来存储所有毁掉的东西。
2. 通过迭代 `flyingDiscs` 数组（使用 `forEach` 方法）创建矩形来代表飞行物。**提示**，因为你使用 CSS 动画来使物体移动，你需要基于 `currentLifeTime` 的 Y-axis 计算他们位置。
3. 通过迭代 `cannonBalls` 数组（使用 `forEach` 方法）创建矩形来代表炮弹。
4. 调用 `checkCollision` 方法，来决定这两个矩形是否必须被摧毁。然后，如果他们必须被摧毁，他们被添加到 `objectsDestroyed` 数组，由这个方法返回。

最后，你需要更新 `moveObjects.js` 文件，参照下面来使用这个方法：

```
// ... import statements

import checkCollisions from './checkCollisions';

function moveObjects(state, action) {
  // ... other statements and definitions

  // the only change in the following three lines is that it cannot
  // be a const anymore, it must be defined with let
  let flyingObjects = newState.gameState.flyingObjects.filter(object => (
    (now - object.createdAt) < 4000
  ));

  // ... { x, y } constants and angle constant

  const objectsDestroyed = checkCollisions(cannonBalls, flyingObjects);
  const cannonBallsDestroyed = objectsDestroyed.map(object => (object.cannonBallId));
  const flyingDiscsDestroyed = objectsDestroyed.map(object => (object.flyingDiscId));

  cannonBalls = cannonBalls.filter(cannonBall => (cannonBallsDestroyed.indexOf(cannonBall.id)));
  flyingObjects = flyingObjects.filter(flyingDisc => (flyingDiscsDestroyed.indexOf(flyingDisc.id)));

  return {
    ...newState,
    gameState: {
      ...newState.gameState,
      flyingObjects,
      cannonBalls,
    },
    angle,
  };
}

export default moveObjects;
```

这里，你使用 `checkCollisions` 函数的结果从 `cannonBalls` 和 `flyingObjects` 数组中移除对象。


现在，当炮弹和飞行物体重叠，新版本的 `moveObjects` reducer 把它们从 `gameState` 删除。你可以在浏览器中看到这个 action。

### 更新生命数和当前分数

无论什么时候飞行的物体入侵地球，你必须减少玩家持有的命的数量。所以，当玩家没有更多地生命值的时候，你必须结束游戏。要实现这些特性，你只需要更新两个文件。第一个文件是 `./src/reducers/moveObject.js`。你需要按照下面来更新它：

```
import { calculateAngle } from '../utils/formulas';
import createFlyingObjects from './createFlyingObjects';
import moveBalls from './moveCannonBalls';
import checkCollisions from './checkCollisions';

function moveObjects(state, action) {
  // ... code until newState.gameState.flyingObjects.filter

  const lostLife = state.gameState.flyingObjects.length > flyingObjects.length;
  let lives = state.gameState.lives;
  if (lostLife) {
    lives--;
  }

  const started = lives > 0;
  if (!started) {
    flyingObjects = [];
    cannonBalls = [];
    lives = 3;
  }

  // ... x, y, angle, objectsDestroyed, etc ...

  return {
    ...newState,
    gameState: {
      ...newState.gameState,
      flyingObjects,
      cannonBalls: [...cannonBalls],
      lives,
      started,
    },
    angle,
  };
}

export default moveObjects;
```

这些行新代码只是简单的比较了 `flyingObjects` 数组和其在 `state` 中的初始长度来决定玩家是否失去生命。这个策略有效是因为你把这些代码添加在了弹出飞行物体之后并且在删除碰撞物体之前。这些飞行物体在游戏中保持 4 秒钟（`(now - object.createdAt) < 4000`）。所以，如果这些数组的长度发生了变化，就意味着飞行物体入侵了地球。

现在，给玩家展示他们的生命数，你需要更新 `Canvas` 组件。所以，打开 `./src/components/Canvas.jsx` 文件并且按照下面来更新：

```
// ... other import statements
import Heart from './Heart';

const Canvas = (props) => {
  // ... gameHeight and viewBox constants

  const lives = [];
  for (let i = 0; i < props.gameState.lives; i++) {
    const heartPosition = {
      x: -180 - (i * 70),
      y: 35
    };
    lives.push(<Heart key={i} position={heartPosition}/>);
  }

  return (
    <svg ...>
      // ... all other elements

      {lives}
    </svg>
  );
};

// ... propTypes, defaultProps, and export statements
```

有了这些更改，你的游戏几乎完成了。玩家已经能够发射和杀死飞行物体，并且如果太多的它们进攻地球，游戏结束。现在，为了完成这部分，你需要更新玩家当前的分数，这样他们才能比较谁杀了更多地外星人。

做这个来加强你的游戏很简单。你只需要按以下来更新 `./src/reducers/moveObjects.js` 这个文件：

```
// ... import statements

function moveObjects(state, action) {
  // ... everything else

  const kills = state.gameState.kills + flyingDiscsDestroyed.length;

  return {
    // ...newState,
    gameState: {
      // ... other props
      kills,
    },
    // ... angle,
  };
}

export default moveObjects;
```

然后，在 `./src/components.Canvas.jsx` 文件，你需要用这个来替换 `CurrentScore` 组件（硬编码值为 15）：

```
<CurrentScore score={props.gameState.kills} />
```

> “我使用 React、Redux、SVG 和 CSS 动画创建一个游戏。”

### 更新排行榜

好消息！更新排行榜是你说你使用 React、Redux、SVG 和 CSS 动画完成了一个游戏所需要做的最后一件事。同样的，正如你看到的，这里的工作很快并且没有痛苦。

第一，你需要更新 `./server/index.js` 文件来重置 `players` 数组。你不希望你发布的游戏里是假用户和假结果。所以，打开这个文件并且删除所有的假玩家/结果。最后，你会有像下面这样定义的常量：

```
const players = [];
```

然后，你需要重构 `App` 组件。所以，打开 `./src/App.js` 文件并且做下面的修改：

```
// ... import statetments

// ... Auth0.configure

class App extends Component {
  constructor(props) {
    // ... super and this.shoot.bind(this)
    this.socket = null;
    this.currentPlayer = null;
  }

  // replace the whole content of the componentDidMount method
  componentDidMount() {
    const self = this;

    Auth0.handleAuthCallback();

    Auth0.subscribe((auth) => {
      if (!auth) return;

      self.playerProfile = Auth0.getProfile();
      self.currentPlayer = {
        id: self.playerProfile.sub,
        maxScore: 0,
        name: self.playerProfile.name,
        picture: self.playerProfile.picture,
      };

      this.props.loggedIn(self.currentPlayer);

      self.socket = io('http://localhost:3001', {
        query: `token=${Auth0.getAccessToken()}`,
      });

      self.socket.on('players', (players) => {
        this.props.leaderboardLoaded(players);
        players.forEach((player) => {
          if (player.id === self.currentPlayer.id) {
            self.currentPlayer.maxScore = player.maxScore;
          }
        });
      });
    });

    setInterval(() => {
      self.props.moveObjects(self.canvasMousePosition);
    }, 10);

    window.onresize = () => {
      const cnv = document.getElementById('aliens-go-home-canvas');
      cnv.style.width = `${window.innerWidth}px`;
      cnv.style.height = `${window.innerHeight}px`;
    };
    window.onresize();
  }

  componentWillReceiveProps(nextProps) {
    if (!nextProps.gameState.started && this.props.gameState.started) {
      if (this.currentPlayer.maxScore < this.props.gameState.kills) {
        this.socket.emit('new-max-score', {
          ...this.currentPlayer,
          maxScore: this.props.gameState.kills,
        });
      }
    }
  }

  // ... trackMouse, shoot, and render method
}

// ... propTypes, defaultProps, and export statement
```

做一个总结，这些是你在这个组件中做的更改：

*   你在它的类里面定义两个新属性（`socket` 和 `currentPlayer`），这样你就能在不同的方法里使用它们。
*   你删除用来触发模拟 `new-max-score` 事件的假的最高分。
*   你通过迭代 `players` 数组（你从 Socket.IO 后台接收到的）来设置玩家正确的最高分。就这样，如果他们再一次回来啊，他们仍然会有 `maxScore` 记录
*   你定义 `componentWillReceiveProps` 生命周期来检查玩家是否打到了一个新的 `maxScore`。如果是，你的游戏触发一个 `new-max-score` 事件去更新排行榜

这就是了！你的游戏已经准备好了第一次。要看所有的行为，用下面的代码运行 Socket.IO 后台和你的 React 应用：

```
# 在后台运行后端服务
node ./server/index &

# 运行 React 应用
npm start
```

然后，运行浏览器，使用不同得 email 地址认证，并且杀一些外星人。你可以看到，当游戏结束的时候，排行榜将会在两个浏览器更新。

![Aliens, Go Home! 游戏完成。](https://cdn.auth0.com/blog/aliens-go-home/complete.png)

## 总结

在这个系列中，你使用了很多惊人的技术来创建一个好游戏。你使用了 React 来定义和控制游戏元素，你使用了 SVG（代替 HTML）来渲染这些元素，你使用了 Redux 来控制游戏的状态，并且你使用了 CSS 动画使外星人在屏幕上运动。哦，除此之外，你甚至使用了一点 Socket.IO 使你的排行榜是实时的，并使用 Auth0 作为你游戏的身份管理系统。

唉！你走了很长的路，你在这三篇文章中学了很多。可能是时候休息一下，玩会儿你的游戏了。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
