> * 原文地址：[I Built Tic Tac Toe With JavaScript](https://mitchum.blog/i-built-tic-tac-toe-with-javascript/)
> * 原文作者：[MITCHUM](https://mitchum.blog/author/mitchm/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/i-built-tic-tac-toe-with-javascript.md](https://github.com/xitu/gold-miner/blob/master/TODO1/i-built-tic-tac-toe-with-javascript.md)
> * 译者：
> * 校对者：

# I Built Tic Tac Toe With JavaScript

In my last post I showed you guys a [matching game](https://www.mitchum.blog/i-built-a-simple-matching-game-with-javascript/) I built using JavaScript and talked a bit about front-end [web technologies](https://mitchum.blog/how-a-dynamic-web-application-works-an-epic-tale-of-courage-and-sacrifice/). I received some positive feedback, so for this week’s post I decided to build a [tic tac toe game](https://www.mitchum.blog/games/tic-tac-toe/tic-tac-toe.html) using JavaScript and describe its construction in detail. I also took on the additional challenge of not using any external JavaScript libraries in the project.

[Click here](https://www.mitchum.blog/games/tic-tac-toe/tic-tac-toe.html) to play tic-tac-toe!

There are two difficulty levels: moron and genius. Once you’ve bested the moron, see if you can defeat the tic-tac-toe genius. The genius is more formidable than the moron, but he is a little arrogant and isn’t actually all that bright. As a reader of my blog, I bet you are smart enough to exploit the flaws in his thinking.

## How It’s Made

This tic tac toe game is built using the three basic front-end web technologies: HTML, CSS, and JavaScript. I’m going to show you the code for each and describe the role they play in creating the final game. Here are the three files:

[tic-tac-toe.html](https://mitchum.blog/games/tic-tac-toe/tic-tac-toe.html)

[tic-tac-toe.css](https://mitchum.blog/games/tic-tac-toe/tic-tac-toe.css)

[tic-tac-toe.js](https://mitchum.blog/games/tic-tac-toe/tic-tac-toe.js)

### HTML

##### The Header

Let’s start with the head tag, shown below. This tag comes at the start of every HTML document you create. It’s a good place for including elements that affect the page as a whole.

```
<head>
    <title>Tic Tac Toe</title>
    <link rel="stylesheet" href="tic-tac-toe.css">
    <link rel="shortcut icon" 
          href="https://mitchum.blog/wp-content/uploads/2019/05/favicon.png" />
</head>        
```

Our head tag has three child tags inside of it: a title tag and two link tags. The tab of our web browser displays the contents of our title tag. In our case this is “Tic Tac Toe”. The second link tag contains a reference to the icon we want displayed in the tab of our web browser. Together, they form a tab that looks like this:

![Browser tab for javascript Tic Tac Toe game](https://i1.wp.com/mitchum.blog/wp-content/uploads/2019/06/tab.png?w=740&ssl=1)

The first link tag contains a reference to our [tic-tac-toe.css](https://mitchum.blog/games/tic-tac-toe/tic-tac-toe.css) file. This file is what lets us add color and positioning to our HTML document. Our game would look rather dreary without including this file.

![Tic Tac Toe game without css applied](https://i2.wp.com/mitchum.blog/wp-content/uploads/2019/06/htmlonly-1.png?w=740&ssl=1)

Our HTML document without any style.

Next we have the main body of our HTML document. We are going to break it up into two sections: the board and the controls. We’ll start with the board.

##### The Board

We are using a table tag for representing our tic-tac-toe game board. The code is shown below:

```
<table class="board">
<tr>
  <td>
      <div id="0" class="square left top"></div>
  </td>
  <td>
      <div id="1" class="square top v-middle"></div>
  </td>
  <td>
      <div id="2" class="square right top"></div>
  </td>
</tr>
<tr>
  <td>
      <div id="3" class="square left h-middle"></div>
  </td>
  <td>
      <div id="4" class="square v-middle h-middle"></div>
  </td>
  <td>
      <div id="5" class="square right h-middle"></div>
  </td>
</tr>
<tr>
  <td>
      <div id="6" class="square left bottom"></div>
  </td>
  <td>
      <div id="7" class="square bottom v-middle"></div>
  </td>
  <td>
      <div id="8" class="square right bottom"></div>
  </td>
</tr> 
</table>
```

We have added the class, “board” to the table in order to add styling to it. The board has three table row tags each containing three table data tags. This results in a 3×3 game board. We have assigned each square of the game board a numerical id and some classes indicating its positioning.

##### The Controls

What I’m calling the controls section consists of a message box, a few buttons, and drop down list. The code looks like this:

```
<br>
<div id="messageBox">Pick a square!</div>
<br>
<div class="controls">
 <button class="button" onclick="resetGame()">Play Again</button> 
 <form action="https://mitchum.blog/sneaky-subscribe" 
       style="display: inline-block;">
    <button class="button" type="submit">Click Me!</button> 
 </form>
 <select id="difficulty">
   <option value="moron" selected >Moron</option>
   <option value="genius">Genius</option>
 </select>
</div>
```

The message box is situated between two line breaks. Following the second line break is a div containing the rest of our controls. The play again button has a click handler that calls a JavaScript function in [tic-tac-toe.js](https://mitchum.blog/games/tic-tac-toe/tic-tac-toe.js). The mystery button is wrapped inside of a form tag. Finally, the select tag contains two options: moron and genius. The moron option is selected by default.

Each of these HTML elements has been assigned various classes and ids which will be used for assisting in executing the game logic and for adding styling. Let’s talk about how that styling is applied.

## CSS

I’m going to break the explanation of the [tic-tac-toe.css](https://mitchum.blog/games/tic-tac-toe/tic-tac-toe.css) file up into several sections because I think that will make it easier to follow as a reader.

##### Basic Elements

The first section contains styling for the body, main, and h1 tags. The background styling on the body tag simply sets the light blue background color of the page using RGB values.

The max-width, padding, and margin styling on the main tag centers our game on the screen. I borrowed this awesome and succinct styling from this [blog post](https://jrl.ninja/etc/1/).

The h1 tag is contains the big “Tic Tac Toe” heading, and we add style to center it and give it that yellow coloring.

See below:

![CSS styling for the page](https://i2.wp.com/mitchum.blog/wp-content/uploads/2019/06/css1.png?w=740&ssl=1)

##### The Controls

Next we are going to talk about styling for the message box, difficulty drop down list, and the top-level controls section.

We center the text inside the message box and color it yellow. Then we add a border with rounded corners.

We set the size of our difficulty drop down, and add rounded corners, and then we set its font size, colors, and positioning.

The only change we need to make to the controls div is to make sure that everything is centered.

See below:

![ CSS styling for the controls](https://i0.wp.com/mitchum.blog/wp-content/uploads/2019/06/css2.png?w=740&ssl=1)

##### The Board

Next comes the styling of our game board itself. We need to set the size, color, and text positioning of each square. More importantly, we need to make the borders visible in the appropriate locations. We added several classes for identifying where squares are located on the game board, allowing us to create the famous tic-tac-toe pattern. We also varied the size of the border to get a more three dimensional look and feel.

![CSS styling for the tic tac toe board](https://i0.wp.com/mitchum.blog/wp-content/uploads/2019/06/css3.png?w=740&ssl=1)

##### The Buttons

Finally we come to the buttons. I have to confess, I borrowed these styles from [w3schools](https://www.w3schools.com/css/tryit.asp?filename=trycss_buttons_animate3). However, I did modify them slightly to match our color scheme.

![CSS styling for the buttons](https://i0.wp.com/mitchum.blog/wp-content/uploads/2019/06/css4.png?w=740&ssl=1)

Alright, that’s it for the CSS! Now we can finally move onto the fun part: JavaScript.

### JavaScript

As should be expected, the JavaScript code is the most complex part of the tic tac toe game. I’m going to describe the basic structure and the artificial intelligence, but I’m not going to describe each and every function. Instead, I’m going to leave it as an exercise for you to read the code and understand how each function was implemented. These other functions have been made **bold** for your convenience.

If something in the code is confusing then leave a comment and I’ll do my best to explain it! If you can think of a better way to implement something then I would love to hear your feedback in the comments as well. The goal is for everyone to learn more and have fun in the process.

##### Basic Structure

The first thing we need to do is initialize some variables. We have a couple variables for keeping track of the game’s state: one for keeping track of if the game is over, and one for storing the chosen difficulty level.

We also have a few more variables for storing some useful information: An array of our squares, the number of squares, and the win conditions. Our board is represented by a sequential list of numbers, and there are eight possible win conditions. So the win conditions are represented by an array containing eight arrays, one for each possible three square winning combination.

See below:

![initialization javascript variables](https://i2.wp.com/mitchum.blog/wp-content/uploads/2019/06/css5.png?w=740&ssl=1)

With that in mind, let’s talk about how this program works. This game is [event-driven](https://en.wikipedia.org/wiki/Event-driven_architecture). Any action that occurs on-screen happens because you clicked somewhere, and the code responded to it. When you click on the “Play Again” button, the board is cleared and you can play another round of tic tac toe. When you change the difficulty level, the game responds by making different moves in response to yours.

The most important event we have to respond to is when a player clicks on a square. There are lots of things that need to be checked. The bulk of this logic happens inside the top-level function I wrote called **chooseSquare**.

See below:

![Javascript for choosing a tic tac toe square.](https://i1.wp.com/mitchum.blog/wp-content/uploads/2019/06/js2.png?w=740&ssl=1)

##### The Code Examined

Let’s walk through the code from top to bottom.

**Line 176:** The first thing we do is set the difficulty variable to whatever was chosen in the drop down list. This is important because our artificial intelligence looks at this variable to determine what move to make.

**Line 177:** The second thing we do is check if the game is over. If it is not then we can proceed. Otherwise, there is no need to continue.

**Lines 179 – 181:** Third, we set the message displayed to the player to the default, “Pick a square!” message. We do this by calling the **setMessageBox** function. Then we set variables for the id and the HTML of the square that was selected by the player.

**Line 182:** We check if the square is open by calling **squareIsOpen**. If a marker has already been placed there then the player is trying to make an illegal move. In the corresponding else block, we notify him as such.

**Lines 184 -185:** Since the square is open, we set the marker to “X”. Then we check to see if we won by calling **checkForWinCondition**. If we won we are returned an array containing the winning combination. If lost we are simply returned false. This is possible because JavaScript is not [type safe](https://en.wikipedia.org/wiki/Type_safety).

**Line 186:** If the player didn’t win then we must continue so that his opponent can make a move. If the player did win, then the corresponding else block will handle it by setting the game over variable to true, turning the winning squares green by calling **highlightWinningSquares**, and setting the winning message.

**Lines 188 – 189:** Now that the player’s move is finished we need to make a move for the computer. The function called **opponentMove** handles this, and it will be discussed later in detail. Then we need to check to see if the player lost by calling the same function we used on line 185, but this time passing in “O” as a parameter. Yay for reusability!

**Line 190:** If the computer did not win then we must continue so that we can check for a draw. If the computer did win, then the corresponding else block will handle it by setting the game over variable to true, turning the winning squares red by calling **highlightWinningSquares**, and setting the losing message.

**Lines 192 – 197:** We check for a draw by calling the **checkForDraw** function. If there are no win conditions met and there are no more available moves to be made then we must have reached a draw. If a draw has been reached then we set the game over variable to true and set the draw message.

That’s it for the main game logic! The rest of this function is just the corresponding else blocks which we already covered. As I mentioned previously, go read through the other functions to get a fuller understanding of how the game logic works.

##### Artificial Intelligence

There are two difficulty levels: moron and genius. The moron always takes the first available square in order of id. He will sacrifice a win just to keep up this orderly pattern, and he will not deviate from it even to prevent a loss. He is a simpleton.

The genius is much more sophisticated. He will take a win when its there, and he will try to prevent a loss. Going second puts him at a disadvantage, so he favors the center square for its defensive qualities. However, he does have weaknesses that can be exploited. He’s following a better set of rules, but he isn’t great at adapting to situations on the fly. When he can’t find an obvious move to make he reverts back to the same simple ways of the moron.

See below:

![AI top level javascript function](https://i0.wp.com/mitchum.blog/wp-content/uploads/2019/06/js4.png?w=740&ssl=1)

The top level AI function

![AI implementation details in javascript](https://i2.wp.com/mitchum.blog/wp-content/uploads/2019/06/js5.png?w=740&ssl=1)

The AI implementation details

Once you understand the algorithm let me know in the comments what changes we could make to turn our wannabe genius into a true one!

(adsbygoogle = window.adsbygoogle || \[\]).push({});

### Summary

In this post I showed off the Tic Tac Toe game I made using JavaScript. Then we looked at how it was constructed and how the artificial intelligence works. Let me know what you think, and what kind of games you would like to see me make in the future. Keep in mind though, I’m only one guy, so no asking for Call of Duty!

If you want to learn more about how to write good programs in JavaScript, one book that I recommend is [JavaScript: The Good Parts](https://amzn.to/2XrvPrt), by the legendary Douglas Crockford. The language has been improved dramatically over the years, but it still has some odd properties because of its development history. The book does a great job of helping you navigate around its more questionable design choices. I found it helpful when I was learning the language.

If you decide to purchase it, I would be grateful if you decided to go through the link above. I will get a commission through Amazon’s affiliate program, with no additional cost to you. It helps me keep this site up and running.

Thanks for reading, and I’ll see you next time!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
