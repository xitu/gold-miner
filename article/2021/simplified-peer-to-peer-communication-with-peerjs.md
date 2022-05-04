> * 原文地址：[Simplified Peer to Peer Communication with PeerJS](https://blog.bitsrc.io/simplified-peer-to-peer-communication-with-peerjs-e37244267723)
> * 原文作者：[Dulanka Karunasena](https://medium.com/@dulanka)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/simplified-peer-to-peer-communication-with-peerjs.md](https://github.com/xitu/gold-miner/blob/master/article/2021/simplified-peer-to-peer-communication-with-peerjs.md)
> * 译者：[tong-h](https://github.com/Tong-H)
> * 校对者：[jaredliw](https://github.com/jaredliw)，[CarlosChenN](https://github.com/CarlosChenN)

# 使用 PeerJS 轻松实现 P2P 通信

![](https://cdn-images-1.medium.com/max/5760/1*-Rh8z0kzvXKz_BbONP60Yw.jpeg)

实现 P2P 通信是一项具有挑战性的任务，但如果你知道如何使用正确的工具，那么这项任务就变得简单多了。

所以，我将在这篇文章探讨 [PeerJS](https://peerjs.com/)，这是一个封装了 WebRTC 的 JavaScript 库，可以在 web 应用中更加轻松的实现 P2P 通信。

## PeerJS 是如何简化 WebRTC 的？

当在 web 应用中涉及到实时 P2P 通信时，WebRTC 是许多开发者的使用标准。但它也自带了一些复杂性：

* 如果你使用纯 WebRTC，首先你要定义一个 STUN（Session Traversal Utilities for NAT）服务为通讯中涉及到的每一个节点生成 ICE（Interactive Connectivity Establishment）协议候选者。
* 然后你需要将这些 ICE 协议候选者的详情存储在你的服务中。
* 最后，你需要使用 WebSockets 来处理实时更新。

即使你之前没有接触过 WebRTC，我相信你也已经感受到了实现它的复杂性。但别担心，PeerJS 来解救你了。

> 有了 PeerJS，我们不用担心 STUN，ICE 协议候选者，或者服务器的创建，而且我们甚至可以避免使用 WebSockets。

PeerJS 提供一个完整的、可配置的点对点连接的 API， 以及一个称之为 PeerServer 的服务，使得我们能够轻松的在 PeerJS 的客户端之间建立连接。

那么就来看看我们如何使用 PeerJS 来创建一个简单的聊天应用。

## 使用 PeerJS 和 React 搭建你的第一个聊天室

### 步骤 1 —— 安装 PeerJS

首先，我们需要将 PeerJS 作为一个 node module 安装在你的项目中，并将 [peer](https://www.npmjs.com/package/peer) 作为全局依赖。

```bash
// 安装 PeerJS
npm i peerjs

// 安装 Peer
npm i -g peer
```

> **注意**：PeerJS 用于在本地启动 PeerServer，但你也可以使用 [PeerServer Cloud](https://peerjs.com/peerserver.html) 实例。

### 步骤 2 —— 实现聊天室

现在，让我们移至 React 应用，先初始化聊天组件的 state。

我们将在 state 内处理我们自己的 ID，目标节点 ID，聊天信息，以及一个 Peer 对象的实例。

```js
state = {
  myId: '',
  friendId: '',
  peer: {},
  message: '',
  messages: []
}
```

我们需要通过定义主机名，端口号以及路径来创建一个 Peer 实例用于管理我们的 P2P 连接。在整个通信过程中我们都将使用该实例。

```js
const peer = new Peer('', {
  host: 'localhost',
  port: '3001',
  path: '/'
});
```

> **提示：**你可以使用你自己的 ID 作为第一个参数，或者不传参，让 PeerServer 生成一个随机 ID。如果你使用 `const peer = new Peer();`，你将连接到 PeerServer Cloud。

Peer 实例有几个方法去处理 peer 之间的通信。`peer.on` 是用于监听节点的事件，当接收远程节点的通话时该方法很有用。

`open` 事件将会在成功连接 PeerServer 后发出，我们将通过该事件去更新 myId 和 peer 实例的 state。

```js
peer.on('open', (id) => {

this.setState({
    myId: id,
    peer: peer
   });
});
```

然后，我们需要通过 `connection` 事件来监听远程节点连接，并通过其回调函数获取远程节点发送的消息。

```js
peer.on('connection', (conn) => {
  conn.on('data', (data) => {

      this.setState({
        messages: [...this.state.messages, data]
      });

   });
});
```

现在我们已经实现了消息接收的功能。那么在最后一步，让我们创建一个方法用于消息发送。

`peer.connect` 方法使我们可以通过指定远程节点 id 来连接该节点。然后它将返回一个 `DataConnection` 对象用于向节点发送消息。

```js
send = () => {
  const conn = this.state.peer.connect(this.state.friendId);

  conn.on('open', () => {

    const msgObj = {
      sender: this.state.myId,
      message: this.state.message
    };

   conn.send(msgObj);

    this.setState({
      messages: [...this.state.messages, msgObj],
      message: ''
    });

  });
}
```

### 步骤 3 —— 实现视频聊天

现在，让我们修改聊天室用于发送视频消息。该功能的实现与之前我们讨论过的步骤非常相似。我们可以通过 `peer.on` 方法监听 `call` 事件从而获知来自远程节点的来电。该监听事件提供一个携带 `MediaConnection` 对象的回调函数，而接受者的视频流和音频流将提供给 `MediaConnection` 对象的 `answer` 方法。

```js
peer.on('call', (call) => {

var getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia;

getUserMedia({ video: true, audio: true }, (stream) => {

  this.myVideo.srcObject = stream;
  this.myVideo.play();
  
  call.answer(stream);

  call.on('stream', (remoteStream) => {
    this.friendVideo.srcObject = remoteStream;
    this.friendVideo.play();
  });

}, err => { console.log('Error!') });
});
```

现在，让我们从我们的端口向远程节点发送一个视频通话。这个方法与来电响应类似。我们需要调用最初的 `peer` 实例上的 `call` 方法并且将提供节点 ID 和视频流作为其参数。

`call` 方法将由此返回一个 `MediaConnection` 对象，我们可以通过该对象使用节点的视频流。

```js
videoCall = () => {

var getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia;

getUserMedia({ video: true, audio: true }, (stream) => {

  this.myVideo.srcObject = stream;
  this.myVideo.play();

  const call = this.state.peer.call(this.state.friendId, stream);

  call.on('stream', (remoteStream) => {
    this.friendVideo.srcObject = remoteStream;
    this.friendVideo.play();
  });
}, err => { console.log('Error!') });
}
```

### 步骤 4 —— 最后的事项

终于到时候添加一些 JSX 来渲染我们的聊天室了。让我们添加两个输入框用于输入节点 ID 以及聊天信息。我们将使用 `ref` 属性来操作 `video` 元素。

```js
return (
<div className="wrapper">
  <div className="col">
    <h1>My ID: {this.state.myId}</h1>

    <label>Friend ID:</label>
    <input
     type="text"
     value={this.state.friendId}
     onChange={e => { this.setState({ friendId: e.target.value });}} />

<br />
<br />

    <label>Message:</label>
    <input
     type="text"
     value={this.state.message}
     onChange={e => { this.setState({ message: e.target.value }); }} />

    <button onClick={this.send}>Send</button>
    <button onClick={this.videoCall}>Video Call</button>
    {
      this.state.messages.map((message, i) => {
        return (
          <div key={i}>
          <h3>{message.sender}:</h3>
          <p>{message.message}</p>
          </div>
        )
      });
    }
    </div>
    <div className="col">
      <div>
        <video ref={ref => this.myVideo = ref} />
      </div>
      <div>
        <video ref={ref => this.friendVideo = ref} />
      </div>
    </div>
  </div>
  );
```

就这样！现在，一个快速视频聊天已经全部设置好了。最后的成果看起来像这样，你可以在我的 GitHub [仓库](https://github.com/Dulanka-K/video-chat)找到完整的代码。

![](https://cdn-images-1.medium.com/max/3840/1*G48OkV0QlFvETj2zqDuqIw.gif)

![](https://cdn-images-1.medium.com/max/2000/1*0epo9iaN7-wx39_FkRTBCw.gif)

> **注意**：在不是 HTTPS 连接的情况下，一些浏览器（尤其是手机浏览器）可能不允许使用相机和麦克风。你可以参考这篇[文章](https://blog.bitsrc.io/using-https-for-local-development-for-react-angular-and-node-fdfaf69693cd)，通过几个步骤设置一个本地 HTTPS 连接。

## 结语

WebRTC 是支持 P2P 通信的浏览器标准。但是因为牵涉到 STUN 服务器，ICE 协议候选者，SDPs，以及 WebSockets，所以实现 WebRTC 会有一点复杂。

PeerJS 通过封装 WebRTC 简化了整个流程，为我们提供了更简单的事件和方法。

所以，我邀请你尝试使用 PeerJS，并在评论区中让我知道你的观点。

感谢阅读！！！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
