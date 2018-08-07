> * 原文地址：[Introducing SpaceAce, a new kind of front-end state library](https://medium.com/dailyjs/introducing-spaceace-a-new-kind-of-front-end-state-library-5215b18adc11)
> * 原文作者：[Jon Abrams](https://medium.com/@jonathanabrams?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/introducing-spaceace-a-new-kind-of-front-end-state-library.md](https://github.com/xitu/gold-miner/blob/master/TODO1/introducing-spaceace-a-new-kind-of-front-end-state-library.md)
> * 译者：
> * 校对者：

# Introducing SpaceAce, a new kind of front-end state library

Anyone who’s developed front-end applications knows that managing the state is one of the most important, and challenging, aspects. Popular component-based view libraries, like React, include fully functional, if not rudimentary, state management. They enable each component of your application to manage their own state. They work well enough for small applications, but you’ll quickly encounter frustration. It’s a challenge deciding which components have state and how the data from each state gets shared between components. Then there’s figuring out how or why state was changed.

To address the above problems of component-oriented state, libraries like Redux were introduced. They centralize that state into a centralized “store” that every component can read and write to. To maintain order they centralize the logic that changes the state into a central part of the application called the [**reducer**](https://redux.js.org/basics/reducers), which is invoked using **actions**,  and causing it to produce a fresh copy of the state. It’s very effective but has a high learning curve, requires a lot of boiler-plate, and forces you to separate code that updates the state from the code that renders the view.

[SpaceAce](https://github.com/JonAbrams/SpaceAce) is a new library that takes all the benefits of Redux, such as a centralized store, immutable state, unidirectional data flow, clearly defined actions, **and** it greatly simplifies how your code updates the store’s state.

We’ve been using SpaceAce to manage state in our main React app at [Trusted Health](https://www.trustedhealth.com/) for nearly a year now with great success. While our engineering team is relatively small (3 people) it has really sped up feature development without sacrificing code complexity or testability.

### What is SpaceAce?

SpaceAce provides a state management _store_ known as a **space**. A space is the read-only (immutable) state and a toolkit for updating it. But this store doesn’t just _have_ state inside it, it _is_ the state. At the same time, it provides multiple methods for generating new version of state. How? It’s a function… with properties! Many JS developers don’t know that JS functions are also objects. In addition to being executable, they can also have properties, just like objects (because they’re objects too!).

Each space is an immutable object with properties that can be read directly, but cannot be changed directly. Each space is _also_ a function that can create a new copy with specified changes applied to the state.

Finally, an example:

```
import Space from 'spaceace';

const space = new Space({
    appName: "SpaceAce demoe",
    user: { name: 'Jon', level: 9001 }
});

const newSpace = space({ appName: "SpaceAce demo" });

console.log(`Old app name: ${space.appName}, new app name: ${newSpace.appName}`);
```

Outputs: “Old app name: SpaceAce demoe, new app name: SpaceAce demo”

The above example shows how you make a space and directly “change” it by calling it with an object to merge onto the state. This is similar to [React’s setState](https://itnext.io/react-setstate-usage-and-gotchas-ac10b4e03d60), applying a shallow merge. Keep in mind though that the original space doesn’t change, it instead returns a copy with the changes applied.

However, it’s not really useful until the application re-renders with the new state. To make that easier, a **subscribe** function is provided. It invokes a callback whenever the associated space “changes”:

```
import Space, { subscribe } from 'spaceace';

const space = new Space({
    appName: "SpaceAce demoe",
    user: { name: 'Jon', level: 9001 }
});

subscribe(space, ({ newSpace, causedBy }) => {
  console.log(`State updated by ${causedBy}`);
  ReactDOM.render(
    <h1>{newSpace.appName}</h1>, 
    document.getElementById('app')
  );
});

// Causes React to render
space({ appName: "SpaceAce demo" });
```

Most of the time, the state changes due to something the user has done. They click a checkbox, select an option from a dropdown, or type into a field. SpaceAce makes updating state from these simple interactions **ridiculously easy**. If you invoke the space with a string, it generates and returns a handler function:

```
export const PizzaForm = ({ space }) => (
  <form>
    <label>Name</label>
    <input 
      type="text" 
      value={space.name || ''} 
      onChange={space('name')} // Whenever user types, `space.name` is updated
    />
    <label>Do you like pizza?</label>
    <input
      type="checkbox"
      checked={space.pizzaLover || false}
      onChange={space('pizzaLover')} // Assigns true or false to `space.pizzaLover`
     />
  </form>
);
```

While most apps contain a lot of simple interactions, they also consist of complex actions. SpaceAce allows you to define custom actions, all within the same file as your component. When called, these actions are given an object filled with handy functions for updating the state:

```
import { fetchPizza } from '../apiCalls';

/* 
  handleSubmit is a custom action.
  The first parameter is provided by SpaceAce.
  The remaining parameters are passed-through
  which in this case consists of React's event object
*/
const handleSubmit = async ({ space, merge }, event) => {
  event.preventDefault();
  
  // merge does a shallow merge, allowing the assignment of multiple properties at once
  merge({ saving: true }); // updates space immediately, triggers re-render
  
  const { data, error } = await fetchPizza({ name: space.name });
  if (error) return merge({ error: errorMsg, saving: false });
  
  merge({ 
    saving: false, 
    pizza: data.pizza // 'Pepperoni', hopefully
  });
};

/*
  handleReset is another custom action.
  This one erases all properties on the space,
  replacing them with only the specified ones.
*/
const handleReset = ({ replace }) => {
  replace({
    name: '',
    pizzaLover: false
  });
};

export const PizzaForm = ({ space }) => (
  <form onSubmit={space(handleSubmit)}>
    {/* ... some input elements */}
    <p className="error">{space.errorMsg}</p>
    {space.pizza && <p>You’ve been given: {space.pizza}</p>}
    <button disabled={space.saving} type="submit">Get Pizza</button>
    <button disabled={space.saving} type="button" onClick={space(handleReset)}>Reset</button>
  </form>
);
```

You may notice that all these ways of changing a space’s state assumes that the state is relatively shallow, but how is that possible if there’s only one space per app? It isn’t! Every space can have any number of child sub-spaces, which are also just spaces, but they have parents. Whenever one of those child spaces is updated the changes bubble up, triggering a re-render of the app once the change reaches the root space.

The best part of child spaces, is you don’t need to explicitly make them. They’re automatically created when you access an object or array on the space:

```
const handleRemove = ({ remove }, itemToBeRemoved) => {
  // `remove` is available on array spaces, runs callback 
  // on each element.
  // For any callback that returns true, the element is removed
  remove(item => item === itemToBeRemoved);
};

/* 
  A shopping cart's space is an array of items,
  each being an object, and therefore a space too.
*/
export const ShoppingCart = ({ space }) => (
  <div>
    <ul>
      {space.map(item => (
        <li key={item.uuid}>
          <CartItem 
            space={item} 
            onRemove={space(handleRemove).bind(null, item)} 
           />
        </li>
      )}
    </ul>
  </div>
);
const CartItem = ({ space, onRemove }) => (
  <div>
    <strong>{space.name}</strong>
    <input 
      type="number" 
      min="0" 
      max="10" 
      onChange={space('count')}
      value={space.count} 
     />
    <button onClick={onRemove}>Remove</button>
  </div>
);
```

There’re a bunch more features to discover, and fun tricks that I’ll be sharing soon. Stay tuned for my next post!

Meanwhile, check out the [documentation and code on Github](https://github.com/JonAbrams/SpaceAce) and [let me know what you think](https://twitter.com/JonathanAbrams)!

Thanks to [Zivi Weinstock](https://medium.com/@z1v1?source=post_page).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
