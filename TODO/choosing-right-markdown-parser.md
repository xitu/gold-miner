* 原文链接 : [Choosing the Right Markdown Parser]( https://css-tricks.com/choosing-right-markdown-parser/) 
* 原文作者 : [CSS-TRICKS]( https://css-tricks.com) 
* 译文出自 : [掘金翻译计划]( https://github.com/xitu/gold-miner) 
* 译者 : [lfkdsk]( https://github.com/lfkdsk) 
* 校对者: 
* 状态 : 已认领  

_以下客座文章由[Ray Villalobos]( http://www.raybo.org/)提供。在这篇文章中Ray将要去探索很多种不同的Markdown语法。所有的这些MarkDown变种均提供了不同的特性，都超越传统的Markdown语法，却又相互之间又各有不同。如果你正在挑选一门Markdown语言使用（或是提供给你的Web产品的用户使用），那你就值得的去了解它们，一旦选定就很难再切换到别的Markdown版本而且挑选的结果依赖于你需要哪些特性。Ray提供的一门[关于MarkDown课程]( http://www.lynda.com/Web-Development-tutorials/Up-Running-Markdown/438888-2.html)将会分享这些不同的版本都拥有哪些特性去帮助你做出明智的选择。_ 

Markdown改变了很多专业领域的书写方式。这种语言使用简单的文本和极少的标记并可以将其转换为越来越多的格式。然而不是所有的Markdown解析器被创造出来都是一样的。因为原来的规范没有与时俱进,替代版本像是 Multi-Markdown,GFM(Github Flavored Markdown),Markdown Extra和其他的版本扩充了这门语言。

[Markdown的原始解析器]( https://daringfireball.net/projects/markdown/)是用Perl编写的。核心的特性包括解析块元素（例如段落，换行，标头，块引用，列表，代码块和水平线）和行内元素（链接，加重，代码段和图片）。从那以后，该解析器的作者John Gruber再也没有扩充过语法了，所以很多的新增和实现伴随着不同的他们认为合适的、或是支持解释某些元素的解析器支持浮出水面。


<figure>![]( https://cdn.css-tricks.com/wp-content/uploads/2016/01/choose-markdown.jpg)</figure> 

### 选择一个版本

在一个程序里实现Markdown功能需要考虑很多，包括你将要使用的开发语言和你想要支持的特性。原始的版本是由Perl编写的，对于每一个项目来说，这并不是一个实用的选择。最流行的实现版本包括：PHP, Ruby和JavaScript。你选择了哪种语言将会间接影响你能支持哪些特性和能使用哪些库。让我们来看看一些选择：

<table> 

<thead> 

<tr> 

<th>语言</th> 

<th>库 (下载项目)</th> 

</tr> 

</thead> 

<tbody> 

<tr> 

<td>Perl</td> 

<td>[Original version]( http://daringfireball.net/projects/markdown/)</td> 

</tr> 

<tr> 

<td>JavaScript</td> 

<td>[CommonMark]( https://github.com/jgm/commonmark.js), [Marked]( https://github.com/chjj/marked), [Markdown-it]( https://github.com/markdown-it/markdown-it), [Remarkable]( https://github.com/jonschlinkert/remarkable), [Showdown]( https://github.com/showdownjs/showdown)</td> 

</tr> 

<tr> 

<td>Ruby</td> 

<td>[Github Flavored Markup]( https://github.com/github/markup), [Kramdown]( https://github.com/gettalong/kramdown), [Maruku]( https://github.com/bhollis/maruku), [Redcarpet]( https://github.com/vmg/redcarpet)</td> 

</tr> 

<tr> 

<td>PHP</td> 

<td>[Cebe Markdown]( https://github.com/cebe/markdown), [Ciconia]( https://github.com/kzykhys/Ciconia), [Parsedown](   https://github.com/erusev/parsedown), [PHP Markdown Extended]( https://github.com/piwi/markdown-extended)</td> 

</tr> 

<tr> 

<td>Python</td> 

<td>[Python Markdown]( https://pypi.python.org/pypi/Markdown)</td> 

</tr> 

</tbody> 

</table> 


以防万一你想用别的语言去实现Markdown，这里还有许多额外的[其他的语言](https://github.com/markdown/markdown.github.com/wiki/Implementations)实现的版本。

### 核心特性  

核心Markdown语言支持许多非常有用的默认功能。虽然不同的实现支持一系列的扩展功能，他们都应该至少支持以下核心语法：[行内html]( https://daringfireball.net/projects/markdown/syntax#html), [自动分段]( https://daringfireball.net/projects/markdown/syntax#p), [标头]( https://daringfireball.net/projects/markdown/syntax#header), [块引用]( https://daringfireball.net/projects/markdown/syntax#blockquote), [列表]( https://daringfireball.net/projects/markdown/syntax#list), [代码块]( https://daringfireball.net/projects/markdown/syntax#precode), [水平线]( https://daringfireball.net/projects/markdown/syntax#hr), [链接]( https://daringfireball.net/projects/markdown/syntax#link), [加重]( https://daringfireball.net/projects/markdown/syntax#em), [行内代码]( https://daringfireball.net/projects/markdown/syntax#code) 和 [图片]( https://daringfireball.net/projects/markdown/syntax#img). 

### 值得注意的版本

可用Markdown的版本有很多，有几个已经对其它版本有很大的影响。正因如此，你会经常看到他们被其他版本引述作为其中的一部分。例如，库会提到支持CommonMark，GFM或是Multi-Markdown。让我们来看看那意味着什么。


#### GFM 

Github是使Markdown在开发者中流行的原因之一，开源共享平台接受并扩展了一个叫[Github Flavored Markup]( https://help.github.com/articles/working-with-advanced-formatting/)的版本，（GFM）包括围栏代码块，URL自动链接，删除线，表格甚至能够创建带有勾选框的任务列表。所以，当一个版本支持提及的GFM，就是实现了这些扩展。

**Supports**: [Fenced Codeblocks], [Syntax Highlighting], [Tables], [URL AutoLinking], [Strikethrough] 


#### CommonMark 

最近有一个行动去规范Markdown语法。一组Markdown开发者加入去创建一个版本，测试和文档，最终的结果就是名为[CommonMark](http://commonmark.org/)的更强大的规范语言。此时，这个实现添加了围栏代码块，但是更多的是某些特征是如何获得一致的输出和转换要实现的具体细节。很多的拓展将会带来更加符合[其他语言](https://github.com/jgm/CommonMark/wiki/Proposed-Extensions)已经提出的特性.

这种格式是较新的，不支持很多功能，但它正在积极开发并有计划地增加了许多Multi-Markdown的特性。

**Supports**: [Fenced Codeblocks], [URL AutoLinking], [Strikethrough] 


#### Multi-markdown 

第一个拓展了这门语言的重大的项目是Multi-Markdown。它增加了很多其他版本已经支持的特性。它最初和Markdown一样是用Perl编写的，不过后来转用C来写。所以，如果你看到一个项目支持Multi-Markdown，那么它很可能具有[这些功能](https://rawgit.com/fletcher/human-markdown-reference/master/index.html)大部分。

### 可选择特性

让我们来看看这些不同实现版本都支持的特性。

#### 围栏代码块

其中一个最好的对于开发者的就是能够简单的添加代码在Markdown中。原始的实现对如以四个空格或是一个制表符开头的行自动将文本作为代码块。这在一些时候会产生错误，所以重大的实现引入了围栏代码块通过允许你在将一块文本标记为代码时使用三个刻度标记（`），或在某些情况下三重符号（〜）字符：


    ``` 
    body { 
      margin: 0; 
      padding: 0; 
      color: #222; 
      background-color: white; 
      font-family: sans-serif; 
      font-size: 1.8rem; 
      line-height: 160%; 
      font-weight: 400; 
    } 
    ``` 

**Available with:** [CommonMark]( http://commonmark.org/), [Github Flavored Markdown]( https://help.github.com/articles/github-flavored-markdown/), [Kramdown]( http://kramdown.gettalong.org/), [Markdown-it](   https://markdown-it.github.io/), [Marked]( https://github.com/chjj/marked), [Maruku]( http://maruku.rubyforge.org/index.html), [Multi-Markdown]( http://fletcherpenney.net/multimarkdown/), [PHP Markdown Extended]( https://github.com/piwi/markdown-extended), [Python Markdown]( https://pythonhosted.org/Markdown/), [Redcarpet]( https://github.com/vmg/redcarpet), [Remarkable]( https://jonschlinkert.github.io/remarkable/demo/), [Showdown]( http://showdownjs.github.io/demo/) 

#### 语法高亮

添加代码块是很棒的，但是默认Markdown的解释器将会将代码使用`<code>` 和 `<pre></pre>` 标记简单的包裹起来，这将使文本以一种预定格式和固定宽度字体格式显示。一些实现可以通过允许您指定旁边的刻度标记语言改善这一点，并可能包括一个分析器，可以自动让你选择不同的色彩款式，并指定语言代码编写，这样的颜色是更有意义的。

    ```css 
    body { 
      margin: 0; 
      padding: 0; 
      color: #222; 
      background-color: white; 
      font-family: sans-serif; 
      font-size: 1.8rem; 
      line-height: 160%; 
      font-weight: 400; 
    } 
    ``` 

**Available with:** [Github Flavored Markdown]( https://help.github.com/articles/github-flavored-markdown/), [Kramdown]( http://kramdown.gettalong.org/)*, [Marked]( https://github.com/chjj/marked), [Maruku]( http://maruku.rubyforge.org/index.html), [Multi-Markdown]( http://fletcherpenney.net/multimarkdown/), [PHP Markdown Extended]( https://github.com/piwi/markdown-extended), [Python Markdown]( https://pythonhosted.org/Markdown/), [Redcarpet]( https://github.com/vmg/redcarpet), [Remarkable]( https://jonschlinkert.github.io/remarkable/demo/), [Showdown]( http://showdownjs.github.io/demo/) 

*有些支持不嵌入到解析器，而是依赖于其它的库如[highlight.js]（https://highlightjs.org/）。


#### 表格

在HTML编写表格很笨拙。 markdown的某些版本可以让你添加表以一个相当简单的语法。


    Dimensions | Megapixels 
    ---|--- 
    1,920 x 1,080 | 2.1MP 
    3,264 x 2,448 | 8MP 
    4,288 x 3,216 | 14MP 

Renders like this: 

<table><colgroup><col> <col></colgroup> 

<thead> 

<tr> 

<th>尺寸</th> 

<th>百万像素</th> 

</tr> 

</thead> 

<tbody> 

<tr> 

<td>1,920 x 1,080</td> 

<td>2.1MP</td> 

</tr> 

<tr> 

<td>3,264 x 2,448</td> 

<td>8MP</td> 

</tr> 

<tr> 

<td>4,288 x 3,216</td> 

<td>14MP</td> 

</tr> 

</tbody> 

</table> 

只需要几分钟就能够做出像这样的一个表格，但是在你做过几次后，你会认为使用HTML有一些麻烦。如果你需要帮助创建表格，阅读这篇指南[Markdown Tables Generator]( http://www.tablesgenerator.com/markdown_tables).


[![Markdown Tables Generator]( https://cdn.css-tricks.com/wp-content/uploads/2016/01/OiO5m2q.png)]( http://www.tablesgenerator.com/markdown_tables) 

**Available with:** [Github Flavored Markdown]( https://help.github.com/articles/github-flavored-markdown/), [Kramdown]( http://kramdown.gettalong.org/), [Markdown-it]( https://markdown-it.github.io/), [Marked]( https://github.com/chjj/marked), [Maruku]( http://maruku.rubyforge.org/index.html), [Multi-Markdown]( http://fletcherpenney.net/multimarkdown/), [PHP Markdown Extended]( https://github.com/piwi/markdown-extended), [Python Markdown]( https://pythonhosted.org/Markdown/), [Redcarpet]( https://github.com/vmg/redcarpet), [Remarkable]( https://jonschlinkert.github.io/remarkable/demo/), [Showdown]( http://showdownjs.github.io/demo/) 


#### 元数据

一些拓展将会让你添加元数据以便添加一些信息，例如你的应用可以解析的像是选择模版或是设置一个文章标题。一些人使用[Multi-Markdown structure]( https://github.com/fletcher/MultiMarkdown/wiki/MultiMarkdown-Syntax-Guide#metadata)为了元数据，其他人喜欢Jekyll parser的使用[YAML]( http://www.yaml.org/)，它可以让你表达这种元数据部分中复杂的数据。这对于应用程序开发人员一个非常有用的方便的功能。

    --- 
    Title:  SVG Article  
    Author: Ray Villalobos 
    Date:   January 6, 2016 
    heroimage: " http://i.imgur.com/rBX9z0k.png" 
    tags: 
    - data visualization 
    - bitmap 
    - raster graphics 
    - navigation 
    --- 

**Available with:** [Markdown-it]( https://markdown-it.github.io/), [Maruku]( http://maruku.rubyforge.org/index.html), [Multi-Markdown]( http://fletcherpenney.net/multimarkdown/), [PHP Markdown Extended]( https://github.com/piwi/markdown-extended), [Python Markdown]( https://pythonhosted.org/Markdown/), [Redcarpet]( https://github.com/vmg/redcarpet), [Remarkable]( https://jonschlinkert.github.io/remarkable/demo/), [Showdown]( http://showdownjs.github.io/demo/) 


#### URL 自动链接
这些简单的扩展让你的文字中出现的URL通过分析器会自动转换为链接。这实在是方便，实用的例如GFM，使链接可点击而无需额外的工作使得文档更容易编写的实现。

**Available with:** [CommonMark]( http://commonmark.org/), [Github Flavored Markdown]( https://help.github.com/articles/github-flavored-markdown/), [Kramdown]( http://kramdown.gettalong.org/), [Markdown-it](   https://markdown-it.github.io/), [Marked]( https://github.com/chjj/marked), [Maruku]( http://maruku.rubyforge.org/index.html), [Multi-Markdown]( http://fletcherpenney.net/multimarkdown/), [PHP Markdown Extended]( https://github.com/piwi/markdown-extended), [Python Markdown]( https://pythonhosted.org/Markdown/), [Redcarpet]( https://github.com/vmg/redcarpet), [Remarkable]( https://jonschlinkert.github.io/remarkable/demo/), [Showdown]( http://showdownjs.github.io/demo/) 


#### 脚注和其他链接类型

脚注允许你创建你的文档中到放置在Markdown页面底部引用链接。这比普通的链接、行内放置您的内容的不同。这允许用户在一个单独的部分，浏览所有的相关链接，有时会很有帮助。

	你能够找到一个站点的例子[^Demo]使用了PostCSS构建的脚注，或是你能够查看的[^Github Repo]从这个项目。
	
    #### Footnotes 
    [Demo]( http://iviewsource.com/exercises/postcsslayouts) 
    [Github Repo]( https://github.com/planetoftheweb/postcsslayouts) 

在Multi-Markdown中还有很多其他的交互链接方式，但是它们在规范之外几乎没有任何支持。包括[交叉引用和引文]( https://rawgit.com/fletcher/human-markdown-reference/master/index.html).很有可能个人解析器处理链接的方式就是你将要发掘的东西。


**Available with:** [Kramdown]( http://kramdown.gettalong.org/), [Markdown-it]( https://markdown-it.github.io/), [Maruku]( http://maruku.rubyforge.org/index.html), [Multi-Markdown]( http://fletcherpenney.net/multimarkdown/), [PHP Markdown Extended]( https://github.com/piwi/markdown-extended), [Python Markdown]( https://pythonhosted.org/Markdown/), [Redcarpet]( https://github.com/vmg/redcarpet), [Remarkable]( https://jonschlinkert.github.io/remarkable/demo/), [Showdown]( http://showdownjs.github.io/demo/) 

#### 任务列表

这是GFM的特性，并且已经被部分的实现。它增加了任务列表标记使您可以创建复选框旁边的内容来模拟一个任务列表清单。


    - [ ] 运行 `> npm-install` 安装项目依赖
    - [X] 安装 gulp.js 通过Mac的terminal或是PC上的Gitbash `> npm install -g gulp` 
    - [ ] 运行Gulp命令行`> gulp` 

**Available with:** [Github Flavored Markdown]( https://help.github.com/articles/github-flavored-markdown/), [Markdown-it]( https://markdown-it.github.io/), [Marked]( https://github.com/chjj/marked), [Python Markdown]( https://pythonhosted.org/Markdown/), [Redcarpet]( https://github.com/vmg/redcarpet),[Showdown]( http://showdownjs.github.io/demo/) 

#### 定义列表

虽然定义列表不为其他类型的列表为常见，这是一个伟大的方式编码在HTML中的某些类型的元素，有些实现创建了更简单的添加方式去添加这些。他们的定义有两种方式，根据不同的语言，用冒号（`：`）或符号（` ~ `），虽然冒号的实用更为常见。


    ES6/ES2015 
    :   流行JavaScript的新版本

    TypeScript 
      ~ TypeScript是一个能够转换为JavaScript的、工作在大多数浏览器上的

**Available with:** [Kramdown]( http://kramdown.gettalong.org/), [Markdown-it]( https://markdown-it.github.io/)*, [Maruku]( http://maruku.rubyforge.org/index.html), [Multi-Markdown]( http://fletcherpenney.net/multimarkdown/), [PHP Markdown Extended]( https://github.com/piwi/markdown-extended), [Python Markdown]( https://pythonhosted.org/Markdown/), [Remarkable]( https://jonschlinkert.github.io/remarkable/demo/) 

* 需要拓展



#### 数学 

对于一些用户创建数学公式是非常有用的，所以可以创建这些的语言已经在一些markdown的实现中出现，即Multi-Markdown。在其他语言的支持是可用的，有时通过扩展。


**Available with:** [Kramdown]( http://kramdown.gettalong.org/)*, [Maruku]( http://maruku.rubyforge.org/index.html), [Multi-Markdown]( http://fletcherpenney.net/multimarkdown/), [Markdown-it]( https://markdown-it.github.io/), [Python Markdown]( https://pythonhosted.org/Markdown/)* 

* 需要拓展 

### 哦 亲爱的 I/O

有一件事是你必须要小心的是如何处理不同版本的输入和输出。只是因为一个版本说它支持表，并不意味着定义表的标准方式。此外，一些版本将生成HTML，有些极其冗长，有些会很简。还有一大变化的东西，如白色空间处理。有些版本将在每个标题设置ID但其他一些不会。这已经是OpenMark之后关注点之一。最好辨识你选择的版本支持哪些方式的方法是使用[Babelmark 2 test]( http://johnmacfarlane.net/babelmark2/). 粘贴一些代码，它将会向你展示不同的解析器的输出作为预览

