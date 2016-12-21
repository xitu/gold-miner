>* 原文链接 : ["较为完整的 React.js / Vue.js 的性能比较 Part 1." - comparing React.js to Vue.js for dynamic tabular data](https://engineering.footballradar.com/from-a-react-point-of-vue-comparing-reactjs-to-vuejs-for-dynamic-tabular-data/)
* 原文作者 : [Max Willmott](https://engineering.footballradar.com/author/max-willmott/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [circlelove](http://github.com/circlelove)
* 校对者:[liangbijie](http://github.com/liangbijie) , [jamweak](http://github.com/jamweak)

# 较为完整的 React.js / Vue.js 的性能比较 Part 1

##### 更新


所以我把 React 设在了开发模式。创建和合并了许多建议。这个 PR 还是值得一读的，因为它经历了错误地方而一度得到了正确的返回; [https://github.com/footballradar/VueReactPerf/pull/3](https://github.com/footballradar/VueReactPerf/pull/3).



对于第二部分的这些测试，请访问： [较为完整的 React.js / Vue.js 的性能比较](https://gold.xitu.io/entry/57691d5d6be3ff006a438e09)

##### 介绍
plish this, although we are much more experienced with React than we are with Vue.

这个发布的目的是研究 [React](https://facebook.github.io/react/) 和 [Vue](https://vuejs.org/) 作为视图层的区别。选定一个带有频繁更新的数据与固定行数的嵌套表视图作为问题的场景。这很好地表现了我们在 Footbal Radar 面临的前端问题。我们不需要对 React 和 Vue 了解太多来解决这个问题，尽管相比 Vue 来说对于 React 我们已经身经百战了。



你可以在我们的 GitHub上查看我们的代码 - [https://github.com/footballradar/VueReactPerf](https://github.com/footballradar/VueReactPerf).

The output of both view libs will look like this:  

二者 view 的结果如下：                                                                                                                           
![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-21-at-15-02-07.png)

##### 测试

 
我们会对每种方案运行50个比赛。每场比赛每秒更新一次，并将至少增加它的时钟和一个球员单元。另外的属性是随机独立更新。一旦每场比赛开始，我们就会启动时间线记录30秒。明白起见我会转储一个出我的的笔记本的规格的截图。

![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-13-33-07.png)


##### 数据

Our dataset is an array of 5-a-side football games. Each game updates once a second and we’ll allow for a variable number of games. We won’t go into too much detail about how we’re generating the data but if you’re curious check out our `src/react.data.js` and `src/vue.data.js` in the 
我们的数据设置是一个每方5人的足球比赛。每场比赛都是每秒更新一次，我们允许多场比赛同时进行。在这里我们不赘述生产数据的细节，如果你十分好奇，请访问
[GitHub repo](https://github.com/footballradar/VueReactPerf)查看我们的`src/react.data.js` 和 `src/vue.data.js` 。

这就是我们的比赛项目的架构

* 时钟
* 得分

   *   主场
   *   客场

   
 
*   队伍

   *   主场
   *   客场

*   恶意铲球
*   吃牌

   *   黄牌
   *   红牌

*  球员
    *  姓名
    *  努力级别
    *  出场顺序


我们要记住在 view 层显示数据。 虽然数据的产生对于 React 和 Vue 相同，还是存在有轻微的差异

*  Immutable.js for React--这能够方便我们施行 `shouldComponentUpdate`来轻松优化渲染

*  显示数据--通过订阅数据源，我们可以通过`setState()`更新 React 。
*  将数据作为带有接受器的对象显示 -Vue 通过挂钩我们的状态接受器进行实时更新翻译。因此我们需要显示和更新状态作为一个壳边对象

##### React 实例

为了创建以上视图我们用4个组件收尾：
*   `App` - 从数据源和带有最新数据的 `setState`订阅。
*   `Games` - 通过  `App` 渲染，获取比赛数组。
*   `Game` - 利用`Games` 渲染的一行，获得比赛地图。
*   `Player` -  通过 'game' 渲染的元组，获取球员地图。


任何时候当有嵌套的数据时，我们可以利用“Immutable 引用检查”的优势，即过创建一个子组件并实现‘shouldComponentUpdate’
。这个案例当中，我们为`Game` 和 `Player`组件进行了此项操作。


    shouldComponentUpdate(nextProps){
        return nextProps.game !== this.props.game;
    }


考虑到我们所做的一切都是在 `Game` 地图里面访问属性之后显示，创建比分、队伍和吃牌的子组件就没有那么必要了。

这是来自 React 实例的第一个结果。

_概述:_

 ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-13-58-26.png) 


_自下而上:_

 ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-13-59-00.png) 


_时间线:_

 ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-14-07-19.png)


大概10% 的浏览器时间用于脚本。当这不是空闲时，它主要是脚本，因此在时间轴中的峰值大都是黄色。我们可以确保时间都花在 React 而不是在重堆栈查找生成数据：


![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-13-59-34-1.png)

由于没有什么可以比较的，也没有太多好说的。当我们第一次运行测试的时候我忘记了在`Game` 组件置放`shouldComponentUpdate` ，造成结果差异巨大。

![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-21-at-15-16-02-1.png)

3行的 Javascript 代码使得工作量减少了5倍。不管怎么样都迁入我们的 Vue 版本。

##### Vue 实例


起初我并不确定是否要用 Immutable.js 的 Vue ，因为他依赖于挂钩朴素 JavaScript 对象的接收器/给定器。

我第一个尝试确实死在了时间线上面。尽管如此我记录了30秒，只能得到5到20秒的结果。我意识到这可能是因为页面在15秒使用了完全的时间线缓冲！所以我只会打印前10秒的结果。

![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-21-at-17-38-04.png)

10秒的时间当中，2秒用于脚本的运行上。这并不乐观。Vue 耗费的时间重新创建组件的数据每次都是一个新的参考，这就是使用 Immutable.js 的一个关键。所有我们抛弃了这个方法。

我们改变了数据结构因而只是显示了状态对象，之后直接传递给了 Vue 实例。 同一比赛的所有的更新连带引用都是相同的；完成地和 React 做的事情相反。也没什么太多代码改变。一旦我们触发了 Immutable.js ，所有需要做的就是显示比赛：

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



我们没有订阅组件的数据源，那是我们在 React 的 `App`  组件里面使用的，我们订阅的是自己小的存储器当中。    利用获取器显示状态，Vue 就可以挂钩通顺保持通过我们获取器的只读状态了。我是从 Vuex 的源码里偷学的这种方法， Vuex 是一种 Vue 的状态管理库。

_概述 - Vue:_

 ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-14-01-40.png) 

_概述 - React:_

 ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-13-58-26-1.png)

第一幅图是 Vue ， 第二幅是 React 的概述。看这个饼图，真是空闲呢！我需要运行测试以及 React 多次来保证结果符合要求。

_自下而上 - Vue:_

 ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-14-02-17.png) 

_自下而上 - React:_

 ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-13-59-00-1.png)


我们可以看到，相比 React 来说，Vue 在自身消耗的时间更少。 这是取决于每个组件处理的数据和更新速度。

_重堆栈 - Vue:_

 ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-14-04-19.png) 

_重堆栈- React:_

 ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-13-59-34.png)

_时间线 - Vue:_

 ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-14-05-11.png) 

_时间线 - React:_

 ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-14-07-19-1.png)


我想这能代表的东西不少。Vue 的时间线上面，有意义的黄色更少了。内存也相当不错。尽管缓慢上升，或许这表明在我数据生成当中有某种问题发生。

好吧很酷，不过我们全身还有可以商量的实验空间。如果我们使用的规模是100个比赛呢？我们得离开页面一小会让每个游戏都 “开球”

_概述 - Vue:_

 ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-13-50-29.png) 

_概述 - React:_

 ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-13-53-55.png)

我们的　Vue　实例处理加载比　React　更好，React　用了３倍的时间进行脚本处理了50个比赛。


不知道为什么那就先试试500个游戏吧，我将只记录前15秒的信息（如果我们没有杀死时间线缓存的话。。。）

_概述 - Vue:_

 ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-14-20-38.png) 

_概述 - React:_

 ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-14-36-14.png)

_自下而上 - Vue:_

 ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-14-21-14.png) 

_自下而上 - React:_

 ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-14-36-33.png)

说实话我对于 React 前15秒的时间线记录十分吃惊。实际上似乎它比 Vue 实例在时间线使用了更少的缓存。React 页不可用，采集大概10秒来进行时钟更新。Vue 页面的耗费不多但是出于不同的原因，非常令人愉快地看到打印时间比脚本处理时间长。我能标注行和更新并不在峰位，而是在后面。

##### 结论

对于结果我特别震惊，我不知道 Vue 是不是就那么好，随便了。这些不是完美的测试但是他们实际完成了真实的问题，而我们不能够给出完美的解决方案。

takeway 就是 Vue  在处理现存元素/数据的频繁变化方面比 React好，我相信这就是答案。
 [reactivity](https://vuejs.org/guide/reactivity.html) system.

感谢您的阅读  

[https://github.com/footballradar/VueReactPerf](https://github.com/footballradar/VueReactPerf)

