>* 原文链接 : ["A fairer Vue of React" - Comparing React to Vue for dynamic tabular data, part 2.](https://engineering.footballradar.com/a-fairer-vue-of-react-comparing-react-to-vue-for-dynamic-tabular-data-part-2/)
* 原文作者 : [Max Willmott](https://engineering.footballradar.com/author/max-willmott/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


_For part one, please visit: [https://engineering.footballradar.com/from-a-react-point-of-vue-comparing-reactjs-to-vuejs-for-dynamic-tabular-data/](https://engineering.footballradar.com/from-a-react-point-of-vue-comparing-reactjs-to-vuejs-for-dynamic-tabular-data/). Note that the results of this first post have been invalidated by some unfortunate mistakes, but this should set the context for this post._

Monday 23rd May we posted the results of a performance experiment using React and Vue. The idea was to work out whether React or Vue would be more suitable for tabular data that updates a lot, especially when performance is critical. This is very representative of some challenges we work on at Football Radar.

Initially we were very encouraged and surprised by the results, but a few important mistakes meant that our "findings" were not as revelatory as as we thought. Thanks to some great feedback from both the React and Vue communities - especially React core engineer Christopher Chedeau ([@vjeux](https://twitter.com/vjeux)) and Vue creator Evan You ([@youyuxi](https://twitter.com/youyuxi)) - we were quickly able to narrow down the problems with our tests. We're very grateful for the high-quality discussion that followed; I'm slightly embarrassed that these mistakes made it into the open but we've learnt a lot from the responses, so it's been a blessing in disguise.

Considering how many improvements have been made as a result of the first post there is nothing to say there can be no further improvements. With that in mind this post is more of a document of a journey than a conclusive, end result.

First of all I would like to recap the intention of this experiment, then talk about the mistakes we made - giving credit to those who helped us fix them - and finally post a fairer set of results from the updated tests.

## The Test

The experiment was to output a list of football games, each updating its data once per second. In order to test performance and scaling characteristics, we altered two independent variables: number of games and delay between updates.

![](http://ac-Myg6wSTV.clouddn.com/5be4086d861ed7351bab.png)

In order to test the performance, we tested with 50, 100 and 500 games in both Vue and React, with delays of 100ms and 1 second. The idea was to simulate the conditions of load on the page and see how both implementations scale.

Our first test suggested that Vue massively outperformed React, which was very sensational and unexpected, but was caused by running the tests in development mode. This was the biggest omission and definitely the main cause of the skewed results. Thank you to Christopher Chedeau (@Vjeux) for catching this bug: [https://github.com/footballradar/VueReactPerf/pull/3](https://github.com/footballradar/VueReactPerf/pull/3). By running React in production mode, many expensive parts of React are avoided, including prop-types checking and warnings. This is an obvious optimisation, but since React runs in development mode by default, one that is easily overlooked. It should be stressed that Vue was _also_ running in development mode, so both tests were equally afflicted. The discussion that followed in that pull request was particularly insightful.

We also pushed some broken test data that further skewed the results by having Vue perform 10x as much work as the equivalent version in React. In our original tests both frameworks were run against equivalent data, but the version on Github had this inconsistency, so other people running the tests may have seen misleading results.

## Changes from previous test

*   Run in [production mode](https://github.com/footballradar/VueReactPerf/pull/3)
*   Add `webpack.optimize.UglifyJsPlugin`
*   Add [babel-react-optimize preset](https://github.com/thejameskyle/babel-react-optimize)

## New Findings

We'll post the timeline summaries below and we have screenshots of the actual timeline and bottom-up stacks in the repo: [https://github.com/footballradar/VueReactPerf/tree/master/results/v2](https://github.com/footballradar/VueReactPerf/tree/master/results/v2)

Interestingly the Chrome dev tools crashes when retrieving a 30s timeline for the Vue 500 game tests but doesn't for React 500 game tests. We captured 15 seconds instead and that was even more confusing as Vue has a lot more idle time than React.

All of the results below share a common theme: React performs more scripting work, as we would expect from its virtual DOM implementation, and Vue is heavier on painting and rendering as it touches the DOM directly. The key difference is that in terms of total work done, Vue _still_ appears to be faster by up to 25% in some cases. This is not the huge difference we originally reported but still noteworthy.
##### 50 games, 100ms delay between updates.
React:  
![](http://ww2.sinaimg.cn/large/a490147fgw1f4mtuj37onj207f04l74d.jpg)

Vue:  
![](http://ac-Myg6wSTV.clouddn.com/29bf60c3f146eab2c6dc.png)
##### 50 games, 1s delay between updates.
React:  
![](http://ac-Myg6wSTV.clouddn.com/b0b15f794c9a2070a533.png)

Vue:  
![](http://ac-Myg6wSTV.clouddn.com/f6d6c16641bcdbfdc6cb.png)
##### 100 games, 100ms delay between updates.
React:  
![](http://ac-Myg6wSTV.clouddn.com/72c40b5122614ecb66af.png)

Vue:  
![](http://ac-Myg6wSTV.clouddn.com/239e96ce2a5037dd7a9a.png)
##### 100 games, 1s delay between updates.
React:  
![](http://ac-Myg6wSTV.clouddn.com/902c1fe2a6c6d5d9671f.png)

Vue:  
![](http://ac-Myg6wSTV.clouddn.com/5490fb9635b763d94c05.png)
##### 500 games, 100ms delay between updates.
React:  
![](http://ac-Myg6wSTV.clouddn.com/352538cf119141efb387.png)

Vue:  
![](http://ac-Myg6wSTV.clouddn.com/20251f4ab6a45b138669.png)
##### 500 games, 1s delay between updates.
React:  
![](http://ac-Myg6wSTV.clouddn.com/04278f218752b89c2042.png)

Vue:  
![](http://ac-Myg6wSTV.clouddn.com/f6095bbea3543f55a175.png)

## Conclusion

Overall, the original claims about Vue's performance still hold some value _in this use case_ but there was clearly a lot of opportunity for optimisation - especially with React. One surprising take away is how much work and collective knowledge was required to bring out better performance from React, while Vue was fairly well optimised from the get-go. Whatever we can say about the relative performance of these two libraries, this is definitely a win for Vue's developer experience.

