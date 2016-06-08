>* 原文链接 : [Performance optimisations for React applications](https://medium.com/@alexandereardon/performance-optimisations-for-react-applications-b453c597b191#.cymwuepwo)
* 原文作者 : [Alex Reardon](https://medium.com/@alexandereardon)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:

![](http://ww2.sinaimg.cn/large/0060lm7Tgw1f47ucaolgzj31jk0lmtcc.jpg)

#### 要点梗概

React 应用主要的性能问题在于多余的处理和组件的 DOM 比对。为了避免这些性能陷阱，你应该尽可能的在 **shouldComponentUpdate** 中返回 **false** 。


简而言之，归结于如下两点：

1.  _加速_ **shouldComponentUpdate** 的检查
2.  _简化_ **shouldComponentUpdate** 的检查

#### 免责声明！

文章中的示例是用 React + Redux 写的。如果你用的是其它的数据流库，原理是相通的但是实现会不同。

在文章中我没有使用 immutability (不可变)库，只是一些普通的 es6 和一点 es7。有些东西用不可变数据库要简单一点，但是我不准备在这里讨论这一部分内容。

## React 应用的主要性能问题是什么？

1.  组件中那些不更新 DOM 的冗余操作
2.  DOM 比对那些无须更新的叶子节点  
    - 虽则 DOM 比对很出色并加速了 React ，但计算成本是不容忽视的

## React 默认的渲染行为是怎样的？

我们来看一下 React 是如何渲染组件的。

#### 初始化渲染

在初始化渲染时，我们需要渲染整个应用  
（绿色 ＝ 已渲染节点）

![](http://ww2.sinaimg.cn/large/0060lm7Tgw1f47uc09colj318g0haacs.jpg)

每一个节点都被渲染 —— 这很赞！我们的应用现在呈现了我们的初始状态。

#### 提出改变

我们想更新一部分数据。这些改变只和一个叶子节点相关

![](http://ww4.sinaimg.cn/large/0060lm7Tgw1f47ubbtpw1j318g0haju7.jpg)

#### 理想更新

我们只想渲染通向叶子节点路径上的这几个节点

![](http://ww2.sinaimg.cn/large/0060lm7Tgw1f47ub7ewwsj318g0ha773.jpg)

#### 默认行为

如果你不告诉 React 别这样做，它便会如此  
（橘黄色 ＝ 浪费的渲染）

![](http://ww3.sinaimg.cn/large/0060lm7Tgw1f47ubiztaxj318g0hagoe.jpg)

哦，不！我们所有的组件都重渲了。

React 的每一个组件都有一个 **shouldComponentUpdate(nextProps, nextState)** 函数。它的职责是当组件需要更新时返回 **true** ， 而组件不必更新时则返回 **false** 。返回 **false** 会导致组件的 **render** 函数不被调用。React 总是默认在 **shouldComponentUpdate** 中返回 **true**，即便你没有显示地定义一个 **shouldComponentUpdate** 函数。

```javascript
// 默认行为
shouldComponentUpdate(nextProps, nextState) {
    return true;
}
```

这就意味着在默认情况下，你每次更新你的顶层级的 **props**，整个应用的每一个组件都会渲染。这是一个主要的性能问题。

## 我们如何获得理想的更新？

尽可能的在 **shouldComponentUpdate** 中返回 **false** 。

简而言之：

1.  _加速_ **shouldComponentUpdate** 的检查
2.  _简化_ **shouldComponentUpdate** 的检查

## 加速 shouldComponentUpdate 检查

理想情况下我们不希望在 **shouldComponentUpdate** 中做深等（也叫全等，相对于shallow equality(弱等，浅等)）检查，因为这非常昂贵，尤其是在大规模和拥有大的数据结构的时候。

```javascript
class Item extends React.component {
    shouldComponentUpdate(nextProps) {
      // 这很昂贵
      return isDeepEqual(this.props, nextProps);
    }
    // ...
}
```

一个替代方法是_只要对象的值发生了变化，就改变对象的引用_。

```javascript
const newValue = {
    ...oldValue
    // 在这里做你想要的修改
};

// 快速检查 —— 只要检查引用
newValue === oldValue; // false

// 如果你愿意也可以用 Object.assign 语法
const newValue2 = Object.assign({}, oldValue);

newValue2 === oldValue; // false
```

在 Redux reducer 中使用这个技巧：

```javascript
// 在这个 Redux reducer 中，我们将改变一个 item 的 description
export default (state, action) {

    if(action.type === 'ITEM_DESCRIPTION_UPDATE') {

        const { itemId, description } = action;

        const items = state.items.map(item => {
            // action 和这个 item 无关 —— 我们可以不作修改直接返回这个 item
            if(item.id !== itemId) {
              return item;
            }

            // 我们想改变这个 item
            // 这会保留原本 item 的值，但
            // 会返回一个更新过 description 的新对象
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
```

如果你采用这个方法，那你只需在 **shouldComponentUpdate** 函数中作引用检查

```javascript
// 超级快 —— 你所做的只是检查引用！
shouldComponentUpdate(nextProps) {
    return isObjectEqual(this.props, nextProps);
}
```

**isObjectEqual** 的一个实现示例

```javascript
const isObjectEqual = (obj1, obj2) => {
    if(!isObject(obj1) || !isObject(obj2)) {
        return false;
    }

    // 引用是否相同
    if(obj1 === obj2) {
        return true;
    }

    // 它们包含的键名是否一致？
    const item1Keys = Object.keys(obj1).sort();
    const item2Keys = Object.keys(obj2).sort();

    if(!isArrayEqual(item1Keys, item2Keys)) {
        return false;
    }

    // 属性所对应的每一个对象是否具有相同的引用？
    return item2Keys.every(key => {
        const value = obj1[key];
        const nextValue = obj2[key];

        if(value === nextValue) {
            return true;
        }

        // 数组另外 —— 检查一个层级深度
        return Array.isArray(value) && 
            Array.isArray(nextValue) && 
            isArrayEqual(value, nextValue);
    });
};

const isArrayEqual = (array1 = [], array2 = []) => {
    if(array1 === array2) {
        return true;
    }

    // 检查一个层级深度
    return array1.length === array2.length &&
        array1.every((item, index) => item === array2[index]);
};
```


## 简化 shouldComponentUpdate 检查

先看一个_复杂_的 **shouldComponentUpdate** 示例

```javascript
// 关注分离的数据结构（标准化数据）
const state = {
    items: [
        {
            id: 5,
            description: 'some really cool item'
        }
    ]

    // 表示用户与系统交互的对象
    interaction: {
        selectedId: 5
    }
};
```

这样组织你的数据，会使得在 **shouldComponentUpdate** 变的_困难_

```javascript
import React, { Component, PropTypes } from 'react'

class List extends Component {

    propTypes = {
        items: PropTypes.array.isRequired,
        iteraction: PropTypes.object.isRequired
    }

    shouldComponentUpdate (nextProps) {
        // items 中的元素是否发生了改变？
        if(!isArrayEqual(this.props.items, nextProps.items)) {
            return true;
        }

        // 从这里开始事情会变的很恐怖

        // 如果 interaction 没有变化，那可以返回 false （真棒！）
        if(isObjectEqual(this.props.interaction, nextProps.interaction)) {
            return false;
        }

        // 如果代码运行到这里，我们知道：
        //    1. items 没有变化
        //    2. interaction 变了
        // 我们需要 interaction 的变化是否与我们相干

        const wasItemSelected = this.props.items.any(item => {
            return item.id === this.props.interaction.selectedId
        })
        const isItemSelected = nextProps.items.any(item => {
            return item.id === nextProps.interaction.selectedId
        })

        // 如果发生了改变就返回 true
        // 如果没有发生变化就返回 false
        return wasItemSelected !== isItemSelected;
    }

    render() {
        <div>
            {this.props.items.map(item => {
                const isSelected = this.props.interaction.selectedId === item.id;
                return (<Item item={item} isSelected={isSelected} />);
            })}
        </div>
    }
}
```

#### 问题1：**shouldComponentUpdate** 体积庞大

你可以看出一个非常简单的数据对应的 **shouldComponentUpdate** 即庞大又复杂。这是因为它需要知道数据的结构以及它们之间的关联。**shouldComponentUpdate** 函数的复杂度和体积只随着你的数据结构增长。这_很容易_导致两点错误：

1.  在不应该返回 **false** 的时候返回 **false**（应用显示错误的状态）
2.  在不应该返回 **true** 的时候返回 **true**（引发性能问题）

为什么要让事情变得这么复杂？你只想让这些检查变得简单一点，以至于你根本就不必考虑它们。

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
    
#### Special case: functions

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

## Tooling

All of the rules and techniques listed above were found by using performance measuring tools. Using tools will help you find performance hotspots specific to your application.

#### console.time

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

#### React.perf

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

#### Browser tools

CPU profiler flame charts can also be helpful in finding performance problems in your applications.

> The Flame Chart shows you the state of the JavaScript stack for your code at every millisecond during the performance profile. This gives you a way to know exactly which function was executing at any point during the recording, how long it ran for, and where it was called from - Mozilla

Firefox: [see here](https://developer.mozilla.org/en-US/docs/Tools/Performance/Flame_Chart)

Chrome: [see here](https://addyosmani.com/blog/devtools-flame-charts/)

Thanks for reading and all the best in making highly performant React apps!
