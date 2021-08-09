> * 原文地址：[Simplified Peer to Peer Communication with PeerJS](https://blog.bitsrc.io/simplified-peer-to-peer-communication-with-peerjs-e37244267723)
> * 原文作者：[Dulanka Karunasena](https://medium.com/@dulanka)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/simplified-peer-to-peer-communication-with-peerjs.md](https://github.com/xitu/gold-miner/blob/master/article/2021/simplified-peer-to-peer-communication-with-peerjs.md)
> * 译者：
> * 校对者：

# Simplified Peer to Peer Communication with PeerJS

![](https://cdn-images-1.medium.com/max/5760/1*-Rh8z0kzvXKz_BbONP60Yw.jpeg)

Implementing peer-to-peer communication is a challenging task. But, if you know the correct tools, you can make it a whole lot easier.

So, in this article, I will discuss [PeerJS](https://peerjs.com/), a JavaScript library that acts as a wrapper around WebRTC, making it easier to implement peer-to-peer communication in web applications.

## How PeerJS Simplifies WebRTC?

When it comes to real-time P2P communication in web applications, WebRTC is the standard used by many developers. But, it comes with some complexities as follows;

* If you use pure WebRTC, first, you define a STUN (Session Traversal Utilities for NAT) server to generate ICE (Interactive Connectivity Establishment) candidates for each peer involved in communication.
* Then you need to use your servers to store these ICE candidate details.
* Finally, you need to implement WebSockets to handle real-time updates.

Even you haven’t worked with WebRTC before; I’m sure you must be feeling the complexity of its implementation. But, don’t worry, PeerJS is here for the rescue.

> With PeerJS, we don’t have to worry about STUNs, ICE candidates, or server creation. We can even avoid implementing WebSockets as well.

PeerJs provides a complete, configurable peer-to-peer connection API and a server called PeerServer to easily establish connections between PeerJS clients.

So, let’s see how we can use PeerJS to create a simple chat application.

## Building Your First Chat Room with PeerJS and React

### Step 1 — Installing PeerJS

First, we need to install PeerJS library to your project as a node module and the [peer](https://www.npmjs.com/package/peer) library as a global dependency.

```bash
// Installing PeerJS
npm i peerjs

// Installing Peer
npm i -g peer
```

> **Note:** PeerJS library is used to start the PeerServer locally. You can also use the [PeerServer Cloud](https://peerjs.com/peerserver.html) instance as well.

#### Step 2 — Implementing the Chat Room

Now, let’s move to our React application and get things started by initializing the state of the chat component.

Inside the state, we will be handling our ID, peer ID, chat messages, and an instance of Peer object.

```js
state = {
  myId: '',
  friendId: '',
  peer: {},
  message: '',
  messages: []
}
```

Then we need to create a Peer instance by defining hostname, port, and path to manage our P2P connection. We will use this instance throughout the communication process.

```js
const peer = new Peer('', {
  host: 'localhost',
  port: '3001',
  path: '/'
});
```

> **Tip:** You can use your own ID as the first argument or leave it undefined for the PeerServer to generate a random ID. If you use `const peer = new Peer();` you will be connected to PeerServer Cloud.

Peer instance has several methods to handle communication between peers. `peer.on` is used to listen to peer events, and it is useful when receiving calls from remote peers.

`open` event will be emitted after successfully connecting to PeerServer, and we will use this event to update the state of myId and peer instance.

```js
peer.on('open', (id) => {

this.setState({
    myId: id,
    peer: peer
   });
});
```

Then, we need to use the `connection` event to listen to remote peer connections, and we can use its callback to grab the message sent by the remote peer.

```js
peer.on('connection', (conn) => {
  conn.on('data', (data) => {

      this.setState({
        messages: [...this.state.messages, data]
      });

   });
});
```

Now, we have implemented all the functionalities to receive messages. As the final step, let’s create a method to send a message.

`peer.connect` method allows us to connect to the peer by specifying peer id. Then it returns a `DataConnection` object which can be used to send message data to the peer.

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

### Step 3 — Video Chat Implementation

Now, let’s modify our chat room to send video messages. Implementing it is pretty much similar to what we discussed in the previous step. We can use the `call` event inside `peer.on` method to listen to calls from the remote peer. It will provide a callback with an object named `MediaConnection` and receiver’s video and audio streams are provided to the `answer` method of `MediaConnection` object.

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

Now let’s make a video call to the peer from our end. This approach is similar to answering a call. We need to use the `call` method of the initial `peer` instance and provide peer ID and video stream as arguments.

`call` method will then return a `MediaConnection` object which we can use to access the peer’s stream.

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

### Step 4 — Finalizing Things

Finally, it’s time to add some JSX to render our chat room. Let’s add two input fields for peer ID and chat messages. We will use the `ref` attribute to access the `video` element.

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

That’s it! Now we are all set for a quick video chat. The final implementation will look like this and you can find the full code in my GitHub [repository](https://github.com/Dulanka-K/video-chat).

![](https://cdn-images-1.medium.com/max/3840/1*G48OkV0QlFvETj2zqDuqIw.gif)

![](https://cdn-images-1.medium.com/max/2000/1*0epo9iaN7-wx39_FkRTBCw.gif)

> **Note:** Some browsers (especially mobile browsers) may not allow camera and microphone access without an HTTPS connection. You can refer to this [article](https://blog.bitsrc.io/using-https-for-local-development-for-react-angular-and-node-fdfaf69693cd) to set up a local HTTPS connection in few steps.

## Final Words

Web RTC is the browser standard that enables real-time peer-to-peer communication. But implementing WebRTC is a bit complex due to the involvement of STUN Servers, ICE candidates, SDPs, and WebSockets.

PeerJS simplifies the whole process by acting as a wrapper to WebRTC and provides us with much simpler events and methods to work.

So, I invite you to try PeerJS and let me know your thoughts in the comments section.

Thank you for Reading !!!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
