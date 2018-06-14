> * 原文地址：[json — JavaScript Object Notation](https://pymotw.com/3/json/)
> * 原文作者：[pymotw.com](pymotw.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/json-javascript-object-notation.md](https://github.com/xitu/gold-miner/blob/master/TODO/json-javascript-object-notation.md)
> * 译者：[snowyYU](https://github.com/snowyYU)
> * 校对者：[Starriers](https://github.com/Starriers), [zhmhhu](https://github.com/zhmhhu)

# json — JavaScript 对象表示法

目的：实现 Python 对象和 JSON 字符串间的相互转化。

`json` 模块提供了一个类似于 [`pickle`](https://pymotw.com/3/pickle/index.html#module-pickle) 的 API，用于将内存中的 Python 对象转换为 JavaScript Object Notation（JSON）的序列化表示形式。相较于 pickle，JSON 优势之一就是被许多语言实现和应用（特别是 JavaScript）。它被广泛用于 REST API 中Web服务器和客户端之间的通信，此外也可用于其他应用程序间的通信。

## 编码和解码简单的数据类型

JSON 编码器原生支持 Python 的基本类型 (`str`, `int`, `float`, `list`, `tuple`, 和 `dict`).

```
# json_simple_types.py

import json

data = [{'a': 'A', 'b': (2, 4), 'c': 3.0}]
print('DATA:', repr(data))

data_string = json.dumps(data)
print('JSON:', data_string)
```

值的编码方式看起来类似于 Python 的 `repr()` 输出。

```
$ python3 json_simple_types.py

DATA: [{'c': 3.0, 'b': (2, 4), 'a': 'A'}]
JSON: [{"c": 3.0, "b": [2, 4], "a": "A"}]
```

编码之后再解码，将可能得到并不完全相同的对象类型。

```
# json_simple_types_decode.py

import json

data = [{'a': 'A', 'b': (2, 4), 'c': 3.0}]
print('DATA   :', data)

data_string = json.dumps(data)
print('ENCODED:', data_string)

decoded = json.loads(data_string)
print('DECODED:', decoded)

print('ORIGINAL:', type(data[0]['b']))
print('DECODED :', type(decoded[0]['b']))
```

特别注意，元组会转化成列表。

```
$ python3 json_simple_types_decode.py

DATA   : [{'c': 3.0, 'b': (2, 4), 'a': 'A'}]
ENCODED: [{"c": 3.0, "b": [2, 4], "a": "A"}]
DECODED: [{'c': 3.0, 'b': [2, 4], 'a': 'A'}]
ORIGINAL: <class 'tuple'>
DECODED : <class 'list'>
```

## 可读性 vs. 紧凑型输出

相较于[`pickle`](https://pymotw.com/3/pickle/index.html#module-pickle)，JSON 可读性更好。 `dumps()` 函数接收若干参数来优化输出的可读性。例如，`sort_keys`参数告诉编码器以排序而不是随机顺序输出字典的键的值。

```
# json_sort_keys.py

import json

data = [{'a': 'A', 'b': (2, 4), 'c': 3.0}]
print('DATA:', repr(data))

unsorted = json.dumps(data)
print('JSON:', json.dumps(data))
print('SORT:', json.dumps(data, sort_keys=True))

first = json.dumps(data, sort_keys=True)
second = json.dumps(data, sort_keys=True)

print('UNSORTED MATCH:', unsorted == first)
print('SORTED MATCH  :', first == second)
```

有序输出，可读性自然比较高，并且在测试中容易对 JSON 的输出进行比较。

```
$ python3 json_sort_keys.py

DATA: [{'c': 3.0, 'b': (2, 4), 'a': 'A'}]
JSON: [{"c": 3.0, "b": [2, 4], "a": "A"}]
SORT: [{"a": "A", "b": [2, 4], "c": 3.0}]
UNSORTED MATCH: False
SORTED MATCH  : True
```

对于高度嵌套的数据结构，请为 `indent` 指定一个值，以便输出结构更加清晰的格式。

```
# json_indent.py

import json

data = [{'a': 'A', 'b': (2, 4), 'c': 3.0}]
print('DATA:', repr(data))

print('NORMAL:', json.dumps(data, sort_keys=True))
print('INDENT:', json.dumps(data, sort_keys=True, indent=2))
```

当 indent 是一个非负整数时，其输出更接近 [`pprint`](https://pymotw.com/3/pprint/index.html#module-pprint) 的输出，其缩进的空格数与传入的 indent 值相同，展示了清晰的数据结构。

```
$ python3 json_indent.py

DATA: [{'c': 3.0, 'b': (2, 4), 'a': 'A'}]
NORMAL: [{"a": "A", "b": [2, 4], "c": 3.0}]
INDENT: [
  {
    "a": "A",
    "b": [
      2,
      4
    ],
    "c": 3.0
  }
]
```

虽然输出的数据结构更清晰，但增加了传输相同数据量所需的字节数，因此它不适用于生产环境。实际上，可以通过设置输出的 separators 参数，使其编码后的值比默认情况下更紧凑。

```
# json_compact_encoding.py

import json

data = [{'a': 'A', 'b': (2, 4), 'c': 3.0}]
print('DATA:', repr(data))

print('repr(data)             :', len(repr(data)))

plain_dump = json.dumps(data)
print('dumps(data)            :', len(plain_dump))

small_indent = json.dumps(data, indent=2)
print('dumps(data, indent=2)  :', len(small_indent))

with_separators = json.dumps(data, separators=(',', ':'))
print('dumps(data, separators):', len(with_separators))
```

`dumps()` 的`separators`参数应该是一个包含字符串的元组，用于分隔列表中的项目以及字典中的值。默认值是'('，'，'：')`。通过消除空占位符，生成更紧凑的输出。

```
$ python3 json_compact_encoding.py

DATA: [{'c': 3.0, 'b': (2, 4), 'a': 'A'}]
repr(data)             : 35
dumps(data)            : 35
dumps(data, indent=2)  : 73
dumps(data, separators): 29
```

## 编码字典

JSON 期望字典键的格式是字符串。如果用非字符串类型作为键编码字典会产生一个 `TypeError`。解决该限制的一种方法是使用 skipkeys 参数告诉编码器跳过非字符串键：

```
# json_skipkeys.py

import json

data = [{'a': 'A', 'b': (2, 4), 'c': 3.0, ('d',): 'D tuple'}]

print('First attempt')
try:
    print(json.dumps(data))
except TypeError as err:
    print('ERROR:', err)

print()
print('Second attempt')
print(json.dumps(data, skipkeys=True))
```

没有抛出异常，忽略了非字符串键。

```
$ python3 json_skipkeys.py

First attempt
ERROR: keys must be a string

Second attempt
[{"c": 3.0, "b": [2, 4], "a": "A"}]
```

## 使用自定义类型

到目前为止，所有的例子都使用了 Pythons 的内置类型，因为这些类型本身就支持 `json`。此外，通常还需要对自定义类进行编码，并且有两种方法可以做到这一点。

将下面的类进行编码：

```
# json_myobj.py

class MyObj:

    def __init__(self, s):
        self.s = s

    def __repr__(self):
        return '<MyObj({})>'.format(self.s)
```

说个简单编码 `MyObj` 实例的方法：定义一个函数将未知类型转换为已知类型。类本身不需要进行编码，所以它只是将一个对象转换为另一个。

```
# json_dump_default.py

import json
import json_myobj

obj = json_myobj.MyObj('instance value goes here')

print('First attempt')
try:
    print(json.dumps(obj))
except TypeError as err:
    print('ERROR:', err)


def convert_to_builtin_type(obj):
    print('default(', repr(obj), ')')
    # Convert objects to a dictionary of their representation
    d = {
        '__class__': obj.__class__.__name__,
        '__module__': obj.__module__,
    }
    d.update(obj.__dict__)
    return d


print()
print('With default')
print(json.dumps(obj, default=convert_to_builtin_type))
```

依赖的模块可以正常访问的情况下，在 `convert_to_builtin_type()` 中，没有被 `json` 识别的类的实例被格式化为具有足够信息的字典，然后重新创建该对象.

```
$ python3 json_dump_default.py

First attempt
ERROR: <MyObj(instance value goes here)> is not JSON serializable

With default
default( <MyObj(instance value goes here)> )
{"s": "instance value goes here", "__module__": "json_myobj",
"__class__": "MyObj"}
```

要解析结果并创建一个 `MyObj()`实例，可以使用 `object_hook` 参数来调用 `loads()` 以连接解析器，这样就可以从模块中导入类并用于创建实例。

为从输入数据流中解码出的每个字典调用 `object_hook`，它提供将字典转换为另一种类型的对象的功能。钩子函数应该返回调用应用程序应该接收的对象而不是字典

```
# json_load_object_hook.py

import json


def dict_to_object(d):
    if '__class__' in d:
        class_name = d.pop('__class__')
        module_name = d.pop('__module__')
        module = __import__(module_name)
        print('MODULE:', module.__name__)
        class_ = getattr(module, class_name)
        print('CLASS:', class_)
        args = {
            key: value
            for key, value in d.items()
        }
        print('INSTANCE ARGS:', args)
        inst = class_(**args)
    else:
        inst = d
    return inst


encoded_object = '''
    [{"s": "instance value goes here",
      "__module__": "json_myobj", "__class__": "MyObj"}]
    '''

myobj_instance = json.loads(
    encoded_object,
    object_hook=dict_to_object,
)
print(myobj_instance)
```

由于 `json` 将字符串值转换为了 unicode 对象，因此在将其用作类构造函数的关键字参数之前，需要将它们重新编码为 ASCII 字符串。

```
$ python3 json_load_object_hook.py

MODULE: json_myobj
CLASS: <class 'json_myobj.MyObj'>
INSTANCE ARGS: {'s': 'instance value goes here'}
[<MyObj(instance value goes here)>]
```

类似的钩子可用于内置的数据类型：整数（`parseint`），浮点数（`parsefloat`）和常量（`parse constant`）。

## 编码器和解析器相关的类

除了已经介绍的便利功能之外，`json` 模块还提供了编码和解析相关的类。直接使用类可以访问额外的 API 来定制它们的行为。

`JSONEncoder` 使用一个可迭代的接口来产生编码数据的 “块”，使得它更容易写入文件或网络套接字，而无需在内存中表示整个数据结构。

```
# json_encoder_iterable.py

import json

encoder = json.JSONEncoder()
data = [{'a': 'A', 'b': (2, 4), 'c': 3.0}]

for part in encoder.iterencode(data):
    print('PART:', part)
```

输出以逻辑单位为准，和值的大小无关。

```
$ python3 json_encoder_iterable.py

PART: [
PART: {
PART: "c"
PART: :
PART: 3.0
PART: ,
PART: "b"
PART: :
PART: [2
PART: , 4
PART: ]
PART: ,
PART: "a"
PART: :
PART: "A"
PART: }
PART: ]
```

`encode()` 方法基本上等同于 `''.join(encoder.iterencode())`，此外还有一些预先错误检查。

要对任意对象进行编码，建议使用与 `convert_to_builtin_type()` 中使用的类似的实现来重载 `default()` 方法。

```
# json_encoder_default.py

import json
import json_myobj


class MyEncoder(json.JSONEncoder):

    def default(self, obj):
        print('default(', repr(obj), ')')
        # Convert objects to a dictionary of their representation
        d = {
            '__class__': obj.__class__.__name__,
            '__module__': obj.__module__,
        }
        d.update(obj.__dict__)
        return d


obj = json_myobj.MyObj('internal data')
print(obj)
print(MyEncoder().encode(obj))
```

和之前的例子输出相同。

```
$ python3 json_encoder_default.py

<MyObj(internal data)>
default( <MyObj(internal data)> )
{"s": "internal data", "__module__": "json_myobj", "__class__":
"MyObj"}
```

解析文本，将字典转换为对象比上面提到的实现方法更为复杂，不过差别不大。

```
# json_decoder_object_hook.py

import json


class MyDecoder(json.JSONDecoder):

    def __init__(self):
        json.JSONDecoder.__init__(
            self,
            object_hook=self.dict_to_object,
        )

    def dict_to_object(self, d):
        if '__class__' in d:
            class_name = d.pop('__class__')
            module_name = d.pop('__module__')
            module = __import__(module_name)
            print('MODULE:', module.__name__)
            class_ = getattr(module, class_name)
            print('CLASS:', class_)
            args = {
                key: value
                for key, value in d.items()
            }
            print('INSTANCE ARGS:', args)
            inst = class_(**args)
        else:
            inst = d
        return inst


encoded_object = '''
[{"s": "instance value goes here",
  "__module__": "json_myobj", "__class__": "MyObj"}]
'''

myobj_instance = MyDecoder().decode(encoded_object)
print(myobj_instance)
```

输出与前面的例子相同。

```
$ python3 json_decoder_object_hook.py

MODULE: json_myobj
CLASS: <class 'json_myobj.MyObj'>
INSTANCE ARGS: {'s': 'instance value goes here'}
[<MyObj(instance value goes here)>]
```

## 使用流和文件

到目前为止，所有的例子的前提都是假设整个数据结构的编码版本可以一次保存在内存中。对于包含大量数据的复杂结构，将编码直接写入文件类对象会比较好。`load()`和 `dump()` 函数可以接受文件类对象的引用作为参数，来进行方便读写操作。

```
# json_dump_file.py

import io
import json

data = [{'a': 'A', 'b': (2, 4), 'c': 3.0}]

f = io.StringIO()
json.dump(data, f)

print(f.getvalue())
```

套接字或常规文件句柄有着和本示例中使用的 `StringIO` 缓冲区相同的工作方式。

```
$ python3 json_dump_file.py

[{"c": 3.0, "b": [2, 4], "a": "A"}]
```

尽管它没有被优化为一次只读取一部分数据，但 `load()` 函数仍然提供了一种把输入流转换成对象的封装逻辑方面的好处。

```
# json_load_file.py

import io
import json

f = io.StringIO('[{"a": "A", "c": 3.0, "b": [2, 4]}]')
print(json.load(f))
```

就像 `dump()` 一样，任何类文件对象都可以传递给 `load()`。

```
$ python3 json_load_file.py

[{'c': 3.0, 'b': [2, 4], 'a': 'A'}]
```


## 混合数据流

`JSONDecoder` 包含 `raw_decode()`，这是一种解码数据结构后面跟着更多数据的方法，比如带有尾随文本的 JSON 数据。返回值是通过对输入数据进行解码而创建的对象，以及指示解码器在何处停止工作的位置索引。

```
# json_mixed_data.py

import json

decoder = json.JSONDecoder()


def get_decoded_and_remainder(input_data):
    obj, end = decoder.raw_decode(input_data)
    remaining = input_data[end:]
    return (obj, end, remaining)


encoded_object = '[{"a": "A", "c": 3.0, "b": [2, 4]}]'
extra_text = 'This text is not JSON.'

print('JSON first:')
data = ' '.join([encoded_object, extra_text])
obj, end, remaining = get_decoded_and_remainder(data)

print('Object              :', obj)
print('End of parsed input :', end)
print('Remaining text      :', repr(remaining))

print()
print('JSON embedded:')
try:
    data = ' '.join([extra_text, encoded_object, extra_text])
    obj, end, remaining = get_decoded_and_remainder(data)
except ValueError as err:
    print('ERROR:', err)
```

但是，这只有在对象出现在输入的开头时才有效。

```
$ python3 json_mixed_data.py

JSON first:
Object              : [{'c': 3.0, 'b': [2, 4], 'a': 'A'}]
End of parsed input : 35
Remaining text      : ' This text is not JSON.'

JSON embedded:
ERROR: Expecting value: line 1 column 1 (char 0)
```

## 命令行中的 JSON

`json.tool` 模块实现了一个命令行程序，用于重新格式化 JSON 数据以便于阅读。

```
[{"a": "A", "c": 3.0, "b": [2, 4]}]
```

输入文件 `example.json` 包含一个按字母顺序排列的映射。下面的第一个例子显示按顺序重新格式化的数据，第二个例子使用 `--sort-keys` 在打印输出之前对映射键进行排序。

```
$ python3 -m json.tool example.json

[
    {
        "a": "A",
        "c": 3.0,
        "b": [
            2,
            4
        ]
    }
]

$ python3 -m json.tool --sort-keys example.json

[
    {
        "a": "A",
        "b": [
            2,
            4
        ],
        "c": 3.0
    }
]
```

参阅

* [json 的标准库文档](https://docs.python.org/3.5/library/json.html)
* [<span class="std std-ref">从Python2 迁移到 3 json 相关的笔记</span>](../porting_notes.html#porting-json)
* [JavaScript 对象表示法](http://json.org/) – JSON 主页, 内含相关文档和在其他语言中的实现。
* [jsonpickle](http://code.google.com/p/jsonpickle/) – `<span class="pre">jsonpickle</span>` 支持将任意 Python 对象序列化为 json字符串。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
