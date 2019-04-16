
> * 原文地址：[What’s New In Python 3.7](https://docs.python.org/3.7/whatsnew/3.7.html)
> * 原文作者：[https://docs.python.org/](https://docs.python.org/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/new-in-python-3.7.md](https://github.com/xitu/gold-miner/blob/master/TODO/new-in-python-3.7.md)
> * 译者：[winjeysong](https://github.com/winjeysong)
> * 校对者：[LynnShaw](https://github.com/LynnShaw)

# Python 3.7 新特性
- 版本：3.7.0a1
- 日期：2017年9月27日

本文阐述了Python 3.7所具有的新特性（与3.6版本对比）。

详见[更新日志](https://docs.python.org/3.7/whatsnew/changelog.html#changelog)。

**注意：** 预发布版本的用户要留意，本文档目前还属于草案。随着Python 3.7的发布，后续将会有很显著的更新，所以即使阅读过早期版本，也值得再回来看看。

## 版本亮点总结
### 新特性

#### PEP 538：遗留的C语言本地化编码自动强制转换问题

在 Python 3 系列版本中，确定一个合理的默认策略来处理当前位于非 Windows 平台上默认C语言本地化编码隐式采用的“7位 ASCII”，是个永不停歇的挑战。

[**PEP 538**](https://www.python.org/dev/peps/pep-0538) 更新了默认的解释器命令行界面，从而能自动地将本地化编码强制转换为一种可用的且基于 UTF-8的编码，它就是文档里所描述的新环境变量 [`PYTHONCOERCECLOCALE`](https://docs.python.org/3.7/using/cmdline.html#envvar-PYTHONCOERCECLOCALE)。用这种方式自动设置 `LC_CTYPE` 意味着核心解释器和关于本地化识别的C语言扩展（如 [`readline`](https://docs.python.org/3.7/library/readline.html#module-readline)）将会采用 UTF-8 作为默认的文本编码，而不是 ASCII。

[**PEP 11**](https://www.python.org/dev/peps/pep-0011) 中有关平台支持的定义也已经更新，限制了对于全文处理的支持，变为适当的基于非 ASCII 的本地化编码配置。

作为变化的一部分，当使用任一强制转换的已定义目标编码（当前为 `C.UTF-8`，`C.utf8` 和 `UTF-8`），`stdin` 及 `stdout` 的默认错误处理器现在为 `surrogateescape`（而不是 `strict`）；而 `stderr` 的默认错误处理器仍然是 `backslashreplace`，与语言环境无关。

默认的本地化编码强制转换是隐式的，但是为了能帮助调试潜在的与本地化相关的集成问题，可以通过设置 `PYTHONCOERCECLOCALE=warn` 来请求直接用 `stderr` 发出明确的警告。当核心解释器初始化时，如果遗留的C语言本地化编码仍是活动状态，那么该设置会导致 Python 运行时发出警告。

**另见：**

<dl class="last docutils">

[**PEP 538**](https://www.python.org/dev/peps/pep-0538) —— 把遗留的C语言本地化编码强制转换为基于 UTF-8 的编码。

PEP 由 Nick Coghlan 撰写及实施。

### 其他的语言更新

* 现在传递给某个函数的参数（ *argument* ）可以超过255个，且一个函数的形参（ *parameter* ）可以超过255个。(由 Serhiy Storchaka 参与贡献的 [bpo-12844](https://bugs.python.org/issue12844) 和 [bpo-18896](https://bugs.python.org/issue18896)。)
* [`bytes.fromhex()`](https://docs.python.org/3.7/library/stdtypes.html#bytes.fromhex) 及 [`bytearray.fromhex()`](https://docs.python.org/3.7/library/stdtypes.html#bytearray.fromhex) 现在将忽略所有的 ASCII 空白符，而不止空格。(由 Robert Xiao 参与贡献的 [bpo-28927](https://bugs.python.org/issue28927)。)
* 现在当 `from ... import ...` 失败的时候，[`ImportError`](https://docs.python.org/3.7/library/exceptions.html#ImportError) 会展示模块名及模块 `__file__` 路径。(由 Matthias Bussonnier 参与贡献的 [bpo-29546](https://bugs.python.org/issue29546)。)
* 现在已支持将包含绝对 imports 的循环 imports 通过名称绑定到一个子模块上。(由 Serhiy Storchaka 参与贡献的 [bpo-30024](https://bugs.python.org/issue30024)。)
* 现在，`object.__format__(x,'')` 等价于 `str(x)` ，而不是 `format(str(self),'')`。(由 Serhiy Storchaka 参与贡献的 [bpo-28974](https://bugs.python.org/issue28974)。)

## 新模块

* 暂无。

### 改进的模块

#### argparse

在大多数的 unix 命令中，[`parse_intermixed_args()`](https://docs.python.org/3.7/library/argparse.html#argparse.ArgumentParser.parse_intermixed_args) 能让用户在命令行里混用选项和位置参数，它支持大部分而非全部的 argparse 功能。(由 paul.j3 参与贡献的 [bpo-14191](https://bugs.python.org/issue14191)。)

#### binascii

[`b2a_uu()`](https://docs.python.org/3.7/library/binascii.html#binascii.b2a_uu) 函数现在能接受一个可选的 _backtick_ 关键字参数，当它的值为 true 时，所有的“0”都将被替换为 ``'`'`` 而非空格。(由 Xiang Zhang 参与贡献的 [bpo-30103](https://bugs.python.org/issue30103)。)

#### calendar

[`HTMLCalendar`](https://docs.python.org/3.7/library/calendar.html#calendar.HTMLCalendar)类具有新的类属性，它能在生成的 HTML 日历中很方便地自定义 CSS 类。(由 Oz Tiram 参与贡献的 [bpo-30095](https://bugs.python.org/issue30095)。)

#### cgi

[`parse_multipart()`](../library/cgi.html#cgi.parse_multipart "cgi.parse_multipart") 作为 `FieldStorage` 会返回同样的结果：对于非文件字段，与键相关联的值是一个字符串列表，而非字节。(由 Pierre Quentel 参与贡献的 [bpo-29979](https://bugs.python.org/issue29979)。)

#### contextlib

已添加 [`contextlib.asynccontextmanager()`](https://docs.python.org/3.7/library/contextlib.html#contextlib.asynccontextmanager)。(由 Jelle Zijlstra 参与贡献的 [bpo-29679](https://bugs.python.org/issue29679)。)

#### dis

[`dis()`](https://docs.python.org/3.7/library/dis.html#dis.dis) 函数现在可以反汇编嵌套代码对象（代码解析，生成器表达式和嵌套函数，以及用于构建嵌套类的代码）。(由 Serhiy Storchaka 参与贡献的 [bpo-11822](https://bugs.python.org/issue11822)。)

#### distutils

README.rst 现已包含在 distutils 的标准自述文件列表中，进而它也分别包含在各源码中。(由 Ryan Gonzalez 参与贡献的 [bpo-11913](https://bugs.python.org/issue11913)。)

#### http.server

[`SimpleHTTPRequestHandler`](https://docs.python.org/3.7/library/http.server.html#http.server.SimpleHTTPRequestHandler) 支持 HTTP If-Modified-Since 头文件。如果在头文件指定的时间之后，目标文件未被修改，则服务器返回 304 响应状态码。 (由 Pierre Quentel 参与贡献的 [bpo-29654](https://bugs.python.org/issue29654)。)

在 [`SimpleHTTPRequestHandler`](https://docs.python.org/3.7/library/http.server.html#http.server.SimpleHTTPRequestHandler) 中添加 `directory` 参数，在命令行的 [`server`](https://docs.python.org/3.7/library/http.server.html#module-http.server) 模块中添加 `--directory`。有了这个参数，服务器将会运行在指定目录下，默认使用当前工作目录。(由 Stéphane Wirtel and Julien Palard 参与贡献的 [bpo-28707](https://bugs.python.org/issue28707)。)

#### locale

在 [`locale`](https://docs.python.org/3.7/library/locale.html#module-locale) 模块的 `format_string()` 方法中添加了另一个参数 _monetary_ 。如果 _monetary_ 的值为 true，会转换为使用货币千位分隔符和分组字符串。(由 Garvit 参与贡献的 [bpo-10379](https://bugs.python.org/issue10379)。)

#### math 

新的 [`remainder()`](https://docs.python.org/3.7/library/math.html#math.remainder) 函数实现了 IEEE 754-style 的取余操作。(由 Mark Dickinson 参与贡献的 [bpo-29962](https://bugs.python.org/issue29962)。)

#### os

增加了对 [`fwalk()`](https://docs.python.org/3.7/library/os.html#os.fwalk) 中 [`bytes`](https://docs.python.org/3.7/library/stdtypes.html#bytes) 路径的支持。(由 Serhiy Storchaka 参与贡献的 [bpo-28682](https://bugs.python.org/issue28682)。)
 (Contributed by Serhiy Storchaka in [bpo-28682](https://bugs.python.org/issue28682).)

在Unix平台上，增加了对 [`scandir()`](https://docs.python.org/3.7/library/os.html#os.scandir) 中 [file descriptors](https://docs.python.org/3.7/library/os.html#path-fd) 的支持。(由 Serhiy Storchaka 参与贡献的 [bpo-25996](https://bugs.python.org/issue25996)。)

新的 [`os.register_at_fork()`](https://docs.python.org/3.7/library/os.html#os.register_at_fork) 函数允许注册 Python 的回调在进程的分支上执行。(由 Antoine Pitrou 参与贡献的 [bpo-16500](https://bugs.python.org/issue16500)。)

#### pdb

[`set_trace()`](https://docs.python.org/3.7/library/pdb.html#pdb.set_trace) 现在需要一个可选的 `header` 强制关键字参数。如果已给出，它将会在调试开始前打印至控制台。

#### string

[`string.Template`](https://docs.python.org/3.7/library/string.html#string.Template) 现在可以分别为花括号占位符和非花括号占位符选择性地修改正则表达式模式。(由 Barry Warsaw 参与贡献的 [bpo-1198569](https://bugs.python.org/issue1198569)。)

#### unittest.mock

[`sentinel`](https://docs.python.org/3.7/library/unittest.mock.html#unittest.mock.sentinel) 属性现在会保留自己的同一性，当它们被 [`copied`](https://docs.python.org/3.7/library/copy.html#module-copy) 或 [`pickled`](https://docs.python.org/3.7/library/pickle.html#module-pickle) 时。(由 Serhiy Storchaka 参与贡献的 [bpo-20804](https://bugs.python.org/issue20804)。)

#### xmlrpc.server
`xmlrpc.server.SimpleXMLRPCDispatcher` 的 `register_function()` 及其子类能被用作装饰器。(由 Xiang Zhang 参与贡献的 [bpo-7769](https://bugs.python.org/issue7769)。)

#### unicodedata

内部的 [`unicodedata`](https://docs.python.org/3.7/library/unicodedata.html#module-unicodedata) 数据库已升级，能够使用 [Unicode 10](http://www.unicode.org/versions/Unicode10.0.0/)。 (由 Benjamin Peterson 参与贡献。)

#### urllib.parse

[`urllib.parse.quote()`](https://docs.python.org/3.7/library/urllib.parse.html#urllib.parse.quote) 已经从 RFC 2396 升级至 RFC 3986，将 `~` 添加到默认情况下从不引用的字符集中。(由 Christian Theune 和 Ratnadeep Debnath 参与贡献的 [bpo-16285](https://bugs.python.org/issue16285)。)

#### uu

函数 [`encode()`](https://docs.python.org/3.7/library/uu.html#uu.encode) 现在能接受一个可选的关键字参数 _backtick_ ，当它的值为 true 时，“0”会被 ``'`'`` 替代而非空格。(由 Xiang Zhang 参与贡献的 [bpo-30103](https://bugs.python.org/issue30103)。)

#### zipapp

函数 `zipapp.create_archive()` 现在能接受一个可选的参数 **filter**，来允许用户选择哪些文件应该被包含在存档中。

### 优化

* 添加了两个新的操作码：`LOAD_METHOD` 及 `CALL_METHOD`，从而避免为了方法调用的绑定方法对象的实例化，这将导致方法调用的速度提升20%。(由 Yury Selivanov 及 INADA Naoki 参与贡献的 [bpo-26110](https://bugs.python.org/issue26110)。)
* 当在一字符串内查找某些特殊的 Unicode 字符（如乌克兰大写字母 “Є”）时，将会比查找其他字符慢25倍，但现在最差情况下也只慢了3倍。(由 Serhiy Storchaka 参与贡献的 [bpo-24821](https://bugs.python.org/issue24821)。)
* 标准C语言库的快速执行现在能用于 [`math`](https://docs.python.org/3.7/library/math.html#module-math) 模块内的 [`erf()`](https://docs.python.org/3.7/library/math.html#math.erf) 和 [`erfc()`](https://docs.python.org/3.7/library/math.html#math.erfc) 函数。(由 Serhiy Storchaka 参与贡献的 [bpo-26121](https://bugs.python.org/issue26121)。)
* 由于使用了 [`os.scandir()`](https://docs.python.org/3.7/library/os.html#os.scandir) 函数，[`os.fwalk()`](https://docs.python.org/3.7/library/os.html#os.fwalk) 函数的效率已经提升了2倍。 (由 Serhiy Storchaka 参与贡献的 [bpo-25996](https://bugs.python.org/issue25996)。)
* 优化了对于大小写忽略的匹配及对于 [`regular expressions`](https://docs.python.org/3.7/library/re.html#module-re) 的查找。 对一些字符的查找速度现在能提升至原来的20倍。(由 Serhiy Storchaka 参与贡献的 [bpo-30285](https://bugs.python.org/issue30285)。)
* 在较重负荷下，`selectors.EpollSelector.modify()`，`selectors.PollSelector.modify()` 及 `selectors.DevpollSelector.modify()` 将比原来快10%左右。(由 Giampaolo Rodola’ 参与贡献的 [bpo-30014](https://bugs.python.org/issue30014)。)

## 编译生成及C语言API的更改

* 在非OSX、UNIX平台上，当构建 [`_ctypes`](https://docs.python.org/3.7/library/ctypes.html#module-ctypes) 模块时不会再打包 libffi 的完整副本以使用。现在在这些平台上构建 ` _ctypes` 时需要已安装的 libffi 副本。(由 Zachary Ware 参与贡献的 [bpo-27979](https://bugs.python.org/issue27979)。)
* 结构 [`PyMemberDef`](https://docs.python.org/3.7/c-api/structures.html#c.PyMemberDef)，[`PyGetSetDef`](https://docs.python.org/3.7/c-api/structures.html#c.PyGetSetDef)，[`PyStructSequence_Field`](https://docs.python.org/3.7/c-api/tuple.html#c.PyStructSequence_Field)，[`PyStructSequence_Desc`](https://docs.python.org/3.7/c-api/tuple.html#c.PyStructSequence_Desc) 及 `wrapperbase` 的 `name` 和 `doc` 字段的类型现在为 `const char *` 而非 `char *`。(由 Serhiy Storchaka 参与参与贡献的 [bpo-28761](https://bugs.python.org/issue28761)。)
* [`PyUnicode_AsUTF8AndSize()`](https://docs.python.org/3.7/c-api/unicode.html#c.PyUnicode_AsUTF8AndSize) 及 [`PyUnicode_AsUTF8()`](https://docs.python.org/3.7/c-api/unicode.html#c.PyUnicode_AsUTF8) 返回的类型是 `const char *` 而非 `char *`。(由 Serhiy Storchaka 参与贡献的 [bpo-28769](https://bugs.python.org/issue28769)。)
* 新增了函数 [`PySlice_Unpack()`](https://docs.python.org/3.7/c-api/slice.html#c.PySlice_Unpack) 和 [`PySlice_AdjustIndices()`](https://docs.python.org/3.7/c-api/slice.html#c.PySlice_AdjustIndices)。 (由 Serhiy Storchaka 参与贡献的 [bpo-27867](https://bugs.python.org/issue27867)。)
* 已弃用 [`PyOS_AfterFork()`](https://docs.python.org/3.7/c-api/sys.html#c.PyOS_AfterFork)，支持使用新函数 [`PyOS_BeforeFork()`](https://docs.python.org/3.7/c-api/sys.html#c.PyOS_BeforeFork)，[`PyOS_AfterFork_Parent()`](https://docs.python.org/3.7/c-api/sys.html#c.PyOS_AfterFork_Parent) 及 [`PyOS_AfterFork_Child()`](https://docs.python.org/3.7/c-api/sys.html#c.PyOS_AfterFork_Child)。 (由 by Antoine Pitrou 参与贡献的 [bpo-16500](https://bugs.python.org/issue16500)。)
* Windows 构建进程不再依赖 Subversion 来 pull 外部资源，而是通过使用 Python 脚本从 Github 下载 zip 文件。如果系统未安装 Python 3.6（通过命令 `py -3.6`），将会使用 NuGet 来下载 32位的 Python 副本。(由 Zachary Ware 参与贡献的 [bpo-30450](https://bugs.python.org/issue30450)。)
* 移除了对于构建 `--without-threads` 的支持。(由 Antoine Pitrou 参与贡献的 [bpo-31370](https://bugs.python.org/issue31370)。)

## 其他 CPython 实现的更改

* 在被追踪的框架上，通过将新的 `f_trace_lines` 属性设置为 [`False`](https://docs.python.org/3.7/library/constants.html#False)，追踪钩子现在可以选择不接收来自解释器的 `line` 事件。(由 Nick Coghlan 参与贡献的 [bpo-31344](https://bugs.python.org/issue31344)。)
* 在被追踪的框架上，通过将新的 `f_trace_opcodes` 属性设置为 [`True`](https://docs.python.org/3.7/library/constants.html#True)，追踪钩子现在可以选择接收来自解释器的 `opcode` 事件。(由 Nick Coghlan 参与贡献的 [bpo-31344](https://bugs.python.org/issue31344)。)

## 弃用的内容

* 如果未设置 `Py_LIMITED_API` ，或其被设置为从 `0x03050400` 到 `0x03060000` （不含）的值或不小于 `0x03060100` 的值，将弃用函数 [`PySlice_GetIndicesEx()`](https://docs.python.org/3.7/c-api/slice.html#c.PySlice_GetIndicesEx) 并用宏将其替代。(由 Serhiy Storchaka 参与贡献的 [bpo-27867](https://bugs.python.org/issue27867)。)
* 用 `format_string()` 来替代 [`locale`](https://docs.python.org/3.7/library/locale.html#module-locale) 模块中被弃用的 [`format()`](https://docs.python.org/3.7/library/functions.html#format)。(由 Garvit 参与贡献的 [bpo-10379](https://bugs.python.org/issue10379)。)
* 方法 [`MetaPathFinder.find_module()`](https://docs.python.org/3.7/library/importlib.html#importlib.abc.MetaPathFinder.find_spec)（由  [`MetaPathFinder.find_spec()`](https://docs.python.org/3.7/library/importlib.html#importlib.abc.PathEntryFinder.find_loader) 替代）和方法 [`PathEntryFinder.find_loader()`](https://docs.python.org/3.7/library/importlib.html#importlib.abc.MetaPathFinder.find_spec)（由  [`PathEntryFinder.find_spec()`](https://docs.python.org/3.7/library/importlib.html#importlib.abc.PathEntryFinder.find_spec) 替代）都已在 Python 3.4 被弃用，且现在会发出 [`DeprecationWarning`](https://docs.python.org/3.7/library/exceptions.html#DeprecationWarning)的警告。(由 Matthias Bussonnier 参与贡献的 [bpo-29576](https://bugs.python.org/issue29576)。)
* 在 [`gettext`](https://docs.python.org/3.7/library/gettext.html#module-gettext) 中通过使用非整型值来筛选复数形式的值已被弃用，它不会再起作用。(由 Serhiy Storchaka 参与贡献的 [bpo-28692](https://bugs.python.org/issue28692)。)
* [`macpath`](https://docs.python.org/3.7/library/macpath.html#module-macpath) 模块已被弃用，且它将会在 Python 3.8 版本中被移除。

### C语言API的更改

* `PyThread_start_new_thread()` 和 `PyThread_get_thread_ident()` 返回结果的类型, 及 [`PyThreadState_SetAsyncExc()`](https://docs.python.org/3.7/c-api/init.html#c.PyThreadState_SetAsyncExc) 中参数 *id* 的类型从 `long` 变为 `unsigned long`。(由 Serhiy Storchaka 参与贡献的 [bpo-6532](https://bugs.python.org/issue6532)。)
* 如果 [`PyUnicode_AsWideCharString()`](https://docs.python.org/3.7/c-api/unicode.html#c.PyUnicode_AsWideCharString) 的第二个实参是 _NULL_ 且 `wchar_t*` 字符串包含空字符，就会引起一个 [`ValueError`](https://docs.python.org/3.7/library/exceptions.html#ValueError) 的报错。(由 Serhiy Storchaka 参与贡献的 [bpo-30708](https://bugs.python.org/issue30708)。)

### 仅Windows平台

* Python 启动器（py.exe）能接收32及64位说明符，且无需指定次要版本。所以 `py -3-32` 与 `py -3-64` 也会和 `py -3.7-32` 一样有效，并且现在能接受 -*m*-64 与 -*m.n*-64 来强制使用64位 Python，即使32位在使用中也是如此。如果指定版本不可用，py.exe将会报错退出。(由 Steve Barnes 参与贡献的 [bpo-30291](https://bugs.python.org/issue30291)。)
* 启动器可以通过命令 “py -0” 运行，生成已安装 Python 的版本列表，*标有星号的是为默认*，运行 “py -0p” 将包含安装路径。如果 py 使用无法匹配的版本说明符运行，也会打印*缩略形式*的可用说明符列表。(由 Steve Barnes 参与贡献的 [bpo-30362](https://bugs.python.org/issue30362)。)

## 移除的内容

### 移除的API及特性

* 在使用 [`re.sub()`](https://docs.python.org/3.7/library/re.html#re.sub) 的替换模板中，由 `'\'` 及一个 ASCII 字母组成的未知转义符已在 Python 3.5 中被弃用，现在使用将会报错。
* 移除了 [`tarfile.TarFile.add()`](https://docs.python.org/3.7/library/tarfile.html#tarfile.TarFile.add) 中的实参 _exclude_ 。它已在 Python 2.7 和 3.2 版本被弃用，取而代之的是使用实参 *filter*。
* `ntpath` 模块中的 `splitunc()` 函数在 Python 3.1 被弃用，现在已被移除。使用 [`splitdrive()`](https://docs.python.org/3.7/library/os.path.html#os.path.splitdrive) 函数来替代。
* [`collections.namedtuple()`](https://docs.python.org/3.7/library/collections.html#collections.namedtuple) 不再支持 *verbose* 参数和 `_source` 属性，该属性用于显示为已命名元组类所生成的源码。这是用来提升类创建速度的优化设计的一部分。(由 Jelle Zijlstra 贡献并由 INADA Naoki，Serhiy Storchaka，和 Raymond Hettinger 进一步完善的 [bpo-28638](https://bugs.python.org/issue28638)。)
* 函数 [`bool()`](https://docs.python.org/3.7/library/functions.html#bool)，[`float()`](https://docs.python.org/3.7/library/functions.html#float)，[`list()`](https://docs.python.org/3.7/library/stdtypes.html#list) 和 [`tuple()`](https://docs.python.org/3.7/library/stdtypes.html#tuple) 不再使用关键字参数。[`int()`](https://docs.python.org/3.7/library/functions.html#int) 的第一个参数现在只能作为位置参数传递。
* 移除了先前在 Python 2.4 版本已被弃用的在 [`plistlib`](https://docs.python.org/3.7/library/plistlib.html#module-plistlib) 模块中的类 `Plist`，`Dict` 和 `_InternalDict`。函数 [`readPlist()`](https://docs.python.org/3.7/library/plistlib.html#plistlib.readPlist) 和 [`readPlistFromBytes()`](https://docs.python.org/3.7/library/plistlib.html#plistlib.readPlistFromBytes) 返回结果中的 dict 类型值现在就是标准的 dict 类型。你再也不能使用属性访问来访问到这些字典里的项。

## 移植到 Python 3.7

本小节列出了之前描述的一些更改，以及一些其他bug修复，因而你可能需要对你的代码进行更改。

### Python API的更改

* 如果 *path* 是一个字符串，[`pkgutil.walk_packages()`](https://docs.python.org/3.7/library/pkgutil.html#pkgutil.walk_packages) 现在会引起 ValueError 报错，之前会返回一个空列表。(由 Sanyam Khurana 参与贡献的 [bpo-24744](https://bugs.python.org/issue24744)。)
* [`string.Formatter.format()`](https://docs.python.org/3.7/library/string.html#string.Formatter.format) 的格式化字符串参数现在是 [positional-only](https://docs.python.org/3.7/glossary.html#positional-only-parameter)，将它作为关键字参数传递已在 Python 3.5 时被弃用。(由 Serhiy Storchaka 参与贡献的 [bpo-29193](https://bugs.python.org/issue29193)。)
* [`http.cookies.Morsel`](https://docs.python.org/3.7/library/http.cookies.html#http.cookies.Morsel) 类的属性 [`key`](https://docs.python.org/3.7/library/http.cookies.html#http.cookies.Morsel.key)，[`value`](https://docs.python.org/3.7/library/http.cookies.html#http.cookies.Morsel.value) 和 [`coded_value`](https://docs.python.org/3.7/library/http.cookies.html#http.cookies.Morsel.coded_value) 现在是只读的，将值分配给它们已经在 Python 3.5 中被弃用了，需要使用 [`set()`](https://docs.python.org/3.7/library/http.cookies.html#http.cookies.Morsel.set) 方法对它们进行设置。(由 Serhiy Storchaka 参与贡献的 [bpo-29192](https://bugs.python.org/issue29192)。)
* `Module`，`FunctionDef`，`AsyncFunctionDef` 及 `ClassDef` AST 节点现在新增了一个 `docstring` 字段，它们自身的首次声明不再被当做是一个 docstring。类和模块的代码对象 `co_firstlineno` 及 `co_lnotab` 会因这个更改而受到影响。(由 INADA Naoki and Eugene Toder 参与贡献的 [bpo-29463](https://bugs.python.org/issue29463)。)
* [`os.makedirs()`](https://docs.python.org/3.7/library/os.html#os.makedirs) 的参数 *mode* 不再影响新建的中级目录的文件权限位，要想设置它们的文件权限位，你可以在调用 `makedirs()` 之前设置 umask。(由 Serhiy Storchaka 参与贡献的 [bpo-19930](https://bugs.python.org/issue19930)。)
* 现在 [`struct.Struct.format`](https://docs.python.org/3.7/library/struct.html#struct.Struct.format) 的类型是 [`str`](https://docs.python.org/3.7/library/stdtypes.html#str) 而非 [`bytes`](https://docs.python.org/3.7/library/stdtypes.html#bytes)。(由 Victor Stinner 参与贡献的 [bpo-21071](https://bugs.python.org/issue21071)。)
* 由于 [`socket`](https://docs.python.org/3.7/library/socket.html#module-socket) 模块的内部更改，你将无法在旧版本 Python 中通过 [`socket.fromshare()`](https://docs.python.org/3.7/library/socket.html#socket.fromshare) 创建一个 [`share()`](https://docs.python.org/3.7/library/socket.html#socket.socket.share)-ed（共享的）接口。
* [`datetime.timedelta`](https://docs.python.org/3.7/library/datetime.html#datetime.timedelta) 的 `repr` 已变为在输出中包含关键字参数。(由 Utkarsh Upadhyay 参与贡献的 [bpo-30302](https://bugs.python.org/issue30302)。)

### CPython 字节码的更改

* 增加了两个新的操作码：[`LOAD_METHOD`](https://docs.python.org/3.7/library/dis.html#opcode-LOAD_METHOD) 和 [`CALL_METHOD`](https://docs.python.org/3.7/library/dis.html#opcode-CALL_METHOD)。(由 Yury Selivanov 和 INADA Naoki 参与贡献的 [bpo-26110](https://bugs.python.org/issue26110)。)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
