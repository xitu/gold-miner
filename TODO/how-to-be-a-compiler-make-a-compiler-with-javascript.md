> * 原文地址：[How to be* a compiler — make a compiler with JavaScript](https://medium.com/@kosamari/how-to-be-a-compiler-make-a-compiler-with-javascript-4a8a13d473b4#.r832qh7i8)
* 原文作者：[Mariko Kosaka](https://medium.com/@kosamari)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# How to be* a compiler — make a compiler with JavaScript








*Yes! you should _be_ a compiler. It’s awesome.

One wonderful Sunday in Bushwick, Brooklyn. I found a book [“Design by Numbers” by John Maeda](https://mitpress.mit.edu/books/design-numbers) at my local bookstore. In it was step by step instruction of [DBN programming language](http://dbn.media.mit.edu/) — a language made in late 90s at MIT Media Lab, designed to introduce computer programming concepts in visual way.

![](https://cdn-images-1.medium.com/max/1600/1*l2yQRbwlojZhNyEJi8uVDA.png)



DNB code sample from [http://dbn.media.mit.edu/introduction.html](http://dbn.media.mit.edu/introduction.html)

I imminently thought making SVG out of DBN and run it in browser would be an interesting project in 2016 rather than installing Java environment to execute original DBN source code.

I figured I would need to write a DBN to SVG compiler, so the quest of writing a compiler has began. **“Making compiler” sounds like a lot of computer science… but I’ve never traversed nodes in coding interview, can I make a compiler?**







![](https://cdn-images-1.medium.com/max/1600/1*mihwNKQqerkXUZ4GQhqgsg.png)



My imaginary compiler, where code goes to be punished. If the code is bad, it’s captured in error message forever.











* * *







### Let’s try to be a compiler first

Compiler is a mechanism that takes a piece of code and turn it into something else. Let’s compile simple DBN code into a physical drawing.

There are 3 commands in this DBN code, “Paper” defines color of the paper, “Pen” defines color of the pen, and “Line” draw a line. 100 in color parameter means 100% black or rgb(0%, 0%, 0%) in CSS. The image produced in DBN are always in grayscale. In DBN, a paper is always 100×100, line-width is always 1, and Line is defined by x y coordinates of starting point and ending point counting from bottom-left corner.

Let’s try to be a compiler ourself. Stop here, grab a paper and a pen and try compiling following code as drawing.

    Paper 0
    Pen 100
    Line 0 50 100 50

Did you draw a black line in the middle from left side to right side? Congratulations! You just became a compiler.







![](https://cdn-images-1.medium.com/max/1600/1*aDJskliFHSIIfYhr8aN3UA.png)



Compiled result

### How does a compiler work ?

Let’s look at what just happened in our head as a compiler.

#### 1\. Lexical Analysis (tokenization)

First thing we did was to separate each keywords (called tokens) by white space. While we are separating words, we also assigned primitive types to each tokens, like “word” or “number”.







![](https://cdn-images-1.medium.com/max/1600/1*lM4hjuI28Dodn-DfnXQu4A.png)



lexical analysis

#### 2\. Parsing (Syntactical Analysis)

Once a blob of text is separated into tokens, we went through each of them and tried to find a relationship between tokens.  
In this case, we group together numbers associated with command keyword. By doing this, we start seeing a structure of the code.







![](https://cdn-images-1.medium.com/max/1600/1*Masaunh04PyclWIGhztHmg.png)



Parsing

#### 3\. Transformation

Once we analyzed syntax by parsing, we transformed the structure to something suitable for the final result. In this case, we are going to draw an image, so we are going to transform it to step by step instruction for humans.







![](https://cdn-images-1.medium.com/max/1600/1*ExV6vUNKZ4-IpG15-CAeFw.png)



Transformation

#### 4\. Code Generation

Lastly, we make a compiled result, a drawing. At this point, we just follow the instructions we made in previous step to draw.







![](https://cdn-images-1.medium.com/max/1600/1*250m-6zI6slTBirOxHX7kw.png)



Code Generation

And that’s what a compiler does!

The drawing we made is the compiled result (like .exe file when you compile C code). We can pass this drawing to anyone or any device (scanner, camera etc) to “run it” and everyone (or device) will see a black line in the middle.











* * *







### Let’s make a compiler

Now that we know how compilers work, let’s make one in JavaScript. This compiler takes DBN code and turn them into SVG code.

#### 1\. Lexer function

Just like we can split English sentence “I have a pen” to [I, have, a, pen], lexical analyzer splits a code string into small meaningful chunks (tokens). In DBN, each token is delimited by white spaces, and classified as either “word” or “number”.





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

#### 2\. Parser function

Parser go through each tokens, find syntactic information, and builds an object called AST (Abstract Syntax Tree). You can think of AST as a map for our code — a way to understand how a piece of code is structured.

In our code, there are 2 syntax types “NumberLiteral” and “CallExpression”. NumberLiteral means the value is a number. It is used as arguments for CallExpression.





    function parser (tokens) {
      var AST = {
        type: 'Drawing',
        body: []
      }
      // extract a token at a time as current_token. Loop until we are out of tokens.
      while (tokens.length > 0){
        var current_token = tokens.shift()

        // Since number token does not do anything by it self, we only analyze syntax when we find a word.
        if (current_token.type === 'word') {
          switch (current_token.value) {
            case 'Paper' :
              var expression = {
                type: 'CallExpression',
                name: 'Paper',
                arguments: []
              }
              // if current token is CallExpression of type Paper, next token should be color argument
              var argument = tokens.shift()
              if(argument.type === 'number') {
                expression.arguments.push({  // add argument information to expression object
                  type: 'NumberLiteral',
                  value: argument.value
                })
                AST.body.push(expression)    // push the expression object to body of our AST
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

#### 3\. Transformer function

AST we created in previous step is good at describing what’s happening in the code, but it is not useful to create SVG file out of it.  
For example. “Paper” is a concept that only exists in DBN paradigm. In SVG, we might use element to represent a Paper. Transformer function converts AST to another AST that is SVG friendly.





    function transformer (ast) {
      var svg_ast = {
        tag : 'svg',
        attr: {
          width: 100, height: 100, viewBox: '0 0 100 100',
          xmlns: 'http://www.w3.org/2000/svg', version: '1.1'
        },
        body:[]
      }

      var pen_color = 100 // default pen color is black

      // Extract a call expression at a time as `node`. Loop until we are out of expressions in body.
      while (ast.body.length > 0) {
        var node = ast.body.shift()
        switch (node.name) {
          case 'Paper' :
            var paper_color = 100 - node.arguments[0].value
            svg_ast.body.push({ // add rect element information to svg_ast's body
              tag : 'rect',
              attr : {
                x: 0, y: 0,
                width: 100, height:100,
                fill: 'rgb(' + paper_color + '%,' + paper_color + '%,' + paper_color + '%)'
              }
            })
            break
          case 'Pen':
            pen_color = 100 - node.arguments[0].value // keep current pen color in `pen_color` variable
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

#### 4\. Generator function

As the final step of this compiler, generator function creates SVG code based on new AST we made in previous step.





    function generator (svg_ast) {

      // create attributes string out of attr object
      // { "width": 100, "height": 100 } becomes 'width="100" height="100"'
      function createAttrString (attr) {
        return Object.keys(attr).map(function (key){
          return key + '="' + attr[key] + '"'
        }).join(' ')
      }

      // top node is always . Create attributes string for svg tag
      var svg_attr = createAttrString(svg_ast.attr)

      // for each elements in the body of svg_ast, generate svg tag
      var elements = svg_ast.body.map(function (node) {
        return ''
      }).join('\n\t')

      // wrap with open and close svg tag to complete SVG code
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
      
      
    

#### 5\. Put it all together as a compiler

Let’s call this compiler the “sbn compiler” (SVG by numbers compiler).  
We create a sbn object with lexer, parser, transformer, and generator methods. Then add a “compile” method to call all 4 methods in a chain.

We can now pass code string to the compile method and get SVG out.





    var sbn = {}
    sbn.VERSION = '0.0.1'
    sbn.lexer = lexer
    sbn.parser = parser
    sbn.transformer = transformer
    sbn.generator = generator

    sbn.compile = function (code) {
      return this.generator(this.transformer(this.parser(this.lexer(code))))
    }

    // call sbn compiler
    var code = 'Paper 0 Pen 100 Line 0 50 100 50'
    var svg = sbn.compile(code)
    document.body.innerHTML = svg





I’ve made a [interactive demo](https://kosamari.github.io/sbn/) that shows you results of each steps in this compiler. Code for sbn compiler is posted on [github](https://github.com/kosamari/sbn). I’m adding more features into the compiler at the moment. If you want to check the basic compiler we made in this post, please check out [simple branch](https://github.com/kosamari/sbn/tree/simple).







![](https://cdn-images-1.medium.com/max/1600/1*7ADpMcLo1VOnW4-fF2vjDg.png)



[https://kosamari.github.io/sbn/](https://kosamari.github.io/sbn/)

### Shouldn’t a compiler use recursion and traversal etc ?

Yes, those are all wonderful techniques to build a compiler, but that doesn’t mean you have to take that approach first.

I started by making compiler for a small subset of DBN programming language, a very limited small feature set. Since then, I expanded scope and now planning on adding features like variable, code block, and loops to this compiler. It would be a good idea to use those technique at this point, but it was not the requirement to get started.

### Writing compiler is awesome

What can you do by making your own compiler ? Maybe you might want to make new JavaScript-like language in Spanish… how about español script?

    // ES (español script)
    función () {
      si (verdadero) {
        return «¡Hola!»
      }
    }

There are people who made programming language in [Emoji (Emojicode)](http://www.emojicode.org/)and in [colored image (Piet programming language)](http://www.dangermouse.net/esoteric/piet.html). Possibilities are endless !











* * *







### Learnings from making a compiler

Making a compiler was fun, but most importantly, it taught me a lot about software development. Here are few things I learned while making my compiler.







![](https://cdn-images-1.medium.com/max/1600/1*AREFc7UVIAu_YIgk46EwaA.png)



How I imagine compiler after making one myself

#### 1\. It’s okay to have unfamiliar things.

Much like our lexical analyzer, you don’t need to know everything from the beginning. If you don’t really understand a piece of code or technology, it’s okay to just say “There is a thing, I know that much” and pass it on to next step. Don’t stress about it, you’ll get there eventually.

#### 2\. Don’t be a jerk with bad error message.

Parser’s role is to follow the rule and check if things are written according to those rules. So, many times, error happens. When it does, try to send helpful and welcoming messages. It’s easy to say “It doesn’t work that way” (like “ILLEGAL Token” or “undefined is not a function” error in JavaScript) but in stead, try to tell users what should happen as much as you can.

This also applies to team communication. When someone is stuck with a question, instead of saying “yeah that doesn’t work”, maybe you can start saying “I would google keywords like ___ and ___ .” or “I recommend reading this page on documentation.” You don’t need to do the work for them, but you can certainly help them do the work better and faster by providing a little more help.

Elm is a programming language [that embrace this method](http://elm-lang.org/blog/compiler-errors-for-humans). They put “Maybe you want to try this ?” in their error message.

#### 3\. Context is everything

Finally, just like our transformer transformed one type of AST to another more fitting one for the final result, everything is context specific.

There is no one perfect way to do things. So don’t just do things because it is popular or you have done it before, think about the context first. Things that work for one user may be a disaster for another user.

Also, appreciate the work those transformers do. You may know good transformers in your team — someone who is really good at bridging gaps. Those work by transformers may not directly create a code, but it is a damn important work in producing quality product.











* * *







Hope you enjoyed this post and hope I convinced you how awesome it is to build & be a compiler!





