> * 原文地址：[11 Chrome APIs That Will Give Your Web App a Native Feel](https://blog.bitsrc.io/11-chrome-apis-that-give-your-web-app-a-native-feel-ad35ad648f09)
> * 原文作者：[Shanika Wickramasinghe](https://medium.com/@shanikanishadhi1992)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/11-chrome-apis-that-give-your-web-app-a-native-feel.md](https://github.com/xitu/gold-miner/blob/master/TODO1/11-chrome-apis-that-give-your-web-app-a-native-feel.md)
> * 译者：
> * 校对者：

# 11 Chrome APIs That Will Give Your Web App a Native Feel

#### 11 Chrome APIs that will give your web app a native-like user experience.

![](https://cdn-images-1.medium.com/max/2560/1*M4FLqVN1o0AVstiq1FmWdA.jpeg)

## Why aim for a “native feel” ?

Native apps are more stable, faster and offer many features that web apps are lacking (or at least were lacking up until lately). In short — native apps, generally speaking, offer a better UX than their webby counterpart.

Of course, web apps have their own advantages — they are universal, require minimal effort to get started with, always-up-to-date and most importantly for us as developers, they are cost-effective.

The solution should not be a compromise between the two but the best of both worlds.

## 1. SMS Receiver

![Source: [https://web.dev/sms-receiver-api-announcement/](https://web.dev/sms-receiver-api-announcement/)](https://cdn-images-1.medium.com/max/2234/0*K3DcqnbwAiKsFJf9)

Mobiles are essentially used for communication and verification of users. For online transactions, mobile phones are verified with a one-time password (OTP ) sent by SMS to their phone numbers. Users copy the OTP and send it over the web browser to the respective agency.

Users need to provide the OTP twice to confirm each process, searching for the SMS, and copying the latest OTP is a tedious and risky task. The SMS receiver app allows you to copy the OTP obtained via the SMS verification message and verifies it.

Once you receive an OTP as SMS, you see a bottom sheet popping up, prompting verification of the phone number. Clicking verify on the SMS receiver app will programmatically transfer the OTP to the browser, and the form will be submitted automatically. Along with SMS Receiver API, it is recommended to use an additional layer of security like form authentication to establish new sessions for users.

#### How the API Works:

1. Feature Detection: Feature detection is enabled for the SMS object.

```JavaScript
if ('sms' in navigator) {
  ...
}

```

2. Process OTP: Once the receiver receives the SMS, a bottom sheet is displayed with the verify button. When the user clicks it, a regular expression is used to extract the OTP and verify the user.

```JavaScript
const code = sms.content.match(/^[\s\S]*otp=([0-9]{6})[\s\S]*$/m)[1];
```

3. Submitting the OTP: Once the OTP is retrieved, it will be sent to the server for OTP verification.

![Source: [https://web.dev/sms-receiver-api-announcement/](https://web.dev/sms-receiver-api-announcement/)](https://cdn-images-1.medium.com/max/2000/0*Gjiw69Zc0oTeQkDG)

Check out this demo:
[**SMS Receiver API Demo**](https://sms-receiver-demo.glitch.me/)

## 2. Contact Picker

![source: [https://web.dev/contact-picker/](https://web.dev/contact-picker/)](https://cdn-images-1.medium.com/max/2000/0*IdpUhLkaa07MSVKj)

Picking a contact from your mobile devices contact list is a simple action that most mobile device users take for granted. However, this is not something that is available on web apps, and the only way to enter details of contact was to type it in manually.

Using the contact picker API, you can effortlessly search for a contact from the contact list, select it and add it to a form in a web app. This is an on-demand feature that is available from Chrome 80. The contact picker API allows users to select one or more contacts and then adds limited details in the browser.

You can now have contact information like email, phone number, and name extracted quickly for many purposes. Some use cases are selecting the recipient’s email for web-based client mail, picking the recipient’s phone number to make a voice-over-IP call, and search for a contact on Facebook.

Chrome makes sure to secure all your contact details and data. Review the [Security and Privacy](https://web.dev/contact-picker/#security-considerations) before using this API in applications.

#### How API Works :

This API needs a single call with optional parameters mentioned. First, identify if the feature is available. forWindows, you can use the following code.

```JavaScript
const supported = ('contacts' in navigator && 'ContactsManager' in window);

```

Next, open the Contact Picker using “navigator.contacts.select()”. then let the user select the contacts they want to share and click **DONE.** The API uses the promise to show the contacts to select and display operations.

```JavaScript
const props = ['name', 'email', 'tel', 'address', 'icon'];
const opts = {multiple: true};
 
try {
  const contacts = await navigator.contacts.select(props, opts);
  handleResults(contacts);
} catch (ex) {
  // Handle any errors here.
}

```

Additionally, you need to handle the errors for these API.

Check out this demo:
[**Contact Picker API Demo**](https://contact-picker.glitch.me/)

## 3. Native File system API

![source: [https://web.dev/native-file-system/](https://web.dev/native-file-system/)](https://cdn-images-1.medium.com/max/2000/0*Tdc9sdhDmrHaTEa4)

File reading and writing is a common scenario in the digital world. Using the Native File system API, we can now build apps that interact with files on the user’s local device. With the user’s permission, you can allow them to select a file, modify it, and save it back to the device storage.

Files like IDE, editors, and text files can be accessed, changed, and stored on the disk in this manner. Before opening and storing the file, the Web app will be required to request the user for permission.

When writing files to disk, users are allowed to select a different name for them. To modify the existing file on disk, the user needs to grant additional permissions. System files and other important documents are not accessible to ensure the security and stability of the device.

1) The Native file system API can be used to open a directory and enumerate its contents.

2) Permission given by a user to modify existing files or directories can be revoked.

3) Permission persists only until the tab is open.

Once a tab is closed, the web app loses the permissions allowed by the user. Even if the same app is used again, it will be required to prompt for permission each time. The Native File system API is available as an Origin Trial, this allows you to work with the trial version of Native file system API.

Before using this API, please look at its [security and permissions](https://web.dev/native-file-system/#security-considerations).

#### How API Works :

1. First enable the native-file-system-api flag in chrome://flags.

2. Request a token to add it to the page from this [link](https://developers.chrome.com/origintrials/#/view_trial/3868592079911256065).

`<meta http-equiv=”origin-trial” content=”TOKEN_GOES_HERE”>` OR `Origin-Trial: TOKEN_GOES_HERE`.

Once API is running, allow the user to choose the file to be edited using window.chooseFileSystEmentries(). Next, get the file from the system and read it.

```JavaScript
const file = await fileHandle.getFile();
const contents = await file.text();

```

Once the file is saved, set the type: `saveFile` to chooseFileSystemEnteries.

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

Later save the changes to a file.

```JavaScript
async function writeFile(fileHandle, contents) {
  // Create a writer (request permission if necessary).
  const writer = await fileHandle.createWriter();
  // Write the full length of the contents
  await writer.write(0, contents);
  // Close the file and write the contents to disk
  await writer.close();
}

```

apps need permission to write the content to the disk. Once the permission is granted to write, call FileSystemWriter.Writer(). Later use close() method to close the FileSystemSWriter()

Check out this demo:

[**Text Editor**](https://googlechromelabs.github.io/text-editor/)

## 4. Shape Detection API

You can now capture faces in web apps using the shape detection API. The browser-based API and Chrome for Android make it easy to capture images or live videos via the device camera. Integrations with the Android, iOS, and macOS systems at the hardware level allow access to the device camera module without affecting performance.

These implementations are exposed through a set of JavaScript libraries. Supported features include Face Detection, barcode detection, among others. Face detection in web apps will allow you to:

* Annotate people on social media — It will highlight the boundaries of the detected face in the image to facilitate the annotation.
* Content sites can accurately crop images along with highlighted sites that include specific objects.
* Overlaying objects on highlighted faces can be easily done.

#### How API Works :

Feature detection: Check the existence of constructors to feature shape detection.

```JavaScript
const supported = await (async () => 'FaceDetector' in window &&
    await new FaceDetector().detect(document.createElement('canvas'))
    .then(_ => true)
    .catch(e => e.name === 'NotSupportedError' ? false : true))();

```

These detectors work async, so they need some time to detect the face.

## 5. Web Payments API

The Web payments API works along the lines of Web payments web standards. It simplifies online payments and works on various payment systems, browsers, and device types. The Payment Request API is available on multiple browsers, Chrome, Edge, Safari, and Mozilla. It facilitates the payment flow between merchants and users. A merchant can integrate various payment methods with minimal effort.

The Web Payments API works based on three principles:

1. Standard and Open: Provides a universal standard that can be implemented by anyone.
2. Easy and consistent: Provides a convenient checkout experience for users by restoring the payment details and address that needs to be filled in checkout forms.
3. Secure and Flexible: Provides industry-leading security with flexibility for many payment flows.

#### How API Works:

To use this API, call hasEnrolledInstrument() method and check for instrument presence.

```JavaScript
// Checking for payment app availability without checking for instrument presence.
if (request.hasEnrolledInstrument) {
  // `canMakePayment()` behavior change corresponds to
  // `hasEnrolledInstrument()` availability.
  request.canMakePayment().then(handlePaymentAppAvailable).catch(handleError);
} else {
  console.log("Cannot check for payment app availability without checking for instrument presence.");
}

```

## 6. Wake Lock API

![Source: [https://web.dev/wakelock/](https://web.dev/wakelock/)](https://cdn-images-1.medium.com/max/2000/0*zJuBNN-nn9Xx5NwU)

Many types of devices are programmed to sleep when in an idle or unused state. While this is fine when not in use, it can be annoying when users are engaged with the screen, and the device turns off and locks the screen.

There are two types of wake lock APIs — screen and system. While an app is running on the screen, the screen wake lock prevents the device from turning it off, and the system wake lock prevents the device’s CPU from going into standby mode.

Page visibility and fullscreen mode are responsible for activating or releasing the wake lock. Changes in the screen like entering full-screen mode, minimizing the current window, or switching away from a tab will release the wake lock.

#### How API Works :

To avail this feature, get a [token](https://developers.chrome.com/origintrials/#/view_trial/902971725287784449) for your origin. Add that token to your page.

`<meta http-equiv=”origin-trial” content=”TOKEN_GOES_HERE”>` Or `Origin-Trial: TOKEN_GOES_HERE`

Instead of using the token, you can enable it using #experimental-web-platform-features flag in chrome://flags.

To request a wake lock, call navigator.wavelock.request() method that returns a WakeLockSentinel object. Excapuslate the call in try…catch block. To release the wake lock, call release() method of wavelocksentinel.

```JavaScript
// The wake lock sentinel.
let wakeLock = null; 
// Function that attempts to request a wake lock.
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
// Request a wake lock…
await requestWakeLock();
// …and release it again after 5s.
window.setTimeout(() => {
  wakeLock.release();
  wakeLock = null;
}, 5000);

```

The Wake lock has a life cycle and is sensitive to page visibility and full-screen mode. Check for these states before requesting a wakelock.

```JavaScript
const handleVisibilityChange = () => {
  if (wakeLock !== null && document.visibilityState === 'visible') {
	requestWakeLock();
  }
};
document.addEventListener('visibilitychange', handleVisibilityChange);
document.addEventListener('fullscreenchange', handleVisibilityChange);

```

Check out this demo:
[**Wake Lock Demo**](https://wake-lock-demo.glitch.me/)

## 7. Service workers and the Cache Storage API

The browser’s cache used to be the only way to reload older content of a website, but now you can use service workers and cache storage API to have better control of this process.

A service worker is a JavaScript file that runs to intercept network requests, perform caching, and deliver messages by pushing. They are independent of the main thread and run in the background.

Using the cache storage API, developers can decide and control the contents of the browser cache. It follows a code-driven approach to store cache and is called from a service worker. You can configure the cache storage API with cache-control headers.

The setting Cache-Control needs to be cleared for accessing the versioned and unversioned URL’s. If versioned URLs are added to the cache storage, additional network requests are avoided for these URLs by the browser.

A combination of HTTP cache, service worker, and the cache storage API can allow developers to:

1. Reload cached content in the background.
2. Impose a cap on the maximum number of assets to be cached.
3. Add a custom expiration policy.
4. Compare cached and network responses.

## 8. Asynchronous clipboard API

![source: [https://web.dev/image-support-for-async-clipboard/](https://web.dev/image-support-for-async-clipboard/)](https://cdn-images-1.medium.com/max/2000/0*eziEHL8pSojXJ_F_)

The Async clipboard API can be used to copy images and paste them in the browser. The image that needs to be copied is stored as a ‘Blob’. Making a request to a server each time an image needs to be copied is not feasible.

Now, images can be written to a canvas element on a web form by using HTMLCanvasElement.toBlob() directly from the clipboard. While only a single image can be copied at present, a future release will enable copying multiple images simultaneously. To paste an image, the API iterates over it in the clipboard in a promise-based asynchronous manner.

The custom paste handler and custom copy handler allow you to handle paste and copy events for images. A major concern of copying and pasting images on Chrome is accessing image compressed bombs. These are large compressed image files that are too large to be handled on a web form once decompressed. They can also be malicious images that can exploit known vulnerabilities in the operating system.

#### How API Works :

First, we need an image as a blob, that is requested from the server by calling fetch() and set the return type as blob. Then pass an array of clipboarditem to write() method.

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

While pasting the navigator, Clipboard.read() is used to iterate the clipboard objects and read the items.

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

Check out this demo:
[**Image support for the async clipboard API**](https://web.dev/image-support-for-async-clipboard/#demo)

## 9. Web Share Target API

![Source: [https://web.dev/web-share-target/](https://web.dev/web-share-target/)](https://cdn-images-1.medium.com/max/2000/0*6G_C2tZdB3rCYvNY)

Mobile apps make sharing files with other devices and users as easy as a few clicks. The Web share target API allows you to do the same on web apps.

To use this feature, you need to:

1. Register the app as a shared target.
2. Update the web app manifest with the shared target.
3. Add the basic information for the target app to accept. Information like data, links, text can be added in the JSON file.
4. Accept Application changes in the shared target. This will allow data changes in the target app, like creating a bookmark in an app or accepting a file request.
5. Handle incoming content by processing GET shares and POST shares.

The following code shows how you can create the manifest.json file for accepting basic information.

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

## 10. Periodic Background Sync API

Native apps do well in fetching fresh data, even when connectivity is not satisfactory. Time-sensitive things like articles and news are continually being updated. The periodic background sync API offers similar functionality for web apps. It enables the web app to synchronize data periodically.

The API synchronizes data in the background so that the web app does not fetch data while it is launched or relaunched. This reduces page load time and optimizes performance.

Given the high likeliness of this API being used by every developer and it leading to misuse of battery and network resources, Chrome has devised a way of restricting its use. It will not be openly available for every browser tab, but be regulated via a site engagement score, which will ensure that the API will only be active on tabs that are actively being engaged by users.

The following code is an example of periodic background sync to update the article for a news site.

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

## Conclusion

Users expect web applications to have the same capabilities as their native application counterparts. Without similar behavior, users will reject apps or find alternatives. As such, Chrome APIs come as a much-needed benefit for developers.

However, it is important to understand that there are certain restrictions that apply. Developers need to pay attention to these in order to provide a seamless experience. Simply implementing every API will not be worthwhile or useful.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
