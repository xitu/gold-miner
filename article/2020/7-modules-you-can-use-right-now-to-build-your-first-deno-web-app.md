> * 原文地址：[7 modules you can use right now to build your first Deno web app](https://medium.com/javascript-in-plain-english/7-modules-you-can-use-right-now-to-build-your-first-deno-web-app-b041a156a346)
> * 原文作者：[francesco marassi](https://medium.com/@marassi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/7-modules-you-can-use-right-now-to-build-your-first-deno-web-app.md](https://github.com/xitu/gold-miner/blob/master/article/2020/7-modules-you-can-use-right-now-to-build-your-first-deno-web-app.md)
> * 译者：[niayyy](https://github.com/niayyy-S)
> * 校对者：[qicoo](https://github.com/MangoTsing)

# 可以用来构建 Deno Web 应用程序的 7 个模块

![](https://cdn-images-1.medium.com/max/2048/0*NaSZcL23r-soB27b)

Deno 1.0.0 终于来了。这有一些资源将帮助你创建你的第一个 Deno Web 应用。

## Deno 是什么？

Deno  是由 [**Ryan Dahl**](https://en.wikipedia.org/wiki/Ryan_Dahl)创造的，你可能会听说他创造的另一个项目 —— 是的，正是 [**Node.js**](https://nodejs.org/en/)。

两年前，Ryan 在 JSConf 上做了一个演讲，题目为 《对于 Node.js 我感到遗憾的 10 件事情》，在那里他宣布他正在从事于 Deno，它将会成为比 Node **更安全**的版本，同时没有让项目臃肿的 **node_modules** 文件夹。

从 [**deno.land**](http://deno.land) 这个网站（从 Deno 的顶级域名可以看出吉祥物是一个恐龙）上可以看出，Deno 是一个**拥有默认的安全特性和良好的开发者体验的 JavaScript/TypeScript 运行时。它是使用 V8、Rust 和 Tokio 来构建的**.

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

你是一个 NoSQL 迷吗？你更喜欢把所有的数据放到一个没有固定结构的数据库吗？

如果你打算在 Deno 中使用 MongoDB，那么 Deno_mongo 是你所需要的。快速添加非结构化的数据到你的仓库吧💪。

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

很多时候，你将在 Web 应用程序中发送邮件。如果你需要发送邮件，这里有一些例子：

* 新用户的确认邮件；
* 忘记密码邮件；
* 订阅内容接收；
* ‘**Do you miss us**’ 邮件，当用户超过 7 天未使用你的应用程序（这是最糟糕的，请不要这样做）。

如果你需要发送那些重要的邮件，**Deno-smtp** 是你需要的，它将有助于你的日常活动。你也可以在邮件内容中添加 html！

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

你将开始在你本机上编写你的闪亮的新的 Deno 应用程序，上面的许多模块都使用了某种凭证（SMTP 证书、MongoDB url、ect…）。但是你不能直接把这些凭证放入你的代码中，因为：

* 在生产服务器上你将使用不同的凭证（或者至少我希望如此）；
* 你不想在一些仓库暴露它们。

Deno-dotenv 允许去设置 **.env** 文件。把你的凭证和环境变量放到 **.env** 文件中，然后使用这个模块获取它们：

```TypeScript
# .env
GREETING=hello world

# main.ts
import { config } from "https://deno.land/x/dotenv/mod.ts";

console.log(config());
```

这将打印出

```
> deno dotenv.ts
{ GREETING: "hello world" }
```
[**pietvanzoen/deno-dotenv**](https://github.com/pietvanzoen/deno-dotenv)

## 7. Denon

如果你使用 node 工作，你一定使用过 [Nodemon](https://nodemon.io/) 来当保存你在编写的文件时，自动重载你的本地服务器。

Denon 是基于 Deno 的这样的模块。

你首先需要使用 **deno install** 去安装

```bash
deno install --unstable --allow-read --allow-run -f 
https://deno.land/x/denon/denon.ts
```

然后你可以在你的应用程序文件路径使用 denon 来启动你的本地应用程序。下次你修改了你的应用程序，Denon 将自动重载你的 Deno 服务器！

[**eliassjogreen/denon**](https://github.com/eliassjogreen/denon)

## 除这些外，许多 npm 库已经兼容了 Deno！

是的，许多 npm 库已经兼容了 Deno！这是一个最新的特性：写一次代码，在 Node 和 Deno 中都能运行。

例如，你现在可以在 Deno 中导入并使用这些库：

[https://www.i18next.com/overview/getting-started](https://www.i18next.com/overview/getting-started)

[https://github.com/adrai/enum](https://github.com/adrai/enum)

许多其它的库将在下个月完全兼容 Deno。

## 在未来，Deno 将取代 Node.js 吗？

作出明确的回复还为时尚早。Deno 虽然已经到达了 1.0.0 版本，但还远远没有完成。

未来这几年，Node 还将是后端 JavaScript 的首选，但是拥有一个更安全和以正确的方式解决 JavaScript 最令人尴尬的部分之一（是的，我说的正是吃了太多的硬盘空间的 node_modules）的选择真是太棒了。

这些模块无疑将帮助你使用 Deno 编写你的第一个 Web 应用程序，并且将帮助围绕着这个新的运行时的社区更加的强大。

有任何关于 Deno 的问题？[在 Twitter](https://twitter.com/urcoilbisurco) 上告诉我，或者在文章下留言！

#### 相关资源

* 关于 Deno 想学习更多？官方网站有很棒的文档：[https://deno.land/manual/introduction](https://deno.land/manual/introduction)
* 想发现更多基于 Deno 的很棒的模块？[https://github.com/denolib/awesome-deno](https://github.com/denolib/awesome-deno) 有许多其它可以探索和使用的模块 ✨

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
