* 原文[Getting Started](https://cloud.google.com/functions/getting-started)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [huanglizhuo](https://github.com/huanglizhuo)
* 校对者: [shenxn](https://github.com/shenxn) [CoderBOBO](https://github.com/CoderBOBO) [edvarHua](https://github.com/edvardHua)


#入门

使用 [Google Cloud Functions](https://cloud.google.com/functions/docs/) 的准备工作：

 1. 要是你还没有 Google 账户的话[点击这里创建](https://accounts.google.com/SignUp)

 2. 在你的 Google 账户中创建一个结算账户

	为了使用 Google Cloud Function 你必须开启你计划使用的云工程的结算渠道，前提是你必须先有个可以结算的账户

	如果你没有可以结算的账户，那么点击[这里](https://console.cloud.google.com/billing?_ga=1.11430708.1008720489.1449201561) 创建一个

 3. 创建 Cloud Platform 工程

	我们建议大家创建一个新的工程体验 Google Cloud Functions。当然你也可以使用已经创建的工程。点击[这里](https://console.cloud.google.com/project?_ga=1.203378321.1008720489.1449201561)创建新的项目。

 4. 给你的项目开启结算

	你要使用的云项目必须开启结算。可以在[这里](https://console.cloud.google.com/project?_ga=1.203378321.1008720489.1449201561) 开启结算。

 5. 开启云函数 APIs

	在开始使用 Cloud Functions 前，你需要确保 Cloud Functions API(以及所有的依赖 API ) 是开启的。你可以在[这里](https://console.cloud.google.com/flows/enableapi?apiid=cloudfunctions,container,compute_component,storage_component,pubsub,logging,source&pli=1&_ga=1.1977009.1008720489.1449201561)开启云函数 APIs
	
	这将会开启下面的云平台 APIs
	
	* Google Cloud Functions
	* Google Container Engine
	* Google Compute Engine
	* Google Cloud Pub/Sub
	* Google Cloud Logging
	* Google Cloud Storage
	* Cloud Source Repositories 

6. 安装 Google Cloud SDK

	这份文档中的 walkthrough 例子就是使用的 gcloud 命令行工具可以在 Cloud SDK 中找到。安装和设置 Cloud SDK 的指导文档请参看 Cloud SDK 的[安装和快速开始](https://cloud.google.com/sdk)

	接下来在你自己的机器上用下面的命令进行认证：

	> $ gcloud auth login

	在 gcloud 中设置活跃项目，这个项目是应该是你之前选择的同一个项目：

	> $ gcloud config set project <PROJECT_ID>

	参看 [Cloud Platform Console projects page](https://console.cloud.google.com/project?_ga=1.241528706.1008720489.1449201561) 来确定 <PROJECT_ID> 或者通过 Google CLoud Platform Console 的控制台查找 ID

```
注意:这里的 project ID 可能和 Cloud Platform Console 顶部显示的项目名字不一样

```

开启 alpha 特性访问 Cloud Functions:

> $ gcloud components update alpha

执行 gcloud functions 帮助命令确定所有都就绪了(别忘了加上 alpha 参数):

> $ gcloud alpha functions -h
