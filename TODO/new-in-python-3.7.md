
> * 原文地址：[What’s New In Python 3.7](https://docs.python.org/3.7/whatsnew/3.7.html)
> * 原文作者：[https://docs.python.org/](https://docs.python.org/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/new-in-python-3.7.md](https://github.com/xitu/gold-miner/blob/master/TODO/new-in-python-3.7.md)
> * 译者：
> * 校对者：

# What’s New In Python 3.7

- Release: 3.7.0a1
- Date: September 27, 2017

This article explains the new features in Python 3.7, compared to 3.6.

For full details, see the [changelog](https://docs.python.org/3.7/whatsnew/changelog.html#changelog).

**Note:** Prerelease users should be aware that this document is currently in draft form. It will be updated substantially as Python 3.7 moves towards release, so it’s worth checking back even after reading earlier versions.

## Summary – Release highlights

### New Features

#### PEP 538: Legacy C Locale Coercion

An ongoing challenge within the Python 3 series has been determining a sensible default strategy for handling the “7-bit ASCII” text encoding assumption currently implied by the use of the default C locale on non-Windows platforms.

[**PEP 538**](https://www.python.org/dev/peps/pep-0538) updates the default interpreter command line interface to automatically coerce that locale to an available UTF-8 based locale as described in the documentation of the new [`PYTHONCOERCECLOCALE`](https://docs.python.org/3.7/using/cmdline.html#envvar-PYTHONCOERCECLOCALE) environment variable. Automatically setting `LC_CTYPE` this way means that both the core interpreter and locale-aware C extensions (such as [`readline`](https://docs.python.org/3.7/library/readline.html#module-readline)) will assume the use of UTF-8 as the default text encoding, rather than ASCII.

The platform support definition in [**PEP 11**](https://www.python.org/dev/peps/pep-0011) has also been updated to limit full text handling support to suitably configured non-ASCII based locales.

As part of this change, the default error handler for `stdin` and `stdout` is now `surrogateescape` (rather than `strict`) when using any of the defined coercion target locales (currently `C.UTF-8`, `C.utf8`, and `UTF-8`). The default error handler for `stderr` continues to be `backslashreplace`, regardless of locale.

Locale coercion is silent by default, but to assist in debugging potentially locale related integration problems, explicit warnings (emitted directly on `stderr` can be requested by setting `PYTHONCOERCECLOCALE=warn`. This setting will also cause the Python runtime to emit a warning if the legacy C locale remains active when the core interpreter is initialized.

**See also:**

<dl class="last docutils">

[**PEP 538**](https://www.python.org/dev/peps/pep-0538) – Coercing the legacy C locale to a UTF-8 based locale.

PEP written and implemented by Nick Coghlan.

### Other Language Changes

* More than 255 arguments can now be passed to a function, and a function can now have more than 255 parameters. (Contributed by Serhiy Storchaka in [bpo-12844](https://bugs.python.org/issue12844) and [bpo-18896](https://bugs.python.org/issue18896).)
* [`bytes.fromhex()`](https://docs.python.org/3.7/library/stdtypes.html#bytes.fromhex) and [`bytearray.fromhex()`](https://docs.python.org/3.7/library/stdtypes.html#bytearray.fromhex) now ignore all ASCII whitespace, not only spaces. (Contributed by Robert Xiao in [bpo-28927](https://bugs.python.org/issue28927).)
* [`ImportError`](https://docs.python.org/3.7/library/exceptions.html#ImportError) now displays module name and module `__file__` path when `from ... import ...` fails. (Contributed by Matthias Bussonnier in [bpo-29546](https://bugs.python.org/issue29546).)
* Circular imports involving absolute imports with binding a submodule to a name are now supported. (Contributed by Serhiy Storchaka in [bpo-30024](https://bugs.python.org/issue30024).)
* `object.__format__(x,'')` is now equivalent to `str(x)` rather than `format(str(self),'')`. (Contributed by Serhiy Storchaka in [bpo-28974](https://bugs.python.org/issue28974).)

## New Modules

* None yet.

### Improved Modules

#### argparse

The [`parse_intermixed_args()`](https://docs.python.org/3.7/library/argparse.html#argparse.ArgumentParser.parse_intermixed_args) supports letting the user intermix options and positional arguments on the command line, as is possible in many unix commands. It supports most but not all argparse features. (Contributed by paul.j3 in [bpo-14191](https://bugs.python.org/issue14191).)

#### binascii

The [`b2a_uu()`](https://docs.python.org/3.7/library/binascii.html#binascii.b2a_uu) function now accepts an optional _backtick_ keyword argument. When it’s true, zeros are represented by `'`'` instead of spaces. (Contributed by Xiang Zhang in [bpo-30103](https://bugs.python.org/issue30103).)

#### calendar

The class [`HTMLCalendar`](https://docs.python.org/3.7/library/calendar.html#calendar.HTMLCalendar) has new class attributes which ease the customisation of the CSS classes in the produced HTML calendar. (Contributed by Oz Tiram in [bpo-30095](https://bugs.python.org/issue30095).)

#### cgi

[`parse_multipart()`](../library/cgi.html#cgi.parse_multipart "cgi.parse_multipart") returns the same results as `<span class="pre">FieldStorage</span>` : for non-file fields, the value associated to a key is a list of strings, not bytes. (Contributed by Pierre Quentel in [bpo-29979](https://bugs.python.org/issue29979).)

#### contextlib

[`contextlib.asynccontextmanager()`](https://docs.python.org/3.7/library/contextlib.html#contextlib.asynccontextmanager) has been added. (Contributed by Jelle Zijlstra in [bpo-29679](https://bugs.python.org/issue29679).)

#### dis

The [`dis()`](https://docs.python.org/3.7/library/dis.html#dis.dis) function now is able to disassemble nested code objects (the code of comprehensions, generator expressions and nested functions, and the code used for building nested classes). (Contributed by Serhiy Storchaka in [bpo-11822](https://bugs.python.org/issue11822).)

#### distutils

README.rst is now included in the list of distutils standard READMEs and therefore included in source distributions. (Contributed by Ryan Gonzalez in [bpo-11913](https://bugs.python.org/issue11913).)

#### http.server

[`SimpleHTTPRequestHandler`](https://docs.python.org/3.7/library/http.server.html#http.server.SimpleHTTPRequestHandler) supports the HTTP If-Modified-Since header. The server returns the 304 response status if the target file was not modified after the time specified in the header. (Contributed by Pierre Quentel in [bpo-29654](https://bugs.python.org/issue29654).)

Add the parameter `directory` to the [`SimpleHTTPRequestHandler`](https://docs.python.org/3.7/library/http.server.html#http.server.SimpleHTTPRequestHandler) and the `--directory` to the command line of the module [`server`](https://docs.python.org/3.7/library/http.server.html#module-http.server). With this parameter, the server serves the specified directory, by default it uses the current working directory. (Contributed by Stéphane Wirtel and Julien Palard in [bpo-28707](https://bugs.python.org/issue28707).)

#### locale

Added another argument _monetary_ in `format_string()` of [`locale`](https://docs.python.org/3.7/library/locale.html#module-locale). If _monetary_ is true, the conversion uses monetary thousands separator and grouping strings. (Contributed by Garvit in [bpo-10379](https://bugs.python.org/issue10379).)

#### math

New [`remainder()`](https://docs.python.org/3.7/library/math.html#math.remainder) function, implementing the IEEE 754-style remainder operation. (Contributed by Mark Dickinson in [bpo-29962](https://bugs.python.org/issue29962).)

#### os

Added support for [`bytes`](https://docs.python.org/3.7/library/stdtypes.html#bytes) paths in [`fwalk()`](https://docs.python.org/3.7/library/os.html#os.fwalk). (Contributed by Serhiy Storchaka in [bpo-28682](https://bugs.python.org/issue28682).)

Added support for [file descriptors](https://docs.python.org/3.7/library/os.html#path-fd) in [`scandir()`](https://docs.python.org/3.7/library/os.html#os.scandir) on Unix. (Contributed by Serhiy Storchaka in [bpo-25996](https://bugs.python.org/issue25996).)

New function [`os.register_at_fork()`](https://docs.python.org/3.7/library/os.html#os.register_at_fork) allows registering Python callbacks to be executed on a process fork. (Contributed by Antoine Pitrou in [bpo-16500](https://bugs.python.org/issue16500).)

#### pdb

[`set_trace()`](https://docs.python.org/3.7/library/pdb.html#pdb.set_trace) now takes an optional `header` keyword-only argument. If given, this is printed to the console just before debugging begins.

#### string

[`string.Template`](https://docs.python.org/3.7/library/string.html#string.Template) now lets you to optionally modify the regular expression pattern for braced placeholders and non-braced placeholders separately. (Contributed by Barry Warsaw in [bpo-1198569](https://bugs.python.org/issue1198569).)

#### unittest.mock

The [`sentinel`](https://docs.python.org/3.7/library/unittest.mock.html#unittest.mock.sentinel) attributes now preserve their identity when they are [`copied`](https://docs.python.org/3.7/library/copy.html#module-copy) or [`pickled`](https://docs.python.org/3.7/library/pickle.html#module-pickle). (Contributed by Serhiy Storchaka in [bpo-20804](https://bugs.python.org/issue20804).)

#### xmlrpc.server

`register_function()` of `xmlrpc.server.SimpleXMLRPCDispatcher` and its subclasses can be used as a decorator. (Contributed by Xiang Zhang in [bpo-7769](https://bugs.python.org/issue7769).)

#### unicodedata

The internal [`unicodedata`](https://docs.python.org/3.7/library/unicodedata.html#module-unicodedata) database has been upgraded to use [Unicode 10](http://www.unicode.org/versions/Unicode10.0.0/). (Contributed by Benjamin Peterson.)

#### urllib.parse

[`urllib.parse.quote()`](https://docs.python.org/3.7/library/urllib.parse.html#urllib.parse.quote) has been updated from RFC 2396 to RFC 3986, adding `~` to the set of characters that is never quoted by default. (Contributed by Christian Theune and Ratnadeep Debnath in [bpo-16285](https://bugs.python.org/issue16285).)

#### uu

Function [`encode()`](https://docs.python.org/3.7/library/uu.html#uu.encode) now accepts an optional _backtick_ keyword argument. When it’s true, zeros are represented by `'`'` instead of spaces. (Contributed by Xiang Zhang in [bpo-30103](https://bugs.python.org/issue30103).)

#### zipapp

Function `zipapp.create_archive()` now accepts an optional **filter** argument, to allow the user to select which files should be included in the archive.

### Optimizations

* Added two new opcodes: `LOAD_METHOD` and `CALL_METHOD` to avoid instantiation of bound method objects for method calls, which results in method calls being faster up to 20%. (Contributed by Yury Selivanov and INADA Naoki in [bpo-26110](https://bugs.python.org/issue26110).)
* Searching some unlucky Unicode characters (like Ukrainian capital “Є”) in a string was to 25 times slower than searching other characters. Now it is slower only by 3 times in worst case. (Contributed by Serhiy Storchaka in [bpo-24821](https://bugs.python.org/issue24821).)
* Fast implementation from standard C library is now used for functions [`erf()`](https://docs.python.org/3.7/library/math.html#math.erf) and [`erfc()`](https://docs.python.org/3.7/library/math.html#math.erfc) in the [`math`](https://docs.python.org/3.7/library/math.html#module-math) module. (Contributed by Serhiy Storchaka in [bpo-26121](https://bugs.python.org/issue26121).)
* The [`os.fwalk()`](https://docs.python.org/3.7/library/os.html#os.fwalk) function has been sped up by 2 times. This was done using the [`os.scandir()`](https://docs.python.org/3.7/library/os.html#os.scandir) function. (Contributed by Serhiy Storchaka in [bpo-25996](https://bugs.python.org/issue25996).)
* Optimized case-insensitive matching and searching of [`regular expressions`](https://docs.python.org/3.7/library/re.html#module-re). Searching some patterns can now be up to 20 times faster. (Contributed by Serhiy Storchaka in [bpo-30285](https://bugs.python.org/issue30285).)
* `selectors.EpollSelector.modify()`, `selectors.PollSelector.modify()` and `selectors.DevpollSelector.modify()` may be around 10% faster under heavy loads. (Contributed by Giampaolo Rodola’ in [bpo-30014](https://bugs.python.org/issue30014))

## Build and C API Changes

* A full copy of libffi is no longer bundled for use when building the [`_ctypes`](https://docs.python.org/3.7/library/ctypes.html#module-ctypes) module on non-OSX UNIX platforms. An installed copy of libffi is now required when building `<span class="pre">_ctypes</span>` on such platforms. Contributed by Zachary Ware in [bpo-27979](https://bugs.python.org/issue27979).
* The fields `name` and `doc` of structures [`PyMemberDef`](https://docs.python.org/3.7/c-api/structures.html#c.PyMemberDef), [`PyGetSetDef`](https://docs.python.org/3.7/c-api/structures.html#c.PyGetSetDef), [`PyStructSequence_Field`](https://docs.python.org/3.7/c-api/tuple.html#c.PyStructSequence_Field), [`PyStructSequence_Desc`](https://docs.python.org/3.7/c-api/tuple.html#c.PyStructSequence_Desc), and `wrapperbase` are now of type `const char *` rather of `char *`. (Contributed by Serhiy Storchaka in [bpo-28761](https://bugs.python.org/issue28761).)
* The result of [`PyUnicode_AsUTF8AndSize()`](https://docs.python.org/3.7/c-api/unicode.html#c.PyUnicode_AsUTF8AndSize) and [`PyUnicode_AsUTF8()`](https://docs.python.org/3.7/c-api/unicode.html#c.PyUnicode_AsUTF8) is now of type `const char *` rather of `char *`. (Contributed by Serhiy Storchaka in [bpo-28769](https://bugs.python.org/issue28769).)
* Added functions [`PySlice_Unpack()`](https://docs.python.org/3.7/c-api/slice.html#c.PySlice_Unpack) and [`PySlice_AdjustIndices()`](https://docs.python.org/3.7/c-api/slice.html#c.PySlice_AdjustIndices). (Contributed by Serhiy Storchaka in [bpo-27867](https://bugs.python.org/issue27867).)
* [`PyOS_AfterFork()`](https://docs.python.org/3.7/c-api/sys.html#c.PyOS_AfterFork) is deprecated in favour of the new functions [`PyOS_BeforeFork()`](https://docs.python.org/3.7/c-api/sys.html#c.PyOS_BeforeFork), [`PyOS_AfterFork_Parent()`](https://docs.python.org/3.7/c-api/sys.html#c.PyOS_AfterFork_Parent) and [`PyOS_AfterFork_Child()`](https://docs.python.org/3.7/c-api/sys.html#c.PyOS_AfterFork_Child). (Contributed by Antoine Pitrou in [bpo-16500](https://bugs.python.org/issue16500).)
* The Windows build process no longer depends on Subversion to pull in external sources, a Python script is used to download zipfiles from GitHub instead. If Python 3.6 is not found on the system (via `py -3.6`), NuGet is used to download a copy of 32-bit Python for this purpose. (Contributed by Zachary Ware in [bpo-30450](https://bugs.python.org/issue30450).)
* Support for building `--without-threads` is removed. (Contributed by Antoine Pitrou in [bpo-31370](https://bugs.python.org/issue31370).).

## Other CPython Implementation Changes

* Trace hooks may now opt out of receiving `line` events from the interpreter by setting the new `f_trace_lines` attribute to [`False`](https://docs.python.org/3.7/library/constants.html#False) on the frame being traced. (Contributed by Nick Coghlan in [bpo-31344](https://bugs.python.org/issue31344).)
* Trace hooks may now opt in to receiving `opcode` events from the interpreter by setting the new `f_trace_opcodes` attribute to [`True`](https://docs.python.org/3.7/library/constants.html#True) on the frame being traced. (Contributed by Nick Coghlan in [bpo-31344](https://bugs.python.org/issue31344).)

## Deprecated

* Function [`PySlice_GetIndicesEx()`](https://docs.python.org/3.7/c-api/slice.html#c.PySlice_GetIndicesEx) is deprecated and replaced with a macro if `Py_LIMITED_API` is not set or set to the value between `0x03050400` and `0x03060000` (not including) or `0x03060100` or higher. (Contributed by Serhiy Storchaka in [bpo-27867](https://bugs.python.org/issue27867).)
* Deprecated [`format()`](https://docs.python.org/3.7/library/functions.html#format) from [`locale`](https://docs.python.org/3.7/library/locale.html#module-locale), use the `format_string()` instead. (Contributed by Garvit in [bpo-10379](https://bugs.python.org/issue10379).)
* Methods [`MetaPathFinder.find_module()`](https://docs.python.org/3.7/library/importlib.html#importlib.abc.MetaPathFinder.find_spec) (replaced by [`MetaPathFinder.find_spec`()](https://docs.python.org/3.7/library/importlib.html#importlib.abc.PathEntryFinder.find_loader) ) and [`PathEntryFinder.find_loader()`](https://docs.python.org/3.7/library/importlib.html#importlib.abc.MetaPathFinder.find_spec)) (replaced by [`PathEntryFinder.find_spec()`](https://docs.python.org/3.7/library/importlib.html#importlib.abc.PathEntryFinder.find_spec)) both deprecated in Python 3.4 now emit [`DeprecationWarning`](https://docs.python.org/3.7/library/exceptions.html#DeprecationWarning). (Contributed by Matthias Bussonnier in [bpo-29576](https://bugs.python.org/issue29576))
* Using non-integer value for selecting a plural form in [`gettext`](https://docs.python.org/3.7/library/gettext.html#module-gettext) is now deprecated. It never correctly worked. (Contributed by Serhiy Storchaka in [bpo-28692](https://bugs.python.org/issue28692).)
* The [`macpath`](https://docs.python.org/3.7/library/macpath.html#module-macpath) is now deprecated and will be removed in Python 3.8.

### Changes in the C API

* The type of results of `PyThread_start_new_thread()` and `PyThread_get_thread_ident()`, and the *id* parameter of [`PyThreadState_SetAsyncExc()`](https://docs.python.org/3.7/c-api/init.html#c.PyThreadState_SetAsyncExc) changed from `long` to `unsigned long`. (Contributed by Serhiy Storchaka in [bpo-6532](https://bugs.python.org/issue6532).)
* [`PyUnicode_AsWideCharString()`](https://docs.python.org/3.7/c-api/unicode.html#c.PyUnicode_AsWideCharString) now raises a [`ValueError`](https://docs.python.org/3.7/library/exceptions.html#ValueError) if the second argument is _NULL_ and the `wchar_t*` string contains null characters. (Contributed by Serhiy Storchaka in [bpo-30708](https://bugs.python.org/issue30708).)

### Windows Only

* The python launcher, (py.exe), can accept 32 & 64 bit specifiers **without** having to specify a minor version as well. So `py -3-32` and `py -3-64` become valid as well as `py -3.7-32`, also the -*m*-64 and -*m.n*-64 forms are now accepted to force 64 bit python even if 32 bit would have otherwise been used. If the specified version is not available py.exe will error exit. (Contributed by Steve Barnes in [bpo-30291](https://bugs.python.org/issue30291).)
* The launcher can be run as “py -0” to produce a list of the installed pythons, *with default marked with an asterix*. Running “py -0p” will include the paths. If py is run with a version specifier that cannot be matched it will also print the *short form* list of available specifiers. (Contributed by Steve Barnes in [bpo-30362](https://bugs.python.org/issue30362).)

## Removed

### API and Feature Removals

* Unknown escapes consisting of `'\'` and an ASCII letter in replacement templates for [`re.sub()`](https://docs.python.org/3.7/library/re.html#re.sub) were deprecated in Python 3.5, and will now cause an error.
* Removed support of the _exclude_ argument in [`tarfile.TarFile.add()`](https://docs.python.org/3.7/library/tarfile.html#tarfile.TarFile.add). It was deprecated in Python 2.7 and 3.2\. Use the *filter* argument instead.
* The `splitunc()` function in the `ntpath` module was deprecated in Python 3.1, and has now been removed. Use the [`splitdrive()`](https://docs.python.org/3.7/library/os.path.html#os.path.splitdrive) function instead.
* [`collections.namedtuple()`](https://docs.python.org/3.7/library/collections.html#collections.namedtuple) no longer supports the *verbose* parameter or `_source` attribute which showed the generated source code for the named tuple class. This was part of an optimization designed to speed-up class creation. (Contributed by Jelle Zijlstra with further improvements by INADA Naoki, Serhiy Storchaka, and Raymond Hettinger in [bpo-28638](https://bugs.python.org/issue28638).)
* Functions [`bool()`](https://docs.python.org/3.7/library/functions.html#bool), [`float()`](https://docs.python.org/3.7/library/functions.html#float), [`list()`](https://docs.python.org/3.7/library/stdtypes.html#list) and [`tuple()`](https://docs.python.org/3.7/library/stdtypes.html#tuple) no longer take keyword arguments. The first argument of [`int()`](https://docs.python.org/3.7/library/functions.html#int) can now be passed only as positional argument.
* Removed previously deprecated in Python 2.4 classes `Plist`, `Dict` and `_InternalDict` in the [`plistlib`](https://docs.python.org/3.7/library/plistlib.html#module-plistlib) module. Dict values in the result of functions [`readPlist()`](https://docs.python.org/3.7/library/plistlib.html#plistlib.readPlist) and [`readPlistFromBytes()`](https://docs.python.org/3.7/library/plistlib.html#plistlib.readPlistFromBytes) are now normal dicts. You no longer can use attribute access to access items of these dictionaries.

## Porting to Python 3.7

This section lists previously described changes and other bugfixes that may require changes to your code.

### Changes in the Python API

* [`pkgutil.walk_packages()`](https://docs.python.org/3.7/library/pkgutil.html#pkgutil.walk_packages) now raises ValueError if *path* is a string. Previously an empty list was returned. (Contributed by Sanyam Khurana in [bpo-24744](https://bugs.python.org/issue24744).)
* A format string argument for [`string.Formatter.format()`](https://docs.python.org/3.7/library/string.html#string.Formatter.format) is now [positional-only](https://docs.python.org/3.7/glossary.html#positional-only-parameter). Passing it as a keyword argument was deprecated in Python 3.5\. (Contributed by Serhiy Storchaka in [bpo-29193](https://bugs.python.org/issue29193).)
* Attributes [`key`](https://docs.python.org/3.7/library/http.cookies.html#http.cookies.Morsel.key), [`value`](https://docs.python.org/3.7/library/http.cookies.html#http.cookies.Morsel.value) and [`coded_value`](https://docs.python.org/3.7/library/http.cookies.html#http.cookies.Morsel.coded_value) of class [`http.cookies.Morsel`](https://docs.python.org/3.7/library/http.cookies.html#http.cookies.Morsel) are now read-only. Assigning to them was deprecated in Python 3.5. Use the [`set()`](https://docs.python.org/3.7/library/http.cookies.html#http.cookies.Morsel.set) method for setting them. (Contributed by Serhiy Storchaka in [bpo-29192](https://bugs.python.org/issue29192).)
* `Module`, `FunctionDef`, `AsyncFunctionDef`, and `ClassDef` AST nodes now have a new `docstring` field. The first statement in their body is not considered as a docstring anymore. `co_firstlineno` and `co_lnotab` of code object for class and module are affected by this change. (Contributed by INADA Naoki and Eugene Toder in [bpo-29463](https://bugs.python.org/issue29463).)
* The *mode* argument of [`os.makedirs()`](https://docs.python.org/3.7/library/os.html#os.makedirs) no longer affects the file permission bits of newly-created intermediate-level directories. To set their file permission bits you can set the umask before invoking `makedirs()`. (Contributed by Serhiy Storchaka in [bpo-19930](https://bugs.python.org/issue19930).)
* The [`struct.Struct.format`](https://docs.python.org/3.7/library/struct.html#struct.Struct.format) type is now [`str`](https://docs.python.org/3.7/library/stdtypes.html#str) instead of [`bytes`](https://docs.python.org/3.7/library/stdtypes.html#bytes). (Contributed by Victor Stinner in [bpo-21071](https://bugs.python.org/issue21071).)
* Due to internal changes in [`socket`](https://docs.python.org/3.7/library/socket.html#module-socket) you won’t be able to [`socket.fromshare()`](https://docs.python.org/3.7/library/socket.html#socket.fromshare) a socket [`share()`](https://docs.python.org/3.7/library/socket.html#socket.socket.share)-ed in older Python versions.
* `repr` for [`datetime.timedelta`](https://docs.python.org/3.7/library/datetime.html#datetime.timedelta) has changed to include keyword arguments in the output. (Contributed by Utkarsh Upadhyay in [bpo-30302](https://bugs.python.org/issue30302).)

### CPython bytecode changes

* Added two new opcodes: [`LOAD_METHOD`](https://docs.python.org/3.7/library/dis.html#opcode-LOAD_METHOD) and [`CALL_METHOD`](https://docs.python.org/3.7/library/dis.html#opcode-CALL_METHOD). (Contributed by Yury Selivanov and INADA Naoki in [bpo-26110](https://bugs.python.org/issue26110).)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
