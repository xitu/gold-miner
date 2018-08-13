> * 原文地址：[HOW TO DEAL WITH DIRTY SIDE EFFECTS IN YOUR PURE FUNCTIONAL JAVASCRIPT](https://jrsinclair.com/articles/2018/how-to-deal-with-dirty-side-effects-in-your-pure-functional-javascript/)
> * 原文作者：[James Sinclair](https://jrsinclair.com/articles/2018/how-to-deal-with-dirty-side-effects-in-your-pure-functional-javascript/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-deal-with-dirty-side-effects-in-your-pure-functional-javascript.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-deal-with-dirty-side-effects-in-your-pure-functional-javascript.md)
> * 译者：
> * 校对者：

# HOW TO DEAL WITH DIRTY SIDE EFFECTS IN YOUR PURE FUNCTIONAL JAVASCRIPT

So, you’ve begun to dabble in functional programming. It won’t be long before you come across the concept of _pure functions_. And, as you go on, you will discover that functional programmers appear to be obsessed with them. “Pure functions let you reason about your code,” they say. “Pure functions are less likely to start a thermonuclear war.” “Pure functions give you referential transparency”. And on it goes. They are not wrong either. Pure functions are a good thing. But there’s a problem…

A pure function is a function that has no side effects.[1](#fn:1 "see footnote") But if you know anything about programming, you know that side effects are the _whole point_. Why bother calculating 𝜋 to 100 places if there’s no way anyone can read it? To print it out somewhere, we need to write to a console, or send data to a printer, or _something_ where someone can read it. And, what good is a database if you can’t enter any data into it? We _need_ to read data from input devices, and request information from the network. We can’t do any of it without side effects. And yet, functional programming is built around pure functions. So how do functional programmers manage to get anything done?

The short answer is, they do what mathematicians do: They cheat.

Now, when I say they cheat, they technically follow the rules. But they find loopholes in those rules and stretch them big enough to drive a herd of elephants through. There’s two main ways they do this:

1.  _Dependency injection_, or as I call it, _chucking the problem over the fence_; and
2.  _Using an Effect functor_, which I think of as _extreme procrastination_.[2](#fn:2 "see footnote")

## Dependency Injection

Dependency injection is our first method for dealing with side effects. In this approach, we take any impurities in our code, and shove them into function parameters. Then we can treat them as some other function’s responsibility. To explain what I mean, let’s look at some code:

```
// logSomething :: String -> ()
function logSomething(something) {
    const dt = (new Date()).toIsoString();
    console.log(`${dt}: ${something}`);
    return something;
}
```

Our `logSomething()` function has two sources of impurity: It creates a `Date()` and it logs to the console. So, not only does it perform IO, it also gives a different result every millisecond that you run it. So, how do you make this function pure? With dependency injection, we take any impurities and make them a function parameter. So instead of taking one parameter, our function will take three:

```
// logSomething: Date -> Console -> String -> ()
function logSomething(d, cnsl, something) {
    const dt = d.toIsoString();
    cnsl.log(`${dt}: ${something}`);
    return something;
}
```

Then to call it, we have to explicitly pass in the impure bits ourselves:

```
const something = "Curiouser and curiouser!"
const d = new Date();
logSomething(d, console, something);
// ⦘ Curiouser and curiouser!
```

Now, you may be thinking: “This is stupid. All we’ve done is shoved the problem one level up. It’s still just as impure as before.” And you’d be right. It’s totally a loophole.

YouTube 视频链接：https://youtu.be/9ZSoJDUD_bU

It’s like feigning ignorance: “Oh no officer, I had no idea that calling `log()` on that “`cnsl`” object would perform IO. Someone else just passed it to me. I’ve got no idea where it came from.” It seems a bit lame.

It’s not quite as stupid as it seems though. Notice something about our `logSomething()` function. If you want it to do something impure, you have to _make_ it impure. We could just as easily pass different parameters:

```
const d = {toISOString: () => '1865-11-26T16:00:00.000Z'};
const cnsl = {
    log: () => {
        // do nothing
    },
};
logSomething(d, cnsl, "Off with their heads!");
//  ￩ "Off with their heads!"
```

Now, our function does nothing (other than return the `something` parameter). But it is completely pure. If you call it with those same parameters, it will return the same thing every single time. And that is the point. To make it impure, we have to take deliberate action. Or, to put it another way, everything that function depends on is right there in the signature. It doesn’t access any global objects like `console` or `Date`. It makes everything explicit.

It’s also important to note, that we can pass functions to our formerly impure function too. Let’s look at another example. Imagine we have a username in a form somewhere. We’d like to get the value of that form input:

```
// getUserNameFromDOM :: () -> String
function getUserNameFromDOM() {
    return document.querySelector('#username').value;
}

const username = getUserNameFromDOM();
username;
// ￩ "mhatter"
```

In this case, we’re attempting to query the DOM for some information. This is impure, since `document` is a global object that could change at any moment. One way to make our function pure would be to pass the global `document` object as a parameter. But, we could also pass a `querySelector()` function like so:

```
// getUserNameFromDOM :: (String -> Element) -> String
function getUserNameFromDOM($) {
    return $('#username').value;
}

// qs :: String -> Element
const qs = document.querySelector.bind(document);

const username = getUserNameFromDOM(qs);
username;
// ￩ "mhatter"
```

Now, again, you may be thinking “This is still stupid!” All we’ve done is move the impurity out of `getUsernameFromDOM()`. It hasn’t gone away. We’ve just stuck it in another function `qs()`. It doesn’t seem to do much other than make the code longer. Instead of one impure function, we have two functions, one of which is still impure.

Bear with me. Imagine we want to write a test for `getUserNameFromDOM()`. Now, comparing the impure and pure versions, which one would be easier to work with? For the impure version to work at all, we need a global document object. And on top of that, it needs to have an element with the ID `username` somewhere inside it. If I want to test that outside a browser, then I have to import something like JSDOM or a headless browser. All to test one very small function. But using the second version, I can do this:

```
const qsStub = () => ({value: 'mhatter'});
const username = getUserNameFromDOM(qsStub);
assert.strictEqual('mhatter', username, `Expected username to be ${username}`);
```

Now, this doesn’t mean that you shouldn’t also create an integration test that runs in a real browser. (Or, at least a simulated one like JSDOM). But what this example does show is that `getUserNameFromDOM()` is now completely predictable. If we pass it qsStub it will always return `mhatter`. We’ve moved the unpredictability into the smaller function `qs`.

If we want to, we can keep pushing that unpredictability further and further out. Eventually, we push them right to the very edges of our code. So we end up with a thin shell of impure code that wraps around a well-tested, predictable core. As you start to build larger applications, that predictability starts to matter. A lot.

### The disadvantage of dependency injection

It is possible to create large, complex applications this way. I know [because I’ve done it](https://www.squiz.net/technology/squiz-workplace). Testing becomes easier, and it makes every function’s dependencies explicit. But it does have some drawbacks. The main one is that you end up with lengthy function signatures like this:

```
function app(doc, con, ftch, store, config, ga, d, random) {
    // Application code goes here
 }

app(document, console, fetch, store, config, ga, (new Date()), Math.random);
```

This isn’t so bad, except that you then have the issue of parameter drilling. You might need one those parameters in a very low-level function. So you have to thread the parameter down through many layers of function calls. It gets annoying. For example, you might have to pass the date down through 5 layers of intermediate functions. And none of those intermediate functions uses the date object at all. It’s not the end of the world. And it is good to be able to see those explicit dependencies. But it’s still annoying. And there is another way…

## Lazy Functions

Let’s look at the second loophole that functional programmers exploit. It starts like this: _A side effect isn’t a side effect until it actually happens_. Sounds cryptic, I know. Let’s try and make that a bit clearer. Consider this code:

```
// fZero :: () -> Number
function fZero() {
    console.log('Launching nuclear missiles');
    // Code to launch nuclear missiles goes here
    return 0;
}
```

It’s a stupid example, I know. If we want a zero in our code, we can just write it. And I know you, gentle reader, would never write code to control nuclear weapons in JavaScript. But it helps illustrate the point. This is clearly impure code. It logs to the console, and it might also start thermonuclear war. Imagine we want that zero though. Imagine a scenario where we want to calculate something _after_ missile launch. We might need to start a countdown timer or something like that. In this scenario, it would be perfectly reasonable to plan out how we’d do that calculation ahead of time. And we would want to be very careful about when those missiles take off. We don’t want to mix up our calculations in such a way that they might accidentally launch the missiles. So, what if we wrapped `fZero()` inside another function that just returned it. Kind of like a safety wrapper.

```
// fZero :: () -> Number
function fZero() {
    console.log('Launching nuclear missiles');
    // Code to launch nuclear missiles goes here
    return 0;
}

// returnZeroFunc :: () -> (() -> Number)
function returnZeroFunc() {
    return fZero;
}
```

I can run `returnZeroFunc()` as many times as I want, and so long as I don’t _call_ the return value, I am (theoretically) safe. My code won’t launch any nuclear missiles.

```
const zeroFunc1 = returnZeroFunc();
const zeroFunc2 = returnZeroFunc();
const zeroFunc3 = returnZeroFunc();
// No nuclear missiles launched.
```

Now, let’s define pure functions a bit more formally. Then we can examine our `returnZeroFunc()` function in more detail. A function is pure if:

1.  It has no observable side effects; and
2.  It is referentially transparent. That is, given the same input it always returns the same output.

Let’s check out `returnZeroFunc()`. Does it have any side effects? Well, we just established that calling `returnZeroFunc()` won’t launch any nuclear missiles. Unless you go to the extra step of calling the returned function, nothing happens. So, no side-effects here.

Is it `returnZeroFunc()` referentially transparent? That is, does it always return the same value given the same input? Well, the way it’s currently written, we can test it:

```
zeroFunc1 === zeroFunc2; // true
zeroFunc2 === zeroFunc3; // true
```

But it’s not quite pure yet. Our function `returnZeroFunc()` is referencing a variable outside its scope. To solve that, we can rewrite it this way:

```
// returnZeroFunc :: () -> (() -> Number)
function returnZeroFunc() {
    function fZero() {
        console.log('Launching nuclear missiles');
        // Code to launch nuclear missiles goes here
        return 0;
    }
    return fZero;
}
```

Our function is now pure. But, JavaScript works against us a little here. We can’t use `===` to verify referential transparency any more. This is because `returnZeroFunc()` will return always a new function reference. But you can check referential transparency by inspecting the code. Our `returnZeroFunc()` function does nothing other than return the _same_ function, every time.

This is a neat little loophole. But can we actually use it for real code? The answer is yes. But before we get to how you’d do it in practice, let’s push this idea a little further. Going back to our dangerous `fZero()` function:

```
// fZero :: () -> Number
function fZero() {
    console.log('Launching nuclear missiles');
    // Code to launch nuclear missiles goes here
    return 0;
}
```

Let’s try and use the zero that `fZero()` returns, but without starting thermonuclear war (yet). We’ll create a function that takes the zero that `fZero()` eventually returns, and adds one to it:

```
// fIncrement :: (() -> Number) -> Number
function fIncrement(f) {
    return f() + 1;
}

fIncrement(fZero);
// ⦘ Launching nuclear missiles
// ￩ 1
```

Whoops. We accidentally started thermonuclear war. Let’s try again. This time, we won’t return a number. Instead, we’ll return a function that will _eventually_ return a number:

```
// fIncrement :: (() -> Number) -> (() -> Number)
function fIncrement(f) {
    return () => f() + 1;
}

fIncrement(zero);
// ￩ [Function]
```

Phew. Crisis averted. Let’s keep going. With these two functions, we can create a whole bunch of ‘eventual numbers’:

```
const fOne   = fIncrement(zero);
const fTwo   = fIncrement(one);
const fThree = fIncrement(two);
// And so on…
```

We could also create a bunch of `f*()` functions that work with eventual values:

```
// fMultiply :: (() -> Number) -> (() -> Number) -> (() -> Number)
function fMultiply(a, b) {
    return () => a() * b();
}

// fPow :: (() -> Number) -> (() -> Number) -> (() -> Number)
function fPow(a, b) {
    return () => Math.pow(a(), b());
}

// fSqrt :: (() -> Number) -> (() -> Number)
function fSqrt(x) {
    return () => Math.sqrt(x());
}

const fFour = fPow(fTwo, fTwo);
const fEight = fMultiply(fFour, fTwo);
const fTwentySeven = fPow(fThree, fThree);
const fNine = fSqrt(fTwentySeven);
// No console log or thermonuclear war. Jolly good show!
```

Do you see what we’ve done here? Anything we would do with regular numbers, we can do with eventual numbers. Mathematicians call this [‘isomorphism’](https://en.wikipedia.org/wiki/Isomorphism). We can always turn a regular number into an eventual number by sticking it in a function. And we can get the eventual number back by calling the function. In other words we have a _mapping_ between numbers and eventual numbers. It’s more exciting than it sounds. I promise. We’ll come back to this idea soon.

This function wrapping thing is a legitimate strategy. We can keep hiding behind functions as long as we want. And so long as we never actually call any of these functions, they’re all theoretically pure. And nobody is starting any wars. In regular (non-nuclear) code, we actually _want_ those side effects, eventually. Wrapping everything in a function lets us control those effects with precision. We decide exactly when those side effects happen. But, it’s a pain typing those brackets everywhere. And it’s annoying to create new versions of every function. We’ve got perfectly good functions like `Math.sqrt()` built into the language. It would be nice if there was a way to use those ordinary functions with our delayed values. Enter the Effect functor.

## The Effect Functor

For our purposes, the Effect functor is nothing more than an object that we stick our delayed function in. So, we’ll stick our `fZero` function into an Effect object. But, before we do that, let’s take the pressure down a notch:

```
// zero :: () -> Number
function fZero() {
    console.log('Starting with nothing');
    // Definitely not launching a nuclear strike here.
    // But this function is still impure.
    return 0;
}
```

Now we create a constructor function that creates an Effect object for us:

```
// Effect :: Function -> Effect
function Effect(f) {
    return {};
}
```

Not much to look at so far. Let’s make it do something useful. We want to use our regular `fZero()` function with our Effect. We’ll write a method that will take a regular function, and _eventually_ apply it to our delayed value. And we’ll do it _without triggering the effect_. We call it `map`. This is because it creates a _mapping_ between regular functions and Effect functions. It might look something like this:

```
// Effect :: Function -> Effect
function Effect(f) {
    return {
        map(g) {
            return Effect(x => g(f(x)));
        }
    }
}
```

Now, if you’re paying attention, you may be wondering about `map()`. It looks suspiciously like compose. We’ll come back to that later. For now, let’s try it out:

```
const zero = Effect(fZero);
const increment = x => x + 1; // A plain ol' regular function.
const one = zero.map(increment);
```

Hmm. We don’t really have a way to see what happened. Let’s modify Effect so we have a way to ‘pull the trigger’, so to speak:

```
// Effect :: Function -> Effect
function Effect(f) {
    return {
        map(g) {
            return Effect(x => g(f(x)));
        },
        runEffects(x) {
            return f(x);
        }
    }
}

const zero = Effect(fZero);
const increment = x => x + 1; // Just a regular function.
const one = zero.map(increment);

one.runEffects();
// ⦘ Starting with nothing
// ￩ 1
```

And if we want to, we can keep calling that map function:

```
const double = x => x * 2;
const cube = x => Math.pow(x, 3);
const eight = Effect(fZero)
    .map(increment)
    .map(double)
    .map(cube);

eight.runEffects();
// ⦘ Starting with nothing
// ￩ 8
```

Now, this is where it starts to get interesting. We called this a ‘functor’. All that means is that Effect has a `map` function, and it [obeys some rules](https://github.com/fantasyland/fantasy-land#functor). These rules aren’t the kind of rules for things you _can’t_ do though. They’re rules for things you _can_ do. They’re more like privileges. Because Effect is part of the functor club, there are certain things it gets to do. One of those is called the ‘composition rule’. It goes like this:

  
If we have an Effect `e`, and two functions `f`, and `g`  
Then `e.map(g).map(f)` is equivalent to `e.map(x => f(g(x)))`.  
  

To put it another way, doing two maps in a row is equivalent to composing the two functions. Which means Effect can do things like this (recall our example above):

```
const incDoubleCube = x => cube(double(increment(x)));
// If we're using a library like Ramda or lodash/fp we could also write:
// const incDoubleCube = compose(cube, double, increment);
const eight = Effect(fZero).map(incDoubleCube);
```

And when we do that, we are _guaranteed_ to get the same result as our triple-map version. We can use this to refactor our code, with confidence that our code will not break. In some cases we can even make performance improvements by swapping between approaches.

But enough with the number examples. Let’s do something more like ‘real’ code.

### A shortcut for making Effects

Our Effect constructor takes a function as its argument. This is convenient, because most of the side effects we want to delay are also functions. For example, `Math.random()` and `console.log()` are both this type of thing. But sometimes we want to jam a plain old value into an Effect. For example, imagine we’ve attached some sort of config object to the `window` global in the browser. We want to get a a value out, but this is will not be a pure operation. We can write a little shortcut that will make this task easier:[3](#fn:3 "see footnote")

```
// of :: a -> Effect a
Effect.of = function of(val) {
    return Effect(() => val);
}
```

To show how this might be handy, imagine we’re working on a web application. This application has some standard features like a list of articles and a user bio. But _where_ in the HTML these components live changes for different customers. Since we’re clever engineers, we decide to store their locations in a global config object. That way we can always locate them.fe For example:

```
window.myAppConf = {
    selectors: {
        'user-bio':     '.userbio',
        'article-list': '#articles',
        'user-name':    '.userfullname',
    },
    templates: {
        'greet':  'Pleased to meet you, {name}',
        'notify': 'You have {n} alerts',
    }
};
```

Now, with our `Effect.of()` shortcut, we can quickly shove the value we want into an Effect wrapper like so:

```
const win = Effect.of(window);
userBioLocator = win.map(x => x.myAppConf.selectors['user-bio']);
// ￩ Effect('.userbio')
```

### Nesting and un-nesting Effects

Mapping Effects thing can get us a long way. But sometimes we end up mapping a function that also returns an Effect. We’ve already defined `getElementLocator()` which returns an Effect containing a string. If we actually want to locate the DOM element, then we need to call `document.querySelector()`—another impure function. So we might purify it by returning an Effect instead:

```
// $ :: String -> Effect DOMElement
function $(selector) {
    return Effect.of(document.querySelector(s));
}
```

Now if we want to put those two together, we can try using `map()`:

```
const userBio = userBioLocator.map($);
// ￩ Effect(Effect(<div>))
```

What we’ve got is a bit awkward to work with now. If we want to access that div, we have to map with a function that also maps the thing we actually want to do. For example, if we wanted to get the `innerHTML` it would look something like this:

```
const innerHTML = userBio.map(eff => eff.map(domEl => domEl.innerHTML));
// ￩ Effect(Effect('<h2>User Biography</h2>'))
```

Let’s try picking that apart a little. We’ll back all the way up to `userBio` and move forward from there. It will be a bit tedious, but we want to be clear about what’s going on here. The notation we’ve been using, `Effect('user-bio')` is a little misleading. If we were to write it as code, it would look more like so:

```
Effect(() => '.userbio');
```

Except that’s not accurate either. What we’re really doing is more like:

```
Effect(() => window.myAppConf.selectors['user-bio']);
```

Now, when we map, it’s the same as composing that inner function with another function (as we saw above). So when we map with `$`, it looks a bit like so:

```
Effect(() => window.myAppConf.selectors['user-bio']);
```

Expanding that out gives us:

```
Effect(
    () => Effect.of(document.querySelector(window.myAppConf.selectors['user-bio'])))
);
```

And expanding `Effect.of` gives us a clearer picture:

```
Effect(
    () => Effect(
        () => document.querySelector(window.myAppConf.selectors['user-bio'])
    )
);
```

Note: All the code that actually does stuff is in the innermost function. None of it has leaked out to the outer Effect.

#### Join

Why bother spelling all that out? Well, we want to un-nest these nested Effects. If we’re going to do that, we want to make certain that we’re not bringing in any unwanted side-effects in the process. For Effect, the way to un-nest, is to call `.runEffects()` on the outer function. But this might get confusing. We’ve gone through this whole exercise to check that we’re _not_ going to run any effects. So we’ll create another function that does the same thing, and call it `join`. We use `join` when we’re un-nesting Effects, and `runEffects()` when we actually want to run effects. That makes our intention clear, even if the code we run is the same.

```
// Effect :: Function -> Effect
function Effect(f) {
    return {
        map(g) {
            return Effect(x => g(f(x)));
        },
        runEffects(x) {
            return f(x);
        }
        join(x) {
            return f(x);
        }
    }
}
```

We can then use this to un-nest our user biography element:

```
const userBioHTML = Effect.of(window)
    .map(x => x.myAppConf.selectors['user-bio'])
    .map($)
    .join()
    .map(x => x.innerHTML);
// ￩ Effect('<h2>User Biography</h2>')
```

#### Chain

This pattern of running `.map()` followed by `.join()` comes up often. So often in fact, that it would be handy to have a shortcut function. That way, whenever we have a function that returns an Effect, we can use this shortcut. It saves us writing `map` then `join` over and over. We’d write it like so:

```
// Effect :: Function -> Effect
function Effect(f) {
    return {
        map(g) {
            return Effect(x => g(f(x)));
        },
        runEffects(x) {
            return f(x);
        }
        join(x) {
            return f(x);
        }
        chain(g) {
            return Effect(f).map(g).join();
        }
    }
}
```

We call the new function `chain()` because it allows us to chain together Effects. (That, and because the standard tells us to call it that).[4](#fn:4 "see footnote") Our code to get the user biography inner HTML would then look more like this:

```
const userBioHTML = Effect.of(window)
    .map(x => x.myAppConf.selectors['user-bio'])
    .chain($)
    .map(x => x.innerHTML);
// ￩ Effect('<h2>User Biography</h2>')
```

Unfortunately, other programming languages use a bunch of different names for this idea. It can get a little bit confusing if you’re trying to read up about it. Sometimes it’s called `flatMap`. This name makes a lot of sense, as we’re doing a regular mapping, then flattening out the result with `.join()`. In Haskell though, it’s given the confusing name of `bind`. So if you’re reading elsewhere, keep in mind that `chain`, `flatMap` and `bind` refer to similar concepts.

### Combining Effects

There’s one final scenario where working with Effect might get a little awkward. It’s where we want to combine two or more Effects using a single function. For example, what if we wanted to grab the user’s name from the DOM? And then insert it into a template provided by our app config? So, we might have a template function like this (note that we’re creating a curried version):

```
// tpl :: String -> Object -> String
const tpl = curry(function tpl(pattern, data) {
    return Object.keys(data).reduce(
        (str, key) => str.replace(new RegExp(`{${key}}`, data[key]),
        pattern
    );
});
```

That’s all well and good. But let’s grab our data:

```
const win = Effect.of(window);
const name = win.map(w => w.myAppConfig.selectors['user-name'])
    .chain($)
    .map(el => el.innerHTML)
    .map(str => ({name: str});
// ￩ Effect({name: 'Mr. Hatter'});

const pattern = win.map(w => w.myAppConfig.templates('greeting'));
// ￩ Effect('Pleased to meet you, {name}');
```

We’ve got a template function. It takes a string and an object, and returns a string. But our string and object (`name` and `pattern`) are wrapped up in Effects. What we want to do is _lift_ our `tpl()` function up into a higher plane so that it works with Effects.

Let’s start out by seeing what happens if we call `map()` with `tpl()` on our pattern Effect:

```
pattern.map(tpl);
// ￩ Effect([Function])
```

Looking at the types might make things a little clearer. The type signature for map is something like this:

    _map :: Effect a ~> (a -> b) -> Effect b_

And our template function has the signature:

    _tpl :: String -> Object -> String_

So, when we call map on `pattern`, we get a _partially applied_ function (remember we curried `tpl`) inside an Effect.

    _Effect (Object -> String)_

We now want to pass in the value from inside our pattern Effect. But we don’t really have a way to do that yet. We’ll write another method for Effect (called `ap()`) that will take care of this:

```
// Effect :: Function -> Effect
function Effect(f) {
    return {
        map(g) {
            return Effect(x => g(f(x)));
        },
        runEffects(x) {
            return f(x);
        }
        join(x) {
            return f(x);
        }
        chain(g) {
            return Effect(f).map(g).join();
        }
        ap(eff) {
             // If someone calls ap, we assume eff has a function inside it (rather than a value).
            // We'll use map to go inside off, and access that function (we'll call it 'g')
            // Once we've got g, we apply the value inside off f() to it
            return eff.map(g => g(f()));
        }
    }
}
```

With that in place, we can run `.ap()` to apply our template:

```
const win = Effect.of(window);
const name = win.map(w => w.myAppConfig.selectors['user-name'])
    .chain($)
    .map(el => el.innerHTML)
    .map(str => ({name: str}));

const pattern = win.map(w => w.myAppConfig.templates('greeting'));

const greeting = name.ap(pattern.map(tpl));
// ￩ Effect('Pleased to meet you, Mr Hatter')
```

We’ve achieved our goal. But I have a confession to make… The thing is, I find `ap()` confusing sometimes. It’s hard to remember that I have to map the function in first, and then run `ap()` after. And then I forget which order the parameters are applied. But there is a way around this. Most of the time, what I’m trying to do is _lift_ an ordinary function up into the world of applicatives. That is, I’ve got plain functions, and I want to make them work with things like Effect that have an `.ap()` method. We can write a function that will do this for us:

```
// liftA2 :: (a -> b -> c) -> (Applicative a -> Applicative b -> Applicative c)
const liftA2 = curry(function liftA2(f, x, y) {
    return y.ap(x.map(f));
    // We could also write:
    //  return x.map(f).chain(g => y.map(g));
});
```

We’ve called it `liftA2()` because it lifts a function that takes two arguments. We could similarly write a `liftA3()` like so:

```
// liftA3 :: (a -> b -> c -> d) -> (Applicative a -> Applicative b -> Applicative c -> Applicative d)
const liftA3 = curry(function liftA3(f, a, b, c) {
    return c.ap(b.ap(a.map(f)));
});
```

Notice that `liftA2` and `liftA3` don’t ever mention Effect. In theory, they can work with any object that has a compatible `ap()` method.

Using `liftA2()` we can rewrite our example above as follows:

```
const win = Effect.of(window);
const user = win.map(w => w.myAppConfig.selectors['user-name'])
    .chain($)
    .map(el => el.innerHTML)
    .map(str => ({name: str});

const pattern = win.map(w => w.myAppConfig.templates['greeting']);

const greeting = liftA2(tpl)(pattern, user);
// ￩ Effect('Pleased to meet you, Mr Hatter')
```

## So What?

At this point, you may be thinking ‘This seems like a lot of effort to go to just to avoid the odd side effect here and there.’ What does it matter? Sticking things inside Effects, and wrapping our heads around `ap()` seems like hard work. Why bother, when the impure code works just fine? And when would you ever _need_ this in the real world?

> The functional programmer sounds rather like a mediæval monk, denying himself the pleasures of life in the hope it will make him virtuous.
> 
> —John Hughes[5](#fn:5 "see footnote")

Let’s break those objections down into two questions:

1.  Does functional purity really matter? and
2.  When would this Effect thing ever be useful in the real world?

### Functional Purity Matters

It’s true. When you look at a small function in isolation, a little bit of impurity doesn’t matter. Writing `const pattern = window.myAppConfig.templates['greeting'];` is quicker and simpler than something like this:

```
const pattern = Effect.of(window).map(w => w.myAppConfig.templates('greeting'));
```

And _if that was all you ever did_, that would remain true. The side effect wouldn’t matter. But this is just one line of code—in an application that may contain thousands, even millions of lines of code. Functional purity starts to matter a lot more when you’re trying to work out why your app has mysteriously stopped working ‘for no reason’. Something unexpected has happened. You’re trying to break the problem down and isolate its cause. In those circumstances, the more code you can rule out the better. If your functions are pure, then you can be confident that the only thing affecting their behaviour are the inputs passed to it. And this narrows down the number of things you need to consider… err… considerably. In other words, it allows you to _think less_. In a large, complex application, this is a Big Deal.

### The Effect pattern in the real world

Okay. Maybe functional purity matters if you’re building a large, complex applications. Something like Facebook or Gmail. But what if you’re not doing that? Let’s consider a scenario that will become more and more common. You have some data. Not just a little bit of data, but a _lot_ of data. Millions of rows of it, in CSV text files, or huge database tables. And you’re tasked with processing this data. Perhaps you’re training an artificial neural network to build an inference model. Perhaps you’re trying to figure out the next big cryptocurrency move. Whatever. The thing is, it’s going to take a lot of processing grunt to get the job done.

Joel Spolsky argues convincingly that [functional programming can help us out here](https://www.joelonsoftware.com/2006/08/01/can-your-programming-language-do-this/). We could write alternative versions of `map` and `reduce` that will run in parallel. And functional purity makes this possible. But that’s not the end of the story. Sure, you can write some fancy parallel processing code. But even then, your development machine still only has 4 cores (or maybe 8 or 16 if you’re lucky). That job is still going to take forever. Unless, that is, you can run it on _heaps_ of processors… something like a GPU, or a whole cluster of processing servers.

For this to work, you’d need to _describe_ the computations you want to run. But, you want to describe them _without actually running them_. Sound familiar? Ideally, you’d then pass the description to some sort of framework. The framework would take care of reading all the data in, and splitting it up among processing nodes. Then the same framework would pull the results back together and tell you how it went. This how TensorFlow works.

> TensorFlow™ is an open source software library for high performance numerical computation. Its flexible architecture allows easy deployment of computation across a variety of platforms (CPUs, GPUs, TPUs), and from desktops to clusters of servers to mobile and edge devices. Originally developed by researchers and engineers from the Google Brain team within Google’s AI organization, it comes with strong support for machine learning and deep learning and the flexible numerical computation core is used across many other scientific domains.
> 
> —TensorFlow home page[6](#fn:6 "see footnote")

When you use TensorFlow, you don’t use the normal data types from the programming language you’re writing in. Instead, you create ‘Tensors’. If we wanted to add two numbers, it would look something like this:

```
node1 = tf.constant(3.0, tf.float32)
node2 = tf.constant(4.0, tf.float32)
node3 = tf.add(node1, node2)
```

The above code is written in Python, but it doesn’t look so very different from JavaScript, does it? And like with our Effect, the `add` code won’t run until we tell it to (using `sess.run()`, in this case):

```
print("node3: ", node3)
print("sess.run(node3): ", sess.run(node3))
#⦘ node3:  Tensor("Add_2:0", shape=(), dtype=float32)
#⦘ sess.run(node3):  7.0
```

We don’t get 7.0 until we call `sess.run()`. As you can see, it’s much the same as our delayed functions. We plan out our computations ahead of time. Then, once we’re ready, we pull the trigger to kick everything off.

## Summary

We’ve covered a lot of ground. But we’ve explored two ways to handle functional impurity in our code:

1.  Dependency injection; and
2.  The Effect functor.

Dependency injection works by moving the impure parts of the code out of the function. So you have to pass them in as parameters. The Effect functor, in contrast, works by wrapping everything behind a function. To run the effects, we have to make a deliberate effort to run the wrapper function.

Both approaches are cheats. They don’t remove the impurities entirely, they just shove them out to the edges of our code. But this is a good thing. It makes explicit which parts of the code are impure. This can be a real advantage when attempting to debug problems in complex code bases.

* * *

1.  This is not a complete definition, but will do for the moment. We will come back to the formal definition later. [ ↩](#fnref:1 "return to body")
    
2.  In other languages (like Haskell) this is called an IO functor or an IO monad. [PureScript](http://www.purescript.org/) uses the term _Effect_. And I find it is a little more descriptive. [ ↩](#fnref:2 "return to body")
    
3.  Note that different languages have different names for this shortcut. In Haskell, for example, it's called `pure`. I have no idea why. [ ↩](#fnref:3 "return to body")
    
4.  In this case, the standard is the [Fantasy Land specification for Chain](https://github.com/fantasyland/fantasy-land#chain). [ ↩](#fnref:4 "return to body")
    
5.  John Hughes, 1990, ‘Why Functional Programming Matters’, _Research Topics in Functional Programming_ ed. D. Turner, Addison–Wesley, pp 17–42, [https://www.cs.kent.ac.uk/people/staff/dat/miranda/whyfp90.pdf](https://www.cs.kent.ac.uk/people/staff/dat/miranda/whyfp90.pdf) [ ↩](#fnref:5 "return to body")
    
6.  _TensorFlow™: An open source machine learning framework for everyone,_ [https://www.tensorflow.org/](https://www.tensorflow.org/), 12 May 2018. [ ↩](#fnref:6 "return to body")
    

*   [Let me know your thoughts via the Twitters](https://twitter.com/share?url=http://jrsinclair.com/articles/2018/how-to-deal-with-dirty-side-effects-in-your-pure-functional-javascript&text=%E2%80%9CHow to deal with dirty side effects in your pure functional JavaScript%E2%80%9D+by+%40jrsinclair)
*   [Subscribe to receive updates via the electronic mail system](/subscribe.html)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
