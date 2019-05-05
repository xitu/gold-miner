> * 原文地址：[Password Reset Emails In Your React App Made Easy with Nodemailer](https://itnext.io/password-reset-emails-in-your-react-app-made-easy-with-nodemailer-bb27968310d7)
> * 原文作者：[Paige Niedringhaus](https://medium.com/@paigen11)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/password-reset-emails-in-your-react-app-made-easy-with-nodemailer.md](https://github.com/xitu/gold-miner/blob/master/TODO1/password-reset-emails-in-your-react-app-made-easy-with-nodemailer.md)
> * 译者：
> * 校对者：

# Password Reset Emails In Your React App Made Easy with Nodemailer

> Resetting Passwords in JavaScript Apps Doesn’t Have to be Complicated

![](https://cdn-images-1.medium.com/max/4552/1*LlYcAoiR_1FakdL5FmTxRw.png)

### Password Resets in a MERN Application

Before I actually attempted to build in an email-based password reset for my MERN app, I thought it would be tougher to do. From everything I’d heard before, sending emails in a JavaScript application was painful, but I still wanted to attempt it.

For a few months, to hone my full stack JavaScript skills, I’ve been slowly building and adding on to a [user registration service](https://github.com/paigen11/mysql-registration-passport).

First, I built it with a React front end, an Express / Node.js backend and a Docker-powered MySQL database. I used a `docker-compose.yml` to start the whole app with one command (if you’d like to read more about my use of Docker for development, you can see this [blog post](https://medium.com/@paigen11/using-docker-docker-compose-to-improve-your-full-stack-application-development-1e41280748f4)).

After I’d gotten that working, I added in authorization to the app using Passport.js and JSON Web Tokens (JWTs). You can read about the fun (pain) of that [here](https://itnext.io/implementing-json-web-tokens-passport-js-in-a-javascript-application-with-react-b86b1f313436), if you’re curious. And it took me a while — I ran into a bunch of road blocks and obstacles that stalled me out multiple times. But grit and my inability to let go of a problem once it’s taken root in my brain prevailed, and I figured it out and moved on.

When I decided to tackle sending password reset links via email (just like real sites when users, myself included, inevitably forget their password), I figured I was in for more pain. It just couldn’t be too easy, no matter that practically every site out there has this very functionality. But I was wrong. And I’m so glad I was.

### Nodemailer — The Magic Bullet

![](https://cdn-images-1.medium.com/max/2000/1*srax5uIJJj_5mUkCtEI8xQ.png)

Once I started googling around looking for solutions to my password reset feature, I came across a number of articles recommending [Nodemailer](https://nodemailer.com/about/).

When I visited the website, the first lines I read were:

> Nodemailer is a module for Node.js applications to allow easy as cake email sending. The project got started back in 2010 when there was no sane option to send email messages, today it is the solution most Node.js users turn to by default. — Nodemailer

And you know what? It wasn’t kidding. Easy as cake isn’t too far wrong.

Of course, before I got started, I did a little more digging to make sure I was placing my faith in a decent piece of technology, and what I saw on [NPM](https://www.npmjs.com/package/nodemailer) and [Github](https://github.com/nodemailer/nodemailer) put my mind at ease.

Nodemailer has:

* Over 615,000 weekly downloads from NPM,
* Over 10,000 stars on Github,
* 206 releases to date,
* Over 2,500 dependent packages,
* And it’s been around in some form or fashion since 2010.

Ok, that seemed good enough for me to give it a shot in my own project.

### Implementation of Nodemailer in my code (front and backend)

I didn’t need anything fancy for my password reset, just:

* a way to send an email to a user’s address,
* and that email would contain a link that would redirect them to a protected page on my site where they could reset their password,
* and then they could log in using their new password.
* I also wanted the password reset link to expire after a certain time period for better security.

Here’s how I did it.

### Front End Code (Client Folder) — Send Reset Email

I’ll start with the React code first, because I had to have a page where users could enter their email addresses and fire off the email with the reset link.

**`ForgotPassword.js`**

![](https://cdn-images-1.medium.com/max/2704/1*r9V8XUjaYw-QBnLqv4kPiA.png)

Ok, I know this is a big screenshot but I’ll break it down (and I used the [Polacode](https://github.com/octref/polacode) extension in VS Code to make this beautiful screenshot, FYI). If you want to copy/paste the actual code, you can see the whole repo [here](https://github.com/paigen11/mysql-registration-passport).

What you should really focus on here is the `sendEmail` function and the `render` method of the component. The rest is just setting initial state and variables, and styling of buttons and elements.

**The Render Method**

![](https://cdn-images-1.medium.com/max/2704/1*xVFpFa-557DJ89nyW8kC6A.png)

Notice inside the `render` method, that I have a simple input box for the user to enter his/her email address, and a submit button which triggers the `this.sendEmail()` function when clicked. Beyond that, I have a little error and success handling built in based on if the user hasn’t entered an email, if the server responds back the email was successfully sent or it wasn’t a recognized address.

**The Send Email Function**

![](https://cdn-images-1.medium.com/max/2704/1*QFsQudnZUkRdd3PEZdH_fQ.png)

For all of my HTTP requests, I’m using the [Axios](https://www.npmjs.com/package/axios) library, which just makes it really easy to make AJAX calls to the server, even easier than the built in `fetch()` web API, in my opinion.

When the user enters their email, I make a POST request to the server, and wait for a response. If the email address isn’t found, I can tell the user they entered it wrong or if they’re new, they can go to the register page and create an account, and if the address does match one in my database, they’ll get back a success message saying the password reset link has been sent to their email address.

Let’s move on to the back end code now.

### Back End Code (API Folder) — Send Reset Email

**`forgotPassword.js`**

![](https://cdn-images-1.medium.com/max/4500/1*f1W9yIwc0rNyGYLQIpTK-A.png)

The back end code is a little more involved. This is where Nodemailer comes into play.

When the user hits the `forgotPassword` route on the back end with the email address they entered, the first thing Sequelize does is check if that email exists in my database. If it doesn’t the user gets notified they may have mistyped it, if it does exist, then a series of other events starts.

None of the following steps is very difficult, it’s just chaining them all together that was a little tricky, at first.

**Step 1: Generate a Token**

![](https://cdn-images-1.medium.com/max/2604/1*WB1CE9-HxjkbUXMuKX5gkA.png)

The first step after confirming the email is attached to a user in the database, is generating a token that can be attached to the user’s account and setting a time limit for that token to be valid.

Node.js has a built in module called [Crypto](https://nodejs.org/api/crypto.html#crypto_crypto), which provides cryptographic functionality, which is a fancy way of saying, I can generate a unique hash token easily using the command crypto.randomBytes(20).toString('hex');. Then, I save that new token to my user’s profile in the database under the column name `resetPasswordToken`. I also set a timestamp for how long that token will be valid. I made mine valid for one hour after sending the link — `Date.now() + 36000`.

**Step 2: Create Nodemailer Transport**

![](https://cdn-images-1.medium.com/max/2604/1*41dtjCfN-OV3HLpRvnSCKA.png)

Next, I created the `transporter` which is actually the account sending the password reset email link.

I chose to use Gmail, because I use Gmail personally, and I created a new dummy account to send the emails. Since I don’t want to give out the credentials for that account to anyone, I put the credentials into a `.env` file that is included in my `.gitignore` so it never gets committed to Github or anywhere else.

The NPM package `[dotenv](https://www.npmjs.com/package/dotenv)` is used to read the contents of the file and insert the email address and password for Nodemailer’s `createTransport` function to pick up.

**Step 3: Create Mail Options**

![](https://cdn-images-1.medium.com/max/4488/1*GSXm2RvmB2cccXRTF2J8GA.png)

The third step is creating the email template or `mailOptions` as Nodemailer calls it that the user will see (and this is also where the verified email address they pass from the front end input gets used).

There are whole third-party libraries for making great looking emails to go with the Nodemailer module, but I just wanted a bare bones email, so I made this one myself.

It contains the `from` email address (mySqlDemoEmail@gmail.com, for me), the user’s email goes in the `to` box, the `subject` line is something along the lines of reset password link, and the `text` is a simple string containing a little info and the website’s URL reset route including the token I created earlier, tacked on to the end. This will allow me to verify the user is who they say they are when they click the link and go to the site to reset their password.

**Step 4: Send Mail**

![](https://cdn-images-1.medium.com/max/2624/1*_w-0XM0OV5DLmylhmOh5vg.png)

The final step of this file actually putting together the pieces I created: the `transporter` the `mailOptions`, the `token` and using Nodemailer’s `sendMail()` function. If it works, I’ll get back a 200 response, which I then use to trigger a success call to the client, and if it fails, I log out the error to see what went wrong.

### Enabling Gmail to Send Reset Emails

There’s an extra gotcha to be aware of when setting up the transporter email that all the emails are sent from, at least, when using Gmail.

In order to be able to send emails from an account, 2-Step verification must be disabled, and a setting titled ‘Allow less secure apps’ must be toggled to on. See screenshot below. To do this, I went to my settings [here](https://myaccount.google.com/lesssecureapps), and turned it on.

Now, I could send reset emails with no problems. If you’re having trouble, check Nodemailer’s FAQs for more help.

![This is the screen you should see where you can turn ‘on’ less secure apps. Just one more reason to use some dummy email account instead of your actual Gmail account too.](https://cdn-images-1.medium.com/max/4152/1*R-Ee6gv6v__lBvP0bcuHZg.png)

### Front End Code — Update Password Screen

Great, now users should be getting reset emails in their inbox that look something like this.

![It’s a simple email, but it does what I need it to do.](https://cdn-images-1.medium.com/max/4844/1*B-_8dljYLsa7ewl22-1Udg.png)

If you notice, the third line is a link to my website (running locally on port 3031), to another page called ‘Reset’, followed by the hashed token I generated back in step 1 with the Node.js `crypto` module.

When a user clicks this link, they’re directed to a new page in the application entitled ‘Password Reset Screen’, which can only be accessed with a valid token. If the token has expired or is otherwise invalid, the user will see an error screen with links to go home or attempt to send a new password reset email.

Here’s the React code for the reset screen.

**`ResetPassword.js`**

![](https://cdn-images-1.medium.com/max/3188/1*Gia0EtrP3EWK9NT5TjAtlw.png)

And here’s the three main pieces of this component that do the heavy lifting.

**The Initial Component Did Mount Lifecycle Method**

![](https://cdn-images-1.medium.com/max/2564/1*ArzihAeJ6jv95v-dGMyeBQ.png)

This method fires as soon as the page is reached. It extracts the token from the URL query parameters and passes it back to the server’s `reset` route to verify the token is legit.

Then, the server either responds with an ‘a-ok’, this token is valid and associated with the user or a ‘no’, the token’s no good anymore for some reason.

**The Update Password Function**

![](https://cdn-images-1.medium.com/max/2604/1*iJgW4i4pBn18lCMGLfWlhQ.png)

This is the function that will fire if the user is authenticated and allowed to reset their password. It also accesses a specific route on the server called `updatePasswordViaEmail` (I did this because I gave users a separate route to update their password while logged in to the app, as well), and once the updated password has been saved to the database, a success message response is sent back to the client.

**The Render Method**

![](https://cdn-images-1.medium.com/max/2564/1*wmFa05AS8CE-pYLzhOwKpg.png)

The last piece of this component, is the `render` method. Initially, while the token is being verified for its validity, the `loading` message shows.

If the link is invalid in some way, the `error` message shows on the screen with links back to the home screen or forgot password page.

If the user is authorized to reset their password, they get the new password input with the `updatePassword()` function attached to it, and once the server’s responded with success updating the password, the `updated` boolean is set to true and the Your password has been successfully reset... message is shown along with a login button.

### Back End Code — Reset Password & Update Password

Ok, I’m in the home stretch now. Here’s the last two routes on the server side you’ll need. These correspond to the two methods I just walked through on the client side in the React`ResetPassword.js` component.

**`resetPassword.js`**

![](https://cdn-images-1.medium.com/max/2564/1*wrTzgtWpXLeDyut3JDFw2g.png)

This is the route that’s called on the `componentDidMount` lifecycle method on the client side. It checks the `resetPasswordToken` passed from the link’s query parameters and date timestamp to ensure that everything’s good.

You’ll notice the `resetPasswordExpires` parameter has an odd looking `$gt: Date.now()` parameter. This is an [operator alias comparator](http://docs.sequelizejs.com/manual/tutorial/querying.html#operators-aliases), which [Sequelize](http://docs.sequelizejs.com/) allows me to use, and all the `$gt:` stands for is ‘greater than’ whatever it is being compared to. In this instance, it’s comparing the current time to the expiration time stamp saved to the database when the reset password email was sent, to make sure the password’s being reset less than an hour after the email was sent.

As long as both parameters are valid for that user, the client is sent a successful response and the user can proceed with the password reset.

**`updatePasswordViaEmail.js`**

![](https://cdn-images-1.medium.com/max/2568/1*9DsfHUnYVyRXoCJt7S7bFA.png)

This is the second route that’s called when the user submits his/her password to be updated.

Once again, I find the user in the database (the `username` was passed back to the client from the `reset` route above and held in the app’s state until the update function was called), I hash the new password using my `bcrypt` module (just like my Passport.js middleware does when a new user is being written into the database initially),update that user’s `password` in the database with the new hash and set both the `resetPasswordToken` and `resetPasswordExpires` columns back to null, so the same link can’t be used more than once.

As soon as that’s complete, the server sends back a 200 response with the success message, `Password updated` for the client.

And you’ve successfully reset a user’s password via email. Not too tough.

### Conclusion

At first glance, resetting a user’s password via an email link seems a bit daunting. But Nodemailer helps make a major factor (the emailing bit) simple. And once that’s done it’s just a few routes on the server side and inputs on the client side to get that password updated for the user.

Check back in a few weeks, I’ll be writing about using Puppeteer and headless Chrome for end-to-end testing or something else related to web development, so please follow me so you don’t miss out.

Thanks for reading, I hope this gives you an idea of how to use Nodemailer to send password reset emails for a MERN application. Claps and shares are very much appreciated!

**If you enjoyed reading this, you may also enjoy some of my other blogs:**

* [The Absolute Easiest Way to Debug Node.js — with VS Code](https://itnext.io/the-absolute-easiest-way-to-debug-node-js-with-vscode-2e02ef5b1bad)
* [Implementing JSON Web Tokens & Passport.js in a JavaScript Application with React](https://itnext.io/implementing-json-web-tokens-passport-js-in-a-javascript-application-with-react-b86b1f313436)
* [Sequelize: Like Mongoose But for SQL](https://medium.com/@paigen11/sequelize-the-orm-for-sql-databases-with-nodejs-daa7c6d5aca3)

***

**References and Further Resources:**

* Nodemailer: [https://nodemailer.com/about/](https://nodemailer.com/about/)
* Nodemailer, Github: [https://github.com/nodemailer/nodemailer](https://github.com/nodemailer/nodemailer)
* Nodemailer, NPM: [https://www.npmjs.com/package/nodemailer](https://www.npmjs.com/package/nodemailer)
* MERN App with Nodemailer Repo: [https://github.com/paigen11/mysql-registration-passport](https://github.com/paigen11/mysql-registration-passport)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
