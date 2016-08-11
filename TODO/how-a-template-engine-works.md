> * 原文地址：[How a template engine works](https://fengsp.github.io/blog/2016/8/how-a-template-engine-works/)
* 原文作者：[Shipeng Feng](https://twitter.com/_fengsp)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： 
* 校对者： 

I have used template engines for a long time and finally have some time to find
out how a template engine works.

### Introduction

Briefly, a template engine is a tool that you can use to do programming tasks
involving a lot of textual data.  The most common usage is HTML generation
in web applications.  Specifically in Python, we have a few options right now
if you want one template engine, like [jinja](http://jinja.pocoo.org/) or
[mako](http://www.makotemplates.org/).  Here we are going to find out how a template
engine works by digging in the template module of the tornado web framework, it is a
simple system so we can focus on the basic ideas of the process.

Before we go into the implementation detail, let's look at the simple API usage first:

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

Here the user's name will be dynamic in the page html, so are a list of jobs.  You
can install `tornado` and run the code to see the output.

### Implementation

If we look at the `PAGE_HTML` closely, we could easily find out that a template string
has two parts, the static literal text part and the dynamic part.  We use special
notation to distinguish the dynamic part.  In the whole, the template engine should
take the template string and output the static part as it is, it also needs to
handle the dynamic pieces with the given context and produce the right string result.
So basically a template engine is just one Python function:

    deftemplate_engine(template_string, **context):# process herereturn result_string

During the processing procedure, the template engine has two phases:

The parsing stage takes the template string and produces something that could be
rendered.  Consider the template string as source code, the parsing tool could be
either a programming language interpreter or a programming language compiler.  If
the tool is an interpreter, parsing produces a data structure, the rendering tool
will walk through the structure and produces the result text.  The Django template
engine parsing tool is an interpreter.  Otherwise, parsing produces some executable
code, the rendering tool does nothing but executes the code and produces the result.
The Jinja2, Mako and Tornado template module are all using a compiler as parsing tool.

### Compiling

As said above, we now need to parse the template string, and the parsing tool in
tornado template module compiles templates to Python code.  Our parsing tool is
simply one Python function that does Python code generation:

    defparse_template(template_string):# compilationreturn python_source_code

Before we get to the implementation of `parse_template`, let's see the code it
produces, here is an example template source string:

    <html>
      Hello, {{ username }}!
      <ul>{% for job in jobs %}<li>{{ job.name }}</li>{% end %}</ul></html>

Our `parse_template` function will compile this template to Python code, which is
just one function, the simplified version is:

    def_execute():
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

Now our template is parsed into a function called `_execute`, this function access
all context variables from global namespace.  This function creates a list of strings
and join them together as the result string.  The `username` is put in a local name
`_tmp`, looking up a local name is much faster than looking up a global.  There are
other optimizations that can be done here, like:

    _buffer.append('hello')
    
    _append_buffer = _buffer.append
    # faster for repeated use
    _append_buffer('hello')

Expressions in `{{ ... }}` are evaluated and appended to the string buffer list.
In the tornado template module, there is no restrictions on the expressions you can
include in your statements, if and for blocks get translated exactly into Python.

### The Code

Let's see the real implementation now.  The core interface that we are using is the
`Template` class, when we create one `Template` object, we compile the template string
and later we can use it to render a given context.  We only need to compile once and
you can cache the template object anywhere, the simplified version of constructor:

    classTemplate(object):def__init__(self, template_string):
            self.code = parse_template(template_string)
            self.compiled = compile(self.code, '<string>', 'exec')

The `compile` will compile the *source* into a code object.  We can execute it
later with an `exec` statement.  Now let's build the `parse_template` function,
firstly we need to parse our template string into a list of nodes that knows
how to generate Python code, we need a function called `_parse`, we will see the
function later, we need some helpers now, to help with reading through the template
file, we have the `_TemplateReader` class, which handles the reading for us as we
consume the template file.  We need to start from the begining and keep going ahead
to find some special notations, the `_TemplateReader` will keep the current position
and give us ways to do it:

    class_TemplateReader(object):def__init__(self, text):
            self.text = text
            self.pos = 0deffind(self, needle, start=0, end=None):
            pos = self.pos
            start += pos
            if end isNone:
                index = self.text.find(needle, start)
            else:
                end += pos
                index = self.text.find(needle, start, end)
            if index != -1:
                index -= pos
            return index
    
        defconsume(self, count=None):if count isNone:
                count = len(self.text) - self.pos
            newpos = self.pos + count
            s = self.text[self.pos:newpos]
            self.pos = newpos
            return s
    
        defremaining(self):return len(self.text) - self.pos
    
        def__len__(self):return self.remaining()
    
        def__getitem__(self, key):if key < 0:
                return self.text[key]
            else:
                return self.text[self.pos + key]
    
        def__str__(self):return self.text[self.pos:]

To help with generating the Python code, we need the `_CodeWriter` class, this class
writes lines of codes and manages indentation, also it is one Python context manager:

    class_CodeWriter(object):def__init__(self):
            self.buffer = cStringIO.StringIO()
            self._indent = 0defindent(self):return self
    
        defindent_size(self):return self._indent
    
        def__enter__(self):
            self._indent += 1return self
    
        def__exit__(self, *args):
            self._indent -= 1defwrite_line(self, line, indent=None):if indent == None:
                indent = self._indent
            for i in xrange(indent):
                self.buffer.write("    ")
            print self.buffer, line
    
        def__str__(self):return self.buffer.getvalue()

In the begining of the `parse_template`, we create one template reader first:

    defparse_template(template_string):
        reader = _TemplateReader(template_string)
        file_node = _File(_parse(reader))
        writer = _CodeWriter()
        file_node.generate(writer)
        return str(writer)

Then we pass the reader to the `_parse` function and produces a list of nodes.
All of there nodes are the child nodes of the template file node.  We create
one CodeWriter object, the file node writes Python code into the CodeWriter,
and we return the generated Python code.  The `_Node` class would handle the Python
code generation for a specific case, we will see it later.  Now let's go back to our
`_parse` function:

    def_parse(reader, in_block=None):
        body = _ChunkList([])
        whileTrue:
            # Find next template directive
            curly = 0whileTrue:
                curly = reader.find("{", curly)
                if curly == -1or curly + 1 == reader.remaining():
                    # EOFif in_block:
                        raise ParseError("Missing {%% end %%} block for %s" %
                                         in_block)
                    body.chunks.append(_Text(reader.consume()))
                    return body
                # If the first curly brace is not the start of a special token,# start searching from the character after itif reader[curly + 1] notin ("{", "%"):
                    curly += 1continue# When there are more than 2 curlies in a row, use the# innermost ones.  This is useful when generating languages# like latex where curlies are also meaningfulif (curly + 2 < reader.remaining() and
                    reader[curly + 1] == '{'and reader[curly + 2] == '{'):
                    curly += 1continuebreak

We loop forever to find a template directive in the remaining file, if we reach
the end of the file, we append the text node and exit, otherwise, we have found
one template directive.

    # Append any text before the special tokenif curly > 0:
                body.chunks.append(_Text(reader.consume(curly)))

Before we handle the special token, we append the text node if there is static part.

    start_brace = reader.consume(2)

Get our start brace, if should be `'{{'` or `'{%'`.

    # Expressionif start_brace == "{{":
                end = reader.find("}}")
                ifend == -1or reader.find("\n", 0, end) != -1:
                    raise ParseError("Missing end expression }}")
                contents = reader.consume(end).strip()
                reader.consume(2)
                ifnotcontents:
                    raise ParseError("Empty expression")
                body.chunks.append(_Expression(contents))
                continue

The start brace is `'{{'` and we have an expression here, just get the contents
of the expression and append one `_Expression` node.

    # Blockassert start_brace == "{%", start_brace
            end = reader.find("%}")
            if end == -1or reader.find("\n", 0, end) != -1:
                raise ParseError("Missing end block %}")
            contents = reader.consume(end).strip()
            reader.consume(2)
            ifnot contents:
                raise ParseError("Empty block tag ({% %})")
            operator, space, suffix = contents.partition(" ")
            # End tagif operator == "end":
                ifnot in_block:
                    raise ParseError("Extra {% end %} block")
                return body
            elif operator in ("try", "if", "for", "while"):
                # parse inner body recursively
                block_body = _parse(reader, operator)
                block = _ControlBlock(contents, block_body)
                body.chunks.append(block)
                continueelse:
                raise ParseError("unknown operator: %r" % operator)

We have a block here, normally we would get the block body recursively and append
a `_ControlBlock` node, the block body should be a list of nodes.  If we encounter
an `{% end %}`, the block ends and we exit the function.

It is time to find out the secrets of `_Node` class, it is quite simple:

    class_Node(object):defgenerate(self, writer):raise NotImplementedError()

    class_ChunkList(_Node):def__init__(self, chunks):
            self.chunks = chunks
    
        defgenerate(self, writer):for chunk in self.chunks:
                chunk.generate(writer)

A `_ChunkList` is just a list of nodes.

    class_File(_Node):def__init__(self, body):
            self.body = body
    
        defgenerate(self, writer):
            writer.write_line("def _execute():")
            with writer.indent():
                writer.write_line("_buffer = []")
                self.body.generate(writer)
                writer.write_line("return ''.join(_buffer)")

A `_File` node write the `_execute` function to the CodeWriter.

    class_Expression(_Node):def__init__(self, expression):
            self.expression = expression
    
        defgenerate(self, writer):
            writer.write_line("_tmp = %s" % self.expression)
            writer.write_line("_buffer.append(str(_tmp))")
    
    
    class_Text(_Node):def__init__(self, value):
            self.value = value
    
        defgenerate(self, writer):
            value = self.value
            if value:
                writer.write_line('_buffer.append(%r)' % value)

The `_Text` and `_Expression` node are also really simple, just append what you
get from the template source.

    class_ControlBlock(_Node):def__init__(self, statement, body=None):
            self.statement = statement
            self.body = body
    
        defgenerate(self, writer):
            writer.write_line("%s:" % self.statement)
            with writer.indent():
                self.body.generate(writer)

For a `_ControlBlock` node, we need to indent and write our child node list with
the indentation.

Now let's get back to the rendering part, we render a context by using the `generate`
method of `Template` object, the `generate` function just call the compiled Python
code:

    defgenerate(self, **kwargs):
        namespace = {}
        namespace.update(kwargs)
        exec self.compiled in namespace
        execute = namespace["_execute"]
        return execute()

The `exec` function executes the compiled code object in the given global namespace,
then we grab our `_execute` function from the global namespace and call it.

### Next

So that's all, compile the template to Python function and execute it to get result.
The tornado template module has more features than we've discussed here, but we
already know well about the basic idea, you can find out more if you are interested:

- Template inheritance
- Template inclusion
- More control logic like else, elif, try, etc
- Whitespace controls
- Escaping
- More template directives

tags:[tornado](https://fengsp.github.io/blog/2016/8/how-a-template-engine-works/)[template](https://fengsp.github.io/blog/2016/8/how-a-template-engine-works/)[python](https://fengsp.github.io/blog/2016/8/how-a-template-engine-works/)
