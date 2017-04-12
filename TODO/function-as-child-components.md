> * 原文地址：[Function as Child Components](http://merrickchristensen.com/articles/function-as-child-components.html)
> * 原文作者：[Merrick](http://merrickchristensen.com/about.html)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# Function as Child Components #

I recently polled on Twitter regarding Higher Order Components and Function as Child, the results were surprising to me.

If you don’t know what the “Function as Child” pattern is, this article is my attempt to:

1. Teach you what it is.
2. Convince you of why it is useful.
3. Get some fetching hearts, or retweets or likes or newsletters or something, I don’t know. I just want to feel appreciated, you know?

## What are Function as Child Components? ##

“Function as Child Component”s are components that receive a function as their child. The pattern is simply implemented and enforced thanks to React’s property types.

```
classMyComponentextendsReact.Component{   
  render() {  
    return (  
        <div>
          {this.props.children('Scuba Steve')}
        </div>
    );  
  }  
}

MyComponent.propTypes = {  
  children: React.PropTypes.func.isRequired,  
};

```

That is it! By using a Function as Child Component we decouple our parent component and our child component letting the composer decide what & how to apply parameters to the child component. For example:

```
<MyComponent>
  {(name) => (
    <div>{name}</div>
  )}
</MyComponent>

```

And somebody else, using the same component could decide to apply the name differently, perhaps to an attribute:

```
<MyComponent>
  {(name) => (
    <imgsrc=’/scuba-steves-picture.jpg’alt={name} />
  )}
</MyComponent>
```

What is really neat here is that MyComponent, the Function as Child Component can manager state on behalf of components it is composed with, without making demands on how that state is leveraged by its children. Lets move on to a more realistic example.

### The Ratio Component ###

The Ratio Component will use the current device width, listen for resize events and call into its children with a width, height and some information about whether or not it has computed the size yet.

First we start out with a Function as Child Component snippet, this is common across all Function as Child Component’s and it just lets consumers know we are expecting a function as our child, not React nodes.

```
classRatioextendsReact.Component{  
  render() {  
    return (  
        {this.props.children()}  
    );  
  }  
}

Ratio.propTypes = {  
 children: React.PropTypes.func.isRequired,  
};

```

Next lets design our API, we want a ratio provided in terms of X and Y axis which we will then use the current width to compute, lets set up some internal state to manage the width and height, whether or not we have even calculated that yet, along with some propTypes and defaultProps to be good citizens for people using our component.

```
classRatioextendsReact.Component{  

  constructor() {  
    super(...arguments);  
    this.state = {  
      hasComputed: false,  
      width: 0,  
      height: 0,   
    };  
  }

  render() {  
    return (  
      {this.props.children()}  
    );  
  }  
}

Ratio.propTypes = {  
  x: React.PropTypes.number.isRequired,  
  y: React.PropTypes.number.isRequired,  
  children: React.PropTypes.func.isRequired,  
};

Ratio.defaultProps = {  
  x: 3,  
  y: 4  
};

```

Alright so we aren’t doing anything interesting yet, lets add some event listeners and actually calculate the width (accommodating as well for when our ratio changes):

```
classRatioextendsReact.Component{

  constructor() {
    super(...arguments);
    this.handleResize = this.handleResize.bind(this);
    this.state = {
      hasComputed: false,
      width: 0,
      height: 0, 
    };
  }

  getComputedDimensions({x, y}) {
    const {width} = this.container.getBoundingClientRect();
return {
      width,
      height: width * (y / x), 
    };
  }

  componentWillReceiveProps(next) {
    this.setState(this.getComputedDimensions(next));
  }

  componentDidMount() {
    this.setState({
      ...this.getComputedDimensions(this.props),
      hasComputed: true,
    });
    window.addEventListener('resize', this.handleResize, false);
  }

  componentWillUnmount() {
    window.removeEventListener('resize', this.handleResize, false);
  }

  handleResize() {
    this.setState({
      hasComputed: false,
    }, () => {
      this.setState({
        hasComputed: true,
        ...this.getComputedDimensions(this.props),
      });
    });
  }

  render() {
    return (
      <divref={(ref) => this.container = ref}>
        {this.props.children(this.state.width, this.state.height, this.state.hasComputed)}
      </div>
    );
  }
}

Ratio.propTypes = {
  x: React.PropTypes.number.isRequired,
  y: React.PropTypes.number.isRequired,
  children: React.PropTypes.func.isRequired,
};

Ratio.defaultProps = {
  x: 3,
  y: 4
};

```

Alright, so I did a lot there. We added some event listeners to listen for resize events as well as actually computing the width and height using the provided ratio. Neat, so we’ve got a width and height in our internal state, how can we share it with other components?

This is one of those things that is hard to understand because it is so simple that when you see it you think, “That can’t be all there is to it.” but this ***is***all there is to it.

#### Children is literally just a JavaScript function. ####

That means in order to pass the calculated width and height down we just provide them as parameters:

```
render() {
    return (
      <divref='container'>
        {this.props.children(this.state.width, this.state.height, this.state.hasComputed)}
      </div>
    );
}

```

Now anyone can use the ratio component to provide a full width and properly computed height in whatever way they would like! For example, someone could use the Ratio component for setting the ratio on an img:

```
<Ratio>
  {(width, height, hasComputed) => (
    hasComputed 
      ? <imgsrc='/scuba-steve-image.png'width={width}height={height} /> 
      : null
  )}
</Ratio>
```

Meanwhile, in another file, someone has decided to use it for setting CSS properties.

```
<Ratio>
  {(width, height, hasComputed) => (
    <div style={{width, height}}>Hello world!</div>
  )}
</Ratio>

```

And in another app, someone is using to conditionally render different children based on computed height:

```
<Ratio>
  {(width, height, hasComputed) => (
    hasComputed && height > TOO_TALL
      ? <TallThing />
      : <NotSoTallThing />
  )}
</Ratio>
```

### Strengths ###

1. The developer composing the components owns how these properties are passed around and used.
2. The author of the Function as Child Component doesn’t enforce how its values are leveraged allowing for very flexible use.
3. Consumers don’t need to create another component to decide how to apply properties passed in from a “Higher Order Component”. Higher Order Components typically enforce property names on the components they are composed with. To work around this many providers of “Higher Order Components” provide a selector function which allows consumers to choose your property names (think redux-connects select function). This isn’t a problem with Function as Child Components.
4. Doesn’t pollute “props” namespace, this allows you to use a “Ratio” component and a “Pinch to Zoom” component together regardless that they are both calculating width. Higher Order Components carry an implicit contract they impose on the components they are composed with, unfortunately this can mean colliding prop names being unable to compose Higher Order Components with other ones.
5. Higher Order Components create a layer of indirection in your development tools and components themselves, for example setting constants on a Higher Order Component will be unaccessible once wrapped in a Higher Order Component. For example:

```
MyComponent.SomeContant = 'SCUBA';

```

Then wrapped by a Higher Order Component,

```
exportdefault connect(...., MyComponent);

```

RIP your constant. It is no longer accessible without the Higher Order Component providing a function to access the underlying component class. Sad.

#### Summary ####

Most the time when you think “I need a Higher Order Component for this shared functionality!” I hope I have convinced you that a Function as Child Component is a better alternative for abstracting your UI concerns, in my experience it nearly always is, with the exception that your child component is truly coupled to the Higher Order Component it is composed with.

#### An Unfortunate Truth About Higher Order Components ####

As an ancillary point, I believe that Higher Order Components are improperly named though it is probably to late to try and change their name. A higher order function is a function that does at least one of the following:

1. Takes n functions as arguments.
2. Returns a function as a result.

Indeed Higher Order Components do something similar to this, namely take a Component as and argument and return a Component but I think it is easier to think of a Higher Order Component as a factory function, it is a function that dynamically creates a component to allow for runtime composition of your components. However, they are **unaware** of your React state and props at composition time!

Function as Child Components allow for similar composition of your components with the benefit of having access to state, props and context when making composition decisions. Since Function as Child Components:

1. Take a function as an argument.
2. Render the result of said function.

I can’t help but feel they should have gotten the title “Higher Order Components” since it is a lot like higher order functions only using the component composition technique instead of functional composition. Oh well, for now we will keep calling them “Function as Child Components” which is just wordy and gross sounding.

### Examples ###

1. [Pinch to Zoom - Function as Child Component](https://gist.github.com/iammerrick/c4bbac856222d65d3a11dad1c42bdcca)
2. [react-motion](https://github.com/chenglou/react-motion) This project introduced me to this concept after being a long time Higher Order Component convert.
---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
