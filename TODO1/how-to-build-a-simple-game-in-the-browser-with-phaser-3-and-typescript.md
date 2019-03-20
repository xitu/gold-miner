> * 原文地址：[How to build a simple game in the browser with Phaser 3 and TypeScript](https://medium.freecodecamp.org/how-to-build-a-simple-game-in-the-browser-with-phaser-3-and-typescript-bdc94719135)
> * 原文作者：[Mariya Davydova](https://medium.com/@mariyadavydova)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-build-a-simple-game-in-the-browser-with-phaser-3-and-typescript.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-build-a-simple-game-in-the-browser-with-phaser-3-and-typescript.md)
> * 译者：
> * 校对者：

## 如何使用 Phaser 3 和 TypeScript 在浏览器中构建一个简单的游戏

![](https://cdn-images-1.medium.com/max/10944/1*m16cMnrn60vR49N8Sj1liA.jpeg)

照片由 [Phil Botha](https://unsplash.com/photos/a0TJ3hy-UD8?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) 拍摄并发布于 [Unsplash](https://unsplash.com/collections/3995048/stars/e08862541511fcb17f0de3d4a555bff8?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)

我是后端开发人员，而我的前端开发专业知识相对较弱。前一段时间我想找点乐子，在浏览器中制作游戏；我选择 Phaser 3 框架（它现在看起来非常流行）和 TypeScript 语言（因为我更喜欢静态类型语言而不是动态类型语言）。事实证明，你需要做一些无聊的事情才能使它正常工作，所以我写了这个教程来帮助像我这样的其他人更快地开始。

## 准备开发环境

### IDE

选择你的开发环境。如果你愿意，你可以随时使用普通的旧记事本，但我建议你使用更有帮助的 IDE。至于我，我更喜欢在 Emacs 中开发拿手的项目，因此我安装了 [tide](https://github.com/ananthakumaran/tide) 并按照说明进行设置。

### Node

如果我们使用 JavaScript 进行开发，那么无需这些准备步骤就可以开始编码。但是，由于我们想要使用 TypeScript，我们必须设置基础架构以尽可能快地进行未来的开发。因此我们需要安装 node 和 npm 。

在我编写本教程时，我使用 [node 10.13.0](https://nodejs.org/en/) 和 [npm 6.4.1](https://www.npmjs.com/)。请注意，前端世界中的版本更新速度非常快，因此你只需使用最新的稳定版本。我强烈建议你使用 [nvm](https://github.com/creationix/nvm) 而不是手动安装 node 和 npm，这会为你节省大量的时间和精力。

## 搭建项目

### 项目结构

我们将使用 npm 来构建项目，因此要启动项目，请转到空文件夹并运行`npm init`。 npm 会问你关于项目属性的几个问题，然后创建一个`package.json` 文件。它看起来像这样：

```json
{
  "name": "Starfall",
  "version": "0.1.0",
  "description": "Starfall game (Phaser 3 + TypeScript)",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "author": "Mariya Davydova",
  "license": "MIT"
}
```

### 软件包

使用以下命令安装我们需要的软件包：

```bash
npm install -D typescript webpack webpack-cli ts-loader phaser live-server
```

`-D` 选项（完整写法 `--save-dev`）使 npm 自动将这些包添加到 `package.json` 中的 devDependencies 列表中：

```json
"devDependencies": {
   "live-server": "^1.2.1",
   "phaser": "^3.15.1",
   "ts-loader": "^5.3.0",
   "typescript": "^3.1.6",
   "webpack": "^4.26.0",
   "webpack-cli": "^3.1.2"
 }
```

### Webpack

Webpack 将运行 TypeScript 编译器，并将一堆生成的 JS 文件以及库收集到一个压缩过的 JS 中，以便我们可以将它包含在页面中。

在 `package.json` 附近添加 `webpack.config.js`：

```js
const path = require('path');

module.exports = {
  entry: './src/app.ts',
  module: {
    rules: [
      {
        test: /\.tsx?$/,
        use: 'ts-loader',
        exclude: /node_modules/
      }
    ]
  },
  resolve: {
    extensions: [ '.ts', '.tsx', '.js' ]
  },
  output: {
    filename: 'app.js',
    path: path.resolve(__dirname, 'dist')
  },
  mode: 'development'
};
```
在这里我们看到 webpack 必须从 `src/app.ts` 开始获取源代码（我们将很快添加）并收集 `dist/app.js` 文件中的所有内容。

### TypeScript

我们还需要一个用于 TypeScript 编译器的小配置（`tsconfig.json`），其中我们描述了希望将源代码编译到哪个 JS 版本，以及在哪里找到这些源代码：

```json
{
  "compilerOptions": {
    "target": "es5"
  },
  "include": [
    "src/*"
  ]
}
```

### TypeScript 定义

TypeScript 是一种静态类型语言。因此，它需要编译的类型定义（.d.ts）。在编写本教程时，Phaser 3 的定义尚未作为 npm 包提供，因此您可能需要从官方存储库中 [下载它们](https://github.com/photonstorm/phaser3-docs/blob/master/typescript/phaser.d.ts)，并将文件放在项目的 `src` 子目录中。

### Scripts

我们几乎完成了项目的设置。此时你应该创建 `package.json` 、`webpack.config.js` 和 `tsconfig.json`，并添加 `src/phaser.d.ts`。在开始编写代码之前，我们需要做的最后一件事是解释 npm 与项目有什么关系。我们更新 `package.json` 的 `scripts` 部分，如下所示：

```js
"scripts": {
  "build": "webpack",
  "start": "webpack --watch & live-server --port=8085"
}
```

执行 `npm build` 时，webpack 将根据配置构建 `app.js` 文件。当你运行 `npm start` 时，你不必费心去构建过程，只要对任何更新进行了保存操作，webpack 就会重建应用程序；而 [live-server](https://www.npmjs.com/package/live-server) 将在默认浏览器中重新加载它。该应用程序将托管在 [http://127.0.0.1:8085/](http://127.0.0.1:8085/) 。

## 入门

既然我们已经建立了基础设施（开始一个项目时我感到厌恶的环节），我们终于可以开始编码了。在这一步中，我们将做一件简单的事情：在浏览器窗口中绘制一个深蓝色矩形。使用一个大型的游戏开发框架是有点……嗯……太过分了。不过，我们还会在接下来的步骤中使用它。

让我简要解释一下 Phaser 3 的主要概念。游戏是 `Phaser.Game` 类（或其后代）的一个实例。每个游戏都包含一个或多个 `Phaser.Game` 后代的实例。每个场景包含几个对象（静态或动态对象），并代表游戏的逻辑部分。例如，我们琐碎的游戏将有三个场景：欢迎屏幕，游戏本身和分数屏幕。

让我们开始编码吧。

首先，为游戏创建一个简单的 HTML 容器。创建一个 `index.html` 文件，其中包含以下代码：

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Starfall</title>
    <script src="dist/app.js"></script>
  </head>
  <body>
    <div id="game"></div>
  </body>
</html>
```
这里只有两个基本部分：第一个是 `script` 标签，表示我们将在这里使用我们构建的文件；第二个是 `div` 标签，它将成为游戏容器。

现在创建 `src/app.ts` 文件并添加以下代码：

```typescript
import "phaser";

const config: GameConfig = {
  title: "Starfall",
  width: 800,
  height: 600,
  parent: "game"
  backgroundColor: "#18216D"
};

export class StarfallGame extends Phaser.Game {
  constructor(config: GameConfig) {
    super(config);
  }
}

window.onload = () => {
  var game = new StarfallGame(config);
};
```

这段代码一目了然。GameConfig 有很多不同的属性，你可以查看 [这里](https://photonstorm.github.io/phaser3-docs/global.html#GameConfig) .

现在你终于可以运行 `npm start` 了。如果在此步骤和之前的步骤中完成所有操作，您应该在浏览器中看到一些简单的内容：

![是的，这是一个蓝屏。](https://cdn-images-1.medium.com/max/2000/1*1ecSa8Bs5zX6TQRq60qr6w.png)

## 让星辰坠落吧

我们创建了一个基本应用程序。现在是时候添加一个会发生某些事情的场景。我们的游戏很简单：星星会掉到地上，目标就是捕捉尽可能多的星星。

为了实现这个目标，创建一个新文件 `gameScene.ts`，并添加以下代码：

```typescript
import "phaser";

export class GameScene extends Phaser.Scene {

  constructor() {
    super({
      key: "GameScene"
    });
  }

  init(params): void {
    // TODO
  }

  preload(): void {
    // TODO
  }
  
  create(): void {
    // TODO
  }

  update(time): void {
    // TODO
  }
};
```
这里的构造函数包含一个 key ，其他场景可以在其下调用此场景。

你在这里看到四种方法的插桩。让我简要解释一下它们之间的区别：

* `init([params])` 在场景开始时被调用。这个函数可以通过调用 `scene.start(key, [params])` 来接受从其他场景或游戏传递的参数。

* `preload()` 在创建场景对象之前被调用，它包含加载资源；这些资源将被缓存，因此当重新启动场景时，不会重新加载它们。

* `create()` 在加载资源时被调用，并且通常包含主要游戏对象（背景，玩家，障碍物，敌人等）的创建。

* `update([time])` 在每个 tick 中被调用并包含场景的动态部分（移动，闪烁等）的所有内容。

为了确保我们以后不会忘记这些，让我们在 `game.ts` 中快速添加以下行：

```typescript
import "phaser";
import { GameScene } from "./gameScene";

const config: GameConfig = {
  title: "Starfall",
  width: 800,
  height: 600,
  parent: "game",
  scene: [GameScene],
  physics: {
    default: "arcade",
    arcade: {
      debug: false
    }
  },
  backgroundColor: "#000033"
};
...
```

我们的游戏现在知道游戏场景。如果游戏配置包含一个场景列表，然后第一个场景开始时，游戏开始。所有其他场景都被创建，但直到明确调用才开始。

我们还在这里添加了 arcade physics（一种物理模型，[这里有一些例子](http://phaser.io/examples/v2/category/arcade-physics)），这里需要用它使我们的星星下降。

现在我们可以把内容放在我们游戏场景的骨架上。

首先，我们声明一些必要的属性和对象：

```typescript
export class GameScene extends Phaser.Scene {
  delta: number;
  lastStarTime: number;
  starsCaught: number;
  starsFallen: number;
  sand: Phaser.Physics.Arcade.StaticGroup;
  info: Phaser.GameObjects.Text;
...
```

然后，我们初始化数字：

```typescript
  init(/*params: any*/): void {
      this.delta = 1000;
      this.lastStarTime = 0;
      this.starsCaught = 0;
      this.starsFallen = 0;
  }
```

现在，我们加载几个图片：

```typescript
  preload(): void {
    this.load.setBaseURL(
        "https://raw.githubusercontent.com/mariyadavydova/" +
        "starfall-phaser3-typescript/master/");
    this.load.image("star", "assets/star.png");
    this.load.image("sand", "assets/sand.jpg");
  }
```

在这之后，我们可以准备我们的静态组件。我们将创造地球组件，星星将落在那里，文字通知我们目前的分数：

```typescript
  create(): void {
    this.sand = this.physics.add.staticGroup({
      key: 'sand',
      frameQuantity: 20
    });
    Phaser.Actions.PlaceOnLine(this.sand.getChildren(),
      new Phaser.Geom.Line(20, 580, 820, 580));
    this.sand.refresh();

    this.info = this.add.text(10, 10, '',
      { font: '24px Arial Bold', fill: '#FBFBAC' });
  }
```

Phaser 3 中的一个组是一种创建一组您想要一起控制的对象的方法。有两种类型的对象：静态和动态。正如你可能猜到的那样，静态物体（地面，墙壁，各种障碍物）不会移动，动态物体（马里奥，舰船，导弹）可以移动。

我们创建了一个静态的地面组。那些碎片沿着线放置。请注意，该线分为 20 个相等的部分（不是您可能预期的 19 个），并且地砖位于左端的每个部分，瓷砖中心位于该点（我希望这些能让你明白那些数字的意思）。我们还必须调用 `refresh()` 来更新组边界框，否则将根据默认位置（场景的左上角）检查冲突。

如果您现在在浏览器中查看应用程序，您应该会看到如下内容：

![蓝屏演变](https://cdn-images-1.medium.com/max/2000/1*GvOFAilcNMp0FnOTr_QqsA.png)

我们终于达到了这个场景中最具活力的部分 —— `update()` 函数，其中星星落下。此函数在 60ms 内调用一次。我们希望每秒发出一颗新的流星。我们不会为此使用动态组，因为每个星的生命周期都很短：它会被用户点击或与地面碰撞而被摧毁。因此，在 `emitStar()` 函数中，我们创建一个新的星并添加两个事件的处理：`onClick()` 和`onCollision()`。

```typescript
update(time: number): void {
    var diff: number = time - this.lastStarTime;
    if (diff > this.delta) {
      this.lastStarTime = time;
      if (this.delta > 500) {
        this.delta -= 20;
      }
      this.emitStar();
    }
    this.info.text =
      this.starsCaught + " caught - " +
      this.starsFallen + " fallen (max 3)";
  }

private onClick(star: Phaser.Physics.Arcade.Image): () => void {
    return function () {
      star.setTint(0x00ff00);
      star.setVelocity(0, 0);
      this.starsCaught += 1;
      this.time.delayedCall(100, function (star) {
        star.destroy();
      }, [star], this);
    }
  }

private onFall(star: Phaser.Physics.Arcade.Image): () => void {
    return function () {
      star.setTint(0xff0000);
      this.starsFallen += 1;
      this.time.delayedCall(100, function (star) {
        star.destroy();
      }, [star], this);
    }
  }

private emitStar(): void {
    var star: Phaser.Physics.Arcade.Image;
    var x = Phaser.Math.Between(25, 775);
    var y = 26;
    star = this.physics.add.image(x, y, "star");

star.setDisplaySize(50, 50);
    star.setVelocity(0, 200);
    star.setInteractive();

star.on('pointerdown', this.onClick(star), this);
    this.physics.add.collider(star, this.sand, 
      this.onFall(star), null, this);
  }
```

最后，我们有了一个游戏！但是它还没有胜利条件。我们将在教程的最后部分添加它。

![我不擅长捕捉星星……](https://cdn-images-1.medium.com/max/2000/1*tjX0ikNYl-UFJQnOkQIeOA.png)

## 把它全部包装好

通常，游戏由几个场景组成。即使游戏很简单，你也需要一个开始场景（至少包含 Play 按钮）和一个结束场景（显示游戏会话的结果，如得分或达到的最高等级）。让我们将这些场景添加到我们的应用程序中。

在我们的例子中，它们将非常相似，因为我不想过多关注游戏的图形设计。毕竟，这是一个编程教程。

欢迎场景将在 `welcomeScene.ts` 中包含以下代码。请注意，当用户点击此场景中的某个位置时，将显示游戏场景。

```typescript
import "phaser";

export class WelcomeScene extends Phaser.Scene {
  title: Phaser.GameObjects.Text;
  hint: Phaser.GameObjects.Text;

constructor() {
    super({
      key: "WelcomeScene"
    });
  }

create(): void {
    var titleText: string = "Starfall";
    this.title = this.add.text(150, 200, titleText,
      { font: '128px Arial Bold', fill: '#FBFBAC' });

var hintText: string = "Click to start";
    this.hint = this.add.text(300, 350, hintText,
      { font: '24px Arial Bold', fill: '#FBFBAC' });

this.input.on('pointerdown', function (/*pointer*/) {
      this.scene.start("GameScene");
    }, this);
  }
};
```

得分场景看起来几乎相同，点击（ `scoreScene.ts` ）后引导到欢迎场景。

```typescript
import "phaser";

export class ScoreScene extends Phaser.Scene {
  score: number;
  result: Phaser.GameObjects.Text;
  hint: Phaser.GameObjects.Text;

constructor() {
    super({
      key: "ScoreScene"
    });
  }

init(params: any): void {
    this.score = params.starsCaught;
  }

create(): void {
    var resultText: string = 'Your score is ' + this.score + '!';
    this.result = this.add.text(200, 250, resultText,
      { font: '48px Arial Bold', fill: '#FBFBAC' });

var hintText: string = "Click to restart";
    this.hint = this.add.text(300, 350, hintText,
      { font: '24px Arial Bold', fill: '#FBFBAC' });

this.input.on('pointerdown', function (/*pointer*/) {
      this.scene.start("WelcomeScene");
    }, this);
  }
};
```

我们现在需要更新我们的主应用程序文件：添加这些场景并使 `WelcomeScene` 成为列表中的第一个（译者注：第一个位置会首先运行，类似于小程序的 page 列表）：

```typescript
import "phaser";
import { WelcomeScene } from "./welcomeScene";
import { GameScene } from "./gameScene";
import { ScoreScene } from "./scoreScene";

const config: GameConfig = {
  ...
  scene: [WelcomeScene, GameScene, ScoreScene],
  ...
```

你有没有发现遗漏了什么？是的，我们还没有从任何地方调用 `ScoreScene` ！当玩家错过第三颗星时（此时游戏结束），我们来调用它：

```typescript
private onFall(star: Phaser.Physics.Arcade.Image): () => void {
    return function () {
      star.setTint(0xff0000);
      this.starsFallen += 1;
      this.time.delayedCall(100, function (star) {
        star.destroy();
        if (this.starsFallen > 2) {
          this.scene.start("ScoreScene", 
            { starsCaught: this.starsCaught });
        }
      }, [star], this);
    }
  }
```

最后，我们的 Starfall 游戏看起来像一个真正的游戏了 - 它可以开始、结束，甚至有一个分数排行榜（你可以捕获多少颗星？）。

我希望这个教程对你来说和我写的时候一样有用😀，任何反馈都非常感谢！

你可以在 [这里](https://github.com/mariyadavydova/starfall-phaser3-typescript) 找到本教程的源代码。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
