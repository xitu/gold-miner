> * 原文地址：[Beyond console.log()](https://medium.com/@mattburgess/beyond-console-log-2400fdf4a9d8)
> * 原文作者：[Matt Burgess](https://medium.com/@mattburgess?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/beyond-console-log.md](https://github.com/xitu/gold-miner/blob/master/TODO1/beyond-console-log.md)
> * 译者：
> * 校对者：

# Beyond console.log()

## There is more to debugging JavaScript than console.log to output values. It might seem obvious I’m going to pimp the debugger, but actually no.

![](https://cdn-images-1.medium.com/max/2000/1*uUhNZZObj6zD9_qxrDTD9w.jpeg)

It seems like it’s cool to tell people doing JavaScript that they should be using the browser’s debugger, and there’s certainly a time and a place for that. But a lot of the time you just want to see whether a particular bit of code executes or what a variable is, **without** disappearing into the RxJS codebase or the bowels of a Promise library.

Nevertheless, while `console.log` has its place, a lot of people don’t realise that the `console` itself has a lot of options beyond the basic `log`. Appropriate use of these functions can make debugging easier, faster, and more intuitive.

### console.log()

There is a surprising amount of functionality in good old console.log that people don’t expect. While most people use it as `console.log(object)`, you can also do `console.log(object, otherObject, string)` and it will log them all out neatly. Occasionally handy.

More than that, there’s another format: `console.log(msg, values)`. This works a lot like something like `sprintf` in C or PHP.

```
console.log('I like %s but I do not like %s.', 'Skittles', 'pus');
```

Will output exactly as you’d expect.

```
> I like Skittles but I do not like pus.
```

Common placeholders are `%o` (that’s a letter o, not a zero) which takes an object, `%s` which takes a string, and `%d` which is for a decimal or integer.

![](https://cdn-images-1.medium.com/max/800/1*k36EIUqbxmWeYwZVqOrzNQ.png)

Another fun one is `%c` but your mileage may vary on this. It’s actually a placeholder for CSS values.

```
console.log('I am a %cbutton', 'color: white; background-color: orange; padding: 2px 5px; border-radius: 2px');
```

![](https://cdn-images-1.medium.com/max/800/1*LetSPI-9ubOuADejUa_YSA.png)

The values will run onto anything that follows, there’s no “end tag”, which is a bit weird. But you can mangle it a bit like this.

![](https://cdn-images-1.medium.com/max/800/1*cHWO5DRw9c2z9Jv_Fx2AvQ.png)

It’s not elegant, nor is it particularly useful. That’s not really a button, of course.

![](https://cdn-images-1.medium.com/max/800/1*0qgPtZGOZKBKPi1Va5wf2A.png)

Again, is it useful? Ehhhhh.

### **console.dir()**

For the most part, `console.dir()` functions very much like `log()`, though it looks a teeny bit different.

![](https://cdn-images-1.medium.com/max/800/1*AUEqpGMNKtp28OK057V3Ow.png)

Dropping down the little arrow will show the same exact object details as above, which can also be seen from the `console.log` version. Where things diverge more drasically, and more interesting, is when you look at elements.

```
let element = document.getElementById('2x-container');
```

This is the output from logging that input:

![](https://cdn-images-1.medium.com/max/800/1*l7ujPmSWwpH7QtXCZ-jk2Q.png)

I’ve popped open a few elements. This is clearly showing the DOM, and we can navigate through it. But `console.dir(element)` gives us a surprisingly different output.

![](https://cdn-images-1.medium.com/max/800/1*CERwy7Fs7tdijOxugLW54A.png)

This is a way more _objecty_ way of looking at the element. There may be times when that’s what you actually want, something more like inspecting the element.

### console.warn()

Probably the most obvious direct replacement for `log()`, you can just use `console.warn()` in exactly the same way. The only real difference is the output is a bit yellow. Specifically the output is at a warning level not an info level, so the browser will treat it slightly differently. This has the effect of making it a bit more obvious in a cluttered output.

There’s a bigger advantage, though. Because the output is a warning rather than an info, you can filter out all the `console.log` and leave only `console.warn`. This is particularly helpful in those occasionally chatty apps that constantly output a bunch of useless nonsense to the browser. Clearing the noise can let you see your output much more easily.

### console.table()

It’s surprising that this isn’t better known, but the `console.table()` function is intended to display tabular data in a way that’s much neater than just dumping out the raw array of objects.

As an example, here’s a list of data.

```
const transactions = [{
  id: "7cb1-e041b126-f3b8",
  seller: "WAL0412",
  buyer: "WAL3023",
  price: 203450,
  time: 1539688433
},
{
  id: "1d4c-31f8f14b-1571",
  seller: "WAL0452",
  buyer: "WAL3023",
  price: 348299,
  time: 1539688433
},
{
  id: "b12c-b3adf58f-809f",
  seller: "WAL0012",
  buyer: "WAL2025",
  price: 59240,
  time: 1539688433
}];
```

If we use `console.log` to dump out the above we get some pretty unhelpful output:

```
▶ (3) [{…}, {…}, {…}]
```

The little arrow lets you click down and open up the array, sure, but it’s not really the “at a glance” that we’d like.

The output from `console.table(data)` though, is a lot more helpful.

![](https://cdn-images-1.medium.com/max/800/1*wr2e5dAr_K5ilwMsYMetgw.png)

The optional second argument is the list of columns you want. Obviously defaults to all columns, but we can also do this.

```
> console.table(data, ["id", "price"]);
```

We get this output, showing only the id and the price. Useful for overly large objects with largely irrelevant detail. The index column is auto-created and doesn’t go away as far as I can tell.

![](https://cdn-images-1.medium.com/max/800/1*_je_I8pwxVgFjvCnwybMDw.png)

Something to note here is that this is out of order — the arrow on the far right column header shows why. I clicked on that column to sort by it. Very handy for finding the biggest or smallest of a column, or just getting a different look at the data. That functionality has nothing to do with only showing some columns, by the way. It’s always available.

`console.table()` only has the ability to handle a maximum of 1000 rows, so it might not be suitable to all datasets.

### console.assert()

A function whose usefulness is often missed, `assert()` is the same as `log()` but only in the case where the first argument is _falsey_. It does nothing at all if the first argument is true.

This can be particularly useful for cases where you have a loop (or several different function calls) and only one displays a particular behaviour. Essentially it’s the same as doing this.

```
if (object.whatever === 'value') {
  console.log(object);
}
```

To clarify, when I say “the same as” I should better say that it’s the **opposite of** doing that. So you’d need to invert the conditional.

So let’s assume that one of our values above is coming through with a `null` or `0` in its timestamp, which is screwing up our code formatting the date.

```
console.assert(tx.timestamp, tx);
```

When used with any of the **valid** transaction objects it just skips on past. But the broken one triggers our logging, because the timestamp is 0 or null, which is _falsey_.

Sometimes we want more complex conditionals. For example, we’ve seen issues with the data for user `WAL0412` and want to display out only transactions from them. This is the intuitive solution.

```
console.assert(tx.buyer === 'WAL0412', tx);
```

This looks right, but won’t work. Remember, the condition has to be false… we want to _assert_, not _filter_.

```
console.assert(tx.buyer !== 'WAL0412', tx);
```

This will do what we want. Any transaction where the buyer is **not** WAL0412 will be true on that conditional, leaving only the ones that are. Or… aren’t not.

Like a few of these, `console.assert()` isn’t always particularly useful. But it can be an elegant solution in specific cases.

### console.count()

Another one with a niche use, count simply acts as a counter, optionally as a named counter.

```
for(let i = 0; i < 10000; i++) {
  if(i % 2) {
    console.count('odds');
  }
  if(!(i % 5)) {
    console.count('multiplesOfFive');
  }
  if(isPrime(i)) {
    console.count('prime');
  }
}
```

This is not useful code, and a bit abstract. Also I’m not going to demonstrate the `isPrime` function, just pretend it works.

What we’ll get should be essentially a list of

```
odds: 1
odds: 2
prime: 1
odds: 3
multiplesOfFive: 1
prime: 2
odds: 4
prime: 3
odds: 5
multiplesOfFive: 2
...
```

And so on. This is useful for cases where you may have been just dumping out the index, or you would like to keep one (or more) running counts.

You can also use `console.count()` just like that, with no arguments. Doing so calls it `default`.

There’s also a related `console.countReset()` that you can use to reset the counter if you like.

### console.trace()

This is harder to demo in a simple bit of data. Where it excels is when you’re trying to figure out inside a class or library which actual caller is causing the problem.

For example, there might be 12 different components calling a service, but one of them doesn’t have a dependency set up properly.

```
export default class CupcakeService {
    
  constructor(dataLib) {
    this.dataLib = dataLib;
    if(typeof dataLib !== 'object') {
      console.log(dataLib);
      console.trace();
    }
  }
  ...
}
```

Using `console.log()` alone here would tell us what the dataLib is being passed in as, but not where. The stacktrace, though, will tell us very clearly that the problem is `Dashboard.js`, which we can see is `new CupcakeService(false)` and causing the error. And now we get bullied into using TypeScript.

### console.time()

A dedicated function for tracking time taken for actions, console.time() is better way to track the microtime taken for JavaScript executions.

```
function slowFunction(number) {
  var functionTimerStart = new Date().getTime();
  // something slow or complex with the numbers. 
  // Factorials, or whatever.
  var functionTime = new Date().getTime() - functionTimerStart;
  console.log(`Function time: ${ functionTime }`);
}
var start = new Date().getTime();

for (i = 0; i < 100000; ++i) {
  slowFunction(i);
}

var time = new Date().getTime() - start;
console.log(`Execution time: ${ time }`);
```

This is an old school method. I should also point to the console.log above. A lot of people don’t realise you can use template strings and interpolation there, but you can. From time to time it helps.

So let’s modernise the above.

```
const slowFunction = number =>  {
  console.time('slowFunction');
  // something slow or complex with the numbers. 
  // Factorials, or whatever.
  console.timeEnd('slowFunction');
}
console.time();

for (i = 0; i < 100000; ++i) {
  slowFunction(i);
}
console.timeEnd();
```

We now no longer need to do any math or set temporary variables.

### console.group()

Now we’re probably in the most complex and advanced area of the console output. Group lets you… well, group things. In particular it lets you nest things. Where it excels is in terms of showing structure that exists in code.

```
// this is the global scope
let number = 1;
console.group('OutsideLoop');
console.log(number);
console.group('Loop');
for (let i = 0; i < 5; i++) {
  number = i + number;
  console.log(number);
}
console.groupEnd();
console.log(number);
console.groupEnd();
console.log('All done now');
```

This is kind of rough again. You can see the output here.

![](https://cdn-images-1.medium.com/max/800/1*4Dil0L35FnGxiVPJx4mJsQ.png)

Not really useful for much, but you could potentially see how some of these are combined.

```
class MyClass {
  constructor(dataAccess) {
    console.group('Constructor');
    console.log('Constructor executed');
    console.assert(typeof dataAccess === 'object', 
      'Potentially incorrect dataAccess object');
    this.initializeEvents();
    console.groupEnd();
  }
  initializeEvents() {
    console.group('events');
    console.log('Initialising events');
    console.groupEnd();
  }
}
let myClass = new MyClass(false);
```

![](https://cdn-images-1.medium.com/max/800/1*MW0eKpxlBK-Cf9atJv3Baw.png)

This is a lot of work and a lot of code for debugging info that might not be all that useful. But it’s nevertheless an interesting idea, and you can see how much clearer it can make the **context** of your logging.

There is a final point to make on these, which is `console.groupCollapsed`. Functionally this is the same as `console.group` but the block starts off closed. It’s not as well supported, but if you have a huge block of nonsense you might want hidden by default it’s an option.

### Conclusion

There’s not really much of a conclusion to make here. All of these tools are potentially useful, in cases where you might just want a tiny bit more than `console.log(pet)` but don’t really need a debugger.

Probably the most useful is `console.table`, but all the others have their place as well. I’m a fan of `console.assert` for cases where we want to debug something out, but only under a specific condition.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
