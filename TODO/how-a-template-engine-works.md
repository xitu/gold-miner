> * 原文地址：[How a template engine works](https://fengsp.github.io/blog/2016/8/how-a-template-engine-works/)
* 原文作者：[Shipeng Feng](https://twitter.com/_fengsp)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： [Zheaoli](https://github.com/Zheaoli)
* 校对者：[Kulbear](https://github.com/Kulbear), [hpoenixf](https://github.com/hpoenixf)

# 详解 Python 模板引擎工作机制

我已经使用各种模版引擎很久了，现在终于有时间研究一下模版引擎到底是如何工作的了。

### 简介

简单的说，模版引擎是一种可以用来完成涉及大量文本数据的编程任务的工具。一般而言，我们经常在一个 **web** 应用中利用模板引擎来生成 **HTML** 。在 **Python** 中，当你想使用模板引擎的时候，你会发现你有不少的选择，比如 [jinja](http://jinja.pocoo.org/) 或者是 [mako](http://www.makotemplates.org/) 。从现在开始，我们将利用 [**tornado**](https://github.com/tornadoweb/tornado) 中的模板引擎来讲解模板引擎的工作原理，在 **tornado** 中，自带的模板引擎相对的简单，能方便我们去深入的剖析其原理。

在我们研究（模版引擎）的实现原理之前，先让我们来看一个简单的接口调用例子。

~~~Python
    from tornado import template

    PAGE_HTML = """
    <html>
      Hello, {{ username }}!
      <ul>
        {% for job in job_list %}
          <li>{{ job }}</li>
        {% end %}
      </ul>
    </html>
    """
    t = template.Template(PAGE_HTML)
    print t.generate(username='John', job_list=['engineer'])
~~~

这段代码里的 `username` 将会动态的生成，`job` 列表也是如此。你可以通过安装 `tornado` 并运行这段代码来看看最后的效果。

### 详解

如果你仔细观察 `PAGE_HTML` ，你会发现这段模板字符串由两个部分组成，一部分是固定的字符串，另一部分是将会动态生成的内容。我们将会用特殊的符号来标注动态生成的部分。在整个工作流程中，模板引擎需要正确输出固定的字符串，同时需要将正确的结果替换我们所标注的需要动态生成的字符串。

使用模板引擎最简单的方式就是像下面这样用一行 **python** 代码就可以解决：

~~~Python
    deftemplate_engine(template_string, **context):# process herereturn result_string

~~~

在整个工作过程中，模板引擎将会分为如下两个阶段对我们的字符串进行操作：

* 解析
* 渲染

在解析阶段，我们将我们准备好的字符串进行解析，然后格式化成可被渲染的格式，其可能是能被 `rendered.Consider` 所解析的字符串，解析器可能是一个语言的解释器或是一个语言的编译器。如果解析器是一种解释器的话，在解析过程中将会生成一种特殊的数据结构来存放数据，然后渲染器会遍历整个数据结构来进行渲染。例如 **Django** 的模板引擎中的解析器就是一种基于解释器的工具。除此之外，解析器可能会生成一些可执行代码，渲染器将只会执行这些代码，然后生成对应的结果。在 **Jinja2** ， **Mako** ，**Tornado** 中，模板引擎都在使用编译器来作为解析工具。
### 编译

如同上面所说的一样，我们需要解析我们所编写的模板字符串，然后 **tornado** 中的模板解析器将会将我们所编写的模板字符串编译成可执行的 **Python** 代码。我们的解析工具负责生成Python代码，而仅仅由单个Python函数构成：

~~~Python
    def parse_template(template_string):
      # compilation
      return python_source_code
~~~

在我们分析 `parse_template` 的代码之前，让我们先看个模板字符串的例子：

~~~html
    <html>
      Hello, {{ username }}!
      <ul>
        {% for job in jobs %}
          <li>{{ job.name }}</li>
        {% end %}
      </ul>
    </html>
~~~

模板引擎里的 `parse_template` 函数将会将上面这个字符串编译成 **Python** 源码，最简单的实现方式如下：

~~~Python
    def _execute():
        _buffer = []
        _buffer.append('\n<html>\n  Hello, ')
        _tmp = username
        _buffer.append(str(_tmp))
        _buffer.append('!\n  <ul>\n    ')
        for job in jobs:
            _buffer.append('\n      <li>')
            _tmp = job.name
            _buffer.append(str(_tmp))
            _buffer.append('</li>\n    ')
        _buffer.append('\n  </ul>\n</html>\n')
        return''.join(_buffer)
~~~

现在我们在 `_execute` 函数里处理我们的模版。这个函数将可以使用全局命名空间里的所有有效变量。这个函数将创建一个包含多个 **string** 的列表并将他们合并后返回。显然找到一个局部变量比找一个全局变量要快多了。同时，我们对于其余代码的优化也在这个阶段完成，比如：

~~~Python
    _buffer.append('hello')

    _append_buffer = _buffer.append
    # faster for repeated use
    _append_buffer('hello')
~~~

在 `{{ ... }}` 中的表达式将会被提取出来，然后添加进 `string` 列表中。在 `tornado` 模板模块中，在 `{{ ... }}` 所编写的表达式没有任何的限制，**if** 和 **for** 代码块都可以准确地转换成为 **Python** 代码。

### 让我们来看看具体的代码实现吧

让我们来看看模板引擎的具体实现吧。我们在 `Template` 类中编声明核心变量，当我们创建一个 `Template` 对象后，我们便可以编译我们所编写的模板字符串，随后我们便可以根据编译的结果来对其进行渲染。我们只需要对我们所编写的模板字符串进行一次编译，然后我们可以缓存我们的编译结果，下面是 `Template` 类的简化版本的构造器：

~~~Python
    class Template(object):
        def__init__(self, template_string):
            self.code = parse_template(template_string)
            self.compiled = compile(self.code, '<string>', 'exec')
~~~

上段代码里的 `compile` 函数将会将字符串编译成为可执行代码，我们可以稍后调用 `exec` 函数来执行我们生成的代码。现在，让我们来看看 `parse_template` 函数的实现，首先，我们需要将我们所编写的模板字符串转化成一个个独立的节点，为我们后面生成 **Python** 代码做好准备。在这过程中，我们需要一个 `_parse` 函数，我们先把它放在一边，等下在回来看看这个函数。现，我们需要编写一些辅助函数来帮助我们从模板文件里读取数据。现在让我们来看看 `_TemplateReader` 这个类，它用于从我们自定义的模板中读取数据：

~~~Python
    class _TemplateReader(object):
      def __init__(self, text):
          self.text = text
          self.pos = 0

      def find(self, needle, start=0, end=None):
          pos = self.pos
          start += pos
          if end is None:
              index = self.text.find(needle, start)
          else:
              end += pos
              index = self.text.find(needle, start, end)
          if index != -1:
              index -= pos
          return index

      def consume(self, count=None):
          if count is None:
              count = len(self.text) - self.pos
          newpos = self.pos + count
          s = self.text[self.pos:newpos]
          self.pos = newpos
          return s

      def remaining(self):
          return len(self.text) - self.pos

      def __len__(self):
          return self.remaining()

      def __getitem__(self, key):
          if key < 0:
              return self.text[key]
          else:
              return self.text[self.pos + key]

      def __str__(self):
          return self.text[self.pos:]
~~~

为了生成 **Python** 代码，我们需要去看看 `_CodeWriter` 这个类的源码，这个类可以编写代码行和管理缩进，同时它也是一个 **Python** 上下文管理器：

~~~Python
    class _CodeWriter(object):
      def __init__(self):
          self.buffer = cStringIO.StringIO()
          self._indent = 0

      def indent(self):
          return self

      def indent_size(self):
          return self._indent

      def __enter__(self):
          self._indent += 1
          return self

      def __exit__(self, *args):
          self._indent -= 1

      def write_line(self, line, indent=None):
          if indent == None:
              indent = self._indent
          for i in xrange(indent):
              self.buffer.write("    ")
          print self.buffer, line

      def __str__(self):
          return self.buffer.getvalue()
~~~

在 `parse_template` 函数里，我们先要创建一个 `_TemplateReader` 对象：

~~~Python
    def parse_template(template_string):
        reader = _TemplateReader(template_string)
        file_node = _File(_parse(reader))
        writer = _CodeWriter()
        file_node.generate(writer)
        return str(writer)
~~~

然后，我们将我们所创建的 `_TemplateReader` 对象传入 `_parse` 函数中以便生成节点列表。这里生成的所有节点都是模板文件的子节点。接着，我们创建一个 `_CodeWriter` 对象，然后 `file_node` 对象会把生成的 **Python** 代码写入 `_CodeWriter` 对象中。然后我们返回一系列动态生成的 **Python** 代码。`_Node` 类将会用一种特殊的方法去生成 **Python** 源码。这个先放着，我们等下再绕回来看。 现在先让我们回头看看前面所说的 `_parse` 函数：

~~~Python
    def _parse(reader, in_block=None):
      body = _ChunkList([])
      while True:
          # Find next template directive
          curly = 0
          while True:
              curly = reader.find("{", curly)
              if curly == -1 or curly + 1 == reader.remaining():
                  # EOF
                  if in_block:
                      raise ParseError("Missing {%% end %%} block for %s" %
                                       in_block)
                  body.chunks.append(_Text(reader.consume()))
                  return body
              # If the first curly brace is not the start of a special token,
              # start searching from the character after it
              if reader[curly + 1] not in ("{", "%"):
                  curly += 1
                  continue
              # When there are more than 2 curlies in a row, use the
              # innermost ones.  This is useful when generating languages
              # like latex where curlies are also meaningful
              if (curly + 2 < reader.remaining() and
                  reader[curly + 1] == '{' and reader[curly + 2] == '{'):
                  curly += 1
                  continue
              break
~~~

我们将在文件中无限循环下去来查找我们所规定的特殊标记符号。当我们到达文件的末尾处时，我们将文本节点添加至列表中然后退出循环。

~~~Python
    # Append any text before the special token
    if curly > 0:
      body.chunks.append(_Text(reader.consume(curly)))
~~~

在我们对特殊标记的代码块进行处理之前，我们先将静态的部分添加至节点列表中。

~~~Python
    start_brace = reader.consume(2)
~~~

在遇到 `{{` 或者 `{%` 的符号时，我们便开始着手处理相应的的表达式：

~~~Python
    # Expression
    if start_brace == "{{":
        end = reader.find("}}")
        if end == -1 or reader.find("\n", 0, end) != -1:
            raise ParseError("Missing end expression }}")
        contents = reader.consume(end).strip()
        reader.consume(2)
        if not contents:
            raise ParseError("Empty expression")
        body.chunks.append(_Expression(contents))
        continue
~~~

当遇到 `{{` 之时，便意味着后面会跟随一个表达式，我们只需要将表达式提取出来，并添加至 `_Expression` 节点列表中。

~~~Python
      # Block
      assert start_brace == "{%", start_brace
      end = reader.find("%}")
      if end == -1 or reader.find("\n", 0, end) != -1:
          raise ParseError("Missing end block %}")
      contents = reader.consume(end).strip()
      reader.consume(2)
      if not contents:
          raise ParseError("Empty block tag ({% %})")
      operator, space, suffix = contents.partition(" ")
      # End tag
      if operator == "end":
          if not in_block:
              raise ParseError("Extra {% end %} block")
          return body
      elif operator in ("try", "if", "for", "while"):
          # parse inner body recursively
          block_body = _parse(reader, operator)
          block = _ControlBlock(contents, block_body)
          body.chunks.append(block)
          continue
      else:
          raise ParseError("unknown operator: %r" % operator)
~~~

在遇到模板里的代码块的时候，我们需要通过递归的方式将代码块提取出来，并添加至 `_ControlBlock` 节点列表中。当遇到 `{% end %}` 时，意味着这个代码块的结束，这个时候我们可以跳出相对应的函数了。

好了现在，让我们看看之前所提到的 `_Node` 节点，别慌，这其实是很简单的：

~~~Python
    class _Node(object):
      def generate(self, writer):
          raise NotImplementedError()


    class _ChunkList(_Node):
      def __init__(self, chunks):
          self.chunks = chunks

      def generate(self, writer):
          for chunk in self.chunks:
              chunk.generate(writer)

`_ChunkList` 只是一个节点列表而已。

~~~Python
    class _File(_Node):
      def __init__(self, body):
          self.body = body

      def generate(self, writer):
          writer.write_line("def _execute():")
          with writer.indent():
              writer.write_line("_buffer = []")
              self.body.generate(writer)
              writer.write_line("return ''.join(_buffer)")
~~~

在 `_File` 中，它会将 `_execute` 函数写入 `CodeWriter`。

~~~Python
    class _Expression(_Node):
        def __init__(self, expression):
            self.expression = expression

        def generate(self, writer):
            writer.write_line("_tmp = %s" % self.expression)
            writer.write_line("_buffer.append(str(_tmp))")


    class _Text(_Node):
        def __init__(self, value):
            self.value = value

        def generate(self, writer):
            value = self.value
            if value:
                writer.write_line('_buffer.append(%r)' % value)
~~~

`_Text` 和 `_Expression` 节点的实现也非常简单，它们只是将我们从模板里获取的数据添加进列表中。

~~~Python
    class _ControlBlock(_Node):
        def __init__(self, statement, body=None):
            self.statement = statement
            self.body = body

        def generate(self, writer):
            writer.write_line("%s:" % self.statement)
            with writer.indent():
                self.body.generate(writer)
~~~

在 `_ControlBlock` 中，我们需要将我们获取的代码块按 **Python** 语法进行格式化。

现在让我们看看之前所提到的模板引擎的渲染部分，我们通过在 `Template` 对象中实现 `generate` 方法来调用从模板中解析出来的 `Python` 代码。

~~~Python
    def generate(self, **kwargs):
        namespace = {}
        namespace.update(kwargs)
        exec self.compiled in namespace
        execute = namespace["_execute"]
        return execute()
~~~

在给予的全局命名空间中， **exec** 函数将会执行编译过的代码对象。然后我们就可以在全局中调用 **_execute** 函数了。

### 最后

经过上面的一系列操作，我们便可以尽情的编译我们的模板并得到相对应的结果了。其实在 **tornado** 模板引擎中，还有很多特性是我们没有讨论到的，不过，我们已经了解了其最基础的工作机制，你可以在此基础上去研究你所感兴趣的部分，比如：

- 模板继承
- 模板包含
- 其余的一些逻辑控制语句，比如 `else` , `elfi` , `try` 等等
- 空白控制
- 特殊字符转译
- 更多没讲到的模板指令（译者注：请参考 **tornado** [官方文档](http://www.tornadoweb.org/en/stable/)
