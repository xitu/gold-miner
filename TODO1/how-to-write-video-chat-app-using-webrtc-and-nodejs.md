> * 原文地址：[WebRTC and Node.js: Development of a real-time video chat app](https://tsh.io/blog/how-to-write-video-chat-app-using-webrtc-and-nodejs/)
> * 原文作者：[Mikołaj Wargowski](https://github.com/Miczeq22) 
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-write-video-chat-app-using-webrtc-and-nodejs.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-write-video-chat-app-using-webrtc-and-nodejs.md)
> * 译者：[👊Badd](https://juejin.im/user/5b0f6d4b6fb9a009e405dda1)
> * 校对者：[RubyJy](https://github.com/RubyJy), [cyz980908](https://github.com/cyz980908)

# WebRTC 联手 Node.js：打造实时视频聊天应用

> **(实时)时间就是金钱，那我就开门见山了。在本文中，我将带你写一个视频聊天应用，支持两个用户之间进行视频和语音通信。没什么难度，也没什么花哨的东西，却是一次 JavaScript —— 严格来说是 WebRTC 和 [Node.js](https://tsh.io/services/web-development/node/) —— 的绝佳试炼。**

## 何为 WebRTC？

**网络实时通信（Web Real-Time Communication，缩写为 WebRTC）是一项 HTML5 规范，它使你能直接用浏览器进行实时通讯，不用依赖第三方插件**。WebRTC 有多种用途（甚至能实现文件共享），但其主要应用为实时点对点音频与视频通讯，本文的重点也是这一点。

WebRTC 的强大之处在于允许访问设备 —— 你可以通过 WebRTC 调用麦克风、摄像头，甚至共享屏幕，而且全部都是实时进行的！因此，WebRTC 用最简单的方式

> **使网页语音视频聊天成为可能。**

## WebRTC JavaScript API

WebRTC 是一个复杂的话题，这其中涉及很多技术。而建立连接、通讯、传输数据是通过一系列 JavaScript API。主要的 API 有：

- **RTCPeerConnection** —— 创建并导航点对点连接，
- **RTCSessionDescription** —— 描述（潜在的）连接端点及其配置，
- **navigator.getUserMedia** —— 获取音视频。

## 为何用 Node.js？

若想在两个或多个设备之间建立远程连接，你需要一个服务器。在本例中，你需要的是一个能操控实时通讯的服务器。你知道 Node.js 是支持实时可扩展应用的。要开发能自由交换数据的双向连接应用，你可能会用到 WebSocket，它能在客户端和服务端之间打开一个通讯会话。客户端发出的请求被处理成一个循环 —— 严格讲是事件循环，这使得 Node.js 成为一个不错的选择，因为它使用了“无阻塞”的方法来处理请求，这样就能实现低延迟和高吞吐量。

扩展阅读： [Node.js 新特性将颠覆 AI、物联网等更多惊人领域](https://juejin.im/post/5dbb8d70f265da4d12067a3e)

## 思路演示：我们要做个什么东西？

我们要做一个非常简单的应用，它能向被连接的设备推送音频流和视频流 —— 一个基本的视频聊天应用。我们将会用到：

- Express 库，用以提供用户界面 HTML 文件之类的静态文件，
- socket.io 库，用 WebSocket 在两个设备间建立一个连接，
- WebRTC，使媒体设备（摄像头和麦克风）能在连接设备之间推送音频流和视频流。

## 实现视频聊天

第一步，我们要有一个用作应用的用户界面的 HTML 文件。用 `npm init` 初始化一个新的 Node.js 项目。然后，运行 `npm i -D typescript ts-node nodemon @types/express @types/socket.io` 来安装一些开发依赖包，运行 `npm i express socket.io` 来安装生产依赖包。

现在，我们可以在 `package.json` 文件中写一个脚本，来运行项目：

```json
{
 "scripts": {
   "start": "ts-node src/index.ts",
   "dev": "nodemon --watch 'src/**/*.ts' --exec 'ts-node' src/index.ts"
 },
 "devDependencies": {
   "@types/express": "^4.17.2",
   "@types/socket.io": "^2.1.4",
   "nodemon": "^1.19.4",
   "ts-node": "^8.4.1",
   "typescript": "^3.7.2"
 },
 "dependencies": {
   "express": "^4.17.1",
   "socket.io": "^2.3.0"
 }
}
```

我们运行 `npm run dev` 命令后，Nodemon 会监听 src 文件夹中每一个 `.ts` 后缀的文件的变动。现在我们来创建一个 src 文件夹，在 src 中，创建两个 TypeScript 文件：`index.ts` 和 `server.ts`。

在 `server.ts` 里，我们会创建一个 Server 类，并使之配合 Express 和 socket.io：

```ts
import express, { Application } from "express";
import socketIO, { Server as SocketIOServer } from "socket.io";
import { createServer, Server as HTTPServer } from "http";
 
export class Server {
 private httpServer: HTTPServer;
 private app: Application;
 private io: SocketIOServer;
 
 private readonly DEFAULT_PORT = 5000;
 
 constructor() {
   this.initialize();
 
   this.handleRoutes();
   this.handleSocketConnection();
 }
 
 private initialize(): void {
   this.app = express();
   this.httpServer = createServer(this.app);
   this.io = socketIO(this.httpServer);
 }
 
 private handleRoutes(): void {
   this.app.get("/", (req, res) => {
     res.send(`<h1>Hello World</h1>`); 
   });
 }
 
 private handleSocketConnection(): void {
   this.io.on("connection", socket => {
     console.log("Socket connected.");
   });
 }
 
 public listen(callback: (port: number) => void): void {
   this.httpServer.listen(this.DEFAULT_PORT, () =>
     callback(this.DEFAULT_PORT)
   );
 }
}
```

我们需要在 `index.ts` 文件里新建一个 `Server` 类的实例并调用 `listen` 方法，这样就能启动服务器了：

```ts
import { Server } from "./server";
 
const server = new Server();
 
server.listen(port => {
 console.log(`Server is listening on http://localhost:${port}`);
});
```

现在运行 `npm run dev`，我们将会看到：

![](https://tsh.io/wp-content/uploads/2019/11/how-to-write-a-real-time-video-chat-app-1_.png)

打开浏览器访问 [http://localhost:5000](http://localhost:5000/)，我们会看到“Hello World”字样：

![](https://tsh.io/wp-content/uploads/2019/11/how-to-write-a-real-time-video-chat-app-2_.png)

现在，我们要创建一个新的 HTML 文件 `public/index.html`：

```html
<!DOCTYPE html>
<html lang="en">
 <head>
   <meta charset="UTF-8" />
   <meta name="viewport" content="width=device-width, initial-scale=1.0" />
   <meta http-equiv="X-UA-Compatible" content="ie=edge" />
   <title>Dogeller</title>
   <link
     href="https://fonts.googleapis.com/css?family=Montserrat:300,400,500,700&display=swap"
     rel="stylesheet"
   />
   <link rel="stylesheet" href="./styles.css" />
   <script src="https://cdnjs.cloudflare.com/ajax/libs/socket.io/2.3.0/socket.io.js"></script>
 </head>
 <body>
   <div class="container">
     <header class="header">
       <div class="logo-container">
         <img src="./img/doge.png" alt="doge logo" class="logo-img" />
         <h1 class="logo-text">
           Doge<span class="logo-highlight">ller</span>
         </h1>
       </div>
     </header>
     <div class="content-container">
       <div class="active-users-panel" id="active-user-container">
         <h3 class="panel-title">Active Users:</h3>
       </div>
       <div class="video-chat-container">
         <h2 class="talk-info" id="talking-with-info"> 
           Select active user on the left menu.
         </h2>
         <div class="video-container">
           <video autoplay class="remote-video" id="remote-video"></video>
           <video autoplay muted class="local-video" id="local-video"></video>
         </div>
       </div>
     </div>
   </div>
   <script src="./scripts/index.js"></script>
 </body>
</html>
```

在这个文件里，我们声明两个视频元素：一个用来呈现远程视频连接，另一个用来呈现本地视频。你可能已经注意到了，我们还引入了本地脚本文件，所以让我们来新建一个文件夹 —— 命名为 `scripts` 并在其中创建 `index.js` 文件。至于样式文件，你可以在 [GitHub 仓库](https://github.com/Miczeq22/simple-chat-app)下载到。

现在就该把 `index.html` 从服务端传给浏览器了。首先你要告诉 Express，你要返回哪个静态文件。这需要我们在 `Server` 类中实现一个新的方法：

```ts
private configureApp(): void {
   this.app.use(express.static(path.join(__dirname, "../public")));
 }
 ```

别忘了在 `initialize` 方法中调用 `configureApp` 方法：

```ts
private initialize(): void {
   this.app = express();
   this.httpServer = createServer(this.app);
   this.io = socketIO(this.httpServer);
 
   this.configureApp();
   this.handleSocketConnection();
 }
```

至此，当打开 [http://localhost:5000](http://localhost:5000/)，你会看到 `index.html` 文件已经运行起来了：

![](https://tsh.io/wp-content/uploads/2019/11/how-to-write-a-real-time-video-chat-app-3_.png)

下一步就该访问摄像头和麦克风，并让媒体流展示在 `local-video` 元素中了。打开 `public/scripts/index.js` 文件，添加以下代码：

```js
navigator.getUserMedia(
 { video: true, audio: true },
 stream => {
   const localVideo = document.getElementById("local-video");
   if (localVideo) {
     localVideo.srcObject = stream;
   }
 },
 error => {
   console.warn(error.message);
 }
);
```

再回到浏览器，你会看到一个请求访问媒体设备的提示框，授权这个请求后，你会看到你的摄像头被唤醒了！

![](https://tsh.io/wp-content/uploads/2019/11/how-to-write-a-real-time-video-chat-app-4_.png)

扩展阅读：[简易指南：Node.js 的并发性及一些坑](https://tsh.io/blog/simple-guide-concurrency-node-js/)

## 如何处理 socket 连接？

现在我们将着重关注如何处理 socket 连接 —— 我们需要连接客户端和服务端，故此要用到 socket.io。在 `public/scripts/index.js` 中添加：

```js
this.io.on("connection", socket => {
     const existingSocket = this.activeSockets.find(
       existingSocket => existingSocket === socket.id
     );
 
     if (!existingSocket) {
       this.activeSockets.push(socket.id);
 
       socket.emit("update-user-list", {
         users: this.activeSockets.filter(
           existingSocket => existingSocket !== socket.id
         )
       });
 
       socket.broadcast.emit("update-user-list", {
         users: [socket.id]
       });
     }
   }
```

刷新页面就能看到终端中有一条信息：“Socket connected”。

![](https://tsh.io/wp-content/uploads/2019/11/how-to-write-a-real-time-video-chat-app-5_.png)此时我们再回到 `server.ts` 将 socket 存到内存中，便于保持连接的唯一性。也就是说，在 `Server` 类中增加一个新的私有字段：

```ts
private activeSockets: string[] = [];
```

在连接 socket 时检查是否已经有 socket 存在了。如果还没有，那就向内存中添加新的 socket，并将数据发送给连接的用户：

```ts
this.io.on("connection", socket => {
     const existingSocket = this.activeSockets.find(
       existingSocket => existingSocket === socket.id
     );
 
     if (!existingSocket) {
       this.activeSockets.push(socket.id);
 
       socket.emit("update-user-list", {
         users: this.activeSockets.filter(
           existingSocket => existingSocket !== socket.id
         )
       });
 
       socket.broadcast.emit("update-user-list", {
         users: [socket.id]
       });
     }
   }
```

还需要在 socket 断开时做出响应，所以要在 socket 里面添加：

```ts
socket.on("disconnect", () => {
   this.activeSockets = this.activeSockets.filter(
     existingSocket => existingSocket !== socket.id
   );
   socket.broadcast.emit("remove-user", {
     socketId: socket.id
   });
 });
```

在客户端（也就是 `public/scripts/index.js`），你需要对这些消息施行对应的操作：

```js
socket.on("update-user-list", ({ users }) => {
 updateUserList(users);
});
 
socket.on("remove-user", ({ socketId }) => {
 const elToRemove = document.getElementById(socketId);
 
 if (elToRemove) {
   elToRemove.remove();
 }
});
```

这是 `updateUserList` 函数：

```js
function updateUserList(socketIds) {
 const activeUserContainer = document.getElementById("active-user-container");
 
 socketIds.forEach(socketId => {
   const alreadyExistingUser = document.getElementById(socketId);
   if (!alreadyExistingUser) {
     const userContainerEl = createUserItemContainer(socketId);
     activeUserContainer.appendChild(userContainerEl);
   }
 });
}
```

还有 `createUserItemContainer` 函数：

```js
function createUserItemContainer(socketId) {
 const userContainerEl = document.createElement("div");
 
 const usernameEl = document.createElement("p");
 
 userContainerEl.setAttribute("class", "active-user");
 userContainerEl.setAttribute("id", socketId);
 usernameEl.setAttribute("class", "username");
 usernameEl.innerHTML = `Socket: ${socketId}`;
 
 userContainerEl.appendChild(usernameEl);
 
 userContainerEl.addEventListener("click", () => {
   unselectUsersFromList();
   userContainerEl.setAttribute("class", "active-user active-user--selected");
   const talkingWithInfo = document.getElementById("talking-with-info");
   talkingWithInfo.innerHTML = `Talking with: "Socket: ${socketId}"`;
   callUser(socketId);
 }); 
 return userContainerEl;
}
```

请注意，我们在用户容器元素上添加了一个点击事件监听，点击会调用 `callUser` 函数 —— 就目前来说，你可以先写成空函数。现在，当你运行两个浏览器窗口（其中一个作为本地用户窗口），你会发现在应用中有两个连接中的 socket：

![](https://tsh.io/wp-content/uploads/2019/11/how-to-write-a-real-time-video-chat-app-6_.png)

点击列表中的在线用户后，要调用 `callUser` 函数。但在实现该函数前，你需要在 `window` 对象中声明两个类。

```js
const { RTCPeerConnection, RTCSessionDescription } = window;
```

我们会在 `callUser` 函数中用到它们： 

```js
async function callUser(socketId) {
 const offer = await peerConnection.createOffer();
 await peerConnection.setLocalDescription(new RTCSessionDescription(offer));
 
 socket.emit("call-user", {
   offer,
   to: socketId
 });
}
```

这里，我们创建了一个本地连接请求，并发送给被选中的用户。服务端会监听一个叫做 `call-user` 的事件，拦截本地发出的连接请求，并发送给被选中的用户。在 `server.ts` 中需要这样实现： 

```ts
socket.on("call-user", data => {
   socket.to(data.to).emit("call-made", {
     offer: data.offer,
     socket: socket.id
   });
 });
```

现在在客户端，我们需要对 `call-made` 事件做出响应：

```js
socket.on("call-made", async data => {
 await peerConnection.setRemoteDescription(
   new RTCSessionDescription(data.offer)
 );
 const answer = await peerConnection.createAnswer();
 await peerConnection.setLocalDescription(new RTCSessionDescription(answer));
 
 socket.emit("make-answer", {
   answer,
   to: data.socket
 });
});
```

然后，给这个从服务端收到的连接请求设置一个远程描述，并给该请求创建一个回应。在服务端，你需要把对应的数据传给被选中的用户。在 `server.ts`中，在添加一个事件监听：

```ts
socket.on("make-answer", data => {
   socket.to(data.to).emit("answer-made", {
     socket: socket.id,
     answer: data.answer
   });
 });
```

相应地，在客户端处理 `answer-made` 事件：

```js
socket.on("answer-made", async data => {
 await peerConnection.setRemoteDescription(
   new RTCSessionDescription(data.answer)
 );
 
 if (!isAlreadyCalling) {
   callUser(data.socket);
   isAlreadyCalling = true;
 }
});
```

我们使用一个非常有用的标志 —— `isAlreadyCalling` —— 来确保只对该用户呼叫一次。

最后，只需添加本地记录 —— 音频和视频 —— 到连接中即可，这样就能与连接的用户共享音频和视频了。那就需要我们在 `navigator.getMediaDevice` 回调函数中，用 `peerConnection` 对象调用 `addTrack` 函数。

```js
navigator.getUserMedia(
 { video: true, audio: true },
 stream => {
   const localVideo = document.getElementById("local-video");
   if (localVideo) {
     localVideo.srcObject = stream;
   }
 
   stream.getTracks().forEach(track => peerConnection.addTrack(track, stream));
 },
 error => {
   console.warn(error.message);
 }
);
```

以及为 `ontrack` 事件添加对应的处理函数：

```js
peerConnection.ontrack = function({ streams: [stream] }) {
 const remoteVideo = document.getElementById("remote-video");
 if (remoteVideo) {
   remoteVideo.srcObject = stream;
 }
};
```

如你所见，我们从传入的对象中获取到了媒体流，并改写了 `remote-video` 中的 `srcObject`，以便使用接收到的媒体流。所以，现在当你点击了一个在线用户，你就能建立一个音视频连接，如下：

![](https://tsh.io/wp-content/uploads/2019/11/how-to-write-a-real-time-video-chat-app-7_.png)

扩展阅读：[Node.js 和依赖注入 —— 是敌是友？](https://tsh.io/blog/dependency-injection-in-node-js/)

## 现在你已经点亮了开发视频聊天应用的技能啦！

WebRTC 是个庞大的话题 —— 特别是如果你想要知道其深层原理的时候。幸运的是，我们有简单易用的 JavaScript API 可以用，使我们能够做出诸如视频聊天应用等十分简洁的应用！

如果你想深入了解 WebRTC，请看 [WebRTC 官方文档](https://webrtc.org/start/)。个人推荐阅读 [MDN 文档](https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
