原文[Command Reference](https://cloud.google.com/functions/reference)


##命令行参考

###Cloud Functions 命令行界面

Google Cloud Functions 通过 gcloud SDK 提供了一个命令行界面(CLI)。如果你读过[开始](.getting-started.md)章节，那么你应该已经安装了这个工具了。

###认证

执行下面的命令给 gcloud 工具进行认证:

> $ gcloud auth login

###CLI 方法

查看 gcloud 工具的全部方法列表，执行:

> $ gcloud alpha functions -h

常用的方法如下:

```
call        为测试同步调用该函数
delete      删除一个函数
deploy      创建一个新函数或者更新一个已近存在的函数
describe    显示函数的相关描述
get-logs    显示给定函数产生的日志
list        列出给定区域的全部函数
```

可以通过给单个命令添加一个 -h 参数来查看该命令的详细帮助文档，比如:

>$ gcloud alpha functions call -h
