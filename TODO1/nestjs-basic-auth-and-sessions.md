> * 原文地址：[NestJS Basic Auth and Sessions](https://blog.exceptionfound.com/2018/06/07/nestjs-basic-auth-and-sessions/)
> * 原文作者：[Just Another Typescript Blog](https://blog.exceptionfound.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/nestjs-basic-auth-and-sessions.md](https://github.com/xitu/gold-miner/blob/master/TODO1/nestjs-basic-auth-and-sessions.md)
> * 译者：
> * 校对者：

# NestJS Basic Auth and Sessions

> **Code Disclaimer**
>
> All code on this website is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
>
> All code on this website is is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

In this article, I am exploring NestJS and the Authentication strategy, this mostly documents my journey in figuring our how to implement auth strategy in NestJS by using knowledge from Node. **It is not meant to be used in production as it is**.

In this post we are going to explore how we can easily implement Basic Auth and Session management using [passport.js](https://github.com/jaredhanson/passport) in [NestJS Framework](https://docs.nestjs.com/).

First off all clone this pre set-up starter project from github which includes all the libraries needed for this tutorial in **package.json** and run **npm install.**

* [https://github.com/artonio/nestjs-session-tutorial](https://github.com/artonio/nestjs-session-tutorial)
* [https://github.com/artonio/nestjs-session-tutorial-finished](https://github.com/artonio/nestjs-session-tutorial-finished) – finished source code.

This project will make use of the following concepts and libraries.

* [Swagger](https://swagger.io/) – the ultimate documentation for your REST API endpoints as well as a great tool to quickly test your API, the project was set up with swagger using the [documentation](https://docs.nestjs.com/recipes/swagger) from NestJS website.
* [Exception Filters](https://docs.nestjs.com/exception-filters) – The built-in **exceptions layer** is responsible for handling all thrown exceptions across your whole application. When an unhandled exception is caught, the end-user will receive an appropriate user-friendly response. What it means is that we can throw an exception anywhere in our application and the global exception handler will catch it and return a predefined JSON response.
* [TypeORM](http://typeorm.io/#/) – A surprisingly robust and mature ORM given how young it is. Written in TypeScript. Supports both [ActiveRecord and DataMapper](http://typeorm.io/#/active-record-data-mapper) patterns. Supports caching and many, many more features. Excellent documentation. Support most SQL and NoSQL dbs. For this project we are going to use sqlite. We will use ActiveRecord pattern for this tutorial. [TypeORM TypeDocs (like javadocs)](http://typeorm-doc.exceptionfound.com/)
* [Custom Decorator](https://docs.nestjs.com/custom-decorators)  – We will create a custom route decorator to access our User object from the session.
* Basic Auth – User authentication using Basic Auth header
* [Sessions](https://github.com/expressjs/session) – Once the user is authenticated, a session and a cookie will be created so that on each request that requires the user information we will be able to access the logged in user from the session object.

#### Database Schema

![](http://blog.exceptionfound.com/wp-content/uploads/2018/06/Screen-Shot-2018-06-06-at-8.27.09-PM-196x300.png?189db0&189db0)

**What we are going to build.** The schema is very basic. Users have many Projects. We want to be able to log in with user credentials that match a record in the database, once logged in we will use a cookie to retrieve projects for the user.

**Functionality**. Create users. Create a project for logged in user. Get all Users. Get all projects for logged in user. We will not cover update or delete.

#### Project Structure

![](http://blog.exceptionfound.com/wp-content/uploads/2018/06/project_structure-185x300.png?189db0&189db0)

**Common.** Custom Exceptions and filters.

**Project.** Project Service, Project Controller, Project DB Entity, Project module.

**User.** User Service, User Controller, User DB Entity, User Module.

**Auth.** AppAuthGuard, Cookie Serializer/Deserializer, Http Strategy, Session Guard, Auth Service, Auth Module.

#### Creating User module

**Prerequisite: You must have @nest/cli installed globally**

###### Create User Module

```
nest g mo user
```

This should create a user directory and a user module inside it.

###### Create User Controller

```
nest g co user
```

This should place a user controller into a user directory and update user module.

###### Create User Service

```
nest g s user
```

This will create a user service and update the user module, however for me I think there is a **bug/feature**? The user service ends up being placed into root project folder instead of the user folder, make sure to move it manually into the user folder and update user module if it happens to you.

###### Create User Entity

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
    projects: ProjectEntity\[\];

    public static async findAll(): Promise<UserEntity\[\]> {
        const users: UserEntity\[\] = await UserEntity.find();
        if (users.length > 0) {
            return Promise.resolve(users);
        } else {
            throw new AppError(AppErrorTypeEnum.NO\_USERS\_IN_DB);
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

A few notes here on UserEntity. We will use a TypeScript **setter** to automatically hash the password when the password property is set. The file is using AppError and AppErrorTypeEnum, don’t worry we will create it in a bit. We are also going to set the following properties on the password_hash variable.:

* **select: false –** do not return this column when using find methods or running a query to select a user.
* **name: ‘password’ –** set the actual column name to be password, if this options is not set then TypeORM will autogenerate a column name from the variable name.

#### Create Project Module

Create the Project Module the same way that we used to create a **User Module.** Also create a Project Service and a Project Controller.

###### Create Project Entity

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

Now we need to tell TypeORM about these entities and we need to set the configuration options to let TypeORM connect to our sqlite db.

In AppModule add this:

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
  imports: \[
      TypeOrmModule.forRoot({
          type: 'sqlite',
          database: `${process.cwd()}/tutorial.sqlite`,
          entities: \[UserEntity, ProjectEntity\],
          synchronize: true,
          // logging: 'all'
      }),
      UserModule,
      ProjectModule,
  \],
  controllers: \[AppController\],
  providers: \[ AppService \],
})
export class AppModule {}
```

**logging** is commented out but you can read more about it [here](http://typeorm.io/#/logging).

**User Module** should look like this:

```typescript
import { Module } from '@nestjs/common';
import { UserController } from './user.controller';
import { UserService } from './user.service';
import {TypeOrmModule} from '@nestjs/typeorm';
import {UserEntity} from './user.entity';

@Module({
    imports: \[TypeOrmModule.forFeature(\[UserEntity\])\],
    controllers: \[UserController\],
    providers: \[UserService\]
})
export class UserModule {}
```

**Project Module** should look like this:

```typescript
import { Module } from '@nestjs/common';
import { ProjectController } from './project.controller';
import { ProjectService } from './project.service';
import {TypeOrmModule} from '@nestjs/typeorm';
import {ProjectEntity} from './project.entity';

@Module({
    imports: \[TypeOrmModule.forFeature(\[ProjectEntity\])\],
    controllers: \[ProjectController\],
    providers: \[ProjectService\]
})
export class ProjectModule {}
```

###### Setting up global exception handling

Under **src/** create ‘common’ directory and inside we will have two directories: error and filters. (Refer to project structure screenshot)

#### Error Directory

Create **AppErrorTypeEnum.ts**

```typescript
export const enum AppErrorTypeEnum {
    USER\_NOT\_FOUND,
    USER_EXISTS,
    NOT\_IN\_SESSION,
    NO\_USERS\_IN_DB
}
```

Here we will create a **const** enum, const enums do not generate objects but rather generate a  simple var->number relationship and if you do not need to find a string representation of your enum it is more performant to create an enum const.

Create **IErrorMessage.ts**

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

This will be the structure of the JSON that will be returned back to the user.

And finally, create **AppError.ts**

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
            case AppErrorTypeEnum.USER\_NOT\_FOUND:
                res = {
                    type: AppErrorTypeEnum.USER\_NOT\_FOUND,
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
            case AppErrorTypeEnum.NOT\_IN\_SESSION:
                res = {
                    type: AppErrorTypeEnum.NOT\_IN\_SESSION,
                    httpStatus: HttpStatus.UNAUTHORIZED,
                    errorMessage: 'No Session',
                    userMessage: 'Session Expired'
                };
                break;
            case AppErrorTypeEnum.NO\_USERS\_IN_DB:
                res = {
                    type: AppErrorTypeEnum.NO\_USERS\_IN_DB,
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

This will be the error that we throw anywhere within our code and the global exception handler will catch it and return an Object that conforms to the IErrorMessage structure.

#### Filters Directory

Create **DispatchError.ts**

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
            return res.status(HttpStatus.INTERNAL\_SERVER\_ERROR).send();
        }
    }

}
```

You can implement this class any way you like, this is just an example of things that you can do.

Now all we have to do is tell our app to use this filter, nothing is simpler. In our **main.ts** add this:

```typescript
app.useGlobalFilters(new DispatchError());
```

Now, your **main.ts** file should look like this:

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

#### Creating and fetching Users

Ok, now we are ready to add some logic to create users and fetch users. Let’s follow the Spring Boot style of services. Out user service will implement IUserService. Create **IUserService.ts** in user folder. Also we are going to need to define a model that will be coming in the request to create user. Create a **user/models/CreateUserDto.ts**

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

The purpose of this class is to essentially tell swagger what kind of data structure it should send.

And here is our **IUserService.ts**

```typescript
import {CreateUserDto} from './models/CreateUserDto';
import {UserEntity} from './user.entity';
import {ProjectEntity} from '../project/project.entity';

export interface IUserService {
    findAll(): Promise<UserEntity\[\]>;
    createUser(user: CreateUserDto): Promise<UserEntity>;
    getProjectsForUser(user: UserEntity): Promise<ProjectEntity\[\]>;
}
```

**user.service.ts**

```typescript
import { Injectable } from '@nestjs/common';
import {UserEntity} from './user.entity';
import {IUserService} from './IUserService';
import {CreateUserDto} from './models/CreateUserDto';
import {ProjectEntity} from '../project/project.entity';

@Injectable()
export class UserService implements IUserService{
    public async findAll(): Promise<UserEntity\[\]> {
        return await UserEntity.findAll();
    }

    public async createUser(user: CreateUserDto): Promise<UserEntity> {
       return await UserEntity.createUser(user);
    }

    public async getProjectsForUser(user: UserEntity): Promise<ProjectEntity\[\]> {
        return undefined;
    }
}
```

And finally: **user.controller.ts**

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
        const users: UserEntity\[\] = await this.usersService.findAll();
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

Beautiful thing about the controller is it just send the success result back to the user, we do not need to handle any errors as they are handled by the global exception handler.

Now let’s run our server by running either **npm run start** or **npm run start:dev** (this command will monitor your code for changes and restart the server each time you save). After the server has started, go to [http://localhost:3000/api/#/.](http://localhost:3000/api/#/)

If everything went well you should see swagger interface and a few endpoints. Explore the **tutorial.sqlite** with your favorite sqlite editor (firefox has sqlite extension) and confirm the schema. Experiment with running get all users when there are no users in db. It should return 404 and a JSON containing the userMessage, errorMessage etc (the message that we defined in our **AppError.ts**). Create a User and run get all users. If that all works then let’s proceed to create a **login** endpoint. If it does not, leave comments.

#### Implementing Authentication

Add to the end of **user.controller.ts**

```typescript
@Post('login')
@ApiOperation({title: 'Authenticate'})
@ApiBearerAuth()
public async login(@Req() req: Request, @Res() res: Response, @Session() session) {
    return res.status(HttpStatus.OK).send();
}
```

**@ApiBearerAuth()** annotation is for swagger to know that with this request we want to send basic auth in header. There is however, one more thing we must add to our **main.ts**

```typescript
const options = new DocumentBuilder()
        .setTitle('User Session Tutorial')
        .setDescription('Basic Auth and session management')
        .setVersion('1.0')
        .addTag('nestjs')
        .addBearerAuth('Authorization', 'header')
        .build();
```

Now, if we restart the server, we should see a little lock icon next to our api endpoint. It does not do anything yet, so let’s add some logic. Now at the time of writing this tutorial, in my opinion the documentation on how to do properly implement this is not complete, I followed this [NestJS Docs](https://docs.nestjs.com/techniques/authentication) to implement this and also I ran into the following [issue](https://github.com/nestjs/passport/issues/7). Nevertheless after poking around the [@nestjs/passport](https://github.com/nestjs/passport) lib I got it to work with the following:

Before we set up our auth logic we need to add the following to **main.ts**

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

#### Create Auth Module

Run **nest g mo auth** and **nest g s auth,** this will create **auth** directory with auth module in it, once again move auth.service to auth directory if it created it outside. Now the NestJS documentation says to use **@UseGuards(AuthGuard(‘bearer’))** but because of above mentioned issue I implemented my own AuthGuard which loges the user in. And we will also need to implement a PassportStrategy. Create **src/auth/AppAuthGuard.ts**

```typescript
import {CanActivate, ExecutionContext, UnauthorizedException} from '@nestjs/common';
import * as passport from 'passport';

export class AppAuthGuard implements CanActivate {
    async canActivate(context: ExecutionContext): Promise<boolean> {
        const options = { ...defaultOptions };
        const httpContext = context.switchToHttp();
        const \[request, response\] = \[
            httpContext.getRequest(),
            httpContext.getResponse()
        \];
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

Create **src/auth/http.strategy.ts**

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

* **token** – a token we are going to receive in the hearer in the following format **“Bearer base64encode(‘somestring’)”.**
* **done(null, {user: test})** – store object in the second argument in the session. For now we just store a fake object, later we will retrieve the user from db and store it in the session

Update **AuthModule.ts**

```typescript
import { Module } from '@nestjs/common';
import { AuthService } from './auth.service';
import {HttpStrategy} from './http.strategy';
import {AppAuthGuard} from './AppAuthGuard';

@Module({
  providers: \[AuthService, HttpStrategy, AppAuthGuard\]
})
export class AuthModule {}
```

Now let’s run our server.

The way to test it is to go to swagger api in the browser, click on the lock icon and enter ‘**Bearer test**‘ and click Authorize. Then open **Chrome Dev Tools** and go to tab **Application** and on the left side pane click **Cookies->http://localhost:3000.** Now execute **POST /login**. We are expecting to see a cookie with the name ‘**sess-tutorial**‘. But we don’t see anything. What’s wrong? If we look at the [passport documentation](https://github.com/jaredhanson/passport). We see that we need to add the following to the passport.

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

Turns out that **@nestjs/passport** has an abstract class **PassportSerializer.** Why an abstract class? Hmm, let’s try to extend it and make it an **@Injectable()** and then provide it in our **auth.module.ts.**

Create **src/auth/cookie-serializer.ts**

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
  providers: \[AuthService, HttpStrategy, AppAuthGuard, CookieSerializer\]
})
export class AuthModule {}
```

Now, let’s run our server and execute **POST /login** with Basic Auth Header, now we should see a cookie in Chrome Dev Tools. A little guessing, but very easy to figure out by reading the actual express documentation and reading the @nestjs/passport docs.

Time to add logic to authenticate the user against the record in the database and protect routes which should be only accessed if the user is logged in.

Add the following function to **UserEntity.ts**

```typescript
public static async authenticateUser(user: {username: string, password: string}): Promise<UserEntity> {
        let u: UserEntity;
        u = await UserEntity.findOne({
            select: \['id', 'username', 'password_hash'\],
            where: { username: user.username}
        });
        const passHash = crypto.createHmac('sha256', user.password).digest('hex');
        if (u.password_hash === passHash) {
            delete u.password_hash;
            return  u;
        }
    }
```

and to **AuthService.ts**.

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

and let’s modify our **http.strategy.ts**

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

Now test it in swagger by going to this free online [base64encoder](https://www.base64encode.org/). And encode the following string:

```typescript
{
  "username" : "johnny",
  "password": "1234"
}
```

Now back in swagger enter **‘Bearer ew0KICAidXNlcm5hbWUiIDogImpvaG5ueSIsDQogICJwYXNzd29yZCI6ICIxMjM0Ig0KfQ==’.** The string after bearer is the encode json string, it will be decoded and compared in **authenticateUser** function in the **UserEntity.ts**. And now do a **POST /login**, you should see a cookie appear in chrome dev tools (provided you have the user with username ‘jonny’ and password ‘1234’ in the database).

Let’s create a route which will be used to create a project for the currently logged in user, however before we do that we need a “Session Guard” which will protect our route and throw an AppError if the user is not in session.

###### Protecting Routes From Unauthorized Access

Create **src/auth/SessionGuard.ts**

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
            throw new AppError(AppErrorTypeEnum.NOT\_IN\_SESSION);
        }

    }
}
```

And we will need a convenient way of retrieving user object from the session. So instead of doing **req.session.passport.user**. Create **src/user/user.decorator.ts:**

import {createParamDecorator} from '@nestjs/common';

```typescript
export const SessionUser = createParamDecorator((data, req) => {
    return req.session.passport.user;
})
```

Now let’s add a function to **ProjectEntity** to create projects for a given user.

```typescript
public static async createProjects(projects: CreateProjectDto\[\], user: UserEntity): Promise<ProjectEntity\[\]> {
       const u: UserEntity = await UserEntity.findOne(user.id);
       if (!u) throw new AppError(AppErrorTypeEnum.USER\_NOT\_FOUND);
       const projectEntities: ProjectEntity\[\] = \[\];
       projects.forEach((p: CreateProjectDto) => {
           const pr: ProjectEntity = new ProjectEntity();
           pr.name = p.name;
           pr.description = p.description;
           projectEntities.push(pr);
       });
       u.projects = projectEntities;
       const result: ProjectEntity\[\] = await ProjectEntity.save(projectEntities);
       await UserEntity.save(\[u\]);
       return Promise.all(result);
   }
```

To **ProjectService** we will add:

```typescript
public async createProject(projects: CreateProjectDto\[\], user: UserEntity): Promise<ProjectEntity\[\]> {
       return ProjectEntity.createProjects(projects, user);
}
```

And let’s put it all together in **ProjectController**:

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
    public async createProject(@Body() createProjects: CreateProjectDto\[\], @Res() res, @SessionUser() user: UserEntity) {
        const projects: ProjectEntity\[\] = await this.projectService.createProject(createProjects, user);
        return res.status(HttpStatus.OK).send(projects);
    }

}
```

* **@UseGuards(SessionGuard)** – if the user is not in session, return predefined JSON in AppError in the response.
* **@SessionUser()** – our custom decorator allows us to easily grab the **UserEntity** object form the session. (It’s not really necessary to store a whole object, we can store user id by modifying our CookieSerializer class)

In Swagger, try to create a project without being authenticated and after logging in. You must send an array of projects. (Please note, session will be lost after a server restart). You can also delete a cookie by selecting in the Chrome Dev Tools.

Now let’s add get projects for user functionality.

###### Get Projects for Authenticated User

In **ProjectEntity** add:

```typescript
public static async getProjects(user: UserEntity): Promise<ProjectEntity\[\]> {
        const u: UserEntity = await UserEntity.findOne(user.id, { relations: \['projects'\]});
        if (!u) throw new AppError(AppErrorTypeEnum.USER\_NOT\_FOUND);
        return Promise.all(u.projects);
    }
```

And in **ProjectService** add:

```typescript
public async getProjectsForUser(user: UserEntity): Promise<ProjectEntity\[\]> {
        return ProjectEntity.getProjects(user);
    }
```

And in **ProjectController** add:

```typescript
@Get('')
@UseGuards(SessionGuard)
@ApiOperation({title: 'Get Projects for User'})
public async getProjects(@Res() res, @SessionUser() user: UserEntity) {
    const projects: ProjectEntity\[\] = await this.projectService.getProjectsForUser(user);
    return res.status(HttpStatus.OK).send(projects);
}
```

And that’s about it.

You can check out the finished source code [here](https://github.com/artonio/nestjs-session-tutorial-finished).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
