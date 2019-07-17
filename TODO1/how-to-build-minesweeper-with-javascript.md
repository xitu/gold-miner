> * 原文地址：[How To Build Minesweeper With JavaScript](https://mitchum.blog/how-to-build-minesweeper-with-javascript/)
> * 原文作者：[Mitchum](https://mitchum.blog/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-build-minesweeper-with-javascript.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-build-minesweeper-with-javascript.md)
> * 译者：
> * 校对者：

# How To Build Minesweeper With JavaScript

![](https://i1.wp.com/mitchum.blog/wp-content/uploads/2019/07/featureimage.png?w=600&ssl=1)

In my last post I showed you guys a [tic tac toe](https://mitchum.blog/i-built-tic-tac-toe-with-javascript/) game I built using JavaScript, and before that I built a [matching game](https://mitchum.blog/i-built-a-simple-matching-game-with-javascript/). For this week’s post I decided to ramp up the complexity a bit. You guys are going to learn how to build minesweeper with JavaScript. I also used jQuery, a JavaScript library that is helpful for interacting with html. Whenever you see a function call with a leading dollar sign, that is jQuery at work. If you want to learn more about it, the [documentation](https://api.jquery.com/) for it is very good.

**[Click here](https://mitchum.blog/games/minesweeper/minesweeper.html)** to play minesweeper! You will want to play it on your desktop computer because of the control scheme.

Here are the three files necessary for creating the game:

* [HTML](http://mitchum.blog/games/minesweeper/minesweeper.html)
* [CSS](http://mitchum.blog/games/minesweeper/minesweeper.css)
* [JavaScript](http://mitchum.blog/games/minesweeper/minesweeper.js)

If you want to learn how to build minesweeper with JavaScript, the first step is understanding how the game works. Let’s jump right in and talk about the rules.

## Rules of the Game

1. The minesweeper board is a 10 x 10 square. We could make it other sizes, like the classic Windows version, but for demonstration purposes we will stick to the smaller, “beginner” version of the game.
2. The board has a predetermined number of randomly placed mines. The player cannot see them.
3. Cells can exist in one of two states: opened or closed. Clicking on a cell opens it. If a mine was lurking there, the game ends in failure. If there is no mine in the cell, but there are mines in one or more of its neighboring cells, then the opened cell shows the neighboring mine count. When none of the cell’s neighbors are mined, each one of those cells is opened automatically.
4. Right clicking on a cell marks it with a flag. The flag indicates that the player knows there is a mine lurking there.
5. Holding down the ctrl button while clicking on an opened cell has some slightly complicated rules. If the number of flags surrounding the cell match its neighbor mine count, and each flagged cell actually contains a mine, then all closed, unflagged neighboring cells are opened automatically. However, if even one of these flags was placed on the wrong cell, the game ends in failure.
6. The player wins the game if he/she opens all cells without mines.

## Data Structures

### Cell

![JavaScript code for a minesweeper cell](https://i2.wp.com/mitchum.blog/wp-content/uploads/2019/07/cell.png?w=740&ssl=1)

JavaScript code representing a minesweeper cell.

Each cell is an object that has several properties:

* **id**: A string containing the row and column. This unique identifier makes it easier to find cells quickly when needed. If you pay close attention you will notice that there are some shortcuts I take related to the ids. I can get away with these shortcuts because of the small board size, but these techniques will not scale to larger boards. See if you can spot them. If you do, point them out in the comments!
* **row**: An integer representing the horizontal position of the cell within the board.
* **column**: An integer representing the vertical position of the cell within the board.
* **opened**: This is a boolean property indicating whether the cell has been opened.
* **flagged**: Another boolean property indicating whether a flag has been placed on the cell.
* **mined**: Yet another boolean property indicating whether the cell has been mined.
* **neighborMineCount**: An integer indicating the number of neighboring cells containing a mine.

### Board

![JavaScript code for the minesweeper board](https://i0.wp.com/mitchum.blog/wp-content/uploads/2019/07/board.png?w=740&ssl=1)

JavaScript code representing our game board.

Our board is a collection of cells. We could represent our board in many different ways. I chose to represent it as an object with key value pairs. As we saw earlier, each cell has an id. The board is just a mapping between these unique keys and their corresponding cells.

After creating the board we have to do two more tasks: randomly assign the mines and calculate the neighboring mine counts. We’ll talk more about these tasks in the next section.

## Algorithms

### Randomly Assign Mines

![JavaScript code for randomly assigning mines](https://i0.wp.com/mitchum.blog/wp-content/uploads/2019/07/randomlyassignmines-1.png?w=740&ssl=1)

JavaScript code for randomly assigning mines to cells.

One of the first things we have to do before a game of minesweeper can be played is assign mines to cells. For this, I created a function that takes the board and the desired mine count as parameters.

For every mine we place, we must generate a random row and column. Furthermore, the same row and column combination should never appear more than once. Otherwise we would end up with less than our desired number of mines. We must repeat the random number generation if a duplicate appears.

As each random cell coordinate is generated we set the **mined** property to true of the corresponding cell in our board.

I created a helper function in order to help with the task of generating random numbers within our desired range. See below:

![JavaScript code for random integer generator.](https://i0.wp.com/mitchum.blog/wp-content/uploads/2019/07/getrandominteger.png?w=740&ssl=1)

Helper function for generating random integers.

### Calculate Neighbor Mine Count

![](https://i0.wp.com/mitchum.blog/wp-content/uploads/2019/07/calculateneighborminecounts-1.png?w=740&ssl=1)

JavaScript code for calculating the neighboring mine count of each cell.

Now let’s look at what it takes to calculate the neighboring mine count of each cell in our board.

You’ll notice that we start by looping through each row and column on the board, a very common pattern. This will allow us to execute the same code on each of our cells.

We first check if each cell is mined. If it is, there is no need to check the neighboring mine count. After all, if the player clicks on it he/she will lose the game!

If the cell is not mined then we need to see how many mines are surrounding it. The first thing we do is call our **getNeighbors** helper function, which returns a list of ids of the neighboring cells. Then we loop through this list, add up the number of mines, and update the cell’s **neighborMineCount** property appropriately.

##### Won’t you be my neighbor?

Let’s take a closer look at that **getNeighbors** function, as it will be used several more times throughout the code. I mentioned earlier that some of my design choices won’t scale to larger board sizes. Now would be a good time to try and spot them.

![](https://i2.wp.com/mitchum.blog/wp-content/uploads/2019/07/getneighbors.png?w=740&ssl=1)

JavaScript code for getting all of the neighboring ids of a minesweeper cell.

The function takes a cell id as a parameter. Then we immediately split it into two pieces so that we have variables for the row and the column. We use the **parseInt** function, which is built into the JavaScript language, to turn these variables into integers. Now we can perform math operations on them.

Next, we use the row and column to calculate potential ids of each neighboring cell and push them onto a list. Our list should have eight ids in it before cleaning it up to handle special scenarios.

![](https://i1.wp.com/mitchum.blog/wp-content/uploads/2019/07/neighborsexample.png?w=740&ssl=1)

A minesweeper cell and its neighbors.

While this is fine for the general case, there are some special cases we have to worry about. Namely, cells along the borders of our game board. These cells will have less than eight neighbors.

In order to take care of this, we loop through our list of neighbor ids and remove any id that is greater than 2 in length. All invalid neighbors will either be -1 or 10, so this little check solves the problem nicely.

We also have to decrement our index variable whenever we remove an id from our list in order to keep it in sync.

##### Is it mined?

Okay, we have one last function to talk about in this section: **isMined**.

![JavaScript function that checks if a cell is mined.](https://i0.wp.com/mitchum.blog/wp-content/uploads/2019/07/ismined.png?w=740&ssl=1)

JavaScript function that checks if a cell is mined.

The **isMined** function is pretty simple. It just checks if the cell is mined or not. The function returns a 1 if it is mined, and a 0 if it is not mined. This feature allows us to sum up the function’s return values as we call it repeatedly in the loop.

That wraps up the algorithms for getting our minesweeper game board set up. Let’s move on to the actual game play.

### Opening A Cell

![JavaScript code that executes when a minesweeper cell is opened.](https://i2.wp.com/mitchum.blog/wp-content/uploads/2019/07/handleclick.png?w=740&ssl=1)

JavaScript code that executes when a minesweeper cell is opened.

Alright let’s dive right into this bad boy. We execute this function whenever a player clicks on a cell. It does **a lot** of work, and it also uses something called recursion. If you are unfamiliar with the concept, see the definition below:

**Recursion**: See ****recursion****.

Ah, computer science jokes. They always go over so well at bars and coffee shops. You really ought to try them out on that cutie you’ve been crushing on.

Anyways, a [recursive function](https://en.wikipedia.org/wiki/Recursion_(computer_science)) is just a function that calls itself. Sounds like a stack overflow waiting to happen, right? That’s why you need a base case that returns a value without making any subsequent recursive calls. Our function will eventually stop calling itself because there will be no more cells that need to be opened.

Recursion is rarely the right choice in a real world project, but it is a useful tool to have in your toolbox. We could have written this code without recursion, but I thought you all might want to see an example of it in action.

##### Handle Click Explained

The **handleClick** function takes a cell id as a parameter. We need to handle the case where the player pressed the ctrl button while clicking on the cell, but we will talk about that in a later section.

Assuming the game isn’t over and we are handling a basic left click event, there are a few checks we need to make. We want to ignore the click if the player already opened or flagged the cell. It would be frustrating for the player if an inaccurate click on an already flagged cell ended the game.

If neither of those are true then we will proceed. If a mine is present in the cell we need to initiate the game over logic and display the exploded mine in red. Otherwise, we will open the cell.

If the opened cell has mines surrounding it we will display the neighboring mine count to the player in the appropriate font color. If there are no mines surrounding the cell, then it is time for our recursion to kick in. After setting the background color of the cell to a slightly darker shade of gray, we call **handleClick** on each unopened neighboring cell without a flag.

##### Helper Functions

Let’s take a look at the helper functions we are using inside the **handleClick** function. We’ve already talked about **getNeighbors**, so we’ll skip that one. Let’s start with the **loss** function.

![JavaScript code that gets called whenever the player has lost at minesweeper.](https://i2.wp.com/mitchum.blog/wp-content/uploads/2019/07/loss.png?w=740&ssl=1)

JavaScript code that gets called whenever the player has lost the game.

When a loss occurs, we set the variable that tracks this and then display a message letting the player know that the game is over. We also loop through each cell and display the mine locations. Then we stop the clock.

Second, we have the **getNumberColor** function. This function is responsible for giving us the color corresponding to the neighboring mine count.

![JavaScript code that gets passed a number and returns a color. ](https://i0.wp.com/mitchum.blog/wp-content/uploads/2019/07/getnumbercolor.png?w=740&ssl=1)

JavaScript code that gets passed a number and returns a color.

I tried to match up the colors just like the classic Windows version of minesweeper does it. Maybe I should have used a [switch statement](https://www.w3schools.com/js/js_switch.asp) here, but I already took the screen shot, and it’s not really a big deal. Let’s move on to what the code looks like for putting a flag on a cell.

### Flagging A Cell

![JavaScript code for putting a flag on a minesweeper cell.](https://i1.wp.com/mitchum.blog/wp-content/uploads/2019/07/handlerightclick.png?w=740&ssl=1)

JavaScript code for putting a flag on a minesweeper cell.

Right clicking on a cell will place a flag on it. If the player right clicks on an empty cell and we have more mines that need to be flagged we will display the red flag on the cell, update its **flagged** property to true, and decrement the number of mines remaining. We do the opposite if the cell already had a flag. Finally, we update the GUI to display the number of mines remaining.

### Opening Neighboring Cells

![JavaScript code for handling ctrl + left click](https://i0.wp.com/mitchum.blog/wp-content/uploads/2019/07/handlctrlclick.png?w=740&ssl=1)

JavaScript code for handling ctrl + left click

We have covered the actions of opening cells and marking them with flags, so let’s talk about the last action a player can take: opening an already opened cell’s neighboring cells. The **handleCtrlClick** function contains the logic for this. This player can perform this action by holding ctrl and left clicking on an opened cell that contains neighboring mines.

The first thing we do after checking those conditions is build up a list of the neighboring flagged cells. If the number of flagged cells matches the actual number of surrounding mines then we can proceed. Otherwise, we do nothing and exit the function.

If we were able to proceed, the next thing we do is check if any of the flagged cells did not contain a mine. If this is true, we know that the player predicted the mine locations incorrectly, and clicking on all of the non-flagged, neighboring cells will end in a loss. We will need to set the local **lost** variable and call the **loss** function. We talked about the **loss** function earlier in the article.

If the player did not lose, then we will need to open up the non-flagged neighboring cells. We simply need to loop through them and call the **handleClick** function on each. However, we must first set the **ctrlIsPressed** variable to false to prevent falling into the **handleCtrlClick** function by mistake.

## Starting A New Game

We are almost done analyzing all of the JavaScript necessary to build minesweeper! All that we have left to cover are the initialization steps necessary for starting a new game.

![JavaScript code for initializing minesweeper](https://i0.wp.com/mitchum.blog/wp-content/uploads/2019/07/initializationandvariables-1.png?w=740&ssl=1)

JavaScript code for initializing minesweeper

The first thing we do is initialize a few variables. We need some constants for storing the [html codes](https://www.w3schools.com/html/html_symbols.asp) for the flag and mine icons. We also need some constants for storing the board size, the number of mines, the timer value, and the number of mines remaining.

Additionally, we need a variable for storing if the player is pushing the ctrl button. We utilize jQuery to add the event handlers to the document, and these handlers are responsible for setting the **ctrlIsPressed** variable.

Finally, we call the **newGame** function and also bind this function to the new game button.

### Helper Functions

![JavaScript code for starting a new game of minesweeper.](https://i0.wp.com/mitchum.blog/wp-content/uploads/2019/07/newgame.png?w=740&ssl=1)

JavaScript code for starting a new game of minesweeper.

Th **newGame** function is responsible for resetting our variables so that our game is in a ready-to-play state. This includes resetting the values that are displayed to the player, calling **initializeCells**, and creating a new random board. It also includes resetting the clock, which gets updated every second.

Let’s wrap things up by looking at **initializeCells**.

![JavaScript code for attaching click handlers to minesweeper cells.](https://i1.wp.com/mitchum.blog/wp-content/uploads/2019/07/initializecells.png?w=740&ssl=1)

JavaScript code for attaching click handlers to cells and checking for the victory condition.

The main purpose of this function is to add additional properties to our html game cells. Each cell needs the appropriate id added so that we can access it easily from the game logic. Every cell also needs a background image applied for stylistic reasons.

We also need to attach a click handler to every cell so that we can detect left and right clicks.

The function that handles left clicks calls **handleClick**, passing in the appropriate id. Then it checks to see if every cell without a mine has been opened. If this is true then the player has won the game and we can congratulate him/her appropriately.

The function that handles right clicks calls **handleRightClick**, passing in the appropriate id. Then it simply returns false. This causes the context menu not to pop up, which is the default behavior of a right click on a web page. You wouldn’t want to do this sort of thing for a standard business [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete) application, but for minesweeper it is appropriate.

## Conclusion

Congrats on learning how to build minesweeper with JavaScript! That was a lot of code, but hopefully it makes sense after breaking it up into modules like this. We could definitely make more improvements to this program’s reusability, extensibility, and readability. We also did not cover the HTML or CSS in detail. If you have questions or see ways to improve the code, I’d love to hear from you in the comments!

If these posts are making you want to learn more about how to write good programs in JavaScript, one book that I recommend is [JavaScript: The Good Parts](https://amzn.to/2XrvPrt), by the legendary Douglas Crockford. The man popularized JSON as a data exchange format, and really contributed a lot to the advancement of the web.

The language has been improved dramatically over the years, but it still has some odd properties because of its development history. The book does a great job of helping you navigate around its more questionable design choices, like the global namespace. I found it helpful when I was first learning the language.

[![JavaScript: The Good Parts book](//ws-na.amazon-adsystem.com/widgets/q?_encoding=UTF8&MarketPlace=US&ASIN=0596517742&ServiceVersion=20070822&ID=AsinImage&WS=1&Format=_SL250_&tag=mitchumblog-20)](https://www.amazon.com/gp/product/0596517742/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=0596517742&linkCode=as2&tag=mitchumblog-20&linkId=fa7b0d5ed5bb3d96797d9b9f54a40e32)

If you decide to purchase it, I would be grateful if you decided to go through the [link](https://amzn.to/2XrvPrt) above. I will get a commission through Amazon’s affiliate program, with no additional cost to you. It helps me keep this site up and running without resorting to annoying advertisements. I would rather promote products that I know will be helpful to you guys.

Alright, enough with the promotion. I hope you guys enjoyed learning about how to build minesweeper with JavaScript. Let me know what other simple games like this you would like to see, and don’t forget to [drop me your email](https://mitchum.blog/subscribe/) so you don’t miss the next one that comes out. You will also receive my free checklist for writing great functions.

Take care, and God bless!

**Update (7/13/2019):** This post became more popular than I thought it would, which is awesome! I’ve received a lot of great feedback from readers about areas that could be improved. I work daily in a code base that until recently was stuck in Internet Explorer [quirks mode](https://en.wikipedia.org/wiki/Quirks_mode). Many of my daily habits there transferred to my work on minesweeper, resulting in some code that doesn’t take advantage of the bleeding edge of JavaScript technology. At some point I would like to do another post where I [refactor](https://en.wikipedia.org/wiki/Code_refactoring) the code. I plan to remove jQuery entirely and use the [ES6](https://www.w3schools.com/js/js_es6.asp) syntax instead of the [ES5](https://www.w3schools.com/js/js_es5.asp) syntax where appropriate. But you don’t have to wait for me! See if you can make these changes yourself! And let me know how it goes in the comments.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
