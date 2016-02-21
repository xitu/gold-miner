* 原文链接 : [Choosing the Right Markdown Parser]( https://css-tricks.com/choosing-right-markdown-parser/) 
* 原文作者 : [CSS-TRICKS]( https://css-tricks.com) 
* 译文出自 : [掘金翻译计划]( https://github.com/xitu/gold-miner) 
* 译者 : [lfkdsk]( https://github.com/lfkdsk) 
* 校对者: 
* 状态 : 已认领  


_The following is a guest post by [Ray Villalobos]( http://www.raybo.org/). Ray is going to explore many of the different varietals of Markdown. All of them offer features beyond what the original Markdown can do, but they offer different features amongst themselves. If you're choosing a version to use (or a version you're offering to users on your web product), it pays to know what you are getting into, as it's difficult to switch once you've chosen and there is content out there that depends on those features. Ray, who has [a course on Markdown]( http://www.lynda.com/Web-Development-tutorials/Up-Running-Markdown/438888-2.html), is going to share which versions have which features to help you make an informed choice._ 

_以下客座文章由[Ray Villalobos]( http://www.raybo.org/)提供。在这篇文章中Ray将要去探索很多种不同的Markdown语法。所有的这些MarkDown语法均提供了不同的特性，都超越传统的Markdown语法，却又相互之间又各有不同。如果你正在挑选一门Markdown语言使用（或是提供给你的Web产品的用户使用），那你就值得的去了解它们，因为你的选择将会非常困难而且挑选的结果依赖于哪些特性。Ray提供的一门[关于MarkDown课程]( http://www.lynda.com/Web-Development-tutorials/Up-Running-Markdown/438888-2.html)将会分享这些不同的版本都拥有哪些特性去帮助你做出明智的选择。_ 


Markdown has changed the way professionals in many fields write. The language uses simple text with minimal markup and can convert it to a growing number of formats. However, not all markdown parsers are created equally. Because the original spec hasn't evolved with the times, alternate versions like Multi-Markdown, GFM (Github Flavored Markdown), Markdown Extra and others have expanded the language. 


Markdown改变了很多专业领域的书写方式。这种语言使用简单的文本和极少的标记并可以将其转换为越来越多的格式。然而不是所有的Markdown解析器是被等同的创造出来的。因为原来的规范没有与时俱进,替代版本像是 Multi-Markdown,GFM(Github Flavored Markdown),Markdown Extra和其他的版本扩充了这门语言。

The [original parser]( https://daringfireball.net/projects/markdown/) was written in Perl. The core features include parsing block elements (such as paragraphs, line breaks, headers, blockquotes, lists, code blocks and horizontal rules) and span elements (links, emphasis, code snippets and images). Since then, the language hasn't been expanded by its creator John Gruber, so a number of additions and implementations have surfaced with different parsers adding support for different implementations as they see fit, or interpreting how certain elements are parsed. 

[Markdown的原始解析器]( https://daringfireball.net/projects/markdown/)是由Perl编写的。核心的特性包括解析块元素（例如段落，换行，标头，块引用，列表，代码块和垂直线）和行内元素（链接，加重，代码段和图片）。从此以后，这个语言没有被它的创造者John Gruber扩充，所以很多的新增和实现伴随着不同的他们认为合适的、或是支持解释某些元素的解析器支持浮出水面。


<figure>![]( https://cdn.css-tricks.com/wp-content/uploads/2016/01/choose-markdown.jpg)</figure> 

### Choosing a version 

### 选择一个版本

There's a lot to consider when thinking about implementing Markdown into a project, including the language you'll be developing with as well as the features you want to support. The original implementation was written in Perl, but that's not a practical option for every project. There are implementations in most popular languages including: PHP, Ruby and JavaScript. Which language you choose will have repercussions as to which features you'll be able to support and what libraries will be available. Let's take a look at some of the options: 

实现Markdown功能在一个程序里需要考虑很多，包括你将要使用的开发语言和你想要支持的特性。原始的版本是由Perl编写的，但是这不是对于每一个项目实用的选择。最流行的实现版本包括：PHP, Ruby和JavaScript。你选择了哪种语言将会间接影响你能支持哪些特性和能使用哪些库。让我们来看看一些选择：

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

There are additional implementations in [many other languages](https://github.com/markdown/markdown.github.com/wiki/Implementations), just in case you're looking to implement Markdown in other languages. 

这里还有一些额外的支持使用了很多[其他的语言](https://github.com/markdown/markdown.github.com/wiki/Implementations),万一希望使用其他语言实现Markdown。

### Core features 

The core markdown language supports a number of default features that are quite useful. Although different implementations support a range of extended features, they should all support at least the following core syntax: [Inline HTML]( https://daringfireball.net/projects/markdown/syntax#html), [Automatic paragraphs]( https://daringfireball.net/projects/markdown/syntax#p), [headers]( https://daringfireball.net/projects/markdown/syntax#header), [blockquotes]( https://daringfireball.net/projects/markdown/syntax#blockquote), [lists]( https://daringfireball.net/projects/markdown/syntax#list), [code blocks]( https://daringfireball.net/projects/markdown/syntax#precode), [horizontal rules]( https://daringfireball.net/projects/markdown/syntax#hr), [links]( https://daringfireball.net/projects/markdown/syntax#link), [emphasis]( https://daringfireball.net/projects/markdown/syntax#em), [inline code]( https://daringfireball.net/projects/markdown/syntax#code) and [images]( https://daringfireball.net/projects/markdown/syntax#img). 


### 核心特性  

核心Markdown语言支持许多非常有用的默认功能。虽然不同的实现支持一系列的扩展功能，他们都应该至少支持以下核心语法：[Inline HTML]( https://daringfireball.net/projects/markdown/syntax#html), [Automatic paragraphs]( https://daringfireball.net/projects/markdown/syntax#p), [headers]( https://daringfireball.net/projects/markdown/syntax#header), [blockquotes]( https://daringfireball.net/projects/markdown/syntax#blockquote), [lists]( https://daringfireball.net/projects/markdown/syntax#list), [code blocks]( https://daringfireball.net/projects/markdown/syntax#precode), [horizontal rules]( https://daringfireball.net/projects/markdown/syntax#hr), [links]( https://daringfireball.net/projects/markdown/syntax#link), [emphasis]( https://daringfireball.net/projects/markdown/syntax#em), [inline code]( https://daringfireball.net/projects/markdown/syntax#code) 和 [images]( https://daringfireball.net/projects/markdown/syntax#img). 

### Noteworthy versions 


With the many versions of markdown available, a few have had a substantial impact on other versions. So much so that you'll often see them quoted as part of other versions. For example, libraries will mention support of CommonMark, GFM or Multi-Markdown. Let's take a look at what those mean. 

### 值得注意的版本

可用Markdown的很多版本，有几个已经对其它版本有很大的影响。正因如此，你会经常看到他们被其他版本引述作为其中的一部分。例如，库会提到支持CommonMark，GFM或是Multi-Markdown。让我们来看看那意味着什么。


#### GFM 

One of the reason Markdown became so popular with developers is because Github, the open source sharing platform accepted and extended the language with a version called [Github Flavored Markup]( https://help.github.com/articles/working-with-advanced-formatting/) (GFM) to include fenced codeblocks, URL Autolinking, Strikethrough, Tables and even the ability to create to-dos within repos. So, when a version mentions support of GFM, look for those extensions to be implemented. 

**Supports**: [Fenced Codeblocks], [Syntax Highlighting], [Tables], [URL AutoLinking], [Strikethrough] 

Github是使Markdown在开发者中流行的原因之一，开源共享平台接受并扩展了一个版本的语言叫[Github Flavored Markup]( https://help.github.com/articles/working-with-advanced-formatting/)（GFM）包括围栏代码块，URL自动链接，删除线，表格甚至能够创建带有勾选框的任务列表。所以，当一个版本支持提及的GFM，就是实现了这些扩展。

**Supports**: [Fenced Codeblocks], [Syntax Highlighting], [Tables], [URL AutoLinking], [Strikethrough] 


#### CommonMark 

Recently there has been a move to standardize markdown. A group of Markdown developers joined to create a version, tests and documentation for the language that resulted in a more robust specification for the language called [CommonMark]( http://commonmark.org/). At this time, the implementation added fenced codeblocks, but mostly detailed the specifics of how certain features were to be implemented for consistent output and conversion. A lot more extensions that would bring this more in line with what's available in other languages [have been proposed]( https://github.com/jgm/CommonMark/wiki/Proposed-Extensions) for the future. 

This format is relatively new and doesn't support a lot of features, but it is actively being developed and there are plans to add many Multi-Markdown features. 

**Supports**: [Fenced Codeblocks], [URL AutoLinking], [Strikethrough] 

最近有一个行动去规范Markdown语法。一组Markdown开发者加入去创建一个版本，测试和文档，最终的结果就是名为[CommonMark](http://commonmark.org/)的更强大的规范语言。此时，这个实现添加了围栏代码块，但是更多的是某些特征是如何获得一致的输出和转换要实现的具体细节。很多的拓展将会带来更加符合[其他语言](https://github.com/jgm/CommonMark/wiki/Proposed-Extensions)已经提出的特性.

这种格式是相对新的，不支持很多功能，但它正在积极开发并有计划地增加了许多Multi-Markdown的特点。

**Supports**: [Fenced Codeblocks], [URL AutoLinking], [Strikethrough] 


#### Multi-markdown 

The first serious projects that extended the language is Multi-Markdown. It added a number of features to the language that is supported by other versions. It was originally written in Perl, like Markdown, but then moved onto C. So, if you see that a project has Multi-Markdown support, then it probably has [most of these features]( https://rawgit.com/fletcher/human-markdown-reference/master/index.html). 

第一个拓展了这门语言的严肃项目是Multi-Markdown。它增加了许多功能，是由其它版本所支持的特性。它最初是用Perl编写，如Markdown，但随后又转而到C上.所以，如果你看到一个项目支持Multi-Markdown，那么它很可能具有[这些功能](https://rawgit.com/fletcher/human-markdown-reference/master/index.html)大部分。


### Optional Features 

Let's take a look at the features that are available through different implementations. 

### 可选择特性

让我们来看看这些可通过不同的实现的特性。


#### Fenced Codeblocks 

One of the best additions for developers is the ability to easily add code to your markdown. The original implementation automatically considered a block of text as code if it was indented by 4 spaces or a single tab. That's sometimes inconvenient, so several implementations incorporated fenced codeblocks by allowing you to place three tickmarks (`) or in some cases triple tilde (~) characters at the beginning of a block of text to mark it as code: 

#### 围栏代码块

其中一个最好的对于开发者的就是能够简单的添加代码在Markdown中。原始的实现对如以四个空格或是一个制表符开头的行自动将文本作为代码块。这在一些时候会产生错误，所以严肃的实现引入了围栏代码块通过允许你在将一块文本标记为代码时使用三个刻度标记（`），或在某些情况下三重符号（〜）字符：


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




#### Syntax Highlighting 

Adding code blocks is great but, by default, markdown interpreters will simply wrap the blocks inside `<code>` and `<pre></pre>` tags, which makes the text show up as pre-formatted text in a fixed width font. Some implementations can improve on this by allowing you to specify a language next to the tickmarks and may include a parser that automatically lets you choose different color styles and specify which language your code was written so that the colors are more meaningful. 

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

* Some of this support doesn't come embedded into the parser, but is dependent upon other libraries like [highlight.js]( https://highlightjs.org/). 

*有些支持不嵌入到解析器，而是依赖于其它的库如[highlight.js]（https://highlightjs.org/）。



#### Tables 

Writing tables in HTML can be cumbersome. Some versions of markdown can take care of this by letting you add tables with a fairly simple syntax. 

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

It takes a few minutes to get the hang of building tables like this, but after you do it a few times, you’ll think of using HTML a bit of a hassle. If you need help creating tables, check out this [Markdown Tables Generator]( http://www.tablesgenerator.com/markdown_tables). 

只需要几分钟就能够做出像这样的一个表格，但是在你做过几次后，你会认为使用HTML有一些麻烦。如果你需要帮助创建表格，阅读这篇指南[Markdown Tables Generator]( http://www.tablesgenerator.com/markdown_tables).


[![Markdown Tables Generator]( https://cdn.css-tricks.com/wp-content/uploads/2016/01/OiO5m2q.png)]( http://www.tablesgenerator.com/markdown_tables) 

**Available with:** [Github Flavored Markdown]( https://help.github.com/articles/github-flavored-markdown/), [Kramdown]( http://kramdown.gettalong.org/), [Markdown-it]( https://markdown-it.github.io/), [Marked]( https://github.com/chjj/marked), [Maruku]( http://maruku.rubyforge.org/index.html), [Multi-Markdown]( http://fletcherpenney.net/multimarkdown/), [PHP Markdown Extended]( https://github.com/piwi/markdown-extended), [Python Markdown]( https://pythonhosted.org/Markdown/), [Redcarpet]( https://github.com/vmg/redcarpet), [Remarkable]( https://jonschlinkert.github.io/remarkable/demo/), [Showdown]( http://showdownjs.github.io/demo/) 



#### Metadata 

Some extensions will let you add meta data that you can use to add information that your app can parse like perhaps choosing a template or setting the page title. Some use the [Multi-Markdown structure]( https://github.com/fletcher/MultiMarkdown/wiki/MultiMarkdown-Syntax-Guide#metadata) for this metadata, and others like the Jekyll parser use [YAML]( http://www.yaml.org/) as the format, which lets you express complex data within this metadata section. This can be a really useful handy feature for app developers.

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



#### URL Autolinking 

These fairly simple extensions allows URLs that naturally occur within your text to convert to links automatically via the parser. This is really convenient and is really useful in an implementation like GFM, where making URLs clickable without additional work makes for documentation that's easier to write. 

#### URL 自动链接
这些简单的扩展让你的文字中出现的URL通过分析器会自动转换为链接。这实在是方便，实用的例如GFM，使链接可点击而无需额外的工作使得文档更容易编写的实现。

**Available with:** [CommonMark]( http://commonmark.org/), [Github Flavored Markdown]( https://help.github.com/articles/github-flavored-markdown/), [Kramdown]( http://kramdown.gettalong.org/), [Markdown-it](   https://markdown-it.github.io/), [Marked]( https://github.com/chjj/marked), [Maruku]( http://maruku.rubyforge.org/index.html), [Multi-Markdown]( http://fletcherpenney.net/multimarkdown/), [PHP Markdown Extended]( https://github.com/piwi/markdown-extended), [Python Markdown]( https://pythonhosted.org/Markdown/), [Redcarpet]( https://github.com/vmg/redcarpet), [Remarkable]( https://jonschlinkert.github.io/remarkable/demo/), [Showdown]( http://showdownjs.github.io/demo/) 



#### Footnotes & Other Link types 

Footnotes allows you to create links within your document to references that are placed at the bottom of the markdown page. This is different than normal links, which are placed inline within your content. This allows users to view all of the related links within a document in a single section, which is nice sometimes. 

#### 脚注和其他链接类型

脚注允许你创建你的文档中到放置在Markdown页面底部引用链接。这比普通的链接、行内放置您的内容的不同。这允许用户在一个单独的部分，浏览所有的相关链接，有时会很有帮助。

    You can find a demo of a site[^Demo] built with PostCSS in our footnotes, or you can checkout the [^Github Repo] for the project. 
	
	你能够找到一个站点的例子[^Demo]使用了PostCSS构建的脚注，或是你能够查看的[^Github Repo]从这个项目。
	
    #### Footnotes 
    [Demo]( http://iviewsource.com/exercises/postcsslayouts) 
    [Github Repo]( https://github.com/planetoftheweb/postcsslayouts) 

There are a couple of other alternate link methods in Multi-Markdown, but they have virtually no support outside that specification. This includes [Cross References and Citations]( https://rawgit.com/fletcher/human-markdown-reference/master/index.html). Chances are, the way that the individual parsers handle links is something you’ll want to explore. 

在Multi-Markdown中还有很多其他的交互链接方式，但是它们在规范之外几乎没有任何支持。包括[交叉引用和引文]( https://rawgit.com/fletcher/human-markdown-reference/master/index.html).很有可能个人解析器处理链接的方式就是你将要发掘的东西。


**Available with:** [Kramdown]( http://kramdown.gettalong.org/), [Markdown-it]( https://markdown-it.github.io/), [Maruku]( http://maruku.rubyforge.org/index.html), [Multi-Markdown]( http://fletcherpenney.net/multimarkdown/), [PHP Markdown Extended]( https://github.com/piwi/markdown-extended), [Python Markdown]( https://pythonhosted.org/Markdown/), [Redcarpet]( https://github.com/vmg/redcarpet), [Remarkable]( https://jonschlinkert.github.io/remarkable/demo/), [Showdown]( http://showdownjs.github.io/demo/) 



#### To-dos 

This is a Github Flavored Markdown feature that has caught on in some implementations. It adds to-do list markup so that you can create checkboxes next to content to simulate a to do list. 

#### 任务列表

这是GFM的特性，并且已经被部分的实现。它增加了任务列表标记使您可以创建复选框旁边的内容来模拟一个任务列表清单。


    - [ ] 运行 `> npm-install` 安装项目依赖
    - [X] 安装 gulp.js 通过Mac的terminal或是PC上的Gitbash `> npm install -g gulp` 
    - [ ] 运行Gulp命令行`> gulp` 

**Available with:** [Github Flavored Markdown]( https://help.github.com/articles/github-flavored-markdown/), [Markdown-it]( https://markdown-it.github.io/), [Marked]( https://github.com/chjj/marked), [Python Markdown]( https://pythonhosted.org/Markdown/), [Redcarpet]( https://github.com/vmg/redcarpet),[Showdown]( http://showdownjs.github.io/demo/) 



#### Definition Lists 

Although definitions lists are not as common as other types of lists, it's a great way of coding certain types of elements in HTML, some implementations add a way to create these in a much simpler way. There are two ways of defining them, depending on the language, using a colon (`:`) or a tilde (`~`), although the implementation with the colons are more common. 

#### 定义列表

虽然定义列表不为其他类型的列表为常见，这是一个伟大的方式编码在HTML中的某些类型的元素，有些实现创建了更简单的添加方式去添加这些。他们的定义有两种方式，根据不同的语言，用冒号（`：`）或符号（` ~ `），虽然冒号的实用更为常见。


    ES6/ES2015 
    :   流行JavaScript的新版本

    TypeScript 
      ~ TypeScript是一个能够转换为JavaScript的、工作在大多数浏览器上的

**Available with:** [Kramdown]( http://kramdown.gettalong.org/), [Markdown-it]( https://markdown-it.github.io/)*, [Maruku]( http://maruku.rubyforge.org/index.html), [Multi-Markdown]( http://fletcherpenney.net/multimarkdown/), [PHP Markdown Extended]( https://github.com/piwi/markdown-extended), [Python Markdown]( https://pythonhosted.org/Markdown/), [Remarkable]( https://jonschlinkert.github.io/remarkable/demo/) 

* 需要拓展



#### 数学 

The ability to create mathematical formulas can be useful to some users so a language for creating them has appeared within some markdown implementations, namely Multi-Markdown. Support in other languages is available, sometimes through an extension. 

对于一些用户创建数学公式是非常有用的，所以可以创建这些的语言已经在一些markdown的实现中出现，即Multi-Markdown。在其他语言的支持是可用的，有时通过扩展。


**Available with:** [Kramdown]( http://kramdown.gettalong.org/)*, [Maruku]( http://maruku.rubyforge.org/index.html), [Multi-Markdown]( http://fletcherpenney.net/multimarkdown/), [Markdown-it]( https://markdown-it.github.io/), [Python Markdown]( https://pythonhosted.org/Markdown/)* 

* 需要拓展 



### Oh that sweet I/O 


### 哦 亲爱的 I/O

One thing that you have to be careful about is how different versions handle input and output. Just because a versions says it support tables, doesn't mean that there's a standard way of defining the tables. Furthermore, some versions will generate HTML that is extremely verbose and some will be very minimalist. There’s also wide variations of how things like white space are handled. Some versions will place IDs within each headline and some won’t. This has been one of the concerns behind the OpenMark. The best way to identify how the version you’ve chosen handles this is to use the [Babelmark 2 test]( http://johnmacfarlane.net/babelmark2/). Paste some code and it will show you how different parsers take care of the output as well as a preview. 

有一件事是你必须要小心的是如何处理不同版本的输入和输出。只是因为一个版本说它支持表，并不意味着定义表的标准方式。此外，一些版本将生成HTML，有些极其冗长，有些会很简。还有一大变化的东西，如白色空间处理。有些版本将在每个标题设置ID但其他一些不会。这已经是OpenMark之后关注点之一。最好辨识你选择的版本支持哪些方式的方法是使用[Babelmark 2 test]( http://johnmacfarlane.net/babelmark2/). 粘贴一些代码，它将会向你展示不同的解析器的输出作为预览

