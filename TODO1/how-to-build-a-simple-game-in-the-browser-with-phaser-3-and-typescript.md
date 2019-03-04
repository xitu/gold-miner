> * 原文地址：[How to build a simple game in the browser with Phaser 3 and TypeScript](https://medium.freecodecamp.org/how-to-build-a-simple-game-in-the-browser-with-phaser-3-and-typescript-bdc94719135)
> * 原文作者：[Mariya Davydova](https://medium.com/@mariyadavydova)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-build-a-simple-game-in-the-browser-with-phaser-3-and-typescript.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-build-a-simple-game-in-the-browser-with-phaser-3-and-typescript.md)
> * 译者：
> * 校对者：

## How to build a simple game in the browser with Phaser 3 and TypeScript

![](https://cdn-images-1.medium.com/max/10944/1*m16cMnrn60vR49N8Sj1liA.jpeg)

Photo by [Phil Botha](https://unsplash.com/photos/a0TJ3hy-UD8?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/collections/3995048/stars/e08862541511fcb17f0de3d4a555bff8?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)

I’m a developer advocate and a backend developer, and my frontend development expertise is relatively weak. A while ago I wanted to have some fun and make a game in a browser; I chose Phaser 3 as a framework (it looks quite popular these days) and TypeScript as a language (because I prefer static typing over dynamic). It turned out that you need to do some boring stuff to make it all work, so I wrote this tutorial to help the other people like me get started faster.

## Preparing the environment

### IDE

Choose your development environment. You can always use plain old Notepad if you wish, but I would suggest using something more helpful. As for me, I prefer developing pet projects in Emacs, therefore I have installed [tide](https://github.com/ananthakumaran/tide) and followed the instructions to set it up.

### Node

If we were developing on JavaScript, we would be perfectly fine to start coding without all these preparation steps. However, as we want to use TypeScript, we have to set up the infrastructure to make the future development as fast as possible. Thus we need to install node and npm.

As I write this tutorial, I use [node 10.13.0](https://nodejs.org/en/) and [npm 6.4.1](https://www.npmjs.com/). Please note that the versions in the frontend world update extremely fast, so you simply take the latest stable versions. I strongly recommend using [nvm](https://github.com/creationix/nvm) instead of installing node and npm manually; it will save you a lot of time and nerves.

## Setting up the project

### Project structure

We will use npm for building the project, so to start the project go to an empty folder and run `npm init`. npm will ask you several questions about your project properties and then create a `package.json` file. It will look something like this:

```
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

### Packages

Install the packages we need with the following command:

```
npm install -D typescript webpack webpack-cli ts-loader phaser live-server
```

`-D` option (a.k.a. `--save-dev`) makes npm add these packages to the list of dependencies in `package.json` automatically:

```
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

Webpack will run the TypeScript compiler and collect the bunch of resulting JS files as well as libraries into one minified JS so that we can include it in our page.

Add `webpack.config.js` near your `project.json`:

```
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

Here we see that webpack has to get the sources starting from `src/app.ts`(which we’ll add very soon) and collect everything in `dist/app.js` file.

### TypeScript

We also need a small configuration file for the TypeScript compiler (`tsconfig.json`) where we explain which JS version we want the sources to be compiled to and where to find those sources:

```
{
  "compilerOptions": {
    "target": "es5"
  },
  "include": [
    "src/*"
  ]
}
```

### TypeScript definitions

TypeScript is a statically typed language. Therefore, it requires type definitions for the compilation. At the time of writing this tutorial, the definitions for Phaser 3 were not yet available as the npm package, so you may need to [download them](https://github.com/photonstorm/phaser3-docs/blob/master/typescript/phaser.d.ts) from the official repository and put the file in the `src` subdirectory of your project.

### Scripts

We have almost finished the project set up. At this moment you should have created `package.json`, `webpack.config.js`, and `tsconfig.json`, and added `src/phaser.d.ts`. The last thing we need to do before starting to write code is to explain what exactly npm has to do with the project. We update the `scripts` section of the `package.json` as follows:

```
"scripts": {
  "build": "webpack",
  "start": "webpack --watch & live-server --port=8085"
}
```

When you execute `npm build`, the `app.js` file will be built according to the webpack configuration. And when you run `npm start`, you won’t have to bother about the build process: as soon as you save any source, webpack will rebuild the app and the [live-server](https://www.npmjs.com/package/live-server) will reload it in your default browser. The app will be hosted at [http://127.0.0.1:8085/](http://127.0.0.1:8085/).

## Getting started

Now that we have set up the infrastructure (the part I personally hate when starting a project), we can finally start coding. In this step we’ll do a straightforward thing: draw a dark blue rectangle in our browser window. Using a big game development framework for this is a little bit of… hmmm… overkill. Still, we’ll need it on the next steps.

Let me briefly explain the main concepts of Phaser 3. The game is an instance of the `Phaser.Game` class (or its descendant). Each game contains one or more instances of `Phaser.Scene` descendants. Each scene contains several objects, either static or dynamic, and represents a logical part of the game. For example, our trivial game will have three scenes: the welcome screen, the game itself, and the score screen.

Let’s start coding.

First, create a minimalistic HTML container for the game. Make an `index.html` file, which contains the following code:

```
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

There are only two essential parts here: the first one is a `script` entry which says that we are going to use our built file here, and the second one is a `div` entry which will be the game container.

Now create a file `src/app.ts` with the following code:

```
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

This code is self-explanatory. GameConfig has a lot of various properties, you can check them out [here](https://photonstorm.github.io/phaser3-docs/global.html#GameConfig) .

And now you can finally run `npm start`. If everything was done correctly on this and previous steps, you should see something as simple as this in your browser:

![Yes, this is a blue screen.](https://cdn-images-1.medium.com/max/2000/1*1ecSa8Bs5zX6TQRq60qr6w.png)

## Making the stars fall

We have created an elementary application. Now it’s time to add a scene where something will happen. Our game will be simple: the stars will fall to the ground, and the goal will be to catch as many as possible.

To achieve this goal create a new file, `gameScene.ts`, and add the following code:

```
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

Constructor here contains a key under which other scenes may call this scene.

You see here stubs for four methods. Let me briefly explain the difference between then:

* `init([params])` is called when the scene starts; this function may accept parameters, which are passed from other scenes or game by calling `scene.start(key, [params])`

* `preload()` is called before the scene objects are created, and it contains loading assets; these assets are cached, so when the scene is restarted, they are not reloaded

* `create()` is called when the assets are loaded and usually contains creation of the main game objects (background, player, obstacles, enemies, etc.)

* `update([time])` is called every tick and contains the dynamic part of the scene — everything that moves, flashes, etc.

To be sure that we don’t forget it later, let’s quickly add the following lines in the `game.ts`:

```
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

Our game now knows about the game scene. If the game config contains a list of scenes then the first one is started when the game is begun, and all others are created but not started until explicitly called.

We have also added arcade physics here. It is required to make our stars fall.

Now we can put flesh on the bones of our game scene.

First, we declare some properties and objects we’re gonna need:

```
export class GameScene extends Phaser.Scene {
  delta: number;
  lastStarTime: number;
  starsCaught: number;
  starsFallen: number;
  sand: Phaser.Physics.Arcade.StaticGroup;
  info: Phaser.GameObjects.Text;
...
```

Then, we initialize numbers:

```
init(/*params: any*/): void {
    this.delta = 1000;
    this.lastStarTime = 0;
    this.starsCaught = 0;
    this.starsFallen = 0;
  }
```

Now, we load a couple of images:

```
preload(): void {
    this.load.setBaseURL(
      "https://raw.githubusercontent.com/mariyadavydova/" +
      "starfall-phaser3-typescript/master/");
    this.load.image("star", "assets/star.png");
    this.load.image("sand", "assets/sand.jpg");
  }
```

After that, we can prepare our static components. We will create the ground, where the stars will fall, and the text informing us about the current score:

```
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

A group in Phaser 3 is a way to create a bunch of the objects you want to control together. There two types of objects: static and dynamic. As you may guess, static objects don’t move (ground, walls, various obstacles), while dynamic ones do the job (Mario, ships, missiles).

We create a static group of the ground pieces. Those pieces are placed along the line. Please note that the line is divided into 20 equal sections (not 19 as you’ve may have expected), and the ground tiles are placed on each section at the left end with the tile center located at that point (I hope this explains those numbers). We also have to call `refresh()` to update the group bounding box (otherwise, the collisions will be checked against the default location, which is the top left corner of the scene).

If you check out your application in the browser now, you should see something like this:

![Blue screen evolution](https://cdn-images-1.medium.com/max/2000/1*GvOFAilcNMp0FnOTr_QqsA.png)

We have finally reached the most dynamic part of this scene — `update()` function, where the stars fall. This function is called somewhere around once in 60 ms. We want to emit a new falling star every second. We won’t use a dynamic group for this, as the lifecycle of each star will be short: it will be destroyed either by user click or by colliding with the ground. Therefore inside the `emitStar()` function we create a new star and add the processing of two events: `onClick()` and `onCollision()`.

```
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

Finally, we have a game! It doesn’t have a win condition yet. We’ll add it in the last part of our tutorial.

![I’m bad at catching stars…](https://cdn-images-1.medium.com/max/2000/1*tjX0ikNYl-UFJQnOkQIeOA.png)

## Wrapping it all up

Usually, a game consists of several scenes. Even if the gameplay is simple, you need an opening scene (containing at the very least the ‘Play!’ button) and a closing one (showing the result of your game session, like the score or the maximum level reached). Let’s add these scenes to our application.

In our case, they will be pretty similar, as I don’t want to pay too much attention to the graphic design of the game. After all, this a programming tutorial.

The welcome scene will have the following code in `welcomeScene.ts`. Note that when a user clicks somewhere on this scene, a game scene will appear.

```
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

The score scene will look almost the same, leading to the welcome scene on click (`scoreScene.ts`).

```
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

We need to update our main application file now: add these scenes and make the `WelcomeScene` to be the first in the list:

```
import "phaser";
import { WelcomeScene } from "./welcomeScene";
import { GameScene } from "./gameScene";
import { ScoreScene } from "./scoreScene";

const config: GameConfig = {
  ...
  scene: [WelcomeScene, GameScene, ScoreScene],
  ...
```

Have you noticed what is missing? Right, we do not call the `ScoreScene` from anywhere yet! Let’s call it when the player has missed the third star:

```
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

Finally, our Starfall game looks like a real game — it starts, ends, and even has a goal to archive (how many stars can you catch?).

I hope this tutorial is as useful for you as it was for me when I wrote it :) Any feedback is highly appreciated!

The source code for this tutorial may be found [here](https://github.com/mariyadavydova/starfall-phaser3-typescript).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
