> * 原文地址：[An Animated Intro to RxJS](https://css-tricks.com/animated-intro-rxjs/)
* 原文作者：[David Khourshid](https://css-tricks.com/author/davidkpiano/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： 
* 校对者：

# An Animated Intro to RxJS

You might have heard of RxJS, or ReactiveX, or reactive programming, or even just functional programming before. These are terms that are becoming more and more prominent when talking about the latest-and-greatest front-end technologies. And if you're anything like me, you were completely bewildered when you first tried learning about it.

According to [ReactiveX.io](http://reactivex.io/):

> ReactiveX is a library for composing asynchronous and event-based programs by using observable sequences.

That's a lot to digest in a single sentence. In this article, we're going to take a different approach to learning about RxJS (the JavaScript implementation of ReactiveX) and Observables, by creating **reactive animations**.

### Understanding Observables

An array is a collection of elements, such as `[1, 2, 3, 4, 5]`. You get all the elements immediately, and you can do things like [map](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/map), [filter](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/filter) and [map](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/map) them. This allows you to transform the collection of elements any way you'd like.

Now suppose that each element in the array occurred *over time*; that is, you don't get all elements immediately, but rather one at a time. You might get the first element at 1 second, the next at 3 seconds, and so on. Here's how that might be represented:

![](https://cdn.css-tricks.com/wp-content/uploads/2017/02/rx-article-1.svg)
This can be described as a stream of values, or a sequence of events, or more relevantly, an **observable**. 

An **observable** is a collection of values over time.

Just like with an array, you can map, filter, and more over these values to create and compose new observables. Finally, you can subscribe to these observables and do whatever you want with the final stream of values. This is where RxJS comes in.

### Getting Started with RxJS

The easiest way to start using [RxJS](http://reactivex.io/rxjs/) is to use a CDN, although there are [many ways to install it](http://reactivex.io/rxjs/manual/installation.html) depending on your project's needs.

```
HTML

<!-- the latest, minified version of RxJS -->
<scriptsrc="https://unpkg.com/@reactivex/rxjs@latest/dist/global/Rx.min.js"></script>
    
```

Once you have RxJS in your project, you can create an observable from *just about anything*:

```
JS

const aboutAnything = 42;

// From just about anything (single value).
// The observable emits that value, then completes.
const meaningOfLife$ = Rx.Observable.just(aboutAnything);

// From an array or iterable.
// The observable emits each item from the array, then completes.
const myNumber$ = Rx.Observable.from([1, 2, 3, 4, 5]);

// From a promise.
// The observable emits the result eventually, then completes (or errors).
const myData$ = Rx.Observable.fromPromise(fetch('http://example.com/users'));

// From an event.
// The observable continuously emits events from the event listener.
const mouseMove$ = Rx.Observable
  .fromEvent(document.documentElement, 'mousemove');
```

*Note: the dollar sign (`$`) at the end of the variable is just a convention to indicate that the variable is an observable.* Observables can be used to model anything that can be represented as a stream of values over time, such as events, Promises, timers, intervals, and animations.

As is, these observables don't do much of anything, at least until you actually *observe* them. A **subscription** will do just that, which is created using `.subscribe()`:

```
JS

// Whenever we receive a number from the observable,
// log it to the console.
myNumber$.subscribe(number => console.log(number));

// Result:
// > 1
// > 2
// > 3
// > 4
// > 5
```

Let's see this in practice:

[codepen](http://codepen.io/davidkpiano/pen/d6f5fa72a9b7b6c2c9141de6fa1ab93f)

```
JS

const docElm = document.documentElement;
const cardElm = document.querySelector('#card');
const titleElm = document.querySelector('#title');

const mouseMove$ = Rx.Observable
  .fromEvent(docElm, 'mousemove');

mouseMove$.subscribe(event => {
  titleElm.innerHTML = `${event.clientX}, ${event.clientY}`
});
```

From the `mouseMove$` observable, every time a `mousemove` event occurs, the subscription changes the `.innerHTML` of the `titleElm` to the position of the mouse. The [`.map`](http://reactivex.io/rxjs/class/es6/Observable.js%7EObservable.html#instance-method-map) operator (which works similar to the `Array.prototype.map` method) can help simplify things:

```
JS

// Produces e.g., {x: 42, y: 100} instead of the entire event
const mouseMove$ = Rx.Observable
  .fromEvent(docElm, 'mousemove')
  .map(event => ({ x: event.clientX, y: event.clientY }));
```

With a little math and inline styles, you can make the card rotate towards the mouse. Both `pos.y / clientHeight` and `pos.x / clientWidth` evaluate to values between 0 and 1, so multiplying that by 50 and subtracting half (25) produces values from -25 to 25, which is just what we need for our rotation values:

[codepen](http://codepen.io/davidkpiano/pen/55cb38a26b9166c41017c6512ea00209)

```
JS

const docElm = document.documentElement;
const cardElm = document.querySelector('#card');
const titleElm = document.querySelector('#title');

const { clientWidth, clientHeight } = docElm;

const mouseMove$ = Rx.Observable
  .fromEvent(docElm, 'mousemove')
  .map(event => ({ x: event.clientX, y: event.clientY }))

mouseMove$.subscribe(pos => {
  const rotX = (pos.y / clientHeight * -50) - 25;
  const rotY = (pos.x / clientWidth * 50) - 25;

  cardElm.style = `
    transform: rotateX(${rotX}deg) rotateY(${rotY}deg);
  `;
});
```

### Combining with `.merge`

Now let's say you wanted this to respond to either mouse moves or touch moves, on touch devices. Without any callback mess, you can use RxJS to combine observables in many ways. In this example, the [`.merge`](http://reactivex.io/documentation/operators/merge.html) operator can be used. Just like multiple lanes of traffic merging into a single lane, this returns a single observable containing all of the data merged from multiple observables.

![](https://cdn.css-tricks.com/wp-content/uploads/2017/02/merge.png)

	JS
	
    const touchMove$ = Rx.Observable
      .fromEvent(docElm,'touchmove').map(event =>({
        x: event.touches[0].clientX,
        y: event.touches[0].clientY
      }));const move$ = Rx.Observable.merge(mouseMove$, touchMove$);
    
    move$.subscribe(pos =>{// ...});

Go ahead, try panning around on a touch device:

[codepen](http://codepen.io/davidkpiano/pen/4a430c13f4faae099e5a34cb2a82ce6d)

There are other [useful operators for combining observables](http://reactivex.io/documentation/operators.html#combining), such as `.switch()`, `.combineLatest()`, and `.withLatestFrom()`, which we'll be looking at next.

### Adding Smooth Motion

As neat as the rotating card is, the motion a bit too rigid. Whenever the mouse (or finger) stops, the rotation instantly stops. To remedy this, linear interpolation (LERP) can be used. The general technique is described in [this great tutorial](https://codepen.io/rachsmith/post/animation-tip-lerp) by Rachel Smith. Essentially, instead of jumping from point A to B, LERP will go a fraction of the way on every animation tick. This produces a smooth transition, even when mouse/touch motion has stopped.

Let's create a function that has one job: to calculate the next value given a start value and an end value, using LERP:

```
JS

function lerp(start, end) {
  const dx = end.x - start.x;
  const dy = end.y - start.y;

  return {
    x: start.x + dx * 0.1,
    y: start.y + dy * 0.1,
  };
}
```

Short and sweet. We have a *pure* function that returns a new, linearly interpolated position value every time, by moving a current (start) position 10% closer to the next (end) position on each animation frame.

#### Schedulers and `.interval`

The question is, how do we represent animation frames in RxJS? Turns out, RxJS has something called **Schedulers** which control *when* data is emitted from an observable, among other things like when subscriptions should start receiving values.

Using [`Rx.Observable.interval()`](http://reactivex.io/documentation/operators/interval.html), you can create an observable that emits values on a regularly scheduled interval, such as every one second (`Rx.Observable.interval(1000)`). If you create a tiny interval, such as `Rx.Observable.interval(0)` and schedule it to emit values only on every animation frame using `Rx.Scheduler.animationFrame`, a value will be emitted about every 16 to 17ms, within the animation frame, as expected:

```
JS

const animationFrame$ = Rx.Observable.interval(0, Rx.Scheduler.animationFrame);
```

#### Combining with `.withLatestFrom`

To create a smooth linear interpolation, you just need to care about the latest mouse/touch position on *every animation tick*. To do that, there is an operator called [`.withLatestFrom()`](http://reactivex.io/rxjs/class/es6/Observable.js%7EObservable.html#instance-method-withLatestFrom):

```
JS

const smoothMove$ = animationFrame$
  .withLatestFrom(move$, (frame, move) => move);
```

Now, `smoothMove$` is a new observable that emits the latest values from `move$`*only* whenever `animationFrame$` emits a value. This is desired -- you don't want values emitted outside animation frames (unless you really like jank). The second argument is a function that describes what to do when combining the latest values from each observable. In this case, the only important value is the `move` value, which is all that's returned.

![](https://cdn.css-tricks.com/wp-content/uploads/2017/02/with-latest-from.png)

#### Transitioning with `.scan`

Now that you have an observable emitting the latest values from `move$` on every animation frame, it's time to add linear interpolation. The [`.scan()`](http://reactivex.io/documentation/operators/scan.html) operator "accumulates" the current value and next value from an observable, given a function that takes those values.

![](https://cdn.css-tricks.com/wp-content/uploads/2017/02/scan.png)

This is perfect for our linear interpolation use-case. Remember that our `lerp(start, end)` function takes two arguments: the `start` (current) value and the `end` (next) value.

```
JS

const smoothMove$ = animationFrame$
  .withLatestFrom(move$, (frame, move) => move)
  .scan((current, next) => lerp(current, next));
  // or simplified: .scan(lerp)
```

Now, you can subscribe to `smoothMove$` instead of `move$` to see the linear interpolation in action:

[codepen](http://codepen.io/davidkpiano/pen/YNOoEK)

### Conclusion

RxJS is *not* an animation library, of course, but handling values over time in a composable, declarative way is such a core concept to ReactiveX that animation serves as a great way to demonstrate the technology. Reactive Programming is a different way of thinking about programming, with many advantages:

- It is declarative, composable, and immutable, which avoids callback hell and makes your code more terse, reusable, and modular.
- It is very useful in dealing with all types of async data, whether it's fetching data, communicating via WebSockets, listening to external events from multiple sources, or even animations
- "Separation of concerns" - you declaratively represent the data that you expect using Observables and operators, and then deal with side effects in a single `.subscribe()` instead of sprinkling them around your code base.
- There are implementations in *so many languages* - Java, PHP, Python, Ruby, C#, Swift, and others you might not have even heard of.
- It is *not a framework*, and many popular frameworks (such as React, Angular, and Vue) work very well with RxJS.
- You can get hipster points if you want, but ReactiveX was first implemented nearly a decade ago (2009), stemming from ideas by [Conal Elliott and Paul Hudak](http://conal.net/papers/icfp97/)*two* decades ago (1997), in describing functional reactive animations (surprise surprise). Needless to say, it's battle-tested.

This article explored a number of useful parts and concepts of RxJS - creating Observables with `.fromEvent()` and `.interval()`, operating on observables with `.map()` and `.scan()`, combining multiple observables with `.merge()` and `.withLatestFrom()`, and introducing Schedulers with `Rx.Scheduler.animationFrame`. There are many other useful resources for learning RxJS:

- [ReactiveX: RxJS](http://reactivex.io/rxjs/) - the official documentation
- [RxMarbles](http://rxmarbles.com/) - for visualizing observables
- [The introduction to Reactive Programming you've been missing](https://gist.github.com/staltz/868e7e9bc2a7b8c1f754) by Andre Staltz

If you want to dive further into animating with RxJS (and getting even more declarative with CSS variables), check out [my slides from CSS Dev Conf 2016](http://slides.com/davidkhourshid/reactanim#/) and [my talk from JSConf Iceland 2016](https://www.youtube.com/watch?v=lTCukb6Zn3g) on Reactive Animations with CSS Variables. For inspiration, here's some Pens that use RxJS for animation:

- [3D Digital Clock](http://codepen.io/davidkpiano/pen/Vmyyzd)
- [Heart App Concept](http://codepen.io/davidkpiano/pen/mAoaxP)
- [Perspective Drag with RxJS](http://codepen.io/Enki/pen/eBwKgO)