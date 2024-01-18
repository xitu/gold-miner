> * 原文地址：[Achieve Next.js Mastery: Build a Sales Page with Stripe and Airtable](https://dev.to/triggerdotdev/achieve-nextjs-mastery-build-a-sales-page-with-stripe-and-airtable-1p5m)
> * 原文作者：[Eric Allam](https://dev.to/maverickdotdev)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2023/4achieve-nextjs-mastery-build-a-sales-page-with-stripe-and-airtable.md](https://github.com/xitu/gold-miner/blob/master/article/2023/achieve-nextjs-mastery-build-a-sales-page-with-stripe-and-airtable.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：

# 实现熟练使用 Next.js：使用 Stripe 和 Airtable 搭建一个销售页面

在这个教程中，你将学习如何构建一个销售落地页：

- 使用 Next.js 构建整个销售页面。
- 通过 Stripe 进行支付。
- 将支付的详细信息保存到 Airtable 数据库中。

![Price](https://res.cloudinary.com/practicaldev/image/fetch/s--hSROD7md--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/rl8xnljxxmiww802y6rw.gif)

___

## 你的 Next.js 后台作业管理系统

[Trigger.dev](https://trigger.dev/) 是一个可以让你在 Next.js、Remix、Astro 等应用中创建和监视长时间运行任务的开源库！

如果你愿意花一点时间来给我点个 Star，我将不胜感激 💖
[https://github.com/triggerdotdev/trigger.dev](https://github.com/triggerdotdev/trigger.dev)

[![GiveStar](https://res.cloudinary.com/practicaldev/image/fetch/s--jmfYPyVI--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/9wsljq85zi71b0pksld7.png)](https://github.com/triggerdotdev/trigger.dev)

___

## 让我们来设置一下🔥

在这里，我将带你逐步创建课程主页的用户界面。

通过运行下面的代码片段创建一个新的 TypeScript Next.js 项目。

```shell
npx create-next-app course-page
```

安装 [React Icons](https://react-icons.github.io/react-icons) package，这样让我们在应用程序中可以使用各式的 Icon。

```shell
npm install react-icons --save
```

应用分为两个页面：主页，代表课程的着陆页面，和成功页面，用户在付款后会显示。

### 主页 🏠

主页分为五个部分 - 导航栏、页眉、功能展示、购买部分和页脚。

![Scroll](https://res.cloudinary.com/practicaldev/image/fetch/s--9CdteCXn--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/cex2b139qxtv48vbf0mj.gif)

更新 `index.tsx` 文件（如下所示）。占位符代表着首页的每个部分。

```tsx
import { Inter } from "next/font/google";
const inter = Inter({ subsets: ["latin"] });

export default function Home() {
    return (
        <main className={` ${inter.className}`}>
            {/* --- Navigation bar --- */}
            <p>Hello world</p>
            {/* --- Header --- */}

            {/* --- Features Section --- */}

            {/* --- Purchase Now Section--- */}

            {/* --- Footer Section --- */}
        </main>
    );
}
```

用下面的代码段替换 `Navigation bar` 占位符.

```tsx
<nav className='md:h-[12vh] w-full md:p-8 p-4 flex items-center justify-between border-b-[1px] border-b-gray-200 bg-white sticky top-0 z-20'>
    <h2 className='text-2xl font-bold text-purple-600'>TechGrow</h2>
    <button className='bg-purple-600 hover:bg-purple-800 text-white px-5 py-3 rounded-2xl'>
        Get Started
    </button>
</nav>
```

将以下代码片段复制到 `Header` 部分。你可以从 GitHub Repo 中获取这些[图片](https://github.com/triggerdotdev/blog/tree/main/sales-page/src/images).

```tsx
<header className='min-h-[88vh] w-full md:px-8 px-4 py-12 flex md:flex-row flex-col items-center justify-between'>
    <div className='md:w-[60%] w-full md:pr-6 md:mb-0 mb-8'>
        <h2 className='font-extrabold text-5xl mb-4'>
            Future-Proof Your Career with Top Digital Skills!
        </h2>
        <p className='opacity-60 mb-4'>
            Unlock your full potential of a future-proof career through the power of
            top digital skills with our all-in-one growth package.
        </p>
        <button className='bg-purple-600 hover:bg-purple-800 w-[200px] text-white px-5 py-3 rounded-2xl text-lg font-semibold'>
            Get Started
        </button>
    </div>
    <div className='md:w-[40%] w-full'>
        <Image src={headerImage} alt='Man smiling' className='rounded-lg' />
    </div>
</header>
```

`Feature` 展示部分可以给用户展现为什么他们应该购买这一课程的原因。

```tsx
<section className='w-full min-h-[88vh] bg-purple-50 md:px-8 px-4 py-14 '>
    <h2 className='font-extrabold text-3xl text-center mb-4'>Why Choose Us?</h2>
    <p className='opacity-50 text-center'>
        Unlock your full potential of a future-proof career
    </p>
    <p className='opacity-50 mb-14 text-center'>
        that surpasses your expectation.
    </p>
    <div className='flex w-full items-center justify-between md:space-x-6 md:flex-row flex-col'>
        <div className='md:w-1/3 md:mb-0 mb-6 w-full bg-white rounded-xl px-5 py-8 hover:border-[1px] hover:border-purple-600 hover:shadow-md'>
            <div className='rounded-full p-4 bg-purple-50 max-w-max mb-2'>
                <FaChalkboardTeacher className='text-2xl text-purple-800' />
            </div>
            <p className='font-bold text-lg mb-2'>Expert instructors</p>
            <p className='text-sm opacity-50'>
                Learn from industry experts, gaining unique insights which cannot be
                found elsewhere.
            </p>
        </div>
        <div className='md:w-1/3 md:mb-0 mb-6 w-full bg-white rounded-xl px-5 py-8 hover:border-[1px] hover:border-purple-600 hover:shadow-md'>
            <div className='rounded-full p-4 bg-purple-50 max-w-max mb-2'>
                <IoDocumentTextSharp className='text-2xl text-purple-800' />
            </div>
            <p className='font-bold text-lg mb-2'>Hands-On Projects</p>
            <p className='text-sm opacity-50'>
                Learn practical, real-world digital skills through relevant projects and
                interactive sessions.
            </p>
        </div>
        <div className='md:w-1/3 md:mb-0 mb-6 w-full bg-white rounded-xl px-5 py-8 hover:border-[1px] hover:border-purple-600 hover:shadow-md'>
            <div className='rounded-full p-4 bg-purple-50 max-w-max mb-2'>
                <BsFillClockFill className='text-2xl text-purple-800' />
            </div>
            <p className='font-bold text-lg mb-2'>Lifetime Access</p>
            <p className='text-sm opacity-50'>
                Unlimited lifetime access for continuous learning and personal growth.
            </p>
        </div>
    </div>
</section>
```

用下面的代码段替换 `Purchase Now` 占位符。

```tsx
<div className='w-full min-h-[70vh] py-14 md:px-12 px-4 bg-purple-700 flex md:flex-row flex-col items-center justify-between'>
    <div className='md:w-[50%] w-full md:pr-6 md:mb-0 mb-8'>
        <h2 className='font-extrabold text-5xl mb-4 text-purple-50'>
            Start learning and grow your skills today!{" "}
        </h2>
        <p className='mb-4 text-purple-300'>
            Unlock your full potential of a future-proof career through the power of
            top digital skills with our all-in-one growth package.
        </p>
        <div className='mb-6'>
            <div className='flex items-center space-x-3 mb-2'>
                <AiFillCheckCircle className='text-2xl text-green-300' />
                <p className='text-purple-50 text-sm opacity-80'>24/7 availability</p>
            </div>
            <div className='flex items-center space-x-3 mb-2'>
                <AiFillCheckCircle className='text-2xl text-green-300' />
                <p className='text-purple-50 text-sm opacity-80 '>
                    Expert-led tutorials
                </p>
            </div>
            <div className='flex items-center space-x-3 mb-2'>
                <AiFillCheckCircle className='text-2xl text-green-300' />
                <p className='text-purple-50 text-sm opacity-80 '>
                    High-quality contents
                </p>
            </div>
            <div className='flex items-center space-x-3 mb-2'>
                <AiFillCheckCircle className='text-2xl text-green-300' />
                <p className='text-purple-50 text-sm opacity-80 '>
                    Hands-on practical and interactive sessions
                </p>
            </div>
        </div>
        <button className='bg-purple-50 hover:bg-purple-100 w-[200px] text-purple-600 px-5 py-3 rounded-2xl text-lg font-semibold'>
            Purchase Now
        </button>
    </div>
    <div className='md:w-[50%] w-full flex items-center justify-center'>
        <Image src={buy} alt='Man smiling' className='rounded-lg' />
    </div>
</div>
```

最后，用下面的代码更新 `Footer` 部分。

```tsx
<footer className='w-full flex items-center justify-center min-h-[10vh] bg-white'>
    <p className='text-purple-800 text-sm'>
        Copyright, &copy; {new Date().getFullYear()} All Rights Reserved Tech Grow
    </p>
</footer>
```

### 成功  🚀

支付成功后，用户将被重定向到成功页面。

创建一个名为 `success.tsx` 的文件，并将下面的代码复制到文件中。

```tsx
import React from "react";
import Link from "next/link";

export default function Success() {
    return (
        <div className='w-full min-h-[100vh] flex flex-col items-center justify-center'>
            <h2 className='text-3xl font-bold mb-4'>Payment Sucessful!</h2>
            <Link
                href='/'
                className='bg-purple-50 hover:bg-purple-100 text-purple-600 px-5 py-3 rounded-2xl text-lg font-semibold'
            >
                Go Home
            </Link>
        </div>
    );
}
```

恭喜！🎉 你已成功为应用程序创建了用户界面。

___

## 开始收款 💰

[Stripe](https://stripe.com/) 是一个流行的在线支付处理平台，可以让你创建产品，并将一次性和定期支付方式集成到你的应用程序中。

在这里，我将为你介绍如何在 Stripe 上创建产品，以及如何将 Stripe 支付页面添加到你的 Next.js 应用程序中。

首先，你需要[创建一个账户](https://dashboard.stripe.com/login)。你可以在本教程中使用测试模式账户。

[![first](https://res.cloudinary.com/practicaldev/image/fetch/s--Xpis-Gpl--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/hpg6nrxfuhjodgz1qv6g.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--Xpis-Gpl--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/hpg6nrxfuhjodgz1qv6g.png)

从顶部菜单选择 `Product`，然后点击 `Add Product` 按钮创建新产品。提供产品名称、价格、描述和付款选项。选择 `One-Time` 作为付款选项。


[![Select Products](https://res.cloudinary.com/practicaldev/image/fetch/s--RX98AGTw--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/jrfuxt87igu801cp0y0x.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--RX98AGTw--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/jrfuxt87igu801cp0y0x.png)

创建一个 `.env.local` 环境文件并拷贝你的 `PRODUCT_ID` 进去：

```dotenv
PRODUCT_ID=<YOUR_PRODUCT_ID>
```

然后从顶部菜单点选 `Developers`，选择 `API keys`，然后创建一个新的密钥。

[![ProdId](https://res.cloudinary.com/practicaldev/image/fetch/s--n5pEQe8h--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/hipric4ehzdjirxk8pgx.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--n5pEQe8h--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/hipric4ehzdjirxk8pgx.png)

把这个密钥保存到 `.env.local` 文件中，以让你的应用程序可以在 Strip 处通过认证并使用其服务。

```dotenv
STRIPE_API_KEY=<YOUR_STRIPE_SECRET_KEY>
```

### 为 Next.js 添加 Stripe 结帐页面

要做到这一点，请安装 Stripe Node.js 库。

```shell
npm install stripe
```

在 Next.js 应用程序中创建一个API端点 - `api/payment`，并将下面的代码复制到文件中：

```ts
//👉🏻  Within the api/payment.ts file
import type { NextApiRequest, NextApiResponse } from "next";
import Stripe from "stripe";

const stripe = new Stripe(process.env.STRIPE_API_KEY!, {} as any);

export default async function handler(
    req: NextApiRequest,
    res: NextApiResponse
) {
    const session = await stripe.checkout.sessions.create({
        line_items: [
            {
                price: process.env.PRODUCT_ID,
                quantity: 1,
            },
        ],
        mode: "payment",
        success_url: `http://localhost:3000/success?session_id={CHECKOUT_SESSION_ID}`,
        cancel_url: "http://localhost:3000",
    });

    res.status(200).json({ session: session.url });
}
```

以上的代码片段创建了一个产品的结账会话，并返回会话 URL（收款的链接）。你需要将用户重定向到此 URL 以让用户可以付款。

在 `index.tsx` 文件中创建一个函数，该函数从 API 端点检索会话 URL 并将用户重定向到页面。当用户单击 Web 页面上的任何按钮时执行该函数。

```ts
const handlePayment = async () => {
    try {
        const data = await fetch("/api/payment");
        const response = await data.json();
        window.location.assign(response.session);
    } catch (err) {
        console.error(err);
    }
};
```

![Stripe](https://res.cloudinary.com/practicaldev/image/fetch/s--rewk5cZw--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/01xw1l2ypai8wnj7ttfh.gif)

恭喜你！🎉 你成功地将 Stripe 结帐页面添加到你的应用程序中。在接下来的部分，你将学习如何使用 Trigger.dev 处理付款并将用户详细信息保存到 Airtable 数据库。

___

## 使用Trigger.dev处理付款

[Trigger.dev](https://trigger.dev/) 是一个开源库，可以让你在 Next.js、Remix、Astro 等应用程序中创建和监视长时间运行的作业！通过 Trigger.dev，你可以在代码库和 GitHub Repo、Slack 频道等服务中自动执行、安排和延迟任务。

## 将Stripe连接到Trigger.dev ✨

在这里，你将学习如何使用 Trigger.dev Webhooks 在你的应用程序中处理 Stripe 付款。

[Trigger.dev webhooks](https://trigger.dev/docs/documentation/introductionhttps://trigger.dev/docs/documentation/concepts/triggers/webhooks) 是用户友好的，可以为你管理注册和注销流程。此外，如果出现错误，它会尝试重新发送事件直到成功为止。

你只需要[指定服务](https://trigger.dev/docs/integrations/introduction)和要监听的事件，而 Trigger.dev 会为你配置好。

### 将 Trigger.dev 添加到 Next.js 应用程序

在我们继续之前，你需要创建一个 [Trigger.dev 账户](https://trigger.dev/)。

为你的任务创建组织和项目名称。

[![Create org](https://res.cloudinary.com/practicaldev/image/fetch/s--rEmyYjpZ--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/vyb6eskgqhpxv5etm0mk.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--rEmyYjpZ--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/vyb6eskgqhpxv5etm0mk.png)

按照提供的步骤进行。

[![Org2](https://res.cloudinary.com/practicaldev/image/fetch/s--UnTM7AHG--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/0dwbs7tfk8swg8ziedax.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--UnTM7AHG--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/0dwbs7tfk8swg8ziedax.png)

或者在你的项目仪表盘的侧边栏点击 `Environments & API Keys`。

[![EnvApiKeys](https://res.cloudinary.com/practicaldev/image/fetch/s--z2jzAKWa--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/wsxvinx16hoqlsc2ccl5.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--z2jzAKWa--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/wsxvinx16hoqlsc2ccl5.png)

复制你的 DEV 服务器 API 密钥，然后运行下面的代码片段安装 Trigger.dev。请仔细按照说明操作。

```shell
npx @trigger.dev/cli@latest init
```

运行你的 Next.js 项目。

```shell
npm run dev
```

在另一个终端中运行以下代码片段，以在 Trigger.dev 和你的 Next.js 项目之间建立隧道。

```shell
npx @trigger.dev/cli@latest dev
```

最后，将 `jobs/examples.ts` 文件重命名为 `jobs/functions.ts`。这将是处理所有任务的地方。

恭喜你！🎉 你已成功将 Trigger.dev 添加到你的 Next.js 应用中。

### 监听 Stripe 的成功付款

安装 Trigger.dev 提供的 Stripe package。

```shell
npm install @trigger.dev/stripe@latest
```

按照如下代码更新 `jobs/functions.ts` 文件。

```ts
import { client } from "@/trigger";
import { Stripe } from "@trigger.dev/stripe";

const stripe = new Stripe({
    id: "stripe",
    apiKey: process.env.STRIPE_API_KEY!,
});

client.defineJob({
    //👇🏻 job properties
    id: "save-customer",
    name: "Save Customer Details",
    version: "0.0.1",
    //👇🏻 event trigger
    trigger: stripe.onCheckoutSessionCompleted(),

    run: async (payload, io, ctx) => {
        const { customer_details } = payload;
        await io.logger.info("Getting event from Stripe!🎉");
        //👇🏻 logs customer's details
        await io.logger.info(JSON.stringify(customer_details));

        await io.logger.info("✨ Congratulations, A customer just paid! ✨");
    },
});
```

这段代码片段会自动创建一个 Stripe Webhook，用于监听结账完成事件，当用户进行付款时触发。

[![Stripe Webhook](https://res.cloudinary.com/practicaldev/image/fetch/s--cq1WBvt3--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/u7oenhtrf5vj753ddunu.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--cq1WBvt3--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/u7oenhtrf5vj753ddunu.png)

用户付款后，他们的详细信息将被记录在 Trigger.dev 的作业控制台上。

![Stripe5](https://res.cloudinary.com/practicaldev/image/fetch/s--fo6CKVR4--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/uzinnyp1tdw7djq6guyo.gif)

## 存储用户信息 💾

在从 Stripe webhook 中检索到用户的详细信息之后，下一步是将这些详细信息保存到数据库中。在本节中，你将学习如何将 Airtable 集成到 Next.js 应用程序中，并使用 Trigger.dev 与其进行交互。

[Airtable](https://airtable.com/) 是一款易于使用的基于云的软件，可帮助你将信息组织成可自定义的表格。它就像是电子表格和数据库的混合体，让你以视觉上令人愉悦的方式协同管理数据、任务或项目。

要开始，请创建一个 [Airtable 账户](https://airtable.com/)，并设置一个工作区和一个数据库。Airtable 工作区充当包含多个数据库（称为 bases）的文件夹。每个数据库可以包含多个表格。

[![Bases](https://res.cloudinary.com/practicaldev/image/fetch/s--phZWcV6o--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/rtfq2u88e6lcgi7dmdoz.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--phZWcV6o--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/rtfq2u88e6lcgi7dmdoz.png)

在 Bases 中，创建一个包含 `Name` 和 `Email` 列的 Table。这将是从 Stripe 检索到的用户姓名和电子邮件将被存储的地方。

[![Airtable](https://res.cloudinary.com/practicaldev/image/fetch/s--77c5oAVv--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/l5ghzs8xy825vl9ckomh.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--77c5oAVv--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/l5ghzs8xy825vl9ckomh.png)

在导航栏处点击 `Help` 按钮，然后选择 `API Documentation`.

[![Help](https://res.cloudinary.com/practicaldev/image/fetch/s--YCdpGAr---/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/imv2u146bzqtupwdk8x1.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--YCdpGAr---/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/imv2u146bzqtupwdk8x1.png)

滑动页面，找到并复制 Base ID 和 Table ID，然后保存到 `.env.local` 文件中。

```dotenv
AIRTABLE_BASE_ID=<YOUR_AIRTABLE_BASE_ID>
AIRTABLE_TABLE_ID=<YOUR_AIRTABLE_TABLE_ID>
```

好的，接下来，通过点击你的头像并选择 `Developer Hub` 来创建一个个人访问令牌。为令牌赋予读写权限。

[![Next](https://res.cloudinary.com/practicaldev/image/fetch/s--wpNk8h69--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/povizzzv0004tf8hj4uo.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--wpNk8h69--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/povizzzv0004tf8hj4uo.png)

在 `.env.local` 文件中保存刚刚创建的令牌。

```dotenv
AIRTABLE_TOKEN=<YOUR_PERSONAL_ACCESS_TOKEN>
```

然后安装 Trigger.dev 提供的 Airtable package。

```shell
npm install @trigger.dev/airtable
```

更新 `jobs/functions.js` 文件，以此在用户完成付款后保存用户名称与邮箱到 Airtable 之中。

```ts
import { Airtable } from "@trigger.dev/airtable";
import { client } from "@/trigger";
import { Stripe } from "@trigger.dev/stripe";

// -- 👇🏻 Airtable instance --
const airtable = new Airtable({
    id: "airtable",
    token: process.env.AIRTABLE_TOKEN,
});
// -- 👇🏻 Stripe instance --
const stripe = new Stripe({
    id: "stripe",
    apiKey: process.env.STRIPE_API_KEY!,
});

client.defineJob({
    id: "save-customer",
    name: "Save Customer Details",
    version: "0.0.1",
    // -- 👇🏻 integrates Airtable --
    integrations: { airtable },
    trigger: stripe.onCheckoutSessionCompleted(),

    run: async (payload, io, ctx) => {
        const { customer_details } = payload;
        await io.logger.info("Getting event from Stripe!🎉");
        await io.logger.info(JSON.stringify(customer_details));

        await io.logger.info("Adding data to Airtable🎉");

        // --👇🏻 access the exact table via its ID --
        const table = io.airtable
            .base(process.env.AIRTABLE_BASE_ID!)
            .table(process.env.AIRTABLE_TABLE_ID!);

        // -- 👇🏻 adds a new record to the table --
        await table.createRecords("create records", [
            {
                fields: {
                    Name: customer_details?.name!,
                    Email: customer_details?.email!,
                },
            },
        ]);

        await io.logger.info("✨ Congratulations, New customer added! ✨");
    },
});
```

这段代码片段将 Airtable 集成到 Trigger.dev 中，访问数据库的 Table，并将用户的姓名和电子邮件保存到表中。

恭喜！你已经完成了本教程的项目。

___

## 结论

到目前为止，你已经学会了如何

-   在你的 Next.js 应用中添加 Stripe 结账页面，
-   使用 Trigger.dev 处理付款，并且
-   通过 Trigger.dev 将数据保存到 Airtable。

Trigger.dev 提供三种通信方法：Webhook、Schedule 和 Event。Schedule 适用于定期任务，Event 在发送有效负载时激活作业，而 Webhooks在特定事件发生时触发实时作业。

作为一名开源开发者，欢迎加入我们的[社区](https://discord.gg/nkqV9xBYWy)与维护人员一起贡献和交流。不要犹豫访问我们的 [GitHub Repo](https://github.com/triggerdotdev/trigger.dev)，来一起为这个项目贡献自己力量，或者提出与 Trigger.dev 有关的 issue！

本教程的源代码可以在这里获得：https://github.com/triggerdotdev/blog/tree/main/sales-page

感谢你的阅读！

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
