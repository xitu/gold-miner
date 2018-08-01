> * 原文地址：[I created the exact same app in React and Vue. Here are the differences.](https://medium.com/javascript-in-plain-english/i-created-the-exact-same-app-in-react-and-vue-here-are-the-differences-e9a1ae8077fd)
> * 原文作者：[Sunil Sandhu](https://medium.com/@sunilsandhu?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/i-created-the-exact-same-app-in-react-and-vue-here-are-the-differences.md](https://github.com/xitu/gold-miner/blob/master/TODO1/i-created-the-exact-same-app-in-react-and-vue-here-are-the-differences.md)
> * 译者：[jonjia](https://github.com/jonjia)
> * 校对者：

# 用 React 和 Vue 创建了两个完全相同的应用后，发现了这些差异

在工作中使用 Vue 一段时间后，对它的工作原理有了相当深入的了解。然而，我很想知道篱笆另一边的草地是什么样 - React。

我已经阅读了 React 文档并观看了一些教程视频，虽然它们很棒，但我真正想知道的是 React 与 Vue 到底有什么不同。这里的「不同」不是指它们是否具有虚拟 DOM 或者它们如何渲染页面。我希望有人能直接解释代码并告诉我会发生什么！我想找到一篇能解释这些差异的文章，那样 Vue、React (或者 Web 开发)的新手就可以更好地理解两者之间的差异了。

但我找不到任何解决这个问题的资源。所以我意识到必须靠自己来解决这个问题以便看到它们之间的相似之处和不同之处。在这样做时，我想我会记录整个过程，所以最终就有了这样一篇文章。

![](https://cdn-images-1.medium.com/max/800/1*ubWUG5LqQ0ak6wvFJtexHA.png)

你 pick 谁？

我决定构建一个标准的 Todo 列表应用，允许用户添加、删除列表中的项目。两个应用都使用默认的 CLI (React 的 create-react-app，Vue 的 vue-cli) 来构建。顺便说一下，CLI 表示命令行界面。🤓

### 因为这篇文章的篇幅已经超出了我的预期，所以让我们首先快速了解下这两个应用：

![](https://cdn-images-1.medium.com/max/2000/1*mJ-qdNqldpgae2U5oS0qDg.png)

Vue vs React：势均力敌

两个应用的 CSS 代码完全相同，但这些代码的位置不同。为了说明这一点，我们先看看两个应用的文件结构，如下：

![](https://cdn-images-1.medium.com/max/800/1*rahCwWEIXM7Wblk4L9ExYA.png)

你 pick 谁？

可以发现，它们的结构几乎相同。唯一不同是：React 应用有 3 个 CSS 文件；Vue 应用一个也没有。这样做的原因是：在 create-react-app 中，每个 React 组件都会附带一个样式文件来保存其样式；而 Vue CLI 采取单文件组件，每个组件的样式都会在组件内部声明。

最终，它们都达到了同样目的，也没有什么会阻止你在 React 或 Vue 中以不同方式构建自己的 CSS。这完全取决于个人便好 - 你会听到社区中关于如何构建 CSS 的大量讨论。现在，我们会遵循两个 CLI 中列出的结构。

但在进一步讨论之前，让我们先看看典型的 Vue 和 React 组件是什么样的：

![](https://cdn-images-1.medium.com/max/1000/1*yQS8va-QXM2poiP-RqasOw.png)

左边是 Vue 组件，右边是 React 组件。

现在开始，让我们深入了解细节吧！

### **如何改变数据？**

首先，「改变数据」是什么意思？听起来有些技术含量不是吗？它基本上表示改变我们存储的数据。因此，如果我们想将一个人的名字从 John 改为 Mark，我们就会「改变数据」。这是 React 和 Vue 之间的关键区别所在。Vue 本质上创建了一个数据对象，其中的数据可以自由更新；而 React 创建了一个状态对象，就需要更多的工作来完成更新。React 有充分的理由要求额外的工作，我们会稍微介绍一下。但首先，让我们看一下 Vue 中的 **data** 对象和 React 中的 **state** 对象：

![](https://cdn-images-1.medium.com/max/600/1*b9BjPHgneHv2K6ZYlAoe8A.png)

![](https://cdn-images-1.medium.com/max/600/1*asy_vlGoZgtA3sAA7Dw4CA.png)

左边是 Vue data 对象，右边是 React state 对象。

你可以看到我们给两个对象传递了相同的数据，只是标识符不同。将初始数据传给我们组件的方式非常相似。但正如上面提到的，如何改变这些数据在两个框架之间会有所不同。

假设有一个名为 name 的数据元素，它的值是：爱贝睿技术团队。

在 Vue 中，我们通过 `this.name`** 来引用它。也可以通过 `this.name = '爱贝睿'` 来更新它。这会把我们的名字改为「爱贝睿」。正是我们公司的名字，但修改确实成功了。:)

在 React 中，我们需要通过 `this.state.name` 来引用相同的数据。现在关键区别在于我们不能简单地通过 `this.state.name = '爱贝睿'`，因为 React 内部机制会防止这种简单、轻易的改变。所以在 React 中，我们会通过 `this.setState({ name: '爱贝睿' })` 来更新数据。

虽然这和我们在 Vue 中的方法都能实现相同目的，但 React 内部为防止我们意外地覆盖 `this.state` 有一些额外代码，`this.state` 和 `this.setState` 之间区别明显。有些理由说明了为什么 React 改变数据的方式与 Vue 不同，[Revanth Kumar](https://medium.com/@revanth0212) 的解释如下：

> 这是因为 React 希望在状态发生变化时重新执行某些生命周期方法，如 componentWillReceiveProps、shouldComponentUpdate、componentWillUpdate、render 和 componentDidUpdate。当你调用 setState 方法时，它会很快知道状态发生了改变。如果你直接修改 state，React 需要做更多工作来跟踪修改以及重新运行生命周期方法等等。所以为了简单起见，React 使用 setState 方法。

![](https://cdn-images-1.medium.com/max/800/1*IugEwe6Lkm5iFB-Q9zvc5w.jpeg)

肖恩·宾很有经验（Sean Bean：《指环王：护戒使者》中博罗米尔扮演者，其中台词 “One does not simply walk into Mordor（魔多不是你想去就能去的），此处为：this.state 不是你想用就能用的）

现在我们已经知道如何改变数据，然后来看看如何在 Todo 列表应用中添加新项目。

### **如何添加一个新的 Todo 项？**

#### **React**：

```
createNewToDoItem = () => {
    this.setState( ({ list, todo }) => ({
      list: [
          ...list,
        {
          todo
        }
      ],
      todo: ''
    })
  );
};
```

#### 使用 React 如何实现？

在 React 中，input 元素的 `value` 属性被绑定到了 this.state.todo 这个值上。这个值可以通过调用一些函数实现自动更新，这些函数绑定到一起就创建了**双向数据绑定**（如果你之前没听过，在后面的**使用 Vue 如何实现**部分有更详细的解释）。React 通过在 **input** 元素上绑定 **onChange** 方法来实现双向绑定。让我们来看看 **input** 元素是什么样的，然后再来解释原理：

```
<input type="text" 
       value={this.state.todo} 
       onChange={this.handleInput}/>
```

如果 input 元素的值发生变化，handleInput 方法就会被调用。它会使用输入字段中的内容来更新 state 对象中 **todo** 的值。这个函数如下：

```
handleInput = e => {
  this.setState({
    todo: e.target.value
  });
};
```

现在，每当用户按下页面上的 **+** 按钮添加新项目时，**createNewToDoItem** 函数就会运行 this.setState 方法并向其传递一个函数作为参数。这个函数有两个参数，第一个是来自 state 对象的整个 **list** 数组，第二个是新的 **todo**（由 **handleInput** 函数更新）项目。然后该函数返回一个新对象，该对象包含之前的整个 **list**，然后在 list 末尾添加新的 **todo ** 项。整个 list 是使用扩展运算符添加的（如果你以前没有看过这个可以搜索一下，这是 ES6 语法）。

最后，我们将 **todo** 设置为空字符串，它会自动更新 **input 元素**的**值**。

#### Vue：

```
createNewToDoItem() {
    this.list.push(
        {
            'todo': this.todo
        }
    );
    this.todo = '';
}
```

#### 使用 Vue 如何实现？

在 Vue 中，**input** 元素有一个名为 **v-model** 的指令。可以可以帮助我们创建**双向数据绑定**。先看看 **input** 元素是什么样的，然后再来解释原理：

```
<input type="text" v-model="todo"/>
```

V-Model 指令将 input 元素的值绑定到数据对象中的 toDoItem。当页面加载时，我们通过 `todo: ''` 将 toDoItem 设置为空字符串。如果这里已经有一些数据，例如 `todo: '原有 todo'`，input 元素会使用已有数据**原有 todo **作为初始值。无论如何，回到使用空字符串作为初始值，我们在 input 元素输入的任何文本都绑定到 **todo** 上。这实际上就是双向绑定（input 元素可以更新数据对象，数据对象也可以更input 元素的值）。

所以回顾前面 **createNewToDoItem()** 代码，我们看到它将 **todo** 的内容添加到 **list** 数组，然后将 **todo** 更新为空字符串。

### 如何删除列表中的 Todo 项？

#### React：

```
deleteItem = indexToDelete => {
    this.setState(({ list }) => ({
      list: list.filter((toDo, index) => index !== indexToDelete)
    }));
};
```

#### 使用 React 如何实现？

虽然 deleteItem 方法定义在 **ToDo.js** 文件中，但先将 **deleteItem()** 方法作为 **<ToDoItem/>** 组件的 prop 传递进去，在 **ToDoItem.js** 内部引用它也就很容易了，写法如下：

```
<ToDoItem deleteItem={this.deleteItem.bind(this, key)}/>
```

首先将方法传递到子组件，使其可以访问。同样可以看到我们也绑定了 **this**，并把 key 作为参数传递，key 用来区分点击删除的是哪个  **ToDoItem**。然后，在 **ToDoItem** 内部，代码如下：

```
<div className="ToDoItem-Delete" onClick={this.props.deleteItem}>-</div> 
```

所有需要引用父组件中的一个方法只通过 **this.props.deleteItem** 就可以实现。

#### Vue：

```
onDeleteItem(todo){
  this.list = this.list.filter(item => item !== todo);
}
```

#### 使用 Vue 如何实现？

Vue 应用需要稍微不同的方法。基本上分为三步：

首先，在元素上绑定点击事件处理方法：

```
<div class="ToDoItem-Delete" @click="deleteItem(todo)">-</div>
```

然后，创建一个调用 emit 方法的函数作为子组件（这个例子中，就是 **ToDoItem.vue** 组件）内部方法，如下：

```
deleteItem(todo) {
    this.$emit('delete', todo)
}
```

除此之外，当我们在 **ToDo.vue** 中添加 **ToDoItem.vue** 时，我们实际引用了一个**函数**：

```
<ToDoItem v-for="todo in list" 
          :todo="todo" 
          @delete="onDeleteItem" // <-- 这里 :)
          :key="todo.id" />
```

这就是所谓的自定义事件监听器。它会监听任何由 emit 触发名为 delete 的事件发生的场合。如果监听到，就会触发执行名为 **onDeleteItem** 的方法。这个方法定义在 **ToDoItem.vue** 组件内部而不是 **ToDoItem.vue** 组件。这个方法，正如上面所示，会过滤 **data 对象**内的 **todo 数组**并移除点击的项目。

这里值得注意的是：在 Vue 应用中，也可以把 `$emit` 部分写到**@click** 指令中，如下：

```
<div class="ToDoItem-Delete" @click="this.$emit('delete', todo)">-</div> 
```

这样可以将步骤从 3 步减少到 2 步，这也仅仅取决于个人偏好。

简而言之，React 中的子组件可以通过 **this.props** 访问父组件（假设你向下传递 props，这是相当标准的做法，你会在其它 React 示例中遇到很多次）中的方法，而在 Vue 中，你必须从子组件内部发出通常在父组件内监听的事件。

### 如何传递事件监听器？

#### React：

简单事件（如点击事件）的事件监听器是直截了当的。以下是我们为新建 ToDo 项目按钮绑定 click 事件监听的示例：

```
<div className="ToDo-Add" onClick={this.createNewToDoItem}>+</div>.
```

这里的实现非常简单，看起来很像使用原生 JS 来处理行内的 onClick 事件。正如 Vue 部分提到的，如果是为按下回车按钮设置事件监听器就需要花费更长的时间了。input 标签通常会处理 onKeyPress 事件，如下：

```
<input type="text" onKeyPress={this.handleKeyPress}/>.
```

只要这个方法监听到了回车键按下，它就会调用 **createNewToDoItem** 函数，如下所示：

```
handleKeyPress = (e) => {

if (e.key === 'Enter') {

this.createNewToDoItem();

}

};
```

#### Vue：

Vue 中的实现超级直接。只需使用 **@** 符号，然后绑定相应的事件监听器。例如，要添加 click 事件监听器，只需如下编写代码：

```
<div class="ToDo-Add" @click="createNewToDoItem()">+</div> 
```

注意：**@click** 实际上是 **v-on:click** 的简写。Vue 事件监听器另一个很酷的事情是：有很多修饰符可以链接到它们，例如 .once，它可以防止事件监听器被多次触发。在编写用于处理键盘事件侦听器时，也有一些快捷方式。我发现在 React 中为创建新的 ToDo 项绑定一个事件监听器需要花费更长的时间。而在 Vue 中，我能够像下面这样简单实现：

```
<input type="text" v-on:keyup.enter="createNewToDoItem"/>
```

#### 如何将数据传递给子组件？

#### React：

在 React 中，我们在使用子组件的地方通过 prop 传递数据，如下：

```
<ToDoItem key={key} item={todo} />
```

上面有两个 props 传递给了 **ToDoItem** 组件。这样传递之后，就可以在子组件内部通过 this.props 来引用它们了。因此，就可以通过 this.props.item 访问 **todo** 变量了。

#### Vue：

在 Vue 中，也是在使用子组件的地方传递数据，如下：

```
<ToDoItem v-for="todo in list"   
            :todo="todo" :id="todo.id"  
            :key="todo.id"  
            @delete="onDeleteItem" />
```

这样传递之后，我们会把这些数据传递到子组件的 props 数组中：**props: [ 'id', 'todo' ]**。然后就可以在子组件中通过它们的名字进行引用了，比如 **id** 和 **todo**。

### 如何将数据发送回父组件？

#### React：

我们首先将函数传递给子组件，方法就是在使用子组件的位置将其作为prop 传递。然后在形如 **onClick** 方法中通过 **this.props.whateverTheFunctionIsCalled** 引用这个函数。这将触发位于父组件中定义的函数。可以在**如何从列表中删除 Todo 项**一节中看到整个过程的一个示例。

#### Vue：

在子组件中，我们只需编写一个函数，将一个事件名发送回父组件。在父组件中，我们编写一个函数来监听这个事件，它会触发函数调用。可以在**如何从列表中删除 Todo 项**一节中看到整个过程的一个示例。

### **到这里就完成了** 🎉

我们研究了如何添加、删除和更改数据，以 prop 形式从父组件到子组件传递数据，以及通过事件侦听器形式将数据从子组件发送到父组件。当然，在 React 和 Vue 之间还存在许多其它小差异，但希望本文的内容对你理解两个框架如何处理问题打下一个好的基础 🤓

#### **两个应用 Github 仓库链接：**

Vue ToDo：[https://github.com/sunil-sandhu/vue-todo](https://github.com/sunil-sandhu/vue-todo)

React ToDo：[https://github.com/sunil-sandhu/react-todo](https://github.com/sunil-sandhu/react-todo)




> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
