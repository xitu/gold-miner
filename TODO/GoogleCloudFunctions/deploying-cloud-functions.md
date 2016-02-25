* 原文[ Deploying Cloud Functions](https://cloud.google.com/functions/deploying)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [huanglizhuo](https://github.com/huanglizhuo)
* 校对者: [shenxn](https://github.com/shenxn) [CoderBOBO](https://github.com/CoderBOBO) [edvarHua](https://github.com/edvardHua)


#部署 Cloud Functions

##在本地构建和测试

Cloud Functions 是在一个 Node.js 运行环境中管理的，因此你可以在你喜欢的开发工具在本地 Node.js 环境进行构建和测试你的函数。

##部署

你可以从本地文件系统(借助[Google Storage bucket](https://cloud.google.com/storage/docs/))部署 Cloud Functions，也可以从你 Github 或 Bitbucket 源码仓库(借助 [Cloud Source Respositories](https://cloud.google.com/tools/cloud-repositories/docs/))部署

在部署时，Cloud Functions 会查找名叫 `index.js` 或者 `function.js` 的文件。如果你提供的 `package.js` 文件中包含 `"main"` 入口，Cloud Functions 就会寻找对应的指定文件而不是前面的这两个。

```
注意：首次部署函数时可能要花费几分钟，因为我们需要为你的函数提供底层支持。随后的部署就会很快了

```

###本地文件系统

本地文件系统部署方式是通过上传一个包含你函数的 ZIP 文件到 Cloud Storage Bucket 中，然后通过命令行工具把那个 bucket 包含在部署中。当使用命令行工具时，Cloud Functions 把包含函数的文件夹打包。另外，你也可以使用 Cloud Platform Console 的 Cloud Functions 界面上传你自己打包的 ZIP 文件。

####创建一个 Cloud Storage Bucket

首先你需要一个 Cloud Storage Bucket 作为你函数代码的临时存储地点。

 如果你还没有 Cloud Storage Bucket ，跟随下面的步骤创建一个：

1. 打开 [Cloud Storage Console](https://console.cloud.google.com/project/_/storage/browser?_ga=1.242691842.1008720489.1449201561)

2. 创建一个新的 bucket

3. 输入 bucket 名字(这里我们使用"cloud-functions")，然后根据你的喜好选择存储类型和位置。

4. 点击创建。

####使用 gcloud 命令行部署

在你函数代码所在的文件夹使用 gcloud 命令行工具的 deploy 命令。命令格式如下：

> $ gcloud alpha functions deploy <NAME> --bucket <BUCKET_NAME> <TRIGGER>

下表是命令中的参数说明:

参数|说明
----|----
deploy| 执行的 Cloud Functions 命令，这里是 deploy 命令。
<NAME>| 你部署的 Cloud Functions 的名称。名称中只能有小写字母，数字和连字符。除非你指定了 --entry-point 选项，否则你模块中必须导出和这个同名的函数。
--bucket <BUCKET_NAME>| 函数源码要上传的 Cloud Storage bucket 的名字
<TRIGGER>|此函数的触发器(参考[Calling Cloud Functions](https://cloud.google.com/functions/calling)) 
可选参数|
--entry-point <FUNCTION_NAME>|作为入口的函数名，而不是<NAME> 参数中使用的那个默认的。这个参数主要用在你源文件中导出的函数名和你部署时候<NAME> 参数指定的函数名不一致时。

下面的例子部署了一个函数并为它部署了有一个 HTTP 触发器:

> $ gcloud alpha functions deploy helloworld --bucket cloud-functions --trigger-http

下表是命令中的参数说明:

参数|说明
----|----
deploy| 执行的 Cloud Functions 命令，这里是 deploy 命令。
helloworld| 部署的函数名，这里是 helloworld 。部署的 CLoud Functions 将会注册到 helloworld 名字下，而源代码中必须导出一个名字是 helloworld 的函数。
--bucket cloud-functions| 源代码上传到的 Cloud Storage 的bucket 名字，这里是 cloud-functions
--trigger-http|函数触发器的类型，这里是 HTTP 请求(webhook)

下面的例子部署了同一个函数但是在不同的命名空间下：

> $ gcloud alpha functions deploy hello --entry-point helloworld --bucket cloud-functions --trigger-http

下表是命令中的参数说明:

参数|说明
----|----
deploy| 执行的 Cloud Functions 命令，这里是 deploy 命令。
hello | 部署的函数名，这里是 hello 。部署的函数会注册在 hello 名下。
--entry-point helloworld|部署的 Cloud Functions 使用一个名字为 helloworld 的导出函数
--bucket cloud-functions| 源代码上传到的 Cloud Storage bucket 名字，这里是 cloud-functions
--trigger-http|函数触发器的类型，这里是 HTTP 请求(webhook)

--entry-point 选项在你导出函数的名字和 Cloud Functions 命名规则不符合时很有用。

###Cloud 仓库

如果你更喜欢使用像 Github 或者 Bitbucket 源码仓库来部署你的函数，那么你可以使用 [Google Cloud Source Repositories](https://cloud.google.com/tools/cloud-repositories/docs) 从你仓库的分支或者 tag 直接部署。

####设置Cloud Source Repositories  

1. 遵循 Cloud Source Respositories 的[开始](https://cloud.google.com/tools/cloud-repositories/docs/cloud-repositories-setup) 设置你的仓库。

2. 跟随这份[指导](https://cloud.google.com/tools/cloud-repositories/docs/cloud-repositories-hosted-repository) 来链接你的 Github 或 Bitbucket 分支。

一旦 Cloud Source Repositories 和你外部的仓库建立了联系，这些仓库就会保持同步，这样你就可以给你通常提交的那个仓库提交了。

####通过 gcloud 命令行工具部署

使用 --source-url 参数从你的源码仓库部署函数：

>$ gcloud alpha functions deploy helloworld \
  --source-url https://source.developers.google.com/p/<PROJECT_ID> <TRIGGER>

下表是命令中的参数说明:

参数|说明
----|----
deploy| 执行的 Cloud Functions 命令，这里是 deploy 命令。
helloworld| 部署的函数名，这里是 helloworld 。部署的 CLoud Functions 将会注册到 helloworld 名字下，而源代码中必须导出一个名字是 helloworld 的函数。
--source-url https://source.developers.google.com/p/<PROJECT_ID>| 项目云仓库的 url 。格式应该是https://source.developers.google.com/p/<PROJECT_ID> 最后跟的是你的 Cloud Project ID
<TRIGGER>|此函数的触发器(参考[Calling Cloud Functions](https://cloud.google.com/functions/calling)) 
可选参数|
--source <SOURCE>|源码树包含函数的路径。例如 "/functions"
--source-branch <SOURCE_BRANCH>|包含函数源码的分支名
--source-tag <SOURCE_TAG> |包含函数源码的 tag 名
--source-revision <SOURCE_REVISION>	|包含函数源码的 revision 名

####使用 Cloud Console 部署
你也可以在 Cloud Platform Console 的 Cloud Functions 页面的创建和部署函数。
