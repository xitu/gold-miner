> * 原文地址：[Part Of Why I Think React Is Junk](https://medium.com/codex/part-of-why-i-think-react-is-junk-e4db95e15ef4)
> * 原文作者：[deathshadow](https://deathshadow.medium.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/Part-Of-Why-I-Think-React-Is-Junk.md](https://github.com/xitu/gold-miner/blob/master/article/2021/Part-Of-Why-I-Think-React-Is-Junk.md)
> * 译者：
> * 校对者：

# Part Of Why I Think React Is Junk

### With Actual Examples!

![](https://cdn-images-1.medium.com/max/2056/1*tH8WnMG_S0MAPdscYH3m3Q.png)

I oft get a lot of flak for my extremely low view of front-end frameworks. For all the claims of being “easier” or “better for collaboration” or “faster to develop”, I find them to universally be the polar opposite.

React, Vue, Angular, and their kine make no sense to me. ***IF ****(big if)* they are — *or can be —* used server-side, they’re nothing but code bloat rubbish adding extra steps of zero value. They don’t do anything server-side that functions/methods with template strings couldn’t accomplish cleaner/more efficiently. When used client side for normal things like shopping carts and contact forms they flip the bird at usability and accessibility since that stuff should either not be scripted in the first place, or at least have graceful degradation. Worse they “hide” actual DOM interactions and add unnecessary complexity.

Whilst as some point out it’s certainly possible to avoid some of these issues — see “Gatsby” — it only makes things an even bigger pointless mess that could have done simpler, cleaner, and in a more understandable manner without the frameworks. Server-side it’s as if HTML is too complicated so they make it even more complicated. Client-side it’s as if the DOM gets the same treatment.

Those alone should be sufficient reasons to reject their use. No matter how many blindly parrot the propaganda that doesn’t make it fact. To be brutally frank — *I know, me being frank? Shocking!* — many of the reasons people create and support these “frameworks” seems to boil down to at best disinformation and misunderstandings, at worst it’s all bald faced lies!

## The Lies

There’s a lot of just plain wrong, misleading, and broken information that led to some of the things that make React and its ilk painfully flawed.

### “Working With The Live DOM Is Slow!”

**Bullcookies!** There is no demonstrable improvement of their memory and processing wasting “virtual DOM” and simply going straight to the live DOM. If anything it’s slower because they have to “diff” changes to their document fragments to the live document! Just make the bloody change!

### “Don’t Store Data On The Live DOM, It’s Unsafe”

100% fiction. You’re going to put it there eventually, and the Nodes being attached live or not has not only no impact on speed, it also doesn’t create any security issues.

### “The DOM Is Too Hard For Normal People”

Compared to the convoluted spaghetti code inherent to the likes of React? **REALLY?** It’s just an object tree. I honestly think these claims of vanilla code being so “hard” stems from the irrational fear of Objects that gets instilled by people saying “You’re too dumb for this”.

Utter poppycock… and far more insulting than anything I’m saying here. Don’t let people tell you that you are too stupid to do something; particularly as part of the propaganda to sucker you into using some bloated, hard to use, nonsensical snake-oil.

---

I could go on for quite some time about other lies, but they all boil down to being different ways of claiming that doing more work with more code in a more complex manner is somehow magically “Easier”, or “simpler”, or “better” than the vanilla equivalents. To me, it’s all nonsensical smoke and mirrors to hide a general ignorance of HTML, CSS, JavaScript, and who websites are even for.

## Prove It!

Ok then, let’s use the two “meatiest’ examples from early in Reacts tutorials and documentation: A Tic Tac Toe game, and a temperature conversion calculator. As much as I rag on React, these are two excellent choices as examples go given they mix logic, intractability, and are well suited to client-side only operation as neither is “mission critical” like a contact form or shopping cart would be. *Those last two being things that should never RELY 100% on JavaScript to function.*

### “Make” And Other Library Functions

I dislike frameworks because what they provide can usually be done better in just a couple minutes from scratch. Rather than blindly copy any of my existing ways of doing things like DOM building, I’m gonna do a quick clean-room implementation to make things a bit more fair.

The first simple routine is called “make”. It’s similar in function to React’s “create””except it can accept JSON structures in various forms to “make” larger DOM trees in one pass. Consider this roughly equivalent to what JSX is compiled into. I dislike JSX because I’d rather the code I wrote be the code that’s deployed, because then it’s easier to change, debug, and maintain.

*Maybe that’s just me… but deploying code that isn’t what you wrote when the language is interpreted and source delivered seems pretty derp. Probably a contributor why I dislike LESS/SASS/SCSS as well.*

```js
function make(tagName, data) {
    var e = document.createElement(tagName);
    if (data) {
        if (
            data instanceof Array ||
            data instanceof Node ||
            ("object" !== typeof data)
        ) return makeAppend(e, data), e;
        if (data.append) makeAppend(e, data.append);
        if (data.attr) for (
            var [name, value] of Object.entries(data.attr)
            ) setAttribute(e, name, value);
        if (data.style) Object.assign(e.style, data.style);
        if (data.repeat) while (data.repeat[0]--) e.append(
            make(data.repeat[1], data.repeat[2])
        );
        if (data.parent) data.parent.append(e);
    }
    return e;
} // make
```

You pass it the tag you want to make, and then either an array of more instructions that are passed to make to create children of said element, or an object containing .append to add children the same way, .attr to assign attributes, .style to set the style, .repeat to create a bunch of the same children, and/or .parent to say what the new element should be created under.

*A more robust version would include a “placement” attribute to say where it should be appended in relationship to the parent.*

For example if we wanted to make a standard THEAD under table#test filled with a TR and properly scoped TH:

```js
make("thead", {
    append: [
        ["tr", [
            ["th", {scope: "col", append: "Item"}],
            ["th", {scope: "col", append: "Quntity"}],
            ["th", {scope: "col", append: "Unit Price"}],
            ["th", {scope: "col", append: "Total"}]
        ]]
    ],
    parent: document.getElementById("test")
});
```

Pretty simple. This “make” routine relies on two other routines:

```js
function makeAppend(e, data) {
    if (data instanceof Array) {
        for (var row of data) {
            e.append(row instanceof Array ? make(...row) : row);
        }
    } else e.append(data);
} // makeAppend
function setAttribute(e, name, value) {
    if (
        value instanceof Array ||
        ("object" == typeof value) ||
        ("function" == typeof value)
    ) e[name] = value;
    else e.setAttribute(name === "className" ? "class" : name, value);
} // safeSetAttr
```

makeAppend is like Element.append, but it accepts an array of what to append, and if it detects an array in the data stream it calls “make” with it instead.

`setAttribute` is a mirror of `Element.setAttribute` but without the “issues’ that has. For example the Element method only accepts strings which can be wrong if you want to set something like an `onEvent` attribute. If the data is object, array, or function, we need to do direct assignment. Conversely some attributes can screw up if you assign them direct so we want the conventional Element.setAttribute for any values that are not those types. I also wash className to class since setAttribute on “className” doesn’t work, and there is no Element.className on SVG, XML or other non HTML elements. We don’t really need that here, but it’s still nice to be XML/SVG safe.

A final function I tossed in is “purge”

```js
function purge(e, amt) {
    var dir = amt < 0 ? "firstChild" : "lastChild";
    amt = Math.abs(amt);
    while (amt--) e.removeChild(e[dir]);
} // purge
```

Which removes “amt” number of children from the end of the parent element “e”. If you feed it a negative number, it will remove them from the beginning.

That in a nutshell is 80%+ of all I would ever need in helper functions for the majority of things I’d ever do in JS these days.

**So Let’s Get To It!**

## Tic Tac Toe

Their original: [https://codepen.io/gaearon/pen/gWWZgR?editors=0010](https://codepen.io/gaearon/pen/gWWZgR?editors=0010)

My rewrite: [https://codepen.io/jason-knight/pen/qBqwrwo](https://codepen.io/jason-knight/pen/qBqwrwo)

The original has “issues” — in my opinion — in both lack of code clarity, and how it is constructed on the DOM. Some of these issues have nothing to do with the JavaScript, but just bespeak how the people creating these systems are unqualified to write a single line of HTML or CSS.

Such as the “DIV for Nothing” .board-row in their generated markup, their failure to leverage FIELDSET in what is obviously a group of fields, the pissing all over their JSX with classes for nothing, the whole “state” rubbish that ends up tracking extra data in memory that not only doesn’t need to be tracked, but would be faster/cleaner to implement with a data flush and write of just the turns. Even the use of pixel metrics in the stylesheet — a giant middle finger to usability and accessibility — makes one question if the people who CREATED this system are qualified to tell people how to use web technologies.

Worse though is that you simply don’t see the actual value writes to the live DOM, meaning you’re 100% reliant on their code to even guess if things are being updated properly. I know people claim that this “state” and virtual DOM nonsense is cleaner or easier… I just don’t see it.

We start out declaring all the variables specific to tracking the game state. If you worry about so many globals 1) their code does it too, 2) wrap it in a IIFE or include it as a module. The “functional programming” nutters pissing and moaning about “Side effects” can go suck an egg.

*As I’ve said before, if you’re doing it on “purpose” it’s not a “side effect”. There’s only one reason they chose that term to describe it, and it has nothing to do with accessing the parent scope being “evil”. Programming 101 — at least when I learned it decades ago — inward scope good, outward scope bad. If it REALLY bothers you, make it all object based and waste a bunch of code saying “this” all over the place.*

```js
var
    lines = [
        [0, 1, 2],
        [3, 4, 5],
        [6, 7, 8],
        [0, 3, 6],
        [1, 4, 7],
        [2, 5, 8],
        [0, 4, 8],
        [2, 4, 6]
    ],
    player,
    squares = make('fieldset', {
        repeat: [9, "input", {
            attr: {onclick: squareClick, type: "button"},
        }],
        attr: {id: "board"},
        parent: document.body,
    }).elements,
    turn,
    turnHistory = [],
    turnOL = make("ol"),
    txtPlayer = new Text(),
    txtTurn = new Text(),
    winner;
```

Predeclaring all our variables together in one place gives us a cross-reference we can easily go to in order to know what’s in use. This is something as a Pascal/Modula/Ada guy I find vastly superior to this nonsensical and error inducing practice of just letting people declare variables wherever the blazes they want in the middle of the code logic. When I learned programming for anything other than counters for loops, that was just plain bad code even if it’s the norm in ****-show memory leak inducing typo becomes a new variable “what the *** variables are even in use” languages like C!

The big thing here being the squares variable, a reference to the fieldset#board.elements which will be our playfield buttons. I fill it with 9 input of type=”button”, so that we can set “value” on it which behaves just like textContent would on button. It’s just a hair less code and easier to manipulate. Note that we set the `onclick` event as `squareClick`. We'll get to that shortly.

`player`, `turn`, and `winner` are all game state tracking. `turnHistory` should be self explanatory, as should the `turnOL`. `txtPlayer` and txtTurn are textNodes we store references to before storing them in the structure of our information `DIV`.

Note that “new Text()” is the new way of doing “document.createTextNode”. Functionally identical, just easier to work with. *I kind of wish the ECMA would give Element a constructor!*

Now that we have those, we can build the information DIV that will hold the current player and the list.

```js
make('div', {
    append: [txtTurn, " : ", txtPlayer, turnOL],
    parent: document.body
});
```

Again the simple make routine creates our DIV, appends the elements we created as variables along with a `" : "` between the turn text (“Next Player” or “Winner”) and the player (“X” or “O”)

Next we’ll need to make the buttons to go direct to each turn. A simple function to handle that can be called both when a turn is taken, and at the start to make our “Go to Game Start” button.

```js
function turnButton(append, onclick, value) {
    make("li", {
        append: [["button", {attr: {onclick, value}, append}]],
        parent: turnOL
    });
} // turnButton
```

Again using `make` to add the LI, the button inside it, etc, etc. Note that these turn buttons can also have a value set on them. This is where a “button” helps as we can store a value (the turn) that’s separate from its text. Also notice that by using argument names that match our object assignments, we don’t have to say “onclick : onclick” or “value : value”. *I’m oft amazed how many JS dev’s don’t know you can do that…*

We also want a “restart” function to set up the initial game state or revert the game to that state.

```js
function restart() {
    for (var square of squares) square.value = "";
    txtPlayer.textContent = player = "X";
    winner = false;
    turn = 0;
    txtTurn.textContent = "Next Player";
} // restart
```

Empty out all the squares, set the player and the text showing the current player to “X”, set winner to false, turn 0 (no turns taken), and set up the instructions text to “Next Player”.

Thus our next step in the setup is to add:

```js
turnButton("Go To Game Start", restart);
restart();
```

Adding the back to start, and initializing our play state. I do this separate from the startup variables so that we aren’t saying all the same things twice. *This is a case where a “game” object would make more sense, but I’m trying to keep this simple.*

Next we need a callback handler for all those click events on the squares.

```js
function squareClick(e) {
    e = e.currentTarget;
    if (winner || e.value) return;
    e.value = player;
    if (turnHistory.length > turn) {
        purge(turnOL, turnHistory.length - turn);
        turnHistory = turnHistory.slice(0, turn);
    }
    turnHistory.push(e);
    turn++;
    turnButton("Go to move " + turn, goToTurn, turn);
    calcWinner();
} // squareClick
```

We start out by grabbing the current element since we don’t give a flying fig about the event itself. If we already have a winner or the value of the clicked square is set, terminate early. Otherwise the current element is set to the current player (“X” or “O”). If the turn history is longer than the current turn, we want to purge all those “Go To Move” buttons as well as the history entries. We can then push this element into the turn history, increment the turn counter, then create a new turnButton LI/BUTTON. Finally check to see if there’s a winner.

The winner check routine:

```js
function calcWinner() {
    for (var [a, b, c] of lines) if (
        (player == squares[a].value) &&
        (player == squares[b].value) &&
        (player == squares[c].value)
    ) {
        txtTurn.textContent = "Winner";
        return txtPlayer.textContent = winner = player;
    }
    if (turn == 9) {
        txtTurn.textContent = "Tie";
        txtPlayer.textContent = "Game Over";
    } else nextPlayer();
} // calcWinner
```

Is also pretty simple and has better short-circuit than theirs.

1. I don’t have “lines” stored inside it where it adds execution and memory overhead that even “const” doesn’t fix.

2. By comparing to player I'm able to implement simpler checks with faster loop abortion.

3. By using for/of instead of the old-school loop, I can do my destructuring in the loop. Also doesn’t help that they use const there which if they were REAL constants would break the execution loop. *I’m actually not sure why theirs would/should even be allowed to work on those grounds… but again I also find let/const to be pretty useless/pointless. You need them you’ve probably got bigger problems.*

4. If needed we return the winner, otherwise void since that’s the default. You don’t have to explicitly `return false;` as that’s one of the advantages of loose typecasting and “truthiness”. *Stop fighting what JS tries to make simpler!*

I also trap the last turn for an appropriate message *(something they do not do)* as well as increment the player here.

Finally we need the routine to go back to a specific turn. Theirs handles this by storing the entire playfield and game state every blasted turn. By the time you wade through all the overhead in place to do that, you’ve spent more processing time than it would take to just wipe the field and then incrementally plug in each alternating turn… which is exactly what I did:

```js
function goToTurn(e) {
    restart();
    for (var input of turnHistory) {
        input.value = player;
        if (++turn == e.currentTarget.value) break;
        nextPlayer();
    }
    calcWinner();
} // goToTurn
```

Reset the playfield, loop through the history applying each players turn to the appropriate squares leveraging “`nextPlayer`” inside the loop. Applies many times faster than all that state nonsense despite the “from scratch” application. Finally we call `calcWinner` to set the win state if need be.

The `nextPlayer` function being really simple:

```js
function nextPlayer() {
    txtPlayer.textContent = player = player === "X" ? "O" : "X";
} // nextPlayer
```

That in a nutshell is a quick and dirty rewrite. I’d probably clean it up with some objects and so forth, but even as is compared to the original, well…

### The Comparison

Their original using JSX is 3,247 bytes but it relies on react.js to even function. Mine is up at 3,354 bytes, **but that’s not a fair comparison.**

Why is it not fair? First off, I have comments for function closures and sections whilst they have no comments. So if we strip out all the comments? It’s down to 3,118 bytes. So in reality the entire thing is 129 bytes smaller…

… or is it? No, it’s still not fair because they get to leverage the entire fatass react.js library. So relying on their library it’s still as much code as you’d write without it! Code where half of what’s really going on is even hidden from you!

So to level the playing field we have to discount my helper functions just as we don’t count react.js… and that guts us down to 1,956 bytes. That’s roughly 60.2% the total code for the same basic functionality…

*Excuse the font and image quality, it’s scaled down 50% from a 4k display.*

![React vs. simple vanilla function.](https://cdn-images-1.medium.com/max/2544/1*4fGJ95-YPmlwU4I9CQf20Q.png)

And looking at the source of the two side-by-side, I know which one I’d rather work with and it’s sure as shine-ola not the React one.

## Temperature Calculator

This far simpler example is even less efficient and less well thought out on implementation, entirely because of how React works. Again, I’ll use the same helper lib in the form of `make`, but I don’t need `purge` for this.

Their original: [https://codepen.io/gaearon/pen/WZpxpz?editors=0010](https://codepen.io/gaearon/pen/WZpxpz?editors=0010)

My Rewrite: [https://codepen.io/jason-knight/full/OJbGmoN](https://codepen.io/jason-knight/full/OJbGmoN)

This time around theirs is even more of a wreck in terms of what they’re generating, since they’re using FIELDSET and LEGEND to do LABEL’s job, without even bothering to provide a proper FIELDSET or LEGEND. That’s the first blasted thing I fixed.

But it goes downhill even faster from there. All that JSX rubbish is code-bloat trash that makes actually doing anything MORE complicated. Worse they hardcoded the conversions instead of setting up a multi-conversion object. This is so much a case where objects and arrays would/should be leveraged for greater code simplicity and efficiency. I mean hell, look at the spaghetti of just Celsius and Fahrenheit having a lookup table, a conversion function for each, hardcoded handlers for each, and the endless daisy chain of “functional programming” trash that does nothing but add more execution overhead whilst breaking things up into subsections that don’t need breaking up. For things that one six to eight line event handler and one reference object would/should be able to handle!

This why the first thing I wrote was this:

```js
var
    scales = {
        celcius: {
            fahrenheit: (t) => 32 + t * 1.8,
            kelvin: (t) => 273.15 + t
        },
        fahrenheit: {
            celcius: (t) => (t - 32) / 1.8,
            kelvin: (t) => 273.15 + ((t - 32) / 1.8)
        },
        kelvin: {
            celcius: (t) => t - 273.15,
            fahrenheit: (t) => (t - 273.15) * 1.8 + 32
        }
    };
```

Tossing Kelvin in to test adding other conversions. This structure can be used to both create the inputs, AND to provide callbacks for the conversions as needed. *Normally I rail against arrow functions, but these are basically lambda, the ideal usage case for them.*

You want to add another temperature scale, just create a new top-level object like I did with Kelvin, then create the calculations to turn it into the other types as children lambda’s, then add the appropriate lambda’s for each other conversion to those. *Easy-peasy lemon squeezy.*

I then use make to create a `FIELDSET` and create a text node for plugging state into.

```js
  root = make("fieldset", {
    append: [["legend", [
        "Enter a temperature in any field below for conversion"
    ]]],
    parent: document.body
}),
    boilingText = new Text();
```

Now we have a proper grouping `FIELDSET` and are no longer abusing `LEGEND` by providing a real one.

To make the various input based on our scales…

```js
function makeTempInput(name, parent) {
    Object.defineProperty(scales[name], "input", {
        value: make("input", {
            attr: {
                id: "tempCalc_" + name,
                name,
                oninput: onTempInput,
                pattern: "[-+]?[0-9]*[.,]?[0-9]+",
                type: "number"
            },
        })
    });
    make("label", {
        append: [name, ["br"], scales[name].input, ["br"]],
        parent
    });
} // makeTempInput
```

I use Object.defineProperty to create an INPUT element on the scales. I do this so that it can be read, but is not enumerated / iterable. This way when we want to iterate through the object’s visible properties, the reference to the corresponding input is not in the way. As we need no reference to the label, we just make that separately adding some line breaks for simple formatting since there’s no reason to be wasting block level containers on each of these.

*Actually in hindsight, that doesn’t need those ID’s. Oh well, I’m not going back and re-doing the screenshots and other deployments now.*

For those who can’t grasp something as simple as the DOM, the above basically makes the same thing as:

```html
<label>
    fahrenheit<br>
    <input id="temp_fahrenheit"
           name="fahrenheit" 
           oninput="ontempinput();"
           pattern="[-+]?[0-9]*[.,]?[0-9]+"
           type="number"><br>
</label>
```

Attached to our “root” `FIELDSET` directly on the DOM, but with a reference to the `INPUT` added to the appropriate subsection of `scales`.

Note the use of `type="number"` and the pattern which lets us kill off scripted value validation. It misses out on paste, but for now it’s more than sufficient. That’s probably an unfair advantage on my side since who knows when their example was last updated. Even so, thank you W3C for one of the few useful additions from HTML 5.

We can then just call it for each and every one of our `scales`.

```js
for (var name in scales) makeTempInput(name, root);
```

Naturally we need the `oninput` handler.

```js
function onTempInput(event) {
    var input = event.currentTarget;
    for (
        var [name, method]
        of Object.entries(scales[input.name])
        ) scales[name].input.value = method(input.valueAsNumber);
    boilNoticeUpdate();
} // onTempInput
```

We get the `INPUT` element that triggered the event, we go through all of the `scales` related to that `INPUT`, and perform their associated methods based on the `INPUT`’s value.

Also by using `HTMLInputElement.valueAsNumber` we avoid more possible headaches with people forcing text in there. *That’s a relatively new addition to the DOM properties. I like it. I like it a lot.*

Then we test for boiling:

```js
function boilNoticeUpdate() {
    boilingText.textContent = scales.celcius.input.value >= 100 ? "" : "not";
} // boilNoticeUpdate
```

Changing only the one little tiny textNode, not the whole blasted string. Because yes, you can target subsections of text without Element nodes as textNodes can also be siblings and do not auto-collapse. *(unless you do something stupid like innerHTML or textContent on the parent)*

And on startup it calls the boilNoticeUpdate just to be sure the text is correct. Firefox likes to retain values on normal refreshes, so status updates like that should be run during startup.

… and that’s it.

### The Comparison

The React based original is 2,441 bytes whilst my rewrite is 2,630 bytes, but again that’s not a level playing field. Not only this time is that counting the helper functions and comments, we also have Kelvin support.

Removing just the comments gets it down to 2,442, nearly the same size. Remove Kelvin by simply changing the scales declaration to:

```js
scales = {
    celcius: {
        fahrenheit: (t) => 32 + t * 1.8
    },
    fahrenheit: {
        celcius: (t) => (t - 32) / 1.8
    }
}
```

… and it drops to 2,262. So even with the overhead of the custom make function and its dependents doing roughly what react.js provides, it’s actually 179 bytes smaller. If we remove those for a fair comparison since we’re not counting react.js itself in this, we’re looking at a mere 1,243 bytes! That’s for all intents and purposes **HALF THE FLIPPING CODE!**

Even more of a laugh when you realize I’m using the full temperature names, not single letters. That way I don’t need a conversion table. Want the first letter upper-case? Do it in the CSS!

*Though it would really help if I could remember that first “h” in fahrenheit.*

That’s easier to follow, more extensible / scalable since the conversions aren’t hardcoded, and because we cut out all that virtual DOM and comparison rubbish it’s more efficient on both memory use and execution time!

**Again, which would you rather maintain?**

![React vs. Vanilla Lib code comparison](https://cdn-images-1.medium.com/max/2472/1*pYbWu-rf8KuoMXR3NGNsXw.png)

More importantly, which one would you rather have to deal with when it comes time to add more temperature scales to it? You know, that scalability these framework developers are always flapping their yaps about?

## Conclusion

![A good engineer is always a wee bit conservative, at least on paper.](https://cdn-images-1.medium.com/max/2000/1*H2Mnjw70o9f9nBsbbfIZ4g.jpeg)

Reacts methodology basically makes you write — *if you omit helper functions/libraries and react.js itself from either way of doing it* — write double or more the code needed to do the job. This seems to scale upwards too, which is why as an accessibility and efficiency consultant I keep coming across clients with megabytes of scripting on sites where half of it doesn’t even need scripting to be done, and the other half has little excuse to be more than 48k of code. Megabytes doing kilobytes flipping job!

And that’s with me Mr. Scott-ing those figures. *Aka figure out how much you actually need, then double it.*

… And we didn’t even talk about the even larger code it actually outputs client-side. Even with the helper functions to bring us up to the same level of functionality, it’s nearly the same amount of code.

How is that easier, or simpler, or better? It’s abstraction for abstraction’s sake. Sure, I skipped into global space in a way I’d never do, but so do their examples because these are EXAMPLES.

In no way, shape, or form are their approaches better, or easier, or any of the other wild unfounded claims people make about these types of frameworks. Sure, they’re not as bad as the [mind-numbing idiocy of HTML/CSS frameworks](https://medium.com/codex/why-presentational-classes-for-html-css-are-ignorant-garbage-bcfdb02ec397), but it’s not exactly a surprise either they seem to go hand-in-hand in terms of who uses them; much less the stream of lame excuses, half-truths, and outright lies they parrot. *It’s the same dance, just a different tune.*

Go straight to the DOM, and bypass all the felgercarb.

— EDIT — I have written a follow-up based on many of the more substantial replies and counterpoints you folks have left in the comments. You’ve not changed my mind, but you did get me thinking.

[https://deathshadow.medium.com/i-think-react-is-junk-round-two-5cb80c5d82b3](https://deathshadow.medium.com/i-think-react-is-junk-round-two-5cb80c5d82b3)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
