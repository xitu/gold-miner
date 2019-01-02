>* 原文链接 : [Using the new Google Sheets API](http://wescpy.blogspot.hk/2016/06/using-new-google-sheets-api.html)
* 原文作者 : [WESLEY CHUN](http://google.com/+WesleyChun)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Goshin](https://github.com/Goshin)
* 校对者: [warcryDoggie](https://github.com/warcryDoggie), [jkjk77](https://github.com/jkjk77)

# 如何应用最新版的谷歌表格 API

## 引言

本文将演示如何使用最新的 [Google 表格 API](http://developers.google.com/sheets). Google 在 2016 I/O 大会上发布了第四版的表格 API（[博客](http://googleappsdeveloper.blogspot.com/2016/06/auto-generating-google-forms.html)，[视频](http://youtu.be/Gk-xpjgUwx4)），与之前版本相比，新版增加了大量功能。现在，你可以通过 API v4 完成 Google 表格移动版和桌面版的大部分操作。

文章下面会通过 Python 脚本，一步步将一个玩具公司关系型数据库里的客户订单数据逐条读出，并写到一个 Google 表格中。其他会涉及到的 API 还有：新建 Google 表格、从表格中读取数据。

在之前的[几篇文章](http://goo.gl/57Gufk)中，我们已经介绍了 Google API 的结构和大致的使用说明，所以近期的文章会关注特定 API 在实际问题中的使用方法。如果你已经阅读过之前那篇，便可以从下面的授权范围开始，了解具体如何使用。

## Google 表格 API 授权认证及权限范围

之前版本的 Google Sheets API（早期名为 [Google Spreadsheets  API](http://developers.google.com/google-apps/spreadsheets)）作为 [GData API 组](http://developers.google.com/gdata/docs/directory) 的一部分，与其他 API 一起构建实现了较不安全的 [Google Data (GData) 协议](http://developers.google.com/gdata)，以一种 REST 驱动的技术方式读写网络中的信息。而新版表格 API 已成为 [Google APIs](http://developers.google.com/api-client-library/python/apis) 中的一员，使用 [OAuth2](http://oauth.net/) 方式认证，且利用 [Google APIs 客户端库](http://developers.google.com/discovery/libraries) 降低了使用难度。

目前 API 提供[两种授权范围](https://developers.google.com/sheets/guides/authorizing#OAuth2Authorizing)：只读和读写。一般建议开发者根据用途尽量选择较多限制的授权范围。这样可以向用户请求较少的权限，用户更乐意一些，而且这样会令你的应用更加安全，防止可能的数据破坏，并可以预防流量及其他配额不经意地超出。在这个例子中我们需要创建表格并写入数据，所以_必须_选择『读写』授权。

* [参考文档 - 权限部分：读写表格数据及表格属性](https://www.googleapis.com/auth/spreadsheets)

## 使用 Google 表格 API

开始代码部分的讲解：从 SQLite 数据库读取记录，根据这些数据新建 Google 表格。

之前的[文章](http://goo.gl/cdm3kZ)和[视频](http://goo.gl/KMfbeK)中已经包含了授权的完整例子，所以这里直接从创建表格的调用点开始。调用 `apiclient.discovey.build()` 函数，并传入 API 名字符串 `'sheets'` 和版本号字符串 `'v4'`。

```python
SHEETS = discovery.build('sheets', 'v4', http=creds.authorize(Http()))
```

有了表格服务的调用点，首先要做的就是新建一个空白的 Google 表格。在此之前，你需要知道一点：大多数的 API 调用都需要传入一个包含操作名和数据的 JSON 请求主体，随着使用的深入，你会越来越熟悉这一点。对于新建表格来说，JSON 主体就比较简单，不需要加入任何值，传进一个空的 `dict` 就行，但最好还是提供一个表格的名字，参照下面这个 `data`：

```python
data = {'properties': {'title': 'Toy orders [%s]' % time.ctime()}}
```

注意表格的标题 "title" 是它属性 "properties" 的一部分，另外这里还给名字加上了当前的时间戳。完成主体的构建后，将其传入 [`spreadsheets().create()`](http://developers.google.com/sheets/reference/rest/v4/spreadsheets/create) 并执行，完成空白表格的创建。

```python
res = SHEETS.spreadsheets().create(body=data).execute()
```

另外，你还可以通过  [Google Drive API](http://developers.google.com/drive) ([v2](http://wescpy.blogspot.com/2015/12/google-drive-uploading-downloading.html) 或 [v3](http://wescpy.blogspot.com/2015/12/migrating-to-new-google-drive-api-v3.html)) 来新建表格，但还需要传入 Google 表格（文件）的 [MIME 类型](http://developers.google.com/drive/v3/web/mime-types):

```python
data = {
    'name': 'Toy orders [%s]' % time.ctime(),
    'mimeType': 'application/vnd.google-apps.spreadsheet',
}
res = DRIVE.files().create(body=data).execute() # insert() for v2
```

一般来说如果你只需要进行表格的操作，那仅表格的 API 就已足够。但如果你还需要创建其他文件，或是操作其他 Drive 文件和文件夹，你才需要 Drive API。当然如果你的应用复杂，你也可以都用，或是结合其他 Google API 使用。但这里就只用到表格 API。

新建完表格后，获取并显示一些信息。

```python
SHEET_ID = res['spreadsheetId']
print('Created "%s"' % res['properties']['title'])
```

你也许会问：为什么要先新建表格然后再另外调用 API 添加数据？为什么不能在新建表格的时候同时添加数据？这个问题的答案虽然是可以，但是这样做意味着你需要在创建表格的时候，构建一个包含整张表格所有单元格数据及其格式的 JSON，而且单元格的格式数据相当繁复，结构并不像一个数组这么简单（当然你可以尽管尝试）。所以才有了 [spreadsheets().values()](http://developers.google.com/sheets/reference/rest/v4/spreadsheets.values) 的一系列相关函数，来简化仅针对表格数据的上传和下载。

现在再看看 [SQLite](http://sqlite.org) 数据库文件（[db.sqlite](https://github.com/googlecodelabs/sheets-api/blob/master/start/db.sqlite)） 读写部分，你可以从 [Google 表格 Node.js 代码实验](http://g.co/codelabs/sheets) 处获取该文件。下面的代码通过 [sqlite3](http://docs.python.org/library/sqlite3) 标准库来连接数据库，读取所有记录，添加表头，并去除最后两列时间戳：

```python
FIELDS = ('ID', 'Customer Name', 'Product Code', 'Units Ordered',
        'Unit Price', 'Status', 'Created at', 'Updated at')
cxn = sqlite3.connect('db.sqlite')
cur = cxn.cursor()
rows = cur.execute('SELECT * FROM orders').fetchall()
cxn.close()
rows.insert(0, FIELDS)
data = {'values': [row[:6] for row in rows]}
```

拿到表格主体（由记录组成的数组）后，调用 [spreadsheets().values().update()](http://developers.google.com/sheets/reference/rest/v4/spreadsheets.values/update)，比如：

```python
SHEETS.spreadsheets().values().update(spreadsheetId=SHEET_ID,
    range='A1', body=data, valueInputOption='RAW').execute()
```

除了表格 ID 和数据主体之外，这个 API 调用还需要另外两个参数字段：一个是写入表格中的单元格位置范围（这里是左上角，记为 [A1](https://developers.google.com/sheets/guides/concepts#a1_notation)）。另一个是[值的输入选项](https://developers.google.com/sheets/reference/rest/v4/ValueInputOption)，用来定义数据该如何处理：是作为原始值（"RAW"），或用户输入值（"USER_ENTERED"），还是转换成字符串、数字。

从表格中读取行数据就比较简单，[spreadsheets().values().get()](http://developers.google.com/sheets/reference/rest/v4/spreadsheets.values/get) 只需要传入表格 ID 和读取单元格的范围。

```python
print('Wrote data to Sheet:')
rows = SHEETS.spreadsheets().values().get(spreadsheetId=SHEET_ID,
    range='Sheet1').execute().get('values', [])
for row in rows:
    print(row)
```

如果成功的话，会返回一个包含 `'values'` 键的 `dict`。`get()` 的默认值是一个空数组，这样在失败时，`for` 循环也不会出错。

如果你成功运行（末尾有附完整代码），并在浏览器 OAuth2 授权弹窗中同意 Google 表格修改权限的申请，你应该可以得到以下输出：

```bash
$ python3 sheets-toys.py # or python (2.x)
Created "Toy orders [Thu May 26 18:58:17 2016]" with this data:
['ID', 'Customer Name', 'Product Code', 'Units Ordered', 'Unit Price', 'Status']
['1', "Alice's Antiques", 'FOO-100', '25', '12.5', 'DELIVERED']
['2', "Bob's Brewery", 'FOO-200', '60', '18.75', 'SHIPPED']
['3', "Carol's Car Wash", 'FOO-100', '100', '9.25', 'SHIPPED']
['4', "David's Dog Grooming", 'FOO-250', '15', '29.95', 'PENDING']
['5', "Elizabeth's Eatery", 'FOO-100', '35', '10.95', 'PENDING']
```

## 总结

下面是完整脚本，兼容 Python2 **和** Python3。

```python
'''sheets-toys.py -- Google Sheets API demo
    created Jun 2016 by +Wesley Chun/@wescpy
'''
from __future__ import print_function
import argparse
import sqlite3
import time

from apiclient import discovery
from httplib2 import Http
from oauth2client import file, client, tools

SCOPES = 'https://www.googleapis.com/auth/spreadsheets'
store = file.Storage('storage.json')
creds = store.get()
if not creds or creds.invalid:
    flags = argparse.ArgumentParser(parents=[tools.argparser]).parse_args()
    flow = client.flow_from_clientsecrets('client_id.json', SCOPES)
    creds = tools.run_flow(flow, store, flags)

SHEETS = discovery.build('sheets', 'v4', http=creds.authorize(Http()))
data = {'properties': {'title': 'Toy orders [%s]' % time.ctime()}}
res = SHEETS.spreadsheets().create(body=data).execute()
SHEET_ID = res['spreadsheetId']
print('Created "%s"' % res['properties']['title'])

FIELDS = ('ID', 'Customer Name', 'Product Code', 'Units Ordered',
        'Unit Price', 'Status', 'Created at', 'Updated at')
cxn = sqlite3.connect('db.sqlite')
cur = cxn.cursor()
rows = cur.execute('SELECT * FROM orders').fetchall()
cxn.close()
rows.insert(0, FIELDS)
data = {'values': [row[:6] for row in rows]}

SHEETS.spreadsheets().values().update(spreadsheetId=SHEET_ID,
    range='A1', body=data, valueInputOption='RAW').execute()
print('Wrote data to Sheet:')
rows = SHEETS.spreadsheets().values().get(spreadsheetId=SHEET_ID,
    range='Sheet1').execute().get('values', [])
for row in rows:
    print(row)
```

你可以根据你的需要修改定制这段代码，改成移动前端脚本、开发脚本、后端脚本，或是使用其他 Google API。如果你觉得例子太过复杂，可以看看这篇只涉及读取现有表格的[快速入门 Python 部分](http://developers.google.com/sheets/quickstart/python)。如果你熟悉 JavaScript，想做点更正式的东西，可以了解一下这个 [Node.js 上手表格 API 代码实验](http://g.co/codelabs/sheets)，即上文中获取数据库文件的地方。本文就写到这里，希望能在最新表格 API 的入门了解上对你有所帮助。

**附加题**: 请自由尝试单元格格式化及其他 API 的功能。除了读写数值，API 还有很多功能，挑战一下你自己吧！

