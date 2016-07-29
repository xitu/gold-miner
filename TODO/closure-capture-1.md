>* 原文链接 : [Closures Capture Semantics, Part 1: Catch them all!](http://alisoftware.github.io/swift/closures/2016/07/25/closure-capture-1/)
* 原文作者 : [Olivier Halligon](http://alisoftware.github.io/about/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


Even with ARC nowadays, it’s still important to understand memory management and objects life-cycles. A special case is when using closures, which are more and more present in Swift and have different capture semantics than ObjC’s block capture rules. Let’s see how they work.

## Introduction

In Swift, closures capture the variables they reference: variables declared outside of the closure but that you use inside the closure are retained by the closure by default, to ensure they are still alive when the closure is executed.

For the rest of this article, let’s define a simplistic `Pokemon` example class:



    class Pokemon: CustomDebugStringConvertible {
      let name: String
      init(name: String) {
        self.name = name
      }
      var debugDescription: String { return "\(name)>" }
      deinit { print("\(self) escaped!") }
    }



Let also declare a simple function that takes a closure as parameter, and executes that closure some seconds later (using GCD). This way we’ll use it in below examples to see how that closure captures the outer variables.



    func delay(seconds: NSTimeInterval, closure: ()->()) {
      let time = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC)))
      dispatch_after(time, dispatch_get_main_queue()) {
        print("🕑")
        closure()
      }
    }

ℹ️️ In Swift 3, the above function would be written something like this instead:


    func delay(seconds: Int, closure: ()->()) {
      let time = DispatchTime.now() + .seconds(seconds)
      DispatchQueue.main.after(when: time) {
        print("🕑")
        closure()
      }
    }

## Default capture semantics

Now, let’s start with a simple example:


    func demo1() {
      let pokemon = Pokemon(name: "Mewtwo")
      print("before closure: \(pokemon)")
      delay(1) {
        print("inside closure: \(pokemon)")
      }
      print("bye")
    }



This might seem like a simple one, but it’s interesting to note that the closure gets executed 1 second after the code from the `demo1()` function has finished executed and we exited the function’s scope… yet the `Pokemon` is still alive when the block is executed that one second later!



    before closure: <Pokemon Mewtwo>
    bye
    🕑
    inside closure: <Pokemon Mewtwo>
    <Pokemon Mewtwo> escaped!



That’s because the closure strongly captures the variable `pokemon`: as the Swift compiler sees that the closure references that `pokemon` variable inside the closure, it automatically captures it (strongly by default), so that this `pokemon` is alive as long as the closure itself is alive.

So yes, closures are a little like Pokeballs 😆 as long as you keep the <del>pokeball</del> closure around, the `pokemon` variable will be there too, but when that <del>pokeball</del> closure is released, so is the `pokemon` it referenced.

In this example, the closure itself gets released once it has been executed by GCD, so that’s when the `pokemon`’s `deinit` method gets called too.

ℹ️ If Swift didn’t capture that `pokemon` variable automatically, that would mean that the `pokemon` variable would have had time to go out of scope when we reach the end of the `demo1` function, and that pokemon would no longer exist when the closure would execute one second later… leading to a probable crash.  
Thankfully, Swift is smarter than that and captures that pokemon for us. We’ll see in a later article how we can weakly capture those variables instead when we need to.

## Captured variables are evaluated on execution

One important thing to note though is that **in Swift the captured variables are evaluated at the closure execution’s time**<sup>[1](http://alisoftware.github.io/swift/closures/2016/07/25/closure-capture-1/#fn:block-modifier)</sup>. We could say that it captures the _reference_ (or _pointer_) to the variable.

So here’s an interesting example:



    func demo2() {
      var pokemon = Pokemon(name: "Pikachu")
      print("before closure: \(pokemon)")
      delay(1) {
        print("inside closure: \(pokemon)")
      }
      pokemon = Pokemon(name: "Mewtwo")
      print("after closure: \(pokemon)")
    }



Could you guess what gets printed? Here’s the answer:



    before closure: <Pokemon Pikachu>
    <Pokemon Pikachu> escaped!
    after closure: <Pokemon Mewtwo>
    🕑
    inside closure: <Pokemon Mewtwo>
    <Pokemon Mewtwo> escaped!



Note that we change the `pokemon` object _after_ creating the closure, still when the closure executes 1 second later (while we already exited the scope of the `demo2()` function), we print the new `pokemon`, not the old one! That’s because Swift captures variables by reference by default.

So here, we initialize `pokemon` to Pikachu, then we change its value to Mewtwo, so that Pikachu gets released — as no more variable retains it. Then one second later the closure gets executed and it prints the content of the variable `pokemon` that the closure captured by reference.

The closure didn’t capture “Pikachu” (the pokemon we got at the time the closure was created), but more a reference to the `pokemon` variable — that now evaluates to “Mewtwo” at the time the closure gets executed.

What might seems odd is that this works for value types too, like `Int` for example:



    func demo3() {
      var value = 42
      print("before closure: \(value)")
      delay(1) {
        print("inside closure: \(value)")
      }
      value = 1337
      print("after closure: \(value)")
    }



This prints:



    before closure: 42
    after closure: 1337
    🕑
    inside closure: 1337



Yes, the closure prints the _new_ value of the `Int` — even if `Int` is a value type! — because it captures a reference to the variable, not the variable content itself.

## You can modify captured values in closures

Note that if the captured value is a `var` (and not a `let`), you can also modify the value **from within the closure**<sup>[2](http://alisoftware.github.io/swift/closures/2016/07/25/closure-capture-1/#fn:objc_block_modify)</sup>.



    func demo4() {
      var value = 42
      print("before closure: \(value)")
      delay(1) {
        print("inside closure 1, before change: \(value)")
        value = 1337
        print("inside closure 1, after change: \(value)")
      }
      delay(2) {
        print("inside closure 2: \(value)")
      }
    }



This code prints the following:



    before closure: 42
    🕑
    inside closure 1, before change: 42
    inside closure 1, after change: 1337
    🕑
    inside closure 2: 1337



So here, the `value` variable has been changed from inside the block (even if it has been captured, it was not captured as a constant copy, but still refers to the same variable). And the second block sees that new value even if it executes later — and at a time when the first block was already released and the value variable already been out of the `demo4()` function’s scope!

## Capturing a variable as a constant copy

If you want to capture the value of a variable at the point of the closure **creation**, instead of having it evaluate only when the closure executes, you can use a **capture list**.

Capture lists are written between square brackets right after the closure’s opening bracket (and before the closure’s arguments / return type if any)<sup>[3](http://alisoftware.github.io/swift/closures/2016/07/25/closure-capture-1/#fn:in-keyword)</sup>.

To capture the value of a variable at the point of the closure’s creation (instead of a reference to the variable itself), you can use the `[localVar = varToCapture]` capture list. Here’s what it looks like:



    func demo5() {
      var value = 42
      print("before closure: \(value)")
      delay(1) { [constValue = value] in
        print("inside closure: \(constValue)")
      }
      value = 1337
      print("after closure: \(value)")
    }



This will print:



    before closure: 42
    after closure: 1337
    🕑
    inside closure: 42



Compare this with `demo3()` code above, and notice that this time the value printed by the closure… is the content of the `value` variable **at the time of creation** — before it got assigned its new `1337` value — even if the block is executed _after_ this new value.

That’s what `[constValue = value]` is doing in this closure: capturng the _value_ of the `value` variable at the time of the closure’s creation — and not a reference to the variable itself to evaluate it later.

## Back to Pokemons

What we saw just above also means that if that value is a reference type — like our `Pokemon` class — the closure does not really strongly capture the variable reference, but rather somehow capture a copy of the original instance contained in the `pokemon` variable being captured.:



    func demo6() {
      var pokemon = Pokemon(name: "Pikachu")
      print("before closure: \(pokemon)")
      delay(1) { [pokemonCopy = pokemon] in
        print("inside closure: \(pokemonCopy)")
      }
      pokemon = Pokemon(name: "Mewtwo")
      print("after closure: \(pokemon)")
    }


It’s a bit like if we create an intermediate variable to point to the same pokemon, and captured this variable instead:



    func demo6_equivalent() {
      var pokemon = Pokemon(name: "Pikachu")
      print("before closure: \(pokemon)")
      // here we create an intermediate variable to hold the instance 
      // pointed by the variable at that point in the code:
      let pokemonCopy = pokemon
      delay(1) {
        print("inside closure: \(pokemonCopy)")
      }
      pokemon = Pokemon(name: "Mewtwo")
      print("after closure: \(pokemon)")
    }



_In fact, using the capture list is exactly equivalent in behavior to that code above… except that this `pokemonCopy` intermediate variable is local to the closure and will only be accessible from within the closure body._

Compare this `demo6()` — that uses `[pokemonCopy = pokemon] in …` — and `demo2()` — which doesn’t, and use `pokemon` direclty instead. `demo6()` outputs this:



    before closure: <Pokemon Pikachu>
    after closure: <Pokemon Mewtwo>
    <Pokemon Mewtwo> escaped!
    🕑
    inside closure: <Pokemon Pikachu>
    <Pokemon Pikachu> escaped!



Here’s what happens:

*   Pikachu is created;
*   then it is captured as a copy (capturing the **value** of the `pokemon` variable here) by the closure.
*   So when a few lines below we assign `pokemon` to a new Pokemon “Mewtwo”, then “Pikachu” is not released _just yet_, as it’s still retained by the closure.
*   When we exit the `demo6` function’s scope, Mewtwo is released, as the `pokemon` variable itself — which was the only one strongly referencing it — is going out of scope.
*   Then later, when the closure executes, it prints `"Pikachu"` because that was the Pokemon being captured at the closure creation’s time by the capture list.
*   Then the closure is released by GCD, and so is the Pikachu pokemon which it was retaining.

On the contrary, back in the `demo2` code above:

*   Pickachu was created;
*   then the closure only captured a **reference** to the `pokemon` variable, not the actual Pickachu pokemon/value the variable contained.
*   So when `pokemon` was assigned a new value `"Mewtwo"` later, Pikachu was not strongly referenced by anyone anymore and got released right away.
*   But the `pokemon` _variable_ (holding the `"Mewtwo"` pokemon at that time) was still strongly referenced by the closure
*   So that’s the pokemon that was printed when the closure was executed one second later
*   And that Mewtwo pokemon was only released once the closure was executed then released by GCD.

## Mixing it all

So… did you catch it all? I know, there’s a lot to get there…

Here is a more contrieved example mixing both the value evaluated and captured at closure creation — thanks to a capture list — and the variable reference captured and evaluated at closure evaluation:



    func demo7() {
      var pokemon = Pokemon(name: "Mew")
      print("➡️ Initial pokemon is \(pokemon)")

      delay(1) { [capturedPokemon = pokemon] in
        print("closure 1 — pokemon captured at creation time: \(capturedPokemon)")
        print("closure 1 — variable evaluated at execution time: \(pokemon)")
        pokemon = Pokemon(name: "Pikachu")
        print("closure 1 - pokemon has been now set to \(pokemon)")
      }

      pokemon = Pokemon(name: "Mewtwo")
      print("🔄 pokemon changed to \(pokemon)")

      delay(2) { [capturedPokemon = pokemon] in
        print("closure 2 — pokemon captured at creation time: \(capturedPokemon)")
        print("closure 2 — variable evaluated at execution time: \(pokemon)")
        pokemon = Pokemon(name: "Charizard")
        print("closure 2 - value has been now set to \(pokemon)")
      }
    }


Can you guess the output on this one? It might be a bit hard to guess, but it’s a good execise to try to determine the output yourself to check if you understood all of today’s lesson…

![drumroll](http://ac-Myg6wSTV.clouddn.com/0c59ce77448794cf9dcc.gif)

Ok, here’s the output from that code. Did you guess it right?


    ➡️ Initial pokemon is <Pokemon Mew>
    🔄 pokemon changed to <Pokemon Mewtwo>
    🕑
    closure 1 — pokemon captured at creation time: <Pokemon Mew>
    closure 1 — variable evaluated at execution time: <Pokemon Mewtwo>
    closure 1 - pokemon has been now set to <Pokemon Pikachu>
    <Pokemon Mew> escaped!
    🕑
    closure 2 — pokemon captured at creation time: <Pokemon Mewtwo>
    closure 2 — variable evaluated at execution time: <Pokemon Pikachu>
    <Pokemon Pikachu> escaped!
    closure 2 - value has been now set to <Pokemon Charizard>
    <Pokemon Mewtwo> escaped!
    <Pokemon Charizard> escaped!

So, what did happen here? Being a bit complicated, let’s explain each step in details:

1.  ➡️ `pokemon` is initially set to `Mew`
2.  Then the closure 1 is created and the _value_ (`Mew` at that time) of `pokemon` is captured into a new `capturedPokemon` variable — which is local to that closure (and the reference to the `pokemon` variable is captured too, as both `capturedPokemon` and `pokemeon` are used in the closure’s code)
3.  🔄 Then `pokemon` is changed to `Mewtwo`
4.  Then the closure 2 is created and the _value_ (`Mewtwo` at that time) of `pokemon` is captured into a new `capturedPokemon` variable — which is local to that closure (and the reference to the `pokemon` variable is captured too, as both are used in that closure’s code)
5.  Now, the function `demo8()` has ended.
6.  🕑 One second later, GCD executes the first closure.
    *   In prints the _value_ `Mew` that it captured in `capturedPokemon` at the time that closure was created on step 2.
    *   It also evalutes the current value of the `pokemon` variable that it captured by reference, which is still `Mewtwo` (as of when we left it before exiting the `demo8()` function on step 5)
    *   Then it sets the `pokemon` variable to value `Pikachu` (again, the closure captured a _reference_ to the variable `pokemon` so that’s the same variable as the one used in `demo8()`’s body as well as in the other closure that it assigns a value to)
    *   When the closure finished executing and is released by GCD, nobody retains `Mew` anymore, so it’s deallocated. But `Mewtwo` is still captured by the 2nd closure’s `capturedPokemon` and `Pikachu` is still stored in the `pokemon` variable which is captured by reference by the 2nd closure too.
7.  🕑 Another second later, GCD executes the second closure.
    *   In prints the _value_ `Mewtwo` that it captured in `capturedPokemon` at the time that second closure was created on step 4.
    *   It also evalutes the current value of the `pokemon` variable that it captured by reference, which is `Pikachu` (as it has been modified by the first closure since then)
    *   Lastly, it sets the `pokemon` variable to `Charizard`, and the `Pikachu` pokemon that was only referenced by that `pokemon` variable isn’t retained anymore and is deallocated.
    *   When the closure finished executing and is released by GCD, the `capturedPokemon` local variable goes out of scope so `Mewtwo` is released, and nobody retains a reference to the `pokemon` variable anymore either so the `Charizard` pokemon it retained is released too.

## Conclusion

Still confused by all that gymnastics? That’s normal. Closure capture semantics can sometimes be tricky, especially with that last contrieved example. Just remember these key points:

*   Swift closures capture a _reference_ to the outer variables that you happen to use inside the closure.
*   That reference gets **evaluated at the time the closure itself gets executed**.
*   Being a capture of the reference to the variable (and not the variable’s value itself), **you can modify the variable’s value from wthin the closure** (if that variable is declared as `var` and not `let`, of course)
*   **You can instead tell Swift to evaluate a variable at the point of the closure creation** and store that _value_ in a local constant, instead of capturing the variable itself. You do that using **capture lists** expressed inside brackets.

I will let today’s lesson sink it for now, as it might be sometimes hard to grasp. Don’t hesitate to try and test this code and variations of it in a Playground to clearly understand how all of this works on your own.

Once you’ve understood this more clearly, it will be time for the next part of this blog post, on which we’ll talk about capturing variables _weakly_ to avoid reference cycles, and what `[weak self]` and `[unowned self]` all means in closures.

_Thanks to [@merowing](https://twitter.com/merowing_) for the discussion about all those capture semantics we had in Slack and some revelations about captured variables being evaluated at closure execution time! You can visit [his blog here](http://merowing.info) 😉_

1.  For those of you who know Objective-C, you can notice that the Swift behavior is unlike Objective-C’s default block semantics but instead somewhat like if the variable had the `__block` modifier in Objective-C. [↩](#fnref:block-modifier)

2.  unlike in ObjC’s default behavior… and more like when you’re using `__block` in Objective-C [↩](#fnref:objc_block_modify)

3.  Note that even if in our examples we only capture one variable, you can list more than just one variable capture in a capture list, that’s why they are called _lists_. Also, if you don’t list the closure arguments list, you’ll still have to put the `in` keyword after the capture list to separate it from the closure’s body. [↩](#fnref:in-keyword)
