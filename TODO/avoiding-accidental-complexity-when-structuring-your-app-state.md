> * 原文地址：[Avoiding Accidental Complexity When Structuring Your App State](https://hackernoon.com/avoiding-accidental-complexity-when-structuring-your-app-state-6e6d22ad5e2a#.hgm96hth7)
* 原文作者：[Tal Kol](https://hackernoon.com/@talkol)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

Flux implementations like Redux encourage us to think explicitly about our app state and spend time modeling it. It turns out that this isn’t a trivial task. It’s a classic example of chaos theory, where a seemingly harmless flutter of wings in the wrong direction can cause a hurricane of accidental complexity later on. Provided below is a list of practical tips of how to model app state in order to keep your business-logic and yourself as sane as possible.

#### What exactly is app state

According to [Wikipedia](https://en.wikipedia.org/wiki/State_%28computer_science%29) — a computer program stores data in variables, which represent storage locations in the computer’s memory. The contents of these memory locations, at any given point in the program’s execution, is called the program’s _state_.

In our context, it’s important to add the word _minimal_ to this definition. When modeling our app’s state for explicit control, we’ll do our best to deal with the minimal amount of data required to express this state, and ignore all the other floating variables in our program that can be derived from this core.

In [Flux](https://facebook.github.io/flux/) applications, app state is held within _stores_. Dispatched _actions_ cause this state to change, afterwhich the _views_ that listen to these state changes will re-render themselves accordingly.



![](https://cdn-images-1.medium.com/max/800/1*pgxTL69KXTYjupzGO015Ew.png)



[Redux](http://redux.js.org/), which will be our resident Flux implementation for the sake of this discussion, adds several stricter requirements — like holding the entire app state in a _single_ store, which is also _immutable_ and normally _serializable_.

The tips outlined below should also be relevant if you’re not using Redux. There’s a good chance they’re even relevant if you’re not using Flux at all.

#### 1. Avoid modeling state after server API

Local app state often originates from a server. When an app is used to display data arriving from a remote server, it’s often very tempting to maintain the structure of this data as-is.

Consider an example of an e-commerce store management app. The merchant will use this app to manage store inventory, so displaying a product list is a key feature. The product list originates from the server, but needs to be stored locally in app state in order to be rendered inside views. Let’s assume the main API for retrieving the list of products from the server returns the following JSON result:


```
{
  "total": 117,
  "offset": 0,
  "products": [
    {
      "id": "88cd7621-d3e1-42b7-b2b8-8ca82cdac2f0",
      "title": "Blue Shirt",
      "price": 9.99
    },
    {
      "id": "aec17a8e-4793-4687-9be4-02a6cf305590",
      "title": "Red Hat",
      "price": 7.99
    }
  ]
}
```

The list of products arrives as an _array_ of _objects_, so why not save them in the app state as an array of objects?

The design of server API follows different concerns that don’t necessarily align with the goals your app state structure is trying to achieve. In this case, the server’s choice of _array_ is probably related to response paging, splitting the full list into smaller chunks so data can be downloaded as needed and avoiding sending the same data more than once to save bandwidth. All valid network concerns, but in general — unrelated to our state concerns.


#### 2. Prefer maps to arrays

In general, arrays are inconvenient for maintaining state. Consider what happens when a specific product needs to be updated or retrieved. This can be the case, for example, if the app is used to edit prices, or if data from the server needs to be refreshed. Iterating over a large array to find a specific product is much less convenient than querying this product according to its _ID_.

So what’s the recommended approach? Use a _map_ and index by the primary key used for queries.

This means the data from the example above can be stored in app state in the following structure:

```
{
  "productsById": {
    "88cd7621-d3e1-42b7-b2b8-8ca82cdac2f0": {
      "title": "Blue Shirt",
      "price": 9.99
    },
    "aec17a8e-4793-4687-9be4-02a6cf305590": {
      "title": "Red Hat",
      "price": 7.99
    }
  }
}
```

What happens if sort order is important? For example, if the order returned from the server is the same order we’re required to present to the user. In that case, we can store an additional array of _ID_’s only:

```
{
  "productsById": {
    "88cd7621-d3e1-42b7-b2b8-8ca82cdac2f0": {
      "title": "Blue Shirt",
      "price": 9.99
    },
    "aec17a8e-4793-4687-9be4-02a6cf305590": {
      "title": "Red Hat",
      "price": 7.99
    }
  },
  "productIds": [
    "88cd7621-d3e1-42b7-b2b8-8ca82cdac2f0",
    "aec17a8e-4793-4687-9be4-02a6cf305590"
  ]
}
```

An interesting side note: If we’re planning to display the data inside a React Native [ListView](https://facebook.github.io/react-native/docs/listview.html) component, this structure actually works very well. The recommended version of [cloneWithRows](https://facebook.github.io/react-native/docs/listviewdatasource.html#clonewithrows) that supports stable row ID’s expects this exact format.

#### 3. Avoid modeling state after what views like to consume

The eventual purpose of app state is to propagate into views and be rendered for the user’s pleasure. It seems tempting to avoid the cost of additional transformations and simply store the state in the same exact structure views expect to receive.

Let’s return to our e-commerce store management example. Suppose that every product can either be in-stock or out-of-stock. We can store this data in a _boolean_ property of our product object:

```
{
  "id": "88cd7621-d3e1-42b7-b2b8-8ca82cdac2f0",
  "title": "Blue Shirt",
  "price": 9.99,
  "outOfStock": false
}
```

Our app is required to display a list of all products that are out-of-stock. As you recall from above, the React Native ListView component expects for its [cloneWithRows](https://facebook.github.io/react-native/docs/listviewdatasource.html#clonewithrows) method 2 arguments: a map of rows and an array of row ID’s. We are tempted to prepare the state in advance and hold this list explicitly. This will allow us to provide both arguments to the ListViews without additional transformations. The state structure we’ll end up with is the following:

```
{
  "productsById": {
    "88cd7621-d3e1-42b7-b2b8-8ca82cdac2f0": {
      "title": "Blue Shirt",
      "price": 9.99,
      "outOfStock": false
    },
    "aec17a8e-4793-4687-9be4-02a6cf305590": {
      "title": "Red Hat",
      "price": 7.99,
      "outOfStock": true
    }
  },
  "outOfStockProductIds": ["aec17a8e-4793-4687-9be4-02a6cf305590"]
}
```

Sounds like a good idea, right? Well.. it turns out that it isn’t.

The reason, like before, is that views are guided by a different set of concerns. Views don’t care about keeping state minimal. If anything, they prefer the complete opposite since data must be laid out for the user’s sake. Different views may present the same state data in different ways and it is usually impossible to satisfy them all without duplicating data.

Which brings us to the next point..

### 4. Never hold duplicate data in the app state

A good test whether your state is holding duplicate data is checking if updates must be done to two places at once in order to maintain consistency. In the out-of-stock products example above, suppose that the first product suddenly becomes out-of-stock. In order to process this update, we’ll have to change its _outOfStock_ field in the map to _true_ and add its _ID_ to the array _outOfStockProductIds — _two updates_._

Dealing with duplicate data is simple. All you have to do is remove one of the instances. The reasoning behind this stems from the principle of [single source of truth](https://en.wikipedia.org/wiki/Single_source_of_truth). If data is only saved once, it is no longer possible to reach a state of inconsistency.

If we remove the _outOfStockProductIds_ array, we’ll still need to find a way to prepare this data for view consumption. This transformation will have to take place in runtime right before data is given to the view. The recommended practice in Redux apps is implementing this in a [selector](https://egghead.io/lessons/javascript-redux-colocating-selectors-with-reducers):

```
{
  "productsById": {
    "88cd7621-d3e1-42b7-b2b8-8ca82cdac2f0": {
      "title": "Blue Shirt",
      "price": 9.99,
      "outOfStock": false
    },
    "aec17a8e-4793-4687-9be4-02a6cf305590": {
      "title": "Red Hat",
      "price": 7.99,
      "outOfStock": true
    }
  }
}

// selector
function outOfStockProductIds(state) {
  return _.keys(_.pickBy(state.productsById, (product) => product.outOfStock));  
}
```

The selector is a pure function that takes the state as input and returns the transformed part of the state we want to consume. [Dan Abramov](https://twitter.com/dan_abramov) recommends we locate selectors alongside reducers since they’re normally tightly coupled. We’ll execute the selector inside the view’s _mapStateToProps_.

Another viable alternative to removing the array is to remove the _outOfStock_ property from every product in the map. In this alternate approach, we can keep the array as the single source of truth. Actually.. according to tip #2 it would probably be better to change this array to a map:

```
{
  "productsById": {
    "88cd7621-d3e1-42b7-b2b8-8ca82cdac2f0": {
      "title": "Blue Shirt",
      "price": 9.99      
    },
    "aec17a8e-4793-4687-9be4-02a6cf305590": {
      "title": "Red Hat",
      "price": 7.99
    }
  },
  "outOfStockProductMap": {
    "aec17a8e-4793-4687-9be4-02a6cf305590": true
  }
}

// selector
function outOfStockProductIds(state) {
  return _.keys(state.outOfStockProductMap);  
}
```

#### 5. Never store derived data in the state


The single source of truth principle holds for more than just duplicate data. Any derived data found in the store violates the principle because updates have to made to multiple locations to maintain consistency.

Let’s add another requirement to our store management example — an ability to place products on sale and add a discount to their price. The app is required to display to the user a filtered list that shows either all products, only products without a discount or only products that have a discount.

A common mistake would be to hold 3 arrays in the store, each containing the _ID_’s of the relevant products to each of the filters. Since the 3 array can be derived from both the current filter and the product map, a better approach would be to generate them with a _selector_ like before:

```
{
  "productsById": {
    "88cd7621-d3e1-42b7-b2b8-8ca82cdac2f0": {
      "title": "Blue Shirt",
      "price": 9.99,
      "discount": 1.99
    },
    "aec17a8e-4793-4687-9be4-02a6cf305590": {
      "title": "Red Hat",
      "price": 7.99,
      "discount": 0
    }
  }
}

// selector
function filteredProductIds(state, filter) {
  return _.keys(_.pickBy(state.productsById, (product) => {
    if (filter == "ALL_PRODUCTS") return true;
    if (filter == "NO_DISCOUNTS" && product.discount == 0) return true;
    if (filter == "ONLY_DISCOUNTS" && product.discount > 0) return true;
    return false;
  }));  
}
```

Selectors are executed on every state change right before views are re-rendered. If your selectors are computationally intensive and you’re concerned about performance, apply [memoization](https://en.wikipedia.org/wiki/Memoization) to compute results just once and cache them. Take a look at the [Reselect](https://github.com/reactjs/reselect) library that implements this optimization.

### 6. Normalize nested objects

In general, the underlying motivation for the tips so far is _simplicity_. State needs to be managed over time and we want to make this as painless as possible. Simplicity is easier to maintain when your data objects are independent, but what happens when we have interconnections?

Consider the following example in our store management app. We want to add an order management system, where customers purchase several products as a single _order_. Let’s assume that we have a server API that returns the following JSON list of orders:

```
{
  "total": 1,
  "offset": 0,
  "orders": [
    {
      "id": "14e743f8-8fa5-4520-be62-4339551383b5",
      "customer": "John Smith",
      "products": [
        {
          "id": "88cd7621-d3e1-42b7-b2b8-8ca82cdac2f0",
          "title": "Blue Shirt",
          "price": 9.99,
          "giftWrap": true,
          "notes": "It's a gift, please remove price tag"
        }
      ],
      "totalPrice": 9.99
    }
  ]
}
```

An _order_ contains several _products_, so we have a relationship between the two that needs to be modeled. We already know from tip #1 that we probably shouldn’t use the API response structure as-is, which indeed seems problematic because it will cause duplication of product data.

A good approach in this case is to _normalize_ the data and maintain two separate maps — one for products and one for orders. Since both types of objects are based on unique _ID_’s, we can use the _ID_ property to specify interconnections. The resulting app state structure is:

```
{
  "productsById": {
    "88cd7621-d3e1-42b7-b2b8-8ca82cdac2f0": {
      "title": "Blue Shirt",
      "price": 9.99
    },
    "aec17a8e-4793-4687-9be4-02a6cf305590": {
      "title": "Red Hat",
      "price": 7.99
    }
  },
  "ordersById": {
    "14e743f8-8fa5-4520-be62-4339551383b5": {
      "customer": "John Smith",
      "products": {
        "88cd7621-d3e1-42b7-b2b8-8ca82cdac2f0": {
          "giftWrap": true,
          "notes": "It's a gift, please remove price tag"
        }
      },
      "totalPrice": 9.99
    }
  }
}
```

If we want to find all products that are part of a certain order, we iterate over the keys of the _products_ property. Each key is a product _ID_. Accessing the _productsById_ map with this _ID_ will provide us with the product details. Additional product details that are specific to this order, such as _giftWrap_, are found in the values of the _products_ map under the order.

If the process of normalizing API responses becomes tedious, take a look at generic helper libraries like [normalizr](https://github.com/paularmstrong/normalizr) which take a schema and perform the normalization process for you.

#### 7. App state can be regarded as an in-memory database

The various modeling tips we’ve covered so far should be familiar. We’ve been making similar choices when putting on our DBA hats and designing traditional [databases](https://en.wikipedia.org/wiki/Database).

When modeling traditional database structure, we’re avoiding duplication and derivatives, indexing data in map-like _tables_ using primary keys (ID’s) and normalizing relationships between several tables. Pretty much everything we’ve talked about so far.

Treating your app state as you would an in-memory database might assist you in entering the correct mindset for making better structuring decisions.


#### Treat app state as a first class citizen

If you take one thing from this post, this should be it.

During imperative programming we tend to treat code as king and spend less time worrying about “correct” models for internal implicit data structures such as state. Our app state usually finds itself scattered among various managers or controllers as private properties, growing organically.

Things are different under the declarative paradigm. In environments like React, our system is reactive to state. The state is now a first class citizen and is just as important as the code we write. It is the purpose of our Flux actions and the source of truth for our Flux views. Libraries such as Redux revolve around it and employ tools like immutability to make it more predictable.

We should spend time thinking about our app state. We should be aware of how complex it becomes and much energy our code spends over maintaining it. And we should definitely refactor it, just like we do to code that shows signs of starting to rot.
