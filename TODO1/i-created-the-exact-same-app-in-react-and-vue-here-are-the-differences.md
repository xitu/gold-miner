> * 原文地址：[I created the exact same app in React and Vue. Here are the differences.](https://medium.com/javascript-in-plain-english/i-created-the-exact-same-app-in-react-and-vue-here-are-the-differences-e9a1ae8077fd)
> * 原文作者：[Sunil Sandhu](https://medium.com/@sunilsandhu?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/i-created-the-exact-same-app-in-react-and-vue-here-are-the-differences.md](https://github.com/xitu/gold-miner/blob/master/TODO1/i-created-the-exact-same-app-in-react-and-vue-here-are-the-differences.md)
> * 译者：
> * 校对者：

# I created the exact same app in React and Vue. Here are the differences.

Having used Vue at my current workplace, I already had a fairly solid knowledge of how it all worked. However, I was curious to know what the grass was like on the other side of the fence — the grass in this scenario being React.

I’d read the React docs and watched a few tutorial videos and, while they were great and all, what I really wanted to know was how different React was from Vue. By “different”, I didn’t mean things such as whether they both had virtual DOMS or how they went about rendering pages. I wanted someone to take the time to explain the code and to tell me what was going on! I wanted to find an article that took the time to explain these differences so that someone new to either Vue or React (or Web Development as a whole) could gain a better understanding of the differences between the two.

But I couldn’t find anything that tackled this. So I came to the realisation that I’d have to go ahead and build this myself in order to see the similarities and differences. In doing so, I thought I’d document the whole process so that an article on this will finally exist.

![](https://cdn-images-1.medium.com/max/800/1*ubWUG5LqQ0ak6wvFJtexHA.png)

Who wore it better?

I decided to try and build a fairly standard To Do App that allows a user to add and delete items from the list. Both apps were built using the default CLIs (create-react-app for React, and vue-cli for Vue). CLI stands for Command Line Interface by the way. 🤓

### Anyway, this intro is already longer than I’d anticipated. So let’s start by having a quick look at how the two apps look:

![](https://cdn-images-1.medium.com/max/2000/1*mJ-qdNqldpgae2U5oS0qDg.png)

Vue vs React: The Irresistible Force meets The Immovable Object

The CSS code for both apps are exactly the same, but there are differences in where these are located. With that in mind, let’s next have a look at the file structure of both apps:

![](https://cdn-images-1.medium.com/max/800/1*rahCwWEIXM7Wblk4L9ExYA.png)

Who wore it better?

You’ll see that their structures are almost identical as well. The only difference here is that the React app has three CSS files, whereas the Vue app doesn’t have any. The reason for this is because, in create-react-app, a React component will have an accompanying file to hold its styles, whereas Vue CLI adopts an all encompassing approach, where the styles are declared inside the actual component file.

Ultimately, they both achieve the same thing, and there is nothing to say that you can’t go ahead and structure your CSS differently in React or Vue. It really comes down to personal preference - you’ll hear plenty of discussion from the dev community over how CSS should be structured. For now, we’ll just follow the structure laid out in both CLIs.

But before we go any further, let’s take a quick look at what a typical Vue and React component look like:

![](https://cdn-images-1.medium.com/max/1000/1*yQS8va-QXM2poiP-RqasOw.png)

Vue on the left. React on the right

Now that’s out of the way, let’s get into the nitty gritty detail!

### **How do we mutate data?**

But first, what do we even mean by “mutate data”? Sounds a bit technical doesn’t it? It basically just means changing the data that we have stored. So if we wanted to change the value of a person’s name from John to Mark, we would be ‘mutating the data’. So this is where a key difference between React and Vue lies. While Vue essentially creates a data object, where data can freely be updated, React creates a state object, where a little more legwork is required to carry out updates. Now React implements the extra legwork with good reason, and we’ll get into that in a little bit. But first, let’s take a look at the **data** object from Vue and the **state** object from React:

![](https://cdn-images-1.medium.com/max/600/1*b9BjPHgneHv2K6ZYlAoe8A.png)

![](https://cdn-images-1.medium.com/max/600/1*asy_vlGoZgtA3sAA7Dw4CA.png)

Vue data object on the left. React state object on the right.

So you can see that we have passed the same data into both, but they’re simply labelled differently. So passing initial data into our components is very, very similar. But as we’ve mentioned, how we go about changing this data differs between both frameworks.

Let’s say that we have an data element called name: ‘Sunil’.

In Vue, we reference this by calling **this.name**. We can also go about updating this by calling **this.name** **= ‘John’**. This would change my name to John. I’m not sure how I feel about being called John, but hey ho, things happen! :)

In React, we would reference the same piece of data by calling **this.state.name**. Now the key difference here is that we cannot simply write **this.state.name** = ‘John’, because React has restrictions in place to prevent this kind of easy, care-free mutation-making. So in React, we would write something along the lines of **this.setState({name: ‘John’})**.

While this essentially does the same thing as we achieved in Vue, the extra bit of writing in there to stop us from accidentally overwriting this.state, as there’s a clear difference between this.state and this.setState. There are actually reasons here for why React makes mutations differently to Vue, as [Revanth Kumar](https://medium.com/@revanth0212) explains here:

> “This is because React wants to re-run certain life cycle hooks, [such as] componentWillReceiveProps, shouldComponentUpdate, componentWillUpdate, render, componentDidUpdate, whenever state changes. It would know that the state has changed when you call the setState function. If you directly mutated state, React would have to do a lot more work to keep track of changes and what lifecycle hooks to run etc. So to make it simple React uses setState.”

![](https://cdn-images-1.medium.com/max/800/1*IugEwe6Lkm5iFB-Q9zvc5w.jpeg)

Bean knew best

Now that we have mutations out of the way, let’s get into the nitty, gritty by looking at how we would go about adding new items to both of our To Do Apps.

### **How do we create new To Do Items?**

#### **React**:

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

#### How did React do that?

In React, our input field has a handle on it called **value.** This value gets automatically updated through the use of a couple of functions that tie together to create **two-way binding** (if you’ve never heard of this before, there’s a more detailed explanation in the _How did Vue do that_ section after this). React handles two-way binding by having an additional **onChange** function attached to the **input** field. Let’s quickly take a look at the **input** field so that you can see what is going on:

```
<input type="text" 
       value={this.state.todo} 
       onChange={this.handleInput}/>
```

The handleInput function is ran whenever the value of the input field changes. It updates the **todo** that sits inside the state object by setting it to whatever is in the input field. This function looks as such:

```
handleInput = e => {
  this.setState({
    todo: e.target.value
  });
};
```

Now, whenever a user presses the **+** button on the page to add a new item, the **createNewToDoItem** function essentially runs this.setState and passes it a function. This function takes two parameters, the first being the entire **list** array from the state object, the second being the **todo** (which gets updated by the **handleInput** function). The function then returns a new object, which contains the entire **list** from before and then adds **todo** at the end of it. The entire list is added through the use of a spread operator (Google this if you’ve not seen this before — it’s ES6 syntax).

Finally, we set **todo** to an empty string, which automatically updates the **value** inside the **input** field.

#### Vue:

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

#### How did Vue do that?

In Vue, our **input** field has a handle on it called **v-model**. This allows us to do something known as **two-way binding**. Let’s just quickly look at our input field, then we’ll explain what is going on:

```
<input type="text" v-model="todo"/>
```

V-Model ties the input of this field to an key we have in our data object called toDoItem. When the page loads, we have toDoItem set to an empty string, as such: **todo: ‘’**. If this had some data already in there, such as **todo: ‘add some text here’**, our input field would load with _add some text here_ already inside the input field. Anyway, going back to having it as an empty string, whatever text we type inside the input field gets bound to the value for **todo**. This is effectively two-way binding (the input field can update the data object and the data object can update the input field).

So looking back at the **createNewToDoItem()** code block from earlier, we see that we push the contents of **todo** into the **list** array  and then update **todo** to an empty string.

### How do we delete from the list?

#### React:

```
deleteItem = indexToDelete => {
    this.setState(({ list }) => ({
      list: list.filter((toDo, index) => index !== indexToDelete)
    }));
};
```

#### How did React do that?

So whilst the deleteItem function is located inside **ToDo.js**, I was very easily able to make reference to it inside **ToDoItem.js** by firstly, passing the **deleteItem()** function as a prop on **<ToDoItem/>** as such:

```
<ToDoItem deleteItem={this.deleteItem.bind(this, key)}/>
```

This firstly passes the function down to make it accessible to the child. You’ll see here that we’re also binding **this** as well as passing the key parameter, as key is what the function is going to use to be able to differentiate between which **ToDoItem** is attempting to delete when clicked. Then, inside the **ToDoItem** component, we do the following:

```
<div className="ToDoItem-Delete" onClick={this.props.deleteItem}>-</div> 
```

All I had to do to reference a function that sat inside the parent component was to reference **this.props.deleteItem**.

#### Vue:

```
onDeleteItem(todo){
  this.list = this.list.filter(item => item !== todo);
}
```

#### How did Vue do that?

A slightly different approach is required in Vue. We essentially have to do three things here:

Firstly, on the element we want to call the function:

```
<div class="ToDoItem-Delete" @click="deleteItem(todo)">-</div>
```

Then we have to create an emit function as a method inside the child component (in this case, **ToDoItem.vue**), which looks like this:

```
deleteItem(todo) {
    this.$emit('delete', todo)
}
```

Along with this, you’ll notice that we actually reference a **function** when we add **ToDoItem.vue** inside of **ToDo.vue**:

```
<ToDoItem v-for="todo in list" 
          :todo="todo" 
          @delete="onDeleteItem" // <-- this :)
          :key="todo.id" />
```

This is what is known as a custom event-listener. It listens out for any occasion where an emit is triggered with the string of ‘delete’. If it hears this, if triggers a function called **onDeleteItem**. This function sits inside of **ToDo.vue,** rather than **ToDoItem.vue**. This function, as listed earlier, simply filters the **todo array** inside  the **data object** to remove the item that was clicked on.

It’s also worth noting here that in the Vue example, I could have simply written the **$emit** part inside of the **@click** listener, as such:

```
<div class="ToDoItem-Delete" @click="this.$emit('delete', todo)">-</div> 
```

This would have reduced the number of steps down from 3 to 2, and this is simply down to personal preference.

In short, child components in React will have access to parent functions via **this.props** (providing you are passing props down, which is fairly standard practice and you’ll come across this loads of times in other React examples), whilst in Vue, you have to emit events from the child that will usually be collected inside the parent component.

### How do we pass event listeners?

#### React:

Event listeners for simple things such as click events are straight forward. Here is an example of how we created a click event for a button that creates a new ToDo item:

```
<div className="ToDo-Add" onClick={this.createNewToDoItem}>+</div>.
```

Super easy here and pretty much looks like how we would handle an in-line onClick with vanilla JS. As mentioned in the Vue section, it took a little bit longer to set up an event listener to handle whenever the enter button was pressed. This essentially required an onKeyPress event to be handled by the input tag, as such:

```
<input type="text" onKeyPress={this.handleKeyPress}/>.
```

This function essentially triggered the **createNewToDoItem** function whenever it recognised that the ‘enter’ key had been pressed, as such:

```
handleKeyPress = (e) => {

if (e.key === 'Enter') {

this.createNewToDoItem();

}

};
```

#### Vue:

In Vue it is super straight-forward. We simply use the **@** symbol, and then the type of event-listener we want to do. So for example, to add a click event listener, we could write the following:

```
<div class="ToDo-Add" @click="createNewToDoItem()">+</div> 
```

Note: **@click** is actually shorthand for writing **v-on:click**. The cool thing with Vue event listeners is that there are also a bunch of things that you can chain on to them, such as .once which prevents the event listener from being triggered more than once. There are also a bunch of shortcuts when it comes to writing specific event listeners for handling key strokes. I found that it took quite a bit longer to create an event listener in React to create new ToDo items whenever the enter button was pressed. In Vue, I was able to simply write:

```
<input type="text" v-on:keyup.enter="createNewToDoItem"/>
```

#### How do we pass data through to a child component?

#### React:

In react, we pass props onto the child component at the point where it is created. Such as:

```
<ToDoItem key={key} item={todo} />
```

Here we see two props passed to the **ToDoItem** component. From this point on, we can now reference them in the child component via this.props. So to access the **item.todo** prop, we simply call this.props.todo.

#### Vue:

In Vue, we pass props onto the child component at the point where it is created. Such as:

```
<ToDoItem v-for="todo in list"   
            :todo="todo"  
            :key="todo.id"  
            @delete="onDeleteItem" />
```

Once this is done, we then pass them into the props array in the child component, as such: **props: [ ‘id’, ‘todo’ ]**. These can then be referenced in the child by their names, so ‘**id**’ and **‘todo**’.

### How do we emit data back to a parent component?

#### React:

We firstly pass the function down to the child component by referencing it as a prop in the place where we call the child component. We then add the call the function on the child by whatever means, such as an **onClick**, by referencing **this.props.whateverTheFunctionIsCalled**. This will then trigger the function that sits in the parent component. We can see an example of this entire process in the section _‘How do we delete from the list’._

#### Vue:

In our child component, we simply write a function that emits a value back to the parent function. In our parent component, we write a function that listens for when that value is emitted, which can then trigger a function call. We can see an example of this entire process in the section _‘How do we delete from the list’_

### **And there we have it!** 🎉

We’ve looked at how we add, remove and change data, pass data in the form of props from parent to child, and send data from the child to the parent in the form of event listeners. There are, of course, lots of other little differences and quirks between React and Vue, but the hopefully the contents of this article has helped to serve as a bit of a foundation for understanding how both frameworks handle stuff 🤓

#### **Github links to both apps:**

Vue ToDo: [https://github.com/sunil-sandhu/vue-todo](https://github.com/sunil-sandhu/vue-todo)

React ToDo: [https://github.com/sunil-sandhu/react-todo](https://github.com/sunil-sandhu/react-todo)

_This article was updated on July 28th 2018, following suggestions from_ [_Dan Charousek_](https://github.com/DanCharousek)_, who kindly made recommendations for improving the Vue ToDo app, and_ [_Lucas Everett_](https://medium.com/@lucaseverett) _who made some fantastic suggestions for the React ToDo app (he also rewrote the createNewToDoItem and deleteItem functions)_ 🤓

_This article was updated on July 30th 2018, to try to clarify that this article was written with new developers in mind, whether that be to either JS frameworks such as React and Vue, or simply new to the industry in general. This article is not really intended for seasoned veterans. Suggestions made by_ [_Daniel Lang_](https://github.com/mavrick) _and_ [_Bert Evans_](https://github.com/alevans4)_. Bert very kindly made a pull request to the Vue ToDo repository to implement a more robust way of emitting data back from child to parent, along with a better ID system for each ToDo Item. A quote explaining why React uses setState was also added, following a fantastic comment left by_ [_Revanth Kumar_](https://medium.com/@revanth0212)_._

**_I thought I’d also take a moment to let you know that we are currently looking for writers to join our team at Javascript In Plain English. If you’re passionate about Javascript and have a story to tell, feel free to contact me at hello@sunilsandhu.com to find out more_ 🤓**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
