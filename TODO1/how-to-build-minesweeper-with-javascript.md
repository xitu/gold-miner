> * 原文地址：[How To Build Minesweeper With JavaScript](https://mitchum.blog/how-to-build-minesweeper-with-javascript/)
> * 原文作者：[Mitchum](https://mitchum.blog/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-build-minesweeper-with-javascript.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-build-minesweeper-with-javascript.md)
> * 译者：[ZavierTang](https://github.com/zaviertang)
> * 校对者：[Stevens1995](https://github.com/Stevens1995)、[githubmnume](https://github.com/githubmnume)

# 如何用 JavaScript 编写扫雷游戏

![](https://i1.wp.com/mitchum.blog/wp-content/uploads/2019/07/featureimage.png?w=600&ssl=1)

在我的上一篇文章中，我向大家介绍了一款使用 JavaScript 编写的[三连棋游戏](https://mitchum.blog/i-built-tic-tac-toe-with-javascript/)，在那之前我也编写了一款[匹配游戏](https://mitchum.blog/i-built-a-simple-matching-game-with-javascript/)。本周，我决定增加一些复杂性。你们将学习如何用 JavaScript 编写扫雷游戏。我使用了 jQuery，这是一个有助于与 HTML 交互的 JavaScript 库。当你看到一个函数的调用带有一个前导的美元（`$`）符号时，这就是 jQuery 的操作。如果你想了解更多关于 jQuery 的内容，阅读[官方文档](https://api.jquery.com/)是最佳的选择。

[点击](https://mitchum.blog/games/minesweeper/minesweeper.html)试玩扫雷游戏！这款游戏推荐在台式电脑上体验，因为这样更便于操作。

下面是创建这个游戏所需的三个文件：

* [HTML](http://mitchum.blog/games/minesweeper/minesweeper.html)
* [CSS](http://mitchum.blog/games/minesweeper/minesweeper.css)
* [JavaScript](http://mitchum.blog/games/minesweeper/minesweeper.js)

如果你想学习如何使用 JavaScript 编写扫雷游戏，第一步便是要理解游戏是如何工作的。让我们直接从游戏规则开始吧。

## 游戏规则

1. 扫雷的面板是一个 10×10 的正方形。我们可以将它设置成其他大小，比如经典的 Windows 版本，但是为了演示，我们将使用较小的”入门级”版本。
2. 面板上有固定数量随机放置的地雷，玩家将看不到它们。
3. 每个单元格处于两种状态之一：打开或关闭。单击一个单元格将打开它。如果有地雷潜伏在那里，游戏就会以失败告终。如果单元格中没有地雷，但是相邻的一个或多个单元格中有地雷，则打开的单元格显示相邻单元格的地雷数。当相邻的单元格中没有一个是地雷时，这些单元格会自动打开。
4. 右键单击一个单元格将给它标记一个小旗。小旗表示玩家已经知道在那里潜伏着地雷。
5. 在单击处于打开状态的单元格的同时按住 ctrl 键会有一些稍微复杂的规则。如果包围该单元格的标志的数量与其邻的地雷数相匹配，并且每个标记的单元格实际上真的是一个地雷，那么所有处于关闭状态并且未标记的相邻单元格都会自动打开。然而，如果其中的一个标记被放置在错误的单元格上，游戏将以失败告终。
6. 如果玩家打开了所有没有潜伏地雷的单元格，便将赢得游戏。

## 数据结构

### Cell

```js
// 表示单元格的 JavaScript 代码：
function Cell( row, column, opened, flagged, mined, neighborMineCount ) 
{
	return {
		id: row + "" + column,
		row: row,
		column: column,	
		opened: opened,
		flagged: flagged,
		mined: mined,
		neighborMineCount: neighborMineCount
	}
}
```

每个单元格都是一个对象，包含以下属性：

- **id**：包含行和列的字符串。作为唯一标识符使得在需要的时候更容易快速找到单元格。如果你仔细观察，你会注意到我使用了一些与 `id` 相关的快捷方法。我可以使用这些快捷方法，因为扫雷游戏的面板较小，但这些代码也不会考虑扩展到更大的游戏面板上。如果你发现了，请在评论中指出来！
- **row**：表示单元格在游戏面板中的水平位置的整数。
- **column**：表示单元格在游戏面板中的垂直位置的整数。
- **opened**：这是一个布尔值，表示单元格是否处于打开状态。
- **flagged**：另一个布尔值，表示单元格是否被标记。
- **mined**：也是一个布尔值，表示是否在单元格上放置了地雷。
- **neighborMineCount**：一个整数，表示包含地雷的相邻单元格的个数。

### Board

```js
// 表示游戏面板的 JavaScript 代码：
function Board( boardSize, mineCount )
{
	var board = {};
	for( var row = 0; row < boardSize; row++ )
	{
		for( var column = 0; column < boardSize; column++ )
		{
			board[row + "" + column] = Cell( row, column, false, false, false, 0 );
		}
	}
	board = randomlyAssignMines( board, mineCount );
	board = calculateNeighborMineCounts( board, boardSize );
	return board;
}
```

我们的游戏面板是由单元格组成的集合。我们可以用许多不同的方式来代表我们的游戏面板。我选择将它表示为键值对形式的对象。正如我们前面看到的，每个单元格都有一个 `id` 用来作为键。游戏面板是这些唯一键和它们对应的单元格之间的映射。

在创建了游戏面板之后，我们还需要完成另外两项任务：随机放置地雷并计算邻近的地雷数量。我们将在下一节详细讨论这些任务。

## 算法

### 随机放置地雷

```js
// 随机放置地雷的 JavaScript 代码。
var randomlyAssignMines = function( board, mineCount )
{
	var mineCooridinates = [];
	for( var i = 0; i < mineCount; i++ )
	{
		var randomRowCoordinate = getRandomInteger( 0, boardSize );
		var randomColumnCoordinate = getRandomInteger( 0, boardSize );
		var cell = randomRowCoordinate + "" + randomColumnCoordinate;
		while( mineCooridinates.includes( cell ) )
		{
			randomRowCoordinate = getRandomInteger( 0, boardSize );
			randomColumnCoordinate = getRandomInteger( 0, boardSize );
			cell = randomRowCoordinate + "" + randomColumnCoordinate;
		}
		mineCooridinates.push( cell );
		board[cell].mined = true;
	}
	return board;
}
```

在扫雷游戏开始之前，我们要做的第一件事就是将地雷随机放置到单元格。为此，我创建了一个函数，该函数接收游戏面板对象（`board`）和所需的地雷计数（`mineCount`）作为参数。

对于我们要放置的每一个地雷，我们生成随机的行和列。此外，相同的行和列组合不应该重复出现。否则，我们的地雷将少于我们所期望的数目。如果出现重复，则必须重新随机生成。

当生成每个随机单元格坐标时，我们将对应单元格的 `mined` 属性设置为 `true`。

我创建了一个辅助函数，用来生成在我们预期范围内的随机数。如下：

```js
// 用来生成随机数的辅助函数：
var getRandomInteger = function( min, max )
{
	return Math.floor( Math.random() * ( max - min ) ) + min;
}
```

### 计算相邻地雷的数量

```js
// 计算相邻地雷数的 JavaScript 代码：
var calculateNeighborMineCounts = function( board, boardSize )
{
	var cell;
	var neighborMineCount = 0;
	for( var row = 0; row < boardSize; row++ )
	{
		for( var column = 0; column < boardSize; column++ )
		{
			var id = row + "" + column;
			cell = board[id];
			if( !cell.mined )
			{
				var neighbors = getNeighbors( id );
				neighborMineCount = 0;
				for( var i = 0; i < neighbors.length; i++ )
				{
					neighborMineCount += isMined( board, neighbors[i] );
				}
				cell.neighborMineCount = neighborMineCount;
			}
		}
	}
	return board;
}
```

现在让我们看看如何计算相邻单元格的地雷数。

你会注意到，我们循环遍历了游戏面板上的每一行和每一列，这是一种非常常见的方式。这样我们可以每个单元格上执行相同的处理。

我们首先检查每个单元格是否放置了地雷。如果是，则不需要检查相邻的地雷数。毕竟，如果玩家点击了它，他/她将会输掉游戏

如果单元格没有被放置地雷，那么我们需要看看它周围有多少地雷。我们要做的第一件事是调用 `getNeighbors` 辅助函数，它返回相邻单元格的 `id` 列表。然后我们循环遍历这个列表，累计地雷的数量，并更新单元格的 `neighborMineCount` 属性。

##### 获取相邻的单元格

让我们仔细看看 `getNeighbors` 函数，因为在整个代码中它将被多次调用。我之前提到过，我的一些设计方式是因为不用扩展到更大的游戏面板上。这里也是如此：

```js
// 用于获取扫雷车单元格的所有相邻 id 的 JavaScript 代码：
var getNeighbors = function( id )
{
	var row = parseInt(id[0]);
	var column = parseInt(id[1]);
	var neighbors = [];
	neighbors.push( (row - 1) + "" + (column - 1) );
	neighbors.push( (row - 1) + "" + column );
	neighbors.push( (row - 1) + "" + (column + 1) );
	neighbors.push( row + "" + (column - 1) );
	neighbors.push( row + "" + (column + 1) );
	neighbors.push( (row + 1) + "" + (column - 1) );
	neighbors.push( (row + 1) + "" + column );
	neighbors.push( (row + 1) + "" + (column + 1) );

	for( var i = 0; i < neighbors.length; i++)
	{ 
	   if ( neighbors[i].length > 2 ) 
	   {
	      neighbors.splice(i, 1); 
	      i--;
	   }
	}

	return neighbors
}
```

该函数接收单元格 `id` 作为参数。然后我们马上把它分成两部分这样我们就有了行和列的值。我们使用内置函数 `parseInt` 将字符串转换为整数。现在我们可以对它们进行数学运算了。

接下来，我们使用行和列计算每个相邻单元格的 `id`，并将它们加入列表。在处理情况之前，列表中应该包含 8 个 `id`。

![](https://i1.wp.com/mitchum.blog/wp-content/uploads/2019/07/neighborsexample.png?w=740&ssl=1)

一个单元格和它相邻的单元格。

虽然这对于一般情况是没问题的，但是有一些特殊的情况我们需要考虑。也就是游戏面板边界的单元格。这些单元格的相邻单元格数量会少于 8 个。

为了解决这个问题，我们循环遍历相邻单元格的 `id`，并删除长度大于 2 的 `id`。所有无效的相邻单元格行或者列可能是 -1 或 10，所以很巧妙地解决了这个问题。

每当从列表中删除 `id` 时，为了保持它同步，我们还必须减少索引变量。

##### 判断地雷

好的，我们在这一节还有最后一个函数要讨论：`isMined`。

```js
// 检查单元格是否是地雷的 JavaScript 函数：
var isMined = function( board, id )
{	
	var cell = board[id];
	var mined = 0;
	if( typeof cell !== 'undefined' )
	{
		mined = cell.mined ? 1 : 0;
	}
	return mined;
}
```

`isMined` 函数非常简单。它只是检查单元格是否是地雷。如果是，则返回 1；否则，返回 0。这个特性允许我们在循环中反复调用函数时，对函数的返回值进行累加。

这就完成了设置扫雷游戏面板的算法。让我们进入真正的游戏吧！

### 翻开单元格

```js
// 当单元格被翻开时执行的 JavaScript 代码：
var handleClick = function( id )
{
	if( !gameOver )
	{
		if( ctrlIsPressed )
		{
			handleCtrlClick( id );
		}
		else
		{
			var cell = board[id];
			var $cell = $( '#' + id );
			if( !cell.opened )
			{
				if( !cell.flagged )
				{
					if( cell.mined )
					{
						loss();		
						$cell.html( MINE ).css( 'color', 'red');		
					}
					else
					{
						cell.opened = true;
						if( cell.neighborMineCount > 0 )
						{
							var color = getNumberColor( cell.neighborMineCount );
							$cell.html( cell.neighborMineCount ).css( 'color', color );
						}
						else
						{
							$cell.html( "" )
								 .css( 'background-image', 'radial-gradient(#e6e6e6,#c9c7c7)');
							var neighbors = getNeighbors( id );
							for( var i = 0; i < neighbors.length; i++ )
							{
								var neighbor = neighbors[i];
								if(  typeof board[neighbor] !== 'undefined' &&
									 !board[neighbor].flagged && !board[neighbor].opened )
								{
									handleClick( neighbor );
								}
							}
						}
					}
				}
			}
		}
	}
}
```

好吧，让我们直接进入这个刺激的操作。每当玩家点击一个单元格时，我们都会执行这个函数。它做了很多工作，还使用了递归。如果你不熟悉这个概念，请参阅以下定义：

**Recursion**：See **recursion**（不停地看）。

哈哈，真是计算机科学界的笑话。如果是在酒吧或咖啡厅这样做总是有趣的。你真的应该在你暗恋的那个可爱的女孩身上试试。

总之，递归函数就是一个调用自身的函数。听起来可能会发生堆栈溢出的问题，对吗？这就是为什么你需要一个不再进行任何后续递归调用的基本条件。我们的函数最终将停止调用自己，因为不再需要打开任何单元格。

在实际项目中，递归很少是正确的选择，但它却是一个很有用的工具。我们本可以不使用递归来编写这段代码，但我想大家可能都想看看它的实际示例。

##### 单击单元格

`handleClick` 函数接收单元格 `id` 作为参数。我们需要处理玩家在单击单元格时同时按下 ctrl 键的情况，但是我们将在后面的部分讨论这个问题。

假设游戏还没有结束，我们正在处理一个基本的左键单击事件，我们需要做一些检查。如果玩家已经翻开或标记了这个单元格，我们应该忽略这次点击事件。因为如果玩家意外地点击一个已经标记过的单元格而导致游戏结束，这将会让玩家感到沮丧。

不满足这两个条件，那么我们将继续。如果在单元格中存在地雷，我们就需要去处理游戏失败的逻辑，并将爆炸的地雷显示为红色。否则，我们将把单元格设置为打开的状态。

如果打开的单元格周围有地雷，我们将以适当的字体颜色向玩家显示邻近的地雷数量。如果单元格周围没有地雷，那么是时候使用递归了。在将单元格的背景颜色设置为稍微暗一点的灰色之后，我们对每个未打开的并且没有被标记的相邻单元格调用 `handleClick`。

##### 辅助函数

让我们来看看 `handleClick` 函数中使用的辅助函数。我们已经讲过 `getNeighbors` 了，所以我们从 `loss` 失函数开始。

```js
// 当玩家输掉游戏时调用的 JavaScript 代码：
var loss = function()
{
	gameOver = true;
	$('#messageBox').text('Game Over!')
					.css({'color':'white', 
						  'background-color': 'red'});
	var cells = Object.keys(board);
	for( var i = 0; i < cells.length; i++ )
	{
		if( board[cells[i]].mined && !board[cells[i]].flagged )
		{
			$('#' + board[cells[i]].id ).html( MINE )
										.css('color', 'black');
		}
	}
	clearInterval(timeout);
}
```

当游戏失败，我们设置全局变量 `gameOver` 的值，然后显示一条消息，让玩家知道游戏已经结束。我们还循环遍历每个单元格并显示地雷出现的位置。然后我们停止计时。

其次，我们还有 `getNumberColor` 函数。这个函数负责给出相邻单元格的地雷数显示的颜色。

```js
// 传入一个数字并返回颜色的 JavaScript 代码：
var getNumberColor = function( number )
{
	var color = 'black';        
	if( number === 1 )
	{
		color = 'blue';
	}
	else if( number === 2 )
	{
		color = 'green';
	}
	else if( number === 3 )
	{
		color = 'red';
	}
	else if( number === 4 )
	{
		color = 'orange';
	}
	return color;
}
```

我试着把颜色搭配起来，就像经典的 Windows 版扫雷游戏那样。也许我应该用 [switch](https://www.w3schools.com/js/js_switch.asp) 语句，但我已经不考虑游戏被扩展的情况了，这没什么大不了的。让我们继续看看标记单元格的逻辑代码。

### 标记单元格

```js
// 用于在单元格上放置标记的 JavaScript 代码：
var handleRightClick = function( id )
{
	if( !gameOver )
	{
		var cell = board[id];
		var $cell = $( '#' + id );
		if( !cell.opened )
		{
			if( !cell.flagged && minesRemaining > 0 )
			{
				cell.flagged = true;
				$cell.html( FLAG ).css( 'color', 'red');
				minesRemaining--;
			}
			else if( cell.flagged )
			{
				cell.flagged = false;
				$cell.html( "" ).css( 'color', 'black');
				minesRemaining++;
			}

			$( '#mines-remaining').text( minesRemaining );
		}
	}
}
```

右键单击一个单元格将在其上放置一个标记。如果玩家右键点击了一个没有被标记的单元格，并且当前游戏还有剩余的地雷需要被标记，我们将在单元格上插上小红旗作为标记，并将其 `flagged` 属性更新为 `true`，同时减少剩余地雷的数量。如果单元格已经有了一个标志，则执行相反的操作。最后，我们更新显示的剩余地雷数量。

### 翻开所有相邻单元格

```js
// 处理 ctrl + 左键的 JavaScript 代码
var handleCtrlClick = function( id )
{
	var cell = board[id];
	var $cell = $( '#' + id );
	if( cell.opened && cell.neighborMineCount > 0 )
	{
		var neighbors = getNeighbors( id );
		var flagCount = 0;
		var flaggedCells = [];
		var neighbor;
		for( var i = 0; i < neighbors.length; i++ )
		{
			neighbor = board[neighbors[i]];
			if( neighbor.flagged )
			{
				flaggedCells.push( neighbor );
			}
			flagCount += neighbor.flagged;
		}

		var lost = false;
		if( flagCount === cell.neighborMineCount )
		{
			for( i = 0; i < flaggedCells.length; i++ )
			{
				if( flaggedCells[i].flagged && !flaggedCells[i].mined )
				{
					loss();
					lost = true;
					break;
				}
			}

			if( !lost )
			{
				for( var i = 0; i < neighbors.length; i++ )
				{
					neighbor = board[neighbors[i]];
					if( !neighbor.flagged && !neighbor.opened )
					{
						ctrlIsPressed = false;
						handleClick( neighbor.id );
					}
				}
			}
		}
	}
}
```

我们已经介绍了打开单元格和标记单元格的操作，所以让我们来介绍玩家可以进行的最后一项操作：打开处于打开状态单元格的相邻单元格。`handleCtrlClick` 函数就是用来处理这个逻辑的。可以通过按住 ctrl 并左键单击一个处于打开状态的且包含相邻地雷的单元格来执行此操作。

如果这样，我们要做的第一件事是创建一个相邻被标记的单元格列表。如果相邻被标记单元格的数量与周围地雷的实际数量相匹配，那么我们继续。否则，我们什么也不做，直接退出函数。

如果继续，接下来要做的就是检查被标记的单元格中是否包含地雷。如果是，我们便知道玩家错误地预测了地雷的位置，并且将要翻开所有未标记的相邻单元格导致游戏失败。我们需要设置局部变量 `lost` 的值并调用 `loss` 函数。前面已经讨论了 `loss` 函数。

如果游戏仍然没有失败，那么我们将需要打开所有未标记的相邻单元格。我们只需要循环遍历它们，并在每个函数上调用 `handleClick` 函数。但是，我们必须首先将 `ctrlIsPressed` 变量设置为 `false`，以防止错误地执行 `handleCtrlClick` 函数。

## 开始游戏

我们几乎完成了对编写扫雷游戏所需的所有 JavaScript 逻辑的分析！剩下要讨论的就是开始新游戏所需的初始化步骤。

```js
// 用于初始化扫雷游戏的 JavaScript 代码
var FLAG = "&#9873;";
var MINE = "&#9881;";
var boardSize = 10;
var mines = 10;
var timer = 0;
var timeout;
var minesRemaining;

$(document).keydown(function(event){
    if(event.ctrlKey)
        ctrlIsPressed = true;
});

$(document).keyup(function(){
    ctrlIsPressed = false;
});

var ctrlIsPressed = false;
var board = newGame( boardSize, mines );

$('#new-game-button').click( function(){
	board = newGame( boardSize, mines );
})
```

我们要做的第一件事就是初始化一些变量。我们需要定义常量来存储小旗和地雷图标的 [html 代码]()。我们还需要一些常量来存储游戏面板的大小、地雷的总数、计时器和剩余地雷的数量。

此外，如果玩家按下 ctrl 键，我们需要一个变量来存储是否按下了 ctrl 键。我们使用 jQuery 将事件处理程序添加到 `document` 中，用来设置 `ctrlIsPressed` 变量的值。

最后，我们调用 `newGame` 函数并将该函数绑定到 new game 按钮。

### 辅助函数

```js
// 开始新的扫雷游戏的 JavaScript 代码
var newGame = function( boardSize, mines )
{
	$('#time').text("0");
	$('#messageBox').text('Make a Move!')
					.css({'color': 'rgb(255, 255, 153)', 
						  'background-color': 'rgb(102, 178, 255)'});
	minesRemaining = mines;
	$( '#mines-remaining').text( minesRemaining );
	gameOver = false;
	initializeCells( boardSize );
	board = Board( boardSize, mines );
	timer = 0;
	clearInterval(timeout);
	timeout = setInterval(function () {
    // This will be executed after 1,000 milliseconds
    timer++;
    if( timer >= 999 )
    {
    	timer = 999;
    }
    $('#time').text(timer);
	}, 1000);

	return board;
}
```

`newGame` 函数负责重置变量，使我们的游戏处于随时可以玩的状态。这包括重置显示给玩家的消息、调用 `initializeCells`，以及创建一个新的随机游戏面板。它还包括重置时计时器，并且每秒钟更新一次。

让我们通过看 `initializeCells` 来总结一下。

```js
// 用于将单击处理程序附加到单元格并检查胜利条件的 JavaScript 代码
var initializeCells = function( boardSize ) 
{
	var row  = 0;
	var column = 0;
	$( ".cell" ).each( function(){
		$(this).attr( "id", row + "" + column ).css('color', 'black').text("");
		$('#' + row + "" + column ).css('background-image', 
										'radial-gradient(#fff,#e6e6e6)');
		column++;
		if( column >= boardSize )
		{
			column = 0;
			row++;
		}

		$(this).off().click(function(e)
		{
		    handleClick( $(this).attr("id") );
		    var isVictory = true;
			var cells = Object.keys(board);
			for( var i = 0; i < cells.length; i++ )
			{
				if( !board[cells[i]].mined )
				{
					if( !board[cells[i]].opened )
					{
						isVictory = false;
						break;
					}
				}
			}

			if( isVictory )
			{
				gameOver = true;
				$('#messageBox').text('You Win!').css({'color': 'white',
													   'background-color': 'green'});
				clearInterval( timeout );
			}
		});

		$(this).contextmenu(function(e)
		{
		    handleRightClick( $(this).attr("id") );
		    return false;
		});
	})
}
```

这个函数的主要目的是向单元格 DOM 对象添加额外的属性。每个单元格 DOM 都需要添加对应的 id，以便我们能够从游戏逻辑中轻松地访问它。每个单元格还需要一个合适的背景图像。

我们还需要为每个单元格 DOM 添加一个单击处理程序，以便能够监听左击和右击事件。

处理左击事件调用 `handleClick` 函数，传入对应的 `id`。然后检查是否每个没有地雷的单元格都被打开了。如果这是真的，那么游戏胜利，我们可以适当地祝贺一下他/她。

处理右击事件调用 `handleRightClick`，同样传入对应的 `id`，然后返回 `false`。这样会阻止 Web 页面右键单击显示上下文菜单的默认行为。对于一般的 [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete) 应用程序，你可能不希望这样处理，但是对于扫雷游戏，这是合适的。

## 总结

祝贺你，已经学习了如何使用 JavaScript 编写扫雷游戏！看起来有很多的代码，但希望我们把它分解成这样不同的模块，是有意义的。我们肯定可以对这个程序的可重用性、可扩展性和可读性做更多的改进。我们也没有详细介绍 HTML 或 CSS 代码。如果你有任何问题或有改进代码的方法，我很乐意在评论中听到你的意见！

如果这篇文章让你想要更多地了解如何用 JavaScript 编写更好的程序，我推荐一本 JavaScript 书：《JavaScript 语言精粹》，作者是 Douglas Crockford。他将 JSON 推广为一种数据交换的格式，并为 Web 的发展做出了巨大贡献。

多年来，该 JavaScript 语言得到了极大的改进，但由于其发展的历史，它仍然具有一些奇怪的特性。这本书会帮助你更好的理解这本语言在设计上存在的问题（如全局命名空间）。当我第一次学习这门语言时，我发现它很有帮助。

[![JavaScript: The Good Parts book](//ws-na.amazon-adsystem.com/widgets/q?_encoding=UTF8&MarketPlace=US&ASIN=0596517742&ServiceVersion=20070822&ID=AsinImage&WS=1&Format=_SL250_&tag=mitchumblog-20)](https://www.amazon.com/gp/product/0596517742/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=0596517742&linkCode=as2&tag=mitchumblog-20&linkId=fa7b0d5ed5bb3d96797d9b9f54a40e32)

如果你决定拥有它，并且通过上面的链接购买我会非常地感谢你。我将通过亚马逊的会员计划获得一些佣金，不需要你付额外的费用。它将帮助我维护这个网站的正常运行，而不用求助于烦人的广告。我宁愿推荐我认为对你们有帮助的产品。

好了，广告到此为止。我希望你们有一个愉快的阅读体验。让我知道你还想看什么其他类似的简单游戏，不要忘记留下你的电子邮件，这样你就不会错过写一篇文章。你还会收到我的免费推送内容，如何更好地编写函数。

祝好！

**更新(2019/7/13日)**：这篇文章比我想象的更受欢迎，太棒了！我从读者那里收到了很多关于可以改进的方面的反馈。我每天都在做维护一个代码库的工作，直到现在这个代码库还停留在 Internet Explorer [怪异模式](https://en.wikipedia.org/wiki/Quirks_mode)。我在工作中的许多编码习惯都转移到了我在扫雷游戏上，导致一些代码没有利用 JavaScript 技术的前沿。之后，我想在另一篇文章中重构代码。我计划完全删除 jQuery，并在适当的地方使用 ES6 语法而不是 ES5。但你不用等我！看看你自己能否完成这些工作！请在评论中告诉我进展如何。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
