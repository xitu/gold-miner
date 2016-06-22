>* 原文链接 : ["From a React point of Vue..." - comparing React.js to Vue.js for dynamic tabular data](https://engineering.footballradar.com/from-a-react-point-of-vue-comparing-reactjs-to-vuejs-for-dynamic-tabular-data/)
* 原文作者 : [Max Willmott](https://engineering.footballradar.com/author/max-willmott/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [circlelove](http://github.com/circlelove)
* 校对者:



##### Update
##### 更新


So I'd left React in development mode. A number of suggestions have been made and merged in. The PR is worth a read as it goes through what went wrong and has some results once corrected; [https://github.com/footballradar/VueReactPerf/pull/3](https://github.com/footballradar/VueReactPerf/pull/3).

所以我把 React 设在了开发模式。创建和合并了许多建议。这个 PR 还是值得一读的，因为它经历了错误地方而一度得到了正确的返回。

For part 2 of these tests, please visit:
对于第二部分的这些测试，请访问： [https://engineering.footballradar.com/a-fairer-vue-of-react-comparing-react-to-vue-for-dynamic-tabular-data-part-2/](https://engineering.footballradar.com/a-fairer-vue-of-react-comparing-react-to-vue-for-dynamic-tabular-data-part-2/)

##### Intro
##### 介绍

The aim of this post is to observe the differences between [React](https://facebook.github.io/react/) and [Vue](https://vuejs.org/) as view layers. The scenario is a page which has a table of nested, frequently-updating data with a fixed number of rows. This nicely represents some of the problems we face on the front-end at Football Radar. We don’t need to know too much about React or Vue to accomplish this, although we are much more experienced with React than we are with Vue.
这个发布的目的是研究 [React](https://facebook.github.io/react/) 和 [Vue](https://vuejs.org/) 作为视图层的区别。这个场景是关于有一个嵌套表，带有频繁更新的数据与固定行数。这很好地表现了我们在 Footbal Radar 面临的前端问题。我们不需要对 React 和 Vue 了解太多来解决这个问题，尽管相比 Vue 来说对于 React 我们已经身经百战了。


You can check out the code on our GitHub 
你可以在我们的 GitHub上查看我们的代码 - [https://github.com/footballradar/VueReactPerf](https://github.com/footballradar/VueReactPerf).

The output of both view libs will look like this:  

二者 view 的结果如下：                                                                                                                                                                                                                                                                                                                                                                     
![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-21-at-15-02-07.png)

##### The Test
##### 测试

We’ll run each solution with 50 games. Each game updates once a second and will at a minimum increment its clock and one player cell. Other properties are randomly and independently updated. Once each game has kicked off we’ll start a timeline recording for 30 seconds. I’ll dump a screenshot of my laptop's spec for clarification:  
我们会对每种方案运行50个比赛。每场比赛每秒更新一次，并将至少增加它的时钟和一个球员细胞。另一个属性是随机和无依赖更新。一旦每场比赛开始，我们就会启动时间线记录30秒。明白起见我会转储一个出我的的笔记本的规格的截图。

![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-13-33-07.png)

##### The Data
##### 数据

Our dataset is an array of 5-a-side football games. Each game updates once a second and we’ll allow for a variable number of games. We won’t go into too much detail about how we’re generating the data but if you’re curious check out our `src/react.data.js` and `src/vue.data.js` in the 
我们的数据设置是一个每方5人的足球比赛。每场比赛都是每秒更新一次，我们允许多场比赛同时进行。在这里我们不赘述生产数据的细节，如果你十分好奇，请在
[GitHub repo](https://github.com/footballradar/VueReactPerf)查看我们的`src/react.data.js` 和 `src/vue.data.js` 。

This is the structure of the Game object
这就是我们的比赛项目的架构

*   clock 时钟
*   score 得分

   *   home 主场
   *   away 客场

   
 
*   teams 队伍

   *   home 主场
   *   away 客场

*   outrageousTackles 恶意铲球
*   cards 吃牌

   *   yellow 黄牌
   *   red 红牌

*   players 球员
    *   name 姓名
    *   effortLevel 努力级别
    *   invitedNextWeek  出场顺序

We need to expose our data with our view layer in mind. Whilst the generation of the data will remain the same for React and Vue, there are slight differences.
我们要记住在 view 层显示数据。 虽然数据的产生对于 React 和 Vue 相同，还是存在有轻微的差异

*   Immutable.js for React - This lets us implement `shouldComponentUpdate` to easily to optimise our renders. 这能够方便我们施行 `shouldComponentUpdate`来轻松优化渲染
*   Expose data as an Observable for React - By subscribing to our data source we can then update React via `setState()`.显示数据，通过订阅数据源，我们可以通过`setState()`更新 React 。
*   Expose data as POJO with getters for Vue - Vue reacts to changes to our state by hooking into the getters. Due to this we need to expose and update our state as a mutable object. 将数据作为带有接受器的对象显示 - Vue 通过挂钩我们的状态接受器进行实时更新翻译。因此我们需要显示和更新状态作为一个壳边对象

##### React Implementation
##### React 实例

To create the view above we ended up with 4 components:
为了创建以上视图我们用4个组件收尾：
*   `App` - subscribes to the data source and `setState` with the latest data从数据源和带有最新数据的 `setState`订阅。
*   `Games` - Rendered by `App`, taking the array of Games通过  `App` 渲染，获取比赛数组。
*   `Game` - A row rendered by `Games`, taking a Game Map 利用`Games` 渲染的一行，获得比赛地图。
*   `Player` - A cell rendered by `Game`, taking the Player Map 通过 'game' 渲染的元组，获取球员地图。

Any time there is nested data we can gain the advantage of Immutable reference checking by creating a sub component for it and implement `shouldComponentUpdate`. In this case we’ve done it for the `Game` and `Player` component:
借助 Immutable 引用检查的优势，任何时候都有我们可以充分利用的嵌套数据，这创建了一个子组件，和一个实例`shouldComponentUpdate`。这个案例当中，我们为`Game` 和 `Player`组件进行了此项操作。
    shouldComponentUpdate(nextProps){
        return nextProps.game !== this.props.game;
    }

Considering all we’re doing is accessing a property in the `Game` Map then displaying it, there shouldn’t be much need to create a sub component for scores, teams and cards.
考虑到我们所做的一切都是在 `Game` 地图里面访问属性之后显示，创建比分、队伍和吃牌的子组件就没有那么必要了。

Here are the first results from the React implementation:
这是来自 React 实例的第一个结果。

_Summary:_ ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-13-58-26.png) _Bottom-up:_ ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-13-59-00.png) _Timeline:_ ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-14-07-19.png)

Roughly 10% of the browser's time was spent scripting. When it wasn’t idle it was mostly scripting, hence the spikes in the timeline being mostly yellow. We can make sure the time was spent in React and not our data generation by looking at the heaviest stack window:  
大概10% 的浏览器时间用于脚本。当这不是空闲时，它主要是脚本，因此在时间轴中的峰值大都是黄色。我们可以确保时间都花在 React 而不是通过查看重堆栈的数据生成：
![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-13-59-34-1.png)

Since we have nothing to compare this to there’s not much to say at this point. When we first ran this test I had forgotten to put the `shouldComponentUpdate` on the `Game` component and the difference was huge:  
由于没有什么可以比较的，也没有太多好说的。当我们第一次运行测试的时候我忘记了在`Game` 组件置放`shouldComponentUpdate` ，造成结果差异巨大。

![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-21-at-15-16-02-1.png)

3 lines of JavaScript reduced the work by 5 times. Anyway moving onto our Vue version.
3行的 Javascript 代码使得工作量减少了5倍。不管怎么样都迁入我们的 Vue 版本。

##### Vue Implementation
##### Vue 实例

At first I wasn’t sure about using Immutable.js with Vue since it relies on hooking into the getters/setters of plain JavaScript Objects. Whilst this is cool I still want to use Immutable in my data generation as it forces consistency when updating data and reduces bugs caused by side effects.
起初我并不确定是否要用 Immutable.js 的 Vue ，因为他依赖于挂钩朴素 JavaScript 项目的接收器/给定器。

My first attempt really buggered up the timeline. Even though I recorded 30 seconds I would only get between 5 and 20 seconds of results. I realised this was due to the page using the entire timeline buffer in ~15 seconds! So I’ll just print the results of the first 10 seconds.  
我第一个尝试确实死在了时间线上面。尽管如此我记录了30秒，只能得到5到20秒的结果。我意识到这可能是因为页面在15秒使用了完全的时间线缓冲！所以我只会打印前10秒的结果。
![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-21-at-17-38-04.png)


In 10 seconds, 2 were spent scripting. That isn’t very good. Vue was spending its time recreating each component as the data was a new reference each time, which is the point of using Immutable.js. So we’ll scrap this approach, it’s not how Vue was designed to work anyway but we’re coming from a React perspective here.
10秒当中，2秒用于脚本。这并不乐观。Vue 耗费的时间重新创建组件的数据每次都是一个新的参考，这就是使用 Immutable.js 的一个关键。所有我们抛弃了这个方法。

We changed the data structure so we’re just exposing a POJO of state then passing this directly to the Vue instance. All updates to games are on the same object so the reference is the same; the complete opposite to what we were doing for React. This wasn’t much of a code change however. Once we had stripped away Immutable.js, all we needed to do was expose the games:
我们改变了数据结构因而只是显示了状态对象，之后直接传递给了 Vue 实例。 同一比赛的所有的更新连带引用都是相同的；完成地和 React 做的事情相反。也没什么太多代码改变。一定我们触发了 Immutable.js ，所有需要做的就是显示比赛：

    export function createStore(noOfGames) {

        let _state;

        createGames(noOfGames).subscribe((games) => _state = games);

        return {
            get state() {
                return _state;
            },

            set state(x) {
                throw "State cannot be modified from outside";
            }
        }
    }

    new Vue({
        el: "#app",
        data: {
            games: store.state
        }
    });

Instead of subscribing to the data source in the component, which is what we did in the React `App` component, we subscribe to it in our little store. We then expose the state via a getter so Vue can hook into it whilst keeping it readonly via our setter. I stole this approach by looking at the source of Vuex, a state management lib for Vue.
我们没有订阅组件的数据源，那是我们在 React 的 `App`  组件里面使用的，我们订阅的是自己小的存储。利用获取器显示状态，Vue 就可以挂钩通顺保持通过我们获取器的制度了。我是从 Vuex 的源码里偷学的这种方法， Vuex 是一种 Vue 的状态管理库。

_概述 - Vue:_ ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-14-01-40.png) _Summary - React:_ ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-13-58-26-1.png)

The first image is Vue, the second is the React summary from earlier. Look at that circle. So much idle. I had to run this test and the React one many, many times to make sure this was legit.
第一幅图是 Vue ， 第二幅是 React 的概述。看这个饼图，真是空闲呢！我需要运行测试以及 React 多次来保证结果符合要求。

_自下而上 - Vue:_ ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-14-02-17.png) _Bottom-up - React:_ ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-13-59-00-1.png)

We can see here that Vue spends much less time in itself compared to React. This is down to how each component handles its data and updates.
我们可以看到，相比 React 来说，Vue 在自身消耗的时间更少。 这是取决于每个组件处理的数据和更新速度。

_重堆栈 - Vue:_ ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-14-04-19.png) _Heaviest stack - React:_ ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-13-59-34.png)

_时间线 - Vue:_ ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-14-05-11.png) _Timeline - React:_ ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-14-07-19-1.png)

I thought this was pretty telling too. Significantly less yellow on the Vue timeline. The memory seems pretty good too. Although it is creeping up, maybe indicating some issue in my data generation.
我想这能代表的东西不少。Vue 的时间线上面，有意义的黄色更少了。内存也相当不错。尽管缓慢上升，或许这表明在我数据生成当中有某种问题发生。

Okay cool so this is awesome but we evidently have some room to experiment. What happens when we scale up to 100 games? We’ll have to leave the page for a bit to let each game “kickoff”.
好吧很酷，不过我们全身还有可以商量的实验空间。如果我们使用的规模是100个比赛呢？我们得离开页面一小会让每个游戏都 “开球”

_概述 - Vue:_ ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-13-50-29.png) _Summary - React:_ ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-13-53-55.png)

Our Vue implementation handles the load much better than our React one, which has spent over 3 times the amount of time scripting than with 50 games (half the games).
我们的　Vue　实例处理加载比　React　更好，React　用了３倍的时间进行脚本处理了50个比赛。
Not sure what’s gonna happen but let’s try 500 games, I’ll only record 15secs here (if we don’t kill the timeline buffer…)
不知道为什么那就先试试500个游戏吧，我将只记录前15秒的信息（如果我们没有杀死时间线缓存的话。。。）

_概述 - Vue:_ ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-14-20-38.png) _Summary - React:_ ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-14-36-14.png)

_自下而上 - Vue:_ ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-14-21-14.png) _Bottom-up - React:_ ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-14-36-33.png)

To be honest I’m surprised I could record 15 seconds of timeline for the React version. In fact it seemed to take up a lot less of the timeline buffer than the Vue implementation. The React page was unusable, taking ~10seconds to update the clock by 1 second. The Vue page didn’t fare much better but for different reasons, it’s pretty nice to see the painting time take longer than the scripting time. I could still highlight the rows and the updates weren’t in spikes, just behind.
说实话我对于 React 前15秒的时间线记录十分吃惊。实际上似乎它比 Vue 实例在时间线缓存上用了更少的时间。React 页不可用，采集大概10秒来进行时钟更新。Vue 页面的耗费不多但是出于不同的原因，非常令人愉快地看到打印时间比脚本处理时间长。我能标注行和更新并不在峰位，而是在后面。

##### Conclusion结论

I’m pretty shocked by these results, I didn’t know whether Vue would be better at all, let alone by this much. These aren’t perfect tests but they are constructed around a real world problem where we don’t/can’t have the perfect solution.
对于结果我特别震惊，我不知道 Vue 是不是就那么好，随便了。这些不是完美的测试但是他们实际完成了真实的问题，而我们不能够给出完美的解决方案。

The takeaway is that Vue handles frequent changes to existing elements/data much better than React, and I believe this is due to its
takeway 就是 Vue 解决频率变化使得现有元素/数据比 React好，我相信这就睡答案。
 [reactivity](https://vuejs.org/guide/reactivity.html) system.

Cheers for reading.
感谢您的阅读  

[https://github.com/footballradar/VueReactPerf](https://github.com/footballradar/VueReactPerf)

