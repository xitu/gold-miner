> * 原文地址：[Build a Babel Fish with Nexmo, and the Microsoft Translator Speech API](https://www.nexmo.com/blog/2018/03/14/speech-voice-translation-microsoft-dr/)
> * 原文作者：[Naomi Pentrel](https://www.nexmo.com/blog/author/naomi-pentrel/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/speech-voice-translation-microsoft-dr.md](https://github.com/xitu/gold-miner/blob/master/TODO1/speech-voice-translation-microsoft-dr.md)
> * 译者：[Starrier](https://github.com/Starriers)
> * 校对者：[haoyuez](https://github.com/haoyuez)

# 使用 Nexmo 和微软语音翻译 API 构建 Babel Fish

如果在过去的几个月时间里你关注过互联网上的变化，那你就会注意到 Google 的即时翻译 Pixel Buds。它是一个像给 **Galaxy 的 Hitchhiker 指南**中 Bable Fish 一样的技术，可以为穿戴者翻译任何可感知的语言并让他们像虚拟人类一样与穿戴者进行交流。但使用 Google 的 Pixel Buds 代价昂贵 —— 那么我们为何不自己动手构建呢？这也是 [Danielle](https://twitter.com/dantoml) 和我最近在 [hackference](https://2017.hackference.co.uk/) 上所构想的。我们想要去创建一个让电话交流的双方可以根据自己所需，听到彼此说话内容的翻译版本的 Nexmo Babel Fish。

![Image of a Babel fish from The Hitchhiker's Guide to the Galaxy](https://www.nexmo.com/wp-content/uploads/2018/03/babelfish.png)

来自给 Galaxy 的 Hitchhiker 的指南中的 Bable Fish 的图片。

在这篇博客中，我们将介绍搭建 Babel Fish 系统的步骤。首先我们需要设置和配置环境。然后我们会设置一个 Nexmo number 来处理调用。在此之后，我们会搭建一个通过 WebSocket 接收语音，并将其从 Nexmo number 传送到微软语言翻译 API 的 Python 服务器。我们会使用语音翻译 API 来处理转录和翻译。在此基础上，我们将实现管理双向对话的逻辑，并指示 Nexmo number 说出翻译内容。为了便于实现，双方必须都调用我们的 Nexmo number。你可以参考下面的高级图表，它展示了来自任何一方的语音实例是如何处理的。注意在本教程中，我会使用一个德语/英语的示例。

![Diagram that shows how a message passes through the system. A German caller speaks a message in German which Nexmo passes through to a Python server. The Python server sends the German audio to the Microsoft Speech API. The Speech API responds by sending the English translation as text to the Python server. The Python server then sends a request to Nexmo to speak the English message to the British caller. At this point the British caller hears the translated message in English.](https://www.nexmo.com/wp-content/uploads/2018/03/system_diagram.png)

该图表展示了消息如何在系统中传递。一个德语调用者通过 Nexmo 发送一条德语消息给 Python 服务器。Python 服务器将德语音频发送给微软语音 API。语音 API 将英文翻译作为文本发送到 Python 服务器来响应请求。Python 服务器会向 Nexmo 发送请求，向英语调用者说出英语消息。此时英语调用者便会听到翻译后的英语信息。

如果你只想看代码，可以在 [Github](https://github.com/npentrel/babelfish) 上找到。

## 准备条件

你需要同时安装 Python 2.x 或 3.x 和 HTTP 通道软件 [ngrok](https://ngrok.com/)。我们会列出你在安装过程中需要的所有命令。

## 开始

### 配置你的环境

我们从使用 [Virtualenv](https://virtualenv.pypa.io/en/stable/) 来为此项目配置虚拟环境的 DIY Babel Fish 的解决方案开始。Virtualenv 允许我们将此项目与其他项目隔离。继续为此项目创建目录，并将以下依赖列表复制到你项目目录中命名为 `requirements.txt` 的文件中：

```
nexmo
tornado>=4.4.2
requests>=2.12.4
```

为了创建并激活你的虚拟环境，请在终端运行以下命令：

```
virtualenv venv  # sets up the environment
source venv/bin/activate  # activates the environment
pip install -r requirement.txt  # installs our dependencies
 
# 如果你使用的是 Python 3，请使用以下命令
pip3 install -r requirement.txt
```

此时，通过在单独打开一个终端的窗口中运行下列命令来启动 ngrok。ngrok 允许我们将本地 5000 端口暴露给外部请求。为此，你需要让 ngrok 在后台保持正常运行。你可以阅读更多关于用 Nexmo 链接 ngrok 的[信息](https://www.nexmo.com/blog/2017/07/04/local-development-nexmo-ngrok-tunnel-dr/)。

```
ngrok http 5000
```

一旦你运行上述命令，你的终端就会和下面的截图类似。下一步，你需要在配置你的 Nexmo 应用程序和编号 时转发 URL。

![Screenshot of ngrok running in a terminal and displaying a forwarding URL of the form “http://016a0331.ngrok.io”.](https://www.nexmo.com/wp-content/uploads/2018/03/ngrok.png)

在终端运行的 ngrok 以及展示转发来自 “http://016a0331.ngrok.io” URL 的屏幕截图。

### 获取一个 Nexmo number

使用我们的翻译服务需要一个 Nexmo Number。如果你还没有账号，可以在 [dashboard.nexmo.com/sign-up](https://dashboard.nexmo.com/sign-up) 进行注册，请前往 [dashboard.nexmo.com/buy-numbers](https://dashboard.nexmo.com/buy-numbers) 购买一个具有语音功能的 Nexmo number。

![Screen capture of a user buying a number using the Nexmo buy numbers menu. A user selects their country, Voice as the feature, and mobile as the type and clicks on the search button. The user then clicks on buy for the first number that comes up and confirms the purchase.](https://www.nexmo.com/wp-content/uploads/2018/03/buy-nexmo-number.gif)

该截屏展示了用户如何使用 Nexmo 的购买编号菜单来购买 Nexmo number。用户需要选择国家和语音将作为特征，移动设备作为类型，最后点击搜索按钮。然后点击第一个数字边的购买链接，便可确认购买。

### 创建 Nexmo 应用程序

进入你的应用程序，然后新增一个。对事件 URL 和应答 URL 使用 Ngrok 转发 URL，添加 `/event` 作为事件 URL(e.g. `http://016a0331.ngrok.io/event`) 的路径，对应答 URL(e.g. `http://016a0331.ngrok.io/ncco`) 使用 `/ncco`。我们之后会设置这些端点。在你的电脑上通过用户接口生成并存储一对公钥/私钥对。

![Screen capture of a user creating an application using the Nexmo application menu. A user clicks on add new application. In the form that appears the user enters babelfish as the application name, `http://016a0331.ngrok.io/event` as the Event URL, and `http://016a0331.ngrok.io/ncco` as the Answer URL. The user then clicks on the `Generate public/private key pair` link, saves the key when prompted, and finally clicks on create application.” The last step for our number setup is to link the number you purchased earlier to your application. Use the application dashboard to link the number.](https://www.nexmo.com/wp-content/uploads/2018/03/create-application.gif)

使用 Nexmo 应用程序目录创建应用程序的用户屏幕截图。用户点击新增应用程序。在显示的表单中，用户输入 Babelfish 作为应用程序名，`http://016a0331.ngrok.io/event` 作为事件的 URL，`http://016a0331.ngrok.io/ncco` 作为应答 URL。然后用户单击 `Generate public/private key pair` 链接，在提示时保存密钥，最后单击创建应用程序。编号设置的最后一步是将你之前购买的编号链接到你的应用程序。使用应用程序仪表板来链接编号。

### 获取微软语音翻译 API 的密钥

我们需要设置的另一个服务是[微软的语音服务 API](http://docs.microsofttranslator.com/speech-translate.html)。在 [azure.com](http://azure.com) 上注册一个免费的微软 Azure 账号，然后跳转到 [portal.azure.com](http://portal.azure.com)，创建一个语音翻译 API 资源。你需要它为下一步生成的密钥。

![Screen capture of a user setting up the Microsoft Translator Speech API. A user types translator speech into the Marketplace search on the Microsoft Azure portal. The user then clicks on the Translator Speech API option that comes up and clicks on the create button on the API overview screen. The user then fills in the form for the resource using babelfish as the name, Pay-as-you-go as the subscription, F0 (10 Hours of audio input) as the pricing tier, and babelfish-resource as the resource group name. After checking the box that the user has 'read and understood the notice' and checking add to dashboard, the user clicks on create and is redirected to the dashboard. After the deployment finishes, the user clicks on the deployed resource and is presented with a resource dashboard. On the resource dashboard under the section grab the keys the user clicks on keys and copies key 1.](https://www.nexmo.com/wp-content/uploads/2018/03/microsoft-translator-api.gif)

设置微软语音翻译 API 的用户屏幕截图。用户在微软 Azure 上的市场搜索中输入语言翻译。然后，用户单击出现的语音翻译 API 选项，再单击 API 概述屏幕上的创建按钮。之后，用户填写资源的表单，使用 babelfish 作为应用程序名，Pay-as-you-go 作为订阅，F0（10 小时的音频输入）作为定价层，babelfish —— 资源作为资源组组名。选中用户已经“阅读并理解注意事项”的选框，并检查添加到仪表板，用户单击创建并重定向到仪表板。部署完成后，用户单击已部署的资源，会显示一个资源仪表板。在资源仪表板中，抓取用户单击的键并复制键 1。

### 管理密钥和配置

我们现在有了自己的 Nexmo number 和语音翻译 API 密钥。我们现在要做的就是去设置一个包含所有这些重要细节的密码和配置，这样我们就不必继续编辑它们，可以对它们进行单独的管理。将下列内容存储在你项目目录的 `secrets.py` 中，然后用你的值来替换占位符值。

```
# 用你的值替换下面的值
# 你的 API 密钥和密码可以在这里找到 https://dashboard.nexmo.com/getting-started-guide
NEXMO_API_KEY = "<your-api-key>"
NEXMO_API_SECRET = "<your-api-secret>"
# 你的 nexmo 编号
NEXMO_NUMBER = "+447512345678"
# 这可以在你的 Nexmo 应用程序面板上找到
NEXMO_APPLICATION_ID = "<nexmo-application-id>"
# 这是设置你的应用程序时下载的私钥
NEXMO_PRIVATE_KEY = '''-----BEGIN PRIVATE KEY-----
<your-private-key>
-----END PRIVATE KEY-----'''
 
# 你必须注册一个免费的微软账号才能使用微软语音翻译 API：http://docs.microsofttranslator.com/speech-translate.html
MICROSOFT_TRANSLATION_SPEECH_CLIENT_SECRET = "<your-api-key>"
```

之后，在你的项目目录中，在 `config.py` 中存储以下内容，然后再用值替换占位符值。注意，你也可以选择以下语言的其他语言。你也可以在之后的任意时间更改这些内容。

```
HOSTNAME = '<your-value>.ngrok.io'
 
# 用相同格式的数字替换变量赋值
CALLER = '447812345678'
 
# 用语言替换变量值
LANGUAGE1 = 'de-DE'
 
 
# 将变量赋值替换为你的语言的相应名称。可以在这里找到：
# https://developer.nexmo.com/api/voice/ncco#voice-names
VOICE1 = 'Marlene'
 
# 其他语言和语音
LANGUAGE2 = 'en-US'
VOICE2 = 'Kimberly'
```

## 教程步骤

我们将首先介绍如何使用语言翻译 API 进行身份认证。然后我们将使用提供的模版来设置我们的 Tornado Web 服务器。之后，我们要实现 `CallHandler`、`EventHandler` 以及 `WSHandler`。`CallHandler` 将为我们处理 Nexmo number 的调用。在此基础上，`EventHandler` 将被用于处理 Nexmo 发送的事件，例如开始或完成的调用。在每个事件中，Nexmo 都会发送关于启动或完成调用的执行者的信息。我们会使用这些信息来存储特定调用中的人。`WSHandler` 同时被用来打开 WebSocket，Nexmo 和我们的 Python 服务器通过它进行通信。Python 服务器将创建音频片段并将其发送到语言翻译 API。处理器将使用 `EventHandler` 收集信息来正确地路由。下面的部分会进一步解释这些概念，并显示相应的实现。

### 使用微软语言翻译 API 的身份认证

要使用语音翻译 API，我们需要一个名为 `MICROSOFT_TRANSLATION_SPEECH_CLIENT_SECRET` 的 token。幸运的是，微软提供了一个 Python [AzureAuthClient](https://github.com/MicrosoftTranslator/Python-Speech-Translate/blob/master/auth.py)，我们会使用它，不会做任何更改。请将以下内容复制并保存到你的项目目录中名为 `azure_auth_client.py` 的文件中。

```
"""
从 Azure 平台获取示例 A 的代码。
访问 http://docs.microsofttranslator.com/oauth-token.html 来查看
微软 Azure 认知服务的身份验证服务 API 参考资料。
"""
 
from datetime import timedelta
from datetime import datetime
 
import requests
 
class AzureAuthClient(object):
    """
    Provides a client for obtaining an OAuth token from the authentication service
    for Microsoft Translator in Azure Cognitive Services.
    """
 
    def __init__(self, client_secret):
        """
        :param client_secret: Client secret.
        """
 
        self.client_secret = client_secret
        # token field is used to store the last token obtained from the token service
        # the cached token is re-used until the time specified in reuse_token_until.
        self.token = None
        self.reuse_token_until = None
 
    def get_access_token(self):
        '''
        Returns an access token for the specified subscription.
        This method uses a cache to limit the number of requests to the token service.
        A fresh token can be re-used during its lifetime of 10 minutes. After a successful
        request to the token service, this method caches the access token. Subsequent
        invocations of the method return the cached token for the next 5 minutes. After
        5 minutes, a new token is fetched from the token service and the cache is updated.
        '''
 
        if (self.token is None) or (datetime.utcnow() > self.reuse_token_until):
 
            token_service_url = 'https://api.cognitive.microsoft.com/sts/v1.0/issueToken'
 
            request_headers = {'Ocp-Apim-Subscription-Key': self.client_secret}
 
            response = requests.post(token_service_url, headers=request_headers)
            response.raise_for_status()
 
            self.token = response.content
            self.reuse_token_until = datetime.utcnow() + timedelta(minutes=5)
 
        return self.token
```

### 创建服务器

计算机通信协议 WebSocket 允许我们在一个 TCP 连接中拥有一个双向通信管道。Nexmo 的 Voice API [允许你将电话调用链接到这样的 WebScoket 端点](https://developer.nexmo.com/voice/voice-api/guides/call-a-websocket/python)。我们会使用 Tornado Web 服务器 web 框架来实现我们的 WebSocket 协议。

如果你一直按照步骤来，而且所有的文件都如我们所描述的创建，那么你可以从下面的 Tornado Web 服务器配置开始。这个代码会处理所有的导入，配置 Nexmo 客户端以及 azure auth 客户端，并使用 5000 端口启动服务器。注意这个服务器目前还未执行任何有用操作。它有 3 个端点：`ncco`、`event` 和 `socket`，它们会分别调用 `CallHandler`、`EventHandler` 和 `WSHandler`。我们会在下面的部分实现处理器。

在你的项目文件夹中创建一个名为 `main.py` 的文件，并将以下代码复制进去。

```
from string import Template
import json
import os
import requests
import struct
import StringIO
 
from tornado import httpserver, httpclient, ioloop, web, websocket, gen
from xml.etree import ElementTree
import nexmo
 
from azure_auth_client import AzureAuthClient
from config import HOSTNAME, CALLER, LANGUAGE1, VOICE1, LANGUAGE2, VOICE2
from secrets import NEXMO_APPLICATION_ID, NEXMO_PRIVATE_KEY, MICROSOFT_TRANSLATION_SPEECH_CLIENT_SECRET, NEXMO_NUMBER
 
 
nexmo_client = nexmo.Client(application_id=NEXMO_APPLICATION_ID, private_key=NEXMO_PRIVATE_KEY)
azure_auth_client = AzureAuthClient(MICROSOFT_TRANSLATION_SPEECH_CLIENT_SECRET)
 
conversation_id_by_phone_number = {}
call_id_by_conversation_id = {}
 
 
class CallHandler(web.RequestHandler):
    @web.asynchronous
    def get(self):
        self.write("Hello world")
 
 
class EventHandler(web.RequestHandler):
    @web.asynchronous
    def post(self):
        self.write("Hello world")
 
 
class WSHandler(websocket.WebSocketHandler):
    def open(self):
        print("WebSocket opened")
 
    def on_message(self, message):
        self.write_message(u"You said: " + message)
 
    def on_close(self):
        print("WebSocket closed")
 
 
def main():
    application = web.Application([
        (r"/event", EventHandler),
        (r"/ncco", CallHandler),
        (r"/socket", WSHandler),
    ])
 
    http_server = httpserver.HTTPServer(application)
    port = int(os.environ.get("PORT", 5000))
    http_server.listen(port)
    print("Running on port: " + str(port))
 
    ioloop.IOLoop.instance().start()
 
 
if __name__ == "__main__":
    main()
```

### 实现 CallHandler

为了将电话调用连接到 WebSocket 端点，Nexmo 的 Voice API 使用 **N**exmo **C**all **C**ontrol **O**bject (**NCCO**) 或 API 调用。当有人调用你的 Nexmo number 时，Nexmo 就会向你在设置 Nexmo Voice 应用程序时提供的 URL 发起 GET 请求。我们将应用程序指向服务器，服务器现在需要通过 `NCCO` 来响应这个请求。这个 `NCCO` 应该指示 Nexmo 给调用者发生一个简短的欢迎消息，然后将调用者连接到 WebSocket。

![Diagram that shows the interactions between a user, Nexmo, and the web server. When the user calls the Nexmo number, Nexmo sends a GET request to the web server's /ncco endpoint. The web server responds with an NCCO that instructs Nexmo to open a socket with the web server.](https://www.nexmo.com/wp-content/uploads/2018/03/NCCO.png)

显示用户、Nexmo 以及 web 服务器之间的交互图。当用户调用 Nexmo number 时，Nexmo 就会向 web 服务器/ncco 发送一个 GET 请求。web 服务器会指示 Nexmo 打开自身的 socket 来让 NCCO 进行响应。

接着将以下的 `NCCO` 保存到你项目中名为 `ncco.json` 的文件中。它包含执行请求动作所需的模版。但是，它也包括一些我们以后使用时需要替换的占位符变量（`$hostname`、`$whoami` 和 `$cid`）。

```
[
  {
    "action": "talk",
    "text": "Please wait while we connect you."
  },
  {
    "action": "connect",
    "eventUrl": [
      "http://$hostname/event"
    ],
    "from": "12345",
    "endpoint": [
      {
        "type": "websocket",
        "uri" : "ws://$hostname/socket",
        "content-type": "audio/l16;rate=16000",
        "headers": {
          "whoami": "$whoami",
          "cid": "$cid"
        }
      }
    ]
  }
]
```

在服务器模版中，以下再现部分设置了 `/ncco` 端点和 `CallHandler` 之间的映射。这个映射确保了在 `/ncco` 接收到 GET 请求时，`CallHandler` 的 get 方法由服务器执行。

```
application = web.Application([
    (r"/event", EventHandler),
    (r"/ncco", CallHandler),
    (r"/socket", WSHandler),
])
```

当服务器执行方法时，它会使用以下代码返回一个组装的 `NCCO`。首先，我们从 `data` 变量中查询（即 GET 请求）收集数据。我们还存储`conversation_uuid`，以便之后的使用。在这种情况下，有一个打印语句，可以在你测试服务器时看见 `conversation_uuid`。接下来，代码从我们创建的 `ncco.json` 文件中加载 `NCCO`。为了完成加载 `NCCO`，我们用从数据变量中手机的值替换占位符变量（`$hostname`、`$cid` 和 `$whoami`）。替换之后，我们已经准备好将其返回给 Nexmo 了。

将上述模版中的 `CallHandler` 替换为以下代码：

```
class CallHandler(web.RequestHandler):
    @web.asynchronous
    def get(self):
        data={}
        data['hostname'] = HOSTNAME
        data['whoami'] = self.get_query_argument('from')
        data['cid'] = self.get_query_argument('conversation_uuid')
        conversation_id_by_phone_number[self.get_query_argument('from')] = self.get_query_argument('conversation_uuid')
        print(conversation_id_by_phone_number)
        filein = open('ncco.json')
        src = Template(filein.read())
        filein.close()
        ncco = json.loads(src.substitute(data))
        self.write(json.dumps(ncco))
        self.set_header("Content-Type", 'application/json; charset="utf-8"')
        self.finish()
```

无论何时，只要有人调用 Nexmo number，Nexmo 就会向我们的 `/ncco` 端点发送 GET 请求，`CallHandler` 将组装并发送 `NCCO`。Nexmo 之后会执行 `NCCO` 中所设计的动作。在这种情况下，这意味着调用者会听到**“请稍侯，我们正在与你建立连接。”**之后，Nexmo 会尝试将调用连接到提供的 `socket` 端点。它也会提供了 Nexmo 要使用的 `event` 端点。如果你现在通过在终端窗口运行 `python main.py` 来启动服务器，你就会发现你能听到消息，但调用会在消息之后结束。这是因为我们没有实现 `EventHandler` 或 `WSHandler`。我们开始实现吧！

### 实现 EventHandler

`EventHandler` 处理 Nexmo 发送的时间。我们对任何调用都感兴趣，因此我们会检查任何请求，以确定其主体是否包含 `direction`，以及该目录是否为 `incoming`。如果是的话，我们会存储 uuid 并完成上下文请求。`call_id_by_conversation_id` 字典将用于 `WSHandler` 中调用方之间的消息路由。

用以下模版代码替换 `EventHandler`：

```
class EventHandler(web.RequestHandler):
    @web.asynchronous
    def post(self):
        body = json.loads(self.request.body)
        if 'direction' in body and body['direction'] == 'inbound':
            if 'uuid' in body and 'conversation_uuid' in body:
                call_id_by_conversation_id[body['conversation_uuid']] = body['uuid']
        self.content_type = 'text/plain'
        self.write('ok')
        self.finish()
```

### 实现 WSHandler

`CallHandler` 和 `EventHandler` 允许我们的应用程序来设置调用。`WSHandler` 现在将关注调用的音频流。语音的主调用者将通过语音翻译 API 转录并翻译，结果文本将由另一端的 Nexmo 语音说出。因此第二个人就可以用他们所明白的语言来倾听调用者的语音了，然后再作出响应。语言翻译 API 将依次翻译响应，以便第一格人可以听到他们的语言。这个工作流就是我们要实现的部分。

当 Nexmo Voice API 连接 WebSocket 时，Nexmo 会向端点发送一个初始化的 HTTP GET 请求。我们的服务器响应 HTTP 101 来切换协议，服务器之后会使用 TCP 连接 Nexmo。连接会通过 Tornado 来为我们处理升级。无论何时有人调用 Nexmo number，Nexmo 都会在调用期间打开 WebSocket。当 WebSocket 被打开并且最后被关闭时，Tornado 框架将调用下面的 `open` 和 `close` 方法。我们不需要在这两种情况下做任何事情，但我们会打印消息，这样我们就可以在服务器运行时跟踪掌握所发生的一切。

现在我们打开一个连接，Nexmo 会在 `on_message` 方法中处理我们发送的信息。我们从 Nexmo 收到第一个消息是带有元数据的纯文本。在收到这一消息后，我们会设置 `WSHandler` 的 `whoami` 属性，以便能识别发言人。之后，我们会创建一个我们发送到语音翻译 API 的 wave 标题。为了向语音翻译 API 发送消息，我们将创建一个 `translator_future`。根据调用者的不同，例如，消息来源，我们将使用相应的语言变量创建 `translator_future`，以便 API 了解从哪种语言翻译成哪种其他的语言。

`translator_future` 是连接到语音翻译 API 的另一个 WebSocket。我们使用它来传递我们从 Nexmo Voice API 接收到的消息。在它创建之后，`translator_future` 被存储在变量 `ws` 中，被用来发送我们之前创建的 wave 标题。来自 Nexmo 的每个后续消息都是二进制消息。这些二进制消息使用 `translator_future` 传递语音翻译 API，它会处理音频并返回转录的翻译。

当我们初始化 `translator_future` 时，我们声明语言翻译 API 处理我们时，它应该会调用 `speech_to_translation_completed` 方法。这个方法在接收到消息后，会检查消息是否为空，然后以消息接收语言语音出消息内容。它只会对其他调用者说出消息，而不是最初说话的人。此外，我们还会将翻译内容打印到终端。

将模版中的 `WSHandler` 替换为以下代码：

```
class WSHandler(websocket.WebSocketHandler):
    whoami = None
 
    def open(self):
        print("Websocket Call Connected")
 
    def translator_future(self, translate_from, translate_to):
        uri = "wss://dev.microsofttranslator.com/speech/translate?from={0}&to={1}&api-version=1.0".format(translate_from[:2], translate_to)
        request = httpclient.HTTPRequest(uri, headers={
            'Authorization': 'Bearer ' + azure_auth_client.get_access_token(),
        })
        return websocket.websocket_connect(request, on_message_callback=self.speech_to_translation_completed)
 
    def speech_to_translation_completed(self, new_message):
        if new_message == None:
            print("Got None Message")
            return
        msg = json.loads(new_message)
        if msg['translation'] != '':
            print("Translated: " + "'" + msg['recognition'] + "' -> '" + msg['translation'] + "'")
            for key, value in conversation_id_by_phone_number.iteritems():
                if key != self.whoami and value != None:
                    if self.whoami == CALLER:
                        speak(call_id_by_conversation_id[value], msg['translation'], VOICE2)
                    else:
                        speak(call_id_by_conversation_id[value], msg['translation'], VOICE1)
 
    @gen.coroutine
    def on_message(self, message):
        if type(message) == str:
            ws = yield self.ws_future
            ws.write_message(message, binary=True)
        else:
            message = json.loads(message)
            self.whoami = message['whoami']
            print("Sending wav header")
            header = make_wave_header(16000)
 
            if self.whoami == CALLER:
                self.ws_future = self.translator_future(LANGUAGE1, LANGUAGE2)
            else:
                self.ws_future = self.translator_future(LANGUAGE2, LANGUAGE1)
 
            ws = yield self.ws_future
            ws.write_message(header, binary=True)
 
    @gen.coroutine
    def on_close(self):
        print("Websocket Call Disconnected")
```

我们使用名为 `make_wave_header` 的函数来创建语言翻译 API 所期望的标题。用于创建 WAV 头的代码复制于 [Python-Speech-Translate](https://github.com/MicrosoftTranslator/Python-Speech-Translate) 项目，如下简介。

将 `make_wave_header` 函数复制到 `main.py` 文件末尾：

```
def make_wave_header(frame_rate):
    """
    Generate WAV header that precedes actual audio data sent to the speech translation service.
    :param frame_rate: Sampling frequency (8000 for 8kHz or 16000 for 16kHz).
    :return: binary string
    """
 
    if frame_rate not in [8000, 16000]:
        raise ValueError("Sampling frequency, frame_rate, should be 8000 or 16000.")
 
    nchannels = 1
    bytes_per_sample = 2
 
    output = StringIO.StringIO()
    output.write('RIFF')
    output.write(struct.pack('<L', 0))
    output.write('WAVE')
    output.write('fmt ')
    output.write(struct.pack('<L', 18))
    output.write(struct.pack('<H', 0x0001))
    output.write(struct.pack('<H', nchannels))
    output.write(struct.pack('<L', frame_rate))
    output.write(struct.pack('<L', frame_rate * nchannels * bytes_per_sample))
    output.write(struct.pack('<H', nchannels * bytes_per_sample))
    output.write(struct.pack('<H', bytes_per_sample * 8))
    output.write(struct.pack('<H', 0))
    output.write('data')
    output.write(struct.pack('<L', 0))
 
    data = output.getvalue()
    output.close()
 
    return data
```

最后，上述提及的 `speak` 函数其实是在 `nexmo_client` 方法 `send_speech` 周围的进行的简单封装。正如你在下面所看到的那样，它会打印打印一些在运行代码时可能对你有用的信息，然后使用 Nexmo API 指示 Nexmo 使用给定的 `voice_name` 来播放 `text`。

将下列 `speak` 函数复制到你的 `main.py` 文件末尾。

```
def speak(uuid, text, vn):
    print("speaking to: " + uuid  + " " + text)
    response = nexmo_client.send_speech(uuid, text=text, voice_name=vn)
    print(response)
```

## 结论

如果你一直是按照步骤做的，那么现在应该已经成功构建了自己的 Babel Fish！如果你没有遵循步骤，也可以在[这里](https://github.com/npentrel/babelfish)找到源代码。

通过在终端中输入 `python main.py` 来运行。现在和别人合作（或者使用两部手机）。从两条线上拨打你的 Nexmo 号码。你应该可以听到欢迎信息，然后就可以用你选择的两种语音进行交流了。

我们概括一下：我们首先配置了环境， Nexmo 应用程序和微软的语言翻译 API。然后构建了自己的 Tornado WebServer，它允许我们使用 WebSocket 来处理语音调用，可以将语音调用的语音传递给语音翻译 API。API 为我们翻译并转录语音。得到结果后，我们用新语言说出信息。我们的路由逻辑使得我们的服务可以处理双向调用，即我们的服务在连接两个调用者后，会先翻译任何一个人的语音以确保他们彼此可以选择彼此需要的语言来进行沟通。

我们现在做到了。我们正在运行的 Babel Fish！恐怕我们的 DIY Babel Fish 并不会像电影中的那样可爱，但这是一种可行性的选择。

如果你有任何疑问，请联系 [@naomi_pen](https://twitter.com/naomi_pen) 或在 [naomi.codes](http://naomi.codes/) 上找我。

### 下一步？

如果你对此有深入了解的兴趣，那么为什么不实现允许用户在调用开始时可以选择语言的逻辑呢？这种逻辑也可能会消除我们硬编码主要电话号码的必要性。对于一个有趣的项目来说，你也可以探索为电话会议工作以及为每个电话创建记录。最后，我设想你可能想要确保你自己服务的安全性以及不让任何人都有机会调用你的服务。你可以通过只允许某个号码（或多个）来使用你的服务，或者使用第二阶段的内部调用的逻辑来允许你邀请没有给定 Bable Fish 服务权限的用户。我很想知道你在 Twitter 上构建的内容 —— [@naomi_pen](https://twitter.com/naomi_pen)！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
