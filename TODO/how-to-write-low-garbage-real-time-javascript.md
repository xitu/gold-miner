>* 原文链接 : [How to write low garbage real-time Javascript](https://www.scirra.com/blog/76/how-to-write-low-garbage-real-time-javascript)
* 原文作者 : [Ashley ](https://www.scirra.com/users/ashley)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:

_Edit 27th March 2012: wow, this article went a long way, thanks for the great response! There has been some criticism of some of the techniques here, such as the use of 'delete'. I'm aware things like that can cause other slowdowns, we use it very very sparingly in our engine. As always everything involves tradeoffs and you have to use judgement to balance GC with other concerns. This is simply a list of techniques we've found useful in our engine and was not meant to be a complete reference. I hope it's still somehow useful though!_

For HTML5 games written in Javascript, one of the biggest obstacles to a smooth experience is **garbage collection (GC) pauses.** Javascript doesn't have explicit memory management, meaning you create things but don't release them. Sooner or later the browser decides to clean up: execution is paused, the browser figures out which parts of memory are still currently in use, and then releases everything else. This blog post will go in to the technical details of avoiding GC overhead, which should also come in handy for any plugin or behavior developers working with Construct 2's [Javascript SDK](http://www.scirra.com/manual/15/sdk "Construct 2 Javascript Plugin and Behavior SDK").

There are lots of techniques browsers can employ to reduce GC pauses, but if your code creates a lot of garbage, sooner or later it's going to have to pause and clean up. This results in zig-zag memory usage graphs, as objects are gradually created, then the browser suddenly cleans up. For example, below is a graph of Chrome's memory usage while playing Space Blaster.

![Chrome garbage-collected memory usage](https://www.scirra.com/images/chromememoryusage.png)  

_Zig-zag memory usage while playing a Javascript game. This can be mistaken for a memory leak, but is in fact the normal operation of Javascript._

Further, a game running at 60 fps only has 16ms to render each frame, and GC collection can easily take 100ms or more - resulting in a visible pause, or in even worse situations, a constantly choppy play experience. Therefore, for real-time Javascript code like game engines, the solution is to try and reach the point where _you create nothing at all_ during a typical frame. This is surprisingly difficult, because there are many innocuous looking Javascript statements that actually create garbage, and they _all_ have to be removed from the per-frame code path. In Construct 2 we've gone to great lengths to minimise the garbage overhead in the per-tick engine, but as you can see from the graph above there's still a small rate of object creation that Chrome is cleaning up every several seconds. Note it's only a small dip though - there isn't a large amount of memory being cleaned up. A taller, more extreme zig-zag would be a cause for concern. However it's probably good enough, since small collections are quicker, and the occasional small pause is not generally too noticable - and as we shall see, sometimes it's extremely difficult to avoid new allocations.

It's also important for third-party plugin and behavior developers to follow these guidelines. Otherwise, a badly written plugin can create lots of garbage and cause the game to become choppy, even though the main Construct 2 engine is very low-garbage.

### Simple techniques

First of all, most obviously, the `new` keyword indicates an allocation, e.g. `new Foo()`. Where possible, try to create the object on startup, and simply **re-use the same object** for as long as possible.

Less obviously, there are three syntax shortcuts for common uses of `new`:

`{}` _(creates a new object)_  
`[]` _(creates a new array)_  
`function () { ... }` _(creates a new function, which are also garbage-collected!)_

For objects, avoid `{}` the same way you avoid `new` - try to recycle objects. Note this includes objects with properties like `{ "foo": "bar" }`, which is also commonly used in functions to return multiple values at once. It may be better to write the return value to the same (global) object every time and return that - providing you document this carefully, since you can cause bugs if you keep referencing the returned object which will change on every call!

You can actually re-cycle an existing object (providing it has no prototype chain) by deleting all of its properties, restoring it to an empty object like `{}`. For this you can use the `cr.wipe(obj)` function, defined as:

    // remove all own properties on obj,
    effectively reverting it to a new object
    cr.wipe = function (obj)
    {
    	for (var p in obj)
    	{
    		if (obj.hasOwnProperty(p))
    			delete obj[p];
    	}
    };

So in some cases you can re-use an object by calling `cr.wipe(obj)` and adding properties again. Wiping an object may take longer on-the-spot than simply assigning `{}`, but in real-time code it's much more important to avoid building up garbage which will later result in a pause.

Assigning `[]` to an array is often used as a shorthand to clear it (e.g. `arr = [];`), but note this creates a new empty array and garbages the old one! It's better to write `arr.length = 0;` which has the same effect but while re-using the same array object.

Functions are a bit trickier. Functions are commonly created at startup and don't tend to be allocated at run-time so much - but this means it's easy to overlook the cases where they are dynamically created. One example is functions which return functions. The main game loop typically uses `setTimeout` or `requestAnimationFrame` to call a member function something like this:

<pre>setTimeout((function (self) { return function () {
self.tick(); }; })(this), 16);</pre>

This looks like a reasonable way to call `this.tick()` every 16 ms. However, it also means every tick it returns a new function! This can be avoided by storing the function permanently, like so:



    // at startup
    this.tickFunc = (function (self) { return function () {
    self.tick(); }; })(this);

    // in the tick() function
    setTimeout(this.tickFunc, 16); 

This re-uses the same function every tick rather than spawning a new one. The same idea can be applied anywhere else functions are returned or otherwise created at runtime.

### Advanced techniques

As we progress further avoiding garbage becomes more difficult, since Javascript is so fundamentally designed around the GC. Many of the convenient library functions in Javascript also create new objects. There is not much you can do here but go back to the documentation and look up the return values. For example, the array `slice()` method returns a new array (based on a range in the original array, which remains untouched), string's `substr` returns a new string (based on a range of characters in the original string, which remains untouched), and so on. Calling these functions creates garbage, and all you can do is either not call them, or in extreme cases re-write the functions in a way which does not create garbage. For example in the Construct 2 engine, for various reasons a regular operation is to delete the element at an index from an array. This convenient snippet was originally used for this:

    var sliced = arr.slice(index + 1);
    arr.length = index;
    arr.push.apply(arr, sliced);

However, `slice()` returns a new array object with the latter part of the array, and it becomes garbage after being copied back in (`arr.push.apply`). Since this was a hot spot for garbage creation in our engine, it was rewritten to an iterative version:

    for (var i = index, len = arr.length - 1; i < len; i++)
    	arr[i] = arr[i + 1];

    arr.length = len;

Obviously rewriting a lot of library functions is a huge pain, so you have to carefully balance the needs of convenience versus garbage creation. If it's called many times per frame, you may well want to rewrite a library function yourself.

It can be tempting to use `{}` syntax to pass data along in recursive functions. This is better done with a single array representing a stack which you push and pop for each level of recursion. Better yet, don't actually pop the array - you'll garbage the last object in the array. Instead use a 'top index' variable which you simply decrement. Then instead of pushing, increment the top index and re-use the next object in the array if there is one, otherwise do a real push.

Also, **avoid vector objects if at all possible** (as in vector2 with x and y properties). While again it may be convenient to have functions return these objects so they can change or return both values at once, you can easily end up with hundreds of these created _every frame_, resulting in terrible GC performance. These functions must be separated out to work on each component separately, e.g. instead of `getPosition()` returning a vector2 object, have `getX()` and `getY()`.

Sometimes you're stuck with a library which is a garbage nightmare. The Box2Dweb library is a prime example: it spawns hundreds of b2Vec2 objects every frame constantly spraying the browser with garbage, and can end up causing significant garbage collector pauses. The best thing to do in this situation is create a recycling cache. We've been testing a modified version of Box2D ([Box2Dweb-closure](https://github.com/illandril/box2dweb-closure)) that does this and it seems to help alleviate (although not entirely solve) GC pauses. See the code for `Get` and `Free` in [b2Vec2.js](https://github.com/illandril/box2dweb-closure/blob/master/src/common/math/b2Vec2.js). There's an array called the 'free cache', and throughout the code if there's a b2Vec2 which is known to be no longer used, it is freed, which puts it in the free cache. When requesting a new b2Vec2, if there are any in the free cache they are re-used, otherwise a new one is allocated. It's not perfect, since by some measurements I made often only half the b2Vec2s created get recycled, but it does relieve the pressure on the GC helping there be less frequent pauses.

### Conclusion

It's difficult avoiding garbage entirely in Javascript. The garbage-collection pattern is fundamentally at odds with the requirements of real-time software like games. It can also be a lot of work to eliminate garbage from Javascript code since there's a lot of straightforward code out there which has the side-effect of creating loads of garbage. However, with care and attention, it is possible to craft real-time Javascript with little to no garbage collector overhead, and this is essential for games and apps which need to be highly responsive.

