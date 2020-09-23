> * 原文地址：[Implementing Monte Carlo Tree Search in Node.js](https://medium.com/@quasimik/implementing-monte-carlo-tree-search-in-node-js-5f07595104df)
> * 原文作者：[Michael Liu](https://medium.com/@quasimik)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/implementing-monte-carlo-tree-search-in-node-js.md](https://github.com/xitu/gold-miner/blob/master/article/2020/implementing-monte-carlo-tree-search-in-node-js.md)
> * 译者：
> * 校对者：

# Implementing Monte Carlo Tree Search in Node.js

![](https://cdn-images-1.medium.com/max/5000/1*RIYK4LcwRn_GCm_A3Mg1JA.jpeg)

This article is a follow-up to [the previous one](https://medium.com/@quasimik/monte-carlo-tree-search-applied-to-letterpress-34f41c86e238), but I’ll provide enough context so that it’s possible to drop in on this one. Be forewarned that this one’s going to be more technical. All code is available in [this GitHub repo](https://github.com/quasimik/medium-mcts/).

As with the previous article, this one also assumes some computer science knowledge on the reader’s part, in particular how the **tree data structure** works. Intermediate knowledge of **JavaScript** (ES6+) is required.

This article has one simple goal:

1. Implement a Monte Carlo Tree Search (MCTS) algorithm to play a game given its rules.

That’s it. Performance? Maybe next time. This whole thing is going to be instructional and hands-on. I will provide brief explanations of the linked code snippets, and the hope is that you, reader, will follow along and take the time to understand tricky bits in the code.

Let’s begin.

## Create the Skeleton Files

In `game.js`:

```js
/** Class representing the game board. */
class Game {

  /** Generate and return the initial game state. */
  start() {
    // TODO
    return state
  }

  /** Return the current player’s legal moves from given state. */
  legalPlays(state) {
    // TODO
    return plays
  }

  /** Advance the given state and return it. */
  nextState(state, move) {
    // TODO
    return newState
  }

  /** Return the winner of the game. */
  winner(state) {
    // TODO
    return winner
  }
}

module.exports = Game
```

In `monte-carlo.js`:

```js
/** Class representing the Monte Carlo search tree. */
class MonteCarlo {

  /** From given state, repeatedly run MCTS to build statistics. */
  runSearch(state, timeout) {
    // TODO
  }

  /** Get the best move from available statistics. */
  bestPlay(state) {
    // TODO
    // return play
  }
}

module.exports = MonteCarlo
```

In `index.js`:

```js
const Game = require('./game.js')
const MonteCarlo = require('./monte-carlo.js')

let game = new Game()
let mcts = new MonteCarlo(game)

let state = game.start()
let winner = game.winner(state)

// From initial state, take turns to play game until someone wins
while (winner === null) {
  mcts.runSearch(state, 1)
  let play = mcts.bestPlay(state)
  state = game.nextState(state, play)
  winner = game.winner(state)
}

console.log(winner)
```

Take a moment to look over the code. Build a scaffold of the subparts in your mind, and make sense of it. This is a mental checkpoint; make sure you understand how it all fits together. Otherwise, leave a comment and I’ll see what I can do.

## Finding the Right Game

In the context of developing an MCTS-playing agent, we can think of our **real** program as the code that implements the MCTS framework; the code in `monte-carlo.js`. The game-specific code in `game.js` is interchangeable, plug-and-play; it is the interface through which we use our MCTS framework. We’re primarily interested in making the brains behind MCTS, and it should really work with any game we decide to run it on. After all, we’re interested in **general** game-playing.

To test our MCTS framework, though, we’ll need to **pick** a specific game and run our framework using that. We want to see our framework spit out decisions that make sense for our chosen game at each step of the way.

How about tic-tac-toe, then? It’s what virtually every introductory game-playing instructional uses, and it has some very desirable properties:

* Everyone has played it before,
* Its rules are simple to implement algorithmically,
* It has [perfect information](https://en.wikipedia.org/wiki/Perfect_information) and is deterministic,
* It is an adversarial 2-player game,
* The state space is simple enough to mentally model,
* The state space is complex enough to demonstrate the algorithm’s power.

But tic-tac-toe’s really **boring**, isn’t it? Plus, there’s some chance that you, reader, already know the optimal strategy for tic-tac-toe, and that takes some of the magic away. There are so many games to choose from. Let’s pick another one: how about **connect four**? It has all the benefits above, except maybe enjoying somewhat lower popularity than tic-tac-toe, and one probably can’t as easily build a mental model of connect four’s state space.

![I did it for the memes.](https://cdn-images-1.medium.com/max/2000/1*7KOc9QzhtuzIFgYBHem_Zg.jpeg)

For our implementation, we’ll be using Hasbro’s dimensions and rules. That’s 6 rows by 7 columns; where vertical, horizontal, and diagonal runs of 4 count for wins. Discs are dropped from above, and settle on the first free slot from the bottom (thanks, gravity!).

A quick note before we move on, though. If you’re confident, you can go ahead and implement any game you want by yourself, as long as it adheres to the given game API. Just don’t come crying when you mess up and it doesn’t work. Keep in mind that games like chess and Go are way too complex for even MCTS to (effectively) tackle on its own; Google fixed that in [AlphaGo](https://storage.googleapis.com/deepmind-media/alphago/AlphaGoNaturePaper.pdf) by adding a healthy sprinkling of machine learning to MCTS. If you’re flying your own game, you can skip the next two sections.

## Implement Connect Four

At this point, go ahead and rename `game.js` to `game-c4.js`; and also rename the class to `Game_C4`. Also, create two new classes: `State_C4` in `state-c4.js` to represent game states, and `Play_C4` in `play-c4.js` to represent state transitions.

Although this isn’t the main chunk of this article, how would you build this yourself?

* How would you represent a game state in `State_C4`?
* How would you represent a state transition (i.e. a play, or a move) in `Play_C4`?
* How would you take `State_C4`, `Play_C4`, and the rules of connect four — and put that in cold, hard code in `Game_C4`?

Remember, we need connect four in the form demanded by the high-level API methods defined in the `game-c4.js` skeleton.

Maybe think about it for a while. Or you could just get the completed `[play-c4.js](https://github.com/quasimik/medium-mcts/blob/master/play-c4.js)`, `[state-c4.js](https://github.com/quasimik/medium-mcts/blob/master/state-c4.js)`, and `[game-c4.js](https://github.com/quasimik/medium-mcts/blob/master/game-c4.js)` that I made.

---

Phew! That was a lot of work, wasn’t it? (It was — at least for me.) The code requires some knowledge of [JavaScript](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference), but should be quite readable after some squinting. The most work goes into `Game_C4.winner()`, which builds runs of points in four separate boards, all in `checkBoards`. Each check board accounts a possible winning orientation (horizontal / vertical / left diagonal / right diagonal). The check boards are one larger than the actual game board on 3 sides to provide convenient zero padding for the algorithm.

I’m sure there are better ways to do this. The run-time performance of `Game.winner()` is not great; specifically, in [big-O notation](http://interactivepython.org/runestone/static/pythonds/AlgorithmAnalysis/BigONotation.html), it’s O(rows\*cols) not great. This could be drastically improved by storing `checkBoards` within the state object, and only updating `checkBoards` with the last played cell (which would also be included in the state object). Maybe you can try this optimization later.

## Play Connect Four

Here, we’re going to test `Game_C4` by simulating 1000 games of connect four. Grab this program file: `[test-game-c4.js](https://github.com/quasimik/medium-mcts/blob/master/test-game-c4.js)`.

Run `node test-game-c4.js` on a terminal. On a relatively modern processor and a recent version of Node.js, the 1000 iterations should run in under a second:

```
$ node test-game-c4.js

[ [ 0, 0, 0, 0, 0, 0, 2 ],
  [ 0, 2, 0, 0, 0, 0, 2 ],
  [ 0, 1, 0, 1, 2, 1, 2 ],
  [ 0, 2, 1, 2, 2, 1, 2 ],
  [ 0, 1, 1, 2, 1, 2, 1 ],
  [ 0, 1, 2, 1, 1, 2, 1 ] ]
0.549
```

Player 2 is internally represented by **-1**, for convenience of calculations in `game-c4.js`; the bit of code replacing -1 with 2 is just there to align the board output. The program outputs only one board for brevity, but it really plays 999 other games. After the single board output, it should output the fraction of player 1 wins over all 1000 games — expect a value around 55%, because the first player has first-mover’s advantage.

## Where We Are Now

Alright. We’ve got a working game, with API methods that work with game states represented by nice `State` objects. Where are we at right now?

> Goal: Implement a Monte Carlo Tree Search (MCTS) algorithm to play a game given its rules.

Of course, we’re not there yet. The previous section does one very important thing for us: it provides a tangible goal, forming the backbone for testing our implementation of MCTS. Now, we move on to the main event.

## Implement MCTS

Reading [the previous article](https://medium.com/@quasimik/monte-carlo-tree-search-applied-to-letterpress-34f41c86e238) — particularly the **MCTS in Detail** section — should help with understanding the rest of this article. Here, I’ll follow a similar organization as in **MCTS in Detail**. I’ll also quote myself in some places to elucidate certain points.

#### Implement Search Tree Nodes

![](https://cdn-images-1.medium.com/max/2800/1*X-O642s1_MTFnevaBPk9iQ.jpeg)

> To store the statistical information gained from these simulations, MCTS builds its own **search tree** from scratch…

At this point, invoke your knowledge of [trees](https://en.wikipedia.org/wiki/Tree_(data_structure)). MCTS is a **tree search**, so it’s no surprise that we’ll need **tree nodes**. We will implement these nodes in their own class `MonteCarloNode`, in `monte-carlo-node.js`. Then, we’ll use that to build the search tree in `MonteCarlo`.

```js
/** Class representing a node in the search tree. */
class MonteCarloNode {

  constructor(parent, play, state, unexpandedPlays) {
    
    this.play = play
    this.state = state

    // Monte Carlo stuff
    this.n_plays = 0
    this.n_wins = 0

    // Tree stuff
    this.parent = parent
    this.children = new Map()
    for (let play of unexpandedPlays) {
      this.children.set(play.hash(), { play: play, node: null })
    }
  }

  ...
```

Again, make sure this all makes sense:

* `parent` is the parent `MonteCarloNode`,
* `play` is the `Play` made from the parent to get to this node,
* `state` is the game `State` associated with this node,
* `unexpandedPlays` is an array of legal `Plays` that can be made from this node,
* `this.children` is built from `unexpandedPlays`, and is a [Map](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Map) of `Plays` to children `MonteCarloNodes` (not quite, see below).

`MonteCarloNode.children` is a map from play hashes to an object containing (1) the play object and (2) the associated child node. We include the play object here for convenient recovery of play objects from their hashes.

Importantly, `Play` and `State` should provide `hash()` methods. We’ll use these hashes as keys to JavaScript Maps in several places, like in `MonteCarloNode.children`.

Note that two `State` objects should be considered different by `State.hash()` — even if they have the same board state — if each reached that identical board state through **different play orders**. With this in mind, we can simply make `State.hash()` return a stringified ordered array of `Play` objects, representing the moves made to reach that state. If you grabbed my copy of `state-c4.js`, this is already done.

We’ll now add member methods to `MonteCarloNode`.

```js
  ...

  /** Get the MonteCarloNode corresponding to the given play. */
  childNode(play) {
    // TODO
    // return MonteCarloNode
  }

  /** Expand the specified child play and return the new child node. */
  expand(play, childState, unexpandedPlays) {
    // TODO
    // return MonteCarloNode
  }

  /** Get all legal plays from this node. */
  allPlays() {
    // TODO
    // return Play[]
  }

  /** Get all unexpanded legal plays from this node. */
  unexpandedPlays() {
    // TODO
    // return Play[]
  }

  /** Whether this node is fully expanded. */
  isFullyExpanded() {
    // TODO
    // return bool
  }

  /** Whether this node is terminal in the game tree, 
      NOT INCLUSIVE of termination due to winning. */
  isLeaf() {
    // TODO
    // return bool
  }
  
  /** Get the UCB1 value for this node. */
  getUCB1(biasParam) {
    // TODO
    // return number
  }
}

module.exports = MonteCarloNode
```

That’s a lot of methods!

In particular, `MonteCarloNode.expand()` replaces null (unexpanded) nodes in `MonteCarloNode.children` with real nodes. This method will be a part of **Phase 2: Expansion** in the four-phase MCTS algorithm. Other methods explain themselves.

As usual, you can implement these yourself or you can grab the completed `[monte-carlo-node.js](https://github.com/quasimik/medium-mcts/blob/master/monte-carlo-node.js)`. Even if you do it yourself, I recommend checking against my completed program to make sure everything’s OK before moving on.

If you just grabbed my completed program, have a quick glance over the implementation, just as another mental checkpoint to re-center your overall understanding. These are short methods. You’ll get through them in no time.

![](https://cdn-images-1.medium.com/max/2000/1*eFzE9DWAfJKpehpbYSqivQ.png)

In particular, `MonteCarloNode.getUCB1()` is an almost direct translation of the following formula into code. This whole equation is explained in detail in the previous article. Go take another look; it’s not that hard to understand and it’s worth it.

#### Update the MonteCarlo Class

The current version is [monte-carlo-v1.js](https://github.com/quasimik/medium-mcts/blob/master/monte-carlo-v1.js), a mere skeleton. The first update to the class is to include `MonteCarloNode` and to add a constructor.

```js
const MonteCarloNode = require('./monte-carlo-node.js')

/** Class representing the Monte Carlo search tree. */
class MonteCarlo {
    
  constructor(game, UCB1ExploreParam = 2) {
    this.game = game
    this.UCB1ExploreParam = UCB1ExploreParam
    this.nodes = new Map() // map: State.hash() => MonteCarloNode
  }

  ...
```

`MonteCarlo.nodes` allows us to get any node given its state; this will be useful. As for the other member variables, it just makes sense for them to be associated with `MonteCarlo`.

```js
  ...

  /** If given state does not exist, create dangling node. */
  makeNode(state) {
    if (!this.nodes.has(state.hash())) {
      let unexpandedPlays = this.game.legalPlays(state).slice()
      let node = new MonteCarloNode(null, null, state, unexpandedPlays)
      this.nodes.set(state.hash(), node)
    }
  }

  ...
```

This lets us create the root node. It also lets us create arbitrary nodes, which could be useful. Maybe.

```js
  ...

  /** From given state, repeatedly run MCTS to build statistics. */
  runSearch(state, timeout = 3) {

    this.makeNode(state)

    let end = Date.now() + timeout * 1000
    while (Date.now() < end) {

      let node = this.select(state)
      let winner = this.game.winner(node.state)

      if (node.isLeaf() === false && winner === null) {
        node = this.expand(node)
        winner = this.simulate(node)
      }
      this.backpropagate(node, winner)
    }
  }

  ...
```

Finally, we arrive at the heart of the algorithm. Quoting verbatim from [the first article](https://medium.com/@quasimik/monte-carlo-tree-search-applied-to-letterpress-34f41c86e238), here’s what’s happening:

1. In phase (1), existing information is used to repeatedly choose successive child nodes down to the end of the search tree.
2. Next, in phase (2), the search tree is expanded by adding a node.
3. Then, in phase (3), a simulation is run to the end to determine the winner.
4. Finally, in phase (4), all the nodes in the selected path are updated with new information gained from the simulated game.

This 4-phase algorithm is run repeatedly until enough information is gathered to produce a good move.

```js
  ...

  /** Get the best move from available statistics. */
  bestPlay(state) {
    // TODO
    // return play
  }

  /** Phase 1, Selection: Select until not fully expanded OR leaf */
  select(state) {
    // TODO
    // return node
  }

  /** Phase 2, Expansion: Expand a random unexpanded child node */
  expand(node) {
    // TODO
    // return childNode
  }

  /** Phase 3, Simulation: Play game to terminal state, return winner */
  simulate(node) {
    // TODO
    // return winner
  }

  /** Phase 4, Backpropagation: Update ancestor statistics */
  backpropagate(node, winner) {
    // TODO
  }
}
```

Here are stub methods that we’ll fill in shortly. We’re now at version [monte-carlo-v2.js](https://github.com/quasimik/medium-mcts/blob/master/monte-carlo-v2.js).

#### Implement MCTS Phase 1: Selection

![](https://cdn-images-1.medium.com/max/2800/1*HXg8Z9BTtlrH0clwTEkF8w.jpeg)

> Starting from the root node of the search tree, we go down the tree by repeatedly (1) selecting a legal move and (2) advancing to the corresponding child node. If one, several, or all of the legal moves in a node does not have a corresponding node in the search tree, we stop selection.

```js
  ...  

  /** Phase 1, Selection: Select until not fully expanded OR leaf */
  select(state) {

    let node = this.nodes.get(state.hash())
    while(node.isFullyExpanded() && !node.isLeaf()) {

      let plays = node.allPlays()
      let bestPlay
      let bestUCB1 = -Infinity

      for (let play of plays) {
        let childUCB1 = node.childNode(play)
                            .getUCB1(this.UCB1ExploreParam)
        if (childUCB1 > bestUCB1) {
          bestPlay = play
          bestUCB1 = childUCB1
        }
      }
      node = node.childNode(bestPlay)
    }
    return node
  }

  ...
```

This function uses the UCB1 statistics available, by querying the UCB1 value of each child node. It selects the child with the highest UCB1 value, then repeats the process for the selected child node’s children, and so on.

When the loop terminates, the selected node is guaranteed to have at least one unexpanded child, **unless** that node is a leaf node. This case is handled by the calling function `MonteCarlo.runSearch()`, so we don’t have to worry about it here.

#### Implement MCTS Phase 2: Expansion

![](https://cdn-images-1.medium.com/max/2800/1*Lxhg0BSSwLmR0kh8uHpDJw.jpeg)

> After selection stops, there will be at least one unexpanded move in the search tree. Now, we randomly choose one of them and we then create the child node corresponding to that move (bolded in the diagram). We add this node as a child to the last selected node in the selection phase, expanding the search tree. The statistics information in the node is initialized with 0 wins out of 0 simulations.

```js
  ...

  /** Phase 2, Expansion: Expand a random unexpanded child node */
  expand(node) {

    let plays = node.unexpandedPlays()
    let index = Math.floor(Math.random() * plays.length)
    let play = plays[index]

    let childState = this.game.nextState(node.state, play)
    let childUnexpandedPlays = this.game.legalPlays(childState)
    let childNode = node.expand(play, childState, childUnexpandedPlays)
    this.nodes.set(childState.hash(), childNode)

    return childNode
  }

  ...
```

Take another look at `MonteCarlo.runSearch()`. Expansion is done within a check if (node.isLeaf() === false && winner === null). Obviously, it’s impossible to expand if there are no children possible in the game tree — for example, when the board is full. We also don’t want to expand if there’s a winner — this is as obvious as saying you should stop playing the game when your opponent wins.

So what happens if the node is leaf? We just backpropagate with whomever won in that node — be it player 1, player -1, or even 0 (a draw). Similarly, if there’s a non-null winner at any node, we just skip expansion and simulation, and immediately backpropagate with that winner (1 or -1 or 0).

What does it mean to backpropagate with a 0 winner? Does it really work okay with MCTS? More on this later. Spoiler: it works okay.

#### Implement MCTS Phase 3: Simulation

![](https://cdn-images-1.medium.com/max/2800/1*cdAMXAIpqWovfOPFd8r81w.jpeg)

> Continuing from the newly-created node in the expansion phase, moves are selected randomly and the game state is repeatedly advanced. This repeats until the game is finished and a winner emerges. No new nodes are created in this phase.

```js
  ...
  
  /** Phase 3, Simulation: Play game to terminal state, return winner */
  simulate(node) {

    let state = node.state
    let winner = this.game.winner(state)

    while (winner === null) {
      let plays = this.game.legalPlays(state)
      let play = plays[Math.floor(Math.random() * plays.length)]
      state = this.game.nextState(state, play)
      winner = this.game.winner(state)
    }

    return winner
  }

  ...
```

Because nothing is saved here, this mostly involves `Game` and not much of `MonteCarloNode`.

Looking at `MonteCarlo.runSearch()` again, simulation is done within the same check if (node.isLeaf() === false && winner === null) as expansion. The reason: if one of these two conditions hold, then the final winner is whomever the winner of the current node is. We just use this winner for backpropagation.

#### Implement MCTS Phase 4: Backpropagation

![](https://cdn-images-1.medium.com/max/2800/1*1iSZ0jZgzj4K0uBypQK_Pg.jpeg)

> After the simulation phase, the statistics on all the visited nodes (bolded in the diagram) are updated. Each visited node has its simulation count incremented. Depending on which player wins, its win count may also be incremented. In the diagram, **blue** wins, so each visited **red** node’s win count is incremented. This flip is due to the fact that each node’s statistics are used for its **parent** node’s choice, not its own.

```js
  ...

  /** Phase 4, Backpropagation: Update ancestor statistics */
  backpropagate(node, winner) {
    while (node !== null) {
      node.n_plays += 1
      // Parent's choice
      if (node.state.isPlayer(-winner)) {
        node.n_wins += 1
      }
      node = node.parent
    }
  }
}

module.exports = MonteCarlo
```

This is the part that affects the selection phase in the next iteration of the search. Note that this assumes a two-player game, allowing the flip in `node.state.isPlayer(-winner)`. You can probably generalize this function for an **n**-player game by doing node.parent.state.isPlayer(winner) or something.

Think a while about what it means to backpropagate with a 0 winner. This corresponds to a drawn game, and every visited node’s `n_plays` statistics get incremented, while neither player 1's nor player -1’s `n_wins` statistics get incremented. This update behaves like a **lost game for both players**, pushing selection towards other plays. In the end, games that end in a draw are as likely to be under-explored as games that end in a loss. This doesn’t break anything, but it results in suboptimal play for when forcing a draw is preferable to losing. A quick fix would be to increment `n_wins` of both players by **half** on draws.

#### Implement Best Play Selection

![](https://cdn-images-1.medium.com/max/2800/1*_dqXQtC0YC_lsi32ZVoPgg.jpeg)

> The beauty of MCTS(UCT) is that, due to its asymmetrical nature, the tree selection and growth gradually converges to better moves. At the end, you get the child node with the highest number of simulations and that’s your best move according to MCTS.

```js
  ...
  
  /** Get the best move from available statistics. */  
  bestPlay(state) {

    this.makeNode(state)

    // If not all children are expanded, not enough information
    if (this.nodes.get(state.hash()).isFullyExpanded() === false)
      throw new Error("Not enough information!")

    let node = this.nodes.get(state.hash())
    let allPlays = node.allPlays()
    let bestPlay
    let max = -Infinity

    for (let play of allPlays) {
      let childNode = node.childNode(play)
      if (childNode.n_plays > max) {
        bestPlay = play
        max = childNode.n_plays
      }
    }

    return bestPlay
  }

  ...
```

Note that there are different ways to choose the “best” play. The one here is called **robust child** in the literature, choosing the highest `n_plays`. Another is **max child**, which chooses the highest winrate `n_wins/n_plays`.

## Implement Statistics Introspection and Display

Right now, you should be able to run `node index.js` on the current version `[index-v1.js](https://github.com/quasimik/medium-mcts/blob/master/index-v1.js)`; however, you won’t see very much. To see what’s happening inside, we need to do a bit more.

In `monte-carlo.js`:

```js
  ...  
  
  // Utility Methods

  /** Return MCTS statistics for this node and children nodes */
  getStats(state) {

    let node = this.nodes.get(state.hash())
    let stats = { n_plays: node.n_plays, 
                  n_wins: node.n_wins, 
                  children: [] }
    
    for (let child of node.children.values()) {
      if (child.node === null) 
        stats.children.push({ play: child.play, 
                              n_plays: null, 
                              n_wins: null})
      else 
        stats.children.push({ play: child.play, 
                              n_plays: child.node.n_plays, 
                              n_wins: child.node.n_wins})
    }

    return stats
  }
}

module.exports = MonteCarlo
```

This lets us query the statistics of a node and its direct children. With this done, we have completed `MonteCarlo`. You can run with what you have, or optionally grab my completed `[monte-carlo.js](https://github.com/quasimik/medium-mcts/blob/master/monte-carlo.js)`. Note that in my completed version, there’s an additional parameter on `bestPlay()` to control the best-play policy used.

Now, incorporate `MonteCarlo.getStats()` into `index.js` yourself, or instead grab my complete version of `[index.js](https://github.com/quasimik/medium-mcts/blob/master/index.js)`.

Then, run `node index.js`:

```
$ node index.js

player: 1
[ [ 0, 0, 0, 0, 0, 0, 0 ],
  [ 0, 0, 0, 0, 0, 0, 0 ],
  [ 0, 0, 0, 0, 0, 0, 0 ],
  [ 0, 0, 0, 0, 0, 0, 0 ],
  [ 0, 0, 0, 0, 0, 0, 0 ],
  [ 0, 0, 0, 0, 0, 0, 0 ] ]
{ n_plays: 3996,
  n_wins: 1664,
  children: 
   [ { play: Play_C4 { row: 5, col: 0 }, n_plays: 191, n_wins: 85 },
     { play: Play_C4 { row: 5, col: 1 }, n_plays: 513, n_wins: 287 },
     { play: Play_C4 { row: 5, col: 2 }, n_plays: 563, n_wins: 320 },
     { play: Play_C4 { row: 5, col: 3 }, n_plays: 1705, n_wins: 1094 },
     { play: Play_C4 { row: 5, col: 4 }, n_plays: 494, n_wins: 275 },
     { play: Play_C4 { row: 5, col: 5 }, n_plays: 211, n_wins: 97 },
     { play: Play_C4 { row: 5, col: 6 }, n_plays: 319, n_wins: 163 } ] }
chosen play: Play_C4 { row: 5, col: 3 }

player: 2
[ [ 0, 0, 0, 0, 0, 0, 0 ],
  [ 0, 0, 0, 0, 0, 0, 0 ],
  [ 0, 0, 0, 0, 0, 0, 0 ],
  [ 0, 0, 0, 0, 0, 0, 0 ],
  [ 0, 0, 0, 0, 0, 0, 0 ],
  [ 0, 0, 0, 1, 0, 0, 0 ] ]
{ n_plays: 6682,
  n_wins: 4239,
  children: 
   [ { play: Play_C4 { row: 5, col: 0 }, n_plays: 577, n_wins: 185 },
     { play: Play_C4 { row: 5, col: 1 }, n_plays: 799, n_wins: 277 },
     { play: Play_C4 { row: 5, col: 2 }, n_plays: 1303, n_wins: 495 },
     { play: Play_C4 { row: 4, col: 3 }, n_plays: 1508, n_wins: 584 },
     { play: Play_C4 { row: 5, col: 4 }, n_plays: 1110, n_wins: 410 },
     { play: Play_C4 { row: 5, col: 5 }, n_plays: 770, n_wins: 265 },
     { play: Play_C4 { row: 5, col: 6 }, n_plays: 614, n_wins: 200 } ] }
chosen play: Play_C4 { row: 4, col: 3 }

...

winner: 2
[ [ 0, 0, 2, 2, 2, 0, 0 ],
  [ 1, 0, 2, 2, 1, 0, 1 ],
  [ 2, 0, 2, 1, 1, 2, 2 ],
  [ 1, 0, 1, 1, 2, 1, 1 ],
  [ 2, 0, 2, 2, 1, 2, 1 ],
  [ 1, 0, 2, 1, 1, 2, 1 ] ]
```

Beautiful.

## Parting Words

It’s been a wonderful journey, and I hope you’ve enjoyed it. The next post will be about optimization, and the current state of the art in MCTS.

I’ll see you then.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
