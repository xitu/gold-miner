> * 原文地址：[Hookrouter: A Modern Approach to React Routing](https://blog.bitsrc.io/hookrouter-a-modern-approach-to-react-routing-b6e36f7d49d9)
> * 原文作者：[Isuri Devindi](https://medium.com/@isuridevindi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/hookrouter-a-modern-approach-to-react-routing.md](https://github.com/xitu/gold-miner/blob/master/article/2021/hookrouter-a-modern-approach-to-react-routing.md)
> * 译者：
> * 校对者：

# Hookrouter: A Modern Approach to React Routing

![](https://cdn-images-1.medium.com/max/5760/1*04u1ylnBHOx19jxSMkenVA.jpeg)

Routing is essential for Single Page Applications (SPAs) to navigate through pages and to initialize state. With React, I’m sure most of you have used react-router-dom, a variant of the Reactrouter library for routing.

However, with React hooks’ introduction, a new module known as the [**Hookrouter**](https://github.com/Paratron/hookrouter) has been launched very recently as a flexible, fast router based on hooks.

This article will focus on how we can use **the Hookrouter** module to replicate the Reactrouter’s basic functionalities.

---

> To demonstrate the features of Hookrouter I will be using a product store front example with four basic components namely Nav.js, Home.js, About.js, and Shop.js. Besides, the complete React app with routing using Hookrouter can be found [here](https://github.com/Isuri-Devindi/Hookrouter-demo).

## 1. Defining Routes with Hookrouter vs Reactrouter

When using Reactrouter, we can define the routes as follows.

```JavaScript
import Nav from './components/Nav';
import About from './components/About';
import Shop from './components/Shop';
import Home from './components/Home';
import {BrowserRouter as Router,Route} from'react-router-dom';

function App() {
  
  return (
    
    <Router>
    <div className="App">

      <Nav/>
      <Route path = '/'  component = {Home}/>
      <Route path = '/about' component = {About}/>
      <Route path = '/shop' component = {Shop}/>
             
    </div>
   </Router>
  );
}
export default App;
```

I hope most of you are familiar with the above example, which is relatively straightforward.

However, if we implement the same using Hookrouter, we can declare the routes as an object using the `useRoutes()` hook.

The object keys define the paths, while values are the functions triggered when the path matches. The router checks the paths one after the other and stops after a match has been found.

```JavaScript
import {useRoutes} from 'hookrouter'
import Nav from './components/Nav';
import About from './components/About';
import Shop from './components/Shop';
import Home from './components/Home';

function App() {
  const routes = {
    '/' :()=><Home/>,
    '/about' :()=> <About/>,
    '/shop' :()=> <Shop/>,
   };
  const routeResults = useRoutes(routes);
  return (
    <div className="App">
        <Nav/>
        {routeResults}
    </div>
  );
}

export default App;
```

The `\<Route/>` the component in Reactrouter has to be rendered every time, along with all the props for each route in the app. Nevertheless, with Hookrouter, the routes defined as an object can be simply passed to the `useRoutes()` hook.

> **Note:** Make sure to create the route object outside the components; otherwise, the whole object will be re-created at every render.

## 2. Implementing Switch Functionality of Reactrouter in Hookrouter

The `\<Switch>`is used to render routes exclusively by rendering the first child `\<Route>` or `\<Redirect>` that matches the location. `\<Switch>` is usually utilized to render a 404 page when the defined navigation routes are not matched.

Let’s look at how we can use `\<Switch>` to route to the 404 pages with Reactrouter.

```JavaScript
import Nav from './components/Nav';
import About from './components/About';
import Shop from './components/Shop';
import Home from './components/Home';
import Error from './components/Error';
import {BrowserRouter as Router, Switch,Route} from'react-router-dom';

function App() {
  
  return (
    
    <Router>
    <div className="App">

      <Nav/>
      <Switch>
      <Route path = '/' exact component = {Home}/>
      <Route path = '/about' component = {About}/>
      <Route path = '/shop'exact component = {Shop}/>
      <Route><Error/> </Route>
      </Switch>

     
      
    </div>
   </Router>
  );
}
export default App;
```

> When routing is done using the Hookrouter, the routes are rendered exclusively since they are defined in an object. Therefore, the useRoutes() hook performs the functionality of the \<Switch> component by default.

For instance, to route to a 404 page using Hookrouter, we only have to pass the error we want to display or the component containing the error message for rendering, as shown below (line 17).

```JavaScript
import {useRoutes} from 'hookrouter'
import Nav from './components/Nav';
import About from './components/About';
import Shop from './components/Shop';
import Home from './components/Home';

function App() {
  const routes = {
    '/' :()=><Home/>,
    '/about' :()=> <About/>,
    '/shop' :()=> <Shop/>,
   };
  const routeResults = useRoutes(routes);
  return (
    <div className="App">
        <Nav/>
        {routeResults||<h1>PAGE  NOT FOUND</h1>}
    </div>
  );
}

export default App;
```

> **Note:** An important fact I have noticed is that in Reactrouter `\<Switch>`is that if the path is not declared as exact, it might lead to erroneous routings in some cases.

For example, if the path to `{Home}` is not declared as exact, the application won’t route to any other path starting with `‘/’`. As a result, the app won’t route to `{About}` or `{Shop}` components and will always route to the Home page. However, in Hookrouter, since the routes are declared as an object, explicit declarations of “exact” for paths are not necessary.

## 3. Navigation using Hookrouter

With Reactrouter, `\<Link>` is used to navigate across the application. Besides, navigations can be customized and managed interactively in a React app using this.

```JavaScript
import React from 'react'
import {Link} from 'react-router-dom'

function Nav() {
    return (
        <div>
            <nav>
                   <ul className='nav-links'>
                      
                      <Link className='Link' to='/'>
                        <li>HOME</li>
                      </Link>
                      <Link className='Link' to='/about'>
                        <li>ABOUT</li>
                      </Link>
                      <Link className='Link' to='/shop'>
                        <li>SHOP</li>
                      </Link>

                  </ul>
                
            </nav>
        </div>
    )
}
export default Nav
```

> The Hookrouter uses a \<A> component to provide the functionality of the \<Link> component. \<A> is a wrapper around the HTML anchor tag \<a> and is 100% feature compatible with the anchor tag.

The main difference between `\<A>` and `\<Link>` is that `\<A>`pushes the URL to the history stack without loading a new page. As a result, onclick functions have to be wrapped by the `\<A>` component to intercept the click event to stop the default behavior and push the URL on the history stack.

```JavaScript
import React from 'react'
import {A} from 'hookrouter'

function Nav() {
        return (
            <div>
                <nav>
                        <ul className='nav-links'>
                          
                          <A className='Link' href='/'>
                            <li>HOME</li>
                          </A>
                          <A className='Link' href='/about'>
                            <li>ABOUT</li>
                          </A>
                          <A className='Link' href='/shop'>
                            <li>SHOP</li>
                          </A>
    
                        </ul>
                </nav>
            </div>
        )
    }
    
export default Nav
```

## 4. Handling Dynamic Routes

Some components contain dynamic portions that have to be rendered based on the URL on demand. URL parameters are used to set dynamic values in a URL. In Reactrouter, placeholders are passed to the path prop starting with a colon in the `\<Route/>` component.

To demonstrate this concept, let’s consider a list of products displayed on the application’s Shop page. The user should be directed to the Details page of a specific product when they click on it. The navigation is done dynamically, passing the product id as a placeholder in the path prop.

```JavaScript
 <Route path = '/shop/:id' component = {Details}/>
```

> In Hookrouter, the URL parameters can be passed in the same way as done in Reactrouter. The construct is the same.

```JavaScript
const routes = {
     '/shop/:id':({id})=><Details id={id}/>
  };
```

However, the Hookrouter handles the URL parameters differently.

1. It reads the URL parameters using the keys defined in the routes object
2. Puts them into an object, and the named parameters will be forwarded to the route result function as a combined object.
3. The dynamic property is extracted from the props using object destructuring, and then it can be applied to the relevant component.

Therefore, as you have seen, the same result obtained using the Reactrouter can be achieved by the Hookrouter.

## 5. Other Features of the Hookrouter

### Programmatic navigation

The navigate(url, [replace], [queryParams]) function from the Hookrouter package can be used to send users to a specific page defined by the absolute or relative URL provided. For example, to navigate to the about page, the code snippet given below can be used.

```js
navigate(‘/about’) 
```

`navigate()` by default is a forward navigation. Therefore, a new entry in the browsing history will be created, and the user can click the back button in the browser to get back to the previous page.

### Redirects

Hookrouter handles redirects with the aid of the `useRedirect()` hook. It takes a source route and a target route as parameters.

```js
useRedirect('/', '/greeting');
```

Whenever the `‘/’`path is matched, the `useRedirect()` will automatically redirect the user to the ‘/greeting’ route.

This hook triggers a replacement navigation intent. As a result, there will be only one entry in the navigation history. Therefore, if redirection happens from `‘/’` to `‘/greeting’` as shown in the last code snippet, the `‘/’ `route will not appear in the browsing history.

Many of the other Reactrouter library features (apart from the ones discussed here) can be implemented using the Hookrouter module, such as nested routing, lazy loading components, and server-side rendering.

Besides, feel free to go through the [Hookrouter documentation](https://github.com/Paratron/hookrouter/blob/master/src-docs/pages/en/README.md) to learn more about this module.

## Drawbacks

I have noticed that sometimes the Hookrouter doesn’t work with [**Strict Mode**](https://reactjs.org/docs/strict-mode.html) that is enabled by default in the latest versions of create-react-app.

However, you only have to remove the `\<React.StrictMode>` component from your index.js to use Hookrouter.

```jsx
<React.StrictMode>
  <App />
</React.StrictMode>
```

Another drawback is that since this module is relatively new, it might contain some unknown and unusual bugs resulting in unexpected behaviors.

## Conclusion

From the above demonstrations, it’s clear that the Hookrouter module offers a cleaner, faster, and more flexible alternative to handle routes in a React application.

It offers most of the Reactrouter library features. Therefore, I encourage you to go ahead and try it out for smaller projects for a start.

Thank you for reading!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
