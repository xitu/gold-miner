* 原文地址：[How I built a web server using Go — and on ChromeOS](https://medium.freecodecamp.com/how-i-built-a-web-server-using-go-and-on-chromeos-3b83e4c2da5f#.rwir5yc1k)
* 原文作者：[Peter GleesonFollow](https://medium.freecodecamp.com/@petergleeson1?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：


# How I built a web server using Go — and on ChromeOS #

## Linux →ChromeOS →Android →Linux Emulator ##

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/2000/0*jHeP1Jefk_56SFZY.jpg">

Image via [WikiMedia](https://upload.wikimedia.org/wikipedia/commons/6/69/Wikimedia_Foundation_Servers-8055_35.jpg) 

“Why on earth did you get a Chromebook for web development?” is a question I’m occasionally asked. People don’t seem to believe I’m able to teach myself full-stack web development on a machine marketed for its simplicity and ease-of-use.

I’ll admit that when I bought the thing back before Christmas, I didn’t expect any miracles from it. As long as it came with a text editor and an internet browser, I saw it as a cheap, portable way of learning the basics of front-end web development and watching YouTube on the go. I was also sold on the whole ‘cloud computing’ concept (that stuff’s the *future*).

As it turns out, I’ve been pleasantly surprised by just how capable the little machine is. It boots up ridiculously fast, has a great battery life, and with the help of the omnipresent ‘cloud’, does pretty much most things you’d expect from any other machine. Plus, the model I chose comes with a touchscreen that folds right over into a variety of yoga positions to give you a tablet or a ‘tent’, or any other configuration you like, which if anything, looks cool.

Over the last couple of weeks, though, I’ve taken a bigger interest in back-end development (motivated in part by a turbulent relationship between myself and CSS). I’d read about how it is possible to install Ubuntu Linux on a Chromebook (if I understand correctly, ChromeOS itself is basically built upon an underlying Linux kernel). I might yet do this, but it appears to be a slightly involved process that requires switching to developer mode, and wipes the local storage and disables all the nice security features ChromeOS is known for. I decided to look for an alternative.

And I found one that works remarkably well. You see, Google have recently brought Android apps to some Chromebook models — and a few design/UX issues aside, anything that runs on your Android phone should run smoothly on ChromeOS. One such app I’ve installed is [Termux](https://termux.com/)  — a Linux emulator for Android, no rooting required. I’ve been playing around with it the last few days, and suffice to say, I’m very impressed. [Fredrik Fornwall](https://medium.com/@fornwall)  has done an incredible job.

I got started with a pair of [articles](https://medium.freecodecamp.com/building-a-node-js-application-on-android-part-1-termux-vim-and-node-js-dfa90c28958f)  written by [Aurélien Giraud](https://medium.com/@aurerua)  — and bam! Before I’d finished my morning coffee, I had a Node.js server and NeDB database up and running locally on my Chromebook — no scary developer mode necessary! If you have an Android device, I’d totally recommend bookmarking Aurélien’s tutorial and trying it out. You’ll have a Node.js server running on your phone in minutes.

Now I’m getting on just fine with Node, but I’m also interested in trying out a few other server-side languages —to see what the options are before narrowing down and picking one to focus on. One language I’ve been reading about is [Go](https://tour.golang.org/welcome/1) , introduced by Google back in 2009. It’s been doing alright lately and is growing in popularity — in fact, it has been named 2016’s [Programming Language of the Year](http://insights.dice.com/2017/01/10/go-tiobe-programming-language-2016/) .

Go is similar in some respects to languages like C and C++, and its design was indeed influenced by them. However, a primary motivation for creating Go in the first place was a dislike of the complexity of these long-established languages. As a result, Go is intentionally a much simpler language to use.

#### How much simpler? ####

For instance, there is no ‘while’ loop in Go. No, when it comes to loops, you’ve got one choice and one choice only: the ‘for’ loop.

```
//basically a 'while' loop:

for i < 1000 {
   //something
   i++
}
```

Type inference is optional. You can declare and initialise a variable the long way, or take a shortcut and assign type implicitly.

```
var x int = 2

//is the same as:

x := 2
```

‘If’ and ‘else’ statements are pretty straightforward:

```
x := 5

if x > 10 {
   fmt.Println("Greater than 10")
} else {
     fmt.Println("Less than or equal to 10")
}
```

Go is also fast to compile and comes with all sorts of helpful packages available in the standard library, which is well-documented online. It’s been used in a number of [projects](https://en.wikipedia.org/wiki/Go_%28programming_language%29#Projects_using_Go) , including some by household names such as Google, Dropbox, Soundcloud, Twitch and Uber.

I reasoned that if it’s good enough for them, it’s probably worth taking a look at. For anyone else taking their first steps into back-end development, I’ve put together a little tutorial, based upon my experiments with Go using Termux. If you have an Android device, or indeed a Chromebook with access to the Play Store, then get Termux installed and running, and we’re ready to go (EDIT: pun *not* actually intended).

If you have a conventional Linux device, feel free to join in as well! The instructions for the server program itself should work just fine on [any platform that supports Go.](https://golang.org/doc/install) 

#### Get Going With Termux ####

Termux, like any other Android app, is very straightforward to download and install. Just search the Play Store, and hit INSTALL. Once it’s ready, open it up. You should have a nice blank command line interface looking back at you. I’d strongly recommend using a physical keyboard (either built-in, or micro-USB or Bluetooth connected), but if you don’t have one to hand, I’ve heard good things about another Android app called Hacker’s Keyboard.

As covered in Aurélien’s tutorial from last year, Termux comes with very little pre-installed. Run the following commands in the terminal:

```
$ apt update
$ apt upgrade
$ apt install coreutils
```

Good. Everything’s up-to-date, and coreutils will help you navigate the file system a little easier. Let’s check where we are in the directory tree.

```
$ pwd
```

This should return a path name, showing where you currently are in the directory. If we’re not already there, let’s navigate to the ‘home’ folder, and see what’s inside:

```
$ cd $HOME && ls
```

Ok, let’s make a new directory for our Go tutorial, and navigate in there. Then, we can create a new file, called ‘server.go’.

```
$ mkdir go-tutorial && cd go-tutorial
$ touch server.go
```

If we type ‘ls’, we will see this one file in our directory. Now, let’s get ourselves a text editor. Aurélien’s tutorial introduces you to Vim, and if you’d prefer use that, then by all means do so. A slightly more ‘beginner-friendly’ editor, which I’ll be using here, is one called nano. Let’s install that, and open our server.go file:

```
$ apt install nano
$ nano server.go
```

Great! Now we can start typing as much code as we like. But before we do, let’s install the Go compiler, because we’ll kinda need this for our code to be of any use. Quit nano with Ctrl+X, and from the command line, type:

```
$ apt install golang
```

Now, let’s go back into nano, and start writing our server code!

#### Building a Simple Web Server ####

We’re going to write a simple program that launches a server, and serves a HTML page that lets the user enter a password to login and see a welcome message (or a “Sorry, try again”-type message if the password is wrong). In nano, begin with the following:

```
//Build a web server

package main

import (
   "fmt"
   "net/http"
)
```

What we’ve done is create a package. Go programs always run in packages. It’s a way of storing and organizing code, and lets you call functions from other packages nice and easily. In fact, that’s the next thing we’ve written. We’ve told Go to import the ‘fmt’ package, and the ‘http’ package from the ‘net’ directory within the standard library. This gives us access to functions that lets us play around with ‘formatted I/O’, and HTTP requests and responses.

Now, let’s get this thing online. A few lines down, let’s write the following code:

```
func main() {
   http.ListenAndServe(":8080",nil)
   fmt.Println("Server is listening at port 8080")
}
```

Like C, C++, Java etc., Go programs enter with a ‘main()’ function. We’ve told the server to listen out for requests at port 8080 (although feel free to choose a different number), and to print out a message letting us know that’s what it’s doing.

That’ll do for now! Let’s save the file (Ctrl+O), exit (Ctrl+X) and run our program. At the command line, type:

```
go run server.go
```

This will ask the Go compiler to both compile and run the program. After a short pause, the program should run. You’ll hopefully see the following output:

```
Server is listening at port 8080
```

Brilliant! Your server is listening for requests at port 8080. Unfortunately, it has no idea what to do with any requests it receives, because we haven’t told it how to respond. That’s the next step. Interrupt the server program with Ctrl+C, and reopen server.go in nano.

#### Sending a Response ####

We need the server to ‘handle’ requests, and write back appropriate responses. Thankfully, the ‘http’ package we imported makes this easy to do.

For the sake of readability, let’s insert the following code between the import() statement and the main() function. We could just carry on below the main() function, however, and all would be fine. Do it your way!

Anyway, let’s write a handler function.

```
func handler (write http.ResponseWriter, req *http.Request) {
   fmt.Fprint(write, "<h1>Hello!</h1>")
}
```

This is a function that takes two arguments, *write* and *req*. These are assigned types *ResponseWriter* and* *Request*, which are defined in the ‘http’ package. We then ask the server to write some HTML in response.

In order to use this function, we need to call it within the main() function. Add the code in **bold** font below:

```
func main() {
   http.ListenAndServe(":8080",nil)
   fmt.Println("Server is listening at port 8080")
   http.HandleFunc("/", handler)
}
```

The line we’ve added calls HandleFunc() from the ‘http’ package. This takes two arguments. The first is a string, and the second refers to the handler() function we wrote just a moment ago. We’re asking the server to handle all requests to the web root “/” with the handler() function.

Save and close server.go, then from the console, run the server again.

```
go run server.go
```

Again, we should see the output message, letting us know the server is listening out for requests. Well, why don’t we send it a request? Just open up your web browser and visit [http://localhost:8080/](http://localhost:8080) .

Chromebooks tend to be pretty opinionated about which browser you should use, but I found that Chrome to be somewhat uncooperative when it came to connecting to any localhost ports. Installing the Mozilla Firefox for Android app from the Play Store resolved this.

Alternatively, if you’d like to stay entirely within Termux (and why not?), then check out Lynx. It’s a text-based browser which has been around since 1992. There’s no images, no CSS, and certainly no JavaScript. For the purposes of this tutorial though, it does the job nicely. Install and run with:

```
$ apt install lynx
$ lynx localhost:8080
```

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*akBwgTRiLA3WG5PqpGJ2eQ.png">

Medium’s homepage, as viewed in the Lynx browser running in Termux.

If all is well, you should be greeted in your browser of choice with a heading saying “Hello!” If not, head back into nano and review server.go. Errors I made the first time round included using curly braces {} instead of brackets for the import() statement. There were also a couple of stray commas masquerading as dots (maybe I should use Ctrl+Alt+’+’ to increase the font size in Termux).

#### The World’s Most Exclusive Website ####

Our server now responds to HTTP requests with a nice short line of HTML. Not exactly the next Facebook, but one step closer than we were before. Let’s make it a bit more interesting.

To recap: we’re going to make a page that asks the user for a password. If the password is wrong, the user gets a warning message telling them so. If it is correct, then the user receives a great big message saying “Welcome!” As it’s your own server on your own machine, and only you will know the password, it’s going to be a *very* exclusive website.

First off, let’s make the HTML response a bit more interesting. Go back to the `handler()` function we wrote before. Paste in all of the code in **bold** in place of what’s already there (it’s all one line). Careful with the quote marks! I’ve started and ended the string with double-quotes, and used single-quotes within the HTML section. Make sure you’re consistent.

```
func handler (write http.ResponseWriter, req *http.Request) {
   fmt.Fprint(write, "<h1>Login</h1><form action='/log-in/' method='POST'> Password:<br> <input type='password' name='pass'><br> <input type='submit' value='Go!'></form>")
}
```

When we run the server, the HTML should render the following page:

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*akpgU8Iox9RqGoOC0SC40A.png">

Foreground: Mozilla Firefox for Android; Background: Lynx for Termux

Now, I’m aware that I’m assuming a little familiarity with HTML here. Briefly, what we have is a header and a form. The form’s ‘action’ attribute is called ‘/log-in/’ and its method is set to POST. There are two input fields: one for password entry, and another to submit the form. The password field is named “pass”. We’ll need to refer to these names later on.

So what happens if we enter a password and submit it? Well, we’re making another HTTP request (“/log-in/”) to the server, so we need to write another function that handles this request. Back to Termux, and open up server.go in your text editor of choice.

We’re going to make another function (personally, I’d write it between handler() and main(), but do whatever suits you). This is another function to handle HTTP requests — this time, to “/log-in/” requests, which are made whenever the user submits the form we made earlier.

```
func loginHandler (write http.ResponseWriter, req *http.Request){

   password := req.FormValue("pass")

   if password == "let-me-in" {
                fmt.Fprint(write, "<h1>Welcome!</h1>")

   } else {
         fmt.Fprint(write, "<h3>Wrong password! Try again.</h3>")
   }

}
```

As before, this function has two arguments, *write* and *req*, which are assigned the same types as defined in the ‘http’ package.

We then create a variable called *password*, which we set equal to the ‘value’ of the request form’s input field called “pass”. Notice the implicit type assignment with the use of “:=”? We can do this because the password field’s value will always be sent as a string.

Next up is an ‘if’ statement, using the “==” comparison operator to check if *password* is identical to the string “let-me-in”. This is of course, how we’re defining the correct password. You can change this string to whatever you like.

If the strings *are* identical, you’re in! For now, we’re printing out a boring “welcome” message. We’ll change that in a minute.

Else, if the strings are *not* identical, we’re printing out a “try again” message. Again, we could do with making that a little more interesting. For a start, it’d be useful if the password form was still available to the user. Add in the following code in **bold**. All it is, is the same password form HTML from before.

```
func loginHandler (write http.ResponseWriter, req *http.Request){

password := req.FormValue("pass")

if password == "let-me-in" {
                fmt.Fprint(write, "<h1>Welcome!</h1>")

} else {
         fmt.Fprint(write, "**<h1>Login</h1><form action='/log-in/' method='POST'> Password:<br> <input type='password' name='pass'><br> <input type='submit' value='Go!'></form>**<h3 **style='color: white; background-color: red'**>Wrong password! Try again.</h3>")
   }

}
```

I’ve also added some simple styling to the “try again” message. Totally optional, but why not? Let’s do the same for the “welcome” message:

```
func loginHandler (write http.ResponseWriter, req *http.Request){

password := req.FormValue("pass")

if password == "let-me-in" {
                fmt.Fprint(write, "**<h1 style='color: white; background-color: navy; font-size: 72px'>**Welcome!</h1>")

} else {
         fmt.Fprint(write, "<h1>Login</h1><form action='/log-in/' method='POST'> Password:<br> <input type='password' name='pass'><br> <input type='submit' value='Go!'></form><h3 style='color: white; background-color: red'>Wrong password! Try again.</h3>")
   }

}
```

Almost there! We’ve written out our loginHandler() function, but there’s no reference to it in our main() function. Add the following **bold** line of code:

```
func main() {
   http.ListenAndServe(":8080",nil)
   fmt.Println("Server is listening at port 8080")
   http.HandleFunc("/", handler)
   http.HandleFunc("/log-in/", loginHandler)
}
```

There! We’ve now told the server that if it receives a “/log-in/” request (which it will whenever the user clicks the submit button), use the `loginHandler()` function to make a response. We’re done! The whole code in server.go should look something like that below:

```
//Build a web server

package main

import (
   "fmt"
   "net/http"
)

func handler (write http.ResponseWriter, req *http.Request) {
   fmt.Fprint(write, "**<**h1>Login</h1><form action='/log-in/' method='POST'> Password:<br> <input type='password' name='pass'><br> <input type='submit' value='Go!'></form>")
}

func loginHandler (write http.ResponseWriter, req *http.Request){
   password := req.FormValue("pass")
   if password == "let-me-in" {
                fmt.Fprint(write, "<h1 style='color: white;       background-color: navy; font-size: 72px'>Welcome!</h1>")
   } else {
         fmt.Fprint(write, "<h1>Login</h1><form action='/log-in/' method='POST'> Password:<br> <input type='password' name='pass'><br> <input type='submit' value='Go!'></form><h3 style='color: white; background-color: red'>Wrong password! Try again.</h3>")
   }
}

func main() {
   http.ListenAndServe(":8080",nil)
   fmt.Println("Server is listening at port 8080")
   http.HandleFunc("/", handler)
   http.HandleFunc("/log-in/", loginHandler)
}
```

Save and exit nano, and from the command line, let’s ask the Go compiler to *build* our server. This command compiles the program once, and lets us run it whenever we like thereafter.

```
go build server.go
```

Give it a moment or two to compile, then enter the following command:

```
./server
```

You should get the usual “listening” message. Now, if you go to the browser and access [http://localhost:8080](http://localhost:8080) , you’ll be asked to enter the password. If we enter it incorrectly, we get the following:

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*RKnDclkFGuf1vHIJk8Y25w.png">

Nope

Whereas, if we enter the correct password:

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*pDsiYj8so6H1KcMEjiMZxw.png">

Firefox appears a little more enthusiastic than Lynx…

#### Concluding Remarks ####

If you’ve read this far, I hope you’ve enjoyed the tutorial and found it helpful. I’ve pitched it at readers in a similar position as myself — kinda new to the whole web development thing and interested to learn more about how it works on the server-side, behind-the-scenes.

Of course, the simple login page we made here still has a long way to go before it’s anything to write home about. You wouldn’t really write the HTML into the handler functions as we did here (Go’s html package has some nice templating options that I’m going to look into), nor would you define the correct password in an ‘if’ statement. It’d be much better to have a database of passwords (and usernames), which you’d query each time the server received a log-in request.

To that end, Termux does offer a SQLite package, as well as various database packages available in Node.js. A cool extension to this tutorial would be to create a database of usernames and their passwords, and allow new users to be added. You’d begin by adding another input field, and altering the loginHandler() function.

I’ve already expressed my opinion of Termux — it’s remarkable, and I look forward to it only getting better as more packages become available. As well as Go and Node.js, I’ve successfully written and compiled/run simple programs in C, C++, CoffeeScript, PHP and Python 3.6, and there’s still other languages I haven’t yet looked at (anyone into Erlang/Lua/PicoLisp?)

As for Go, my first encounter has been a positive one. I like its focus on simplicity, and I like the syntax, and the documentation is at a level that is accessible, yet pushes me to develop my understanding. For what a relative beginner’s opinion is worth on the matter, it feels like a cross between C++ and Python. To some extent, that’s probably exactly what it’s meant to be!
