> * 原文地址：[How To Build a Blog with Nest.js, MongoDB, and Vue.js](https://www.digitalocean.com/community/tutorials/how-to-build-a-blog-with-nest-js-mongodb-and-vue-js)
> * 原文作者：[Oluyemi Olususi](https://www.digitalocean.com/community/users/yemiwebby)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-build-a-blog-with-nest-js-mongodb-and-vue-js.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-build-a-blog-with-nest-js-mongodb-and-vue-js.md)
> * 译者：[Jessica](https://github.com/cyz980908)
> * 校对者：[vitoxli](https://github.com/vitoxli)，[lihaobhsfer](https://github.com/lihaobhsfer)

# 如何用 Nest.js、MongoDB 和 Vue.js 搭建一个博客

## 概述

[Nest.js](https://nestjs.com/) 是一个可扩展的服务端 JavaScript 框架。它使用 TypeScript 构建，所以它依然与 JavaScript 兼容，这使得它成为构建高效可靠的后端应用的有效工具。它还具有模块化结构，可为 Node.js 开发环境提供一个成熟的结构化的设计模式。

[Vue.js](https://vuejs.org/) 是用于构建用户界面的前端 JavaScript 框架。它不仅有简单但功能强大的 API，还具有出色的性能。Vue.js 能提供任意项目规模的 Web 应用的前端层和逻辑。它可以轻松地将自身与其他库或现有项目集成在一起，这使得它成为大多数现代 Web 应用的理想选择。

在本教程中，我们将通过构建一个 Nest.js 应用，来熟悉它的构建模块以及构建现代 Web 应用的基本原则。我们会将应用划分为两个不同的部分：前端和后端。首先，我们将使用 Nest.js 来构建的 RESTful 后端 API。然后，将使用 Vue.js 来构建前端。其中前后端的应用将在不同的端口上运行，并将作为独立的域运行。

我们将构建的是一个博客应用，用户可以使用该应用创建和保存新文章，在主页上查看保存的文章，以及进行其他操作，例如编辑和删除文章。此外，我们还会连接应用并将应用数据持久化到 [MongoDB](https://www.mongodb.com/) 中，MongoDB 是一种无模式（schema-less）的 NoSQL 数据库，可以接收和存储 JSON 文件。本教程的重点是介绍如何在开发环境中构建应用。如果是在生产环境，我们还应该考虑应用的用户身份验证。

## 前提

要完成本教程，我们需要：

* 在本地安装 [Node.js](https://nodejs.org/en/)（至少 v6 版本）和 [npm](https://www.npmjs.com/)（至少 v5.2 版本）。Node.js 是一个允许您在浏览器之外运行 JavaScript 代码的运行环境。它带有一个名为 `npm` 的预安装的包管理工具,可让您安装和更新软件包。如果要在 macOS 或 Ubuntu 18.04 上安装它们，请遵循文章[如何在 macOS 上安装 Node.js 并创建本地开发环境](https://www.digitalocean.com/community/tutorials/how-to-install-node-js-and-create-a-local-development-environment-on-macos)中的步骤或者文章[如何在 Ubuntu 18.04 上安装 Node.js](https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-18-04)中的“使用 PPA 进行安装”这一节。
* 在您的机器上安装 MongoDB 数据库。按照[这里](https://www.mongodb.com/download-center/community)的说明来下载并安装您操作系统所对应的版本。您可以通过在 [Mac](https://docs.mongodb.com/manual/tutorial/install-mongodb-on-os-x/?_ga=2.44532076.918654254.1550698665-2018226388.1550698665#create-the-data-directory) 上使用 [Homebrew](https://brew.sh/) 进行安装，也可以从 [MongoDB 网站](https://www.mongodb.com/download-center/community)下载。
* 对 TypeScript 和 [JavaScript](https://www.digitalocean.com/community/tutorial_series/how-to-code-in-javascript) 有基本了解。
* 安装文本编辑器，例如 [Visual Studio Code](https://code.visualstudio.com/)、[Atom](https://atom.io) 或者 [Sublime Text](https://www.sublimetext.com)。

**注意：** 本教程使用 macOS 机器进行开发。如果您正在使用其他的操作系统，可能需要在整个教程中使用 `sudo` 来执行 `npm` 命令。

## 第一步 —— 安装 Nest.js 和其他依赖

在本节中，我们先在本地安装 Nest.js 及其所需依赖。您可以使用 Nest.js 提供的 [CLI](https://docs.nestjs.com/cli/overview) 轻松地安装 Nest.js，也可以从 GitHub 上的入门项目安装。就本教程而言，我们将使用 CLI 来初始化应用。首先，在终端运行以下命令，以便在您的机器上全局安装它：

```sh
npm i -g @nestjs/cli
```

您将看到类似于以下内容的输出：

```
Output@nestjs/cli@5.8.0
added 220 packages from 163 contributors in 49.104s
```

要确认已完成 Nest CLI 的安装，请在终端上运行此命令：

```sh
nest --version
```

您将看到安装在您计算机上的 Nest 版本：

```
Output5.8.0
```

我们将使用 `nest` 命令来管理项目，并使用它来生成相关文件 —— 比如 controller、modules 和 provider。

要开始本教程的项目，请在终端中使用 `nest` 命令运行以下命令行来构建名为 `blog-backend` 的新 Nest.js 项目：

```sh
nest new blog-backend
```

在运行该命令之后，`nest` 将立即向您提供一些基本信息，如`描述（description）`、`版本（version）`和`作者（author）`。继续并提供适当的细节。在您回答了每个提示之后，在您的计算机上按`回车`继续。

接下来，我们将选择一个包管理器。就本教程而言，选择 `npm` 并按`回车键`开始安装 Nest.js。

![Alt 创建一个 Nest 项目](https://assets.digitalocean.com/articles/nest_vue_mongo/step1a.png)

这将在本地开发文件夹中的 `blog-backend` 文件夹中生成一个新的 Nest.js 项目。

接下来，从终端导航到新的项目文件夹：

```sh
cd blog-backend
```

运行以下命令以安装其他服务依赖项：

```sh
npm install --save @nestjs/mongoose mongoose
```

这时，我们已经安装了 `@nestjs/mongoose` 和 `mongoose`，前者是一个用于 MongoDB 的对象建模工具的 Nest.js 专用软件包，后者是用于操作 Mongoose 的软件包。

现在，使用以下命令启动应用：

```sh
npm run start
```

现在，选择您喜欢的浏览器，打开 `http://localhost:3000`，您将看到我们的应用正在运行。

![Alt 新安装的 Nest.js 应用的欢迎页面](https://assets.digitalocean.com/articles/nest_vue_mongo/step1b.png)

现在，我们已经在 Nest CLI 命令的帮助下成功地创建了项目。接着，继续运行应用，并在本地机器上的默认端口 `3000` 上访问它。在下一节中，我们将通过设置数据库连接的配置来进一步了解应用。

## 第二步 —— 配置和连接数据库

这一步, 我们将配置 MongoDB 并将其集成到 Nest.js 应用中，用 MongoDB 存储应用的数据。MongoDB 将数据以**字段：值**对的形式存储在 **document** 中。您将使用 [Mongoose](https://mongoosejs.com/) 来访问这些数据结构，Mongoose 是一个对象文档模型（Object Document Modeling，ODM），它能够让我们定义表示 MongoDB 数据库存储的数据类型的 schema 结构。

要启动 MongoDB，首先打开一个单独的终端，使应用可以继续运行，然后执行以下命令：

```sh
sudo mongod
```

这将启动 MongoDB 服务并在您机器的后台运行数据库。

在文本编辑器中打开 `blog-backend` 项目，定位到 `./src/app.module.ts` 文件。我们可以通过在根 `ApplicationModule` 中已安装的 `MongooseModule` 来建立到数据库的连接。需要添加以下几行代码来更新 `app.module.ts` 中的内容：

~/blog-backend/src/app.module.ts

```ts
import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { MongooseModule } from '@nestjs/mongoose';

@Module({
  imports: [
    MongooseModule.forRoot('mongodb://localhost/nest-blog', { useNewUrlParser: true }),
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule { }
```

在这个文件中，我们使用 `forRoot()` 方法来完成与数据库的连接。完成编辑后，保存并关闭文件。

有了这些，我们就可以使用 Mongoose 中对应 MongoDB 的模块来建立数据库连接。在下一节中，我们将使用 Mongoose 库、TypeScript 接口和数据传输对象（DTO）schema 创建一个数据库 schema。

## 第三步 —— 创建数据库 Schema，接口以及 DTO

在这一步, 我们将使用 Mongoose 为数据库创建 **schema**，**接口**和**数据传输对象**。Mongoose 帮助我们管理数据之间的关系，并提供数据类型的 schema 验证。为了更好的定义应用中数据库里数据结构和数据类型，我们将创建文件，以确定以下内容：

* **数据库 schema**： 这是一种数据组织，它是定义数据库需要存储的数据结构和类型的蓝图。
* **接口**：TypeScript 接口用于类型检查。它可以用来定义在应用中传递的数据的类型。
* **数据传输对象**： 这个对象定义了数据是以何种形式通过网络发送的以及如何在进程之间进行传输的。

首先, 回到当前应用运行的终端，使用 `CTRL + C` 停止进程，跳转至 `./src/` 文件夹：

```sh
cd ./src/
```

然后，创建一个名为 `blog` 的目录，并在其中创建一个 `schemas` 文件夹：

```sh
mkdir -p blog/schemas
```

在 `schemas` 文件夹，创建一个名为 `blog.schema.ts` 的新文件。使用文本编辑器打开它。然后，添加以下内容：

~/blog-backend/src/blog/schemas/blog.schema.ts

```ts
import * as mongoose from 'mongoose';

export const BlogSchema = new mongoose.Schema({
    title: String,
    description: String,
    body: String,
    author: String,
    date_posted: String
})
```

这里，我们使用 Mongoose 来定义将存储在数据库中的数据类型。我们已经指定所有将存储并且接受的字段只有字符串类型。完成编辑后保存并关闭文件。

现在，确定了数据库 schema 之后，就可以继续创建接口了。

首先，回到 `blog` 文件夹：

```sh
cd ~/blog-backend/src/blog/
```

创建一个名为 `interfaces` 的新文件夹，并跳转至文件夹内：

```sh
mkdir interfaces
```

在`interfaces` 文件夹，创建一个叫 `post.interface.ts` 的文件，并用文本编辑器打开它。添加以下内容以定义 `Post` 的数据类型：

~/blog-backend/src/blog/interfaces/post.interface.ts

```ts
import { Document } from 'mongoose';

export interface Post extends Document {
    readonly title: string;
    readonly description: string;
    readonly body: string;
    readonly author: string;
    readonly date_posted: string
}
```

在这个文件中，我们已经成功地将 `Post` 类型的数据类型定义为字符串值。保存并退出文件。

因为我们的应用将会向数据库发送数据，所以我们将创建一个数据传输对象，它将定义数据会怎样发送到网络。

为此，请在 `./src/blog` 文件夹中创建一个文件夹 `dto`。在新创建的文件夹中，创建一个名为 `create-post.dto.ts` 的文件

定位到 `blog` 文件夹：

```sh
cd ~/blog-backend/src/blog/
```

然后创建一个名为 `dto` 的文件夹并跳转到该文件夹：

```sh
mkdir dto
```

在 `dto` 文件夹中，创建一个名为 `create-post.dto` 的新文件。使用文本编辑器打开它，添加以下内容：

~/blog-backend/src/blog/dto/create-post.dto.ts

```ts
export class CreatePostDTO {
    readonly title: string;
    readonly description: string;
    readonly body: string;
    readonly author: string;
    readonly date_posted: string
}
```

我们已经将 `CreatePostDTO` 类中的每个属性都标记为数据类型为 `string`，并标记为 `readonly`，以避免不必要的数据操作。完成编辑后保存并退出文件。

在这一步中，我们已经为数据库创建了数据库 schema、接口、以及数据库将要存储的数据的数据传输对象。接下来，我们将为博客创建模块、控制器和服务。

## 第四步 —— 为你的博客创建模块（Module）、控制器（Controller）和服务（Service）

在这一步，我们将通过为博客创建一个模块来改进应用的现有结构。这个模块将组织应用中的文件结构。接着，我们将创建一个控制器来处理来自客户端的路由和 HTTP 请求。最后，我们将创建服务来处理应用程序中所有控制器无法处理的复杂业务逻辑。

### 创建模块

与 Angular 等前端框架类似，Nest.js 使用的是模块化语法。Nest.js 应用采用模块化设计；它预装的是单个根模块，这对小型应用来说通常是够用的。但是，当应用业务开始增长时，Nest.js 推荐使用多模块来组织应用，将代码根据相关的功能分解成不同模块。

Nest.js 中的**模块**由 `@Module()` 装饰器标识，并接受有 `controller` 和 `provider` 之类属性的对象。其中每一个属性都会分别采用一组 `controller` 和 `provider`。

我们将为这个博客应用生成一个新模块，使结构更有组织。首先，仍然在 `~/blog-backend` 文件夹中，执行以下命令：

```sh
nest generate module blog
```

您将看到类似于以下内容的输出：

```
OutputCREATE /src/blog/blog.module.ts

UPDATE /src/app.module.ts
```

该命令生成了一个名为 `blog.module.ts` 的新模块。将新创建的模块导入到应用的根模块中。这将允许 Nest.js 知道根模块之外的另一个模块的存在。

在这个文件中，您将看到以下代码：

~/blog-backend/src/blog/blog.module.ts

```ts
import { Module } from '@nestjs/common';

@Module({})
export class BlogModule {}
```

在本教程的后面，我们将使用所需的属性更新这个 `BlogModule`。现在保存并退出文件。

### 创建服务

**服务**（在 Nest.js 中也称它为 provider）的意义在于从仅应处理 HTTP 请求的控制器中移除业务逻辑，并会将更复杂的任务重定向到其他的服务类。服务是普通的 JavaScript 类，在它们的代码上方会带有 `@Injectable()` 装饰器。要生成新服务，请在该项目目录下终端运行以下命令：

```sh
nest generate service blog
```

您将看到类似于以下内容的输出：

```
Output  CREATE /src/blog/blog.service.spec.ts (445 bytes)

CREATE /src/blog/blog.service.ts (88 bytes)

UPDATE /src/blog/blog.module.ts (529 bytes)
```

这里通过 `nest` 命令创建了一个 `blog.service.spec.ts` 文件，我们可以使用它进行测试。它还创建了一个新的 `blog.service.ts` 文件，它将保存这个应用的所有逻辑，并处理向 MongoDB 数据库的添加和检索 document。此外，它还会自动导入新创建的服务并将其添加到 `blog.module.ts` 中。

服务处理应用中所有的逻辑，负责与数据库交互，并将合适的响应返回给控制器。为此，在文本编辑器中打开`blog.service.ts` 文件，并将内容替换为以下内容：

~/blog-backend/src/blog/blog.service.ts

```ts
import { Injectable } from '@nestjs/common';
import { Model } from 'mongoose';
import { InjectModel } from '@nestjs/mongoose';
import { Post } from './interfaces/post.interface';
import { CreatePostDTO } from './dto/create-post.dto';

@Injectable()
export class BlogService {

    constructor(@InjectModel('Post') private readonly postModel: Model<Post>) { }

    async getPosts(): Promise<Post[]> {
        const posts = await this.postModel.find().exec();
        return posts;
    }

    async getPost(postID): Promise<Post> {
        const post = await this.postModel
            .findById(postID)
            .exec();
        return post;
    }

    async addPost(createPostDTO: CreatePostDTO): Promise<Post> {
        const newPost = await this.postModel(createPostDTO);
        return newPost.save();
    }

    async editPost(postID, createPostDTO: CreatePostDTO): Promise<Post> {
        const editedPost = await this.postModel
            .findByIdAndUpdate(postID, createPostDTO, { new: true });
        return editedPost;
    }

    async deletePost(postID): Promise<any> {
        const deletedPost = await this.postModel
            .findByIdAndRemove(postID);
        return deletedPost;
    }

}
```

在这个文件中，我们首先从 `@nestjs/common`、`mongoose` 和 `@nestjs/mongoose` 中导入所需的模块。同时我们还导入了一个名为 `Post` 的接口和一个数据传输对象 `CreatePostDTO`。

在 `constructor` 中，我们使用了 `@InjectModel('Post')`，将 `Post` 模型注入这个 `BlogService` 类中。现在，我们可以使用这个注入的模型来检索所有的文章，获取一篇文章，并执行其他与数据库相关的活动。

接着，我们创建了以下方法：

* `getPosts()`：从数据库中获取所有文章。
* `getPost()`：从数据库中检索一篇文章。
* `addPost()`：添加一篇新文章。
* `editPost()`：更新一篇文章。
* `deletePost()`：删除特定的文章。

完成后，保存并退出文件。

我们已经完成了几个方法的设置和创建，这些方法将通过后端 API 来与 MongoDB 数据库进行的适当交互。现在，我们将创建用于处理来自前端客户端的 HTTP 调用所需的路由。

### 创建控制器

在 Nest.js 中，**控制器**负责处理来自应用客户端的任何请求并返回适当的响应。与大多数其他 web 框架类似，对于应用而言重要的就是监听请求并响应。

为了满足博客应用的所有 HTTP 请求，我们将利用 `nest` 命令生成一个新的控制器文件。首先确保您仍然在项目目录，`blog-backend`，然后运行以下命令：

```sh
nest generate controller blog
```

您将看到类似于以下内容的输出：

```
OutputCREATE /src/blog/blog.controller.spec.ts (474 bytes)

CREATE /src/blog/blog.controller.ts (97 bytes)

UPDATE /src/blog/blog.module.ts (483 bytes)
```

这段输出表示该命令在 `src/blog` 目录中创建了两个新文件，`blog.controller.spec.ts` 和 `blog.controller.ts`。前者是一个可以用来为新创建的控制器编写自动测试的文件。后者是控制器文件本身。Nest.js 中的控制器是用 `@Controller` 元数据装饰的 TypeScript 文件。该命令还导入了新创建的控制器并添加它到博客模块。

接下来，用文本编辑器打开 `blog.controller.ts` 文件并用以下内容更新它：

~/blog-backend/src/blog/blog.controller.ts

```ts
import { Controller, Get, Res, HttpStatus, Param, NotFoundException, Post, Body, Query, Put, Delete } from '@nestjs/common';
import { BlogService } from './blog.service';
import { CreatePostDTO } from './dto/create-post.dto';
import { ValidateObjectId } from '../shared/pipes/validate-object-id.pipes';


@Controller('blog')
export class BlogController {

    constructor(private blogService: BlogService) { }

    @Get('posts')
    async getPosts(@Res() res) {
        const posts = await this.blogService.getPosts();
        return res.status(HttpStatus.OK).json(posts);
    }

    @Get('post/:postID')
    async getPost(@Res() res, @Param('postID', new ValidateObjectId()) postID) {
        const post = await this.blogService.getPost(postID);
        if (!post) throw new NotFoundException('Post does not exist!');
        return res.status(HttpStatus.OK).json(post);

    }

    @Post('/post')
    async addPost(@Res() res, @Body() createPostDTO: CreatePostDTO) {
        const newPost = await this.blogService.addPost(createPostDTO);
        return res.status(HttpStatus.OK).json({
            message: "Post has been submitted successfully!",
            post: newPost
        })
    }
}
```

在这个文件中，我们首先引入了来自 `@nestjs/common` 模块的处理 HTTP 请求所需的模块。然后，我们引入了三个新模块：`BlogService`、`CreatePostDTO` 和 `ValidateObjectId`。之后，通过在构造函数中将 `BlogService` 注入到控制器，以使得拥有访问权限来使用 `BlogService` 文件中已经定义好的函数。在 Nest.js 中，这是一种模式，叫作**依赖注入**，有助于提高效率和增强应用的模块化。

最后，我们创建了以下这些异步方法：

* `getPosts()`： 这个方法将执行从客户端接收 HTTP GET 请求时从数据库中获取所有文章，然后返回适当的响应的功能。它用 `@Get('posts')` 装饰。
* `getPost()`： 这将以 `postID` 作为参数，从数据库中获取一篇文章。除了传递给这个方法的 `postID` 参数之外，还实现了一个名为 `ValidateObjectId()` 的额外方法。这个方法实现了 Nest.js 中的 `PipeTransform` 接口。它是用于验证并确保可以在数据库中找到 `postID` 参数。我们将在下一节中定义这个方法。
* `addPost()`： 这个方法将处理 HTTP POST 请求，以便向数据库添加新的文章。

为了能够编辑和删除特定的文章，我们需要在 `blog.controller.ts` 文件中添加两个以上的方法。我们需要，在之前添加到 `blog.controller.ts` 的 `addPost()` 方法后，直接加上 `editPost()` 和 `deletePost()` 方法：

~/blog-backend/src/blog/blog.controller.ts

```ts
...
@Controller('blog')
export class BlogController {
    ...
    @Put('/edit')
    async editPost(
        @Res() res,
        @Query('postID', new ValidateObjectId()) postID,
        @Body() createPostDTO: CreatePostDTO
    ) {
        const editedPost = await this.blogService.editPost(postID, createPostDTO);
        if (!editedPost) throw new NotFoundException('Post does not exist!');
        return res.status(HttpStatus.OK).json({
            message: 'Post has been successfully updated',
            post: editedPost
        })
    }


    @Delete('/delete')
    async deletePost(@Res() res, @Query('postID', new ValidateObjectId()) postID) {
        const deletedPost = await this.blogService.deletePost(postID);
        if (!deletedPost) throw new NotFoundException('Post does not exist!');
        return res.status(HttpStatus.OK).json({
            message: 'Post has been deleted!',
            post: deletedPost
        })
    }
}
```

这里解释一下我们到底添加了什么：

* `editPost()`： 这个方法接受 `postID` 的查询参数，并执行更新一篇文章的功能。它还利用 `ValidateObjectId` 方法为您需要编辑文章提供适当的认证。
* `deletePost()`： 这个方法将接受 `postID` 的查询参数，并从数据库中删除特定的文章。

与 `BlogController` 类似，这里定义的每个异步方法都有一个元数据装饰器，并且包含一个 Nest.js 中用于路由机制的前缀。它控制每个控制器接收的请求，以及分别指向应该处理请求和返回的响应方法。

例如，我们在本节中创建的 `BlogController` 具有 `blog` 前缀和一个名为 `getPosts()` 采用 `posts` 前缀的方法。这意味着发送到 `blog/posts`（`http:localhost:3000/blog/posts`）的任何 GET 请求都将由 `getPosts()` 方法处理。其他处理 HTTP 请求的方法与这个示例中的方式类似。

保存并退出文件。

关于应用的完整 `blog.controller.ts` 文件，请访问 [DO Community repository](https://github.com/do-community/nest-vue-project/blob/master/blog-backend/src/blog/blog.controller.ts)。

在这一节中，我们创建了模块，使得应用更便于管理。我们还创建了服务，通过与数据库的交互并返回适当的响应来处理应用程序的业务逻辑。最后，我们创建了控制器并生成了必要的方法来处理来自客户端的 HTTP 请求，例如 `GET`、`POST`、`PUT` 和 `DELETE`。在下一节中，我们将完成后端设置。

## 第五步 —— 为 Mongoose 创建一个额外的认证

我们可以通过唯一的 ID （也称为 `PostID`）来区分博客应用中的每篇文章。这意味着获取文章的话，我们需要将此 ID 作为查询参数传递过去。为了验证这个 `postID` 参数并确保这篇文章在数据库确实存在可用，我们需要创建一个可复用的函数，该函数可以从 `BlogController` 中的任何方法初始化。

要配置它，请定位到 `./src/blog` 文件夹：

```sh
cd ./src/blog/
```

然后，创建一个名为 `shared` 的新文件夹：

```sh
mkdir -p shared/pipes
```

在 `pipes` 文件夹中，使用文本编辑器创建一个名为 validate-object-id.pipes.ts 的新文件，并打开它。添加以下内容以定义接受的 `postID` 数据：

~/blog-backend/src/blog/shared/pipes/validate-object-id.pipes.ts

```ts
import { PipeTransform, Injectable, ArgumentMetadata, BadRequestException } from '@nestjs/common';
import * as mongoose from 'mongoose';

@Injectable()
export class ValidateObjectId implements PipeTransform<string> {
    async transform(value: string, metadata: ArgumentMetadata) {
        const isValid = mongoose.Types.ObjectId.isValid(value);
        if (!isValid) throw new BadRequestException('Invalid ID!');
        return value;
    }
}
```

`ValidateObjectId()` 类是由 `@nestjs/common` 模块中的 `PipeTransform` 方法实现的。它有一个名为 `transform()` 的方法，该方法将 value 作为参数 —— 在当前着种情况下为 `postID`。使用这个方法，任何带有无法在数据库中检索到的 `postID` 的应用中的前端 HTTP 请求都会被视为无效。保存并关闭文件。

在创建了服务和控制器之后，我们需要建立基于 `BlogSchema` 的 `Post` 模型。这个配置可以在根 `ApplicationModule` 中设置，但是在这本例中，我们将在 `BlogModule` 中构建模型以维护应用的组织。打开`./src/blog/blog.module.ts` 并用以下内容更新它：

~/blog-backend/src/blog/blog.module.ts

```ts
import { Module } from '@nestjs/common';
import { BlogController } from './blog.controller';
import { BlogService } from './blog.service';
import { MongooseModule } from '@nestjs/mongoose';
import { BlogSchema } from './schemas/blog.schema';

@Module({
  imports: [
    MongooseModule.forFeature([{ name: 'Post', schema: BlogSchema }])
 ],
  controllers: [BlogController],
  providers: [BlogService]
})
export class BlogModule { }
```

在这里我们使用 `MongooseModule.forFeature()` 方法来定义在模块中应该注册哪些模型。如果没有这个方法，使用 `@injectModel()` 装饰器在 `BlogService` 中注入 `PostModel` 将不起作用。完成添加后，保存并关闭文件。

在这一步中，我们已经用 Nest.js 创建了完整的后端 RESTful API，并将其与 MongoDB 集成。在下一节中，我们将配置服务器以允许来自其他服务器的 HTTP 请求，因为我们的前端应用和后端将运行在不同的端口上。

## 第六步 —— 启用 CORS

跨域的 HTTP 请求通常在默认情况下被阻止，除非服务器指定允许它访问。要使前端应用向后端服务器发出跨域请求，必须启用**跨源资源共享（CORS）**，这是一种允许请求 Web 页面上跨域资源的技术。

在 Nest.js 中启用 CORS，我们需要向 `main.ts` 文件中添加一个方法。用文本编辑器打开位于 `./src/main.ts` 中的文件，并用以下内容更新它：

~/blog-backend/src/main.ts

```ts
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.enableCors();
  await app.listen(3000);
}
bootstrap();
```

保存并退出文件。

现在我们已经完成了后端设置，我们将把重点转移到前端，使用 Vue.js 来使用到目前为止构建的 API。

## 第七步 —— 创建 Vue.js 前端

在本节中，我们将使用 Vue.js 创建前端应用。[Vue CLI](https://cli.vuejs.org/) 是一个脚手架，它使我们能够方便简单地快速生成和安装一个新的 Vue.js 项目。

首先，您需要在您的机器上全局安装 Vue CLI 。打开另一个终端，注意路径不是在 `blog-backend` 文件夹，而是在本地项目的 development 文件夹，然后运行：

```sh
npm install -g @vue/cli
```

一旦安装过程完成，我们将利用 `vue` 命令创建一个新的 Vue.js 项目：

```sh
vue create blog-frontend
```

输入此命令后，我们将看到一个简短的提示。选择 `manually select features` 选项（意思是手动选择特性），然后按下计算机上的`空格`，这时会显示出多个特性来让您来选择此项目所需的特性。我们将选择`Babel`、`Router` 和 `Linter / Formatter`。

![Alt CLI 初始化 Vue 项目](https://assets.digitalocean.com/articles/nest_vue_mongo/step7a.png)

对于下一条指令，输入 `y` 来使用路由的历史模式；这将使历史模式在 router 文件中启用，这个 router 文件将自动为我们的项目生成。此外，仅选择`ESLint with error prevention only` 用于 linter/formatter 的配置。下一步，选择 `Lint on save` 为保留其他的 Lint 功能。然后选择将我们的配置保存到一个 `dedicated config file`（专用配置文件）中，以供将来的项目使用。最后，为我们的这些预置设置输入一个名称，比如 `vueconfig`。

![Alt CLI 初始化 Vue.js 项目的最后一步](https://assets.digitalocean.com/articles/nest_vue_mongo/step7b.png)

Vue.js 将开始在一个名为 `blog-frontend` 的目录中创建应用及其所需的所有依赖项。

安装过程完成后，在 Vue.js 应用中定位到：

```sh
cd blog-frontend
```

然后，使用以下命令启动服务器：

```sh
npm run serve
```

我们的应用将在 `http://localhost:8080` 上运行。

![Alt Vue.js 首页界面](https://assets.digitalocean.com/articles/nest_vue_mongo/step7c.png)

由于我们将在此应用中执行 HTTP 请求，因此需要安装 axios，这是一种基于 Promise 的浏览器 HTTP 客户端。这里将使用 axios 执行来自应用中不同组件的 HTTP 请求。在您的计算机的终端上按 `CTRL + C` 终止前端应用，然后运行以下命令：

```sh
npm install axios --save
```

我们的前端应用将从应用中的不同组件中对特定域上的后端 API 进行 API 调用。为了确保我们应用的路由请求结构是正确的，我们可以创建一个`辅助`文件，在其中定义服务器 `baseURL`。

首先，将仍然位于博客前端的终端中，定位到 `./src/` 文件夹：

```sh
cd ./src/
```

创建另一个名为 `utils` 的文件夹：

```sh
mkdir utils
```

在 `utils` 文件夹，使用文本编辑器创建一个名为 `helper.js` 的新文件并将其打开。添加以下内容以定义后端 Nest.js 项目的 `baseURL`：

~blog-frontend/src/utils/helper.js

```js
export const server = {

baseURL: 'http://localhost:3000'

}
```

定义了 `baseURL` 之后，我们可以从 Vue.js 组件文件中的任何位置调用它。在需要更改 URL 的情况下，更改这个文件中的 baseURL 比在整个应用代码中更新更容易。

在本节中，我们安装了 Vue CLI，这是一个用于创建新的 Vue.js 应用的脚手架工具。我们使用此工具来创建 `blog-frontend` 应用。此外，我们还运行了应用并安装了一个名为 axios 的库，每当应用中出现 HTTP 调用时，我们都使用该库。接下来，我们将为应用创建组件。

## 第八步 —— 创建可复用的组件

现在我们要为我们的应用创建可重用的组件，这是 Vue.js 应用的标准结构。Vue.js 中的组件系统使开发人员能够构建一个单独的、独立的接口单元，该单元具有自己的状态、HTML 和样式。这使得这些组件可以被复用。

每个 Vue.js 组件都包含三个不同的部分：

* `<template>`：包含着 HTML 内容
* `<script>`：包含所有基本的前端逻辑并定义函数
* `<style>`：每个组件的单独样式表

首先，我们将创建一个用来创建文章的组件。我们需要在 `./src/components` 文件夹中创建一个名为 `post` 的新文件夹，这个文件夹中存放有关文章的必要的可重用组件。然后使用文本编辑器在新创建的 `post` 文件夹中创建另一个文件并将其命名为 `Create.vue`。打开这个文件并添加以下代码，这段代码告诉了我们提交文章所需的输入字段：

~blog-frontend/src/components/post/Create.vue

```vue
<template>
   <div>
        <div class="col-md-12 form-wrapper">
          <h2> Create Post </h2>
          <form id="create-post-form" @submit.prevent="createPost">
               <div class="form-group col-md-12">
                <label for="title"> Title </label>
                <input type="text" id="title" v-model="title" name="title" class="form-control" placeholder="Enter title">
               </div>
              <div class="form-group col-md-12">
                  <label for="description"> Description </label>
                  <input type="text" id="description" v-model="description" name="description" class="form-control" placeholder="Enter Description">
              </div>
              <div class="form-group col-md-12">
                  <label for="body"> Write Content </label>
                  <textarea id="body" cols="30" rows="5" v-model="body" class="form-control"></textarea>
              </div>
              <div class="form-group col-md-12">
                  <label for="author"> Author </label>
                  <input type="text" id="author" v-model="author" name="author" class="form-control">
              </div>

              <div class="form-group col-md-4 pull-right">
                  <button class="btn btn-success" type="submit"> Create Post </button>
              </div>          
          </form>
        </div>
    </div>
</template>
```

这是 `CreatePost` 组件的 `<template>` 部分。它包含创建新文章所需的 HTML 元素 input。每个输入字段都有一个 `v-model` 指令作为输入属性。这是为了使每个表单上的 input 框都有双向数据绑定，以便 Vue.js 更容易获得用户的输入。

接下来，将 `<script>` 部分直接添加到前面的文件中：

~blog-frontend/src/components/post/Create.vue

```js
...
<script>
import axios from "axios";
import { server } from "../../utils/helper";
import router from "../../router";
export default {
  data() {
    return {
      title: "",
      description: "",
      body: "",
      author: "",
      date_posted: ""
    };
  },
  created() {
    this.date_posted = new Date().toLocaleDateString();
  },
  methods: {
    createPost() {
      let postData = {
        title: this.title,
        description: this.description,
        body: this.body,
        author: this.author,
        date_posted: this.date_posted
      };
      this.__submitToServer(postData);
    },
    __submitToServer(data) {
      axios.post(`${server.baseURL}/blog/post`, data).then(data => {
        router.push({ name: "home" });
      });
    }
  }
};
</script>
```

这里我们添加了一个名为 `createPost()` 的方法来创建一篇新文章，并使用 axios 将其提交给服务器。一旦用户创建了一篇新文章，应用将重定向回主页，用户可以在那里查看创建的文章的列表。

我们将在本教程的后面配置 vue-router 来实现重定向。

完成编辑后保存并关闭文件。关于应用的完整 `Create.vue` 文件，请访问 [DO Community repository](https://github.com/do-community/nest-vue-project/blob/master/blog-frontend/src/components/post/Create.vue)。

现在，我们需要再创建一个用于编辑特定文章的组件。定位到 `./src/components/post` 文件夹，再创建一个名为 `Edit.vue` 文件。添加以下 `<template>` 部分的代码到文件中：

~blog-frontend/src/components/post/Edit.vue

```vue
<template>
<div>
      <h4 class="text-center mt-20">
       <small>
         <button class="btn btn-success" v-on:click="navigate()"> View All Posts </button>
       </small>
    </h4>
        <div class="col-md-12 form-wrapper">
          <h2> Edit Post </h2>
          <form id="edit-post-form" @submit.prevent="editPost">
            <div class="form-group col-md-12">
                <label for="title"> Title </label>
                <input type="text" id="title" v-model="post.title" name="title" class="form-control" placeholder="Enter title">
            </div>
            <div class="form-group col-md-12">
                <label for="description"> Description </label>
                <input type="text" id="description" v-model="post.description" name="description" class="form-control" placeholder="Enter Description">
            </div>
            <div class="form-group col-md-12">
                <label for="body"> Write Content </label>
                <textarea id="body" cols="30" rows="5" v-model="post.body" class="form-control"></textarea>
            </div>
            <div class="form-group col-md-12">
                <label for="author"> Author </label>
                <input type="text" id="author" v-model="post.author" name="author" class="form-control">
            </div>

            <div class="form-group col-md-4 pull-right">
                <button class="btn btn-success" type="submit"> Edit Post </button>
            </div>
          </form>
        </div>
    </div>
</template>

```

这里的 template 部分的内容与 `CreatePost()` 组件类似；唯一的区别是它包含了需要编辑的特定文章的具体内容。

接下来，直接在 `Edit.vue` 中的 `</template>` 部分后面添加 `<script>` 部分：

~blog-frontend/src/components/post/Edit.vue

```js
...
<script>
import { server } from "../../utils/helper";
import axios from "axios";
import router from "../../router";
export default {
  data() {
    return {
      id: 0,
      post: {}
    };
  },
  created() {
    this.id = this.$route.params.id;
    this.getPost();
  },
  methods: {
    editPost() {
      let postData = {
        title: this.post.title,
        description: this.post.description,
        body: this.post.body,
        author: this.post.author,
        date_posted: this.post.date_posted
      };

      axios
        .put(`${server.baseURL}/blog/edit?postID=${this.id}`, postData)
        .then(data => {
          router.push({ name: "home" });
        });
    },
    getPost() {
      axios
        .get(`${server.baseURL}/blog/post/${this.id}`)
        .then(data => (this.post = data.data));
    },
    navigate() {
      router.go(-1);
    }
  }
};
</script>
```

在这里，我们获得了路由参数 `id` 来标识特定文章。然后，我们创建了一个名为 `getPost()` 的方法来从数据库检索这篇文章的详细信息，并使用它更新页面。最后，我们创建了 `editPost()` 方法，用 HTTP PUT 请求将编辑后的文章提交回后端服务器。

完成编辑后保存并关闭文件。关于应用的完整 `Edit.vue` 文件，请访问 [DO Community repository](https://github.com/do-community/nest-vue-project/blob/master/blog-frontend/src/components/post/Edit.vue)。

现在，我们在 `./src/components/post` 文件夹中创建一个名为 `Post.vue` 新组件。这样我们就可以从首页中查看特定文章的详细信息。然后，将以下内容添加到 `Post.vue` 中：

~blog-frontend/src/components/post/Post.vue

```js
<template>
    <div class="text-center">
        <div class="col-sm-12">
      <h4 style="margin-top: 30px;"><small><button class="btn btn-success" v-on:click="navigate()"> View All Posts </button></small></h4>
      <hr>
      <h2>{{ post.title }}</h2>
      <h5><span class="glyphicon glyphicon-time"></span> Post by {{post.author}}, {{post.date_posted}}.</h5>
      <p> {{ post.body }} </p>

    </div>
    </div>
</template>
```

这段代码会渲染出文章的详细信息，包括`标题（titile）`、`作者（author）`和文章`正文（body）`。

现在，直接在 `</template>` 之后，添加以下代码：

~blog-frontend/src/components/post/Post.vue

```js
...
<script>
import { server } from "../../utils/helper";
import axios from "axios";
import router from "../../router";
export default {
  data() {
    return {
      id: 0,
      post: {}
    };
  },
  created() {
    this.id = this.$route.params.id;
    this.getPost();
  },
  methods: {
    getPost() {
      axios
        .get(`${server.baseURL}/blog/post/${this.id}`)
        .then(data => (this.post = data.data));
    },
    navigate() {
      router.go(-1);
    }
  }
};
</script>
```

这里的 `<script>` 部分的内容与编辑特文章的组件类似，我们从路由中获得了参数 `id` 并使用它来检索特定文章的详细信息。

完成编辑后保存并关闭文件。关于应用的完整 `Post.vue` 文件，请访问 [DO Community repository](https://github.com/do-community/nest-vue-project/blob/master/blog-frontend/src/components/post/Post.vue)。

接下来，要向用户显示所有创建的文章，我们需要创建一个新组件。定位到 `src/views` 中的 `views` 文件夹，您将看到 `Home.vue` 组件 —— 如果此文件不存在，请使用文本编辑器创建它，并添加以下代码：

~blog-frontend/src/views/Home.vue

```vue
<template>
    <div>

      <div class="text-center">
        <h1>Nest Blog Tutorial</h1>
       <p> This is the description of the blog built with Nest.js, Vue.js and MongoDB</p>

       <div v-if="posts.length === 0">
            <h2> No post found at the moment </h2>
        </div>
      </div>

        <div class="row">
           <div class="col-md-4" v-for="post in posts" :key="post._id">
              <div class="card mb-4 shadow-sm">
                <div class="card-body">
                   <h2 class="card-img-top">{{ post.title }}</h2>
                  <p class="card-text">{{ post.body }}</p>
                  <div class="d-flex justify-content-between align-items-center">
                    <div class="btn-group" style="margin-bottom: 20px;">
                      <router-link :to="{name: 'Post', params: {id: post._id}}" class="btn btn-sm btn-outline-secondary">View Post </router-link>
                       <router-link :to="{name: 'Edit', params: {id: post._id}}" class="btn btn-sm btn-outline-secondary">Edit Post </router-link>
                       <button class="btn btn-sm btn-outline-secondary" v-on:click="deletePost(post._id)">Delete Post</button>
                    </div>
                  </div>

                  <div class="card-footer">
                    <small class="text-muted">Posted on: {{ post.date_posted}}</small><br/>
                    <small class="text-muted">by: {{ post.author}}</small>
                  </div>

                </div>
              </div>
            </div>
      </div>
    </div>
</template>
```

这里，在 `<template>` 部分中，通过 `post._id` 参数，我们使用 `<router-link>` 来创建用于编辑文章和查看文章的链接。我们还使用了 `v-if` 指令为用户有选择地呈现文章。如果数据库中没有文章，用户将只看到以下文本：**No post found at the moment（暂时没有发现任何文章）**.

完成编辑后保存并关闭文件。关于应用的完整 `Home.vue` 文件，请访问 [DO Community repository](https://github.com/do-community/nest-vue-project/blob/master/blog-frontend/src/components/post/Home.vue)。

现在，直接在 `Home.vue` 中的 `</template>` 部分之后，添加以下 `</script>` 部分：

~blog-frontend/src/views/Home.vue

```js
...
<script>
// @ 是 /src 的别名
import { server } from "@/utils/helper";
import axios from "axios";

export default {
  data() {
    return {
      posts: []
    };
  },
  created() {
    this.fetchPosts();
  },
  methods: {
    fetchPosts() {
      axios
        .get(`${server.baseURL}/blog/posts`)
        .then(data => (this.posts = data.data));
    },
    deletePost(id) {
      axios.delete(`${server.baseURL}/blog/delete?postID=${id}`).then(data => {
        console.log(data);
        window.location.reload();
      });
    }
  }
};
</script>
```

在这个文件的 `<script>` 部分中，我们创建了一个名为 `fetchPosts()` 的方法来从数据库获取所有的文章，并使用服务器返回的数据更新页面。

现在，我们将更新前端应用的 `App` 组件，以便创建到 `Home` 组件和 `Create` 组件的链接。打开 `src/App.vue`，用以下内容更新它：

~blog-frontend/src/App.vue

```vue
<template>
  <div id="app">
    <div id="nav">
      <router-link to="/">Home</router-link> |
      <router-link to="/create">Create</router-link>
    </div>
    <router-view/>
  </div>
</template>

<style>
#app {
  font-family: "Avenir", Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
}
#nav {
  padding: 30px;
  text-align: center;
}

#nav a {
  font-weight: bold;
  color: #2c3e50;
}

#nav a.router-link-exact-active {
  color: #42b983;
}
</style>
```

上面的代码中，除了包含到 `Home` 和 `Create` 组件的链接之外，还包含了 `<Style>` 部分，它是这个组件的样式表，包含着页面上一些元素的样式定义。保存并退出文件。

在这一节中，我们已经创建了应用所需的所有组件。接下来，我们将配置路由文件。

## 第九步 —— 搭建路由

在创建了所有需要的可复用组件之后，现在我们可以通过更新包含所有组件链接的路由文件，来正确配置路由文件。这将保证前端应用中的所有的路由都会映射到特定的组件，以便采取适当的操作。定位到 `./src/router.js`，并将其内容替换为以下内容：

~blog-frontend/src/router.js

```js
import Vue from 'vue'
import Router from 'vue-router'
import HomeComponent from '@/views/Home';
import EditComponent from '@/components/post/Edit';
import CreateComponent from '@/components/post/Create';
import PostComponent from '@/components/post/Post';

Vue.use(Router)

export default new Router({
  mode: 'history',
  routes: [
    { path: '/', redirect: { name: 'home' } },
    { path: '/home', name: 'home', component: HomeComponent },
    { path: '/create', name: 'Create', component: CreateComponent },
    { path: '/edit/:id', name: 'Edit', component: EditComponent },
    { path: '/post/:id', name: 'Post', component: PostComponent }
  ]
});
```

我们从 `vue-router` 模块中导入了 `Router`，并通过传递 `mode` 和 `route` 参数实例化了它。`vue-router` 的默认模式是 hash 模式，该模式使用 URL 的 hash 来一个模拟完整的 URL，于是当 URL 更改时页面不会重新加载。如果不需要 hash 模式，我们可以在此处使用 history 模式来实现 URL 的路由而无需重新加载页面。最后，在 `routes` 选项中，我们指定了路由的具体对应组件 —— 应用中调用路由时应该呈现的组件和组件的名称。保存并退出文件。

既然我们已经搭建好了应用的路由，现在就需要引入 Bootstrap 文件来预制应用用户界面的样式。我们需要在文本编辑器中打开 `./public/index.html` 文件，并通过在文件中添加以下内容来包含用于 Bootstrap 的 CDN 文件：

~blog-frontend/public/index.html

```html
<!DOCTYPE html>
<html lang="en">
<head>
  ...
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">
  <title>blog-frontend</title>
</head>
<body>
   ...
</body>
</html>
```

保存并退出文件，然后使用 `npm run serve` 为我们的 `blog-frontend` 项目重新启动应用（如果它当前没有运行的话）。

**注意：** 确保后端服务器和 MongoDB 实例都在运行。如果没有的话，从另一个新的终端定位到 `blog-backend` 项目下并运行 `npm run start`。同样，通过从一个新的终端运行 `sudo mongod` 来启动 MongoDB 服务。

通过 URL 跳转到我们的应用：`http://localhost:8080`。现在您可以通过创建和编辑文章来测试您的博客啦！

![Alt 创建一篇新文章](https://assets.digitalocean.com/articles/nest_vue_mongo/step9a.png)

单击应用上的 **Create** 以查看 **Create Post** 视图，该视图与 `CreateComponent` 组件相关并会渲染该组件。在 input 框中输入内容，然后单击 **Create Post** 按钮提交一篇文章。完成后，应用将把您重定向回主页。

应用的主页呈现的是组件 `HomeComponent`。这个组件会调用一个它的方法，会发送一个 HTTP 调用来从数据库获取所有的文章并将它们显示给用户。

![Alt 从数据库中查看所有的文章](https://assets.digitalocean.com/articles/nest_vue_mongo/step9b.png)

点击某个特定文章的 **Edit Post** 按钮，您会进入一个编辑页面，在那里您可以做任何修改并保存您的文章。

![Alt 修改一篇新发的文章](https://assets.digitalocean.com/articles/nest_vue_mongo/step9c.png)

在本节中，我们配置并搭建了应用的路由。到这里，我们的博客应用就准备好了。

## 总结

在本教程中，您通过使用 Nest.js 来探索了构造 Node.js 应用的新方法。您创建了一个简单的博客应用，使用 Nest.js 构建后端 RESTful API，使用 Vue.js 处理了所有前端逻辑。此外，您还将 MongoDB 数据库集成到 Nest.js 应用中。

想要了解关于如何将身份验证添加到应用中，您可以使用 [Passport.js](http://www.passportjs.org/)。一个流行的 Node.js 认证库。您可以在 [Nest.js 文档](https://docs.nestjs.com/techniques/authentication)中了解关于 Passport.js 的集成。

您可以在[这个项目的 GitHub ](https://github.com/do-community/nest-vue-project)上找到项目的完整源代码。想要获取更多关于 Nest 的信息。您可以访问[官方文档](https://docs.nestjs.com/)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
