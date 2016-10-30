>* 原文链接 : [Performance optimisations for React applications](https://medium.com/@alexandereardon/performance-optimisations-for-react-applications-b453c597b191#.cymwuepwo)
* 原文作者 : [Alex Reardon](https://medium.com/@alexandereardon)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [woota](https://github.com/woota)
* 校对者: [malcolmyu](https://github.com/malcolmyu), [Zheaoli](https://github.com/Zheaoli)

# React 应用的性能优化之路

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

每一个节点都被渲染 —— 这很赞！现在我们的应用呈现了我们的初始状态。

#### 提出改变

我们想更新一部分数据。这些改变只和一个叶子节点相关

![](http://ww4.sinaimg.cn/large/0060lm7Tgw1f47ubbtpw1j318g0haju7.jpg)

#### 理想更新

我们只想渲染通向叶子节点的关键路径上的这几个节点

![](http://ww2.sinaimg.cn/large/0060lm7Tgw1f47ub7ewwsj318g0ha773.jpg)

#### 默认行为

如果你不告诉 React 别这样做，它便会如此  
（橘黄色 ＝ 浪费的渲染）

![](http://ww3.sinaimg.cn/large/0060lm7Tgw1f47ubiztaxj318g0hagoe.jpg)

哦，不！我们所有的节点都被重新渲染了。

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

理想情况下我们不希望在 **shouldComponentUpdate** 中做深等检查，因为这非常昂贵，尤其是在大规模和拥有大的数据结构的时候。

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

        // 数组例外，再检查一个层级的深度
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

如果这样组织你的数据，会使得在 **shouldComponentUpdate** 中进行检查变得_困难_

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

#### 问题2：父子级之间强耦合

通常而言，应用都要推广松耦合（组件对其它的组件知道的越少越好）。父组件应该尽量避免知晓其子组件的工作原理。这就允许你改变子组件的行为而无须让父级知晓这些变化（假设 **PropsTypes** 保持不变）。它还允许子组件独立运转，而不必让父级紧密的控制其行为。

#### 解决办法：**压平你的数据**

通过压平（合并）你的数据结构，你可以重新使用非常简单的引用检查来看是否有什么发生了变化。

```javascript
const state = {
    items: [
        {
            id: 5,
            description: 'some really cool item',

            // interaction 现在存在于 item 的内部
            interaction: {
                isSelected: true
            }
        }
    }
};
```

这样组织你的数据使得在 **shouldComponentUpdate** 中做检查变得_简单_

```javascript
import React, {Component, PropTypes} from 'react'

class List extends Component {

    propTypes = {
        items: PropTypes.array.isRequired
    }

    shouldComponentUpdate(nextProps) {
        // so easy，麻麻再也不用担心我的更新检查了
        return isObjectEqual(this.props, nextProps);
    }

    render() {
        <div>
            {this.props.items.map(item => {

                return (
                <Item item={item}
                    isSelected={item.interaction.isSelected} />)
            })}
        </div>
    }
}
```

如果你想要更新 **interaction** 你就改变整个对象的引用

```javascript
// redux reducer
export default (state, action) => {

    if(action.type === 'ITEM_SELECT') {

        const { itemId } = action;

        const items = state.items.map(item => {
            if(item.id !== itemId) {
                return item;
            }

            // 改变整个对象的引用
            return {
                ...item,
                interaction: {
                    isSelected: true
                }
            }
        })

        return {
            ...state,
            items
        };
    }

    return state;
};
```


## 误区：引用检查与动态 props

一个创建动态 props 的例子

```javascript
class Foo extends React.Component {
    render() {
        const {items} = this.props;

        // 这个对象每次都有一个新的引用
        const newData = { hello: 'world' };


        return <Item name={name} data={newData} />
    }
}

class Item extends React.Component {

    // 即便前后两个对象的值相同，检查也总会返回true，因为 `data` 每次都会得到一个新的引用
    shouldComponentUpdate(nextProps) {
        return isObjectEqual(this.props, nextProps);
    }
}
```

通常我们不会在组件中创建一个新的 props 把它传下来 。但是，这在循环中更为常见

```javascript
class List exntends React.Component {
    render() {
        const {items} = this.props;

        <div>
            {items.map((item, index) => {
                // 这个对象每次都会获得一个新引用
                const newData = {
                    hello: 'world',
                    isFirst: index === 0
                };


                return <Item name={name} data={newData} />
            })}
        </div>
    }
}
```

这在创建函数时很常见

```javascript
import myActionCreator from './my-action-creator';

class List extends React.Component {
    render() {
        const {items, dispatch} = this.props;

        <div>
            {items.map(item => {
                // 这个函数的引用每次都会变
                const callback = () => {
                    dispatch(myActionCreator(item));
                }

                return <Item name={name} onUpdate={callback} />
            })}
        </div>
    }
}
```

#### 解决问题的策略

1.  避免在组件中创建动态的 props

改善你的数据模型，这样你就可以直接把 props 传下来

2.  把动态 props 转化成满足全等（**===**）的类型传下来

eg:  
- boolean  
- number  
- string

```javascript
const bool1 = true;
const bool2 = true;

bool1 === bool2; // true

const string1 = 'hello';
const string2 = 'hello';

string1 === string2; // true
```

如果你实在需要传递动态对象，那就把它当作字符串传下来，再在子级进行解构

```javascript
render() {
    const {items} = this.props;

    <div>
        {items.map(item => {
            // 每次获得新引用
            const bad = {
                id: item.id,
                type: item.type
            };

            // 相同的值可以满足严格的全等 '==='
            const good = `${item.id}::${item.type}`;

            return <Item identifier={good} />
        })}
    </div>
}
```
    
#### 特殊情况：函数

1.  如果可以的话，尽量避免传递函数。相反，让子组件自由的 **dispatch** 动作。这还有个附加的好处就是把业务逻辑移出组件。
2.  在 **shouldComponetUpdate** 中忽略函数检查。这样不是很理想，因我们不知道函数的值是否变化了。
3.  创建一个 **data -> function** 的不可变绑定。你可以在 **componentWillReceiveProps** 函数中把它们存到 **state** 中去。这样就不会在每一次 render 时拿到新的引用。这个方法极度笨重，因为你须要维护和更新一个函数列表。
4.  创建一个拥有正确 this 绑定的中间组件。这也不够理想，因为你在层级中引入了一个冗余层。
5.  任何其它你能够想到的、能够避免每次 **render** 调用时创建一个新函数的方法。

方案4 的示例

```javascript
// 引入另外一层 'ListItem'
<List>
    <ListItem> // 你可以在这里创建正确的 this 绑定
        <Item />
    </ListItem>
</List>

class ListItem extends React.Component {

    // 这样总能得到正确的 this 绑定，因为它绑定在了实例上
    // 感谢 es7！
    const callback = () => {
        dispatch(doSomething());
    }

    render() {
        return <Item callback={this.callback} item={this.props.item} />
    }
}
```

## 工具

以上列出来的所有规则和技巧都是通过使用性能测量工具发现的。使用工具可以帮助你发现你的应用的具体性能问题所在。

#### console.time

这一个相当简单：

1.  开始一个计时器
2.  做点什么
3.  停止计时器

一个比较好的做法是使用 Redux 中间件：

```javascript
export default store => next => action => {
    console.time(action.type)

    // `next` 是一个函数，它接收 'action' 并把它发送到 ‘reducers' 进行处理
    // 这会导致你应有的一次重渲
    const result = next(action);

    // 渲染用了多久？
    console.timeEnd(action.type);

    return result;
};
```

用这个方法可以记录你应用的每一个 action 和它引起的渲染所花费的时间。你可以快速知道哪些 action 渲染时间最长，这样当你解决性能问题时就可以从那里着手。拿到时间值还能帮助你判断你所做的性能优化是否奏效了。

#### React.perf

这个工具的思路和 **console.time** 是一致的，只不过用的是 React 的性能工具：

1.  Perf.start()
2.  do stuff
3.  Perf.stop()

Redux 中间件示例：

```javascript
import Perf from 'react-addons-perf';

export default store => next => action => {
    const key = `performance:${action.type}`;
    Perf.start();

    // 拿到新的 state 重渲应用
    const result = next(action);
    Perf.stop();

    console.group(key);
    console.info('wasted');
    Perf.printWasted();
    // 你可以在这里打印任何你感兴趣的 Perf 测量值

    console.groupEnd(key);
    return result;
};
```

与 **console.time** 方法类似，它能让你看到你每一个 action 的性能指标。更多关于 React 性能 addon 的信息请点击[这里](https://facebook.github.io/react/docs/perf.html)

#### 浏览器工具

CPU 分析器火焰图表在寻找你的应用程序的性能问题时也能发挥作用。

> 在做性能分析时，火焰图表会展示出每一毫秒你的代码的 Javascript 堆栈的状态。在记录的时候，你就可以确切地知道任意时间点执行的是哪一个函数，它执行了多久，又是谁调用了它。—— Mozilla

Firefox: [点击查看](https://developer.mozilla.org/en-US/docs/Tools/Performance/Flame_Chart)

Chrome: [点击查看](https://addyosmani.com/blog/devtools-flame-charts/)

感谢阅读，祝你顺利构建出高性能的 React 应用！
