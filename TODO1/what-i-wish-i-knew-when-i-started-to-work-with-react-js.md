> * 原文地址：[What I wish I knew when I started to work with React.js](https://medium.freecodecamp.org/what-i-wish-i-knew-when-i-started-to-work-with-react-js-3ba36107fd13)
> * 原文作者：[David Yu](https://medium.com/@davidyu_44356)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/what-i-wish-i-knew-when-i-started-to-work-with-react-js.md](https://github.com/xitu/gold-miner/blob/master/TODO1/what-i-wish-i-knew-when-i-started-to-work-with-react-js.md)
> * 译者：[xionglong58](thhps:github.com/xionglong58)
> * 校对者：

# 我多希望在我学习 React.js 之前就已经知晓这些小窍门

![Photo by [Ben White](https://unsplash.com/@benwhitephotography?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10432/0*nrQ5vVSdulAG3LFO)

自从 2013 年 5 月 29 日发布初始版本以来，React.js 迅速抢占互联网。很明显，包括我在内的很多开发者从这一神奇的架构中取得成效。

在 Medium 中有很多关于 React.js 的教程，我真希望在我学习 React.js 的时候，其中能有一篇能告诉我下面所列的一些小窍门。

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

你之所以会针对每一个方法使用 `.bind(this)`，是因为大多数教程告诉你得那样做。当你有很多受控组件的时候，你的 `constructor(){}`将会显得特别臃肿。

### 其实，你可以这样做:

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

咋样?

ES6 中的箭头函数使用[词法作用域](https://whatis.techtarget.com/definition/lexical-scoping-static-scoping)让方法能够访问其被定义位置的 `this`。

## When service workers work against you

Service worker 有利于[渐进式 web 应用](https://developers.google.com/web/progressive-web-apps/)，它使得网页能够离线访问，并在用户的网络链接状态差时进行优化。

但是，如果你没有意识到 service worker 在缓存你的静态文件，你会反复尝试进行热替换操作。

却发现网站一直得不到更新。😰

莫慌张, 确保你的 `src/index.js` 文件中有以下内容：

```
// 确保 service worker 取消注册
serviceWorker.unregister();
```

从 React.js 的 16.8 版开始，上面一行默认就是 `serverWorker.unregister()` 。

但是，如果以后版本有变化，你得知道在哪儿进行修改。

## 99% 的情况下你不需要使用 eject

[Create React App](https://github.com/facebook/create-react-app) 提供一个命令 `yarn eject`，使得你能够个性化项目的构建过程。

I remember trying to customize the build process to have SVG images automatically inlined in our code. I spent hours just trying to understand the build process. We end up having an import file that injects SVG tags, and we increased the site’s loading speed by 0.0001 milliseconds.

Ejecting your React project is like popping the hood of your running car and changing the engine on the fly to run 1% faster.

Of course, if you’re already a Webpack master, it’s worthwhile to customize the build process to tailor the project’s needs.

When you’re trying to deliver on time, focus your effort on where it moves the needle forward.

## ESlint Auto Fix On Save saves so much time

You might have copied some code from somewhere that has out of whack formatting. Because you can’t stand how ugly it looks, you spend time manually adding spaces.

![](https://cdn-images-1.medium.com/max/3840/1*mJyoA_RfLTejXzz49Epgmg.gif)

With ESLint and Visual Studio Code Plugin, it can fix it for you on save.

![](https://cdn-images-1.medium.com/max/3840/1*OeKL1AqAkouPQ4I3NdKRbw.gif)

### How?

 1. In your `package.json`, add some dev dependencies and do `npm i` or `yarn`:

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

2. Install ESLint extension

![](https://cdn-images-1.medium.com/max/2000/1*fS3jaNpWKkaoV8ZZWAgcVA.png)

3. Enable Auto Fix On Save

![](https://cdn-images-1.medium.com/max/2000/1*FZLWmlqxE1leDVlaMrd_RA.png)

## You don’t need Redux, styled-components, etc…

Every tool has its purpose. That being said, it’s good to know about the different tools.

> If all you have is a hammer, everything looks like a nail — Abraham Maslow

You need to think about the setup time for some of the libraries you use and compare it to:

* What’s the problem that I am trying to solve?

* Will this project live long enough to benefit from this library?

* Does React already offer something right out of the box?

With [Context](https://reactjs.org/docs/context.html) and [Hooks](https://reactjs.org/docs/hooks-intro.html) available for React now, do you still need Redux?

I do highly recommend [Redux Offline](https://github.com/redux-offline/redux-offline) for when your users are in a poor internet connection environment.

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

The naïve me would write something like:

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
  // this.state.isFiltered should be true, but it's not
  if (this.state.isFiltered) {
   // Do some filtering
  }
 };
```

### Option 1: Passing the state down

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
  // Do some filtering
 }
};
```

### Option 2: The secondary function to the callback of setState

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
   // Do some filtering
  }
};
```

## 总结

这些小窍门节省了我很多时间，我也相信还有很多关于 React.js 的小窍门。请在评论区自由评论、分享你所知道的小窍门。

（广告时间）如果你希望你的网站与微信平台进行结合，并获得 10 亿以上的用户，快注册获取[微信常用术语词汇表](https://pages.convertkit.com/b2469604dd/0c671fdd2d).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
