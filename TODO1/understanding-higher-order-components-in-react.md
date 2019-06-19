> * 原文地址：[Understanding Higher-Order Components in React](https://blog.bitsrc.io/understanding-higher-order-components-in-react-12de3ab2cca5)
> * 原文作者：[Chidume Nnamdi 🔥💻🎵🎮](https://medium.com/@kurtwanger40)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-higher-order-components-in-react.md](https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-higher-order-components-in-react.md)
> * 译者：
> * 校对者：

# Understanding Higher-Order Components in React

> Your complete guide to higher-order React components

![](https://cdn-images-1.medium.com/max/2560/1*0fo4LLhFgxrhLTugpFdsmg.jpeg)

In our last post, we talked about type-checking in React; we saw how to specify the types of props in our React components despite being written in JS.

In this post we continue the streak, we will look into HOC in React.

## What is HOC?

HOC is an advanced technique in React whereby a function takes a Component argument and returns a new component.

```
function composeComponent(Component) {
    return class extends React.Component {
        render() {
            return <Component />
        }
    }

}
```

Here, the function `composeComponent` accepts an argument `Component` and returns an ES6 class component. The returned class renders the Component argument. The Component arg will be a React component which will be rendered by the returned class component.

For example:

```
class CatComponent {
    render() {
        return <div>Cat Component</div>
    }
}
```

We have a CatComponent that renders this:

```
Cat Component
```

We can pass the CatComponet to the composeComponent function to get another component:

```
const composedCatComponent = composeComponent(CatComponent)
```

The composedCatComponent can be rendered:

```
<composedCatComponent />
```

and the output will be:

```
Cat Component
```

This is the same as Higher-Order function we see in JS.

## Higher-Order Function

HO function is a pattern in JS whereby a function takes a function and returns a function as the result. This is possible because of the compositional nature of JS. It means that:

* objects
* arrays
* strings
* numbers
* boolean
* functions

can be passed to functions as arguments or returned from a function.

```
function mul(x) {
    return (y) => {
        return x * y
    }
}
const mulTwo = mul(2)

mulTwo(2) // 4
mulTwo(3) // 9
mulTwo(4) // 8
mulTwo(5) // 10
```

The `mul` function returns a function which traps `x` in a closure. This `x` is now available for the returned function to use. The `mul` is now a higher-order function because it returns a function. This means we can use it to build other, more specific functions by using different arguments.

We can use it to create a function that triples its arguments:

```
function mul(x) {
    return (y) => {
        return x * y
    }
}
const triple = mul(3)

triple(2) // 6
triple(3) // 9
triple(4) // 12
triple(5) // 15
```

**what are the benefits of HOs?** When we see ourself repeating a logic over and over. We need to find a way to place the logic in one place and use it from there. HO functions provide a pattern that we can use to implement it.

From the above example, if we continuously multiply by `3` in our app, we can create a function that returns a function that multiplies by `3` `triple`, so whenever we need to write a `multiplication by 3` code, we simply call `triple` passing the number to be multiplied by `3` as parameter.

## Cross-cutting concerns with HOC

**What are the benefits of using HOCs in our React app?**

During the course of our programming, we might find ourselves repeating the same logic over and over again.

For example, we have an app to view and edit documents. Basically, we will want to authenticate the app the app so that the only authenticated users could access the dashboard, edit a document, view a document or delete a document. We will have our routes like this:

```
<Route path="/" component={App}>
    <Route path="/dashboard" component={Documents}/>
    <Route path="document/:id/view" component={ViewDocument} />
    <Route path="documents/:id/delete" component={DelDocument} />
    <Route path="documents/:id/edit" component={EditDocument}/>
</Route>
```

We will have to auth Documents so only auth’d users can access it. We would do something like this:

```
class Doucments extends React.Component {
    componentwillMount() {
        if(!this.props.isAuth){
            this.context.router.push("/")
        }
    }
    componentWillUpdate(nextProps) {
        if(!nextProps.isAuth) {
            this.context.router.push("/")            
        }
    }
    render() {
        return <div>Documents Paegs!!!</div>
    }
}

function mapstateToProps(state) {
    isAuth: state.auth
}
export default connect(mapStateToProps)(Documents)
```

The state.auth holds the state of the user. IF the user is not auth’d it will be false, if auth’d it will be true. The connect function will map the state to the components isAuth props object. Then when the component tries to mount on the DOM the componentWillMount is fired, so there we check if the isAuth prop is true. If it is true the method passes down if not the method pushes route “/” the index page to the router which makes our browser load the index page inside of rendering the documents component effectively denying an unauth’d user access to it.

When the component tries to re-render after the initial rendering, we only do the same in the componentWillUpdate to check if the user is still auth’d, if not we load the index page.

Now we can gon to do the same in the ViewDocument:

```
class ViewDoucment extends React.Component {
    componentwillMount() {
        if(!this.props.isAuth){
            this.context.router.push("/")
        }
    }
    componentWillUpdate(nextProps) {
        if(!nextProps.isAuth) {
            this.context.router.push("/")            
        }
    }
    render() {
        return <div>View Document Page!!!</div>
    }
}

function mapstateToProps(state) {
    isAuth: state.auth
}
export default connect(mapStateToProps)(ViewDocument)
```

In the EditDocument:

```
class EditDocument extends React.Component {
    componentwillMount() {
        if(!this.props.isAuth){
            this.context.router.push("/")
        }
    }
    componentWillUpdate(nextProps) {
        if(!nextProps.isAuth) {
            this.context.router.push("/")            
        }
    }
    render() {
        return <div>Edit Document Page!!!</div>
    }
}

function mapstateToProps(state) {
    isAuth: state.auth
}
export default connect(mapStateToProps)(EditDocument)
```

In the DelDocument:

```
class DelDocument extends React.Component {
    componentwillMount() {
        if(!this.props.isAuth){
            this.context.router.push("/")
        }
    }
    componentWillUpdate(nextProps) {
        if(!nextProps.isAuth) {
            this.context.router.push("/")            
        }
    }
    render() {
        return <div>Delete Document Page!!!</div>
    }
}

function mapstateToProps(state) {
    isAuth: state.auth
}
export default connect(mapStateToProps)(DelDocument)
```

The pages do different things but their implementation is the same.

Each component:

* connect to the state via react-redux connect.
* map the state `auth` to their `props` `isAuth` property
* check for authentication in the componentWillMount
* check for authentication in the componentWillUpdate

Imagine our project grows big into many components, we find ourselves adding the above in each component. It will be quite boring for sure.

We need to need to find a way to define the logic in a single place. The best bet is to use HOC.

To do that we move all our logic into a function that will return a component:

```
function requireAuthentication(composedComponent) {
    class Authentication extends React.Component {
        componentwillMount() {
            if(!this.props.isAuth){
                this.context.router.push("/")
            }
        }
        componentWillUpdate(nextProps) {
            if(!nextProps.isAuth) {
                this.context.router.push("/")            
            }
        }
        render() {
            <ComposedComponent />
        }
    }
    function mapstateToProps(state) {
        isAuth: state.auth
    }
    return connect(mapStateToProps)(Authentication)
}
```

You see that we move all the similar implementation inside the Authentication component. The requireAuthentication function will return connect the Authentication component to the store and return it. Then the Authentication will render the component passed in through ComposedCompoennt argument.

Our routes will now look like this:

```
<Route path="/" component={App}>
    <Route path="/dashboard" component={requireAuthentication(Documents)}/>
    <Route path="document/:id/view" component={requireAuthentication(ViewDocument)} />
    <Route path="documents/:id/delete" component={requireAuthentication(DelDocument)} />
    <Route path="documents/:id/edit" component={requireAuthentication(EditDocument)}/>
</Route>
```

So you see no matter a million routes our app will have in the future, we would not worry about adding authentication to the component, we just call the requireAuthentication function with the component passed to it.

There many benefits of using HOCs. When you find yourself repeating your yourself you need to move the logic to a definite place and apply HOC.

## Conclusion

In summary a Higher-Order function:

* returns a function
* can be used to solve the DRY problem

A Higher-Order component:

* takes a component as an argument
* returns another component
* the returned component will render the original component.
* can be used to solve the DRY problem

If you have any question regarding this or anything I should add, correct or remove, feel free to comment, email or DM me

Thanks!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
