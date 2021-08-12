> * 原文地址：[I Used Python to Create My Own Programming Language](https://python.plainenglish.io/introduction-to-creating-interpreter-using-python-c2a9a6820aa0)
> * 原文作者：[Umangshrestha](https://medium.com/@umangshrestha09)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/introduction-to-creating-interpreter-using-python.md](https://github.com/xitu/gold-miner/blob/master/article/2021/introduction-to-creating-interpreter-using-python.md)
> * 译者：[jaredliw](https://github.com/jaredliw)
> * 校对者：

# 我用 Python 创建了一个属于我自己的编程语言

计算机只能理解机器码。 归根结底，编程语言只是一串文字，目的是为了让人类更容易编写他们想让计算机做的事情。 真正的魔法是由编译器和解释器完成以弥合两者之间的差距。 解释器逐行读取代码并将其转换为机器码。 在本文中，我们将设计一个可以执行算术运算的解释器。 我们不会重新造轮子。 我将使用由 David M. Beazley 开发的词法解析器 —— PLY（[Python Lex-Yacc](https://github.com/dabeaz/ply)）。PLY 可以通过以下方式下载：

```bash
$ pip install ply
```

我们将粗略地浏览一下创建解释器所需的基础知识。 欲了解更多，请参阅[这个](https://github.com/dabeaz/ply) GitHub 仓库。

![basic representation of interpreter](https://cdn-images-1.medium.com/max/2000/1*fnh2Q_e0lHe8zgqpPPEyRQ.png)

## 标记 （Token）

`标记`是为解释器提供有意义信息的最小字符单位。 标记包含一对名称和属性值。

让我们从创建标记名称列表开始。 这是一个必要的步骤。

```Python
tokens = (
    # 数据类型
    "NUM",
    "FLOAT",
    # 算术运算
    "PLUS",
    "MINUS",
    "MUL",
    "DIV",
    # 括号
    "LPAREN",
    "RPAREN",
)
```

## 词法分析器 （Lexer）

将语句转换为标记的过程称为`标记化（Tokenization）`或`词法分析（Lexing）`。 执行 `词法分析` 的程序是 `词法分析器 （Lexer）`。

```Python
# 这些 Token 的正则表达
t_PLUS    =  r"\+"
t_MINUS   =  r"\-"
t_MUL     =  r"\*"
t_DIV     =  r"/"
t_LPAREN  =  r"\("
t_RPAREN  =  r"\)"
# 忽略空格和制表符
t_ignore  =  r" \t"

# 为每个规则添加动作
def t_FLOAT(t):
    r"\d+\.\d+"
    t.value = float(t.value)
    return t

def t_NUM(t):
    r"\d+"
    t.value = int(t.value)
    return t

# 未定义规则字符的错误处理
def t_error(t):
    # 此处的 t.value 包含未标记的其余输入
    print(f"keyword not found: {t.value[0]}\nline {t.lineno}")
    t.lexer.skip(1)

# 如果看到 \n 则将其设为新的一行
def t_newline(t):
    r"\n+"
    t.lexer.lineno += t.value.count("\n")
```

要导入词法分析器，我们将使用：

`import ply.lex as lex`

`t_` 是一个特殊的前缀，表示定义标记的规则。 每条词法规则都是用正则表达式制作的，与 python 中的 [`re`](https://umangshrestha09.medium.com/list/regex-423b3a281bcc) 模块兼容。 正则表达式能够根据规则扫描样式并搜索有限的符号串。 正则表达式定义的文法称为**正则文法**。正则文法定义的语言则称为**正则语言**。

定义好了规则，我们将构建词法分析器。

```py
data = 'a = 2 +(10 -8)/1.0'

lexer = lex.lex()
lexer.input(data)

while tok := lexer.token():
    print(tok)
```

为了传递输入字符串，我们使用 `lexer.input(data)`。`lexer.token()` 将返回下一个 `LexToken` 实例，最后返回 `None`。根据上述规则，代码`2 + ( 10 -8)/1.0` 的标记将是：

![](https://cdn-images-1.medium.com/max/2000/1*59uivI84Mhe-UjeeGs1xoQ.jpeg)

紫色字符代表的是标记的名称。

## Backus-Naur Form (BNF)

Most programming languages can be written by `context-free languages`. It is more complex that regular languages. For `context free language` we use `context free grammar` which is the set of rules to describe all the possible syntax in the language. BNF is the way of defining syntax that describes the grammar of programming language. With that out of the way. Lets see the example:

symbol := alternative1| alternative2 …

Based on the production rule the left hand side of `:=` is replaced by value one of the alternative in right hand side which are separated by `|`. For the calculator interpreter I am using grammar specification like:

```
expression expression : expression '+' factor
                      | expression '-' factor
                      | expression '/' factor
                      | expression '*' factor
                      | expression '^' factor
                      | -expression
                      | factor

factor     : NUM
           | float
           | ( expression )
```

The input tokens are symbols such as `Num, Float, +, — , *, /. `are `terminals`. It consists of collection of terminals and rules such as term and factor `non-terminals`. For more information on BNF refer [here](https://isaaccomputerscience.org/concepts/dsa_toc_bnf).

## Parser

We will be using `YACC` (`Yet another compiler-compiler`) as parser generator. To use it we will use `import ply.yacc as yacc`.

```Python
from operator import (add,  sub, mul, truediv, pow) 

# list of operators supported by our interpetor
ops = {
    '+' : add,
    '-' : sub,
    '*' : mul,
    '/' : truediv,   
    '^' : pow,  
}

def p_expression(p):
    """expression : expression PLUS factor
                | expression MINUS factor
                | expression DIV factor
                | expression MUL factor
                | expression POW factor"""
    if (p[2], p[3]) == ("/",  0):
        # if  division is by 0 puttinf 'inf' as value 
        p[0] = float('INF')
    else:  
        p[0] = ops[p[2]](p[1], p[3])

def p_expression_uminus(p):
    "expression : MINUS expression %prec UMINUS"
    p[0] = -p[2]

def p_expression_factor(p):
    'expression : factor'
    p[0] = p[1]

def p_factor_num(p):
    """factor : NUM
            | FLOAT"""
    p[0] = p[1]

def p_factor_expr(p):
    'factor : LPAREN expression RPAREN'
    p[0] = p[2]

# Error rule for syntax errors
def p_error(p):
    print(f"Syntax error in {p.value}")
```

In the doc string we will add appropriate grammar specification. The `p` values are mapped to grammatical symbols as shown below:

```
expression: expression PLUS  expression
p[0]         p[1]       p[2]  p[3]
```

Then we can add the rule based on expression. Yacc allows individual tokens to be assigned precedence level. We can set it using:

```py
precedence = (
    ('left', 'PLUS', 'MINUS'),
    ('left', 'MUL', 'DIV'),
)
```

`PLUS` and `MINUS` have the same precedence level and have left associativity. The `MUL` and `DIV` have higher precedence that `PLUS` and `MINUS`.

To parse the code we will use:

```py
parser = yacc.yacc()result = parser.parse(data)print(result)
```

The full code is here:

```Python
###################################### Imports                           ######################################from operator import (add,  sub, mul, truediv, pow) import ply.yacc as yaccimport ply.lex as lexfrom logging import (basicConfig, INFO, getLogger)# list of operators supported by our interpetorops = {    '+' : add,    '-' : sub,    '*' : mul,    '/' : truediv,       '^' : pow,  }###################################### List of tokens                    ######################################tokens = (    # data types    "NUM",    "FLOAT",        # athemetic operations       "PLUS",    "MINUS",    "MUL",    "DIV",    "POW",    # brackets    "LPAREN",    "RPAREN",)###################################### Regular expression for the tokens ######################################t_PLUS    =  r"\+"t_MINUS   =  r"\-"t_MUL     =  r"\*"t_DIV     =  r"/"t_LPAREN  =  r"\("t_RPAREN  =  r"\)"t_POW     =  r"\^"# spaces and tabs will be ignoredt_ignore  =  r" \t"# adding rules with actionsdef t_FLOAT(t):    r"\d+\.\d+"    t.value = float(t.value)    return tdef t_NUM(t):    r"\d+"    t.value = int(t.value)    return tdef t_error(t):    print(f"keyword not found: {t.value[0]}\nline {t.lineno}")    t.lexer.skip(1)def t_newline(t):    r"\n+"    t.lexer.lineno += t.value.count("\n")###################################### Setting precedence of symbols     ######################################precedence = (    ('left', 'PLUS', 'MINUS'),    ('left', 'MUL', 'DIV'),    ('right', 'UMINUS'),)###################################### Writing BNF rule                  ######################################def p_expression(p):    """expression : expression PLUS factor                | expression MINUS factor                | expression DIV factor                | expression MUL factor                | expression POW factor"""    if (p[2], p[3]) == ("/",  0):        # if  division is by 0 puttinf 'inf' as value         p[0] = float('INF')    else:          p[0] = ops[p[2]](p[1], p[3])def p_expression_uminus(p):    "expression : MINUS expression %prec UMINUS"    p[0] = -p[2]def p_expression_factor(p):    'expression : factor'    p[0] = p[1]def p_factor_num(p):    """factor : NUM            | FLOAT"""    p[0] = p[1]def p_factor_expr(p):    'factor : LPAREN expression RPAREN'    p[0] = p[2]# Error rule for syntax errorsdef p_error(p):    print(f"Syntax error in {p.value}")###################################### Main                              ######################################if __name__ == "__main__":    basicConfig(level=INFO, filename="logs.txt")    lexer = lex.lex()    parser = yacc.yacc()    while 1:        try:            result = parser.parse(                input(">>>"),                 debug=getLogger())            print(result)        except AttributeError:            print("invalid syntax")
```

## 结论

由于这个话题的体积庞大，这篇文章并不能将事物完全的解释清楚，但我希望你能很好地理解文中涵盖的表层知识。 我很快会发布关于这个话题的其他文章。 谢谢你，祝你有个美好的一天。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
