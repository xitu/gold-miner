> * 原文地址：[What I wish I knew when I started to work with React.js](https://medium.freecodecamp.org/what-i-wish-i-knew-when-i-started-to-work-with-react-js-3ba36107fd13)
> * 原文作者：[David Yu](https://medium.com/@davidyu_44356)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/what-i-wish-i-knew-when-i-started-to-work-with-react-js.md](https://github.com/xitu/gold-miner/blob/master/TODO1/what-i-wish-i-knew-when-i-started-to-work-with-react-js.md)
> * 译者：[xionglong58](https://github.com/xionglong58)
> * 校对者：[xujiujiu](https://github.com/xujiujiu)，[wznonstop](https://github.com/wznonstop)

# 我多希望在我学习 React.js 之前就已经知晓这些小窍门

![Photo by [Ben White](https://unsplash.com/@benwhitephotography?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10432/0*nrQ5vVSdulAG3LFO)

自从 2013 年 5 月 29 日发布初始版本以来，React.js 迅速抢占互联网。很明显，包括我在内的很多开发者都从这一神奇的架构中获益。

在 Medium 中有很多关于 React.js 的教程，我真希望在初学 React.js 的时候，其中能有一篇能告诉我下面所列的一些小窍门。

## 使用箭头函数的时候不需要 .bind(this) 操作

通常，当你有一个受控组件的时候，你的程序多少会包含下面的内容：

```
class Foo extends React.Component{
  constructor( props ){
    super( props );
    this.handleClick = this.handleClick.bind(this);
  }

  handleClick(event){
    // your event handling logic
  }

  render(){
    return (
      <button type="button" 
      onClick={this.handleClick}>
      Click Me
      </button>
    );
  }
}
```

你之所以会针对每一个方法使用 `.bind(this)`，是因为大多数教程告诉你得那样做。当你有很多受控组件的时候，你的 `constructor(){}` 将会显得特别臃肿。

### 其实，你可以这样做：

```
class Foo extends React.Component{

  handleClick = (event) => {
    // your event handling logic
  }

  render(){
    return (
      <button type="button" 
      onClick={this.handleClick}>
        Click Me
      </button>
    );
  }
}
```

咋样？

ES6 中的箭头函数使用[词法作用域](https://whatis.techtarget.com/definition/lexical-scoping-static-scoping)让方法能够访问其被定义位置的 `this`。

## 当 service worker 阻碍你开发时

service worker 有利于[渐进式 web 应用](https://developers.google.com/web/progressive-web-apps/)，它使得网页能够离线访问，并在用户的网络连接状态差时进行优化。

但是，如果你没有意识到 service worker 在缓存你的静态文件，你会反复尝试进行热替换操作。

却发现网站一直得不到更新。😰

莫慌张, 确保你的 `src/index.js` 文件中有以下内容：

```
// 确保注销 service worker
serviceWorker.unregister();
```

从 React.js 的 16.8 版开始，上面一行默认就是 `serverWorker.unregister()`。

但是，如果以后版本有变化，你也会知道在哪儿进行修改。

## 99% 的情况下你不需要使用 eject

[Create React App](https://github.com/facebook/create-react-app) 提供一个命令 `yarn eject`，使得你能够定制项目的构建过程。

还记得我曾为了在代码中自动内嵌 SVG 图片而尝试去自己配置构建过程。我花了大量的时间去了解整个构建过程。最终我们得到了一个注入了 SVG 标签的导入文件，并将站点的加载速度只提高了 0.0001 毫秒。

eject 你的 React 项目就像是打开运行中汽车的引擎盖，并在行驶中更换引擎一样。

当然了，如果你是一名 Webpack 大佬，那么为了满足项目的需求而去定制构建过程也是值得的。

如果你只是想按时完成任务，那就把精力全部集中在能够推动你前进的地方。

## ESlint 的 Auto Fix On Save 会让你节省很多时间

你可能也曾从某些地方拷贝过格式混乱的代码。由于无法接受它“丑陋”的格式，你不得不花时间手动加一些空格啥的。

![](https://cdn-images-1.medium.com/max/3840/1*mJyoA_RfLTejXzz49Epgmg.gif)

有了 ESLint 和 Visual Studio Code 插件，代码会在你保存文件时自动对齐。

![](https://cdn-images-1.medium.com/max/3840/1*OeKL1AqAkouPQ4I3NdKRbw.gif)

### 如何进行设置呢？

 1. 在你的 `package.json` 文件中添加一些 dev dependencies 并执行命令 `npm i` 或 `yarn`：

```
"devDependencies": {

 "eslint-config-airbnb": "^17.1.0",

 "eslint-config-prettier": "^3.1.0",

 "eslint-plugin-import": "^2.14.0",

 "eslint-plugin-jsx-a11y": "^6.1.1",

 "eslint-plugin-prettier": "^3.0.0",

 "eslint-plugin-react": "^7.11.0"

}
```

2. 安装 ESLint 扩展

![](https://cdn-images-1.medium.com/max/2000/1*fS3jaNpWKkaoV8ZZWAgcVA.png)

3. 勾选 Auto Fix On Save

![](https://cdn-images-1.medium.com/max/2000/1*FZLWmlqxE1leDVlaMrd_RA.png)

## 你并不需要 Redux、styled-components 等库

每种工具都有其用途，了解不同的工具也确实是件好事。

> 如果你手里有一把锤子，所有东西看上去都像钉子。—— 亚伯拉罕·马斯洛

使用一些库时你需要考虑引入它们的时间成本，还要考虑下面的几个问题：

* 我将要去解决什么问题？

* 项目能否长久的受益于这个库吗？

* React 本身是不是已经提供了现成的解决方法？

当 React 有 [Context](https://reactjs.org/docs/context.html) 和 [Hooks](https://reactjs.org/docs/hooks-intro.html) 时, 你真的还需要 Redux 吗？

当你的用户处于糟糕的网络环境时，我尤其推荐你使用 [Redux Offline](https://github.com/redux-offline/redux-offline)。

## 重用事件处理器

如果你不喜欢重复编写相同的程序，那重用事件处理器是一个不错的选择：

```
class App extends Component {

 constructor(props) {
  super(props);
  this.state = {
   foo: "",
   bar: "",
  };
 }

 // Reusable for all inputs
 onChange = e => {
  const {
   target: { value, name },
  } = e;
  
  // name will be the state name
  this.setState({
   [name]: value
  });

 };
 
 render() {
  return (
   <div>
    <input name="foo" onChange={this.onChange} />
    <input name="bar" onChange={this.onChange} />   
   </div>
  );
 }
}
```

## setState 方法是异步的

小白时期的我可能会写下面的程序：

```
 constructor(props) {
  super(props);
  this.state = {
   isFiltered: false
  };
 }

 toggleFilter = () => {
  this.setState({
   isFiltered: !this.state.isFiltered
  });
  this.filterData();
 };
 
 filterData = () => {
  // this.state.isFiltered 值应该为 true，但事实上却为 false
  if (this.state.isFiltered) {
   // Do some filtering
  }
 };
```

### 建议 1：向下传递 state

```
toggleFilter = () => {
 const currentFilterState = !this.state.isFiltered;
 this.setState({
  isFiltered: currentFilterState
 });
 this.filterData(currentFilterState);
};

filterData = (currentFilterState) => {
 if (currentFilterState) {
  // 做些过滤操作
 }
};
```

### 建议 2：在 setState 的第二个回调函数中操作 state

```
toggleFilter = () => {
 this.setState((prevState) => ({
  isFiltered: !prevState.isFiltered
 }), () => {
  this.filterData();
 });
};

filterData = () => {
  if (this.state.isFiltered) {
   // 做些过滤操作
  }
};
```

## 总结

这些小窍门节省了我很多时间，我也相信还有很多关于 React.js 的小窍门。请在评论区自由评论、分享你所知道的小窍门。

（广告时间）如果你希望你的网站与微信平台进行结合，并获得 10 亿以上的用户，快注册获取[微信常用术语词汇表](https://pages.convertkit.com/b2469604dd/0c671fdd2d).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
