> * 原文地址：[7 modules you can use right now to build your first Deno web app](https://medium.com/javascript-in-plain-english/7-modules-you-can-use-right-now-to-build-your-first-deno-web-app-b041a156a346)
> * 原文作者：[francesco marassi](https://medium.com/@marassi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/7-modules-you-can-use-right-now-to-build-your-first-deno-web-app.md](https://github.com/xitu/gold-miner/blob/master/article/2020/7-modules-you-can-use-right-now-to-build-your-first-deno-web-app.md)
> * 译者：
> * 校对者：

# 7 modules you can use right now to build your first Deno web app

![](https://cdn-images-1.medium.com/max/2048/0*NaSZcL23r-soB27b)

#### Deno 1.0.0 is finally here. Here are some resources that will help you create your first Deno web app.

## What is Deno?

Deno is created by [**Ryan Dahl**](https://en.wikipedia.org/wiki/Ryan_Dahl), that is also the creator of something that you may have heard of… yes, [**Node.js**](https://nodejs.org/en/).

2 years ago, Ryan did a presentation at JSConf called ’10 Things I Regret About Node.js’ where he announced that he was working on Deno, that was going to be a **more secure** version of Node and without the **node_modules** folder that bloats your project.

From the [**deno.land**](http://deno.land) website (best domain ever since the Deno mascotte is a Dinosaur), Deno is a **JavaScript/TypeScript runtime with secure defaults and a great developer experience. It’s built on V8, Rust, and Tokio**.

The premises are great, but if you are like me, you will want to get your hands dirty on this to understand it better.

Here are **7 Deno modules** that can help you create a web app and learn about Deno:

## 1. Dinatra

If you are coming from the Ruby language, you may have heard of [Sinatra](http://sinatrarb.com/), a little web framework that permits in 5 minutes to put online a web server with minimal effort.

**Dinatra** is Sinatra but for Deno, a lightweight web app framework that you can use right now to create your first web app in Deno.

Here is an example:

```TypeScript
import {
  app,
  get,
  post,
  redirect,
  contentType,
} from "https://denopkg.com/syumai/dinatra@0.12.0/mod.ts";

app(
  get("/hello", () => "hello"),
  get("/hello/:id", ({ params }) => params.id),
  get(
    "/hello/:id/and/:name",
    ({ params }) => `:id is ${params.id}, :name is ${params.name}`,
  ),
  get("/error", () => [500, "an error has occured"]),
  get("/callName", ({ params }) => `Hi, ${params.name}!`),
  post("/callName", ({ params }) => `Hi, ${params.name}!`),
  get("/foo", () => redirect("/hello", 302)), // redirect from /foo to /hello
  get("/info", () => [
    200,
    contentType("json"),
    JSON.stringify({ app: "dinatra", version: "0.0.1" }),
  ]),
);
```

You can create CRUD methods, access Query and Body parameters, and return JSON all out of the box.
[**syumai/dinatra**
**Sinatra like light weight web app framework for deno. - syumai/dinatra**github.com](https://github.com/syumai/dinatra)

## 2. Deno Postgres

```TypeScript
import { Client } from "https://deno.land/x/postgres/mod.ts";

async function main() {
  const client = new Client({
    user: "user",
    database: "test",
    host: "localhost",
    port: "5432"
  });
  await client.connect();
  const result = await client.query("SELECT * FROM people;");
  console.log(result.rows);
  await client.end();
}

main();
```

With Deno-Postgres, you can connect to your Postgres database and make SQL queries. All methods returns **promises**, so you will be able to use **await** for all the results.
[**buildondata/deno-postgres**
**PostgreSQL driver for Deno. It's still work in progress, but you can take it for a test drive! deno-postgres is being…**github.com](https://github.com/buildondata/deno-postgres)

## 3. Deno Nessie

Accessing and reading a Postgres database is fun, but you know what is not fun? **Changing the database structure.** You have no version control and a single error can destroy all your stored data. Always backup your data first, kids!

**Deno-nessie is a database migration tool for Deno**, that will help you create migration files and altering your tables. In this way you can add to your version control all the history of your database changes and your colleagues will be able to alter their local databases in a breeze.

```TypeScript
import { Schema } from "https://deno.land/x/nessie/mod.ts";

export const up = (scema: Schema): void => {
  scema.create("users", (table) => {
    table.id();
    table.string("name", 100).nullable();
    table.boolean("is_true").default("false");
    table.custom("custom_column int default 1");
    table.timestamps();
  });

  scema.queryString(
    "INSERT INTO users VALUES (DEFAULT, 'Deno', true, 2, DEFAULT, DEFAULT);",
  );
};

export const down = (schema: Schema): void => {
  schema.drop("users");
};
```
[**halvardssm/deno-nessie**
**A database migration tool for deno inspired by Laravel. Supports PostgreSQL and MySQL, soon: SQLite. See documentation…**github.com](https://github.com/halvardssm/deno-nessie)

## 4. Deno Mongo

Are you a NoSQL fanboy? Do you prefer to put all your data inside your database without a fixed structure?

Deno_mongo is what you need to use MongoDB with Deno. You will start adding unstructured data to your repos in less than a minute 💪

```TypeScript
import { init, MongoClient } from "https://deno.land/x/mongo@v0.5.2/mod.ts";

// Initialize the plugin
await init();

const client = new MongoClient();
client.connectWithUri("mongodb://localhost:27017");

const db = getClient().database("test");
const users = db.collection("users");

// insert
const insertId = await users.insertOne({
  username: "user1",
  password: "pass1"
});

// insertMany
const insertIds = await users.insertMany([
  {
    username: "user1",
    password: "pass1"
  },
  {
    username: "user2",
    password: "pass2"
  }
]);

// findOne
const user1 = await users.findOne({ _id: insertId });

// find
const users = await users.find({ username: { $ne: null } });

// count
const count = await users.count({ username: { $ne: null } });

```
[**manyuanrong/deno_mongo**
**MongoDB driver for Deno. Contribute to manyuanrong/deno_mongo development by creating an account on GitHub.**github.com](https://github.com/manyuanrong/deno_mongo)

## 5. Deno SMTP

Lots of times you will need to send emails inside your web app. Here are some example of email that you will need to send:

* Confirmation emails for new users;
* Forgot password emails;
* Subscriptions Receipts;
* ‘**Do you miss us**’ emails when the user doesn’t visit your app for 7+ days (these are the worst. Please, don’t do this)

**Deno-smtp** is what you need to send those important email that will help your day-to-day activity. You can also add html to the content of the email!

```TypeScript
import { SmtpClient } from "https://deno.land/x/smtp/mod.ts";

const client = new SmtpClient();

await client.connect({
  host: "smtp.163.com",
  port: 25,
  username: "username",
  password: "password",
});

await client.send({
  from: "mailaddress@163.com",
  to: "to-address@xx.com",
  subject: "Mail Title",
  content: "Mail Content，maybe HTML",
});

await client.close();
```
[**manyuanrong/deno-smtp**
**SMTP implements for deno. Contribute to manyuanrong/deno-smtp development by creating an account on GitHub.**github.com](https://github.com/manyuanrong/deno-smtp)

## 6. Deno Dotenv

You will start coding your shiny new Deno app on your local PC, and lots of the modules above uses some kind of credentials (SMTP credentials, MongoDB urls, ect…). But you can’t put these credentials directly in your code, because:

* on the production server you will use different credentials (or at least I hope so)
* you don’t want to expose them on some git repository.

Deno-dotenv permits to handle **dotenv** files. Just put your credentials and ENV Variables in the **.env** file and access them with this module:

```TypeScript
# .env
GREETING=hello world

# main.ts
import { config } from "https://deno.land/x/dotenv/mod.ts";

console.log(config());
```

This will print

```
> deno dotenv.ts
{ GREETING: "hello world" }
```
[**pietvanzoen/deno-dotenv**
**Dotenv handling for deno. Setup a .env file in the root of your project. GREETING=hello world Then import the…**github.com](https://github.com/pietvanzoen/deno-dotenv)

## 7. Denon

If you worked with node, you surely used [Nodemon](https://nodemon.io/) to automatically reload your local server when you saved a file you were working on.

Denon is exactly that, but for Deno.

You need to install it first with **deno install**

```
deno install --unstable --allow-read --allow-run -f 
https://deno.land/x/denon/denon.ts
```

And then you can start your local app with denon followed by your app file path. Next time you will make a change to your app, Denon will automatically reloads your Deno server!
[**eliassjogreen/denon**
**Denon aims to be the deno replacement for nodemon providing a feature packed and easy to use experience. Denon provides…**github.com](https://github.com/eliassjogreen/denon)

## But… lots of npm libraries are already compatible with Deno!

Yes, lots of npm libraries are already compatible with Deno! That’s one of the best feature: write the code once and run it on both Node and Deno.

For example, you can already import and use these libraries in Deno right now:

[https://www.i18next.com/overview/getting-started](https://www.i18next.com/overview/getting-started)

[https://github.com/adrai/enum](https://github.com/adrai/enum)

And lots of other will become full-compatible with Deno in the next months.

## Will Deno replace Node.js in the future?

It’s still quite early to give a clear response. Deno has reached 1.0.0 but it’s far from finished.

For some years Node will still be the #1 choice for backend JavaScript, but it’s great to have an alternative that is more secure and addresses in the right way one of the most embarassing parts of JavaScript (yes, I’m speaking about that big massive hard disk eater of node_modules).

These modules surely will help working on some first web apps written in Deno and will help the community around this new runtime become stronger.

Have any questions about Deno? Let me know [on Twitter](https://twitter.com/urcoilbisurco) or reply to this article!

#### Resources

* Want lo learn more about Deno? The official website has a great documentation: [https://deno.land/manual/introduction](https://deno.land/manual/introduction)
* Want to find some more awesome Modules for Deno? [https://github.com/denolib/awesome-deno](https://github.com/denolib/awesome-deno) has lots of other modules to explore and to use ✨

#### A note from the Plain English team

Did you know that we have four publications? Show some love by giving them a follow: [**JavaScript in Plain English**](https://medium.com/javascript-in-plain-english), [**AI in Plain English**](https://medium.com/ai-in-plain-english), [**UX in Plain English**](https://medium.com/ux-in-plain-english), **[Python in Plain English](https://medium.com/python-in-plain-english)** — thank you and keep learning! We’ve also launched a YouTube and would love for you to support us by [**subscribing to our Plain English channel**](https://www.youtube.com/channel/UCtipWUghju290NWcn8jhyAw)

And as always, Plain English wants to help promote good content. If you have an article that you would like to submit to any of our publications, send an email to **[submissions@plainenglish.io](mailto:submissions@plainenglish.io)** with your Medium username and what you are interested in writing about and we will get back to you!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
