
> * 原文地址：[Offline-Friendly Forms](https://mxb.at/blog/offline-forms/)
> * 原文作者：[mxbck](https://twitter.com/intent/follow?screen_name=mxbck)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/offline-friendly-forms.md](https://github.com/xitu/gold-miner/blob/master/TODO/offline-friendly-forms.md)
> * 译者：[sunui](https://github.com/sunui)
> * 校对者：[yanyixin](https://github.com/yanyixin)、[Tina92](https://github.com/Tina92)

# 离线友好的表单

网络不佳时网页表单的表现通常并不理想。如果你试图在离线状态下提交表单，那就很可能丢失刚刚填好的数据。下面就看看我们是如何修复这个问题的。

太长，勿点：这里是本文的 [CodePen Demo](https://codepen.io/mxbck/pen/ayYGGO/)。

随着 Service Workers 的推行，现在开发者们甚至可以实现离线版的网页了。静态资源的缓存相对容易，而像表单这样需要服务器交互的情况就很难优化了。即使这样，提供一些有用的离线回退方案还是有可能的。

首先，我们为离线友好的表单创建一个新的类。接着我们保存一些 `<form>` 元素的属性然后绑定一个触发 submit 事件的函数：

```
class OfflineForm {
  // 配置实例。
  constructor(form) {
    this.id = form.id;
    this.action = form.action;
    this.data = {};
    
    form.addEventListener('submit', e => this.handleSubmit(e));
  }
}
```

在 submit 处理函数中，我们使用 `navigator.onLine` 属性内置一个简单的网络检查器。[浏览器对它的支持](http://caniuse.com/online-status/embed/)很好，而且实现它也不难。

⚠️ 但它还是有一定[误报](https://developer.mozilla.org/en-US/docs/Web/API/NavigatorOnLine/onLine)的可能，因为这个属性只能检查客户端是否连接到网络，而不能检测实际的网络连通性。另一方面，一个 `false` 值意味着“离线”是相对确定的。因此，比起其他方式这个判断方法是最好的。

如果一个用户当前处于离线状态，我们就暂停表单的提交，把数据存储在本地。

```
handleSubmit(e) {
  e.preventDefault();
  // 解析表单输入，存储到对象中
  this.getFormData();
  
  if (!navigator.onLine) {
    // 用户离线，在设备中存储数据
    this.storeData();
  } else {
    // 用户在线，通过 ajax 发送数据 
    this.sendData();
  }
}
```

## 存储表单数据

存储数据到用户设备有[几种不同的方式](https://developer.mozilla.org/en-US/docs/Web/API/Storage)。根据数据的不同，如果你不希望本地副本持久存储在内存中，可以使用 `sessionStorage`。在我们的例子中，我们可以一起使用  `localStorage`。

我们可以给表单数据附上时间戳，把它赋值给一个新的对象，并且使用 `localStorage.setItem` 保存。这个方法接受两个参数：**key**（表单 id）和 **value**（数据的 JSON 串）。

```
storeData() {
  // 检测 localStorage 是否可用
  if (typeof Storage !== 'undefined') {
    const entry = {
      time: new Date().getTime(),
      data: this.data,
    };
    // 把数据存储为 JSON 串
    localStorage.setItem(this.id, JSON.stringify(entry));
    return true;
  }
  return false;
}
```

提示：你可以在 Chrome 的开发者工具 “Application” 中查看存储数据。如果不出差错，你可以看到内容如下：

![](https://mxb.at/blog/offline-forms/devtools.png)

通知用户发生了什么也是个好主意，这样他们会知道他们的数据不会丢失。我们可以扩展 `handleSubmit` 函数来显示某些反馈信息。

![](https://mxb.at/blog/offline-forms/message.png)

多么周到的表单！

## 检查保存的数据

一旦用户联网，我们想检查一下是否有被存储的提交。我们可以监听 `online` 事件来捕获网络链接的改变，还有页面刷新时的 `load` 事件：

```
constructor(form){
  ...
  window.addEventListener('online', () => this.checkStorage());
  window.addEventListener('load', () => this.checkStorage());
}
```

```
checkStorage() {
  if (typeof Storage !== 'undefined') {
    // 检测我们是否在 localStorage 之中存储了数据
    const item = localStorage.getItem(this.id);
    const entry = item && JSON.parse(item);

    if (entry) {
      // 舍弃超过一天的提交。 （可选）
      const now = new Date().getTime();
      const day = 24 * 60 * 60 * 1000;
      if (now - day > entry.time) {
        localStorage.removeItem(this.id);
        return;
      }

      // 我们已经验证了表单数据，尝试提交它
      this.data = entry.data;
      this.sendData();
    }
  }
}
```

一旦我们成功提交了表单，那最后一步就是移除 `localStorage` 中的数据，来避免重复提交。假设是一个 ajax 表单，我们可以在服务器响应成功的回调里做这件事。很简单，这里我们可以使用 storage 对象的 `removeItem()` 方法。

```
sendData() {
  // 向服务器发送 ajax 请求
  axios.post(this.action, this.data)
    .then((response) => {
      if (response.status === 200) {
        // 成功时移除存储的数据
        localStorage.removeItem(this.id);
      }
    })
    .catch((error) => {
      console.warn(error);
    });
}
```

如果你不想使用 ajax 提交，另一个方案是将存储的数据回填到表单，然后调用 `form.submit()` 或让用户自己点击提交按钮。

☝️ 注意：简单起见，我在这个案例中省略了一些其他部分，比如表单验证和安全 token 验证等，这些东西在真正的生产环境是必不可少的。这里的另一个问题是处理敏感数据，就是说你不能在本地存储一些密码或者信用卡数据等私密信息。

如果你感兴趣，请查阅 [CodePen 上的全部示例](https://codepen.io/mxbck/pen/ayYGGO)。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
