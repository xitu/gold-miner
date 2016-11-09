> * 原文地址：[How to be* a compiler — make a compiler with JavaScript](https://medium.com/@kosamari/how-to-be-a-compiler-make-a-compiler-with-javascript-4a8a13d473b4#.r832qh7i8)
* 原文作者：[Mariko Kosaka](https://medium.com/@kosamari)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[luoyaqifei](http://www.zengmingxia.com)
* 校对者：[rottenpen](https://github.com/rottenpen)，[xiaoheiai4719](https://github.com/xiaoheiai4719)

# 成为一个编译器之「使用 JavaScript 来制作编译器」








对的！你应该**成为**一个编译器。这很棒！

布希维克，布鲁克林，一个很棒的周日。我在书店里发现了一本书 [John Maeda 写的 “Design by Numbers” ](https://mitpress.mit.edu/books/design-numbers)。在这本书里有 [DBN 编程语言](http://dbn.media.mit.edu/) 一步步的指令——这是一种 90 年代末期被 MIT 媒体实验室创造出来的语言，它被设计出来，以可视化的方式介绍计算机编程概念。

![](https://cdn-images-1.medium.com/max/1600/1*l2yQRbwlojZhNyEJi8uVDA.png)



这是 DNB 代码示例 [http://dbn.media.mit.edu/introduction.html](http://dbn.media.mit.edu/introduction.html)。

我马上想到，用 DBN 制作出 SVG 并将它放在浏览器里执行，在 2016 年这个年头，一定比安装 Java 环境来执行原生的 DBN 源代码要来得有趣。

我意识到我需要写一个 DBN 到 SVG 的编译器，所以写编译器的探索之路开始了。**「制作一个编译器」听起来很计算机科学……但是我从没在代码面试中遍历过节点，我真能造出一个编译器？**







![](https://cdn-images-1.medium.com/max/1600/1*mihwNKQqerkXUZ4GQhqgsg.png)



我想象中的编译器，应该是代码需要被严格对待的。如果代码写得很差，它将永久地陷在错误信息里。











* * *







### 让我们先尝试着成为一个编译器

编译器是一种接收一段代码然后把它转成一些别的什么的机制。让我们编译简单的 DBN 代码到实质的画上。

在这段 DBN 代码中有 3 个指令，「Paper」定义了纸的颜色，「Pen」定义了笔的颜色，「Line」画出来一条线。100 在颜色参数中代表着 100% 的黑色或者 CSS 中的 rgb(0%, 0%, 0%)。DBN 生成的图片总是用灰度表示的。在 DBN 中，一张纸总是 100 × 100，线条宽度总是 1，线段用起点和终点相对于左下角的 x 、y 坐标来定义。

让我们先尝试着变成一个编译器。停在这里，拿一张纸和一支笔，然后尝试着编译下面的画图代码：

    Paper 0
    Pen 100
    Line 0 50 100 50

你在纸的中间，从左到右地画出来一条黑色的线了吗？恭喜！你刚刚变身成了一个编译器！







![](https://cdn-images-1.medium.com/max/1600/1*aDJskliFHSIIfYhr8aN3UA.png)



编译结果

### 编译器是怎么工作的？

让我们看看刚刚在我们作为编译器的脑袋里发生了什么。

#### 1\. 词法分析（标记化）

首先我们做的就是将每个关键字（称为标记）用空格分开。当我们分割单词时，我们也将原始类型赋给每个标记，比如「单词」或者「数字」。







![](https://cdn-images-1.medium.com/max/1600/1*lM4hjuI28Dodn-DfnXQu4A.png)



词法分析

#### 2\. Parsing (语法分析)

当一堆文本被分割成标记后，我们遍历这些标记，尝试去找它们之间的关系。
在这种情况下，我们将数字和与其相联系的命令关键字分为一组。通过这么做，我们开始观察代码的结构。







![](https://cdn-images-1.medium.com/max/1600/1*Masaunh04PyclWIGhztHmg.png)



语法分析

#### 3\. 转换

一旦我们完成了语法分析，我们需要将结构转换成更适合于最终结果的。在本文情况下，我们将要画一张图，所以我们要将它转换成对人类的一步步的指令。







![](https://cdn-images-1.medium.com/max/1600/1*ExV6vUNKZ4-IpG15-CAeFw.png)



转换

#### 4\. 代码生成

最后，我们生成一个编译结果，一幅画。在这个环节，我们只是遵循我们在之前的步骤里生成的指令来画画。







![](https://cdn-images-1.medium.com/max/1600/1*250m-6zI6slTBirOxHX7kw.png)



代码生成

这就是编译器做的事情啦！

我们生成的画就是编译结果（就好像你编译 C 语言时的 .exe 文件）。我们可以将这幅画给任何人或者任何设备（扫描仪、相机等）传阅，来「执行它」，所有人（或设备）将会看到一条居中黑线。











* * *







### 让我们制作一个编译器

现在既然我们知道了编译器是怎么工作的，让我们用 JavaScript 来制作一个。这个编译器接收 DBN 代码并将它转成 SVG 代码。

#### 1\. 词法分析器函数

就像我们将英语句子「I have a pen」分割成 [I, have, a, pen] 一样，词法分析器将一段代码字符串分割成小的有意义的块（标记）。在 DBN 里，每个标记都被空格分隔开，并且被分成「单词」或是「数字」。





    function lexer (code) {
      return code.split(/\s+/)
              .filter(function (t) { return t.length > 0 })
              .map(function (t) {
                return isNaN(t)
                        ? {type: 'word', value: t}
                        : {type: 'number', value: t}
              })
    }





    input: "Paper 100"
    output:[
      { type: "word", value: "Paper" }, { type: "number", value: 100 }
    ]

#### 2\. 语法分析器函数

语法分析器遍历每个标记，寻找语法信息，并且构建一个叫做 AST（Abstract Syntax Tree，抽象语法树）的对象。你可以把 AST 想成一幅代码地图——这是理解一段代码如何架构的方式。

在我们的代码里，有 2 个语法类型「NumberLiteral」和「CallExpression」。NumberLiteral 意味着值是个数字，它作为参数被 CallExpression 使用。





    function parser (tokens) {
      var AST = {
        type: 'Drawing',
        body: []
      }
      // 一次提取一个标记，作为 current_token，一直循环，直到我们脱离标记。
      while (tokens.length > 0){
        var current_token = tokens.shift()

        // 既然数字标记自身并不做任何事情，我们只要在发现一个单词时分析它的语法。
        if (current_token.type === 'word') {
          switch (current_token.value) {
            case 'Paper' :
              var expression = {
                type: 'CallExpression',
                name: 'Paper',
                arguments: []
              }
              // 如果当前标记是以 Paper 为类型的 CallExpression，下一个标记应该是颜色参数
              var argument = tokens.shift()
              if(argument.type === 'number') {
                expression.arguments.push({  // 在 expression 对象内部加入参数信息
                  type: 'NumberLiteral',
                  value: argument.value
                })
                AST.body.push(expression)    // 将 expression 对象放入我们的 AST 的 body 内
              } else {
                throw 'Paper command must be followed by a number.'
              }
              break
            case 'Pen' :
              ...
            case 'Line':
              ...
          }
        }
      }
      return AST
    }





    input: [
      { type: "word", value: "Paper" }, { type: "number", value: 100 }
    ]
    output: {
      "type": "Drawing",
      "body": [{
        "type": "CallExpression",
        "name": "Paper",
        "arguments": [{ "type": "NumberLiteral", "value": "100" }]
      }]
    }

#### 3\. 转换器函数

我们在上一步创建的 AST 很好地描述了代码里发生的事情，但是它对于创建 SVG 文件没有什么用处。
比方说，「Paper」是一个只存在于 DBN 思维方式里的概念，在 SVG 中，我们可能用元素（element）来表示一个「Paper」。转换器函数将 AST 转换成另一种对 SVG 友好的 AST。





    function transformer (ast) {
      var svg_ast = {
        tag : 'svg',
        attr: {
          width: 100, height: 100, viewBox: '0 0 100 100',
          xmlns: 'http://www.w3.org/2000/svg', version: '1.1'
        },
        body:[]
      }

      var pen_color = 100 // 默认钢笔颜色为黑

      // 一次提取一个调用表达式，作为 `node`。循环直至我们跳出表达式体。
      while (ast.body.length > 0) {
        var node = ast.body.shift()
        switch (node.name) {
          case 'Paper' :
            var paper_color = 100 - node.arguments[0].value
            svg_ast.body.push({ // 在 svg_ast 的 body 内加入 rect 元素信息
              tag : 'rect',
              attr : {
                x: 0, y: 0,
                width: 100, height:100,
                fill: 'rgb(' + paper_color + '%,' + paper_color + '%,' + paper_color + '%)'
              }
            })
            break
          case 'Pen':
            pen_color = 100 - node.arguments[0].value // 把当前的钢笔颜色保存在 `pen_color` 变量内
            break
          case 'Line':
            ...
        }
      }
      return svg_ast
     }





    input: {
      "type": "Drawing",
      "body": [{
        "type": "CallExpression",
        "name": "Paper",
        "arguments": [{ "type": "NumberLiteral", "value": "100" }]
      }]
    }

    output: {
      "tag": "svg",
      "attr": {
        "width": 100,
        "height": 100,
        "viewBox": "0 0 100 100",
        "xmlns": "http://www.w3.org/2000/svg",
        "version": "1.1"
      },
      "body": [{
        "tag": "rect",
        "attr": {
          "x": 0,
          "y": 0,
          "width": 100,
          "height": 100,
          "fill": "rgb(0%, 0%, 0%)"
        }
      }]
    }

#### 4\. 生成器函数

作为这个编译器的最后一步，生成器函数基于我们上一步产生的新 AST 生成了 SVG 代码。





    function generator (svg_ast) {

      // 从 attr 对象中创建属性（attribute）字符串
      // 使得 { "width": 100, "height": 100 } 变成 'width="100" height="100"'
      function createAttrString (attr) {
        return Object.keys(attr).map(function (key){
          return key + '="' + attr[key] + '"'
        }).join(' ')
      }

      // 顶端节点总是 <svg>。为 svg 标签创建属性字符串
      var svg_attr = createAttrString(svg_ast.attr)

      // 为每个 svf_ast body 中的元素，生成 svg 标签
      var elements = svg_ast.body.map(function (node) {
        return ''
      }).join('\n\t')

      // 使用开和关的 svg 标签包装来完成 svg 代码
      return '\n' + elements + '\n'
    }





    input: {
      "tag": "svg",
      "attr": {
        "width": 100,
        "height": 100,
        "viewBox": "0 0 100 100",
        "xmlns": "http://www.w3.org/2000/svg",
        "version": "1.1"
      },
      "body": [{
        "tag": "rect",
        "attr": {
          "x": 0,
          "y": 0,
          "width": 100,
          "height": 100,
          "fill": "rgb(0%, 0%, 0%)"
        }
      }]
    }

    output:
    <svg width="100" height="100" viewBox="0 0 100 100" version="1.1" xmlns="http://www.w3.org/2000/svg">
      <rect x="0" y="0" width="100" height="100" fill="rgb(0%, 0%, 0%)">
      </rect>
    </svg>




#### 5\. 将它们放在一起，作为一个编译器

让我们把这个编译器称为「sbn 编译器」（SVG by numbers 编译器）。
我们创建了一个带有词法分析器、语法分析器、转换器和生成器方法的 sbn 对象，然后添加了一个叫做「compile」的方法来链式调用这四个方法。

我们现在可以将代码串传给「compile」方法，得到 SVG。





    var sbn = {}
    sbn.VERSION = '0.0.1'
    sbn.lexer = lexer
    sbn.parser = parser
    sbn.transformer = transformer
    sbn.generator = generator

    sbn.compile = function (code) {
      return this.generator(this.transformer(this.parser(this.lexer(code))))
    }

    // 调用 sbn 编译器
    var code = 'Paper 0 Pen 100 Line 0 50 100 50'
    var svg = sbn.compile(code)
    document.body.innerHTML = svg





我做了一个 [互动演示](https://kosamari.github.io/sbn/)，其中展示了这个编译器里每一步的结果。这个 sbn 编译器的代码放在 [github](https://github.com/kosamari/sbn) 上，我目前正在给它添加更多的特性。如果你想要检查我们在这篇文章中的基本编译器的画，请切换到 [简单分支](https://github.com/kosamari/sbn/tree/simple)。








![](https://cdn-images-1.medium.com/max/1600/1*7ADpMcLo1VOnW4-fF2vjDg.png)



[https://kosamari.github.io/sbn/](https://kosamari.github.io/sbn/)

### 难道一个编译器不应该使用递归或者遍历之类的吗？

是的，那些是制作一个编译器需要的所有棒棒哒技术，然而这并不意味着你需要先使用那些做法。

我从为 DBN 编程语言的一个小子集（一个非常有限的小特征集）制作编译器开始，扩展范围，现在正准备向这个编译器上添加一些诸如变量、代码块和循环这样的特性。现在这个时候使用那些技术是一个好的想法，但是那些技术并不是刚开始就要用到的。

### 写编译器超棒的

你可以通过制作你自己的编译器来做些什么？也许你想要用西班牙语制作一个新的类 JavaScript 语言……

    // ES (español script)
    función () {
      si (verdadero) {
        return «¡Hola!»
      }
    }

这里有一些人，他们用 [Emoji (Emojicode)](http://www.emojicode.org/) 和 [色块 (Piet 编程语言)](http://www.dangermouse.net/esoteric/piet.html) 制作了编程语言。可能性永无止境！











* * *







### 从制作一个编译器中学到的

 制作编译器很有趣，但最重要的是，它教了我很多软件开发方面的知识。下面是一些我在制作自己的编译器中学到的东西。







![](https://cdn-images-1.medium.com/max/1600/1*AREFc7UVIAu_YIgk46EwaA.png)



在制作了一个我自己的编译器后我是怎么想象编译器的

#### 1\. 有一些不熟悉的东西很正常。

像我们的词法分析器一样，你不必要从刚开始就知道所有的事情。如果你真的不懂一段代码或者技术，只说一句「这有个东西，我只知道这么多了」，然后将它放到下一个步骤去做，也是挺好的。不要对这个事情有压力，你最终会明白它的。

#### 2\. 不要变成一个只发送坏的错误消息的混蛋。

语法分析器的功能是遵循规则、检查代码是不是按照那些规则写的。所以，错误会发生，很多次。当错误发生时，尝试着去发送一些有用的、欢迎式的信息。说「它不是那么工作的」（比如 JavaScript 里的「不合法标记」或者「undefined 不是个函数」错误）当然很简单，但是，请尽量多地告诉用户原本应该发生什么。

这在团队沟通中也有效。当某个人被困在一个问题中的时候，不要说「耶那没有用的」，可能你可以从说「如果是我，我会谷歌关键字 XXX 和 XXX」或「我推荐你读文档上的这一页」开始。你不必为他们做这些工作，但是你可以通过提供一些小的帮助来让他们工作得更好更快。

Elm 是一个 [拥抱这种方法](http://elm-lang.org/blog/compiler-errors-for-humans) 的编程语言。它们将「也许你想试试这个？」放在它们的错误信息里。

#### 3\. 背景就是一切

最后，就像我们的转换器一样，将一种类型的 AST 转换成另一种更加适合的，来用于最终的结果，所有的事情都是指定背景的。

没有一个总是完美的做事方式。所以不要因为某件事情很流行或者你以前做过就只做它，首先想想它的背景。对一个用户可行的事情可能对另一个用户是一场灾难。

同时，欣赏转换器做的那些工作。你可能知道你的团队里的那些好的转换器——某个非常擅长为鸿沟搭桥梁的人。转换器做的那些工作不是直接地创建代码，但都是在生产优秀产品时不可或缺的工作。











* * *







希望你享受这篇文章，希望我可以说服你制作 & 成为一个编译器有多么棒！
