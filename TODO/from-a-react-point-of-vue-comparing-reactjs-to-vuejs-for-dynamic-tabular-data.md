>* 原文链接 : ["From a React point of Vue..." - comparing React.js to Vue.js for dynamic tabular data](https://engineering.footballradar.com/from-a-react-point-of-vue-comparing-reactjs-to-vuejs-for-dynamic-tabular-data/)
* 原文作者 : [Max Willmott](https://engineering.footballradar.com/author/max-willmott/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:



##### Update

So I'd left React in development mode. A number of suggestions have been made and merged in. The PR is worth a read as it goes through what went wrong and has some results once corrected; [https://github.com/footballradar/VueReactPerf/pull/3](https://github.com/footballradar/VueReactPerf/pull/3).

For part 2 of these tests, please visit: [https://engineering.footballradar.com/a-fairer-vue-of-react-comparing-react-to-vue-for-dynamic-tabular-data-part-2/](https://engineering.footballradar.com/a-fairer-vue-of-react-comparing-react-to-vue-for-dynamic-tabular-data-part-2/)

##### Intro

The aim of this post is to observe the differences between [React](https://facebook.github.io/react/) and [Vue](https://vuejs.org/) as view layers. The scenario is a page which has a table of nested, frequently-updating data with a fixed number of rows. This nicely represents some of the problems we face on the front-end at Football Radar. We don’t need to know too much about React or Vue to accomplish this, although we are much more experienced with React than we are with Vue.

You can check out the code on our GitHub - [https://github.com/footballradar/VueReactPerf](https://github.com/footballradar/VueReactPerf).

The output of both view libs will look like this:  
![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-21-at-15-02-07.png)

##### The Test

We’ll run each solution with 50 games. Each game updates once a second and will at a minimum increment its clock and one player cell. Other properties are randomly and independently updated. Once each game has kicked off we’ll start a timeline recording for 30 seconds. I’ll dump a screenshot of my laptop's spec for clarification:  
![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-13-33-07.png)

##### The Data

Our dataset is an array of 5-a-side football games. Each game updates once a second and we’ll allow for a variable number of games. We won’t go into too much detail about how we’re generating the data but if you’re curious check out our `src/react.data.js` and `src/vue.data.js` in the [GitHub repo](https://github.com/footballradar/VueReactPerf).

This is the structure of the Game object

*   clock
*   score

   *   home
   *   away

*   teams

   *   home
   *   away

*   outrageousTackles
*   cards

   *   yellow
   *   red

*   players
    *   name
    *   effortLevel
    *   invitedNextWeek

We need to expose our data with our view layer in mind. Whilst the generation of the data will remain the same for React and Vue, there are slight differences.

*   Immutable.js for React - This lets us implement `shouldComponentUpdate` to easily to optimise our renders.
*   Expose data as an Observable for React - By subscribing to our data source we can then update React via `setState()`.
*   Expose data as POJO with getters for Vue - Vue reacts to changes to our state by hooking into the getters. Due to this we need to expose and update our state as a mutable object.

##### React Implementation

To create the view above we ended up with 4 components:

*   `App` - subscribes to the data source and `setState` with the latest data
*   `Games` - Rendered by `App`, taking the array of Games
*   `Game` - A row rendered by `Games`, taking a Game Map
*   `Player` - A cell rendered by `Game`, taking the Player Map

Any time there is nested data we can gain the advantage of Immutable reference checking by creating a sub component for it and implement `shouldComponentUpdate`. In this case we’ve done it for the `Game` and `Player` component:

    shouldComponentUpdate(nextProps){
        return nextProps.game !== this.props.game;
    }

Considering all we’re doing is accessing a property in the `Game` Map then displaying it, there shouldn’t be much need to create a sub component for scores, teams and cards.

Here are the first results from the React implementation:

_Summary:_ ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-13-58-26.png) _Bottom-up:_ ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-13-59-00.png) _Timeline:_ ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-14-07-19.png)

Roughly 10% of the browser's time was spent scripting. When it wasn’t idle it was mostly scripting, hence the spikes in the timeline being mostly yellow. We can make sure the time was spent in React and not our data generation by looking at the heaviest stack window:  
![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-13-59-34-1.png)

Since we have nothing to compare this to there’s not much to say at this point. When we first ran this test I had forgotten to put the `shouldComponentUpdate` on the `Game` component and the difference was huge:  
![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-21-at-15-16-02-1.png)

3 lines of JavaScript reduced the work by 5 times. Anyway moving onto our Vue version.

##### Vue Implementation

At first I wasn’t sure about using Immutable.js with Vue since it relies on hooking into the getters/setters of plain JavaScript Objects. Whilst this is cool I still want to use Immutable in my data generation as it forces consistency when updating data and reduces bugs caused by side effects.

My first attempt really buggered up the timeline. Even though I recorded 30 seconds I would only get between 5 and 20 seconds of results. I realised this was due to the page using the entire timeline buffer in ~15 seconds! So I’ll just print the results of the first 10 seconds.  
![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-21-at-17-38-04.png)

In 10 seconds, 2 were spent scripting. That isn’t very good. Vue was spending its time recreating each component as the data was a new reference each time, which is the point of using Immutable.js. So we’ll scrap this approach, it’s not how Vue was designed to work anyway but we’re coming from a React perspective here.

We changed the data structure so we’re just exposing a POJO of state then passing this directly to the Vue instance. All updates to games are on the same object so the reference is the same; the complete opposite to what we were doing for React. This wasn’t much of a code change however. Once we had stripped away Immutable.js, all we needed to do was expose the games:

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

Once that was sorted we ran the test and the results are insane:

_Summary - Vue:_ ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-14-01-40.png) _Summary - React:_ ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-13-58-26-1.png)

The first image is Vue, the second is the React summary from earlier. Look at that circle. So much idle. I had to run this test and the React one many, many times to make sure this was legit.

_Bottom-up - Vue:_ ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-14-02-17.png) _Bottom-up - React:_ ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-13-59-00-1.png)

We can see here that Vue spends much less time in itself compared to React. This is down to how each component handles its data and updates.

_Heaviest stack - Vue:_ ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-14-04-19.png) _Heaviest stack - React:_ ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-13-59-34.png)

_Timeline - Vue:_ ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-14-05-11.png) _Timeline - React:_ ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-14-07-19-1.png)

I thought this was pretty telling too. Significantly less yellow on the Vue timeline. The memory seems pretty good too. Although it is creeping up, maybe indicating some issue in my data generation.

Okay cool so this is awesome but we evidently have some room to experiment. What happens when we scale up to 100 games? We’ll have to leave the page for a bit to let each game “kickoff”.

_Summary - Vue:_ ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-13-50-29.png) _Summary - React:_ ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-13-53-55.png)

Our Vue implementation handles the load much better than our React one, which has spent over 3 times the amount of time scripting than with 50 games (half the games).

Not sure what’s gonna happen but let’s try 500 games, I’ll only record 15secs here (if we don’t kill the timeline buffer…)

_Summary - Vue:_ ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-14-20-38.png) _Summary - React:_ ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-14-36-14.png)

_Bottom-up - Vue:_ ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-14-21-14.png) _Bottom-up - React:_ ![](https://engineering.footballradar.com/content/images/2016/05/Screen-Shot-2016-05-23-at-14-36-33.png)

To be honest I’m surprised I could record 15 seconds of timeline for the React version. In fact it seemed to take up a lot less of the timeline buffer than the Vue implementation. The React page was unusable, taking ~10seconds to update the clock by 1 second. The Vue page didn’t fare much better but for different reasons, it’s pretty nice to see the painting time take longer than the scripting time. I could still highlight the rows and the updates weren’t in spikes, just behind.

##### Conclusion

I’m pretty shocked by these results, I didn’t know whether Vue would be better at all, let alone by this much. These aren’t perfect tests but they are constructed around a real world problem where we don’t/can’t have the perfect solution.

The takeaway is that Vue handles frequent changes to existing elements/data much better than React, and I believe this is due to its [reactivity](https://vuejs.org/guide/reactivity.html) system.

Cheers for reading.

[https://github.com/footballradar/VueReactPerf](https://github.com/footballradar/VueReactPerf)

