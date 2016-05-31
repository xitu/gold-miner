>* 原文链接 : [Performance optimisations for React applications](https://medium.com/@alexandereardon/performance-optimisations-for-react-applications-b453c597b191#.cymwuepwo)
* 原文作者 : [Alex Reardon](https://medium.com/@alexandereardon)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:

![](http://ww2.sinaimg.cn/large/0060lm7Tgw1f47ucaolgzj31jk0lmtcc.jpg)

#### TLDR;

The main performance hotspot in React applications is redundant processing and DOM diffing in components. In order to avoid this return **false** from **shouldComponentUpdate** as high up in your application as you can.

To facilitate this:

1.  Make **shouldComponentUpdate** checks _fast_
2.  Make **shouldComponentUpdate** checks _easy_

#### Disclaimers!

The examples in this blog will be using React + Redux. If you are using another data-flow library the principles will apply but the implementation will be different.

I have not used an immutability library in this blog but only vanilla es6 and a little bit of es7\. A few things become easier when using an immutability library but I will not be discussing them here.

## What is the main performance hotspot in React applications?

1.  Redundant processing in components that do not update the DOM
2.  DOM diffing leaf nodes that do not need to be updated  
    - while DOM diffing is incredible and facilitates React, it is not trivial computationally

## What is the default render behaviour in React?

Let's take a look at how React renders components

#### Initial render

On the initial render we need the entire application to render  
(green = nodes that rendered)

![](http://ww2.sinaimg.cn/large/0060lm7Tgw1f47uc09colj318g0haacs.jpg)

Every node has rendered - this is good! Our application now represents our initial state

#### Proposed change

We want to update a piece of data. This change is only relevant to one leaf node

![](http://ww4.sinaimg.cn/large/0060lm7Tgw1f47ubbtpw1j318g0haju7.jpg)

#### Ideal update

We want to only render the nodes that are along the critical path to our leaf node

![](http://ww2.sinaimg.cn/large/0060lm7Tgw1f47ub7ewwsj318g0ha773.jpg)

#### Default behaviour

This is what React does if you do not tell it otherwise  
(orange = waste)

![](http://ww3.sinaimg.cn/large/0060lm7Tgw1f47ubiztaxj318g0hagoe.jpg)

Oh no! All of our nodes have rendered.

Every component in React has a **shouldComponentUpdate(nextProps, nextState)** function. It is the responsibility of this function to return **true** if the component should update and **false** if the component should not update. Returning **false** results in the components **render** function not being called at all. The default behaviour in React is that **shouldComponentUpdate** always returns **true**, even if you do not define a **shouldComponentUpdate** function explicitly.

    // default behaviour
    shouldComponentUpdate(nextProps, nextState) {
        return true;
    }

This means that by default every time you update your top level **props** every component in the whole application will **render**. This is a major performance problem.

## How do we get the ideal update?

Return **false** from **shouldComponentUpdate** as high up in your application as you can.

To facilitate this:

1.  Make **shouldComponentUpdate** checks _fast_
2.  Make **shouldComponentUpdate** checks _easy_

## Make shouldComponentUpdate checks fast

Ideally we do not want to be doing deep equality checks in our **shouldComponentUpdate** functions as they are expensive, especially at scale and with large data structures.

        class Item extends React.Component {
        shouldComponentUpdate(nextProps) {
          // expensive!
          return isDeepEqual(this.props, nextProps);
        }
        // ...
        }

An alternative approach is to _change an objects reference whenever it's value changes_.

        const newValue = {
        ...oldValue
        // any modifications you want to do
    };

    // fast check - only need to check references
    newValue === oldValue; // false

    // you can also use the Object.assign syntax if you prefer
    const newValue2 = Object.assign({}, oldValue);

    newValue2 === oldValue; // false

Using this technique in a Redux reducer:

    // in this Redux reducer we are going to change the description of an item
    export default (state, action) => {

        if(action.type === 'ITEM_DESCRIPTION_UPDATE') {

            const {itemId, description} = action;

            const items = state.items.map(item => {
                // action is not relevant to this item - we can return the old item unmodified
                if(item.id !== itemId) {
                  return item;
                }

                // we want to change this item
                // this will keep the 'value' of the old item but 
                // return a new object with an updated description
                return {
                  ...item,
                  description
                };
            });

            return {
              ...state,
              items
            };
        }

        return state;
    }

If you adopt this approach then all you need to do in your **shouldComponentUpdate** function is do reference checks

        // super fast - all you are doing is checking references!
    shouldComponentUpdate(nextProps) {
        return isObjectEqual(this.props, nextProps);
    }

Example implementation of **isObjectEqual**

        const isObjectEqual = (obj1, obj2) => {
        if(!isObject(obj1) || !isObject(obj2)) {
            return false;
        }

        // are the references the same?
        if (obj1 === obj2) {
           return true;
        }

       // does it contain objects with the same keys?
       const item1Keys = Object.keys(obj1).sort();
       const item2Keys = Object.keys(obj2).sort();

       if (!isArrayEqual(item1Keys, item2Keys)) {
            return false;
       }

       // does every object in props have the same reference?
       return item2Keys.every(key => {
           const value = obj1[key];
           const nextValue = obj2[key];

           if (value === nextValue) {
               return true;
           }

           // special case for arrays - check one level deep
           return Array.isArray(value) &&
               Array.isArray(nextValue) &&
               isArrayEqual(value, nextValue);
       });
    };

    const isArrayEqual = (array1 = [], array2 = []) => {
        if (array1 === array2) {
            return true;
        }

        // check one level deep
        return array1.length === array2.length &&
            array1.every((item, index) => item === array2[index]);
    };


## Make shouldComponentUpdate checks easy

Example of a _hard_ **shouldComponentUpdate**

        // Data structure with good separation of concerns (normalised data)
    const state = {
        items: [
            {
                id: 5,
                description: 'some really cool item'
            }
        ],

        // an object to represent the users interaction with the system
        interaction: {
            selectedId: 5
        }
    };

Structuring your data like this makes doing checks in your **shouldComponentUpdate** _hard_

        import React, {Component, PropTypes} from 'react';

    class List extends Component {

        propTypes = {
            items: PropTypes.array.isRequired,
            interaction: PropTypes.object.isRequired
        }

        shouldComponentUpdate (nextProps) {
            // have any of the items changed?
            if(!isArrayEqual(this.props.items, nextProps.items)){
                return true;
            }
            // everything from here is horrible.

            // if interaction has not changed at all then when can return false (yay!)
            if(isObjectEqual(this.props.interaction, nextProps.interaction)){
                return false;
            }

            // at this point we know:
            //      1\. the items have not changed
            //      2\. the interaction has changed
            // we need to find out if the interaction change was relevant for us

            const wasItemSelected = this.props.items.any(item => {
                return item.id === this.props.interaction.selectedId
            });
            const isItemSelected = nextProps.items.any(item => {
                return item.id === nextProps.interaction.selectedId
            });

            // return true when something has changed
            // return false when nothing has changed
            return wasItemSelected !== isItemSelected;
        }

        render() {
            <div>
                {this.props.items.map(item => {
                    const isSelected = this.props.interaction.selectedId === item.id;
                    return (<item item="{item}" isselected="{isSelected}">);
                })}
            </item></div>
        }
    }

#### Problem 1: huge **shouldComponentUpdate** functions

You can see how big and complex the **shouldComponentUpdate** is with a very simple data. This is because the function needs to know about the data structures and how they related to one another. The complexity and size of **shouldComponentUpdate** functions only grows as your data structure does. This can _easily_ lead to two errors:

1.  returning **false** when you should not (state is not correctly represented in the app)
2.  returning **true** when you should not (performance problem)

Why make things hard for yourself? You want these checks to be so easy that you do not need to really think about them.

#### Problem 2: tight coupling of parents to children

Generally applications want to promote loose coupling (components know as little about other components as possible). Parent components should have as little understanding as possible about how their children work. This allows you to change the children's behaviour without the parent needing to know about the change (assuming the **PropTypes** remain the same). It also allows children to operate in isolation without needing a parent to tightly control it's behaviour.

#### Fix: **Denormalize your data**

By denormalizing (merging) your data structure you can go back to just using really simple reference checks to see if anything has changed.

        const state = {
        items: [
            {
                id: 5,
                description: 'some really cool item',

                // interaction now lives on the item itself
                interaction: {
                    isSelected: true
                }
            }
        ]
    };

Structuring your data like this makes doing checks in your **shouldComponentUpdate** _easy_

        import React, {Component, PropTypes} from 'react';

    class List extends Component {

        propTypes = {
            items: PropTypes.array.isRequired
        }

        shouldComponentUpdate (nextProps) {
            // so easy
            return isObjectEqual(this.props, nextProps);
        }

        render() {
                <div>
                    {this.props.items.map(item => {

                        return (
                        <item item="{item}" isselected="{item.interaction.isSelected}">);
                    })}
                </item></div>
            }
    }

If you want to update the **interaction** you change the reference to the whole object

        // redux reducer
    export default (state, action) => {

        if(action.type === 'ITEM_SELECT') {

            const {itemId} = action;

            const items = state.items.map(item => {
                if(item.id !== itemId) {
                    return item;
                }

                // changing the reference to the whole object
                return {
                    ...item,
                    interaction: {
                        isSelected: true
                    }
                }

            });

            return {
              ...state,
              items
            };
        }

        return state;
    };


## Gotcha: reference checking and dynamic props

An example of creating dynamic props

        class Foo extends React.Component {
        render() {
            const {items} = this.props;

            // this object will have a new reference every time
            const newData = { hello: 'world' };

            return <item data="{newData}">
        }
    }

    class Item extends React.Component {

        // this will always return true as `data` will have a new reference every time
        // even if the objects have the same value
        shouldComponentUpdate(nextProps) {
            return isObjectEqual(this.props, nextProps);
        }
    }
    </item>

Usually we do not create new props inside a component to just pass it down. However, it is more prevalent to do this inside of loops

        class List extends React.Component {
        render() {
            const {items} = this.props;

            <div>
                {items.map((item, index) => {
                     // this object will have a new reference every time
                    const newData = {
                        hello: 'world',
                        isFirst: index === 0
                    };

                    return <item data="{newData}">
                })}
            </item></div>
        }
    }

This is commonly used when creating functions

    import myActionCreator from './my-action-creator';

    class List extends React.Component {
        render() {
            const {items, dispatch} = this.props;

            <div>
                {items.map(item => {
                     // this function will have a new reference every time
                    const callback = () => {
                        dispatch(myActionCreator(item));
                    }

                    return <item onupdate="{callback}">
                })}
            </item></div>
        }
    }

#### Strategies to overcome the issue
1\. Avoid creating dynamic props inside of components

improve your data model so that you can just pass props straight through

2\. Pass dynamic props as types that satisfy **===** equality

eg:  
- boolean  
- number  
- string

        const bool1 = true;
    const bool2 = true;

    bool1 === bool2; // true

    const string1 = 'hello';
    const string2 = 'hello';

    string1 === string2; // true

If you really do need to pass in a dynamic object you could pass a string representation of the object that could be deconstructed in the child

        render() {
        const {items} = this.props;

        <div>
            {items.map(item => {
                // will have a new reference every time
                const bad = {
                    id: item.id,
                    type: item.type
                };

                // equal values will satify strict equality '==='
                const good = `${item.id}::${item.type}`;

                return <item identifier="{good}">
            })}
        </item></div>
    }

1.  Do not pass functions if you can avoid it. Rather, let the child **dispatch** actions when it wants to. This has the added advantage of moving business logic out of components.
2.  Ignore functions in your **shouldComponentUpdate** check. This is not ideal as it won't be able to know if the value of the function changes.
3.  Create a map of **data -> function** that does not change. You could put these in **state** in your **componentWillReceiveProps** function. That way each render would not get a new reference. This method is extremely heavy handed as you need to maintain and update a list of functions.
4.  Create a middle component with the correct this binding. This is also not ideal as you introduce a redundant layer into your hierarchy
5.  Anything else you can think of that avoids creating a new function every time **render** is called!

Example of strategy #4

        // introduce another layer 'ListItem'
    <list>
        <listitem> // you can create the correct this bindings in here
            <item>
        </item></listitem>
    </list>

    class ListItem extends React.Component {

        // this will always have the correct this binding as it is tied to the instance
        // thanks es7!
        const callback = () => {
              dispatch(doSomething(item));
        }

        render() {
            return <item callback="{this.callback}" item="{this.props.item}">
        }
    }
    </item>

</div>

</div>

</section>

<section score="41.25">

<div score="32.5">

<div score="11.5">

## Tooling

All of the rules and techniques listed above were found by using performance measuring tools. Using tools will help you find performance hotspots specific to your application.

This one is fairly simple:

1.  start a timer
2.  do stuff
3.  stop the timer

A great way to do this is with a Redux middleware:

    export default store => next => action => {
        console.time(action.type);

        // `next` is a function that takes an 'action' and sends it through to the 'reducers'
        // this will result in a re-render of your application
        const result = next(action);

        // how long did the render take?
        console.timeEnd(action.type);

        return result;
    };

Using this method you can record the time taken for every action and its resulting render in your application. You can quickly see what actions take the longest amount of time to render which gives you a good place to start when addressing performance concerns. Having time values also helps you to see the what difference your changes are making to your application.

This one uses the same idea as **console.time** but uses the React performance utility tools:

1.  Perf.start()
2.  do stuff
3.  Perf.stop

Example Redux middleware:

        import Perf from 'react-addons-perf';

    export default store => next => action => {
        const key = `performance:${action.type}`;
        Perf.start();

        // will re-render the application with new state
        const result = next(action);
        Perf.stop();

        console.group(key);
        console.info('wasted');
        Perf.printWasted();
        // any other Perf measurements you are interested in

        console.groupEnd(key);
        return result;
    };

Similar to the **console.time** method this will let you see performance metrics for each of your actions. For more information on the React performance addon [see here](https://facebook.github.io/react/docs/perf.html)

CPU profiler flame charts can also be helpful in finding performance problems in your applications.

> The Flame Chart shows you the state of the JavaScript stack for your code at every millisecond during the performance profile. This gives you a way to know exactly which function was executing at any point during the recording, how long it ran for, and where it was called from - Mozilla

Firefox: [see here](https://developer.mozilla.org/en-US/docs/Tools/Performance/Flame_Chart)

Chrome: [see here](https://addyosmani.com/blog/devtools-flame-charts/)

</div>

</div>

</section>

<section score="41.25">

<div score="31.25">

<div>

Thanks for reading and all the best in making highly performant React apps!

</div>

</div>

</section>

</div>

</div>
