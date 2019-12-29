# WebRTC and Node.js: Development of a real-time video chat app

(Real-)time is money, so I'm gonna get to the point. In this article, I'll show you how to write a video chat application which allows sharing both video and audio between two connected users. It's quite simple, nothing fancy but good for training in JavaScript language and -- to be more precise -- WebRTC technology and [Node.js](https://tsh.io/services/web-development/node/).

What is WebRTC?
---------------

Web Real-Time Communications -- WebRTC in short -- is an HTML5 specification that allows you to communicate in real-time directly between browsers without any third-party plugins. WebRTC can be used for multiple tasks (even file sharing) but real-time peer-to-peer audio and video communication is obviously the primary feature and we will focus on those in this article.

What WebRTC does is to allow access to devices -- you can use a microphone, a camera and share your screen with help from WebRTC and do all of that in real-time! So, in the simplest way 

> WebRTC enables for audio and video communication to work inside web pages.

WebRTC JavaScript API
---------------------

WebRTC is a complex topic where many technologies are involved. However, establishing connections, communication and transmitting data are implemented through a set of JS APIs. The primary APIs include:

-   RTCPeerConnection --  creates and navigates peer-to-peer connections,
-   RTCSessionDescription -- describes one end of a connection (or a potential connection) and how it's configured,
-   navigator.getUserMedia -- captures audio and video.

Why Node.js?
------------

To make a remote connection between two or more devices you need a server. In this case, you need a server that handles real-time communication. You know that Node.js is built for real-time scalable applications. To develop two-way connection apps with free data exchange, you would probably use WebSockets that allows opening a communication session between a client and a server. Requests from the client are processed as a loop, more precisely -- the event loop, which makes Node.js a good option because it takes a "non-blocking" approach to serve requests and thus, achieves low latency and high throughput along the way.

Read more: [New Node.js 12 features will see it disrupt AI, IoT and more surprising areas](https://tsh.io/blog/new-node-js-features/)

Demo Idea: what are we going to create here?
--------------------------------------------

We are going to create a very simple application which allows us to stream audio and video to the connected device -- a basic video chat app. We will use:

-   express library to serve static files like our HTML file which stands for our UI,
-   socket.io library to establish a connection between two devices with WebSockets,
-   WebRTC to allow media devices (camera and microphone) to stream audio and video between connected devices.

Video Chat implementation
-------------------------

The first thing we're gonna do is to serve an HTML file that will work as a UI for our application. Let's initialize new node.js project by running: `npm init`. After that we need to install a few dev dependencies by running: `npm i -D typescript ts-node nodemon @types/express @types/socket.io` and production dependencies by running: `npm i express socket.io`.

Now we can define scripts to run our project in `package.json` file:

|  | { |
|  | "scripts": { |
|  | "start": "ts-node src/index.ts", |
|  | "dev": "nodemon --watch 'src/**/*.ts' --exec 'ts-node' src/index.ts" |
|  | }, |
|  | "devDependencies": { |
|  | "@types/express": "^4.17.2", |
|  | "@types/socket.io": "^2.1.4", |
|  | "nodemon": "^1.19.4", |
|  | "ts-node": "^8.4.1", |
|  | "typescript": "^3.7.2" |
|  | }, |
|  | "dependencies": { |
|  | "express": "^4.17.1", |
|  | "socket.io": "^2.3.0" |
|  | } |
|  | } |

[view raw](https://gist.github.com/tsh-code/5d34542fe5274341439ef92de7861cd3/raw/4c7af04448cd7006fc49cdb7fb69338ed4407585/package.json)[package.json](https://gist.github.com/tsh-code/5d34542fe5274341439ef92de7861cd3#file-package-json) hosted with ❤ by [GitHub](https://github.com/)

When we run `npm run dev` command, then nodemon will be looking at any changes in src folder for every file which ends with the `.ts `extension. Now we are going to create an src folder and inside this folder, we will create two typescript files: `index.ts` and ``server.ts``.

Inside server.ts we will create server class and we will make it work with express and socket.io:

|  | import express, { Application } from "express"; |
|  | import socketIO, { Server as SocketIOServer } from "socket.io"; |
|  | import { createServer, Server as HTTPServer } from "http"; |
|  |  |
|  | export class Server { |
|  | private httpServer: HTTPServer; |
|  | private app: Application; |
|  | private io: SocketIOServer; |
|  |  |
|  | private readonly DEFAULT_PORT = 5000; |
|  |  |
|  | constructor() { |
|  | this.initialize(); |
|  |  |
|  | this.handleRoutes(); |
|  | this.handleSocketConnection(); |
|  | } |
|  |  |
|  | private initialize(): void { |
|  | this.app = express(); |
|  | this.httpServer = createServer(this.app); |
|  | this.io = socketIO(this.httpServer); |
|  | } |
|  |  |
|  | private handleRoutes(): void { |
|  | this.app.get("/", (req, res) => { |
|  | res.send(`<h1>Hello World</h1>`); |
|  | }); |
|  | } |
|  |  |
|  | private handleSocketConnection(): void { |
|  | this.io.on("connection", socket => { |
|  | console.log("Socket connected."); |
|  | }); |
|  | } |
|  |  |
|  | public listen(callback: (port: number) => void): void { |
|  | this.httpServer.listen(this.DEFAULT_PORT, () => |
|  | callback(this.DEFAULT_PORT) |
|  | ); |
|  | } |
|  | } |
|  |  |

[view raw](https://gist.github.com/tsh-code/5d34542fe5274341439ef92de7861cd3/raw/4c7af04448cd7006fc49cdb7fb69338ed4407585/basic-server-configuration.ts)[basic-server-configuration.ts](https://gist.github.com/tsh-code/5d34542fe5274341439ef92de7861cd3#file-basic-server-configuration-ts) hosted with ❤ by [GitHub](https://github.com/)

To run our server, we need to make a new instance of `Server` class and invoke `listen` method, we will make it inside `index.ts` file:

|  | import { Server } from "./server"; |
|  |  |
|  | const server = new Server(); |
|  |  |
|  | server.listen(port => { |
|  | console.log(`Server is listening on http://localhost:${port}`); |
|  | }); |

[view raw](https://gist.github.com/tsh-code/5d34542fe5274341439ef92de7861cd3/raw/4c7af04448cd7006fc49cdb7fb69338ed4407585/index.ts)[index.ts](https://gist.github.com/tsh-code/5d34542fe5274341439ef92de7861cd3#file-index-ts) hosted with ❤ by [GitHub](https://github.com/)

Now, when we run: `npm run dev`, we should see:

![](https://tsh.io/wp-content/uploads/2019/11/how-to-write-a-real-time-video-chat-app-1_.png)

And when we open the browser and enter on[ http://localhost:5000](http://localhost:5000/) we should notice our "Hello World" message:

![](https://tsh.io/wp-content/uploads/2019/11/how-to-write-a-real-time-video-chat-app-2_.png)

Now we are going to create a new HTML file inside `public/index.html`:

|  | <!DOCTYPE html> |
|  | <html lang="en"> |
|  | <head> |
|  | <meta charset="UTF-8" /> |
|  | <meta name="viewport" content="width=device-width, initial-scale=1.0" /> |
|  | <meta http-equiv="X-UA-Compatible" content="ie=edge" /> |
|  | <title>Dogeller</title> |
|  | <link |
|  | href="https://fonts.googleapis.com/css?family=Montserrat:300,400,500,700&display=swap" |
|  | rel="stylesheet" |
|  | /> |
|  | <link rel="stylesheet" href="./styles.css" /> |
|  | <script src="https://cdnjs.cloudflare.com/ajax/libs/socket.io/2.3.0/socket.io.js"></script> |
|  | </head> |
|  | <body> |
|  | <div class="container"> |
|  | <header class="header"> |
|  | <div class="logo-container"> |
|  | <img src="./img/doge.png" alt="doge logo" class="logo-img" /> |
|  | <h1 class="logo-text"> |
|  | Doge<span class="logo-highlight">ller</span> |
|  | </h1> |
|  | </div> |
|  | </header> |
|  | <div class="content-container"> |
|  | <div class="active-users-panel" id="active-user-container"> |
|  | <h3 class="panel-title">Active Users:</h3> |
|  | </div> |
|  | <div class="video-chat-container"> |
|  | <h2 class="talk-info" id="talking-with-info"> |
|  | Select active user on the left menu. |
|  | </h2> |
|  | <div class="video-container"> |
|  | <video autoplay class="remote-video" id="remote-video"></video> |
|  | <video autoplay muted class="local-video" id="local-video"></video> |
|  | </div> |
|  | </div> |
|  | </div> |
|  | </div> |
|  | <script src="./scripts/index.js"></script> |
|  | </body> |
|  | </html> |
|  |  |

[view raw](https://gist.github.com/tsh-code/5d34542fe5274341439ef92de7861cd3/raw/4c7af04448cd7006fc49cdb7fb69338ed4407585/index.html)[index.html](https://gist.github.com/tsh-code/5d34542fe5274341439ef92de7861cd3#file-index-html) hosted with ❤ by [GitHub](https://github.com/)

In this file, we declared two video elements: one for remote video connection and another for local video. As you've probably noticed, we are also importing local script, so let's create a new folder -- called scripts and create `index.js` file inside this directory. As for styles, you can download them from [the GitHub repository](https://github.com/Miczeq22/simple-chat-app).

Now, you need to serve index.html to the browser. First, you need to tell express, which static files you want to serve. In order to do it, we will implement a new method inside the Server class:

|  | private configureApp(): void { |
|  | this.app.use(express.static(path.join(__dirname, "../public"))); |
|  | } |

[view raw](https://gist.github.com/tsh-code/5d34542fe5274341439ef92de7861cd3/raw/4c7af04448cd7006fc49cdb7fb69338ed4407585/handle-static-files.ts)[handle-static-files.ts](https://gist.github.com/tsh-code/5d34542fe5274341439ef92de7861cd3#file-handle-static-files-ts) hosted with ❤ by [GitHub](https://github.com/)

Don't forget to invoke `configureApp` method inside `initialize` method:

|  | private initialize(): void { |
|  | this.app = express(); |
|  | this.httpServer = createServer(this.app); |
|  | this.io = socketIO(this.httpServer); |
|  |  |
|  | this.configureApp(); |
|  | this.handleSocketConnection(); |
|  | } |

[view raw](https://gist.github.com/tsh-code/5d34542fe5274341439ef92de7861cd3/raw/4c7af04448cd7006fc49cdb7fb69338ed4407585/server-init.ts)[server-init.ts](https://gist.github.com/tsh-code/5d34542fe5274341439ef92de7861cd3#file-server-init-ts) hosted with ❤ by [GitHub](https://github.com/)

Now, when you enter [http://localhost:5000](http://localhost:5000/), you should see your index.html file in action:

![](https://tsh.io/wp-content/uploads/2019/11/how-to-write-a-real-time-video-chat-app-3_.png)

The next thing you want to implement is the camera and video access, and stream it to the `local-video` element. To do it, you need to open `public/scripts/index.js` file and implement it with:

|  | navigator.getUserMedia( |
|  | { video: true, audio: true }, |
|  | stream => { |
|  | const localVideo = document.getElementById("local-video"); |
|  | if (localVideo) { |
|  | localVideo.srcObject = stream; |
|  | } |
|  | }, |
|  | error => { |
|  | console.warn(error.message); |
|  | } |
|  | ); |

[view raw](https://gist.github.com/tsh-code/5d34542fe5274341439ef92de7861cd3/raw/4c7af04448cd7006fc49cdb7fb69338ed4407585/handle-media-access.js)[handle-media-access.js](https://gist.github.com/tsh-code/5d34542fe5274341439ef92de7861cd3#file-handle-media-access-js) hosted with ❤ by [GitHub](https://github.com/)

When you go back to the browser, you should notice a prompt that asks you to access your media devices, and after accepting this prompt, you should see your camera in action! 

![](https://tsh.io/wp-content/uploads/2019/11/how-to-write-a-real-time-video-chat-app-4_.png)

Read more: [A simple guide to concurrency in Node.js and a few traps that come with it](https://tsh.io/blog/simple-guide-concurrency-node-js/)

How to handle socket connections?
---------------------------------

Now we will focus on handling socket connections -- we need to connect our client with the server and for that, we will use socket.io. Inside `public/scripts/index.js`, add:

|  | this.io.on("connection", socket => { |
|  | const existingSocket = this.activeSockets.find( |
|  | existingSocket => existingSocket === socket.id |
|  | ); |
|  |  |
|  | if (!existingSocket) { |
|  | this.activeSockets.push(socket.id); |
|  |  |
|  | socket.emit("update-user-list", { |
|  | users: this.activeSockets.filter( |
|  | existingSocket => existingSocket !== socket.id |
|  | ) |
|  | }); |
|  |  |
|  | socket.broadcast.emit("update-user-list", { |
|  | users: [socket.id] |
|  | }); |
|  | } |
|  | } |

[view raw](https://gist.github.com/tsh-code/5d34542fe5274341439ef92de7861cd3/raw/4c7af04448cd7006fc49cdb7fb69338ed4407585/socket-connection.ts)[socket-connection.ts](https://gist.github.com/tsh-code/5d34542fe5274341439ef92de7861cd3#file-socket-connection-ts) hosted with ❤ by [GitHub](https://github.com/)

After page refresh, you should notice a message: "Socket connected" in our terminal.

![](https://tsh.io/wp-content/uploads/2019/11/how-to-write-a-real-time-video-chat-app-5_.png)Now we will go back to `server.ts `and store connected sockets in memory, just to keep only unique connections. So, add a new private field in the `Server` class:

|  | private activeSockets: string[] = []; |

[view raw](https://gist.github.com/tsh-code/5d34542fe5274341439ef92de7861cd3/raw/4c7af04448cd7006fc49cdb7fb69338ed4407585/keeping-active-sockets.ts)[keeping-active-sockets.ts](https://gist.github.com/tsh-code/5d34542fe5274341439ef92de7861cd3#file-keeping-active-sockets-ts) hosted with ❤ by [GitHub](https://github.com/)

And on the socket connection check if socket already exists. If it doesn't, push new socket to memory and emit data to connected users:

|  | this.io.on("connection", socket => { |
|  | const existingSocket = this.activeSockets.find( |
|  | existingSocket => existingSocket === socket.id |
|  | ); |
|  |  |
|  | if (!existingSocket) { |
|  | this.activeSockets.push(socket.id); |
|  |  |
|  | socket.emit("update-user-list", { |
|  | users: this.activeSockets.filter( |
|  | existingSocket => existingSocket !== socket.id |
|  | ) |
|  | }); |
|  |  |
|  | socket.broadcast.emit("update-user-list", { |
|  | users: [socket.id] |
|  | }); |
|  | } |
|  | } |

[view raw](https://gist.github.com/tsh-code/5d34542fe5274341439ef92de7861cd3/raw/4c7af04448cd7006fc49cdb7fb69338ed4407585/socket-connection.ts)[socket-connection.ts](https://gist.github.com/tsh-code/5d34542fe5274341439ef92de7861cd3#file-socket-connection-ts) hosted with ❤ by [GitHub](https://github.com/)

You also need to respond on socket disconnect, so inside socket connection, you need to add:

|  | socket.on("disconnect", () => { |
|  | this.activeSockets = this.activeSockets.filter( |
|  | existingSocket => existingSocket !== socket.id |
|  | ); |
|  | socket.broadcast.emit("remove-user", { |
|  | socketId: socket.id |
|  | }); |
|  | }); |

[view raw](https://gist.github.com/tsh-code/5d34542fe5274341439ef92de7861cd3/raw/4c7af04448cd7006fc49cdb7fb69338ed4407585/socket-disconnection.ts)[socket-disconnection.ts](https://gist.github.com/tsh-code/5d34542fe5274341439ef92de7861cd3#file-socket-disconnection-ts) hosted with ❤ by [GitHub](https://github.com/)

On the client-side (meaning `public/scripts/index.js`), you need to implement proper behaviour on those messages:

|  | socket.on("update-user-list", ({ users }) => { |
|  | updateUserList(users); |
|  | }); |
|  |  |
|  | socket.on("remove-user", ({ socketId }) => { |
|  | const elToRemove = document.getElementById(socketId); |
|  |  |
|  | if (elToRemove) { |
|  | elToRemove.remove(); |
|  | } |
|  | }); |

[view raw](https://gist.github.com/tsh-code/5d34542fe5274341439ef92de7861cd3/raw/4c7af04448cd7006fc49cdb7fb69338ed4407585/on-update-user-list.js)[on-update-user-list.js](https://gist.github.com/tsh-code/5d34542fe5274341439ef92de7861cd3#file-on-update-user-list-js) hosted with ❤ by [GitHub](https://github.com/)

Here is the `updateUserList` function:

|  | function updateUserList(socketIds) { |
|  | const activeUserContainer = document.getElementById("active-user-container"); |
|  |  |
|  | socketIds.forEach(socketId => { |
|  | const alreadyExistingUser = document.getElementById(socketId); |
|  | if (!alreadyExistingUser) { |
|  | const userContainerEl = createUserItemContainer(socketId); |
|  | activeUserContainer.appendChild(userContainerEl); |
|  | } |
|  | }); |
|  | } |

[view raw](https://gist.github.com/tsh-code/5d34542fe5274341439ef92de7861cd3/raw/4c7af04448cd7006fc49cdb7fb69338ed4407585/update-user-list.js)[update-user-list.js](https://gist.github.com/tsh-code/5d34542fe5274341439ef92de7861cd3#file-update-user-list-js) hosted with ❤ by [GitHub](https://github.com/)

And `createUserItemContainer `function:

|  | function createUserItemContainer(socketId) { |
|  | const userContainerEl = document.createElement("div"); |
|  |  |
|  | const usernameEl = document.createElement("p"); |
|  |  |
|  | userContainerEl.setAttribute("class", "active-user"); |
|  | userContainerEl.setAttribute("id", socketId); |
|  | usernameEl.setAttribute("class", "username"); |
|  | usernameEl.innerHTML = `Socket: ${socketId}`; |
|  |  |
|  | userContainerEl.appendChild(usernameEl); |
|  |  |
|  | userContainerEl.addEventListener("click", () => { |
|  | unselectUsersFromList(); |
|  | userContainerEl.setAttribute("class", "active-user active-user--selected"); |
|  | const talkingWithInfo = document.getElementById("talking-with-info"); |
|  | talkingWithInfo.innerHTML = `Talking with: "Socket: ${socketId}"`; |
|  | callUser(socketId); |
|  | }); |
|  | return userContainerEl; |
|  | } |
|  |  |

[view raw](https://gist.github.com/tsh-code/5d34542fe5274341439ef92de7861cd3/raw/4c7af04448cd7006fc49cdb7fb69338ed4407585/create-user-element.js)[create-user-element.js](https://gist.github.com/tsh-code/5d34542fe5274341439ef92de7861cd3#file-create-user-element-js) hosted with ❤ by [GitHub](https://github.com/)

Please notice that we add a click listener to a user container element, which invokes `callUser` function -- for now, it can be an empty function. Now when you run two browser windows (one as a private window), you should notice two connected sockets in your web app:

![](https://tsh.io/wp-content/uploads/2019/11/how-to-write-a-real-time-video-chat-app-6_.png)

After clicking the active user from the list, we want to invoke `callUser` function. But before you implement it, you need to declare two classes from the `window` object.

|  | const { RTCPeerConnection, RTCSessionDescription } = window; |

[view raw](https://gist.github.com/tsh-code/5d34542fe5274341439ef92de7861cd3/raw/4c7af04448cd7006fc49cdb7fb69338ed4407585/rtc-objects.js)[rtc-objects.js](https://gist.github.com/tsh-code/5d34542fe5274341439ef92de7861cd3#file-rtc-objects-js) hosted with ❤ by [GitHub](https://github.com/)

We will use them in` callUser `function: 

|  | async function callUser(socketId) { |
|  | const offer = await peerConnection.createOffer(); |
|  | await peerConnection.setLocalDescription(new RTCSessionDescription(offer)); |
|  |  |
|  | socket.emit("call-user", { |
|  | offer, |
|  | to: socketId |
|  | }); |
|  | } |

[view raw](https://gist.github.com/tsh-code/5d34542fe5274341439ef92de7861cd3/raw/4c7af04448cd7006fc49cdb7fb69338ed4407585/call-user.js)[call-user.js](https://gist.github.com/tsh-code/5d34542fe5274341439ef92de7861cd3#file-call-user-js) hosted with ❤ by [GitHub](https://github.com/)

Here we create a local offer and send to the selected user. The server listens to an event called `call-user`, intercepts the offer and forwards it to the selected user. Let's implement it in server.ts: 

|  | socket.on("call-user", data => { |
|  | socket.to(data.to).emit("call-made", { |
|  | offer: data.offer, |
|  | socket: socket.id |
|  | }); |
|  | }); |

[view raw](https://gist.github.com/tsh-code/5d34542fe5274341439ef92de7861cd3/raw/4c7af04448cd7006fc49cdb7fb69338ed4407585/call-user.ts)[call-user.ts](https://gist.github.com/tsh-code/5d34542fe5274341439ef92de7861cd3#file-call-user-ts) hosted with ❤ by [GitHub](https://github.com/)

Now on the client side, you need to react on `call-made` event:

|  | socket.on("call-made", async data => { |
|  | await peerConnection.setRemoteDescription( |
|  | new RTCSessionDescription(data.offer) |
|  | ); |
|  | const answer = await peerConnection.createAnswer(); |
|  | await peerConnection.setLocalDescription(new RTCSessionDescription(answer)); |
|  |  |
|  | socket.emit("make-answer", { |
|  | answer, |
|  | to: data.socket |
|  | }); |
|  | }); |

[view raw](https://gist.github.com/tsh-code/5d34542fe5274341439ef92de7861cd3/raw/4c7af04448cd7006fc49cdb7fb69338ed4407585/on-call-made.js)[on-call-made.js](https://gist.github.com/tsh-code/5d34542fe5274341439ef92de7861cd3#file-on-call-made-js) hosted with ❤ by [GitHub](https://github.com/)

Then set a remote description on the offer you've got from the server and create an answer for this offer. On the server-side, you need to just pass proper data to the selected user.  Inside `server.ts`, let's add another listener:

|  | socket.on("make-answer", data => { |
|  | socket.to(data.to).emit("answer-made", { |
|  | socket: socket.id, |
|  | answer: data.answer |
|  | }); |
|  | }); |

[view raw](https://gist.github.com/tsh-code/5d34542fe5274341439ef92de7861cd3/raw/4c7af04448cd7006fc49cdb7fb69338ed4407585/make-answer.ts)[make-answer.ts](https://gist.github.com/tsh-code/5d34542fe5274341439ef92de7861cd3#file-make-answer-ts) hosted with ❤ by [GitHub](https://github.com/)

On the client's side we need to handle `answer-made` event:

|  | socket.on("answer-made", async data => { |
|  | await peerConnection.setRemoteDescription( |
|  | new RTCSessionDescription(data.answer) |
|  | ); |
|  |  |
|  | if (!isAlreadyCalling) { |
|  | callUser(data.socket); |
|  | isAlreadyCalling = true; |
|  | } |
|  | }); |

[view raw](https://gist.github.com/tsh-code/5d34542fe5274341439ef92de7861cd3/raw/4c7af04448cd7006fc49cdb7fb69338ed4407585/on-made-answer.js)[on-made-answer.js](https://gist.github.com/tsh-code/5d34542fe5274341439ef92de7861cd3#file-on-made-answer-js) hosted with ❤ by [GitHub](https://github.com/)

We use the helpful flag --` isAlreadyCalling` -- just to make sure we call only the user only once.

The last thing you need to do is to add local tracks -- audio and video to your peer connection, Thanks to this, we will be able to share video and audio with connected users. To do this, in the `navigator.getMediaDevice` callback we need to call the `addTrack` function on the `peerConnection `object.

|  | navigator.getUserMedia( |
|  | { video: true, audio: true }, |
|  | stream => { |
|  | const localVideo = document.getElementById("local-video"); |
|  | if (localVideo) { |
|  | localVideo.srcObject = stream; |
|  | } |
|  |  |
|  | stream.getTracks().forEach(track => peerConnection.addTrack(track, stream)); |
|  | }, |
|  | error => { |
|  | console.warn(error.message); |
|  | } |
|  | ); |

[view raw](https://gist.github.com/tsh-code/5d34542fe5274341439ef92de7861cd3/raw/4c7af04448cd7006fc49cdb7fb69338ed4407585/passing-tracks.js)[passing-tracks.js](https://gist.github.com/tsh-code/5d34542fe5274341439ef92de7861cd3#file-passing-tracks-js) hosted with ❤ by [GitHub](https://github.com/)

And we need to add a proper handler for `ontrack `event:

|  | peerConnection.ontrack = function({ streams: [stream] }) { |
|  | const remoteVideo = document.getElementById("remote-video"); |
|  | if (remoteVideo) { |
|  | remoteVideo.srcObject = stream; |
|  | } |
|  | }; |

[view raw](https://gist.github.com/tsh-code/5d34542fe5274341439ef92de7861cd3/raw/4c7af04448cd7006fc49cdb7fb69338ed4407585/setting-remote-video-stream.js)[setting-remote-video-stream.js](https://gist.github.com/tsh-code/5d34542fe5274341439ef92de7861cd3#file-setting-remote-video-stream-js) hosted with ❤ by [GitHub](https://github.com/)

As you can see, we've taken stream from the passed object and changed `srcObject `in remote-video to use received stream. So now after you click on the active user, you should make a video and audio connection, just like below:

![](https://tsh.io/wp-content/uploads/2019/11/how-to-write-a-real-time-video-chat-app-7_.png)

Read more: [Node.js and dependency injection -- friends or foes?](https://tsh.io/blog/dependency-injection-in-node-js/)

Now you know how to write a video chat app!
-------------------------------------------

WebRTC is a vast topic -- especially if you want to know how it works under the hood. Fortunately, we have access to easy-in-use JavaScript API, where we can create pretty neat apps, e.g. video-sharing, chat applications and much more!

If you want to deep dive into WebRTC, here's a link to [the WebRTC official documentation. ](https://webrtc.org/start/)My recommendation is to use [docs from MDN](https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API).
