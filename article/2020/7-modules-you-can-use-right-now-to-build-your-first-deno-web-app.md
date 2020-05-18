> * 原文地址：[7 modules you can use right now to build your first Deno web app](https://medium.com/javascript-in-plain-english/7-modules-you-can-use-right-now-to-build-your-first-deno-web-app-b041a156a346)
> * 原文作者：[francesco marassi](https://medium.com/@marassi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/7-modules-you-can-use-right-now-to-build-your-first-deno-web-app.md](https://github.com/xitu/gold-miner/blob/master/article/2020/7-modules-you-can-use-right-now-to-build-your-first-deno-web-app.md)
> * 译者：
> * 校对者：

# 使用 7 个模块来构建第一个 Deno Web 应用

![](https://cdn-images-1.medium.com/max/2048/0*NaSZcL23r-soB27b)

Deno 1.0.0 终于来了。这有一些资源将帮助你创建你的第一个 Deno Web 应用。

## Deno 是什么？

Deno  是由 [**Ryan Dahl**](https://en.wikipedia.org/wiki/Ryan_Dahl)创造的，你可能会听说他创造的另一个项目 —— 是的，那就是 [**Node.js**](https://nodejs.org/en/)。

两年前，Ryan 在 JSConf 上做了一个演讲，题目为 ‘对于 Node.js 我感到遗憾的 10 件事情’，在那里他宣布他正在从事于 Deno，它将会成为 Node **更安全**的版本，同时没有让项目臃肿的 **node_modules** 文件夹。

从 [**deno.land**](http://deno.land) 这个网站（自从 Deno 的吉祥物是一个恐龙以来最好的域名），Deno 是一个 **JavaScript/TypeScript 运行时，拥有默认的安全特性和良好的开发者体验。使用 V8、Rust 和 Tokio 构建**.

前提概论很好，但如果你像我一样，你会想亲自动手来更好地理解它。

这有 **7 个 Deno 模块**可以帮助你创造一个 Web 应用和学习 Deno：

## 1. Dinatra

如果你学习过 Ruby 语言，你可能听说过 [Sinatra](http://sinatrarb.com/)，一个小型的 Web 框架，允许在 5 分钟内使用最小的工作量来构建一个 Web 服务器。

**Dinatra** 是基于 Deno 的 Sinatra，一个轻量的 Web 应用程序框架，现在你可以使用它来创建你的第一个基于 Deno 的 Web 应用程序。

这是一个示例：

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
  get("/foo", () => redirect("/hello", 302)), // 从 /foo 从定向到 /hello
  get("/info", () => [
    200,
    contentType("json"),
    JSON.stringify({ app: "dinatra", version: "0.0.1" }),
  ]),
);
```

你可以创建一个 CRUD 的方法，获取查询和 Body 内的参数，然后全部返回 JSON 格式的结果。

[**syumai/dinatra**](https://github.com/syumai/dinatra)

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

使用 Deno-Postgres，可以连接你的 Postgres 数据库和进行 SQL 查询。所有的方法返回 **Promise**，因此你可以对所有的结果使用 **await**。

[**buildondata/deno-postgres**](https://github.com/buildondata/deno-postgres)

## 3. Deno Nessie

访问和读取一个 Postgres 数据库是有趣的，但是你知道什么是无趣的吗？**更改数据库结构**。由于没有版本控制，单个的错误可能会破坏你所有存储的数据。一定要先备份数据，孩子们！

**Deno-nessie 是一个基于 Deno 的数据库迁移工具**，这将帮助你创建迁移文件和改变你的数据库中的表。通过这种方式你可以添加你的版本来控制所有的数据库修改历史，你的同事将能够轻松更改他们的本地数据库。

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

[**halvardssm/deno-nessie**](https://github.com/halvardssm/deno-nessie)

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
[**manyuanrong/deno_mongo**](https://github.com/manyuanrong/deno_mongo)

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
[**manyuanrong/deno-smtp**](https://github.com/manyuanrong/deno-smtp)

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
[**pietvanzoen/deno-dotenv**](https://github.com/pietvanzoen/deno-dotenv)

## 7. Denon

If you worked with node, you surely used [Nodemon](https://nodemon.io/) to automatically reload your local server when you saved a file you were working on.

Denon is exactly that, but for Deno.

You need to install it first with **deno install**

```bash
deno install --unstable --allow-read --allow-run -f 
https://deno.land/x/denon/denon.ts
```

And then you can start your local app with denon followed by your app file path. Next time you will make a change to your app, Denon will automatically reloads your Deno server!

[**eliassjogreen/denon**](https://github.com/eliassjogreen/denon)

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

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
