> * 原文地址：[11 Chrome APIs That Will Give Your Web App a Native Feel](https://blog.bitsrc.io/11-chrome-apis-that-give-your-web-app-a-native-feel-ad35ad648f09)
> * 原文作者：[Shanika Wickramasinghe](https://medium.com/@shanikanishadhi1992)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/11-chrome-apis-that-give-your-web-app-a-native-feel.md](https://github.com/xitu/gold-miner/blob/master/TODO1/11-chrome-apis-that-give-your-web-app-a-native-feel.md)
> * 译者：[Jessica](https://github.com/cyz980908)
> * 校对者：[niayyy-S](https://github.com/niayyy)，[Gesj-yean](https://github.com/Gesj-yean)

# 11 个能让你的 Web App 像原生 App 的 Chrome API

![](https://cdn-images-1.medium.com/max/2560/1*M4FLqVN1o0AVstiq1FmWdA.jpeg)

## 为什么要追求所谓的"原生体验"？

原生 App 更加稳定、运行速度更快，并且提供了许多 Web App 所缺乏的特性（可以说直到最近 Web App 依旧缺乏）。简而言之，通常原生 App 比 Web App 提供更好的用户体验。

当然，Web App 有其自身的优势 —— 它具有通用性，入门简单，而且始终是最新版本。此外，对我们开发人员来说更重要的是，它的性价比很高。

我们最好的解决方案不应该是两者之间的折中，而是“小孩子才做选择，我全都要”。

## 1. 短信服务接收

![来自：[https://web.dev/sms-receiver-api-announcement/](https://web.dev/sms-receiver-api-announcement/)](https://cdn-images-1.medium.com/max/2234/0*K3DcqnbwAiKsFJf9)

手机本质上是用于用户的通信和验证。对于在线交易，App 会通过短信向手机发送一次性密码（one-time password，OTP）来验证用户的手机号码。用户复制 OTP 并通过 Web 浏览器将其发送到相应的代理商。

用户每次的确认过程中都需要操作两次 OTP，搜索到验证码短信，复制最新的 OTP 是一项繁琐而又有风险的工作。而通过短信接收 API，可以直接将短信验证信息获取的 OTP 进行复制并验证，不需要用户自己进行复制粘贴操作。

一旦你收到一个有 OTP 的验证码短信，你会看到一个底页弹出，提示验证电话号码。点击应用上的“验证”，就会将 OTP 程序化地传输到浏览器，自动提交表单。使用短信接收 API 时，建议使用表单验证等附加安全层，为用户建立新的会话。

#### 该 API 如何使用：

1. 功能检测：对短信服务（SMS）对象进行功能检测判断。

```JavaScript
if ('sms' in navigator) {
  ...
}

```

2. 处理 OTP：接收方收到短信后，底部弹出带有验证按钮的页面。当用户点击验证按钮后，通过正则表达式提取 OTP 并验证用户。

```JavaScript
const code = sms.content.match(/^[\s\S]*otp=([0-9]{6})[\s\S]*$/m)[1];
```

3. 提交OTP：一旦检索到 OTP，就将其发送到服务器进行 OTP 验证。

![来自：[https://web.dev/sms-receiver-api-announcement/](https://web.dev/sms-receiver-api-announcement/)](https://cdn-images-1.medium.com/max/2000/0*Gjiw69Zc0oTeQkDG)

查看 Demo：
[**短信服务接收 API Demo**](https://sms-receiver-demo.glitch.me/)

## 2. 联系人选择器

![来自：[https://web.dev/contact-picker/](https://web.dev/contact-picker/)](https://cdn-images-1.medium.com/max/2000/0*IdpUhLkaa07MSVKj)

从移动设备的联系人列表中挑选联系人，是大多数移动设备用户认为理所当然的一个简单操作。然而，这并不是 Web App 上所能做到的，唯一的方法就是手动输入联系人的详细信息。

使用联系人选择 API，你可以毫不费力地从联系人列表中搜索联系人，选择并将其添加到 Web App 中的表单中。这是 Chrome 80 版本针对该需求提供的功能。联系人选择 API 允许用户选择一个或多个联系人，然后在浏览器中添加有限的详细信息。

有了它，你可以快速提取电子邮件、电话号码、姓名等联系人信息，用于多种用途。一些使用案例有：选择收件人的电子邮件进行 Web 端的邮件发送，选择收件人的电话号码进行 IP 语音通话，以及在 Facebook 上搜索联系人等。

Chrome 需要保护好你的所有联系信息和数据的安全。所以，在 App 中使用此 API 之前，请查看[安全和隐私条款](https://web.dev/contact-picker/#security-considerations)。

#### 该 API 如何使用：

这个 API 需要一个单独的调用，其中传入的参数是可选的。首先，确定该功能是否可用，对于 Windows，可以使用下面的代码。

```JavaScript
const supported = ('contacts' in navigator && 'ContactsManager' in window);

```

接着，使用 “navigator.contacts.select()” 打开“联系人选择器”，然后让用户选择想要分享的联系人，然后点击**完成**。API 返回一个可以显示选择和操作联系人的 `Promise`。

```JavaScript
const props = ['name', 'email', 'tel', 'address', 'icon'];
const opts = {multiple: true};
 
try {
  const contacts = await navigator.contacts.select(props, opts);
  handleResults(contacts);
} catch (ex) {
  // 在这里处理任何报错。
}

```

此外，你还需要处理这些 API 的报错。

观看此 Demo：
[**联系人选择 API Demo**](https://contact-picker.glitch.me/)

## 3.原生文件系统 API

![来自：[https://web.dev/native-file-system/](https://web.dev/native-file-system/)](https://cdn-images-1.medium.com/max/2000/0*Tdc9sdhDmrHaTEa4)

文件读取和写入是数字世界中的很常见的场景。现在，我们可以使用原生文件系统 API，构建与用户本地设备上的文件进行交互的 App。在用户的许可下，你可以允许他们选择文件，对文件进行修改并将其保存回设备存储中。

像 IDE、编辑器和文本文件等类型的文件可以被访问、修改和存储在磁盘上。在打开和保存文件之前，Web App 需要请求用户的许可。

在将文件写入磁盘时，用户可以对文件进行重命名。要修改磁盘上现有的文件时，用户需要授予额外的权限。系统文件和其他重要文件为了确保设备的安全和稳定，无法被访问。

1) 原生文件系统 API 可以用来打开一个目录并列出其中包含的内容。

2) 用户给出的修改现有文件或目录的权限可以被撤销。

3) 权限只在标签页打开的时间范围内有效。

一旦标签页被关闭，Web App 将失去用户所允许的权限。即使再次打开相同的 App，每次都需要提示获得许可。原生文件系统 API 在原始试用版（Origin Trials）中可用，你可以使用这个试用版的原生文件系统 API 工作。

在使用此 API 之前，请查看其[安全性和权限](https://web.dev/native-file-system/#security-considerations)。

#### 该 API 如何使用：

1. 首先在 chrome://flags 中启用 native-file-system-api 标志。

2. 在这个[链接](https://developers.chrome.com/origintrials/#/view_trial/3868592079911256065)中申请一个令牌，将其添加到页面中。

`<meta http-equiv=”origin-trial” content=”TOKEN_GOES_HERE”>` 或者 `Origin-Trial: TOKEN_GOES_HERE`.

API 开启后，使用 `window.chooseFileSystEmentries()` 来让用户选择要编辑的文件。然后从系统中获取文件并读取。

```JavaScript
const file = await fileHandle.getFile();
const contents = await file.text();

```

文件保存后，通过 chooseFileSystemEnteries 设置类型为 `saveFile`。

```JavaScript
function getNewFileHandle() {
  const opts = {
	type: 'saveFile',
	accepts: [{
  	description: 'Text file',
  	extensions: ['txt'],
	  mimeTypes: ['text/plain'],
    }],
  };
  const handle = window.chooseFileSystemEntries(opts);
  return handle;
}

```

之后将所有的修改内容保存到文件中。

```JavaScript
async function writeFile(fileHandle, contents) {
  // 创创建一个 writer（必要时需要请求许可）。
  const writer = await fileHandle.createWriter();
  // 写入内容
  await writer.write(0, contents);
  // 关闭文件并将内容写入磁盘
  await writer.close();
}

```

应用需要权限才能将内容写入磁盘。获取到写入权限后，调用 `FileSystemWriter.Writer()` 来写入内容。之后使用 `close()` 方法关闭 `FileSystemSWriter()`。

查看 Demo：

[**文本编辑器**](https://googlechromelabs.github.io/text-editor/)

## 4. 图形检测 API

现在，你可以使用图形检测 API 在 Web App 中捕捉人脸。借助基于浏览器的 API 以及 Android 中的 Chrome 浏览器，你可以通过设备摄像头轻松捕捉图像或实时视频。并且它在硬件层面与 Android、iOS 和 macOS 系统的集成，可以在不影响应用性能的情况下访问设备摄像头模块。

这些是通过一组 JavaScript 库来实现的。支持的功能包括人脸检测、条形码检测等。在 Web App 中的人脸识别可以使你：

* 在社交媒体上对人物进行注解 —— 它将突出显示图像中检测到的人脸的边界，以方便注释。
* 内容网站可以准确地裁剪包括特定对象在内的高亮站点的图像。
* 在突出显示的人脸上叠加对象的操作可以很容易地完成。

#### 该 API 如何使用：

功能检测：检查图形检测的构造函数是否存在。

```JavaScript
const supported = await (async () => 'FaceDetector' in window &&
    await new FaceDetector().detect(document.createElement('canvas'))
    .then(_ => true)
    .catch(e => e.name === 'NotSupportedError' ? false : true))();
```

这些检测是异步工作的，所以需要一些时间来检测人脸。

## 5. Web 支付 API

Web 支付 API 遵循 Web 支付标准。它简化了在线支付的流程，适用于各种支付系统、浏览器和设备类型。支付请求 API 可以在多种浏览器上使用，包括 Chrome、Edge、Safari 和 Mozilla。它加速了商家和用户之间的支付流。商家可以用最少的花费整合各种支付方式。

Web 支付 API 的工作基于以下三个原则：

1. 标准且开放：提供了一个任何人都可以实现的通用标准。
2. 简单且一致：通过恢复付款细节和需要在付款表单中填写的地址，为用户提供方便的付款体验。
3. 安全且灵活：为许多支付流提供行业领先的安全性和灵活性。

#### 该 API 如何使用：

要使用此 API，请调用 hasEnrolledInstrument() 方法并检查设备是否存在。

```JavaScript
// 检查 支付 App 的可用性，而不检查设备的存在。
if (request.hasEnrolledInstrument) {
  // `canMakePayment()` 里的具体行为会根据
  // `hasEnrolledInstrument()` 是否可用而变化。
  request.canMakePayment().then(handlePaymentAppAvailable).catch(handleError);
} else {
  console.log("Cannot check for payment app availability without checking for instrument presence.");
}

```

## 6. 唤醒锁 API

![来自：[https://web.dev/wakelock/](https://web.dev/wakelock/)](https://cdn-images-1.medium.com/max/2000/0*zJuBNN-nn9Xx5NwU)

许多类型的设备被设定为在空闲或未使用状态下自动休眠。虽然这在不使用时很好，但当用户使用屏幕时，设备关闭并锁定屏幕，就会很烦人。

唤醒锁API有两种类型：屏幕和系统。当应用在屏幕上运行时，屏幕唤醒锁可以防止设备关闭它，系统唤醒锁可以防止设备的 CPU 进入待机模式。

页面可见性和全屏模式负责激活或释放唤醒锁。屏幕上的变化（例如进入全屏模式，最小化当前窗口或从选项卡切换开）将释放唤醒锁。

#### 该 API 如何使用：

要使用此功能，请为你的源获取一个[令牌](https://developers.chrome.com/origintrials/#/view_trial/902971725287784449)，将该令牌添加到你的页面中。

`<meta http-equiv=”origin-trial” content=”TOKEN_GOES_HERE”>` 或者 `Origin-Trial: TOKEN_GOES_HERE`

除了使用令牌，你还需要确保 chrome://flags 页面中的 `#experimental-web-platform-features` 标志位开启。

要请求唤醒锁，请调用 `navigator.wavelock.request()` 方法来返回一个 `WakeLockSentinel` 对象。并将这个调用添加到 `try...catch` 块中。要释放唤醒锁，请调用 `wavelocksentinel` 的 `release()` 方法。

```JavaScript
// 唤醒锁.
let wakeLock = null; 
// 试图请求唤醒锁的函数。
const requestWakeLock = async () => {
  try {
	wakeLock = await navigator.wakeLock.request('screen');
	wakeLock.addEventListener('release', () => {
  	console.log('Wake Lock was released');
	});
	console.log('Wake Lock is active');
  } catch (err) {
	console.error(`${err.name}, ${err.message}`);
  }
}; 
// 请求唤醒锁……
await requestWakeLock();
// 并在 5 秒后再次释放。
window.setTimeout(() => {
  wakeLock.release();
  wakeLock = null;
}, 5000);
```

唤醒锁有一个生命周期，并且对页面可见性和全屏模式很敏感。所以在请求唤醒锁之前检查这些状态。

```JavaScript
const handleVisibilityChange = () => {
  if (wakeLock !== null && document.visibilityState === 'visible') {
	requestWakeLock();
  }
};
document.addEventListener('visibilitychange', handleVisibilityChange);
document.addEventListener('fullscreenchange', handleVisibilityChange);
```

查看 Demo：

[**唤醒锁 API Demo**](https://wake-lock-demo.glitch.me/)

## 7. Service worker 和 Cache 缓存 API

浏览器的缓存曾经是重新加载网页的旧内容的唯一方法，但是现在你可以使用 Service worker 和 cache 缓存 API 来更好地控制这个过程。

Service worker 是一个 JavaScript 文件，用于拦截网络请求、执行缓存并通过推送传递消息。它们独立于主线程，在后台运行。

使用 cache 缓存 API，开发人员可以决定和控制浏览器缓存的内容。它遵循代码驱动的方法来存储缓存，并从 Service worker 中调用。你可以使用 cache-control 头来配置 cache 缓存 API。

需要清除设置的 Cache-Control 才能访问版本化和未版本化的 URL。如果将版本化的 URL 添加到 cache 缓存中，浏览器会避免对这些 URL 进行额外的网络请求。

HTTP缓存、Service worker 和缓存存储 API 的组合可以使开发人员这样做：

1. 在浏览器后台重新请求缓存的内容。
2. 对要缓存的最大资产数设置上限。
3. 添加自定义过期策略。
4. 比较缓存和网络响应。

## 8. 异步剪贴板 API

![来自：[https://web.dev/image-support-for-async-clipboard/](https://web.dev/image-support-for-async-clipboard/)](https://cdn-images-1.medium.com/max/2000/0*eziEHL8pSojXJ_F_)

异步剪贴板 API 可用于复制图像并将其粘贴到浏览器中。需要复制的图像会被存储为一个 **Blob** 对象。因此，在每次需要复制图像时是不会向服务器发出的请求。

现在，可以直接从剪贴板中使用 HTMLCanvasElement.toBlob() 将图像写入 Web 表单上的画布元素。虽然目前只能复制一个图像，但将来的版本将允许同时复制多个图像。粘贴图像时，API 在剪贴板中会以基于 Promise 的异步方式对其进行更新。

自定义的粘贴处理程序和自定义的复制处理程序允许你可以处理图像的粘贴和复制事件。在 Chrome 上复制和粘贴图像的一个主要问题是访问图像“压缩炸弹”。这是指一些大型的压缩过的图像文件，一旦解压缩，就无法在 Web 表单上处理。这些图像也可以是恶意图像，有可能会利用操作系统中已知的漏洞来进行破坏。

#### 该 API 如何使用：

首先，我们需要一个为 Blob 对象的图像，它是通过调用 fetch() 方法从服务器请求的，我们再将返回类型设置为 blob。然后传递一个 clipboarditem 数组来调用 wirte() 方法。

```JavaScript
try {
  const imgURL = '/images/generic/file.png';
  const data = await fetch(imgURL);
  const blob = await data.blob();
  await navigator.clipboard.write([
	new ClipboardItem({
  	[blob.type]: blob
	})
  ]);
  console.log('Image copied.');
} catch(e) {
  console.error(e, e.message);
}

```

在粘贴时，navigator.Clipboard.read() 用于迭代剪贴板对象并读取项。

```JavaScript
async function getClipboardContents() {
  try {
	const clipboardItems = await navigator.clipboard.read();
	for (const clipboardItem of clipboardItems) {
  	try {
    	for (const type of clipboardItem.types) {
      	const blob = await clipboardItem.getType(type);
      	console.log(URL.createObjectURL(blob));
    	}
  	} catch (e) {
    	console.error(e, e.message);
  	}
	}
  } catch (e) {
	console.error(e, e.message);
  }
}
```

该 API 如何使用：

[**支持异步剪贴板 API 的图像**](https://web.dev/image-support-for-async-clipboard/#demo)

## 9. Web 目标共享 API

![来自：[https://web.dev/web-share-target/](https://web.dev/web-share-target/)](https://cdn-images-1.medium.com/max/2000/0*6G_C2tZdB3rCYvNY)

移动 App 上与其他电子设备或用户共享文件非常简单，只需点击几下鼠标即可。Web 共享目标 API 可以使你在 Web App 上也能完成相同的操作。

要使用此功能，你需要：

1. 将 App 注册为共享目标。
2. 使用目标分享更新 Web App 的 manifest。
3. 添加目标应用要接收的基本信息。数据、链接、文本等信息可以添加到 JSON 文件中。
4. 接受在共享目标中应用的更改。这将允许在目标应用中进行数据更改，比如在应用中创建书签或接受文件请求。
5. 通过处理获取共享和发布共享来处理进入的内容。

下面的代码展示了如何创建 manifest.json，用于接收基本信息文件。

```JSON
"share_target": {
  "action": "/share-target/",
  "method": "GET",
  "params": {
	"title": "title",
	"text": "text",
	"url": "url"
  }
}
```

## 10. 定期向后台同步 API

原生应用在获取新数据方面做得很好，即使在连通性不令人满意的情况下也是如此。最新时间的文章和新闻会不断更新。定期的后台同步 API 为 Web App 提供了类似的功能。它使得 Web App 能够定期地同步数据。

该 API 在后台同步数据，因此 Web App 在启动或重新启动时不会获取数据。这减少了页面加载时间并优化了性能。

考虑到每个开发人员使用这个 API 的可能性都很高，并且它会导致电池和网络资源的滥用，Chrome 设计了一种限制其使用的方法。它不会对每个浏览器选项卡都开放，而是通过一个站点参与度评分来管理，这将确保该 API 只在用户正在积极参与的选项卡上活动。

下面的代码是一个用于更新新闻站点文章的定期后台同步的示例。

```JavaScript
async function updateArticles() {
  const articlesCache = await caches.open('articles');
  await articlesCache.add('/api/articles');
}

self.addEventListener('periodicsync', (event) => {
  if (event.tag === 'update-articles') {
	event.waitUntil(updateArticles());
  }
});
```

## 结论

用户在使用 App 时，会期望 Web App 具有与原生 App 相同的功能。如果没有，用户就会拒绝使用该 App 或寻找其他的替代方案。因此，Chrome API 对开发者来说是一个非常需要的好东西。

不过，需要注意的是，这些 API 还是有一些使用的限制。开发者需要注意这些，这样才能提供完美的 App 体验。简单地会调用每一个 API 都是没有价值和作用的。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
