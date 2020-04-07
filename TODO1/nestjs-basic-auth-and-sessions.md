> * 原文地址：[NestJS Basic Auth and Sessions](https://blog.exceptionfound.com/2018/06/07/nestjs-basic-auth-and-sessions/)
> * 原文作者：[Just Another Typescript Blog](https://blog.exceptionfound.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/nestjs-basic-auth-and-sessions.md](https://github.com/xitu/gold-miner/blob/master/TODO1/nestjs-basic-auth-and-sessions.md)
> * 译者：[Jessica](https://github.com/cyz980908)
> * 校对者：[samyu2000](https://github.com/samyu2000)

# NestJS 实现基本用户认证和会话

> **代码免责声明**
>
> 本网站所有代码均为免费软件：您可以根据自由软件基金会发布的 GNU 通用公共许可证的条款，重新发布或者修改它。其中许可证的版本为 3 或者（由您选择的）任何更新版本。
>
> 我希望文章里的所有代码能够对您有所帮助，但**不作任何担保**。也不保证代码的性能以及它适用于某种功能。有关更多细节，请参阅 GNU 通用公共许可证。

本文研究NestJS 和认证策略，并记录了我使用Node知识在NestJS 中实现认证策略的过程。**但是，这不意味着您在实际项目中要像我这么做**。

在本文中，我们将探讨如何在 [NestJS](https://docs.nestjs.com/)中使用 [passport.js](https://github.com/jaredhanson/passport) 来轻松地实现基本的身份验证和会话管理。

首先，从 github 克隆这个预设置好的入门项目，其中 **package.json** 文件中包含了本项目所需的所有库，然后执行 **npm install**。

* [https://github.com/artonio/nestjs-session-tutorial](https://github.com/artonio/nestjs-session-tutorial)
* [https://github.com/artonio/nestjs-session-tutorial-finished](https://github.com/artonio/nestjs-session-tutorial-finished) —— 项目的完整源码。

本项目将使用以下方法和库。

* [Swagger](https://swagger.io/) —— 它能为您的应用生成对应的 REST API 接口的最终文档。同时还是一个快速测试 API 的好工具。您可以在 NestJS 网站浏览到有关 Swagger 的[文档](https://docs.nestjs.com/recipes/swagger)，以便在我们的项目中使用 Swagger。
* [Exception Filters](https://docs.nestjs.com/exception-filters) —— 它是 NestJS 内置的异常处理模块，负责处理整个应用中抛出的所有异常。当应用程序捕获到未处理的异常时，用户得到的响应是友好得体的。这意味着我们在应用中的任何地方抛出的异常，都会被全局异常处理程序捕获并且返回预定义的 JSON 响应。
* [TypeORM](http://typeorm.io/#/) —— 它是一个健壮性极好、成熟的ORM框架，虽然是不久前面世的。它使用 TypeScript 编写。同时支持 [ActiveRecord 和 DataMapper](http://typeorm.io/#/active-record-data-mapper) 模式，还支持缓存等许多其他功能。它的文档也十分优秀。TypeORM 支持大多数 SQL 和 NoSQL 数据库。对于本项目，我们将使用 sqlite 数据库。并使用 ActiveRecord 模式。[TypeORM TypeDocs（类似 javadocs）](http://typeorm-doc.exceptionfound.com/)
* [Custom Decorator](https://docs.nestjs.com/custom-decorators) —— 我们将创建一个自定义的路由装饰器来在 session 中访问用户对象。
* Basic Auth —— 使用 Basic Auth Header 的用户身份验证。
* [Sessions](https://github.com/expressjs/session) —— 一旦用户通过身份验证，就会创建一个 session 和一个 cookie，这样在每个需要用户信息的请求中，我们都能够从 session 对象中访问登录的用户。

#### 数据库 schema

![](http://blog.exceptionfound.com/wp-content/uploads/2018/06/Screen-Shot-2018-06-06-at-8.27.09-PM-196x300.png?189db0&189db0)

**我们将要创建的。** 本项目的 schema 很简单。我们有很多 user 和 project，但一个 user 只能够匹配到自己对应的 project。我们希望能够使用与数据库中的记录匹配的用户凭证进行登录，一旦登录，我们将使用 cookie 为用户检索项目。

**功能设计。** 创建 user；为登录的 user 创建一个 project；获取所有 user；获取所有已登录 user 的 project。本项目没有更新或删除的功能。

#### 项目结构

![](http://blog.exceptionfound.com/wp-content/uploads/2018/06/project_structure-185x300.png?189db0&189db0)

**common 目录：** 自定义异常和异常过滤器。

**project 目录：** project 服务、project 控制器、 project 数据库实体、project 模块。

**user 目录：** user 服务、user 控制器、user 数据库实体、user 模块。

**auth 目录：** AppAuthGuard、Cookie 序列化器/反序列化器、Http 策略、Session Guard、Auth 服务、Auth 模块。

#### 创建 user 模块

**前提：必须全局安装 @nest/cli**

###### 创建 user 模块

```
nest g mo user
```

这将会创建一个 user 目录和一个 user 模块。

###### 创建 user 控制器

```
nest g co user
```

这将 user 的控制器放入 user 目录并更新 user 模块。

###### 创建 user 服务

```
nest g s user
```

这将创建一个 user 服务并更新 user 模块。但是我的 user 服务最终被放置在根项目文件夹下而不是 user 文件夹中，我不是很清楚这是个 **bug 还是 Nestjs的框架特性**？如果您也碰上了这种情况，请手动将其移动到 user 文件夹中，并更新 user 模块中 user 服务的引用路径。

###### 创建 user 实体

```typescript
import {BaseEntity, Column, Entity, OneToMany, PrimaryGeneratedColumn} from 'typeorm';
import * as crypto from 'crypto';
import {ProjectEntity} from '../project/project.entity';
import {CreateUserDto} from './models/CreateUserDto';
import {AppErrorTypeEnum} from '../common/error/AppErrorTypeEnum';
import {AppError} from '../common/error/AppError';

@Entity({name: 'users'})
export class UserEntity extends BaseEntity {
    @PrimaryGeneratedColumn()
    id: number;

    @Column({
        length: 30
    })
    public firstName: string;

    @Column({
        length: 50
    })
    public lastName: string;

    @Column({
        length: 50
    })
    public username: string;

    @Column({
        length: 250,
        select: false,
        name: 'password'
    })
    public password_hash: string;

    set password(password: string) {
        const passHash = crypto.createHmac('sha256', password).digest('hex');
        this.password_hash = passHash;
    }

    @OneToMany(type => ProjectEntity, project => project.user)
    projects: ProjectEntity[];

    public static async findAll(): Promise<UserEntity[]> {
        const users: UserEntity[] = await UserEntity.find();
        if (users.length > 0) {
            return Promise.resolve(users);
        } else {
            throw new AppError(AppErrorTypeEnum.NO_USERS_IN_DB);
        }

    }

    public static async createUser(user: CreateUserDto): Promise<UserEntity> {
        let u: UserEntity;
        u = await UserEntity.findOne({username: user.username});
        if (u) {
            throw new AppError(AppErrorTypeEnum.USER_EXISTS);
        } else {
            u = new UserEntity();
            Object.assign(u, user);
            return await UserEntity.save(u);
        }
    }
}
```

这里有一些关于 UserEntity 的注意事项。当设置 password 属性时，我们将使用 TypeScript 的 **setter** ，并哈希加密我们的密码。在这个文件中，我们使用到了 AppError 和 AppErrorTypeEnum。不要担心，我们稍后会创建它们。我们还将在 password_hash 变量上设置以下属性： 

* **select: false ——** 当查询某个用户时，不要返回此列信息。
* **name: ‘password’ ——** 将实际列名设置为 “password”，如果未设置此选项，TypeORM 则会将变量名自动生成为列名。

#### 创建 project 模块

创建 project 模块的方式与创建 **user 模块**的方式相同。也需要创建一个project 服务和一个 project 控制器。

###### 创建 project 实体

```typescript
import {BaseEntity, Column, Entity, ManyToOne, PrimaryGeneratedColumn} from 'typeorm';
import {UserEntity} from '../user/user.entity';

@Entity({name: 'projects'})
export class ProjectEntity extends BaseEntity{
    @PrimaryGeneratedColumn()
    id: number;

    @Column()
    name: string;

    @Column()
    description: string;

    @ManyToOne(type => UserEntity)
    user: UserEntity;
}
```

现在我们需要告诉 TypeORM 这些实体的信息，并且还需要设置配置选项，以便让 TypeORM 连接到 sqlite 数据库。

在 AppModule 中添加以下代码：

```typescript
import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import {TypeOrmModule} from '@nestjs/typeorm';
import { UserModule } from './user/user.module';
import { ProjectModule } from './project/project.module';
import {UserEntity} from './user/user.entity';
import {ProjectEntity} from './project/project.entity';

@Module({
  imports: [
      TypeOrmModule.forRoot({
          type: 'sqlite',
          database: `${process.cwd()}/tutorial.sqlite`,
          entities: [UserEntity, ProjectEntity],
          synchronize: true,
          // logging: 'all'
      }),
      UserModule,
      ProjectModule,
  ],
  controllers: [AppController],
  providers: [ AppService ],
})
export class AppModule {}
```

**logging** 是日志相关，我们对它加了注释符号，但您可以在 [http://typeorm.io/#/logging](http://typeorm.io/#/logging) 了解更多信息。

**user 模块**现在应该是这样的：

```typescript
import { Module } from '@nestjs/common';
import { UserController } from './user.controller';
import { UserService } from './user.service';
import {TypeOrmModule} from '@nestjs/typeorm';
import {UserEntity} from './user.entity';

@Module({
    imports: [TypeOrmModule.forFeature([UserEntity])],
    controllers: [UserController],
    providers: [UserService]
})
export class UserModule {}
```

**project 模块**现在应该是这样的：

```typescript
import { Module } from '@nestjs/common';
import { ProjectController } from './project.controller';
import { ProjectService } from './project.service';
import {TypeOrmModule} from '@nestjs/typeorm';
import {ProjectEntity} from './project.entity';

@Module({
    imports: [TypeOrmModule.forFeature([ProjectEntity])],
    controllers: [ProjectController],
    providers: [ProjectService]
})
export class ProjectModule {}
```

###### 设置全局异常处理

在 **src/** 目录下创建 common 目录，在 common 目录下，我们将创建两个目录：error 和 filters。（可参考文章开头的项目结构截图）

#### Error 目录

如下所示，创建 **AppErrorTypeEnum.ts** 文件。

```typescript
export const enum AppErrorTypeEnum {
    USER_NOT_FOUND,
    USER_EXISTS,
    NOT_IN_SESSION,
    NO_USERS_IN_DB
}
```

我们将创建一个枚举类型变量，它不是对象，而是生成一个简单的 var->number 的关系映射，如果不是必须需要查找枚举的表示形式为字符串，选择创建 enum const 的话，性能会更高。

如下所示，创建 **IErrorMessage.ts** 文件。

```typescript
import {AppErrorTypeEnum} from './AppErrorTypeEnum';
import {HttpStatus} from '@nestjs/common';

export interface IErrorMessage {
    type: AppErrorTypeEnum;
    httpStatus: HttpStatus;
    errorMessage: string;
    userMessage: string;
}
```

这将是返回给用户的 JSON 结构。

最终，如下所示，创建 **AppError.ts** 文件。

```typescript
import {AppErrorTypeEnum} from './AppErrorTypeEnum';
import {IErrorMessage} from './IErrorMessage';
import {HttpStatus} from '@nestjs/common';

export class AppError extends Error {

    public errorCode: AppErrorTypeEnum;
    public httpStatus: number;
    public errorMessage: string;
    public userMessage: string;

    constructor(errorCode: AppErrorTypeEnum) {
        super();
        const errorMessageConfig: IErrorMessage = this.getError(errorCode);
        if (!errorMessageConfig) throw new Error('Unable to find message code error.');

        Error.captureStackTrace(this, this.constructor);
        this.name = this.constructor.name;
        this.httpStatus = errorMessageConfig.httpStatus;
        this.errorCode = errorCode;
        this.errorMessage = errorMessageConfig.errorMessage;
        this.userMessage = errorMessageConfig.userMessage;
    }

    private getError(errorCode: AppErrorTypeEnum): IErrorMessage {

        let res: IErrorMessage;

        switch (errorCode) {
            case AppErrorTypeEnum.USER_NOT_FOUND:
                res = {
                    type: AppErrorTypeEnum.USER_NOT_FOUND,
                    httpStatus: HttpStatus.NOT_FOUND,
                    errorMessage: 'User not found',
                    userMessage: 'Unable to find the user with the provided information.'
                };
                break;
            case AppErrorTypeEnum.USER_EXISTS:
                res = {
                    type: AppErrorTypeEnum.USER_EXISTS,
                    httpStatus: HttpStatus.UNPROCESSABLE_ENTITY,
                    errorMessage: 'User exisists',
                    userMessage: 'Username exists'
                };
                break;
            case AppErrorTypeEnum.NOT_IN_SESSION:
                res = {
                    type: AppErrorTypeEnum.NOT_IN_SESSION,
                    httpStatus: HttpStatus.UNAUTHORIZED,
                    errorMessage: 'No Session',
                    userMessage: 'Session Expired'
                };
                break;
            case AppErrorTypeEnum.NO_USERS_IN_DB:
                res = {
                    type: AppErrorTypeEnum.NO_USERS_IN_DB,
                    httpStatus: HttpStatus.NOT_FOUND,
                    errorMessage: 'No Users exits in the database',
                    userMessage: 'No Users. Create some.'
                };
                break;
        }
        return res;
    }

}
```

这段代码表示，我们在代码中的任何地方抛出错误时，全局异常处理程序将捕获它并返回一个结构与 IErrorMessage 一致的对象。

#### filters 目录

如下所示，创建 **DispatchError.ts** 文件。

```typescript
import {ArgumentsHost, Catch, ExceptionFilter, HttpStatus, UnauthorizedException} from '@nestjs/common';
import {AppError} from '../error/AppError';

@Catch()
export class DispatchError implements ExceptionFilter {
    catch(exception: any, host: ArgumentsHost): any {
        const ctx = host.switchToHttp();
        const res = ctx.getResponse();

        if (exception instanceof AppError) {
            return res.status(exception.httpStatus).json({
                errorCode: exception.errorCode,
                errorMsg: exception.errorMessage,
                usrMsg: exception.userMessage,
                httpCode: exception.httpStatus
            });
        } else if (exception instanceof UnauthorizedException) {
            console.log(exception.message);
            console.error(exception.stack);
            return res.status(HttpStatus.UNAUTHORIZED).json(exception.message);
        } else if (exception.status === 403) {
            return res.status(HttpStatus.FORBIDDEN).json(exception.message);
        }

        else {
            console.error(exception.message);
            console.error(exception.stack);
            return res.status(HttpStatus.INTERNAL_SERVER_ERROR).send();
        }
    }

}
```

您可以用任何您认为合适的方式实现这个类，上面这段代码只是一个小例子。

现在我们要做的就是让应用程序使用此过滤器，这很简单。在我们的 **main.ts** 中添加以下内容：

```typescript
app.useGlobalFilters(new DispatchError());
```

现在，您的 **main.ts** 文件内容大致如下：

```typescript
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import {DocumentBuilder, SwaggerModule} from '@nestjs/swagger';
import {DispatchError} from './common/filters/DispatchError';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.useGlobalFilters(new DispatchError());
  const options = new DocumentBuilder()
        .setTitle('User Session Tutorial')
        .setDescription('Basic Auth and session management')
        .setVersion('1.0')
        .addTag('nestjs')
        .build();
  const document = SwaggerModule.createDocument(app, options);
  SwaggerModule.setup('api', app, document);
  await app.listen(3000);
}
bootstrap();
```

#### 创建和获取 user

好的，现在我们准备添加一些逻辑来创建和获取 user。让我们遵循 Spring Boot 中服务的风格。我们的 user 服务将在 IUserService 中实现。在 user 文件夹，创建 **IUserService.ts** 文件。同时，我们还需要定义一个 model，这个 model 将在创建 user 的请求中使用到。创建 **user/models/CreateUserDto.ts** 文件。

```typescript
import {ApiModelProperty} from '@nestjs/swagger';

export class CreateUserDto {
    @ApiModelProperty()
    readonly firstName: string;

    @ApiModelProperty()
    readonly lastName: string;

    @ApiModelProperty()
    readonly username: string;

    @ApiModelProperty()
    readonly password: string;
}
```

这个类的主要功能是告诉 Swagger 它应该发送什么样的数据结构。

这里是我们的 **IUserService.ts**。

```typescript
import {CreateUserDto} from './models/CreateUserDto';
import {UserEntity} from './user.entity';
import {ProjectEntity} from '../project/project.entity';

export interface IUserService {
    findAll(): Promise<UserEntity[]>;
    createUser(user: CreateUserDto): Promise<UserEntity>;
    getProjectsForUser(user: UserEntity): Promise<ProjectEntity[]>;
}
```

这里是我们的 **user.service.ts**。

```typescript
import { Injectable } from '@nestjs/common';
import {UserEntity} from './user.entity';
import {IUserService} from './IUserService';
import {CreateUserDto} from './models/CreateUserDto';
import {ProjectEntity} from '../project/project.entity';

@Injectable()
export class UserService implements IUserService{
    public async findAll(): Promise<UserEntity[]> {
        return await UserEntity.findAll();
    }

    public async createUser(user: CreateUserDto): Promise<UserEntity> {
       return await UserEntity.createUser(user);
    }

    public async getProjectsForUser(user: UserEntity): Promise<ProjectEntity[]> {
        return undefined;
    }
}
```

最后是 **user.controller.ts**。

```typescript
import {Body, Controller, Get, HttpStatus, Post, Req, Res, Session} from '@nestjs/common';
import {UserService} from './user.service';
import {ApiBearerAuth, ApiOperation, ApiResponse} from '@nestjs/swagger';
import {UserEntity} from './user.entity';
import {CreateUserDto} from './models/CreateUserDto';
import {Request, Response} from 'express';

@Controller('user')
export class UserController {
    constructor(private readonly usersService: UserService) {}

    @Get('')
    @ApiOperation({title: 'Get List of All Users'})
    @ApiResponse({ status: 200, description: 'User Found.'})
    @ApiResponse({ status: 404, description: 'No Users found.'})
    public async getAllUsers(@Req() req: Request, @Res() res, @Session() session) {
        const users: UserEntity[] = await this.usersService.findAll();
        return res
                .status(HttpStatus.OK)
                .send(users);

    }

    @Post('')
    @ApiOperation({title: 'Create User'})
    public async create(@Body() createUser: CreateUserDto, @Res() res) {
        await this.usersService.createUser(createUser);
        return res.status(HttpStatus.CREATED).send();
    }
}
```

控制器的优雅之处在于它只是将成功结果返回给用户，我们不需要处理任何错误异常，因为它们是由全局异常处理程序处理的。

现在，通过运行 **npm run start** 或者 **npm run start:dev** 来启动服务器（**npm run start:dev** 会监视您的代码更改，并在每次保存时重新启动服务器）。服务器启动后，访问[http://localhost:3000/api/#/](http://localhost:3000/api/#/)。

如果一切顺利，您应该会看到 Swagger 的界面和一些 API 接口。阅读 **sqlite 的教程** 并选择您认为合适的 sqlite 工具（Firefox 浏览器有 sqlite 的扩展插件）确认数据的 schema 是否正确。当数据库中没有用户时，尝试获取所有 user，它应该会返回状态码 404 和一个包含 userMessage、errorMessage 等 (我们在 **AppError.ts** 中定义的信息)的 JSON。现在，创建一个 user 再执行获取所有 user。如果一切正常，那么我们继续创建一个**登录**的 API 接口。如果有问题，请在评论区留下问题。

#### 实现认证

在 **user.controller.ts** 文件后追加如下代码。

```typescript
@Post('login')
@ApiOperation({title: 'Authenticate'})
@ApiBearerAuth()
public async login(@Req() req: Request, @Res() res: Response, @Session() session) {
    return res.status(HttpStatus.OK).send();
}
```

**@ApiBearerAuth()** 注解是为了让 Swagger 知道，通过此请求，我们希望在 Header 中发送 Basic Auth。不过，我们还必须添加一些代码到 **main.ts** 中。

```typescript
const options = new DocumentBuilder()
        .setTitle('User Session Tutorial')
        .setDescription('Basic Auth and session management')
        .setVersion('1.0')
        .addTag('nestjs')
        .addBearerAuth('Authorization', 'header')
        .build();
```

现在，如果重新启动服务器，我们可以在 API 接口旁边看到一个小锁图标。但这个接口现在什么都没有，所以让我们给它添加一些逻辑。在我写这篇教程的时候，我认为文档中关于如何正确实现这种功能的内容不够完善，我跟着 [NestJS 官方文档](https://docs.nestjs.com/techniques/authentication) 来实现，但遇到了以下[问题](https://github.com/nestjs/passport/issues/7)。不过，我发现 [@nestjs/passport](https://github.com/nestjs/passport) 这个库，我可以将其与以下内容一起使用：

在设计认证的逻辑之前，我们需要将以下内容添加到 **main.ts** 中。

```typescript
* import * as passport from 'passport';
    import * as session from 'express-session'
    app.use(session({
         secret: 'secret-key',
         name: 'sess-tutorial',
         resave: false,
         saveUninitialized: false
    }))
    app.use(passport.initialize());
    app.use(passport.session());
```

#### 创建 auth 模块

执行 **nest g mo auth** 和 **nest g s auth**，这将创建带有 auth 模块的 **auth** 目录。和之前一样，如果 auth.service 在 auth 目录外生成了，把它移进去就好。NestJS 官方文档说这里需要使用 **@UseGuards(AuthGuard(‘bearer’))** 但是由于刚刚我提到的那个问题，我自己实现了 AuthGuard，亲测可以登录用户。接着，我们还需要实现我们的“通行证策略”。创建 **src/auth/AppAuthGuard.ts** 文件。

```typescript
import {CanActivate, ExecutionContext, UnauthorizedException} from '@nestjs/common';
import * as passport from 'passport';

export class AppAuthGuard implements CanActivate {
    async canActivate(context: ExecutionContext): Promise<boolean> {
        const options = { ...defaultOptions };
        const httpContext = context.switchToHttp();
        const [request, response] = [
            httpContext.getRequest(),
            httpContext.getResponse()
        ];
        const passportFn = createPassportContext(request, response);

        const user = await passportFn(
            'bearer',
            options
        );
        if (user) {
            request.login(user, (res) => {});
        }

        return true;
    }

}

const createPassportContext = (request, response) => (type, options) =>
    new Promise((resolve, reject) =>
        passport.authenticate(type, options, (err, user, info) => {
            try {
                return resolve(options.callback(err, user, info));
            } catch (err) {
                reject(err);
            }
        })(request, response, resolve)
    );

const defaultOptions = {
    session: true,
    property: 'user',
    callback: (err, user, info) => {
        if (err || !user) {
            throw err || new UnauthorizedException();
        }
        return user;
    }
};
```

创建 **src/auth/http.strategy.ts** 文件。

```typescript
import {Injectable} from '@nestjs/common';
import {PassportStrategy} from '@nestjs/passport';
import { Strategy } from 'passport-http-bearer';

@Injectable()
export class HttpStrategy extends PassportStrategy(Strategy) {
    async validate(token: any, done: Function) {
        done(null, {user: 'test'});
    }
}
```

* **token** —— 我们将在请求的中 Header 中接收到一个令牌，一般称它为 ”token“，其格式如下：**“Bearer base64encode(‘somestring’)”.**
* **done(null, {user: test})** —— 将对象存储在 session 的第二个参数中。现在我们先暂时存储一个假对象，稍后我们将用从数据库检索出的用户对象替换。

更新 **AuthModule.ts** 文件。

```typescript
import { Module } from '@nestjs/common';
import { AuthService } from './auth.service';
import {HttpStrategy} from './http.strategy';
import {AppAuthGuard} from './AppAuthGuard';

@Module({
  providers: [AuthService, HttpStrategy, AppAuthGuard]
})
export class AuthModule {}
```

现在运行我们的服务器。

测试我们项目的最好方法是进入浏览器中的 Swagger API，单击锁图标并输入 “**Bearer test**”，然后单击 “Authorize”。打开 **Chrome 开发者工具** 切换到 **Application** 选项卡，在左侧面板上点击，`Cookies->http://localhost:3000`。现在点击 **POST /login** 接口的 “Execute”，来发出请求。我们期望会看到一个名为“**sess-tutorial**” 的 cookie。但是目前我们什么也没看到。哪里出了问题？如果再我们仔细看一下[passport 的文档](https://github.com/jaredhanson/passport)，会发现我们还需要在 passport 在对象上增加以下内容。

```typescript
passport.serializeUser(function(user, done) {
  done(null, user.id);
});

passport.deserializeUser(function(id, done) {
  User.findById(id, function (err, user) {
    done(err, user);
  });
});
```

 文档说，**@nestjs/passport** 中有一个名为**PassportSerializer** 的抽象类。为什么必须是一个抽象类呢？我们先试一试再说，先将抽象类实现为具体类，并加上 **@Injectable()** 注解，然后供我们的 **auth.module.ts.** 使用。

如下所示，创建 **src/auth/cookie-serializer.ts** 文件。

```typescript
import {PassportSerializer} from '@nestjs/passport/dist/passport.serializer';
import {Injectable} from '@nestjs/common';

@Injectable()
export class CookieSerializer extends PassportSerializer {
    serializeUser(user: any, done: Function): any {
        done(null, user);
    }

    deserializeUser(payload: any, done: Function): any {
        done(null, payload);
    }

}
```

**AuthModule**

```typescript
import { Module } from '@nestjs/common';
import { AuthService } from './auth.service';
import {HttpStrategy} from './http.strategy';
import {AppAuthGuard} from './AppAuthGuard';
import {CookieSerializer} from './cookie-serializer';

@Module({
  providers: [AuthService, HttpStrategy, AppAuthGuard, CookieSerializer]
})
export class AuthModule {}
```

现在，运行我们的服务器并使用 Basic Auth Header 请求 **POST /login** 接口，现在我们应该可以在 Chrome 开发者工具中看到一个 cookie 了。刚刚我们遇到了一点小问题，但是通过阅读开发文档和 `@nestjs/passport` 的文档我们很快地找到了答案。

现在需要添加逻辑来根据数据库中的记录对用户进行身份验证，并且保证只有在用户登录后才能进行路由请求。

将下面的函数添加到 **UserEntity.ts** 中。

```typescript
public static async authenticateUser(user: {username: string, password: string}): Promise<UserEntity> {
        let u: UserEntity;
        u = await UserEntity.findOne({
            select: ['id', 'username', 'password_hash'],
            where: { username: user.username}
        });
        const passHash = crypto.createHmac('sha256', user.password).digest('hex');
        if (u.password_hash === passHash) {
            delete u.password_hash;
            return  u;
        }
    }
```

以及更新 **AuthService.ts**。

```typescript
import { Injectable } from '@nestjs/common';
import {UserEntity} from '../user/user.entity';

@Injectable()
export class AuthService {
    async validateUser(user: {username: string, password: string}): Promise<any> {
        return await UserEntity.authenticateUser(user);
    }
}
```

接着修改一下我们的 **http.strategy.ts**。

```typescript
import {Injectable, UnauthorizedException} from '@nestjs/common';
import {PassportStrategy} from '@nestjs/passport';
import { Strategy } from 'passport-http-bearer';
import {AuthService} from './auth.service';

@Injectable()
export class HttpStrategy extends PassportStrategy(Strategy) {

    constructor(private readonly authService: AuthService) {
        super();
    }

    async validate(token: any, done: Function) {
        let authObject: {username: string, password: string} = null;
        const decoded = Buffer.from(token, 'base64').toString();
        try {
            authObject = JSON.parse(decoded);
            const user = await this.authService.validateUser(authObject);
            if (!user) {
                return done(new UnauthorizedException(), false);
            }
            done(null, user);
        } catch (e) {
            return done(new UnauthorizedException(), false);
        }
    }
}
```

现在打开免费[ base64 加密网站](https://www.base64encode.org/)，加密的下面的 JSON 字段，并将在 Swagger 中发送。

```json
{
  "username" : "johnny",
  "password": "1234"
}
```

现在回到 Swagger 中，在刚刚点击右侧的 **Authorize** 弹出的输入框中输入 **“Bearer ew0KICAidXNlcm5hbWUiIDogImpvaG5ueSIsDQogICJwYXNzd29yZCI6ICIxMjM0Ig0KfQ==”**。Bearer 后面的字符串是上面刚刚加密过的 JSON 字符串，它将在 **UserEntity.ts** 的 **authenticateUser** 函数中被解码和匹配。现在执行 **POST /login**，您应该看到 Chrome 开发者工具 中出现了一个 cookie（如果您的用户在数据库中为用户名 “jonny”，密码为 “1234”的话）。

让我们创建一个路由，它将用于为当前登录的用户创建一个项目，但在此之前，我们需要一个“会话保护程序”，它将保护我们的路由，如果 session 中没有用户，它会抛出一个 AppError。

###### 保护路由免遭未经授权的访问

创建 **src/auth/SessionGuard.ts** 文件。

```typescript
import {CanActivate, ExecutionContext} from '@nestjs/common';
import {AppError} from '../common/error/AppError';
import {AppErrorTypeEnum} from '../common/error/AppErrorTypeEnum';

export class SessionGuard implements CanActivate {
    canActivate(context: ExecutionContext): boolean | Promise<boolean> {
        const httpContext = context.switchToHttp();
        const request = httpContext.getRequest();

        try {
            if (request.session.passport.user)
                return true;
        } catch (e) {
            throw new AppError(AppErrorTypeEnum.NOT_IN_SESSION);
        }

    }
}
```

我们还可以用一种更方便的方法来从 session 中检索 user 对象。使用 **req.session.passport.user** 这样的方式可以，但是不够优雅。现在，创建 **src/user/user.decorator.ts** 文件。

```typescript
import {createParamDecorator} from '@nestjs/common';

export const SessionUser = createParamDecorator((data, req) => {
    return req.session.passport.user;
})
```

接着，我们向 **ProjectEntity** 类中添加一个函数来为给定的用户创建 project。

```typescript
public static async createProjects(projects: CreateProjectDto[], user: UserEntity): Promise<ProjectEntity[]> {
       const u: UserEntity = await UserEntity.findOne(user.id);
       if (!u) throw new AppError(AppErrorTypeEnum.USER_NOT_FOUND);
       const projectEntities: ProjectEntity[] = [];
       projects.forEach((p: CreateProjectDto) => {
           const pr: ProjectEntity = new ProjectEntity();
           pr.name = p.name;
           pr.description = p.description;
           projectEntities.push(pr);
       });
       u.projects = projectEntities;
       const result: ProjectEntity[] = await ProjectEntity.save(projectEntities);
       await UserEntity.save([u]);
       return Promise.all(result);
   }
```

在 **ProjectService** 类中，添加将下内容。

```typescript
public async createProject(projects: CreateProjectDto[], user: UserEntity): Promise<ProjectEntity[]> {
       return ProjectEntity.createProjects(projects, user);
}
```

再更新 **ProjectController**。

```typescript
import {Body, Controller, HttpStatus, Post, Res, UseGuards} from '@nestjs/common';
import {SessionGuard} from '../auth/SessionGuard';
import {SessionUser} from '../user/user.decorator';
import {UserEntity} from '../user/user.entity';
import {ApiOperation, ApiUseTags} from '@nestjs/swagger';
import {CreateProjectDto} from './models/CreateProjectDto';
import {ProjectService} from './project.service';
import {ProjectEntity} from './project.entity';

@ApiUseTags('project')
@Controller('project')
export class ProjectController {

    constructor(private readonly projectService: ProjectService) {}

    @Post('')
    @UseGuards(SessionGuard)
    @ApiOperation({title: 'Create a project for the logged in user'})
    public async createProject(@Body() createProjects: CreateProjectDto[], @Res() res, @SessionUser() user: UserEntity) {
        const projects: ProjectEntity[] = await this.projectService.createProject(createProjects, user);
        return res.status(HttpStatus.OK).send(projects);
    }

}
```

* **@UseGuards(SessionGuard)** —— 如果 user 不在 session 中，则响应的 AppError 中会返回预定义的 JSON。
* **@SessionUser()** —— 我们的自定义装饰器可以使我们轻松地从 session 中获取到 **UserEntity** 对象。（其实我们没有必要存储整个 **UserEntity** 对象，我们可以通过修改 CookieSerializer 类来保存用户的 id）。

在 Swagger 中，尝试在不进行用户身份验证和用户登陆通过的情况下分别创建 project，看看有什么区别。在创建 project 时您发送的必须是一个包含项目的数组。（请注意，在服务器重启后，seesion 将会丢失）。您也可以通过使用 Chrome 开发者工具来删除一个 cookie。

现在，我们添加获取 project 的用户功能。

###### 为已认证的 user 获取 project

在 **ProjectEntity** 中添加如下代码：

```typescript
public static async getProjects(user: UserEntity): Promise<ProjectEntity[]> {
        const u: UserEntity = await UserEntity.findOne(user.id, { relations: ['projects']});
        if (!u) throw new AppError(AppErrorTypeEnum.USER_NOT_FOUND);
        return Promise.all(u.projects);
    }
```

在 **ProjectService** 中添加如下代码：

```typescript
public async getProjectsForUser(user: UserEntity): Promise<ProjectEntity[]> {
        return ProjectEntity.getProjects(user);
    }
```

在 **ProjectController** 中添加如下代码：

```typescript
@Get('')
@UseGuards(SessionGuard)
@ApiOperation({title: 'Get Projects for User'})
public async getProjects(@Res() res, @SessionUser() user: UserEntity) {
    const projects: ProjectEntity[] = await this.projectService.getProjectsForUser(user);
    return res.status(HttpStatus.OK).send(projects);
}
```

以上就是全部内容。

您可以在 [https://github.com/artonio/nestjs-session-tutorial-finished](https://github.com/artonio/nestjs-session-tutorial-finished) 查看完成的源码。

译者注：原作者的文章写于 2018 年，NestJS 的版本是 5.0.0，现在 NestJS 已经更新到 v6 了，所以是不兼容的。但是 NestJS 的官方有 v5 迁移到 v6 的[迁移指南](https://docs.nestjs.cn/6/migrationguide)，有需要可以参考。同理，文章中提到的其他库也需要注意版本。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
