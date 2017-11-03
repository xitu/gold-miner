> * 原文地址：[How to draw in JavaScript](https://aleen42.gitbooks.io/personalwiki/content/post/how_to_draw/how_to_draw.html)
* 原文作者：[aleen42](https://github.com/aleen42)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Jiang Haichao](http://github.com/AceLeeWinnie)
* 校对者：[L9m](https://github.com/L9m) [Mark](https://github.com/marcmoore)

# 如何用 JavaScript 作画

<p align="center"><img width="70%" src="https://github.com/aleen42/PersonalWiki/blob/master/post/how_to_draw/preview.png" alt="用 javascript 作画" /></p>
<p align="center"><strong>图 1.1</strong>简单预览</p>

因为我司给我一个在浏览器中以编程方式来实现绘图的需求，如下图 1.1 所示，我想分享一些用 JavaScript 绘画的要点。实际上，我们画啥呢？**答案是任一种图像和图形**。

这里有个样例，你可以直接点击 http://draw.soundtooth.cn/ 查看。并拖拽任意图片，放置到红色方框内，点击 "Process" 按钮，启动绘图方法：

<p align="center">
<iframe width="100%" height="600px" src="https://aleen42.github.io/example/draw/"></iframe>
</p>

注意：这个项目的版权是我司的，所以并不会向社区 **开源** 代码。

项目开始时，我深受 [这篇文章](https://aleen42.gitbooks.io/personalwiki/content/Programming/JavaScript/webgl/canvas/line_drawing/line_drawing.html) 中光线动画绘制的启发。如果仔细阅读，你会发现，在绘制任何图形之前都需要路径数据，有了这些数据，我们才能够模拟绘画。这些数据的形式应该像下面这样：

```nginx
M 161.70443,272.07413
C 148.01517,240.84549 134.3259,209.61686 120.63664,178.38822
C 132.07442,172.84968 139.59482,171.3636 151.84309,171.76866
```

你可能会问，这样的 `path` 数据只在 SVG 元素中有效，怎么能绘制其他像 JPG、PNG、或者 GIF 这样的图片呢。这是我们在本文后面将探讨的问题。在那之前，我们先简单绘制一幅 SVG 图像。

### 绘制 SVG 文件

什么是 SVG？可伸缩矢量图形，又称为 SVG，是针对二维图形基于 XML 的矢量图片格式，支持动画交互。不支持老旧的 IE 浏览器。如果你是设计师，或者是经常使用 Adobe Illustration 做绘图工具的插画家，也许已经对图形已经有了一定的认知。但与一般图形主要的不同在于，SVG 是可伸缩的无损的，而其他格式的图片不是。

注意：一般来说，SVG 格式的图片被称作 **图形**，而其他格式的被称为 **图像**。

#### 从 SVG 文件中提取数据

正如上文所说，在绘制 SVG 之前，你需要从 SVG 文件中读取数据。这通常是 JavaScript 中 `FileReader` 这个对象的工作，它的初始化代码片段像下面这样：

```js
if (FileReader) {
    /** 如果浏览器支持 FileReader 对象 */
    var fileReader = new FileReader();
}
```

作为一个 Web API，`FileReader` 能够读取本地文件，`readAsText` 是其中支持读取文本格式内容的方法之一。它可以触发事先定义的 `onload` 方法，我们能够在事件处理方法内部读取内容。读取内容的代码应该如下所示：

```js
fileReader.onload = function (e) {
    /** SVG 文件内容 */
    var contents = e.target.result;
};

fileReader.readAsText(file);
```

有了阅读监听器，你也许会考虑是否还要用一个按钮来上传文件。现在看来，那是普通没有任何吸引力的交互方式。于此，我们可以通过拖放来优化这类交互。这意味着你能够拖拽任何图形并且放置到读取内容的方框里。因为我的项目的优先技术选型是 Canvas，我将通过设置事件监听器和注册一个 canvas 的 `drop` 事件来实现这种交互。 

```js
/** Drop 事件处理 */
canvas.addEventListener('drop', function (e) {
    /** 从 e 中提取 `file` 对象 */
    var file = e.dataTransfer.files[0];

    /** 开始读取文件内容 */
    fileReader.readAsText(file);
});
```

#### 数据加工

现在数据已经存储在 `contents` 变量里，并且已经能够处理它，数据对我们来说只是文本而已。开始时，我尝试使用常规方法提取路径节点。

```js
var paths = contents.match(/<path([\s\S]+?)\/>/g);
```

但是这个方法有两个缺点：

- 会丢失整个 SVG 文件结构。
- 不能创建一个合法的 `SVGPathElement` DOM 元素。

为了更直白地说明，请看如下代码：

```js
if (paths) {
    var pathNodes = [];
    var pathLen = paths.length;

    for (var i = 0; i < pathLen; i++) {
        /** 创建一个合法的 SVGPathElement DOM 节点 */
        var pathNode = document.createElementNS('http://www.w3.org/2000/svg', 'path');

        /** 使用临时 div 元素，方便读取属性 `d` */
        var tmpDiv = document.createElement('div');
        tmpDiv.innerHTML = paths[i];

        /** 设置合法的 `d` 属性 */
        pathNode.setAttribute('d', tmpDiv.childNodes[0]
            .getAttribute('d')
            .trim()
            .split('\n').join('')
            .split('    ').join('')
        );

        /** 存储在一个数组里 */
        pathNodes.push(pathNode);
    }
}
```

正如你看到的， `tmpDiv.childNodes[0]` 不是一个 `SVGPathElement`，所以我们需要创建另一个节点。如果我用另一个方法读取整个 SVG 文件，`SVGPath` 变量能够以清晰的结构存储整个 SVG 对象，并且可以随意访问：

```js
var tempDiv = document.createElement('div');
tempDiv.innerHTML = contents.trim()
    .split('\n').join('')
    .split('	').join('');

var SVGNode = tempDiv.childNodes[0];
```

用递归的方式可以很容易地提取所有 `SVGPathElement` 并且直接送入 `pathNodes` 栈。

```js
var pathNodes = [];

function recursivelyExtract(parentNode) {
    var children = parentNode.childNodes;
    var childLen = children.length;

    /** 如果节点没有孩子节点，则直接返回 */
    if (childLen === 0) {
        return;
    }

    /** 循环子节点，如果子节点是 SVGPathElement，则提取出来 */
    for (var i = 0; i < childLen; i++) {
        if (children[i].nodeName === 'path') {
            pathNodes.push(children[i]);
        }
    }
};

recursivelyExtract(SVGNode);
```

使用那种方法看起来优雅多了，至少我是这么认为的，尤其是和其他元素一起绘制的时候，我只用 `switch` 结构就能提取不同元素，而不是使用一些常规表达。一般来说，在一个 SVG 文件里，图形元素除了可以被定义成 `path`，还可被定义成 `circle`，`rect`，`polyline`。所以，我们应该怎么处理他们？答案是用 JavaScript 就能全部转换成 `path` 元素，这个稍后再说。

我在开发项目的时候有一个问题是到底需要重点关注什么。在一个复合路径中，`m` 和 `M` 完全不一样，必须要有至少一个 `m` 或者一个 `M`，所以你必须把他们分离出来，避免两条路径相互影响。也就是说，如果一条路径属于复合路径，则区分这两个符号：

```js
function generatePathNode(d) {
	var path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
	path.setAttribute('d', d);
	return path;
};

var d = children[i].getAttribute('d');

/** 分离复合路径 */
var ds = d.match(/m[\s\S]+?(?=(?:m|$)+)/ig);
var dsLen = ds.length;

/** 复合路径 */
if (dsLen > 1) {
    /**
     * 区分 `m` 和 `M`
     * ...
     */
} else {
    pathNodes.push(children[i]);
}
```

#### 用 Canvas 作图

注意：路径已经在提取出来并存储在本地变量中，下一步要做的是用点绘制出来：

```js
var pointsArr = [];
var pathLen = pathNodes.length;

for (var j = 0; j < pathLen; j++) {
    var index = pointsArr[].push([]);
    var pointsLen = pathNodes[j].getTotalLength();

    for (var k = 0; k < pointsLen; k++) {
        /** 从路径中提取点 */
        pointsArr[index].push(pathNodes[j].getPointAtLength(k));
    }
}
```

如你所见，`pointsArr` 是一个二维数组，第一维是路径，第二维是每个路径下的点。当然，这些点是能用 Canvas 画出来的，如下：

```js
/** 根据所给 index 绘制路径 */
function drawPath(index) {
    var ctx = canvas.getContext('2d');
    ctx.beginPath();

    /** 设置路径 */
    ctx.moveTo(pointsArr[index][0].x, pointsArr[index][0].y);

    for (var i = 1; i < pointsArr[index].length; i++) {
        ctx.lineTo(pointsArr[index][i].x, pointsArr[index][i].y);
    }

    /** 渲染 */
    ctx.stroke();
}
```

试着考虑这样一个问题：如果一条路径包括尽可能多的可绘制点，如何优化绘制方案更快速地绘制？也许，跳着画是解决的简单之法，但是怎么跳着画是另一个关键问题。我还没有发现完美解法，如果你有想法，欢迎交流。

```js
function optimizeJump() {
    var perfectJump = 1;

    /**
     * 计算最优跨度值的算法
     * ...
     */
    return perfectJump;
}

function drawPath(index) {
    var ctx = canvas.getContext('2d');
    ctx.beginPath();

    ctx.moveTo(pointsArr[index][0].x, pointsArr[index][0].y);

    /** 跳着画的优化方案 */
    var perfectJump = optimizeJump();
    for (var i = 1; i < pointsArr[index].length; i+= perfectJump) {
        ctx.lineTo(pointsArr[index][i].x, pointsArr[index][i].y);
    }

    ctx.stroke();
}
```

算法是我们需要重点思考的。

#### 校准参数

随着需求越来越复杂，路径数据无法适应比例缩放，改变大小或者移动图形的场景。

##### **为何要校准参数？**

因为你可能要在Canvas当中对图形进行比例缩放、调整尺寸、移动，这就意味着路径数据也应该随着你的改动来变化。但实际上它不能，所以我们才需要校准参数。

<p align="center"><img width="70%" src="https://github.com/aleen42/PersonalWiki/raw/master/post/how_to_draw/panel.png" alt="draw in javascript" /></p>
<p align="center"><strong>图 2.1</strong>所谓面板</p>

图 2.1 展示了一个高亮工作区域，我叫它 **面板**。在这个面板上，你可以进行拖放，拖拽，调整尺寸或者移动操作。实际上，面板里包含了一个能满足你需求的 Canvas 对象。只需要把 SVG 文件（图 2.2）拖放到面板里，就可以在屏幕上重绘，结果如图 2.3：

<p align="center"><img width="50%" src="http://ww1.sinaimg.cn/large/006y8lVagw1faie2abj2nj30e80e8dgn.jpg" /></p>
<p align="center"><strong>图 2.2</strong>绘制的 SVG 文件</p>

富含中国元素的美丽 logo 就生成啦

<p align="center"><img width="70%" src="https://github.com/aleen42/PersonalWiki/raw/master/post/how_to_draw/1.png" alt="draw in javascript" /></p>
<p align="center"><strong>图 2.3</strong> 渲染图形 </p>

除了图形操作，其他 SVG 属性也会影响路径数据，比如 `width`，`height` 和 `viewBox`。

```html
<svg xmlns="http://www.w3.org/2000/svg" width="400" height="200" viewBox="0 0 200 200">
    <!-- paths -->
</svg>
```

所以，校准参数的计算受两个因素影响，**属性** 和 **操作**。

##### **计算**

计算之前，要了解定义的变量和代表的含义。

首先是图形位置变量：

- **oriX**: 图形初始 `x` 值
- **oriY**: 图形初始 `y` 值
- **moveX**: 移动前后 `x` 的差值.
- **moveY**: 移动前后 `y` 的差值.
- **viewBoxX**: 图形的 `viewBox` 属性的 `x` 值
- **viewBoxY**: 图形的 `viewBox` 属性的 `y` 值

然后是图形尺寸变量：

- **oriW**: 图形初始宽度
- **oriH**: 图形初始高度
- **svgW**: SVG 元素的宽度
- **svgH**: SVG 元素的高度
- **viewBoxW**: SVG 元素的 `viewBox` 属性的宽度
- **viewBoxH**: SVG 元素的 `viewBox` 属性的高度
- **curW**: 图形的当前宽度
- **curH**: 图形的当前高度

了解变量含义之后，我们可以开始计算校准参数了。

用以下公式计算图形的当前位置：

```js
var x = oriX + moveX;   /** 图形的当前 x 值 */
var y = oriY + moveY;   /** 图形的当前 y 值 */
```

下面这个公式是用于计算比例：

```js
var ratioParam = Math.max(oriW / svgW, oriH / svgH) * Math.min(svgW / viewBoxW, svgH / viewBoxH);

var ratioX = (curW / oriW) * ratioParam;
var ratioY = (curH / oriH) * ratioParam;
```

要记住 `viewBox` 属性的 `x` 和 `y` 值会裁切图形（如图 2.4）。所以，我们需要从初始点值中去掉这部分值。

<p align="center"><img width="70%" src="https://github.com/aleen42/PersonalWiki/raw/master/post/how_to_draw/2.png" alt="draw in javascript" /></p>
<p align="center"><strong>图 2.4</strong> 裁切图形 </p>

我只需要边缘点的最大值和最小值。举个栗子，如果点集的位置在图形之外，我就改变 `x` 或 `y`，甚至全部改变，重写到图形的边上。

```js
point.x = point.x >= x && point.x <= x + curW ? point.x : ((point.x < x) ? x : x + curW);
point.y = point.y >= y && point.y <= x + curH ? point.y : ((point.y < y) ? y : y + curH);
```

据我所知，当点的数量很大的时候，删除范围外的点要比重写更好。

#### 把所有形状变成路径元素

现在，我们已经知道怎么用 JavaScript 绘制 `path` 元素。上文说道，在绘制 `rect`、`polyline`、`circle` 等其他元素定义的形状之前，应该先转换成路径。本节，就来介绍一下做法。

##### **圆与椭圆**

圆和椭圆元素是近亲，相同属性如表 2.1 所示：

**圆**|**椭圆**
:-----:|:------:
CX|CX
CY|CY

<p align="center"><strong>表 2.1</strong>相同属性</p>

不同属性如表 2.2 所示：

**圆**|**椭圆**
:-----:|:------:
R|RX
|RY

<p align="center"><strong>表 2.2</strong>不同属性</p>

路径转换方法如下：

```js
function convertCE(cx, cy) {
    function calcOuput(cx, cy, rx, ry) {
        if (cx < 0 || cy < 0 || rx <= 0 || ry <= 0) {
            return '';
        }

        var output = 'M' + (cx - rx).toString() + ',' + cy.toString();
        output += 'a' + rx.toString() + ',' + ry.toString() + ' 0 1,0 ' + (2 * rx).toString() + ',0';
		output += 'a' + rx.toString() + ',' + ry.toString() + ' 0 1,0'  + (-2 * rx).toString() + ',0';

		return output;
    }

    switch (arguments.length) {
    case 3:
        return calcOuput(parseFloat(cx, 10), parseFloat(cy, 10), parseFloat(arguments[2], 10), parseFloat(arguments[2], 10));
    case 4:
        return calcOuput(parseFloat(cx, 10), parseFloat(cy, 10), parseFloat(arguments[2], 10), parseFloat(arguments[3], 10));
        break;
    default:
        return '';
    }
}
```

##### **多边形和随意画的圆**

对于这些元素，要提取 `points` 属性。按路径元素的 `d` 值的特定格式重新组装。

```js
/** 传入 `points` 属性的值*/
function convertPoly(points, types) {
    types = types || 'polyline';

    var pointsArr = points
        /** 清除多余元素 */
        .split(' 	').join('')
        .trim()
        .split(/\s+|,/);
    var x0 = pointsArr.shift();
    var y0 = pointsArr.shift();

    var output = 'M' + x0 + ',' + y0 + 'L' + pointsArr.join(' ');

    return types === 'polygon' ? output + 'z' : output;
}
```

##### **线段**

一般来说，`line` 元素有多个属性用于线的定位：`x1`，`y1`，`x2` 和 `y2`。

很简单，我们可以这么计算：

```js
function convertLine(x1, y1, x2, y2) {
    if (parseFloat(x1, 10) < 0 || parseFloat(y1, 10) < 0 || parseFloat(x2, 10) < 0 || parseFloat(y2, 10) < 0) {
        return '';
    }

    return 'M' + x1 + ',' + y1 + 'L' + x2 + ',' + y2;
}
```

##### **矩形**

矩形也有一些用于定位和决定大小的属性：`x`，`y`，`width` 和 `height`。

```js
function convertRectangles(x, y, width, height) {
    var x = parseFloat(x, 10);
    var y = parseFloat(y, 10);
    var width = parseFloat(width, 10);
    var height = parseFloat(height, 10);

    if (x < 0 || y < 0 || width < 0 || height < 0) {
        return '';
    }

    return 'M' + x + ',' + y + 'L' + (x + width) + ',' + y + ' ' + (x + width) + ',' + (y + height) + ' ' + x + ',' + (y + height) + 'z';
}
```

形状转换成 `path` 的方法已经全部讲解完毕。你可以用这些方法绘制上述图形。

### 绘制非 SVG 图像，也就是图片

除了 SVG 文件，我们还想绘制像 PNG，JPG，或者 GIF 格式的图像。仅仅由像素数据组成，我们是无法直接使用的。因此，我尝试用计算机视觉领域的一个常见技术，Canny 边缘检测算法。用这种算法，可以简单地找到位图的轮廓。

寻找轮廓的整个步骤简单概括为：**灰度** -> **高斯模糊** -> **Canny 梯度** -> **Canny 非极大值抑制** -> **Canny 磁滞** -> **扫描**。这也是 [Canny 边缘检测算法](https://en.wikipedia.org/wiki/Canny_edge_detector) 的步骤。

在处理之前，我们要定义一些通用函数。第一个是 `runImg` 函数，通常用在从 Canvas 中加载图片时，将其转换成由数组组成的矩阵。

```js
/**
 * [runImg: 从 Canvas 对象中加载图片]
 * @param  {[type]}   canvas [the canvas object]
 * @param  {[type]}   size   [the size of the matrix, like 3 for 3x3 matrixs]
 * @param  {Function} fn     [callback function]
 */
function runImg(canvas, size, fn) {
    for (var y = 0; y < canvas.height; y++) {
        for (var x = 0; x < canvas.width; x++) {
            var i = x * 4 + y * canvas.width * 4;
            var matrix = getMatrix(x, y, size);
            fn(i, matrix);
        }
    }

    /**
     * [getMatrix: 给定规模生成矩阵]
     * @param  {[type]} cx   [the x value of the central point]
     * @param  {[type]} cy   [the y value of the central point]
     * @param  {[type]} size [the size of the matrix you want to generate]
     * @return {[type]}      [return null if size is null, or return a matrix with a legal given size]
     */
    function getMatrix(cx, cy, size) {
        /**
         * 给定 cx，cy，size，图片宽高，生成 size x size 的二维数组
         */
        if (!size) {
            return;
        }

        var matrix = [];

        for (var i = 0, y = -(size - 1) / 2; i < size; i++, y++) {
            matrix[i] = [];

            for (var j = 0, x = -(size - 1) / 2; j < size; j++, x++) {
                matrix[i][j] = (cx + x) * 4 + (cy + y) * canvas.width * 4;
            }
        }

        return matrix;
    }
}
```

然而，针对 `imgData` 还有一些操作，`imgData` 是 Canvas 中 Context 对象的 `Context.prototype.getImageData(x, y, width, height)` 这 个 prototype 方法的返回值变量。

```js
/**
 * [getRGBA: 给定初始节点获取 RGBA 值]
 * @param  {[type]} start   [the point you want to know]
 * @param  {[type]} imgData [image data of the canvas]
 * @return {[Object]}       [return an object composed with r, g, b, and a attributes respectively]
 */
function getRGBA(start, imgData) {
    return {
        r: imgData.data[start],
        g: imgData.data[start + 1],
        b: imgData.data[start + 2],
        a: imgData.data[start + 3]
    };
}

/**
 * [getPixel: 类似 getRGBA, 但包含合法性检测]
 * @param  {[type]} i       [the point you want to know]
 * @param  {[type]} imgData [image data of the canvas]
 * @return {[Object]}       [return an object composed with r, g, b, and a attributes respectively]
 */
function getPixel(i, imgData) {
    if (i < 0 || i > imgData.data.length - 4) {
        return {
            r: 255,
            g: 255,
            b: 255,
            a: 255
        };
    } else {
        return getRGBA(i, imgData);
    }
}

/**
 * [setPixel: 与 getPixel 相反, 这个函数用于为特定点设值]
 * @param {[type]} i       [the point you want to set]
 * @param {[type]} val     [an object composed with r, g, b, and a attributes respectively]
 * @param {[type]} imgData [image data of the canvas]
 */
function setPixel(i, val, imgData) {
    imgData.data[i] = typeof val === 'number' ? val : val.r;
    imgData.data[i + 1] = typeof val === 'number' ? val : val.g;
    imgData.data[i + 2] = typeof val === 'number' ? val : val.b;
}
```

#### 灰度

现在，可以开始找轮廓了，点击 *Run* 运行 Codepen 上给出的例子。由于有一定的复杂性，要等一会儿才能在屏幕上看到结果。

灰度在维基百科上的定义如下：

> 在摄影和计算领域，**灰度** 或者说 **灰度** 数字图像是每个像素值都是单个采样的图片，即，这样的图片只携带亮度信息。

本节，我们将用两个方法实现灰度处理：

```js
/**
 * [calculateGray: 计算灰度值]
 * @param  {[type]} pixel [an object composed with r, g, b, and a attributes respectively]
 * @return {[Number]}     [return a grayscale value]
 */
function calculateGray(pixel) {
    return ((0.3 * pixel.r) + (0.59 * pixel.g) + (0.11 * pixel.b));
}

/**
 * [grayscale: 为 canvas 处理灰度]
 * @param  {[type]} canvas [the canvas object]
 */
function grayscale(canvas) {
    var ctx = canvas.getContext('2d');

    var imgDataCopy = ctx.getImageData(0, 0, canvas.width, canvas.height);
    var grayLevel;

    runImg(canvas, null, function (current) {
        grayLevel = calculateGray(getPixel(current, imgDataCopy));
        setPixel(current, grayLevel, imgDataCopy);
    });

    ctx.putImageData(imgDataCopy, 0, 0);
}
```

栗子如下：

<p>
<p data-height="383" data-theme-id="21735" data-slug-hash="gLOgLM" data-default-tab="result" data-user="aleen42" data-embed-version="2" data-pen-title="gLOgLM" class="codepen">See the Pen <a href="http://codepen.io/aleen42/pen/gLOgLM/">gLOgLM</a> by aleen42 (<a href="http://codepen.io/aleen42">@aleen42</a>) on <a href="http://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>
</p>

#### 高斯模糊

高斯模糊是增加边缘检测精度的一个方法，也是 Canny 边缘检测的第一步。

```js
/**
 * [sumArr: 给定数组取和]
 * @param  {[type]} arr [the array]
 * @return {[type]}     [return the sum value]
 */
function sumArr(arr) {
    var result = 0;

    arr.map(function(element, index) {
        result += (/^\s*function Array/.test(String(element.constructor))) ? sumArr(element) : element;
    });

    return result;
}

/**
 * [generateKernel: 生成高斯模糊算法的核心参数]
 * @param  {[type]} sigma [the sigma value]
 * @param  {[type]} size  [the size of the matrix]
 * @return {[type]}       [description]
 */
function generateKernel(sigma, size) {
    var kernel = [];

    /** Euler's number rounded of to 3 places */
    var E = 2.718;

    for (var y = -(size - 1) / 2, i = 0; i < size; y++, i++) {
        kernel[i] = [];

        for (var x = -(size - 1) / 2, j = 0; j < size; x++, j++) {
            /** create kernel round to 3 decimal places */
            kernel[i][j] = 1 / (2 * Math.PI * Math.pow(sigma, 2)) * Math.pow(E, -(Math.pow(Math.abs(x), 2) + Math.pow(Math.abs(y), 2)) / (2 * Math.pow(sigma, 2)));
        }
    }

    /** normalize the kernel to make its sum 1 */
    var normalize = 1 / sumArr(kernel);

    for (var k = 0; k < kernel.length; k++) {
        for (var l = 0; l < kernel[k].length; l++) {
            kernel[k][l] = Math.round(normalize * kernel[k][l] * 1000) / 1000;
        }
    }

    return kernel;
}

/**
 * [gaussianBlur: 对 canvas 对象进行高斯模糊处理]
 * @param  {[type]} canvas [the canvas object]
 * @param  {[type]} sigma  [the sigma value]
 * @param  {[type]} size   [the size of the matrix]
 * @return {[type]}        [description]
 */
function gaussianBlur(canvas, sigma, size) {
    var ctx = canvas.getContext('2d');

    var imgDataCopy = ctx.getImageData(0, 0, canvas.width, canvas.height);
    var kernel = generateKernel(sigma, size);

    runImg(canvas, size, function (current, neighbors) {
        var resultR = 0;
        var resultG = 0;
        var resultB = 0;
        var pixel;

        for (var i = 0; i < size; i++) {
            for (var j = 0; j < size; j++) {
                pixel = getPixel(neighbors[i][j], imgDataCopy);

                /** 返回像素值乘以核心值 */
                resultR += pixel.r * kernel[i][j];
                resultG += pixel.g * kernel[i][j];
                resultB += pixel.b * kernel[i][j];
            }
        }

        setPixel(current, {
            r: resultR,
            g: resultG,
            b: resultB
        }, imgDataCopy);
    });

    ctx.putImageData(imgDataCopy, 0, 0);
}
```

如果你想检查效果，改变 sigma 和 size 参数返回演示如下，

<p>
<p data-height="383" data-theme-id="21735" data-slug-hash="LbYWYN" data-default-tab="result" data-user="aleen42" data-embed-version="2" data-pen-title="LbYWYN" class="codepen">See the Pen <a href="http://codepen.io/aleen42/pen/LbYWYN/">LbYWYN</a> by aleen42 (<a href="http://codepen.io/aleen42">@aleen42</a>) on <a href="http://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>
</p>

#### Canny 梯度

在这步，我们将找到图片的亮度梯度（G）。在之前，我们要得到边缘检测器（Roberts，Prewitt，Sobel等）第一步在水平方向（Gx）和垂直方向（Gy）的衍生值。我们用的是 **Sobel 探测器**。

在处理灰度之前，我们应该导出一个模块，用于操作像素，我们命名为 Pixel。

```js
(function(exports) {
    /** 实际上，每个像素有 8 个方向 */
    var DIRECTIONS = ['n', 'e', 's', 'w', 'ne', 'nw', 'se', 'sw'];

    function Pixel(i, w, h, canvas) {
        this.index = i;
        this.width = w;
        this.height = h;
        this.neighbors = [];
        this.canvas = canvas;

        DIRECTIONS.map(function(d, idx) {
            this.neighbors.push(this[d]());
        }.bind(this));
    }

    /**
     * 这个对象方便获取 8 个临近方向的像素值
     * _______________
     * | NW | N | NE |
     * |____|___|____|
     * | W  | C | E  |
     * |____|___|____|
     * | SW | S | SE |
     * |____|___|____|
     * 给定矩阵模型的 index, width and height
    **/

    Pixel.prototype.n = function() {
        /**
         * 像素在 canvas 图片数据中是个简单数组
         * 1 个像素占用 4 个连续数组元素
         * 等于 r-g-b-a
         */
        return (this.index - this.width * 4);
    };

    Pixel.prototype.e = function() {
        return (this.index + 4);
    };

    Pixel.prototype.s = function() {
        return (this.index + this.width * 4);
    };

    Pixel.prototype.w = function() {
        return (this.index - 4);
    };

    Pixel.prototype.ne = function() {
        return (this.index - this.width * 4 + 4);
    };

    Pixel.prototype.nw = function() {
        return (this.index - this.width * 4 - 4);
    };

    Pixel.prototype.se = function() {
        return (this.index + this.width * 4 + 4);
    };

    Pixel.prototype.sw = function() {
        return (this.index + this.width * 4 - 4);
    };

    Pixel.prototype.r = function() {
        return this.canvas[this.index];
    };

    Pixel.prototype.g = function() {
        return this.canvas[this.index + 1];
    };;

    Pixel.prototype.b = function() {
        return this.canvas[this.index + 2];
    };

    Pixel.prototype.a = function() {
        return this.canvas[this.index + 3];
    };

    Pixel.prototype.isBorder = function() {
        return (this.index - (this.width * 4)) < 0 ||
            (this.index % (this.width * 4)) === 0 ||
            (this.index % (this.width * 4)) === ((this.width * 4) - 4) ||
            (this.index + (this.width * 4)) > (this.width * this.height * 4);
    };

    exports.Pixel = Pixel;
}(this));
```

用 Pixel 开始实现梯度处理：

```js
function roundDir(deg) {
    /** rounds degrees to 4 possible orientations: horizontal, vertical, and 2 diagonals */
    var deg = deg < 0 ? deg + 180 : deg;

    if ((deg >= 0 && deg <= 22.5) || (deg > 157.5 && deg <= 180)) {
        return 0;
    } else if (deg > 22.5 && deg <= 67.5) {
        return 45;
    } else if (deg > 67.5 && deg <= 112.5) {
        return 90;
    } else if (deg > 112.5 && deg <= 157.5) {
        return 135;
    }
};

function gradient(canvas, op) {
    var ctx = canvas.getContext('2d');

    var imgData = ctx.getImageData(0, 0, canvas.width, canvas.height);
    var imgDataCopy = ctx.getImageData(0, 0, canvas.width, canvas.height);

    var dirMap = [];
    var gradMap = [];

    var SOBEL_X_FILTER = [
        [-1, 0, 1],
        [-2, 0, 2],
        [-1, 0, 1]
    ];

    var SOBEL_Y_FILTER = [
        [1, 2, 1],
        [0, 0, 0],
        [-1, -2, -1]
    ];

    var ROBERTS_X_FILTER = [
        [1, 0],
        [0, -1]
    ];

    var ROBERTS_Y_FILTER = [
        [0, 1],
        [-1, 0]
    ];

    var PREWITT_X_FILTER = [
        [-1, 0, 1],
        [-1, 0, 1],
        [-1, 0, 1]
    ];

    var PREWITT_Y_FILTER = [
        [-1, -1, -1],
        [0, 0, 0],
        [1, 1, 1]
    ];

    var OPERATORS = {
        'sobel': {
            x: SOBEL_X_FILTER,
            y: SOBEL_Y_FILTER,
            len: SOBEL_X_FILTER.length
        },
        'roberts': {
            x: ROBERTS_X_FILTER,
            y: ROBERTS_Y_FILTER,
            len: ROBERTS_Y_FILTER.length
        },
        'prewitt': {
            x: PREWITT_X_FILTER,
            y: PREWITT_Y_FILTER,
            len: PREWITT_Y_FILTER.length
        }
    };

    runImg(canvas, 3, function (current, neighbors) {
        var edgeX = 0;
        var edgeY = 0;
        var pixel = new Pixel(current, imgDataCopy.width, imgDataCopy.height);

        if (!pixel.isBorder()) {
            for (var i = 0; i < OPERATORS[op].len; i++) {
                for (var j = 0; j < OPERATORS[op].len; j++) {
                    edgeX += imgData.data[neighbors[i][j]] * OPERATORS[op]["x"][i][j];
                    edgeY += imgData.data[neighbors[i][j]] * OPERATORS[op]["y"][i][j];
                }
            }
        }

        dirMap[current] = roundDir(Math.atan2(edgeY, edgeX) * (180 / Math.PI));
        gradMap[current] = Math.round(Math.sqrt(edgeX * edgeX + edgeY * edgeY));

        setPixel(current, gradMap[current], imgDataCopy);
    });

    ctx.putImageData(imgDataCopy, 0, 0);
}
```

样例如下：

<p>
<p data-height="383" data-theme-id="21735" data-slug-hash="aBbpWM" data-default-tab="result" data-user="aleen42" data-embed-version="2" data-pen-title="aBbpWM" class="codepen">See the Pen <a href="http://codepen.io/aleen42/pen/aBbpWM/">aBbpWM</a> by aleen42 (<a href="http://codepen.io/aleen42">@aleen42</a>) on <a href="http://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>
</p>

#### Canny 非极大值抑制

非极大值抑制应用到 “薄” 边。梯度计算后，从梯度值中提取的边缘仍然很模糊。根据范式 3，边缘只能有一个精确值。所以非极大值抑制能够帮助抑制除了本地极大值之外的其他值，指出亮度值改变最大的位置。

最后一步是计算 `dirMap` 和 `graphMap`：

```js
function getPixelNeighbors(dir) {
    var degrees = {
        0: [{ x: 1, y: 2 }, { x: 1, y: 0 }],
        45: [{ x: 0, y: 2 }, { x: 2, y: 0 }],
        90: [{ x: 0, y: 1 }, { x: 2, y: 1 }],
        135: [{ x: 0, y: 0 }, { x: 2, y: 2 }]
    };

    return degrees[dir];
}

function nonMaximumSuppress(canvas, dirMap, gradMap) {
    var ctx = canvas.getContext('2d');

    var imgDataCopy = ctx.getImageData(0, 0, canvas.width, canvas.height);

    runImg(canvas, 3, function(current, neighbors) {
        var pixNeighbors = getPixelNeighbors(dirMap[current]);

        /** pixel neighbors to compare */
        var pix1 = gradMap[neighbors[pixNeighbors[0].x][pixNeighbors[0].y]];
        var pix2 = gradMap[neighbors[pixNeighbors[1].x][pixNeighbors[1].y]];

        if (pix1 > gradMap[current] ||
            pix2 > gradMap[current] ||
            (pix2 === gradMap[current] &&
                pix1 < gradMap[current])) {
            setPixel(current, 0, imgDataCopy);
        }
    });

    ctx.putImageData(imgDataCopy, 0, 0);
}
```

抑制之后，看起来比以前效果要好：

<p>
<p data-height="383" data-theme-id="21735" data-slug-hash="jVOBNe" data-default-tab="result" data-user="aleen42" data-embed-version="2" data-pen-title="jVOBNe" class="codepen">See the Pen <a href="http://codepen.io/aleen42/pen/jVOBNe/">jVOBNe</a> by aleen42 (<a href="http://codepen.io/aleen42">@aleen42</a>) on <a href="http://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>
</p>

#### Canny 磁滞

无论如何，这个所谓的 “弱” 边还需要进一步加工。Canny 磁滞是 Canny 边缘检测的改进方法。

```js
function createHistogram(canvas) {
    var histogram = {
        g: []
    };

    var size = 256;
    var total = 0;

    var ctx = canvas.getContext('2d');

    var imgData = ctx.getImageData(0, 0, canvas.width, canvas.height);

    while (size--) {
        histogram.g[size] = 0;
    }

    runImg(canvas, null, function(i) {
        histogram.g[imgData.data[i]]++;
        total++;
    });

    histogram.length = total;

    return histogram;
};

function calcBetweenClassVariance(weight1, mean1, weight2, mean2) {
    return weight1 * weight2 * (mean1 - mean2) * (mean1 - mean2);
};

function calcWeight(histogram, s, e) {
    var total = histogram.reduce(function(i, j) {
        return i + j;
    }, 0);

    var partHist = (s === e) ? [histogram[s]] : histogram.slice(s, e);
    var part = partHist.reduce(function(i, j) {
        return i + j;
    }, 0);

    return parseFloat(part, 10) / total;
};

function calcMean(histogram, s, e) {
    var partHist = (s === e) ? [histogram[s]] : histogram.slice(s, e);

    var val = 0;
    var total = 0;

    partHist.forEach(function(el, i) {
        val += ((s + i) * el);
        total += el;
    });

    return parseFloat(val, 10) / total;
};

function fastOtsu(canvas) {
    var histogram = createHistogram(canvas);
    var start = 0;
    var end = histogram.g.length - 1;

    var leftWeight;
    var rightWeight;
    var leftMean;
    var rightMean;

    var betweenClassVariances = [];
    var max = -Infinity;
    var threshold;

    histogram.g.forEach(function(el, i) {
        leftWeight = calcWeight(histogram.g, start, i);
        rightWeight = calcWeight(histogram.g, i, end + 1);
        leftMean = calcMean(histogram.g, start, i);
        rightMean = calcMean(histogram.g, i, end + 1);
        betweenClassVariances[i] = calcBetweenClassVariance(leftWeight, leftMean, rightWeight, rightMean);

        if (betweenClassVariances[i] > max) {
            max = betweenClassVariances[i];
            threshold = i;
        }
    });

    return threshold;
};

function getEdgeNeighbors(i, imgData, threshold, includedEdges) {
    var neighbors = [];
    var pixel = new Pixel(i, imgData.width, imgData.height);

    for (var j = 0; j < pixel.neighbors.length; j++) {
        if (imgData.data[pixel.neighbors[j]] >= threshold && (includedEdges === undefined || includedEdges.indexOf(pixel.neighbors[j]) === -1)) {
            neighbors.push(pixel.neighbors[j]);
        }
    }

    return neighbors;
}

function _traverseEdge(current, imgData, threshold, traversed) {
    /**
     * traverses the current pixel until a length has been reached
     * initialize the group from the current pixel's perspective
     */
    var group = [current];

    /** pass the traversed group to the getEdgeNeighbors so that it will not include those anymore */
    var neighbors = getEdgeNeighbors(current, imgData, threshold, traversed);

    for (var i = 0; i < neighbors.length; i++) {
        /** recursively get the other edges connected */
        group = group.concat(_traverseEdge(neighbors[i], imgData, threshold, traversed.concat(group)));
    }

    /** if the pixel group is not above max length, it will return the pixels included in that small pixel group */
    return group;
}

function hysteresis(canvas) {
    var ctx = canvas.getContext('2d');

    var imgDataCopy = ctx.getImageData(0, 0, canvas.width, canvas.height);

    /** where real edges will be stored with the 1st pass */
    var realEdges = [];

    /** high threshold value */
    var t1 = fastOtsu(canvas);

    /** low threshold value */
    var t2 = t1 / 2;

    /** first pass */
    runImg(canvas, null, function(current) {
        if (imgDataCopy.data[current] > t1 && realEdges[current] === undefined) {
            /** accept as a definite edge */
            var group = _traverseEdge(current, imgDataCopy, t2, []);
            for (var i = 0; i < group.length; i++) {
                realEdges[group[i]] = true;
            }
        }
    });

    /** second pass */
    runImg(canvas, null, function(current) {
        if (realEdges[current] === undefined) {
            setPixel(current, 0, imgDataCopy);
        } else {
            setPixel(current, 255, imgDataCopy);
        }
    });

    ctx.putImageData(imgDataCopy, 0, 0);
}
```

从图中删除 “弱” 边之后是什么样的呢？

<p>
<p data-height="383" data-theme-id="21735" data-slug-hash="RowpLx" data-default-tab="result" data-user="aleen42" data-embed-version="2" data-pen-title="RowpLx" class="codepen">See the Pen <a href="http://codepen.io/aleen42/pen/RowpLx/">RowpLx</a> by aleen42 (<a href="http://codepen.io/aleen42">@aleen42</a>) on <a href="http://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>
</p>

哇，看起来更完美了。

#### 扫描

这幅图只有两种像素：0 和 255，可以通过扫描每个像素生成点路径。算法描述如下：

- 循环获取像素值, 检测是否被标记为255值.
- 匹配之后，找出生成最长路径的方向。（当一条路径是由自身组成的，每个像素都会被标记，当一条路径的点有超过一个值，就是一条真实路径，**6** ~ **10**。）

扫描之后，提取 SVG 的路径数据，当然你还可以绘制路径。

### 小结

本文详细地讨论了如何用 JavaScript 绘图，不管是 SVG 文件还是其他类型图片，比如 PNG、JPG 和 GIF。核心思想是转换特定格式到路径数据。一旦抽离出这样的数据，我们还可以模进行模拟绘图。

- 直接绘制 SVG 文件中的 `path` 元素。
- 如果是其他元素，例如 `rect`，需要先转换成 `path`。
- 使用 Canny 轮廓检测算法检测位图中的轮廓，这样才可以绘制.

### 参考文档

- [1] ["光线绘图动画"](./../../Programming/JavaScript/webgl/canvas/line_drawing/line_drawing.md), 2016
- [2] ["位图轮廓查找"](./../../Programming/JavaScript/webgl/canvas/finding_contours/finding_contours.md), 2016
- [3] ["绘制一个 SVG 文件"](./../../Programming/JavaScript/webgl/canvas/drawing_an_svg/drawing_an_svg.md), 2016
- [4] ["SVG 文件绘制的校准参数"](./../../Programming/JavaScript/webgl/SVG/calibration_parameters/calibration_parameters.md), 2016
- [5] ["转换所有形状/原始形状到 SVG 的路径元素"](./../../Programming/JavaScript/webgl/SVG/convert_shapes_to_path/convert_shapes_to_path.md), 2016
- [6] ["轮廓"](https://github.com/JMPerez/contour), 2015
- [7] ["Canny 边缘检测器"](https://en.wikipedia.org/wiki/Canny_edge_detector), Wikipedia, 2016
